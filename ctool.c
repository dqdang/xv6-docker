#include "fcntl.h"
#include "types.h"
#include "stat.h"
#include "user.h"
#include "container.h"

void print_usage(int mode){

  if(mode == 0){ // not enough arguments
    printf(1, "Usage: ctool <mode> <args>\n");
  }
  if(mode == 1){ // crea te
    printf(1, "Usage: ctool create <container> <exec1> <exec2> ...\n");
  }
  if(mode == 2){ // create with container created
    printf(1, "Container taken. Failed to create, exiting...\n");
  }
  if(mode == 3){ // start
    printf(1, "Usage: ctool start <console> <container> <exec> <max proc> <max mem> <max disk>\n");
  }
  if(mode == 4){ // pause
    printf(1, "Usage: ctool pause <container>\n");
  }
  if(mode == 5){ // stop
    printf(1, "Usage: ctool stop <container>\n");
  }
  if(mode == 6){ // resume
    printf(1, "Usage: ctool resume <container>\n");
  }
  if(mode == 7){ // delete
    printf(1, "Usage: ctool delete <container>\n");
  }
  
  exit();
}

// ctool create c0 cat ls echo sh ...
int create(int argc, char *argv[]){
  int i, id, bytes, cindex;
  char *mkdir[2];
  char fs[32];
  strcpy(fs, "/");
  strcat(fs, argv[2]);
  strcat(fs, "\0");
  setactivefs(fs);

  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
  index[1] = '\0';
  cindex = atoi(index);

  setname(cindex, argv[2]);
  setalive(cindex, 1);
  char path[32];
  strcpy(path, "/");
  strcat(path, argv[2]);
  strcat(path, "\0");
  setpath(cindex, path, 0);

  int ppid = getpid();
  id = fork(0);
  if(id == 0){
    exec(mkdir[0], mkdir);
    printf(1, "Creating container failed. Container taken.\n");
    kill(ppid);
    exit();
  }
  id = wait();

  for(i = 3; i < argc; i++){ // going through ls echo cat ...
    char destination[32];

    strcpy(destination, "/");
    strcat(destination, mkdir[1]);
    strcat(destination, "/");
    strcat(destination, argv[i]);
    strcat(destination, "\0");

    bytes = copy(argv[i], destination);//, getuseddisk(cindex), getmaxdisk(cindex));
    printf(1, "Bytes for %s: %d\n", argv[i], bytes);
  }
  strcpy(fs, "/\0");
  setactivefs(fs);
  return 0;
}

// ctool start vc0 c0 usfsh (optinal) -> 8 8 8
int start(int argc, char *argv[]){
  char fs[32];
  strcpy(fs, "/");
  strcat(fs, argv[3]);
  strcat(fs, "\0");
  setactivefs(fs);

  int id, fd, cindex, ppid = getpid();
  char index[2];
  index[0] = argv[3][strlen(argv[3])-1];
  index[1] = '\0';
  cindex = atoi(index);

  
  if(argc == 5){
    setmaxproc(cindex, 10);
    setmaxmem(cindex, 500);
    setmaxdisk(cindex, 4 * 1000000);
  }else{
    setmaxproc(cindex, atoi(argv[5]));
    setmaxmem(cindex, atoi(argv[6]));
    setmaxdisk(cindex, atoi(argv[7]) * 1000000);
  }
  

  setvc(cindex, argv[2]);

  fd = open(argv[2], O_RDWR);
  if(fd < 0){
    printf(1, "Failed to open console %s\n", argv[2]);
    exit();
  }
  printf(1, "Opened console %s.\n", argv[2]);
  /* fork a child and exec argv[4] */
  id = forkC(cindex, 1);


  if(id == 0){
    close(0);
    close(1);
    close(2);
    dup(fd);
    dup(fd);
    dup(fd);
    if(chdir(argv[3]) < 0){
      printf(1, "Container %s does not exist.", argv[3]);
      kill(ppid);
      exit();
    }
    exec(argv[4], &argv[4]);
    close(fd);
    exit();
  }
  strcpy(fs, "/\0");
  setactivefs(fs);
  return 0;
}

// ctool stop c0
int stop(char *argv[]){
  int cindex;
  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
  index[1] = '\0';
  cindex = atoi(index);

  cstop(cindex);
  return 1;
}

// ctool pause c0
int pause(char *argv[]){
  int cindex;
  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
  index[1] = '\0';
  cindex = atoi(index);
  cpause(cindex);
  return 1;
}

// ctool resume c0
int resume(char *argv[]){
  int cindex;
  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
  index[1] = '\0';
  cindex = atoi(index);

  cresume(cindex);
  return 1;
}



// int delete(char *argv[]){
//   int id, i, j, cindex;
//   char compare[32];
//   char *rm[2];
//   rm[0] = "/rm";
//   //TODO: call pause

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

int info(){
  tostring();
  return 0;
}

int main(int argc, char *argv[]){
  if(argc < 2){
    print_usage(0);
  }

  if(strcmp(argv[1], "create") == 0){
    if(argc < 4){
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

  if(strcmp(argv[1], "pause") == 0){
    if(argc < 3){
      print_usage(4);
    }
    pause(argv);
  }

  if(strcmp(argv[1], "stop") == 0){
    if(argc < 3){
      print_usage(5);
    }
    stop(argv);
  }

  if(strcmp(argv[1], "resume") == 0){
    if(argc < 3){
      print_usage(6);
    }
    resume(argv);
  }

  // if(strcmp(argv[1], "delete") == 0){
  //   if(argc < 3){
  //     print_usage(7);
  //   }
  //   delete(argv);
  // }

  if(strcmp(argv[1], "info") == 0){
    info();
  }
  
  exit();
}
