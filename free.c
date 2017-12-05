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
  char available[100];
  char maxbytes[100];
  char kallocs[100];
  char usedkallocs[100];
  char maxkallocs[100];


  if(strcmp(fs, "/") == 0){
    itoa((getallusedmem()*4096), usedbytes, 10);
    itoa((getallmaxmem()-getallusedmem())*4096, available, 10);
    itoa((getallmaxmem()*4096), maxbytes, 10);
    itoa(getallusedmem(), usedkallocs, 10);
    itoa(getallmaxmem(), maxkallocs, 10);
    strcpy(kallocs, usedkallocs);
    strcat(kallocs, "/");
    strcat(kallocs, maxkallocs);
    strcat(kallocs, "\0");
  }
  else{
    int index = getactivefsindex();
    itoa((getusedmem(index)*4096), usedbytes, 10);
    itoa((getmaxmem(index)-getusedmem(index))*4096, available, 10);
    itoa((getmaxmem(index)*4096), maxbytes, 10);
    itoa(getusedmem(index), usedkallocs, 10);
    itoa(getmaxmem(index), maxkallocs, 10);
    strcpy(kallocs, usedkallocs);
    strcat(kallocs, "/");
    strcat(kallocs, maxkallocs);
    strcat(kallocs, "\0");
  }
  printf(1, "%s\n", "Filesystem              Used         Available         Total         kallocs");
  printf(1, "%s%s%s%s%s%s%s%s%s\n",fs, spaces(24-strlen(fs), space1), usedbytes, spaces(13-strlen(usedbytes), space2), available, spaces(18-strlen(available), space3), maxbytes, spaces(14-strlen(maxbytes), space4), kallocs);
  exit();

}
