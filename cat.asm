
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
   f:	c7 44 24 04 80 11 00 	movl   $0x1180,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 e9 07 00 00       	call   80c <write>
  23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  26:	74 19                	je     41 <cat+0x41>
      printf(1, "cat: write error\n");
  28:	c7 44 24 04 2f 0d 00 	movl   $0xd2f,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 2d 09 00 00       	call   969 <printf>
      exit();
  3c:	e8 ab 07 00 00       	call   7ec <exit>
void
cat(int fd)
{
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
  41:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  48:	00 
  49:	c7 44 24 04 80 11 00 	movl   $0x1180,0x4(%esp)
  50:	00 
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 a8 07 00 00       	call   804 <read>
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
  6b:	c7 44 24 04 41 0d 00 	movl   $0xd41,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 ea 08 00 00       	call   969 <printf>
    exit();
  7f:	e8 68 07 00 00       	call   7ec <exit>
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
  a1:	e8 46 07 00 00       	call   7ec <exit>
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
  cd:	e8 5a 07 00 00       	call   82c <open>
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
  f3:	c7 44 24 04 52 0d 00 	movl   $0xd52,0x4(%esp)
  fa:	00 
  fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 102:	e8 62 08 00 00       	call   969 <printf>
      exit();
 107:	e8 e0 06 00 00       	call   7ec <exit>
    }
    cat(fd);
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	89 04 24             	mov    %eax,(%esp)
 113:	e8 e8 fe ff ff       	call   0 <cat>
    close(fd);
 118:	8b 44 24 18          	mov    0x18(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 f0 06 00 00       	call   814 <close>
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
 135:	e8 b2 06 00 00       	call   7ec <exit>
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

0000018f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 192:	eb 06                	jmp    19a <strcmp+0xb>
    p++, q++;
 194:	ff 45 08             	incl   0x8(%ebp)
 197:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	8a 00                	mov    (%eax),%al
 19f:	84 c0                	test   %al,%al
 1a1:	74 0e                	je     1b1 <strcmp+0x22>
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	8a 10                	mov    (%eax),%dl
 1a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ab:	8a 00                	mov    (%eax),%al
 1ad:	38 c2                	cmp    %al,%dl
 1af:	74 e3                	je     194 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	8a 00                	mov    (%eax),%al
 1b6:	0f b6 d0             	movzbl %al,%edx
 1b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bc:	8a 00                	mov    (%eax),%al
 1be:	0f b6 c0             	movzbl %al,%eax
 1c1:	29 c2                	sub    %eax,%edx
 1c3:	89 d0                	mov    %edx,%eax
}
 1c5:	5d                   	pop    %ebp
 1c6:	c3                   	ret    

000001c7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 1c7:	55                   	push   %ebp
 1c8:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 1ca:	eb 09                	jmp    1d5 <strncmp+0xe>
    n--, p++, q++;
 1cc:	ff 4d 10             	decl   0x10(%ebp)
 1cf:	ff 45 08             	incl   0x8(%ebp)
 1d2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 1d5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1d9:	74 17                	je     1f2 <strncmp+0x2b>
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	8a 00                	mov    (%eax),%al
 1e0:	84 c0                	test   %al,%al
 1e2:	74 0e                	je     1f2 <strncmp+0x2b>
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	8a 10                	mov    (%eax),%dl
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	8a 00                	mov    (%eax),%al
 1ee:	38 c2                	cmp    %al,%dl
 1f0:	74 da                	je     1cc <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 1f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1f6:	75 07                	jne    1ff <strncmp+0x38>
    return 0;
 1f8:	b8 00 00 00 00       	mov    $0x0,%eax
 1fd:	eb 14                	jmp    213 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 1ff:	8b 45 08             	mov    0x8(%ebp),%eax
 202:	8a 00                	mov    (%eax),%al
 204:	0f b6 d0             	movzbl %al,%edx
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	8a 00                	mov    (%eax),%al
 20c:	0f b6 c0             	movzbl %al,%eax
 20f:	29 c2                	sub    %eax,%edx
 211:	89 d0                	mov    %edx,%eax
}
 213:	5d                   	pop    %ebp
 214:	c3                   	ret    

00000215 <strlen>:

uint
strlen(const char *s)
{
 215:	55                   	push   %ebp
 216:	89 e5                	mov    %esp,%ebp
 218:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 21b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 222:	eb 03                	jmp    227 <strlen+0x12>
 224:	ff 45 fc             	incl   -0x4(%ebp)
 227:	8b 55 fc             	mov    -0x4(%ebp),%edx
 22a:	8b 45 08             	mov    0x8(%ebp),%eax
 22d:	01 d0                	add    %edx,%eax
 22f:	8a 00                	mov    (%eax),%al
 231:	84 c0                	test   %al,%al
 233:	75 ef                	jne    224 <strlen+0xf>
    ;
  return n;
 235:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <memset>:

void*
memset(void *dst, int c, uint n)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 240:	8b 45 10             	mov    0x10(%ebp),%eax
 243:	89 44 24 08          	mov    %eax,0x8(%esp)
 247:	8b 45 0c             	mov    0xc(%ebp),%eax
 24a:	89 44 24 04          	mov    %eax,0x4(%esp)
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	89 04 24             	mov    %eax,(%esp)
 254:	e8 e3 fe ff ff       	call   13c <stosb>
  return dst;
 259:	8b 45 08             	mov    0x8(%ebp),%eax
}
 25c:	c9                   	leave  
 25d:	c3                   	ret    

0000025e <strchr>:

char*
strchr(const char *s, char c)
{
 25e:	55                   	push   %ebp
 25f:	89 e5                	mov    %esp,%ebp
 261:	83 ec 04             	sub    $0x4,%esp
 264:	8b 45 0c             	mov    0xc(%ebp),%eax
 267:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 26a:	eb 12                	jmp    27e <strchr+0x20>
    if(*s == c)
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8a 00                	mov    (%eax),%al
 271:	3a 45 fc             	cmp    -0x4(%ebp),%al
 274:	75 05                	jne    27b <strchr+0x1d>
      return (char*)s;
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	eb 11                	jmp    28c <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 27b:	ff 45 08             	incl   0x8(%ebp)
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	8a 00                	mov    (%eax),%al
 283:	84 c0                	test   %al,%al
 285:	75 e5                	jne    26c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 287:	b8 00 00 00 00       	mov    $0x0,%eax
}
 28c:	c9                   	leave  
 28d:	c3                   	ret    

