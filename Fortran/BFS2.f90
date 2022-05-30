module typedef
    implicit none
    type :: node
        integer :: distance, ID !距离是指从node%prev到node的距离
        logical :: is_last
        type(node), pointer :: prev
        type(node), pointer :: next
    end type node
end module typedef
  
!subroutine add_to_last(i, p, last)
!    implicit none
!    use typedef
!    type(node),pointer :: p, q, last
!    integer :: i
!    
!    allocate(q)
!    if(p%ID/=1) then
!        last%next=>q
!        q%prev=>last
!    else
!        q=node(0,1,.false.,null(),null())
!    end if 
!    return
!    end subroutine
    
!subroutine del_from_first()
!    implicit none
!    use typedef
!    type(node),pointer ::q
!
!    
!end subroutine

program main
    use typedef
    implicit none
    character(len=30) filename
    type(node), pointer :: p, q, head, last
    integer :: i, error, n
    integer :: adjmatrix(9,9)!,allocatable
    logical :: h
    
    filename='adjmatrix.txt'
    open(10,file=filename,status="old",iostat=error)
    if(error/=0) then
        write(*,*) "Open file fail!"
        stop
    end if 
    read(10,*) adjmatrix
    n=9
    !write(*,"(9I3.1)") adjmatrix
    allocate(head)
    head=node(0,1,.false.,null(),null())     !从第一个元素开始，后面队首会改变
    last=>head
    p=>head
    !先加入首元素的邻居

    do i=1,n            !遍历所有元素
       if(adjmatrix(p%ID,i)/=0) then!如果是邻居
            !if(last%prev/=null()) then
                p=node(adjmatrix(head%ID,i),i,.true.,null(),null())
                q=>last
                deallocate(last)
                q%next=>p               !把这个元素加入队尾
                p%prev=>q
                last=>q
        end if
    end do
    !write(*,*)adjmatrix(head%ID,2)
    p=>head
    do i=1,10
        write(*,*) p%ID
        p=>p%next
    end do
    
    
    !do while(.true.)
    !    if(associated(p) .and. associated(p)) then  !队首队尾至少要有一个有链接的
    !        if(p%is_last==.false.) then  !如果p不是最后一个
    !            write(*,*) head$ID      !程序执行部分
    !            head%next%prev=>null()    !先弹出第一个元素
    !            head=>head$next           !head指向它的下一个元素
    !            do i=1,nodenum            !遍历所有元素
    !              if(adjmatrix(p%ID,i)==1) then!如果是邻居
    !                q=node(adjmatrix(last%ID,i),i,.flase.,last,null())!把这个元素加入队尾
    !                last%next=>q
    !                last=>q
    !              end if
    !            end do
    !        else            
    !          write(*,*) "运行完成!"
    !          exit
    !        end if
    !    end if
    !end do
    stop
end program