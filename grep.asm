
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 28             	sub    $0x28,%esp
       6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
       d:	e9 c2 00 00 00       	jmp    d4 <grep+0xd4>
      12:	8b 45 ec             	mov    -0x14(%ebp),%eax
      15:	01 45 f4             	add    %eax,-0xc(%ebp)
      18:	8b 45 f4             	mov    -0xc(%ebp),%eax
      1b:	05 40 15 00 00       	add    $0x1540,%eax
      20:	c6 00 00             	movb   $0x0,(%eax)
      23:	c7 45 f0 40 15 00 00 	movl   $0x1540,-0x10(%ebp)
      2a:	eb 4d                	jmp    79 <grep+0x79>
      2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
      2f:	c6 00 00             	movb   $0x0,(%eax)
      32:	8b 45 f0             	mov    -0x10(%ebp),%eax
      35:	89 44 24 04          	mov    %eax,0x4(%esp)
      39:	8b 45 08             	mov    0x8(%ebp),%eax
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 b7 01 00 00       	call   1fb <match>
      44:	85 c0                	test   %eax,%eax
      46:	74 2a                	je     72 <grep+0x72>
      48:	8b 45 e8             	mov    -0x18(%ebp),%eax
      4b:	c6 00 0a             	movb   $0xa,(%eax)
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
      72:	8b 45 e8             	mov    -0x18(%ebp),%eax
      75:	40                   	inc    %eax
      76:	89 45 f0             	mov    %eax,-0x10(%ebp)
      79:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
      80:	00 
      81:	8b 45 f0             	mov    -0x10(%ebp),%eax
      84:	89 04 24             	mov    %eax,(%esp)
      87:	e8 de 04 00 00       	call   56a <strchr>
      8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
      8f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      93:	75 97                	jne    2c <grep+0x2c>
      95:	81 7d f0 40 15 00 00 	cmpl   $0x1540,-0x10(%ebp)
      9c:	75 07                	jne    a5 <grep+0xa5>
      9e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
      a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
      a9:	7e 29                	jle    d4 <grep+0xd4>
      ab:	ba 40 15 00 00       	mov    $0x1540,%edx
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	29 c2                	sub    %eax,%edx
      b5:	89 d0                	mov    %edx,%eax
      b7:	01 45 f4             	add    %eax,-0xc(%ebp)
      ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
      bd:	89 44 24 08          	mov    %eax,0x8(%esp)
      c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
      c4:	89 44 24 04          	mov    %eax,0x4(%esp)
      c8:	c7 04 24 40 15 00 00 	movl   $0x1540,(%esp)
      cf:	e8 dd 09 00 00       	call   ab1 <memmove>
      d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d7:	ba ff 03 00 00       	mov    $0x3ff,%edx
      dc:	29 c2                	sub    %eax,%edx
      de:	89 d0                	mov    %edx,%eax
      e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
      e3:	81 c2 40 15 00 00    	add    $0x1540,%edx
      e9:	89 44 24 08          	mov    %eax,0x8(%esp)
      ed:	89 54 24 04          	mov    %edx,0x4(%esp)
      f1:	8b 45 0c             	mov    0xc(%ebp),%eax
      f4:	89 04 24             	mov    %eax,(%esp)
      f7:	e8 14 0a 00 00       	call   b10 <read>
      fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
      ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     103:	0f 8f 09 ff ff ff    	jg     12 <grep+0x12>
     109:	c9                   	leave  
     10a:	c3                   	ret    

