
_echoloop:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;
  int ticks;

  if (argc < 3) {
   9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
  	printf(1, "usage: echoloop ticks arg1 [arg2 ...]\n");
   f:	c7 44 24 04 b0 0d 00 	movl   $0xdb0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 c6 09 00 00       	call   9e9 <printf>
  	exit();
  23:	e8 44 08 00 00       	call   86c <exit>
  }

  ticks = atoi(argv[1]);
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 04             	add    $0x4,%eax
  2e:	8b 00                	mov    (%eax),%eax
  30:	89 04 24             	mov    %eax,(%esp)
  33:	e8 a3 07 00 00       	call   7db <atoi>
  38:	89 44 24 18          	mov    %eax,0x18(%esp)

  while(1){
	  for(i = 2; i < argc; i++)
  3c:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
  43:	00 
  44:	eb 48                	jmp    8e <main+0x8e>
    	printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  46:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4a:	40                   	inc    %eax
  4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  4e:	7d 07                	jge    57 <main+0x57>
  50:	b8 d7 0d 00 00       	mov    $0xdd7,%eax
  55:	eb 05                	jmp    5c <main+0x5c>
  57:	b8 d9 0d 00 00       	mov    $0xdd9,%eax
  5c:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  60:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	01 ca                	add    %ecx,%edx
  6c:	8b 12                	mov    (%edx),%edx
  6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  72:	89 54 24 08          	mov    %edx,0x8(%esp)
  76:	c7 44 24 04 db 0d 00 	movl   $0xddb,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 5f 09 00 00       	call   9e9 <printf>
  }

  ticks = atoi(argv[1]);

  while(1){
	  for(i = 2; i < argc; i++)
  8a:	ff 44 24 1c          	incl   0x1c(%esp)
  8e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  92:	3b 45 08             	cmp    0x8(%ebp),%eax
  95:	7c af                	jl     46 <main+0x46>
    	printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    sleep(ticks);
  97:	8b 44 24 18          	mov    0x18(%esp),%eax
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 59 08 00 00       	call   8fc <sleep>
  }
  a3:	eb 97                	jmp    3c <main+0x3c>
  a5:	90                   	nop
  a6:	90                   	nop
  a7:	90                   	nop

000000a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b0:	8b 55 10             	mov    0x10(%ebp),%edx
  b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  b6:	89 cb                	mov    %ecx,%ebx
  b8:	89 df                	mov    %ebx,%edi
  ba:	89 d1                	mov    %edx,%ecx
  bc:	fc                   	cld    
  bd:	f3 aa                	rep stos %al,%es:(%edi)
  bf:	89 ca                	mov    %ecx,%edx
  c1:	89 fb                	mov    %edi,%ebx
  c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c9:	5b                   	pop    %ebx
  ca:	5f                   	pop    %edi
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    

000000cd <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  cd:	55                   	push   %ebp
  ce:	89 e5                	mov    %esp,%ebp
  d0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d9:	90                   	nop
  da:	8b 45 08             	mov    0x8(%ebp),%eax
  dd:	8d 50 01             	lea    0x1(%eax),%edx
  e0:	89 55 08             	mov    %edx,0x8(%ebp)
  e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ec:	8a 12                	mov    (%edx),%dl
  ee:	88 10                	mov    %dl,(%eax)
  f0:	8a 00                	mov    (%eax),%al
  f2:	84 c0                	test   %al,%al
  f4:	75 e4                	jne    da <strcpy+0xd>
    ;
  return os;
  f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
 101:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 108:	00 
 109:	8b 45 08             	mov    0x8(%ebp),%eax
 10c:	89 04 24             	mov    %eax,(%esp)
 10f:	e8 98 07 00 00       	call   8ac <open>
 114:	89 45 f0             	mov    %eax,-0x10(%ebp)
 117:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 11b:	79 20                	jns    13d <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	89 44 24 08          	mov    %eax,0x8(%esp)
 124:	c7 44 24 04 e0 0d 00 	movl   $0xde0,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	e8 b1 08 00 00       	call   9e9 <printf>
        exit();
 138:	e8 2f 07 00 00       	call   86c <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 13d:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 144:	00 
 145:	8b 45 0c             	mov    0xc(%ebp),%eax
 148:	89 04 24             	mov    %eax,(%esp)
 14b:	e8 5c 07 00 00       	call   8ac <open>
 150:	89 45 ec             	mov    %eax,-0x14(%ebp)
 153:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 157:	79 20                	jns    179 <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 159:	8b 45 0c             	mov    0xc(%ebp),%eax
 15c:	89 44 24 08          	mov    %eax,0x8(%esp)
 160:	c7 44 24 04 fb 0d 00 	movl   $0xdfb,0x4(%esp)
 167:	00 
 168:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 16f:	e8 75 08 00 00       	call   9e9 <printf>
        exit();
 174:	e8 f3 06 00 00       	call   86c <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 179:	eb 56                	jmp    1d1 <copy+0xd6>
        int max = used_disk+=count;
 17b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 17e:	01 45 10             	add    %eax,0x10(%ebp)
 181:	8b 45 10             	mov    0x10(%ebp),%eax
 184:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 18a:	89 44 24 08          	mov    %eax,0x8(%esp)
 18e:	c7 44 24 04 17 0e 00 	movl   $0xe17,0x4(%esp)
 195:	00 
 196:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19d:	e8 47 08 00 00       	call   9e9 <printf>
        if(max > max_disk){
 1a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1a5:	3b 45 14             	cmp    0x14(%ebp),%eax
 1a8:	7e 07                	jle    1b1 <copy+0xb6>
          return -1;
 1aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1af:	eb 5c                	jmp    20d <copy+0x112>
        }
        bytes = bytes + count;
 1b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 1b4:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 1b7:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 1be:	00 
 1bf:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1c9:	89 04 24             	mov    %eax,(%esp)
 1cc:	e8 bb 06 00 00       	call   88c <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 1d1:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 1d8:	00 
 1d9:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 99 06 00 00       	call   884 <read>
 1eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
 1ee:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1f2:	7f 87                	jg     17b <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1f7:	89 04 24             	mov    %eax,(%esp)
 1fa:	e8 95 06 00 00       	call   894 <close>
    close(fd2);
 1ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 202:	89 04 24             	mov    %eax,(%esp)
 205:	e8 8a 06 00 00       	call   894 <close>
    return(bytes);
 20a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 20d:	c9                   	leave  
 20e:	c3                   	ret    

