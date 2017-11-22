
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 d2 07 00 00       	call   7e0 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 5a 08 00 00       	call   878 <sleep>
  exit();
  1e:	e8 c5 07 00 00       	call   7e8 <exit>
  23:	90                   	nop

00000024 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  24:	55                   	push   %ebp
  25:	89 e5                	mov    %esp,%ebp
  27:	57                   	push   %edi
  28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  29:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2c:	8b 55 10             	mov    0x10(%ebp),%edx
  2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  32:	89 cb                	mov    %ecx,%ebx
  34:	89 df                	mov    %ebx,%edi
  36:	89 d1                	mov    %edx,%ecx
  38:	fc                   	cld    
  39:	f3 aa                	rep stos %al,%es:(%edi)
  3b:	89 ca                	mov    %ecx,%edx
  3d:	89 fb                	mov    %edi,%ebx
  3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  45:	5b                   	pop    %ebx
  46:	5f                   	pop    %edi
  47:	5d                   	pop    %ebp
  48:	c3                   	ret    

00000049 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  49:	55                   	push   %ebp
  4a:	89 e5                	mov    %esp,%ebp
  4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4f:	8b 45 08             	mov    0x8(%ebp),%eax
  52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  55:	90                   	nop
  56:	8b 45 08             	mov    0x8(%ebp),%eax
  59:	8d 50 01             	lea    0x1(%eax),%edx
  5c:	89 55 08             	mov    %edx,0x8(%ebp)
  5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  62:	8d 4a 01             	lea    0x1(%edx),%ecx
  65:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  68:	8a 12                	mov    (%edx),%dl
  6a:	88 10                	mov    %dl,(%eax)
  6c:	8a 00                	mov    (%eax),%al
  6e:	84 c0                	test   %al,%al
  70:	75 e4                	jne    56 <strcpy+0xd>
    ;
  return os;
  72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  75:	c9                   	leave  
  76:	c3                   	ret    

00000077 <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  7a:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
  7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  84:	00 
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	89 04 24             	mov    %eax,(%esp)
  8b:	e8 98 07 00 00       	call   828 <open>
  90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  97:	79 20                	jns    b9 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	89 44 24 08          	mov    %eax,0x8(%esp)
  a0:	c7 44 24 04 2b 0d 00 	movl   $0xd2b,0x4(%esp)
  a7:	00 
  a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  af:	e8 b1 08 00 00       	call   965 <printf>
        exit();
  b4:	e8 2f 07 00 00       	call   7e8 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
  b9:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  c0:	00 
  c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  c4:	89 04 24             	mov    %eax,(%esp)
  c7:	e8 5c 07 00 00       	call   828 <open>
  cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  d3:	79 20                	jns    f5 <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
  d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  dc:	c7 44 24 04 46 0d 00 	movl   $0xd46,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 75 08 00 00       	call   965 <printf>
        exit();
  f0:	e8 f3 06 00 00       	call   7e8 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
  f5:	eb 56                	jmp    14d <copy+0xd6>
        int max = used_disk+=count;
  f7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  fa:	01 45 10             	add    %eax,0x10(%ebp)
  fd:	8b 45 10             	mov    0x10(%ebp),%eax
 100:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 106:	89 44 24 08          	mov    %eax,0x8(%esp)
 10a:	c7 44 24 04 62 0d 00 	movl   $0xd62,0x4(%esp)
 111:	00 
 112:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 119:	e8 47 08 00 00       	call   965 <printf>
        if(max > max_disk){
 11e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 121:	3b 45 14             	cmp    0x14(%ebp),%eax
 124:	7e 07                	jle    12d <copy+0xb6>
          return -1;
 126:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 12b:	eb 5c                	jmp    189 <copy+0x112>
        }
        bytes = bytes + count;
 12d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 130:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 133:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 13a:	00 
 13b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 13e:	89 44 24 04          	mov    %eax,0x4(%esp)
 142:	8b 45 ec             	mov    -0x14(%ebp),%eax
 145:	89 04 24             	mov    %eax,(%esp)
 148:	e8 bb 06 00 00       	call   808 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 14d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 154:	00 
 155:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 158:	89 44 24 04          	mov    %eax,0x4(%esp)
 15c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 15f:	89 04 24             	mov    %eax,(%esp)
 162:	e8 99 06 00 00       	call   800 <read>
 167:	89 45 e8             	mov    %eax,-0x18(%ebp)
 16a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 16e:	7f 87                	jg     f7 <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 170:	8b 45 f0             	mov    -0x10(%ebp),%eax
 173:	89 04 24             	mov    %eax,(%esp)
 176:	e8 95 06 00 00       	call   810 <close>
    close(fd2);
 17b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 17e:	89 04 24             	mov    %eax,(%esp)
 181:	e8 8a 06 00 00       	call   810 <close>
    return(bytes);
 186:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 189:	c9                   	leave  
 18a:	c3                   	ret    

0000018b <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18b:	55                   	push   %ebp
 18c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 18e:	eb 06                	jmp    196 <strcmp+0xb>
    p++, q++;
 190:	ff 45 08             	incl   0x8(%ebp)
 193:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	8a 00                	mov    (%eax),%al
 19b:	84 c0                	test   %al,%al
 19d:	74 0e                	je     1ad <strcmp+0x22>
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	8a 10                	mov    (%eax),%dl
 1a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a7:	8a 00                	mov    (%eax),%al
 1a9:	38 c2                	cmp    %al,%dl
 1ab:	74 e3                	je     190 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
 1b0:	8a 00                	mov    (%eax),%al
 1b2:	0f b6 d0             	movzbl %al,%edx
 1b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b8:	8a 00                	mov    (%eax),%al
 1ba:	0f b6 c0             	movzbl %al,%eax
 1bd:	29 c2                	sub    %eax,%edx
 1bf:	89 d0                	mov    %edx,%eax
}
 1c1:	5d                   	pop    %ebp
 1c2:	c3                   	ret    

000001c3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 1c3:	55                   	push   %ebp
 1c4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 1c6:	eb 09                	jmp    1d1 <strncmp+0xe>
    n--, p++, q++;
 1c8:	ff 4d 10             	decl   0x10(%ebp)
 1cb:	ff 45 08             	incl   0x8(%ebp)
 1ce:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 1d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1d5:	74 17                	je     1ee <strncmp+0x2b>
 1d7:	8b 45 08             	mov    0x8(%ebp),%eax
 1da:	8a 00                	mov    (%eax),%al
 1dc:	84 c0                	test   %al,%al
 1de:	74 0e                	je     1ee <strncmp+0x2b>
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
 1e3:	8a 10                	mov    (%eax),%dl
 1e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e8:	8a 00                	mov    (%eax),%al
 1ea:	38 c2                	cmp    %al,%dl
 1ec:	74 da                	je     1c8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 1ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1f2:	75 07                	jne    1fb <strncmp+0x38>
    return 0;
 1f4:	b8 00 00 00 00       	mov    $0x0,%eax
 1f9:	eb 14                	jmp    20f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 1fb:	8b 45 08             	mov    0x8(%ebp),%eax
 1fe:	8a 00                	mov    (%eax),%al
 200:	0f b6 d0             	movzbl %al,%edx
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	8a 00                	mov    (%eax),%al
 208:	0f b6 c0             	movzbl %al,%eax
 20b:	29 c2                	sub    %eax,%edx
 20d:	89 d0                	mov    %edx,%eax
}
 20f:	5d                   	pop    %ebp
 210:	c3                   	ret    

