#define NUM_VCS 4

struct container{
  int alive;
  char name[32];
  char vc[32];
  char path[256];
  char **files;
  int num_files;
  int max_proc;
  int max_mem;
  int max_disk;
  int used_mem;
  int used_disk;
  int atroot;
  int next_proc;
};

struct{
  struct container tuperwares[NUM_VCS];
  int used_disk;
  int max_disk;
  int used_mem;
  int max_mem;
  char active_fs[32];
  int next_proc;
}cabinet;

int
getname(int index, char* name);

int
setnextproc(int index, int val);

int 
setname(int index, char* name);

int
getmaxproc(int index);

int
setmaxproc(int index, int max_proc);

int
getmaxmem(int index);

int
setmaxmem(int index, int max_mem);

int
getmaxdisk(int index);

int
setmaxdisk(int index, int max_disk);

int
getusedmem(int index);

int
setusedmem(int index, int used_mem);

int
getallusedmem(void);

int
setallusedmem(int used_mem);

int
getallmaxmem(void);

int
setallmaxmem(int mem);

int
getuseddisk(int index);

int
setuseddisk(int index, int used_disk);

int
getalluseddisk(void);

int
setalluseddisk(int used_disk);

int
getallmaxdisk(void);

int
setallmaxdisk(int disk);

int
setvc(int index, char* vc);

int
setactivefs(char *fs);

int
getactivefs(char *fs);

int
getvcfs(char *vc, char *fs);

int
tostring(void);

int
getactivefsindex(void);

int
setatroot(int index, int val);

int
getatroot(int index);

int
getpath(int index, char *path);

int
setpath(int index, char *path, int remove);

int
setalive(int index, int val);

int
getnumcontainers(void);
