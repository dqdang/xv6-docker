
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 39                	jmp    41 <cat+0x41>
    if (write(1, buf, n) != n) {
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 80 13 00 	movl   $0x1380,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 e9 08 00 00       	call   90c <write>
  23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  26:	74 19                	je     41 <cat+0x41>
      printf(1, "cat: write error\n");
  28:	c7 44 24 04 e7 0e 00 	movl   $0xee7,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 e5 0a 00 00       	call   b21 <printf>
      exit();
  3c:	e8 ab 08 00 00       	call   8ec <exit>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  41:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  48:	00 
  49:	c7 44 24 04 80 13 00 	movl   $0x1380,0x4(%esp)
  50:	00 
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 a8 08 00 00       	call   904 <read>
  5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  63:	7f a3                	jg     8 <cat+0x8>
    if (write(1, buf, n) != n) {
      printf(1, "cat: write error\n");
      exit();
    }
  }
  if(n < 0){
  65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  69:	79 19                	jns    84 <cat+0x84>
    printf(1, "cat: read error\n");
  6b:	c7 44 24 04 f9 0e 00 	movl   $0xef9,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 a2 0a 00 00       	call   b21 <printf>
    exit();
  7f:	e8 68 08 00 00       	call   8ec <exit>
  }
}
  84:	c9                   	leave  
  85:	c3                   	ret    

00000086 <main>:

int
main(int argc, char *argv[])
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 e4 f0             	and    $0xfffffff0,%esp
  8c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  8f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  93:	7f 11                	jg     a6 <main+0x20>
    cat(0);
  95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  9c:	e8 5f ff ff ff       	call   0 <cat>
    exit();
  a1:	e8 46 08 00 00       	call   8ec <exit>
  }

  for(i = 1; i < argc; i++){
  a6:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  ad:	00 
  ae:	eb 78                	jmp    128 <main+0xa2>
    if((fd = open(argv[i], 0)) < 0){
  b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	01 d0                	add    %edx,%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c9:	00 
  ca:	89 04 24             	mov    %eax,(%esp)
  cd:	e8 5a 08 00 00       	call   92c <open>
  d2:	89 44 24 18          	mov    %eax,0x18(%esp)
  d6:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  db:	79 2f                	jns    10c <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  dd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	8b 00                	mov    (%eax),%eax
  ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  f3:	c7 44 24 04 0a 0f 00 	movl   $0xf0a,0x4(%esp)
  fa:	00 
  fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 102:	e8 1a 0a 00 00       	call   b21 <printf>
      exit();
 107:	e8 e0 07 00 00       	call   8ec <exit>
    }
    cat(fd);
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	89 04 24             	mov    %eax,(%esp)
 113:	e8 e8 fe ff ff       	call   0 <cat>
    close(fd);
 118:	8b 44 24 18          	mov    0x18(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 f0 07 00 00       	call   914 <close>
  if(argc <= 1){
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
 124:	ff 44 24 1c          	incl   0x1c(%esp)
 128:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 12c:	3b 45 08             	cmp    0x8(%ebp),%eax
 12f:	0f 8c 7b ff ff ff    	jl     b0 <main+0x2a>
      exit();
    }
    cat(fd);
    close(fd);
  }
  exit();
 135:	e8 b2 07 00 00       	call   8ec <exit>
 13a:	90                   	nop
 13b:	90                   	nop

0000013c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 141:	8b 4d 08             	mov    0x8(%ebp),%ecx
 144:	8b 55 10             	mov    0x10(%ebp),%edx
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 cb                	mov    %ecx,%ebx
 14c:	89 df                	mov    %ebx,%edi
 14e:	89 d1                	mov    %edx,%ecx
 150:	fc                   	cld    
 151:	f3 aa                	rep stos %al,%es:(%edi)
 153:	89 ca                	mov    %ecx,%edx
 155:	89 fb                	mov    %edi,%ebx
 157:	89 5d 08             	mov    %ebx,0x8(%ebp)
 15a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15d:	5b                   	pop    %ebx
 15e:	5f                   	pop    %edi
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    

00000161 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16d:	90                   	nop
 16e:	8b 45 08             	mov    0x8(%ebp),%eax
 171:	8d 50 01             	lea    0x1(%eax),%edx
 174:	89 55 08             	mov    %edx,0x8(%ebp)
 177:	8b 55 0c             	mov    0xc(%ebp),%edx
 17a:	8d 4a 01             	lea    0x1(%edx),%ecx
 17d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 180:	8a 12                	mov    (%edx),%dl
 182:	88 10                	mov    %dl,(%eax)
 184:	8a 00                	mov    (%eax),%al
 186:	84 c0                	test   %al,%al
 188:	75 e4                	jne    16e <strcpy+0xd>
    ;
  return os;
 18a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18d:	c9                   	leave  
 18e:	c3                   	ret    

0000018f <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
 195:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
 19c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a3:	00 
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	89 04 24             	mov    %eax,(%esp)
 1aa:	e8 7d 07 00 00       	call   92c <open>
 1af:	89 45 f0             	mov    %eax,-0x10(%ebp)
 1b2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1b6:	79 20                	jns    1d8 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
 1b8:	8b 45 08             	mov    0x8(%ebp),%eax
 1bb:	89 44 24 08          	mov    %eax,0x8(%esp)
 1bf:	c7 44 24 04 1f 0f 00 	movl   $0xf1f,0x4(%esp)
 1c6:	00 
 1c7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1ce:	e8 4e 09 00 00       	call   b21 <printf>
      exit();
 1d3:	e8 14 07 00 00       	call   8ec <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 1d8:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 1df:	00 
 1e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 41 07 00 00       	call   92c <open>
 1eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1f2:	79 20                	jns    214 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	89 44 24 08          	mov    %eax,0x8(%esp)
 1fb:	c7 44 24 04 3a 0f 00 	movl   $0xf3a,0x4(%esp)
 202:	00 
 203:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 20a:	e8 12 09 00 00       	call   b21 <printf>
      exit();
 20f:	e8 d8 06 00 00       	call   8ec <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 214:	eb 3b                	jmp    251 <copy+0xc2>
  {
      max = used_disk+=count;
 216:	8b 45 e8             	mov    -0x18(%ebp),%eax
 219:	01 45 10             	add    %eax,0x10(%ebp)
 21c:	8b 45 10             	mov    0x10(%ebp),%eax
 21f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 225:	3b 45 14             	cmp    0x14(%ebp),%eax
 228:	7e 07                	jle    231 <copy+0xa2>
      {
        return -1;
 22a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 22f:	eb 5c                	jmp    28d <copy+0xfe>
      }
      bytes = bytes + count;
 231:	8b 45 e8             	mov    -0x18(%ebp),%eax
 234:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 237:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 23e:	00 
 23f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 242:	89 44 24 04          	mov    %eax,0x4(%esp)
 246:	8b 45 ec             	mov    -0x14(%ebp),%eax
 249:	89 04 24             	mov    %eax,(%esp)
 24c:	e8 bb 06 00 00       	call   90c <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 251:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 258:	00 
 259:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 25c:	89 44 24 04          	mov    %eax,0x4(%esp)
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
 263:	89 04 24             	mov    %eax,(%esp)
 266:	e8 99 06 00 00       	call   904 <read>
 26b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 26e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 272:	7f a2                	jg     216 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 274:	8b 45 f0             	mov    -0x10(%ebp),%eax
 277:	89 04 24             	mov    %eax,(%esp)
 27a:	e8 95 06 00 00       	call   914 <close>
  close(fd2);
 27f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 282:	89 04 24             	mov    %eax,(%esp)
 285:	e8 8a 06 00 00       	call   914 <close>
  return(bytes);
 28a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 292:	eb 06                	jmp    29a <strcmp+0xb>
    p++, q++;
 294:	ff 45 08             	incl   0x8(%ebp)
 297:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	8a 00                	mov    (%eax),%al
 29f:	84 c0                	test   %al,%al
 2a1:	74 0e                	je     2b1 <strcmp+0x22>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	8a 10                	mov    (%eax),%dl
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	8a 00                	mov    (%eax),%al
 2ad:	38 c2                	cmp    %al,%dl
 2af:	74 e3                	je     294 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2b1:	8b 45 08             	mov    0x8(%ebp),%eax
 2b4:	8a 00                	mov    (%eax),%al
 2b6:	0f b6 d0             	movzbl %al,%edx
 2b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bc:	8a 00                	mov    (%eax),%al
 2be:	0f b6 c0             	movzbl %al,%eax
 2c1:	29 c2                	sub    %eax,%edx
 2c3:	89 d0                	mov    %edx,%eax
}
 2c5:	5d                   	pop    %ebp
 2c6:	c3                   	ret    

000002c7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2c7:	55                   	push   %ebp
 2c8:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 2ca:	eb 09                	jmp    2d5 <strncmp+0xe>
    n--, p++, q++;
 2cc:	ff 4d 10             	decl   0x10(%ebp)
 2cf:	ff 45 08             	incl   0x8(%ebp)
 2d2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 2d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2d9:	74 17                	je     2f2 <strncmp+0x2b>
 2db:	8b 45 08             	mov    0x8(%ebp),%eax
 2de:	8a 00                	mov    (%eax),%al
 2e0:	84 c0                	test   %al,%al
 2e2:	74 0e                	je     2f2 <strncmp+0x2b>
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	8a 10                	mov    (%eax),%dl
 2e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ec:	8a 00                	mov    (%eax),%al
 2ee:	38 c2                	cmp    %al,%dl
 2f0:	74 da                	je     2cc <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 2f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2f6:	75 07                	jne    2ff <strncmp+0x38>
    return 0;
 2f8:	b8 00 00 00 00       	mov    $0x0,%eax
 2fd:	eb 14                	jmp    313 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 2ff:	8b 45 08             	mov    0x8(%ebp),%eax
 302:	8a 00                	mov    (%eax),%al
 304:	0f b6 d0             	movzbl %al,%edx
 307:	8b 45 0c             	mov    0xc(%ebp),%eax
 30a:	8a 00                	mov    (%eax),%al
 30c:	0f b6 c0             	movzbl %al,%eax
 30f:	29 c2                	sub    %eax,%edx
 311:	89 d0                	mov    %edx,%eax
}
 313:	5d                   	pop    %ebp
 314:	c3                   	ret    