00000211 <strlen>:

uint
strlen(const char *s)
{
 211:	55                   	push   %ebp
 212:	89 e5                	mov    %esp,%ebp
 214:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 217:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 21e:	eb 03                	jmp    223 <strlen+0x12>
 220:	ff 45 fc             	incl   -0x4(%ebp)
 223:	8b 55 fc             	mov    -0x4(%ebp),%edx
 226:	8b 45 08             	mov    0x8(%ebp),%eax
 229:	01 d0                	add    %edx,%eax
 22b:	8a 00                	mov    (%eax),%al
 22d:	84 c0                	test   %al,%al
 22f:	75 ef                	jne    220 <strlen+0xf>
    ;
  return n;
 231:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <memset>:

void*
memset(void *dst, int c, uint n)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
 239:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 23c:	8b 45 10             	mov    0x10(%ebp),%eax
 23f:	89 44 24 08          	mov    %eax,0x8(%esp)
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	89 44 24 04          	mov    %eax,0x4(%esp)
 24a:	8b 45 08             	mov    0x8(%ebp),%eax
 24d:	89 04 24             	mov    %eax,(%esp)
 250:	e8 cf fd ff ff       	call   24 <stosb>
  return dst;
 255:	8b 45 08             	mov    0x8(%ebp),%eax
}
 258:	c9                   	leave  
 259:	c3                   	ret    

0000025a <strchr>:

char*
strchr(const char *s, char c)
{
 25a:	55                   	push   %ebp
 25b:	89 e5                	mov    %esp,%ebp
 25d:	83 ec 04             	sub    $0x4,%esp
 260:	8b 45 0c             	mov    0xc(%ebp),%eax
 263:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 266:	eb 12                	jmp    27a <strchr+0x20>
    if(*s == c)
 268:	8b 45 08             	mov    0x8(%ebp),%eax
 26b:	8a 00                	mov    (%eax),%al
 26d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 270:	75 05                	jne    277 <strchr+0x1d>
      return (char*)s;
 272:	8b 45 08             	mov    0x8(%ebp),%eax
 275:	eb 11                	jmp    288 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 277:	ff 45 08             	incl   0x8(%ebp)
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	8a 00                	mov    (%eax),%al
 27f:	84 c0                	test   %al,%al
 281:	75 e5                	jne    268 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 283:	b8 00 00 00 00       	mov    $0x0,%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <strcat>:

char *
strcat(char *dest, const char *src)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 290:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 297:	eb 03                	jmp    29c <strcat+0x12>
 299:	ff 45 fc             	incl   -0x4(%ebp)
 29c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29f:	8b 45 08             	mov    0x8(%ebp),%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	8a 00                	mov    (%eax),%al
 2a6:	84 c0                	test   %al,%al
 2a8:	75 ef                	jne    299 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 2aa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 2b1:	eb 1e                	jmp    2d1 <strcat+0x47>
        dest[i+j] = src[j];
 2b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b9:	01 d0                	add    %edx,%eax
 2bb:	89 c2                	mov    %eax,%edx
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
 2c0:	01 c2                	add    %eax,%edx
 2c2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c8:	01 c8                	add    %ecx,%eax
 2ca:	8a 00                	mov    (%eax),%al
 2cc:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 2ce:	ff 45 f8             	incl   -0x8(%ebp)
 2d1:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d7:	01 d0                	add    %edx,%eax
 2d9:	8a 00                	mov    (%eax),%al
 2db:	84 c0                	test   %al,%al
 2dd:	75 d4                	jne    2b3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 2df:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e5:	01 d0                	add    %edx,%eax
 2e7:	89 c2                	mov    %eax,%edx
 2e9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ec:	01 d0                	add    %edx,%eax
 2ee:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f4:	c9                   	leave  
 2f5:	c3                   	ret    

000002f6 <strstr>:

int 
strstr(char* s, char* sub)
{
 2f6:	55                   	push   %ebp
 2f7:	89 e5                	mov    %esp,%ebp
 2f9:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 303:	eb 7c                	jmp    381 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 305:	8b 55 fc             	mov    -0x4(%ebp),%edx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	01 d0                	add    %edx,%eax
 30d:	8a 10                	mov    (%eax),%dl
 30f:	8b 45 0c             	mov    0xc(%ebp),%eax
 312:	8a 00                	mov    (%eax),%al
 314:	38 c2                	cmp    %al,%dl
 316:	75 66                	jne    37e <strstr+0x88>
        {
            if(strlen(sub) == 1)
 318:	8b 45 0c             	mov    0xc(%ebp),%eax
 31b:	89 04 24             	mov    %eax,(%esp)
 31e:	e8 ee fe ff ff       	call   211 <strlen>
 323:	83 f8 01             	cmp    $0x1,%eax
 326:	75 05                	jne    32d <strstr+0x37>
            {  
                return i;
 328:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32b:	eb 6b                	jmp    398 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 32d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 334:	eb 3a                	jmp    370 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 336:	8b 45 f8             	mov    -0x8(%ebp),%eax
 339:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33c:	01 d0                	add    %edx,%eax
 33e:	89 c2                	mov    %eax,%edx
 340:	8b 45 08             	mov    0x8(%ebp),%eax
 343:	01 d0                	add    %edx,%eax
 345:	8a 10                	mov    (%eax),%dl
 347:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	01 c8                	add    %ecx,%eax
 34f:	8a 00                	mov    (%eax),%al
 351:	38 c2                	cmp    %al,%dl
 353:	75 16                	jne    36b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 355:	8b 45 f8             	mov    -0x8(%ebp),%eax
 358:	8d 50 01             	lea    0x1(%eax),%edx
 35b:	8b 45 0c             	mov    0xc(%ebp),%eax
 35e:	01 d0                	add    %edx,%eax
 360:	8a 00                	mov    (%eax),%al
 362:	84 c0                	test   %al,%al
 364:	75 07                	jne    36d <strstr+0x77>
                    {
                        return i;
 366:	8b 45 fc             	mov    -0x4(%ebp),%eax
 369:	eb 2d                	jmp    398 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 36b:	eb 11                	jmp    37e <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 36d:	ff 45 f8             	incl   -0x8(%ebp)
 370:	8b 55 f8             	mov    -0x8(%ebp),%edx
 373:	8b 45 0c             	mov    0xc(%ebp),%eax
 376:	01 d0                	add    %edx,%eax
 378:	8a 00                	mov    (%eax),%al
 37a:	84 c0                	test   %al,%al
 37c:	75 b8                	jne    336 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 37e:	ff 45 fc             	incl   -0x4(%ebp)
 381:	8b 55 fc             	mov    -0x4(%ebp),%edx
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	01 d0                	add    %edx,%eax
 389:	8a 00                	mov    (%eax),%al
 38b:	84 c0                	test   %al,%al
 38d:	0f 85 72 ff ff ff    	jne    305 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 393:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <strtok>:

char *
strtok(char *s, const char *delim)
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	53                   	push   %ebx
 39e:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a5:	75 08                	jne    3af <strtok+0x15>
  s = lasts;
 3a7:	a1 64 11 00 00       	mov    0x1164,%eax
 3ac:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	8d 50 01             	lea    0x1(%eax),%edx
 3b5:	89 55 08             	mov    %edx,0x8(%ebp)
 3b8:	8a 00                	mov    (%eax),%al
 3ba:	0f be d8             	movsbl %al,%ebx
 3bd:	85 db                	test   %ebx,%ebx
 3bf:	75 07                	jne    3c8 <strtok+0x2e>
      return 0;
 3c1:	b8 00 00 00 00       	mov    $0x0,%eax
 3c6:	eb 58                	jmp    420 <strtok+0x86>
    } while (strchr(delim, ch));
 3c8:	88 d8                	mov    %bl,%al
 3ca:	0f be c0             	movsbl %al,%eax
 3cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d4:	89 04 24             	mov    %eax,(%esp)
 3d7:	e8 7e fe ff ff       	call   25a <strchr>
 3dc:	85 c0                	test   %eax,%eax
 3de:	75 cf                	jne    3af <strtok+0x15>
    --s;
 3e0:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ea:	8b 45 08             	mov    0x8(%ebp),%eax
 3ed:	89 04 24             	mov    %eax,(%esp)
 3f0:	e8 31 00 00 00       	call   426 <strcspn>
 3f5:	89 c2                	mov    %eax,%edx
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	01 d0                	add    %edx,%eax
 3fc:	a3 64 11 00 00       	mov    %eax,0x1164
    if (*lasts != 0)
 401:	a1 64 11 00 00       	mov    0x1164,%eax
 406:	8a 00                	mov    (%eax),%al
 408:	84 c0                	test   %al,%al
 40a:	74 11                	je     41d <strtok+0x83>
  *lasts++ = 0;
 40c:	a1 64 11 00 00       	mov    0x1164,%eax
 411:	8d 50 01             	lea    0x1(%eax),%edx
 414:	89 15 64 11 00 00    	mov    %edx,0x1164
 41a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 41d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 420:	83 c4 14             	add    $0x14,%esp
 423:	5b                   	pop    %ebx
 424:	5d                   	pop    %ebp
 425:	c3                   	ret    

00000426 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 426:	55                   	push   %ebp
 427:	89 e5                	mov    %esp,%ebp
 429:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 42c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 433:	eb 26                	jmp    45b <strcspn+0x35>
        if(strchr(s2,*s1))
 435:	8b 45 08             	mov    0x8(%ebp),%eax
 438:	8a 00                	mov    (%eax),%al
 43a:	0f be c0             	movsbl %al,%eax
 43d:	89 44 24 04          	mov    %eax,0x4(%esp)
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	89 04 24             	mov    %eax,(%esp)
 447:	e8 0e fe ff ff       	call   25a <strchr>
 44c:	85 c0                	test   %eax,%eax
 44e:	74 05                	je     455 <strcspn+0x2f>
            return ret;
 450:	8b 45 fc             	mov    -0x4(%ebp),%eax
 453:	eb 12                	jmp    467 <strcspn+0x41>
        else
            s1++,ret++;
 455:	ff 45 08             	incl   0x8(%ebp)
 458:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 45b:	8b 45 08             	mov    0x8(%ebp),%eax
 45e:	8a 00                	mov    (%eax),%al
 460:	84 c0                	test   %al,%al
 462:	75 d1                	jne    435 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 464:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 467:	c9                   	leave  
 468:	c3                   	ret    

00000469 <isspace>:

int
isspace(unsigned char c)
{
 469:	55                   	push   %ebp
 46a:	89 e5                	mov    %esp,%ebp
 46c:	83 ec 04             	sub    $0x4,%esp
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 475:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 479:	74 1e                	je     499 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 47b:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 47f:	74 18                	je     499 <isspace+0x30>
 481:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 485:	74 12                	je     499 <isspace+0x30>
 487:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 48b:	74 0c                	je     499 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 48d:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 491:	74 06                	je     499 <isspace+0x30>
 493:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 497:	75 07                	jne    4a0 <isspace+0x37>
 499:	b8 01 00 00 00       	mov    $0x1,%eax
 49e:	eb 05                	jmp    4a5 <isspace+0x3c>
 4a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4a5:	c9                   	leave  
 4a6:	c3                   	ret    

000004a7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4a7:	55                   	push   %ebp
 4a8:	89 e5                	mov    %esp,%ebp
 4aa:	57                   	push   %edi
 4ab:	56                   	push   %esi
 4ac:	53                   	push   %ebx
 4ad:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 4b0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 4b5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 4bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 4bf:	eb 01                	jmp    4c2 <strtoul+0x1b>
  p += 1;
 4c1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 4c2:	8a 03                	mov    (%ebx),%al
 4c4:	0f b6 c0             	movzbl %al,%eax
 4c7:	89 04 24             	mov    %eax,(%esp)
 4ca:	e8 9a ff ff ff       	call   469 <isspace>
 4cf:	85 c0                	test   %eax,%eax
 4d1:	75 ee                	jne    4c1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 4d3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4d7:	75 30                	jne    509 <strtoul+0x62>
    {
  if (*p == '0') {
 4d9:	8a 03                	mov    (%ebx),%al
 4db:	3c 30                	cmp    $0x30,%al
 4dd:	75 21                	jne    500 <strtoul+0x59>
      p += 1;
 4df:	43                   	inc    %ebx
      if (*p == 'x') {
 4e0:	8a 03                	mov    (%ebx),%al
 4e2:	3c 78                	cmp    $0x78,%al
 4e4:	75 0a                	jne    4f0 <strtoul+0x49>
    p += 1;
 4e6:	43                   	inc    %ebx
    base = 16;
 4e7:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 4ee:	eb 31                	jmp    521 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 4f0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 4f7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 4fe:	eb 21                	jmp    521 <strtoul+0x7a>
      }
  }
  else base = 10;
 500:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 507:	eb 18                	jmp    521 <strtoul+0x7a>
    } else if (base == 16) {
 509:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 50d:	75 12                	jne    521 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 50f:	8a 03                	mov    (%ebx),%al
 511:	3c 30                	cmp    $0x30,%al
 513:	75 0c                	jne    521 <strtoul+0x7a>
 515:	8d 43 01             	lea    0x1(%ebx),%eax
 518:	8a 00                	mov    (%eax),%al
 51a:	3c 78                	cmp    $0x78,%al
 51c:	75 03                	jne    521 <strtoul+0x7a>
      p += 2;
 51e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 521:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 525:	75 29                	jne    550 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 527:	8a 03                	mov    (%ebx),%al
 529:	0f be c0             	movsbl %al,%eax
 52c:	83 e8 30             	sub    $0x30,%eax
 52f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 531:	83 fe 07             	cmp    $0x7,%esi
 534:	76 06                	jbe    53c <strtoul+0x95>
    break;
 536:	90                   	nop
 537:	e9 b6 00 00 00       	jmp    5f2 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 53c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 543:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 546:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 54d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 54e:	eb d7                	jmp    527 <strtoul+0x80>
    } else if (base == 10) {
 550:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 554:	75 2b                	jne    581 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 556:	8a 03                	mov    (%ebx),%al
 558:	0f be c0             	movsbl %al,%eax
 55b:	83 e8 30             	sub    $0x30,%eax
 55e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 560:	83 fe 09             	cmp    $0x9,%esi
 563:	76 06                	jbe    56b <strtoul+0xc4>
    break;
 565:	90                   	nop
 566:	e9 87 00 00 00       	jmp    5f2 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 56b:	89 f8                	mov    %edi,%eax
 56d:	c1 e0 02             	shl    $0x2,%eax
 570:	01 f8                	add    %edi,%eax
 572:	01 c0                	add    %eax,%eax
 574:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 577:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 57e:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 57f:	eb d5                	jmp    556 <strtoul+0xaf>
    } else if (base == 16) {
 581:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 585:	75 35                	jne    5bc <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 587:	8a 03                	mov    (%ebx),%al
 589:	0f be c0             	movsbl %al,%eax
 58c:	83 e8 30             	sub    $0x30,%eax
 58f:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 591:	83 fe 4a             	cmp    $0x4a,%esi
 594:	76 02                	jbe    598 <strtoul+0xf1>
    break;
 596:	eb 22                	jmp    5ba <strtoul+0x113>
      }
      digit = cvtIn[digit];
 598:	8a 86 00 11 00 00    	mov    0x1100(%esi),%al
 59e:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5a1:	83 fe 0f             	cmp    $0xf,%esi
 5a4:	76 02                	jbe    5a8 <strtoul+0x101>
    break;
 5a6:	eb 12                	jmp    5ba <strtoul+0x113>
      }
      result = (result << 4) + digit;
 5a8:	89 f8                	mov    %edi,%eax
 5aa:	c1 e0 04             	shl    $0x4,%eax
 5ad:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 5b7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 5b8:	eb cd                	jmp    587 <strtoul+0xe0>
 5ba:	eb 36                	jmp    5f2 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 5bc:	8a 03                	mov    (%ebx),%al
 5be:	0f be c0             	movsbl %al,%eax
 5c1:	83 e8 30             	sub    $0x30,%eax
 5c4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5c6:	83 fe 4a             	cmp    $0x4a,%esi
 5c9:	76 02                	jbe    5cd <strtoul+0x126>
    break;
 5cb:	eb 25                	jmp    5f2 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 5cd:	8a 86 00 11 00 00    	mov    0x1100(%esi),%al
 5d3:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 5d6:	8b 45 10             	mov    0x10(%ebp),%eax
 5d9:	39 f0                	cmp    %esi,%eax
 5db:	77 02                	ja     5df <strtoul+0x138>
    break;
 5dd:	eb 13                	jmp    5f2 <strtoul+0x14b>
      }
      result = result*base + digit;
 5df:	8b 45 10             	mov    0x10(%ebp),%eax
 5e2:	0f af c7             	imul   %edi,%eax
 5e5:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5e8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 5ef:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 5f0:	eb ca                	jmp    5bc <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 5f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f6:	75 03                	jne    5fb <strtoul+0x154>
  p = string;
 5f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 5fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ff:	74 05                	je     606 <strtoul+0x15f>
  *endPtr = p;
 601:	8b 45 0c             	mov    0xc(%ebp),%eax
 604:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 606:	89 f8                	mov    %edi,%eax
}
 608:	83 c4 14             	add    $0x14,%esp
 60b:	5b                   	pop    %ebx
 60c:	5e                   	pop    %esi
 60d:	5f                   	pop    %edi
 60e:	5d                   	pop    %ebp
 60f:	c3                   	ret    

00000610 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	53                   	push   %ebx
 614:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 617:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 61a:	eb 01                	jmp    61d <strtol+0xd>
      p += 1;
 61c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 61d:	8a 03                	mov    (%ebx),%al
 61f:	0f b6 c0             	movzbl %al,%eax
 622:	89 04 24             	mov    %eax,(%esp)
 625:	e8 3f fe ff ff       	call   469 <isspace>
 62a:	85 c0                	test   %eax,%eax
 62c:	75 ee                	jne    61c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 62e:	8a 03                	mov    (%ebx),%al
 630:	3c 2d                	cmp    $0x2d,%al
 632:	75 1e                	jne    652 <strtol+0x42>
  p += 1;
 634:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 635:	8b 45 10             	mov    0x10(%ebp),%eax
 638:	89 44 24 08          	mov    %eax,0x8(%esp)
 63c:	8b 45 0c             	mov    0xc(%ebp),%eax
 63f:	89 44 24 04          	mov    %eax,0x4(%esp)
 643:	89 1c 24             	mov    %ebx,(%esp)
 646:	e8 5c fe ff ff       	call   4a7 <strtoul>
 64b:	f7 d8                	neg    %eax
 64d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 650:	eb 20                	jmp    672 <strtol+0x62>
    } else {
  if (*p == '+') {
 652:	8a 03                	mov    (%ebx),%al
 654:	3c 2b                	cmp    $0x2b,%al
 656:	75 01                	jne    659 <strtol+0x49>
      p += 1;
 658:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 659:	8b 45 10             	mov    0x10(%ebp),%eax
 65c:	89 44 24 08          	mov    %eax,0x8(%esp)
 660:	8b 45 0c             	mov    0xc(%ebp),%eax
 663:	89 44 24 04          	mov    %eax,0x4(%esp)
 667:	89 1c 24             	mov    %ebx,(%esp)
 66a:	e8 38 fe ff ff       	call   4a7 <strtoul>
 66f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 672:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 676:	75 17                	jne    68f <strtol+0x7f>
 678:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 67c:	74 11                	je     68f <strtol+0x7f>
 67e:	8b 45 0c             	mov    0xc(%ebp),%eax
 681:	8b 00                	mov    (%eax),%eax
 683:	39 d8                	cmp    %ebx,%eax
 685:	75 08                	jne    68f <strtol+0x7f>
  *endPtr = string;
 687:	8b 45 0c             	mov    0xc(%ebp),%eax
 68a:	8b 55 08             	mov    0x8(%ebp),%edx
 68d:	89 10                	mov    %edx,(%eax)
    }
    return result;
 68f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 692:	83 c4 1c             	add    $0x1c,%esp
 695:	5b                   	pop    %ebx
 696:	5d                   	pop    %ebp
 697:	c3                   	ret    

00000698 <gets>:

char*
gets(char *buf, int max)
{
 698:	55                   	push   %ebp
 699:	89 e5                	mov    %esp,%ebp
 69b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 69e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6a5:	eb 49                	jmp    6f0 <gets+0x58>
    cc = read(0, &c, 1);
 6a7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6ae:	00 
 6af:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6bd:	e8 3e 01 00 00       	call   800 <read>
 6c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6c9:	7f 02                	jg     6cd <gets+0x35>
      break;
 6cb:	eb 2c                	jmp    6f9 <gets+0x61>
    buf[i++] = c;
 6cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6d0:	8d 50 01             	lea    0x1(%eax),%edx
 6d3:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6d6:	89 c2                	mov    %eax,%edx
 6d8:	8b 45 08             	mov    0x8(%ebp),%eax
 6db:	01 c2                	add    %eax,%edx
 6dd:	8a 45 ef             	mov    -0x11(%ebp),%al
 6e0:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6e2:	8a 45 ef             	mov    -0x11(%ebp),%al
 6e5:	3c 0a                	cmp    $0xa,%al
 6e7:	74 10                	je     6f9 <gets+0x61>
 6e9:	8a 45 ef             	mov    -0x11(%ebp),%al
 6ec:	3c 0d                	cmp    $0xd,%al
 6ee:	74 09                	je     6f9 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f3:	40                   	inc    %eax
 6f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6f7:	7c ae                	jl     6a7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6fc:	8b 45 08             	mov    0x8(%ebp),%eax
 6ff:	01 d0                	add    %edx,%eax
 701:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 704:	8b 45 08             	mov    0x8(%ebp),%eax
}
 707:	c9                   	leave  
 708:	c3                   	ret    

00000709 <stat>:

int
stat(char *n, struct stat *st)
{
 709:	55                   	push   %ebp
 70a:	89 e5                	mov    %esp,%ebp
 70c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 70f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 716:	00 
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 06 01 00 00       	call   828 <open>
 722:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 725:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 729:	79 07                	jns    732 <stat+0x29>
    return -1;
 72b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 730:	eb 23                	jmp    755 <stat+0x4c>
  r = fstat(fd, st);
 732:	8b 45 0c             	mov    0xc(%ebp),%eax
 735:	89 44 24 04          	mov    %eax,0x4(%esp)
 739:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73c:	89 04 24             	mov    %eax,(%esp)
 73f:	e8 fc 00 00 00       	call   840 <fstat>
 744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 747:	8b 45 f4             	mov    -0xc(%ebp),%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 be 00 00 00       	call   810 <close>
  return r;
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 755:	c9                   	leave  
 756:	c3                   	ret    

00000757 <atoi>:

int
atoi(const char *s)
{
 757:	55                   	push   %ebp
 758:	89 e5                	mov    %esp,%ebp
 75a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 75d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 764:	eb 24                	jmp    78a <atoi+0x33>
    n = n*10 + *s++ - '0';
 766:	8b 55 fc             	mov    -0x4(%ebp),%edx
 769:	89 d0                	mov    %edx,%eax
 76b:	c1 e0 02             	shl    $0x2,%eax
 76e:	01 d0                	add    %edx,%eax
 770:	01 c0                	add    %eax,%eax
 772:	89 c1                	mov    %eax,%ecx
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	8d 50 01             	lea    0x1(%eax),%edx
 77a:	89 55 08             	mov    %edx,0x8(%ebp)
 77d:	8a 00                	mov    (%eax),%al
 77f:	0f be c0             	movsbl %al,%eax
 782:	01 c8                	add    %ecx,%eax
 784:	83 e8 30             	sub    $0x30,%eax
 787:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 78a:	8b 45 08             	mov    0x8(%ebp),%eax
 78d:	8a 00                	mov    (%eax),%al
 78f:	3c 2f                	cmp    $0x2f,%al
 791:	7e 09                	jle    79c <atoi+0x45>
 793:	8b 45 08             	mov    0x8(%ebp),%eax
 796:	8a 00                	mov    (%eax),%al
 798:	3c 39                	cmp    $0x39,%al
 79a:	7e ca                	jle    766 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 79f:	c9                   	leave  
 7a0:	c3                   	ret    

000007a1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7a1:	55                   	push   %ebp
 7a2:	89 e5                	mov    %esp,%ebp
 7a4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7a7:	8b 45 08             	mov    0x8(%ebp),%eax
 7aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 7b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7b3:	eb 16                	jmp    7cb <memmove+0x2a>
    *dst++ = *src++;
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	8d 50 01             	lea    0x1(%eax),%edx
 7bb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7be:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c1:	8d 4a 01             	lea    0x1(%edx),%ecx
 7c4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7c7:	8a 12                	mov    (%edx),%dl
 7c9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7cb:	8b 45 10             	mov    0x10(%ebp),%eax
 7ce:	8d 50 ff             	lea    -0x1(%eax),%edx
 7d1:	89 55 10             	mov    %edx,0x10(%ebp)
 7d4:	85 c0                	test   %eax,%eax
 7d6:	7f dd                	jg     7b5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7db:	c9                   	leave  
 7dc:	c3                   	ret    
 7dd:	90                   	nop
 7de:	90                   	nop
 7df:	90                   	nop

000007e0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7e0:	b8 01 00 00 00       	mov    $0x1,%eax
 7e5:	cd 40                	int    $0x40
 7e7:	c3                   	ret    

000007e8 <exit>:
SYSCALL(exit)
 7e8:	b8 02 00 00 00       	mov    $0x2,%eax
 7ed:	cd 40                	int    $0x40
 7ef:	c3                   	ret    

000007f0 <wait>:
SYSCALL(wait)
 7f0:	b8 03 00 00 00       	mov    $0x3,%eax
 7f5:	cd 40                	int    $0x40
 7f7:	c3                   	ret    

000007f8 <pipe>:
SYSCALL(pipe)
 7f8:	b8 04 00 00 00       	mov    $0x4,%eax
 7fd:	cd 40                	int    $0x40
 7ff:	c3                   	ret    

00000800 <read>:
SYSCALL(read)
 800:	b8 05 00 00 00       	mov    $0x5,%eax
 805:	cd 40                	int    $0x40
 807:	c3                   	ret    

00000808 <write>:
SYSCALL(write)
 808:	b8 10 00 00 00       	mov    $0x10,%eax
 80d:	cd 40                	int    $0x40
 80f:	c3                   	ret    

00000810 <close>:
SYSCALL(close)
 810:	b8 15 00 00 00       	mov    $0x15,%eax
 815:	cd 40                	int    $0x40
 817:	c3                   	ret    

00000818 <kill>:
SYSCALL(kill)
 818:	b8 06 00 00 00       	mov    $0x6,%eax
 81d:	cd 40                	int    $0x40
 81f:	c3                   	ret    

00000820 <exec>:
SYSCALL(exec)
 820:	b8 07 00 00 00       	mov    $0x7,%eax
 825:	cd 40                	int    $0x40
 827:	c3                   	ret    

00000828 <open>:
SYSCALL(open)
 828:	b8 0f 00 00 00       	mov    $0xf,%eax
 82d:	cd 40                	int    $0x40
 82f:	c3                   	ret    

00000830 <mknod>:
SYSCALL(mknod)
 830:	b8 11 00 00 00       	mov    $0x11,%eax
 835:	cd 40                	int    $0x40
 837:	c3                   	ret    

00000838 <unlink>:
SYSCALL(unlink)
 838:	b8 12 00 00 00       	mov    $0x12,%eax
 83d:	cd 40                	int    $0x40
 83f:	c3                   	ret    

00000840 <fstat>:
SYSCALL(fstat)
 840:	b8 08 00 00 00       	mov    $0x8,%eax
 845:	cd 40                	int    $0x40
 847:	c3                   	ret    

00000848 <link>:
SYSCALL(link)
 848:	b8 13 00 00 00       	mov    $0x13,%eax
 84d:	cd 40                	int    $0x40
 84f:	c3                   	ret    

00000850 <mkdir>:
SYSCALL(mkdir)
 850:	b8 14 00 00 00       	mov    $0x14,%eax
 855:	cd 40                	int    $0x40
 857:	c3                   	ret    

00000858 <chdir>:
SYSCALL(chdir)
 858:	b8 09 00 00 00       	mov    $0x9,%eax
 85d:	cd 40                	int    $0x40
 85f:	c3                   	ret    

00000860 <dup>:
SYSCALL(dup)
 860:	b8 0a 00 00 00       	mov    $0xa,%eax
 865:	cd 40                	int    $0x40
 867:	c3                   	ret    

00000868 <getpid>:
SYSCALL(getpid)
 868:	b8 0b 00 00 00       	mov    $0xb,%eax
 86d:	cd 40                	int    $0x40
 86f:	c3                   	ret    

00000870 <sbrk>:
SYSCALL(sbrk)
 870:	b8 0c 00 00 00       	mov    $0xc,%eax
 875:	cd 40                	int    $0x40
 877:	c3                   	ret    

00000878 <sleep>:
SYSCALL(sleep)
 878:	b8 0d 00 00 00       	mov    $0xd,%eax
 87d:	cd 40                	int    $0x40
 87f:	c3                   	ret    

00000880 <uptime>:
SYSCALL(uptime)
 880:	b8 0e 00 00 00       	mov    $0xe,%eax
 885:	cd 40                	int    $0x40
 887:	c3                   	ret    

00000888 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 888:	55                   	push   %ebp
 889:	89 e5                	mov    %esp,%ebp
 88b:	83 ec 18             	sub    $0x18,%esp
 88e:	8b 45 0c             	mov    0xc(%ebp),%eax
 891:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 894:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 89b:	00 
 89c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 89f:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a3:	8b 45 08             	mov    0x8(%ebp),%eax
 8a6:	89 04 24             	mov    %eax,(%esp)
 8a9:	e8 5a ff ff ff       	call   808 <write>
}
 8ae:	c9                   	leave  
 8af:	c3                   	ret    

000008b0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8b0:	55                   	push   %ebp
 8b1:	89 e5                	mov    %esp,%ebp
 8b3:	56                   	push   %esi
 8b4:	53                   	push   %ebx
 8b5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 8b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 8bf:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 8c3:	74 17                	je     8dc <printint+0x2c>
 8c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8c9:	79 11                	jns    8dc <printint+0x2c>
    neg = 1;
 8cb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 8d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d5:	f7 d8                	neg    %eax
 8d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8da:	eb 06                	jmp    8e2 <printint+0x32>
  } else {
    x = xx;
 8dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 8df:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 8e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8e9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8ec:	8d 41 01             	lea    0x1(%ecx),%eax
 8ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8f8:	ba 00 00 00 00       	mov    $0x0,%edx
 8fd:	f7 f3                	div    %ebx
 8ff:	89 d0                	mov    %edx,%eax
 901:	8a 80 4c 11 00 00    	mov    0x114c(%eax),%al
 907:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 90b:	8b 75 10             	mov    0x10(%ebp),%esi
 90e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 911:	ba 00 00 00 00       	mov    $0x0,%edx
 916:	f7 f6                	div    %esi
 918:	89 45 ec             	mov    %eax,-0x14(%ebp)
 91b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 91f:	75 c8                	jne    8e9 <printint+0x39>
  if(neg)
 921:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 925:	74 10                	je     937 <printint+0x87>
    buf[i++] = '-';
 927:	8b 45 f4             	mov    -0xc(%ebp),%eax
 92a:	8d 50 01             	lea    0x1(%eax),%edx
 92d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 930:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 935:	eb 1e                	jmp    955 <printint+0xa5>
 937:	eb 1c                	jmp    955 <printint+0xa5>
    putc(fd, buf[i]);
 939:	8d 55 dc             	lea    -0x24(%ebp),%edx
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	01 d0                	add    %edx,%eax
 941:	8a 00                	mov    (%eax),%al
 943:	0f be c0             	movsbl %al,%eax
 946:	89 44 24 04          	mov    %eax,0x4(%esp)
 94a:	8b 45 08             	mov    0x8(%ebp),%eax
 94d:	89 04 24             	mov    %eax,(%esp)
 950:	e8 33 ff ff ff       	call   888 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 955:	ff 4d f4             	decl   -0xc(%ebp)
 958:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 95c:	79 db                	jns    939 <printint+0x89>
    putc(fd, buf[i]);
}
 95e:	83 c4 30             	add    $0x30,%esp
 961:	5b                   	pop    %ebx
 962:	5e                   	pop    %esi
 963:	5d                   	pop    %ebp
 964:	c3                   	ret    

00000965 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 965:	55                   	push   %ebp
 966:	89 e5                	mov    %esp,%ebp
 968:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 96b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 972:	8d 45 0c             	lea    0xc(%ebp),%eax
 975:	83 c0 04             	add    $0x4,%eax
 978:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 97b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 982:	e9 77 01 00 00       	jmp    afe <printf+0x199>
    c = fmt[i] & 0xff;
 987:	8b 55 0c             	mov    0xc(%ebp),%edx
 98a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 98d:	01 d0                	add    %edx,%eax
 98f:	8a 00                	mov    (%eax),%al
 991:	0f be c0             	movsbl %al,%eax
 994:	25 ff 00 00 00       	and    $0xff,%eax
 999:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 99c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9a0:	75 2c                	jne    9ce <printf+0x69>
      if(c == '%'){
 9a2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9a6:	75 0c                	jne    9b4 <printf+0x4f>
        state = '%';
 9a8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 9af:	e9 47 01 00 00       	jmp    afb <printf+0x196>
      } else {
        putc(fd, c);
 9b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9b7:	0f be c0             	movsbl %al,%eax
 9ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 9be:	8b 45 08             	mov    0x8(%ebp),%eax
 9c1:	89 04 24             	mov    %eax,(%esp)
 9c4:	e8 bf fe ff ff       	call   888 <putc>
 9c9:	e9 2d 01 00 00       	jmp    afb <printf+0x196>
      }
    } else if(state == '%'){
 9ce:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 9d2:	0f 85 23 01 00 00    	jne    afb <printf+0x196>
      if(c == 'd'){
 9d8:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 9dc:	75 2d                	jne    a0b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 9de:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9e1:	8b 00                	mov    (%eax),%eax
 9e3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 9ea:	00 
 9eb:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 9f2:	00 
 9f3:	89 44 24 04          	mov    %eax,0x4(%esp)
 9f7:	8b 45 08             	mov    0x8(%ebp),%eax
 9fa:	89 04 24             	mov    %eax,(%esp)
 9fd:	e8 ae fe ff ff       	call   8b0 <printint>
        ap++;
 a02:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a06:	e9 e9 00 00 00       	jmp    af4 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a0b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a0f:	74 06                	je     a17 <printf+0xb2>
 a11:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a15:	75 2d                	jne    a44 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a17:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a1a:	8b 00                	mov    (%eax),%eax
 a1c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a23:	00 
 a24:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a2b:	00 
 a2c:	89 44 24 04          	mov    %eax,0x4(%esp)
 a30:	8b 45 08             	mov    0x8(%ebp),%eax
 a33:	89 04 24             	mov    %eax,(%esp)
 a36:	e8 75 fe ff ff       	call   8b0 <printint>
        ap++;
 a3b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a3f:	e9 b0 00 00 00       	jmp    af4 <printf+0x18f>
      } else if(c == 's'){
 a44:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a48:	75 42                	jne    a8c <printf+0x127>
        s = (char*)*ap;
 a4a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a4d:	8b 00                	mov    (%eax),%eax
 a4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a52:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a5a:	75 09                	jne    a65 <printf+0x100>
          s = "(null)";
 a5c:	c7 45 f4 73 0d 00 00 	movl   $0xd73,-0xc(%ebp)
        while(*s != 0){
 a63:	eb 1c                	jmp    a81 <printf+0x11c>
 a65:	eb 1a                	jmp    a81 <printf+0x11c>
          putc(fd, *s);
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	8a 00                	mov    (%eax),%al
 a6c:	0f be c0             	movsbl %al,%eax
 a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
 a73:	8b 45 08             	mov    0x8(%ebp),%eax
 a76:	89 04 24             	mov    %eax,(%esp)
 a79:	e8 0a fe ff ff       	call   888 <putc>
          s++;
 a7e:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a84:	8a 00                	mov    (%eax),%al
 a86:	84 c0                	test   %al,%al
 a88:	75 dd                	jne    a67 <printf+0x102>
 a8a:	eb 68                	jmp    af4 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a8c:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a90:	75 1d                	jne    aaf <printf+0x14a>
        putc(fd, *ap);
 a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a95:	8b 00                	mov    (%eax),%eax
 a97:	0f be c0             	movsbl %al,%eax
 a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
 a9e:	8b 45 08             	mov    0x8(%ebp),%eax
 aa1:	89 04 24             	mov    %eax,(%esp)
 aa4:	e8 df fd ff ff       	call   888 <putc>
        ap++;
 aa9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aad:	eb 45                	jmp    af4 <printf+0x18f>
      } else if(c == '%'){
 aaf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ab3:	75 17                	jne    acc <printf+0x167>
        putc(fd, c);
 ab5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ab8:	0f be c0             	movsbl %al,%eax
 abb:	89 44 24 04          	mov    %eax,0x4(%esp)
 abf:	8b 45 08             	mov    0x8(%ebp),%eax
 ac2:	89 04 24             	mov    %eax,(%esp)
 ac5:	e8 be fd ff ff       	call   888 <putc>
 aca:	eb 28                	jmp    af4 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 acc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 ad3:	00 
 ad4:	8b 45 08             	mov    0x8(%ebp),%eax
 ad7:	89 04 24             	mov    %eax,(%esp)
 ada:	e8 a9 fd ff ff       	call   888 <putc>
        putc(fd, c);
 adf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ae2:	0f be c0             	movsbl %al,%eax
 ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
 ae9:	8b 45 08             	mov    0x8(%ebp),%eax
 aec:	89 04 24             	mov    %eax,(%esp)
 aef:	e8 94 fd ff ff       	call   888 <putc>
      }
      state = 0;
 af4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 afb:	ff 45 f0             	incl   -0x10(%ebp)
 afe:	8b 55 0c             	mov    0xc(%ebp),%edx
 b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b04:	01 d0                	add    %edx,%eax
 b06:	8a 00                	mov    (%eax),%al
 b08:	84 c0                	test   %al,%al
 b0a:	0f 85 77 fe ff ff    	jne    987 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b10:	c9                   	leave  
 b11:	c3                   	ret    
 b12:	90                   	nop
 b13:	90                   	nop

00000b14 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b14:	55                   	push   %ebp
 b15:	89 e5                	mov    %esp,%ebp
 b17:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b1a:	8b 45 08             	mov    0x8(%ebp),%eax
 b1d:	83 e8 08             	sub    $0x8,%eax
 b20:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b23:	a1 70 11 00 00       	mov    0x1170,%eax
 b28:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b2b:	eb 24                	jmp    b51 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b30:	8b 00                	mov    (%eax),%eax
 b32:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b35:	77 12                	ja     b49 <free+0x35>
 b37:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b3a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b3d:	77 24                	ja     b63 <free+0x4f>
 b3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b42:	8b 00                	mov    (%eax),%eax
 b44:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b47:	77 1a                	ja     b63 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4c:	8b 00                	mov    (%eax),%eax
 b4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b51:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b54:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b57:	76 d4                	jbe    b2d <free+0x19>
 b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5c:	8b 00                	mov    (%eax),%eax
 b5e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b61:	76 ca                	jbe    b2d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b63:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b66:	8b 40 04             	mov    0x4(%eax),%eax
 b69:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b70:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b73:	01 c2                	add    %eax,%edx
 b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b78:	8b 00                	mov    (%eax),%eax
 b7a:	39 c2                	cmp    %eax,%edx
 b7c:	75 24                	jne    ba2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b81:	8b 50 04             	mov    0x4(%eax),%edx
 b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b87:	8b 00                	mov    (%eax),%eax
 b89:	8b 40 04             	mov    0x4(%eax),%eax
 b8c:	01 c2                	add    %eax,%edx
 b8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b91:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b94:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b97:	8b 00                	mov    (%eax),%eax
 b99:	8b 10                	mov    (%eax),%edx
 b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9e:	89 10                	mov    %edx,(%eax)
 ba0:	eb 0a                	jmp    bac <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ba2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba5:	8b 10                	mov    (%eax),%edx
 ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 baa:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 bac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 baf:	8b 40 04             	mov    0x4(%eax),%eax
 bb2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bbc:	01 d0                	add    %edx,%eax
 bbe:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bc1:	75 20                	jne    be3 <free+0xcf>
    p->s.size += bp->s.size;
 bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc6:	8b 50 04             	mov    0x4(%eax),%edx
 bc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bcc:	8b 40 04             	mov    0x4(%eax),%eax
 bcf:	01 c2                	add    %eax,%edx
 bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bda:	8b 10                	mov    (%eax),%edx
 bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdf:	89 10                	mov    %edx,(%eax)
 be1:	eb 08                	jmp    beb <free+0xd7>
  } else
    p->s.ptr = bp;
 be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 be9:	89 10                	mov    %edx,(%eax)
  freep = p;
 beb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bee:	a3 70 11 00 00       	mov    %eax,0x1170
}
 bf3:	c9                   	leave  
 bf4:	c3                   	ret    

00000bf5 <morecore>:

static Header*
morecore(uint nu)
{
 bf5:	55                   	push   %ebp
 bf6:	89 e5                	mov    %esp,%ebp
 bf8:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 bfb:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c02:	77 07                	ja     c0b <morecore+0x16>
    nu = 4096;
 c04:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c0b:	8b 45 08             	mov    0x8(%ebp),%eax
 c0e:	c1 e0 03             	shl    $0x3,%eax
 c11:	89 04 24             	mov    %eax,(%esp)
 c14:	e8 57 fc ff ff       	call   870 <sbrk>
 c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c1c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c20:	75 07                	jne    c29 <morecore+0x34>
    return 0;
 c22:	b8 00 00 00 00       	mov    $0x0,%eax
 c27:	eb 22                	jmp    c4b <morecore+0x56>
  hp = (Header*)p;
 c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c32:	8b 55 08             	mov    0x8(%ebp),%edx
 c35:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c3b:	83 c0 08             	add    $0x8,%eax
 c3e:	89 04 24             	mov    %eax,(%esp)
 c41:	e8 ce fe ff ff       	call   b14 <free>
  return freep;
 c46:	a1 70 11 00 00       	mov    0x1170,%eax
}
 c4b:	c9                   	leave  
 c4c:	c3                   	ret    

00000c4d <malloc>:

void*
malloc(uint nbytes)
{
 c4d:	55                   	push   %ebp
 c4e:	89 e5                	mov    %esp,%ebp
 c50:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c53:	8b 45 08             	mov    0x8(%ebp),%eax
 c56:	83 c0 07             	add    $0x7,%eax
 c59:	c1 e8 03             	shr    $0x3,%eax
 c5c:	40                   	inc    %eax
 c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c60:	a1 70 11 00 00       	mov    0x1170,%eax
 c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c68:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c6c:	75 23                	jne    c91 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 c6e:	c7 45 f0 68 11 00 00 	movl   $0x1168,-0x10(%ebp)
 c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c78:	a3 70 11 00 00       	mov    %eax,0x1170
 c7d:	a1 70 11 00 00       	mov    0x1170,%eax
 c82:	a3 68 11 00 00       	mov    %eax,0x1168
    base.s.size = 0;
 c87:	c7 05 6c 11 00 00 00 	movl   $0x0,0x116c
 c8e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c91:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c94:	8b 00                	mov    (%eax),%eax
 c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9c:	8b 40 04             	mov    0x4(%eax),%eax
 c9f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 ca2:	72 4d                	jb     cf1 <malloc+0xa4>
      if(p->s.size == nunits)
 ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca7:	8b 40 04             	mov    0x4(%eax),%eax
 caa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cad:	75 0c                	jne    cbb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb2:	8b 10                	mov    (%eax),%edx
 cb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb7:	89 10                	mov    %edx,(%eax)
 cb9:	eb 26                	jmp    ce1 <malloc+0x94>
      else {
        p->s.size -= nunits;
 cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cbe:	8b 40 04             	mov    0x4(%eax),%eax
 cc1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 cc4:	89 c2                	mov    %eax,%edx
 cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cc9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ccf:	8b 40 04             	mov    0x4(%eax),%eax
 cd2:	c1 e0 03             	shl    $0x3,%eax
 cd5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cdb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 cde:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce4:	a3 70 11 00 00       	mov    %eax,0x1170
      return (void*)(p + 1);
 ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cec:	83 c0 08             	add    $0x8,%eax
 cef:	eb 38                	jmp    d29 <malloc+0xdc>
    }
    if(p == freep)
 cf1:	a1 70 11 00 00       	mov    0x1170,%eax
 cf6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 cf9:	75 1b                	jne    d16 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 cfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 cfe:	89 04 24             	mov    %eax,(%esp)
 d01:	e8 ef fe ff ff       	call   bf5 <morecore>
 d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d09:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d0d:	75 07                	jne    d16 <malloc+0xc9>
        return 0;
 d0f:	b8 00 00 00 00       	mov    $0x0,%eax
 d14:	eb 13                	jmp    d29 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d16:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d19:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1f:	8b 00                	mov    (%eax),%eax
 d21:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d24:	e9 70 ff ff ff       	jmp    c99 <malloc+0x4c>
}
 d29:	c9                   	leave  
 d2a:	c3                   	ret    
