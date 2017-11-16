
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 ff 07 00 	movl   $0x7ff,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 16 04 00 00       	call   439 <printf>
    exit();
  23:	e8 94 02 00 00       	call   2bc <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 26                	jmp    58 <main+0x58>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 df 01 00 00       	call   22b <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 98 02 00 00       	call   2ec <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	ff 44 24 1c          	incl   0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c d1                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  61:	e8 56 02 00 00       	call   2bc <exit>
  66:	90                   	nop
  67:	90                   	nop

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	90                   	nop
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	8d 50 01             	lea    0x1(%eax),%edx
  a0:	89 55 08             	mov    %edx,0x8(%ebp)
  a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  a9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ac:	8a 12                	mov    (%edx),%dl
  ae:	88 10                	mov    %dl,(%eax)
  b0:	8a 00                	mov    (%eax),%al
  b2:	84 c0                	test   %al,%al
  b4:	75 e4                	jne    9a <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 06                	jmp    c6 <strcmp+0xb>
    p++, q++;
  c0:	ff 45 08             	incl   0x8(%ebp)
  c3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	8a 00                	mov    (%eax),%al
  cb:	84 c0                	test   %al,%al
  cd:	74 0e                	je     dd <strcmp+0x22>
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	8a 10                	mov    (%eax),%dl
  d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  d7:	8a 00                	mov    (%eax),%al
  d9:	38 c2                	cmp    %al,%dl
  db:	74 e3                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  dd:	8b 45 08             	mov    0x8(%ebp),%eax
  e0:	8a 00                	mov    (%eax),%al
  e2:	0f b6 d0             	movzbl %al,%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	8a 00                	mov    (%eax),%al
  ea:	0f b6 c0             	movzbl %al,%eax
  ed:	29 c2                	sub    %eax,%edx
  ef:	89 d0                	mov    %edx,%eax
}
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    

000000f3 <strlen>:

uint
strlen(char *s)
{
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 100:	eb 03                	jmp    105 <strlen+0x12>
 102:	ff 45 fc             	incl   -0x4(%ebp)
 105:	8b 55 fc             	mov    -0x4(%ebp),%edx
 108:	8b 45 08             	mov    0x8(%ebp),%eax
 10b:	01 d0                	add    %edx,%eax
 10d:	8a 00                	mov    (%eax),%al
 10f:	84 c0                	test   %al,%al
 111:	75 ef                	jne    102 <strlen+0xf>
    ;
  return n;
 113:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 116:	c9                   	leave  
 117:	c3                   	ret    

00000118 <memset>:

void*
memset(void *dst, int c, uint n)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 11e:	8b 45 10             	mov    0x10(%ebp),%eax
 121:	89 44 24 08          	mov    %eax,0x8(%esp)
 125:	8b 45 0c             	mov    0xc(%ebp),%eax
 128:	89 44 24 04          	mov    %eax,0x4(%esp)
 12c:	8b 45 08             	mov    0x8(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 31 ff ff ff       	call   68 <stosb>
  return dst;
 137:	8b 45 08             	mov    0x8(%ebp),%eax
}
 13a:	c9                   	leave  
 13b:	c3                   	ret    

0000013c <strchr>:

char*
strchr(const char *s, char c)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	83 ec 04             	sub    $0x4,%esp
 142:	8b 45 0c             	mov    0xc(%ebp),%eax
 145:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 148:	eb 12                	jmp    15c <strchr+0x20>
    if(*s == c)
 14a:	8b 45 08             	mov    0x8(%ebp),%eax
 14d:	8a 00                	mov    (%eax),%al
 14f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 152:	75 05                	jne    159 <strchr+0x1d>
      return (char*)s;
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	eb 11                	jmp    16a <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 159:	ff 45 08             	incl   0x8(%ebp)
 15c:	8b 45 08             	mov    0x8(%ebp),%eax
 15f:	8a 00                	mov    (%eax),%al
 161:	84 c0                	test   %al,%al
 163:	75 e5                	jne    14a <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 165:	b8 00 00 00 00       	mov    $0x0,%eax
}
 16a:	c9                   	leave  
 16b:	c3                   	ret    

