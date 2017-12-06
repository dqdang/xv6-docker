#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "syscall.h"

// User code makes a system call with INT T_SYSCALL.
// System call number in %eax.
// Arguments on the stack, from the user call to the C
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
  *ip = *(int*)(addr);
  return 0;
}

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}

// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}

extern int sys_chdir(void);
extern int sys_close(void);
extern int sys_dup(void);
extern int sys_exec(void);
extern int sys_exit(void);
extern int sys_fork(void);
extern int sys_forkC(void);
extern int sys_fstat(void);
extern int sys_getpid(void);
extern int sys_kill(void);
extern int sys_link(void);
extern int sys_mkdir(void);
extern int sys_mknod(void);
extern int sys_open(void);
extern int sys_pipe(void);
extern int sys_read(void);
extern int sys_sbrk(void);
extern int sys_sleep(void);
extern int sys_unlink(void);
extern int sys_wait(void);
extern int sys_write(void);
extern int sys_uptime(void);
extern int sys_getname(void);
extern int sys_setname(void);
extern int sys_getmaxproc(void);
extern int sys_setmaxproc(void);
extern int sys_getmaxmem(void);
extern int sys_setmaxmem(void);
extern int sys_getmaxdisk(void);
extern int sys_setmaxdisk(void);
extern int sys_getusedmem(void);
extern int sys_setusedmem(void);
extern int sys_getallusedmem(void);
extern int sys_setallusedmem(void);
extern int sys_getallmaxmem(void);
extern int sys_setallmaxmem(void);
extern int sys_getuseddisk(void);
extern int sys_setuseddisk(void);
extern int sys_getalluseddisk(void);
extern int sys_setalluseddisk(void);
extern int sys_getallmaxdisk(void);
extern int sys_setallmaxdisk(void);
extern int sys_setvc(void);
extern int sys_getvcfs(void);
extern int sys_setactivefs(void);
extern int sys_getactivefs(void);
extern int sys_getcwd(void);
extern int sys_tostring(void);
extern int sys_getactivefsindex(void);
extern int sys_getatroot(void);
extern int sys_setatroot(void);
extern int sys_getpath(void);
extern int sys_setpath(void);
extern int sys_ps(void);
extern int sys_setalive(void);
extern int sys_getnumcontainers(void);
extern int sys_getticks(void);
extern int sys_cpause(void);
extern int sys_cstop(void);
extern int sys_cresume(void);
extern int sys_setnextproc(void);


static int (*syscalls[])(void) = {
[SYS_fork]                sys_fork,
[SYS_forkC]               sys_forkC,
[SYS_exit]                sys_exit,
[SYS_wait]                sys_wait,
[SYS_pipe]                sys_pipe,
[SYS_read]                sys_read,
[SYS_kill]                sys_kill,
[SYS_exec]                sys_exec,
[SYS_fstat]               sys_fstat,
[SYS_chdir]               sys_chdir,
[SYS_dup]                 sys_dup,
[SYS_getpid]              sys_getpid,
[SYS_sbrk]                sys_sbrk,
[SYS_sleep]               sys_sleep,
[SYS_uptime]              sys_uptime,
[SYS_open]                sys_open,
[SYS_write]               sys_write,
[SYS_mknod]               sys_mknod,
[SYS_unlink]              sys_unlink,
[SYS_link]                sys_link,
[SYS_mkdir]               sys_mkdir,
[SYS_close]               sys_close,
[SYS_getname]             sys_getname,
[SYS_setname]             sys_setname,
[SYS_getmaxproc]          sys_getmaxproc,
[SYS_setmaxproc]          sys_setmaxproc,
[SYS_getmaxmem]           sys_getmaxmem,
[SYS_setmaxmem]           sys_setmaxmem,
[SYS_getmaxdisk]          sys_getmaxdisk,
[SYS_setmaxdisk]          sys_setmaxdisk,
[SYS_getusedmem]          sys_getusedmem,
[SYS_setusedmem]          sys_setusedmem,
[SYS_getuseddisk]         sys_getuseddisk,
[SYS_setuseddisk]         sys_setuseddisk,
[SYS_getallusedmem]       sys_getallusedmem,
[SYS_setallusedmem]       sys_setallusedmem,
[SYS_getallmaxmem]        sys_getallmaxmem,
[SYS_setallmaxmem]        sys_setallmaxmem,
[SYS_getalluseddisk]      sys_getalluseddisk,
[SYS_setalluseddisk]      sys_setalluseddisk,    
[SYS_getallmaxdisk]       sys_getallmaxdisk,
[SYS_setallmaxdisk]       sys_setallmaxdisk,  
[SYS_setvc]               sys_setvc,
[SYS_getvcfs]             sys_getvcfs,
[SYS_setactivefs]         sys_setactivefs, 
[SYS_getactivefs]         sys_getactivefs, 
[SYS_getcwd]              sys_getcwd,
[SYS_tostring]            sys_tostring,
[SYS_getactivefsindex]    sys_getactivefsindex,
[SYS_getatroot]           sys_getatroot,
[SYS_setatroot]           sys_setatroot,
[SYS_getpath]             sys_getpath,
[SYS_setpath]             sys_setpath,
[SYS_ps]                  sys_ps,
[SYS_setalive]            sys_setalive,
[SYS_getnumcontainers]    sys_getnumcontainers,
[SYS_getticks]            sys_getticks,
[SYS_cpause]              sys_cpause,
[SYS_cstop]               sys_cstop,
[SYS_cresume]             sys_cresume,
[SYS_setnextproc]         sys_setnextproc,
};

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
