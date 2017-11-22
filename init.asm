
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <create_vcs>:

char *argv[] = { "sh", 0 };

void
create_vcs(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int i, fd;
  char *dname = "vc0";
   6:	c7 45 f0 96 0e 00 00 	movl   $0xe96,-0x10(%ebp)

  for (i = 0; i < 4; i++) {
   d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  14:	eb 58                	jmp    6e <create_vcs+0x6e>
    dname[2] = '0' + i;
  16:	8b 45 f0             	mov    -0x10(%ebp),%eax
  19:	8d 50 02             	lea    0x2(%eax),%edx
  1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1f:	83 c0 30             	add    $0x30,%eax
  22:	88 02                	mov    %al,(%edx)
    if ((fd = open(dname, O_RDWR)) < 0){
  24:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  2b:	00 
  2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  2f:	89 04 24             	mov    %eax,(%esp)
  32:	e8 59 09 00 00       	call   990 <open>
  37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  3e:	79 20                	jns    60 <create_vcs+0x60>
      mknod(dname, 1, i + 2);
  40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  43:	83 c0 02             	add    $0x2,%eax
  46:	98                   	cwtl   
  47:	89 44 24 08          	mov    %eax,0x8(%esp)
  4b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  52:	00 
  53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  56:	89 04 24             	mov    %eax,(%esp)
  59:	e8 3a 09 00 00       	call   998 <mknod>
  5e:	eb 0b                	jmp    6b <create_vcs+0x6b>
    } else {
      close(fd);
  60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  63:	89 04 24             	mov    %eax,(%esp)
  66:	e8 0d 09 00 00       	call   978 <close>
create_vcs(void)
{
  int i, fd;
  char *dname = "vc0";

  for (i = 0; i < 4; i++) {
  6b:	ff 45 f4             	incl   -0xc(%ebp)
  6e:	83 7d f4 03          	cmpl   $0x3,-0xc(%ebp)
  72:	7e a2                	jle    16 <create_vcs+0x16>
      mknod(dname, 1, i + 2);
    } else {
      close(fd);
    }
  }
}
  74:	c9                   	leave  
  75:	c3                   	ret    

00000076 <main>:

int
main(void)
{
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	83 e4 f0             	and    $0xfffffff0,%esp
  7c:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
  7f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  86:	00 
  87:	c7 04 24 9a 0e 00 00 	movl   $0xe9a,(%esp)
  8e:	e8 fd 08 00 00       	call   990 <open>
  93:	85 c0                	test   %eax,%eax
  95:	79 30                	jns    c7 <main+0x51>
    mknod("console", 1, 1);
  97:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  9e:	00 
  9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 9a 0e 00 00 	movl   $0xe9a,(%esp)
  ae:	e8 e5 08 00 00       	call   998 <mknod>
    open("console", O_RDWR);
  b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  ba:	00 
  bb:	c7 04 24 9a 0e 00 00 	movl   $0xe9a,(%esp)
  c2:	e8 c9 08 00 00       	call   990 <open>
  }
  dup(0);  // stdout
  c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ce:	e8 f5 08 00 00       	call   9c8 <dup>
  dup(0);  // stderr
  d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  da:	e8 e9 08 00 00       	call   9c8 <dup>

  create_vcs();
  df:	e8 1c ff ff ff       	call   0 <create_vcs>

  for(;;){
    printf(1, "init: starting sh\n");
  e4:	c7 44 24 04 a2 0e 00 	movl   $0xea2,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 d5 09 00 00       	call   acd <printf>
    pid = fork();
  f8:	e8 4b 08 00 00       	call   948 <fork>
  fd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
 101:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 106:	79 19                	jns    121 <main+0xab>
      printf(1, "init: fork failed\n");
 108:	c7 44 24 04 b5 0e 00 	movl   $0xeb5,0x4(%esp)
 10f:	00 
 110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 117:	e8 b1 09 00 00       	call   acd <printf>
      exit();
 11c:	e8 2f 08 00 00       	call   950 <exit>
    }
    if(pid == 0){
 121:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 126:	75 2d                	jne    155 <main+0xdf>
      exec("sh", argv);
 128:	c7 44 24 04 e0 12 00 	movl   $0x12e0,0x4(%esp)
 12f:	00 
 130:	c7 04 24 93 0e 00 00 	movl   $0xe93,(%esp)
 137:	e8 4c 08 00 00       	call   988 <exec>
      printf(1, "init: exec sh failed\n");
 13c:	c7 44 24 04 c8 0e 00 	movl   $0xec8,0x4(%esp)
 143:	00 
 144:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14b:	e8 7d 09 00 00       	call   acd <printf>
      exit();
 150:	e8 fb 07 00 00       	call   950 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 155:	eb 14                	jmp    16b <main+0xf5>
      printf(1, "zombie!\n");
 157:	c7 44 24 04 de 0e 00 	movl   $0xede,0x4(%esp)
 15e:	00 
 15f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 166:	e8 62 09 00 00       	call   acd <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 16b:	e8 e8 07 00 00       	call   958 <wait>
 170:	89 44 24 18          	mov    %eax,0x18(%esp)
 174:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 179:	78 0a                	js     185 <main+0x10f>
 17b:	8b 44 24 18          	mov    0x18(%esp),%eax
 17f:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 183:	75 d2                	jne    157 <main+0xe1>
      printf(1, "zombie!\n");
  }
 185:	e9 5a ff ff ff       	jmp    e4 <main+0x6e>
 18a:	90                   	nop
 18b:	90                   	nop

0000018c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 18c:	55                   	push   %ebp
 18d:	89 e5                	mov    %esp,%ebp
 18f:	57                   	push   %edi
 190:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 191:	8b 4d 08             	mov    0x8(%ebp),%ecx
 194:	8b 55 10             	mov    0x10(%ebp),%edx
 197:	8b 45 0c             	mov    0xc(%ebp),%eax
 19a:	89 cb                	mov    %ecx,%ebx
 19c:	89 df                	mov    %ebx,%edi
 19e:	89 d1                	mov    %edx,%ecx
 1a0:	fc                   	cld    
 1a1:	f3 aa                	rep stos %al,%es:(%edi)
 1a3:	89 ca                	mov    %ecx,%edx
 1a5:	89 fb                	mov    %edi,%ebx
 1a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1aa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1ad:	5b                   	pop    %ebx
 1ae:	5f                   	pop    %edi
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1bd:	90                   	nop
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	8d 50 01             	lea    0x1(%eax),%edx
 1c4:	89 55 08             	mov    %edx,0x8(%ebp)
 1c7:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ca:	8d 4a 01             	lea    0x1(%edx),%ecx
 1cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1d0:	8a 12                	mov    (%edx),%dl
 1d2:	88 10                	mov    %dl,(%eax)
 1d4:	8a 00                	mov    (%eax),%al
 1d6:	84 c0                	test   %al,%al
 1d8:	75 e4                	jne    1be <strcpy+0xd>
    ;
  return os;
 1da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1dd:	c9                   	leave  
 1de:	c3                   	ret    

000001df <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
 1e5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ec:	00 
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	89 04 24             	mov    %eax,(%esp)
 1f3:	e8 98 07 00 00       	call   990 <open>
 1f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 1fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1ff:	79 20                	jns    221 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	89 44 24 08          	mov    %eax,0x8(%esp)
 208:	c7 44 24 04 e7 0e 00 	movl   $0xee7,0x4(%esp)
 20f:	00 
 210:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 217:	e8 b1 08 00 00       	call   acd <printf>
        exit();
 21c:	e8 2f 07 00 00       	call   950 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 221:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 228:	00 
 229:	8b 45 0c             	mov    0xc(%ebp),%eax
 22c:	89 04 24             	mov    %eax,(%esp)
 22f:	e8 5c 07 00 00       	call   990 <open>
 234:	89 45 ec             	mov    %eax,-0x14(%ebp)
 237:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 23b:	79 20                	jns    25d <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	89 44 24 08          	mov    %eax,0x8(%esp)
 244:	c7 44 24 04 02 0f 00 	movl   $0xf02,0x4(%esp)
 24b:	00 
 24c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 253:	e8 75 08 00 00       	call   acd <printf>
        exit();
 258:	e8 f3 06 00 00       	call   950 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 25d:	eb 56                	jmp    2b5 <copy+0xd6>
        int max = used_disk+=count;
 25f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 262:	01 45 10             	add    %eax,0x10(%ebp)
 265:	8b 45 10             	mov    0x10(%ebp),%eax
 268:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 26b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 26e:	89 44 24 08          	mov    %eax,0x8(%esp)
 272:	c7 44 24 04 1e 0f 00 	movl   $0xf1e,0x4(%esp)
 279:	00 
 27a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 281:	e8 47 08 00 00       	call   acd <printf>
        if(max > max_disk){
 286:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 289:	3b 45 14             	cmp    0x14(%ebp),%eax
 28c:	7e 07                	jle    295 <copy+0xb6>
          return -1;
 28e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 293:	eb 5c                	jmp    2f1 <copy+0x112>
        }
        bytes = bytes + count;
 295:	8b 45 e8             	mov    -0x18(%ebp),%eax
 298:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 29b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 2a2:	00 
 2a3:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 2a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 bb 06 00 00       	call   970 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 2b5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 2bc:	00 
 2bd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 2c0:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2c7:	89 04 24             	mov    %eax,(%esp)
 2ca:	e8 99 06 00 00       	call   968 <read>
 2cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
 2d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 2d6:	7f 87                	jg     25f <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 2d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 95 06 00 00       	call   978 <close>
    close(fd2);
 2e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2e6:	89 04 24             	mov    %eax,(%esp)
 2e9:	e8 8a 06 00 00       	call   978 <close>
    return(bytes);
 2ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2f1:	c9                   	leave  
 2f2:	c3                   	ret    

000002f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2f6:	eb 06                	jmp    2fe <strcmp+0xb>
    p++, q++;
 2f8:	ff 45 08             	incl   0x8(%ebp)
 2fb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	8a 00                	mov    (%eax),%al
 303:	84 c0                	test   %al,%al
 305:	74 0e                	je     315 <strcmp+0x22>
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	8a 10                	mov    (%eax),%dl
 30c:	8b 45 0c             	mov    0xc(%ebp),%eax
 30f:	8a 00                	mov    (%eax),%al
 311:	38 c2                	cmp    %al,%dl
 313:	74 e3                	je     2f8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	8a 00                	mov    (%eax),%al
 31a:	0f b6 d0             	movzbl %al,%edx
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	8a 00                	mov    (%eax),%al
 322:	0f b6 c0             	movzbl %al,%eax
 325:	29 c2                	sub    %eax,%edx
 327:	89 d0                	mov    %edx,%eax
}
 329:	5d                   	pop    %ebp
 32a:	c3                   	ret    

0000032b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 32b:	55                   	push   %ebp
 32c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 32e:	eb 09                	jmp    339 <strncmp+0xe>
    n--, p++, q++;
 330:	ff 4d 10             	decl   0x10(%ebp)
 333:	ff 45 08             	incl   0x8(%ebp)
 336:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 339:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 33d:	74 17                	je     356 <strncmp+0x2b>
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	8a 00                	mov    (%eax),%al
 344:	84 c0                	test   %al,%al
 346:	74 0e                	je     356 <strncmp+0x2b>
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	8a 10                	mov    (%eax),%dl
 34d:	8b 45 0c             	mov    0xc(%ebp),%eax
 350:	8a 00                	mov    (%eax),%al
 352:	38 c2                	cmp    %al,%dl
 354:	74 da                	je     330 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 356:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 35a:	75 07                	jne    363 <strncmp+0x38>
    return 0;
 35c:	b8 00 00 00 00       	mov    $0x0,%eax
 361:	eb 14                	jmp    377 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	8a 00                	mov    (%eax),%al
 368:	0f b6 d0             	movzbl %al,%edx
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	8a 00                	mov    (%eax),%al
 370:	0f b6 c0             	movzbl %al,%eax
 373:	29 c2                	sub    %eax,%edx
 375:	89 d0                	mov    %edx,%eax
}
 377:	5d                   	pop    %ebp
 378:	c3                   	ret    

