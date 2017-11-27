
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
   6:	c7 45 f0 0a 0f 00 00 	movl   $0xf0a,-0x10(%ebp)

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
  32:	e8 45 09 00 00       	call   97c <open>
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
  59:	e8 26 09 00 00       	call   984 <mknod>
  5e:	eb 0b                	jmp    6b <create_vcs+0x6b>
    } else {
      close(fd);
  60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  63:	89 04 24             	mov    %eax,(%esp)
  66:	e8 f9 08 00 00       	call   964 <close>
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
  87:	c7 04 24 0e 0f 00 00 	movl   $0xf0e,(%esp)
  8e:	e8 e9 08 00 00       	call   97c <open>
  93:	85 c0                	test   %eax,%eax
  95:	79 30                	jns    c7 <main+0x51>
    mknod("console", 1, 1);
  97:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  9e:	00 
  9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 0e 0f 00 00 	movl   $0xf0e,(%esp)
  ae:	e8 d1 08 00 00       	call   984 <mknod>
    open("console", O_RDWR);
  b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  ba:	00 
  bb:	c7 04 24 0e 0f 00 00 	movl   $0xf0e,(%esp)
  c2:	e8 b5 08 00 00       	call   97c <open>
  }
  dup(0);  // stdout
  c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ce:	e8 e1 08 00 00       	call   9b4 <dup>
  dup(0);  // stderr
  d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  da:	e8 d5 08 00 00       	call   9b4 <dup>

  create_vcs();
  df:	e8 1c ff ff ff       	call   0 <create_vcs>

  for(;;){
    printf(1, "init: starting sh\n");
  e4:	c7 44 24 04 16 0f 00 	movl   $0xf16,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 49 0a 00 00       	call   b41 <printf>
    pid = fork();
  f8:	e8 37 08 00 00       	call   934 <fork>
  fd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
 101:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 106:	79 19                	jns    121 <main+0xab>
      printf(1, "init: fork failed\n");
 108:	c7 44 24 04 29 0f 00 	movl   $0xf29,0x4(%esp)
 10f:	00 
 110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 117:	e8 25 0a 00 00       	call   b41 <printf>
      exit();
 11c:	e8 1b 08 00 00       	call   93c <exit>
    }
    if(pid == 0){
 121:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 126:	75 2d                	jne    155 <main+0xdf>
      exec("sh", argv);
 128:	c7 44 24 04 40 13 00 	movl   $0x1340,0x4(%esp)
 12f:	00 
 130:	c7 04 24 07 0f 00 00 	movl   $0xf07,(%esp)
 137:	e8 38 08 00 00       	call   974 <exec>
      printf(1, "init: exec sh failed\n");
 13c:	c7 44 24 04 3c 0f 00 	movl   $0xf3c,0x4(%esp)
 143:	00 
 144:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14b:	e8 f1 09 00 00       	call   b41 <printf>
      exit();
 150:	e8 e7 07 00 00       	call   93c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 155:	eb 14                	jmp    16b <main+0xf5>
      printf(1, "zombie!\n");
 157:	c7 44 24 04 52 0f 00 	movl   $0xf52,0x4(%esp)
 15e:	00 
 15f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 166:	e8 d6 09 00 00       	call   b41 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 16b:	e8 d4 07 00 00       	call   944 <wait>
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

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
 1e2:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
 1e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
 1ec:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1f3:	00 
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	89 04 24             	mov    %eax,(%esp)
 1fa:	e8 7d 07 00 00       	call   97c <open>
 1ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
 202:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 206:	79 20                	jns    228 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
 208:	8b 45 08             	mov    0x8(%ebp),%eax
 20b:	89 44 24 08          	mov    %eax,0x8(%esp)
 20f:	c7 44 24 04 5b 0f 00 	movl   $0xf5b,0x4(%esp)
 216:	00 
 217:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 21e:	e8 1e 09 00 00       	call   b41 <printf>
      exit();
 223:	e8 14 07 00 00       	call   93c <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 228:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 22f:	00 
 230:	8b 45 0c             	mov    0xc(%ebp),%eax
 233:	89 04 24             	mov    %eax,(%esp)
 236:	e8 41 07 00 00       	call   97c <open>
 23b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 23e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 242:	79 20                	jns    264 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	89 44 24 08          	mov    %eax,0x8(%esp)
 24b:	c7 44 24 04 76 0f 00 	movl   $0xf76,0x4(%esp)
 252:	00 
 253:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 25a:	e8 e2 08 00 00       	call   b41 <printf>
      exit();
 25f:	e8 d8 06 00 00       	call   93c <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 264:	eb 3b                	jmp    2a1 <copy+0xc2>
  {
      max = used_disk+=count;
 266:	8b 45 e8             	mov    -0x18(%ebp),%eax
 269:	01 45 10             	add    %eax,0x10(%ebp)
 26c:	8b 45 10             	mov    0x10(%ebp),%eax
 26f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 272:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 275:	3b 45 14             	cmp    0x14(%ebp),%eax
 278:	7e 07                	jle    281 <copy+0xa2>
      {
        return -1;
 27a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 27f:	eb 5c                	jmp    2dd <copy+0xfe>
      }
      bytes = bytes + count;
 281:	8b 45 e8             	mov    -0x18(%ebp),%eax
 284:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 287:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 28e:	00 
 28f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 292:	89 44 24 04          	mov    %eax,0x4(%esp)
 296:	8b 45 ec             	mov    -0x14(%ebp),%eax
 299:	89 04 24             	mov    %eax,(%esp)
 29c:	e8 bb 06 00 00       	call   95c <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 2a1:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 2a8:	00 
 2a9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 2ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2b3:	89 04 24             	mov    %eax,(%esp)
 2b6:	e8 99 06 00 00       	call   954 <read>
 2bb:	89 45 e8             	mov    %eax,-0x18(%ebp)
 2be:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 2c2:	7f a2                	jg     266 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 2c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2c7:	89 04 24             	mov    %eax,(%esp)
 2ca:	e8 95 06 00 00       	call   964 <close>
  close(fd2);
 2cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 8a 06 00 00       	call   964 <close>
  return(bytes);
 2da:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2dd:	c9                   	leave  
 2de:	c3                   	ret    

000002df <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2df:	55                   	push   %ebp
 2e0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2e2:	eb 06                	jmp    2ea <strcmp+0xb>
    p++, q++;
 2e4:	ff 45 08             	incl   0x8(%ebp)
 2e7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	8a 00                	mov    (%eax),%al
 2ef:	84 c0                	test   %al,%al
 2f1:	74 0e                	je     301 <strcmp+0x22>
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	8a 10                	mov    (%eax),%dl
 2f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fb:	8a 00                	mov    (%eax),%al
 2fd:	38 c2                	cmp    %al,%dl
 2ff:	74 e3                	je     2e4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	8a 00                	mov    (%eax),%al
 306:	0f b6 d0             	movzbl %al,%edx
 309:	8b 45 0c             	mov    0xc(%ebp),%eax
 30c:	8a 00                	mov    (%eax),%al
 30e:	0f b6 c0             	movzbl %al,%eax
 311:	29 c2                	sub    %eax,%edx
 313:	89 d0                	mov    %edx,%eax
}
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    

00000317 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 317:	55                   	push   %ebp
 318:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 31a:	eb 09                	jmp    325 <strncmp+0xe>
    n--, p++, q++;
 31c:	ff 4d 10             	decl   0x10(%ebp)
 31f:	ff 45 08             	incl   0x8(%ebp)
 322:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 325:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 329:	74 17                	je     342 <strncmp+0x2b>
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	8a 00                	mov    (%eax),%al
 330:	84 c0                	test   %al,%al
 332:	74 0e                	je     342 <strncmp+0x2b>
 334:	8b 45 08             	mov    0x8(%ebp),%eax
 337:	8a 10                	mov    (%eax),%dl
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	8a 00                	mov    (%eax),%al
 33e:	38 c2                	cmp    %al,%dl
 340:	74 da                	je     31c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 342:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 346:	75 07                	jne    34f <strncmp+0x38>
    return 0;
 348:	b8 00 00 00 00       	mov    $0x0,%eax
 34d:	eb 14                	jmp    363 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	8a 00                	mov    (%eax),%al
 354:	0f b6 d0             	movzbl %al,%edx
 357:	8b 45 0c             	mov    0xc(%ebp),%eax
 35a:	8a 00                	mov    (%eax),%al
 35c:	0f b6 c0             	movzbl %al,%eax
 35f:	29 c2                	sub    %eax,%edx
 361:	89 d0                	mov    %edx,%eax
}
 363:	5d                   	pop    %ebp
 364:	c3                   	ret    