00000315 <strlen>:

uint
strlen(const char *s)
{
 315:	55                   	push   %ebp
 316:	89 e5                	mov    %esp,%ebp
 318:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 31b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 322:	eb 03                	jmp    327 <strlen+0x12>
 324:	ff 45 fc             	incl   -0x4(%ebp)
 327:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32a:	8b 45 08             	mov    0x8(%ebp),%eax
 32d:	01 d0                	add    %edx,%eax
 32f:	8a 00                	mov    (%eax),%al
 331:	84 c0                	test   %al,%al
 333:	75 ef                	jne    324 <strlen+0xf>
    ;
  return n;
 335:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 338:	c9                   	leave  
 339:	c3                   	ret    

0000033a <memset>:

void*
memset(void *dst, int c, uint n)
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 340:	8b 45 10             	mov    0x10(%ebp),%eax
 343:	89 44 24 08          	mov    %eax,0x8(%esp)
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	89 44 24 04          	mov    %eax,0x4(%esp)
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	89 04 24             	mov    %eax,(%esp)
 354:	e8 e3 fd ff ff       	call   13c <stosb>
  return dst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <strchr>:

char*
strchr(const char *s, char c)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 04             	sub    $0x4,%esp
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 36a:	eb 12                	jmp    37e <strchr+0x20>
    if(*s == c)
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
 36f:	8a 00                	mov    (%eax),%al
 371:	3a 45 fc             	cmp    -0x4(%ebp),%al
 374:	75 05                	jne    37b <strchr+0x1d>
      return (char*)s;
 376:	8b 45 08             	mov    0x8(%ebp),%eax
 379:	eb 11                	jmp    38c <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 37b:	ff 45 08             	incl   0x8(%ebp)
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	8a 00                	mov    (%eax),%al
 383:	84 c0                	test   %al,%al
 385:	75 e5                	jne    36c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 387:	b8 00 00 00 00       	mov    $0x0,%eax
}
 38c:	c9                   	leave  
 38d:	c3                   	ret    

0000038e <strcat>:

