
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
   6:	c7 45 f0 82 0d 00 00 	movl   $0xd82,-0x10(%ebp)

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
  32:	e8 45 08 00 00       	call   87c <open>
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
  59:	e8 26 08 00 00       	call   884 <mknod>
  5e:	eb 0b                	jmp    6b <create_vcs+0x6b>
    } else {
      close(fd);
  60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  63:	89 04 24             	mov    %eax,(%esp)
  66:	e8 f9 07 00 00       	call   864 <close>
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
  87:	c7 04 24 86 0d 00 00 	movl   $0xd86,(%esp)
  8e:	e8 e9 07 00 00       	call   87c <open>
  93:	85 c0                	test   %eax,%eax
  95:	79 30                	jns    c7 <main+0x51>
    mknod("console", 1, 1);
  97:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  9e:	00 
  9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  a6:	00 
  a7:	c7 04 24 86 0d 00 00 	movl   $0xd86,(%esp)
  ae:	e8 d1 07 00 00       	call   884 <mknod>
    open("console", O_RDWR);
  b3:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  ba:	00 
  bb:	c7 04 24 86 0d 00 00 	movl   $0xd86,(%esp)
  c2:	e8 b5 07 00 00       	call   87c <open>
  }
  dup(0);  // stdout
  c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  ce:	e8 e1 07 00 00       	call   8b4 <dup>
  dup(0);  // stderr
  d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  da:	e8 d5 07 00 00       	call   8b4 <dup>

  create_vcs();
  df:	e8 1c ff ff ff       	call   0 <create_vcs>

  for(;;){
    printf(1, "init: starting sh\n");
  e4:	c7 44 24 04 8e 0d 00 	movl   $0xd8e,0x4(%esp)
  eb:	00 
  ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f3:	e8 c1 08 00 00       	call   9b9 <printf>
    pid = fork();
  f8:	e8 37 07 00 00       	call   834 <fork>
  fd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
 101:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 106:	79 19                	jns    121 <main+0xab>
      printf(1, "init: fork failed\n");
 108:	c7 44 24 04 a1 0d 00 	movl   $0xda1,0x4(%esp)
 10f:	00 
 110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 117:	e8 9d 08 00 00       	call   9b9 <printf>
      exit();
 11c:	e8 1b 07 00 00       	call   83c <exit>
    }
    if(pid == 0){
 121:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
 126:	75 2d                	jne    155 <main+0xdf>
      exec("sh", argv);
 128:	c7 44 24 04 60 11 00 	movl   $0x1160,0x4(%esp)
 12f:	00 
 130:	c7 04 24 7f 0d 00 00 	movl   $0xd7f,(%esp)
 137:	e8 38 07 00 00       	call   874 <exec>
      printf(1, "init: exec sh failed\n");
 13c:	c7 44 24 04 b4 0d 00 	movl   $0xdb4,0x4(%esp)
 143:	00 
 144:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14b:	e8 69 08 00 00       	call   9b9 <printf>
      exit();
 150:	e8 e7 06 00 00       	call   83c <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 155:	eb 14                	jmp    16b <main+0xf5>
      printf(1, "zombie!\n");
 157:	c7 44 24 04 ca 0d 00 	movl   $0xdca,0x4(%esp)
 15e:	00 
 15f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 166:	e8 4e 08 00 00       	call   9b9 <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
 16b:	e8 d4 06 00 00       	call   844 <wait>
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

000001df <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1df:	55                   	push   %ebp
 1e0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1e2:	eb 06                	jmp    1ea <strcmp+0xb>
    p++, q++;
 1e4:	ff 45 08             	incl   0x8(%ebp)
 1e7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	8a 00                	mov    (%eax),%al
 1ef:	84 c0                	test   %al,%al
 1f1:	74 0e                	je     201 <strcmp+0x22>
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	8a 10                	mov    (%eax),%dl
 1f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fb:	8a 00                	mov    (%eax),%al
 1fd:	38 c2                	cmp    %al,%dl
 1ff:	74 e3                	je     1e4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	8a 00                	mov    (%eax),%al
 206:	0f b6 d0             	movzbl %al,%edx
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	8a 00                	mov    (%eax),%al
 20e:	0f b6 c0             	movzbl %al,%eax
 211:	29 c2                	sub    %eax,%edx
 213:	89 d0                	mov    %edx,%eax
}
 215:	5d                   	pop    %ebp
 216:	c3                   	ret    

00000217 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 21a:	eb 09                	jmp    225 <strncmp+0xe>
    n--, p++, q++;
 21c:	ff 4d 10             	decl   0x10(%ebp)
 21f:	ff 45 08             	incl   0x8(%ebp)
 222:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 225:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 229:	74 17                	je     242 <strncmp+0x2b>
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	8a 00                	mov    (%eax),%al
 230:	84 c0                	test   %al,%al
 232:	74 0e                	je     242 <strncmp+0x2b>
 234:	8b 45 08             	mov    0x8(%ebp),%eax
 237:	8a 10                	mov    (%eax),%dl
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	8a 00                	mov    (%eax),%al
 23e:	38 c2                	cmp    %al,%dl
 240:	74 da                	je     21c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 242:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 246:	75 07                	jne    24f <strncmp+0x38>
    return 0;
 248:	b8 00 00 00 00       	mov    $0x0,%eax
 24d:	eb 14                	jmp    263 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8a 00                	mov    (%eax),%al
 254:	0f b6 d0             	movzbl %al,%edx
 257:	8b 45 0c             	mov    0xc(%ebp),%eax
 25a:	8a 00                	mov    (%eax),%al
 25c:	0f b6 c0             	movzbl %al,%eax
 25f:	29 c2                	sub    %eax,%edx
 261:	89 d0                	mov    %edx,%eax
}
 263:	5d                   	pop    %ebp
 264:	c3                   	ret    

00000265 <strlen>:

uint
strlen(const char *s)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 26b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 272:	eb 03                	jmp    277 <strlen+0x12>
 274:	ff 45 fc             	incl   -0x4(%ebp)
 277:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	8a 00                	mov    (%eax),%al
 281:	84 c0                	test   %al,%al
 283:	75 ef                	jne    274 <strlen+0xf>
    ;
  return n;
 285:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <memset>:

void*
memset(void *dst, int c, uint n)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 290:	8b 45 10             	mov    0x10(%ebp),%eax
 293:	89 44 24 08          	mov    %eax,0x8(%esp)
 297:	8b 45 0c             	mov    0xc(%ebp),%eax
 29a:	89 44 24 04          	mov    %eax,0x4(%esp)
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	89 04 24             	mov    %eax,(%esp)
 2a4:	e8 e3 fe ff ff       	call   18c <stosb>
  return dst;
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ac:	c9                   	leave  
 2ad:	c3                   	ret    

000002ae <strchr>:

char*
strchr(const char *s, char c)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 04             	sub    $0x4,%esp
 2b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ba:	eb 12                	jmp    2ce <strchr+0x20>
    if(*s == c)
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	8a 00                	mov    (%eax),%al
 2c1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2c4:	75 05                	jne    2cb <strchr+0x1d>
      return (char*)s;
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	eb 11                	jmp    2dc <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2cb:	ff 45 08             	incl   0x8(%ebp)
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	8a 00                	mov    (%eax),%al
 2d3:	84 c0                	test   %al,%al
 2d5:	75 e5                	jne    2bc <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <strcat>:

char *
strcat(char *dest, const char *src)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2eb:	eb 03                	jmp    2f0 <strcat+0x12>
 2ed:	ff 45 fc             	incl   -0x4(%ebp)
 2f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	01 d0                	add    %edx,%eax
 2f8:	8a 00                	mov    (%eax),%al
 2fa:	84 c0                	test   %al,%al
 2fc:	75 ef                	jne    2ed <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 2fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 305:	eb 1e                	jmp    325 <strcat+0x47>
        dest[i+j] = src[j];
 307:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30d:	01 d0                	add    %edx,%eax
 30f:	89 c2                	mov    %eax,%edx
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	01 c2                	add    %eax,%edx
 316:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 319:	8b 45 0c             	mov    0xc(%ebp),%eax
 31c:	01 c8                	add    %ecx,%eax
 31e:	8a 00                	mov    (%eax),%al
 320:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 322:	ff 45 f8             	incl   -0x8(%ebp)
 325:	8b 55 f8             	mov    -0x8(%ebp),%edx
 328:	8b 45 0c             	mov    0xc(%ebp),%eax
 32b:	01 d0                	add    %edx,%eax
 32d:	8a 00                	mov    (%eax),%al
 32f:	84 c0                	test   %al,%al
 331:	75 d4                	jne    307 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 333:	8b 45 f8             	mov    -0x8(%ebp),%eax
 336:	8b 55 fc             	mov    -0x4(%ebp),%edx
 339:	01 d0                	add    %edx,%eax
 33b:	89 c2                	mov    %eax,%edx
 33d:	8b 45 08             	mov    0x8(%ebp),%eax
 340:	01 d0                	add    %edx,%eax
 342:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 345:	8b 45 08             	mov    0x8(%ebp),%eax
}
 348:	c9                   	leave  
 349:	c3                   	ret    

0000034a <strstr>:

int 
strstr(char* s, char* sub)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 350:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 357:	eb 7c                	jmp    3d5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 359:	8b 55 fc             	mov    -0x4(%ebp),%edx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	01 d0                	add    %edx,%eax
 361:	8a 10                	mov    (%eax),%dl
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	8a 00                	mov    (%eax),%al
 368:	38 c2                	cmp    %al,%dl
 36a:	75 66                	jne    3d2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 36c:	8b 45 0c             	mov    0xc(%ebp),%eax
 36f:	89 04 24             	mov    %eax,(%esp)
 372:	e8 ee fe ff ff       	call   265 <strlen>
 377:	83 f8 01             	cmp    $0x1,%eax
 37a:	75 05                	jne    381 <strstr+0x37>
            {  
                return i;
 37c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 37f:	eb 6b                	jmp    3ec <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 381:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 388:	eb 3a                	jmp    3c4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 38a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 38d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 390:	01 d0                	add    %edx,%eax
 392:	89 c2                	mov    %eax,%edx
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	01 d0                	add    %edx,%eax
 399:	8a 10                	mov    (%eax),%dl
 39b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	01 c8                	add    %ecx,%eax
 3a3:	8a 00                	mov    (%eax),%al
 3a5:	38 c2                	cmp    %al,%dl
 3a7:	75 16                	jne    3bf <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 3a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ac:	8d 50 01             	lea    0x1(%eax),%edx
 3af:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b2:	01 d0                	add    %edx,%eax
 3b4:	8a 00                	mov    (%eax),%al
 3b6:	84 c0                	test   %al,%al
 3b8:	75 07                	jne    3c1 <strstr+0x77>
                    {
                        return i;
 3ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3bd:	eb 2d                	jmp    3ec <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3bf:	eb 11                	jmp    3d2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3c1:	ff 45 f8             	incl   -0x8(%ebp)
 3c4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	01 d0                	add    %edx,%eax
 3cc:	8a 00                	mov    (%eax),%al
 3ce:	84 c0                	test   %al,%al
 3d0:	75 b8                	jne    38a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3d2:	ff 45 fc             	incl   -0x4(%ebp)
 3d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d8:	8b 45 08             	mov    0x8(%ebp),%eax
 3db:	01 d0                	add    %edx,%eax
 3dd:	8a 00                	mov    (%eax),%al
 3df:	84 c0                	test   %al,%al
 3e1:	0f 85 72 ff ff ff    	jne    359 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 3e7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3ec:	c9                   	leave  
 3ed:	c3                   	ret    

000003ee <strtok>:

char *
strtok(char *s, const char *delim)
{
 3ee:	55                   	push   %ebp
 3ef:	89 e5                	mov    %esp,%ebp
 3f1:	53                   	push   %ebx
 3f2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3f9:	75 08                	jne    403 <strtok+0x15>
  s = lasts;
 3fb:	a1 e4 11 00 00       	mov    0x11e4,%eax
 400:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	8d 50 01             	lea    0x1(%eax),%edx
 409:	89 55 08             	mov    %edx,0x8(%ebp)
 40c:	8a 00                	mov    (%eax),%al
 40e:	0f be d8             	movsbl %al,%ebx
 411:	85 db                	test   %ebx,%ebx
 413:	75 07                	jne    41c <strtok+0x2e>
      return 0;
 415:	b8 00 00 00 00       	mov    $0x0,%eax
 41a:	eb 58                	jmp    474 <strtok+0x86>
    } while (strchr(delim, ch));
 41c:	88 d8                	mov    %bl,%al
 41e:	0f be c0             	movsbl %al,%eax
 421:	89 44 24 04          	mov    %eax,0x4(%esp)
 425:	8b 45 0c             	mov    0xc(%ebp),%eax
 428:	89 04 24             	mov    %eax,(%esp)
 42b:	e8 7e fe ff ff       	call   2ae <strchr>
 430:	85 c0                	test   %eax,%eax
 432:	75 cf                	jne    403 <strtok+0x15>
    --s;
 434:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	89 44 24 04          	mov    %eax,0x4(%esp)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	89 04 24             	mov    %eax,(%esp)
 444:	e8 31 00 00 00       	call   47a <strcspn>
 449:	89 c2                	mov    %eax,%edx
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	01 d0                	add    %edx,%eax
 450:	a3 e4 11 00 00       	mov    %eax,0x11e4
    if (*lasts != 0)
 455:	a1 e4 11 00 00       	mov    0x11e4,%eax
 45a:	8a 00                	mov    (%eax),%al
 45c:	84 c0                	test   %al,%al
 45e:	74 11                	je     471 <strtok+0x83>
  *lasts++ = 0;
 460:	a1 e4 11 00 00       	mov    0x11e4,%eax
 465:	8d 50 01             	lea    0x1(%eax),%edx
 468:	89 15 e4 11 00 00    	mov    %edx,0x11e4
 46e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 471:	8b 45 08             	mov    0x8(%ebp),%eax
}
 474:	83 c4 14             	add    $0x14,%esp
 477:	5b                   	pop    %ebx
 478:	5d                   	pop    %ebp
 479:	c3                   	ret    

0000047a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 47a:	55                   	push   %ebp
 47b:	89 e5                	mov    %esp,%ebp
 47d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 480:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 487:	eb 26                	jmp    4af <strcspn+0x35>
        if(strchr(s2,*s1))
 489:	8b 45 08             	mov    0x8(%ebp),%eax
 48c:	8a 00                	mov    (%eax),%al
 48e:	0f be c0             	movsbl %al,%eax
 491:	89 44 24 04          	mov    %eax,0x4(%esp)
 495:	8b 45 0c             	mov    0xc(%ebp),%eax
 498:	89 04 24             	mov    %eax,(%esp)
 49b:	e8 0e fe ff ff       	call   2ae <strchr>
 4a0:	85 c0                	test   %eax,%eax
 4a2:	74 05                	je     4a9 <strcspn+0x2f>
            return ret;
 4a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4a7:	eb 12                	jmp    4bb <strcspn+0x41>
        else
            s1++,ret++;
 4a9:	ff 45 08             	incl   0x8(%ebp)
 4ac:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	8a 00                	mov    (%eax),%al
 4b4:	84 c0                	test   %al,%al
 4b6:	75 d1                	jne    489 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4bb:	c9                   	leave  
 4bc:	c3                   	ret    

000004bd <isspace>:

int
isspace(unsigned char c)
{
 4bd:	55                   	push   %ebp
 4be:	89 e5                	mov    %esp,%ebp
 4c0:	83 ec 04             	sub    $0x4,%esp
 4c3:	8b 45 08             	mov    0x8(%ebp),%eax
 4c6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4c9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4cd:	74 1e                	je     4ed <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4cf:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4d3:	74 18                	je     4ed <isspace+0x30>
 4d5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4d9:	74 12                	je     4ed <isspace+0x30>
 4db:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4df:	74 0c                	je     4ed <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4e1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 4e5:	74 06                	je     4ed <isspace+0x30>
 4e7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 4eb:	75 07                	jne    4f4 <isspace+0x37>
 4ed:	b8 01 00 00 00       	mov    $0x1,%eax
 4f2:	eb 05                	jmp    4f9 <isspace+0x3c>
 4f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4f9:	c9                   	leave  
 4fa:	c3                   	ret    

000004fb <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4fb:	55                   	push   %ebp
 4fc:	89 e5                	mov    %esp,%ebp
 4fe:	57                   	push   %edi
 4ff:	56                   	push   %esi
 500:	53                   	push   %ebx
 501:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 504:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 509:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 510:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 513:	eb 01                	jmp    516 <strtoul+0x1b>
  p += 1;
 515:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 516:	8a 03                	mov    (%ebx),%al
 518:	0f b6 c0             	movzbl %al,%eax
 51b:	89 04 24             	mov    %eax,(%esp)
 51e:	e8 9a ff ff ff       	call   4bd <isspace>
 523:	85 c0                	test   %eax,%eax
 525:	75 ee                	jne    515 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 52b:	75 30                	jne    55d <strtoul+0x62>
    {
  if (*p == '0') {
 52d:	8a 03                	mov    (%ebx),%al
 52f:	3c 30                	cmp    $0x30,%al
 531:	75 21                	jne    554 <strtoul+0x59>
      p += 1;
 533:	43                   	inc    %ebx
      if (*p == 'x') {
 534:	8a 03                	mov    (%ebx),%al
 536:	3c 78                	cmp    $0x78,%al
 538:	75 0a                	jne    544 <strtoul+0x49>
    p += 1;
 53a:	43                   	inc    %ebx
    base = 16;
 53b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 542:	eb 31                	jmp    575 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 544:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 54b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 552:	eb 21                	jmp    575 <strtoul+0x7a>
      }
  }
  else base = 10;
 554:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 55b:	eb 18                	jmp    575 <strtoul+0x7a>
    } else if (base == 16) {
 55d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 561:	75 12                	jne    575 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 563:	8a 03                	mov    (%ebx),%al
 565:	3c 30                	cmp    $0x30,%al
 567:	75 0c                	jne    575 <strtoul+0x7a>
 569:	8d 43 01             	lea    0x1(%ebx),%eax
 56c:	8a 00                	mov    (%eax),%al
 56e:	3c 78                	cmp    $0x78,%al
 570:	75 03                	jne    575 <strtoul+0x7a>
      p += 2;
 572:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 575:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 579:	75 29                	jne    5a4 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 57b:	8a 03                	mov    (%ebx),%al
 57d:	0f be c0             	movsbl %al,%eax
 580:	83 e8 30             	sub    $0x30,%eax
 583:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 585:	83 fe 07             	cmp    $0x7,%esi
 588:	76 06                	jbe    590 <strtoul+0x95>
    break;
 58a:	90                   	nop
 58b:	e9 b6 00 00 00       	jmp    646 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 590:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 597:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 59a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 5a1:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 5a2:	eb d7                	jmp    57b <strtoul+0x80>
    } else if (base == 10) {
 5a4:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 5a8:	75 2b                	jne    5d5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5aa:	8a 03                	mov    (%ebx),%al
 5ac:	0f be c0             	movsbl %al,%eax
 5af:	83 e8 30             	sub    $0x30,%eax
 5b2:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5b4:	83 fe 09             	cmp    $0x9,%esi
 5b7:	76 06                	jbe    5bf <strtoul+0xc4>
    break;
 5b9:	90                   	nop
 5ba:	e9 87 00 00 00       	jmp    646 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5bf:	89 f8                	mov    %edi,%eax
 5c1:	c1 e0 02             	shl    $0x2,%eax
 5c4:	01 f8                	add    %edi,%eax
 5c6:	01 c0                	add    %eax,%eax
 5c8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5cb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5d2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5d3:	eb d5                	jmp    5aa <strtoul+0xaf>
    } else if (base == 16) {
 5d5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5d9:	75 35                	jne    610 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5db:	8a 03                	mov    (%ebx),%al
 5dd:	0f be c0             	movsbl %al,%eax
 5e0:	83 e8 30             	sub    $0x30,%eax
 5e3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5e5:	83 fe 4a             	cmp    $0x4a,%esi
 5e8:	76 02                	jbe    5ec <strtoul+0xf1>
    break;
 5ea:	eb 22                	jmp    60e <strtoul+0x113>
      }
      digit = cvtIn[digit];
 5ec:	8a 86 80 11 00 00    	mov    0x1180(%esi),%al
 5f2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5f5:	83 fe 0f             	cmp    $0xf,%esi
 5f8:	76 02                	jbe    5fc <strtoul+0x101>
    break;
 5fa:	eb 12                	jmp    60e <strtoul+0x113>
      }
      result = (result << 4) + digit;
 5fc:	89 f8                	mov    %edi,%eax
 5fe:	c1 e0 04             	shl    $0x4,%eax
 601:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 604:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 60b:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 60c:	eb cd                	jmp    5db <strtoul+0xe0>
 60e:	eb 36                	jmp    646 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 610:	8a 03                	mov    (%ebx),%al
 612:	0f be c0             	movsbl %al,%eax
 615:	83 e8 30             	sub    $0x30,%eax
 618:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 61a:	83 fe 4a             	cmp    $0x4a,%esi
 61d:	76 02                	jbe    621 <strtoul+0x126>
    break;
 61f:	eb 25                	jmp    646 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 621:	8a 86 80 11 00 00    	mov    0x1180(%esi),%al
 627:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 62a:	8b 45 10             	mov    0x10(%ebp),%eax
 62d:	39 f0                	cmp    %esi,%eax
 62f:	77 02                	ja     633 <strtoul+0x138>
    break;
 631:	eb 13                	jmp    646 <strtoul+0x14b>
      }
      result = result*base + digit;
 633:	8b 45 10             	mov    0x10(%ebp),%eax
 636:	0f af c7             	imul   %edi,%eax
 639:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 63c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 643:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 644:	eb ca                	jmp    610 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 646:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64a:	75 03                	jne    64f <strtoul+0x154>
  p = string;
 64c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 64f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 653:	74 05                	je     65a <strtoul+0x15f>
  *endPtr = p;
 655:	8b 45 0c             	mov    0xc(%ebp),%eax
 658:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 65a:	89 f8                	mov    %edi,%eax
}
 65c:	83 c4 14             	add    $0x14,%esp
 65f:	5b                   	pop    %ebx
 660:	5e                   	pop    %esi
 661:	5f                   	pop    %edi
 662:	5d                   	pop    %ebp
 663:	c3                   	ret    

