
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
   f:	c7 44 24 04 bb 0d 00 	movl   $0xdbb,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 d2 09 00 00       	call   9f5 <printf>
    exit();
  23:	e8 f0 07 00 00       	call   818 <exit>
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
  47:	e8 3b 07 00 00       	call   787 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 f4 07 00 00       	call   848 <kill>

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
  61:	e8 b2 07 00 00       	call   818 <exit>
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
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

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

000000bb <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  be:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
  c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
  c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  cf:	00 
  d0:	8b 45 08             	mov    0x8(%ebp),%eax
  d3:	89 04 24             	mov    %eax,(%esp)
  d6:	e8 7d 07 00 00       	call   858 <open>
  db:	89 45 f0             	mov    %eax,-0x10(%ebp)
  de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  e2:	79 20                	jns    104 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	c7 44 24 04 cf 0d 00 	movl   $0xdcf,0x4(%esp)
  f2:	00 
  f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fa:	e8 f6 08 00 00       	call   9f5 <printf>
      exit();
  ff:	e8 14 07 00 00       	call   818 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 104:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 10b:	00 
 10c:	8b 45 0c             	mov    0xc(%ebp),%eax
 10f:	89 04 24             	mov    %eax,(%esp)
 112:	e8 41 07 00 00       	call   858 <open>
 117:	89 45 ec             	mov    %eax,-0x14(%ebp)
 11a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 11e:	79 20                	jns    140 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	89 44 24 08          	mov    %eax,0x8(%esp)
 127:	c7 44 24 04 ea 0d 00 	movl   $0xdea,0x4(%esp)
 12e:	00 
 12f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 136:	e8 ba 08 00 00       	call   9f5 <printf>
      exit();
 13b:	e8 d8 06 00 00       	call   818 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 140:	eb 3b                	jmp    17d <copy+0xc2>
  {
      max = used_disk+=count;
 142:	8b 45 e8             	mov    -0x18(%ebp),%eax
 145:	01 45 10             	add    %eax,0x10(%ebp)
 148:	8b 45 10             	mov    0x10(%ebp),%eax
 14b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 14e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 151:	3b 45 14             	cmp    0x14(%ebp),%eax
 154:	7e 07                	jle    15d <copy+0xa2>
      {
        return -1;
 156:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 15b:	eb 5c                	jmp    1b9 <copy+0xfe>
      }
      bytes = bytes + count;
 15d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 160:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 163:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 16a:	00 
 16b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 16e:	89 44 24 04          	mov    %eax,0x4(%esp)
 172:	8b 45 ec             	mov    -0x14(%ebp),%eax
 175:	89 04 24             	mov    %eax,(%esp)
 178:	e8 bb 06 00 00       	call   838 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 17d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 184:	00 
 185:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 188:	89 44 24 04          	mov    %eax,0x4(%esp)
 18c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 18f:	89 04 24             	mov    %eax,(%esp)
 192:	e8 99 06 00 00       	call   830 <read>
 197:	89 45 e8             	mov    %eax,-0x18(%ebp)
 19a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 19e:	7f a2                	jg     142 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 1a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 95 06 00 00       	call   840 <close>
  close(fd2);
 1ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 8a 06 00 00       	call   840 <close>
  return(bytes);
 1b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1b9:	c9                   	leave  
 1ba:	c3                   	ret    

000001bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1bb:	55                   	push   %ebp
 1bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1be:	eb 06                	jmp    1c6 <strcmp+0xb>
    p++, q++;
 1c0:	ff 45 08             	incl   0x8(%ebp)
 1c3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	8a 00                	mov    (%eax),%al
 1cb:	84 c0                	test   %al,%al
 1cd:	74 0e                	je     1dd <strcmp+0x22>
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	8a 10                	mov    (%eax),%dl
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	8a 00                	mov    (%eax),%al
 1d9:	38 c2                	cmp    %al,%dl
 1db:	74 e3                	je     1c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
 1e0:	8a 00                	mov    (%eax),%al
 1e2:	0f b6 d0             	movzbl %al,%edx
 1e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e8:	8a 00                	mov    (%eax),%al
 1ea:	0f b6 c0             	movzbl %al,%eax
 1ed:	29 c2                	sub    %eax,%edx
 1ef:	89 d0                	mov    %edx,%eax
}
 1f1:	5d                   	pop    %ebp
 1f2:	c3                   	ret    

000001f3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 1f6:	eb 09                	jmp    201 <strncmp+0xe>
    n--, p++, q++;
 1f8:	ff 4d 10             	decl   0x10(%ebp)
 1fb:	ff 45 08             	incl   0x8(%ebp)
 1fe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 201:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 205:	74 17                	je     21e <strncmp+0x2b>
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	8a 00                	mov    (%eax),%al
 20c:	84 c0                	test   %al,%al
 20e:	74 0e                	je     21e <strncmp+0x2b>
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8a 10                	mov    (%eax),%dl
 215:	8b 45 0c             	mov    0xc(%ebp),%eax
 218:	8a 00                	mov    (%eax),%al
 21a:	38 c2                	cmp    %al,%dl
 21c:	74 da                	je     1f8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 21e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 222:	75 07                	jne    22b <strncmp+0x38>
    return 0;
 224:	b8 00 00 00 00       	mov    $0x0,%eax
 229:	eb 14                	jmp    23f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	8a 00                	mov    (%eax),%al
 230:	0f b6 d0             	movzbl %al,%edx
 233:	8b 45 0c             	mov    0xc(%ebp),%eax
 236:	8a 00                	mov    (%eax),%al
 238:	0f b6 c0             	movzbl %al,%eax
 23b:	29 c2                	sub    %eax,%edx
 23d:	89 d0                	mov    %edx,%eax
}
 23f:	5d                   	pop    %ebp
 240:	c3                   	ret    

00000241 <strlen>:

uint
strlen(const char *s)
{
 241:	55                   	push   %ebp
 242:	89 e5                	mov    %esp,%ebp
 244:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 247:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 24e:	eb 03                	jmp    253 <strlen+0x12>
 250:	ff 45 fc             	incl   -0x4(%ebp)
 253:	8b 55 fc             	mov    -0x4(%ebp),%edx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	01 d0                	add    %edx,%eax
 25b:	8a 00                	mov    (%eax),%al
 25d:	84 c0                	test   %al,%al
 25f:	75 ef                	jne    250 <strlen+0xf>
    ;
  return n;
 261:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <memset>:

void*
memset(void *dst, int c, uint n)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 26c:	8b 45 10             	mov    0x10(%ebp),%eax
 26f:	89 44 24 08          	mov    %eax,0x8(%esp)
 273:	8b 45 0c             	mov    0xc(%ebp),%eax
 276:	89 44 24 04          	mov    %eax,0x4(%esp)
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	89 04 24             	mov    %eax,(%esp)
 280:	e8 e3 fd ff ff       	call   68 <stosb>
  return dst;
 285:	8b 45 08             	mov    0x8(%ebp),%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <strchr>:

char*
strchr(const char *s, char c)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 04             	sub    $0x4,%esp
 290:	8b 45 0c             	mov    0xc(%ebp),%eax
 293:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 296:	eb 12                	jmp    2aa <strchr+0x20>
    if(*s == c)
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	8a 00                	mov    (%eax),%al
 29d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a0:	75 05                	jne    2a7 <strchr+0x1d>
      return (char*)s;
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	eb 11                	jmp    2b8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2a7:	ff 45 08             	incl   0x8(%ebp)
 2aa:	8b 45 08             	mov    0x8(%ebp),%eax
 2ad:	8a 00                	mov    (%eax),%al
 2af:	84 c0                	test   %al,%al
 2b1:	75 e5                	jne    298 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <strcat>:

char *
strcat(char *dest, const char *src)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2c7:	eb 03                	jmp    2cc <strcat+0x12>
 2c9:	ff 45 fc             	incl   -0x4(%ebp)
 2cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	01 d0                	add    %edx,%eax
 2d4:	8a 00                	mov    (%eax),%al
 2d6:	84 c0                	test   %al,%al
 2d8:	75 ef                	jne    2c9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 2da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 2e1:	eb 1e                	jmp    301 <strcat+0x47>
        dest[i+j] = src[j];
 2e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e9:	01 d0                	add    %edx,%eax
 2eb:	89 c2                	mov    %eax,%edx
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	01 c2                	add    %eax,%edx
 2f2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f8:	01 c8                	add    %ecx,%eax
 2fa:	8a 00                	mov    (%eax),%al
 2fc:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 2fe:	ff 45 f8             	incl   -0x8(%ebp)
 301:	8b 55 f8             	mov    -0x8(%ebp),%edx
 304:	8b 45 0c             	mov    0xc(%ebp),%eax
 307:	01 d0                	add    %edx,%eax
 309:	8a 00                	mov    (%eax),%al
 30b:	84 c0                	test   %al,%al
 30d:	75 d4                	jne    2e3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 30f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 312:	8b 55 fc             	mov    -0x4(%ebp),%edx
 315:	01 d0                	add    %edx,%eax
 317:	89 c2                	mov    %eax,%edx
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	01 d0                	add    %edx,%eax
 31e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 321:	8b 45 08             	mov    0x8(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <strstr>:

int 
strstr(char* s, char* sub)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 32c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 333:	eb 7c                	jmp    3b1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 335:	8b 55 fc             	mov    -0x4(%ebp),%edx
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	01 d0                	add    %edx,%eax
 33d:	8a 10                	mov    (%eax),%dl
 33f:	8b 45 0c             	mov    0xc(%ebp),%eax
 342:	8a 00                	mov    (%eax),%al
 344:	38 c2                	cmp    %al,%dl
 346:	75 66                	jne    3ae <strstr+0x88>
        {
            if(strlen(sub) == 1)
 348:	8b 45 0c             	mov    0xc(%ebp),%eax
 34b:	89 04 24             	mov    %eax,(%esp)
 34e:	e8 ee fe ff ff       	call   241 <strlen>
 353:	83 f8 01             	cmp    $0x1,%eax
 356:	75 05                	jne    35d <strstr+0x37>
            {  
                return i;
 358:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35b:	eb 6b                	jmp    3c8 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 35d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 364:	eb 3a                	jmp    3a0 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 366:	8b 45 f8             	mov    -0x8(%ebp),%eax
 369:	8b 55 fc             	mov    -0x4(%ebp),%edx
 36c:	01 d0                	add    %edx,%eax
 36e:	89 c2                	mov    %eax,%edx
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	01 d0                	add    %edx,%eax
 375:	8a 10                	mov    (%eax),%dl
 377:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 37a:	8b 45 0c             	mov    0xc(%ebp),%eax
 37d:	01 c8                	add    %ecx,%eax
 37f:	8a 00                	mov    (%eax),%al
 381:	38 c2                	cmp    %al,%dl
 383:	75 16                	jne    39b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 385:	8b 45 f8             	mov    -0x8(%ebp),%eax
 388:	8d 50 01             	lea    0x1(%eax),%edx
 38b:	8b 45 0c             	mov    0xc(%ebp),%eax
 38e:	01 d0                	add    %edx,%eax
 390:	8a 00                	mov    (%eax),%al
 392:	84 c0                	test   %al,%al
 394:	75 07                	jne    39d <strstr+0x77>
                    {
                        return i;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
 399:	eb 2d                	jmp    3c8 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 39b:	eb 11                	jmp    3ae <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 39d:	ff 45 f8             	incl   -0x8(%ebp)
 3a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a6:	01 d0                	add    %edx,%eax
 3a8:	8a 00                	mov    (%eax),%al
 3aa:	84 c0                	test   %al,%al
 3ac:	75 b8                	jne    366 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3ae:	ff 45 fc             	incl   -0x4(%ebp)
 3b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b4:	8b 45 08             	mov    0x8(%ebp),%eax
 3b7:	01 d0                	add    %edx,%eax
 3b9:	8a 00                	mov    (%eax),%al
 3bb:	84 c0                	test   %al,%al
 3bd:	0f 85 72 ff ff ff    	jne    335 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 3c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3c8:	c9                   	leave  
 3c9:	c3                   	ret    

000003ca <strtok>:

char *
strtok(char *s, const char *delim)
{
 3ca:	55                   	push   %ebp
 3cb:	89 e5                	mov    %esp,%ebp
 3cd:	53                   	push   %ebx
 3ce:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3d5:	75 08                	jne    3df <strtok+0x15>
  s = lasts;
 3d7:	a1 04 12 00 00       	mov    0x1204,%eax
 3dc:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	8d 50 01             	lea    0x1(%eax),%edx
 3e5:	89 55 08             	mov    %edx,0x8(%ebp)
 3e8:	8a 00                	mov    (%eax),%al
 3ea:	0f be d8             	movsbl %al,%ebx
 3ed:	85 db                	test   %ebx,%ebx
 3ef:	75 07                	jne    3f8 <strtok+0x2e>
      return 0;
 3f1:	b8 00 00 00 00       	mov    $0x0,%eax
 3f6:	eb 58                	jmp    450 <strtok+0x86>
    } while (strchr(delim, ch));
 3f8:	88 d8                	mov    %bl,%al
 3fa:	0f be c0             	movsbl %al,%eax
 3fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 401:	8b 45 0c             	mov    0xc(%ebp),%eax
 404:	89 04 24             	mov    %eax,(%esp)
 407:	e8 7e fe ff ff       	call   28a <strchr>
 40c:	85 c0                	test   %eax,%eax
 40e:	75 cf                	jne    3df <strtok+0x15>
    --s;
 410:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	89 44 24 04          	mov    %eax,0x4(%esp)
 41a:	8b 45 08             	mov    0x8(%ebp),%eax
 41d:	89 04 24             	mov    %eax,(%esp)
 420:	e8 31 00 00 00       	call   456 <strcspn>
 425:	89 c2                	mov    %eax,%edx
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	01 d0                	add    %edx,%eax
 42c:	a3 04 12 00 00       	mov    %eax,0x1204
    if (*lasts != 0)
 431:	a1 04 12 00 00       	mov    0x1204,%eax
 436:	8a 00                	mov    (%eax),%al
 438:	84 c0                	test   %al,%al
 43a:	74 11                	je     44d <strtok+0x83>
  *lasts++ = 0;
 43c:	a1 04 12 00 00       	mov    0x1204,%eax
 441:	8d 50 01             	lea    0x1(%eax),%edx
 444:	89 15 04 12 00 00    	mov    %edx,0x1204
 44a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 450:	83 c4 14             	add    $0x14,%esp
 453:	5b                   	pop    %ebx
 454:	5d                   	pop    %ebp
 455:	c3                   	ret    

00000456 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 456:	55                   	push   %ebp
 457:	89 e5                	mov    %esp,%ebp
 459:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 45c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 463:	eb 26                	jmp    48b <strcspn+0x35>
        if(strchr(s2,*s1))
 465:	8b 45 08             	mov    0x8(%ebp),%eax
 468:	8a 00                	mov    (%eax),%al
 46a:	0f be c0             	movsbl %al,%eax
 46d:	89 44 24 04          	mov    %eax,0x4(%esp)
 471:	8b 45 0c             	mov    0xc(%ebp),%eax
 474:	89 04 24             	mov    %eax,(%esp)
 477:	e8 0e fe ff ff       	call   28a <strchr>
 47c:	85 c0                	test   %eax,%eax
 47e:	74 05                	je     485 <strcspn+0x2f>
            return ret;
 480:	8b 45 fc             	mov    -0x4(%ebp),%eax
 483:	eb 12                	jmp    497 <strcspn+0x41>
        else
            s1++,ret++;
 485:	ff 45 08             	incl   0x8(%ebp)
 488:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	8a 00                	mov    (%eax),%al
 490:	84 c0                	test   %al,%al
 492:	75 d1                	jne    465 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 494:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 497:	c9                   	leave  
 498:	c3                   	ret    

00000499 <isspace>:

int
isspace(unsigned char c)
{
 499:	55                   	push   %ebp
 49a:	89 e5                	mov    %esp,%ebp
 49c:	83 ec 04             	sub    $0x4,%esp
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4a5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4a9:	74 1e                	je     4c9 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4ab:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4af:	74 18                	je     4c9 <isspace+0x30>
 4b1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4b5:	74 12                	je     4c9 <isspace+0x30>
 4b7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4bb:	74 0c                	je     4c9 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4bd:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 4c1:	74 06                	je     4c9 <isspace+0x30>
 4c3:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 4c7:	75 07                	jne    4d0 <isspace+0x37>
 4c9:	b8 01 00 00 00       	mov    $0x1,%eax
 4ce:	eb 05                	jmp    4d5 <isspace+0x3c>
 4d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4d5:	c9                   	leave  
 4d6:	c3                   	ret    

000004d7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4d7:	55                   	push   %ebp
 4d8:	89 e5                	mov    %esp,%ebp
 4da:	57                   	push   %edi
 4db:	56                   	push   %esi
 4dc:	53                   	push   %ebx
 4dd:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 4e0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 4e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 4ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 4ef:	eb 01                	jmp    4f2 <strtoul+0x1b>
  p += 1;
 4f1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 4f2:	8a 03                	mov    (%ebx),%al
 4f4:	0f b6 c0             	movzbl %al,%eax
 4f7:	89 04 24             	mov    %eax,(%esp)
 4fa:	e8 9a ff ff ff       	call   499 <isspace>
 4ff:	85 c0                	test   %eax,%eax
 501:	75 ee                	jne    4f1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 503:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 507:	75 30                	jne    539 <strtoul+0x62>
    {
  if (*p == '0') {
 509:	8a 03                	mov    (%ebx),%al
 50b:	3c 30                	cmp    $0x30,%al
 50d:	75 21                	jne    530 <strtoul+0x59>
      p += 1;
 50f:	43                   	inc    %ebx
      if (*p == 'x') {
 510:	8a 03                	mov    (%ebx),%al
 512:	3c 78                	cmp    $0x78,%al
 514:	75 0a                	jne    520 <strtoul+0x49>
    p += 1;
 516:	43                   	inc    %ebx
    base = 16;
 517:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 51e:	eb 31                	jmp    551 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 520:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 527:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 52e:	eb 21                	jmp    551 <strtoul+0x7a>
      }
  }
  else base = 10;
 530:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 537:	eb 18                	jmp    551 <strtoul+0x7a>
    } else if (base == 16) {
 539:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 53d:	75 12                	jne    551 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 53f:	8a 03                	mov    (%ebx),%al
 541:	3c 30                	cmp    $0x30,%al
 543:	75 0c                	jne    551 <strtoul+0x7a>
 545:	8d 43 01             	lea    0x1(%ebx),%eax
 548:	8a 00                	mov    (%eax),%al
 54a:	3c 78                	cmp    $0x78,%al
 54c:	75 03                	jne    551 <strtoul+0x7a>
      p += 2;
 54e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 551:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 555:	75 29                	jne    580 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 557:	8a 03                	mov    (%ebx),%al
 559:	0f be c0             	movsbl %al,%eax
 55c:	83 e8 30             	sub    $0x30,%eax
 55f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 561:	83 fe 07             	cmp    $0x7,%esi
 564:	76 06                	jbe    56c <strtoul+0x95>
    break;
 566:	90                   	nop
 567:	e9 b6 00 00 00       	jmp    622 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 56c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 573:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 576:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 57d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 57e:	eb d7                	jmp    557 <strtoul+0x80>
    } else if (base == 10) {
 580:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 584:	75 2b                	jne    5b1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 586:	8a 03                	mov    (%ebx),%al
 588:	0f be c0             	movsbl %al,%eax
 58b:	83 e8 30             	sub    $0x30,%eax
 58e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 590:	83 fe 09             	cmp    $0x9,%esi
 593:	76 06                	jbe    59b <strtoul+0xc4>
    break;
 595:	90                   	nop
 596:	e9 87 00 00 00       	jmp    622 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 59b:	89 f8                	mov    %edi,%eax
 59d:	c1 e0 02             	shl    $0x2,%eax
 5a0:	01 f8                	add    %edi,%eax
 5a2:	01 c0                	add    %eax,%eax
 5a4:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5ae:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5af:	eb d5                	jmp    586 <strtoul+0xaf>
    } else if (base == 16) {
 5b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5b5:	75 35                	jne    5ec <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5b7:	8a 03                	mov    (%ebx),%al
 5b9:	0f be c0             	movsbl %al,%eax
 5bc:	83 e8 30             	sub    $0x30,%eax
 5bf:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5c1:	83 fe 4a             	cmp    $0x4a,%esi
 5c4:	76 02                	jbe    5c8 <strtoul+0xf1>
    break;
 5c6:	eb 22                	jmp    5ea <strtoul+0x113>
      }
      digit = cvtIn[digit];
 5c8:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 5ce:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5d1:	83 fe 0f             	cmp    $0xf,%esi
 5d4:	76 02                	jbe    5d8 <strtoul+0x101>
    break;
 5d6:	eb 12                	jmp    5ea <strtoul+0x113>
      }
      result = (result << 4) + digit;
 5d8:	89 f8                	mov    %edi,%eax
 5da:	c1 e0 04             	shl    $0x4,%eax
 5dd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5e0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 5e7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 5e8:	eb cd                	jmp    5b7 <strtoul+0xe0>
 5ea:	eb 36                	jmp    622 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 5ec:	8a 03                	mov    (%ebx),%al
 5ee:	0f be c0             	movsbl %al,%eax
 5f1:	83 e8 30             	sub    $0x30,%eax
 5f4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5f6:	83 fe 4a             	cmp    $0x4a,%esi
 5f9:	76 02                	jbe    5fd <strtoul+0x126>
    break;
 5fb:	eb 25                	jmp    622 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 5fd:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 603:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 606:	8b 45 10             	mov    0x10(%ebp),%eax
 609:	39 f0                	cmp    %esi,%eax
 60b:	77 02                	ja     60f <strtoul+0x138>
    break;
 60d:	eb 13                	jmp    622 <strtoul+0x14b>
      }
      result = result*base + digit;
 60f:	8b 45 10             	mov    0x10(%ebp),%eax
 612:	0f af c7             	imul   %edi,%eax
 615:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 618:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 61f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 620:	eb ca                	jmp    5ec <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 622:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 626:	75 03                	jne    62b <strtoul+0x154>
  p = string;
 628:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 62b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 62f:	74 05                	je     636 <strtoul+0x15f>
  *endPtr = p;
 631:	8b 45 0c             	mov    0xc(%ebp),%eax
 634:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 636:	89 f8                	mov    %edi,%eax
}
 638:	83 c4 14             	add    $0x14,%esp
 63b:	5b                   	pop    %ebx
 63c:	5e                   	pop    %esi
 63d:	5f                   	pop    %edi
 63e:	5d                   	pop    %ebp
 63f:	c3                   	ret    

00000640 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	53                   	push   %ebx
 644:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 647:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 64a:	eb 01                	jmp    64d <strtol+0xd>
      p += 1;
 64c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 64d:	8a 03                	mov    (%ebx),%al
 64f:	0f b6 c0             	movzbl %al,%eax
 652:	89 04 24             	mov    %eax,(%esp)
 655:	e8 3f fe ff ff       	call   499 <isspace>
 65a:	85 c0                	test   %eax,%eax
 65c:	75 ee                	jne    64c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 65e:	8a 03                	mov    (%ebx),%al
 660:	3c 2d                	cmp    $0x2d,%al
 662:	75 1e                	jne    682 <strtol+0x42>
  p += 1;
 664:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 665:	8b 45 10             	mov    0x10(%ebp),%eax
 668:	89 44 24 08          	mov    %eax,0x8(%esp)
 66c:	8b 45 0c             	mov    0xc(%ebp),%eax
 66f:	89 44 24 04          	mov    %eax,0x4(%esp)
 673:	89 1c 24             	mov    %ebx,(%esp)
 676:	e8 5c fe ff ff       	call   4d7 <strtoul>
 67b:	f7 d8                	neg    %eax
 67d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 680:	eb 20                	jmp    6a2 <strtol+0x62>
    } else {
  if (*p == '+') {
 682:	8a 03                	mov    (%ebx),%al
 684:	3c 2b                	cmp    $0x2b,%al
 686:	75 01                	jne    689 <strtol+0x49>
      p += 1;
 688:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 689:	8b 45 10             	mov    0x10(%ebp),%eax
 68c:	89 44 24 08          	mov    %eax,0x8(%esp)
 690:	8b 45 0c             	mov    0xc(%ebp),%eax
 693:	89 44 24 04          	mov    %eax,0x4(%esp)
 697:	89 1c 24             	mov    %ebx,(%esp)
 69a:	e8 38 fe ff ff       	call   4d7 <strtoul>
 69f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6a6:	75 17                	jne    6bf <strtol+0x7f>
 6a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ac:	74 11                	je     6bf <strtol+0x7f>
 6ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b1:	8b 00                	mov    (%eax),%eax
 6b3:	39 d8                	cmp    %ebx,%eax
 6b5:	75 08                	jne    6bf <strtol+0x7f>
  *endPtr = string;
 6b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ba:	8b 55 08             	mov    0x8(%ebp),%edx
 6bd:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 6c2:	83 c4 1c             	add    $0x1c,%esp
 6c5:	5b                   	pop    %ebx
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret    

000006c8 <gets>:

char*
gets(char *buf, int max)
{
 6c8:	55                   	push   %ebp
 6c9:	89 e5                	mov    %esp,%ebp
 6cb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6d5:	eb 49                	jmp    720 <gets+0x58>
    cc = read(0, &c, 1);
 6d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6de:	00 
 6df:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6ed:	e8 3e 01 00 00       	call   830 <read>
 6f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f9:	7f 02                	jg     6fd <gets+0x35>
      break;
 6fb:	eb 2c                	jmp    729 <gets+0x61>
    buf[i++] = c;
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	8d 50 01             	lea    0x1(%eax),%edx
 703:	89 55 f4             	mov    %edx,-0xc(%ebp)
 706:	89 c2                	mov    %eax,%edx
 708:	8b 45 08             	mov    0x8(%ebp),%eax
 70b:	01 c2                	add    %eax,%edx
 70d:	8a 45 ef             	mov    -0x11(%ebp),%al
 710:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 712:	8a 45 ef             	mov    -0x11(%ebp),%al
 715:	3c 0a                	cmp    $0xa,%al
 717:	74 10                	je     729 <gets+0x61>
 719:	8a 45 ef             	mov    -0x11(%ebp),%al
 71c:	3c 0d                	cmp    $0xd,%al
 71e:	74 09                	je     729 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 720:	8b 45 f4             	mov    -0xc(%ebp),%eax
 723:	40                   	inc    %eax
 724:	3b 45 0c             	cmp    0xc(%ebp),%eax
 727:	7c ae                	jl     6d7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 729:	8b 55 f4             	mov    -0xc(%ebp),%edx
 72c:	8b 45 08             	mov    0x8(%ebp),%eax
 72f:	01 d0                	add    %edx,%eax
 731:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 734:	8b 45 08             	mov    0x8(%ebp),%eax
}
 737:	c9                   	leave  
 738:	c3                   	ret    

00000739 <stat>:

int
stat(char *n, struct stat *st)
{
 739:	55                   	push   %ebp
 73a:	89 e5                	mov    %esp,%ebp
 73c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 73f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 746:	00 
 747:	8b 45 08             	mov    0x8(%ebp),%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 06 01 00 00       	call   858 <open>
 752:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 755:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 759:	79 07                	jns    762 <stat+0x29>
    return -1;
 75b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 760:	eb 23                	jmp    785 <stat+0x4c>
  r = fstat(fd, st);
 762:	8b 45 0c             	mov    0xc(%ebp),%eax
 765:	89 44 24 04          	mov    %eax,0x4(%esp)
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 fc 00 00 00       	call   870 <fstat>
 774:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 777:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77a:	89 04 24             	mov    %eax,(%esp)
 77d:	e8 be 00 00 00       	call   840 <close>
  return r;
 782:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 785:	c9                   	leave  
 786:	c3                   	ret    

00000787 <atoi>:

int
atoi(const char *s)
{
 787:	55                   	push   %ebp
 788:	89 e5                	mov    %esp,%ebp
 78a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 78d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 794:	eb 24                	jmp    7ba <atoi+0x33>
    n = n*10 + *s++ - '0';
 796:	8b 55 fc             	mov    -0x4(%ebp),%edx
 799:	89 d0                	mov    %edx,%eax
 79b:	c1 e0 02             	shl    $0x2,%eax
 79e:	01 d0                	add    %edx,%eax
 7a0:	01 c0                	add    %eax,%eax
 7a2:	89 c1                	mov    %eax,%ecx
 7a4:	8b 45 08             	mov    0x8(%ebp),%eax
 7a7:	8d 50 01             	lea    0x1(%eax),%edx
 7aa:	89 55 08             	mov    %edx,0x8(%ebp)
 7ad:	8a 00                	mov    (%eax),%al
 7af:	0f be c0             	movsbl %al,%eax
 7b2:	01 c8                	add    %ecx,%eax
 7b4:	83 e8 30             	sub    $0x30,%eax
 7b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7ba:	8b 45 08             	mov    0x8(%ebp),%eax
 7bd:	8a 00                	mov    (%eax),%al
 7bf:	3c 2f                	cmp    $0x2f,%al
 7c1:	7e 09                	jle    7cc <atoi+0x45>
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	8a 00                	mov    (%eax),%al
 7c8:	3c 39                	cmp    $0x39,%al
 7ca:	7e ca                	jle    796 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7cf:	c9                   	leave  
 7d0:	c3                   	ret    

000007d1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7d1:	55                   	push   %ebp
 7d2:	89 e5                	mov    %esp,%ebp
 7d4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7d7:	8b 45 08             	mov    0x8(%ebp),%eax
 7da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7e3:	eb 16                	jmp    7fb <memmove+0x2a>
    *dst++ = *src++;
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	8d 50 01             	lea    0x1(%eax),%edx
 7eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f1:	8d 4a 01             	lea    0x1(%edx),%ecx
 7f4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7f7:	8a 12                	mov    (%edx),%dl
 7f9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7fb:	8b 45 10             	mov    0x10(%ebp),%eax
 7fe:	8d 50 ff             	lea    -0x1(%eax),%edx
 801:	89 55 10             	mov    %edx,0x10(%ebp)
 804:	85 c0                	test   %eax,%eax
 806:	7f dd                	jg     7e5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 808:	8b 45 08             	mov    0x8(%ebp),%eax
}
 80b:	c9                   	leave  
 80c:	c3                   	ret    
 80d:	90                   	nop
 80e:	90                   	nop
 80f:	90                   	nop

00000810 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 810:	b8 01 00 00 00       	mov    $0x1,%eax
 815:	cd 40                	int    $0x40
 817:	c3                   	ret    

00000818 <exit>:
SYSCALL(exit)
 818:	b8 02 00 00 00       	mov    $0x2,%eax
 81d:	cd 40                	int    $0x40
 81f:	c3                   	ret    

00000820 <wait>:
SYSCALL(wait)
 820:	b8 03 00 00 00       	mov    $0x3,%eax
 825:	cd 40                	int    $0x40
 827:	c3                   	ret    

00000828 <pipe>:
SYSCALL(pipe)
 828:	b8 04 00 00 00       	mov    $0x4,%eax
 82d:	cd 40                	int    $0x40
 82f:	c3                   	ret    

00000830 <read>:
SYSCALL(read)
 830:	b8 05 00 00 00       	mov    $0x5,%eax
 835:	cd 40                	int    $0x40
 837:	c3                   	ret    

00000838 <write>:
SYSCALL(write)
 838:	b8 10 00 00 00       	mov    $0x10,%eax
 83d:	cd 40                	int    $0x40
 83f:	c3                   	ret    

00000840 <close>:
SYSCALL(close)
 840:	b8 15 00 00 00       	mov    $0x15,%eax
 845:	cd 40                	int    $0x40
 847:	c3                   	ret    

00000848 <kill>:
SYSCALL(kill)
 848:	b8 06 00 00 00       	mov    $0x6,%eax
 84d:	cd 40                	int    $0x40
 84f:	c3                   	ret    

00000850 <exec>:
SYSCALL(exec)
 850:	b8 07 00 00 00       	mov    $0x7,%eax
 855:	cd 40                	int    $0x40
 857:	c3                   	ret    

00000858 <open>:
SYSCALL(open)
 858:	b8 0f 00 00 00       	mov    $0xf,%eax
 85d:	cd 40                	int    $0x40
 85f:	c3                   	ret    

00000860 <mknod>:
SYSCALL(mknod)
 860:	b8 11 00 00 00       	mov    $0x11,%eax
 865:	cd 40                	int    $0x40
 867:	c3                   	ret    

00000868 <unlink>:
SYSCALL(unlink)
 868:	b8 12 00 00 00       	mov    $0x12,%eax
 86d:	cd 40                	int    $0x40
 86f:	c3                   	ret    

00000870 <fstat>:
SYSCALL(fstat)
 870:	b8 08 00 00 00       	mov    $0x8,%eax
 875:	cd 40                	int    $0x40
 877:	c3                   	ret    

00000878 <link>:
SYSCALL(link)
 878:	b8 13 00 00 00       	mov    $0x13,%eax
 87d:	cd 40                	int    $0x40
 87f:	c3                   	ret    

00000880 <mkdir>:
SYSCALL(mkdir)
 880:	b8 14 00 00 00       	mov    $0x14,%eax
 885:	cd 40                	int    $0x40
 887:	c3                   	ret    

00000888 <chdir>:
SYSCALL(chdir)
 888:	b8 09 00 00 00       	mov    $0x9,%eax
 88d:	cd 40                	int    $0x40
 88f:	c3                   	ret    

00000890 <dup>:
SYSCALL(dup)
 890:	b8 0a 00 00 00       	mov    $0xa,%eax
 895:	cd 40                	int    $0x40
 897:	c3                   	ret    

00000898 <getpid>:
SYSCALL(getpid)
 898:	b8 0b 00 00 00       	mov    $0xb,%eax
 89d:	cd 40                	int    $0x40
 89f:	c3                   	ret    

000008a0 <sbrk>:
SYSCALL(sbrk)
 8a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 8a5:	cd 40                	int    $0x40
 8a7:	c3                   	ret    

000008a8 <sleep>:
SYSCALL(sleep)
 8a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <uptime>:
SYSCALL(uptime)
 8b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <getname>:
SYSCALL(getname)
 8b8:	b8 16 00 00 00       	mov    $0x16,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <setname>:
SYSCALL(setname)
 8c0:	b8 17 00 00 00       	mov    $0x17,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <getmaxproc>:
SYSCALL(getmaxproc)
 8c8:	b8 18 00 00 00       	mov    $0x18,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <setmaxproc>:
SYSCALL(setmaxproc)
 8d0:	b8 19 00 00 00       	mov    $0x19,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <getmaxmem>:
SYSCALL(getmaxmem)
 8d8:	b8 1a 00 00 00       	mov    $0x1a,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <setmaxmem>:
SYSCALL(setmaxmem)
 8e0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <getmaxdisk>:
SYSCALL(getmaxdisk)
 8e8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <setmaxdisk>:
SYSCALL(setmaxdisk)
 8f0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <getusedmem>:
SYSCALL(getusedmem)
 8f8:	b8 1e 00 00 00       	mov    $0x1e,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <setusedmem>:
SYSCALL(setusedmem)
 900:	b8 1f 00 00 00       	mov    $0x1f,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <getuseddisk>:
SYSCALL(getuseddisk)
 908:	b8 20 00 00 00       	mov    $0x20,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <setuseddisk>:
SYSCALL(setuseddisk)
 910:	b8 21 00 00 00       	mov    $0x21,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 918:	55                   	push   %ebp
 919:	89 e5                	mov    %esp,%ebp
 91b:	83 ec 18             	sub    $0x18,%esp
 91e:	8b 45 0c             	mov    0xc(%ebp),%eax
 921:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 924:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 92b:	00 
 92c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 92f:	89 44 24 04          	mov    %eax,0x4(%esp)
 933:	8b 45 08             	mov    0x8(%ebp),%eax
 936:	89 04 24             	mov    %eax,(%esp)
 939:	e8 fa fe ff ff       	call   838 <write>
}
 93e:	c9                   	leave  
 93f:	c3                   	ret    

00000940 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	56                   	push   %esi
 944:	53                   	push   %ebx
 945:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 948:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 94f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 953:	74 17                	je     96c <printint+0x2c>
 955:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 959:	79 11                	jns    96c <printint+0x2c>
    neg = 1;
 95b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 962:	8b 45 0c             	mov    0xc(%ebp),%eax
 965:	f7 d8                	neg    %eax
 967:	89 45 ec             	mov    %eax,-0x14(%ebp)
 96a:	eb 06                	jmp    972 <printint+0x32>
  } else {
    x = xx;
 96c:	8b 45 0c             	mov    0xc(%ebp),%eax
 96f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 972:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 979:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 97c:	8d 41 01             	lea    0x1(%ecx),%eax
 97f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 982:	8b 5d 10             	mov    0x10(%ebp),%ebx
 985:	8b 45 ec             	mov    -0x14(%ebp),%eax
 988:	ba 00 00 00 00       	mov    $0x0,%edx
 98d:	f7 f3                	div    %ebx
 98f:	89 d0                	mov    %edx,%eax
 991:	8a 80 ec 11 00 00    	mov    0x11ec(%eax),%al
 997:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 99b:	8b 75 10             	mov    0x10(%ebp),%esi
 99e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9a1:	ba 00 00 00 00       	mov    $0x0,%edx
 9a6:	f7 f6                	div    %esi
 9a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9af:	75 c8                	jne    979 <printint+0x39>
  if(neg)
 9b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9b5:	74 10                	je     9c7 <printint+0x87>
    buf[i++] = '-';
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	8d 50 01             	lea    0x1(%eax),%edx
 9bd:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9c0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9c5:	eb 1e                	jmp    9e5 <printint+0xa5>
 9c7:	eb 1c                	jmp    9e5 <printint+0xa5>
    putc(fd, buf[i]);
 9c9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cf:	01 d0                	add    %edx,%eax
 9d1:	8a 00                	mov    (%eax),%al
 9d3:	0f be c0             	movsbl %al,%eax
 9d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 9da:	8b 45 08             	mov    0x8(%ebp),%eax
 9dd:	89 04 24             	mov    %eax,(%esp)
 9e0:	e8 33 ff ff ff       	call   918 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9e5:	ff 4d f4             	decl   -0xc(%ebp)
 9e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ec:	79 db                	jns    9c9 <printint+0x89>
    putc(fd, buf[i]);
}
 9ee:	83 c4 30             	add    $0x30,%esp
 9f1:	5b                   	pop    %ebx
 9f2:	5e                   	pop    %esi
 9f3:	5d                   	pop    %ebp
 9f4:	c3                   	ret    

000009f5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9f5:	55                   	push   %ebp
 9f6:	89 e5                	mov    %esp,%ebp
 9f8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9fb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a02:	8d 45 0c             	lea    0xc(%ebp),%eax
 a05:	83 c0 04             	add    $0x4,%eax
 a08:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a0b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a12:	e9 77 01 00 00       	jmp    b8e <printf+0x199>
    c = fmt[i] & 0xff;
 a17:	8b 55 0c             	mov    0xc(%ebp),%edx
 a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a1d:	01 d0                	add    %edx,%eax
 a1f:	8a 00                	mov    (%eax),%al
 a21:	0f be c0             	movsbl %al,%eax
 a24:	25 ff 00 00 00       	and    $0xff,%eax
 a29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a2c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a30:	75 2c                	jne    a5e <printf+0x69>
      if(c == '%'){
 a32:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a36:	75 0c                	jne    a44 <printf+0x4f>
        state = '%';
 a38:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a3f:	e9 47 01 00 00       	jmp    b8b <printf+0x196>
      } else {
        putc(fd, c);
 a44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a47:	0f be c0             	movsbl %al,%eax
 a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
 a4e:	8b 45 08             	mov    0x8(%ebp),%eax
 a51:	89 04 24             	mov    %eax,(%esp)
 a54:	e8 bf fe ff ff       	call   918 <putc>
 a59:	e9 2d 01 00 00       	jmp    b8b <printf+0x196>
      }
    } else if(state == '%'){
 a5e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a62:	0f 85 23 01 00 00    	jne    b8b <printf+0x196>
      if(c == 'd'){
 a68:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a6c:	75 2d                	jne    a9b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a71:	8b 00                	mov    (%eax),%eax
 a73:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a7a:	00 
 a7b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a82:	00 
 a83:	89 44 24 04          	mov    %eax,0x4(%esp)
 a87:	8b 45 08             	mov    0x8(%ebp),%eax
 a8a:	89 04 24             	mov    %eax,(%esp)
 a8d:	e8 ae fe ff ff       	call   940 <printint>
        ap++;
 a92:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a96:	e9 e9 00 00 00       	jmp    b84 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a9b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a9f:	74 06                	je     aa7 <printf+0xb2>
 aa1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 aa5:	75 2d                	jne    ad4 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 aa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 aaa:	8b 00                	mov    (%eax),%eax
 aac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 ab3:	00 
 ab4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 abb:	00 
 abc:	89 44 24 04          	mov    %eax,0x4(%esp)
 ac0:	8b 45 08             	mov    0x8(%ebp),%eax
 ac3:	89 04 24             	mov    %eax,(%esp)
 ac6:	e8 75 fe ff ff       	call   940 <printint>
        ap++;
 acb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 acf:	e9 b0 00 00 00       	jmp    b84 <printf+0x18f>
      } else if(c == 's'){
 ad4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 ad8:	75 42                	jne    b1c <printf+0x127>
        s = (char*)*ap;
 ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
 add:	8b 00                	mov    (%eax),%eax
 adf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 ae2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 ae6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aea:	75 09                	jne    af5 <printf+0x100>
          s = "(null)";
 aec:	c7 45 f4 06 0e 00 00 	movl   $0xe06,-0xc(%ebp)
        while(*s != 0){
 af3:	eb 1c                	jmp    b11 <printf+0x11c>
 af5:	eb 1a                	jmp    b11 <printf+0x11c>
          putc(fd, *s);
 af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afa:	8a 00                	mov    (%eax),%al
 afc:	0f be c0             	movsbl %al,%eax
 aff:	89 44 24 04          	mov    %eax,0x4(%esp)
 b03:	8b 45 08             	mov    0x8(%ebp),%eax
 b06:	89 04 24             	mov    %eax,(%esp)
 b09:	e8 0a fe ff ff       	call   918 <putc>
          s++;
 b0e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b14:	8a 00                	mov    (%eax),%al
 b16:	84 c0                	test   %al,%al
 b18:	75 dd                	jne    af7 <printf+0x102>
 b1a:	eb 68                	jmp    b84 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b1c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b20:	75 1d                	jne    b3f <printf+0x14a>
        putc(fd, *ap);
 b22:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b25:	8b 00                	mov    (%eax),%eax
 b27:	0f be c0             	movsbl %al,%eax
 b2a:	89 44 24 04          	mov    %eax,0x4(%esp)
 b2e:	8b 45 08             	mov    0x8(%ebp),%eax
 b31:	89 04 24             	mov    %eax,(%esp)
 b34:	e8 df fd ff ff       	call   918 <putc>
        ap++;
 b39:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b3d:	eb 45                	jmp    b84 <printf+0x18f>
      } else if(c == '%'){
 b3f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b43:	75 17                	jne    b5c <printf+0x167>
        putc(fd, c);
 b45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b48:	0f be c0             	movsbl %al,%eax
 b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b4f:	8b 45 08             	mov    0x8(%ebp),%eax
 b52:	89 04 24             	mov    %eax,(%esp)
 b55:	e8 be fd ff ff       	call   918 <putc>
 b5a:	eb 28                	jmp    b84 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b5c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b63:	00 
 b64:	8b 45 08             	mov    0x8(%ebp),%eax
 b67:	89 04 24             	mov    %eax,(%esp)
 b6a:	e8 a9 fd ff ff       	call   918 <putc>
        putc(fd, c);
 b6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b72:	0f be c0             	movsbl %al,%eax
 b75:	89 44 24 04          	mov    %eax,0x4(%esp)
 b79:	8b 45 08             	mov    0x8(%ebp),%eax
 b7c:	89 04 24             	mov    %eax,(%esp)
 b7f:	e8 94 fd ff ff       	call   918 <putc>
      }
      state = 0;
 b84:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b8b:	ff 45 f0             	incl   -0x10(%ebp)
 b8e:	8b 55 0c             	mov    0xc(%ebp),%edx
 b91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b94:	01 d0                	add    %edx,%eax
 b96:	8a 00                	mov    (%eax),%al
 b98:	84 c0                	test   %al,%al
 b9a:	0f 85 77 fe ff ff    	jne    a17 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 ba0:	c9                   	leave  
 ba1:	c3                   	ret    
 ba2:	90                   	nop
 ba3:	90                   	nop

00000ba4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ba4:	55                   	push   %ebp
 ba5:	89 e5                	mov    %esp,%ebp
 ba7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 baa:	8b 45 08             	mov    0x8(%ebp),%eax
 bad:	83 e8 08             	sub    $0x8,%eax
 bb0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb3:	a1 10 12 00 00       	mov    0x1210,%eax
 bb8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bbb:	eb 24                	jmp    be1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc0:	8b 00                	mov    (%eax),%eax
 bc2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bc5:	77 12                	ja     bd9 <free+0x35>
 bc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bca:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bcd:	77 24                	ja     bf3 <free+0x4f>
 bcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd2:	8b 00                	mov    (%eax),%eax
 bd4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bd7:	77 1a                	ja     bf3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdc:	8b 00                	mov    (%eax),%eax
 bde:	89 45 fc             	mov    %eax,-0x4(%ebp)
 be1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 be7:	76 d4                	jbe    bbd <free+0x19>
 be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bec:	8b 00                	mov    (%eax),%eax
 bee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bf1:	76 ca                	jbe    bbd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf6:	8b 40 04             	mov    0x4(%eax),%eax
 bf9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c00:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c03:	01 c2                	add    %eax,%edx
 c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c08:	8b 00                	mov    (%eax),%eax
 c0a:	39 c2                	cmp    %eax,%edx
 c0c:	75 24                	jne    c32 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c11:	8b 50 04             	mov    0x4(%eax),%edx
 c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c17:	8b 00                	mov    (%eax),%eax
 c19:	8b 40 04             	mov    0x4(%eax),%eax
 c1c:	01 c2                	add    %eax,%edx
 c1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c21:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c27:	8b 00                	mov    (%eax),%eax
 c29:	8b 10                	mov    (%eax),%edx
 c2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2e:	89 10                	mov    %edx,(%eax)
 c30:	eb 0a                	jmp    c3c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c32:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c35:	8b 10                	mov    (%eax),%edx
 c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3f:	8b 40 04             	mov    0x4(%eax),%eax
 c42:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c4c:	01 d0                	add    %edx,%eax
 c4e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c51:	75 20                	jne    c73 <free+0xcf>
    p->s.size += bp->s.size;
 c53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c56:	8b 50 04             	mov    0x4(%eax),%edx
 c59:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c5c:	8b 40 04             	mov    0x4(%eax),%eax
 c5f:	01 c2                	add    %eax,%edx
 c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c64:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c67:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c6a:	8b 10                	mov    (%eax),%edx
 c6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6f:	89 10                	mov    %edx,(%eax)
 c71:	eb 08                	jmp    c7b <free+0xd7>
  } else
    p->s.ptr = bp;
 c73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c76:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c79:	89 10                	mov    %edx,(%eax)
  freep = p;
 c7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c7e:	a3 10 12 00 00       	mov    %eax,0x1210
}
 c83:	c9                   	leave  
 c84:	c3                   	ret    

00000c85 <morecore>:

static Header*
morecore(uint nu)
{
 c85:	55                   	push   %ebp
 c86:	89 e5                	mov    %esp,%ebp
 c88:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c8b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c92:	77 07                	ja     c9b <morecore+0x16>
    nu = 4096;
 c94:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c9b:	8b 45 08             	mov    0x8(%ebp),%eax
 c9e:	c1 e0 03             	shl    $0x3,%eax
 ca1:	89 04 24             	mov    %eax,(%esp)
 ca4:	e8 f7 fb ff ff       	call   8a0 <sbrk>
 ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cac:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cb0:	75 07                	jne    cb9 <morecore+0x34>
    return 0;
 cb2:	b8 00 00 00 00       	mov    $0x0,%eax
 cb7:	eb 22                	jmp    cdb <morecore+0x56>
  hp = (Header*)p;
 cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cbc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 cbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cc2:	8b 55 08             	mov    0x8(%ebp),%edx
 cc5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ccb:	83 c0 08             	add    $0x8,%eax
 cce:	89 04 24             	mov    %eax,(%esp)
 cd1:	e8 ce fe ff ff       	call   ba4 <free>
  return freep;
 cd6:	a1 10 12 00 00       	mov    0x1210,%eax
}
 cdb:	c9                   	leave  
 cdc:	c3                   	ret    

00000cdd <malloc>:

void*
malloc(uint nbytes)
{
 cdd:	55                   	push   %ebp
 cde:	89 e5                	mov    %esp,%ebp
 ce0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ce3:	8b 45 08             	mov    0x8(%ebp),%eax
 ce6:	83 c0 07             	add    $0x7,%eax
 ce9:	c1 e8 03             	shr    $0x3,%eax
 cec:	40                   	inc    %eax
 ced:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 cf0:	a1 10 12 00 00       	mov    0x1210,%eax
 cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cfc:	75 23                	jne    d21 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 cfe:	c7 45 f0 08 12 00 00 	movl   $0x1208,-0x10(%ebp)
 d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d08:	a3 10 12 00 00       	mov    %eax,0x1210
 d0d:	a1 10 12 00 00       	mov    0x1210,%eax
 d12:	a3 08 12 00 00       	mov    %eax,0x1208
    base.s.size = 0;
 d17:	c7 05 0c 12 00 00 00 	movl   $0x0,0x120c
 d1e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d24:	8b 00                	mov    (%eax),%eax
 d26:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2c:	8b 40 04             	mov    0x4(%eax),%eax
 d2f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d32:	72 4d                	jb     d81 <malloc+0xa4>
      if(p->s.size == nunits)
 d34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d37:	8b 40 04             	mov    0x4(%eax),%eax
 d3a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d3d:	75 0c                	jne    d4b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d42:	8b 10                	mov    (%eax),%edx
 d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d47:	89 10                	mov    %edx,(%eax)
 d49:	eb 26                	jmp    d71 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4e:	8b 40 04             	mov    0x4(%eax),%eax
 d51:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d54:	89 c2                	mov    %eax,%edx
 d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d59:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5f:	8b 40 04             	mov    0x4(%eax),%eax
 d62:	c1 e0 03             	shl    $0x3,%eax
 d65:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d6e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d74:	a3 10 12 00 00       	mov    %eax,0x1210
      return (void*)(p + 1);
 d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7c:	83 c0 08             	add    $0x8,%eax
 d7f:	eb 38                	jmp    db9 <malloc+0xdc>
    }
    if(p == freep)
 d81:	a1 10 12 00 00       	mov    0x1210,%eax
 d86:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d89:	75 1b                	jne    da6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d8e:	89 04 24             	mov    %eax,(%esp)
 d91:	e8 ef fe ff ff       	call   c85 <morecore>
 d96:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d9d:	75 07                	jne    da6 <malloc+0xc9>
        return 0;
 d9f:	b8 00 00 00 00       	mov    $0x0,%eax
 da4:	eb 13                	jmp    db9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 daf:	8b 00                	mov    (%eax),%eax
 db1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 db4:	e9 70 ff ff ff       	jmp    d29 <malloc+0x4c>
}
 db9:	c9                   	leave  
 dba:	c3                   	ret    