char *
strcat(char *dest, const char *src)
{
 38e:	55                   	push   %ebp
 38f:	89 e5                	mov    %esp,%ebp
 391:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 394:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 39b:	eb 03                	jmp    3a0 <strcat+0x12>
 39d:	ff 45 fc             	incl   -0x4(%ebp)
 3a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	01 d0                	add    %edx,%eax
 3a8:	8a 00                	mov    (%eax),%al
 3aa:	84 c0                	test   %al,%al
 3ac:	75 ef                	jne    39d <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 3ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 3b5:	eb 1e                	jmp    3d5 <strcat+0x47>
        dest[i+j] = src[j];
 3b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3bd:	01 d0                	add    %edx,%eax
 3bf:	89 c2                	mov    %eax,%edx
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	01 c2                	add    %eax,%edx
 3c6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cc:	01 c8                	add    %ecx,%eax
 3ce:	8a 00                	mov    (%eax),%al
 3d0:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 3d2:	ff 45 f8             	incl   -0x8(%ebp)
 3d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	01 d0                	add    %edx,%eax
 3dd:	8a 00                	mov    (%eax),%al
 3df:	84 c0                	test   %al,%al
 3e1:	75 d4                	jne    3b7 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 3e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3e9:	01 d0                	add    %edx,%eax
 3eb:	89 c2                	mov    %eax,%edx
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	01 d0                	add    %edx,%eax
 3f2:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f8:	c9                   	leave  
 3f9:	c3                   	ret    

000003fa <strstr>:

int 
strstr(char* s, char* sub)
{
 3fa:	55                   	push   %ebp
 3fb:	89 e5                	mov    %esp,%ebp
 3fd:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 400:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 407:	eb 7c                	jmp    485 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 409:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40c:	8b 45 08             	mov    0x8(%ebp),%eax
 40f:	01 d0                	add    %edx,%eax
 411:	8a 10                	mov    (%eax),%dl
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	8a 00                	mov    (%eax),%al
 418:	38 c2                	cmp    %al,%dl
 41a:	75 66                	jne    482 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 41c:	8b 45 0c             	mov    0xc(%ebp),%eax
 41f:	89 04 24             	mov    %eax,(%esp)
 422:	e8 ee fe ff ff       	call   315 <strlen>
 427:	83 f8 01             	cmp    $0x1,%eax
 42a:	75 05                	jne    431 <strstr+0x37>
            {  
                return i;
 42c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 42f:	eb 6b                	jmp    49c <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 431:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 438:	eb 3a                	jmp    474 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 43a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 43d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 440:	01 d0                	add    %edx,%eax
 442:	89 c2                	mov    %eax,%edx
 444:	8b 45 08             	mov    0x8(%ebp),%eax
 447:	01 d0                	add    %edx,%eax
 449:	8a 10                	mov    (%eax),%dl
 44b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 44e:	8b 45 0c             	mov    0xc(%ebp),%eax
 451:	01 c8                	add    %ecx,%eax
 453:	8a 00                	mov    (%eax),%al
 455:	38 c2                	cmp    %al,%dl
 457:	75 16                	jne    46f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 459:	8b 45 f8             	mov    -0x8(%ebp),%eax
 45c:	8d 50 01             	lea    0x1(%eax),%edx
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	01 d0                	add    %edx,%eax
 464:	8a 00                	mov    (%eax),%al
 466:	84 c0                	test   %al,%al
 468:	75 07                	jne    471 <strstr+0x77>
                    {
                        return i;
 46a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 46d:	eb 2d                	jmp    49c <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 46f:	eb 11                	jmp    482 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 471:	ff 45 f8             	incl   -0x8(%ebp)
 474:	8b 55 f8             	mov    -0x8(%ebp),%edx
 477:	8b 45 0c             	mov    0xc(%ebp),%eax
 47a:	01 d0                	add    %edx,%eax
 47c:	8a 00                	mov    (%eax),%al
 47e:	84 c0                	test   %al,%al
 480:	75 b8                	jne    43a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 482:	ff 45 fc             	incl   -0x4(%ebp)
 485:	8b 55 fc             	mov    -0x4(%ebp),%edx
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	01 d0                	add    %edx,%eax
 48d:	8a 00                	mov    (%eax),%al
 48f:	84 c0                	test   %al,%al
 491:	0f 85 72 ff ff ff    	jne    409 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 497:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 49c:	c9                   	leave  
 49d:	c3                   	ret    

0000049e <strtok>:

char *
strtok(char *s, const char *delim)
{
 49e:	55                   	push   %ebp
 49f:	89 e5                	mov    %esp,%ebp
 4a1:	53                   	push   %ebx
 4a2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 4a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4a9:	75 08                	jne    4b3 <strtok+0x15>
  s = lasts;
 4ab:	a1 64 13 00 00       	mov    0x1364,%eax
 4b0:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	8d 50 01             	lea    0x1(%eax),%edx
 4b9:	89 55 08             	mov    %edx,0x8(%ebp)
 4bc:	8a 00                	mov    (%eax),%al
 4be:	0f be d8             	movsbl %al,%ebx
 4c1:	85 db                	test   %ebx,%ebx
 4c3:	75 07                	jne    4cc <strtok+0x2e>
      return 0;
 4c5:	b8 00 00 00 00       	mov    $0x0,%eax
 4ca:	eb 58                	jmp    524 <strtok+0x86>
    } while (strchr(delim, ch));
 4cc:	88 d8                	mov    %bl,%al
 4ce:	0f be c0             	movsbl %al,%eax
 4d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d8:	89 04 24             	mov    %eax,(%esp)
 4db:	e8 7e fe ff ff       	call   35e <strchr>
 4e0:	85 c0                	test   %eax,%eax
 4e2:	75 cf                	jne    4b3 <strtok+0x15>
    --s;
 4e4:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 4e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ee:	8b 45 08             	mov    0x8(%ebp),%eax
 4f1:	89 04 24             	mov    %eax,(%esp)
 4f4:	e8 31 00 00 00       	call   52a <strcspn>
 4f9:	89 c2                	mov    %eax,%edx
 4fb:	8b 45 08             	mov    0x8(%ebp),%eax
 4fe:	01 d0                	add    %edx,%eax
 500:	a3 64 13 00 00       	mov    %eax,0x1364
    if (*lasts != 0)
 505:	a1 64 13 00 00       	mov    0x1364,%eax
 50a:	8a 00                	mov    (%eax),%al
 50c:	84 c0                	test   %al,%al
 50e:	74 11                	je     521 <strtok+0x83>
  *lasts++ = 0;
 510:	a1 64 13 00 00       	mov    0x1364,%eax
 515:	8d 50 01             	lea    0x1(%eax),%edx
 518:	89 15 64 13 00 00    	mov    %edx,0x1364
 51e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 521:	8b 45 08             	mov    0x8(%ebp),%eax
}
 524:	83 c4 14             	add    $0x14,%esp
 527:	5b                   	pop    %ebx
 528:	5d                   	pop    %ebp
 529:	c3                   	ret    

0000052a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 52a:	55                   	push   %ebp
 52b:	89 e5                	mov    %esp,%ebp
 52d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 530:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 537:	eb 26                	jmp    55f <strcspn+0x35>
        if(strchr(s2,*s1))
 539:	8b 45 08             	mov    0x8(%ebp),%eax
 53c:	8a 00                	mov    (%eax),%al
 53e:	0f be c0             	movsbl %al,%eax
 541:	89 44 24 04          	mov    %eax,0x4(%esp)
 545:	8b 45 0c             	mov    0xc(%ebp),%eax
 548:	89 04 24             	mov    %eax,(%esp)
 54b:	e8 0e fe ff ff       	call   35e <strchr>
 550:	85 c0                	test   %eax,%eax
 552:	74 05                	je     559 <strcspn+0x2f>
            return ret;
 554:	8b 45 fc             	mov    -0x4(%ebp),%eax
 557:	eb 12                	jmp    56b <strcspn+0x41>
        else
            s1++,ret++;
 559:	ff 45 08             	incl   0x8(%ebp)
 55c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	8a 00                	mov    (%eax),%al
 564:	84 c0                	test   %al,%al
 566:	75 d1                	jne    539 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 568:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 56b:	c9                   	leave  
 56c:	c3                   	ret    

0000056d <isspace>:

int
isspace(unsigned char c)
{
 56d:	55                   	push   %ebp
 56e:	89 e5                	mov    %esp,%ebp
 570:	83 ec 04             	sub    $0x4,%esp
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 579:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 57d:	74 1e                	je     59d <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 57f:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 583:	74 18                	je     59d <isspace+0x30>
 585:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 589:	74 12                	je     59d <isspace+0x30>
 58b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 58f:	74 0c                	je     59d <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 591:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 595:	74 06                	je     59d <isspace+0x30>
 597:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 59b:	75 07                	jne    5a4 <isspace+0x37>
 59d:	b8 01 00 00 00       	mov    $0x1,%eax
 5a2:	eb 05                	jmp    5a9 <isspace+0x3c>
 5a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5a9:	c9                   	leave  
 5aa:	c3                   	ret    

000005ab <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 5ab:	55                   	push   %ebp
 5ac:	89 e5                	mov    %esp,%ebp
 5ae:	57                   	push   %edi
 5af:	56                   	push   %esi
 5b0:	53                   	push   %ebx
 5b1:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 5b4:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 5b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 5c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 5c3:	eb 01                	jmp    5c6 <strtoul+0x1b>
  p += 1;
 5c5:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 5c6:	8a 03                	mov    (%ebx),%al
 5c8:	0f b6 c0             	movzbl %al,%eax
 5cb:	89 04 24             	mov    %eax,(%esp)
 5ce:	e8 9a ff ff ff       	call   56d <isspace>
 5d3:	85 c0                	test   %eax,%eax
 5d5:	75 ee                	jne    5c5 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 5d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5db:	75 30                	jne    60d <strtoul+0x62>
    {
  if (*p == '0') {
 5dd:	8a 03                	mov    (%ebx),%al
 5df:	3c 30                	cmp    $0x30,%al
 5e1:	75 21                	jne    604 <strtoul+0x59>
      p += 1;
 5e3:	43                   	inc    %ebx
      if (*p == 'x') {
 5e4:	8a 03                	mov    (%ebx),%al
 5e6:	3c 78                	cmp    $0x78,%al
 5e8:	75 0a                	jne    5f4 <strtoul+0x49>
    p += 1;
 5ea:	43                   	inc    %ebx
    base = 16;
 5eb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 5f2:	eb 31                	jmp    625 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 5f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 5fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 602:	eb 21                	jmp    625 <strtoul+0x7a>
      }
  }
  else base = 10;
 604:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 60b:	eb 18                	jmp    625 <strtoul+0x7a>
    } else if (base == 16) {
 60d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 611:	75 12                	jne    625 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 613:	8a 03                	mov    (%ebx),%al
 615:	3c 30                	cmp    $0x30,%al
 617:	75 0c                	jne    625 <strtoul+0x7a>
 619:	8d 43 01             	lea    0x1(%ebx),%eax
 61c:	8a 00                	mov    (%eax),%al
 61e:	3c 78                	cmp    $0x78,%al
 620:	75 03                	jne    625 <strtoul+0x7a>
      p += 2;
 622:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 625:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 629:	75 29                	jne    654 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 62b:	8a 03                	mov    (%ebx),%al
 62d:	0f be c0             	movsbl %al,%eax
 630:	83 e8 30             	sub    $0x30,%eax
 633:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 635:	83 fe 07             	cmp    $0x7,%esi
 638:	76 06                	jbe    640 <strtoul+0x95>
    break;
 63a:	90                   	nop
 63b:	e9 b6 00 00 00       	jmp    6f6 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 640:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 647:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 64a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 651:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 652:	eb d7                	jmp    62b <strtoul+0x80>
    } else if (base == 10) {
 654:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 658:	75 2b                	jne    685 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 65a:	8a 03                	mov    (%ebx),%al
 65c:	0f be c0             	movsbl %al,%eax
 65f:	83 e8 30             	sub    $0x30,%eax
 662:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 664:	83 fe 09             	cmp    $0x9,%esi
 667:	76 06                	jbe    66f <strtoul+0xc4>
    break;
 669:	90                   	nop
 66a:	e9 87 00 00 00       	jmp    6f6 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 66f:	89 f8                	mov    %edi,%eax
 671:	c1 e0 02             	shl    $0x2,%eax
 674:	01 f8                	add    %edi,%eax
 676:	01 c0                	add    %eax,%eax
 678:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 67b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 682:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 683:	eb d5                	jmp    65a <strtoul+0xaf>
    } else if (base == 16) {
 685:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 689:	75 35                	jne    6c0 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 68b:	8a 03                	mov    (%ebx),%al
 68d:	0f be c0             	movsbl %al,%eax
 690:	83 e8 30             	sub    $0x30,%eax
 693:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 695:	83 fe 4a             	cmp    $0x4a,%esi
 698:	76 02                	jbe    69c <strtoul+0xf1>
    break;
 69a:	eb 22                	jmp    6be <strtoul+0x113>
      }
      digit = cvtIn[digit];
 69c:	8a 86 00 13 00 00    	mov    0x1300(%esi),%al
 6a2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 6a5:	83 fe 0f             	cmp    $0xf,%esi
 6a8:	76 02                	jbe    6ac <strtoul+0x101>
    break;
 6aa:	eb 12                	jmp    6be <strtoul+0x113>
      }
      result = (result << 4) + digit;
 6ac:	89 f8                	mov    %edi,%eax
 6ae:	c1 e0 04             	shl    $0x4,%eax
 6b1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 6bb:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 6bc:	eb cd                	jmp    68b <strtoul+0xe0>
 6be:	eb 36                	jmp    6f6 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 6c0:	8a 03                	mov    (%ebx),%al
 6c2:	0f be c0             	movsbl %al,%eax
 6c5:	83 e8 30             	sub    $0x30,%eax
 6c8:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6ca:	83 fe 4a             	cmp    $0x4a,%esi
 6cd:	76 02                	jbe    6d1 <strtoul+0x126>
    break;
 6cf:	eb 25                	jmp    6f6 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 6d1:	8a 86 00 13 00 00    	mov    0x1300(%esi),%al
 6d7:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 6da:	8b 45 10             	mov    0x10(%ebp),%eax
 6dd:	39 f0                	cmp    %esi,%eax
 6df:	77 02                	ja     6e3 <strtoul+0x138>
    break;
 6e1:	eb 13                	jmp    6f6 <strtoul+0x14b>
      }
      result = result*base + digit;
 6e3:	8b 45 10             	mov    0x10(%ebp),%eax
 6e6:	0f af c7             	imul   %edi,%eax
 6e9:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6ec:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 6f3:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 6f4:	eb ca                	jmp    6c0 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 6f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fa:	75 03                	jne    6ff <strtoul+0x154>
  p = string;
 6fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 6ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 703:	74 05                	je     70a <strtoul+0x15f>
  *endPtr = p;
 705:	8b 45 0c             	mov    0xc(%ebp),%eax
 708:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 70a:	89 f8                	mov    %edi,%eax
}
 70c:	83 c4 14             	add    $0x14,%esp
 70f:	5b                   	pop    %ebx
 710:	5e                   	pop    %esi
 711:	5f                   	pop    %edi
 712:	5d                   	pop    %ebp
 713:	c3                   	ret    

00000714 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 714:	55                   	push   %ebp
 715:	89 e5                	mov    %esp,%ebp
 717:	53                   	push   %ebx
 718:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 71b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 71e:	eb 01                	jmp    721 <strtol+0xd>
      p += 1;
 720:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 721:	8a 03                	mov    (%ebx),%al
 723:	0f b6 c0             	movzbl %al,%eax
 726:	89 04 24             	mov    %eax,(%esp)
 729:	e8 3f fe ff ff       	call   56d <isspace>
 72e:	85 c0                	test   %eax,%eax
 730:	75 ee                	jne    720 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 732:	8a 03                	mov    (%ebx),%al
 734:	3c 2d                	cmp    $0x2d,%al
 736:	75 1e                	jne    756 <strtol+0x42>
  p += 1;
 738:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 739:	8b 45 10             	mov    0x10(%ebp),%eax
 73c:	89 44 24 08          	mov    %eax,0x8(%esp)
 740:	8b 45 0c             	mov    0xc(%ebp),%eax
 743:	89 44 24 04          	mov    %eax,0x4(%esp)
 747:	89 1c 24             	mov    %ebx,(%esp)
 74a:	e8 5c fe ff ff       	call   5ab <strtoul>
 74f:	f7 d8                	neg    %eax
 751:	89 45 f8             	mov    %eax,-0x8(%ebp)
 754:	eb 20                	jmp    776 <strtol+0x62>
    } else {
  if (*p == '+') {
 756:	8a 03                	mov    (%ebx),%al
 758:	3c 2b                	cmp    $0x2b,%al
 75a:	75 01                	jne    75d <strtol+0x49>
      p += 1;
 75c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 75d:	8b 45 10             	mov    0x10(%ebp),%eax
 760:	89 44 24 08          	mov    %eax,0x8(%esp)
 764:	8b 45 0c             	mov    0xc(%ebp),%eax
 767:	89 44 24 04          	mov    %eax,0x4(%esp)
 76b:	89 1c 24             	mov    %ebx,(%esp)
 76e:	e8 38 fe ff ff       	call   5ab <strtoul>
 773:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 776:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 77a:	75 17                	jne    793 <strtol+0x7f>
 77c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 780:	74 11                	je     793 <strtol+0x7f>
 782:	8b 45 0c             	mov    0xc(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	39 d8                	cmp    %ebx,%eax
 789:	75 08                	jne    793 <strtol+0x7f>
  *endPtr = string;
 78b:	8b 45 0c             	mov    0xc(%ebp),%eax
 78e:	8b 55 08             	mov    0x8(%ebp),%edx
 791:	89 10                	mov    %edx,(%eax)
    }
    return result;
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 796:	83 c4 1c             	add    $0x1c,%esp
 799:	5b                   	pop    %ebx
 79a:	5d                   	pop    %ebp
 79b:	c3                   	ret    

0000079c <gets>:

char*
gets(char *buf, int max)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 7a9:	eb 49                	jmp    7f4 <gets+0x58>
    cc = read(0, &c, 1);
 7ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7b2:	00 
 7b3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 7b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7c1:	e8 3e 01 00 00       	call   904 <read>
 7c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 7c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7cd:	7f 02                	jg     7d1 <gets+0x35>
      break;
 7cf:	eb 2c                	jmp    7fd <gets+0x61>
    buf[i++] = c;
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	8d 50 01             	lea    0x1(%eax),%edx
 7d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7da:	89 c2                	mov    %eax,%edx
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
 7df:	01 c2                	add    %eax,%edx
 7e1:	8a 45 ef             	mov    -0x11(%ebp),%al
 7e4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 7e6:	8a 45 ef             	mov    -0x11(%ebp),%al
 7e9:	3c 0a                	cmp    $0xa,%al
 7eb:	74 10                	je     7fd <gets+0x61>
 7ed:	8a 45 ef             	mov    -0x11(%ebp),%al
 7f0:	3c 0d                	cmp    $0xd,%al
 7f2:	74 09                	je     7fd <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f7:	40                   	inc    %eax
 7f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 7fb:	7c ae                	jl     7ab <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 7fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 800:	8b 45 08             	mov    0x8(%ebp),%eax
 803:	01 d0                	add    %edx,%eax
 805:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 808:	8b 45 08             	mov    0x8(%ebp),%eax
}
 80b:	c9                   	leave  
 80c:	c3                   	ret    

0000080d <stat>:

int
stat(char *n, struct stat *st)
{
 80d:	55                   	push   %ebp
 80e:	89 e5                	mov    %esp,%ebp
 810:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 813:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 81a:	00 
 81b:	8b 45 08             	mov    0x8(%ebp),%eax
 81e:	89 04 24             	mov    %eax,(%esp)
 821:	e8 06 01 00 00       	call   92c <open>
 826:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 82d:	79 07                	jns    836 <stat+0x29>
    return -1;
 82f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 834:	eb 23                	jmp    859 <stat+0x4c>
  r = fstat(fd, st);
 836:	8b 45 0c             	mov    0xc(%ebp),%eax
 839:	89 44 24 04          	mov    %eax,0x4(%esp)
 83d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 840:	89 04 24             	mov    %eax,(%esp)
 843:	e8 fc 00 00 00       	call   944 <fstat>
 848:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 84b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84e:	89 04 24             	mov    %eax,(%esp)
 851:	e8 be 00 00 00       	call   914 <close>
  return r;
 856:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 859:	c9                   	leave  
 85a:	c3                   	ret    

0000085b <atoi>:

int
atoi(const char *s)
{
 85b:	55                   	push   %ebp
 85c:	89 e5                	mov    %esp,%ebp
 85e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 861:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 868:	eb 24                	jmp    88e <atoi+0x33>
    n = n*10 + *s++ - '0';
 86a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 86d:	89 d0                	mov    %edx,%eax
 86f:	c1 e0 02             	shl    $0x2,%eax
 872:	01 d0                	add    %edx,%eax
 874:	01 c0                	add    %eax,%eax
 876:	89 c1                	mov    %eax,%ecx
 878:	8b 45 08             	mov    0x8(%ebp),%eax
 87b:	8d 50 01             	lea    0x1(%eax),%edx
 87e:	89 55 08             	mov    %edx,0x8(%ebp)
 881:	8a 00                	mov    (%eax),%al
 883:	0f be c0             	movsbl %al,%eax
 886:	01 c8                	add    %ecx,%eax
 888:	83 e8 30             	sub    $0x30,%eax
 88b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 88e:	8b 45 08             	mov    0x8(%ebp),%eax
 891:	8a 00                	mov    (%eax),%al
 893:	3c 2f                	cmp    $0x2f,%al
 895:	7e 09                	jle    8a0 <atoi+0x45>
 897:	8b 45 08             	mov    0x8(%ebp),%eax
 89a:	8a 00                	mov    (%eax),%al
 89c:	3c 39                	cmp    $0x39,%al
 89e:	7e ca                	jle    86a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 8a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    

000008a5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 8a5:	55                   	push   %ebp
 8a6:	89 e5                	mov    %esp,%ebp
 8a8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 8ab:	8b 45 08             	mov    0x8(%ebp),%eax
 8ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 8b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 8b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 8b7:	eb 16                	jmp    8cf <memmove+0x2a>
    *dst++ = *src++;
 8b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bc:	8d 50 01             	lea    0x1(%eax),%edx
 8bf:	89 55 fc             	mov    %edx,-0x4(%ebp)
 8c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8c5:	8d 4a 01             	lea    0x1(%edx),%ecx
 8c8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 8cb:	8a 12                	mov    (%edx),%dl
 8cd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8cf:	8b 45 10             	mov    0x10(%ebp),%eax
 8d2:	8d 50 ff             	lea    -0x1(%eax),%edx
 8d5:	89 55 10             	mov    %edx,0x10(%ebp)
 8d8:	85 c0                	test   %eax,%eax
 8da:	7f dd                	jg     8b9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8df:	c9                   	leave  
 8e0:	c3                   	ret    
 8e1:	90                   	nop
 8e2:	90                   	nop
 8e3:	90                   	nop

000008e4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8e4:	b8 01 00 00 00       	mov    $0x1,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <exit>:
SYSCALL(exit)
 8ec:	b8 02 00 00 00       	mov    $0x2,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <wait>:
SYSCALL(wait)
 8f4:	b8 03 00 00 00       	mov    $0x3,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <pipe>:
SYSCALL(pipe)
 8fc:	b8 04 00 00 00       	mov    $0x4,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <read>:
SYSCALL(read)
 904:	b8 05 00 00 00       	mov    $0x5,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <write>:
SYSCALL(write)
 90c:	b8 10 00 00 00       	mov    $0x10,%eax
 911:	cd 40                	int    $0x40
 913:	c3                   	ret    

00000914 <close>:
SYSCALL(close)
 914:	b8 15 00 00 00       	mov    $0x15,%eax
 919:	cd 40                	int    $0x40
 91b:	c3                   	ret    

0000091c <kill>:
SYSCALL(kill)
 91c:	b8 06 00 00 00       	mov    $0x6,%eax
 921:	cd 40                	int    $0x40
 923:	c3                   	ret    

00000924 <exec>:
SYSCALL(exec)
 924:	b8 07 00 00 00       	mov    $0x7,%eax
 929:	cd 40                	int    $0x40
 92b:	c3                   	ret    

0000092c <open>:
SYSCALL(open)
 92c:	b8 0f 00 00 00       	mov    $0xf,%eax
 931:	cd 40                	int    $0x40
 933:	c3                   	ret    

00000934 <mknod>:
SYSCALL(mknod)
 934:	b8 11 00 00 00       	mov    $0x11,%eax
 939:	cd 40                	int    $0x40
 93b:	c3                   	ret    

0000093c <unlink>:
SYSCALL(unlink)
 93c:	b8 12 00 00 00       	mov    $0x12,%eax
 941:	cd 40                	int    $0x40
 943:	c3                   	ret    

00000944 <fstat>:
SYSCALL(fstat)
 944:	b8 08 00 00 00       	mov    $0x8,%eax
 949:	cd 40                	int    $0x40
 94b:	c3                   	ret    

0000094c <link>:
SYSCALL(link)
 94c:	b8 13 00 00 00       	mov    $0x13,%eax
 951:	cd 40                	int    $0x40
 953:	c3                   	ret    

00000954 <mkdir>:
SYSCALL(mkdir)
 954:	b8 14 00 00 00       	mov    $0x14,%eax
 959:	cd 40                	int    $0x40
 95b:	c3                   	ret    

0000095c <chdir>:
SYSCALL(chdir)
 95c:	b8 09 00 00 00       	mov    $0x9,%eax
 961:	cd 40                	int    $0x40
 963:	c3                   	ret    

00000964 <dup>:
SYSCALL(dup)
 964:	b8 0a 00 00 00       	mov    $0xa,%eax
 969:	cd 40                	int    $0x40
 96b:	c3                   	ret    

0000096c <getpid>:
SYSCALL(getpid)
 96c:	b8 0b 00 00 00       	mov    $0xb,%eax
 971:	cd 40                	int    $0x40
 973:	c3                   	ret    

00000974 <sbrk>:
SYSCALL(sbrk)
 974:	b8 0c 00 00 00       	mov    $0xc,%eax
 979:	cd 40                	int    $0x40
 97b:	c3                   	ret    

0000097c <sleep>:
SYSCALL(sleep)
 97c:	b8 0d 00 00 00       	mov    $0xd,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <uptime>:
SYSCALL(uptime)
 984:	b8 0e 00 00 00       	mov    $0xe,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <getname>:
SYSCALL(getname)
 98c:	b8 16 00 00 00       	mov    $0x16,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <setname>:
SYSCALL(setname)
 994:	b8 17 00 00 00       	mov    $0x17,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <getmaxproc>:
SYSCALL(getmaxproc)
 99c:	b8 18 00 00 00       	mov    $0x18,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <setmaxproc>:
SYSCALL(setmaxproc)
 9a4:	b8 19 00 00 00       	mov    $0x19,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <getmaxmem>:
SYSCALL(getmaxmem)
 9ac:	b8 1a 00 00 00       	mov    $0x1a,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <setmaxmem>:
SYSCALL(setmaxmem)
 9b4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <getmaxdisk>:
SYSCALL(getmaxdisk)
 9bc:	b8 1c 00 00 00       	mov    $0x1c,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    

000009c4 <setmaxdisk>:
SYSCALL(setmaxdisk)
 9c4:	b8 1d 00 00 00       	mov    $0x1d,%eax
 9c9:	cd 40                	int    $0x40
 9cb:	c3                   	ret    

000009cc <getusedmem>:
SYSCALL(getusedmem)
 9cc:	b8 1e 00 00 00       	mov    $0x1e,%eax
 9d1:	cd 40                	int    $0x40
 9d3:	c3                   	ret    

000009d4 <setusedmem>:
SYSCALL(setusedmem)
 9d4:	b8 1f 00 00 00       	mov    $0x1f,%eax
 9d9:	cd 40                	int    $0x40
 9db:	c3                   	ret    

000009dc <getuseddisk>:
SYSCALL(getuseddisk)
 9dc:	b8 20 00 00 00       	mov    $0x20,%eax
 9e1:	cd 40                	int    $0x40
 9e3:	c3                   	ret    

000009e4 <setuseddisk>:
SYSCALL(setuseddisk)
 9e4:	b8 21 00 00 00       	mov    $0x21,%eax
 9e9:	cd 40                	int    $0x40
 9eb:	c3                   	ret    

000009ec <setvc>:
SYSCALL(setvc)
 9ec:	b8 22 00 00 00       	mov    $0x22,%eax
 9f1:	cd 40                	int    $0x40
 9f3:	c3                   	ret    

000009f4 <setactivefs>:
SYSCALL(setactivefs)
 9f4:	b8 24 00 00 00       	mov    $0x24,%eax
 9f9:	cd 40                	int    $0x40
 9fb:	c3                   	ret    

000009fc <getactivefs>:
SYSCALL(getactivefs)
 9fc:	b8 25 00 00 00       	mov    $0x25,%eax
 a01:	cd 40                	int    $0x40
 a03:	c3                   	ret    

00000a04 <getvcfs>:
SYSCALL(getvcfs)
 a04:	b8 23 00 00 00       	mov    $0x23,%eax
 a09:	cd 40                	int    $0x40
 a0b:	c3                   	ret    

00000a0c <getcwd>:
SYSCALL(getcwd)
 a0c:	b8 26 00 00 00       	mov    $0x26,%eax
 a11:	cd 40                	int    $0x40
 a13:	c3                   	ret    

00000a14 <tostring>:
SYSCALL(tostring)
 a14:	b8 27 00 00 00       	mov    $0x27,%eax
 a19:	cd 40                	int    $0x40
 a1b:	c3                   	ret    

00000a1c <getactivefsindex>:
SYSCALL(getactivefsindex)
 a1c:	b8 28 00 00 00       	mov    $0x28,%eax
 a21:	cd 40                	int    $0x40
 a23:	c3                   	ret    

00000a24 <setatroot>:
SYSCALL(setatroot)
 a24:	b8 2a 00 00 00       	mov    $0x2a,%eax
 a29:	cd 40                	int    $0x40
 a2b:	c3                   	ret    

00000a2c <getatroot>:
SYSCALL(getatroot)
 a2c:	b8 29 00 00 00       	mov    $0x29,%eax
 a31:	cd 40                	int    $0x40
 a33:	c3                   	ret    

00000a34 <getpath>:
SYSCALL(getpath)
 a34:	b8 2b 00 00 00       	mov    $0x2b,%eax
 a39:	cd 40                	int    $0x40
 a3b:	c3                   	ret    

00000a3c <setpath>:
SYSCALL(setpath)
 a3c:	b8 2c 00 00 00       	mov    $0x2c,%eax
 a41:	cd 40                	int    $0x40
 a43:	c3                   	ret    

00000a44 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a44:	55                   	push   %ebp
 a45:	89 e5                	mov    %esp,%ebp
 a47:	83 ec 18             	sub    $0x18,%esp
 a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
 a4d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a50:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 a57:	00 
 a58:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
 a5f:	8b 45 08             	mov    0x8(%ebp),%eax
 a62:	89 04 24             	mov    %eax,(%esp)
 a65:	e8 a2 fe ff ff       	call   90c <write>
}
 a6a:	c9                   	leave  
 a6b:	c3                   	ret    

00000a6c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a6c:	55                   	push   %ebp
 a6d:	89 e5                	mov    %esp,%ebp
 a6f:	56                   	push   %esi
 a70:	53                   	push   %ebx
 a71:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a74:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a7b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a7f:	74 17                	je     a98 <printint+0x2c>
 a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a85:	79 11                	jns    a98 <printint+0x2c>
    neg = 1;
 a87:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a8e:	8b 45 0c             	mov    0xc(%ebp),%eax
 a91:	f7 d8                	neg    %eax
 a93:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a96:	eb 06                	jmp    a9e <printint+0x32>
  } else {
    x = xx;
 a98:	8b 45 0c             	mov    0xc(%ebp),%eax
 a9b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 aa5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 aa8:	8d 41 01             	lea    0x1(%ecx),%eax
 aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aae:	8b 5d 10             	mov    0x10(%ebp),%ebx
 ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ab4:	ba 00 00 00 00       	mov    $0x0,%edx
 ab9:	f7 f3                	div    %ebx
 abb:	89 d0                	mov    %edx,%eax
 abd:	8a 80 4c 13 00 00    	mov    0x134c(%eax),%al
 ac3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 ac7:	8b 75 10             	mov    0x10(%ebp),%esi
 aca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 acd:	ba 00 00 00 00       	mov    $0x0,%edx
 ad2:	f7 f6                	div    %esi
 ad4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ad7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 adb:	75 c8                	jne    aa5 <printint+0x39>
  if(neg)
 add:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ae1:	74 10                	je     af3 <printint+0x87>
    buf[i++] = '-';
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	8d 50 01             	lea    0x1(%eax),%edx
 ae9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 aec:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 af1:	eb 1e                	jmp    b11 <printint+0xa5>
 af3:	eb 1c                	jmp    b11 <printint+0xa5>
    putc(fd, buf[i]);
 af5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afb:	01 d0                	add    %edx,%eax
 afd:	8a 00                	mov    (%eax),%al
 aff:	0f be c0             	movsbl %al,%eax
 b02:	89 44 24 04          	mov    %eax,0x4(%esp)
 b06:	8b 45 08             	mov    0x8(%ebp),%eax
 b09:	89 04 24             	mov    %eax,(%esp)
 b0c:	e8 33 ff ff ff       	call   a44 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b11:	ff 4d f4             	decl   -0xc(%ebp)
 b14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b18:	79 db                	jns    af5 <printint+0x89>
    putc(fd, buf[i]);
}
 b1a:	83 c4 30             	add    $0x30,%esp
 b1d:	5b                   	pop    %ebx
 b1e:	5e                   	pop    %esi
 b1f:	5d                   	pop    %ebp
 b20:	c3                   	ret    

00000b21 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b21:	55                   	push   %ebp
 b22:	89 e5                	mov    %esp,%ebp
 b24:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b27:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b2e:	8d 45 0c             	lea    0xc(%ebp),%eax
 b31:	83 c0 04             	add    $0x4,%eax
 b34:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b3e:	e9 77 01 00 00       	jmp    cba <printf+0x199>
    c = fmt[i] & 0xff;
 b43:	8b 55 0c             	mov    0xc(%ebp),%edx
 b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b49:	01 d0                	add    %edx,%eax
 b4b:	8a 00                	mov    (%eax),%al
 b4d:	0f be c0             	movsbl %al,%eax
 b50:	25 ff 00 00 00       	and    $0xff,%eax
 b55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b5c:	75 2c                	jne    b8a <printf+0x69>
      if(c == '%'){
 b5e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b62:	75 0c                	jne    b70 <printf+0x4f>
        state = '%';
 b64:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b6b:	e9 47 01 00 00       	jmp    cb7 <printf+0x196>
      } else {
        putc(fd, c);
 b70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b73:	0f be c0             	movsbl %al,%eax
 b76:	89 44 24 04          	mov    %eax,0x4(%esp)
 b7a:	8b 45 08             	mov    0x8(%ebp),%eax
 b7d:	89 04 24             	mov    %eax,(%esp)
 b80:	e8 bf fe ff ff       	call   a44 <putc>
 b85:	e9 2d 01 00 00       	jmp    cb7 <printf+0x196>
      }
    } else if(state == '%'){
 b8a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b8e:	0f 85 23 01 00 00    	jne    cb7 <printf+0x196>
      if(c == 'd'){
 b94:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b98:	75 2d                	jne    bc7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 b9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b9d:	8b 00                	mov    (%eax),%eax
 b9f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 ba6:	00 
 ba7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 bae:	00 
 baf:	89 44 24 04          	mov    %eax,0x4(%esp)
 bb3:	8b 45 08             	mov    0x8(%ebp),%eax
 bb6:	89 04 24             	mov    %eax,(%esp)
 bb9:	e8 ae fe ff ff       	call   a6c <printint>
        ap++;
 bbe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bc2:	e9 e9 00 00 00       	jmp    cb0 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 bc7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 bcb:	74 06                	je     bd3 <printf+0xb2>
 bcd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 bd1:	75 2d                	jne    c00 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 bd3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bd6:	8b 00                	mov    (%eax),%eax
 bd8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 bdf:	00 
 be0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 be7:	00 
 be8:	89 44 24 04          	mov    %eax,0x4(%esp)
 bec:	8b 45 08             	mov    0x8(%ebp),%eax
 bef:	89 04 24             	mov    %eax,(%esp)
 bf2:	e8 75 fe ff ff       	call   a6c <printint>
        ap++;
 bf7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bfb:	e9 b0 00 00 00       	jmp    cb0 <printf+0x18f>
      } else if(c == 's'){
 c00:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 c04:	75 42                	jne    c48 <printf+0x127>
        s = (char*)*ap;
 c06:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c09:	8b 00                	mov    (%eax),%eax
 c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c0e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c16:	75 09                	jne    c21 <printf+0x100>
          s = "(null)";
 c18:	c7 45 f4 56 0f 00 00 	movl   $0xf56,-0xc(%ebp)
        while(*s != 0){
 c1f:	eb 1c                	jmp    c3d <printf+0x11c>
 c21:	eb 1a                	jmp    c3d <printf+0x11c>
          putc(fd, *s);
 c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c26:	8a 00                	mov    (%eax),%al
 c28:	0f be c0             	movsbl %al,%eax
 c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
 c2f:	8b 45 08             	mov    0x8(%ebp),%eax
 c32:	89 04 24             	mov    %eax,(%esp)
 c35:	e8 0a fe ff ff       	call   a44 <putc>
          s++;
 c3a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c40:	8a 00                	mov    (%eax),%al
 c42:	84 c0                	test   %al,%al
 c44:	75 dd                	jne    c23 <printf+0x102>
 c46:	eb 68                	jmp    cb0 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c48:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c4c:	75 1d                	jne    c6b <printf+0x14a>
        putc(fd, *ap);
 c4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c51:	8b 00                	mov    (%eax),%eax
 c53:	0f be c0             	movsbl %al,%eax
 c56:	89 44 24 04          	mov    %eax,0x4(%esp)
 c5a:	8b 45 08             	mov    0x8(%ebp),%eax
 c5d:	89 04 24             	mov    %eax,(%esp)
 c60:	e8 df fd ff ff       	call   a44 <putc>
        ap++;
 c65:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c69:	eb 45                	jmp    cb0 <printf+0x18f>
      } else if(c == '%'){
 c6b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c6f:	75 17                	jne    c88 <printf+0x167>
        putc(fd, c);
 c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c74:	0f be c0             	movsbl %al,%eax
 c77:	89 44 24 04          	mov    %eax,0x4(%esp)
 c7b:	8b 45 08             	mov    0x8(%ebp),%eax
 c7e:	89 04 24             	mov    %eax,(%esp)
 c81:	e8 be fd ff ff       	call   a44 <putc>
 c86:	eb 28                	jmp    cb0 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c88:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 c8f:	00 
 c90:	8b 45 08             	mov    0x8(%ebp),%eax
 c93:	89 04 24             	mov    %eax,(%esp)
 c96:	e8 a9 fd ff ff       	call   a44 <putc>
        putc(fd, c);
 c9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c9e:	0f be c0             	movsbl %al,%eax
 ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
 ca5:	8b 45 08             	mov    0x8(%ebp),%eax
 ca8:	89 04 24             	mov    %eax,(%esp)
 cab:	e8 94 fd ff ff       	call   a44 <putc>
      }
      state = 0;
 cb0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 cb7:	ff 45 f0             	incl   -0x10(%ebp)
 cba:	8b 55 0c             	mov    0xc(%ebp),%edx
 cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cc0:	01 d0                	add    %edx,%eax
 cc2:	8a 00                	mov    (%eax),%al
 cc4:	84 c0                	test   %al,%al
 cc6:	0f 85 77 fe ff ff    	jne    b43 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 ccc:	c9                   	leave  
 ccd:	c3                   	ret    
 cce:	90                   	nop
 ccf:	90                   	nop

00000cd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cd0:	55                   	push   %ebp
 cd1:	89 e5                	mov    %esp,%ebp
 cd3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cd6:	8b 45 08             	mov    0x8(%ebp),%eax
 cd9:	83 e8 08             	sub    $0x8,%eax
 cdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cdf:	a1 70 13 00 00       	mov    0x1370,%eax
 ce4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ce7:	eb 24                	jmp    d0d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cec:	8b 00                	mov    (%eax),%eax
 cee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cf1:	77 12                	ja     d05 <free+0x35>
 cf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 cf9:	77 24                	ja     d1f <free+0x4f>
 cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfe:	8b 00                	mov    (%eax),%eax
 d00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d03:	77 1a                	ja     d1f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d08:	8b 00                	mov    (%eax),%eax
 d0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d10:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d13:	76 d4                	jbe    ce9 <free+0x19>
 d15:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d18:	8b 00                	mov    (%eax),%eax
 d1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d1d:	76 ca                	jbe    ce9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 d1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d22:	8b 40 04             	mov    0x4(%eax),%eax
 d25:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d2f:	01 c2                	add    %eax,%edx
 d31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d34:	8b 00                	mov    (%eax),%eax
 d36:	39 c2                	cmp    %eax,%edx
 d38:	75 24                	jne    d5e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d3d:	8b 50 04             	mov    0x4(%eax),%edx
 d40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d43:	8b 00                	mov    (%eax),%eax
 d45:	8b 40 04             	mov    0x4(%eax),%eax
 d48:	01 c2                	add    %eax,%edx
 d4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d4d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d50:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d53:	8b 00                	mov    (%eax),%eax
 d55:	8b 10                	mov    (%eax),%edx
 d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d5a:	89 10                	mov    %edx,(%eax)
 d5c:	eb 0a                	jmp    d68 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d61:	8b 10                	mov    (%eax),%edx
 d63:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d66:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d68:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d6b:	8b 40 04             	mov    0x4(%eax),%eax
 d6e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d78:	01 d0                	add    %edx,%eax
 d7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d7d:	75 20                	jne    d9f <free+0xcf>
    p->s.size += bp->s.size;
 d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d82:	8b 50 04             	mov    0x4(%eax),%edx
 d85:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d88:	8b 40 04             	mov    0x4(%eax),%eax
 d8b:	01 c2                	add    %eax,%edx
 d8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d90:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d93:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d96:	8b 10                	mov    (%eax),%edx
 d98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d9b:	89 10                	mov    %edx,(%eax)
 d9d:	eb 08                	jmp    da7 <free+0xd7>
  } else
    p->s.ptr = bp;
 d9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 da2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 da5:	89 10                	mov    %edx,(%eax)
  freep = p;
 da7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 daa:	a3 70 13 00 00       	mov    %eax,0x1370
}
 daf:	c9                   	leave  
 db0:	c3                   	ret    

