#define NUM_VCS 4

struct container{
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

};

struct{
  struct container tuperwares[NUM_VCS];
  int used_disk;
  int used_mem;
  char active_fs[32];
}cabinet;

int
getname(int index, char* name);

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
getuseddisk(int index);

int
setuseddisk(int index, int used_disk);

int
setvc(int index, char* vc);

int
setactivefs(char *fs);

int
getactivefs(char *fs);

int
getvcfs(char *vc, char *fs);

int
tostring(char *string);

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
