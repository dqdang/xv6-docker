
_ctool:     file format elf32-i386


Disassembly of section .text:

00000000 <itoa>:
#include "stat.h"
#include "user.h"
#include "container.h"

void itoa(int num, char* str, int base)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 10             	sub    $0x10,%esp
    char temp;
    int rem, i = 0, j = 0;
       6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
       d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 
    if (num == 0)
      14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      18:	75 23                	jne    3d <itoa+0x3d>
    {
        str[i++] = '0';
      1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
      1d:	8d 50 01             	lea    0x1(%eax),%edx
      20:	89 55 f8             	mov    %edx,-0x8(%ebp)
      23:	89 c2                	mov    %eax,%edx
      25:	8b 45 0c             	mov    0xc(%ebp),%eax
      28:	01 d0                	add    %edx,%eax
      2a:	c6 00 30             	movb   $0x30,(%eax)
        str[i] = '\0';
      2d:	8b 55 f8             	mov    -0x8(%ebp),%edx
      30:	8b 45 0c             	mov    0xc(%ebp),%eax
      33:	01 d0                	add    %edx,%eax
      35:	c6 00 00             	movb   $0x0,(%eax)
        return;
      38:	e9 a9 00 00 00       	jmp    e6 <itoa+0xe6>
    }
 
    while (num != 0)
      3d:	eb 36                	jmp    75 <itoa+0x75>
    {
        rem = num % base;
      3f:	8b 45 08             	mov    0x8(%ebp),%eax
      42:	99                   	cltd   
      43:	f7 7d 10             	idivl  0x10(%ebp)
      46:	89 55 fc             	mov    %edx,-0x4(%ebp)
        if(rem > 9)
      49:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
      4d:	7e 04                	jle    53 <itoa+0x53>
        {
            rem = rem - 10;
      4f:	83 6d fc 0a          	subl   $0xa,-0x4(%ebp)
        }
        /* Add the digit as a string */
        str[i++] = rem + '0';
      53:	8b 45 f8             	mov    -0x8(%ebp),%eax
      56:	8d 50 01             	lea    0x1(%eax),%edx
      59:	89 55 f8             	mov    %edx,-0x8(%ebp)
      5c:	89 c2                	mov    %eax,%edx
      5e:	8b 45 0c             	mov    0xc(%ebp),%eax
      61:	01 c2                	add    %eax,%edx
      63:	8b 45 fc             	mov    -0x4(%ebp),%eax
      66:	83 c0 30             	add    $0x30,%eax
      69:	88 02                	mov    %al,(%edx)
        num = num/base;
      6b:	8b 45 08             	mov    0x8(%ebp),%eax
      6e:	99                   	cltd   
      6f:	f7 7d 10             	idivl  0x10(%ebp)
      72:	89 45 08             	mov    %eax,0x8(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return;
    }
 
    while (num != 0)
      75:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      79:	75 c4                	jne    3f <itoa+0x3f>
        /* Add the digit as a string */
        str[i++] = rem + '0';
        num = num/base;
    }

    str[i] = '\0';
      7b:	8b 55 f8             	mov    -0x8(%ebp),%edx
      7e:	8b 45 0c             	mov    0xc(%ebp),%eax
      81:	01 d0                	add    %edx,%eax
      83:	c6 00 00             	movb   $0x0,(%eax)

    for(j = 0; j < i / 2; j++)
      86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      8d:	eb 45                	jmp    d4 <itoa+0xd4>
    {
        temp = str[j];
      8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
      92:	8b 45 0c             	mov    0xc(%ebp),%eax
      95:	01 d0                	add    %edx,%eax
      97:	8a 00                	mov    (%eax),%al
      99:	88 45 f3             	mov    %al,-0xd(%ebp)
        str[j] = str[i - j - 1];
      9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
      9f:	8b 45 0c             	mov    0xc(%ebp),%eax
      a2:	01 c2                	add    %eax,%edx
      a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
      a7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
      aa:	29 c1                	sub    %eax,%ecx
      ac:	89 c8                	mov    %ecx,%eax
      ae:	8d 48 ff             	lea    -0x1(%eax),%ecx
      b1:	8b 45 0c             	mov    0xc(%ebp),%eax
      b4:	01 c8                	add    %ecx,%eax
      b6:	8a 00                	mov    (%eax),%al
      b8:	88 02                	mov    %al,(%edx)
        str[i - j - 1] = temp;
      ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
      bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
      c0:	29 c2                	sub    %eax,%edx
      c2:	89 d0                	mov    %edx,%eax
      c4:	8d 50 ff             	lea    -0x1(%eax),%edx
      c7:	8b 45 0c             	mov    0xc(%ebp),%eax
      ca:	01 c2                	add    %eax,%edx
      cc:	8a 45 f3             	mov    -0xd(%ebp),%al
      cf:	88 02                	mov    %al,(%edx)
        num = num/base;
    }

    str[i] = '\0';

    for(j = 0; j < i / 2; j++)
      d1:	ff 45 f4             	incl   -0xc(%ebp)
      d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
      d7:	89 c2                	mov    %eax,%edx
      d9:	c1 ea 1f             	shr    $0x1f,%edx
      dc:	01 d0                	add    %edx,%eax
      de:	d1 f8                	sar    %eax
      e0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
      e3:	7f aa                	jg     8f <itoa+0x8f>
        temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }

    return;
      e5:	90                   	nop
}
      e6:	c9                   	leave  
      e7:	c3                   	ret    

000000e8 <print_usage>:



void print_usage(int mode){
      e8:	55                   	push   %ebp
      e9:	89 e5                	mov    %esp,%ebp
      eb:	83 ec 18             	sub    $0x18,%esp

  if(mode == 0){ // not enough arguments
      ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      f2:	75 14                	jne    108 <print_usage+0x20>
    printf(1, "Usage: ctool <mode> <args>\n");
      f4:	c7 44 24 04 4c 15 00 	movl   $0x154c,0x4(%esp)
      fb:	00 
      fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     103:	e8 7d 10 00 00       	call   1185 <printf>
  }
  if(mode == 1){ // create
     108:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     10c:	75 14                	jne    122 <print_usage+0x3a>
    printf(1, "Usage: ctool create <container> <max proc> <max mem> <max disk> <exec1> <exec2> ...\n");
     10e:	c7 44 24 04 68 15 00 	movl   $0x1568,0x4(%esp)
     115:	00 
     116:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     11d:	e8 63 10 00 00       	call   1185 <printf>
  }
  if(mode == 2){ // create with container created
     122:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
     126:	75 14                	jne    13c <print_usage+0x54>
    printf(1, "Container taken. Failed to create, exiting...\n");
     128:	c7 44 24 04 c0 15 00 	movl   $0x15c0,0x4(%esp)
     12f:	00 
     130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     137:	e8 49 10 00 00       	call   1185 <printf>
  }
  if(mode == 3){ // start
     13c:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
     140:	75 14                	jne    156 <print_usage+0x6e>
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
     142:	c7 44 24 04 f0 15 00 	movl   $0x15f0,0x4(%esp)
     149:	00 
     14a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     151:	e8 2f 10 00 00       	call   1185 <printf>
  }
  if(mode == 4){ // delete
     156:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     15a:	75 14                	jne    170 <print_usage+0x88>
    printf(1, "Usage: ctool delete <container>\n");
     15c:	c7 44 24 04 24 16 00 	movl   $0x1624,0x4(%esp)
     163:	00 
     164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     16b:	e8 15 10 00 00       	call   1185 <printf>
  }
  
  exit();
     170:	e8 db 0d 00 00       	call   f50 <exit>

00000175 <start>:
}

// ctool start vc0 c0 usfsh
int start(int argc, char *argv[]){
     175:	55                   	push   %ebp
     176:	89 e5                	mov    %esp,%ebp
     178:	53                   	push   %ebx
     179:	83 ec 34             	sub    $0x34,%esp
  int id, fd, cindex = 1, ppid = getpid();
     17c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     183:	e8 48 0e 00 00       	call   fd0 <getpid>
     188:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char index[2];
  index[0] = argv[3][strlen(argv[3])-1];
     18b:	8b 45 0c             	mov    0xc(%ebp),%eax
     18e:	83 c0 0c             	add    $0xc,%eax
     191:	8b 18                	mov    (%eax),%ebx
     193:	8b 45 0c             	mov    0xc(%ebp),%eax
     196:	83 c0 0c             	add    $0xc,%eax
     199:	8b 00                	mov    (%eax),%eax
     19b:	89 04 24             	mov    %eax,(%esp)
     19e:	e8 d6 07 00 00       	call   979 <strlen>
     1a3:	48                   	dec    %eax
     1a4:	01 d8                	add    %ebx,%eax
     1a6:	8a 00                	mov    (%eax),%al
     1a8:	88 45 e6             	mov    %al,-0x1a(%ebp)
  index[1] = '\0';
     1ab:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  cindex = atoi(index);
     1af:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     1b2:	89 04 24             	mov    %eax,(%esp)
     1b5:	e8 05 0d 00 00       	call   ebf <atoi>
     1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

  setvc(cindex, argv[2]);
     1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
     1c0:	83 c0 08             	add    $0x8,%eax
     1c3:	8b 00                	mov    (%eax),%eax
     1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
     1c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1cc:	89 04 24             	mov    %eax,(%esp)
     1cf:	e8 7c 0e 00 00       	call   1050 <setvc>

  fd = open(argv[2], O_RDWR);
     1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
     1d7:	83 c0 08             	add    $0x8,%eax
     1da:	8b 00                	mov    (%eax),%eax
     1dc:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     1e3:	00 
     1e4:	89 04 24             	mov    %eax,(%esp)
     1e7:	e8 a4 0d 00 00       	call   f90 <open>
     1ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     1ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     1f3:	79 25                	jns    21a <start+0xa5>
    printf(1, "Failed to open console %s\n", argv[2]);
     1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     1f8:	83 c0 08             	add    $0x8,%eax
     1fb:	8b 00                	mov    (%eax),%eax
     1fd:	89 44 24 08          	mov    %eax,0x8(%esp)
     201:	c7 44 24 04 45 16 00 	movl   $0x1645,0x4(%esp)
     208:	00 
     209:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     210:	e8 70 0f 00 00       	call   1185 <printf>
    exit();
     215:	e8 36 0d 00 00       	call   f50 <exit>
  }
  printf(1, "Opened console %s\n", argv[2]);
     21a:	8b 45 0c             	mov    0xc(%ebp),%eax
     21d:	83 c0 08             	add    $0x8,%eax
     220:	8b 00                	mov    (%eax),%eax
     222:	89 44 24 08          	mov    %eax,0x8(%esp)
     226:	c7 44 24 04 60 16 00 	movl   $0x1660,0x4(%esp)
     22d:	00 
     22e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     235:	e8 4b 0f 00 00       	call   1185 <printf>
  /* fork a child and exec argv[4] */
  id = fork();
     23a:	e8 09 0d 00 00       	call   f48 <fork>
     23f:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if(id == 0){
     242:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     246:	0f 85 b3 00 00 00    	jne    2ff <start+0x18a>
    close(0);
     24c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     253:	e8 20 0d 00 00       	call   f78 <close>
    close(1);
     258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     25f:	e8 14 0d 00 00       	call   f78 <close>
    close(2);
     264:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     26b:	e8 08 0d 00 00       	call   f78 <close>
    dup(fd);
     270:	8b 45 ec             	mov    -0x14(%ebp),%eax
     273:	89 04 24             	mov    %eax,(%esp)
     276:	e8 4d 0d 00 00       	call   fc8 <dup>
    dup(fd);
     27b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 42 0d 00 00       	call   fc8 <dup>
    dup(fd);
     286:	8b 45 ec             	mov    -0x14(%ebp),%eax
     289:	89 04 24             	mov    %eax,(%esp)
     28c:	e8 37 0d 00 00       	call   fc8 <dup>
    if(chdir(argv[3]) < 0){
     291:	8b 45 0c             	mov    0xc(%ebp),%eax
     294:	83 c0 0c             	add    $0xc,%eax
     297:	8b 00                	mov    (%eax),%eax
     299:	89 04 24             	mov    %eax,(%esp)
     29c:	e8 1f 0d 00 00       	call   fc0 <chdir>
     2a1:	85 c0                	test   %eax,%eax
     2a3:	79 30                	jns    2d5 <start+0x160>
      printf(1, "Container %s does not exist.", argv[3]);
     2a5:	8b 45 0c             	mov    0xc(%ebp),%eax
     2a8:	83 c0 0c             	add    $0xc,%eax
     2ab:	8b 00                	mov    (%eax),%eax
     2ad:	89 44 24 08          	mov    %eax,0x8(%esp)
     2b1:	c7 44 24 04 73 16 00 	movl   $0x1673,0x4(%esp)
     2b8:	00 
     2b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c0:	e8 c0 0e 00 00       	call   1185 <printf>
      kill(ppid);
     2c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2c8:	89 04 24             	mov    %eax,(%esp)
     2cb:	e8 b0 0c 00 00       	call   f80 <kill>
      exit();
     2d0:	e8 7b 0c 00 00       	call   f50 <exit>
    }
    exec(argv[4], &argv[4]);
     2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
     2d8:	8d 50 10             	lea    0x10(%eax),%edx
     2db:	8b 45 0c             	mov    0xc(%ebp),%eax
     2de:	83 c0 10             	add    $0x10,%eax
     2e1:	8b 00                	mov    (%eax),%eax
     2e3:	89 54 24 04          	mov    %edx,0x4(%esp)
     2e7:	89 04 24             	mov    %eax,(%esp)
     2ea:	e8 99 0c 00 00       	call   f88 <exec>
    close(fd);
     2ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2f2:	89 04 24             	mov    %eax,(%esp)
     2f5:	e8 7e 0c 00 00       	call   f78 <close>
    exit();
     2fa:	e8 51 0c 00 00       	call   f50 <exit>
  }

  return 0;
     2ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
     304:	83 c4 34             	add    $0x34,%esp
     307:	5b                   	pop    %ebx
     308:	5d                   	pop    %ebp
     309:	c3                   	ret    