0000010b <main>:
     10b:	55                   	push   %ebp
     10c:	89 e5                	mov    %esp,%ebp
     10e:	83 e4 f0             	and    $0xfffffff0,%esp
     111:	83 ec 20             	sub    $0x20,%esp
     114:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     118:	7f 19                	jg     133 <main+0x28>
     11a:	c7 44 24 04 3c 10 00 	movl   $0x103c,0x4(%esp)
     121:	00 
     122:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     129:	e8 47 0b 00 00       	call   c75 <printf>
     12e:	e8 c5 09 00 00       	call   af8 <exit>
     133:	8b 45 0c             	mov    0xc(%ebp),%eax
     136:	8b 40 04             	mov    0x4(%eax),%eax
     139:	89 44 24 18          	mov    %eax,0x18(%esp)
     13d:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
     141:	7f 19                	jg     15c <main+0x51>
     143:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     14a:	00 
     14b:	8b 44 24 18          	mov    0x18(%esp),%eax
     14f:	89 04 24             	mov    %eax,(%esp)
     152:	e8 a9 fe ff ff       	call   0 <grep>
     157:	e8 9c 09 00 00       	call   af8 <exit>
     15c:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
     163:	00 
     164:	e9 80 00 00 00       	jmp    1e9 <main+0xde>
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
     196:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     19a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     1a1:	8b 45 0c             	mov    0xc(%ebp),%eax
     1a4:	01 d0                	add    %edx,%eax
     1a6:	8b 00                	mov    (%eax),%eax
     1a8:	89 44 24 08          	mov    %eax,0x8(%esp)
     1ac:	c7 44 24 04 5c 10 00 	movl   $0x105c,0x4(%esp)
     1b3:	00 
     1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1bb:	e8 b5 0a 00 00       	call   c75 <printf>
     1c0:	e8 33 09 00 00       	call   af8 <exit>
     1c5:	8b 44 24 14          	mov    0x14(%esp),%eax
     1c9:	89 44 24 04          	mov    %eax,0x4(%esp)
     1cd:	8b 44 24 18          	mov    0x18(%esp),%eax
     1d1:	89 04 24             	mov    %eax,(%esp)
     1d4:	e8 27 fe ff ff       	call   0 <grep>
     1d9:	8b 44 24 14          	mov    0x14(%esp),%eax
     1dd:	89 04 24             	mov    %eax,(%esp)
     1e0:	e8 3b 09 00 00       	call   b20 <close>
     1e5:	ff 44 24 1c          	incl   0x1c(%esp)
     1e9:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     1ed:	3b 45 08             	cmp    0x8(%ebp),%eax
     1f0:	0f 8c 73 ff ff ff    	jl     169 <main+0x5e>
     1f6:	e8 fd 08 00 00       	call   af8 <exit>

000001fb <match>:
     1fb:	55                   	push   %ebp
     1fc:	89 e5                	mov    %esp,%ebp
     1fe:	83 ec 18             	sub    $0x18,%esp
     201:	8b 45 08             	mov    0x8(%ebp),%eax
     204:	8a 00                	mov    (%eax),%al
     206:	3c 5e                	cmp    $0x5e,%al
     208:	75 17                	jne    221 <match+0x26>
     20a:	8b 45 08             	mov    0x8(%ebp),%eax
     20d:	8d 50 01             	lea    0x1(%eax),%edx
     210:	8b 45 0c             	mov    0xc(%ebp),%eax
     213:	89 44 24 04          	mov    %eax,0x4(%esp)
     217:	89 14 24             	mov    %edx,(%esp)
     21a:	e8 35 00 00 00       	call   254 <matchhere>
     21f:	eb 31                	jmp    252 <match+0x57>
     221:	8b 45 0c             	mov    0xc(%ebp),%eax
     224:	89 44 24 04          	mov    %eax,0x4(%esp)
     228:	8b 45 08             	mov    0x8(%ebp),%eax
     22b:	89 04 24             	mov    %eax,(%esp)
     22e:	e8 21 00 00 00       	call   254 <matchhere>
     233:	85 c0                	test   %eax,%eax
     235:	74 07                	je     23e <match+0x43>
     237:	b8 01 00 00 00       	mov    $0x1,%eax
     23c:	eb 14                	jmp    252 <match+0x57>
     23e:	8b 45 0c             	mov    0xc(%ebp),%eax
     241:	8d 50 01             	lea    0x1(%eax),%edx
     244:	89 55 0c             	mov    %edx,0xc(%ebp)
     247:	8a 00                	mov    (%eax),%al
     249:	84 c0                	test   %al,%al
     24b:	75 d4                	jne    221 <match+0x26>
     24d:	b8 00 00 00 00       	mov    $0x0,%eax
     252:	c9                   	leave  
     253:	c3                   	ret    

