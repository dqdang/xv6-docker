// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"


char *argv[] = { "sh", 0 };

void
create_vcs(void)
{
  int i, fd;
  char *dname = "vc0";

  for (i = 0; i < 4; i++) {
    dname[2] = '0' + i;
    if ((fd = open(dname, O_RDWR)) < 0){
      mknod(dname, 1, i + 2);
    } else {
      close(fd);
    }
  }
}

int
main(void)
{
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  char fs[32];
  getactivefs(fs);

  if((fd = open(fs, 0)) < 0){
    printf(2, "cannot open %s\n", fs);
    return 0;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "cannot stat %s\n", fs);
    close(fd);
    return 0;
  }

 
  if(strlen(fs) + 1 + DIRSIZ + 1 > sizeof buf){
    printf(1, "path too long\n");
    return 0;
  }
  strcpy(buf, fs);
  p = buf+strlen(buf);
  *p++ = '/';
  while(read(fd, &de, sizeof(de)) == sizeof(de)){
    if(de.inum == 0)
      continue;
    memmove(p, de.name, DIRSIZ);
    p[DIRSIZ] = 0;
    if(stat(buf, &st) < 0){
      printf(1, "cannot stat %s\n", buf);
      continue;
    }
    int all_disk = getalluseddisk();
    setalluseddisk(all_disk+st.size);
  }

  close(fd);

  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  create_vcs();

  for(;;){
    printf(1, "init: starting sh\n");
    pid = fork(0);
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