0000020f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 20f:	55                   	push   %ebp
 210:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 212:	eb 06                	jmp    21a <strcmp+0xb>
    p++, q++;
 214:	ff 45 08             	incl   0x8(%ebp)
 217:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
 21d:	8a 00                	mov    (%eax),%al
 21f:	84 c0                	test   %al,%al
 221:	74 0e                	je     231 <strcmp+0x22>
 223:	8b 45 08             	mov    0x8(%ebp),%eax
 226:	8a 10                	mov    (%eax),%dl
 228:	8b 45 0c             	mov    0xc(%ebp),%eax
 22b:	8a 00                	mov    (%eax),%al
 22d:	38 c2                	cmp    %al,%dl
 22f:	74 e3                	je     214 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 231:	8b 45 08             	mov    0x8(%ebp),%eax
 234:	8a 00                	mov    (%eax),%al
 236:	0f b6 d0             	movzbl %al,%edx
 239:	8b 45 0c             	mov    0xc(%ebp),%eax
 23c:	8a 00                	mov    (%eax),%al
 23e:	0f b6 c0             	movzbl %al,%eax
 241:	29 c2                	sub    %eax,%edx
 243:	89 d0                	mov    %edx,%eax
}
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    

00000247 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 24a:	eb 09                	jmp    255 <strncmp+0xe>
    n--, p++, q++;
 24c:	ff 4d 10             	decl   0x10(%ebp)
 24f:	ff 45 08             	incl   0x8(%ebp)
 252:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 255:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 259:	74 17                	je     272 <strncmp+0x2b>
 25b:	8b 45 08             	mov    0x8(%ebp),%eax
 25e:	8a 00                	mov    (%eax),%al
 260:	84 c0                	test   %al,%al
 262:	74 0e                	je     272 <strncmp+0x2b>
 264:	8b 45 08             	mov    0x8(%ebp),%eax
 267:	8a 10                	mov    (%eax),%dl
 269:	8b 45 0c             	mov    0xc(%ebp),%eax
 26c:	8a 00                	mov    (%eax),%al
 26e:	38 c2                	cmp    %al,%dl
 270:	74 da                	je     24c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 272:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 276:	75 07                	jne    27f <strncmp+0x38>
    return 0;
 278:	b8 00 00 00 00       	mov    $0x0,%eax
 27d:	eb 14                	jmp    293 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	8a 00                	mov    (%eax),%al
 284:	0f b6 d0             	movzbl %al,%edx
 287:	8b 45 0c             	mov    0xc(%ebp),%eax
 28a:	8a 00                	mov    (%eax),%al
 28c:	0f b6 c0             	movzbl %al,%eax
 28f:	29 c2                	sub    %eax,%edx
 291:	89 d0                	mov    %edx,%eax
}
 293:	5d                   	pop    %ebp
 294:	c3                   	ret    

00000295 <strlen>:

uint
strlen(const char *s)
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 29b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2a2:	eb 03                	jmp    2a7 <strlen+0x12>
 2a4:	ff 45 fc             	incl   -0x4(%ebp)
 2a7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	01 d0                	add    %edx,%eax
 2af:	8a 00                	mov    (%eax),%al
 2b1:	84 c0                	test   %al,%al
 2b3:	75 ef                	jne    2a4 <strlen+0xf>
    ;
  return n;
 2b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2c0:	8b 45 10             	mov    0x10(%ebp),%eax
 2c3:	89 44 24 08          	mov    %eax,0x8(%esp)
 2c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	89 04 24             	mov    %eax,(%esp)
 2d4:	e8 cf fd ff ff       	call   a8 <stosb>
  return dst;
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <strchr>:

char*
strchr(const char *s, char c)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	83 ec 04             	sub    $0x4,%esp
 2e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ea:	eb 12                	jmp    2fe <strchr+0x20>
    if(*s == c)
 2ec:	8b 45 08             	mov    0x8(%ebp),%eax
 2ef:	8a 00                	mov    (%eax),%al
 2f1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2f4:	75 05                	jne    2fb <strchr+0x1d>
      return (char*)s;
 2f6:	8b 45 08             	mov    0x8(%ebp),%eax
 2f9:	eb 11                	jmp    30c <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2fb:	ff 45 08             	incl   0x8(%ebp)
 2fe:	8b 45 08             	mov    0x8(%ebp),%eax
 301:	8a 00                	mov    (%eax),%al
 303:	84 c0                	test   %al,%al
 305:	75 e5                	jne    2ec <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 307:	b8 00 00 00 00       	mov    $0x0,%eax
}
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <strcat>:

char *
strcat(char *dest, const char *src)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 31b:	eb 03                	jmp    320 <strcat+0x12>
 31d:	ff 45 fc             	incl   -0x4(%ebp)
 320:	8b 55 fc             	mov    -0x4(%ebp),%edx
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	01 d0                	add    %edx,%eax
 328:	8a 00                	mov    (%eax),%al
 32a:	84 c0                	test   %al,%al
 32c:	75 ef                	jne    31d <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 32e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 335:	eb 1e                	jmp    355 <strcat+0x47>
        dest[i+j] = src[j];
 337:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33d:	01 d0                	add    %edx,%eax
 33f:	89 c2                	mov    %eax,%edx
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	01 c2                	add    %eax,%edx
 346:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 349:	8b 45 0c             	mov    0xc(%ebp),%eax
 34c:	01 c8                	add    %ecx,%eax
 34e:	8a 00                	mov    (%eax),%al
 350:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 352:	ff 45 f8             	incl   -0x8(%ebp)
 355:	8b 55 f8             	mov    -0x8(%ebp),%edx
 358:	8b 45 0c             	mov    0xc(%ebp),%eax
 35b:	01 d0                	add    %edx,%eax
 35d:	8a 00                	mov    (%eax),%al
 35f:	84 c0                	test   %al,%al
 361:	75 d4                	jne    337 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 363:	8b 45 f8             	mov    -0x8(%ebp),%eax
 366:	8b 55 fc             	mov    -0x4(%ebp),%edx
 369:	01 d0                	add    %edx,%eax
 36b:	89 c2                	mov    %eax,%edx
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	01 d0                	add    %edx,%eax
 372:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
}
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <strstr>:

int 
strstr(char* s, char* sub)
{
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 387:	eb 7c                	jmp    405 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 389:	8b 55 fc             	mov    -0x4(%ebp),%edx
 38c:	8b 45 08             	mov    0x8(%ebp),%eax
 38f:	01 d0                	add    %edx,%eax
 391:	8a 10                	mov    (%eax),%dl
 393:	8b 45 0c             	mov    0xc(%ebp),%eax
 396:	8a 00                	mov    (%eax),%al
 398:	38 c2                	cmp    %al,%dl
 39a:	75 66                	jne    402 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 39c:	8b 45 0c             	mov    0xc(%ebp),%eax
 39f:	89 04 24             	mov    %eax,(%esp)
 3a2:	e8 ee fe ff ff       	call   295 <strlen>
 3a7:	83 f8 01             	cmp    $0x1,%eax
 3aa:	75 05                	jne    3b1 <strstr+0x37>
            {  
                return i;
 3ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3af:	eb 6b                	jmp    41c <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 3b1:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 3b8:	eb 3a                	jmp    3f4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 3ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3bd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c0:	01 d0                	add    %edx,%eax
 3c2:	89 c2                	mov    %eax,%edx
 3c4:	8b 45 08             	mov    0x8(%ebp),%eax
 3c7:	01 d0                	add    %edx,%eax
 3c9:	8a 10                	mov    (%eax),%dl
 3cb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d1:	01 c8                	add    %ecx,%eax
 3d3:	8a 00                	mov    (%eax),%al
 3d5:	38 c2                	cmp    %al,%dl
 3d7:	75 16                	jne    3ef <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 3d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3dc:	8d 50 01             	lea    0x1(%eax),%edx
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	01 d0                	add    %edx,%eax
 3e4:	8a 00                	mov    (%eax),%al
 3e6:	84 c0                	test   %al,%al
 3e8:	75 07                	jne    3f1 <strstr+0x77>
                    {
                        return i;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	eb 2d                	jmp    41c <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3ef:	eb 11                	jmp    402 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3f1:	ff 45 f8             	incl   -0x8(%ebp)
 3f4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fa:	01 d0                	add    %edx,%eax
 3fc:	8a 00                	mov    (%eax),%al
 3fe:	84 c0                	test   %al,%al
 400:	75 b8                	jne    3ba <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 402:	ff 45 fc             	incl   -0x4(%ebp)
 405:	8b 55 fc             	mov    -0x4(%ebp),%edx
 408:	8b 45 08             	mov    0x8(%ebp),%eax
 40b:	01 d0                	add    %edx,%eax
 40d:	8a 00                	mov    (%eax),%al
 40f:	84 c0                	test   %al,%al
 411:	0f 85 72 ff ff ff    	jne    389 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 417:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 41c:	c9                   	leave  
 41d:	c3                   	ret    

0000041e <strtok>:

char *
strtok(char *s, const char *delim)
{
 41e:	55                   	push   %ebp
 41f:	89 e5                	mov    %esp,%ebp
 421:	53                   	push   %ebx
 422:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 425:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 429:	75 08                	jne    433 <strtok+0x15>
  s = lasts;
 42b:	a1 24 12 00 00       	mov    0x1224,%eax
 430:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	8d 50 01             	lea    0x1(%eax),%edx
 439:	89 55 08             	mov    %edx,0x8(%ebp)
 43c:	8a 00                	mov    (%eax),%al
 43e:	0f be d8             	movsbl %al,%ebx
 441:	85 db                	test   %ebx,%ebx
 443:	75 07                	jne    44c <strtok+0x2e>
      return 0;
 445:	b8 00 00 00 00       	mov    $0x0,%eax
 44a:	eb 58                	jmp    4a4 <strtok+0x86>
    } while (strchr(delim, ch));
 44c:	88 d8                	mov    %bl,%al
 44e:	0f be c0             	movsbl %al,%eax
 451:	89 44 24 04          	mov    %eax,0x4(%esp)
 455:	8b 45 0c             	mov    0xc(%ebp),%eax
 458:	89 04 24             	mov    %eax,(%esp)
 45b:	e8 7e fe ff ff       	call   2de <strchr>
 460:	85 c0                	test   %eax,%eax
 462:	75 cf                	jne    433 <strtok+0x15>
    --s;
 464:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 467:	8b 45 0c             	mov    0xc(%ebp),%eax
 46a:	89 44 24 04          	mov    %eax,0x4(%esp)
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	89 04 24             	mov    %eax,(%esp)
 474:	e8 31 00 00 00       	call   4aa <strcspn>
 479:	89 c2                	mov    %eax,%edx
 47b:	8b 45 08             	mov    0x8(%ebp),%eax
 47e:	01 d0                	add    %edx,%eax
 480:	a3 24 12 00 00       	mov    %eax,0x1224
    if (*lasts != 0)
 485:	a1 24 12 00 00       	mov    0x1224,%eax
 48a:	8a 00                	mov    (%eax),%al
 48c:	84 c0                	test   %al,%al
 48e:	74 11                	je     4a1 <strtok+0x83>
  *lasts++ = 0;
 490:	a1 24 12 00 00       	mov    0x1224,%eax
 495:	8d 50 01             	lea    0x1(%eax),%edx
 498:	89 15 24 12 00 00    	mov    %edx,0x1224
 49e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a4:	83 c4 14             	add    $0x14,%esp
 4a7:	5b                   	pop    %ebx
 4a8:	5d                   	pop    %ebp
 4a9:	c3                   	ret    

000004aa <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 4aa:	55                   	push   %ebp
 4ab:	89 e5                	mov    %esp,%ebp
 4ad:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 4b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 4b7:	eb 26                	jmp    4df <strcspn+0x35>
        if(strchr(s2,*s1))
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
 4bc:	8a 00                	mov    (%eax),%al
 4be:	0f be c0             	movsbl %al,%eax
 4c1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c8:	89 04 24             	mov    %eax,(%esp)
 4cb:	e8 0e fe ff ff       	call   2de <strchr>
 4d0:	85 c0                	test   %eax,%eax
 4d2:	74 05                	je     4d9 <strcspn+0x2f>
            return ret;
 4d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4d7:	eb 12                	jmp    4eb <strcspn+0x41>
        else
            s1++,ret++;
 4d9:	ff 45 08             	incl   0x8(%ebp)
 4dc:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	8a 00                	mov    (%eax),%al
 4e4:	84 c0                	test   %al,%al
 4e6:	75 d1                	jne    4b9 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4eb:	c9                   	leave  
 4ec:	c3                   	ret    

000004ed <isspace>:

int
isspace(unsigned char c)
{
 4ed:	55                   	push   %ebp
 4ee:	89 e5                	mov    %esp,%ebp
 4f0:	83 ec 04             	sub    $0x4,%esp
 4f3:	8b 45 08             	mov    0x8(%ebp),%eax
 4f6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4f9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4fd:	74 1e                	je     51d <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4ff:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 503:	74 18                	je     51d <isspace+0x30>
 505:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 509:	74 12                	je     51d <isspace+0x30>
 50b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 50f:	74 0c                	je     51d <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 511:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 515:	74 06                	je     51d <isspace+0x30>
 517:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 51b:	75 07                	jne    524 <isspace+0x37>
 51d:	b8 01 00 00 00       	mov    $0x1,%eax
 522:	eb 05                	jmp    529 <isspace+0x3c>
 524:	b8 00 00 00 00       	mov    $0x0,%eax
}
 529:	c9                   	leave  
 52a:	c3                   	ret    

0000052b <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 52b:	55                   	push   %ebp
 52c:	89 e5                	mov    %esp,%ebp
 52e:	57                   	push   %edi
 52f:	56                   	push   %esi
 530:	53                   	push   %ebx
 531:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 534:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 540:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 543:	eb 01                	jmp    546 <strtoul+0x1b>
  p += 1;
 545:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 546:	8a 03                	mov    (%ebx),%al
 548:	0f b6 c0             	movzbl %al,%eax
 54b:	89 04 24             	mov    %eax,(%esp)
 54e:	e8 9a ff ff ff       	call   4ed <isspace>
 553:	85 c0                	test   %eax,%eax
 555:	75 ee                	jne    545 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 557:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 55b:	75 30                	jne    58d <strtoul+0x62>
    {
  if (*p == '0') {
 55d:	8a 03                	mov    (%ebx),%al
 55f:	3c 30                	cmp    $0x30,%al
 561:	75 21                	jne    584 <strtoul+0x59>
      p += 1;
 563:	43                   	inc    %ebx
      if (*p == 'x') {
 564:	8a 03                	mov    (%ebx),%al
 566:	3c 78                	cmp    $0x78,%al
 568:	75 0a                	jne    574 <strtoul+0x49>
    p += 1;
 56a:	43                   	inc    %ebx
    base = 16;
 56b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 572:	eb 31                	jmp    5a5 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 574:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 57b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 582:	eb 21                	jmp    5a5 <strtoul+0x7a>
      }
  }
  else base = 10;
 584:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 58b:	eb 18                	jmp    5a5 <strtoul+0x7a>
    } else if (base == 16) {
 58d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 591:	75 12                	jne    5a5 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 593:	8a 03                	mov    (%ebx),%al
 595:	3c 30                	cmp    $0x30,%al
 597:	75 0c                	jne    5a5 <strtoul+0x7a>
 599:	8d 43 01             	lea    0x1(%ebx),%eax
 59c:	8a 00                	mov    (%eax),%al
 59e:	3c 78                	cmp    $0x78,%al
 5a0:	75 03                	jne    5a5 <strtoul+0x7a>
      p += 2;
 5a2:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 5a5:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 5a9:	75 29                	jne    5d4 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5ab:	8a 03                	mov    (%ebx),%al
 5ad:	0f be c0             	movsbl %al,%eax
 5b0:	83 e8 30             	sub    $0x30,%eax
 5b3:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 5b5:	83 fe 07             	cmp    $0x7,%esi
 5b8:	76 06                	jbe    5c0 <strtoul+0x95>
    break;
 5ba:	90                   	nop
 5bb:	e9 b6 00 00 00       	jmp    676 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 5c0:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 5c7:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5ca:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 5d1:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 5d2:	eb d7                	jmp    5ab <strtoul+0x80>
    } else if (base == 10) {
 5d4:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 5d8:	75 2b                	jne    605 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5da:	8a 03                	mov    (%ebx),%al
 5dc:	0f be c0             	movsbl %al,%eax
 5df:	83 e8 30             	sub    $0x30,%eax
 5e2:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5e4:	83 fe 09             	cmp    $0x9,%esi
 5e7:	76 06                	jbe    5ef <strtoul+0xc4>
    break;
 5e9:	90                   	nop
 5ea:	e9 87 00 00 00       	jmp    676 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5ef:	89 f8                	mov    %edi,%eax
 5f1:	c1 e0 02             	shl    $0x2,%eax
 5f4:	01 f8                	add    %edi,%eax
 5f6:	01 c0                	add    %eax,%eax
 5f8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5fb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 602:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 603:	eb d5                	jmp    5da <strtoul+0xaf>
    } else if (base == 16) {
 605:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 609:	75 35                	jne    640 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 60b:	8a 03                	mov    (%ebx),%al
 60d:	0f be c0             	movsbl %al,%eax
 610:	83 e8 30             	sub    $0x30,%eax
 613:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 615:	83 fe 4a             	cmp    $0x4a,%esi
 618:	76 02                	jbe    61c <strtoul+0xf1>
    break;
 61a:	eb 22                	jmp    63e <strtoul+0x113>
      }
      digit = cvtIn[digit];
 61c:	8a 86 c0 11 00 00    	mov    0x11c0(%esi),%al
 622:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 625:	83 fe 0f             	cmp    $0xf,%esi
 628:	76 02                	jbe    62c <strtoul+0x101>
    break;
 62a:	eb 12                	jmp    63e <strtoul+0x113>
      }
      result = (result << 4) + digit;
 62c:	89 f8                	mov    %edi,%eax
 62e:	c1 e0 04             	shl    $0x4,%eax
 631:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 634:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 63b:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 63c:	eb cd                	jmp    60b <strtoul+0xe0>
 63e:	eb 36                	jmp    676 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 640:	8a 03                	mov    (%ebx),%al
 642:	0f be c0             	movsbl %al,%eax
 645:	83 e8 30             	sub    $0x30,%eax
 648:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 64a:	83 fe 4a             	cmp    $0x4a,%esi
 64d:	76 02                	jbe    651 <strtoul+0x126>
    break;
 64f:	eb 25                	jmp    676 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 651:	8a 86 c0 11 00 00    	mov    0x11c0(%esi),%al
 657:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 65a:	8b 45 10             	mov    0x10(%ebp),%eax
 65d:	39 f0                	cmp    %esi,%eax
 65f:	77 02                	ja     663 <strtoul+0x138>
    break;
 661:	eb 13                	jmp    676 <strtoul+0x14b>
      }
      result = result*base + digit;
 663:	8b 45 10             	mov    0x10(%ebp),%eax
 666:	0f af c7             	imul   %edi,%eax
 669:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 66c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 673:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 674:	eb ca                	jmp    640 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 676:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 67a:	75 03                	jne    67f <strtoul+0x154>
  p = string;
 67c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 67f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 683:	74 05                	je     68a <strtoul+0x15f>
  *endPtr = p;
 685:	8b 45 0c             	mov    0xc(%ebp),%eax
 688:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 68a:	89 f8                	mov    %edi,%eax
}
 68c:	83 c4 14             	add    $0x14,%esp
 68f:	5b                   	pop    %ebx
 690:	5e                   	pop    %esi
 691:	5f                   	pop    %edi
 692:	5d                   	pop    %ebp
 693:	c3                   	ret    