00000254 <matchhere>:
     254:	55                   	push   %ebp
     255:	89 e5                	mov    %esp,%ebp
     257:	83 ec 18             	sub    $0x18,%esp
     25a:	8b 45 08             	mov    0x8(%ebp),%eax
     25d:	8a 00                	mov    (%eax),%al
     25f:	84 c0                	test   %al,%al
     261:	75 0a                	jne    26d <matchhere+0x19>
     263:	b8 01 00 00 00       	mov    $0x1,%eax
     268:	e9 8c 00 00 00       	jmp    2f9 <matchhere+0xa5>
     26d:	8b 45 08             	mov    0x8(%ebp),%eax
     270:	40                   	inc    %eax
     271:	8a 00                	mov    (%eax),%al
     273:	3c 2a                	cmp    $0x2a,%al
     275:	75 23                	jne    29a <matchhere+0x46>
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
     29a:	8b 45 08             	mov    0x8(%ebp),%eax
     29d:	8a 00                	mov    (%eax),%al
     29f:	3c 24                	cmp    $0x24,%al
     2a1:	75 19                	jne    2bc <matchhere+0x68>
     2a3:	8b 45 08             	mov    0x8(%ebp),%eax
     2a6:	40                   	inc    %eax
     2a7:	8a 00                	mov    (%eax),%al
     2a9:	84 c0                	test   %al,%al
     2ab:	75 0f                	jne    2bc <matchhere+0x68>
     2ad:	8b 45 0c             	mov    0xc(%ebp),%eax
     2b0:	8a 00                	mov    (%eax),%al
     2b2:	84 c0                	test   %al,%al
     2b4:	0f 94 c0             	sete   %al
     2b7:	0f b6 c0             	movzbl %al,%eax
     2ba:	eb 3d                	jmp    2f9 <matchhere+0xa5>
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
     2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
     2df:	8d 50 01             	lea    0x1(%eax),%edx
     2e2:	8b 45 08             	mov    0x8(%ebp),%eax
     2e5:	40                   	inc    %eax
     2e6:	89 54 24 04          	mov    %edx,0x4(%esp)
     2ea:	89 04 24             	mov    %eax,(%esp)
     2ed:	e8 62 ff ff ff       	call   254 <matchhere>
     2f2:	eb 05                	jmp    2f9 <matchhere+0xa5>
     2f4:	b8 00 00 00 00       	mov    $0x0,%eax
     2f9:	c9                   	leave  
     2fa:	c3                   	ret    

000002fb <matchstar>:
     2fb:	55                   	push   %ebp
     2fc:	89 e5                	mov    %esp,%ebp
     2fe:	83 ec 18             	sub    $0x18,%esp
     301:	8b 45 10             	mov    0x10(%ebp),%eax
     304:	89 44 24 04          	mov    %eax,0x4(%esp)
     308:	8b 45 0c             	mov    0xc(%ebp),%eax
     30b:	89 04 24             	mov    %eax,(%esp)
     30e:	e8 41 ff ff ff       	call   254 <matchhere>
     313:	85 c0                	test   %eax,%eax
     315:	74 07                	je     31e <matchstar+0x23>
     317:	b8 01 00 00 00       	mov    $0x1,%eax
     31c:	eb 27                	jmp    345 <matchstar+0x4a>
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
     340:	b8 00 00 00 00       	mov    $0x0,%eax
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
     3cb:	c7 44 24 04 72 10 00 	movl   $0x1072,0x4(%esp)
     3d2:	00 
     3d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3da:	e8 96 08 00 00       	call   c75 <printf>
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
     407:	c7 44 24 04 8d 10 00 	movl   $0x108d,0x4(%esp)
     40e:	00 
     40f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     416:	e8 5a 08 00 00       	call   c75 <printf>
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
     6b7:	a1 24 15 00 00       	mov    0x1524,%eax
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
     70c:	a3 24 15 00 00       	mov    %eax,0x1524
    if (*lasts != 0)
     711:	a1 24 15 00 00       	mov    0x1524,%eax
     716:	8a 00                	mov    (%eax),%al
     718:	84 c0                	test   %al,%al
     71a:	74 11                	je     72d <strtok+0x83>
  *lasts++ = 0;
     71c:	a1 24 15 00 00       	mov    0x1524,%eax
     721:	8d 50 01             	lea    0x1(%eax),%edx
     724:	89 15 24 15 00 00    	mov    %edx,0x1524
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
     8a8:	8a 86 c0 14 00 00    	mov    0x14c0(%esi),%al
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
     8dd:	8a 86 c0 14 00 00    	mov    0x14c0(%esi),%al
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
     af0:	b8 01 00 00 00       	mov    $0x1,%eax
     af5:	cd 40                	int    $0x40
     af7:	c3                   	ret    