0000028e <strcat>:

char *
strcat(char *dest, const char *src)
{
 28e:	55                   	push   %ebp
 28f:	89 e5                	mov    %esp,%ebp
 291:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 294:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 29b:	eb 03                	jmp    2a0 <strcat+0x12>
 29d:	ff 45 fc             	incl   -0x4(%ebp)
 2a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	01 d0                	add    %edx,%eax
 2a8:	8a 00                	mov    (%eax),%al
 2aa:	84 c0                	test   %al,%al
 2ac:	75 ef                	jne    29d <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 2ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 2b5:	eb 1e                	jmp    2d5 <strcat+0x47>
        dest[i+j] = src[j];
 2b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ba:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2bd:	01 d0                	add    %edx,%eax
 2bf:	89 c2                	mov    %eax,%edx
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
 2c4:	01 c2                	add    %eax,%edx
 2c6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cc:	01 c8                	add    %ecx,%eax
 2ce:	8a 00                	mov    (%eax),%al
 2d0:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 2d2:	ff 45 f8             	incl   -0x8(%ebp)
 2d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2db:	01 d0                	add    %edx,%eax
 2dd:	8a 00                	mov    (%eax),%al
 2df:	84 c0                	test   %al,%al
 2e1:	75 d4                	jne    2b7 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 2e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e9:	01 d0                	add    %edx,%eax
 2eb:	89 c2                	mov    %eax,%edx
 2ed:	8b 45 08             	mov    0x8(%ebp),%eax
 2f0:	01 d0                	add    %edx,%eax
 2f2:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 2f5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <strstr>:

int 
strstr(char* s, char* sub)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 307:	eb 7c                	jmp    385 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 309:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30c:	8b 45 08             	mov    0x8(%ebp),%eax
 30f:	01 d0                	add    %edx,%eax
 311:	8a 10                	mov    (%eax),%dl
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	8a 00                	mov    (%eax),%al
 318:	38 c2                	cmp    %al,%dl
 31a:	75 66                	jne    382 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 31c:	8b 45 0c             	mov    0xc(%ebp),%eax
 31f:	89 04 24             	mov    %eax,(%esp)
 322:	e8 ee fe ff ff       	call   215 <strlen>
 327:	83 f8 01             	cmp    $0x1,%eax
 32a:	75 05                	jne    331 <strstr+0x37>
            {  
                return i;
 32c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32f:	eb 6b                	jmp    39c <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 331:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 338:	eb 3a                	jmp    374 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 33a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 340:	01 d0                	add    %edx,%eax
 342:	89 c2                	mov    %eax,%edx
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	01 d0                	add    %edx,%eax
 349:	8a 10                	mov    (%eax),%dl
 34b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 34e:	8b 45 0c             	mov    0xc(%ebp),%eax
 351:	01 c8                	add    %ecx,%eax
 353:	8a 00                	mov    (%eax),%al
 355:	38 c2                	cmp    %al,%dl
 357:	75 16                	jne    36f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 359:	8b 45 f8             	mov    -0x8(%ebp),%eax
 35c:	8d 50 01             	lea    0x1(%eax),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	01 d0                	add    %edx,%eax
 364:	8a 00                	mov    (%eax),%al
 366:	84 c0                	test   %al,%al
 368:	75 07                	jne    371 <strstr+0x77>
                    {
                        return i;
 36a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36d:	eb 2d                	jmp    39c <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 36f:	eb 11                	jmp    382 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 371:	ff 45 f8             	incl   -0x8(%ebp)
 374:	8b 55 f8             	mov    -0x8(%ebp),%edx
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	01 d0                	add    %edx,%eax
 37c:	8a 00                	mov    (%eax),%al
 37e:	84 c0                	test   %al,%al
 380:	75 b8                	jne    33a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 382:	ff 45 fc             	incl   -0x4(%ebp)
 385:	8b 55 fc             	mov    -0x4(%ebp),%edx
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	01 d0                	add    %edx,%eax
 38d:	8a 00                	mov    (%eax),%al
 38f:	84 c0                	test   %al,%al
 391:	0f 85 72 ff ff ff    	jne    309 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 39c:	c9                   	leave  
 39d:	c3                   	ret    

0000039e <strtok>:

char *
strtok(char *s, const char *delim)
{
 39e:	55                   	push   %ebp
 39f:	89 e5                	mov    %esp,%ebp
 3a1:	53                   	push   %ebx
 3a2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a9:	75 08                	jne    3b3 <strtok+0x15>
  s = lasts;
 3ab:	a1 64 11 00 00       	mov    0x1164,%eax
 3b0:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	8d 50 01             	lea    0x1(%eax),%edx
 3b9:	89 55 08             	mov    %edx,0x8(%ebp)
 3bc:	8a 00                	mov    (%eax),%al
 3be:	0f be d8             	movsbl %al,%ebx
 3c1:	85 db                	test   %ebx,%ebx
 3c3:	75 07                	jne    3cc <strtok+0x2e>
      return 0;
 3c5:	b8 00 00 00 00       	mov    $0x0,%eax
 3ca:	eb 58                	jmp    424 <strtok+0x86>
    } while (strchr(delim, ch));
 3cc:	88 d8                	mov    %bl,%al
 3ce:	0f be c0             	movsbl %al,%eax
 3d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d8:	89 04 24             	mov    %eax,(%esp)
 3db:	e8 7e fe ff ff       	call   25e <strchr>
 3e0:	85 c0                	test   %eax,%eax
 3e2:	75 cf                	jne    3b3 <strtok+0x15>
    --s;
 3e4:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 3e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	89 04 24             	mov    %eax,(%esp)
 3f4:	e8 31 00 00 00       	call   42a <strcspn>
 3f9:	89 c2                	mov    %eax,%edx
 3fb:	8b 45 08             	mov    0x8(%ebp),%eax
 3fe:	01 d0                	add    %edx,%eax
 400:	a3 64 11 00 00       	mov    %eax,0x1164
    if (*lasts != 0)
 405:	a1 64 11 00 00       	mov    0x1164,%eax
 40a:	8a 00                	mov    (%eax),%al
 40c:	84 c0                	test   %al,%al
 40e:	74 11                	je     421 <strtok+0x83>
  *lasts++ = 0;
 410:	a1 64 11 00 00       	mov    0x1164,%eax
 415:	8d 50 01             	lea    0x1(%eax),%edx
 418:	89 15 64 11 00 00    	mov    %edx,0x1164
 41e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 421:	8b 45 08             	mov    0x8(%ebp),%eax
}
 424:	83 c4 14             	add    $0x14,%esp
 427:	5b                   	pop    %ebx
 428:	5d                   	pop    %ebp
 429:	c3                   	ret    

0000042a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 430:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 437:	eb 26                	jmp    45f <strcspn+0x35>
        if(strchr(s2,*s1))
 439:	8b 45 08             	mov    0x8(%ebp),%eax
 43c:	8a 00                	mov    (%eax),%al
 43e:	0f be c0             	movsbl %al,%eax
 441:	89 44 24 04          	mov    %eax,0x4(%esp)
 445:	8b 45 0c             	mov    0xc(%ebp),%eax
 448:	89 04 24             	mov    %eax,(%esp)
 44b:	e8 0e fe ff ff       	call   25e <strchr>
 450:	85 c0                	test   %eax,%eax
 452:	74 05                	je     459 <strcspn+0x2f>
            return ret;
 454:	8b 45 fc             	mov    -0x4(%ebp),%eax
 457:	eb 12                	jmp    46b <strcspn+0x41>
        else
            s1++,ret++;
 459:	ff 45 08             	incl   0x8(%ebp)
 45c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 45f:	8b 45 08             	mov    0x8(%ebp),%eax
 462:	8a 00                	mov    (%eax),%al
 464:	84 c0                	test   %al,%al
 466:	75 d1                	jne    439 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 468:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 46b:	c9                   	leave  
 46c:	c3                   	ret    

0000046d <isspace>:

int
isspace(unsigned char c)
{
 46d:	55                   	push   %ebp
 46e:	89 e5                	mov    %esp,%ebp
 470:	83 ec 04             	sub    $0x4,%esp
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 479:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 47d:	74 1e                	je     49d <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 47f:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 483:	74 18                	je     49d <isspace+0x30>
 485:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 489:	74 12                	je     49d <isspace+0x30>
 48b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 48f:	74 0c                	je     49d <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 491:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 495:	74 06                	je     49d <isspace+0x30>
 497:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 49b:	75 07                	jne    4a4 <isspace+0x37>
 49d:	b8 01 00 00 00       	mov    $0x1,%eax
 4a2:	eb 05                	jmp    4a9 <isspace+0x3c>
 4a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4a9:	c9                   	leave  
 4aa:	c3                   	ret    

000004ab <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4ab:	55                   	push   %ebp
 4ac:	89 e5                	mov    %esp,%ebp
 4ae:	57                   	push   %edi
 4af:	56                   	push   %esi
 4b0:	53                   	push   %ebx
 4b1:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 4b4:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 4b9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 4c0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 4c3:	eb 01                	jmp    4c6 <strtoul+0x1b>
  p += 1;
 4c5:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 4c6:	8a 03                	mov    (%ebx),%al
 4c8:	0f b6 c0             	movzbl %al,%eax
 4cb:	89 04 24             	mov    %eax,(%esp)
 4ce:	e8 9a ff ff ff       	call   46d <isspace>
 4d3:	85 c0                	test   %eax,%eax
 4d5:	75 ee                	jne    4c5 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 4d7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4db:	75 30                	jne    50d <strtoul+0x62>
    {
  if (*p == '0') {
 4dd:	8a 03                	mov    (%ebx),%al
 4df:	3c 30                	cmp    $0x30,%al
 4e1:	75 21                	jne    504 <strtoul+0x59>
      p += 1;
 4e3:	43                   	inc    %ebx
      if (*p == 'x') {
 4e4:	8a 03                	mov    (%ebx),%al
 4e6:	3c 78                	cmp    $0x78,%al
 4e8:	75 0a                	jne    4f4 <strtoul+0x49>
    p += 1;
 4ea:	43                   	inc    %ebx
    base = 16;
 4eb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 4f2:	eb 31                	jmp    525 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 4f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 4fb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 502:	eb 21                	jmp    525 <strtoul+0x7a>
      }
  }
  else base = 10;
 504:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 50b:	eb 18                	jmp    525 <strtoul+0x7a>
    } else if (base == 16) {
 50d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 511:	75 12                	jne    525 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 513:	8a 03                	mov    (%ebx),%al
 515:	3c 30                	cmp    $0x30,%al
 517:	75 0c                	jne    525 <strtoul+0x7a>
 519:	8d 43 01             	lea    0x1(%ebx),%eax
 51c:	8a 00                	mov    (%eax),%al
 51e:	3c 78                	cmp    $0x78,%al
 520:	75 03                	jne    525 <strtoul+0x7a>
      p += 2;
 522:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 525:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 529:	75 29                	jne    554 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 52b:	8a 03                	mov    (%ebx),%al
 52d:	0f be c0             	movsbl %al,%eax
 530:	83 e8 30             	sub    $0x30,%eax
 533:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 535:	83 fe 07             	cmp    $0x7,%esi
 538:	76 06                	jbe    540 <strtoul+0x95>
    break;
 53a:	90                   	nop
 53b:	e9 b6 00 00 00       	jmp    5f6 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 540:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 547:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 54a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 551:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 552:	eb d7                	jmp    52b <strtoul+0x80>
    } else if (base == 10) {
 554:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 558:	75 2b                	jne    585 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 55a:	8a 03                	mov    (%ebx),%al
 55c:	0f be c0             	movsbl %al,%eax
 55f:	83 e8 30             	sub    $0x30,%eax
 562:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 564:	83 fe 09             	cmp    $0x9,%esi
 567:	76 06                	jbe    56f <strtoul+0xc4>
    break;
 569:	90                   	nop
 56a:	e9 87 00 00 00       	jmp    5f6 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 56f:	89 f8                	mov    %edi,%eax
 571:	c1 e0 02             	shl    $0x2,%eax
 574:	01 f8                	add    %edi,%eax
 576:	01 c0                	add    %eax,%eax
 578:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 57b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 582:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 583:	eb d5                	jmp    55a <strtoul+0xaf>
    } else if (base == 16) {
 585:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 589:	75 35                	jne    5c0 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 58b:	8a 03                	mov    (%ebx),%al
 58d:	0f be c0             	movsbl %al,%eax
 590:	83 e8 30             	sub    $0x30,%eax
 593:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 595:	83 fe 4a             	cmp    $0x4a,%esi
 598:	76 02                	jbe    59c <strtoul+0xf1>
    break;
 59a:	eb 22                	jmp    5be <strtoul+0x113>
      }
      digit = cvtIn[digit];
 59c:	8a 86 00 11 00 00    	mov    0x1100(%esi),%al
 5a2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5a5:	83 fe 0f             	cmp    $0xf,%esi
 5a8:	76 02                	jbe    5ac <strtoul+0x101>
    break;
 5aa:	eb 12                	jmp    5be <strtoul+0x113>
      }
      result = (result << 4) + digit;
 5ac:	89 f8                	mov    %edi,%eax
 5ae:	c1 e0 04             	shl    $0x4,%eax
 5b1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 5bb:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 5bc:	eb cd                	jmp    58b <strtoul+0xe0>
 5be:	eb 36                	jmp    5f6 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 5c0:	8a 03                	mov    (%ebx),%al
 5c2:	0f be c0             	movsbl %al,%eax
 5c5:	83 e8 30             	sub    $0x30,%eax
 5c8:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5ca:	83 fe 4a             	cmp    $0x4a,%esi
 5cd:	76 02                	jbe    5d1 <strtoul+0x126>
    break;
 5cf:	eb 25                	jmp    5f6 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 5d1:	8a 86 00 11 00 00    	mov    0x1100(%esi),%al
 5d7:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 5da:	8b 45 10             	mov    0x10(%ebp),%eax
 5dd:	39 f0                	cmp    %esi,%eax
 5df:	77 02                	ja     5e3 <strtoul+0x138>
    break;
 5e1:	eb 13                	jmp    5f6 <strtoul+0x14b>
      }
      result = result*base + digit;
 5e3:	8b 45 10             	mov    0x10(%ebp),%eax
 5e6:	0f af c7             	imul   %edi,%eax
 5e9:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5ec:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 5f3:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 5f4:	eb ca                	jmp    5c0 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 5f6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5fa:	75 03                	jne    5ff <strtoul+0x154>
  p = string;
 5fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 5ff:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 603:	74 05                	je     60a <strtoul+0x15f>
  *endPtr = p;
 605:	8b 45 0c             	mov    0xc(%ebp),%eax
 608:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 60a:	89 f8                	mov    %edi,%eax
}
 60c:	83 c4 14             	add    $0x14,%esp
 60f:	5b                   	pop    %ebx
 610:	5e                   	pop    %esi
 611:	5f                   	pop    %edi
 612:	5d                   	pop    %ebp
 613:	c3                   	ret    

