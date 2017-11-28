
_ctool:     file format elf32-i386


Disassembly of section .text:

00000000 <itoa>:
#include "stat.h"
#include "user.h"
#include "container.h"

char* itoa(int num, char* str, int base)
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
      18:	75 26                	jne    40 <itoa+0x40>
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
        return str;
      38:	8b 45 0c             	mov    0xc(%ebp),%eax
      3b:	e9 ab 00 00 00       	jmp    eb <itoa+0xeb>
    }
 
    while (num != 0)
      40:	eb 36                	jmp    78 <itoa+0x78>
    {
        rem = num % base;
      42:	8b 45 08             	mov    0x8(%ebp),%eax
      45:	99                   	cltd   
      46:	f7 7d 10             	idivl  0x10(%ebp)
      49:	89 55 fc             	mov    %edx,-0x4(%ebp)
        if(rem > 9)
      4c:	83 7d fc 09          	cmpl   $0x9,-0x4(%ebp)
      50:	7e 04                	jle    56 <itoa+0x56>
        {
            rem = rem - 10;
      52:	83 6d fc 0a          	subl   $0xa,-0x4(%ebp)
        }
        /* Add the digit as a string */
        str[i++] = rem + '0';
      56:	8b 45 f8             	mov    -0x8(%ebp),%eax
      59:	8d 50 01             	lea    0x1(%eax),%edx
      5c:	89 55 f8             	mov    %edx,-0x8(%ebp)
      5f:	89 c2                	mov    %eax,%edx
      61:	8b 45 0c             	mov    0xc(%ebp),%eax
      64:	01 c2                	add    %eax,%edx
      66:	8b 45 fc             	mov    -0x4(%ebp),%eax
      69:	83 c0 30             	add    $0x30,%eax
      6c:	88 02                	mov    %al,(%edx)
        num = num/base;
      6e:	8b 45 08             	mov    0x8(%ebp),%eax
      71:	99                   	cltd   
      72:	f7 7d 10             	idivl  0x10(%ebp)
      75:	89 45 08             	mov    %eax,0x8(%ebp)
        str[i++] = '0';
        str[i] = '\0';
        return str;
    }
 
    while (num != 0)
      78:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      7c:	75 c4                	jne    42 <itoa+0x42>
        /* Add the digit as a string */
        str[i++] = rem + '0';
        num = num/base;
    }

    str[i] = '\0';
      7e:	8b 55 f8             	mov    -0x8(%ebp),%edx
      81:	8b 45 0c             	mov    0xc(%ebp),%eax
      84:	01 d0                	add    %edx,%eax
      86:	c6 00 00             	movb   $0x0,(%eax)

    for(j = 0; j < i / 2; j++)
      89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      90:	eb 45                	jmp    d7 <itoa+0xd7>
    {
        temp = str[j];
      92:	8b 55 f4             	mov    -0xc(%ebp),%edx
      95:	8b 45 0c             	mov    0xc(%ebp),%eax
      98:	01 d0                	add    %edx,%eax
      9a:	8a 00                	mov    (%eax),%al
      9c:	88 45 f3             	mov    %al,-0xd(%ebp)
        str[j] = str[i - j - 1];
      9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
      a2:	8b 45 0c             	mov    0xc(%ebp),%eax
      a5:	01 c2                	add    %eax,%edx
      a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
      aa:	8b 4d f8             	mov    -0x8(%ebp),%ecx
      ad:	29 c1                	sub    %eax,%ecx
      af:	89 c8                	mov    %ecx,%eax
      b1:	8d 48 ff             	lea    -0x1(%eax),%ecx
      b4:	8b 45 0c             	mov    0xc(%ebp),%eax
      b7:	01 c8                	add    %ecx,%eax
      b9:	8a 00                	mov    (%eax),%al
      bb:	88 02                	mov    %al,(%edx)
        str[i - j - 1] = temp;
      bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
      c0:	8b 55 f8             	mov    -0x8(%ebp),%edx
      c3:	29 c2                	sub    %eax,%edx
      c5:	89 d0                	mov    %edx,%eax
      c7:	8d 50 ff             	lea    -0x1(%eax),%edx
      ca:	8b 45 0c             	mov    0xc(%ebp),%eax
      cd:	01 c2                	add    %eax,%edx
      cf:	8a 45 f3             	mov    -0xd(%ebp),%al
      d2:	88 02                	mov    %al,(%edx)
        num = num/base;
    }

    str[i] = '\0';

    for(j = 0; j < i / 2; j++)
      d4:	ff 45 f4             	incl   -0xc(%ebp)
      d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
      da:	89 c2                	mov    %eax,%edx
      dc:	c1 ea 1f             	shr    $0x1f,%edx
      df:	01 d0                	add    %edx,%eax
      e1:	d1 f8                	sar    %eax
      e3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
      e6:	7f aa                	jg     92 <itoa+0x92>
        temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }
 
    return str;
      e8:	8b 45 0c             	mov    0xc(%ebp),%eax
}
      eb:	c9                   	leave  
      ec:	c3                   	ret    

000000ed <print_usage>:



void print_usage(int mode){
      ed:	55                   	push   %ebp
      ee:	89 e5                	mov    %esp,%ebp
      f0:	83 ec 18             	sub    $0x18,%esp

  if(mode == 0){ // not enough arguments
      f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      f7:	75 14                	jne    10d <print_usage+0x20>
    printf(1, "Usage: ctool <mode> <args>\n");
      f9:	c7 44 24 04 44 15 00 	movl   $0x1544,0x4(%esp)
     100:	00 
     101:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     108:	e8 70 10 00 00       	call   117d <printf>
  }
  if(mode == 1){ // create
     10d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     111:	75 14                	jne    127 <print_usage+0x3a>
    printf(1, "Usage: ctool create <container> <max proc> <max mem> <max disk> <exec1> <exec2> ...\n");
     113:	c7 44 24 04 60 15 00 	movl   $0x1560,0x4(%esp)
     11a:	00 
     11b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     122:	e8 56 10 00 00       	call   117d <printf>
  }
  if(mode == 2){ // create with container created
     127:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
     12b:	75 14                	jne    141 <print_usage+0x54>
    printf(1, "Container taken. Failed to create, exiting...\n");
     12d:	c7 44 24 04 b8 15 00 	movl   $0x15b8,0x4(%esp)
     134:	00 
     135:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     13c:	e8 3c 10 00 00       	call   117d <printf>
  }
  if(mode == 3){ // start
     141:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
     145:	75 14                	jne    15b <print_usage+0x6e>
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
     147:	c7 44 24 04 e8 15 00 	movl   $0x15e8,0x4(%esp)
     14e:	00 
     14f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     156:	e8 22 10 00 00       	call   117d <printf>
  }
  if(mode == 4){ // delete
     15b:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     15f:	75 14                	jne    175 <print_usage+0x88>
    printf(1, "Usage: ctool delete <container>\n");
     161:	c7 44 24 04 1c 16 00 	movl   $0x161c,0x4(%esp)
     168:	00 
     169:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     170:	e8 08 10 00 00       	call   117d <printf>
  }
  
  exit();
     175:	e8 de 0d 00 00       	call   f58 <exit>

0000017a <start>:
}

// ctool start vc0 c0 usfsh
int start(int argc, char *argv[]){
     17a:	55                   	push   %ebp
     17b:	89 e5                	mov    %esp,%ebp
     17d:	53                   	push   %ebx
     17e:	83 ec 34             	sub    $0x34,%esp
  int id, fd, cindex = 1, ppid = getpid();
     181:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
     188:	e8 4b 0e 00 00       	call   fd8 <getpid>
     18d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  char index[2];
  index[0] = argv[3][strlen(argv[3])-1];
     190:	8b 45 0c             	mov    0xc(%ebp),%eax
     193:	83 c0 0c             	add    $0xc,%eax
     196:	8b 18                	mov    (%eax),%ebx
     198:	8b 45 0c             	mov    0xc(%ebp),%eax
     19b:	83 c0 0c             	add    $0xc,%eax
     19e:	8b 00                	mov    (%eax),%eax
     1a0:	89 04 24             	mov    %eax,(%esp)
     1a3:	e8 d9 07 00 00       	call   981 <strlen>
     1a8:	48                   	dec    %eax
     1a9:	01 d8                	add    %ebx,%eax
     1ab:	8a 00                	mov    (%eax),%al
     1ad:	88 45 e6             	mov    %al,-0x1a(%ebp)
  index[1] = '\0';
     1b0:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  cindex = atoi(index);
     1b4:	8d 45 e6             	lea    -0x1a(%ebp),%eax
     1b7:	89 04 24             	mov    %eax,(%esp)
     1ba:	e8 08 0d 00 00       	call   ec7 <atoi>
     1bf:	89 45 f4             	mov    %eax,-0xc(%ebp)

  setvc(cindex, argv[2]);
     1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
     1c5:	83 c0 08             	add    $0x8,%eax
     1c8:	8b 00                	mov    (%eax),%eax
     1ca:	89 44 24 04          	mov    %eax,0x4(%esp)
     1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1d1:	89 04 24             	mov    %eax,(%esp)
     1d4:	e8 7f 0e 00 00       	call   1058 <setvc>
  // getvcfs("vc0")

  fd = open(argv[2], O_RDWR);
     1d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     1dc:	83 c0 08             	add    $0x8,%eax
     1df:	8b 00                	mov    (%eax),%eax
     1e1:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     1e8:	00 
     1e9:	89 04 24             	mov    %eax,(%esp)
     1ec:	e8 a7 0d 00 00       	call   f98 <open>
     1f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(fd < 0){
     1f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     1f8:	79 25                	jns    21f <start+0xa5>
    printf(1, "Failed to open console %s\n", argv[2]);
     1fa:	8b 45 0c             	mov    0xc(%ebp),%eax
     1fd:	83 c0 08             	add    $0x8,%eax
     200:	8b 00                	mov    (%eax),%eax
     202:	89 44 24 08          	mov    %eax,0x8(%esp)
     206:	c7 44 24 04 3d 16 00 	movl   $0x163d,0x4(%esp)
     20d:	00 
     20e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     215:	e8 63 0f 00 00       	call   117d <printf>
    exit();
     21a:	e8 39 0d 00 00       	call   f58 <exit>
  }
  printf(1, "Opened console %s\n", argv[2]);
     21f:	8b 45 0c             	mov    0xc(%ebp),%eax
     222:	83 c0 08             	add    $0x8,%eax
     225:	8b 00                	mov    (%eax),%eax
     227:	89 44 24 08          	mov    %eax,0x8(%esp)
     22b:	c7 44 24 04 58 16 00 	movl   $0x1658,0x4(%esp)
     232:	00 
     233:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     23a:	e8 3e 0f 00 00       	call   117d <printf>
  /* fork a child and exec argv[4] */
  id = fork();
     23f:	e8 0c 0d 00 00       	call   f50 <fork>
     244:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if(id == 0){
     247:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     24b:	0f 85 b3 00 00 00    	jne    304 <start+0x18a>
    close(0);
     251:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     258:	e8 23 0d 00 00       	call   f80 <close>
    close(1);
     25d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     264:	e8 17 0d 00 00       	call   f80 <close>
    close(2);
     269:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     270:	e8 0b 0d 00 00       	call   f80 <close>
    dup(fd);
     275:	8b 45 ec             	mov    -0x14(%ebp),%eax
     278:	89 04 24             	mov    %eax,(%esp)
     27b:	e8 50 0d 00 00       	call   fd0 <dup>
    dup(fd);
     280:	8b 45 ec             	mov    -0x14(%ebp),%eax
     283:	89 04 24             	mov    %eax,(%esp)
     286:	e8 45 0d 00 00       	call   fd0 <dup>
    dup(fd);
     28b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     28e:	89 04 24             	mov    %eax,(%esp)
     291:	e8 3a 0d 00 00       	call   fd0 <dup>
    if(chdir(argv[3]) < 0){
     296:	8b 45 0c             	mov    0xc(%ebp),%eax
     299:	83 c0 0c             	add    $0xc,%eax
     29c:	8b 00                	mov    (%eax),%eax
     29e:	89 04 24             	mov    %eax,(%esp)
     2a1:	e8 22 0d 00 00       	call   fc8 <chdir>
     2a6:	85 c0                	test   %eax,%eax
     2a8:	79 30                	jns    2da <start+0x160>
      printf(1, "Container %s does not exist.", argv[3]);
     2aa:	8b 45 0c             	mov    0xc(%ebp),%eax
     2ad:	83 c0 0c             	add    $0xc,%eax
     2b0:	8b 00                	mov    (%eax),%eax
     2b2:	89 44 24 08          	mov    %eax,0x8(%esp)
     2b6:	c7 44 24 04 6b 16 00 	movl   $0x166b,0x4(%esp)
     2bd:	00 
     2be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2c5:	e8 b3 0e 00 00       	call   117d <printf>
      kill(ppid);
     2ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2cd:	89 04 24             	mov    %eax,(%esp)
     2d0:	e8 b3 0c 00 00       	call   f88 <kill>
      exit();
     2d5:	e8 7e 0c 00 00       	call   f58 <exit>
    }
    exec(argv[4], &argv[4]);
     2da:	8b 45 0c             	mov    0xc(%ebp),%eax
     2dd:	8d 50 10             	lea    0x10(%eax),%edx
     2e0:	8b 45 0c             	mov    0xc(%ebp),%eax
     2e3:	83 c0 10             	add    $0x10,%eax
     2e6:	8b 00                	mov    (%eax),%eax
     2e8:	89 54 24 04          	mov    %edx,0x4(%esp)
     2ec:	89 04 24             	mov    %eax,(%esp)
     2ef:	e8 9c 0c 00 00       	call   f90 <exec>
    close(fd);
     2f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2f7:	89 04 24             	mov    %eax,(%esp)
     2fa:	e8 81 0c 00 00       	call   f80 <close>
    exit();
     2ff:	e8 54 0c 00 00       	call   f58 <exit>
  }

  return 0;
     304:	b8 00 00 00 00       	mov    $0x0,%eax
}
     309:	83 c4 34             	add    $0x34,%esp
     30c:	5b                   	pop    %ebx
     30d:	5d                   	pop    %ebp
     30e:	c3                   	ret    

