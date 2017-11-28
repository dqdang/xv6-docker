
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
      1b:	05 e0 15 00 00       	add    $0x15e0,%eax
      20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
      23:	c7 45 f0 e0 15 00 00 	movl   $0x15e0,-0x10(%ebp)
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
      6d:	e8 a6 0a 00 00       	call   b18 <write>
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
      87:	e8 de 04 00 00       	call   56a <strchr>
      8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      93:	75 97                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
      95:	81 7d f0 e0 15 00 00 	cmpl   $0x15e0,-0x10(%ebp)
      9c:	75 07                	jne    a5 <grep+0xa5>
      m = 0;
      9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
      a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      a9:	7e 29                	jle    d4 <grep+0xd4>
      m -= p - buf;
      ab:	ba e0 15 00 00       	mov    $0x15e0,%edx
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	29 c2                	sub    %eax,%edx
      b5:	89 d0                	mov    %edx,%eax
      b7:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
      ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
      bd:	89 44 24 08          	mov    %eax,0x8(%esp)
      c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
      c4:	89 44 24 04          	mov    %eax,0x4(%esp)
      c8:	c7 04 24 e0 15 00 00 	movl   $0x15e0,(%esp)
      cf:	e8 dd 09 00 00       	call   ab1 <memmove>
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
      e3:	81 c2 e0 15 00 00    	add    $0x15e0,%edx
      e9:	89 44 24 08          	mov    %eax,0x8(%esp)
      ed:	89 54 24 04          	mov    %edx,0x4(%esp)
      f1:	8b 45 0c             	mov    0xc(%ebp),%eax
      f4:	89 04 24             	mov    %eax,(%esp)
      f7:	e8 14 0a 00 00       	call   b10 <read>
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
     11a:	c7 44 24 04 e4 10 00 	movl   $0x10e4,0x4(%esp)
     121:	00 
     122:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     129:	e8 ef 0b 00 00       	call   d1d <printf>
    exit();
     12e:	e8 c5 09 00 00       	call   af8 <exit>
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
     157:	e8 9c 09 00 00       	call   af8 <exit>
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
     186:	e8 ad 09 00 00       	call   b38 <open>
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
     1ac:	c7 44 24 04 04 11 00 	movl   $0x1104,0x4(%esp)
     1b3:	00 
     1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1bb:	e8 5d 0b 00 00       	call   d1d <printf>
      exit();
     1c0:	e8 33 09 00 00       	call   af8 <exit>
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
     1e0:	e8 3b 09 00 00       	call   b20 <close>
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
     1f6:	e8 fd 08 00 00       	call   af8 <exit>

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

0000039b <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     39b:	55                   	push   %ebp
     39c:	89 e5                	mov    %esp,%ebp
     39e:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     3a1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     3a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3af:	00 
     3b0:	8b 45 08             	mov    0x8(%ebp),%eax
     3b3:	89 04 24             	mov    %eax,(%esp)
     3b6:	e8 7d 07 00 00       	call   b38 <open>
     3bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
     3be:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3c2:	79 20                	jns    3e4 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     3c4:	8b 45 08             	mov    0x8(%ebp),%eax
     3c7:	89 44 24 08          	mov    %eax,0x8(%esp)
     3cb:	c7 44 24 04 1a 11 00 	movl   $0x111a,0x4(%esp)
     3d2:	00 
     3d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3da:	e8 3e 09 00 00       	call   d1d <printf>
      exit();
     3df:	e8 14 07 00 00       	call   af8 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     3e4:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     3eb:	00 
     3ec:	8b 45 0c             	mov    0xc(%ebp),%eax
     3ef:	89 04 24             	mov    %eax,(%esp)
     3f2:	e8 41 07 00 00       	call   b38 <open>
     3f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
     3fa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     3fe:	79 20                	jns    420 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     400:	8b 45 0c             	mov    0xc(%ebp),%eax
     403:	89 44 24 08          	mov    %eax,0x8(%esp)
     407:	c7 44 24 04 35 11 00 	movl   $0x1135,0x4(%esp)
     40e:	00 
     40f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     416:	e8 02 09 00 00       	call   d1d <printf>
      exit();
     41b:	e8 d8 06 00 00       	call   af8 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     420:	eb 3b                	jmp    45d <copy+0xc2>
  {
      max = used_disk+=count;
     422:	8b 45 e8             	mov    -0x18(%ebp),%eax
     425:	01 45 10             	add    %eax,0x10(%ebp)
     428:	8b 45 10             	mov    0x10(%ebp),%eax
     42b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     42e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     431:	3b 45 14             	cmp    0x14(%ebp),%eax
     434:	7e 07                	jle    43d <copy+0xa2>
      {
        return -1;
     436:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     43b:	eb 5c                	jmp    499 <copy+0xfe>
      }
      bytes = bytes + count;
     43d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     440:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     443:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     44a:	00 
     44b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     44e:	89 44 24 04          	mov    %eax,0x4(%esp)
     452:	8b 45 ec             	mov    -0x14(%ebp),%eax
     455:	89 04 24             	mov    %eax,(%esp)
     458:	e8 bb 06 00 00       	call   b18 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     45d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     464:	00 
     465:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     468:	89 44 24 04          	mov    %eax,0x4(%esp)
     46c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     46f:	89 04 24             	mov    %eax,(%esp)
     472:	e8 99 06 00 00       	call   b10 <read>
     477:	89 45 e8             	mov    %eax,-0x18(%ebp)
     47a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     47e:	7f a2                	jg     422 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     480:	8b 45 f0             	mov    -0x10(%ebp),%eax
     483:	89 04 24             	mov    %eax,(%esp)
     486:	e8 95 06 00 00       	call   b20 <close>
  close(fd2);
     48b:	8b 45 ec             	mov    -0x14(%ebp),%eax
     48e:	89 04 24             	mov    %eax,(%esp)
     491:	e8 8a 06 00 00       	call   b20 <close>
  return(bytes);
     496:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     499:	c9                   	leave  
     49a:	c3                   	ret    

0000049b <strcmp>:

int
strcmp(const char *p, const char *q)
{
     49b:	55                   	push   %ebp
     49c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     49e:	eb 06                	jmp    4a6 <strcmp+0xb>
    p++, q++;
     4a0:	ff 45 08             	incl   0x8(%ebp)
     4a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     4a6:	8b 45 08             	mov    0x8(%ebp),%eax
     4a9:	8a 00                	mov    (%eax),%al
     4ab:	84 c0                	test   %al,%al
     4ad:	74 0e                	je     4bd <strcmp+0x22>
     4af:	8b 45 08             	mov    0x8(%ebp),%eax
     4b2:	8a 10                	mov    (%eax),%dl
     4b4:	8b 45 0c             	mov    0xc(%ebp),%eax
     4b7:	8a 00                	mov    (%eax),%al
     4b9:	38 c2                	cmp    %al,%dl
     4bb:	74 e3                	je     4a0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     4bd:	8b 45 08             	mov    0x8(%ebp),%eax
     4c0:	8a 00                	mov    (%eax),%al
     4c2:	0f b6 d0             	movzbl %al,%edx
     4c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     4c8:	8a 00                	mov    (%eax),%al
     4ca:	0f b6 c0             	movzbl %al,%eax
     4cd:	29 c2                	sub    %eax,%edx
     4cf:	89 d0                	mov    %edx,%eax
}
     4d1:	5d                   	pop    %ebp
     4d2:	c3                   	ret    

000004d3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     4d3:	55                   	push   %ebp
     4d4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     4d6:	eb 09                	jmp    4e1 <strncmp+0xe>
    n--, p++, q++;
     4d8:	ff 4d 10             	decl   0x10(%ebp)
     4db:	ff 45 08             	incl   0x8(%ebp)
     4de:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     4e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     4e5:	74 17                	je     4fe <strncmp+0x2b>
     4e7:	8b 45 08             	mov    0x8(%ebp),%eax
     4ea:	8a 00                	mov    (%eax),%al
     4ec:	84 c0                	test   %al,%al
     4ee:	74 0e                	je     4fe <strncmp+0x2b>
     4f0:	8b 45 08             	mov    0x8(%ebp),%eax
     4f3:	8a 10                	mov    (%eax),%dl
     4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     4f8:	8a 00                	mov    (%eax),%al
     4fa:	38 c2                	cmp    %al,%dl
     4fc:	74 da                	je     4d8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     4fe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     502:	75 07                	jne    50b <strncmp+0x38>
    return 0;
     504:	b8 00 00 00 00       	mov    $0x0,%eax
     509:	eb 14                	jmp    51f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     50b:	8b 45 08             	mov    0x8(%ebp),%eax
     50e:	8a 00                	mov    (%eax),%al
     510:	0f b6 d0             	movzbl %al,%edx
     513:	8b 45 0c             	mov    0xc(%ebp),%eax
     516:	8a 00                	mov    (%eax),%al
     518:	0f b6 c0             	movzbl %al,%eax
     51b:	29 c2                	sub    %eax,%edx
     51d:	89 d0                	mov    %edx,%eax
}
     51f:	5d                   	pop    %ebp
     520:	c3                   	ret    

