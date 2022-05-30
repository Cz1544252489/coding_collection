program main
    implicit none
    integer,parameter :: n=1000
    real :: p=0.01
    integer,parameter :: k0=6 
    integer :: i,j,k,Newrand,visit0,start,level  !level表示层级，即到根节点的最短距离
    integer :: mark(n),degree(n),edge(n,n),neighbor(n),length(n,n),temp(n,n)
    integer :: kaver=4
    real :: cluster(n)
    real :: rand,averlen
    integer ::count,count0,count1,count2,flag
    
    integer,pointer :: Q=>null()   !队列
    integer,target :: visit(n)   !已经扫描过的点
    
    open(7,file="degree.txt")
    open(8,file="cluster.txt")
    open(9,file="length.txt")
    open(10,file="edge.xls")
    open(666,file="temp.txt")
        
    !生成WS模型
    do i=1,n
        do j=1,k0/2
            if(i+j<=n)then
                edge(i,i+j)=1
                edge(i+j,i)=1
                degree(i)=degree(i)+1
                degree(i+j)=degree(i+j)+1
            else
                edge(i,i+j-n)=1
                edge(i+j-n,i)=1
                degree(i)=degree(i)+1
                degree(i+j-n)=degree(i+j-n)+1
            endif
        enddo
    enddo
    call random_seed()
    do j=1,k0/2
        do i=1,n
            mark(i)=0                                                                                   
        enddo
        do i=1,n
            call random_number(rand)
            if(rand<p) mark(i)=1        !选择需要重连的边
        enddo
        do i=1,n
            if(mark(i)==1)then
100             call random_number(rand)
                Newrand=int(n*rand)+1       !重新选边并重连
                if(Newrand==i .or. edge(i,Newrand)==1) goto 100
                if(i+j<=n)then
                    edge(i,i+j)=0
                    edge(i+j,i)=0
                    degree(i+j)=degree(i+j)-1
                else
                    edge(i,i+j-n)=0
                    edge(i+j-n,i)=0
                    degree(i+j-n)=degree(i+j-n)-1
                endif
                edge(i,Newrand)=1
                edge(Newrand,i)=1
                degree(Newrand)=degree(Newrand)+1
            endif
        enddo
    enddo
    
    write(10,"(1000I)") edge
    !计算度分布
    !do i=1,n
    !    count=0
    !    do j=1,n
    !        if(degree(j)==i)then
    !            count=count+1
    !        endif
    !    enddo
    !    if(count/=0)then
    !        write(7,*) i,1.0*count/n
    !    endif
    !enddo
    
    !计算聚集系数
    do i=1,n
        cluster(i)=0
        neighbor(i)=0
    enddo
    do i=1,n
        count=1
        do j=1,n
            if(edge(i,j)==1)then
                neighbor(count)=j
                count=count+1
            endif
        enddo
        do j=1,count-1
            do k=j+1,count-1
                if(edge(neighbor(j),neighbor(k))==1)then
                    cluster(i)=cluster(i)+1
                endif
            enddo
        enddo
            cluster(i)=2*cluster(i)/degree(i)/(degree(i)-1)
    enddo
    write(8,*) p,sum(cluster)/n
    
    !利用BFS算法求最短路长
    !do start=1,n        !起始点
    !    do i=1,n
    !        visit(n)=0
    !    enddo
    !    level=1                     !层数及该点到起始点的最短距离                   
    !    visit(1)=start
    !    visit0=2
    !    Q=>visit(1)                 !指针指向起始点
    !        count=1
    !        do i=1,n           
    !            flag=0                  !接下来4行保证不会选到重复的点 
    !            do j=1,visit0       
    !                if(i==visit(j)) flag=1
    !            enddo
    !            if(edge(i,Q)==1 .and. flag==0)then
    !                visit(visit0)=i     !visit的计数器为visit0
    !                length(i,start)=level
    !                length(start,i)=level
    !                count=count+1       
    !                visit0=visit0+1
    !            endif
    !        enddo                       !最后的count的值就是此层的长度
    !    do while(.true.)     !当visit中元素超过n时跳出循环
    !        level=level+1
    !       do count1=visit0-count+1,visit0                    !某一层的起点
    !            Q=>visit(count1)
    !            do i=1,n
    !                flag=0                  !接下来4行保证不会选到重复的点 
    !                do j=1,visit0       
    !                    if(i==visit(j)) flag=1
    !                enddo
    !                if(edge(i,Q)==1 .and. flag==0)then
    !                    visit(visit0)=i     !visit的计数器为visit0
    !                    length(i,start)=level
    !                    length(start,i)=level
    !                    count=count+1       
    !                    visit0=visit0+1
    !                endif
    !        if(visit0>n)exit
    !            enddo
    !        if(visit0>n)exit
    !       enddo
    !        if(visit0>n)exit
    !    enddo
    !enddo
    !基本方法
    !do i=1,n-1
    !    do j=i+1,n
    !        if(edge(i,j)==1) then
    !            length(i,j)=1   !若有连边，则距离设置为1
    !            length(j,i)=1
    !        else
    !            length(i,j)=n   !否则设置为0
    !            length(j,i)=n
    !        end if
    !    end do
    !end do
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
    !do i=1,n
    !    do j=1,n
    !        write(9,*) length(j,i)
    !    enddo
    !enddo
    !averlen=1.0*sum(length)/n/(n-1)
    !write(666,*) p,n,averlen
end program                 