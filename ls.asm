
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	53                   	push   %ebx
       4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
       7:	8b 45 08             	mov    0x8(%ebp),%eax
       a:	89 04 24             	mov    %eax,(%esp)
       d:	e8 2f 05 00 00       	call   541 <strlen>
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
    ;
  p++;
      30:	ff 45 f4             	incl   -0xc(%ebp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
      33:	8b 45 f4             	mov    -0xc(%ebp),%eax
      36:	89 04 24             	mov    %eax,(%esp)
      39:	e8 03 05 00 00       	call   541 <strlen>
      3e:	83 f8 0d             	cmp    $0xd,%eax
      41:	76 05                	jbe    48 <fmtname+0x48>
    return p;
      43:	8b 45 f4             	mov    -0xc(%ebp),%eax
      46:	eb 5f                	jmp    a7 <fmtname+0xa7>
  memmove(buf, p, strlen(p));
      48:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4b:	89 04 24             	mov    %eax,(%esp)
      4e:	e8 ee 04 00 00       	call   541 <strlen>
      53:	89 44 24 08          	mov    %eax,0x8(%esp)
      57:	8b 45 f4             	mov    -0xc(%ebp),%eax
      5a:	89 44 24 04          	mov    %eax,0x4(%esp)
      5e:	c7 04 24 40 15 00 00 	movl   $0x1540,(%esp)
      65:	e8 67 0a 00 00       	call   ad1 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
      6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 cc 04 00 00       	call   541 <strlen>
      75:	ba 0e 00 00 00       	mov    $0xe,%edx
      7a:	89 d3                	mov    %edx,%ebx
      7c:	29 c3                	sub    %eax,%ebx
      7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
      81:	89 04 24             	mov    %eax,(%esp)
      84:	e8 b8 04 00 00       	call   541 <strlen>
      89:	05 40 15 00 00       	add    $0x1540,%eax
      8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
      92:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
      99:	00 
      9a:	89 04 24             	mov    %eax,(%esp)
      9d:	e8 c4 04 00 00       	call   566 <memset>
  return buf;
      a2:	b8 40 15 00 00       	mov    $0x1540,%eax
}
      a7:	83 c4 24             	add    $0x24,%esp
      aa:	5b                   	pop    %ebx
      ab:	5d                   	pop    %ebp
      ac:	c3                   	ret    

000000ad <ls>:

void
ls(char *path)
{
      ad:	55                   	push   %ebp
      ae:	89 e5                	mov    %esp,%ebp
      b0:	57                   	push   %edi
      b1:	56                   	push   %esi
      b2:	53                   	push   %ebx
      b3:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
      b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
      c0:	00 
      c1:	8b 45 08             	mov    0x8(%ebp),%eax
      c4:	89 04 24             	mov    %eax,(%esp)
      c7:	e8 8c 0a 00 00       	call   b58 <open>
      cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
      d3:	79 20                	jns    f5 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
      d5:	8b 45 08             	mov    0x8(%ebp),%eax
      d8:	89 44 24 08          	mov    %eax,0x8(%esp)
      dc:	c7 44 24 04 5b 10 00 	movl   $0x105b,0x4(%esp)
      e3:	00 
      e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      eb:	e8 a5 0b 00 00       	call   c95 <printf>
    return;
      f0:	e9 fd 01 00 00       	jmp    2f2 <ls+0x245>
  }

  if(fstat(fd, &st) < 0){
      f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
      fb:	89 44 24 04          	mov    %eax,0x4(%esp)
      ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     102:	89 04 24             	mov    %eax,(%esp)
     105:	e8 66 0a 00 00       	call   b70 <fstat>
     10a:	85 c0                	test   %eax,%eax
     10c:	79 2b                	jns    139 <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
     10e:	8b 45 08             	mov    0x8(%ebp),%eax
     111:	89 44 24 08          	mov    %eax,0x8(%esp)
     115:	c7 44 24 04 6f 10 00 	movl   $0x106f,0x4(%esp)
     11c:	00 
     11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     124:	e8 6c 0b 00 00       	call   c95 <printf>
    close(fd);
     129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     12c:	89 04 24             	mov    %eax,(%esp)
     12f:	e8 0c 0a 00 00       	call   b40 <close>
    return;
     134:	e9 b9 01 00 00       	jmp    2f2 <ls+0x245>
  }

  switch(st.type){
     139:	8b 85 bc fd ff ff    	mov    -0x244(%ebp),%eax
     13f:	98                   	cwtl   
     140:	83 f8 01             	cmp    $0x1,%eax
     143:	74 52                	je     197 <ls+0xea>
     145:	83 f8 02             	cmp    $0x2,%eax
     148:	0f 85 99 01 00 00    	jne    2e7 <ls+0x23a>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
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
     17e:	c7 44 24 04 83 10 00 	movl   $0x1083,0x4(%esp)
     185:	00 
     186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     18d:	e8 03 0b 00 00       	call   c95 <printf>
    break;
     192:	e9 50 01 00 00       	jmp    2e7 <ls+0x23a>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
     197:	8b 45 08             	mov    0x8(%ebp),%eax
     19a:	89 04 24             	mov    %eax,(%esp)
     19d:	e8 9f 03 00 00       	call   541 <strlen>
     1a2:	83 c0 10             	add    $0x10,%eax
     1a5:	3d 00 02 00 00       	cmp    $0x200,%eax
     1aa:	76 19                	jbe    1c5 <ls+0x118>
      printf(1, "ls: path too long\n");
     1ac:	c7 44 24 04 90 10 00 	movl   $0x1090,0x4(%esp)
     1b3:	00 
     1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     1bb:	e8 d5 0a 00 00       	call   c95 <printf>
      break;
     1c0:	e9 22 01 00 00       	jmp    2e7 <ls+0x23a>
    }
    strcpy(buf, path);
     1c5:	8b 45 08             	mov    0x8(%ebp),%eax
     1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
     1cc:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 9f 01 00 00       	call   379 <strcpy>
    p = buf+strlen(buf);
     1da:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     1e0:	89 04 24             	mov    %eax,(%esp)
     1e3:	e8 59 03 00 00       	call   541 <strlen>
     1e8:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
     1ee:	01 d0                	add    %edx,%eax
     1f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
     1f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1f6:	8d 50 01             	lea    0x1(%eax),%edx
     1f9:	89 55 e0             	mov    %edx,-0x20(%ebp)
     1fc:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     1ff:	e9 bc 00 00 00       	jmp    2c0 <ls+0x213>
      if(de.inum == 0)
     204:	8b 85 d0 fd ff ff    	mov    -0x230(%ebp),%eax
     20a:	66 85 c0             	test   %ax,%ax
     20d:	75 05                	jne    214 <ls+0x167>
        continue;
     20f:	e9 ac 00 00 00       	jmp    2c0 <ls+0x213>
      memmove(p, de.name, DIRSIZ);
     214:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
     21b:	00 
     21c:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     222:	83 c0 02             	add    $0x2,%eax
     225:	89 44 24 04          	mov    %eax,0x4(%esp)
     229:	8b 45 e0             	mov    -0x20(%ebp),%eax
     22c:	89 04 24             	mov    %eax,(%esp)
     22f:	e8 9d 08 00 00       	call   ad1 <memmove>
      p[DIRSIZ] = 0;
     234:	8b 45 e0             	mov    -0x20(%ebp),%eax
     237:	83 c0 0e             	add    $0xe,%eax
     23a:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
     23d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
     243:	89 44 24 04          	mov    %eax,0x4(%esp)
     247:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     24d:	89 04 24             	mov    %eax,(%esp)
     250:	e8 e4 07 00 00       	call   a39 <stat>
     255:	85 c0                	test   %eax,%eax
     257:	79 20                	jns    279 <ls+0x1cc>
        printf(1, "ls: cannot stat %s\n", buf);
     259:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
     25f:	89 44 24 08          	mov    %eax,0x8(%esp)
     263:	c7 44 24 04 6f 10 00 	movl   $0x106f,0x4(%esp)
     26a:	00 
     26b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     272:	e8 1e 0a 00 00       	call   c95 <printf>
        continue;
     277:	eb 47                	jmp    2c0 <ls+0x213>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
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
     2ac:	c7 44 24 04 83 10 00 	movl   $0x1083,0x4(%esp)
     2b3:	00 
     2b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2bb:	e8 d5 09 00 00       	call   c95 <printf>
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
     2c0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     2c7:	00 
     2c8:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
     2ce:	89 44 24 04          	mov    %eax,0x4(%esp)
     2d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2d5:	89 04 24             	mov    %eax,(%esp)
     2d8:	e8 53 08 00 00       	call   b30 <read>
     2dd:	83 f8 10             	cmp    $0x10,%eax
     2e0:	0f 84 1e ff ff ff    	je     204 <ls+0x157>
        printf(1, "ls: cannot stat %s\n", buf);
        continue;
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
     2e6:	90                   	nop
  }
  close(fd);
     2e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     2ea:	89 04 24             	mov    %eax,(%esp)
     2ed:	e8 4e 08 00 00       	call   b40 <close>
}
     2f2:	81 c4 5c 02 00 00    	add    $0x25c,%esp
     2f8:	5b                   	pop    %ebx
     2f9:	5e                   	pop    %esi
     2fa:	5f                   	pop    %edi
     2fb:	5d                   	pop    %ebp
     2fc:	c3                   	ret    