00000af8 <exit>:
     af8:	b8 02 00 00 00       	mov    $0x2,%eax
     afd:	cd 40                	int    $0x40
     aff:	c3                   	ret    

00000b00 <wait>:
     b00:	b8 03 00 00 00       	mov    $0x3,%eax
     b05:	cd 40                	int    $0x40
     b07:	c3                   	ret    

00000b08 <pipe>:
     b08:	b8 04 00 00 00       	mov    $0x4,%eax
     b0d:	cd 40                	int    $0x40
     b0f:	c3                   	ret    

00000b10 <read>:
     b10:	b8 05 00 00 00       	mov    $0x5,%eax
     b15:	cd 40                	int    $0x40
     b17:	c3                   	ret    

00000b18 <write>:
     b18:	b8 10 00 00 00       	mov    $0x10,%eax
     b1d:	cd 40                	int    $0x40
     b1f:	c3                   	ret    

00000b20 <close>:
     b20:	b8 15 00 00 00       	mov    $0x15,%eax
     b25:	cd 40                	int    $0x40
     b27:	c3                   	ret    

00000b28 <kill>:
     b28:	b8 06 00 00 00       	mov    $0x6,%eax
     b2d:	cd 40                	int    $0x40
     b2f:	c3                   	ret    

00000b30 <exec>:
     b30:	b8 07 00 00 00       	mov    $0x7,%eax
     b35:	cd 40                	int    $0x40
     b37:	c3                   	ret    

00000b38 <open>:
     b38:	b8 0f 00 00 00       	mov    $0xf,%eax
     b3d:	cd 40                	int    $0x40
     b3f:	c3                   	ret    

00000b40 <mknod>:
     b40:	b8 11 00 00 00       	mov    $0x11,%eax
     b45:	cd 40                	int    $0x40
     b47:	c3                   	ret    

00000b48 <unlink>:
     b48:	b8 12 00 00 00       	mov    $0x12,%eax
     b4d:	cd 40                	int    $0x40
     b4f:	c3                   	ret    

00000b50 <fstat>:
     b50:	b8 08 00 00 00       	mov    $0x8,%eax
     b55:	cd 40                	int    $0x40
     b57:	c3                   	ret    

00000b58 <link>:
     b58:	b8 13 00 00 00       	mov    $0x13,%eax
     b5d:	cd 40                	int    $0x40
     b5f:	c3                   	ret    

00000b60 <mkdir>:
     b60:	b8 14 00 00 00       	mov    $0x14,%eax
     b65:	cd 40                	int    $0x40
     b67:	c3                   	ret    

00000b68 <chdir>:
     b68:	b8 09 00 00 00       	mov    $0x9,%eax
     b6d:	cd 40                	int    $0x40
     b6f:	c3                   	ret    

00000b70 <dup>:
     b70:	b8 0a 00 00 00       	mov    $0xa,%eax
     b75:	cd 40                	int    $0x40
     b77:	c3                   	ret    

00000b78 <getpid>:
     b78:	b8 0b 00 00 00       	mov    $0xb,%eax
     b7d:	cd 40                	int    $0x40
     b7f:	c3                   	ret    

00000b80 <sbrk>:
     b80:	b8 0c 00 00 00       	mov    $0xc,%eax
     b85:	cd 40                	int    $0x40
     b87:	c3                   	ret    

00000b88 <sleep>:
     b88:	b8 0d 00 00 00       	mov    $0xd,%eax
     b8d:	cd 40                	int    $0x40
     b8f:	c3                   	ret    

00000b90 <uptime>:
     b90:	b8 0e 00 00 00       	mov    $0xe,%eax
     b95:	cd 40                	int    $0x40
     b97:	c3                   	ret    

00000b98 <putc>:
     b98:	55                   	push   %ebp
     b99:	89 e5                	mov    %esp,%ebp
     b9b:	83 ec 18             	sub    $0x18,%esp
     b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
     ba1:	88 45 f4             	mov    %al,-0xc(%ebp)
     ba4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bab:	00 
     bac:	8d 45 f4             	lea    -0xc(%ebp),%eax
     baf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb3:	8b 45 08             	mov    0x8(%ebp),%eax
     bb6:	89 04 24             	mov    %eax,(%esp)
     bb9:	e8 5a ff ff ff       	call   b18 <write>
     bbe:	c9                   	leave  
     bbf:	c3                   	ret    

