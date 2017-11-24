
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 24             	sub    $0x24,%esp
       7:	8b 45 08             	mov    0x8(%ebp),%eax
       a:	89 04 24             	mov    %eax,(%esp)
       d:	e8 1b 05 00 00       	call   52d <strlen>
      12:	8b 55 08             	mov    0x8(%ebp),%edx
      15:	01 d0                	add    %edx,%eax
      17:	89 45 f4             	mov    %eax,-0xc(%ebp)
      1a:	eb 03                	jmp    1f <fmtname+0x1f>
      1c:	ff 4d f4             	decl   -0xc(%ebp)
      1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
      22:	3b 45 08             	cmp    0x8(%ebp),%eax
      25:	72 09                	jb     30 <fmtname+0x30>
      27:	8b 45 f4             	mov    -0xc(%ebp),%eax
      2a:	8a 00                	mov    (%eax),%al
      2c:	3c 2f                	cmp    $0x2f,%al
      2e:	75 ec                	jne    1c <fmtname+0x1c>
      30:	ff 45 f4             	incl   -0xc(%ebp)
      33:	8b 45 f4             	mov    -0xc(%ebp),%eax
      36:	89 04 24             	mov    %eax,(%esp)
      39:	e8 ef 04 00 00       	call   52d <strlen>
      3e:	83 f8 0d             	cmp    $0xd,%eax
      41:	76 05                	jbe    48 <fmtname+0x48>
      43:	8b 45 f4             	mov    -0xc(%ebp),%eax
      46:	eb 5f                	jmp    a7 <fmtname+0xa7>
      48:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4b:	89 04 24             	mov    %eax,(%esp)
      4e:	e8 da 04 00 00       	call   52d <strlen>
      53:	89 44 24 08          	mov    %eax,0x8(%esp)
      57:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5a:	89 44 24 04          	mov    %eax,0x4(%esp)
      5e:	c7 04 24 00 15 00 00 	movl   $0x1500,(%esp)
      65:	e8 53 0a 00 00       	call   abd <memmove>
      6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 b8 04 00 00       	call   52d <strlen>
      75:	ba 0e 00 00 00       	mov    $0xe,%edx
      7a:	89 d3                	mov    %edx,%ebx
      7c:	29 c3                	sub    %eax,%ebx
      7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
      81:	89 04 24             	mov    %eax,(%esp)
      84:	e8 a4 04 00 00       	call   52d <strlen>
      89:	05 00 15 00 00       	add    $0x1500,%eax
      8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
      92:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
      99:	00 
      9a:	89 04 24             	mov    %eax,(%esp)
      9d:	e8 b0 04 00 00       	call   552 <memset>
      a2:	b8 00 15 00 00       	mov    $0x1500,%eax
      a7:	83 c4 24             	add    $0x24,%esp
      aa:	5b                   	pop    %ebx
      ab:	5d                   	pop    %ebp
      ac:	c3                   	ret    

000000ad <ls>:
      ad:	55                   	push   %ebp
      ae:	89 e5                	mov    %esp,%ebp
      b0:	57                   	push   %edi
      b1:	56                   	push   %esi
      b2:	53                   	push   %ebx
      b3:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
      b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      c0:	00 
      c1:	8b 45 08             	mov    0x8(%ebp),%eax
      c4:	89 04 24             	mov    %eax,(%esp)
      c7:	e8 78 0a 00 00       	call   b44 <open>
      cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
      d3:	79 20                	jns    f5 <ls+0x48>
      d5:	8b 45 08             	mov    0x8(%ebp),%eax
      d8:	89 44 24 08          	mov    %eax,0x8(%esp)
      dc:	c7 44 24 04 47 10 00 	movl   $0x1047,0x4(%esp)
      e3:	00 
      e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      eb:	e8 91 0b 00 00       	call   c81 <printf>
      f0:	e9 fd 01 00 00       	jmp    2f2 <ls+0x245>
      f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
      fb:	89 44 24 04          	mov    %eax,0x4(%esp)
      ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     102:	89 04 24             	mov    %eax,(%esp)
     105:	e8 52 0a 00 00       	call   b5c <fstat>
     10a:	85 c0                	test   %eax,%eax
     10c:	79 2b                	jns    139 <ls+0x8c>
     10e:	8b 45 08             	mov    0x8(%ebp),%eax
     111:	89 44 24 08          	mov    %eax,0x8(%esp)
     115:	c7 44 24 04 5b 10 00 	movl   $0x105b,0x4(%esp)
     11c:	00 
     11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     124:	e8 58 0b 00 00       	call   c81 <printf>
     129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     12c:	89 04 24             	mov    %eax,(%esp)
     12f:	e8 f8 09 00 00       	call   b2c <close>
     134:	e9 b9 01 00 00       	jmp    2f2 <ls+0x245>
     139:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
     13f:	98                   	cwtl   
     140:	83 f8 01             	cmp    $0x1,%eax
     143:	74 52                	je     197 <ls+0xea>
     145:	83 f8 02             	cmp    $0x2,%eax
     148:	0f 85 99 01 00 00    	jne    2e7 <ls+0x23a>
     14e:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     154:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     15a:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
     160:	0f bf d8             	movswl %ax,%ebx
     163:	8b 45 08             	mov    0x8(%ebp),%eax
     166:	89 04 24             	mov    %eax,(%esp)
     169:	e8 92 fe ff ff       	call   0 <fmtname>
     16e:	89 7c 24 14          	mov    %edi,0x14(%esp)
     172:	89 74 24 10          	mov    %esi,0x10(%esp)
     176:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     17a:	89 44 24 08          	mov    %eax,0x8(%esp)
     17e:	c7 44 24 04 6f 10 00 	movl   $0x106f,0x4(%esp)
     185:	00 
     186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     18d:	e8 ef 0a 00 00       	call   c81 <printf>
     192:	e9 50 01 00 00       	jmp    2e7 <ls+0x23a>
     197:	8b 45 08             	mov    0x8(%ebp),%eax
     19a:	89 04 24             	mov    %eax,(%esp)
     19d:	e8 8b 03 00 00       	call   52d <strlen>
     1a2:	83 c0 10             	add    $0x10,%eax
     1a5:	3d 00 02 00 00       	cmp    $0x200,%eax
     1aa:	76 19                	jbe    1c5 <ls+0x118>
     1ac:	c7 44 24 04 7c 10 00 	movl   $0x107c,0x4(%esp)
     1b3:	00 
     1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1bb:	e8 c1 0a 00 00       	call   c81 <printf>
     1c0:	e9 22 01 00 00       	jmp    2e7 <ls+0x23a>
     1c5:	8b 45 08             	mov    0x8(%ebp),%eax
     1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
     1cc:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 9f 01 00 00       	call   379 <strcpy>
     1da:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1e0:	89 04 24             	mov    %eax,(%esp)
     1e3:	e8 45 03 00 00       	call   52d <strlen>
     1e8:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
     1ee:	01 d0                	add    %edx,%eax
     1f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
     1f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1f6:	8d 50 01             	lea    0x1(%eax),%edx
     1f9:	89 55 e0             	mov    %edx,-0x20(%ebp)
     1fc:	c6 00 2f             	movb   $0x2f,(%eax)
     1ff:	e9 bc 00 00 00       	jmp    2c0 <ls+0x213>
     204:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
     20a:	66 85 c0             	test   %ax,%ax
     20d:	75 05                	jne    214 <ls+0x167>
     20f:	e9 ac 00 00 00       	jmp    2c0 <ls+0x213>
     214:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
     21b:	00 
     21c:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     222:	83 c0 02             	add    $0x2,%eax
     225:	89 44 24 04          	mov    %eax,0x4(%esp)
     229:	8b 45 e0             	mov    -0x20(%ebp),%eax
     22c:	89 04 24             	mov    %eax,(%esp)
     22f:	e8 89 08 00 00       	call   abd <memmove>
     234:	8b 45 e0             	mov    -0x20(%ebp),%eax
     237:	83 c0 0e             	add    $0xe,%eax
     23a:	c6 00 00             	movb   $0x0,(%eax)
     23d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
     243:	89 44 24 04          	mov    %eax,0x4(%esp)
     247:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     24d:	89 04 24             	mov    %eax,(%esp)
     250:	e8 d0 07 00 00       	call   a25 <stat>
     255:	85 c0                	test   %eax,%eax
     257:	79 20                	jns    279 <ls+0x1cc>
     259:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     25f:	89 44 24 08          	mov    %eax,0x8(%esp)
     263:	c7 44 24 04 5b 10 00 	movl   $0x105b,0x4(%esp)
     26a:	00 
     26b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     272:	e8 0a 0a 00 00       	call   c81 <printf>
     277:	eb 47                	jmp    2c0 <ls+0x213>
     279:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
     27f:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
     285:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
     28b:	0f bf d8             	movswl %ax,%ebx
     28e:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     294:	89 04 24             	mov    %eax,(%esp)
     297:	e8 64 fd ff ff       	call   0 <fmtname>
     29c:	89 7c 24 14          	mov    %edi,0x14(%esp)
     2a0:	89 74 24 10          	mov    %esi,0x10(%esp)
     2a4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
     2a8:	89 44 24 08          	mov    %eax,0x8(%esp)
     2ac:	c7 44 24 04 6f 10 00 	movl   $0x106f,0x4(%esp)
     2b3:	00 
     2b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2bb:	e8 c1 09 00 00       	call   c81 <printf>
     2c0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     2c7:	00 
     2c8:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     2ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     2d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2d5:	89 04 24             	mov    %eax,(%esp)
     2d8:	e8 3f 08 00 00       	call   b1c <read>
     2dd:	83 f8 10             	cmp    $0x10,%eax
     2e0:	0f 84 1e ff ff ff    	je     204 <ls+0x157>
     2e6:	90                   	nop
     2e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2ea:	89 04 24             	mov    %eax,(%esp)
     2ed:	e8 3a 08 00 00       	call   b2c <close>
     2f2:	81 c4 5c 02 00 00    	add    $0x25c,%esp
     2f8:	5b                   	pop    %ebx
     2f9:	5e                   	pop    %esi
     2fa:	5f                   	pop    %edi
     2fb:	5d                   	pop    %ebp
     2fc:	c3                   	ret    

