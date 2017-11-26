
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
   c:	e8 dc 02 00 00       	call   2ed <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 bd 08 00 00       	call   8e4 <write>
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
  2f:	c7 44 24 04 c4 09 00 	movl   $0x9c4,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 1e                	jmp    6a <forktest+0x41>
    pid = fork();
  4c:	e8 6b 08 00 00       	call   8bc <fork>
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
  62:	e8 5d 08 00 00       	call   8c4 <exit>
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
  84:	c7 44 24 04 d0 09 00 	movl   $0x9d0,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 68 ff ff ff       	call   0 <printf>
    exit();
  98:	e8 27 08 00 00       	call   8c4 <exit>
  }

  for(; n > 0; n--){
  9d:	eb 25                	jmp    c4 <forktest+0x9b>
    if(wait() < 0){
  9f:	e8 28 08 00 00       	call   8cc <wait>
  a4:	85 c0                	test   %eax,%eax
  a6:	79 19                	jns    c1 <forktest+0x98>
      printf(1, "wait stopped early\n");
  a8:	c7 44 24 04 ef 09 00 	movl   $0x9ef,0x4(%esp)
  af:	00 
  b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b7:	e8 44 ff ff ff       	call   0 <printf>
      exit();
  bc:	e8 03 08 00 00       	call   8c4 <exit>
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
  ca:	e8 fd 07 00 00       	call   8cc <wait>
  cf:	83 f8 ff             	cmp    $0xffffffff,%eax
  d2:	74 19                	je     ed <forktest+0xc4>
    printf(1, "wait got too many\n");
  d4:	c7 44 24 04 03 0a 00 	movl   $0xa03,0x4(%esp)
  db:	00 
  dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e3:	e8 18 ff ff ff       	call   0 <printf>
    exit();
  e8:	e8 d7 07 00 00       	call   8c4 <exit>
  }

  printf(1, "fork test OK\n");
  ed:	c7 44 24 04 16 0a 00 	movl   $0xa16,0x4(%esp)
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
 10e:	e8 b1 07 00 00       	call   8c4 <exit>
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

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
 16d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
 174:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 17b:	00 
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	89 04 24             	mov    %eax,(%esp)
 182:	e8 7d 07 00 00       	call   904 <open>
 187:	89 45 f0             	mov    %eax,-0x10(%ebp)
 18a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 18e:	79 20                	jns    1b0 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	89 44 24 08          	mov    %eax,0x8(%esp)
 197:	c7 44 24 04 24 0a 00 	movl   $0xa24,0x4(%esp)
 19e:	00 
 19f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a6:	e8 55 fe ff ff       	call   0 <printf>
      exit();
 1ab:	e8 14 07 00 00       	call   8c4 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 1b0:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 1b7:	00 
 1b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bb:	89 04 24             	mov    %eax,(%esp)
 1be:	e8 41 07 00 00       	call   904 <open>
 1c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1ca:	79 20                	jns    1ec <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 1cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1cf:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d3:	c7 44 24 04 3f 0a 00 	movl   $0xa3f,0x4(%esp)
 1da:	00 
 1db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1e2:	e8 19 fe ff ff       	call   0 <printf>
      exit();
 1e7:	e8 d8 06 00 00       	call   8c4 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 1ec:	eb 3b                	jmp    229 <copy+0xc2>
  {
      max = used_disk+=count;
 1ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 1f1:	01 45 10             	add    %eax,0x10(%ebp)
 1f4:	8b 45 10             	mov    0x10(%ebp),%eax
 1f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 1fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1fd:	3b 45 14             	cmp    0x14(%ebp),%eax
 200:	7e 07                	jle    209 <copy+0xa2>
      {
        return -1;
 202:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 207:	eb 5c                	jmp    265 <copy+0xfe>
      }
      bytes = bytes + count;
 209:	8b 45 e8             	mov    -0x18(%ebp),%eax
 20c:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 20f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 216:	00 
 217:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 21a:	89 44 24 04          	mov    %eax,0x4(%esp)
 21e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 221:	89 04 24             	mov    %eax,(%esp)
 224:	e8 bb 06 00 00       	call   8e4 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 229:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 230:	00 
 231:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 234:	89 44 24 04          	mov    %eax,0x4(%esp)
 238:	8b 45 f0             	mov    -0x10(%ebp),%eax
 23b:	89 04 24             	mov    %eax,(%esp)
 23e:	e8 99 06 00 00       	call   8dc <read>
 243:	89 45 e8             	mov    %eax,-0x18(%ebp)
 246:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 24a:	7f a2                	jg     1ee <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 24c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 95 06 00 00       	call   8ec <close>
  close(fd2);
 257:	8b 45 ec             	mov    -0x14(%ebp),%eax
 25a:	89 04 24             	mov    %eax,(%esp)
 25d:	e8 8a 06 00 00       	call   8ec <close>
  return(bytes);
 262:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 265:	c9                   	leave  
 266:	c3                   	ret    

00000267 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 267:	55                   	push   %ebp
 268:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 26a:	eb 06                	jmp    272 <strcmp+0xb>
    p++, q++;
 26c:	ff 45 08             	incl   0x8(%ebp)
 26f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	8a 00                	mov    (%eax),%al
 277:	84 c0                	test   %al,%al
 279:	74 0e                	je     289 <strcmp+0x22>
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	8a 10                	mov    (%eax),%dl
 280:	8b 45 0c             	mov    0xc(%ebp),%eax
 283:	8a 00                	mov    (%eax),%al
 285:	38 c2                	cmp    %al,%dl
 287:	74 e3                	je     26c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 289:	8b 45 08             	mov    0x8(%ebp),%eax
 28c:	8a 00                	mov    (%eax),%al
 28e:	0f b6 d0             	movzbl %al,%edx
 291:	8b 45 0c             	mov    0xc(%ebp),%eax
 294:	8a 00                	mov    (%eax),%al
 296:	0f b6 c0             	movzbl %al,%eax
 299:	29 c2                	sub    %eax,%edx
 29b:	89 d0                	mov    %edx,%eax
}
 29d:	5d                   	pop    %ebp
 29e:	c3                   	ret    

0000029f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 29f:	55                   	push   %ebp
 2a0:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 2a2:	eb 09                	jmp    2ad <strncmp+0xe>
    n--, p++, q++;
 2a4:	ff 4d 10             	decl   0x10(%ebp)
 2a7:	ff 45 08             	incl   0x8(%ebp)
 2aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 2ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2b1:	74 17                	je     2ca <strncmp+0x2b>
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	8a 00                	mov    (%eax),%al
 2b8:	84 c0                	test   %al,%al
 2ba:	74 0e                	je     2ca <strncmp+0x2b>
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
 2bf:	8a 10                	mov    (%eax),%dl
 2c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c4:	8a 00                	mov    (%eax),%al
 2c6:	38 c2                	cmp    %al,%dl
 2c8:	74 da                	je     2a4 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 2ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ce:	75 07                	jne    2d7 <strncmp+0x38>
    return 0;
 2d0:	b8 00 00 00 00       	mov    $0x0,%eax
 2d5:	eb 14                	jmp    2eb <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	8a 00                	mov    (%eax),%al
 2dc:	0f b6 d0             	movzbl %al,%edx
 2df:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e2:	8a 00                	mov    (%eax),%al
 2e4:	0f b6 c0             	movzbl %al,%eax
 2e7:	29 c2                	sub    %eax,%edx
 2e9:	89 d0                	mov    %edx,%eax
}
 2eb:	5d                   	pop    %ebp
 2ec:	c3                   	ret    

