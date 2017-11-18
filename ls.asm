
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
   d:	e8 1b 04 00 00       	call   42d <strlen>
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
  39:	e8 ef 03 00 00       	call   42d <strlen>
  3e:	83 f8 0d             	cmp    $0xd,%eax
  41:	76 05                	jbe    48 <fmtname+0x48>
    return p;
  43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  46:	eb 5f                	jmp    a7 <fmtname+0xa7>
  memmove(buf, p, strlen(p));
  48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4b:	89 04 24             	mov    %eax,(%esp)
  4e:	e8 da 03 00 00       	call   42d <strlen>
  53:	89 44 24 08          	mov    %eax,0x8(%esp)
  57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  5e:	c7 04 24 c0 13 00 00 	movl   $0x13c0,(%esp)
  65:	e8 53 09 00 00       	call   9bd <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  6d:	89 04 24             	mov    %eax,(%esp)
  70:	e8 b8 03 00 00       	call   42d <strlen>
  75:	ba 0e 00 00 00       	mov    $0xe,%edx
  7a:	89 d3                	mov    %edx,%ebx
  7c:	29 c3                	sub    %eax,%ebx
  7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  81:	89 04 24             	mov    %eax,(%esp)
  84:	e8 a4 03 00 00       	call   42d <strlen>
  89:	05 c0 13 00 00       	add    $0x13c0,%eax
  8e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  92:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  99:	00 
  9a:	89 04 24             	mov    %eax,(%esp)
  9d:	e8 b0 03 00 00       	call   452 <memset>
  return buf;
  a2:	b8 c0 13 00 00       	mov    $0x13c0,%eax
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
  c7:	e8 78 09 00 00       	call   a44 <open>
  cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  cf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d3:	79 20                	jns    f5 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d5:	8b 45 08             	mov    0x8(%ebp),%eax
  d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  dc:	c7 44 24 04 47 0f 00 	movl   $0xf47,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  eb:	e8 91 0a 00 00       	call   b81 <printf>
    return;
  f0:	e9 fd 01 00 00       	jmp    2f2 <ls+0x245>
  }

  if(fstat(fd, &st) < 0){
  f5:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 102:	89 04 24             	mov    %eax,(%esp)
 105:	e8 52 09 00 00       	call   a5c <fstat>
 10a:	85 c0                	test   %eax,%eax
 10c:	79 2b                	jns    139 <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 10e:	8b 45 08             	mov    0x8(%ebp),%eax
 111:	89 44 24 08          	mov    %eax,0x8(%esp)
 115:	c7 44 24 04 5b 0f 00 	movl   $0xf5b,0x4(%esp)
 11c:	00 
 11d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 124:	e8 58 0a 00 00       	call   b81 <printf>
    close(fd);
 129:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12c:	89 04 24             	mov    %eax,(%esp)
 12f:	e8 f8 08 00 00       	call   a2c <close>
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
 17e:	c7 44 24 04 6f 0f 00 	movl   $0xf6f,0x4(%esp)
 185:	00 
 186:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18d:	e8 ef 09 00 00       	call   b81 <printf>
    break;
 192:	e9 50 01 00 00       	jmp    2e7 <ls+0x23a>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 197:	8b 45 08             	mov    0x8(%ebp),%eax
 19a:	89 04 24             	mov    %eax,(%esp)
 19d:	e8 8b 02 00 00       	call   42d <strlen>
 1a2:	83 c0 10             	add    $0x10,%eax
 1a5:	3d 00 02 00 00       	cmp    $0x200,%eax
 1aa:	76 19                	jbe    1c5 <ls+0x118>
      printf(1, "ls: path too long\n");
 1ac:	c7 44 24 04 7c 0f 00 	movl   $0xf7c,0x4(%esp)
 1b3:	00 
 1b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bb:	e8 c1 09 00 00       	call   b81 <printf>
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
 1e3:	e8 45 02 00 00       	call   42d <strlen>
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
 22f:	e8 89 07 00 00       	call   9bd <memmove>
      p[DIRSIZ] = 0;
 234:	8b 45 e0             	mov    -0x20(%ebp),%eax
 237:	83 c0 0e             	add    $0xe,%eax
 23a:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 23d:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 24d:	89 04 24             	mov    %eax,(%esp)
 250:	e8 d0 06 00 00       	call   925 <stat>
 255:	85 c0                	test   %eax,%eax
 257:	79 20                	jns    279 <ls+0x1cc>
        printf(1, "ls: cannot stat %s\n", buf);
 259:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 25f:	89 44 24 08          	mov    %eax,0x8(%esp)
 263:	c7 44 24 04 5b 0f 00 	movl   $0xf5b,0x4(%esp)
 26a:	00 
 26b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 272:	e8 0a 09 00 00       	call   b81 <printf>
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
 2ac:	c7 44 24 04 6f 0f 00 	movl   $0xf6f,0x4(%esp)
 2b3:	00 
 2b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2bb:	e8 c1 08 00 00       	call   b81 <printf>
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
 2d8:	e8 3f 07 00 00       	call   a1c <read>
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
 2ed:	e8 3a 07 00 00       	call   a2c <close>
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
 30c:	c7 04 24 8f 0f 00 00 	movl   $0xf8f,(%esp)
 313:	e8 95 fd ff ff       	call   ad <ls>
    exit();
 318:	e8 e7 06 00 00       	call   a04 <exit>
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
 34e:	e8 b1 06 00 00       	call   a04 <exit>
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

000003a7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3a7:	55                   	push   %ebp
 3a8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3aa:	eb 06                	jmp    3b2 <strcmp+0xb>
    p++, q++;
 3ac:	ff 45 08             	incl   0x8(%ebp)
 3af:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 3b2:	8b 45 08             	mov    0x8(%ebp),%eax
 3b5:	8a 00                	mov    (%eax),%al
 3b7:	84 c0                	test   %al,%al
 3b9:	74 0e                	je     3c9 <strcmp+0x22>
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	8a 10                	mov    (%eax),%dl
 3c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c3:	8a 00                	mov    (%eax),%al
 3c5:	38 c2                	cmp    %al,%dl
 3c7:	74 e3                	je     3ac <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 3c9:	8b 45 08             	mov    0x8(%ebp),%eax
 3cc:	8a 00                	mov    (%eax),%al
 3ce:	0f b6 d0             	movzbl %al,%edx
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	8a 00                	mov    (%eax),%al
 3d6:	0f b6 c0             	movzbl %al,%eax
 3d9:	29 c2                	sub    %eax,%edx
 3db:	89 d0                	mov    %edx,%eax
}
 3dd:	5d                   	pop    %ebp
 3de:	c3                   	ret    

