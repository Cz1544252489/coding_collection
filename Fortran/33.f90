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
    integer,parameter :: n=20
    integer,parameter :: k=3
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
    
    real,dimension(n,n) :: Omega,M0,A,X,S(n),U,V
    

    
    !A和Omega的生成
    !call rand_new(n,k,M0)   !生成随机矩阵
    call random_number(M0)
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
            A(i,j)=M0(i,j)*Omega(i,j)!A=M.*Omega
            A(j,i)=M0(i,j)*Omega(i,j)
        end do
    end do
    do i=1,n
        Omega(i,i)=0
        A(i,i)=0
        M0(i,i)=0
    end do
    
    !设置初始值
    call random_number(X)
    call lin_svd(X,S,U,V)
    
    
    
    
    
    
    
    !输出区域
    open(103,file='C:\Users\Administrator\Desktop\data1.txt',position='append')
    
    
    write(103,600) transpose(A)
    
    write(103,*)  '   '
    
    !write(103,600) transpose(M0)
    
    close(103)
600 format((20F10.2))    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