0000030a <stop>:

int stop(char *argv[]){
     30a:	55                   	push   %ebp
     30b:	89 e5                	mov    %esp,%ebp
  // TODO: loop through processes and kill them
  return 1;
     30d:	b8 01 00 00 00       	mov    $0x1,%eax
}
     312:	5d                   	pop    %ebp
     313:	c3                   	ret    

00000314 <create>:
//     }
//   }return 1;
// }

// ctool create c0 8 8 8 cat ls echo sh ...
int create(int argc, char *argv[]){
     314:	55                   	push   %ebp
     315:	89 e5                	mov    %esp,%ebp
     317:	53                   	push   %ebx
     318:	83 ec 64             	sub    $0x64,%esp
  int i, id, bytes, cindex = 0;
     31b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  // num_files = argc - 6;
  char *mkdir[2];
  // char *files[num_files];
  mkdir[0] = "mkdir";
     322:	c7 45 dc 90 16 00 00 	movl   $0x1690,-0x24(%ebp)
  mkdir[1] = argv[2];
     329:	8b 45 0c             	mov    0xc(%ebp),%eax
     32c:	8b 40 08             	mov    0x8(%eax),%eax
     32f:	89 45 e0             	mov    %eax,-0x20(%ebp)

  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
     332:	8b 45 0c             	mov    0xc(%ebp),%eax
     335:	83 c0 08             	add    $0x8,%eax
     338:	8b 18                	mov    (%eax),%ebx
     33a:	8b 45 0c             	mov    0xc(%ebp),%eax
     33d:	83 c0 08             	add    $0x8,%eax
     340:	8b 00                	mov    (%eax),%eax
     342:	89 04 24             	mov    %eax,(%esp)
     345:	e8 2f 06 00 00       	call   979 <strlen>
     34a:	48                   	dec    %eax
     34b:	01 d8                	add    %ebx,%eax
     34d:	8a 00                	mov    (%eax),%al
     34f:	88 45 da             	mov    %al,-0x26(%ebp)
  index[1] = '\0';
     352:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  cindex = atoi(index);
     356:	8d 45 da             	lea    -0x26(%ebp),%eax
     359:	89 04 24             	mov    %eax,(%esp)
     35c:	e8 5e 0b 00 00       	call   ebf <atoi>
     361:	89 45 f0             	mov    %eax,-0x10(%ebp)

  setname(cindex, argv[2]);
     364:	8b 45 0c             	mov    0xc(%ebp),%eax
     367:	83 c0 08             	add    $0x8,%eax
     36a:	8b 00                	mov    (%eax),%eax
     36c:	89 44 24 04          	mov    %eax,0x4(%esp)
     370:	8b 45 f0             	mov    -0x10(%ebp),%eax
     373:	89 04 24             	mov    %eax,(%esp)
     376:	e8 7d 0c 00 00       	call   ff8 <setname>
  setmaxproc(cindex, atoi(argv[3]));
     37b:	8b 45 0c             	mov    0xc(%ebp),%eax
     37e:	83 c0 0c             	add    $0xc,%eax
     381:	8b 00                	mov    (%eax),%eax
     383:	89 04 24             	mov    %eax,(%esp)
     386:	e8 34 0b 00 00       	call   ebf <atoi>
     38b:	89 44 24 04          	mov    %eax,0x4(%esp)
     38f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     392:	89 04 24             	mov    %eax,(%esp)
     395:	e8 6e 0c 00 00       	call   1008 <setmaxproc>
  setmaxmem(cindex, atoi(argv[4]) * 1000000);
     39a:	8b 45 0c             	mov    0xc(%ebp),%eax
     39d:	83 c0 10             	add    $0x10,%eax
     3a0:	8b 00                	mov    (%eax),%eax
     3a2:	89 04 24             	mov    %eax,(%esp)
     3a5:	e8 15 0b 00 00       	call   ebf <atoi>
     3aa:	89 c2                	mov    %eax,%edx
     3ac:	89 d0                	mov    %edx,%eax
     3ae:	c1 e0 02             	shl    $0x2,%eax
     3b1:	01 d0                	add    %edx,%eax
     3b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3ba:	01 d0                	add    %edx,%eax
     3bc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3c3:	01 d0                	add    %edx,%eax
     3c5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3cc:	01 d0                	add    %edx,%eax
     3ce:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3d5:	01 d0                	add    %edx,%eax
     3d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3de:	01 d0                	add    %edx,%eax
     3e0:	c1 e0 06             	shl    $0x6,%eax
     3e3:	89 44 24 04          	mov    %eax,0x4(%esp)
     3e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3ea:	89 04 24             	mov    %eax,(%esp)
     3ed:	e8 26 0c 00 00       	call   1018 <setmaxmem>
  setmaxdisk(cindex, atoi(argv[5]) * 1000000);
     3f2:	8b 45 0c             	mov    0xc(%ebp),%eax
     3f5:	83 c0 14             	add    $0x14,%eax
     3f8:	8b 00                	mov    (%eax),%eax
     3fa:	89 04 24             	mov    %eax,(%esp)
     3fd:	e8 bd 0a 00 00       	call   ebf <atoi>
     402:	89 c2                	mov    %eax,%edx
     404:	89 d0                	mov    %edx,%eax
     406:	c1 e0 02             	shl    $0x2,%eax
     409:	01 d0                	add    %edx,%eax
     40b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     412:	01 d0                	add    %edx,%eax
     414:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     41b:	01 d0                	add    %edx,%eax
     41d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     424:	01 d0                	add    %edx,%eax
     426:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     42d:	01 d0                	add    %edx,%eax
     42f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     436:	01 d0                	add    %edx,%eax
     438:	c1 e0 06             	shl    $0x6,%eax
     43b:	89 44 24 04          	mov    %eax,0x4(%esp)
     43f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     442:	89 04 24             	mov    %eax,(%esp)
     445:	e8 de 0b 00 00       	call   1028 <setmaxdisk>
  setusedmem(cindex, 0);
     44a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     451:	00 
     452:	8b 45 f0             	mov    -0x10(%ebp),%eax
     455:	89 04 24             	mov    %eax,(%esp)
     458:	e8 db 0b 00 00       	call   1038 <setusedmem>
  setuseddisk(cindex, 0);
     45d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     464:	00 
     465:	8b 45 f0             	mov    -0x10(%ebp),%eax
     468:	89 04 24             	mov    %eax,(%esp)
     46b:	e8 d8 0b 00 00       	call   1048 <setuseddisk>
  setatroot(cindex, 1);
     470:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
     477:	00 
     478:	8b 45 f0             	mov    -0x10(%ebp),%eax
     47b:	89 04 24             	mov    %eax,(%esp)
     47e:	e8 05 0c 00 00       	call   1088 <setatroot>

  int ppid = getpid();
     483:	e8 48 0b 00 00       	call   fd0 <getpid>
     488:	89 45 ec             	mov    %eax,-0x14(%ebp)
  id = fork();
     48b:	e8 b8 0a 00 00       	call   f48 <fork>
     490:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(id == 0){
     493:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     497:	75 36                	jne    4cf <create+0x1bb>
    exec(mkdir[0], mkdir);
     499:	8b 45 dc             	mov    -0x24(%ebp),%eax
     49c:	8d 55 dc             	lea    -0x24(%ebp),%edx
     49f:	89 54 24 04          	mov    %edx,0x4(%esp)
     4a3:	89 04 24             	mov    %eax,(%esp)
     4a6:	e8 dd 0a 00 00       	call   f88 <exec>
    printf(1, "Creating container failed. Container taken.\n");
     4ab:	c7 44 24 04 98 16 00 	movl   $0x1698,0x4(%esp)
     4b2:	00 
     4b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4ba:	e8 c6 0c 00 00       	call   1185 <printf>
    kill(ppid);
     4bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4c2:	89 04 24             	mov    %eax,(%esp)
     4c5:	e8 b6 0a 00 00       	call   f80 <kill>
    exit();
     4ca:	e8 81 0a 00 00       	call   f50 <exit>
  }
  id = wait();
     4cf:	e8 84 0a 00 00       	call   f58 <wait>
     4d4:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     4d7:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     4de:	e9 66 01 00 00       	jmp    649 <create+0x335>
    char destination[32];

    strcpy(destination, "/");
     4e3:	c7 44 24 04 c5 16 00 	movl   $0x16c5,0x4(%esp)
     4ea:	00 
     4eb:	8d 45 b0             	lea    -0x50(%ebp),%eax
     4ee:	89 04 24             	mov    %eax,(%esp)
     4f1:	e8 cf 02 00 00       	call   7c5 <strcpy>
    strcat(destination, mkdir[1]);
     4f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
     4f9:	89 44 24 04          	mov    %eax,0x4(%esp)
     4fd:	8d 45 b0             	lea    -0x50(%ebp),%eax
     500:	89 04 24             	mov    %eax,(%esp)
     503:	e8 ea 04 00 00       	call   9f2 <strcat>
    strcat(destination, "/");
     508:	c7 44 24 04 c5 16 00 	movl   $0x16c5,0x4(%esp)
     50f:	00 
     510:	8d 45 b0             	lea    -0x50(%ebp),%eax
     513:	89 04 24             	mov    %eax,(%esp)
     516:	e8 d7 04 00 00       	call   9f2 <strcat>
    strcat(destination, argv[i]);
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     525:	8b 45 0c             	mov    0xc(%ebp),%eax
     528:	01 d0                	add    %edx,%eax
     52a:	8b 00                	mov    (%eax),%eax
     52c:	89 44 24 04          	mov    %eax,0x4(%esp)
     530:	8d 45 b0             	lea    -0x50(%ebp),%eax
     533:	89 04 24             	mov    %eax,(%esp)
     536:	e8 b7 04 00 00       	call   9f2 <strcat>
    strcat(destination, "\0");
     53b:	c7 44 24 04 c7 16 00 	movl   $0x16c7,0x4(%esp)
     542:	00 
     543:	8d 45 b0             	lea    -0x50(%ebp),%eax
     546:	89 04 24             	mov    %eax,(%esp)
     549:	e8 a4 04 00 00       	call   9f2 <strcat>

    // ctable.tuperwares[i].files[i-6] = argv[i];
    bytes = copy(argv[i], destination, getuseddisk(cindex), getmaxdisk(cindex));
     54e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     551:	89 04 24             	mov    %eax,(%esp)
     554:	e8 c7 0a 00 00       	call   1020 <getmaxdisk>
     559:	89 c3                	mov    %eax,%ebx
     55b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     55e:	89 04 24             	mov    %eax,(%esp)
     561:	e8 da 0a 00 00       	call   1040 <getuseddisk>
     566:	8b 55 f4             	mov    -0xc(%ebp),%edx
     569:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
     570:	8b 55 0c             	mov    0xc(%ebp),%edx
     573:	01 ca                	add    %ecx,%edx
     575:	8b 12                	mov    (%edx),%edx
     577:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     57b:	89 44 24 08          	mov    %eax,0x8(%esp)
     57f:	8d 45 b0             	lea    -0x50(%ebp),%eax
     582:	89 44 24 04          	mov    %eax,0x4(%esp)
     586:	89 14 24             	mov    %edx,(%esp)
     589:	e8 65 02 00 00       	call   7f3 <copy>
     58e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Bytes for %s: %d\n", argv[i], bytes);
     591:	8b 45 f4             	mov    -0xc(%ebp),%eax
     594:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     59b:	8b 45 0c             	mov    0xc(%ebp),%eax
     59e:	01 d0                	add    %edx,%eax
     5a0:	8b 00                	mov    (%eax),%eax
     5a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     5a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
     5a9:	89 44 24 08          	mov    %eax,0x8(%esp)
     5ad:	c7 44 24 04 c9 16 00 	movl   $0x16c9,0x4(%esp)
     5b4:	00 
     5b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5bc:	e8 c4 0b 00 00       	call   1185 <printf>

    if(bytes > 0){
     5c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     5c5:	7e 21                	jle    5e8 <create+0x2d4>
      setuseddisk(cindex, getuseddisk(cindex) + bytes);
     5c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5ca:	89 04 24             	mov    %eax,(%esp)
     5cd:	e8 6e 0a 00 00       	call   1040 <getuseddisk>
     5d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     5d5:	01 d0                	add    %edx,%eax
     5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
     5db:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5de:	89 04 24             	mov    %eax,(%esp)
     5e1:	e8 62 0a 00 00       	call   1048 <setuseddisk>
     5e6:	eb 5e                	jmp    646 <create+0x332>
    }
    else{
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
     5e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     5f2:	8b 45 0c             	mov    0xc(%ebp),%eax
     5f5:	01 d0                	add    %edx,%eax
     5f7:	8b 00                	mov    (%eax),%eax
     5f9:	89 44 24 08          	mov    %eax,0x8(%esp)
     5fd:	c7 44 24 04 dc 16 00 	movl   $0x16dc,0x4(%esp)
     604:	00 
     605:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     60c:	e8 74 0b 00 00       	call   1185 <printf>
      id = fork();
     611:	e8 32 09 00 00       	call   f48 <fork>
     616:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(id == 0){
     619:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     61d:	75 1f                	jne    63e <create+0x32a>
        char *remove_args[2];
        remove_args[0] = "rm";
     61f:	c7 45 d0 32 17 00 00 	movl   $0x1732,-0x30(%ebp)
        remove_args[1] = destination;
     626:	8d 45 b0             	lea    -0x50(%ebp),%eax
     629:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        exec(remove_args[0], remove_args);
     62c:	8b 45 d0             	mov    -0x30(%ebp),%eax
     62f:	8d 55 d0             	lea    -0x30(%ebp),%edx
     632:	89 54 24 04          	mov    %edx,0x4(%esp)
     636:	89 04 24             	mov    %eax,(%esp)
     639:	e8 4a 09 00 00       	call   f88 <exec>
      }
      id = wait();
     63e:	e8 15 09 00 00       	call   f58 <wait>
     643:	89 45 e8             	mov    %eax,-0x18(%ebp)
    kill(ppid);
    exit();
  }
  id = wait();

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     646:	ff 45 f4             	incl   -0xc(%ebp)
     649:	8b 45 f4             	mov    -0xc(%ebp),%eax
     64c:	3b 45 08             	cmp    0x8(%ebp),%eax
     64f:	0f 8c 8e fe ff ff    	jl     4e3 <create+0x1cf>
        exec(remove_args[0], remove_args);
      }
      id = wait();
    }
  }
  printf(1, "Total used disk: %d\n", getuseddisk(cindex));
     655:	8b 45 f0             	mov    -0x10(%ebp),%eax
     658:	89 04 24             	mov    %eax,(%esp)
     65b:	e8 e0 09 00 00       	call   1040 <getuseddisk>
     660:	89 44 24 08          	mov    %eax,0x8(%esp)
     664:	c7 44 24 04 35 17 00 	movl   $0x1735,0x4(%esp)
     66b:	00 
     66c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     673:	e8 0d 0b 00 00       	call   1185 <printf>

  // TODO: IMPLEMENT GET/SET FILES
  // ctable.tuperwares[cindex].files = files;
  return 0;
     678:	b8 00 00 00 00       	mov    $0x0,%eax
}
     67d:	83 c4 64             	add    $0x64,%esp
     680:	5b                   	pop    %ebx
     681:	5d                   	pop    %ebp
     682:	c3                   	ret    