00000bc0 <printint>:
     bc0:	55                   	push   %ebp
     bc1:	89 e5                	mov    %esp,%ebp
     bc3:	56                   	push   %esi
     bc4:	53                   	push   %ebx
     bc5:	83 ec 30             	sub    $0x30,%esp
     bc8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     bcf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     bd3:	74 17                	je     bec <printint+0x2c>
     bd5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bd9:	79 11                	jns    bec <printint+0x2c>
     bdb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     be2:	8b 45 0c             	mov    0xc(%ebp),%eax
     be5:	f7 d8                	neg    %eax
     be7:	89 45 ec             	mov    %eax,-0x14(%ebp)
     bea:	eb 06                	jmp    bf2 <printint+0x32>
     bec:	8b 45 0c             	mov    0xc(%ebp),%eax
     bef:	89 45 ec             	mov    %eax,-0x14(%ebp)
     bf2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bf9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     bfc:	8d 41 01             	lea    0x1(%ecx),%eax
     bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
     c02:	8b 5d 10             	mov    0x10(%ebp),%ebx
     c05:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c08:	ba 00 00 00 00       	mov    $0x0,%edx
     c0d:	f7 f3                	div    %ebx
     c0f:	89 d0                	mov    %edx,%eax
     c11:	8a 80 0c 15 00 00    	mov    0x150c(%eax),%al
     c17:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
     c1b:	8b 75 10             	mov    0x10(%ebp),%esi
     c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c21:	ba 00 00 00 00       	mov    $0x0,%edx
     c26:	f7 f6                	div    %esi
     c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c2f:	75 c8                	jne    bf9 <printint+0x39>
     c31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c35:	74 10                	je     c47 <printint+0x87>
     c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c3a:	8d 50 01             	lea    0x1(%eax),%edx
     c3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c40:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
     c45:	eb 1e                	jmp    c65 <printint+0xa5>
     c47:	eb 1c                	jmp    c65 <printint+0xa5>
     c49:	8d 55 dc             	lea    -0x24(%ebp),%edx
     c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c4f:	01 d0                	add    %edx,%eax
     c51:	8a 00                	mov    (%eax),%al
     c53:	0f be c0             	movsbl %al,%eax
     c56:	89 44 24 04          	mov    %eax,0x4(%esp)
     c5a:	8b 45 08             	mov    0x8(%ebp),%eax
     c5d:	89 04 24             	mov    %eax,(%esp)
     c60:	e8 33 ff ff ff       	call   b98 <putc>
     c65:	ff 4d f4             	decl   -0xc(%ebp)
     c68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c6c:	79 db                	jns    c49 <printint+0x89>
     c6e:	83 c4 30             	add    $0x30,%esp
     c71:	5b                   	pop    %ebx
     c72:	5e                   	pop    %esi
     c73:	5d                   	pop    %ebp
     c74:	c3                   	ret    

