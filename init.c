// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"
#include "container.h"


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
count_files(char* p){
  char buf[512];
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(p, 0)) < 0){
    printf(2, "cannot open %s\n", p);
    return 0;
  }

  if(fstat(fd, &st) < 0){
    printf(2, "cannot stat %s\n", p);
    close(fd);
    return 0;
  }

  if(strlen(p) + 1 + DIRSIZ + 1 > sizeof buf){
    printf(1, "path too long\n");
    return 0;
  }
  strcpy(buf, p);
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
    if(st.type != 1)
    {
      setalluseddisk(all_disk+st.size);
    }
    else
    {
      // printf(1, "HERE\n");
      count_files(&p);
    }
  }

  close(fd);
  return 0;
}

int
main(void)
{
  char fs[32];
  getactivefs(fs);
  count_files(&fs);

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
