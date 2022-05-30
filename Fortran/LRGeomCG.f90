!****************************************************************************
!
!  PROGRAM: LRGeomCG
!
!   PURPOSE:  use LRGeomCG algorithm to solve LRMC problem.
!    
!   Record of revisions:
!      Date         Programmer      Description of change
!   ========        ==========      =====================
!   2021.5.22            陈卓              Original code
!
!****************************************************************************

    
    module variable0
    implicit none
    integer,parameter :: n=200
    integer,parameter :: k=20
    real :: tau=1e-3     !终止条件参数
    real :: p0=3.0*k*(2*n-k)/n**2       !观察值占比
    !real :: p0=0.1
    integer :: max_iter=200
    integer :: i,j
    end module variable0
    
    module variable1
    use variable0
    implicit none
    real :: Omega(n,n),A(n,n)
    common Omega,A
    
    end module variable1
    
    module variable2
    use variable0
    implicit none
    real,dimension(n,n) :: eye
    real,dimension(n,k) :: U,V
    real,dimension(k) :: S
    end module variable2
    
    module variable3
    use variable0
    implicit none
    real,dimension(n,n) :: TU,TV
    real,dimension(n) :: TS
    end module variable3
    
    module variable4
    use variable0
    implicit none
    integer :: flag,im
    real :: fXtemp,rtemp0,rtemp1,beta
    end module variable4
    

    
    module typedef
    use variable0
    implicit none
    type :: datalink
        integer :: count
        real :: X(n,n),fX,xi(n,n),yita(n,n),t,alpha,rr
        type(datalink),pointer :: prev
        type(datalink),pointer :: next
    end type datalink
    end module typedef
    

    
    
    Module ran_mod
    Implicit None
    ! ran return a uniform random number between 0-1  
    ! norma return a normal distribution  
    contains 
    function ran()   !returns random number between 0 - 1  
    implicit none 
    integer , save :: flag = 0
    double precision :: ran 
    if(flag==0) then 
      call random_seed()
      flag = 1 
    endif 
    call random_number(ran)     ! built in fortran 90 random number function  
    end function ran
  
    function normal(mean,sigma) 
    implicit none 
    integer :: flag 
    double precision, parameter :: pi = 3.141592653589793239  
    double precision :: u1, u2, y1, y2, normal, mean, sigma 
    save flag 
    data flag /0/ 
    u1 = ran(); u2 = ran()
    if (flag.eq.0) then 
      y1 = sqrt(-2.0d0*log(u1))*cos(2.0d0*pi*u2) 
      normal = mean + sigma*y1 
      flag = 1 
    else 
      y2 = sqrt(-2.0d0*log(u1))*sin(2.0d0*pi*u2) 
      normal = mean + sigma*y2 
      flag = 0 
    endif  
    end function normal 

    End Module ran_mod
    
    
    

    
    
    
    program main
    include 'link_fnl_shared.h'
    use typedef
    use variable1
    use variable2
    use variable4
    use lin_svd_int  !svd
    implicit none
    interface 
        function T_XtoXp(X,xi)
            use variable0
            implicit none
            real,dimension(n,n) :: X,xi,T_XtoXp
        end function T_XtoXp
        function grad_f(X)
            use variable0
            implicit none
            real,dimension(n,n) :: X,grad_f
        end function grad_f
    end interface
    type(datalink),target :: BOXm,BOX,BOXp,tBOX
    type(datalink),pointer :: p
    
    real,dimension(k,k) :: Sigma
    real,dimension(n,n) :: M0,zero
    real,dimension(k) :: tempSigma
    
    real,external :: normF,trace,f
    
    integer :: IHOUR0, IMIN0, ISEC0,IHOUR1, IMIN1, ISEC1
    
    CALL TIMDY (IHOUR0, IMIN0, ISEC0)
    !A和Omega的生成
    call rand_new(n,k,M0)   !生成随机矩阵
    call random_seed()
    !生成随机指标集
    call random_number(Omega)
    forall(i=1:n,j=1:n,Omega(i,j)>1-p0) Omega(i,j)=1
    forall(i=1:n,j=1:n,Omega(i,j)<=1-p0) Omega(i,j)=0

    forall(i=1:n,j=1:n) A(i,j)=M0(i,j)*Omega(i,j)!A=M.*Omega

    
    !open(100,file='F:\data\M.txt')
    !write(100,600) transpose(M0)
    !close(100)
    
    
    
    zero=0.0
    eye=0.0
    forall(i=1:n) eye(i,i)=1.0
    !datalink的输入变量分别为:count,X,fX,xi,yita,t,alpha,rr,prev,next
    !BOXm指BOX_minus 前一个盒子
    call rand_new(n,k,tBOX%X)
    BOXm=datalink(0,tBOX%X,0,zero,zero,0,0,0,BOXp,BOX)
    
    !BOX指           当前的盒子
    call rand_new(n,k,tBOX%X)
    BOX=datalink(1,tBOX%X,0,zero,zero,0,0,0,BOXm,BOXp)
    
    !BOXp指BOX_plus 后一个盒子
    BOXp=datalink(2,zero,0,zero,zero,0,0,0,BOX,BOXm)
    
    !迭代开始
    p=>BOXm
    do while(p%count<max_iter)
        !赋值运算区域
        p%fX=f(p%X)
        p%xi=grad_f(p%X)       !计算梯度
        
        if(normF(p%xi)<=tau) then
            exit 
        end if
        !计算当前共轭方向
        !call direction(p%prev%X,p%prev%yita,p%X,p%yita)
        beta=trace(matmul(transpose(p%xi-T_XtoXp(p%X,p%prev%xi)),p%xi))
        beta=beta/trace(matmul(transpose(p%xi),p%xi))
        beta=max(0.0,beta)
        p%yita=-p%xi+beta*T_XtoXp(p%X,p%prev%yita)
        !p%yita=-p%xi
        
        p%alpha=trace(matmul(transpose(-p%yita),p%xi))
        p%alpha=p%alpha/sqrt(trace(matmul(transpose(p%yita),p%yita))*trace(matmul(transpose(p%xi),p%xi)))
        if(p%alpha<0.1) p%yita=-p%xi
        
        !计算初始步长
        !call ini_step(p%X,p%yita,p%t)
        call mysvd(p%X,S,U,V)
        M0=matmul(matmul(U,transpose(U)),matmul(p%yita,matmul(V,transpose(V))))
        M0=M0+matmul(eye-matmul(U,transpose(U)),matmul(p%yita,matmul(V,transpose(V))))
        M0=M0+matmul(matmul(U,transpose(U)),matmul(p%yita,eye-matmul(V,transpose(V))))
        
        p%t=trace(matmul(transpose(Omega*M0),Omega*A-Omega*p%X))
        p%t=p%t/trace(matmul(transpose(Omega*M0),Omega*M0))
        
        !Armijo步长
        im=0
        do while(.true.)
            
            !拉回映射
            !call retraction(p%X,p%xi,mtemp2)
            call mysvd(p%X+p%xi,tempSigma,U,V)
            Sigma=0.0
            forall(i=1:k) Sigma(i,i)=tempSigma(i)
            M0=matmul(U,matmul(Sigma,transpose(V)))
            
            !结束
            
            if(f(p%X)-f(M0)+0.0001*0.5**im*p%t*trace(matmul(p%xi,transpose(p%yita)))>=0) then
                exit
            else
                im=im+1
            end if
            if(im>20) then
                exit
            end if  
        end do
        if(im<=20) then 
            p%next%X=M0
        end if
        p%rr=normF(Omega*(p%X-A))
        p%rr=p%rr/normF(Omega*A)
        
        !输出区域        
        write(*,*) 'count=',p%count
        if(im>1)then
            write(*,*) 'im=',im
        end if
        write(*,*) 'fX=',p%fX
        write(*,*) 'normF(xi)=',normF(p%xi)
        write(*,*) 'rr=',p%rr
        write(*,*) '        '
        
        !更新区域
        p%count=p%prev%count+1   !每个计数器count再前一个的基础上加一
        p=>p%next                !指针指向下一个盒子
    end do
    

        
        CALL TIMDY (IHOUR1, IMIN1, ISEC1)
        
        open(99,file='C:\Users\Administrator\Desktop\data.txt',position='append')
        WRITE (99,*) 'Start:Hour:Minute:Second = ', IHOUR0, ':', IMIN0,  ':', ISEC0
        WRITE (99,*) 'End:Hour:Minute:Second = ', IHOUR1, ':', IMIN1,  ':', ISEC1
        write(99,*) 'n=',n,'    k=',k
        write(99,*) 'tau=',tau,'    p0=',p0
        if(p%count>max_iter-3) then  
            write(99,*) 'over max_iter!'
        else 
            write(99,*) 'iterate',p%count,'times!'
        end if
        write(99,*) 'time cost: ',(IHOUR1-IHOUR0)*3600+(IMIN1-IMIN0)*60+ISEC1-ISEC0,'  s'
        write(99,*) '    '
        close(99)
        
