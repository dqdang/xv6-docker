
_vctest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int fd, id;

  if (argc < 3) {
   9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(1, "usage: vctest <vc> <cmd> [<arg> ...]\n");
   f:	c7 44 24 04 04 0e 00 	movl   $0xe04,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 1a 0a 00 00       	call   a3d <printf>
    exit();
  23:	e8 98 08 00 00       	call   8c0 <exit>
  }

  fd = open(argv[1], O_RDWR);
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 04             	add    $0x4,%eax
  2e:	8b 00                	mov    (%eax),%eax
  30:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  37:	00 
  38:	89 04 24             	mov    %eax,(%esp)
  3b:	e8 c0 08 00 00       	call   900 <open>
  40:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  printf(1, "fd = %d\n", fd);
  44:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  48:	89 44 24 08          	mov    %eax,0x8(%esp)
  4c:	c7 44 24 04 2a 0e 00 	movl   $0xe2a,0x4(%esp)
  53:	00 
  54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5b:	e8 dd 09 00 00       	call   a3d <printf>

  /* fork a child and exec argv[1] */
  id = fork();
  60:	e8 53 08 00 00       	call   8b8 <fork>
  65:	89 44 24 18          	mov    %eax,0x18(%esp)

  if (id == 0){
  69:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  6e:	75 67                	jne    d7 <main+0xd7>
    close(0);
  70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  77:	e8 6c 08 00 00       	call   8e8 <close>
    close(1);
  7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  83:	e8 60 08 00 00       	call   8e8 <close>
    close(2);
  88:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8f:	e8 54 08 00 00       	call   8e8 <close>
    dup(fd);
  94:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  98:	89 04 24             	mov    %eax,(%esp)
  9b:	e8 98 08 00 00       	call   938 <dup>
    dup(fd);
  a0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  a4:	89 04 24             	mov    %eax,(%esp)
  a7:	e8 8c 08 00 00       	call   938 <dup>
    dup(fd);
  ac:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b0:	89 04 24             	mov    %eax,(%esp)
  b3:	e8 80 08 00 00       	call   938 <dup>
    exec(argv[2], &argv[2]);
  b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  bb:	8d 50 08             	lea    0x8(%eax),%edx
  be:	8b 45 0c             	mov    0xc(%ebp),%eax
  c1:	83 c0 08             	add    $0x8,%eax
  c4:	8b 00                	mov    (%eax),%eax
  c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  ca:	89 04 24             	mov    %eax,(%esp)
  cd:	e8 26 08 00 00       	call   8f8 <exec>
    exit();
  d2:	e8 e9 07 00 00       	call   8c0 <exit>
  }

  printf(1, "%s started on vc0\n", argv[1]);
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	83 c0 04             	add    $0x4,%eax
  dd:	8b 00                	mov    (%eax),%eax
  df:	89 44 24 08          	mov    %eax,0x8(%esp)
  e3:	c7 44 24 04 33 0e 00 	movl   $0xe33,0x4(%esp)
  ea:	00 
  eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f2:	e8 46 09 00 00       	call   a3d <printf>

  exit();
  f7:	e8 c4 07 00 00       	call   8c0 <exit>

000000fc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
 100:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 101:	8b 4d 08             	mov    0x8(%ebp),%ecx
 104:	8b 55 10             	mov    0x10(%ebp),%edx
 107:	8b 45 0c             	mov    0xc(%ebp),%eax
 10a:	89 cb                	mov    %ecx,%ebx
 10c:	89 df                	mov    %ebx,%edi
 10e:	89 d1                	mov    %edx,%ecx
 110:	fc                   	cld    
 111:	f3 aa                	rep stos %al,%es:(%edi)
 113:	89 ca                	mov    %ecx,%edx
 115:	89 fb                	mov    %edi,%ebx
 117:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 11d:	5b                   	pop    %ebx
 11e:	5f                   	pop    %edi
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    

00000121 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 12d:	90                   	nop
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	8d 50 01             	lea    0x1(%eax),%edx
 134:	89 55 08             	mov    %edx,0x8(%ebp)
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
 13a:	8d 4a 01             	lea    0x1(%edx),%ecx
 13d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 140:	8a 12                	mov    (%edx),%dl
 142:	88 10                	mov    %dl,(%eax)
 144:	8a 00                	mov    (%eax),%al
 146:	84 c0                	test   %al,%al
 148:	75 e4                	jne    12e <strcpy+0xd>
    ;
  return os;
 14a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
 152:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
 155:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 15c:	00 
 15d:	8b 45 08             	mov    0x8(%ebp),%eax
 160:	89 04 24             	mov    %eax,(%esp)
 163:	e8 98 07 00 00       	call   900 <open>
 168:	89 45 f0             	mov    %eax,-0x10(%ebp)
 16b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 16f:	79 20                	jns    191 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	89 44 24 08          	mov    %eax,0x8(%esp)
 178:	c7 44 24 04 46 0e 00 	movl   $0xe46,0x4(%esp)
 17f:	00 
 180:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 187:	e8 b1 08 00 00       	call   a3d <printf>
        exit();
 18c:	e8 2f 07 00 00       	call   8c0 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 191:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 198:	00 
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	89 04 24             	mov    %eax,(%esp)
 19f:	e8 5c 07 00 00       	call   900 <open>
 1a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1a7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1ab:	79 20                	jns    1cd <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 1ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b4:	c7 44 24 04 61 0e 00 	movl   $0xe61,0x4(%esp)
 1bb:	00 
 1bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c3:	e8 75 08 00 00       	call   a3d <printf>
        exit();
 1c8:	e8 f3 06 00 00       	call   8c0 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 1cd:	eb 56                	jmp    225 <copy+0xd6>
        int max = used_disk+=count;
 1cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 1d2:	01 45 10             	add    %eax,0x10(%ebp)
 1d5:	8b 45 10             	mov    0x10(%ebp),%eax
 1d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 1db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1de:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e2:	c7 44 24 04 7d 0e 00 	movl   $0xe7d,0x4(%esp)
 1e9:	00 
 1ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1f1:	e8 47 08 00 00       	call   a3d <printf>
        if(max > max_disk){
 1f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1f9:	3b 45 14             	cmp    0x14(%ebp),%eax
 1fc:	7e 07                	jle    205 <copy+0xb6>
          return -1;
 1fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 203:	eb 5c                	jmp    261 <copy+0x112>
        }
        bytes = bytes + count;
 205:	8b 45 e8             	mov    -0x18(%ebp),%eax
 208:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 20b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 212:	00 
 213:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 216:	89 44 24 04          	mov    %eax,0x4(%esp)
 21a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 21d:	89 04 24             	mov    %eax,(%esp)
 220:	e8 bb 06 00 00       	call   8e0 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 225:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 22c:	00 
 22d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 230:	89 44 24 04          	mov    %eax,0x4(%esp)
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
 237:	89 04 24             	mov    %eax,(%esp)
 23a:	e8 99 06 00 00       	call   8d8 <read>
 23f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 242:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 246:	7f 87                	jg     1cf <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 248:	8b 45 f0             	mov    -0x10(%ebp),%eax
 24b:	89 04 24             	mov    %eax,(%esp)
 24e:	e8 95 06 00 00       	call   8e8 <close>
    close(fd2);
 253:	8b 45 ec             	mov    -0x14(%ebp),%eax
 256:	89 04 24             	mov    %eax,(%esp)
 259:	e8 8a 06 00 00       	call   8e8 <close>
    return(bytes);
 25e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 261:	c9                   	leave  
 262:	c3                   	ret    

