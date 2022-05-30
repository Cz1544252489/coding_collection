    module variable
    implicit none 
    integer,parameter :: n=5
    end module variable  
    
    module typedef
    use variable
    implicit none 
    type :: datalink
        integer :: count
        real :: X(n,n),xi(n,n),yita(n,n),t
        type(datalink),pointer :: prev
        type(datalink),pointer :: next
    end type datalink
    end module typedef
    
    program main
    use typedef
    implicit none 
    type(datalink),target :: BOXm,BOX,BOXp 
    type(datalink),pointer :: p
    integer :: i,j,k,err,flag
    real :: X(n,n),xi(n,n),yita(n,n),t,zero(n,n)
    forall(i=1:n,j=1:n) zero(i,j)=0
    !datalink的输入变量分别为:count,X,xi,yita,t,prev,next
    !BOXm指BOX_minus 前一个盒子
    BOXm=datalink(0,zero,zero,zero,0,BOXp,BOX)
    !BOX指           当前的盒子
    BOX=datalink(1,zero,zero,zero,0,BOXm,BOXp)
    !BOXp指BOX_plus 后一个盒子
    BOXp=datalink(2,zero,zero,zero,0,BOX,BOXm)
    
    !迭代计数器
    flag=0
    p=>BOX
    do while(flag<10)
        !赋值区域
        forall(i=1:n,j=1:n) p%X(i,j)=1.0*i+1.0*j+p%count
        forall(i=1:n,j=1:n) p%xi(i,j)=1.0*i-1.0*j+p%count
        
        !输出区域        
        write(*,*) 'count=',p%count
        write(*,*) 'X='
        write(*,"(5F8.3)") p%X
        write(*,*) 'xi='
        write(*,"(5F8.3)") p%xi
        
        
        !更新区域
        p%count=p%prev%count+1   !每个计数器count再前一个的基础上加一
        p=>p%next                !指针指向下一个盒子
        flag=flag+1              !迭代计数器加一
    end do
    stop
    end program main