000002fd <main>:

int
main(int argc, char *argv[])
{
     2fd:	55                   	push   %ebp
     2fe:	89 e5                	mov    %esp,%ebp
     300:	83 e4 f0             	and    $0xfffffff0,%esp
     303:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
     306:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     30a:	7f 11                	jg     31d <main+0x20>
    ls(".");
     30c:	c7 04 24 a3 10 00 00 	movl   $0x10a3,(%esp)
     313:	e8 95 fd ff ff       	call   ad <ls>
    exit();
     318:	e8 fb 07 00 00       	call   b18 <exit>
  }
  for(i=1; i<argc; i++)
     31d:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
     324:	00 
     325:	eb 1e                	jmp    345 <main+0x48>
    ls(argv[i]);
     327:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     32b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     332:	8b 45 0c             	mov    0xc(%ebp),%eax
     335:	01 d0                	add    %edx,%eax
     337:	8b 00                	mov    (%eax),%eax
     339:	89 04 24             	mov    %eax,(%esp)
     33c:	e8 6c fd ff ff       	call   ad <ls>

  if(argc < 2){
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
     341:	ff 44 24 1c          	incl   0x1c(%esp)
     345:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     349:	3b 45 08             	cmp    0x8(%ebp),%eax
     34c:	7c d9                	jl     327 <main+0x2a>
    ls(argv[i]);
  exit();
     34e:	e8 c5 07 00 00       	call   b18 <exit>
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

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
     3a7:	55                   	push   %ebp
     3a8:	89 e5                	mov    %esp,%ebp
     3aa:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
     3ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3b4:	00 
     3b5:	8b 45 08             	mov    0x8(%ebp),%eax
     3b8:	89 04 24             	mov    %eax,(%esp)
     3bb:	e8 98 07 00 00       	call   b58 <open>
     3c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
     3c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     3c7:	79 20                	jns    3e9 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
     3c9:	8b 45 08             	mov    0x8(%ebp),%eax
     3cc:	89 44 24 08          	mov    %eax,0x8(%esp)
     3d0:	c7 44 24 04 a5 10 00 	movl   $0x10a5,0x4(%esp)
     3d7:	00 
     3d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     3df:	e8 b1 08 00 00       	call   c95 <printf>
        exit();
     3e4:	e8 2f 07 00 00       	call   b18 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
     3e9:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     3f0:	00 
     3f1:	8b 45 0c             	mov    0xc(%ebp),%eax
     3f4:	89 04 24             	mov    %eax,(%esp)
     3f7:	e8 5c 07 00 00       	call   b58 <open>
     3fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
     3ff:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     403:	79 20                	jns    425 <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
     405:	8b 45 0c             	mov    0xc(%ebp),%eax
     408:	89 44 24 08          	mov    %eax,0x8(%esp)
     40c:	c7 44 24 04 c0 10 00 	movl   $0x10c0,0x4(%esp)
     413:	00 
     414:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     41b:	e8 75 08 00 00       	call   c95 <printf>
        exit();
     420:	e8 f3 06 00 00       	call   b18 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
     425:	eb 56                	jmp    47d <copy+0xd6>
        int max = used_disk+=count;
     427:	8b 45 e8             	mov    -0x18(%ebp),%eax
     42a:	01 45 10             	add    %eax,0x10(%ebp)
     42d:	8b 45 10             	mov    0x10(%ebp),%eax
     430:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
     433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     436:	89 44 24 08          	mov    %eax,0x8(%esp)
     43a:	c7 44 24 04 dc 10 00 	movl   $0x10dc,0x4(%esp)
     441:	00 
     442:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     449:	e8 47 08 00 00       	call   c95 <printf>
        if(max > max_disk){
     44e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     451:	3b 45 14             	cmp    0x14(%ebp),%eax
     454:	7e 07                	jle    45d <copy+0xb6>
          return -1;
     456:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     45b:	eb 5c                	jmp    4b9 <copy+0x112>
        }
        bytes = bytes + count;
     45d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     460:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
     463:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     46a:	00 
     46b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     46e:	89 44 24 04          	mov    %eax,0x4(%esp)
     472:	8b 45 ec             	mov    -0x14(%ebp),%eax
     475:	89 04 24             	mov    %eax,(%esp)
     478:	e8 bb 06 00 00       	call   b38 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
     47d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     484:	00 
     485:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     488:	89 44 24 04          	mov    %eax,0x4(%esp)
     48c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     48f:	89 04 24             	mov    %eax,(%esp)
     492:	e8 99 06 00 00       	call   b30 <read>
     497:	89 45 e8             	mov    %eax,-0x18(%ebp)
     49a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     49e:	7f 87                	jg     427 <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
     4a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4a3:	89 04 24             	mov    %eax,(%esp)
     4a6:	e8 95 06 00 00       	call   b40 <close>
    close(fd2);
     4ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
     4ae:	89 04 24             	mov    %eax,(%esp)
     4b1:	e8 8a 06 00 00       	call   b40 <close>
    return(bytes);
     4b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4b9:	c9                   	leave  
     4ba:	c3                   	ret    

000004bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
     4bb:	55                   	push   %ebp
     4bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     4be:	eb 06                	jmp    4c6 <strcmp+0xb>
    p++, q++;
     4c0:	ff 45 08             	incl   0x8(%ebp)
     4c3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     4c6:	8b 45 08             	mov    0x8(%ebp),%eax
     4c9:	8a 00                	mov    (%eax),%al
     4cb:	84 c0                	test   %al,%al
     4cd:	74 0e                	je     4dd <strcmp+0x22>
     4cf:	8b 45 08             	mov    0x8(%ebp),%eax
     4d2:	8a 10                	mov    (%eax),%dl
     4d4:	8b 45 0c             	mov    0xc(%ebp),%eax
     4d7:	8a 00                	mov    (%eax),%al
     4d9:	38 c2                	cmp    %al,%dl
     4db:	74 e3                	je     4c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     4dd:	8b 45 08             	mov    0x8(%ebp),%eax
     4e0:	8a 00                	mov    (%eax),%al
     4e2:	0f b6 d0             	movzbl %al,%edx
     4e5:	8b 45 0c             	mov    0xc(%ebp),%eax
     4e8:	8a 00                	mov    (%eax),%al
     4ea:	0f b6 c0             	movzbl %al,%eax
     4ed:	29 c2                	sub    %eax,%edx
     4ef:	89 d0                	mov    %edx,%eax
}
     4f1:	5d                   	pop    %ebp
     4f2:	c3                   	ret    

000004f3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     4f3:	55                   	push   %ebp
     4f4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     4f6:	eb 09                	jmp    501 <strncmp+0xe>
    n--, p++, q++;
     4f8:	ff 4d 10             	decl   0x10(%ebp)
     4fb:	ff 45 08             	incl   0x8(%ebp)
     4fe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     501:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     505:	74 17                	je     51e <strncmp+0x2b>
     507:	8b 45 08             	mov    0x8(%ebp),%eax
     50a:	8a 00                	mov    (%eax),%al
     50c:	84 c0                	test   %al,%al
     50e:	74 0e                	je     51e <strncmp+0x2b>
     510:	8b 45 08             	mov    0x8(%ebp),%eax
     513:	8a 10                	mov    (%eax),%dl
     515:	8b 45 0c             	mov    0xc(%ebp),%eax
     518:	8a 00                	mov    (%eax),%al
     51a:	38 c2                	cmp    %al,%dl
     51c:	74 da                	je     4f8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     51e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     522:	75 07                	jne    52b <strncmp+0x38>
    return 0;
     524:	b8 00 00 00 00       	mov    $0x0,%eax
     529:	eb 14                	jmp    53f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     52b:	8b 45 08             	mov    0x8(%ebp),%eax
     52e:	8a 00                	mov    (%eax),%al
     530:	0f b6 d0             	movzbl %al,%edx
     533:	8b 45 0c             	mov    0xc(%ebp),%eax
     536:	8a 00                	mov    (%eax),%al
     538:	0f b6 c0             	movzbl %al,%eax
     53b:	29 c2                	sub    %eax,%edx
     53d:	89 d0                	mov    %edx,%eax
}
     53f:	5d                   	pop    %ebp
     540:	c3                   	ret    

