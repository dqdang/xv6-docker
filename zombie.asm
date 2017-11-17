
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 62 02 00 00       	call   270 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 ea 02 00 00       	call   308 <sleep>
  exit();
  1e:	e8 55 02 00 00       	call   278 <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	90                   	nop
  56:	8b 45 08             	mov    0x8(%ebp),%eax
  59:	8d 50 01             	lea    0x1(%eax),%edx
  5c:	89 55 08             	mov    %edx,0x8(%ebp)
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  62:	8d 4a 01             	lea    0x1(%edx),%ecx
  65:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  68:	8a 12                	mov    (%edx),%dl
  6a:	88 10                	mov    %dl,(%eax)
  6c:	8a 00                	mov    (%eax),%al
  6e:	84 c0                	test   %al,%al
  70:	75 e4                	jne    56 <strcpy+0xd>
    ;
  return os;
  72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  75:	c9                   	leave  
  76:	c3                   	ret    

00000077 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7a:	eb 06                	jmp    82 <strcmp+0xb>
    p++, q++;
  7c:	ff 45 08             	incl   0x8(%ebp)
  7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  82:	8b 45 08             	mov    0x8(%ebp),%eax
  85:	8a 00                	mov    (%eax),%al
  87:	84 c0                	test   %al,%al
  89:	74 0e                	je     99 <strcmp+0x22>
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	8a 10                	mov    (%eax),%dl
  90:	8b 45 0c             	mov    0xc(%ebp),%eax
  93:	8a 00                	mov    (%eax),%al
  95:	38 c2                	cmp    %al,%dl
  97:	74 e3                	je     7c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	8a 00                	mov    (%eax),%al
  9e:	0f b6 d0             	movzbl %al,%edx
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	8a 00                	mov    (%eax),%al
  a6:	0f b6 c0             	movzbl %al,%eax
  a9:	29 c2                	sub    %eax,%edx
  ab:	89 d0                	mov    %edx,%eax
}
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <strlen>:

uint
strlen(char *s)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  bc:	eb 03                	jmp    c1 <strlen+0x12>
  be:	ff 45 fc             	incl   -0x4(%ebp)
  c1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8a 00                	mov    (%eax),%al
  cb:	84 c0                	test   %al,%al
  cd:	75 ef                	jne    be <strlen+0xf>
    ;
  return n;
  cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d2:	c9                   	leave  
  d3:	c3                   	ret    

000000d4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  da:	8b 45 10             	mov    0x10(%ebp),%eax
  dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	89 04 24             	mov    %eax,(%esp)
  ee:	e8 31 ff ff ff       	call   24 <stosb>
  return dst;
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
  f6:	c9                   	leave  
  f7:	c3                   	ret    

000000f8 <strchr>:

char*
strchr(const char *s, char c)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	83 ec 04             	sub    $0x4,%esp
  fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 101:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 104:	eb 12                	jmp    118 <strchr+0x20>
    if(*s == c)
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	8a 00                	mov    (%eax),%al
 10b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 10e:	75 05                	jne    115 <strchr+0x1d>
      return (char*)s;
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	eb 11                	jmp    126 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 115:	ff 45 08             	incl   0x8(%ebp)
 118:	8b 45 08             	mov    0x8(%ebp),%eax
 11b:	8a 00                	mov    (%eax),%al
 11d:	84 c0                	test   %al,%al
 11f:	75 e5                	jne    106 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 121:	b8 00 00 00 00       	mov    $0x0,%eax
}
 126:	c9                   	leave  
 127:	c3                   	ret    

