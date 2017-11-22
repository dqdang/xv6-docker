
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
   f:	c7 44 24 04 00 13 00 	movl   $0x1300,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 fd 08 00 00       	call   920 <write>
  23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  26:	74 19                	je     41 <cat+0x41>
      printf(1, "cat: write error\n");
  28:	c7 44 24 04 43 0e 00 	movl   $0xe43,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 41 0a 00 00       	call   a7d <printf>
      exit();
  3c:	e8 bf 08 00 00       	call   900 <exit>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  41:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  48:	00 
  49:	c7 44 24 04 00 13 00 	movl   $0x1300,0x4(%esp)
  50:	00 
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 bc 08 00 00       	call   918 <read>
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
  6b:	c7 44 24 04 55 0e 00 	movl   $0xe55,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 fe 09 00 00       	call   a7d <printf>
    exit();
  7f:	e8 7c 08 00 00       	call   900 <exit>
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
  a1:	e8 5a 08 00 00       	call   900 <exit>
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
  cd:	e8 6e 08 00 00       	call   940 <open>
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
  f3:	c7 44 24 04 66 0e 00 	movl   $0xe66,0x4(%esp)
  fa:	00 
  fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 102:	e8 76 09 00 00       	call   a7d <printf>
      exit();
 107:	e8 f4 07 00 00       	call   900 <exit>
    }
    cat(fd);
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	89 04 24             	mov    %eax,(%esp)
 113:	e8 e8 fe ff ff       	call   0 <cat>
    close(fd);
 118:	8b 44 24 18          	mov    0x18(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 04 08 00 00       	call   928 <close>
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
 135:	e8 c6 07 00 00       	call   900 <exit>
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

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
 195:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 19c:	00 
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	89 04 24             	mov    %eax,(%esp)
 1a3:	e8 98 07 00 00       	call   940 <open>
 1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1af:	79 20                	jns    1d1 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b8:	c7 44 24 04 7b 0e 00 	movl   $0xe7b,0x4(%esp)
 1bf:	00 
 1c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c7:	e8 b1 08 00 00       	call   a7d <printf>
        exit();
 1cc:	e8 2f 07 00 00       	call   900 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 1d1:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 1d8:	00 
 1d9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1dc:	89 04 24             	mov    %eax,(%esp)
 1df:	e8 5c 07 00 00       	call   940 <open>
 1e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 1e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 1eb:	79 20                	jns    20d <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 1ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1f4:	c7 44 24 04 96 0e 00 	movl   $0xe96,0x4(%esp)
 1fb:	00 
 1fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 203:	e8 75 08 00 00       	call   a7d <printf>
        exit();
 208:	e8 f3 06 00 00       	call   900 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 20d:	eb 56                	jmp    265 <copy+0xd6>
        int max = used_disk+=count;
 20f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 212:	01 45 10             	add    %eax,0x10(%ebp)
 215:	8b 45 10             	mov    0x10(%ebp),%eax
 218:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 21b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 21e:	89 44 24 08          	mov    %eax,0x8(%esp)
 222:	c7 44 24 04 b2 0e 00 	movl   $0xeb2,0x4(%esp)
 229:	00 
 22a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 231:	e8 47 08 00 00       	call   a7d <printf>
        if(max > max_disk){
 236:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 239:	3b 45 14             	cmp    0x14(%ebp),%eax
 23c:	7e 07                	jle    245 <copy+0xb6>
          return -1;
 23e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 243:	eb 5c                	jmp    2a1 <copy+0x112>
        }
        bytes = bytes + count;
 245:	8b 45 e8             	mov    -0x18(%ebp),%eax
 248:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 24b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 252:	00 
 253:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 256:	89 44 24 04          	mov    %eax,0x4(%esp)
 25a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 25d:	89 04 24             	mov    %eax,(%esp)
 260:	e8 bb 06 00 00       	call   920 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 265:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 26c:	00 
 26d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 270:	89 44 24 04          	mov    %eax,0x4(%esp)
 274:	8b 45 f0             	mov    -0x10(%ebp),%eax
 277:	89 04 24             	mov    %eax,(%esp)
 27a:	e8 99 06 00 00       	call   918 <read>
 27f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 282:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 286:	7f 87                	jg     20f <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 288:	8b 45 f0             	mov    -0x10(%ebp),%eax
 28b:	89 04 24             	mov    %eax,(%esp)
 28e:	e8 95 06 00 00       	call   928 <close>
    close(fd2);
 293:	8b 45 ec             	mov    -0x14(%ebp),%eax
 296:	89 04 24             	mov    %eax,(%esp)
 299:	e8 8a 06 00 00       	call   928 <close>
    return(bytes);
 29e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 2a1:	c9                   	leave  
 2a2:	c3                   	ret    

000002a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2a3:	55                   	push   %ebp
 2a4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 2a6:	eb 06                	jmp    2ae <strcmp+0xb>
    p++, q++;
 2a8:	ff 45 08             	incl   0x8(%ebp)
 2ab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	8a 00                	mov    (%eax),%al
 2b3:	84 c0                	test   %al,%al
 2b5:	74 0e                	je     2c5 <strcmp+0x22>
 2b7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ba:	8a 10                	mov    (%eax),%dl
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	8a 00                	mov    (%eax),%al
 2c1:	38 c2                	cmp    %al,%dl
 2c3:	74 e3                	je     2a8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	8a 00                	mov    (%eax),%al
 2ca:	0f b6 d0             	movzbl %al,%edx
 2cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d0:	8a 00                	mov    (%eax),%al
 2d2:	0f b6 c0             	movzbl %al,%eax
 2d5:	29 c2                	sub    %eax,%edx
 2d7:	89 d0                	mov    %edx,%eax
}
 2d9:	5d                   	pop    %ebp
 2da:	c3                   	ret    

000002db <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 2db:	55                   	push   %ebp
 2dc:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 2de:	eb 09                	jmp    2e9 <strncmp+0xe>
    n--, p++, q++;
 2e0:	ff 4d 10             	decl   0x10(%ebp)
 2e3:	ff 45 08             	incl   0x8(%ebp)
 2e6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 2e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2ed:	74 17                	je     306 <strncmp+0x2b>
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	8a 00                	mov    (%eax),%al
 2f4:	84 c0                	test   %al,%al
 2f6:	74 0e                	je     306 <strncmp+0x2b>
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	8a 10                	mov    (%eax),%dl
 2fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 300:	8a 00                	mov    (%eax),%al
 302:	38 c2                	cmp    %al,%dl
 304:	74 da                	je     2e0 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 306:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 30a:	75 07                	jne    313 <strncmp+0x38>
    return 0;
 30c:	b8 00 00 00 00       	mov    $0x0,%eax
 311:	eb 14                	jmp    327 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	8a 00                	mov    (%eax),%al
 318:	0f b6 d0             	movzbl %al,%edx
 31b:	8b 45 0c             	mov    0xc(%ebp),%eax
 31e:	8a 00                	mov    (%eax),%al
 320:	0f b6 c0             	movzbl %al,%eax
 323:	29 c2                	sub    %eax,%edx
 325:	89 d0                	mov    %edx,%eax
}
 327:	5d                   	pop    %ebp
 328:	c3                   	ret    

