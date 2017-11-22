#include "fcntl.h"
#include "types.h"
#include "stat.h"
#include "user.h"

int create(int argc, char *argv[])
{
  int i, id, fd;
  char *mkdir[2];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];
  
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

  exit();
}