00000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	55                   	push   %ebp
 129:	89 e5                	mov    %esp,%ebp
 12b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 12e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 135:	eb 49                	jmp    180 <gets+0x58>
    cc = read(0, &c, 1);
 137:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 13e:	00 
 13f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 142:	89 44 24 04          	mov    %eax,0x4(%esp)
 146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 14d:	e8 3e 01 00 00       	call   290 <read>
 152:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 155:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 159:	7f 02                	jg     15d <gets+0x35>
      break;
 15b:	eb 2c                	jmp    189 <gets+0x61>
    buf[i++] = c;
 15d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 160:	8d 50 01             	lea    0x1(%eax),%edx
 163:	89 55 f4             	mov    %edx,-0xc(%ebp)
 166:	89 c2                	mov    %eax,%edx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	01 c2                	add    %eax,%edx
 16d:	8a 45 ef             	mov    -0x11(%ebp),%al
 170:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 172:	8a 45 ef             	mov    -0x11(%ebp),%al
 175:	3c 0a                	cmp    $0xa,%al
 177:	74 10                	je     189 <gets+0x61>
 179:	8a 45 ef             	mov    -0x11(%ebp),%al
 17c:	3c 0d                	cmp    $0xd,%al
 17e:	74 09                	je     189 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 180:	8b 45 f4             	mov    -0xc(%ebp),%eax
 183:	40                   	inc    %eax
 184:	3b 45 0c             	cmp    0xc(%ebp),%eax
 187:	7c ae                	jl     137 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 189:	8b 55 f4             	mov    -0xc(%ebp),%edx
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	01 d0                	add    %edx,%eax
 191:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 194:	8b 45 08             	mov    0x8(%ebp),%eax
}
 197:	c9                   	leave  
 198:	c3                   	ret    

00000199 <stat>:

int
stat(char *n, struct stat *st)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 19f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a6:	00 
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	89 04 24             	mov    %eax,(%esp)
 1ad:	e8 06 01 00 00       	call   2b8 <open>
 1b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1b9:	79 07                	jns    1c2 <stat+0x29>
    return -1;
 1bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1c0:	eb 23                	jmp    1e5 <stat+0x4c>
  r = fstat(fd, st);
 1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1cc:	89 04 24             	mov    %eax,(%esp)
 1cf:	e8 fc 00 00 00       	call   2d0 <fstat>
 1d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1da:	89 04 24             	mov    %eax,(%esp)
 1dd:	e8 be 00 00 00       	call   2a0 <close>
  return r;
 1e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1e5:	c9                   	leave  
 1e6:	c3                   	ret    

000001e7 <atoi>:

int
atoi(const char *s)
{
 1e7:	55                   	push   %ebp
 1e8:	89 e5                	mov    %esp,%ebp
 1ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 1f4:	eb 24                	jmp    21a <atoi+0x33>
    n = n*10 + *s++ - '0';
 1f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f9:	89 d0                	mov    %edx,%eax
 1fb:	c1 e0 02             	shl    $0x2,%eax
 1fe:	01 d0                	add    %edx,%eax
 200:	01 c0                	add    %eax,%eax
 202:	89 c1                	mov    %eax,%ecx
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	8d 50 01             	lea    0x1(%eax),%edx
 20a:	89 55 08             	mov    %edx,0x8(%ebp)
 20d:	8a 00                	mov    (%eax),%al
 20f:	0f be c0             	movsbl %al,%eax
 212:	01 c8                	add    %ecx,%eax
 214:	83 e8 30             	sub    $0x30,%eax
 217:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	8a 00                	mov    (%eax),%al
 21f:	3c 2f                	cmp    $0x2f,%al
 221:	7e 09                	jle    22c <atoi+0x45>
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8a 00                	mov    (%eax),%al
 228:	3c 39                	cmp    $0x39,%al
 22a:	7e ca                	jle    1f6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 22c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22f:	c9                   	leave  
 230:	c3                   	ret    

00000231 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 231:	55                   	push   %ebp
 232:	89 e5                	mov    %esp,%ebp
 234:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 243:	eb 16                	jmp    25b <memmove+0x2a>
    *dst++ = *src++;
 245:	8b 45 fc             	mov    -0x4(%ebp),%eax
 248:	8d 50 01             	lea    0x1(%eax),%edx
 24b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 24e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 251:	8d 4a 01             	lea    0x1(%edx),%ecx
 254:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 257:	8a 12                	mov    (%edx),%dl
 259:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 25b:	8b 45 10             	mov    0x10(%ebp),%eax
 25e:	8d 50 ff             	lea    -0x1(%eax),%edx
 261:	89 55 10             	mov    %edx,0x10(%ebp)
 264:	85 c0                	test   %eax,%eax
 266:	7f dd                	jg     245 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 268:	8b 45 08             	mov    0x8(%ebp),%eax
}
 26b:	c9                   	leave  
 26c:	c3                   	ret    
 26d:	90                   	nop
 26e:	90                   	nop
 26f:	90                   	nop

