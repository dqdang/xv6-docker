
_rm:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: rm files...\n");
   f:	c7 44 24 04 0b 0e 00 	movl   $0xe0b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 22 0a 00 00       	call   a45 <printf>
    exit();
  23:	e8 18 08 00 00       	call   840 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4e                	jmp    80 <main+0x80>
    if(unlink(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 44 08 00 00       	call   890 <unlink>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 1f 0e 00 	movl   $0xe1f,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 cb 09 00 00       	call   a45 <printf>
      break;
  7a:	eb 0d                	jmp    89 <main+0x89>
  if(argc < 2){
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	ff 44 24 1c          	incl   0x1c(%esp)
  80:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  84:	3b 45 08             	cmp    0x8(%ebp),%eax
  87:	7c a9                	jl     32 <main+0x32>
      printf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit();
  89:	e8 b2 07 00 00       	call   840 <exit>
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8d 50 01             	lea    0x1(%eax),%edx
  c8:	89 55 08             	mov    %edx,0x8(%ebp)
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d4:	8a 12                	mov    (%edx),%dl
  d6:	88 10                	mov    %dl,(%eax)
  d8:	8a 00                	mov    (%eax),%al
  da:	84 c0                	test   %al,%al
  dc:	75 e4                	jne    c2 <strcpy+0xd>
    ;
  return os;
  de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e1:	c9                   	leave  
  e2:	c3                   	ret    

000000e3 <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
  e9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
  f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  f7:	00 
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	89 04 24             	mov    %eax,(%esp)
  fe:	e8 7d 07 00 00       	call   880 <open>
 103:	89 45 f0             	mov    %eax,-0x10(%ebp)
 106:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 10a:	79 20                	jns    12c <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
 10c:	8b 45 08             	mov    0x8(%ebp),%eax
 10f:	89 44 24 08          	mov    %eax,0x8(%esp)
 113:	c7 44 24 04 38 0e 00 	movl   $0xe38,0x4(%esp)
 11a:	00 
 11b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 122:	e8 1e 09 00 00       	call   a45 <printf>
      exit();
 127:	e8 14 07 00 00       	call   840 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 12c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 133:	00 
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 04 24             	mov    %eax,(%esp)
 13a:	e8 41 07 00 00       	call   880 <open>
 13f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 142:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 146:	79 20                	jns    168 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	89 44 24 08          	mov    %eax,0x8(%esp)
 14f:	c7 44 24 04 53 0e 00 	movl   $0xe53,0x4(%esp)
 156:	00 
 157:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 15e:	e8 e2 08 00 00       	call   a45 <printf>
      exit();
 163:	e8 d8 06 00 00       	call   840 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 168:	eb 3b                	jmp    1a5 <copy+0xc2>
  {
      max = used_disk+=count;
 16a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 16d:	01 45 10             	add    %eax,0x10(%ebp)
 170:	8b 45 10             	mov    0x10(%ebp),%eax
 173:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 179:	3b 45 14             	cmp    0x14(%ebp),%eax
 17c:	7e 07                	jle    185 <copy+0xa2>
      {
        return -1;
 17e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 183:	eb 5c                	jmp    1e1 <copy+0xfe>
      }
      bytes = bytes + count;
 185:	8b 45 e8             	mov    -0x18(%ebp),%eax
 188:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 18b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 192:	00 
 193:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 196:	89 44 24 04          	mov    %eax,0x4(%esp)
 19a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 19d:	89 04 24             	mov    %eax,(%esp)
 1a0:	e8 bb 06 00 00       	call   860 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 1a5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 1ac:	00 
 1ad:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1b7:	89 04 24             	mov    %eax,(%esp)
 1ba:	e8 99 06 00 00       	call   858 <read>
 1bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
 1c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1c6:	7f a2                	jg     16a <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 1c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cb:	89 04 24             	mov    %eax,(%esp)
 1ce:	e8 95 06 00 00       	call   868 <close>
  close(fd2);
 1d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1d6:	89 04 24             	mov    %eax,(%esp)
 1d9:	e8 8a 06 00 00       	call   868 <close>
  return(bytes);
 1de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1e1:	c9                   	leave  
 1e2:	c3                   	ret    

000001e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1e6:	eb 06                	jmp    1ee <strcmp+0xb>
    p++, q++;
 1e8:	ff 45 08             	incl   0x8(%ebp)
 1eb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ee:	8b 45 08             	mov    0x8(%ebp),%eax
 1f1:	8a 00                	mov    (%eax),%al
 1f3:	84 c0                	test   %al,%al
 1f5:	74 0e                	je     205 <strcmp+0x22>
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	8a 10                	mov    (%eax),%dl
 1fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ff:	8a 00                	mov    (%eax),%al
 201:	38 c2                	cmp    %al,%dl
 203:	74 e3                	je     1e8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	8a 00                	mov    (%eax),%al
 20a:	0f b6 d0             	movzbl %al,%edx
 20d:	8b 45 0c             	mov    0xc(%ebp),%eax
 210:	8a 00                	mov    (%eax),%al
 212:	0f b6 c0             	movzbl %al,%eax
 215:	29 c2                	sub    %eax,%edx
 217:	89 d0                	mov    %edx,%eax
}
 219:	5d                   	pop    %ebp
 21a:	c3                   	ret    

0000021b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 21b:	55                   	push   %ebp
 21c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 21e:	eb 09                	jmp    229 <strncmp+0xe>
    n--, p++, q++;
 220:	ff 4d 10             	decl   0x10(%ebp)
 223:	ff 45 08             	incl   0x8(%ebp)
 226:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 229:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 22d:	74 17                	je     246 <strncmp+0x2b>
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	8a 00                	mov    (%eax),%al
 234:	84 c0                	test   %al,%al
 236:	74 0e                	je     246 <strncmp+0x2b>
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	8a 10                	mov    (%eax),%dl
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	8a 00                	mov    (%eax),%al
 242:	38 c2                	cmp    %al,%dl
 244:	74 da                	je     220 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 246:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 24a:	75 07                	jne    253 <strncmp+0x38>
    return 0;
 24c:	b8 00 00 00 00       	mov    $0x0,%eax
 251:	eb 14                	jmp    267 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	8a 00                	mov    (%eax),%al
 258:	0f b6 d0             	movzbl %al,%edx
 25b:	8b 45 0c             	mov    0xc(%ebp),%eax
 25e:	8a 00                	mov    (%eax),%al
 260:	0f b6 c0             	movzbl %al,%eax
 263:	29 c2                	sub    %eax,%edx
 265:	89 d0                	mov    %edx,%eax
}
 267:	5d                   	pop    %ebp
 268:	c3                   	ret    

00000269 <strlen>:

uint
strlen(const char *s)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
 26c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 26f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 276:	eb 03                	jmp    27b <strlen+0x12>
 278:	ff 45 fc             	incl   -0x4(%ebp)
 27b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	01 d0                	add    %edx,%eax
 283:	8a 00                	mov    (%eax),%al
 285:	84 c0                	test   %al,%al
 287:	75 ef                	jne    278 <strlen+0xf>
    ;
  return n;
 289:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28c:	c9                   	leave  
 28d:	c3                   	ret    

0000028e <memset>:

void*
memset(void *dst, int c, uint n)
{
 28e:	55                   	push   %ebp
 28f:	89 e5                	mov    %esp,%ebp
 291:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 294:	8b 45 10             	mov    0x10(%ebp),%eax
 297:	89 44 24 08          	mov    %eax,0x8(%esp)
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a2:	8b 45 08             	mov    0x8(%ebp),%eax
 2a5:	89 04 24             	mov    %eax,(%esp)
 2a8:	e8 e3 fd ff ff       	call   90 <stosb>
  return dst;
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <strchr>:

char*
strchr(const char *s, char c)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 04             	sub    $0x4,%esp
 2b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2be:	eb 12                	jmp    2d2 <strchr+0x20>
    if(*s == c)
 2c0:	8b 45 08             	mov    0x8(%ebp),%eax
 2c3:	8a 00                	mov    (%eax),%al
 2c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2c8:	75 05                	jne    2cf <strchr+0x1d>
      return (char*)s;
 2ca:	8b 45 08             	mov    0x8(%ebp),%eax
 2cd:	eb 11                	jmp    2e0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2cf:	ff 45 08             	incl   0x8(%ebp)
 2d2:	8b 45 08             	mov    0x8(%ebp),%eax
 2d5:	8a 00                	mov    (%eax),%al
 2d7:	84 c0                	test   %al,%al
 2d9:	75 e5                	jne    2c0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2db:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <strcat>:

char *
strcat(char *dest, const char *src)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2ef:	eb 03                	jmp    2f4 <strcat+0x12>
 2f1:	ff 45 fc             	incl   -0x4(%ebp)
 2f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	01 d0                	add    %edx,%eax
 2fc:	8a 00                	mov    (%eax),%al
 2fe:	84 c0                	test   %al,%al
 300:	75 ef                	jne    2f1 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 302:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 309:	eb 1e                	jmp    329 <strcat+0x47>
        dest[i+j] = src[j];
 30b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 30e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 311:	01 d0                	add    %edx,%eax
 313:	89 c2                	mov    %eax,%edx
 315:	8b 45 08             	mov    0x8(%ebp),%eax
 318:	01 c2                	add    %eax,%edx
 31a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 31d:	8b 45 0c             	mov    0xc(%ebp),%eax
 320:	01 c8                	add    %ecx,%eax
 322:	8a 00                	mov    (%eax),%al
 324:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 326:	ff 45 f8             	incl   -0x8(%ebp)
 329:	8b 55 f8             	mov    -0x8(%ebp),%edx
 32c:	8b 45 0c             	mov    0xc(%ebp),%eax
 32f:	01 d0                	add    %edx,%eax
 331:	8a 00                	mov    (%eax),%al
 333:	84 c0                	test   %al,%al
 335:	75 d4                	jne    30b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 337:	8b 45 f8             	mov    -0x8(%ebp),%eax
 33a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33d:	01 d0                	add    %edx,%eax
 33f:	89 c2                	mov    %eax,%edx
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	01 d0                	add    %edx,%eax
 346:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 349:	8b 45 08             	mov    0x8(%ebp),%eax
}
 34c:	c9                   	leave  
 34d:	c3                   	ret    

0000034e <strstr>:

int 
strstr(char* s, char* sub)
{
 34e:	55                   	push   %ebp
 34f:	89 e5                	mov    %esp,%ebp
 351:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 354:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 35b:	eb 7c                	jmp    3d9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 35d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	01 d0                	add    %edx,%eax
 365:	8a 10                	mov    (%eax),%dl
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	8a 00                	mov    (%eax),%al
 36c:	38 c2                	cmp    %al,%dl
 36e:	75 66                	jne    3d6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 370:	8b 45 0c             	mov    0xc(%ebp),%eax
 373:	89 04 24             	mov    %eax,(%esp)
 376:	e8 ee fe ff ff       	call   269 <strlen>
 37b:	83 f8 01             	cmp    $0x1,%eax
 37e:	75 05                	jne    385 <strstr+0x37>
            {  
                return i;
 380:	8b 45 fc             	mov    -0x4(%ebp),%eax
 383:	eb 6b                	jmp    3f0 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 385:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 38c:	eb 3a                	jmp    3c8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 38e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 391:	8b 55 fc             	mov    -0x4(%ebp),%edx
 394:	01 d0                	add    %edx,%eax
 396:	89 c2                	mov    %eax,%edx
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	01 d0                	add    %edx,%eax
 39d:	8a 10                	mov    (%eax),%dl
 39f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a5:	01 c8                	add    %ecx,%eax
 3a7:	8a 00                	mov    (%eax),%al
 3a9:	38 c2                	cmp    %al,%dl
 3ab:	75 16                	jne    3c3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 3ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3b0:	8d 50 01             	lea    0x1(%eax),%edx
 3b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b6:	01 d0                	add    %edx,%eax
 3b8:	8a 00                	mov    (%eax),%al
 3ba:	84 c0                	test   %al,%al
 3bc:	75 07                	jne    3c5 <strstr+0x77>
                    {
                        return i;
 3be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c1:	eb 2d                	jmp    3f0 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3c3:	eb 11                	jmp    3d6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3c5:	ff 45 f8             	incl   -0x8(%ebp)
 3c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	01 d0                	add    %edx,%eax
 3d0:	8a 00                	mov    (%eax),%al
 3d2:	84 c0                	test   %al,%al
 3d4:	75 b8                	jne    38e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3d6:	ff 45 fc             	incl   -0x4(%ebp)
 3d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	01 d0                	add    %edx,%eax
 3e1:	8a 00                	mov    (%eax),%al
 3e3:	84 c0                	test   %al,%al
 3e5:	0f 85 72 ff ff ff    	jne    35d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 3eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3f0:	c9                   	leave  
 3f1:	c3                   	ret    

000003f2 <strtok>:

char *
strtok(char *s, const char *delim)
{
 3f2:	55                   	push   %ebp
 3f3:	89 e5                	mov    %esp,%ebp
 3f5:	53                   	push   %ebx
 3f6:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3fd:	75 08                	jne    407 <strtok+0x15>
  s = lasts;
 3ff:	a1 64 12 00 00       	mov    0x1264,%eax
 404:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 407:	8b 45 08             	mov    0x8(%ebp),%eax
 40a:	8d 50 01             	lea    0x1(%eax),%edx
 40d:	89 55 08             	mov    %edx,0x8(%ebp)
 410:	8a 00                	mov    (%eax),%al
 412:	0f be d8             	movsbl %al,%ebx
 415:	85 db                	test   %ebx,%ebx
 417:	75 07                	jne    420 <strtok+0x2e>
      return 0;
 419:	b8 00 00 00 00       	mov    $0x0,%eax
 41e:	eb 58                	jmp    478 <strtok+0x86>
    } while (strchr(delim, ch));
 420:	88 d8                	mov    %bl,%al
 422:	0f be c0             	movsbl %al,%eax
 425:	89 44 24 04          	mov    %eax,0x4(%esp)
 429:	8b 45 0c             	mov    0xc(%ebp),%eax
 42c:	89 04 24             	mov    %eax,(%esp)
 42f:	e8 7e fe ff ff       	call   2b2 <strchr>
 434:	85 c0                	test   %eax,%eax
 436:	75 cf                	jne    407 <strtok+0x15>
    --s;
 438:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 43b:	8b 45 0c             	mov    0xc(%ebp),%eax
 43e:	89 44 24 04          	mov    %eax,0x4(%esp)
 442:	8b 45 08             	mov    0x8(%ebp),%eax
 445:	89 04 24             	mov    %eax,(%esp)
 448:	e8 31 00 00 00       	call   47e <strcspn>
 44d:	89 c2                	mov    %eax,%edx
 44f:	8b 45 08             	mov    0x8(%ebp),%eax
 452:	01 d0                	add    %edx,%eax
 454:	a3 64 12 00 00       	mov    %eax,0x1264
    if (*lasts != 0)
 459:	a1 64 12 00 00       	mov    0x1264,%eax
 45e:	8a 00                	mov    (%eax),%al
 460:	84 c0                	test   %al,%al
 462:	74 11                	je     475 <strtok+0x83>
  *lasts++ = 0;
 464:	a1 64 12 00 00       	mov    0x1264,%eax
 469:	8d 50 01             	lea    0x1(%eax),%edx
 46c:	89 15 64 12 00 00    	mov    %edx,0x1264
 472:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 475:	8b 45 08             	mov    0x8(%ebp),%eax
}
 478:	83 c4 14             	add    $0x14,%esp
 47b:	5b                   	pop    %ebx
 47c:	5d                   	pop    %ebp
 47d:	c3                   	ret    

0000047e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 47e:	55                   	push   %ebp
 47f:	89 e5                	mov    %esp,%ebp
 481:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 484:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 48b:	eb 26                	jmp    4b3 <strcspn+0x35>
        if(strchr(s2,*s1))
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
 490:	8a 00                	mov    (%eax),%al
 492:	0f be c0             	movsbl %al,%eax
 495:	89 44 24 04          	mov    %eax,0x4(%esp)
 499:	8b 45 0c             	mov    0xc(%ebp),%eax
 49c:	89 04 24             	mov    %eax,(%esp)
 49f:	e8 0e fe ff ff       	call   2b2 <strchr>
 4a4:	85 c0                	test   %eax,%eax
 4a6:	74 05                	je     4ad <strcspn+0x2f>
            return ret;
 4a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4ab:	eb 12                	jmp    4bf <strcspn+0x41>
        else
            s1++,ret++;
 4ad:	ff 45 08             	incl   0x8(%ebp)
 4b0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	8a 00                	mov    (%eax),%al
 4b8:	84 c0                	test   %al,%al
 4ba:	75 d1                	jne    48d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4bf:	c9                   	leave  
 4c0:	c3                   	ret    

000004c1 <isspace>:

int
isspace(unsigned char c)
{
 4c1:	55                   	push   %ebp
 4c2:	89 e5                	mov    %esp,%ebp
 4c4:	83 ec 04             	sub    $0x4,%esp
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4cd:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4d1:	74 1e                	je     4f1 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4d3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4d7:	74 18                	je     4f1 <isspace+0x30>
 4d9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4dd:	74 12                	je     4f1 <isspace+0x30>
 4df:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4e3:	74 0c                	je     4f1 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4e5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 4e9:	74 06                	je     4f1 <isspace+0x30>
 4eb:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 4ef:	75 07                	jne    4f8 <isspace+0x37>
 4f1:	b8 01 00 00 00       	mov    $0x1,%eax
 4f6:	eb 05                	jmp    4fd <isspace+0x3c>
 4f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4fd:	c9                   	leave  
 4fe:	c3                   	ret    

000004ff <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4ff:	55                   	push   %ebp
 500:	89 e5                	mov    %esp,%ebp
 502:	57                   	push   %edi
 503:	56                   	push   %esi
 504:	53                   	push   %ebx
 505:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 508:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 50d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 514:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 517:	eb 01                	jmp    51a <strtoul+0x1b>
  p += 1;
 519:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 51a:	8a 03                	mov    (%ebx),%al
 51c:	0f b6 c0             	movzbl %al,%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 9a ff ff ff       	call   4c1 <isspace>
 527:	85 c0                	test   %eax,%eax
 529:	75 ee                	jne    519 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 52b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 52f:	75 30                	jne    561 <strtoul+0x62>
    {
  if (*p == '0') {
 531:	8a 03                	mov    (%ebx),%al
 533:	3c 30                	cmp    $0x30,%al
 535:	75 21                	jne    558 <strtoul+0x59>
      p += 1;
 537:	43                   	inc    %ebx
      if (*p == 'x') {
 538:	8a 03                	mov    (%ebx),%al
 53a:	3c 78                	cmp    $0x78,%al
 53c:	75 0a                	jne    548 <strtoul+0x49>
    p += 1;
 53e:	43                   	inc    %ebx
    base = 16;
 53f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 546:	eb 31                	jmp    579 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 548:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 54f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 556:	eb 21                	jmp    579 <strtoul+0x7a>
      }
  }
  else base = 10;
 558:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 55f:	eb 18                	jmp    579 <strtoul+0x7a>
    } else if (base == 16) {
 561:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 565:	75 12                	jne    579 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 567:	8a 03                	mov    (%ebx),%al
 569:	3c 30                	cmp    $0x30,%al
 56b:	75 0c                	jne    579 <strtoul+0x7a>
 56d:	8d 43 01             	lea    0x1(%ebx),%eax
 570:	8a 00                	mov    (%eax),%al
 572:	3c 78                	cmp    $0x78,%al
 574:	75 03                	jne    579 <strtoul+0x7a>
      p += 2;
 576:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 579:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 57d:	75 29                	jne    5a8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 57f:	8a 03                	mov    (%ebx),%al
 581:	0f be c0             	movsbl %al,%eax
 584:	83 e8 30             	sub    $0x30,%eax
 587:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 589:	83 fe 07             	cmp    $0x7,%esi
 58c:	76 06                	jbe    594 <strtoul+0x95>
    break;
 58e:	90                   	nop
 58f:	e9 b6 00 00 00       	jmp    64a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 594:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 59b:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 59e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 5a5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 5a6:	eb d7                	jmp    57f <strtoul+0x80>
    } else if (base == 10) {
 5a8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 5ac:	75 2b                	jne    5d9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5ae:	8a 03                	mov    (%ebx),%al
 5b0:	0f be c0             	movsbl %al,%eax
 5b3:	83 e8 30             	sub    $0x30,%eax
 5b6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5b8:	83 fe 09             	cmp    $0x9,%esi
 5bb:	76 06                	jbe    5c3 <strtoul+0xc4>
    break;
 5bd:	90                   	nop
 5be:	e9 87 00 00 00       	jmp    64a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5c3:	89 f8                	mov    %edi,%eax
 5c5:	c1 e0 02             	shl    $0x2,%eax
 5c8:	01 f8                	add    %edi,%eax
 5ca:	01 c0                	add    %eax,%eax
 5cc:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5d6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5d7:	eb d5                	jmp    5ae <strtoul+0xaf>
    } else if (base == 16) {
 5d9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5dd:	75 35                	jne    614 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5df:	8a 03                	mov    (%ebx),%al
 5e1:	0f be c0             	movsbl %al,%eax
 5e4:	83 e8 30             	sub    $0x30,%eax
 5e7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5e9:	83 fe 4a             	cmp    $0x4a,%esi
 5ec:	76 02                	jbe    5f0 <strtoul+0xf1>
    break;
 5ee:	eb 22                	jmp    612 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 5f0:	8a 86 00 12 00 00    	mov    0x1200(%esi),%al
 5f6:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5f9:	83 fe 0f             	cmp    $0xf,%esi
 5fc:	76 02                	jbe    600 <strtoul+0x101>
    break;
 5fe:	eb 12                	jmp    612 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 600:	89 f8                	mov    %edi,%eax
 602:	c1 e0 04             	shl    $0x4,%eax
 605:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 608:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 60f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 610:	eb cd                	jmp    5df <strtoul+0xe0>
 612:	eb 36                	jmp    64a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 614:	8a 03                	mov    (%ebx),%al
 616:	0f be c0             	movsbl %al,%eax
 619:	83 e8 30             	sub    $0x30,%eax
 61c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 61e:	83 fe 4a             	cmp    $0x4a,%esi
 621:	76 02                	jbe    625 <strtoul+0x126>
    break;
 623:	eb 25                	jmp    64a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 625:	8a 86 00 12 00 00    	mov    0x1200(%esi),%al
 62b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 62e:	8b 45 10             	mov    0x10(%ebp),%eax
 631:	39 f0                	cmp    %esi,%eax
 633:	77 02                	ja     637 <strtoul+0x138>
    break;
 635:	eb 13                	jmp    64a <strtoul+0x14b>
      }
      result = result*base + digit;
 637:	8b 45 10             	mov    0x10(%ebp),%eax
 63a:	0f af c7             	imul   %edi,%eax
 63d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 640:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 647:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 648:	eb ca                	jmp    614 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 64a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 64e:	75 03                	jne    653 <strtoul+0x154>
  p = string;
 650:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 653:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 657:	74 05                	je     65e <strtoul+0x15f>
  *endPtr = p;
 659:	8b 45 0c             	mov    0xc(%ebp),%eax
 65c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 65e:	89 f8                	mov    %edi,%eax
}
 660:	83 c4 14             	add    $0x14,%esp
 663:	5b                   	pop    %ebx
 664:	5e                   	pop    %esi
 665:	5f                   	pop    %edi
 666:	5d                   	pop    %ebp
 667:	c3                   	ret    

00000668 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 668:	55                   	push   %ebp
 669:	89 e5                	mov    %esp,%ebp
 66b:	53                   	push   %ebx
 66c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 66f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 672:	eb 01                	jmp    675 <strtol+0xd>
      p += 1;
 674:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 675:	8a 03                	mov    (%ebx),%al
 677:	0f b6 c0             	movzbl %al,%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 3f fe ff ff       	call   4c1 <isspace>
 682:	85 c0                	test   %eax,%eax
 684:	75 ee                	jne    674 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 686:	8a 03                	mov    (%ebx),%al
 688:	3c 2d                	cmp    $0x2d,%al
 68a:	75 1e                	jne    6aa <strtol+0x42>
  p += 1;
 68c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 68d:	8b 45 10             	mov    0x10(%ebp),%eax
 690:	89 44 24 08          	mov    %eax,0x8(%esp)
 694:	8b 45 0c             	mov    0xc(%ebp),%eax
 697:	89 44 24 04          	mov    %eax,0x4(%esp)
 69b:	89 1c 24             	mov    %ebx,(%esp)
 69e:	e8 5c fe ff ff       	call   4ff <strtoul>
 6a3:	f7 d8                	neg    %eax
 6a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6a8:	eb 20                	jmp    6ca <strtol+0x62>
    } else {
  if (*p == '+') {
 6aa:	8a 03                	mov    (%ebx),%al
 6ac:	3c 2b                	cmp    $0x2b,%al
 6ae:	75 01                	jne    6b1 <strtol+0x49>
      p += 1;
 6b0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6b1:	8b 45 10             	mov    0x10(%ebp),%eax
 6b4:	89 44 24 08          	mov    %eax,0x8(%esp)
 6b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bf:	89 1c 24             	mov    %ebx,(%esp)
 6c2:	e8 38 fe ff ff       	call   4ff <strtoul>
 6c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6ce:	75 17                	jne    6e7 <strtol+0x7f>
 6d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6d4:	74 11                	je     6e7 <strtol+0x7f>
 6d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d9:	8b 00                	mov    (%eax),%eax
 6db:	39 d8                	cmp    %ebx,%eax
 6dd:	75 08                	jne    6e7 <strtol+0x7f>
  *endPtr = string;
 6df:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e2:	8b 55 08             	mov    0x8(%ebp),%edx
 6e5:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 6ea:	83 c4 1c             	add    $0x1c,%esp
 6ed:	5b                   	pop    %ebx
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret    

000006f0 <gets>:

char*
gets(char *buf, int max)
{
 6f0:	55                   	push   %ebp
 6f1:	89 e5                	mov    %esp,%ebp
 6f3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6fd:	eb 49                	jmp    748 <gets+0x58>
    cc = read(0, &c, 1);
 6ff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 706:	00 
 707:	8d 45 ef             	lea    -0x11(%ebp),%eax
 70a:	89 44 24 04          	mov    %eax,0x4(%esp)
 70e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 715:	e8 3e 01 00 00       	call   858 <read>
 71a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 71d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 721:	7f 02                	jg     725 <gets+0x35>
      break;
 723:	eb 2c                	jmp    751 <gets+0x61>
    buf[i++] = c;
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	8d 50 01             	lea    0x1(%eax),%edx
 72b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 72e:	89 c2                	mov    %eax,%edx
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	01 c2                	add    %eax,%edx
 735:	8a 45 ef             	mov    -0x11(%ebp),%al
 738:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 73a:	8a 45 ef             	mov    -0x11(%ebp),%al
 73d:	3c 0a                	cmp    $0xa,%al
 73f:	74 10                	je     751 <gets+0x61>
 741:	8a 45 ef             	mov    -0x11(%ebp),%al
 744:	3c 0d                	cmp    $0xd,%al
 746:	74 09                	je     751 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 748:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74b:	40                   	inc    %eax
 74c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 74f:	7c ae                	jl     6ff <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 751:	8b 55 f4             	mov    -0xc(%ebp),%edx
 754:	8b 45 08             	mov    0x8(%ebp),%eax
 757:	01 d0                	add    %edx,%eax
 759:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 75c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 75f:	c9                   	leave  
 760:	c3                   	ret    

00000761 <stat>:

int
stat(char *n, struct stat *st)
{
 761:	55                   	push   %ebp
 762:	89 e5                	mov    %esp,%ebp
 764:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 767:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 76e:	00 
 76f:	8b 45 08             	mov    0x8(%ebp),%eax
 772:	89 04 24             	mov    %eax,(%esp)
 775:	e8 06 01 00 00       	call   880 <open>
 77a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 77d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 781:	79 07                	jns    78a <stat+0x29>
    return -1;
 783:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 788:	eb 23                	jmp    7ad <stat+0x4c>
  r = fstat(fd, st);
 78a:	8b 45 0c             	mov    0xc(%ebp),%eax
 78d:	89 44 24 04          	mov    %eax,0x4(%esp)
 791:	8b 45 f4             	mov    -0xc(%ebp),%eax
 794:	89 04 24             	mov    %eax,(%esp)
 797:	e8 fc 00 00 00       	call   898 <fstat>
 79c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a2:	89 04 24             	mov    %eax,(%esp)
 7a5:	e8 be 00 00 00       	call   868 <close>
  return r;
 7aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7ad:	c9                   	leave  
 7ae:	c3                   	ret    

000007af <atoi>:

int
atoi(const char *s)
{
 7af:	55                   	push   %ebp
 7b0:	89 e5                	mov    %esp,%ebp
 7b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7bc:	eb 24                	jmp    7e2 <atoi+0x33>
    n = n*10 + *s++ - '0';
 7be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7c1:	89 d0                	mov    %edx,%eax
 7c3:	c1 e0 02             	shl    $0x2,%eax
 7c6:	01 d0                	add    %edx,%eax
 7c8:	01 c0                	add    %eax,%eax
 7ca:	89 c1                	mov    %eax,%ecx
 7cc:	8b 45 08             	mov    0x8(%ebp),%eax
 7cf:	8d 50 01             	lea    0x1(%eax),%edx
 7d2:	89 55 08             	mov    %edx,0x8(%ebp)
 7d5:	8a 00                	mov    (%eax),%al
 7d7:	0f be c0             	movsbl %al,%eax
 7da:	01 c8                	add    %ecx,%eax
 7dc:	83 e8 30             	sub    $0x30,%eax
 7df:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7e2:	8b 45 08             	mov    0x8(%ebp),%eax
 7e5:	8a 00                	mov    (%eax),%al
 7e7:	3c 2f                	cmp    $0x2f,%al
 7e9:	7e 09                	jle    7f4 <atoi+0x45>
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	8a 00                	mov    (%eax),%al
 7f0:	3c 39                	cmp    $0x39,%al
 7f2:	7e ca                	jle    7be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7f7:	c9                   	leave  
 7f8:	c3                   	ret    

000007f9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7f9:	55                   	push   %ebp
 7fa:	89 e5                	mov    %esp,%ebp
 7fc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7ff:	8b 45 08             	mov    0x8(%ebp),%eax
 802:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 805:	8b 45 0c             	mov    0xc(%ebp),%eax
 808:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 80b:	eb 16                	jmp    823 <memmove+0x2a>
    *dst++ = *src++;
 80d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 810:	8d 50 01             	lea    0x1(%eax),%edx
 813:	89 55 fc             	mov    %edx,-0x4(%ebp)
 816:	8b 55 f8             	mov    -0x8(%ebp),%edx
 819:	8d 4a 01             	lea    0x1(%edx),%ecx
 81c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 81f:	8a 12                	mov    (%edx),%dl
 821:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 823:	8b 45 10             	mov    0x10(%ebp),%eax
 826:	8d 50 ff             	lea    -0x1(%eax),%edx
 829:	89 55 10             	mov    %edx,0x10(%ebp)
 82c:	85 c0                	test   %eax,%eax
 82e:	7f dd                	jg     80d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 830:	8b 45 08             	mov    0x8(%ebp),%eax
}
 833:	c9                   	leave  
 834:	c3                   	ret    
 835:	90                   	nop
 836:	90                   	nop
 837:	90                   	nop

00000838 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 838:	b8 01 00 00 00       	mov    $0x1,%eax
 83d:	cd 40                	int    $0x40
 83f:	c3                   	ret    

00000840 <exit>:
SYSCALL(exit)
 840:	b8 02 00 00 00       	mov    $0x2,%eax
 845:	cd 40                	int    $0x40
 847:	c3                   	ret    

00000848 <wait>:
SYSCALL(wait)
 848:	b8 03 00 00 00       	mov    $0x3,%eax
 84d:	cd 40                	int    $0x40
 84f:	c3                   	ret    

00000850 <pipe>:
SYSCALL(pipe)
 850:	b8 04 00 00 00       	mov    $0x4,%eax
 855:	cd 40                	int    $0x40
 857:	c3                   	ret    

00000858 <read>:
SYSCALL(read)
 858:	b8 05 00 00 00       	mov    $0x5,%eax
 85d:	cd 40                	int    $0x40
 85f:	c3                   	ret    

00000860 <write>:
SYSCALL(write)
 860:	b8 10 00 00 00       	mov    $0x10,%eax
 865:	cd 40                	int    $0x40
 867:	c3                   	ret    

00000868 <close>:
SYSCALL(close)
 868:	b8 15 00 00 00       	mov    $0x15,%eax
 86d:	cd 40                	int    $0x40
 86f:	c3                   	ret    

00000870 <kill>:
SYSCALL(kill)
 870:	b8 06 00 00 00       	mov    $0x6,%eax
 875:	cd 40                	int    $0x40
 877:	c3                   	ret    

00000878 <exec>:
SYSCALL(exec)
 878:	b8 07 00 00 00       	mov    $0x7,%eax
 87d:	cd 40                	int    $0x40
 87f:	c3                   	ret    

00000880 <open>:
SYSCALL(open)
 880:	b8 0f 00 00 00       	mov    $0xf,%eax
 885:	cd 40                	int    $0x40
 887:	c3                   	ret    

00000888 <mknod>:
SYSCALL(mknod)
 888:	b8 11 00 00 00       	mov    $0x11,%eax
 88d:	cd 40                	int    $0x40
 88f:	c3                   	ret    

00000890 <unlink>:
SYSCALL(unlink)
 890:	b8 12 00 00 00       	mov    $0x12,%eax
 895:	cd 40                	int    $0x40
 897:	c3                   	ret    

00000898 <fstat>:
SYSCALL(fstat)
 898:	b8 08 00 00 00       	mov    $0x8,%eax
 89d:	cd 40                	int    $0x40
 89f:	c3                   	ret    

000008a0 <link>:
SYSCALL(link)
 8a0:	b8 13 00 00 00       	mov    $0x13,%eax
 8a5:	cd 40                	int    $0x40
 8a7:	c3                   	ret    

000008a8 <mkdir>:
SYSCALL(mkdir)
 8a8:	b8 14 00 00 00       	mov    $0x14,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <chdir>:
SYSCALL(chdir)
 8b0:	b8 09 00 00 00       	mov    $0x9,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <dup>:
SYSCALL(dup)
 8b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <getpid>:
SYSCALL(getpid)
 8c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <sbrk>:
SYSCALL(sbrk)
 8c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <sleep>:
SYSCALL(sleep)
 8d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <uptime>:
SYSCALL(uptime)
 8d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <getname>:
SYSCALL(getname)
 8e0:	b8 16 00 00 00       	mov    $0x16,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <setname>:
SYSCALL(setname)
 8e8:	b8 17 00 00 00       	mov    $0x17,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <getmaxproc>:
SYSCALL(getmaxproc)
 8f0:	b8 18 00 00 00       	mov    $0x18,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <setmaxproc>:
SYSCALL(setmaxproc)
 8f8:	b8 19 00 00 00       	mov    $0x19,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <getmaxmem>:
SYSCALL(getmaxmem)
 900:	b8 1a 00 00 00       	mov    $0x1a,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <setmaxmem>:
SYSCALL(setmaxmem)
 908:	b8 1b 00 00 00       	mov    $0x1b,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <getmaxdisk>:
SYSCALL(getmaxdisk)
 910:	b8 1c 00 00 00       	mov    $0x1c,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <setmaxdisk>:
SYSCALL(setmaxdisk)
 918:	b8 1d 00 00 00       	mov    $0x1d,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <getusedmem>:
SYSCALL(getusedmem)
 920:	b8 1e 00 00 00       	mov    $0x1e,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <setusedmem>:
SYSCALL(setusedmem)
 928:	b8 1f 00 00 00       	mov    $0x1f,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <getuseddisk>:
SYSCALL(getuseddisk)
 930:	b8 20 00 00 00       	mov    $0x20,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <setuseddisk>:
SYSCALL(setuseddisk)
 938:	b8 21 00 00 00       	mov    $0x21,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <setvc>:
SYSCALL(setvc)
 940:	b8 22 00 00 00       	mov    $0x22,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <setactivefs>:
SYSCALL(setactivefs)
 948:	b8 24 00 00 00       	mov    $0x24,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <getactivefs>:
SYSCALL(getactivefs)
 950:	b8 25 00 00 00       	mov    $0x25,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <getvcfs>:
SYSCALL(getvcfs)
 958:	b8 23 00 00 00       	mov    $0x23,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <getcwd>:
SYSCALL(getcwd)
 960:	b8 26 00 00 00       	mov    $0x26,%eax
 965:	cd 40                	int    $0x40
 967:	c3                   	ret    

00000968 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 968:	55                   	push   %ebp
 969:	89 e5                	mov    %esp,%ebp
 96b:	83 ec 18             	sub    $0x18,%esp
 96e:	8b 45 0c             	mov    0xc(%ebp),%eax
 971:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 974:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 97b:	00 
 97c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 97f:	89 44 24 04          	mov    %eax,0x4(%esp)
 983:	8b 45 08             	mov    0x8(%ebp),%eax
 986:	89 04 24             	mov    %eax,(%esp)
 989:	e8 d2 fe ff ff       	call   860 <write>
}
 98e:	c9                   	leave  
 98f:	c3                   	ret    

00000990 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 990:	55                   	push   %ebp
 991:	89 e5                	mov    %esp,%ebp
 993:	56                   	push   %esi
 994:	53                   	push   %ebx
 995:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 998:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 99f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9a3:	74 17                	je     9bc <printint+0x2c>
 9a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9a9:	79 11                	jns    9bc <printint+0x2c>
    neg = 1;
 9ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 9b5:	f7 d8                	neg    %eax
 9b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9ba:	eb 06                	jmp    9c2 <printint+0x32>
  } else {
    x = xx;
 9bc:	8b 45 0c             	mov    0xc(%ebp),%eax
 9bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9c2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9c9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9cc:	8d 41 01             	lea    0x1(%ecx),%eax
 9cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9d8:	ba 00 00 00 00       	mov    $0x0,%edx
 9dd:	f7 f3                	div    %ebx
 9df:	89 d0                	mov    %edx,%eax
 9e1:	8a 80 4c 12 00 00    	mov    0x124c(%eax),%al
 9e7:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9eb:	8b 75 10             	mov    0x10(%ebp),%esi
 9ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9f1:	ba 00 00 00 00       	mov    $0x0,%edx
 9f6:	f7 f6                	div    %esi
 9f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9fb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9ff:	75 c8                	jne    9c9 <printint+0x39>
  if(neg)
 a01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a05:	74 10                	je     a17 <printint+0x87>
    buf[i++] = '-';
 a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0a:	8d 50 01             	lea    0x1(%eax),%edx
 a0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a10:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a15:	eb 1e                	jmp    a35 <printint+0xa5>
 a17:	eb 1c                	jmp    a35 <printint+0xa5>
    putc(fd, buf[i]);
 a19:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1f:	01 d0                	add    %edx,%eax
 a21:	8a 00                	mov    (%eax),%al
 a23:	0f be c0             	movsbl %al,%eax
 a26:	89 44 24 04          	mov    %eax,0x4(%esp)
 a2a:	8b 45 08             	mov    0x8(%ebp),%eax
 a2d:	89 04 24             	mov    %eax,(%esp)
 a30:	e8 33 ff ff ff       	call   968 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a35:	ff 4d f4             	decl   -0xc(%ebp)
 a38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a3c:	79 db                	jns    a19 <printint+0x89>
    putc(fd, buf[i]);
}
 a3e:	83 c4 30             	add    $0x30,%esp
 a41:	5b                   	pop    %ebx
 a42:	5e                   	pop    %esi
 a43:	5d                   	pop    %ebp
 a44:	c3                   	ret    

00000a45 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a45:	55                   	push   %ebp
 a46:	89 e5                	mov    %esp,%ebp
 a48:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a4b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a52:	8d 45 0c             	lea    0xc(%ebp),%eax
 a55:	83 c0 04             	add    $0x4,%eax
 a58:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a5b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a62:	e9 77 01 00 00       	jmp    bde <printf+0x199>
    c = fmt[i] & 0xff;
 a67:	8b 55 0c             	mov    0xc(%ebp),%edx
 a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6d:	01 d0                	add    %edx,%eax
 a6f:	8a 00                	mov    (%eax),%al
 a71:	0f be c0             	movsbl %al,%eax
 a74:	25 ff 00 00 00       	and    $0xff,%eax
 a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a7c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a80:	75 2c                	jne    aae <printf+0x69>
      if(c == '%'){
 a82:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a86:	75 0c                	jne    a94 <printf+0x4f>
        state = '%';
 a88:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a8f:	e9 47 01 00 00       	jmp    bdb <printf+0x196>
      } else {
        putc(fd, c);
 a94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a97:	0f be c0             	movsbl %al,%eax
 a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
 a9e:	8b 45 08             	mov    0x8(%ebp),%eax
 aa1:	89 04 24             	mov    %eax,(%esp)
 aa4:	e8 bf fe ff ff       	call   968 <putc>
 aa9:	e9 2d 01 00 00       	jmp    bdb <printf+0x196>
      }
    } else if(state == '%'){
 aae:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 ab2:	0f 85 23 01 00 00    	jne    bdb <printf+0x196>
      if(c == 'd'){
 ab8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 abc:	75 2d                	jne    aeb <printf+0xa6>
        printint(fd, *ap, 10, 1);
 abe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ac1:	8b 00                	mov    (%eax),%eax
 ac3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 aca:	00 
 acb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 ad2:	00 
 ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
 ad7:	8b 45 08             	mov    0x8(%ebp),%eax
 ada:	89 04 24             	mov    %eax,(%esp)
 add:	e8 ae fe ff ff       	call   990 <printint>
        ap++;
 ae2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ae6:	e9 e9 00 00 00       	jmp    bd4 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 aeb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 aef:	74 06                	je     af7 <printf+0xb2>
 af1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 af5:	75 2d                	jne    b24 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 afa:	8b 00                	mov    (%eax),%eax
 afc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 b03:	00 
 b04:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b0b:	00 
 b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
 b10:	8b 45 08             	mov    0x8(%ebp),%eax
 b13:	89 04 24             	mov    %eax,(%esp)
 b16:	e8 75 fe ff ff       	call   990 <printint>
        ap++;
 b1b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b1f:	e9 b0 00 00 00       	jmp    bd4 <printf+0x18f>
      } else if(c == 's'){
 b24:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b28:	75 42                	jne    b6c <printf+0x127>
        s = (char*)*ap;
 b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b2d:	8b 00                	mov    (%eax),%eax
 b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b32:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b36:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b3a:	75 09                	jne    b45 <printf+0x100>
          s = "(null)";
 b3c:	c7 45 f4 6f 0e 00 00 	movl   $0xe6f,-0xc(%ebp)
        while(*s != 0){
 b43:	eb 1c                	jmp    b61 <printf+0x11c>
 b45:	eb 1a                	jmp    b61 <printf+0x11c>
          putc(fd, *s);
 b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4a:	8a 00                	mov    (%eax),%al
 b4c:	0f be c0             	movsbl %al,%eax
 b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
 b53:	8b 45 08             	mov    0x8(%ebp),%eax
 b56:	89 04 24             	mov    %eax,(%esp)
 b59:	e8 0a fe ff ff       	call   968 <putc>
          s++;
 b5e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b64:	8a 00                	mov    (%eax),%al
 b66:	84 c0                	test   %al,%al
 b68:	75 dd                	jne    b47 <printf+0x102>
 b6a:	eb 68                	jmp    bd4 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b6c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b70:	75 1d                	jne    b8f <printf+0x14a>
        putc(fd, *ap);
 b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b75:	8b 00                	mov    (%eax),%eax
 b77:	0f be c0             	movsbl %al,%eax
 b7a:	89 44 24 04          	mov    %eax,0x4(%esp)
 b7e:	8b 45 08             	mov    0x8(%ebp),%eax
 b81:	89 04 24             	mov    %eax,(%esp)
 b84:	e8 df fd ff ff       	call   968 <putc>
        ap++;
 b89:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b8d:	eb 45                	jmp    bd4 <printf+0x18f>
      } else if(c == '%'){
 b8f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b93:	75 17                	jne    bac <printf+0x167>
        putc(fd, c);
 b95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b98:	0f be c0             	movsbl %al,%eax
 b9b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b9f:	8b 45 08             	mov    0x8(%ebp),%eax
 ba2:	89 04 24             	mov    %eax,(%esp)
 ba5:	e8 be fd ff ff       	call   968 <putc>
 baa:	eb 28                	jmp    bd4 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 bac:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 bb3:	00 
 bb4:	8b 45 08             	mov    0x8(%ebp),%eax
 bb7:	89 04 24             	mov    %eax,(%esp)
 bba:	e8 a9 fd ff ff       	call   968 <putc>
        putc(fd, c);
 bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bc2:	0f be c0             	movsbl %al,%eax
 bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
 bc9:	8b 45 08             	mov    0x8(%ebp),%eax
 bcc:	89 04 24             	mov    %eax,(%esp)
 bcf:	e8 94 fd ff ff       	call   968 <putc>
      }
      state = 0;
 bd4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bdb:	ff 45 f0             	incl   -0x10(%ebp)
 bde:	8b 55 0c             	mov    0xc(%ebp),%edx
 be1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be4:	01 d0                	add    %edx,%eax
 be6:	8a 00                	mov    (%eax),%al
 be8:	84 c0                	test   %al,%al
 bea:	0f 85 77 fe ff ff    	jne    a67 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bf0:	c9                   	leave  
 bf1:	c3                   	ret    
 bf2:	90                   	nop
 bf3:	90                   	nop

00000bf4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bf4:	55                   	push   %ebp
 bf5:	89 e5                	mov    %esp,%ebp
 bf7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bfa:	8b 45 08             	mov    0x8(%ebp),%eax
 bfd:	83 e8 08             	sub    $0x8,%eax
 c00:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c03:	a1 70 12 00 00       	mov    0x1270,%eax
 c08:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c0b:	eb 24                	jmp    c31 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c10:	8b 00                	mov    (%eax),%eax
 c12:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c15:	77 12                	ja     c29 <free+0x35>
 c17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c1a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c1d:	77 24                	ja     c43 <free+0x4f>
 c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c22:	8b 00                	mov    (%eax),%eax
 c24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c27:	77 1a                	ja     c43 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2c:	8b 00                	mov    (%eax),%eax
 c2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c31:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c34:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c37:	76 d4                	jbe    c0d <free+0x19>
 c39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3c:	8b 00                	mov    (%eax),%eax
 c3e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c41:	76 ca                	jbe    c0d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c46:	8b 40 04             	mov    0x4(%eax),%eax
 c49:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c50:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c53:	01 c2                	add    %eax,%edx
 c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c58:	8b 00                	mov    (%eax),%eax
 c5a:	39 c2                	cmp    %eax,%edx
 c5c:	75 24                	jne    c82 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c5e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c61:	8b 50 04             	mov    0x4(%eax),%edx
 c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c67:	8b 00                	mov    (%eax),%eax
 c69:	8b 40 04             	mov    0x4(%eax),%eax
 c6c:	01 c2                	add    %eax,%edx
 c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c71:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c74:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c77:	8b 00                	mov    (%eax),%eax
 c79:	8b 10                	mov    (%eax),%edx
 c7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7e:	89 10                	mov    %edx,(%eax)
 c80:	eb 0a                	jmp    c8c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c82:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c85:	8b 10                	mov    (%eax),%edx
 c87:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c8f:	8b 40 04             	mov    0x4(%eax),%eax
 c92:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c99:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9c:	01 d0                	add    %edx,%eax
 c9e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ca1:	75 20                	jne    cc3 <free+0xcf>
    p->s.size += bp->s.size;
 ca3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca6:	8b 50 04             	mov    0x4(%eax),%edx
 ca9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cac:	8b 40 04             	mov    0x4(%eax),%eax
 caf:	01 c2                	add    %eax,%edx
 cb1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cba:	8b 10                	mov    (%eax),%edx
 cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbf:	89 10                	mov    %edx,(%eax)
 cc1:	eb 08                	jmp    ccb <free+0xd7>
  } else
    p->s.ptr = bp;
 cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 cc9:	89 10                	mov    %edx,(%eax)
  freep = p;
 ccb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cce:	a3 70 12 00 00       	mov    %eax,0x1270
}
 cd3:	c9                   	leave  
 cd4:	c3                   	ret    

00000cd5 <morecore>:

static Header*
morecore(uint nu)
{
 cd5:	55                   	push   %ebp
 cd6:	89 e5                	mov    %esp,%ebp
 cd8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 cdb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ce2:	77 07                	ja     ceb <morecore+0x16>
    nu = 4096;
 ce4:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 ceb:	8b 45 08             	mov    0x8(%ebp),%eax
 cee:	c1 e0 03             	shl    $0x3,%eax
 cf1:	89 04 24             	mov    %eax,(%esp)
 cf4:	e8 cf fb ff ff       	call   8c8 <sbrk>
 cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cfc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d00:	75 07                	jne    d09 <morecore+0x34>
    return 0;
 d02:	b8 00 00 00 00       	mov    $0x0,%eax
 d07:	eb 22                	jmp    d2b <morecore+0x56>
  hp = (Header*)p;
 d09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d12:	8b 55 08             	mov    0x8(%ebp),%edx
 d15:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d1b:	83 c0 08             	add    $0x8,%eax
 d1e:	89 04 24             	mov    %eax,(%esp)
 d21:	e8 ce fe ff ff       	call   bf4 <free>
  return freep;
 d26:	a1 70 12 00 00       	mov    0x1270,%eax
}
 d2b:	c9                   	leave  
 d2c:	c3                   	ret    

00000d2d <malloc>:

void*
malloc(uint nbytes)
{
 d2d:	55                   	push   %ebp
 d2e:	89 e5                	mov    %esp,%ebp
 d30:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d33:	8b 45 08             	mov    0x8(%ebp),%eax
 d36:	83 c0 07             	add    $0x7,%eax
 d39:	c1 e8 03             	shr    $0x3,%eax
 d3c:	40                   	inc    %eax
 d3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d40:	a1 70 12 00 00       	mov    0x1270,%eax
 d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d4c:	75 23                	jne    d71 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d4e:	c7 45 f0 68 12 00 00 	movl   $0x1268,-0x10(%ebp)
 d55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d58:	a3 70 12 00 00       	mov    %eax,0x1270
 d5d:	a1 70 12 00 00       	mov    0x1270,%eax
 d62:	a3 68 12 00 00       	mov    %eax,0x1268
    base.s.size = 0;
 d67:	c7 05 6c 12 00 00 00 	movl   $0x0,0x126c
 d6e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d74:	8b 00                	mov    (%eax),%eax
 d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7c:	8b 40 04             	mov    0x4(%eax),%eax
 d7f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d82:	72 4d                	jb     dd1 <malloc+0xa4>
      if(p->s.size == nunits)
 d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d87:	8b 40 04             	mov    0x4(%eax),%eax
 d8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d8d:	75 0c                	jne    d9b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d92:	8b 10                	mov    (%eax),%edx
 d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d97:	89 10                	mov    %edx,(%eax)
 d99:	eb 26                	jmp    dc1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d9e:	8b 40 04             	mov    0x4(%eax),%eax
 da1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 da4:	89 c2                	mov    %eax,%edx
 da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 daf:	8b 40 04             	mov    0x4(%eax),%eax
 db2:	c1 e0 03             	shl    $0x3,%eax
 db5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 dbe:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 dc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dc4:	a3 70 12 00 00       	mov    %eax,0x1270
      return (void*)(p + 1);
 dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcc:	83 c0 08             	add    $0x8,%eax
 dcf:	eb 38                	jmp    e09 <malloc+0xdc>
    }
    if(p == freep)
 dd1:	a1 70 12 00 00       	mov    0x1270,%eax
 dd6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 dd9:	75 1b                	jne    df6 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 ddb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 dde:	89 04 24             	mov    %eax,(%esp)
 de1:	e8 ef fe ff ff       	call   cd5 <morecore>
 de6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 de9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ded:	75 07                	jne    df6 <malloc+0xc9>
        return 0;
 def:	b8 00 00 00 00       	mov    $0x0,%eax
 df4:	eb 13                	jmp    e09 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dff:	8b 00                	mov    (%eax),%eax
 e01:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e04:	e9 70 ff ff ff       	jmp    d79 <malloc+0x4c>
}
 e09:	c9                   	leave  
 e0a:	c3                   	ret    