000002fd <main>:
     2fd:	55                   	push   %ebp
     2fe:	89 e5                	mov    %esp,%ebp
     300:	83 e4 f0             	and    $0xfffffff0,%esp
     303:	83 ec 20             	sub    $0x20,%esp
     306:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     30a:	7f 11                	jg     31d <main+0x20>
     30c:	c7 04 24 8f 10 00 00 	movl   $0x108f,(%esp)
     313:	e8 95 fd ff ff       	call   ad <ls>
     318:	e8 e7 07 00 00       	call   b04 <exit>
     31d:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
     324:	00 
     325:	eb 1e                	jmp    345 <main+0x48>
     327:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     32b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     332:	8b 45 0c             	mov    0xc(%ebp),%eax
     335:	01 d0                	add    %edx,%eax
     337:	8b 00                	mov    (%eax),%eax
     339:	89 04 24             	mov    %eax,(%esp)
     33c:	e8 6c fd ff ff       	call   ad <ls>
     341:	ff 44 24 1c          	incl   0x1c(%esp)
     345:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     349:	3b 45 08             	cmp    0x8(%ebp),%eax
     34c:	7c d9                	jl     327 <main+0x2a>
     34e:	e8 b1 07 00 00       	call   b04 <exit>
     353:	90                   	nop

00000354 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     354:	55                   	push   %ebp
     355:	89 e5                	mov    %esp,%ebp
     357:	57                   	push   %edi
     358:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     359:	8b 4d 08             	mov    0x8(%ebp),%ecx
     35c:	8b 55 10             	mov    0x10(%ebp),%edx
     35f:	8b 45 0c             	mov    0xc(%ebp),%eax
     362:	89 cb                	mov    %ecx,%ebx
     364:	89 df                	mov    %ebx,%edi
     366:	89 d1                	mov    %edx,%ecx
     368:	fc                   	cld    
     369:	f3 aa                	rep stos %al,%es:(%edi)
     36b:	89 ca                	mov    %ecx,%edx
     36d:	89 fb                	mov    %edi,%ebx
     36f:	89 5d 08             	mov    %ebx,0x8(%ebp)
     372:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     375:	5b                   	pop    %ebx
     376:	5f                   	pop    %edi
     377:	5d                   	pop    %ebp
     378:	c3                   	ret    

00000379 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     379:	55                   	push   %ebp
     37a:	89 e5                	mov    %esp,%ebp
     37c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     37f:	8b 45 08             	mov    0x8(%ebp),%eax
     382:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     385:	90                   	nop
     386:	8b 45 08             	mov    0x8(%ebp),%eax
     389:	8d 50 01             	lea    0x1(%eax),%edx
     38c:	89 55 08             	mov    %edx,0x8(%ebp)
     38f:	8b 55 0c             	mov    0xc(%ebp),%edx
     392:	8d 4a 01             	lea    0x1(%edx),%ecx
     395:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     398:	8a 12                	mov    (%edx),%dl
     39a:	88 10                	mov    %dl,(%eax)
     39c:	8a 00                	mov    (%eax),%al
     39e:	84 c0                	test   %al,%al
     3a0:	75 e4                	jne    386 <strcpy+0xd>
    ;
  return os;
     3a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     3a5:	c9                   	leave  
     3a6:	c3                   	ret    

000003a7 <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     3a7:	55                   	push   %ebp
     3a8:	89 e5                	mov    %esp,%ebp
     3aa:	83 ec 58             	sub    $0x58,%esp
    int fd1, fd2, count, bytes = 0, max;
     3ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char buffer[32];
        
    if((fd1 = open(inputfile, O_RDONLY)) < 0)
     3b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3bb:	00 
     3bc:	8b 45 08             	mov    0x8(%ebp),%eax
     3bf:	89 04 24             	mov    %eax,(%esp)
     3c2:	e8 7d 07 00 00       	call   b44 <open>
     3c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
     3ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3ce:	79 20                	jns    3f0 <copy+0x49>
    {
        printf(1, "Cannot open inputfile: %s\n", inputfile);
     3d0:	8b 45 08             	mov    0x8(%ebp),%eax
     3d3:	89 44 24 08          	mov    %eax,0x8(%esp)
     3d7:	c7 44 24 04 91 10 00 	movl   $0x1091,0x4(%esp)
     3de:	00 
     3df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3e6:	e8 96 08 00 00       	call   c81 <printf>
        exit();
     3eb:	e8 14 07 00 00       	call   b04 <exit>
    }
    if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     3f0:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     3f7:	00 
     3f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     3fb:	89 04 24             	mov    %eax,(%esp)
     3fe:	e8 41 07 00 00       	call   b44 <open>
     403:	89 45 ec             	mov    %eax,-0x14(%ebp)
     406:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     40a:	79 20                	jns    42c <copy+0x85>
    {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
     40c:	8b 45 0c             	mov    0xc(%ebp),%eax
     40f:	89 44 24 08          	mov    %eax,0x8(%esp)
     413:	c7 44 24 04 ac 10 00 	movl   $0x10ac,0x4(%esp)
     41a:	00 
     41b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     422:	e8 5a 08 00 00       	call   c81 <printf>
        exit();
     427:	e8 d8 06 00 00       	call   b04 <exit>
    }

    while((count = read(fd1, buffer, 32)) > 0)
     42c:	eb 3b                	jmp    469 <copy+0xc2>
    {
        max = used_disk+=count;
     42e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     431:	01 45 10             	add    %eax,0x10(%ebp)
     434:	8b 45 10             	mov    0x10(%ebp),%eax
     437:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(max > max_disk)
     43a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     43d:	3b 45 14             	cmp    0x14(%ebp),%eax
     440:	7e 07                	jle    449 <copy+0xa2>
        {
          return -1;
     442:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     447:	eb 5c                	jmp    4a5 <copy+0xfe>
        }
        bytes = bytes + count;
     449:	8b 45 e8             	mov    -0x18(%ebp),%eax
     44c:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
     44f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     456:	00 
     457:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     45a:	89 44 24 04          	mov    %eax,0x4(%esp)
     45e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     461:	89 04 24             	mov    %eax,(%esp)
     464:	e8 bb 06 00 00       	call   b24 <write>
    {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while((count = read(fd1, buffer, 32)) > 0)
     469:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     470:	00 
     471:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     474:	89 44 24 04          	mov    %eax,0x4(%esp)
     478:	8b 45 f0             	mov    -0x10(%ebp),%eax
     47b:	89 04 24             	mov    %eax,(%esp)
     47e:	e8 99 06 00 00       	call   b1c <read>
     483:	89 45 e8             	mov    %eax,-0x18(%ebp)
     486:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     48a:	7f a2                	jg     42e <copy+0x87>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
     48c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48f:	89 04 24             	mov    %eax,(%esp)
     492:	e8 95 06 00 00       	call   b2c <close>
    close(fd2);
     497:	8b 45 ec             	mov    -0x14(%ebp),%eax
     49a:	89 04 24             	mov    %eax,(%esp)
     49d:	e8 8a 06 00 00       	call   b2c <close>
    return(bytes);
     4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4a5:	c9                   	leave  
     4a6:	c3                   	ret    

000004a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     4a7:	55                   	push   %ebp
     4a8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     4aa:	eb 06                	jmp    4b2 <strcmp+0xb>
    p++, q++;
     4ac:	ff 45 08             	incl   0x8(%ebp)
     4af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     4b2:	8b 45 08             	mov    0x8(%ebp),%eax
     4b5:	8a 00                	mov    (%eax),%al
     4b7:	84 c0                	test   %al,%al
     4b9:	74 0e                	je     4c9 <strcmp+0x22>
     4bb:	8b 45 08             	mov    0x8(%ebp),%eax
     4be:	8a 10                	mov    (%eax),%dl
     4c0:	8b 45 0c             	mov    0xc(%ebp),%eax
     4c3:	8a 00                	mov    (%eax),%al
     4c5:	38 c2                	cmp    %al,%dl
     4c7:	74 e3                	je     4ac <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     4c9:	8b 45 08             	mov    0x8(%ebp),%eax
     4cc:	8a 00                	mov    (%eax),%al
     4ce:	0f b6 d0             	movzbl %al,%edx
     4d1:	8b 45 0c             	mov    0xc(%ebp),%eax
     4d4:	8a 00                	mov    (%eax),%al
     4d6:	0f b6 c0             	movzbl %al,%eax
     4d9:	29 c2                	sub    %eax,%edx
     4db:	89 d0                	mov    %edx,%eax
}
     4dd:	5d                   	pop    %ebp
     4de:	c3                   	ret    

000004df <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     4df:	55                   	push   %ebp
     4e0:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     4e2:	eb 09                	jmp    4ed <strncmp+0xe>
    n--, p++, q++;
     4e4:	ff 4d 10             	decl   0x10(%ebp)
     4e7:	ff 45 08             	incl   0x8(%ebp)
     4ea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     4ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     4f1:	74 17                	je     50a <strncmp+0x2b>
     4f3:	8b 45 08             	mov    0x8(%ebp),%eax
     4f6:	8a 00                	mov    (%eax),%al
     4f8:	84 c0                	test   %al,%al
     4fa:	74 0e                	je     50a <strncmp+0x2b>
     4fc:	8b 45 08             	mov    0x8(%ebp),%eax
     4ff:	8a 10                	mov    (%eax),%dl
     501:	8b 45 0c             	mov    0xc(%ebp),%eax
     504:	8a 00                	mov    (%eax),%al
     506:	38 c2                	cmp    %al,%dl
     508:	74 da                	je     4e4 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     50a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     50e:	75 07                	jne    517 <strncmp+0x38>
    return 0;
     510:	b8 00 00 00 00       	mov    $0x0,%eax
     515:	eb 14                	jmp    52b <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     517:	8b 45 08             	mov    0x8(%ebp),%eax
     51a:	8a 00                	mov    (%eax),%al
     51c:	0f b6 d0             	movzbl %al,%edx
     51f:	8b 45 0c             	mov    0xc(%ebp),%eax
     522:	8a 00                	mov    (%eax),%al
     524:	0f b6 c0             	movzbl %al,%eax
     527:	29 c2                	sub    %eax,%edx
     529:	89 d0                	mov    %edx,%eax
}
     52b:	5d                   	pop    %ebp
     52c:	c3                   	ret    

