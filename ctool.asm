
_ctool:     file format elf32-i386


Disassembly of section .text:

00000000 <print_usage>:
#include "types.h"
#include "stat.h"
#include "user.h"
#include "container.h"

void print_usage(int mode){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp

  if(mode == 0){ // not enough arguments
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 14                	jne    20 <print_usage+0x20>
    printf(1, "Usage: ctool <mode> <args>\n");
       c:	c7 44 24 04 dc 12 00 	movl   $0x12dc,0x4(%esp)
      13:	00 
      14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      1b:	e8 f5 0e 00 00       	call   f15 <printf>
  }
  if(mode == 1){ // create
      20:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
      24:	75 14                	jne    3a <print_usage+0x3a>
    printf(1, "Usage: ctool create <container> <max proc> <max mem> <max disk> <exec1> <exec2> ...\n");
      26:	c7 44 24 04 f8 12 00 	movl   $0x12f8,0x4(%esp)
      2d:	00 
      2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      35:	e8 db 0e 00 00       	call   f15 <printf>
  }
  if(mode == 2){ // create with container created
      3a:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
      3e:	75 14                	jne    54 <print_usage+0x54>
    printf(1, "Container taken. Failed to create, exiting...\n");
      40:	c7 44 24 04 50 13 00 	movl   $0x1350,0x4(%esp)
      47:	00 
      48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      4f:	e8 c1 0e 00 00       	call   f15 <printf>
  }
  if(mode == 3){ // start
      54:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
      58:	75 14                	jne    6e <print_usage+0x6e>
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
      5a:	c7 44 24 04 80 13 00 	movl   $0x1380,0x4(%esp)
      61:	00 
      62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      69:	e8 a7 0e 00 00       	call   f15 <printf>
  }
  if(mode == 4){ // delete
      6e:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
      72:	75 14                	jne    88 <print_usage+0x88>
    printf(1, "Usage: ctool delete <container>\n");
      74:	c7 44 24 04 b4 13 00 	movl   $0x13b4,0x4(%esp)
      7b:	00 
      7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      83:	e8 8d 0e 00 00       	call   f15 <printf>
  }
  
  exit();
      88:	e8 ab 0c 00 00       	call   d38 <exit>

0000008d <is_int>:
}

int is_int(char c){
      8d:	55                   	push   %ebp
      8e:	89 e5                	mov    %esp,%ebp
      90:	83 ec 04             	sub    $0x4,%esp
      93:	8b 45 08             	mov    0x8(%ebp),%eax
      96:	88 45 fc             	mov    %al,-0x4(%ebp)
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
      99:	80 7d fc 30          	cmpb   $0x30,-0x4(%ebp)
      9d:	74 36                	je     d5 <is_int+0x48>
  
  exit();
}