00000270 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 270:	b8 01 00 00 00       	mov    $0x1,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <exit>:
SYSCALL(exit)
 278:	b8 02 00 00 00       	mov    $0x2,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <wait>:
SYSCALL(wait)
 280:	b8 03 00 00 00       	mov    $0x3,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <pipe>:
SYSCALL(pipe)
 288:	b8 04 00 00 00       	mov    $0x4,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <read>:
SYSCALL(read)
 290:	b8 05 00 00 00       	mov    $0x5,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <write>:
SYSCALL(write)
 298:	b8 10 00 00 00       	mov    $0x10,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <close>:
SYSCALL(close)
 2a0:	b8 15 00 00 00       	mov    $0x15,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <kill>:
SYSCALL(kill)
 2a8:	b8 06 00 00 00       	mov    $0x6,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <exec>:
SYSCALL(exec)
 2b0:	b8 07 00 00 00       	mov    $0x7,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <open>:
SYSCALL(open)
 2b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <mknod>:
SYSCALL(mknod)
 2c0:	b8 11 00 00 00       	mov    $0x11,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <unlink>:
SYSCALL(unlink)
 2c8:	b8 12 00 00 00       	mov    $0x12,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <fstat>:
SYSCALL(fstat)
 2d0:	b8 08 00 00 00       	mov    $0x8,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <link>:
SYSCALL(link)
 2d8:	b8 13 00 00 00       	mov    $0x13,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <mkdir>:
SYSCALL(mkdir)
 2e0:	b8 14 00 00 00       	mov    $0x14,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <chdir>:
SYSCALL(chdir)
 2e8:	b8 09 00 00 00       	mov    $0x9,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <dup>:
SYSCALL(dup)
 2f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <getpid>:
SYSCALL(getpid)
 2f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <sbrk>:
SYSCALL(sbrk)
 300:	b8 0c 00 00 00       	mov    $0xc,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <sleep>:
SYSCALL(sleep)
 308:	b8 0d 00 00 00       	mov    $0xd,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <uptime>:
SYSCALL(uptime)
 310:	b8 0e 00 00 00       	mov    $0xe,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 318:	55                   	push   %ebp
 319:	89 e5                	mov    %esp,%ebp
 31b:	83 ec 18             	sub    $0x18,%esp
 31e:	8b 45 0c             	mov    0xc(%ebp),%eax
 321:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 324:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 32b:	00 
 32c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 32f:	89 44 24 04          	mov    %eax,0x4(%esp)
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	89 04 24             	mov    %eax,(%esp)
 339:	e8 5a ff ff ff       	call   298 <write>
}
 33e:	c9                   	leave  
 33f:	c3                   	ret    

