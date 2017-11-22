
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 62                	jmp    84 <wc+0x84>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 51                	jmp    7c <wc+0x7c>
      c++;
  2b:	ff 45 e8             	incl   -0x18(%ebp)
      if(buf[i] == '\n')
  2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  31:	05 80 13 00 00       	add    $0x1380,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 80 13 00 00       	add    $0x1380,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  50:	c7 04 24 db 0e 00 00 	movl   $0xedb,(%esp)
  57:	e8 ae 03 00 00       	call   40a <strchr>
  5c:	85 c0                	test   %eax,%eax
  5e:	74 09                	je     69 <wc+0x69>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  67:	eb 10                	jmp    79 <wc+0x79>
      else if(!inword){
  69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  6d:	75 0a                	jne    79 <wc+0x79>
        w++;
  6f:	ff 45 ec             	incl   -0x14(%ebp)
        inword = 1;
  72:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
    for(i=0; i<n; i++){
  79:	ff 45 f4             	incl   -0xc(%ebp)
  7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  7f:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  82:	7c a7                	jl     2b <wc+0x2b>
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  while((n = read(fd, buf, sizeof(buf))) > 0){
  84:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8b:	00 
  8c:	c7 44 24 04 80 13 00 	movl   $0x1380,0x4(%esp)
  93:	00 
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 11 09 00 00       	call   9b0 <read>
  9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  a6:	0f 8f 76 ff ff ff    	jg     22 <wc+0x22>
        w++;
        inword = 1;
      }
    }
  }
  if(n < 0){
  ac:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b0:	79 19                	jns    cb <wc+0xcb>
    printf(1, "wc: read error\n");
  b2:	c7 44 24 04 e1 0e 00 	movl   $0xee1,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 4f 0a 00 00       	call   b15 <printf>
    exit();
  c6:	e8 cd 08 00 00       	call   998 <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ce:	89 44 24 14          	mov    %eax,0x14(%esp)
  d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  e7:	c7 44 24 04 f1 0e 00 	movl   $0xef1,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 1a 0a 00 00       	call   b15 <printf>
}
  fb:	c9                   	leave  
  fc:	c3                   	ret    

000000fd <main>:

int
main(int argc, char *argv[])
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 e4 f0             	and    $0xfffffff0,%esp
 103:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 106:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 10a:	7f 19                	jg     125 <main+0x28>
    wc(0, "");
 10c:	c7 44 24 04 fe 0e 00 	movl   $0xefe,0x4(%esp)
 113:	00 
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    exit();
 120:	e8 73 08 00 00       	call   998 <exit>
  }

  for(i = 1; i < argc; i++){
 125:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 12c:	00 
 12d:	e9 8e 00 00 00       	jmp    1c0 <main+0xc3>
    if((fd = open(argv[i], 0)) < 0){
 132:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 136:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	01 d0                	add    %edx,%eax
 142:	8b 00                	mov    (%eax),%eax
 144:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14b:	00 
 14c:	89 04 24             	mov    %eax,(%esp)
 14f:	e8 84 08 00 00       	call   9d8 <open>
 154:	89 44 24 18          	mov    %eax,0x18(%esp)
 158:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 15d:	79 2f                	jns    18e <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 15f:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 163:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	01 d0                	add    %edx,%eax
 16f:	8b 00                	mov    (%eax),%eax
 171:	89 44 24 08          	mov    %eax,0x8(%esp)
 175:	c7 44 24 04 ff 0e 00 	movl   $0xeff,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 8c 09 00 00       	call   b15 <printf>
      exit();
 189:	e8 0a 08 00 00       	call   998 <exit>
    }
    wc(fd, argv[i]);
 18e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 192:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	01 d0                	add    %edx,%eax
 19e:	8b 00                	mov    (%eax),%eax
 1a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a4:	8b 44 24 18          	mov    0x18(%esp),%eax
 1a8:	89 04 24             	mov    %eax,(%esp)
 1ab:	e8 50 fe ff ff       	call   0 <wc>
    close(fd);
 1b0:	8b 44 24 18          	mov    0x18(%esp),%eax
 1b4:	89 04 24             	mov    %eax,(%esp)
 1b7:	e8 04 08 00 00       	call   9c0 <close>
  if(argc <= 1){
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
 1bc:	ff 44 24 1c          	incl   0x1c(%esp)
 1c0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1c4:	3b 45 08             	cmp    0x8(%ebp),%eax
 1c7:	0f 8c 65 ff ff ff    	jl     132 <main+0x35>
      exit();
    }
    wc(fd, argv[i]);
    close(fd);
  }
  exit();
 1cd:	e8 c6 07 00 00       	call   998 <exit>
 1d2:	90                   	nop
 1d3:	90                   	nop

000001d4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1dc:	8b 55 10             	mov    0x10(%ebp),%edx
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	89 cb                	mov    %ecx,%ebx
 1e4:	89 df                	mov    %ebx,%edi
 1e6:	89 d1                	mov    %edx,%ecx
 1e8:	fc                   	cld    
 1e9:	f3 aa                	rep stos %al,%es:(%edi)
 1eb:	89 ca                	mov    %ecx,%edx
 1ed:	89 fb                	mov    %edi,%ebx
 1ef:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1f5:	5b                   	pop    %ebx
 1f6:	5f                   	pop    %edi
 1f7:	5d                   	pop    %ebp
 1f8:	c3                   	ret    

000001f9 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 205:	90                   	nop
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	8d 50 01             	lea    0x1(%eax),%edx
 20c:	89 55 08             	mov    %edx,0x8(%ebp)
 20f:	8b 55 0c             	mov    0xc(%ebp),%edx
 212:	8d 4a 01             	lea    0x1(%edx),%ecx
 215:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 218:	8a 12                	mov    (%edx),%dl
 21a:	88 10                	mov    %dl,(%eax)
 21c:	8a 00                	mov    (%eax),%al
 21e:	84 c0                	test   %al,%al
 220:	75 e4                	jne    206 <strcpy+0xd>
    ;
  return os;
 222:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 225:	c9                   	leave  
 226:	c3                   	ret    

