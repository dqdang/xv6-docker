#include "fcntl.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "container.h"


int main(int argc, char *argv[]){
  char fs[128];
  getactivefs(fs);
  char space1[128];
  char space2[128];
  char space3[128];
  char space4[128];
  // char percent[100];
  char usedbytes[100];
  char maxbytes[100];
  char kallocs[100];

  if(strcmp(fs, "/") == 0){
    // itoa((getallusedmem()*4096)/(getallmaxmem()*4096), percent, 10);
    itoa((getallusedmem()*4096), usedbytes, 10);
    itoa((getallmaxmem()*4096), maxbytes, 10);
    itoa(getallusedmem(), kallocs, 10);
  }
  else{
    int index = getactivefsindex();
    // itoa((getusedmem(index)*4096)/(getmaxmem(index)*4096), percent, 10);
    itoa((getusedmem(index)*4096), usedbytes, 10);
    itoa((getmaxmem(index)*4096), maxbytes, 10);
    itoa(getusedmem(index), kallocs, 10);
  }
  // printf(1, "%s\n", "Filesystem                  kallocs      Used       Available      Use%");
  printf(1, "%s\n", "Filesystem                  kallocs      Used       Available");
  // printf(1, "%s%s%s%s%s%s%s%s%s\n",fs, spaces(28-strlen(fs), space1), kallocs, spaces(13-strlen(kallocs), space2), usedbytes, spaces(11-strlen(usedbytes), space3), maxbytes, spaces(15-strlen(maxbytes), space4), percent);
  printf(1, "%s%s%s%s%s%s%s\n",fs, spaces(28-strlen(fs), space1), kallocs, spaces(13-strlen(kallocs), space2), usedbytes, spaces(11-strlen(usedbytes), space3), maxbytes);
  exit();

}