00000263 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 263:	55                   	push   %ebp
 264:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 266:	eb 06                	jmp    26e <strcmp+0xb>
    p++, q++;
 268:	ff 45 08             	incl   0x8(%ebp)
 26b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	8a 00                	mov    (%eax),%al
 273:	84 c0                	test   %al,%al
 275:	74 0e                	je     285 <strcmp+0x22>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	8a 10                	mov    (%eax),%dl
 27c:	8b 45 0c             	mov    0xc(%ebp),%eax
 27f:	8a 00                	mov    (%eax),%al
 281:	38 c2                	cmp    %al,%dl
 283:	74 e3                	je     268 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
 288:	8a 00                	mov    (%eax),%al
 28a:	0f b6 d0             	movzbl %al,%edx
 28d:	8b 45 0c             	mov    0xc(%ebp),%eax
 290:	8a 00                	mov    (%eax),%al
 292:	0f b6 c0             	movzbl %al,%eax
 295:	29 c2                	sub    %eax,%edx
 297:	89 d0                	mov    %edx,%eax
}
 299:	5d                   	pop    %ebp
 29a:	c3                   	ret    

0000029b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 29b:	55                   	push   %ebp
 29c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 29e:	eb 09                	jmp    2a9 <strncmp+0xe>
    n--, p++, q++;
 2a0:	ff 4d 10             	decl   0x10(%ebp)
 2a3:	ff 45 08             	incl   0x8(%ebp)
 2a6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 2a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ad:	74 17                	je     2c6 <strncmp+0x2b>
 2af:	8b 45 08             	mov    0x8(%ebp),%eax
 2b2:	8a 00                	mov    (%eax),%al
 2b4:	84 c0                	test   %al,%al
 2b6:	74 0e                	je     2c6 <strncmp+0x2b>
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	8a 10                	mov    (%eax),%dl
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	8a 00                	mov    (%eax),%al
 2c2:	38 c2                	cmp    %al,%dl
 2c4:	74 da                	je     2a0 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 2c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ca:	75 07                	jne    2d3 <strncmp+0x38>
    return 0;
 2cc:	b8 00 00 00 00       	mov    $0x0,%eax
 2d1:	eb 14                	jmp    2e7 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	8a 00                	mov    (%eax),%al
 2d8:	0f b6 d0             	movzbl %al,%edx
 2db:	8b 45 0c             	mov    0xc(%ebp),%eax
 2de:	8a 00                	mov    (%eax),%al
 2e0:	0f b6 c0             	movzbl %al,%eax
 2e3:	29 c2                	sub    %eax,%edx
 2e5:	89 d0                	mov    %edx,%eax
}
 2e7:	5d                   	pop    %ebp
 2e8:	c3                   	ret    

000002e9 <strlen>:

uint
strlen(const char *s)
{
 2e9:	55                   	push   %ebp
 2ea:	89 e5                	mov    %esp,%ebp
 2ec:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2ef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2f6:	eb 03                	jmp    2fb <strlen+0x12>
 2f8:	ff 45 fc             	incl   -0x4(%ebp)
 2fb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	01 d0                	add    %edx,%eax
 303:	8a 00                	mov    (%eax),%al
 305:	84 c0                	test   %al,%al
 307:	75 ef                	jne    2f8 <strlen+0xf>
    ;
  return n;
 309:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <memset>:

void*
memset(void *dst, int c, uint n)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 314:	8b 45 10             	mov    0x10(%ebp),%eax
 317:	89 44 24 08          	mov    %eax,0x8(%esp)
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	89 44 24 04          	mov    %eax,0x4(%esp)
 322:	8b 45 08             	mov    0x8(%ebp),%eax
 325:	89 04 24             	mov    %eax,(%esp)
 328:	e8 cf fd ff ff       	call   fc <stosb>
  return dst;
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <strchr>:

char*
strchr(const char *s, char c)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 04             	sub    $0x4,%esp
 338:	8b 45 0c             	mov    0xc(%ebp),%eax
 33b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 33e:	eb 12                	jmp    352 <strchr+0x20>
    if(*s == c)
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	8a 00                	mov    (%eax),%al
 345:	3a 45 fc             	cmp    -0x4(%ebp),%al
 348:	75 05                	jne    34f <strchr+0x1d>
      return (char*)s;
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	eb 11                	jmp    360 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 34f:	ff 45 08             	incl   0x8(%ebp)
 352:	8b 45 08             	mov    0x8(%ebp),%eax
 355:	8a 00                	mov    (%eax),%al
 357:	84 c0                	test   %al,%al
 359:	75 e5                	jne    340 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 35b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <strcat>:

char *
strcat(char *dest, const char *src)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 36f:	eb 03                	jmp    374 <strcat+0x12>
 371:	ff 45 fc             	incl   -0x4(%ebp)
 374:	8b 55 fc             	mov    -0x4(%ebp),%edx
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	01 d0                	add    %edx,%eax
 37c:	8a 00                	mov    (%eax),%al
 37e:	84 c0                	test   %al,%al
 380:	75 ef                	jne    371 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 382:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 389:	eb 1e                	jmp    3a9 <strcat+0x47>
        dest[i+j] = src[j];
 38b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 38e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 391:	01 d0                	add    %edx,%eax
 393:	89 c2                	mov    %eax,%edx
 395:	8b 45 08             	mov    0x8(%ebp),%eax
 398:	01 c2                	add    %eax,%edx
 39a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 39d:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a0:	01 c8                	add    %ecx,%eax
 3a2:	8a 00                	mov    (%eax),%al
 3a4:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 3a6:	ff 45 f8             	incl   -0x8(%ebp)
 3a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 3af:	01 d0                	add    %edx,%eax
 3b1:	8a 00                	mov    (%eax),%al
 3b3:	84 c0                	test   %al,%al
 3b5:	75 d4                	jne    38b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 3b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3bd:	01 d0                	add    %edx,%eax
 3bf:	89 c2                	mov    %eax,%edx
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	01 d0                	add    %edx,%eax
 3c6:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <strstr>:

int 
strstr(char* s, char* sub)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
 3d1:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3db:	eb 7c                	jmp    459 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 3dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e0:	8b 45 08             	mov    0x8(%ebp),%eax
 3e3:	01 d0                	add    %edx,%eax
 3e5:	8a 10                	mov    (%eax),%dl
 3e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ea:	8a 00                	mov    (%eax),%al
 3ec:	38 c2                	cmp    %al,%dl
 3ee:	75 66                	jne    456 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 3f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f3:	89 04 24             	mov    %eax,(%esp)
 3f6:	e8 ee fe ff ff       	call   2e9 <strlen>
 3fb:	83 f8 01             	cmp    $0x1,%eax
 3fe:	75 05                	jne    405 <strstr+0x37>
            {  
                return i;
 400:	8b 45 fc             	mov    -0x4(%ebp),%eax
 403:	eb 6b                	jmp    470 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 405:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 40c:	eb 3a                	jmp    448 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 40e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 411:	8b 55 fc             	mov    -0x4(%ebp),%edx
 414:	01 d0                	add    %edx,%eax
 416:	89 c2                	mov    %eax,%edx
 418:	8b 45 08             	mov    0x8(%ebp),%eax
 41b:	01 d0                	add    %edx,%eax
 41d:	8a 10                	mov    (%eax),%dl
 41f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	01 c8                	add    %ecx,%eax
 427:	8a 00                	mov    (%eax),%al
 429:	38 c2                	cmp    %al,%dl
 42b:	75 16                	jne    443 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 42d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 430:	8d 50 01             	lea    0x1(%eax),%edx
 433:	8b 45 0c             	mov    0xc(%ebp),%eax
 436:	01 d0                	add    %edx,%eax
 438:	8a 00                	mov    (%eax),%al
 43a:	84 c0                	test   %al,%al
 43c:	75 07                	jne    445 <strstr+0x77>
                    {
                        return i;
 43e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 441:	eb 2d                	jmp    470 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 443:	eb 11                	jmp    456 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 445:	ff 45 f8             	incl   -0x8(%ebp)
 448:	8b 55 f8             	mov    -0x8(%ebp),%edx
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	01 d0                	add    %edx,%eax
 450:	8a 00                	mov    (%eax),%al
 452:	84 c0                	test   %al,%al
 454:	75 b8                	jne    40e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 456:	ff 45 fc             	incl   -0x4(%ebp)
 459:	8b 55 fc             	mov    -0x4(%ebp),%edx
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	01 d0                	add    %edx,%eax
 461:	8a 00                	mov    (%eax),%al
 463:	84 c0                	test   %al,%al
 465:	0f 85 72 ff ff ff    	jne    3dd <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 46b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 470:	c9                   	leave  
 471:	c3                   	ret    

00000472 <strtok>:

char *
strtok(char *s, const char *delim)
{
 472:	55                   	push   %ebp
 473:	89 e5                	mov    %esp,%ebp
 475:	53                   	push   %ebx
 476:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 479:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 47d:	75 08                	jne    487 <strtok+0x15>
  s = lasts;
 47f:	a1 84 12 00 00       	mov    0x1284,%eax
 484:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 487:	8b 45 08             	mov    0x8(%ebp),%eax
 48a:	8d 50 01             	lea    0x1(%eax),%edx
 48d:	89 55 08             	mov    %edx,0x8(%ebp)
 490:	8a 00                	mov    (%eax),%al
 492:	0f be d8             	movsbl %al,%ebx
 495:	85 db                	test   %ebx,%ebx
 497:	75 07                	jne    4a0 <strtok+0x2e>
      return 0;
 499:	b8 00 00 00 00       	mov    $0x0,%eax
 49e:	eb 58                	jmp    4f8 <strtok+0x86>
    } while (strchr(delim, ch));
 4a0:	88 d8                	mov    %bl,%al
 4a2:	0f be c0             	movsbl %al,%eax
 4a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ac:	89 04 24             	mov    %eax,(%esp)
 4af:	e8 7e fe ff ff       	call   332 <strchr>
 4b4:	85 c0                	test   %eax,%eax
 4b6:	75 cf                	jne    487 <strtok+0x15>
    --s;
 4b8:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 4bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4be:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c2:	8b 45 08             	mov    0x8(%ebp),%eax
 4c5:	89 04 24             	mov    %eax,(%esp)
 4c8:	e8 31 00 00 00       	call   4fe <strcspn>
 4cd:	89 c2                	mov    %eax,%edx
 4cf:	8b 45 08             	mov    0x8(%ebp),%eax
 4d2:	01 d0                	add    %edx,%eax
 4d4:	a3 84 12 00 00       	mov    %eax,0x1284
    if (*lasts != 0)
 4d9:	a1 84 12 00 00       	mov    0x1284,%eax
 4de:	8a 00                	mov    (%eax),%al
 4e0:	84 c0                	test   %al,%al
 4e2:	74 11                	je     4f5 <strtok+0x83>
  *lasts++ = 0;
 4e4:	a1 84 12 00 00       	mov    0x1284,%eax
 4e9:	8d 50 01             	lea    0x1(%eax),%edx
 4ec:	89 15 84 12 00 00    	mov    %edx,0x1284
 4f2:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 4f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4f8:	83 c4 14             	add    $0x14,%esp
 4fb:	5b                   	pop    %ebx
 4fc:	5d                   	pop    %ebp
 4fd:	c3                   	ret    

000004fe <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 4fe:	55                   	push   %ebp
 4ff:	89 e5                	mov    %esp,%ebp
 501:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 504:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 50b:	eb 26                	jmp    533 <strcspn+0x35>
        if(strchr(s2,*s1))
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
 510:	8a 00                	mov    (%eax),%al
 512:	0f be c0             	movsbl %al,%eax
 515:	89 44 24 04          	mov    %eax,0x4(%esp)
 519:	8b 45 0c             	mov    0xc(%ebp),%eax
 51c:	89 04 24             	mov    %eax,(%esp)
 51f:	e8 0e fe ff ff       	call   332 <strchr>
 524:	85 c0                	test   %eax,%eax
 526:	74 05                	je     52d <strcspn+0x2f>
            return ret;
 528:	8b 45 fc             	mov    -0x4(%ebp),%eax
 52b:	eb 12                	jmp    53f <strcspn+0x41>
        else
            s1++,ret++;
 52d:	ff 45 08             	incl   0x8(%ebp)
 530:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 533:	8b 45 08             	mov    0x8(%ebp),%eax
 536:	8a 00                	mov    (%eax),%al
 538:	84 c0                	test   %al,%al
 53a:	75 d1                	jne    50d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 53c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 53f:	c9                   	leave  
 540:	c3                   	ret    

00000541 <isspace>:

int
isspace(unsigned char c)
{
 541:	55                   	push   %ebp
 542:	89 e5                	mov    %esp,%ebp
 544:	83 ec 04             	sub    $0x4,%esp
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 54d:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 551:	74 1e                	je     571 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 553:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 557:	74 18                	je     571 <isspace+0x30>
 559:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 55d:	74 12                	je     571 <isspace+0x30>
 55f:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 563:	74 0c                	je     571 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 565:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 569:	74 06                	je     571 <isspace+0x30>
 56b:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 56f:	75 07                	jne    578 <isspace+0x37>
 571:	b8 01 00 00 00       	mov    $0x1,%eax
 576:	eb 05                	jmp    57d <isspace+0x3c>
 578:	b8 00 00 00 00       	mov    $0x0,%eax
}
 57d:	c9                   	leave  
 57e:	c3                   	ret    

0000057f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 57f:	55                   	push   %ebp
 580:	89 e5                	mov    %esp,%ebp
 582:	57                   	push   %edi
 583:	56                   	push   %esi
 584:	53                   	push   %ebx
 585:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 588:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 58d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 594:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 597:	eb 01                	jmp    59a <strtoul+0x1b>
  p += 1;
 599:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 59a:	8a 03                	mov    (%ebx),%al
 59c:	0f b6 c0             	movzbl %al,%eax
 59f:	89 04 24             	mov    %eax,(%esp)
 5a2:	e8 9a ff ff ff       	call   541 <isspace>
 5a7:	85 c0                	test   %eax,%eax
 5a9:	75 ee                	jne    599 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 5ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5af:	75 30                	jne    5e1 <strtoul+0x62>
    {
  if (*p == '0') {
 5b1:	8a 03                	mov    (%ebx),%al
 5b3:	3c 30                	cmp    $0x30,%al
 5b5:	75 21                	jne    5d8 <strtoul+0x59>
      p += 1;
 5b7:	43                   	inc    %ebx
      if (*p == 'x') {
 5b8:	8a 03                	mov    (%ebx),%al
 5ba:	3c 78                	cmp    $0x78,%al
 5bc:	75 0a                	jne    5c8 <strtoul+0x49>
    p += 1;
 5be:	43                   	inc    %ebx
    base = 16;
 5bf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 5c6:	eb 31                	jmp    5f9 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 5c8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 5cf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 5d6:	eb 21                	jmp    5f9 <strtoul+0x7a>
      }
  }
  else base = 10;
 5d8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 5df:	eb 18                	jmp    5f9 <strtoul+0x7a>
    } else if (base == 16) {
 5e1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5e5:	75 12                	jne    5f9 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 5e7:	8a 03                	mov    (%ebx),%al
 5e9:	3c 30                	cmp    $0x30,%al
 5eb:	75 0c                	jne    5f9 <strtoul+0x7a>
 5ed:	8d 43 01             	lea    0x1(%ebx),%eax
 5f0:	8a 00                	mov    (%eax),%al
 5f2:	3c 78                	cmp    $0x78,%al
 5f4:	75 03                	jne    5f9 <strtoul+0x7a>
      p += 2;
 5f6:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 5f9:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 5fd:	75 29                	jne    628 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5ff:	8a 03                	mov    (%ebx),%al
 601:	0f be c0             	movsbl %al,%eax
 604:	83 e8 30             	sub    $0x30,%eax
 607:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 609:	83 fe 07             	cmp    $0x7,%esi
 60c:	76 06                	jbe    614 <strtoul+0x95>
    break;
 60e:	90                   	nop
 60f:	e9 b6 00 00 00       	jmp    6ca <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 614:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 61b:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 61e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 625:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 626:	eb d7                	jmp    5ff <strtoul+0x80>
    } else if (base == 10) {
 628:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 62c:	75 2b                	jne    659 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 62e:	8a 03                	mov    (%ebx),%al
 630:	0f be c0             	movsbl %al,%eax
 633:	83 e8 30             	sub    $0x30,%eax
 636:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 638:	83 fe 09             	cmp    $0x9,%esi
 63b:	76 06                	jbe    643 <strtoul+0xc4>
    break;
 63d:	90                   	nop
 63e:	e9 87 00 00 00       	jmp    6ca <strtoul+0x14b>
      }
      result = (10*result) + digit;
 643:	89 f8                	mov    %edi,%eax
 645:	c1 e0 02             	shl    $0x2,%eax
 648:	01 f8                	add    %edi,%eax
 64a:	01 c0                	add    %eax,%eax
 64c:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 64f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 656:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 657:	eb d5                	jmp    62e <strtoul+0xaf>
    } else if (base == 16) {
 659:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 65d:	75 35                	jne    694 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 65f:	8a 03                	mov    (%ebx),%al
 661:	0f be c0             	movsbl %al,%eax
 664:	83 e8 30             	sub    $0x30,%eax
 667:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 669:	83 fe 4a             	cmp    $0x4a,%esi
 66c:	76 02                	jbe    670 <strtoul+0xf1>
    break;
 66e:	eb 22                	jmp    692 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 670:	8a 86 20 12 00 00    	mov    0x1220(%esi),%al
 676:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 679:	83 fe 0f             	cmp    $0xf,%esi
 67c:	76 02                	jbe    680 <strtoul+0x101>
    break;
 67e:	eb 12                	jmp    692 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 680:	89 f8                	mov    %edi,%eax
 682:	c1 e0 04             	shl    $0x4,%eax
 685:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 688:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 68f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 690:	eb cd                	jmp    65f <strtoul+0xe0>
 692:	eb 36                	jmp    6ca <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 694:	8a 03                	mov    (%ebx),%al
 696:	0f be c0             	movsbl %al,%eax
 699:	83 e8 30             	sub    $0x30,%eax
 69c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 69e:	83 fe 4a             	cmp    $0x4a,%esi
 6a1:	76 02                	jbe    6a5 <strtoul+0x126>
    break;
 6a3:	eb 25                	jmp    6ca <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 6a5:	8a 86 20 12 00 00    	mov    0x1220(%esi),%al
 6ab:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 6ae:	8b 45 10             	mov    0x10(%ebp),%eax
 6b1:	39 f0                	cmp    %esi,%eax
 6b3:	77 02                	ja     6b7 <strtoul+0x138>
    break;
 6b5:	eb 13                	jmp    6ca <strtoul+0x14b>
      }
      result = result*base + digit;
 6b7:	8b 45 10             	mov    0x10(%ebp),%eax
 6ba:	0f af c7             	imul   %edi,%eax
 6bd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 6c7:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 6c8:	eb ca                	jmp    694 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 6ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ce:	75 03                	jne    6d3 <strtoul+0x154>
  p = string;
 6d0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 6d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6d7:	74 05                	je     6de <strtoul+0x15f>
  *endPtr = p;
 6d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6dc:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 6de:	89 f8                	mov    %edi,%eax
}
 6e0:	83 c4 14             	add    $0x14,%esp
 6e3:	5b                   	pop    %ebx
 6e4:	5e                   	pop    %esi
 6e5:	5f                   	pop    %edi
 6e6:	5d                   	pop    %ebp
 6e7:	c3                   	ret    

000006e8 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	53                   	push   %ebx
 6ec:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 6ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 6f2:	eb 01                	jmp    6f5 <strtol+0xd>
      p += 1;
 6f4:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 6f5:	8a 03                	mov    (%ebx),%al
 6f7:	0f b6 c0             	movzbl %al,%eax
 6fa:	89 04 24             	mov    %eax,(%esp)
 6fd:	e8 3f fe ff ff       	call   541 <isspace>
 702:	85 c0                	test   %eax,%eax
 704:	75 ee                	jne    6f4 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 706:	8a 03                	mov    (%ebx),%al
 708:	3c 2d                	cmp    $0x2d,%al
 70a:	75 1e                	jne    72a <strtol+0x42>
  p += 1;
 70c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 70d:	8b 45 10             	mov    0x10(%ebp),%eax
 710:	89 44 24 08          	mov    %eax,0x8(%esp)
 714:	8b 45 0c             	mov    0xc(%ebp),%eax
 717:	89 44 24 04          	mov    %eax,0x4(%esp)
 71b:	89 1c 24             	mov    %ebx,(%esp)
 71e:	e8 5c fe ff ff       	call   57f <strtoul>
 723:	f7 d8                	neg    %eax
 725:	89 45 f8             	mov    %eax,-0x8(%ebp)
 728:	eb 20                	jmp    74a <strtol+0x62>
    } else {
  if (*p == '+') {
 72a:	8a 03                	mov    (%ebx),%al
 72c:	3c 2b                	cmp    $0x2b,%al
 72e:	75 01                	jne    731 <strtol+0x49>
      p += 1;
 730:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 731:	8b 45 10             	mov    0x10(%ebp),%eax
 734:	89 44 24 08          	mov    %eax,0x8(%esp)
 738:	8b 45 0c             	mov    0xc(%ebp),%eax
 73b:	89 44 24 04          	mov    %eax,0x4(%esp)
 73f:	89 1c 24             	mov    %ebx,(%esp)
 742:	e8 38 fe ff ff       	call   57f <strtoul>
 747:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 74a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 74e:	75 17                	jne    767 <strtol+0x7f>
 750:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 754:	74 11                	je     767 <strtol+0x7f>
 756:	8b 45 0c             	mov    0xc(%ebp),%eax
 759:	8b 00                	mov    (%eax),%eax
 75b:	39 d8                	cmp    %ebx,%eax
 75d:	75 08                	jne    767 <strtol+0x7f>
  *endPtr = string;
 75f:	8b 45 0c             	mov    0xc(%ebp),%eax
 762:	8b 55 08             	mov    0x8(%ebp),%edx
 765:	89 10                	mov    %edx,(%eax)
    }
    return result;
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 76a:	83 c4 1c             	add    $0x1c,%esp
 76d:	5b                   	pop    %ebx
 76e:	5d                   	pop    %ebp
 76f:	c3                   	ret    

00000770 <gets>:

char*
gets(char *buf, int max)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 776:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 77d:	eb 49                	jmp    7c8 <gets+0x58>
    cc = read(0, &c, 1);
 77f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 786:	00 
 787:	8d 45 ef             	lea    -0x11(%ebp),%eax
 78a:	89 44 24 04          	mov    %eax,0x4(%esp)
 78e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 795:	e8 3e 01 00 00       	call   8d8 <read>
 79a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 79d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a1:	7f 02                	jg     7a5 <gets+0x35>
      break;
 7a3:	eb 2c                	jmp    7d1 <gets+0x61>
    buf[i++] = c;
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	8d 50 01             	lea    0x1(%eax),%edx
 7ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7ae:	89 c2                	mov    %eax,%edx
 7b0:	8b 45 08             	mov    0x8(%ebp),%eax
 7b3:	01 c2                	add    %eax,%edx
 7b5:	8a 45 ef             	mov    -0x11(%ebp),%al
 7b8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 7ba:	8a 45 ef             	mov    -0x11(%ebp),%al
 7bd:	3c 0a                	cmp    $0xa,%al
 7bf:	74 10                	je     7d1 <gets+0x61>
 7c1:	8a 45 ef             	mov    -0x11(%ebp),%al
 7c4:	3c 0d                	cmp    $0xd,%al
 7c6:	74 09                	je     7d1 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cb:	40                   	inc    %eax
 7cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7cf:	7c ae                	jl     77f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7d4:	8b 45 08             	mov    0x8(%ebp),%eax
 7d7:	01 d0                	add    %edx,%eax
 7d9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7df:	c9                   	leave  
 7e0:	c3                   	ret    

000007e1 <stat>:

int
stat(char *n, struct stat *st)
{
 7e1:	55                   	push   %ebp
 7e2:	89 e5                	mov    %esp,%ebp
 7e4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 7ee:	00 
 7ef:	8b 45 08             	mov    0x8(%ebp),%eax
 7f2:	89 04 24             	mov    %eax,(%esp)
 7f5:	e8 06 01 00 00       	call   900 <open>
 7fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 801:	79 07                	jns    80a <stat+0x29>
    return -1;
 803:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 808:	eb 23                	jmp    82d <stat+0x4c>
  r = fstat(fd, st);
 80a:	8b 45 0c             	mov    0xc(%ebp),%eax
 80d:	89 44 24 04          	mov    %eax,0x4(%esp)
 811:	8b 45 f4             	mov    -0xc(%ebp),%eax
 814:	89 04 24             	mov    %eax,(%esp)
 817:	e8 fc 00 00 00       	call   918 <fstat>
 81c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 81f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 822:	89 04 24             	mov    %eax,(%esp)
 825:	e8 be 00 00 00       	call   8e8 <close>
  return r;
 82a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 82d:	c9                   	leave  
 82e:	c3                   	ret    

0000082f <atoi>:

int
atoi(const char *s)
{
 82f:	55                   	push   %ebp
 830:	89 e5                	mov    %esp,%ebp
 832:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 835:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 83c:	eb 24                	jmp    862 <atoi+0x33>
    n = n*10 + *s++ - '0';
 83e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 841:	89 d0                	mov    %edx,%eax
 843:	c1 e0 02             	shl    $0x2,%eax
 846:	01 d0                	add    %edx,%eax
 848:	01 c0                	add    %eax,%eax
 84a:	89 c1                	mov    %eax,%ecx
 84c:	8b 45 08             	mov    0x8(%ebp),%eax
 84f:	8d 50 01             	lea    0x1(%eax),%edx
 852:	89 55 08             	mov    %edx,0x8(%ebp)
 855:	8a 00                	mov    (%eax),%al
 857:	0f be c0             	movsbl %al,%eax
 85a:	01 c8                	add    %ecx,%eax
 85c:	83 e8 30             	sub    $0x30,%eax
 85f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 862:	8b 45 08             	mov    0x8(%ebp),%eax
 865:	8a 00                	mov    (%eax),%al
 867:	3c 2f                	cmp    $0x2f,%al
 869:	7e 09                	jle    874 <atoi+0x45>
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	8a 00                	mov    (%eax),%al
 870:	3c 39                	cmp    $0x39,%al
 872:	7e ca                	jle    83e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 874:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 877:	c9                   	leave  
 878:	c3                   	ret    

00000879 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 879:	55                   	push   %ebp
 87a:	89 e5                	mov    %esp,%ebp
 87c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 885:	8b 45 0c             	mov    0xc(%ebp),%eax
 888:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 88b:	eb 16                	jmp    8a3 <memmove+0x2a>
    *dst++ = *src++;
 88d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 890:	8d 50 01             	lea    0x1(%eax),%edx
 893:	89 55 fc             	mov    %edx,-0x4(%ebp)
 896:	8b 55 f8             	mov    -0x8(%ebp),%edx
 899:	8d 4a 01             	lea    0x1(%edx),%ecx
 89c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 89f:	8a 12                	mov    (%edx),%dl
 8a1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8a3:	8b 45 10             	mov    0x10(%ebp),%eax
 8a6:	8d 50 ff             	lea    -0x1(%eax),%edx
 8a9:	89 55 10             	mov    %edx,0x10(%ebp)
 8ac:	85 c0                	test   %eax,%eax
 8ae:	7f dd                	jg     88d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8b0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8b3:	c9                   	leave  
 8b4:	c3                   	ret    
 8b5:	90                   	nop
 8b6:	90                   	nop
 8b7:	90                   	nop

000008b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8b8:	b8 01 00 00 00       	mov    $0x1,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <exit>:
SYSCALL(exit)
 8c0:	b8 02 00 00 00       	mov    $0x2,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <wait>:
SYSCALL(wait)
 8c8:	b8 03 00 00 00       	mov    $0x3,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <pipe>:
SYSCALL(pipe)
 8d0:	b8 04 00 00 00       	mov    $0x4,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <read>:
SYSCALL(read)
 8d8:	b8 05 00 00 00       	mov    $0x5,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <write>:
SYSCALL(write)
 8e0:	b8 10 00 00 00       	mov    $0x10,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <close>:
SYSCALL(close)
 8e8:	b8 15 00 00 00       	mov    $0x15,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <kill>:
SYSCALL(kill)
 8f0:	b8 06 00 00 00       	mov    $0x6,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <exec>:
SYSCALL(exec)
 8f8:	b8 07 00 00 00       	mov    $0x7,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <open>:
SYSCALL(open)
 900:	b8 0f 00 00 00       	mov    $0xf,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <mknod>:
SYSCALL(mknod)
 908:	b8 11 00 00 00       	mov    $0x11,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <unlink>:
SYSCALL(unlink)
 910:	b8 12 00 00 00       	mov    $0x12,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <fstat>:
SYSCALL(fstat)
 918:	b8 08 00 00 00       	mov    $0x8,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <link>:
SYSCALL(link)
 920:	b8 13 00 00 00       	mov    $0x13,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <mkdir>:
SYSCALL(mkdir)
 928:	b8 14 00 00 00       	mov    $0x14,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <chdir>:
SYSCALL(chdir)
 930:	b8 09 00 00 00       	mov    $0x9,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <dup>:
SYSCALL(dup)
 938:	b8 0a 00 00 00       	mov    $0xa,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <getpid>:
SYSCALL(getpid)
 940:	b8 0b 00 00 00       	mov    $0xb,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <sbrk>:
SYSCALL(sbrk)
 948:	b8 0c 00 00 00       	mov    $0xc,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <sleep>:
SYSCALL(sleep)
 950:	b8 0d 00 00 00       	mov    $0xd,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <uptime>:
SYSCALL(uptime)
 958:	b8 0e 00 00 00       	mov    $0xe,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 960:	55                   	push   %ebp
 961:	89 e5                	mov    %esp,%ebp
 963:	83 ec 18             	sub    $0x18,%esp
 966:	8b 45 0c             	mov    0xc(%ebp),%eax
 969:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 96c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 973:	00 
 974:	8d 45 f4             	lea    -0xc(%ebp),%eax
 977:	89 44 24 04          	mov    %eax,0x4(%esp)
 97b:	8b 45 08             	mov    0x8(%ebp),%eax
 97e:	89 04 24             	mov    %eax,(%esp)
 981:	e8 5a ff ff ff       	call   8e0 <write>
}
 986:	c9                   	leave  
 987:	c3                   	ret    

00000988 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 988:	55                   	push   %ebp
 989:	89 e5                	mov    %esp,%ebp
 98b:	56                   	push   %esi
 98c:	53                   	push   %ebx
 98d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 990:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 997:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 99b:	74 17                	je     9b4 <printint+0x2c>
 99d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9a1:	79 11                	jns    9b4 <printint+0x2c>
    neg = 1;
 9a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 9ad:	f7 d8                	neg    %eax
 9af:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9b2:	eb 06                	jmp    9ba <printint+0x32>
  } else {
    x = xx;
 9b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 9b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9c4:	8d 41 01             	lea    0x1(%ecx),%eax
 9c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9d0:	ba 00 00 00 00       	mov    $0x0,%edx
 9d5:	f7 f3                	div    %ebx
 9d7:	89 d0                	mov    %edx,%eax
 9d9:	8a 80 6c 12 00 00    	mov    0x126c(%eax),%al
 9df:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9e3:	8b 75 10             	mov    0x10(%ebp),%esi
 9e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9e9:	ba 00 00 00 00       	mov    $0x0,%edx
 9ee:	f7 f6                	div    %esi
 9f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9f7:	75 c8                	jne    9c1 <printint+0x39>
  if(neg)
 9f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9fd:	74 10                	je     a0f <printint+0x87>
    buf[i++] = '-';
 9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a02:	8d 50 01             	lea    0x1(%eax),%edx
 a05:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a08:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a0d:	eb 1e                	jmp    a2d <printint+0xa5>
 a0f:	eb 1c                	jmp    a2d <printint+0xa5>
    putc(fd, buf[i]);
 a11:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a17:	01 d0                	add    %edx,%eax
 a19:	8a 00                	mov    (%eax),%al
 a1b:	0f be c0             	movsbl %al,%eax
 a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a22:	8b 45 08             	mov    0x8(%ebp),%eax
 a25:	89 04 24             	mov    %eax,(%esp)
 a28:	e8 33 ff ff ff       	call   960 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a2d:	ff 4d f4             	decl   -0xc(%ebp)
 a30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a34:	79 db                	jns    a11 <printint+0x89>
    putc(fd, buf[i]);
}
 a36:	83 c4 30             	add    $0x30,%esp
 a39:	5b                   	pop    %ebx
 a3a:	5e                   	pop    %esi
 a3b:	5d                   	pop    %ebp
 a3c:	c3                   	ret    

00000a3d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a3d:	55                   	push   %ebp
 a3e:	89 e5                	mov    %esp,%ebp
 a40:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a43:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a4a:	8d 45 0c             	lea    0xc(%ebp),%eax
 a4d:	83 c0 04             	add    $0x4,%eax
 a50:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a53:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a5a:	e9 77 01 00 00       	jmp    bd6 <printf+0x199>
    c = fmt[i] & 0xff;
 a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
 a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a65:	01 d0                	add    %edx,%eax
 a67:	8a 00                	mov    (%eax),%al
 a69:	0f be c0             	movsbl %al,%eax
 a6c:	25 ff 00 00 00       	and    $0xff,%eax
 a71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a74:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a78:	75 2c                	jne    aa6 <printf+0x69>
      if(c == '%'){
 a7a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a7e:	75 0c                	jne    a8c <printf+0x4f>
        state = '%';
 a80:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a87:	e9 47 01 00 00       	jmp    bd3 <printf+0x196>
      } else {
        putc(fd, c);
 a8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a8f:	0f be c0             	movsbl %al,%eax
 a92:	89 44 24 04          	mov    %eax,0x4(%esp)
 a96:	8b 45 08             	mov    0x8(%ebp),%eax
 a99:	89 04 24             	mov    %eax,(%esp)
 a9c:	e8 bf fe ff ff       	call   960 <putc>
 aa1:	e9 2d 01 00 00       	jmp    bd3 <printf+0x196>
      }
    } else if(state == '%'){
 aa6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 aaa:	0f 85 23 01 00 00    	jne    bd3 <printf+0x196>
      if(c == 'd'){
 ab0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 ab4:	75 2d                	jne    ae3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 ab6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ab9:	8b 00                	mov    (%eax),%eax
 abb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 ac2:	00 
 ac3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 aca:	00 
 acb:	89 44 24 04          	mov    %eax,0x4(%esp)
 acf:	8b 45 08             	mov    0x8(%ebp),%eax
 ad2:	89 04 24             	mov    %eax,(%esp)
 ad5:	e8 ae fe ff ff       	call   988 <printint>
        ap++;
 ada:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ade:	e9 e9 00 00 00       	jmp    bcc <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 ae3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 ae7:	74 06                	je     aef <printf+0xb2>
 ae9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 aed:	75 2d                	jne    b1c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 aef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 af2:	8b 00                	mov    (%eax),%eax
 af4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 afb:	00 
 afc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b03:	00 
 b04:	89 44 24 04          	mov    %eax,0x4(%esp)
 b08:	8b 45 08             	mov    0x8(%ebp),%eax
 b0b:	89 04 24             	mov    %eax,(%esp)
 b0e:	e8 75 fe ff ff       	call   988 <printint>
        ap++;
 b13:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b17:	e9 b0 00 00 00       	jmp    bcc <printf+0x18f>
      } else if(c == 's'){
 b1c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b20:	75 42                	jne    b64 <printf+0x127>
        s = (char*)*ap;
 b22:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b25:	8b 00                	mov    (%eax),%eax
 b27:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b2a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b32:	75 09                	jne    b3d <printf+0x100>
          s = "(null)";
 b34:	c7 45 f4 8e 0e 00 00 	movl   $0xe8e,-0xc(%ebp)
        while(*s != 0){
 b3b:	eb 1c                	jmp    b59 <printf+0x11c>
 b3d:	eb 1a                	jmp    b59 <printf+0x11c>
          putc(fd, *s);
 b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b42:	8a 00                	mov    (%eax),%al
 b44:	0f be c0             	movsbl %al,%eax
 b47:	89 44 24 04          	mov    %eax,0x4(%esp)
 b4b:	8b 45 08             	mov    0x8(%ebp),%eax
 b4e:	89 04 24             	mov    %eax,(%esp)
 b51:	e8 0a fe ff ff       	call   960 <putc>
          s++;
 b56:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5c:	8a 00                	mov    (%eax),%al
 b5e:	84 c0                	test   %al,%al
 b60:	75 dd                	jne    b3f <printf+0x102>
 b62:	eb 68                	jmp    bcc <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b64:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b68:	75 1d                	jne    b87 <printf+0x14a>
        putc(fd, *ap);
 b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b6d:	8b 00                	mov    (%eax),%eax
 b6f:	0f be c0             	movsbl %al,%eax
 b72:	89 44 24 04          	mov    %eax,0x4(%esp)
 b76:	8b 45 08             	mov    0x8(%ebp),%eax
 b79:	89 04 24             	mov    %eax,(%esp)
 b7c:	e8 df fd ff ff       	call   960 <putc>
        ap++;
 b81:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b85:	eb 45                	jmp    bcc <printf+0x18f>
      } else if(c == '%'){
 b87:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b8b:	75 17                	jne    ba4 <printf+0x167>
        putc(fd, c);
 b8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b90:	0f be c0             	movsbl %al,%eax
 b93:	89 44 24 04          	mov    %eax,0x4(%esp)
 b97:	8b 45 08             	mov    0x8(%ebp),%eax
 b9a:	89 04 24             	mov    %eax,(%esp)
 b9d:	e8 be fd ff ff       	call   960 <putc>
 ba2:	eb 28                	jmp    bcc <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ba4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 bab:	00 
 bac:	8b 45 08             	mov    0x8(%ebp),%eax
 baf:	89 04 24             	mov    %eax,(%esp)
 bb2:	e8 a9 fd ff ff       	call   960 <putc>
        putc(fd, c);
 bb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bba:	0f be c0             	movsbl %al,%eax
 bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
 bc1:	8b 45 08             	mov    0x8(%ebp),%eax
 bc4:	89 04 24             	mov    %eax,(%esp)
 bc7:	e8 94 fd ff ff       	call   960 <putc>
      }
      state = 0;
 bcc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bd3:	ff 45 f0             	incl   -0x10(%ebp)
 bd6:	8b 55 0c             	mov    0xc(%ebp),%edx
 bd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bdc:	01 d0                	add    %edx,%eax
 bde:	8a 00                	mov    (%eax),%al
 be0:	84 c0                	test   %al,%al
 be2:	0f 85 77 fe ff ff    	jne    a5f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 be8:	c9                   	leave  
 be9:	c3                   	ret    
 bea:	90                   	nop
 beb:	90                   	nop

00000bec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bec:	55                   	push   %ebp
 bed:	89 e5                	mov    %esp,%ebp
 bef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bf2:	8b 45 08             	mov    0x8(%ebp),%eax
 bf5:	83 e8 08             	sub    $0x8,%eax
 bf8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bfb:	a1 90 12 00 00       	mov    0x1290,%eax
 c00:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c03:	eb 24                	jmp    c29 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c08:	8b 00                	mov    (%eax),%eax
 c0a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c0d:	77 12                	ja     c21 <free+0x35>
 c0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c12:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c15:	77 24                	ja     c3b <free+0x4f>
 c17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1a:	8b 00                	mov    (%eax),%eax
 c1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c1f:	77 1a                	ja     c3b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c21:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c24:	8b 00                	mov    (%eax),%eax
 c26:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c29:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c2f:	76 d4                	jbe    c05 <free+0x19>
 c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c34:	8b 00                	mov    (%eax),%eax
 c36:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c39:	76 ca                	jbe    c05 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3e:	8b 40 04             	mov    0x4(%eax),%eax
 c41:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c48:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4b:	01 c2                	add    %eax,%edx
 c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c50:	8b 00                	mov    (%eax),%eax
 c52:	39 c2                	cmp    %eax,%edx
 c54:	75 24                	jne    c7a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c56:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c59:	8b 50 04             	mov    0x4(%eax),%edx
 c5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5f:	8b 00                	mov    (%eax),%eax
 c61:	8b 40 04             	mov    0x4(%eax),%eax
 c64:	01 c2                	add    %eax,%edx
 c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c69:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6f:	8b 00                	mov    (%eax),%eax
 c71:	8b 10                	mov    (%eax),%edx
 c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c76:	89 10                	mov    %edx,(%eax)
 c78:	eb 0a                	jmp    c84 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c7d:	8b 10                	mov    (%eax),%edx
 c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c82:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c87:	8b 40 04             	mov    0x4(%eax),%eax
 c8a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c94:	01 d0                	add    %edx,%eax
 c96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c99:	75 20                	jne    cbb <free+0xcf>
    p->s.size += bp->s.size;
 c9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9e:	8b 50 04             	mov    0x4(%eax),%edx
 ca1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca4:	8b 40 04             	mov    0x4(%eax),%eax
 ca7:	01 c2                	add    %eax,%edx
 ca9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 caf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb2:	8b 10                	mov    (%eax),%edx
 cb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb7:	89 10                	mov    %edx,(%eax)
 cb9:	eb 08                	jmp    cc3 <free+0xd7>
  } else
    p->s.ptr = bp;
 cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 cc1:	89 10                	mov    %edx,(%eax)
  freep = p;
 cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc6:	a3 90 12 00 00       	mov    %eax,0x1290
}
 ccb:	c9                   	leave  
 ccc:	c3                   	ret    

