
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
   6:	c7 45 f0 56 0e 00 00 	movl   $0xe56,-0x10(%ebp)

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
  32:	e8 19 09 00 00       	call   950 <open>
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
  59:	e8 fa 08 00 00       	call   958 <mknod>
  5e:	eb 0b                	jmp    6b <create_vcs+0x6b>
    } else {
      close(fd);
  60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  63:	89 04 24             	mov    %eax,(%esp)
  66:	e8 cd 08 00 00       	call   938 <close>
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
  7c:	83 ec 30             	sub    $0x30,%esp
  int i, pid, wpid, id, fd;

  if(open("console", O_RDWR) < 0){
  7f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  86:	00 
  87:	c7 04 24 5a 0e 00 00 	movl   $0xe5a,(%esp)
  8e:	e8 bd 08 00 00       	call   950 <open>
  93:	85 c0                	test   %eax,%eax
  95:	79 30                	jns    c7 <main+0x51>
    mknod("console", 1, 1);
  97:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  9e:	00 
  9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 5a 0e 00 00 	movl   $0xe5a,(%esp)
  ae:	e8 a5 08 00 00       	call   958 <mknod>
    open("console", O_RDWR);
  b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  ba:	00 
  bb:	c7 04 24 5a 0e 00 00 	movl   $0xe5a,(%esp)
  c2:	e8 89 08 00 00       	call   950 <open>
  }
  dup(0);  // stdout
  c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ce:	e8 b5 08 00 00       	call   988 <dup>
  dup(0);  // stderr
  d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  da:	e8 a9 08 00 00       	call   988 <dup>

  create_vcs();
  df:	e8 1c ff ff ff       	call   0 <create_vcs>

  for(;;){
    printf(1, "init: starting sh\n");
  e4:	c7 44 24 04 62 0e 00 	movl   $0xe62,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 95 09 00 00       	call   a8d <printf>
    pid = fork();
  f8:	e8 0b 08 00 00       	call   908 <fork>
  fd:	89 44 24 28          	mov    %eax,0x28(%esp)
    if(pid < 0){
 101:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
 106:	79 19                	jns    121 <main+0xab>
      printf(1, "init: fork failed\n");
 108:	c7 44 24 04 75 0e 00 	movl   $0xe75,0x4(%esp)
 10f:	00 
 110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 117:	e8 71 09 00 00       	call   a8d <printf>
      exit();
 11c:	e8 ef 07 00 00       	call   910 <exit>
    }
    if(pid == 0){
 121:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
 126:	75 2d                	jne    155 <main+0xdf>
      exec("sh", argv);
 128:	c7 44 24 04 40 12 00 	movl   $0x1240,0x4(%esp)
 12f:	00 
 130:	c7 04 24 53 0e 00 00 	movl   $0xe53,(%esp)
 137:	e8 0c 08 00 00       	call   948 <exec>
      printf(1, "init: exec sh failed\n");
 13c:	c7 44 24 04 88 0e 00 	movl   $0xe88,0x4(%esp)
 143:	00 
 144:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14b:	e8 3d 09 00 00       	call   a8d <printf>
      exit();
 150:	e8 bb 07 00 00       	call   910 <exit>
    }
    if(pid > 0)
 155:	83 7c 24 28 00       	cmpl   $0x0,0x28(%esp)
 15a:	0f 8e ca 00 00 00    	jle    22a <main+0x1b4>
    {
      char *dname = "vc0";
 160:	c7 44 24 24 56 0e 00 	movl   $0xe56,0x24(%esp)
 167:	00 
      for (i = 0; i < 4; i++)
 168:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
 16f:	00 
 170:	e9 aa 00 00 00       	jmp    21f <main+0x1a9>
      {
        dname[2] = '0' + i;
 175:	8b 44 24 24          	mov    0x24(%esp),%eax
 179:	8d 50 02             	lea    0x2(%eax),%edx
 17c:	8b 44 24 2c          	mov    0x2c(%esp),%eax
 180:	83 c0 30             	add    $0x30,%eax
 183:	88 02                	mov    %al,(%edx)
        fd = open(dname, O_RDWR);
 185:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
 18c:	00 
 18d:	8b 44 24 24          	mov    0x24(%esp),%eax
 191:	89 04 24             	mov    %eax,(%esp)
 194:	e8 b7 07 00 00       	call   950 <open>
 199:	89 44 24 20          	mov    %eax,0x20(%esp)

        /* fork a child and exec argv[1] */
        id = fork();
 19d:	e8 66 07 00 00       	call   908 <fork>
 1a2:	89 44 24 1c          	mov    %eax,0x1c(%esp)

        if (id == 0){
 1a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 1ab:	75 62                	jne    20f <main+0x199>
          close(0);
 1ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b4:	e8 7f 07 00 00       	call   938 <close>
          close(1);
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 73 07 00 00       	call   938 <close>
          close(2);
 1c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 1cc:	e8 67 07 00 00       	call   938 <close>
          dup(fd);
 1d1:	8b 44 24 20          	mov    0x20(%esp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 ab 07 00 00       	call   988 <dup>
          dup(fd);
 1dd:	8b 44 24 20          	mov    0x20(%esp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 9f 07 00 00       	call   988 <dup>
          dup(fd);
 1e9:	8b 44 24 20          	mov    0x20(%esp),%eax
 1ed:	89 04 24             	mov    %eax,(%esp)
 1f0:	e8 93 07 00 00       	call   988 <dup>
          exec(argv[0], &argv[0]);
 1f5:	a1 40 12 00 00       	mov    0x1240,%eax
 1fa:	c7 44 24 04 40 12 00 	movl   $0x1240,0x4(%esp)
 201:	00 
 202:	89 04 24             	mov    %eax,(%esp)
 205:	e8 3e 07 00 00       	call   948 <exec>
          exit();
 20a:	e8 01 07 00 00       	call   910 <exit>
        }
        close(fd);
 20f:	8b 44 24 20          	mov    0x20(%esp),%eax
 213:	89 04 24             	mov    %eax,(%esp)
 216:	e8 1d 07 00 00       	call   938 <close>
      exit();
    }
    if(pid > 0)
    {
      char *dname = "vc0";
      for (i = 0; i < 4; i++)
 21b:	ff 44 24 2c          	incl   0x2c(%esp)
 21f:	83 7c 24 2c 03       	cmpl   $0x3,0x2c(%esp)
 224:	0f 8e 4b ff ff ff    	jle    175 <main+0xff>
          exit();
        }
        close(fd);
      }
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 22a:	eb 14                	jmp    240 <main+0x1ca>
      printf(1, "zombie!\n");
 22c:	c7 44 24 04 9e 0e 00 	movl   $0xe9e,0x4(%esp)
 233:	00 
 234:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 23b:	e8 4d 08 00 00       	call   a8d <printf>
          exit();
        }
        close(fd);
      }
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 240:	e8 d3 06 00 00       	call   918 <wait>
 245:	89 44 24 18          	mov    %eax,0x18(%esp)
 249:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 24e:	78 0a                	js     25a <main+0x1e4>
 250:	8b 44 24 18          	mov    0x18(%esp),%eax
 254:	3b 44 24 28          	cmp    0x28(%esp),%eax
 258:	75 d2                	jne    22c <main+0x1b6>
      printf(1, "zombie!\n");
  }
 25a:	e9 85 fe ff ff       	jmp    e4 <main+0x6e>
 25f:	90                   	nop

00000260 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 260:	55                   	push   %ebp
 261:	89 e5                	mov    %esp,%ebp
 263:	57                   	push   %edi
 264:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 265:	8b 4d 08             	mov    0x8(%ebp),%ecx
 268:	8b 55 10             	mov    0x10(%ebp),%edx
 26b:	8b 45 0c             	mov    0xc(%ebp),%eax
 26e:	89 cb                	mov    %ecx,%ebx
 270:	89 df                	mov    %ebx,%edi
 272:	89 d1                	mov    %edx,%ecx
 274:	fc                   	cld    
 275:	f3 aa                	rep stos %al,%es:(%edi)
 277:	89 ca                	mov    %ecx,%edx
 279:	89 fb                	mov    %edi,%ebx
 27b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 27e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 281:	5b                   	pop    %ebx
 282:	5f                   	pop    %edi
 283:	5d                   	pop    %ebp
 284:	c3                   	ret    

00000285 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 285:	55                   	push   %ebp
 286:	89 e5                	mov    %esp,%ebp
 288:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 291:	90                   	nop
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	8d 50 01             	lea    0x1(%eax),%edx
 298:	89 55 08             	mov    %edx,0x8(%ebp)
 29b:	8b 55 0c             	mov    0xc(%ebp),%edx
 29e:	8d 4a 01             	lea    0x1(%edx),%ecx
 2a1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 2a4:	8a 12                	mov    (%edx),%dl
 2a6:	88 10                	mov    %dl,(%eax)
 2a8:	8a 00                	mov    (%eax),%al
 2aa:	84 c0                	test   %al,%al
 2ac:	75 e4                	jne    292 <strcpy+0xd>
    ;
  return os;
 2ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b1:	c9                   	leave  
 2b2:	c3                   	ret    

000002b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2b6:	eb 06                	jmp    2be <strcmp+0xb>
    p++, q++;
 2b8:	ff 45 08             	incl   0x8(%ebp)
 2bb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	8a 00                	mov    (%eax),%al
 2c3:	84 c0                	test   %al,%al
 2c5:	74 0e                	je     2d5 <strcmp+0x22>
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	8a 10                	mov    (%eax),%dl
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	8a 00                	mov    (%eax),%al
 2d1:	38 c2                	cmp    %al,%dl
 2d3:	74 e3                	je     2b8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	8a 00                	mov    (%eax),%al
 2da:	0f b6 d0             	movzbl %al,%edx
 2dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e0:	8a 00                	mov    (%eax),%al
 2e2:	0f b6 c0             	movzbl %al,%eax
 2e5:	29 c2                	sub    %eax,%edx
 2e7:	89 d0                	mov    %edx,%eax
}
 2e9:	5d                   	pop    %ebp
 2ea:	c3                   	ret    