00000340 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
 345:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 348:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 34f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 353:	74 17                	je     36c <printint+0x2c>
 355:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 359:	79 11                	jns    36c <printint+0x2c>
    neg = 1;
 35b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 362:	8b 45 0c             	mov    0xc(%ebp),%eax
 365:	f7 d8                	neg    %eax
 367:	89 45 ec             	mov    %eax,-0x14(%ebp)
 36a:	eb 06                	jmp    372 <printint+0x32>
  } else {
    x = xx;
 36c:	8b 45 0c             	mov    0xc(%ebp),%eax
 36f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 372:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 379:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 37c:	8d 41 01             	lea    0x1(%ecx),%eax
 37f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 382:	8b 5d 10             	mov    0x10(%ebp),%ebx
 385:	8b 45 ec             	mov    -0x14(%ebp),%eax
 388:	ba 00 00 00 00       	mov    $0x0,%edx
 38d:	f7 f3                	div    %ebx
 38f:	89 d0                	mov    %edx,%eax
 391:	8a 80 08 0a 00 00    	mov    0xa08(%eax),%al
 397:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 39b:	8b 75 10             	mov    0x10(%ebp),%esi
 39e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3a1:	ba 00 00 00 00       	mov    $0x0,%edx
 3a6:	f7 f6                	div    %esi
 3a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 3af:	75 c8                	jne    379 <printint+0x39>
  if(neg)
 3b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 3b5:	74 10                	je     3c7 <printint+0x87>
    buf[i++] = '-';
 3b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3ba:	8d 50 01             	lea    0x1(%eax),%edx
 3bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 3c5:	eb 1e                	jmp    3e5 <printint+0xa5>
 3c7:	eb 1c                	jmp    3e5 <printint+0xa5>
    putc(fd, buf[i]);
 3c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 3cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3cf:	01 d0                	add    %edx,%eax
 3d1:	8a 00                	mov    (%eax),%al
 3d3:	0f be c0             	movsbl %al,%eax
 3d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 3da:	8b 45 08             	mov    0x8(%ebp),%eax
 3dd:	89 04 24             	mov    %eax,(%esp)
 3e0:	e8 33 ff ff ff       	call   318 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 3e5:	ff 4d f4             	decl   -0xc(%ebp)
 3e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3ec:	79 db                	jns    3c9 <printint+0x89>
    putc(fd, buf[i]);
}
 3ee:	83 c4 30             	add    $0x30,%esp
 3f1:	5b                   	pop    %ebx
 3f2:	5e                   	pop    %esi
 3f3:	5d                   	pop    %ebp
 3f4:	c3                   	ret    

