module linklist
    implicit none
    type student
        character(len=30) :: name
        integer :: Politics, English, Math1, Math2, FirstTest, LastTest
    end type
    
    type :: datalink
        type(student) :: item
        type(datalink),pointer :: next
    end type
    
    contains
    
    function SearchList(name, head)
        implicit none
        character(len=30) :: name
        type(datalink), pointer :: head, p
        type(datalink), pointer :: SearchList
        
        p=>head
        nullify(SearchList)
        do while(associated(p))
            if(p%item%name==name) then
                SearchList => p
                return
            end if
            p => p%next
        end do
        return
    end function
    
    end module linklist
    !根据姓名查询成绩
    program ex1016
        use linklist
        implicit none
        character(len=20) :: filename
        character(len=18) :: tempstr
        character(len=30) :: name
        type(datalink), pointer :: head
        type(datalink), pointer :: p
        integer :: i, error, size
        
        !write(*,*) "filename:"
        !read(*,*) filename
        filename="GradeList2.txt"
        open(10, file=filename, status="old", iostat=error)
        if(error/=0) then
            write(*,*) "Open file fail!"
            stop
        end if
        
        allocate(head)
        nullify(head%next)
        p=>head
        size=0
        read(10, "(A80)") tempstr 
        
        do while(.true.)
            read(10,fmt=*, iostat=error) p%item
            if(error/=0) exit
            size=size+1
            allocate(p%next, stat=error)
            if(error/=0) then
                write(*,*) "Out of memory!"
                stop
            end if
            p=>p%next
            nullify(p%next)
        end do
        write(*,"('总共有',I3,'位学生')") size
        
        do while(.true.)
            write(*,*) "要查询哪位同学的成绩？"
            read(*,*) name
            !if(i<1 .or. i>size) exit
            p=>SearchList(name,head)
            if(associated(p)) then
                write(*,"(6(A12,I3))")"政治成绩",p%item%Politics,&
                                    "外语成绩",p%item%English,&
                                    "数学分析",p%item%Math1,&
                                    "高等代数",p%item%Math2,&
                                    "初始成绩",p%item%FirstTest,&
                                    "复试成绩",p%item%LastTest
            else
                exit
            end if
        end do
        write(*,"('该同学',I3,'不存在,程序结束.')") i
        
        stop
    end program