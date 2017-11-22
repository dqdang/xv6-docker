#include "types.h"
#include "stat.h"
#include "user.h"

int create(int argc, char *argv[])
{
  int i, id;
  char *arguments[2];
  arguments[0] = "mkdir";
  arguments[1] = argv[2];
  id = fork();
  if(id == 0)
  {
    exec(arguments[0], arguments);
  }

  for(i = 3; i < argc; i++)
  {
    id = fork();
    if(id == 0)
    {
      exec("cat < afkdlasjdflka > jflkajsdf", );
    }
  }
}

int
main(int argc, char *argv[])
{
  if(strcmp(argv[1], "create") == 0)
  {
    create(argc, argv);
  }
}