00000379 <strlen>:

uint
strlen(const char *s)
{
 379:	55                   	push   %ebp
 37a:	89 e5                	mov    %esp,%ebp
 37c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 37f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 386:	eb 03                	jmp    38b <strlen+0x12>
 388:	ff 45 fc             	incl   -0x4(%ebp)
 38b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 38e:	8b 45 08             	mov    0x8(%ebp),%eax
 391:	01 d0                	add    %edx,%eax
 393:	8a 00                	mov    (%eax),%al
 395:	84 c0                	test   %al,%al
 397:	75 ef                	jne    388 <strlen+0xf>
    ;
  return n;
 399:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <memset>:

void*
memset(void *dst, int c, uint n)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3a4:	8b 45 10             	mov    0x10(%ebp),%eax
 3a7:	89 44 24 08          	mov    %eax,0x8(%esp)
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	89 04 24             	mov    %eax,(%esp)
 3b8:	e8 cf fd ff ff       	call   18c <stosb>
  return dst;
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3c0:	c9                   	leave  
 3c1:	c3                   	ret    

000003c2 <strchr>:

char*
strchr(const char *s, char c)
{
 3c2:	55                   	push   %ebp
 3c3:	89 e5                	mov    %esp,%ebp
 3c5:	83 ec 04             	sub    $0x4,%esp
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3ce:	eb 12                	jmp    3e2 <strchr+0x20>
    if(*s == c)
 3d0:	8b 45 08             	mov    0x8(%ebp),%eax
 3d3:	8a 00                	mov    (%eax),%al
 3d5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3d8:	75 05                	jne    3df <strchr+0x1d>
      return (char*)s;
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	eb 11                	jmp    3f0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3df:	ff 45 08             	incl   0x8(%ebp)
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	8a 00                	mov    (%eax),%al
 3e7:	84 c0                	test   %al,%al
 3e9:	75 e5                	jne    3d0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <strcat>:

char *
strcat(char *dest, const char *src)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3f8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ff:	eb 03                	jmp    404 <strcat+0x12>
 401:	ff 45 fc             	incl   -0x4(%ebp)
 404:	8b 55 fc             	mov    -0x4(%ebp),%edx
 407:	8b 45 08             	mov    0x8(%ebp),%eax
 40a:	01 d0                	add    %edx,%eax
 40c:	8a 00                	mov    (%eax),%al
 40e:	84 c0                	test   %al,%al
 410:	75 ef                	jne    401 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 412:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 419:	eb 1e                	jmp    439 <strcat+0x47>
        dest[i+j] = src[j];
 41b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 41e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 421:	01 d0                	add    %edx,%eax
 423:	89 c2                	mov    %eax,%edx
 425:	8b 45 08             	mov    0x8(%ebp),%eax
 428:	01 c2                	add    %eax,%edx
 42a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 42d:	8b 45 0c             	mov    0xc(%ebp),%eax
 430:	01 c8                	add    %ecx,%eax
 432:	8a 00                	mov    (%eax),%al
 434:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 436:	ff 45 f8             	incl   -0x8(%ebp)
 439:	8b 55 f8             	mov    -0x8(%ebp),%edx
 43c:	8b 45 0c             	mov    0xc(%ebp),%eax
 43f:	01 d0                	add    %edx,%eax
 441:	8a 00                	mov    (%eax),%al
 443:	84 c0                	test   %al,%al
 445:	75 d4                	jne    41b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 447:	8b 45 f8             	mov    -0x8(%ebp),%eax
 44a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 44d:	01 d0                	add    %edx,%eax
 44f:	89 c2                	mov    %eax,%edx
 451:	8b 45 08             	mov    0x8(%ebp),%eax
 454:	01 d0                	add    %edx,%eax
 456:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 459:	8b 45 08             	mov    0x8(%ebp),%eax
}
 45c:	c9                   	leave  
 45d:	c3                   	ret    

0000045e <strstr>:

int 
strstr(char* s, char* sub)
{
 45e:	55                   	push   %ebp
 45f:	89 e5                	mov    %esp,%ebp
 461:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 464:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 46b:	eb 7c                	jmp    4e9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 46d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 470:	8b 45 08             	mov    0x8(%ebp),%eax
 473:	01 d0                	add    %edx,%eax
 475:	8a 10                	mov    (%eax),%dl
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	8a 00                	mov    (%eax),%al
 47c:	38 c2                	cmp    %al,%dl
 47e:	75 66                	jne    4e6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 480:	8b 45 0c             	mov    0xc(%ebp),%eax
 483:	89 04 24             	mov    %eax,(%esp)
 486:	e8 ee fe ff ff       	call   379 <strlen>
 48b:	83 f8 01             	cmp    $0x1,%eax
 48e:	75 05                	jne    495 <strstr+0x37>
            {  
                return i;
 490:	8b 45 fc             	mov    -0x4(%ebp),%eax
 493:	eb 6b                	jmp    500 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 495:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 49c:	eb 3a                	jmp    4d8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 49e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4a4:	01 d0                	add    %edx,%eax
 4a6:	89 c2                	mov    %eax,%edx
 4a8:	8b 45 08             	mov    0x8(%ebp),%eax
 4ab:	01 d0                	add    %edx,%eax
 4ad:	8a 10                	mov    (%eax),%dl
 4af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b5:	01 c8                	add    %ecx,%eax
 4b7:	8a 00                	mov    (%eax),%al
 4b9:	38 c2                	cmp    %al,%dl
 4bb:	75 16                	jne    4d3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 4bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4c0:	8d 50 01             	lea    0x1(%eax),%edx
 4c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c6:	01 d0                	add    %edx,%eax
 4c8:	8a 00                	mov    (%eax),%al
 4ca:	84 c0                	test   %al,%al
 4cc:	75 07                	jne    4d5 <strstr+0x77>
                    {
                        return i;
 4ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4d1:	eb 2d                	jmp    500 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 4d3:	eb 11                	jmp    4e6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 4d5:	ff 45 f8             	incl   -0x8(%ebp)
 4d8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4db:	8b 45 0c             	mov    0xc(%ebp),%eax
 4de:	01 d0                	add    %edx,%eax
 4e0:	8a 00                	mov    (%eax),%al
 4e2:	84 c0                	test   %al,%al
 4e4:	75 b8                	jne    49e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 4e6:	ff 45 fc             	incl   -0x4(%ebp)
 4e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
 4ef:	01 d0                	add    %edx,%eax
 4f1:	8a 00                	mov    (%eax),%al
 4f3:	84 c0                	test   %al,%al
 4f5:	0f 85 72 ff ff ff    	jne    46d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 4fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 500:	c9                   	leave  
 501:	c3                   	ret    

00000502 <strtok>:

char *
strtok(char *s, const char *delim)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	53                   	push   %ebx
 506:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 509:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 50d:	75 08                	jne    517 <strtok+0x15>
  s = lasts;
 50f:	a1 64 13 00 00       	mov    0x1364,%eax
 514:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	8d 50 01             	lea    0x1(%eax),%edx
 51d:	89 55 08             	mov    %edx,0x8(%ebp)
 520:	8a 00                	mov    (%eax),%al
 522:	0f be d8             	movsbl %al,%ebx
 525:	85 db                	test   %ebx,%ebx
 527:	75 07                	jne    530 <strtok+0x2e>
      return 0;
 529:	b8 00 00 00 00       	mov    $0x0,%eax
 52e:	eb 58                	jmp    588 <strtok+0x86>
    } while (strchr(delim, ch));
 530:	88 d8                	mov    %bl,%al
 532:	0f be c0             	movsbl %al,%eax
 535:	89 44 24 04          	mov    %eax,0x4(%esp)
 539:	8b 45 0c             	mov    0xc(%ebp),%eax
 53c:	89 04 24             	mov    %eax,(%esp)
 53f:	e8 7e fe ff ff       	call   3c2 <strchr>
 544:	85 c0                	test   %eax,%eax
 546:	75 cf                	jne    517 <strtok+0x15>
    --s;
 548:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 54b:	8b 45 0c             	mov    0xc(%ebp),%eax
 54e:	89 44 24 04          	mov    %eax,0x4(%esp)
 552:	8b 45 08             	mov    0x8(%ebp),%eax
 555:	89 04 24             	mov    %eax,(%esp)
 558:	e8 31 00 00 00       	call   58e <strcspn>
 55d:	89 c2                	mov    %eax,%edx
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	01 d0                	add    %edx,%eax
 564:	a3 64 13 00 00       	mov    %eax,0x1364
    if (*lasts != 0)
 569:	a1 64 13 00 00       	mov    0x1364,%eax
 56e:	8a 00                	mov    (%eax),%al
 570:	84 c0                	test   %al,%al
 572:	74 11                	je     585 <strtok+0x83>
  *lasts++ = 0;
 574:	a1 64 13 00 00       	mov    0x1364,%eax
 579:	8d 50 01             	lea    0x1(%eax),%edx
 57c:	89 15 64 13 00 00    	mov    %edx,0x1364
 582:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 585:	8b 45 08             	mov    0x8(%ebp),%eax
}
 588:	83 c4 14             	add    $0x14,%esp
 58b:	5b                   	pop    %ebx
 58c:	5d                   	pop    %ebp
 58d:	c3                   	ret    

0000058e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 58e:	55                   	push   %ebp
 58f:	89 e5                	mov    %esp,%ebp
 591:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 594:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 59b:	eb 26                	jmp    5c3 <strcspn+0x35>
        if(strchr(s2,*s1))
 59d:	8b 45 08             	mov    0x8(%ebp),%eax
 5a0:	8a 00                	mov    (%eax),%al
 5a2:	0f be c0             	movsbl %al,%eax
 5a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ac:	89 04 24             	mov    %eax,(%esp)
 5af:	e8 0e fe ff ff       	call   3c2 <strchr>
 5b4:	85 c0                	test   %eax,%eax
 5b6:	74 05                	je     5bd <strcspn+0x2f>
            return ret;
 5b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5bb:	eb 12                	jmp    5cf <strcspn+0x41>
        else
            s1++,ret++;
 5bd:	ff 45 08             	incl   0x8(%ebp)
 5c0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	8a 00                	mov    (%eax),%al
 5c8:	84 c0                	test   %al,%al
 5ca:	75 d1                	jne    59d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 5cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5cf:	c9                   	leave  
 5d0:	c3                   	ret    

000005d1 <isspace>:

int
isspace(unsigned char c)
{
 5d1:	55                   	push   %ebp
 5d2:	89 e5                	mov    %esp,%ebp
 5d4:	83 ec 04             	sub    $0x4,%esp
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 5dd:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 5e1:	74 1e                	je     601 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 5e3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 5e7:	74 18                	je     601 <isspace+0x30>
 5e9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 5ed:	74 12                	je     601 <isspace+0x30>
 5ef:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 5f3:	74 0c                	je     601 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 5f5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 5f9:	74 06                	je     601 <isspace+0x30>
 5fb:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 5ff:	75 07                	jne    608 <isspace+0x37>
 601:	b8 01 00 00 00       	mov    $0x1,%eax
 606:	eb 05                	jmp    60d <isspace+0x3c>
 608:	b8 00 00 00 00       	mov    $0x0,%eax
}
 60d:	c9                   	leave  
 60e:	c3                   	ret    

0000060f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 60f:	55                   	push   %ebp
 610:	89 e5                	mov    %esp,%ebp
 612:	57                   	push   %edi
 613:	56                   	push   %esi
 614:	53                   	push   %ebx
 615:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 618:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 61d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 624:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 627:	eb 01                	jmp    62a <strtoul+0x1b>
  p += 1;
 629:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 62a:	8a 03                	mov    (%ebx),%al
 62c:	0f b6 c0             	movzbl %al,%eax
 62f:	89 04 24             	mov    %eax,(%esp)
 632:	e8 9a ff ff ff       	call   5d1 <isspace>
 637:	85 c0                	test   %eax,%eax
 639:	75 ee                	jne    629 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 63b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 63f:	75 30                	jne    671 <strtoul+0x62>
    {
  if (*p == '0') {
 641:	8a 03                	mov    (%ebx),%al
 643:	3c 30                	cmp    $0x30,%al
 645:	75 21                	jne    668 <strtoul+0x59>
      p += 1;
 647:	43                   	inc    %ebx
      if (*p == 'x') {
 648:	8a 03                	mov    (%ebx),%al
 64a:	3c 78                	cmp    $0x78,%al
 64c:	75 0a                	jne    658 <strtoul+0x49>
    p += 1;
 64e:	43                   	inc    %ebx
    base = 16;
 64f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 656:	eb 31                	jmp    689 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 658:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 65f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 666:	eb 21                	jmp    689 <strtoul+0x7a>
      }
  }
  else base = 10;
 668:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 66f:	eb 18                	jmp    689 <strtoul+0x7a>
    } else if (base == 16) {
 671:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 675:	75 12                	jne    689 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 677:	8a 03                	mov    (%ebx),%al
 679:	3c 30                	cmp    $0x30,%al
 67b:	75 0c                	jne    689 <strtoul+0x7a>
 67d:	8d 43 01             	lea    0x1(%ebx),%eax
 680:	8a 00                	mov    (%eax),%al
 682:	3c 78                	cmp    $0x78,%al
 684:	75 03                	jne    689 <strtoul+0x7a>
      p += 2;
 686:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 689:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 68d:	75 29                	jne    6b8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 68f:	8a 03                	mov    (%ebx),%al
 691:	0f be c0             	movsbl %al,%eax
 694:	83 e8 30             	sub    $0x30,%eax
 697:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 699:	83 fe 07             	cmp    $0x7,%esi
 69c:	76 06                	jbe    6a4 <strtoul+0x95>
    break;
 69e:	90                   	nop
 69f:	e9 b6 00 00 00       	jmp    75a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 6a4:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 6ab:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6ae:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 6b5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 6b6:	eb d7                	jmp    68f <strtoul+0x80>
    } else if (base == 10) {
 6b8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 6bc:	75 2b                	jne    6e9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6be:	8a 03                	mov    (%ebx),%al
 6c0:	0f be c0             	movsbl %al,%eax
 6c3:	83 e8 30             	sub    $0x30,%eax
 6c6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 6c8:	83 fe 09             	cmp    $0x9,%esi
 6cb:	76 06                	jbe    6d3 <strtoul+0xc4>
    break;
 6cd:	90                   	nop
 6ce:	e9 87 00 00 00       	jmp    75a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 6d3:	89 f8                	mov    %edi,%eax
 6d5:	c1 e0 02             	shl    $0x2,%eax
 6d8:	01 f8                	add    %edi,%eax
 6da:	01 c0                	add    %eax,%eax
 6dc:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 6e6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 6e7:	eb d5                	jmp    6be <strtoul+0xaf>
    } else if (base == 16) {
 6e9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 6ed:	75 35                	jne    724 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6ef:	8a 03                	mov    (%ebx),%al
 6f1:	0f be c0             	movsbl %al,%eax
 6f4:	83 e8 30             	sub    $0x30,%eax
 6f7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6f9:	83 fe 4a             	cmp    $0x4a,%esi
 6fc:	76 02                	jbe    700 <strtoul+0xf1>
    break;
 6fe:	eb 22                	jmp    722 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 700:	8a 86 00 13 00 00    	mov    0x1300(%esi),%al
 706:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 709:	83 fe 0f             	cmp    $0xf,%esi
 70c:	76 02                	jbe    710 <strtoul+0x101>
    break;
 70e:	eb 12                	jmp    722 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 710:	89 f8                	mov    %edi,%eax
 712:	c1 e0 04             	shl    $0x4,%eax
 715:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 718:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 71f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 720:	eb cd                	jmp    6ef <strtoul+0xe0>
 722:	eb 36                	jmp    75a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 724:	8a 03                	mov    (%ebx),%al
 726:	0f be c0             	movsbl %al,%eax
 729:	83 e8 30             	sub    $0x30,%eax
 72c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 72e:	83 fe 4a             	cmp    $0x4a,%esi
 731:	76 02                	jbe    735 <strtoul+0x126>
    break;
 733:	eb 25                	jmp    75a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 735:	8a 86 00 13 00 00    	mov    0x1300(%esi),%al
 73b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 73e:	8b 45 10             	mov    0x10(%ebp),%eax
 741:	39 f0                	cmp    %esi,%eax
 743:	77 02                	ja     747 <strtoul+0x138>
    break;
 745:	eb 13                	jmp    75a <strtoul+0x14b>
      }
      result = result*base + digit;
 747:	8b 45 10             	mov    0x10(%ebp),%eax
 74a:	0f af c7             	imul   %edi,%eax
 74d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 750:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 757:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 758:	eb ca                	jmp    724 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 75a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 75e:	75 03                	jne    763 <strtoul+0x154>
  p = string;
 760:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 763:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 767:	74 05                	je     76e <strtoul+0x15f>
  *endPtr = p;
 769:	8b 45 0c             	mov    0xc(%ebp),%eax
 76c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 76e:	89 f8                	mov    %edi,%eax
}
 770:	83 c4 14             	add    $0x14,%esp
 773:	5b                   	pop    %ebx
 774:	5e                   	pop    %esi
 775:	5f                   	pop    %edi
 776:	5d                   	pop    %ebp
 777:	c3                   	ret    

00000778 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 778:	55                   	push   %ebp
 779:	89 e5                	mov    %esp,%ebp
 77b:	53                   	push   %ebx
 77c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 77f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 782:	eb 01                	jmp    785 <strtol+0xd>
      p += 1;
 784:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 785:	8a 03                	mov    (%ebx),%al
 787:	0f b6 c0             	movzbl %al,%eax
 78a:	89 04 24             	mov    %eax,(%esp)
 78d:	e8 3f fe ff ff       	call   5d1 <isspace>
 792:	85 c0                	test   %eax,%eax
 794:	75 ee                	jne    784 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 796:	8a 03                	mov    (%ebx),%al
 798:	3c 2d                	cmp    $0x2d,%al
 79a:	75 1e                	jne    7ba <strtol+0x42>
  p += 1;
 79c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 79d:	8b 45 10             	mov    0x10(%ebp),%eax
 7a0:	89 44 24 08          	mov    %eax,0x8(%esp)
 7a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ab:	89 1c 24             	mov    %ebx,(%esp)
 7ae:	e8 5c fe ff ff       	call   60f <strtoul>
 7b3:	f7 d8                	neg    %eax
 7b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 7b8:	eb 20                	jmp    7da <strtol+0x62>
    } else {
  if (*p == '+') {
 7ba:	8a 03                	mov    (%ebx),%al
 7bc:	3c 2b                	cmp    $0x2b,%al
 7be:	75 01                	jne    7c1 <strtol+0x49>
      p += 1;
 7c0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 7c1:	8b 45 10             	mov    0x10(%ebp),%eax
 7c4:	89 44 24 08          	mov    %eax,0x8(%esp)
 7c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 7cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 7cf:	89 1c 24             	mov    %ebx,(%esp)
 7d2:	e8 38 fe ff ff       	call   60f <strtoul>
 7d7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 7da:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 7de:	75 17                	jne    7f7 <strtol+0x7f>
 7e0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7e4:	74 11                	je     7f7 <strtol+0x7f>
 7e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e9:	8b 00                	mov    (%eax),%eax
 7eb:	39 d8                	cmp    %ebx,%eax
 7ed:	75 08                	jne    7f7 <strtol+0x7f>
  *endPtr = string;
 7ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 7f2:	8b 55 08             	mov    0x8(%ebp),%edx
 7f5:	89 10                	mov    %edx,(%eax)
    }
    return result;
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 7fa:	83 c4 1c             	add    $0x1c,%esp
 7fd:	5b                   	pop    %ebx
 7fe:	5d                   	pop    %ebp
 7ff:	c3                   	ret    

00000800 <gets>:

char*
gets(char *buf, int max)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 806:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 80d:	eb 49                	jmp    858 <gets+0x58>
    cc = read(0, &c, 1);
 80f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 816:	00 
 817:	8d 45 ef             	lea    -0x11(%ebp),%eax
 81a:	89 44 24 04          	mov    %eax,0x4(%esp)
 81e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 825:	e8 3e 01 00 00       	call   968 <read>
 82a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 82d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 831:	7f 02                	jg     835 <gets+0x35>
      break;
 833:	eb 2c                	jmp    861 <gets+0x61>
    buf[i++] = c;
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8d 50 01             	lea    0x1(%eax),%edx
 83b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 83e:	89 c2                	mov    %eax,%edx
 840:	8b 45 08             	mov    0x8(%ebp),%eax
 843:	01 c2                	add    %eax,%edx
 845:	8a 45 ef             	mov    -0x11(%ebp),%al
 848:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 84a:	8a 45 ef             	mov    -0x11(%ebp),%al
 84d:	3c 0a                	cmp    $0xa,%al
 84f:	74 10                	je     861 <gets+0x61>
 851:	8a 45 ef             	mov    -0x11(%ebp),%al
 854:	3c 0d                	cmp    $0xd,%al
 856:	74 09                	je     861 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 858:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85b:	40                   	inc    %eax
 85c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 85f:	7c ae                	jl     80f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 861:	8b 55 f4             	mov    -0xc(%ebp),%edx
 864:	8b 45 08             	mov    0x8(%ebp),%eax
 867:	01 d0                	add    %edx,%eax
 869:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 86c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 86f:	c9                   	leave  
 870:	c3                   	ret    

00000871 <stat>:

int
stat(char *n, struct stat *st)
{
 871:	55                   	push   %ebp
 872:	89 e5                	mov    %esp,%ebp
 874:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 877:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 87e:	00 
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	89 04 24             	mov    %eax,(%esp)
 885:	e8 06 01 00 00       	call   990 <open>
 88a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 88d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 891:	79 07                	jns    89a <stat+0x29>
    return -1;
 893:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 898:	eb 23                	jmp    8bd <stat+0x4c>
  r = fstat(fd, st);
 89a:	8b 45 0c             	mov    0xc(%ebp),%eax
 89d:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a4:	89 04 24             	mov    %eax,(%esp)
 8a7:	e8 fc 00 00 00       	call   9a8 <fstat>
 8ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 8af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b2:	89 04 24             	mov    %eax,(%esp)
 8b5:	e8 be 00 00 00       	call   978 <close>
  return r;
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8bd:	c9                   	leave  
 8be:	c3                   	ret    

000008bf <atoi>:

int
atoi(const char *s)
{
 8bf:	55                   	push   %ebp
 8c0:	89 e5                	mov    %esp,%ebp
 8c2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 8c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 8cc:	eb 24                	jmp    8f2 <atoi+0x33>
    n = n*10 + *s++ - '0';
 8ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8d1:	89 d0                	mov    %edx,%eax
 8d3:	c1 e0 02             	shl    $0x2,%eax
 8d6:	01 d0                	add    %edx,%eax
 8d8:	01 c0                	add    %eax,%eax
 8da:	89 c1                	mov    %eax,%ecx
 8dc:	8b 45 08             	mov    0x8(%ebp),%eax
 8df:	8d 50 01             	lea    0x1(%eax),%edx
 8e2:	89 55 08             	mov    %edx,0x8(%ebp)
 8e5:	8a 00                	mov    (%eax),%al
 8e7:	0f be c0             	movsbl %al,%eax
 8ea:	01 c8                	add    %ecx,%eax
 8ec:	83 e8 30             	sub    $0x30,%eax
 8ef:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
 8f5:	8a 00                	mov    (%eax),%al
 8f7:	3c 2f                	cmp    $0x2f,%al
 8f9:	7e 09                	jle    904 <atoi+0x45>
 8fb:	8b 45 08             	mov    0x8(%ebp),%eax
 8fe:	8a 00                	mov    (%eax),%al
 900:	3c 39                	cmp    $0x39,%al
 902:	7e ca                	jle    8ce <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 904:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 907:	c9                   	leave  
 908:	c3                   	ret    

00000909 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 909:	55                   	push   %ebp
 90a:	89 e5                	mov    %esp,%ebp
 90c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 90f:	8b 45 08             	mov    0x8(%ebp),%eax
 912:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 915:	8b 45 0c             	mov    0xc(%ebp),%eax
 918:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 91b:	eb 16                	jmp    933 <memmove+0x2a>
    *dst++ = *src++;
 91d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 920:	8d 50 01             	lea    0x1(%eax),%edx
 923:	89 55 fc             	mov    %edx,-0x4(%ebp)
 926:	8b 55 f8             	mov    -0x8(%ebp),%edx
 929:	8d 4a 01             	lea    0x1(%edx),%ecx
 92c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 92f:	8a 12                	mov    (%edx),%dl
 931:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 933:	8b 45 10             	mov    0x10(%ebp),%eax
 936:	8d 50 ff             	lea    -0x1(%eax),%edx
 939:	89 55 10             	mov    %edx,0x10(%ebp)
 93c:	85 c0                	test   %eax,%eax
 93e:	7f dd                	jg     91d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 940:	8b 45 08             	mov    0x8(%ebp),%eax
}
 943:	c9                   	leave  
 944:	c3                   	ret    
 945:	90                   	nop
 946:	90                   	nop
 947:	90                   	nop

00000948 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 948:	b8 01 00 00 00       	mov    $0x1,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <exit>:
SYSCALL(exit)
 950:	b8 02 00 00 00       	mov    $0x2,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <wait>:
SYSCALL(wait)
 958:	b8 03 00 00 00       	mov    $0x3,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <pipe>:
SYSCALL(pipe)
 960:	b8 04 00 00 00       	mov    $0x4,%eax
 965:	cd 40                	int    $0x40
 967:	c3                   	ret    

00000968 <read>:
SYSCALL(read)
 968:	b8 05 00 00 00       	mov    $0x5,%eax
 96d:	cd 40                	int    $0x40
 96f:	c3                   	ret    

00000970 <write>:
SYSCALL(write)
 970:	b8 10 00 00 00       	mov    $0x10,%eax
 975:	cd 40                	int    $0x40
 977:	c3                   	ret    

00000978 <close>:
SYSCALL(close)
 978:	b8 15 00 00 00       	mov    $0x15,%eax
 97d:	cd 40                	int    $0x40
 97f:	c3                   	ret    

00000980 <kill>:
SYSCALL(kill)
 980:	b8 06 00 00 00       	mov    $0x6,%eax
 985:	cd 40                	int    $0x40
 987:	c3                   	ret    

00000988 <exec>:
SYSCALL(exec)
 988:	b8 07 00 00 00       	mov    $0x7,%eax
 98d:	cd 40                	int    $0x40
 98f:	c3                   	ret    

00000990 <open>:
SYSCALL(open)
 990:	b8 0f 00 00 00       	mov    $0xf,%eax
 995:	cd 40                	int    $0x40
 997:	c3                   	ret    

00000998 <mknod>:
SYSCALL(mknod)
 998:	b8 11 00 00 00       	mov    $0x11,%eax
 99d:	cd 40                	int    $0x40
 99f:	c3                   	ret    

000009a0 <unlink>:
SYSCALL(unlink)
 9a0:	b8 12 00 00 00       	mov    $0x12,%eax
 9a5:	cd 40                	int    $0x40
 9a7:	c3                   	ret    

000009a8 <fstat>:
SYSCALL(fstat)
 9a8:	b8 08 00 00 00       	mov    $0x8,%eax
 9ad:	cd 40                	int    $0x40
 9af:	c3                   	ret    

000009b0 <link>:
SYSCALL(link)
 9b0:	b8 13 00 00 00       	mov    $0x13,%eax
 9b5:	cd 40                	int    $0x40
 9b7:	c3                   	ret    

000009b8 <mkdir>:
SYSCALL(mkdir)
 9b8:	b8 14 00 00 00       	mov    $0x14,%eax
 9bd:	cd 40                	int    $0x40
 9bf:	c3                   	ret    

000009c0 <chdir>:
SYSCALL(chdir)
 9c0:	b8 09 00 00 00       	mov    $0x9,%eax
 9c5:	cd 40                	int    $0x40
 9c7:	c3                   	ret    

000009c8 <dup>:
SYSCALL(dup)
 9c8:	b8 0a 00 00 00       	mov    $0xa,%eax
 9cd:	cd 40                	int    $0x40
 9cf:	c3                   	ret    

000009d0 <getpid>:
SYSCALL(getpid)
 9d0:	b8 0b 00 00 00       	mov    $0xb,%eax
 9d5:	cd 40                	int    $0x40
 9d7:	c3                   	ret    

000009d8 <sbrk>:
SYSCALL(sbrk)
 9d8:	b8 0c 00 00 00       	mov    $0xc,%eax
 9dd:	cd 40                	int    $0x40
 9df:	c3                   	ret    

000009e0 <sleep>:
SYSCALL(sleep)
 9e0:	b8 0d 00 00 00       	mov    $0xd,%eax
 9e5:	cd 40                	int    $0x40
 9e7:	c3                   	ret    

000009e8 <uptime>:
SYSCALL(uptime)
 9e8:	b8 0e 00 00 00       	mov    $0xe,%eax
 9ed:	cd 40                	int    $0x40
 9ef:	c3                   	ret    

000009f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 9f0:	55                   	push   %ebp
 9f1:	89 e5                	mov    %esp,%ebp
 9f3:	83 ec 18             	sub    $0x18,%esp
 9f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 9f9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 a03:	00 
 a04:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a07:	89 44 24 04          	mov    %eax,0x4(%esp)
 a0b:	8b 45 08             	mov    0x8(%ebp),%eax
 a0e:	89 04 24             	mov    %eax,(%esp)
 a11:	e8 5a ff ff ff       	call   970 <write>
}
 a16:	c9                   	leave  
 a17:	c3                   	ret    

00000a18 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a18:	55                   	push   %ebp
 a19:	89 e5                	mov    %esp,%ebp
 a1b:	56                   	push   %esi
 a1c:	53                   	push   %ebx
 a1d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a27:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a2b:	74 17                	je     a44 <printint+0x2c>
 a2d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a31:	79 11                	jns    a44 <printint+0x2c>
    neg = 1;
 a33:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
 a3d:	f7 d8                	neg    %eax
 a3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a42:	eb 06                	jmp    a4a <printint+0x32>
  } else {
    x = xx;
 a44:	8b 45 0c             	mov    0xc(%ebp),%eax
 a47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a51:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a54:	8d 41 01             	lea    0x1(%ecx),%eax
 a57:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a5d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a60:	ba 00 00 00 00       	mov    $0x0,%edx
 a65:	f7 f3                	div    %ebx
 a67:	89 d0                	mov    %edx,%eax
 a69:	8a 80 4c 13 00 00    	mov    0x134c(%eax),%al
 a6f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a73:	8b 75 10             	mov    0x10(%ebp),%esi
 a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a79:	ba 00 00 00 00       	mov    $0x0,%edx
 a7e:	f7 f6                	div    %esi
 a80:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a83:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a87:	75 c8                	jne    a51 <printint+0x39>
  if(neg)
 a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a8d:	74 10                	je     a9f <printint+0x87>
    buf[i++] = '-';
 a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a92:	8d 50 01             	lea    0x1(%eax),%edx
 a95:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a98:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a9d:	eb 1e                	jmp    abd <printint+0xa5>
 a9f:	eb 1c                	jmp    abd <printint+0xa5>
    putc(fd, buf[i]);
 aa1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa7:	01 d0                	add    %edx,%eax
 aa9:	8a 00                	mov    (%eax),%al
 aab:	0f be c0             	movsbl %al,%eax
 aae:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab2:	8b 45 08             	mov    0x8(%ebp),%eax
 ab5:	89 04 24             	mov    %eax,(%esp)
 ab8:	e8 33 ff ff ff       	call   9f0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 abd:	ff 4d f4             	decl   -0xc(%ebp)
 ac0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac4:	79 db                	jns    aa1 <printint+0x89>
    putc(fd, buf[i]);
}
 ac6:	83 c4 30             	add    $0x30,%esp
 ac9:	5b                   	pop    %ebx
 aca:	5e                   	pop    %esi
 acb:	5d                   	pop    %ebp
 acc:	c3                   	ret    

