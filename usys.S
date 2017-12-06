#include "syscall.h"
#include "traps.h"

#define SYSCALL(name) \
  .globl name; \
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
SYSCALL(forkC)
SYSCALL(exit)
SYSCALL(wait)
SYSCALL(pipe)
SYSCALL(read)
SYSCALL(write)
SYSCALL(close)
SYSCALL(kill)
SYSCALL(exec)
SYSCALL(open)
SYSCALL(mknod)
SYSCALL(unlink)
SYSCALL(fstat)
SYSCALL(link)
SYSCALL(mkdir)
SYSCALL(chdir)
SYSCALL(dup)
SYSCALL(getpid)
SYSCALL(sbrk)
SYSCALL(sleep)
SYSCALL(uptime)
SYSCALL(getname)
SYSCALL(setname)
SYSCALL(getmaxproc)
SYSCALL(setmaxproc)
SYSCALL(getmaxmem)
SYSCALL(setmaxmem)
SYSCALL(getmaxdisk)
SYSCALL(setmaxdisk)
SYSCALL(getallmaxmem)
SYSCALL(setallmaxmem)
SYSCALL(getallmaxdisk)
SYSCALL(setallmaxdisk)
SYSCALL(getusedmem)
SYSCALL(setusedmem)
SYSCALL(getuseddisk)
SYSCALL(setuseddisk)
SYSCALL(getallusedmem)
SYSCALL(setallusedmem)
SYSCALL(getalluseddisk)
SYSCALL(setalluseddisk)
SYSCALL(setvc)
SYSCALL(setactivefs)
SYSCALL(getactivefs)
SYSCALL(getvcfs)
SYSCALL(getcwd)
SYSCALL(tostring)
SYSCALL(getactivefsindex)
SYSCALL(setatroot)
SYSCALL(getatroot)
SYSCALL(getpath)
SYSCALL(setpath)
SYSCALL(setalive);
SYSCALL(ps)
SYSCALL(getnumcontainers);
SYSCALL(getticks);
SYSCALL(cpause);
SYSCALL(cstop);
SYSCALL(cresume);
SYSCALL(setnextproc);