00000227 <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
 22d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 234:	00 
 235:	8b 45 08             	mov    0x8(%ebp),%eax
 238:	89 04 24             	mov    %eax,(%esp)
 23b:	e8 98 07 00 00       	call   9d8 <open>
 240:	89 45 f0             	mov    %eax,-0x10(%ebp)
 243:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 247:	79 20                	jns    269 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	89 44 24 08          	mov    %eax,0x8(%esp)
 250:	c7 44 24 04 13 0f 00 	movl   $0xf13,0x4(%esp)
 257:	00 
 258:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 25f:	e8 b1 08 00 00       	call   b15 <printf>
        exit();
 264:	e8 2f 07 00 00       	call   998 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 269:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 270:	00 
 271:	8b 45 0c             	mov    0xc(%ebp),%eax
 274:	89 04 24             	mov    %eax,(%esp)
 277:	e8 5c 07 00 00       	call   9d8 <open>
 27c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 27f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 283:	79 20                	jns    2a5 <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 285:	8b 45 0c             	mov    0xc(%ebp),%eax
 288:	89 44 24 08          	mov    %eax,0x8(%esp)
 28c:	c7 44 24 04 2e 0f 00 	movl   $0xf2e,0x4(%esp)
 293:	00 
 294:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 29b:	e8 75 08 00 00       	call   b15 <printf>
        exit();
 2a0:	e8 f3 06 00 00       	call   998 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 2a5:	eb 56                	jmp    2fd <copy+0xd6>
        int max = used_disk+=count;
 2a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2aa:	01 45 10             	add    %eax,0x10(%ebp)
 2ad:	8b 45 10             	mov    0x10(%ebp),%eax
 2b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 2b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2b6:	89 44 24 08          	mov    %eax,0x8(%esp)
 2ba:	c7 44 24 04 4a 0f 00 	movl   $0xf4a,0x4(%esp)
 2c1:	00 
 2c2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c9:	e8 47 08 00 00       	call   b15 <printf>
        if(max > max_disk){
 2ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2d1:	3b 45 14             	cmp    0x14(%ebp),%eax
 2d4:	7e 07                	jle    2dd <copy+0xb6>
          return -1;
 2d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2db:	eb 5c                	jmp    339 <copy+0x112>
        }
        bytes = bytes + count;
 2dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2e0:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 2e3:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 2ea:	00 
 2eb:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 2ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2f5:	89 04 24             	mov    %eax,(%esp)
 2f8:	e8 bb 06 00 00       	call   9b8 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 2fd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 304:	00 
 305:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 308:	89 44 24 04          	mov    %eax,0x4(%esp)
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 30f:	89 04 24             	mov    %eax,(%esp)
 312:	e8 99 06 00 00       	call   9b0 <read>
 317:	89 45 e8             	mov    %eax,-0x18(%ebp)
 31a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 31e:	7f 87                	jg     2a7 <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 320:	8b 45 f0             	mov    -0x10(%ebp),%eax
 323:	89 04 24             	mov    %eax,(%esp)
 326:	e8 95 06 00 00       	call   9c0 <close>
    close(fd2);
 32b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 32e:	89 04 24             	mov    %eax,(%esp)
 331:	e8 8a 06 00 00       	call   9c0 <close>
    return(bytes);
 336:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 33e:	eb 06                	jmp    346 <strcmp+0xb>
    p++, q++;
 340:	ff 45 08             	incl   0x8(%ebp)
 343:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 346:	8b 45 08             	mov    0x8(%ebp),%eax
 349:	8a 00                	mov    (%eax),%al
 34b:	84 c0                	test   %al,%al
 34d:	74 0e                	je     35d <strcmp+0x22>
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	8a 10                	mov    (%eax),%dl
 354:	8b 45 0c             	mov    0xc(%ebp),%eax
 357:	8a 00                	mov    (%eax),%al
 359:	38 c2                	cmp    %al,%dl
 35b:	74 e3                	je     340 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
 360:	8a 00                	mov    (%eax),%al
 362:	0f b6 d0             	movzbl %al,%edx
 365:	8b 45 0c             	mov    0xc(%ebp),%eax
 368:	8a 00                	mov    (%eax),%al
 36a:	0f b6 c0             	movzbl %al,%eax
 36d:	29 c2                	sub    %eax,%edx
 36f:	89 d0                	mov    %edx,%eax
}
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    

00000373 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 376:	eb 09                	jmp    381 <strncmp+0xe>
    n--, p++, q++;
 378:	ff 4d 10             	decl   0x10(%ebp)
 37b:	ff 45 08             	incl   0x8(%ebp)
 37e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 381:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 385:	74 17                	je     39e <strncmp+0x2b>
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	8a 00                	mov    (%eax),%al
 38c:	84 c0                	test   %al,%al
 38e:	74 0e                	je     39e <strncmp+0x2b>
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	8a 10                	mov    (%eax),%dl
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	8a 00                	mov    (%eax),%al
 39a:	38 c2                	cmp    %al,%dl
 39c:	74 da                	je     378 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 39e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3a2:	75 07                	jne    3ab <strncmp+0x38>
    return 0;
 3a4:	b8 00 00 00 00       	mov    $0x0,%eax
 3a9:	eb 14                	jmp    3bf <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 3ab:	8b 45 08             	mov    0x8(%ebp),%eax
 3ae:	8a 00                	mov    (%eax),%al
 3b0:	0f b6 d0             	movzbl %al,%edx
 3b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b6:	8a 00                	mov    (%eax),%al
 3b8:	0f b6 c0             	movzbl %al,%eax
 3bb:	29 c2                	sub    %eax,%edx
 3bd:	89 d0                	mov    %edx,%eax
}
 3bf:	5d                   	pop    %ebp
 3c0:	c3                   	ret    

000003c1 <strlen>:

uint
strlen(const char *s)
{
 3c1:	55                   	push   %ebp
 3c2:	89 e5                	mov    %esp,%ebp
 3c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ce:	eb 03                	jmp    3d3 <strlen+0x12>
 3d0:	ff 45 fc             	incl   -0x4(%ebp)
 3d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	01 d0                	add    %edx,%eax
 3db:	8a 00                	mov    (%eax),%al
 3dd:	84 c0                	test   %al,%al
 3df:	75 ef                	jne    3d0 <strlen+0xf>
    ;
  return n;
 3e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3e4:	c9                   	leave  
 3e5:	c3                   	ret    

000003e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3ec:	8b 45 10             	mov    0x10(%ebp),%eax
 3ef:	89 44 24 08          	mov    %eax,0x8(%esp)
 3f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fa:	8b 45 08             	mov    0x8(%ebp),%eax
 3fd:	89 04 24             	mov    %eax,(%esp)
 400:	e8 cf fd ff ff       	call   1d4 <stosb>
  return dst;
 405:	8b 45 08             	mov    0x8(%ebp),%eax
}
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <strchr>:

char*
strchr(const char *s, char c)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	83 ec 04             	sub    $0x4,%esp
 410:	8b 45 0c             	mov    0xc(%ebp),%eax
 413:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 416:	eb 12                	jmp    42a <strchr+0x20>
    if(*s == c)
 418:	8b 45 08             	mov    0x8(%ebp),%eax
 41b:	8a 00                	mov    (%eax),%al
 41d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 420:	75 05                	jne    427 <strchr+0x1d>
      return (char*)s;
 422:	8b 45 08             	mov    0x8(%ebp),%eax
 425:	eb 11                	jmp    438 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 427:	ff 45 08             	incl   0x8(%ebp)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	8a 00                	mov    (%eax),%al
 42f:	84 c0                	test   %al,%al
 431:	75 e5                	jne    418 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 433:	b8 00 00 00 00       	mov    $0x0,%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <strcat>:

char *
strcat(char *dest, const char *src)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 440:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 447:	eb 03                	jmp    44c <strcat+0x12>
 449:	ff 45 fc             	incl   -0x4(%ebp)
 44c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	8a 00                	mov    (%eax),%al
 456:	84 c0                	test   %al,%al
 458:	75 ef                	jne    449 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 45a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 461:	eb 1e                	jmp    481 <strcat+0x47>
        dest[i+j] = src[j];
 463:	8b 45 f8             	mov    -0x8(%ebp),%eax
 466:	8b 55 fc             	mov    -0x4(%ebp),%edx
 469:	01 d0                	add    %edx,%eax
 46b:	89 c2                	mov    %eax,%edx
 46d:	8b 45 08             	mov    0x8(%ebp),%eax
 470:	01 c2                	add    %eax,%edx
 472:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 475:	8b 45 0c             	mov    0xc(%ebp),%eax
 478:	01 c8                	add    %ecx,%eax
 47a:	8a 00                	mov    (%eax),%al
 47c:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 47e:	ff 45 f8             	incl   -0x8(%ebp)
 481:	8b 55 f8             	mov    -0x8(%ebp),%edx
 484:	8b 45 0c             	mov    0xc(%ebp),%eax
 487:	01 d0                	add    %edx,%eax
 489:	8a 00                	mov    (%eax),%al
 48b:	84 c0                	test   %al,%al
 48d:	75 d4                	jne    463 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 48f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 492:	8b 55 fc             	mov    -0x4(%ebp),%edx
 495:	01 d0                	add    %edx,%eax
 497:	89 c2                	mov    %eax,%edx
 499:	8b 45 08             	mov    0x8(%ebp),%eax
 49c:	01 d0                	add    %edx,%eax
 49e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4a4:	c9                   	leave  
 4a5:	c3                   	ret    

