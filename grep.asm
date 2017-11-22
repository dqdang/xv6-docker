
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
      1b:	05 60 15 00 00       	add    $0x1560,%eax
      20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
      23:	c7 45 f0 60 15 00 00 	movl   $0x1560,-0x10(%ebp)
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
      6d:	e8 ba 0a 00 00       	call   b2c <write>
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
      87:	e8 f2 04 00 00       	call   57e <strchr>
      8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      93:	75 97                	jne    2c <grep+0x2c>
        *q = '\n';
        write(1, p, q+1 - p);
      }
      p = q+1;
    }
    if(p == buf)
      95:	81 7d f0 60 15 00 00 	cmpl   $0x1560,-0x10(%ebp)
      9c:	75 07                	jne    a5 <grep+0xa5>
      m = 0;
      9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
      a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      a9:	7e 29                	jle    d4 <grep+0xd4>
      m -= p - buf;
      ab:	ba 60 15 00 00       	mov    $0x1560,%edx
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	29 c2                	sub    %eax,%edx
      b5:	89 d0                	mov    %edx,%eax
      b7:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
      ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
      bd:	89 44 24 08          	mov    %eax,0x8(%esp)
      c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
      c4:	89 44 24 04          	mov    %eax,0x4(%esp)
      c8:	c7 04 24 60 15 00 00 	movl   $0x1560,(%esp)
      cf:	e8 f1 09 00 00       	call   ac5 <memmove>
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
      e3:	81 c2 60 15 00 00    	add    $0x1560,%edx
      e9:	89 44 24 08          	mov    %eax,0x8(%esp)
      ed:	89 54 24 04          	mov    %edx,0x4(%esp)
      f1:	8b 45 0c             	mov    0xc(%ebp),%eax
      f4:	89 04 24             	mov    %eax,(%esp)
      f7:	e8 28 0a 00 00       	call   b24 <read>
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
     11a:	c7 44 24 04 50 10 00 	movl   $0x1050,0x4(%esp)
     121:	00 
     122:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     129:	e8 5b 0b 00 00       	call   c89 <printf>
    exit();
     12e:	e8 d9 09 00 00       	call   b0c <exit>
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
     157:	e8 b0 09 00 00       	call   b0c <exit>
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
     186:	e8 c1 09 00 00       	call   b4c <open>
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
     1ac:	c7 44 24 04 70 10 00 	movl   $0x1070,0x4(%esp)
     1b3:	00 
     1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1bb:	e8 c9 0a 00 00       	call   c89 <printf>
      exit();
     1c0:	e8 47 09 00 00       	call   b0c <exit>
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
     1e0:	e8 4f 09 00 00       	call   b34 <close>
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
     1f6:	e8 11 09 00 00       	call   b0c <exit>

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

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
     39b:	55                   	push   %ebp
     39c:	89 e5                	mov    %esp,%ebp
     39e:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
     3a1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3a8:	00 
     3a9:	8b 45 08             	mov    0x8(%ebp),%eax
     3ac:	89 04 24             	mov    %eax,(%esp)
     3af:	e8 98 07 00 00       	call   b4c <open>
     3b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
     3b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3bb:	79 20                	jns    3dd <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
     3bd:	8b 45 08             	mov    0x8(%ebp),%eax
     3c0:	89 44 24 08          	mov    %eax,0x8(%esp)
     3c4:	c7 44 24 04 86 10 00 	movl   $0x1086,0x4(%esp)
     3cb:	00 
     3cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3d3:	e8 b1 08 00 00       	call   c89 <printf>
        exit();
     3d8:	e8 2f 07 00 00       	call   b0c <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
     3dd:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     3e4:	00 
     3e5:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e8:	89 04 24             	mov    %eax,(%esp)
     3eb:	e8 5c 07 00 00       	call   b4c <open>
     3f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
     3f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     3f7:	79 20                	jns    419 <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
     3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     3fc:	89 44 24 08          	mov    %eax,0x8(%esp)
     400:	c7 44 24 04 a1 10 00 	movl   $0x10a1,0x4(%esp)
     407:	00 
     408:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     40f:	e8 75 08 00 00       	call   c89 <printf>
        exit();
     414:	e8 f3 06 00 00       	call   b0c <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
     419:	eb 56                	jmp    471 <copy+0xd6>
        int max = used_disk+=count;
     41b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     41e:	01 45 10             	add    %eax,0x10(%ebp)
     421:	8b 45 10             	mov    0x10(%ebp),%eax
     424:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
     427:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     42a:	89 44 24 08          	mov    %eax,0x8(%esp)
     42e:	c7 44 24 04 bd 10 00 	movl   $0x10bd,0x4(%esp)
     435:	00 
     436:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     43d:	e8 47 08 00 00       	call   c89 <printf>
        if(max > max_disk){
     442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     445:	3b 45 14             	cmp    0x14(%ebp),%eax
     448:	7e 07                	jle    451 <copy+0xb6>
          return -1;
     44a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     44f:	eb 5c                	jmp    4ad <copy+0x112>
        }
        bytes = bytes + count;
     451:	8b 45 e8             	mov    -0x18(%ebp),%eax
     454:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
     457:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     45e:	00 
     45f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     462:	89 44 24 04          	mov    %eax,0x4(%esp)
     466:	8b 45 ec             	mov    -0x14(%ebp),%eax
     469:	89 04 24             	mov    %eax,(%esp)
     46c:	e8 bb 06 00 00       	call   b2c <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
     471:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     478:	00 
     479:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     47c:	89 44 24 04          	mov    %eax,0x4(%esp)
     480:	8b 45 f0             	mov    -0x10(%ebp),%eax
     483:	89 04 24             	mov    %eax,(%esp)
     486:	e8 99 06 00 00       	call   b24 <read>
     48b:	89 45 e8             	mov    %eax,-0x18(%ebp)
     48e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     492:	7f 87                	jg     41b <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
     494:	8b 45 f0             	mov    -0x10(%ebp),%eax
     497:	89 04 24             	mov    %eax,(%esp)
     49a:	e8 95 06 00 00       	call   b34 <close>
    close(fd2);
     49f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4a2:	89 04 24             	mov    %eax,(%esp)
     4a5:	e8 8a 06 00 00       	call   b34 <close>
    return(bytes);
     4aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4ad:	c9                   	leave  
     4ae:	c3                   	ret    

000004af <strcmp>:

int
strcmp(const char *p, const char *q)
{
     4af:	55                   	push   %ebp
     4b0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     4b2:	eb 06                	jmp    4ba <strcmp+0xb>
    p++, q++;
     4b4:	ff 45 08             	incl   0x8(%ebp)
     4b7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     4ba:	8b 45 08             	mov    0x8(%ebp),%eax
     4bd:	8a 00                	mov    (%eax),%al
     4bf:	84 c0                	test   %al,%al
     4c1:	74 0e                	je     4d1 <strcmp+0x22>
     4c3:	8b 45 08             	mov    0x8(%ebp),%eax
     4c6:	8a 10                	mov    (%eax),%dl
     4c8:	8b 45 0c             	mov    0xc(%ebp),%eax
     4cb:	8a 00                	mov    (%eax),%al
     4cd:	38 c2                	cmp    %al,%dl
     4cf:	74 e3                	je     4b4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     4d1:	8b 45 08             	mov    0x8(%ebp),%eax
     4d4:	8a 00                	mov    (%eax),%al
     4d6:	0f b6 d0             	movzbl %al,%edx
     4d9:	8b 45 0c             	mov    0xc(%ebp),%eax
     4dc:	8a 00                	mov    (%eax),%al
     4de:	0f b6 c0             	movzbl %al,%eax
     4e1:	29 c2                	sub    %eax,%edx
     4e3:	89 d0                	mov    %edx,%eax
}
     4e5:	5d                   	pop    %ebp
     4e6:	c3                   	ret    

