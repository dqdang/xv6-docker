
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
       c:	c7 44 24 04 3c 13 00 	movl   $0x133c,0x4(%esp)
      13:	00 
      14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      1b:	e8 55 0f 00 00       	call   f75 <printf>
  }
  if(mode == 1){ // create
      20:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
      24:	75 14                	jne    3a <print_usage+0x3a>
    printf(1, "Usage: ctool create <container> <max proc> <max mem> <max disk> <exec1> <exec2> ...\n");
      26:	c7 44 24 04 58 13 00 	movl   $0x1358,0x4(%esp)
      2d:	00 
      2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      35:	e8 3b 0f 00 00       	call   f75 <printf>
  }
  if(mode == 2){ // create with container created
      3a:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
      3e:	75 14                	jne    54 <print_usage+0x54>
    printf(1, "Container taken. Failed to create, exiting...\n");
      40:	c7 44 24 04 b0 13 00 	movl   $0x13b0,0x4(%esp)
      47:	00 
      48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      4f:	e8 21 0f 00 00       	call   f75 <printf>
  }
  if(mode == 3){ // start
      54:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
      58:	75 14                	jne    6e <print_usage+0x6e>
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
      5a:	c7 44 24 04 e0 13 00 	movl   $0x13e0,0x4(%esp)
      61:	00 
      62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      69:	e8 07 0f 00 00       	call   f75 <printf>
  }
  if(mode == 4){ // delete
      6e:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
      72:	75 14                	jne    88 <print_usage+0x88>
    printf(1, "Usage: ctool delete <container>\n");
      74:	c7 44 24 04 14 14 00 	movl   $0x1414,0x4(%esp)
      7b:	00 
      7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      83:	e8 ed 0e 00 00       	call   f75 <printf>
  }
  
  exit();
      88:	e8 e3 0c 00 00       	call   d70 <exit>

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
      fc:	e8 af 0c 00 00       	call   db0 <open>
     101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "fd = %d\n", fd);
     104:	8b 45 f4             	mov    -0xc(%ebp),%eax
     107:	89 44 24 08          	mov    %eax,0x8(%esp)
     10b:	c7 44 24 04 35 14 00 	movl   $0x1435,0x4(%esp)
     112:	00 
     113:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     11a:	e8 56 0e 00 00       	call   f75 <printf>
  /* fork a child and exec argv[4] */
  id = fork();
     11f:	e8 44 0c 00 00       	call   d68 <fork>
     124:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(id == 0){
     127:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     12b:	0f 85 9c 00 00 00    	jne    1cd <start+0xea>
    close(0);
     131:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     138:	e8 5b 0c 00 00       	call   d98 <close>
    close(1);
     13d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     144:	e8 4f 0c 00 00       	call   d98 <close>
    close(2);
     149:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     150:	e8 43 0c 00 00       	call   d98 <close>
    dup(fd);
     155:	8b 45 f4             	mov    -0xc(%ebp),%eax
     158:	89 04 24             	mov    %eax,(%esp)
     15b:	e8 88 0c 00 00       	call   de8 <dup>
    dup(fd);
     160:	8b 45 f4             	mov    -0xc(%ebp),%eax
     163:	89 04 24             	mov    %eax,(%esp)
     166:	e8 7d 0c 00 00       	call   de8 <dup>
    dup(fd);
     16b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 72 0c 00 00       	call   de8 <dup>
    if(chdir(argv[3]) < 0){
     176:	8b 45 0c             	mov    0xc(%ebp),%eax
     179:	83 c0 0c             	add    $0xc,%eax
     17c:	8b 00                	mov    (%eax),%eax
     17e:	89 04 24             	mov    %eax,(%esp)
     181:	e8 5a 0c 00 00       	call   de0 <chdir>
     186:	85 c0                	test   %eax,%eax
     188:	79 19                	jns    1a3 <start+0xc0>
      printf(1, "Container does not exist.");
     18a:	c7 44 24 04 3e 14 00 	movl   $0x143e,0x4(%esp)
     191:	00 
     192:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     199:	e8 d7 0d 00 00       	call   f75 <printf>
      exit();
     19e:	e8 cd 0b 00 00       	call   d70 <exit>
    }
    exec(argv[4], &argv[4]);
     1a3:	8b 45 0c             	mov    0xc(%ebp),%eax
     1a6:	8d 50 10             	lea    0x10(%eax),%edx
     1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     1ac:	83 c0 10             	add    $0x10,%eax
     1af:	8b 00                	mov    (%eax),%eax
     1b1:	89 54 24 04          	mov    %edx,0x4(%esp)
     1b5:	89 04 24             	mov    %eax,(%esp)
     1b8:	e8 eb 0b 00 00       	call   da8 <exec>
    close(fd);
     1bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c0:	89 04 24             	mov    %eax,(%esp)
     1c3:	e8 d0 0b 00 00       	call   d98 <close>
    exit();
     1c8:	e8 a3 0b 00 00       	call   d70 <exit>
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
     1ec:	c7 45 e0 58 14 00 00 	movl   $0x1458,-0x20(%ebp)
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

  setname(cindex, argv[2]);
     21f:	8b 45 0c             	mov    0xc(%ebp),%eax
     222:	83 c0 08             	add    $0x8,%eax
     225:	8b 00                	mov    (%eax),%eax
     227:	89 44 24 04          	mov    %eax,0x4(%esp)
     22b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     22e:	89 04 24             	mov    %eax,(%esp)
     231:	e8 e2 0b 00 00       	call   e18 <setname>
  setmaxproc(cindex, atoi(argv[3]));
     236:	8b 45 0c             	mov    0xc(%ebp),%eax
     239:	83 c0 0c             	add    $0xc,%eax
     23c:	8b 00                	mov    (%eax),%eax
     23e:	89 04 24             	mov    %eax,(%esp)
     241:	e8 99 0a 00 00       	call   cdf <atoi>
     246:	89 44 24 04          	mov    %eax,0x4(%esp)
     24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     24d:	89 04 24             	mov    %eax,(%esp)
     250:	e8 d3 0b 00 00       	call   e28 <setmaxproc>
  setmaxmem(cindex, atoi(argv[4]) * 1000000);
     255:	8b 45 0c             	mov    0xc(%ebp),%eax
     258:	83 c0 10             	add    $0x10,%eax
     25b:	8b 00                	mov    (%eax),%eax
     25d:	89 04 24             	mov    %eax,(%esp)
     260:	e8 7a 0a 00 00       	call   cdf <atoi>
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
     2a8:	e8 8b 0b 00 00       	call   e38 <setmaxmem>
  setmaxdisk(cindex, atoi(argv[5]) * 1000000);
     2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     2b0:	83 c0 14             	add    $0x14,%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	89 04 24             	mov    %eax,(%esp)
     2b8:	e8 22 0a 00 00       	call   cdf <atoi>
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
     300:	e8 43 0b 00 00       	call   e48 <setmaxdisk>
  setusedmem(cindex, 0);
     305:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     30c:	00 
     30d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     310:	89 04 24             	mov    %eax,(%esp)
     313:	e8 40 0b 00 00       	call   e58 <setusedmem>
  setuseddisk(cindex, 0);
     318:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     31f:	00 
     320:	8b 45 f0             	mov    -0x10(%ebp),%eax
     323:	89 04 24             	mov    %eax,(%esp)
     326:	e8 3d 0b 00 00       	call   e68 <setuseddisk>


  id = fork();
     32b:	e8 38 0a 00 00       	call   d68 <fork>
     330:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0){
     333:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     337:	75 12                	jne    34b <create+0x16d>
    exec(mkdir[0], mkdir);
     339:	8b 45 e0             	mov    -0x20(%ebp),%eax
     33c:	8d 55 e0             	lea    -0x20(%ebp),%edx
     33f:	89 54 24 04          	mov    %edx,0x4(%esp)
     343:	89 04 24             	mov    %eax,(%esp)
     346:	e8 5d 0a 00 00       	call   da8 <exec>
  }
  id = wait();
     34b:	e8 28 0a 00 00       	call   d78 <wait>
     350:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     353:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     35a:	e9 66 01 00 00       	jmp    4c5 <create+0x2e7>
    char destination[32];

    strcpy(destination, "/");
     35f:	c7 44 24 04 5e 14 00 	movl   $0x145e,0x4(%esp)
     366:	00 
     367:	8d 45 b8             	lea    -0x48(%ebp),%eax
     36a:	89 04 24             	mov    %eax,(%esp)
     36d:	e8 73 02 00 00       	call   5e5 <strcpy>
    strcat(destination, mkdir[1]);
     372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     375:	89 44 24 04          	mov    %eax,0x4(%esp)
     379:	8d 45 b8             	lea    -0x48(%ebp),%eax
     37c:	89 04 24             	mov    %eax,(%esp)
     37f:	e8 8e 04 00 00       	call   812 <strcat>
    strcat(destination, "/");
     384:	c7 44 24 04 5e 14 00 	movl   $0x145e,0x4(%esp)
     38b:	00 
     38c:	8d 45 b8             	lea    -0x48(%ebp),%eax
     38f:	89 04 24             	mov    %eax,(%esp)
     392:	e8 7b 04 00 00       	call   812 <strcat>
    strcat(destination, argv[i]);
     397:	8b 45 f4             	mov    -0xc(%ebp),%eax
     39a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
     3a4:	01 d0                	add    %edx,%eax
     3a6:	8b 00                	mov    (%eax),%eax
     3a8:	89 44 24 04          	mov    %eax,0x4(%esp)
     3ac:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3af:	89 04 24             	mov    %eax,(%esp)
     3b2:	e8 5b 04 00 00       	call   812 <strcat>
    strcat(destination, "\0");
     3b7:	c7 44 24 04 60 14 00 	movl   $0x1460,0x4(%esp)
     3be:	00 
     3bf:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3c2:	89 04 24             	mov    %eax,(%esp)
     3c5:	e8 48 04 00 00       	call   812 <strcat>

    // ctable.tuperwares[i].files[i-6] = argv[i];
    bytes = copy(argv[i], destination, getuseddisk(cindex), getmaxdisk(cindex));
     3ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3cd:	89 04 24             	mov    %eax,(%esp)
     3d0:	e8 6b 0a 00 00       	call   e40 <getmaxdisk>
     3d5:	89 c3                	mov    %eax,%ebx
     3d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3da:	89 04 24             	mov    %eax,(%esp)
     3dd:	e8 7e 0a 00 00       	call   e60 <getuseddisk>
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
     405:	e8 09 02 00 00       	call   613 <copy>
     40a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Bytes for %s: %d\n", argv[i], bytes);
     40d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     417:	8b 45 0c             	mov    0xc(%ebp),%eax
     41a:	01 d0                	add    %edx,%eax
     41c:	8b 00                	mov    (%eax),%eax
     41e:	8b 55 e8             	mov    -0x18(%ebp),%edx
     421:	89 54 24 0c          	mov    %edx,0xc(%esp)
     425:	89 44 24 08          	mov    %eax,0x8(%esp)
     429:	c7 44 24 04 62 14 00 	movl   $0x1462,0x4(%esp)
     430:	00 
     431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     438:	e8 38 0b 00 00       	call   f75 <printf>

    if(bytes > 0){
     43d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     441:	7e 21                	jle    464 <create+0x286>
      setuseddisk(cindex, getuseddisk(cindex) + bytes);
     443:	8b 45 f0             	mov    -0x10(%ebp),%eax
     446:	89 04 24             	mov    %eax,(%esp)
     449:	e8 12 0a 00 00       	call   e60 <getuseddisk>
     44e:	8b 55 e8             	mov    -0x18(%ebp),%edx
     451:	01 d0                	add    %edx,%eax
     453:	89 44 24 04          	mov    %eax,0x4(%esp)
     457:	8b 45 f0             	mov    -0x10(%ebp),%eax
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 06 0a 00 00       	call   e68 <setuseddisk>
     462:	eb 5e                	jmp    4c2 <create+0x2e4>
    }
    else{
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
     464:	8b 45 f4             	mov    -0xc(%ebp),%eax
     467:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     46e:	8b 45 0c             	mov    0xc(%ebp),%eax
     471:	01 d0                	add    %edx,%eax
     473:	8b 00                	mov    (%eax),%eax
     475:	89 44 24 08          	mov    %eax,0x8(%esp)
     479:	c7 44 24 04 74 14 00 	movl   $0x1474,0x4(%esp)
     480:	00 
     481:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     488:	e8 e8 0a 00 00       	call   f75 <printf>
      id = fork();
     48d:	e8 d6 08 00 00       	call   d68 <fork>
     492:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(id == 0){
     495:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     499:	75 1f                	jne    4ba <create+0x2dc>
        char *remove_args[2];
        remove_args[0] = "rm";
     49b:	c7 45 d8 ca 14 00 00 	movl   $0x14ca,-0x28(%ebp)
        remove_args[1] = destination;
     4a2:	8d 45 b8             	lea    -0x48(%ebp),%eax
     4a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        exec(remove_args[0], remove_args);
     4a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
     4ab:	8d 55 d8             	lea    -0x28(%ebp),%edx
     4ae:	89 54 24 04          	mov    %edx,0x4(%esp)
     4b2:	89 04 24             	mov    %eax,(%esp)
     4b5:	e8 ee 08 00 00       	call   da8 <exec>
      }
      id = wait();
     4ba:	e8 b9 08 00 00       	call   d78 <wait>
     4bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0){
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     4c2:	ff 45 f4             	incl   -0xc(%ebp)
     4c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c8:	3b 45 08             	cmp    0x8(%ebp),%eax
     4cb:	0f 8c 8e fe ff ff    	jl     35f <create+0x181>
        exec(remove_args[0], remove_args);
      }
      id = wait();
    }
  }
  printf(1, "Total used disk: %d\n", getuseddisk(cindex));
     4d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4d4:	89 04 24             	mov    %eax,(%esp)
     4d7:	e8 84 09 00 00       	call   e60 <getuseddisk>
     4dc:	89 44 24 08          	mov    %eax,0x8(%esp)
     4e0:	c7 44 24 04 cd 14 00 	movl   $0x14cd,0x4(%esp)
     4e7:	00 
     4e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4ef:	e8 81 0a 00 00       	call   f75 <printf>

  // TODO: IMPLEMENT GET/SET FILES
  // ctable.tuperwares[cindex].files = files;
  return 0;
     4f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
     4f9:	83 c4 54             	add    $0x54,%esp
     4fc:	5b                   	pop    %ebx
     4fd:	5d                   	pop    %ebp
     4fe:	c3                   	ret    

