#include "types.h"
#include "defs.h"
#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
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

int getallusedmem(void){
    return cabinet.used_mem;
}

int setallusedmem(int mem){
    cabinet.used_mem = mem;
    return 0;
}

int getallmaxmem(void){
    return cabinet.max_mem;
}

int setallmaxmem(int mem){
    cabinet.max_mem = mem;
    return 0;
}

int getuseddisk(int index){
    return cabinet.tuperwares[index].used_disk;
}

int setuseddisk(int index, int used_disk){
    cabinet.tuperwares[index].used_disk = used_disk;
    return 0;
}

int getalluseddisk(void){
    return cabinet.used_disk;
}

int setalluseddisk(int disk){
    cabinet.used_disk = disk;
    return 0;
}

int getallmaxdisk(void){
    return cabinet.max_disk;
}

int setallmaxdisk(int disk){
    cabinet.max_disk = disk;
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

int setalive(int index, int val){
    cabinet.tuperwares[index].alive = val;
    return 0;
}

int getalive(int index){
    return cabinet.tuperwares[index].alive;
}


int getactivefsindex(void){
    int i, index = -1;
    for(i = 0; i < NUM_VCS; i++){

        if(cabinet.tuperwares[i].alive && strcmp(&cabinet.active_fs[1], cabinet.tuperwares[i].name) == 0){
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

int getpath(int index, char *path){
    int i = 0;
    while((*path++ = cabinet.tuperwares[index].path[i++]) != 0);

    return 0;
}

int setpath(int index, char *path, int update){
    int i = 1, j, x, single = 1;
    char temp_currpath[128];
    char temp_path[128];
    char *token_cab, *token_path;
    char *path_arr[128];

    if(update == 1){
        strcpy(temp_currpath, cabinet.tuperwares[index].path);
        strcat(temp_currpath, "\0");
        token_cab = temp_currpath;
        strcpy(temp_path, path);
        strcat(temp_path, "\0");
        token_path = temp_path;
        path_arr[0] = "/";

        path_arr[i] = strtok(token_cab, "/");
        // building array from current path: path_arr = ["/", "c0", ..., ...]
        while (path_arr[i] != 0) {
            path_arr[++i] = strtok(0, "/");
        }

        // checking to see if path has multiple directory changes: cd ../../../work
        for(x = 0; x < strlen(path); x++){
            if(path[x] == '/'){
                single = 0;
            }
        }

        // updating current path array to new path
        if(single == 0){
            token_path = strtok(token_path, "/");

            while(token_path != 0){        
                if(strcmp(token_path, "..") == 0){
                    path_arr[--i] = 0;
                }
                else{   
                    path_arr[i++] = token_path;
                }
                token_path = strtok(0, "/");
            }
        }else{
            if(strcmp(path, "..") == 0){
                path_arr[--i] = 0;
            }else{                
                path_arr[i] = path;
            }
        }

        // copy back into container path member
        strcpy(cabinet.tuperwares[index].path, path_arr[0]);
        for(j = 1; j <= i; j++){
            if(path_arr[j] != 0){
                strcat(cabinet.tuperwares[index].path, path_arr[j]);
                strcat(cabinet.tuperwares[index].path, "/");
            }
        }
        strcat(cabinet.tuperwares[index].path, "\0");
    }else{
        strcpy(cabinet.tuperwares[index].path, path);
    }

    return 0;
}

int tostring(char *string){
    int i;
    strncpy(string, "Active FS: ", 11);
    strcat(string, cabinet.active_fs);
    strcat(string, "\n\n");
    for(i = 0; i < NUM_VCS; i++){
        strcat(string, "Name: ");
        if(cabinet.tuperwares[i].name != 0){
            strcat(string, cabinet.tuperwares[i].name);
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "VC: ");
        if(cabinet.tuperwares[i].vc != 0){
            strcat(string, cabinet.tuperwares[i].vc);
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "CURRENT PATH: ");
        if(cabinet.tuperwares[i].path != 0){
            strcat(string, cabinet.tuperwares[i].path);
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "MAX PROC:  ");
        if(cabinet.tuperwares[i].max_proc != 0){
            char num_string[32];
            strcat(string, itoa(cabinet.tuperwares[i].max_proc, num_string, 10));
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "USED MEM:  ");
        if(cabinet.tuperwares[i].used_mem != 0){
            char num_string[32];
            strcat(string, itoa(cabinet.tuperwares[i].used_mem*4096, num_string, 10));
        }else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "MAX MEM:   ");
        if(cabinet.tuperwares[i].max_mem != 0){
            char num_string[32];
            strcat(string, itoa(cabinet.tuperwares[i].max_mem*4096, num_string, 10));
        }
        else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "USED DISK: ");
        if(cabinet.tuperwares[i].used_disk != 0){
            char num_string[32];
            strcat(string, itoa(cabinet.tuperwares[i].used_disk, num_string, 10));
        }else{
            strcat(string, "NULL");
        }
        strcat(string, "\n");
        strcat(string, "MAX DISK:  ");
        if(cabinet.tuperwares[i].max_disk != 0){
            char num_string[32];
            strcat(string, itoa(cabinet.tuperwares[i].max_disk, num_string, 10));
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


