#include "fcntl.h"
#include "types.h"
#include "stat.h"
#include "user.h"

struct container
{
  char *name;
  char **progs; 
  int max_proc;
  int max_mem;
  int max_disk;
  int used_mem;
  int used_disk;
};

struct
{
  struct container tuperwares[4];
  int count;
} ctable;

void print_usage(int mode)
{
  if(mode == 0) // not enough arguments
  {
    printf(1, "Usage: ctool <mode> <args>\n");
  }
  if(mode == 1) // create
  {
    printf(1, "Usage: ctool create <max proc> <max mem> <max disk> <container> <exec1> <exec2> ...\n");
  }
  if(mode == 2) // create with container created
  {
    printf(1, "Container taken. Failed to create, exiting...\n");
  }
  if(mode == 3) // start
  {
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
  }
  
  exit();
}

int is_int(char c)
{
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
}

// ctool start vc0 c0 usfsh
int start(int argc, char *argv[])
{
  int id, fd;
  fd = open(argv[2], O_RDWR);
  printf(1, "fd = %d\n", fd);

  /* fork a child and exec argv[4] */
  id = fork();

  if(id == 0)
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

// ctool create c0 8 8 8 cat ls echo sh ...
int create(int argc, char *argv[])
{
  int i, id, bytes, cindex = 0;
  char *mkdir[2];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  while(!is_int(argv[2][cindex]))
  {
    cindex = cindex + 1;
  }

  strcpy(ctable.tuperwares[cindex].name, argv[2]);
  ctable.count = ctable.count + 1;
  ctable.tuperwares[cindex].max_proc = atoi(argv[3]);
  ctable.tuperwares[cindex].max_mem = atoi(argv[4])*1000000;
  ctable.tuperwares[cindex].max_disk = atoi(argv[5])*1000000;
  ctable.tuperwares[cindex].used_mem = 0;
  ctable.tuperwares[cindex].used_disk = 0;

  id = fork();
  if(id == 0)
  {
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 6; i < argc; i++) // going through ls echo cat ...
  {
    char destination[32];

    strcpy(destination, "/");
    strcat(destination, mkdir[1]);
    strcat(destination, "/");
    strcat(destination, argv[i]);
    strcat(destination, "\0");

    bytes = copy(argv[i], destination, ctable.tuperwares[cindex].used_disk, ctable.tuperwares[cindex].max_disk);
    printf(1, "Bytes for each file: %d\n", bytes);

    if(bytes > 0)
    {
      ctable.tuperwares[cindex].used_disk += bytes; 
    }
    else
    {
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
      id = fork();
      if(id == 0)
      {
        char *remove_args[2];
        remove_args[0] = "rm";
        remove_args[1] = destination;
        exec(remove_args[0], remove_args);
      }
      id = wait();
    }
  }
  return 0;
}

int main(int argc, char *argv[])
{
  if(argc < 2)
  {
    print_usage(0);
  }

  if(strcmp(argv[1], "create") == 0)
  {
    if(argc < 7)
    {
      print_usage(1);
    }
    if(chdir(argv[2]) > 0)
    {
      print_usage(2);
    }

    create(argc, argv);
  }

  if(strcmp(argv[1], "start") == 0)
  {
    if(argc < 5)
    {
      print_usage(3);
    }

    start(argc, argv);
  }

  exit();
}
