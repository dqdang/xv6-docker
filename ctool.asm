
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
      f4:	c7 44 24 04 98 15 00 	movl   $0x1598,0x4(%esp)
      fb:	00 
      fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     103:	e8 c9 10 00 00       	call   11d1 <printf>
  }
  if(mode == 1){ // create
     108:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     10c:	75 14                	jne    122 <print_usage+0x3a>
    printf(1, "Usage: ctool create <container> <max proc> <max mem> <max disk> <exec1> <exec2> ...\n");
     10e:	c7 44 24 04 b4 15 00 	movl   $0x15b4,0x4(%esp)
     115:	00 
     116:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     11d:	e8 af 10 00 00       	call   11d1 <printf>
  }
  if(mode == 2){ // create with container created
     122:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
     126:	75 14                	jne    13c <print_usage+0x54>
    printf(1, "Container taken. Failed to create, exiting...\n");
     128:	c7 44 24 04 0c 16 00 	movl   $0x160c,0x4(%esp)
     12f:	00 
     130:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     137:	e8 95 10 00 00       	call   11d1 <printf>
  }
  if(mode == 3){ // start
     13c:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
     140:	75 14                	jne    156 <print_usage+0x6e>
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
     142:	c7 44 24 04 3c 16 00 	movl   $0x163c,0x4(%esp)
     149:	00 
     14a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     151:	e8 7b 10 00 00       	call   11d1 <printf>
  }
  if(mode == 4){ // delete
     156:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     15a:	75 14                	jne    170 <print_usage+0x88>
    printf(1, "Usage: ctool delete <container>\n");
     15c:	c7 44 24 04 70 16 00 	movl   $0x1670,0x4(%esp)
     163:	00 
     164:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     16b:	e8 61 10 00 00       	call   11d1 <printf>
  }
  
  exit();
     170:	e8 27 0e 00 00       	call   f9c <exit>

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
     183:	e8 94 0e 00 00       	call   101c <getpid>
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
     19e:	e8 22 08 00 00       	call   9c5 <strlen>
     1a3:	48                   	dec    %eax
     1a4:	01 d8                	add    %ebx,%eax
     1a6:	8a 00                	mov    (%eax),%al
     1a8:	88 45 e6             	mov    %al,-0x1a(%ebp)
  index[1] = '\0';
     1ab:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  cindex = atoi(index);
     1af:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     1b2:	89 04 24             	mov    %eax,(%esp)
     1b5:	e8 51 0d 00 00       	call   f0b <atoi>
     1ba:	89 45 f4             	mov    %eax,-0xc(%ebp)

  setvc(cindex, argv[2]);
     1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
     1c0:	83 c0 08             	add    $0x8,%eax
     1c3:	8b 00                	mov    (%eax),%eax
     1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
     1c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1cc:	89 04 24             	mov    %eax,(%esp)
     1cf:	e8 c8 0e 00 00       	call   109c <setvc>

  fd = open(argv[2], O_RDWR);
     1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
     1d7:	83 c0 08             	add    $0x8,%eax
     1da:	8b 00                	mov    (%eax),%eax
     1dc:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     1e3:	00 
     1e4:	89 04 24             	mov    %eax,(%esp)
     1e7:	e8 f0 0d 00 00       	call   fdc <open>
     1ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     1ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     1f3:	79 25                	jns    21a <start+0xa5>
    printf(1, "Failed to open console %s\n", argv[2]);
     1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     1f8:	83 c0 08             	add    $0x8,%eax
     1fb:	8b 00                	mov    (%eax),%eax
     1fd:	89 44 24 08          	mov    %eax,0x8(%esp)
     201:	c7 44 24 04 91 16 00 	movl   $0x1691,0x4(%esp)
     208:	00 
     209:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     210:	e8 bc 0f 00 00       	call   11d1 <printf>
    exit();
     215:	e8 82 0d 00 00       	call   f9c <exit>
  }
  printf(1, "Opened console %s\n", argv[2]);
     21a:	8b 45 0c             	mov    0xc(%ebp),%eax
     21d:	83 c0 08             	add    $0x8,%eax
     220:	8b 00                	mov    (%eax),%eax
     222:	89 44 24 08          	mov    %eax,0x8(%esp)
     226:	c7 44 24 04 ac 16 00 	movl   $0x16ac,0x4(%esp)
     22d:	00 
     22e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     235:	e8 97 0f 00 00       	call   11d1 <printf>
  /* fork a child and exec argv[4] */
  id = fork();
     23a:	e8 55 0d 00 00       	call   f94 <fork>
     23f:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if(id == 0){
     242:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     246:	0f 85 b3 00 00 00    	jne    2ff <start+0x18a>
    close(0);
     24c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     253:	e8 6c 0d 00 00       	call   fc4 <close>
    close(1);
     258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     25f:	e8 60 0d 00 00       	call   fc4 <close>
    close(2);
     264:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     26b:	e8 54 0d 00 00       	call   fc4 <close>
    dup(fd);
     270:	8b 45 ec             	mov    -0x14(%ebp),%eax
     273:	89 04 24             	mov    %eax,(%esp)
     276:	e8 99 0d 00 00       	call   1014 <dup>
    dup(fd);
     27b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 8e 0d 00 00       	call   1014 <dup>
    dup(fd);
     286:	8b 45 ec             	mov    -0x14(%ebp),%eax
     289:	89 04 24             	mov    %eax,(%esp)
     28c:	e8 83 0d 00 00       	call   1014 <dup>
    if(chdir(argv[3]) < 0){
     291:	8b 45 0c             	mov    0xc(%ebp),%eax
     294:	83 c0 0c             	add    $0xc,%eax
     297:	8b 00                	mov    (%eax),%eax
     299:	89 04 24             	mov    %eax,(%esp)
     29c:	e8 6b 0d 00 00       	call   100c <chdir>
     2a1:	85 c0                	test   %eax,%eax
     2a3:	79 30                	jns    2d5 <start+0x160>
      printf(1, "Container %s does not exist.", argv[3]);
     2a5:	8b 45 0c             	mov    0xc(%ebp),%eax
     2a8:	83 c0 0c             	add    $0xc,%eax
     2ab:	8b 00                	mov    (%eax),%eax
     2ad:	89 44 24 08          	mov    %eax,0x8(%esp)
     2b1:	c7 44 24 04 bf 16 00 	movl   $0x16bf,0x4(%esp)
     2b8:	00 
     2b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c0:	e8 0c 0f 00 00       	call   11d1 <printf>
      kill(ppid);
     2c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2c8:	89 04 24             	mov    %eax,(%esp)
     2cb:	e8 fc 0c 00 00       	call   fcc <kill>
      exit();
     2d0:	e8 c7 0c 00 00       	call   f9c <exit>
    }
    exec(argv[4], &argv[4]);
     2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
     2d8:	8d 50 10             	lea    0x10(%eax),%edx
     2db:	8b 45 0c             	mov    0xc(%ebp),%eax
     2de:	83 c0 10             	add    $0x10,%eax
     2e1:	8b 00                	mov    (%eax),%eax
     2e3:	89 54 24 04          	mov    %edx,0x4(%esp)
     2e7:	89 04 24             	mov    %eax,(%esp)
     2ea:	e8 e5 0c 00 00       	call   fd4 <exec>
    close(fd);
     2ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2f2:	89 04 24             	mov    %eax,(%esp)
     2f5:	e8 ca 0c 00 00       	call   fc4 <close>
    exit();
     2fa:	e8 9d 0c 00 00       	call   f9c <exit>
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
     318:	81 ec 84 00 00 00    	sub    $0x84,%esp
  int i, id, bytes, cindex = 0;
     31e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  // num_files = argc - 6;
  char *mkdir[2];
  // char *files[num_files];
  mkdir[0] = "mkdir";
     325:	c7 45 dc dc 16 00 00 	movl   $0x16dc,-0x24(%ebp)
  mkdir[1] = argv[2];
     32c:	8b 45 0c             	mov    0xc(%ebp),%eax
     32f:	8b 40 08             	mov    0x8(%eax),%eax
     332:	89 45 e0             	mov    %eax,-0x20(%ebp)

  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
     335:	8b 45 0c             	mov    0xc(%ebp),%eax
     338:	83 c0 08             	add    $0x8,%eax
     33b:	8b 18                	mov    (%eax),%ebx
     33d:	8b 45 0c             	mov    0xc(%ebp),%eax
     340:	83 c0 08             	add    $0x8,%eax
     343:	8b 00                	mov    (%eax),%eax
     345:	89 04 24             	mov    %eax,(%esp)
     348:	e8 78 06 00 00       	call   9c5 <strlen>
     34d:	48                   	dec    %eax
     34e:	01 d8                	add    %ebx,%eax
     350:	8a 00                	mov    (%eax),%al
     352:	88 45 da             	mov    %al,-0x26(%ebp)
  index[1] = '\0';
     355:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  cindex = atoi(index);
     359:	8d 45 da             	lea    -0x26(%ebp),%eax
     35c:	89 04 24             	mov    %eax,(%esp)
     35f:	e8 a7 0b 00 00       	call   f0b <atoi>
     364:	89 45 f0             	mov    %eax,-0x10(%ebp)

  setname(cindex, argv[2]);
     367:	8b 45 0c             	mov    0xc(%ebp),%eax
     36a:	83 c0 08             	add    $0x8,%eax
     36d:	8b 00                	mov    (%eax),%eax
     36f:	89 44 24 04          	mov    %eax,0x4(%esp)
     373:	8b 45 f0             	mov    -0x10(%ebp),%eax
     376:	89 04 24             	mov    %eax,(%esp)
     379:	e8 c6 0c 00 00       	call   1044 <setname>
  setmaxproc(cindex, atoi(argv[3]));
     37e:	8b 45 0c             	mov    0xc(%ebp),%eax
     381:	83 c0 0c             	add    $0xc,%eax
     384:	8b 00                	mov    (%eax),%eax
     386:	89 04 24             	mov    %eax,(%esp)
     389:	e8 7d 0b 00 00       	call   f0b <atoi>
     38e:	89 44 24 04          	mov    %eax,0x4(%esp)
     392:	8b 45 f0             	mov    -0x10(%ebp),%eax
     395:	89 04 24             	mov    %eax,(%esp)
     398:	e8 b7 0c 00 00       	call   1054 <setmaxproc>
  setmaxmem(cindex, atoi(argv[4]) * 1000000);
     39d:	8b 45 0c             	mov    0xc(%ebp),%eax
     3a0:	83 c0 10             	add    $0x10,%eax
     3a3:	8b 00                	mov    (%eax),%eax
     3a5:	89 04 24             	mov    %eax,(%esp)
     3a8:	e8 5e 0b 00 00       	call   f0b <atoi>
     3ad:	89 c2                	mov    %eax,%edx
     3af:	89 d0                	mov    %edx,%eax
     3b1:	c1 e0 02             	shl    $0x2,%eax
     3b4:	01 d0                	add    %edx,%eax
     3b6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3bd:	01 d0                	add    %edx,%eax
     3bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3c6:	01 d0                	add    %edx,%eax
     3c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3cf:	01 d0                	add    %edx,%eax
     3d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3d8:	01 d0                	add    %edx,%eax
     3da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3e1:	01 d0                	add    %edx,%eax
     3e3:	c1 e0 06             	shl    $0x6,%eax
     3e6:	89 44 24 04          	mov    %eax,0x4(%esp)
     3ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3ed:	89 04 24             	mov    %eax,(%esp)
     3f0:	e8 6f 0c 00 00       	call   1064 <setmaxmem>
  setmaxdisk(cindex, atoi(argv[5]) * 1000000);
     3f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     3f8:	83 c0 14             	add    $0x14,%eax
     3fb:	8b 00                	mov    (%eax),%eax
     3fd:	89 04 24             	mov    %eax,(%esp)
     400:	e8 06 0b 00 00       	call   f0b <atoi>
     405:	89 c2                	mov    %eax,%edx
     407:	89 d0                	mov    %edx,%eax
     409:	c1 e0 02             	shl    $0x2,%eax
     40c:	01 d0                	add    %edx,%eax
     40e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     415:	01 d0                	add    %edx,%eax
     417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     41e:	01 d0                	add    %edx,%eax
     420:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     427:	01 d0                	add    %edx,%eax
     429:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     430:	01 d0                	add    %edx,%eax
     432:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     439:	01 d0                	add    %edx,%eax
     43b:	c1 e0 06             	shl    $0x6,%eax
     43e:	89 44 24 04          	mov    %eax,0x4(%esp)
     442:	8b 45 f0             	mov    -0x10(%ebp),%eax
     445:	89 04 24             	mov    %eax,(%esp)
     448:	e8 27 0c 00 00       	call   1074 <setmaxdisk>
  setusedmem(cindex, 0);
     44d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     454:	00 
     455:	8b 45 f0             	mov    -0x10(%ebp),%eax
     458:	89 04 24             	mov    %eax,(%esp)
     45b:	e8 24 0c 00 00       	call   1084 <setusedmem>
  setuseddisk(cindex, 0);
     460:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     467:	00 
     468:	8b 45 f0             	mov    -0x10(%ebp),%eax
     46b:	89 04 24             	mov    %eax,(%esp)
     46e:	e8 21 0c 00 00       	call   1094 <setuseddisk>
  char path[32];
  strcpy(path, "/");
     473:	c7 44 24 04 e2 16 00 	movl   $0x16e2,0x4(%esp)
     47a:	00 
     47b:	8d 45 ba             	lea    -0x46(%ebp),%eax
     47e:	89 04 24             	mov    %eax,(%esp)
     481:	e8 8b 03 00 00       	call   811 <strcpy>
  strcat(path, argv[2]);
     486:	8b 45 0c             	mov    0xc(%ebp),%eax
     489:	83 c0 08             	add    $0x8,%eax
     48c:	8b 00                	mov    (%eax),%eax
     48e:	89 44 24 04          	mov    %eax,0x4(%esp)
     492:	8d 45 ba             	lea    -0x46(%ebp),%eax
     495:	89 04 24             	mov    %eax,(%esp)
     498:	e8 a1 05 00 00       	call   a3e <strcat>
  strcat(path, "\0");
     49d:	c7 44 24 04 e4 16 00 	movl   $0x16e4,0x4(%esp)
     4a4:	00 
     4a5:	8d 45 ba             	lea    -0x46(%ebp),%eax
     4a8:	89 04 24             	mov    %eax,(%esp)
     4ab:	e8 8e 05 00 00       	call   a3e <strcat>
  setpath(cindex, path, 0);
     4b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     4b7:	00 
     4b8:	8d 45 ba             	lea    -0x46(%ebp),%eax
     4bb:	89 44 24 04          	mov    %eax,0x4(%esp)
     4bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4c2:	89 04 24             	mov    %eax,(%esp)
     4c5:	e8 22 0c 00 00       	call   10ec <setpath>

  int ppid = getpid();
     4ca:	e8 4d 0b 00 00       	call   101c <getpid>
     4cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  id = fork();
     4d2:	e8 bd 0a 00 00       	call   f94 <fork>
     4d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(id == 0){
     4da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     4de:	75 36                	jne    516 <create+0x202>
    exec(mkdir[0], mkdir);
     4e0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     4e3:	8d 55 dc             	lea    -0x24(%ebp),%edx
     4e6:	89 54 24 04          	mov    %edx,0x4(%esp)
     4ea:	89 04 24             	mov    %eax,(%esp)
     4ed:	e8 e2 0a 00 00       	call   fd4 <exec>
    printf(1, "Creating container failed. Container taken.\n");
     4f2:	c7 44 24 04 e8 16 00 	movl   $0x16e8,0x4(%esp)
     4f9:	00 
     4fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     501:	e8 cb 0c 00 00       	call   11d1 <printf>
    kill(ppid);
     506:	8b 45 ec             	mov    -0x14(%ebp),%eax
     509:	89 04 24             	mov    %eax,(%esp)
     50c:	e8 bb 0a 00 00       	call   fcc <kill>
    exit();
     511:	e8 86 0a 00 00       	call   f9c <exit>
  }
  id = wait();
     516:	e8 89 0a 00 00       	call   fa4 <wait>
     51b:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     51e:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     525:	e9 66 01 00 00       	jmp    690 <create+0x37c>
    char destination[32];

    strcpy(destination, "/");
     52a:	c7 44 24 04 e2 16 00 	movl   $0x16e2,0x4(%esp)
     531:	00 
     532:	8d 45 90             	lea    -0x70(%ebp),%eax
     535:	89 04 24             	mov    %eax,(%esp)
     538:	e8 d4 02 00 00       	call   811 <strcpy>
    strcat(destination, mkdir[1]);
     53d:	8b 45 e0             	mov    -0x20(%ebp),%eax
     540:	89 44 24 04          	mov    %eax,0x4(%esp)
     544:	8d 45 90             	lea    -0x70(%ebp),%eax
     547:	89 04 24             	mov    %eax,(%esp)
     54a:	e8 ef 04 00 00       	call   a3e <strcat>
    strcat(destination, "/");
     54f:	c7 44 24 04 e2 16 00 	movl   $0x16e2,0x4(%esp)
     556:	00 
     557:	8d 45 90             	lea    -0x70(%ebp),%eax
     55a:	89 04 24             	mov    %eax,(%esp)
     55d:	e8 dc 04 00 00       	call   a3e <strcat>
    strcat(destination, argv[i]);
     562:	8b 45 f4             	mov    -0xc(%ebp),%eax
     565:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     56c:	8b 45 0c             	mov    0xc(%ebp),%eax
     56f:	01 d0                	add    %edx,%eax
     571:	8b 00                	mov    (%eax),%eax
     573:	89 44 24 04          	mov    %eax,0x4(%esp)
     577:	8d 45 90             	lea    -0x70(%ebp),%eax
     57a:	89 04 24             	mov    %eax,(%esp)
     57d:	e8 bc 04 00 00       	call   a3e <strcat>
    strcat(destination, "\0");
     582:	c7 44 24 04 e4 16 00 	movl   $0x16e4,0x4(%esp)
     589:	00 
     58a:	8d 45 90             	lea    -0x70(%ebp),%eax
     58d:	89 04 24             	mov    %eax,(%esp)
     590:	e8 a9 04 00 00       	call   a3e <strcat>

    // ctable.tuperwares[i].files[i-6] = argv[i];
    bytes = copy(argv[i], destination, getuseddisk(cindex), getmaxdisk(cindex));
     595:	8b 45 f0             	mov    -0x10(%ebp),%eax
     598:	89 04 24             	mov    %eax,(%esp)
     59b:	e8 cc 0a 00 00       	call   106c <getmaxdisk>
     5a0:	89 c3                	mov    %eax,%ebx
     5a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5a5:	89 04 24             	mov    %eax,(%esp)
     5a8:	e8 df 0a 00 00       	call   108c <getuseddisk>
     5ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
     5b0:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
     5b7:	8b 55 0c             	mov    0xc(%ebp),%edx
     5ba:	01 ca                	add    %ecx,%edx
     5bc:	8b 12                	mov    (%edx),%edx
     5be:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     5c2:	89 44 24 08          	mov    %eax,0x8(%esp)
     5c6:	8d 45 90             	lea    -0x70(%ebp),%eax
     5c9:	89 44 24 04          	mov    %eax,0x4(%esp)
     5cd:	89 14 24             	mov    %edx,(%esp)
     5d0:	e8 6a 02 00 00       	call   83f <copy>
     5d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Bytes for %s: %d\n", argv[i], bytes);
     5d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     5e2:	8b 45 0c             	mov    0xc(%ebp),%eax
     5e5:	01 d0                	add    %edx,%eax
     5e7:	8b 00                	mov    (%eax),%eax
     5e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     5ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
     5f0:	89 44 24 08          	mov    %eax,0x8(%esp)
     5f4:	c7 44 24 04 15 17 00 	movl   $0x1715,0x4(%esp)
     5fb:	00 
     5fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     603:	e8 c9 0b 00 00       	call   11d1 <printf>

    if(bytes > 0){
     608:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     60c:	7e 21                	jle    62f <create+0x31b>
      setuseddisk(cindex, getuseddisk(cindex) + bytes);
     60e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     611:	89 04 24             	mov    %eax,(%esp)
     614:	e8 73 0a 00 00       	call   108c <getuseddisk>
     619:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     61c:	01 d0                	add    %edx,%eax
     61e:	89 44 24 04          	mov    %eax,0x4(%esp)
     622:	8b 45 f0             	mov    -0x10(%ebp),%eax
     625:	89 04 24             	mov    %eax,(%esp)
     628:	e8 67 0a 00 00       	call   1094 <setuseddisk>
     62d:	eb 5e                	jmp    68d <create+0x379>
    }
    else{
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
     62f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     632:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     639:	8b 45 0c             	mov    0xc(%ebp),%eax
     63c:	01 d0                	add    %edx,%eax
     63e:	8b 00                	mov    (%eax),%eax
     640:	89 44 24 08          	mov    %eax,0x8(%esp)
     644:	c7 44 24 04 28 17 00 	movl   $0x1728,0x4(%esp)
     64b:	00 
     64c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     653:	e8 79 0b 00 00       	call   11d1 <printf>
      id = fork();
     658:	e8 37 09 00 00       	call   f94 <fork>
     65d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(id == 0){
     660:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     664:	75 1f                	jne    685 <create+0x371>
        char *remove_args[2];
        remove_args[0] = "rm";
     666:	c7 45 b0 7e 17 00 00 	movl   $0x177e,-0x50(%ebp)
        remove_args[1] = destination;
     66d:	8d 45 90             	lea    -0x70(%ebp),%eax
     670:	89 45 b4             	mov    %eax,-0x4c(%ebp)
        exec(remove_args[0], remove_args);
     673:	8b 45 b0             	mov    -0x50(%ebp),%eax
     676:	8d 55 b0             	lea    -0x50(%ebp),%edx
     679:	89 54 24 04          	mov    %edx,0x4(%esp)
     67d:	89 04 24             	mov    %eax,(%esp)
     680:	e8 4f 09 00 00       	call   fd4 <exec>
      }
      id = wait();
     685:	e8 1a 09 00 00       	call   fa4 <wait>
     68a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    kill(ppid);
    exit();
  }
  id = wait();

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     68d:	ff 45 f4             	incl   -0xc(%ebp)
     690:	8b 45 f4             	mov    -0xc(%ebp),%eax
     693:	3b 45 08             	cmp    0x8(%ebp),%eax
     696:	0f 8c 8e fe ff ff    	jl     52a <create+0x216>
        exec(remove_args[0], remove_args);
      }
      id = wait();
    }
  }
  printf(1, "Total used disk: %d\n", getuseddisk(cindex));
     69c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     69f:	89 04 24             	mov    %eax,(%esp)
     6a2:	e8 e5 09 00 00       	call   108c <getuseddisk>
     6a7:	89 44 24 08          	mov    %eax,0x8(%esp)
     6ab:	c7 44 24 04 81 17 00 	movl   $0x1781,0x4(%esp)
     6b2:	00 
     6b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6ba:	e8 12 0b 00 00       	call   11d1 <printf>

  // TODO: IMPLEMENT GET/SET FILES
  // ctable.tuperwares[cindex].files = files;
  return 0;
     6bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6c4:	81 c4 84 00 00 00    	add    $0x84,%esp
     6ca:	5b                   	pop    %ebx
     6cb:	5d                   	pop    %ebp
     6cc:	c3                   	ret    