00000683 <to_string>:

int to_string(){
     683:	55                   	push   %ebp
     684:	89 e5                	mov    %esp,%ebp
     686:	81 ec 18 01 00 00    	sub    $0x118,%esp

  char containers[256];
  tostring(containers);
     68c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
     692:	89 04 24             	mov    %eax,(%esp)
     695:	e8 de 09 00 00       	call   1078 <tostring>
  printf(1, "%s\n", containers);
     69a:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
     6a0:	89 44 24 08          	mov    %eax,0x8(%esp)
     6a4:	c7 44 24 04 4a 17 00 	movl   $0x174a,0x4(%esp)
     6ab:	00 
     6ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6b3:	e8 cd 0a 00 00       	call   1185 <printf>
  return 0;
     6b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6bd:	c9                   	leave  
     6be:	c3                   	ret    

000006bf <main>:

int main(int argc, char *argv[]){
     6bf:	55                   	push   %ebp
     6c0:	89 e5                	mov    %esp,%ebp
     6c2:	83 e4 f0             	and    $0xfffffff0,%esp
     6c5:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2){
     6c8:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     6cc:	7f 0c                	jg     6da <main+0x1b>
    print_usage(0);
     6ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6d5:	e8 0e fa ff ff       	call   e8 <print_usage>
  }

  if(strcmp(argv[1], "create") == 0){
     6da:	8b 45 0c             	mov    0xc(%ebp),%eax
     6dd:	83 c0 04             	add    $0x4,%eax
     6e0:	8b 00                	mov    (%eax),%eax
     6e2:	c7 44 24 04 4e 17 00 	movl   $0x174e,0x4(%esp)
     6e9:	00 
     6ea:	89 04 24             	mov    %eax,(%esp)
     6ed:	e8 01 02 00 00       	call   8f3 <strcmp>
     6f2:	85 c0                	test   %eax,%eax
     6f4:	75 44                	jne    73a <main+0x7b>
    if(argc < 7){
     6f6:	83 7d 08 06          	cmpl   $0x6,0x8(%ebp)
     6fa:	7f 0c                	jg     708 <main+0x49>
      print_usage(1);
     6fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     703:	e8 e0 f9 ff ff       	call   e8 <print_usage>
    }
    if(chdir(argv[2]) > 0){
     708:	8b 45 0c             	mov    0xc(%ebp),%eax
     70b:	83 c0 08             	add    $0x8,%eax
     70e:	8b 00                	mov    (%eax),%eax
     710:	89 04 24             	mov    %eax,(%esp)
     713:	e8 a8 08 00 00       	call   fc0 <chdir>
     718:	85 c0                	test   %eax,%eax
     71a:	7e 0c                	jle    728 <main+0x69>
      print_usage(2);
     71c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     723:	e8 c0 f9 ff ff       	call   e8 <print_usage>
    }
    create(argc, argv);
     728:	8b 45 0c             	mov    0xc(%ebp),%eax
     72b:	89 44 24 04          	mov    %eax,0x4(%esp)
     72f:	8b 45 08             	mov    0x8(%ebp),%eax
     732:	89 04 24             	mov    %eax,(%esp)
     735:	e8 da fb ff ff       	call   314 <create>
  }

  if(strcmp(argv[1], "start") == 0){
     73a:	8b 45 0c             	mov    0xc(%ebp),%eax
     73d:	83 c0 04             	add    $0x4,%eax
     740:	8b 00                	mov    (%eax),%eax
     742:	c7 44 24 04 55 17 00 	movl   $0x1755,0x4(%esp)
     749:	00 
     74a:	89 04 24             	mov    %eax,(%esp)
     74d:	e8 a1 01 00 00       	call   8f3 <strcmp>
     752:	85 c0                	test   %eax,%eax
     754:	75 24                	jne    77a <main+0xbb>
    if(argc < 5){
     756:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     75a:	7f 0c                	jg     768 <main+0xa9>
      print_usage(3);
     75c:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     763:	e8 80 f9 ff ff       	call   e8 <print_usage>
    }
    start(argc, argv);
     768:	8b 45 0c             	mov    0xc(%ebp),%eax
     76b:	89 44 24 04          	mov    %eax,0x4(%esp)
     76f:	8b 45 08             	mov    0x8(%ebp),%eax
     772:	89 04 24             	mov    %eax,(%esp)
     775:	e8 fb f9 ff ff       	call   175 <start>
  }

  if(strcmp(argv[1], "string") == 0){
     77a:	8b 45 0c             	mov    0xc(%ebp),%eax
     77d:	83 c0 04             	add    $0x4,%eax
     780:	8b 00                	mov    (%eax),%eax
     782:	c7 44 24 04 5b 17 00 	movl   $0x175b,0x4(%esp)
     789:	00 
     78a:	89 04 24             	mov    %eax,(%esp)
     78d:	e8 61 01 00 00       	call   8f3 <strcmp>
     792:	85 c0                	test   %eax,%eax
     794:	75 05                	jne    79b <main+0xdc>
    to_string();
     796:	e8 e8 fe ff ff       	call   683 <to_string>
  //   if(argc < 3){
  //     print_usage(4);
  //   }
  //   delete(argv);
  // }
  exit();
     79b:	e8 b0 07 00 00       	call   f50 <exit>

000007a0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     7a0:	55                   	push   %ebp
     7a1:	89 e5                	mov    %esp,%ebp
     7a3:	57                   	push   %edi
     7a4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     7a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     7a8:	8b 55 10             	mov    0x10(%ebp),%edx
     7ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     7ae:	89 cb                	mov    %ecx,%ebx
     7b0:	89 df                	mov    %ebx,%edi
     7b2:	89 d1                	mov    %edx,%ecx
     7b4:	fc                   	cld    
     7b5:	f3 aa                	rep stos %al,%es:(%edi)
     7b7:	89 ca                	mov    %ecx,%edx
     7b9:	89 fb                	mov    %edi,%ebx
     7bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
     7be:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     7c1:	5b                   	pop    %ebx
     7c2:	5f                   	pop    %edi
     7c3:	5d                   	pop    %ebp
     7c4:	c3                   	ret    

000007c5 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     7c5:	55                   	push   %ebp
     7c6:	89 e5                	mov    %esp,%ebp
     7c8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     7cb:	8b 45 08             	mov    0x8(%ebp),%eax
     7ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     7d1:	90                   	nop
     7d2:	8b 45 08             	mov    0x8(%ebp),%eax
     7d5:	8d 50 01             	lea    0x1(%eax),%edx
     7d8:	89 55 08             	mov    %edx,0x8(%ebp)
     7db:	8b 55 0c             	mov    0xc(%ebp),%edx
     7de:	8d 4a 01             	lea    0x1(%edx),%ecx
     7e1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     7e4:	8a 12                	mov    (%edx),%dl
     7e6:	88 10                	mov    %dl,(%eax)
     7e8:	8a 00                	mov    (%eax),%al
     7ea:	84 c0                	test   %al,%al
     7ec:	75 e4                	jne    7d2 <strcpy+0xd>
    ;
  return os;
     7ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     7f1:	c9                   	leave  
     7f2:	c3                   	ret    

000007f3 <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     7f3:	55                   	push   %ebp
     7f4:	89 e5                	mov    %esp,%ebp
     7f6:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     7f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     800:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     807:	00 
     808:	8b 45 08             	mov    0x8(%ebp),%eax
     80b:	89 04 24             	mov    %eax,(%esp)
     80e:	e8 7d 07 00 00       	call   f90 <open>
     813:	89 45 f0             	mov    %eax,-0x10(%ebp)
     816:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     81a:	79 20                	jns    83c <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     81c:	8b 45 08             	mov    0x8(%ebp),%eax
     81f:	89 44 24 08          	mov    %eax,0x8(%esp)
     823:	c7 44 24 04 62 17 00 	movl   $0x1762,0x4(%esp)
     82a:	00 
     82b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     832:	e8 4e 09 00 00       	call   1185 <printf>
      exit();
     837:	e8 14 07 00 00       	call   f50 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     83c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     843:	00 
     844:	8b 45 0c             	mov    0xc(%ebp),%eax
     847:	89 04 24             	mov    %eax,(%esp)
     84a:	e8 41 07 00 00       	call   f90 <open>
     84f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     852:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     856:	79 20                	jns    878 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     858:	8b 45 0c             	mov    0xc(%ebp),%eax
     85b:	89 44 24 08          	mov    %eax,0x8(%esp)
     85f:	c7 44 24 04 7d 17 00 	movl   $0x177d,0x4(%esp)
     866:	00 
     867:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     86e:	e8 12 09 00 00       	call   1185 <printf>
      exit();
     873:	e8 d8 06 00 00       	call   f50 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     878:	eb 3b                	jmp    8b5 <copy+0xc2>
  {
      max = used_disk+=count;
     87a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     87d:	01 45 10             	add    %eax,0x10(%ebp)
     880:	8b 45 10             	mov    0x10(%ebp),%eax
     883:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     886:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     889:	3b 45 14             	cmp    0x14(%ebp),%eax
     88c:	7e 07                	jle    895 <copy+0xa2>
      {
        return -1;
     88e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     893:	eb 5c                	jmp    8f1 <copy+0xfe>
      }
      bytes = bytes + count;
     895:	8b 45 e8             	mov    -0x18(%ebp),%eax
     898:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     89b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     8a2:	00 
     8a3:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     8a6:	89 44 24 04          	mov    %eax,0x4(%esp)
     8aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8ad:	89 04 24             	mov    %eax,(%esp)
     8b0:	e8 bb 06 00 00       	call   f70 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     8b5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     8bc:	00 
     8bd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     8c0:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8c7:	89 04 24             	mov    %eax,(%esp)
     8ca:	e8 99 06 00 00       	call   f68 <read>
     8cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
     8d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     8d6:	7f a2                	jg     87a <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     8d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8db:	89 04 24             	mov    %eax,(%esp)
     8de:	e8 95 06 00 00       	call   f78 <close>
  close(fd2);
     8e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8e6:	89 04 24             	mov    %eax,(%esp)
     8e9:	e8 8a 06 00 00       	call   f78 <close>
  return(bytes);
     8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8f1:	c9                   	leave  
     8f2:	c3                   	ret    

000008f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8f3:	55                   	push   %ebp
     8f4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     8f6:	eb 06                	jmp    8fe <strcmp+0xb>
    p++, q++;
     8f8:	ff 45 08             	incl   0x8(%ebp)
     8fb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     8fe:	8b 45 08             	mov    0x8(%ebp),%eax
     901:	8a 00                	mov    (%eax),%al
     903:	84 c0                	test   %al,%al
     905:	74 0e                	je     915 <strcmp+0x22>
     907:	8b 45 08             	mov    0x8(%ebp),%eax
     90a:	8a 10                	mov    (%eax),%dl
     90c:	8b 45 0c             	mov    0xc(%ebp),%eax
     90f:	8a 00                	mov    (%eax),%al
     911:	38 c2                	cmp    %al,%dl
     913:	74 e3                	je     8f8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     915:	8b 45 08             	mov    0x8(%ebp),%eax
     918:	8a 00                	mov    (%eax),%al
     91a:	0f b6 d0             	movzbl %al,%edx
     91d:	8b 45 0c             	mov    0xc(%ebp),%eax
     920:	8a 00                	mov    (%eax),%al
     922:	0f b6 c0             	movzbl %al,%eax
     925:	29 c2                	sub    %eax,%edx
     927:	89 d0                	mov    %edx,%eax
}
     929:	5d                   	pop    %ebp
     92a:	c3                   	ret    

0000092b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     92b:	55                   	push   %ebp
     92c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     92e:	eb 09                	jmp    939 <strncmp+0xe>
    n--, p++, q++;
     930:	ff 4d 10             	decl   0x10(%ebp)
     933:	ff 45 08             	incl   0x8(%ebp)
     936:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     939:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     93d:	74 17                	je     956 <strncmp+0x2b>
     93f:	8b 45 08             	mov    0x8(%ebp),%eax
     942:	8a 00                	mov    (%eax),%al
     944:	84 c0                	test   %al,%al
     946:	74 0e                	je     956 <strncmp+0x2b>
     948:	8b 45 08             	mov    0x8(%ebp),%eax
     94b:	8a 10                	mov    (%eax),%dl
     94d:	8b 45 0c             	mov    0xc(%ebp),%eax
     950:	8a 00                	mov    (%eax),%al
     952:	38 c2                	cmp    %al,%dl
     954:	74 da                	je     930 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     956:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     95a:	75 07                	jne    963 <strncmp+0x38>
    return 0;
     95c:	b8 00 00 00 00       	mov    $0x0,%eax
     961:	eb 14                	jmp    977 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     963:	8b 45 08             	mov    0x8(%ebp),%eax
     966:	8a 00                	mov    (%eax),%al
     968:	0f b6 d0             	movzbl %al,%edx
     96b:	8b 45 0c             	mov    0xc(%ebp),%eax
     96e:	8a 00                	mov    (%eax),%al
     970:	0f b6 c0             	movzbl %al,%eax
     973:	29 c2                	sub    %eax,%edx
     975:	89 d0                	mov    %edx,%eax
}
     977:	5d                   	pop    %ebp
     978:	c3                   	ret    

00000979 <strlen>:

uint
strlen(const char *s)
{
     979:	55                   	push   %ebp
     97a:	89 e5                	mov    %esp,%ebp
     97c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     97f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     986:	eb 03                	jmp    98b <strlen+0x12>
     988:	ff 45 fc             	incl   -0x4(%ebp)
     98b:	8b 55 fc             	mov    -0x4(%ebp),%edx
     98e:	8b 45 08             	mov    0x8(%ebp),%eax
     991:	01 d0                	add    %edx,%eax
     993:	8a 00                	mov    (%eax),%al
     995:	84 c0                	test   %al,%al
     997:	75 ef                	jne    988 <strlen+0xf>
    ;
  return n;
     999:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     99c:	c9                   	leave  
     99d:	c3                   	ret    

0000099e <memset>:

void*
memset(void *dst, int c, uint n)
{
     99e:	55                   	push   %ebp
     99f:	89 e5                	mov    %esp,%ebp
     9a1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     9a4:	8b 45 10             	mov    0x10(%ebp),%eax
     9a7:	89 44 24 08          	mov    %eax,0x8(%esp)
     9ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     9b2:	8b 45 08             	mov    0x8(%ebp),%eax
     9b5:	89 04 24             	mov    %eax,(%esp)
     9b8:	e8 e3 fd ff ff       	call   7a0 <stosb>
  return dst;
     9bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9c0:	c9                   	leave  
     9c1:	c3                   	ret    

000009c2 <strchr>:

char*
strchr(const char *s, char c)
{
     9c2:	55                   	push   %ebp
     9c3:	89 e5                	mov    %esp,%ebp
     9c5:	83 ec 04             	sub    $0x4,%esp
     9c8:	8b 45 0c             	mov    0xc(%ebp),%eax
     9cb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     9ce:	eb 12                	jmp    9e2 <strchr+0x20>
    if(*s == c)
     9d0:	8b 45 08             	mov    0x8(%ebp),%eax
     9d3:	8a 00                	mov    (%eax),%al
     9d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
     9d8:	75 05                	jne    9df <strchr+0x1d>
      return (char*)s;
     9da:	8b 45 08             	mov    0x8(%ebp),%eax
     9dd:	eb 11                	jmp    9f0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     9df:	ff 45 08             	incl   0x8(%ebp)
     9e2:	8b 45 08             	mov    0x8(%ebp),%eax
     9e5:	8a 00                	mov    (%eax),%al
     9e7:	84 c0                	test   %al,%al
     9e9:	75 e5                	jne    9d0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     9eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
     9f0:	c9                   	leave  
     9f1:	c3                   	ret    

000009f2 <strcat>:

char *
strcat(char *dest, const char *src)
{
     9f2:	55                   	push   %ebp
     9f3:	89 e5                	mov    %esp,%ebp
     9f5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     9f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     9ff:	eb 03                	jmp    a04 <strcat+0x12>
     a01:	ff 45 fc             	incl   -0x4(%ebp)
     a04:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a07:	8b 45 08             	mov    0x8(%ebp),%eax
     a0a:	01 d0                	add    %edx,%eax
     a0c:	8a 00                	mov    (%eax),%al
     a0e:	84 c0                	test   %al,%al
     a10:	75 ef                	jne    a01 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     a12:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     a19:	eb 1e                	jmp    a39 <strcat+0x47>
        dest[i+j] = src[j];
     a1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a1e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a21:	01 d0                	add    %edx,%eax
     a23:	89 c2                	mov    %eax,%edx
     a25:	8b 45 08             	mov    0x8(%ebp),%eax
     a28:	01 c2                	add    %eax,%edx
     a2a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     a2d:	8b 45 0c             	mov    0xc(%ebp),%eax
     a30:	01 c8                	add    %ecx,%eax
     a32:	8a 00                	mov    (%eax),%al
     a34:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     a36:	ff 45 f8             	incl   -0x8(%ebp)
     a39:	8b 55 f8             	mov    -0x8(%ebp),%edx
     a3c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a3f:	01 d0                	add    %edx,%eax
     a41:	8a 00                	mov    (%eax),%al
     a43:	84 c0                	test   %al,%al
     a45:	75 d4                	jne    a1b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     a47:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a4a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a4d:	01 d0                	add    %edx,%eax
     a4f:	89 c2                	mov    %eax,%edx
     a51:	8b 45 08             	mov    0x8(%ebp),%eax
     a54:	01 d0                	add    %edx,%eax
     a56:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     a59:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a5c:	c9                   	leave  
     a5d:	c3                   	ret    

00000a5e <strstr>:

int 
strstr(char* s, char* sub)
{
     a5e:	55                   	push   %ebp
     a5f:	89 e5                	mov    %esp,%ebp
     a61:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     a64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     a6b:	eb 7c                	jmp    ae9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     a6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a70:	8b 45 08             	mov    0x8(%ebp),%eax
     a73:	01 d0                	add    %edx,%eax
     a75:	8a 10                	mov    (%eax),%dl
     a77:	8b 45 0c             	mov    0xc(%ebp),%eax
     a7a:	8a 00                	mov    (%eax),%al
     a7c:	38 c2                	cmp    %al,%dl
     a7e:	75 66                	jne    ae6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     a80:	8b 45 0c             	mov    0xc(%ebp),%eax
     a83:	89 04 24             	mov    %eax,(%esp)
     a86:	e8 ee fe ff ff       	call   979 <strlen>
     a8b:	83 f8 01             	cmp    $0x1,%eax
     a8e:	75 05                	jne    a95 <strstr+0x37>
            {  
                return i;
     a90:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a93:	eb 6b                	jmp    b00 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     a95:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     a9c:	eb 3a                	jmp    ad8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     a9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     aa1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     aa4:	01 d0                	add    %edx,%eax
     aa6:	89 c2                	mov    %eax,%edx
     aa8:	8b 45 08             	mov    0x8(%ebp),%eax
     aab:	01 d0                	add    %edx,%eax
     aad:	8a 10                	mov    (%eax),%dl
     aaf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab5:	01 c8                	add    %ecx,%eax
     ab7:	8a 00                	mov    (%eax),%al
     ab9:	38 c2                	cmp    %al,%dl
     abb:	75 16                	jne    ad3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     abd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ac0:	8d 50 01             	lea    0x1(%eax),%edx
     ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ac6:	01 d0                	add    %edx,%eax
     ac8:	8a 00                	mov    (%eax),%al
     aca:	84 c0                	test   %al,%al
     acc:	75 07                	jne    ad5 <strstr+0x77>
                    {
                        return i;
     ace:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ad1:	eb 2d                	jmp    b00 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     ad3:	eb 11                	jmp    ae6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     ad5:	ff 45 f8             	incl   -0x8(%ebp)
     ad8:	8b 55 f8             	mov    -0x8(%ebp),%edx
     adb:	8b 45 0c             	mov    0xc(%ebp),%eax
     ade:	01 d0                	add    %edx,%eax
     ae0:	8a 00                	mov    (%eax),%al
     ae2:	84 c0                	test   %al,%al
     ae4:	75 b8                	jne    a9e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     ae6:	ff 45 fc             	incl   -0x4(%ebp)
     ae9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     aec:	8b 45 08             	mov    0x8(%ebp),%eax
     aef:	01 d0                	add    %edx,%eax
     af1:	8a 00                	mov    (%eax),%al
     af3:	84 c0                	test   %al,%al
     af5:	0f 85 72 ff ff ff    	jne    a6d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     afb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b00:	c9                   	leave  
     b01:	c3                   	ret    

00000b02 <strtok>:

char *
strtok(char *s, const char *delim)
{
     b02:	55                   	push   %ebp
     b03:	89 e5                	mov    %esp,%ebp
     b05:	53                   	push   %ebx
     b06:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     b09:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b0d:	75 08                	jne    b17 <strtok+0x15>
  s = lasts;
     b0f:	a1 64 1c 00 00       	mov    0x1c64,%eax
     b14:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     b17:	8b 45 08             	mov    0x8(%ebp),%eax
     b1a:	8d 50 01             	lea    0x1(%eax),%edx
     b1d:	89 55 08             	mov    %edx,0x8(%ebp)
     b20:	8a 00                	mov    (%eax),%al
     b22:	0f be d8             	movsbl %al,%ebx
     b25:	85 db                	test   %ebx,%ebx
     b27:	75 07                	jne    b30 <strtok+0x2e>
      return 0;
     b29:	b8 00 00 00 00       	mov    $0x0,%eax
     b2e:	eb 58                	jmp    b88 <strtok+0x86>
    } while (strchr(delim, ch));
     b30:	88 d8                	mov    %bl,%al
     b32:	0f be c0             	movsbl %al,%eax
     b35:	89 44 24 04          	mov    %eax,0x4(%esp)
     b39:	8b 45 0c             	mov    0xc(%ebp),%eax
     b3c:	89 04 24             	mov    %eax,(%esp)
     b3f:	e8 7e fe ff ff       	call   9c2 <strchr>
     b44:	85 c0                	test   %eax,%eax
     b46:	75 cf                	jne    b17 <strtok+0x15>
    --s;
     b48:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
     b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
     b52:	8b 45 08             	mov    0x8(%ebp),%eax
     b55:	89 04 24             	mov    %eax,(%esp)
     b58:	e8 31 00 00 00       	call   b8e <strcspn>
     b5d:	89 c2                	mov    %eax,%edx
     b5f:	8b 45 08             	mov    0x8(%ebp),%eax
     b62:	01 d0                	add    %edx,%eax
     b64:	a3 64 1c 00 00       	mov    %eax,0x1c64
    if (*lasts != 0)
     b69:	a1 64 1c 00 00       	mov    0x1c64,%eax
     b6e:	8a 00                	mov    (%eax),%al
     b70:	84 c0                	test   %al,%al
     b72:	74 11                	je     b85 <strtok+0x83>
  *lasts++ = 0;
     b74:	a1 64 1c 00 00       	mov    0x1c64,%eax
     b79:	8d 50 01             	lea    0x1(%eax),%edx
     b7c:	89 15 64 1c 00 00    	mov    %edx,0x1c64
     b82:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     b85:	8b 45 08             	mov    0x8(%ebp),%eax
}
     b88:	83 c4 14             	add    $0x14,%esp
     b8b:	5b                   	pop    %ebx
     b8c:	5d                   	pop    %ebp
     b8d:	c3                   	ret    

00000b8e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     b8e:	55                   	push   %ebp
     b8f:	89 e5                	mov    %esp,%ebp
     b91:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     b94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     b9b:	eb 26                	jmp    bc3 <strcspn+0x35>
        if(strchr(s2,*s1))
     b9d:	8b 45 08             	mov    0x8(%ebp),%eax
     ba0:	8a 00                	mov    (%eax),%al
     ba2:	0f be c0             	movsbl %al,%eax
     ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
     ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
     bac:	89 04 24             	mov    %eax,(%esp)
     baf:	e8 0e fe ff ff       	call   9c2 <strchr>
     bb4:	85 c0                	test   %eax,%eax
     bb6:	74 05                	je     bbd <strcspn+0x2f>
            return ret;
     bb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bbb:	eb 12                	jmp    bcf <strcspn+0x41>
        else
            s1++,ret++;
     bbd:	ff 45 08             	incl   0x8(%ebp)
     bc0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     bc3:	8b 45 08             	mov    0x8(%ebp),%eax
     bc6:	8a 00                	mov    (%eax),%al
     bc8:	84 c0                	test   %al,%al
     bca:	75 d1                	jne    b9d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     bcf:	c9                   	leave  
     bd0:	c3                   	ret    

00000bd1 <isspace>:

int
isspace(unsigned char c)
{
     bd1:	55                   	push   %ebp
     bd2:	89 e5                	mov    %esp,%ebp
     bd4:	83 ec 04             	sub    $0x4,%esp
     bd7:	8b 45 08             	mov    0x8(%ebp),%eax
     bda:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     bdd:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     be1:	74 1e                	je     c01 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     be3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     be7:	74 18                	je     c01 <isspace+0x30>
     be9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     bed:	74 12                	je     c01 <isspace+0x30>
     bef:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     bf3:	74 0c                	je     c01 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     bf5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     bf9:	74 06                	je     c01 <isspace+0x30>
     bfb:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     bff:	75 07                	jne    c08 <isspace+0x37>
     c01:	b8 01 00 00 00       	mov    $0x1,%eax
     c06:	eb 05                	jmp    c0d <isspace+0x3c>
     c08:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c0d:	c9                   	leave  
     c0e:	c3                   	ret    

00000c0f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     c0f:	55                   	push   %ebp
     c10:	89 e5                	mov    %esp,%ebp
     c12:	57                   	push   %edi
     c13:	56                   	push   %esi
     c14:	53                   	push   %ebx
     c15:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     c18:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     c1d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     c24:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     c27:	eb 01                	jmp    c2a <strtoul+0x1b>
  p += 1;
     c29:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     c2a:	8a 03                	mov    (%ebx),%al
     c2c:	0f b6 c0             	movzbl %al,%eax
     c2f:	89 04 24             	mov    %eax,(%esp)
     c32:	e8 9a ff ff ff       	call   bd1 <isspace>
     c37:	85 c0                	test   %eax,%eax
     c39:	75 ee                	jne    c29 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     c3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     c3f:	75 30                	jne    c71 <strtoul+0x62>
    {
  if (*p == '0') {
     c41:	8a 03                	mov    (%ebx),%al
     c43:	3c 30                	cmp    $0x30,%al
     c45:	75 21                	jne    c68 <strtoul+0x59>
      p += 1;
     c47:	43                   	inc    %ebx
      if (*p == 'x') {
     c48:	8a 03                	mov    (%ebx),%al
     c4a:	3c 78                	cmp    $0x78,%al
     c4c:	75 0a                	jne    c58 <strtoul+0x49>
    p += 1;
     c4e:	43                   	inc    %ebx
    base = 16;
     c4f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     c56:	eb 31                	jmp    c89 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     c58:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     c5f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     c66:	eb 21                	jmp    c89 <strtoul+0x7a>
      }
  }
  else base = 10;
     c68:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     c6f:	eb 18                	jmp    c89 <strtoul+0x7a>
    } else if (base == 16) {
     c71:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     c75:	75 12                	jne    c89 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     c77:	8a 03                	mov    (%ebx),%al
     c79:	3c 30                	cmp    $0x30,%al
     c7b:	75 0c                	jne    c89 <strtoul+0x7a>
     c7d:	8d 43 01             	lea    0x1(%ebx),%eax
     c80:	8a 00                	mov    (%eax),%al
     c82:	3c 78                	cmp    $0x78,%al
     c84:	75 03                	jne    c89 <strtoul+0x7a>
      p += 2;
     c86:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     c89:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     c8d:	75 29                	jne    cb8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     c8f:	8a 03                	mov    (%ebx),%al
     c91:	0f be c0             	movsbl %al,%eax
     c94:	83 e8 30             	sub    $0x30,%eax
     c97:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     c99:	83 fe 07             	cmp    $0x7,%esi
     c9c:	76 06                	jbe    ca4 <strtoul+0x95>
    break;
     c9e:	90                   	nop
     c9f:	e9 b6 00 00 00       	jmp    d5a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     ca4:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     cab:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     cae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     cb5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     cb6:	eb d7                	jmp    c8f <strtoul+0x80>
    } else if (base == 10) {
     cb8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     cbc:	75 2b                	jne    ce9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     cbe:	8a 03                	mov    (%ebx),%al
     cc0:	0f be c0             	movsbl %al,%eax
     cc3:	83 e8 30             	sub    $0x30,%eax
     cc6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     cc8:	83 fe 09             	cmp    $0x9,%esi
     ccb:	76 06                	jbe    cd3 <strtoul+0xc4>
    break;
     ccd:	90                   	nop
     cce:	e9 87 00 00 00       	jmp    d5a <strtoul+0x14b>
      }
      result = (10*result) + digit;
     cd3:	89 f8                	mov    %edi,%eax
     cd5:	c1 e0 02             	shl    $0x2,%eax
     cd8:	01 f8                	add    %edi,%eax
     cda:	01 c0                	add    %eax,%eax
     cdc:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     cdf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     ce6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     ce7:	eb d5                	jmp    cbe <strtoul+0xaf>
    } else if (base == 16) {
     ce9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     ced:	75 35                	jne    d24 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     cef:	8a 03                	mov    (%ebx),%al
     cf1:	0f be c0             	movsbl %al,%eax
     cf4:	83 e8 30             	sub    $0x30,%eax
     cf7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     cf9:	83 fe 4a             	cmp    $0x4a,%esi
     cfc:	76 02                	jbe    d00 <strtoul+0xf1>
    break;
     cfe:	eb 22                	jmp    d22 <strtoul+0x113>
      }
      digit = cvtIn[digit];
     d00:	8a 86 00 1c 00 00    	mov    0x1c00(%esi),%al
     d06:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     d09:	83 fe 0f             	cmp    $0xf,%esi
     d0c:	76 02                	jbe    d10 <strtoul+0x101>
    break;
     d0e:	eb 12                	jmp    d22 <strtoul+0x113>
      }
      result = (result << 4) + digit;
     d10:	89 f8                	mov    %edi,%eax
     d12:	c1 e0 04             	shl    $0x4,%eax
     d15:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     d18:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     d1f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     d20:	eb cd                	jmp    cef <strtoul+0xe0>
     d22:	eb 36                	jmp    d5a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     d24:	8a 03                	mov    (%ebx),%al
     d26:	0f be c0             	movsbl %al,%eax
     d29:	83 e8 30             	sub    $0x30,%eax
     d2c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     d2e:	83 fe 4a             	cmp    $0x4a,%esi
     d31:	76 02                	jbe    d35 <strtoul+0x126>
    break;
     d33:	eb 25                	jmp    d5a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     d35:	8a 86 00 1c 00 00    	mov    0x1c00(%esi),%al
     d3b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     d3e:	8b 45 10             	mov    0x10(%ebp),%eax
     d41:	39 f0                	cmp    %esi,%eax
     d43:	77 02                	ja     d47 <strtoul+0x138>
    break;
     d45:	eb 13                	jmp    d5a <strtoul+0x14b>
      }
      result = result*base + digit;
     d47:	8b 45 10             	mov    0x10(%ebp),%eax
     d4a:	0f af c7             	imul   %edi,%eax
     d4d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     d50:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     d57:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     d58:	eb ca                	jmp    d24 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d5e:	75 03                	jne    d63 <strtoul+0x154>
  p = string;
     d60:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     d63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     d67:	74 05                	je     d6e <strtoul+0x15f>
  *endPtr = p;
     d69:	8b 45 0c             	mov    0xc(%ebp),%eax
     d6c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     d6e:	89 f8                	mov    %edi,%eax
}
     d70:	83 c4 14             	add    $0x14,%esp
     d73:	5b                   	pop    %ebx
     d74:	5e                   	pop    %esi
     d75:	5f                   	pop    %edi
     d76:	5d                   	pop    %ebp
     d77:	c3                   	ret    

00000d78 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     d78:	55                   	push   %ebp
     d79:	89 e5                	mov    %esp,%ebp
     d7b:	53                   	push   %ebx
     d7c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     d7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     d82:	eb 01                	jmp    d85 <strtol+0xd>
      p += 1;
     d84:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     d85:	8a 03                	mov    (%ebx),%al
     d87:	0f b6 c0             	movzbl %al,%eax
     d8a:	89 04 24             	mov    %eax,(%esp)
     d8d:	e8 3f fe ff ff       	call   bd1 <isspace>
     d92:	85 c0                	test   %eax,%eax
     d94:	75 ee                	jne    d84 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     d96:	8a 03                	mov    (%ebx),%al
     d98:	3c 2d                	cmp    $0x2d,%al
     d9a:	75 1e                	jne    dba <strtol+0x42>
  p += 1;
     d9c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     d9d:	8b 45 10             	mov    0x10(%ebp),%eax
     da0:	89 44 24 08          	mov    %eax,0x8(%esp)
     da4:	8b 45 0c             	mov    0xc(%ebp),%eax
     da7:	89 44 24 04          	mov    %eax,0x4(%esp)
     dab:	89 1c 24             	mov    %ebx,(%esp)
     dae:	e8 5c fe ff ff       	call   c0f <strtoul>
     db3:	f7 d8                	neg    %eax
     db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
     db8:	eb 20                	jmp    dda <strtol+0x62>
    } else {
  if (*p == '+') {
     dba:	8a 03                	mov    (%ebx),%al
     dbc:	3c 2b                	cmp    $0x2b,%al
     dbe:	75 01                	jne    dc1 <strtol+0x49>
      p += 1;
     dc0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     dc1:	8b 45 10             	mov    0x10(%ebp),%eax
     dc4:	89 44 24 08          	mov    %eax,0x8(%esp)
     dc8:	8b 45 0c             	mov    0xc(%ebp),%eax
     dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
     dcf:	89 1c 24             	mov    %ebx,(%esp)
     dd2:	e8 38 fe ff ff       	call   c0f <strtoul>
     dd7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     dda:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     dde:	75 17                	jne    df7 <strtol+0x7f>
     de0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     de4:	74 11                	je     df7 <strtol+0x7f>
     de6:	8b 45 0c             	mov    0xc(%ebp),%eax
     de9:	8b 00                	mov    (%eax),%eax
     deb:	39 d8                	cmp    %ebx,%eax
     ded:	75 08                	jne    df7 <strtol+0x7f>
  *endPtr = string;
     def:	8b 45 0c             	mov    0xc(%ebp),%eax
     df2:	8b 55 08             	mov    0x8(%ebp),%edx
     df5:	89 10                	mov    %edx,(%eax)
    }
    return result;
     df7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     dfa:	83 c4 1c             	add    $0x1c,%esp
     dfd:	5b                   	pop    %ebx
     dfe:	5d                   	pop    %ebp
     dff:	c3                   	ret    

00000e00 <gets>:

char*
gets(char *buf, int max)
{
     e00:	55                   	push   %ebp
     e01:	89 e5                	mov    %esp,%ebp
     e03:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e0d:	eb 49                	jmp    e58 <gets+0x58>
    cc = read(0, &c, 1);
     e0f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e16:	00 
     e17:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e1a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e25:	e8 3e 01 00 00       	call   f68 <read>
     e2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e2d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e31:	7f 02                	jg     e35 <gets+0x35>
      break;
     e33:	eb 2c                	jmp    e61 <gets+0x61>
    buf[i++] = c;
     e35:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e38:	8d 50 01             	lea    0x1(%eax),%edx
     e3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e3e:	89 c2                	mov    %eax,%edx
     e40:	8b 45 08             	mov    0x8(%ebp),%eax
     e43:	01 c2                	add    %eax,%edx
     e45:	8a 45 ef             	mov    -0x11(%ebp),%al
     e48:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e4a:	8a 45 ef             	mov    -0x11(%ebp),%al
     e4d:	3c 0a                	cmp    $0xa,%al
     e4f:	74 10                	je     e61 <gets+0x61>
     e51:	8a 45 ef             	mov    -0x11(%ebp),%al
     e54:	3c 0d                	cmp    $0xd,%al
     e56:	74 09                	je     e61 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e5b:	40                   	inc    %eax
     e5c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e5f:	7c ae                	jl     e0f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e61:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e64:	8b 45 08             	mov    0x8(%ebp),%eax
     e67:	01 d0                	add    %edx,%eax
     e69:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e6c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e6f:	c9                   	leave  
     e70:	c3                   	ret    

00000e71 <stat>:

int
stat(char *n, struct stat *st)
{
     e71:	55                   	push   %ebp
     e72:	89 e5                	mov    %esp,%ebp
     e74:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e77:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e7e:	00 
     e7f:	8b 45 08             	mov    0x8(%ebp),%eax
     e82:	89 04 24             	mov    %eax,(%esp)
     e85:	e8 06 01 00 00       	call   f90 <open>
     e8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e91:	79 07                	jns    e9a <stat+0x29>
    return -1;
     e93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e98:	eb 23                	jmp    ebd <stat+0x4c>
  r = fstat(fd, st);
     e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
     ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ea4:	89 04 24             	mov    %eax,(%esp)
     ea7:	e8 fc 00 00 00       	call   fa8 <fstat>
     eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eb2:	89 04 24             	mov    %eax,(%esp)
     eb5:	e8 be 00 00 00       	call   f78 <close>
  return r;
     eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ebd:	c9                   	leave  
     ebe:	c3                   	ret    

00000ebf <atoi>:

int
atoi(const char *s)
{
     ebf:	55                   	push   %ebp
     ec0:	89 e5                	mov    %esp,%ebp
     ec2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ec5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ecc:	eb 24                	jmp    ef2 <atoi+0x33>
    n = n*10 + *s++ - '0';
     ece:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ed1:	89 d0                	mov    %edx,%eax
     ed3:	c1 e0 02             	shl    $0x2,%eax
     ed6:	01 d0                	add    %edx,%eax
     ed8:	01 c0                	add    %eax,%eax
     eda:	89 c1                	mov    %eax,%ecx
     edc:	8b 45 08             	mov    0x8(%ebp),%eax
     edf:	8d 50 01             	lea    0x1(%eax),%edx
     ee2:	89 55 08             	mov    %edx,0x8(%ebp)
     ee5:	8a 00                	mov    (%eax),%al
     ee7:	0f be c0             	movsbl %al,%eax
     eea:	01 c8                	add    %ecx,%eax
     eec:	83 e8 30             	sub    $0x30,%eax
     eef:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ef2:	8b 45 08             	mov    0x8(%ebp),%eax
     ef5:	8a 00                	mov    (%eax),%al
     ef7:	3c 2f                	cmp    $0x2f,%al
     ef9:	7e 09                	jle    f04 <atoi+0x45>
     efb:	8b 45 08             	mov    0x8(%ebp),%eax
     efe:	8a 00                	mov    (%eax),%al
     f00:	3c 39                	cmp    $0x39,%al
     f02:	7e ca                	jle    ece <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f04:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f07:	c9                   	leave  
     f08:	c3                   	ret    

00000f09 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f09:	55                   	push   %ebp
     f0a:	89 e5                	mov    %esp,%ebp
     f0c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     f0f:	8b 45 08             	mov    0x8(%ebp),%eax
     f12:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f15:	8b 45 0c             	mov    0xc(%ebp),%eax
     f18:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f1b:	eb 16                	jmp    f33 <memmove+0x2a>
    *dst++ = *src++;
     f1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f20:	8d 50 01             	lea    0x1(%eax),%edx
     f23:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f26:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f29:	8d 4a 01             	lea    0x1(%edx),%ecx
     f2c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f2f:	8a 12                	mov    (%edx),%dl
     f31:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f33:	8b 45 10             	mov    0x10(%ebp),%eax
     f36:	8d 50 ff             	lea    -0x1(%eax),%edx
     f39:	89 55 10             	mov    %edx,0x10(%ebp)
     f3c:	85 c0                	test   %eax,%eax
     f3e:	7f dd                	jg     f1d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f40:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f43:	c9                   	leave  
     f44:	c3                   	ret    
     f45:	90                   	nop
     f46:	90                   	nop
     f47:	90                   	nop

00000f48 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f48:	b8 01 00 00 00       	mov    $0x1,%eax
     f4d:	cd 40                	int    $0x40
     f4f:	c3                   	ret    

00000f50 <exit>:
SYSCALL(exit)
     f50:	b8 02 00 00 00       	mov    $0x2,%eax
     f55:	cd 40                	int    $0x40
     f57:	c3                   	ret    

00000f58 <wait>:
SYSCALL(wait)
     f58:	b8 03 00 00 00       	mov    $0x3,%eax
     f5d:	cd 40                	int    $0x40
     f5f:	c3                   	ret    

00000f60 <pipe>:
SYSCALL(pipe)
     f60:	b8 04 00 00 00       	mov    $0x4,%eax
     f65:	cd 40                	int    $0x40
     f67:	c3                   	ret    

00000f68 <read>:
SYSCALL(read)
     f68:	b8 05 00 00 00       	mov    $0x5,%eax
     f6d:	cd 40                	int    $0x40
     f6f:	c3                   	ret    

00000f70 <write>:
SYSCALL(write)
     f70:	b8 10 00 00 00       	mov    $0x10,%eax
     f75:	cd 40                	int    $0x40
     f77:	c3                   	ret    

00000f78 <close>:
SYSCALL(close)
     f78:	b8 15 00 00 00       	mov    $0x15,%eax
     f7d:	cd 40                	int    $0x40
     f7f:	c3                   	ret    

00000f80 <kill>:
SYSCALL(kill)
     f80:	b8 06 00 00 00       	mov    $0x6,%eax
     f85:	cd 40                	int    $0x40
     f87:	c3                   	ret    

00000f88 <exec>:
SYSCALL(exec)
     f88:	b8 07 00 00 00       	mov    $0x7,%eax
     f8d:	cd 40                	int    $0x40
     f8f:	c3                   	ret    

00000f90 <open>:
SYSCALL(open)
     f90:	b8 0f 00 00 00       	mov    $0xf,%eax
     f95:	cd 40                	int    $0x40
     f97:	c3                   	ret    

00000f98 <mknod>:
SYSCALL(mknod)
     f98:	b8 11 00 00 00       	mov    $0x11,%eax
     f9d:	cd 40                	int    $0x40
     f9f:	c3                   	ret    

00000fa0 <unlink>:
SYSCALL(unlink)
     fa0:	b8 12 00 00 00       	mov    $0x12,%eax
     fa5:	cd 40                	int    $0x40
     fa7:	c3                   	ret    

00000fa8 <fstat>:
SYSCALL(fstat)
     fa8:	b8 08 00 00 00       	mov    $0x8,%eax
     fad:	cd 40                	int    $0x40
     faf:	c3                   	ret    

00000fb0 <link>:
SYSCALL(link)
     fb0:	b8 13 00 00 00       	mov    $0x13,%eax
     fb5:	cd 40                	int    $0x40
     fb7:	c3                   	ret    

00000fb8 <mkdir>:
SYSCALL(mkdir)
     fb8:	b8 14 00 00 00       	mov    $0x14,%eax
     fbd:	cd 40                	int    $0x40
     fbf:	c3                   	ret    

00000fc0 <chdir>:
SYSCALL(chdir)
     fc0:	b8 09 00 00 00       	mov    $0x9,%eax
     fc5:	cd 40                	int    $0x40
     fc7:	c3                   	ret    

00000fc8 <dup>:
SYSCALL(dup)
     fc8:	b8 0a 00 00 00       	mov    $0xa,%eax
     fcd:	cd 40                	int    $0x40
     fcf:	c3                   	ret    

00000fd0 <getpid>:
SYSCALL(getpid)
     fd0:	b8 0b 00 00 00       	mov    $0xb,%eax
     fd5:	cd 40                	int    $0x40
     fd7:	c3                   	ret    

00000fd8 <sbrk>:
SYSCALL(sbrk)
     fd8:	b8 0c 00 00 00       	mov    $0xc,%eax
     fdd:	cd 40                	int    $0x40
     fdf:	c3                   	ret    

00000fe0 <sleep>:
SYSCALL(sleep)
     fe0:	b8 0d 00 00 00       	mov    $0xd,%eax
     fe5:	cd 40                	int    $0x40
     fe7:	c3                   	ret    

00000fe8 <uptime>:
SYSCALL(uptime)
     fe8:	b8 0e 00 00 00       	mov    $0xe,%eax
     fed:	cd 40                	int    $0x40
     fef:	c3                   	ret    

00000ff0 <getname>:
SYSCALL(getname)
     ff0:	b8 16 00 00 00       	mov    $0x16,%eax
     ff5:	cd 40                	int    $0x40
     ff7:	c3                   	ret    

00000ff8 <setname>:
SYSCALL(setname)
     ff8:	b8 17 00 00 00       	mov    $0x17,%eax
     ffd:	cd 40                	int    $0x40
     fff:	c3                   	ret    

00001000 <getmaxproc>:
SYSCALL(getmaxproc)
    1000:	b8 18 00 00 00       	mov    $0x18,%eax
    1005:	cd 40                	int    $0x40
    1007:	c3                   	ret    

00001008 <setmaxproc>:
SYSCALL(setmaxproc)
    1008:	b8 19 00 00 00       	mov    $0x19,%eax
    100d:	cd 40                	int    $0x40
    100f:	c3                   	ret    

00001010 <getmaxmem>:
SYSCALL(getmaxmem)
    1010:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1015:	cd 40                	int    $0x40
    1017:	c3                   	ret    

00001018 <setmaxmem>:
SYSCALL(setmaxmem)
    1018:	b8 1b 00 00 00       	mov    $0x1b,%eax
    101d:	cd 40                	int    $0x40
    101f:	c3                   	ret    

00001020 <getmaxdisk>:
SYSCALL(getmaxdisk)
    1020:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1025:	cd 40                	int    $0x40
    1027:	c3                   	ret    

00001028 <setmaxdisk>:
SYSCALL(setmaxdisk)
    1028:	b8 1d 00 00 00       	mov    $0x1d,%eax
    102d:	cd 40                	int    $0x40
    102f:	c3                   	ret    

00001030 <getusedmem>:
SYSCALL(getusedmem)
    1030:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1035:	cd 40                	int    $0x40
    1037:	c3                   	ret    

00001038 <setusedmem>:
SYSCALL(setusedmem)
    1038:	b8 1f 00 00 00       	mov    $0x1f,%eax
    103d:	cd 40                	int    $0x40
    103f:	c3                   	ret    

00001040 <getuseddisk>:
SYSCALL(getuseddisk)
    1040:	b8 20 00 00 00       	mov    $0x20,%eax
    1045:	cd 40                	int    $0x40
    1047:	c3                   	ret    

00001048 <setuseddisk>:
SYSCALL(setuseddisk)
    1048:	b8 21 00 00 00       	mov    $0x21,%eax
    104d:	cd 40                	int    $0x40
    104f:	c3                   	ret    

00001050 <setvc>:
SYSCALL(setvc)
    1050:	b8 22 00 00 00       	mov    $0x22,%eax
    1055:	cd 40                	int    $0x40
    1057:	c3                   	ret    

00001058 <setactivefs>:
SYSCALL(setactivefs)
    1058:	b8 24 00 00 00       	mov    $0x24,%eax
    105d:	cd 40                	int    $0x40
    105f:	c3                   	ret    

00001060 <getactivefs>:
SYSCALL(getactivefs)
    1060:	b8 25 00 00 00       	mov    $0x25,%eax
    1065:	cd 40                	int    $0x40
    1067:	c3                   	ret    

00001068 <getvcfs>:
SYSCALL(getvcfs)
    1068:	b8 23 00 00 00       	mov    $0x23,%eax
    106d:	cd 40                	int    $0x40
    106f:	c3                   	ret    

00001070 <getcwd>:
SYSCALL(getcwd)
    1070:	b8 26 00 00 00       	mov    $0x26,%eax
    1075:	cd 40                	int    $0x40
    1077:	c3                   	ret    

00001078 <tostring>:
SYSCALL(tostring)
    1078:	b8 27 00 00 00       	mov    $0x27,%eax
    107d:	cd 40                	int    $0x40
    107f:	c3                   	ret    

00001080 <getactivefsindex>:
SYSCALL(getactivefsindex)
    1080:	b8 28 00 00 00       	mov    $0x28,%eax
    1085:	cd 40                	int    $0x40
    1087:	c3                   	ret    

00001088 <setatroot>:
SYSCALL(setatroot)
    1088:	b8 2a 00 00 00       	mov    $0x2a,%eax
    108d:	cd 40                	int    $0x40
    108f:	c3                   	ret    

00001090 <getatroot>:
SYSCALL(getatroot)
    1090:	b8 29 00 00 00       	mov    $0x29,%eax
    1095:	cd 40                	int    $0x40
    1097:	c3                   	ret    

00001098 <getpath>:
SYSCALL(getpath)
    1098:	b8 2b 00 00 00       	mov    $0x2b,%eax
    109d:	cd 40                	int    $0x40
    109f:	c3                   	ret    

000010a0 <setpath>:
SYSCALL(setpath)
    10a0:	b8 2c 00 00 00       	mov    $0x2c,%eax
    10a5:	cd 40                	int    $0x40
    10a7:	c3                   	ret    

000010a8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    10a8:	55                   	push   %ebp
    10a9:	89 e5                	mov    %esp,%ebp
    10ab:	83 ec 18             	sub    $0x18,%esp
    10ae:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    10b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    10bb:	00 
    10bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
    10bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c3:	8b 45 08             	mov    0x8(%ebp),%eax
    10c6:	89 04 24             	mov    %eax,(%esp)
    10c9:	e8 a2 fe ff ff       	call   f70 <write>
}
    10ce:	c9                   	leave  
    10cf:	c3                   	ret    

000010d0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    10d0:	55                   	push   %ebp
    10d1:	89 e5                	mov    %esp,%ebp
    10d3:	56                   	push   %esi
    10d4:	53                   	push   %ebx
    10d5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    10d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    10df:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    10e3:	74 17                	je     10fc <printint+0x2c>
    10e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    10e9:	79 11                	jns    10fc <printint+0x2c>
    neg = 1;
    10eb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    10f2:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f5:	f7 d8                	neg    %eax
    10f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10fa:	eb 06                	jmp    1102 <printint+0x32>
  } else {
    x = xx;
    10fc:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    1102:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1109:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    110c:	8d 41 01             	lea    0x1(%ecx),%eax
    110f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1112:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1115:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1118:	ba 00 00 00 00       	mov    $0x0,%edx
    111d:	f7 f3                	div    %ebx
    111f:	89 d0                	mov    %edx,%eax
    1121:	8a 80 4c 1c 00 00    	mov    0x1c4c(%eax),%al
    1127:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    112b:	8b 75 10             	mov    0x10(%ebp),%esi
    112e:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1131:	ba 00 00 00 00       	mov    $0x0,%edx
    1136:	f7 f6                	div    %esi
    1138:	89 45 ec             	mov    %eax,-0x14(%ebp)
    113b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    113f:	75 c8                	jne    1109 <printint+0x39>
  if(neg)
    1141:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1145:	74 10                	je     1157 <printint+0x87>
    buf[i++] = '-';
    1147:	8b 45 f4             	mov    -0xc(%ebp),%eax
    114a:	8d 50 01             	lea    0x1(%eax),%edx
    114d:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1150:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1155:	eb 1e                	jmp    1175 <printint+0xa5>
    1157:	eb 1c                	jmp    1175 <printint+0xa5>
    putc(fd, buf[i]);
    1159:	8d 55 dc             	lea    -0x24(%ebp),%edx
    115c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    115f:	01 d0                	add    %edx,%eax
    1161:	8a 00                	mov    (%eax),%al
    1163:	0f be c0             	movsbl %al,%eax
    1166:	89 44 24 04          	mov    %eax,0x4(%esp)
    116a:	8b 45 08             	mov    0x8(%ebp),%eax
    116d:	89 04 24             	mov    %eax,(%esp)
    1170:	e8 33 ff ff ff       	call   10a8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1175:	ff 4d f4             	decl   -0xc(%ebp)
    1178:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    117c:	79 db                	jns    1159 <printint+0x89>
    putc(fd, buf[i]);
}
    117e:	83 c4 30             	add    $0x30,%esp
    1181:	5b                   	pop    %ebx
    1182:	5e                   	pop    %esi
    1183:	5d                   	pop    %ebp
    1184:	c3                   	ret    

00001185 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1185:	55                   	push   %ebp
    1186:	89 e5                	mov    %esp,%ebp
    1188:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    118b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1192:	8d 45 0c             	lea    0xc(%ebp),%eax
    1195:	83 c0 04             	add    $0x4,%eax
    1198:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    119b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11a2:	e9 77 01 00 00       	jmp    131e <printf+0x199>
    c = fmt[i] & 0xff;
    11a7:	8b 55 0c             	mov    0xc(%ebp),%edx
    11aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ad:	01 d0                	add    %edx,%eax
    11af:	8a 00                	mov    (%eax),%al
    11b1:	0f be c0             	movsbl %al,%eax
    11b4:	25 ff 00 00 00       	and    $0xff,%eax
    11b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    11bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11c0:	75 2c                	jne    11ee <printf+0x69>
      if(c == '%'){
    11c2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    11c6:	75 0c                	jne    11d4 <printf+0x4f>
        state = '%';
    11c8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    11cf:	e9 47 01 00 00       	jmp    131b <printf+0x196>
      } else {
        putc(fd, c);
    11d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11d7:	0f be c0             	movsbl %al,%eax
    11da:	89 44 24 04          	mov    %eax,0x4(%esp)
    11de:	8b 45 08             	mov    0x8(%ebp),%eax
    11e1:	89 04 24             	mov    %eax,(%esp)
    11e4:	e8 bf fe ff ff       	call   10a8 <putc>
    11e9:	e9 2d 01 00 00       	jmp    131b <printf+0x196>
      }
    } else if(state == '%'){
    11ee:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    11f2:	0f 85 23 01 00 00    	jne    131b <printf+0x196>
      if(c == 'd'){
    11f8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    11fc:	75 2d                	jne    122b <printf+0xa6>
        printint(fd, *ap, 10, 1);
    11fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1201:	8b 00                	mov    (%eax),%eax
    1203:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    120a:	00 
    120b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1212:	00 
    1213:	89 44 24 04          	mov    %eax,0x4(%esp)
    1217:	8b 45 08             	mov    0x8(%ebp),%eax
    121a:	89 04 24             	mov    %eax,(%esp)
    121d:	e8 ae fe ff ff       	call   10d0 <printint>
        ap++;
    1222:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1226:	e9 e9 00 00 00       	jmp    1314 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    122b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    122f:	74 06                	je     1237 <printf+0xb2>
    1231:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1235:	75 2d                	jne    1264 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    1237:	8b 45 e8             	mov    -0x18(%ebp),%eax
    123a:	8b 00                	mov    (%eax),%eax
    123c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1243:	00 
    1244:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    124b:	00 
    124c:	89 44 24 04          	mov    %eax,0x4(%esp)
    1250:	8b 45 08             	mov    0x8(%ebp),%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 75 fe ff ff       	call   10d0 <printint>
        ap++;
    125b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    125f:	e9 b0 00 00 00       	jmp    1314 <printf+0x18f>
      } else if(c == 's'){
    1264:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1268:	75 42                	jne    12ac <printf+0x127>
        s = (char*)*ap;
    126a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    126d:	8b 00                	mov    (%eax),%eax
    126f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1272:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1276:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    127a:	75 09                	jne    1285 <printf+0x100>
          s = "(null)";
    127c:	c7 45 f4 99 17 00 00 	movl   $0x1799,-0xc(%ebp)
        while(*s != 0){
    1283:	eb 1c                	jmp    12a1 <printf+0x11c>
    1285:	eb 1a                	jmp    12a1 <printf+0x11c>
          putc(fd, *s);
    1287:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128a:	8a 00                	mov    (%eax),%al
    128c:	0f be c0             	movsbl %al,%eax
    128f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1293:	8b 45 08             	mov    0x8(%ebp),%eax
    1296:	89 04 24             	mov    %eax,(%esp)
    1299:	e8 0a fe ff ff       	call   10a8 <putc>
          s++;
    129e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    12a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a4:	8a 00                	mov    (%eax),%al
    12a6:	84 c0                	test   %al,%al
    12a8:	75 dd                	jne    1287 <printf+0x102>
    12aa:	eb 68                	jmp    1314 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    12ac:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    12b0:	75 1d                	jne    12cf <printf+0x14a>
        putc(fd, *ap);
    12b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    12b5:	8b 00                	mov    (%eax),%eax
    12b7:	0f be c0             	movsbl %al,%eax
    12ba:	89 44 24 04          	mov    %eax,0x4(%esp)
    12be:	8b 45 08             	mov    0x8(%ebp),%eax
    12c1:	89 04 24             	mov    %eax,(%esp)
    12c4:	e8 df fd ff ff       	call   10a8 <putc>
        ap++;
    12c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    12cd:	eb 45                	jmp    1314 <printf+0x18f>
      } else if(c == '%'){
    12cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    12d3:	75 17                	jne    12ec <printf+0x167>
        putc(fd, c);
    12d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12d8:	0f be c0             	movsbl %al,%eax
    12db:	89 44 24 04          	mov    %eax,0x4(%esp)
    12df:	8b 45 08             	mov    0x8(%ebp),%eax
    12e2:	89 04 24             	mov    %eax,(%esp)
    12e5:	e8 be fd ff ff       	call   10a8 <putc>
    12ea:	eb 28                	jmp    1314 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    12ec:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    12f3:	00 
    12f4:	8b 45 08             	mov    0x8(%ebp),%eax
    12f7:	89 04 24             	mov    %eax,(%esp)
    12fa:	e8 a9 fd ff ff       	call   10a8 <putc>
        putc(fd, c);
    12ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1302:	0f be c0             	movsbl %al,%eax
    1305:	89 44 24 04          	mov    %eax,0x4(%esp)
    1309:	8b 45 08             	mov    0x8(%ebp),%eax
    130c:	89 04 24             	mov    %eax,(%esp)
    130f:	e8 94 fd ff ff       	call   10a8 <putc>
      }
      state = 0;
    1314:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    131b:	ff 45 f0             	incl   -0x10(%ebp)
    131e:	8b 55 0c             	mov    0xc(%ebp),%edx
    1321:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1324:	01 d0                	add    %edx,%eax
    1326:	8a 00                	mov    (%eax),%al
    1328:	84 c0                	test   %al,%al
    132a:	0f 85 77 fe ff ff    	jne    11a7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1330:	c9                   	leave  
    1331:	c3                   	ret    
    1332:	90                   	nop
    1333:	90                   	nop

00001334 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1334:	55                   	push   %ebp
    1335:	89 e5                	mov    %esp,%ebp
    1337:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    133a:	8b 45 08             	mov    0x8(%ebp),%eax
    133d:	83 e8 08             	sub    $0x8,%eax
    1340:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1343:	a1 70 1c 00 00       	mov    0x1c70,%eax
    1348:	89 45 fc             	mov    %eax,-0x4(%ebp)
    134b:	eb 24                	jmp    1371 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    134d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1350:	8b 00                	mov    (%eax),%eax
    1352:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1355:	77 12                	ja     1369 <free+0x35>
    1357:	8b 45 f8             	mov    -0x8(%ebp),%eax
    135a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    135d:	77 24                	ja     1383 <free+0x4f>
    135f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1362:	8b 00                	mov    (%eax),%eax
    1364:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1367:	77 1a                	ja     1383 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1369:	8b 45 fc             	mov    -0x4(%ebp),%eax
    136c:	8b 00                	mov    (%eax),%eax
    136e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1371:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1374:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1377:	76 d4                	jbe    134d <free+0x19>
    1379:	8b 45 fc             	mov    -0x4(%ebp),%eax
    137c:	8b 00                	mov    (%eax),%eax
    137e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1381:	76 ca                	jbe    134d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1383:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1386:	8b 40 04             	mov    0x4(%eax),%eax
    1389:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1390:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1393:	01 c2                	add    %eax,%edx
    1395:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1398:	8b 00                	mov    (%eax),%eax
    139a:	39 c2                	cmp    %eax,%edx
    139c:	75 24                	jne    13c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    139e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13a1:	8b 50 04             	mov    0x4(%eax),%edx
    13a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13a7:	8b 00                	mov    (%eax),%eax
    13a9:	8b 40 04             	mov    0x4(%eax),%eax
    13ac:	01 c2                	add    %eax,%edx
    13ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    13b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13b7:	8b 00                	mov    (%eax),%eax
    13b9:	8b 10                	mov    (%eax),%edx
    13bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13be:	89 10                	mov    %edx,(%eax)
    13c0:	eb 0a                	jmp    13cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    13c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13c5:	8b 10                	mov    (%eax),%edx
    13c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    13cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13cf:	8b 40 04             	mov    0x4(%eax),%eax
    13d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    13d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13dc:	01 d0                	add    %edx,%eax
    13de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    13e1:	75 20                	jne    1403 <free+0xcf>
    p->s.size += bp->s.size;
    13e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13e6:	8b 50 04             	mov    0x4(%eax),%edx
    13e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13ec:	8b 40 04             	mov    0x4(%eax),%eax
    13ef:	01 c2                	add    %eax,%edx
    13f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    13f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13fa:	8b 10                	mov    (%eax),%edx
    13fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13ff:	89 10                	mov    %edx,(%eax)
    1401:	eb 08                	jmp    140b <free+0xd7>
  } else
    p->s.ptr = bp;
    1403:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1406:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1409:	89 10                	mov    %edx,(%eax)
  freep = p;
    140b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    140e:	a3 70 1c 00 00       	mov    %eax,0x1c70
}
    1413:	c9                   	leave  
    1414:	c3                   	ret    

00001415 <morecore>:

static Header*
morecore(uint nu)
{
    1415:	55                   	push   %ebp
    1416:	89 e5                	mov    %esp,%ebp
    1418:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    141b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1422:	77 07                	ja     142b <morecore+0x16>
    nu = 4096;
    1424:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    142b:	8b 45 08             	mov    0x8(%ebp),%eax
    142e:	c1 e0 03             	shl    $0x3,%eax
    1431:	89 04 24             	mov    %eax,(%esp)
    1434:	e8 9f fb ff ff       	call   fd8 <sbrk>
    1439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    143c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1440:	75 07                	jne    1449 <morecore+0x34>
    return 0;
    1442:	b8 00 00 00 00       	mov    $0x0,%eax
    1447:	eb 22                	jmp    146b <morecore+0x56>
  hp = (Header*)p;
    1449:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1452:	8b 55 08             	mov    0x8(%ebp),%edx
    1455:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1458:	8b 45 f0             	mov    -0x10(%ebp),%eax
    145b:	83 c0 08             	add    $0x8,%eax
    145e:	89 04 24             	mov    %eax,(%esp)
    1461:	e8 ce fe ff ff       	call   1334 <free>
  return freep;
    1466:	a1 70 1c 00 00       	mov    0x1c70,%eax
}
    146b:	c9                   	leave  
    146c:	c3                   	ret    

0000146d <malloc>:

void*
malloc(uint nbytes)
{
    146d:	55                   	push   %ebp
    146e:	89 e5                	mov    %esp,%ebp
    1470:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1473:	8b 45 08             	mov    0x8(%ebp),%eax
    1476:	83 c0 07             	add    $0x7,%eax
    1479:	c1 e8 03             	shr    $0x3,%eax
    147c:	40                   	inc    %eax
    147d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1480:	a1 70 1c 00 00       	mov    0x1c70,%eax
    1485:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    148c:	75 23                	jne    14b1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    148e:	c7 45 f0 68 1c 00 00 	movl   $0x1c68,-0x10(%ebp)
    1495:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1498:	a3 70 1c 00 00       	mov    %eax,0x1c70
    149d:	a1 70 1c 00 00       	mov    0x1c70,%eax
    14a2:	a3 68 1c 00 00       	mov    %eax,0x1c68
    base.s.size = 0;
    14a7:	c7 05 6c 1c 00 00 00 	movl   $0x0,0x1c6c
    14ae:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14b4:	8b 00                	mov    (%eax),%eax
    14b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    14b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bc:	8b 40 04             	mov    0x4(%eax),%eax
    14bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    14c2:	72 4d                	jb     1511 <malloc+0xa4>
      if(p->s.size == nunits)
    14c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c7:	8b 40 04             	mov    0x4(%eax),%eax
    14ca:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    14cd:	75 0c                	jne    14db <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    14cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d2:	8b 10                	mov    (%eax),%edx
    14d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14d7:	89 10                	mov    %edx,(%eax)
    14d9:	eb 26                	jmp    1501 <malloc+0x94>
      else {
        p->s.size -= nunits;
    14db:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14de:	8b 40 04             	mov    0x4(%eax),%eax
    14e1:	2b 45 ec             	sub    -0x14(%ebp),%eax
    14e4:	89 c2                	mov    %eax,%edx
    14e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    14ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ef:	8b 40 04             	mov    0x4(%eax),%eax
    14f2:	c1 e0 03             	shl    $0x3,%eax
    14f5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    14f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
    14fe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1501:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1504:	a3 70 1c 00 00       	mov    %eax,0x1c70
      return (void*)(p + 1);
    1509:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150c:	83 c0 08             	add    $0x8,%eax
    150f:	eb 38                	jmp    1549 <malloc+0xdc>
    }
    if(p == freep)
    1511:	a1 70 1c 00 00       	mov    0x1c70,%eax
    1516:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1519:	75 1b                	jne    1536 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    151b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    151e:	89 04 24             	mov    %eax,(%esp)
    1521:	e8 ef fe ff ff       	call   1415 <morecore>
    1526:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1529:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    152d:	75 07                	jne    1536 <malloc+0xc9>
        return 0;
    152f:	b8 00 00 00 00       	mov    $0x0,%eax
    1534:	eb 13                	jmp    1549 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1536:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1539:	89 45 f0             	mov    %eax,-0x10(%ebp)
    153c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    153f:	8b 00                	mov    (%eax),%eax
    1541:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1544:	e9 70 ff ff ff       	jmp    14b9 <malloc+0x4c>
}
    1549:	c9                   	leave  
    154a:	c3                   	ret    