00000694 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	53                   	push   %ebx
 698:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 69b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 69e:	eb 01                	jmp    6a1 <strtol+0xd>
      p += 1;
 6a0:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 6a1:	8a 03                	mov    (%ebx),%al
 6a3:	0f b6 c0             	movzbl %al,%eax
 6a6:	89 04 24             	mov    %eax,(%esp)
 6a9:	e8 3f fe ff ff       	call   4ed <isspace>
 6ae:	85 c0                	test   %eax,%eax
 6b0:	75 ee                	jne    6a0 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 6b2:	8a 03                	mov    (%ebx),%al
 6b4:	3c 2d                	cmp    $0x2d,%al
 6b6:	75 1e                	jne    6d6 <strtol+0x42>
  p += 1;
 6b8:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 6b9:	8b 45 10             	mov    0x10(%ebp),%eax
 6bc:	89 44 24 08          	mov    %eax,0x8(%esp)
 6c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c7:	89 1c 24             	mov    %ebx,(%esp)
 6ca:	e8 5c fe ff ff       	call   52b <strtoul>
 6cf:	f7 d8                	neg    %eax
 6d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6d4:	eb 20                	jmp    6f6 <strtol+0x62>
    } else {
  if (*p == '+') {
 6d6:	8a 03                	mov    (%ebx),%al
 6d8:	3c 2b                	cmp    $0x2b,%al
 6da:	75 01                	jne    6dd <strtol+0x49>
      p += 1;
 6dc:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6dd:	8b 45 10             	mov    0x10(%ebp),%eax
 6e0:	89 44 24 08          	mov    %eax,0x8(%esp)
 6e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6eb:	89 1c 24             	mov    %ebx,(%esp)
 6ee:	e8 38 fe ff ff       	call   52b <strtoul>
 6f3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6f6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6fa:	75 17                	jne    713 <strtol+0x7f>
 6fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 700:	74 11                	je     713 <strtol+0x7f>
 702:	8b 45 0c             	mov    0xc(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	39 d8                	cmp    %ebx,%eax
 709:	75 08                	jne    713 <strtol+0x7f>
  *endPtr = string;
 70b:	8b 45 0c             	mov    0xc(%ebp),%eax
 70e:	8b 55 08             	mov    0x8(%ebp),%edx
 711:	89 10                	mov    %edx,(%eax)
    }
    return result;
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 716:	83 c4 1c             	add    $0x1c,%esp
 719:	5b                   	pop    %ebx
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret    

0000071c <gets>:

char*
gets(char *buf, int max)
{
 71c:	55                   	push   %ebp
 71d:	89 e5                	mov    %esp,%ebp
 71f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 722:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 729:	eb 49                	jmp    774 <gets+0x58>
    cc = read(0, &c, 1);
 72b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 732:	00 
 733:	8d 45 ef             	lea    -0x11(%ebp),%eax
 736:	89 44 24 04          	mov    %eax,0x4(%esp)
 73a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 741:	e8 3e 01 00 00       	call   884 <read>
 746:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 74d:	7f 02                	jg     751 <gets+0x35>
      break;
 74f:	eb 2c                	jmp    77d <gets+0x61>
    buf[i++] = c;
 751:	8b 45 f4             	mov    -0xc(%ebp),%eax
 754:	8d 50 01             	lea    0x1(%eax),%edx
 757:	89 55 f4             	mov    %edx,-0xc(%ebp)
 75a:	89 c2                	mov    %eax,%edx
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
 75f:	01 c2                	add    %eax,%edx
 761:	8a 45 ef             	mov    -0x11(%ebp),%al
 764:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 766:	8a 45 ef             	mov    -0x11(%ebp),%al
 769:	3c 0a                	cmp    $0xa,%al
 76b:	74 10                	je     77d <gets+0x61>
 76d:	8a 45 ef             	mov    -0x11(%ebp),%al
 770:	3c 0d                	cmp    $0xd,%al
 772:	74 09                	je     77d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 774:	8b 45 f4             	mov    -0xc(%ebp),%eax
 777:	40                   	inc    %eax
 778:	3b 45 0c             	cmp    0xc(%ebp),%eax
 77b:	7c ae                	jl     72b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 77d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 780:	8b 45 08             	mov    0x8(%ebp),%eax
 783:	01 d0                	add    %edx,%eax
 785:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 788:	8b 45 08             	mov    0x8(%ebp),%eax
}
 78b:	c9                   	leave  
 78c:	c3                   	ret    

0000078d <stat>:

int
stat(char *n, struct stat *st)
{
 78d:	55                   	push   %ebp
 78e:	89 e5                	mov    %esp,%ebp
 790:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 793:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 79a:	00 
 79b:	8b 45 08             	mov    0x8(%ebp),%eax
 79e:	89 04 24             	mov    %eax,(%esp)
 7a1:	e8 06 01 00 00       	call   8ac <open>
 7a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ad:	79 07                	jns    7b6 <stat+0x29>
    return -1;
 7af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7b4:	eb 23                	jmp    7d9 <stat+0x4c>
  r = fstat(fd, st);
 7b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	89 04 24             	mov    %eax,(%esp)
 7c3:	e8 fc 00 00 00       	call   8c4 <fstat>
 7c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	89 04 24             	mov    %eax,(%esp)
 7d1:	e8 be 00 00 00       	call   894 <close>
  return r;
 7d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7d9:	c9                   	leave  
 7da:	c3                   	ret    

000007db <atoi>:

int
atoi(const char *s)
{
 7db:	55                   	push   %ebp
 7dc:	89 e5                	mov    %esp,%ebp
 7de:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7e1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7e8:	eb 24                	jmp    80e <atoi+0x33>
    n = n*10 + *s++ - '0';
 7ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7ed:	89 d0                	mov    %edx,%eax
 7ef:	c1 e0 02             	shl    $0x2,%eax
 7f2:	01 d0                	add    %edx,%eax
 7f4:	01 c0                	add    %eax,%eax
 7f6:	89 c1                	mov    %eax,%ecx
 7f8:	8b 45 08             	mov    0x8(%ebp),%eax
 7fb:	8d 50 01             	lea    0x1(%eax),%edx
 7fe:	89 55 08             	mov    %edx,0x8(%ebp)
 801:	8a 00                	mov    (%eax),%al
 803:	0f be c0             	movsbl %al,%eax
 806:	01 c8                	add    %ecx,%eax
 808:	83 e8 30             	sub    $0x30,%eax
 80b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 80e:	8b 45 08             	mov    0x8(%ebp),%eax
 811:	8a 00                	mov    (%eax),%al
 813:	3c 2f                	cmp    $0x2f,%al
 815:	7e 09                	jle    820 <atoi+0x45>
 817:	8b 45 08             	mov    0x8(%ebp),%eax
 81a:	8a 00                	mov    (%eax),%al
 81c:	3c 39                	cmp    $0x39,%al
 81e:	7e ca                	jle    7ea <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 820:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 823:	c9                   	leave  
 824:	c3                   	ret    

00000825 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 825:	55                   	push   %ebp
 826:	89 e5                	mov    %esp,%ebp
 828:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 831:	8b 45 0c             	mov    0xc(%ebp),%eax
 834:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 837:	eb 16                	jmp    84f <memmove+0x2a>
    *dst++ = *src++;
 839:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83c:	8d 50 01             	lea    0x1(%eax),%edx
 83f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 842:	8b 55 f8             	mov    -0x8(%ebp),%edx
 845:	8d 4a 01             	lea    0x1(%edx),%ecx
 848:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 84b:	8a 12                	mov    (%edx),%dl
 84d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 84f:	8b 45 10             	mov    0x10(%ebp),%eax
 852:	8d 50 ff             	lea    -0x1(%eax),%edx
 855:	89 55 10             	mov    %edx,0x10(%ebp)
 858:	85 c0                	test   %eax,%eax
 85a:	7f dd                	jg     839 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 85c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 85f:	c9                   	leave  
 860:	c3                   	ret    
 861:	90                   	nop
 862:	90                   	nop
 863:	90                   	nop

00000864 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 864:	b8 01 00 00 00       	mov    $0x1,%eax
 869:	cd 40                	int    $0x40
 86b:	c3                   	ret    

0000086c <exit>:
SYSCALL(exit)
 86c:	b8 02 00 00 00       	mov    $0x2,%eax
 871:	cd 40                	int    $0x40
 873:	c3                   	ret    

00000874 <wait>:
SYSCALL(wait)
 874:	b8 03 00 00 00       	mov    $0x3,%eax
 879:	cd 40                	int    $0x40
 87b:	c3                   	ret    

0000087c <pipe>:
SYSCALL(pipe)
 87c:	b8 04 00 00 00       	mov    $0x4,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <read>:
SYSCALL(read)
 884:	b8 05 00 00 00       	mov    $0x5,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <write>:
SYSCALL(write)
 88c:	b8 10 00 00 00       	mov    $0x10,%eax
 891:	cd 40                	int    $0x40
 893:	c3                   	ret    

00000894 <close>:
SYSCALL(close)
 894:	b8 15 00 00 00       	mov    $0x15,%eax
 899:	cd 40                	int    $0x40
 89b:	c3                   	ret    

0000089c <kill>:
SYSCALL(kill)
 89c:	b8 06 00 00 00       	mov    $0x6,%eax
 8a1:	cd 40                	int    $0x40
 8a3:	c3                   	ret    

000008a4 <exec>:
SYSCALL(exec)
 8a4:	b8 07 00 00 00       	mov    $0x7,%eax
 8a9:	cd 40                	int    $0x40
 8ab:	c3                   	ret    

000008ac <open>:
SYSCALL(open)
 8ac:	b8 0f 00 00 00       	mov    $0xf,%eax
 8b1:	cd 40                	int    $0x40
 8b3:	c3                   	ret    

000008b4 <mknod>:
SYSCALL(mknod)
 8b4:	b8 11 00 00 00       	mov    $0x11,%eax
 8b9:	cd 40                	int    $0x40
 8bb:	c3                   	ret    

000008bc <unlink>:
SYSCALL(unlink)
 8bc:	b8 12 00 00 00       	mov    $0x12,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <fstat>:
SYSCALL(fstat)
 8c4:	b8 08 00 00 00       	mov    $0x8,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <link>:
SYSCALL(link)
 8cc:	b8 13 00 00 00       	mov    $0x13,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <mkdir>:
SYSCALL(mkdir)
 8d4:	b8 14 00 00 00       	mov    $0x14,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <chdir>:
SYSCALL(chdir)
 8dc:	b8 09 00 00 00       	mov    $0x9,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <dup>:
SYSCALL(dup)
 8e4:	b8 0a 00 00 00       	mov    $0xa,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <getpid>:
SYSCALL(getpid)
 8ec:	b8 0b 00 00 00       	mov    $0xb,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <sbrk>:
SYSCALL(sbrk)
 8f4:	b8 0c 00 00 00       	mov    $0xc,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <sleep>:
SYSCALL(sleep)
 8fc:	b8 0d 00 00 00       	mov    $0xd,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <uptime>:
SYSCALL(uptime)
 904:	b8 0e 00 00 00       	mov    $0xe,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 90c:	55                   	push   %ebp
 90d:	89 e5                	mov    %esp,%ebp
 90f:	83 ec 18             	sub    $0x18,%esp
 912:	8b 45 0c             	mov    0xc(%ebp),%eax
 915:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 918:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 91f:	00 
 920:	8d 45 f4             	lea    -0xc(%ebp),%eax
 923:	89 44 24 04          	mov    %eax,0x4(%esp)
 927:	8b 45 08             	mov    0x8(%ebp),%eax
 92a:	89 04 24             	mov    %eax,(%esp)
 92d:	e8 5a ff ff ff       	call   88c <write>
}
 932:	c9                   	leave  
 933:	c3                   	ret    

00000934 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 934:	55                   	push   %ebp
 935:	89 e5                	mov    %esp,%ebp
 937:	56                   	push   %esi
 938:	53                   	push   %ebx
 939:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 93c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 943:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 947:	74 17                	je     960 <printint+0x2c>
 949:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 94d:	79 11                	jns    960 <printint+0x2c>
    neg = 1;
 94f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 956:	8b 45 0c             	mov    0xc(%ebp),%eax
 959:	f7 d8                	neg    %eax
 95b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 95e:	eb 06                	jmp    966 <printint+0x32>
  } else {
    x = xx;
 960:	8b 45 0c             	mov    0xc(%ebp),%eax
 963:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 966:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 96d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 970:	8d 41 01             	lea    0x1(%ecx),%eax
 973:	89 45 f4             	mov    %eax,-0xc(%ebp)
 976:	8b 5d 10             	mov    0x10(%ebp),%ebx
 979:	8b 45 ec             	mov    -0x14(%ebp),%eax
 97c:	ba 00 00 00 00       	mov    $0x0,%edx
 981:	f7 f3                	div    %ebx
 983:	89 d0                	mov    %edx,%eax
 985:	8a 80 0c 12 00 00    	mov    0x120c(%eax),%al
 98b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 98f:	8b 75 10             	mov    0x10(%ebp),%esi
 992:	8b 45 ec             	mov    -0x14(%ebp),%eax
 995:	ba 00 00 00 00       	mov    $0x0,%edx
 99a:	f7 f6                	div    %esi
 99c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 99f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9a3:	75 c8                	jne    96d <printint+0x39>
  if(neg)
 9a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9a9:	74 10                	je     9bb <printint+0x87>
    buf[i++] = '-';
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	8d 50 01             	lea    0x1(%eax),%edx
 9b1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9b4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9b9:	eb 1e                	jmp    9d9 <printint+0xa5>
 9bb:	eb 1c                	jmp    9d9 <printint+0xa5>
    putc(fd, buf[i]);
 9bd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c3:	01 d0                	add    %edx,%eax
 9c5:	8a 00                	mov    (%eax),%al
 9c7:	0f be c0             	movsbl %al,%eax
 9ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ce:	8b 45 08             	mov    0x8(%ebp),%eax
 9d1:	89 04 24             	mov    %eax,(%esp)
 9d4:	e8 33 ff ff ff       	call   90c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9d9:	ff 4d f4             	decl   -0xc(%ebp)
 9dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9e0:	79 db                	jns    9bd <printint+0x89>
    putc(fd, buf[i]);
}
 9e2:	83 c4 30             	add    $0x30,%esp
 9e5:	5b                   	pop    %ebx
 9e6:	5e                   	pop    %esi
 9e7:	5d                   	pop    %ebp
 9e8:	c3                   	ret    

000009e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9e9:	55                   	push   %ebp
 9ea:	89 e5                	mov    %esp,%ebp
 9ec:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9ef:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9f6:	8d 45 0c             	lea    0xc(%ebp),%eax
 9f9:	83 c0 04             	add    $0x4,%eax
 9fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9ff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a06:	e9 77 01 00 00       	jmp    b82 <printf+0x199>
    c = fmt[i] & 0xff;
 a0b:	8b 55 0c             	mov    0xc(%ebp),%edx
 a0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a11:	01 d0                	add    %edx,%eax
 a13:	8a 00                	mov    (%eax),%al
 a15:	0f be c0             	movsbl %al,%eax
 a18:	25 ff 00 00 00       	and    $0xff,%eax
 a1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a20:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a24:	75 2c                	jne    a52 <printf+0x69>
      if(c == '%'){
 a26:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a2a:	75 0c                	jne    a38 <printf+0x4f>
        state = '%';
 a2c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a33:	e9 47 01 00 00       	jmp    b7f <printf+0x196>
      } else {
        putc(fd, c);
 a38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a3b:	0f be c0             	movsbl %al,%eax
 a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a42:	8b 45 08             	mov    0x8(%ebp),%eax
 a45:	89 04 24             	mov    %eax,(%esp)
 a48:	e8 bf fe ff ff       	call   90c <putc>
 a4d:	e9 2d 01 00 00       	jmp    b7f <printf+0x196>
      }
    } else if(state == '%'){
 a52:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a56:	0f 85 23 01 00 00    	jne    b7f <printf+0x196>
      if(c == 'd'){
 a5c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a60:	75 2d                	jne    a8f <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a62:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a65:	8b 00                	mov    (%eax),%eax
 a67:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a6e:	00 
 a6f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a76:	00 
 a77:	89 44 24 04          	mov    %eax,0x4(%esp)
 a7b:	8b 45 08             	mov    0x8(%ebp),%eax
 a7e:	89 04 24             	mov    %eax,(%esp)
 a81:	e8 ae fe ff ff       	call   934 <printint>
        ap++;
 a86:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a8a:	e9 e9 00 00 00       	jmp    b78 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a8f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a93:	74 06                	je     a9b <printf+0xb2>
 a95:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a99:	75 2d                	jne    ac8 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a9e:	8b 00                	mov    (%eax),%eax
 aa0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 aa7:	00 
 aa8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 aaf:	00 
 ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab4:	8b 45 08             	mov    0x8(%ebp),%eax
 ab7:	89 04 24             	mov    %eax,(%esp)
 aba:	e8 75 fe ff ff       	call   934 <printint>
        ap++;
 abf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ac3:	e9 b0 00 00 00       	jmp    b78 <printf+0x18f>
      } else if(c == 's'){
 ac8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 acc:	75 42                	jne    b10 <printf+0x127>
        s = (char*)*ap;
 ace:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ad1:	8b 00                	mov    (%eax),%eax
 ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 ad6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 ada:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ade:	75 09                	jne    ae9 <printf+0x100>
          s = "(null)";
 ae0:	c7 45 f4 28 0e 00 00 	movl   $0xe28,-0xc(%ebp)
        while(*s != 0){
 ae7:	eb 1c                	jmp    b05 <printf+0x11c>
 ae9:	eb 1a                	jmp    b05 <printf+0x11c>
          putc(fd, *s);
 aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aee:	8a 00                	mov    (%eax),%al
 af0:	0f be c0             	movsbl %al,%eax
 af3:	89 44 24 04          	mov    %eax,0x4(%esp)
 af7:	8b 45 08             	mov    0x8(%ebp),%eax
 afa:	89 04 24             	mov    %eax,(%esp)
 afd:	e8 0a fe ff ff       	call   90c <putc>
          s++;
 b02:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b08:	8a 00                	mov    (%eax),%al
 b0a:	84 c0                	test   %al,%al
 b0c:	75 dd                	jne    aeb <printf+0x102>
 b0e:	eb 68                	jmp    b78 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b10:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b14:	75 1d                	jne    b33 <printf+0x14a>
        putc(fd, *ap);
 b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b19:	8b 00                	mov    (%eax),%eax
 b1b:	0f be c0             	movsbl %al,%eax
 b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
 b22:	8b 45 08             	mov    0x8(%ebp),%eax
 b25:	89 04 24             	mov    %eax,(%esp)
 b28:	e8 df fd ff ff       	call   90c <putc>
        ap++;
 b2d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b31:	eb 45                	jmp    b78 <printf+0x18f>
      } else if(c == '%'){
 b33:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b37:	75 17                	jne    b50 <printf+0x167>
        putc(fd, c);
 b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b3c:	0f be c0             	movsbl %al,%eax
 b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
 b43:	8b 45 08             	mov    0x8(%ebp),%eax
 b46:	89 04 24             	mov    %eax,(%esp)
 b49:	e8 be fd ff ff       	call   90c <putc>
 b4e:	eb 28                	jmp    b78 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b50:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b57:	00 
 b58:	8b 45 08             	mov    0x8(%ebp),%eax
 b5b:	89 04 24             	mov    %eax,(%esp)
 b5e:	e8 a9 fd ff ff       	call   90c <putc>
        putc(fd, c);
 b63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b66:	0f be c0             	movsbl %al,%eax
 b69:	89 44 24 04          	mov    %eax,0x4(%esp)
 b6d:	8b 45 08             	mov    0x8(%ebp),%eax
 b70:	89 04 24             	mov    %eax,(%esp)
 b73:	e8 94 fd ff ff       	call   90c <putc>
      }
      state = 0;
 b78:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b7f:	ff 45 f0             	incl   -0x10(%ebp)
 b82:	8b 55 0c             	mov    0xc(%ebp),%edx
 b85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b88:	01 d0                	add    %edx,%eax
 b8a:	8a 00                	mov    (%eax),%al
 b8c:	84 c0                	test   %al,%al
 b8e:	0f 85 77 fe ff ff    	jne    a0b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b94:	c9                   	leave  
 b95:	c3                   	ret    
 b96:	90                   	nop
 b97:	90                   	nop

00000b98 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b98:	55                   	push   %ebp
 b99:	89 e5                	mov    %esp,%ebp
 b9b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b9e:	8b 45 08             	mov    0x8(%ebp),%eax
 ba1:	83 e8 08             	sub    $0x8,%eax
 ba4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ba7:	a1 30 12 00 00       	mov    0x1230,%eax
 bac:	89 45 fc             	mov    %eax,-0x4(%ebp)
 baf:	eb 24                	jmp    bd5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb4:	8b 00                	mov    (%eax),%eax
 bb6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bb9:	77 12                	ja     bcd <free+0x35>
 bbb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bc1:	77 24                	ja     be7 <free+0x4f>
 bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc6:	8b 00                	mov    (%eax),%eax
 bc8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bcb:	77 1a                	ja     be7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd0:	8b 00                	mov    (%eax),%eax
 bd2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bd5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bdb:	76 d4                	jbe    bb1 <free+0x19>
 bdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be0:	8b 00                	mov    (%eax),%eax
 be2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 be5:	76 ca                	jbe    bb1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 be7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bea:	8b 40 04             	mov    0x4(%eax),%eax
 bed:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bf4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf7:	01 c2                	add    %eax,%edx
 bf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bfc:	8b 00                	mov    (%eax),%eax
 bfe:	39 c2                	cmp    %eax,%edx
 c00:	75 24                	jne    c26 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c02:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c05:	8b 50 04             	mov    0x4(%eax),%edx
 c08:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0b:	8b 00                	mov    (%eax),%eax
 c0d:	8b 40 04             	mov    0x4(%eax),%eax
 c10:	01 c2                	add    %eax,%edx
 c12:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c15:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1b:	8b 00                	mov    (%eax),%eax
 c1d:	8b 10                	mov    (%eax),%edx
 c1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c22:	89 10                	mov    %edx,(%eax)
 c24:	eb 0a                	jmp    c30 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c26:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c29:	8b 10                	mov    (%eax),%edx
 c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c33:	8b 40 04             	mov    0x4(%eax),%eax
 c36:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c40:	01 d0                	add    %edx,%eax
 c42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c45:	75 20                	jne    c67 <free+0xcf>
    p->s.size += bp->s.size;
 c47:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c4a:	8b 50 04             	mov    0x4(%eax),%edx
 c4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c50:	8b 40 04             	mov    0x4(%eax),%eax
 c53:	01 c2                	add    %eax,%edx
 c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c58:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c5e:	8b 10                	mov    (%eax),%edx
 c60:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c63:	89 10                	mov    %edx,(%eax)
 c65:	eb 08                	jmp    c6f <free+0xd7>
  } else
    p->s.ptr = bp;
 c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c6d:	89 10                	mov    %edx,(%eax)
  freep = p;
 c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c72:	a3 30 12 00 00       	mov    %eax,0x1230
}
 c77:	c9                   	leave  
 c78:	c3                   	ret    

00000c79 <morecore>:

static Header*
morecore(uint nu)
{
 c79:	55                   	push   %ebp
 c7a:	89 e5                	mov    %esp,%ebp
 c7c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c7f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c86:	77 07                	ja     c8f <morecore+0x16>
    nu = 4096;
 c88:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c8f:	8b 45 08             	mov    0x8(%ebp),%eax
 c92:	c1 e0 03             	shl    $0x3,%eax
 c95:	89 04 24             	mov    %eax,(%esp)
 c98:	e8 57 fc ff ff       	call   8f4 <sbrk>
 c9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ca0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ca4:	75 07                	jne    cad <morecore+0x34>
    return 0;
 ca6:	b8 00 00 00 00       	mov    $0x0,%eax
 cab:	eb 22                	jmp    ccf <morecore+0x56>
  hp = (Header*)p;
 cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb6:	8b 55 08             	mov    0x8(%ebp),%edx
 cb9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cbf:	83 c0 08             	add    $0x8,%eax
 cc2:	89 04 24             	mov    %eax,(%esp)
 cc5:	e8 ce fe ff ff       	call   b98 <free>
  return freep;
 cca:	a1 30 12 00 00       	mov    0x1230,%eax
}
 ccf:	c9                   	leave  
 cd0:	c3                   	ret    

00000cd1 <malloc>:

void*
malloc(uint nbytes)
{
 cd1:	55                   	push   %ebp
 cd2:	89 e5                	mov    %esp,%ebp
 cd4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cd7:	8b 45 08             	mov    0x8(%ebp),%eax
 cda:	83 c0 07             	add    $0x7,%eax
 cdd:	c1 e8 03             	shr    $0x3,%eax
 ce0:	40                   	inc    %eax
 ce1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ce4:	a1 30 12 00 00       	mov    0x1230,%eax
 ce9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cf0:	75 23                	jne    d15 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 cf2:	c7 45 f0 28 12 00 00 	movl   $0x1228,-0x10(%ebp)
 cf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cfc:	a3 30 12 00 00       	mov    %eax,0x1230
 d01:	a1 30 12 00 00       	mov    0x1230,%eax
 d06:	a3 28 12 00 00       	mov    %eax,0x1228
    base.s.size = 0;
 d0b:	c7 05 2c 12 00 00 00 	movl   $0x0,0x122c
 d12:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d18:	8b 00                	mov    (%eax),%eax
 d1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d20:	8b 40 04             	mov    0x4(%eax),%eax
 d23:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d26:	72 4d                	jb     d75 <malloc+0xa4>
      if(p->s.size == nunits)
 d28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2b:	8b 40 04             	mov    0x4(%eax),%eax
 d2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d31:	75 0c                	jne    d3f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d36:	8b 10                	mov    (%eax),%edx
 d38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d3b:	89 10                	mov    %edx,(%eax)
 d3d:	eb 26                	jmp    d65 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d42:	8b 40 04             	mov    0x4(%eax),%eax
 d45:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d48:	89 c2                	mov    %eax,%edx
 d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d53:	8b 40 04             	mov    0x4(%eax),%eax
 d56:	c1 e0 03             	shl    $0x3,%eax
 d59:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d62:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d68:	a3 30 12 00 00       	mov    %eax,0x1230
      return (void*)(p + 1);
 d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d70:	83 c0 08             	add    $0x8,%eax
 d73:	eb 38                	jmp    dad <malloc+0xdc>
    }
    if(p == freep)
 d75:	a1 30 12 00 00       	mov    0x1230,%eax
 d7a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d7d:	75 1b                	jne    d9a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d82:	89 04 24             	mov    %eax,(%esp)
 d85:	e8 ef fe ff ff       	call   c79 <morecore>
 d8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d91:	75 07                	jne    d9a <malloc+0xc9>
        return 0;
 d93:	b8 00 00 00 00       	mov    $0x0,%eax
 d98:	eb 13                	jmp    dad <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da3:	8b 00                	mov    (%eax),%eax
 da5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 da8:	e9 70 ff ff ff       	jmp    d1d <malloc+0x4c>
}
 dad:	c9                   	leave  
 dae:	c3                   	ret    