int is_int(char c){
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
      9f:	80 7d fc 31          	cmpb   $0x31,-0x4(%ebp)
      a3:	74 30                	je     d5 <is_int+0x48>
      a5:	80 7d fc 32          	cmpb   $0x32,-0x4(%ebp)
      a9:	74 2a                	je     d5 <is_int+0x48>
      ab:	80 7d fc 33          	cmpb   $0x33,-0x4(%ebp)
      af:	74 24                	je     d5 <is_int+0x48>
      b1:	80 7d fc 34          	cmpb   $0x34,-0x4(%ebp)
      b5:	74 1e                	je     d5 <is_int+0x48>
      b7:	80 7d fc 35          	cmpb   $0x35,-0x4(%ebp)
      bb:	74 18                	je     d5 <is_int+0x48>
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
      bd:	80 7d fc 36          	cmpb   $0x36,-0x4(%ebp)
      c1:	74 12                	je     d5 <is_int+0x48>
      c3:	80 7d fc 37          	cmpb   $0x37,-0x4(%ebp)
      c7:	74 0c                	je     d5 <is_int+0x48>
      c9:	80 7d fc 38          	cmpb   $0x38,-0x4(%ebp)
      cd:	74 06                	je     d5 <is_int+0x48>
      cf:	80 7d fc 39          	cmpb   $0x39,-0x4(%ebp)
      d3:	75 07                	jne    dc <is_int+0x4f>
      d5:	b8 01 00 00 00       	mov    $0x1,%eax
      da:	eb 05                	jmp    e1 <is_int+0x54>
      dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
      e1:	c9                   	leave  
      e2:	c3                   	ret    

000000e3 <start>:

// ctool start vc0 c0 usfsh
int start(int argc, char *argv[]){
      e3:	55                   	push   %ebp
      e4:	89 e5                	mov    %esp,%ebp
      e6:	83 ec 28             	sub    $0x28,%esp
  int id, fd;
  fd = open(argv[2], O_RDWR);
      e9:	8b 45 0c             	mov    0xc(%ebp),%eax
      ec:	83 c0 08             	add    $0x8,%eax
      ef:	8b 00                	mov    (%eax),%eax
      f1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
      f8:	00 
      f9:	89 04 24             	mov    %eax,(%esp)
      fc:	e8 77 0c 00 00       	call   d78 <open>
     101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "fd = %d\n", fd);
     104:	8b 45 f4             	mov    -0xc(%ebp),%eax
     107:	89 44 24 08          	mov    %eax,0x8(%esp)
     10b:	c7 44 24 04 d5 13 00 	movl   $0x13d5,0x4(%esp)
     112:	00 
     113:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     11a:	e8 f6 0d 00 00       	call   f15 <printf>
  /* fork a child and exec argv[4] */
  id = fork();
     11f:	e8 0c 0c 00 00       	call   d30 <fork>
     124:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(id == 0){
     127:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     12b:	0f 85 9c 00 00 00    	jne    1cd <start+0xea>
    close(0);
     131:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     138:	e8 23 0c 00 00       	call   d60 <close>
    close(1);
     13d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     144:	e8 17 0c 00 00       	call   d60 <close>
    close(2);
     149:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     150:	e8 0b 0c 00 00       	call   d60 <close>
    dup(fd);
     155:	8b 45 f4             	mov    -0xc(%ebp),%eax
     158:	89 04 24             	mov    %eax,(%esp)
     15b:	e8 50 0c 00 00       	call   db0 <dup>
    dup(fd);
     160:	8b 45 f4             	mov    -0xc(%ebp),%eax
     163:	89 04 24             	mov    %eax,(%esp)
     166:	e8 45 0c 00 00       	call   db0 <dup>
    dup(fd);
     16b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 3a 0c 00 00       	call   db0 <dup>
    if(chdir(argv[3]) < 0){
     176:	8b 45 0c             	mov    0xc(%ebp),%eax
     179:	83 c0 0c             	add    $0xc,%eax
     17c:	8b 00                	mov    (%eax),%eax
     17e:	89 04 24             	mov    %eax,(%esp)
     181:	e8 22 0c 00 00       	call   da8 <chdir>
     186:	85 c0                	test   %eax,%eax
     188:	79 19                	jns    1a3 <start+0xc0>
      printf(1, "Container does not exist.");
     18a:	c7 44 24 04 de 13 00 	movl   $0x13de,0x4(%esp)
     191:	00 
     192:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     199:	e8 77 0d 00 00       	call   f15 <printf>
      exit();
     19e:	e8 95 0b 00 00       	call   d38 <exit>
    }
    exec(argv[4], &argv[4]);
     1a3:	8b 45 0c             	mov    0xc(%ebp),%eax
     1a6:	8d 50 10             	lea    0x10(%eax),%edx
     1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     1ac:	83 c0 10             	add    $0x10,%eax
     1af:	8b 00                	mov    (%eax),%eax
     1b1:	89 54 24 04          	mov    %edx,0x4(%esp)
     1b5:	89 04 24             	mov    %eax,(%esp)
     1b8:	e8 b3 0b 00 00       	call   d70 <exec>
    close(fd);
     1bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c0:	89 04 24             	mov    %eax,(%esp)
     1c3:	e8 98 0b 00 00       	call   d60 <close>
    exit();
     1c8:	e8 6b 0b 00 00       	call   d38 <exit>
  }

  return 0;
     1cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
     1d2:	c9                   	leave  
     1d3:	c3                   	ret    

000001d4 <stop>:

int stop(char *argv[]){
     1d4:	55                   	push   %ebp
     1d5:	89 e5                	mov    %esp,%ebp
  // TODO: loop through processes and kill them
  return 1;
     1d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
     1dc:	5d                   	pop    %ebp
     1dd:	c3                   	ret    

000001de <create>:
//     }
//   }return 1;
// }

// ctool create c0 8 8 8 cat ls echo sh ...
int create(int argc, char *argv[]){
     1de:	55                   	push   %ebp
     1df:	89 e5                	mov    %esp,%ebp
     1e1:	53                   	push   %ebx
     1e2:	83 ec 54             	sub    $0x54,%esp
  int i, id, bytes, cindex = 0;
     1e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  // num_files = argc - 6;
  char *mkdir[2];
  // char *files[num_files];
  mkdir[0] = "mkdir";
     1ec:	c7 45 e0 f8 13 00 00 	movl   $0x13f8,-0x20(%ebp)
  mkdir[1] = argv[2];
     1f3:	8b 45 0c             	mov    0xc(%ebp),%eax
     1f6:	8b 40 08             	mov    0x8(%eax),%eax
     1f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  while(!is_int(argv[2][cindex])){
     1fc:	eb 03                	jmp    201 <create+0x23>
    cindex = cindex + 1;
     1fe:	ff 45 f0             	incl   -0x10(%ebp)
  char *mkdir[2];
  // char *files[num_files];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  while(!is_int(argv[2][cindex])){
     201:	8b 45 0c             	mov    0xc(%ebp),%eax
     204:	83 c0 08             	add    $0x8,%eax
     207:	8b 10                	mov    (%eax),%edx
     209:	8b 45 f0             	mov    -0x10(%ebp),%eax
     20c:	01 d0                	add    %edx,%eax
     20e:	8a 00                	mov    (%eax),%al
     210:	0f be c0             	movsbl %al,%eax
     213:	89 04 24             	mov    %eax,(%esp)
     216:	e8 72 fe ff ff       	call   8d <is_int>
     21b:	85 c0                	test   %eax,%eax
     21d:	74 df                	je     1fe <create+0x20>
    cindex = cindex + 1;
  }

  // strcpy(ctable.tuperwares[cindex].name, argv[2]);
  setname(cindex, argv[2]);
     21f:	8b 45 0c             	mov    0xc(%ebp),%eax
     222:	83 c0 08             	add    $0x8,%eax
     225:	8b 00                	mov    (%eax),%eax
     227:	89 44 24 04          	mov    %eax,0x4(%esp)
     22b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     22e:	89 04 24             	mov    %eax,(%esp)
     231:	e8 aa 0b 00 00       	call   de0 <setname>
  // ctable.tuperwares[cindex].max_mem = atoi(argv[4])*1000000;
  // ctable.tuperwares[cindex].max_disk = atoi(argv[5])*1000000;
  // ctable.tuperwares[cindex].used_mem = 0;
  // ctable.tuperwares[cindex].used_disk = 0;

  setmaxproc(cindex, atoi(argv[3]));
     236:	8b 45 0c             	mov    0xc(%ebp),%eax
     239:	83 c0 0c             	add    $0xc,%eax
     23c:	8b 00                	mov    (%eax),%eax
     23e:	89 04 24             	mov    %eax,(%esp)
     241:	e8 61 0a 00 00       	call   ca7 <atoi>
     246:	89 44 24 04          	mov    %eax,0x4(%esp)
     24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     24d:	89 04 24             	mov    %eax,(%esp)
     250:	e8 9b 0b 00 00       	call   df0 <setmaxproc>
  setmaxmem(cindex, atoi(argv[4]) * 1000000);
     255:	8b 45 0c             	mov    0xc(%ebp),%eax
     258:	83 c0 10             	add    $0x10,%eax
     25b:	8b 00                	mov    (%eax),%eax
     25d:	89 04 24             	mov    %eax,(%esp)
     260:	e8 42 0a 00 00       	call   ca7 <atoi>
     265:	89 c2                	mov    %eax,%edx
     267:	89 d0                	mov    %edx,%eax
     269:	c1 e0 02             	shl    $0x2,%eax
     26c:	01 d0                	add    %edx,%eax
     26e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     275:	01 d0                	add    %edx,%eax
     277:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     27e:	01 d0                	add    %edx,%eax
     280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     287:	01 d0                	add    %edx,%eax
     289:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     290:	01 d0                	add    %edx,%eax
     292:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     299:	01 d0                	add    %edx,%eax
     29b:	c1 e0 06             	shl    $0x6,%eax
     29e:	89 44 24 04          	mov    %eax,0x4(%esp)
     2a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2a5:	89 04 24             	mov    %eax,(%esp)
     2a8:	e8 53 0b 00 00       	call   e00 <setmaxmem>
  setmaxdisk(cindex, atoi(argv[5]) * 1000000);
     2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     2b0:	83 c0 14             	add    $0x14,%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	89 04 24             	mov    %eax,(%esp)
     2b8:	e8 ea 09 00 00       	call   ca7 <atoi>
     2bd:	89 c2                	mov    %eax,%edx
     2bf:	89 d0                	mov    %edx,%eax
     2c1:	c1 e0 02             	shl    $0x2,%eax
     2c4:	01 d0                	add    %edx,%eax
     2c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2cd:	01 d0                	add    %edx,%eax
     2cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2d6:	01 d0                	add    %edx,%eax
     2d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2df:	01 d0                	add    %edx,%eax
     2e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2e8:	01 d0                	add    %edx,%eax
     2ea:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2f1:	01 d0                	add    %edx,%eax
     2f3:	c1 e0 06             	shl    $0x6,%eax
     2f6:	89 44 24 04          	mov    %eax,0x4(%esp)
     2fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2fd:	89 04 24             	mov    %eax,(%esp)
     300:	e8 0b 0b 00 00       	call   e10 <setmaxdisk>
  setusedmem(cindex, 0);
     305:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     30c:	00 
     30d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     310:	89 04 24             	mov    %eax,(%esp)
     313:	e8 08 0b 00 00       	call   e20 <setusedmem>
  setuseddisk(cindex, 0);
     318:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     31f:	00 
     320:	8b 45 f0             	mov    -0x10(%ebp),%eax
     323:	89 04 24             	mov    %eax,(%esp)
     326:	e8 05 0b 00 00       	call   e30 <setuseddisk>


  id = fork();
     32b:	e8 00 0a 00 00       	call   d30 <fork>
     330:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0){
     333:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     337:	75 12                	jne    34b <create+0x16d>
    exec(mkdir[0], mkdir);
     339:	8b 45 e0             	mov    -0x20(%ebp),%eax
     33c:	8d 55 e0             	lea    -0x20(%ebp),%edx
     33f:	89 54 24 04          	mov    %edx,0x4(%esp)
     343:	89 04 24             	mov    %eax,(%esp)
     346:	e8 25 0a 00 00       	call   d70 <exec>
  }
  id = wait();
     34b:	e8 f0 09 00 00       	call   d40 <wait>
     350:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     353:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     35a:	e9 51 01 00 00       	jmp    4b0 <create+0x2d2>
    char destination[32];

    strcpy(destination, "/");
     35f:	c7 44 24 04 fe 13 00 	movl   $0x13fe,0x4(%esp)
     366:	00 
     367:	8d 45 b8             	lea    -0x48(%ebp),%eax
     36a:	89 04 24             	mov    %eax,(%esp)
     36d:	e8 3b 02 00 00       	call   5ad <strcpy>
    strcat(destination, mkdir[1]);
     372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     375:	89 44 24 04          	mov    %eax,0x4(%esp)
     379:	8d 45 b8             	lea    -0x48(%ebp),%eax
     37c:	89 04 24             	mov    %eax,(%esp)
     37f:	e8 56 04 00 00       	call   7da <strcat>
    strcat(destination, "/");
     384:	c7 44 24 04 fe 13 00 	movl   $0x13fe,0x4(%esp)
     38b:	00 
     38c:	8d 45 b8             	lea    -0x48(%ebp),%eax
     38f:	89 04 24             	mov    %eax,(%esp)
     392:	e8 43 04 00 00       	call   7da <strcat>
    strcat(destination, argv[i]);
     397:	8b 45 f4             	mov    -0xc(%ebp),%eax
     39a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
     3a4:	01 d0                	add    %edx,%eax
     3a6:	8b 00                	mov    (%eax),%eax
     3a8:	89 44 24 04          	mov    %eax,0x4(%esp)
     3ac:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3af:	89 04 24             	mov    %eax,(%esp)
     3b2:	e8 23 04 00 00       	call   7da <strcat>
    strcat(destination, "\0");
     3b7:	c7 44 24 04 00 14 00 	movl   $0x1400,0x4(%esp)
     3be:	00 
     3bf:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3c2:	89 04 24             	mov    %eax,(%esp)
     3c5:	e8 10 04 00 00       	call   7da <strcat>

    // ctable.tuperwares[i].files[i-6] = argv[i];
    bytes = copy(argv[i], destination, getuseddisk(cindex), getmaxdisk(cindex));
     3ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3cd:	89 04 24             	mov    %eax,(%esp)
     3d0:	e8 33 0a 00 00       	call   e08 <getmaxdisk>
     3d5:	89 c3                	mov    %eax,%ebx
     3d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3da:	89 04 24             	mov    %eax,(%esp)
     3dd:	e8 46 0a 00 00       	call   e28 <getuseddisk>
     3e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     3e5:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
     3ec:	8b 55 0c             	mov    0xc(%ebp),%edx
     3ef:	01 ca                	add    %ecx,%edx
     3f1:	8b 12                	mov    (%edx),%edx
     3f3:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     3f7:	89 44 24 08          	mov    %eax,0x8(%esp)
     3fb:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3fe:	89 44 24 04          	mov    %eax,0x4(%esp)
     402:	89 14 24             	mov    %edx,(%esp)
     405:	e8 d1 01 00 00       	call   5db <copy>
     40a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Bytes for each file: %d\n", bytes);
     40d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     410:	89 44 24 08          	mov    %eax,0x8(%esp)
     414:	c7 44 24 04 02 14 00 	movl   $0x1402,0x4(%esp)
     41b:	00 
     41c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     423:	e8 ed 0a 00 00       	call   f15 <printf>

    if(bytes > 0){
     428:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     42c:	7e 21                	jle    44f <create+0x271>
      setuseddisk(cindex, getuseddisk(cindex) + bytes);
     42e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     431:	89 04 24             	mov    %eax,(%esp)
     434:	e8 ef 09 00 00       	call   e28 <getuseddisk>
     439:	8b 55 e8             	mov    -0x18(%ebp),%edx
     43c:	01 d0                	add    %edx,%eax
     43e:	89 44 24 04          	mov    %eax,0x4(%esp)
     442:	8b 45 f0             	mov    -0x10(%ebp),%eax
     445:	89 04 24             	mov    %eax,(%esp)
     448:	e8 e3 09 00 00       	call   e30 <setuseddisk>
     44d:	eb 5e                	jmp    4ad <create+0x2cf>
      // ctable.tuperwares[cindex].used_disk += bytes; 
    }
    else{
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
     44f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     452:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     459:	8b 45 0c             	mov    0xc(%ebp),%eax
     45c:	01 d0                	add    %edx,%eax
     45e:	8b 00                	mov    (%eax),%eax
     460:	89 44 24 08          	mov    %eax,0x8(%esp)
     464:	c7 44 24 04 1c 14 00 	movl   $0x141c,0x4(%esp)
     46b:	00 
     46c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     473:	e8 9d 0a 00 00       	call   f15 <printf>
      id = fork();
     478:	e8 b3 08 00 00       	call   d30 <fork>
     47d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(id == 0){
     480:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     484:	75 1f                	jne    4a5 <create+0x2c7>
        char *remove_args[2];
        remove_args[0] = "rm";
     486:	c7 45 d8 72 14 00 00 	movl   $0x1472,-0x28(%ebp)
        remove_args[1] = destination;
     48d:	8d 45 b8             	lea    -0x48(%ebp),%eax
     490:	89 45 dc             	mov    %eax,-0x24(%ebp)
        exec(remove_args[0], remove_args);
     493:	8b 45 d8             	mov    -0x28(%ebp),%eax
     496:	8d 55 d8             	lea    -0x28(%ebp),%edx
     499:	89 54 24 04          	mov    %edx,0x4(%esp)
     49d:	89 04 24             	mov    %eax,(%esp)
     4a0:	e8 cb 08 00 00       	call   d70 <exec>
      }
      id = wait();
     4a5:	e8 96 08 00 00       	call   d40 <wait>
     4aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0){
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     4ad:	ff 45 f4             	incl   -0xc(%ebp)
     4b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b3:	3b 45 08             	cmp    0x8(%ebp),%eax
     4b6:	0f 8c a3 fe ff ff    	jl     35f <create+0x181>
      id = wait();
    }
  }
  // TODO: IMPLEMENT GET/SET FILES
  // ctable.tuperwares[cindex].files = files;
  return 0;
     4bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
     4c1:	83 c4 54             	add    $0x54,%esp
     4c4:	5b                   	pop    %ebx
     4c5:	5d                   	pop    %ebp
     4c6:	c3                   	ret    

000004c7 <main>:

int main(int argc, char *argv[]){
     4c7:	55                   	push   %ebp
     4c8:	89 e5                	mov    %esp,%ebp
     4ca:	83 e4 f0             	and    $0xfffffff0,%esp
     4cd:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2){
     4d0:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     4d4:	7f 0c                	jg     4e2 <main+0x1b>
    print_usage(0);
     4d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4dd:	e8 1e fb ff ff       	call   0 <print_usage>
  }

  if(strcmp(argv[1], "create") == 0){
     4e2:	8b 45 0c             	mov    0xc(%ebp),%eax
     4e5:	83 c0 04             	add    $0x4,%eax
     4e8:	8b 00                	mov    (%eax),%eax
     4ea:	c7 44 24 04 75 14 00 	movl   $0x1475,0x4(%esp)
     4f1:	00 
     4f2:	89 04 24             	mov    %eax,(%esp)
     4f5:	e8 e1 01 00 00       	call   6db <strcmp>
     4fa:	85 c0                	test   %eax,%eax
     4fc:	75 44                	jne    542 <main+0x7b>
    if(argc < 7){
     4fe:	83 7d 08 06          	cmpl   $0x6,0x8(%ebp)
     502:	7f 0c                	jg     510 <main+0x49>
      print_usage(1);
     504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     50b:	e8 f0 fa ff ff       	call   0 <print_usage>
    }
    if(chdir(argv[2]) > 0){
     510:	8b 45 0c             	mov    0xc(%ebp),%eax
     513:	83 c0 08             	add    $0x8,%eax
     516:	8b 00                	mov    (%eax),%eax
     518:	89 04 24             	mov    %eax,(%esp)
     51b:	e8 88 08 00 00       	call   da8 <chdir>
     520:	85 c0                	test   %eax,%eax
     522:	7e 0c                	jle    530 <main+0x69>
      print_usage(2);
     524:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     52b:	e8 d0 fa ff ff       	call   0 <print_usage>
    }
    create(argc, argv);
     530:	8b 45 0c             	mov    0xc(%ebp),%eax
     533:	89 44 24 04          	mov    %eax,0x4(%esp)
     537:	8b 45 08             	mov    0x8(%ebp),%eax
     53a:	89 04 24             	mov    %eax,(%esp)
     53d:	e8 9c fc ff ff       	call   1de <create>
  }

  if(strcmp(argv[1], "start") == 0){
     542:	8b 45 0c             	mov    0xc(%ebp),%eax
     545:	83 c0 04             	add    $0x4,%eax
     548:	8b 00                	mov    (%eax),%eax
     54a:	c7 44 24 04 7c 14 00 	movl   $0x147c,0x4(%esp)
     551:	00 
     552:	89 04 24             	mov    %eax,(%esp)
     555:	e8 81 01 00 00       	call   6db <strcmp>
     55a:	85 c0                	test   %eax,%eax
     55c:	75 24                	jne    582 <main+0xbb>
    if(argc < 5){
     55e:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     562:	7f 0c                	jg     570 <main+0xa9>
      print_usage(3);
     564:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     56b:	e8 90 fa ff ff       	call   0 <print_usage>
    }
    start(argc, argv);
     570:	8b 45 0c             	mov    0xc(%ebp),%eax
     573:	89 44 24 04          	mov    %eax,0x4(%esp)
     577:	8b 45 08             	mov    0x8(%ebp),%eax
     57a:	89 04 24             	mov    %eax,(%esp)
     57d:	e8 61 fb ff ff       	call   e3 <start>
  //   if(argc < 3){
  //     print_usage(4);
  //   }
  //   delete(argv);
  // }
  exit();
     582:	e8 b1 07 00 00       	call   d38 <exit>
     587:	90                   	nop

00000588 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     588:	55                   	push   %ebp
     589:	89 e5                	mov    %esp,%ebp
     58b:	57                   	push   %edi
     58c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     58d:	8b 4d 08             	mov    0x8(%ebp),%ecx
     590:	8b 55 10             	mov    0x10(%ebp),%edx
     593:	8b 45 0c             	mov    0xc(%ebp),%eax
     596:	89 cb                	mov    %ecx,%ebx
     598:	89 df                	mov    %ebx,%edi
     59a:	89 d1                	mov    %edx,%ecx
     59c:	fc                   	cld    
     59d:	f3 aa                	rep stos %al,%es:(%edi)
     59f:	89 ca                	mov    %ecx,%edx
     5a1:	89 fb                	mov    %edi,%ebx
     5a3:	89 5d 08             	mov    %ebx,0x8(%ebp)
     5a6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     5a9:	5b                   	pop    %ebx
     5aa:	5f                   	pop    %edi
     5ab:	5d                   	pop    %ebp
     5ac:	c3                   	ret    

000005ad <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     5ad:	55                   	push   %ebp
     5ae:	89 e5                	mov    %esp,%ebp
     5b0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     5b3:	8b 45 08             	mov    0x8(%ebp),%eax
     5b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     5b9:	90                   	nop
     5ba:	8b 45 08             	mov    0x8(%ebp),%eax
     5bd:	8d 50 01             	lea    0x1(%eax),%edx
     5c0:	89 55 08             	mov    %edx,0x8(%ebp)
     5c3:	8b 55 0c             	mov    0xc(%ebp),%edx
     5c6:	8d 4a 01             	lea    0x1(%edx),%ecx
     5c9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     5cc:	8a 12                	mov    (%edx),%dl
     5ce:	88 10                	mov    %dl,(%eax)
     5d0:	8a 00                	mov    (%eax),%al
     5d2:	84 c0                	test   %al,%al
     5d4:	75 e4                	jne    5ba <strcpy+0xd>
    ;
  return os;
     5d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     5d9:	c9                   	leave  
     5da:	c3                   	ret    

000005db <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     5db:	55                   	push   %ebp
     5dc:	89 e5                	mov    %esp,%ebp
     5de:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     5e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     5e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5ef:	00 
     5f0:	8b 45 08             	mov    0x8(%ebp),%eax
     5f3:	89 04 24             	mov    %eax,(%esp)
     5f6:	e8 7d 07 00 00       	call   d78 <open>
     5fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
     5fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     602:	79 20                	jns    624 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     604:	8b 45 08             	mov    0x8(%ebp),%eax
     607:	89 44 24 08          	mov    %eax,0x8(%esp)
     60b:	c7 44 24 04 82 14 00 	movl   $0x1482,0x4(%esp)
     612:	00 
     613:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     61a:	e8 f6 08 00 00       	call   f15 <printf>
      exit();
     61f:	e8 14 07 00 00       	call   d38 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     624:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     62b:	00 
     62c:	8b 45 0c             	mov    0xc(%ebp),%eax
     62f:	89 04 24             	mov    %eax,(%esp)
     632:	e8 41 07 00 00       	call   d78 <open>
     637:	89 45 ec             	mov    %eax,-0x14(%ebp)
     63a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     63e:	79 20                	jns    660 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     640:	8b 45 0c             	mov    0xc(%ebp),%eax
     643:	89 44 24 08          	mov    %eax,0x8(%esp)
     647:	c7 44 24 04 9d 14 00 	movl   $0x149d,0x4(%esp)
     64e:	00 
     64f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     656:	e8 ba 08 00 00       	call   f15 <printf>
      exit();
     65b:	e8 d8 06 00 00       	call   d38 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     660:	eb 3b                	jmp    69d <copy+0xc2>
  {
      max = used_disk+=count;
     662:	8b 45 e8             	mov    -0x18(%ebp),%eax
     665:	01 45 10             	add    %eax,0x10(%ebp)
     668:	8b 45 10             	mov    0x10(%ebp),%eax
     66b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     66e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     671:	3b 45 14             	cmp    0x14(%ebp),%eax
     674:	7e 07                	jle    67d <copy+0xa2>
      {
        return -1;
     676:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     67b:	eb 5c                	jmp    6d9 <copy+0xfe>
      }
      bytes = bytes + count;
     67d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     680:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     683:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     68a:	00 
     68b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     68e:	89 44 24 04          	mov    %eax,0x4(%esp)
     692:	8b 45 ec             	mov    -0x14(%ebp),%eax
     695:	89 04 24             	mov    %eax,(%esp)
     698:	e8 bb 06 00 00       	call   d58 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     69d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     6a4:	00 
     6a5:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
     6ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6af:	89 04 24             	mov    %eax,(%esp)
     6b2:	e8 99 06 00 00       	call   d50 <read>
     6b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
     6ba:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     6be:	7f a2                	jg     662 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     6c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6c3:	89 04 24             	mov    %eax,(%esp)
     6c6:	e8 95 06 00 00       	call   d60 <close>
  close(fd2);
     6cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6ce:	89 04 24             	mov    %eax,(%esp)
     6d1:	e8 8a 06 00 00       	call   d60 <close>
  return(bytes);
     6d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6d9:	c9                   	leave  
     6da:	c3                   	ret    

000006db <strcmp>:

int
strcmp(const char *p, const char *q)
{
     6db:	55                   	push   %ebp
     6dc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     6de:	eb 06                	jmp    6e6 <strcmp+0xb>
    p++, q++;
     6e0:	ff 45 08             	incl   0x8(%ebp)
     6e3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     6e6:	8b 45 08             	mov    0x8(%ebp),%eax
     6e9:	8a 00                	mov    (%eax),%al
     6eb:	84 c0                	test   %al,%al
     6ed:	74 0e                	je     6fd <strcmp+0x22>
     6ef:	8b 45 08             	mov    0x8(%ebp),%eax
     6f2:	8a 10                	mov    (%eax),%dl
     6f4:	8b 45 0c             	mov    0xc(%ebp),%eax
     6f7:	8a 00                	mov    (%eax),%al
     6f9:	38 c2                	cmp    %al,%dl
     6fb:	74 e3                	je     6e0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     6fd:	8b 45 08             	mov    0x8(%ebp),%eax
     700:	8a 00                	mov    (%eax),%al
     702:	0f b6 d0             	movzbl %al,%edx
     705:	8b 45 0c             	mov    0xc(%ebp),%eax
     708:	8a 00                	mov    (%eax),%al
     70a:	0f b6 c0             	movzbl %al,%eax
     70d:	29 c2                	sub    %eax,%edx
     70f:	89 d0                	mov    %edx,%eax
}
     711:	5d                   	pop    %ebp
     712:	c3                   	ret    

00000713 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     713:	55                   	push   %ebp
     714:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     716:	eb 09                	jmp    721 <strncmp+0xe>
    n--, p++, q++;
     718:	ff 4d 10             	decl   0x10(%ebp)
     71b:	ff 45 08             	incl   0x8(%ebp)
     71e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     721:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     725:	74 17                	je     73e <strncmp+0x2b>
     727:	8b 45 08             	mov    0x8(%ebp),%eax
     72a:	8a 00                	mov    (%eax),%al
     72c:	84 c0                	test   %al,%al
     72e:	74 0e                	je     73e <strncmp+0x2b>
     730:	8b 45 08             	mov    0x8(%ebp),%eax
     733:	8a 10                	mov    (%eax),%dl
     735:	8b 45 0c             	mov    0xc(%ebp),%eax
     738:	8a 00                	mov    (%eax),%al
     73a:	38 c2                	cmp    %al,%dl
     73c:	74 da                	je     718 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     73e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     742:	75 07                	jne    74b <strncmp+0x38>
    return 0;
     744:	b8 00 00 00 00       	mov    $0x0,%eax
     749:	eb 14                	jmp    75f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     74b:	8b 45 08             	mov    0x8(%ebp),%eax
     74e:	8a 00                	mov    (%eax),%al
     750:	0f b6 d0             	movzbl %al,%edx
     753:	8b 45 0c             	mov    0xc(%ebp),%eax
     756:	8a 00                	mov    (%eax),%al
     758:	0f b6 c0             	movzbl %al,%eax
     75b:	29 c2                	sub    %eax,%edx
     75d:	89 d0                	mov    %edx,%eax
}
     75f:	5d                   	pop    %ebp
     760:	c3                   	ret    

00000761 <strlen>:

uint
strlen(const char *s)
{
     761:	55                   	push   %ebp
     762:	89 e5                	mov    %esp,%ebp
     764:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     767:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     76e:	eb 03                	jmp    773 <strlen+0x12>
     770:	ff 45 fc             	incl   -0x4(%ebp)
     773:	8b 55 fc             	mov    -0x4(%ebp),%edx
     776:	8b 45 08             	mov    0x8(%ebp),%eax
     779:	01 d0                	add    %edx,%eax
     77b:	8a 00                	mov    (%eax),%al
     77d:	84 c0                	test   %al,%al
     77f:	75 ef                	jne    770 <strlen+0xf>
    ;
  return n;
     781:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     784:	c9                   	leave  
     785:	c3                   	ret    

00000786 <memset>:

void*
memset(void *dst, int c, uint n)
{
     786:	55                   	push   %ebp
     787:	89 e5                	mov    %esp,%ebp
     789:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     78c:	8b 45 10             	mov    0x10(%ebp),%eax
     78f:	89 44 24 08          	mov    %eax,0x8(%esp)
     793:	8b 45 0c             	mov    0xc(%ebp),%eax
     796:	89 44 24 04          	mov    %eax,0x4(%esp)
     79a:	8b 45 08             	mov    0x8(%ebp),%eax
     79d:	89 04 24             	mov    %eax,(%esp)
     7a0:	e8 e3 fd ff ff       	call   588 <stosb>
  return dst;
     7a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     7a8:	c9                   	leave  
     7a9:	c3                   	ret    

000007aa <strchr>:

char*
strchr(const char *s, char c)
{
     7aa:	55                   	push   %ebp
     7ab:	89 e5                	mov    %esp,%ebp
     7ad:	83 ec 04             	sub    $0x4,%esp
     7b0:	8b 45 0c             	mov    0xc(%ebp),%eax
     7b3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     7b6:	eb 12                	jmp    7ca <strchr+0x20>
    if(*s == c)
     7b8:	8b 45 08             	mov    0x8(%ebp),%eax
     7bb:	8a 00                	mov    (%eax),%al
     7bd:	3a 45 fc             	cmp    -0x4(%ebp),%al
     7c0:	75 05                	jne    7c7 <strchr+0x1d>
      return (char*)s;
     7c2:	8b 45 08             	mov    0x8(%ebp),%eax
     7c5:	eb 11                	jmp    7d8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     7c7:	ff 45 08             	incl   0x8(%ebp)
     7ca:	8b 45 08             	mov    0x8(%ebp),%eax
     7cd:	8a 00                	mov    (%eax),%al
     7cf:	84 c0                	test   %al,%al
     7d1:	75 e5                	jne    7b8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     7d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7d8:	c9                   	leave  
     7d9:	c3                   	ret    

000007da <strcat>:

char *
strcat(char *dest, const char *src)
{
     7da:	55                   	push   %ebp
     7db:	89 e5                	mov    %esp,%ebp
     7dd:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     7e0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     7e7:	eb 03                	jmp    7ec <strcat+0x12>
     7e9:	ff 45 fc             	incl   -0x4(%ebp)
     7ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
     7ef:	8b 45 08             	mov    0x8(%ebp),%eax
     7f2:	01 d0                	add    %edx,%eax
     7f4:	8a 00                	mov    (%eax),%al
     7f6:	84 c0                	test   %al,%al
     7f8:	75 ef                	jne    7e9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     7fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     801:	eb 1e                	jmp    821 <strcat+0x47>
        dest[i+j] = src[j];
     803:	8b 45 f8             	mov    -0x8(%ebp),%eax
     806:	8b 55 fc             	mov    -0x4(%ebp),%edx
     809:	01 d0                	add    %edx,%eax
     80b:	89 c2                	mov    %eax,%edx
     80d:	8b 45 08             	mov    0x8(%ebp),%eax
     810:	01 c2                	add    %eax,%edx
     812:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     815:	8b 45 0c             	mov    0xc(%ebp),%eax
     818:	01 c8                	add    %ecx,%eax
     81a:	8a 00                	mov    (%eax),%al
     81c:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     81e:	ff 45 f8             	incl   -0x8(%ebp)
     821:	8b 55 f8             	mov    -0x8(%ebp),%edx
     824:	8b 45 0c             	mov    0xc(%ebp),%eax
     827:	01 d0                	add    %edx,%eax
     829:	8a 00                	mov    (%eax),%al
     82b:	84 c0                	test   %al,%al
     82d:	75 d4                	jne    803 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     82f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     832:	8b 55 fc             	mov    -0x4(%ebp),%edx
     835:	01 d0                	add    %edx,%eax
     837:	89 c2                	mov    %eax,%edx
     839:	8b 45 08             	mov    0x8(%ebp),%eax
     83c:	01 d0                	add    %edx,%eax
     83e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     841:	8b 45 08             	mov    0x8(%ebp),%eax
}
     844:	c9                   	leave  
     845:	c3                   	ret    

00000846 <strstr>:

int 
strstr(char* s, char* sub)
{
     846:	55                   	push   %ebp
     847:	89 e5                	mov    %esp,%ebp
     849:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     84c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     853:	eb 7c                	jmp    8d1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     855:	8b 55 fc             	mov    -0x4(%ebp),%edx
     858:	8b 45 08             	mov    0x8(%ebp),%eax
     85b:	01 d0                	add    %edx,%eax
     85d:	8a 10                	mov    (%eax),%dl
     85f:	8b 45 0c             	mov    0xc(%ebp),%eax
     862:	8a 00                	mov    (%eax),%al
     864:	38 c2                	cmp    %al,%dl
     866:	75 66                	jne    8ce <strstr+0x88>
        {
            if(strlen(sub) == 1)
     868:	8b 45 0c             	mov    0xc(%ebp),%eax
     86b:	89 04 24             	mov    %eax,(%esp)
     86e:	e8 ee fe ff ff       	call   761 <strlen>
     873:	83 f8 01             	cmp    $0x1,%eax
     876:	75 05                	jne    87d <strstr+0x37>
            {  
                return i;
     878:	8b 45 fc             	mov    -0x4(%ebp),%eax
     87b:	eb 6b                	jmp    8e8 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     87d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     884:	eb 3a                	jmp    8c0 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     886:	8b 45 f8             	mov    -0x8(%ebp),%eax
     889:	8b 55 fc             	mov    -0x4(%ebp),%edx
     88c:	01 d0                	add    %edx,%eax
     88e:	89 c2                	mov    %eax,%edx
     890:	8b 45 08             	mov    0x8(%ebp),%eax
     893:	01 d0                	add    %edx,%eax
     895:	8a 10                	mov    (%eax),%dl
     897:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     89a:	8b 45 0c             	mov    0xc(%ebp),%eax
     89d:	01 c8                	add    %ecx,%eax
     89f:	8a 00                	mov    (%eax),%al
     8a1:	38 c2                	cmp    %al,%dl
     8a3:	75 16                	jne    8bb <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     8a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8a8:	8d 50 01             	lea    0x1(%eax),%edx
     8ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     8ae:	01 d0                	add    %edx,%eax
     8b0:	8a 00                	mov    (%eax),%al
     8b2:	84 c0                	test   %al,%al
     8b4:	75 07                	jne    8bd <strstr+0x77>
                    {
                        return i;
     8b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8b9:	eb 2d                	jmp    8e8 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     8bb:	eb 11                	jmp    8ce <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     8bd:	ff 45 f8             	incl   -0x8(%ebp)
     8c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
     8c3:	8b 45 0c             	mov    0xc(%ebp),%eax
     8c6:	01 d0                	add    %edx,%eax
     8c8:	8a 00                	mov    (%eax),%al
     8ca:	84 c0                	test   %al,%al
     8cc:	75 b8                	jne    886 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     8ce:	ff 45 fc             	incl   -0x4(%ebp)
     8d1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     8d4:	8b 45 08             	mov    0x8(%ebp),%eax
     8d7:	01 d0                	add    %edx,%eax
     8d9:	8a 00                	mov    (%eax),%al
     8db:	84 c0                	test   %al,%al
     8dd:	0f 85 72 ff ff ff    	jne    855 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     8e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     8e8:	c9                   	leave  
     8e9:	c3                   	ret    

000008ea <strtok>:

char *
strtok(char *s, const char *delim)
{
     8ea:	55                   	push   %ebp
     8eb:	89 e5                	mov    %esp,%ebp
     8ed:	53                   	push   %ebx
     8ee:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     8f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     8f5:	75 08                	jne    8ff <strtok+0x15>
  s = lasts;
     8f7:	a1 44 19 00 00       	mov    0x1944,%eax
     8fc:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     8ff:	8b 45 08             	mov    0x8(%ebp),%eax
     902:	8d 50 01             	lea    0x1(%eax),%edx
     905:	89 55 08             	mov    %edx,0x8(%ebp)
     908:	8a 00                	mov    (%eax),%al
     90a:	0f be d8             	movsbl %al,%ebx
     90d:	85 db                	test   %ebx,%ebx
     90f:	75 07                	jne    918 <strtok+0x2e>
      return 0;
     911:	b8 00 00 00 00       	mov    $0x0,%eax
     916:	eb 58                	jmp    970 <strtok+0x86>
    } while (strchr(delim, ch));
     918:	88 d8                	mov    %bl,%al
     91a:	0f be c0             	movsbl %al,%eax
     91d:	89 44 24 04          	mov    %eax,0x4(%esp)
     921:	8b 45 0c             	mov    0xc(%ebp),%eax
     924:	89 04 24             	mov    %eax,(%esp)
     927:	e8 7e fe ff ff       	call   7aa <strchr>
     92c:	85 c0                	test   %eax,%eax
     92e:	75 cf                	jne    8ff <strtok+0x15>
    --s;
     930:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     933:	8b 45 0c             	mov    0xc(%ebp),%eax
     936:	89 44 24 04          	mov    %eax,0x4(%esp)
     93a:	8b 45 08             	mov    0x8(%ebp),%eax
     93d:	89 04 24             	mov    %eax,(%esp)
     940:	e8 31 00 00 00       	call   976 <strcspn>
     945:	89 c2                	mov    %eax,%edx
     947:	8b 45 08             	mov    0x8(%ebp),%eax
     94a:	01 d0                	add    %edx,%eax
     94c:	a3 44 19 00 00       	mov    %eax,0x1944
    if (*lasts != 0)
     951:	a1 44 19 00 00       	mov    0x1944,%eax
     956:	8a 00                	mov    (%eax),%al
     958:	84 c0                	test   %al,%al
     95a:	74 11                	je     96d <strtok+0x83>
  *lasts++ = 0;
     95c:	a1 44 19 00 00       	mov    0x1944,%eax
     961:	8d 50 01             	lea    0x1(%eax),%edx
     964:	89 15 44 19 00 00    	mov    %edx,0x1944
     96a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     96d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     970:	83 c4 14             	add    $0x14,%esp
     973:	5b                   	pop    %ebx
     974:	5d                   	pop    %ebp
     975:	c3                   	ret    

00000976 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     976:	55                   	push   %ebp
     977:	89 e5                	mov    %esp,%ebp
     979:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     97c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     983:	eb 26                	jmp    9ab <strcspn+0x35>
        if(strchr(s2,*s1))
     985:	8b 45 08             	mov    0x8(%ebp),%eax
     988:	8a 00                	mov    (%eax),%al
     98a:	0f be c0             	movsbl %al,%eax
     98d:	89 44 24 04          	mov    %eax,0x4(%esp)
     991:	8b 45 0c             	mov    0xc(%ebp),%eax
     994:	89 04 24             	mov    %eax,(%esp)
     997:	e8 0e fe ff ff       	call   7aa <strchr>
     99c:	85 c0                	test   %eax,%eax
     99e:	74 05                	je     9a5 <strcspn+0x2f>
            return ret;
     9a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9a3:	eb 12                	jmp    9b7 <strcspn+0x41>
        else
            s1++,ret++;
     9a5:	ff 45 08             	incl   0x8(%ebp)
     9a8:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     9ab:	8b 45 08             	mov    0x8(%ebp),%eax
     9ae:	8a 00                	mov    (%eax),%al
     9b0:	84 c0                	test   %al,%al
     9b2:	75 d1                	jne    985 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     9b7:	c9                   	leave  
     9b8:	c3                   	ret    

000009b9 <isspace>:

int
isspace(unsigned char c)
{
     9b9:	55                   	push   %ebp
     9ba:	89 e5                	mov    %esp,%ebp
     9bc:	83 ec 04             	sub    $0x4,%esp
     9bf:	8b 45 08             	mov    0x8(%ebp),%eax
     9c2:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     9c5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     9c9:	74 1e                	je     9e9 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     9cb:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     9cf:	74 18                	je     9e9 <isspace+0x30>
     9d1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     9d5:	74 12                	je     9e9 <isspace+0x30>
     9d7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     9db:	74 0c                	je     9e9 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     9dd:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     9e1:	74 06                	je     9e9 <isspace+0x30>
     9e3:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     9e7:	75 07                	jne    9f0 <isspace+0x37>
     9e9:	b8 01 00 00 00       	mov    $0x1,%eax
     9ee:	eb 05                	jmp    9f5 <isspace+0x3c>
     9f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
     9f5:	c9                   	leave  
     9f6:	c3                   	ret    

000009f7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     9f7:	55                   	push   %ebp
     9f8:	89 e5                	mov    %esp,%ebp
     9fa:	57                   	push   %edi
     9fb:	56                   	push   %esi
     9fc:	53                   	push   %ebx
     9fd:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     a00:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     a05:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     a0f:	eb 01                	jmp    a12 <strtoul+0x1b>
  p += 1;
     a11:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     a12:	8a 03                	mov    (%ebx),%al
     a14:	0f b6 c0             	movzbl %al,%eax
     a17:	89 04 24             	mov    %eax,(%esp)
     a1a:	e8 9a ff ff ff       	call   9b9 <isspace>
     a1f:	85 c0                	test   %eax,%eax
     a21:	75 ee                	jne    a11 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     a23:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     a27:	75 30                	jne    a59 <strtoul+0x62>
    {
  if (*p == '0') {
     a29:	8a 03                	mov    (%ebx),%al
     a2b:	3c 30                	cmp    $0x30,%al
     a2d:	75 21                	jne    a50 <strtoul+0x59>
      p += 1;
     a2f:	43                   	inc    %ebx
      if (*p == 'x') {
     a30:	8a 03                	mov    (%ebx),%al
     a32:	3c 78                	cmp    $0x78,%al
     a34:	75 0a                	jne    a40 <strtoul+0x49>
    p += 1;
     a36:	43                   	inc    %ebx
    base = 16;
     a37:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     a3e:	eb 31                	jmp    a71 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     a40:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     a47:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     a4e:	eb 21                	jmp    a71 <strtoul+0x7a>
      }
  }
  else base = 10;
     a50:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     a57:	eb 18                	jmp    a71 <strtoul+0x7a>
    } else if (base == 16) {
     a59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     a5d:	75 12                	jne    a71 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     a5f:	8a 03                	mov    (%ebx),%al
     a61:	3c 30                	cmp    $0x30,%al
     a63:	75 0c                	jne    a71 <strtoul+0x7a>
     a65:	8d 43 01             	lea    0x1(%ebx),%eax
     a68:	8a 00                	mov    (%eax),%al
     a6a:	3c 78                	cmp    $0x78,%al
     a6c:	75 03                	jne    a71 <strtoul+0x7a>
      p += 2;
     a6e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     a71:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     a75:	75 29                	jne    aa0 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     a77:	8a 03                	mov    (%ebx),%al
     a79:	0f be c0             	movsbl %al,%eax
     a7c:	83 e8 30             	sub    $0x30,%eax
     a7f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     a81:	83 fe 07             	cmp    $0x7,%esi
     a84:	76 06                	jbe    a8c <strtoul+0x95>
    break;
     a86:	90                   	nop
     a87:	e9 b6 00 00 00       	jmp    b42 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     a8c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     a93:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     a96:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     a9d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     a9e:	eb d7                	jmp    a77 <strtoul+0x80>
    } else if (base == 10) {
     aa0:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     aa4:	75 2b                	jne    ad1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     aa6:	8a 03                	mov    (%ebx),%al
     aa8:	0f be c0             	movsbl %al,%eax
     aab:	83 e8 30             	sub    $0x30,%eax
     aae:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     ab0:	83 fe 09             	cmp    $0x9,%esi
     ab3:	76 06                	jbe    abb <strtoul+0xc4>
    break;
     ab5:	90                   	nop
     ab6:	e9 87 00 00 00       	jmp    b42 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     abb:	89 f8                	mov    %edi,%eax
     abd:	c1 e0 02             	shl    $0x2,%eax
     ac0:	01 f8                	add    %edi,%eax
     ac2:	01 c0                	add    %eax,%eax
     ac4:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     ac7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     ace:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     acf:	eb d5                	jmp    aa6 <strtoul+0xaf>
    } else if (base == 16) {
     ad1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     ad5:	75 35                	jne    b0c <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     ad7:	8a 03                	mov    (%ebx),%al
     ad9:	0f be c0             	movsbl %al,%eax
     adc:	83 e8 30             	sub    $0x30,%eax
     adf:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     ae1:	83 fe 4a             	cmp    $0x4a,%esi
     ae4:	76 02                	jbe    ae8 <strtoul+0xf1>
    break;
     ae6:	eb 22                	jmp    b0a <strtoul+0x113>
      }
      digit = cvtIn[digit];
     ae8:	8a 86 e0 18 00 00    	mov    0x18e0(%esi),%al
     aee:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     af1:	83 fe 0f             	cmp    $0xf,%esi
     af4:	76 02                	jbe    af8 <strtoul+0x101>
    break;
     af6:	eb 12                	jmp    b0a <strtoul+0x113>
      }
      result = (result << 4) + digit;
     af8:	89 f8                	mov    %edi,%eax
     afa:	c1 e0 04             	shl    $0x4,%eax
     afd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b00:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     b07:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     b08:	eb cd                	jmp    ad7 <strtoul+0xe0>
     b0a:	eb 36                	jmp    b42 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     b0c:	8a 03                	mov    (%ebx),%al
     b0e:	0f be c0             	movsbl %al,%eax
     b11:	83 e8 30             	sub    $0x30,%eax
     b14:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     b16:	83 fe 4a             	cmp    $0x4a,%esi
     b19:	76 02                	jbe    b1d <strtoul+0x126>
    break;
     b1b:	eb 25                	jmp    b42 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     b1d:	8a 86 e0 18 00 00    	mov    0x18e0(%esi),%al
     b23:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     b26:	8b 45 10             	mov    0x10(%ebp),%eax
     b29:	39 f0                	cmp    %esi,%eax
     b2b:	77 02                	ja     b2f <strtoul+0x138>
    break;
     b2d:	eb 13                	jmp    b42 <strtoul+0x14b>
      }
      result = result*base + digit;
     b2f:	8b 45 10             	mov    0x10(%ebp),%eax
     b32:	0f af c7             	imul   %edi,%eax
     b35:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b38:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     b3f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     b40:	eb ca                	jmp    b0c <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     b42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b46:	75 03                	jne    b4b <strtoul+0x154>
  p = string;
     b48:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     b4b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     b4f:	74 05                	je     b56 <strtoul+0x15f>
  *endPtr = p;
     b51:	8b 45 0c             	mov    0xc(%ebp),%eax
     b54:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     b56:	89 f8                	mov    %edi,%eax
}
     b58:	83 c4 14             	add    $0x14,%esp
     b5b:	5b                   	pop    %ebx
     b5c:	5e                   	pop    %esi
     b5d:	5f                   	pop    %edi
     b5e:	5d                   	pop    %ebp
     b5f:	c3                   	ret    

00000b60 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     b60:	55                   	push   %ebp
     b61:	89 e5                	mov    %esp,%ebp
     b63:	53                   	push   %ebx
     b64:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     b6a:	eb 01                	jmp    b6d <strtol+0xd>
      p += 1;
     b6c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     b6d:	8a 03                	mov    (%ebx),%al
     b6f:	0f b6 c0             	movzbl %al,%eax
     b72:	89 04 24             	mov    %eax,(%esp)
     b75:	e8 3f fe ff ff       	call   9b9 <isspace>
     b7a:	85 c0                	test   %eax,%eax
     b7c:	75 ee                	jne    b6c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     b7e:	8a 03                	mov    (%ebx),%al
     b80:	3c 2d                	cmp    $0x2d,%al
     b82:	75 1e                	jne    ba2 <strtol+0x42>
  p += 1;
     b84:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     b85:	8b 45 10             	mov    0x10(%ebp),%eax
     b88:	89 44 24 08          	mov    %eax,0x8(%esp)
     b8c:	8b 45 0c             	mov    0xc(%ebp),%eax
     b8f:	89 44 24 04          	mov    %eax,0x4(%esp)
     b93:	89 1c 24             	mov    %ebx,(%esp)
     b96:	e8 5c fe ff ff       	call   9f7 <strtoul>
     b9b:	f7 d8                	neg    %eax
     b9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
     ba0:	eb 20                	jmp    bc2 <strtol+0x62>
    } else {
  if (*p == '+') {
     ba2:	8a 03                	mov    (%ebx),%al
     ba4:	3c 2b                	cmp    $0x2b,%al
     ba6:	75 01                	jne    ba9 <strtol+0x49>
      p += 1;
     ba8:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     ba9:	8b 45 10             	mov    0x10(%ebp),%eax
     bac:	89 44 24 08          	mov    %eax,0x8(%esp)
     bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb7:	89 1c 24             	mov    %ebx,(%esp)
     bba:	e8 38 fe ff ff       	call   9f7 <strtoul>
     bbf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     bc2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     bc6:	75 17                	jne    bdf <strtol+0x7f>
     bc8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bcc:	74 11                	je     bdf <strtol+0x7f>
     bce:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd1:	8b 00                	mov    (%eax),%eax
     bd3:	39 d8                	cmp    %ebx,%eax
     bd5:	75 08                	jne    bdf <strtol+0x7f>
  *endPtr = string;
     bd7:	8b 45 0c             	mov    0xc(%ebp),%eax
     bda:	8b 55 08             	mov    0x8(%ebp),%edx
     bdd:	89 10                	mov    %edx,(%eax)
    }
    return result;
     bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     be2:	83 c4 1c             	add    $0x1c,%esp
     be5:	5b                   	pop    %ebx
     be6:	5d                   	pop    %ebp
     be7:	c3                   	ret    

00000be8 <gets>:

char*
gets(char *buf, int max)
{
     be8:	55                   	push   %ebp
     be9:	89 e5                	mov    %esp,%ebp
     beb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bf5:	eb 49                	jmp    c40 <gets+0x58>
    cc = read(0, &c, 1);
     bf7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bfe:	00 
     bff:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c02:	89 44 24 04          	mov    %eax,0x4(%esp)
     c06:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c0d:	e8 3e 01 00 00       	call   d50 <read>
     c12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c19:	7f 02                	jg     c1d <gets+0x35>
      break;
     c1b:	eb 2c                	jmp    c49 <gets+0x61>
    buf[i++] = c;
     c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c20:	8d 50 01             	lea    0x1(%eax),%edx
     c23:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c26:	89 c2                	mov    %eax,%edx
     c28:	8b 45 08             	mov    0x8(%ebp),%eax
     c2b:	01 c2                	add    %eax,%edx
     c2d:	8a 45 ef             	mov    -0x11(%ebp),%al
     c30:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     c32:	8a 45 ef             	mov    -0x11(%ebp),%al
     c35:	3c 0a                	cmp    $0xa,%al
     c37:	74 10                	je     c49 <gets+0x61>
     c39:	8a 45 ef             	mov    -0x11(%ebp),%al
     c3c:	3c 0d                	cmp    $0xd,%al
     c3e:	74 09                	je     c49 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c43:	40                   	inc    %eax
     c44:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c47:	7c ae                	jl     bf7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c49:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c4c:	8b 45 08             	mov    0x8(%ebp),%eax
     c4f:	01 d0                	add    %edx,%eax
     c51:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     c54:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c57:	c9                   	leave  
     c58:	c3                   	ret    

00000c59 <stat>:

int
stat(char *n, struct stat *st)
{
     c59:	55                   	push   %ebp
     c5a:	89 e5                	mov    %esp,%ebp
     c5c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c66:	00 
     c67:	8b 45 08             	mov    0x8(%ebp),%eax
     c6a:	89 04 24             	mov    %eax,(%esp)
     c6d:	e8 06 01 00 00       	call   d78 <open>
     c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     c75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c79:	79 07                	jns    c82 <stat+0x29>
    return -1;
     c7b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c80:	eb 23                	jmp    ca5 <stat+0x4c>
  r = fstat(fd, st);
     c82:	8b 45 0c             	mov    0xc(%ebp),%eax
     c85:	89 44 24 04          	mov    %eax,0x4(%esp)
     c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c8c:	89 04 24             	mov    %eax,(%esp)
     c8f:	e8 fc 00 00 00       	call   d90 <fstat>
     c94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9a:	89 04 24             	mov    %eax,(%esp)
     c9d:	e8 be 00 00 00       	call   d60 <close>
  return r;
     ca2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ca5:	c9                   	leave  
     ca6:	c3                   	ret    

00000ca7 <atoi>:

int
atoi(const char *s)
{
     ca7:	55                   	push   %ebp
     ca8:	89 e5                	mov    %esp,%ebp
     caa:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     cad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     cb4:	eb 24                	jmp    cda <atoi+0x33>
    n = n*10 + *s++ - '0';
     cb6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     cb9:	89 d0                	mov    %edx,%eax
     cbb:	c1 e0 02             	shl    $0x2,%eax
     cbe:	01 d0                	add    %edx,%eax
     cc0:	01 c0                	add    %eax,%eax
     cc2:	89 c1                	mov    %eax,%ecx
     cc4:	8b 45 08             	mov    0x8(%ebp),%eax
     cc7:	8d 50 01             	lea    0x1(%eax),%edx
     cca:	89 55 08             	mov    %edx,0x8(%ebp)
     ccd:	8a 00                	mov    (%eax),%al
     ccf:	0f be c0             	movsbl %al,%eax
     cd2:	01 c8                	add    %ecx,%eax
     cd4:	83 e8 30             	sub    $0x30,%eax
     cd7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cda:	8b 45 08             	mov    0x8(%ebp),%eax
     cdd:	8a 00                	mov    (%eax),%al
     cdf:	3c 2f                	cmp    $0x2f,%al
     ce1:	7e 09                	jle    cec <atoi+0x45>
     ce3:	8b 45 08             	mov    0x8(%ebp),%eax
     ce6:	8a 00                	mov    (%eax),%al
     ce8:	3c 39                	cmp    $0x39,%al
     cea:	7e ca                	jle    cb6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cef:	c9                   	leave  
     cf0:	c3                   	ret    

00000cf1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     cf1:	55                   	push   %ebp
     cf2:	89 e5                	mov    %esp,%ebp
     cf4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     cf7:	8b 45 08             	mov    0x8(%ebp),%eax
     cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
     d00:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d03:	eb 16                	jmp    d1b <memmove+0x2a>
    *dst++ = *src++;
     d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d08:	8d 50 01             	lea    0x1(%eax),%edx
     d0b:	89 55 fc             	mov    %edx,-0x4(%ebp)
     d0e:	8b 55 f8             	mov    -0x8(%ebp),%edx
     d11:	8d 4a 01             	lea    0x1(%edx),%ecx
     d14:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     d17:	8a 12                	mov    (%edx),%dl
     d19:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d1b:	8b 45 10             	mov    0x10(%ebp),%eax
     d1e:	8d 50 ff             	lea    -0x1(%eax),%edx
     d21:	89 55 10             	mov    %edx,0x10(%ebp)
     d24:	85 c0                	test   %eax,%eax
     d26:	7f dd                	jg     d05 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d28:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d2b:	c9                   	leave  
     d2c:	c3                   	ret    
     d2d:	90                   	nop
     d2e:	90                   	nop
     d2f:	90                   	nop

00000d30 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d30:	b8 01 00 00 00       	mov    $0x1,%eax
     d35:	cd 40                	int    $0x40
     d37:	c3                   	ret    

00000d38 <exit>:
SYSCALL(exit)
     d38:	b8 02 00 00 00       	mov    $0x2,%eax
     d3d:	cd 40                	int    $0x40
     d3f:	c3                   	ret    

00000d40 <wait>:
SYSCALL(wait)
     d40:	b8 03 00 00 00       	mov    $0x3,%eax
     d45:	cd 40                	int    $0x40
     d47:	c3                   	ret    

00000d48 <pipe>:
SYSCALL(pipe)
     d48:	b8 04 00 00 00       	mov    $0x4,%eax
     d4d:	cd 40                	int    $0x40
     d4f:	c3                   	ret    

00000d50 <read>:
SYSCALL(read)
     d50:	b8 05 00 00 00       	mov    $0x5,%eax
     d55:	cd 40                	int    $0x40
     d57:	c3                   	ret    

00000d58 <write>:
SYSCALL(write)
     d58:	b8 10 00 00 00       	mov    $0x10,%eax
     d5d:	cd 40                	int    $0x40
     d5f:	c3                   	ret    

00000d60 <close>:
SYSCALL(close)
     d60:	b8 15 00 00 00       	mov    $0x15,%eax
     d65:	cd 40                	int    $0x40
     d67:	c3                   	ret    

00000d68 <kill>:
SYSCALL(kill)
     d68:	b8 06 00 00 00       	mov    $0x6,%eax
     d6d:	cd 40                	int    $0x40
     d6f:	c3                   	ret    

00000d70 <exec>:
SYSCALL(exec)
     d70:	b8 07 00 00 00       	mov    $0x7,%eax
     d75:	cd 40                	int    $0x40
     d77:	c3                   	ret    

00000d78 <open>:
SYSCALL(open)
     d78:	b8 0f 00 00 00       	mov    $0xf,%eax
     d7d:	cd 40                	int    $0x40
     d7f:	c3                   	ret    

00000d80 <mknod>:
SYSCALL(mknod)
     d80:	b8 11 00 00 00       	mov    $0x11,%eax
     d85:	cd 40                	int    $0x40
     d87:	c3                   	ret    

00000d88 <unlink>:
SYSCALL(unlink)
     d88:	b8 12 00 00 00       	mov    $0x12,%eax
     d8d:	cd 40                	int    $0x40
     d8f:	c3                   	ret    

00000d90 <fstat>:
SYSCALL(fstat)
     d90:	b8 08 00 00 00       	mov    $0x8,%eax
     d95:	cd 40                	int    $0x40
     d97:	c3                   	ret    

00000d98 <link>:
SYSCALL(link)
     d98:	b8 13 00 00 00       	mov    $0x13,%eax
     d9d:	cd 40                	int    $0x40
     d9f:	c3                   	ret    

00000da0 <mkdir>:
SYSCALL(mkdir)
     da0:	b8 14 00 00 00       	mov    $0x14,%eax
     da5:	cd 40                	int    $0x40
     da7:	c3                   	ret    

00000da8 <chdir>:
SYSCALL(chdir)
     da8:	b8 09 00 00 00       	mov    $0x9,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <dup>:
SYSCALL(dup)
     db0:	b8 0a 00 00 00       	mov    $0xa,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <getpid>:
SYSCALL(getpid)
     db8:	b8 0b 00 00 00       	mov    $0xb,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <sbrk>:
SYSCALL(sbrk)
     dc0:	b8 0c 00 00 00       	mov    $0xc,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <sleep>:
SYSCALL(sleep)
     dc8:	b8 0d 00 00 00       	mov    $0xd,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <uptime>:
SYSCALL(uptime)
     dd0:	b8 0e 00 00 00       	mov    $0xe,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <getname>:
SYSCALL(getname)
     dd8:	b8 16 00 00 00       	mov    $0x16,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <setname>:
SYSCALL(setname)
     de0:	b8 17 00 00 00       	mov    $0x17,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <getmaxproc>:
SYSCALL(getmaxproc)
     de8:	b8 18 00 00 00       	mov    $0x18,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <setmaxproc>:
SYSCALL(setmaxproc)
     df0:	b8 19 00 00 00       	mov    $0x19,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <getmaxmem>:
SYSCALL(getmaxmem)
     df8:	b8 1a 00 00 00       	mov    $0x1a,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <setmaxmem>:
SYSCALL(setmaxmem)
     e00:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <getmaxdisk>:
SYSCALL(getmaxdisk)
     e08:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e0d:	cd 40                	int    $0x40
     e0f:	c3                   	ret    

00000e10 <setmaxdisk>:
SYSCALL(setmaxdisk)
     e10:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e15:	cd 40                	int    $0x40
     e17:	c3                   	ret    

00000e18 <getusedmem>:
SYSCALL(getusedmem)
     e18:	b8 1e 00 00 00       	mov    $0x1e,%eax
     e1d:	cd 40                	int    $0x40
     e1f:	c3                   	ret    

00000e20 <setusedmem>:
SYSCALL(setusedmem)
     e20:	b8 1f 00 00 00       	mov    $0x1f,%eax
     e25:	cd 40                	int    $0x40
     e27:	c3                   	ret    

00000e28 <getuseddisk>:
SYSCALL(getuseddisk)
     e28:	b8 20 00 00 00       	mov    $0x20,%eax
     e2d:	cd 40                	int    $0x40
     e2f:	c3                   	ret    

00000e30 <setuseddisk>:
SYSCALL(setuseddisk)
     e30:	b8 21 00 00 00       	mov    $0x21,%eax
     e35:	cd 40                	int    $0x40
     e37:	c3                   	ret    

00000e38 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e38:	55                   	push   %ebp
     e39:	89 e5                	mov    %esp,%ebp
     e3b:	83 ec 18             	sub    $0x18,%esp
     e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e41:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e44:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e4b:	00 
     e4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
     e53:	8b 45 08             	mov    0x8(%ebp),%eax
     e56:	89 04 24             	mov    %eax,(%esp)
     e59:	e8 fa fe ff ff       	call   d58 <write>
}
     e5e:	c9                   	leave  
     e5f:	c3                   	ret    

00000e60 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e60:	55                   	push   %ebp
     e61:	89 e5                	mov    %esp,%ebp
     e63:	56                   	push   %esi
     e64:	53                   	push   %ebx
     e65:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     e68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     e6f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     e73:	74 17                	je     e8c <printint+0x2c>
     e75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e79:	79 11                	jns    e8c <printint+0x2c>
    neg = 1;
     e7b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     e82:	8b 45 0c             	mov    0xc(%ebp),%eax
     e85:	f7 d8                	neg    %eax
     e87:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e8a:	eb 06                	jmp    e92 <printint+0x32>
  } else {
    x = xx;
     e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
     e8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     e92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     e99:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     e9c:	8d 41 01             	lea    0x1(%ecx),%eax
     e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     ea2:	8b 5d 10             	mov    0x10(%ebp),%ebx
     ea5:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ea8:	ba 00 00 00 00       	mov    $0x0,%edx
     ead:	f7 f3                	div    %ebx
     eaf:	89 d0                	mov    %edx,%eax
     eb1:	8a 80 2c 19 00 00    	mov    0x192c(%eax),%al
     eb7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     ebb:	8b 75 10             	mov    0x10(%ebp),%esi
     ebe:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ec1:	ba 00 00 00 00       	mov    $0x0,%edx
     ec6:	f7 f6                	div    %esi
     ec8:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ecb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ecf:	75 c8                	jne    e99 <printint+0x39>
  if(neg)
     ed1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ed5:	74 10                	je     ee7 <printint+0x87>
    buf[i++] = '-';
     ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eda:	8d 50 01             	lea    0x1(%eax),%edx
     edd:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ee0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     ee5:	eb 1e                	jmp    f05 <printint+0xa5>
     ee7:	eb 1c                	jmp    f05 <printint+0xa5>
    putc(fd, buf[i]);
     ee9:	8d 55 dc             	lea    -0x24(%ebp),%edx
     eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eef:	01 d0                	add    %edx,%eax
     ef1:	8a 00                	mov    (%eax),%al
     ef3:	0f be c0             	movsbl %al,%eax
     ef6:	89 44 24 04          	mov    %eax,0x4(%esp)
     efa:	8b 45 08             	mov    0x8(%ebp),%eax
     efd:	89 04 24             	mov    %eax,(%esp)
     f00:	e8 33 ff ff ff       	call   e38 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f05:	ff 4d f4             	decl   -0xc(%ebp)
     f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f0c:	79 db                	jns    ee9 <printint+0x89>
    putc(fd, buf[i]);
}
     f0e:	83 c4 30             	add    $0x30,%esp
     f11:	5b                   	pop    %ebx
     f12:	5e                   	pop    %esi
     f13:	5d                   	pop    %ebp
     f14:	c3                   	ret    

00000f15 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f15:	55                   	push   %ebp
     f16:	89 e5                	mov    %esp,%ebp
     f18:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f1b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f22:	8d 45 0c             	lea    0xc(%ebp),%eax
     f25:	83 c0 04             	add    $0x4,%eax
     f28:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f32:	e9 77 01 00 00       	jmp    10ae <printf+0x199>
    c = fmt[i] & 0xff;
     f37:	8b 55 0c             	mov    0xc(%ebp),%edx
     f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f3d:	01 d0                	add    %edx,%eax
     f3f:	8a 00                	mov    (%eax),%al
     f41:	0f be c0             	movsbl %al,%eax
     f44:	25 ff 00 00 00       	and    $0xff,%eax
     f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f50:	75 2c                	jne    f7e <printf+0x69>
      if(c == '%'){
     f52:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f56:	75 0c                	jne    f64 <printf+0x4f>
        state = '%';
     f58:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f5f:	e9 47 01 00 00       	jmp    10ab <printf+0x196>
      } else {
        putc(fd, c);
     f64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f67:	0f be c0             	movsbl %al,%eax
     f6a:	89 44 24 04          	mov    %eax,0x4(%esp)
     f6e:	8b 45 08             	mov    0x8(%ebp),%eax
     f71:	89 04 24             	mov    %eax,(%esp)
     f74:	e8 bf fe ff ff       	call   e38 <putc>
     f79:	e9 2d 01 00 00       	jmp    10ab <printf+0x196>
      }
    } else if(state == '%'){
     f7e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     f82:	0f 85 23 01 00 00    	jne    10ab <printf+0x196>
      if(c == 'd'){
     f88:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     f8c:	75 2d                	jne    fbb <printf+0xa6>
        printint(fd, *ap, 10, 1);
     f8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f91:	8b 00                	mov    (%eax),%eax
     f93:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     f9a:	00 
     f9b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     fa2:	00 
     fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
     fa7:	8b 45 08             	mov    0x8(%ebp),%eax
     faa:	89 04 24             	mov    %eax,(%esp)
     fad:	e8 ae fe ff ff       	call   e60 <printint>
        ap++;
     fb2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fb6:	e9 e9 00 00 00       	jmp    10a4 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
     fbb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     fbf:	74 06                	je     fc7 <printf+0xb2>
     fc1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     fc5:	75 2d                	jne    ff4 <printf+0xdf>
        printint(fd, *ap, 16, 0);
     fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fca:	8b 00                	mov    (%eax),%eax
     fcc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     fd3:	00 
     fd4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     fdb:	00 
     fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
     fe0:	8b 45 08             	mov    0x8(%ebp),%eax
     fe3:	89 04 24             	mov    %eax,(%esp)
     fe6:	e8 75 fe ff ff       	call   e60 <printint>
        ap++;
     feb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fef:	e9 b0 00 00 00       	jmp    10a4 <printf+0x18f>
      } else if(c == 's'){
     ff4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     ff8:	75 42                	jne    103c <printf+0x127>
        s = (char*)*ap;
     ffa:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ffd:	8b 00                	mov    (%eax),%eax
     fff:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1002:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1006:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    100a:	75 09                	jne    1015 <printf+0x100>
          s = "(null)";
    100c:	c7 45 f4 b9 14 00 00 	movl   $0x14b9,-0xc(%ebp)
        while(*s != 0){
    1013:	eb 1c                	jmp    1031 <printf+0x11c>
    1015:	eb 1a                	jmp    1031 <printf+0x11c>
          putc(fd, *s);
    1017:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101a:	8a 00                	mov    (%eax),%al
    101c:	0f be c0             	movsbl %al,%eax
    101f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1023:	8b 45 08             	mov    0x8(%ebp),%eax
    1026:	89 04 24             	mov    %eax,(%esp)
    1029:	e8 0a fe ff ff       	call   e38 <putc>
          s++;
    102e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1031:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1034:	8a 00                	mov    (%eax),%al
    1036:	84 c0                	test   %al,%al
    1038:	75 dd                	jne    1017 <printf+0x102>
    103a:	eb 68                	jmp    10a4 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    103c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1040:	75 1d                	jne    105f <printf+0x14a>
        putc(fd, *ap);
    1042:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1045:	8b 00                	mov    (%eax),%eax
    1047:	0f be c0             	movsbl %al,%eax
    104a:	89 44 24 04          	mov    %eax,0x4(%esp)
    104e:	8b 45 08             	mov    0x8(%ebp),%eax
    1051:	89 04 24             	mov    %eax,(%esp)
    1054:	e8 df fd ff ff       	call   e38 <putc>
        ap++;
    1059:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    105d:	eb 45                	jmp    10a4 <printf+0x18f>
      } else if(c == '%'){
    105f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1063:	75 17                	jne    107c <printf+0x167>
        putc(fd, c);
    1065:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1068:	0f be c0             	movsbl %al,%eax
    106b:	89 44 24 04          	mov    %eax,0x4(%esp)
    106f:	8b 45 08             	mov    0x8(%ebp),%eax
    1072:	89 04 24             	mov    %eax,(%esp)
    1075:	e8 be fd ff ff       	call   e38 <putc>
    107a:	eb 28                	jmp    10a4 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    107c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1083:	00 
    1084:	8b 45 08             	mov    0x8(%ebp),%eax
    1087:	89 04 24             	mov    %eax,(%esp)
    108a:	e8 a9 fd ff ff       	call   e38 <putc>
        putc(fd, c);
    108f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1092:	0f be c0             	movsbl %al,%eax
    1095:	89 44 24 04          	mov    %eax,0x4(%esp)
    1099:	8b 45 08             	mov    0x8(%ebp),%eax
    109c:	89 04 24             	mov    %eax,(%esp)
    109f:	e8 94 fd ff ff       	call   e38 <putc>
      }
      state = 0;
    10a4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    10ab:	ff 45 f0             	incl   -0x10(%ebp)
    10ae:	8b 55 0c             	mov    0xc(%ebp),%edx
    10b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10b4:	01 d0                	add    %edx,%eax
    10b6:	8a 00                	mov    (%eax),%al
    10b8:	84 c0                	test   %al,%al
    10ba:	0f 85 77 fe ff ff    	jne    f37 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    10c0:	c9                   	leave  
    10c1:	c3                   	ret    
    10c2:	90                   	nop
    10c3:	90                   	nop

000010c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10c4:	55                   	push   %ebp
    10c5:	89 e5                	mov    %esp,%ebp
    10c7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10ca:	8b 45 08             	mov    0x8(%ebp),%eax
    10cd:	83 e8 08             	sub    $0x8,%eax
    10d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10d3:	a1 50 19 00 00       	mov    0x1950,%eax
    10d8:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10db:	eb 24                	jmp    1101 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10e0:	8b 00                	mov    (%eax),%eax
    10e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10e5:	77 12                	ja     10f9 <free+0x35>
    10e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10ea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10ed:	77 24                	ja     1113 <free+0x4f>
    10ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10f2:	8b 00                	mov    (%eax),%eax
    10f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10f7:	77 1a                	ja     1113 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10fc:	8b 00                	mov    (%eax),%eax
    10fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1101:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1104:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1107:	76 d4                	jbe    10dd <free+0x19>
    1109:	8b 45 fc             	mov    -0x4(%ebp),%eax
    110c:	8b 00                	mov    (%eax),%eax
    110e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1111:	76 ca                	jbe    10dd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1113:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1116:	8b 40 04             	mov    0x4(%eax),%eax
    1119:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1120:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1123:	01 c2                	add    %eax,%edx
    1125:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1128:	8b 00                	mov    (%eax),%eax
    112a:	39 c2                	cmp    %eax,%edx
    112c:	75 24                	jne    1152 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    112e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1131:	8b 50 04             	mov    0x4(%eax),%edx
    1134:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1137:	8b 00                	mov    (%eax),%eax
    1139:	8b 40 04             	mov    0x4(%eax),%eax
    113c:	01 c2                	add    %eax,%edx
    113e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1141:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1144:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1147:	8b 00                	mov    (%eax),%eax
    1149:	8b 10                	mov    (%eax),%edx
    114b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    114e:	89 10                	mov    %edx,(%eax)
    1150:	eb 0a                	jmp    115c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1152:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1155:	8b 10                	mov    (%eax),%edx
    1157:	8b 45 f8             	mov    -0x8(%ebp),%eax
    115a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    115c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    115f:	8b 40 04             	mov    0x4(%eax),%eax
    1162:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1169:	8b 45 fc             	mov    -0x4(%ebp),%eax
    116c:	01 d0                	add    %edx,%eax
    116e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1171:	75 20                	jne    1193 <free+0xcf>
    p->s.size += bp->s.size;
    1173:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1176:	8b 50 04             	mov    0x4(%eax),%edx
    1179:	8b 45 f8             	mov    -0x8(%ebp),%eax
    117c:	8b 40 04             	mov    0x4(%eax),%eax
    117f:	01 c2                	add    %eax,%edx
    1181:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1184:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1187:	8b 45 f8             	mov    -0x8(%ebp),%eax
    118a:	8b 10                	mov    (%eax),%edx
    118c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    118f:	89 10                	mov    %edx,(%eax)
    1191:	eb 08                	jmp    119b <free+0xd7>
  } else
    p->s.ptr = bp;
    1193:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1196:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1199:	89 10                	mov    %edx,(%eax)
  freep = p;
    119b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    119e:	a3 50 19 00 00       	mov    %eax,0x1950
}
    11a3:	c9                   	leave  
    11a4:	c3                   	ret    

000011a5 <morecore>:

static Header*
morecore(uint nu)
{
    11a5:	55                   	push   %ebp
    11a6:	89 e5                	mov    %esp,%ebp
    11a8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    11ab:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    11b2:	77 07                	ja     11bb <morecore+0x16>
    nu = 4096;
    11b4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    11bb:	8b 45 08             	mov    0x8(%ebp),%eax
    11be:	c1 e0 03             	shl    $0x3,%eax
    11c1:	89 04 24             	mov    %eax,(%esp)
    11c4:	e8 f7 fb ff ff       	call   dc0 <sbrk>
    11c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    11cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    11d0:	75 07                	jne    11d9 <morecore+0x34>
    return 0;
    11d2:	b8 00 00 00 00       	mov    $0x0,%eax
    11d7:	eb 22                	jmp    11fb <morecore+0x56>
  hp = (Header*)p;
    11d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    11df:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11e2:	8b 55 08             	mov    0x8(%ebp),%edx
    11e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    11e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11eb:	83 c0 08             	add    $0x8,%eax
    11ee:	89 04 24             	mov    %eax,(%esp)
    11f1:	e8 ce fe ff ff       	call   10c4 <free>
  return freep;
    11f6:	a1 50 19 00 00       	mov    0x1950,%eax
}
    11fb:	c9                   	leave  
    11fc:	c3                   	ret    

000011fd <malloc>:

void*
malloc(uint nbytes)
{
    11fd:	55                   	push   %ebp
    11fe:	89 e5                	mov    %esp,%ebp
    1200:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1203:	8b 45 08             	mov    0x8(%ebp),%eax
    1206:	83 c0 07             	add    $0x7,%eax
    1209:	c1 e8 03             	shr    $0x3,%eax
    120c:	40                   	inc    %eax
    120d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1210:	a1 50 19 00 00       	mov    0x1950,%eax
    1215:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1218:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    121c:	75 23                	jne    1241 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    121e:	c7 45 f0 48 19 00 00 	movl   $0x1948,-0x10(%ebp)
    1225:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1228:	a3 50 19 00 00       	mov    %eax,0x1950
    122d:	a1 50 19 00 00       	mov    0x1950,%eax
    1232:	a3 48 19 00 00       	mov    %eax,0x1948
    base.s.size = 0;
    1237:	c7 05 4c 19 00 00 00 	movl   $0x0,0x194c
    123e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1241:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1244:	8b 00                	mov    (%eax),%eax
    1246:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1249:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124c:	8b 40 04             	mov    0x4(%eax),%eax
    124f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1252:	72 4d                	jb     12a1 <malloc+0xa4>
      if(p->s.size == nunits)
    1254:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1257:	8b 40 04             	mov    0x4(%eax),%eax
    125a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    125d:	75 0c                	jne    126b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    125f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1262:	8b 10                	mov    (%eax),%edx
    1264:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1267:	89 10                	mov    %edx,(%eax)
    1269:	eb 26                	jmp    1291 <malloc+0x94>
      else {
        p->s.size -= nunits;
    126b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    126e:	8b 40 04             	mov    0x4(%eax),%eax
    1271:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1274:	89 c2                	mov    %eax,%edx
    1276:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1279:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127f:	8b 40 04             	mov    0x4(%eax),%eax
    1282:	c1 e0 03             	shl    $0x3,%eax
    1285:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1288:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    128e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1291:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1294:	a3 50 19 00 00       	mov    %eax,0x1950
      return (void*)(p + 1);
    1299:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129c:	83 c0 08             	add    $0x8,%eax
    129f:	eb 38                	jmp    12d9 <malloc+0xdc>
    }
    if(p == freep)
    12a1:	a1 50 19 00 00       	mov    0x1950,%eax
    12a6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    12a9:	75 1b                	jne    12c6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    12ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12ae:	89 04 24             	mov    %eax,(%esp)
    12b1:	e8 ef fe ff ff       	call   11a5 <morecore>
    12b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    12b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12bd:	75 07                	jne    12c6 <malloc+0xc9>
        return 0;
    12bf:	b8 00 00 00 00       	mov    $0x0,%eax
    12c4:	eb 13                	jmp    12d9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12cf:	8b 00                	mov    (%eax),%eax
    12d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    12d4:	e9 70 ff ff ff       	jmp    1249 <malloc+0x4c>
}
    12d9:	c9                   	leave  
    12da:	c3                   	ret    