000003f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 402:	8d 45 0c             	lea    0xc(%ebp),%eax
 405:	83 c0 04             	add    $0x4,%eax
 408:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 40b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 412:	e9 77 01 00 00       	jmp    58e <printf+0x199>
    c = fmt[i] & 0xff;
 417:	8b 55 0c             	mov    0xc(%ebp),%edx
 41a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 41d:	01 d0                	add    %edx,%eax
 41f:	8a 00                	mov    (%eax),%al
 421:	0f be c0             	movsbl %al,%eax
 424:	25 ff 00 00 00       	and    $0xff,%eax
 429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 42c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 430:	75 2c                	jne    45e <printf+0x69>
      if(c == '%'){
 432:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 436:	75 0c                	jne    444 <printf+0x4f>
        state = '%';
 438:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 43f:	e9 47 01 00 00       	jmp    58b <printf+0x196>
      } else {
        putc(fd, c);
 444:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 447:	0f be c0             	movsbl %al,%eax
 44a:	89 44 24 04          	mov    %eax,0x4(%esp)
 44e:	8b 45 08             	mov    0x8(%ebp),%eax
 451:	89 04 24             	mov    %eax,(%esp)
 454:	e8 bf fe ff ff       	call   318 <putc>
 459:	e9 2d 01 00 00       	jmp    58b <printf+0x196>
      }
    } else if(state == '%'){
 45e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 462:	0f 85 23 01 00 00    	jne    58b <printf+0x196>
      if(c == 'd'){
 468:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 46c:	75 2d                	jne    49b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 46e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 471:	8b 00                	mov    (%eax),%eax
 473:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 47a:	00 
 47b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 482:	00 
 483:	89 44 24 04          	mov    %eax,0x4(%esp)
 487:	8b 45 08             	mov    0x8(%ebp),%eax
 48a:	89 04 24             	mov    %eax,(%esp)
 48d:	e8 ae fe ff ff       	call   340 <printint>
        ap++;
 492:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 496:	e9 e9 00 00 00       	jmp    584 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 49b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 49f:	74 06                	je     4a7 <printf+0xb2>
 4a1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 4a5:	75 2d                	jne    4d4 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 4a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4aa:	8b 00                	mov    (%eax),%eax
 4ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 4b3:	00 
 4b4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 4bb:	00 
 4bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	89 04 24             	mov    %eax,(%esp)
 4c6:	e8 75 fe ff ff       	call   340 <printint>
        ap++;
 4cb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4cf:	e9 b0 00 00 00       	jmp    584 <printf+0x18f>
      } else if(c == 's'){
 4d4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 4d8:	75 42                	jne    51c <printf+0x127>
        s = (char*)*ap;
 4da:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4dd:	8b 00                	mov    (%eax),%eax
 4df:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 4e2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 4e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4ea:	75 09                	jne    4f5 <printf+0x100>
          s = "(null)";
 4ec:	c7 45 f4 bb 07 00 00 	movl   $0x7bb,-0xc(%ebp)
        while(*s != 0){
 4f3:	eb 1c                	jmp    511 <printf+0x11c>
 4f5:	eb 1a                	jmp    511 <printf+0x11c>
          putc(fd, *s);
 4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fa:	8a 00                	mov    (%eax),%al
 4fc:	0f be c0             	movsbl %al,%eax
 4ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	89 04 24             	mov    %eax,(%esp)
 509:	e8 0a fe ff ff       	call   318 <putc>
          s++;
 50e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 511:	8b 45 f4             	mov    -0xc(%ebp),%eax
 514:	8a 00                	mov    (%eax),%al
 516:	84 c0                	test   %al,%al
 518:	75 dd                	jne    4f7 <printf+0x102>
 51a:	eb 68                	jmp    584 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 51c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 520:	75 1d                	jne    53f <printf+0x14a>
        putc(fd, *ap);
 522:	8b 45 e8             	mov    -0x18(%ebp),%eax
 525:	8b 00                	mov    (%eax),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	89 44 24 04          	mov    %eax,0x4(%esp)
 52e:	8b 45 08             	mov    0x8(%ebp),%eax
 531:	89 04 24             	mov    %eax,(%esp)
 534:	e8 df fd ff ff       	call   318 <putc>
        ap++;
 539:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 53d:	eb 45                	jmp    584 <printf+0x18f>
      } else if(c == '%'){
 53f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 543:	75 17                	jne    55c <printf+0x167>
        putc(fd, c);
 545:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	89 44 24 04          	mov    %eax,0x4(%esp)
 54f:	8b 45 08             	mov    0x8(%ebp),%eax
 552:	89 04 24             	mov    %eax,(%esp)
 555:	e8 be fd ff ff       	call   318 <putc>
 55a:	eb 28                	jmp    584 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 55c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 563:	00 
 564:	8b 45 08             	mov    0x8(%ebp),%eax
 567:	89 04 24             	mov    %eax,(%esp)
 56a:	e8 a9 fd ff ff       	call   318 <putc>
        putc(fd, c);
 56f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 572:	0f be c0             	movsbl %al,%eax
 575:	89 44 24 04          	mov    %eax,0x4(%esp)
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	89 04 24             	mov    %eax,(%esp)
 57f:	e8 94 fd ff ff       	call   318 <putc>
      }
      state = 0;
 584:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 58b:	ff 45 f0             	incl   -0x10(%ebp)
 58e:	8b 55 0c             	mov    0xc(%ebp),%edx
 591:	8b 45 f0             	mov    -0x10(%ebp),%eax
 594:	01 d0                	add    %edx,%eax
 596:	8a 00                	mov    (%eax),%al
 598:	84 c0                	test   %al,%al
 59a:	0f 85 77 fe ff ff    	jne    417 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5a0:	c9                   	leave  
 5a1:	c3                   	ret    
 5a2:	90                   	nop
 5a3:	90                   	nop

000005a4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5aa:	8b 45 08             	mov    0x8(%ebp),%eax
 5ad:	83 e8 08             	sub    $0x8,%eax
 5b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b3:	a1 24 0a 00 00       	mov    0xa24,%eax
 5b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5bb:	eb 24                	jmp    5e1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5c0:	8b 00                	mov    (%eax),%eax
 5c2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5c5:	77 12                	ja     5d9 <free+0x35>
 5c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5ca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5cd:	77 24                	ja     5f3 <free+0x4f>
 5cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d2:	8b 00                	mov    (%eax),%eax
 5d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5d7:	77 1a                	ja     5f3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5dc:	8b 00                	mov    (%eax),%eax
 5de:	89 45 fc             	mov    %eax,-0x4(%ebp)
 5e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 5e7:	76 d4                	jbe    5bd <free+0x19>
 5e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ec:	8b 00                	mov    (%eax),%eax
 5ee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 5f1:	76 ca                	jbe    5bd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 5f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5f6:	8b 40 04             	mov    0x4(%eax),%eax
 5f9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 600:	8b 45 f8             	mov    -0x8(%ebp),%eax
 603:	01 c2                	add    %eax,%edx
 605:	8b 45 fc             	mov    -0x4(%ebp),%eax
 608:	8b 00                	mov    (%eax),%eax
 60a:	39 c2                	cmp    %eax,%edx
 60c:	75 24                	jne    632 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 60e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 611:	8b 50 04             	mov    0x4(%eax),%edx
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
 617:	8b 00                	mov    (%eax),%eax
 619:	8b 40 04             	mov    0x4(%eax),%eax
 61c:	01 c2                	add    %eax,%edx
 61e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 621:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 624:	8b 45 fc             	mov    -0x4(%ebp),%eax
 627:	8b 00                	mov    (%eax),%eax
 629:	8b 10                	mov    (%eax),%edx
 62b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 62e:	89 10                	mov    %edx,(%eax)
 630:	eb 0a                	jmp    63c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 632:	8b 45 fc             	mov    -0x4(%ebp),%eax
 635:	8b 10                	mov    (%eax),%edx
 637:	8b 45 f8             	mov    -0x8(%ebp),%eax
 63a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 63c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 63f:	8b 40 04             	mov    0x4(%eax),%eax
 642:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 649:	8b 45 fc             	mov    -0x4(%ebp),%eax
 64c:	01 d0                	add    %edx,%eax
 64e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 651:	75 20                	jne    673 <free+0xcf>
    p->s.size += bp->s.size;
 653:	8b 45 fc             	mov    -0x4(%ebp),%eax
 656:	8b 50 04             	mov    0x4(%eax),%edx
 659:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65c:	8b 40 04             	mov    0x4(%eax),%eax
 65f:	01 c2                	add    %eax,%edx
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 667:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66a:	8b 10                	mov    (%eax),%edx
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	89 10                	mov    %edx,(%eax)
 671:	eb 08                	jmp    67b <free+0xd7>
  } else
    p->s.ptr = bp;
 673:	8b 45 fc             	mov    -0x4(%ebp),%eax
 676:	8b 55 f8             	mov    -0x8(%ebp),%edx
 679:	89 10                	mov    %edx,(%eax)
  freep = p;
 67b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67e:	a3 24 0a 00 00       	mov    %eax,0xa24
}
 683:	c9                   	leave  
 684:	c3                   	ret    

