#include "types.h"
#include "user.h"

int main(void)
{
   int i = 1, j, x, single = 1, update = 1;
   char abs[52];
   getpath(0, abs);
   char *path = "test";
    char *token_cab;
    char *token_path;
    char *path_arr[128];

    if(update == 1){
        getpath(0, token_cab);
        token_path = path;
        path_arr[0] = "/";

        while ((token_cab = strtok(token_cab, "/")) != 0){
            path_arr[i++] = token_cab;
            token_cab = 0;
        }

        for(x = 0; x < strlen(path); x++){
            if(path[x] == '/'){
                single = 0;
            }
        }
        if(!single){
            while((token_path = strtok(token_path, "/")) != 0){                
                if(strcmp(token_path, "..") == 0){
                    path_arr[--i] = 0;
                    i++;
                }
                else{
                    path_arr[i++] = token_path;
                }
            }token_path = 0;
        }else{
            path_arr[i] = path;

        }

        strcpy(abs, path_arr[0]);
        for(j = 1; j <= i; j++){
            if(path_arr[j] != 0){
                strcat(abs, path_arr[j]);
                strcat(abs, "/");
            }
        }
        strcat(abs, "\0");
    }else{
        strcpy(abs, path);

    }

    printf(1, "Absolute path: %s\n", abs);

    exit();
}
