
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
       c:	c7 44 24 04 18 13 00 	movl   $0x1318,0x4(%esp)
      13:	00 
      14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      1b:	e8 31 0f 00 00       	call   f51 <printf>
  }
  if(mode == 1){ // create
      20:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
      24:	75 14                	jne    3a <print_usage+0x3a>
    printf(1, "Usage: ctool create <container> <max proc> <max mem> <max disk> <exec1> <exec2> ...\n");
      26:	c7 44 24 04 34 13 00 	movl   $0x1334,0x4(%esp)
      2d:	00 
      2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      35:	e8 17 0f 00 00       	call   f51 <printf>
  }
  if(mode == 2){ // create with container created
      3a:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
      3e:	75 14                	jne    54 <print_usage+0x54>
    printf(1, "Container taken. Failed to create, exiting...\n");
      40:	c7 44 24 04 8c 13 00 	movl   $0x138c,0x4(%esp)
      47:	00 
      48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      4f:	e8 fd 0e 00 00       	call   f51 <printf>
  }
  if(mode == 3){ // start
      54:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
      58:	75 14                	jne    6e <print_usage+0x6e>
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
      5a:	c7 44 24 04 bc 13 00 	movl   $0x13bc,0x4(%esp)
      61:	00 
      62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      69:	e8 e3 0e 00 00       	call   f51 <printf>
  }
  if(mode == 4){ // delete
      6e:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
      72:	75 14                	jne    88 <print_usage+0x88>
    printf(1, "Usage: ctool delete <container>\n");
      74:	c7 44 24 04 f0 13 00 	movl   $0x13f0,0x4(%esp)
      7b:	00 
      7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      83:	e8 c9 0e 00 00       	call   f51 <printf>
  }
  
  exit();
      88:	e8 bf 0c 00 00       	call   d4c <exit>

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
      fc:	e8 8b 0c 00 00       	call   d8c <open>
     101:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "fd = %d\n", fd);
     104:	8b 45 f4             	mov    -0xc(%ebp),%eax
     107:	89 44 24 08          	mov    %eax,0x8(%esp)
     10b:	c7 44 24 04 11 14 00 	movl   $0x1411,0x4(%esp)
     112:	00 
     113:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     11a:	e8 32 0e 00 00       	call   f51 <printf>
  /* fork a child and exec argv[4] */
  id = fork();
     11f:	e8 20 0c 00 00       	call   d44 <fork>
     124:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(id == 0){
     127:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     12b:	0f 85 9c 00 00 00    	jne    1cd <start+0xea>
    close(0);
     131:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     138:	e8 37 0c 00 00       	call   d74 <close>
    close(1);
     13d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     144:	e8 2b 0c 00 00       	call   d74 <close>
    close(2);
     149:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     150:	e8 1f 0c 00 00       	call   d74 <close>
    dup(fd);
     155:	8b 45 f4             	mov    -0xc(%ebp),%eax
     158:	89 04 24             	mov    %eax,(%esp)
     15b:	e8 64 0c 00 00       	call   dc4 <dup>
    dup(fd);
     160:	8b 45 f4             	mov    -0xc(%ebp),%eax
     163:	89 04 24             	mov    %eax,(%esp)
     166:	e8 59 0c 00 00       	call   dc4 <dup>
    dup(fd);
     16b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     16e:	89 04 24             	mov    %eax,(%esp)
     171:	e8 4e 0c 00 00       	call   dc4 <dup>
    if(chdir(argv[3]) < 0){
     176:	8b 45 0c             	mov    0xc(%ebp),%eax
     179:	83 c0 0c             	add    $0xc,%eax
     17c:	8b 00                	mov    (%eax),%eax
     17e:	89 04 24             	mov    %eax,(%esp)
     181:	e8 36 0c 00 00       	call   dbc <chdir>
     186:	85 c0                	test   %eax,%eax
     188:	79 19                	jns    1a3 <start+0xc0>
      printf(1, "Container does not exist.");
     18a:	c7 44 24 04 1a 14 00 	movl   $0x141a,0x4(%esp)
     191:	00 
     192:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     199:	e8 b3 0d 00 00       	call   f51 <printf>
      exit();
     19e:	e8 a9 0b 00 00       	call   d4c <exit>
    }
    exec(argv[4], &argv[4]);
     1a3:	8b 45 0c             	mov    0xc(%ebp),%eax
     1a6:	8d 50 10             	lea    0x10(%eax),%edx
     1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     1ac:	83 c0 10             	add    $0x10,%eax
     1af:	8b 00                	mov    (%eax),%eax
     1b1:	89 54 24 04          	mov    %edx,0x4(%esp)
     1b5:	89 04 24             	mov    %eax,(%esp)
     1b8:	e8 c7 0b 00 00       	call   d84 <exec>
    close(fd);
     1bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c0:	89 04 24             	mov    %eax,(%esp)
     1c3:	e8 ac 0b 00 00       	call   d74 <close>
    exit();
     1c8:	e8 7f 0b 00 00       	call   d4c <exit>
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
     1ec:	c7 45 e0 34 14 00 00 	movl   $0x1434,-0x20(%ebp)
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
     231:	e8 be 0b 00 00       	call   df4 <setname>
  setmaxproc(cindex, atoi(argv[3]));
     236:	8b 45 0c             	mov    0xc(%ebp),%eax
     239:	83 c0 0c             	add    $0xc,%eax
     23c:	8b 00                	mov    (%eax),%eax
     23e:	89 04 24             	mov    %eax,(%esp)
     241:	e8 75 0a 00 00       	call   cbb <atoi>
     246:	89 44 24 04          	mov    %eax,0x4(%esp)
     24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     24d:	89 04 24             	mov    %eax,(%esp)
     250:	e8 af 0b 00 00       	call   e04 <setmaxproc>
  setmaxmem(cindex, atoi(argv[4]) * 1000000);
     255:	8b 45 0c             	mov    0xc(%ebp),%eax
     258:	83 c0 10             	add    $0x10,%eax
     25b:	8b 00                	mov    (%eax),%eax
     25d:	89 04 24             	mov    %eax,(%esp)
     260:	e8 56 0a 00 00       	call   cbb <atoi>
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
     2a8:	e8 67 0b 00 00       	call   e14 <setmaxmem>
  setmaxdisk(cindex, atoi(argv[5]) * 1000000);
     2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     2b0:	83 c0 14             	add    $0x14,%eax
     2b3:	8b 00                	mov    (%eax),%eax
     2b5:	89 04 24             	mov    %eax,(%esp)
     2b8:	e8 fe 09 00 00       	call   cbb <atoi>
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
     300:	e8 1f 0b 00 00       	call   e24 <setmaxdisk>
  setusedmem(cindex, 0);
     305:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     30c:	00 
     30d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     310:	89 04 24             	mov    %eax,(%esp)
     313:	e8 1c 0b 00 00       	call   e34 <setusedmem>
  setuseddisk(cindex, 0);
     318:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     31f:	00 
     320:	8b 45 f0             	mov    -0x10(%ebp),%eax
     323:	89 04 24             	mov    %eax,(%esp)
     326:	e8 19 0b 00 00       	call   e44 <setuseddisk>


  id = fork();
     32b:	e8 14 0a 00 00       	call   d44 <fork>
     330:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0){
     333:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     337:	75 12                	jne    34b <create+0x16d>
    exec(mkdir[0], mkdir);
     339:	8b 45 e0             	mov    -0x20(%ebp),%eax
     33c:	8d 55 e0             	lea    -0x20(%ebp),%edx
     33f:	89 54 24 04          	mov    %edx,0x4(%esp)
     343:	89 04 24             	mov    %eax,(%esp)
     346:	e8 39 0a 00 00       	call   d84 <exec>
  }
  id = wait();
     34b:	e8 04 0a 00 00       	call   d54 <wait>
     350:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     353:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     35a:	e9 66 01 00 00       	jmp    4c5 <create+0x2e7>
    char destination[32];

    strcpy(destination, "/");
     35f:	c7 44 24 04 3a 14 00 	movl   $0x143a,0x4(%esp)
     366:	00 
     367:	8d 45 b8             	lea    -0x48(%ebp),%eax
     36a:	89 04 24             	mov    %eax,(%esp)
     36d:	e8 4f 02 00 00       	call   5c1 <strcpy>
    strcat(destination, mkdir[1]);
     372:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     375:	89 44 24 04          	mov    %eax,0x4(%esp)
     379:	8d 45 b8             	lea    -0x48(%ebp),%eax
     37c:	89 04 24             	mov    %eax,(%esp)
     37f:	e8 6a 04 00 00       	call   7ee <strcat>
    strcat(destination, "/");
     384:	c7 44 24 04 3a 14 00 	movl   $0x143a,0x4(%esp)
     38b:	00 
     38c:	8d 45 b8             	lea    -0x48(%ebp),%eax
     38f:	89 04 24             	mov    %eax,(%esp)
     392:	e8 57 04 00 00       	call   7ee <strcat>
    strcat(destination, argv[i]);
     397:	8b 45 f4             	mov    -0xc(%ebp),%eax
     39a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
     3a4:	01 d0                	add    %edx,%eax
     3a6:	8b 00                	mov    (%eax),%eax
     3a8:	89 44 24 04          	mov    %eax,0x4(%esp)
     3ac:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3af:	89 04 24             	mov    %eax,(%esp)
     3b2:	e8 37 04 00 00       	call   7ee <strcat>
    strcat(destination, "\0");
     3b7:	c7 44 24 04 3c 14 00 	movl   $0x143c,0x4(%esp)
     3be:	00 
     3bf:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3c2:	89 04 24             	mov    %eax,(%esp)
     3c5:	e8 24 04 00 00       	call   7ee <strcat>

    // ctable.tuperwares[i].files[i-6] = argv[i];
    bytes = copy(argv[i], destination, getuseddisk(cindex), getmaxdisk(cindex));
     3ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3cd:	89 04 24             	mov    %eax,(%esp)
     3d0:	e8 47 0a 00 00       	call   e1c <getmaxdisk>
     3d5:	89 c3                	mov    %eax,%ebx
     3d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3da:	89 04 24             	mov    %eax,(%esp)
     3dd:	e8 5a 0a 00 00       	call   e3c <getuseddisk>
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
     405:	e8 e5 01 00 00       	call   5ef <copy>
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
     429:	c7 44 24 04 3e 14 00 	movl   $0x143e,0x4(%esp)
     430:	00 
     431:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     438:	e8 14 0b 00 00       	call   f51 <printf>

    if(bytes > 0){
     43d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     441:	7e 21                	jle    464 <create+0x286>
      setuseddisk(cindex, getuseddisk(cindex) + bytes);
     443:	8b 45 f0             	mov    -0x10(%ebp),%eax
     446:	89 04 24             	mov    %eax,(%esp)
     449:	e8 ee 09 00 00       	call   e3c <getuseddisk>
     44e:	8b 55 e8             	mov    -0x18(%ebp),%edx
     451:	01 d0                	add    %edx,%eax
     453:	89 44 24 04          	mov    %eax,0x4(%esp)
     457:	8b 45 f0             	mov    -0x10(%ebp),%eax
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 e2 09 00 00       	call   e44 <setuseddisk>
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
     479:	c7 44 24 04 50 14 00 	movl   $0x1450,0x4(%esp)
     480:	00 
     481:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     488:	e8 c4 0a 00 00       	call   f51 <printf>
      id = fork();
     48d:	e8 b2 08 00 00       	call   d44 <fork>
     492:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(id == 0){
     495:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     499:	75 1f                	jne    4ba <create+0x2dc>
        char *remove_args[2];
        remove_args[0] = "rm";
     49b:	c7 45 d8 a6 14 00 00 	movl   $0x14a6,-0x28(%ebp)
        remove_args[1] = destination;
     4a2:	8d 45 b8             	lea    -0x48(%ebp),%eax
     4a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
        exec(remove_args[0], remove_args);
     4a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
     4ab:	8d 55 d8             	lea    -0x28(%ebp),%edx
     4ae:	89 54 24 04          	mov    %edx,0x4(%esp)
     4b2:	89 04 24             	mov    %eax,(%esp)
     4b5:	e8 ca 08 00 00       	call   d84 <exec>
      }
      id = wait();
     4ba:	e8 95 08 00 00       	call   d54 <wait>
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
    }
  }

  // TODO: IMPLEMENT GET/SET FILES
  // ctable.tuperwares[cindex].files = files;
  return 0;
     4d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
     4d6:	83 c4 54             	add    $0x54,%esp
     4d9:	5b                   	pop    %ebx
     4da:	5d                   	pop    %ebp
     4db:	c3                   	ret    