000004a6 <strstr>:

int 
strstr(char* s, char* sub)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 4ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4b3:	eb 7c                	jmp    531 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 4b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	01 d0                	add    %edx,%eax
 4bd:	8a 10                	mov    (%eax),%dl
 4bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c2:	8a 00                	mov    (%eax),%al
 4c4:	38 c2                	cmp    %al,%dl
 4c6:	75 66                	jne    52e <strstr+0x88>
        {
            if(strlen(sub) == 1)
 4c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cb:	89 04 24             	mov    %eax,(%esp)
 4ce:	e8 ee fe ff ff       	call   3c1 <strlen>
 4d3:	83 f8 01             	cmp    $0x1,%eax
 4d6:	75 05                	jne    4dd <strstr+0x37>
            {  
                return i;
 4d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4db:	eb 6b                	jmp    548 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 4dd:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 4e4:	eb 3a                	jmp    520 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 4e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ec:	01 d0                	add    %edx,%eax
 4ee:	89 c2                	mov    %eax,%edx
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	01 d0                	add    %edx,%eax
 4f5:	8a 10                	mov    (%eax),%dl
 4f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fd:	01 c8                	add    %ecx,%eax
 4ff:	8a 00                	mov    (%eax),%al
 501:	38 c2                	cmp    %al,%dl
 503:	75 16                	jne    51b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 505:	8b 45 f8             	mov    -0x8(%ebp),%eax
 508:	8d 50 01             	lea    0x1(%eax),%edx
 50b:	8b 45 0c             	mov    0xc(%ebp),%eax
 50e:	01 d0                	add    %edx,%eax
 510:	8a 00                	mov    (%eax),%al
 512:	84 c0                	test   %al,%al
 514:	75 07                	jne    51d <strstr+0x77>
                    {
                        return i;
 516:	8b 45 fc             	mov    -0x4(%ebp),%eax
 519:	eb 2d                	jmp    548 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 51b:	eb 11                	jmp    52e <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 51d:	ff 45 f8             	incl   -0x8(%ebp)
 520:	8b 55 f8             	mov    -0x8(%ebp),%edx
 523:	8b 45 0c             	mov    0xc(%ebp),%eax
 526:	01 d0                	add    %edx,%eax
 528:	8a 00                	mov    (%eax),%al
 52a:	84 c0                	test   %al,%al
 52c:	75 b8                	jne    4e6 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 52e:	ff 45 fc             	incl   -0x4(%ebp)
 531:	8b 55 fc             	mov    -0x4(%ebp),%edx
 534:	8b 45 08             	mov    0x8(%ebp),%eax
 537:	01 d0                	add    %edx,%eax
 539:	8a 00                	mov    (%eax),%al
 53b:	84 c0                	test   %al,%al
 53d:	0f 85 72 ff ff ff    	jne    4b5 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 543:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 548:	c9                   	leave  
 549:	c3                   	ret    

0000054a <strtok>:

char *
strtok(char *s, const char *delim)
{
 54a:	55                   	push   %ebp
 54b:	89 e5                	mov    %esp,%ebp
 54d:	53                   	push   %ebx
 54e:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 551:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 555:	75 08                	jne    55f <strtok+0x15>
  s = lasts;
 557:	a1 64 13 00 00       	mov    0x1364,%eax
 55c:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	8d 50 01             	lea    0x1(%eax),%edx
 565:	89 55 08             	mov    %edx,0x8(%ebp)
 568:	8a 00                	mov    (%eax),%al
 56a:	0f be d8             	movsbl %al,%ebx
 56d:	85 db                	test   %ebx,%ebx
 56f:	75 07                	jne    578 <strtok+0x2e>
      return 0;
 571:	b8 00 00 00 00       	mov    $0x0,%eax
 576:	eb 58                	jmp    5d0 <strtok+0x86>
    } while (strchr(delim, ch));
 578:	88 d8                	mov    %bl,%al
 57a:	0f be c0             	movsbl %al,%eax
 57d:	89 44 24 04          	mov    %eax,0x4(%esp)
 581:	8b 45 0c             	mov    0xc(%ebp),%eax
 584:	89 04 24             	mov    %eax,(%esp)
 587:	e8 7e fe ff ff       	call   40a <strchr>
 58c:	85 c0                	test   %eax,%eax
 58e:	75 cf                	jne    55f <strtok+0x15>
    --s;
 590:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 593:	8b 45 0c             	mov    0xc(%ebp),%eax
 596:	89 44 24 04          	mov    %eax,0x4(%esp)
 59a:	8b 45 08             	mov    0x8(%ebp),%eax
 59d:	89 04 24             	mov    %eax,(%esp)
 5a0:	e8 31 00 00 00       	call   5d6 <strcspn>
 5a5:	89 c2                	mov    %eax,%edx
 5a7:	8b 45 08             	mov    0x8(%ebp),%eax
 5aa:	01 d0                	add    %edx,%eax
 5ac:	a3 64 13 00 00       	mov    %eax,0x1364
    if (*lasts != 0)
 5b1:	a1 64 13 00 00       	mov    0x1364,%eax
 5b6:	8a 00                	mov    (%eax),%al
 5b8:	84 c0                	test   %al,%al
 5ba:	74 11                	je     5cd <strtok+0x83>
  *lasts++ = 0;
 5bc:	a1 64 13 00 00       	mov    0x1364,%eax
 5c1:	8d 50 01             	lea    0x1(%eax),%edx
 5c4:	89 15 64 13 00 00    	mov    %edx,0x1364
 5ca:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 5cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5d0:	83 c4 14             	add    $0x14,%esp
 5d3:	5b                   	pop    %ebx
 5d4:	5d                   	pop    %ebp
 5d5:	c3                   	ret    

000005d6 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 5d6:	55                   	push   %ebp
 5d7:	89 e5                	mov    %esp,%ebp
 5d9:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 5dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 5e3:	eb 26                	jmp    60b <strcspn+0x35>
        if(strchr(s2,*s1))
 5e5:	8b 45 08             	mov    0x8(%ebp),%eax
 5e8:	8a 00                	mov    (%eax),%al
 5ea:	0f be c0             	movsbl %al,%eax
 5ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f4:	89 04 24             	mov    %eax,(%esp)
 5f7:	e8 0e fe ff ff       	call   40a <strchr>
 5fc:	85 c0                	test   %eax,%eax
 5fe:	74 05                	je     605 <strcspn+0x2f>
            return ret;
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
 603:	eb 12                	jmp    617 <strcspn+0x41>
        else
            s1++,ret++;
 605:	ff 45 08             	incl   0x8(%ebp)
 608:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	8a 00                	mov    (%eax),%al
 610:	84 c0                	test   %al,%al
 612:	75 d1                	jne    5e5 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 614:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 617:	c9                   	leave  
 618:	c3                   	ret    

00000619 <isspace>:

int
isspace(unsigned char c)
{
 619:	55                   	push   %ebp
 61a:	89 e5                	mov    %esp,%ebp
 61c:	83 ec 04             	sub    $0x4,%esp
 61f:	8b 45 08             	mov    0x8(%ebp),%eax
 622:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 625:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 629:	74 1e                	je     649 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 62b:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 62f:	74 18                	je     649 <isspace+0x30>
 631:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 635:	74 12                	je     649 <isspace+0x30>
 637:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 63b:	74 0c                	je     649 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 63d:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 641:	74 06                	je     649 <isspace+0x30>
 643:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 647:	75 07                	jne    650 <isspace+0x37>
 649:	b8 01 00 00 00       	mov    $0x1,%eax
 64e:	eb 05                	jmp    655 <isspace+0x3c>
 650:	b8 00 00 00 00       	mov    $0x0,%eax
}
 655:	c9                   	leave  
 656:	c3                   	ret    

00000657 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 657:	55                   	push   %ebp
 658:	89 e5                	mov    %esp,%ebp
 65a:	57                   	push   %edi
 65b:	56                   	push   %esi
 65c:	53                   	push   %ebx
 65d:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 660:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 665:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 66c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 66f:	eb 01                	jmp    672 <strtoul+0x1b>
  p += 1;
 671:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 672:	8a 03                	mov    (%ebx),%al
 674:	0f b6 c0             	movzbl %al,%eax
 677:	89 04 24             	mov    %eax,(%esp)
 67a:	e8 9a ff ff ff       	call   619 <isspace>
 67f:	85 c0                	test   %eax,%eax
 681:	75 ee                	jne    671 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 683:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 687:	75 30                	jne    6b9 <strtoul+0x62>
    {
  if (*p == '0') {
 689:	8a 03                	mov    (%ebx),%al
 68b:	3c 30                	cmp    $0x30,%al
 68d:	75 21                	jne    6b0 <strtoul+0x59>
      p += 1;
 68f:	43                   	inc    %ebx
      if (*p == 'x') {
 690:	8a 03                	mov    (%ebx),%al
 692:	3c 78                	cmp    $0x78,%al
 694:	75 0a                	jne    6a0 <strtoul+0x49>
    p += 1;
 696:	43                   	inc    %ebx
    base = 16;
 697:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 69e:	eb 31                	jmp    6d1 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 6a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 6a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 6ae:	eb 21                	jmp    6d1 <strtoul+0x7a>
      }
  }
  else base = 10;
 6b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 6b7:	eb 18                	jmp    6d1 <strtoul+0x7a>
    } else if (base == 16) {
 6b9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 6bd:	75 12                	jne    6d1 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 6bf:	8a 03                	mov    (%ebx),%al
 6c1:	3c 30                	cmp    $0x30,%al
 6c3:	75 0c                	jne    6d1 <strtoul+0x7a>
 6c5:	8d 43 01             	lea    0x1(%ebx),%eax
 6c8:	8a 00                	mov    (%eax),%al
 6ca:	3c 78                	cmp    $0x78,%al
 6cc:	75 03                	jne    6d1 <strtoul+0x7a>
      p += 2;
 6ce:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 6d1:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 6d5:	75 29                	jne    700 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6d7:	8a 03                	mov    (%ebx),%al
 6d9:	0f be c0             	movsbl %al,%eax
 6dc:	83 e8 30             	sub    $0x30,%eax
 6df:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 6e1:	83 fe 07             	cmp    $0x7,%esi
 6e4:	76 06                	jbe    6ec <strtoul+0x95>
    break;
 6e6:	90                   	nop
 6e7:	e9 b6 00 00 00       	jmp    7a2 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 6ec:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 6f3:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 6fd:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 6fe:	eb d7                	jmp    6d7 <strtoul+0x80>
    } else if (base == 10) {
 700:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 704:	75 2b                	jne    731 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 706:	8a 03                	mov    (%ebx),%al
 708:	0f be c0             	movsbl %al,%eax
 70b:	83 e8 30             	sub    $0x30,%eax
 70e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 710:	83 fe 09             	cmp    $0x9,%esi
 713:	76 06                	jbe    71b <strtoul+0xc4>
    break;
 715:	90                   	nop
 716:	e9 87 00 00 00       	jmp    7a2 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 71b:	89 f8                	mov    %edi,%eax
 71d:	c1 e0 02             	shl    $0x2,%eax
 720:	01 f8                	add    %edi,%eax
 722:	01 c0                	add    %eax,%eax
 724:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 727:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 72e:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 72f:	eb d5                	jmp    706 <strtoul+0xaf>
    } else if (base == 16) {
 731:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 735:	75 35                	jne    76c <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 737:	8a 03                	mov    (%ebx),%al
 739:	0f be c0             	movsbl %al,%eax
 73c:	83 e8 30             	sub    $0x30,%eax
 73f:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 741:	83 fe 4a             	cmp    $0x4a,%esi
 744:	76 02                	jbe    748 <strtoul+0xf1>
    break;
 746:	eb 22                	jmp    76a <strtoul+0x113>
      }
      digit = cvtIn[digit];
 748:	8a 86 00 13 00 00    	mov    0x1300(%esi),%al
 74e:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 751:	83 fe 0f             	cmp    $0xf,%esi
 754:	76 02                	jbe    758 <strtoul+0x101>
    break;
 756:	eb 12                	jmp    76a <strtoul+0x113>
      }
      result = (result << 4) + digit;
 758:	89 f8                	mov    %edi,%eax
 75a:	c1 e0 04             	shl    $0x4,%eax
 75d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 760:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 767:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 768:	eb cd                	jmp    737 <strtoul+0xe0>
 76a:	eb 36                	jmp    7a2 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 76c:	8a 03                	mov    (%ebx),%al
 76e:	0f be c0             	movsbl %al,%eax
 771:	83 e8 30             	sub    $0x30,%eax
 774:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 776:	83 fe 4a             	cmp    $0x4a,%esi
 779:	76 02                	jbe    77d <strtoul+0x126>
    break;
 77b:	eb 25                	jmp    7a2 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 77d:	8a 86 00 13 00 00    	mov    0x1300(%esi),%al
 783:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 786:	8b 45 10             	mov    0x10(%ebp),%eax
 789:	39 f0                	cmp    %esi,%eax
 78b:	77 02                	ja     78f <strtoul+0x138>
    break;
 78d:	eb 13                	jmp    7a2 <strtoul+0x14b>
      }
      result = result*base + digit;
 78f:	8b 45 10             	mov    0x10(%ebp),%eax
 792:	0f af c7             	imul   %edi,%eax
 795:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 798:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 79f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 7a0:	eb ca                	jmp    76c <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 7a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7a6:	75 03                	jne    7ab <strtoul+0x154>
  p = string;
 7a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 7ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7af:	74 05                	je     7b6 <strtoul+0x15f>
  *endPtr = p;
 7b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b4:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 7b6:	89 f8                	mov    %edi,%eax
}
 7b8:	83 c4 14             	add    $0x14,%esp
 7bb:	5b                   	pop    %ebx
 7bc:	5e                   	pop    %esi
 7bd:	5f                   	pop    %edi
 7be:	5d                   	pop    %ebp
 7bf:	c3                   	ret    

