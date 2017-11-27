
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
  31:	05 00 14 00 00       	add    $0x1400,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 00 14 00 00       	add    $0x1400,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  50:	c7 04 24 4f 0f 00 00 	movl   $0xf4f,(%esp)
  57:	e8 9a 03 00 00       	call   3f6 <strchr>
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
  8c:	c7 44 24 04 00 14 00 	movl   $0x1400,0x4(%esp)
  93:	00 
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 fd 08 00 00       	call   99c <read>
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
  b2:	c7 44 24 04 55 0f 00 	movl   $0xf55,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 c3 0a 00 00       	call   b89 <printf>
    exit();
  c6:	e8 b9 08 00 00       	call   984 <exit>
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
  e7:	c7 44 24 04 65 0f 00 	movl   $0xf65,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 8e 0a 00 00       	call   b89 <printf>
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
 10c:	c7 44 24 04 72 0f 00 	movl   $0xf72,0x4(%esp)
 113:	00 
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    exit();
 120:	e8 5f 08 00 00       	call   984 <exit>
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
 14f:	e8 70 08 00 00       	call   9c4 <open>
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
 175:	c7 44 24 04 73 0f 00 	movl   $0xf73,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 00 0a 00 00       	call   b89 <printf>
      exit();
 189:	e8 f6 07 00 00       	call   984 <exit>
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
 1b7:	e8 f0 07 00 00       	call   9ac <close>
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
 1cd:	e8 b2 07 00 00       	call   984 <exit>
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

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
 22a:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
 22d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
 234:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 23b:	00 
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	89 04 24             	mov    %eax,(%esp)
 242:	e8 7d 07 00 00       	call   9c4 <open>
 247:	89 45 f0             	mov    %eax,-0x10(%ebp)
 24a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 24e:	79 20                	jns    270 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	89 44 24 08          	mov    %eax,0x8(%esp)
 257:	c7 44 24 04 87 0f 00 	movl   $0xf87,0x4(%esp)
 25e:	00 
 25f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 266:	e8 1e 09 00 00       	call   b89 <printf>
      exit();
 26b:	e8 14 07 00 00       	call   984 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 270:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 277:	00 
 278:	8b 45 0c             	mov    0xc(%ebp),%eax
 27b:	89 04 24             	mov    %eax,(%esp)
 27e:	e8 41 07 00 00       	call   9c4 <open>
 283:	89 45 ec             	mov    %eax,-0x14(%ebp)
 286:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 28a:	79 20                	jns    2ac <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 28c:	8b 45 0c             	mov    0xc(%ebp),%eax
 28f:	89 44 24 08          	mov    %eax,0x8(%esp)
 293:	c7 44 24 04 a2 0f 00 	movl   $0xfa2,0x4(%esp)
 29a:	00 
 29b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2a2:	e8 e2 08 00 00       	call   b89 <printf>
      exit();
 2a7:	e8 d8 06 00 00       	call   984 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 2ac:	eb 3b                	jmp    2e9 <copy+0xc2>
  {
      max = used_disk+=count;
 2ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2b1:	01 45 10             	add    %eax,0x10(%ebp)
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
 2b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 2ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2bd:	3b 45 14             	cmp    0x14(%ebp),%eax
 2c0:	7e 07                	jle    2c9 <copy+0xa2>
      {
        return -1;
 2c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c7:	eb 5c                	jmp    325 <copy+0xfe>
      }
      bytes = bytes + count;
 2c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2cc:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 2cf:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 2d6:	00 
 2d7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 2da:	89 44 24 04          	mov    %eax,0x4(%esp)
 2de:	8b 45 ec             	mov    -0x14(%ebp),%eax
 2e1:	89 04 24             	mov    %eax,(%esp)
 2e4:	e8 bb 06 00 00       	call   9a4 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 2e9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 2f0:	00 
 2f1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 2f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 2fb:	89 04 24             	mov    %eax,(%esp)
 2fe:	e8 99 06 00 00       	call   99c <read>
 303:	89 45 e8             	mov    %eax,-0x18(%ebp)
 306:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 30a:	7f a2                	jg     2ae <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 30f:	89 04 24             	mov    %eax,(%esp)
 312:	e8 95 06 00 00       	call   9ac <close>
  close(fd2);
 317:	8b 45 ec             	mov    -0x14(%ebp),%eax
 31a:	89 04 24             	mov    %eax,(%esp)
 31d:	e8 8a 06 00 00       	call   9ac <close>
  return(bytes);
 322:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 325:	c9                   	leave  
 326:	c3                   	ret    

00000327 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 327:	55                   	push   %ebp
 328:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 32a:	eb 06                	jmp    332 <strcmp+0xb>
    p++, q++;
 32c:	ff 45 08             	incl   0x8(%ebp)
 32f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	8a 00                	mov    (%eax),%al
 337:	84 c0                	test   %al,%al
 339:	74 0e                	je     349 <strcmp+0x22>
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	8a 10                	mov    (%eax),%dl
 340:	8b 45 0c             	mov    0xc(%ebp),%eax
 343:	8a 00                	mov    (%eax),%al
 345:	38 c2                	cmp    %al,%dl
 347:	74 e3                	je     32c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	8a 00                	mov    (%eax),%al
 34e:	0f b6 d0             	movzbl %al,%edx
 351:	8b 45 0c             	mov    0xc(%ebp),%eax
 354:	8a 00                	mov    (%eax),%al
 356:	0f b6 c0             	movzbl %al,%eax
 359:	29 c2                	sub    %eax,%edx
 35b:	89 d0                	mov    %edx,%eax
}
 35d:	5d                   	pop    %ebp
 35e:	c3                   	ret    

0000035f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 362:	eb 09                	jmp    36d <strncmp+0xe>
    n--, p++, q++;
 364:	ff 4d 10             	decl   0x10(%ebp)
 367:	ff 45 08             	incl   0x8(%ebp)
 36a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 36d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 371:	74 17                	je     38a <strncmp+0x2b>
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	8a 00                	mov    (%eax),%al
 378:	84 c0                	test   %al,%al
 37a:	74 0e                	je     38a <strncmp+0x2b>
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	8a 10                	mov    (%eax),%dl
 381:	8b 45 0c             	mov    0xc(%ebp),%eax
 384:	8a 00                	mov    (%eax),%al
 386:	38 c2                	cmp    %al,%dl
 388:	74 da                	je     364 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 38a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 38e:	75 07                	jne    397 <strncmp+0x38>
    return 0;
 390:	b8 00 00 00 00       	mov    $0x0,%eax
 395:	eb 14                	jmp    3ab <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 397:	8b 45 08             	mov    0x8(%ebp),%eax
 39a:	8a 00                	mov    (%eax),%al
 39c:	0f b6 d0             	movzbl %al,%edx
 39f:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a2:	8a 00                	mov    (%eax),%al
 3a4:	0f b6 c0             	movzbl %al,%eax
 3a7:	29 c2                	sub    %eax,%edx
 3a9:	89 d0                	mov    %edx,%eax
}
 3ab:	5d                   	pop    %ebp
 3ac:	c3                   	ret    

000003ad <strlen>:

uint
strlen(const char *s)
{
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
 3b0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3ba:	eb 03                	jmp    3bf <strlen+0x12>
 3bc:	ff 45 fc             	incl   -0x4(%ebp)
 3bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	01 d0                	add    %edx,%eax
 3c7:	8a 00                	mov    (%eax),%al
 3c9:	84 c0                	test   %al,%al
 3cb:	75 ef                	jne    3bc <strlen+0xf>
    ;
  return n;
 3cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d0:	c9                   	leave  
 3d1:	c3                   	ret    

000003d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d2:	55                   	push   %ebp
 3d3:	89 e5                	mov    %esp,%ebp
 3d5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 3d8:	8b 45 10             	mov    0x10(%ebp),%eax
 3db:	89 44 24 08          	mov    %eax,0x8(%esp)
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e6:	8b 45 08             	mov    0x8(%ebp),%eax
 3e9:	89 04 24             	mov    %eax,(%esp)
 3ec:	e8 e3 fd ff ff       	call   1d4 <stosb>
  return dst;
 3f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3f4:	c9                   	leave  
 3f5:	c3                   	ret    

000003f6 <strchr>:

char*
strchr(const char *s, char c)
{
 3f6:	55                   	push   %ebp
 3f7:	89 e5                	mov    %esp,%ebp
 3f9:	83 ec 04             	sub    $0x4,%esp
 3fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ff:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 402:	eb 12                	jmp    416 <strchr+0x20>
    if(*s == c)
 404:	8b 45 08             	mov    0x8(%ebp),%eax
 407:	8a 00                	mov    (%eax),%al
 409:	3a 45 fc             	cmp    -0x4(%ebp),%al
 40c:	75 05                	jne    413 <strchr+0x1d>
      return (char*)s;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
 411:	eb 11                	jmp    424 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 413:	ff 45 08             	incl   0x8(%ebp)
 416:	8b 45 08             	mov    0x8(%ebp),%eax
 419:	8a 00                	mov    (%eax),%al
 41b:	84 c0                	test   %al,%al
 41d:	75 e5                	jne    404 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 41f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 424:	c9                   	leave  
 425:	c3                   	ret    

00000426 <strcat>:

char *
strcat(char *dest, const char *src)
{
 426:	55                   	push   %ebp
 427:	89 e5                	mov    %esp,%ebp
 429:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 42c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 433:	eb 03                	jmp    438 <strcat+0x12>
 435:	ff 45 fc             	incl   -0x4(%ebp)
 438:	8b 55 fc             	mov    -0x4(%ebp),%edx
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	01 d0                	add    %edx,%eax
 440:	8a 00                	mov    (%eax),%al
 442:	84 c0                	test   %al,%al
 444:	75 ef                	jne    435 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 446:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 44d:	eb 1e                	jmp    46d <strcat+0x47>
        dest[i+j] = src[j];
 44f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 452:	8b 55 fc             	mov    -0x4(%ebp),%edx
 455:	01 d0                	add    %edx,%eax
 457:	89 c2                	mov    %eax,%edx
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	01 c2                	add    %eax,%edx
 45e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 461:	8b 45 0c             	mov    0xc(%ebp),%eax
 464:	01 c8                	add    %ecx,%eax
 466:	8a 00                	mov    (%eax),%al
 468:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 46a:	ff 45 f8             	incl   -0x8(%ebp)
 46d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 470:	8b 45 0c             	mov    0xc(%ebp),%eax
 473:	01 d0                	add    %edx,%eax
 475:	8a 00                	mov    (%eax),%al
 477:	84 c0                	test   %al,%al
 479:	75 d4                	jne    44f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 47b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 47e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 481:	01 d0                	add    %edx,%eax
 483:	89 c2                	mov    %eax,%edx
 485:	8b 45 08             	mov    0x8(%ebp),%eax
 488:	01 d0                	add    %edx,%eax
 48a:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 490:	c9                   	leave  
 491:	c3                   	ret    

00000492 <strstr>:

int 
strstr(char* s, char* sub)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 49f:	eb 7c                	jmp    51d <strstr+0x8b>
    {
        if(s[i] == sub[0])
 4a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4a4:	8b 45 08             	mov    0x8(%ebp),%eax
 4a7:	01 d0                	add    %edx,%eax
 4a9:	8a 10                	mov    (%eax),%dl
 4ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ae:	8a 00                	mov    (%eax),%al
 4b0:	38 c2                	cmp    %al,%dl
 4b2:	75 66                	jne    51a <strstr+0x88>
        {
            if(strlen(sub) == 1)
 4b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b7:	89 04 24             	mov    %eax,(%esp)
 4ba:	e8 ee fe ff ff       	call   3ad <strlen>
 4bf:	83 f8 01             	cmp    $0x1,%eax
 4c2:	75 05                	jne    4c9 <strstr+0x37>
            {  
                return i;
 4c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c7:	eb 6b                	jmp    534 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 4c9:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 4d0:	eb 3a                	jmp    50c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 4d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d8:	01 d0                	add    %edx,%eax
 4da:	89 c2                	mov    %eax,%edx
 4dc:	8b 45 08             	mov    0x8(%ebp),%eax
 4df:	01 d0                	add    %edx,%eax
 4e1:	8a 10                	mov    (%eax),%dl
 4e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e9:	01 c8                	add    %ecx,%eax
 4eb:	8a 00                	mov    (%eax),%al
 4ed:	38 c2                	cmp    %al,%dl
 4ef:	75 16                	jne    507 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 4f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4f4:	8d 50 01             	lea    0x1(%eax),%edx
 4f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4fa:	01 d0                	add    %edx,%eax
 4fc:	8a 00                	mov    (%eax),%al
 4fe:	84 c0                	test   %al,%al
 500:	75 07                	jne    509 <strstr+0x77>
                    {
                        return i;
 502:	8b 45 fc             	mov    -0x4(%ebp),%eax
 505:	eb 2d                	jmp    534 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 507:	eb 11                	jmp    51a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 509:	ff 45 f8             	incl   -0x8(%ebp)
 50c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 50f:	8b 45 0c             	mov    0xc(%ebp),%eax
 512:	01 d0                	add    %edx,%eax
 514:	8a 00                	mov    (%eax),%al
 516:	84 c0                	test   %al,%al
 518:	75 b8                	jne    4d2 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 51a:	ff 45 fc             	incl   -0x4(%ebp)
 51d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 520:	8b 45 08             	mov    0x8(%ebp),%eax
 523:	01 d0                	add    %edx,%eax
 525:	8a 00                	mov    (%eax),%al
 527:	84 c0                	test   %al,%al
 529:	0f 85 72 ff ff ff    	jne    4a1 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 52f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 534:	c9                   	leave  
 535:	c3                   	ret    

00000536 <strtok>:

char *
strtok(char *s, const char *delim)
{
 536:	55                   	push   %ebp
 537:	89 e5                	mov    %esp,%ebp
 539:	53                   	push   %ebx
 53a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 53d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 541:	75 08                	jne    54b <strtok+0x15>
  s = lasts;
 543:	a1 e4 13 00 00       	mov    0x13e4,%eax
 548:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 54b:	8b 45 08             	mov    0x8(%ebp),%eax
 54e:	8d 50 01             	lea    0x1(%eax),%edx
 551:	89 55 08             	mov    %edx,0x8(%ebp)
 554:	8a 00                	mov    (%eax),%al
 556:	0f be d8             	movsbl %al,%ebx
 559:	85 db                	test   %ebx,%ebx
 55b:	75 07                	jne    564 <strtok+0x2e>
      return 0;
 55d:	b8 00 00 00 00       	mov    $0x0,%eax
 562:	eb 58                	jmp    5bc <strtok+0x86>
    } while (strchr(delim, ch));
 564:	88 d8                	mov    %bl,%al
 566:	0f be c0             	movsbl %al,%eax
 569:	89 44 24 04          	mov    %eax,0x4(%esp)
 56d:	8b 45 0c             	mov    0xc(%ebp),%eax
 570:	89 04 24             	mov    %eax,(%esp)
 573:	e8 7e fe ff ff       	call   3f6 <strchr>
 578:	85 c0                	test   %eax,%eax
 57a:	75 cf                	jne    54b <strtok+0x15>
    --s;
 57c:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 57f:	8b 45 0c             	mov    0xc(%ebp),%eax
 582:	89 44 24 04          	mov    %eax,0x4(%esp)
 586:	8b 45 08             	mov    0x8(%ebp),%eax
 589:	89 04 24             	mov    %eax,(%esp)
 58c:	e8 31 00 00 00       	call   5c2 <strcspn>
 591:	89 c2                	mov    %eax,%edx
 593:	8b 45 08             	mov    0x8(%ebp),%eax
 596:	01 d0                	add    %edx,%eax
 598:	a3 e4 13 00 00       	mov    %eax,0x13e4
    if (*lasts != 0)
 59d:	a1 e4 13 00 00       	mov    0x13e4,%eax
 5a2:	8a 00                	mov    (%eax),%al
 5a4:	84 c0                	test   %al,%al
 5a6:	74 11                	je     5b9 <strtok+0x83>
  *lasts++ = 0;
 5a8:	a1 e4 13 00 00       	mov    0x13e4,%eax
 5ad:	8d 50 01             	lea    0x1(%eax),%edx
 5b0:	89 15 e4 13 00 00    	mov    %edx,0x13e4
 5b6:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 5b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5bc:	83 c4 14             	add    $0x14,%esp
 5bf:	5b                   	pop    %ebx
 5c0:	5d                   	pop    %ebp
 5c1:	c3                   	ret    

000005c2 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 5c2:	55                   	push   %ebp
 5c3:	89 e5                	mov    %esp,%ebp
 5c5:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 5c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 5cf:	eb 26                	jmp    5f7 <strcspn+0x35>
        if(strchr(s2,*s1))
 5d1:	8b 45 08             	mov    0x8(%ebp),%eax
 5d4:	8a 00                	mov    (%eax),%al
 5d6:	0f be c0             	movsbl %al,%eax
 5d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e0:	89 04 24             	mov    %eax,(%esp)
 5e3:	e8 0e fe ff ff       	call   3f6 <strchr>
 5e8:	85 c0                	test   %eax,%eax
 5ea:	74 05                	je     5f1 <strcspn+0x2f>
            return ret;
 5ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5ef:	eb 12                	jmp    603 <strcspn+0x41>
        else
            s1++,ret++;
 5f1:	ff 45 08             	incl   0x8(%ebp)
 5f4:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	8a 00                	mov    (%eax),%al
 5fc:	84 c0                	test   %al,%al
 5fe:	75 d1                	jne    5d1 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 600:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 603:	c9                   	leave  
 604:	c3                   	ret    

00000605 <isspace>:

int
isspace(unsigned char c)
{
 605:	55                   	push   %ebp
 606:	89 e5                	mov    %esp,%ebp
 608:	83 ec 04             	sub    $0x4,%esp
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 611:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 615:	74 1e                	je     635 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 617:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 61b:	74 18                	je     635 <isspace+0x30>
 61d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 621:	74 12                	je     635 <isspace+0x30>
 623:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 627:	74 0c                	je     635 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 629:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 62d:	74 06                	je     635 <isspace+0x30>
 62f:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 633:	75 07                	jne    63c <isspace+0x37>
 635:	b8 01 00 00 00       	mov    $0x1,%eax
 63a:	eb 05                	jmp    641 <isspace+0x3c>
 63c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 641:	c9                   	leave  
 642:	c3                   	ret    

00000643 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	57                   	push   %edi
 647:	56                   	push   %esi
 648:	53                   	push   %ebx
 649:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 64c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 651:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 658:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 65b:	eb 01                	jmp    65e <strtoul+0x1b>
  p += 1;
 65d:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 65e:	8a 03                	mov    (%ebx),%al
 660:	0f b6 c0             	movzbl %al,%eax
 663:	89 04 24             	mov    %eax,(%esp)
 666:	e8 9a ff ff ff       	call   605 <isspace>
 66b:	85 c0                	test   %eax,%eax
 66d:	75 ee                	jne    65d <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 66f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 673:	75 30                	jne    6a5 <strtoul+0x62>
    {
  if (*p == '0') {
 675:	8a 03                	mov    (%ebx),%al
 677:	3c 30                	cmp    $0x30,%al
 679:	75 21                	jne    69c <strtoul+0x59>
      p += 1;
 67b:	43                   	inc    %ebx
      if (*p == 'x') {
 67c:	8a 03                	mov    (%ebx),%al
 67e:	3c 78                	cmp    $0x78,%al
 680:	75 0a                	jne    68c <strtoul+0x49>
    p += 1;
 682:	43                   	inc    %ebx
    base = 16;
 683:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 68a:	eb 31                	jmp    6bd <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 68c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 693:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 69a:	eb 21                	jmp    6bd <strtoul+0x7a>
      }
  }
  else base = 10;
 69c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 6a3:	eb 18                	jmp    6bd <strtoul+0x7a>
    } else if (base == 16) {
 6a5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 6a9:	75 12                	jne    6bd <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 6ab:	8a 03                	mov    (%ebx),%al
 6ad:	3c 30                	cmp    $0x30,%al
 6af:	75 0c                	jne    6bd <strtoul+0x7a>
 6b1:	8d 43 01             	lea    0x1(%ebx),%eax
 6b4:	8a 00                	mov    (%eax),%al
 6b6:	3c 78                	cmp    $0x78,%al
 6b8:	75 03                	jne    6bd <strtoul+0x7a>
      p += 2;
 6ba:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 6bd:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 6c1:	75 29                	jne    6ec <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6c3:	8a 03                	mov    (%ebx),%al
 6c5:	0f be c0             	movsbl %al,%eax
 6c8:	83 e8 30             	sub    $0x30,%eax
 6cb:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 6cd:	83 fe 07             	cmp    $0x7,%esi
 6d0:	76 06                	jbe    6d8 <strtoul+0x95>
    break;
 6d2:	90                   	nop
 6d3:	e9 b6 00 00 00       	jmp    78e <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 6d8:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 6df:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 6e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 6e9:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 6ea:	eb d7                	jmp    6c3 <strtoul+0x80>
    } else if (base == 10) {
 6ec:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 6f0:	75 2b                	jne    71d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 6f2:	8a 03                	mov    (%ebx),%al
 6f4:	0f be c0             	movsbl %al,%eax
 6f7:	83 e8 30             	sub    $0x30,%eax
 6fa:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 6fc:	83 fe 09             	cmp    $0x9,%esi
 6ff:	76 06                	jbe    707 <strtoul+0xc4>
    break;
 701:	90                   	nop
 702:	e9 87 00 00 00       	jmp    78e <strtoul+0x14b>
      }
      result = (10*result) + digit;
 707:	89 f8                	mov    %edi,%eax
 709:	c1 e0 02             	shl    $0x2,%eax
 70c:	01 f8                	add    %edi,%eax
 70e:	01 c0                	add    %eax,%eax
 710:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 713:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 71a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 71b:	eb d5                	jmp    6f2 <strtoul+0xaf>
    } else if (base == 16) {
 71d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 721:	75 35                	jne    758 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 723:	8a 03                	mov    (%ebx),%al
 725:	0f be c0             	movsbl %al,%eax
 728:	83 e8 30             	sub    $0x30,%eax
 72b:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 72d:	83 fe 4a             	cmp    $0x4a,%esi
 730:	76 02                	jbe    734 <strtoul+0xf1>
    break;
 732:	eb 22                	jmp    756 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 734:	8a 86 80 13 00 00    	mov    0x1380(%esi),%al
 73a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 73d:	83 fe 0f             	cmp    $0xf,%esi
 740:	76 02                	jbe    744 <strtoul+0x101>
    break;
 742:	eb 12                	jmp    756 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 744:	89 f8                	mov    %edi,%eax
 746:	c1 e0 04             	shl    $0x4,%eax
 749:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 74c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 753:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 754:	eb cd                	jmp    723 <strtoul+0xe0>
 756:	eb 36                	jmp    78e <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 758:	8a 03                	mov    (%ebx),%al
 75a:	0f be c0             	movsbl %al,%eax
 75d:	83 e8 30             	sub    $0x30,%eax
 760:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 762:	83 fe 4a             	cmp    $0x4a,%esi
 765:	76 02                	jbe    769 <strtoul+0x126>
    break;
 767:	eb 25                	jmp    78e <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 769:	8a 86 80 13 00 00    	mov    0x1380(%esi),%al
 76f:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 772:	8b 45 10             	mov    0x10(%ebp),%eax
 775:	39 f0                	cmp    %esi,%eax
 777:	77 02                	ja     77b <strtoul+0x138>
    break;
 779:	eb 13                	jmp    78e <strtoul+0x14b>
      }
      result = result*base + digit;
 77b:	8b 45 10             	mov    0x10(%ebp),%eax
 77e:	0f af c7             	imul   %edi,%eax
 781:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 784:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 78b:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 78c:	eb ca                	jmp    758 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 78e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 792:	75 03                	jne    797 <strtoul+0x154>
  p = string;
 794:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 797:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 79b:	74 05                	je     7a2 <strtoul+0x15f>
  *endPtr = p;
 79d:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a0:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 7a2:	89 f8                	mov    %edi,%eax
}
 7a4:	83 c4 14             	add    $0x14,%esp
 7a7:	5b                   	pop    %ebx
 7a8:	5e                   	pop    %esi
 7a9:	5f                   	pop    %edi
 7aa:	5d                   	pop    %ebp
 7ab:	c3                   	ret    

000007ac <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 7ac:	55                   	push   %ebp
 7ad:	89 e5                	mov    %esp,%ebp
 7af:	53                   	push   %ebx
 7b0:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 7b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 7b6:	eb 01                	jmp    7b9 <strtol+0xd>
      p += 1;
 7b8:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 7b9:	8a 03                	mov    (%ebx),%al
 7bb:	0f b6 c0             	movzbl %al,%eax
 7be:	89 04 24             	mov    %eax,(%esp)
 7c1:	e8 3f fe ff ff       	call   605 <isspace>
 7c6:	85 c0                	test   %eax,%eax
 7c8:	75 ee                	jne    7b8 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 7ca:	8a 03                	mov    (%ebx),%al
 7cc:	3c 2d                	cmp    $0x2d,%al
 7ce:	75 1e                	jne    7ee <strtol+0x42>
  p += 1;
 7d0:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 7d1:	8b 45 10             	mov    0x10(%ebp),%eax
 7d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 7d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 7db:	89 44 24 04          	mov    %eax,0x4(%esp)
 7df:	89 1c 24             	mov    %ebx,(%esp)
 7e2:	e8 5c fe ff ff       	call   643 <strtoul>
 7e7:	f7 d8                	neg    %eax
 7e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 7ec:	eb 20                	jmp    80e <strtol+0x62>
    } else {
  if (*p == '+') {
 7ee:	8a 03                	mov    (%ebx),%al
 7f0:	3c 2b                	cmp    $0x2b,%al
 7f2:	75 01                	jne    7f5 <strtol+0x49>
      p += 1;
 7f4:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 7f5:	8b 45 10             	mov    0x10(%ebp),%eax
 7f8:	89 44 24 08          	mov    %eax,0x8(%esp)
 7fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 803:	89 1c 24             	mov    %ebx,(%esp)
 806:	e8 38 fe ff ff       	call   643 <strtoul>
 80b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 80e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 812:	75 17                	jne    82b <strtol+0x7f>
 814:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 818:	74 11                	je     82b <strtol+0x7f>
 81a:	8b 45 0c             	mov    0xc(%ebp),%eax
 81d:	8b 00                	mov    (%eax),%eax
 81f:	39 d8                	cmp    %ebx,%eax
 821:	75 08                	jne    82b <strtol+0x7f>
  *endPtr = string;
 823:	8b 45 0c             	mov    0xc(%ebp),%eax
 826:	8b 55 08             	mov    0x8(%ebp),%edx
 829:	89 10                	mov    %edx,(%eax)
    }
    return result;
 82b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 82e:	83 c4 1c             	add    $0x1c,%esp
 831:	5b                   	pop    %ebx
 832:	5d                   	pop    %ebp
 833:	c3                   	ret    

00000834 <gets>:

char*
gets(char *buf, int max)
{
 834:	55                   	push   %ebp
 835:	89 e5                	mov    %esp,%ebp
 837:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 83a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 841:	eb 49                	jmp    88c <gets+0x58>
    cc = read(0, &c, 1);
 843:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 84a:	00 
 84b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 84e:	89 44 24 04          	mov    %eax,0x4(%esp)
 852:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 859:	e8 3e 01 00 00       	call   99c <read>
 85e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 861:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 865:	7f 02                	jg     869 <gets+0x35>
      break;
 867:	eb 2c                	jmp    895 <gets+0x61>
    buf[i++] = c;
 869:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86c:	8d 50 01             	lea    0x1(%eax),%edx
 86f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 872:	89 c2                	mov    %eax,%edx
 874:	8b 45 08             	mov    0x8(%ebp),%eax
 877:	01 c2                	add    %eax,%edx
 879:	8a 45 ef             	mov    -0x11(%ebp),%al
 87c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 87e:	8a 45 ef             	mov    -0x11(%ebp),%al
 881:	3c 0a                	cmp    $0xa,%al
 883:	74 10                	je     895 <gets+0x61>
 885:	8a 45 ef             	mov    -0x11(%ebp),%al
 888:	3c 0d                	cmp    $0xd,%al
 88a:	74 09                	je     895 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88f:	40                   	inc    %eax
 890:	3b 45 0c             	cmp    0xc(%ebp),%eax
 893:	7c ae                	jl     843 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 895:	8b 55 f4             	mov    -0xc(%ebp),%edx
 898:	8b 45 08             	mov    0x8(%ebp),%eax
 89b:	01 d0                	add    %edx,%eax
 89d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8a3:	c9                   	leave  
 8a4:	c3                   	ret    

000008a5 <stat>:

int
stat(char *n, struct stat *st)
{
 8a5:	55                   	push   %ebp
 8a6:	89 e5                	mov    %esp,%ebp
 8a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 8ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 8b2:	00 
 8b3:	8b 45 08             	mov    0x8(%ebp),%eax
 8b6:	89 04 24             	mov    %eax,(%esp)
 8b9:	e8 06 01 00 00       	call   9c4 <open>
 8be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 8c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8c5:	79 07                	jns    8ce <stat+0x29>
    return -1;
 8c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 8cc:	eb 23                	jmp    8f1 <stat+0x4c>
  r = fstat(fd, st);
 8ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d8:	89 04 24             	mov    %eax,(%esp)
 8db:	e8 fc 00 00 00       	call   9dc <fstat>
 8e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	89 04 24             	mov    %eax,(%esp)
 8e9:	e8 be 00 00 00       	call   9ac <close>
  return r;
 8ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8f1:	c9                   	leave  
 8f2:	c3                   	ret    

000008f3 <atoi>:

int
atoi(const char *s)
{
 8f3:	55                   	push   %ebp
 8f4:	89 e5                	mov    %esp,%ebp
 8f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 8f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 900:	eb 24                	jmp    926 <atoi+0x33>
    n = n*10 + *s++ - '0';
 902:	8b 55 fc             	mov    -0x4(%ebp),%edx
 905:	89 d0                	mov    %edx,%eax
 907:	c1 e0 02             	shl    $0x2,%eax
 90a:	01 d0                	add    %edx,%eax
 90c:	01 c0                	add    %eax,%eax
 90e:	89 c1                	mov    %eax,%ecx
 910:	8b 45 08             	mov    0x8(%ebp),%eax
 913:	8d 50 01             	lea    0x1(%eax),%edx
 916:	89 55 08             	mov    %edx,0x8(%ebp)
 919:	8a 00                	mov    (%eax),%al
 91b:	0f be c0             	movsbl %al,%eax
 91e:	01 c8                	add    %ecx,%eax
 920:	83 e8 30             	sub    $0x30,%eax
 923:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 926:	8b 45 08             	mov    0x8(%ebp),%eax
 929:	8a 00                	mov    (%eax),%al
 92b:	3c 2f                	cmp    $0x2f,%al
 92d:	7e 09                	jle    938 <atoi+0x45>
 92f:	8b 45 08             	mov    0x8(%ebp),%eax
 932:	8a 00                	mov    (%eax),%al
 934:	3c 39                	cmp    $0x39,%al
 936:	7e ca                	jle    902 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 93b:	c9                   	leave  
 93c:	c3                   	ret    

0000093d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 93d:	55                   	push   %ebp
 93e:	89 e5                	mov    %esp,%ebp
 940:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 943:	8b 45 08             	mov    0x8(%ebp),%eax
 946:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 949:	8b 45 0c             	mov    0xc(%ebp),%eax
 94c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 94f:	eb 16                	jmp    967 <memmove+0x2a>
    *dst++ = *src++;
 951:	8b 45 fc             	mov    -0x4(%ebp),%eax
 954:	8d 50 01             	lea    0x1(%eax),%edx
 957:	89 55 fc             	mov    %edx,-0x4(%ebp)
 95a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 95d:	8d 4a 01             	lea    0x1(%edx),%ecx
 960:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 963:	8a 12                	mov    (%edx),%dl
 965:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 967:	8b 45 10             	mov    0x10(%ebp),%eax
 96a:	8d 50 ff             	lea    -0x1(%eax),%edx
 96d:	89 55 10             	mov    %edx,0x10(%ebp)
 970:	85 c0                	test   %eax,%eax
 972:	7f dd                	jg     951 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 974:	8b 45 08             	mov    0x8(%ebp),%eax
}
 977:	c9                   	leave  
 978:	c3                   	ret    
 979:	90                   	nop
 97a:	90                   	nop
 97b:	90                   	nop

0000097c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 97c:	b8 01 00 00 00       	mov    $0x1,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <exit>:
SYSCALL(exit)
 984:	b8 02 00 00 00       	mov    $0x2,%eax
 989:	cd 40                	int    $0x40
 98b:	c3                   	ret    

0000098c <wait>:
SYSCALL(wait)
 98c:	b8 03 00 00 00       	mov    $0x3,%eax
 991:	cd 40                	int    $0x40
 993:	c3                   	ret    

00000994 <pipe>:
SYSCALL(pipe)
 994:	b8 04 00 00 00       	mov    $0x4,%eax
 999:	cd 40                	int    $0x40
 99b:	c3                   	ret    

0000099c <read>:
SYSCALL(read)
 99c:	b8 05 00 00 00       	mov    $0x5,%eax
 9a1:	cd 40                	int    $0x40
 9a3:	c3                   	ret    

000009a4 <write>:
SYSCALL(write)
 9a4:	b8 10 00 00 00       	mov    $0x10,%eax
 9a9:	cd 40                	int    $0x40
 9ab:	c3                   	ret    

000009ac <close>:
SYSCALL(close)
 9ac:	b8 15 00 00 00       	mov    $0x15,%eax
 9b1:	cd 40                	int    $0x40
 9b3:	c3                   	ret    

000009b4 <kill>:
SYSCALL(kill)
 9b4:	b8 06 00 00 00       	mov    $0x6,%eax
 9b9:	cd 40                	int    $0x40
 9bb:	c3                   	ret    

000009bc <exec>:
SYSCALL(exec)
 9bc:	b8 07 00 00 00       	mov    $0x7,%eax
 9c1:	cd 40                	int    $0x40
 9c3:	c3                   	ret    

000009c4 <open>:
SYSCALL(open)
 9c4:	b8 0f 00 00 00       	mov    $0xf,%eax
 9c9:	cd 40                	int    $0x40
 9cb:	c3                   	ret    

000009cc <mknod>:
SYSCALL(mknod)
 9cc:	b8 11 00 00 00       	mov    $0x11,%eax
 9d1:	cd 40                	int    $0x40
 9d3:	c3                   	ret    

000009d4 <unlink>:
SYSCALL(unlink)
 9d4:	b8 12 00 00 00       	mov    $0x12,%eax
 9d9:	cd 40                	int    $0x40
 9db:	c3                   	ret    

000009dc <fstat>:
SYSCALL(fstat)
 9dc:	b8 08 00 00 00       	mov    $0x8,%eax
 9e1:	cd 40                	int    $0x40
 9e3:	c3                   	ret    

000009e4 <link>:
SYSCALL(link)
 9e4:	b8 13 00 00 00       	mov    $0x13,%eax
 9e9:	cd 40                	int    $0x40
 9eb:	c3                   	ret    

000009ec <mkdir>:
SYSCALL(mkdir)
 9ec:	b8 14 00 00 00       	mov    $0x14,%eax
 9f1:	cd 40                	int    $0x40
 9f3:	c3                   	ret    

000009f4 <chdir>:
SYSCALL(chdir)
 9f4:	b8 09 00 00 00       	mov    $0x9,%eax
 9f9:	cd 40                	int    $0x40
 9fb:	c3                   	ret    

000009fc <dup>:
SYSCALL(dup)
 9fc:	b8 0a 00 00 00       	mov    $0xa,%eax
 a01:	cd 40                	int    $0x40
 a03:	c3                   	ret    

00000a04 <getpid>:
SYSCALL(getpid)
 a04:	b8 0b 00 00 00       	mov    $0xb,%eax
 a09:	cd 40                	int    $0x40
 a0b:	c3                   	ret    

00000a0c <sbrk>:
SYSCALL(sbrk)
 a0c:	b8 0c 00 00 00       	mov    $0xc,%eax
 a11:	cd 40                	int    $0x40
 a13:	c3                   	ret    

00000a14 <sleep>:
SYSCALL(sleep)
 a14:	b8 0d 00 00 00       	mov    $0xd,%eax
 a19:	cd 40                	int    $0x40
 a1b:	c3                   	ret    

00000a1c <uptime>:
SYSCALL(uptime)
 a1c:	b8 0e 00 00 00       	mov    $0xe,%eax
 a21:	cd 40                	int    $0x40
 a23:	c3                   	ret    

00000a24 <getname>:
SYSCALL(getname)
 a24:	b8 16 00 00 00       	mov    $0x16,%eax
 a29:	cd 40                	int    $0x40
 a2b:	c3                   	ret    

00000a2c <setname>:
SYSCALL(setname)
 a2c:	b8 17 00 00 00       	mov    $0x17,%eax
 a31:	cd 40                	int    $0x40
 a33:	c3                   	ret    

00000a34 <getmaxproc>:
SYSCALL(getmaxproc)
 a34:	b8 18 00 00 00       	mov    $0x18,%eax
 a39:	cd 40                	int    $0x40
 a3b:	c3                   	ret    

00000a3c <setmaxproc>:
SYSCALL(setmaxproc)
 a3c:	b8 19 00 00 00       	mov    $0x19,%eax
 a41:	cd 40                	int    $0x40
 a43:	c3                   	ret    

00000a44 <getmaxmem>:
SYSCALL(getmaxmem)
 a44:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a49:	cd 40                	int    $0x40
 a4b:	c3                   	ret    

00000a4c <setmaxmem>:
SYSCALL(setmaxmem)
 a4c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 a51:	cd 40                	int    $0x40
 a53:	c3                   	ret    

00000a54 <getmaxdisk>:
SYSCALL(getmaxdisk)
 a54:	b8 1c 00 00 00       	mov    $0x1c,%eax
 a59:	cd 40                	int    $0x40
 a5b:	c3                   	ret    

00000a5c <setmaxdisk>:
SYSCALL(setmaxdisk)
 a5c:	b8 1d 00 00 00       	mov    $0x1d,%eax
 a61:	cd 40                	int    $0x40
 a63:	c3                   	ret    

00000a64 <getusedmem>:
SYSCALL(getusedmem)
 a64:	b8 1e 00 00 00       	mov    $0x1e,%eax
 a69:	cd 40                	int    $0x40
 a6b:	c3                   	ret    

00000a6c <setusedmem>:
SYSCALL(setusedmem)
 a6c:	b8 1f 00 00 00       	mov    $0x1f,%eax
 a71:	cd 40                	int    $0x40
 a73:	c3                   	ret    

00000a74 <getuseddisk>:
SYSCALL(getuseddisk)
 a74:	b8 20 00 00 00       	mov    $0x20,%eax
 a79:	cd 40                	int    $0x40
 a7b:	c3                   	ret    

00000a7c <setuseddisk>:
SYSCALL(setuseddisk)
 a7c:	b8 21 00 00 00       	mov    $0x21,%eax
 a81:	cd 40                	int    $0x40
 a83:	c3                   	ret    

00000a84 <setvc>:
SYSCALL(setvc)
 a84:	b8 22 00 00 00       	mov    $0x22,%eax
 a89:	cd 40                	int    $0x40
 a8b:	c3                   	ret    

00000a8c <setactivefs>:
SYSCALL(setactivefs)
 a8c:	b8 24 00 00 00       	mov    $0x24,%eax
 a91:	cd 40                	int    $0x40
 a93:	c3                   	ret    

00000a94 <getactivefs>:
SYSCALL(getactivefs)
 a94:	b8 25 00 00 00       	mov    $0x25,%eax
 a99:	cd 40                	int    $0x40
 a9b:	c3                   	ret    

00000a9c <getvcfs>:
SYSCALL(getvcfs)
 a9c:	b8 23 00 00 00       	mov    $0x23,%eax
 aa1:	cd 40                	int    $0x40
 aa3:	c3                   	ret    

00000aa4 <getcwd>:
SYSCALL(getcwd)
 aa4:	b8 26 00 00 00       	mov    $0x26,%eax
 aa9:	cd 40                	int    $0x40
 aab:	c3                   	ret    

00000aac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 aac:	55                   	push   %ebp
 aad:	89 e5                	mov    %esp,%ebp
 aaf:	83 ec 18             	sub    $0x18,%esp
 ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
 ab5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 ab8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 abf:	00 
 ac0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
 ac7:	8b 45 08             	mov    0x8(%ebp),%eax
 aca:	89 04 24             	mov    %eax,(%esp)
 acd:	e8 d2 fe ff ff       	call   9a4 <write>
}
 ad2:	c9                   	leave  
 ad3:	c3                   	ret    

00000ad4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 ad4:	55                   	push   %ebp
 ad5:	89 e5                	mov    %esp,%ebp
 ad7:	56                   	push   %esi
 ad8:	53                   	push   %ebx
 ad9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 adc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 ae3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 ae7:	74 17                	je     b00 <printint+0x2c>
 ae9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 aed:	79 11                	jns    b00 <printint+0x2c>
    neg = 1;
 aef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 af6:	8b 45 0c             	mov    0xc(%ebp),%eax
 af9:	f7 d8                	neg    %eax
 afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
 afe:	eb 06                	jmp    b06 <printint+0x32>
  } else {
    x = xx;
 b00:	8b 45 0c             	mov    0xc(%ebp),%eax
 b03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 b06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 b0d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 b10:	8d 41 01             	lea    0x1(%ecx),%eax
 b13:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b16:	8b 5d 10             	mov    0x10(%ebp),%ebx
 b19:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b1c:	ba 00 00 00 00       	mov    $0x0,%edx
 b21:	f7 f3                	div    %ebx
 b23:	89 d0                	mov    %edx,%eax
 b25:	8a 80 cc 13 00 00    	mov    0x13cc(%eax),%al
 b2b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 b2f:	8b 75 10             	mov    0x10(%ebp),%esi
 b32:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b35:	ba 00 00 00 00       	mov    $0x0,%edx
 b3a:	f7 f6                	div    %esi
 b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b43:	75 c8                	jne    b0d <printint+0x39>
  if(neg)
 b45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b49:	74 10                	je     b5b <printint+0x87>
    buf[i++] = '-';
 b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4e:	8d 50 01             	lea    0x1(%eax),%edx
 b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
 b54:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 b59:	eb 1e                	jmp    b79 <printint+0xa5>
 b5b:	eb 1c                	jmp    b79 <printint+0xa5>
    putc(fd, buf[i]);
 b5d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b63:	01 d0                	add    %edx,%eax
 b65:	8a 00                	mov    (%eax),%al
 b67:	0f be c0             	movsbl %al,%eax
 b6a:	89 44 24 04          	mov    %eax,0x4(%esp)
 b6e:	8b 45 08             	mov    0x8(%ebp),%eax
 b71:	89 04 24             	mov    %eax,(%esp)
 b74:	e8 33 ff ff ff       	call   aac <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b79:	ff 4d f4             	decl   -0xc(%ebp)
 b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b80:	79 db                	jns    b5d <printint+0x89>
    putc(fd, buf[i]);
}
 b82:	83 c4 30             	add    $0x30,%esp
 b85:	5b                   	pop    %ebx
 b86:	5e                   	pop    %esi
 b87:	5d                   	pop    %ebp
 b88:	c3                   	ret    

00000b89 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b89:	55                   	push   %ebp
 b8a:	89 e5                	mov    %esp,%ebp
 b8c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b96:	8d 45 0c             	lea    0xc(%ebp),%eax
 b99:	83 c0 04             	add    $0x4,%eax
 b9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 ba6:	e9 77 01 00 00       	jmp    d22 <printf+0x199>
    c = fmt[i] & 0xff;
 bab:	8b 55 0c             	mov    0xc(%ebp),%edx
 bae:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bb1:	01 d0                	add    %edx,%eax
 bb3:	8a 00                	mov    (%eax),%al
 bb5:	0f be c0             	movsbl %al,%eax
 bb8:	25 ff 00 00 00       	and    $0xff,%eax
 bbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 bc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bc4:	75 2c                	jne    bf2 <printf+0x69>
      if(c == '%'){
 bc6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bca:	75 0c                	jne    bd8 <printf+0x4f>
        state = '%';
 bcc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 bd3:	e9 47 01 00 00       	jmp    d1f <printf+0x196>
      } else {
        putc(fd, c);
 bd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bdb:	0f be c0             	movsbl %al,%eax
 bde:	89 44 24 04          	mov    %eax,0x4(%esp)
 be2:	8b 45 08             	mov    0x8(%ebp),%eax
 be5:	89 04 24             	mov    %eax,(%esp)
 be8:	e8 bf fe ff ff       	call   aac <putc>
 bed:	e9 2d 01 00 00       	jmp    d1f <printf+0x196>
      }
    } else if(state == '%'){
 bf2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 bf6:	0f 85 23 01 00 00    	jne    d1f <printf+0x196>
      if(c == 'd'){
 bfc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 c00:	75 2d                	jne    c2f <printf+0xa6>
        printint(fd, *ap, 10, 1);
 c02:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c05:	8b 00                	mov    (%eax),%eax
 c07:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 c0e:	00 
 c0f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 c16:	00 
 c17:	89 44 24 04          	mov    %eax,0x4(%esp)
 c1b:	8b 45 08             	mov    0x8(%ebp),%eax
 c1e:	89 04 24             	mov    %eax,(%esp)
 c21:	e8 ae fe ff ff       	call   ad4 <printint>
        ap++;
 c26:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c2a:	e9 e9 00 00 00       	jmp    d18 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 c2f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 c33:	74 06                	je     c3b <printf+0xb2>
 c35:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 c39:	75 2d                	jne    c68 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 c3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c3e:	8b 00                	mov    (%eax),%eax
 c40:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 c47:	00 
 c48:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 c4f:	00 
 c50:	89 44 24 04          	mov    %eax,0x4(%esp)
 c54:	8b 45 08             	mov    0x8(%ebp),%eax
 c57:	89 04 24             	mov    %eax,(%esp)
 c5a:	e8 75 fe ff ff       	call   ad4 <printint>
        ap++;
 c5f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c63:	e9 b0 00 00 00       	jmp    d18 <printf+0x18f>
      } else if(c == 's'){
 c68:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 c6c:	75 42                	jne    cb0 <printf+0x127>
        s = (char*)*ap;
 c6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c71:	8b 00                	mov    (%eax),%eax
 c73:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c76:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c7e:	75 09                	jne    c89 <printf+0x100>
          s = "(null)";
 c80:	c7 45 f4 be 0f 00 00 	movl   $0xfbe,-0xc(%ebp)
        while(*s != 0){
 c87:	eb 1c                	jmp    ca5 <printf+0x11c>
 c89:	eb 1a                	jmp    ca5 <printf+0x11c>
          putc(fd, *s);
 c8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c8e:	8a 00                	mov    (%eax),%al
 c90:	0f be c0             	movsbl %al,%eax
 c93:	89 44 24 04          	mov    %eax,0x4(%esp)
 c97:	8b 45 08             	mov    0x8(%ebp),%eax
 c9a:	89 04 24             	mov    %eax,(%esp)
 c9d:	e8 0a fe ff ff       	call   aac <putc>
          s++;
 ca2:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca8:	8a 00                	mov    (%eax),%al
 caa:	84 c0                	test   %al,%al
 cac:	75 dd                	jne    c8b <printf+0x102>
 cae:	eb 68                	jmp    d18 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 cb0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 cb4:	75 1d                	jne    cd3 <printf+0x14a>
        putc(fd, *ap);
 cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 cb9:	8b 00                	mov    (%eax),%eax
 cbb:	0f be c0             	movsbl %al,%eax
 cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
 cc2:	8b 45 08             	mov    0x8(%ebp),%eax
 cc5:	89 04 24             	mov    %eax,(%esp)
 cc8:	e8 df fd ff ff       	call   aac <putc>
        ap++;
 ccd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 cd1:	eb 45                	jmp    d18 <printf+0x18f>
      } else if(c == '%'){
 cd3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 cd7:	75 17                	jne    cf0 <printf+0x167>
        putc(fd, c);
 cd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 cdc:	0f be c0             	movsbl %al,%eax
 cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
 ce3:	8b 45 08             	mov    0x8(%ebp),%eax
 ce6:	89 04 24             	mov    %eax,(%esp)
 ce9:	e8 be fd ff ff       	call   aac <putc>
 cee:	eb 28                	jmp    d18 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 cf0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 cf7:	00 
 cf8:	8b 45 08             	mov    0x8(%ebp),%eax
 cfb:	89 04 24             	mov    %eax,(%esp)
 cfe:	e8 a9 fd ff ff       	call   aac <putc>
        putc(fd, c);
 d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 d06:	0f be c0             	movsbl %al,%eax
 d09:	89 44 24 04          	mov    %eax,0x4(%esp)
 d0d:	8b 45 08             	mov    0x8(%ebp),%eax
 d10:	89 04 24             	mov    %eax,(%esp)
 d13:	e8 94 fd ff ff       	call   aac <putc>
      }
      state = 0;
 d18:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 d1f:	ff 45 f0             	incl   -0x10(%ebp)
 d22:	8b 55 0c             	mov    0xc(%ebp),%edx
 d25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d28:	01 d0                	add    %edx,%eax
 d2a:	8a 00                	mov    (%eax),%al
 d2c:	84 c0                	test   %al,%al
 d2e:	0f 85 77 fe ff ff    	jne    bab <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 d34:	c9                   	leave  
 d35:	c3                   	ret    
 d36:	90                   	nop
 d37:	90                   	nop

00000d38 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d38:	55                   	push   %ebp
 d39:	89 e5                	mov    %esp,%ebp
 d3b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d3e:	8b 45 08             	mov    0x8(%ebp),%eax
 d41:	83 e8 08             	sub    $0x8,%eax
 d44:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d47:	a1 f0 13 00 00       	mov    0x13f0,%eax
 d4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d4f:	eb 24                	jmp    d75 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d54:	8b 00                	mov    (%eax),%eax
 d56:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d59:	77 12                	ja     d6d <free+0x35>
 d5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d5e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d61:	77 24                	ja     d87 <free+0x4f>
 d63:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d66:	8b 00                	mov    (%eax),%eax
 d68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d6b:	77 1a                	ja     d87 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d70:	8b 00                	mov    (%eax),%eax
 d72:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d75:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d78:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d7b:	76 d4                	jbe    d51 <free+0x19>
 d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d80:	8b 00                	mov    (%eax),%eax
 d82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d85:	76 ca                	jbe    d51 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 d87:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d8a:	8b 40 04             	mov    0x4(%eax),%eax
 d8d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d94:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d97:	01 c2                	add    %eax,%edx
 d99:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d9c:	8b 00                	mov    (%eax),%eax
 d9e:	39 c2                	cmp    %eax,%edx
 da0:	75 24                	jne    dc6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 da2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 da5:	8b 50 04             	mov    0x4(%eax),%edx
 da8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dab:	8b 00                	mov    (%eax),%eax
 dad:	8b 40 04             	mov    0x4(%eax),%eax
 db0:	01 c2                	add    %eax,%edx
 db2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 db5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 db8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dbb:	8b 00                	mov    (%eax),%eax
 dbd:	8b 10                	mov    (%eax),%edx
 dbf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dc2:	89 10                	mov    %edx,(%eax)
 dc4:	eb 0a                	jmp    dd0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dc9:	8b 10                	mov    (%eax),%edx
 dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dce:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dd3:	8b 40 04             	mov    0x4(%eax),%eax
 dd6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ddd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 de0:	01 d0                	add    %edx,%eax
 de2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 de5:	75 20                	jne    e07 <free+0xcf>
    p->s.size += bp->s.size;
 de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dea:	8b 50 04             	mov    0x4(%eax),%edx
 ded:	8b 45 f8             	mov    -0x8(%ebp),%eax
 df0:	8b 40 04             	mov    0x4(%eax),%eax
 df3:	01 c2                	add    %eax,%edx
 df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 df8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 dfb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dfe:	8b 10                	mov    (%eax),%edx
 e00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e03:	89 10                	mov    %edx,(%eax)
 e05:	eb 08                	jmp    e0f <free+0xd7>
  } else
    p->s.ptr = bp;
 e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 e0d:	89 10                	mov    %edx,(%eax)
  freep = p;
 e0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e12:	a3 f0 13 00 00       	mov    %eax,0x13f0
}
 e17:	c9                   	leave  
 e18:	c3                   	ret    

00000e19 <morecore>:

static Header*
morecore(uint nu)
{
 e19:	55                   	push   %ebp
 e1a:	89 e5                	mov    %esp,%ebp
 e1c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 e1f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 e26:	77 07                	ja     e2f <morecore+0x16>
    nu = 4096;
 e28:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 e2f:	8b 45 08             	mov    0x8(%ebp),%eax
 e32:	c1 e0 03             	shl    $0x3,%eax
 e35:	89 04 24             	mov    %eax,(%esp)
 e38:	e8 cf fb ff ff       	call   a0c <sbrk>
 e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 e40:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 e44:	75 07                	jne    e4d <morecore+0x34>
    return 0;
 e46:	b8 00 00 00 00       	mov    $0x0,%eax
 e4b:	eb 22                	jmp    e6f <morecore+0x56>
  hp = (Header*)p;
 e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 e53:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e56:	8b 55 08             	mov    0x8(%ebp),%edx
 e59:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 e5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e5f:	83 c0 08             	add    $0x8,%eax
 e62:	89 04 24             	mov    %eax,(%esp)
 e65:	e8 ce fe ff ff       	call   d38 <free>
  return freep;
 e6a:	a1 f0 13 00 00       	mov    0x13f0,%eax
}
 e6f:	c9                   	leave  
 e70:	c3                   	ret    

00000e71 <malloc>:

void*
malloc(uint nbytes)
{
 e71:	55                   	push   %ebp
 e72:	89 e5                	mov    %esp,%ebp
 e74:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e77:	8b 45 08             	mov    0x8(%ebp),%eax
 e7a:	83 c0 07             	add    $0x7,%eax
 e7d:	c1 e8 03             	shr    $0x3,%eax
 e80:	40                   	inc    %eax
 e81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e84:	a1 f0 13 00 00       	mov    0x13f0,%eax
 e89:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e90:	75 23                	jne    eb5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 e92:	c7 45 f0 e8 13 00 00 	movl   $0x13e8,-0x10(%ebp)
 e99:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e9c:	a3 f0 13 00 00       	mov    %eax,0x13f0
 ea1:	a1 f0 13 00 00       	mov    0x13f0,%eax
 ea6:	a3 e8 13 00 00       	mov    %eax,0x13e8
    base.s.size = 0;
 eab:	c7 05 ec 13 00 00 00 	movl   $0x0,0x13ec
 eb2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eb8:	8b 00                	mov    (%eax),%eax
 eba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec0:	8b 40 04             	mov    0x4(%eax),%eax
 ec3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ec6:	72 4d                	jb     f15 <malloc+0xa4>
      if(p->s.size == nunits)
 ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ecb:	8b 40 04             	mov    0x4(%eax),%eax
 ece:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ed1:	75 0c                	jne    edf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ed6:	8b 10                	mov    (%eax),%edx
 ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 edb:	89 10                	mov    %edx,(%eax)
 edd:	eb 26                	jmp    f05 <malloc+0x94>
      else {
        p->s.size -= nunits;
 edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ee2:	8b 40 04             	mov    0x4(%eax),%eax
 ee5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ee8:	89 c2                	mov    %eax,%edx
 eea:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eed:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ef0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ef3:	8b 40 04             	mov    0x4(%eax),%eax
 ef6:	c1 e0 03             	shl    $0x3,%eax
 ef9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eff:	8b 55 ec             	mov    -0x14(%ebp),%edx
 f02:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f08:	a3 f0 13 00 00       	mov    %eax,0x13f0
      return (void*)(p + 1);
 f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f10:	83 c0 08             	add    $0x8,%eax
 f13:	eb 38                	jmp    f4d <malloc+0xdc>
    }
    if(p == freep)
 f15:	a1 f0 13 00 00       	mov    0x13f0,%eax
 f1a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 f1d:	75 1b                	jne    f3a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 f22:	89 04 24             	mov    %eax,(%esp)
 f25:	e8 ef fe ff ff       	call   e19 <morecore>
 f2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 f2d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 f31:	75 07                	jne    f3a <malloc+0xc9>
        return 0;
 f33:	b8 00 00 00 00       	mov    $0x0,%eax
 f38:	eb 13                	jmp    f4d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f43:	8b 00                	mov    (%eax),%eax
 f45:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 f48:	e9 70 ff ff ff       	jmp    ebd <malloc+0x4c>
}
 f4d:	c9                   	leave  
 f4e:	c3                   	ret    