0000016c <gets>:

char*
gets(char *buf, int max)
{
 16c:	55                   	push   %ebp
 16d:	89 e5                	mov    %esp,%ebp
 16f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 172:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 179:	eb 49                	jmp    1c4 <gets+0x58>
    cc = read(0, &c, 1);
 17b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 182:	00 
 183:	8d 45 ef             	lea    -0x11(%ebp),%eax
 186:	89 44 24 04          	mov    %eax,0x4(%esp)
 18a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 191:	e8 3e 01 00 00       	call   2d4 <read>
 196:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 199:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 19d:	7f 02                	jg     1a1 <gets+0x35>
      break;
 19f:	eb 2c                	jmp    1cd <gets+0x61>
    buf[i++] = c;
 1a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1a4:	8d 50 01             	lea    0x1(%eax),%edx
 1a7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1aa:	89 c2                	mov    %eax,%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	01 c2                	add    %eax,%edx
 1b1:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1b6:	8a 45 ef             	mov    -0x11(%ebp),%al
 1b9:	3c 0a                	cmp    $0xa,%al
 1bb:	74 10                	je     1cd <gets+0x61>
 1bd:	8a 45 ef             	mov    -0x11(%ebp),%al
 1c0:	3c 0d                	cmp    $0xd,%al
 1c2:	74 09                	je     1cd <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c7:	40                   	inc    %eax
 1c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1cb:	7c ae                	jl     17b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	01 d0                	add    %edx,%eax
 1d5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1db:	c9                   	leave  
 1dc:	c3                   	ret    

000001dd <stat>:

int
stat(char *n, struct stat *st)
{
 1dd:	55                   	push   %ebp
 1de:	89 e5                	mov    %esp,%ebp
 1e0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1ea:	00 
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	89 04 24             	mov    %eax,(%esp)
 1f1:	e8 06 01 00 00       	call   2fc <open>
 1f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1fd:	79 07                	jns    206 <stat+0x29>
    return -1;
 1ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 204:	eb 23                	jmp    229 <stat+0x4c>
  r = fstat(fd, st);
 206:	8b 45 0c             	mov    0xc(%ebp),%eax
 209:	89 44 24 04          	mov    %eax,0x4(%esp)
 20d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 210:	89 04 24             	mov    %eax,(%esp)
 213:	e8 fc 00 00 00       	call   314 <fstat>
 218:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 21b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 21e:	89 04 24             	mov    %eax,(%esp)
 221:	e8 be 00 00 00       	call   2e4 <close>
  return r;
 226:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 229:	c9                   	leave  
 22a:	c3                   	ret    

0000022b <atoi>:

int
atoi(const char *s)
{
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 231:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 238:	eb 24                	jmp    25e <atoi+0x33>
    n = n*10 + *s++ - '0';
 23a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23d:	89 d0                	mov    %edx,%eax
 23f:	c1 e0 02             	shl    $0x2,%eax
 242:	01 d0                	add    %edx,%eax
 244:	01 c0                	add    %eax,%eax
 246:	89 c1                	mov    %eax,%ecx
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	8d 50 01             	lea    0x1(%eax),%edx
 24e:	89 55 08             	mov    %edx,0x8(%ebp)
 251:	8a 00                	mov    (%eax),%al
 253:	0f be c0             	movsbl %al,%eax
 256:	01 c8                	add    %ecx,%eax
 258:	83 e8 30             	sub    $0x30,%eax
 25b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	8a 00                	mov    (%eax),%al
 263:	3c 2f                	cmp    $0x2f,%al
 265:	7e 09                	jle    270 <atoi+0x45>
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	8a 00                	mov    (%eax),%al
 26c:	3c 39                	cmp    $0x39,%al
 26e:	7e ca                	jle    23a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 270:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 273:	c9                   	leave  
 274:	c3                   	ret    

00000275 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 281:	8b 45 0c             	mov    0xc(%ebp),%eax
 284:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 287:	eb 16                	jmp    29f <memmove+0x2a>
    *dst++ = *src++;
 289:	8b 45 fc             	mov    -0x4(%ebp),%eax
 28c:	8d 50 01             	lea    0x1(%eax),%edx
 28f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 292:	8b 55 f8             	mov    -0x8(%ebp),%edx
 295:	8d 4a 01             	lea    0x1(%edx),%ecx
 298:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 29b:	8a 12                	mov    (%edx),%dl
 29d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 29f:	8b 45 10             	mov    0x10(%ebp),%eax
 2a2:	8d 50 ff             	lea    -0x1(%eax),%edx
 2a5:	89 55 10             	mov    %edx,0x10(%ebp)
 2a8:	85 c0                	test   %eax,%eax
 2aa:	7f dd                	jg     289 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2af:	c9                   	leave  
 2b0:	c3                   	ret    
 2b1:	90                   	nop
 2b2:	90                   	nop
 2b3:	90                   	nop

000002b4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b4:	b8 01 00 00 00       	mov    $0x1,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <exit>:
SYSCALL(exit)
 2bc:	b8 02 00 00 00       	mov    $0x2,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <wait>:
SYSCALL(wait)
 2c4:	b8 03 00 00 00       	mov    $0x3,%eax
 2c9:	cd 40                	int    $0x40
 2cb:	c3                   	ret    

000002cc <pipe>:
SYSCALL(pipe)
 2cc:	b8 04 00 00 00       	mov    $0x4,%eax
 2d1:	cd 40                	int    $0x40
 2d3:	c3                   	ret    

000002d4 <read>:
SYSCALL(read)
 2d4:	b8 05 00 00 00       	mov    $0x5,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <write>:
SYSCALL(write)
 2dc:	b8 10 00 00 00       	mov    $0x10,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <close>:
SYSCALL(close)
 2e4:	b8 15 00 00 00       	mov    $0x15,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <kill>:
SYSCALL(kill)
 2ec:	b8 06 00 00 00       	mov    $0x6,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <exec>:
SYSCALL(exec)
 2f4:	b8 07 00 00 00       	mov    $0x7,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <open>:
SYSCALL(open)
 2fc:	b8 0f 00 00 00       	mov    $0xf,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <mknod>:
SYSCALL(mknod)
 304:	b8 11 00 00 00       	mov    $0x11,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <unlink>:
SYSCALL(unlink)
 30c:	b8 12 00 00 00       	mov    $0x12,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <fstat>:
SYSCALL(fstat)
 314:	b8 08 00 00 00       	mov    $0x8,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <link>:
SYSCALL(link)
 31c:	b8 13 00 00 00       	mov    $0x13,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <mkdir>:
SYSCALL(mkdir)
 324:	b8 14 00 00 00       	mov    $0x14,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <chdir>:
SYSCALL(chdir)
 32c:	b8 09 00 00 00       	mov    $0x9,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <dup>:
SYSCALL(dup)
 334:	b8 0a 00 00 00       	mov    $0xa,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <getpid>:
SYSCALL(getpid)
 33c:	b8 0b 00 00 00       	mov    $0xb,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <sbrk>:
SYSCALL(sbrk)
 344:	b8 0c 00 00 00       	mov    $0xc,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <sleep>:
SYSCALL(sleep)
 34c:	b8 0d 00 00 00       	mov    $0xd,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <uptime>:
SYSCALL(uptime)
 354:	b8 0e 00 00 00       	mov    $0xe,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35c:	55                   	push   %ebp
 35d:	89 e5                	mov    %esp,%ebp
 35f:	83 ec 18             	sub    $0x18,%esp
 362:	8b 45 0c             	mov    0xc(%ebp),%eax
 365:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 368:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36f:	00 
 370:	8d 45 f4             	lea    -0xc(%ebp),%eax
 373:	89 44 24 04          	mov    %eax,0x4(%esp)
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 5a ff ff ff       	call   2dc <write>
}
 382:	c9                   	leave  
 383:	c3                   	ret    

00000384 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	56                   	push   %esi
 388:	53                   	push   %ebx
 389:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 38c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 393:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 397:	74 17                	je     3b0 <printint+0x2c>
 399:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 39d:	79 11                	jns    3b0 <printint+0x2c>
    neg = 1;
 39f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a9:	f7 d8                	neg    %eax
 3ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ae:	eb 06                	jmp    3b6 <printint+0x32>
  } else {
    x = xx;
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3bd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 3c0:	8d 41 01             	lea    0x1(%ecx),%eax
 3c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 3c6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 3c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3cc:	ba 00 00 00 00       	mov    $0x0,%edx
 3d1:	f7 f3                	div    %ebx
 3d3:	89 d0                	mov    %edx,%eax
 3d5:	8a 80 60 0a 00 00    	mov    0xa60(%eax),%al
 3db:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 3df:	8b 75 10             	mov    0x10(%ebp),%esi
 3e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3e5:	ba 00 00 00 00       	mov    $0x0,%edx
 3ea:	f7 f6                	div    %esi
 3ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3f3:	75 c8                	jne    3bd <printint+0x39>
  if(neg)
 3f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3f9:	74 10                	je     40b <printint+0x87>
    buf[i++] = '-';
 3fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3fe:	8d 50 01             	lea    0x1(%eax),%edx
 401:	89 55 f4             	mov    %edx,-0xc(%ebp)
 404:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 409:	eb 1e                	jmp    429 <printint+0xa5>
 40b:	eb 1c                	jmp    429 <printint+0xa5>
    putc(fd, buf[i]);
 40d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 410:	8b 45 f4             	mov    -0xc(%ebp),%eax
 413:	01 d0                	add    %edx,%eax
 415:	8a 00                	mov    (%eax),%al
 417:	0f be c0             	movsbl %al,%eax
 41a:	89 44 24 04          	mov    %eax,0x4(%esp)
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	89 04 24             	mov    %eax,(%esp)
 424:	e8 33 ff ff ff       	call   35c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 429:	ff 4d f4             	decl   -0xc(%ebp)
 42c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 430:	79 db                	jns    40d <printint+0x89>
    putc(fd, buf[i]);
}
 432:	83 c4 30             	add    $0x30,%esp
 435:	5b                   	pop    %ebx
 436:	5e                   	pop    %esi
 437:	5d                   	pop    %ebp
 438:	c3                   	ret    

00000439 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 439:	55                   	push   %ebp
 43a:	89 e5                	mov    %esp,%ebp
 43c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 43f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 446:	8d 45 0c             	lea    0xc(%ebp),%eax
 449:	83 c0 04             	add    $0x4,%eax
 44c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 44f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 456:	e9 77 01 00 00       	jmp    5d2 <printf+0x199>
    c = fmt[i] & 0xff;
 45b:	8b 55 0c             	mov    0xc(%ebp),%edx
 45e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 461:	01 d0                	add    %edx,%eax
 463:	8a 00                	mov    (%eax),%al
 465:	0f be c0             	movsbl %al,%eax
 468:	25 ff 00 00 00       	and    $0xff,%eax
 46d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 470:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 474:	75 2c                	jne    4a2 <printf+0x69>
      if(c == '%'){
 476:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 47a:	75 0c                	jne    488 <printf+0x4f>
        state = '%';
 47c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 483:	e9 47 01 00 00       	jmp    5cf <printf+0x196>
      } else {
        putc(fd, c);
 488:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 48b:	0f be c0             	movsbl %al,%eax
 48e:	89 44 24 04          	mov    %eax,0x4(%esp)
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	89 04 24             	mov    %eax,(%esp)
 498:	e8 bf fe ff ff       	call   35c <putc>
 49d:	e9 2d 01 00 00       	jmp    5cf <printf+0x196>
      }
    } else if(state == '%'){
 4a2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4a6:	0f 85 23 01 00 00    	jne    5cf <printf+0x196>
      if(c == 'd'){
 4ac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4b0:	75 2d                	jne    4df <printf+0xa6>
        printint(fd, *ap, 10, 1);
 4b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4b5:	8b 00                	mov    (%eax),%eax
 4b7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 4be:	00 
 4bf:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 4c6:	00 
 4c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	89 04 24             	mov    %eax,(%esp)
 4d1:	e8 ae fe ff ff       	call   384 <printint>
        ap++;
 4d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4da:	e9 e9 00 00 00       	jmp    5c8 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 4df:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4e3:	74 06                	je     4eb <printf+0xb2>
 4e5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4e9:	75 2d                	jne    518 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4ee:	8b 00                	mov    (%eax),%eax
 4f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4f7:	00 
 4f8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4ff:	00 
 500:	89 44 24 04          	mov    %eax,0x4(%esp)
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	89 04 24             	mov    %eax,(%esp)
 50a:	e8 75 fe ff ff       	call   384 <printint>
        ap++;
 50f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 513:	e9 b0 00 00 00       	jmp    5c8 <printf+0x18f>
      } else if(c == 's'){
 518:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 51c:	75 42                	jne    560 <printf+0x127>
        s = (char*)*ap;
 51e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 521:	8b 00                	mov    (%eax),%eax
 523:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 526:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 52a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52e:	75 09                	jne    539 <printf+0x100>
          s = "(null)";
 530:	c7 45 f4 13 08 00 00 	movl   $0x813,-0xc(%ebp)
        while(*s != 0){
 537:	eb 1c                	jmp    555 <printf+0x11c>
 539:	eb 1a                	jmp    555 <printf+0x11c>
          putc(fd, *s);
 53b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 53e:	8a 00                	mov    (%eax),%al
 540:	0f be c0             	movsbl %al,%eax
 543:	89 44 24 04          	mov    %eax,0x4(%esp)
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	89 04 24             	mov    %eax,(%esp)
 54d:	e8 0a fe ff ff       	call   35c <putc>
          s++;
 552:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 555:	8b 45 f4             	mov    -0xc(%ebp),%eax
 558:	8a 00                	mov    (%eax),%al
 55a:	84 c0                	test   %al,%al
 55c:	75 dd                	jne    53b <printf+0x102>
 55e:	eb 68                	jmp    5c8 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 560:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 564:	75 1d                	jne    583 <printf+0x14a>
        putc(fd, *ap);
 566:	8b 45 e8             	mov    -0x18(%ebp),%eax
 569:	8b 00                	mov    (%eax),%eax
 56b:	0f be c0             	movsbl %al,%eax
 56e:	89 44 24 04          	mov    %eax,0x4(%esp)
 572:	8b 45 08             	mov    0x8(%ebp),%eax
 575:	89 04 24             	mov    %eax,(%esp)
 578:	e8 df fd ff ff       	call   35c <putc>
        ap++;
 57d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 581:	eb 45                	jmp    5c8 <printf+0x18f>
      } else if(c == '%'){
 583:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 587:	75 17                	jne    5a0 <printf+0x167>
        putc(fd, c);
 589:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58c:	0f be c0             	movsbl %al,%eax
 58f:	89 44 24 04          	mov    %eax,0x4(%esp)
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	89 04 24             	mov    %eax,(%esp)
 599:	e8 be fd ff ff       	call   35c <putc>
 59e:	eb 28                	jmp    5c8 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5a0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 5a7:	00 
 5a8:	8b 45 08             	mov    0x8(%ebp),%eax
 5ab:	89 04 24             	mov    %eax,(%esp)
 5ae:	e8 a9 fd ff ff       	call   35c <putc>
        putc(fd, c);
 5b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5b6:	0f be c0             	movsbl %al,%eax
 5b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bd:	8b 45 08             	mov    0x8(%ebp),%eax
 5c0:	89 04 24             	mov    %eax,(%esp)
 5c3:	e8 94 fd ff ff       	call   35c <putc>
      }
      state = 0;
 5c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5cf:	ff 45 f0             	incl   -0x10(%ebp)
 5d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 5d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5d8:	01 d0                	add    %edx,%eax
 5da:	8a 00                	mov    (%eax),%al
 5dc:	84 c0                	test   %al,%al
 5de:	0f 85 77 fe ff ff    	jne    45b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5e4:	c9                   	leave  
 5e5:	c3                   	ret    
 5e6:	90                   	nop
 5e7:	90                   	nop

000005e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ee:	8b 45 08             	mov    0x8(%ebp),%eax
 5f1:	83 e8 08             	sub    $0x8,%eax
 5f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5f7:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 5fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5ff:	eb 24                	jmp    625 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 601:	8b 45 fc             	mov    -0x4(%ebp),%eax
 604:	8b 00                	mov    (%eax),%eax
 606:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 609:	77 12                	ja     61d <free+0x35>
 60b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 60e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 611:	77 24                	ja     637 <free+0x4f>
 613:	8b 45 fc             	mov    -0x4(%ebp),%eax
 616:	8b 00                	mov    (%eax),%eax
 618:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 61b:	77 1a                	ja     637 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 61d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 620:	8b 00                	mov    (%eax),%eax
 622:	89 45 fc             	mov    %eax,-0x4(%ebp)
 625:	8b 45 f8             	mov    -0x8(%ebp),%eax
 628:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 62b:	76 d4                	jbe    601 <free+0x19>
 62d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 630:	8b 00                	mov    (%eax),%eax
 632:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 635:	76 ca                	jbe    601 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	8b 40 04             	mov    0x4(%eax),%eax
 63d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 644:	8b 45 f8             	mov    -0x8(%ebp),%eax
 647:	01 c2                	add    %eax,%edx
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	8b 00                	mov    (%eax),%eax
 64e:	39 c2                	cmp    %eax,%edx
 650:	75 24                	jne    676 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 652:	8b 45 f8             	mov    -0x8(%ebp),%eax
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	8b 45 fc             	mov    -0x4(%ebp),%eax
 65b:	8b 00                	mov    (%eax),%eax
 65d:	8b 40 04             	mov    0x4(%eax),%eax
 660:	01 c2                	add    %eax,%edx
 662:	8b 45 f8             	mov    -0x8(%ebp),%eax
 665:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 668:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66b:	8b 00                	mov    (%eax),%eax
 66d:	8b 10                	mov    (%eax),%edx
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	89 10                	mov    %edx,(%eax)
 674:	eb 0a                	jmp    680 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 676:	8b 45 fc             	mov    -0x4(%ebp),%eax
 679:	8b 10                	mov    (%eax),%edx
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
 683:	8b 40 04             	mov    0x4(%eax),%eax
 686:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 68d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 690:	01 d0                	add    %edx,%eax
 692:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 695:	75 20                	jne    6b7 <free+0xcf>
    p->s.size += bp->s.size;
 697:	8b 45 fc             	mov    -0x4(%ebp),%eax
 69a:	8b 50 04             	mov    0x4(%eax),%edx
 69d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a0:	8b 40 04             	mov    0x4(%eax),%eax
 6a3:	01 c2                	add    %eax,%edx
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b3:	89 10                	mov    %edx,(%eax)
 6b5:	eb 08                	jmp    6bf <free+0xd7>
  } else
    p->s.ptr = bp;
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6bd:	89 10                	mov    %edx,(%eax)
  freep = p;
 6bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c2:	a3 7c 0a 00 00       	mov    %eax,0xa7c
}
 6c7:	c9                   	leave  
 6c8:	c3                   	ret    