00000c75 <printf>:
     c75:	55                   	push   %ebp
     c76:	89 e5                	mov    %esp,%ebp
     c78:	83 ec 38             	sub    $0x38,%esp
     c7b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     c82:	8d 45 0c             	lea    0xc(%ebp),%eax
     c85:	83 c0 04             	add    $0x4,%eax
     c88:	89 45 e8             	mov    %eax,-0x18(%ebp)
     c8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     c92:	e9 77 01 00 00       	jmp    e0e <printf+0x199>
     c97:	8b 55 0c             	mov    0xc(%ebp),%edx
     c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c9d:	01 d0                	add    %edx,%eax
     c9f:	8a 00                	mov    (%eax),%al
     ca1:	0f be c0             	movsbl %al,%eax
     ca4:	25 ff 00 00 00       	and    $0xff,%eax
     ca9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     cac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     cb0:	75 2c                	jne    cde <printf+0x69>
     cb2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     cb6:	75 0c                	jne    cc4 <printf+0x4f>
     cb8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     cbf:	e9 47 01 00 00       	jmp    e0b <printf+0x196>
     cc4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cc7:	0f be c0             	movsbl %al,%eax
     cca:	89 44 24 04          	mov    %eax,0x4(%esp)
     cce:	8b 45 08             	mov    0x8(%ebp),%eax
     cd1:	89 04 24             	mov    %eax,(%esp)
     cd4:	e8 bf fe ff ff       	call   b98 <putc>
     cd9:	e9 2d 01 00 00       	jmp    e0b <printf+0x196>
     cde:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     ce2:	0f 85 23 01 00 00    	jne    e0b <printf+0x196>
     ce8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     cec:	75 2d                	jne    d1b <printf+0xa6>
     cee:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cf1:	8b 00                	mov    (%eax),%eax
     cf3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     cfa:	00 
     cfb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     d02:	00 
     d03:	89 44 24 04          	mov    %eax,0x4(%esp)
     d07:	8b 45 08             	mov    0x8(%ebp),%eax
     d0a:	89 04 24             	mov    %eax,(%esp)
     d0d:	e8 ae fe ff ff       	call   bc0 <printint>
     d12:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d16:	e9 e9 00 00 00       	jmp    e04 <printf+0x18f>
     d1b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     d1f:	74 06                	je     d27 <printf+0xb2>
     d21:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     d25:	75 2d                	jne    d54 <printf+0xdf>
     d27:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d2a:	8b 00                	mov    (%eax),%eax
     d2c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d33:	00 
     d34:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     d3b:	00 
     d3c:	89 44 24 04          	mov    %eax,0x4(%esp)
     d40:	8b 45 08             	mov    0x8(%ebp),%eax
     d43:	89 04 24             	mov    %eax,(%esp)
     d46:	e8 75 fe ff ff       	call   bc0 <printint>
     d4b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d4f:	e9 b0 00 00 00       	jmp    e04 <printf+0x18f>
     d54:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     d58:	75 42                	jne    d9c <printf+0x127>
     d5a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d5d:	8b 00                	mov    (%eax),%eax
     d5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     d62:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d6a:	75 09                	jne    d75 <printf+0x100>
     d6c:	c7 45 f4 a9 10 00 00 	movl   $0x10a9,-0xc(%ebp)
     d73:	eb 1c                	jmp    d91 <printf+0x11c>
     d75:	eb 1a                	jmp    d91 <printf+0x11c>
     d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d7a:	8a 00                	mov    (%eax),%al
     d7c:	0f be c0             	movsbl %al,%eax
     d7f:	89 44 24 04          	mov    %eax,0x4(%esp)
     d83:	8b 45 08             	mov    0x8(%ebp),%eax
     d86:	89 04 24             	mov    %eax,(%esp)
     d89:	e8 0a fe ff ff       	call   b98 <putc>
     d8e:	ff 45 f4             	incl   -0xc(%ebp)
     d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d94:	8a 00                	mov    (%eax),%al
     d96:	84 c0                	test   %al,%al
     d98:	75 dd                	jne    d77 <printf+0x102>
     d9a:	eb 68                	jmp    e04 <printf+0x18f>
     d9c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     da0:	75 1d                	jne    dbf <printf+0x14a>
     da2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     da5:	8b 00                	mov    (%eax),%eax
     da7:	0f be c0             	movsbl %al,%eax
     daa:	89 44 24 04          	mov    %eax,0x4(%esp)
     dae:	8b 45 08             	mov    0x8(%ebp),%eax
     db1:	89 04 24             	mov    %eax,(%esp)
     db4:	e8 df fd ff ff       	call   b98 <putc>
     db9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     dbd:	eb 45                	jmp    e04 <printf+0x18f>
     dbf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     dc3:	75 17                	jne    ddc <printf+0x167>
     dc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dc8:	0f be c0             	movsbl %al,%eax
     dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
     dcf:	8b 45 08             	mov    0x8(%ebp),%eax
     dd2:	89 04 24             	mov    %eax,(%esp)
     dd5:	e8 be fd ff ff       	call   b98 <putc>
     dda:	eb 28                	jmp    e04 <printf+0x18f>
     ddc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     de3:	00 
     de4:	8b 45 08             	mov    0x8(%ebp),%eax
     de7:	89 04 24             	mov    %eax,(%esp)
     dea:	e8 a9 fd ff ff       	call   b98 <putc>
     def:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     df2:	0f be c0             	movsbl %al,%eax
     df5:	89 44 24 04          	mov    %eax,0x4(%esp)
     df9:	8b 45 08             	mov    0x8(%ebp),%eax
     dfc:	89 04 24             	mov    %eax,(%esp)
     dff:	e8 94 fd ff ff       	call   b98 <putc>
     e04:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     e0b:	ff 45 f0             	incl   -0x10(%ebp)
     e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
     e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e14:	01 d0                	add    %edx,%eax
     e16:	8a 00                	mov    (%eax),%al
     e18:	84 c0                	test   %al,%al
     e1a:	0f 85 77 fe ff ff    	jne    c97 <printf+0x22>
     e20:	c9                   	leave  
     e21:	c3                   	ret    
     e22:	90                   	nop
     e23:	90                   	nop