00000acd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 acd:	55                   	push   %ebp
 ace:	89 e5                	mov    %esp,%ebp
 ad0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 ad3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 ada:	8d 45 0c             	lea    0xc(%ebp),%eax
 add:	83 c0 04             	add    $0x4,%eax
 ae0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 ae3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 aea:	e9 77 01 00 00       	jmp    c66 <printf+0x199>
    c = fmt[i] & 0xff;
 aef:	8b 55 0c             	mov    0xc(%ebp),%edx
 af2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 af5:	01 d0                	add    %edx,%eax
 af7:	8a 00                	mov    (%eax),%al
 af9:	0f be c0             	movsbl %al,%eax
 afc:	25 ff 00 00 00       	and    $0xff,%eax
 b01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b04:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b08:	75 2c                	jne    b36 <printf+0x69>
      if(c == '%'){
 b0a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b0e:	75 0c                	jne    b1c <printf+0x4f>
        state = '%';
 b10:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b17:	e9 47 01 00 00       	jmp    c63 <printf+0x196>
      } else {
        putc(fd, c);
 b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b1f:	0f be c0             	movsbl %al,%eax
 b22:	89 44 24 04          	mov    %eax,0x4(%esp)
 b26:	8b 45 08             	mov    0x8(%ebp),%eax
 b29:	89 04 24             	mov    %eax,(%esp)
 b2c:	e8 bf fe ff ff       	call   9f0 <putc>
 b31:	e9 2d 01 00 00       	jmp    c63 <printf+0x196>
      }
    } else if(state == '%'){
 b36:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b3a:	0f 85 23 01 00 00    	jne    c63 <printf+0x196>
      if(c == 'd'){
 b40:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b44:	75 2d                	jne    b73 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b49:	8b 00                	mov    (%eax),%eax
 b4b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 b52:	00 
 b53:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 b5a:	00 
 b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b5f:	8b 45 08             	mov    0x8(%ebp),%eax
 b62:	89 04 24             	mov    %eax,(%esp)
 b65:	e8 ae fe ff ff       	call   a18 <printint>
        ap++;
 b6a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b6e:	e9 e9 00 00 00       	jmp    c5c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 b73:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b77:	74 06                	je     b7f <printf+0xb2>
 b79:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b7d:	75 2d                	jne    bac <printf+0xdf>
        printint(fd, *ap, 16, 0);
 b7f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b82:	8b 00                	mov    (%eax),%eax
 b84:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 b8b:	00 
 b8c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b93:	00 
 b94:	89 44 24 04          	mov    %eax,0x4(%esp)
 b98:	8b 45 08             	mov    0x8(%ebp),%eax
 b9b:	89 04 24             	mov    %eax,(%esp)
 b9e:	e8 75 fe ff ff       	call   a18 <printint>
        ap++;
 ba3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ba7:	e9 b0 00 00 00       	jmp    c5c <printf+0x18f>
      } else if(c == 's'){
 bac:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 bb0:	75 42                	jne    bf4 <printf+0x127>
        s = (char*)*ap;
 bb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bb5:	8b 00                	mov    (%eax),%eax
 bb7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 bba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 bbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bc2:	75 09                	jne    bcd <printf+0x100>
          s = "(null)";
 bc4:	c7 45 f4 2f 0f 00 00 	movl   $0xf2f,-0xc(%ebp)
        while(*s != 0){
 bcb:	eb 1c                	jmp    be9 <printf+0x11c>
 bcd:	eb 1a                	jmp    be9 <printf+0x11c>
          putc(fd, *s);
 bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd2:	8a 00                	mov    (%eax),%al
 bd4:	0f be c0             	movsbl %al,%eax
 bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
 bdb:	8b 45 08             	mov    0x8(%ebp),%eax
 bde:	89 04 24             	mov    %eax,(%esp)
 be1:	e8 0a fe ff ff       	call   9f0 <putc>
          s++;
 be6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bec:	8a 00                	mov    (%eax),%al
 bee:	84 c0                	test   %al,%al
 bf0:	75 dd                	jne    bcf <printf+0x102>
 bf2:	eb 68                	jmp    c5c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 bf4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 bf8:	75 1d                	jne    c17 <printf+0x14a>
        putc(fd, *ap);
 bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bfd:	8b 00                	mov    (%eax),%eax
 bff:	0f be c0             	movsbl %al,%eax
 c02:	89 44 24 04          	mov    %eax,0x4(%esp)
 c06:	8b 45 08             	mov    0x8(%ebp),%eax
 c09:	89 04 24             	mov    %eax,(%esp)
 c0c:	e8 df fd ff ff       	call   9f0 <putc>
        ap++;
 c11:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c15:	eb 45                	jmp    c5c <printf+0x18f>
      } else if(c == '%'){
 c17:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c1b:	75 17                	jne    c34 <printf+0x167>
        putc(fd, c);
 c1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c20:	0f be c0             	movsbl %al,%eax
 c23:	89 44 24 04          	mov    %eax,0x4(%esp)
 c27:	8b 45 08             	mov    0x8(%ebp),%eax
 c2a:	89 04 24             	mov    %eax,(%esp)
 c2d:	e8 be fd ff ff       	call   9f0 <putc>
 c32:	eb 28                	jmp    c5c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c34:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 c3b:	00 
 c3c:	8b 45 08             	mov    0x8(%ebp),%eax
 c3f:	89 04 24             	mov    %eax,(%esp)
 c42:	e8 a9 fd ff ff       	call   9f0 <putc>
        putc(fd, c);
 c47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c4a:	0f be c0             	movsbl %al,%eax
 c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
 c51:	8b 45 08             	mov    0x8(%ebp),%eax
 c54:	89 04 24             	mov    %eax,(%esp)
 c57:	e8 94 fd ff ff       	call   9f0 <putc>
      }
      state = 0;
 c5c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c63:	ff 45 f0             	incl   -0x10(%ebp)
 c66:	8b 55 0c             	mov    0xc(%ebp),%edx
 c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c6c:	01 d0                	add    %edx,%eax
 c6e:	8a 00                	mov    (%eax),%al
 c70:	84 c0                	test   %al,%al
 c72:	0f 85 77 fe ff ff    	jne    aef <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c78:	c9                   	leave  
 c79:	c3                   	ret    
 c7a:	90                   	nop
 c7b:	90                   	nop

00000c7c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c7c:	55                   	push   %ebp
 c7d:	89 e5                	mov    %esp,%ebp
 c7f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c82:	8b 45 08             	mov    0x8(%ebp),%eax
 c85:	83 e8 08             	sub    $0x8,%eax
 c88:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c8b:	a1 70 13 00 00       	mov    0x1370,%eax
 c90:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c93:	eb 24                	jmp    cb9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c98:	8b 00                	mov    (%eax),%eax
 c9a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c9d:	77 12                	ja     cb1 <free+0x35>
 c9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ca5:	77 24                	ja     ccb <free+0x4f>
 ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 caa:	8b 00                	mov    (%eax),%eax
 cac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 caf:	77 1a                	ja     ccb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb4:	8b 00                	mov    (%eax),%eax
 cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cbc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cbf:	76 d4                	jbe    c95 <free+0x19>
 cc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc4:	8b 00                	mov    (%eax),%eax
 cc6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cc9:	76 ca                	jbe    c95 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 ccb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cce:	8b 40 04             	mov    0x4(%eax),%eax
 cd1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cdb:	01 c2                	add    %eax,%edx
 cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce0:	8b 00                	mov    (%eax),%eax
 ce2:	39 c2                	cmp    %eax,%edx
 ce4:	75 24                	jne    d0a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ce6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce9:	8b 50 04             	mov    0x4(%eax),%edx
 cec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cef:	8b 00                	mov    (%eax),%eax
 cf1:	8b 40 04             	mov    0x4(%eax),%eax
 cf4:	01 c2                	add    %eax,%edx
 cf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cff:	8b 00                	mov    (%eax),%eax
 d01:	8b 10                	mov    (%eax),%edx
 d03:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d06:	89 10                	mov    %edx,(%eax)
 d08:	eb 0a                	jmp    d14 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d0d:	8b 10                	mov    (%eax),%edx
 d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d12:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d14:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d17:	8b 40 04             	mov    0x4(%eax),%eax
 d1a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d24:	01 d0                	add    %edx,%eax
 d26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d29:	75 20                	jne    d4b <free+0xcf>
    p->s.size += bp->s.size;
 d2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d2e:	8b 50 04             	mov    0x4(%eax),%edx
 d31:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d34:	8b 40 04             	mov    0x4(%eax),%eax
 d37:	01 c2                	add    %eax,%edx
 d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d3c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d42:	8b 10                	mov    (%eax),%edx
 d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d47:	89 10                	mov    %edx,(%eax)
 d49:	eb 08                	jmp    d53 <free+0xd7>
  } else
    p->s.ptr = bp;
 d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d51:	89 10                	mov    %edx,(%eax)
  freep = p;
 d53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d56:	a3 70 13 00 00       	mov    %eax,0x1370
}
 d5b:	c9                   	leave  
 d5c:	c3                   	ret    