00000db1 <morecore>:

static Header*
morecore(uint nu)
{
 db1:	55                   	push   %ebp
 db2:	89 e5                	mov    %esp,%ebp
 db4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 db7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 dbe:	77 07                	ja     dc7 <morecore+0x16>
    nu = 4096;
 dc0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 dc7:	8b 45 08             	mov    0x8(%ebp),%eax
 dca:	c1 e0 03             	shl    $0x3,%eax
 dcd:	89 04 24             	mov    %eax,(%esp)
 dd0:	e8 9f fb ff ff       	call   974 <sbrk>
 dd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 dd8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ddc:	75 07                	jne    de5 <morecore+0x34>
    return 0;
 dde:	b8 00 00 00 00       	mov    $0x0,%eax
 de3:	eb 22                	jmp    e07 <morecore+0x56>
  hp = (Header*)p;
 de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 deb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dee:	8b 55 08             	mov    0x8(%ebp),%edx
 df1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 df4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 df7:	83 c0 08             	add    $0x8,%eax
 dfa:	89 04 24             	mov    %eax,(%esp)
 dfd:	e8 ce fe ff ff       	call   cd0 <free>
  return freep;
 e02:	a1 70 13 00 00       	mov    0x1370,%eax
}
 e07:	c9                   	leave  
 e08:	c3                   	ret    

