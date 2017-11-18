
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 c2 00 00 00       	jmp    d4 <grep+0xd4>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 e0 13 00 00       	add    $0x13e0,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 e0 13 00 00 	movl   $0x13e0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 4d                	jmp    79 <grep+0x79>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  35:	89 44 24 04          	mov    %eax,0x4(%esp)
  39:	8b 45 08             	mov    0x8(%ebp),%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 b7 01 00 00       	call   1fb <match>
  44:	85 c0                	test   %eax,%eax
  46:	74 2a                	je     72 <grep+0x72>
        *q = '\n';
  48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4b:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  51:	40                   	inc    %eax
  52:	89 c2                	mov    %eax,%edx
  54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  57:	29 c2                	sub    %eax,%edx
  59:	89 d0                	mov    %edx,%eax
  5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  62:	89 44 24 04          	mov    %eax,0x4(%esp)
  66:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6d:	e8 a6 09 00 00       	call   a18 <write>
      }
      p = q+1;
  72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  75:	40                   	inc    %eax
  76:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    m += n;
    buf[m] = '\0';
    p = buf;
    while((q = strchr(p, '\n')) != 0){
  79:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  80:	00 
  81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 de 03 00 00       	call   46a <strchr>
  8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  93:	75 97                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
  95:	81 7d f0 e0 13 00 00 	cmpl   $0x13e0,-0x10(%ebp)
  9c:	75 07                	jne    a5 <grep+0xa5>
      m = 0;
  9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a9:	7e 29                	jle    d4 <grep+0xd4>
      m -= p - buf;
  ab:	ba e0 13 00 00       	mov    $0x13e0,%edx
  b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b3:	29 c2                	sub    %eax,%edx
  b5:	89 d0                	mov    %edx,%eax
  b7:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	89 44 24 08          	mov    %eax,0x8(%esp)
  c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  c8:	c7 04 24 e0 13 00 00 	movl   $0x13e0,(%esp)
  cf:	e8 dd 08 00 00       	call   9b1 <memmove>
{
  int n, m;
  char *p, *q;

  m = 0;
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d7:	ba ff 03 00 00       	mov    $0x3ff,%edx
  dc:	29 c2                	sub    %eax,%edx
  de:	89 d0                	mov    %edx,%eax
  e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e3:	81 c2 e0 13 00 00    	add    $0x13e0,%edx
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	89 04 24             	mov    %eax,(%esp)
  f7:	e8 14 09 00 00       	call   a10 <read>
  fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 103:	0f 8f 09 ff ff ff    	jg     12 <grep+0x12>
    if(m > 0){
      m -= p - buf;
      memmove(buf, p, m);
    }
  }
}
 109:	c9                   	leave  
 10a:	c3                   	ret    

0000010b <main>:

int
main(int argc, char *argv[])
{
 10b:	55                   	push   %ebp
 10c:	89 e5                	mov    %esp,%ebp
 10e:	83 e4 f0             	and    $0xfffffff0,%esp
 111:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;

  if(argc <= 1){
 114:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 118:	7f 19                	jg     133 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 11a:	c7 44 24 04 3c 0f 00 	movl   $0xf3c,0x4(%esp)
 121:	00 
 122:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 129:	e8 47 0a 00 00       	call   b75 <printf>
    exit();
 12e:	e8 c5 08 00 00       	call   9f8 <exit>
  }
  pattern = argv[1];
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	8b 40 04             	mov    0x4(%eax),%eax
 139:	89 44 24 18          	mov    %eax,0x18(%esp)

  if(argc <= 2){
 13d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 141:	7f 19                	jg     15c <main+0x51>
    grep(pattern, 0);
 143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14a:	00 
 14b:	8b 44 24 18          	mov    0x18(%esp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 a9 fe ff ff       	call   0 <grep>
    exit();
 157:	e8 9c 08 00 00       	call   9f8 <exit>
  }

  for(i = 2; i < argc; i++){
 15c:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 163:	00 
 164:	e9 80 00 00 00       	jmp    1e9 <main+0xde>
    if((fd = open(argv[i], 0)) < 0){
 169:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 16d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	01 d0                	add    %edx,%eax
 179:	8b 00                	mov    (%eax),%eax
 17b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 182:	00 
 183:	89 04 24             	mov    %eax,(%esp)
 186:	e8 ad 08 00 00       	call   a38 <open>
 18b:	89 44 24 14          	mov    %eax,0x14(%esp)
 18f:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 194:	79 2f                	jns    1c5 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 196:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 19a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a4:	01 d0                	add    %edx,%eax
 1a6:	8b 00                	mov    (%eax),%eax
 1a8:	89 44 24 08          	mov    %eax,0x8(%esp)
 1ac:	c7 44 24 04 5c 0f 00 	movl   $0xf5c,0x4(%esp)
 1b3:	00 
 1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bb:	e8 b5 09 00 00       	call   b75 <printf>
      exit();
 1c0:	e8 33 08 00 00       	call   9f8 <exit>
    }
    grep(pattern, fd);
 1c5:	8b 44 24 14          	mov    0x14(%esp),%eax
 1c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cd:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d1:	89 04 24             	mov    %eax,(%esp)
 1d4:	e8 27 fe ff ff       	call   0 <grep>
    close(fd);
 1d9:	8b 44 24 14          	mov    0x14(%esp),%eax
 1dd:	89 04 24             	mov    %eax,(%esp)
 1e0:	e8 3b 08 00 00       	call   a20 <close>
  if(argc <= 2){
    grep(pattern, 0);
    exit();
  }

  for(i = 2; i < argc; i++){
 1e5:	ff 44 24 1c          	incl   0x1c(%esp)
 1e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1ed:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f0:	0f 8c 73 ff ff ff    	jl     169 <main+0x5e>
      exit();
    }
    grep(pattern, fd);
    close(fd);
  }
  exit();
 1f6:	e8 fd 07 00 00       	call   9f8 <exit>

000001fb <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	8a 00                	mov    (%eax),%al
 206:	3c 5e                	cmp    $0x5e,%al
 208:	75 17                	jne    221 <match+0x26>
    return matchhere(re+1, text);
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	8d 50 01             	lea    0x1(%eax),%edx
 210:	8b 45 0c             	mov    0xc(%ebp),%eax
 213:	89 44 24 04          	mov    %eax,0x4(%esp)
 217:	89 14 24             	mov    %edx,(%esp)
 21a:	e8 35 00 00 00       	call   254 <matchhere>
 21f:	eb 31                	jmp    252 <match+0x57>
  do{  // must look at empty string
    if(matchhere(re, text))
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	89 44 24 04          	mov    %eax,0x4(%esp)
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	89 04 24             	mov    %eax,(%esp)
 22e:	e8 21 00 00 00       	call   254 <matchhere>
 233:	85 c0                	test   %eax,%eax
 235:	74 07                	je     23e <match+0x43>
      return 1;
 237:	b8 01 00 00 00       	mov    $0x1,%eax
 23c:	eb 14                	jmp    252 <match+0x57>
  }while(*text++ != '\0');
 23e:	8b 45 0c             	mov    0xc(%ebp),%eax
 241:	8d 50 01             	lea    0x1(%eax),%edx
 244:	89 55 0c             	mov    %edx,0xc(%ebp)
 247:	8a 00                	mov    (%eax),%al
 249:	84 c0                	test   %al,%al
 24b:	75 d4                	jne    221 <match+0x26>
  return 0;
 24d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 252:	c9                   	leave  
 253:	c3                   	ret    

00000254 <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 254:	55                   	push   %ebp
 255:	89 e5                	mov    %esp,%ebp
 257:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	8a 00                	mov    (%eax),%al
 25f:	84 c0                	test   %al,%al
 261:	75 0a                	jne    26d <matchhere+0x19>
    return 1;
 263:	b8 01 00 00 00       	mov    $0x1,%eax
 268:	e9 8c 00 00 00       	jmp    2f9 <matchhere+0xa5>
  if(re[1] == '*')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	40                   	inc    %eax
 271:	8a 00                	mov    (%eax),%al
 273:	3c 2a                	cmp    $0x2a,%al
 275:	75 23                	jne    29a <matchhere+0x46>
    return matchstar(re[0], re+2, text);
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	8d 48 02             	lea    0x2(%eax),%ecx
 27d:	8b 45 08             	mov    0x8(%ebp),%eax
 280:	8a 00                	mov    (%eax),%al
 282:	0f be c0             	movsbl %al,%eax
 285:	8b 55 0c             	mov    0xc(%ebp),%edx
 288:	89 54 24 08          	mov    %edx,0x8(%esp)
 28c:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 290:	89 04 24             	mov    %eax,(%esp)
 293:	e8 63 00 00 00       	call   2fb <matchstar>
 298:	eb 5f                	jmp    2f9 <matchhere+0xa5>
  if(re[0] == '$' && re[1] == '\0')
 29a:	8b 45 08             	mov    0x8(%ebp),%eax
 29d:	8a 00                	mov    (%eax),%al
 29f:	3c 24                	cmp    $0x24,%al
 2a1:	75 19                	jne    2bc <matchhere+0x68>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	40                   	inc    %eax
 2a7:	8a 00                	mov    (%eax),%al
 2a9:	84 c0                	test   %al,%al
 2ab:	75 0f                	jne    2bc <matchhere+0x68>
    return *text == '\0';
 2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b0:	8a 00                	mov    (%eax),%al
 2b2:	84 c0                	test   %al,%al
 2b4:	0f 94 c0             	sete   %al
 2b7:	0f b6 c0             	movzbl %al,%eax
 2ba:	eb 3d                	jmp    2f9 <matchhere+0xa5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bf:	8a 00                	mov    (%eax),%al
 2c1:	84 c0                	test   %al,%al
 2c3:	74 2f                	je     2f4 <matchhere+0xa0>
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
 2c8:	8a 00                	mov    (%eax),%al
 2ca:	3c 2e                	cmp    $0x2e,%al
 2cc:	74 0e                	je     2dc <matchhere+0x88>
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	8a 10                	mov    (%eax),%dl
 2d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d6:	8a 00                	mov    (%eax),%al
 2d8:	38 c2                	cmp    %al,%dl
 2da:	75 18                	jne    2f4 <matchhere+0xa0>
    return matchhere(re+1, text+1);
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	8d 50 01             	lea    0x1(%eax),%edx
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	40                   	inc    %eax
 2e6:	89 54 24 04          	mov    %edx,0x4(%esp)
 2ea:	89 04 24             	mov    %eax,(%esp)
 2ed:	e8 62 ff ff ff       	call   254 <matchhere>
 2f2:	eb 05                	jmp    2f9 <matchhere+0xa5>
  return 0;
 2f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f9:	c9                   	leave  
 2fa:	c3                   	ret    

000002fb <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 2fb:	55                   	push   %ebp
 2fc:	89 e5                	mov    %esp,%ebp
 2fe:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 301:	8b 45 10             	mov    0x10(%ebp),%eax
 304:	89 44 24 04          	mov    %eax,0x4(%esp)
 308:	8b 45 0c             	mov    0xc(%ebp),%eax
 30b:	89 04 24             	mov    %eax,(%esp)
 30e:	e8 41 ff ff ff       	call   254 <matchhere>
 313:	85 c0                	test   %eax,%eax
 315:	74 07                	je     31e <matchstar+0x23>
      return 1;
 317:	b8 01 00 00 00       	mov    $0x1,%eax
 31c:	eb 27                	jmp    345 <matchstar+0x4a>
  }while(*text!='\0' && (*text++==c || c=='.'));
 31e:	8b 45 10             	mov    0x10(%ebp),%eax
 321:	8a 00                	mov    (%eax),%al
 323:	84 c0                	test   %al,%al
 325:	74 19                	je     340 <matchstar+0x45>
 327:	8b 45 10             	mov    0x10(%ebp),%eax
 32a:	8d 50 01             	lea    0x1(%eax),%edx
 32d:	89 55 10             	mov    %edx,0x10(%ebp)
 330:	8a 00                	mov    (%eax),%al
 332:	0f be c0             	movsbl %al,%eax
 335:	3b 45 08             	cmp    0x8(%ebp),%eax
 338:	74 c7                	je     301 <matchstar+0x6>
 33a:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 33e:	74 c1                	je     301 <matchstar+0x6>
  return 0;
 340:	b8 00 00 00 00       	mov    $0x0,%eax
}
 345:	c9                   	leave  
 346:	c3                   	ret    
 347:	90                   	nop

