#include "container.h"

#define NUM_VCS 4

struct container tuperwares[NUM_VCS];

int getname(int index, char* name){
    int i = 0;
    while((*name++ = tuperwares[index].name[i++]) != 0);

    return 0;
}

int setname(int index, char* name){
    int i = 0;
    while((tuperwares[index].name[i++] = *name++) != 0);

    return 0;
}

int getmaxproc(int index){
    return tuperwares[index].max_proc;
}

int setmaxproc(int index, int max_proc){
    tuperwares[index].max_proc = max_proc;
    return 0;
}

int getmaxmem(int index){
    return tuperwares[index].max_mem;
}

int setmaxmem(int index, int max_mem){
    tuperwares[index].max_mem = max_mem;
    return 0;
}

int getmaxdisk(int index){
    return tuperwares[index].max_disk;
}

int setmaxdisk(int index, int max_disk){
    tuperwares[index].max_disk = max_disk;
    return 0;
}

int getusedmem(int index){
    return tuperwares[index].used_mem;
}

int setusedmem(int index, int used_mem){
    tuperwares[index].used_mem = used_mem;
    return 0;
}

int getuseddisk(int index){
    return tuperwares[index].used_disk;
}

int setuseddisk(int index, int used_disk){
    tuperwares[index].used_disk = used_disk;
    return 0;
}