00000e09 <malloc>:

void*
malloc(uint nbytes)
{
 e09:	55                   	push   %ebp
 e0a:	89 e5                	mov    %esp,%ebp
 e0c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e0f:	8b 45 08             	mov    0x8(%ebp),%eax
 e12:	83 c0 07             	add    $0x7,%eax
 e15:	c1 e8 03             	shr    $0x3,%eax
 e18:	40                   	inc    %eax
 e19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e1c:	a1 70 13 00 00       	mov    0x1370,%eax
 e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e28:	75 23                	jne    e4d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 e2a:	c7 45 f0 68 13 00 00 	movl   $0x1368,-0x10(%ebp)
 e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e34:	a3 70 13 00 00       	mov    %eax,0x1370
 e39:	a1 70 13 00 00       	mov    0x1370,%eax
 e3e:	a3 68 13 00 00       	mov    %eax,0x1368
    base.s.size = 0;
 e43:	c7 05 6c 13 00 00 00 	movl   $0x0,0x136c
 e4a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e50:	8b 00                	mov    (%eax),%eax
 e52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e58:	8b 40 04             	mov    0x4(%eax),%eax
 e5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e5e:	72 4d                	jb     ead <malloc+0xa4>
      if(p->s.size == nunits)
 e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e63:	8b 40 04             	mov    0x4(%eax),%eax
 e66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e69:	75 0c                	jne    e77 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e6e:	8b 10                	mov    (%eax),%edx
 e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e73:	89 10                	mov    %edx,(%eax)
 e75:	eb 26                	jmp    e9d <malloc+0x94>
      else {
        p->s.size -= nunits;
 e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e7a:	8b 40 04             	mov    0x4(%eax),%eax
 e7d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e80:	89 c2                	mov    %eax,%edx
 e82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e85:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e8b:	8b 40 04             	mov    0x4(%eax),%eax
 e8e:	c1 e0 03             	shl    $0x3,%eax
 e91:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e97:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e9a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ea0:	a3 70 13 00 00       	mov    %eax,0x1370
      return (void*)(p + 1);
 ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ea8:	83 c0 08             	add    $0x8,%eax
 eab:	eb 38                	jmp    ee5 <malloc+0xdc>
    }
    if(p == freep)
 ead:	a1 70 13 00 00       	mov    0x1370,%eax
 eb2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 eb5:	75 1b                	jne    ed2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 eb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 eba:	89 04 24             	mov    %eax,(%esp)
 ebd:	e8 ef fe ff ff       	call   db1 <morecore>
 ec2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ec5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ec9:	75 07                	jne    ed2 <malloc+0xc9>
        return 0;
 ecb:	b8 00 00 00 00       	mov    $0x0,%eax
 ed0:	eb 13                	jmp    ee5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ed5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 edb:	8b 00                	mov    (%eax),%eax
 edd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ee0:	e9 70 ff ff ff       	jmp    e55 <malloc+0x4c>
}
 ee5:	c9                   	leave  
 ee6:	c3                   	ret    