000007c0 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 7c0:	55                   	push   %ebp
 7c1:	89 e5                	mov    %esp,%ebp
 7c3:	53                   	push   %ebx
 7c4:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 7c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 7ca:	eb 01                	jmp    7cd <strtol+0xd>
      p += 1;
 7cc:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 7cd:	8a 03                	mov    (%ebx),%al
 7cf:	0f b6 c0             	movzbl %al,%eax
 7d2:	89 04 24             	mov    %eax,(%esp)
 7d5:	e8 3f fe ff ff       	call   619 <isspace>
 7da:	85 c0                	test   %eax,%eax
 7dc:	75 ee                	jne    7cc <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 7de:	8a 03                	mov    (%ebx),%al
 7e0:	3c 2d                	cmp    $0x2d,%al
 7e2:	75 1e                	jne    802 <strtol+0x42>
  p += 1;
 7e4:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 7e5:	8b 45 10             	mov    0x10(%ebp),%eax
 7e8:	89 44 24 08          	mov    %eax,0x8(%esp)
 7ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 7f3:	89 1c 24             	mov    %ebx,(%esp)
 7f6:	e8 5c fe ff ff       	call   657 <strtoul>
 7fb:	f7 d8                	neg    %eax
 7fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
 800:	eb 20                	jmp    822 <strtol+0x62>
    } else {
  if (*p == '+') {
 802:	8a 03                	mov    (%ebx),%al
 804:	3c 2b                	cmp    $0x2b,%al
 806:	75 01                	jne    809 <strtol+0x49>
      p += 1;
 808:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 809:	8b 45 10             	mov    0x10(%ebp),%eax
 80c:	89 44 24 08          	mov    %eax,0x8(%esp)
 810:	8b 45 0c             	mov    0xc(%ebp),%eax
 813:	89 44 24 04          	mov    %eax,0x4(%esp)
 817:	89 1c 24             	mov    %ebx,(%esp)
 81a:	e8 38 fe ff ff       	call   657 <strtoul>
 81f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 822:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 826:	75 17                	jne    83f <strtol+0x7f>
 828:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 82c:	74 11                	je     83f <strtol+0x7f>
 82e:	8b 45 0c             	mov    0xc(%ebp),%eax
 831:	8b 00                	mov    (%eax),%eax
 833:	39 d8                	cmp    %ebx,%eax
 835:	75 08                	jne    83f <strtol+0x7f>
  *endPtr = string;
 837:	8b 45 0c             	mov    0xc(%ebp),%eax
 83a:	8b 55 08             	mov    0x8(%ebp),%edx
 83d:	89 10                	mov    %edx,(%eax)
    }
    return result;
 83f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 842:	83 c4 1c             	add    $0x1c,%esp
 845:	5b                   	pop    %ebx
 846:	5d                   	pop    %ebp
 847:	c3                   	ret    

00000848 <gets>:

char*
gets(char *buf, int max)
{
 848:	55                   	push   %ebp
 849:	89 e5                	mov    %esp,%ebp
 84b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 84e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 855:	eb 49                	jmp    8a0 <gets+0x58>
    cc = read(0, &c, 1);
 857:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 85e:	00 
 85f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 862:	89 44 24 04          	mov    %eax,0x4(%esp)
 866:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 86d:	e8 3e 01 00 00       	call   9b0 <read>
 872:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 875:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 879:	7f 02                	jg     87d <gets+0x35>
      break;
 87b:	eb 2c                	jmp    8a9 <gets+0x61>
    buf[i++] = c;
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8d 50 01             	lea    0x1(%eax),%edx
 883:	89 55 f4             	mov    %edx,-0xc(%ebp)
 886:	89 c2                	mov    %eax,%edx
 888:	8b 45 08             	mov    0x8(%ebp),%eax
 88b:	01 c2                	add    %eax,%edx
 88d:	8a 45 ef             	mov    -0x11(%ebp),%al
 890:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 892:	8a 45 ef             	mov    -0x11(%ebp),%al
 895:	3c 0a                	cmp    $0xa,%al
 897:	74 10                	je     8a9 <gets+0x61>
 899:	8a 45 ef             	mov    -0x11(%ebp),%al
 89c:	3c 0d                	cmp    $0xd,%al
 89e:	74 09                	je     8a9 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	40                   	inc    %eax
 8a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 8a7:	7c ae                	jl     857 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 8a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8ac:	8b 45 08             	mov    0x8(%ebp),%eax
 8af:	01 d0                	add    %edx,%eax
 8b1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8b7:	c9                   	leave  
 8b8:	c3                   	ret    

000008b9 <stat>:

int
stat(char *n, struct stat *st)
{
 8b9:	55                   	push   %ebp
 8ba:	89 e5                	mov    %esp,%ebp
 8bc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 8bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8c6:	00 
 8c7:	8b 45 08             	mov    0x8(%ebp),%eax
 8ca:	89 04 24             	mov    %eax,(%esp)
 8cd:	e8 06 01 00 00       	call   9d8 <open>
 8d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 8d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d9:	79 07                	jns    8e2 <stat+0x29>
    return -1;
 8db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8e0:	eb 23                	jmp    905 <stat+0x4c>
  r = fstat(fd, st);
 8e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	89 04 24             	mov    %eax,(%esp)
 8ef:	e8 fc 00 00 00       	call   9f0 <fstat>
 8f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 8f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fa:	89 04 24             	mov    %eax,(%esp)
 8fd:	e8 be 00 00 00       	call   9c0 <close>
  return r;
 902:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 905:	c9                   	leave  
 906:	c3                   	ret    

00000907 <atoi>:

int
atoi(const char *s)
{
 907:	55                   	push   %ebp
 908:	89 e5                	mov    %esp,%ebp
 90a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 90d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 914:	eb 24                	jmp    93a <atoi+0x33>
    n = n*10 + *s++ - '0';
 916:	8b 55 fc             	mov    -0x4(%ebp),%edx
 919:	89 d0                	mov    %edx,%eax
 91b:	c1 e0 02             	shl    $0x2,%eax
 91e:	01 d0                	add    %edx,%eax
 920:	01 c0                	add    %eax,%eax
 922:	89 c1                	mov    %eax,%ecx
 924:	8b 45 08             	mov    0x8(%ebp),%eax
 927:	8d 50 01             	lea    0x1(%eax),%edx
 92a:	89 55 08             	mov    %edx,0x8(%ebp)
 92d:	8a 00                	mov    (%eax),%al
 92f:	0f be c0             	movsbl %al,%eax
 932:	01 c8                	add    %ecx,%eax
 934:	83 e8 30             	sub    $0x30,%eax
 937:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 93a:	8b 45 08             	mov    0x8(%ebp),%eax
 93d:	8a 00                	mov    (%eax),%al
 93f:	3c 2f                	cmp    $0x2f,%al
 941:	7e 09                	jle    94c <atoi+0x45>
 943:	8b 45 08             	mov    0x8(%ebp),%eax
 946:	8a 00                	mov    (%eax),%al
 948:	3c 39                	cmp    $0x39,%al
 94a:	7e ca                	jle    916 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 94c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 94f:	c9                   	leave  
 950:	c3                   	ret    

00000951 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 951:	55                   	push   %ebp
 952:	89 e5                	mov    %esp,%ebp
 954:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 957:	8b 45 08             	mov    0x8(%ebp),%eax
 95a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 95d:	8b 45 0c             	mov    0xc(%ebp),%eax
 960:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 963:	eb 16                	jmp    97b <memmove+0x2a>
    *dst++ = *src++;
 965:	8b 45 fc             	mov    -0x4(%ebp),%eax
 968:	8d 50 01             	lea    0x1(%eax),%edx
 96b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 96e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 971:	8d 4a 01             	lea    0x1(%edx),%ecx
 974:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 977:	8a 12                	mov    (%edx),%dl
 979:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 97b:	8b 45 10             	mov    0x10(%ebp),%eax
 97e:	8d 50 ff             	lea    -0x1(%eax),%edx
 981:	89 55 10             	mov    %edx,0x10(%ebp)
 984:	85 c0                	test   %eax,%eax
 986:	7f dd                	jg     965 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 988:	8b 45 08             	mov    0x8(%ebp),%eax
}
 98b:	c9                   	leave  
 98c:	c3                   	ret    
 98d:	90                   	nop
 98e:	90                   	nop
 98f:	90                   	nop

00000990 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 990:	b8 01 00 00 00       	mov    $0x1,%eax
 995:	cd 40                	int    $0x40
 997:	c3                   	ret    

00000998 <exit>:
SYSCALL(exit)
 998:	b8 02 00 00 00       	mov    $0x2,%eax
 99d:	cd 40                	int    $0x40
 99f:	c3                   	ret    

000009a0 <wait>:
SYSCALL(wait)
 9a0:	b8 03 00 00 00       	mov    $0x3,%eax
 9a5:	cd 40                	int    $0x40
 9a7:	c3                   	ret    

000009a8 <pipe>:
SYSCALL(pipe)
 9a8:	b8 04 00 00 00       	mov    $0x4,%eax
 9ad:	cd 40                	int    $0x40
 9af:	c3                   	ret    

000009b0 <read>:
SYSCALL(read)
 9b0:	b8 05 00 00 00       	mov    $0x5,%eax
 9b5:	cd 40                	int    $0x40
 9b7:	c3                   	ret    

000009b8 <write>:
SYSCALL(write)
 9b8:	b8 10 00 00 00       	mov    $0x10,%eax
 9bd:	cd 40                	int    $0x40
 9bf:	c3                   	ret    

000009c0 <close>:
SYSCALL(close)
 9c0:	b8 15 00 00 00       	mov    $0x15,%eax
 9c5:	cd 40                	int    $0x40
 9c7:	c3                   	ret    

000009c8 <kill>:
SYSCALL(kill)
 9c8:	b8 06 00 00 00       	mov    $0x6,%eax
 9cd:	cd 40                	int    $0x40
 9cf:	c3                   	ret    

000009d0 <exec>:
SYSCALL(exec)
 9d0:	b8 07 00 00 00       	mov    $0x7,%eax
 9d5:	cd 40                	int    $0x40
 9d7:	c3                   	ret    

000009d8 <open>:
SYSCALL(open)
 9d8:	b8 0f 00 00 00       	mov    $0xf,%eax
 9dd:	cd 40                	int    $0x40
 9df:	c3                   	ret    

000009e0 <mknod>:
SYSCALL(mknod)
 9e0:	b8 11 00 00 00       	mov    $0x11,%eax
 9e5:	cd 40                	int    $0x40
 9e7:	c3                   	ret    

000009e8 <unlink>:
SYSCALL(unlink)
 9e8:	b8 12 00 00 00       	mov    $0x12,%eax
 9ed:	cd 40                	int    $0x40
 9ef:	c3                   	ret    

000009f0 <fstat>:
SYSCALL(fstat)
 9f0:	b8 08 00 00 00       	mov    $0x8,%eax
 9f5:	cd 40                	int    $0x40
 9f7:	c3                   	ret    

000009f8 <link>:
SYSCALL(link)
 9f8:	b8 13 00 00 00       	mov    $0x13,%eax
 9fd:	cd 40                	int    $0x40
 9ff:	c3                   	ret    

00000a00 <mkdir>:
SYSCALL(mkdir)
 a00:	b8 14 00 00 00       	mov    $0x14,%eax
 a05:	cd 40                	int    $0x40
 a07:	c3                   	ret    

00000a08 <chdir>:
SYSCALL(chdir)
 a08:	b8 09 00 00 00       	mov    $0x9,%eax
 a0d:	cd 40                	int    $0x40
 a0f:	c3                   	ret    

00000a10 <dup>:
SYSCALL(dup)
 a10:	b8 0a 00 00 00       	mov    $0xa,%eax
 a15:	cd 40                	int    $0x40
 a17:	c3                   	ret    

00000a18 <getpid>:
SYSCALL(getpid)
 a18:	b8 0b 00 00 00       	mov    $0xb,%eax
 a1d:	cd 40                	int    $0x40
 a1f:	c3                   	ret    

00000a20 <sbrk>:
SYSCALL(sbrk)
 a20:	b8 0c 00 00 00       	mov    $0xc,%eax
 a25:	cd 40                	int    $0x40
 a27:	c3                   	ret    

00000a28 <sleep>:
SYSCALL(sleep)
 a28:	b8 0d 00 00 00       	mov    $0xd,%eax
 a2d:	cd 40                	int    $0x40
 a2f:	c3                   	ret    

00000a30 <uptime>:
SYSCALL(uptime)
 a30:	b8 0e 00 00 00       	mov    $0xe,%eax
 a35:	cd 40                	int    $0x40
 a37:	c3                   	ret    

00000a38 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a38:	55                   	push   %ebp
 a39:	89 e5                	mov    %esp,%ebp
 a3b:	83 ec 18             	sub    $0x18,%esp
 a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
 a41:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 a44:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 a4b:	00 
 a4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 a4f:	89 44 24 04          	mov    %eax,0x4(%esp)
 a53:	8b 45 08             	mov    0x8(%ebp),%eax
 a56:	89 04 24             	mov    %eax,(%esp)
 a59:	e8 5a ff ff ff       	call   9b8 <write>
}
 a5e:	c9                   	leave  
 a5f:	c3                   	ret    

00000a60 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	56                   	push   %esi
 a64:	53                   	push   %ebx
 a65:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 a68:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 a6f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 a73:	74 17                	je     a8c <printint+0x2c>
 a75:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 a79:	79 11                	jns    a8c <printint+0x2c>
    neg = 1;
 a7b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 a82:	8b 45 0c             	mov    0xc(%ebp),%eax
 a85:	f7 d8                	neg    %eax
 a87:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a8a:	eb 06                	jmp    a92 <printint+0x32>
  } else {
    x = xx;
 a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
 a8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a92:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a99:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a9c:	8d 41 01             	lea    0x1(%ecx),%eax
 a9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 aa8:	ba 00 00 00 00       	mov    $0x0,%edx
 aad:	f7 f3                	div    %ebx
 aaf:	89 d0                	mov    %edx,%eax
 ab1:	8a 80 4c 13 00 00    	mov    0x134c(%eax),%al
 ab7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 abb:	8b 75 10             	mov    0x10(%ebp),%esi
 abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ac1:	ba 00 00 00 00       	mov    $0x0,%edx
 ac6:	f7 f6                	div    %esi
 ac8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 acb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 acf:	75 c8                	jne    a99 <printint+0x39>
  if(neg)
 ad1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ad5:	74 10                	je     ae7 <printint+0x87>
    buf[i++] = '-';
 ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ada:	8d 50 01             	lea    0x1(%eax),%edx
 add:	89 55 f4             	mov    %edx,-0xc(%ebp)
 ae0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 ae5:	eb 1e                	jmp    b05 <printint+0xa5>
 ae7:	eb 1c                	jmp    b05 <printint+0xa5>
    putc(fd, buf[i]);
 ae9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aef:	01 d0                	add    %edx,%eax
 af1:	8a 00                	mov    (%eax),%al
 af3:	0f be c0             	movsbl %al,%eax
 af6:	89 44 24 04          	mov    %eax,0x4(%esp)
 afa:	8b 45 08             	mov    0x8(%ebp),%eax
 afd:	89 04 24             	mov    %eax,(%esp)
 b00:	e8 33 ff ff ff       	call   a38 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b05:	ff 4d f4             	decl   -0xc(%ebp)
 b08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b0c:	79 db                	jns    ae9 <printint+0x89>
    putc(fd, buf[i]);
}
 b0e:	83 c4 30             	add    $0x30,%esp
 b11:	5b                   	pop    %ebx
 b12:	5e                   	pop    %esi
 b13:	5d                   	pop    %ebp
 b14:	c3                   	ret    

00000b15 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b15:	55                   	push   %ebp
 b16:	89 e5                	mov    %esp,%ebp
 b18:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b1b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b22:	8d 45 0c             	lea    0xc(%ebp),%eax
 b25:	83 c0 04             	add    $0x4,%eax
 b28:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b2b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b32:	e9 77 01 00 00       	jmp    cae <printf+0x199>
    c = fmt[i] & 0xff;
 b37:	8b 55 0c             	mov    0xc(%ebp),%edx
 b3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b3d:	01 d0                	add    %edx,%eax
 b3f:	8a 00                	mov    (%eax),%al
 b41:	0f be c0             	movsbl %al,%eax
 b44:	25 ff 00 00 00       	and    $0xff,%eax
 b49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 b4c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b50:	75 2c                	jne    b7e <printf+0x69>
      if(c == '%'){
 b52:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b56:	75 0c                	jne    b64 <printf+0x4f>
        state = '%';
 b58:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 b5f:	e9 47 01 00 00       	jmp    cab <printf+0x196>
      } else {
        putc(fd, c);
 b64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b67:	0f be c0             	movsbl %al,%eax
 b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
 b6e:	8b 45 08             	mov    0x8(%ebp),%eax
 b71:	89 04 24             	mov    %eax,(%esp)
 b74:	e8 bf fe ff ff       	call   a38 <putc>
 b79:	e9 2d 01 00 00       	jmp    cab <printf+0x196>
      }
    } else if(state == '%'){
 b7e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 b82:	0f 85 23 01 00 00    	jne    cab <printf+0x196>
      if(c == 'd'){
 b88:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b8c:	75 2d                	jne    bbb <printf+0xa6>
        printint(fd, *ap, 10, 1);
 b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b91:	8b 00                	mov    (%eax),%eax
 b93:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 b9a:	00 
 b9b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 ba2:	00 
 ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
 ba7:	8b 45 08             	mov    0x8(%ebp),%eax
 baa:	89 04 24             	mov    %eax,(%esp)
 bad:	e8 ae fe ff ff       	call   a60 <printint>
        ap++;
 bb2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bb6:	e9 e9 00 00 00       	jmp    ca4 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 bbb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 bbf:	74 06                	je     bc7 <printf+0xb2>
 bc1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 bc5:	75 2d                	jne    bf4 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 bc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bca:	8b 00                	mov    (%eax),%eax
 bcc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 bd3:	00 
 bd4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 bdb:	00 
 bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
 be0:	8b 45 08             	mov    0x8(%ebp),%eax
 be3:	89 04 24             	mov    %eax,(%esp)
 be6:	e8 75 fe ff ff       	call   a60 <printint>
        ap++;
 beb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bef:	e9 b0 00 00 00       	jmp    ca4 <printf+0x18f>
      } else if(c == 's'){
 bf4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 bf8:	75 42                	jne    c3c <printf+0x127>
        s = (char*)*ap;
 bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bfd:	8b 00                	mov    (%eax),%eax
 bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c02:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c0a:	75 09                	jne    c15 <printf+0x100>
          s = "(null)";
 c0c:	c7 45 f4 5b 0f 00 00 	movl   $0xf5b,-0xc(%ebp)
        while(*s != 0){
 c13:	eb 1c                	jmp    c31 <printf+0x11c>
 c15:	eb 1a                	jmp    c31 <printf+0x11c>
          putc(fd, *s);
 c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1a:	8a 00                	mov    (%eax),%al
 c1c:	0f be c0             	movsbl %al,%eax
 c1f:	89 44 24 04          	mov    %eax,0x4(%esp)
 c23:	8b 45 08             	mov    0x8(%ebp),%eax
 c26:	89 04 24             	mov    %eax,(%esp)
 c29:	e8 0a fe ff ff       	call   a38 <putc>
          s++;
 c2e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c34:	8a 00                	mov    (%eax),%al
 c36:	84 c0                	test   %al,%al
 c38:	75 dd                	jne    c17 <printf+0x102>
 c3a:	eb 68                	jmp    ca4 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c3c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c40:	75 1d                	jne    c5f <printf+0x14a>
        putc(fd, *ap);
 c42:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c45:	8b 00                	mov    (%eax),%eax
 c47:	0f be c0             	movsbl %al,%eax
 c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
 c4e:	8b 45 08             	mov    0x8(%ebp),%eax
 c51:	89 04 24             	mov    %eax,(%esp)
 c54:	e8 df fd ff ff       	call   a38 <putc>
        ap++;
 c59:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c5d:	eb 45                	jmp    ca4 <printf+0x18f>
      } else if(c == '%'){
 c5f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c63:	75 17                	jne    c7c <printf+0x167>
        putc(fd, c);
 c65:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c68:	0f be c0             	movsbl %al,%eax
 c6b:	89 44 24 04          	mov    %eax,0x4(%esp)
 c6f:	8b 45 08             	mov    0x8(%ebp),%eax
 c72:	89 04 24             	mov    %eax,(%esp)
 c75:	e8 be fd ff ff       	call   a38 <putc>
 c7a:	eb 28                	jmp    ca4 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 c7c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 c83:	00 
 c84:	8b 45 08             	mov    0x8(%ebp),%eax
 c87:	89 04 24             	mov    %eax,(%esp)
 c8a:	e8 a9 fd ff ff       	call   a38 <putc>
        putc(fd, c);
 c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c92:	0f be c0             	movsbl %al,%eax
 c95:	89 44 24 04          	mov    %eax,0x4(%esp)
 c99:	8b 45 08             	mov    0x8(%ebp),%eax
 c9c:	89 04 24             	mov    %eax,(%esp)
 c9f:	e8 94 fd ff ff       	call   a38 <putc>
      }
      state = 0;
 ca4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 cab:	ff 45 f0             	incl   -0x10(%ebp)
 cae:	8b 55 0c             	mov    0xc(%ebp),%edx
 cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb4:	01 d0                	add    %edx,%eax
 cb6:	8a 00                	mov    (%eax),%al
 cb8:	84 c0                	test   %al,%al
 cba:	0f 85 77 fe ff ff    	jne    b37 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 cc0:	c9                   	leave  
 cc1:	c3                   	ret    
 cc2:	90                   	nop
 cc3:	90                   	nop

00000cc4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 cc4:	55                   	push   %ebp
 cc5:	89 e5                	mov    %esp,%ebp
 cc7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cca:	8b 45 08             	mov    0x8(%ebp),%eax
 ccd:	83 e8 08             	sub    $0x8,%eax
 cd0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cd3:	a1 70 13 00 00       	mov    0x1370,%eax
 cd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 cdb:	eb 24                	jmp    d01 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cdd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce0:	8b 00                	mov    (%eax),%eax
 ce2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ce5:	77 12                	ja     cf9 <free+0x35>
 ce7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ced:	77 24                	ja     d13 <free+0x4f>
 cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cf2:	8b 00                	mov    (%eax),%eax
 cf4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cf7:	77 1a                	ja     d13 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfc:	8b 00                	mov    (%eax),%eax
 cfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d01:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d04:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d07:	76 d4                	jbe    cdd <free+0x19>
 d09:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d0c:	8b 00                	mov    (%eax),%eax
 d0e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d11:	76 ca                	jbe    cdd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 d13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d16:	8b 40 04             	mov    0x4(%eax),%eax
 d19:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d20:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d23:	01 c2                	add    %eax,%edx
 d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d28:	8b 00                	mov    (%eax),%eax
 d2a:	39 c2                	cmp    %eax,%edx
 d2c:	75 24                	jne    d52 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d31:	8b 50 04             	mov    0x4(%eax),%edx
 d34:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d37:	8b 00                	mov    (%eax),%eax
 d39:	8b 40 04             	mov    0x4(%eax),%eax
 d3c:	01 c2                	add    %eax,%edx
 d3e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d41:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d44:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d47:	8b 00                	mov    (%eax),%eax
 d49:	8b 10                	mov    (%eax),%edx
 d4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d4e:	89 10                	mov    %edx,(%eax)
 d50:	eb 0a                	jmp    d5c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d55:	8b 10                	mov    (%eax),%edx
 d57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d5a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d5f:	8b 40 04             	mov    0x4(%eax),%eax
 d62:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d6c:	01 d0                	add    %edx,%eax
 d6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d71:	75 20                	jne    d93 <free+0xcf>
    p->s.size += bp->s.size;
 d73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d76:	8b 50 04             	mov    0x4(%eax),%edx
 d79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d7c:	8b 40 04             	mov    0x4(%eax),%eax
 d7f:	01 c2                	add    %eax,%edx
 d81:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d84:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d8a:	8b 10                	mov    (%eax),%edx
 d8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d8f:	89 10                	mov    %edx,(%eax)
 d91:	eb 08                	jmp    d9b <free+0xd7>
  } else
    p->s.ptr = bp;
 d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d96:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d99:	89 10                	mov    %edx,(%eax)
  freep = p;
 d9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d9e:	a3 70 13 00 00       	mov    %eax,0x1370
}
 da3:	c9                   	leave  
 da4:	c3                   	ret    

