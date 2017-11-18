
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
   c:	e8 dc 01 00 00       	call   1ed <strlen>
  11:	89 44 24 08          	mov    %eax,0x8(%esp)
  15:	8b 45 0c             	mov    0xc(%ebp),%eax
  18:	89 44 24 04          	mov    %eax,0x4(%esp)
  1c:	8b 45 08             	mov    0x8(%ebp),%eax
  1f:	89 04 24             	mov    %eax,(%esp)
  22:	e8 bd 07 00 00       	call   7e4 <write>
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
  2f:	c7 44 24 04 64 08 00 	movl   $0x864,0x4(%esp)
  36:	00 
  37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3e:	e8 bd ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  4a:	eb 1e                	jmp    6a <forktest+0x41>
    pid = fork();
  4c:	e8 6b 07 00 00       	call   7bc <fork>
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
  62:	e8 5d 07 00 00       	call   7c4 <exit>
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
  84:	c7 44 24 04 70 08 00 	movl   $0x870,0x4(%esp)
  8b:	00 
  8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  93:	e8 68 ff ff ff       	call   0 <printf>
    exit();
  98:	e8 27 07 00 00       	call   7c4 <exit>
  }

  for(; n > 0; n--){
  9d:	eb 25                	jmp    c4 <forktest+0x9b>
    if(wait() < 0){
  9f:	e8 28 07 00 00       	call   7cc <wait>
  a4:	85 c0                	test   %eax,%eax
  a6:	79 19                	jns    c1 <forktest+0x98>
      printf(1, "wait stopped early\n");
  a8:	c7 44 24 04 8f 08 00 	movl   $0x88f,0x4(%esp)
  af:	00 
  b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b7:	e8 44 ff ff ff       	call   0 <printf>
      exit();
  bc:	e8 03 07 00 00       	call   7c4 <exit>
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
  ca:	e8 fd 06 00 00       	call   7cc <wait>
  cf:	83 f8 ff             	cmp    $0xffffffff,%eax
  d2:	74 19                	je     ed <forktest+0xc4>
    printf(1, "wait got too many\n");
  d4:	c7 44 24 04 a3 08 00 	movl   $0x8a3,0x4(%esp)
  db:	00 
  dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e3:	e8 18 ff ff ff       	call   0 <printf>
    exit();
  e8:	e8 d7 06 00 00       	call   7c4 <exit>
  }

  printf(1, "fork test OK\n");
  ed:	c7 44 24 04 b6 08 00 	movl   $0x8b6,0x4(%esp)
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
 10e:	e8 b1 06 00 00       	call   7c4 <exit>
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

00000167 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 16a:	eb 06                	jmp    172 <strcmp+0xb>
    p++, q++;
 16c:	ff 45 08             	incl   0x8(%ebp)
 16f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	8a 00                	mov    (%eax),%al
 177:	84 c0                	test   %al,%al
 179:	74 0e                	je     189 <strcmp+0x22>
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	8a 10                	mov    (%eax),%dl
 180:	8b 45 0c             	mov    0xc(%ebp),%eax
 183:	8a 00                	mov    (%eax),%al
 185:	38 c2                	cmp    %al,%dl
 187:	74 e3                	je     16c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
 18c:	8a 00                	mov    (%eax),%al
 18e:	0f b6 d0             	movzbl %al,%edx
 191:	8b 45 0c             	mov    0xc(%ebp),%eax
 194:	8a 00                	mov    (%eax),%al
 196:	0f b6 c0             	movzbl %al,%eax
 199:	29 c2                	sub    %eax,%edx
 19b:	89 d0                	mov    %edx,%eax
}
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    

0000019f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 1a2:	eb 09                	jmp    1ad <strncmp+0xe>
    n--, p++, q++;
 1a4:	ff 4d 10             	decl   0x10(%ebp)
 1a7:	ff 45 08             	incl   0x8(%ebp)
 1aa:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 1ad:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1b1:	74 17                	je     1ca <strncmp+0x2b>
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	8a 00                	mov    (%eax),%al
 1b8:	84 c0                	test   %al,%al
 1ba:	74 0e                	je     1ca <strncmp+0x2b>
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	8a 10                	mov    (%eax),%dl
 1c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c4:	8a 00                	mov    (%eax),%al
 1c6:	38 c2                	cmp    %al,%dl
 1c8:	74 da                	je     1a4 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 1ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1ce:	75 07                	jne    1d7 <strncmp+0x38>
    return 0;
 1d0:	b8 00 00 00 00       	mov    $0x0,%eax
 1d5:	eb 14                	jmp    1eb <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	8a 00                	mov    (%eax),%al
 1dc:	0f b6 d0             	movzbl %al,%edx
 1df:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e2:	8a 00                	mov    (%eax),%al
 1e4:	0f b6 c0             	movzbl %al,%eax
 1e7:	29 c2                	sub    %eax,%edx
 1e9:	89 d0                	mov    %edx,%eax
}
 1eb:	5d                   	pop    %ebp
 1ec:	c3                   	ret    