000004ff <main>:

int main(int argc, char *argv[]){
     4ff:	55                   	push   %ebp
     500:	89 e5                	mov    %esp,%ebp
     502:	83 e4 f0             	and    $0xfffffff0,%esp
     505:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2){
     508:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     50c:	7f 0c                	jg     51a <main+0x1b>
    print_usage(0);
     50e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     515:	e8 e6 fa ff ff       	call   0 <print_usage>
  }

  if(strcmp(argv[1], "create") == 0){
     51a:	8b 45 0c             	mov    0xc(%ebp),%eax
     51d:	83 c0 04             	add    $0x4,%eax
     520:	8b 00                	mov    (%eax),%eax
     522:	c7 44 24 04 e2 14 00 	movl   $0x14e2,0x4(%esp)
     529:	00 
     52a:	89 04 24             	mov    %eax,(%esp)
     52d:	e8 e1 01 00 00       	call   713 <strcmp>
     532:	85 c0                	test   %eax,%eax
     534:	75 44                	jne    57a <main+0x7b>
    if(argc < 7){
     536:	83 7d 08 06          	cmpl   $0x6,0x8(%ebp)
     53a:	7f 0c                	jg     548 <main+0x49>
      print_usage(1);
     53c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     543:	e8 b8 fa ff ff       	call   0 <print_usage>
    }
    if(chdir(argv[2]) > 0){
     548:	8b 45 0c             	mov    0xc(%ebp),%eax
     54b:	83 c0 08             	add    $0x8,%eax
     54e:	8b 00                	mov    (%eax),%eax
     550:	89 04 24             	mov    %eax,(%esp)
     553:	e8 88 08 00 00       	call   de0 <chdir>
     558:	85 c0                	test   %eax,%eax
     55a:	7e 0c                	jle    568 <main+0x69>
      print_usage(2);
     55c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     563:	e8 98 fa ff ff       	call   0 <print_usage>
    }
    create(argc, argv);
     568:	8b 45 0c             	mov    0xc(%ebp),%eax
     56b:	89 44 24 04          	mov    %eax,0x4(%esp)
     56f:	8b 45 08             	mov    0x8(%ebp),%eax
     572:	89 04 24             	mov    %eax,(%esp)
     575:	e8 64 fc ff ff       	call   1de <create>
  }

  if(strcmp(argv[1], "start") == 0){
     57a:	8b 45 0c             	mov    0xc(%ebp),%eax
     57d:	83 c0 04             	add    $0x4,%eax
     580:	8b 00                	mov    (%eax),%eax
     582:	c7 44 24 04 e9 14 00 	movl   $0x14e9,0x4(%esp)
     589:	00 
     58a:	89 04 24             	mov    %eax,(%esp)
     58d:	e8 81 01 00 00       	call   713 <strcmp>
     592:	85 c0                	test   %eax,%eax
     594:	75 24                	jne    5ba <main+0xbb>
    if(argc < 5){
     596:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     59a:	7f 0c                	jg     5a8 <main+0xa9>
      print_usage(3);
     59c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     5a3:	e8 58 fa ff ff       	call   0 <print_usage>
    }
    start(argc, argv);
     5a8:	8b 45 0c             	mov    0xc(%ebp),%eax
     5ab:	89 44 24 04          	mov    %eax,0x4(%esp)
     5af:	8b 45 08             	mov    0x8(%ebp),%eax
     5b2:	89 04 24             	mov    %eax,(%esp)
     5b5:	e8 29 fb ff ff       	call   e3 <start>
  //   if(argc < 3){
  //     print_usage(4);
  //   }
  //   delete(argv);
  // }
  exit();
     5ba:	e8 b1 07 00 00       	call   d70 <exit>
     5bf:	90                   	nop

000005c0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     5c0:	55                   	push   %ebp
     5c1:	89 e5                	mov    %esp,%ebp
     5c3:	57                   	push   %edi
     5c4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     5c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     5c8:	8b 55 10             	mov    0x10(%ebp),%edx
     5cb:	8b 45 0c             	mov    0xc(%ebp),%eax
     5ce:	89 cb                	mov    %ecx,%ebx
     5d0:	89 df                	mov    %ebx,%edi
     5d2:	89 d1                	mov    %edx,%ecx
     5d4:	fc                   	cld    
     5d5:	f3 aa                	rep stos %al,%es:(%edi)
     5d7:	89 ca                	mov    %ecx,%edx
     5d9:	89 fb                	mov    %edi,%ebx
     5db:	89 5d 08             	mov    %ebx,0x8(%ebp)
     5de:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     5e1:	5b                   	pop    %ebx
     5e2:	5f                   	pop    %edi
     5e3:	5d                   	pop    %ebp
     5e4:	c3                   	ret    

000005e5 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     5e5:	55                   	push   %ebp
     5e6:	89 e5                	mov    %esp,%ebp
     5e8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     5eb:	8b 45 08             	mov    0x8(%ebp),%eax
     5ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     5f1:	90                   	nop
     5f2:	8b 45 08             	mov    0x8(%ebp),%eax
     5f5:	8d 50 01             	lea    0x1(%eax),%edx
     5f8:	89 55 08             	mov    %edx,0x8(%ebp)
     5fb:	8b 55 0c             	mov    0xc(%ebp),%edx
     5fe:	8d 4a 01             	lea    0x1(%edx),%ecx
     601:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     604:	8a 12                	mov    (%edx),%dl
     606:	88 10                	mov    %dl,(%eax)
     608:	8a 00                	mov    (%eax),%al
     60a:	84 c0                	test   %al,%al
     60c:	75 e4                	jne    5f2 <strcpy+0xd>
    ;
  return os;
     60e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     611:	c9                   	leave  
     612:	c3                   	ret    

00000613 <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     613:	55                   	push   %ebp
     614:	89 e5                	mov    %esp,%ebp
     616:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     619:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     620:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     627:	00 
     628:	8b 45 08             	mov    0x8(%ebp),%eax
     62b:	89 04 24             	mov    %eax,(%esp)
     62e:	e8 7d 07 00 00       	call   db0 <open>
     633:	89 45 f0             	mov    %eax,-0x10(%ebp)
     636:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     63a:	79 20                	jns    65c <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     63c:	8b 45 08             	mov    0x8(%ebp),%eax
     63f:	89 44 24 08          	mov    %eax,0x8(%esp)
     643:	c7 44 24 04 ef 14 00 	movl   $0x14ef,0x4(%esp)
     64a:	00 
     64b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     652:	e8 1e 09 00 00       	call   f75 <printf>
      exit();
     657:	e8 14 07 00 00       	call   d70 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     65c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     663:	00 
     664:	8b 45 0c             	mov    0xc(%ebp),%eax
     667:	89 04 24             	mov    %eax,(%esp)
     66a:	e8 41 07 00 00       	call   db0 <open>
     66f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     672:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     676:	79 20                	jns    698 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     678:	8b 45 0c             	mov    0xc(%ebp),%eax
     67b:	89 44 24 08          	mov    %eax,0x8(%esp)
     67f:	c7 44 24 04 0a 15 00 	movl   $0x150a,0x4(%esp)
     686:	00 
     687:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     68e:	e8 e2 08 00 00       	call   f75 <printf>
      exit();
     693:	e8 d8 06 00 00       	call   d70 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     698:	eb 3b                	jmp    6d5 <copy+0xc2>
  {
      max = used_disk+=count;
     69a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     69d:	01 45 10             	add    %eax,0x10(%ebp)
     6a0:	8b 45 10             	mov    0x10(%ebp),%eax
     6a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     6a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6a9:	3b 45 14             	cmp    0x14(%ebp),%eax
     6ac:	7e 07                	jle    6b5 <copy+0xa2>
      {
        return -1;
     6ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     6b3:	eb 5c                	jmp    711 <copy+0xfe>
      }
      bytes = bytes + count;
     6b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6b8:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     6bb:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     6c2:	00 
     6c3:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     6c6:	89 44 24 04          	mov    %eax,0x4(%esp)
     6ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6cd:	89 04 24             	mov    %eax,(%esp)
     6d0:	e8 bb 06 00 00       	call   d90 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     6d5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     6dc:	00 
     6dd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     6e0:	89 44 24 04          	mov    %eax,0x4(%esp)
     6e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6e7:	89 04 24             	mov    %eax,(%esp)
     6ea:	e8 99 06 00 00       	call   d88 <read>
     6ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
     6f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     6f6:	7f a2                	jg     69a <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     6f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6fb:	89 04 24             	mov    %eax,(%esp)
     6fe:	e8 95 06 00 00       	call   d98 <close>
  close(fd2);
     703:	8b 45 ec             	mov    -0x14(%ebp),%eax
     706:	89 04 24             	mov    %eax,(%esp)
     709:	e8 8a 06 00 00       	call   d98 <close>
  return(bytes);
     70e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     711:	c9                   	leave  
     712:	c3                   	ret    

00000713 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     713:	55                   	push   %ebp
     714:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     716:	eb 06                	jmp    71e <strcmp+0xb>
    p++, q++;
     718:	ff 45 08             	incl   0x8(%ebp)
     71b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     71e:	8b 45 08             	mov    0x8(%ebp),%eax
     721:	8a 00                	mov    (%eax),%al
     723:	84 c0                	test   %al,%al
     725:	74 0e                	je     735 <strcmp+0x22>
     727:	8b 45 08             	mov    0x8(%ebp),%eax
     72a:	8a 10                	mov    (%eax),%dl
     72c:	8b 45 0c             	mov    0xc(%ebp),%eax
     72f:	8a 00                	mov    (%eax),%al
     731:	38 c2                	cmp    %al,%dl
     733:	74 e3                	je     718 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     735:	8b 45 08             	mov    0x8(%ebp),%eax
     738:	8a 00                	mov    (%eax),%al
     73a:	0f b6 d0             	movzbl %al,%edx
     73d:	8b 45 0c             	mov    0xc(%ebp),%eax
     740:	8a 00                	mov    (%eax),%al
     742:	0f b6 c0             	movzbl %al,%eax
     745:	29 c2                	sub    %eax,%edx
     747:	89 d0                	mov    %edx,%eax
}
     749:	5d                   	pop    %ebp
     74a:	c3                   	ret    

0000074b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     74b:	55                   	push   %ebp
     74c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     74e:	eb 09                	jmp    759 <strncmp+0xe>
    n--, p++, q++;
     750:	ff 4d 10             	decl   0x10(%ebp)
     753:	ff 45 08             	incl   0x8(%ebp)
     756:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     759:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     75d:	74 17                	je     776 <strncmp+0x2b>
     75f:	8b 45 08             	mov    0x8(%ebp),%eax
     762:	8a 00                	mov    (%eax),%al
     764:	84 c0                	test   %al,%al
     766:	74 0e                	je     776 <strncmp+0x2b>
     768:	8b 45 08             	mov    0x8(%ebp),%eax
     76b:	8a 10                	mov    (%eax),%dl
     76d:	8b 45 0c             	mov    0xc(%ebp),%eax
     770:	8a 00                	mov    (%eax),%al
     772:	38 c2                	cmp    %al,%dl
     774:	74 da                	je     750 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     776:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     77a:	75 07                	jne    783 <strncmp+0x38>
    return 0;
     77c:	b8 00 00 00 00       	mov    $0x0,%eax
     781:	eb 14                	jmp    797 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     783:	8b 45 08             	mov    0x8(%ebp),%eax
     786:	8a 00                	mov    (%eax),%al
     788:	0f b6 d0             	movzbl %al,%edx
     78b:	8b 45 0c             	mov    0xc(%ebp),%eax
     78e:	8a 00                	mov    (%eax),%al
     790:	0f b6 c0             	movzbl %al,%eax
     793:	29 c2                	sub    %eax,%edx
     795:	89 d0                	mov    %edx,%eax
}
     797:	5d                   	pop    %ebp
     798:	c3                   	ret    