00000ccd <morecore>:

static Header*
morecore(uint nu)
{
 ccd:	55                   	push   %ebp
 cce:	89 e5                	mov    %esp,%ebp
 cd0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 cd3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cda:	77 07                	ja     ce3 <morecore+0x16>
    nu = 4096;
 cdc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ce3:	8b 45 08             	mov    0x8(%ebp),%eax
 ce6:	c1 e0 03             	shl    $0x3,%eax
 ce9:	89 04 24             	mov    %eax,(%esp)
 cec:	e8 57 fc ff ff       	call   948 <sbrk>
 cf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cf4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cf8:	75 07                	jne    d01 <morecore+0x34>
    return 0;
 cfa:	b8 00 00 00 00       	mov    $0x0,%eax
 cff:	eb 22                	jmp    d23 <morecore+0x56>
  hp = (Header*)p;
 d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d07:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d0a:	8b 55 08             	mov    0x8(%ebp),%edx
 d0d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d13:	83 c0 08             	add    $0x8,%eax
 d16:	89 04 24             	mov    %eax,(%esp)
 d19:	e8 ce fe ff ff       	call   bec <free>
  return freep;
 d1e:	a1 90 12 00 00       	mov    0x1290,%eax
}
 d23:	c9                   	leave  
 d24:	c3                   	ret    