00000348 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 348:	55                   	push   %ebp
 349:	89 e5                	mov    %esp,%ebp
 34b:	57                   	push   %edi
 34c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 34d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 350:	8b 55 10             	mov    0x10(%ebp),%edx
 353:	8b 45 0c             	mov    0xc(%ebp),%eax
 356:	89 cb                	mov    %ecx,%ebx
 358:	89 df                	mov    %ebx,%edi
 35a:	89 d1                	mov    %edx,%ecx
 35c:	fc                   	cld    
 35d:	f3 aa                	rep stos %al,%es:(%edi)
 35f:	89 ca                	mov    %ecx,%edx
 361:	89 fb                	mov    %edi,%ebx
 363:	89 5d 08             	mov    %ebx,0x8(%ebp)
 366:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 369:	5b                   	pop    %ebx
 36a:	5f                   	pop    %edi
 36b:	5d                   	pop    %ebp
 36c:	c3                   	ret    

0000036d <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 379:	90                   	nop
 37a:	8b 45 08             	mov    0x8(%ebp),%eax
 37d:	8d 50 01             	lea    0x1(%eax),%edx
 380:	89 55 08             	mov    %edx,0x8(%ebp)
 383:	8b 55 0c             	mov    0xc(%ebp),%edx
 386:	8d 4a 01             	lea    0x1(%edx),%ecx
 389:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 38c:	8a 12                	mov    (%edx),%dl
 38e:	88 10                	mov    %dl,(%eax)
 390:	8a 00                	mov    (%eax),%al
 392:	84 c0                	test   %al,%al
 394:	75 e4                	jne    37a <strcpy+0xd>
    ;
  return os;
 396:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39e:	eb 06                	jmp    3a6 <strcmp+0xb>
    p++, q++;
 3a0:	ff 45 08             	incl   0x8(%ebp)
 3a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8a 00                	mov    (%eax),%al
 3ab:	84 c0                	test   %al,%al
 3ad:	74 0e                	je     3bd <strcmp+0x22>
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	8a 10                	mov    (%eax),%dl
 3b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b7:	8a 00                	mov    (%eax),%al
 3b9:	38 c2                	cmp    %al,%dl
 3bb:	74 e3                	je     3a0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	8a 00                	mov    (%eax),%al
 3c2:	0f b6 d0             	movzbl %al,%edx
 3c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c8:	8a 00                	mov    (%eax),%al
 3ca:	0f b6 c0             	movzbl %al,%eax
 3cd:	29 c2                	sub    %eax,%edx
 3cf:	89 d0                	mov    %edx,%eax
}
 3d1:	5d                   	pop    %ebp
 3d2:	c3                   	ret    

000003d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 3d3:	55                   	push   %ebp
 3d4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 3d6:	eb 09                	jmp    3e1 <strncmp+0xe>
    n--, p++, q++;
 3d8:	ff 4d 10             	decl   0x10(%ebp)
 3db:	ff 45 08             	incl   0x8(%ebp)
 3de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 3e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3e5:	74 17                	je     3fe <strncmp+0x2b>
 3e7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ea:	8a 00                	mov    (%eax),%al
 3ec:	84 c0                	test   %al,%al
 3ee:	74 0e                	je     3fe <strncmp+0x2b>
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	8a 10                	mov    (%eax),%dl
 3f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3f8:	8a 00                	mov    (%eax),%al
 3fa:	38 c2                	cmp    %al,%dl
 3fc:	74 da                	je     3d8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 3fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 402:	75 07                	jne    40b <strncmp+0x38>
    return 0;
 404:	b8 00 00 00 00       	mov    $0x0,%eax
 409:	eb 14                	jmp    41f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	8a 00                	mov    (%eax),%al
 410:	0f b6 d0             	movzbl %al,%edx
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	8a 00                	mov    (%eax),%al
 418:	0f b6 c0             	movzbl %al,%eax
 41b:	29 c2                	sub    %eax,%edx
 41d:	89 d0                	mov    %edx,%eax
}
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    

