!
!   PURPOSE:  by full-rank factorizaion method RGD algorithm to solve LRMC problem.
!    
!   Record of revisions:
!      Date         Programmer      Description of change
!   ========        ==========      =====================
!   2021.7.5            陈卓              Original code
!
!****************************************************************************
    
    
    module variable0
    implicit none
    integer,parameter :: n=200
    integer,parameter :: k=5
    real :: tau=1e-3     !终止条件参数
    !real :: p0=3.0*k*(2*n-k)/n**2       !观察值占比
    real :: p0=0.5
    integer :: max_iter=200
    integer :: i,j
    end module variable0
    
    
    
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
    use variable0
    use lin_svd_int
    !use ran_mod
    implicit none
    
    real,dimension(n,n) :: Omega,Mstar,M0,X,S(n),U,V,Lr,Lc,mtempS
    real,dimension(n,k) :: mtemp0,mtemp1,G0,H0
    real,dimension(k,k) :: diagS
    real,dimension(n,2*k) :: gradf
    
    real :: vtemp0(n),r
    
    !A和Omega的生成
    !call rand_new(n,k,M0)   !生成随机矩阵
    call random_number(Mstar)
    call random_seed()
    !生成随机指标集
    call random_number(Omega)
    do i=1,n
        do j=1,n
            if(Omega(i,j)>1-p0)then
                Omega(i,j)=1
                Omega(j,i)=1
            else
                Omega(i,j)=0
                Omega(j,i)=0
            end if
        end do
    end do
    M0=Mstar*Omega!M0=Mstar.*Omega
    do i=1,n
        Omega(i,i)=0
        M0(i,i)=0
        Mstar(i,i)=0
    end do
    
    !设置初始值，满秩分解
    call random_number(mtemp0)
    !call random_number(mtemp1)
    !X=matmul(mtemp0,transpose(mtemp0))
    !iopt(1)=c_options(,lin_svd_set_small,10**(-5))
    call lin_svd(M0,S,U,V)
    
    diagS=0
    forall(i=1:k) diagS(i,i)=S(i)
    
    G0=matmul(U(:,1:k),sqrt(diagS))
    H0=matmul(V(:,1:k),sqrt(diagS))
    
    !求M0的L矩阵
    Lr=-M0;
    vtemp0=sum(M0,1)
    forall(i=1:n) Lr(i,i)=Lr(i,i)+vtemp0(i)
    
    Lc=-M0;
    vtemp0=sum(M0,2)
    forall(i=1:n) Lc(i,i)=Lc(i,i)+vtemp0(i)
    
    
    !求梯度
    mtempS=Omega*(matmul(G0,transpose(H0))-Mstar)
    gradf(1:n,1:k)=matmul(mtempS,H0)
    gradf(1:n,k+1:2*k)=matmul(transpose(mtempS),G0)
    call norm(gradf,r)
    
    
    
    
    
    !输出区域
    !open(103,file='C:\Users\Administrator\Desktop\data1.txt',position='append')
    open(103,file='C:\Users\Administrator\Desktop\data1.txt')
    
    
    !write(103,600) transpose(U)
    
    write(103,*)  '   '
    
    !write(103,600) transpose(V)
    
    write(103,*)  '   '
    
    !write(103,600) transpose(M0)
    
    write(103,*)  '   '
    
    write(103,*)  r
    
    close(103)
600 format((20F10.5)) 
601 format((5F10.2))
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    end program main
    
    


    
    
    subroutine norm(gradf,r)
    use variable0
    implicit none
    
    real,dimension(n,2*k),intent(in) :: gradf
    real,intent(out) :: r
    
    real,dimension(n,n) :: mtemp,vtemp(n)
    
    mtemp=matmul(gradf,transpose(gradf))
    forall(i=1:n) vtemp(i)=mtemp(i,i)
    
    r=sqrt(sum(vtemp))
    
    
    end subroutine norm