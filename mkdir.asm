
_mkdir:     file format elf32-i386


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
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 97 0d 00 	movl   $0xd97,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 ae 09 00 00       	call   9d1 <printf>
    exit();
  23:	e8 2c 08 00 00       	call   854 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4e                	jmp    80 <main+0x80>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 70 08 00 00       	call   8bc <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 ae 0d 00 	movl   $0xdae,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 57 09 00 00       	call   9d1 <printf>
      break;
  7a:	eb 0d                	jmp    89 <main+0x89>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	ff 44 24 1c          	incl   0x1c(%esp)
  80:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  84:	3b 45 08             	cmp    0x8(%ebp),%eax
  87:	7c a9                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  89:	e8 c6 07 00 00       	call   854 <exit>
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

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  e6:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
  e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  f0:	00 
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	89 04 24             	mov    %eax,(%esp)
  f7:	e8 98 07 00 00       	call   894 <open>
  fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 103:	79 20                	jns    125 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	89 44 24 08          	mov    %eax,0x8(%esp)
 10c:	c7 44 24 04 ca 0d 00 	movl   $0xdca,0x4(%esp)
 113:	00 
 114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 11b:	e8 b1 08 00 00       	call   9d1 <printf>
        exit();
 120:	e8 2f 07 00 00       	call   854 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 125:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 12c:	00 
 12d:	8b 45 0c             	mov    0xc(%ebp),%eax
 130:	89 04 24             	mov    %eax,(%esp)
 133:	e8 5c 07 00 00       	call   894 <open>
 138:	89 45 ec             	mov    %eax,-0x14(%ebp)
 13b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 13f:	79 20                	jns    161 <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 141:	8b 45 0c             	mov    0xc(%ebp),%eax
 144:	89 44 24 08          	mov    %eax,0x8(%esp)
 148:	c7 44 24 04 e5 0d 00 	movl   $0xde5,0x4(%esp)
 14f:	00 
 150:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 157:	e8 75 08 00 00       	call   9d1 <printf>
        exit();
 15c:	e8 f3 06 00 00       	call   854 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 161:	eb 56                	jmp    1b9 <copy+0xd6>
        int max = used_disk+=count;
 163:	8b 45 e8             	mov    -0x18(%ebp),%eax
 166:	01 45 10             	add    %eax,0x10(%ebp)
 169:	8b 45 10             	mov    0x10(%ebp),%eax
 16c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 16f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 172:	89 44 24 08          	mov    %eax,0x8(%esp)
 176:	c7 44 24 04 01 0e 00 	movl   $0xe01,0x4(%esp)
 17d:	00 
 17e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 185:	e8 47 08 00 00       	call   9d1 <printf>
        if(max > max_disk){
 18a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 18d:	3b 45 14             	cmp    0x14(%ebp),%eax
 190:	7e 07                	jle    199 <copy+0xb6>
          return -1;
 192:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 197:	eb 5c                	jmp    1f5 <copy+0x112>
        }
        bytes = bytes + count;
 199:	8b 45 e8             	mov    -0x18(%ebp),%eax
 19c:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 19f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 1a6:	00 
 1a7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1b1:	89 04 24             	mov    %eax,(%esp)
 1b4:	e8 bb 06 00 00       	call   874 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 1b9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 1c0:	00 
 1c1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1c4:	89 44 24 04          	mov    %eax,0x4(%esp)
 1c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cb:	89 04 24             	mov    %eax,(%esp)
 1ce:	e8 99 06 00 00       	call   86c <read>
 1d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
 1d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1da:	7f 87                	jg     163 <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 1dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1df:	89 04 24             	mov    %eax,(%esp)
 1e2:	e8 95 06 00 00       	call   87c <close>
    close(fd2);
 1e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1ea:	89 04 24             	mov    %eax,(%esp)
 1ed:	e8 8a 06 00 00       	call   87c <close>
    return(bytes);
 1f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1fa:	eb 06                	jmp    202 <strcmp+0xb>
    p++, q++;
 1fc:	ff 45 08             	incl   0x8(%ebp)
 1ff:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	8a 00                	mov    (%eax),%al
 207:	84 c0                	test   %al,%al
 209:	74 0e                	je     219 <strcmp+0x22>
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	8a 10                	mov    (%eax),%dl
 210:	8b 45 0c             	mov    0xc(%ebp),%eax
 213:	8a 00                	mov    (%eax),%al
 215:	38 c2                	cmp    %al,%dl
 217:	74 e3                	je     1fc <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	8a 00                	mov    (%eax),%al
 21e:	0f b6 d0             	movzbl %al,%edx
 221:	8b 45 0c             	mov    0xc(%ebp),%eax
 224:	8a 00                	mov    (%eax),%al
 226:	0f b6 c0             	movzbl %al,%eax
 229:	29 c2                	sub    %eax,%edx
 22b:	89 d0                	mov    %edx,%eax
}
 22d:	5d                   	pop    %ebp
 22e:	c3                   	ret    

0000022f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 232:	eb 09                	jmp    23d <strncmp+0xe>
    n--, p++, q++;
 234:	ff 4d 10             	decl   0x10(%ebp)
 237:	ff 45 08             	incl   0x8(%ebp)
 23a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 23d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 241:	74 17                	je     25a <strncmp+0x2b>
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	8a 00                	mov    (%eax),%al
 248:	84 c0                	test   %al,%al
 24a:	74 0e                	je     25a <strncmp+0x2b>
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	8a 10                	mov    (%eax),%dl
 251:	8b 45 0c             	mov    0xc(%ebp),%eax
 254:	8a 00                	mov    (%eax),%al
 256:	38 c2                	cmp    %al,%dl
 258:	74 da                	je     234 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 25a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 25e:	75 07                	jne    267 <strncmp+0x38>
    return 0;
 260:	b8 00 00 00 00       	mov    $0x0,%eax
 265:	eb 14                	jmp    27b <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	8a 00                	mov    (%eax),%al
 26c:	0f b6 d0             	movzbl %al,%edx
 26f:	8b 45 0c             	mov    0xc(%ebp),%eax
 272:	8a 00                	mov    (%eax),%al
 274:	0f b6 c0             	movzbl %al,%eax
 277:	29 c2                	sub    %eax,%edx
 279:	89 d0                	mov    %edx,%eax
}
 27b:	5d                   	pop    %ebp
 27c:	c3                   	ret    

0000027d <strlen>:

uint
strlen(const char *s)
{
 27d:	55                   	push   %ebp
 27e:	89 e5                	mov    %esp,%ebp
 280:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 283:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 28a:	eb 03                	jmp    28f <strlen+0x12>
 28c:	ff 45 fc             	incl   -0x4(%ebp)
 28f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	01 d0                	add    %edx,%eax
 297:	8a 00                	mov    (%eax),%al
 299:	84 c0                	test   %al,%al
 29b:	75 ef                	jne    28c <strlen+0xf>
    ;
  return n;
 29d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a8:	8b 45 10             	mov    0x10(%ebp),%eax
 2ab:	89 44 24 08          	mov    %eax,0x8(%esp)
 2af:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	89 04 24             	mov    %eax,(%esp)
 2bc:	e8 cf fd ff ff       	call   90 <stosb>
  return dst;
 2c1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c4:	c9                   	leave  
 2c5:	c3                   	ret    

000002c6 <strchr>:

char*
strchr(const char *s, char c)
{
 2c6:	55                   	push   %ebp
 2c7:	89 e5                	mov    %esp,%ebp
 2c9:	83 ec 04             	sub    $0x4,%esp
 2cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d2:	eb 12                	jmp    2e6 <strchr+0x20>
    if(*s == c)
 2d4:	8b 45 08             	mov    0x8(%ebp),%eax
 2d7:	8a 00                	mov    (%eax),%al
 2d9:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2dc:	75 05                	jne    2e3 <strchr+0x1d>
      return (char*)s;
 2de:	8b 45 08             	mov    0x8(%ebp),%eax
 2e1:	eb 11                	jmp    2f4 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e3:	ff 45 08             	incl   0x8(%ebp)
 2e6:	8b 45 08             	mov    0x8(%ebp),%eax
 2e9:	8a 00                	mov    (%eax),%al
 2eb:	84 c0                	test   %al,%al
 2ed:	75 e5                	jne    2d4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <strcat>:

char *
strcat(char *dest, const char *src)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 303:	eb 03                	jmp    308 <strcat+0x12>
 305:	ff 45 fc             	incl   -0x4(%ebp)
 308:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30b:	8b 45 08             	mov    0x8(%ebp),%eax
 30e:	01 d0                	add    %edx,%eax
 310:	8a 00                	mov    (%eax),%al
 312:	84 c0                	test   %al,%al
 314:	75 ef                	jne    305 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 316:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 31d:	eb 1e                	jmp    33d <strcat+0x47>
        dest[i+j] = src[j];
 31f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 322:	8b 55 fc             	mov    -0x4(%ebp),%edx
 325:	01 d0                	add    %edx,%eax
 327:	89 c2                	mov    %eax,%edx
 329:	8b 45 08             	mov    0x8(%ebp),%eax
 32c:	01 c2                	add    %eax,%edx
 32e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 331:	8b 45 0c             	mov    0xc(%ebp),%eax
 334:	01 c8                	add    %ecx,%eax
 336:	8a 00                	mov    (%eax),%al
 338:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 33a:	ff 45 f8             	incl   -0x8(%ebp)
 33d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 340:	8b 45 0c             	mov    0xc(%ebp),%eax
 343:	01 d0                	add    %edx,%eax
 345:	8a 00                	mov    (%eax),%al
 347:	84 c0                	test   %al,%al
 349:	75 d4                	jne    31f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 34b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 351:	01 d0                	add    %edx,%eax
 353:	89 c2                	mov    %eax,%edx
 355:	8b 45 08             	mov    0x8(%ebp),%eax
 358:	01 d0                	add    %edx,%eax
 35a:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 35d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 360:	c9                   	leave  
 361:	c3                   	ret    

00000362 <strstr>:

int 
strstr(char* s, char* sub)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 368:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 36f:	eb 7c                	jmp    3ed <strstr+0x8b>
    {
        if(s[i] == sub[0])
 371:	8b 55 fc             	mov    -0x4(%ebp),%edx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	01 d0                	add    %edx,%eax
 379:	8a 10                	mov    (%eax),%dl
 37b:	8b 45 0c             	mov    0xc(%ebp),%eax
 37e:	8a 00                	mov    (%eax),%al
 380:	38 c2                	cmp    %al,%dl
 382:	75 66                	jne    3ea <strstr+0x88>
        {
            if(strlen(sub) == 1)
 384:	8b 45 0c             	mov    0xc(%ebp),%eax
 387:	89 04 24             	mov    %eax,(%esp)
 38a:	e8 ee fe ff ff       	call   27d <strlen>
 38f:	83 f8 01             	cmp    $0x1,%eax
 392:	75 05                	jne    399 <strstr+0x37>
            {  
                return i;
 394:	8b 45 fc             	mov    -0x4(%ebp),%eax
 397:	eb 6b                	jmp    404 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 399:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 3a0:	eb 3a                	jmp    3dc <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 3a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3a8:	01 d0                	add    %edx,%eax
 3aa:	89 c2                	mov    %eax,%edx
 3ac:	8b 45 08             	mov    0x8(%ebp),%eax
 3af:	01 d0                	add    %edx,%eax
 3b1:	8a 10                	mov    (%eax),%dl
 3b3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b9:	01 c8                	add    %ecx,%eax
 3bb:	8a 00                	mov    (%eax),%al
 3bd:	38 c2                	cmp    %al,%dl
 3bf:	75 16                	jne    3d7 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 3c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3c4:	8d 50 01             	lea    0x1(%eax),%edx
 3c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ca:	01 d0                	add    %edx,%eax
 3cc:	8a 00                	mov    (%eax),%al
 3ce:	84 c0                	test   %al,%al
 3d0:	75 07                	jne    3d9 <strstr+0x77>
                    {
                        return i;
 3d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d5:	eb 2d                	jmp    404 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3d7:	eb 11                	jmp    3ea <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3d9:	ff 45 f8             	incl   -0x8(%ebp)
 3dc:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3df:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e2:	01 d0                	add    %edx,%eax
 3e4:	8a 00                	mov    (%eax),%al
 3e6:	84 c0                	test   %al,%al
 3e8:	75 b8                	jne    3a2 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3ea:	ff 45 fc             	incl   -0x4(%ebp)
 3ed:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f0:	8b 45 08             	mov    0x8(%ebp),%eax
 3f3:	01 d0                	add    %edx,%eax
 3f5:	8a 00                	mov    (%eax),%al
 3f7:	84 c0                	test   %al,%al
 3f9:	0f 85 72 ff ff ff    	jne    371 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 3ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 404:	c9                   	leave  
 405:	c3                   	ret    

00000406 <strtok>:

char *
strtok(char *s, const char *delim)
{
 406:	55                   	push   %ebp
 407:	89 e5                	mov    %esp,%ebp
 409:	53                   	push   %ebx
 40a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 40d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 411:	75 08                	jne    41b <strtok+0x15>
  s = lasts;
 413:	a1 04 12 00 00       	mov    0x1204,%eax
 418:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 41b:	8b 45 08             	mov    0x8(%ebp),%eax
 41e:	8d 50 01             	lea    0x1(%eax),%edx
 421:	89 55 08             	mov    %edx,0x8(%ebp)
 424:	8a 00                	mov    (%eax),%al
 426:	0f be d8             	movsbl %al,%ebx
 429:	85 db                	test   %ebx,%ebx
 42b:	75 07                	jne    434 <strtok+0x2e>
      return 0;
 42d:	b8 00 00 00 00       	mov    $0x0,%eax
 432:	eb 58                	jmp    48c <strtok+0x86>
    } while (strchr(delim, ch));
 434:	88 d8                	mov    %bl,%al
 436:	0f be c0             	movsbl %al,%eax
 439:	89 44 24 04          	mov    %eax,0x4(%esp)
 43d:	8b 45 0c             	mov    0xc(%ebp),%eax
 440:	89 04 24             	mov    %eax,(%esp)
 443:	e8 7e fe ff ff       	call   2c6 <strchr>
 448:	85 c0                	test   %eax,%eax
 44a:	75 cf                	jne    41b <strtok+0x15>
    --s;
 44c:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 44f:	8b 45 0c             	mov    0xc(%ebp),%eax
 452:	89 44 24 04          	mov    %eax,0x4(%esp)
 456:	8b 45 08             	mov    0x8(%ebp),%eax
 459:	89 04 24             	mov    %eax,(%esp)
 45c:	e8 31 00 00 00       	call   492 <strcspn>
 461:	89 c2                	mov    %eax,%edx
 463:	8b 45 08             	mov    0x8(%ebp),%eax
 466:	01 d0                	add    %edx,%eax
 468:	a3 04 12 00 00       	mov    %eax,0x1204
    if (*lasts != 0)
 46d:	a1 04 12 00 00       	mov    0x1204,%eax
 472:	8a 00                	mov    (%eax),%al
 474:	84 c0                	test   %al,%al
 476:	74 11                	je     489 <strtok+0x83>
  *lasts++ = 0;
 478:	a1 04 12 00 00       	mov    0x1204,%eax
 47d:	8d 50 01             	lea    0x1(%eax),%edx
 480:	89 15 04 12 00 00    	mov    %edx,0x1204
 486:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 489:	8b 45 08             	mov    0x8(%ebp),%eax
}
 48c:	83 c4 14             	add    $0x14,%esp
 48f:	5b                   	pop    %ebx
 490:	5d                   	pop    %ebp
 491:	c3                   	ret    

00000492 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 492:	55                   	push   %ebp
 493:	89 e5                	mov    %esp,%ebp
 495:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 498:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 49f:	eb 26                	jmp    4c7 <strcspn+0x35>
        if(strchr(s2,*s1))
 4a1:	8b 45 08             	mov    0x8(%ebp),%eax
 4a4:	8a 00                	mov    (%eax),%al
 4a6:	0f be c0             	movsbl %al,%eax
 4a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b0:	89 04 24             	mov    %eax,(%esp)
 4b3:	e8 0e fe ff ff       	call   2c6 <strchr>
 4b8:	85 c0                	test   %eax,%eax
 4ba:	74 05                	je     4c1 <strcspn+0x2f>
            return ret;
 4bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4bf:	eb 12                	jmp    4d3 <strcspn+0x41>
        else
            s1++,ret++;
 4c1:	ff 45 08             	incl   0x8(%ebp)
 4c4:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4c7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ca:	8a 00                	mov    (%eax),%al
 4cc:	84 c0                	test   %al,%al
 4ce:	75 d1                	jne    4a1 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4d3:	c9                   	leave  
 4d4:	c3                   	ret    

000004d5 <isspace>:

int
isspace(unsigned char c)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 04             	sub    $0x4,%esp
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4e1:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4e5:	74 1e                	je     505 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4e7:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4eb:	74 18                	je     505 <isspace+0x30>
 4ed:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4f1:	74 12                	je     505 <isspace+0x30>
 4f3:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4f7:	74 0c                	je     505 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4f9:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 4fd:	74 06                	je     505 <isspace+0x30>
 4ff:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 503:	75 07                	jne    50c <isspace+0x37>
 505:	b8 01 00 00 00       	mov    $0x1,%eax
 50a:	eb 05                	jmp    511 <isspace+0x3c>
 50c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 511:	c9                   	leave  
 512:	c3                   	ret    

00000513 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 513:	55                   	push   %ebp
 514:	89 e5                	mov    %esp,%ebp
 516:	57                   	push   %edi
 517:	56                   	push   %esi
 518:	53                   	push   %ebx
 519:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 51c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 521:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 528:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 52b:	eb 01                	jmp    52e <strtoul+0x1b>
  p += 1;
 52d:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 52e:	8a 03                	mov    (%ebx),%al
 530:	0f b6 c0             	movzbl %al,%eax
 533:	89 04 24             	mov    %eax,(%esp)
 536:	e8 9a ff ff ff       	call   4d5 <isspace>
 53b:	85 c0                	test   %eax,%eax
 53d:	75 ee                	jne    52d <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 53f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 543:	75 30                	jne    575 <strtoul+0x62>
    {
  if (*p == '0') {
 545:	8a 03                	mov    (%ebx),%al
 547:	3c 30                	cmp    $0x30,%al
 549:	75 21                	jne    56c <strtoul+0x59>
      p += 1;
 54b:	43                   	inc    %ebx
      if (*p == 'x') {
 54c:	8a 03                	mov    (%ebx),%al
 54e:	3c 78                	cmp    $0x78,%al
 550:	75 0a                	jne    55c <strtoul+0x49>
    p += 1;
 552:	43                   	inc    %ebx
    base = 16;
 553:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 55a:	eb 31                	jmp    58d <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 55c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 563:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 56a:	eb 21                	jmp    58d <strtoul+0x7a>
      }
  }
  else base = 10;
 56c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 573:	eb 18                	jmp    58d <strtoul+0x7a>
    } else if (base == 16) {
 575:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 579:	75 12                	jne    58d <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 57b:	8a 03                	mov    (%ebx),%al
 57d:	3c 30                	cmp    $0x30,%al
 57f:	75 0c                	jne    58d <strtoul+0x7a>
 581:	8d 43 01             	lea    0x1(%ebx),%eax
 584:	8a 00                	mov    (%eax),%al
 586:	3c 78                	cmp    $0x78,%al
 588:	75 03                	jne    58d <strtoul+0x7a>
      p += 2;
 58a:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 58d:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 591:	75 29                	jne    5bc <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 593:	8a 03                	mov    (%ebx),%al
 595:	0f be c0             	movsbl %al,%eax
 598:	83 e8 30             	sub    $0x30,%eax
 59b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 59d:	83 fe 07             	cmp    $0x7,%esi
 5a0:	76 06                	jbe    5a8 <strtoul+0x95>
    break;
 5a2:	90                   	nop
 5a3:	e9 b6 00 00 00       	jmp    65e <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 5a8:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 5af:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 5b9:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 5ba:	eb d7                	jmp    593 <strtoul+0x80>
    } else if (base == 10) {
 5bc:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 5c0:	75 2b                	jne    5ed <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5c2:	8a 03                	mov    (%ebx),%al
 5c4:	0f be c0             	movsbl %al,%eax
 5c7:	83 e8 30             	sub    $0x30,%eax
 5ca:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5cc:	83 fe 09             	cmp    $0x9,%esi
 5cf:	76 06                	jbe    5d7 <strtoul+0xc4>
    break;
 5d1:	90                   	nop
 5d2:	e9 87 00 00 00       	jmp    65e <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5d7:	89 f8                	mov    %edi,%eax
 5d9:	c1 e0 02             	shl    $0x2,%eax
 5dc:	01 f8                	add    %edi,%eax
 5de:	01 c0                	add    %eax,%eax
 5e0:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5e3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5ea:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5eb:	eb d5                	jmp    5c2 <strtoul+0xaf>
    } else if (base == 16) {
 5ed:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5f1:	75 35                	jne    628 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5f3:	8a 03                	mov    (%ebx),%al
 5f5:	0f be c0             	movsbl %al,%eax
 5f8:	83 e8 30             	sub    $0x30,%eax
 5fb:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5fd:	83 fe 4a             	cmp    $0x4a,%esi
 600:	76 02                	jbe    604 <strtoul+0xf1>
    break;
 602:	eb 22                	jmp    626 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 604:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 60a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 60d:	83 fe 0f             	cmp    $0xf,%esi
 610:	76 02                	jbe    614 <strtoul+0x101>
    break;
 612:	eb 12                	jmp    626 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 614:	89 f8                	mov    %edi,%eax
 616:	c1 e0 04             	shl    $0x4,%eax
 619:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 61c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 623:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 624:	eb cd                	jmp    5f3 <strtoul+0xe0>
 626:	eb 36                	jmp    65e <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 628:	8a 03                	mov    (%ebx),%al
 62a:	0f be c0             	movsbl %al,%eax
 62d:	83 e8 30             	sub    $0x30,%eax
 630:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 632:	83 fe 4a             	cmp    $0x4a,%esi
 635:	76 02                	jbe    639 <strtoul+0x126>
    break;
 637:	eb 25                	jmp    65e <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 639:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 63f:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 642:	8b 45 10             	mov    0x10(%ebp),%eax
 645:	39 f0                	cmp    %esi,%eax
 647:	77 02                	ja     64b <strtoul+0x138>
    break;
 649:	eb 13                	jmp    65e <strtoul+0x14b>
      }
      result = result*base + digit;
 64b:	8b 45 10             	mov    0x10(%ebp),%eax
 64e:	0f af c7             	imul   %edi,%eax
 651:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 654:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 65b:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 65c:	eb ca                	jmp    628 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 65e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 662:	75 03                	jne    667 <strtoul+0x154>
  p = string;
 664:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 667:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 66b:	74 05                	je     672 <strtoul+0x15f>
  *endPtr = p;
 66d:	8b 45 0c             	mov    0xc(%ebp),%eax
 670:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 672:	89 f8                	mov    %edi,%eax
}
 674:	83 c4 14             	add    $0x14,%esp
 677:	5b                   	pop    %ebx
 678:	5e                   	pop    %esi
 679:	5f                   	pop    %edi
 67a:	5d                   	pop    %ebp
 67b:	c3                   	ret    

0000067c <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 67c:	55                   	push   %ebp
 67d:	89 e5                	mov    %esp,%ebp
 67f:	53                   	push   %ebx
 680:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 683:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 686:	eb 01                	jmp    689 <strtol+0xd>
      p += 1;
 688:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 689:	8a 03                	mov    (%ebx),%al
 68b:	0f b6 c0             	movzbl %al,%eax
 68e:	89 04 24             	mov    %eax,(%esp)
 691:	e8 3f fe ff ff       	call   4d5 <isspace>
 696:	85 c0                	test   %eax,%eax
 698:	75 ee                	jne    688 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 69a:	8a 03                	mov    (%ebx),%al
 69c:	3c 2d                	cmp    $0x2d,%al
 69e:	75 1e                	jne    6be <strtol+0x42>
  p += 1;
 6a0:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 6a1:	8b 45 10             	mov    0x10(%ebp),%eax
 6a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 6a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 6af:	89 1c 24             	mov    %ebx,(%esp)
 6b2:	e8 5c fe ff ff       	call   513 <strtoul>
 6b7:	f7 d8                	neg    %eax
 6b9:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6bc:	eb 20                	jmp    6de <strtol+0x62>
    } else {
  if (*p == '+') {
 6be:	8a 03                	mov    (%ebx),%al
 6c0:	3c 2b                	cmp    $0x2b,%al
 6c2:	75 01                	jne    6c5 <strtol+0x49>
      p += 1;
 6c4:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6c5:	8b 45 10             	mov    0x10(%ebp),%eax
 6c8:	89 44 24 08          	mov    %eax,0x8(%esp)
 6cc:	8b 45 0c             	mov    0xc(%ebp),%eax
 6cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d3:	89 1c 24             	mov    %ebx,(%esp)
 6d6:	e8 38 fe ff ff       	call   513 <strtoul>
 6db:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6de:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6e2:	75 17                	jne    6fb <strtol+0x7f>
 6e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6e8:	74 11                	je     6fb <strtol+0x7f>
 6ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ed:	8b 00                	mov    (%eax),%eax
 6ef:	39 d8                	cmp    %ebx,%eax
 6f1:	75 08                	jne    6fb <strtol+0x7f>
  *endPtr = string;
 6f3:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f6:	8b 55 08             	mov    0x8(%ebp),%edx
 6f9:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 6fe:	83 c4 1c             	add    $0x1c,%esp
 701:	5b                   	pop    %ebx
 702:	5d                   	pop    %ebp
 703:	c3                   	ret    

00000704 <gets>:

char*
gets(char *buf, int max)
{
 704:	55                   	push   %ebp
 705:	89 e5                	mov    %esp,%ebp
 707:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 70a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 711:	eb 49                	jmp    75c <gets+0x58>
    cc = read(0, &c, 1);
 713:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 71a:	00 
 71b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 71e:	89 44 24 04          	mov    %eax,0x4(%esp)
 722:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 729:	e8 3e 01 00 00       	call   86c <read>
 72e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 731:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 735:	7f 02                	jg     739 <gets+0x35>
      break;
 737:	eb 2c                	jmp    765 <gets+0x61>
    buf[i++] = c;
 739:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73c:	8d 50 01             	lea    0x1(%eax),%edx
 73f:	89 55 f4             	mov    %edx,-0xc(%ebp)
 742:	89 c2                	mov    %eax,%edx
 744:	8b 45 08             	mov    0x8(%ebp),%eax
 747:	01 c2                	add    %eax,%edx
 749:	8a 45 ef             	mov    -0x11(%ebp),%al
 74c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 74e:	8a 45 ef             	mov    -0x11(%ebp),%al
 751:	3c 0a                	cmp    $0xa,%al
 753:	74 10                	je     765 <gets+0x61>
 755:	8a 45 ef             	mov    -0x11(%ebp),%al
 758:	3c 0d                	cmp    $0xd,%al
 75a:	74 09                	je     765 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 75c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75f:	40                   	inc    %eax
 760:	3b 45 0c             	cmp    0xc(%ebp),%eax
 763:	7c ae                	jl     713 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 765:	8b 55 f4             	mov    -0xc(%ebp),%edx
 768:	8b 45 08             	mov    0x8(%ebp),%eax
 76b:	01 d0                	add    %edx,%eax
 76d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 770:	8b 45 08             	mov    0x8(%ebp),%eax
}
 773:	c9                   	leave  
 774:	c3                   	ret    

00000775 <stat>:

int
stat(char *n, struct stat *st)
{
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 77b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 782:	00 
 783:	8b 45 08             	mov    0x8(%ebp),%eax
 786:	89 04 24             	mov    %eax,(%esp)
 789:	e8 06 01 00 00       	call   894 <open>
 78e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 791:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 795:	79 07                	jns    79e <stat+0x29>
    return -1;
 797:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 79c:	eb 23                	jmp    7c1 <stat+0x4c>
  r = fstat(fd, st);
 79e:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a8:	89 04 24             	mov    %eax,(%esp)
 7ab:	e8 fc 00 00 00       	call   8ac <fstat>
 7b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b6:	89 04 24             	mov    %eax,(%esp)
 7b9:	e8 be 00 00 00       	call   87c <close>
  return r;
 7be:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7c1:	c9                   	leave  
 7c2:	c3                   	ret    

000007c3 <atoi>:

int
atoi(const char *s)
{
 7c3:	55                   	push   %ebp
 7c4:	89 e5                	mov    %esp,%ebp
 7c6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7c9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7d0:	eb 24                	jmp    7f6 <atoi+0x33>
    n = n*10 + *s++ - '0';
 7d2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7d5:	89 d0                	mov    %edx,%eax
 7d7:	c1 e0 02             	shl    $0x2,%eax
 7da:	01 d0                	add    %edx,%eax
 7dc:	01 c0                	add    %eax,%eax
 7de:	89 c1                	mov    %eax,%ecx
 7e0:	8b 45 08             	mov    0x8(%ebp),%eax
 7e3:	8d 50 01             	lea    0x1(%eax),%edx
 7e6:	89 55 08             	mov    %edx,0x8(%ebp)
 7e9:	8a 00                	mov    (%eax),%al
 7eb:	0f be c0             	movsbl %al,%eax
 7ee:	01 c8                	add    %ecx,%eax
 7f0:	83 e8 30             	sub    $0x30,%eax
 7f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7f6:	8b 45 08             	mov    0x8(%ebp),%eax
 7f9:	8a 00                	mov    (%eax),%al
 7fb:	3c 2f                	cmp    $0x2f,%al
 7fd:	7e 09                	jle    808 <atoi+0x45>
 7ff:	8b 45 08             	mov    0x8(%ebp),%eax
 802:	8a 00                	mov    (%eax),%al
 804:	3c 39                	cmp    $0x39,%al
 806:	7e ca                	jle    7d2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 808:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80b:	c9                   	leave  
 80c:	c3                   	ret    

0000080d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 80d:	55                   	push   %ebp
 80e:	89 e5                	mov    %esp,%ebp
 810:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 813:	8b 45 08             	mov    0x8(%ebp),%eax
 816:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 819:	8b 45 0c             	mov    0xc(%ebp),%eax
 81c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 81f:	eb 16                	jmp    837 <memmove+0x2a>
    *dst++ = *src++;
 821:	8b 45 fc             	mov    -0x4(%ebp),%eax
 824:	8d 50 01             	lea    0x1(%eax),%edx
 827:	89 55 fc             	mov    %edx,-0x4(%ebp)
 82a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82d:	8d 4a 01             	lea    0x1(%edx),%ecx
 830:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 833:	8a 12                	mov    (%edx),%dl
 835:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 837:	8b 45 10             	mov    0x10(%ebp),%eax
 83a:	8d 50 ff             	lea    -0x1(%eax),%edx
 83d:	89 55 10             	mov    %edx,0x10(%ebp)
 840:	85 c0                	test   %eax,%eax
 842:	7f dd                	jg     821 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 844:	8b 45 08             	mov    0x8(%ebp),%eax
}
 847:	c9                   	leave  
 848:	c3                   	ret    
 849:	90                   	nop
 84a:	90                   	nop
 84b:	90                   	nop

0000084c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 84c:	b8 01 00 00 00       	mov    $0x1,%eax
 851:	cd 40                	int    $0x40
 853:	c3                   	ret    

00000854 <exit>:
SYSCALL(exit)
 854:	b8 02 00 00 00       	mov    $0x2,%eax
 859:	cd 40                	int    $0x40
 85b:	c3                   	ret    

0000085c <wait>:
SYSCALL(wait)
 85c:	b8 03 00 00 00       	mov    $0x3,%eax
 861:	cd 40                	int    $0x40
 863:	c3                   	ret    

00000864 <pipe>:
SYSCALL(pipe)
 864:	b8 04 00 00 00       	mov    $0x4,%eax
 869:	cd 40                	int    $0x40
 86b:	c3                   	ret    

0000086c <read>:
SYSCALL(read)
 86c:	b8 05 00 00 00       	mov    $0x5,%eax
 871:	cd 40                	int    $0x40
 873:	c3                   	ret    

00000874 <write>:
SYSCALL(write)
 874:	b8 10 00 00 00       	mov    $0x10,%eax
 879:	cd 40                	int    $0x40
 87b:	c3                   	ret    

0000087c <close>:
SYSCALL(close)
 87c:	b8 15 00 00 00       	mov    $0x15,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <kill>:
SYSCALL(kill)
 884:	b8 06 00 00 00       	mov    $0x6,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <exec>:
SYSCALL(exec)
 88c:	b8 07 00 00 00       	mov    $0x7,%eax
 891:	cd 40                	int    $0x40
 893:	c3                   	ret    

00000894 <open>:
SYSCALL(open)
 894:	b8 0f 00 00 00       	mov    $0xf,%eax
 899:	cd 40                	int    $0x40
 89b:	c3                   	ret    

0000089c <mknod>:
SYSCALL(mknod)
 89c:	b8 11 00 00 00       	mov    $0x11,%eax
 8a1:	cd 40                	int    $0x40
 8a3:	c3                   	ret    

000008a4 <unlink>:
SYSCALL(unlink)
 8a4:	b8 12 00 00 00       	mov    $0x12,%eax
 8a9:	cd 40                	int    $0x40
 8ab:	c3                   	ret    

000008ac <fstat>:
SYSCALL(fstat)
 8ac:	b8 08 00 00 00       	mov    $0x8,%eax
 8b1:	cd 40                	int    $0x40
 8b3:	c3                   	ret    

000008b4 <link>:
SYSCALL(link)
 8b4:	b8 13 00 00 00       	mov    $0x13,%eax
 8b9:	cd 40                	int    $0x40
 8bb:	c3                   	ret    

000008bc <mkdir>:
SYSCALL(mkdir)
 8bc:	b8 14 00 00 00       	mov    $0x14,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <chdir>:
SYSCALL(chdir)
 8c4:	b8 09 00 00 00       	mov    $0x9,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <dup>:
SYSCALL(dup)
 8cc:	b8 0a 00 00 00       	mov    $0xa,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <getpid>:
SYSCALL(getpid)
 8d4:	b8 0b 00 00 00       	mov    $0xb,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <sbrk>:
SYSCALL(sbrk)
 8dc:	b8 0c 00 00 00       	mov    $0xc,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <sleep>:
SYSCALL(sleep)
 8e4:	b8 0d 00 00 00       	mov    $0xd,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <uptime>:
SYSCALL(uptime)
 8ec:	b8 0e 00 00 00       	mov    $0xe,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 18             	sub    $0x18,%esp
 8fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 8fd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 900:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 907:	00 
 908:	8d 45 f4             	lea    -0xc(%ebp),%eax
 90b:	89 44 24 04          	mov    %eax,0x4(%esp)
 90f:	8b 45 08             	mov    0x8(%ebp),%eax
 912:	89 04 24             	mov    %eax,(%esp)
 915:	e8 5a ff ff ff       	call   874 <write>
}
 91a:	c9                   	leave  
 91b:	c3                   	ret    

0000091c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 91c:	55                   	push   %ebp
 91d:	89 e5                	mov    %esp,%ebp
 91f:	56                   	push   %esi
 920:	53                   	push   %ebx
 921:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 924:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 92b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 92f:	74 17                	je     948 <printint+0x2c>
 931:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 935:	79 11                	jns    948 <printint+0x2c>
    neg = 1;
 937:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 93e:	8b 45 0c             	mov    0xc(%ebp),%eax
 941:	f7 d8                	neg    %eax
 943:	89 45 ec             	mov    %eax,-0x14(%ebp)
 946:	eb 06                	jmp    94e <printint+0x32>
  } else {
    x = xx;
 948:	8b 45 0c             	mov    0xc(%ebp),%eax
 94b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 94e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 955:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 958:	8d 41 01             	lea    0x1(%ecx),%eax
 95b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 95e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 961:	8b 45 ec             	mov    -0x14(%ebp),%eax
 964:	ba 00 00 00 00       	mov    $0x0,%edx
 969:	f7 f3                	div    %ebx
 96b:	89 d0                	mov    %edx,%eax
 96d:	8a 80 ec 11 00 00    	mov    0x11ec(%eax),%al
 973:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 977:	8b 75 10             	mov    0x10(%ebp),%esi
 97a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 97d:	ba 00 00 00 00       	mov    $0x0,%edx
 982:	f7 f6                	div    %esi
 984:	89 45 ec             	mov    %eax,-0x14(%ebp)
 987:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 98b:	75 c8                	jne    955 <printint+0x39>
  if(neg)
 98d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 991:	74 10                	je     9a3 <printint+0x87>
    buf[i++] = '-';
 993:	8b 45 f4             	mov    -0xc(%ebp),%eax
 996:	8d 50 01             	lea    0x1(%eax),%edx
 999:	89 55 f4             	mov    %edx,-0xc(%ebp)
 99c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9a1:	eb 1e                	jmp    9c1 <printint+0xa5>
 9a3:	eb 1c                	jmp    9c1 <printint+0xa5>
    putc(fd, buf[i]);
 9a5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ab:	01 d0                	add    %edx,%eax
 9ad:	8a 00                	mov    (%eax),%al
 9af:	0f be c0             	movsbl %al,%eax
 9b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b6:	8b 45 08             	mov    0x8(%ebp),%eax
 9b9:	89 04 24             	mov    %eax,(%esp)
 9bc:	e8 33 ff ff ff       	call   8f4 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9c1:	ff 4d f4             	decl   -0xc(%ebp)
 9c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9c8:	79 db                	jns    9a5 <printint+0x89>
    putc(fd, buf[i]);
}
 9ca:	83 c4 30             	add    $0x30,%esp
 9cd:	5b                   	pop    %ebx
 9ce:	5e                   	pop    %esi
 9cf:	5d                   	pop    %ebp
 9d0:	c3                   	ret    

000009d1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9d1:	55                   	push   %ebp
 9d2:	89 e5                	mov    %esp,%ebp
 9d4:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9d7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9de:	8d 45 0c             	lea    0xc(%ebp),%eax
 9e1:	83 c0 04             	add    $0x4,%eax
 9e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9e7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9ee:	e9 77 01 00 00       	jmp    b6a <printf+0x199>
    c = fmt[i] & 0xff;
 9f3:	8b 55 0c             	mov    0xc(%ebp),%edx
 9f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f9:	01 d0                	add    %edx,%eax
 9fb:	8a 00                	mov    (%eax),%al
 9fd:	0f be c0             	movsbl %al,%eax
 a00:	25 ff 00 00 00       	and    $0xff,%eax
 a05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a08:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a0c:	75 2c                	jne    a3a <printf+0x69>
      if(c == '%'){
 a0e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a12:	75 0c                	jne    a20 <printf+0x4f>
        state = '%';
 a14:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a1b:	e9 47 01 00 00       	jmp    b67 <printf+0x196>
      } else {
        putc(fd, c);
 a20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a23:	0f be c0             	movsbl %al,%eax
 a26:	89 44 24 04          	mov    %eax,0x4(%esp)
 a2a:	8b 45 08             	mov    0x8(%ebp),%eax
 a2d:	89 04 24             	mov    %eax,(%esp)
 a30:	e8 bf fe ff ff       	call   8f4 <putc>
 a35:	e9 2d 01 00 00       	jmp    b67 <printf+0x196>
      }
    } else if(state == '%'){
 a3a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a3e:	0f 85 23 01 00 00    	jne    b67 <printf+0x196>
      if(c == 'd'){
 a44:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a48:	75 2d                	jne    a77 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a4d:	8b 00                	mov    (%eax),%eax
 a4f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a56:	00 
 a57:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a5e:	00 
 a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
 a63:	8b 45 08             	mov    0x8(%ebp),%eax
 a66:	89 04 24             	mov    %eax,(%esp)
 a69:	e8 ae fe ff ff       	call   91c <printint>
        ap++;
 a6e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a72:	e9 e9 00 00 00       	jmp    b60 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a77:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a7b:	74 06                	je     a83 <printf+0xb2>
 a7d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a81:	75 2d                	jne    ab0 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a83:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a86:	8b 00                	mov    (%eax),%eax
 a88:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a8f:	00 
 a90:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a97:	00 
 a98:	89 44 24 04          	mov    %eax,0x4(%esp)
 a9c:	8b 45 08             	mov    0x8(%ebp),%eax
 a9f:	89 04 24             	mov    %eax,(%esp)
 aa2:	e8 75 fe ff ff       	call   91c <printint>
        ap++;
 aa7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aab:	e9 b0 00 00 00       	jmp    b60 <printf+0x18f>
      } else if(c == 's'){
 ab0:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 ab4:	75 42                	jne    af8 <printf+0x127>
        s = (char*)*ap;
 ab6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ab9:	8b 00                	mov    (%eax),%eax
 abb:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 abe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac6:	75 09                	jne    ad1 <printf+0x100>
          s = "(null)";
 ac8:	c7 45 f4 12 0e 00 00 	movl   $0xe12,-0xc(%ebp)
        while(*s != 0){
 acf:	eb 1c                	jmp    aed <printf+0x11c>
 ad1:	eb 1a                	jmp    aed <printf+0x11c>
          putc(fd, *s);
 ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad6:	8a 00                	mov    (%eax),%al
 ad8:	0f be c0             	movsbl %al,%eax
 adb:	89 44 24 04          	mov    %eax,0x4(%esp)
 adf:	8b 45 08             	mov    0x8(%ebp),%eax
 ae2:	89 04 24             	mov    %eax,(%esp)
 ae5:	e8 0a fe ff ff       	call   8f4 <putc>
          s++;
 aea:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af0:	8a 00                	mov    (%eax),%al
 af2:	84 c0                	test   %al,%al
 af4:	75 dd                	jne    ad3 <printf+0x102>
 af6:	eb 68                	jmp    b60 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 af8:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 afc:	75 1d                	jne    b1b <printf+0x14a>
        putc(fd, *ap);
 afe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b01:	8b 00                	mov    (%eax),%eax
 b03:	0f be c0             	movsbl %al,%eax
 b06:	89 44 24 04          	mov    %eax,0x4(%esp)
 b0a:	8b 45 08             	mov    0x8(%ebp),%eax
 b0d:	89 04 24             	mov    %eax,(%esp)
 b10:	e8 df fd ff ff       	call   8f4 <putc>
        ap++;
 b15:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b19:	eb 45                	jmp    b60 <printf+0x18f>
      } else if(c == '%'){
 b1b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b1f:	75 17                	jne    b38 <printf+0x167>
        putc(fd, c);
 b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b24:	0f be c0             	movsbl %al,%eax
 b27:	89 44 24 04          	mov    %eax,0x4(%esp)
 b2b:	8b 45 08             	mov    0x8(%ebp),%eax
 b2e:	89 04 24             	mov    %eax,(%esp)
 b31:	e8 be fd ff ff       	call   8f4 <putc>
 b36:	eb 28                	jmp    b60 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b38:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b3f:	00 
 b40:	8b 45 08             	mov    0x8(%ebp),%eax
 b43:	89 04 24             	mov    %eax,(%esp)
 b46:	e8 a9 fd ff ff       	call   8f4 <putc>
        putc(fd, c);
 b4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b4e:	0f be c0             	movsbl %al,%eax
 b51:	89 44 24 04          	mov    %eax,0x4(%esp)
 b55:	8b 45 08             	mov    0x8(%ebp),%eax
 b58:	89 04 24             	mov    %eax,(%esp)
 b5b:	e8 94 fd ff ff       	call   8f4 <putc>
      }
      state = 0;
 b60:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b67:	ff 45 f0             	incl   -0x10(%ebp)
 b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
 b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b70:	01 d0                	add    %edx,%eax
 b72:	8a 00                	mov    (%eax),%al
 b74:	84 c0                	test   %al,%al
 b76:	0f 85 77 fe ff ff    	jne    9f3 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b7c:	c9                   	leave  
 b7d:	c3                   	ret    
 b7e:	90                   	nop
 b7f:	90                   	nop

00000b80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b80:	55                   	push   %ebp
 b81:	89 e5                	mov    %esp,%ebp
 b83:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b86:	8b 45 08             	mov    0x8(%ebp),%eax
 b89:	83 e8 08             	sub    $0x8,%eax
 b8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b8f:	a1 10 12 00 00       	mov    0x1210,%eax
 b94:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b97:	eb 24                	jmp    bbd <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b99:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b9c:	8b 00                	mov    (%eax),%eax
 b9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ba1:	77 12                	ja     bb5 <free+0x35>
 ba3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ba6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ba9:	77 24                	ja     bcf <free+0x4f>
 bab:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bae:	8b 00                	mov    (%eax),%eax
 bb0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bb3:	77 1a                	ja     bcf <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb8:	8b 00                	mov    (%eax),%eax
 bba:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bc0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bc3:	76 d4                	jbe    b99 <free+0x19>
 bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc8:	8b 00                	mov    (%eax),%eax
 bca:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bcd:	76 ca                	jbe    b99 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bcf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd2:	8b 40 04             	mov    0x4(%eax),%eax
 bd5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bdc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bdf:	01 c2                	add    %eax,%edx
 be1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be4:	8b 00                	mov    (%eax),%eax
 be6:	39 c2                	cmp    %eax,%edx
 be8:	75 24                	jne    c0e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bed:	8b 50 04             	mov    0x4(%eax),%edx
 bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf3:	8b 00                	mov    (%eax),%eax
 bf5:	8b 40 04             	mov    0x4(%eax),%eax
 bf8:	01 c2                	add    %eax,%edx
 bfa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bfd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c03:	8b 00                	mov    (%eax),%eax
 c05:	8b 10                	mov    (%eax),%edx
 c07:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c0a:	89 10                	mov    %edx,(%eax)
 c0c:	eb 0a                	jmp    c18 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c11:	8b 10                	mov    (%eax),%edx
 c13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c16:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c18:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1b:	8b 40 04             	mov    0x4(%eax),%eax
 c1e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c28:	01 d0                	add    %edx,%eax
 c2a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c2d:	75 20                	jne    c4f <free+0xcf>
    p->s.size += bp->s.size;
 c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c32:	8b 50 04             	mov    0x4(%eax),%edx
 c35:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c38:	8b 40 04             	mov    0x4(%eax),%eax
 c3b:	01 c2                	add    %eax,%edx
 c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c40:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c43:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c46:	8b 10                	mov    (%eax),%edx
 c48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c4b:	89 10                	mov    %edx,(%eax)
 c4d:	eb 08                	jmp    c57 <free+0xd7>
  } else
    p->s.ptr = bp;
 c4f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c52:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c55:	89 10                	mov    %edx,(%eax)
  freep = p;
 c57:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5a:	a3 10 12 00 00       	mov    %eax,0x1210
}
 c5f:	c9                   	leave  
 c60:	c3                   	ret    

00000c61 <morecore>:

static Header*
morecore(uint nu)
{
 c61:	55                   	push   %ebp
 c62:	89 e5                	mov    %esp,%ebp
 c64:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c67:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c6e:	77 07                	ja     c77 <morecore+0x16>
    nu = 4096;
 c70:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c77:	8b 45 08             	mov    0x8(%ebp),%eax
 c7a:	c1 e0 03             	shl    $0x3,%eax
 c7d:	89 04 24             	mov    %eax,(%esp)
 c80:	e8 57 fc ff ff       	call   8dc <sbrk>
 c85:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c88:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c8c:	75 07                	jne    c95 <morecore+0x34>
    return 0;
 c8e:	b8 00 00 00 00       	mov    $0x0,%eax
 c93:	eb 22                	jmp    cb7 <morecore+0x56>
  hp = (Header*)p;
 c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c9e:	8b 55 08             	mov    0x8(%ebp),%edx
 ca1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ca4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ca7:	83 c0 08             	add    $0x8,%eax
 caa:	89 04 24             	mov    %eax,(%esp)
 cad:	e8 ce fe ff ff       	call   b80 <free>
  return freep;
 cb2:	a1 10 12 00 00       	mov    0x1210,%eax
}
 cb7:	c9                   	leave  
 cb8:	c3                   	ret    

00000cb9 <malloc>:

void*
malloc(uint nbytes)
{
 cb9:	55                   	push   %ebp
 cba:	89 e5                	mov    %esp,%ebp
 cbc:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cbf:	8b 45 08             	mov    0x8(%ebp),%eax
 cc2:	83 c0 07             	add    $0x7,%eax
 cc5:	c1 e8 03             	shr    $0x3,%eax
 cc8:	40                   	inc    %eax
 cc9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ccc:	a1 10 12 00 00       	mov    0x1210,%eax
 cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cd8:	75 23                	jne    cfd <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 cda:	c7 45 f0 08 12 00 00 	movl   $0x1208,-0x10(%ebp)
 ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce4:	a3 10 12 00 00       	mov    %eax,0x1210
 ce9:	a1 10 12 00 00       	mov    0x1210,%eax
 cee:	a3 08 12 00 00       	mov    %eax,0x1208
    base.s.size = 0;
 cf3:	c7 05 0c 12 00 00 00 	movl   $0x0,0x120c
 cfa:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d00:	8b 00                	mov    (%eax),%eax
 d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d08:	8b 40 04             	mov    0x4(%eax),%eax
 d0b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d0e:	72 4d                	jb     d5d <malloc+0xa4>
      if(p->s.size == nunits)
 d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d13:	8b 40 04             	mov    0x4(%eax),%eax
 d16:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d19:	75 0c                	jne    d27 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1e:	8b 10                	mov    (%eax),%edx
 d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d23:	89 10                	mov    %edx,(%eax)
 d25:	eb 26                	jmp    d4d <malloc+0x94>
      else {
        p->s.size -= nunits;
 d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2a:	8b 40 04             	mov    0x4(%eax),%eax
 d2d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d30:	89 c2                	mov    %eax,%edx
 d32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d35:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3b:	8b 40 04             	mov    0x4(%eax),%eax
 d3e:	c1 e0 03             	shl    $0x3,%eax
 d41:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d47:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d4a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d50:	a3 10 12 00 00       	mov    %eax,0x1210
      return (void*)(p + 1);
 d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d58:	83 c0 08             	add    $0x8,%eax
 d5b:	eb 38                	jmp    d95 <malloc+0xdc>
    }
    if(p == freep)
 d5d:	a1 10 12 00 00       	mov    0x1210,%eax
 d62:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d65:	75 1b                	jne    d82 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d67:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d6a:	89 04 24             	mov    %eax,(%esp)
 d6d:	e8 ef fe ff ff       	call   c61 <morecore>
 d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d79:	75 07                	jne    d82 <malloc+0xc9>
        return 0;
 d7b:	b8 00 00 00 00       	mov    $0x0,%eax
 d80:	eb 13                	jmp    d95 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d85:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8b:	8b 00                	mov    (%eax),%eax
 d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d90:	e9 70 ff ff ff       	jmp    d05 <malloc+0x4c>
}
 d95:	c9                   	leave  
 d96:	c3                   	ret    