00000421 <strlen>:

uint
strlen(const char *s)
{
 421:	55                   	push   %ebp
 422:	89 e5                	mov    %esp,%ebp
 424:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 427:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 42e:	eb 03                	jmp    433 <strlen+0x12>
 430:	ff 45 fc             	incl   -0x4(%ebp)
 433:	8b 55 fc             	mov    -0x4(%ebp),%edx
 436:	8b 45 08             	mov    0x8(%ebp),%eax
 439:	01 d0                	add    %edx,%eax
 43b:	8a 00                	mov    (%eax),%al
 43d:	84 c0                	test   %al,%al
 43f:	75 ef                	jne    430 <strlen+0xf>
    ;
  return n;
 441:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 444:	c9                   	leave  
 445:	c3                   	ret    

00000446 <memset>:

void*
memset(void *dst, int c, uint n)
{
 446:	55                   	push   %ebp
 447:	89 e5                	mov    %esp,%ebp
 449:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 44c:	8b 45 10             	mov    0x10(%ebp),%eax
 44f:	89 44 24 08          	mov    %eax,0x8(%esp)
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	89 44 24 04          	mov    %eax,0x4(%esp)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	89 04 24             	mov    %eax,(%esp)
 460:	e8 e3 fe ff ff       	call   348 <stosb>
  return dst;
 465:	8b 45 08             	mov    0x8(%ebp),%eax
}
 468:	c9                   	leave  
 469:	c3                   	ret    

0000046a <strchr>:

char*
strchr(const char *s, char c)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	83 ec 04             	sub    $0x4,%esp
 470:	8b 45 0c             	mov    0xc(%ebp),%eax
 473:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 476:	eb 12                	jmp    48a <strchr+0x20>
    if(*s == c)
 478:	8b 45 08             	mov    0x8(%ebp),%eax
 47b:	8a 00                	mov    (%eax),%al
 47d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 480:	75 05                	jne    487 <strchr+0x1d>
      return (char*)s;
 482:	8b 45 08             	mov    0x8(%ebp),%eax
 485:	eb 11                	jmp    498 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 487:	ff 45 08             	incl   0x8(%ebp)
 48a:	8b 45 08             	mov    0x8(%ebp),%eax
 48d:	8a 00                	mov    (%eax),%al
 48f:	84 c0                	test   %al,%al
 491:	75 e5                	jne    478 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 493:	b8 00 00 00 00       	mov    $0x0,%eax
}
 498:	c9                   	leave  
 499:	c3                   	ret    

0000049a <strcat>:

char *
strcat(char *dest, const char *src)
{
 49a:	55                   	push   %ebp
 49b:	89 e5                	mov    %esp,%ebp
 49d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 4a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4a7:	eb 03                	jmp    4ac <strcat+0x12>
 4a9:	ff 45 fc             	incl   -0x4(%ebp)
 4ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4af:	8b 45 08             	mov    0x8(%ebp),%eax
 4b2:	01 d0                	add    %edx,%eax
 4b4:	8a 00                	mov    (%eax),%al
 4b6:	84 c0                	test   %al,%al
 4b8:	75 ef                	jne    4a9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 4ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 4c1:	eb 1e                	jmp    4e1 <strcat+0x47>
        dest[i+j] = src[j];
 4c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4c9:	01 d0                	add    %edx,%eax
 4cb:	89 c2                	mov    %eax,%edx
 4cd:	8b 45 08             	mov    0x8(%ebp),%eax
 4d0:	01 c2                	add    %eax,%edx
 4d2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4d5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d8:	01 c8                	add    %ecx,%eax
 4da:	8a 00                	mov    (%eax),%al
 4dc:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 4de:	ff 45 f8             	incl   -0x8(%ebp)
 4e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e7:	01 d0                	add    %edx,%eax
 4e9:	8a 00                	mov    (%eax),%al
 4eb:	84 c0                	test   %al,%al
 4ed:	75 d4                	jne    4c3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 4ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4f5:	01 d0                	add    %edx,%eax
 4f7:	89 c2                	mov    %eax,%edx
 4f9:	8b 45 08             	mov    0x8(%ebp),%eax
 4fc:	01 d0                	add    %edx,%eax
 4fe:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 501:	8b 45 08             	mov    0x8(%ebp),%eax
}
 504:	c9                   	leave  
 505:	c3                   	ret    

00000506 <strstr>:

int 
strstr(char* s, char* sub)
{
 506:	55                   	push   %ebp
 507:	89 e5                	mov    %esp,%ebp
 509:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 50c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 513:	eb 7c                	jmp    591 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 515:	8b 55 fc             	mov    -0x4(%ebp),%edx
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	01 d0                	add    %edx,%eax
 51d:	8a 10                	mov    (%eax),%dl
 51f:	8b 45 0c             	mov    0xc(%ebp),%eax
 522:	8a 00                	mov    (%eax),%al
 524:	38 c2                	cmp    %al,%dl
 526:	75 66                	jne    58e <strstr+0x88>
        {
            if(strlen(sub) == 1)
 528:	8b 45 0c             	mov    0xc(%ebp),%eax
 52b:	89 04 24             	mov    %eax,(%esp)
 52e:	e8 ee fe ff ff       	call   421 <strlen>
 533:	83 f8 01             	cmp    $0x1,%eax
 536:	75 05                	jne    53d <strstr+0x37>
            {  
                return i;
 538:	8b 45 fc             	mov    -0x4(%ebp),%eax
 53b:	eb 6b                	jmp    5a8 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 53d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 544:	eb 3a                	jmp    580 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 546:	8b 45 f8             	mov    -0x8(%ebp),%eax
 549:	8b 55 fc             	mov    -0x4(%ebp),%edx
 54c:	01 d0                	add    %edx,%eax
 54e:	89 c2                	mov    %eax,%edx
 550:	8b 45 08             	mov    0x8(%ebp),%eax
 553:	01 d0                	add    %edx,%eax
 555:	8a 10                	mov    (%eax),%dl
 557:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 55a:	8b 45 0c             	mov    0xc(%ebp),%eax
 55d:	01 c8                	add    %ecx,%eax
 55f:	8a 00                	mov    (%eax),%al
 561:	38 c2                	cmp    %al,%dl
 563:	75 16                	jne    57b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 565:	8b 45 f8             	mov    -0x8(%ebp),%eax
 568:	8d 50 01             	lea    0x1(%eax),%edx
 56b:	8b 45 0c             	mov    0xc(%ebp),%eax
 56e:	01 d0                	add    %edx,%eax
 570:	8a 00                	mov    (%eax),%al
 572:	84 c0                	test   %al,%al
 574:	75 07                	jne    57d <strstr+0x77>
                    {
                        return i;
 576:	8b 45 fc             	mov    -0x4(%ebp),%eax
 579:	eb 2d                	jmp    5a8 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 57b:	eb 11                	jmp    58e <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 57d:	ff 45 f8             	incl   -0x8(%ebp)
 580:	8b 55 f8             	mov    -0x8(%ebp),%edx
 583:	8b 45 0c             	mov    0xc(%ebp),%eax
 586:	01 d0                	add    %edx,%eax
 588:	8a 00                	mov    (%eax),%al
 58a:	84 c0                	test   %al,%al
 58c:	75 b8                	jne    546 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 58e:	ff 45 fc             	incl   -0x4(%ebp)
 591:	8b 55 fc             	mov    -0x4(%ebp),%edx
 594:	8b 45 08             	mov    0x8(%ebp),%eax
 597:	01 d0                	add    %edx,%eax
 599:	8a 00                	mov    (%eax),%al
 59b:	84 c0                	test   %al,%al
 59d:	0f 85 72 ff ff ff    	jne    515 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 5a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 5a8:	c9                   	leave  
 5a9:	c3                   	ret    

000005aa <strtok>:

char *
strtok(char *s, const char *delim)
{
 5aa:	55                   	push   %ebp
 5ab:	89 e5                	mov    %esp,%ebp
 5ad:	53                   	push   %ebx
 5ae:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 5b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5b5:	75 08                	jne    5bf <strtok+0x15>
  s = lasts;
 5b7:	a1 c4 13 00 00       	mov    0x13c4,%eax
 5bc:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 5bf:	8b 45 08             	mov    0x8(%ebp),%eax
 5c2:	8d 50 01             	lea    0x1(%eax),%edx
 5c5:	89 55 08             	mov    %edx,0x8(%ebp)
 5c8:	8a 00                	mov    (%eax),%al
 5ca:	0f be d8             	movsbl %al,%ebx
 5cd:	85 db                	test   %ebx,%ebx
 5cf:	75 07                	jne    5d8 <strtok+0x2e>
      return 0;
 5d1:	b8 00 00 00 00       	mov    $0x0,%eax
 5d6:	eb 58                	jmp    630 <strtok+0x86>
    } while (strchr(delim, ch));
 5d8:	88 d8                	mov    %bl,%al
 5da:	0f be c0             	movsbl %al,%eax
 5dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e4:	89 04 24             	mov    %eax,(%esp)
 5e7:	e8 7e fe ff ff       	call   46a <strchr>
 5ec:	85 c0                	test   %eax,%eax
 5ee:	75 cf                	jne    5bf <strtok+0x15>
    --s;
 5f0:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 5f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fa:	8b 45 08             	mov    0x8(%ebp),%eax
 5fd:	89 04 24             	mov    %eax,(%esp)
 600:	e8 31 00 00 00       	call   636 <strcspn>
 605:	89 c2                	mov    %eax,%edx
 607:	8b 45 08             	mov    0x8(%ebp),%eax
 60a:	01 d0                	add    %edx,%eax
 60c:	a3 c4 13 00 00       	mov    %eax,0x13c4
    if (*lasts != 0)
 611:	a1 c4 13 00 00       	mov    0x13c4,%eax
 616:	8a 00                	mov    (%eax),%al
 618:	84 c0                	test   %al,%al
 61a:	74 11                	je     62d <strtok+0x83>
  *lasts++ = 0;
 61c:	a1 c4 13 00 00       	mov    0x13c4,%eax
 621:	8d 50 01             	lea    0x1(%eax),%edx
 624:	89 15 c4 13 00 00    	mov    %edx,0x13c4
 62a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 62d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 630:	83 c4 14             	add    $0x14,%esp
 633:	5b                   	pop    %ebx
 634:	5d                   	pop    %ebp
 635:	c3                   	ret    

00000636 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 636:	55                   	push   %ebp
 637:	89 e5                	mov    %esp,%ebp
 639:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 63c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 643:	eb 26                	jmp    66b <strcspn+0x35>
        if(strchr(s2,*s1))
 645:	8b 45 08             	mov    0x8(%ebp),%eax
 648:	8a 00                	mov    (%eax),%al
 64a:	0f be c0             	movsbl %al,%eax
 64d:	89 44 24 04          	mov    %eax,0x4(%esp)
 651:	8b 45 0c             	mov    0xc(%ebp),%eax
 654:	89 04 24             	mov    %eax,(%esp)
 657:	e8 0e fe ff ff       	call   46a <strchr>
 65c:	85 c0                	test   %eax,%eax
 65e:	74 05                	je     665 <strcspn+0x2f>
            return ret;
 660:	8b 45 fc             	mov    -0x4(%ebp),%eax
 663:	eb 12                	jmp    677 <strcspn+0x41>
        else
            s1++,ret++;
 665:	ff 45 08             	incl   0x8(%ebp)
 668:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 66b:	8b 45 08             	mov    0x8(%ebp),%eax
 66e:	8a 00                	mov    (%eax),%al
 670:	84 c0                	test   %al,%al
 672:	75 d1                	jne    645 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 674:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 677:	c9                   	leave  
 678:	c3                   	ret    

00000679 <isspace>:

int
isspace(unsigned char c)
{
 679:	55                   	push   %ebp
 67a:	89 e5                	mov    %esp,%ebp
 67c:	83 ec 04             	sub    $0x4,%esp
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 685:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 689:	74 1e                	je     6a9 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 68b:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 68f:	74 18                	je     6a9 <isspace+0x30>
 691:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 695:	74 12                	je     6a9 <isspace+0x30>
 697:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 69b:	74 0c                	je     6a9 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 69d:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 6a1:	74 06                	je     6a9 <isspace+0x30>
 6a3:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 6a7:	75 07                	jne    6b0 <isspace+0x37>
 6a9:	b8 01 00 00 00       	mov    $0x1,%eax
 6ae:	eb 05                	jmp    6b5 <isspace+0x3c>
 6b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 6b5:	c9                   	leave  
 6b6:	c3                   	ret    

000006b7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 6b7:	55                   	push   %ebp
 6b8:	89 e5                	mov    %esp,%ebp
 6ba:	57                   	push   %edi
 6bb:	56                   	push   %esi
 6bc:	53                   	push   %ebx
 6bd:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 6c0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 6c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 6cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 6cf:	eb 01                	jmp    6d2 <strtoul+0x1b>
  p += 1;
 6d1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 6d2:	8a 03                	mov    (%ebx),%al
 6d4:	0f b6 c0             	movzbl %al,%eax
 6d7:	89 04 24             	mov    %eax,(%esp)
 6da:	e8 9a ff ff ff       	call   679 <isspace>
 6df:	85 c0                	test   %eax,%eax
 6e1:	75 ee                	jne    6d1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 6e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 6e7:	75 30                	jne    719 <strtoul+0x62>
    {
  if (*p == '0') {
 6e9:	8a 03                	mov    (%ebx),%al
 6eb:	3c 30                	cmp    $0x30,%al
 6ed:	75 21                	jne    710 <strtoul+0x59>
      p += 1;
 6ef:	43                   	inc    %ebx
      if (*p == 'x') {
 6f0:	8a 03                	mov    (%ebx),%al
 6f2:	3c 78                	cmp    $0x78,%al
 6f4:	75 0a                	jne    700 <strtoul+0x49>
    p += 1;
 6f6:	43                   	inc    %ebx
    base = 16;
 6f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 6fe:	eb 31                	jmp    731 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 700:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 707:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 70e:	eb 21                	jmp    731 <strtoul+0x7a>
      }
  }
  else base = 10;
 710:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 717:	eb 18                	jmp    731 <strtoul+0x7a>
    } else if (base == 16) {
 719:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 71d:	75 12                	jne    731 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 71f:	8a 03                	mov    (%ebx),%al
 721:	3c 30                	cmp    $0x30,%al
 723:	75 0c                	jne    731 <strtoul+0x7a>
 725:	8d 43 01             	lea    0x1(%ebx),%eax
 728:	8a 00                	mov    (%eax),%al
 72a:	3c 78                	cmp    $0x78,%al
 72c:	75 03                	jne    731 <strtoul+0x7a>
      p += 2;
 72e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 731:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 735:	75 29                	jne    760 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 737:	8a 03                	mov    (%ebx),%al
 739:	0f be c0             	movsbl %al,%eax
 73c:	83 e8 30             	sub    $0x30,%eax
 73f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 741:	83 fe 07             	cmp    $0x7,%esi
 744:	76 06                	jbe    74c <strtoul+0x95>
    break;
 746:	90                   	nop
 747:	e9 b6 00 00 00       	jmp    802 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 74c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 753:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 756:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 75d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 75e:	eb d7                	jmp    737 <strtoul+0x80>
    } else if (base == 10) {
 760:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 764:	75 2b                	jne    791 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 766:	8a 03                	mov    (%ebx),%al
 768:	0f be c0             	movsbl %al,%eax
 76b:	83 e8 30             	sub    $0x30,%eax
 76e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 770:	83 fe 09             	cmp    $0x9,%esi
 773:	76 06                	jbe    77b <strtoul+0xc4>
    break;
 775:	90                   	nop
 776:	e9 87 00 00 00       	jmp    802 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 77b:	89 f8                	mov    %edi,%eax
 77d:	c1 e0 02             	shl    $0x2,%eax
 780:	01 f8                	add    %edi,%eax
 782:	01 c0                	add    %eax,%eax
 784:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 787:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 78e:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 78f:	eb d5                	jmp    766 <strtoul+0xaf>
    } else if (base == 16) {
 791:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 795:	75 35                	jne    7cc <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 797:	8a 03                	mov    (%ebx),%al
 799:	0f be c0             	movsbl %al,%eax
 79c:	83 e8 30             	sub    $0x30,%eax
 79f:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 7a1:	83 fe 4a             	cmp    $0x4a,%esi
 7a4:	76 02                	jbe    7a8 <strtoul+0xf1>
    break;
 7a6:	eb 22                	jmp    7ca <strtoul+0x113>
      }
      digit = cvtIn[digit];
 7a8:	8a 86 60 13 00 00    	mov    0x1360(%esi),%al
 7ae:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 7b1:	83 fe 0f             	cmp    $0xf,%esi
 7b4:	76 02                	jbe    7b8 <strtoul+0x101>
    break;
 7b6:	eb 12                	jmp    7ca <strtoul+0x113>
      }
      result = (result << 4) + digit;
 7b8:	89 f8                	mov    %edi,%eax
 7ba:	c1 e0 04             	shl    $0x4,%eax
 7bd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 7c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 7c7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 7c8:	eb cd                	jmp    797 <strtoul+0xe0>
 7ca:	eb 36                	jmp    802 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 7cc:	8a 03                	mov    (%ebx),%al
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	83 e8 30             	sub    $0x30,%eax
 7d4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 7d6:	83 fe 4a             	cmp    $0x4a,%esi
 7d9:	76 02                	jbe    7dd <strtoul+0x126>
    break;
 7db:	eb 25                	jmp    802 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 7dd:	8a 86 60 13 00 00    	mov    0x1360(%esi),%al
 7e3:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 7e6:	8b 45 10             	mov    0x10(%ebp),%eax
 7e9:	39 f0                	cmp    %esi,%eax
 7eb:	77 02                	ja     7ef <strtoul+0x138>
    break;
 7ed:	eb 13                	jmp    802 <strtoul+0x14b>
      }
      result = result*base + digit;
 7ef:	8b 45 10             	mov    0x10(%ebp),%eax
 7f2:	0f af c7             	imul   %edi,%eax
 7f5:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 7f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 7ff:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 800:	eb ca                	jmp    7cc <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 802:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 806:	75 03                	jne    80b <strtoul+0x154>
  p = string;
 808:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 80b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 80f:	74 05                	je     816 <strtoul+0x15f>
  *endPtr = p;
 811:	8b 45 0c             	mov    0xc(%ebp),%eax
 814:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 816:	89 f8                	mov    %edi,%eax
}
 818:	83 c4 14             	add    $0x14,%esp
 81b:	5b                   	pop    %ebx
 81c:	5e                   	pop    %esi
 81d:	5f                   	pop    %edi
 81e:	5d                   	pop    %ebp
 81f:	c3                   	ret    

00000820 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	53                   	push   %ebx
 824:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 827:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 82a:	eb 01                	jmp    82d <strtol+0xd>
      p += 1;
 82c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 82d:	8a 03                	mov    (%ebx),%al
 82f:	0f b6 c0             	movzbl %al,%eax
 832:	89 04 24             	mov    %eax,(%esp)
 835:	e8 3f fe ff ff       	call   679 <isspace>
 83a:	85 c0                	test   %eax,%eax
 83c:	75 ee                	jne    82c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 83e:	8a 03                	mov    (%ebx),%al
 840:	3c 2d                	cmp    $0x2d,%al
 842:	75 1e                	jne    862 <strtol+0x42>
  p += 1;
 844:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 845:	8b 45 10             	mov    0x10(%ebp),%eax
 848:	89 44 24 08          	mov    %eax,0x8(%esp)
 84c:	8b 45 0c             	mov    0xc(%ebp),%eax
 84f:	89 44 24 04          	mov    %eax,0x4(%esp)
 853:	89 1c 24             	mov    %ebx,(%esp)
 856:	e8 5c fe ff ff       	call   6b7 <strtoul>
 85b:	f7 d8                	neg    %eax
 85d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 860:	eb 20                	jmp    882 <strtol+0x62>
    } else {
  if (*p == '+') {
 862:	8a 03                	mov    (%ebx),%al
 864:	3c 2b                	cmp    $0x2b,%al
 866:	75 01                	jne    869 <strtol+0x49>
      p += 1;
 868:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 869:	8b 45 10             	mov    0x10(%ebp),%eax
 86c:	89 44 24 08          	mov    %eax,0x8(%esp)
 870:	8b 45 0c             	mov    0xc(%ebp),%eax
 873:	89 44 24 04          	mov    %eax,0x4(%esp)
 877:	89 1c 24             	mov    %ebx,(%esp)
 87a:	e8 38 fe ff ff       	call   6b7 <strtoul>
 87f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 882:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 886:	75 17                	jne    89f <strtol+0x7f>
 888:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 88c:	74 11                	je     89f <strtol+0x7f>
 88e:	8b 45 0c             	mov    0xc(%ebp),%eax
 891:	8b 00                	mov    (%eax),%eax
 893:	39 d8                	cmp    %ebx,%eax
 895:	75 08                	jne    89f <strtol+0x7f>
  *endPtr = string;
 897:	8b 45 0c             	mov    0xc(%ebp),%eax
 89a:	8b 55 08             	mov    0x8(%ebp),%edx
 89d:	89 10                	mov    %edx,(%eax)
    }
    return result;
 89f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 8a2:	83 c4 1c             	add    $0x1c,%esp
 8a5:	5b                   	pop    %ebx
 8a6:	5d                   	pop    %ebp
 8a7:	c3                   	ret    

000008a8 <gets>:

char*
gets(char *buf, int max)
{
 8a8:	55                   	push   %ebp
 8a9:	89 e5                	mov    %esp,%ebp
 8ab:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8b5:	eb 49                	jmp    900 <gets+0x58>
    cc = read(0, &c, 1);
 8b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8be:	00 
 8bf:	8d 45 ef             	lea    -0x11(%ebp),%eax
 8c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 8c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8cd:	e8 3e 01 00 00       	call   a10 <read>
 8d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 8d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8d9:	7f 02                	jg     8dd <gets+0x35>
      break;
 8db:	eb 2c                	jmp    909 <gets+0x61>
    buf[i++] = c;
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	8d 50 01             	lea    0x1(%eax),%edx
 8e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8e6:	89 c2                	mov    %eax,%edx
 8e8:	8b 45 08             	mov    0x8(%ebp),%eax
 8eb:	01 c2                	add    %eax,%edx
 8ed:	8a 45 ef             	mov    -0x11(%ebp),%al
 8f0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 8f2:	8a 45 ef             	mov    -0x11(%ebp),%al
 8f5:	3c 0a                	cmp    $0xa,%al
 8f7:	74 10                	je     909 <gets+0x61>
 8f9:	8a 45 ef             	mov    -0x11(%ebp),%al
 8fc:	3c 0d                	cmp    $0xd,%al
 8fe:	74 09                	je     909 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	40                   	inc    %eax
 904:	3b 45 0c             	cmp    0xc(%ebp),%eax
 907:	7c ae                	jl     8b7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 909:	8b 55 f4             	mov    -0xc(%ebp),%edx
 90c:	8b 45 08             	mov    0x8(%ebp),%eax
 90f:	01 d0                	add    %edx,%eax
 911:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 914:	8b 45 08             	mov    0x8(%ebp),%eax
}
 917:	c9                   	leave  
 918:	c3                   	ret    

00000919 <stat>:

int
stat(char *n, struct stat *st)
{
 919:	55                   	push   %ebp
 91a:	89 e5                	mov    %esp,%ebp
 91c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 91f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 926:	00 
 927:	8b 45 08             	mov    0x8(%ebp),%eax
 92a:	89 04 24             	mov    %eax,(%esp)
 92d:	e8 06 01 00 00       	call   a38 <open>
 932:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 935:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 939:	79 07                	jns    942 <stat+0x29>
    return -1;
 93b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 940:	eb 23                	jmp    965 <stat+0x4c>
  r = fstat(fd, st);
 942:	8b 45 0c             	mov    0xc(%ebp),%eax
 945:	89 44 24 04          	mov    %eax,0x4(%esp)
 949:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94c:	89 04 24             	mov    %eax,(%esp)
 94f:	e8 fc 00 00 00       	call   a50 <fstat>
 954:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 957:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95a:	89 04 24             	mov    %eax,(%esp)
 95d:	e8 be 00 00 00       	call   a20 <close>
  return r;
 962:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 965:	c9                   	leave  
 966:	c3                   	ret    

00000967 <atoi>:

int
atoi(const char *s)
{
 967:	55                   	push   %ebp
 968:	89 e5                	mov    %esp,%ebp
 96a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 96d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 974:	eb 24                	jmp    99a <atoi+0x33>
    n = n*10 + *s++ - '0';
 976:	8b 55 fc             	mov    -0x4(%ebp),%edx
 979:	89 d0                	mov    %edx,%eax
 97b:	c1 e0 02             	shl    $0x2,%eax
 97e:	01 d0                	add    %edx,%eax
 980:	01 c0                	add    %eax,%eax
 982:	89 c1                	mov    %eax,%ecx
 984:	8b 45 08             	mov    0x8(%ebp),%eax
 987:	8d 50 01             	lea    0x1(%eax),%edx
 98a:	89 55 08             	mov    %edx,0x8(%ebp)
 98d:	8a 00                	mov    (%eax),%al
 98f:	0f be c0             	movsbl %al,%eax
 992:	01 c8                	add    %ecx,%eax
 994:	83 e8 30             	sub    $0x30,%eax
 997:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 99a:	8b 45 08             	mov    0x8(%ebp),%eax
 99d:	8a 00                	mov    (%eax),%al
 99f:	3c 2f                	cmp    $0x2f,%al
 9a1:	7e 09                	jle    9ac <atoi+0x45>
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	8a 00                	mov    (%eax),%al
 9a8:	3c 39                	cmp    $0x39,%al
 9aa:	7e ca                	jle    976 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 9ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 9af:	c9                   	leave  
 9b0:	c3                   	ret    

000009b1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 9b1:	55                   	push   %ebp
 9b2:	89 e5                	mov    %esp,%ebp
 9b4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 9bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 9c0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 9c3:	eb 16                	jmp    9db <memmove+0x2a>
    *dst++ = *src++;
 9c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9c8:	8d 50 01             	lea    0x1(%eax),%edx
 9cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 9ce:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9d1:	8d 4a 01             	lea    0x1(%edx),%ecx
 9d4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 9d7:	8a 12                	mov    (%edx),%dl
 9d9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9db:	8b 45 10             	mov    0x10(%ebp),%eax
 9de:	8d 50 ff             	lea    -0x1(%eax),%edx
 9e1:	89 55 10             	mov    %edx,0x10(%ebp)
 9e4:	85 c0                	test   %eax,%eax
 9e6:	7f dd                	jg     9c5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 9e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 9eb:	c9                   	leave  
 9ec:	c3                   	ret    
 9ed:	90                   	nop
 9ee:	90                   	nop
 9ef:	90                   	nop

000009f0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 9f0:	b8 01 00 00 00       	mov    $0x1,%eax
 9f5:	cd 40                	int    $0x40
 9f7:	c3                   	ret    

000009f8 <exit>:
SYSCALL(exit)
 9f8:	b8 02 00 00 00       	mov    $0x2,%eax
 9fd:	cd 40                	int    $0x40
 9ff:	c3                   	ret    

00000a00 <wait>:
SYSCALL(wait)
 a00:	b8 03 00 00 00       	mov    $0x3,%eax
 a05:	cd 40                	int    $0x40
 a07:	c3                   	ret    

00000a08 <pipe>:
SYSCALL(pipe)
 a08:	b8 04 00 00 00       	mov    $0x4,%eax
 a0d:	cd 40                	int    $0x40
 a0f:	c3                   	ret    

00000a10 <read>:
SYSCALL(read)
 a10:	b8 05 00 00 00       	mov    $0x5,%eax
 a15:	cd 40                	int    $0x40
 a17:	c3                   	ret    

00000a18 <write>:
SYSCALL(write)
 a18:	b8 10 00 00 00       	mov    $0x10,%eax
 a1d:	cd 40                	int    $0x40
 a1f:	c3                   	ret    

00000a20 <close>:
SYSCALL(close)
 a20:	b8 15 00 00 00       	mov    $0x15,%eax
 a25:	cd 40                	int    $0x40
 a27:	c3                   	ret    

00000a28 <kill>:
SYSCALL(kill)
 a28:	b8 06 00 00 00       	mov    $0x6,%eax
 a2d:	cd 40                	int    $0x40
 a2f:	c3                   	ret    

00000a30 <exec>:
SYSCALL(exec)
 a30:	b8 07 00 00 00       	mov    $0x7,%eax
 a35:	cd 40                	int    $0x40
 a37:	c3                   	ret    

00000a38 <open>:
SYSCALL(open)
 a38:	b8 0f 00 00 00       	mov    $0xf,%eax
 a3d:	cd 40                	int    $0x40
 a3f:	c3                   	ret    

00000a40 <mknod>:
SYSCALL(mknod)
 a40:	b8 11 00 00 00       	mov    $0x11,%eax
 a45:	cd 40                	int    $0x40
 a47:	c3                   	ret    

00000a48 <unlink>:
SYSCALL(unlink)
 a48:	b8 12 00 00 00       	mov    $0x12,%eax
 a4d:	cd 40                	int    $0x40
 a4f:	c3                   	ret    

00000a50 <fstat>:
SYSCALL(fstat)
 a50:	b8 08 00 00 00       	mov    $0x8,%eax
 a55:	cd 40                	int    $0x40
 a57:	c3                   	ret    

00000a58 <link>:
SYSCALL(link)
 a58:	b8 13 00 00 00       	mov    $0x13,%eax
 a5d:	cd 40                	int    $0x40
 a5f:	c3                   	ret    

00000a60 <mkdir>:
SYSCALL(mkdir)
 a60:	b8 14 00 00 00       	mov    $0x14,%eax
 a65:	cd 40                	int    $0x40
 a67:	c3                   	ret    

00000a68 <chdir>:
SYSCALL(chdir)
 a68:	b8 09 00 00 00       	mov    $0x9,%eax
 a6d:	cd 40                	int    $0x40
 a6f:	c3                   	ret    

00000a70 <dup>:
SYSCALL(dup)
 a70:	b8 0a 00 00 00       	mov    $0xa,%eax
 a75:	cd 40                	int    $0x40
 a77:	c3                   	ret    

00000a78 <getpid>:
SYSCALL(getpid)
 a78:	b8 0b 00 00 00       	mov    $0xb,%eax
 a7d:	cd 40                	int    $0x40
 a7f:	c3                   	ret    

00000a80 <sbrk>:
SYSCALL(sbrk)
 a80:	b8 0c 00 00 00       	mov    $0xc,%eax
 a85:	cd 40                	int    $0x40
 a87:	c3                   	ret    

00000a88 <sleep>:
SYSCALL(sleep)
 a88:	b8 0d 00 00 00       	mov    $0xd,%eax
 a8d:	cd 40                	int    $0x40
 a8f:	c3                   	ret    

00000a90 <uptime>:
SYSCALL(uptime)
 a90:	b8 0e 00 00 00       	mov    $0xe,%eax
 a95:	cd 40                	int    $0x40
 a97:	c3                   	ret    

00000a98 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a98:	55                   	push   %ebp
 a99:	89 e5                	mov    %esp,%ebp
 a9b:	83 ec 18             	sub    $0x18,%esp
 a9e:	8b 45 0c             	mov    0xc(%ebp),%eax
 aa1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 aa4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 aab:	00 
 aac:	8d 45 f4             	lea    -0xc(%ebp),%eax
 aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab3:	8b 45 08             	mov    0x8(%ebp),%eax
 ab6:	89 04 24             	mov    %eax,(%esp)
 ab9:	e8 5a ff ff ff       	call   a18 <write>
}
 abe:	c9                   	leave  
 abf:	c3                   	ret    

00000ac0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 ac0:	55                   	push   %ebp
 ac1:	89 e5                	mov    %esp,%ebp
 ac3:	56                   	push   %esi
 ac4:	53                   	push   %ebx
 ac5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 ac8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 acf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 ad3:	74 17                	je     aec <printint+0x2c>
 ad5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ad9:	79 11                	jns    aec <printint+0x2c>
    neg = 1;
 adb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 ae2:	8b 45 0c             	mov    0xc(%ebp),%eax
 ae5:	f7 d8                	neg    %eax
 ae7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 aea:	eb 06                	jmp    af2 <printint+0x32>
  } else {
    x = xx;
 aec:	8b 45 0c             	mov    0xc(%ebp),%eax
 aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 af2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 af9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 afc:	8d 41 01             	lea    0x1(%ecx),%eax
 aff:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b02:	8b 5d 10             	mov    0x10(%ebp),%ebx
 b05:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b08:	ba 00 00 00 00       	mov    $0x0,%edx
 b0d:	f7 f3                	div    %ebx
 b0f:	89 d0                	mov    %edx,%eax
 b11:	8a 80 ac 13 00 00    	mov    0x13ac(%eax),%al
 b17:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 b1b:	8b 75 10             	mov    0x10(%ebp),%esi
 b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b21:	ba 00 00 00 00       	mov    $0x0,%edx
 b26:	f7 f6                	div    %esi
 b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b2f:	75 c8                	jne    af9 <printint+0x39>
  if(neg)
 b31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b35:	74 10                	je     b47 <printint+0x87>
    buf[i++] = '-';
 b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3a:	8d 50 01             	lea    0x1(%eax),%edx
 b3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 b40:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 b45:	eb 1e                	jmp    b65 <printint+0xa5>
 b47:	eb 1c                	jmp    b65 <printint+0xa5>
    putc(fd, buf[i]);
 b49:	8d 55 dc             	lea    -0x24(%ebp),%edx
 b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4f:	01 d0                	add    %edx,%eax
 b51:	8a 00                	mov    (%eax),%al
 b53:	0f be c0             	movsbl %al,%eax
 b56:	89 44 24 04          	mov    %eax,0x4(%esp)
 b5a:	8b 45 08             	mov    0x8(%ebp),%eax
 b5d:	89 04 24             	mov    %eax,(%esp)
 b60:	e8 33 ff ff ff       	call   a98 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b65:	ff 4d f4             	decl   -0xc(%ebp)
 b68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b6c:	79 db                	jns    b49 <printint+0x89>
    putc(fd, buf[i]);
}
 b6e:	83 c4 30             	add    $0x30,%esp
 b71:	5b                   	pop    %ebx
 b72:	5e                   	pop    %esi
 b73:	5d                   	pop    %ebp
 b74:	c3                   	ret    

00000b75 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b75:	55                   	push   %ebp
 b76:	89 e5                	mov    %esp,%ebp
 b78:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b82:	8d 45 0c             	lea    0xc(%ebp),%eax
 b85:	83 c0 04             	add    $0x4,%eax
 b88:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b92:	e9 77 01 00 00       	jmp    d0e <printf+0x199>
    c = fmt[i] & 0xff;
 b97:	8b 55 0c             	mov    0xc(%ebp),%edx
 b9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9d:	01 d0                	add    %edx,%eax
 b9f:	8a 00                	mov    (%eax),%al
 ba1:	0f be c0             	movsbl %al,%eax
 ba4:	25 ff 00 00 00       	and    $0xff,%eax
 ba9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bb0:	75 2c                	jne    bde <printf+0x69>
      if(c == '%'){
 bb2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bb6:	75 0c                	jne    bc4 <printf+0x4f>
        state = '%';
 bb8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 bbf:	e9 47 01 00 00       	jmp    d0b <printf+0x196>
      } else {
        putc(fd, c);
 bc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bc7:	0f be c0             	movsbl %al,%eax
 bca:	89 44 24 04          	mov    %eax,0x4(%esp)
 bce:	8b 45 08             	mov    0x8(%ebp),%eax
 bd1:	89 04 24             	mov    %eax,(%esp)
 bd4:	e8 bf fe ff ff       	call   a98 <putc>
 bd9:	e9 2d 01 00 00       	jmp    d0b <printf+0x196>
      }
    } else if(state == '%'){
 bde:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 be2:	0f 85 23 01 00 00    	jne    d0b <printf+0x196>
      if(c == 'd'){
 be8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 bec:	75 2d                	jne    c1b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 bee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bf1:	8b 00                	mov    (%eax),%eax
 bf3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 bfa:	00 
 bfb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 c02:	00 
 c03:	89 44 24 04          	mov    %eax,0x4(%esp)
 c07:	8b 45 08             	mov    0x8(%ebp),%eax
 c0a:	89 04 24             	mov    %eax,(%esp)
 c0d:	e8 ae fe ff ff       	call   ac0 <printint>
        ap++;
 c12:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c16:	e9 e9 00 00 00       	jmp    d04 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 c1b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 c1f:	74 06                	je     c27 <printf+0xb2>
 c21:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 c25:	75 2d                	jne    c54 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 c27:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c2a:	8b 00                	mov    (%eax),%eax
 c2c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 c33:	00 
 c34:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 c3b:	00 
 c3c:	89 44 24 04          	mov    %eax,0x4(%esp)
 c40:	8b 45 08             	mov    0x8(%ebp),%eax
 c43:	89 04 24             	mov    %eax,(%esp)
 c46:	e8 75 fe ff ff       	call   ac0 <printint>
        ap++;
 c4b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c4f:	e9 b0 00 00 00       	jmp    d04 <printf+0x18f>
      } else if(c == 's'){
 c54:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 c58:	75 42                	jne    c9c <printf+0x127>
        s = (char*)*ap;
 c5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c5d:	8b 00                	mov    (%eax),%eax
 c5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c62:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c6a:	75 09                	jne    c75 <printf+0x100>
          s = "(null)";
 c6c:	c7 45 f4 72 0f 00 00 	movl   $0xf72,-0xc(%ebp)
        while(*s != 0){
 c73:	eb 1c                	jmp    c91 <printf+0x11c>
 c75:	eb 1a                	jmp    c91 <printf+0x11c>
          putc(fd, *s);
 c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c7a:	8a 00                	mov    (%eax),%al
 c7c:	0f be c0             	movsbl %al,%eax
 c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
 c83:	8b 45 08             	mov    0x8(%ebp),%eax
 c86:	89 04 24             	mov    %eax,(%esp)
 c89:	e8 0a fe ff ff       	call   a98 <putc>
          s++;
 c8e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c94:	8a 00                	mov    (%eax),%al
 c96:	84 c0                	test   %al,%al
 c98:	75 dd                	jne    c77 <printf+0x102>
 c9a:	eb 68                	jmp    d04 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 c9c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ca0:	75 1d                	jne    cbf <printf+0x14a>
        putc(fd, *ap);
 ca2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ca5:	8b 00                	mov    (%eax),%eax
 ca7:	0f be c0             	movsbl %al,%eax
 caa:	89 44 24 04          	mov    %eax,0x4(%esp)
 cae:	8b 45 08             	mov    0x8(%ebp),%eax
 cb1:	89 04 24             	mov    %eax,(%esp)
 cb4:	e8 df fd ff ff       	call   a98 <putc>
        ap++;
 cb9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 cbd:	eb 45                	jmp    d04 <printf+0x18f>
      } else if(c == '%'){
 cbf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 cc3:	75 17                	jne    cdc <printf+0x167>
        putc(fd, c);
 cc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 cc8:	0f be c0             	movsbl %al,%eax
 ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
 ccf:	8b 45 08             	mov    0x8(%ebp),%eax
 cd2:	89 04 24             	mov    %eax,(%esp)
 cd5:	e8 be fd ff ff       	call   a98 <putc>
 cda:	eb 28                	jmp    d04 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 cdc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 ce3:	00 
 ce4:	8b 45 08             	mov    0x8(%ebp),%eax
 ce7:	89 04 24             	mov    %eax,(%esp)
 cea:	e8 a9 fd ff ff       	call   a98 <putc>
        putc(fd, c);
 cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 cf2:	0f be c0             	movsbl %al,%eax
 cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
 cf9:	8b 45 08             	mov    0x8(%ebp),%eax
 cfc:	89 04 24             	mov    %eax,(%esp)
 cff:	e8 94 fd ff ff       	call   a98 <putc>
      }
      state = 0;
 d04:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 d0b:	ff 45 f0             	incl   -0x10(%ebp)
 d0e:	8b 55 0c             	mov    0xc(%ebp),%edx
 d11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d14:	01 d0                	add    %edx,%eax
 d16:	8a 00                	mov    (%eax),%al
 d18:	84 c0                	test   %al,%al
 d1a:	0f 85 77 fe ff ff    	jne    b97 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 d20:	c9                   	leave  
 d21:	c3                   	ret    
 d22:	90                   	nop
 d23:	90                   	nop

00000d24 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d24:	55                   	push   %ebp
 d25:	89 e5                	mov    %esp,%ebp
 d27:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d2a:	8b 45 08             	mov    0x8(%ebp),%eax
 d2d:	83 e8 08             	sub    $0x8,%eax
 d30:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d33:	a1 d0 13 00 00       	mov    0x13d0,%eax
 d38:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d3b:	eb 24                	jmp    d61 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d40:	8b 00                	mov    (%eax),%eax
 d42:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d45:	77 12                	ja     d59 <free+0x35>
 d47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d4a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d4d:	77 24                	ja     d73 <free+0x4f>
 d4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d52:	8b 00                	mov    (%eax),%eax
 d54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d57:	77 1a                	ja     d73 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d5c:	8b 00                	mov    (%eax),%eax
 d5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d64:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d67:	76 d4                	jbe    d3d <free+0x19>
 d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d6c:	8b 00                	mov    (%eax),%eax
 d6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d71:	76 ca                	jbe    d3d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 d73:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d76:	8b 40 04             	mov    0x4(%eax),%eax
 d79:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d80:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d83:	01 c2                	add    %eax,%edx
 d85:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d88:	8b 00                	mov    (%eax),%eax
 d8a:	39 c2                	cmp    %eax,%edx
 d8c:	75 24                	jne    db2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d91:	8b 50 04             	mov    0x4(%eax),%edx
 d94:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d97:	8b 00                	mov    (%eax),%eax
 d99:	8b 40 04             	mov    0x4(%eax),%eax
 d9c:	01 c2                	add    %eax,%edx
 d9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 da1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 da4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 da7:	8b 00                	mov    (%eax),%eax
 da9:	8b 10                	mov    (%eax),%edx
 dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dae:	89 10                	mov    %edx,(%eax)
 db0:	eb 0a                	jmp    dbc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 db5:	8b 10                	mov    (%eax),%edx
 db7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dba:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 dbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dbf:	8b 40 04             	mov    0x4(%eax),%eax
 dc2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dcc:	01 d0                	add    %edx,%eax
 dce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 dd1:	75 20                	jne    df3 <free+0xcf>
    p->s.size += bp->s.size;
 dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dd6:	8b 50 04             	mov    0x4(%eax),%edx
 dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ddc:	8b 40 04             	mov    0x4(%eax),%eax
 ddf:	01 c2                	add    %eax,%edx
 de1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 de4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dea:	8b 10                	mov    (%eax),%edx
 dec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 def:	89 10                	mov    %edx,(%eax)
 df1:	eb 08                	jmp    dfb <free+0xd7>
  } else
    p->s.ptr = bp;
 df3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 df6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 df9:	89 10                	mov    %edx,(%eax)
  freep = p;
 dfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dfe:	a3 d0 13 00 00       	mov    %eax,0x13d0
}
 e03:	c9                   	leave  
 e04:	c3                   	ret    

00000e05 <morecore>:

static Header*
morecore(uint nu)
{
 e05:	55                   	push   %ebp
 e06:	89 e5                	mov    %esp,%ebp
 e08:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 e0b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 e12:	77 07                	ja     e1b <morecore+0x16>
    nu = 4096;
 e14:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 e1b:	8b 45 08             	mov    0x8(%ebp),%eax
 e1e:	c1 e0 03             	shl    $0x3,%eax
 e21:	89 04 24             	mov    %eax,(%esp)
 e24:	e8 57 fc ff ff       	call   a80 <sbrk>
 e29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 e2c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 e30:	75 07                	jne    e39 <morecore+0x34>
    return 0;
 e32:	b8 00 00 00 00       	mov    $0x0,%eax
 e37:	eb 22                	jmp    e5b <morecore+0x56>
  hp = (Header*)p;
 e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 e3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e42:	8b 55 08             	mov    0x8(%ebp),%edx
 e45:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 e48:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e4b:	83 c0 08             	add    $0x8,%eax
 e4e:	89 04 24             	mov    %eax,(%esp)
 e51:	e8 ce fe ff ff       	call   d24 <free>
  return freep;
 e56:	a1 d0 13 00 00       	mov    0x13d0,%eax
}
 e5b:	c9                   	leave  
 e5c:	c3                   	ret    

00000e5d <malloc>:

void*
malloc(uint nbytes)
{
 e5d:	55                   	push   %ebp
 e5e:	89 e5                	mov    %esp,%ebp
 e60:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e63:	8b 45 08             	mov    0x8(%ebp),%eax
 e66:	83 c0 07             	add    $0x7,%eax
 e69:	c1 e8 03             	shr    $0x3,%eax
 e6c:	40                   	inc    %eax
 e6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e70:	a1 d0 13 00 00       	mov    0x13d0,%eax
 e75:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e7c:	75 23                	jne    ea1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 e7e:	c7 45 f0 c8 13 00 00 	movl   $0x13c8,-0x10(%ebp)
 e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e88:	a3 d0 13 00 00       	mov    %eax,0x13d0
 e8d:	a1 d0 13 00 00       	mov    0x13d0,%eax
 e92:	a3 c8 13 00 00       	mov    %eax,0x13c8
    base.s.size = 0;
 e97:	c7 05 cc 13 00 00 00 	movl   $0x0,0x13cc
 e9e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ea1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ea4:	8b 00                	mov    (%eax),%eax
 ea6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eac:	8b 40 04             	mov    0x4(%eax),%eax
 eaf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 eb2:	72 4d                	jb     f01 <malloc+0xa4>
      if(p->s.size == nunits)
 eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb7:	8b 40 04             	mov    0x4(%eax),%eax
 eba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ebd:	75 0c                	jne    ecb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 ebf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec2:	8b 10                	mov    (%eax),%edx
 ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ec7:	89 10                	mov    %edx,(%eax)
 ec9:	eb 26                	jmp    ef1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ece:	8b 40 04             	mov    0x4(%eax),%eax
 ed1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ed4:	89 c2                	mov    %eax,%edx
 ed6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ed9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 edf:	8b 40 04             	mov    0x4(%eax),%eax
 ee2:	c1 e0 03             	shl    $0x3,%eax
 ee5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eeb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 eee:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ef4:	a3 d0 13 00 00       	mov    %eax,0x13d0
      return (void*)(p + 1);
 ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 efc:	83 c0 08             	add    $0x8,%eax
 eff:	eb 38                	jmp    f39 <malloc+0xdc>
    }
    if(p == freep)
 f01:	a1 d0 13 00 00       	mov    0x13d0,%eax
 f06:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 f09:	75 1b                	jne    f26 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 f0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 f0e:	89 04 24             	mov    %eax,(%esp)
 f11:	e8 ef fe ff ff       	call   e05 <morecore>
 f16:	89 45 f4             	mov    %eax,-0xc(%ebp)
 f19:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 f1d:	75 07                	jne    f26 <malloc+0xc9>
        return 0;
 f1f:	b8 00 00 00 00       	mov    $0x0,%eax
 f24:	eb 13                	jmp    f39 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f29:	89 45 f0             	mov    %eax,-0x10(%ebp)
 f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f2f:	8b 00                	mov    (%eax),%eax
 f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 f34:	e9 70 ff ff ff       	jmp    ea9 <malloc+0x4c>
}
 f39:	c9                   	leave  
 f3a:	c3                   	ret    