000002ed <strlen>:

uint
strlen(const char *s)
{
 2ed:	55                   	push   %ebp
 2ee:	89 e5                	mov    %esp,%ebp
 2f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2fa:	eb 03                	jmp    2ff <strlen+0x12>
 2fc:	ff 45 fc             	incl   -0x4(%ebp)
 2ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	01 d0                	add    %edx,%eax
 307:	8a 00                	mov    (%eax),%al
 309:	84 c0                	test   %al,%al
 30b:	75 ef                	jne    2fc <strlen+0xf>
    ;
  return n;
 30d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <memset>:

void*
memset(void *dst, int c, uint n)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	89 44 24 08          	mov    %eax,0x8(%esp)
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 44 24 04          	mov    %eax,0x4(%esp)
 326:	8b 45 08             	mov    0x8(%ebp),%eax
 329:	89 04 24             	mov    %eax,(%esp)
 32c:	e8 e3 fd ff ff       	call   114 <stosb>
  return dst;
 331:	8b 45 08             	mov    0x8(%ebp),%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <strchr>:

char*
strchr(const char *s, char c)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 04             	sub    $0x4,%esp
 33c:	8b 45 0c             	mov    0xc(%ebp),%eax
 33f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 342:	eb 12                	jmp    356 <strchr+0x20>
    if(*s == c)
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8a 00                	mov    (%eax),%al
 349:	3a 45 fc             	cmp    -0x4(%ebp),%al
 34c:	75 05                	jne    353 <strchr+0x1d>
      return (char*)s;
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	eb 11                	jmp    364 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 353:	ff 45 08             	incl   0x8(%ebp)
 356:	8b 45 08             	mov    0x8(%ebp),%eax
 359:	8a 00                	mov    (%eax),%al
 35b:	84 c0                	test   %al,%al
 35d:	75 e5                	jne    344 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 35f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 364:	c9                   	leave  
 365:	c3                   	ret    

00000366 <strcat>:

char *
strcat(char *dest, const char *src)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 36c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 373:	eb 03                	jmp    378 <strcat+0x12>
 375:	ff 45 fc             	incl   -0x4(%ebp)
 378:	8b 55 fc             	mov    -0x4(%ebp),%edx
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	01 d0                	add    %edx,%eax
 380:	8a 00                	mov    (%eax),%al
 382:	84 c0                	test   %al,%al
 384:	75 ef                	jne    375 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 386:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 38d:	eb 1e                	jmp    3ad <strcat+0x47>
        dest[i+j] = src[j];
 38f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 392:	8b 55 fc             	mov    -0x4(%ebp),%edx
 395:	01 d0                	add    %edx,%eax
 397:	89 c2                	mov    %eax,%edx
 399:	8b 45 08             	mov    0x8(%ebp),%eax
 39c:	01 c2                	add    %eax,%edx
 39e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a4:	01 c8                	add    %ecx,%eax
 3a6:	8a 00                	mov    (%eax),%al
 3a8:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 3aa:	ff 45 f8             	incl   -0x8(%ebp)
 3ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b3:	01 d0                	add    %edx,%eax
 3b5:	8a 00                	mov    (%eax),%al
 3b7:	84 c0                	test   %al,%al
 3b9:	75 d4                	jne    38f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 3bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c1:	01 d0                	add    %edx,%eax
 3c3:	89 c2                	mov    %eax,%edx
 3c5:	8b 45 08             	mov    0x8(%ebp),%eax
 3c8:	01 d0                	add    %edx,%eax
 3ca:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <strstr>:

int 
strstr(char* s, char* sub)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3df:	eb 7c                	jmp    45d <strstr+0x8b>
    {
        if(s[i] == sub[0])
 3e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e4:	8b 45 08             	mov    0x8(%ebp),%eax
 3e7:	01 d0                	add    %edx,%eax
 3e9:	8a 10                	mov    (%eax),%dl
 3eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ee:	8a 00                	mov    (%eax),%al
 3f0:	38 c2                	cmp    %al,%dl
 3f2:	75 66                	jne    45a <strstr+0x88>
        {
            if(strlen(sub) == 1)
 3f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f7:	89 04 24             	mov    %eax,(%esp)
 3fa:	e8 ee fe ff ff       	call   2ed <strlen>
 3ff:	83 f8 01             	cmp    $0x1,%eax
 402:	75 05                	jne    409 <strstr+0x37>
            {  
                return i;
 404:	8b 45 fc             	mov    -0x4(%ebp),%eax
 407:	eb 6b                	jmp    474 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 409:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 410:	eb 3a                	jmp    44c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 412:	8b 45 f8             	mov    -0x8(%ebp),%eax
 415:	8b 55 fc             	mov    -0x4(%ebp),%edx
 418:	01 d0                	add    %edx,%eax
 41a:	89 c2                	mov    %eax,%edx
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	01 d0                	add    %edx,%eax
 421:	8a 10                	mov    (%eax),%dl
 423:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 426:	8b 45 0c             	mov    0xc(%ebp),%eax
 429:	01 c8                	add    %ecx,%eax
 42b:	8a 00                	mov    (%eax),%al
 42d:	38 c2                	cmp    %al,%dl
 42f:	75 16                	jne    447 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 431:	8b 45 f8             	mov    -0x8(%ebp),%eax
 434:	8d 50 01             	lea    0x1(%eax),%edx
 437:	8b 45 0c             	mov    0xc(%ebp),%eax
 43a:	01 d0                	add    %edx,%eax
 43c:	8a 00                	mov    (%eax),%al
 43e:	84 c0                	test   %al,%al
 440:	75 07                	jne    449 <strstr+0x77>
                    {
                        return i;
 442:	8b 45 fc             	mov    -0x4(%ebp),%eax
 445:	eb 2d                	jmp    474 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 447:	eb 11                	jmp    45a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 449:	ff 45 f8             	incl   -0x8(%ebp)
 44c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	8a 00                	mov    (%eax),%al
 456:	84 c0                	test   %al,%al
 458:	75 b8                	jne    412 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 45a:	ff 45 fc             	incl   -0x4(%ebp)
 45d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 460:	8b 45 08             	mov    0x8(%ebp),%eax
 463:	01 d0                	add    %edx,%eax
 465:	8a 00                	mov    (%eax),%al
 467:	84 c0                	test   %al,%al
 469:	0f 85 72 ff ff ff    	jne    3e1 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 46f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 474:	c9                   	leave  
 475:	c3                   	ret    

00000476 <strtok>:

char *
strtok(char *s, const char *delim)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	53                   	push   %ebx
 47a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 47d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 481:	75 08                	jne    48b <strtok+0x15>
  s = lasts;
 483:	a1 b0 0d 00 00       	mov    0xdb0,%eax
 488:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	8d 50 01             	lea    0x1(%eax),%edx
 491:	89 55 08             	mov    %edx,0x8(%ebp)
 494:	8a 00                	mov    (%eax),%al
 496:	0f be d8             	movsbl %al,%ebx
 499:	85 db                	test   %ebx,%ebx
 49b:	75 07                	jne    4a4 <strtok+0x2e>
      return 0;
 49d:	b8 00 00 00 00       	mov    $0x0,%eax
 4a2:	eb 58                	jmp    4fc <strtok+0x86>
    } while (strchr(delim, ch));
 4a4:	88 d8                	mov    %bl,%al
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b0:	89 04 24             	mov    %eax,(%esp)
 4b3:	e8 7e fe ff ff       	call   336 <strchr>
 4b8:	85 c0                	test   %eax,%eax
 4ba:	75 cf                	jne    48b <strtok+0x15>
    --s;
 4bc:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 4bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 4c6:	8b 45 08             	mov    0x8(%ebp),%eax
 4c9:	89 04 24             	mov    %eax,(%esp)
 4cc:	e8 31 00 00 00       	call   502 <strcspn>
 4d1:	89 c2                	mov    %eax,%edx
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	01 d0                	add    %edx,%eax
 4d8:	a3 b0 0d 00 00       	mov    %eax,0xdb0
    if (*lasts != 0)
 4dd:	a1 b0 0d 00 00       	mov    0xdb0,%eax
 4e2:	8a 00                	mov    (%eax),%al
 4e4:	84 c0                	test   %al,%al
 4e6:	74 11                	je     4f9 <strtok+0x83>
  *lasts++ = 0;
 4e8:	a1 b0 0d 00 00       	mov    0xdb0,%eax
 4ed:	8d 50 01             	lea    0x1(%eax),%edx
 4f0:	89 15 b0 0d 00 00    	mov    %edx,0xdb0
 4f6:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 4f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4fc:	83 c4 14             	add    $0x14,%esp
 4ff:	5b                   	pop    %ebx
 500:	5d                   	pop    %ebp
 501:	c3                   	ret    

00000502 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 508:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 50f:	eb 26                	jmp    537 <strcspn+0x35>
        if(strchr(s2,*s1))
 511:	8b 45 08             	mov    0x8(%ebp),%eax
 514:	8a 00                	mov    (%eax),%al
 516:	0f be c0             	movsbl %al,%eax
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	8b 45 0c             	mov    0xc(%ebp),%eax
 520:	89 04 24             	mov    %eax,(%esp)
 523:	e8 0e fe ff ff       	call   336 <strchr>
 528:	85 c0                	test   %eax,%eax
 52a:	74 05                	je     531 <strcspn+0x2f>
            return ret;
 52c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 52f:	eb 12                	jmp    543 <strcspn+0x41>
        else
            s1++,ret++;
 531:	ff 45 08             	incl   0x8(%ebp)
 534:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 537:	8b 45 08             	mov    0x8(%ebp),%eax
 53a:	8a 00                	mov    (%eax),%al
 53c:	84 c0                	test   %al,%al
 53e:	75 d1                	jne    511 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 540:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 543:	c9                   	leave  
 544:	c3                   	ret    

00000545 <isspace>:

int
isspace(unsigned char c)
{
 545:	55                   	push   %ebp
 546:	89 e5                	mov    %esp,%ebp
 548:	83 ec 04             	sub    $0x4,%esp
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 551:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 555:	74 1e                	je     575 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 557:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 55b:	74 18                	je     575 <isspace+0x30>
 55d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 561:	74 12                	je     575 <isspace+0x30>
 563:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 567:	74 0c                	je     575 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 569:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 56d:	74 06                	je     575 <isspace+0x30>
 56f:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 573:	75 07                	jne    57c <isspace+0x37>
 575:	b8 01 00 00 00       	mov    $0x1,%eax
 57a:	eb 05                	jmp    581 <isspace+0x3c>
 57c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 581:	c9                   	leave  
 582:	c3                   	ret    

00000583 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 583:	55                   	push   %ebp
 584:	89 e5                	mov    %esp,%ebp
 586:	57                   	push   %edi
 587:	56                   	push   %esi
 588:	53                   	push   %ebx
 589:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 58c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 591:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 598:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 59b:	eb 01                	jmp    59e <strtoul+0x1b>
  p += 1;
 59d:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 59e:	8a 03                	mov    (%ebx),%al
 5a0:	0f b6 c0             	movzbl %al,%eax
 5a3:	89 04 24             	mov    %eax,(%esp)
 5a6:	e8 9a ff ff ff       	call   545 <isspace>
 5ab:	85 c0                	test   %eax,%eax
 5ad:	75 ee                	jne    59d <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 5af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5b3:	75 30                	jne    5e5 <strtoul+0x62>
    {
  if (*p == '0') {
 5b5:	8a 03                	mov    (%ebx),%al
 5b7:	3c 30                	cmp    $0x30,%al
 5b9:	75 21                	jne    5dc <strtoul+0x59>
      p += 1;
 5bb:	43                   	inc    %ebx
      if (*p == 'x') {
 5bc:	8a 03                	mov    (%ebx),%al
 5be:	3c 78                	cmp    $0x78,%al
 5c0:	75 0a                	jne    5cc <strtoul+0x49>
    p += 1;
 5c2:	43                   	inc    %ebx
    base = 16;
 5c3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 5ca:	eb 31                	jmp    5fd <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 5cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 5d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 5da:	eb 21                	jmp    5fd <strtoul+0x7a>
      }
  }
  else base = 10;
 5dc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 5e3:	eb 18                	jmp    5fd <strtoul+0x7a>
    } else if (base == 16) {
 5e5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5e9:	75 12                	jne    5fd <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 5eb:	8a 03                	mov    (%ebx),%al
 5ed:	3c 30                	cmp    $0x30,%al
 5ef:	75 0c                	jne    5fd <strtoul+0x7a>
 5f1:	8d 43 01             	lea    0x1(%ebx),%eax
 5f4:	8a 00                	mov    (%eax),%al
 5f6:	3c 78                	cmp    $0x78,%al
 5f8:	75 03                	jne    5fd <strtoul+0x7a>
      p += 2;
 5fa:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 5fd:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 601:	75 29                	jne    62c <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 603:	8a 03                	mov    (%ebx),%al
 605:	0f be c0             	movsbl %al,%eax
 608:	83 e8 30             	sub    $0x30,%eax
 60b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 60d:	83 fe 07             	cmp    $0x7,%esi
 610:	76 06                	jbe    618 <strtoul+0x95>
    break;
 612:	90                   	nop
 613:	e9 b6 00 00 00       	jmp    6ce <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 618:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 61f:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 622:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 629:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 62a:	eb d7                	jmp    603 <strtoul+0x80>
    } else if (base == 10) {
 62c:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 630:	75 2b                	jne    65d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 632:	8a 03                	mov    (%ebx),%al
 634:	0f be c0             	movsbl %al,%eax
 637:	83 e8 30             	sub    $0x30,%eax
 63a:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 63c:	83 fe 09             	cmp    $0x9,%esi
 63f:	76 06                	jbe    647 <strtoul+0xc4>
    break;
 641:	90                   	nop
 642:	e9 87 00 00 00       	jmp    6ce <strtoul+0x14b>
      }
      result = (10*result) + digit;
 647:	89 f8                	mov    %edi,%eax
 649:	c1 e0 02             	shl    $0x2,%eax
 64c:	01 f8                	add    %edi,%eax
 64e:	01 c0                	add    %eax,%eax
 650:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 653:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 65a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 65b:	eb d5                	jmp    632 <strtoul+0xaf>
    } else if (base == 16) {
 65d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 661:	75 35                	jne    698 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 663:	8a 03                	mov    (%ebx),%al
 665:	0f be c0             	movsbl %al,%eax
 668:	83 e8 30             	sub    $0x30,%eax
 66b:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 66d:	83 fe 4a             	cmp    $0x4a,%esi
 670:	76 02                	jbe    674 <strtoul+0xf1>
    break;
 672:	eb 22                	jmp    696 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 674:	8a 86 60 0d 00 00    	mov    0xd60(%esi),%al
 67a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 67d:	83 fe 0f             	cmp    $0xf,%esi
 680:	76 02                	jbe    684 <strtoul+0x101>
    break;
 682:	eb 12                	jmp    696 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 684:	89 f8                	mov    %edi,%eax
 686:	c1 e0 04             	shl    $0x4,%eax
 689:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 68c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 693:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 694:	eb cd                	jmp    663 <strtoul+0xe0>
 696:	eb 36                	jmp    6ce <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 698:	8a 03                	mov    (%ebx),%al
 69a:	0f be c0             	movsbl %al,%eax
 69d:	83 e8 30             	sub    $0x30,%eax
 6a0:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6a2:	83 fe 4a             	cmp    $0x4a,%esi
 6a5:	76 02                	jbe    6a9 <strtoul+0x126>
    break;
 6a7:	eb 25                	jmp    6ce <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 6a9:	8a 86 60 0d 00 00    	mov    0xd60(%esi),%al
 6af:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 6b2:	8b 45 10             	mov    0x10(%ebp),%eax
 6b5:	39 f0                	cmp    %esi,%eax
 6b7:	77 02                	ja     6bb <strtoul+0x138>
    break;
 6b9:	eb 13                	jmp    6ce <strtoul+0x14b>
      }
      result = result*base + digit;
 6bb:	8b 45 10             	mov    0x10(%ebp),%eax
 6be:	0f af c7             	imul   %edi,%eax
 6c1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 6cb:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 6cc:	eb ca                	jmp    698 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 6ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6d2:	75 03                	jne    6d7 <strtoul+0x154>
  p = string;
 6d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 6d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6db:	74 05                	je     6e2 <strtoul+0x15f>
  *endPtr = p;
 6dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e0:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 6e2:	89 f8                	mov    %edi,%eax
}
 6e4:	83 c4 14             	add    $0x14,%esp
 6e7:	5b                   	pop    %ebx
 6e8:	5e                   	pop    %esi
 6e9:	5f                   	pop    %edi
 6ea:	5d                   	pop    %ebp
 6eb:	c3                   	ret    

000006ec <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 6ec:	55                   	push   %ebp
 6ed:	89 e5                	mov    %esp,%ebp
 6ef:	53                   	push   %ebx
 6f0:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 6f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 6f6:	eb 01                	jmp    6f9 <strtol+0xd>
      p += 1;
 6f8:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 6f9:	8a 03                	mov    (%ebx),%al
 6fb:	0f b6 c0             	movzbl %al,%eax
 6fe:	89 04 24             	mov    %eax,(%esp)
 701:	e8 3f fe ff ff       	call   545 <isspace>
 706:	85 c0                	test   %eax,%eax
 708:	75 ee                	jne    6f8 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 70a:	8a 03                	mov    (%ebx),%al
 70c:	3c 2d                	cmp    $0x2d,%al
 70e:	75 1e                	jne    72e <strtol+0x42>
  p += 1;
 710:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 711:	8b 45 10             	mov    0x10(%ebp),%eax
 714:	89 44 24 08          	mov    %eax,0x8(%esp)
 718:	8b 45 0c             	mov    0xc(%ebp),%eax
 71b:	89 44 24 04          	mov    %eax,0x4(%esp)
 71f:	89 1c 24             	mov    %ebx,(%esp)
 722:	e8 5c fe ff ff       	call   583 <strtoul>
 727:	f7 d8                	neg    %eax
 729:	89 45 f8             	mov    %eax,-0x8(%ebp)
 72c:	eb 20                	jmp    74e <strtol+0x62>
    } else {
  if (*p == '+') {
 72e:	8a 03                	mov    (%ebx),%al
 730:	3c 2b                	cmp    $0x2b,%al
 732:	75 01                	jne    735 <strtol+0x49>
      p += 1;
 734:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 735:	8b 45 10             	mov    0x10(%ebp),%eax
 738:	89 44 24 08          	mov    %eax,0x8(%esp)
 73c:	8b 45 0c             	mov    0xc(%ebp),%eax
 73f:	89 44 24 04          	mov    %eax,0x4(%esp)
 743:	89 1c 24             	mov    %ebx,(%esp)
 746:	e8 38 fe ff ff       	call   583 <strtoul>
 74b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 74e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 752:	75 17                	jne    76b <strtol+0x7f>
 754:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 758:	74 11                	je     76b <strtol+0x7f>
 75a:	8b 45 0c             	mov    0xc(%ebp),%eax
 75d:	8b 00                	mov    (%eax),%eax
 75f:	39 d8                	cmp    %ebx,%eax
 761:	75 08                	jne    76b <strtol+0x7f>
  *endPtr = string;
 763:	8b 45 0c             	mov    0xc(%ebp),%eax
 766:	8b 55 08             	mov    0x8(%ebp),%edx
 769:	89 10                	mov    %edx,(%eax)
    }
    return result;
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 76e:	83 c4 1c             	add    $0x1c,%esp
 771:	5b                   	pop    %ebx
 772:	5d                   	pop    %ebp
 773:	c3                   	ret    

00000774 <gets>:

char*
gets(char *buf, int max)
{
 774:	55                   	push   %ebp
 775:	89 e5                	mov    %esp,%ebp
 777:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 77a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 781:	eb 49                	jmp    7cc <gets+0x58>
    cc = read(0, &c, 1);
 783:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 78a:	00 
 78b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 78e:	89 44 24 04          	mov    %eax,0x4(%esp)
 792:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 799:	e8 3e 01 00 00       	call   8dc <read>
 79e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 7a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a5:	7f 02                	jg     7a9 <gets+0x35>
      break;
 7a7:	eb 2c                	jmp    7d5 <gets+0x61>
    buf[i++] = c;
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	8d 50 01             	lea    0x1(%eax),%edx
 7af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7b2:	89 c2                	mov    %eax,%edx
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
 7b7:	01 c2                	add    %eax,%edx
 7b9:	8a 45 ef             	mov    -0x11(%ebp),%al
 7bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 7be:	8a 45 ef             	mov    -0x11(%ebp),%al
 7c1:	3c 0a                	cmp    $0xa,%al
 7c3:	74 10                	je     7d5 <gets+0x61>
 7c5:	8a 45 ef             	mov    -0x11(%ebp),%al
 7c8:	3c 0d                	cmp    $0xd,%al
 7ca:	74 09                	je     7d5 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cf:	40                   	inc    %eax
 7d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7d3:	7c ae                	jl     783 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	01 d0                	add    %edx,%eax
 7dd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7e3:	c9                   	leave  
 7e4:	c3                   	ret    

000007e5 <stat>:

int
stat(char *n, struct stat *st)
{
 7e5:	55                   	push   %ebp
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 7f2:	00 
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	89 04 24             	mov    %eax,(%esp)
 7f9:	e8 06 01 00 00       	call   904 <open>
 7fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 805:	79 07                	jns    80e <stat+0x29>
    return -1;
 807:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 80c:	eb 23                	jmp    831 <stat+0x4c>
  r = fstat(fd, st);
 80e:	8b 45 0c             	mov    0xc(%ebp),%eax
 811:	89 44 24 04          	mov    %eax,0x4(%esp)
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	89 04 24             	mov    %eax,(%esp)
 81b:	e8 fc 00 00 00       	call   91c <fstat>
 820:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 823:	8b 45 f4             	mov    -0xc(%ebp),%eax
 826:	89 04 24             	mov    %eax,(%esp)
 829:	e8 be 00 00 00       	call   8ec <close>
  return r;
 82e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 831:	c9                   	leave  
 832:	c3                   	ret    

00000833 <atoi>:

int
atoi(const char *s)
{
 833:	55                   	push   %ebp
 834:	89 e5                	mov    %esp,%ebp
 836:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 839:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 840:	eb 24                	jmp    866 <atoi+0x33>
    n = n*10 + *s++ - '0';
 842:	8b 55 fc             	mov    -0x4(%ebp),%edx
 845:	89 d0                	mov    %edx,%eax
 847:	c1 e0 02             	shl    $0x2,%eax
 84a:	01 d0                	add    %edx,%eax
 84c:	01 c0                	add    %eax,%eax
 84e:	89 c1                	mov    %eax,%ecx
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	8d 50 01             	lea    0x1(%eax),%edx
 856:	89 55 08             	mov    %edx,0x8(%ebp)
 859:	8a 00                	mov    (%eax),%al
 85b:	0f be c0             	movsbl %al,%eax
 85e:	01 c8                	add    %ecx,%eax
 860:	83 e8 30             	sub    $0x30,%eax
 863:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 866:	8b 45 08             	mov    0x8(%ebp),%eax
 869:	8a 00                	mov    (%eax),%al
 86b:	3c 2f                	cmp    $0x2f,%al
 86d:	7e 09                	jle    878 <atoi+0x45>
 86f:	8b 45 08             	mov    0x8(%ebp),%eax
 872:	8a 00                	mov    (%eax),%al
 874:	3c 39                	cmp    $0x39,%al
 876:	7e ca                	jle    842 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 878:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 87b:	c9                   	leave  
 87c:	c3                   	ret    

0000087d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 87d:	55                   	push   %ebp
 87e:	89 e5                	mov    %esp,%ebp
 880:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 883:	8b 45 08             	mov    0x8(%ebp),%eax
 886:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 889:	8b 45 0c             	mov    0xc(%ebp),%eax
 88c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 88f:	eb 16                	jmp    8a7 <memmove+0x2a>
    *dst++ = *src++;
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	8d 50 01             	lea    0x1(%eax),%edx
 897:	89 55 fc             	mov    %edx,-0x4(%ebp)
 89a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 89d:	8d 4a 01             	lea    0x1(%edx),%ecx
 8a0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 8a3:	8a 12                	mov    (%edx),%dl
 8a5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8a7:	8b 45 10             	mov    0x10(%ebp),%eax
 8aa:	8d 50 ff             	lea    -0x1(%eax),%edx
 8ad:	89 55 10             	mov    %edx,0x10(%ebp)
 8b0:	85 c0                	test   %eax,%eax
 8b2:	7f dd                	jg     891 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8b7:	c9                   	leave  
 8b8:	c3                   	ret    
 8b9:	90                   	nop
 8ba:	90                   	nop
 8bb:	90                   	nop

000008bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8bc:	b8 01 00 00 00       	mov    $0x1,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <exit>:
SYSCALL(exit)
 8c4:	b8 02 00 00 00       	mov    $0x2,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <wait>:
SYSCALL(wait)
 8cc:	b8 03 00 00 00       	mov    $0x3,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <pipe>:
SYSCALL(pipe)
 8d4:	b8 04 00 00 00       	mov    $0x4,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <read>:
SYSCALL(read)
 8dc:	b8 05 00 00 00       	mov    $0x5,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <write>:
SYSCALL(write)
 8e4:	b8 10 00 00 00       	mov    $0x10,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <close>:
SYSCALL(close)
 8ec:	b8 15 00 00 00       	mov    $0x15,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <kill>:
SYSCALL(kill)
 8f4:	b8 06 00 00 00       	mov    $0x6,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <exec>:
SYSCALL(exec)
 8fc:	b8 07 00 00 00       	mov    $0x7,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <open>:
SYSCALL(open)
 904:	b8 0f 00 00 00       	mov    $0xf,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <mknod>:
SYSCALL(mknod)
 90c:	b8 11 00 00 00       	mov    $0x11,%eax
 911:	cd 40                	int    $0x40
 913:	c3                   	ret    

00000914 <unlink>:
SYSCALL(unlink)
 914:	b8 12 00 00 00       	mov    $0x12,%eax
 919:	cd 40                	int    $0x40
 91b:	c3                   	ret    

0000091c <fstat>:
SYSCALL(fstat)
 91c:	b8 08 00 00 00       	mov    $0x8,%eax
 921:	cd 40                	int    $0x40
 923:	c3                   	ret    

00000924 <link>:
SYSCALL(link)
 924:	b8 13 00 00 00       	mov    $0x13,%eax
 929:	cd 40                	int    $0x40
 92b:	c3                   	ret    

0000092c <mkdir>:
SYSCALL(mkdir)
 92c:	b8 14 00 00 00       	mov    $0x14,%eax
 931:	cd 40                	int    $0x40
 933:	c3                   	ret    

00000934 <chdir>:
SYSCALL(chdir)
 934:	b8 09 00 00 00       	mov    $0x9,%eax
 939:	cd 40                	int    $0x40
 93b:	c3                   	ret    

0000093c <dup>:
SYSCALL(dup)
 93c:	b8 0a 00 00 00       	mov    $0xa,%eax
 941:	cd 40                	int    $0x40
 943:	c3                   	ret    

00000944 <getpid>:
SYSCALL(getpid)
 944:	b8 0b 00 00 00       	mov    $0xb,%eax
 949:	cd 40                	int    $0x40
 94b:	c3                   	ret    

0000094c <sbrk>:
SYSCALL(sbrk)
 94c:	b8 0c 00 00 00       	mov    $0xc,%eax
 951:	cd 40                	int    $0x40
 953:	c3                   	ret    

00000954 <sleep>:
SYSCALL(sleep)
 954:	b8 0d 00 00 00       	mov    $0xd,%eax
 959:	cd 40                	int    $0x40
 95b:	c3                   	ret    

0000095c <uptime>:
SYSCALL(uptime)
 95c:	b8 0e 00 00 00       	mov    $0xe,%eax
 961:	cd 40                	int    $0x40
 963:	c3                   	ret    

00000964 <getname>:
SYSCALL(getname)
 964:	b8 16 00 00 00       	mov    $0x16,%eax
 969:	cd 40                	int    $0x40
 96b:	c3                   	ret    

0000096c <setname>:
SYSCALL(setname)
 96c:	b8 17 00 00 00       	mov    $0x17,%eax
 971:	cd 40                	int    $0x40
 973:	c3                   	ret    

00000974 <getmaxproc>:
SYSCALL(getmaxproc)
 974:	b8 18 00 00 00       	mov    $0x18,%eax
 979:	cd 40                	int    $0x40
 97b:	c3                   	ret    

0000097c <setmaxproc>:
SYSCALL(setmaxproc)
 97c:	b8 19 00 00 00       	mov    $0x19,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <getmaxmem>:
SYSCALL(getmaxmem)
 984:	b8 1a 00 00 00       	mov    $0x1a,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <setmaxmem>:
SYSCALL(setmaxmem)
 98c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <getmaxdisk>:
SYSCALL(getmaxdisk)
 994:	b8 1c 00 00 00       	mov    $0x1c,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <setmaxdisk>:
SYSCALL(setmaxdisk)
 99c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <getusedmem>:
SYSCALL(getusedmem)
 9a4:	b8 1e 00 00 00       	mov    $0x1e,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <setusedmem>:
SYSCALL(setusedmem)
 9ac:	b8 1f 00 00 00       	mov    $0x1f,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <getuseddisk>:
SYSCALL(getuseddisk)
 9b4:	b8 20 00 00 00       	mov    $0x20,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <setuseddisk>:
SYSCALL(setuseddisk)
 9bc:	b8 21 00 00 00       	mov    $0x21,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    