0000030f <stop>:

int stop(char *argv[]){
     30f:	55                   	push   %ebp
     310:	89 e5                	mov    %esp,%ebp
  // TODO: loop through processes and kill them
  return 1;
     312:	b8 01 00 00 00       	mov    $0x1,%eax
}
     317:	5d                   	pop    %ebp
     318:	c3                   	ret    

00000319 <create>:
//     }
//   }return 1;
// }

// ctool create c0 8 8 8 cat ls echo sh ...
int create(int argc, char *argv[]){
     319:	55                   	push   %ebp
     31a:	89 e5                	mov    %esp,%ebp
     31c:	53                   	push   %ebx
     31d:	83 ec 64             	sub    $0x64,%esp
  int i, id, bytes, cindex = 0;
     320:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  // num_files = argc - 6;
  char *mkdir[2];
  // char *files[num_files];
  mkdir[0] = "mkdir";
     327:	c7 45 dc 88 16 00 00 	movl   $0x1688,-0x24(%ebp)
  mkdir[1] = argv[2];
     32e:	8b 45 0c             	mov    0xc(%ebp),%eax
     331:	8b 40 08             	mov    0x8(%eax),%eax
     334:	89 45 e0             	mov    %eax,-0x20(%ebp)

  char index[2];
  index[0] = argv[2][strlen(argv[2])-1];
     337:	8b 45 0c             	mov    0xc(%ebp),%eax
     33a:	83 c0 08             	add    $0x8,%eax
     33d:	8b 18                	mov    (%eax),%ebx
     33f:	8b 45 0c             	mov    0xc(%ebp),%eax
     342:	83 c0 08             	add    $0x8,%eax
     345:	8b 00                	mov    (%eax),%eax
     347:	89 04 24             	mov    %eax,(%esp)
     34a:	e8 32 06 00 00       	call   981 <strlen>
     34f:	48                   	dec    %eax
     350:	01 d8                	add    %ebx,%eax
     352:	8a 00                	mov    (%eax),%al
     354:	88 45 da             	mov    %al,-0x26(%ebp)
  index[1] = '\0';
     357:	c6 45 db 00          	movb   $0x0,-0x25(%ebp)
  cindex = atoi(index);
     35b:	8d 45 da             	lea    -0x26(%ebp),%eax
     35e:	89 04 24             	mov    %eax,(%esp)
     361:	e8 61 0b 00 00       	call   ec7 <atoi>
     366:	89 45 f0             	mov    %eax,-0x10(%ebp)

  setname(cindex, argv[2]);
     369:	8b 45 0c             	mov    0xc(%ebp),%eax
     36c:	83 c0 08             	add    $0x8,%eax
     36f:	8b 00                	mov    (%eax),%eax
     371:	89 44 24 04          	mov    %eax,0x4(%esp)
     375:	8b 45 f0             	mov    -0x10(%ebp),%eax
     378:	89 04 24             	mov    %eax,(%esp)
     37b:	e8 80 0c 00 00       	call   1000 <setname>
  setmaxproc(cindex, atoi(argv[3]));
     380:	8b 45 0c             	mov    0xc(%ebp),%eax
     383:	83 c0 0c             	add    $0xc,%eax
     386:	8b 00                	mov    (%eax),%eax
     388:	89 04 24             	mov    %eax,(%esp)
     38b:	e8 37 0b 00 00       	call   ec7 <atoi>
     390:	89 44 24 04          	mov    %eax,0x4(%esp)
     394:	8b 45 f0             	mov    -0x10(%ebp),%eax
     397:	89 04 24             	mov    %eax,(%esp)
     39a:	e8 71 0c 00 00       	call   1010 <setmaxproc>
  setmaxmem(cindex, atoi(argv[4]) * 1000000);
     39f:	8b 45 0c             	mov    0xc(%ebp),%eax
     3a2:	83 c0 10             	add    $0x10,%eax
     3a5:	8b 00                	mov    (%eax),%eax
     3a7:	89 04 24             	mov    %eax,(%esp)
     3aa:	e8 18 0b 00 00       	call   ec7 <atoi>
     3af:	89 c2                	mov    %eax,%edx
     3b1:	89 d0                	mov    %edx,%eax
     3b3:	c1 e0 02             	shl    $0x2,%eax
     3b6:	01 d0                	add    %edx,%eax
     3b8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3bf:	01 d0                	add    %edx,%eax
     3c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3c8:	01 d0                	add    %edx,%eax
     3ca:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3d1:	01 d0                	add    %edx,%eax
     3d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3da:	01 d0                	add    %edx,%eax
     3dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3e3:	01 d0                	add    %edx,%eax
     3e5:	c1 e0 06             	shl    $0x6,%eax
     3e8:	89 44 24 04          	mov    %eax,0x4(%esp)
     3ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3ef:	89 04 24             	mov    %eax,(%esp)
     3f2:	e8 29 0c 00 00       	call   1020 <setmaxmem>
  setmaxdisk(cindex, atoi(argv[5]) * 1000000);
     3f7:	8b 45 0c             	mov    0xc(%ebp),%eax
     3fa:	83 c0 14             	add    $0x14,%eax
     3fd:	8b 00                	mov    (%eax),%eax
     3ff:	89 04 24             	mov    %eax,(%esp)
     402:	e8 c0 0a 00 00       	call   ec7 <atoi>
     407:	89 c2                	mov    %eax,%edx
     409:	89 d0                	mov    %edx,%eax
     40b:	c1 e0 02             	shl    $0x2,%eax
     40e:	01 d0                	add    %edx,%eax
     410:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     417:	01 d0                	add    %edx,%eax
     419:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     420:	01 d0                	add    %edx,%eax
     422:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     429:	01 d0                	add    %edx,%eax
     42b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     432:	01 d0                	add    %edx,%eax
     434:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     43b:	01 d0                	add    %edx,%eax
     43d:	c1 e0 06             	shl    $0x6,%eax
     440:	89 44 24 04          	mov    %eax,0x4(%esp)
     444:	8b 45 f0             	mov    -0x10(%ebp),%eax
     447:	89 04 24             	mov    %eax,(%esp)
     44a:	e8 e1 0b 00 00       	call   1030 <setmaxdisk>
  setusedmem(cindex, 0);
     44f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     456:	00 
     457:	8b 45 f0             	mov    -0x10(%ebp),%eax
     45a:	89 04 24             	mov    %eax,(%esp)
     45d:	e8 de 0b 00 00       	call   1040 <setusedmem>
  setuseddisk(cindex, 0);
     462:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     469:	00 
     46a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     46d:	89 04 24             	mov    %eax,(%esp)
     470:	e8 db 0b 00 00       	call   1050 <setuseddisk>
  setatroot(cindex, 1);
     475:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
     47c:	00 
     47d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     480:	89 04 24             	mov    %eax,(%esp)
     483:	e8 08 0c 00 00       	call   1090 <setatroot>

  int ppid = getpid();
     488:	e8 4b 0b 00 00       	call   fd8 <getpid>
     48d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  id = fork();
     490:	e8 bb 0a 00 00       	call   f50 <fork>
     495:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(id == 0){
     498:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     49c:	75 36                	jne    4d4 <create+0x1bb>
    exec(mkdir[0], mkdir);
     49e:	8b 45 dc             	mov    -0x24(%ebp),%eax
     4a1:	8d 55 dc             	lea    -0x24(%ebp),%edx
     4a4:	89 54 24 04          	mov    %edx,0x4(%esp)
     4a8:	89 04 24             	mov    %eax,(%esp)
     4ab:	e8 e0 0a 00 00       	call   f90 <exec>
    printf(1, "Creating container failed. Container taken.\n");
     4b0:	c7 44 24 04 90 16 00 	movl   $0x1690,0x4(%esp)
     4b7:	00 
     4b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4bf:	e8 b9 0c 00 00       	call   117d <printf>
    kill(ppid);
     4c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4c7:	89 04 24             	mov    %eax,(%esp)
     4ca:	e8 b9 0a 00 00       	call   f88 <kill>
    exit();
     4cf:	e8 84 0a 00 00       	call   f58 <exit>
  }
  id = wait();
     4d4:	e8 87 0a 00 00       	call   f60 <wait>
     4d9:	89 45 e8             	mov    %eax,-0x18(%ebp)

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     4dc:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     4e3:	e9 66 01 00 00       	jmp    64e <create+0x335>
    char destination[32];

    strcpy(destination, "/");
     4e8:	c7 44 24 04 bd 16 00 	movl   $0x16bd,0x4(%esp)
     4ef:	00 
     4f0:	8d 45 b0             	lea    -0x50(%ebp),%eax
     4f3:	89 04 24             	mov    %eax,(%esp)
     4f6:	e8 d2 02 00 00       	call   7cd <strcpy>
    strcat(destination, mkdir[1]);
     4fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
     4fe:	89 44 24 04          	mov    %eax,0x4(%esp)
     502:	8d 45 b0             	lea    -0x50(%ebp),%eax
     505:	89 04 24             	mov    %eax,(%esp)
     508:	e8 ed 04 00 00       	call   9fa <strcat>
    strcat(destination, "/");
     50d:	c7 44 24 04 bd 16 00 	movl   $0x16bd,0x4(%esp)
     514:	00 
     515:	8d 45 b0             	lea    -0x50(%ebp),%eax
     518:	89 04 24             	mov    %eax,(%esp)
     51b:	e8 da 04 00 00       	call   9fa <strcat>
    strcat(destination, argv[i]);
     520:	8b 45 f4             	mov    -0xc(%ebp),%eax
     523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     52a:	8b 45 0c             	mov    0xc(%ebp),%eax
     52d:	01 d0                	add    %edx,%eax
     52f:	8b 00                	mov    (%eax),%eax
     531:	89 44 24 04          	mov    %eax,0x4(%esp)
     535:	8d 45 b0             	lea    -0x50(%ebp),%eax
     538:	89 04 24             	mov    %eax,(%esp)
     53b:	e8 ba 04 00 00       	call   9fa <strcat>
    strcat(destination, "\0");
     540:	c7 44 24 04 bf 16 00 	movl   $0x16bf,0x4(%esp)
     547:	00 
     548:	8d 45 b0             	lea    -0x50(%ebp),%eax
     54b:	89 04 24             	mov    %eax,(%esp)
     54e:	e8 a7 04 00 00       	call   9fa <strcat>

    // ctable.tuperwares[i].files[i-6] = argv[i];
    bytes = copy(argv[i], destination, getuseddisk(cindex), getmaxdisk(cindex));
     553:	8b 45 f0             	mov    -0x10(%ebp),%eax
     556:	89 04 24             	mov    %eax,(%esp)
     559:	e8 ca 0a 00 00       	call   1028 <getmaxdisk>
     55e:	89 c3                	mov    %eax,%ebx
     560:	8b 45 f0             	mov    -0x10(%ebp),%eax
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 dd 0a 00 00       	call   1048 <getuseddisk>
     56b:	8b 55 f4             	mov    -0xc(%ebp),%edx
     56e:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
     575:	8b 55 0c             	mov    0xc(%ebp),%edx
     578:	01 ca                	add    %ecx,%edx
     57a:	8b 12                	mov    (%edx),%edx
     57c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     580:	89 44 24 08          	mov    %eax,0x8(%esp)
     584:	8d 45 b0             	lea    -0x50(%ebp),%eax
     587:	89 44 24 04          	mov    %eax,0x4(%esp)
     58b:	89 14 24             	mov    %edx,(%esp)
     58e:	e8 68 02 00 00       	call   7fb <copy>
     593:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Bytes for %s: %d\n", argv[i], bytes);
     596:	8b 45 f4             	mov    -0xc(%ebp),%eax
     599:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     5a0:	8b 45 0c             	mov    0xc(%ebp),%eax
     5a3:	01 d0                	add    %edx,%eax
     5a5:	8b 00                	mov    (%eax),%eax
     5a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     5aa:	89 54 24 0c          	mov    %edx,0xc(%esp)
     5ae:	89 44 24 08          	mov    %eax,0x8(%esp)
     5b2:	c7 44 24 04 c1 16 00 	movl   $0x16c1,0x4(%esp)
     5b9:	00 
     5ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5c1:	e8 b7 0b 00 00       	call   117d <printf>

    if(bytes > 0){
     5c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
     5ca:	7e 21                	jle    5ed <create+0x2d4>
      setuseddisk(cindex, getuseddisk(cindex) + bytes);
     5cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5cf:	89 04 24             	mov    %eax,(%esp)
     5d2:	e8 71 0a 00 00       	call   1048 <getuseddisk>
     5d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     5da:	01 d0                	add    %edx,%eax
     5dc:	89 44 24 04          	mov    %eax,0x4(%esp)
     5e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     5e3:	89 04 24             	mov    %eax,(%esp)
     5e6:	e8 65 0a 00 00       	call   1050 <setuseddisk>
     5eb:	eb 5e                	jmp    64b <create+0x332>
    }
    else{
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
     5ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     5f7:	8b 45 0c             	mov    0xc(%ebp),%eax
     5fa:	01 d0                	add    %edx,%eax
     5fc:	8b 00                	mov    (%eax),%eax
     5fe:	89 44 24 08          	mov    %eax,0x8(%esp)
     602:	c7 44 24 04 d4 16 00 	movl   $0x16d4,0x4(%esp)
     609:	00 
     60a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     611:	e8 67 0b 00 00       	call   117d <printf>
      id = fork();
     616:	e8 35 09 00 00       	call   f50 <fork>
     61b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(id == 0){
     61e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     622:	75 1f                	jne    643 <create+0x32a>
        char *remove_args[2];
        remove_args[0] = "rm";
     624:	c7 45 d0 2a 17 00 00 	movl   $0x172a,-0x30(%ebp)
        remove_args[1] = destination;
     62b:	8d 45 b0             	lea    -0x50(%ebp),%eax
     62e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        exec(remove_args[0], remove_args);
     631:	8b 45 d0             	mov    -0x30(%ebp),%eax
     634:	8d 55 d0             	lea    -0x30(%ebp),%edx
     637:	89 54 24 04          	mov    %edx,0x4(%esp)
     63b:	89 04 24             	mov    %eax,(%esp)
     63e:	e8 4d 09 00 00       	call   f90 <exec>
      }
      id = wait();
     643:	e8 18 09 00 00       	call   f60 <wait>
     648:	89 45 e8             	mov    %eax,-0x18(%ebp)
    kill(ppid);
    exit();
  }
  id = wait();

  for(i = 6; i < argc; i++){ // going through ls echo cat ...
     64b:	ff 45 f4             	incl   -0xc(%ebp)
     64e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     651:	3b 45 08             	cmp    0x8(%ebp),%eax
     654:	0f 8c 8e fe ff ff    	jl     4e8 <create+0x1cf>
        exec(remove_args[0], remove_args);
      }
      id = wait();
    }
  }
  printf(1, "Total used disk: %d\n", getuseddisk(cindex));
     65a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     65d:	89 04 24             	mov    %eax,(%esp)
     660:	e8 e3 09 00 00       	call   1048 <getuseddisk>
     665:	89 44 24 08          	mov    %eax,0x8(%esp)
     669:	c7 44 24 04 2d 17 00 	movl   $0x172d,0x4(%esp)
     670:	00 
     671:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     678:	e8 00 0b 00 00       	call   117d <printf>

  // TODO: IMPLEMENT GET/SET FILES
  // ctable.tuperwares[cindex].files = files;
  return 0;
     67d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     682:	83 c4 64             	add    $0x64,%esp
     685:	5b                   	pop    %ebx
     686:	5d                   	pop    %ebp
     687:	c3                   	ret    

