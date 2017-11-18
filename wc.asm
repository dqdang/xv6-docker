
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
  31:	05 20 12 00 00       	add    $0x1220,%eax
  36:	8a 00                	mov    (%eax),%al
  38:	3c 0a                	cmp    $0xa,%al
  3a:	75 03                	jne    3f <wc+0x3f>
        l++;
  3c:	ff 45 f0             	incl   -0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  42:	05 20 12 00 00       	add    $0x1220,%eax
  47:	8a 00                	mov    (%eax),%al
  49:	0f be c0             	movsbl %al,%eax
  4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  50:	c7 04 24 c7 0d 00 00 	movl   $0xdc7,(%esp)
  57:	e8 9a 02 00 00       	call   2f6 <strchr>
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
  8c:	c7 44 24 04 20 12 00 	movl   $0x1220,0x4(%esp)
  93:	00 
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	89 04 24             	mov    %eax,(%esp)
  9a:	e8 fd 07 00 00       	call   89c <read>
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
  b2:	c7 44 24 04 cd 0d 00 	movl   $0xdcd,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 3b 09 00 00       	call   a01 <printf>
    exit();
  c6:	e8 b9 07 00 00       	call   884 <exit>
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
  e7:	c7 44 24 04 dd 0d 00 	movl   $0xddd,0x4(%esp)
  ee:	00 
  ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f6:	e8 06 09 00 00       	call   a01 <printf>
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
 10c:	c7 44 24 04 ea 0d 00 	movl   $0xdea,0x4(%esp)
 113:	00 
 114:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11b:	e8 e0 fe ff ff       	call   0 <wc>
    exit();
 120:	e8 5f 07 00 00       	call   884 <exit>
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
 14f:	e8 70 07 00 00       	call   8c4 <open>
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
 175:	c7 44 24 04 eb 0d 00 	movl   $0xdeb,0x4(%esp)
 17c:	00 
 17d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 184:	e8 78 08 00 00       	call   a01 <printf>
      exit();
 189:	e8 f6 06 00 00       	call   884 <exit>
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
 1b7:	e8 f0 06 00 00       	call   8ac <close>
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
 1cd:	e8 b2 06 00 00       	call   884 <exit>
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

00000227 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 227:	55                   	push   %ebp
 228:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 22a:	eb 06                	jmp    232 <strcmp+0xb>
    p++, q++;
 22c:	ff 45 08             	incl   0x8(%ebp)
 22f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	8a 00                	mov    (%eax),%al
 237:	84 c0                	test   %al,%al
 239:	74 0e                	je     249 <strcmp+0x22>
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	8a 10                	mov    (%eax),%dl
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	8a 00                	mov    (%eax),%al
 245:	38 c2                	cmp    %al,%dl
 247:	74 e3                	je     22c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
 24c:	8a 00                	mov    (%eax),%al
 24e:	0f b6 d0             	movzbl %al,%edx
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	8a 00                	mov    (%eax),%al
 256:	0f b6 c0             	movzbl %al,%eax
 259:	29 c2                	sub    %eax,%edx
 25b:	89 d0                	mov    %edx,%eax
}
 25d:	5d                   	pop    %ebp
 25e:	c3                   	ret    

0000025f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 25f:	55                   	push   %ebp
 260:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 262:	eb 09                	jmp    26d <strncmp+0xe>
    n--, p++, q++;
 264:	ff 4d 10             	decl   0x10(%ebp)
 267:	ff 45 08             	incl   0x8(%ebp)
 26a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 26d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 271:	74 17                	je     28a <strncmp+0x2b>
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	8a 00                	mov    (%eax),%al
 278:	84 c0                	test   %al,%al
 27a:	74 0e                	je     28a <strncmp+0x2b>
 27c:	8b 45 08             	mov    0x8(%ebp),%eax
 27f:	8a 10                	mov    (%eax),%dl
 281:	8b 45 0c             	mov    0xc(%ebp),%eax
 284:	8a 00                	mov    (%eax),%al
 286:	38 c2                	cmp    %al,%dl
 288:	74 da                	je     264 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 28a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 28e:	75 07                	jne    297 <strncmp+0x38>
    return 0;
 290:	b8 00 00 00 00       	mov    $0x0,%eax
 295:	eb 14                	jmp    2ab <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	8a 00                	mov    (%eax),%al
 29c:	0f b6 d0             	movzbl %al,%edx
 29f:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a2:	8a 00                	mov    (%eax),%al
 2a4:	0f b6 c0             	movzbl %al,%eax
 2a7:	29 c2                	sub    %eax,%edx
 2a9:	89 d0                	mov    %edx,%eax
}
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    

000002ad <strlen>:

uint
strlen(const char *s)
{
 2ad:	55                   	push   %ebp
 2ae:	89 e5                	mov    %esp,%ebp
 2b0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 2b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2ba:	eb 03                	jmp    2bf <strlen+0x12>
 2bc:	ff 45 fc             	incl   -0x4(%ebp)
 2bf:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	01 d0                	add    %edx,%eax
 2c7:	8a 00                	mov    (%eax),%al
 2c9:	84 c0                	test   %al,%al
 2cb:	75 ef                	jne    2bc <strlen+0xf>
    ;
  return n;
 2cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2d8:	8b 45 10             	mov    0x10(%ebp),%eax
 2db:	89 44 24 08          	mov    %eax,0x8(%esp)
 2df:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	89 04 24             	mov    %eax,(%esp)
 2ec:	e8 e3 fe ff ff       	call   1d4 <stosb>
  return dst;
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <strchr>:

char*
strchr(const char *s, char c)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 04             	sub    $0x4,%esp
 2fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ff:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 302:	eb 12                	jmp    316 <strchr+0x20>
    if(*s == c)
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	8a 00                	mov    (%eax),%al
 309:	3a 45 fc             	cmp    -0x4(%ebp),%al
 30c:	75 05                	jne    313 <strchr+0x1d>
      return (char*)s;
 30e:	8b 45 08             	mov    0x8(%ebp),%eax
 311:	eb 11                	jmp    324 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 313:	ff 45 08             	incl   0x8(%ebp)
 316:	8b 45 08             	mov    0x8(%ebp),%eax
 319:	8a 00                	mov    (%eax),%al
 31b:	84 c0                	test   %al,%al
 31d:	75 e5                	jne    304 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 31f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 324:	c9                   	leave  
 325:	c3                   	ret    

00000326 <strcat>:

char *
strcat(char *dest, const char *src)
{
 326:	55                   	push   %ebp
 327:	89 e5                	mov    %esp,%ebp
 329:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 32c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 333:	eb 03                	jmp    338 <strcat+0x12>
 335:	ff 45 fc             	incl   -0x4(%ebp)
 338:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	01 d0                	add    %edx,%eax
 340:	8a 00                	mov    (%eax),%al
 342:	84 c0                	test   %al,%al
 344:	75 ef                	jne    335 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 346:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 34d:	eb 1e                	jmp    36d <strcat+0x47>
        dest[i+j] = src[j];
 34f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 352:	8b 55 fc             	mov    -0x4(%ebp),%edx
 355:	01 d0                	add    %edx,%eax
 357:	89 c2                	mov    %eax,%edx
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	01 c2                	add    %eax,%edx
 35e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 361:	8b 45 0c             	mov    0xc(%ebp),%eax
 364:	01 c8                	add    %ecx,%eax
 366:	8a 00                	mov    (%eax),%al
 368:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 36a:	ff 45 f8             	incl   -0x8(%ebp)
 36d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	01 d0                	add    %edx,%eax
 375:	8a 00                	mov    (%eax),%al
 377:	84 c0                	test   %al,%al
 379:	75 d4                	jne    34f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 37b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 37e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 381:	01 d0                	add    %edx,%eax
 383:	89 c2                	mov    %eax,%edx
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	01 d0                	add    %edx,%eax
 38a:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 390:	c9                   	leave  
 391:	c3                   	ret    

00000392 <strstr>:

int 
strstr(char* s, char* sub)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 398:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 39f:	eb 7c                	jmp    41d <strstr+0x8b>
    {
        if(s[i] == sub[0])
 3a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a4:	8b 45 08             	mov    0x8(%ebp),%eax
 3a7:	01 d0                	add    %edx,%eax
 3a9:	8a 10                	mov    (%eax),%dl
 3ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ae:	8a 00                	mov    (%eax),%al
 3b0:	38 c2                	cmp    %al,%dl
 3b2:	75 66                	jne    41a <strstr+0x88>
        {
            if(strlen(sub) == 1)
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	89 04 24             	mov    %eax,(%esp)
 3ba:	e8 ee fe ff ff       	call   2ad <strlen>
 3bf:	83 f8 01             	cmp    $0x1,%eax
 3c2:	75 05                	jne    3c9 <strstr+0x37>
            {  
                return i;
 3c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c7:	eb 6b                	jmp    434 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 3c9:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 3d0:	eb 3a                	jmp    40c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 3d2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3d8:	01 d0                	add    %edx,%eax
 3da:	89 c2                	mov    %eax,%edx
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	01 d0                	add    %edx,%eax
 3e1:	8a 10                	mov    (%eax),%dl
 3e3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e9:	01 c8                	add    %ecx,%eax
 3eb:	8a 00                	mov    (%eax),%al
 3ed:	38 c2                	cmp    %al,%dl
 3ef:	75 16                	jne    407 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 3f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3f4:	8d 50 01             	lea    0x1(%eax),%edx
 3f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fa:	01 d0                	add    %edx,%eax
 3fc:	8a 00                	mov    (%eax),%al
 3fe:	84 c0                	test   %al,%al
 400:	75 07                	jne    409 <strstr+0x77>
                    {
                        return i;
 402:	8b 45 fc             	mov    -0x4(%ebp),%eax
 405:	eb 2d                	jmp    434 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 407:	eb 11                	jmp    41a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 409:	ff 45 f8             	incl   -0x8(%ebp)
 40c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 40f:	8b 45 0c             	mov    0xc(%ebp),%eax
 412:	01 d0                	add    %edx,%eax
 414:	8a 00                	mov    (%eax),%al
 416:	84 c0                	test   %al,%al
 418:	75 b8                	jne    3d2 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 41a:	ff 45 fc             	incl   -0x4(%ebp)
 41d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	01 d0                	add    %edx,%eax
 425:	8a 00                	mov    (%eax),%al
 427:	84 c0                	test   %al,%al
 429:	0f 85 72 ff ff ff    	jne    3a1 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 42f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 434:	c9                   	leave  
 435:	c3                   	ret    

00000436 <strtok>:

char *
strtok(char *s, const char *delim)
{
 436:	55                   	push   %ebp
 437:	89 e5                	mov    %esp,%ebp
 439:	53                   	push   %ebx
 43a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 43d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 441:	75 08                	jne    44b <strtok+0x15>
  s = lasts;
 443:	a1 04 12 00 00       	mov    0x1204,%eax
 448:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	8d 50 01             	lea    0x1(%eax),%edx
 451:	89 55 08             	mov    %edx,0x8(%ebp)
 454:	8a 00                	mov    (%eax),%al
 456:	0f be d8             	movsbl %al,%ebx
 459:	85 db                	test   %ebx,%ebx
 45b:	75 07                	jne    464 <strtok+0x2e>
      return 0;
 45d:	b8 00 00 00 00       	mov    $0x0,%eax
 462:	eb 58                	jmp    4bc <strtok+0x86>
    } while (strchr(delim, ch));
 464:	88 d8                	mov    %bl,%al
 466:	0f be c0             	movsbl %al,%eax
 469:	89 44 24 04          	mov    %eax,0x4(%esp)
 46d:	8b 45 0c             	mov    0xc(%ebp),%eax
 470:	89 04 24             	mov    %eax,(%esp)
 473:	e8 7e fe ff ff       	call   2f6 <strchr>
 478:	85 c0                	test   %eax,%eax
 47a:	75 cf                	jne    44b <strtok+0x15>
    --s;
 47c:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 47f:	8b 45 0c             	mov    0xc(%ebp),%eax
 482:	89 44 24 04          	mov    %eax,0x4(%esp)
 486:	8b 45 08             	mov    0x8(%ebp),%eax
 489:	89 04 24             	mov    %eax,(%esp)
 48c:	e8 31 00 00 00       	call   4c2 <strcspn>
 491:	89 c2                	mov    %eax,%edx
 493:	8b 45 08             	mov    0x8(%ebp),%eax
 496:	01 d0                	add    %edx,%eax
 498:	a3 04 12 00 00       	mov    %eax,0x1204
    if (*lasts != 0)
 49d:	a1 04 12 00 00       	mov    0x1204,%eax
 4a2:	8a 00                	mov    (%eax),%al
 4a4:	84 c0                	test   %al,%al
 4a6:	74 11                	je     4b9 <strtok+0x83>
  *lasts++ = 0;
 4a8:	a1 04 12 00 00       	mov    0x1204,%eax
 4ad:	8d 50 01             	lea    0x1(%eax),%edx
 4b0:	89 15 04 12 00 00    	mov    %edx,0x1204
 4b6:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 4b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4bc:	83 c4 14             	add    $0x14,%esp
 4bf:	5b                   	pop    %ebx
 4c0:	5d                   	pop    %ebp
 4c1:	c3                   	ret    

000004c2 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 4c2:	55                   	push   %ebp
 4c3:	89 e5                	mov    %esp,%ebp
 4c5:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 4c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 4cf:	eb 26                	jmp    4f7 <strcspn+0x35>
        if(strchr(s2,*s1))
 4d1:	8b 45 08             	mov    0x8(%ebp),%eax
 4d4:	8a 00                	mov    (%eax),%al
 4d6:	0f be c0             	movsbl %al,%eax
 4d9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e0:	89 04 24             	mov    %eax,(%esp)
 4e3:	e8 0e fe ff ff       	call   2f6 <strchr>
 4e8:	85 c0                	test   %eax,%eax
 4ea:	74 05                	je     4f1 <strcspn+0x2f>
            return ret;
 4ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4ef:	eb 12                	jmp    503 <strcspn+0x41>
        else
            s1++,ret++;
 4f1:	ff 45 08             	incl   0x8(%ebp)
 4f4:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4f7:	8b 45 08             	mov    0x8(%ebp),%eax
 4fa:	8a 00                	mov    (%eax),%al
 4fc:	84 c0                	test   %al,%al
 4fe:	75 d1                	jne    4d1 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 500:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 503:	c9                   	leave  
 504:	c3                   	ret    

00000505 <isspace>:

int
isspace(unsigned char c)
{
 505:	55                   	push   %ebp
 506:	89 e5                	mov    %esp,%ebp
 508:	83 ec 04             	sub    $0x4,%esp
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 511:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 515:	74 1e                	je     535 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 517:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 51b:	74 18                	je     535 <isspace+0x30>
 51d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 521:	74 12                	je     535 <isspace+0x30>
 523:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 527:	74 0c                	je     535 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 529:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 52d:	74 06                	je     535 <isspace+0x30>
 52f:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 533:	75 07                	jne    53c <isspace+0x37>
 535:	b8 01 00 00 00       	mov    $0x1,%eax
 53a:	eb 05                	jmp    541 <isspace+0x3c>
 53c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 541:	c9                   	leave  
 542:	c3                   	ret    

00000543 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 543:	55                   	push   %ebp
 544:	89 e5                	mov    %esp,%ebp
 546:	57                   	push   %edi
 547:	56                   	push   %esi
 548:	53                   	push   %ebx
 549:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 54c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 551:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 558:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 55b:	eb 01                	jmp    55e <strtoul+0x1b>
  p += 1;
 55d:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 55e:	8a 03                	mov    (%ebx),%al
 560:	0f b6 c0             	movzbl %al,%eax
 563:	89 04 24             	mov    %eax,(%esp)
 566:	e8 9a ff ff ff       	call   505 <isspace>
 56b:	85 c0                	test   %eax,%eax
 56d:	75 ee                	jne    55d <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 56f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 573:	75 30                	jne    5a5 <strtoul+0x62>
    {
  if (*p == '0') {
 575:	8a 03                	mov    (%ebx),%al
 577:	3c 30                	cmp    $0x30,%al
 579:	75 21                	jne    59c <strtoul+0x59>
      p += 1;
 57b:	43                   	inc    %ebx
      if (*p == 'x') {
 57c:	8a 03                	mov    (%ebx),%al
 57e:	3c 78                	cmp    $0x78,%al
 580:	75 0a                	jne    58c <strtoul+0x49>
    p += 1;
 582:	43                   	inc    %ebx
    base = 16;
 583:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 58a:	eb 31                	jmp    5bd <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 58c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 593:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 59a:	eb 21                	jmp    5bd <strtoul+0x7a>
      }
  }
  else base = 10;
 59c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 5a3:	eb 18                	jmp    5bd <strtoul+0x7a>
    } else if (base == 16) {
 5a5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5a9:	75 12                	jne    5bd <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 5ab:	8a 03                	mov    (%ebx),%al
 5ad:	3c 30                	cmp    $0x30,%al
 5af:	75 0c                	jne    5bd <strtoul+0x7a>
 5b1:	8d 43 01             	lea    0x1(%ebx),%eax
 5b4:	8a 00                	mov    (%eax),%al
 5b6:	3c 78                	cmp    $0x78,%al
 5b8:	75 03                	jne    5bd <strtoul+0x7a>
      p += 2;
 5ba:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 5bd:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 5c1:	75 29                	jne    5ec <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5c3:	8a 03                	mov    (%ebx),%al
 5c5:	0f be c0             	movsbl %al,%eax
 5c8:	83 e8 30             	sub    $0x30,%eax
 5cb:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 5cd:	83 fe 07             	cmp    $0x7,%esi
 5d0:	76 06                	jbe    5d8 <strtoul+0x95>
    break;
 5d2:	90                   	nop
 5d3:	e9 b6 00 00 00       	jmp    68e <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 5d8:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 5df:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5e2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 5e9:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 5ea:	eb d7                	jmp    5c3 <strtoul+0x80>
    } else if (base == 10) {
 5ec:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 5f0:	75 2b                	jne    61d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5f2:	8a 03                	mov    (%ebx),%al
 5f4:	0f be c0             	movsbl %al,%eax
 5f7:	83 e8 30             	sub    $0x30,%eax
 5fa:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5fc:	83 fe 09             	cmp    $0x9,%esi
 5ff:	76 06                	jbe    607 <strtoul+0xc4>
    break;
 601:	90                   	nop
 602:	e9 87 00 00 00       	jmp    68e <strtoul+0x14b>
      }
      result = (10*result) + digit;
 607:	89 f8                	mov    %edi,%eax
 609:	c1 e0 02             	shl    $0x2,%eax
 60c:	01 f8                	add    %edi,%eax
 60e:	01 c0                	add    %eax,%eax
 610:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 613:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 61a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 61b:	eb d5                	jmp    5f2 <strtoul+0xaf>
    } else if (base == 16) {
 61d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 621:	75 35                	jne    658 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 623:	8a 03                	mov    (%ebx),%al
 625:	0f be c0             	movsbl %al,%eax
 628:	83 e8 30             	sub    $0x30,%eax
 62b:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 62d:	83 fe 4a             	cmp    $0x4a,%esi
 630:	76 02                	jbe    634 <strtoul+0xf1>
    break;
 632:	eb 22                	jmp    656 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 634:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 63a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 63d:	83 fe 0f             	cmp    $0xf,%esi
 640:	76 02                	jbe    644 <strtoul+0x101>
    break;
 642:	eb 12                	jmp    656 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 644:	89 f8                	mov    %edi,%eax
 646:	c1 e0 04             	shl    $0x4,%eax
 649:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 64c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 653:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 654:	eb cd                	jmp    623 <strtoul+0xe0>
 656:	eb 36                	jmp    68e <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 658:	8a 03                	mov    (%ebx),%al
 65a:	0f be c0             	movsbl %al,%eax
 65d:	83 e8 30             	sub    $0x30,%eax
 660:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 662:	83 fe 4a             	cmp    $0x4a,%esi
 665:	76 02                	jbe    669 <strtoul+0x126>
    break;
 667:	eb 25                	jmp    68e <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 669:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 66f:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 672:	8b 45 10             	mov    0x10(%ebp),%eax
 675:	39 f0                	cmp    %esi,%eax
 677:	77 02                	ja     67b <strtoul+0x138>
    break;
 679:	eb 13                	jmp    68e <strtoul+0x14b>
      }
      result = result*base + digit;
 67b:	8b 45 10             	mov    0x10(%ebp),%eax
 67e:	0f af c7             	imul   %edi,%eax
 681:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 684:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 68b:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 68c:	eb ca                	jmp    658 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 68e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 692:	75 03                	jne    697 <strtoul+0x154>
  p = string;
 694:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 697:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 69b:	74 05                	je     6a2 <strtoul+0x15f>
  *endPtr = p;
 69d:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a0:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 6a2:	89 f8                	mov    %edi,%eax
}
 6a4:	83 c4 14             	add    $0x14,%esp
 6a7:	5b                   	pop    %ebx
 6a8:	5e                   	pop    %esi
 6a9:	5f                   	pop    %edi
 6aa:	5d                   	pop    %ebp
 6ab:	c3                   	ret    

000006ac <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 6ac:	55                   	push   %ebp
 6ad:	89 e5                	mov    %esp,%ebp
 6af:	53                   	push   %ebx
 6b0:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 6b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 6b6:	eb 01                	jmp    6b9 <strtol+0xd>
      p += 1;
 6b8:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 6b9:	8a 03                	mov    (%ebx),%al
 6bb:	0f b6 c0             	movzbl %al,%eax
 6be:	89 04 24             	mov    %eax,(%esp)
 6c1:	e8 3f fe ff ff       	call   505 <isspace>
 6c6:	85 c0                	test   %eax,%eax
 6c8:	75 ee                	jne    6b8 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 6ca:	8a 03                	mov    (%ebx),%al
 6cc:	3c 2d                	cmp    $0x2d,%al
 6ce:	75 1e                	jne    6ee <strtol+0x42>
  p += 1;
 6d0:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 6d1:	8b 45 10             	mov    0x10(%ebp),%eax
 6d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 6d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6db:	89 44 24 04          	mov    %eax,0x4(%esp)
 6df:	89 1c 24             	mov    %ebx,(%esp)
 6e2:	e8 5c fe ff ff       	call   543 <strtoul>
 6e7:	f7 d8                	neg    %eax
 6e9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6ec:	eb 20                	jmp    70e <strtol+0x62>
    } else {
  if (*p == '+') {
 6ee:	8a 03                	mov    (%ebx),%al
 6f0:	3c 2b                	cmp    $0x2b,%al
 6f2:	75 01                	jne    6f5 <strtol+0x49>
      p += 1;
 6f4:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6f5:	8b 45 10             	mov    0x10(%ebp),%eax
 6f8:	89 44 24 08          	mov    %eax,0x8(%esp)
 6fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 703:	89 1c 24             	mov    %ebx,(%esp)
 706:	e8 38 fe ff ff       	call   543 <strtoul>
 70b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 70e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 712:	75 17                	jne    72b <strtol+0x7f>
 714:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 718:	74 11                	je     72b <strtol+0x7f>
 71a:	8b 45 0c             	mov    0xc(%ebp),%eax
 71d:	8b 00                	mov    (%eax),%eax
 71f:	39 d8                	cmp    %ebx,%eax
 721:	75 08                	jne    72b <strtol+0x7f>
  *endPtr = string;
 723:	8b 45 0c             	mov    0xc(%ebp),%eax
 726:	8b 55 08             	mov    0x8(%ebp),%edx
 729:	89 10                	mov    %edx,(%eax)
    }
    return result;
 72b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 72e:	83 c4 1c             	add    $0x1c,%esp
 731:	5b                   	pop    %ebx
 732:	5d                   	pop    %ebp
 733:	c3                   	ret    

00000734 <gets>:

char*
gets(char *buf, int max)
{
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 73a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 741:	eb 49                	jmp    78c <gets+0x58>
    cc = read(0, &c, 1);
 743:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 74a:	00 
 74b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 74e:	89 44 24 04          	mov    %eax,0x4(%esp)
 752:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 759:	e8 3e 01 00 00       	call   89c <read>
 75e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 761:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 765:	7f 02                	jg     769 <gets+0x35>
      break;
 767:	eb 2c                	jmp    795 <gets+0x61>
    buf[i++] = c;
 769:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76c:	8d 50 01             	lea    0x1(%eax),%edx
 76f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 772:	89 c2                	mov    %eax,%edx
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	01 c2                	add    %eax,%edx
 779:	8a 45 ef             	mov    -0x11(%ebp),%al
 77c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 77e:	8a 45 ef             	mov    -0x11(%ebp),%al
 781:	3c 0a                	cmp    $0xa,%al
 783:	74 10                	je     795 <gets+0x61>
 785:	8a 45 ef             	mov    -0x11(%ebp),%al
 788:	3c 0d                	cmp    $0xd,%al
 78a:	74 09                	je     795 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78f:	40                   	inc    %eax
 790:	3b 45 0c             	cmp    0xc(%ebp),%eax
 793:	7c ae                	jl     743 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 795:	8b 55 f4             	mov    -0xc(%ebp),%edx
 798:	8b 45 08             	mov    0x8(%ebp),%eax
 79b:	01 d0                	add    %edx,%eax
 79d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 7a0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <stat>:

int
stat(char *n, struct stat *st)
{
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 7b2:	00 
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	89 04 24             	mov    %eax,(%esp)
 7b9:	e8 06 01 00 00       	call   8c4 <open>
 7be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 7c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7c5:	79 07                	jns    7ce <stat+0x29>
    return -1;
 7c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7cc:	eb 23                	jmp    7f1 <stat+0x4c>
  r = fstat(fd, st);
 7ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 fc 00 00 00       	call   8dc <fstat>
 7e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e6:	89 04 24             	mov    %eax,(%esp)
 7e9:	e8 be 00 00 00       	call   8ac <close>
  return r;
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7f1:	c9                   	leave  
 7f2:	c3                   	ret    

000007f3 <atoi>:

int
atoi(const char *s)
{
 7f3:	55                   	push   %ebp
 7f4:	89 e5                	mov    %esp,%ebp
 7f6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 800:	eb 24                	jmp    826 <atoi+0x33>
    n = n*10 + *s++ - '0';
 802:	8b 55 fc             	mov    -0x4(%ebp),%edx
 805:	89 d0                	mov    %edx,%eax
 807:	c1 e0 02             	shl    $0x2,%eax
 80a:	01 d0                	add    %edx,%eax
 80c:	01 c0                	add    %eax,%eax
 80e:	89 c1                	mov    %eax,%ecx
 810:	8b 45 08             	mov    0x8(%ebp),%eax
 813:	8d 50 01             	lea    0x1(%eax),%edx
 816:	89 55 08             	mov    %edx,0x8(%ebp)
 819:	8a 00                	mov    (%eax),%al
 81b:	0f be c0             	movsbl %al,%eax
 81e:	01 c8                	add    %ecx,%eax
 820:	83 e8 30             	sub    $0x30,%eax
 823:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 826:	8b 45 08             	mov    0x8(%ebp),%eax
 829:	8a 00                	mov    (%eax),%al
 82b:	3c 2f                	cmp    $0x2f,%al
 82d:	7e 09                	jle    838 <atoi+0x45>
 82f:	8b 45 08             	mov    0x8(%ebp),%eax
 832:	8a 00                	mov    (%eax),%al
 834:	3c 39                	cmp    $0x39,%al
 836:	7e ca                	jle    802 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 83b:	c9                   	leave  
 83c:	c3                   	ret    

0000083d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 83d:	55                   	push   %ebp
 83e:	89 e5                	mov    %esp,%ebp
 840:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 843:	8b 45 08             	mov    0x8(%ebp),%eax
 846:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 849:	8b 45 0c             	mov    0xc(%ebp),%eax
 84c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 84f:	eb 16                	jmp    867 <memmove+0x2a>
    *dst++ = *src++;
 851:	8b 45 fc             	mov    -0x4(%ebp),%eax
 854:	8d 50 01             	lea    0x1(%eax),%edx
 857:	89 55 fc             	mov    %edx,-0x4(%ebp)
 85a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 85d:	8d 4a 01             	lea    0x1(%edx),%ecx
 860:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 863:	8a 12                	mov    (%edx),%dl
 865:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 867:	8b 45 10             	mov    0x10(%ebp),%eax
 86a:	8d 50 ff             	lea    -0x1(%eax),%edx
 86d:	89 55 10             	mov    %edx,0x10(%ebp)
 870:	85 c0                	test   %eax,%eax
 872:	7f dd                	jg     851 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 874:	8b 45 08             	mov    0x8(%ebp),%eax
}
 877:	c9                   	leave  
 878:	c3                   	ret    
 879:	90                   	nop
 87a:	90                   	nop
 87b:	90                   	nop

0000087c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 87c:	b8 01 00 00 00       	mov    $0x1,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <exit>:
SYSCALL(exit)
 884:	b8 02 00 00 00       	mov    $0x2,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <wait>:
SYSCALL(wait)
 88c:	b8 03 00 00 00       	mov    $0x3,%eax
 891:	cd 40                	int    $0x40
 893:	c3                   	ret    

00000894 <pipe>:
SYSCALL(pipe)
 894:	b8 04 00 00 00       	mov    $0x4,%eax
 899:	cd 40                	int    $0x40
 89b:	c3                   	ret    

0000089c <read>:
SYSCALL(read)
 89c:	b8 05 00 00 00       	mov    $0x5,%eax
 8a1:	cd 40                	int    $0x40
 8a3:	c3                   	ret    

000008a4 <write>:
SYSCALL(write)
 8a4:	b8 10 00 00 00       	mov    $0x10,%eax
 8a9:	cd 40                	int    $0x40
 8ab:	c3                   	ret    

000008ac <close>:
SYSCALL(close)
 8ac:	b8 15 00 00 00       	mov    $0x15,%eax
 8b1:	cd 40                	int    $0x40
 8b3:	c3                   	ret    

000008b4 <kill>:
SYSCALL(kill)
 8b4:	b8 06 00 00 00       	mov    $0x6,%eax
 8b9:	cd 40                	int    $0x40
 8bb:	c3                   	ret    

000008bc <exec>:
SYSCALL(exec)
 8bc:	b8 07 00 00 00       	mov    $0x7,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <open>:
SYSCALL(open)
 8c4:	b8 0f 00 00 00       	mov    $0xf,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <mknod>:
SYSCALL(mknod)
 8cc:	b8 11 00 00 00       	mov    $0x11,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <unlink>:
SYSCALL(unlink)
 8d4:	b8 12 00 00 00       	mov    $0x12,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <fstat>:
SYSCALL(fstat)
 8dc:	b8 08 00 00 00       	mov    $0x8,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <link>:
SYSCALL(link)
 8e4:	b8 13 00 00 00       	mov    $0x13,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <mkdir>:
SYSCALL(mkdir)
 8ec:	b8 14 00 00 00       	mov    $0x14,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <chdir>:
SYSCALL(chdir)
 8f4:	b8 09 00 00 00       	mov    $0x9,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <dup>:
SYSCALL(dup)
 8fc:	b8 0a 00 00 00       	mov    $0xa,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <getpid>:
SYSCALL(getpid)
 904:	b8 0b 00 00 00       	mov    $0xb,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <sbrk>:
SYSCALL(sbrk)
 90c:	b8 0c 00 00 00       	mov    $0xc,%eax
 911:	cd 40                	int    $0x40
 913:	c3                   	ret    

00000914 <sleep>:
SYSCALL(sleep)
 914:	b8 0d 00 00 00       	mov    $0xd,%eax
 919:	cd 40                	int    $0x40
 91b:	c3                   	ret    

0000091c <uptime>:
SYSCALL(uptime)
 91c:	b8 0e 00 00 00       	mov    $0xe,%eax
 921:	cd 40                	int    $0x40
 923:	c3                   	ret    

00000924 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 924:	55                   	push   %ebp
 925:	89 e5                	mov    %esp,%ebp
 927:	83 ec 18             	sub    $0x18,%esp
 92a:	8b 45 0c             	mov    0xc(%ebp),%eax
 92d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 930:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 937:	00 
 938:	8d 45 f4             	lea    -0xc(%ebp),%eax
 93b:	89 44 24 04          	mov    %eax,0x4(%esp)
 93f:	8b 45 08             	mov    0x8(%ebp),%eax
 942:	89 04 24             	mov    %eax,(%esp)
 945:	e8 5a ff ff ff       	call   8a4 <write>
}
 94a:	c9                   	leave  
 94b:	c3                   	ret    

0000094c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 94c:	55                   	push   %ebp
 94d:	89 e5                	mov    %esp,%ebp
 94f:	56                   	push   %esi
 950:	53                   	push   %ebx
 951:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 954:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 95b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 95f:	74 17                	je     978 <printint+0x2c>
 961:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 965:	79 11                	jns    978 <printint+0x2c>
    neg = 1;
 967:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 96e:	8b 45 0c             	mov    0xc(%ebp),%eax
 971:	f7 d8                	neg    %eax
 973:	89 45 ec             	mov    %eax,-0x14(%ebp)
 976:	eb 06                	jmp    97e <printint+0x32>
  } else {
    x = xx;
 978:	8b 45 0c             	mov    0xc(%ebp),%eax
 97b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 97e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 985:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 988:	8d 41 01             	lea    0x1(%ecx),%eax
 98b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 98e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 991:	8b 45 ec             	mov    -0x14(%ebp),%eax
 994:	ba 00 00 00 00       	mov    $0x0,%edx
 999:	f7 f3                	div    %ebx
 99b:	89 d0                	mov    %edx,%eax
 99d:	8a 80 ec 11 00 00    	mov    0x11ec(%eax),%al
 9a3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9a7:	8b 75 10             	mov    0x10(%ebp),%esi
 9aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ad:	ba 00 00 00 00       	mov    $0x0,%edx
 9b2:	f7 f6                	div    %esi
 9b4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9b7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9bb:	75 c8                	jne    985 <printint+0x39>
  if(neg)
 9bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9c1:	74 10                	je     9d3 <printint+0x87>
    buf[i++] = '-';
 9c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c6:	8d 50 01             	lea    0x1(%eax),%edx
 9c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9cc:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9d1:	eb 1e                	jmp    9f1 <printint+0xa5>
 9d3:	eb 1c                	jmp    9f1 <printint+0xa5>
    putc(fd, buf[i]);
 9d5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9db:	01 d0                	add    %edx,%eax
 9dd:	8a 00                	mov    (%eax),%al
 9df:	0f be c0             	movsbl %al,%eax
 9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e6:	8b 45 08             	mov    0x8(%ebp),%eax
 9e9:	89 04 24             	mov    %eax,(%esp)
 9ec:	e8 33 ff ff ff       	call   924 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9f1:	ff 4d f4             	decl   -0xc(%ebp)
 9f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9f8:	79 db                	jns    9d5 <printint+0x89>
    putc(fd, buf[i]);
}
 9fa:	83 c4 30             	add    $0x30,%esp
 9fd:	5b                   	pop    %ebx
 9fe:	5e                   	pop    %esi
 9ff:	5d                   	pop    %ebp
 a00:	c3                   	ret    

00000a01 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a01:	55                   	push   %ebp
 a02:	89 e5                	mov    %esp,%ebp
 a04:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a07:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a0e:	8d 45 0c             	lea    0xc(%ebp),%eax
 a11:	83 c0 04             	add    $0x4,%eax
 a14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a17:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a1e:	e9 77 01 00 00       	jmp    b9a <printf+0x199>
    c = fmt[i] & 0xff;
 a23:	8b 55 0c             	mov    0xc(%ebp),%edx
 a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a29:	01 d0                	add    %edx,%eax
 a2b:	8a 00                	mov    (%eax),%al
 a2d:	0f be c0             	movsbl %al,%eax
 a30:	25 ff 00 00 00       	and    $0xff,%eax
 a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a38:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a3c:	75 2c                	jne    a6a <printf+0x69>
      if(c == '%'){
 a3e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a42:	75 0c                	jne    a50 <printf+0x4f>
        state = '%';
 a44:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a4b:	e9 47 01 00 00       	jmp    b97 <printf+0x196>
      } else {
        putc(fd, c);
 a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a53:	0f be c0             	movsbl %al,%eax
 a56:	89 44 24 04          	mov    %eax,0x4(%esp)
 a5a:	8b 45 08             	mov    0x8(%ebp),%eax
 a5d:	89 04 24             	mov    %eax,(%esp)
 a60:	e8 bf fe ff ff       	call   924 <putc>
 a65:	e9 2d 01 00 00       	jmp    b97 <printf+0x196>
      }
    } else if(state == '%'){
 a6a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a6e:	0f 85 23 01 00 00    	jne    b97 <printf+0x196>
      if(c == 'd'){
 a74:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a78:	75 2d                	jne    aa7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a7d:	8b 00                	mov    (%eax),%eax
 a7f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a86:	00 
 a87:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a8e:	00 
 a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
 a93:	8b 45 08             	mov    0x8(%ebp),%eax
 a96:	89 04 24             	mov    %eax,(%esp)
 a99:	e8 ae fe ff ff       	call   94c <printint>
        ap++;
 a9e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aa2:	e9 e9 00 00 00       	jmp    b90 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 aa7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 aab:	74 06                	je     ab3 <printf+0xb2>
 aad:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 ab1:	75 2d                	jne    ae0 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 ab3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ab6:	8b 00                	mov    (%eax),%eax
 ab8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 abf:	00 
 ac0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 ac7:	00 
 ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
 acc:	8b 45 08             	mov    0x8(%ebp),%eax
 acf:	89 04 24             	mov    %eax,(%esp)
 ad2:	e8 75 fe ff ff       	call   94c <printint>
        ap++;
 ad7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 adb:	e9 b0 00 00 00       	jmp    b90 <printf+0x18f>
      } else if(c == 's'){
 ae0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 ae4:	75 42                	jne    b28 <printf+0x127>
        s = (char*)*ap;
 ae6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ae9:	8b 00                	mov    (%eax),%eax
 aeb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 aee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 af6:	75 09                	jne    b01 <printf+0x100>
          s = "(null)";
 af8:	c7 45 f4 ff 0d 00 00 	movl   $0xdff,-0xc(%ebp)
        while(*s != 0){
 aff:	eb 1c                	jmp    b1d <printf+0x11c>
 b01:	eb 1a                	jmp    b1d <printf+0x11c>
          putc(fd, *s);
 b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b06:	8a 00                	mov    (%eax),%al
 b08:	0f be c0             	movsbl %al,%eax
 b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b0f:	8b 45 08             	mov    0x8(%ebp),%eax
 b12:	89 04 24             	mov    %eax,(%esp)
 b15:	e8 0a fe ff ff       	call   924 <putc>
          s++;
 b1a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b20:	8a 00                	mov    (%eax),%al
 b22:	84 c0                	test   %al,%al
 b24:	75 dd                	jne    b03 <printf+0x102>
 b26:	eb 68                	jmp    b90 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b28:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b2c:	75 1d                	jne    b4b <printf+0x14a>
        putc(fd, *ap);
 b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b31:	8b 00                	mov    (%eax),%eax
 b33:	0f be c0             	movsbl %al,%eax
 b36:	89 44 24 04          	mov    %eax,0x4(%esp)
 b3a:	8b 45 08             	mov    0x8(%ebp),%eax
 b3d:	89 04 24             	mov    %eax,(%esp)
 b40:	e8 df fd ff ff       	call   924 <putc>
        ap++;
 b45:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b49:	eb 45                	jmp    b90 <printf+0x18f>
      } else if(c == '%'){
 b4b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b4f:	75 17                	jne    b68 <printf+0x167>
        putc(fd, c);
 b51:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b54:	0f be c0             	movsbl %al,%eax
 b57:	89 44 24 04          	mov    %eax,0x4(%esp)
 b5b:	8b 45 08             	mov    0x8(%ebp),%eax
 b5e:	89 04 24             	mov    %eax,(%esp)
 b61:	e8 be fd ff ff       	call   924 <putc>
 b66:	eb 28                	jmp    b90 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b68:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b6f:	00 
 b70:	8b 45 08             	mov    0x8(%ebp),%eax
 b73:	89 04 24             	mov    %eax,(%esp)
 b76:	e8 a9 fd ff ff       	call   924 <putc>
        putc(fd, c);
 b7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b7e:	0f be c0             	movsbl %al,%eax
 b81:	89 44 24 04          	mov    %eax,0x4(%esp)
 b85:	8b 45 08             	mov    0x8(%ebp),%eax
 b88:	89 04 24             	mov    %eax,(%esp)
 b8b:	e8 94 fd ff ff       	call   924 <putc>
      }
      state = 0;
 b90:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b97:	ff 45 f0             	incl   -0x10(%ebp)
 b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
 b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba0:	01 d0                	add    %edx,%eax
 ba2:	8a 00                	mov    (%eax),%al
 ba4:	84 c0                	test   %al,%al
 ba6:	0f 85 77 fe ff ff    	jne    a23 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bac:	c9                   	leave  
 bad:	c3                   	ret    
 bae:	90                   	nop
 baf:	90                   	nop

00000bb0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb0:	55                   	push   %ebp
 bb1:	89 e5                	mov    %esp,%ebp
 bb3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bb6:	8b 45 08             	mov    0x8(%ebp),%eax
 bb9:	83 e8 08             	sub    $0x8,%eax
 bbc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bbf:	a1 10 12 00 00       	mov    0x1210,%eax
 bc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bc7:	eb 24                	jmp    bed <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bcc:	8b 00                	mov    (%eax),%eax
 bce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bd1:	77 12                	ja     be5 <free+0x35>
 bd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bd9:	77 24                	ja     bff <free+0x4f>
 bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bde:	8b 00                	mov    (%eax),%eax
 be0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 be3:	77 1a                	ja     bff <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 be5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be8:	8b 00                	mov    (%eax),%eax
 bea:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bed:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bf3:	76 d4                	jbe    bc9 <free+0x19>
 bf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf8:	8b 00                	mov    (%eax),%eax
 bfa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bfd:	76 ca                	jbe    bc9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c02:	8b 40 04             	mov    0x4(%eax),%eax
 c05:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c0c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c0f:	01 c2                	add    %eax,%edx
 c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c14:	8b 00                	mov    (%eax),%eax
 c16:	39 c2                	cmp    %eax,%edx
 c18:	75 24                	jne    c3e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c1a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c1d:	8b 50 04             	mov    0x4(%eax),%edx
 c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c23:	8b 00                	mov    (%eax),%eax
 c25:	8b 40 04             	mov    0x4(%eax),%eax
 c28:	01 c2                	add    %eax,%edx
 c2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c33:	8b 00                	mov    (%eax),%eax
 c35:	8b 10                	mov    (%eax),%edx
 c37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3a:	89 10                	mov    %edx,(%eax)
 c3c:	eb 0a                	jmp    c48 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c41:	8b 10                	mov    (%eax),%edx
 c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c46:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c4b:	8b 40 04             	mov    0x4(%eax),%eax
 c4e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c58:	01 d0                	add    %edx,%eax
 c5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c5d:	75 20                	jne    c7f <free+0xcf>
    p->s.size += bp->s.size;
 c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c62:	8b 50 04             	mov    0x4(%eax),%edx
 c65:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c68:	8b 40 04             	mov    0x4(%eax),%eax
 c6b:	01 c2                	add    %eax,%edx
 c6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c70:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c73:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c76:	8b 10                	mov    (%eax),%edx
 c78:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c7b:	89 10                	mov    %edx,(%eax)
 c7d:	eb 08                	jmp    c87 <free+0xd7>
  } else
    p->s.ptr = bp;
 c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c82:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c85:	89 10                	mov    %edx,(%eax)
  freep = p;
 c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c8a:	a3 10 12 00 00       	mov    %eax,0x1210
}
 c8f:	c9                   	leave  
 c90:	c3                   	ret    

00000c91 <morecore>:

static Header*
morecore(uint nu)
{
 c91:	55                   	push   %ebp
 c92:	89 e5                	mov    %esp,%ebp
 c94:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c97:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c9e:	77 07                	ja     ca7 <morecore+0x16>
    nu = 4096;
 ca0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ca7:	8b 45 08             	mov    0x8(%ebp),%eax
 caa:	c1 e0 03             	shl    $0x3,%eax
 cad:	89 04 24             	mov    %eax,(%esp)
 cb0:	e8 57 fc ff ff       	call   90c <sbrk>
 cb5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cb8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cbc:	75 07                	jne    cc5 <morecore+0x34>
    return 0;
 cbe:	b8 00 00 00 00       	mov    $0x0,%eax
 cc3:	eb 22                	jmp    ce7 <morecore+0x56>
  hp = (Header*)p;
 cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ccb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cce:	8b 55 08             	mov    0x8(%ebp),%edx
 cd1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cd7:	83 c0 08             	add    $0x8,%eax
 cda:	89 04 24             	mov    %eax,(%esp)
 cdd:	e8 ce fe ff ff       	call   bb0 <free>
  return freep;
 ce2:	a1 10 12 00 00       	mov    0x1210,%eax
}
 ce7:	c9                   	leave  
 ce8:	c3                   	ret    

00000ce9 <malloc>:

void*
malloc(uint nbytes)
{
 ce9:	55                   	push   %ebp
 cea:	89 e5                	mov    %esp,%ebp
 cec:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cef:	8b 45 08             	mov    0x8(%ebp),%eax
 cf2:	83 c0 07             	add    $0x7,%eax
 cf5:	c1 e8 03             	shr    $0x3,%eax
 cf8:	40                   	inc    %eax
 cf9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 cfc:	a1 10 12 00 00       	mov    0x1210,%eax
 d01:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d08:	75 23                	jne    d2d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d0a:	c7 45 f0 08 12 00 00 	movl   $0x1208,-0x10(%ebp)
 d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d14:	a3 10 12 00 00       	mov    %eax,0x1210
 d19:	a1 10 12 00 00       	mov    0x1210,%eax
 d1e:	a3 08 12 00 00       	mov    %eax,0x1208
    base.s.size = 0;
 d23:	c7 05 0c 12 00 00 00 	movl   $0x0,0x120c
 d2a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d30:	8b 00                	mov    (%eax),%eax
 d32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d38:	8b 40 04             	mov    0x4(%eax),%eax
 d3b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d3e:	72 4d                	jb     d8d <malloc+0xa4>
      if(p->s.size == nunits)
 d40:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d43:	8b 40 04             	mov    0x4(%eax),%eax
 d46:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d49:	75 0c                	jne    d57 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4e:	8b 10                	mov    (%eax),%edx
 d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d53:	89 10                	mov    %edx,(%eax)
 d55:	eb 26                	jmp    d7d <malloc+0x94>
      else {
        p->s.size -= nunits;
 d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d5a:	8b 40 04             	mov    0x4(%eax),%eax
 d5d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d60:	89 c2                	mov    %eax,%edx
 d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d65:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6b:	8b 40 04             	mov    0x4(%eax),%eax
 d6e:	c1 e0 03             	shl    $0x3,%eax
 d71:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d77:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d7a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d80:	a3 10 12 00 00       	mov    %eax,0x1210
      return (void*)(p + 1);
 d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d88:	83 c0 08             	add    $0x8,%eax
 d8b:	eb 38                	jmp    dc5 <malloc+0xdc>
    }
    if(p == freep)
 d8d:	a1 10 12 00 00       	mov    0x1210,%eax
 d92:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d95:	75 1b                	jne    db2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d97:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d9a:	89 04 24             	mov    %eax,(%esp)
 d9d:	e8 ef fe ff ff       	call   c91 <morecore>
 da2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 da9:	75 07                	jne    db2 <malloc+0xc9>
        return 0;
 dab:	b8 00 00 00 00       	mov    $0x0,%eax
 db0:	eb 13                	jmp    dc5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 db5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbb:	8b 00                	mov    (%eax),%eax
 dbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 dc0:	e9 70 ff ff ff       	jmp    d35 <malloc+0x4c>
}
 dc5:	c9                   	leave  
 dc6:	c3                   	ret    
