    program main
    
    
    call svd()
    
    !call te()

    end program main
    
    
    
    subroutine svd()
    include 'link_fnl_shared.h'
    implicit none
    integer,parameter :: m=10,n=10,k=5!È¡m<=n£¬·ñÔò½»»»m,n
    real,dimension(m,n) :: A,X
    real,dimension(m,k) :: U
    real,dimension(n,k) :: V
    real,dimension(k,k) :: Sigma
    
    real,dimension(m,1) :: w1,vtemp,e
    real,dimension(1,n) :: u1,utemp,e0
    
    real,dimension(m,m) :: H,I,Ub
    real,dimension(n,n) :: L,J,Vb
    
    
    real,dimension(1,1) :: temp,temp1
    
    integer :: i1,j1
    
    integer :: IHOUR0, IMIN0, ISEC0,IHOUR1, IMIN1, ISEC1
    
    
    CALL TIMDY (IHOUR0, IMIN0, ISEC0)
    call random_seed()
    call random_number(A)
    
    X=A
    
    
    Ub=0
    Vb=0
    forall(i1=1:m) Ub(i1,i1)=1
    forall(i1=1:n) Vb(i1,i1)=1
    
    I=0.0
    forall(i1=1:m) I(i1,i1)=1
    J=0.0
    forall(i1=1:n) J(i1,i1)=1
    
    do j1=1,min(m,n)
        
        if(j1<=m-1)then
            vtemp=0.0
            vtemp(j1:m,1:1)=X(j1:m,j1:j1)
            temp=sqrt(matmul(transpose(vtemp),vtemp))
            e=0.0
            e(j1,1)=1
            w1=vtemp-temp(1,1)*e
            temp1=sqrt(matmul(transpose(w1),w1))
            w1=w1/temp1(1,1)
            H=I-2*matmul(w1,transpose(w1))
            X=matmul(H,X)
            Ub=matmul(Ub,H)
        end if
            
        if(j1<=n-1)then
            utemp=0.0
            utemp(1:1,j1+1:n)=X(j1:j1,j1+1:n)
            temp=sqrt(matmul(utemp,transpose(utemp)))
            e0=0.0
            e0(1,j1+1)=1
            u1=utemp-temp(1,1)*e0
            temp1=sqrt(matmul(u1,transpose(u1)))
            u1=u1/temp1(1,1)
            L=J-2*matmul(transpose(u1),u1)
            X=matmul(X,L)
            Vb=matmul(Vb,L)
        end if
        
    end do
    
    CALL TIMDY (IHOUR1, IMIN1, ISEC1)

    write(*,*) 'time cost: ',(IHOUR1-IHOUR0)*3600+(IMIN1-IMIN0)*60+ISEC1-ISEC0,'  s'
    write(*,*) '    '
    write(*,*) sum(abs(matmul(Ub,matmul(X,transpose(Vb)))-A))
    write(*,998) X

999 format(5F8.4)  
998 format(10F8.4)  
    
    end subroutine svd
    
    
    
    
    subroutine te()
    
    integer :: A(3,3)
    data A / 1,1,1, 2,2,2 ,4,4,4/
    
    
    write(*,998) transpose(A)
    write(*,998) matmul(A(1:3,2:2),transpose(A(1:3,2:2)))

998 format(3I5)  
    
    end subroutine te
    
   !subroutine house(input,length,v,beta)
    
    
    
    
    
    !end subroutine house
    