00000614 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	53                   	push   %ebx
 618:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 61b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 61e:	eb 01                	jmp    621 <strtol+0xd>
      p += 1;
 620:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 621:	8a 03                	mov    (%ebx),%al
 623:	0f b6 c0             	movzbl %al,%eax
 626:	89 04 24             	mov    %eax,(%esp)
 629:	e8 3f fe ff ff       	call   46d <isspace>
 62e:	85 c0                	test   %eax,%eax
 630:	75 ee                	jne    620 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 632:	8a 03                	mov    (%ebx),%al
 634:	3c 2d                	cmp    $0x2d,%al
 636:	75 1e                	jne    656 <strtol+0x42>
  p += 1;
 638:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 639:	8b 45 10             	mov    0x10(%ebp),%eax
 63c:	89 44 24 08          	mov    %eax,0x8(%esp)
 640:	8b 45 0c             	mov    0xc(%ebp),%eax
 643:	89 44 24 04          	mov    %eax,0x4(%esp)
 647:	89 1c 24             	mov    %ebx,(%esp)
 64a:	e8 5c fe ff ff       	call   4ab <strtoul>
 64f:	f7 d8                	neg    %eax
 651:	89 45 f8             	mov    %eax,-0x8(%ebp)
 654:	eb 20                	jmp    676 <strtol+0x62>
    } else {
  if (*p == '+') {
 656:	8a 03                	mov    (%ebx),%al
 658:	3c 2b                	cmp    $0x2b,%al
 65a:	75 01                	jne    65d <strtol+0x49>
      p += 1;
 65c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 65d:	8b 45 10             	mov    0x10(%ebp),%eax
 660:	89 44 24 08          	mov    %eax,0x8(%esp)
 664:	8b 45 0c             	mov    0xc(%ebp),%eax
 667:	89 44 24 04          	mov    %eax,0x4(%esp)
 66b:	89 1c 24             	mov    %ebx,(%esp)
 66e:	e8 38 fe ff ff       	call   4ab <strtoul>
 673:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 676:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 67a:	75 17                	jne    693 <strtol+0x7f>
 67c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 680:	74 11                	je     693 <strtol+0x7f>
 682:	8b 45 0c             	mov    0xc(%ebp),%eax
 685:	8b 00                	mov    (%eax),%eax
 687:	39 d8                	cmp    %ebx,%eax
 689:	75 08                	jne    693 <strtol+0x7f>
  *endPtr = string;
 68b:	8b 45 0c             	mov    0xc(%ebp),%eax
 68e:	8b 55 08             	mov    0x8(%ebp),%edx
 691:	89 10                	mov    %edx,(%eax)
    }
    return result;
 693:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 696:	83 c4 1c             	add    $0x1c,%esp
 699:	5b                   	pop    %ebx
 69a:	5d                   	pop    %ebp
 69b:	c3                   	ret    

0000069c <gets>:

char*
gets(char *buf, int max)
{
 69c:	55                   	push   %ebp
 69d:	89 e5                	mov    %esp,%ebp
 69f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6a9:	eb 49                	jmp    6f4 <gets+0x58>
    cc = read(0, &c, 1);
 6ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6b2:	00 
 6b3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6c1:	e8 3e 01 00 00       	call   804 <read>
 6c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6cd:	7f 02                	jg     6d1 <gets+0x35>
      break;
 6cf:	eb 2c                	jmp    6fd <gets+0x61>
    buf[i++] = c;
 6d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d4:	8d 50 01             	lea    0x1(%eax),%edx
 6d7:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6da:	89 c2                	mov    %eax,%edx
 6dc:	8b 45 08             	mov    0x8(%ebp),%eax
 6df:	01 c2                	add    %eax,%edx
 6e1:	8a 45 ef             	mov    -0x11(%ebp),%al
 6e4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6e6:	8a 45 ef             	mov    -0x11(%ebp),%al
 6e9:	3c 0a                	cmp    $0xa,%al
 6eb:	74 10                	je     6fd <gets+0x61>
 6ed:	8a 45 ef             	mov    -0x11(%ebp),%al
 6f0:	3c 0d                	cmp    $0xd,%al
 6f2:	74 09                	je     6fd <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f7:	40                   	inc    %eax
 6f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6fb:	7c ae                	jl     6ab <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 700:	8b 45 08             	mov    0x8(%ebp),%eax
 703:	01 d0                	add    %edx,%eax
 705:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 708:	8b 45 08             	mov    0x8(%ebp),%eax
}
 70b:	c9                   	leave  
 70c:	c3                   	ret    

0000070d <stat>:

int
stat(char *n, struct stat *st)
{
 70d:	55                   	push   %ebp
 70e:	89 e5                	mov    %esp,%ebp
 710:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 713:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 71a:	00 
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 06 01 00 00       	call   82c <open>
 726:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 729:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 72d:	79 07                	jns    736 <stat+0x29>
    return -1;
 72f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 734:	eb 23                	jmp    759 <stat+0x4c>
  r = fstat(fd, st);
 736:	8b 45 0c             	mov    0xc(%ebp),%eax
 739:	89 44 24 04          	mov    %eax,0x4(%esp)
 73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 740:	89 04 24             	mov    %eax,(%esp)
 743:	e8 fc 00 00 00       	call   844 <fstat>
 748:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 74b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74e:	89 04 24             	mov    %eax,(%esp)
 751:	e8 be 00 00 00       	call   814 <close>
  return r;
 756:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 759:	c9                   	leave  
 75a:	c3                   	ret    

0000075b <atoi>:

int
atoi(const char *s)
{
 75b:	55                   	push   %ebp
 75c:	89 e5                	mov    %esp,%ebp
 75e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 761:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 768:	eb 24                	jmp    78e <atoi+0x33>
    n = n*10 + *s++ - '0';
 76a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 76d:	89 d0                	mov    %edx,%eax
 76f:	c1 e0 02             	shl    $0x2,%eax
 772:	01 d0                	add    %edx,%eax
 774:	01 c0                	add    %eax,%eax
 776:	89 c1                	mov    %eax,%ecx
 778:	8b 45 08             	mov    0x8(%ebp),%eax
 77b:	8d 50 01             	lea    0x1(%eax),%edx
 77e:	89 55 08             	mov    %edx,0x8(%ebp)
 781:	8a 00                	mov    (%eax),%al
 783:	0f be c0             	movsbl %al,%eax
 786:	01 c8                	add    %ecx,%eax
 788:	83 e8 30             	sub    $0x30,%eax
 78b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 78e:	8b 45 08             	mov    0x8(%ebp),%eax
 791:	8a 00                	mov    (%eax),%al
 793:	3c 2f                	cmp    $0x2f,%al
 795:	7e 09                	jle    7a0 <atoi+0x45>
 797:	8b 45 08             	mov    0x8(%ebp),%eax
 79a:	8a 00                	mov    (%eax),%al
 79c:	3c 39                	cmp    $0x39,%al
 79e:	7e ca                	jle    76a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7a3:	c9                   	leave  
 7a4:	c3                   	ret    

000007a5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7a5:	55                   	push   %ebp
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7b7:	eb 16                	jmp    7cf <memmove+0x2a>
    *dst++ = *src++;
 7b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bc:	8d 50 01             	lea    0x1(%eax),%edx
 7bf:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7c2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c5:	8d 4a 01             	lea    0x1(%edx),%ecx
 7c8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7cb:	8a 12                	mov    (%edx),%dl
 7cd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7cf:	8b 45 10             	mov    0x10(%ebp),%eax
 7d2:	8d 50 ff             	lea    -0x1(%eax),%edx
 7d5:	89 55 10             	mov    %edx,0x10(%ebp)
 7d8:	85 c0                	test   %eax,%eax
 7da:	7f dd                	jg     7b9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7dc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7df:	c9                   	leave  
 7e0:	c3                   	ret    
 7e1:	90                   	nop
 7e2:	90                   	nop
 7e3:	90                   	nop

000007e4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7e4:	b8 01 00 00 00       	mov    $0x1,%eax
 7e9:	cd 40                	int    $0x40
 7eb:	c3                   	ret    

000007ec <exit>:
SYSCALL(exit)
 7ec:	b8 02 00 00 00       	mov    $0x2,%eax
 7f1:	cd 40                	int    $0x40
 7f3:	c3                   	ret    

000007f4 <wait>:
SYSCALL(wait)
 7f4:	b8 03 00 00 00       	mov    $0x3,%eax
 7f9:	cd 40                	int    $0x40
 7fb:	c3                   	ret    

000007fc <pipe>:
SYSCALL(pipe)
 7fc:	b8 04 00 00 00       	mov    $0x4,%eax
 801:	cd 40                	int    $0x40
 803:	c3                   	ret    

00000804 <read>:
SYSCALL(read)
 804:	b8 05 00 00 00       	mov    $0x5,%eax
 809:	cd 40                	int    $0x40
 80b:	c3                   	ret    

0000080c <write>:
SYSCALL(write)
 80c:	b8 10 00 00 00       	mov    $0x10,%eax
 811:	cd 40                	int    $0x40
 813:	c3                   	ret    

00000814 <close>:
SYSCALL(close)
 814:	b8 15 00 00 00       	mov    $0x15,%eax
 819:	cd 40                	int    $0x40
 81b:	c3                   	ret    

0000081c <kill>:
SYSCALL(kill)
 81c:	b8 06 00 00 00       	mov    $0x6,%eax
 821:	cd 40                	int    $0x40
 823:	c3                   	ret    

00000824 <exec>:
SYSCALL(exec)
 824:	b8 07 00 00 00       	mov    $0x7,%eax
 829:	cd 40                	int    $0x40
 82b:	c3                   	ret    

0000082c <open>:
SYSCALL(open)
 82c:	b8 0f 00 00 00       	mov    $0xf,%eax
 831:	cd 40                	int    $0x40
 833:	c3                   	ret    

00000834 <mknod>:
SYSCALL(mknod)
 834:	b8 11 00 00 00       	mov    $0x11,%eax
 839:	cd 40                	int    $0x40
 83b:	c3                   	ret    

0000083c <unlink>:
SYSCALL(unlink)
 83c:	b8 12 00 00 00       	mov    $0x12,%eax
 841:	cd 40                	int    $0x40
 843:	c3                   	ret    

00000844 <fstat>:
SYSCALL(fstat)
 844:	b8 08 00 00 00       	mov    $0x8,%eax
 849:	cd 40                	int    $0x40
 84b:	c3                   	ret    

0000084c <link>:
SYSCALL(link)
 84c:	b8 13 00 00 00       	mov    $0x13,%eax
 851:	cd 40                	int    $0x40
 853:	c3                   	ret    

00000854 <mkdir>:
SYSCALL(mkdir)
 854:	b8 14 00 00 00       	mov    $0x14,%eax
 859:	cd 40                	int    $0x40
 85b:	c3                   	ret    

0000085c <chdir>:
SYSCALL(chdir)
 85c:	b8 09 00 00 00       	mov    $0x9,%eax
 861:	cd 40                	int    $0x40
 863:	c3                   	ret    

00000864 <dup>:
SYSCALL(dup)
 864:	b8 0a 00 00 00       	mov    $0xa,%eax
 869:	cd 40                	int    $0x40
 86b:	c3                   	ret    

0000086c <getpid>:
SYSCALL(getpid)
 86c:	b8 0b 00 00 00       	mov    $0xb,%eax
 871:	cd 40                	int    $0x40
 873:	c3                   	ret    

00000874 <sbrk>:
SYSCALL(sbrk)
 874:	b8 0c 00 00 00       	mov    $0xc,%eax
 879:	cd 40                	int    $0x40
 87b:	c3                   	ret    

0000087c <sleep>:
SYSCALL(sleep)
 87c:	b8 0d 00 00 00       	mov    $0xd,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <uptime>:
SYSCALL(uptime)
 884:	b8 0e 00 00 00       	mov    $0xe,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 88c:	55                   	push   %ebp
 88d:	89 e5                	mov    %esp,%ebp
 88f:	83 ec 18             	sub    $0x18,%esp
 892:	8b 45 0c             	mov    0xc(%ebp),%eax
 895:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 898:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 89f:	00 
 8a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	89 04 24             	mov    %eax,(%esp)
 8ad:	e8 5a ff ff ff       	call   80c <write>
}
 8b2:	c9                   	leave  
 8b3:	c3                   	ret    

000008b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8b4:	55                   	push   %ebp
 8b5:	89 e5                	mov    %esp,%ebp
 8b7:	56                   	push   %esi
 8b8:	53                   	push   %ebx
 8b9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 8bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 8c3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 8c7:	74 17                	je     8e0 <printint+0x2c>
 8c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8cd:	79 11                	jns    8e0 <printint+0x2c>
    neg = 1;
 8cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 8d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d9:	f7 d8                	neg    %eax
 8db:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8de:	eb 06                	jmp    8e6 <printint+0x32>
  } else {
    x = xx;
 8e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 8e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8f0:	8d 41 01             	lea    0x1(%ecx),%eax
 8f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8fc:	ba 00 00 00 00       	mov    $0x0,%edx
 901:	f7 f3                	div    %ebx
 903:	89 d0                	mov    %edx,%eax
 905:	8a 80 4c 11 00 00    	mov    0x114c(%eax),%al
 90b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 90f:	8b 75 10             	mov    0x10(%ebp),%esi
 912:	8b 45 ec             	mov    -0x14(%ebp),%eax
 915:	ba 00 00 00 00       	mov    $0x0,%edx
 91a:	f7 f6                	div    %esi
 91c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 91f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 923:	75 c8                	jne    8ed <printint+0x39>
  if(neg)
 925:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 929:	74 10                	je     93b <printint+0x87>
    buf[i++] = '-';
 92b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92e:	8d 50 01             	lea    0x1(%eax),%edx
 931:	89 55 f4             	mov    %edx,-0xc(%ebp)
 934:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 939:	eb 1e                	jmp    959 <printint+0xa5>
 93b:	eb 1c                	jmp    959 <printint+0xa5>
    putc(fd, buf[i]);
 93d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 940:	8b 45 f4             	mov    -0xc(%ebp),%eax
 943:	01 d0                	add    %edx,%eax
 945:	8a 00                	mov    (%eax),%al
 947:	0f be c0             	movsbl %al,%eax
 94a:	89 44 24 04          	mov    %eax,0x4(%esp)
 94e:	8b 45 08             	mov    0x8(%ebp),%eax
 951:	89 04 24             	mov    %eax,(%esp)
 954:	e8 33 ff ff ff       	call   88c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 959:	ff 4d f4             	decl   -0xc(%ebp)
 95c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 960:	79 db                	jns    93d <printint+0x89>
    putc(fd, buf[i]);
}
 962:	83 c4 30             	add    $0x30,%esp
 965:	5b                   	pop    %ebx
 966:	5e                   	pop    %esi
 967:	5d                   	pop    %ebp
 968:	c3                   	ret    

00000969 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 969:	55                   	push   %ebp
 96a:	89 e5                	mov    %esp,%ebp
 96c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 96f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 976:	8d 45 0c             	lea    0xc(%ebp),%eax
 979:	83 c0 04             	add    $0x4,%eax
 97c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 97f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 986:	e9 77 01 00 00       	jmp    b02 <printf+0x199>
    c = fmt[i] & 0xff;
 98b:	8b 55 0c             	mov    0xc(%ebp),%edx
 98e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 991:	01 d0                	add    %edx,%eax
 993:	8a 00                	mov    (%eax),%al
 995:	0f be c0             	movsbl %al,%eax
 998:	25 ff 00 00 00       	and    $0xff,%eax
 99d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9a4:	75 2c                	jne    9d2 <printf+0x69>
      if(c == '%'){
 9a6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9aa:	75 0c                	jne    9b8 <printf+0x4f>
        state = '%';
 9ac:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 9b3:	e9 47 01 00 00       	jmp    aff <printf+0x196>
      } else {
        putc(fd, c);
 9b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9bb:	0f be c0             	movsbl %al,%eax
 9be:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c2:	8b 45 08             	mov    0x8(%ebp),%eax
 9c5:	89 04 24             	mov    %eax,(%esp)
 9c8:	e8 bf fe ff ff       	call   88c <putc>
 9cd:	e9 2d 01 00 00       	jmp    aff <printf+0x196>
      }
    } else if(state == '%'){
 9d2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 9d6:	0f 85 23 01 00 00    	jne    aff <printf+0x196>
      if(c == 'd'){
 9dc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 9e0:	75 2d                	jne    a0f <printf+0xa6>
        printint(fd, *ap, 10, 1);
 9e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9e5:	8b 00                	mov    (%eax),%eax
 9e7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 9ee:	00 
 9ef:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 9f6:	00 
 9f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9fb:	8b 45 08             	mov    0x8(%ebp),%eax
 9fe:	89 04 24             	mov    %eax,(%esp)
 a01:	e8 ae fe ff ff       	call   8b4 <printint>
        ap++;
 a06:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a0a:	e9 e9 00 00 00       	jmp    af8 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a0f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a13:	74 06                	je     a1b <printf+0xb2>
 a15:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a19:	75 2d                	jne    a48 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a1e:	8b 00                	mov    (%eax),%eax
 a20:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a27:	00 
 a28:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a2f:	00 
 a30:	89 44 24 04          	mov    %eax,0x4(%esp)
 a34:	8b 45 08             	mov    0x8(%ebp),%eax
 a37:	89 04 24             	mov    %eax,(%esp)
 a3a:	e8 75 fe ff ff       	call   8b4 <printint>
        ap++;
 a3f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a43:	e9 b0 00 00 00       	jmp    af8 <printf+0x18f>
      } else if(c == 's'){
 a48:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a4c:	75 42                	jne    a90 <printf+0x127>
        s = (char*)*ap;
 a4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a51:	8b 00                	mov    (%eax),%eax
 a53:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a56:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a5e:	75 09                	jne    a69 <printf+0x100>
          s = "(null)";
 a60:	c7 45 f4 67 0d 00 00 	movl   $0xd67,-0xc(%ebp)
        while(*s != 0){
 a67:	eb 1c                	jmp    a85 <printf+0x11c>
 a69:	eb 1a                	jmp    a85 <printf+0x11c>
          putc(fd, *s);
 a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6e:	8a 00                	mov    (%eax),%al
 a70:	0f be c0             	movsbl %al,%eax
 a73:	89 44 24 04          	mov    %eax,0x4(%esp)
 a77:	8b 45 08             	mov    0x8(%ebp),%eax
 a7a:	89 04 24             	mov    %eax,(%esp)
 a7d:	e8 0a fe ff ff       	call   88c <putc>
          s++;
 a82:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	8a 00                	mov    (%eax),%al
 a8a:	84 c0                	test   %al,%al
 a8c:	75 dd                	jne    a6b <printf+0x102>
 a8e:	eb 68                	jmp    af8 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a90:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a94:	75 1d                	jne    ab3 <printf+0x14a>
        putc(fd, *ap);
 a96:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a99:	8b 00                	mov    (%eax),%eax
 a9b:	0f be c0             	movsbl %al,%eax
 a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
 aa2:	8b 45 08             	mov    0x8(%ebp),%eax
 aa5:	89 04 24             	mov    %eax,(%esp)
 aa8:	e8 df fd ff ff       	call   88c <putc>
        ap++;
 aad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ab1:	eb 45                	jmp    af8 <printf+0x18f>
      } else if(c == '%'){
 ab3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ab7:	75 17                	jne    ad0 <printf+0x167>
        putc(fd, c);
 ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 abc:	0f be c0             	movsbl %al,%eax
 abf:	89 44 24 04          	mov    %eax,0x4(%esp)
 ac3:	8b 45 08             	mov    0x8(%ebp),%eax
 ac6:	89 04 24             	mov    %eax,(%esp)
 ac9:	e8 be fd ff ff       	call   88c <putc>
 ace:	eb 28                	jmp    af8 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ad0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 ad7:	00 
 ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 adb:	89 04 24             	mov    %eax,(%esp)
 ade:	e8 a9 fd ff ff       	call   88c <putc>
        putc(fd, c);
 ae3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ae6:	0f be c0             	movsbl %al,%eax
 ae9:	89 44 24 04          	mov    %eax,0x4(%esp)
 aed:	8b 45 08             	mov    0x8(%ebp),%eax
 af0:	89 04 24             	mov    %eax,(%esp)
 af3:	e8 94 fd ff ff       	call   88c <putc>
      }
      state = 0;
 af8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 aff:	ff 45 f0             	incl   -0x10(%ebp)
 b02:	8b 55 0c             	mov    0xc(%ebp),%edx
 b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b08:	01 d0                	add    %edx,%eax
 b0a:	8a 00                	mov    (%eax),%al
 b0c:	84 c0                	test   %al,%al
 b0e:	0f 85 77 fe ff ff    	jne    98b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b14:	c9                   	leave  
 b15:	c3                   	ret    
 b16:	90                   	nop
 b17:	90                   	nop

00000b18 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b18:	55                   	push   %ebp
 b19:	89 e5                	mov    %esp,%ebp
 b1b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b1e:	8b 45 08             	mov    0x8(%ebp),%eax
 b21:	83 e8 08             	sub    $0x8,%eax
 b24:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b27:	a1 70 11 00 00       	mov    0x1170,%eax
 b2c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b2f:	eb 24                	jmp    b55 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b34:	8b 00                	mov    (%eax),%eax
 b36:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b39:	77 12                	ja     b4d <free+0x35>
 b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b3e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b41:	77 24                	ja     b67 <free+0x4f>
 b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b46:	8b 00                	mov    (%eax),%eax
 b48:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b4b:	77 1a                	ja     b67 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b50:	8b 00                	mov    (%eax),%eax
 b52:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b55:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b58:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b5b:	76 d4                	jbe    b31 <free+0x19>
 b5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b60:	8b 00                	mov    (%eax),%eax
 b62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b65:	76 ca                	jbe    b31 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b67:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b6a:	8b 40 04             	mov    0x4(%eax),%eax
 b6d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b74:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b77:	01 c2                	add    %eax,%edx
 b79:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b7c:	8b 00                	mov    (%eax),%eax
 b7e:	39 c2                	cmp    %eax,%edx
 b80:	75 24                	jne    ba6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b82:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b85:	8b 50 04             	mov    0x4(%eax),%edx
 b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b8b:	8b 00                	mov    (%eax),%eax
 b8d:	8b 40 04             	mov    0x4(%eax),%eax
 b90:	01 c2                	add    %eax,%edx
 b92:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b95:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b9b:	8b 00                	mov    (%eax),%eax
 b9d:	8b 10                	mov    (%eax),%edx
 b9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ba2:	89 10                	mov    %edx,(%eax)
 ba4:	eb 0a                	jmp    bb0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ba6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba9:	8b 10                	mov    (%eax),%edx
 bab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 bb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb3:	8b 40 04             	mov    0x4(%eax),%eax
 bb6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc0:	01 d0                	add    %edx,%eax
 bc2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bc5:	75 20                	jne    be7 <free+0xcf>
    p->s.size += bp->s.size;
 bc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bca:	8b 50 04             	mov    0x4(%eax),%edx
 bcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd0:	8b 40 04             	mov    0x4(%eax),%eax
 bd3:	01 c2                	add    %eax,%edx
 bd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bde:	8b 10                	mov    (%eax),%edx
 be0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be3:	89 10                	mov    %edx,(%eax)
 be5:	eb 08                	jmp    bef <free+0xd7>
  } else
    p->s.ptr = bp;
 be7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bea:	8b 55 f8             	mov    -0x8(%ebp),%edx
 bed:	89 10                	mov    %edx,(%eax)
  freep = p;
 bef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf2:	a3 70 11 00 00       	mov    %eax,0x1170
}
 bf7:	c9                   	leave  
 bf8:	c3                   	ret    

