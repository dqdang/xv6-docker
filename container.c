#include "container.h"

#define NUM_VCS 4

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (char)*p - (char)*q;
}

int getname(int index, char* name){
    int i = 0;
    while((*name++ = cabinet.tuperwares[index].name[i++]) != 0);

    return 0;
}

int setname(int index, char* name){
    int i = 0;
    while((cabinet.tuperwares[index].name[i++] = *name++) != 0);

    return 0;
}

int getmaxproc(int index){
    return cabinet.tuperwares[index].max_proc;
}

int setmaxproc(int index, int max_proc){
    cabinet.tuperwares[index].max_proc = max_proc;
    return 0;
}

int getmaxmem(int index){
    return cabinet.tuperwares[index].max_mem;
}

int setmaxmem(int index, int max_mem){
    cabinet.tuperwares[index].max_mem = max_mem;
    return 0;
}

int getmaxdisk(int index){
    return cabinet.tuperwares[index].max_disk;
}

int setmaxdisk(int index, int max_disk){
    cabinet.tuperwares[index].max_disk = max_disk;
    return 0;
}

int getusedmem(int index){
    return cabinet.tuperwares[index].used_mem;
}

int setusedmem(int index, int used_mem){
    cabinet.tuperwares[index].used_mem = used_mem;
    return 0;
}

int getuseddisk(int index){
    return cabinet.tuperwares[index].used_disk;
}

int setuseddisk(int index, int used_disk){
    cabinet.tuperwares[index].used_disk = used_disk;
    return 0;
}

int setvc(int index, char* vc){
    int i = 0;
    while((cabinet.tuperwares[index].vc[i++] = *vc++) != 0);

    return 0;
}

int getvcfs(char *vc, char *fs){
    int i, j = 0;
    for(i = 0; i < NUM_VCS; i++){
        if(strcmp(cabinet.tuperwares[i].vc, vc) == 0){
            while((*fs++ = cabinet.tuperwares[i].name[j++]) != 0);
        }
    }return 0;
}

int setactivefs(char *fs){
    int i = 0;
    while((cabinet.active_fs[i++] = *fs++) != 0);

    return 0;
}

int getactivefs(char *fs){
    int i = 0;
    while((*fs++ = cabinet.active_fs[i++]) != 0);

    return 0;
}

int tostring(char *string){
    int i, j = 0;

    for(i = 0; i < NUM_VCS; i++){
        // string += name;
        while((*string++ = cabinet.tuperwares[i].name[j++]) != 0);
        *string++ = '\n';
        j = 0;
        // string += vc;
        while((*string++ = cabinet.tuperwares[i].vc[j++]) != 0);
        *string++ = '\n';
    }
    *string++ = '\0';
    return 0;
}