600 format((100F10.5))
        !open(99,file='F:\data\X.txt')
        !write(99,600) transpose(p%next%X)
        !close(99)
    stop
    end program main
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    


    
  subroutine rand_new(n,k,X)
    use ran_mod
    implicit none
    
    integer,intent(in) :: n,k
    integer :: i,j
    real,dimension(n,k) :: X_L,X_R
    real,dimension(n,n),intent(out) :: X
    do j=1,k
      do i=1,n
        X_L(i,j)=normal(0.0D0,1.0D0)
        X_R(i,j)=normal(0.0D0,1.0D0)
      end do
    end do
    X=matmul(X_L,transpose(X_R))
    end subroutine rand_new 
    

    
    function f(X)
    use variable1
    implicit none
    real,dimension(n,n) :: X
    real,external :: trace
    real :: f
    f=0.5*trace(matmul((X-A)*Omega,transpose((X-A)*Omega)))
    return
    
    end function f
    
    function grad_f(X)
    !计算梯度，来自原文算法2
    use variable1
    use variable2
    use variable3
    implicit none
    real,dimension(n,n) :: X,grad_f

    call mysvd(X,S,U,V)
    eye=0.0
    forall(i=1:n) eye(i,i)=1.0
    TU=matmul(U,transpose(U))
    TV=matmul(V,transpose(V))
    grad_f=matmul(TU,matmul(A*Omega-X*Omega,TV))
    grad_f=grad_f+matmul((eye-TU),matmul(A*Omega-X*Omega,TV))
    grad_f=grad_f+matmul((TU),matmul(A*Omega-X*Omega,eye-TV))

    end function grad_f
    
    subroutine mysvd(X,S,U,V)
    use variable3
    use lin_svd_int
    implicit none 
    real,dimension(n,n),intent(in) :: X
    real,dimension(n,k),intent(out) :: U,V
    real,dimension(k),intent(out) :: S
    
    call lin_svd(X,TS,TU,TV)
    S=TS(1:k)
    U=TU(:,1:k)
    V=TV(:,1:k) 
    end subroutine mysvd
    
    function trace(X)
    use variable0
    implicit none
    real,dimension(n,n) :: X 
    real :: trace
    trace=0.0
    do i=1,n
        trace=trace+X(i,i)
    end do
    return
    end function trace
    
    
    
    function normF(X)
    use variable0
    implicit none
    real :: normF
    real,dimension(n,n) :: X
    real,external :: trace
    
    normF=sqrt(trace(matmul(X,transpose(X))))
    return
    end function normF
    
    
    function delta(i,j)
    implicit none
    integer :: i,j
    real :: delta
    if(i==j) then
        delta=1.
    else
        delta=0.
    end if 
    end function delta
    
    
    function T_XtoXp(X,xi)
    !计算向量转移/vector transport，来自原文算法3
    use variable2
    use variable3
    implicit none
    real,dimension(n,n):: X,xi,T_XtoXp
    
    call mysvd(X,S,U,V)
    !首先求出核心矩阵M
    eye=0.0
    forall(i=1:n) eye(i,i)=0.0
    
    TU=matmul(U,transpose(U))
    TV=matmul(V,transpose(V))
    
    T_XtoXp=matmul(TU,matmul(xi,TV))
    T_XtoXp=T_XtoXp+matmul(eye-TU,matmul(xi,TV))
    T_XtoXp=T_XtoXp+matmul(TU,matmul(xi,eye-TV))
    end function T_XtoXp
    

    
 