000006cd <to_string>:

int to_string(){
     6cd:	55                   	push   %ebp
     6ce:	89 e5                	mov    %esp,%ebp
     6d0:	81 ec 18 01 00 00    	sub    $0x118,%esp

  char containers[256];
  tostring(containers);
     6d6:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
     6dc:	89 04 24             	mov    %eax,(%esp)
     6df:	e8 e0 09 00 00       	call   10c4 <tostring>
  printf(1, "%s\n", containers);
     6e4:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
     6ea:	89 44 24 08          	mov    %eax,0x8(%esp)
     6ee:	c7 44 24 04 96 17 00 	movl   $0x1796,0x4(%esp)
     6f5:	00 
     6f6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6fd:	e8 cf 0a 00 00       	call   11d1 <printf>
  return 0;
     702:	b8 00 00 00 00       	mov    $0x0,%eax
}
     707:	c9                   	leave  
     708:	c3                   	ret    

00000709 <main>:

int main(int argc, char *argv[]){
     709:	55                   	push   %ebp
     70a:	89 e5                	mov    %esp,%ebp
     70c:	83 e4 f0             	and    $0xfffffff0,%esp
     70f:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2){
     712:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     716:	7f 0c                	jg     724 <main+0x1b>
    print_usage(0);
     718:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     71f:	e8 c4 f9 ff ff       	call   e8 <print_usage>
  }

  if(strcmp(argv[1], "create") == 0){
     724:	8b 45 0c             	mov    0xc(%ebp),%eax
     727:	83 c0 04             	add    $0x4,%eax
     72a:	8b 00                	mov    (%eax),%eax
     72c:	c7 44 24 04 9a 17 00 	movl   $0x179a,0x4(%esp)
     733:	00 
     734:	89 04 24             	mov    %eax,(%esp)
     737:	e8 03 02 00 00       	call   93f <strcmp>
     73c:	85 c0                	test   %eax,%eax
     73e:	75 44                	jne    784 <main+0x7b>
    if(argc < 7){
     740:	83 7d 08 06          	cmpl   $0x6,0x8(%ebp)
     744:	7f 0c                	jg     752 <main+0x49>
      print_usage(1);
     746:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     74d:	e8 96 f9 ff ff       	call   e8 <print_usage>
    }
    if(chdir(argv[2]) > 0){
     752:	8b 45 0c             	mov    0xc(%ebp),%eax
     755:	83 c0 08             	add    $0x8,%eax
     758:	8b 00                	mov    (%eax),%eax
     75a:	89 04 24             	mov    %eax,(%esp)
     75d:	e8 aa 08 00 00       	call   100c <chdir>
     762:	85 c0                	test   %eax,%eax
     764:	7e 0c                	jle    772 <main+0x69>
      print_usage(2);
     766:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     76d:	e8 76 f9 ff ff       	call   e8 <print_usage>
    }
    create(argc, argv);
     772:	8b 45 0c             	mov    0xc(%ebp),%eax
     775:	89 44 24 04          	mov    %eax,0x4(%esp)
     779:	8b 45 08             	mov    0x8(%ebp),%eax
     77c:	89 04 24             	mov    %eax,(%esp)
     77f:	e8 90 fb ff ff       	call   314 <create>
  }

  if(strcmp(argv[1], "start") == 0){
     784:	8b 45 0c             	mov    0xc(%ebp),%eax
     787:	83 c0 04             	add    $0x4,%eax
     78a:	8b 00                	mov    (%eax),%eax
     78c:	c7 44 24 04 a1 17 00 	movl   $0x17a1,0x4(%esp)
     793:	00 
     794:	89 04 24             	mov    %eax,(%esp)
     797:	e8 a3 01 00 00       	call   93f <strcmp>
     79c:	85 c0                	test   %eax,%eax
     79e:	75 24                	jne    7c4 <main+0xbb>
    if(argc < 5){
     7a0:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     7a4:	7f 0c                	jg     7b2 <main+0xa9>
      print_usage(3);
     7a6:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     7ad:	e8 36 f9 ff ff       	call   e8 <print_usage>
    }
    start(argc, argv);
     7b2:	8b 45 0c             	mov    0xc(%ebp),%eax
     7b5:	89 44 24 04          	mov    %eax,0x4(%esp)
     7b9:	8b 45 08             	mov    0x8(%ebp),%eax
     7bc:	89 04 24             	mov    %eax,(%esp)
     7bf:	e8 b1 f9 ff ff       	call   175 <start>
  }

  if(strcmp(argv[1], "string") == 0){
     7c4:	8b 45 0c             	mov    0xc(%ebp),%eax
     7c7:	83 c0 04             	add    $0x4,%eax
     7ca:	8b 00                	mov    (%eax),%eax
     7cc:	c7 44 24 04 a7 17 00 	movl   $0x17a7,0x4(%esp)
     7d3:	00 
     7d4:	89 04 24             	mov    %eax,(%esp)
     7d7:	e8 63 01 00 00       	call   93f <strcmp>
     7dc:	85 c0                	test   %eax,%eax
     7de:	75 05                	jne    7e5 <main+0xdc>
    to_string();
     7e0:	e8 e8 fe ff ff       	call   6cd <to_string>
  //   if(argc < 3){
  //     print_usage(4);
  //   }
  //   delete(argv);
  // }
  exit();
     7e5:	e8 b2 07 00 00       	call   f9c <exit>
     7ea:	90                   	nop
     7eb:	90                   	nop

000007ec <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     7ec:	55                   	push   %ebp
     7ed:	89 e5                	mov    %esp,%ebp
     7ef:	57                   	push   %edi
     7f0:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     7f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
     7f4:	8b 55 10             	mov    0x10(%ebp),%edx
     7f7:	8b 45 0c             	mov    0xc(%ebp),%eax
     7fa:	89 cb                	mov    %ecx,%ebx
     7fc:	89 df                	mov    %ebx,%edi
     7fe:	89 d1                	mov    %edx,%ecx
     800:	fc                   	cld    
     801:	f3 aa                	rep stos %al,%es:(%edi)
     803:	89 ca                	mov    %ecx,%edx
     805:	89 fb                	mov    %edi,%ebx
     807:	89 5d 08             	mov    %ebx,0x8(%ebp)
     80a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     80d:	5b                   	pop    %ebx
     80e:	5f                   	pop    %edi
     80f:	5d                   	pop    %ebp
     810:	c3                   	ret    

00000811 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     811:	55                   	push   %ebp
     812:	89 e5                	mov    %esp,%ebp
     814:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     817:	8b 45 08             	mov    0x8(%ebp),%eax
     81a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     81d:	90                   	nop
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	8d 50 01             	lea    0x1(%eax),%edx
     824:	89 55 08             	mov    %edx,0x8(%ebp)
     827:	8b 55 0c             	mov    0xc(%ebp),%edx
     82a:	8d 4a 01             	lea    0x1(%edx),%ecx
     82d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     830:	8a 12                	mov    (%edx),%dl
     832:	88 10                	mov    %dl,(%eax)
     834:	8a 00                	mov    (%eax),%al
     836:	84 c0                	test   %al,%al
     838:	75 e4                	jne    81e <strcpy+0xd>
    ;
  return os;
     83a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     83d:	c9                   	leave  
     83e:	c3                   	ret    

0000083f <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     83f:	55                   	push   %ebp
     840:	89 e5                	mov    %esp,%ebp
     842:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     845:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     84c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     853:	00 
     854:	8b 45 08             	mov    0x8(%ebp),%eax
     857:	89 04 24             	mov    %eax,(%esp)
     85a:	e8 7d 07 00 00       	call   fdc <open>
     85f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     862:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     866:	79 20                	jns    888 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     868:	8b 45 08             	mov    0x8(%ebp),%eax
     86b:	89 44 24 08          	mov    %eax,0x8(%esp)
     86f:	c7 44 24 04 ae 17 00 	movl   $0x17ae,0x4(%esp)
     876:	00 
     877:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     87e:	e8 4e 09 00 00       	call   11d1 <printf>
      exit();
     883:	e8 14 07 00 00       	call   f9c <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     888:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     88f:	00 
     890:	8b 45 0c             	mov    0xc(%ebp),%eax
     893:	89 04 24             	mov    %eax,(%esp)
     896:	e8 41 07 00 00       	call   fdc <open>
     89b:	89 45 ec             	mov    %eax,-0x14(%ebp)
     89e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     8a2:	79 20                	jns    8c4 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     8a4:	8b 45 0c             	mov    0xc(%ebp),%eax
     8a7:	89 44 24 08          	mov    %eax,0x8(%esp)
     8ab:	c7 44 24 04 c9 17 00 	movl   $0x17c9,0x4(%esp)
     8b2:	00 
     8b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8ba:	e8 12 09 00 00       	call   11d1 <printf>
      exit();
     8bf:	e8 d8 06 00 00       	call   f9c <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     8c4:	eb 3b                	jmp    901 <copy+0xc2>
  {
      max = used_disk+=count;
     8c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8c9:	01 45 10             	add    %eax,0x10(%ebp)
     8cc:	8b 45 10             	mov    0x10(%ebp),%eax
     8cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     8d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8d5:	3b 45 14             	cmp    0x14(%ebp),%eax
     8d8:	7e 07                	jle    8e1 <copy+0xa2>
      {
        return -1;
     8da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     8df:	eb 5c                	jmp    93d <copy+0xfe>
      }
      bytes = bytes + count;
     8e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8e4:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     8e7:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     8ee:	00 
     8ef:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     8f2:	89 44 24 04          	mov    %eax,0x4(%esp)
     8f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8f9:	89 04 24             	mov    %eax,(%esp)
     8fc:	e8 bb 06 00 00       	call   fbc <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     901:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     908:	00 
     909:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     90c:	89 44 24 04          	mov    %eax,0x4(%esp)
     910:	8b 45 f0             	mov    -0x10(%ebp),%eax
     913:	89 04 24             	mov    %eax,(%esp)
     916:	e8 99 06 00 00       	call   fb4 <read>
     91b:	89 45 e8             	mov    %eax,-0x18(%ebp)
     91e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     922:	7f a2                	jg     8c6 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     924:	8b 45 f0             	mov    -0x10(%ebp),%eax
     927:	89 04 24             	mov    %eax,(%esp)
     92a:	e8 95 06 00 00       	call   fc4 <close>
  close(fd2);
     92f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     932:	89 04 24             	mov    %eax,(%esp)
     935:	e8 8a 06 00 00       	call   fc4 <close>
  return(bytes);
     93a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     93d:	c9                   	leave  
     93e:	c3                   	ret    

0000093f <strcmp>:

int
strcmp(const char *p, const char *q)
{
     93f:	55                   	push   %ebp
     940:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     942:	eb 06                	jmp    94a <strcmp+0xb>
    p++, q++;
     944:	ff 45 08             	incl   0x8(%ebp)
     947:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     94a:	8b 45 08             	mov    0x8(%ebp),%eax
     94d:	8a 00                	mov    (%eax),%al
     94f:	84 c0                	test   %al,%al
     951:	74 0e                	je     961 <strcmp+0x22>
     953:	8b 45 08             	mov    0x8(%ebp),%eax
     956:	8a 10                	mov    (%eax),%dl
     958:	8b 45 0c             	mov    0xc(%ebp),%eax
     95b:	8a 00                	mov    (%eax),%al
     95d:	38 c2                	cmp    %al,%dl
     95f:	74 e3                	je     944 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     961:	8b 45 08             	mov    0x8(%ebp),%eax
     964:	8a 00                	mov    (%eax),%al
     966:	0f b6 d0             	movzbl %al,%edx
     969:	8b 45 0c             	mov    0xc(%ebp),%eax
     96c:	8a 00                	mov    (%eax),%al
     96e:	0f b6 c0             	movzbl %al,%eax
     971:	29 c2                	sub    %eax,%edx
     973:	89 d0                	mov    %edx,%eax
}
     975:	5d                   	pop    %ebp
     976:	c3                   	ret    

00000977 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     977:	55                   	push   %ebp
     978:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     97a:	eb 09                	jmp    985 <strncmp+0xe>
    n--, p++, q++;
     97c:	ff 4d 10             	decl   0x10(%ebp)
     97f:	ff 45 08             	incl   0x8(%ebp)
     982:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     985:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     989:	74 17                	je     9a2 <strncmp+0x2b>
     98b:	8b 45 08             	mov    0x8(%ebp),%eax
     98e:	8a 00                	mov    (%eax),%al
     990:	84 c0                	test   %al,%al
     992:	74 0e                	je     9a2 <strncmp+0x2b>
     994:	8b 45 08             	mov    0x8(%ebp),%eax
     997:	8a 10                	mov    (%eax),%dl
     999:	8b 45 0c             	mov    0xc(%ebp),%eax
     99c:	8a 00                	mov    (%eax),%al
     99e:	38 c2                	cmp    %al,%dl
     9a0:	74 da                	je     97c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     9a2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     9a6:	75 07                	jne    9af <strncmp+0x38>
    return 0;
     9a8:	b8 00 00 00 00       	mov    $0x0,%eax
     9ad:	eb 14                	jmp    9c3 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     9af:	8b 45 08             	mov    0x8(%ebp),%eax
     9b2:	8a 00                	mov    (%eax),%al
     9b4:	0f b6 d0             	movzbl %al,%edx
     9b7:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ba:	8a 00                	mov    (%eax),%al
     9bc:	0f b6 c0             	movzbl %al,%eax
     9bf:	29 c2                	sub    %eax,%edx
     9c1:	89 d0                	mov    %edx,%eax
}
     9c3:	5d                   	pop    %ebp
     9c4:	c3                   	ret    

000009c5 <strlen>:

uint
strlen(const char *s)
{
     9c5:	55                   	push   %ebp
     9c6:	89 e5                	mov    %esp,%ebp
     9c8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     9cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     9d2:	eb 03                	jmp    9d7 <strlen+0x12>
     9d4:	ff 45 fc             	incl   -0x4(%ebp)
     9d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
     9da:	8b 45 08             	mov    0x8(%ebp),%eax
     9dd:	01 d0                	add    %edx,%eax
     9df:	8a 00                	mov    (%eax),%al
     9e1:	84 c0                	test   %al,%al
     9e3:	75 ef                	jne    9d4 <strlen+0xf>
    ;
  return n;
     9e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     9e8:	c9                   	leave  
     9e9:	c3                   	ret    

000009ea <memset>:

void*
memset(void *dst, int c, uint n)
{
     9ea:	55                   	push   %ebp
     9eb:	89 e5                	mov    %esp,%ebp
     9ed:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     9f0:	8b 45 10             	mov    0x10(%ebp),%eax
     9f3:	89 44 24 08          	mov    %eax,0x8(%esp)
     9f7:	8b 45 0c             	mov    0xc(%ebp),%eax
     9fa:	89 44 24 04          	mov    %eax,0x4(%esp)
     9fe:	8b 45 08             	mov    0x8(%ebp),%eax
     a01:	89 04 24             	mov    %eax,(%esp)
     a04:	e8 e3 fd ff ff       	call   7ec <stosb>
  return dst;
     a09:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a0c:	c9                   	leave  
     a0d:	c3                   	ret    

00000a0e <strchr>:

char*
strchr(const char *s, char c)
{
     a0e:	55                   	push   %ebp
     a0f:	89 e5                	mov    %esp,%ebp
     a11:	83 ec 04             	sub    $0x4,%esp
     a14:	8b 45 0c             	mov    0xc(%ebp),%eax
     a17:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     a1a:	eb 12                	jmp    a2e <strchr+0x20>
    if(*s == c)
     a1c:	8b 45 08             	mov    0x8(%ebp),%eax
     a1f:	8a 00                	mov    (%eax),%al
     a21:	3a 45 fc             	cmp    -0x4(%ebp),%al
     a24:	75 05                	jne    a2b <strchr+0x1d>
      return (char*)s;
     a26:	8b 45 08             	mov    0x8(%ebp),%eax
     a29:	eb 11                	jmp    a3c <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     a2b:	ff 45 08             	incl   0x8(%ebp)
     a2e:	8b 45 08             	mov    0x8(%ebp),%eax
     a31:	8a 00                	mov    (%eax),%al
     a33:	84 c0                	test   %al,%al
     a35:	75 e5                	jne    a1c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a3c:	c9                   	leave  
     a3d:	c3                   	ret    

00000a3e <strcat>:

char *
strcat(char *dest, const char *src)
{
     a3e:	55                   	push   %ebp
     a3f:	89 e5                	mov    %esp,%ebp
     a41:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     a44:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     a4b:	eb 03                	jmp    a50 <strcat+0x12>
     a4d:	ff 45 fc             	incl   -0x4(%ebp)
     a50:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a53:	8b 45 08             	mov    0x8(%ebp),%eax
     a56:	01 d0                	add    %edx,%eax
     a58:	8a 00                	mov    (%eax),%al
     a5a:	84 c0                	test   %al,%al
     a5c:	75 ef                	jne    a4d <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     a5e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     a65:	eb 1e                	jmp    a85 <strcat+0x47>
        dest[i+j] = src[j];
     a67:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a6d:	01 d0                	add    %edx,%eax
     a6f:	89 c2                	mov    %eax,%edx
     a71:	8b 45 08             	mov    0x8(%ebp),%eax
     a74:	01 c2                	add    %eax,%edx
     a76:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     a79:	8b 45 0c             	mov    0xc(%ebp),%eax
     a7c:	01 c8                	add    %ecx,%eax
     a7e:	8a 00                	mov    (%eax),%al
     a80:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     a82:	ff 45 f8             	incl   -0x8(%ebp)
     a85:	8b 55 f8             	mov    -0x8(%ebp),%edx
     a88:	8b 45 0c             	mov    0xc(%ebp),%eax
     a8b:	01 d0                	add    %edx,%eax
     a8d:	8a 00                	mov    (%eax),%al
     a8f:	84 c0                	test   %al,%al
     a91:	75 d4                	jne    a67 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a96:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a99:	01 d0                	add    %edx,%eax
     a9b:	89 c2                	mov    %eax,%edx
     a9d:	8b 45 08             	mov    0x8(%ebp),%eax
     aa0:	01 d0                	add    %edx,%eax
     aa2:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     aa5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     aa8:	c9                   	leave  
     aa9:	c3                   	ret    

00000aaa <strstr>:

int 
strstr(char* s, char* sub)
{
     aaa:	55                   	push   %ebp
     aab:	89 e5                	mov    %esp,%ebp
     aad:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     ab0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     ab7:	eb 7c                	jmp    b35 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     ab9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     abc:	8b 45 08             	mov    0x8(%ebp),%eax
     abf:	01 d0                	add    %edx,%eax
     ac1:	8a 10                	mov    (%eax),%dl
     ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ac6:	8a 00                	mov    (%eax),%al
     ac8:	38 c2                	cmp    %al,%dl
     aca:	75 66                	jne    b32 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     acc:	8b 45 0c             	mov    0xc(%ebp),%eax
     acf:	89 04 24             	mov    %eax,(%esp)
     ad2:	e8 ee fe ff ff       	call   9c5 <strlen>
     ad7:	83 f8 01             	cmp    $0x1,%eax
     ada:	75 05                	jne    ae1 <strstr+0x37>
            {  
                return i;
     adc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     adf:	eb 6b                	jmp    b4c <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     ae1:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     ae8:	eb 3a                	jmp    b24 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     aea:	8b 45 f8             	mov    -0x8(%ebp),%eax
     aed:	8b 55 fc             	mov    -0x4(%ebp),%edx
     af0:	01 d0                	add    %edx,%eax
     af2:	89 c2                	mov    %eax,%edx
     af4:	8b 45 08             	mov    0x8(%ebp),%eax
     af7:	01 d0                	add    %edx,%eax
     af9:	8a 10                	mov    (%eax),%dl
     afb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     afe:	8b 45 0c             	mov    0xc(%ebp),%eax
     b01:	01 c8                	add    %ecx,%eax
     b03:	8a 00                	mov    (%eax),%al
     b05:	38 c2                	cmp    %al,%dl
     b07:	75 16                	jne    b1f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     b09:	8b 45 f8             	mov    -0x8(%ebp),%eax
     b0c:	8d 50 01             	lea    0x1(%eax),%edx
     b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
     b12:	01 d0                	add    %edx,%eax
     b14:	8a 00                	mov    (%eax),%al
     b16:	84 c0                	test   %al,%al
     b18:	75 07                	jne    b21 <strstr+0x77>
                    {
                        return i;
     b1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b1d:	eb 2d                	jmp    b4c <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     b1f:	eb 11                	jmp    b32 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     b21:	ff 45 f8             	incl   -0x8(%ebp)
     b24:	8b 55 f8             	mov    -0x8(%ebp),%edx
     b27:	8b 45 0c             	mov    0xc(%ebp),%eax
     b2a:	01 d0                	add    %edx,%eax
     b2c:	8a 00                	mov    (%eax),%al
     b2e:	84 c0                	test   %al,%al
     b30:	75 b8                	jne    aea <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     b32:	ff 45 fc             	incl   -0x4(%ebp)
     b35:	8b 55 fc             	mov    -0x4(%ebp),%edx
     b38:	8b 45 08             	mov    0x8(%ebp),%eax
     b3b:	01 d0                	add    %edx,%eax
     b3d:	8a 00                	mov    (%eax),%al
     b3f:	84 c0                	test   %al,%al
     b41:	0f 85 72 ff ff ff    	jne    ab9 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b4c:	c9                   	leave  
     b4d:	c3                   	ret    

00000b4e <strtok>:

char *
strtok(char *s, const char *delim)
{
     b4e:	55                   	push   %ebp
     b4f:	89 e5                	mov    %esp,%ebp
     b51:	53                   	push   %ebx
     b52:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     b55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b59:	75 08                	jne    b63 <strtok+0x15>
  s = lasts;
     b5b:	a1 a4 1c 00 00       	mov    0x1ca4,%eax
     b60:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     b63:	8b 45 08             	mov    0x8(%ebp),%eax
     b66:	8d 50 01             	lea    0x1(%eax),%edx
     b69:	89 55 08             	mov    %edx,0x8(%ebp)
     b6c:	8a 00                	mov    (%eax),%al
     b6e:	0f be d8             	movsbl %al,%ebx
     b71:	85 db                	test   %ebx,%ebx
     b73:	75 07                	jne    b7c <strtok+0x2e>
      return 0;
     b75:	b8 00 00 00 00       	mov    $0x0,%eax
     b7a:	eb 58                	jmp    bd4 <strtok+0x86>
    } while (strchr(delim, ch));
     b7c:	88 d8                	mov    %bl,%al
     b7e:	0f be c0             	movsbl %al,%eax
     b81:	89 44 24 04          	mov    %eax,0x4(%esp)
     b85:	8b 45 0c             	mov    0xc(%ebp),%eax
     b88:	89 04 24             	mov    %eax,(%esp)
     b8b:	e8 7e fe ff ff       	call   a0e <strchr>
     b90:	85 c0                	test   %eax,%eax
     b92:	75 cf                	jne    b63 <strtok+0x15>
    --s;
     b94:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     b97:	8b 45 0c             	mov    0xc(%ebp),%eax
     b9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     b9e:	8b 45 08             	mov    0x8(%ebp),%eax
     ba1:	89 04 24             	mov    %eax,(%esp)
     ba4:	e8 31 00 00 00       	call   bda <strcspn>
     ba9:	89 c2                	mov    %eax,%edx
     bab:	8b 45 08             	mov    0x8(%ebp),%eax
     bae:	01 d0                	add    %edx,%eax
     bb0:	a3 a4 1c 00 00       	mov    %eax,0x1ca4
    if (*lasts != 0)
     bb5:	a1 a4 1c 00 00       	mov    0x1ca4,%eax
     bba:	8a 00                	mov    (%eax),%al
     bbc:	84 c0                	test   %al,%al
     bbe:	74 11                	je     bd1 <strtok+0x83>
  *lasts++ = 0;
     bc0:	a1 a4 1c 00 00       	mov    0x1ca4,%eax
     bc5:	8d 50 01             	lea    0x1(%eax),%edx
     bc8:	89 15 a4 1c 00 00    	mov    %edx,0x1ca4
     bce:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     bd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     bd4:	83 c4 14             	add    $0x14,%esp
     bd7:	5b                   	pop    %ebx
     bd8:	5d                   	pop    %ebp
     bd9:	c3                   	ret    

00000bda <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     bda:	55                   	push   %ebp
     bdb:	89 e5                	mov    %esp,%ebp
     bdd:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     be0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     be7:	eb 26                	jmp    c0f <strcspn+0x35>
        if(strchr(s2,*s1))
     be9:	8b 45 08             	mov    0x8(%ebp),%eax
     bec:	8a 00                	mov    (%eax),%al
     bee:	0f be c0             	movsbl %al,%eax
     bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf8:	89 04 24             	mov    %eax,(%esp)
     bfb:	e8 0e fe ff ff       	call   a0e <strchr>
     c00:	85 c0                	test   %eax,%eax
     c02:	74 05                	je     c09 <strcspn+0x2f>
            return ret;
     c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
     c07:	eb 12                	jmp    c1b <strcspn+0x41>
        else
            s1++,ret++;
     c09:	ff 45 08             	incl   0x8(%ebp)
     c0c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     c0f:	8b 45 08             	mov    0x8(%ebp),%eax
     c12:	8a 00                	mov    (%eax),%al
     c14:	84 c0                	test   %al,%al
     c16:	75 d1                	jne    be9 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     c1b:	c9                   	leave  
     c1c:	c3                   	ret    

00000c1d <isspace>:

int
isspace(unsigned char c)
{
     c1d:	55                   	push   %ebp
     c1e:	89 e5                	mov    %esp,%ebp
     c20:	83 ec 04             	sub    $0x4,%esp
     c23:	8b 45 08             	mov    0x8(%ebp),%eax
     c26:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     c29:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     c2d:	74 1e                	je     c4d <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     c2f:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     c33:	74 18                	je     c4d <isspace+0x30>
     c35:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     c39:	74 12                	je     c4d <isspace+0x30>
     c3b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     c3f:	74 0c                	je     c4d <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     c41:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     c45:	74 06                	je     c4d <isspace+0x30>
     c47:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     c4b:	75 07                	jne    c54 <isspace+0x37>
     c4d:	b8 01 00 00 00       	mov    $0x1,%eax
     c52:	eb 05                	jmp    c59 <isspace+0x3c>
     c54:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c59:	c9                   	leave  
     c5a:	c3                   	ret    

00000c5b <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     c5b:	55                   	push   %ebp
     c5c:	89 e5                	mov    %esp,%ebp
     c5e:	57                   	push   %edi
     c5f:	56                   	push   %esi
     c60:	53                   	push   %ebx
     c61:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     c64:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     c69:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     c70:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     c73:	eb 01                	jmp    c76 <strtoul+0x1b>
  p += 1;
     c75:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     c76:	8a 03                	mov    (%ebx),%al
     c78:	0f b6 c0             	movzbl %al,%eax
     c7b:	89 04 24             	mov    %eax,(%esp)
     c7e:	e8 9a ff ff ff       	call   c1d <isspace>
     c83:	85 c0                	test   %eax,%eax
     c85:	75 ee                	jne    c75 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     c87:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     c8b:	75 30                	jne    cbd <strtoul+0x62>
    {
  if (*p == '0') {
     c8d:	8a 03                	mov    (%ebx),%al
     c8f:	3c 30                	cmp    $0x30,%al
     c91:	75 21                	jne    cb4 <strtoul+0x59>
      p += 1;
     c93:	43                   	inc    %ebx
      if (*p == 'x') {
     c94:	8a 03                	mov    (%ebx),%al
     c96:	3c 78                	cmp    $0x78,%al
     c98:	75 0a                	jne    ca4 <strtoul+0x49>
    p += 1;
     c9a:	43                   	inc    %ebx
    base = 16;
     c9b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     ca2:	eb 31                	jmp    cd5 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     ca4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     cab:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     cb2:	eb 21                	jmp    cd5 <strtoul+0x7a>
      }
  }
  else base = 10;
     cb4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     cbb:	eb 18                	jmp    cd5 <strtoul+0x7a>
    } else if (base == 16) {
     cbd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     cc1:	75 12                	jne    cd5 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     cc3:	8a 03                	mov    (%ebx),%al
     cc5:	3c 30                	cmp    $0x30,%al
     cc7:	75 0c                	jne    cd5 <strtoul+0x7a>
     cc9:	8d 43 01             	lea    0x1(%ebx),%eax
     ccc:	8a 00                	mov    (%eax),%al
     cce:	3c 78                	cmp    $0x78,%al
     cd0:	75 03                	jne    cd5 <strtoul+0x7a>
      p += 2;
     cd2:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     cd5:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     cd9:	75 29                	jne    d04 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     cdb:	8a 03                	mov    (%ebx),%al
     cdd:	0f be c0             	movsbl %al,%eax
     ce0:	83 e8 30             	sub    $0x30,%eax
     ce3:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     ce5:	83 fe 07             	cmp    $0x7,%esi
     ce8:	76 06                	jbe    cf0 <strtoul+0x95>
    break;
     cea:	90                   	nop
     ceb:	e9 b6 00 00 00       	jmp    da6 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     cf0:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     cf7:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     cfa:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     d01:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     d02:	eb d7                	jmp    cdb <strtoul+0x80>
    } else if (base == 10) {
     d04:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     d08:	75 2b                	jne    d35 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     d0a:	8a 03                	mov    (%ebx),%al
     d0c:	0f be c0             	movsbl %al,%eax
     d0f:	83 e8 30             	sub    $0x30,%eax
     d12:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     d14:	83 fe 09             	cmp    $0x9,%esi
     d17:	76 06                	jbe    d1f <strtoul+0xc4>
    break;
     d19:	90                   	nop
     d1a:	e9 87 00 00 00       	jmp    da6 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     d1f:	89 f8                	mov    %edi,%eax
     d21:	c1 e0 02             	shl    $0x2,%eax
     d24:	01 f8                	add    %edi,%eax
     d26:	01 c0                	add    %eax,%eax
     d28:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     d2b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     d32:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     d33:	eb d5                	jmp    d0a <strtoul+0xaf>
    } else if (base == 16) {
     d35:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     d39:	75 35                	jne    d70 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     d3b:	8a 03                	mov    (%ebx),%al
     d3d:	0f be c0             	movsbl %al,%eax
     d40:	83 e8 30             	sub    $0x30,%eax
     d43:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     d45:	83 fe 4a             	cmp    $0x4a,%esi
     d48:	76 02                	jbe    d4c <strtoul+0xf1>
    break;
     d4a:	eb 22                	jmp    d6e <strtoul+0x113>
      }
      digit = cvtIn[digit];
     d4c:	8a 86 40 1c 00 00    	mov    0x1c40(%esi),%al
     d52:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     d55:	83 fe 0f             	cmp    $0xf,%esi
     d58:	76 02                	jbe    d5c <strtoul+0x101>
    break;
     d5a:	eb 12                	jmp    d6e <strtoul+0x113>
      }
      result = (result << 4) + digit;
     d5c:	89 f8                	mov    %edi,%eax
     d5e:	c1 e0 04             	shl    $0x4,%eax
     d61:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     d64:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     d6b:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     d6c:	eb cd                	jmp    d3b <strtoul+0xe0>
     d6e:	eb 36                	jmp    da6 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     d70:	8a 03                	mov    (%ebx),%al
     d72:	0f be c0             	movsbl %al,%eax
     d75:	83 e8 30             	sub    $0x30,%eax
     d78:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     d7a:	83 fe 4a             	cmp    $0x4a,%esi
     d7d:	76 02                	jbe    d81 <strtoul+0x126>
    break;
     d7f:	eb 25                	jmp    da6 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     d81:	8a 86 40 1c 00 00    	mov    0x1c40(%esi),%al
     d87:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     d8a:	8b 45 10             	mov    0x10(%ebp),%eax
     d8d:	39 f0                	cmp    %esi,%eax
     d8f:	77 02                	ja     d93 <strtoul+0x138>
    break;
     d91:	eb 13                	jmp    da6 <strtoul+0x14b>
      }
      result = result*base + digit;
     d93:	8b 45 10             	mov    0x10(%ebp),%eax
     d96:	0f af c7             	imul   %edi,%eax
     d99:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     d9c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     da3:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     da4:	eb ca                	jmp    d70 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     da6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     daa:	75 03                	jne    daf <strtoul+0x154>
  p = string;
     dac:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     daf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     db3:	74 05                	je     dba <strtoul+0x15f>
  *endPtr = p;
     db5:	8b 45 0c             	mov    0xc(%ebp),%eax
     db8:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     dba:	89 f8                	mov    %edi,%eax
}
     dbc:	83 c4 14             	add    $0x14,%esp
     dbf:	5b                   	pop    %ebx
     dc0:	5e                   	pop    %esi
     dc1:	5f                   	pop    %edi
     dc2:	5d                   	pop    %ebp
     dc3:	c3                   	ret    

00000dc4 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     dc4:	55                   	push   %ebp
     dc5:	89 e5                	mov    %esp,%ebp
     dc7:	53                   	push   %ebx
     dc8:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     dcb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     dce:	eb 01                	jmp    dd1 <strtol+0xd>
      p += 1;
     dd0:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     dd1:	8a 03                	mov    (%ebx),%al
     dd3:	0f b6 c0             	movzbl %al,%eax
     dd6:	89 04 24             	mov    %eax,(%esp)
     dd9:	e8 3f fe ff ff       	call   c1d <isspace>
     dde:	85 c0                	test   %eax,%eax
     de0:	75 ee                	jne    dd0 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     de2:	8a 03                	mov    (%ebx),%al
     de4:	3c 2d                	cmp    $0x2d,%al
     de6:	75 1e                	jne    e06 <strtol+0x42>
  p += 1;
     de8:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     de9:	8b 45 10             	mov    0x10(%ebp),%eax
     dec:	89 44 24 08          	mov    %eax,0x8(%esp)
     df0:	8b 45 0c             	mov    0xc(%ebp),%eax
     df3:	89 44 24 04          	mov    %eax,0x4(%esp)
     df7:	89 1c 24             	mov    %ebx,(%esp)
     dfa:	e8 5c fe ff ff       	call   c5b <strtoul>
     dff:	f7 d8                	neg    %eax
     e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
     e04:	eb 20                	jmp    e26 <strtol+0x62>
    } else {
  if (*p == '+') {
     e06:	8a 03                	mov    (%ebx),%al
     e08:	3c 2b                	cmp    $0x2b,%al
     e0a:	75 01                	jne    e0d <strtol+0x49>
      p += 1;
     e0c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     e0d:	8b 45 10             	mov    0x10(%ebp),%eax
     e10:	89 44 24 08          	mov    %eax,0x8(%esp)
     e14:	8b 45 0c             	mov    0xc(%ebp),%eax
     e17:	89 44 24 04          	mov    %eax,0x4(%esp)
     e1b:	89 1c 24             	mov    %ebx,(%esp)
     e1e:	e8 38 fe ff ff       	call   c5b <strtoul>
     e23:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     e26:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     e2a:	75 17                	jne    e43 <strtol+0x7f>
     e2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e30:	74 11                	je     e43 <strtol+0x7f>
     e32:	8b 45 0c             	mov    0xc(%ebp),%eax
     e35:	8b 00                	mov    (%eax),%eax
     e37:	39 d8                	cmp    %ebx,%eax
     e39:	75 08                	jne    e43 <strtol+0x7f>
  *endPtr = string;
     e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
     e3e:	8b 55 08             	mov    0x8(%ebp),%edx
     e41:	89 10                	mov    %edx,(%eax)
    }
    return result;
     e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     e46:	83 c4 1c             	add    $0x1c,%esp
     e49:	5b                   	pop    %ebx
     e4a:	5d                   	pop    %ebp
     e4b:	c3                   	ret    

00000e4c <gets>:

char*
gets(char *buf, int max)
{
     e4c:	55                   	push   %ebp
     e4d:	89 e5                	mov    %esp,%ebp
     e4f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e59:	eb 49                	jmp    ea4 <gets+0x58>
    cc = read(0, &c, 1);
     e5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e62:	00 
     e63:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e66:	89 44 24 04          	mov    %eax,0x4(%esp)
     e6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e71:	e8 3e 01 00 00       	call   fb4 <read>
     e76:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e7d:	7f 02                	jg     e81 <gets+0x35>
      break;
     e7f:	eb 2c                	jmp    ead <gets+0x61>
    buf[i++] = c;
     e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e84:	8d 50 01             	lea    0x1(%eax),%edx
     e87:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e8a:	89 c2                	mov    %eax,%edx
     e8c:	8b 45 08             	mov    0x8(%ebp),%eax
     e8f:	01 c2                	add    %eax,%edx
     e91:	8a 45 ef             	mov    -0x11(%ebp),%al
     e94:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e96:	8a 45 ef             	mov    -0x11(%ebp),%al
     e99:	3c 0a                	cmp    $0xa,%al
     e9b:	74 10                	je     ead <gets+0x61>
     e9d:	8a 45 ef             	mov    -0x11(%ebp),%al
     ea0:	3c 0d                	cmp    $0xd,%al
     ea2:	74 09                	je     ead <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ea7:	40                   	inc    %eax
     ea8:	3b 45 0c             	cmp    0xc(%ebp),%eax
     eab:	7c ae                	jl     e5b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     ead:	8b 55 f4             	mov    -0xc(%ebp),%edx
     eb0:	8b 45 08             	mov    0x8(%ebp),%eax
     eb3:	01 d0                	add    %edx,%eax
     eb5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     eb8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ebb:	c9                   	leave  
     ebc:	c3                   	ret    

00000ebd <stat>:

int
stat(char *n, struct stat *st)
{
     ebd:	55                   	push   %ebp
     ebe:	89 e5                	mov    %esp,%ebp
     ec0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ec3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     eca:	00 
     ecb:	8b 45 08             	mov    0x8(%ebp),%eax
     ece:	89 04 24             	mov    %eax,(%esp)
     ed1:	e8 06 01 00 00       	call   fdc <open>
     ed6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     ed9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     edd:	79 07                	jns    ee6 <stat+0x29>
    return -1;
     edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ee4:	eb 23                	jmp    f09 <stat+0x4c>
  r = fstat(fd, st);
     ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ee9:	89 44 24 04          	mov    %eax,0x4(%esp)
     eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ef0:	89 04 24             	mov    %eax,(%esp)
     ef3:	e8 fc 00 00 00       	call   ff4 <fstat>
     ef8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     efe:	89 04 24             	mov    %eax,(%esp)
     f01:	e8 be 00 00 00       	call   fc4 <close>
  return r;
     f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     f09:	c9                   	leave  
     f0a:	c3                   	ret    

00000f0b <atoi>:

int
atoi(const char *s)
{
     f0b:	55                   	push   %ebp
     f0c:	89 e5                	mov    %esp,%ebp
     f0e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     f11:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     f18:	eb 24                	jmp    f3e <atoi+0x33>
    n = n*10 + *s++ - '0';
     f1a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f1d:	89 d0                	mov    %edx,%eax
     f1f:	c1 e0 02             	shl    $0x2,%eax
     f22:	01 d0                	add    %edx,%eax
     f24:	01 c0                	add    %eax,%eax
     f26:	89 c1                	mov    %eax,%ecx
     f28:	8b 45 08             	mov    0x8(%ebp),%eax
     f2b:	8d 50 01             	lea    0x1(%eax),%edx
     f2e:	89 55 08             	mov    %edx,0x8(%ebp)
     f31:	8a 00                	mov    (%eax),%al
     f33:	0f be c0             	movsbl %al,%eax
     f36:	01 c8                	add    %ecx,%eax
     f38:	83 e8 30             	sub    $0x30,%eax
     f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     f3e:	8b 45 08             	mov    0x8(%ebp),%eax
     f41:	8a 00                	mov    (%eax),%al
     f43:	3c 2f                	cmp    $0x2f,%al
     f45:	7e 09                	jle    f50 <atoi+0x45>
     f47:	8b 45 08             	mov    0x8(%ebp),%eax
     f4a:	8a 00                	mov    (%eax),%al
     f4c:	3c 39                	cmp    $0x39,%al
     f4e:	7e ca                	jle    f1a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f50:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f53:	c9                   	leave  
     f54:	c3                   	ret    

00000f55 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f55:	55                   	push   %ebp
     f56:	89 e5                	mov    %esp,%ebp
     f58:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     f5b:	8b 45 08             	mov    0x8(%ebp),%eax
     f5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f61:	8b 45 0c             	mov    0xc(%ebp),%eax
     f64:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f67:	eb 16                	jmp    f7f <memmove+0x2a>
    *dst++ = *src++;
     f69:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f6c:	8d 50 01             	lea    0x1(%eax),%edx
     f6f:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f72:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f75:	8d 4a 01             	lea    0x1(%edx),%ecx
     f78:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f7b:	8a 12                	mov    (%edx),%dl
     f7d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f7f:	8b 45 10             	mov    0x10(%ebp),%eax
     f82:	8d 50 ff             	lea    -0x1(%eax),%edx
     f85:	89 55 10             	mov    %edx,0x10(%ebp)
     f88:	85 c0                	test   %eax,%eax
     f8a:	7f dd                	jg     f69 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f8c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f8f:	c9                   	leave  
     f90:	c3                   	ret    
     f91:	90                   	nop
     f92:	90                   	nop
     f93:	90                   	nop

00000f94 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f94:	b8 01 00 00 00       	mov    $0x1,%eax
     f99:	cd 40                	int    $0x40
     f9b:	c3                   	ret    

00000f9c <exit>:
SYSCALL(exit)
     f9c:	b8 02 00 00 00       	mov    $0x2,%eax
     fa1:	cd 40                	int    $0x40
     fa3:	c3                   	ret    

00000fa4 <wait>:
SYSCALL(wait)
     fa4:	b8 03 00 00 00       	mov    $0x3,%eax
     fa9:	cd 40                	int    $0x40
     fab:	c3                   	ret    

00000fac <pipe>:
SYSCALL(pipe)
     fac:	b8 04 00 00 00       	mov    $0x4,%eax
     fb1:	cd 40                	int    $0x40
     fb3:	c3                   	ret    

00000fb4 <read>:
SYSCALL(read)
     fb4:	b8 05 00 00 00       	mov    $0x5,%eax
     fb9:	cd 40                	int    $0x40
     fbb:	c3                   	ret    

00000fbc <write>:
SYSCALL(write)
     fbc:	b8 10 00 00 00       	mov    $0x10,%eax
     fc1:	cd 40                	int    $0x40
     fc3:	c3                   	ret    

00000fc4 <close>:
SYSCALL(close)
     fc4:	b8 15 00 00 00       	mov    $0x15,%eax
     fc9:	cd 40                	int    $0x40
     fcb:	c3                   	ret    

00000fcc <kill>:
SYSCALL(kill)
     fcc:	b8 06 00 00 00       	mov    $0x6,%eax
     fd1:	cd 40                	int    $0x40
     fd3:	c3                   	ret    

00000fd4 <exec>:
SYSCALL(exec)
     fd4:	b8 07 00 00 00       	mov    $0x7,%eax
     fd9:	cd 40                	int    $0x40
     fdb:	c3                   	ret    

00000fdc <open>:
SYSCALL(open)
     fdc:	b8 0f 00 00 00       	mov    $0xf,%eax
     fe1:	cd 40                	int    $0x40
     fe3:	c3                   	ret    

00000fe4 <mknod>:
SYSCALL(mknod)
     fe4:	b8 11 00 00 00       	mov    $0x11,%eax
     fe9:	cd 40                	int    $0x40
     feb:	c3                   	ret    

00000fec <unlink>:
SYSCALL(unlink)
     fec:	b8 12 00 00 00       	mov    $0x12,%eax
     ff1:	cd 40                	int    $0x40
     ff3:	c3                   	ret    

00000ff4 <fstat>:
SYSCALL(fstat)
     ff4:	b8 08 00 00 00       	mov    $0x8,%eax
     ff9:	cd 40                	int    $0x40
     ffb:	c3                   	ret    

00000ffc <link>:
SYSCALL(link)
     ffc:	b8 13 00 00 00       	mov    $0x13,%eax
    1001:	cd 40                	int    $0x40
    1003:	c3                   	ret    

00001004 <mkdir>:
SYSCALL(mkdir)
    1004:	b8 14 00 00 00       	mov    $0x14,%eax
    1009:	cd 40                	int    $0x40
    100b:	c3                   	ret    

0000100c <chdir>:
SYSCALL(chdir)
    100c:	b8 09 00 00 00       	mov    $0x9,%eax
    1011:	cd 40                	int    $0x40
    1013:	c3                   	ret    

00001014 <dup>:
SYSCALL(dup)
    1014:	b8 0a 00 00 00       	mov    $0xa,%eax
    1019:	cd 40                	int    $0x40
    101b:	c3                   	ret    

0000101c <getpid>:
SYSCALL(getpid)
    101c:	b8 0b 00 00 00       	mov    $0xb,%eax
    1021:	cd 40                	int    $0x40
    1023:	c3                   	ret    

00001024 <sbrk>:
SYSCALL(sbrk)
    1024:	b8 0c 00 00 00       	mov    $0xc,%eax
    1029:	cd 40                	int    $0x40
    102b:	c3                   	ret    

0000102c <sleep>:
SYSCALL(sleep)
    102c:	b8 0d 00 00 00       	mov    $0xd,%eax
    1031:	cd 40                	int    $0x40
    1033:	c3                   	ret    

00001034 <uptime>:
SYSCALL(uptime)
    1034:	b8 0e 00 00 00       	mov    $0xe,%eax
    1039:	cd 40                	int    $0x40
    103b:	c3                   	ret    

0000103c <getname>:
SYSCALL(getname)
    103c:	b8 16 00 00 00       	mov    $0x16,%eax
    1041:	cd 40                	int    $0x40
    1043:	c3                   	ret    

00001044 <setname>:
SYSCALL(setname)
    1044:	b8 17 00 00 00       	mov    $0x17,%eax
    1049:	cd 40                	int    $0x40
    104b:	c3                   	ret    

0000104c <getmaxproc>:
SYSCALL(getmaxproc)
    104c:	b8 18 00 00 00       	mov    $0x18,%eax
    1051:	cd 40                	int    $0x40
    1053:	c3                   	ret    

00001054 <setmaxproc>:
SYSCALL(setmaxproc)
    1054:	b8 19 00 00 00       	mov    $0x19,%eax
    1059:	cd 40                	int    $0x40
    105b:	c3                   	ret    

0000105c <getmaxmem>:
SYSCALL(getmaxmem)
    105c:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1061:	cd 40                	int    $0x40
    1063:	c3                   	ret    

00001064 <setmaxmem>:
SYSCALL(setmaxmem)
    1064:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1069:	cd 40                	int    $0x40
    106b:	c3                   	ret    

0000106c <getmaxdisk>:
SYSCALL(getmaxdisk)
    106c:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1071:	cd 40                	int    $0x40
    1073:	c3                   	ret    

00001074 <setmaxdisk>:
SYSCALL(setmaxdisk)
    1074:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1079:	cd 40                	int    $0x40
    107b:	c3                   	ret    

0000107c <getusedmem>:
SYSCALL(getusedmem)
    107c:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1081:	cd 40                	int    $0x40
    1083:	c3                   	ret    

00001084 <setusedmem>:
SYSCALL(setusedmem)
    1084:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1089:	cd 40                	int    $0x40
    108b:	c3                   	ret    

0000108c <getuseddisk>:
SYSCALL(getuseddisk)
    108c:	b8 20 00 00 00       	mov    $0x20,%eax
    1091:	cd 40                	int    $0x40
    1093:	c3                   	ret    

00001094 <setuseddisk>:
SYSCALL(setuseddisk)
    1094:	b8 21 00 00 00       	mov    $0x21,%eax
    1099:	cd 40                	int    $0x40
    109b:	c3                   	ret    

0000109c <setvc>:
SYSCALL(setvc)
    109c:	b8 22 00 00 00       	mov    $0x22,%eax
    10a1:	cd 40                	int    $0x40
    10a3:	c3                   	ret    

000010a4 <setactivefs>:
SYSCALL(setactivefs)
    10a4:	b8 24 00 00 00       	mov    $0x24,%eax
    10a9:	cd 40                	int    $0x40
    10ab:	c3                   	ret    

000010ac <getactivefs>:
SYSCALL(getactivefs)
    10ac:	b8 25 00 00 00       	mov    $0x25,%eax
    10b1:	cd 40                	int    $0x40
    10b3:	c3                   	ret    

000010b4 <getvcfs>:
SYSCALL(getvcfs)
    10b4:	b8 23 00 00 00       	mov    $0x23,%eax
    10b9:	cd 40                	int    $0x40
    10bb:	c3                   	ret    

000010bc <getcwd>:
SYSCALL(getcwd)
    10bc:	b8 26 00 00 00       	mov    $0x26,%eax
    10c1:	cd 40                	int    $0x40
    10c3:	c3                   	ret    

000010c4 <tostring>:
SYSCALL(tostring)
    10c4:	b8 27 00 00 00       	mov    $0x27,%eax
    10c9:	cd 40                	int    $0x40
    10cb:	c3                   	ret    

000010cc <getactivefsindex>:
SYSCALL(getactivefsindex)
    10cc:	b8 28 00 00 00       	mov    $0x28,%eax
    10d1:	cd 40                	int    $0x40
    10d3:	c3                   	ret    

000010d4 <setatroot>:
SYSCALL(setatroot)
    10d4:	b8 2a 00 00 00       	mov    $0x2a,%eax
    10d9:	cd 40                	int    $0x40
    10db:	c3                   	ret    

000010dc <getatroot>:
SYSCALL(getatroot)
    10dc:	b8 29 00 00 00       	mov    $0x29,%eax
    10e1:	cd 40                	int    $0x40
    10e3:	c3                   	ret    

000010e4 <getpath>:
SYSCALL(getpath)
    10e4:	b8 2b 00 00 00       	mov    $0x2b,%eax
    10e9:	cd 40                	int    $0x40
    10eb:	c3                   	ret    

000010ec <setpath>:
SYSCALL(setpath)
    10ec:	b8 2c 00 00 00       	mov    $0x2c,%eax
    10f1:	cd 40                	int    $0x40
    10f3:	c3                   	ret    

000010f4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    10f4:	55                   	push   %ebp
    10f5:	89 e5                	mov    %esp,%ebp
    10f7:	83 ec 18             	sub    $0x18,%esp
    10fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    10fd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1100:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1107:	00 
    1108:	8d 45 f4             	lea    -0xc(%ebp),%eax
    110b:	89 44 24 04          	mov    %eax,0x4(%esp)
    110f:	8b 45 08             	mov    0x8(%ebp),%eax
    1112:	89 04 24             	mov    %eax,(%esp)
    1115:	e8 a2 fe ff ff       	call   fbc <write>
}
    111a:	c9                   	leave  
    111b:	c3                   	ret    

0000111c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    111c:	55                   	push   %ebp
    111d:	89 e5                	mov    %esp,%ebp
    111f:	56                   	push   %esi
    1120:	53                   	push   %ebx
    1121:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1124:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    112b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    112f:	74 17                	je     1148 <printint+0x2c>
    1131:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1135:	79 11                	jns    1148 <printint+0x2c>
    neg = 1;
    1137:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    113e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1141:	f7 d8                	neg    %eax
    1143:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1146:	eb 06                	jmp    114e <printint+0x32>
  } else {
    x = xx;
    1148:	8b 45 0c             	mov    0xc(%ebp),%eax
    114b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    114e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1155:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1158:	8d 41 01             	lea    0x1(%ecx),%eax
    115b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    115e:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1161:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1164:	ba 00 00 00 00       	mov    $0x0,%edx
    1169:	f7 f3                	div    %ebx
    116b:	89 d0                	mov    %edx,%eax
    116d:	8a 80 8c 1c 00 00    	mov    0x1c8c(%eax),%al
    1173:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1177:	8b 75 10             	mov    0x10(%ebp),%esi
    117a:	8b 45 ec             	mov    -0x14(%ebp),%eax
    117d:	ba 00 00 00 00       	mov    $0x0,%edx
    1182:	f7 f6                	div    %esi
    1184:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1187:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    118b:	75 c8                	jne    1155 <printint+0x39>
  if(neg)
    118d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1191:	74 10                	je     11a3 <printint+0x87>
    buf[i++] = '-';
    1193:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1196:	8d 50 01             	lea    0x1(%eax),%edx
    1199:	89 55 f4             	mov    %edx,-0xc(%ebp)
    119c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    11a1:	eb 1e                	jmp    11c1 <printint+0xa5>
    11a3:	eb 1c                	jmp    11c1 <printint+0xa5>
    putc(fd, buf[i]);
    11a5:	8d 55 dc             	lea    -0x24(%ebp),%edx
    11a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ab:	01 d0                	add    %edx,%eax
    11ad:	8a 00                	mov    (%eax),%al
    11af:	0f be c0             	movsbl %al,%eax
    11b2:	89 44 24 04          	mov    %eax,0x4(%esp)
    11b6:	8b 45 08             	mov    0x8(%ebp),%eax
    11b9:	89 04 24             	mov    %eax,(%esp)
    11bc:	e8 33 ff ff ff       	call   10f4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    11c1:	ff 4d f4             	decl   -0xc(%ebp)
    11c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    11c8:	79 db                	jns    11a5 <printint+0x89>
    putc(fd, buf[i]);
}
    11ca:	83 c4 30             	add    $0x30,%esp
    11cd:	5b                   	pop    %ebx
    11ce:	5e                   	pop    %esi
    11cf:	5d                   	pop    %ebp
    11d0:	c3                   	ret    

000011d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    11d1:	55                   	push   %ebp
    11d2:	89 e5                	mov    %esp,%ebp
    11d4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    11d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    11de:	8d 45 0c             	lea    0xc(%ebp),%eax
    11e1:	83 c0 04             	add    $0x4,%eax
    11e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    11e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    11ee:	e9 77 01 00 00       	jmp    136a <printf+0x199>
    c = fmt[i] & 0xff;
    11f3:	8b 55 0c             	mov    0xc(%ebp),%edx
    11f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11f9:	01 d0                	add    %edx,%eax
    11fb:	8a 00                	mov    (%eax),%al
    11fd:	0f be c0             	movsbl %al,%eax
    1200:	25 ff 00 00 00       	and    $0xff,%eax
    1205:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1208:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    120c:	75 2c                	jne    123a <printf+0x69>
      if(c == '%'){
    120e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1212:	75 0c                	jne    1220 <printf+0x4f>
        state = '%';
    1214:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    121b:	e9 47 01 00 00       	jmp    1367 <printf+0x196>
      } else {
        putc(fd, c);
    1220:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1223:	0f be c0             	movsbl %al,%eax
    1226:	89 44 24 04          	mov    %eax,0x4(%esp)
    122a:	8b 45 08             	mov    0x8(%ebp),%eax
    122d:	89 04 24             	mov    %eax,(%esp)
    1230:	e8 bf fe ff ff       	call   10f4 <putc>
    1235:	e9 2d 01 00 00       	jmp    1367 <printf+0x196>
      }
    } else if(state == '%'){
    123a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    123e:	0f 85 23 01 00 00    	jne    1367 <printf+0x196>
      if(c == 'd'){
    1244:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1248:	75 2d                	jne    1277 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    124a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    124d:	8b 00                	mov    (%eax),%eax
    124f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1256:	00 
    1257:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    125e:	00 
    125f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1263:	8b 45 08             	mov    0x8(%ebp),%eax
    1266:	89 04 24             	mov    %eax,(%esp)
    1269:	e8 ae fe ff ff       	call   111c <printint>
        ap++;
    126e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1272:	e9 e9 00 00 00       	jmp    1360 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    1277:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    127b:	74 06                	je     1283 <printf+0xb2>
    127d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1281:	75 2d                	jne    12b0 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    1283:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1286:	8b 00                	mov    (%eax),%eax
    1288:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    128f:	00 
    1290:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1297:	00 
    1298:	89 44 24 04          	mov    %eax,0x4(%esp)
    129c:	8b 45 08             	mov    0x8(%ebp),%eax
    129f:	89 04 24             	mov    %eax,(%esp)
    12a2:	e8 75 fe ff ff       	call   111c <printint>
        ap++;
    12a7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    12ab:	e9 b0 00 00 00       	jmp    1360 <printf+0x18f>
      } else if(c == 's'){
    12b0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    12b4:	75 42                	jne    12f8 <printf+0x127>
        s = (char*)*ap;
    12b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    12b9:	8b 00                	mov    (%eax),%eax
    12bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    12be:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    12c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12c6:	75 09                	jne    12d1 <printf+0x100>
          s = "(null)";
    12c8:	c7 45 f4 e5 17 00 00 	movl   $0x17e5,-0xc(%ebp)
        while(*s != 0){
    12cf:	eb 1c                	jmp    12ed <printf+0x11c>
    12d1:	eb 1a                	jmp    12ed <printf+0x11c>
          putc(fd, *s);
    12d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12d6:	8a 00                	mov    (%eax),%al
    12d8:	0f be c0             	movsbl %al,%eax
    12db:	89 44 24 04          	mov    %eax,0x4(%esp)
    12df:	8b 45 08             	mov    0x8(%ebp),%eax
    12e2:	89 04 24             	mov    %eax,(%esp)
    12e5:	e8 0a fe ff ff       	call   10f4 <putc>
          s++;
    12ea:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    12ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f0:	8a 00                	mov    (%eax),%al
    12f2:	84 c0                	test   %al,%al
    12f4:	75 dd                	jne    12d3 <printf+0x102>
    12f6:	eb 68                	jmp    1360 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    12f8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    12fc:	75 1d                	jne    131b <printf+0x14a>
        putc(fd, *ap);
    12fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1301:	8b 00                	mov    (%eax),%eax
    1303:	0f be c0             	movsbl %al,%eax
    1306:	89 44 24 04          	mov    %eax,0x4(%esp)
    130a:	8b 45 08             	mov    0x8(%ebp),%eax
    130d:	89 04 24             	mov    %eax,(%esp)
    1310:	e8 df fd ff ff       	call   10f4 <putc>
        ap++;
    1315:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1319:	eb 45                	jmp    1360 <printf+0x18f>
      } else if(c == '%'){
    131b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    131f:	75 17                	jne    1338 <printf+0x167>
        putc(fd, c);
    1321:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1324:	0f be c0             	movsbl %al,%eax
    1327:	89 44 24 04          	mov    %eax,0x4(%esp)
    132b:	8b 45 08             	mov    0x8(%ebp),%eax
    132e:	89 04 24             	mov    %eax,(%esp)
    1331:	e8 be fd ff ff       	call   10f4 <putc>
    1336:	eb 28                	jmp    1360 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1338:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    133f:	00 
    1340:	8b 45 08             	mov    0x8(%ebp),%eax
    1343:	89 04 24             	mov    %eax,(%esp)
    1346:	e8 a9 fd ff ff       	call   10f4 <putc>
        putc(fd, c);
    134b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    134e:	0f be c0             	movsbl %al,%eax
    1351:	89 44 24 04          	mov    %eax,0x4(%esp)
    1355:	8b 45 08             	mov    0x8(%ebp),%eax
    1358:	89 04 24             	mov    %eax,(%esp)
    135b:	e8 94 fd ff ff       	call   10f4 <putc>
      }
      state = 0;
    1360:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1367:	ff 45 f0             	incl   -0x10(%ebp)
    136a:	8b 55 0c             	mov    0xc(%ebp),%edx
    136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1370:	01 d0                	add    %edx,%eax
    1372:	8a 00                	mov    (%eax),%al
    1374:	84 c0                	test   %al,%al
    1376:	0f 85 77 fe ff ff    	jne    11f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    137c:	c9                   	leave  
    137d:	c3                   	ret    
    137e:	90                   	nop
    137f:	90                   	nop

00001380 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1380:	55                   	push   %ebp
    1381:	89 e5                	mov    %esp,%ebp
    1383:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1386:	8b 45 08             	mov    0x8(%ebp),%eax
    1389:	83 e8 08             	sub    $0x8,%eax
    138c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    138f:	a1 b0 1c 00 00       	mov    0x1cb0,%eax
    1394:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1397:	eb 24                	jmp    13bd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1399:	8b 45 fc             	mov    -0x4(%ebp),%eax
    139c:	8b 00                	mov    (%eax),%eax
    139e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    13a1:	77 12                	ja     13b5 <free+0x35>
    13a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13a6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    13a9:	77 24                	ja     13cf <free+0x4f>
    13ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13ae:	8b 00                	mov    (%eax),%eax
    13b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    13b3:	77 1a                	ja     13cf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    13b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13b8:	8b 00                	mov    (%eax),%eax
    13ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
    13bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13c0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    13c3:	76 d4                	jbe    1399 <free+0x19>
    13c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13c8:	8b 00                	mov    (%eax),%eax
    13ca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    13cd:	76 ca                	jbe    1399 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    13cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13d2:	8b 40 04             	mov    0x4(%eax),%eax
    13d5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    13dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13df:	01 c2                	add    %eax,%edx
    13e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13e4:	8b 00                	mov    (%eax),%eax
    13e6:	39 c2                	cmp    %eax,%edx
    13e8:	75 24                	jne    140e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    13ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13ed:	8b 50 04             	mov    0x4(%eax),%edx
    13f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13f3:	8b 00                	mov    (%eax),%eax
    13f5:	8b 40 04             	mov    0x4(%eax),%eax
    13f8:	01 c2                	add    %eax,%edx
    13fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13fd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1400:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1403:	8b 00                	mov    (%eax),%eax
    1405:	8b 10                	mov    (%eax),%edx
    1407:	8b 45 f8             	mov    -0x8(%ebp),%eax
    140a:	89 10                	mov    %edx,(%eax)
    140c:	eb 0a                	jmp    1418 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    140e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1411:	8b 10                	mov    (%eax),%edx
    1413:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1416:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1418:	8b 45 fc             	mov    -0x4(%ebp),%eax
    141b:	8b 40 04             	mov    0x4(%eax),%eax
    141e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1425:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1428:	01 d0                	add    %edx,%eax
    142a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    142d:	75 20                	jne    144f <free+0xcf>
    p->s.size += bp->s.size;
    142f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1432:	8b 50 04             	mov    0x4(%eax),%edx
    1435:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1438:	8b 40 04             	mov    0x4(%eax),%eax
    143b:	01 c2                	add    %eax,%edx
    143d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1440:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1443:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1446:	8b 10                	mov    (%eax),%edx
    1448:	8b 45 fc             	mov    -0x4(%ebp),%eax
    144b:	89 10                	mov    %edx,(%eax)
    144d:	eb 08                	jmp    1457 <free+0xd7>
  } else
    p->s.ptr = bp;
    144f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1452:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1455:	89 10                	mov    %edx,(%eax)
  freep = p;
    1457:	8b 45 fc             	mov    -0x4(%ebp),%eax
    145a:	a3 b0 1c 00 00       	mov    %eax,0x1cb0
}
    145f:	c9                   	leave  
    1460:	c3                   	ret    

00001461 <morecore>:

static Header*
morecore(uint nu)
{
    1461:	55                   	push   %ebp
    1462:	89 e5                	mov    %esp,%ebp
    1464:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1467:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    146e:	77 07                	ja     1477 <morecore+0x16>
    nu = 4096;
    1470:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1477:	8b 45 08             	mov    0x8(%ebp),%eax
    147a:	c1 e0 03             	shl    $0x3,%eax
    147d:	89 04 24             	mov    %eax,(%esp)
    1480:	e8 9f fb ff ff       	call   1024 <sbrk>
    1485:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1488:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    148c:	75 07                	jne    1495 <morecore+0x34>
    return 0;
    148e:	b8 00 00 00 00       	mov    $0x0,%eax
    1493:	eb 22                	jmp    14b7 <morecore+0x56>
  hp = (Header*)p;
    1495:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1498:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    149b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    149e:	8b 55 08             	mov    0x8(%ebp),%edx
    14a1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    14a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14a7:	83 c0 08             	add    $0x8,%eax
    14aa:	89 04 24             	mov    %eax,(%esp)
    14ad:	e8 ce fe ff ff       	call   1380 <free>
  return freep;
    14b2:	a1 b0 1c 00 00       	mov    0x1cb0,%eax
}
    14b7:	c9                   	leave  
    14b8:	c3                   	ret    

000014b9 <malloc>:

void*
malloc(uint nbytes)
{
    14b9:	55                   	push   %ebp
    14ba:	89 e5                	mov    %esp,%ebp
    14bc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    14bf:	8b 45 08             	mov    0x8(%ebp),%eax
    14c2:	83 c0 07             	add    $0x7,%eax
    14c5:	c1 e8 03             	shr    $0x3,%eax
    14c8:	40                   	inc    %eax
    14c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    14cc:	a1 b0 1c 00 00       	mov    0x1cb0,%eax
    14d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    14d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14d8:	75 23                	jne    14fd <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    14da:	c7 45 f0 a8 1c 00 00 	movl   $0x1ca8,-0x10(%ebp)
    14e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14e4:	a3 b0 1c 00 00       	mov    %eax,0x1cb0
    14e9:	a1 b0 1c 00 00       	mov    0x1cb0,%eax
    14ee:	a3 a8 1c 00 00       	mov    %eax,0x1ca8
    base.s.size = 0;
    14f3:	c7 05 ac 1c 00 00 00 	movl   $0x0,0x1cac
    14fa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1500:	8b 00                	mov    (%eax),%eax
    1502:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1505:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1508:	8b 40 04             	mov    0x4(%eax),%eax
    150b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    150e:	72 4d                	jb     155d <malloc+0xa4>
      if(p->s.size == nunits)
    1510:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1513:	8b 40 04             	mov    0x4(%eax),%eax
    1516:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1519:	75 0c                	jne    1527 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    151b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    151e:	8b 10                	mov    (%eax),%edx
    1520:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1523:	89 10                	mov    %edx,(%eax)
    1525:	eb 26                	jmp    154d <malloc+0x94>
      else {
        p->s.size -= nunits;
    1527:	8b 45 f4             	mov    -0xc(%ebp),%eax
    152a:	8b 40 04             	mov    0x4(%eax),%eax
    152d:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1530:	89 c2                	mov    %eax,%edx
    1532:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1535:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1538:	8b 45 f4             	mov    -0xc(%ebp),%eax
    153b:	8b 40 04             	mov    0x4(%eax),%eax
    153e:	c1 e0 03             	shl    $0x3,%eax
    1541:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1544:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1547:	8b 55 ec             	mov    -0x14(%ebp),%edx
    154a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    154d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1550:	a3 b0 1c 00 00       	mov    %eax,0x1cb0
      return (void*)(p + 1);
    1555:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1558:	83 c0 08             	add    $0x8,%eax
    155b:	eb 38                	jmp    1595 <malloc+0xdc>
    }
    if(p == freep)
    155d:	a1 b0 1c 00 00       	mov    0x1cb0,%eax
    1562:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1565:	75 1b                	jne    1582 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1567:	8b 45 ec             	mov    -0x14(%ebp),%eax
    156a:	89 04 24             	mov    %eax,(%esp)
    156d:	e8 ef fe ff ff       	call   1461 <morecore>
    1572:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1575:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1579:	75 07                	jne    1582 <malloc+0xc9>
        return 0;
    157b:	b8 00 00 00 00       	mov    $0x0,%eax
    1580:	eb 13                	jmp    1595 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1582:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1585:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1588:	8b 45 f4             	mov    -0xc(%ebp),%eax
    158b:	8b 00                	mov    (%eax),%eax
    158d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1590:	e9 70 ff ff ff       	jmp    1505 <malloc+0x4c>
}
    1595:	c9                   	leave  
    1596:	c3                   	ret    