00000d25 <malloc>:

void*
malloc(uint nbytes)
{
 d25:	55                   	push   %ebp
 d26:	89 e5                	mov    %esp,%ebp
 d28:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d2b:	8b 45 08             	mov    0x8(%ebp),%eax
 d2e:	83 c0 07             	add    $0x7,%eax
 d31:	c1 e8 03             	shr    $0x3,%eax
 d34:	40                   	inc    %eax
 d35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d38:	a1 90 12 00 00       	mov    0x1290,%eax
 d3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d44:	75 23                	jne    d69 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d46:	c7 45 f0 88 12 00 00 	movl   $0x1288,-0x10(%ebp)
 d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d50:	a3 90 12 00 00       	mov    %eax,0x1290
 d55:	a1 90 12 00 00       	mov    0x1290,%eax
 d5a:	a3 88 12 00 00       	mov    %eax,0x1288
    base.s.size = 0;
 d5f:	c7 05 8c 12 00 00 00 	movl   $0x0,0x128c
 d66:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d6c:	8b 00                	mov    (%eax),%eax
 d6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d74:	8b 40 04             	mov    0x4(%eax),%eax
 d77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d7a:	72 4d                	jb     dc9 <malloc+0xa4>
      if(p->s.size == nunits)
 d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7f:	8b 40 04             	mov    0x4(%eax),%eax
 d82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d85:	75 0c                	jne    d93 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8a:	8b 10                	mov    (%eax),%edx
 d8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d8f:	89 10                	mov    %edx,(%eax)
 d91:	eb 26                	jmp    db9 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d96:	8b 40 04             	mov    0x4(%eax),%eax
 d99:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d9c:	89 c2                	mov    %eax,%edx
 d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da7:	8b 40 04             	mov    0x4(%eax),%eax
 daa:	c1 e0 03             	shl    $0x3,%eax
 dad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 db6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dbc:	a3 90 12 00 00       	mov    %eax,0x1290
      return (void*)(p + 1);
 dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc4:	83 c0 08             	add    $0x8,%eax
 dc7:	eb 38                	jmp    e01 <malloc+0xdc>
    }
    if(p == freep)
 dc9:	a1 90 12 00 00       	mov    0x1290,%eax
 dce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 dd1:	75 1b                	jne    dee <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 dd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 dd6:	89 04 24             	mov    %eax,(%esp)
 dd9:	e8 ef fe ff ff       	call   ccd <morecore>
 dde:	89 45 f4             	mov    %eax,-0xc(%ebp)
 de1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 de5:	75 07                	jne    dee <malloc+0xc9>
        return 0;
 de7:	b8 00 00 00 00       	mov    $0x0,%eax
 dec:	eb 13                	jmp    e01 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df7:	8b 00                	mov    (%eax),%eax
 df9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 dfc:	e9 70 ff ff ff       	jmp    d71 <malloc+0x4c>
}
 e01:	c9                   	leave  
 e02:	c3                   	ret    