00000521 <strlen>:

uint
strlen(const char *s)
{
     521:	55                   	push   %ebp
     522:	89 e5                	mov    %esp,%ebp
     524:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     527:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     52e:	eb 03                	jmp    533 <strlen+0x12>
     530:	ff 45 fc             	incl   -0x4(%ebp)
     533:	8b 55 fc             	mov    -0x4(%ebp),%edx
     536:	8b 45 08             	mov    0x8(%ebp),%eax
     539:	01 d0                	add    %edx,%eax
     53b:	8a 00                	mov    (%eax),%al
     53d:	84 c0                	test   %al,%al
     53f:	75 ef                	jne    530 <strlen+0xf>
    ;
  return n;
     541:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     544:	c9                   	leave  
     545:	c3                   	ret    

00000546 <memset>:

void*
memset(void *dst, int c, uint n)
{
     546:	55                   	push   %ebp
     547:	89 e5                	mov    %esp,%ebp
     549:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     54c:	8b 45 10             	mov    0x10(%ebp),%eax
     54f:	89 44 24 08          	mov    %eax,0x8(%esp)
     553:	8b 45 0c             	mov    0xc(%ebp),%eax
     556:	89 44 24 04          	mov    %eax,0x4(%esp)
     55a:	8b 45 08             	mov    0x8(%ebp),%eax
     55d:	89 04 24             	mov    %eax,(%esp)
     560:	e8 e3 fd ff ff       	call   348 <stosb>
  return dst;
     565:	8b 45 08             	mov    0x8(%ebp),%eax
}
     568:	c9                   	leave  
     569:	c3                   	ret    

0000056a <strchr>:

char*
strchr(const char *s, char c)
{
     56a:	55                   	push   %ebp
     56b:	89 e5                	mov    %esp,%ebp
     56d:	83 ec 04             	sub    $0x4,%esp
     570:	8b 45 0c             	mov    0xc(%ebp),%eax
     573:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     576:	eb 12                	jmp    58a <strchr+0x20>
    if(*s == c)
     578:	8b 45 08             	mov    0x8(%ebp),%eax
     57b:	8a 00                	mov    (%eax),%al
     57d:	3a 45 fc             	cmp    -0x4(%ebp),%al
     580:	75 05                	jne    587 <strchr+0x1d>
      return (char*)s;
     582:	8b 45 08             	mov    0x8(%ebp),%eax
     585:	eb 11                	jmp    598 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     587:	ff 45 08             	incl   0x8(%ebp)
     58a:	8b 45 08             	mov    0x8(%ebp),%eax
     58d:	8a 00                	mov    (%eax),%al
     58f:	84 c0                	test   %al,%al
     591:	75 e5                	jne    578 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     593:	b8 00 00 00 00       	mov    $0x0,%eax
}
     598:	c9                   	leave  
     599:	c3                   	ret    

0000059a <strcat>:

char *
strcat(char *dest, const char *src)
{
     59a:	55                   	push   %ebp
     59b:	89 e5                	mov    %esp,%ebp
     59d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     5a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     5a7:	eb 03                	jmp    5ac <strcat+0x12>
     5a9:	ff 45 fc             	incl   -0x4(%ebp)
     5ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5af:	8b 45 08             	mov    0x8(%ebp),%eax
     5b2:	01 d0                	add    %edx,%eax
     5b4:	8a 00                	mov    (%eax),%al
     5b6:	84 c0                	test   %al,%al
     5b8:	75 ef                	jne    5a9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     5ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     5c1:	eb 1e                	jmp    5e1 <strcat+0x47>
        dest[i+j] = src[j];
     5c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     5c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5c9:	01 d0                	add    %edx,%eax
     5cb:	89 c2                	mov    %eax,%edx
     5cd:	8b 45 08             	mov    0x8(%ebp),%eax
     5d0:	01 c2                	add    %eax,%edx
     5d2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     5d5:	8b 45 0c             	mov    0xc(%ebp),%eax
     5d8:	01 c8                	add    %ecx,%eax
     5da:	8a 00                	mov    (%eax),%al
     5dc:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     5de:	ff 45 f8             	incl   -0x8(%ebp)
     5e1:	8b 55 f8             	mov    -0x8(%ebp),%edx
     5e4:	8b 45 0c             	mov    0xc(%ebp),%eax
     5e7:	01 d0                	add    %edx,%eax
     5e9:	8a 00                	mov    (%eax),%al
     5eb:	84 c0                	test   %al,%al
     5ed:	75 d4                	jne    5c3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     5ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
     5f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5f5:	01 d0                	add    %edx,%eax
     5f7:	89 c2                	mov    %eax,%edx
     5f9:	8b 45 08             	mov    0x8(%ebp),%eax
     5fc:	01 d0                	add    %edx,%eax
     5fe:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     601:	8b 45 08             	mov    0x8(%ebp),%eax
}
     604:	c9                   	leave  
     605:	c3                   	ret    

00000606 <strstr>:

int 
strstr(char* s, char* sub)
{
     606:	55                   	push   %ebp
     607:	89 e5                	mov    %esp,%ebp
     609:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     60c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     613:	eb 7c                	jmp    691 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     615:	8b 55 fc             	mov    -0x4(%ebp),%edx
     618:	8b 45 08             	mov    0x8(%ebp),%eax
     61b:	01 d0                	add    %edx,%eax
     61d:	8a 10                	mov    (%eax),%dl
     61f:	8b 45 0c             	mov    0xc(%ebp),%eax
     622:	8a 00                	mov    (%eax),%al
     624:	38 c2                	cmp    %al,%dl
     626:	75 66                	jne    68e <strstr+0x88>
        {
            if(strlen(sub) == 1)
     628:	8b 45 0c             	mov    0xc(%ebp),%eax
     62b:	89 04 24             	mov    %eax,(%esp)
     62e:	e8 ee fe ff ff       	call   521 <strlen>
     633:	83 f8 01             	cmp    $0x1,%eax
     636:	75 05                	jne    63d <strstr+0x37>
            {  
                return i;
     638:	8b 45 fc             	mov    -0x4(%ebp),%eax
     63b:	eb 6b                	jmp    6a8 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     63d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     644:	eb 3a                	jmp    680 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     646:	8b 45 f8             	mov    -0x8(%ebp),%eax
     649:	8b 55 fc             	mov    -0x4(%ebp),%edx
     64c:	01 d0                	add    %edx,%eax
     64e:	89 c2                	mov    %eax,%edx
     650:	8b 45 08             	mov    0x8(%ebp),%eax
     653:	01 d0                	add    %edx,%eax
     655:	8a 10                	mov    (%eax),%dl
     657:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     65a:	8b 45 0c             	mov    0xc(%ebp),%eax
     65d:	01 c8                	add    %ecx,%eax
     65f:	8a 00                	mov    (%eax),%al
     661:	38 c2                	cmp    %al,%dl
     663:	75 16                	jne    67b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     665:	8b 45 f8             	mov    -0x8(%ebp),%eax
     668:	8d 50 01             	lea    0x1(%eax),%edx
     66b:	8b 45 0c             	mov    0xc(%ebp),%eax
     66e:	01 d0                	add    %edx,%eax
     670:	8a 00                	mov    (%eax),%al
     672:	84 c0                	test   %al,%al
     674:	75 07                	jne    67d <strstr+0x77>
                    {
                        return i;
     676:	8b 45 fc             	mov    -0x4(%ebp),%eax
     679:	eb 2d                	jmp    6a8 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     67b:	eb 11                	jmp    68e <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     67d:	ff 45 f8             	incl   -0x8(%ebp)
     680:	8b 55 f8             	mov    -0x8(%ebp),%edx
     683:	8b 45 0c             	mov    0xc(%ebp),%eax
     686:	01 d0                	add    %edx,%eax
     688:	8a 00                	mov    (%eax),%al
     68a:	84 c0                	test   %al,%al
     68c:	75 b8                	jne    646 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     68e:	ff 45 fc             	incl   -0x4(%ebp)
     691:	8b 55 fc             	mov    -0x4(%ebp),%edx
     694:	8b 45 08             	mov    0x8(%ebp),%eax
     697:	01 d0                	add    %edx,%eax
     699:	8a 00                	mov    (%eax),%al
     69b:	84 c0                	test   %al,%al
     69d:	0f 85 72 ff ff ff    	jne    615 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     6a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     6a8:	c9                   	leave  
     6a9:	c3                   	ret    

000006aa <strtok>:

char *
strtok(char *s, const char *delim)
{
     6aa:	55                   	push   %ebp
     6ab:	89 e5                	mov    %esp,%ebp
     6ad:	53                   	push   %ebx
     6ae:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     6b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     6b5:	75 08                	jne    6bf <strtok+0x15>
  s = lasts;
     6b7:	a1 c4 15 00 00       	mov    0x15c4,%eax
     6bc:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     6bf:	8b 45 08             	mov    0x8(%ebp),%eax
     6c2:	8d 50 01             	lea    0x1(%eax),%edx
     6c5:	89 55 08             	mov    %edx,0x8(%ebp)
     6c8:	8a 00                	mov    (%eax),%al
     6ca:	0f be d8             	movsbl %al,%ebx
     6cd:	85 db                	test   %ebx,%ebx
     6cf:	75 07                	jne    6d8 <strtok+0x2e>
      return 0;
     6d1:	b8 00 00 00 00       	mov    $0x0,%eax
     6d6:	eb 58                	jmp    730 <strtok+0x86>
    } while (strchr(delim, ch));
     6d8:	88 d8                	mov    %bl,%al
     6da:	0f be c0             	movsbl %al,%eax
     6dd:	89 44 24 04          	mov    %eax,0x4(%esp)
     6e1:	8b 45 0c             	mov    0xc(%ebp),%eax
     6e4:	89 04 24             	mov    %eax,(%esp)
     6e7:	e8 7e fe ff ff       	call   56a <strchr>
     6ec:	85 c0                	test   %eax,%eax
     6ee:	75 cf                	jne    6bf <strtok+0x15>
    --s;
     6f0:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     6f3:	8b 45 0c             	mov    0xc(%ebp),%eax
     6f6:	89 44 24 04          	mov    %eax,0x4(%esp)
     6fa:	8b 45 08             	mov    0x8(%ebp),%eax
     6fd:	89 04 24             	mov    %eax,(%esp)
     700:	e8 31 00 00 00       	call   736 <strcspn>
     705:	89 c2                	mov    %eax,%edx
     707:	8b 45 08             	mov    0x8(%ebp),%eax
     70a:	01 d0                	add    %edx,%eax
     70c:	a3 c4 15 00 00       	mov    %eax,0x15c4
    if (*lasts != 0)
     711:	a1 c4 15 00 00       	mov    0x15c4,%eax
     716:	8a 00                	mov    (%eax),%al
     718:	84 c0                	test   %al,%al
     71a:	74 11                	je     72d <strtok+0x83>
  *lasts++ = 0;
     71c:	a1 c4 15 00 00       	mov    0x15c4,%eax
     721:	8d 50 01             	lea    0x1(%eax),%edx
     724:	89 15 c4 15 00 00    	mov    %edx,0x15c4
     72a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     72d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     730:	83 c4 14             	add    $0x14,%esp
     733:	5b                   	pop    %ebx
     734:	5d                   	pop    %ebp
     735:	c3                   	ret    

00000736 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     736:	55                   	push   %ebp
     737:	89 e5                	mov    %esp,%ebp
     739:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     73c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     743:	eb 26                	jmp    76b <strcspn+0x35>
        if(strchr(s2,*s1))
     745:	8b 45 08             	mov    0x8(%ebp),%eax
     748:	8a 00                	mov    (%eax),%al
     74a:	0f be c0             	movsbl %al,%eax
     74d:	89 44 24 04          	mov    %eax,0x4(%esp)
     751:	8b 45 0c             	mov    0xc(%ebp),%eax
     754:	89 04 24             	mov    %eax,(%esp)
     757:	e8 0e fe ff ff       	call   56a <strchr>
     75c:	85 c0                	test   %eax,%eax
     75e:	74 05                	je     765 <strcspn+0x2f>
            return ret;
     760:	8b 45 fc             	mov    -0x4(%ebp),%eax
     763:	eb 12                	jmp    777 <strcspn+0x41>
        else
            s1++,ret++;
     765:	ff 45 08             	incl   0x8(%ebp)
     768:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     76b:	8b 45 08             	mov    0x8(%ebp),%eax
     76e:	8a 00                	mov    (%eax),%al
     770:	84 c0                	test   %al,%al
     772:	75 d1                	jne    745 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     774:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     777:	c9                   	leave  
     778:	c3                   	ret    

00000779 <isspace>:

int
isspace(unsigned char c)
{
     779:	55                   	push   %ebp
     77a:	89 e5                	mov    %esp,%ebp
     77c:	83 ec 04             	sub    $0x4,%esp
     77f:	8b 45 08             	mov    0x8(%ebp),%eax
     782:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     785:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     789:	74 1e                	je     7a9 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     78b:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     78f:	74 18                	je     7a9 <isspace+0x30>
     791:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     795:	74 12                	je     7a9 <isspace+0x30>
     797:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     79b:	74 0c                	je     7a9 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     79d:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     7a1:	74 06                	je     7a9 <isspace+0x30>
     7a3:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     7a7:	75 07                	jne    7b0 <isspace+0x37>
     7a9:	b8 01 00 00 00       	mov    $0x1,%eax
     7ae:	eb 05                	jmp    7b5 <isspace+0x3c>
     7b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7b5:	c9                   	leave  
     7b6:	c3                   	ret    

000007b7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     7b7:	55                   	push   %ebp
     7b8:	89 e5                	mov    %esp,%ebp
     7ba:	57                   	push   %edi
     7bb:	56                   	push   %esi
     7bc:	53                   	push   %ebx
     7bd:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     7c0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     7c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     7cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     7cf:	eb 01                	jmp    7d2 <strtoul+0x1b>
  p += 1;
     7d1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     7d2:	8a 03                	mov    (%ebx),%al
     7d4:	0f b6 c0             	movzbl %al,%eax
     7d7:	89 04 24             	mov    %eax,(%esp)
     7da:	e8 9a ff ff ff       	call   779 <isspace>
     7df:	85 c0                	test   %eax,%eax
     7e1:	75 ee                	jne    7d1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     7e3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     7e7:	75 30                	jne    819 <strtoul+0x62>
    {
  if (*p == '0') {
     7e9:	8a 03                	mov    (%ebx),%al
     7eb:	3c 30                	cmp    $0x30,%al
     7ed:	75 21                	jne    810 <strtoul+0x59>
      p += 1;
     7ef:	43                   	inc    %ebx
      if (*p == 'x') {
     7f0:	8a 03                	mov    (%ebx),%al
     7f2:	3c 78                	cmp    $0x78,%al
     7f4:	75 0a                	jne    800 <strtoul+0x49>
    p += 1;
     7f6:	43                   	inc    %ebx
    base = 16;
     7f7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     7fe:	eb 31                	jmp    831 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     800:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     807:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     80e:	eb 21                	jmp    831 <strtoul+0x7a>
      }
  }
  else base = 10;
     810:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     817:	eb 18                	jmp    831 <strtoul+0x7a>
    } else if (base == 16) {
     819:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     81d:	75 12                	jne    831 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     81f:	8a 03                	mov    (%ebx),%al
     821:	3c 30                	cmp    $0x30,%al
     823:	75 0c                	jne    831 <strtoul+0x7a>
     825:	8d 43 01             	lea    0x1(%ebx),%eax
     828:	8a 00                	mov    (%eax),%al
     82a:	3c 78                	cmp    $0x78,%al
     82c:	75 03                	jne    831 <strtoul+0x7a>
      p += 2;
     82e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     831:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     835:	75 29                	jne    860 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     837:	8a 03                	mov    (%ebx),%al
     839:	0f be c0             	movsbl %al,%eax
     83c:	83 e8 30             	sub    $0x30,%eax
     83f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     841:	83 fe 07             	cmp    $0x7,%esi
     844:	76 06                	jbe    84c <strtoul+0x95>
    break;
     846:	90                   	nop
     847:	e9 b6 00 00 00       	jmp    902 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     84c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     853:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     856:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     85d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     85e:	eb d7                	jmp    837 <strtoul+0x80>
    } else if (base == 10) {
     860:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     864:	75 2b                	jne    891 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     866:	8a 03                	mov    (%ebx),%al
     868:	0f be c0             	movsbl %al,%eax
     86b:	83 e8 30             	sub    $0x30,%eax
     86e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     870:	83 fe 09             	cmp    $0x9,%esi
     873:	76 06                	jbe    87b <strtoul+0xc4>
    break;
     875:	90                   	nop
     876:	e9 87 00 00 00       	jmp    902 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     87b:	89 f8                	mov    %edi,%eax
     87d:	c1 e0 02             	shl    $0x2,%eax
     880:	01 f8                	add    %edi,%eax
     882:	01 c0                	add    %eax,%eax
     884:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     887:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     88e:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     88f:	eb d5                	jmp    866 <strtoul+0xaf>
    } else if (base == 16) {
     891:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     895:	75 35                	jne    8cc <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     897:	8a 03                	mov    (%ebx),%al
     899:	0f be c0             	movsbl %al,%eax
     89c:	83 e8 30             	sub    $0x30,%eax
     89f:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8a1:	83 fe 4a             	cmp    $0x4a,%esi
     8a4:	76 02                	jbe    8a8 <strtoul+0xf1>
    break;
     8a6:	eb 22                	jmp    8ca <strtoul+0x113>
      }
      digit = cvtIn[digit];
     8a8:	8a 86 60 15 00 00    	mov    0x1560(%esi),%al
     8ae:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     8b1:	83 fe 0f             	cmp    $0xf,%esi
     8b4:	76 02                	jbe    8b8 <strtoul+0x101>
    break;
     8b6:	eb 12                	jmp    8ca <strtoul+0x113>
      }
      result = (result << 4) + digit;
     8b8:	89 f8                	mov    %edi,%eax
     8ba:	c1 e0 04             	shl    $0x4,%eax
     8bd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     8c0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     8c7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     8c8:	eb cd                	jmp    897 <strtoul+0xe0>
     8ca:	eb 36                	jmp    902 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     8cc:	8a 03                	mov    (%ebx),%al
     8ce:	0f be c0             	movsbl %al,%eax
     8d1:	83 e8 30             	sub    $0x30,%eax
     8d4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8d6:	83 fe 4a             	cmp    $0x4a,%esi
     8d9:	76 02                	jbe    8dd <strtoul+0x126>
    break;
     8db:	eb 25                	jmp    902 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     8dd:	8a 86 60 15 00 00    	mov    0x1560(%esi),%al
     8e3:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     8e6:	8b 45 10             	mov    0x10(%ebp),%eax
     8e9:	39 f0                	cmp    %esi,%eax
     8eb:	77 02                	ja     8ef <strtoul+0x138>
    break;
     8ed:	eb 13                	jmp    902 <strtoul+0x14b>
      }
      result = result*base + digit;
     8ef:	8b 45 10             	mov    0x10(%ebp),%eax
     8f2:	0f af c7             	imul   %edi,%eax
     8f5:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     8f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     8ff:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     900:	eb ca                	jmp    8cc <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     902:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     906:	75 03                	jne    90b <strtoul+0x154>
  p = string;
     908:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     90b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     90f:	74 05                	je     916 <strtoul+0x15f>
  *endPtr = p;
     911:	8b 45 0c             	mov    0xc(%ebp),%eax
     914:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     916:	89 f8                	mov    %edi,%eax
}
     918:	83 c4 14             	add    $0x14,%esp
     91b:	5b                   	pop    %ebx
     91c:	5e                   	pop    %esi
     91d:	5f                   	pop    %edi
     91e:	5d                   	pop    %ebp
     91f:	c3                   	ret    

00000920 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     920:	55                   	push   %ebp
     921:	89 e5                	mov    %esp,%ebp
     923:	53                   	push   %ebx
     924:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     927:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     92a:	eb 01                	jmp    92d <strtol+0xd>
      p += 1;
     92c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     92d:	8a 03                	mov    (%ebx),%al
     92f:	0f b6 c0             	movzbl %al,%eax
     932:	89 04 24             	mov    %eax,(%esp)
     935:	e8 3f fe ff ff       	call   779 <isspace>
     93a:	85 c0                	test   %eax,%eax
     93c:	75 ee                	jne    92c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     93e:	8a 03                	mov    (%ebx),%al
     940:	3c 2d                	cmp    $0x2d,%al
     942:	75 1e                	jne    962 <strtol+0x42>
  p += 1;
     944:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     945:	8b 45 10             	mov    0x10(%ebp),%eax
     948:	89 44 24 08          	mov    %eax,0x8(%esp)
     94c:	8b 45 0c             	mov    0xc(%ebp),%eax
     94f:	89 44 24 04          	mov    %eax,0x4(%esp)
     953:	89 1c 24             	mov    %ebx,(%esp)
     956:	e8 5c fe ff ff       	call   7b7 <strtoul>
     95b:	f7 d8                	neg    %eax
     95d:	89 45 f8             	mov    %eax,-0x8(%ebp)
     960:	eb 20                	jmp    982 <strtol+0x62>
    } else {
  if (*p == '+') {
     962:	8a 03                	mov    (%ebx),%al
     964:	3c 2b                	cmp    $0x2b,%al
     966:	75 01                	jne    969 <strtol+0x49>
      p += 1;
     968:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     969:	8b 45 10             	mov    0x10(%ebp),%eax
     96c:	89 44 24 08          	mov    %eax,0x8(%esp)
     970:	8b 45 0c             	mov    0xc(%ebp),%eax
     973:	89 44 24 04          	mov    %eax,0x4(%esp)
     977:	89 1c 24             	mov    %ebx,(%esp)
     97a:	e8 38 fe ff ff       	call   7b7 <strtoul>
     97f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     982:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     986:	75 17                	jne    99f <strtol+0x7f>
     988:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     98c:	74 11                	je     99f <strtol+0x7f>
     98e:	8b 45 0c             	mov    0xc(%ebp),%eax
     991:	8b 00                	mov    (%eax),%eax
     993:	39 d8                	cmp    %ebx,%eax
     995:	75 08                	jne    99f <strtol+0x7f>
  *endPtr = string;
     997:	8b 45 0c             	mov    0xc(%ebp),%eax
     99a:	8b 55 08             	mov    0x8(%ebp),%edx
     99d:	89 10                	mov    %edx,(%eax)
    }
    return result;
     99f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     9a2:	83 c4 1c             	add    $0x1c,%esp
     9a5:	5b                   	pop    %ebx
     9a6:	5d                   	pop    %ebp
     9a7:	c3                   	ret    

000009a8 <gets>:

char*
gets(char *buf, int max)
{
     9a8:	55                   	push   %ebp
     9a9:	89 e5                	mov    %esp,%ebp
     9ab:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9b5:	eb 49                	jmp    a00 <gets+0x58>
    cc = read(0, &c, 1);
     9b7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     9be:	00 
     9bf:	8d 45 ef             	lea    -0x11(%ebp),%eax
     9c2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9cd:	e8 3e 01 00 00       	call   b10 <read>
     9d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     9d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9d9:	7f 02                	jg     9dd <gets+0x35>
      break;
     9db:	eb 2c                	jmp    a09 <gets+0x61>
    buf[i++] = c;
     9dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9e0:	8d 50 01             	lea    0x1(%eax),%edx
     9e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9e6:	89 c2                	mov    %eax,%edx
     9e8:	8b 45 08             	mov    0x8(%ebp),%eax
     9eb:	01 c2                	add    %eax,%edx
     9ed:	8a 45 ef             	mov    -0x11(%ebp),%al
     9f0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     9f2:	8a 45 ef             	mov    -0x11(%ebp),%al
     9f5:	3c 0a                	cmp    $0xa,%al
     9f7:	74 10                	je     a09 <gets+0x61>
     9f9:	8a 45 ef             	mov    -0x11(%ebp),%al
     9fc:	3c 0d                	cmp    $0xd,%al
     9fe:	74 09                	je     a09 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a03:	40                   	inc    %eax
     a04:	3b 45 0c             	cmp    0xc(%ebp),%eax
     a07:	7c ae                	jl     9b7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     a09:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a0c:	8b 45 08             	mov    0x8(%ebp),%eax
     a0f:	01 d0                	add    %edx,%eax
     a11:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     a14:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a17:	c9                   	leave  
     a18:	c3                   	ret    

00000a19 <stat>:

int
stat(char *n, struct stat *st)
{
     a19:	55                   	push   %ebp
     a1a:	89 e5                	mov    %esp,%ebp
     a1c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a1f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     a26:	00 
     a27:	8b 45 08             	mov    0x8(%ebp),%eax
     a2a:	89 04 24             	mov    %eax,(%esp)
     a2d:	e8 06 01 00 00       	call   b38 <open>
     a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     a35:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     a39:	79 07                	jns    a42 <stat+0x29>
    return -1;
     a3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a40:	eb 23                	jmp    a65 <stat+0x4c>
  r = fstat(fd, st);
     a42:	8b 45 0c             	mov    0xc(%ebp),%eax
     a45:	89 44 24 04          	mov    %eax,0x4(%esp)
     a49:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a4c:	89 04 24             	mov    %eax,(%esp)
     a4f:	e8 fc 00 00 00       	call   b50 <fstat>
     a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a5a:	89 04 24             	mov    %eax,(%esp)
     a5d:	e8 be 00 00 00       	call   b20 <close>
  return r;
     a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a65:	c9                   	leave  
     a66:	c3                   	ret    

00000a67 <atoi>:

int
atoi(const char *s)
{
     a67:	55                   	push   %ebp
     a68:	89 e5                	mov    %esp,%ebp
     a6a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     a6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     a74:	eb 24                	jmp    a9a <atoi+0x33>
    n = n*10 + *s++ - '0';
     a76:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a79:	89 d0                	mov    %edx,%eax
     a7b:	c1 e0 02             	shl    $0x2,%eax
     a7e:	01 d0                	add    %edx,%eax
     a80:	01 c0                	add    %eax,%eax
     a82:	89 c1                	mov    %eax,%ecx
     a84:	8b 45 08             	mov    0x8(%ebp),%eax
     a87:	8d 50 01             	lea    0x1(%eax),%edx
     a8a:	89 55 08             	mov    %edx,0x8(%ebp)
     a8d:	8a 00                	mov    (%eax),%al
     a8f:	0f be c0             	movsbl %al,%eax
     a92:	01 c8                	add    %ecx,%eax
     a94:	83 e8 30             	sub    $0x30,%eax
     a97:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a9a:	8b 45 08             	mov    0x8(%ebp),%eax
     a9d:	8a 00                	mov    (%eax),%al
     a9f:	3c 2f                	cmp    $0x2f,%al
     aa1:	7e 09                	jle    aac <atoi+0x45>
     aa3:	8b 45 08             	mov    0x8(%ebp),%eax
     aa6:	8a 00                	mov    (%eax),%al
     aa8:	3c 39                	cmp    $0x39,%al
     aaa:	7e ca                	jle    a76 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     aac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     aaf:	c9                   	leave  
     ab0:	c3                   	ret    

00000ab1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     ab1:	55                   	push   %ebp
     ab2:	89 e5                	mov    %esp,%ebp
     ab4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     ab7:	8b 45 08             	mov    0x8(%ebp),%eax
     aba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     abd:	8b 45 0c             	mov    0xc(%ebp),%eax
     ac0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     ac3:	eb 16                	jmp    adb <memmove+0x2a>
    *dst++ = *src++;
     ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ac8:	8d 50 01             	lea    0x1(%eax),%edx
     acb:	89 55 fc             	mov    %edx,-0x4(%ebp)
     ace:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ad1:	8d 4a 01             	lea    0x1(%edx),%ecx
     ad4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     ad7:	8a 12                	mov    (%edx),%dl
     ad9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     adb:	8b 45 10             	mov    0x10(%ebp),%eax
     ade:	8d 50 ff             	lea    -0x1(%eax),%edx
     ae1:	89 55 10             	mov    %edx,0x10(%ebp)
     ae4:	85 c0                	test   %eax,%eax
     ae6:	7f dd                	jg     ac5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     ae8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     aeb:	c9                   	leave  
     aec:	c3                   	ret    
     aed:	90                   	nop
     aee:	90                   	nop
     aef:	90                   	nop

00000af0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     af0:	b8 01 00 00 00       	mov    $0x1,%eax
     af5:	cd 40                	int    $0x40
     af7:	c3                   	ret    

00000af8 <exit>:
SYSCALL(exit)
     af8:	b8 02 00 00 00       	mov    $0x2,%eax
     afd:	cd 40                	int    $0x40
     aff:	c3                   	ret    

00000b00 <wait>:
SYSCALL(wait)
     b00:	b8 03 00 00 00       	mov    $0x3,%eax
     b05:	cd 40                	int    $0x40
     b07:	c3                   	ret    

00000b08 <pipe>:
SYSCALL(pipe)
     b08:	b8 04 00 00 00       	mov    $0x4,%eax
     b0d:	cd 40                	int    $0x40
     b0f:	c3                   	ret    

00000b10 <read>:
SYSCALL(read)
     b10:	b8 05 00 00 00       	mov    $0x5,%eax
     b15:	cd 40                	int    $0x40
     b17:	c3                   	ret    

00000b18 <write>:
SYSCALL(write)
     b18:	b8 10 00 00 00       	mov    $0x10,%eax
     b1d:	cd 40                	int    $0x40
     b1f:	c3                   	ret    

00000b20 <close>:
SYSCALL(close)
     b20:	b8 15 00 00 00       	mov    $0x15,%eax
     b25:	cd 40                	int    $0x40
     b27:	c3                   	ret    

00000b28 <kill>:
SYSCALL(kill)
     b28:	b8 06 00 00 00       	mov    $0x6,%eax
     b2d:	cd 40                	int    $0x40
     b2f:	c3                   	ret    

00000b30 <exec>:
SYSCALL(exec)
     b30:	b8 07 00 00 00       	mov    $0x7,%eax
     b35:	cd 40                	int    $0x40
     b37:	c3                   	ret    

00000b38 <open>:
SYSCALL(open)
     b38:	b8 0f 00 00 00       	mov    $0xf,%eax
     b3d:	cd 40                	int    $0x40
     b3f:	c3                   	ret    

00000b40 <mknod>:
SYSCALL(mknod)
     b40:	b8 11 00 00 00       	mov    $0x11,%eax
     b45:	cd 40                	int    $0x40
     b47:	c3                   	ret    

00000b48 <unlink>:
SYSCALL(unlink)
     b48:	b8 12 00 00 00       	mov    $0x12,%eax
     b4d:	cd 40                	int    $0x40
     b4f:	c3                   	ret    

00000b50 <fstat>:
SYSCALL(fstat)
     b50:	b8 08 00 00 00       	mov    $0x8,%eax
     b55:	cd 40                	int    $0x40
     b57:	c3                   	ret    

00000b58 <link>:
SYSCALL(link)
     b58:	b8 13 00 00 00       	mov    $0x13,%eax
     b5d:	cd 40                	int    $0x40
     b5f:	c3                   	ret    

00000b60 <mkdir>:
SYSCALL(mkdir)
     b60:	b8 14 00 00 00       	mov    $0x14,%eax
     b65:	cd 40                	int    $0x40
     b67:	c3                   	ret    

00000b68 <chdir>:
SYSCALL(chdir)
     b68:	b8 09 00 00 00       	mov    $0x9,%eax
     b6d:	cd 40                	int    $0x40
     b6f:	c3                   	ret    

00000b70 <dup>:
SYSCALL(dup)
     b70:	b8 0a 00 00 00       	mov    $0xa,%eax
     b75:	cd 40                	int    $0x40
     b77:	c3                   	ret    

00000b78 <getpid>:
SYSCALL(getpid)
     b78:	b8 0b 00 00 00       	mov    $0xb,%eax
     b7d:	cd 40                	int    $0x40
     b7f:	c3                   	ret    

00000b80 <sbrk>:
SYSCALL(sbrk)
     b80:	b8 0c 00 00 00       	mov    $0xc,%eax
     b85:	cd 40                	int    $0x40
     b87:	c3                   	ret    

00000b88 <sleep>:
SYSCALL(sleep)
     b88:	b8 0d 00 00 00       	mov    $0xd,%eax
     b8d:	cd 40                	int    $0x40
     b8f:	c3                   	ret    

00000b90 <uptime>:
SYSCALL(uptime)
     b90:	b8 0e 00 00 00       	mov    $0xe,%eax
     b95:	cd 40                	int    $0x40
     b97:	c3                   	ret    

00000b98 <getname>:
SYSCALL(getname)
     b98:	b8 16 00 00 00       	mov    $0x16,%eax
     b9d:	cd 40                	int    $0x40
     b9f:	c3                   	ret    

00000ba0 <setname>:
SYSCALL(setname)
     ba0:	b8 17 00 00 00       	mov    $0x17,%eax
     ba5:	cd 40                	int    $0x40
     ba7:	c3                   	ret    

00000ba8 <getmaxproc>:
SYSCALL(getmaxproc)
     ba8:	b8 18 00 00 00       	mov    $0x18,%eax
     bad:	cd 40                	int    $0x40
     baf:	c3                   	ret    

00000bb0 <setmaxproc>:
SYSCALL(setmaxproc)
     bb0:	b8 19 00 00 00       	mov    $0x19,%eax
     bb5:	cd 40                	int    $0x40
     bb7:	c3                   	ret    

00000bb8 <getmaxmem>:
SYSCALL(getmaxmem)
     bb8:	b8 1a 00 00 00       	mov    $0x1a,%eax
     bbd:	cd 40                	int    $0x40
     bbf:	c3                   	ret    

00000bc0 <setmaxmem>:
SYSCALL(setmaxmem)
     bc0:	b8 1b 00 00 00       	mov    $0x1b,%eax
     bc5:	cd 40                	int    $0x40
     bc7:	c3                   	ret    

00000bc8 <getmaxdisk>:
SYSCALL(getmaxdisk)
     bc8:	b8 1c 00 00 00       	mov    $0x1c,%eax
     bcd:	cd 40                	int    $0x40
     bcf:	c3                   	ret    

00000bd0 <setmaxdisk>:
SYSCALL(setmaxdisk)
     bd0:	b8 1d 00 00 00       	mov    $0x1d,%eax
     bd5:	cd 40                	int    $0x40
     bd7:	c3                   	ret    

00000bd8 <getusedmem>:
SYSCALL(getusedmem)
     bd8:	b8 1e 00 00 00       	mov    $0x1e,%eax
     bdd:	cd 40                	int    $0x40
     bdf:	c3                   	ret    

00000be0 <setusedmem>:
SYSCALL(setusedmem)
     be0:	b8 1f 00 00 00       	mov    $0x1f,%eax
     be5:	cd 40                	int    $0x40
     be7:	c3                   	ret    

00000be8 <getuseddisk>:
SYSCALL(getuseddisk)
     be8:	b8 20 00 00 00       	mov    $0x20,%eax
     bed:	cd 40                	int    $0x40
     bef:	c3                   	ret    

00000bf0 <setuseddisk>:
SYSCALL(setuseddisk)
     bf0:	b8 21 00 00 00       	mov    $0x21,%eax
     bf5:	cd 40                	int    $0x40
     bf7:	c3                   	ret    

00000bf8 <setvc>:
SYSCALL(setvc)
     bf8:	b8 22 00 00 00       	mov    $0x22,%eax
     bfd:	cd 40                	int    $0x40
     bff:	c3                   	ret    

00000c00 <setactivefs>:
SYSCALL(setactivefs)
     c00:	b8 24 00 00 00       	mov    $0x24,%eax
     c05:	cd 40                	int    $0x40
     c07:	c3                   	ret    

00000c08 <getactivefs>:
SYSCALL(getactivefs)
     c08:	b8 25 00 00 00       	mov    $0x25,%eax
     c0d:	cd 40                	int    $0x40
     c0f:	c3                   	ret    

00000c10 <getvcfs>:
SYSCALL(getvcfs)
     c10:	b8 23 00 00 00       	mov    $0x23,%eax
     c15:	cd 40                	int    $0x40
     c17:	c3                   	ret    

00000c18 <getcwd>:
SYSCALL(getcwd)
     c18:	b8 26 00 00 00       	mov    $0x26,%eax
     c1d:	cd 40                	int    $0x40
     c1f:	c3                   	ret    

00000c20 <tostring>:
SYSCALL(tostring)
     c20:	b8 27 00 00 00       	mov    $0x27,%eax
     c25:	cd 40                	int    $0x40
     c27:	c3                   	ret    

00000c28 <getactivefsindex>:
SYSCALL(getactivefsindex)
     c28:	b8 28 00 00 00       	mov    $0x28,%eax
     c2d:	cd 40                	int    $0x40
     c2f:	c3                   	ret    

00000c30 <setatroot>:
SYSCALL(setatroot)
     c30:	b8 2a 00 00 00       	mov    $0x2a,%eax
     c35:	cd 40                	int    $0x40
     c37:	c3                   	ret    

00000c38 <getatroot>:
SYSCALL(getatroot)
     c38:	b8 29 00 00 00       	mov    $0x29,%eax
     c3d:	cd 40                	int    $0x40
     c3f:	c3                   	ret    

00000c40 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     c40:	55                   	push   %ebp
     c41:	89 e5                	mov    %esp,%ebp
     c43:	83 ec 18             	sub    $0x18,%esp
     c46:	8b 45 0c             	mov    0xc(%ebp),%eax
     c49:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     c4c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c53:	00 
     c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
     c57:	89 44 24 04          	mov    %eax,0x4(%esp)
     c5b:	8b 45 08             	mov    0x8(%ebp),%eax
     c5e:	89 04 24             	mov    %eax,(%esp)
     c61:	e8 b2 fe ff ff       	call   b18 <write>
}
     c66:	c9                   	leave  
     c67:	c3                   	ret    

00000c68 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c68:	55                   	push   %ebp
     c69:	89 e5                	mov    %esp,%ebp
     c6b:	56                   	push   %esi
     c6c:	53                   	push   %ebx
     c6d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     c70:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     c77:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     c7b:	74 17                	je     c94 <printint+0x2c>
     c7d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     c81:	79 11                	jns    c94 <printint+0x2c>
    neg = 1;
     c83:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c8d:	f7 d8                	neg    %eax
     c8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c92:	eb 06                	jmp    c9a <printint+0x32>
  } else {
    x = xx;
     c94:	8b 45 0c             	mov    0xc(%ebp),%eax
     c97:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     c9a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     ca1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ca4:	8d 41 01             	lea    0x1(%ecx),%eax
     ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     caa:	8b 5d 10             	mov    0x10(%ebp),%ebx
     cad:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cb0:	ba 00 00 00 00       	mov    $0x0,%edx
     cb5:	f7 f3                	div    %ebx
     cb7:	89 d0                	mov    %edx,%eax
     cb9:	8a 80 ac 15 00 00    	mov    0x15ac(%eax),%al
     cbf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     cc3:	8b 75 10             	mov    0x10(%ebp),%esi
     cc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cc9:	ba 00 00 00 00       	mov    $0x0,%edx
     cce:	f7 f6                	div    %esi
     cd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
     cd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     cd7:	75 c8                	jne    ca1 <printint+0x39>
  if(neg)
     cd9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     cdd:	74 10                	je     cef <printint+0x87>
    buf[i++] = '-';
     cdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ce2:	8d 50 01             	lea    0x1(%eax),%edx
     ce5:	89 55 f4             	mov    %edx,-0xc(%ebp)
     ce8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     ced:	eb 1e                	jmp    d0d <printint+0xa5>
     cef:	eb 1c                	jmp    d0d <printint+0xa5>
    putc(fd, buf[i]);
     cf1:	8d 55 dc             	lea    -0x24(%ebp),%edx
     cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cf7:	01 d0                	add    %edx,%eax
     cf9:	8a 00                	mov    (%eax),%al
     cfb:	0f be c0             	movsbl %al,%eax
     cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
     d02:	8b 45 08             	mov    0x8(%ebp),%eax
     d05:	89 04 24             	mov    %eax,(%esp)
     d08:	e8 33 ff ff ff       	call   c40 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     d0d:	ff 4d f4             	decl   -0xc(%ebp)
     d10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d14:	79 db                	jns    cf1 <printint+0x89>
    putc(fd, buf[i]);
}
     d16:	83 c4 30             	add    $0x30,%esp
     d19:	5b                   	pop    %ebx
     d1a:	5e                   	pop    %esi
     d1b:	5d                   	pop    %ebp
     d1c:	c3                   	ret    

00000d1d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     d1d:	55                   	push   %ebp
     d1e:	89 e5                	mov    %esp,%ebp
     d20:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     d23:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     d2a:	8d 45 0c             	lea    0xc(%ebp),%eax
     d2d:	83 c0 04             	add    $0x4,%eax
     d30:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     d33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     d3a:	e9 77 01 00 00       	jmp    eb6 <printf+0x199>
    c = fmt[i] & 0xff;
     d3f:	8b 55 0c             	mov    0xc(%ebp),%edx
     d42:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d45:	01 d0                	add    %edx,%eax
     d47:	8a 00                	mov    (%eax),%al
     d49:	0f be c0             	movsbl %al,%eax
     d4c:	25 ff 00 00 00       	and    $0xff,%eax
     d51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     d54:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d58:	75 2c                	jne    d86 <printf+0x69>
      if(c == '%'){
     d5a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     d5e:	75 0c                	jne    d6c <printf+0x4f>
        state = '%';
     d60:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     d67:	e9 47 01 00 00       	jmp    eb3 <printf+0x196>
      } else {
        putc(fd, c);
     d6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d6f:	0f be c0             	movsbl %al,%eax
     d72:	89 44 24 04          	mov    %eax,0x4(%esp)
     d76:	8b 45 08             	mov    0x8(%ebp),%eax
     d79:	89 04 24             	mov    %eax,(%esp)
     d7c:	e8 bf fe ff ff       	call   c40 <putc>
     d81:	e9 2d 01 00 00       	jmp    eb3 <printf+0x196>
      }
    } else if(state == '%'){
     d86:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     d8a:	0f 85 23 01 00 00    	jne    eb3 <printf+0x196>
      if(c == 'd'){
     d90:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     d94:	75 2d                	jne    dc3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
     d96:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d99:	8b 00                	mov    (%eax),%eax
     d9b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     da2:	00 
     da3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     daa:	00 
     dab:	89 44 24 04          	mov    %eax,0x4(%esp)
     daf:	8b 45 08             	mov    0x8(%ebp),%eax
     db2:	89 04 24             	mov    %eax,(%esp)
     db5:	e8 ae fe ff ff       	call   c68 <printint>
        ap++;
     dba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     dbe:	e9 e9 00 00 00       	jmp    eac <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
     dc3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     dc7:	74 06                	je     dcf <printf+0xb2>
     dc9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     dcd:	75 2d                	jne    dfc <printf+0xdf>
        printint(fd, *ap, 16, 0);
     dcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dd2:	8b 00                	mov    (%eax),%eax
     dd4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ddb:	00 
     ddc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     de3:	00 
     de4:	89 44 24 04          	mov    %eax,0x4(%esp)
     de8:	8b 45 08             	mov    0x8(%ebp),%eax
     deb:	89 04 24             	mov    %eax,(%esp)
     dee:	e8 75 fe ff ff       	call   c68 <printint>
        ap++;
     df3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     df7:	e9 b0 00 00 00       	jmp    eac <printf+0x18f>
      } else if(c == 's'){
     dfc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     e00:	75 42                	jne    e44 <printf+0x127>
        s = (char*)*ap;
     e02:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e05:	8b 00                	mov    (%eax),%eax
     e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     e0a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     e0e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     e12:	75 09                	jne    e1d <printf+0x100>
          s = "(null)";
     e14:	c7 45 f4 51 11 00 00 	movl   $0x1151,-0xc(%ebp)
        while(*s != 0){
     e1b:	eb 1c                	jmp    e39 <printf+0x11c>
     e1d:	eb 1a                	jmp    e39 <printf+0x11c>
          putc(fd, *s);
     e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e22:	8a 00                	mov    (%eax),%al
     e24:	0f be c0             	movsbl %al,%eax
     e27:	89 44 24 04          	mov    %eax,0x4(%esp)
     e2b:	8b 45 08             	mov    0x8(%ebp),%eax
     e2e:	89 04 24             	mov    %eax,(%esp)
     e31:	e8 0a fe ff ff       	call   c40 <putc>
          s++;
     e36:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     e39:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e3c:	8a 00                	mov    (%eax),%al
     e3e:	84 c0                	test   %al,%al
     e40:	75 dd                	jne    e1f <printf+0x102>
     e42:	eb 68                	jmp    eac <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     e44:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     e48:	75 1d                	jne    e67 <printf+0x14a>
        putc(fd, *ap);
     e4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e4d:	8b 00                	mov    (%eax),%eax
     e4f:	0f be c0             	movsbl %al,%eax
     e52:	89 44 24 04          	mov    %eax,0x4(%esp)
     e56:	8b 45 08             	mov    0x8(%ebp),%eax
     e59:	89 04 24             	mov    %eax,(%esp)
     e5c:	e8 df fd ff ff       	call   c40 <putc>
        ap++;
     e61:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     e65:	eb 45                	jmp    eac <printf+0x18f>
      } else if(c == '%'){
     e67:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     e6b:	75 17                	jne    e84 <printf+0x167>
        putc(fd, c);
     e6d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e70:	0f be c0             	movsbl %al,%eax
     e73:	89 44 24 04          	mov    %eax,0x4(%esp)
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
     e7a:	89 04 24             	mov    %eax,(%esp)
     e7d:	e8 be fd ff ff       	call   c40 <putc>
     e82:	eb 28                	jmp    eac <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     e84:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     e8b:	00 
     e8c:	8b 45 08             	mov    0x8(%ebp),%eax
     e8f:	89 04 24             	mov    %eax,(%esp)
     e92:	e8 a9 fd ff ff       	call   c40 <putc>
        putc(fd, c);
     e97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e9a:	0f be c0             	movsbl %al,%eax
     e9d:	89 44 24 04          	mov    %eax,0x4(%esp)
     ea1:	8b 45 08             	mov    0x8(%ebp),%eax
     ea4:	89 04 24             	mov    %eax,(%esp)
     ea7:	e8 94 fd ff ff       	call   c40 <putc>
      }
      state = 0;
     eac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     eb3:	ff 45 f0             	incl   -0x10(%ebp)
     eb6:	8b 55 0c             	mov    0xc(%ebp),%edx
     eb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ebc:	01 d0                	add    %edx,%eax
     ebe:	8a 00                	mov    (%eax),%al
     ec0:	84 c0                	test   %al,%al
     ec2:	0f 85 77 fe ff ff    	jne    d3f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     ec8:	c9                   	leave  
     ec9:	c3                   	ret    
     eca:	90                   	nop
     ecb:	90                   	nop

00000ecc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     ecc:	55                   	push   %ebp
     ecd:	89 e5                	mov    %esp,%ebp
     ecf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     ed2:	8b 45 08             	mov    0x8(%ebp),%eax
     ed5:	83 e8 08             	sub    $0x8,%eax
     ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     edb:	a1 d0 15 00 00       	mov    0x15d0,%eax
     ee0:	89 45 fc             	mov    %eax,-0x4(%ebp)
     ee3:	eb 24                	jmp    f09 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ee5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ee8:	8b 00                	mov    (%eax),%eax
     eea:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     eed:	77 12                	ja     f01 <free+0x35>
     eef:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ef2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     ef5:	77 24                	ja     f1b <free+0x4f>
     ef7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     efa:	8b 00                	mov    (%eax),%eax
     efc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     eff:	77 1a                	ja     f1b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f04:	8b 00                	mov    (%eax),%eax
     f06:	89 45 fc             	mov    %eax,-0x4(%ebp)
     f09:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f0c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     f0f:	76 d4                	jbe    ee5 <free+0x19>
     f11:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f14:	8b 00                	mov    (%eax),%eax
     f16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     f19:	76 ca                	jbe    ee5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     f1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f1e:	8b 40 04             	mov    0x4(%eax),%eax
     f21:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     f28:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f2b:	01 c2                	add    %eax,%edx
     f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f30:	8b 00                	mov    (%eax),%eax
     f32:	39 c2                	cmp    %eax,%edx
     f34:	75 24                	jne    f5a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f39:	8b 50 04             	mov    0x4(%eax),%edx
     f3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f3f:	8b 00                	mov    (%eax),%eax
     f41:	8b 40 04             	mov    0x4(%eax),%eax
     f44:	01 c2                	add    %eax,%edx
     f46:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f49:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     f4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f4f:	8b 00                	mov    (%eax),%eax
     f51:	8b 10                	mov    (%eax),%edx
     f53:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f56:	89 10                	mov    %edx,(%eax)
     f58:	eb 0a                	jmp    f64 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     f5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f5d:	8b 10                	mov    (%eax),%edx
     f5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f62:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     f64:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f67:	8b 40 04             	mov    0x4(%eax),%eax
     f6a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     f71:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f74:	01 d0                	add    %edx,%eax
     f76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     f79:	75 20                	jne    f9b <free+0xcf>
    p->s.size += bp->s.size;
     f7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f7e:	8b 50 04             	mov    0x4(%eax),%edx
     f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f84:	8b 40 04             	mov    0x4(%eax),%eax
     f87:	01 c2                	add    %eax,%edx
     f89:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f8c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f92:	8b 10                	mov    (%eax),%edx
     f94:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f97:	89 10                	mov    %edx,(%eax)
     f99:	eb 08                	jmp    fa3 <free+0xd7>
  } else
    p->s.ptr = bp;
     f9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f9e:	8b 55 f8             	mov    -0x8(%ebp),%edx
     fa1:	89 10                	mov    %edx,(%eax)
  freep = p;
     fa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     fa6:	a3 d0 15 00 00       	mov    %eax,0x15d0
}
     fab:	c9                   	leave  
     fac:	c3                   	ret    

00000fad <morecore>:

static Header*
morecore(uint nu)
{
     fad:	55                   	push   %ebp
     fae:	89 e5                	mov    %esp,%ebp
     fb0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     fb3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     fba:	77 07                	ja     fc3 <morecore+0x16>
    nu = 4096;
     fbc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     fc3:	8b 45 08             	mov    0x8(%ebp),%eax
     fc6:	c1 e0 03             	shl    $0x3,%eax
     fc9:	89 04 24             	mov    %eax,(%esp)
     fcc:	e8 af fb ff ff       	call   b80 <sbrk>
     fd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     fd4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     fd8:	75 07                	jne    fe1 <morecore+0x34>
    return 0;
     fda:	b8 00 00 00 00       	mov    $0x0,%eax
     fdf:	eb 22                	jmp    1003 <morecore+0x56>
  hp = (Header*)p;
     fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     fe7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fea:	8b 55 08             	mov    0x8(%ebp),%edx
     fed:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     ff0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff3:	83 c0 08             	add    $0x8,%eax
     ff6:	89 04 24             	mov    %eax,(%esp)
     ff9:	e8 ce fe ff ff       	call   ecc <free>
  return freep;
     ffe:	a1 d0 15 00 00       	mov    0x15d0,%eax
}
    1003:	c9                   	leave  
    1004:	c3                   	ret    

00001005 <malloc>:

void*
malloc(uint nbytes)
{
    1005:	55                   	push   %ebp
    1006:	89 e5                	mov    %esp,%ebp
    1008:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    100b:	8b 45 08             	mov    0x8(%ebp),%eax
    100e:	83 c0 07             	add    $0x7,%eax
    1011:	c1 e8 03             	shr    $0x3,%eax
    1014:	40                   	inc    %eax
    1015:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1018:	a1 d0 15 00 00       	mov    0x15d0,%eax
    101d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1020:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1024:	75 23                	jne    1049 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1026:	c7 45 f0 c8 15 00 00 	movl   $0x15c8,-0x10(%ebp)
    102d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1030:	a3 d0 15 00 00       	mov    %eax,0x15d0
    1035:	a1 d0 15 00 00       	mov    0x15d0,%eax
    103a:	a3 c8 15 00 00       	mov    %eax,0x15c8
    base.s.size = 0;
    103f:	c7 05 cc 15 00 00 00 	movl   $0x0,0x15cc
    1046:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1049:	8b 45 f0             	mov    -0x10(%ebp),%eax
    104c:	8b 00                	mov    (%eax),%eax
    104e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1051:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1054:	8b 40 04             	mov    0x4(%eax),%eax
    1057:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    105a:	72 4d                	jb     10a9 <malloc+0xa4>
      if(p->s.size == nunits)
    105c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    105f:	8b 40 04             	mov    0x4(%eax),%eax
    1062:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1065:	75 0c                	jne    1073 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1067:	8b 45 f4             	mov    -0xc(%ebp),%eax
    106a:	8b 10                	mov    (%eax),%edx
    106c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    106f:	89 10                	mov    %edx,(%eax)
    1071:	eb 26                	jmp    1099 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1073:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1076:	8b 40 04             	mov    0x4(%eax),%eax
    1079:	2b 45 ec             	sub    -0x14(%ebp),%eax
    107c:	89 c2                	mov    %eax,%edx
    107e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1081:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1084:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1087:	8b 40 04             	mov    0x4(%eax),%eax
    108a:	c1 e0 03             	shl    $0x3,%eax
    108d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1090:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1093:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1096:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1099:	8b 45 f0             	mov    -0x10(%ebp),%eax
    109c:	a3 d0 15 00 00       	mov    %eax,0x15d0
      return (void*)(p + 1);
    10a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10a4:	83 c0 08             	add    $0x8,%eax
    10a7:	eb 38                	jmp    10e1 <malloc+0xdc>
    }
    if(p == freep)
    10a9:	a1 d0 15 00 00       	mov    0x15d0,%eax
    10ae:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    10b1:	75 1b                	jne    10ce <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    10b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    10b6:	89 04 24             	mov    %eax,(%esp)
    10b9:	e8 ef fe ff ff       	call   fad <morecore>
    10be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    10c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    10c5:	75 07                	jne    10ce <malloc+0xc9>
        return 0;
    10c7:	b8 00 00 00 00       	mov    $0x0,%eax
    10cc:	eb 13                	jmp    10e1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    10d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    10d7:	8b 00                	mov    (%eax),%eax
    10d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    10dc:	e9 70 ff ff ff       	jmp    1051 <malloc+0x4c>
}
    10e1:	c9                   	leave  
    10e2:	c3                   	ret    