00000799 <strlen>:

uint
strlen(const char *s)
{
     799:	55                   	push   %ebp
     79a:	89 e5                	mov    %esp,%ebp
     79c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     79f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     7a6:	eb 03                	jmp    7ab <strlen+0x12>
     7a8:	ff 45 fc             	incl   -0x4(%ebp)
     7ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
     7ae:	8b 45 08             	mov    0x8(%ebp),%eax
     7b1:	01 d0                	add    %edx,%eax
     7b3:	8a 00                	mov    (%eax),%al
     7b5:	84 c0                	test   %al,%al
     7b7:	75 ef                	jne    7a8 <strlen+0xf>
    ;
  return n;
     7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     7bc:	c9                   	leave  
     7bd:	c3                   	ret    

000007be <memset>:

void*
memset(void *dst, int c, uint n)
{
     7be:	55                   	push   %ebp
     7bf:	89 e5                	mov    %esp,%ebp
     7c1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     7c4:	8b 45 10             	mov    0x10(%ebp),%eax
     7c7:	89 44 24 08          	mov    %eax,0x8(%esp)
     7cb:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     7d2:	8b 45 08             	mov    0x8(%ebp),%eax
     7d5:	89 04 24             	mov    %eax,(%esp)
     7d8:	e8 e3 fd ff ff       	call   5c0 <stosb>
  return dst;
     7dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
     7e0:	c9                   	leave  
     7e1:	c3                   	ret    

000007e2 <strchr>:

char*
strchr(const char *s, char c)
{
     7e2:	55                   	push   %ebp
     7e3:	89 e5                	mov    %esp,%ebp
     7e5:	83 ec 04             	sub    $0x4,%esp
     7e8:	8b 45 0c             	mov    0xc(%ebp),%eax
     7eb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     7ee:	eb 12                	jmp    802 <strchr+0x20>
    if(*s == c)
     7f0:	8b 45 08             	mov    0x8(%ebp),%eax
     7f3:	8a 00                	mov    (%eax),%al
     7f5:	3a 45 fc             	cmp    -0x4(%ebp),%al
     7f8:	75 05                	jne    7ff <strchr+0x1d>
      return (char*)s;
     7fa:	8b 45 08             	mov    0x8(%ebp),%eax
     7fd:	eb 11                	jmp    810 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     7ff:	ff 45 08             	incl   0x8(%ebp)
     802:	8b 45 08             	mov    0x8(%ebp),%eax
     805:	8a 00                	mov    (%eax),%al
     807:	84 c0                	test   %al,%al
     809:	75 e5                	jne    7f0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     80b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     810:	c9                   	leave  
     811:	c3                   	ret    

00000812 <strcat>:

char *
strcat(char *dest, const char *src)
{
     812:	55                   	push   %ebp
     813:	89 e5                	mov    %esp,%ebp
     815:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     818:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     81f:	eb 03                	jmp    824 <strcat+0x12>
     821:	ff 45 fc             	incl   -0x4(%ebp)
     824:	8b 55 fc             	mov    -0x4(%ebp),%edx
     827:	8b 45 08             	mov    0x8(%ebp),%eax
     82a:	01 d0                	add    %edx,%eax
     82c:	8a 00                	mov    (%eax),%al
     82e:	84 c0                	test   %al,%al
     830:	75 ef                	jne    821 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     832:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     839:	eb 1e                	jmp    859 <strcat+0x47>
        dest[i+j] = src[j];
     83b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     83e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     841:	01 d0                	add    %edx,%eax
     843:	89 c2                	mov    %eax,%edx
     845:	8b 45 08             	mov    0x8(%ebp),%eax
     848:	01 c2                	add    %eax,%edx
     84a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     84d:	8b 45 0c             	mov    0xc(%ebp),%eax
     850:	01 c8                	add    %ecx,%eax
     852:	8a 00                	mov    (%eax),%al
     854:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     856:	ff 45 f8             	incl   -0x8(%ebp)
     859:	8b 55 f8             	mov    -0x8(%ebp),%edx
     85c:	8b 45 0c             	mov    0xc(%ebp),%eax
     85f:	01 d0                	add    %edx,%eax
     861:	8a 00                	mov    (%eax),%al
     863:	84 c0                	test   %al,%al
     865:	75 d4                	jne    83b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     867:	8b 45 f8             	mov    -0x8(%ebp),%eax
     86a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     86d:	01 d0                	add    %edx,%eax
     86f:	89 c2                	mov    %eax,%edx
     871:	8b 45 08             	mov    0x8(%ebp),%eax
     874:	01 d0                	add    %edx,%eax
     876:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     879:	8b 45 08             	mov    0x8(%ebp),%eax
}
     87c:	c9                   	leave  
     87d:	c3                   	ret    

0000087e <strstr>:

int 
strstr(char* s, char* sub)
{
     87e:	55                   	push   %ebp
     87f:	89 e5                	mov    %esp,%ebp
     881:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     884:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     88b:	eb 7c                	jmp    909 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     88d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     890:	8b 45 08             	mov    0x8(%ebp),%eax
     893:	01 d0                	add    %edx,%eax
     895:	8a 10                	mov    (%eax),%dl
     897:	8b 45 0c             	mov    0xc(%ebp),%eax
     89a:	8a 00                	mov    (%eax),%al
     89c:	38 c2                	cmp    %al,%dl
     89e:	75 66                	jne    906 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     8a0:	8b 45 0c             	mov    0xc(%ebp),%eax
     8a3:	89 04 24             	mov    %eax,(%esp)
     8a6:	e8 ee fe ff ff       	call   799 <strlen>
     8ab:	83 f8 01             	cmp    $0x1,%eax
     8ae:	75 05                	jne    8b5 <strstr+0x37>
            {  
                return i;
     8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8b3:	eb 6b                	jmp    920 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     8b5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     8bc:	eb 3a                	jmp    8f8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     8be:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     8c4:	01 d0                	add    %edx,%eax
     8c6:	89 c2                	mov    %eax,%edx
     8c8:	8b 45 08             	mov    0x8(%ebp),%eax
     8cb:	01 d0                	add    %edx,%eax
     8cd:	8a 10                	mov    (%eax),%dl
     8cf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     8d2:	8b 45 0c             	mov    0xc(%ebp),%eax
     8d5:	01 c8                	add    %ecx,%eax
     8d7:	8a 00                	mov    (%eax),%al
     8d9:	38 c2                	cmp    %al,%dl
     8db:	75 16                	jne    8f3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     8dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8e0:	8d 50 01             	lea    0x1(%eax),%edx
     8e3:	8b 45 0c             	mov    0xc(%ebp),%eax
     8e6:	01 d0                	add    %edx,%eax
     8e8:	8a 00                	mov    (%eax),%al
     8ea:	84 c0                	test   %al,%al
     8ec:	75 07                	jne    8f5 <strstr+0x77>
                    {
                        return i;
     8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8f1:	eb 2d                	jmp    920 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     8f3:	eb 11                	jmp    906 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     8f5:	ff 45 f8             	incl   -0x8(%ebp)
     8f8:	8b 55 f8             	mov    -0x8(%ebp),%edx
     8fb:	8b 45 0c             	mov    0xc(%ebp),%eax
     8fe:	01 d0                	add    %edx,%eax
     900:	8a 00                	mov    (%eax),%al
     902:	84 c0                	test   %al,%al
     904:	75 b8                	jne    8be <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     906:	ff 45 fc             	incl   -0x4(%ebp)
     909:	8b 55 fc             	mov    -0x4(%ebp),%edx
     90c:	8b 45 08             	mov    0x8(%ebp),%eax
     90f:	01 d0                	add    %edx,%eax
     911:	8a 00                	mov    (%eax),%al
     913:	84 c0                	test   %al,%al
     915:	0f 85 72 ff ff ff    	jne    88d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     91b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     920:	c9                   	leave  
     921:	c3                   	ret    

00000922 <strtok>:

char *
strtok(char *s, const char *delim)
{
     922:	55                   	push   %ebp
     923:	89 e5                	mov    %esp,%ebp
     925:	53                   	push   %ebx
     926:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     929:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     92d:	75 08                	jne    937 <strtok+0x15>
  s = lasts;
     92f:	a1 c4 19 00 00       	mov    0x19c4,%eax
     934:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     937:	8b 45 08             	mov    0x8(%ebp),%eax
     93a:	8d 50 01             	lea    0x1(%eax),%edx
     93d:	89 55 08             	mov    %edx,0x8(%ebp)
     940:	8a 00                	mov    (%eax),%al
     942:	0f be d8             	movsbl %al,%ebx
     945:	85 db                	test   %ebx,%ebx
     947:	75 07                	jne    950 <strtok+0x2e>
      return 0;
     949:	b8 00 00 00 00       	mov    $0x0,%eax
     94e:	eb 58                	jmp    9a8 <strtok+0x86>
    } while (strchr(delim, ch));
     950:	88 d8                	mov    %bl,%al
     952:	0f be c0             	movsbl %al,%eax
     955:	89 44 24 04          	mov    %eax,0x4(%esp)
     959:	8b 45 0c             	mov    0xc(%ebp),%eax
     95c:	89 04 24             	mov    %eax,(%esp)
     95f:	e8 7e fe ff ff       	call   7e2 <strchr>
     964:	85 c0                	test   %eax,%eax
     966:	75 cf                	jne    937 <strtok+0x15>
    --s;
     968:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     96b:	8b 45 0c             	mov    0xc(%ebp),%eax
     96e:	89 44 24 04          	mov    %eax,0x4(%esp)
     972:	8b 45 08             	mov    0x8(%ebp),%eax
     975:	89 04 24             	mov    %eax,(%esp)
     978:	e8 31 00 00 00       	call   9ae <strcspn>
     97d:	89 c2                	mov    %eax,%edx
     97f:	8b 45 08             	mov    0x8(%ebp),%eax
     982:	01 d0                	add    %edx,%eax
     984:	a3 c4 19 00 00       	mov    %eax,0x19c4
    if (*lasts != 0)
     989:	a1 c4 19 00 00       	mov    0x19c4,%eax
     98e:	8a 00                	mov    (%eax),%al
     990:	84 c0                	test   %al,%al
     992:	74 11                	je     9a5 <strtok+0x83>
  *lasts++ = 0;
     994:	a1 c4 19 00 00       	mov    0x19c4,%eax
     999:	8d 50 01             	lea    0x1(%eax),%edx
     99c:	89 15 c4 19 00 00    	mov    %edx,0x19c4
     9a2:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     9a5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9a8:	83 c4 14             	add    $0x14,%esp
     9ab:	5b                   	pop    %ebx
     9ac:	5d                   	pop    %ebp
     9ad:	c3                   	ret    

000009ae <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     9ae:	55                   	push   %ebp
     9af:	89 e5                	mov    %esp,%ebp
     9b1:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     9b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     9bb:	eb 26                	jmp    9e3 <strcspn+0x35>
        if(strchr(s2,*s1))
     9bd:	8b 45 08             	mov    0x8(%ebp),%eax
     9c0:	8a 00                	mov    (%eax),%al
     9c2:	0f be c0             	movsbl %al,%eax
     9c5:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c9:	8b 45 0c             	mov    0xc(%ebp),%eax
     9cc:	89 04 24             	mov    %eax,(%esp)
     9cf:	e8 0e fe ff ff       	call   7e2 <strchr>
     9d4:	85 c0                	test   %eax,%eax
     9d6:	74 05                	je     9dd <strcspn+0x2f>
            return ret;
     9d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9db:	eb 12                	jmp    9ef <strcspn+0x41>
        else
            s1++,ret++;
     9dd:	ff 45 08             	incl   0x8(%ebp)
     9e0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     9e3:	8b 45 08             	mov    0x8(%ebp),%eax
     9e6:	8a 00                	mov    (%eax),%al
     9e8:	84 c0                	test   %al,%al
     9ea:	75 d1                	jne    9bd <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     9ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     9ef:	c9                   	leave  
     9f0:	c3                   	ret    

000009f1 <isspace>:

int
isspace(unsigned char c)
{
     9f1:	55                   	push   %ebp
     9f2:	89 e5                	mov    %esp,%ebp
     9f4:	83 ec 04             	sub    $0x4,%esp
     9f7:	8b 45 08             	mov    0x8(%ebp),%eax
     9fa:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     9fd:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     a01:	74 1e                	je     a21 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     a03:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     a07:	74 18                	je     a21 <isspace+0x30>
     a09:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     a0d:	74 12                	je     a21 <isspace+0x30>
     a0f:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     a13:	74 0c                	je     a21 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     a15:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     a19:	74 06                	je     a21 <isspace+0x30>
     a1b:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     a1f:	75 07                	jne    a28 <isspace+0x37>
     a21:	b8 01 00 00 00       	mov    $0x1,%eax
     a26:	eb 05                	jmp    a2d <isspace+0x3c>
     a28:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a2d:	c9                   	leave  
     a2e:	c3                   	ret    

00000a2f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     a2f:	55                   	push   %ebp
     a30:	89 e5                	mov    %esp,%ebp
     a32:	57                   	push   %edi
     a33:	56                   	push   %esi
     a34:	53                   	push   %ebx
     a35:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     a38:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     a3d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     a44:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     a47:	eb 01                	jmp    a4a <strtoul+0x1b>
  p += 1;
     a49:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     a4a:	8a 03                	mov    (%ebx),%al
     a4c:	0f b6 c0             	movzbl %al,%eax
     a4f:	89 04 24             	mov    %eax,(%esp)
     a52:	e8 9a ff ff ff       	call   9f1 <isspace>
     a57:	85 c0                	test   %eax,%eax
     a59:	75 ee                	jne    a49 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     a5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     a5f:	75 30                	jne    a91 <strtoul+0x62>
    {
  if (*p == '0') {
     a61:	8a 03                	mov    (%ebx),%al
     a63:	3c 30                	cmp    $0x30,%al
     a65:	75 21                	jne    a88 <strtoul+0x59>
      p += 1;
     a67:	43                   	inc    %ebx
      if (*p == 'x') {
     a68:	8a 03                	mov    (%ebx),%al
     a6a:	3c 78                	cmp    $0x78,%al
     a6c:	75 0a                	jne    a78 <strtoul+0x49>
    p += 1;
     a6e:	43                   	inc    %ebx
    base = 16;
     a6f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     a76:	eb 31                	jmp    aa9 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     a78:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     a7f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     a86:	eb 21                	jmp    aa9 <strtoul+0x7a>
      }
  }
  else base = 10;
     a88:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     a8f:	eb 18                	jmp    aa9 <strtoul+0x7a>
    } else if (base == 16) {
     a91:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     a95:	75 12                	jne    aa9 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     a97:	8a 03                	mov    (%ebx),%al
     a99:	3c 30                	cmp    $0x30,%al
     a9b:	75 0c                	jne    aa9 <strtoul+0x7a>
     a9d:	8d 43 01             	lea    0x1(%ebx),%eax
     aa0:	8a 00                	mov    (%eax),%al
     aa2:	3c 78                	cmp    $0x78,%al
     aa4:	75 03                	jne    aa9 <strtoul+0x7a>
      p += 2;
     aa6:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     aa9:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     aad:	75 29                	jne    ad8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     aaf:	8a 03                	mov    (%ebx),%al
     ab1:	0f be c0             	movsbl %al,%eax
     ab4:	83 e8 30             	sub    $0x30,%eax
     ab7:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     ab9:	83 fe 07             	cmp    $0x7,%esi
     abc:	76 06                	jbe    ac4 <strtoul+0x95>
    break;
     abe:	90                   	nop
     abf:	e9 b6 00 00 00       	jmp    b7a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     ac4:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     acb:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     ace:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     ad5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     ad6:	eb d7                	jmp    aaf <strtoul+0x80>
    } else if (base == 10) {
     ad8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     adc:	75 2b                	jne    b09 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     ade:	8a 03                	mov    (%ebx),%al
     ae0:	0f be c0             	movsbl %al,%eax
     ae3:	83 e8 30             	sub    $0x30,%eax
     ae6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     ae8:	83 fe 09             	cmp    $0x9,%esi
     aeb:	76 06                	jbe    af3 <strtoul+0xc4>
    break;
     aed:	90                   	nop
     aee:	e9 87 00 00 00       	jmp    b7a <strtoul+0x14b>
      }
      result = (10*result) + digit;
     af3:	89 f8                	mov    %edi,%eax
     af5:	c1 e0 02             	shl    $0x2,%eax
     af8:	01 f8                	add    %edi,%eax
     afa:	01 c0                	add    %eax,%eax
     afc:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     aff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     b06:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     b07:	eb d5                	jmp    ade <strtoul+0xaf>
    } else if (base == 16) {
     b09:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     b0d:	75 35                	jne    b44 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     b0f:	8a 03                	mov    (%ebx),%al
     b11:	0f be c0             	movsbl %al,%eax
     b14:	83 e8 30             	sub    $0x30,%eax
     b17:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     b19:	83 fe 4a             	cmp    $0x4a,%esi
     b1c:	76 02                	jbe    b20 <strtoul+0xf1>
    break;
     b1e:	eb 22                	jmp    b42 <strtoul+0x113>
      }
      digit = cvtIn[digit];
     b20:	8a 86 60 19 00 00    	mov    0x1960(%esi),%al
     b26:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     b29:	83 fe 0f             	cmp    $0xf,%esi
     b2c:	76 02                	jbe    b30 <strtoul+0x101>
    break;
     b2e:	eb 12                	jmp    b42 <strtoul+0x113>
      }
      result = (result << 4) + digit;
     b30:	89 f8                	mov    %edi,%eax
     b32:	c1 e0 04             	shl    $0x4,%eax
     b35:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b38:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     b3f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     b40:	eb cd                	jmp    b0f <strtoul+0xe0>
     b42:	eb 36                	jmp    b7a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     b44:	8a 03                	mov    (%ebx),%al
     b46:	0f be c0             	movsbl %al,%eax
     b49:	83 e8 30             	sub    $0x30,%eax
     b4c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     b4e:	83 fe 4a             	cmp    $0x4a,%esi
     b51:	76 02                	jbe    b55 <strtoul+0x126>
    break;
     b53:	eb 25                	jmp    b7a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     b55:	8a 86 60 19 00 00    	mov    0x1960(%esi),%al
     b5b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     b5e:	8b 45 10             	mov    0x10(%ebp),%eax
     b61:	39 f0                	cmp    %esi,%eax
     b63:	77 02                	ja     b67 <strtoul+0x138>
    break;
     b65:	eb 13                	jmp    b7a <strtoul+0x14b>
      }
      result = result*base + digit;
     b67:	8b 45 10             	mov    0x10(%ebp),%eax
     b6a:	0f af c7             	imul   %edi,%eax
     b6d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b70:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     b77:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     b78:	eb ca                	jmp    b44 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b7e:	75 03                	jne    b83 <strtoul+0x154>
  p = string;
     b80:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     b83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     b87:	74 05                	je     b8e <strtoul+0x15f>
  *endPtr = p;
     b89:	8b 45 0c             	mov    0xc(%ebp),%eax
     b8c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     b8e:	89 f8                	mov    %edi,%eax
}
     b90:	83 c4 14             	add    $0x14,%esp
     b93:	5b                   	pop    %ebx
     b94:	5e                   	pop    %esi
     b95:	5f                   	pop    %edi
     b96:	5d                   	pop    %ebp
     b97:	c3                   	ret    

00000b98 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     b98:	55                   	push   %ebp
     b99:	89 e5                	mov    %esp,%ebp
     b9b:	53                   	push   %ebx
     b9c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     b9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     ba2:	eb 01                	jmp    ba5 <strtol+0xd>
      p += 1;
     ba4:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     ba5:	8a 03                	mov    (%ebx),%al
     ba7:	0f b6 c0             	movzbl %al,%eax
     baa:	89 04 24             	mov    %eax,(%esp)
     bad:	e8 3f fe ff ff       	call   9f1 <isspace>
     bb2:	85 c0                	test   %eax,%eax
     bb4:	75 ee                	jne    ba4 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     bb6:	8a 03                	mov    (%ebx),%al
     bb8:	3c 2d                	cmp    $0x2d,%al
     bba:	75 1e                	jne    bda <strtol+0x42>
  p += 1;
     bbc:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     bbd:	8b 45 10             	mov    0x10(%ebp),%eax
     bc0:	89 44 24 08          	mov    %eax,0x8(%esp)
     bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     bcb:	89 1c 24             	mov    %ebx,(%esp)
     bce:	e8 5c fe ff ff       	call   a2f <strtoul>
     bd3:	f7 d8                	neg    %eax
     bd5:	89 45 f8             	mov    %eax,-0x8(%ebp)
     bd8:	eb 20                	jmp    bfa <strtol+0x62>
    } else {
  if (*p == '+') {
     bda:	8a 03                	mov    (%ebx),%al
     bdc:	3c 2b                	cmp    $0x2b,%al
     bde:	75 01                	jne    be1 <strtol+0x49>
      p += 1;
     be0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     be1:	8b 45 10             	mov    0x10(%ebp),%eax
     be4:	89 44 24 08          	mov    %eax,0x8(%esp)
     be8:	8b 45 0c             	mov    0xc(%ebp),%eax
     beb:	89 44 24 04          	mov    %eax,0x4(%esp)
     bef:	89 1c 24             	mov    %ebx,(%esp)
     bf2:	e8 38 fe ff ff       	call   a2f <strtoul>
     bf7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     bfa:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     bfe:	75 17                	jne    c17 <strtol+0x7f>
     c00:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     c04:	74 11                	je     c17 <strtol+0x7f>
     c06:	8b 45 0c             	mov    0xc(%ebp),%eax
     c09:	8b 00                	mov    (%eax),%eax
     c0b:	39 d8                	cmp    %ebx,%eax
     c0d:	75 08                	jne    c17 <strtol+0x7f>
  *endPtr = string;
     c0f:	8b 45 0c             	mov    0xc(%ebp),%eax
     c12:	8b 55 08             	mov    0x8(%ebp),%edx
     c15:	89 10                	mov    %edx,(%eax)
    }
    return result;
     c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     c1a:	83 c4 1c             	add    $0x1c,%esp
     c1d:	5b                   	pop    %ebx
     c1e:	5d                   	pop    %ebp
     c1f:	c3                   	ret    

00000c20 <gets>:

char*
gets(char *buf, int max)
{
     c20:	55                   	push   %ebp
     c21:	89 e5                	mov    %esp,%ebp
     c23:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c2d:	eb 49                	jmp    c78 <gets+0x58>
    cc = read(0, &c, 1);
     c2f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c36:	00 
     c37:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
     c3e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c45:	e8 3e 01 00 00       	call   d88 <read>
     c4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c51:	7f 02                	jg     c55 <gets+0x35>
      break;
     c53:	eb 2c                	jmp    c81 <gets+0x61>
    buf[i++] = c;
     c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c58:	8d 50 01             	lea    0x1(%eax),%edx
     c5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c5e:	89 c2                	mov    %eax,%edx
     c60:	8b 45 08             	mov    0x8(%ebp),%eax
     c63:	01 c2                	add    %eax,%edx
     c65:	8a 45 ef             	mov    -0x11(%ebp),%al
     c68:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     c6a:	8a 45 ef             	mov    -0x11(%ebp),%al
     c6d:	3c 0a                	cmp    $0xa,%al
     c6f:	74 10                	je     c81 <gets+0x61>
     c71:	8a 45 ef             	mov    -0x11(%ebp),%al
     c74:	3c 0d                	cmp    $0xd,%al
     c76:	74 09                	je     c81 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c7b:	40                   	inc    %eax
     c7c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c7f:	7c ae                	jl     c2f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c81:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c84:	8b 45 08             	mov    0x8(%ebp),%eax
     c87:	01 d0                	add    %edx,%eax
     c89:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     c8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c8f:	c9                   	leave  
     c90:	c3                   	ret    

00000c91 <stat>:

int
stat(char *n, struct stat *st)
{
     c91:	55                   	push   %ebp
     c92:	89 e5                	mov    %esp,%ebp
     c94:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c97:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c9e:	00 
     c9f:	8b 45 08             	mov    0x8(%ebp),%eax
     ca2:	89 04 24             	mov    %eax,(%esp)
     ca5:	e8 06 01 00 00       	call   db0 <open>
     caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     cb1:	79 07                	jns    cba <stat+0x29>
    return -1;
     cb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cb8:	eb 23                	jmp    cdd <stat+0x4c>
  r = fstat(fd, st);
     cba:	8b 45 0c             	mov    0xc(%ebp),%eax
     cbd:	89 44 24 04          	mov    %eax,0x4(%esp)
     cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc4:	89 04 24             	mov    %eax,(%esp)
     cc7:	e8 fc 00 00 00       	call   dc8 <fstat>
     ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cd2:	89 04 24             	mov    %eax,(%esp)
     cd5:	e8 be 00 00 00       	call   d98 <close>
  return r;
     cda:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cdd:	c9                   	leave  
     cde:	c3                   	ret    

00000cdf <atoi>:

int
atoi(const char *s)
{
     cdf:	55                   	push   %ebp
     ce0:	89 e5                	mov    %esp,%ebp
     ce2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     cec:	eb 24                	jmp    d12 <atoi+0x33>
    n = n*10 + *s++ - '0';
     cee:	8b 55 fc             	mov    -0x4(%ebp),%edx
     cf1:	89 d0                	mov    %edx,%eax
     cf3:	c1 e0 02             	shl    $0x2,%eax
     cf6:	01 d0                	add    %edx,%eax
     cf8:	01 c0                	add    %eax,%eax
     cfa:	89 c1                	mov    %eax,%ecx
     cfc:	8b 45 08             	mov    0x8(%ebp),%eax
     cff:	8d 50 01             	lea    0x1(%eax),%edx
     d02:	89 55 08             	mov    %edx,0x8(%ebp)
     d05:	8a 00                	mov    (%eax),%al
     d07:	0f be c0             	movsbl %al,%eax
     d0a:	01 c8                	add    %ecx,%eax
     d0c:	83 e8 30             	sub    $0x30,%eax
     d0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d12:	8b 45 08             	mov    0x8(%ebp),%eax
     d15:	8a 00                	mov    (%eax),%al
     d17:	3c 2f                	cmp    $0x2f,%al
     d19:	7e 09                	jle    d24 <atoi+0x45>
     d1b:	8b 45 08             	mov    0x8(%ebp),%eax
     d1e:	8a 00                	mov    (%eax),%al
     d20:	3c 39                	cmp    $0x39,%al
     d22:	7e ca                	jle    cee <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     d24:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d27:	c9                   	leave  
     d28:	c3                   	ret    

00000d29 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d29:	55                   	push   %ebp
     d2a:	89 e5                	mov    %esp,%ebp
     d2c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     d2f:	8b 45 08             	mov    0x8(%ebp),%eax
     d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d35:	8b 45 0c             	mov    0xc(%ebp),%eax
     d38:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d3b:	eb 16                	jmp    d53 <memmove+0x2a>
    *dst++ = *src++;
     d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d40:	8d 50 01             	lea    0x1(%eax),%edx
     d43:	89 55 fc             	mov    %edx,-0x4(%ebp)
     d46:	8b 55 f8             	mov    -0x8(%ebp),%edx
     d49:	8d 4a 01             	lea    0x1(%edx),%ecx
     d4c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     d4f:	8a 12                	mov    (%edx),%dl
     d51:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d53:	8b 45 10             	mov    0x10(%ebp),%eax
     d56:	8d 50 ff             	lea    -0x1(%eax),%edx
     d59:	89 55 10             	mov    %edx,0x10(%ebp)
     d5c:	85 c0                	test   %eax,%eax
     d5e:	7f dd                	jg     d3d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d60:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d63:	c9                   	leave  
     d64:	c3                   	ret    
     d65:	90                   	nop
     d66:	90                   	nop
     d67:	90                   	nop

00000d68 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d68:	b8 01 00 00 00       	mov    $0x1,%eax
     d6d:	cd 40                	int    $0x40
     d6f:	c3                   	ret    

00000d70 <exit>:
SYSCALL(exit)
     d70:	b8 02 00 00 00       	mov    $0x2,%eax
     d75:	cd 40                	int    $0x40
     d77:	c3                   	ret    

00000d78 <wait>:
SYSCALL(wait)
     d78:	b8 03 00 00 00       	mov    $0x3,%eax
     d7d:	cd 40                	int    $0x40
     d7f:	c3                   	ret    

00000d80 <pipe>:
SYSCALL(pipe)
     d80:	b8 04 00 00 00       	mov    $0x4,%eax
     d85:	cd 40                	int    $0x40
     d87:	c3                   	ret    

00000d88 <read>:
SYSCALL(read)
     d88:	b8 05 00 00 00       	mov    $0x5,%eax
     d8d:	cd 40                	int    $0x40
     d8f:	c3                   	ret    

00000d90 <write>:
SYSCALL(write)
     d90:	b8 10 00 00 00       	mov    $0x10,%eax
     d95:	cd 40                	int    $0x40
     d97:	c3                   	ret    

00000d98 <close>:
SYSCALL(close)
     d98:	b8 15 00 00 00       	mov    $0x15,%eax
     d9d:	cd 40                	int    $0x40
     d9f:	c3                   	ret    

00000da0 <kill>:
SYSCALL(kill)
     da0:	b8 06 00 00 00       	mov    $0x6,%eax
     da5:	cd 40                	int    $0x40
     da7:	c3                   	ret    

00000da8 <exec>:
SYSCALL(exec)
     da8:	b8 07 00 00 00       	mov    $0x7,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <open>:
SYSCALL(open)
     db0:	b8 0f 00 00 00       	mov    $0xf,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <mknod>:
SYSCALL(mknod)
     db8:	b8 11 00 00 00       	mov    $0x11,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <unlink>:
SYSCALL(unlink)
     dc0:	b8 12 00 00 00       	mov    $0x12,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <fstat>:
SYSCALL(fstat)
     dc8:	b8 08 00 00 00       	mov    $0x8,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <link>:
SYSCALL(link)
     dd0:	b8 13 00 00 00       	mov    $0x13,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <mkdir>:
SYSCALL(mkdir)
     dd8:	b8 14 00 00 00       	mov    $0x14,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <chdir>:
SYSCALL(chdir)
     de0:	b8 09 00 00 00       	mov    $0x9,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <dup>:
SYSCALL(dup)
     de8:	b8 0a 00 00 00       	mov    $0xa,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <getpid>:
SYSCALL(getpid)
     df0:	b8 0b 00 00 00       	mov    $0xb,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <sbrk>:
SYSCALL(sbrk)
     df8:	b8 0c 00 00 00       	mov    $0xc,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <sleep>:
SYSCALL(sleep)
     e00:	b8 0d 00 00 00       	mov    $0xd,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <uptime>:
SYSCALL(uptime)
     e08:	b8 0e 00 00 00       	mov    $0xe,%eax
     e0d:	cd 40                	int    $0x40
     e0f:	c3                   	ret    

00000e10 <getname>:
SYSCALL(getname)
     e10:	b8 16 00 00 00       	mov    $0x16,%eax
     e15:	cd 40                	int    $0x40
     e17:	c3                   	ret    

00000e18 <setname>:
SYSCALL(setname)
     e18:	b8 17 00 00 00       	mov    $0x17,%eax
     e1d:	cd 40                	int    $0x40
     e1f:	c3                   	ret    

00000e20 <getmaxproc>:
SYSCALL(getmaxproc)
     e20:	b8 18 00 00 00       	mov    $0x18,%eax
     e25:	cd 40                	int    $0x40
     e27:	c3                   	ret    

00000e28 <setmaxproc>:
SYSCALL(setmaxproc)
     e28:	b8 19 00 00 00       	mov    $0x19,%eax
     e2d:	cd 40                	int    $0x40
     e2f:	c3                   	ret    

00000e30 <getmaxmem>:
SYSCALL(getmaxmem)
     e30:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e35:	cd 40                	int    $0x40
     e37:	c3                   	ret    

00000e38 <setmaxmem>:
SYSCALL(setmaxmem)
     e38:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e3d:	cd 40                	int    $0x40
     e3f:	c3                   	ret    

00000e40 <getmaxdisk>:
SYSCALL(getmaxdisk)
     e40:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e45:	cd 40                	int    $0x40
     e47:	c3                   	ret    

00000e48 <setmaxdisk>:
SYSCALL(setmaxdisk)
     e48:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e4d:	cd 40                	int    $0x40
     e4f:	c3                   	ret    

00000e50 <getusedmem>:
SYSCALL(getusedmem)
     e50:	b8 1e 00 00 00       	mov    $0x1e,%eax
     e55:	cd 40                	int    $0x40
     e57:	c3                   	ret    

00000e58 <setusedmem>:
SYSCALL(setusedmem)
     e58:	b8 1f 00 00 00       	mov    $0x1f,%eax
     e5d:	cd 40                	int    $0x40
     e5f:	c3                   	ret    

00000e60 <getuseddisk>:
SYSCALL(getuseddisk)
     e60:	b8 20 00 00 00       	mov    $0x20,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <setuseddisk>:
SYSCALL(setuseddisk)
     e68:	b8 21 00 00 00       	mov    $0x21,%eax
     e6d:	cd 40                	int    $0x40
     e6f:	c3                   	ret    

00000e70 <setvc>:
SYSCALL(setvc)
     e70:	b8 22 00 00 00       	mov    $0x22,%eax
     e75:	cd 40                	int    $0x40
     e77:	c3                   	ret    

00000e78 <setactivefs>:
SYSCALL(setactivefs)
     e78:	b8 24 00 00 00       	mov    $0x24,%eax
     e7d:	cd 40                	int    $0x40
     e7f:	c3                   	ret    

00000e80 <getactivefs>:
SYSCALL(getactivefs)
     e80:	b8 25 00 00 00       	mov    $0x25,%eax
     e85:	cd 40                	int    $0x40
     e87:	c3                   	ret    

00000e88 <getvcfs>:
SYSCALL(getvcfs)
     e88:	b8 23 00 00 00       	mov    $0x23,%eax
     e8d:	cd 40                	int    $0x40
     e8f:	c3                   	ret    

00000e90 <getcwd>:
SYSCALL(getcwd)
     e90:	b8 26 00 00 00       	mov    $0x26,%eax
     e95:	cd 40                	int    $0x40
     e97:	c3                   	ret    

00000e98 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e98:	55                   	push   %ebp
     e99:	89 e5                	mov    %esp,%ebp
     e9b:	83 ec 18             	sub    $0x18,%esp
     e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     ea4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     eab:	00 
     eac:	8d 45 f4             	lea    -0xc(%ebp),%eax
     eaf:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb3:	8b 45 08             	mov    0x8(%ebp),%eax
     eb6:	89 04 24             	mov    %eax,(%esp)
     eb9:	e8 d2 fe ff ff       	call   d90 <write>
}
     ebe:	c9                   	leave  
     ebf:	c3                   	ret    

00000ec0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
     ec3:	56                   	push   %esi
     ec4:	53                   	push   %ebx
     ec5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     ec8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     ecf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     ed3:	74 17                	je     eec <printint+0x2c>
     ed5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     ed9:	79 11                	jns    eec <printint+0x2c>
    neg = 1;
     edb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     ee2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ee5:	f7 d8                	neg    %eax
     ee7:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eea:	eb 06                	jmp    ef2 <printint+0x32>
  } else {
    x = xx;
     eec:	8b 45 0c             	mov    0xc(%ebp),%eax
     eef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     ef2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     ef9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     efc:	8d 41 01             	lea    0x1(%ecx),%eax
     eff:	89 45 f4             	mov    %eax,-0xc(%ebp)
     f02:	8b 5d 10             	mov    0x10(%ebp),%ebx
     f05:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f08:	ba 00 00 00 00       	mov    $0x0,%edx
     f0d:	f7 f3                	div    %ebx
     f0f:	89 d0                	mov    %edx,%eax
     f11:	8a 80 ac 19 00 00    	mov    0x19ac(%eax),%al
     f17:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     f1b:	8b 75 10             	mov    0x10(%ebp),%esi
     f1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f21:	ba 00 00 00 00       	mov    $0x0,%edx
     f26:	f7 f6                	div    %esi
     f28:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f2f:	75 c8                	jne    ef9 <printint+0x39>
  if(neg)
     f31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f35:	74 10                	je     f47 <printint+0x87>
    buf[i++] = '-';
     f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f3a:	8d 50 01             	lea    0x1(%eax),%edx
     f3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     f40:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     f45:	eb 1e                	jmp    f65 <printint+0xa5>
     f47:	eb 1c                	jmp    f65 <printint+0xa5>
    putc(fd, buf[i]);
     f49:	8d 55 dc             	lea    -0x24(%ebp),%edx
     f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f4f:	01 d0                	add    %edx,%eax
     f51:	8a 00                	mov    (%eax),%al
     f53:	0f be c0             	movsbl %al,%eax
     f56:	89 44 24 04          	mov    %eax,0x4(%esp)
     f5a:	8b 45 08             	mov    0x8(%ebp),%eax
     f5d:	89 04 24             	mov    %eax,(%esp)
     f60:	e8 33 ff ff ff       	call   e98 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f65:	ff 4d f4             	decl   -0xc(%ebp)
     f68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f6c:	79 db                	jns    f49 <printint+0x89>
    putc(fd, buf[i]);
}
     f6e:	83 c4 30             	add    $0x30,%esp
     f71:	5b                   	pop    %ebx
     f72:	5e                   	pop    %esi
     f73:	5d                   	pop    %ebp
     f74:	c3                   	ret    

00000f75 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f75:	55                   	push   %ebp
     f76:	89 e5                	mov    %esp,%ebp
     f78:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f82:	8d 45 0c             	lea    0xc(%ebp),%eax
     f85:	83 c0 04             	add    $0x4,%eax
     f88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f92:	e9 77 01 00 00       	jmp    110e <printf+0x199>
    c = fmt[i] & 0xff;
     f97:	8b 55 0c             	mov    0xc(%ebp),%edx
     f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f9d:	01 d0                	add    %edx,%eax
     f9f:	8a 00                	mov    (%eax),%al
     fa1:	0f be c0             	movsbl %al,%eax
     fa4:	25 ff 00 00 00       	and    $0xff,%eax
     fa9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     fac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     fb0:	75 2c                	jne    fde <printf+0x69>
      if(c == '%'){
     fb2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     fb6:	75 0c                	jne    fc4 <printf+0x4f>
        state = '%';
     fb8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     fbf:	e9 47 01 00 00       	jmp    110b <printf+0x196>
      } else {
        putc(fd, c);
     fc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fc7:	0f be c0             	movsbl %al,%eax
     fca:	89 44 24 04          	mov    %eax,0x4(%esp)
     fce:	8b 45 08             	mov    0x8(%ebp),%eax
     fd1:	89 04 24             	mov    %eax,(%esp)
     fd4:	e8 bf fe ff ff       	call   e98 <putc>
     fd9:	e9 2d 01 00 00       	jmp    110b <printf+0x196>
      }
    } else if(state == '%'){
     fde:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     fe2:	0f 85 23 01 00 00    	jne    110b <printf+0x196>
      if(c == 'd'){
     fe8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     fec:	75 2d                	jne    101b <printf+0xa6>
        printint(fd, *ap, 10, 1);
     fee:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ff1:	8b 00                	mov    (%eax),%eax
     ff3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     ffa:	00 
     ffb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1002:	00 
    1003:	89 44 24 04          	mov    %eax,0x4(%esp)
    1007:	8b 45 08             	mov    0x8(%ebp),%eax
    100a:	89 04 24             	mov    %eax,(%esp)
    100d:	e8 ae fe ff ff       	call   ec0 <printint>
        ap++;
    1012:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1016:	e9 e9 00 00 00       	jmp    1104 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    101b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    101f:	74 06                	je     1027 <printf+0xb2>
    1021:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1025:	75 2d                	jne    1054 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    1027:	8b 45 e8             	mov    -0x18(%ebp),%eax
    102a:	8b 00                	mov    (%eax),%eax
    102c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1033:	00 
    1034:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    103b:	00 
    103c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1040:	8b 45 08             	mov    0x8(%ebp),%eax
    1043:	89 04 24             	mov    %eax,(%esp)
    1046:	e8 75 fe ff ff       	call   ec0 <printint>
        ap++;
    104b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    104f:	e9 b0 00 00 00       	jmp    1104 <printf+0x18f>
      } else if(c == 's'){
    1054:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1058:	75 42                	jne    109c <printf+0x127>
        s = (char*)*ap;
    105a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    105d:	8b 00                	mov    (%eax),%eax
    105f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1062:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    106a:	75 09                	jne    1075 <printf+0x100>
          s = "(null)";
    106c:	c7 45 f4 26 15 00 00 	movl   $0x1526,-0xc(%ebp)
        while(*s != 0){
    1073:	eb 1c                	jmp    1091 <printf+0x11c>
    1075:	eb 1a                	jmp    1091 <printf+0x11c>
          putc(fd, *s);
    1077:	8b 45 f4             	mov    -0xc(%ebp),%eax
    107a:	8a 00                	mov    (%eax),%al
    107c:	0f be c0             	movsbl %al,%eax
    107f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1083:	8b 45 08             	mov    0x8(%ebp),%eax
    1086:	89 04 24             	mov    %eax,(%esp)
    1089:	e8 0a fe ff ff       	call   e98 <putc>
          s++;
    108e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1091:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1094:	8a 00                	mov    (%eax),%al
    1096:	84 c0                	test   %al,%al
    1098:	75 dd                	jne    1077 <printf+0x102>
    109a:	eb 68                	jmp    1104 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    109c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    10a0:	75 1d                	jne    10bf <printf+0x14a>
        putc(fd, *ap);
    10a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    10a5:	8b 00                	mov    (%eax),%eax
    10a7:	0f be c0             	movsbl %al,%eax
    10aa:	89 44 24 04          	mov    %eax,0x4(%esp)
    10ae:	8b 45 08             	mov    0x8(%ebp),%eax
    10b1:	89 04 24             	mov    %eax,(%esp)
    10b4:	e8 df fd ff ff       	call   e98 <putc>
        ap++;
    10b9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    10bd:	eb 45                	jmp    1104 <printf+0x18f>
      } else if(c == '%'){
    10bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    10c3:	75 17                	jne    10dc <printf+0x167>
        putc(fd, c);
    10c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10c8:	0f be c0             	movsbl %al,%eax
    10cb:	89 44 24 04          	mov    %eax,0x4(%esp)
    10cf:	8b 45 08             	mov    0x8(%ebp),%eax
    10d2:	89 04 24             	mov    %eax,(%esp)
    10d5:	e8 be fd ff ff       	call   e98 <putc>
    10da:	eb 28                	jmp    1104 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10dc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    10e3:	00 
    10e4:	8b 45 08             	mov    0x8(%ebp),%eax
    10e7:	89 04 24             	mov    %eax,(%esp)
    10ea:	e8 a9 fd ff ff       	call   e98 <putc>
        putc(fd, c);
    10ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10f2:	0f be c0             	movsbl %al,%eax
    10f5:	89 44 24 04          	mov    %eax,0x4(%esp)
    10f9:	8b 45 08             	mov    0x8(%ebp),%eax
    10fc:	89 04 24             	mov    %eax,(%esp)
    10ff:	e8 94 fd ff ff       	call   e98 <putc>
      }
      state = 0;
    1104:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    110b:	ff 45 f0             	incl   -0x10(%ebp)
    110e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1111:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1114:	01 d0                	add    %edx,%eax
    1116:	8a 00                	mov    (%eax),%al
    1118:	84 c0                	test   %al,%al
    111a:	0f 85 77 fe ff ff    	jne    f97 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1120:	c9                   	leave  
    1121:	c3                   	ret    
    1122:	90                   	nop
    1123:	90                   	nop

00001124 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1124:	55                   	push   %ebp
    1125:	89 e5                	mov    %esp,%ebp
    1127:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    112a:	8b 45 08             	mov    0x8(%ebp),%eax
    112d:	83 e8 08             	sub    $0x8,%eax
    1130:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1133:	a1 d0 19 00 00       	mov    0x19d0,%eax
    1138:	89 45 fc             	mov    %eax,-0x4(%ebp)
    113b:	eb 24                	jmp    1161 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    113d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1140:	8b 00                	mov    (%eax),%eax
    1142:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1145:	77 12                	ja     1159 <free+0x35>
    1147:	8b 45 f8             	mov    -0x8(%ebp),%eax
    114a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    114d:	77 24                	ja     1173 <free+0x4f>
    114f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1152:	8b 00                	mov    (%eax),%eax
    1154:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1157:	77 1a                	ja     1173 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1159:	8b 45 fc             	mov    -0x4(%ebp),%eax
    115c:	8b 00                	mov    (%eax),%eax
    115e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1161:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1164:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1167:	76 d4                	jbe    113d <free+0x19>
    1169:	8b 45 fc             	mov    -0x4(%ebp),%eax
    116c:	8b 00                	mov    (%eax),%eax
    116e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1171:	76 ca                	jbe    113d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1173:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1176:	8b 40 04             	mov    0x4(%eax),%eax
    1179:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1180:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1183:	01 c2                	add    %eax,%edx
    1185:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1188:	8b 00                	mov    (%eax),%eax
    118a:	39 c2                	cmp    %eax,%edx
    118c:	75 24                	jne    11b2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    118e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1191:	8b 50 04             	mov    0x4(%eax),%edx
    1194:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1197:	8b 00                	mov    (%eax),%eax
    1199:	8b 40 04             	mov    0x4(%eax),%eax
    119c:	01 c2                	add    %eax,%edx
    119e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11a1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    11a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11a7:	8b 00                	mov    (%eax),%eax
    11a9:	8b 10                	mov    (%eax),%edx
    11ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ae:	89 10                	mov    %edx,(%eax)
    11b0:	eb 0a                	jmp    11bc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    11b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b5:	8b 10                	mov    (%eax),%edx
    11b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ba:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    11bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11bf:	8b 40 04             	mov    0x4(%eax),%eax
    11c2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    11c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11cc:	01 d0                	add    %edx,%eax
    11ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11d1:	75 20                	jne    11f3 <free+0xcf>
    p->s.size += bp->s.size;
    11d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d6:	8b 50 04             	mov    0x4(%eax),%edx
    11d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11dc:	8b 40 04             	mov    0x4(%eax),%eax
    11df:	01 c2                	add    %eax,%edx
    11e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11e4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ea:	8b 10                	mov    (%eax),%edx
    11ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ef:	89 10                	mov    %edx,(%eax)
    11f1:	eb 08                	jmp    11fb <free+0xd7>
  } else
    p->s.ptr = bp;
    11f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11f6:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11f9:	89 10                	mov    %edx,(%eax)
  freep = p;
    11fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11fe:	a3 d0 19 00 00       	mov    %eax,0x19d0
}
    1203:	c9                   	leave  
    1204:	c3                   	ret    

00001205 <morecore>:

static Header*
morecore(uint nu)
{
    1205:	55                   	push   %ebp
    1206:	89 e5                	mov    %esp,%ebp
    1208:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    120b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1212:	77 07                	ja     121b <morecore+0x16>
    nu = 4096;
    1214:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    121b:	8b 45 08             	mov    0x8(%ebp),%eax
    121e:	c1 e0 03             	shl    $0x3,%eax
    1221:	89 04 24             	mov    %eax,(%esp)
    1224:	e8 cf fb ff ff       	call   df8 <sbrk>
    1229:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    122c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1230:	75 07                	jne    1239 <morecore+0x34>
    return 0;
    1232:	b8 00 00 00 00       	mov    $0x0,%eax
    1237:	eb 22                	jmp    125b <morecore+0x56>
  hp = (Header*)p;
    1239:	8b 45 f4             	mov    -0xc(%ebp),%eax
    123c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1242:	8b 55 08             	mov    0x8(%ebp),%edx
    1245:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1248:	8b 45 f0             	mov    -0x10(%ebp),%eax
    124b:	83 c0 08             	add    $0x8,%eax
    124e:	89 04 24             	mov    %eax,(%esp)
    1251:	e8 ce fe ff ff       	call   1124 <free>
  return freep;
    1256:	a1 d0 19 00 00       	mov    0x19d0,%eax
}
    125b:	c9                   	leave  
    125c:	c3                   	ret    

0000125d <malloc>:

void*
malloc(uint nbytes)
{
    125d:	55                   	push   %ebp
    125e:	89 e5                	mov    %esp,%ebp
    1260:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1263:	8b 45 08             	mov    0x8(%ebp),%eax
    1266:	83 c0 07             	add    $0x7,%eax
    1269:	c1 e8 03             	shr    $0x3,%eax
    126c:	40                   	inc    %eax
    126d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1270:	a1 d0 19 00 00       	mov    0x19d0,%eax
    1275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1278:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    127c:	75 23                	jne    12a1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    127e:	c7 45 f0 c8 19 00 00 	movl   $0x19c8,-0x10(%ebp)
    1285:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1288:	a3 d0 19 00 00       	mov    %eax,0x19d0
    128d:	a1 d0 19 00 00       	mov    0x19d0,%eax
    1292:	a3 c8 19 00 00       	mov    %eax,0x19c8
    base.s.size = 0;
    1297:	c7 05 cc 19 00 00 00 	movl   $0x0,0x19cc
    129e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12a4:	8b 00                	mov    (%eax),%eax
    12a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    12a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ac:	8b 40 04             	mov    0x4(%eax),%eax
    12af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12b2:	72 4d                	jb     1301 <malloc+0xa4>
      if(p->s.size == nunits)
    12b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b7:	8b 40 04             	mov    0x4(%eax),%eax
    12ba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    12bd:	75 0c                	jne    12cb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    12bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c2:	8b 10                	mov    (%eax),%edx
    12c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12c7:	89 10                	mov    %edx,(%eax)
    12c9:	eb 26                	jmp    12f1 <malloc+0x94>
      else {
        p->s.size -= nunits;
    12cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ce:	8b 40 04             	mov    0x4(%eax),%eax
    12d1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    12d4:	89 c2                	mov    %eax,%edx
    12d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    12dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12df:	8b 40 04             	mov    0x4(%eax),%eax
    12e2:	c1 e0 03             	shl    $0x3,%eax
    12e5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    12e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12eb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    12ee:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    12f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12f4:	a3 d0 19 00 00       	mov    %eax,0x19d0
      return (void*)(p + 1);
    12f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12fc:	83 c0 08             	add    $0x8,%eax
    12ff:	eb 38                	jmp    1339 <malloc+0xdc>
    }
    if(p == freep)
    1301:	a1 d0 19 00 00       	mov    0x19d0,%eax
    1306:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1309:	75 1b                	jne    1326 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    130b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    130e:	89 04 24             	mov    %eax,(%esp)
    1311:	e8 ef fe ff ff       	call   1205 <morecore>
    1316:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1319:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    131d:	75 07                	jne    1326 <malloc+0xc9>
        return 0;
    131f:	b8 00 00 00 00       	mov    $0x0,%eax
    1324:	eb 13                	jmp    1339 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1326:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1329:	89 45 f0             	mov    %eax,-0x10(%ebp)
    132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    132f:	8b 00                	mov    (%eax),%eax
    1331:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1334:	e9 70 ff ff ff       	jmp    12a9 <malloc+0x4c>
}
    1339:	c9                   	leave  
    133a:	c3                   	ret    