000001ed <strlen>:

uint
strlen(const char *s)
{
 1ed:	55                   	push   %ebp
 1ee:	89 e5                	mov    %esp,%ebp
 1f0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1f3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1fa:	eb 03                	jmp    1ff <strlen+0x12>
 1fc:	ff 45 fc             	incl   -0x4(%ebp)
 1ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	01 d0                	add    %edx,%eax
 207:	8a 00                	mov    (%eax),%al
 209:	84 c0                	test   %al,%al
 20b:	75 ef                	jne    1fc <strlen+0xf>
    ;
  return n;
 20d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 210:	c9                   	leave  
 211:	c3                   	ret    

00000212 <memset>:

void*
memset(void *dst, int c, uint n)
{
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
 215:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 218:	8b 45 10             	mov    0x10(%ebp),%eax
 21b:	89 44 24 08          	mov    %eax,0x8(%esp)
 21f:	8b 45 0c             	mov    0xc(%ebp),%eax
 222:	89 44 24 04          	mov    %eax,0x4(%esp)
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	89 04 24             	mov    %eax,(%esp)
 22c:	e8 e3 fe ff ff       	call   114 <stosb>
  return dst;
 231:	8b 45 08             	mov    0x8(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <strchr>:

char*
strchr(const char *s, char c)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	8b 45 0c             	mov    0xc(%ebp),%eax
 23f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 242:	eb 12                	jmp    256 <strchr+0x20>
    if(*s == c)
 244:	8b 45 08             	mov    0x8(%ebp),%eax
 247:	8a 00                	mov    (%eax),%al
 249:	3a 45 fc             	cmp    -0x4(%ebp),%al
 24c:	75 05                	jne    253 <strchr+0x1d>
      return (char*)s;
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	eb 11                	jmp    264 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 253:	ff 45 08             	incl   0x8(%ebp)
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8a 00                	mov    (%eax),%al
 25b:	84 c0                	test   %al,%al
 25d:	75 e5                	jne    244 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 25f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <strcat>:

char *
strcat(char *dest, const char *src)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 26c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 273:	eb 03                	jmp    278 <strcat+0x12>
 275:	ff 45 fc             	incl   -0x4(%ebp)
 278:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	01 d0                	add    %edx,%eax
 280:	8a 00                	mov    (%eax),%al
 282:	84 c0                	test   %al,%al
 284:	75 ef                	jne    275 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 286:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 28d:	eb 1e                	jmp    2ad <strcat+0x47>
        dest[i+j] = src[j];
 28f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 292:	8b 55 fc             	mov    -0x4(%ebp),%edx
 295:	01 d0                	add    %edx,%eax
 297:	89 c2                	mov    %eax,%edx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	01 c2                	add    %eax,%edx
 29e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	01 c8                	add    %ecx,%eax
 2a6:	8a 00                	mov    (%eax),%al
 2a8:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 2aa:	ff 45 f8             	incl   -0x8(%ebp)
 2ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b3:	01 d0                	add    %edx,%eax
 2b5:	8a 00                	mov    (%eax),%al
 2b7:	84 c0                	test   %al,%al
 2b9:	75 d4                	jne    28f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 2bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c1:	01 d0                	add    %edx,%eax
 2c3:	89 c2                	mov    %eax,%edx
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	01 d0                	add    %edx,%eax
 2ca:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <strstr>:

int 
strstr(char* s, char* sub)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2df:	eb 7c                	jmp    35d <strstr+0x8b>
    {
        if(s[i] == sub[0])
 2e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	01 d0                	add    %edx,%eax
 2e9:	8a 10                	mov    (%eax),%dl
 2eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ee:	8a 00                	mov    (%eax),%al
 2f0:	38 c2                	cmp    %al,%dl
 2f2:	75 66                	jne    35a <strstr+0x88>
        {
            if(strlen(sub) == 1)
 2f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f7:	89 04 24             	mov    %eax,(%esp)
 2fa:	e8 ee fe ff ff       	call   1ed <strlen>
 2ff:	83 f8 01             	cmp    $0x1,%eax
 302:	75 05                	jne    309 <strstr+0x37>
            {  
                return i;
 304:	8b 45 fc             	mov    -0x4(%ebp),%eax
 307:	eb 6b                	jmp    374 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 309:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 310:	eb 3a                	jmp    34c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 312:	8b 45 f8             	mov    -0x8(%ebp),%eax
 315:	8b 55 fc             	mov    -0x4(%ebp),%edx
 318:	01 d0                	add    %edx,%eax
 31a:	89 c2                	mov    %eax,%edx
 31c:	8b 45 08             	mov    0x8(%ebp),%eax
 31f:	01 d0                	add    %edx,%eax
 321:	8a 10                	mov    (%eax),%dl
 323:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 326:	8b 45 0c             	mov    0xc(%ebp),%eax
 329:	01 c8                	add    %ecx,%eax
 32b:	8a 00                	mov    (%eax),%al
 32d:	38 c2                	cmp    %al,%dl
 32f:	75 16                	jne    347 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 331:	8b 45 f8             	mov    -0x8(%ebp),%eax
 334:	8d 50 01             	lea    0x1(%eax),%edx
 337:	8b 45 0c             	mov    0xc(%ebp),%eax
 33a:	01 d0                	add    %edx,%eax
 33c:	8a 00                	mov    (%eax),%al
 33e:	84 c0                	test   %al,%al
 340:	75 07                	jne    349 <strstr+0x77>
                    {
                        return i;
 342:	8b 45 fc             	mov    -0x4(%ebp),%eax
 345:	eb 2d                	jmp    374 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 347:	eb 11                	jmp    35a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 349:	ff 45 f8             	incl   -0x8(%ebp)
 34c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 34f:	8b 45 0c             	mov    0xc(%ebp),%eax
 352:	01 d0                	add    %edx,%eax
 354:	8a 00                	mov    (%eax),%al
 356:	84 c0                	test   %al,%al
 358:	75 b8                	jne    312 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 35a:	ff 45 fc             	incl   -0x4(%ebp)
 35d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	01 d0                	add    %edx,%eax
 365:	8a 00                	mov    (%eax),%al
 367:	84 c0                	test   %al,%al
 369:	0f 85 72 ff ff ff    	jne    2e1 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 36f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 374:	c9                   	leave  
 375:	c3                   	ret    

00000376 <strtok>:

char *
strtok(char *s, const char *delim)
{
 376:	55                   	push   %ebp
 377:	89 e5                	mov    %esp,%ebp
 379:	53                   	push   %ebx
 37a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 37d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 381:	75 08                	jne    38b <strtok+0x15>
  s = lasts;
 383:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 388:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	8d 50 01             	lea    0x1(%eax),%edx
 391:	89 55 08             	mov    %edx,0x8(%ebp)
 394:	8a 00                	mov    (%eax),%al
 396:	0f be d8             	movsbl %al,%ebx
 399:	85 db                	test   %ebx,%ebx
 39b:	75 07                	jne    3a4 <strtok+0x2e>
      return 0;
 39d:	b8 00 00 00 00       	mov    $0x0,%eax
 3a2:	eb 58                	jmp    3fc <strtok+0x86>
    } while (strchr(delim, ch));
 3a4:	88 d8                	mov    %bl,%al
 3a6:	0f be c0             	movsbl %al,%eax
 3a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b0:	89 04 24             	mov    %eax,(%esp)
 3b3:	e8 7e fe ff ff       	call   236 <strchr>
 3b8:	85 c0                	test   %eax,%eax
 3ba:	75 cf                	jne    38b <strtok+0x15>
    --s;
 3bc:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 3bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3c6:	8b 45 08             	mov    0x8(%ebp),%eax
 3c9:	89 04 24             	mov    %eax,(%esp)
 3cc:	e8 31 00 00 00       	call   402 <strcspn>
 3d1:	89 c2                	mov    %eax,%edx
 3d3:	8b 45 08             	mov    0x8(%ebp),%eax
 3d6:	01 d0                	add    %edx,%eax
 3d8:	a3 f0 0b 00 00       	mov    %eax,0xbf0
    if (*lasts != 0)
 3dd:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 3e2:	8a 00                	mov    (%eax),%al
 3e4:	84 c0                	test   %al,%al
 3e6:	74 11                	je     3f9 <strtok+0x83>
  *lasts++ = 0;
 3e8:	a1 f0 0b 00 00       	mov    0xbf0,%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 15 f0 0b 00 00    	mov    %edx,0xbf0
 3f6:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3fc:	83 c4 14             	add    $0x14,%esp
 3ff:	5b                   	pop    %ebx
 400:	5d                   	pop    %ebp
 401:	c3                   	ret    

00000402 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 402:	55                   	push   %ebp
 403:	89 e5                	mov    %esp,%ebp
 405:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 408:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 40f:	eb 26                	jmp    437 <strcspn+0x35>
        if(strchr(s2,*s1))
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	8a 00                	mov    (%eax),%al
 416:	0f be c0             	movsbl %al,%eax
 419:	89 44 24 04          	mov    %eax,0x4(%esp)
 41d:	8b 45 0c             	mov    0xc(%ebp),%eax
 420:	89 04 24             	mov    %eax,(%esp)
 423:	e8 0e fe ff ff       	call   236 <strchr>
 428:	85 c0                	test   %eax,%eax
 42a:	74 05                	je     431 <strcspn+0x2f>
            return ret;
 42c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 42f:	eb 12                	jmp    443 <strcspn+0x41>
        else
            s1++,ret++;
 431:	ff 45 08             	incl   0x8(%ebp)
 434:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	8a 00                	mov    (%eax),%al
 43c:	84 c0                	test   %al,%al
 43e:	75 d1                	jne    411 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 440:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 443:	c9                   	leave  
 444:	c3                   	ret    

00000445 <isspace>:

int
isspace(unsigned char c)
{
 445:	55                   	push   %ebp
 446:	89 e5                	mov    %esp,%ebp
 448:	83 ec 04             	sub    $0x4,%esp
 44b:	8b 45 08             	mov    0x8(%ebp),%eax
 44e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 451:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 455:	74 1e                	je     475 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 457:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 45b:	74 18                	je     475 <isspace+0x30>
 45d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 461:	74 12                	je     475 <isspace+0x30>
 463:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 467:	74 0c                	je     475 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 469:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 46d:	74 06                	je     475 <isspace+0x30>
 46f:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 473:	75 07                	jne    47c <isspace+0x37>
 475:	b8 01 00 00 00       	mov    $0x1,%eax
 47a:	eb 05                	jmp    481 <isspace+0x3c>
 47c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 481:	c9                   	leave  
 482:	c3                   	ret    

00000483 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 483:	55                   	push   %ebp
 484:	89 e5                	mov    %esp,%ebp
 486:	57                   	push   %edi
 487:	56                   	push   %esi
 488:	53                   	push   %ebx
 489:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 48c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 491:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 498:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 49b:	eb 01                	jmp    49e <strtoul+0x1b>
  p += 1;
 49d:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 49e:	8a 03                	mov    (%ebx),%al
 4a0:	0f b6 c0             	movzbl %al,%eax
 4a3:	89 04 24             	mov    %eax,(%esp)
 4a6:	e8 9a ff ff ff       	call   445 <isspace>
 4ab:	85 c0                	test   %eax,%eax
 4ad:	75 ee                	jne    49d <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 4af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4b3:	75 30                	jne    4e5 <strtoul+0x62>
    {
  if (*p == '0') {
 4b5:	8a 03                	mov    (%ebx),%al
 4b7:	3c 30                	cmp    $0x30,%al
 4b9:	75 21                	jne    4dc <strtoul+0x59>
      p += 1;
 4bb:	43                   	inc    %ebx
      if (*p == 'x') {
 4bc:	8a 03                	mov    (%ebx),%al
 4be:	3c 78                	cmp    $0x78,%al
 4c0:	75 0a                	jne    4cc <strtoul+0x49>
    p += 1;
 4c2:	43                   	inc    %ebx
    base = 16;
 4c3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 4ca:	eb 31                	jmp    4fd <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 4cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 4d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 4da:	eb 21                	jmp    4fd <strtoul+0x7a>
      }
  }
  else base = 10;
 4dc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 4e3:	eb 18                	jmp    4fd <strtoul+0x7a>
    } else if (base == 16) {
 4e5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4e9:	75 12                	jne    4fd <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 4eb:	8a 03                	mov    (%ebx),%al
 4ed:	3c 30                	cmp    $0x30,%al
 4ef:	75 0c                	jne    4fd <strtoul+0x7a>
 4f1:	8d 43 01             	lea    0x1(%ebx),%eax
 4f4:	8a 00                	mov    (%eax),%al
 4f6:	3c 78                	cmp    $0x78,%al
 4f8:	75 03                	jne    4fd <strtoul+0x7a>
      p += 2;
 4fa:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 4fd:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 501:	75 29                	jne    52c <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 503:	8a 03                	mov    (%ebx),%al
 505:	0f be c0             	movsbl %al,%eax
 508:	83 e8 30             	sub    $0x30,%eax
 50b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 50d:	83 fe 07             	cmp    $0x7,%esi
 510:	76 06                	jbe    518 <strtoul+0x95>
    break;
 512:	90                   	nop
 513:	e9 b6 00 00 00       	jmp    5ce <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 518:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 51f:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 522:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 529:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 52a:	eb d7                	jmp    503 <strtoul+0x80>
    } else if (base == 10) {
 52c:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 530:	75 2b                	jne    55d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 532:	8a 03                	mov    (%ebx),%al
 534:	0f be c0             	movsbl %al,%eax
 537:	83 e8 30             	sub    $0x30,%eax
 53a:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 53c:	83 fe 09             	cmp    $0x9,%esi
 53f:	76 06                	jbe    547 <strtoul+0xc4>
    break;
 541:	90                   	nop
 542:	e9 87 00 00 00       	jmp    5ce <strtoul+0x14b>
      }
      result = (10*result) + digit;
 547:	89 f8                	mov    %edi,%eax
 549:	c1 e0 02             	shl    $0x2,%eax
 54c:	01 f8                	add    %edi,%eax
 54e:	01 c0                	add    %eax,%eax
 550:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 553:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 55a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 55b:	eb d5                	jmp    532 <strtoul+0xaf>
    } else if (base == 16) {
 55d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 561:	75 35                	jne    598 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 563:	8a 03                	mov    (%ebx),%al
 565:	0f be c0             	movsbl %al,%eax
 568:	83 e8 30             	sub    $0x30,%eax
 56b:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 56d:	83 fe 4a             	cmp    $0x4a,%esi
 570:	76 02                	jbe    574 <strtoul+0xf1>
    break;
 572:	eb 22                	jmp    596 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 574:	8a 86 a0 0b 00 00    	mov    0xba0(%esi),%al
 57a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 57d:	83 fe 0f             	cmp    $0xf,%esi
 580:	76 02                	jbe    584 <strtoul+0x101>
    break;
 582:	eb 12                	jmp    596 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 584:	89 f8                	mov    %edi,%eax
 586:	c1 e0 04             	shl    $0x4,%eax
 589:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 58c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 593:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 594:	eb cd                	jmp    563 <strtoul+0xe0>
 596:	eb 36                	jmp    5ce <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 598:	8a 03                	mov    (%ebx),%al
 59a:	0f be c0             	movsbl %al,%eax
 59d:	83 e8 30             	sub    $0x30,%eax
 5a0:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5a2:	83 fe 4a             	cmp    $0x4a,%esi
 5a5:	76 02                	jbe    5a9 <strtoul+0x126>
    break;
 5a7:	eb 25                	jmp    5ce <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 5a9:	8a 86 a0 0b 00 00    	mov    0xba0(%esi),%al
 5af:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 5b2:	8b 45 10             	mov    0x10(%ebp),%eax
 5b5:	39 f0                	cmp    %esi,%eax
 5b7:	77 02                	ja     5bb <strtoul+0x138>
    break;
 5b9:	eb 13                	jmp    5ce <strtoul+0x14b>
      }
      result = result*base + digit;
 5bb:	8b 45 10             	mov    0x10(%ebp),%eax
 5be:	0f af c7             	imul   %edi,%eax
 5c1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5c4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 5cb:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 5cc:	eb ca                	jmp    598 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 5ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5d2:	75 03                	jne    5d7 <strtoul+0x154>
  p = string;
 5d4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 5d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5db:	74 05                	je     5e2 <strtoul+0x15f>
  *endPtr = p;
 5dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e0:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 5e2:	89 f8                	mov    %edi,%eax
}
 5e4:	83 c4 14             	add    $0x14,%esp
 5e7:	5b                   	pop    %ebx
 5e8:	5e                   	pop    %esi
 5e9:	5f                   	pop    %edi
 5ea:	5d                   	pop    %ebp
 5eb:	c3                   	ret    

000005ec <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 5ec:	55                   	push   %ebp
 5ed:	89 e5                	mov    %esp,%ebp
 5ef:	53                   	push   %ebx
 5f0:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 5f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 5f6:	eb 01                	jmp    5f9 <strtol+0xd>
      p += 1;
 5f8:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 5f9:	8a 03                	mov    (%ebx),%al
 5fb:	0f b6 c0             	movzbl %al,%eax
 5fe:	89 04 24             	mov    %eax,(%esp)
 601:	e8 3f fe ff ff       	call   445 <isspace>
 606:	85 c0                	test   %eax,%eax
 608:	75 ee                	jne    5f8 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 60a:	8a 03                	mov    (%ebx),%al
 60c:	3c 2d                	cmp    $0x2d,%al
 60e:	75 1e                	jne    62e <strtol+0x42>
  p += 1;
 610:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 611:	8b 45 10             	mov    0x10(%ebp),%eax
 614:	89 44 24 08          	mov    %eax,0x8(%esp)
 618:	8b 45 0c             	mov    0xc(%ebp),%eax
 61b:	89 44 24 04          	mov    %eax,0x4(%esp)
 61f:	89 1c 24             	mov    %ebx,(%esp)
 622:	e8 5c fe ff ff       	call   483 <strtoul>
 627:	f7 d8                	neg    %eax
 629:	89 45 f8             	mov    %eax,-0x8(%ebp)
 62c:	eb 20                	jmp    64e <strtol+0x62>
    } else {
  if (*p == '+') {
 62e:	8a 03                	mov    (%ebx),%al
 630:	3c 2b                	cmp    $0x2b,%al
 632:	75 01                	jne    635 <strtol+0x49>
      p += 1;
 634:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 635:	8b 45 10             	mov    0x10(%ebp),%eax
 638:	89 44 24 08          	mov    %eax,0x8(%esp)
 63c:	8b 45 0c             	mov    0xc(%ebp),%eax
 63f:	89 44 24 04          	mov    %eax,0x4(%esp)
 643:	89 1c 24             	mov    %ebx,(%esp)
 646:	e8 38 fe ff ff       	call   483 <strtoul>
 64b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 64e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 652:	75 17                	jne    66b <strtol+0x7f>
 654:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 658:	74 11                	je     66b <strtol+0x7f>
 65a:	8b 45 0c             	mov    0xc(%ebp),%eax
 65d:	8b 00                	mov    (%eax),%eax
 65f:	39 d8                	cmp    %ebx,%eax
 661:	75 08                	jne    66b <strtol+0x7f>
  *endPtr = string;
 663:	8b 45 0c             	mov    0xc(%ebp),%eax
 666:	8b 55 08             	mov    0x8(%ebp),%edx
 669:	89 10                	mov    %edx,(%eax)
    }
    return result;
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 66e:	83 c4 1c             	add    $0x1c,%esp
 671:	5b                   	pop    %ebx
 672:	5d                   	pop    %ebp
 673:	c3                   	ret    

00000674 <gets>:

char*
gets(char *buf, int max)
{
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 67a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 681:	eb 49                	jmp    6cc <gets+0x58>
    cc = read(0, &c, 1);
 683:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 68a:	00 
 68b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 68e:	89 44 24 04          	mov    %eax,0x4(%esp)
 692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 699:	e8 3e 01 00 00       	call   7dc <read>
 69e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6a5:	7f 02                	jg     6a9 <gets+0x35>
      break;
 6a7:	eb 2c                	jmp    6d5 <gets+0x61>
    buf[i++] = c;
 6a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ac:	8d 50 01             	lea    0x1(%eax),%edx
 6af:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6b2:	89 c2                	mov    %eax,%edx
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	01 c2                	add    %eax,%edx
 6b9:	8a 45 ef             	mov    -0x11(%ebp),%al
 6bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6be:	8a 45 ef             	mov    -0x11(%ebp),%al
 6c1:	3c 0a                	cmp    $0xa,%al
 6c3:	74 10                	je     6d5 <gets+0x61>
 6c5:	8a 45 ef             	mov    -0x11(%ebp),%al
 6c8:	3c 0d                	cmp    $0xd,%al
 6ca:	74 09                	je     6d5 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6cf:	40                   	inc    %eax
 6d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6d3:	7c ae                	jl     683 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6d8:	8b 45 08             	mov    0x8(%ebp),%eax
 6db:	01 d0                	add    %edx,%eax
 6dd:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6e3:	c9                   	leave  
 6e4:	c3                   	ret    

000006e5 <stat>:

int
stat(char *n, struct stat *st)
{
 6e5:	55                   	push   %ebp
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 6f2:	00 
 6f3:	8b 45 08             	mov    0x8(%ebp),%eax
 6f6:	89 04 24             	mov    %eax,(%esp)
 6f9:	e8 06 01 00 00       	call   804 <open>
 6fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 701:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 705:	79 07                	jns    70e <stat+0x29>
    return -1;
 707:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 70c:	eb 23                	jmp    731 <stat+0x4c>
  r = fstat(fd, st);
 70e:	8b 45 0c             	mov    0xc(%ebp),%eax
 711:	89 44 24 04          	mov    %eax,0x4(%esp)
 715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 718:	89 04 24             	mov    %eax,(%esp)
 71b:	e8 fc 00 00 00       	call   81c <fstat>
 720:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 723:	8b 45 f4             	mov    -0xc(%ebp),%eax
 726:	89 04 24             	mov    %eax,(%esp)
 729:	e8 be 00 00 00       	call   7ec <close>
  return r;
 72e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 731:	c9                   	leave  
 732:	c3                   	ret    

00000733 <atoi>:

int
atoi(const char *s)
{
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 739:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 740:	eb 24                	jmp    766 <atoi+0x33>
    n = n*10 + *s++ - '0';
 742:	8b 55 fc             	mov    -0x4(%ebp),%edx
 745:	89 d0                	mov    %edx,%eax
 747:	c1 e0 02             	shl    $0x2,%eax
 74a:	01 d0                	add    %edx,%eax
 74c:	01 c0                	add    %eax,%eax
 74e:	89 c1                	mov    %eax,%ecx
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	8d 50 01             	lea    0x1(%eax),%edx
 756:	89 55 08             	mov    %edx,0x8(%ebp)
 759:	8a 00                	mov    (%eax),%al
 75b:	0f be c0             	movsbl %al,%eax
 75e:	01 c8                	add    %ecx,%eax
 760:	83 e8 30             	sub    $0x30,%eax
 763:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 766:	8b 45 08             	mov    0x8(%ebp),%eax
 769:	8a 00                	mov    (%eax),%al
 76b:	3c 2f                	cmp    $0x2f,%al
 76d:	7e 09                	jle    778 <atoi+0x45>
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	8a 00                	mov    (%eax),%al
 774:	3c 39                	cmp    $0x39,%al
 776:	7e ca                	jle    742 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 77b:	c9                   	leave  
 77c:	c3                   	ret    

0000077d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 77d:	55                   	push   %ebp
 77e:	89 e5                	mov    %esp,%ebp
 780:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 783:	8b 45 08             	mov    0x8(%ebp),%eax
 786:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 789:	8b 45 0c             	mov    0xc(%ebp),%eax
 78c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 78f:	eb 16                	jmp    7a7 <memmove+0x2a>
    *dst++ = *src++;
 791:	8b 45 fc             	mov    -0x4(%ebp),%eax
 794:	8d 50 01             	lea    0x1(%eax),%edx
 797:	89 55 fc             	mov    %edx,-0x4(%ebp)
 79a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 79d:	8d 4a 01             	lea    0x1(%edx),%ecx
 7a0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7a3:	8a 12                	mov    (%edx),%dl
 7a5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7a7:	8b 45 10             	mov    0x10(%ebp),%eax
 7aa:	8d 50 ff             	lea    -0x1(%eax),%edx
 7ad:	89 55 10             	mov    %edx,0x10(%ebp)
 7b0:	85 c0                	test   %eax,%eax
 7b2:	7f dd                	jg     791 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7b7:	c9                   	leave  
 7b8:	c3                   	ret    
 7b9:	90                   	nop
 7ba:	90                   	nop
 7bb:	90                   	nop

000007bc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7bc:	b8 01 00 00 00       	mov    $0x1,%eax
 7c1:	cd 40                	int    $0x40
 7c3:	c3                   	ret    

000007c4 <exit>:
SYSCALL(exit)
 7c4:	b8 02 00 00 00       	mov    $0x2,%eax
 7c9:	cd 40                	int    $0x40
 7cb:	c3                   	ret    

000007cc <wait>:
SYSCALL(wait)
 7cc:	b8 03 00 00 00       	mov    $0x3,%eax
 7d1:	cd 40                	int    $0x40
 7d3:	c3                   	ret    

000007d4 <pipe>:
SYSCALL(pipe)
 7d4:	b8 04 00 00 00       	mov    $0x4,%eax
 7d9:	cd 40                	int    $0x40
 7db:	c3                   	ret    

000007dc <read>:
SYSCALL(read)
 7dc:	b8 05 00 00 00       	mov    $0x5,%eax
 7e1:	cd 40                	int    $0x40
 7e3:	c3                   	ret    

000007e4 <write>:
SYSCALL(write)
 7e4:	b8 10 00 00 00       	mov    $0x10,%eax
 7e9:	cd 40                	int    $0x40
 7eb:	c3                   	ret    

000007ec <close>:
SYSCALL(close)
 7ec:	b8 15 00 00 00       	mov    $0x15,%eax
 7f1:	cd 40                	int    $0x40
 7f3:	c3                   	ret    

000007f4 <kill>:
SYSCALL(kill)
 7f4:	b8 06 00 00 00       	mov    $0x6,%eax
 7f9:	cd 40                	int    $0x40
 7fb:	c3                   	ret    

000007fc <exec>:
SYSCALL(exec)
 7fc:	b8 07 00 00 00       	mov    $0x7,%eax
 801:	cd 40                	int    $0x40
 803:	c3                   	ret    

00000804 <open>:
SYSCALL(open)
 804:	b8 0f 00 00 00       	mov    $0xf,%eax
 809:	cd 40                	int    $0x40
 80b:	c3                   	ret    

0000080c <mknod>:
SYSCALL(mknod)
 80c:	b8 11 00 00 00       	mov    $0x11,%eax
 811:	cd 40                	int    $0x40
 813:	c3                   	ret    

00000814 <unlink>:
SYSCALL(unlink)
 814:	b8 12 00 00 00       	mov    $0x12,%eax
 819:	cd 40                	int    $0x40
 81b:	c3                   	ret    

0000081c <fstat>:
SYSCALL(fstat)
 81c:	b8 08 00 00 00       	mov    $0x8,%eax
 821:	cd 40                	int    $0x40
 823:	c3                   	ret    

00000824 <link>:
SYSCALL(link)
 824:	b8 13 00 00 00       	mov    $0x13,%eax
 829:	cd 40                	int    $0x40
 82b:	c3                   	ret    

0000082c <mkdir>:
SYSCALL(mkdir)
 82c:	b8 14 00 00 00       	mov    $0x14,%eax
 831:	cd 40                	int    $0x40
 833:	c3                   	ret    

00000834 <chdir>:
SYSCALL(chdir)
 834:	b8 09 00 00 00       	mov    $0x9,%eax
 839:	cd 40                	int    $0x40
 83b:	c3                   	ret    

0000083c <dup>:
SYSCALL(dup)
 83c:	b8 0a 00 00 00       	mov    $0xa,%eax
 841:	cd 40                	int    $0x40
 843:	c3                   	ret    

00000844 <getpid>:
SYSCALL(getpid)
 844:	b8 0b 00 00 00       	mov    $0xb,%eax
 849:	cd 40                	int    $0x40
 84b:	c3                   	ret    

0000084c <sbrk>:
SYSCALL(sbrk)
 84c:	b8 0c 00 00 00       	mov    $0xc,%eax
 851:	cd 40                	int    $0x40
 853:	c3                   	ret    

00000854 <sleep>:
SYSCALL(sleep)
 854:	b8 0d 00 00 00       	mov    $0xd,%eax
 859:	cd 40                	int    $0x40
 85b:	c3                   	ret    

0000085c <uptime>:
SYSCALL(uptime)
 85c:	b8 0e 00 00 00       	mov    $0xe,%eax
 861:	cd 40                	int    $0x40
 863:	c3                   	ret    