00000da5 <morecore>:

static Header*
morecore(uint nu)
{
 da5:	55                   	push   %ebp
 da6:	89 e5                	mov    %esp,%ebp
 da8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 dab:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 db2:	77 07                	ja     dbb <morecore+0x16>
    nu = 4096;
 db4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 dbb:	8b 45 08             	mov    0x8(%ebp),%eax
 dbe:	c1 e0 03             	shl    $0x3,%eax
 dc1:	89 04 24             	mov    %eax,(%esp)
 dc4:	e8 57 fc ff ff       	call   a20 <sbrk>
 dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 dcc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 dd0:	75 07                	jne    dd9 <morecore+0x34>
    return 0;
 dd2:	b8 00 00 00 00       	mov    $0x0,%eax
 dd7:	eb 22                	jmp    dfb <morecore+0x56>
  hp = (Header*)p;
 dd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ddc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ddf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 de2:	8b 55 08             	mov    0x8(%ebp),%edx
 de5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 de8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 deb:	83 c0 08             	add    $0x8,%eax
 dee:	89 04 24             	mov    %eax,(%esp)
 df1:	e8 ce fe ff ff       	call   cc4 <free>
  return freep;
 df6:	a1 70 13 00 00       	mov    0x1370,%eax
}
 dfb:	c9                   	leave  
 dfc:	c3                   	ret    