00000329 <strlen>:

uint
strlen(const char *s)
{
 329:	55                   	push   %ebp
 32a:	89 e5                	mov    %esp,%ebp
 32c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 32f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 336:	eb 03                	jmp    33b <strlen+0x12>
 338:	ff 45 fc             	incl   -0x4(%ebp)
 33b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33e:	8b 45 08             	mov    0x8(%ebp),%eax
 341:	01 d0                	add    %edx,%eax
 343:	8a 00                	mov    (%eax),%al
 345:	84 c0                	test   %al,%al
 347:	75 ef                	jne    338 <strlen+0xf>
    ;
  return n;
 349:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <memset>:

void*
memset(void *dst, int c, uint n)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 354:	8b 45 10             	mov    0x10(%ebp),%eax
 357:	89 44 24 08          	mov    %eax,0x8(%esp)
 35b:	8b 45 0c             	mov    0xc(%ebp),%eax
 35e:	89 44 24 04          	mov    %eax,0x4(%esp)
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	89 04 24             	mov    %eax,(%esp)
 368:	e8 cf fd ff ff       	call   13c <stosb>
  return dst;
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 370:	c9                   	leave  
 371:	c3                   	ret    

00000372 <strchr>:

char*
strchr(const char *s, char c)
{
 372:	55                   	push   %ebp
 373:	89 e5                	mov    %esp,%ebp
 375:	83 ec 04             	sub    $0x4,%esp
 378:	8b 45 0c             	mov    0xc(%ebp),%eax
 37b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 37e:	eb 12                	jmp    392 <strchr+0x20>
    if(*s == c)
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	8a 00                	mov    (%eax),%al
 385:	3a 45 fc             	cmp    -0x4(%ebp),%al
 388:	75 05                	jne    38f <strchr+0x1d>
      return (char*)s;
 38a:	8b 45 08             	mov    0x8(%ebp),%eax
 38d:	eb 11                	jmp    3a0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 38f:	ff 45 08             	incl   0x8(%ebp)
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	8a 00                	mov    (%eax),%al
 397:	84 c0                	test   %al,%al
 399:	75 e5                	jne    380 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 39b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3a0:	c9                   	leave  
 3a1:	c3                   	ret    

000003a2 <strcat>:

char *
strcat(char *dest, const char *src)
{
 3a2:	55                   	push   %ebp
 3a3:	89 e5                	mov    %esp,%ebp
 3a5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 3a8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3af:	eb 03                	jmp    3b4 <strcat+0x12>
 3b1:	ff 45 fc             	incl   -0x4(%ebp)
 3b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ba:	01 d0                	add    %edx,%eax
 3bc:	8a 00                	mov    (%eax),%al
 3be:	84 c0                	test   %al,%al
 3c0:	75 ef                	jne    3b1 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 3c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 3c9:	eb 1e                	jmp    3e9 <strcat+0x47>
        dest[i+j] = src[j];
 3cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d1:	01 d0                	add    %edx,%eax
 3d3:	89 c2                	mov    %eax,%edx
 3d5:	8b 45 08             	mov    0x8(%ebp),%eax
 3d8:	01 c2                	add    %eax,%edx
 3da:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e0:	01 c8                	add    %ecx,%eax
 3e2:	8a 00                	mov    (%eax),%al
 3e4:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 3e6:	ff 45 f8             	incl   -0x8(%ebp)
 3e9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ef:	01 d0                	add    %edx,%eax
 3f1:	8a 00                	mov    (%eax),%al
 3f3:	84 c0                	test   %al,%al
 3f5:	75 d4                	jne    3cb <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 3f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fd:	01 d0                	add    %edx,%eax
 3ff:	89 c2                	mov    %eax,%edx
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	01 d0                	add    %edx,%eax
 406:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 409:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40c:	c9                   	leave  
 40d:	c3                   	ret    

0000040e <strstr>:

int 
strstr(char* s, char* sub)
{
 40e:	55                   	push   %ebp
 40f:	89 e5                	mov    %esp,%ebp
 411:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 41b:	eb 7c                	jmp    499 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 41d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	01 d0                	add    %edx,%eax
 425:	8a 10                	mov    (%eax),%dl
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	8a 00                	mov    (%eax),%al
 42c:	38 c2                	cmp    %al,%dl
 42e:	75 66                	jne    496 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 430:	8b 45 0c             	mov    0xc(%ebp),%eax
 433:	89 04 24             	mov    %eax,(%esp)
 436:	e8 ee fe ff ff       	call   329 <strlen>
 43b:	83 f8 01             	cmp    $0x1,%eax
 43e:	75 05                	jne    445 <strstr+0x37>
            {  
                return i;
 440:	8b 45 fc             	mov    -0x4(%ebp),%eax
 443:	eb 6b                	jmp    4b0 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 445:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 44c:	eb 3a                	jmp    488 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 44e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 451:	8b 55 fc             	mov    -0x4(%ebp),%edx
 454:	01 d0                	add    %edx,%eax
 456:	89 c2                	mov    %eax,%edx
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	01 d0                	add    %edx,%eax
 45d:	8a 10                	mov    (%eax),%dl
 45f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	01 c8                	add    %ecx,%eax
 467:	8a 00                	mov    (%eax),%al
 469:	38 c2                	cmp    %al,%dl
 46b:	75 16                	jne    483 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 46d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 470:	8d 50 01             	lea    0x1(%eax),%edx
 473:	8b 45 0c             	mov    0xc(%ebp),%eax
 476:	01 d0                	add    %edx,%eax
 478:	8a 00                	mov    (%eax),%al
 47a:	84 c0                	test   %al,%al
 47c:	75 07                	jne    485 <strstr+0x77>
                    {
                        return i;
 47e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 481:	eb 2d                	jmp    4b0 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 483:	eb 11                	jmp    496 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 485:	ff 45 f8             	incl   -0x8(%ebp)
 488:	8b 55 f8             	mov    -0x8(%ebp),%edx
 48b:	8b 45 0c             	mov    0xc(%ebp),%eax
 48e:	01 d0                	add    %edx,%eax
 490:	8a 00                	mov    (%eax),%al
 492:	84 c0                	test   %al,%al
 494:	75 b8                	jne    44e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 496:	ff 45 fc             	incl   -0x4(%ebp)
 499:	8b 55 fc             	mov    -0x4(%ebp),%edx
 49c:	8b 45 08             	mov    0x8(%ebp),%eax
 49f:	01 d0                	add    %edx,%eax
 4a1:	8a 00                	mov    (%eax),%al
 4a3:	84 c0                	test   %al,%al
 4a5:	0f 85 72 ff ff ff    	jne    41d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 4ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 4b0:	c9                   	leave  
 4b1:	c3                   	ret    

000004b2 <strtok>:

char *
strtok(char *s, const char *delim)
{
 4b2:	55                   	push   %ebp
 4b3:	89 e5                	mov    %esp,%ebp
 4b5:	53                   	push   %ebx
 4b6:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 4b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 4bd:	75 08                	jne    4c7 <strtok+0x15>
  s = lasts;
 4bf:	a1 e4 12 00 00       	mov    0x12e4,%eax
 4c4:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	8d 50 01             	lea    0x1(%eax),%edx
 4cd:	89 55 08             	mov    %edx,0x8(%ebp)
 4d0:	8a 00                	mov    (%eax),%al
 4d2:	0f be d8             	movsbl %al,%ebx
 4d5:	85 db                	test   %ebx,%ebx
 4d7:	75 07                	jne    4e0 <strtok+0x2e>
      return 0;
 4d9:	b8 00 00 00 00       	mov    $0x0,%eax
 4de:	eb 58                	jmp    538 <strtok+0x86>
    } while (strchr(delim, ch));
 4e0:	88 d8                	mov    %bl,%al
 4e2:	0f be c0             	movsbl %al,%eax
 4e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ec:	89 04 24             	mov    %eax,(%esp)
 4ef:	e8 7e fe ff ff       	call   372 <strchr>
 4f4:	85 c0                	test   %eax,%eax
 4f6:	75 cf                	jne    4c7 <strtok+0x15>
    --s;
 4f8:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 4fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 502:	8b 45 08             	mov    0x8(%ebp),%eax
 505:	89 04 24             	mov    %eax,(%esp)
 508:	e8 31 00 00 00       	call   53e <strcspn>
 50d:	89 c2                	mov    %eax,%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	01 d0                	add    %edx,%eax
 514:	a3 e4 12 00 00       	mov    %eax,0x12e4
    if (*lasts != 0)
 519:	a1 e4 12 00 00       	mov    0x12e4,%eax
 51e:	8a 00                	mov    (%eax),%al
 520:	84 c0                	test   %al,%al
 522:	74 11                	je     535 <strtok+0x83>
  *lasts++ = 0;
 524:	a1 e4 12 00 00       	mov    0x12e4,%eax
 529:	8d 50 01             	lea    0x1(%eax),%edx
 52c:	89 15 e4 12 00 00    	mov    %edx,0x12e4
 532:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 535:	8b 45 08             	mov    0x8(%ebp),%eax
}
 538:	83 c4 14             	add    $0x14,%esp
 53b:	5b                   	pop    %ebx
 53c:	5d                   	pop    %ebp
 53d:	c3                   	ret    

0000053e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 53e:	55                   	push   %ebp
 53f:	89 e5                	mov    %esp,%ebp
 541:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 544:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 54b:	eb 26                	jmp    573 <strcspn+0x35>
        if(strchr(s2,*s1))
 54d:	8b 45 08             	mov    0x8(%ebp),%eax
 550:	8a 00                	mov    (%eax),%al
 552:	0f be c0             	movsbl %al,%eax
 555:	89 44 24 04          	mov    %eax,0x4(%esp)
 559:	8b 45 0c             	mov    0xc(%ebp),%eax
 55c:	89 04 24             	mov    %eax,(%esp)
 55f:	e8 0e fe ff ff       	call   372 <strchr>
 564:	85 c0                	test   %eax,%eax
 566:	74 05                	je     56d <strcspn+0x2f>
            return ret;
 568:	8b 45 fc             	mov    -0x4(%ebp),%eax
 56b:	eb 12                	jmp    57f <strcspn+0x41>
        else
            s1++,ret++;
 56d:	ff 45 08             	incl   0x8(%ebp)
 570:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 573:	8b 45 08             	mov    0x8(%ebp),%eax
 576:	8a 00                	mov    (%eax),%al
 578:	84 c0                	test   %al,%al
 57a:	75 d1                	jne    54d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 57c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 57f:	c9                   	leave  
 580:	c3                   	ret    

00000581 <isspace>:

int
isspace(unsigned char c)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	83 ec 04             	sub    $0x4,%esp
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 58d:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 591:	74 1e                	je     5b1 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 593:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 597:	74 18                	je     5b1 <isspace+0x30>
 599:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 59d:	74 12                	je     5b1 <isspace+0x30>
 59f:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 5a3:	74 0c                	je     5b1 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 5a5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 5a9:	74 06                	je     5b1 <isspace+0x30>
 5ab:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 5af:	75 07                	jne    5b8 <isspace+0x37>
 5b1:	b8 01 00 00 00       	mov    $0x1,%eax
 5b6:	eb 05                	jmp    5bd <isspace+0x3c>
 5b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 5bd:	c9                   	leave  
 5be:	c3                   	ret    

000005bf <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 5bf:	55                   	push   %ebp
 5c0:	89 e5                	mov    %esp,%ebp
 5c2:	57                   	push   %edi
 5c3:	56                   	push   %esi
 5c4:	53                   	push   %ebx
 5c5:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 5c8:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 5cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 5d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 5d7:	eb 01                	jmp    5da <strtoul+0x1b>
  p += 1;
 5d9:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 5da:	8a 03                	mov    (%ebx),%al
 5dc:	0f b6 c0             	movzbl %al,%eax
 5df:	89 04 24             	mov    %eax,(%esp)
 5e2:	e8 9a ff ff ff       	call   581 <isspace>
 5e7:	85 c0                	test   %eax,%eax
 5e9:	75 ee                	jne    5d9 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 5eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 5ef:	75 30                	jne    621 <strtoul+0x62>
    {
  if (*p == '0') {
 5f1:	8a 03                	mov    (%ebx),%al
 5f3:	3c 30                	cmp    $0x30,%al
 5f5:	75 21                	jne    618 <strtoul+0x59>
      p += 1;
 5f7:	43                   	inc    %ebx
      if (*p == 'x') {
 5f8:	8a 03                	mov    (%ebx),%al
 5fa:	3c 78                	cmp    $0x78,%al
 5fc:	75 0a                	jne    608 <strtoul+0x49>
    p += 1;
 5fe:	43                   	inc    %ebx
    base = 16;
 5ff:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 606:	eb 31                	jmp    639 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 608:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 60f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 616:	eb 21                	jmp    639 <strtoul+0x7a>
      }
  }
  else base = 10;
 618:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 61f:	eb 18                	jmp    639 <strtoul+0x7a>
    } else if (base == 16) {
 621:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 625:	75 12                	jne    639 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 627:	8a 03                	mov    (%ebx),%al
 629:	3c 30                	cmp    $0x30,%al
 62b:	75 0c                	jne    639 <strtoul+0x7a>
 62d:	8d 43 01             	lea    0x1(%ebx),%eax
 630:	8a 00                	mov    (%eax),%al
 632:	3c 78                	cmp    $0x78,%al
 634:	75 03                	jne    639 <strtoul+0x7a>
      p += 2;
 636:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 639:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 63d:	75 29                	jne    668 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 63f:	8a 03                	mov    (%ebx),%al
 641:	0f be c0             	movsbl %al,%eax
 644:	83 e8 30             	sub    $0x30,%eax
 647:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 649:	83 fe 07             	cmp    $0x7,%esi
 64c:	76 06                	jbe    654 <strtoul+0x95>
    break;
 64e:	90                   	nop
 64f:	e9 b6 00 00 00       	jmp    70a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 654:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 65b:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 65e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 665:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 666:	eb d7                	jmp    63f <strtoul+0x80>
    } else if (base == 10) {
 668:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 66c:	75 2b                	jne    699 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 66e:	8a 03                	mov    (%ebx),%al
 670:	0f be c0             	movsbl %al,%eax
 673:	83 e8 30             	sub    $0x30,%eax
 676:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 678:	83 fe 09             	cmp    $0x9,%esi
 67b:	76 06                	jbe    683 <strtoul+0xc4>
    break;
 67d:	90                   	nop
 67e:	e9 87 00 00 00       	jmp    70a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 683:	89 f8                	mov    %edi,%eax
 685:	c1 e0 02             	shl    $0x2,%eax
 688:	01 f8                	add    %edi,%eax
 68a:	01 c0                	add    %eax,%eax
 68c:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 68f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 696:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 697:	eb d5                	jmp    66e <strtoul+0xaf>
    } else if (base == 16) {
 699:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 69d:	75 35                	jne    6d4 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 69f:	8a 03                	mov    (%ebx),%al
 6a1:	0f be c0             	movsbl %al,%eax
 6a4:	83 e8 30             	sub    $0x30,%eax
 6a7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6a9:	83 fe 4a             	cmp    $0x4a,%esi
 6ac:	76 02                	jbe    6b0 <strtoul+0xf1>
    break;
 6ae:	eb 22                	jmp    6d2 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 6b0:	8a 86 80 12 00 00    	mov    0x1280(%esi),%al
 6b6:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 6b9:	83 fe 0f             	cmp    $0xf,%esi
 6bc:	76 02                	jbe    6c0 <strtoul+0x101>
    break;
 6be:	eb 12                	jmp    6d2 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 6c0:	89 f8                	mov    %edi,%eax
 6c2:	c1 e0 04             	shl    $0x4,%eax
 6c5:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6c8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 6cf:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 6d0:	eb cd                	jmp    69f <strtoul+0xe0>
 6d2:	eb 36                	jmp    70a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 6d4:	8a 03                	mov    (%ebx),%al
 6d6:	0f be c0             	movsbl %al,%eax
 6d9:	83 e8 30             	sub    $0x30,%eax
 6dc:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 6de:	83 fe 4a             	cmp    $0x4a,%esi
 6e1:	76 02                	jbe    6e5 <strtoul+0x126>
    break;
 6e3:	eb 25                	jmp    70a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 6e5:	8a 86 80 12 00 00    	mov    0x1280(%esi),%al
 6eb:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 6ee:	8b 45 10             	mov    0x10(%ebp),%eax
 6f1:	39 f0                	cmp    %esi,%eax
 6f3:	77 02                	ja     6f7 <strtoul+0x138>
    break;
 6f5:	eb 13                	jmp    70a <strtoul+0x14b>
      }
      result = result*base + digit;
 6f7:	8b 45 10             	mov    0x10(%ebp),%eax
 6fa:	0f af c7             	imul   %edi,%eax
 6fd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 700:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 707:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 708:	eb ca                	jmp    6d4 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 70a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70e:	75 03                	jne    713 <strtoul+0x154>
  p = string;
 710:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 717:	74 05                	je     71e <strtoul+0x15f>
  *endPtr = p;
 719:	8b 45 0c             	mov    0xc(%ebp),%eax
 71c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 71e:	89 f8                	mov    %edi,%eax
}
 720:	83 c4 14             	add    $0x14,%esp
 723:	5b                   	pop    %ebx
 724:	5e                   	pop    %esi
 725:	5f                   	pop    %edi
 726:	5d                   	pop    %ebp
 727:	c3                   	ret    

00000728 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 728:	55                   	push   %ebp
 729:	89 e5                	mov    %esp,%ebp
 72b:	53                   	push   %ebx
 72c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 72f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 732:	eb 01                	jmp    735 <strtol+0xd>
      p += 1;
 734:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 735:	8a 03                	mov    (%ebx),%al
 737:	0f b6 c0             	movzbl %al,%eax
 73a:	89 04 24             	mov    %eax,(%esp)
 73d:	e8 3f fe ff ff       	call   581 <isspace>
 742:	85 c0                	test   %eax,%eax
 744:	75 ee                	jne    734 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 746:	8a 03                	mov    (%ebx),%al
 748:	3c 2d                	cmp    $0x2d,%al
 74a:	75 1e                	jne    76a <strtol+0x42>
  p += 1;
 74c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 74d:	8b 45 10             	mov    0x10(%ebp),%eax
 750:	89 44 24 08          	mov    %eax,0x8(%esp)
 754:	8b 45 0c             	mov    0xc(%ebp),%eax
 757:	89 44 24 04          	mov    %eax,0x4(%esp)
 75b:	89 1c 24             	mov    %ebx,(%esp)
 75e:	e8 5c fe ff ff       	call   5bf <strtoul>
 763:	f7 d8                	neg    %eax
 765:	89 45 f8             	mov    %eax,-0x8(%ebp)
 768:	eb 20                	jmp    78a <strtol+0x62>
    } else {
  if (*p == '+') {
 76a:	8a 03                	mov    (%ebx),%al
 76c:	3c 2b                	cmp    $0x2b,%al
 76e:	75 01                	jne    771 <strtol+0x49>
      p += 1;
 770:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 771:	8b 45 10             	mov    0x10(%ebp),%eax
 774:	89 44 24 08          	mov    %eax,0x8(%esp)
 778:	8b 45 0c             	mov    0xc(%ebp),%eax
 77b:	89 44 24 04          	mov    %eax,0x4(%esp)
 77f:	89 1c 24             	mov    %ebx,(%esp)
 782:	e8 38 fe ff ff       	call   5bf <strtoul>
 787:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 78a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 78e:	75 17                	jne    7a7 <strtol+0x7f>
 790:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 794:	74 11                	je     7a7 <strtol+0x7f>
 796:	8b 45 0c             	mov    0xc(%ebp),%eax
 799:	8b 00                	mov    (%eax),%eax
 79b:	39 d8                	cmp    %ebx,%eax
 79d:	75 08                	jne    7a7 <strtol+0x7f>
  *endPtr = string;
 79f:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a2:	8b 55 08             	mov    0x8(%ebp),%edx
 7a5:	89 10                	mov    %edx,(%eax)
    }
    return result;
 7a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 7aa:	83 c4 1c             	add    $0x1c,%esp
 7ad:	5b                   	pop    %ebx
 7ae:	5d                   	pop    %ebp
 7af:	c3                   	ret    

000007b0 <gets>:

char*
gets(char *buf, int max)
{
 7b0:	55                   	push   %ebp
 7b1:	89 e5                	mov    %esp,%ebp
 7b3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 7bd:	eb 49                	jmp    808 <gets+0x58>
    cc = read(0, &c, 1);
 7bf:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7c6:	00 
 7c7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 7ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 7d5:	e8 3e 01 00 00       	call   918 <read>
 7da:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 7dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7e1:	7f 02                	jg     7e5 <gets+0x35>
      break;
 7e3:	eb 2c                	jmp    811 <gets+0x61>
    buf[i++] = c;
 7e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e8:	8d 50 01             	lea    0x1(%eax),%edx
 7eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
 7ee:	89 c2                	mov    %eax,%edx
 7f0:	8b 45 08             	mov    0x8(%ebp),%eax
 7f3:	01 c2                	add    %eax,%edx
 7f5:	8a 45 ef             	mov    -0x11(%ebp),%al
 7f8:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 7fa:	8a 45 ef             	mov    -0x11(%ebp),%al
 7fd:	3c 0a                	cmp    $0xa,%al
 7ff:	74 10                	je     811 <gets+0x61>
 801:	8a 45 ef             	mov    -0x11(%ebp),%al
 804:	3c 0d                	cmp    $0xd,%al
 806:	74 09                	je     811 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	40                   	inc    %eax
 80c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 80f:	7c ae                	jl     7bf <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 811:	8b 55 f4             	mov    -0xc(%ebp),%edx
 814:	8b 45 08             	mov    0x8(%ebp),%eax
 817:	01 d0                	add    %edx,%eax
 819:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 81c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 81f:	c9                   	leave  
 820:	c3                   	ret    

00000821 <stat>:

int
stat(char *n, struct stat *st)
{
 821:	55                   	push   %ebp
 822:	89 e5                	mov    %esp,%ebp
 824:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 827:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 82e:	00 
 82f:	8b 45 08             	mov    0x8(%ebp),%eax
 832:	89 04 24             	mov    %eax,(%esp)
 835:	e8 06 01 00 00       	call   940 <open>
 83a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 83d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 841:	79 07                	jns    84a <stat+0x29>
    return -1;
 843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 848:	eb 23                	jmp    86d <stat+0x4c>
  r = fstat(fd, st);
 84a:	8b 45 0c             	mov    0xc(%ebp),%eax
 84d:	89 44 24 04          	mov    %eax,0x4(%esp)
 851:	8b 45 f4             	mov    -0xc(%ebp),%eax
 854:	89 04 24             	mov    %eax,(%esp)
 857:	e8 fc 00 00 00       	call   958 <fstat>
 85c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 85f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 862:	89 04 24             	mov    %eax,(%esp)
 865:	e8 be 00 00 00       	call   928 <close>
  return r;
 86a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 86d:	c9                   	leave  
 86e:	c3                   	ret    

0000086f <atoi>:

int
atoi(const char *s)
{
 86f:	55                   	push   %ebp
 870:	89 e5                	mov    %esp,%ebp
 872:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 875:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 87c:	eb 24                	jmp    8a2 <atoi+0x33>
    n = n*10 + *s++ - '0';
 87e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 881:	89 d0                	mov    %edx,%eax
 883:	c1 e0 02             	shl    $0x2,%eax
 886:	01 d0                	add    %edx,%eax
 888:	01 c0                	add    %eax,%eax
 88a:	89 c1                	mov    %eax,%ecx
 88c:	8b 45 08             	mov    0x8(%ebp),%eax
 88f:	8d 50 01             	lea    0x1(%eax),%edx
 892:	89 55 08             	mov    %edx,0x8(%ebp)
 895:	8a 00                	mov    (%eax),%al
 897:	0f be c0             	movsbl %al,%eax
 89a:	01 c8                	add    %ecx,%eax
 89c:	83 e8 30             	sub    $0x30,%eax
 89f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8a2:	8b 45 08             	mov    0x8(%ebp),%eax
 8a5:	8a 00                	mov    (%eax),%al
 8a7:	3c 2f                	cmp    $0x2f,%al
 8a9:	7e 09                	jle    8b4 <atoi+0x45>
 8ab:	8b 45 08             	mov    0x8(%ebp),%eax
 8ae:	8a 00                	mov    (%eax),%al
 8b0:	3c 39                	cmp    $0x39,%al
 8b2:	7e ca                	jle    87e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 8b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 8b7:	c9                   	leave  
 8b8:	c3                   	ret    

000008b9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 8b9:	55                   	push   %ebp
 8ba:	89 e5                	mov    %esp,%ebp
 8bc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 8bf:	8b 45 08             	mov    0x8(%ebp),%eax
 8c2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 8c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 8c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 8cb:	eb 16                	jmp    8e3 <memmove+0x2a>
    *dst++ = *src++;
 8cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d0:	8d 50 01             	lea    0x1(%eax),%edx
 8d3:	89 55 fc             	mov    %edx,-0x4(%ebp)
 8d6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d9:	8d 4a 01             	lea    0x1(%edx),%ecx
 8dc:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 8df:	8a 12                	mov    (%edx),%dl
 8e1:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8e3:	8b 45 10             	mov    0x10(%ebp),%eax
 8e6:	8d 50 ff             	lea    -0x1(%eax),%edx
 8e9:	89 55 10             	mov    %edx,0x10(%ebp)
 8ec:	85 c0                	test   %eax,%eax
 8ee:	7f dd                	jg     8cd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 8f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8f3:	c9                   	leave  
 8f4:	c3                   	ret    
 8f5:	90                   	nop
 8f6:	90                   	nop
 8f7:	90                   	nop

000008f8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 8f8:	b8 01 00 00 00       	mov    $0x1,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <exit>:
SYSCALL(exit)
 900:	b8 02 00 00 00       	mov    $0x2,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <wait>:
SYSCALL(wait)
 908:	b8 03 00 00 00       	mov    $0x3,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <pipe>:
SYSCALL(pipe)
 910:	b8 04 00 00 00       	mov    $0x4,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <read>:
SYSCALL(read)
 918:	b8 05 00 00 00       	mov    $0x5,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <write>:
SYSCALL(write)
 920:	b8 10 00 00 00       	mov    $0x10,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <close>:
SYSCALL(close)
 928:	b8 15 00 00 00       	mov    $0x15,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <kill>:
SYSCALL(kill)
 930:	b8 06 00 00 00       	mov    $0x6,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <exec>:
SYSCALL(exec)
 938:	b8 07 00 00 00       	mov    $0x7,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <open>:
SYSCALL(open)
 940:	b8 0f 00 00 00       	mov    $0xf,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <mknod>:
SYSCALL(mknod)
 948:	b8 11 00 00 00       	mov    $0x11,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <unlink>:
SYSCALL(unlink)
 950:	b8 12 00 00 00       	mov    $0x12,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <fstat>:
SYSCALL(fstat)
 958:	b8 08 00 00 00       	mov    $0x8,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <link>:
SYSCALL(link)
 960:	b8 13 00 00 00       	mov    $0x13,%eax
 965:	cd 40                	int    $0x40
 967:	c3                   	ret    

00000968 <mkdir>:
SYSCALL(mkdir)
 968:	b8 14 00 00 00       	mov    $0x14,%eax
 96d:	cd 40                	int    $0x40
 96f:	c3                   	ret    

00000970 <chdir>:
SYSCALL(chdir)
 970:	b8 09 00 00 00       	mov    $0x9,%eax
 975:	cd 40                	int    $0x40
 977:	c3                   	ret    

00000978 <dup>:
SYSCALL(dup)
 978:	b8 0a 00 00 00       	mov    $0xa,%eax
 97d:	cd 40                	int    $0x40
 97f:	c3                   	ret    

00000980 <getpid>:
SYSCALL(getpid)
 980:	b8 0b 00 00 00       	mov    $0xb,%eax
 985:	cd 40                	int    $0x40
 987:	c3                   	ret    

00000988 <sbrk>:
SYSCALL(sbrk)
 988:	b8 0c 00 00 00       	mov    $0xc,%eax
 98d:	cd 40                	int    $0x40
 98f:	c3                   	ret    

00000990 <sleep>:
SYSCALL(sleep)
 990:	b8 0d 00 00 00       	mov    $0xd,%eax
 995:	cd 40                	int    $0x40
 997:	c3                   	ret    

00000998 <uptime>:
SYSCALL(uptime)
 998:	b8 0e 00 00 00       	mov    $0xe,%eax
 99d:	cd 40                	int    $0x40
 99f:	c3                   	ret    

000009a0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 9a0:	55                   	push   %ebp
 9a1:	89 e5                	mov    %esp,%ebp
 9a3:	83 ec 18             	sub    $0x18,%esp
 9a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9ac:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9b3:	00 
 9b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9bb:	8b 45 08             	mov    0x8(%ebp),%eax
 9be:	89 04 24             	mov    %eax,(%esp)
 9c1:	e8 5a ff ff ff       	call   920 <write>
}
 9c6:	c9                   	leave  
 9c7:	c3                   	ret    

000009c8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9c8:	55                   	push   %ebp
 9c9:	89 e5                	mov    %esp,%ebp
 9cb:	56                   	push   %esi
 9cc:	53                   	push   %ebx
 9cd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 9d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 9d7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9db:	74 17                	je     9f4 <printint+0x2c>
 9dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9e1:	79 11                	jns    9f4 <printint+0x2c>
    neg = 1;
 9e3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 9ed:	f7 d8                	neg    %eax
 9ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9f2:	eb 06                	jmp    9fa <printint+0x32>
  } else {
    x = xx;
 9f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 9f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a01:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a04:	8d 41 01             	lea    0x1(%ecx),%eax
 a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a0a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a10:	ba 00 00 00 00       	mov    $0x0,%edx
 a15:	f7 f3                	div    %ebx
 a17:	89 d0                	mov    %edx,%eax
 a19:	8a 80 cc 12 00 00    	mov    0x12cc(%eax),%al
 a1f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a23:	8b 75 10             	mov    0x10(%ebp),%esi
 a26:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a29:	ba 00 00 00 00       	mov    $0x0,%edx
 a2e:	f7 f6                	div    %esi
 a30:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a37:	75 c8                	jne    a01 <printint+0x39>
  if(neg)
 a39:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a3d:	74 10                	je     a4f <printint+0x87>
    buf[i++] = '-';
 a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a42:	8d 50 01             	lea    0x1(%eax),%edx
 a45:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a48:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a4d:	eb 1e                	jmp    a6d <printint+0xa5>
 a4f:	eb 1c                	jmp    a6d <printint+0xa5>
    putc(fd, buf[i]);
 a51:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a57:	01 d0                	add    %edx,%eax
 a59:	8a 00                	mov    (%eax),%al
 a5b:	0f be c0             	movsbl %al,%eax
 a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a62:	8b 45 08             	mov    0x8(%ebp),%eax
 a65:	89 04 24             	mov    %eax,(%esp)
 a68:	e8 33 ff ff ff       	call   9a0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a6d:	ff 4d f4             	decl   -0xc(%ebp)
 a70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a74:	79 db                	jns    a51 <printint+0x89>
    putc(fd, buf[i]);
}
 a76:	83 c4 30             	add    $0x30,%esp
 a79:	5b                   	pop    %ebx
 a7a:	5e                   	pop    %esi
 a7b:	5d                   	pop    %ebp
 a7c:	c3                   	ret    

00000a7d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a7d:	55                   	push   %ebp
 a7e:	89 e5                	mov    %esp,%ebp
 a80:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a83:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a8a:	8d 45 0c             	lea    0xc(%ebp),%eax
 a8d:	83 c0 04             	add    $0x4,%eax
 a90:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a9a:	e9 77 01 00 00       	jmp    c16 <printf+0x199>
    c = fmt[i] & 0xff;
 a9f:	8b 55 0c             	mov    0xc(%ebp),%edx
 aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 aa5:	01 d0                	add    %edx,%eax
 aa7:	8a 00                	mov    (%eax),%al
 aa9:	0f be c0             	movsbl %al,%eax
 aac:	25 ff 00 00 00       	and    $0xff,%eax
 ab1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 ab4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ab8:	75 2c                	jne    ae6 <printf+0x69>
      if(c == '%'){
 aba:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 abe:	75 0c                	jne    acc <printf+0x4f>
        state = '%';
 ac0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 ac7:	e9 47 01 00 00       	jmp    c13 <printf+0x196>
      } else {
        putc(fd, c);
 acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 acf:	0f be c0             	movsbl %al,%eax
 ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
 ad6:	8b 45 08             	mov    0x8(%ebp),%eax
 ad9:	89 04 24             	mov    %eax,(%esp)
 adc:	e8 bf fe ff ff       	call   9a0 <putc>
 ae1:	e9 2d 01 00 00       	jmp    c13 <printf+0x196>
      }
    } else if(state == '%'){
 ae6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 aea:	0f 85 23 01 00 00    	jne    c13 <printf+0x196>
      if(c == 'd'){
 af0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 af4:	75 2d                	jne    b23 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 af9:	8b 00                	mov    (%eax),%eax
 afb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 b02:	00 
 b03:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 b0a:	00 
 b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b0f:	8b 45 08             	mov    0x8(%ebp),%eax
 b12:	89 04 24             	mov    %eax,(%esp)
 b15:	e8 ae fe ff ff       	call   9c8 <printint>
        ap++;
 b1a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b1e:	e9 e9 00 00 00       	jmp    c0c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 b23:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b27:	74 06                	je     b2f <printf+0xb2>
 b29:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b2d:	75 2d                	jne    b5c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 b2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b32:	8b 00                	mov    (%eax),%eax
 b34:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 b3b:	00 
 b3c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b43:	00 
 b44:	89 44 24 04          	mov    %eax,0x4(%esp)
 b48:	8b 45 08             	mov    0x8(%ebp),%eax
 b4b:	89 04 24             	mov    %eax,(%esp)
 b4e:	e8 75 fe ff ff       	call   9c8 <printint>
        ap++;
 b53:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b57:	e9 b0 00 00 00       	jmp    c0c <printf+0x18f>
      } else if(c == 's'){
 b5c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b60:	75 42                	jne    ba4 <printf+0x127>
        s = (char*)*ap;
 b62:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b65:	8b 00                	mov    (%eax),%eax
 b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b6a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b72:	75 09                	jne    b7d <printf+0x100>
          s = "(null)";
 b74:	c7 45 f4 c3 0e 00 00 	movl   $0xec3,-0xc(%ebp)
        while(*s != 0){
 b7b:	eb 1c                	jmp    b99 <printf+0x11c>
 b7d:	eb 1a                	jmp    b99 <printf+0x11c>
          putc(fd, *s);
 b7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b82:	8a 00                	mov    (%eax),%al
 b84:	0f be c0             	movsbl %al,%eax
 b87:	89 44 24 04          	mov    %eax,0x4(%esp)
 b8b:	8b 45 08             	mov    0x8(%ebp),%eax
 b8e:	89 04 24             	mov    %eax,(%esp)
 b91:	e8 0a fe ff ff       	call   9a0 <putc>
          s++;
 b96:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9c:	8a 00                	mov    (%eax),%al
 b9e:	84 c0                	test   %al,%al
 ba0:	75 dd                	jne    b7f <printf+0x102>
 ba2:	eb 68                	jmp    c0c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ba4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ba8:	75 1d                	jne    bc7 <printf+0x14a>
        putc(fd, *ap);
 baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bad:	8b 00                	mov    (%eax),%eax
 baf:	0f be c0             	movsbl %al,%eax
 bb2:	89 44 24 04          	mov    %eax,0x4(%esp)
 bb6:	8b 45 08             	mov    0x8(%ebp),%eax
 bb9:	89 04 24             	mov    %eax,(%esp)
 bbc:	e8 df fd ff ff       	call   9a0 <putc>
        ap++;
 bc1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bc5:	eb 45                	jmp    c0c <printf+0x18f>
      } else if(c == '%'){
 bc7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bcb:	75 17                	jne    be4 <printf+0x167>
        putc(fd, c);
 bcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bd0:	0f be c0             	movsbl %al,%eax
 bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
 bd7:	8b 45 08             	mov    0x8(%ebp),%eax
 bda:	89 04 24             	mov    %eax,(%esp)
 bdd:	e8 be fd ff ff       	call   9a0 <putc>
 be2:	eb 28                	jmp    c0c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 be4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 beb:	00 
 bec:	8b 45 08             	mov    0x8(%ebp),%eax
 bef:	89 04 24             	mov    %eax,(%esp)
 bf2:	e8 a9 fd ff ff       	call   9a0 <putc>
        putc(fd, c);
 bf7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bfa:	0f be c0             	movsbl %al,%eax
 bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
 c01:	8b 45 08             	mov    0x8(%ebp),%eax
 c04:	89 04 24             	mov    %eax,(%esp)
 c07:	e8 94 fd ff ff       	call   9a0 <putc>
      }
      state = 0;
 c0c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c13:	ff 45 f0             	incl   -0x10(%ebp)
 c16:	8b 55 0c             	mov    0xc(%ebp),%edx
 c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c1c:	01 d0                	add    %edx,%eax
 c1e:	8a 00                	mov    (%eax),%al
 c20:	84 c0                	test   %al,%al
 c22:	0f 85 77 fe ff ff    	jne    a9f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c28:	c9                   	leave  
 c29:	c3                   	ret    
 c2a:	90                   	nop
 c2b:	90                   	nop

00000c2c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c2c:	55                   	push   %ebp
 c2d:	89 e5                	mov    %esp,%ebp
 c2f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c32:	8b 45 08             	mov    0x8(%ebp),%eax
 c35:	83 e8 08             	sub    $0x8,%eax
 c38:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c3b:	a1 f0 12 00 00       	mov    0x12f0,%eax
 c40:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c43:	eb 24                	jmp    c69 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c48:	8b 00                	mov    (%eax),%eax
 c4a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c4d:	77 12                	ja     c61 <free+0x35>
 c4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c52:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c55:	77 24                	ja     c7b <free+0x4f>
 c57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5a:	8b 00                	mov    (%eax),%eax
 c5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c5f:	77 1a                	ja     c7b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c64:	8b 00                	mov    (%eax),%eax
 c66:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c69:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c6c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c6f:	76 d4                	jbe    c45 <free+0x19>
 c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c74:	8b 00                	mov    (%eax),%eax
 c76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c79:	76 ca                	jbe    c45 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7e:	8b 40 04             	mov    0x4(%eax),%eax
 c81:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c88:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8b:	01 c2                	add    %eax,%edx
 c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c90:	8b 00                	mov    (%eax),%eax
 c92:	39 c2                	cmp    %eax,%edx
 c94:	75 24                	jne    cba <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c96:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c99:	8b 50 04             	mov    0x4(%eax),%edx
 c9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9f:	8b 00                	mov    (%eax),%eax
 ca1:	8b 40 04             	mov    0x4(%eax),%eax
 ca4:	01 c2                	add    %eax,%edx
 ca6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 caf:	8b 00                	mov    (%eax),%eax
 cb1:	8b 10                	mov    (%eax),%edx
 cb3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb6:	89 10                	mov    %edx,(%eax)
 cb8:	eb 0a                	jmp    cc4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 cba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbd:	8b 10                	mov    (%eax),%edx
 cbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 cc4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc7:	8b 40 04             	mov    0x4(%eax),%eax
 cca:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 cd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd4:	01 d0                	add    %edx,%eax
 cd6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cd9:	75 20                	jne    cfb <free+0xcf>
    p->s.size += bp->s.size;
 cdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cde:	8b 50 04             	mov    0x4(%eax),%edx
 ce1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ce4:	8b 40 04             	mov    0x4(%eax),%eax
 ce7:	01 c2                	add    %eax,%edx
 ce9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cec:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf2:	8b 10                	mov    (%eax),%edx
 cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cf7:	89 10                	mov    %edx,(%eax)
 cf9:	eb 08                	jmp    d03 <free+0xd7>
  } else
    p->s.ptr = bp;
 cfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfe:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d01:	89 10                	mov    %edx,(%eax)
  freep = p;
 d03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d06:	a3 f0 12 00 00       	mov    %eax,0x12f0
}
 d0b:	c9                   	leave  
 d0c:	c3                   	ret    

00000d0d <morecore>:

static Header*
morecore(uint nu)
{
 d0d:	55                   	push   %ebp
 d0e:	89 e5                	mov    %esp,%ebp
 d10:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d13:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d1a:	77 07                	ja     d23 <morecore+0x16>
    nu = 4096;
 d1c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d23:	8b 45 08             	mov    0x8(%ebp),%eax
 d26:	c1 e0 03             	shl    $0x3,%eax
 d29:	89 04 24             	mov    %eax,(%esp)
 d2c:	e8 57 fc ff ff       	call   988 <sbrk>
 d31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d34:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d38:	75 07                	jne    d41 <morecore+0x34>
    return 0;
 d3a:	b8 00 00 00 00       	mov    $0x0,%eax
 d3f:	eb 22                	jmp    d63 <morecore+0x56>
  hp = (Header*)p;
 d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d44:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d47:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d4a:	8b 55 08             	mov    0x8(%ebp),%edx
 d4d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d53:	83 c0 08             	add    $0x8,%eax
 d56:	89 04 24             	mov    %eax,(%esp)
 d59:	e8 ce fe ff ff       	call   c2c <free>
  return freep;
 d5e:	a1 f0 12 00 00       	mov    0x12f0,%eax
}
 d63:	c9                   	leave  
 d64:	c3                   	ret    

00000d65 <malloc>:

void*
malloc(uint nbytes)
{
 d65:	55                   	push   %ebp
 d66:	89 e5                	mov    %esp,%ebp
 d68:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d6b:	8b 45 08             	mov    0x8(%ebp),%eax
 d6e:	83 c0 07             	add    $0x7,%eax
 d71:	c1 e8 03             	shr    $0x3,%eax
 d74:	40                   	inc    %eax
 d75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d78:	a1 f0 12 00 00       	mov    0x12f0,%eax
 d7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d84:	75 23                	jne    da9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d86:	c7 45 f0 e8 12 00 00 	movl   $0x12e8,-0x10(%ebp)
 d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d90:	a3 f0 12 00 00       	mov    %eax,0x12f0
 d95:	a1 f0 12 00 00       	mov    0x12f0,%eax
 d9a:	a3 e8 12 00 00       	mov    %eax,0x12e8
    base.s.size = 0;
 d9f:	c7 05 ec 12 00 00 00 	movl   $0x0,0x12ec
 da6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dac:	8b 00                	mov    (%eax),%eax
 dae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db4:	8b 40 04             	mov    0x4(%eax),%eax
 db7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dba:	72 4d                	jb     e09 <malloc+0xa4>
      if(p->s.size == nunits)
 dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbf:	8b 40 04             	mov    0x4(%eax),%eax
 dc2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dc5:	75 0c                	jne    dd3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dca:	8b 10                	mov    (%eax),%edx
 dcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dcf:	89 10                	mov    %edx,(%eax)
 dd1:	eb 26                	jmp    df9 <malloc+0x94>
      else {
        p->s.size -= nunits;
 dd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd6:	8b 40 04             	mov    0x4(%eax),%eax
 dd9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ddc:	89 c2                	mov    %eax,%edx
 dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de7:	8b 40 04             	mov    0x4(%eax),%eax
 dea:	c1 e0 03             	shl    $0x3,%eax
 ded:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 df6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 df9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dfc:	a3 f0 12 00 00       	mov    %eax,0x12f0
      return (void*)(p + 1);
 e01:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e04:	83 c0 08             	add    $0x8,%eax
 e07:	eb 38                	jmp    e41 <malloc+0xdc>
    }
    if(p == freep)
 e09:	a1 f0 12 00 00       	mov    0x12f0,%eax
 e0e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e11:	75 1b                	jne    e2e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 e13:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e16:	89 04 24             	mov    %eax,(%esp)
 e19:	e8 ef fe ff ff       	call   d0d <morecore>
 e1e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e25:	75 07                	jne    e2e <malloc+0xc9>
        return 0;
 e27:	b8 00 00 00 00       	mov    $0x0,%eax
 e2c:	eb 13                	jmp    e41 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e31:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e37:	8b 00                	mov    (%eax),%eax
 e39:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e3c:	e9 70 ff ff ff       	jmp    db1 <malloc+0x4c>
}
 e41:	c9                   	leave  
 e42:	c3                   	ret    
