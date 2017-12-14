#include "fcntl.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "container.h"


int main(int argc, char *argv[]){
  char fs[128];
  getactivefs(fs);
  char space1[128];
  char space3[128];
  char space4[128];
  // char percent[100];
  char available[100];
  char usedbytes[100];
  char maxbytes[100];

  if(strcmp(fs, "/") == 0){
    itoa((getalluseddisk()), usedbytes, 10);
    itoa((getallmaxdisk()), maxbytes, 10);
    itoa((getallmaxdisk() - getalluseddisk()), available, 10);
  }
  else{
    int index = getactivefsindex();
    itoa((getuseddisk(index)), usedbytes, 10);
    itoa((getmaxdisk(index)), maxbytes, 10);
    itoa((getmaxdisk(index) - getuseddisk(index)), available, 10);
  }
  printf(1, "%s\n", "Filesystem              Used         Available         Total");
  printf(1, "%s%s%s%s%s%s%s\n",fs, spaces(24-strlen(fs), space1), usedbytes, spaces(13-strlen(usedbytes), space3), available, spaces(18-strlen(available), space4), maxbytes);
  exit();
}