00000688 <to_string>:

int to_string(){
     688:	55                   	push   %ebp
     689:	89 e5                	mov    %esp,%ebp
     68b:	81 ec 18 01 00 00    	sub    $0x118,%esp
  // printf(1, "FS = %s\n", fs);
  // int active = (1 + 1) % (4 + 1);
  // printf(1, "WTF = %d\n", active);

  char containers[256];
  tostring(containers);
     691:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
     697:	89 04 24             	mov    %eax,(%esp)
     69a:	e8 e1 09 00 00       	call   1080 <tostring>
  printf(1, "%s\n", containers);
     69f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
     6a5:	89 44 24 08          	mov    %eax,0x8(%esp)
     6a9:	c7 44 24 04 42 17 00 	movl   $0x1742,0x4(%esp)
     6b0:	00 
     6b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6b8:	e8 c0 0a 00 00       	call   117d <printf>
  return 0;
     6bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6c2:	c9                   	leave  
     6c3:	c3                   	ret    

000006c4 <main>:

int main(int argc, char *argv[]){
     6c4:	55                   	push   %ebp
     6c5:	89 e5                	mov    %esp,%ebp
     6c7:	83 e4 f0             	and    $0xfffffff0,%esp
     6ca:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2){
     6cd:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     6d1:	7f 0c                	jg     6df <main+0x1b>
    print_usage(0);
     6d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     6da:	e8 0e fa ff ff       	call   ed <print_usage>
  }

  if(strcmp(argv[1], "create") == 0){
     6df:	8b 45 0c             	mov    0xc(%ebp),%eax
     6e2:	83 c0 04             	add    $0x4,%eax
     6e5:	8b 00                	mov    (%eax),%eax
     6e7:	c7 44 24 04 46 17 00 	movl   $0x1746,0x4(%esp)
     6ee:	00 
     6ef:	89 04 24             	mov    %eax,(%esp)
     6f2:	e8 04 02 00 00       	call   8fb <strcmp>
     6f7:	85 c0                	test   %eax,%eax
     6f9:	75 44                	jne    73f <main+0x7b>
    if(argc < 7){
     6fb:	83 7d 08 06          	cmpl   $0x6,0x8(%ebp)
     6ff:	7f 0c                	jg     70d <main+0x49>
      print_usage(1);
     701:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     708:	e8 e0 f9 ff ff       	call   ed <print_usage>
    }
    if(chdir(argv[2]) > 0){
     70d:	8b 45 0c             	mov    0xc(%ebp),%eax
     710:	83 c0 08             	add    $0x8,%eax
     713:	8b 00                	mov    (%eax),%eax
     715:	89 04 24             	mov    %eax,(%esp)
     718:	e8 ab 08 00 00       	call   fc8 <chdir>
     71d:	85 c0                	test   %eax,%eax
     71f:	7e 0c                	jle    72d <main+0x69>
      print_usage(2);
     721:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     728:	e8 c0 f9 ff ff       	call   ed <print_usage>
    }
    create(argc, argv);
     72d:	8b 45 0c             	mov    0xc(%ebp),%eax
     730:	89 44 24 04          	mov    %eax,0x4(%esp)
     734:	8b 45 08             	mov    0x8(%ebp),%eax
     737:	89 04 24             	mov    %eax,(%esp)
     73a:	e8 da fb ff ff       	call   319 <create>
  }

  if(strcmp(argv[1], "start") == 0){
     73f:	8b 45 0c             	mov    0xc(%ebp),%eax
     742:	83 c0 04             	add    $0x4,%eax
     745:	8b 00                	mov    (%eax),%eax
     747:	c7 44 24 04 4d 17 00 	movl   $0x174d,0x4(%esp)
     74e:	00 
     74f:	89 04 24             	mov    %eax,(%esp)
     752:	e8 a4 01 00 00       	call   8fb <strcmp>
     757:	85 c0                	test   %eax,%eax
     759:	75 24                	jne    77f <main+0xbb>
    if(argc < 5){
     75b:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     75f:	7f 0c                	jg     76d <main+0xa9>
      print_usage(3);
     761:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     768:	e8 80 f9 ff ff       	call   ed <print_usage>
    }
    start(argc, argv);
     76d:	8b 45 0c             	mov    0xc(%ebp),%eax
     770:	89 44 24 04          	mov    %eax,0x4(%esp)
     774:	8b 45 08             	mov    0x8(%ebp),%eax
     777:	89 04 24             	mov    %eax,(%esp)
     77a:	e8 fb f9 ff ff       	call   17a <start>
  }

  if(strcmp(argv[1], "string") == 0){
     77f:	8b 45 0c             	mov    0xc(%ebp),%eax
     782:	83 c0 04             	add    $0x4,%eax
     785:	8b 00                	mov    (%eax),%eax
     787:	c7 44 24 04 53 17 00 	movl   $0x1753,0x4(%esp)
     78e:	00 
     78f:	89 04 24             	mov    %eax,(%esp)
     792:	e8 64 01 00 00       	call   8fb <strcmp>
     797:	85 c0                	test   %eax,%eax
     799:	75 05                	jne    7a0 <main+0xdc>
    to_string();
     79b:	e8 e8 fe ff ff       	call   688 <to_string>
  //   if(argc < 3){
  //     print_usage(4);
  //   }
  //   delete(argv);
  // }
  exit();
     7a0:	e8 b3 07 00 00       	call   f58 <exit>
     7a5:	90                   	nop
     7a6:	90                   	nop
     7a7:	90                   	nop

000007a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     7a8:	55                   	push   %ebp
     7a9:	89 e5                	mov    %esp,%ebp
     7ab:	57                   	push   %edi
     7ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     7ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
     7b0:	8b 55 10             	mov    0x10(%ebp),%edx
     7b3:	8b 45 0c             	mov    0xc(%ebp),%eax
     7b6:	89 cb                	mov    %ecx,%ebx
     7b8:	89 df                	mov    %ebx,%edi
     7ba:	89 d1                	mov    %edx,%ecx
     7bc:	fc                   	cld    
     7bd:	f3 aa                	rep stos %al,%es:(%edi)
     7bf:	89 ca                	mov    %ecx,%edx
     7c1:	89 fb                	mov    %edi,%ebx
     7c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
     7c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     7c9:	5b                   	pop    %ebx
     7ca:	5f                   	pop    %edi
     7cb:	5d                   	pop    %ebp
     7cc:	c3                   	ret    

000007cd <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     7cd:	55                   	push   %ebp
     7ce:	89 e5                	mov    %esp,%ebp
     7d0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     7d3:	8b 45 08             	mov    0x8(%ebp),%eax
     7d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     7d9:	90                   	nop
     7da:	8b 45 08             	mov    0x8(%ebp),%eax
     7dd:	8d 50 01             	lea    0x1(%eax),%edx
     7e0:	89 55 08             	mov    %edx,0x8(%ebp)
     7e3:	8b 55 0c             	mov    0xc(%ebp),%edx
     7e6:	8d 4a 01             	lea    0x1(%edx),%ecx
     7e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     7ec:	8a 12                	mov    (%edx),%dl
     7ee:	88 10                	mov    %dl,(%eax)
     7f0:	8a 00                	mov    (%eax),%al
     7f2:	84 c0                	test   %al,%al
     7f4:	75 e4                	jne    7da <strcpy+0xd>
    ;
  return os;
     7f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     7f9:	c9                   	leave  
     7fa:	c3                   	ret    

000007fb <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     7fb:	55                   	push   %ebp
     7fc:	89 e5                	mov    %esp,%ebp
     7fe:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     801:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     808:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     80f:	00 
     810:	8b 45 08             	mov    0x8(%ebp),%eax
     813:	89 04 24             	mov    %eax,(%esp)
     816:	e8 7d 07 00 00       	call   f98 <open>
     81b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     81e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     822:	79 20                	jns    844 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     824:	8b 45 08             	mov    0x8(%ebp),%eax
     827:	89 44 24 08          	mov    %eax,0x8(%esp)
     82b:	c7 44 24 04 5a 17 00 	movl   $0x175a,0x4(%esp)
     832:	00 
     833:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     83a:	e8 3e 09 00 00       	call   117d <printf>
      exit();
     83f:	e8 14 07 00 00       	call   f58 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     844:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     84b:	00 
     84c:	8b 45 0c             	mov    0xc(%ebp),%eax
     84f:	89 04 24             	mov    %eax,(%esp)
     852:	e8 41 07 00 00       	call   f98 <open>
     857:	89 45 ec             	mov    %eax,-0x14(%ebp)
     85a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     85e:	79 20                	jns    880 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     860:	8b 45 0c             	mov    0xc(%ebp),%eax
     863:	89 44 24 08          	mov    %eax,0x8(%esp)
     867:	c7 44 24 04 75 17 00 	movl   $0x1775,0x4(%esp)
     86e:	00 
     86f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     876:	e8 02 09 00 00       	call   117d <printf>
      exit();
     87b:	e8 d8 06 00 00       	call   f58 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     880:	eb 3b                	jmp    8bd <copy+0xc2>
  {
      max = used_disk+=count;
     882:	8b 45 e8             	mov    -0x18(%ebp),%eax
     885:	01 45 10             	add    %eax,0x10(%ebp)
     888:	8b 45 10             	mov    0x10(%ebp),%eax
     88b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     88e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     891:	3b 45 14             	cmp    0x14(%ebp),%eax
     894:	7e 07                	jle    89d <copy+0xa2>
      {
        return -1;
     896:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     89b:	eb 5c                	jmp    8f9 <copy+0xfe>
      }
      bytes = bytes + count;
     89d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     8a0:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     8a3:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     8aa:	00 
     8ab:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     8ae:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8b5:	89 04 24             	mov    %eax,(%esp)
     8b8:	e8 bb 06 00 00       	call   f78 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     8bd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     8c4:	00 
     8c5:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     8c8:	89 44 24 04          	mov    %eax,0x4(%esp)
     8cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8cf:	89 04 24             	mov    %eax,(%esp)
     8d2:	e8 99 06 00 00       	call   f70 <read>
     8d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
     8da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     8de:	7f a2                	jg     882 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     8e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     8e3:	89 04 24             	mov    %eax,(%esp)
     8e6:	e8 95 06 00 00       	call   f80 <close>
  close(fd2);
     8eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8ee:	89 04 24             	mov    %eax,(%esp)
     8f1:	e8 8a 06 00 00       	call   f80 <close>
  return(bytes);
     8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8f9:	c9                   	leave  
     8fa:	c3                   	ret    

000008fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8fb:	55                   	push   %ebp
     8fc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     8fe:	eb 06                	jmp    906 <strcmp+0xb>
    p++, q++;
     900:	ff 45 08             	incl   0x8(%ebp)
     903:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     906:	8b 45 08             	mov    0x8(%ebp),%eax
     909:	8a 00                	mov    (%eax),%al
     90b:	84 c0                	test   %al,%al
     90d:	74 0e                	je     91d <strcmp+0x22>
     90f:	8b 45 08             	mov    0x8(%ebp),%eax
     912:	8a 10                	mov    (%eax),%dl
     914:	8b 45 0c             	mov    0xc(%ebp),%eax
     917:	8a 00                	mov    (%eax),%al
     919:	38 c2                	cmp    %al,%dl
     91b:	74 e3                	je     900 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     91d:	8b 45 08             	mov    0x8(%ebp),%eax
     920:	8a 00                	mov    (%eax),%al
     922:	0f b6 d0             	movzbl %al,%edx
     925:	8b 45 0c             	mov    0xc(%ebp),%eax
     928:	8a 00                	mov    (%eax),%al
     92a:	0f b6 c0             	movzbl %al,%eax
     92d:	29 c2                	sub    %eax,%edx
     92f:	89 d0                	mov    %edx,%eax
}
     931:	5d                   	pop    %ebp
     932:	c3                   	ret    

00000933 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     933:	55                   	push   %ebp
     934:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     936:	eb 09                	jmp    941 <strncmp+0xe>
    n--, p++, q++;
     938:	ff 4d 10             	decl   0x10(%ebp)
     93b:	ff 45 08             	incl   0x8(%ebp)
     93e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     941:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     945:	74 17                	je     95e <strncmp+0x2b>
     947:	8b 45 08             	mov    0x8(%ebp),%eax
     94a:	8a 00                	mov    (%eax),%al
     94c:	84 c0                	test   %al,%al
     94e:	74 0e                	je     95e <strncmp+0x2b>
     950:	8b 45 08             	mov    0x8(%ebp),%eax
     953:	8a 10                	mov    (%eax),%dl
     955:	8b 45 0c             	mov    0xc(%ebp),%eax
     958:	8a 00                	mov    (%eax),%al
     95a:	38 c2                	cmp    %al,%dl
     95c:	74 da                	je     938 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     95e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     962:	75 07                	jne    96b <strncmp+0x38>
    return 0;
     964:	b8 00 00 00 00       	mov    $0x0,%eax
     969:	eb 14                	jmp    97f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     96b:	8b 45 08             	mov    0x8(%ebp),%eax
     96e:	8a 00                	mov    (%eax),%al
     970:	0f b6 d0             	movzbl %al,%edx
     973:	8b 45 0c             	mov    0xc(%ebp),%eax
     976:	8a 00                	mov    (%eax),%al
     978:	0f b6 c0             	movzbl %al,%eax
     97b:	29 c2                	sub    %eax,%edx
     97d:	89 d0                	mov    %edx,%eax
}
     97f:	5d                   	pop    %ebp
     980:	c3                   	ret    

00000981 <strlen>:

uint
strlen(const char *s)
{
     981:	55                   	push   %ebp
     982:	89 e5                	mov    %esp,%ebp
     984:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     987:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     98e:	eb 03                	jmp    993 <strlen+0x12>
     990:	ff 45 fc             	incl   -0x4(%ebp)
     993:	8b 55 fc             	mov    -0x4(%ebp),%edx
     996:	8b 45 08             	mov    0x8(%ebp),%eax
     999:	01 d0                	add    %edx,%eax
     99b:	8a 00                	mov    (%eax),%al
     99d:	84 c0                	test   %al,%al
     99f:	75 ef                	jne    990 <strlen+0xf>
    ;
  return n;
     9a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     9a4:	c9                   	leave  
     9a5:	c3                   	ret    

000009a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     9a6:	55                   	push   %ebp
     9a7:	89 e5                	mov    %esp,%ebp
     9a9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     9ac:	8b 45 10             	mov    0x10(%ebp),%eax
     9af:	89 44 24 08          	mov    %eax,0x8(%esp)
     9b3:	8b 45 0c             	mov    0xc(%ebp),%eax
     9b6:	89 44 24 04          	mov    %eax,0x4(%esp)
     9ba:	8b 45 08             	mov    0x8(%ebp),%eax
     9bd:	89 04 24             	mov    %eax,(%esp)
     9c0:	e8 e3 fd ff ff       	call   7a8 <stosb>
  return dst;
     9c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9c8:	c9                   	leave  
     9c9:	c3                   	ret    

000009ca <strchr>:

char*
strchr(const char *s, char c)
{
     9ca:	55                   	push   %ebp
     9cb:	89 e5                	mov    %esp,%ebp
     9cd:	83 ec 04             	sub    $0x4,%esp
     9d0:	8b 45 0c             	mov    0xc(%ebp),%eax
     9d3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     9d6:	eb 12                	jmp    9ea <strchr+0x20>
    if(*s == c)
     9d8:	8b 45 08             	mov    0x8(%ebp),%eax
     9db:	8a 00                	mov    (%eax),%al
     9dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
     9e0:	75 05                	jne    9e7 <strchr+0x1d>
      return (char*)s;
     9e2:	8b 45 08             	mov    0x8(%ebp),%eax
     9e5:	eb 11                	jmp    9f8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     9e7:	ff 45 08             	incl   0x8(%ebp)
     9ea:	8b 45 08             	mov    0x8(%ebp),%eax
     9ed:	8a 00                	mov    (%eax),%al
     9ef:	84 c0                	test   %al,%al
     9f1:	75 e5                	jne    9d8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     9f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     9f8:	c9                   	leave  
     9f9:	c3                   	ret    

000009fa <strcat>:

char *
strcat(char *dest, const char *src)
{
     9fa:	55                   	push   %ebp
     9fb:	89 e5                	mov    %esp,%ebp
     9fd:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     a00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     a07:	eb 03                	jmp    a0c <strcat+0x12>
     a09:	ff 45 fc             	incl   -0x4(%ebp)
     a0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a0f:	8b 45 08             	mov    0x8(%ebp),%eax
     a12:	01 d0                	add    %edx,%eax
     a14:	8a 00                	mov    (%eax),%al
     a16:	84 c0                	test   %al,%al
     a18:	75 ef                	jne    a09 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     a1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     a21:	eb 1e                	jmp    a41 <strcat+0x47>
        dest[i+j] = src[j];
     a23:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a26:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a29:	01 d0                	add    %edx,%eax
     a2b:	89 c2                	mov    %eax,%edx
     a2d:	8b 45 08             	mov    0x8(%ebp),%eax
     a30:	01 c2                	add    %eax,%edx
     a32:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     a35:	8b 45 0c             	mov    0xc(%ebp),%eax
     a38:	01 c8                	add    %ecx,%eax
     a3a:	8a 00                	mov    (%eax),%al
     a3c:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     a3e:	ff 45 f8             	incl   -0x8(%ebp)
     a41:	8b 55 f8             	mov    -0x8(%ebp),%edx
     a44:	8b 45 0c             	mov    0xc(%ebp),%eax
     a47:	01 d0                	add    %edx,%eax
     a49:	8a 00                	mov    (%eax),%al
     a4b:	84 c0                	test   %al,%al
     a4d:	75 d4                	jne    a23 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     a52:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a55:	01 d0                	add    %edx,%eax
     a57:	89 c2                	mov    %eax,%edx
     a59:	8b 45 08             	mov    0x8(%ebp),%eax
     a5c:	01 d0                	add    %edx,%eax
     a5e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     a61:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a64:	c9                   	leave  
     a65:	c3                   	ret    

00000a66 <strstr>:

int 
strstr(char* s, char* sub)
{
     a66:	55                   	push   %ebp
     a67:	89 e5                	mov    %esp,%ebp
     a69:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     a6c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     a73:	eb 7c                	jmp    af1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     a75:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a78:	8b 45 08             	mov    0x8(%ebp),%eax
     a7b:	01 d0                	add    %edx,%eax
     a7d:	8a 10                	mov    (%eax),%dl
     a7f:	8b 45 0c             	mov    0xc(%ebp),%eax
     a82:	8a 00                	mov    (%eax),%al
     a84:	38 c2                	cmp    %al,%dl
     a86:	75 66                	jne    aee <strstr+0x88>
        {
            if(strlen(sub) == 1)
     a88:	8b 45 0c             	mov    0xc(%ebp),%eax
     a8b:	89 04 24             	mov    %eax,(%esp)
     a8e:	e8 ee fe ff ff       	call   981 <strlen>
     a93:	83 f8 01             	cmp    $0x1,%eax
     a96:	75 05                	jne    a9d <strstr+0x37>
            {  
                return i;
     a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a9b:	eb 6b                	jmp    b08 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     a9d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     aa4:	eb 3a                	jmp    ae0 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     aa6:	8b 45 f8             	mov    -0x8(%ebp),%eax
     aa9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     aac:	01 d0                	add    %edx,%eax
     aae:	89 c2                	mov    %eax,%edx
     ab0:	8b 45 08             	mov    0x8(%ebp),%eax
     ab3:	01 d0                	add    %edx,%eax
     ab5:	8a 10                	mov    (%eax),%dl
     ab7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     aba:	8b 45 0c             	mov    0xc(%ebp),%eax
     abd:	01 c8                	add    %ecx,%eax
     abf:	8a 00                	mov    (%eax),%al
     ac1:	38 c2                	cmp    %al,%dl
     ac3:	75 16                	jne    adb <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     ac5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ac8:	8d 50 01             	lea    0x1(%eax),%edx
     acb:	8b 45 0c             	mov    0xc(%ebp),%eax
     ace:	01 d0                	add    %edx,%eax
     ad0:	8a 00                	mov    (%eax),%al
     ad2:	84 c0                	test   %al,%al
     ad4:	75 07                	jne    add <strstr+0x77>
                    {
                        return i;
     ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ad9:	eb 2d                	jmp    b08 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     adb:	eb 11                	jmp    aee <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     add:	ff 45 f8             	incl   -0x8(%ebp)
     ae0:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae6:	01 d0                	add    %edx,%eax
     ae8:	8a 00                	mov    (%eax),%al
     aea:	84 c0                	test   %al,%al
     aec:	75 b8                	jne    aa6 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     aee:	ff 45 fc             	incl   -0x4(%ebp)
     af1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     af4:	8b 45 08             	mov    0x8(%ebp),%eax
     af7:	01 d0                	add    %edx,%eax
     af9:	8a 00                	mov    (%eax),%al
     afb:	84 c0                	test   %al,%al
     afd:	0f 85 72 ff ff ff    	jne    a75 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     b08:	c9                   	leave  
     b09:	c3                   	ret    

00000b0a <strtok>:

char *
strtok(char *s, const char *delim)
{
     b0a:	55                   	push   %ebp
     b0b:	89 e5                	mov    %esp,%ebp
     b0d:	53                   	push   %ebx
     b0e:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     b11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     b15:	75 08                	jne    b1f <strtok+0x15>
  s = lasts;
     b17:	a1 44 1c 00 00       	mov    0x1c44,%eax
     b1c:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     b1f:	8b 45 08             	mov    0x8(%ebp),%eax
     b22:	8d 50 01             	lea    0x1(%eax),%edx
     b25:	89 55 08             	mov    %edx,0x8(%ebp)
     b28:	8a 00                	mov    (%eax),%al
     b2a:	0f be d8             	movsbl %al,%ebx
     b2d:	85 db                	test   %ebx,%ebx
     b2f:	75 07                	jne    b38 <strtok+0x2e>
      return 0;
     b31:	b8 00 00 00 00       	mov    $0x0,%eax
     b36:	eb 58                	jmp    b90 <strtok+0x86>
    } while (strchr(delim, ch));
     b38:	88 d8                	mov    %bl,%al
     b3a:	0f be c0             	movsbl %al,%eax
     b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
     b41:	8b 45 0c             	mov    0xc(%ebp),%eax
     b44:	89 04 24             	mov    %eax,(%esp)
     b47:	e8 7e fe ff ff       	call   9ca <strchr>
     b4c:	85 c0                	test   %eax,%eax
     b4e:	75 cf                	jne    b1f <strtok+0x15>
    --s;
     b50:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     b53:	8b 45 0c             	mov    0xc(%ebp),%eax
     b56:	89 44 24 04          	mov    %eax,0x4(%esp)
     b5a:	8b 45 08             	mov    0x8(%ebp),%eax
     b5d:	89 04 24             	mov    %eax,(%esp)
     b60:	e8 31 00 00 00       	call   b96 <strcspn>
     b65:	89 c2                	mov    %eax,%edx
     b67:	8b 45 08             	mov    0x8(%ebp),%eax
     b6a:	01 d0                	add    %edx,%eax
     b6c:	a3 44 1c 00 00       	mov    %eax,0x1c44
    if (*lasts != 0)
     b71:	a1 44 1c 00 00       	mov    0x1c44,%eax
     b76:	8a 00                	mov    (%eax),%al
     b78:	84 c0                	test   %al,%al
     b7a:	74 11                	je     b8d <strtok+0x83>
  *lasts++ = 0;
     b7c:	a1 44 1c 00 00       	mov    0x1c44,%eax
     b81:	8d 50 01             	lea    0x1(%eax),%edx
     b84:	89 15 44 1c 00 00    	mov    %edx,0x1c44
     b8a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     b8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     b90:	83 c4 14             	add    $0x14,%esp
     b93:	5b                   	pop    %ebx
     b94:	5d                   	pop    %ebp
     b95:	c3                   	ret    

00000b96 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     b96:	55                   	push   %ebp
     b97:	89 e5                	mov    %esp,%ebp
     b99:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     b9c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     ba3:	eb 26                	jmp    bcb <strcspn+0x35>
        if(strchr(s2,*s1))
     ba5:	8b 45 08             	mov    0x8(%ebp),%eax
     ba8:	8a 00                	mov    (%eax),%al
     baa:	0f be c0             	movsbl %al,%eax
     bad:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb4:	89 04 24             	mov    %eax,(%esp)
     bb7:	e8 0e fe ff ff       	call   9ca <strchr>
     bbc:	85 c0                	test   %eax,%eax
     bbe:	74 05                	je     bc5 <strcspn+0x2f>
            return ret;
     bc0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bc3:	eb 12                	jmp    bd7 <strcspn+0x41>
        else
            s1++,ret++;
     bc5:	ff 45 08             	incl   0x8(%ebp)
     bc8:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     bcb:	8b 45 08             	mov    0x8(%ebp),%eax
     bce:	8a 00                	mov    (%eax),%al
     bd0:	84 c0                	test   %al,%al
     bd2:	75 d1                	jne    ba5 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     bd7:	c9                   	leave  
     bd8:	c3                   	ret    

00000bd9 <isspace>:

int
isspace(unsigned char c)
{
     bd9:	55                   	push   %ebp
     bda:	89 e5                	mov    %esp,%ebp
     bdc:	83 ec 04             	sub    $0x4,%esp
     bdf:	8b 45 08             	mov    0x8(%ebp),%eax
     be2:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     be5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     be9:	74 1e                	je     c09 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     beb:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     bef:	74 18                	je     c09 <isspace+0x30>
     bf1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     bf5:	74 12                	je     c09 <isspace+0x30>
     bf7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     bfb:	74 0c                	je     c09 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     bfd:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     c01:	74 06                	je     c09 <isspace+0x30>
     c03:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     c07:	75 07                	jne    c10 <isspace+0x37>
     c09:	b8 01 00 00 00       	mov    $0x1,%eax
     c0e:	eb 05                	jmp    c15 <isspace+0x3c>
     c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c15:	c9                   	leave  
     c16:	c3                   	ret    

00000c17 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     c17:	55                   	push   %ebp
     c18:	89 e5                	mov    %esp,%ebp
     c1a:	57                   	push   %edi
     c1b:	56                   	push   %esi
     c1c:	53                   	push   %ebx
     c1d:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     c20:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     c25:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     c2c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     c2f:	eb 01                	jmp    c32 <strtoul+0x1b>
  p += 1;
     c31:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     c32:	8a 03                	mov    (%ebx),%al
     c34:	0f b6 c0             	movzbl %al,%eax
     c37:	89 04 24             	mov    %eax,(%esp)
     c3a:	e8 9a ff ff ff       	call   bd9 <isspace>
     c3f:	85 c0                	test   %eax,%eax
     c41:	75 ee                	jne    c31 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     c43:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     c47:	75 30                	jne    c79 <strtoul+0x62>
    {
  if (*p == '0') {
     c49:	8a 03                	mov    (%ebx),%al
     c4b:	3c 30                	cmp    $0x30,%al
     c4d:	75 21                	jne    c70 <strtoul+0x59>
      p += 1;
     c4f:	43                   	inc    %ebx
      if (*p == 'x') {
     c50:	8a 03                	mov    (%ebx),%al
     c52:	3c 78                	cmp    $0x78,%al
     c54:	75 0a                	jne    c60 <strtoul+0x49>
    p += 1;
     c56:	43                   	inc    %ebx
    base = 16;
     c57:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     c5e:	eb 31                	jmp    c91 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     c60:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     c67:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     c6e:	eb 21                	jmp    c91 <strtoul+0x7a>
      }
  }
  else base = 10;
     c70:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     c77:	eb 18                	jmp    c91 <strtoul+0x7a>
    } else if (base == 16) {
     c79:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     c7d:	75 12                	jne    c91 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     c7f:	8a 03                	mov    (%ebx),%al
     c81:	3c 30                	cmp    $0x30,%al
     c83:	75 0c                	jne    c91 <strtoul+0x7a>
     c85:	8d 43 01             	lea    0x1(%ebx),%eax
     c88:	8a 00                	mov    (%eax),%al
     c8a:	3c 78                	cmp    $0x78,%al
     c8c:	75 03                	jne    c91 <strtoul+0x7a>
      p += 2;
     c8e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     c91:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     c95:	75 29                	jne    cc0 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     c97:	8a 03                	mov    (%ebx),%al
     c99:	0f be c0             	movsbl %al,%eax
     c9c:	83 e8 30             	sub    $0x30,%eax
     c9f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     ca1:	83 fe 07             	cmp    $0x7,%esi
     ca4:	76 06                	jbe    cac <strtoul+0x95>
    break;
     ca6:	90                   	nop
     ca7:	e9 b6 00 00 00       	jmp    d62 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     cac:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     cb3:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     cb6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     cbd:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     cbe:	eb d7                	jmp    c97 <strtoul+0x80>
    } else if (base == 10) {
     cc0:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     cc4:	75 2b                	jne    cf1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     cc6:	8a 03                	mov    (%ebx),%al
     cc8:	0f be c0             	movsbl %al,%eax
     ccb:	83 e8 30             	sub    $0x30,%eax
     cce:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     cd0:	83 fe 09             	cmp    $0x9,%esi
     cd3:	76 06                	jbe    cdb <strtoul+0xc4>
    break;
     cd5:	90                   	nop
     cd6:	e9 87 00 00 00       	jmp    d62 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     cdb:	89 f8                	mov    %edi,%eax
     cdd:	c1 e0 02             	shl    $0x2,%eax
     ce0:	01 f8                	add    %edi,%eax
     ce2:	01 c0                	add    %eax,%eax
     ce4:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     ce7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     cee:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     cef:	eb d5                	jmp    cc6 <strtoul+0xaf>
    } else if (base == 16) {
     cf1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     cf5:	75 35                	jne    d2c <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     cf7:	8a 03                	mov    (%ebx),%al
     cf9:	0f be c0             	movsbl %al,%eax
     cfc:	83 e8 30             	sub    $0x30,%eax
     cff:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     d01:	83 fe 4a             	cmp    $0x4a,%esi
     d04:	76 02                	jbe    d08 <strtoul+0xf1>
    break;
     d06:	eb 22                	jmp    d2a <strtoul+0x113>
      }
      digit = cvtIn[digit];
     d08:	8a 86 e0 1b 00 00    	mov    0x1be0(%esi),%al
     d0e:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     d11:	83 fe 0f             	cmp    $0xf,%esi
     d14:	76 02                	jbe    d18 <strtoul+0x101>
    break;
     d16:	eb 12                	jmp    d2a <strtoul+0x113>
      }
      result = (result << 4) + digit;
     d18:	89 f8                	mov    %edi,%eax
     d1a:	c1 e0 04             	shl    $0x4,%eax
     d1d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     d20:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     d27:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     d28:	eb cd                	jmp    cf7 <strtoul+0xe0>
     d2a:	eb 36                	jmp    d62 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     d2c:	8a 03                	mov    (%ebx),%al
     d2e:	0f be c0             	movsbl %al,%eax
     d31:	83 e8 30             	sub    $0x30,%eax
     d34:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     d36:	83 fe 4a             	cmp    $0x4a,%esi
     d39:	76 02                	jbe    d3d <strtoul+0x126>
    break;
     d3b:	eb 25                	jmp    d62 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     d3d:	8a 86 e0 1b 00 00    	mov    0x1be0(%esi),%al
     d43:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     d46:	8b 45 10             	mov    0x10(%ebp),%eax
     d49:	39 f0                	cmp    %esi,%eax
     d4b:	77 02                	ja     d4f <strtoul+0x138>
    break;
     d4d:	eb 13                	jmp    d62 <strtoul+0x14b>
      }
      result = result*base + digit;
     d4f:	8b 45 10             	mov    0x10(%ebp),%eax
     d52:	0f af c7             	imul   %edi,%eax
     d55:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     d58:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     d5f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     d60:	eb ca                	jmp    d2c <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     d62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d66:	75 03                	jne    d6b <strtoul+0x154>
  p = string;
     d68:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     d6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     d6f:	74 05                	je     d76 <strtoul+0x15f>
  *endPtr = p;
     d71:	8b 45 0c             	mov    0xc(%ebp),%eax
     d74:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     d76:	89 f8                	mov    %edi,%eax
}
     d78:	83 c4 14             	add    $0x14,%esp
     d7b:	5b                   	pop    %ebx
     d7c:	5e                   	pop    %esi
     d7d:	5f                   	pop    %edi
     d7e:	5d                   	pop    %ebp
     d7f:	c3                   	ret    

00000d80 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     d80:	55                   	push   %ebp
     d81:	89 e5                	mov    %esp,%ebp
     d83:	53                   	push   %ebx
     d84:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     d8a:	eb 01                	jmp    d8d <strtol+0xd>
      p += 1;
     d8c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     d8d:	8a 03                	mov    (%ebx),%al
     d8f:	0f b6 c0             	movzbl %al,%eax
     d92:	89 04 24             	mov    %eax,(%esp)
     d95:	e8 3f fe ff ff       	call   bd9 <isspace>
     d9a:	85 c0                	test   %eax,%eax
     d9c:	75 ee                	jne    d8c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     d9e:	8a 03                	mov    (%ebx),%al
     da0:	3c 2d                	cmp    $0x2d,%al
     da2:	75 1e                	jne    dc2 <strtol+0x42>
  p += 1;
     da4:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     da5:	8b 45 10             	mov    0x10(%ebp),%eax
     da8:	89 44 24 08          	mov    %eax,0x8(%esp)
     dac:	8b 45 0c             	mov    0xc(%ebp),%eax
     daf:	89 44 24 04          	mov    %eax,0x4(%esp)
     db3:	89 1c 24             	mov    %ebx,(%esp)
     db6:	e8 5c fe ff ff       	call   c17 <strtoul>
     dbb:	f7 d8                	neg    %eax
     dbd:	89 45 f8             	mov    %eax,-0x8(%ebp)
     dc0:	eb 20                	jmp    de2 <strtol+0x62>
    } else {
  if (*p == '+') {
     dc2:	8a 03                	mov    (%ebx),%al
     dc4:	3c 2b                	cmp    $0x2b,%al
     dc6:	75 01                	jne    dc9 <strtol+0x49>
      p += 1;
     dc8:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     dc9:	8b 45 10             	mov    0x10(%ebp),%eax
     dcc:	89 44 24 08          	mov    %eax,0x8(%esp)
     dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
     dd3:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd7:	89 1c 24             	mov    %ebx,(%esp)
     dda:	e8 38 fe ff ff       	call   c17 <strtoul>
     ddf:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     de2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     de6:	75 17                	jne    dff <strtol+0x7f>
     de8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     dec:	74 11                	je     dff <strtol+0x7f>
     dee:	8b 45 0c             	mov    0xc(%ebp),%eax
     df1:	8b 00                	mov    (%eax),%eax
     df3:	39 d8                	cmp    %ebx,%eax
     df5:	75 08                	jne    dff <strtol+0x7f>
  *endPtr = string;
     df7:	8b 45 0c             	mov    0xc(%ebp),%eax
     dfa:	8b 55 08             	mov    0x8(%ebp),%edx
     dfd:	89 10                	mov    %edx,(%eax)
    }
    return result;
     dff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     e02:	83 c4 1c             	add    $0x1c,%esp
     e05:	5b                   	pop    %ebx
     e06:	5d                   	pop    %ebp
     e07:	c3                   	ret    

00000e08 <gets>:

char*
gets(char *buf, int max)
{
     e08:	55                   	push   %ebp
     e09:	89 e5                	mov    %esp,%ebp
     e0b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e15:	eb 49                	jmp    e60 <gets+0x58>
    cc = read(0, &c, 1);
     e17:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e1e:	00 
     e1f:	8d 45 ef             	lea    -0x11(%ebp),%eax
     e22:	89 44 24 04          	mov    %eax,0x4(%esp)
     e26:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     e2d:	e8 3e 01 00 00       	call   f70 <read>
     e32:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     e35:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e39:	7f 02                	jg     e3d <gets+0x35>
      break;
     e3b:	eb 2c                	jmp    e69 <gets+0x61>
    buf[i++] = c;
     e3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e40:	8d 50 01             	lea    0x1(%eax),%edx
     e43:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e46:	89 c2                	mov    %eax,%edx
     e48:	8b 45 08             	mov    0x8(%ebp),%eax
     e4b:	01 c2                	add    %eax,%edx
     e4d:	8a 45 ef             	mov    -0x11(%ebp),%al
     e50:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     e52:	8a 45 ef             	mov    -0x11(%ebp),%al
     e55:	3c 0a                	cmp    $0xa,%al
     e57:	74 10                	je     e69 <gets+0x61>
     e59:	8a 45 ef             	mov    -0x11(%ebp),%al
     e5c:	3c 0d                	cmp    $0xd,%al
     e5e:	74 09                	je     e69 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e63:	40                   	inc    %eax
     e64:	3b 45 0c             	cmp    0xc(%ebp),%eax
     e67:	7c ae                	jl     e17 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e6c:	8b 45 08             	mov    0x8(%ebp),%eax
     e6f:	01 d0                	add    %edx,%eax
     e71:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e77:	c9                   	leave  
     e78:	c3                   	ret    

00000e79 <stat>:

int
stat(char *n, struct stat *st)
{
     e79:	55                   	push   %ebp
     e7a:	89 e5                	mov    %esp,%ebp
     e7c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e7f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e86:	00 
     e87:	8b 45 08             	mov    0x8(%ebp),%eax
     e8a:	89 04 24             	mov    %eax,(%esp)
     e8d:	e8 06 01 00 00       	call   f98 <open>
     e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     e95:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e99:	79 07                	jns    ea2 <stat+0x29>
    return -1;
     e9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     ea0:	eb 23                	jmp    ec5 <stat+0x4c>
  r = fstat(fd, st);
     ea2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea5:	89 44 24 04          	mov    %eax,0x4(%esp)
     ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eac:	89 04 24             	mov    %eax,(%esp)
     eaf:	e8 fc 00 00 00       	call   fb0 <fstat>
     eb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     eba:	89 04 24             	mov    %eax,(%esp)
     ebd:	e8 be 00 00 00       	call   f80 <close>
  return r;
     ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ec5:	c9                   	leave  
     ec6:	c3                   	ret    

00000ec7 <atoi>:

int
atoi(const char *s)
{
     ec7:	55                   	push   %ebp
     ec8:	89 e5                	mov    %esp,%ebp
     eca:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     ecd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     ed4:	eb 24                	jmp    efa <atoi+0x33>
    n = n*10 + *s++ - '0';
     ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ed9:	89 d0                	mov    %edx,%eax
     edb:	c1 e0 02             	shl    $0x2,%eax
     ede:	01 d0                	add    %edx,%eax
     ee0:	01 c0                	add    %eax,%eax
     ee2:	89 c1                	mov    %eax,%ecx
     ee4:	8b 45 08             	mov    0x8(%ebp),%eax
     ee7:	8d 50 01             	lea    0x1(%eax),%edx
     eea:	89 55 08             	mov    %edx,0x8(%ebp)
     eed:	8a 00                	mov    (%eax),%al
     eef:	0f be c0             	movsbl %al,%eax
     ef2:	01 c8                	add    %ecx,%eax
     ef4:	83 e8 30             	sub    $0x30,%eax
     ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     efa:	8b 45 08             	mov    0x8(%ebp),%eax
     efd:	8a 00                	mov    (%eax),%al
     eff:	3c 2f                	cmp    $0x2f,%al
     f01:	7e 09                	jle    f0c <atoi+0x45>
     f03:	8b 45 08             	mov    0x8(%ebp),%eax
     f06:	8a 00                	mov    (%eax),%al
     f08:	3c 39                	cmp    $0x39,%al
     f0a:	7e ca                	jle    ed6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f0f:	c9                   	leave  
     f10:	c3                   	ret    

00000f11 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     f11:	55                   	push   %ebp
     f12:	89 e5                	mov    %esp,%ebp
     f14:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     f17:	8b 45 08             	mov    0x8(%ebp),%eax
     f1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
     f20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     f23:	eb 16                	jmp    f3b <memmove+0x2a>
    *dst++ = *src++;
     f25:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f28:	8d 50 01             	lea    0x1(%eax),%edx
     f2b:	89 55 fc             	mov    %edx,-0x4(%ebp)
     f2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f31:	8d 4a 01             	lea    0x1(%edx),%ecx
     f34:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     f37:	8a 12                	mov    (%edx),%dl
     f39:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     f3b:	8b 45 10             	mov    0x10(%ebp),%eax
     f3e:	8d 50 ff             	lea    -0x1(%eax),%edx
     f41:	89 55 10             	mov    %edx,0x10(%ebp)
     f44:	85 c0                	test   %eax,%eax
     f46:	7f dd                	jg     f25 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f4b:	c9                   	leave  
     f4c:	c3                   	ret    
     f4d:	90                   	nop
     f4e:	90                   	nop
     f4f:	90                   	nop

00000f50 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     f50:	b8 01 00 00 00       	mov    $0x1,%eax
     f55:	cd 40                	int    $0x40
     f57:	c3                   	ret    

00000f58 <exit>:
SYSCALL(exit)
     f58:	b8 02 00 00 00       	mov    $0x2,%eax
     f5d:	cd 40                	int    $0x40
     f5f:	c3                   	ret    

00000f60 <wait>:
SYSCALL(wait)
     f60:	b8 03 00 00 00       	mov    $0x3,%eax
     f65:	cd 40                	int    $0x40
     f67:	c3                   	ret    

00000f68 <pipe>:
SYSCALL(pipe)
     f68:	b8 04 00 00 00       	mov    $0x4,%eax
     f6d:	cd 40                	int    $0x40
     f6f:	c3                   	ret    

00000f70 <read>:
SYSCALL(read)
     f70:	b8 05 00 00 00       	mov    $0x5,%eax
     f75:	cd 40                	int    $0x40
     f77:	c3                   	ret    

00000f78 <write>:
SYSCALL(write)
     f78:	b8 10 00 00 00       	mov    $0x10,%eax
     f7d:	cd 40                	int    $0x40
     f7f:	c3                   	ret    

00000f80 <close>:
SYSCALL(close)
     f80:	b8 15 00 00 00       	mov    $0x15,%eax
     f85:	cd 40                	int    $0x40
     f87:	c3                   	ret    

00000f88 <kill>:
SYSCALL(kill)
     f88:	b8 06 00 00 00       	mov    $0x6,%eax
     f8d:	cd 40                	int    $0x40
     f8f:	c3                   	ret    

00000f90 <exec>:
SYSCALL(exec)
     f90:	b8 07 00 00 00       	mov    $0x7,%eax
     f95:	cd 40                	int    $0x40
     f97:	c3                   	ret    

00000f98 <open>:
SYSCALL(open)
     f98:	b8 0f 00 00 00       	mov    $0xf,%eax
     f9d:	cd 40                	int    $0x40
     f9f:	c3                   	ret    

00000fa0 <mknod>:
SYSCALL(mknod)
     fa0:	b8 11 00 00 00       	mov    $0x11,%eax
     fa5:	cd 40                	int    $0x40
     fa7:	c3                   	ret    

00000fa8 <unlink>:
SYSCALL(unlink)
     fa8:	b8 12 00 00 00       	mov    $0x12,%eax
     fad:	cd 40                	int    $0x40
     faf:	c3                   	ret    

00000fb0 <fstat>:
SYSCALL(fstat)
     fb0:	b8 08 00 00 00       	mov    $0x8,%eax
     fb5:	cd 40                	int    $0x40
     fb7:	c3                   	ret    

00000fb8 <link>:
SYSCALL(link)
     fb8:	b8 13 00 00 00       	mov    $0x13,%eax
     fbd:	cd 40                	int    $0x40
     fbf:	c3                   	ret    

00000fc0 <mkdir>:
SYSCALL(mkdir)
     fc0:	b8 14 00 00 00       	mov    $0x14,%eax
     fc5:	cd 40                	int    $0x40
     fc7:	c3                   	ret    

00000fc8 <chdir>:
SYSCALL(chdir)
     fc8:	b8 09 00 00 00       	mov    $0x9,%eax
     fcd:	cd 40                	int    $0x40
     fcf:	c3                   	ret    

00000fd0 <dup>:
SYSCALL(dup)
     fd0:	b8 0a 00 00 00       	mov    $0xa,%eax
     fd5:	cd 40                	int    $0x40
     fd7:	c3                   	ret    

00000fd8 <getpid>:
SYSCALL(getpid)
     fd8:	b8 0b 00 00 00       	mov    $0xb,%eax
     fdd:	cd 40                	int    $0x40
     fdf:	c3                   	ret    

00000fe0 <sbrk>:
SYSCALL(sbrk)
     fe0:	b8 0c 00 00 00       	mov    $0xc,%eax
     fe5:	cd 40                	int    $0x40
     fe7:	c3                   	ret    

00000fe8 <sleep>:
SYSCALL(sleep)
     fe8:	b8 0d 00 00 00       	mov    $0xd,%eax
     fed:	cd 40                	int    $0x40
     fef:	c3                   	ret    

00000ff0 <uptime>:
SYSCALL(uptime)
     ff0:	b8 0e 00 00 00       	mov    $0xe,%eax
     ff5:	cd 40                	int    $0x40
     ff7:	c3                   	ret    

00000ff8 <getname>:
SYSCALL(getname)
     ff8:	b8 16 00 00 00       	mov    $0x16,%eax
     ffd:	cd 40                	int    $0x40
     fff:	c3                   	ret    

00001000 <setname>:
SYSCALL(setname)
    1000:	b8 17 00 00 00       	mov    $0x17,%eax
    1005:	cd 40                	int    $0x40
    1007:	c3                   	ret    

00001008 <getmaxproc>:
SYSCALL(getmaxproc)
    1008:	b8 18 00 00 00       	mov    $0x18,%eax
    100d:	cd 40                	int    $0x40
    100f:	c3                   	ret    

00001010 <setmaxproc>:
SYSCALL(setmaxproc)
    1010:	b8 19 00 00 00       	mov    $0x19,%eax
    1015:	cd 40                	int    $0x40
    1017:	c3                   	ret    

00001018 <getmaxmem>:
SYSCALL(getmaxmem)
    1018:	b8 1a 00 00 00       	mov    $0x1a,%eax
    101d:	cd 40                	int    $0x40
    101f:	c3                   	ret    

00001020 <setmaxmem>:
SYSCALL(setmaxmem)
    1020:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1025:	cd 40                	int    $0x40
    1027:	c3                   	ret    

00001028 <getmaxdisk>:
SYSCALL(getmaxdisk)
    1028:	b8 1c 00 00 00       	mov    $0x1c,%eax
    102d:	cd 40                	int    $0x40
    102f:	c3                   	ret    

00001030 <setmaxdisk>:
SYSCALL(setmaxdisk)
    1030:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1035:	cd 40                	int    $0x40
    1037:	c3                   	ret    

00001038 <getusedmem>:
SYSCALL(getusedmem)
    1038:	b8 1e 00 00 00       	mov    $0x1e,%eax
    103d:	cd 40                	int    $0x40
    103f:	c3                   	ret    

00001040 <setusedmem>:
SYSCALL(setusedmem)
    1040:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1045:	cd 40                	int    $0x40
    1047:	c3                   	ret    

00001048 <getuseddisk>:
SYSCALL(getuseddisk)
    1048:	b8 20 00 00 00       	mov    $0x20,%eax
    104d:	cd 40                	int    $0x40
    104f:	c3                   	ret    

00001050 <setuseddisk>:
SYSCALL(setuseddisk)
    1050:	b8 21 00 00 00       	mov    $0x21,%eax
    1055:	cd 40                	int    $0x40
    1057:	c3                   	ret    

00001058 <setvc>:
SYSCALL(setvc)
    1058:	b8 22 00 00 00       	mov    $0x22,%eax
    105d:	cd 40                	int    $0x40
    105f:	c3                   	ret    

00001060 <setactivefs>:
SYSCALL(setactivefs)
    1060:	b8 24 00 00 00       	mov    $0x24,%eax
    1065:	cd 40                	int    $0x40
    1067:	c3                   	ret    

00001068 <getactivefs>:
SYSCALL(getactivefs)
    1068:	b8 25 00 00 00       	mov    $0x25,%eax
    106d:	cd 40                	int    $0x40
    106f:	c3                   	ret    

00001070 <getvcfs>:
SYSCALL(getvcfs)
    1070:	b8 23 00 00 00       	mov    $0x23,%eax
    1075:	cd 40                	int    $0x40
    1077:	c3                   	ret    

00001078 <getcwd>:
SYSCALL(getcwd)
    1078:	b8 26 00 00 00       	mov    $0x26,%eax
    107d:	cd 40                	int    $0x40
    107f:	c3                   	ret    

00001080 <tostring>:
SYSCALL(tostring)
    1080:	b8 27 00 00 00       	mov    $0x27,%eax
    1085:	cd 40                	int    $0x40
    1087:	c3                   	ret    

00001088 <getactivefsindex>:
SYSCALL(getactivefsindex)
    1088:	b8 28 00 00 00       	mov    $0x28,%eax
    108d:	cd 40                	int    $0x40
    108f:	c3                   	ret    

00001090 <setatroot>:
SYSCALL(setatroot)
    1090:	b8 2a 00 00 00       	mov    $0x2a,%eax
    1095:	cd 40                	int    $0x40
    1097:	c3                   	ret    

00001098 <getatroot>:
SYSCALL(getatroot)
    1098:	b8 29 00 00 00       	mov    $0x29,%eax
    109d:	cd 40                	int    $0x40
    109f:	c3                   	ret    

000010a0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    10a0:	55                   	push   %ebp
    10a1:	89 e5                	mov    %esp,%ebp
    10a3:	83 ec 18             	sub    $0x18,%esp
    10a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    10ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    10b3:	00 
    10b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
    10b7:	89 44 24 04          	mov    %eax,0x4(%esp)
    10bb:	8b 45 08             	mov    0x8(%ebp),%eax
    10be:	89 04 24             	mov    %eax,(%esp)
    10c1:	e8 b2 fe ff ff       	call   f78 <write>
}
    10c6:	c9                   	leave  
    10c7:	c3                   	ret    

000010c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    10c8:	55                   	push   %ebp
    10c9:	89 e5                	mov    %esp,%ebp
    10cb:	56                   	push   %esi
    10cc:	53                   	push   %ebx
    10cd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    10d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    10d7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    10db:	74 17                	je     10f4 <printint+0x2c>
    10dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    10e1:	79 11                	jns    10f4 <printint+0x2c>
    neg = 1;
    10e3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    10ea:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ed:	f7 d8                	neg    %eax
    10ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
    10f2:	eb 06                	jmp    10fa <printint+0x32>
  } else {
    x = xx;
    10f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    10fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1101:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1104:	8d 41 01             	lea    0x1(%ecx),%eax
    1107:	89 45 f4             	mov    %eax,-0xc(%ebp)
    110a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    110d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1110:	ba 00 00 00 00       	mov    $0x0,%edx
    1115:	f7 f3                	div    %ebx
    1117:	89 d0                	mov    %edx,%eax
    1119:	8a 80 2c 1c 00 00    	mov    0x1c2c(%eax),%al
    111f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1123:	8b 75 10             	mov    0x10(%ebp),%esi
    1126:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1129:	ba 00 00 00 00       	mov    $0x0,%edx
    112e:	f7 f6                	div    %esi
    1130:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1133:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1137:	75 c8                	jne    1101 <printint+0x39>
  if(neg)
    1139:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    113d:	74 10                	je     114f <printint+0x87>
    buf[i++] = '-';
    113f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1142:	8d 50 01             	lea    0x1(%eax),%edx
    1145:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1148:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    114d:	eb 1e                	jmp    116d <printint+0xa5>
    114f:	eb 1c                	jmp    116d <printint+0xa5>
    putc(fd, buf[i]);
    1151:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1154:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1157:	01 d0                	add    %edx,%eax
    1159:	8a 00                	mov    (%eax),%al
    115b:	0f be c0             	movsbl %al,%eax
    115e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1162:	8b 45 08             	mov    0x8(%ebp),%eax
    1165:	89 04 24             	mov    %eax,(%esp)
    1168:	e8 33 ff ff ff       	call   10a0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    116d:	ff 4d f4             	decl   -0xc(%ebp)
    1170:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1174:	79 db                	jns    1151 <printint+0x89>
    putc(fd, buf[i]);
}
    1176:	83 c4 30             	add    $0x30,%esp
    1179:	5b                   	pop    %ebx
    117a:	5e                   	pop    %esi
    117b:	5d                   	pop    %ebp
    117c:	c3                   	ret    

0000117d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    117d:	55                   	push   %ebp
    117e:	89 e5                	mov    %esp,%ebp
    1180:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1183:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    118a:	8d 45 0c             	lea    0xc(%ebp),%eax
    118d:	83 c0 04             	add    $0x4,%eax
    1190:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1193:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    119a:	e9 77 01 00 00       	jmp    1316 <printf+0x199>
    c = fmt[i] & 0xff;
    119f:	8b 55 0c             	mov    0xc(%ebp),%edx
    11a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11a5:	01 d0                	add    %edx,%eax
    11a7:	8a 00                	mov    (%eax),%al
    11a9:	0f be c0             	movsbl %al,%eax
    11ac:	25 ff 00 00 00       	and    $0xff,%eax
    11b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    11b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    11b8:	75 2c                	jne    11e6 <printf+0x69>
      if(c == '%'){
    11ba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    11be:	75 0c                	jne    11cc <printf+0x4f>
        state = '%';
    11c0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    11c7:	e9 47 01 00 00       	jmp    1313 <printf+0x196>
      } else {
        putc(fd, c);
    11cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    11cf:	0f be c0             	movsbl %al,%eax
    11d2:	89 44 24 04          	mov    %eax,0x4(%esp)
    11d6:	8b 45 08             	mov    0x8(%ebp),%eax
    11d9:	89 04 24             	mov    %eax,(%esp)
    11dc:	e8 bf fe ff ff       	call   10a0 <putc>
    11e1:	e9 2d 01 00 00       	jmp    1313 <printf+0x196>
      }
    } else if(state == '%'){
    11e6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    11ea:	0f 85 23 01 00 00    	jne    1313 <printf+0x196>
      if(c == 'd'){
    11f0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    11f4:	75 2d                	jne    1223 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    11f6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    11f9:	8b 00                	mov    (%eax),%eax
    11fb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1202:	00 
    1203:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    120a:	00 
    120b:	89 44 24 04          	mov    %eax,0x4(%esp)
    120f:	8b 45 08             	mov    0x8(%ebp),%eax
    1212:	89 04 24             	mov    %eax,(%esp)
    1215:	e8 ae fe ff ff       	call   10c8 <printint>
        ap++;
    121a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    121e:	e9 e9 00 00 00       	jmp    130c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    1223:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1227:	74 06                	je     122f <printf+0xb2>
    1229:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    122d:	75 2d                	jne    125c <printf+0xdf>
        printint(fd, *ap, 16, 0);
    122f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1232:	8b 00                	mov    (%eax),%eax
    1234:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    123b:	00 
    123c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1243:	00 
    1244:	89 44 24 04          	mov    %eax,0x4(%esp)
    1248:	8b 45 08             	mov    0x8(%ebp),%eax
    124b:	89 04 24             	mov    %eax,(%esp)
    124e:	e8 75 fe ff ff       	call   10c8 <printint>
        ap++;
    1253:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1257:	e9 b0 00 00 00       	jmp    130c <printf+0x18f>
      } else if(c == 's'){
    125c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1260:	75 42                	jne    12a4 <printf+0x127>
        s = (char*)*ap;
    1262:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1265:	8b 00                	mov    (%eax),%eax
    1267:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    126a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    126e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1272:	75 09                	jne    127d <printf+0x100>
          s = "(null)";
    1274:	c7 45 f4 91 17 00 00 	movl   $0x1791,-0xc(%ebp)
        while(*s != 0){
    127b:	eb 1c                	jmp    1299 <printf+0x11c>
    127d:	eb 1a                	jmp    1299 <printf+0x11c>
          putc(fd, *s);
    127f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1282:	8a 00                	mov    (%eax),%al
    1284:	0f be c0             	movsbl %al,%eax
    1287:	89 44 24 04          	mov    %eax,0x4(%esp)
    128b:	8b 45 08             	mov    0x8(%ebp),%eax
    128e:	89 04 24             	mov    %eax,(%esp)
    1291:	e8 0a fe ff ff       	call   10a0 <putc>
          s++;
    1296:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1299:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129c:	8a 00                	mov    (%eax),%al
    129e:	84 c0                	test   %al,%al
    12a0:	75 dd                	jne    127f <printf+0x102>
    12a2:	eb 68                	jmp    130c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    12a4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    12a8:	75 1d                	jne    12c7 <printf+0x14a>
        putc(fd, *ap);
    12aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    12ad:	8b 00                	mov    (%eax),%eax
    12af:	0f be c0             	movsbl %al,%eax
    12b2:	89 44 24 04          	mov    %eax,0x4(%esp)
    12b6:	8b 45 08             	mov    0x8(%ebp),%eax
    12b9:	89 04 24             	mov    %eax,(%esp)
    12bc:	e8 df fd ff ff       	call   10a0 <putc>
        ap++;
    12c1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    12c5:	eb 45                	jmp    130c <printf+0x18f>
      } else if(c == '%'){
    12c7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    12cb:	75 17                	jne    12e4 <printf+0x167>
        putc(fd, c);
    12cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12d0:	0f be c0             	movsbl %al,%eax
    12d3:	89 44 24 04          	mov    %eax,0x4(%esp)
    12d7:	8b 45 08             	mov    0x8(%ebp),%eax
    12da:	89 04 24             	mov    %eax,(%esp)
    12dd:	e8 be fd ff ff       	call   10a0 <putc>
    12e2:	eb 28                	jmp    130c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    12e4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    12eb:	00 
    12ec:	8b 45 08             	mov    0x8(%ebp),%eax
    12ef:	89 04 24             	mov    %eax,(%esp)
    12f2:	e8 a9 fd ff ff       	call   10a0 <putc>
        putc(fd, c);
    12f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    12fa:	0f be c0             	movsbl %al,%eax
    12fd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1301:	8b 45 08             	mov    0x8(%ebp),%eax
    1304:	89 04 24             	mov    %eax,(%esp)
    1307:	e8 94 fd ff ff       	call   10a0 <putc>
      }
      state = 0;
    130c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1313:	ff 45 f0             	incl   -0x10(%ebp)
    1316:	8b 55 0c             	mov    0xc(%ebp),%edx
    1319:	8b 45 f0             	mov    -0x10(%ebp),%eax
    131c:	01 d0                	add    %edx,%eax
    131e:	8a 00                	mov    (%eax),%al
    1320:	84 c0                	test   %al,%al
    1322:	0f 85 77 fe ff ff    	jne    119f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1328:	c9                   	leave  
    1329:	c3                   	ret    
    132a:	90                   	nop
    132b:	90                   	nop

0000132c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    132c:	55                   	push   %ebp
    132d:	89 e5                	mov    %esp,%ebp
    132f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1332:	8b 45 08             	mov    0x8(%ebp),%eax
    1335:	83 e8 08             	sub    $0x8,%eax
    1338:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    133b:	a1 50 1c 00 00       	mov    0x1c50,%eax
    1340:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1343:	eb 24                	jmp    1369 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1345:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1348:	8b 00                	mov    (%eax),%eax
    134a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    134d:	77 12                	ja     1361 <free+0x35>
    134f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1352:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1355:	77 24                	ja     137b <free+0x4f>
    1357:	8b 45 fc             	mov    -0x4(%ebp),%eax
    135a:	8b 00                	mov    (%eax),%eax
    135c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    135f:	77 1a                	ja     137b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1361:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1364:	8b 00                	mov    (%eax),%eax
    1366:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1369:	8b 45 f8             	mov    -0x8(%ebp),%eax
    136c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    136f:	76 d4                	jbe    1345 <free+0x19>
    1371:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1374:	8b 00                	mov    (%eax),%eax
    1376:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1379:	76 ca                	jbe    1345 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    137b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    137e:	8b 40 04             	mov    0x4(%eax),%eax
    1381:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1388:	8b 45 f8             	mov    -0x8(%ebp),%eax
    138b:	01 c2                	add    %eax,%edx
    138d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1390:	8b 00                	mov    (%eax),%eax
    1392:	39 c2                	cmp    %eax,%edx
    1394:	75 24                	jne    13ba <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1396:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1399:	8b 50 04             	mov    0x4(%eax),%edx
    139c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    139f:	8b 00                	mov    (%eax),%eax
    13a1:	8b 40 04             	mov    0x4(%eax),%eax
    13a4:	01 c2                	add    %eax,%edx
    13a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13a9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    13ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13af:	8b 00                	mov    (%eax),%eax
    13b1:	8b 10                	mov    (%eax),%edx
    13b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13b6:	89 10                	mov    %edx,(%eax)
    13b8:	eb 0a                	jmp    13c4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    13ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13bd:	8b 10                	mov    (%eax),%edx
    13bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13c2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    13c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13c7:	8b 40 04             	mov    0x4(%eax),%eax
    13ca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    13d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13d4:	01 d0                	add    %edx,%eax
    13d6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    13d9:	75 20                	jne    13fb <free+0xcf>
    p->s.size += bp->s.size;
    13db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13de:	8b 50 04             	mov    0x4(%eax),%edx
    13e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13e4:	8b 40 04             	mov    0x4(%eax),%eax
    13e7:	01 c2                	add    %eax,%edx
    13e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13ec:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    13ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
    13f2:	8b 10                	mov    (%eax),%edx
    13f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13f7:	89 10                	mov    %edx,(%eax)
    13f9:	eb 08                	jmp    1403 <free+0xd7>
  } else
    p->s.ptr = bp;
    13fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    13fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1401:	89 10                	mov    %edx,(%eax)
  freep = p;
    1403:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1406:	a3 50 1c 00 00       	mov    %eax,0x1c50
}
    140b:	c9                   	leave  
    140c:	c3                   	ret    

0000140d <morecore>:

static Header*
morecore(uint nu)
{
    140d:	55                   	push   %ebp
    140e:	89 e5                	mov    %esp,%ebp
    1410:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1413:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    141a:	77 07                	ja     1423 <morecore+0x16>
    nu = 4096;
    141c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1423:	8b 45 08             	mov    0x8(%ebp),%eax
    1426:	c1 e0 03             	shl    $0x3,%eax
    1429:	89 04 24             	mov    %eax,(%esp)
    142c:	e8 af fb ff ff       	call   fe0 <sbrk>
    1431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1434:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1438:	75 07                	jne    1441 <morecore+0x34>
    return 0;
    143a:	b8 00 00 00 00       	mov    $0x0,%eax
    143f:	eb 22                	jmp    1463 <morecore+0x56>
  hp = (Header*)p;
    1441:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1444:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1447:	8b 45 f0             	mov    -0x10(%ebp),%eax
    144a:	8b 55 08             	mov    0x8(%ebp),%edx
    144d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1450:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1453:	83 c0 08             	add    $0x8,%eax
    1456:	89 04 24             	mov    %eax,(%esp)
    1459:	e8 ce fe ff ff       	call   132c <free>
  return freep;
    145e:	a1 50 1c 00 00       	mov    0x1c50,%eax
}
    1463:	c9                   	leave  
    1464:	c3                   	ret    

00001465 <malloc>:

void*
malloc(uint nbytes)
{
    1465:	55                   	push   %ebp
    1466:	89 e5                	mov    %esp,%ebp
    1468:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    146b:	8b 45 08             	mov    0x8(%ebp),%eax
    146e:	83 c0 07             	add    $0x7,%eax
    1471:	c1 e8 03             	shr    $0x3,%eax
    1474:	40                   	inc    %eax
    1475:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1478:	a1 50 1c 00 00       	mov    0x1c50,%eax
    147d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1480:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1484:	75 23                	jne    14a9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1486:	c7 45 f0 48 1c 00 00 	movl   $0x1c48,-0x10(%ebp)
    148d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1490:	a3 50 1c 00 00       	mov    %eax,0x1c50
    1495:	a1 50 1c 00 00       	mov    0x1c50,%eax
    149a:	a3 48 1c 00 00       	mov    %eax,0x1c48
    base.s.size = 0;
    149f:	c7 05 4c 1c 00 00 00 	movl   $0x0,0x1c4c
    14a6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14ac:	8b 00                	mov    (%eax),%eax
    14ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    14b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b4:	8b 40 04             	mov    0x4(%eax),%eax
    14b7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    14ba:	72 4d                	jb     1509 <malloc+0xa4>
      if(p->s.size == nunits)
    14bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bf:	8b 40 04             	mov    0x4(%eax),%eax
    14c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    14c5:	75 0c                	jne    14d3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    14c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ca:	8b 10                	mov    (%eax),%edx
    14cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14cf:	89 10                	mov    %edx,(%eax)
    14d1:	eb 26                	jmp    14f9 <malloc+0x94>
      else {
        p->s.size -= nunits;
    14d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d6:	8b 40 04             	mov    0x4(%eax),%eax
    14d9:	2b 45 ec             	sub    -0x14(%ebp),%eax
    14dc:	89 c2                	mov    %eax,%edx
    14de:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    14e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e7:	8b 40 04             	mov    0x4(%eax),%eax
    14ea:	c1 e0 03             	shl    $0x3,%eax
    14ed:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    14f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    14f6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    14f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    14fc:	a3 50 1c 00 00       	mov    %eax,0x1c50
      return (void*)(p + 1);
    1501:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1504:	83 c0 08             	add    $0x8,%eax
    1507:	eb 38                	jmp    1541 <malloc+0xdc>
    }
    if(p == freep)
    1509:	a1 50 1c 00 00       	mov    0x1c50,%eax
    150e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1511:	75 1b                	jne    152e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1513:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1516:	89 04 24             	mov    %eax,(%esp)
    1519:	e8 ef fe ff ff       	call   140d <morecore>
    151e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1521:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1525:	75 07                	jne    152e <malloc+0xc9>
        return 0;
    1527:	b8 00 00 00 00       	mov    $0x0,%eax
    152c:	eb 13                	jmp    1541 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    152e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1531:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1534:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1537:	8b 00                	mov    (%eax),%eax
    1539:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    153c:	e9 70 ff ff ff       	jmp    14b1 <malloc+0x4c>
}
    1541:	c9                   	leave  
    1542:	c3                   	ret    