00000dfd <malloc>:

void*
malloc(uint nbytes)
{
 dfd:	55                   	push   %ebp
 dfe:	89 e5                	mov    %esp,%ebp
 e00:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e03:	8b 45 08             	mov    0x8(%ebp),%eax
 e06:	83 c0 07             	add    $0x7,%eax
 e09:	c1 e8 03             	shr    $0x3,%eax
 e0c:	40                   	inc    %eax
 e0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e10:	a1 70 13 00 00       	mov    0x1370,%eax
 e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e1c:	75 23                	jne    e41 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 e1e:	c7 45 f0 68 13 00 00 	movl   $0x1368,-0x10(%ebp)
 e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e28:	a3 70 13 00 00       	mov    %eax,0x1370
 e2d:	a1 70 13 00 00       	mov    0x1370,%eax
 e32:	a3 68 13 00 00       	mov    %eax,0x1368
    base.s.size = 0;
 e37:	c7 05 6c 13 00 00 00 	movl   $0x0,0x136c
 e3e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e44:	8b 00                	mov    (%eax),%eax
 e46:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e4c:	8b 40 04             	mov    0x4(%eax),%eax
 e4f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e52:	72 4d                	jb     ea1 <malloc+0xa4>
      if(p->s.size == nunits)
 e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e57:	8b 40 04             	mov    0x4(%eax),%eax
 e5a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 e5d:	75 0c                	jne    e6b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e62:	8b 10                	mov    (%eax),%edx
 e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e67:	89 10                	mov    %edx,(%eax)
 e69:	eb 26                	jmp    e91 <malloc+0x94>
      else {
        p->s.size -= nunits;
 e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e6e:	8b 40 04             	mov    0x4(%eax),%eax
 e71:	2b 45 ec             	sub    -0x14(%ebp),%eax
 e74:	89 c2                	mov    %eax,%edx
 e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e79:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e7f:	8b 40 04             	mov    0x4(%eax),%eax
 e82:	c1 e0 03             	shl    $0x3,%eax
 e85:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e8b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e8e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e94:	a3 70 13 00 00       	mov    %eax,0x1370
      return (void*)(p + 1);
 e99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e9c:	83 c0 08             	add    $0x8,%eax
 e9f:	eb 38                	jmp    ed9 <malloc+0xdc>
    }
    if(p == freep)
 ea1:	a1 70 13 00 00       	mov    0x1370,%eax
 ea6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ea9:	75 1b                	jne    ec6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
 eae:	89 04 24             	mov    %eax,(%esp)
 eb1:	e8 ef fe ff ff       	call   da5 <morecore>
 eb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 eb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ebd:	75 07                	jne    ec6 <malloc+0xc9>
        return 0;
 ebf:	b8 00 00 00 00       	mov    $0x0,%eax
 ec4:	eb 13                	jmp    ed9 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ecf:	8b 00                	mov    (%eax),%eax
 ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ed4:	e9 70 ff ff ff       	jmp    e49 <malloc+0x4c>
}
 ed9:	c9                   	leave  
 eda:	c3                   	ret    