000004dc <main>:

int main(int argc, char *argv[]){
     4dc:	55                   	push   %ebp
     4dd:	89 e5                	mov    %esp,%ebp
     4df:	83 e4 f0             	and    $0xfffffff0,%esp
     4e2:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2){
     4e5:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     4e9:	7f 0c                	jg     4f7 <main+0x1b>
    print_usage(0);
     4eb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     4f2:	e8 09 fb ff ff       	call   0 <print_usage>
  }

  if(strcmp(argv[1], "create") == 0){
     4f7:	8b 45 0c             	mov    0xc(%ebp),%eax
     4fa:	83 c0 04             	add    $0x4,%eax
     4fd:	8b 00                	mov    (%eax),%eax
     4ff:	c7 44 24 04 a9 14 00 	movl   $0x14a9,0x4(%esp)
     506:	00 
     507:	89 04 24             	mov    %eax,(%esp)
     50a:	e8 e0 01 00 00       	call   6ef <strcmp>
     50f:	85 c0                	test   %eax,%eax
     511:	75 44                	jne    557 <main+0x7b>
    if(argc < 7){
     513:	83 7d 08 06          	cmpl   $0x6,0x8(%ebp)
     517:	7f 0c                	jg     525 <main+0x49>
      print_usage(1);
     519:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     520:	e8 db fa ff ff       	call   0 <print_usage>
    }
    if(chdir(argv[2]) > 0){
     525:	8b 45 0c             	mov    0xc(%ebp),%eax
     528:	83 c0 08             	add    $0x8,%eax
     52b:	8b 00                	mov    (%eax),%eax
     52d:	89 04 24             	mov    %eax,(%esp)
     530:	e8 87 08 00 00       	call   dbc <chdir>
     535:	85 c0                	test   %eax,%eax
     537:	7e 0c                	jle    545 <main+0x69>
      print_usage(2);
     539:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     540:	e8 bb fa ff ff       	call   0 <print_usage>
    }
    create(argc, argv);
     545:	8b 45 0c             	mov    0xc(%ebp),%eax
     548:	89 44 24 04          	mov    %eax,0x4(%esp)
     54c:	8b 45 08             	mov    0x8(%ebp),%eax
     54f:	89 04 24             	mov    %eax,(%esp)
     552:	e8 87 fc ff ff       	call   1de <create>
  }

  if(strcmp(argv[1], "start") == 0){
     557:	8b 45 0c             	mov    0xc(%ebp),%eax
     55a:	83 c0 04             	add    $0x4,%eax
     55d:	8b 00                	mov    (%eax),%eax
     55f:	c7 44 24 04 b0 14 00 	movl   $0x14b0,0x4(%esp)
     566:	00 
     567:	89 04 24             	mov    %eax,(%esp)
     56a:	e8 80 01 00 00       	call   6ef <strcmp>
     56f:	85 c0                	test   %eax,%eax
     571:	75 24                	jne    597 <main+0xbb>
    if(argc < 5){
     573:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     577:	7f 0c                	jg     585 <main+0xa9>
      print_usage(3);
     579:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     580:	e8 7b fa ff ff       	call   0 <print_usage>
    }
    start(argc, argv);
     585:	8b 45 0c             	mov    0xc(%ebp),%eax
     588:	89 44 24 04          	mov    %eax,0x4(%esp)
     58c:	8b 45 08             	mov    0x8(%ebp),%eax
     58f:	89 04 24             	mov    %eax,(%esp)
     592:	e8 4c fb ff ff       	call   e3 <start>
  //   if(argc < 3){
  //     print_usage(4);
  //   }
  //   delete(argv);
  // }
  exit();
     597:	e8 b0 07 00 00       	call   d4c <exit>

0000059c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     59c:	55                   	push   %ebp
     59d:	89 e5                	mov    %esp,%ebp
     59f:	57                   	push   %edi
     5a0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     5a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
     5a4:	8b 55 10             	mov    0x10(%ebp),%edx
     5a7:	8b 45 0c             	mov    0xc(%ebp),%eax
     5aa:	89 cb                	mov    %ecx,%ebx
     5ac:	89 df                	mov    %ebx,%edi
     5ae:	89 d1                	mov    %edx,%ecx
     5b0:	fc                   	cld    
     5b1:	f3 aa                	rep stos %al,%es:(%edi)
     5b3:	89 ca                	mov    %ecx,%edx
     5b5:	89 fb                	mov    %edi,%ebx
     5b7:	89 5d 08             	mov    %ebx,0x8(%ebp)
     5ba:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     5bd:	5b                   	pop    %ebx
     5be:	5f                   	pop    %edi
     5bf:	5d                   	pop    %ebp
     5c0:	c3                   	ret    

000005c1 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     5c1:	55                   	push   %ebp
     5c2:	89 e5                	mov    %esp,%ebp
     5c4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     5c7:	8b 45 08             	mov    0x8(%ebp),%eax
     5ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     5cd:	90                   	nop
     5ce:	8b 45 08             	mov    0x8(%ebp),%eax
     5d1:	8d 50 01             	lea    0x1(%eax),%edx
     5d4:	89 55 08             	mov    %edx,0x8(%ebp)
     5d7:	8b 55 0c             	mov    0xc(%ebp),%edx
     5da:	8d 4a 01             	lea    0x1(%edx),%ecx
     5dd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     5e0:	8a 12                	mov    (%edx),%dl
     5e2:	88 10                	mov    %dl,(%eax)
     5e4:	8a 00                	mov    (%eax),%al
     5e6:	84 c0                	test   %al,%al
     5e8:	75 e4                	jne    5ce <strcpy+0xd>
    ;
  return os;
     5ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     5ed:	c9                   	leave  
     5ee:	c3                   	ret    

000005ef <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     5ef:	55                   	push   %ebp
     5f0:	89 e5                	mov    %esp,%ebp
     5f2:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     5f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     5fc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     603:	00 
     604:	8b 45 08             	mov    0x8(%ebp),%eax
     607:	89 04 24             	mov    %eax,(%esp)
     60a:	e8 7d 07 00 00       	call   d8c <open>
     60f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     612:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     616:	79 20                	jns    638 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     618:	8b 45 08             	mov    0x8(%ebp),%eax
     61b:	89 44 24 08          	mov    %eax,0x8(%esp)
     61f:	c7 44 24 04 b6 14 00 	movl   $0x14b6,0x4(%esp)
     626:	00 
     627:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     62e:	e8 1e 09 00 00       	call   f51 <printf>
      exit();
     633:	e8 14 07 00 00       	call   d4c <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     638:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     63f:	00 
     640:	8b 45 0c             	mov    0xc(%ebp),%eax
     643:	89 04 24             	mov    %eax,(%esp)
     646:	e8 41 07 00 00       	call   d8c <open>
     64b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     64e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     652:	79 20                	jns    674 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     654:	8b 45 0c             	mov    0xc(%ebp),%eax
     657:	89 44 24 08          	mov    %eax,0x8(%esp)
     65b:	c7 44 24 04 d1 14 00 	movl   $0x14d1,0x4(%esp)
     662:	00 
     663:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     66a:	e8 e2 08 00 00       	call   f51 <printf>
      exit();
     66f:	e8 d8 06 00 00       	call   d4c <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     674:	eb 3b                	jmp    6b1 <copy+0xc2>
  {
      max = used_disk+=count;
     676:	8b 45 e8             	mov    -0x18(%ebp),%eax
     679:	01 45 10             	add    %eax,0x10(%ebp)
     67c:	8b 45 10             	mov    0x10(%ebp),%eax
     67f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     685:	3b 45 14             	cmp    0x14(%ebp),%eax
     688:	7e 07                	jle    691 <copy+0xa2>
      {
        return -1;
     68a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     68f:	eb 5c                	jmp    6ed <copy+0xfe>
      }
      bytes = bytes + count;
     691:	8b 45 e8             	mov    -0x18(%ebp),%eax
     694:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     697:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     69e:	00 
     69f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     6a2:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6a9:	89 04 24             	mov    %eax,(%esp)
     6ac:	e8 bb 06 00 00       	call   d6c <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     6b1:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     6b8:	00 
     6b9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     6bc:	89 44 24 04          	mov    %eax,0x4(%esp)
     6c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6c3:	89 04 24             	mov    %eax,(%esp)
     6c6:	e8 99 06 00 00       	call   d64 <read>
     6cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
     6ce:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     6d2:	7f a2                	jg     676 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     6d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6d7:	89 04 24             	mov    %eax,(%esp)
     6da:	e8 95 06 00 00       	call   d74 <close>
  close(fd2);
     6df:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6e2:	89 04 24             	mov    %eax,(%esp)
     6e5:	e8 8a 06 00 00       	call   d74 <close>
  return(bytes);
     6ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6ed:	c9                   	leave  
     6ee:	c3                   	ret    

000006ef <strcmp>:

int
strcmp(const char *p, const char *q)
{
     6ef:	55                   	push   %ebp
     6f0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     6f2:	eb 06                	jmp    6fa <strcmp+0xb>
    p++, q++;
     6f4:	ff 45 08             	incl   0x8(%ebp)
     6f7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     6fa:	8b 45 08             	mov    0x8(%ebp),%eax
     6fd:	8a 00                	mov    (%eax),%al
     6ff:	84 c0                	test   %al,%al
     701:	74 0e                	je     711 <strcmp+0x22>
     703:	8b 45 08             	mov    0x8(%ebp),%eax
     706:	8a 10                	mov    (%eax),%dl
     708:	8b 45 0c             	mov    0xc(%ebp),%eax
     70b:	8a 00                	mov    (%eax),%al
     70d:	38 c2                	cmp    %al,%dl
     70f:	74 e3                	je     6f4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     711:	8b 45 08             	mov    0x8(%ebp),%eax
     714:	8a 00                	mov    (%eax),%al
     716:	0f b6 d0             	movzbl %al,%edx
     719:	8b 45 0c             	mov    0xc(%ebp),%eax
     71c:	8a 00                	mov    (%eax),%al
     71e:	0f b6 c0             	movzbl %al,%eax
     721:	29 c2                	sub    %eax,%edx
     723:	89 d0                	mov    %edx,%eax
}
     725:	5d                   	pop    %ebp
     726:	c3                   	ret    

00000727 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     727:	55                   	push   %ebp
     728:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     72a:	eb 09                	jmp    735 <strncmp+0xe>
    n--, p++, q++;
     72c:	ff 4d 10             	decl   0x10(%ebp)
     72f:	ff 45 08             	incl   0x8(%ebp)
     732:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     735:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     739:	74 17                	je     752 <strncmp+0x2b>
     73b:	8b 45 08             	mov    0x8(%ebp),%eax
     73e:	8a 00                	mov    (%eax),%al
     740:	84 c0                	test   %al,%al
     742:	74 0e                	je     752 <strncmp+0x2b>
     744:	8b 45 08             	mov    0x8(%ebp),%eax
     747:	8a 10                	mov    (%eax),%dl
     749:	8b 45 0c             	mov    0xc(%ebp),%eax
     74c:	8a 00                	mov    (%eax),%al
     74e:	38 c2                	cmp    %al,%dl
     750:	74 da                	je     72c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     752:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     756:	75 07                	jne    75f <strncmp+0x38>
    return 0;
     758:	b8 00 00 00 00       	mov    $0x0,%eax
     75d:	eb 14                	jmp    773 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     75f:	8b 45 08             	mov    0x8(%ebp),%eax
     762:	8a 00                	mov    (%eax),%al
     764:	0f b6 d0             	movzbl %al,%edx
     767:	8b 45 0c             	mov    0xc(%ebp),%eax
     76a:	8a 00                	mov    (%eax),%al
     76c:	0f b6 c0             	movzbl %al,%eax
     76f:	29 c2                	sub    %eax,%edx
     771:	89 d0                	mov    %edx,%eax
}
     773:	5d                   	pop    %ebp
     774:	c3                   	ret    

00000775 <strlen>:

uint
strlen(const char *s)
{
     775:	55                   	push   %ebp
     776:	89 e5                	mov    %esp,%ebp
     778:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     77b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     782:	eb 03                	jmp    787 <strlen+0x12>
     784:	ff 45 fc             	incl   -0x4(%ebp)
     787:	8b 55 fc             	mov    -0x4(%ebp),%edx
     78a:	8b 45 08             	mov    0x8(%ebp),%eax
     78d:	01 d0                	add    %edx,%eax
     78f:	8a 00                	mov    (%eax),%al
     791:	84 c0                	test   %al,%al
     793:	75 ef                	jne    784 <strlen+0xf>
    ;
  return n;
     795:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     798:	c9                   	leave  
     799:	c3                   	ret    

0000079a <memset>:

void*
memset(void *dst, int c, uint n)
{
     79a:	55                   	push   %ebp
     79b:	89 e5                	mov    %esp,%ebp
     79d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     7a0:	8b 45 10             	mov    0x10(%ebp),%eax
     7a3:	89 44 24 08          	mov    %eax,0x8(%esp)
     7a7:	8b 45 0c             	mov    0xc(%ebp),%eax
     7aa:	89 44 24 04          	mov    %eax,0x4(%esp)
     7ae:	8b 45 08             	mov    0x8(%ebp),%eax
     7b1:	89 04 24             	mov    %eax,(%esp)
     7b4:	e8 e3 fd ff ff       	call   59c <stosb>
  return dst;
     7b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     7bc:	c9                   	leave  
     7bd:	c3                   	ret    

000007be <strchr>:

char*
strchr(const char *s, char c)
{
     7be:	55                   	push   %ebp
     7bf:	89 e5                	mov    %esp,%ebp
     7c1:	83 ec 04             	sub    $0x4,%esp
     7c4:	8b 45 0c             	mov    0xc(%ebp),%eax
     7c7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     7ca:	eb 12                	jmp    7de <strchr+0x20>
    if(*s == c)
     7cc:	8b 45 08             	mov    0x8(%ebp),%eax
     7cf:	8a 00                	mov    (%eax),%al
     7d1:	3a 45 fc             	cmp    -0x4(%ebp),%al
     7d4:	75 05                	jne    7db <strchr+0x1d>
      return (char*)s;
     7d6:	8b 45 08             	mov    0x8(%ebp),%eax
     7d9:	eb 11                	jmp    7ec <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     7db:	ff 45 08             	incl   0x8(%ebp)
     7de:	8b 45 08             	mov    0x8(%ebp),%eax
     7e1:	8a 00                	mov    (%eax),%al
     7e3:	84 c0                	test   %al,%al
     7e5:	75 e5                	jne    7cc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     7e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7ec:	c9                   	leave  
     7ed:	c3                   	ret    

000007ee <strcat>:

char *
strcat(char *dest, const char *src)
{
     7ee:	55                   	push   %ebp
     7ef:	89 e5                	mov    %esp,%ebp
     7f1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     7f4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     7fb:	eb 03                	jmp    800 <strcat+0x12>
     7fd:	ff 45 fc             	incl   -0x4(%ebp)
     800:	8b 55 fc             	mov    -0x4(%ebp),%edx
     803:	8b 45 08             	mov    0x8(%ebp),%eax
     806:	01 d0                	add    %edx,%eax
     808:	8a 00                	mov    (%eax),%al
     80a:	84 c0                	test   %al,%al
     80c:	75 ef                	jne    7fd <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     80e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     815:	eb 1e                	jmp    835 <strcat+0x47>
        dest[i+j] = src[j];
     817:	8b 45 f8             	mov    -0x8(%ebp),%eax
     81a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     81d:	01 d0                	add    %edx,%eax
     81f:	89 c2                	mov    %eax,%edx
     821:	8b 45 08             	mov    0x8(%ebp),%eax
     824:	01 c2                	add    %eax,%edx
     826:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     829:	8b 45 0c             	mov    0xc(%ebp),%eax
     82c:	01 c8                	add    %ecx,%eax
     82e:	8a 00                	mov    (%eax),%al
     830:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     832:	ff 45 f8             	incl   -0x8(%ebp)
     835:	8b 55 f8             	mov    -0x8(%ebp),%edx
     838:	8b 45 0c             	mov    0xc(%ebp),%eax
     83b:	01 d0                	add    %edx,%eax
     83d:	8a 00                	mov    (%eax),%al
     83f:	84 c0                	test   %al,%al
     841:	75 d4                	jne    817 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     843:	8b 45 f8             	mov    -0x8(%ebp),%eax
     846:	8b 55 fc             	mov    -0x4(%ebp),%edx
     849:	01 d0                	add    %edx,%eax
     84b:	89 c2                	mov    %eax,%edx
     84d:	8b 45 08             	mov    0x8(%ebp),%eax
     850:	01 d0                	add    %edx,%eax
     852:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     855:	8b 45 08             	mov    0x8(%ebp),%eax
}
     858:	c9                   	leave  
     859:	c3                   	ret    

0000085a <strstr>:

int 
strstr(char* s, char* sub)
{
     85a:	55                   	push   %ebp
     85b:	89 e5                	mov    %esp,%ebp
     85d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     860:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     867:	eb 7c                	jmp    8e5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     869:	8b 55 fc             	mov    -0x4(%ebp),%edx
     86c:	8b 45 08             	mov    0x8(%ebp),%eax
     86f:	01 d0                	add    %edx,%eax
     871:	8a 10                	mov    (%eax),%dl
     873:	8b 45 0c             	mov    0xc(%ebp),%eax
     876:	8a 00                	mov    (%eax),%al
     878:	38 c2                	cmp    %al,%dl
     87a:	75 66                	jne    8e2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     87c:	8b 45 0c             	mov    0xc(%ebp),%eax
     87f:	89 04 24             	mov    %eax,(%esp)
     882:	e8 ee fe ff ff       	call   775 <strlen>
     887:	83 f8 01             	cmp    $0x1,%eax
     88a:	75 05                	jne    891 <strstr+0x37>
            {  
                return i;
     88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     88f:	eb 6b                	jmp    8fc <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     891:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     898:	eb 3a                	jmp    8d4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     89a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     89d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     8a0:	01 d0                	add    %edx,%eax
     8a2:	89 c2                	mov    %eax,%edx
     8a4:	8b 45 08             	mov    0x8(%ebp),%eax
     8a7:	01 d0                	add    %edx,%eax
     8a9:	8a 10                	mov    (%eax),%dl
     8ab:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     8ae:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b1:	01 c8                	add    %ecx,%eax
     8b3:	8a 00                	mov    (%eax),%al
     8b5:	38 c2                	cmp    %al,%dl
     8b7:	75 16                	jne    8cf <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     8b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8bc:	8d 50 01             	lea    0x1(%eax),%edx
     8bf:	8b 45 0c             	mov    0xc(%ebp),%eax
     8c2:	01 d0                	add    %edx,%eax
     8c4:	8a 00                	mov    (%eax),%al
     8c6:	84 c0                	test   %al,%al
     8c8:	75 07                	jne    8d1 <strstr+0x77>
                    {
                        return i;
     8ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8cd:	eb 2d                	jmp    8fc <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     8cf:	eb 11                	jmp    8e2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     8d1:	ff 45 f8             	incl   -0x8(%ebp)
     8d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
     8d7:	8b 45 0c             	mov    0xc(%ebp),%eax
     8da:	01 d0                	add    %edx,%eax
     8dc:	8a 00                	mov    (%eax),%al
     8de:	84 c0                	test   %al,%al
     8e0:	75 b8                	jne    89a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     8e2:	ff 45 fc             	incl   -0x4(%ebp)
     8e5:	8b 55 fc             	mov    -0x4(%ebp),%edx
     8e8:	8b 45 08             	mov    0x8(%ebp),%eax
     8eb:	01 d0                	add    %edx,%eax
     8ed:	8a 00                	mov    (%eax),%al
     8ef:	84 c0                	test   %al,%al
     8f1:	0f 85 72 ff ff ff    	jne    869 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     8f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     8fc:	c9                   	leave  
     8fd:	c3                   	ret    

000008fe <strtok>:

char *
strtok(char *s, const char *delim)
{
     8fe:	55                   	push   %ebp
     8ff:	89 e5                	mov    %esp,%ebp
     901:	53                   	push   %ebx
     902:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     905:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     909:	75 08                	jne    913 <strtok+0x15>
  s = lasts;
     90b:	a1 84 19 00 00       	mov    0x1984,%eax
     910:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     913:	8b 45 08             	mov    0x8(%ebp),%eax
     916:	8d 50 01             	lea    0x1(%eax),%edx
     919:	89 55 08             	mov    %edx,0x8(%ebp)
     91c:	8a 00                	mov    (%eax),%al
     91e:	0f be d8             	movsbl %al,%ebx
     921:	85 db                	test   %ebx,%ebx
     923:	75 07                	jne    92c <strtok+0x2e>
      return 0;
     925:	b8 00 00 00 00       	mov    $0x0,%eax
     92a:	eb 58                	jmp    984 <strtok+0x86>
    } while (strchr(delim, ch));
     92c:	88 d8                	mov    %bl,%al
     92e:	0f be c0             	movsbl %al,%eax
     931:	89 44 24 04          	mov    %eax,0x4(%esp)
     935:	8b 45 0c             	mov    0xc(%ebp),%eax
     938:	89 04 24             	mov    %eax,(%esp)
     93b:	e8 7e fe ff ff       	call   7be <strchr>
     940:	85 c0                	test   %eax,%eax
     942:	75 cf                	jne    913 <strtok+0x15>
    --s;
     944:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     947:	8b 45 0c             	mov    0xc(%ebp),%eax
     94a:	89 44 24 04          	mov    %eax,0x4(%esp)
     94e:	8b 45 08             	mov    0x8(%ebp),%eax
     951:	89 04 24             	mov    %eax,(%esp)
     954:	e8 31 00 00 00       	call   98a <strcspn>
     959:	89 c2                	mov    %eax,%edx
     95b:	8b 45 08             	mov    0x8(%ebp),%eax
     95e:	01 d0                	add    %edx,%eax
     960:	a3 84 19 00 00       	mov    %eax,0x1984
    if (*lasts != 0)
     965:	a1 84 19 00 00       	mov    0x1984,%eax
     96a:	8a 00                	mov    (%eax),%al
     96c:	84 c0                	test   %al,%al
     96e:	74 11                	je     981 <strtok+0x83>
  *lasts++ = 0;
     970:	a1 84 19 00 00       	mov    0x1984,%eax
     975:	8d 50 01             	lea    0x1(%eax),%edx
     978:	89 15 84 19 00 00    	mov    %edx,0x1984
     97e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     981:	8b 45 08             	mov    0x8(%ebp),%eax
}
     984:	83 c4 14             	add    $0x14,%esp
     987:	5b                   	pop    %ebx
     988:	5d                   	pop    %ebp
     989:	c3                   	ret    

0000098a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     98a:	55                   	push   %ebp
     98b:	89 e5                	mov    %esp,%ebp
     98d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     990:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     997:	eb 26                	jmp    9bf <strcspn+0x35>
        if(strchr(s2,*s1))
     999:	8b 45 08             	mov    0x8(%ebp),%eax
     99c:	8a 00                	mov    (%eax),%al
     99e:	0f be c0             	movsbl %al,%eax
     9a1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9a5:	8b 45 0c             	mov    0xc(%ebp),%eax
     9a8:	89 04 24             	mov    %eax,(%esp)
     9ab:	e8 0e fe ff ff       	call   7be <strchr>
     9b0:	85 c0                	test   %eax,%eax
     9b2:	74 05                	je     9b9 <strcspn+0x2f>
            return ret;
     9b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9b7:	eb 12                	jmp    9cb <strcspn+0x41>
        else
            s1++,ret++;
     9b9:	ff 45 08             	incl   0x8(%ebp)
     9bc:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     9bf:	8b 45 08             	mov    0x8(%ebp),%eax
     9c2:	8a 00                	mov    (%eax),%al
     9c4:	84 c0                	test   %al,%al
     9c6:	75 d1                	jne    999 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     9c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     9cb:	c9                   	leave  
     9cc:	c3                   	ret    

000009cd <isspace>:

int
isspace(unsigned char c)
{
     9cd:	55                   	push   %ebp
     9ce:	89 e5                	mov    %esp,%ebp
     9d0:	83 ec 04             	sub    $0x4,%esp
     9d3:	8b 45 08             	mov    0x8(%ebp),%eax
     9d6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     9d9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     9dd:	74 1e                	je     9fd <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     9df:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     9e3:	74 18                	je     9fd <isspace+0x30>
     9e5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     9e9:	74 12                	je     9fd <isspace+0x30>
     9eb:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     9ef:	74 0c                	je     9fd <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     9f1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     9f5:	74 06                	je     9fd <isspace+0x30>
     9f7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     9fb:	75 07                	jne    a04 <isspace+0x37>
     9fd:	b8 01 00 00 00       	mov    $0x1,%eax
     a02:	eb 05                	jmp    a09 <isspace+0x3c>
     a04:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a09:	c9                   	leave  
     a0a:	c3                   	ret    

00000a0b <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     a0b:	55                   	push   %ebp
     a0c:	89 e5                	mov    %esp,%ebp
     a0e:	57                   	push   %edi
     a0f:	56                   	push   %esi
     a10:	53                   	push   %ebx
     a11:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     a14:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     a19:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     a20:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     a23:	eb 01                	jmp    a26 <strtoul+0x1b>
  p += 1;
     a25:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     a26:	8a 03                	mov    (%ebx),%al
     a28:	0f b6 c0             	movzbl %al,%eax
     a2b:	89 04 24             	mov    %eax,(%esp)
     a2e:	e8 9a ff ff ff       	call   9cd <isspace>
     a33:	85 c0                	test   %eax,%eax
     a35:	75 ee                	jne    a25 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     a37:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     a3b:	75 30                	jne    a6d <strtoul+0x62>
    {
  if (*p == '0') {
     a3d:	8a 03                	mov    (%ebx),%al
     a3f:	3c 30                	cmp    $0x30,%al
     a41:	75 21                	jne    a64 <strtoul+0x59>
      p += 1;
     a43:	43                   	inc    %ebx
      if (*p == 'x') {
     a44:	8a 03                	mov    (%ebx),%al
     a46:	3c 78                	cmp    $0x78,%al
     a48:	75 0a                	jne    a54 <strtoul+0x49>
    p += 1;
     a4a:	43                   	inc    %ebx
    base = 16;
     a4b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     a52:	eb 31                	jmp    a85 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     a54:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     a5b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     a62:	eb 21                	jmp    a85 <strtoul+0x7a>
      }
  }
  else base = 10;
     a64:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     a6b:	eb 18                	jmp    a85 <strtoul+0x7a>
    } else if (base == 16) {
     a6d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     a71:	75 12                	jne    a85 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     a73:	8a 03                	mov    (%ebx),%al
     a75:	3c 30                	cmp    $0x30,%al
     a77:	75 0c                	jne    a85 <strtoul+0x7a>
     a79:	8d 43 01             	lea    0x1(%ebx),%eax
     a7c:	8a 00                	mov    (%eax),%al
     a7e:	3c 78                	cmp    $0x78,%al
     a80:	75 03                	jne    a85 <strtoul+0x7a>
      p += 2;
     a82:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     a85:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     a89:	75 29                	jne    ab4 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     a8b:	8a 03                	mov    (%ebx),%al
     a8d:	0f be c0             	movsbl %al,%eax
     a90:	83 e8 30             	sub    $0x30,%eax
     a93:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     a95:	83 fe 07             	cmp    $0x7,%esi
     a98:	76 06                	jbe    aa0 <strtoul+0x95>
    break;
     a9a:	90                   	nop
     a9b:	e9 b6 00 00 00       	jmp    b56 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     aa0:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     aa7:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     aaa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     ab1:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     ab2:	eb d7                	jmp    a8b <strtoul+0x80>
    } else if (base == 10) {
     ab4:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     ab8:	75 2b                	jne    ae5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     aba:	8a 03                	mov    (%ebx),%al
     abc:	0f be c0             	movsbl %al,%eax
     abf:	83 e8 30             	sub    $0x30,%eax
     ac2:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     ac4:	83 fe 09             	cmp    $0x9,%esi
     ac7:	76 06                	jbe    acf <strtoul+0xc4>
    break;
     ac9:	90                   	nop
     aca:	e9 87 00 00 00       	jmp    b56 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     acf:	89 f8                	mov    %edi,%eax
     ad1:	c1 e0 02             	shl    $0x2,%eax
     ad4:	01 f8                	add    %edi,%eax
     ad6:	01 c0                	add    %eax,%eax
     ad8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     adb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     ae2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     ae3:	eb d5                	jmp    aba <strtoul+0xaf>
    } else if (base == 16) {
     ae5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     ae9:	75 35                	jne    b20 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     aeb:	8a 03                	mov    (%ebx),%al
     aed:	0f be c0             	movsbl %al,%eax
     af0:	83 e8 30             	sub    $0x30,%eax
     af3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     af5:	83 fe 4a             	cmp    $0x4a,%esi
     af8:	76 02                	jbe    afc <strtoul+0xf1>
    break;
     afa:	eb 22                	jmp    b1e <strtoul+0x113>
      }
      digit = cvtIn[digit];
     afc:	8a 86 20 19 00 00    	mov    0x1920(%esi),%al
     b02:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     b05:	83 fe 0f             	cmp    $0xf,%esi
     b08:	76 02                	jbe    b0c <strtoul+0x101>
    break;
     b0a:	eb 12                	jmp    b1e <strtoul+0x113>
      }
      result = (result << 4) + digit;
     b0c:	89 f8                	mov    %edi,%eax
     b0e:	c1 e0 04             	shl    $0x4,%eax
     b11:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b14:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     b1b:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     b1c:	eb cd                	jmp    aeb <strtoul+0xe0>
     b1e:	eb 36                	jmp    b56 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     b20:	8a 03                	mov    (%ebx),%al
     b22:	0f be c0             	movsbl %al,%eax
     b25:	83 e8 30             	sub    $0x30,%eax
     b28:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     b2a:	83 fe 4a             	cmp    $0x4a,%esi
     b2d:	76 02                	jbe    b31 <strtoul+0x126>
    break;
     b2f:	eb 25                	jmp    b56 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     b31:	8a 86 20 19 00 00    	mov    0x1920(%esi),%al
     b37:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     b3a:	8b 45 10             	mov    0x10(%ebp),%eax
     b3d:	39 f0                	cmp    %esi,%eax
     b3f:	77 02                	ja     b43 <strtoul+0x138>
    break;
     b41:	eb 13                	jmp    b56 <strtoul+0x14b>
      }
      result = result*base + digit;
     b43:	8b 45 10             	mov    0x10(%ebp),%eax
     b46:	0f af c7             	imul   %edi,%eax
     b49:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b4c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     b53:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     b54:	eb ca                	jmp    b20 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     b56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b5a:	75 03                	jne    b5f <strtoul+0x154>
  p = string;
     b5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     b5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     b63:	74 05                	je     b6a <strtoul+0x15f>
  *endPtr = p;
     b65:	8b 45 0c             	mov    0xc(%ebp),%eax
     b68:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     b6a:	89 f8                	mov    %edi,%eax
}
     b6c:	83 c4 14             	add    $0x14,%esp
     b6f:	5b                   	pop    %ebx
     b70:	5e                   	pop    %esi
     b71:	5f                   	pop    %edi
     b72:	5d                   	pop    %ebp
     b73:	c3                   	ret    

00000b74 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     b74:	55                   	push   %ebp
     b75:	89 e5                	mov    %esp,%ebp
     b77:	53                   	push   %ebx
     b78:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     b7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     b7e:	eb 01                	jmp    b81 <strtol+0xd>
      p += 1;
     b80:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     b81:	8a 03                	mov    (%ebx),%al
     b83:	0f b6 c0             	movzbl %al,%eax
     b86:	89 04 24             	mov    %eax,(%esp)
     b89:	e8 3f fe ff ff       	call   9cd <isspace>
     b8e:	85 c0                	test   %eax,%eax
     b90:	75 ee                	jne    b80 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     b92:	8a 03                	mov    (%ebx),%al
     b94:	3c 2d                	cmp    $0x2d,%al
     b96:	75 1e                	jne    bb6 <strtol+0x42>
  p += 1;
     b98:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     b99:	8b 45 10             	mov    0x10(%ebp),%eax
     b9c:	89 44 24 08          	mov    %eax,0x8(%esp)
     ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
     ba7:	89 1c 24             	mov    %ebx,(%esp)
     baa:	e8 5c fe ff ff       	call   a0b <strtoul>
     baf:	f7 d8                	neg    %eax
     bb1:	89 45 f8             	mov    %eax,-0x8(%ebp)
     bb4:	eb 20                	jmp    bd6 <strtol+0x62>
    } else {
  if (*p == '+') {
     bb6:	8a 03                	mov    (%ebx),%al
     bb8:	3c 2b                	cmp    $0x2b,%al
     bba:	75 01                	jne    bbd <strtol+0x49>
      p += 1;
     bbc:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     bbd:	8b 45 10             	mov    0x10(%ebp),%eax
     bc0:	89 44 24 08          	mov    %eax,0x8(%esp)
     bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     bcb:	89 1c 24             	mov    %ebx,(%esp)
     bce:	e8 38 fe ff ff       	call   a0b <strtoul>
     bd3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     bd6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     bda:	75 17                	jne    bf3 <strtol+0x7f>
     bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     be0:	74 11                	je     bf3 <strtol+0x7f>
     be2:	8b 45 0c             	mov    0xc(%ebp),%eax
     be5:	8b 00                	mov    (%eax),%eax
     be7:	39 d8                	cmp    %ebx,%eax
     be9:	75 08                	jne    bf3 <strtol+0x7f>
  *endPtr = string;
     beb:	8b 45 0c             	mov    0xc(%ebp),%eax
     bee:	8b 55 08             	mov    0x8(%ebp),%edx
     bf1:	89 10                	mov    %edx,(%eax)
    }
    return result;
     bf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     bf6:	83 c4 1c             	add    $0x1c,%esp
     bf9:	5b                   	pop    %ebx
     bfa:	5d                   	pop    %ebp
     bfb:	c3                   	ret    

00000bfc <gets>:

char*
gets(char *buf, int max)
{
     bfc:	55                   	push   %ebp
     bfd:	89 e5                	mov    %esp,%ebp
     bff:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c02:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c09:	eb 49                	jmp    c54 <gets+0x58>
    cc = read(0, &c, 1);
     c0b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c12:	00 
     c13:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c16:	89 44 24 04          	mov    %eax,0x4(%esp)
     c1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c21:	e8 3e 01 00 00       	call   d64 <read>
     c26:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c29:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c2d:	7f 02                	jg     c31 <gets+0x35>
      break;
     c2f:	eb 2c                	jmp    c5d <gets+0x61>
    buf[i++] = c;
     c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c34:	8d 50 01             	lea    0x1(%eax),%edx
     c37:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c3a:	89 c2                	mov    %eax,%edx
     c3c:	8b 45 08             	mov    0x8(%ebp),%eax
     c3f:	01 c2                	add    %eax,%edx
     c41:	8a 45 ef             	mov    -0x11(%ebp),%al
     c44:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     c46:	8a 45 ef             	mov    -0x11(%ebp),%al
     c49:	3c 0a                	cmp    $0xa,%al
     c4b:	74 10                	je     c5d <gets+0x61>
     c4d:	8a 45 ef             	mov    -0x11(%ebp),%al
     c50:	3c 0d                	cmp    $0xd,%al
     c52:	74 09                	je     c5d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c54:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c57:	40                   	inc    %eax
     c58:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c5b:	7c ae                	jl     c0b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c60:	8b 45 08             	mov    0x8(%ebp),%eax
     c63:	01 d0                	add    %edx,%eax
     c65:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     c68:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c6b:	c9                   	leave  
     c6c:	c3                   	ret    

00000c6d <stat>:

int
stat(char *n, struct stat *st)
{
     c6d:	55                   	push   %ebp
     c6e:	89 e5                	mov    %esp,%ebp
     c70:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c73:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c7a:	00 
     c7b:	8b 45 08             	mov    0x8(%ebp),%eax
     c7e:	89 04 24             	mov    %eax,(%esp)
     c81:	e8 06 01 00 00       	call   d8c <open>
     c86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     c89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c8d:	79 07                	jns    c96 <stat+0x29>
    return -1;
     c8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c94:	eb 23                	jmp    cb9 <stat+0x4c>
  r = fstat(fd, st);
     c96:	8b 45 0c             	mov    0xc(%ebp),%eax
     c99:	89 44 24 04          	mov    %eax,0x4(%esp)
     c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ca0:	89 04 24             	mov    %eax,(%esp)
     ca3:	e8 fc 00 00 00       	call   da4 <fstat>
     ca8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cae:	89 04 24             	mov    %eax,(%esp)
     cb1:	e8 be 00 00 00       	call   d74 <close>
  return r;
     cb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cb9:	c9                   	leave  
     cba:	c3                   	ret    

00000cbb <atoi>:

int
atoi(const char *s)
{
     cbb:	55                   	push   %ebp
     cbc:	89 e5                	mov    %esp,%ebp
     cbe:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     cc1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     cc8:	eb 24                	jmp    cee <atoi+0x33>
    n = n*10 + *s++ - '0';
     cca:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ccd:	89 d0                	mov    %edx,%eax
     ccf:	c1 e0 02             	shl    $0x2,%eax
     cd2:	01 d0                	add    %edx,%eax
     cd4:	01 c0                	add    %eax,%eax
     cd6:	89 c1                	mov    %eax,%ecx
     cd8:	8b 45 08             	mov    0x8(%ebp),%eax
     cdb:	8d 50 01             	lea    0x1(%eax),%edx
     cde:	89 55 08             	mov    %edx,0x8(%ebp)
     ce1:	8a 00                	mov    (%eax),%al
     ce3:	0f be c0             	movsbl %al,%eax
     ce6:	01 c8                	add    %ecx,%eax
     ce8:	83 e8 30             	sub    $0x30,%eax
     ceb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cee:	8b 45 08             	mov    0x8(%ebp),%eax
     cf1:	8a 00                	mov    (%eax),%al
     cf3:	3c 2f                	cmp    $0x2f,%al
     cf5:	7e 09                	jle    d00 <atoi+0x45>
     cf7:	8b 45 08             	mov    0x8(%ebp),%eax
     cfa:	8a 00                	mov    (%eax),%al
     cfc:	3c 39                	cmp    $0x39,%al
     cfe:	7e ca                	jle    cca <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     d00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d03:	c9                   	leave  
     d04:	c3                   	ret    

00000d05 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d05:	55                   	push   %ebp
     d06:	89 e5                	mov    %esp,%ebp
     d08:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     d0b:	8b 45 08             	mov    0x8(%ebp),%eax
     d0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d11:	8b 45 0c             	mov    0xc(%ebp),%eax
     d14:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d17:	eb 16                	jmp    d2f <memmove+0x2a>
    *dst++ = *src++;
     d19:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d1c:	8d 50 01             	lea    0x1(%eax),%edx
     d1f:	89 55 fc             	mov    %edx,-0x4(%ebp)
     d22:	8b 55 f8             	mov    -0x8(%ebp),%edx
     d25:	8d 4a 01             	lea    0x1(%edx),%ecx
     d28:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     d2b:	8a 12                	mov    (%edx),%dl
     d2d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d2f:	8b 45 10             	mov    0x10(%ebp),%eax
     d32:	8d 50 ff             	lea    -0x1(%eax),%edx
     d35:	89 55 10             	mov    %edx,0x10(%ebp)
     d38:	85 c0                	test   %eax,%eax
     d3a:	7f dd                	jg     d19 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d3f:	c9                   	leave  
     d40:	c3                   	ret    
     d41:	90                   	nop
     d42:	90                   	nop
     d43:	90                   	nop

00000d44 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d44:	b8 01 00 00 00       	mov    $0x1,%eax
     d49:	cd 40                	int    $0x40
     d4b:	c3                   	ret    

00000d4c <exit>:
SYSCALL(exit)
     d4c:	b8 02 00 00 00       	mov    $0x2,%eax
     d51:	cd 40                	int    $0x40
     d53:	c3                   	ret    

00000d54 <wait>:
SYSCALL(wait)
     d54:	b8 03 00 00 00       	mov    $0x3,%eax
     d59:	cd 40                	int    $0x40
     d5b:	c3                   	ret    

00000d5c <pipe>:
SYSCALL(pipe)
     d5c:	b8 04 00 00 00       	mov    $0x4,%eax
     d61:	cd 40                	int    $0x40
     d63:	c3                   	ret    

00000d64 <read>:
SYSCALL(read)
     d64:	b8 05 00 00 00       	mov    $0x5,%eax
     d69:	cd 40                	int    $0x40
     d6b:	c3                   	ret    

00000d6c <write>:
SYSCALL(write)
     d6c:	b8 10 00 00 00       	mov    $0x10,%eax
     d71:	cd 40                	int    $0x40
     d73:	c3                   	ret    

00000d74 <close>:
SYSCALL(close)
     d74:	b8 15 00 00 00       	mov    $0x15,%eax
     d79:	cd 40                	int    $0x40
     d7b:	c3                   	ret    

00000d7c <kill>:
SYSCALL(kill)
     d7c:	b8 06 00 00 00       	mov    $0x6,%eax
     d81:	cd 40                	int    $0x40
     d83:	c3                   	ret    

00000d84 <exec>:
SYSCALL(exec)
     d84:	b8 07 00 00 00       	mov    $0x7,%eax
     d89:	cd 40                	int    $0x40
     d8b:	c3                   	ret    

00000d8c <open>:
SYSCALL(open)
     d8c:	b8 0f 00 00 00       	mov    $0xf,%eax
     d91:	cd 40                	int    $0x40
     d93:	c3                   	ret    

00000d94 <mknod>:
SYSCALL(mknod)
     d94:	b8 11 00 00 00       	mov    $0x11,%eax
     d99:	cd 40                	int    $0x40
     d9b:	c3                   	ret    

00000d9c <unlink>:
SYSCALL(unlink)
     d9c:	b8 12 00 00 00       	mov    $0x12,%eax
     da1:	cd 40                	int    $0x40
     da3:	c3                   	ret    

00000da4 <fstat>:
SYSCALL(fstat)
     da4:	b8 08 00 00 00       	mov    $0x8,%eax
     da9:	cd 40                	int    $0x40
     dab:	c3                   	ret    

00000dac <link>:
SYSCALL(link)
     dac:	b8 13 00 00 00       	mov    $0x13,%eax
     db1:	cd 40                	int    $0x40
     db3:	c3                   	ret    

00000db4 <mkdir>:
SYSCALL(mkdir)
     db4:	b8 14 00 00 00       	mov    $0x14,%eax
     db9:	cd 40                	int    $0x40
     dbb:	c3                   	ret    

00000dbc <chdir>:
SYSCALL(chdir)
     dbc:	b8 09 00 00 00       	mov    $0x9,%eax
     dc1:	cd 40                	int    $0x40
     dc3:	c3                   	ret    

00000dc4 <dup>:
SYSCALL(dup)
     dc4:	b8 0a 00 00 00       	mov    $0xa,%eax
     dc9:	cd 40                	int    $0x40
     dcb:	c3                   	ret    

00000dcc <getpid>:
SYSCALL(getpid)
     dcc:	b8 0b 00 00 00       	mov    $0xb,%eax
     dd1:	cd 40                	int    $0x40
     dd3:	c3                   	ret    

00000dd4 <sbrk>:
SYSCALL(sbrk)
     dd4:	b8 0c 00 00 00       	mov    $0xc,%eax
     dd9:	cd 40                	int    $0x40
     ddb:	c3                   	ret    

00000ddc <sleep>:
SYSCALL(sleep)
     ddc:	b8 0d 00 00 00       	mov    $0xd,%eax
     de1:	cd 40                	int    $0x40
     de3:	c3                   	ret    

00000de4 <uptime>:
SYSCALL(uptime)
     de4:	b8 0e 00 00 00       	mov    $0xe,%eax
     de9:	cd 40                	int    $0x40
     deb:	c3                   	ret    

00000dec <getname>:
SYSCALL(getname)
     dec:	b8 16 00 00 00       	mov    $0x16,%eax
     df1:	cd 40                	int    $0x40
     df3:	c3                   	ret    

00000df4 <setname>:
SYSCALL(setname)
     df4:	b8 17 00 00 00       	mov    $0x17,%eax
     df9:	cd 40                	int    $0x40
     dfb:	c3                   	ret    

00000dfc <getmaxproc>:
SYSCALL(getmaxproc)
     dfc:	b8 18 00 00 00       	mov    $0x18,%eax
     e01:	cd 40                	int    $0x40
     e03:	c3                   	ret    

00000e04 <setmaxproc>:
SYSCALL(setmaxproc)
     e04:	b8 19 00 00 00       	mov    $0x19,%eax
     e09:	cd 40                	int    $0x40
     e0b:	c3                   	ret    

00000e0c <getmaxmem>:
SYSCALL(getmaxmem)
     e0c:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e11:	cd 40                	int    $0x40
     e13:	c3                   	ret    

00000e14 <setmaxmem>:
SYSCALL(setmaxmem)
     e14:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e19:	cd 40                	int    $0x40
     e1b:	c3                   	ret    

00000e1c <getmaxdisk>:
SYSCALL(getmaxdisk)
     e1c:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e21:	cd 40                	int    $0x40
     e23:	c3                   	ret    

00000e24 <setmaxdisk>:
SYSCALL(setmaxdisk)
     e24:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e29:	cd 40                	int    $0x40
     e2b:	c3                   	ret    

00000e2c <getusedmem>:
SYSCALL(getusedmem)
     e2c:	b8 1e 00 00 00       	mov    $0x1e,%eax
     e31:	cd 40                	int    $0x40
     e33:	c3                   	ret    

00000e34 <setusedmem>:
SYSCALL(setusedmem)
     e34:	b8 1f 00 00 00       	mov    $0x1f,%eax
     e39:	cd 40                	int    $0x40
     e3b:	c3                   	ret    

00000e3c <getuseddisk>:
SYSCALL(getuseddisk)
     e3c:	b8 20 00 00 00       	mov    $0x20,%eax
     e41:	cd 40                	int    $0x40
     e43:	c3                   	ret    

00000e44 <setuseddisk>:
SYSCALL(setuseddisk)
     e44:	b8 21 00 00 00       	mov    $0x21,%eax
     e49:	cd 40                	int    $0x40
     e4b:	c3                   	ret    

00000e4c <setvc>:
SYSCALL(setvc)
     e4c:	b8 22 00 00 00       	mov    $0x22,%eax
     e51:	cd 40                	int    $0x40
     e53:	c3                   	ret    

00000e54 <setactivefs>:
SYSCALL(setactivefs)
     e54:	b8 24 00 00 00       	mov    $0x24,%eax
     e59:	cd 40                	int    $0x40
     e5b:	c3                   	ret    

00000e5c <getactivefs>:
SYSCALL(getactivefs)
     e5c:	b8 25 00 00 00       	mov    $0x25,%eax
     e61:	cd 40                	int    $0x40
     e63:	c3                   	ret    

00000e64 <getvcfs>:
SYSCALL(getvcfs)
     e64:	b8 23 00 00 00       	mov    $0x23,%eax
     e69:	cd 40                	int    $0x40
     e6b:	c3                   	ret    

00000e6c <getcwd>:
SYSCALL(getcwd)
     e6c:	b8 26 00 00 00       	mov    $0x26,%eax
     e71:	cd 40                	int    $0x40
     e73:	c3                   	ret    

00000e74 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e74:	55                   	push   %ebp
     e75:	89 e5                	mov    %esp,%ebp
     e77:	83 ec 18             	sub    $0x18,%esp
     e7a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e7d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e80:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e87:	00 
     e88:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e8b:	89 44 24 04          	mov    %eax,0x4(%esp)
     e8f:	8b 45 08             	mov    0x8(%ebp),%eax
     e92:	89 04 24             	mov    %eax,(%esp)
     e95:	e8 d2 fe ff ff       	call   d6c <write>
}
     e9a:	c9                   	leave  
     e9b:	c3                   	ret    

00000e9c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e9c:	55                   	push   %ebp
     e9d:	89 e5                	mov    %esp,%ebp
     e9f:	56                   	push   %esi
     ea0:	53                   	push   %ebx
     ea1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     ea4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     eab:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     eaf:	74 17                	je     ec8 <printint+0x2c>
     eb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     eb5:	79 11                	jns    ec8 <printint+0x2c>
    neg = 1;
     eb7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
     ec1:	f7 d8                	neg    %eax
     ec3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     ec6:	eb 06                	jmp    ece <printint+0x32>
  } else {
    x = xx;
     ec8:	8b 45 0c             	mov    0xc(%ebp),%eax
     ecb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     ece:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     ed5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ed8:	8d 41 01             	lea    0x1(%ecx),%eax
     edb:	89 45 f4             	mov    %eax,-0xc(%ebp)
     ede:	8b 5d 10             	mov    0x10(%ebp),%ebx
     ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ee4:	ba 00 00 00 00       	mov    $0x0,%edx
     ee9:	f7 f3                	div    %ebx
     eeb:	89 d0                	mov    %edx,%eax
     eed:	8a 80 6c 19 00 00    	mov    0x196c(%eax),%al
     ef3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     ef7:	8b 75 10             	mov    0x10(%ebp),%esi
     efa:	8b 45 ec             	mov    -0x14(%ebp),%eax
     efd:	ba 00 00 00 00       	mov    $0x0,%edx
     f02:	f7 f6                	div    %esi
     f04:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f07:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f0b:	75 c8                	jne    ed5 <printint+0x39>
  if(neg)
     f0d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f11:	74 10                	je     f23 <printint+0x87>
    buf[i++] = '-';
     f13:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f16:	8d 50 01             	lea    0x1(%eax),%edx
     f19:	89 55 f4             	mov    %edx,-0xc(%ebp)
     f1c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     f21:	eb 1e                	jmp    f41 <printint+0xa5>
     f23:	eb 1c                	jmp    f41 <printint+0xa5>
    putc(fd, buf[i]);
     f25:	8d 55 dc             	lea    -0x24(%ebp),%edx
     f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f2b:	01 d0                	add    %edx,%eax
     f2d:	8a 00                	mov    (%eax),%al
     f2f:	0f be c0             	movsbl %al,%eax
     f32:	89 44 24 04          	mov    %eax,0x4(%esp)
     f36:	8b 45 08             	mov    0x8(%ebp),%eax
     f39:	89 04 24             	mov    %eax,(%esp)
     f3c:	e8 33 ff ff ff       	call   e74 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f41:	ff 4d f4             	decl   -0xc(%ebp)
     f44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f48:	79 db                	jns    f25 <printint+0x89>
    putc(fd, buf[i]);
}
     f4a:	83 c4 30             	add    $0x30,%esp
     f4d:	5b                   	pop    %ebx
     f4e:	5e                   	pop    %esi
     f4f:	5d                   	pop    %ebp
     f50:	c3                   	ret    

00000f51 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f51:	55                   	push   %ebp
     f52:	89 e5                	mov    %esp,%ebp
     f54:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f57:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f5e:	8d 45 0c             	lea    0xc(%ebp),%eax
     f61:	83 c0 04             	add    $0x4,%eax
     f64:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f67:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f6e:	e9 77 01 00 00       	jmp    10ea <printf+0x199>
    c = fmt[i] & 0xff;
     f73:	8b 55 0c             	mov    0xc(%ebp),%edx
     f76:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f79:	01 d0                	add    %edx,%eax
     f7b:	8a 00                	mov    (%eax),%al
     f7d:	0f be c0             	movsbl %al,%eax
     f80:	25 ff 00 00 00       	and    $0xff,%eax
     f85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f8c:	75 2c                	jne    fba <printf+0x69>
      if(c == '%'){
     f8e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f92:	75 0c                	jne    fa0 <printf+0x4f>
        state = '%';
     f94:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f9b:	e9 47 01 00 00       	jmp    10e7 <printf+0x196>
      } else {
        putc(fd, c);
     fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fa3:	0f be c0             	movsbl %al,%eax
     fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
     faa:	8b 45 08             	mov    0x8(%ebp),%eax
     fad:	89 04 24             	mov    %eax,(%esp)
     fb0:	e8 bf fe ff ff       	call   e74 <putc>
     fb5:	e9 2d 01 00 00       	jmp    10e7 <printf+0x196>
      }
    } else if(state == '%'){
     fba:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     fbe:	0f 85 23 01 00 00    	jne    10e7 <printf+0x196>
      if(c == 'd'){
     fc4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     fc8:	75 2d                	jne    ff7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
     fca:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fcd:	8b 00                	mov    (%eax),%eax
     fcf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     fd6:	00 
     fd7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     fde:	00 
     fdf:	89 44 24 04          	mov    %eax,0x4(%esp)
     fe3:	8b 45 08             	mov    0x8(%ebp),%eax
     fe6:	89 04 24             	mov    %eax,(%esp)
     fe9:	e8 ae fe ff ff       	call   e9c <printint>
        ap++;
     fee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     ff2:	e9 e9 00 00 00       	jmp    10e0 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
     ff7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     ffb:	74 06                	je     1003 <printf+0xb2>
     ffd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1001:	75 2d                	jne    1030 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    1003:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1006:	8b 00                	mov    (%eax),%eax
    1008:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    100f:	00 
    1010:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1017:	00 
    1018:	89 44 24 04          	mov    %eax,0x4(%esp)
    101c:	8b 45 08             	mov    0x8(%ebp),%eax
    101f:	89 04 24             	mov    %eax,(%esp)
    1022:	e8 75 fe ff ff       	call   e9c <printint>
        ap++;
    1027:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    102b:	e9 b0 00 00 00       	jmp    10e0 <printf+0x18f>
      } else if(c == 's'){
    1030:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1034:	75 42                	jne    1078 <printf+0x127>
        s = (char*)*ap;
    1036:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1039:	8b 00                	mov    (%eax),%eax
    103b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    103e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1046:	75 09                	jne    1051 <printf+0x100>
          s = "(null)";
    1048:	c7 45 f4 ed 14 00 00 	movl   $0x14ed,-0xc(%ebp)
        while(*s != 0){
    104f:	eb 1c                	jmp    106d <printf+0x11c>
    1051:	eb 1a                	jmp    106d <printf+0x11c>
          putc(fd, *s);
    1053:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1056:	8a 00                	mov    (%eax),%al
    1058:	0f be c0             	movsbl %al,%eax
    105b:	89 44 24 04          	mov    %eax,0x4(%esp)
    105f:	8b 45 08             	mov    0x8(%ebp),%eax
    1062:	89 04 24             	mov    %eax,(%esp)
    1065:	e8 0a fe ff ff       	call   e74 <putc>
          s++;
    106a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    106d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1070:	8a 00                	mov    (%eax),%al
    1072:	84 c0                	test   %al,%al
    1074:	75 dd                	jne    1053 <printf+0x102>
    1076:	eb 68                	jmp    10e0 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1078:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    107c:	75 1d                	jne    109b <printf+0x14a>
        putc(fd, *ap);
    107e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1081:	8b 00                	mov    (%eax),%eax
    1083:	0f be c0             	movsbl %al,%eax
    1086:	89 44 24 04          	mov    %eax,0x4(%esp)
    108a:	8b 45 08             	mov    0x8(%ebp),%eax
    108d:	89 04 24             	mov    %eax,(%esp)
    1090:	e8 df fd ff ff       	call   e74 <putc>
        ap++;
    1095:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1099:	eb 45                	jmp    10e0 <printf+0x18f>
      } else if(c == '%'){
    109b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    109f:	75 17                	jne    10b8 <printf+0x167>
        putc(fd, c);
    10a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10a4:	0f be c0             	movsbl %al,%eax
    10a7:	89 44 24 04          	mov    %eax,0x4(%esp)
    10ab:	8b 45 08             	mov    0x8(%ebp),%eax
    10ae:	89 04 24             	mov    %eax,(%esp)
    10b1:	e8 be fd ff ff       	call   e74 <putc>
    10b6:	eb 28                	jmp    10e0 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10b8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    10bf:	00 
    10c0:	8b 45 08             	mov    0x8(%ebp),%eax
    10c3:	89 04 24             	mov    %eax,(%esp)
    10c6:	e8 a9 fd ff ff       	call   e74 <putc>
        putc(fd, c);
    10cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10ce:	0f be c0             	movsbl %al,%eax
    10d1:	89 44 24 04          	mov    %eax,0x4(%esp)
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	89 04 24             	mov    %eax,(%esp)
    10db:	e8 94 fd ff ff       	call   e74 <putc>
      }
      state = 0;
    10e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    10e7:	ff 45 f0             	incl   -0x10(%ebp)
    10ea:	8b 55 0c             	mov    0xc(%ebp),%edx
    10ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10f0:	01 d0                	add    %edx,%eax
    10f2:	8a 00                	mov    (%eax),%al
    10f4:	84 c0                	test   %al,%al
    10f6:	0f 85 77 fe ff ff    	jne    f73 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    10fc:	c9                   	leave  
    10fd:	c3                   	ret    
    10fe:	90                   	nop
    10ff:	90                   	nop

00001100 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1106:	8b 45 08             	mov    0x8(%ebp),%eax
    1109:	83 e8 08             	sub    $0x8,%eax
    110c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    110f:	a1 90 19 00 00       	mov    0x1990,%eax
    1114:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1117:	eb 24                	jmp    113d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1119:	8b 45 fc             	mov    -0x4(%ebp),%eax
    111c:	8b 00                	mov    (%eax),%eax
    111e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1121:	77 12                	ja     1135 <free+0x35>
    1123:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1126:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1129:	77 24                	ja     114f <free+0x4f>
    112b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    112e:	8b 00                	mov    (%eax),%eax
    1130:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1133:	77 1a                	ja     114f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1135:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1138:	8b 00                	mov    (%eax),%eax
    113a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1140:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1143:	76 d4                	jbe    1119 <free+0x19>
    1145:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1148:	8b 00                	mov    (%eax),%eax
    114a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    114d:	76 ca                	jbe    1119 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    114f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1152:	8b 40 04             	mov    0x4(%eax),%eax
    1155:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    115c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    115f:	01 c2                	add    %eax,%edx
    1161:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1164:	8b 00                	mov    (%eax),%eax
    1166:	39 c2                	cmp    %eax,%edx
    1168:	75 24                	jne    118e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    116d:	8b 50 04             	mov    0x4(%eax),%edx
    1170:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1173:	8b 00                	mov    (%eax),%eax
    1175:	8b 40 04             	mov    0x4(%eax),%eax
    1178:	01 c2                	add    %eax,%edx
    117a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    117d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1180:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1183:	8b 00                	mov    (%eax),%eax
    1185:	8b 10                	mov    (%eax),%edx
    1187:	8b 45 f8             	mov    -0x8(%ebp),%eax
    118a:	89 10                	mov    %edx,(%eax)
    118c:	eb 0a                	jmp    1198 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1191:	8b 10                	mov    (%eax),%edx
    1193:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1196:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1198:	8b 45 fc             	mov    -0x4(%ebp),%eax
    119b:	8b 40 04             	mov    0x4(%eax),%eax
    119e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    11a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11a8:	01 d0                	add    %edx,%eax
    11aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    11ad:	75 20                	jne    11cf <free+0xcf>
    p->s.size += bp->s.size;
    11af:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b2:	8b 50 04             	mov    0x4(%eax),%edx
    11b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11b8:	8b 40 04             	mov    0x4(%eax),%eax
    11bb:	01 c2                	add    %eax,%edx
    11bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11c6:	8b 10                	mov    (%eax),%edx
    11c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11cb:	89 10                	mov    %edx,(%eax)
    11cd:	eb 08                	jmp    11d7 <free+0xd7>
  } else
    p->s.ptr = bp;
    11cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11d5:	89 10                	mov    %edx,(%eax)
  freep = p;
    11d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11da:	a3 90 19 00 00       	mov    %eax,0x1990
}
    11df:	c9                   	leave  
    11e0:	c3                   	ret    

000011e1 <morecore>:

static Header*
morecore(uint nu)
{
    11e1:	55                   	push   %ebp
    11e2:	89 e5                	mov    %esp,%ebp
    11e4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    11e7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    11ee:	77 07                	ja     11f7 <morecore+0x16>
    nu = 4096;
    11f0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    11f7:	8b 45 08             	mov    0x8(%ebp),%eax
    11fa:	c1 e0 03             	shl    $0x3,%eax
    11fd:	89 04 24             	mov    %eax,(%esp)
    1200:	e8 cf fb ff ff       	call   dd4 <sbrk>
    1205:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1208:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    120c:	75 07                	jne    1215 <morecore+0x34>
    return 0;
    120e:	b8 00 00 00 00       	mov    $0x0,%eax
    1213:	eb 22                	jmp    1237 <morecore+0x56>
  hp = (Header*)p;
    1215:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    121b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    121e:	8b 55 08             	mov    0x8(%ebp),%edx
    1221:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1224:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1227:	83 c0 08             	add    $0x8,%eax
    122a:	89 04 24             	mov    %eax,(%esp)
    122d:	e8 ce fe ff ff       	call   1100 <free>
  return freep;
    1232:	a1 90 19 00 00       	mov    0x1990,%eax
}
    1237:	c9                   	leave  
    1238:	c3                   	ret    

00001239 <malloc>:

void*
malloc(uint nbytes)
{
    1239:	55                   	push   %ebp
    123a:	89 e5                	mov    %esp,%ebp
    123c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    123f:	8b 45 08             	mov    0x8(%ebp),%eax
    1242:	83 c0 07             	add    $0x7,%eax
    1245:	c1 e8 03             	shr    $0x3,%eax
    1248:	40                   	inc    %eax
    1249:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    124c:	a1 90 19 00 00       	mov    0x1990,%eax
    1251:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1254:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1258:	75 23                	jne    127d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    125a:	c7 45 f0 88 19 00 00 	movl   $0x1988,-0x10(%ebp)
    1261:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1264:	a3 90 19 00 00       	mov    %eax,0x1990
    1269:	a1 90 19 00 00       	mov    0x1990,%eax
    126e:	a3 88 19 00 00       	mov    %eax,0x1988
    base.s.size = 0;
    1273:	c7 05 8c 19 00 00 00 	movl   $0x0,0x198c
    127a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    127d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1280:	8b 00                	mov    (%eax),%eax
    1282:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1285:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1288:	8b 40 04             	mov    0x4(%eax),%eax
    128b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    128e:	72 4d                	jb     12dd <malloc+0xa4>
      if(p->s.size == nunits)
    1290:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1293:	8b 40 04             	mov    0x4(%eax),%eax
    1296:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1299:	75 0c                	jne    12a7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    129b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129e:	8b 10                	mov    (%eax),%edx
    12a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12a3:	89 10                	mov    %edx,(%eax)
    12a5:	eb 26                	jmp    12cd <malloc+0x94>
      else {
        p->s.size -= nunits;
    12a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12aa:	8b 40 04             	mov    0x4(%eax),%eax
    12ad:	2b 45 ec             	sub    -0x14(%ebp),%eax
    12b0:	89 c2                	mov    %eax,%edx
    12b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    12b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12bb:	8b 40 04             	mov    0x4(%eax),%eax
    12be:	c1 e0 03             	shl    $0x3,%eax
    12c1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    12c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c7:	8b 55 ec             	mov    -0x14(%ebp),%edx
    12ca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    12cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12d0:	a3 90 19 00 00       	mov    %eax,0x1990
      return (void*)(p + 1);
    12d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d8:	83 c0 08             	add    $0x8,%eax
    12db:	eb 38                	jmp    1315 <malloc+0xdc>
    }
    if(p == freep)
    12dd:	a1 90 19 00 00       	mov    0x1990,%eax
    12e2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    12e5:	75 1b                	jne    1302 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    12e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12ea:	89 04 24             	mov    %eax,(%esp)
    12ed:	e8 ef fe ff ff       	call   11e1 <morecore>
    12f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    12f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12f9:	75 07                	jne    1302 <malloc+0xc9>
        return 0;
    12fb:	b8 00 00 00 00       	mov    $0x0,%eax
    1300:	eb 13                	jmp    1315 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1302:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1305:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1308:	8b 45 f4             	mov    -0xc(%ebp),%eax
    130b:	8b 00                	mov    (%eax),%eax
    130d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1310:	e9 70 ff ff ff       	jmp    1285 <malloc+0x4c>
}
    1315:	c9                   	leave  
    1316:	c3                   	ret    
