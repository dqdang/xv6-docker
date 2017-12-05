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
    // itoa(((getalluseddisk())/(getallmaxdisk())) * 100, percent, 10);
    itoa((getalluseddisk()), usedbytes, 10);
    itoa((getallmaxdisk()), maxbytes, 10);
    itoa((getallmaxdisk() - getalluseddisk()), available, 10);
  }
  else{
    int index = getactivefsindex();
    // itoa(((getuseddisk(index))/(getmaxmem(index)*4096)) * 100, percent, 10);
    itoa((getuseddisk(index)), usedbytes, 10);
    itoa((getmaxdisk(index)), maxbytes, 10);
    itoa((getallmaxdisk() - getalluseddisk()), available, 10);
  }
  // printf(1, "%s\n", "Filesystem                  Used       Total      Use%");
  printf(1, "%s\n", "Filesystem                  Used       Total          Available");
  // printf(1, "%s%s%s%s%s%s%s\n",fs, spaces(28-strlen(fs), space1), usedbytes, spaces(11-strlen(usedbytes), space3), maxbytes, spaces(15-strlen(maxbytes), space4), percent);
  printf(1, "%s%s%s%s%s%s%s\n",fs, spaces(28-strlen(fs), space1), usedbytes, spaces(11-strlen(usedbytes), space3), maxbytes, spaces(15-strlen(maxbytes), space4), available);
  exit();
}