00000e24 <free>:
     e24:	55                   	push   %ebp
     e25:	89 e5                	mov    %esp,%ebp
     e27:	83 ec 10             	sub    $0x10,%esp
     e2a:	8b 45 08             	mov    0x8(%ebp),%eax
     e2d:	83 e8 08             	sub    $0x8,%eax
     e30:	89 45 f8             	mov    %eax,-0x8(%ebp)
     e33:	a1 30 15 00 00       	mov    0x1530,%eax
     e38:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e3b:	eb 24                	jmp    e61 <free+0x3d>
     e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e40:	8b 00                	mov    (%eax),%eax
     e42:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e45:	77 12                	ja     e59 <free+0x35>
     e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e4a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e4d:	77 24                	ja     e73 <free+0x4f>
     e4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e52:	8b 00                	mov    (%eax),%eax
     e54:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e57:	77 1a                	ja     e73 <free+0x4f>
     e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e5c:	8b 00                	mov    (%eax),%eax
     e5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e61:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e64:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e67:	76 d4                	jbe    e3d <free+0x19>
     e69:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e6c:	8b 00                	mov    (%eax),%eax
     e6e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e71:	76 ca                	jbe    e3d <free+0x19>
     e73:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e76:	8b 40 04             	mov    0x4(%eax),%eax
     e79:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e83:	01 c2                	add    %eax,%edx
     e85:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e88:	8b 00                	mov    (%eax),%eax
     e8a:	39 c2                	cmp    %eax,%edx
     e8c:	75 24                	jne    eb2 <free+0x8e>
     e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e91:	8b 50 04             	mov    0x4(%eax),%edx
     e94:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e97:	8b 00                	mov    (%eax),%eax
     e99:	8b 40 04             	mov    0x4(%eax),%eax
     e9c:	01 c2                	add    %eax,%edx
     e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ea1:	89 50 04             	mov    %edx,0x4(%eax)
     ea4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ea7:	8b 00                	mov    (%eax),%eax
     ea9:	8b 10                	mov    (%eax),%edx
     eab:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eae:	89 10                	mov    %edx,(%eax)
     eb0:	eb 0a                	jmp    ebc <free+0x98>
     eb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb5:	8b 10                	mov    (%eax),%edx
     eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eba:	89 10                	mov    %edx,(%eax)
     ebc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ebf:	8b 40 04             	mov    0x4(%eax),%eax
     ec2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     ec9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ecc:	01 d0                	add    %edx,%eax
     ece:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     ed1:	75 20                	jne    ef3 <free+0xcf>
     ed3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ed6:	8b 50 04             	mov    0x4(%eax),%edx
     ed9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     edc:	8b 40 04             	mov    0x4(%eax),%eax
     edf:	01 c2                	add    %eax,%edx
     ee1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ee4:	89 50 04             	mov    %edx,0x4(%eax)
     ee7:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eea:	8b 10                	mov    (%eax),%edx
     eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eef:	89 10                	mov    %edx,(%eax)
     ef1:	eb 08                	jmp    efb <free+0xd7>
     ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ef6:	8b 55 f8             	mov    -0x8(%ebp),%edx
     ef9:	89 10                	mov    %edx,(%eax)
     efb:	8b 45 fc             	mov    -0x4(%ebp),%eax
     efe:	a3 30 15 00 00       	mov    %eax,0x1530
     f03:	c9                   	leave  
     f04:	c3                   	ret    