00000365 <strlen>:

uint
strlen(const char *s)
{
 365:	55                   	push   %ebp
 366:	89 e5                	mov    %esp,%ebp
 368:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 36b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 372:	eb 03                	jmp    377 <strlen+0x12>
 374:	ff 45 fc             	incl   -0x4(%ebp)
 377:	8b 55 fc             	mov    -0x4(%ebp),%edx
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	01 d0                	add    %edx,%eax
 37f:	8a 00                	mov    (%eax),%al
 381:	84 c0                	test   %al,%al
 383:	75 ef                	jne    374 <strlen+0xf>
    ;
  return n;
 385:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 388:	c9                   	leave  
 389:	c3                   	ret    

0000038a <memset>:

void*
memset(void *dst, int c, uint n)
{
 38a:	55                   	push   %ebp
 38b:	89 e5                	mov    %esp,%ebp
 38d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 390:	8b 45 10             	mov    0x10(%ebp),%eax
 393:	89 44 24 08          	mov    %eax,0x8(%esp)
 397:	8b 45 0c             	mov    0xc(%ebp),%eax
 39a:	89 44 24 04          	mov    %eax,0x4(%esp)
 39e:	8b 45 08             	mov    0x8(%ebp),%eax
 3a1:	89 04 24             	mov    %eax,(%esp)
 3a4:	e8 e3 fd ff ff       	call   18c <stosb>
  return dst;
 3a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3ac:	c9                   	leave  
 3ad:	c3                   	ret    

000003ae <strchr>:

char*
strchr(const char *s, char c)
{
 3ae:	55                   	push   %ebp
 3af:	89 e5                	mov    %esp,%ebp
 3b1:	83 ec 04             	sub    $0x4,%esp
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 3ba:	eb 12                	jmp    3ce <strchr+0x20>
    if(*s == c)
 3bc:	8b 45 08             	mov    0x8(%ebp),%eax
 3bf:	8a 00                	mov    (%eax),%al
 3c1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 3c4:	75 05                	jne    3cb <strchr+0x1d>
      return (char*)s;
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	eb 11                	jmp    3dc <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 3cb:	ff 45 08             	incl   0x8(%ebp)
 3ce:	8b 45 08             	mov    0x8(%ebp),%eax
 3d1:	8a 00                	mov    (%eax),%al
 3d3:	84 c0                	test   %al,%al
 3d5:	75 e5                	jne    3bc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <strcat>:

char *
strcat(char *dest, const char *src)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3eb:	eb 03                	jmp    3f0 <strcat+0x12>
 3ed:	ff 45 fc             	incl   -0x4(%ebp)
 3f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	01 d0                	add    %edx,%eax
 3f8:	8a 00                	mov    (%eax),%al
 3fa:	84 c0                	test   %al,%al
 3fc:	75 ef                	jne    3ed <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 3fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 405:	eb 1e                	jmp    425 <strcat+0x47>
        dest[i+j] = src[j];
 407:	8b 45 f8             	mov    -0x8(%ebp),%eax
 40a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40d:	01 d0                	add    %edx,%eax
 40f:	89 c2                	mov    %eax,%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	01 c2                	add    %eax,%edx
 416:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	01 c8                	add    %ecx,%eax
 41e:	8a 00                	mov    (%eax),%al
 420:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 422:	ff 45 f8             	incl   -0x8(%ebp)
 425:	8b 55 f8             	mov    -0x8(%ebp),%edx
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	01 d0                	add    %edx,%eax
 42d:	8a 00                	mov    (%eax),%al
 42f:	84 c0                	test   %al,%al
 431:	75 d4                	jne    407 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 433:	8b 45 f8             	mov    -0x8(%ebp),%eax
 436:	8b 55 fc             	mov    -0x4(%ebp),%edx
 439:	01 d0                	add    %edx,%eax
 43b:	89 c2                	mov    %eax,%edx
 43d:	8b 45 08             	mov    0x8(%ebp),%eax
 440:	01 d0                	add    %edx,%eax
 442:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 445:	8b 45 08             	mov    0x8(%ebp),%eax
}
 448:	c9                   	leave  
 449:	c3                   	ret    

0000044a <strstr>:

int 
strstr(char* s, char* sub)
{
 44a:	55                   	push   %ebp
 44b:	89 e5                	mov    %esp,%ebp
 44d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 450:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 457:	eb 7c                	jmp    4d5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 459:	8b 55 fc             	mov    -0x4(%ebp),%edx
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	01 d0                	add    %edx,%eax
 461:	8a 10                	mov    (%eax),%dl
 463:	8b 45 0c             	mov    0xc(%ebp),%eax
 466:	8a 00                	mov    (%eax),%al
 468:	38 c2                	cmp    %al,%dl
 46a:	75 66                	jne    4d2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 46c:	8b 45 0c             	mov    0xc(%ebp),%eax
 46f:	89 04 24             	mov    %eax,(%esp)
 472:	e8 ee fe ff ff       	call   365 <strlen>
 477:	83 f8 01             	cmp    $0x1,%eax
 47a:	75 05                	jne    481 <strstr+0x37>
            {  
                return i;
 47c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 47f:	eb 6b                	jmp    4ec <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 481:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 488:	eb 3a                	jmp    4c4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 48a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 48d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 490:	01 d0                	add    %edx,%eax
 492:	89 c2                	mov    %eax,%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	01 d0                	add    %edx,%eax
 499:	8a 10                	mov    (%eax),%dl
 49b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 49e:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a1:	01 c8                	add    %ecx,%eax
 4a3:	8a 00                	mov    (%eax),%al
 4a5:	38 c2                	cmp    %al,%dl
 4a7:	75 16                	jne    4bf <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 4a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4ac:	8d 50 01             	lea    0x1(%eax),%edx
 4af:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	8a 00                	mov    (%eax),%al
 4b6:	84 c0                	test   %al,%al
 4b8:	75 07                	jne    4c1 <strstr+0x77>
                    {
                        return i;
 4ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4bd:	eb 2d                	jmp    4ec <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 4bf:	eb 11                	jmp    4d2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 4c1:	ff 45 f8             	incl   -0x8(%ebp)
 4c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ca:	01 d0                	add    %edx,%eax
 4cc:	8a 00                	mov    (%eax),%al
 4ce:	84 c0                	test   %al,%al
 4d0:	75 b8                	jne    48a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 4d2:	ff 45 fc             	incl   -0x4(%ebp)
 4d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	01 d0                	add    %edx,%eax
 4dd:	8a 00                	mov    (%eax),%al
 4df:	84 c0                	test   %al,%al
 4e1:	0f 85 72 ff ff ff    	jne    459 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 4e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 4ec:	c9                   	leave  
 4ed:	c3                   	ret    

000004ee <strtok>:

char *
strtok(char *s, const char *delim)
{
 4ee:	55                   	push   %ebp
 4ef:	89 e5                	mov    %esp,%ebp
 4f1:	53                   	push   %ebx
 4f2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 4f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4f9:	75 08                	jne    503 <strtok+0x15>
  s = lasts;
 4fb:	a1 c4 13 00 00       	mov    0x13c4,%eax
 500:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	8d 50 01             	lea    0x1(%eax),%edx
 509:	89 55 08             	mov    %edx,0x8(%ebp)
 50c:	8a 00                	mov    (%eax),%al
 50e:	0f be d8             	movsbl %al,%ebx
 511:	85 db                	test   %ebx,%ebx
 513:	75 07                	jne    51c <strtok+0x2e>
      return 0;
 515:	b8 00 00 00 00       	mov    $0x0,%eax
 51a:	eb 58                	jmp    574 <strtok+0x86>
    } while (strchr(delim, ch));
 51c:	88 d8                	mov    %bl,%al
 51e:	0f be c0             	movsbl %al,%eax
 521:	89 44 24 04          	mov    %eax,0x4(%esp)
 525:	8b 45 0c             	mov    0xc(%ebp),%eax
 528:	89 04 24             	mov    %eax,(%esp)
 52b:	e8 7e fe ff ff       	call   3ae <strchr>
 530:	85 c0                	test   %eax,%eax
 532:	75 cf                	jne    503 <strtok+0x15>
    --s;
 534:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 537:	8b 45 0c             	mov    0xc(%ebp),%eax
 53a:	89 44 24 04          	mov    %eax,0x4(%esp)
 53e:	8b 45 08             	mov    0x8(%ebp),%eax
 541:	89 04 24             	mov    %eax,(%esp)
 544:	e8 31 00 00 00       	call   57a <strcspn>
 549:	89 c2                	mov    %eax,%edx
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	01 d0                	add    %edx,%eax
 550:	a3 c4 13 00 00       	mov    %eax,0x13c4
    if (*lasts != 0)
 555:	a1 c4 13 00 00       	mov    0x13c4,%eax
 55a:	8a 00                	mov    (%eax),%al
 55c:	84 c0                	test   %al,%al
 55e:	74 11                	je     571 <strtok+0x83>
  *lasts++ = 0;
 560:	a1 c4 13 00 00       	mov    0x13c4,%eax
 565:	8d 50 01             	lea    0x1(%eax),%edx
 568:	89 15 c4 13 00 00    	mov    %edx,0x13c4
 56e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 571:	8b 45 08             	mov    0x8(%ebp),%eax
}
 574:	83 c4 14             	add    $0x14,%esp
 577:	5b                   	pop    %ebx
 578:	5d                   	pop    %ebp
 579:	c3                   	ret    

0000057a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 57a:	55                   	push   %ebp
 57b:	89 e5                	mov    %esp,%ebp
 57d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 580:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 587:	eb 26                	jmp    5af <strcspn+0x35>
        if(strchr(s2,*s1))
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	8a 00                	mov    (%eax),%al
 58e:	0f be c0             	movsbl %al,%eax
 591:	89 44 24 04          	mov    %eax,0x4(%esp)
 595:	8b 45 0c             	mov    0xc(%ebp),%eax
 598:	89 04 24             	mov    %eax,(%esp)
 59b:	e8 0e fe ff ff       	call   3ae <strchr>
 5a0:	85 c0                	test   %eax,%eax
 5a2:	74 05                	je     5a9 <strcspn+0x2f>
            return ret;
 5a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5a7:	eb 12                	jmp    5bb <strcspn+0x41>
        else
            s1++,ret++;
 5a9:	ff 45 08             	incl   0x8(%ebp)
 5ac:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 5af:	8b 45 08             	mov    0x8(%ebp),%eax
 5b2:	8a 00                	mov    (%eax),%al
 5b4:	84 c0                	test   %al,%al
 5b6:	75 d1                	jne    589 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 5b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 5bb:	c9                   	leave  
 5bc:	c3                   	ret    

000005bd <isspace>:

int
isspace(unsigned char c)
{
 5bd:	55                   	push   %ebp
 5be:	89 e5                	mov    %esp,%ebp
 5c0:	83 ec 04             	sub    $0x4,%esp
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 5c9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 5cd:	74 1e                	je     5ed <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 5cf:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 5d3:	74 18                	je     5ed <isspace+0x30>
 5d5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 5d9:	74 12                	je     5ed <isspace+0x30>
 5db:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 5df:	74 0c                	je     5ed <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 5e1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 5e5:	74 06                	je     5ed <isspace+0x30>
 5e7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 5eb:	75 07                	jne    5f4 <isspace+0x37>
 5ed:	b8 01 00 00 00       	mov    $0x1,%eax
 5f2:	eb 05                	jmp    5f9 <isspace+0x3c>
 5f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5f9:	c9                   	leave  
 5fa:	c3                   	ret    

000005fb <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 5fb:	55                   	push   %ebp
 5fc:	89 e5                	mov    %esp,%ebp
 5fe:	57                   	push   %edi
 5ff:	56                   	push   %esi
 600:	53                   	push   %ebx
 601:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 604:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 609:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 610:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 613:	eb 01                	jmp    616 <strtoul+0x1b>
  p += 1;
 615:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 616:	8a 03                	mov    (%ebx),%al
 618:	0f b6 c0             	movzbl %al,%eax
 61b:	89 04 24             	mov    %eax,(%esp)
 61e:	e8 9a ff ff ff       	call   5bd <isspace>
 623:	85 c0                	test   %eax,%eax
 625:	75 ee                	jne    615 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 627:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 62b:	75 30                	jne    65d <strtoul+0x62>
    {
  if (*p == '0') {
 62d:	8a 03                	mov    (%ebx),%al
 62f:	3c 30                	cmp    $0x30,%al
 631:	75 21                	jne    654 <strtoul+0x59>
      p += 1;
 633:	43                   	inc    %ebx
      if (*p == 'x') {
 634:	8a 03                	mov    (%ebx),%al
 636:	3c 78                	cmp    $0x78,%al
 638:	75 0a                	jne    644 <strtoul+0x49>
    p += 1;
 63a:	43                   	inc    %ebx
    base = 16;
 63b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 642:	eb 31                	jmp    675 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 644:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 64b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 652:	eb 21                	jmp    675 <strtoul+0x7a>
      }
  }
  else base = 10;
 654:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 65b:	eb 18                	jmp    675 <strtoul+0x7a>
    } else if (base == 16) {
 65d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 661:	75 12                	jne    675 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 663:	8a 03                	mov    (%ebx),%al
 665:	3c 30                	cmp    $0x30,%al
 667:	75 0c                	jne    675 <strtoul+0x7a>
 669:	8d 43 01             	lea    0x1(%ebx),%eax
 66c:	8a 00                	mov    (%eax),%al
 66e:	3c 78                	cmp    $0x78,%al
 670:	75 03                	jne    675 <strtoul+0x7a>
      p += 2;
 672:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 675:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 679:	75 29                	jne    6a4 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 67b:	8a 03                	mov    (%ebx),%al
 67d:	0f be c0             	movsbl %al,%eax
 680:	83 e8 30             	sub    $0x30,%eax
 683:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 685:	83 fe 07             	cmp    $0x7,%esi
 688:	76 06                	jbe    690 <strtoul+0x95>
    break;
 68a:	90                   	nop
 68b:	e9 b6 00 00 00       	jmp    746 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 690:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 697:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 69a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 6a1:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 6a2:	eb d7                	jmp    67b <strtoul+0x80>
    } else if (base == 10) {
 6a4:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 6a8:	75 2b                	jne    6d5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6aa:	8a 03                	mov    (%ebx),%al
 6ac:	0f be c0             	movsbl %al,%eax
 6af:	83 e8 30             	sub    $0x30,%eax
 6b2:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 6b4:	83 fe 09             	cmp    $0x9,%esi
 6b7:	76 06                	jbe    6bf <strtoul+0xc4>
    break;
 6b9:	90                   	nop
 6ba:	e9 87 00 00 00       	jmp    746 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 6bf:	89 f8                	mov    %edi,%eax
 6c1:	c1 e0 02             	shl    $0x2,%eax
 6c4:	01 f8                	add    %edi,%eax
 6c6:	01 c0                	add    %eax,%eax
 6c8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6cb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 6d2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 6d3:	eb d5                	jmp    6aa <strtoul+0xaf>
    } else if (base == 16) {
 6d5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 6d9:	75 35                	jne    710 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6db:	8a 03                	mov    (%ebx),%al
 6dd:	0f be c0             	movsbl %al,%eax
 6e0:	83 e8 30             	sub    $0x30,%eax
 6e3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6e5:	83 fe 4a             	cmp    $0x4a,%esi
 6e8:	76 02                	jbe    6ec <strtoul+0xf1>
    break;
 6ea:	eb 22                	jmp    70e <strtoul+0x113>
      }
      digit = cvtIn[digit];
 6ec:	8a 86 60 13 00 00    	mov    0x1360(%esi),%al
 6f2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 6f5:	83 fe 0f             	cmp    $0xf,%esi
 6f8:	76 02                	jbe    6fc <strtoul+0x101>
    break;
 6fa:	eb 12                	jmp    70e <strtoul+0x113>
      }
      result = (result << 4) + digit;
 6fc:	89 f8                	mov    %edi,%eax
 6fe:	c1 e0 04             	shl    $0x4,%eax
 701:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 704:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 70b:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 70c:	eb cd                	jmp    6db <strtoul+0xe0>
 70e:	eb 36                	jmp    746 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 710:	8a 03                	mov    (%ebx),%al
 712:	0f be c0             	movsbl %al,%eax
 715:	83 e8 30             	sub    $0x30,%eax
 718:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 71a:	83 fe 4a             	cmp    $0x4a,%esi
 71d:	76 02                	jbe    721 <strtoul+0x126>
    break;
 71f:	eb 25                	jmp    746 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 721:	8a 86 60 13 00 00    	mov    0x1360(%esi),%al
 727:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 72a:	8b 45 10             	mov    0x10(%ebp),%eax
 72d:	39 f0                	cmp    %esi,%eax
 72f:	77 02                	ja     733 <strtoul+0x138>
    break;
 731:	eb 13                	jmp    746 <strtoul+0x14b>
      }
      result = result*base + digit;
 733:	8b 45 10             	mov    0x10(%ebp),%eax
 736:	0f af c7             	imul   %edi,%eax
 739:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 73c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 743:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 744:	eb ca                	jmp    710 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 746:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74a:	75 03                	jne    74f <strtoul+0x154>
  p = string;
 74c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 74f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 753:	74 05                	je     75a <strtoul+0x15f>
  *endPtr = p;
 755:	8b 45 0c             	mov    0xc(%ebp),%eax
 758:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 75a:	89 f8                	mov    %edi,%eax
}
 75c:	83 c4 14             	add    $0x14,%esp
 75f:	5b                   	pop    %ebx
 760:	5e                   	pop    %esi
 761:	5f                   	pop    %edi
 762:	5d                   	pop    %ebp
 763:	c3                   	ret    

00000764 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	53                   	push   %ebx
 768:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 76b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 76e:	eb 01                	jmp    771 <strtol+0xd>
      p += 1;
 770:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 771:	8a 03                	mov    (%ebx),%al
 773:	0f b6 c0             	movzbl %al,%eax
 776:	89 04 24             	mov    %eax,(%esp)
 779:	e8 3f fe ff ff       	call   5bd <isspace>
 77e:	85 c0                	test   %eax,%eax
 780:	75 ee                	jne    770 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 782:	8a 03                	mov    (%ebx),%al
 784:	3c 2d                	cmp    $0x2d,%al
 786:	75 1e                	jne    7a6 <strtol+0x42>
  p += 1;
 788:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 789:	8b 45 10             	mov    0x10(%ebp),%eax
 78c:	89 44 24 08          	mov    %eax,0x8(%esp)
 790:	8b 45 0c             	mov    0xc(%ebp),%eax
 793:	89 44 24 04          	mov    %eax,0x4(%esp)
 797:	89 1c 24             	mov    %ebx,(%esp)
 79a:	e8 5c fe ff ff       	call   5fb <strtoul>
 79f:	f7 d8                	neg    %eax
 7a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
 7a4:	eb 20                	jmp    7c6 <strtol+0x62>
    } else {
  if (*p == '+') {
 7a6:	8a 03                	mov    (%ebx),%al
 7a8:	3c 2b                	cmp    $0x2b,%al
 7aa:	75 01                	jne    7ad <strtol+0x49>
      p += 1;
 7ac:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 7ad:	8b 45 10             	mov    0x10(%ebp),%eax
 7b0:	89 44 24 08          	mov    %eax,0x8(%esp)
 7b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7bb:	89 1c 24             	mov    %ebx,(%esp)
 7be:	e8 38 fe ff ff       	call   5fb <strtoul>
 7c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 7c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 7ca:	75 17                	jne    7e3 <strtol+0x7f>
 7cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7d0:	74 11                	je     7e3 <strtol+0x7f>
 7d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d5:	8b 00                	mov    (%eax),%eax
 7d7:	39 d8                	cmp    %ebx,%eax
 7d9:	75 08                	jne    7e3 <strtol+0x7f>
  *endPtr = string;
 7db:	8b 45 0c             	mov    0xc(%ebp),%eax
 7de:	8b 55 08             	mov    0x8(%ebp),%edx
 7e1:	89 10                	mov    %edx,(%eax)
    }
    return result;
 7e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 7e6:	83 c4 1c             	add    $0x1c,%esp
 7e9:	5b                   	pop    %ebx
 7ea:	5d                   	pop    %ebp
 7eb:	c3                   	ret    

000007ec <gets>:

char*
gets(char *buf, int max)
{
 7ec:	55                   	push   %ebp
 7ed:	89 e5                	mov    %esp,%ebp
 7ef:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 7f9:	eb 49                	jmp    844 <gets+0x58>
    cc = read(0, &c, 1);
 7fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 802:	00 
 803:	8d 45 ef             	lea    -0x11(%ebp),%eax
 806:	89 44 24 04          	mov    %eax,0x4(%esp)
 80a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 811:	e8 3e 01 00 00       	call   954 <read>
 816:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 819:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 81d:	7f 02                	jg     821 <gets+0x35>
      break;
 81f:	eb 2c                	jmp    84d <gets+0x61>
    buf[i++] = c;
 821:	8b 45 f4             	mov    -0xc(%ebp),%eax
 824:	8d 50 01             	lea    0x1(%eax),%edx
 827:	89 55 f4             	mov    %edx,-0xc(%ebp)
 82a:	89 c2                	mov    %eax,%edx
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
 82f:	01 c2                	add    %eax,%edx
 831:	8a 45 ef             	mov    -0x11(%ebp),%al
 834:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 836:	8a 45 ef             	mov    -0x11(%ebp),%al
 839:	3c 0a                	cmp    $0xa,%al
 83b:	74 10                	je     84d <gets+0x61>
 83d:	8a 45 ef             	mov    -0x11(%ebp),%al
 840:	3c 0d                	cmp    $0xd,%al
 842:	74 09                	je     84d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 844:	8b 45 f4             	mov    -0xc(%ebp),%eax
 847:	40                   	inc    %eax
 848:	3b 45 0c             	cmp    0xc(%ebp),%eax
 84b:	7c ae                	jl     7fb <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 84d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	01 d0                	add    %edx,%eax
 855:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 858:	8b 45 08             	mov    0x8(%ebp),%eax
}
 85b:	c9                   	leave  
 85c:	c3                   	ret    

0000085d <stat>:

int
stat(char *n, struct stat *st)
{
 85d:	55                   	push   %ebp
 85e:	89 e5                	mov    %esp,%ebp
 860:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 863:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 86a:	00 
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	89 04 24             	mov    %eax,(%esp)
 871:	e8 06 01 00 00       	call   97c <open>
 876:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 879:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 87d:	79 07                	jns    886 <stat+0x29>
    return -1;
 87f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 884:	eb 23                	jmp    8a9 <stat+0x4c>
  r = fstat(fd, st);
 886:	8b 45 0c             	mov    0xc(%ebp),%eax
 889:	89 44 24 04          	mov    %eax,0x4(%esp)
 88d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 890:	89 04 24             	mov    %eax,(%esp)
 893:	e8 fc 00 00 00       	call   994 <fstat>
 898:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	89 04 24             	mov    %eax,(%esp)
 8a1:	e8 be 00 00 00       	call   964 <close>
  return r;
 8a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8a9:	c9                   	leave  
 8aa:	c3                   	ret    

000008ab <atoi>:

int
atoi(const char *s)
{
 8ab:	55                   	push   %ebp
 8ac:	89 e5                	mov    %esp,%ebp
 8ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 8b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 8b8:	eb 24                	jmp    8de <atoi+0x33>
    n = n*10 + *s++ - '0';
 8ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 8bd:	89 d0                	mov    %edx,%eax
 8bf:	c1 e0 02             	shl    $0x2,%eax
 8c2:	01 d0                	add    %edx,%eax
 8c4:	01 c0                	add    %eax,%eax
 8c6:	89 c1                	mov    %eax,%ecx
 8c8:	8b 45 08             	mov    0x8(%ebp),%eax
 8cb:	8d 50 01             	lea    0x1(%eax),%edx
 8ce:	89 55 08             	mov    %edx,0x8(%ebp)
 8d1:	8a 00                	mov    (%eax),%al
 8d3:	0f be c0             	movsbl %al,%eax
 8d6:	01 c8                	add    %ecx,%eax
 8d8:	83 e8 30             	sub    $0x30,%eax
 8db:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8de:	8b 45 08             	mov    0x8(%ebp),%eax
 8e1:	8a 00                	mov    (%eax),%al
 8e3:	3c 2f                	cmp    $0x2f,%al
 8e5:	7e 09                	jle    8f0 <atoi+0x45>
 8e7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ea:	8a 00                	mov    (%eax),%al
 8ec:	3c 39                	cmp    $0x39,%al
 8ee:	7e ca                	jle    8ba <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 8f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8f3:	c9                   	leave  
 8f4:	c3                   	ret    

000008f5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 8f5:	55                   	push   %ebp
 8f6:	89 e5                	mov    %esp,%ebp
 8f8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 8fb:	8b 45 08             	mov    0x8(%ebp),%eax
 8fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 901:	8b 45 0c             	mov    0xc(%ebp),%eax
 904:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 907:	eb 16                	jmp    91f <memmove+0x2a>
    *dst++ = *src++;
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8d 50 01             	lea    0x1(%eax),%edx
 90f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 912:	8b 55 f8             	mov    -0x8(%ebp),%edx
 915:	8d 4a 01             	lea    0x1(%edx),%ecx
 918:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 91b:	8a 12                	mov    (%edx),%dl
 91d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 91f:	8b 45 10             	mov    0x10(%ebp),%eax
 922:	8d 50 ff             	lea    -0x1(%eax),%edx
 925:	89 55 10             	mov    %edx,0x10(%ebp)
 928:	85 c0                	test   %eax,%eax
 92a:	7f dd                	jg     909 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 92c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 92f:	c9                   	leave  
 930:	c3                   	ret    
 931:	90                   	nop
 932:	90                   	nop
 933:	90                   	nop

00000934 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 934:	b8 01 00 00 00       	mov    $0x1,%eax
 939:	cd 40                	int    $0x40
 93b:	c3                   	ret    

0000093c <exit>:
SYSCALL(exit)
 93c:	b8 02 00 00 00       	mov    $0x2,%eax
 941:	cd 40                	int    $0x40
 943:	c3                   	ret    

00000944 <wait>:
SYSCALL(wait)
 944:	b8 03 00 00 00       	mov    $0x3,%eax
 949:	cd 40                	int    $0x40
 94b:	c3                   	ret    

0000094c <pipe>:
SYSCALL(pipe)
 94c:	b8 04 00 00 00       	mov    $0x4,%eax
 951:	cd 40                	int    $0x40
 953:	c3                   	ret    

00000954 <read>:
SYSCALL(read)
 954:	b8 05 00 00 00       	mov    $0x5,%eax
 959:	cd 40                	int    $0x40
 95b:	c3                   	ret    

0000095c <write>:
SYSCALL(write)
 95c:	b8 10 00 00 00       	mov    $0x10,%eax
 961:	cd 40                	int    $0x40
 963:	c3                   	ret    

00000964 <close>:
SYSCALL(close)
 964:	b8 15 00 00 00       	mov    $0x15,%eax
 969:	cd 40                	int    $0x40
 96b:	c3                   	ret    

0000096c <kill>:
SYSCALL(kill)
 96c:	b8 06 00 00 00       	mov    $0x6,%eax
 971:	cd 40                	int    $0x40
 973:	c3                   	ret    

00000974 <exec>:
SYSCALL(exec)
 974:	b8 07 00 00 00       	mov    $0x7,%eax
 979:	cd 40                	int    $0x40
 97b:	c3                   	ret    

0000097c <open>:
SYSCALL(open)
 97c:	b8 0f 00 00 00       	mov    $0xf,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <mknod>:
SYSCALL(mknod)
 984:	b8 11 00 00 00       	mov    $0x11,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <unlink>:
SYSCALL(unlink)
 98c:	b8 12 00 00 00       	mov    $0x12,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <fstat>:
SYSCALL(fstat)
 994:	b8 08 00 00 00       	mov    $0x8,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <link>:
SYSCALL(link)
 99c:	b8 13 00 00 00       	mov    $0x13,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <mkdir>:
SYSCALL(mkdir)
 9a4:	b8 14 00 00 00       	mov    $0x14,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <chdir>:
SYSCALL(chdir)
 9ac:	b8 09 00 00 00       	mov    $0x9,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <dup>:
SYSCALL(dup)
 9b4:	b8 0a 00 00 00       	mov    $0xa,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <getpid>:
SYSCALL(getpid)
 9bc:	b8 0b 00 00 00       	mov    $0xb,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    

000009c4 <sbrk>:
SYSCALL(sbrk)
 9c4:	b8 0c 00 00 00       	mov    $0xc,%eax
 9c9:	cd 40                	int    $0x40
 9cb:	c3                   	ret    

000009cc <sleep>:
SYSCALL(sleep)
 9cc:	b8 0d 00 00 00       	mov    $0xd,%eax
 9d1:	cd 40                	int    $0x40
 9d3:	c3                   	ret    

000009d4 <uptime>:
SYSCALL(uptime)
 9d4:	b8 0e 00 00 00       	mov    $0xe,%eax
 9d9:	cd 40                	int    $0x40
 9db:	c3                   	ret    

000009dc <getname>:
SYSCALL(getname)
 9dc:	b8 16 00 00 00       	mov    $0x16,%eax
 9e1:	cd 40                	int    $0x40
 9e3:	c3                   	ret    

000009e4 <setname>:
SYSCALL(setname)
 9e4:	b8 17 00 00 00       	mov    $0x17,%eax
 9e9:	cd 40                	int    $0x40
 9eb:	c3                   	ret    

000009ec <getmaxproc>:
SYSCALL(getmaxproc)
 9ec:	b8 18 00 00 00       	mov    $0x18,%eax
 9f1:	cd 40                	int    $0x40
 9f3:	c3                   	ret    

000009f4 <setmaxproc>:
SYSCALL(setmaxproc)
 9f4:	b8 19 00 00 00       	mov    $0x19,%eax
 9f9:	cd 40                	int    $0x40
 9fb:	c3                   	ret    

000009fc <getmaxmem>:
SYSCALL(getmaxmem)
 9fc:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a01:	cd 40                	int    $0x40
 a03:	c3                   	ret    

00000a04 <setmaxmem>:
SYSCALL(setmaxmem)
 a04:	b8 1b 00 00 00       	mov    $0x1b,%eax
 a09:	cd 40                	int    $0x40
 a0b:	c3                   	ret    

00000a0c <getmaxdisk>:
SYSCALL(getmaxdisk)
 a0c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 a11:	cd 40                	int    $0x40
 a13:	c3                   	ret    

00000a14 <setmaxdisk>:
SYSCALL(setmaxdisk)
 a14:	b8 1d 00 00 00       	mov    $0x1d,%eax
 a19:	cd 40                	int    $0x40
 a1b:	c3                   	ret    

00000a1c <getusedmem>:
SYSCALL(getusedmem)
 a1c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 a21:	cd 40                	int    $0x40
 a23:	c3                   	ret    

00000a24 <setusedmem>:
SYSCALL(setusedmem)
 a24:	b8 1f 00 00 00       	mov    $0x1f,%eax
 a29:	cd 40                	int    $0x40
 a2b:	c3                   	ret    

00000a2c <getuseddisk>:
SYSCALL(getuseddisk)
 a2c:	b8 20 00 00 00       	mov    $0x20,%eax
 a31:	cd 40                	int    $0x40
 a33:	c3                   	ret    

00000a34 <setuseddisk>:
SYSCALL(setuseddisk)
 a34:	b8 21 00 00 00       	mov    $0x21,%eax
 a39:	cd 40                	int    $0x40
 a3b:	c3                   	ret    

00000a3c <setvc>:
SYSCALL(setvc)
 a3c:	b8 22 00 00 00       	mov    $0x22,%eax
 a41:	cd 40                	int    $0x40
 a43:	c3                   	ret    

00000a44 <setactivefs>:
SYSCALL(setactivefs)
 a44:	b8 24 00 00 00       	mov    $0x24,%eax
 a49:	cd 40                	int    $0x40
 a4b:	c3                   	ret    

00000a4c <getactivefs>:
SYSCALL(getactivefs)
 a4c:	b8 25 00 00 00       	mov    $0x25,%eax
 a51:	cd 40                	int    $0x40
 a53:	c3                   	ret    

00000a54 <getvcfs>:
SYSCALL(getvcfs)
 a54:	b8 23 00 00 00       	mov    $0x23,%eax
 a59:	cd 40                	int    $0x40
 a5b:	c3                   	ret    

00000a5c <getcwd>:
SYSCALL(getcwd)
 a5c:	b8 26 00 00 00       	mov    $0x26,%eax
 a61:	cd 40                	int    $0x40
 a63:	c3                   	ret    

00000a64 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a64:	55                   	push   %ebp
 a65:	89 e5                	mov    %esp,%ebp
 a67:	83 ec 18             	sub    $0x18,%esp
 a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
 a6d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a70:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 a77:	00 
 a78:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
 a7f:	8b 45 08             	mov    0x8(%ebp),%eax
 a82:	89 04 24             	mov    %eax,(%esp)
 a85:	e8 d2 fe ff ff       	call   95c <write>
}
 a8a:	c9                   	leave  
 a8b:	c3                   	ret    

00000a8c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a8c:	55                   	push   %ebp
 a8d:	89 e5                	mov    %esp,%ebp
 a8f:	56                   	push   %esi
 a90:	53                   	push   %ebx
 a91:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a94:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a9b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a9f:	74 17                	je     ab8 <printint+0x2c>
 aa1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 aa5:	79 11                	jns    ab8 <printint+0x2c>
    neg = 1;
 aa7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 aae:	8b 45 0c             	mov    0xc(%ebp),%eax
 ab1:	f7 d8                	neg    %eax
 ab3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ab6:	eb 06                	jmp    abe <printint+0x32>
  } else {
    x = xx;
 ab8:	8b 45 0c             	mov    0xc(%ebp),%eax
 abb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 abe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 ac5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 ac8:	8d 41 01             	lea    0x1(%ecx),%eax
 acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ace:	8b 5d 10             	mov    0x10(%ebp),%ebx
 ad1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ad4:	ba 00 00 00 00       	mov    $0x0,%edx
 ad9:	f7 f3                	div    %ebx
 adb:	89 d0                	mov    %edx,%eax
 add:	8a 80 ac 13 00 00    	mov    0x13ac(%eax),%al
 ae3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 ae7:	8b 75 10             	mov    0x10(%ebp),%esi
 aea:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aed:	ba 00 00 00 00       	mov    $0x0,%edx
 af2:	f7 f6                	div    %esi
 af4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 af7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 afb:	75 c8                	jne    ac5 <printint+0x39>
  if(neg)
 afd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b01:	74 10                	je     b13 <printint+0x87>
    buf[i++] = '-';
 b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b06:	8d 50 01             	lea    0x1(%eax),%edx
 b09:	89 55 f4             	mov    %edx,-0xc(%ebp)
 b0c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 b11:	eb 1e                	jmp    b31 <printint+0xa5>
 b13:	eb 1c                	jmp    b31 <printint+0xa5>
    putc(fd, buf[i]);
 b15:	8d 55 dc             	lea    -0x24(%ebp),%edx
 b18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b1b:	01 d0                	add    %edx,%eax
 b1d:	8a 00                	mov    (%eax),%al
 b1f:	0f be c0             	movsbl %al,%eax
 b22:	89 44 24 04          	mov    %eax,0x4(%esp)
 b26:	8b 45 08             	mov    0x8(%ebp),%eax
 b29:	89 04 24             	mov    %eax,(%esp)
 b2c:	e8 33 ff ff ff       	call   a64 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b31:	ff 4d f4             	decl   -0xc(%ebp)
 b34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b38:	79 db                	jns    b15 <printint+0x89>
    putc(fd, buf[i]);
}
 b3a:	83 c4 30             	add    $0x30,%esp
 b3d:	5b                   	pop    %ebx
 b3e:	5e                   	pop    %esi
 b3f:	5d                   	pop    %ebp
 b40:	c3                   	ret    

00000b41 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b41:	55                   	push   %ebp
 b42:	89 e5                	mov    %esp,%ebp
 b44:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b47:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b4e:	8d 45 0c             	lea    0xc(%ebp),%eax
 b51:	83 c0 04             	add    $0x4,%eax
 b54:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b57:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b5e:	e9 77 01 00 00       	jmp    cda <printf+0x199>
    c = fmt[i] & 0xff;
 b63:	8b 55 0c             	mov    0xc(%ebp),%edx
 b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b69:	01 d0                	add    %edx,%eax
 b6b:	8a 00                	mov    (%eax),%al
 b6d:	0f be c0             	movsbl %al,%eax
 b70:	25 ff 00 00 00       	and    $0xff,%eax
 b75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b78:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b7c:	75 2c                	jne    baa <printf+0x69>
      if(c == '%'){
 b7e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b82:	75 0c                	jne    b90 <printf+0x4f>
        state = '%';
 b84:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b8b:	e9 47 01 00 00       	jmp    cd7 <printf+0x196>
      } else {
        putc(fd, c);
 b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b93:	0f be c0             	movsbl %al,%eax
 b96:	89 44 24 04          	mov    %eax,0x4(%esp)
 b9a:	8b 45 08             	mov    0x8(%ebp),%eax
 b9d:	89 04 24             	mov    %eax,(%esp)
 ba0:	e8 bf fe ff ff       	call   a64 <putc>
 ba5:	e9 2d 01 00 00       	jmp    cd7 <printf+0x196>
      }
    } else if(state == '%'){
 baa:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 bae:	0f 85 23 01 00 00    	jne    cd7 <printf+0x196>
      if(c == 'd'){
 bb4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 bb8:	75 2d                	jne    be7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bbd:	8b 00                	mov    (%eax),%eax
 bbf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 bc6:	00 
 bc7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 bce:	00 
 bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
 bd3:	8b 45 08             	mov    0x8(%ebp),%eax
 bd6:	89 04 24             	mov    %eax,(%esp)
 bd9:	e8 ae fe ff ff       	call   a8c <printint>
        ap++;
 bde:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 be2:	e9 e9 00 00 00       	jmp    cd0 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 be7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 beb:	74 06                	je     bf3 <printf+0xb2>
 bed:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 bf1:	75 2d                	jne    c20 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 bf3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bf6:	8b 00                	mov    (%eax),%eax
 bf8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 bff:	00 
 c00:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 c07:	00 
 c08:	89 44 24 04          	mov    %eax,0x4(%esp)
 c0c:	8b 45 08             	mov    0x8(%ebp),%eax
 c0f:	89 04 24             	mov    %eax,(%esp)
 c12:	e8 75 fe ff ff       	call   a8c <printint>
        ap++;
 c17:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c1b:	e9 b0 00 00 00       	jmp    cd0 <printf+0x18f>
      } else if(c == 's'){
 c20:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 c24:	75 42                	jne    c68 <printf+0x127>
        s = (char*)*ap;
 c26:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c29:	8b 00                	mov    (%eax),%eax
 c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c2e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c36:	75 09                	jne    c41 <printf+0x100>
          s = "(null)";
 c38:	c7 45 f4 92 0f 00 00 	movl   $0xf92,-0xc(%ebp)
        while(*s != 0){
 c3f:	eb 1c                	jmp    c5d <printf+0x11c>
 c41:	eb 1a                	jmp    c5d <printf+0x11c>
          putc(fd, *s);
 c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c46:	8a 00                	mov    (%eax),%al
 c48:	0f be c0             	movsbl %al,%eax
 c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
 c4f:	8b 45 08             	mov    0x8(%ebp),%eax
 c52:	89 04 24             	mov    %eax,(%esp)
 c55:	e8 0a fe ff ff       	call   a64 <putc>
          s++;
 c5a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c60:	8a 00                	mov    (%eax),%al
 c62:	84 c0                	test   %al,%al
 c64:	75 dd                	jne    c43 <printf+0x102>
 c66:	eb 68                	jmp    cd0 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c68:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c6c:	75 1d                	jne    c8b <printf+0x14a>
        putc(fd, *ap);
 c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c71:	8b 00                	mov    (%eax),%eax
 c73:	0f be c0             	movsbl %al,%eax
 c76:	89 44 24 04          	mov    %eax,0x4(%esp)
 c7a:	8b 45 08             	mov    0x8(%ebp),%eax
 c7d:	89 04 24             	mov    %eax,(%esp)
 c80:	e8 df fd ff ff       	call   a64 <putc>
        ap++;
 c85:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c89:	eb 45                	jmp    cd0 <printf+0x18f>
      } else if(c == '%'){
 c8b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c8f:	75 17                	jne    ca8 <printf+0x167>
        putc(fd, c);
 c91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c94:	0f be c0             	movsbl %al,%eax
 c97:	89 44 24 04          	mov    %eax,0x4(%esp)
 c9b:	8b 45 08             	mov    0x8(%ebp),%eax
 c9e:	89 04 24             	mov    %eax,(%esp)
 ca1:	e8 be fd ff ff       	call   a64 <putc>
 ca6:	eb 28                	jmp    cd0 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ca8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 caf:	00 
 cb0:	8b 45 08             	mov    0x8(%ebp),%eax
 cb3:	89 04 24             	mov    %eax,(%esp)
 cb6:	e8 a9 fd ff ff       	call   a64 <putc>
        putc(fd, c);
 cbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 cbe:	0f be c0             	movsbl %al,%eax
 cc1:	89 44 24 04          	mov    %eax,0x4(%esp)
 cc5:	8b 45 08             	mov    0x8(%ebp),%eax
 cc8:	89 04 24             	mov    %eax,(%esp)
 ccb:	e8 94 fd ff ff       	call   a64 <putc>
      }
      state = 0;
 cd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 cd7:	ff 45 f0             	incl   -0x10(%ebp)
 cda:	8b 55 0c             	mov    0xc(%ebp),%edx
 cdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce0:	01 d0                	add    %edx,%eax
 ce2:	8a 00                	mov    (%eax),%al
 ce4:	84 c0                	test   %al,%al
 ce6:	0f 85 77 fe ff ff    	jne    b63 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 cec:	c9                   	leave  
 ced:	c3                   	ret    
 cee:	90                   	nop
 cef:	90                   	nop

00000cf0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cf0:	55                   	push   %ebp
 cf1:	89 e5                	mov    %esp,%ebp
 cf3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cf6:	8b 45 08             	mov    0x8(%ebp),%eax
 cf9:	83 e8 08             	sub    $0x8,%eax
 cfc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cff:	a1 d0 13 00 00       	mov    0x13d0,%eax
 d04:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d07:	eb 24                	jmp    d2d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d0c:	8b 00                	mov    (%eax),%eax
 d0e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d11:	77 12                	ja     d25 <free+0x35>
 d13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d16:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d19:	77 24                	ja     d3f <free+0x4f>
 d1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d1e:	8b 00                	mov    (%eax),%eax
 d20:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d23:	77 1a                	ja     d3f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d28:	8b 00                	mov    (%eax),%eax
 d2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d2d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d30:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d33:	76 d4                	jbe    d09 <free+0x19>
 d35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d38:	8b 00                	mov    (%eax),%eax
 d3a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d3d:	76 ca                	jbe    d09 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 d3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d42:	8b 40 04             	mov    0x4(%eax),%eax
 d45:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d4c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d4f:	01 c2                	add    %eax,%edx
 d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d54:	8b 00                	mov    (%eax),%eax
 d56:	39 c2                	cmp    %eax,%edx
 d58:	75 24                	jne    d7e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d5d:	8b 50 04             	mov    0x4(%eax),%edx
 d60:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d63:	8b 00                	mov    (%eax),%eax
 d65:	8b 40 04             	mov    0x4(%eax),%eax
 d68:	01 c2                	add    %eax,%edx
 d6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d6d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d73:	8b 00                	mov    (%eax),%eax
 d75:	8b 10                	mov    (%eax),%edx
 d77:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d7a:	89 10                	mov    %edx,(%eax)
 d7c:	eb 0a                	jmp    d88 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d81:	8b 10                	mov    (%eax),%edx
 d83:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d86:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d8b:	8b 40 04             	mov    0x4(%eax),%eax
 d8e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d98:	01 d0                	add    %edx,%eax
 d9a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d9d:	75 20                	jne    dbf <free+0xcf>
    p->s.size += bp->s.size;
 d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 da2:	8b 50 04             	mov    0x4(%eax),%edx
 da5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 da8:	8b 40 04             	mov    0x4(%eax),%eax
 dab:	01 c2                	add    %eax,%edx
 dad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 db0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 db3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 db6:	8b 10                	mov    (%eax),%edx
 db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dbb:	89 10                	mov    %edx,(%eax)
 dbd:	eb 08                	jmp    dc7 <free+0xd7>
  } else
    p->s.ptr = bp;
 dbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dc2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 dc5:	89 10                	mov    %edx,(%eax)
  freep = p;
 dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dca:	a3 d0 13 00 00       	mov    %eax,0x13d0
}
 dcf:	c9                   	leave  
 dd0:	c3                   	ret    

00000dd1 <morecore>:

static Header*
morecore(uint nu)
{
 dd1:	55                   	push   %ebp
 dd2:	89 e5                	mov    %esp,%ebp
 dd4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 dd7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 dde:	77 07                	ja     de7 <morecore+0x16>
    nu = 4096;
 de0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 de7:	8b 45 08             	mov    0x8(%ebp),%eax
 dea:	c1 e0 03             	shl    $0x3,%eax
 ded:	89 04 24             	mov    %eax,(%esp)
 df0:	e8 cf fb ff ff       	call   9c4 <sbrk>
 df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 df8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 dfc:	75 07                	jne    e05 <morecore+0x34>
    return 0;
 dfe:	b8 00 00 00 00       	mov    $0x0,%eax
 e03:	eb 22                	jmp    e27 <morecore+0x56>
  hp = (Header*)p;
 e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 e0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e0e:	8b 55 08             	mov    0x8(%ebp),%edx
 e11:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 e14:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e17:	83 c0 08             	add    $0x8,%eax
 e1a:	89 04 24             	mov    %eax,(%esp)
 e1d:	e8 ce fe ff ff       	call   cf0 <free>
  return freep;
 e22:	a1 d0 13 00 00       	mov    0x13d0,%eax
}
 e27:	c9                   	leave  
 e28:	c3                   	ret    

00000e29 <malloc>:

void*
malloc(uint nbytes)
{
 e29:	55                   	push   %ebp
 e2a:	89 e5                	mov    %esp,%ebp
 e2c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e2f:	8b 45 08             	mov    0x8(%ebp),%eax
 e32:	83 c0 07             	add    $0x7,%eax
 e35:	c1 e8 03             	shr    $0x3,%eax
 e38:	40                   	inc    %eax
 e39:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e3c:	a1 d0 13 00 00       	mov    0x13d0,%eax
 e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e48:	75 23                	jne    e6d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 e4a:	c7 45 f0 c8 13 00 00 	movl   $0x13c8,-0x10(%ebp)
 e51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e54:	a3 d0 13 00 00       	mov    %eax,0x13d0
 e59:	a1 d0 13 00 00       	mov    0x13d0,%eax
 e5e:	a3 c8 13 00 00       	mov    %eax,0x13c8
    base.s.size = 0;
 e63:	c7 05 cc 13 00 00 00 	movl   $0x0,0x13cc
 e6a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e70:	8b 00                	mov    (%eax),%eax
 e72:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e78:	8b 40 04             	mov    0x4(%eax),%eax
 e7b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e7e:	72 4d                	jb     ecd <malloc+0xa4>
      if(p->s.size == nunits)
 e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e83:	8b 40 04             	mov    0x4(%eax),%eax
 e86:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e89:	75 0c                	jne    e97 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e8e:	8b 10                	mov    (%eax),%edx
 e90:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e93:	89 10                	mov    %edx,(%eax)
 e95:	eb 26                	jmp    ebd <malloc+0x94>
      else {
        p->s.size -= nunits;
 e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e9a:	8b 40 04             	mov    0x4(%eax),%eax
 e9d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ea0:	89 c2                	mov    %eax,%edx
 ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ea5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eab:	8b 40 04             	mov    0x4(%eax),%eax
 eae:	c1 e0 03             	shl    $0x3,%eax
 eb1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 eba:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ec0:	a3 d0 13 00 00       	mov    %eax,0x13d0
      return (void*)(p + 1);
 ec5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec8:	83 c0 08             	add    $0x8,%eax
 ecb:	eb 38                	jmp    f05 <malloc+0xdc>
    }
    if(p == freep)
 ecd:	a1 d0 13 00 00       	mov    0x13d0,%eax
 ed2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ed5:	75 1b                	jne    ef2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 eda:	89 04 24             	mov    %eax,(%esp)
 edd:	e8 ef fe ff ff       	call   dd1 <morecore>
 ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ee5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ee9:	75 07                	jne    ef2 <malloc+0xc9>
        return 0;
 eeb:	b8 00 00 00 00       	mov    $0x0,%eax
 ef0:	eb 13                	jmp    f05 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ef2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ef5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 efb:	8b 00                	mov    (%eax),%eax
 efd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 f00:	e9 70 ff ff ff       	jmp    e75 <malloc+0x4c>
}
 f05:	c9                   	leave  
 f06:	c3                   	ret    