00000d5d <morecore>:

static Header*
morecore(uint nu)
{
 d5d:	55                   	push   %ebp
 d5e:	89 e5                	mov    %esp,%ebp
 d60:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d63:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d6a:	77 07                	ja     d73 <morecore+0x16>
    nu = 4096;
 d6c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d73:	8b 45 08             	mov    0x8(%ebp),%eax
 d76:	c1 e0 03             	shl    $0x3,%eax
 d79:	89 04 24             	mov    %eax,(%esp)
 d7c:	e8 57 fc ff ff       	call   9d8 <sbrk>
 d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d84:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d88:	75 07                	jne    d91 <morecore+0x34>
    return 0;
 d8a:	b8 00 00 00 00       	mov    $0x0,%eax
 d8f:	eb 22                	jmp    db3 <morecore+0x56>
  hp = (Header*)p;
 d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d97:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d9a:	8b 55 08             	mov    0x8(%ebp),%edx
 d9d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 da0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da3:	83 c0 08             	add    $0x8,%eax
 da6:	89 04 24             	mov    %eax,(%esp)
 da9:	e8 ce fe ff ff       	call   c7c <free>
  return freep;
 dae:	a1 70 13 00 00       	mov    0x1370,%eax
}
 db3:	c9                   	leave  
 db4:	c3                   	ret    