00000541 <strlen>:

uint
strlen(const char *s)
{
     541:	55                   	push   %ebp
     542:	89 e5                	mov    %esp,%ebp
     544:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     547:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     54e:	eb 03                	jmp    553 <strlen+0x12>
     550:	ff 45 fc             	incl   -0x4(%ebp)
     553:	8b 55 fc             	mov    -0x4(%ebp),%edx
     556:	8b 45 08             	mov    0x8(%ebp),%eax
     559:	01 d0                	add    %edx,%eax
     55b:	8a 00                	mov    (%eax),%al
     55d:	84 c0                	test   %al,%al
     55f:	75 ef                	jne    550 <strlen+0xf>
    ;
  return n;
     561:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     564:	c9                   	leave  
     565:	c3                   	ret    

00000566 <memset>:

void*
memset(void *dst, int c, uint n)
{
     566:	55                   	push   %ebp
     567:	89 e5                	mov    %esp,%ebp
     569:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     56c:	8b 45 10             	mov    0x10(%ebp),%eax
     56f:	89 44 24 08          	mov    %eax,0x8(%esp)
     573:	8b 45 0c             	mov    0xc(%ebp),%eax
     576:	89 44 24 04          	mov    %eax,0x4(%esp)
     57a:	8b 45 08             	mov    0x8(%ebp),%eax
     57d:	89 04 24             	mov    %eax,(%esp)
     580:	e8 cf fd ff ff       	call   354 <stosb>
  return dst;
     585:	8b 45 08             	mov    0x8(%ebp),%eax
}
     588:	c9                   	leave  
     589:	c3                   	ret    

0000058a <strchr>:

char*
strchr(const char *s, char c)
{
     58a:	55                   	push   %ebp
     58b:	89 e5                	mov    %esp,%ebp
     58d:	83 ec 04             	sub    $0x4,%esp
     590:	8b 45 0c             	mov    0xc(%ebp),%eax
     593:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     596:	eb 12                	jmp    5aa <strchr+0x20>
    if(*s == c)
     598:	8b 45 08             	mov    0x8(%ebp),%eax
     59b:	8a 00                	mov    (%eax),%al
     59d:	3a 45 fc             	cmp    -0x4(%ebp),%al
     5a0:	75 05                	jne    5a7 <strchr+0x1d>
      return (char*)s;
     5a2:	8b 45 08             	mov    0x8(%ebp),%eax
     5a5:	eb 11                	jmp    5b8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     5a7:	ff 45 08             	incl   0x8(%ebp)
     5aa:	8b 45 08             	mov    0x8(%ebp),%eax
     5ad:	8a 00                	mov    (%eax),%al
     5af:	84 c0                	test   %al,%al
     5b1:	75 e5                	jne    598 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     5b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     5b8:	c9                   	leave  
     5b9:	c3                   	ret    

000005ba <strcat>:

char *
strcat(char *dest, const char *src)
{
     5ba:	55                   	push   %ebp
     5bb:	89 e5                	mov    %esp,%ebp
     5bd:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     5c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     5c7:	eb 03                	jmp    5cc <strcat+0x12>
     5c9:	ff 45 fc             	incl   -0x4(%ebp)
     5cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5cf:	8b 45 08             	mov    0x8(%ebp),%eax
     5d2:	01 d0                	add    %edx,%eax
     5d4:	8a 00                	mov    (%eax),%al
     5d6:	84 c0                	test   %al,%al
     5d8:	75 ef                	jne    5c9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     5da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     5e1:	eb 1e                	jmp    601 <strcat+0x47>
        dest[i+j] = src[j];
     5e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     5e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     5e9:	01 d0                	add    %edx,%eax
     5eb:	89 c2                	mov    %eax,%edx
     5ed:	8b 45 08             	mov    0x8(%ebp),%eax
     5f0:	01 c2                	add    %eax,%edx
     5f2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     5f5:	8b 45 0c             	mov    0xc(%ebp),%eax
     5f8:	01 c8                	add    %ecx,%eax
     5fa:	8a 00                	mov    (%eax),%al
     5fc:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     5fe:	ff 45 f8             	incl   -0x8(%ebp)
     601:	8b 55 f8             	mov    -0x8(%ebp),%edx
     604:	8b 45 0c             	mov    0xc(%ebp),%eax
     607:	01 d0                	add    %edx,%eax
     609:	8a 00                	mov    (%eax),%al
     60b:	84 c0                	test   %al,%al
     60d:	75 d4                	jne    5e3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     60f:	8b 45 f8             	mov    -0x8(%ebp),%eax
     612:	8b 55 fc             	mov    -0x4(%ebp),%edx
     615:	01 d0                	add    %edx,%eax
     617:	89 c2                	mov    %eax,%edx
     619:	8b 45 08             	mov    0x8(%ebp),%eax
     61c:	01 d0                	add    %edx,%eax
     61e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     621:	8b 45 08             	mov    0x8(%ebp),%eax
}
     624:	c9                   	leave  
     625:	c3                   	ret    

00000626 <strstr>:

int 
strstr(char* s, char* sub)
{
     626:	55                   	push   %ebp
     627:	89 e5                	mov    %esp,%ebp
     629:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     62c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     633:	eb 7c                	jmp    6b1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     635:	8b 55 fc             	mov    -0x4(%ebp),%edx
     638:	8b 45 08             	mov    0x8(%ebp),%eax
     63b:	01 d0                	add    %edx,%eax
     63d:	8a 10                	mov    (%eax),%dl
     63f:	8b 45 0c             	mov    0xc(%ebp),%eax
     642:	8a 00                	mov    (%eax),%al
     644:	38 c2                	cmp    %al,%dl
     646:	75 66                	jne    6ae <strstr+0x88>
        {
            if(strlen(sub) == 1)
     648:	8b 45 0c             	mov    0xc(%ebp),%eax
     64b:	89 04 24             	mov    %eax,(%esp)
     64e:	e8 ee fe ff ff       	call   541 <strlen>
     653:	83 f8 01             	cmp    $0x1,%eax
     656:	75 05                	jne    65d <strstr+0x37>
            {  
                return i;
     658:	8b 45 fc             	mov    -0x4(%ebp),%eax
     65b:	eb 6b                	jmp    6c8 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     65d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     664:	eb 3a                	jmp    6a0 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     666:	8b 45 f8             	mov    -0x8(%ebp),%eax
     669:	8b 55 fc             	mov    -0x4(%ebp),%edx
     66c:	01 d0                	add    %edx,%eax
     66e:	89 c2                	mov    %eax,%edx
     670:	8b 45 08             	mov    0x8(%ebp),%eax
     673:	01 d0                	add    %edx,%eax
     675:	8a 10                	mov    (%eax),%dl
     677:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     67a:	8b 45 0c             	mov    0xc(%ebp),%eax
     67d:	01 c8                	add    %ecx,%eax
     67f:	8a 00                	mov    (%eax),%al
     681:	38 c2                	cmp    %al,%dl
     683:	75 16                	jne    69b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     685:	8b 45 f8             	mov    -0x8(%ebp),%eax
     688:	8d 50 01             	lea    0x1(%eax),%edx
     68b:	8b 45 0c             	mov    0xc(%ebp),%eax
     68e:	01 d0                	add    %edx,%eax
     690:	8a 00                	mov    (%eax),%al
     692:	84 c0                	test   %al,%al
     694:	75 07                	jne    69d <strstr+0x77>
                    {
                        return i;
     696:	8b 45 fc             	mov    -0x4(%ebp),%eax
     699:	eb 2d                	jmp    6c8 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     69b:	eb 11                	jmp    6ae <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     69d:	ff 45 f8             	incl   -0x8(%ebp)
     6a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
     6a3:	8b 45 0c             	mov    0xc(%ebp),%eax
     6a6:	01 d0                	add    %edx,%eax
     6a8:	8a 00                	mov    (%eax),%al
     6aa:	84 c0                	test   %al,%al
     6ac:	75 b8                	jne    666 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     6ae:	ff 45 fc             	incl   -0x4(%ebp)
     6b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     6b4:	8b 45 08             	mov    0x8(%ebp),%eax
     6b7:	01 d0                	add    %edx,%eax
     6b9:	8a 00                	mov    (%eax),%al
     6bb:	84 c0                	test   %al,%al
     6bd:	0f 85 72 ff ff ff    	jne    635 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     6c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     6c8:	c9                   	leave  
     6c9:	c3                   	ret    

000006ca <strtok>:

char *
strtok(char *s, const char *delim)
{
     6ca:	55                   	push   %ebp
     6cb:	89 e5                	mov    %esp,%ebp
     6cd:	53                   	push   %ebx
     6ce:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     6d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     6d5:	75 08                	jne    6df <strtok+0x15>
  s = lasts;
     6d7:	a1 54 15 00 00       	mov    0x1554,%eax
     6dc:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     6df:	8b 45 08             	mov    0x8(%ebp),%eax
     6e2:	8d 50 01             	lea    0x1(%eax),%edx
     6e5:	89 55 08             	mov    %edx,0x8(%ebp)
     6e8:	8a 00                	mov    (%eax),%al
     6ea:	0f be d8             	movsbl %al,%ebx
     6ed:	85 db                	test   %ebx,%ebx
     6ef:	75 07                	jne    6f8 <strtok+0x2e>
      return 0;
     6f1:	b8 00 00 00 00       	mov    $0x0,%eax
     6f6:	eb 58                	jmp    750 <strtok+0x86>
    } while (strchr(delim, ch));
     6f8:	88 d8                	mov    %bl,%al
     6fa:	0f be c0             	movsbl %al,%eax
     6fd:	89 44 24 04          	mov    %eax,0x4(%esp)
     701:	8b 45 0c             	mov    0xc(%ebp),%eax
     704:	89 04 24             	mov    %eax,(%esp)
     707:	e8 7e fe ff ff       	call   58a <strchr>
     70c:	85 c0                	test   %eax,%eax
     70e:	75 cf                	jne    6df <strtok+0x15>
    --s;
     710:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     713:	8b 45 0c             	mov    0xc(%ebp),%eax
     716:	89 44 24 04          	mov    %eax,0x4(%esp)
     71a:	8b 45 08             	mov    0x8(%ebp),%eax
     71d:	89 04 24             	mov    %eax,(%esp)
     720:	e8 31 00 00 00       	call   756 <strcspn>
     725:	89 c2                	mov    %eax,%edx
     727:	8b 45 08             	mov    0x8(%ebp),%eax
     72a:	01 d0                	add    %edx,%eax
     72c:	a3 54 15 00 00       	mov    %eax,0x1554
    if (*lasts != 0)
     731:	a1 54 15 00 00       	mov    0x1554,%eax
     736:	8a 00                	mov    (%eax),%al
     738:	84 c0                	test   %al,%al
     73a:	74 11                	je     74d <strtok+0x83>
  *lasts++ = 0;
     73c:	a1 54 15 00 00       	mov    0x1554,%eax
     741:	8d 50 01             	lea    0x1(%eax),%edx
     744:	89 15 54 15 00 00    	mov    %edx,0x1554
     74a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     74d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     750:	83 c4 14             	add    $0x14,%esp
     753:	5b                   	pop    %ebx
     754:	5d                   	pop    %ebp
     755:	c3                   	ret    

00000756 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     756:	55                   	push   %ebp
     757:	89 e5                	mov    %esp,%ebp
     759:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     75c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     763:	eb 26                	jmp    78b <strcspn+0x35>
        if(strchr(s2,*s1))
     765:	8b 45 08             	mov    0x8(%ebp),%eax
     768:	8a 00                	mov    (%eax),%al
     76a:	0f be c0             	movsbl %al,%eax
     76d:	89 44 24 04          	mov    %eax,0x4(%esp)
     771:	8b 45 0c             	mov    0xc(%ebp),%eax
     774:	89 04 24             	mov    %eax,(%esp)
     777:	e8 0e fe ff ff       	call   58a <strchr>
     77c:	85 c0                	test   %eax,%eax
     77e:	74 05                	je     785 <strcspn+0x2f>
            return ret;
     780:	8b 45 fc             	mov    -0x4(%ebp),%eax
     783:	eb 12                	jmp    797 <strcspn+0x41>
        else
            s1++,ret++;
     785:	ff 45 08             	incl   0x8(%ebp)
     788:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     78b:	8b 45 08             	mov    0x8(%ebp),%eax
     78e:	8a 00                	mov    (%eax),%al
     790:	84 c0                	test   %al,%al
     792:	75 d1                	jne    765 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     794:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     797:	c9                   	leave  
     798:	c3                   	ret    

00000799 <isspace>:

int
isspace(unsigned char c)
{
     799:	55                   	push   %ebp
     79a:	89 e5                	mov    %esp,%ebp
     79c:	83 ec 04             	sub    $0x4,%esp
     79f:	8b 45 08             	mov    0x8(%ebp),%eax
     7a2:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     7a5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     7a9:	74 1e                	je     7c9 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     7ab:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     7af:	74 18                	je     7c9 <isspace+0x30>
     7b1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     7b5:	74 12                	je     7c9 <isspace+0x30>
     7b7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     7bb:	74 0c                	je     7c9 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     7bd:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     7c1:	74 06                	je     7c9 <isspace+0x30>
     7c3:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     7c7:	75 07                	jne    7d0 <isspace+0x37>
     7c9:	b8 01 00 00 00       	mov    $0x1,%eax
     7ce:	eb 05                	jmp    7d5 <isspace+0x3c>
     7d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7d5:	c9                   	leave  
     7d6:	c3                   	ret    

000007d7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     7d7:	55                   	push   %ebp
     7d8:	89 e5                	mov    %esp,%ebp
     7da:	57                   	push   %edi
     7db:	56                   	push   %esi
     7dc:	53                   	push   %ebx
     7dd:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     7e0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     7e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     7ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     7ef:	eb 01                	jmp    7f2 <strtoul+0x1b>
  p += 1;
     7f1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     7f2:	8a 03                	mov    (%ebx),%al
     7f4:	0f b6 c0             	movzbl %al,%eax
     7f7:	89 04 24             	mov    %eax,(%esp)
     7fa:	e8 9a ff ff ff       	call   799 <isspace>
     7ff:	85 c0                	test   %eax,%eax
     801:	75 ee                	jne    7f1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     803:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     807:	75 30                	jne    839 <strtoul+0x62>
    {
  if (*p == '0') {
     809:	8a 03                	mov    (%ebx),%al
     80b:	3c 30                	cmp    $0x30,%al
     80d:	75 21                	jne    830 <strtoul+0x59>
      p += 1;
     80f:	43                   	inc    %ebx
      if (*p == 'x') {
     810:	8a 03                	mov    (%ebx),%al
     812:	3c 78                	cmp    $0x78,%al
     814:	75 0a                	jne    820 <strtoul+0x49>
    p += 1;
     816:	43                   	inc    %ebx
    base = 16;
     817:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     81e:	eb 31                	jmp    851 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     820:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     827:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     82e:	eb 21                	jmp    851 <strtoul+0x7a>
      }
  }
  else base = 10;
     830:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     837:	eb 18                	jmp    851 <strtoul+0x7a>
    } else if (base == 16) {
     839:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     83d:	75 12                	jne    851 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     83f:	8a 03                	mov    (%ebx),%al
     841:	3c 30                	cmp    $0x30,%al
     843:	75 0c                	jne    851 <strtoul+0x7a>
     845:	8d 43 01             	lea    0x1(%ebx),%eax
     848:	8a 00                	mov    (%eax),%al
     84a:	3c 78                	cmp    $0x78,%al
     84c:	75 03                	jne    851 <strtoul+0x7a>
      p += 2;
     84e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     851:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     855:	75 29                	jne    880 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     857:	8a 03                	mov    (%ebx),%al
     859:	0f be c0             	movsbl %al,%eax
     85c:	83 e8 30             	sub    $0x30,%eax
     85f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     861:	83 fe 07             	cmp    $0x7,%esi
     864:	76 06                	jbe    86c <strtoul+0x95>
    break;
     866:	90                   	nop
     867:	e9 b6 00 00 00       	jmp    922 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     86c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     873:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     876:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     87d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     87e:	eb d7                	jmp    857 <strtoul+0x80>
    } else if (base == 10) {
     880:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     884:	75 2b                	jne    8b1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     886:	8a 03                	mov    (%ebx),%al
     888:	0f be c0             	movsbl %al,%eax
     88b:	83 e8 30             	sub    $0x30,%eax
     88e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     890:	83 fe 09             	cmp    $0x9,%esi
     893:	76 06                	jbe    89b <strtoul+0xc4>
    break;
     895:	90                   	nop
     896:	e9 87 00 00 00       	jmp    922 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     89b:	89 f8                	mov    %edi,%eax
     89d:	c1 e0 02             	shl    $0x2,%eax
     8a0:	01 f8                	add    %edi,%eax
     8a2:	01 c0                	add    %eax,%eax
     8a4:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     8a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     8ae:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     8af:	eb d5                	jmp    886 <strtoul+0xaf>
    } else if (base == 16) {
     8b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     8b5:	75 35                	jne    8ec <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     8b7:	8a 03                	mov    (%ebx),%al
     8b9:	0f be c0             	movsbl %al,%eax
     8bc:	83 e8 30             	sub    $0x30,%eax
     8bf:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8c1:	83 fe 4a             	cmp    $0x4a,%esi
     8c4:	76 02                	jbe    8c8 <strtoul+0xf1>
    break;
     8c6:	eb 22                	jmp    8ea <strtoul+0x113>
      }
      digit = cvtIn[digit];
     8c8:	8a 86 e0 14 00 00    	mov    0x14e0(%esi),%al
     8ce:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     8d1:	83 fe 0f             	cmp    $0xf,%esi
     8d4:	76 02                	jbe    8d8 <strtoul+0x101>
    break;
     8d6:	eb 12                	jmp    8ea <strtoul+0x113>
      }
      result = (result << 4) + digit;
     8d8:	89 f8                	mov    %edi,%eax
     8da:	c1 e0 04             	shl    $0x4,%eax
     8dd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     8e0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     8e7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     8e8:	eb cd                	jmp    8b7 <strtoul+0xe0>
     8ea:	eb 36                	jmp    922 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     8ec:	8a 03                	mov    (%ebx),%al
     8ee:	0f be c0             	movsbl %al,%eax
     8f1:	83 e8 30             	sub    $0x30,%eax
     8f4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     8f6:	83 fe 4a             	cmp    $0x4a,%esi
     8f9:	76 02                	jbe    8fd <strtoul+0x126>
    break;
     8fb:	eb 25                	jmp    922 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     8fd:	8a 86 e0 14 00 00    	mov    0x14e0(%esi),%al
     903:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     906:	8b 45 10             	mov    0x10(%ebp),%eax
     909:	39 f0                	cmp    %esi,%eax
     90b:	77 02                	ja     90f <strtoul+0x138>
    break;
     90d:	eb 13                	jmp    922 <strtoul+0x14b>
      }
      result = result*base + digit;
     90f:	8b 45 10             	mov    0x10(%ebp),%eax
     912:	0f af c7             	imul   %edi,%eax
     915:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     918:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     91f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     920:	eb ca                	jmp    8ec <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     922:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     926:	75 03                	jne    92b <strtoul+0x154>
  p = string;
     928:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     92b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     92f:	74 05                	je     936 <strtoul+0x15f>
  *endPtr = p;
     931:	8b 45 0c             	mov    0xc(%ebp),%eax
     934:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     936:	89 f8                	mov    %edi,%eax
}
     938:	83 c4 14             	add    $0x14,%esp
     93b:	5b                   	pop    %ebx
     93c:	5e                   	pop    %esi
     93d:	5f                   	pop    %edi
     93e:	5d                   	pop    %ebp
     93f:	c3                   	ret    

00000940 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     940:	55                   	push   %ebp
     941:	89 e5                	mov    %esp,%ebp
     943:	53                   	push   %ebx
     944:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     947:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     94a:	eb 01                	jmp    94d <strtol+0xd>
      p += 1;
     94c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     94d:	8a 03                	mov    (%ebx),%al
     94f:	0f b6 c0             	movzbl %al,%eax
     952:	89 04 24             	mov    %eax,(%esp)
     955:	e8 3f fe ff ff       	call   799 <isspace>
     95a:	85 c0                	test   %eax,%eax
     95c:	75 ee                	jne    94c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     95e:	8a 03                	mov    (%ebx),%al
     960:	3c 2d                	cmp    $0x2d,%al
     962:	75 1e                	jne    982 <strtol+0x42>
  p += 1;
     964:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     965:	8b 45 10             	mov    0x10(%ebp),%eax
     968:	89 44 24 08          	mov    %eax,0x8(%esp)
     96c:	8b 45 0c             	mov    0xc(%ebp),%eax
     96f:	89 44 24 04          	mov    %eax,0x4(%esp)
     973:	89 1c 24             	mov    %ebx,(%esp)
     976:	e8 5c fe ff ff       	call   7d7 <strtoul>
     97b:	f7 d8                	neg    %eax
     97d:	89 45 f8             	mov    %eax,-0x8(%ebp)
     980:	eb 20                	jmp    9a2 <strtol+0x62>
    } else {
  if (*p == '+') {
     982:	8a 03                	mov    (%ebx),%al
     984:	3c 2b                	cmp    $0x2b,%al
     986:	75 01                	jne    989 <strtol+0x49>
      p += 1;
     988:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     989:	8b 45 10             	mov    0x10(%ebp),%eax
     98c:	89 44 24 08          	mov    %eax,0x8(%esp)
     990:	8b 45 0c             	mov    0xc(%ebp),%eax
     993:	89 44 24 04          	mov    %eax,0x4(%esp)
     997:	89 1c 24             	mov    %ebx,(%esp)
     99a:	e8 38 fe ff ff       	call   7d7 <strtoul>
     99f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     9a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     9a6:	75 17                	jne    9bf <strtol+0x7f>
     9a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     9ac:	74 11                	je     9bf <strtol+0x7f>
     9ae:	8b 45 0c             	mov    0xc(%ebp),%eax
     9b1:	8b 00                	mov    (%eax),%eax
     9b3:	39 d8                	cmp    %ebx,%eax
     9b5:	75 08                	jne    9bf <strtol+0x7f>
  *endPtr = string;
     9b7:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ba:	8b 55 08             	mov    0x8(%ebp),%edx
     9bd:	89 10                	mov    %edx,(%eax)
    }
    return result;
     9bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     9c2:	83 c4 1c             	add    $0x1c,%esp
     9c5:	5b                   	pop    %ebx
     9c6:	5d                   	pop    %ebp
     9c7:	c3                   	ret    

000009c8 <gets>:

char*
gets(char *buf, int max)
{
     9c8:	55                   	push   %ebp
     9c9:	89 e5                	mov    %esp,%ebp
     9cb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     9ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9d5:	eb 49                	jmp    a20 <gets+0x58>
    cc = read(0, &c, 1);
     9d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     9de:	00 
     9df:	8d 45 ef             	lea    -0x11(%ebp),%eax
     9e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     9ed:	e8 3e 01 00 00       	call   b30 <read>
     9f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     9f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     9f9:	7f 02                	jg     9fd <gets+0x35>
      break;
     9fb:	eb 2c                	jmp    a29 <gets+0x61>
    buf[i++] = c;
     9fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a00:	8d 50 01             	lea    0x1(%eax),%edx
     a03:	89 55 f4             	mov    %edx,-0xc(%ebp)
     a06:	89 c2                	mov    %eax,%edx
     a08:	8b 45 08             	mov    0x8(%ebp),%eax
     a0b:	01 c2                	add    %eax,%edx
     a0d:	8a 45 ef             	mov    -0x11(%ebp),%al
     a10:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     a12:	8a 45 ef             	mov    -0x11(%ebp),%al
     a15:	3c 0a                	cmp    $0xa,%al
     a17:	74 10                	je     a29 <gets+0x61>
     a19:	8a 45 ef             	mov    -0x11(%ebp),%al
     a1c:	3c 0d                	cmp    $0xd,%al
     a1e:	74 09                	je     a29 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a23:	40                   	inc    %eax
     a24:	3b 45 0c             	cmp    0xc(%ebp),%eax
     a27:	7c ae                	jl     9d7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a2c:	8b 45 08             	mov    0x8(%ebp),%eax
     a2f:	01 d0                	add    %edx,%eax
     a31:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     a34:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a37:	c9                   	leave  
     a38:	c3                   	ret    

00000a39 <stat>:

int
stat(char *n, struct stat *st)
{
     a39:	55                   	push   %ebp
     a3a:	89 e5                	mov    %esp,%ebp
     a3c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a3f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     a46:	00 
     a47:	8b 45 08             	mov    0x8(%ebp),%eax
     a4a:	89 04 24             	mov    %eax,(%esp)
     a4d:	e8 06 01 00 00       	call   b58 <open>
     a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     a59:	79 07                	jns    a62 <stat+0x29>
    return -1;
     a5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     a60:	eb 23                	jmp    a85 <stat+0x4c>
  r = fstat(fd, st);
     a62:	8b 45 0c             	mov    0xc(%ebp),%eax
     a65:	89 44 24 04          	mov    %eax,0x4(%esp)
     a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a6c:	89 04 24             	mov    %eax,(%esp)
     a6f:	e8 fc 00 00 00       	call   b70 <fstat>
     a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a7a:	89 04 24             	mov    %eax,(%esp)
     a7d:	e8 be 00 00 00       	call   b40 <close>
  return r;
     a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     a85:	c9                   	leave  
     a86:	c3                   	ret    

00000a87 <atoi>:

int
atoi(const char *s)
{
     a87:	55                   	push   %ebp
     a88:	89 e5                	mov    %esp,%ebp
     a8a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     a8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     a94:	eb 24                	jmp    aba <atoi+0x33>
    n = n*10 + *s++ - '0';
     a96:	8b 55 fc             	mov    -0x4(%ebp),%edx
     a99:	89 d0                	mov    %edx,%eax
     a9b:	c1 e0 02             	shl    $0x2,%eax
     a9e:	01 d0                	add    %edx,%eax
     aa0:	01 c0                	add    %eax,%eax
     aa2:	89 c1                	mov    %eax,%ecx
     aa4:	8b 45 08             	mov    0x8(%ebp),%eax
     aa7:	8d 50 01             	lea    0x1(%eax),%edx
     aaa:	89 55 08             	mov    %edx,0x8(%ebp)
     aad:	8a 00                	mov    (%eax),%al
     aaf:	0f be c0             	movsbl %al,%eax
     ab2:	01 c8                	add    %ecx,%eax
     ab4:	83 e8 30             	sub    $0x30,%eax
     ab7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     aba:	8b 45 08             	mov    0x8(%ebp),%eax
     abd:	8a 00                	mov    (%eax),%al
     abf:	3c 2f                	cmp    $0x2f,%al
     ac1:	7e 09                	jle    acc <atoi+0x45>
     ac3:	8b 45 08             	mov    0x8(%ebp),%eax
     ac6:	8a 00                	mov    (%eax),%al
     ac8:	3c 39                	cmp    $0x39,%al
     aca:	7e ca                	jle    a96 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     acc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     acf:	c9                   	leave  
     ad0:	c3                   	ret    

00000ad1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     ad1:	55                   	push   %ebp
     ad2:	89 e5                	mov    %esp,%ebp
     ad4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     ad7:	8b 45 08             	mov    0x8(%ebp),%eax
     ada:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     add:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     ae3:	eb 16                	jmp    afb <memmove+0x2a>
    *dst++ = *src++;
     ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ae8:	8d 50 01             	lea    0x1(%eax),%edx
     aeb:	89 55 fc             	mov    %edx,-0x4(%ebp)
     aee:	8b 55 f8             	mov    -0x8(%ebp),%edx
     af1:	8d 4a 01             	lea    0x1(%edx),%ecx
     af4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     af7:	8a 12                	mov    (%edx),%dl
     af9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     afb:	8b 45 10             	mov    0x10(%ebp),%eax
     afe:	8d 50 ff             	lea    -0x1(%eax),%edx
     b01:	89 55 10             	mov    %edx,0x10(%ebp)
     b04:	85 c0                	test   %eax,%eax
     b06:	7f dd                	jg     ae5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     b08:	8b 45 08             	mov    0x8(%ebp),%eax
}
     b0b:	c9                   	leave  
     b0c:	c3                   	ret    
     b0d:	90                   	nop
     b0e:	90                   	nop
     b0f:	90                   	nop

00000b10 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     b10:	b8 01 00 00 00       	mov    $0x1,%eax
     b15:	cd 40                	int    $0x40
     b17:	c3                   	ret    

00000b18 <exit>:
SYSCALL(exit)
     b18:	b8 02 00 00 00       	mov    $0x2,%eax
     b1d:	cd 40                	int    $0x40
     b1f:	c3                   	ret    

00000b20 <wait>:
SYSCALL(wait)
     b20:	b8 03 00 00 00       	mov    $0x3,%eax
     b25:	cd 40                	int    $0x40
     b27:	c3                   	ret    

00000b28 <pipe>:
SYSCALL(pipe)
     b28:	b8 04 00 00 00       	mov    $0x4,%eax
     b2d:	cd 40                	int    $0x40
     b2f:	c3                   	ret    

00000b30 <read>:
SYSCALL(read)
     b30:	b8 05 00 00 00       	mov    $0x5,%eax
     b35:	cd 40                	int    $0x40
     b37:	c3                   	ret    

00000b38 <write>:
SYSCALL(write)
     b38:	b8 10 00 00 00       	mov    $0x10,%eax
     b3d:	cd 40                	int    $0x40
     b3f:	c3                   	ret    

00000b40 <close>:
SYSCALL(close)
     b40:	b8 15 00 00 00       	mov    $0x15,%eax
     b45:	cd 40                	int    $0x40
     b47:	c3                   	ret    

00000b48 <kill>:
SYSCALL(kill)
     b48:	b8 06 00 00 00       	mov    $0x6,%eax
     b4d:	cd 40                	int    $0x40
     b4f:	c3                   	ret    

00000b50 <exec>:
SYSCALL(exec)
     b50:	b8 07 00 00 00       	mov    $0x7,%eax
     b55:	cd 40                	int    $0x40
     b57:	c3                   	ret    

00000b58 <open>:
SYSCALL(open)
     b58:	b8 0f 00 00 00       	mov    $0xf,%eax
     b5d:	cd 40                	int    $0x40
     b5f:	c3                   	ret    

00000b60 <mknod>:
SYSCALL(mknod)
     b60:	b8 11 00 00 00       	mov    $0x11,%eax
     b65:	cd 40                	int    $0x40
     b67:	c3                   	ret    

00000b68 <unlink>:
SYSCALL(unlink)
     b68:	b8 12 00 00 00       	mov    $0x12,%eax
     b6d:	cd 40                	int    $0x40
     b6f:	c3                   	ret    

00000b70 <fstat>:
SYSCALL(fstat)
     b70:	b8 08 00 00 00       	mov    $0x8,%eax
     b75:	cd 40                	int    $0x40
     b77:	c3                   	ret    

00000b78 <link>:
SYSCALL(link)
     b78:	b8 13 00 00 00       	mov    $0x13,%eax
     b7d:	cd 40                	int    $0x40
     b7f:	c3                   	ret    

00000b80 <mkdir>:
SYSCALL(mkdir)
     b80:	b8 14 00 00 00       	mov    $0x14,%eax
     b85:	cd 40                	int    $0x40
     b87:	c3                   	ret    

00000b88 <chdir>:
SYSCALL(chdir)
     b88:	b8 09 00 00 00       	mov    $0x9,%eax
     b8d:	cd 40                	int    $0x40
     b8f:	c3                   	ret    

00000b90 <dup>:
SYSCALL(dup)
     b90:	b8 0a 00 00 00       	mov    $0xa,%eax
     b95:	cd 40                	int    $0x40
     b97:	c3                   	ret    

00000b98 <getpid>:
SYSCALL(getpid)
     b98:	b8 0b 00 00 00       	mov    $0xb,%eax
     b9d:	cd 40                	int    $0x40
     b9f:	c3                   	ret    

00000ba0 <sbrk>:
SYSCALL(sbrk)
     ba0:	b8 0c 00 00 00       	mov    $0xc,%eax
     ba5:	cd 40                	int    $0x40
     ba7:	c3                   	ret    

00000ba8 <sleep>:
SYSCALL(sleep)
     ba8:	b8 0d 00 00 00       	mov    $0xd,%eax
     bad:	cd 40                	int    $0x40
     baf:	c3                   	ret    

00000bb0 <uptime>:
SYSCALL(uptime)
     bb0:	b8 0e 00 00 00       	mov    $0xe,%eax
     bb5:	cd 40                	int    $0x40
     bb7:	c3                   	ret    

00000bb8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     bb8:	55                   	push   %ebp
     bb9:	89 e5                	mov    %esp,%ebp
     bbb:	83 ec 18             	sub    $0x18,%esp
     bbe:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     bc4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     bcb:	00 
     bcc:	8d 45 f4             	lea    -0xc(%ebp),%eax
     bcf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bd3:	8b 45 08             	mov    0x8(%ebp),%eax
     bd6:	89 04 24             	mov    %eax,(%esp)
     bd9:	e8 5a ff ff ff       	call   b38 <write>
}
     bde:	c9                   	leave  
     bdf:	c3                   	ret    

00000be0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     be0:	55                   	push   %ebp
     be1:	89 e5                	mov    %esp,%ebp
     be3:	56                   	push   %esi
     be4:	53                   	push   %ebx
     be5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     be8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     bef:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     bf3:	74 17                	je     c0c <printint+0x2c>
     bf5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bf9:	79 11                	jns    c0c <printint+0x2c>
    neg = 1;
     bfb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     c02:	8b 45 0c             	mov    0xc(%ebp),%eax
     c05:	f7 d8                	neg    %eax
     c07:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c0a:	eb 06                	jmp    c12 <printint+0x32>
  } else {
    x = xx;
     c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     c19:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     c1c:	8d 41 01             	lea    0x1(%ecx),%eax
     c1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
     c22:	8b 5d 10             	mov    0x10(%ebp),%ebx
     c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c28:	ba 00 00 00 00       	mov    $0x0,%edx
     c2d:	f7 f3                	div    %ebx
     c2f:	89 d0                	mov    %edx,%eax
     c31:	8a 80 2c 15 00 00    	mov    0x152c(%eax),%al
     c37:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     c3b:	8b 75 10             	mov    0x10(%ebp),%esi
     c3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c41:	ba 00 00 00 00       	mov    $0x0,%edx
     c46:	f7 f6                	div    %esi
     c48:	89 45 ec             	mov    %eax,-0x14(%ebp)
     c4b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     c4f:	75 c8                	jne    c19 <printint+0x39>
  if(neg)
     c51:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c55:	74 10                	je     c67 <printint+0x87>
    buf[i++] = '-';
     c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c5a:	8d 50 01             	lea    0x1(%eax),%edx
     c5d:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c60:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     c65:	eb 1e                	jmp    c85 <printint+0xa5>
     c67:	eb 1c                	jmp    c85 <printint+0xa5>
    putc(fd, buf[i]);
     c69:	8d 55 dc             	lea    -0x24(%ebp),%edx
     c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c6f:	01 d0                	add    %edx,%eax
     c71:	8a 00                	mov    (%eax),%al
     c73:	0f be c0             	movsbl %al,%eax
     c76:	89 44 24 04          	mov    %eax,0x4(%esp)
     c7a:	8b 45 08             	mov    0x8(%ebp),%eax
     c7d:	89 04 24             	mov    %eax,(%esp)
     c80:	e8 33 ff ff ff       	call   bb8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     c85:	ff 4d f4             	decl   -0xc(%ebp)
     c88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c8c:	79 db                	jns    c69 <printint+0x89>
    putc(fd, buf[i]);
}
     c8e:	83 c4 30             	add    $0x30,%esp
     c91:	5b                   	pop    %ebx
     c92:	5e                   	pop    %esi
     c93:	5d                   	pop    %ebp
     c94:	c3                   	ret    

00000c95 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     c95:	55                   	push   %ebp
     c96:	89 e5                	mov    %esp,%ebp
     c98:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     c9b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     ca2:	8d 45 0c             	lea    0xc(%ebp),%eax
     ca5:	83 c0 04             	add    $0x4,%eax
     ca8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     cab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     cb2:	e9 77 01 00 00       	jmp    e2e <printf+0x199>
    c = fmt[i] & 0xff;
     cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
     cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cbd:	01 d0                	add    %edx,%eax
     cbf:	8a 00                	mov    (%eax),%al
     cc1:	0f be c0             	movsbl %al,%eax
     cc4:	25 ff 00 00 00       	and    $0xff,%eax
     cc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     ccc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     cd0:	75 2c                	jne    cfe <printf+0x69>
      if(c == '%'){
     cd2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     cd6:	75 0c                	jne    ce4 <printf+0x4f>
        state = '%';
     cd8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     cdf:	e9 47 01 00 00       	jmp    e2b <printf+0x196>
      } else {
        putc(fd, c);
     ce4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ce7:	0f be c0             	movsbl %al,%eax
     cea:	89 44 24 04          	mov    %eax,0x4(%esp)
     cee:	8b 45 08             	mov    0x8(%ebp),%eax
     cf1:	89 04 24             	mov    %eax,(%esp)
     cf4:	e8 bf fe ff ff       	call   bb8 <putc>
     cf9:	e9 2d 01 00 00       	jmp    e2b <printf+0x196>
      }
    } else if(state == '%'){
     cfe:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     d02:	0f 85 23 01 00 00    	jne    e2b <printf+0x196>
      if(c == 'd'){
     d08:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     d0c:	75 2d                	jne    d3b <printf+0xa6>
        printint(fd, *ap, 10, 1);
     d0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d11:	8b 00                	mov    (%eax),%eax
     d13:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     d1a:	00 
     d1b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     d22:	00 
     d23:	89 44 24 04          	mov    %eax,0x4(%esp)
     d27:	8b 45 08             	mov    0x8(%ebp),%eax
     d2a:	89 04 24             	mov    %eax,(%esp)
     d2d:	e8 ae fe ff ff       	call   be0 <printint>
        ap++;
     d32:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d36:	e9 e9 00 00 00       	jmp    e24 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
     d3b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     d3f:	74 06                	je     d47 <printf+0xb2>
     d41:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     d45:	75 2d                	jne    d74 <printf+0xdf>
        printint(fd, *ap, 16, 0);
     d47:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d4a:	8b 00                	mov    (%eax),%eax
     d4c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     d53:	00 
     d54:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     d5b:	00 
     d5c:	89 44 24 04          	mov    %eax,0x4(%esp)
     d60:	8b 45 08             	mov    0x8(%ebp),%eax
     d63:	89 04 24             	mov    %eax,(%esp)
     d66:	e8 75 fe ff ff       	call   be0 <printint>
        ap++;
     d6b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     d6f:	e9 b0 00 00 00       	jmp    e24 <printf+0x18f>
      } else if(c == 's'){
     d74:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     d78:	75 42                	jne    dbc <printf+0x127>
        s = (char*)*ap;
     d7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d7d:	8b 00                	mov    (%eax),%eax
     d7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     d82:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     d86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     d8a:	75 09                	jne    d95 <printf+0x100>
          s = "(null)";
     d8c:	c7 45 f4 ed 10 00 00 	movl   $0x10ed,-0xc(%ebp)
        while(*s != 0){
     d93:	eb 1c                	jmp    db1 <printf+0x11c>
     d95:	eb 1a                	jmp    db1 <printf+0x11c>
          putc(fd, *s);
     d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d9a:	8a 00                	mov    (%eax),%al
     d9c:	0f be c0             	movsbl %al,%eax
     d9f:	89 44 24 04          	mov    %eax,0x4(%esp)
     da3:	8b 45 08             	mov    0x8(%ebp),%eax
     da6:	89 04 24             	mov    %eax,(%esp)
     da9:	e8 0a fe ff ff       	call   bb8 <putc>
          s++;
     dae:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     db4:	8a 00                	mov    (%eax),%al
     db6:	84 c0                	test   %al,%al
     db8:	75 dd                	jne    d97 <printf+0x102>
     dba:	eb 68                	jmp    e24 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     dbc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     dc0:	75 1d                	jne    ddf <printf+0x14a>
        putc(fd, *ap);
     dc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dc5:	8b 00                	mov    (%eax),%eax
     dc7:	0f be c0             	movsbl %al,%eax
     dca:	89 44 24 04          	mov    %eax,0x4(%esp)
     dce:	8b 45 08             	mov    0x8(%ebp),%eax
     dd1:	89 04 24             	mov    %eax,(%esp)
     dd4:	e8 df fd ff ff       	call   bb8 <putc>
        ap++;
     dd9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     ddd:	eb 45                	jmp    e24 <printf+0x18f>
      } else if(c == '%'){
     ddf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     de3:	75 17                	jne    dfc <printf+0x167>
        putc(fd, c);
     de5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     de8:	0f be c0             	movsbl %al,%eax
     deb:	89 44 24 04          	mov    %eax,0x4(%esp)
     def:	8b 45 08             	mov    0x8(%ebp),%eax
     df2:	89 04 24             	mov    %eax,(%esp)
     df5:	e8 be fd ff ff       	call   bb8 <putc>
     dfa:	eb 28                	jmp    e24 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     dfc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
     e03:	00 
     e04:	8b 45 08             	mov    0x8(%ebp),%eax
     e07:	89 04 24             	mov    %eax,(%esp)
     e0a:	e8 a9 fd ff ff       	call   bb8 <putc>
        putc(fd, c);
     e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e12:	0f be c0             	movsbl %al,%eax
     e15:	89 44 24 04          	mov    %eax,0x4(%esp)
     e19:	8b 45 08             	mov    0x8(%ebp),%eax
     e1c:	89 04 24             	mov    %eax,(%esp)
     e1f:	e8 94 fd ff ff       	call   bb8 <putc>
      }
      state = 0;
     e24:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     e2b:	ff 45 f0             	incl   -0x10(%ebp)
     e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
     e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e34:	01 d0                	add    %edx,%eax
     e36:	8a 00                	mov    (%eax),%al
     e38:	84 c0                	test   %al,%al
     e3a:	0f 85 77 fe ff ff    	jne    cb7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
     e40:	c9                   	leave  
     e41:	c3                   	ret    
     e42:	90                   	nop
     e43:	90                   	nop

00000e44 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     e44:	55                   	push   %ebp
     e45:	89 e5                	mov    %esp,%ebp
     e47:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
     e4a:	8b 45 08             	mov    0x8(%ebp),%eax
     e4d:	83 e8 08             	sub    $0x8,%eax
     e50:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e53:	a1 60 15 00 00       	mov    0x1560,%eax
     e58:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e5b:	eb 24                	jmp    e81 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e60:	8b 00                	mov    (%eax),%eax
     e62:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e65:	77 12                	ja     e79 <free+0x35>
     e67:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e6a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e6d:	77 24                	ja     e93 <free+0x4f>
     e6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e72:	8b 00                	mov    (%eax),%eax
     e74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e77:	77 1a                	ja     e93 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e7c:	8b 00                	mov    (%eax),%eax
     e7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
     e81:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e84:	3b 45 fc             	cmp    -0x4(%ebp),%eax
     e87:	76 d4                	jbe    e5d <free+0x19>
     e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
     e8c:	8b 00                	mov    (%eax),%eax
     e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     e91:	76 ca                	jbe    e5d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
     e93:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e96:	8b 40 04             	mov    0x4(%eax),%eax
     e99:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ea3:	01 c2                	add    %eax,%edx
     ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ea8:	8b 00                	mov    (%eax),%eax
     eaa:	39 c2                	cmp    %eax,%edx
     eac:	75 24                	jne    ed2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
     eae:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eb1:	8b 50 04             	mov    0x4(%eax),%edx
     eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eb7:	8b 00                	mov    (%eax),%eax
     eb9:	8b 40 04             	mov    0x4(%eax),%eax
     ebc:	01 c2                	add    %eax,%edx
     ebe:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ec1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
     ec4:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ec7:	8b 00                	mov    (%eax),%eax
     ec9:	8b 10                	mov    (%eax),%edx
     ecb:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ece:	89 10                	mov    %edx,(%eax)
     ed0:	eb 0a                	jmp    edc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
     ed2:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ed5:	8b 10                	mov    (%eax),%edx
     ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
     eda:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
     edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     edf:	8b 40 04             	mov    0x4(%eax),%eax
     ee2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
     ee9:	8b 45 fc             	mov    -0x4(%ebp),%eax
     eec:	01 d0                	add    %edx,%eax
     eee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
     ef1:	75 20                	jne    f13 <free+0xcf>
    p->s.size += bp->s.size;
     ef3:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ef6:	8b 50 04             	mov    0x4(%eax),%edx
     ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
     efc:	8b 40 04             	mov    0x4(%eax),%eax
     eff:	01 c2                	add    %eax,%edx
     f01:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f04:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
     f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f0a:	8b 10                	mov    (%eax),%edx
     f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f0f:	89 10                	mov    %edx,(%eax)
     f11:	eb 08                	jmp    f1b <free+0xd7>
  } else
    p->s.ptr = bp;
     f13:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f16:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f19:	89 10                	mov    %edx,(%eax)
  freep = p;
     f1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f1e:	a3 60 15 00 00       	mov    %eax,0x1560
}
     f23:	c9                   	leave  
     f24:	c3                   	ret    

00000f25 <morecore>:

static Header*
morecore(uint nu)
{
     f25:	55                   	push   %ebp
     f26:	89 e5                	mov    %esp,%ebp
     f28:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
     f2b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
     f32:	77 07                	ja     f3b <morecore+0x16>
    nu = 4096;
     f34:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
     f3b:	8b 45 08             	mov    0x8(%ebp),%eax
     f3e:	c1 e0 03             	shl    $0x3,%eax
     f41:	89 04 24             	mov    %eax,(%esp)
     f44:	e8 57 fc ff ff       	call   ba0 <sbrk>
     f49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
     f4c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     f50:	75 07                	jne    f59 <morecore+0x34>
    return 0;
     f52:	b8 00 00 00 00       	mov    $0x0,%eax
     f57:	eb 22                	jmp    f7b <morecore+0x56>
  hp = (Header*)p;
     f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
     f5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f62:	8b 55 08             	mov    0x8(%ebp),%edx
     f65:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
     f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f6b:	83 c0 08             	add    $0x8,%eax
     f6e:	89 04 24             	mov    %eax,(%esp)
     f71:	e8 ce fe ff ff       	call   e44 <free>
  return freep;
     f76:	a1 60 15 00 00       	mov    0x1560,%eax
}
     f7b:	c9                   	leave  
     f7c:	c3                   	ret    

00000f7d <malloc>:

void*
malloc(uint nbytes)
{
     f7d:	55                   	push   %ebp
     f7e:	89 e5                	mov    %esp,%ebp
     f80:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     f83:	8b 45 08             	mov    0x8(%ebp),%eax
     f86:	83 c0 07             	add    $0x7,%eax
     f89:	c1 e8 03             	shr    $0x3,%eax
     f8c:	40                   	inc    %eax
     f8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
     f90:	a1 60 15 00 00       	mov    0x1560,%eax
     f95:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f9c:	75 23                	jne    fc1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
     f9e:	c7 45 f0 58 15 00 00 	movl   $0x1558,-0x10(%ebp)
     fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fa8:	a3 60 15 00 00       	mov    %eax,0x1560
     fad:	a1 60 15 00 00       	mov    0x1560,%eax
     fb2:	a3 58 15 00 00       	mov    %eax,0x1558
    base.s.size = 0;
     fb7:	c7 05 5c 15 00 00 00 	movl   $0x0,0x155c
     fbe:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
     fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fc4:	8b 00                	mov    (%eax),%eax
     fc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
     fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fcc:	8b 40 04             	mov    0x4(%eax),%eax
     fcf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fd2:	72 4d                	jb     1021 <malloc+0xa4>
      if(p->s.size == nunits)
     fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fd7:	8b 40 04             	mov    0x4(%eax),%eax
     fda:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     fdd:	75 0c                	jne    feb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
     fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fe2:	8b 10                	mov    (%eax),%edx
     fe4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     fe7:	89 10                	mov    %edx,(%eax)
     fe9:	eb 26                	jmp    1011 <malloc+0x94>
      else {
        p->s.size -= nunits;
     feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fee:	8b 40 04             	mov    0x4(%eax),%eax
     ff1:	2b 45 ec             	sub    -0x14(%ebp),%eax
     ff4:	89 c2                	mov    %eax,%edx
     ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ff9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
     ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fff:	8b 40 04             	mov    0x4(%eax),%eax
    1002:	c1 e0 03             	shl    $0x3,%eax
    1005:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1008:	8b 45 f4             	mov    -0xc(%ebp),%eax
    100b:	8b 55 ec             	mov    -0x14(%ebp),%edx
    100e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1011:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1014:	a3 60 15 00 00       	mov    %eax,0x1560
      return (void*)(p + 1);
    1019:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101c:	83 c0 08             	add    $0x8,%eax
    101f:	eb 38                	jmp    1059 <malloc+0xdc>
    }
    if(p == freep)
    1021:	a1 60 15 00 00       	mov    0x1560,%eax
    1026:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1029:	75 1b                	jne    1046 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    102b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    102e:	89 04 24             	mov    %eax,(%esp)
    1031:	e8 ef fe ff ff       	call   f25 <morecore>
    1036:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    103d:	75 07                	jne    1046 <malloc+0xc9>
        return 0;
    103f:	b8 00 00 00 00       	mov    $0x0,%eax
    1044:	eb 13                	jmp    1059 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1046:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1049:	89 45 f0             	mov    %eax,-0x10(%ebp)
    104c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    104f:	8b 00                	mov    (%eax),%eax
    1051:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1054:	e9 70 ff ff ff       	jmp    fc9 <malloc+0x4c>
}
    1059:	c9                   	leave  
    105a:	c3                   	ret    