00000664 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 664:	55                   	push   %ebp
 665:	89 e5                	mov    %esp,%ebp
 667:	53                   	push   %ebx
 668:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 66b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 66e:	eb 01                	jmp    671 <strtol+0xd>
      p += 1;
 670:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 671:	8a 03                	mov    (%ebx),%al
 673:	0f b6 c0             	movzbl %al,%eax
 676:	89 04 24             	mov    %eax,(%esp)
 679:	e8 3f fe ff ff       	call   4bd <isspace>
 67e:	85 c0                	test   %eax,%eax
 680:	75 ee                	jne    670 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 682:	8a 03                	mov    (%ebx),%al
 684:	3c 2d                	cmp    $0x2d,%al
 686:	75 1e                	jne    6a6 <strtol+0x42>
  p += 1;
 688:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 689:	8b 45 10             	mov    0x10(%ebp),%eax
 68c:	89 44 24 08          	mov    %eax,0x8(%esp)
 690:	8b 45 0c             	mov    0xc(%ebp),%eax
 693:	89 44 24 04          	mov    %eax,0x4(%esp)
 697:	89 1c 24             	mov    %ebx,(%esp)
 69a:	e8 5c fe ff ff       	call   4fb <strtoul>
 69f:	f7 d8                	neg    %eax
 6a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6a4:	eb 20                	jmp    6c6 <strtol+0x62>
    } else {
  if (*p == '+') {
 6a6:	8a 03                	mov    (%ebx),%al
 6a8:	3c 2b                	cmp    $0x2b,%al
 6aa:	75 01                	jne    6ad <strtol+0x49>
      p += 1;
 6ac:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6ad:	8b 45 10             	mov    0x10(%ebp),%eax
 6b0:	89 44 24 08          	mov    %eax,0x8(%esp)
 6b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bb:	89 1c 24             	mov    %ebx,(%esp)
 6be:	e8 38 fe ff ff       	call   4fb <strtoul>
 6c3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6c6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6ca:	75 17                	jne    6e3 <strtol+0x7f>
 6cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6d0:	74 11                	je     6e3 <strtol+0x7f>
 6d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d5:	8b 00                	mov    (%eax),%eax
 6d7:	39 d8                	cmp    %ebx,%eax
 6d9:	75 08                	jne    6e3 <strtol+0x7f>
  *endPtr = string;
 6db:	8b 45 0c             	mov    0xc(%ebp),%eax
 6de:	8b 55 08             	mov    0x8(%ebp),%edx
 6e1:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 6e6:	83 c4 1c             	add    $0x1c,%esp
 6e9:	5b                   	pop    %ebx
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    

000006ec <gets>:

char*
gets(char *buf, int max)
{
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6f9:	eb 49                	jmp    744 <gets+0x58>
    cc = read(0, &c, 1);
 6fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 702:	00 
 703:	8d 45 ef             	lea    -0x11(%ebp),%eax
 706:	89 44 24 04          	mov    %eax,0x4(%esp)
 70a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 711:	e8 3e 01 00 00       	call   854 <read>
 716:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 719:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 71d:	7f 02                	jg     721 <gets+0x35>
      break;
 71f:	eb 2c                	jmp    74d <gets+0x61>
    buf[i++] = c;
 721:	8b 45 f4             	mov    -0xc(%ebp),%eax
 724:	8d 50 01             	lea    0x1(%eax),%edx
 727:	89 55 f4             	mov    %edx,-0xc(%ebp)
 72a:	89 c2                	mov    %eax,%edx
 72c:	8b 45 08             	mov    0x8(%ebp),%eax
 72f:	01 c2                	add    %eax,%edx
 731:	8a 45 ef             	mov    -0x11(%ebp),%al
 734:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 736:	8a 45 ef             	mov    -0x11(%ebp),%al
 739:	3c 0a                	cmp    $0xa,%al
 73b:	74 10                	je     74d <gets+0x61>
 73d:	8a 45 ef             	mov    -0x11(%ebp),%al
 740:	3c 0d                	cmp    $0xd,%al
 742:	74 09                	je     74d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 744:	8b 45 f4             	mov    -0xc(%ebp),%eax
 747:	40                   	inc    %eax
 748:	3b 45 0c             	cmp    0xc(%ebp),%eax
 74b:	7c ae                	jl     6fb <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 74d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	01 d0                	add    %edx,%eax
 755:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 758:	8b 45 08             	mov    0x8(%ebp),%eax
}
 75b:	c9                   	leave  
 75c:	c3                   	ret    

0000075d <stat>:

int
stat(char *n, struct stat *st)
{
 75d:	55                   	push   %ebp
 75e:	89 e5                	mov    %esp,%ebp
 760:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 763:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 76a:	00 
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	89 04 24             	mov    %eax,(%esp)
 771:	e8 06 01 00 00       	call   87c <open>
 776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 779:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 77d:	79 07                	jns    786 <stat+0x29>
    return -1;
 77f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 784:	eb 23                	jmp    7a9 <stat+0x4c>
  r = fstat(fd, st);
 786:	8b 45 0c             	mov    0xc(%ebp),%eax
 789:	89 44 24 04          	mov    %eax,0x4(%esp)
 78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 fc 00 00 00       	call   894 <fstat>
 798:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 79b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79e:	89 04 24             	mov    %eax,(%esp)
 7a1:	e8 be 00 00 00       	call   864 <close>
  return r;
 7a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7a9:	c9                   	leave  
 7aa:	c3                   	ret    

000007ab <atoi>:

int
atoi(const char *s)
{
 7ab:	55                   	push   %ebp
 7ac:	89 e5                	mov    %esp,%ebp
 7ae:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7b1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7b8:	eb 24                	jmp    7de <atoi+0x33>
    n = n*10 + *s++ - '0';
 7ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7bd:	89 d0                	mov    %edx,%eax
 7bf:	c1 e0 02             	shl    $0x2,%eax
 7c2:	01 d0                	add    %edx,%eax
 7c4:	01 c0                	add    %eax,%eax
 7c6:	89 c1                	mov    %eax,%ecx
 7c8:	8b 45 08             	mov    0x8(%ebp),%eax
 7cb:	8d 50 01             	lea    0x1(%eax),%edx
 7ce:	89 55 08             	mov    %edx,0x8(%ebp)
 7d1:	8a 00                	mov    (%eax),%al
 7d3:	0f be c0             	movsbl %al,%eax
 7d6:	01 c8                	add    %ecx,%eax
 7d8:	83 e8 30             	sub    $0x30,%eax
 7db:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7de:	8b 45 08             	mov    0x8(%ebp),%eax
 7e1:	8a 00                	mov    (%eax),%al
 7e3:	3c 2f                	cmp    $0x2f,%al
 7e5:	7e 09                	jle    7f0 <atoi+0x45>
 7e7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ea:	8a 00                	mov    (%eax),%al
 7ec:	3c 39                	cmp    $0x39,%al
 7ee:	7e ca                	jle    7ba <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7f3:	c9                   	leave  
 7f4:	c3                   	ret    

000007f5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7f5:	55                   	push   %ebp
 7f6:	89 e5                	mov    %esp,%ebp
 7f8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7fb:	8b 45 08             	mov    0x8(%ebp),%eax
 7fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 801:	8b 45 0c             	mov    0xc(%ebp),%eax
 804:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 807:	eb 16                	jmp    81f <memmove+0x2a>
    *dst++ = *src++;
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8d 50 01             	lea    0x1(%eax),%edx
 80f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 812:	8b 55 f8             	mov    -0x8(%ebp),%edx
 815:	8d 4a 01             	lea    0x1(%edx),%ecx
 818:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 81b:	8a 12                	mov    (%edx),%dl
 81d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 81f:	8b 45 10             	mov    0x10(%ebp),%eax
 822:	8d 50 ff             	lea    -0x1(%eax),%edx
 825:	89 55 10             	mov    %edx,0x10(%ebp)
 828:	85 c0                	test   %eax,%eax
 82a:	7f dd                	jg     809 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 82c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 82f:	c9                   	leave  
 830:	c3                   	ret    
 831:	90                   	nop
 832:	90                   	nop
 833:	90                   	nop

00000834 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 834:	b8 01 00 00 00       	mov    $0x1,%eax
 839:	cd 40                	int    $0x40
 83b:	c3                   	ret    

0000083c <exit>:
SYSCALL(exit)
 83c:	b8 02 00 00 00       	mov    $0x2,%eax
 841:	cd 40                	int    $0x40
 843:	c3                   	ret    

00000844 <wait>:
SYSCALL(wait)
 844:	b8 03 00 00 00       	mov    $0x3,%eax
 849:	cd 40                	int    $0x40
 84b:	c3                   	ret    

0000084c <pipe>:
SYSCALL(pipe)
 84c:	b8 04 00 00 00       	mov    $0x4,%eax
 851:	cd 40                	int    $0x40
 853:	c3                   	ret    

00000854 <read>:
SYSCALL(read)
 854:	b8 05 00 00 00       	mov    $0x5,%eax
 859:	cd 40                	int    $0x40
 85b:	c3                   	ret    

0000085c <write>:
SYSCALL(write)
 85c:	b8 10 00 00 00       	mov    $0x10,%eax
 861:	cd 40                	int    $0x40
 863:	c3                   	ret    

00000864 <close>:
SYSCALL(close)
 864:	b8 15 00 00 00       	mov    $0x15,%eax
 869:	cd 40                	int    $0x40
 86b:	c3                   	ret    

0000086c <kill>:
SYSCALL(kill)
 86c:	b8 06 00 00 00       	mov    $0x6,%eax
 871:	cd 40                	int    $0x40
 873:	c3                   	ret    

00000874 <exec>:
SYSCALL(exec)
 874:	b8 07 00 00 00       	mov    $0x7,%eax
 879:	cd 40                	int    $0x40
 87b:	c3                   	ret    

0000087c <open>:
SYSCALL(open)
 87c:	b8 0f 00 00 00       	mov    $0xf,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <mknod>:
SYSCALL(mknod)
 884:	b8 11 00 00 00       	mov    $0x11,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <unlink>:
SYSCALL(unlink)
 88c:	b8 12 00 00 00       	mov    $0x12,%eax
 891:	cd 40                	int    $0x40
 893:	c3                   	ret    

00000894 <fstat>:
SYSCALL(fstat)
 894:	b8 08 00 00 00       	mov    $0x8,%eax
 899:	cd 40                	int    $0x40
 89b:	c3                   	ret    

0000089c <link>:
SYSCALL(link)
 89c:	b8 13 00 00 00       	mov    $0x13,%eax
 8a1:	cd 40                	int    $0x40
 8a3:	c3                   	ret    

000008a4 <mkdir>:
SYSCALL(mkdir)
 8a4:	b8 14 00 00 00       	mov    $0x14,%eax
 8a9:	cd 40                	int    $0x40
 8ab:	c3                   	ret    

000008ac <chdir>:
SYSCALL(chdir)
 8ac:	b8 09 00 00 00       	mov    $0x9,%eax
 8b1:	cd 40                	int    $0x40
 8b3:	c3                   	ret    

000008b4 <dup>:
SYSCALL(dup)
 8b4:	b8 0a 00 00 00       	mov    $0xa,%eax
 8b9:	cd 40                	int    $0x40
 8bb:	c3                   	ret    

000008bc <getpid>:
SYSCALL(getpid)
 8bc:	b8 0b 00 00 00       	mov    $0xb,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <sbrk>:
SYSCALL(sbrk)
 8c4:	b8 0c 00 00 00       	mov    $0xc,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <sleep>:
SYSCALL(sleep)
 8cc:	b8 0d 00 00 00       	mov    $0xd,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <uptime>:
SYSCALL(uptime)
 8d4:	b8 0e 00 00 00       	mov    $0xe,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8dc:	55                   	push   %ebp
 8dd:	89 e5                	mov    %esp,%ebp
 8df:	83 ec 18             	sub    $0x18,%esp
 8e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8e8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8ef:	00 
 8f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	89 04 24             	mov    %eax,(%esp)
 8fd:	e8 5a ff ff ff       	call   85c <write>
}
 902:	c9                   	leave  
 903:	c3                   	ret    

00000904 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 904:	55                   	push   %ebp
 905:	89 e5                	mov    %esp,%ebp
 907:	56                   	push   %esi
 908:	53                   	push   %ebx
 909:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 90c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 913:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 917:	74 17                	je     930 <printint+0x2c>
 919:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 91d:	79 11                	jns    930 <printint+0x2c>
    neg = 1;
 91f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 926:	8b 45 0c             	mov    0xc(%ebp),%eax
 929:	f7 d8                	neg    %eax
 92b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 92e:	eb 06                	jmp    936 <printint+0x32>
  } else {
    x = xx;
 930:	8b 45 0c             	mov    0xc(%ebp),%eax
 933:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 936:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 93d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 940:	8d 41 01             	lea    0x1(%ecx),%eax
 943:	89 45 f4             	mov    %eax,-0xc(%ebp)
 946:	8b 5d 10             	mov    0x10(%ebp),%ebx
 949:	8b 45 ec             	mov    -0x14(%ebp),%eax
 94c:	ba 00 00 00 00       	mov    $0x0,%edx
 951:	f7 f3                	div    %ebx
 953:	89 d0                	mov    %edx,%eax
 955:	8a 80 cc 11 00 00    	mov    0x11cc(%eax),%al
 95b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 95f:	8b 75 10             	mov    0x10(%ebp),%esi
 962:	8b 45 ec             	mov    -0x14(%ebp),%eax
 965:	ba 00 00 00 00       	mov    $0x0,%edx
 96a:	f7 f6                	div    %esi
 96c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 96f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 973:	75 c8                	jne    93d <printint+0x39>
  if(neg)
 975:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 979:	74 10                	je     98b <printint+0x87>
    buf[i++] = '-';
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	8d 50 01             	lea    0x1(%eax),%edx
 981:	89 55 f4             	mov    %edx,-0xc(%ebp)
 984:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 989:	eb 1e                	jmp    9a9 <printint+0xa5>
 98b:	eb 1c                	jmp    9a9 <printint+0xa5>
    putc(fd, buf[i]);
 98d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	01 d0                	add    %edx,%eax
 995:	8a 00                	mov    (%eax),%al
 997:	0f be c0             	movsbl %al,%eax
 99a:	89 44 24 04          	mov    %eax,0x4(%esp)
 99e:	8b 45 08             	mov    0x8(%ebp),%eax
 9a1:	89 04 24             	mov    %eax,(%esp)
 9a4:	e8 33 ff ff ff       	call   8dc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9a9:	ff 4d f4             	decl   -0xc(%ebp)
 9ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b0:	79 db                	jns    98d <printint+0x89>
    putc(fd, buf[i]);
}
 9b2:	83 c4 30             	add    $0x30,%esp
 9b5:	5b                   	pop    %ebx
 9b6:	5e                   	pop    %esi
 9b7:	5d                   	pop    %ebp
 9b8:	c3                   	ret    

000009b9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9b9:	55                   	push   %ebp
 9ba:	89 e5                	mov    %esp,%ebp
 9bc:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9bf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9c6:	8d 45 0c             	lea    0xc(%ebp),%eax
 9c9:	83 c0 04             	add    $0x4,%eax
 9cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9d6:	e9 77 01 00 00       	jmp    b52 <printf+0x199>
    c = fmt[i] & 0xff;
 9db:	8b 55 0c             	mov    0xc(%ebp),%edx
 9de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e1:	01 d0                	add    %edx,%eax
 9e3:	8a 00                	mov    (%eax),%al
 9e5:	0f be c0             	movsbl %al,%eax
 9e8:	25 ff 00 00 00       	and    $0xff,%eax
 9ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9f4:	75 2c                	jne    a22 <printf+0x69>
      if(c == '%'){
 9f6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9fa:	75 0c                	jne    a08 <printf+0x4f>
        state = '%';
 9fc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a03:	e9 47 01 00 00       	jmp    b4f <printf+0x196>
      } else {
        putc(fd, c);
 a08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a0b:	0f be c0             	movsbl %al,%eax
 a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a12:	8b 45 08             	mov    0x8(%ebp),%eax
 a15:	89 04 24             	mov    %eax,(%esp)
 a18:	e8 bf fe ff ff       	call   8dc <putc>
 a1d:	e9 2d 01 00 00       	jmp    b4f <printf+0x196>
      }
    } else if(state == '%'){
 a22:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a26:	0f 85 23 01 00 00    	jne    b4f <printf+0x196>
      if(c == 'd'){
 a2c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a30:	75 2d                	jne    a5f <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a32:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a35:	8b 00                	mov    (%eax),%eax
 a37:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a3e:	00 
 a3f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a46:	00 
 a47:	89 44 24 04          	mov    %eax,0x4(%esp)
 a4b:	8b 45 08             	mov    0x8(%ebp),%eax
 a4e:	89 04 24             	mov    %eax,(%esp)
 a51:	e8 ae fe ff ff       	call   904 <printint>
        ap++;
 a56:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a5a:	e9 e9 00 00 00       	jmp    b48 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a5f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a63:	74 06                	je     a6b <printf+0xb2>
 a65:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a69:	75 2d                	jne    a98 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a6e:	8b 00                	mov    (%eax),%eax
 a70:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a77:	00 
 a78:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a7f:	00 
 a80:	89 44 24 04          	mov    %eax,0x4(%esp)
 a84:	8b 45 08             	mov    0x8(%ebp),%eax
 a87:	89 04 24             	mov    %eax,(%esp)
 a8a:	e8 75 fe ff ff       	call   904 <printint>
        ap++;
 a8f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a93:	e9 b0 00 00 00       	jmp    b48 <printf+0x18f>
      } else if(c == 's'){
 a98:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a9c:	75 42                	jne    ae0 <printf+0x127>
        s = (char*)*ap;
 a9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aa1:	8b 00                	mov    (%eax),%eax
 aa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 aa6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aae:	75 09                	jne    ab9 <printf+0x100>
          s = "(null)";
 ab0:	c7 45 f4 d3 0d 00 00 	movl   $0xdd3,-0xc(%ebp)
        while(*s != 0){
 ab7:	eb 1c                	jmp    ad5 <printf+0x11c>
 ab9:	eb 1a                	jmp    ad5 <printf+0x11c>
          putc(fd, *s);
 abb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 abe:	8a 00                	mov    (%eax),%al
 ac0:	0f be c0             	movsbl %al,%eax
 ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
 ac7:	8b 45 08             	mov    0x8(%ebp),%eax
 aca:	89 04 24             	mov    %eax,(%esp)
 acd:	e8 0a fe ff ff       	call   8dc <putc>
          s++;
 ad2:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad8:	8a 00                	mov    (%eax),%al
 ada:	84 c0                	test   %al,%al
 adc:	75 dd                	jne    abb <printf+0x102>
 ade:	eb 68                	jmp    b48 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ae0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ae4:	75 1d                	jne    b03 <printf+0x14a>
        putc(fd, *ap);
 ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ae9:	8b 00                	mov    (%eax),%eax
 aeb:	0f be c0             	movsbl %al,%eax
 aee:	89 44 24 04          	mov    %eax,0x4(%esp)
 af2:	8b 45 08             	mov    0x8(%ebp),%eax
 af5:	89 04 24             	mov    %eax,(%esp)
 af8:	e8 df fd ff ff       	call   8dc <putc>
        ap++;
 afd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b01:	eb 45                	jmp    b48 <printf+0x18f>
      } else if(c == '%'){
 b03:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b07:	75 17                	jne    b20 <printf+0x167>
        putc(fd, c);
 b09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b0c:	0f be c0             	movsbl %al,%eax
 b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
 b13:	8b 45 08             	mov    0x8(%ebp),%eax
 b16:	89 04 24             	mov    %eax,(%esp)
 b19:	e8 be fd ff ff       	call   8dc <putc>
 b1e:	eb 28                	jmp    b48 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b20:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b27:	00 
 b28:	8b 45 08             	mov    0x8(%ebp),%eax
 b2b:	89 04 24             	mov    %eax,(%esp)
 b2e:	e8 a9 fd ff ff       	call   8dc <putc>
        putc(fd, c);
 b33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b36:	0f be c0             	movsbl %al,%eax
 b39:	89 44 24 04          	mov    %eax,0x4(%esp)
 b3d:	8b 45 08             	mov    0x8(%ebp),%eax
 b40:	89 04 24             	mov    %eax,(%esp)
 b43:	e8 94 fd ff ff       	call   8dc <putc>
      }
      state = 0;
 b48:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b4f:	ff 45 f0             	incl   -0x10(%ebp)
 b52:	8b 55 0c             	mov    0xc(%ebp),%edx
 b55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b58:	01 d0                	add    %edx,%eax
 b5a:	8a 00                	mov    (%eax),%al
 b5c:	84 c0                	test   %al,%al
 b5e:	0f 85 77 fe ff ff    	jne    9db <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b64:	c9                   	leave  
 b65:	c3                   	ret    
 b66:	90                   	nop
 b67:	90                   	nop

00000b68 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b68:	55                   	push   %ebp
 b69:	89 e5                	mov    %esp,%ebp
 b6b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b6e:	8b 45 08             	mov    0x8(%ebp),%eax
 b71:	83 e8 08             	sub    $0x8,%eax
 b74:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b77:	a1 f0 11 00 00       	mov    0x11f0,%eax
 b7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b7f:	eb 24                	jmp    ba5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b81:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b84:	8b 00                	mov    (%eax),%eax
 b86:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b89:	77 12                	ja     b9d <free+0x35>
 b8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b8e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b91:	77 24                	ja     bb7 <free+0x4f>
 b93:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b96:	8b 00                	mov    (%eax),%eax
 b98:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b9b:	77 1a                	ja     bb7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba0:	8b 00                	mov    (%eax),%eax
 ba2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ba5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ba8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bab:	76 d4                	jbe    b81 <free+0x19>
 bad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb0:	8b 00                	mov    (%eax),%eax
 bb2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bb5:	76 ca                	jbe    b81 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bba:	8b 40 04             	mov    0x4(%eax),%eax
 bbd:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bc7:	01 c2                	add    %eax,%edx
 bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bcc:	8b 00                	mov    (%eax),%eax
 bce:	39 c2                	cmp    %eax,%edx
 bd0:	75 24                	jne    bf6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd5:	8b 50 04             	mov    0x4(%eax),%edx
 bd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdb:	8b 00                	mov    (%eax),%eax
 bdd:	8b 40 04             	mov    0x4(%eax),%eax
 be0:	01 c2                	add    %eax,%edx
 be2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 be8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 beb:	8b 00                	mov    (%eax),%eax
 bed:	8b 10                	mov    (%eax),%edx
 bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf2:	89 10                	mov    %edx,(%eax)
 bf4:	eb 0a                	jmp    c00 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 bf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf9:	8b 10                	mov    (%eax),%edx
 bfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bfe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c03:	8b 40 04             	mov    0x4(%eax),%eax
 c06:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c10:	01 d0                	add    %edx,%eax
 c12:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c15:	75 20                	jne    c37 <free+0xcf>
    p->s.size += bp->s.size;
 c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1a:	8b 50 04             	mov    0x4(%eax),%edx
 c1d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c20:	8b 40 04             	mov    0x4(%eax),%eax
 c23:	01 c2                	add    %eax,%edx
 c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c28:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2e:	8b 10                	mov    (%eax),%edx
 c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c33:	89 10                	mov    %edx,(%eax)
 c35:	eb 08                	jmp    c3f <free+0xd7>
  } else
    p->s.ptr = bp;
 c37:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c3d:	89 10                	mov    %edx,(%eax)
  freep = p;
 c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c42:	a3 f0 11 00 00       	mov    %eax,0x11f0
}
 c47:	c9                   	leave  
 c48:	c3                   	ret    

00000c49 <morecore>:

static Header*
morecore(uint nu)
{
 c49:	55                   	push   %ebp
 c4a:	89 e5                	mov    %esp,%ebp
 c4c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c4f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c56:	77 07                	ja     c5f <morecore+0x16>
    nu = 4096;
 c58:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c5f:	8b 45 08             	mov    0x8(%ebp),%eax
 c62:	c1 e0 03             	shl    $0x3,%eax
 c65:	89 04 24             	mov    %eax,(%esp)
 c68:	e8 57 fc ff ff       	call   8c4 <sbrk>
 c6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c70:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c74:	75 07                	jne    c7d <morecore+0x34>
    return 0;
 c76:	b8 00 00 00 00       	mov    $0x0,%eax
 c7b:	eb 22                	jmp    c9f <morecore+0x56>
  hp = (Header*)p;
 c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c80:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c83:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c86:	8b 55 08             	mov    0x8(%ebp),%edx
 c89:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c8f:	83 c0 08             	add    $0x8,%eax
 c92:	89 04 24             	mov    %eax,(%esp)
 c95:	e8 ce fe ff ff       	call   b68 <free>
  return freep;
 c9a:	a1 f0 11 00 00       	mov    0x11f0,%eax
}
 c9f:	c9                   	leave  
 ca0:	c3                   	ret    

00000ca1 <malloc>:

void*
malloc(uint nbytes)
{
 ca1:	55                   	push   %ebp
 ca2:	89 e5                	mov    %esp,%ebp
 ca4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ca7:	8b 45 08             	mov    0x8(%ebp),%eax
 caa:	83 c0 07             	add    $0x7,%eax
 cad:	c1 e8 03             	shr    $0x3,%eax
 cb0:	40                   	inc    %eax
 cb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 cb4:	a1 f0 11 00 00       	mov    0x11f0,%eax
 cb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cbc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cc0:	75 23                	jne    ce5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 cc2:	c7 45 f0 e8 11 00 00 	movl   $0x11e8,-0x10(%ebp)
 cc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ccc:	a3 f0 11 00 00       	mov    %eax,0x11f0
 cd1:	a1 f0 11 00 00       	mov    0x11f0,%eax
 cd6:	a3 e8 11 00 00       	mov    %eax,0x11e8
    base.s.size = 0;
 cdb:	c7 05 ec 11 00 00 00 	movl   $0x0,0x11ec
 ce2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce8:	8b 00                	mov    (%eax),%eax
 cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf0:	8b 40 04             	mov    0x4(%eax),%eax
 cf3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cf6:	72 4d                	jb     d45 <malloc+0xa4>
      if(p->s.size == nunits)
 cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfb:	8b 40 04             	mov    0x4(%eax),%eax
 cfe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d01:	75 0c                	jne    d0f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d06:	8b 10                	mov    (%eax),%edx
 d08:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d0b:	89 10                	mov    %edx,(%eax)
 d0d:	eb 26                	jmp    d35 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d12:	8b 40 04             	mov    0x4(%eax),%eax
 d15:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d18:	89 c2                	mov    %eax,%edx
 d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d23:	8b 40 04             	mov    0x4(%eax),%eax
 d26:	c1 e0 03             	shl    $0x3,%eax
 d29:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d32:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d38:	a3 f0 11 00 00       	mov    %eax,0x11f0
      return (void*)(p + 1);
 d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d40:	83 c0 08             	add    $0x8,%eax
 d43:	eb 38                	jmp    d7d <malloc+0xdc>
    }
    if(p == freep)
 d45:	a1 f0 11 00 00       	mov    0x11f0,%eax
 d4a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d4d:	75 1b                	jne    d6a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d4f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d52:	89 04 24             	mov    %eax,(%esp)
 d55:	e8 ef fe ff ff       	call   c49 <morecore>
 d5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d61:	75 07                	jne    d6a <malloc+0xc9>
        return 0;
 d63:	b8 00 00 00 00       	mov    $0x0,%eax
 d68:	eb 13                	jmp    d7d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d73:	8b 00                	mov    (%eax),%eax
 d75:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d78:	e9 70 ff ff ff       	jmp    ced <malloc+0x4c>
}
 d7d:	c9                   	leave  
 d7e:	c3                   	ret    