000006c9 <morecore>:

static Header*
morecore(uint nu)
{
 6c9:	55                   	push   %ebp
 6ca:	89 e5                	mov    %esp,%ebp
 6cc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6cf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6d6:	77 07                	ja     6df <morecore+0x16>
    nu = 4096;
 6d8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	c1 e0 03             	shl    $0x3,%eax
 6e5:	89 04 24             	mov    %eax,(%esp)
 6e8:	e8 57 fc ff ff       	call   344 <sbrk>
 6ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6f4:	75 07                	jne    6fd <morecore+0x34>
    return 0;
 6f6:	b8 00 00 00 00       	mov    $0x0,%eax
 6fb:	eb 22                	jmp    71f <morecore+0x56>
  hp = (Header*)p;
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 703:	8b 45 f0             	mov    -0x10(%ebp),%eax
 706:	8b 55 08             	mov    0x8(%ebp),%edx
 709:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 70c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 70f:	83 c0 08             	add    $0x8,%eax
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 ce fe ff ff       	call   5e8 <free>
  return freep;
 71a:	a1 7c 0a 00 00       	mov    0xa7c,%eax
}
 71f:	c9                   	leave  
 720:	c3                   	ret    

00000721 <malloc>:

void*
malloc(uint nbytes)
{
 721:	55                   	push   %ebp
 722:	89 e5                	mov    %esp,%ebp
 724:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 727:	8b 45 08             	mov    0x8(%ebp),%eax
 72a:	83 c0 07             	add    $0x7,%eax
 72d:	c1 e8 03             	shr    $0x3,%eax
 730:	40                   	inc    %eax
 731:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 734:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 739:	89 45 f0             	mov    %eax,-0x10(%ebp)
 73c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 740:	75 23                	jne    765 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 742:	c7 45 f0 74 0a 00 00 	movl   $0xa74,-0x10(%ebp)
 749:	8b 45 f0             	mov    -0x10(%ebp),%eax
 74c:	a3 7c 0a 00 00       	mov    %eax,0xa7c
 751:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 756:	a3 74 0a 00 00       	mov    %eax,0xa74
    base.s.size = 0;
 75b:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 762:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 765:	8b 45 f0             	mov    -0x10(%ebp),%eax
 768:	8b 00                	mov    (%eax),%eax
 76a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	8b 40 04             	mov    0x4(%eax),%eax
 773:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 776:	72 4d                	jb     7c5 <malloc+0xa4>
      if(p->s.size == nunits)
 778:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 781:	75 0c                	jne    78f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 783:	8b 45 f4             	mov    -0xc(%ebp),%eax
 786:	8b 10                	mov    (%eax),%edx
 788:	8b 45 f0             	mov    -0x10(%ebp),%eax
 78b:	89 10                	mov    %edx,(%eax)
 78d:	eb 26                	jmp    7b5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	2b 45 ec             	sub    -0x14(%ebp),%eax
 798:	89 c2                	mov    %eax,%edx
 79a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	c1 e0 03             	shl    $0x3,%eax
 7a9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7b2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	a3 7c 0a 00 00       	mov    %eax,0xa7c
      return (void*)(p + 1);
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	83 c0 08             	add    $0x8,%eax
 7c3:	eb 38                	jmp    7fd <malloc+0xdc>
    }
    if(p == freep)
 7c5:	a1 7c 0a 00 00       	mov    0xa7c,%eax
 7ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7cd:	75 1b                	jne    7ea <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 7cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7d2:	89 04 24             	mov    %eax,(%esp)
 7d5:	e8 ef fe ff ff       	call   6c9 <morecore>
 7da:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e1:	75 07                	jne    7ea <malloc+0xc9>
        return 0;
 7e3:	b8 00 00 00 00       	mov    $0x0,%eax
 7e8:	eb 13                	jmp    7fd <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7f8:	e9 70 ff ff ff       	jmp    76d <malloc+0x4c>
}
 7fd:	c9                   	leave  
 7fe:	c3                   	ret    