0000052d <strlen>:

uint
strlen(const char *s)
{
     52d:	55                   	push   %ebp
     52e:	89 e5                	mov    %esp,%ebp
     530:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     533:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     53a:	eb 03                	jmp    53f <strlen+0x12>
     53c:	ff 45 fc             	incl   -0x4(%ebp)
     53f:	8b 55 fc             	mov    -0x4(%ebp),%edx
     542:	8b 45 08             	mov    0x8(%ebp),%eax
     545:	01 d0                	add    %edx,%eax
     547:	8a 00                	mov    (%eax),%al
     549:	84 c0                	test   %al,%al
     54b:	75 ef                	jne    53c <strlen+0xf>
    ;
  return n;
     54d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     550:	c9                   	leave  
     551:	c3                   	ret    

00000552 <memset>:

void*
memset(void *dst, int c, uint n)
{
     552:	55                   	push   %ebp
     553:	89 e5                	mov    %esp,%ebp
     555:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     558:	8b 45 10             	mov    0x10(%ebp),%eax
     55b:	89 44 24 08          	mov    %eax,0x8(%esp)
     55f:	8b 45 0c             	mov    0xc(%ebp),%eax
     562:	89 44 24 04          	mov    %eax,0x4(%esp)
     566:	8b 45 08             	mov    0x8(%ebp),%eax
     569:	89 04 24             	mov    %eax,(%esp)
     56c:	e8 e3 fd ff ff       	call   354 <stosb>
  return dst;
     571:	8b 45 08             	mov    0x8(%ebp),%eax
}
     574:	c9                   	leave  
     575:	c3                   	ret    

00000576 <strchr>:

char*
strchr(const char *s, char c)
{
     576:	55                   	push   %ebp
     577:	89 e5                	mov    %esp,%ebp
     579:	83 ec 04             	sub    $0x4,%esp
     57c:	8b 45 0c             	mov    0xc(%ebp),%eax
     57f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     582:	eb 12                	jmp    596 <strchr+0x20>
    if(*s == c)
     584:	8b 45 08             	mov    0x8(%ebp),%eax
     587:	8a 00                	mov    (%eax),%al
     589:	3a 45 fc             	cmp    -0x4(%ebp),%al
     58c:	75 05                	jne    593 <strchr+0x1d>
      return (char*)s;
     58e:	8b 45 08             	mov    0x8(%ebp),%eax
     591:	eb 11                	jmp    5a4 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     593:	ff 45 08             	incl   0x8(%ebp)
     596:	8b 45 08             	mov    0x8(%ebp),%eax
     599:	8a 00                	mov    (%eax),%al
     59b:	84 c0                	test   %al,%al
     59d:	75 e5                	jne    584 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     59f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     5a4:	c9                   	leave  
     5a5:	c3                   	ret    

000005a6 <strcat>:

char *
strcat(char *dest, const char *src)
{
     5a6:	55                   	push   %ebp
     5a7:	89 e5                	mov    %esp,%ebp
     5a9:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     5ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     5b3:	eb 03                	jmp    5b8 <strcat+0x12>
     5b5:	ff 45 fc             	incl   -0x4(%ebp)
     5b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5bb:	8b 45 08             	mov    0x8(%ebp),%eax
     5be:	01 d0                	add    %edx,%eax
     5c0:	8a 00                	mov    (%eax),%al
     5c2:	84 c0                	test   %al,%al
     5c4:	75 ef                	jne    5b5 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     5c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     5cd:	eb 1e                	jmp    5ed <strcat+0x47>
        dest[i+j] = src[j];
     5cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
     5d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5d5:	01 d0                	add    %edx,%eax
     5d7:	89 c2                	mov    %eax,%edx
     5d9:	8b 45 08             	mov    0x8(%ebp),%eax
     5dc:	01 c2                	add    %eax,%edx
     5de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     5e1:	8b 45 0c             	mov    0xc(%ebp),%eax
     5e4:	01 c8                	add    %ecx,%eax
     5e6:	8a 00                	mov    (%eax),%al
     5e8:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     5ea:	ff 45 f8             	incl   -0x8(%ebp)
     5ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
     5f0:	8b 45 0c             	mov    0xc(%ebp),%eax
     5f3:	01 d0                	add    %edx,%eax
     5f5:	8a 00                	mov    (%eax),%al
     5f7:	84 c0                	test   %al,%al
     5f9:	75 d4                	jne    5cf <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     5fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     5fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
     601:	01 d0                	add    %edx,%eax
     603:	89 c2                	mov    %eax,%edx
     605:	8b 45 08             	mov    0x8(%ebp),%eax
     608:	01 d0                	add    %edx,%eax
     60a:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     60d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     610:	c9                   	leave  
     611:	c3                   	ret    

00000612 <strstr>:

int 
strstr(char* s, char* sub)
{
     612:	55                   	push   %ebp
     613:	89 e5                	mov    %esp,%ebp
     615:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     618:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     61f:	eb 7c                	jmp    69d <strstr+0x8b>
    {
        if(s[i] == sub[0])
     621:	8b 55 fc             	mov    -0x4(%ebp),%edx
     624:	8b 45 08             	mov    0x8(%ebp),%eax
     627:	01 d0                	add    %edx,%eax
     629:	8a 10                	mov    (%eax),%dl
     62b:	8b 45 0c             	mov    0xc(%ebp),%eax
     62e:	8a 00                	mov    (%eax),%al
     630:	38 c2                	cmp    %al,%dl
     632:	75 66                	jne    69a <strstr+0x88>
        {
            if(strlen(sub) == 1)
     634:	8b 45 0c             	mov    0xc(%ebp),%eax
     637:	89 04 24             	mov    %eax,(%esp)
     63a:	e8 ee fe ff ff       	call   52d <strlen>
     63f:	83 f8 01             	cmp    $0x1,%eax
     642:	75 05                	jne    649 <strstr+0x37>
            {  
                return i;
     644:	8b 45 fc             	mov    -0x4(%ebp),%eax
     647:	eb 6b                	jmp    6b4 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     649:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     650:	eb 3a                	jmp    68c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     652:	8b 45 f8             	mov    -0x8(%ebp),%eax
     655:	8b 55 fc             	mov    -0x4(%ebp),%edx
     658:	01 d0                	add    %edx,%eax
     65a:	89 c2                	mov    %eax,%edx
     65c:	8b 45 08             	mov    0x8(%ebp),%eax
     65f:	01 d0                	add    %edx,%eax
     661:	8a 10                	mov    (%eax),%dl
     663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     666:	8b 45 0c             	mov    0xc(%ebp),%eax
     669:	01 c8                	add    %ecx,%eax
     66b:	8a 00                	mov    (%eax),%al
     66d:	38 c2                	cmp    %al,%dl
     66f:	75 16                	jne    687 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     671:	8b 45 f8             	mov    -0x8(%ebp),%eax
     674:	8d 50 01             	lea    0x1(%eax),%edx
     677:	8b 45 0c             	mov    0xc(%ebp),%eax
     67a:	01 d0                	add    %edx,%eax
     67c:	8a 00                	mov    (%eax),%al
     67e:	84 c0                	test   %al,%al
     680:	75 07                	jne    689 <strstr+0x77>
                    {
                        return i;
     682:	8b 45 fc             	mov    -0x4(%ebp),%eax
     685:	eb 2d                	jmp    6b4 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     687:	eb 11                	jmp    69a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     689:	ff 45 f8             	incl   -0x8(%ebp)
     68c:	8b 55 f8             	mov    -0x8(%ebp),%edx
     68f:	8b 45 0c             	mov    0xc(%ebp),%eax
     692:	01 d0                	add    %edx,%eax
     694:	8a 00                	mov    (%eax),%al
     696:	84 c0                	test   %al,%al
     698:	75 b8                	jne    652 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     69a:	ff 45 fc             	incl   -0x4(%ebp)
     69d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     6a0:	8b 45 08             	mov    0x8(%ebp),%eax
     6a3:	01 d0                	add    %edx,%eax
     6a5:	8a 00                	mov    (%eax),%al
     6a7:	84 c0                	test   %al,%al
     6a9:	0f 85 72 ff ff ff    	jne    621 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     6af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     6b4:	c9                   	leave  
     6b5:	c3                   	ret    

000006b6 <strtok>:

char *
strtok(char *s, const char *delim)
{
     6b6:	55                   	push   %ebp
     6b7:	89 e5                	mov    %esp,%ebp
     6b9:	53                   	push   %ebx
     6ba:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     6bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     6c1:	75 08                	jne    6cb <strtok+0x15>
  s = lasts;
     6c3:	a1 14 15 00 00       	mov    0x1514,%eax
     6c8:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     6cb:	8b 45 08             	mov    0x8(%ebp),%eax
     6ce:	8d 50 01             	lea    0x1(%eax),%edx
     6d1:	89 55 08             	mov    %edx,0x8(%ebp)
     6d4:	8a 00                	mov    (%eax),%al
     6d6:	0f be d8             	movsbl %al,%ebx
     6d9:	85 db                	test   %ebx,%ebx
     6db:	75 07                	jne    6e4 <strtok+0x2e>
      return 0;
     6dd:	b8 00 00 00 00       	mov    $0x0,%eax
     6e2:	eb 58                	jmp    73c <strtok+0x86>
    } while (strchr(delim, ch));
     6e4:	88 d8                	mov    %bl,%al
     6e6:	0f be c0             	movsbl %al,%eax
     6e9:	89 44 24 04          	mov    %eax,0x4(%esp)
     6ed:	8b 45 0c             	mov    0xc(%ebp),%eax
     6f0:	89 04 24             	mov    %eax,(%esp)
     6f3:	e8 7e fe ff ff       	call   576 <strchr>
     6f8:	85 c0                	test   %eax,%eax
     6fa:	75 cf                	jne    6cb <strtok+0x15>
    --s;
     6fc:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     6ff:	8b 45 0c             	mov    0xc(%ebp),%eax
     702:	89 44 24 04          	mov    %eax,0x4(%esp)
     706:	8b 45 08             	mov    0x8(%ebp),%eax
     709:	89 04 24             	mov    %eax,(%esp)
     70c:	e8 31 00 00 00       	call   742 <strcspn>
     711:	89 c2                	mov    %eax,%edx
     713:	8b 45 08             	mov    0x8(%ebp),%eax
     716:	01 d0                	add    %edx,%eax
     718:	a3 14 15 00 00       	mov    %eax,0x1514
    if (*lasts != 0)
     71d:	a1 14 15 00 00       	mov    0x1514,%eax
     722:	8a 00                	mov    (%eax),%al
     724:	84 c0                	test   %al,%al
     726:	74 11                	je     739 <strtok+0x83>
  *lasts++ = 0;
     728:	a1 14 15 00 00       	mov    0x1514,%eax
     72d:	8d 50 01             	lea    0x1(%eax),%edx
     730:	89 15 14 15 00 00    	mov    %edx,0x1514
     736:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     739:	8b 45 08             	mov    0x8(%ebp),%eax
}
     73c:	83 c4 14             	add    $0x14,%esp
     73f:	5b                   	pop    %ebx
     740:	5d                   	pop    %ebp
     741:	c3                   	ret    

00000742 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     742:	55                   	push   %ebp
     743:	89 e5                	mov    %esp,%ebp
     745:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     748:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     74f:	eb 26                	jmp    777 <strcspn+0x35>
        if(strchr(s2,*s1))
     751:	8b 45 08             	mov    0x8(%ebp),%eax
     754:	8a 00                	mov    (%eax),%al
     756:	0f be c0             	movsbl %al,%eax
     759:	89 44 24 04          	mov    %eax,0x4(%esp)
     75d:	8b 45 0c             	mov    0xc(%ebp),%eax
     760:	89 04 24             	mov    %eax,(%esp)
     763:	e8 0e fe ff ff       	call   576 <strchr>
     768:	85 c0                	test   %eax,%eax
     76a:	74 05                	je     771 <strcspn+0x2f>
            return ret;
     76c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     76f:	eb 12                	jmp    783 <strcspn+0x41>
        else
            s1++,ret++;
     771:	ff 45 08             	incl   0x8(%ebp)
     774:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     777:	8b 45 08             	mov    0x8(%ebp),%eax
     77a:	8a 00                	mov    (%eax),%al
     77c:	84 c0                	test   %al,%al
     77e:	75 d1                	jne    751 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     780:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     783:	c9                   	leave  
     784:	c3                   	ret    

00000785 <isspace>:

int
isspace(unsigned char c)
{
     785:	55                   	push   %ebp
     786:	89 e5                	mov    %esp,%ebp
     788:	83 ec 04             	sub    $0x4,%esp
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     791:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     795:	74 1e                	je     7b5 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     797:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     79b:	74 18                	je     7b5 <isspace+0x30>
     79d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     7a1:	74 12                	je     7b5 <isspace+0x30>
     7a3:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     7a7:	74 0c                	je     7b5 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     7a9:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     7ad:	74 06                	je     7b5 <isspace+0x30>
     7af:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     7b3:	75 07                	jne    7bc <isspace+0x37>
     7b5:	b8 01 00 00 00       	mov    $0x1,%eax
     7ba:	eb 05                	jmp    7c1 <isspace+0x3c>
     7bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7c1:	c9                   	leave  
     7c2:	c3                   	ret    

000007c3 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     7c3:	55                   	push   %ebp
     7c4:	89 e5                	mov    %esp,%ebp
     7c6:	57                   	push   %edi
     7c7:	56                   	push   %esi
     7c8:	53                   	push   %ebx
     7c9:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     7cc:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     7d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     7d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     7db:	eb 01                	jmp    7de <strtoul+0x1b>
  p += 1;
     7dd:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     7de:	8a 03                	mov    (%ebx),%al
     7e0:	0f b6 c0             	movzbl %al,%eax
     7e3:	89 04 24             	mov    %eax,(%esp)
     7e6:	e8 9a ff ff ff       	call   785 <isspace>
     7eb:	85 c0                	test   %eax,%eax
     7ed:	75 ee                	jne    7dd <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     7ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     7f3:	75 30                	jne    825 <strtoul+0x62>
    {
  if (*p == '0') {
     7f5:	8a 03                	mov    (%ebx),%al
     7f7:	3c 30                	cmp    $0x30,%al
     7f9:	75 21                	jne    81c <strtoul+0x59>
      p += 1;
     7fb:	43                   	inc    %ebx
      if (*p == 'x') {
     7fc:	8a 03                	mov    (%ebx),%al
     7fe:	3c 78                	cmp    $0x78,%al
     800:	75 0a                	jne    80c <strtoul+0x49>
    p += 1;
     802:	43                   	inc    %ebx
    base = 16;
     803:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     80a:	eb 31                	jmp    83d <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     80c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     813:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     81a:	eb 21                	jmp    83d <strtoul+0x7a>
      }
  }
  else base = 10;
     81c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     823:	eb 18                	jmp    83d <strtoul+0x7a>
    } else if (base == 16) {
     825:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     829:	75 12                	jne    83d <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     82b:	8a 03                	mov    (%ebx),%al
     82d:	3c 30                	cmp    $0x30,%al
     82f:	75 0c                	jne    83d <strtoul+0x7a>
     831:	8d 43 01             	lea    0x1(%ebx),%eax
     834:	8a 00                	mov    (%eax),%al
     836:	3c 78                	cmp    $0x78,%al
     838:	75 03                	jne    83d <strtoul+0x7a>
      p += 2;
     83a:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     83d:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     841:	75 29                	jne    86c <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     843:	8a 03                	mov    (%ebx),%al
     845:	0f be c0             	movsbl %al,%eax
     848:	83 e8 30             	sub    $0x30,%eax
     84b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     84d:	83 fe 07             	cmp    $0x7,%esi
     850:	76 06                	jbe    858 <strtoul+0x95>
    break;
     852:	90                   	nop
     853:	e9 b6 00 00 00       	jmp    90e <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     858:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     85f:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     862:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     869:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     86a:	eb d7                	jmp    843 <strtoul+0x80>
    } else if (base == 10) {
     86c:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     870:	75 2b                	jne    89d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     872:	8a 03                	mov    (%ebx),%al
     874:	0f be c0             	movsbl %al,%eax
     877:	83 e8 30             	sub    $0x30,%eax
     87a:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     87c:	83 fe 09             	cmp    $0x9,%esi
     87f:	76 06                	jbe    887 <strtoul+0xc4>
    break;
     881:	90                   	nop
     882:	e9 87 00 00 00       	jmp    90e <strtoul+0x14b>
      }
      result = (10*result) + digit;
     887:	89 f8                	mov    %edi,%eax
     889:	c1 e0 02             	shl    $0x2,%eax
     88c:	01 f8                	add    %edi,%eax
     88e:	01 c0                	add    %eax,%eax
     890:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     893:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     89a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     89b:	eb d5                	jmp    872 <strtoul+0xaf>
    } else if (base == 16) {
     89d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     8a1:	75 35                	jne    8d8 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     8a3:	8a 03                	mov    (%ebx),%al
     8a5:	0f be c0             	movsbl %al,%eax
     8a8:	83 e8 30             	sub    $0x30,%eax
     8ab:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8ad:	83 fe 4a             	cmp    $0x4a,%esi
     8b0:	76 02                	jbe    8b4 <strtoul+0xf1>
    break;
     8b2:	eb 22                	jmp    8d6 <strtoul+0x113>
      }
      digit = cvtIn[digit];
     8b4:	8a 86 a0 14 00 00    	mov    0x14a0(%esi),%al
     8ba:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     8bd:	83 fe 0f             	cmp    $0xf,%esi
     8c0:	76 02                	jbe    8c4 <strtoul+0x101>
    break;
     8c2:	eb 12                	jmp    8d6 <strtoul+0x113>
      }
      result = (result << 4) + digit;
     8c4:	89 f8                	mov    %edi,%eax
     8c6:	c1 e0 04             	shl    $0x4,%eax
     8c9:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     8cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     8d3:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     8d4:	eb cd                	jmp    8a3 <strtoul+0xe0>
     8d6:	eb 36                	jmp    90e <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     8d8:	8a 03                	mov    (%ebx),%al
     8da:	0f be c0             	movsbl %al,%eax
     8dd:	83 e8 30             	sub    $0x30,%eax
     8e0:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8e2:	83 fe 4a             	cmp    $0x4a,%esi
     8e5:	76 02                	jbe    8e9 <strtoul+0x126>
    break;
     8e7:	eb 25                	jmp    90e <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     8e9:	8a 86 a0 14 00 00    	mov    0x14a0(%esi),%al
     8ef:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     8f2:	8b 45 10             	mov    0x10(%ebp),%eax
     8f5:	39 f0                	cmp    %esi,%eax
     8f7:	77 02                	ja     8fb <strtoul+0x138>
    break;
     8f9:	eb 13                	jmp    90e <strtoul+0x14b>
      }
      result = result*base + digit;
     8fb:	8b 45 10             	mov    0x10(%ebp),%eax
     8fe:	0f af c7             	imul   %edi,%eax
     901:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     904:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     90b:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     90c:	eb ca                	jmp    8d8 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     90e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     912:	75 03                	jne    917 <strtoul+0x154>
  p = string;
     914:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     917:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     91b:	74 05                	je     922 <strtoul+0x15f>
  *endPtr = p;
     91d:	8b 45 0c             	mov    0xc(%ebp),%eax
     920:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     922:	89 f8                	mov    %edi,%eax
}
     924:	83 c4 14             	add    $0x14,%esp
     927:	5b                   	pop    %ebx
     928:	5e                   	pop    %esi
     929:	5f                   	pop    %edi
     92a:	5d                   	pop    %ebp
     92b:	c3                   	ret    

0000092c <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     92c:	55                   	push   %ebp
     92d:	89 e5                	mov    %esp,%ebp
     92f:	53                   	push   %ebx
     930:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     933:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     936:	eb 01                	jmp    939 <strtol+0xd>
      p += 1;
     938:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     939:	8a 03                	mov    (%ebx),%al
     93b:	0f b6 c0             	movzbl %al,%eax
     93e:	89 04 24             	mov    %eax,(%esp)
     941:	e8 3f fe ff ff       	call   785 <isspace>
     946:	85 c0                	test   %eax,%eax
     948:	75 ee                	jne    938 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     94a:	8a 03                	mov    (%ebx),%al
     94c:	3c 2d                	cmp    $0x2d,%al
     94e:	75 1e                	jne    96e <strtol+0x42>
  p += 1;
     950:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     951:	8b 45 10             	mov    0x10(%ebp),%eax
     954:	89 44 24 08          	mov    %eax,0x8(%esp)
     958:	8b 45 0c             	mov    0xc(%ebp),%eax
     95b:	89 44 24 04          	mov    %eax,0x4(%esp)
     95f:	89 1c 24             	mov    %ebx,(%esp)
     962:	e8 5c fe ff ff       	call   7c3 <strtoul>
     967:	f7 d8                	neg    %eax
     969:	89 45 f8             	mov    %eax,-0x8(%ebp)
     96c:	eb 20                	jmp    98e <strtol+0x62>
    } else {
  if (*p == '+') {
     96e:	8a 03                	mov    (%ebx),%al
     970:	3c 2b                	cmp    $0x2b,%al
     972:	75 01                	jne    975 <strtol+0x49>
      p += 1;
     974:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     975:	8b 45 10             	mov    0x10(%ebp),%eax
     978:	89 44 24 08          	mov    %eax,0x8(%esp)
     97c:	8b 45 0c             	mov    0xc(%ebp),%eax
     97f:	89 44 24 04          	mov    %eax,0x4(%esp)
     983:	89 1c 24             	mov    %ebx,(%esp)
     986:	e8 38 fe ff ff       	call   7c3 <strtoul>
     98b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     98e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     992:	75 17                	jne    9ab <strtol+0x7f>
     994:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     998:	74 11                	je     9ab <strtol+0x7f>
     99a:	8b 45 0c             	mov    0xc(%ebp),%eax
     99d:	8b 00                	mov    (%eax),%eax
     99f:	39 d8                	cmp    %ebx,%eax
     9a1:	75 08                	jne    9ab <strtol+0x7f>
  *endPtr = string;
     9a3:	8b 45 0c             	mov    0xc(%ebp),%eax
     9a6:	8b 55 08             	mov    0x8(%ebp),%edx
     9a9:	89 10                	mov    %edx,(%eax)
    }
    return result;
     9ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     9ae:	83 c4 1c             	add    $0x1c,%esp
     9b1:	5b                   	pop    %ebx
     9b2:	5d                   	pop    %ebp
     9b3:	c3                   	ret    

000009b4 <gets>:

char*
gets(char *buf, int max)
{
     9b4:	55                   	push   %ebp
     9b5:	89 e5                	mov    %esp,%ebp
     9b7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9c1:	eb 49                	jmp    a0c <gets+0x58>
    cc = read(0, &c, 1);
     9c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     9ca:	00 
     9cb:	8d 45 ef             	lea    -0x11(%ebp),%eax
     9ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     9d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9d9:	e8 3e 01 00 00       	call   b1c <read>
     9de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     9e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9e5:	7f 02                	jg     9e9 <gets+0x35>
      break;
     9e7:	eb 2c                	jmp    a15 <gets+0x61>
    buf[i++] = c;
     9e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ec:	8d 50 01             	lea    0x1(%eax),%edx
     9ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
     9f2:	89 c2                	mov    %eax,%edx
     9f4:	8b 45 08             	mov    0x8(%ebp),%eax
     9f7:	01 c2                	add    %eax,%edx
     9f9:	8a 45 ef             	mov    -0x11(%ebp),%al
     9fc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     9fe:	8a 45 ef             	mov    -0x11(%ebp),%al
     a01:	3c 0a                	cmp    $0xa,%al
     a03:	74 10                	je     a15 <gets+0x61>
     a05:	8a 45 ef             	mov    -0x11(%ebp),%al
     a08:	3c 0d                	cmp    $0xd,%al
     a0a:	74 09                	je     a15 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a0f:	40                   	inc    %eax
     a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
     a13:	7c ae                	jl     9c3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     a15:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a18:	8b 45 08             	mov    0x8(%ebp),%eax
     a1b:	01 d0                	add    %edx,%eax
     a1d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     a20:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a23:	c9                   	leave  
     a24:	c3                   	ret    

00000a25 <stat>:

int
stat(char *n, struct stat *st)
{
     a25:	55                   	push   %ebp
     a26:	89 e5                	mov    %esp,%ebp
     a28:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     a32:	00 
     a33:	8b 45 08             	mov    0x8(%ebp),%eax
     a36:	89 04 24             	mov    %eax,(%esp)
     a39:	e8 06 01 00 00       	call   b44 <open>
     a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     a41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     a45:	79 07                	jns    a4e <stat+0x29>
    return -1;
     a47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a4c:	eb 23                	jmp    a71 <stat+0x4c>
  r = fstat(fd, st);
     a4e:	8b 45 0c             	mov    0xc(%ebp),%eax
     a51:	89 44 24 04          	mov    %eax,0x4(%esp)
     a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a58:	89 04 24             	mov    %eax,(%esp)
     a5b:	e8 fc 00 00 00       	call   b5c <fstat>
     a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a66:	89 04 24             	mov    %eax,(%esp)
     a69:	e8 be 00 00 00       	call   b2c <close>
  return r;
     a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a71:	c9                   	leave  
     a72:	c3                   	ret    

00000a73 <atoi>:

int
atoi(const char *s)
{
     a73:	55                   	push   %ebp
     a74:	89 e5                	mov    %esp,%ebp
     a76:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     a79:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     a80:	eb 24                	jmp    aa6 <atoi+0x33>
    n = n*10 + *s++ - '0';
     a82:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a85:	89 d0                	mov    %edx,%eax
     a87:	c1 e0 02             	shl    $0x2,%eax
     a8a:	01 d0                	add    %edx,%eax
     a8c:	01 c0                	add    %eax,%eax
     a8e:	89 c1                	mov    %eax,%ecx
     a90:	8b 45 08             	mov    0x8(%ebp),%eax
     a93:	8d 50 01             	lea    0x1(%eax),%edx
     a96:	89 55 08             	mov    %edx,0x8(%ebp)
     a99:	8a 00                	mov    (%eax),%al
     a9b:	0f be c0             	movsbl %al,%eax
     a9e:	01 c8                	add    %ecx,%eax
     aa0:	83 e8 30             	sub    $0x30,%eax
     aa3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aa6:	8b 45 08             	mov    0x8(%ebp),%eax
     aa9:	8a 00                	mov    (%eax),%al
     aab:	3c 2f                	cmp    $0x2f,%al
     aad:	7e 09                	jle    ab8 <atoi+0x45>
     aaf:	8b 45 08             	mov    0x8(%ebp),%eax
     ab2:	8a 00                	mov    (%eax),%al
     ab4:	3c 39                	cmp    $0x39,%al
     ab6:	7e ca                	jle    a82 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     abb:	c9                   	leave  
     abc:	c3                   	ret    

00000abd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     abd:	55                   	push   %ebp
     abe:	89 e5                	mov    %esp,%ebp
     ac0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     ac3:	8b 45 08             	mov    0x8(%ebp),%eax
     ac6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
     acc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     acf:	eb 16                	jmp    ae7 <memmove+0x2a>
    *dst++ = *src++;
     ad1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ad4:	8d 50 01             	lea    0x1(%eax),%edx
     ad7:	89 55 fc             	mov    %edx,-0x4(%ebp)
     ada:	8b 55 f8             	mov    -0x8(%ebp),%edx
     add:	8d 4a 01             	lea    0x1(%edx),%ecx
     ae0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     ae3:	8a 12                	mov    (%edx),%dl
     ae5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     ae7:	8b 45 10             	mov    0x10(%ebp),%eax
     aea:	8d 50 ff             	lea    -0x1(%eax),%edx
     aed:	89 55 10             	mov    %edx,0x10(%ebp)
     af0:	85 c0                	test   %eax,%eax
     af2:	7f dd                	jg     ad1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     af4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     af7:	c9                   	leave  
     af8:	c3                   	ret    
     af9:	90                   	nop
     afa:	90                   	nop
     afb:	90                   	nop

00000afc <fork>:
     afc:	b8 01 00 00 00       	mov    $0x1,%eax
     b01:	cd 40                	int    $0x40
     b03:	c3                   	ret    

00000b04 <exit>:
     b04:	b8 02 00 00 00       	mov    $0x2,%eax
     b09:	cd 40                	int    $0x40
     b0b:	c3                   	ret    

00000b0c <wait>:
     b0c:	b8 03 00 00 00       	mov    $0x3,%eax
     b11:	cd 40                	int    $0x40
     b13:	c3                   	ret    

00000b14 <pipe>:
     b14:	b8 04 00 00 00       	mov    $0x4,%eax
     b19:	cd 40                	int    $0x40
     b1b:	c3                   	ret    

00000b1c <read>:
     b1c:	b8 05 00 00 00       	mov    $0x5,%eax
     b21:	cd 40                	int    $0x40
     b23:	c3                   	ret    

00000b24 <write>:
     b24:	b8 10 00 00 00       	mov    $0x10,%eax
     b29:	cd 40                	int    $0x40
     b2b:	c3                   	ret    

00000b2c <close>:
     b2c:	b8 15 00 00 00       	mov    $0x15,%eax
     b31:	cd 40                	int    $0x40
     b33:	c3                   	ret    

00000b34 <kill>:
     b34:	b8 06 00 00 00       	mov    $0x6,%eax
     b39:	cd 40                	int    $0x40
     b3b:	c3                   	ret    

00000b3c <exec>:
     b3c:	b8 07 00 00 00       	mov    $0x7,%eax
     b41:	cd 40                	int    $0x40
     b43:	c3                   	ret    

00000b44 <open>:
     b44:	b8 0f 00 00 00       	mov    $0xf,%eax
     b49:	cd 40                	int    $0x40
     b4b:	c3                   	ret    

00000b4c <mknod>:
     b4c:	b8 11 00 00 00       	mov    $0x11,%eax
     b51:	cd 40                	int    $0x40
     b53:	c3                   	ret    

00000b54 <unlink>:
     b54:	b8 12 00 00 00       	mov    $0x12,%eax
     b59:	cd 40                	int    $0x40
     b5b:	c3                   	ret    

00000b5c <fstat>:
     b5c:	b8 08 00 00 00       	mov    $0x8,%eax
     b61:	cd 40                	int    $0x40
     b63:	c3                   	ret    

00000b64 <link>:
     b64:	b8 13 00 00 00       	mov    $0x13,%eax
     b69:	cd 40                	int    $0x40
     b6b:	c3                   	ret    

00000b6c <mkdir>:
     b6c:	b8 14 00 00 00       	mov    $0x14,%eax
     b71:	cd 40                	int    $0x40
     b73:	c3                   	ret    

00000b74 <chdir>:
     b74:	b8 09 00 00 00       	mov    $0x9,%eax
     b79:	cd 40                	int    $0x40
     b7b:	c3                   	ret    

00000b7c <dup>:
     b7c:	b8 0a 00 00 00       	mov    $0xa,%eax
     b81:	cd 40                	int    $0x40
     b83:	c3                   	ret    

00000b84 <getpid>:
     b84:	b8 0b 00 00 00       	mov    $0xb,%eax
     b89:	cd 40                	int    $0x40
     b8b:	c3                   	ret    

00000b8c <sbrk>:
     b8c:	b8 0c 00 00 00       	mov    $0xc,%eax
     b91:	cd 40                	int    $0x40
     b93:	c3                   	ret    

00000b94 <sleep>:
     b94:	b8 0d 00 00 00       	mov    $0xd,%eax
     b99:	cd 40                	int    $0x40
     b9b:	c3                   	ret    

00000b9c <uptime>:
     b9c:	b8 0e 00 00 00       	mov    $0xe,%eax
     ba1:	cd 40                	int    $0x40
     ba3:	c3                   	ret    

00000ba4 <putc>:
     ba4:	55                   	push   %ebp
     ba5:	89 e5                	mov    %esp,%ebp
     ba7:	83 ec 18             	sub    $0x18,%esp
     baa:	8b 45 0c             	mov    0xc(%ebp),%eax
     bad:	88 45 f4             	mov    %al,-0xc(%ebp)
     bb0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bb7:	00 
     bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
     bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
     bbf:	8b 45 08             	mov    0x8(%ebp),%eax
     bc2:	89 04 24             	mov    %eax,(%esp)
     bc5:	e8 5a ff ff ff       	call   b24 <write>
     bca:	c9                   	leave  
     bcb:	c3                   	ret    

00000bcc <printint>:
     bcc:	55                   	push   %ebp
     bcd:	89 e5                	mov    %esp,%ebp
     bcf:	56                   	push   %esi
     bd0:	53                   	push   %ebx
     bd1:	83 ec 30             	sub    $0x30,%esp
     bd4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     bdb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     bdf:	74 17                	je     bf8 <printint+0x2c>
     be1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     be5:	79 11                	jns    bf8 <printint+0x2c>
     be7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     bee:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf1:	f7 d8                	neg    %eax
     bf3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     bf6:	eb 06                	jmp    bfe <printint+0x32>
     bf8:	8b 45 0c             	mov    0xc(%ebp),%eax
     bfb:	89 45 ec             	mov    %eax,-0x14(%ebp)
     bfe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     c08:	8d 41 01             	lea    0x1(%ecx),%eax
     c0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     c0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
     c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c14:	ba 00 00 00 00       	mov    $0x0,%edx
     c19:	f7 f3                	div    %ebx
     c1b:	89 d0                	mov    %edx,%eax
     c1d:	8a 80 ec 14 00 00    	mov    0x14ec(%eax),%al
     c23:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
     c27:	8b 75 10             	mov    0x10(%ebp),%esi
     c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c2d:	ba 00 00 00 00       	mov    $0x0,%edx
     c32:	f7 f6                	div    %esi
     c34:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c3b:	75 c8                	jne    c05 <printint+0x39>
     c3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c41:	74 10                	je     c53 <printint+0x87>
     c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c46:	8d 50 01             	lea    0x1(%eax),%edx
     c49:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c4c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
     c51:	eb 1e                	jmp    c71 <printint+0xa5>
     c53:	eb 1c                	jmp    c71 <printint+0xa5>
     c55:	8d 55 dc             	lea    -0x24(%ebp),%edx
     c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c5b:	01 d0                	add    %edx,%eax
     c5d:	8a 00                	mov    (%eax),%al
     c5f:	0f be c0             	movsbl %al,%eax
     c62:	89 44 24 04          	mov    %eax,0x4(%esp)
     c66:	8b 45 08             	mov    0x8(%ebp),%eax
     c69:	89 04 24             	mov    %eax,(%esp)
     c6c:	e8 33 ff ff ff       	call   ba4 <putc>
     c71:	ff 4d f4             	decl   -0xc(%ebp)
     c74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c78:	79 db                	jns    c55 <printint+0x89>
     c7a:	83 c4 30             	add    $0x30,%esp
     c7d:	5b                   	pop    %ebx
     c7e:	5e                   	pop    %esi
     c7f:	5d                   	pop    %ebp
     c80:	c3                   	ret    

00000c81 <printf>:
     c81:	55                   	push   %ebp
     c82:	89 e5                	mov    %esp,%ebp
     c84:	83 ec 38             	sub    $0x38,%esp
     c87:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
     c91:	83 c0 04             	add    $0x4,%eax
     c94:	89 45 e8             	mov    %eax,-0x18(%ebp)
     c97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     c9e:	e9 77 01 00 00       	jmp    e1a <printf+0x199>
     ca3:	8b 55 0c             	mov    0xc(%ebp),%edx
     ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ca9:	01 d0                	add    %edx,%eax
     cab:	8a 00                	mov    (%eax),%al
     cad:	0f be c0             	movsbl %al,%eax
     cb0:	25 ff 00 00 00       	and    $0xff,%eax
     cb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     cb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     cbc:	75 2c                	jne    cea <printf+0x69>
     cbe:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     cc2:	75 0c                	jne    cd0 <printf+0x4f>
     cc4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     ccb:	e9 47 01 00 00       	jmp    e17 <printf+0x196>
     cd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cd3:	0f be c0             	movsbl %al,%eax
     cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
     cda:	8b 45 08             	mov    0x8(%ebp),%eax
     cdd:	89 04 24             	mov    %eax,(%esp)
     ce0:	e8 bf fe ff ff       	call   ba4 <putc>
     ce5:	e9 2d 01 00 00       	jmp    e17 <printf+0x196>
     cea:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     cee:	0f 85 23 01 00 00    	jne    e17 <printf+0x196>
     cf4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     cf8:	75 2d                	jne    d27 <printf+0xa6>
     cfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
     cfd:	8b 00                	mov    (%eax),%eax
     cff:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     d06:	00 
     d07:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     d0e:	00 
     d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     d13:	8b 45 08             	mov    0x8(%ebp),%eax
     d16:	89 04 24             	mov    %eax,(%esp)
     d19:	e8 ae fe ff ff       	call   bcc <printint>
     d1e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d22:	e9 e9 00 00 00       	jmp    e10 <printf+0x18f>
     d27:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     d2b:	74 06                	je     d33 <printf+0xb2>
     d2d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     d31:	75 2d                	jne    d60 <printf+0xdf>
     d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d36:	8b 00                	mov    (%eax),%eax
     d38:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d3f:	00 
     d40:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     d47:	00 
     d48:	89 44 24 04          	mov    %eax,0x4(%esp)
     d4c:	8b 45 08             	mov    0x8(%ebp),%eax
     d4f:	89 04 24             	mov    %eax,(%esp)
     d52:	e8 75 fe ff ff       	call   bcc <printint>
     d57:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d5b:	e9 b0 00 00 00       	jmp    e10 <printf+0x18f>
     d60:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     d64:	75 42                	jne    da8 <printf+0x127>
     d66:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d69:	8b 00                	mov    (%eax),%eax
     d6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
     d6e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d76:	75 09                	jne    d81 <printf+0x100>
     d78:	c7 45 f4 c8 10 00 00 	movl   $0x10c8,-0xc(%ebp)
     d7f:	eb 1c                	jmp    d9d <printf+0x11c>
     d81:	eb 1a                	jmp    d9d <printf+0x11c>
     d83:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d86:	8a 00                	mov    (%eax),%al
     d88:	0f be c0             	movsbl %al,%eax
     d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
     d8f:	8b 45 08             	mov    0x8(%ebp),%eax
     d92:	89 04 24             	mov    %eax,(%esp)
     d95:	e8 0a fe ff ff       	call   ba4 <putc>
     d9a:	ff 45 f4             	incl   -0xc(%ebp)
     d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     da0:	8a 00                	mov    (%eax),%al
     da2:	84 c0                	test   %al,%al
     da4:	75 dd                	jne    d83 <printf+0x102>
     da6:	eb 68                	jmp    e10 <printf+0x18f>
     da8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     dac:	75 1d                	jne    dcb <printf+0x14a>
     dae:	8b 45 e8             	mov    -0x18(%ebp),%eax
     db1:	8b 00                	mov    (%eax),%eax
     db3:	0f be c0             	movsbl %al,%eax
     db6:	89 44 24 04          	mov    %eax,0x4(%esp)
     dba:	8b 45 08             	mov    0x8(%ebp),%eax
     dbd:	89 04 24             	mov    %eax,(%esp)
     dc0:	e8 df fd ff ff       	call   ba4 <putc>
     dc5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     dc9:	eb 45                	jmp    e10 <printf+0x18f>
     dcb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     dcf:	75 17                	jne    de8 <printf+0x167>
     dd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dd4:	0f be c0             	movsbl %al,%eax
     dd7:	89 44 24 04          	mov    %eax,0x4(%esp)
     ddb:	8b 45 08             	mov    0x8(%ebp),%eax
     dde:	89 04 24             	mov    %eax,(%esp)
     de1:	e8 be fd ff ff       	call   ba4 <putc>
     de6:	eb 28                	jmp    e10 <printf+0x18f>
     de8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     def:	00 
     df0:	8b 45 08             	mov    0x8(%ebp),%eax
     df3:	89 04 24             	mov    %eax,(%esp)
     df6:	e8 a9 fd ff ff       	call   ba4 <putc>
     dfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dfe:	0f be c0             	movsbl %al,%eax
     e01:	89 44 24 04          	mov    %eax,0x4(%esp)
     e05:	8b 45 08             	mov    0x8(%ebp),%eax
     e08:	89 04 24             	mov    %eax,(%esp)
     e0b:	e8 94 fd ff ff       	call   ba4 <putc>
     e10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     e17:	ff 45 f0             	incl   -0x10(%ebp)
     e1a:	8b 55 0c             	mov    0xc(%ebp),%edx
     e1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e20:	01 d0                	add    %edx,%eax
     e22:	8a 00                	mov    (%eax),%al
     e24:	84 c0                	test   %al,%al
     e26:	0f 85 77 fe ff ff    	jne    ca3 <printf+0x22>
     e2c:	c9                   	leave  
     e2d:	c3                   	ret    
     e2e:	90                   	nop
     e2f:	90                   	nop

00000e30 <free>:
     e30:	55                   	push   %ebp
     e31:	89 e5                	mov    %esp,%ebp
     e33:	83 ec 10             	sub    $0x10,%esp
     e36:	8b 45 08             	mov    0x8(%ebp),%eax
     e39:	83 e8 08             	sub    $0x8,%eax
     e3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
     e3f:	a1 20 15 00 00       	mov    0x1520,%eax
     e44:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e47:	eb 24                	jmp    e6d <free+0x3d>
     e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e4c:	8b 00                	mov    (%eax),%eax
     e4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e51:	77 12                	ja     e65 <free+0x35>
     e53:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e56:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e59:	77 24                	ja     e7f <free+0x4f>
     e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e5e:	8b 00                	mov    (%eax),%eax
     e60:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e63:	77 1a                	ja     e7f <free+0x4f>
     e65:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e68:	8b 00                	mov    (%eax),%eax
     e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e70:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e73:	76 d4                	jbe    e49 <free+0x19>
     e75:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e78:	8b 00                	mov    (%eax),%eax
     e7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e7d:	76 ca                	jbe    e49 <free+0x19>
     e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e82:	8b 40 04             	mov    0x4(%eax),%eax
     e85:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     e8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e8f:	01 c2                	add    %eax,%edx
     e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e94:	8b 00                	mov    (%eax),%eax
     e96:	39 c2                	cmp    %eax,%edx
     e98:	75 24                	jne    ebe <free+0x8e>
     e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e9d:	8b 50 04             	mov    0x4(%eax),%edx
     ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ea3:	8b 00                	mov    (%eax),%eax
     ea5:	8b 40 04             	mov    0x4(%eax),%eax
     ea8:	01 c2                	add    %eax,%edx
     eaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ead:	89 50 04             	mov    %edx,0x4(%eax)
     eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb3:	8b 00                	mov    (%eax),%eax
     eb5:	8b 10                	mov    (%eax),%edx
     eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eba:	89 10                	mov    %edx,(%eax)
     ebc:	eb 0a                	jmp    ec8 <free+0x98>
     ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ec1:	8b 10                	mov    (%eax),%edx
     ec3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ec6:	89 10                	mov    %edx,(%eax)
     ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ecb:	8b 40 04             	mov    0x4(%eax),%eax
     ece:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ed8:	01 d0                	add    %edx,%eax
     eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     edd:	75 20                	jne    eff <free+0xcf>
     edf:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ee2:	8b 50 04             	mov    0x4(%eax),%edx
     ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ee8:	8b 40 04             	mov    0x4(%eax),%eax
     eeb:	01 c2                	add    %eax,%edx
     eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ef0:	89 50 04             	mov    %edx,0x4(%eax)
     ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ef6:	8b 10                	mov    (%eax),%edx
     ef8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     efb:	89 10                	mov    %edx,(%eax)
     efd:	eb 08                	jmp    f07 <free+0xd7>
     eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f02:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f05:	89 10                	mov    %edx,(%eax)
     f07:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f0a:	a3 20 15 00 00       	mov    %eax,0x1520
     f0f:	c9                   	leave  
     f10:	c3                   	ret    

00000f11 <morecore>:
     f11:	55                   	push   %ebp
     f12:	89 e5                	mov    %esp,%ebp
     f14:	83 ec 28             	sub    $0x28,%esp
     f17:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     f1e:	77 07                	ja     f27 <morecore+0x16>
     f20:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
     f27:	8b 45 08             	mov    0x8(%ebp),%eax
     f2a:	c1 e0 03             	shl    $0x3,%eax
     f2d:	89 04 24             	mov    %eax,(%esp)
     f30:	e8 57 fc ff ff       	call   b8c <sbrk>
     f35:	89 45 f4             	mov    %eax,-0xc(%ebp)
     f38:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     f3c:	75 07                	jne    f45 <morecore+0x34>
     f3e:	b8 00 00 00 00       	mov    $0x0,%eax
     f43:	eb 22                	jmp    f67 <morecore+0x56>
     f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f48:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f4e:	8b 55 08             	mov    0x8(%ebp),%edx
     f51:	89 50 04             	mov    %edx,0x4(%eax)
     f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f57:	83 c0 08             	add    $0x8,%eax
     f5a:	89 04 24             	mov    %eax,(%esp)
     f5d:	e8 ce fe ff ff       	call   e30 <free>
     f62:	a1 20 15 00 00       	mov    0x1520,%eax
     f67:	c9                   	leave  
     f68:	c3                   	ret    

00000f69 <malloc>:
     f69:	55                   	push   %ebp
     f6a:	89 e5                	mov    %esp,%ebp
     f6c:	83 ec 28             	sub    $0x28,%esp
     f6f:	8b 45 08             	mov    0x8(%ebp),%eax
     f72:	83 c0 07             	add    $0x7,%eax
     f75:	c1 e8 03             	shr    $0x3,%eax
     f78:	40                   	inc    %eax
     f79:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f7c:	a1 20 15 00 00       	mov    0x1520,%eax
     f81:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f88:	75 23                	jne    fad <malloc+0x44>
     f8a:	c7 45 f0 18 15 00 00 	movl   $0x1518,-0x10(%ebp)
     f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f94:	a3 20 15 00 00       	mov    %eax,0x1520
     f99:	a1 20 15 00 00       	mov    0x1520,%eax
     f9e:	a3 18 15 00 00       	mov    %eax,0x1518
     fa3:	c7 05 1c 15 00 00 00 	movl   $0x0,0x151c
     faa:	00 00 00 
     fad:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fb0:	8b 00                	mov    (%eax),%eax
     fb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
     fb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fb8:	8b 40 04             	mov    0x4(%eax),%eax
     fbb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fbe:	72 4d                	jb     100d <malloc+0xa4>
     fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc3:	8b 40 04             	mov    0x4(%eax),%eax
     fc6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fc9:	75 0c                	jne    fd7 <malloc+0x6e>
     fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fce:	8b 10                	mov    (%eax),%edx
     fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fd3:	89 10                	mov    %edx,(%eax)
     fd5:	eb 26                	jmp    ffd <malloc+0x94>
     fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fda:	8b 40 04             	mov    0x4(%eax),%eax
     fdd:	2b 45 ec             	sub    -0x14(%ebp),%eax
     fe0:	89 c2                	mov    %eax,%edx
     fe2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe5:	89 50 04             	mov    %edx,0x4(%eax)
     fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     feb:	8b 40 04             	mov    0x4(%eax),%eax
     fee:	c1 e0 03             	shl    $0x3,%eax
     ff1:	01 45 f4             	add    %eax,-0xc(%ebp)
     ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ff7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     ffa:	89 50 04             	mov    %edx,0x4(%eax)
     ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1000:	a3 20 15 00 00       	mov    %eax,0x1520
    1005:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1008:	83 c0 08             	add    $0x8,%eax
    100b:	eb 38                	jmp    1045 <malloc+0xdc>
    100d:	a1 20 15 00 00       	mov    0x1520,%eax
    1012:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1015:	75 1b                	jne    1032 <malloc+0xc9>
    1017:	8b 45 ec             	mov    -0x14(%ebp),%eax
    101a:	89 04 24             	mov    %eax,(%esp)
    101d:	e8 ef fe ff ff       	call   f11 <morecore>
    1022:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1025:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1029:	75 07                	jne    1032 <malloc+0xc9>
    102b:	b8 00 00 00 00       	mov    $0x0,%eax
    1030:	eb 13                	jmp    1045 <malloc+0xdc>
    1032:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1035:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1038:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103b:	8b 00                	mov    (%eax),%eax
    103d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1040:	e9 70 ff ff ff       	jmp    fb5 <malloc+0x4c>
    1045:	c9                   	leave  
    1046:	c3                   	ret    
