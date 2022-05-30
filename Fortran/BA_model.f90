program main 
    implicit none
    integer,parameter :: n=200
    integer :: edge(n,n),degree(n),state(n),sum_(n)
    integer :: i,j,m,count1,count2
    integer :: idum,m0  !种子idum
    real :: f,rand
    
    !初始化
    do i=1,m
        if(i<m)then
            degree(i)=2
            edge(i,i+1)=1
            edge(i+1,i)=1
        else
            degree(i)=2
            edge(i,1)=1
            edge(1,i)=1
        endif
    enddo
    
    !演化
    idum=10
    call random_seed(idum)
    do i=m+1,n
        degree(i)=m0
        do j=1,i-1
            state(j)=0
        enddo
        do j=1,i
            sum_(j)=0
        enddo
        count1=0
        do j=1,i-1
            count1=count1+degree(i)
            sum_(j+1)=count1
        enddo
        count2=0  !记录连边数
        call random_number(rand)
100     f=rand*count1
        do j=1,i-1
            if(sum_(j)<f .and. f<sum_(j+1)) then
                if(state(j)==0)then
                    edge(i,j)=1
                    edge(j,i)=1
                    count2=count2+1
                    state(j)=1
                else
                    goto 100
                endif 
            endif
        enddo
    if(count2<m0)  goto 100
    do j=1,i-1
        if(state(j)==1)then
            degree(j)=degree(j)+1
        endif
    enddo
end program