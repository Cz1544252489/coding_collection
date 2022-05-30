program main
    implicit none
    
    integer,parameter :: n=4000
    real,parameter :: p=0.1
    integer :: i,j,k,visit0,start,level       !level表示层级，即到根节点的最短距离
    integer :: kaver=4
    integer :: degree(n),edge(n,n),length(n,n),temp(n,n)
    real :: rand,averlen
    integer :: count,count0,count1,count2,flag
    
    integer,pointer :: Q=>null()   !队列
    integer,target :: visit(n)   !已经扫描过的点
    
    open(7,file="length.txt")
    open(666,file="temp.txt")
    
    do i=1,n
        degree(i)=0
        do j=1,n
            edge(i,j)=0
            edge(i,j)=0
            length(i,j)=0
            length(j,i)=0
       enddo
    enddo
    call random_seed()
    do i=1,n-1
        do j=i+1,n
            call random_number(rand)
            if(rand<p) then
                edge(j,i)=1
                edge(i,j)=1
                degree(i)=degree(i)+1
                degree(j)=degree(j)+1
            endif
        enddo
    enddo
    
    !利用BFS算法求最短路长
    do start=1,n        !起始点
        do i=1,n
            visit(i)=0
        enddo
        level=1                     !层数及该点到起始点的最短距离                   
        visit(1)=start
        visit0=2
        Q=>visit(1)                 !指针指向起始点
            count=1
            do i=1,n           
                flag=0                  !接下来4行保证不会选到重复的点 
                do j=1,visit0       
                    if(i==visit(j)) flag=1
                enddo
                if(edge(i,Q)==1 .and. flag==0)then
                    visit(visit0)=i     !visit的计数器为visit0
                    length(i,start)=level
                    length(start,i)=level
                    count=count+1       
                    visit0=visit0+1
                endif
            enddo                       !最后的count的值就是此层的长度
        do while(.true.)     !当visit中元素超过n时跳出循环
            level=level+1
           do count1=visit0-count+1,visit0                    !某一层的起点
                Q=>visit(count1)
                do i=1,n
                    flag=0                  !接下来4行保证不会选到重复的点 
                    do j=1,visit0       
                        if(i==visit(j)) flag=1
                    enddo
                    if(edge(i,Q)==1 .and. flag==0)then
                        visit(visit0)=i     !visit的计数器为visit0
                        length(i,start)=level
                        length(start,i)=level
                        count=count+1       
                        visit0=visit0+1
                    endif
            if(visit0>n)exit
                enddo
            if(visit0>n)exit
           enddo
            if(visit0>n)exit
        enddo
    !do k=1,n
    !    do i=1,n
    !        if(length(i,k)<n .and. i/=k) then       !点i到k的距离小于n则更新距离
    !            do j=1,n
    !                if(length(k,j)<n .and. k/=j .and. j/=i)then
    !                    if(length(i,k)+length(k,j)<length(i,j))then     !有更短的路径时更新
    !                        length(i,j)=length(i,k)+length(k,j)
    !                    endif
    !                endif
    !            enddo
    !        endif
    !    enddo
    !enddo
    !do i=1,n
    !    do j=1,n
    !        if(length(j,i)==kaver)then
    !            temp(j,i)=1
    !        endif
    !    enddo
    !enddo
    enddo
    averlen=1.0*sum(length)/n/(n-1)
    write(666,*) p,n,averlen
    do j=1,n
        do i=1,n
            write(7,*)length(i,j)
        enddo
    enddo
end