00000db5 <malloc>:

void*
malloc(uint nbytes)
{
 db5:	55                   	push   %ebp
 db6:	89 e5                	mov    %esp,%ebp
 db8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 dbb:	8b 45 08             	mov    0x8(%ebp),%eax
 dbe:	83 c0 07             	add    $0x7,%eax
 dc1:	c1 e8 03             	shr    $0x3,%eax
 dc4:	40                   	inc    %eax
 dc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 dc8:	a1 70 13 00 00       	mov    0x1370,%eax
 dcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 dd4:	75 23                	jne    df9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 dd6:	c7 45 f0 68 13 00 00 	movl   $0x1368,-0x10(%ebp)
 ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 de0:	a3 70 13 00 00       	mov    %eax,0x1370
 de5:	a1 70 13 00 00       	mov    0x1370,%eax
 dea:	a3 68 13 00 00       	mov    %eax,0x1368
    base.s.size = 0;
 def:	c7 05 6c 13 00 00 00 	movl   $0x0,0x136c
 df6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dfc:	8b 00                	mov    (%eax),%eax
 dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e04:	8b 40 04             	mov    0x4(%eax),%eax
 e07:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e0a:	72 4d                	jb     e59 <malloc+0xa4>
      if(p->s.size == nunits)
 e0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e0f:	8b 40 04             	mov    0x4(%eax),%eax
 e12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e15:	75 0c                	jne    e23 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 e17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e1a:	8b 10                	mov    (%eax),%edx
 e1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e1f:	89 10                	mov    %edx,(%eax)
 e21:	eb 26                	jmp    e49 <malloc+0x94>
      else {
        p->s.size -= nunits;
 e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e26:	8b 40 04             	mov    0x4(%eax),%eax
 e29:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e2c:	89 c2                	mov    %eax,%edx
 e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e31:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e37:	8b 40 04             	mov    0x4(%eax),%eax
 e3a:	c1 e0 03             	shl    $0x3,%eax
 e3d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e43:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e46:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e49:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e4c:	a3 70 13 00 00       	mov    %eax,0x1370
      return (void*)(p + 1);
 e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e54:	83 c0 08             	add    $0x8,%eax
 e57:	eb 38                	jmp    e91 <malloc+0xdc>
    }
    if(p == freep)
 e59:	a1 70 13 00 00       	mov    0x1370,%eax
 e5e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e61:	75 1b                	jne    e7e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 e63:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e66:	89 04 24             	mov    %eax,(%esp)
 e69:	e8 ef fe ff ff       	call   d5d <morecore>
 e6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e75:	75 07                	jne    e7e <malloc+0xc9>
        return 0;
 e77:	b8 00 00 00 00       	mov    $0x0,%eax
 e7c:	eb 13                	jmp    e91 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e87:	8b 00                	mov    (%eax),%eax
 e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e8c:	e9 70 ff ff ff       	jmp    e01 <malloc+0x4c>
}
 e91:	c9                   	leave  
 e92:	c3                   	ret    