000004e7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     4e7:	55                   	push   %ebp
     4e8:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     4ea:	eb 09                	jmp    4f5 <strncmp+0xe>
    n--, p++, q++;
     4ec:	ff 4d 10             	decl   0x10(%ebp)
     4ef:	ff 45 08             	incl   0x8(%ebp)
     4f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     4f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     4f9:	74 17                	je     512 <strncmp+0x2b>
     4fb:	8b 45 08             	mov    0x8(%ebp),%eax
     4fe:	8a 00                	mov    (%eax),%al
     500:	84 c0                	test   %al,%al
     502:	74 0e                	je     512 <strncmp+0x2b>
     504:	8b 45 08             	mov    0x8(%ebp),%eax
     507:	8a 10                	mov    (%eax),%dl
     509:	8b 45 0c             	mov    0xc(%ebp),%eax
     50c:	8a 00                	mov    (%eax),%al
     50e:	38 c2                	cmp    %al,%dl
     510:	74 da                	je     4ec <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     512:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     516:	75 07                	jne    51f <strncmp+0x38>
    return 0;
     518:	b8 00 00 00 00       	mov    $0x0,%eax
     51d:	eb 14                	jmp    533 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     51f:	8b 45 08             	mov    0x8(%ebp),%eax
     522:	8a 00                	mov    (%eax),%al
     524:	0f b6 d0             	movzbl %al,%edx
     527:	8b 45 0c             	mov    0xc(%ebp),%eax
     52a:	8a 00                	mov    (%eax),%al
     52c:	0f b6 c0             	movzbl %al,%eax
     52f:	29 c2                	sub    %eax,%edx
     531:	89 d0                	mov    %edx,%eax
}
     533:	5d                   	pop    %ebp
     534:	c3                   	ret    

00000535 <strlen>:

uint
strlen(const char *s)
{
     535:	55                   	push   %ebp
     536:	89 e5                	mov    %esp,%ebp
     538:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     53b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     542:	eb 03                	jmp    547 <strlen+0x12>
     544:	ff 45 fc             	incl   -0x4(%ebp)
     547:	8b 55 fc             	mov    -0x4(%ebp),%edx
     54a:	8b 45 08             	mov    0x8(%ebp),%eax
     54d:	01 d0                	add    %edx,%eax
     54f:	8a 00                	mov    (%eax),%al
     551:	84 c0                	test   %al,%al
     553:	75 ef                	jne    544 <strlen+0xf>
    ;
  return n;
     555:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     558:	c9                   	leave  
     559:	c3                   	ret    

0000055a <memset>:

void*
memset(void *dst, int c, uint n)
{
     55a:	55                   	push   %ebp
     55b:	89 e5                	mov    %esp,%ebp
     55d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     560:	8b 45 10             	mov    0x10(%ebp),%eax
     563:	89 44 24 08          	mov    %eax,0x8(%esp)
     567:	8b 45 0c             	mov    0xc(%ebp),%eax
     56a:	89 44 24 04          	mov    %eax,0x4(%esp)
     56e:	8b 45 08             	mov    0x8(%ebp),%eax
     571:	89 04 24             	mov    %eax,(%esp)
     574:	e8 cf fd ff ff       	call   348 <stosb>
  return dst;
     579:	8b 45 08             	mov    0x8(%ebp),%eax
}
     57c:	c9                   	leave  
     57d:	c3                   	ret    

0000057e <strchr>:

char*
strchr(const char *s, char c)
{
     57e:	55                   	push   %ebp
     57f:	89 e5                	mov    %esp,%ebp
     581:	83 ec 04             	sub    $0x4,%esp
     584:	8b 45 0c             	mov    0xc(%ebp),%eax
     587:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     58a:	eb 12                	jmp    59e <strchr+0x20>
    if(*s == c)
     58c:	8b 45 08             	mov    0x8(%ebp),%eax
     58f:	8a 00                	mov    (%eax),%al
     591:	3a 45 fc             	cmp    -0x4(%ebp),%al
     594:	75 05                	jne    59b <strchr+0x1d>
      return (char*)s;
     596:	8b 45 08             	mov    0x8(%ebp),%eax
     599:	eb 11                	jmp    5ac <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     59b:	ff 45 08             	incl   0x8(%ebp)
     59e:	8b 45 08             	mov    0x8(%ebp),%eax
     5a1:	8a 00                	mov    (%eax),%al
     5a3:	84 c0                	test   %al,%al
     5a5:	75 e5                	jne    58c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     5a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     5ac:	c9                   	leave  
     5ad:	c3                   	ret    

000005ae <strcat>:

char *
strcat(char *dest, const char *src)
{
     5ae:	55                   	push   %ebp
     5af:	89 e5                	mov    %esp,%ebp
     5b1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     5b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     5bb:	eb 03                	jmp    5c0 <strcat+0x12>
     5bd:	ff 45 fc             	incl   -0x4(%ebp)
     5c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5c3:	8b 45 08             	mov    0x8(%ebp),%eax
     5c6:	01 d0                	add    %edx,%eax
     5c8:	8a 00                	mov    (%eax),%al
     5ca:	84 c0                	test   %al,%al
     5cc:	75 ef                	jne    5bd <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     5ce:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     5d5:	eb 1e                	jmp    5f5 <strcat+0x47>
        dest[i+j] = src[j];
     5d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
     5da:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5dd:	01 d0                	add    %edx,%eax
     5df:	89 c2                	mov    %eax,%edx
     5e1:	8b 45 08             	mov    0x8(%ebp),%eax
     5e4:	01 c2                	add    %eax,%edx
     5e6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     5e9:	8b 45 0c             	mov    0xc(%ebp),%eax
     5ec:	01 c8                	add    %ecx,%eax
     5ee:	8a 00                	mov    (%eax),%al
     5f0:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     5f2:	ff 45 f8             	incl   -0x8(%ebp)
     5f5:	8b 55 f8             	mov    -0x8(%ebp),%edx
     5f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     5fb:	01 d0                	add    %edx,%eax
     5fd:	8a 00                	mov    (%eax),%al
     5ff:	84 c0                	test   %al,%al
     601:	75 d4                	jne    5d7 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     603:	8b 45 f8             	mov    -0x8(%ebp),%eax
     606:	8b 55 fc             	mov    -0x4(%ebp),%edx
     609:	01 d0                	add    %edx,%eax
     60b:	89 c2                	mov    %eax,%edx
     60d:	8b 45 08             	mov    0x8(%ebp),%eax
     610:	01 d0                	add    %edx,%eax
     612:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     615:	8b 45 08             	mov    0x8(%ebp),%eax
}
     618:	c9                   	leave  
     619:	c3                   	ret    

0000061a <strstr>:

int 
strstr(char* s, char* sub)
{
     61a:	55                   	push   %ebp
     61b:	89 e5                	mov    %esp,%ebp
     61d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     620:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     627:	eb 7c                	jmp    6a5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     629:	8b 55 fc             	mov    -0x4(%ebp),%edx
     62c:	8b 45 08             	mov    0x8(%ebp),%eax
     62f:	01 d0                	add    %edx,%eax
     631:	8a 10                	mov    (%eax),%dl
     633:	8b 45 0c             	mov    0xc(%ebp),%eax
     636:	8a 00                	mov    (%eax),%al
     638:	38 c2                	cmp    %al,%dl
     63a:	75 66                	jne    6a2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     63c:	8b 45 0c             	mov    0xc(%ebp),%eax
     63f:	89 04 24             	mov    %eax,(%esp)
     642:	e8 ee fe ff ff       	call   535 <strlen>
     647:	83 f8 01             	cmp    $0x1,%eax
     64a:	75 05                	jne    651 <strstr+0x37>
            {  
                return i;
     64c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     64f:	eb 6b                	jmp    6bc <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     651:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     658:	eb 3a                	jmp    694 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     65a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     65d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     660:	01 d0                	add    %edx,%eax
     662:	89 c2                	mov    %eax,%edx
     664:	8b 45 08             	mov    0x8(%ebp),%eax
     667:	01 d0                	add    %edx,%eax
     669:	8a 10                	mov    (%eax),%dl
     66b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     66e:	8b 45 0c             	mov    0xc(%ebp),%eax
     671:	01 c8                	add    %ecx,%eax
     673:	8a 00                	mov    (%eax),%al
     675:	38 c2                	cmp    %al,%dl
     677:	75 16                	jne    68f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     679:	8b 45 f8             	mov    -0x8(%ebp),%eax
     67c:	8d 50 01             	lea    0x1(%eax),%edx
     67f:	8b 45 0c             	mov    0xc(%ebp),%eax
     682:	01 d0                	add    %edx,%eax
     684:	8a 00                	mov    (%eax),%al
     686:	84 c0                	test   %al,%al
     688:	75 07                	jne    691 <strstr+0x77>
                    {
                        return i;
     68a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     68d:	eb 2d                	jmp    6bc <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     68f:	eb 11                	jmp    6a2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     691:	ff 45 f8             	incl   -0x8(%ebp)
     694:	8b 55 f8             	mov    -0x8(%ebp),%edx
     697:	8b 45 0c             	mov    0xc(%ebp),%eax
     69a:	01 d0                	add    %edx,%eax
     69c:	8a 00                	mov    (%eax),%al
     69e:	84 c0                	test   %al,%al
     6a0:	75 b8                	jne    65a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     6a2:	ff 45 fc             	incl   -0x4(%ebp)
     6a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
     6a8:	8b 45 08             	mov    0x8(%ebp),%eax
     6ab:	01 d0                	add    %edx,%eax
     6ad:	8a 00                	mov    (%eax),%al
     6af:	84 c0                	test   %al,%al
     6b1:	0f 85 72 ff ff ff    	jne    629 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     6b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     6bc:	c9                   	leave  
     6bd:	c3                   	ret    

000006be <strtok>:

char *
strtok(char *s, const char *delim)
{
     6be:	55                   	push   %ebp
     6bf:	89 e5                	mov    %esp,%ebp
     6c1:	53                   	push   %ebx
     6c2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     6c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     6c9:	75 08                	jne    6d3 <strtok+0x15>
  s = lasts;
     6cb:	a1 44 15 00 00       	mov    0x1544,%eax
     6d0:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     6d3:	8b 45 08             	mov    0x8(%ebp),%eax
     6d6:	8d 50 01             	lea    0x1(%eax),%edx
     6d9:	89 55 08             	mov    %edx,0x8(%ebp)
     6dc:	8a 00                	mov    (%eax),%al
     6de:	0f be d8             	movsbl %al,%ebx
     6e1:	85 db                	test   %ebx,%ebx
     6e3:	75 07                	jne    6ec <strtok+0x2e>
      return 0;
     6e5:	b8 00 00 00 00       	mov    $0x0,%eax
     6ea:	eb 58                	jmp    744 <strtok+0x86>
    } while (strchr(delim, ch));
     6ec:	88 d8                	mov    %bl,%al
     6ee:	0f be c0             	movsbl %al,%eax
     6f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     6f8:	89 04 24             	mov    %eax,(%esp)
     6fb:	e8 7e fe ff ff       	call   57e <strchr>
     700:	85 c0                	test   %eax,%eax
     702:	75 cf                	jne    6d3 <strtok+0x15>
    --s;
     704:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     707:	8b 45 0c             	mov    0xc(%ebp),%eax
     70a:	89 44 24 04          	mov    %eax,0x4(%esp)
     70e:	8b 45 08             	mov    0x8(%ebp),%eax
     711:	89 04 24             	mov    %eax,(%esp)
     714:	e8 31 00 00 00       	call   74a <strcspn>
     719:	89 c2                	mov    %eax,%edx
     71b:	8b 45 08             	mov    0x8(%ebp),%eax
     71e:	01 d0                	add    %edx,%eax
     720:	a3 44 15 00 00       	mov    %eax,0x1544
    if (*lasts != 0)
     725:	a1 44 15 00 00       	mov    0x1544,%eax
     72a:	8a 00                	mov    (%eax),%al
     72c:	84 c0                	test   %al,%al
     72e:	74 11                	je     741 <strtok+0x83>
  *lasts++ = 0;
     730:	a1 44 15 00 00       	mov    0x1544,%eax
     735:	8d 50 01             	lea    0x1(%eax),%edx
     738:	89 15 44 15 00 00    	mov    %edx,0x1544
     73e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     741:	8b 45 08             	mov    0x8(%ebp),%eax
}
     744:	83 c4 14             	add    $0x14,%esp
     747:	5b                   	pop    %ebx
     748:	5d                   	pop    %ebp
     749:	c3                   	ret    

0000074a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     74a:	55                   	push   %ebp
     74b:	89 e5                	mov    %esp,%ebp
     74d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     750:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     757:	eb 26                	jmp    77f <strcspn+0x35>
        if(strchr(s2,*s1))
     759:	8b 45 08             	mov    0x8(%ebp),%eax
     75c:	8a 00                	mov    (%eax),%al
     75e:	0f be c0             	movsbl %al,%eax
     761:	89 44 24 04          	mov    %eax,0x4(%esp)
     765:	8b 45 0c             	mov    0xc(%ebp),%eax
     768:	89 04 24             	mov    %eax,(%esp)
     76b:	e8 0e fe ff ff       	call   57e <strchr>
     770:	85 c0                	test   %eax,%eax
     772:	74 05                	je     779 <strcspn+0x2f>
            return ret;
     774:	8b 45 fc             	mov    -0x4(%ebp),%eax
     777:	eb 12                	jmp    78b <strcspn+0x41>
        else
            s1++,ret++;
     779:	ff 45 08             	incl   0x8(%ebp)
     77c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     77f:	8b 45 08             	mov    0x8(%ebp),%eax
     782:	8a 00                	mov    (%eax),%al
     784:	84 c0                	test   %al,%al
     786:	75 d1                	jne    759 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     788:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     78b:	c9                   	leave  
     78c:	c3                   	ret    

0000078d <isspace>:

int
isspace(unsigned char c)
{
     78d:	55                   	push   %ebp
     78e:	89 e5                	mov    %esp,%ebp
     790:	83 ec 04             	sub    $0x4,%esp
     793:	8b 45 08             	mov    0x8(%ebp),%eax
     796:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     799:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     79d:	74 1e                	je     7bd <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     79f:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     7a3:	74 18                	je     7bd <isspace+0x30>
     7a5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     7a9:	74 12                	je     7bd <isspace+0x30>
     7ab:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     7af:	74 0c                	je     7bd <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     7b1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     7b5:	74 06                	je     7bd <isspace+0x30>
     7b7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     7bb:	75 07                	jne    7c4 <isspace+0x37>
     7bd:	b8 01 00 00 00       	mov    $0x1,%eax
     7c2:	eb 05                	jmp    7c9 <isspace+0x3c>
     7c4:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7c9:	c9                   	leave  
     7ca:	c3                   	ret    

000007cb <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     7cb:	55                   	push   %ebp
     7cc:	89 e5                	mov    %esp,%ebp
     7ce:	57                   	push   %edi
     7cf:	56                   	push   %esi
     7d0:	53                   	push   %ebx
     7d1:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     7d4:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     7d9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     7e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     7e3:	eb 01                	jmp    7e6 <strtoul+0x1b>
  p += 1;
     7e5:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     7e6:	8a 03                	mov    (%ebx),%al
     7e8:	0f b6 c0             	movzbl %al,%eax
     7eb:	89 04 24             	mov    %eax,(%esp)
     7ee:	e8 9a ff ff ff       	call   78d <isspace>
     7f3:	85 c0                	test   %eax,%eax
     7f5:	75 ee                	jne    7e5 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     7f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     7fb:	75 30                	jne    82d <strtoul+0x62>
    {
  if (*p == '0') {
     7fd:	8a 03                	mov    (%ebx),%al
     7ff:	3c 30                	cmp    $0x30,%al
     801:	75 21                	jne    824 <strtoul+0x59>
      p += 1;
     803:	43                   	inc    %ebx
      if (*p == 'x') {
     804:	8a 03                	mov    (%ebx),%al
     806:	3c 78                	cmp    $0x78,%al
     808:	75 0a                	jne    814 <strtoul+0x49>
    p += 1;
     80a:	43                   	inc    %ebx
    base = 16;
     80b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     812:	eb 31                	jmp    845 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     814:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     81b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     822:	eb 21                	jmp    845 <strtoul+0x7a>
      }
  }
  else base = 10;
     824:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     82b:	eb 18                	jmp    845 <strtoul+0x7a>
    } else if (base == 16) {
     82d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     831:	75 12                	jne    845 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     833:	8a 03                	mov    (%ebx),%al
     835:	3c 30                	cmp    $0x30,%al
     837:	75 0c                	jne    845 <strtoul+0x7a>
     839:	8d 43 01             	lea    0x1(%ebx),%eax
     83c:	8a 00                	mov    (%eax),%al
     83e:	3c 78                	cmp    $0x78,%al
     840:	75 03                	jne    845 <strtoul+0x7a>
      p += 2;
     842:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     845:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     849:	75 29                	jne    874 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     84b:	8a 03                	mov    (%ebx),%al
     84d:	0f be c0             	movsbl %al,%eax
     850:	83 e8 30             	sub    $0x30,%eax
     853:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     855:	83 fe 07             	cmp    $0x7,%esi
     858:	76 06                	jbe    860 <strtoul+0x95>
    break;
     85a:	90                   	nop
     85b:	e9 b6 00 00 00       	jmp    916 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     860:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     867:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     86a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     871:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     872:	eb d7                	jmp    84b <strtoul+0x80>
    } else if (base == 10) {
     874:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     878:	75 2b                	jne    8a5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     87a:	8a 03                	mov    (%ebx),%al
     87c:	0f be c0             	movsbl %al,%eax
     87f:	83 e8 30             	sub    $0x30,%eax
     882:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     884:	83 fe 09             	cmp    $0x9,%esi
     887:	76 06                	jbe    88f <strtoul+0xc4>
    break;
     889:	90                   	nop
     88a:	e9 87 00 00 00       	jmp    916 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     88f:	89 f8                	mov    %edi,%eax
     891:	c1 e0 02             	shl    $0x2,%eax
     894:	01 f8                	add    %edi,%eax
     896:	01 c0                	add    %eax,%eax
     898:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     89b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     8a2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     8a3:	eb d5                	jmp    87a <strtoul+0xaf>
    } else if (base == 16) {
     8a5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     8a9:	75 35                	jne    8e0 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     8ab:	8a 03                	mov    (%ebx),%al
     8ad:	0f be c0             	movsbl %al,%eax
     8b0:	83 e8 30             	sub    $0x30,%eax
     8b3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8b5:	83 fe 4a             	cmp    $0x4a,%esi
     8b8:	76 02                	jbe    8bc <strtoul+0xf1>
    break;
     8ba:	eb 22                	jmp    8de <strtoul+0x113>
      }
      digit = cvtIn[digit];
     8bc:	8a 86 e0 14 00 00    	mov    0x14e0(%esi),%al
     8c2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     8c5:	83 fe 0f             	cmp    $0xf,%esi
     8c8:	76 02                	jbe    8cc <strtoul+0x101>
    break;
     8ca:	eb 12                	jmp    8de <strtoul+0x113>
      }
      result = (result << 4) + digit;
     8cc:	89 f8                	mov    %edi,%eax
     8ce:	c1 e0 04             	shl    $0x4,%eax
     8d1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     8d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     8db:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     8dc:	eb cd                	jmp    8ab <strtoul+0xe0>
     8de:	eb 36                	jmp    916 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     8e0:	8a 03                	mov    (%ebx),%al
     8e2:	0f be c0             	movsbl %al,%eax
     8e5:	83 e8 30             	sub    $0x30,%eax
     8e8:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8ea:	83 fe 4a             	cmp    $0x4a,%esi
     8ed:	76 02                	jbe    8f1 <strtoul+0x126>
    break;
     8ef:	eb 25                	jmp    916 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     8f1:	8a 86 e0 14 00 00    	mov    0x14e0(%esi),%al
     8f7:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     8fa:	8b 45 10             	mov    0x10(%ebp),%eax
     8fd:	39 f0                	cmp    %esi,%eax
     8ff:	77 02                	ja     903 <strtoul+0x138>
    break;
     901:	eb 13                	jmp    916 <strtoul+0x14b>
      }
      result = result*base + digit;
     903:	8b 45 10             	mov    0x10(%ebp),%eax
     906:	0f af c7             	imul   %edi,%eax
     909:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     90c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     913:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     914:	eb ca                	jmp    8e0 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     916:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     91a:	75 03                	jne    91f <strtoul+0x154>
  p = string;
     91c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     91f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     923:	74 05                	je     92a <strtoul+0x15f>
  *endPtr = p;
     925:	8b 45 0c             	mov    0xc(%ebp),%eax
     928:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     92a:	89 f8                	mov    %edi,%eax
}
     92c:	83 c4 14             	add    $0x14,%esp
     92f:	5b                   	pop    %ebx
     930:	5e                   	pop    %esi
     931:	5f                   	pop    %edi
     932:	5d                   	pop    %ebp
     933:	c3                   	ret    

00000934 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     934:	55                   	push   %ebp
     935:	89 e5                	mov    %esp,%ebp
     937:	53                   	push   %ebx
     938:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     93b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     93e:	eb 01                	jmp    941 <strtol+0xd>
      p += 1;
     940:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     941:	8a 03                	mov    (%ebx),%al
     943:	0f b6 c0             	movzbl %al,%eax
     946:	89 04 24             	mov    %eax,(%esp)
     949:	e8 3f fe ff ff       	call   78d <isspace>
     94e:	85 c0                	test   %eax,%eax
     950:	75 ee                	jne    940 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     952:	8a 03                	mov    (%ebx),%al
     954:	3c 2d                	cmp    $0x2d,%al
     956:	75 1e                	jne    976 <strtol+0x42>
  p += 1;
     958:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     959:	8b 45 10             	mov    0x10(%ebp),%eax
     95c:	89 44 24 08          	mov    %eax,0x8(%esp)
     960:	8b 45 0c             	mov    0xc(%ebp),%eax
     963:	89 44 24 04          	mov    %eax,0x4(%esp)
     967:	89 1c 24             	mov    %ebx,(%esp)
     96a:	e8 5c fe ff ff       	call   7cb <strtoul>
     96f:	f7 d8                	neg    %eax
     971:	89 45 f8             	mov    %eax,-0x8(%ebp)
     974:	eb 20                	jmp    996 <strtol+0x62>
    } else {
  if (*p == '+') {
     976:	8a 03                	mov    (%ebx),%al
     978:	3c 2b                	cmp    $0x2b,%al
     97a:	75 01                	jne    97d <strtol+0x49>
      p += 1;
     97c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     97d:	8b 45 10             	mov    0x10(%ebp),%eax
     980:	89 44 24 08          	mov    %eax,0x8(%esp)
     984:	8b 45 0c             	mov    0xc(%ebp),%eax
     987:	89 44 24 04          	mov    %eax,0x4(%esp)
     98b:	89 1c 24             	mov    %ebx,(%esp)
     98e:	e8 38 fe ff ff       	call   7cb <strtoul>
     993:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     996:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     99a:	75 17                	jne    9b3 <strtol+0x7f>
     99c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     9a0:	74 11                	je     9b3 <strtol+0x7f>
     9a2:	8b 45 0c             	mov    0xc(%ebp),%eax
     9a5:	8b 00                	mov    (%eax),%eax
     9a7:	39 d8                	cmp    %ebx,%eax
     9a9:	75 08                	jne    9b3 <strtol+0x7f>
  *endPtr = string;
     9ab:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ae:	8b 55 08             	mov    0x8(%ebp),%edx
     9b1:	89 10                	mov    %edx,(%eax)
    }
    return result;
     9b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     9b6:	83 c4 1c             	add    $0x1c,%esp
     9b9:	5b                   	pop    %ebx
     9ba:	5d                   	pop    %ebp
     9bb:	c3                   	ret    

000009bc <gets>:

char*
gets(char *buf, int max)
{
     9bc:	55                   	push   %ebp
     9bd:	89 e5                	mov    %esp,%ebp
     9bf:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9c9:	eb 49                	jmp    a14 <gets+0x58>
    cc = read(0, &c, 1);
     9cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     9d2:	00 
     9d3:	8d 45 ef             	lea    -0x11(%ebp),%eax
     9d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     9da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9e1:	e8 3e 01 00 00       	call   b24 <read>
     9e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     9e9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9ed:	7f 02                	jg     9f1 <gets+0x35>
      break;
     9ef:	eb 2c                	jmp    a1d <gets+0x61>
    buf[i++] = c;
     9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9f4:	8d 50 01             	lea    0x1(%eax),%edx
     9f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9fa:	89 c2                	mov    %eax,%edx
     9fc:	8b 45 08             	mov    0x8(%ebp),%eax
     9ff:	01 c2                	add    %eax,%edx
     a01:	8a 45 ef             	mov    -0x11(%ebp),%al
     a04:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     a06:	8a 45 ef             	mov    -0x11(%ebp),%al
     a09:	3c 0a                	cmp    $0xa,%al
     a0b:	74 10                	je     a1d <gets+0x61>
     a0d:	8a 45 ef             	mov    -0x11(%ebp),%al
     a10:	3c 0d                	cmp    $0xd,%al
     a12:	74 09                	je     a1d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a17:	40                   	inc    %eax
     a18:	3b 45 0c             	cmp    0xc(%ebp),%eax
     a1b:	7c ae                	jl     9cb <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a20:	8b 45 08             	mov    0x8(%ebp),%eax
     a23:	01 d0                	add    %edx,%eax
     a25:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     a28:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a2b:	c9                   	leave  
     a2c:	c3                   	ret    

00000a2d <stat>:

int
stat(char *n, struct stat *st)
{
     a2d:	55                   	push   %ebp
     a2e:	89 e5                	mov    %esp,%ebp
     a30:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     a3a:	00 
     a3b:	8b 45 08             	mov    0x8(%ebp),%eax
     a3e:	89 04 24             	mov    %eax,(%esp)
     a41:	e8 06 01 00 00       	call   b4c <open>
     a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     a49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     a4d:	79 07                	jns    a56 <stat+0x29>
    return -1;
     a4f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a54:	eb 23                	jmp    a79 <stat+0x4c>
  r = fstat(fd, st);
     a56:	8b 45 0c             	mov    0xc(%ebp),%eax
     a59:	89 44 24 04          	mov    %eax,0x4(%esp)
     a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a60:	89 04 24             	mov    %eax,(%esp)
     a63:	e8 fc 00 00 00       	call   b64 <fstat>
     a68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a6e:	89 04 24             	mov    %eax,(%esp)
     a71:	e8 be 00 00 00       	call   b34 <close>
  return r;
     a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a79:	c9                   	leave  
     a7a:	c3                   	ret    

00000a7b <atoi>:

int
atoi(const char *s)
{
     a7b:	55                   	push   %ebp
     a7c:	89 e5                	mov    %esp,%ebp
     a7e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     a81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     a88:	eb 24                	jmp    aae <atoi+0x33>
    n = n*10 + *s++ - '0';
     a8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a8d:	89 d0                	mov    %edx,%eax
     a8f:	c1 e0 02             	shl    $0x2,%eax
     a92:	01 d0                	add    %edx,%eax
     a94:	01 c0                	add    %eax,%eax
     a96:	89 c1                	mov    %eax,%ecx
     a98:	8b 45 08             	mov    0x8(%ebp),%eax
     a9b:	8d 50 01             	lea    0x1(%eax),%edx
     a9e:	89 55 08             	mov    %edx,0x8(%ebp)
     aa1:	8a 00                	mov    (%eax),%al
     aa3:	0f be c0             	movsbl %al,%eax
     aa6:	01 c8                	add    %ecx,%eax
     aa8:	83 e8 30             	sub    $0x30,%eax
     aab:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aae:	8b 45 08             	mov    0x8(%ebp),%eax
     ab1:	8a 00                	mov    (%eax),%al
     ab3:	3c 2f                	cmp    $0x2f,%al
     ab5:	7e 09                	jle    ac0 <atoi+0x45>
     ab7:	8b 45 08             	mov    0x8(%ebp),%eax
     aba:	8a 00                	mov    (%eax),%al
     abc:	3c 39                	cmp    $0x39,%al
     abe:	7e ca                	jle    a8a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     ac0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ac3:	c9                   	leave  
     ac4:	c3                   	ret    

00000ac5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     ac5:	55                   	push   %ebp
     ac6:	89 e5                	mov    %esp,%ebp
     ac8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     acb:	8b 45 08             	mov    0x8(%ebp),%eax
     ace:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     ad1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ad4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     ad7:	eb 16                	jmp    aef <memmove+0x2a>
    *dst++ = *src++;
     ad9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     adc:	8d 50 01             	lea    0x1(%eax),%edx
     adf:	89 55 fc             	mov    %edx,-0x4(%ebp)
     ae2:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ae5:	8d 4a 01             	lea    0x1(%edx),%ecx
     ae8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     aeb:	8a 12                	mov    (%edx),%dl
     aed:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     aef:	8b 45 10             	mov    0x10(%ebp),%eax
     af2:	8d 50 ff             	lea    -0x1(%eax),%edx
     af5:	89 55 10             	mov    %edx,0x10(%ebp)
     af8:	85 c0                	test   %eax,%eax
     afa:	7f dd                	jg     ad9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     afc:	8b 45 08             	mov    0x8(%ebp),%eax
}
     aff:	c9                   	leave  
     b00:	c3                   	ret    
     b01:	90                   	nop
     b02:	90                   	nop
     b03:	90                   	nop

00000b04 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     b04:	b8 01 00 00 00       	mov    $0x1,%eax
     b09:	cd 40                	int    $0x40
     b0b:	c3                   	ret    

00000b0c <exit>:
SYSCALL(exit)
     b0c:	b8 02 00 00 00       	mov    $0x2,%eax
     b11:	cd 40                	int    $0x40
     b13:	c3                   	ret    

00000b14 <wait>:
SYSCALL(wait)
     b14:	b8 03 00 00 00       	mov    $0x3,%eax
     b19:	cd 40                	int    $0x40
     b1b:	c3                   	ret    

00000b1c <pipe>:
SYSCALL(pipe)
     b1c:	b8 04 00 00 00       	mov    $0x4,%eax
     b21:	cd 40                	int    $0x40
     b23:	c3                   	ret    

00000b24 <read>:
SYSCALL(read)
     b24:	b8 05 00 00 00       	mov    $0x5,%eax
     b29:	cd 40                	int    $0x40
     b2b:	c3                   	ret    

00000b2c <write>:
SYSCALL(write)
     b2c:	b8 10 00 00 00       	mov    $0x10,%eax
     b31:	cd 40                	int    $0x40
     b33:	c3                   	ret    

00000b34 <close>:
SYSCALL(close)
     b34:	b8 15 00 00 00       	mov    $0x15,%eax
     b39:	cd 40                	int    $0x40
     b3b:	c3                   	ret    

00000b3c <kill>:
SYSCALL(kill)
     b3c:	b8 06 00 00 00       	mov    $0x6,%eax
     b41:	cd 40                	int    $0x40
     b43:	c3                   	ret    

00000b44 <exec>:
SYSCALL(exec)
     b44:	b8 07 00 00 00       	mov    $0x7,%eax
     b49:	cd 40                	int    $0x40
     b4b:	c3                   	ret    

00000b4c <open>:
SYSCALL(open)
     b4c:	b8 0f 00 00 00       	mov    $0xf,%eax
     b51:	cd 40                	int    $0x40
     b53:	c3                   	ret    

00000b54 <mknod>:
SYSCALL(mknod)
     b54:	b8 11 00 00 00       	mov    $0x11,%eax
     b59:	cd 40                	int    $0x40
     b5b:	c3                   	ret    

00000b5c <unlink>:
SYSCALL(unlink)
     b5c:	b8 12 00 00 00       	mov    $0x12,%eax
     b61:	cd 40                	int    $0x40
     b63:	c3                   	ret    

00000b64 <fstat>:
SYSCALL(fstat)
     b64:	b8 08 00 00 00       	mov    $0x8,%eax
     b69:	cd 40                	int    $0x40
     b6b:	c3                   	ret    

00000b6c <link>:
SYSCALL(link)
     b6c:	b8 13 00 00 00       	mov    $0x13,%eax
     b71:	cd 40                	int    $0x40
     b73:	c3                   	ret    

00000b74 <mkdir>:
SYSCALL(mkdir)
     b74:	b8 14 00 00 00       	mov    $0x14,%eax
     b79:	cd 40                	int    $0x40
     b7b:	c3                   	ret    

00000b7c <chdir>:
SYSCALL(chdir)
     b7c:	b8 09 00 00 00       	mov    $0x9,%eax
     b81:	cd 40                	int    $0x40
     b83:	c3                   	ret    

00000b84 <dup>:
SYSCALL(dup)
     b84:	b8 0a 00 00 00       	mov    $0xa,%eax
     b89:	cd 40                	int    $0x40
     b8b:	c3                   	ret    

00000b8c <getpid>:
SYSCALL(getpid)
     b8c:	b8 0b 00 00 00       	mov    $0xb,%eax
     b91:	cd 40                	int    $0x40
     b93:	c3                   	ret    

00000b94 <sbrk>:
SYSCALL(sbrk)
     b94:	b8 0c 00 00 00       	mov    $0xc,%eax
     b99:	cd 40                	int    $0x40
     b9b:	c3                   	ret    

00000b9c <sleep>:
SYSCALL(sleep)
     b9c:	b8 0d 00 00 00       	mov    $0xd,%eax
     ba1:	cd 40                	int    $0x40
     ba3:	c3                   	ret    

00000ba4 <uptime>:
SYSCALL(uptime)
     ba4:	b8 0e 00 00 00       	mov    $0xe,%eax
     ba9:	cd 40                	int    $0x40
     bab:	c3                   	ret    

00000bac <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     bac:	55                   	push   %ebp
     bad:	89 e5                	mov    %esp,%ebp
     baf:	83 ec 18             	sub    $0x18,%esp
     bb2:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     bb8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bbf:	00 
     bc0:	8d 45 f4             	lea    -0xc(%ebp),%eax
     bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc7:	8b 45 08             	mov    0x8(%ebp),%eax
     bca:	89 04 24             	mov    %eax,(%esp)
     bcd:	e8 5a ff ff ff       	call   b2c <write>
}
     bd2:	c9                   	leave  
     bd3:	c3                   	ret    

00000bd4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bd4:	55                   	push   %ebp
     bd5:	89 e5                	mov    %esp,%ebp
     bd7:	56                   	push   %esi
     bd8:	53                   	push   %ebx
     bd9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     bdc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     be3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     be7:	74 17                	je     c00 <printint+0x2c>
     be9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bed:	79 11                	jns    c00 <printint+0x2c>
    neg = 1;
     bef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf9:	f7 d8                	neg    %eax
     bfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
     bfe:	eb 06                	jmp    c06 <printint+0x32>
  } else {
    x = xx;
     c00:	8b 45 0c             	mov    0xc(%ebp),%eax
     c03:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     c0d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     c10:	8d 41 01             	lea    0x1(%ecx),%eax
     c13:	89 45 f4             	mov    %eax,-0xc(%ebp)
     c16:	8b 5d 10             	mov    0x10(%ebp),%ebx
     c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c1c:	ba 00 00 00 00       	mov    $0x0,%edx
     c21:	f7 f3                	div    %ebx
     c23:	89 d0                	mov    %edx,%eax
     c25:	8a 80 2c 15 00 00    	mov    0x152c(%eax),%al
     c2b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     c2f:	8b 75 10             	mov    0x10(%ebp),%esi
     c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c35:	ba 00 00 00 00       	mov    $0x0,%edx
     c3a:	f7 f6                	div    %esi
     c3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c3f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c43:	75 c8                	jne    c0d <printint+0x39>
  if(neg)
     c45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c49:	74 10                	je     c5b <printint+0x87>
    buf[i++] = '-';
     c4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c4e:	8d 50 01             	lea    0x1(%eax),%edx
     c51:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c54:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     c59:	eb 1e                	jmp    c79 <printint+0xa5>
     c5b:	eb 1c                	jmp    c79 <printint+0xa5>
    putc(fd, buf[i]);
     c5d:	8d 55 dc             	lea    -0x24(%ebp),%edx
     c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c63:	01 d0                	add    %edx,%eax
     c65:	8a 00                	mov    (%eax),%al
     c67:	0f be c0             	movsbl %al,%eax
     c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
     c6e:	8b 45 08             	mov    0x8(%ebp),%eax
     c71:	89 04 24             	mov    %eax,(%esp)
     c74:	e8 33 ff ff ff       	call   bac <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     c79:	ff 4d f4             	decl   -0xc(%ebp)
     c7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c80:	79 db                	jns    c5d <printint+0x89>
    putc(fd, buf[i]);
}
     c82:	83 c4 30             	add    $0x30,%esp
     c85:	5b                   	pop    %ebx
     c86:	5e                   	pop    %esi
     c87:	5d                   	pop    %ebp
     c88:	c3                   	ret    

00000c89 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     c89:	55                   	push   %ebp
     c8a:	89 e5                	mov    %esp,%ebp
     c8c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     c8f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     c96:	8d 45 0c             	lea    0xc(%ebp),%eax
     c99:	83 c0 04             	add    $0x4,%eax
     c9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     c9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     ca6:	e9 77 01 00 00       	jmp    e22 <printf+0x199>
    c = fmt[i] & 0xff;
     cab:	8b 55 0c             	mov    0xc(%ebp),%edx
     cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cb1:	01 d0                	add    %edx,%eax
     cb3:	8a 00                	mov    (%eax),%al
     cb5:	0f be c0             	movsbl %al,%eax
     cb8:	25 ff 00 00 00       	and    $0xff,%eax
     cbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     cc0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     cc4:	75 2c                	jne    cf2 <printf+0x69>
      if(c == '%'){
     cc6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     cca:	75 0c                	jne    cd8 <printf+0x4f>
        state = '%';
     ccc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     cd3:	e9 47 01 00 00       	jmp    e1f <printf+0x196>
      } else {
        putc(fd, c);
     cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cdb:	0f be c0             	movsbl %al,%eax
     cde:	89 44 24 04          	mov    %eax,0x4(%esp)
     ce2:	8b 45 08             	mov    0x8(%ebp),%eax
     ce5:	89 04 24             	mov    %eax,(%esp)
     ce8:	e8 bf fe ff ff       	call   bac <putc>
     ced:	e9 2d 01 00 00       	jmp    e1f <printf+0x196>
      }
    } else if(state == '%'){
     cf2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     cf6:	0f 85 23 01 00 00    	jne    e1f <printf+0x196>
      if(c == 'd'){
     cfc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     d00:	75 2d                	jne    d2f <printf+0xa6>
        printint(fd, *ap, 10, 1);
     d02:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d05:	8b 00                	mov    (%eax),%eax
     d07:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     d0e:	00 
     d0f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     d16:	00 
     d17:	89 44 24 04          	mov    %eax,0x4(%esp)
     d1b:	8b 45 08             	mov    0x8(%ebp),%eax
     d1e:	89 04 24             	mov    %eax,(%esp)
     d21:	e8 ae fe ff ff       	call   bd4 <printint>
        ap++;
     d26:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d2a:	e9 e9 00 00 00       	jmp    e18 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
     d2f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     d33:	74 06                	je     d3b <printf+0xb2>
     d35:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     d39:	75 2d                	jne    d68 <printf+0xdf>
        printint(fd, *ap, 16, 0);
     d3b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d3e:	8b 00                	mov    (%eax),%eax
     d40:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d47:	00 
     d48:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     d4f:	00 
     d50:	89 44 24 04          	mov    %eax,0x4(%esp)
     d54:	8b 45 08             	mov    0x8(%ebp),%eax
     d57:	89 04 24             	mov    %eax,(%esp)
     d5a:	e8 75 fe ff ff       	call   bd4 <printint>
        ap++;
     d5f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d63:	e9 b0 00 00 00       	jmp    e18 <printf+0x18f>
      } else if(c == 's'){
     d68:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     d6c:	75 42                	jne    db0 <printf+0x127>
        s = (char*)*ap;
     d6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d71:	8b 00                	mov    (%eax),%eax
     d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     d76:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     d7a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d7e:	75 09                	jne    d89 <printf+0x100>
          s = "(null)";
     d80:	c7 45 f4 ce 10 00 00 	movl   $0x10ce,-0xc(%ebp)
        while(*s != 0){
     d87:	eb 1c                	jmp    da5 <printf+0x11c>
     d89:	eb 1a                	jmp    da5 <printf+0x11c>
          putc(fd, *s);
     d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d8e:	8a 00                	mov    (%eax),%al
     d90:	0f be c0             	movsbl %al,%eax
     d93:	89 44 24 04          	mov    %eax,0x4(%esp)
     d97:	8b 45 08             	mov    0x8(%ebp),%eax
     d9a:	89 04 24             	mov    %eax,(%esp)
     d9d:	e8 0a fe ff ff       	call   bac <putc>
          s++;
     da2:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     da8:	8a 00                	mov    (%eax),%al
     daa:	84 c0                	test   %al,%al
     dac:	75 dd                	jne    d8b <printf+0x102>
     dae:	eb 68                	jmp    e18 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     db0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     db4:	75 1d                	jne    dd3 <printf+0x14a>
        putc(fd, *ap);
     db6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     db9:	8b 00                	mov    (%eax),%eax
     dbb:	0f be c0             	movsbl %al,%eax
     dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
     dc2:	8b 45 08             	mov    0x8(%ebp),%eax
     dc5:	89 04 24             	mov    %eax,(%esp)
     dc8:	e8 df fd ff ff       	call   bac <putc>
        ap++;
     dcd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     dd1:	eb 45                	jmp    e18 <printf+0x18f>
      } else if(c == '%'){
     dd3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     dd7:	75 17                	jne    df0 <printf+0x167>
        putc(fd, c);
     dd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ddc:	0f be c0             	movsbl %al,%eax
     ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
     de3:	8b 45 08             	mov    0x8(%ebp),%eax
     de6:	89 04 24             	mov    %eax,(%esp)
     de9:	e8 be fd ff ff       	call   bac <putc>
     dee:	eb 28                	jmp    e18 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     df0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     df7:	00 
     df8:	8b 45 08             	mov    0x8(%ebp),%eax
     dfb:	89 04 24             	mov    %eax,(%esp)
     dfe:	e8 a9 fd ff ff       	call   bac <putc>
        putc(fd, c);
     e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e06:	0f be c0             	movsbl %al,%eax
     e09:	89 44 24 04          	mov    %eax,0x4(%esp)
     e0d:	8b 45 08             	mov    0x8(%ebp),%eax
     e10:	89 04 24             	mov    %eax,(%esp)
     e13:	e8 94 fd ff ff       	call   bac <putc>
      }
      state = 0;
     e18:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     e1f:	ff 45 f0             	incl   -0x10(%ebp)
     e22:	8b 55 0c             	mov    0xc(%ebp),%edx
     e25:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e28:	01 d0                	add    %edx,%eax
     e2a:	8a 00                	mov    (%eax),%al
     e2c:	84 c0                	test   %al,%al
     e2e:	0f 85 77 fe ff ff    	jne    cab <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     e34:	c9                   	leave  
     e35:	c3                   	ret    
     e36:	90                   	nop
     e37:	90                   	nop

00000e38 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e38:	55                   	push   %ebp
     e39:	89 e5                	mov    %esp,%ebp
     e3b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e3e:	8b 45 08             	mov    0x8(%ebp),%eax
     e41:	83 e8 08             	sub    $0x8,%eax
     e44:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e47:	a1 50 15 00 00       	mov    0x1550,%eax
     e4c:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e4f:	eb 24                	jmp    e75 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e51:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e54:	8b 00                	mov    (%eax),%eax
     e56:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e59:	77 12                	ja     e6d <free+0x35>
     e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e5e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e61:	77 24                	ja     e87 <free+0x4f>
     e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e66:	8b 00                	mov    (%eax),%eax
     e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e6b:	77 1a                	ja     e87 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e70:	8b 00                	mov    (%eax),%eax
     e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e75:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e78:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e7b:	76 d4                	jbe    e51 <free+0x19>
     e7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e80:	8b 00                	mov    (%eax),%eax
     e82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e85:	76 ca                	jbe    e51 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e8a:	8b 40 04             	mov    0x4(%eax),%eax
     e8d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     e94:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e97:	01 c2                	add    %eax,%edx
     e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e9c:	8b 00                	mov    (%eax),%eax
     e9e:	39 c2                	cmp    %eax,%edx
     ea0:	75 24                	jne    ec6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ea5:	8b 50 04             	mov    0x4(%eax),%edx
     ea8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eab:	8b 00                	mov    (%eax),%eax
     ead:	8b 40 04             	mov    0x4(%eax),%eax
     eb0:	01 c2                	add    %eax,%edx
     eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eb5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     eb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ebb:	8b 00                	mov    (%eax),%eax
     ebd:	8b 10                	mov    (%eax),%edx
     ebf:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ec2:	89 10                	mov    %edx,(%eax)
     ec4:	eb 0a                	jmp    ed0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     ec6:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ec9:	8b 10                	mov    (%eax),%edx
     ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ece:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ed3:	8b 40 04             	mov    0x4(%eax),%eax
     ed6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ee0:	01 d0                	add    %edx,%eax
     ee2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     ee5:	75 20                	jne    f07 <free+0xcf>
    p->s.size += bp->s.size;
     ee7:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eea:	8b 50 04             	mov    0x4(%eax),%edx
     eed:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ef0:	8b 40 04             	mov    0x4(%eax),%eax
     ef3:	01 c2                	add    %eax,%edx
     ef5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ef8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     efb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     efe:	8b 10                	mov    (%eax),%edx
     f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f03:	89 10                	mov    %edx,(%eax)
     f05:	eb 08                	jmp    f0f <free+0xd7>
  } else
    p->s.ptr = bp;
     f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f0a:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f0d:	89 10                	mov    %edx,(%eax)
  freep = p;
     f0f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f12:	a3 50 15 00 00       	mov    %eax,0x1550
}
     f17:	c9                   	leave  
     f18:	c3                   	ret    

00000f19 <morecore>:

static Header*
morecore(uint nu)
{
     f19:	55                   	push   %ebp
     f1a:	89 e5                	mov    %esp,%ebp
     f1c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     f1f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     f26:	77 07                	ja     f2f <morecore+0x16>
    nu = 4096;
     f28:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     f2f:	8b 45 08             	mov    0x8(%ebp),%eax
     f32:	c1 e0 03             	shl    $0x3,%eax
     f35:	89 04 24             	mov    %eax,(%esp)
     f38:	e8 57 fc ff ff       	call   b94 <sbrk>
     f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     f40:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     f44:	75 07                	jne    f4d <morecore+0x34>
    return 0;
     f46:	b8 00 00 00 00       	mov    $0x0,%eax
     f4b:	eb 22                	jmp    f6f <morecore+0x56>
  hp = (Header*)p;
     f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f50:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f56:	8b 55 08             	mov    0x8(%ebp),%edx
     f59:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f5f:	83 c0 08             	add    $0x8,%eax
     f62:	89 04 24             	mov    %eax,(%esp)
     f65:	e8 ce fe ff ff       	call   e38 <free>
  return freep;
     f6a:	a1 50 15 00 00       	mov    0x1550,%eax
}
     f6f:	c9                   	leave  
     f70:	c3                   	ret    

00000f71 <malloc>:

void*
malloc(uint nbytes)
{
     f71:	55                   	push   %ebp
     f72:	89 e5                	mov    %esp,%ebp
     f74:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f77:	8b 45 08             	mov    0x8(%ebp),%eax
     f7a:	83 c0 07             	add    $0x7,%eax
     f7d:	c1 e8 03             	shr    $0x3,%eax
     f80:	40                   	inc    %eax
     f81:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     f84:	a1 50 15 00 00       	mov    0x1550,%eax
     f89:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f8c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f90:	75 23                	jne    fb5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
     f92:	c7 45 f0 48 15 00 00 	movl   $0x1548,-0x10(%ebp)
     f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f9c:	a3 50 15 00 00       	mov    %eax,0x1550
     fa1:	a1 50 15 00 00       	mov    0x1550,%eax
     fa6:	a3 48 15 00 00       	mov    %eax,0x1548
    base.s.size = 0;
     fab:	c7 05 4c 15 00 00 00 	movl   $0x0,0x154c
     fb2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fb8:	8b 00                	mov    (%eax),%eax
     fba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     fbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc0:	8b 40 04             	mov    0x4(%eax),%eax
     fc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fc6:	72 4d                	jb     1015 <malloc+0xa4>
      if(p->s.size == nunits)
     fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fcb:	8b 40 04             	mov    0x4(%eax),%eax
     fce:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fd1:	75 0c                	jne    fdf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
     fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fd6:	8b 10                	mov    (%eax),%edx
     fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fdb:	89 10                	mov    %edx,(%eax)
     fdd:	eb 26                	jmp    1005 <malloc+0x94>
      else {
        p->s.size -= nunits;
     fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe2:	8b 40 04             	mov    0x4(%eax),%eax
     fe5:	2b 45 ec             	sub    -0x14(%ebp),%eax
     fe8:	89 c2                	mov    %eax,%edx
     fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fed:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ff3:	8b 40 04             	mov    0x4(%eax),%eax
     ff6:	c1 e0 03             	shl    $0x3,%eax
     ff9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
     ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fff:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1002:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1005:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1008:	a3 50 15 00 00       	mov    %eax,0x1550
      return (void*)(p + 1);
    100d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1010:	83 c0 08             	add    $0x8,%eax
    1013:	eb 38                	jmp    104d <malloc+0xdc>
    }
    if(p == freep)
    1015:	a1 50 15 00 00       	mov    0x1550,%eax
    101a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    101d:	75 1b                	jne    103a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    101f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1022:	89 04 24             	mov    %eax,(%esp)
    1025:	e8 ef fe ff ff       	call   f19 <morecore>
    102a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    102d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1031:	75 07                	jne    103a <malloc+0xc9>
        return 0;
    1033:	b8 00 00 00 00       	mov    $0x0,%eax
    1038:	eb 13                	jmp    104d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    103a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1040:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1043:	8b 00                	mov    (%eax),%eax
    1045:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1048:	e9 70 ff ff ff       	jmp    fbd <malloc+0x4c>
}
    104d:	c9                   	leave  
    104e:	c3                   	ret    
