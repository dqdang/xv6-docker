#include "fcntl.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "container.h"

void print_usage(int mode){

  if(mode == 0){ // not enough arguments
    printf(1, "Usage: ctool <mode> <args>\n");
  }
  if(mode == 1){ // create
    printf(1, "Usage: ctool create <container> <max proc> <max mem> <max disk> <exec1> <exec2> ...\n");
  }
  if(mode == 2){ // create with container created
    printf(1, "Container taken. Failed to create, exiting...\n");
  }
  if(mode == 3){ // start
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
  }
  if(mode == 4){ // delete
    printf(1, "Usage: ctool delete <container>\n");
  }
  
  exit();
}

int is_int(char c){
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
}

// ctool start vc0 c0 usfsh
int start(int argc, char *argv[]){
  int id, fd, cindex = 1;
  char index[2];
  index[0] = argv[3][strlen(argv[3])-1];
  index[1] = '\0';
  cindex = atoi(index);

  printf(1, "CINDEX: %d\n", cindex);
  setvc(cindex, argv[2]);
  // getvcfs("vc0")

  fd = open(argv[2], O_RDWR);
  printf(1, "fd = %d\n", fd);
  /* fork a child and exec argv[4] */
  id = fork();

  if(id == 0){
    close(0);
    close(1);
    close(2);
    dup(fd);
    dup(fd);
    dup(fd);
    if(chdir(argv[3]) < 0){
      printf(1, "Container does not exist.");
      exit();
    }
    exec(argv[4], &argv[4]);
    close(fd);
    exit();
  }

  return 0;
}

int stop(char *argv[]){
  // TODO: loop through processes and kill them
  return 1;
}

// int delete(char *argv[]){
//   int id, i, j, cindex;
//   char compare[32];
//   char *rm[2];
//   rm[0] = "/rm";
//   //TODO: call pause

//   while(!is_int(argv[2][cindex])){
//     cindex = cindex + 1;
//   }
//   getname(cindex, compare);
//   for(i = 0; i < NUM_VCS; i++){
//     if(strcmp(compare, argv[2]) == 0){
//       for(j = 0; j < ctable.tuperwares[i].num_files; j++){
//         id = fork();
//         if(id == 0){
//           char destination[32];
//           strcpy(destination, "/");
//           strcat(destination, argv[2]);
//           strcat(destination, "/");
//           strcat(destination, ctable.tuperwares[i].files[j]);
//           strcat(destination, "\0");
//           rm[1] = destination;
//           exec(rm[0], rm);
//         }
//         id = wait();
//       }
//       id = fork();
//       if(id == 0){
//         rm[1] = argv[2];
//         exec(rm[0], rm);
//       }
//       id = wait();

     
//       struct container container;
//       ctable.tuperwares[i] = container;
//       break;
//     }
//   }return 1;
// }

// ctool create c0 8 8 8 cat ls echo sh ...
int create(int argc, char *argv[]){
  int i, id, bytes, cindex = 0;
  // num_files = argc - 6;
  char *mkdir[2];
  // char *files[num_files];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  // while(!is_int(argv[2][cindex])){
  //   cindex = cindex + 1;
  // }
  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
  index[1] = '\0';
  cindex = atoi(index);

  setname(cindex, argv[2]);
  setmaxproc(cindex, atoi(argv[3]));
  setmaxmem(cindex, atoi(argv[4]) * 1000000);
  setmaxdisk(cindex, atoi(argv[5]) * 1000000);
  setusedmem(cindex, 0);
  setuseddisk(cindex, 0);

  int err = 0;
  id = fork();
  if(id == 0){
    exec(mkdir[0], mkdir);
    printf(1, "Creating container failed. Container taken probably.\n");
    err = 1;
  }
  printf(1, "%d\n", err);
  id = wait();
  if(err == 1){
    exit();
  }

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
    char destination[32];

    strcpy(destination, "/");
    strcat(destination, mkdir[1]);
    strcat(destination, "/");
    strcat(destination, argv[i]);
    strcat(destination, "\0");

    // ctable.tuperwares[i].files[i-6] = argv[i];
    bytes = copy(argv[i], destination, getuseddisk(cindex), getmaxdisk(cindex));
    printf(1, "Bytes for %s: %d\n", argv[i], bytes);

    if(bytes > 0){
      setuseddisk(cindex, getuseddisk(cindex) + bytes);
    }
    else{
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
      id = fork();
      if(id == 0){
        char *remove_args[2];
        remove_args[0] = "rm";
        remove_args[1] = destination;
        exec(remove_args[0], remove_args);
      }
      id = wait();
    }
  }
  printf(1, "Total used disk: %d\n", getuseddisk(cindex));

  // TODO: IMPLEMENT GET/SET FILES
  // ctable.tuperwares[cindex].files = files;
  return 0;
}

int to_string(){
  char containers[256];
  tostring(containers);
  printf(1, "%s\n", containers);
  return 0;
}

int main(int argc, char *argv[]){
  if(argc < 2){
    print_usage(0);
  }

  if(strcmp(argv[1], "create") == 0){
    if(argc < 7){
      print_usage(1);
    }
    if(chdir(argv[2]) > 0){
      print_usage(2);
    }
    create(argc, argv);
  }

  if(strcmp(argv[1], "start") == 0){
    if(argc < 5){
      print_usage(3);
    }
    start(argc, argv);
  }

  if(strcmp(argv[1], "string") == 0){
    to_string();
  }

  // if(strcmp(argv[1], "delete") == 0){
  //   if(argc < 3){
  //     print_usage(4);
  //   }
  //   delete(argv);
  // }
  exit();

}
