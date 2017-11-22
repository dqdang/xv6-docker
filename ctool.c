#include "fcntl.h"
#include "types.h"
#include "stat.h"
#include "user.h"

struct container
{
  char *name;
  char **executables; 
  int max_proc;
  int max_mem;
  int max_disk;
};

struct
{
  struct container containers[4];
  int count;
} ctable;

int is_int(char c)
{
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
}

// ctool start vc0 c0 usfsh 8 10 5
int start(int argc, char *argv[])
{
  int id, fd, cindex = 0;
  while(!is_int(argv[3][cindex]))
  {
    cindex = cindex + 1;
  }

  fd = open(argv[2], O_RDWR);
  printf(1, "fd = %d\n", fd);

  strcpy(ctable.containers[cindex].name, argv[3]);
  ctable.containers[cindex].max_proc = atoi(argv[5]);
  ctable.containers[cindex].max_mem = atoi(argv[6]);
  ctable.containers[cindex].max_disk = atoi(argv[7]);

  /* fork a child and exec argv[4] */
  id = fork();

  if (id == 0)
  {
    close(0);
    close(1);
    close(2);
    dup(fd);
    dup(fd);
    dup(fd);
    if(chdir(argv[3]) < 0)
    {
      printf(1, "Container does not exist.");
      exit();
    }
    exec(argv[4], &argv[4]);
    close(fd);
    exit();
  }

  return 0;
}

// ctool create c0 cat ls echo sh ...
int create(int argc, char *argv[])
{
  int i, id, fd;
  char *mkdir[2];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  int cindex = 0;
  while(!is_int(argv[3][cindex]))
  {
    cindex = cindex + 1;
  }

  strcpy(ctable.containers[cindex].name, argv[2]);
  ctable.count = ctable.count + 1;

  id = fork();
  if(id == 0)
  {
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 3; i < argc; i++) // going through ls echo cat ...
  {
    id = fork();
    if(id == 0)
    {
      char *executable[4];
      char destination[32];

      strcpy(destination, "/");
      strcat(destination, mkdir[1]);
      strcat(destination, "/");
      strcat(destination, argv[i]);
      strcat(destination, "\0");

      executable[0] = "cat";
      executable[1] = argv[i];

      fd = open(destination, O_CREATE | O_RDWR);
    
      close(1);
      dup(fd);
      close(fd);
      exec(executable[0], executable);
    }
    id = wait();
  }

  return 0;
}

int main(int argc, char *argv[])
{

  if(argc < 2)
  {
    // TODO:
    // print_usage();
  }

  if(strcmp(argv[1], "create") == 0)
  {
    if(argc < 4)
    {
      // TODO:
      // print_usage("create");
    }
    else
    {
      if(chdir(argv[2]) < 0)
      {
         create(argc, argv);
      }
      else
      {
        printf(1, "This device already has a container's filesystem\n");
        exit();
      }
    }
  }

  if(strcmp(argv[1], "start") == 0)
  {
    if(argc < 4)
    {
      // TODO:
      // print_usage("create");
    }
    else
    {
      start(argc, argv);
    }
  }

  exit();
}
