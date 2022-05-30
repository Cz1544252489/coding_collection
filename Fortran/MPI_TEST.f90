program hello_world
  
  use mpi
  !include 'mpif.h'
  integer ierr, num_procs, my_id
    !real :: b[*]
  call MPI_INIT ( ierr )
  ! find out my process ID, and how many processes were started.
  !call MPI_COMM_RANK (MPI_COMM_WORLD, my_id, ierr)
  !call MPI_COMM_SIZE (MPI_COMM_WORLD, num_procs, ierr)

  !print *, "Hello world! I'm process ", my_id, " out of ", num_procs, " processes."

  !call MPI_FINALIZE ( ierr )

  stop
end program hello_world