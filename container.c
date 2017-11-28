#include "types.h"
#include "defs.h"
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

int getactivefsindex(void){
    int i, index = -1;
    for(i = 0; i < NUM_VCS; i++){
        if(strcmp(&cabinet.active_fs[1], cabinet.tuperwares[i].name) == 0){
            index = i;
            break;
        }
    }return index;
}

int setatroot(int index, int val){
    cabinet.tuperwares[index].atroot = val;

    return 0;
}

int getatroot(int index){
    return cabinet.tuperwares[index].atroot;
}


int tostring(char *string){
    int i;
    strncpy(string, "Active FS: ", 11);
    strcat(string, cabinet.active_fs);
    strcat(string, "\n\n");
    for(i = 0; i < NUM_VCS; i++){
        if(cabinet.tuperwares[i].name != 0){
            strcat(string, "Name: ");
            strcat(string, cabinet.tuperwares[i].name);
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        if(cabinet.tuperwares[i].vc != 0){
            strcat(string, "VC: ");
            strcat(string, cabinet.tuperwares[i].vc);
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "Index: ");
        char num_string[32];
        itoa(i, num_string, 10);
        strcat(string, num_string);
        strcat(string, "\n\n");
    }
    strcat(string, "\0");
    return 0;
}
