
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  write(fd, s, strlen(s));
   6:	8b 45 0c             	mov    0xc(%ebp),%eax
   9:	89 04 24             	mov    %eax,(%esp)
   c:	e8 f0 02 00 00       	call   301 <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 d1 08 00 00       	call   8f8 <write>
}
  27:	c9                   	leave  
  28:	c3                   	ret    

00000029 <forktest>:

void
forktest(void)
{
  29:	55                   	push   %ebp
  2a:	89 e5                	mov    %esp,%ebp
  2c:	83 ec 28             	sub    $0x28,%esp
  int n, pid;

  printf(1, "fork test\n");
  2f:	c7 44 24 04 78 09 00 	movl   $0x978,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 1e                	jmp    6a <forktest+0x41>
    pid = fork();
  4c:	e8 7f 08 00 00       	call   8d0 <fork>
  51:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(pid < 0)
  54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  58:	79 02                	jns    5c <forktest+0x33>
      break;
  5a:	eb 17                	jmp    73 <forktest+0x4a>
    if(pid == 0)
  5c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  60:	75 05                	jne    67 <forktest+0x3e>
      exit();
  62:	e8 71 08 00 00       	call   8d8 <exit>
{
  int n, pid;

  printf(1, "fork test\n");

  for(n=0; n<N; n++){
  67:	ff 45 f4             	incl   -0xc(%ebp)
  6a:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
  71:	7e d9                	jle    4c <forktest+0x23>
      break;
    if(pid == 0)
      exit();
  }

  if(n == N){
  73:	81 7d f4 e8 03 00 00 	cmpl   $0x3e8,-0xc(%ebp)
  7a:	75 21                	jne    9d <forktest+0x74>
    printf(1, "fork claimed to work N times!\n", N);
  7c:	c7 44 24 08 e8 03 00 	movl   $0x3e8,0x8(%esp)
  83:	00 
  84:	c7 44 24 04 84 09 00 	movl   $0x984,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 68 ff ff ff       	call   0 <printf>
    exit();
  98:	e8 3b 08 00 00       	call   8d8 <exit>
  }

  for(; n > 0; n--){
  9d:	eb 25                	jmp    c4 <forktest+0x9b>
    if(wait() < 0){
  9f:	e8 3c 08 00 00       	call   8e0 <wait>
  a4:	85 c0                	test   %eax,%eax
  a6:	79 19                	jns    c1 <forktest+0x98>
      printf(1, "wait stopped early\n");
  a8:	c7 44 24 04 a3 09 00 	movl   $0x9a3,0x4(%esp)
  af:	00 
  b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b7:	e8 44 ff ff ff       	call   0 <printf>
      exit();
  bc:	e8 17 08 00 00       	call   8d8 <exit>
  if(n == N){
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }

  for(; n > 0; n--){
  c1:	ff 4d f4             	decl   -0xc(%ebp)
  c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  c8:	7f d5                	jg     9f <forktest+0x76>
      printf(1, "wait stopped early\n");
      exit();
    }
  }

  if(wait() != -1){
  ca:	e8 11 08 00 00       	call   8e0 <wait>
  cf:	83 f8 ff             	cmp    $0xffffffff,%eax
  d2:	74 19                	je     ed <forktest+0xc4>
    printf(1, "wait got too many\n");
  d4:	c7 44 24 04 b7 09 00 	movl   $0x9b7,0x4(%esp)
  db:	00 
  dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e3:	e8 18 ff ff ff       	call   0 <printf>
    exit();
  e8:	e8 eb 07 00 00       	call   8d8 <exit>
  }

  printf(1, "fork test OK\n");
  ed:	c7 44 24 04 ca 09 00 	movl   $0x9ca,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 ff fe ff ff       	call   0 <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(void)
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
 109:	e8 1b ff ff ff       	call   29 <forktest>
  exit();
 10e:	e8 c5 07 00 00       	call   8d8 <exit>
 113:	90                   	nop

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 08             	mov    0x8(%ebp),%eax
 149:	8d 50 01             	lea    0x1(%eax),%edx
 14c:	89 55 08             	mov    %edx,0x8(%ebp)
 14f:	8b 55 0c             	mov    0xc(%ebp),%edx
 152:	8d 4a 01             	lea    0x1(%edx),%ecx
 155:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 158:	8a 12                	mov    (%edx),%dl
 15a:	88 10                	mov    %dl,(%eax)
 15c:	8a 00                	mov    (%eax),%al
 15e:	84 c0                	test   %al,%al
 160:	75 e4                	jne    146 <strcpy+0xd>
    ;
  return os;
 162:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 165:	c9                   	leave  
 166:	c3                   	ret    

00000167 <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
 16d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 174:	00 
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	89 04 24             	mov    %eax,(%esp)
 17b:	e8 98 07 00 00       	call   918 <open>
 180:	89 45 f0             	mov    %eax,-0x10(%ebp)
 183:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 187:	79 20                	jns    1a9 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	89 44 24 08          	mov    %eax,0x8(%esp)
 190:	c7 44 24 04 d8 09 00 	movl   $0x9d8,0x4(%esp)
 197:	00 
 198:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 19f:	e8 5c fe ff ff       	call   0 <printf>
        exit();
 1a4:	e8 2f 07 00 00       	call   8d8 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 1a9:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 1b0:	00 
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	89 04 24             	mov    %eax,(%esp)
 1b7:	e8 5c 07 00 00       	call   918 <open>
 1bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1c3:	79 20                	jns    1e5 <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	89 44 24 08          	mov    %eax,0x8(%esp)
 1cc:	c7 44 24 04 f3 09 00 	movl   $0x9f3,0x4(%esp)
 1d3:	00 
 1d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1db:	e8 20 fe ff ff       	call   0 <printf>
        exit();
 1e0:	e8 f3 06 00 00       	call   8d8 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 1e5:	eb 56                	jmp    23d <copy+0xd6>
        int max = used_disk+=count;
 1e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 1ea:	01 45 10             	add    %eax,0x10(%ebp)
 1ed:	8b 45 10             	mov    0x10(%ebp),%eax
 1f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 1f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1f6:	89 44 24 08          	mov    %eax,0x8(%esp)
 1fa:	c7 44 24 04 0f 0a 00 	movl   $0xa0f,0x4(%esp)
 201:	00 
 202:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 209:	e8 f2 fd ff ff       	call   0 <printf>
        if(max > max_disk){
 20e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 211:	3b 45 14             	cmp    0x14(%ebp),%eax
 214:	7e 07                	jle    21d <copy+0xb6>
          return -1;
 216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21b:	eb 5c                	jmp    279 <copy+0x112>
        }
        bytes = bytes + count;
 21d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 220:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 223:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 22a:	00 
 22b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 22e:	89 44 24 04          	mov    %eax,0x4(%esp)
 232:	8b 45 ec             	mov    -0x14(%ebp),%eax
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 bb 06 00 00       	call   8f8 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 23d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 244:	00 
 245:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 248:	89 44 24 04          	mov    %eax,0x4(%esp)
 24c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 99 06 00 00       	call   8f0 <read>
 257:	89 45 e8             	mov    %eax,-0x18(%ebp)
 25a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 25e:	7f 87                	jg     1e7 <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
 263:	89 04 24             	mov    %eax,(%esp)
 266:	e8 95 06 00 00       	call   900 <close>
    close(fd2);
 26b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 26e:	89 04 24             	mov    %eax,(%esp)
 271:	e8 8a 06 00 00       	call   900 <close>
    return(bytes);
 276:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 279:	c9                   	leave  
 27a:	c3                   	ret    

0000027b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 27b:	55                   	push   %ebp
 27c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 27e:	eb 06                	jmp    286 <strcmp+0xb>
    p++, q++;
 280:	ff 45 08             	incl   0x8(%ebp)
 283:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 286:	8b 45 08             	mov    0x8(%ebp),%eax
 289:	8a 00                	mov    (%eax),%al
 28b:	84 c0                	test   %al,%al
 28d:	74 0e                	je     29d <strcmp+0x22>
 28f:	8b 45 08             	mov    0x8(%ebp),%eax
 292:	8a 10                	mov    (%eax),%dl
 294:	8b 45 0c             	mov    0xc(%ebp),%eax
 297:	8a 00                	mov    (%eax),%al
 299:	38 c2                	cmp    %al,%dl
 29b:	74 e3                	je     280 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
 2a0:	8a 00                	mov    (%eax),%al
 2a2:	0f b6 d0             	movzbl %al,%edx
 2a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a8:	8a 00                	mov    (%eax),%al
 2aa:	0f b6 c0             	movzbl %al,%eax
 2ad:	29 c2                	sub    %eax,%edx
 2af:	89 d0                	mov    %edx,%eax
}
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 2b6:	eb 09                	jmp    2c1 <strncmp+0xe>
    n--, p++, q++;
 2b8:	ff 4d 10             	decl   0x10(%ebp)
 2bb:	ff 45 08             	incl   0x8(%ebp)
 2be:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 2c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c5:	74 17                	je     2de <strncmp+0x2b>
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	8a 00                	mov    (%eax),%al
 2cc:	84 c0                	test   %al,%al
 2ce:	74 0e                	je     2de <strncmp+0x2b>
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	8a 10                	mov    (%eax),%dl
 2d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d8:	8a 00                	mov    (%eax),%al
 2da:	38 c2                	cmp    %al,%dl
 2dc:	74 da                	je     2b8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 2de:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2e2:	75 07                	jne    2eb <strncmp+0x38>
    return 0;
 2e4:	b8 00 00 00 00       	mov    $0x0,%eax
 2e9:	eb 14                	jmp    2ff <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 2eb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ee:	8a 00                	mov    (%eax),%al
 2f0:	0f b6 d0             	movzbl %al,%edx
 2f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f6:	8a 00                	mov    (%eax),%al
 2f8:	0f b6 c0             	movzbl %al,%eax
 2fb:	29 c2                	sub    %eax,%edx
 2fd:	89 d0                	mov    %edx,%eax
}
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    

00000301 <strlen>:

uint
strlen(const char *s)
{
 301:	55                   	push   %ebp
 302:	89 e5                	mov    %esp,%ebp
 304:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 307:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 30e:	eb 03                	jmp    313 <strlen+0x12>
 310:	ff 45 fc             	incl   -0x4(%ebp)
 313:	8b 55 fc             	mov    -0x4(%ebp),%edx
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	01 d0                	add    %edx,%eax
 31b:	8a 00                	mov    (%eax),%al
 31d:	84 c0                	test   %al,%al
 31f:	75 ef                	jne    310 <strlen+0xf>
    ;
  return n;
 321:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <memset>:

void*
memset(void *dst, int c, uint n)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 32c:	8b 45 10             	mov    0x10(%ebp),%eax
 32f:	89 44 24 08          	mov    %eax,0x8(%esp)
 333:	8b 45 0c             	mov    0xc(%ebp),%eax
 336:	89 44 24 04          	mov    %eax,0x4(%esp)
 33a:	8b 45 08             	mov    0x8(%ebp),%eax
 33d:	89 04 24             	mov    %eax,(%esp)
 340:	e8 cf fd ff ff       	call   114 <stosb>
  return dst;
 345:	8b 45 08             	mov    0x8(%ebp),%eax
}
 348:	c9                   	leave  
 349:	c3                   	ret    

0000034a <strchr>:

char*
strchr(const char *s, char c)
{
 34a:	55                   	push   %ebp
 34b:	89 e5                	mov    %esp,%ebp
 34d:	83 ec 04             	sub    $0x4,%esp
 350:	8b 45 0c             	mov    0xc(%ebp),%eax
 353:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 356:	eb 12                	jmp    36a <strchr+0x20>
    if(*s == c)
 358:	8b 45 08             	mov    0x8(%ebp),%eax
 35b:	8a 00                	mov    (%eax),%al
 35d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 360:	75 05                	jne    367 <strchr+0x1d>
      return (char*)s;
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	eb 11                	jmp    378 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 367:	ff 45 08             	incl   0x8(%ebp)
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
 36d:	8a 00                	mov    (%eax),%al
 36f:	84 c0                	test   %al,%al
 371:	75 e5                	jne    358 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 373:	b8 00 00 00 00       	mov    $0x0,%eax
}
 378:	c9                   	leave  
 379:	c3                   	ret    

0000037a <strcat>:

char *
strcat(char *dest, const char *src)
{
 37a:	55                   	push   %ebp
 37b:	89 e5                	mov    %esp,%ebp
 37d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 380:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 387:	eb 03                	jmp    38c <strcat+0x12>
 389:	ff 45 fc             	incl   -0x4(%ebp)
 38c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	01 d0                	add    %edx,%eax
 394:	8a 00                	mov    (%eax),%al
 396:	84 c0                	test   %al,%al
 398:	75 ef                	jne    389 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 39a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 3a1:	eb 1e                	jmp    3c1 <strcat+0x47>
        dest[i+j] = src[j];
 3a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a9:	01 d0                	add    %edx,%eax
 3ab:	89 c2                	mov    %eax,%edx
 3ad:	8b 45 08             	mov    0x8(%ebp),%eax
 3b0:	01 c2                	add    %eax,%edx
 3b2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	01 c8                	add    %ecx,%eax
 3ba:	8a 00                	mov    (%eax),%al
 3bc:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 3be:	ff 45 f8             	incl   -0x8(%ebp)
 3c1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c7:	01 d0                	add    %edx,%eax
 3c9:	8a 00                	mov    (%eax),%al
 3cb:	84 c0                	test   %al,%al
 3cd:	75 d4                	jne    3a3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 3cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d5:	01 d0                	add    %edx,%eax
 3d7:	89 c2                	mov    %eax,%edx
 3d9:	8b 45 08             	mov    0x8(%ebp),%eax
 3dc:	01 d0                	add    %edx,%eax
 3de:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <strstr>:

int 
strstr(char* s, char* sub)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3ec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3f3:	eb 7c                	jmp    471 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 3f5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f8:	8b 45 08             	mov    0x8(%ebp),%eax
 3fb:	01 d0                	add    %edx,%eax
 3fd:	8a 10                	mov    (%eax),%dl
 3ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 402:	8a 00                	mov    (%eax),%al
 404:	38 c2                	cmp    %al,%dl
 406:	75 66                	jne    46e <strstr+0x88>
        {
            if(strlen(sub) == 1)
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	89 04 24             	mov    %eax,(%esp)
 40e:	e8 ee fe ff ff       	call   301 <strlen>
 413:	83 f8 01             	cmp    $0x1,%eax
 416:	75 05                	jne    41d <strstr+0x37>
            {  
                return i;
 418:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41b:	eb 6b                	jmp    488 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 41d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 424:	eb 3a                	jmp    460 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 426:	8b 45 f8             	mov    -0x8(%ebp),%eax
 429:	8b 55 fc             	mov    -0x4(%ebp),%edx
 42c:	01 d0                	add    %edx,%eax
 42e:	89 c2                	mov    %eax,%edx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	01 d0                	add    %edx,%eax
 435:	8a 10                	mov    (%eax),%dl
 437:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 43a:	8b 45 0c             	mov    0xc(%ebp),%eax
 43d:	01 c8                	add    %ecx,%eax
 43f:	8a 00                	mov    (%eax),%al
 441:	38 c2                	cmp    %al,%dl
 443:	75 16                	jne    45b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 445:	8b 45 f8             	mov    -0x8(%ebp),%eax
 448:	8d 50 01             	lea    0x1(%eax),%edx
 44b:	8b 45 0c             	mov    0xc(%ebp),%eax
 44e:	01 d0                	add    %edx,%eax
 450:	8a 00                	mov    (%eax),%al
 452:	84 c0                	test   %al,%al
 454:	75 07                	jne    45d <strstr+0x77>
                    {
                        return i;
 456:	8b 45 fc             	mov    -0x4(%ebp),%eax
 459:	eb 2d                	jmp    488 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 45b:	eb 11                	jmp    46e <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 45d:	ff 45 f8             	incl   -0x8(%ebp)
 460:	8b 55 f8             	mov    -0x8(%ebp),%edx
 463:	8b 45 0c             	mov    0xc(%ebp),%eax
 466:	01 d0                	add    %edx,%eax
 468:	8a 00                	mov    (%eax),%al
 46a:	84 c0                	test   %al,%al
 46c:	75 b8                	jne    426 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 46e:	ff 45 fc             	incl   -0x4(%ebp)
 471:	8b 55 fc             	mov    -0x4(%ebp),%edx
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	01 d0                	add    %edx,%eax
 479:	8a 00                	mov    (%eax),%al
 47b:	84 c0                	test   %al,%al
 47d:	0f 85 72 ff ff ff    	jne    3f5 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 488:	c9                   	leave  
 489:	c3                   	ret    

0000048a <strtok>:

char *
strtok(char *s, const char *delim)
{
 48a:	55                   	push   %ebp
 48b:	89 e5                	mov    %esp,%ebp
 48d:	53                   	push   %ebx
 48e:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 491:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 495:	75 08                	jne    49f <strtok+0x15>
  s = lasts;
 497:	a1 70 0d 00 00       	mov    0xd70,%eax
 49c:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	8d 50 01             	lea    0x1(%eax),%edx
 4a5:	89 55 08             	mov    %edx,0x8(%ebp)
 4a8:	8a 00                	mov    (%eax),%al
 4aa:	0f be d8             	movsbl %al,%ebx
 4ad:	85 db                	test   %ebx,%ebx
 4af:	75 07                	jne    4b8 <strtok+0x2e>
      return 0;
 4b1:	b8 00 00 00 00       	mov    $0x0,%eax
 4b6:	eb 58                	jmp    510 <strtok+0x86>
    } while (strchr(delim, ch));
 4b8:	88 d8                	mov    %bl,%al
 4ba:	0f be c0             	movsbl %al,%eax
 4bd:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c4:	89 04 24             	mov    %eax,(%esp)
 4c7:	e8 7e fe ff ff       	call   34a <strchr>
 4cc:	85 c0                	test   %eax,%eax
 4ce:	75 cf                	jne    49f <strtok+0x15>
    --s;
 4d0:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 4d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	89 04 24             	mov    %eax,(%esp)
 4e0:	e8 31 00 00 00       	call   516 <strcspn>
 4e5:	89 c2                	mov    %eax,%edx
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	01 d0                	add    %edx,%eax
 4ec:	a3 70 0d 00 00       	mov    %eax,0xd70
    if (*lasts != 0)
 4f1:	a1 70 0d 00 00       	mov    0xd70,%eax
 4f6:	8a 00                	mov    (%eax),%al
 4f8:	84 c0                	test   %al,%al
 4fa:	74 11                	je     50d <strtok+0x83>
  *lasts++ = 0;
 4fc:	a1 70 0d 00 00       	mov    0xd70,%eax
 501:	8d 50 01             	lea    0x1(%eax),%edx
 504:	89 15 70 0d 00 00    	mov    %edx,0xd70
 50a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 510:	83 c4 14             	add    $0x14,%esp
 513:	5b                   	pop    %ebx
 514:	5d                   	pop    %ebp
 515:	c3                   	ret    

00000516 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 516:	55                   	push   %ebp
 517:	89 e5                	mov    %esp,%ebp
 519:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 51c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 523:	eb 26                	jmp    54b <strcspn+0x35>
        if(strchr(s2,*s1))
 525:	8b 45 08             	mov    0x8(%ebp),%eax
 528:	8a 00                	mov    (%eax),%al
 52a:	0f be c0             	movsbl %al,%eax
 52d:	89 44 24 04          	mov    %eax,0x4(%esp)
 531:	8b 45 0c             	mov    0xc(%ebp),%eax
 534:	89 04 24             	mov    %eax,(%esp)
 537:	e8 0e fe ff ff       	call   34a <strchr>
 53c:	85 c0                	test   %eax,%eax
 53e:	74 05                	je     545 <strcspn+0x2f>
            return ret;
 540:	8b 45 fc             	mov    -0x4(%ebp),%eax
 543:	eb 12                	jmp    557 <strcspn+0x41>
        else
            s1++,ret++;
 545:	ff 45 08             	incl   0x8(%ebp)
 548:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	8a 00                	mov    (%eax),%al
 550:	84 c0                	test   %al,%al
 552:	75 d1                	jne    525 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 554:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 557:	c9                   	leave  
 558:	c3                   	ret    

00000559 <isspace>:

int
isspace(unsigned char c)
{
 559:	55                   	push   %ebp
 55a:	89 e5                	mov    %esp,%ebp
 55c:	83 ec 04             	sub    $0x4,%esp
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 565:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 569:	74 1e                	je     589 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 56b:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 56f:	74 18                	je     589 <isspace+0x30>
 571:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 575:	74 12                	je     589 <isspace+0x30>
 577:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 57b:	74 0c                	je     589 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 57d:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 581:	74 06                	je     589 <isspace+0x30>
 583:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 587:	75 07                	jne    590 <isspace+0x37>
 589:	b8 01 00 00 00       	mov    $0x1,%eax
 58e:	eb 05                	jmp    595 <isspace+0x3c>
 590:	b8 00 00 00 00       	mov    $0x0,%eax
}
 595:	c9                   	leave  
 596:	c3                   	ret    

00000597 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 597:	55                   	push   %ebp
 598:	89 e5                	mov    %esp,%ebp
 59a:	57                   	push   %edi
 59b:	56                   	push   %esi
 59c:	53                   	push   %ebx
 59d:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 5a0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 5a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 5ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 5af:	eb 01                	jmp    5b2 <strtoul+0x1b>
  p += 1;
 5b1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 5b2:	8a 03                	mov    (%ebx),%al
 5b4:	0f b6 c0             	movzbl %al,%eax
 5b7:	89 04 24             	mov    %eax,(%esp)
 5ba:	e8 9a ff ff ff       	call   559 <isspace>
 5bf:	85 c0                	test   %eax,%eax
 5c1:	75 ee                	jne    5b1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 5c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5c7:	75 30                	jne    5f9 <strtoul+0x62>
    {
  if (*p == '0') {
 5c9:	8a 03                	mov    (%ebx),%al
 5cb:	3c 30                	cmp    $0x30,%al
 5cd:	75 21                	jne    5f0 <strtoul+0x59>
      p += 1;
 5cf:	43                   	inc    %ebx
      if (*p == 'x') {
 5d0:	8a 03                	mov    (%ebx),%al
 5d2:	3c 78                	cmp    $0x78,%al
 5d4:	75 0a                	jne    5e0 <strtoul+0x49>
    p += 1;
 5d6:	43                   	inc    %ebx
    base = 16;
 5d7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 5de:	eb 31                	jmp    611 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 5e0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 5e7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 5ee:	eb 21                	jmp    611 <strtoul+0x7a>
      }
  }
  else base = 10;
 5f0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 5f7:	eb 18                	jmp    611 <strtoul+0x7a>
    } else if (base == 16) {
 5f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5fd:	75 12                	jne    611 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 5ff:	8a 03                	mov    (%ebx),%al
 601:	3c 30                	cmp    $0x30,%al
 603:	75 0c                	jne    611 <strtoul+0x7a>
 605:	8d 43 01             	lea    0x1(%ebx),%eax
 608:	8a 00                	mov    (%eax),%al
 60a:	3c 78                	cmp    $0x78,%al
 60c:	75 03                	jne    611 <strtoul+0x7a>
      p += 2;
 60e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 611:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 615:	75 29                	jne    640 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 617:	8a 03                	mov    (%ebx),%al
 619:	0f be c0             	movsbl %al,%eax
 61c:	83 e8 30             	sub    $0x30,%eax
 61f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 621:	83 fe 07             	cmp    $0x7,%esi
 624:	76 06                	jbe    62c <strtoul+0x95>
    break;
 626:	90                   	nop
 627:	e9 b6 00 00 00       	jmp    6e2 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 62c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 633:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 636:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 63d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 63e:	eb d7                	jmp    617 <strtoul+0x80>
    } else if (base == 10) {
 640:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 644:	75 2b                	jne    671 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 646:	8a 03                	mov    (%ebx),%al
 648:	0f be c0             	movsbl %al,%eax
 64b:	83 e8 30             	sub    $0x30,%eax
 64e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 650:	83 fe 09             	cmp    $0x9,%esi
 653:	76 06                	jbe    65b <strtoul+0xc4>
    break;
 655:	90                   	nop
 656:	e9 87 00 00 00       	jmp    6e2 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 65b:	89 f8                	mov    %edi,%eax
 65d:	c1 e0 02             	shl    $0x2,%eax
 660:	01 f8                	add    %edi,%eax
 662:	01 c0                	add    %eax,%eax
 664:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 667:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 66e:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 66f:	eb d5                	jmp    646 <strtoul+0xaf>
    } else if (base == 16) {
 671:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 675:	75 35                	jne    6ac <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 677:	8a 03                	mov    (%ebx),%al
 679:	0f be c0             	movsbl %al,%eax
 67c:	83 e8 30             	sub    $0x30,%eax
 67f:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 681:	83 fe 4a             	cmp    $0x4a,%esi
 684:	76 02                	jbe    688 <strtoul+0xf1>
    break;
 686:	eb 22                	jmp    6aa <strtoul+0x113>
      }
      digit = cvtIn[digit];
 688:	8a 86 20 0d 00 00    	mov    0xd20(%esi),%al
 68e:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 691:	83 fe 0f             	cmp    $0xf,%esi
 694:	76 02                	jbe    698 <strtoul+0x101>
    break;
 696:	eb 12                	jmp    6aa <strtoul+0x113>
      }
      result = (result << 4) + digit;
 698:	89 f8                	mov    %edi,%eax
 69a:	c1 e0 04             	shl    $0x4,%eax
 69d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 6a7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 6a8:	eb cd                	jmp    677 <strtoul+0xe0>
 6aa:	eb 36                	jmp    6e2 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 6ac:	8a 03                	mov    (%ebx),%al
 6ae:	0f be c0             	movsbl %al,%eax
 6b1:	83 e8 30             	sub    $0x30,%eax
 6b4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6b6:	83 fe 4a             	cmp    $0x4a,%esi
 6b9:	76 02                	jbe    6bd <strtoul+0x126>
    break;
 6bb:	eb 25                	jmp    6e2 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 6bd:	8a 86 20 0d 00 00    	mov    0xd20(%esi),%al
 6c3:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 6c6:	8b 45 10             	mov    0x10(%ebp),%eax
 6c9:	39 f0                	cmp    %esi,%eax
 6cb:	77 02                	ja     6cf <strtoul+0x138>
    break;
 6cd:	eb 13                	jmp    6e2 <strtoul+0x14b>
      }
      result = result*base + digit;
 6cf:	8b 45 10             	mov    0x10(%ebp),%eax
 6d2:	0f af c7             	imul   %edi,%eax
 6d5:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 6df:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 6e0:	eb ca                	jmp    6ac <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 6e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6e6:	75 03                	jne    6eb <strtoul+0x154>
  p = string;
 6e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 6eb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ef:	74 05                	je     6f6 <strtoul+0x15f>
  *endPtr = p;
 6f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f4:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 6f6:	89 f8                	mov    %edi,%eax
}
 6f8:	83 c4 14             	add    $0x14,%esp
 6fb:	5b                   	pop    %ebx
 6fc:	5e                   	pop    %esi
 6fd:	5f                   	pop    %edi
 6fe:	5d                   	pop    %ebp
 6ff:	c3                   	ret    

00000700 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 700:	55                   	push   %ebp
 701:	89 e5                	mov    %esp,%ebp
 703:	53                   	push   %ebx
 704:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 707:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 70a:	eb 01                	jmp    70d <strtol+0xd>
      p += 1;
 70c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 70d:	8a 03                	mov    (%ebx),%al
 70f:	0f b6 c0             	movzbl %al,%eax
 712:	89 04 24             	mov    %eax,(%esp)
 715:	e8 3f fe ff ff       	call   559 <isspace>
 71a:	85 c0                	test   %eax,%eax
 71c:	75 ee                	jne    70c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 71e:	8a 03                	mov    (%ebx),%al
 720:	3c 2d                	cmp    $0x2d,%al
 722:	75 1e                	jne    742 <strtol+0x42>
  p += 1;
 724:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 725:	8b 45 10             	mov    0x10(%ebp),%eax
 728:	89 44 24 08          	mov    %eax,0x8(%esp)
 72c:	8b 45 0c             	mov    0xc(%ebp),%eax
 72f:	89 44 24 04          	mov    %eax,0x4(%esp)
 733:	89 1c 24             	mov    %ebx,(%esp)
 736:	e8 5c fe ff ff       	call   597 <strtoul>
 73b:	f7 d8                	neg    %eax
 73d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 740:	eb 20                	jmp    762 <strtol+0x62>
    } else {
  if (*p == '+') {
 742:	8a 03                	mov    (%ebx),%al
 744:	3c 2b                	cmp    $0x2b,%al
 746:	75 01                	jne    749 <strtol+0x49>
      p += 1;
 748:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 749:	8b 45 10             	mov    0x10(%ebp),%eax
 74c:	89 44 24 08          	mov    %eax,0x8(%esp)
 750:	8b 45 0c             	mov    0xc(%ebp),%eax
 753:	89 44 24 04          	mov    %eax,0x4(%esp)
 757:	89 1c 24             	mov    %ebx,(%esp)
 75a:	e8 38 fe ff ff       	call   597 <strtoul>
 75f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 762:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 766:	75 17                	jne    77f <strtol+0x7f>
 768:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 76c:	74 11                	je     77f <strtol+0x7f>
 76e:	8b 45 0c             	mov    0xc(%ebp),%eax
 771:	8b 00                	mov    (%eax),%eax
 773:	39 d8                	cmp    %ebx,%eax
 775:	75 08                	jne    77f <strtol+0x7f>
  *endPtr = string;
 777:	8b 45 0c             	mov    0xc(%ebp),%eax
 77a:	8b 55 08             	mov    0x8(%ebp),%edx
 77d:	89 10                	mov    %edx,(%eax)
    }
    return result;
 77f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 782:	83 c4 1c             	add    $0x1c,%esp
 785:	5b                   	pop    %ebx
 786:	5d                   	pop    %ebp
 787:	c3                   	ret    

00000788 <gets>:

char*
gets(char *buf, int max)
{
 788:	55                   	push   %ebp
 789:	89 e5                	mov    %esp,%ebp
 78b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 78e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 795:	eb 49                	jmp    7e0 <gets+0x58>
    cc = read(0, &c, 1);
 797:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 79e:	00 
 79f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 7a2:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7ad:	e8 3e 01 00 00       	call   8f0 <read>
 7b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 7b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7b9:	7f 02                	jg     7bd <gets+0x35>
      break;
 7bb:	eb 2c                	jmp    7e9 <gets+0x61>
    buf[i++] = c;
 7bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c0:	8d 50 01             	lea    0x1(%eax),%edx
 7c3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7c6:	89 c2                	mov    %eax,%edx
 7c8:	8b 45 08             	mov    0x8(%ebp),%eax
 7cb:	01 c2                	add    %eax,%edx
 7cd:	8a 45 ef             	mov    -0x11(%ebp),%al
 7d0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 7d2:	8a 45 ef             	mov    -0x11(%ebp),%al
 7d5:	3c 0a                	cmp    $0xa,%al
 7d7:	74 10                	je     7e9 <gets+0x61>
 7d9:	8a 45 ef             	mov    -0x11(%ebp),%al
 7dc:	3c 0d                	cmp    $0xd,%al
 7de:	74 09                	je     7e9 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e3:	40                   	inc    %eax
 7e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7e7:	7c ae                	jl     797 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	01 d0                	add    %edx,%eax
 7f1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7f7:	c9                   	leave  
 7f8:	c3                   	ret    

000007f9 <stat>:

int
stat(char *n, struct stat *st)
{
 7f9:	55                   	push   %ebp
 7fa:	89 e5                	mov    %esp,%ebp
 7fc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 806:	00 
 807:	8b 45 08             	mov    0x8(%ebp),%eax
 80a:	89 04 24             	mov    %eax,(%esp)
 80d:	e8 06 01 00 00       	call   918 <open>
 812:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 815:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 819:	79 07                	jns    822 <stat+0x29>
    return -1;
 81b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 820:	eb 23                	jmp    845 <stat+0x4c>
  r = fstat(fd, st);
 822:	8b 45 0c             	mov    0xc(%ebp),%eax
 825:	89 44 24 04          	mov    %eax,0x4(%esp)
 829:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82c:	89 04 24             	mov    %eax,(%esp)
 82f:	e8 fc 00 00 00       	call   930 <fstat>
 834:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 837:	8b 45 f4             	mov    -0xc(%ebp),%eax
 83a:	89 04 24             	mov    %eax,(%esp)
 83d:	e8 be 00 00 00       	call   900 <close>
  return r;
 842:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 845:	c9                   	leave  
 846:	c3                   	ret    

00000847 <atoi>:

int
atoi(const char *s)
{
 847:	55                   	push   %ebp
 848:	89 e5                	mov    %esp,%ebp
 84a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 84d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 854:	eb 24                	jmp    87a <atoi+0x33>
    n = n*10 + *s++ - '0';
 856:	8b 55 fc             	mov    -0x4(%ebp),%edx
 859:	89 d0                	mov    %edx,%eax
 85b:	c1 e0 02             	shl    $0x2,%eax
 85e:	01 d0                	add    %edx,%eax
 860:	01 c0                	add    %eax,%eax
 862:	89 c1                	mov    %eax,%ecx
 864:	8b 45 08             	mov    0x8(%ebp),%eax
 867:	8d 50 01             	lea    0x1(%eax),%edx
 86a:	89 55 08             	mov    %edx,0x8(%ebp)
 86d:	8a 00                	mov    (%eax),%al
 86f:	0f be c0             	movsbl %al,%eax
 872:	01 c8                	add    %ecx,%eax
 874:	83 e8 30             	sub    $0x30,%eax
 877:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	8a 00                	mov    (%eax),%al
 87f:	3c 2f                	cmp    $0x2f,%al
 881:	7e 09                	jle    88c <atoi+0x45>
 883:	8b 45 08             	mov    0x8(%ebp),%eax
 886:	8a 00                	mov    (%eax),%al
 888:	3c 39                	cmp    $0x39,%al
 88a:	7e ca                	jle    856 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 88c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 88f:	c9                   	leave  
 890:	c3                   	ret    

00000891 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 891:	55                   	push   %ebp
 892:	89 e5                	mov    %esp,%ebp
 894:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 89d:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 8a3:	eb 16                	jmp    8bb <memmove+0x2a>
    *dst++ = *src++;
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	8d 50 01             	lea    0x1(%eax),%edx
 8ab:	89 55 fc             	mov    %edx,-0x4(%ebp)
 8ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8b1:	8d 4a 01             	lea    0x1(%edx),%ecx
 8b4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 8b7:	8a 12                	mov    (%edx),%dl
 8b9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8bb:	8b 45 10             	mov    0x10(%ebp),%eax
 8be:	8d 50 ff             	lea    -0x1(%eax),%edx
 8c1:	89 55 10             	mov    %edx,0x10(%ebp)
 8c4:	85 c0                	test   %eax,%eax
 8c6:	7f dd                	jg     8a5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8cb:	c9                   	leave  
 8cc:	c3                   	ret    
 8cd:	90                   	nop
 8ce:	90                   	nop
 8cf:	90                   	nop

000008d0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8d0:	b8 01 00 00 00       	mov    $0x1,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <exit>:
SYSCALL(exit)
 8d8:	b8 02 00 00 00       	mov    $0x2,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <wait>:
SYSCALL(wait)
 8e0:	b8 03 00 00 00       	mov    $0x3,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <pipe>:
SYSCALL(pipe)
 8e8:	b8 04 00 00 00       	mov    $0x4,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <read>:
SYSCALL(read)
 8f0:	b8 05 00 00 00       	mov    $0x5,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <write>:
SYSCALL(write)
 8f8:	b8 10 00 00 00       	mov    $0x10,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <close>:
SYSCALL(close)
 900:	b8 15 00 00 00       	mov    $0x15,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <kill>:
SYSCALL(kill)
 908:	b8 06 00 00 00       	mov    $0x6,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <exec>:
SYSCALL(exec)
 910:	b8 07 00 00 00       	mov    $0x7,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <open>:
SYSCALL(open)
 918:	b8 0f 00 00 00       	mov    $0xf,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <mknod>:
SYSCALL(mknod)
 920:	b8 11 00 00 00       	mov    $0x11,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <unlink>:
SYSCALL(unlink)
 928:	b8 12 00 00 00       	mov    $0x12,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <fstat>:
SYSCALL(fstat)
 930:	b8 08 00 00 00       	mov    $0x8,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <link>:
SYSCALL(link)
 938:	b8 13 00 00 00       	mov    $0x13,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <mkdir>:
SYSCALL(mkdir)
 940:	b8 14 00 00 00       	mov    $0x14,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <chdir>:
SYSCALL(chdir)
 948:	b8 09 00 00 00       	mov    $0x9,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <dup>:
SYSCALL(dup)
 950:	b8 0a 00 00 00       	mov    $0xa,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <getpid>:
SYSCALL(getpid)
 958:	b8 0b 00 00 00       	mov    $0xb,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <sbrk>:
SYSCALL(sbrk)
 960:	b8 0c 00 00 00       	mov    $0xc,%eax
 965:	cd 40                	int    $0x40
 967:	c3                   	ret    

00000968 <sleep>:
SYSCALL(sleep)
 968:	b8 0d 00 00 00       	mov    $0xd,%eax
 96d:	cd 40                	int    $0x40
 96f:	c3                   	ret    

00000970 <uptime>:
SYSCALL(uptime)
 970:	b8 0e 00 00 00       	mov    $0xe,%eax
 975:	cd 40                	int    $0x40
 977:	c3                   	ret    