00000685 <morecore>:

static Header*
morecore(uint nu)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
 688:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 68b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 692:	77 07                	ja     69b <morecore+0x16>
    nu = 4096;
 694:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 69b:	8b 45 08             	mov    0x8(%ebp),%eax
 69e:	c1 e0 03             	shl    $0x3,%eax
 6a1:	89 04 24             	mov    %eax,(%esp)
 6a4:	e8 57 fc ff ff       	call   300 <sbrk>
 6a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6ac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 6b0:	75 07                	jne    6b9 <morecore+0x34>
    return 0;
 6b2:	b8 00 00 00 00       	mov    $0x0,%eax
 6b7:	eb 22                	jmp    6db <morecore+0x56>
  hp = (Header*)p;
 6b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 6bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6c2:	8b 55 08             	mov    0x8(%ebp),%edx
 6c5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 6c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6cb:	83 c0 08             	add    $0x8,%eax
 6ce:	89 04 24             	mov    %eax,(%esp)
 6d1:	e8 ce fe ff ff       	call   5a4 <free>
  return freep;
 6d6:	a1 24 0a 00 00       	mov    0xa24,%eax
}
 6db:	c9                   	leave  
 6dc:	c3                   	ret    

000006dd <malloc>:

void*
malloc(uint nbytes)
{
 6dd:	55                   	push   %ebp
 6de:	89 e5                	mov    %esp,%ebp
 6e0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	83 c0 07             	add    $0x7,%eax
 6e9:	c1 e8 03             	shr    $0x3,%eax
 6ec:	40                   	inc    %eax
 6ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 6f0:	a1 24 0a 00 00       	mov    0xa24,%eax
 6f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 6f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fc:	75 23                	jne    721 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 6fe:	c7 45 f0 1c 0a 00 00 	movl   $0xa1c,-0x10(%ebp)
 705:	8b 45 f0             	mov    -0x10(%ebp),%eax
 708:	a3 24 0a 00 00       	mov    %eax,0xa24
 70d:	a1 24 0a 00 00       	mov    0xa24,%eax
 712:	a3 1c 0a 00 00       	mov    %eax,0xa1c
    base.s.size = 0;
 717:	c7 05 20 0a 00 00 00 	movl   $0x0,0xa20
 71e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 721:	8b 45 f0             	mov    -0x10(%ebp),%eax
 724:	8b 00                	mov    (%eax),%eax
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 729:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72c:	8b 40 04             	mov    0x4(%eax),%eax
 72f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 732:	72 4d                	jb     781 <malloc+0xa4>
      if(p->s.size == nunits)
 734:	8b 45 f4             	mov    -0xc(%ebp),%eax
 737:	8b 40 04             	mov    0x4(%eax),%eax
 73a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 73d:	75 0c                	jne    74b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 73f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 742:	8b 10                	mov    (%eax),%edx
 744:	8b 45 f0             	mov    -0x10(%ebp),%eax
 747:	89 10                	mov    %edx,(%eax)
 749:	eb 26                	jmp    771 <malloc+0x94>
      else {
        p->s.size -= nunits;
 74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74e:	8b 40 04             	mov    0x4(%eax),%eax
 751:	2b 45 ec             	sub    -0x14(%ebp),%eax
 754:	89 c2                	mov    %eax,%edx
 756:	8b 45 f4             	mov    -0xc(%ebp),%eax
 759:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	8b 40 04             	mov    0x4(%eax),%eax
 762:	c1 e0 03             	shl    $0x3,%eax
 765:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 76e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 771:	8b 45 f0             	mov    -0x10(%ebp),%eax
 774:	a3 24 0a 00 00       	mov    %eax,0xa24
      return (void*)(p + 1);
 779:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77c:	83 c0 08             	add    $0x8,%eax
 77f:	eb 38                	jmp    7b9 <malloc+0xdc>
    }
    if(p == freep)
 781:	a1 24 0a 00 00       	mov    0xa24,%eax
 786:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 789:	75 1b                	jne    7a6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 78b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 78e:	89 04 24             	mov    %eax,(%esp)
 791:	e8 ef fe ff ff       	call   685 <morecore>
 796:	89 45 f4             	mov    %eax,-0xc(%ebp)
 799:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 79d:	75 07                	jne    7a6 <malloc+0xc9>
        return 0;
 79f:	b8 00 00 00 00       	mov    $0x0,%eax
 7a4:	eb 13                	jmp    7b9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7af:	8b 00                	mov    (%eax),%eax
 7b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 7b4:	e9 70 ff ff ff       	jmp    729 <malloc+0x4c>
}
 7b9:	c9                   	leave  
 7ba:	c3                   	ret    