000003df <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 3df:	55                   	push   %ebp
 3e0:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 3e2:	eb 09                	jmp    3ed <strncmp+0xe>
    n--, p++, q++;
 3e4:	ff 4d 10             	decl   0x10(%ebp)
 3e7:	ff 45 08             	incl   0x8(%ebp)
 3ea:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 3ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3f1:	74 17                	je     40a <strncmp+0x2b>
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	8a 00                	mov    (%eax),%al
 3f8:	84 c0                	test   %al,%al
 3fa:	74 0e                	je     40a <strncmp+0x2b>
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	8a 10                	mov    (%eax),%dl
 401:	8b 45 0c             	mov    0xc(%ebp),%eax
 404:	8a 00                	mov    (%eax),%al
 406:	38 c2                	cmp    %al,%dl
 408:	74 da                	je     3e4 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 40a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 40e:	75 07                	jne    417 <strncmp+0x38>
    return 0;
 410:	b8 00 00 00 00       	mov    $0x0,%eax
 415:	eb 14                	jmp    42b <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	8a 00                	mov    (%eax),%al
 41c:	0f b6 d0             	movzbl %al,%edx
 41f:	8b 45 0c             	mov    0xc(%ebp),%eax
 422:	8a 00                	mov    (%eax),%al
 424:	0f b6 c0             	movzbl %al,%eax
 427:	29 c2                	sub    %eax,%edx
 429:	89 d0                	mov    %edx,%eax
}
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret    

0000042d <strlen>:

uint
strlen(const char *s)
{
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp
 430:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 433:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 43a:	eb 03                	jmp    43f <strlen+0x12>
 43c:	ff 45 fc             	incl   -0x4(%ebp)
 43f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	01 d0                	add    %edx,%eax
 447:	8a 00                	mov    (%eax),%al
 449:	84 c0                	test   %al,%al
 44b:	75 ef                	jne    43c <strlen+0xf>
    ;
  return n;
 44d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 450:	c9                   	leave  
 451:	c3                   	ret    

00000452 <memset>:

void*
memset(void *dst, int c, uint n)
{
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 458:	8b 45 10             	mov    0x10(%ebp),%eax
 45b:	89 44 24 08          	mov    %eax,0x8(%esp)
 45f:	8b 45 0c             	mov    0xc(%ebp),%eax
 462:	89 44 24 04          	mov    %eax,0x4(%esp)
 466:	8b 45 08             	mov    0x8(%ebp),%eax
 469:	89 04 24             	mov    %eax,(%esp)
 46c:	e8 e3 fe ff ff       	call   354 <stosb>
  return dst;
 471:	8b 45 08             	mov    0x8(%ebp),%eax
}
 474:	c9                   	leave  
 475:	c3                   	ret    

00000476 <strchr>:

char*
strchr(const char *s, char c)
{
 476:	55                   	push   %ebp
 477:	89 e5                	mov    %esp,%ebp
 479:	83 ec 04             	sub    $0x4,%esp
 47c:	8b 45 0c             	mov    0xc(%ebp),%eax
 47f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 482:	eb 12                	jmp    496 <strchr+0x20>
    if(*s == c)
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	8a 00                	mov    (%eax),%al
 489:	3a 45 fc             	cmp    -0x4(%ebp),%al
 48c:	75 05                	jne    493 <strchr+0x1d>
      return (char*)s;
 48e:	8b 45 08             	mov    0x8(%ebp),%eax
 491:	eb 11                	jmp    4a4 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 493:	ff 45 08             	incl   0x8(%ebp)
 496:	8b 45 08             	mov    0x8(%ebp),%eax
 499:	8a 00                	mov    (%eax),%al
 49b:	84 c0                	test   %al,%al
 49d:	75 e5                	jne    484 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 49f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4a4:	c9                   	leave  
 4a5:	c3                   	ret    

000004a6 <strcat>:

char *
strcat(char *dest, const char *src)
{
 4a6:	55                   	push   %ebp
 4a7:	89 e5                	mov    %esp,%ebp
 4a9:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 4ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4b3:	eb 03                	jmp    4b8 <strcat+0x12>
 4b5:	ff 45 fc             	incl   -0x4(%ebp)
 4b8:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4bb:	8b 45 08             	mov    0x8(%ebp),%eax
 4be:	01 d0                	add    %edx,%eax
 4c0:	8a 00                	mov    (%eax),%al
 4c2:	84 c0                	test   %al,%al
 4c4:	75 ef                	jne    4b5 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 4c6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 4cd:	eb 1e                	jmp    4ed <strcat+0x47>
        dest[i+j] = src[j];
 4cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4d5:	01 d0                	add    %edx,%eax
 4d7:	89 c2                	mov    %eax,%edx
 4d9:	8b 45 08             	mov    0x8(%ebp),%eax
 4dc:	01 c2                	add    %eax,%edx
 4de:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 4e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4e4:	01 c8                	add    %ecx,%eax
 4e6:	8a 00                	mov    (%eax),%al
 4e8:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 4ea:	ff 45 f8             	incl   -0x8(%ebp)
 4ed:	8b 55 f8             	mov    -0x8(%ebp),%edx
 4f0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f3:	01 d0                	add    %edx,%eax
 4f5:	8a 00                	mov    (%eax),%al
 4f7:	84 c0                	test   %al,%al
 4f9:	75 d4                	jne    4cf <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 4fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 4fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
 501:	01 d0                	add    %edx,%eax
 503:	89 c2                	mov    %eax,%edx
 505:	8b 45 08             	mov    0x8(%ebp),%eax
 508:	01 d0                	add    %edx,%eax
 50a:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 50d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 510:	c9                   	leave  
 511:	c3                   	ret    

00000512 <strstr>:

int 
strstr(char* s, char* sub)
{
 512:	55                   	push   %ebp
 513:	89 e5                	mov    %esp,%ebp
 515:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 518:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 51f:	eb 7c                	jmp    59d <strstr+0x8b>
    {
        if(s[i] == sub[0])
 521:	8b 55 fc             	mov    -0x4(%ebp),%edx
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	01 d0                	add    %edx,%eax
 529:	8a 10                	mov    (%eax),%dl
 52b:	8b 45 0c             	mov    0xc(%ebp),%eax
 52e:	8a 00                	mov    (%eax),%al
 530:	38 c2                	cmp    %al,%dl
 532:	75 66                	jne    59a <strstr+0x88>
        {
            if(strlen(sub) == 1)
 534:	8b 45 0c             	mov    0xc(%ebp),%eax
 537:	89 04 24             	mov    %eax,(%esp)
 53a:	e8 ee fe ff ff       	call   42d <strlen>
 53f:	83 f8 01             	cmp    $0x1,%eax
 542:	75 05                	jne    549 <strstr+0x37>
            {  
                return i;
 544:	8b 45 fc             	mov    -0x4(%ebp),%eax
 547:	eb 6b                	jmp    5b4 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 549:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 550:	eb 3a                	jmp    58c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 552:	8b 45 f8             	mov    -0x8(%ebp),%eax
 555:	8b 55 fc             	mov    -0x4(%ebp),%edx
 558:	01 d0                	add    %edx,%eax
 55a:	89 c2                	mov    %eax,%edx
 55c:	8b 45 08             	mov    0x8(%ebp),%eax
 55f:	01 d0                	add    %edx,%eax
 561:	8a 10                	mov    (%eax),%dl
 563:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 566:	8b 45 0c             	mov    0xc(%ebp),%eax
 569:	01 c8                	add    %ecx,%eax
 56b:	8a 00                	mov    (%eax),%al
 56d:	38 c2                	cmp    %al,%dl
 56f:	75 16                	jne    587 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 571:	8b 45 f8             	mov    -0x8(%ebp),%eax
 574:	8d 50 01             	lea    0x1(%eax),%edx
 577:	8b 45 0c             	mov    0xc(%ebp),%eax
 57a:	01 d0                	add    %edx,%eax
 57c:	8a 00                	mov    (%eax),%al
 57e:	84 c0                	test   %al,%al
 580:	75 07                	jne    589 <strstr+0x77>
                    {
                        return i;
 582:	8b 45 fc             	mov    -0x4(%ebp),%eax
 585:	eb 2d                	jmp    5b4 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 587:	eb 11                	jmp    59a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 589:	ff 45 f8             	incl   -0x8(%ebp)
 58c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 58f:	8b 45 0c             	mov    0xc(%ebp),%eax
 592:	01 d0                	add    %edx,%eax
 594:	8a 00                	mov    (%eax),%al
 596:	84 c0                	test   %al,%al
 598:	75 b8                	jne    552 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 59a:	ff 45 fc             	incl   -0x4(%ebp)
 59d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5a0:	8b 45 08             	mov    0x8(%ebp),%eax
 5a3:	01 d0                	add    %edx,%eax
 5a5:	8a 00                	mov    (%eax),%al
 5a7:	84 c0                	test   %al,%al
 5a9:	0f 85 72 ff ff ff    	jne    521 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 5af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 5b4:	c9                   	leave  
 5b5:	c3                   	ret    

000005b6 <strtok>:

char *
strtok(char *s, const char *delim)
{
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	53                   	push   %ebx
 5ba:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 5bd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 5c1:	75 08                	jne    5cb <strtok+0x15>
  s = lasts;
 5c3:	a1 d4 13 00 00       	mov    0x13d4,%eax
 5c8:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 5cb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ce:	8d 50 01             	lea    0x1(%eax),%edx
 5d1:	89 55 08             	mov    %edx,0x8(%ebp)
 5d4:	8a 00                	mov    (%eax),%al
 5d6:	0f be d8             	movsbl %al,%ebx
 5d9:	85 db                	test   %ebx,%ebx
 5db:	75 07                	jne    5e4 <strtok+0x2e>
      return 0;
 5dd:	b8 00 00 00 00       	mov    $0x0,%eax
 5e2:	eb 58                	jmp    63c <strtok+0x86>
    } while (strchr(delim, ch));
 5e4:	88 d8                	mov    %bl,%al
 5e6:	0f be c0             	movsbl %al,%eax
 5e9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f0:	89 04 24             	mov    %eax,(%esp)
 5f3:	e8 7e fe ff ff       	call   476 <strchr>
 5f8:	85 c0                	test   %eax,%eax
 5fa:	75 cf                	jne    5cb <strtok+0x15>
    --s;
 5fc:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 5ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 602:	89 44 24 04          	mov    %eax,0x4(%esp)
 606:	8b 45 08             	mov    0x8(%ebp),%eax
 609:	89 04 24             	mov    %eax,(%esp)
 60c:	e8 31 00 00 00       	call   642 <strcspn>
 611:	89 c2                	mov    %eax,%edx
 613:	8b 45 08             	mov    0x8(%ebp),%eax
 616:	01 d0                	add    %edx,%eax
 618:	a3 d4 13 00 00       	mov    %eax,0x13d4
    if (*lasts != 0)
 61d:	a1 d4 13 00 00       	mov    0x13d4,%eax
 622:	8a 00                	mov    (%eax),%al
 624:	84 c0                	test   %al,%al
 626:	74 11                	je     639 <strtok+0x83>
  *lasts++ = 0;
 628:	a1 d4 13 00 00       	mov    0x13d4,%eax
 62d:	8d 50 01             	lea    0x1(%eax),%edx
 630:	89 15 d4 13 00 00    	mov    %edx,0x13d4
 636:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 639:	8b 45 08             	mov    0x8(%ebp),%eax
}
 63c:	83 c4 14             	add    $0x14,%esp
 63f:	5b                   	pop    %ebx
 640:	5d                   	pop    %ebp
 641:	c3                   	ret    

00000642 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 642:	55                   	push   %ebp
 643:	89 e5                	mov    %esp,%ebp
 645:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 648:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 64f:	eb 26                	jmp    677 <strcspn+0x35>
        if(strchr(s2,*s1))
 651:	8b 45 08             	mov    0x8(%ebp),%eax
 654:	8a 00                	mov    (%eax),%al
 656:	0f be c0             	movsbl %al,%eax
 659:	89 44 24 04          	mov    %eax,0x4(%esp)
 65d:	8b 45 0c             	mov    0xc(%ebp),%eax
 660:	89 04 24             	mov    %eax,(%esp)
 663:	e8 0e fe ff ff       	call   476 <strchr>
 668:	85 c0                	test   %eax,%eax
 66a:	74 05                	je     671 <strcspn+0x2f>
            return ret;
 66c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 66f:	eb 12                	jmp    683 <strcspn+0x41>
        else
            s1++,ret++;
 671:	ff 45 08             	incl   0x8(%ebp)
 674:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 677:	8b 45 08             	mov    0x8(%ebp),%eax
 67a:	8a 00                	mov    (%eax),%al
 67c:	84 c0                	test   %al,%al
 67e:	75 d1                	jne    651 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 680:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 683:	c9                   	leave  
 684:	c3                   	ret    

00000685 <isspace>:

int
isspace(unsigned char c)
{
 685:	55                   	push   %ebp
 686:	89 e5                	mov    %esp,%ebp
 688:	83 ec 04             	sub    $0x4,%esp
 68b:	8b 45 08             	mov    0x8(%ebp),%eax
 68e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 691:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 695:	74 1e                	je     6b5 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 697:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 69b:	74 18                	je     6b5 <isspace+0x30>
 69d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 6a1:	74 12                	je     6b5 <isspace+0x30>
 6a3:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 6a7:	74 0c                	je     6b5 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 6a9:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 6ad:	74 06                	je     6b5 <isspace+0x30>
 6af:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 6b3:	75 07                	jne    6bc <isspace+0x37>
 6b5:	b8 01 00 00 00       	mov    $0x1,%eax
 6ba:	eb 05                	jmp    6c1 <isspace+0x3c>
 6bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
 6c1:	c9                   	leave  
 6c2:	c3                   	ret    

000006c3 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 6c3:	55                   	push   %ebp
 6c4:	89 e5                	mov    %esp,%ebp
 6c6:	57                   	push   %edi
 6c7:	56                   	push   %esi
 6c8:	53                   	push   %ebx
 6c9:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 6cc:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 6d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 6d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 6db:	eb 01                	jmp    6de <strtoul+0x1b>
  p += 1;
 6dd:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 6de:	8a 03                	mov    (%ebx),%al
 6e0:	0f b6 c0             	movzbl %al,%eax
 6e3:	89 04 24             	mov    %eax,(%esp)
 6e6:	e8 9a ff ff ff       	call   685 <isspace>
 6eb:	85 c0                	test   %eax,%eax
 6ed:	75 ee                	jne    6dd <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 6ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 6f3:	75 30                	jne    725 <strtoul+0x62>
    {
  if (*p == '0') {
 6f5:	8a 03                	mov    (%ebx),%al
 6f7:	3c 30                	cmp    $0x30,%al
 6f9:	75 21                	jne    71c <strtoul+0x59>
      p += 1;
 6fb:	43                   	inc    %ebx
      if (*p == 'x') {
 6fc:	8a 03                	mov    (%ebx),%al
 6fe:	3c 78                	cmp    $0x78,%al
 700:	75 0a                	jne    70c <strtoul+0x49>
    p += 1;
 702:	43                   	inc    %ebx
    base = 16;
 703:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 70a:	eb 31                	jmp    73d <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 70c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 713:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 71a:	eb 21                	jmp    73d <strtoul+0x7a>
      }
  }
  else base = 10;
 71c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 723:	eb 18                	jmp    73d <strtoul+0x7a>
    } else if (base == 16) {
 725:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 729:	75 12                	jne    73d <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 72b:	8a 03                	mov    (%ebx),%al
 72d:	3c 30                	cmp    $0x30,%al
 72f:	75 0c                	jne    73d <strtoul+0x7a>
 731:	8d 43 01             	lea    0x1(%ebx),%eax
 734:	8a 00                	mov    (%eax),%al
 736:	3c 78                	cmp    $0x78,%al
 738:	75 03                	jne    73d <strtoul+0x7a>
      p += 2;
 73a:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 73d:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 741:	75 29                	jne    76c <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 743:	8a 03                	mov    (%ebx),%al
 745:	0f be c0             	movsbl %al,%eax
 748:	83 e8 30             	sub    $0x30,%eax
 74b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 74d:	83 fe 07             	cmp    $0x7,%esi
 750:	76 06                	jbe    758 <strtoul+0x95>
    break;
 752:	90                   	nop
 753:	e9 b6 00 00 00       	jmp    80e <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 758:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 75f:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 762:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 769:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 76a:	eb d7                	jmp    743 <strtoul+0x80>
    } else if (base == 10) {
 76c:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 770:	75 2b                	jne    79d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 772:	8a 03                	mov    (%ebx),%al
 774:	0f be c0             	movsbl %al,%eax
 777:	83 e8 30             	sub    $0x30,%eax
 77a:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 77c:	83 fe 09             	cmp    $0x9,%esi
 77f:	76 06                	jbe    787 <strtoul+0xc4>
    break;
 781:	90                   	nop
 782:	e9 87 00 00 00       	jmp    80e <strtoul+0x14b>
      }
      result = (10*result) + digit;
 787:	89 f8                	mov    %edi,%eax
 789:	c1 e0 02             	shl    $0x2,%eax
 78c:	01 f8                	add    %edi,%eax
 78e:	01 c0                	add    %eax,%eax
 790:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 793:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 79a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 79b:	eb d5                	jmp    772 <strtoul+0xaf>
    } else if (base == 16) {
 79d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 7a1:	75 35                	jne    7d8 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 7a3:	8a 03                	mov    (%ebx),%al
 7a5:	0f be c0             	movsbl %al,%eax
 7a8:	83 e8 30             	sub    $0x30,%eax
 7ab:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 7ad:	83 fe 4a             	cmp    $0x4a,%esi
 7b0:	76 02                	jbe    7b4 <strtoul+0xf1>
    break;
 7b2:	eb 22                	jmp    7d6 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 7b4:	8a 86 60 13 00 00    	mov    0x1360(%esi),%al
 7ba:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 7bd:	83 fe 0f             	cmp    $0xf,%esi
 7c0:	76 02                	jbe    7c4 <strtoul+0x101>
    break;
 7c2:	eb 12                	jmp    7d6 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 7c4:	89 f8                	mov    %edi,%eax
 7c6:	c1 e0 04             	shl    $0x4,%eax
 7c9:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 7cc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 7d3:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 7d4:	eb cd                	jmp    7a3 <strtoul+0xe0>
 7d6:	eb 36                	jmp    80e <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 7d8:	8a 03                	mov    (%ebx),%al
 7da:	0f be c0             	movsbl %al,%eax
 7dd:	83 e8 30             	sub    $0x30,%eax
 7e0:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 7e2:	83 fe 4a             	cmp    $0x4a,%esi
 7e5:	76 02                	jbe    7e9 <strtoul+0x126>
    break;
 7e7:	eb 25                	jmp    80e <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 7e9:	8a 86 60 13 00 00    	mov    0x1360(%esi),%al
 7ef:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 7f2:	8b 45 10             	mov    0x10(%ebp),%eax
 7f5:	39 f0                	cmp    %esi,%eax
 7f7:	77 02                	ja     7fb <strtoul+0x138>
    break;
 7f9:	eb 13                	jmp    80e <strtoul+0x14b>
      }
      result = result*base + digit;
 7fb:	8b 45 10             	mov    0x10(%ebp),%eax
 7fe:	0f af c7             	imul   %edi,%eax
 801:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 804:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 80b:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 80c:	eb ca                	jmp    7d8 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 80e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 812:	75 03                	jne    817 <strtoul+0x154>
  p = string;
 814:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 817:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 81b:	74 05                	je     822 <strtoul+0x15f>
  *endPtr = p;
 81d:	8b 45 0c             	mov    0xc(%ebp),%eax
 820:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 822:	89 f8                	mov    %edi,%eax
}
 824:	83 c4 14             	add    $0x14,%esp
 827:	5b                   	pop    %ebx
 828:	5e                   	pop    %esi
 829:	5f                   	pop    %edi
 82a:	5d                   	pop    %ebp
 82b:	c3                   	ret    

0000082c <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 82c:	55                   	push   %ebp
 82d:	89 e5                	mov    %esp,%ebp
 82f:	53                   	push   %ebx
 830:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 833:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 836:	eb 01                	jmp    839 <strtol+0xd>
      p += 1;
 838:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 839:	8a 03                	mov    (%ebx),%al
 83b:	0f b6 c0             	movzbl %al,%eax
 83e:	89 04 24             	mov    %eax,(%esp)
 841:	e8 3f fe ff ff       	call   685 <isspace>
 846:	85 c0                	test   %eax,%eax
 848:	75 ee                	jne    838 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 84a:	8a 03                	mov    (%ebx),%al
 84c:	3c 2d                	cmp    $0x2d,%al
 84e:	75 1e                	jne    86e <strtol+0x42>
  p += 1;
 850:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 851:	8b 45 10             	mov    0x10(%ebp),%eax
 854:	89 44 24 08          	mov    %eax,0x8(%esp)
 858:	8b 45 0c             	mov    0xc(%ebp),%eax
 85b:	89 44 24 04          	mov    %eax,0x4(%esp)
 85f:	89 1c 24             	mov    %ebx,(%esp)
 862:	e8 5c fe ff ff       	call   6c3 <strtoul>
 867:	f7 d8                	neg    %eax
 869:	89 45 f8             	mov    %eax,-0x8(%ebp)
 86c:	eb 20                	jmp    88e <strtol+0x62>
    } else {
  if (*p == '+') {
 86e:	8a 03                	mov    (%ebx),%al
 870:	3c 2b                	cmp    $0x2b,%al
 872:	75 01                	jne    875 <strtol+0x49>
      p += 1;
 874:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 875:	8b 45 10             	mov    0x10(%ebp),%eax
 878:	89 44 24 08          	mov    %eax,0x8(%esp)
 87c:	8b 45 0c             	mov    0xc(%ebp),%eax
 87f:	89 44 24 04          	mov    %eax,0x4(%esp)
 883:	89 1c 24             	mov    %ebx,(%esp)
 886:	e8 38 fe ff ff       	call   6c3 <strtoul>
 88b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 88e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 892:	75 17                	jne    8ab <strtol+0x7f>
 894:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 898:	74 11                	je     8ab <strtol+0x7f>
 89a:	8b 45 0c             	mov    0xc(%ebp),%eax
 89d:	8b 00                	mov    (%eax),%eax
 89f:	39 d8                	cmp    %ebx,%eax
 8a1:	75 08                	jne    8ab <strtol+0x7f>
  *endPtr = string;
 8a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a6:	8b 55 08             	mov    0x8(%ebp),%edx
 8a9:	89 10                	mov    %edx,(%eax)
    }
    return result;
 8ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 8ae:	83 c4 1c             	add    $0x1c,%esp
 8b1:	5b                   	pop    %ebx
 8b2:	5d                   	pop    %ebp
 8b3:	c3                   	ret    

000008b4 <gets>:

char*
gets(char *buf, int max)
{
 8b4:	55                   	push   %ebp
 8b5:	89 e5                	mov    %esp,%ebp
 8b7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 8ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 8c1:	eb 49                	jmp    90c <gets+0x58>
    cc = read(0, &c, 1);
 8c3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8ca:	00 
 8cb:	8d 45 ef             	lea    -0x11(%ebp),%eax
 8ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 8d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 8d9:	e8 3e 01 00 00       	call   a1c <read>
 8de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 8e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e5:	7f 02                	jg     8e9 <gets+0x35>
      break;
 8e7:	eb 2c                	jmp    915 <gets+0x61>
    buf[i++] = c;
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8d 50 01             	lea    0x1(%eax),%edx
 8ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8f2:	89 c2                	mov    %eax,%edx
 8f4:	8b 45 08             	mov    0x8(%ebp),%eax
 8f7:	01 c2                	add    %eax,%edx
 8f9:	8a 45 ef             	mov    -0x11(%ebp),%al
 8fc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 8fe:	8a 45 ef             	mov    -0x11(%ebp),%al
 901:	3c 0a                	cmp    $0xa,%al
 903:	74 10                	je     915 <gets+0x61>
 905:	8a 45 ef             	mov    -0x11(%ebp),%al
 908:	3c 0d                	cmp    $0xd,%al
 90a:	74 09                	je     915 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	40                   	inc    %eax
 910:	3b 45 0c             	cmp    0xc(%ebp),%eax
 913:	7c ae                	jl     8c3 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 915:	8b 55 f4             	mov    -0xc(%ebp),%edx
 918:	8b 45 08             	mov    0x8(%ebp),%eax
 91b:	01 d0                	add    %edx,%eax
 91d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 920:	8b 45 08             	mov    0x8(%ebp),%eax
}
 923:	c9                   	leave  
 924:	c3                   	ret    

00000925 <stat>:

int
stat(char *n, struct stat *st)
{
 925:	55                   	push   %ebp
 926:	89 e5                	mov    %esp,%ebp
 928:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 92b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 932:	00 
 933:	8b 45 08             	mov    0x8(%ebp),%eax
 936:	89 04 24             	mov    %eax,(%esp)
 939:	e8 06 01 00 00       	call   a44 <open>
 93e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 941:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 945:	79 07                	jns    94e <stat+0x29>
    return -1;
 947:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 94c:	eb 23                	jmp    971 <stat+0x4c>
  r = fstat(fd, st);
 94e:	8b 45 0c             	mov    0xc(%ebp),%eax
 951:	89 44 24 04          	mov    %eax,0x4(%esp)
 955:	8b 45 f4             	mov    -0xc(%ebp),%eax
 958:	89 04 24             	mov    %eax,(%esp)
 95b:	e8 fc 00 00 00       	call   a5c <fstat>
 960:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 963:	8b 45 f4             	mov    -0xc(%ebp),%eax
 966:	89 04 24             	mov    %eax,(%esp)
 969:	e8 be 00 00 00       	call   a2c <close>
  return r;
 96e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 971:	c9                   	leave  
 972:	c3                   	ret    

00000973 <atoi>:

int
atoi(const char *s)
{
 973:	55                   	push   %ebp
 974:	89 e5                	mov    %esp,%ebp
 976:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 979:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 980:	eb 24                	jmp    9a6 <atoi+0x33>
    n = n*10 + *s++ - '0';
 982:	8b 55 fc             	mov    -0x4(%ebp),%edx
 985:	89 d0                	mov    %edx,%eax
 987:	c1 e0 02             	shl    $0x2,%eax
 98a:	01 d0                	add    %edx,%eax
 98c:	01 c0                	add    %eax,%eax
 98e:	89 c1                	mov    %eax,%ecx
 990:	8b 45 08             	mov    0x8(%ebp),%eax
 993:	8d 50 01             	lea    0x1(%eax),%edx
 996:	89 55 08             	mov    %edx,0x8(%ebp)
 999:	8a 00                	mov    (%eax),%al
 99b:	0f be c0             	movsbl %al,%eax
 99e:	01 c8                	add    %ecx,%eax
 9a0:	83 e8 30             	sub    $0x30,%eax
 9a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 9a6:	8b 45 08             	mov    0x8(%ebp),%eax
 9a9:	8a 00                	mov    (%eax),%al
 9ab:	3c 2f                	cmp    $0x2f,%al
 9ad:	7e 09                	jle    9b8 <atoi+0x45>
 9af:	8b 45 08             	mov    0x8(%ebp),%eax
 9b2:	8a 00                	mov    (%eax),%al
 9b4:	3c 39                	cmp    $0x39,%al
 9b6:	7e ca                	jle    982 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 9b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 9bb:	c9                   	leave  
 9bc:	c3                   	ret    

000009bd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 9bd:	55                   	push   %ebp
 9be:	89 e5                	mov    %esp,%ebp
 9c0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 9c3:	8b 45 08             	mov    0x8(%ebp),%eax
 9c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 9c9:	8b 45 0c             	mov    0xc(%ebp),%eax
 9cc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 9cf:	eb 16                	jmp    9e7 <memmove+0x2a>
    *dst++ = *src++;
 9d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9d4:	8d 50 01             	lea    0x1(%eax),%edx
 9d7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 9da:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9dd:	8d 4a 01             	lea    0x1(%edx),%ecx
 9e0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 9e3:	8a 12                	mov    (%edx),%dl
 9e5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 9e7:	8b 45 10             	mov    0x10(%ebp),%eax
 9ea:	8d 50 ff             	lea    -0x1(%eax),%edx
 9ed:	89 55 10             	mov    %edx,0x10(%ebp)
 9f0:	85 c0                	test   %eax,%eax
 9f2:	7f dd                	jg     9d1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 9f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 9f7:	c9                   	leave  
 9f8:	c3                   	ret    
 9f9:	90                   	nop
 9fa:	90                   	nop
 9fb:	90                   	nop

000009fc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 9fc:	b8 01 00 00 00       	mov    $0x1,%eax
 a01:	cd 40                	int    $0x40
 a03:	c3                   	ret    

00000a04 <exit>:
SYSCALL(exit)
 a04:	b8 02 00 00 00       	mov    $0x2,%eax
 a09:	cd 40                	int    $0x40
 a0b:	c3                   	ret    

00000a0c <wait>:
SYSCALL(wait)
 a0c:	b8 03 00 00 00       	mov    $0x3,%eax
 a11:	cd 40                	int    $0x40
 a13:	c3                   	ret    

00000a14 <pipe>:
SYSCALL(pipe)
 a14:	b8 04 00 00 00       	mov    $0x4,%eax
 a19:	cd 40                	int    $0x40
 a1b:	c3                   	ret    

00000a1c <read>:
SYSCALL(read)
 a1c:	b8 05 00 00 00       	mov    $0x5,%eax
 a21:	cd 40                	int    $0x40
 a23:	c3                   	ret    

00000a24 <write>:
SYSCALL(write)
 a24:	b8 10 00 00 00       	mov    $0x10,%eax
 a29:	cd 40                	int    $0x40
 a2b:	c3                   	ret    

00000a2c <close>:
SYSCALL(close)
 a2c:	b8 15 00 00 00       	mov    $0x15,%eax
 a31:	cd 40                	int    $0x40
 a33:	c3                   	ret    

00000a34 <kill>:
SYSCALL(kill)
 a34:	b8 06 00 00 00       	mov    $0x6,%eax
 a39:	cd 40                	int    $0x40
 a3b:	c3                   	ret    

00000a3c <exec>:
SYSCALL(exec)
 a3c:	b8 07 00 00 00       	mov    $0x7,%eax
 a41:	cd 40                	int    $0x40
 a43:	c3                   	ret    

00000a44 <open>:
SYSCALL(open)
 a44:	b8 0f 00 00 00       	mov    $0xf,%eax
 a49:	cd 40                	int    $0x40
 a4b:	c3                   	ret    

00000a4c <mknod>:
SYSCALL(mknod)
 a4c:	b8 11 00 00 00       	mov    $0x11,%eax
 a51:	cd 40                	int    $0x40
 a53:	c3                   	ret    

00000a54 <unlink>:
SYSCALL(unlink)
 a54:	b8 12 00 00 00       	mov    $0x12,%eax
 a59:	cd 40                	int    $0x40
 a5b:	c3                   	ret    

00000a5c <fstat>:
SYSCALL(fstat)
 a5c:	b8 08 00 00 00       	mov    $0x8,%eax
 a61:	cd 40                	int    $0x40
 a63:	c3                   	ret    

00000a64 <link>:
SYSCALL(link)
 a64:	b8 13 00 00 00       	mov    $0x13,%eax
 a69:	cd 40                	int    $0x40
 a6b:	c3                   	ret    

00000a6c <mkdir>:
SYSCALL(mkdir)
 a6c:	b8 14 00 00 00       	mov    $0x14,%eax
 a71:	cd 40                	int    $0x40
 a73:	c3                   	ret    

00000a74 <chdir>:
SYSCALL(chdir)
 a74:	b8 09 00 00 00       	mov    $0x9,%eax
 a79:	cd 40                	int    $0x40
 a7b:	c3                   	ret    

00000a7c <dup>:
SYSCALL(dup)
 a7c:	b8 0a 00 00 00       	mov    $0xa,%eax
 a81:	cd 40                	int    $0x40
 a83:	c3                   	ret    

00000a84 <getpid>:
SYSCALL(getpid)
 a84:	b8 0b 00 00 00       	mov    $0xb,%eax
 a89:	cd 40                	int    $0x40
 a8b:	c3                   	ret    

00000a8c <sbrk>:
SYSCALL(sbrk)
 a8c:	b8 0c 00 00 00       	mov    $0xc,%eax
 a91:	cd 40                	int    $0x40
 a93:	c3                   	ret    

00000a94 <sleep>:
SYSCALL(sleep)
 a94:	b8 0d 00 00 00       	mov    $0xd,%eax
 a99:	cd 40                	int    $0x40
 a9b:	c3                   	ret    

00000a9c <uptime>:
SYSCALL(uptime)
 a9c:	b8 0e 00 00 00       	mov    $0xe,%eax
 aa1:	cd 40                	int    $0x40
 aa3:	c3                   	ret    

00000aa4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 aa4:	55                   	push   %ebp
 aa5:	89 e5                	mov    %esp,%ebp
 aa7:	83 ec 18             	sub    $0x18,%esp
 aaa:	8b 45 0c             	mov    0xc(%ebp),%eax
 aad:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 ab0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 ab7:	00 
 ab8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 abb:	89 44 24 04          	mov    %eax,0x4(%esp)
 abf:	8b 45 08             	mov    0x8(%ebp),%eax
 ac2:	89 04 24             	mov    %eax,(%esp)
 ac5:	e8 5a ff ff ff       	call   a24 <write>
}
 aca:	c9                   	leave  
 acb:	c3                   	ret    

00000acc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 acc:	55                   	push   %ebp
 acd:	89 e5                	mov    %esp,%ebp
 acf:	56                   	push   %esi
 ad0:	53                   	push   %ebx
 ad1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 ad4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 adb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 adf:	74 17                	je     af8 <printint+0x2c>
 ae1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ae5:	79 11                	jns    af8 <printint+0x2c>
    neg = 1;
 ae7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 aee:	8b 45 0c             	mov    0xc(%ebp),%eax
 af1:	f7 d8                	neg    %eax
 af3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 af6:	eb 06                	jmp    afe <printint+0x32>
  } else {
    x = xx;
 af8:	8b 45 0c             	mov    0xc(%ebp),%eax
 afb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 afe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 b05:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 b08:	8d 41 01             	lea    0x1(%ecx),%eax
 b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b0e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 b11:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b14:	ba 00 00 00 00       	mov    $0x0,%edx
 b19:	f7 f3                	div    %ebx
 b1b:	89 d0                	mov    %edx,%eax
 b1d:	8a 80 ac 13 00 00    	mov    0x13ac(%eax),%al
 b23:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 b27:	8b 75 10             	mov    0x10(%ebp),%esi
 b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b2d:	ba 00 00 00 00       	mov    $0x0,%edx
 b32:	f7 f6                	div    %esi
 b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b37:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b3b:	75 c8                	jne    b05 <printint+0x39>
  if(neg)
 b3d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b41:	74 10                	je     b53 <printint+0x87>
    buf[i++] = '-';
 b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b46:	8d 50 01             	lea    0x1(%eax),%edx
 b49:	89 55 f4             	mov    %edx,-0xc(%ebp)
 b4c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 b51:	eb 1e                	jmp    b71 <printint+0xa5>
 b53:	eb 1c                	jmp    b71 <printint+0xa5>
    putc(fd, buf[i]);
 b55:	8d 55 dc             	lea    -0x24(%ebp),%edx
 b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5b:	01 d0                	add    %edx,%eax
 b5d:	8a 00                	mov    (%eax),%al
 b5f:	0f be c0             	movsbl %al,%eax
 b62:	89 44 24 04          	mov    %eax,0x4(%esp)
 b66:	8b 45 08             	mov    0x8(%ebp),%eax
 b69:	89 04 24             	mov    %eax,(%esp)
 b6c:	e8 33 ff ff ff       	call   aa4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 b71:	ff 4d f4             	decl   -0xc(%ebp)
 b74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b78:	79 db                	jns    b55 <printint+0x89>
    putc(fd, buf[i]);
}
 b7a:	83 c4 30             	add    $0x30,%esp
 b7d:	5b                   	pop    %ebx
 b7e:	5e                   	pop    %esi
 b7f:	5d                   	pop    %ebp
 b80:	c3                   	ret    

00000b81 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b81:	55                   	push   %ebp
 b82:	89 e5                	mov    %esp,%ebp
 b84:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b87:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b8e:	8d 45 0c             	lea    0xc(%ebp),%eax
 b91:	83 c0 04             	add    $0x4,%eax
 b94:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b97:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b9e:	e9 77 01 00 00       	jmp    d1a <printf+0x199>
    c = fmt[i] & 0xff;
 ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
 ba6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba9:	01 d0                	add    %edx,%eax
 bab:	8a 00                	mov    (%eax),%al
 bad:	0f be c0             	movsbl %al,%eax
 bb0:	25 ff 00 00 00       	and    $0xff,%eax
 bb5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 bb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bbc:	75 2c                	jne    bea <printf+0x69>
      if(c == '%'){
 bbe:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bc2:	75 0c                	jne    bd0 <printf+0x4f>
        state = '%';
 bc4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 bcb:	e9 47 01 00 00       	jmp    d17 <printf+0x196>
      } else {
        putc(fd, c);
 bd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bd3:	0f be c0             	movsbl %al,%eax
 bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
 bda:	8b 45 08             	mov    0x8(%ebp),%eax
 bdd:	89 04 24             	mov    %eax,(%esp)
 be0:	e8 bf fe ff ff       	call   aa4 <putc>
 be5:	e9 2d 01 00 00       	jmp    d17 <printf+0x196>
      }
    } else if(state == '%'){
 bea:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 bee:	0f 85 23 01 00 00    	jne    d17 <printf+0x196>
      if(c == 'd'){
 bf4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 bf8:	75 2d                	jne    c27 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 bfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bfd:	8b 00                	mov    (%eax),%eax
 bff:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 c06:	00 
 c07:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 c0e:	00 
 c0f:	89 44 24 04          	mov    %eax,0x4(%esp)
 c13:	8b 45 08             	mov    0x8(%ebp),%eax
 c16:	89 04 24             	mov    %eax,(%esp)
 c19:	e8 ae fe ff ff       	call   acc <printint>
        ap++;
 c1e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c22:	e9 e9 00 00 00       	jmp    d10 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 c27:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 c2b:	74 06                	je     c33 <printf+0xb2>
 c2d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 c31:	75 2d                	jne    c60 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 c33:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c36:	8b 00                	mov    (%eax),%eax
 c38:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 c3f:	00 
 c40:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 c47:	00 
 c48:	89 44 24 04          	mov    %eax,0x4(%esp)
 c4c:	8b 45 08             	mov    0x8(%ebp),%eax
 c4f:	89 04 24             	mov    %eax,(%esp)
 c52:	e8 75 fe ff ff       	call   acc <printint>
        ap++;
 c57:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c5b:	e9 b0 00 00 00       	jmp    d10 <printf+0x18f>
      } else if(c == 's'){
 c60:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 c64:	75 42                	jne    ca8 <printf+0x127>
        s = (char*)*ap;
 c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c69:	8b 00                	mov    (%eax),%eax
 c6b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c6e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c76:	75 09                	jne    c81 <printf+0x100>
          s = "(null)";
 c78:	c7 45 f4 91 0f 00 00 	movl   $0xf91,-0xc(%ebp)
        while(*s != 0){
 c7f:	eb 1c                	jmp    c9d <printf+0x11c>
 c81:	eb 1a                	jmp    c9d <printf+0x11c>
          putc(fd, *s);
 c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c86:	8a 00                	mov    (%eax),%al
 c88:	0f be c0             	movsbl %al,%eax
 c8b:	89 44 24 04          	mov    %eax,0x4(%esp)
 c8f:	8b 45 08             	mov    0x8(%ebp),%eax
 c92:	89 04 24             	mov    %eax,(%esp)
 c95:	e8 0a fe ff ff       	call   aa4 <putc>
          s++;
 c9a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca0:	8a 00                	mov    (%eax),%al
 ca2:	84 c0                	test   %al,%al
 ca4:	75 dd                	jne    c83 <printf+0x102>
 ca6:	eb 68                	jmp    d10 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ca8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 cac:	75 1d                	jne    ccb <printf+0x14a>
        putc(fd, *ap);
 cae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 cb1:	8b 00                	mov    (%eax),%eax
 cb3:	0f be c0             	movsbl %al,%eax
 cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
 cba:	8b 45 08             	mov    0x8(%ebp),%eax
 cbd:	89 04 24             	mov    %eax,(%esp)
 cc0:	e8 df fd ff ff       	call   aa4 <putc>
        ap++;
 cc5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 cc9:	eb 45                	jmp    d10 <printf+0x18f>
      } else if(c == '%'){
 ccb:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ccf:	75 17                	jne    ce8 <printf+0x167>
        putc(fd, c);
 cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 cd4:	0f be c0             	movsbl %al,%eax
 cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
 cdb:	8b 45 08             	mov    0x8(%ebp),%eax
 cde:	89 04 24             	mov    %eax,(%esp)
 ce1:	e8 be fd ff ff       	call   aa4 <putc>
 ce6:	eb 28                	jmp    d10 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 ce8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 cef:	00 
 cf0:	8b 45 08             	mov    0x8(%ebp),%eax
 cf3:	89 04 24             	mov    %eax,(%esp)
 cf6:	e8 a9 fd ff ff       	call   aa4 <putc>
        putc(fd, c);
 cfb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 cfe:	0f be c0             	movsbl %al,%eax
 d01:	89 44 24 04          	mov    %eax,0x4(%esp)
 d05:	8b 45 08             	mov    0x8(%ebp),%eax
 d08:	89 04 24             	mov    %eax,(%esp)
 d0b:	e8 94 fd ff ff       	call   aa4 <putc>
      }
      state = 0;
 d10:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 d17:	ff 45 f0             	incl   -0x10(%ebp)
 d1a:	8b 55 0c             	mov    0xc(%ebp),%edx
 d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d20:	01 d0                	add    %edx,%eax
 d22:	8a 00                	mov    (%eax),%al
 d24:	84 c0                	test   %al,%al
 d26:	0f 85 77 fe ff ff    	jne    ba3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 d2c:	c9                   	leave  
 d2d:	c3                   	ret    
 d2e:	90                   	nop
 d2f:	90                   	nop

00000d30 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d30:	55                   	push   %ebp
 d31:	89 e5                	mov    %esp,%ebp
 d33:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d36:	8b 45 08             	mov    0x8(%ebp),%eax
 d39:	83 e8 08             	sub    $0x8,%eax
 d3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d3f:	a1 e0 13 00 00       	mov    0x13e0,%eax
 d44:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d47:	eb 24                	jmp    d6d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4c:	8b 00                	mov    (%eax),%eax
 d4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d51:	77 12                	ja     d65 <free+0x35>
 d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d56:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d59:	77 24                	ja     d7f <free+0x4f>
 d5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d5e:	8b 00                	mov    (%eax),%eax
 d60:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d63:	77 1a                	ja     d7f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d68:	8b 00                	mov    (%eax),%eax
 d6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d70:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d73:	76 d4                	jbe    d49 <free+0x19>
 d75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d78:	8b 00                	mov    (%eax),%eax
 d7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 d7d:	76 ca                	jbe    d49 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d82:	8b 40 04             	mov    0x4(%eax),%eax
 d85:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d8f:	01 c2                	add    %eax,%edx
 d91:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d94:	8b 00                	mov    (%eax),%eax
 d96:	39 c2                	cmp    %eax,%edx
 d98:	75 24                	jne    dbe <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d9d:	8b 50 04             	mov    0x4(%eax),%edx
 da0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 da3:	8b 00                	mov    (%eax),%eax
 da5:	8b 40 04             	mov    0x4(%eax),%eax
 da8:	01 c2                	add    %eax,%edx
 daa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dad:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 db0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 db3:	8b 00                	mov    (%eax),%eax
 db5:	8b 10                	mov    (%eax),%edx
 db7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dba:	89 10                	mov    %edx,(%eax)
 dbc:	eb 0a                	jmp    dc8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 dbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dc1:	8b 10                	mov    (%eax),%edx
 dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dc6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dcb:	8b 40 04             	mov    0x4(%eax),%eax
 dce:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dd8:	01 d0                	add    %edx,%eax
 dda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ddd:	75 20                	jne    dff <free+0xcf>
    p->s.size += bp->s.size;
 ddf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 de2:	8b 50 04             	mov    0x4(%eax),%edx
 de5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 de8:	8b 40 04             	mov    0x4(%eax),%eax
 deb:	01 c2                	add    %eax,%edx
 ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
 df0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 df3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 df6:	8b 10                	mov    (%eax),%edx
 df8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dfb:	89 10                	mov    %edx,(%eax)
 dfd:	eb 08                	jmp    e07 <free+0xd7>
  } else
    p->s.ptr = bp;
 dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e02:	8b 55 f8             	mov    -0x8(%ebp),%edx
 e05:	89 10                	mov    %edx,(%eax)
  freep = p;
 e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e0a:	a3 e0 13 00 00       	mov    %eax,0x13e0
}
 e0f:	c9                   	leave  
 e10:	c3                   	ret    

00000e11 <morecore>:

static Header*
morecore(uint nu)
{
 e11:	55                   	push   %ebp
 e12:	89 e5                	mov    %esp,%ebp
 e14:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 e17:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 e1e:	77 07                	ja     e27 <morecore+0x16>
    nu = 4096;
 e20:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 e27:	8b 45 08             	mov    0x8(%ebp),%eax
 e2a:	c1 e0 03             	shl    $0x3,%eax
 e2d:	89 04 24             	mov    %eax,(%esp)
 e30:	e8 57 fc ff ff       	call   a8c <sbrk>
 e35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 e38:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 e3c:	75 07                	jne    e45 <morecore+0x34>
    return 0;
 e3e:	b8 00 00 00 00       	mov    $0x0,%eax
 e43:	eb 22                	jmp    e67 <morecore+0x56>
  hp = (Header*)p;
 e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e48:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 e4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e4e:	8b 55 08             	mov    0x8(%ebp),%edx
 e51:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e57:	83 c0 08             	add    $0x8,%eax
 e5a:	89 04 24             	mov    %eax,(%esp)
 e5d:	e8 ce fe ff ff       	call   d30 <free>
  return freep;
 e62:	a1 e0 13 00 00       	mov    0x13e0,%eax
}
 e67:	c9                   	leave  
 e68:	c3                   	ret    

00000e69 <malloc>:

void*
malloc(uint nbytes)
{
 e69:	55                   	push   %ebp
 e6a:	89 e5                	mov    %esp,%ebp
 e6c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e6f:	8b 45 08             	mov    0x8(%ebp),%eax
 e72:	83 c0 07             	add    $0x7,%eax
 e75:	c1 e8 03             	shr    $0x3,%eax
 e78:	40                   	inc    %eax
 e79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e7c:	a1 e0 13 00 00       	mov    0x13e0,%eax
 e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e84:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e88:	75 23                	jne    ead <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 e8a:	c7 45 f0 d8 13 00 00 	movl   $0x13d8,-0x10(%ebp)
 e91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e94:	a3 e0 13 00 00       	mov    %eax,0x13e0
 e99:	a1 e0 13 00 00       	mov    0x13e0,%eax
 e9e:	a3 d8 13 00 00       	mov    %eax,0x13d8
    base.s.size = 0;
 ea3:	c7 05 dc 13 00 00 00 	movl   $0x0,0x13dc
 eaa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ead:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eb0:	8b 00                	mov    (%eax),%eax
 eb2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb8:	8b 40 04             	mov    0x4(%eax),%eax
 ebb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ebe:	72 4d                	jb     f0d <malloc+0xa4>
      if(p->s.size == nunits)
 ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec3:	8b 40 04             	mov    0x4(%eax),%eax
 ec6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ec9:	75 0c                	jne    ed7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 ecb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ece:	8b 10                	mov    (%eax),%edx
 ed0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ed3:	89 10                	mov    %edx,(%eax)
 ed5:	eb 26                	jmp    efd <malloc+0x94>
      else {
        p->s.size -= nunits;
 ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eda:	8b 40 04             	mov    0x4(%eax),%eax
 edd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ee0:	89 c2                	mov    %eax,%edx
 ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ee5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eeb:	8b 40 04             	mov    0x4(%eax),%eax
 eee:	c1 e0 03             	shl    $0x3,%eax
 ef1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ef4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ef7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 efa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f00:	a3 e0 13 00 00       	mov    %eax,0x13e0
      return (void*)(p + 1);
 f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f08:	83 c0 08             	add    $0x8,%eax
 f0b:	eb 38                	jmp    f45 <malloc+0xdc>
    }
    if(p == freep)
 f0d:	a1 e0 13 00 00       	mov    0x13e0,%eax
 f12:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 f15:	75 1b                	jne    f32 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 f17:	8b 45 ec             	mov    -0x14(%ebp),%eax
 f1a:	89 04 24             	mov    %eax,(%esp)
 f1d:	e8 ef fe ff ff       	call   e11 <morecore>
 f22:	89 45 f4             	mov    %eax,-0xc(%ebp)
 f25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 f29:	75 07                	jne    f32 <malloc+0xc9>
        return 0;
 f2b:	b8 00 00 00 00       	mov    $0x0,%eax
 f30:	eb 13                	jmp    f45 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f35:	89 45 f0             	mov    %eax,-0x10(%ebp)
 f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f3b:	8b 00                	mov    (%eax),%eax
 f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 f40:	e9 70 ff ff ff       	jmp    eb5 <malloc+0x4c>
}
 f45:	c9                   	leave  
 f46:	c3                   	ret    