00000bf9 <morecore>:

static Header*
morecore(uint nu)
{
 bf9:	55                   	push   %ebp
 bfa:	89 e5                	mov    %esp,%ebp
 bfc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 bff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c06:	77 07                	ja     c0f <morecore+0x16>
    nu = 4096;
 c08:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c0f:	8b 45 08             	mov    0x8(%ebp),%eax
 c12:	c1 e0 03             	shl    $0x3,%eax
 c15:	89 04 24             	mov    %eax,(%esp)
 c18:	e8 57 fc ff ff       	call   874 <sbrk>
 c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c20:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c24:	75 07                	jne    c2d <morecore+0x34>
    return 0;
 c26:	b8 00 00 00 00       	mov    $0x0,%eax
 c2b:	eb 22                	jmp    c4f <morecore+0x56>
  hp = (Header*)p;
 c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c33:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c36:	8b 55 08             	mov    0x8(%ebp),%edx
 c39:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c3f:	83 c0 08             	add    $0x8,%eax
 c42:	89 04 24             	mov    %eax,(%esp)
 c45:	e8 ce fe ff ff       	call   b18 <free>
  return freep;
 c4a:	a1 70 11 00 00       	mov    0x1170,%eax
}
 c4f:	c9                   	leave  
 c50:	c3                   	ret    