000002eb <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 2ee:	eb 09                	jmp    2f9 <strncmp+0xe>
    n--, p++, q++;
 2f0:	ff 4d 10             	decl   0x10(%ebp)
 2f3:	ff 45 08             	incl   0x8(%ebp)
 2f6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 2f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2fd:	74 17                	je     316 <strncmp+0x2b>
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	8a 00                	mov    (%eax),%al
 304:	84 c0                	test   %al,%al
 306:	74 0e                	je     316 <strncmp+0x2b>
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	8a 10                	mov    (%eax),%dl
 30d:	8b 45 0c             	mov    0xc(%ebp),%eax
 310:	8a 00                	mov    (%eax),%al
 312:	38 c2                	cmp    %al,%dl
 314:	74 da                	je     2f0 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 316:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 31a:	75 07                	jne    323 <strncmp+0x38>
    return 0;
 31c:	b8 00 00 00 00       	mov    $0x0,%eax
 321:	eb 14                	jmp    337 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	8a 00                	mov    (%eax),%al
 328:	0f b6 d0             	movzbl %al,%edx
 32b:	8b 45 0c             	mov    0xc(%ebp),%eax
 32e:	8a 00                	mov    (%eax),%al
 330:	0f b6 c0             	movzbl %al,%eax
 333:	29 c2                	sub    %eax,%edx
 335:	89 d0                	mov    %edx,%eax
}
 337:	5d                   	pop    %ebp
 338:	c3                   	ret    

00000339 <strlen>:

uint
strlen(const char *s)
{
 339:	55                   	push   %ebp
 33a:	89 e5                	mov    %esp,%ebp
 33c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 33f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 346:	eb 03                	jmp    34b <strlen+0x12>
 348:	ff 45 fc             	incl   -0x4(%ebp)
 34b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	01 d0                	add    %edx,%eax
 353:	8a 00                	mov    (%eax),%al
 355:	84 c0                	test   %al,%al
 357:	75 ef                	jne    348 <strlen+0xf>
    ;
  return n;
 359:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <memset>:

void*
memset(void *dst, int c, uint n)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 364:	8b 45 10             	mov    0x10(%ebp),%eax
 367:	89 44 24 08          	mov    %eax,0x8(%esp)
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	89 44 24 04          	mov    %eax,0x4(%esp)
 372:	8b 45 08             	mov    0x8(%ebp),%eax
 375:	89 04 24             	mov    %eax,(%esp)
 378:	e8 e3 fe ff ff       	call   260 <stosb>
  return dst;
 37d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 380:	c9                   	leave  
 381:	c3                   	ret    

00000382 <strchr>:

char*
strchr(const char *s, char c)
{
 382:	55                   	push   %ebp
 383:	89 e5                	mov    %esp,%ebp
 385:	83 ec 04             	sub    $0x4,%esp
 388:	8b 45 0c             	mov    0xc(%ebp),%eax
 38b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 38e:	eb 12                	jmp    3a2 <strchr+0x20>
    if(*s == c)
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	8a 00                	mov    (%eax),%al
 395:	3a 45 fc             	cmp    -0x4(%ebp),%al
 398:	75 05                	jne    39f <strchr+0x1d>
      return (char*)s;
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	eb 11                	jmp    3b0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 39f:	ff 45 08             	incl   0x8(%ebp)
 3a2:	8b 45 08             	mov    0x8(%ebp),%eax
 3a5:	8a 00                	mov    (%eax),%al
 3a7:	84 c0                	test   %al,%al
 3a9:	75 e5                	jne    390 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 3ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3b0:	c9                   	leave  
 3b1:	c3                   	ret    

000003b2 <strcat>:

char *
strcat(char *dest, const char *src)
{
 3b2:	55                   	push   %ebp
 3b3:	89 e5                	mov    %esp,%ebp
 3b5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3bf:	eb 03                	jmp    3c4 <strcat+0x12>
 3c1:	ff 45 fc             	incl   -0x4(%ebp)
 3c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	01 d0                	add    %edx,%eax
 3cc:	8a 00                	mov    (%eax),%al
 3ce:	84 c0                	test   %al,%al
 3d0:	75 ef                	jne    3c1 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 3d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 3d9:	eb 1e                	jmp    3f9 <strcat+0x47>
        dest[i+j] = src[j];
 3db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e1:	01 d0                	add    %edx,%eax
 3e3:	89 c2                	mov    %eax,%edx
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	01 c2                	add    %eax,%edx
 3ea:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f0:	01 c8                	add    %ecx,%eax
 3f2:	8a 00                	mov    (%eax),%al
 3f4:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 3f6:	ff 45 f8             	incl   -0x8(%ebp)
 3f9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ff:	01 d0                	add    %edx,%eax
 401:	8a 00                	mov    (%eax),%al
 403:	84 c0                	test   %al,%al
 405:	75 d4                	jne    3db <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 407:	8b 45 f8             	mov    -0x8(%ebp),%eax
 40a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40d:	01 d0                	add    %edx,%eax
 40f:	89 c2                	mov    %eax,%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	01 d0                	add    %edx,%eax
 416:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 419:	8b 45 08             	mov    0x8(%ebp),%eax
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <strstr>:

int 
strstr(char* s, char* sub)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 424:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 42b:	eb 7c                	jmp    4a9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 42d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	01 d0                	add    %edx,%eax
 435:	8a 10                	mov    (%eax),%dl
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	8a 00                	mov    (%eax),%al
 43c:	38 c2                	cmp    %al,%dl
 43e:	75 66                	jne    4a6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 440:	8b 45 0c             	mov    0xc(%ebp),%eax
 443:	89 04 24             	mov    %eax,(%esp)
 446:	e8 ee fe ff ff       	call   339 <strlen>
 44b:	83 f8 01             	cmp    $0x1,%eax
 44e:	75 05                	jne    455 <strstr+0x37>
            {  
                return i;
 450:	8b 45 fc             	mov    -0x4(%ebp),%eax
 453:	eb 6b                	jmp    4c0 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 455:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 45c:	eb 3a                	jmp    498 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 45e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 461:	8b 55 fc             	mov    -0x4(%ebp),%edx
 464:	01 d0                	add    %edx,%eax
 466:	89 c2                	mov    %eax,%edx
 468:	8b 45 08             	mov    0x8(%ebp),%eax
 46b:	01 d0                	add    %edx,%eax
 46d:	8a 10                	mov    (%eax),%dl
 46f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 472:	8b 45 0c             	mov    0xc(%ebp),%eax
 475:	01 c8                	add    %ecx,%eax
 477:	8a 00                	mov    (%eax),%al
 479:	38 c2                	cmp    %al,%dl
 47b:	75 16                	jne    493 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 47d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 480:	8d 50 01             	lea    0x1(%eax),%edx
 483:	8b 45 0c             	mov    0xc(%ebp),%eax
 486:	01 d0                	add    %edx,%eax
 488:	8a 00                	mov    (%eax),%al
 48a:	84 c0                	test   %al,%al
 48c:	75 07                	jne    495 <strstr+0x77>
                    {
                        return i;
 48e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 491:	eb 2d                	jmp    4c0 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 493:	eb 11                	jmp    4a6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 495:	ff 45 f8             	incl   -0x8(%ebp)
 498:	8b 55 f8             	mov    -0x8(%ebp),%edx
 49b:	8b 45 0c             	mov    0xc(%ebp),%eax
 49e:	01 d0                	add    %edx,%eax
 4a0:	8a 00                	mov    (%eax),%al
 4a2:	84 c0                	test   %al,%al
 4a4:	75 b8                	jne    45e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 4a6:	ff 45 fc             	incl   -0x4(%ebp)
 4a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ac:	8b 45 08             	mov    0x8(%ebp),%eax
 4af:	01 d0                	add    %edx,%eax
 4b1:	8a 00                	mov    (%eax),%al
 4b3:	84 c0                	test   %al,%al
 4b5:	0f 85 72 ff ff ff    	jne    42d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 4bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 4c0:	c9                   	leave  
 4c1:	c3                   	ret    

000004c2 <strtok>:

char *
strtok(char *s, const char *delim)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	53                   	push   %ebx
 4c6:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 4c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4cd:	75 08                	jne    4d7 <strtok+0x15>
  s = lasts;
 4cf:	a1 c4 12 00 00       	mov    0x12c4,%eax
 4d4:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	8d 50 01             	lea    0x1(%eax),%edx
 4dd:	89 55 08             	mov    %edx,0x8(%ebp)
 4e0:	8a 00                	mov    (%eax),%al
 4e2:	0f be d8             	movsbl %al,%ebx
 4e5:	85 db                	test   %ebx,%ebx
 4e7:	75 07                	jne    4f0 <strtok+0x2e>
      return 0;
 4e9:	b8 00 00 00 00       	mov    $0x0,%eax
 4ee:	eb 58                	jmp    548 <strtok+0x86>
    } while (strchr(delim, ch));
 4f0:	88 d8                	mov    %bl,%al
 4f2:	0f be c0             	movsbl %al,%eax
 4f5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fc:	89 04 24             	mov    %eax,(%esp)
 4ff:	e8 7e fe ff ff       	call   382 <strchr>
 504:	85 c0                	test   %eax,%eax
 506:	75 cf                	jne    4d7 <strtok+0x15>
    --s;
 508:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 50b:	8b 45 0c             	mov    0xc(%ebp),%eax
 50e:	89 44 24 04          	mov    %eax,0x4(%esp)
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	89 04 24             	mov    %eax,(%esp)
 518:	e8 31 00 00 00       	call   54e <strcspn>
 51d:	89 c2                	mov    %eax,%edx
 51f:	8b 45 08             	mov    0x8(%ebp),%eax
 522:	01 d0                	add    %edx,%eax
 524:	a3 c4 12 00 00       	mov    %eax,0x12c4
    if (*lasts != 0)
 529:	a1 c4 12 00 00       	mov    0x12c4,%eax
 52e:	8a 00                	mov    (%eax),%al
 530:	84 c0                	test   %al,%al
 532:	74 11                	je     545 <strtok+0x83>
  *lasts++ = 0;
 534:	a1 c4 12 00 00       	mov    0x12c4,%eax
 539:	8d 50 01             	lea    0x1(%eax),%edx
 53c:	89 15 c4 12 00 00    	mov    %edx,0x12c4
 542:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 545:	8b 45 08             	mov    0x8(%ebp),%eax
}
 548:	83 c4 14             	add    $0x14,%esp
 54b:	5b                   	pop    %ebx
 54c:	5d                   	pop    %ebp
 54d:	c3                   	ret    

0000054e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 54e:	55                   	push   %ebp
 54f:	89 e5                	mov    %esp,%ebp
 551:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 554:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 55b:	eb 26                	jmp    583 <strcspn+0x35>
        if(strchr(s2,*s1))
 55d:	8b 45 08             	mov    0x8(%ebp),%eax
 560:	8a 00                	mov    (%eax),%al
 562:	0f be c0             	movsbl %al,%eax
 565:	89 44 24 04          	mov    %eax,0x4(%esp)
 569:	8b 45 0c             	mov    0xc(%ebp),%eax
 56c:	89 04 24             	mov    %eax,(%esp)
 56f:	e8 0e fe ff ff       	call   382 <strchr>
 574:	85 c0                	test   %eax,%eax
 576:	74 05                	je     57d <strcspn+0x2f>
            return ret;
 578:	8b 45 fc             	mov    -0x4(%ebp),%eax
 57b:	eb 12                	jmp    58f <strcspn+0x41>
        else
            s1++,ret++;
 57d:	ff 45 08             	incl   0x8(%ebp)
 580:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 583:	8b 45 08             	mov    0x8(%ebp),%eax
 586:	8a 00                	mov    (%eax),%al
 588:	84 c0                	test   %al,%al
 58a:	75 d1                	jne    55d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 58c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 58f:	c9                   	leave  
 590:	c3                   	ret    

00000591 <isspace>:

int
isspace(unsigned char c)
{
 591:	55                   	push   %ebp
 592:	89 e5                	mov    %esp,%ebp
 594:	83 ec 04             	sub    $0x4,%esp
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 59d:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 5a1:	74 1e                	je     5c1 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 5a3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 5a7:	74 18                	je     5c1 <isspace+0x30>
 5a9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 5ad:	74 12                	je     5c1 <isspace+0x30>
 5af:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 5b3:	74 0c                	je     5c1 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 5b5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 5b9:	74 06                	je     5c1 <isspace+0x30>
 5bb:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 5bf:	75 07                	jne    5c8 <isspace+0x37>
 5c1:	b8 01 00 00 00       	mov    $0x1,%eax
 5c6:	eb 05                	jmp    5cd <isspace+0x3c>
 5c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5cd:	c9                   	leave  
 5ce:	c3                   	ret    

000005cf <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 5cf:	55                   	push   %ebp
 5d0:	89 e5                	mov    %esp,%ebp
 5d2:	57                   	push   %edi
 5d3:	56                   	push   %esi
 5d4:	53                   	push   %ebx
 5d5:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 5d8:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 5dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 5e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 5e7:	eb 01                	jmp    5ea <strtoul+0x1b>
  p += 1;
 5e9:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 5ea:	8a 03                	mov    (%ebx),%al
 5ec:	0f b6 c0             	movzbl %al,%eax
 5ef:	89 04 24             	mov    %eax,(%esp)
 5f2:	e8 9a ff ff ff       	call   591 <isspace>
 5f7:	85 c0                	test   %eax,%eax
 5f9:	75 ee                	jne    5e9 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 5fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5ff:	75 30                	jne    631 <strtoul+0x62>
    {
  if (*p == '0') {
 601:	8a 03                	mov    (%ebx),%al
 603:	3c 30                	cmp    $0x30,%al
 605:	75 21                	jne    628 <strtoul+0x59>
      p += 1;
 607:	43                   	inc    %ebx
      if (*p == 'x') {
 608:	8a 03                	mov    (%ebx),%al
 60a:	3c 78                	cmp    $0x78,%al
 60c:	75 0a                	jne    618 <strtoul+0x49>
    p += 1;
 60e:	43                   	inc    %ebx
    base = 16;
 60f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 616:	eb 31                	jmp    649 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 618:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 61f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 626:	eb 21                	jmp    649 <strtoul+0x7a>
      }
  }
  else base = 10;
 628:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 62f:	eb 18                	jmp    649 <strtoul+0x7a>
    } else if (base == 16) {
 631:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 635:	75 12                	jne    649 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 637:	8a 03                	mov    (%ebx),%al
 639:	3c 30                	cmp    $0x30,%al
 63b:	75 0c                	jne    649 <strtoul+0x7a>
 63d:	8d 43 01             	lea    0x1(%ebx),%eax
 640:	8a 00                	mov    (%eax),%al
 642:	3c 78                	cmp    $0x78,%al
 644:	75 03                	jne    649 <strtoul+0x7a>
      p += 2;
 646:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 649:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 64d:	75 29                	jne    678 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 64f:	8a 03                	mov    (%ebx),%al
 651:	0f be c0             	movsbl %al,%eax
 654:	83 e8 30             	sub    $0x30,%eax
 657:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 659:	83 fe 07             	cmp    $0x7,%esi
 65c:	76 06                	jbe    664 <strtoul+0x95>
    break;
 65e:	90                   	nop
 65f:	e9 b6 00 00 00       	jmp    71a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 664:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 66b:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 66e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 675:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 676:	eb d7                	jmp    64f <strtoul+0x80>
    } else if (base == 10) {
 678:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 67c:	75 2b                	jne    6a9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 67e:	8a 03                	mov    (%ebx),%al
 680:	0f be c0             	movsbl %al,%eax
 683:	83 e8 30             	sub    $0x30,%eax
 686:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 688:	83 fe 09             	cmp    $0x9,%esi
 68b:	76 06                	jbe    693 <strtoul+0xc4>
    break;
 68d:	90                   	nop
 68e:	e9 87 00 00 00       	jmp    71a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 693:	89 f8                	mov    %edi,%eax
 695:	c1 e0 02             	shl    $0x2,%eax
 698:	01 f8                	add    %edi,%eax
 69a:	01 c0                	add    %eax,%eax
 69c:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 69f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 6a6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 6a7:	eb d5                	jmp    67e <strtoul+0xaf>
    } else if (base == 16) {
 6a9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 6ad:	75 35                	jne    6e4 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6af:	8a 03                	mov    (%ebx),%al
 6b1:	0f be c0             	movsbl %al,%eax
 6b4:	83 e8 30             	sub    $0x30,%eax
 6b7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6b9:	83 fe 4a             	cmp    $0x4a,%esi
 6bc:	76 02                	jbe    6c0 <strtoul+0xf1>
    break;
 6be:	eb 22                	jmp    6e2 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 6c0:	8a 86 60 12 00 00    	mov    0x1260(%esi),%al
 6c6:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 6c9:	83 fe 0f             	cmp    $0xf,%esi
 6cc:	76 02                	jbe    6d0 <strtoul+0x101>
    break;
 6ce:	eb 12                	jmp    6e2 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 6d0:	89 f8                	mov    %edi,%eax
 6d2:	c1 e0 04             	shl    $0x4,%eax
 6d5:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 6df:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 6e0:	eb cd                	jmp    6af <strtoul+0xe0>
 6e2:	eb 36                	jmp    71a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 6e4:	8a 03                	mov    (%ebx),%al
 6e6:	0f be c0             	movsbl %al,%eax
 6e9:	83 e8 30             	sub    $0x30,%eax
 6ec:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6ee:	83 fe 4a             	cmp    $0x4a,%esi
 6f1:	76 02                	jbe    6f5 <strtoul+0x126>
    break;
 6f3:	eb 25                	jmp    71a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 6f5:	8a 86 60 12 00 00    	mov    0x1260(%esi),%al
 6fb:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 6fe:	8b 45 10             	mov    0x10(%ebp),%eax
 701:	39 f0                	cmp    %esi,%eax
 703:	77 02                	ja     707 <strtoul+0x138>
    break;
 705:	eb 13                	jmp    71a <strtoul+0x14b>
      }
      result = result*base + digit;
 707:	8b 45 10             	mov    0x10(%ebp),%eax
 70a:	0f af c7             	imul   %edi,%eax
 70d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 710:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 717:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 718:	eb ca                	jmp    6e4 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 71a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71e:	75 03                	jne    723 <strtoul+0x154>
  p = string;
 720:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 723:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 727:	74 05                	je     72e <strtoul+0x15f>
  *endPtr = p;
 729:	8b 45 0c             	mov    0xc(%ebp),%eax
 72c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 72e:	89 f8                	mov    %edi,%eax
}
 730:	83 c4 14             	add    $0x14,%esp
 733:	5b                   	pop    %ebx
 734:	5e                   	pop    %esi
 735:	5f                   	pop    %edi
 736:	5d                   	pop    %ebp
 737:	c3                   	ret    

00000738 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 738:	55                   	push   %ebp
 739:	89 e5                	mov    %esp,%ebp
 73b:	53                   	push   %ebx
 73c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 73f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 742:	eb 01                	jmp    745 <strtol+0xd>
      p += 1;
 744:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 745:	8a 03                	mov    (%ebx),%al
 747:	0f b6 c0             	movzbl %al,%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 3f fe ff ff       	call   591 <isspace>
 752:	85 c0                	test   %eax,%eax
 754:	75 ee                	jne    744 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 756:	8a 03                	mov    (%ebx),%al
 758:	3c 2d                	cmp    $0x2d,%al
 75a:	75 1e                	jne    77a <strtol+0x42>
  p += 1;
 75c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 75d:	8b 45 10             	mov    0x10(%ebp),%eax
 760:	89 44 24 08          	mov    %eax,0x8(%esp)
 764:	8b 45 0c             	mov    0xc(%ebp),%eax
 767:	89 44 24 04          	mov    %eax,0x4(%esp)
 76b:	89 1c 24             	mov    %ebx,(%esp)
 76e:	e8 5c fe ff ff       	call   5cf <strtoul>
 773:	f7 d8                	neg    %eax
 775:	89 45 f8             	mov    %eax,-0x8(%ebp)
 778:	eb 20                	jmp    79a <strtol+0x62>
    } else {
  if (*p == '+') {
 77a:	8a 03                	mov    (%ebx),%al
 77c:	3c 2b                	cmp    $0x2b,%al
 77e:	75 01                	jne    781 <strtol+0x49>
      p += 1;
 780:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 781:	8b 45 10             	mov    0x10(%ebp),%eax
 784:	89 44 24 08          	mov    %eax,0x8(%esp)
 788:	8b 45 0c             	mov    0xc(%ebp),%eax
 78b:	89 44 24 04          	mov    %eax,0x4(%esp)
 78f:	89 1c 24             	mov    %ebx,(%esp)
 792:	e8 38 fe ff ff       	call   5cf <strtoul>
 797:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 79a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 79e:	75 17                	jne    7b7 <strtol+0x7f>
 7a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7a4:	74 11                	je     7b7 <strtol+0x7f>
 7a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a9:	8b 00                	mov    (%eax),%eax
 7ab:	39 d8                	cmp    %ebx,%eax
 7ad:	75 08                	jne    7b7 <strtol+0x7f>
  *endPtr = string;
 7af:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b2:	8b 55 08             	mov    0x8(%ebp),%edx
 7b5:	89 10                	mov    %edx,(%eax)
    }
    return result;
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 7ba:	83 c4 1c             	add    $0x1c,%esp
 7bd:	5b                   	pop    %ebx
 7be:	5d                   	pop    %ebp
 7bf:	c3                   	ret    

000007c0 <gets>:

char*
gets(char *buf, int max)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 7cd:	eb 49                	jmp    818 <gets+0x58>
    cc = read(0, &c, 1);
 7cf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7d6:	00 
 7d7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 7da:	89 44 24 04          	mov    %eax,0x4(%esp)
 7de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7e5:	e8 3e 01 00 00       	call   928 <read>
 7ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 7ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7f1:	7f 02                	jg     7f5 <gets+0x35>
      break;
 7f3:	eb 2c                	jmp    821 <gets+0x61>
    buf[i++] = c;
 7f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f8:	8d 50 01             	lea    0x1(%eax),%edx
 7fb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7fe:	89 c2                	mov    %eax,%edx
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	01 c2                	add    %eax,%edx
 805:	8a 45 ef             	mov    -0x11(%ebp),%al
 808:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 80a:	8a 45 ef             	mov    -0x11(%ebp),%al
 80d:	3c 0a                	cmp    $0xa,%al
 80f:	74 10                	je     821 <gets+0x61>
 811:	8a 45 ef             	mov    -0x11(%ebp),%al
 814:	3c 0d                	cmp    $0xd,%al
 816:	74 09                	je     821 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 818:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81b:	40                   	inc    %eax
 81c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 81f:	7c ae                	jl     7cf <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 821:	8b 55 f4             	mov    -0xc(%ebp),%edx
 824:	8b 45 08             	mov    0x8(%ebp),%eax
 827:	01 d0                	add    %edx,%eax
 829:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 82f:	c9                   	leave  
 830:	c3                   	ret    

00000831 <stat>:

int
stat(char *n, struct stat *st)
{
 831:	55                   	push   %ebp
 832:	89 e5                	mov    %esp,%ebp
 834:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 837:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 83e:	00 
 83f:	8b 45 08             	mov    0x8(%ebp),%eax
 842:	89 04 24             	mov    %eax,(%esp)
 845:	e8 06 01 00 00       	call   950 <open>
 84a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 84d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 851:	79 07                	jns    85a <stat+0x29>
    return -1;
 853:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 858:	eb 23                	jmp    87d <stat+0x4c>
  r = fstat(fd, st);
 85a:	8b 45 0c             	mov    0xc(%ebp),%eax
 85d:	89 44 24 04          	mov    %eax,0x4(%esp)
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	89 04 24             	mov    %eax,(%esp)
 867:	e8 fc 00 00 00       	call   968 <fstat>
 86c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 86f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 872:	89 04 24             	mov    %eax,(%esp)
 875:	e8 be 00 00 00       	call   938 <close>
  return r;
 87a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 87d:	c9                   	leave  
 87e:	c3                   	ret    

0000087f <atoi>:

int
atoi(const char *s)
{
 87f:	55                   	push   %ebp
 880:	89 e5                	mov    %esp,%ebp
 882:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 88c:	eb 24                	jmp    8b2 <atoi+0x33>
    n = n*10 + *s++ - '0';
 88e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 891:	89 d0                	mov    %edx,%eax
 893:	c1 e0 02             	shl    $0x2,%eax
 896:	01 d0                	add    %edx,%eax
 898:	01 c0                	add    %eax,%eax
 89a:	89 c1                	mov    %eax,%ecx
 89c:	8b 45 08             	mov    0x8(%ebp),%eax
 89f:	8d 50 01             	lea    0x1(%eax),%edx
 8a2:	89 55 08             	mov    %edx,0x8(%ebp)
 8a5:	8a 00                	mov    (%eax),%al
 8a7:	0f be c0             	movsbl %al,%eax
 8aa:	01 c8                	add    %ecx,%eax
 8ac:	83 e8 30             	sub    $0x30,%eax
 8af:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8b2:	8b 45 08             	mov    0x8(%ebp),%eax
 8b5:	8a 00                	mov    (%eax),%al
 8b7:	3c 2f                	cmp    $0x2f,%al
 8b9:	7e 09                	jle    8c4 <atoi+0x45>
 8bb:	8b 45 08             	mov    0x8(%ebp),%eax
 8be:	8a 00                	mov    (%eax),%al
 8c0:	3c 39                	cmp    $0x39,%al
 8c2:	7e ca                	jle    88e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 8c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8c7:	c9                   	leave  
 8c8:	c3                   	ret    

000008c9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 8c9:	55                   	push   %ebp
 8ca:	89 e5                	mov    %esp,%ebp
 8cc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 8cf:	8b 45 08             	mov    0x8(%ebp),%eax
 8d2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 8d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 8db:	eb 16                	jmp    8f3 <memmove+0x2a>
    *dst++ = *src++;
 8dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e0:	8d 50 01             	lea    0x1(%eax),%edx
 8e3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 8e6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8e9:	8d 4a 01             	lea    0x1(%edx),%ecx
 8ec:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 8ef:	8a 12                	mov    (%edx),%dl
 8f1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8f3:	8b 45 10             	mov    0x10(%ebp),%eax
 8f6:	8d 50 ff             	lea    -0x1(%eax),%edx
 8f9:	89 55 10             	mov    %edx,0x10(%ebp)
 8fc:	85 c0                	test   %eax,%eax
 8fe:	7f dd                	jg     8dd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 900:	8b 45 08             	mov    0x8(%ebp),%eax
}
 903:	c9                   	leave  
 904:	c3                   	ret    
 905:	90                   	nop
 906:	90                   	nop
 907:	90                   	nop

00000908 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 908:	b8 01 00 00 00       	mov    $0x1,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <exit>:
SYSCALL(exit)
 910:	b8 02 00 00 00       	mov    $0x2,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <wait>:
SYSCALL(wait)
 918:	b8 03 00 00 00       	mov    $0x3,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <pipe>:
SYSCALL(pipe)
 920:	b8 04 00 00 00       	mov    $0x4,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <read>:
SYSCALL(read)
 928:	b8 05 00 00 00       	mov    $0x5,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <write>:
SYSCALL(write)
 930:	b8 10 00 00 00       	mov    $0x10,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <close>:
SYSCALL(close)
 938:	b8 15 00 00 00       	mov    $0x15,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <kill>:
SYSCALL(kill)
 940:	b8 06 00 00 00       	mov    $0x6,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <exec>:
SYSCALL(exec)
 948:	b8 07 00 00 00       	mov    $0x7,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <open>:
SYSCALL(open)
 950:	b8 0f 00 00 00       	mov    $0xf,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <mknod>:
SYSCALL(mknod)
 958:	b8 11 00 00 00       	mov    $0x11,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <unlink>:
SYSCALL(unlink)
 960:	b8 12 00 00 00       	mov    $0x12,%eax
 965:	cd 40                	int    $0x40
 967:	c3                   	ret    

00000968 <fstat>:
SYSCALL(fstat)
 968:	b8 08 00 00 00       	mov    $0x8,%eax
 96d:	cd 40                	int    $0x40
 96f:	c3                   	ret    

00000970 <link>:
SYSCALL(link)
 970:	b8 13 00 00 00       	mov    $0x13,%eax
 975:	cd 40                	int    $0x40
 977:	c3                   	ret    

00000978 <mkdir>:
SYSCALL(mkdir)
 978:	b8 14 00 00 00       	mov    $0x14,%eax
 97d:	cd 40                	int    $0x40
 97f:	c3                   	ret    

00000980 <chdir>:
SYSCALL(chdir)
 980:	b8 09 00 00 00       	mov    $0x9,%eax
 985:	cd 40                	int    $0x40
 987:	c3                   	ret    

00000988 <dup>:
SYSCALL(dup)
 988:	b8 0a 00 00 00       	mov    $0xa,%eax
 98d:	cd 40                	int    $0x40
 98f:	c3                   	ret    

00000990 <getpid>:
SYSCALL(getpid)
 990:	b8 0b 00 00 00       	mov    $0xb,%eax
 995:	cd 40                	int    $0x40
 997:	c3                   	ret    

00000998 <sbrk>:
SYSCALL(sbrk)
 998:	b8 0c 00 00 00       	mov    $0xc,%eax
 99d:	cd 40                	int    $0x40
 99f:	c3                   	ret    

000009a0 <sleep>:
SYSCALL(sleep)
 9a0:	b8 0d 00 00 00       	mov    $0xd,%eax
 9a5:	cd 40                	int    $0x40
 9a7:	c3                   	ret    

000009a8 <uptime>:
SYSCALL(uptime)
 9a8:	b8 0e 00 00 00       	mov    $0xe,%eax
 9ad:	cd 40                	int    $0x40
 9af:	c3                   	ret    

000009b0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	83 ec 18             	sub    $0x18,%esp
 9b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 9b9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9c3:	00 
 9c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9cb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ce:	89 04 24             	mov    %eax,(%esp)
 9d1:	e8 5a ff ff ff       	call   930 <write>
}
 9d6:	c9                   	leave  
 9d7:	c3                   	ret    

000009d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9d8:	55                   	push   %ebp
 9d9:	89 e5                	mov    %esp,%ebp
 9db:	56                   	push   %esi
 9dc:	53                   	push   %ebx
 9dd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 9e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 9e7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9eb:	74 17                	je     a04 <printint+0x2c>
 9ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9f1:	79 11                	jns    a04 <printint+0x2c>
    neg = 1;
 9f3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 9fd:	f7 d8                	neg    %eax
 9ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a02:	eb 06                	jmp    a0a <printint+0x32>
  } else {
    x = xx;
 a04:	8b 45 0c             	mov    0xc(%ebp),%eax
 a07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a11:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a14:	8d 41 01             	lea    0x1(%ecx),%eax
 a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a20:	ba 00 00 00 00       	mov    $0x0,%edx
 a25:	f7 f3                	div    %ebx
 a27:	89 d0                	mov    %edx,%eax
 a29:	8a 80 ac 12 00 00    	mov    0x12ac(%eax),%al
 a2f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a33:	8b 75 10             	mov    0x10(%ebp),%esi
 a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a39:	ba 00 00 00 00       	mov    $0x0,%edx
 a3e:	f7 f6                	div    %esi
 a40:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a47:	75 c8                	jne    a11 <printint+0x39>
  if(neg)
 a49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4d:	74 10                	je     a5f <printint+0x87>
    buf[i++] = '-';
 a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a52:	8d 50 01             	lea    0x1(%eax),%edx
 a55:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a58:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a5d:	eb 1e                	jmp    a7d <printint+0xa5>
 a5f:	eb 1c                	jmp    a7d <printint+0xa5>
    putc(fd, buf[i]);
 a61:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	01 d0                	add    %edx,%eax
 a69:	8a 00                	mov    (%eax),%al
 a6b:	0f be c0             	movsbl %al,%eax
 a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a72:	8b 45 08             	mov    0x8(%ebp),%eax
 a75:	89 04 24             	mov    %eax,(%esp)
 a78:	e8 33 ff ff ff       	call   9b0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a7d:	ff 4d f4             	decl   -0xc(%ebp)
 a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a84:	79 db                	jns    a61 <printint+0x89>
    putc(fd, buf[i]);
}
 a86:	83 c4 30             	add    $0x30,%esp
 a89:	5b                   	pop    %ebx
 a8a:	5e                   	pop    %esi
 a8b:	5d                   	pop    %ebp
 a8c:	c3                   	ret    

00000a8d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a8d:	55                   	push   %ebp
 a8e:	89 e5                	mov    %esp,%ebp
 a90:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a9a:	8d 45 0c             	lea    0xc(%ebp),%eax
 a9d:	83 c0 04             	add    $0x4,%eax
 aa0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 aa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 aaa:	e9 77 01 00 00       	jmp    c26 <printf+0x199>
    c = fmt[i] & 0xff;
 aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
 ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab5:	01 d0                	add    %edx,%eax
 ab7:	8a 00                	mov    (%eax),%al
 ab9:	0f be c0             	movsbl %al,%eax
 abc:	25 ff 00 00 00       	and    $0xff,%eax
 ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 ac4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ac8:	75 2c                	jne    af6 <printf+0x69>
      if(c == '%'){
 aca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ace:	75 0c                	jne    adc <printf+0x4f>
        state = '%';
 ad0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 ad7:	e9 47 01 00 00       	jmp    c23 <printf+0x196>
      } else {
        putc(fd, c);
 adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 adf:	0f be c0             	movsbl %al,%eax
 ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
 ae6:	8b 45 08             	mov    0x8(%ebp),%eax
 ae9:	89 04 24             	mov    %eax,(%esp)
 aec:	e8 bf fe ff ff       	call   9b0 <putc>
 af1:	e9 2d 01 00 00       	jmp    c23 <printf+0x196>
      }
    } else if(state == '%'){
 af6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 afa:	0f 85 23 01 00 00    	jne    c23 <printf+0x196>
      if(c == 'd'){
 b00:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b04:	75 2d                	jne    b33 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b09:	8b 00                	mov    (%eax),%eax
 b0b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 b12:	00 
 b13:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 b1a:	00 
 b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b1f:	8b 45 08             	mov    0x8(%ebp),%eax
 b22:	89 04 24             	mov    %eax,(%esp)
 b25:	e8 ae fe ff ff       	call   9d8 <printint>
        ap++;
 b2a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b2e:	e9 e9 00 00 00       	jmp    c1c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 b33:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b37:	74 06                	je     b3f <printf+0xb2>
 b39:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b3d:	75 2d                	jne    b6c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 b3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b42:	8b 00                	mov    (%eax),%eax
 b44:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 b4b:	00 
 b4c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b53:	00 
 b54:	89 44 24 04          	mov    %eax,0x4(%esp)
 b58:	8b 45 08             	mov    0x8(%ebp),%eax
 b5b:	89 04 24             	mov    %eax,(%esp)
 b5e:	e8 75 fe ff ff       	call   9d8 <printint>
        ap++;
 b63:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b67:	e9 b0 00 00 00       	jmp    c1c <printf+0x18f>
      } else if(c == 's'){
 b6c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b70:	75 42                	jne    bb4 <printf+0x127>
        s = (char*)*ap;
 b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b75:	8b 00                	mov    (%eax),%eax
 b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b7a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b82:	75 09                	jne    b8d <printf+0x100>
          s = "(null)";
 b84:	c7 45 f4 a7 0e 00 00 	movl   $0xea7,-0xc(%ebp)
        while(*s != 0){
 b8b:	eb 1c                	jmp    ba9 <printf+0x11c>
 b8d:	eb 1a                	jmp    ba9 <printf+0x11c>
          putc(fd, *s);
 b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b92:	8a 00                	mov    (%eax),%al
 b94:	0f be c0             	movsbl %al,%eax
 b97:	89 44 24 04          	mov    %eax,0x4(%esp)
 b9b:	8b 45 08             	mov    0x8(%ebp),%eax
 b9e:	89 04 24             	mov    %eax,(%esp)
 ba1:	e8 0a fe ff ff       	call   9b0 <putc>
          s++;
 ba6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bac:	8a 00                	mov    (%eax),%al
 bae:	84 c0                	test   %al,%al
 bb0:	75 dd                	jne    b8f <printf+0x102>
 bb2:	eb 68                	jmp    c1c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 bb4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 bb8:	75 1d                	jne    bd7 <printf+0x14a>
        putc(fd, *ap);
 bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bbd:	8b 00                	mov    (%eax),%eax
 bbf:	0f be c0             	movsbl %al,%eax
 bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
 bc6:	8b 45 08             	mov    0x8(%ebp),%eax
 bc9:	89 04 24             	mov    %eax,(%esp)
 bcc:	e8 df fd ff ff       	call   9b0 <putc>
        ap++;
 bd1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bd5:	eb 45                	jmp    c1c <printf+0x18f>
      } else if(c == '%'){
 bd7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bdb:	75 17                	jne    bf4 <printf+0x167>
        putc(fd, c);
 bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 be0:	0f be c0             	movsbl %al,%eax
 be3:	89 44 24 04          	mov    %eax,0x4(%esp)
 be7:	8b 45 08             	mov    0x8(%ebp),%eax
 bea:	89 04 24             	mov    %eax,(%esp)
 bed:	e8 be fd ff ff       	call   9b0 <putc>
 bf2:	eb 28                	jmp    c1c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 bf4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 bfb:	00 
 bfc:	8b 45 08             	mov    0x8(%ebp),%eax
 bff:	89 04 24             	mov    %eax,(%esp)
 c02:	e8 a9 fd ff ff       	call   9b0 <putc>
        putc(fd, c);
 c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c0a:	0f be c0             	movsbl %al,%eax
 c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
 c11:	8b 45 08             	mov    0x8(%ebp),%eax
 c14:	89 04 24             	mov    %eax,(%esp)
 c17:	e8 94 fd ff ff       	call   9b0 <putc>
      }
      state = 0;
 c1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c23:	ff 45 f0             	incl   -0x10(%ebp)
 c26:	8b 55 0c             	mov    0xc(%ebp),%edx
 c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c2c:	01 d0                	add    %edx,%eax
 c2e:	8a 00                	mov    (%eax),%al
 c30:	84 c0                	test   %al,%al
 c32:	0f 85 77 fe ff ff    	jne    aaf <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c38:	c9                   	leave  
 c39:	c3                   	ret    
 c3a:	90                   	nop
 c3b:	90                   	nop

00000c3c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c3c:	55                   	push   %ebp
 c3d:	89 e5                	mov    %esp,%ebp
 c3f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c42:	8b 45 08             	mov    0x8(%ebp),%eax
 c45:	83 e8 08             	sub    $0x8,%eax
 c48:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c4b:	a1 d0 12 00 00       	mov    0x12d0,%eax
 c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c53:	eb 24                	jmp    c79 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c58:	8b 00                	mov    (%eax),%eax
 c5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c5d:	77 12                	ja     c71 <free+0x35>
 c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c62:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c65:	77 24                	ja     c8b <free+0x4f>
 c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6a:	8b 00                	mov    (%eax),%eax
 c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c6f:	77 1a                	ja     c8b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c74:	8b 00                	mov    (%eax),%eax
 c76:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c7f:	76 d4                	jbe    c55 <free+0x19>
 c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c84:	8b 00                	mov    (%eax),%eax
 c86:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c89:	76 ca                	jbe    c55 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8e:	8b 40 04             	mov    0x4(%eax),%eax
 c91:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c9b:	01 c2                	add    %eax,%edx
 c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca0:	8b 00                	mov    (%eax),%eax
 ca2:	39 c2                	cmp    %eax,%edx
 ca4:	75 24                	jne    cca <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ca6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca9:	8b 50 04             	mov    0x4(%eax),%edx
 cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 caf:	8b 00                	mov    (%eax),%eax
 cb1:	8b 40 04             	mov    0x4(%eax),%eax
 cb4:	01 c2                	add    %eax,%edx
 cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbf:	8b 00                	mov    (%eax),%eax
 cc1:	8b 10                	mov    (%eax),%edx
 cc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc6:	89 10                	mov    %edx,(%eax)
 cc8:	eb 0a                	jmp    cd4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 cca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ccd:	8b 10                	mov    (%eax),%edx
 ccf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cd2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd7:	8b 40 04             	mov    0x4(%eax),%eax
 cda:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce4:	01 d0                	add    %edx,%eax
 ce6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ce9:	75 20                	jne    d0b <free+0xcf>
    p->s.size += bp->s.size;
 ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cee:	8b 50 04             	mov    0x4(%eax),%edx
 cf1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf4:	8b 40 04             	mov    0x4(%eax),%eax
 cf7:	01 c2                	add    %eax,%edx
 cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d02:	8b 10                	mov    (%eax),%edx
 d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d07:	89 10                	mov    %edx,(%eax)
 d09:	eb 08                	jmp    d13 <free+0xd7>
  } else
    p->s.ptr = bp;
 d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d0e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d11:	89 10                	mov    %edx,(%eax)
  freep = p;
 d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d16:	a3 d0 12 00 00       	mov    %eax,0x12d0
}
 d1b:	c9                   	leave  
 d1c:	c3                   	ret    

00000d1d <morecore>:

static Header*
morecore(uint nu)
{
 d1d:	55                   	push   %ebp
 d1e:	89 e5                	mov    %esp,%ebp
 d20:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d23:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d2a:	77 07                	ja     d33 <morecore+0x16>
    nu = 4096;
 d2c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d33:	8b 45 08             	mov    0x8(%ebp),%eax
 d36:	c1 e0 03             	shl    $0x3,%eax
 d39:	89 04 24             	mov    %eax,(%esp)
 d3c:	e8 57 fc ff ff       	call   998 <sbrk>
 d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d44:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d48:	75 07                	jne    d51 <morecore+0x34>
    return 0;
 d4a:	b8 00 00 00 00       	mov    $0x0,%eax
 d4f:	eb 22                	jmp    d73 <morecore+0x56>
  hp = (Header*)p;
 d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d5a:	8b 55 08             	mov    0x8(%ebp),%edx
 d5d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d63:	83 c0 08             	add    $0x8,%eax
 d66:	89 04 24             	mov    %eax,(%esp)
 d69:	e8 ce fe ff ff       	call   c3c <free>
  return freep;
 d6e:	a1 d0 12 00 00       	mov    0x12d0,%eax
}
 d73:	c9                   	leave  
 d74:	c3                   	ret    

00000d75 <malloc>:

void*
malloc(uint nbytes)
{
 d75:	55                   	push   %ebp
 d76:	89 e5                	mov    %esp,%ebp
 d78:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d7b:	8b 45 08             	mov    0x8(%ebp),%eax
 d7e:	83 c0 07             	add    $0x7,%eax
 d81:	c1 e8 03             	shr    $0x3,%eax
 d84:	40                   	inc    %eax
 d85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d88:	a1 d0 12 00 00       	mov    0x12d0,%eax
 d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d94:	75 23                	jne    db9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d96:	c7 45 f0 c8 12 00 00 	movl   $0x12c8,-0x10(%ebp)
 d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da0:	a3 d0 12 00 00       	mov    %eax,0x12d0
 da5:	a1 d0 12 00 00       	mov    0x12d0,%eax
 daa:	a3 c8 12 00 00       	mov    %eax,0x12c8
    base.s.size = 0;
 daf:	c7 05 cc 12 00 00 00 	movl   $0x0,0x12cc
 db6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dbc:	8b 00                	mov    (%eax),%eax
 dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc4:	8b 40 04             	mov    0x4(%eax),%eax
 dc7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dca:	72 4d                	jb     e19 <malloc+0xa4>
      if(p->s.size == nunits)
 dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcf:	8b 40 04             	mov    0x4(%eax),%eax
 dd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dd5:	75 0c                	jne    de3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dda:	8b 10                	mov    (%eax),%edx
 ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ddf:	89 10                	mov    %edx,(%eax)
 de1:	eb 26                	jmp    e09 <malloc+0x94>
      else {
        p->s.size -= nunits;
 de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de6:	8b 40 04             	mov    0x4(%eax),%eax
 de9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 dec:	89 c2                	mov    %eax,%edx
 dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df7:	8b 40 04             	mov    0x4(%eax),%eax
 dfa:	c1 e0 03             	shl    $0x3,%eax
 dfd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e03:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e06:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e0c:	a3 d0 12 00 00       	mov    %eax,0x12d0
      return (void*)(p + 1);
 e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e14:	83 c0 08             	add    $0x8,%eax
 e17:	eb 38                	jmp    e51 <malloc+0xdc>
    }
    if(p == freep)
 e19:	a1 d0 12 00 00       	mov    0x12d0,%eax
 e1e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e21:	75 1b                	jne    e3e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e26:	89 04 24             	mov    %eax,(%esp)
 e29:	e8 ef fe ff ff       	call   d1d <morecore>
 e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e35:	75 07                	jne    e3e <malloc+0xc9>
        return 0;
 e37:	b8 00 00 00 00       	mov    $0x0,%eax
 e3c:	eb 13                	jmp    e51 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e47:	8b 00                	mov    (%eax),%eax
 e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e4c:	e9 70 ff ff ff       	jmp    dc1 <malloc+0x4c>
}
 e51:	c9                   	leave  
 e52:	c3                   	ret    