00000f05 <morecore>:
     f05:	55                   	push   %ebp
     f06:	89 e5                	mov    %esp,%ebp
     f08:	83 ec 28             	sub    $0x28,%esp
     f0b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     f12:	77 07                	ja     f1b <morecore+0x16>
     f14:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
     f1b:	8b 45 08             	mov    0x8(%ebp),%eax
     f1e:	c1 e0 03             	shl    $0x3,%eax
     f21:	89 04 24             	mov    %eax,(%esp)
     f24:	e8 57 fc ff ff       	call   b80 <sbrk>
     f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
     f2c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     f30:	75 07                	jne    f39 <morecore+0x34>
     f32:	b8 00 00 00 00       	mov    $0x0,%eax
     f37:	eb 22                	jmp    f5b <morecore+0x56>
     f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f42:	8b 55 08             	mov    0x8(%ebp),%edx
     f45:	89 50 04             	mov    %edx,0x4(%eax)
     f48:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f4b:	83 c0 08             	add    $0x8,%eax
     f4e:	89 04 24             	mov    %eax,(%esp)
     f51:	e8 ce fe ff ff       	call   e24 <free>
     f56:	a1 30 15 00 00       	mov    0x1530,%eax
     f5b:	c9                   	leave  
     f5c:	c3                   	ret    

00000f5d <malloc>:
     f5d:	55                   	push   %ebp
     f5e:	89 e5                	mov    %esp,%ebp
     f60:	83 ec 28             	sub    $0x28,%esp
     f63:	8b 45 08             	mov    0x8(%ebp),%eax
     f66:	83 c0 07             	add    $0x7,%eax
     f69:	c1 e8 03             	shr    $0x3,%eax
     f6c:	40                   	inc    %eax
     f6d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f70:	a1 30 15 00 00       	mov    0x1530,%eax
     f75:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f7c:	75 23                	jne    fa1 <malloc+0x44>
     f7e:	c7 45 f0 28 15 00 00 	movl   $0x1528,-0x10(%ebp)
     f85:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f88:	a3 30 15 00 00       	mov    %eax,0x1530
     f8d:	a1 30 15 00 00       	mov    0x1530,%eax
     f92:	a3 28 15 00 00       	mov    %eax,0x1528
     f97:	c7 05 2c 15 00 00 00 	movl   $0x0,0x152c
     f9e:	00 00 00 
     fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fa4:	8b 00                	mov    (%eax),%eax
     fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fac:	8b 40 04             	mov    0x4(%eax),%eax
     faf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fb2:	72 4d                	jb     1001 <malloc+0xa4>
     fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fb7:	8b 40 04             	mov    0x4(%eax),%eax
     fba:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fbd:	75 0c                	jne    fcb <malloc+0x6e>
     fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc2:	8b 10                	mov    (%eax),%edx
     fc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fc7:	89 10                	mov    %edx,(%eax)
     fc9:	eb 26                	jmp    ff1 <malloc+0x94>
     fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fce:	8b 40 04             	mov    0x4(%eax),%eax
     fd1:	2b 45 ec             	sub    -0x14(%ebp),%eax
     fd4:	89 c2                	mov    %eax,%edx
     fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fd9:	89 50 04             	mov    %edx,0x4(%eax)
     fdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fdf:	8b 40 04             	mov    0x4(%eax),%eax
     fe2:	c1 e0 03             	shl    $0x3,%eax
     fe5:	01 45 f4             	add    %eax,-0xc(%ebp)
     fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     feb:	8b 55 ec             	mov    -0x14(%ebp),%edx
     fee:	89 50 04             	mov    %edx,0x4(%eax)
     ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ff4:	a3 30 15 00 00       	mov    %eax,0x1530
     ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ffc:	83 c0 08             	add    $0x8,%eax
     fff:	eb 38                	jmp    1039 <malloc+0xdc>
    1001:	a1 30 15 00 00       	mov    0x1530,%eax
    1006:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1009:	75 1b                	jne    1026 <malloc+0xc9>
    100b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    100e:	89 04 24             	mov    %eax,(%esp)
    1011:	e8 ef fe ff ff       	call   f05 <morecore>
    1016:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1019:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    101d:	75 07                	jne    1026 <malloc+0xc9>
    101f:	b8 00 00 00 00       	mov    $0x0,%eax
    1024:	eb 13                	jmp    1039 <malloc+0xdc>
    1026:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1029:	89 45 f0             	mov    %eax,-0x10(%ebp)
    102c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    102f:	8b 00                	mov    (%eax),%eax
    1031:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1034:	e9 70 ff ff ff       	jmp    fa9 <malloc+0x4c>
    1039:	c9                   	leave  
    103a:	c3                   	ret    