00000c51 <malloc>:

void*
malloc(uint nbytes)
{
 c51:	55                   	push   %ebp
 c52:	89 e5                	mov    %esp,%ebp
 c54:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c57:	8b 45 08             	mov    0x8(%ebp),%eax
 c5a:	83 c0 07             	add    $0x7,%eax
 c5d:	c1 e8 03             	shr    $0x3,%eax
 c60:	40                   	inc    %eax
 c61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c64:	a1 70 11 00 00       	mov    0x1170,%eax
 c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c70:	75 23                	jne    c95 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 c72:	c7 45 f0 68 11 00 00 	movl   $0x1168,-0x10(%ebp)
 c79:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c7c:	a3 70 11 00 00       	mov    %eax,0x1170
 c81:	a1 70 11 00 00       	mov    0x1170,%eax
 c86:	a3 68 11 00 00       	mov    %eax,0x1168
    base.s.size = 0;
 c8b:	c7 05 6c 11 00 00 00 	movl   $0x0,0x116c
 c92:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c95:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c98:	8b 00                	mov    (%eax),%eax
 c9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca0:	8b 40 04             	mov    0x4(%eax),%eax
 ca3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ca6:	72 4d                	jb     cf5 <malloc+0xa4>
      if(p->s.size == nunits)
 ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cab:	8b 40 04             	mov    0x4(%eax),%eax
 cae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cb1:	75 0c                	jne    cbf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb6:	8b 10                	mov    (%eax),%edx
 cb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cbb:	89 10                	mov    %edx,(%eax)
 cbd:	eb 26                	jmp    ce5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cc2:	8b 40 04             	mov    0x4(%eax),%eax
 cc5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 cc8:	89 c2                	mov    %eax,%edx
 cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ccd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 cd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd3:	8b 40 04             	mov    0x4(%eax),%eax
 cd6:	c1 e0 03             	shl    $0x3,%eax
 cd9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cdf:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ce2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ce5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce8:	a3 70 11 00 00       	mov    %eax,0x1170
      return (void*)(p + 1);
 ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf0:	83 c0 08             	add    $0x8,%eax
 cf3:	eb 38                	jmp    d2d <malloc+0xdc>
    }
    if(p == freep)
 cf5:	a1 70 11 00 00       	mov    0x1170,%eax
 cfa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 cfd:	75 1b                	jne    d1a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 cff:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d02:	89 04 24             	mov    %eax,(%esp)
 d05:	e8 ef fe ff ff       	call   bf9 <morecore>
 d0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d11:	75 07                	jne    d1a <malloc+0xc9>
        return 0;
 d13:	b8 00 00 00 00       	mov    $0x0,%eax
 d18:	eb 13                	jmp    d2d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d23:	8b 00                	mov    (%eax),%eax
 d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d28:	e9 70 ff ff ff       	jmp    c9d <malloc+0x4c>
}
 d2d:	c9                   	leave  
 d2e:	c3                   	ret    
