
_echo:     file format elf32-i386


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

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 48                	jmp    5b <main+0x5b>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	40                   	inc    %eax
  18:	3b 45 08             	cmp    0x8(%ebp),%eax
  1b:	7d 07                	jge    24 <main+0x24>
  1d:	b8 73 0d 00 00       	mov    $0xd73,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 75 0d 00 00       	mov    $0xd75,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 77 0d 00 	movl   $0xd77,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 56 09 00 00       	call   9ad <printf>
int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++)
  57:	ff 44 24 1c          	incl   0x1c(%esp)
  5b:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5f:	3b 45 08             	cmp    0x8(%ebp),%eax
  62:	7c af                	jl     13 <main+0x13>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  exit();
  64:	e8 c7 07 00 00       	call   830 <exit>
  69:	90                   	nop
  6a:	90                   	nop
  6b:	90                   	nop

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	8d 50 01             	lea    0x1(%eax),%edx
  a4:	89 55 08             	mov    %edx,0x8(%ebp)
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b0:	8a 12                	mov    (%edx),%dl
  b2:	88 10                	mov    %dl,(%eax)
  b4:	8a 00                	mov    (%eax),%al
  b6:	84 c0                	test   %al,%al
  b8:	75 e4                	jne    9e <strcpy+0xd>
    ;
  return os;
  ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bd:	c9                   	leave  
  be:	c3                   	ret    

000000bf <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
  bf:	55                   	push   %ebp
  c0:	89 e5                	mov    %esp,%ebp
  c2:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
  c5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  cc:	00 
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	89 04 24             	mov    %eax,(%esp)
  d3:	e8 98 07 00 00       	call   870 <open>
  d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  df:	79 20                	jns    101 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  e8:	c7 44 24 04 7c 0d 00 	movl   $0xd7c,0x4(%esp)
  ef:	00 
  f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f7:	e8 b1 08 00 00       	call   9ad <printf>
        exit();
  fc:	e8 2f 07 00 00       	call   830 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
 101:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 108:	00 
 109:	8b 45 0c             	mov    0xc(%ebp),%eax
 10c:	89 04 24             	mov    %eax,(%esp)
 10f:	e8 5c 07 00 00       	call   870 <open>
 114:	89 45 ec             	mov    %eax,-0x14(%ebp)
 117:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 11b:	79 20                	jns    13d <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
 11d:	8b 45 0c             	mov    0xc(%ebp),%eax
 120:	89 44 24 08          	mov    %eax,0x8(%esp)
 124:	c7 44 24 04 97 0d 00 	movl   $0xd97,0x4(%esp)
 12b:	00 
 12c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 133:	e8 75 08 00 00       	call   9ad <printf>
        exit();
 138:	e8 f3 06 00 00       	call   830 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 13d:	eb 56                	jmp    195 <copy+0xd6>
        int max = used_disk+=count;
 13f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 142:	01 45 10             	add    %eax,0x10(%ebp)
 145:	8b 45 10             	mov    0x10(%ebp),%eax
 148:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
 14b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 14e:	89 44 24 08          	mov    %eax,0x8(%esp)
 152:	c7 44 24 04 b3 0d 00 	movl   $0xdb3,0x4(%esp)
 159:	00 
 15a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 161:	e8 47 08 00 00       	call   9ad <printf>
        if(max > max_disk){
 166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 169:	3b 45 14             	cmp    0x14(%ebp),%eax
 16c:	7e 07                	jle    175 <copy+0xb6>
          return -1;
 16e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 173:	eb 5c                	jmp    1d1 <copy+0x112>
        }
        bytes = bytes + count;
 175:	8b 45 e8             	mov    -0x18(%ebp),%eax
 178:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
 17b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 182:	00 
 183:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 186:	89 44 24 04          	mov    %eax,0x4(%esp)
 18a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 18d:	89 04 24             	mov    %eax,(%esp)
 190:	e8 bb 06 00 00       	call   850 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
 195:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 19c:	00 
 19d:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1a0:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1a7:	89 04 24             	mov    %eax,(%esp)
 1aa:	e8 99 06 00 00       	call   848 <read>
 1af:	89 45 e8             	mov    %eax,-0x18(%ebp)
 1b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1b6:	7f 87                	jg     13f <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
 1b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1bb:	89 04 24             	mov    %eax,(%esp)
 1be:	e8 95 06 00 00       	call   858 <close>
    close(fd2);
 1c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1c6:	89 04 24             	mov    %eax,(%esp)
 1c9:	e8 8a 06 00 00       	call   858 <close>
    return(bytes);
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1d1:	c9                   	leave  
 1d2:	c3                   	ret    

000001d3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1d3:	55                   	push   %ebp
 1d4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1d6:	eb 06                	jmp    1de <strcmp+0xb>
    p++, q++;
 1d8:	ff 45 08             	incl   0x8(%ebp)
 1db:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	8a 00                	mov    (%eax),%al
 1e3:	84 c0                	test   %al,%al
 1e5:	74 0e                	je     1f5 <strcmp+0x22>
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	8a 10                	mov    (%eax),%dl
 1ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ef:	8a 00                	mov    (%eax),%al
 1f1:	38 c2                	cmp    %al,%dl
 1f3:	74 e3                	je     1d8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1f5:	8b 45 08             	mov    0x8(%ebp),%eax
 1f8:	8a 00                	mov    (%eax),%al
 1fa:	0f b6 d0             	movzbl %al,%edx
 1fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 200:	8a 00                	mov    (%eax),%al
 202:	0f b6 c0             	movzbl %al,%eax
 205:	29 c2                	sub    %eax,%edx
 207:	89 d0                	mov    %edx,%eax
}
 209:	5d                   	pop    %ebp
 20a:	c3                   	ret    

0000020b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 20b:	55                   	push   %ebp
 20c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 20e:	eb 09                	jmp    219 <strncmp+0xe>
    n--, p++, q++;
 210:	ff 4d 10             	decl   0x10(%ebp)
 213:	ff 45 08             	incl   0x8(%ebp)
 216:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 219:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 21d:	74 17                	je     236 <strncmp+0x2b>
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	8a 00                	mov    (%eax),%al
 224:	84 c0                	test   %al,%al
 226:	74 0e                	je     236 <strncmp+0x2b>
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	8a 10                	mov    (%eax),%dl
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	8a 00                	mov    (%eax),%al
 232:	38 c2                	cmp    %al,%dl
 234:	74 da                	je     210 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 236:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 23a:	75 07                	jne    243 <strncmp+0x38>
    return 0;
 23c:	b8 00 00 00 00       	mov    $0x0,%eax
 241:	eb 14                	jmp    257 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	8a 00                	mov    (%eax),%al
 248:	0f b6 d0             	movzbl %al,%edx
 24b:	8b 45 0c             	mov    0xc(%ebp),%eax
 24e:	8a 00                	mov    (%eax),%al
 250:	0f b6 c0             	movzbl %al,%eax
 253:	29 c2                	sub    %eax,%edx
 255:	89 d0                	mov    %edx,%eax
}
 257:	5d                   	pop    %ebp
 258:	c3                   	ret    

00000259 <strlen>:

uint
strlen(const char *s)
{
 259:	55                   	push   %ebp
 25a:	89 e5                	mov    %esp,%ebp
 25c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 25f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 266:	eb 03                	jmp    26b <strlen+0x12>
 268:	ff 45 fc             	incl   -0x4(%ebp)
 26b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26e:	8b 45 08             	mov    0x8(%ebp),%eax
 271:	01 d0                	add    %edx,%eax
 273:	8a 00                	mov    (%eax),%al
 275:	84 c0                	test   %al,%al
 277:	75 ef                	jne    268 <strlen+0xf>
    ;
  return n;
 279:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 27c:	c9                   	leave  
 27d:	c3                   	ret    

0000027e <memset>:

void*
memset(void *dst, int c, uint n)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 284:	8b 45 10             	mov    0x10(%ebp),%eax
 287:	89 44 24 08          	mov    %eax,0x8(%esp)
 28b:	8b 45 0c             	mov    0xc(%ebp),%eax
 28e:	89 44 24 04          	mov    %eax,0x4(%esp)
 292:	8b 45 08             	mov    0x8(%ebp),%eax
 295:	89 04 24             	mov    %eax,(%esp)
 298:	e8 cf fd ff ff       	call   6c <stosb>
  return dst;
 29d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2a0:	c9                   	leave  
 2a1:	c3                   	ret    

000002a2 <strchr>:

char*
strchr(const char *s, char c)
{
 2a2:	55                   	push   %ebp
 2a3:	89 e5                	mov    %esp,%ebp
 2a5:	83 ec 04             	sub    $0x4,%esp
 2a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ab:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2ae:	eb 12                	jmp    2c2 <strchr+0x20>
    if(*s == c)
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	8a 00                	mov    (%eax),%al
 2b5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b8:	75 05                	jne    2bf <strchr+0x1d>
      return (char*)s;
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	eb 11                	jmp    2d0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2bf:	ff 45 08             	incl   0x8(%ebp)
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	8a 00                	mov    (%eax),%al
 2c7:	84 c0                	test   %al,%al
 2c9:	75 e5                	jne    2b0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <strcat>:

char *
strcat(char *dest, const char *src)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2d8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2df:	eb 03                	jmp    2e4 <strcat+0x12>
 2e1:	ff 45 fc             	incl   -0x4(%ebp)
 2e4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ea:	01 d0                	add    %edx,%eax
 2ec:	8a 00                	mov    (%eax),%al
 2ee:	84 c0                	test   %al,%al
 2f0:	75 ef                	jne    2e1 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 2f2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 2f9:	eb 1e                	jmp    319 <strcat+0x47>
        dest[i+j] = src[j];
 2fb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
 301:	01 d0                	add    %edx,%eax
 303:	89 c2                	mov    %eax,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	01 c2                	add    %eax,%edx
 30a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 30d:	8b 45 0c             	mov    0xc(%ebp),%eax
 310:	01 c8                	add    %ecx,%eax
 312:	8a 00                	mov    (%eax),%al
 314:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 316:	ff 45 f8             	incl   -0x8(%ebp)
 319:	8b 55 f8             	mov    -0x8(%ebp),%edx
 31c:	8b 45 0c             	mov    0xc(%ebp),%eax
 31f:	01 d0                	add    %edx,%eax
 321:	8a 00                	mov    (%eax),%al
 323:	84 c0                	test   %al,%al
 325:	75 d4                	jne    2fb <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 327:	8b 45 f8             	mov    -0x8(%ebp),%eax
 32a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 32d:	01 d0                	add    %edx,%eax
 32f:	89 c2                	mov    %eax,%edx
 331:	8b 45 08             	mov    0x8(%ebp),%eax
 334:	01 d0                	add    %edx,%eax
 336:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 339:	8b 45 08             	mov    0x8(%ebp),%eax
}
 33c:	c9                   	leave  
 33d:	c3                   	ret    

0000033e <strstr>:

int 
strstr(char* s, char* sub)
{
 33e:	55                   	push   %ebp
 33f:	89 e5                	mov    %esp,%ebp
 341:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 344:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 34b:	eb 7c                	jmp    3c9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 34d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	01 d0                	add    %edx,%eax
 355:	8a 10                	mov    (%eax),%dl
 357:	8b 45 0c             	mov    0xc(%ebp),%eax
 35a:	8a 00                	mov    (%eax),%al
 35c:	38 c2                	cmp    %al,%dl
 35e:	75 66                	jne    3c6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 360:	8b 45 0c             	mov    0xc(%ebp),%eax
 363:	89 04 24             	mov    %eax,(%esp)
 366:	e8 ee fe ff ff       	call   259 <strlen>
 36b:	83 f8 01             	cmp    $0x1,%eax
 36e:	75 05                	jne    375 <strstr+0x37>
            {  
                return i;
 370:	8b 45 fc             	mov    -0x4(%ebp),%eax
 373:	eb 6b                	jmp    3e0 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 375:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 37c:	eb 3a                	jmp    3b8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 37e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 381:	8b 55 fc             	mov    -0x4(%ebp),%edx
 384:	01 d0                	add    %edx,%eax
 386:	89 c2                	mov    %eax,%edx
 388:	8b 45 08             	mov    0x8(%ebp),%eax
 38b:	01 d0                	add    %edx,%eax
 38d:	8a 10                	mov    (%eax),%dl
 38f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	01 c8                	add    %ecx,%eax
 397:	8a 00                	mov    (%eax),%al
 399:	38 c2                	cmp    %al,%dl
 39b:	75 16                	jne    3b3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 39d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a0:	8d 50 01             	lea    0x1(%eax),%edx
 3a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a6:	01 d0                	add    %edx,%eax
 3a8:	8a 00                	mov    (%eax),%al
 3aa:	84 c0                	test   %al,%al
 3ac:	75 07                	jne    3b5 <strstr+0x77>
                    {
                        return i;
 3ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3b1:	eb 2d                	jmp    3e0 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3b3:	eb 11                	jmp    3c6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3b5:	ff 45 f8             	incl   -0x8(%ebp)
 3b8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3be:	01 d0                	add    %edx,%eax
 3c0:	8a 00                	mov    (%eax),%al
 3c2:	84 c0                	test   %al,%al
 3c4:	75 b8                	jne    37e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3c6:	ff 45 fc             	incl   -0x4(%ebp)
 3c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	01 d0                	add    %edx,%eax
 3d1:	8a 00                	mov    (%eax),%al
 3d3:	84 c0                	test   %al,%al
 3d5:	0f 85 72 ff ff ff    	jne    34d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 3db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3e0:	c9                   	leave  
 3e1:	c3                   	ret    

000003e2 <strtok>:

char *
strtok(char *s, const char *delim)
{
 3e2:	55                   	push   %ebp
 3e3:	89 e5                	mov    %esp,%ebp
 3e5:	53                   	push   %ebx
 3e6:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3ed:	75 08                	jne    3f7 <strtok+0x15>
  s = lasts;
 3ef:	a1 c4 11 00 00       	mov    0x11c4,%eax
 3f4:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 3f7:	8b 45 08             	mov    0x8(%ebp),%eax
 3fa:	8d 50 01             	lea    0x1(%eax),%edx
 3fd:	89 55 08             	mov    %edx,0x8(%ebp)
 400:	8a 00                	mov    (%eax),%al
 402:	0f be d8             	movsbl %al,%ebx
 405:	85 db                	test   %ebx,%ebx
 407:	75 07                	jne    410 <strtok+0x2e>
      return 0;
 409:	b8 00 00 00 00       	mov    $0x0,%eax
 40e:	eb 58                	jmp    468 <strtok+0x86>
    } while (strchr(delim, ch));
 410:	88 d8                	mov    %bl,%al
 412:	0f be c0             	movsbl %al,%eax
 415:	89 44 24 04          	mov    %eax,0x4(%esp)
 419:	8b 45 0c             	mov    0xc(%ebp),%eax
 41c:	89 04 24             	mov    %eax,(%esp)
 41f:	e8 7e fe ff ff       	call   2a2 <strchr>
 424:	85 c0                	test   %eax,%eax
 426:	75 cf                	jne    3f7 <strtok+0x15>
    --s;
 428:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 42b:	8b 45 0c             	mov    0xc(%ebp),%eax
 42e:	89 44 24 04          	mov    %eax,0x4(%esp)
 432:	8b 45 08             	mov    0x8(%ebp),%eax
 435:	89 04 24             	mov    %eax,(%esp)
 438:	e8 31 00 00 00       	call   46e <strcspn>
 43d:	89 c2                	mov    %eax,%edx
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	01 d0                	add    %edx,%eax
 444:	a3 c4 11 00 00       	mov    %eax,0x11c4
    if (*lasts != 0)
 449:	a1 c4 11 00 00       	mov    0x11c4,%eax
 44e:	8a 00                	mov    (%eax),%al
 450:	84 c0                	test   %al,%al
 452:	74 11                	je     465 <strtok+0x83>
  *lasts++ = 0;
 454:	a1 c4 11 00 00       	mov    0x11c4,%eax
 459:	8d 50 01             	lea    0x1(%eax),%edx
 45c:	89 15 c4 11 00 00    	mov    %edx,0x11c4
 462:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 465:	8b 45 08             	mov    0x8(%ebp),%eax
}
 468:	83 c4 14             	add    $0x14,%esp
 46b:	5b                   	pop    %ebx
 46c:	5d                   	pop    %ebp
 46d:	c3                   	ret    

0000046e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 46e:	55                   	push   %ebp
 46f:	89 e5                	mov    %esp,%ebp
 471:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 474:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 47b:	eb 26                	jmp    4a3 <strcspn+0x35>
        if(strchr(s2,*s1))
 47d:	8b 45 08             	mov    0x8(%ebp),%eax
 480:	8a 00                	mov    (%eax),%al
 482:	0f be c0             	movsbl %al,%eax
 485:	89 44 24 04          	mov    %eax,0x4(%esp)
 489:	8b 45 0c             	mov    0xc(%ebp),%eax
 48c:	89 04 24             	mov    %eax,(%esp)
 48f:	e8 0e fe ff ff       	call   2a2 <strchr>
 494:	85 c0                	test   %eax,%eax
 496:	74 05                	je     49d <strcspn+0x2f>
            return ret;
 498:	8b 45 fc             	mov    -0x4(%ebp),%eax
 49b:	eb 12                	jmp    4af <strcspn+0x41>
        else
            s1++,ret++;
 49d:	ff 45 08             	incl   0x8(%ebp)
 4a0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	8a 00                	mov    (%eax),%al
 4a8:	84 c0                	test   %al,%al
 4aa:	75 d1                	jne    47d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4af:	c9                   	leave  
 4b0:	c3                   	ret    

000004b1 <isspace>:

int
isspace(unsigned char c)
{
 4b1:	55                   	push   %ebp
 4b2:	89 e5                	mov    %esp,%ebp
 4b4:	83 ec 04             	sub    $0x4,%esp
 4b7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ba:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4bd:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4c1:	74 1e                	je     4e1 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4c3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4c7:	74 18                	je     4e1 <isspace+0x30>
 4c9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4cd:	74 12                	je     4e1 <isspace+0x30>
 4cf:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4d3:	74 0c                	je     4e1 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4d5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 4d9:	74 06                	je     4e1 <isspace+0x30>
 4db:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 4df:	75 07                	jne    4e8 <isspace+0x37>
 4e1:	b8 01 00 00 00       	mov    $0x1,%eax
 4e6:	eb 05                	jmp    4ed <isspace+0x3c>
 4e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	57                   	push   %edi
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
 4f5:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 4f8:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 4fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 504:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 507:	eb 01                	jmp    50a <strtoul+0x1b>
  p += 1;
 509:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 50a:	8a 03                	mov    (%ebx),%al
 50c:	0f b6 c0             	movzbl %al,%eax
 50f:	89 04 24             	mov    %eax,(%esp)
 512:	e8 9a ff ff ff       	call   4b1 <isspace>
 517:	85 c0                	test   %eax,%eax
 519:	75 ee                	jne    509 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 51b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 51f:	75 30                	jne    551 <strtoul+0x62>
    {
  if (*p == '0') {
 521:	8a 03                	mov    (%ebx),%al
 523:	3c 30                	cmp    $0x30,%al
 525:	75 21                	jne    548 <strtoul+0x59>
      p += 1;
 527:	43                   	inc    %ebx
      if (*p == 'x') {
 528:	8a 03                	mov    (%ebx),%al
 52a:	3c 78                	cmp    $0x78,%al
 52c:	75 0a                	jne    538 <strtoul+0x49>
    p += 1;
 52e:	43                   	inc    %ebx
    base = 16;
 52f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 536:	eb 31                	jmp    569 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 538:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 53f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 546:	eb 21                	jmp    569 <strtoul+0x7a>
      }
  }
  else base = 10;
 548:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 54f:	eb 18                	jmp    569 <strtoul+0x7a>
    } else if (base == 16) {
 551:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 555:	75 12                	jne    569 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 557:	8a 03                	mov    (%ebx),%al
 559:	3c 30                	cmp    $0x30,%al
 55b:	75 0c                	jne    569 <strtoul+0x7a>
 55d:	8d 43 01             	lea    0x1(%ebx),%eax
 560:	8a 00                	mov    (%eax),%al
 562:	3c 78                	cmp    $0x78,%al
 564:	75 03                	jne    569 <strtoul+0x7a>
      p += 2;
 566:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 569:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 56d:	75 29                	jne    598 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 56f:	8a 03                	mov    (%ebx),%al
 571:	0f be c0             	movsbl %al,%eax
 574:	83 e8 30             	sub    $0x30,%eax
 577:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 579:	83 fe 07             	cmp    $0x7,%esi
 57c:	76 06                	jbe    584 <strtoul+0x95>
    break;
 57e:	90                   	nop
 57f:	e9 b6 00 00 00       	jmp    63a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 584:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 58b:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 58e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 595:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 596:	eb d7                	jmp    56f <strtoul+0x80>
    } else if (base == 10) {
 598:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 59c:	75 2b                	jne    5c9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 59e:	8a 03                	mov    (%ebx),%al
 5a0:	0f be c0             	movsbl %al,%eax
 5a3:	83 e8 30             	sub    $0x30,%eax
 5a6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5a8:	83 fe 09             	cmp    $0x9,%esi
 5ab:	76 06                	jbe    5b3 <strtoul+0xc4>
    break;
 5ad:	90                   	nop
 5ae:	e9 87 00 00 00       	jmp    63a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5b3:	89 f8                	mov    %edi,%eax
 5b5:	c1 e0 02             	shl    $0x2,%eax
 5b8:	01 f8                	add    %edi,%eax
 5ba:	01 c0                	add    %eax,%eax
 5bc:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5bf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5c6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5c7:	eb d5                	jmp    59e <strtoul+0xaf>
    } else if (base == 16) {
 5c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5cd:	75 35                	jne    604 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5cf:	8a 03                	mov    (%ebx),%al
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	83 e8 30             	sub    $0x30,%eax
 5d7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5d9:	83 fe 4a             	cmp    $0x4a,%esi
 5dc:	76 02                	jbe    5e0 <strtoul+0xf1>
    break;
 5de:	eb 22                	jmp    602 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 5e0:	8a 86 60 11 00 00    	mov    0x1160(%esi),%al
 5e6:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5e9:	83 fe 0f             	cmp    $0xf,%esi
 5ec:	76 02                	jbe    5f0 <strtoul+0x101>
    break;
 5ee:	eb 12                	jmp    602 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 5f0:	89 f8                	mov    %edi,%eax
 5f2:	c1 e0 04             	shl    $0x4,%eax
 5f5:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5f8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 5ff:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 600:	eb cd                	jmp    5cf <strtoul+0xe0>
 602:	eb 36                	jmp    63a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 604:	8a 03                	mov    (%ebx),%al
 606:	0f be c0             	movsbl %al,%eax
 609:	83 e8 30             	sub    $0x30,%eax
 60c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 60e:	83 fe 4a             	cmp    $0x4a,%esi
 611:	76 02                	jbe    615 <strtoul+0x126>
    break;
 613:	eb 25                	jmp    63a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 615:	8a 86 60 11 00 00    	mov    0x1160(%esi),%al
 61b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 61e:	8b 45 10             	mov    0x10(%ebp),%eax
 621:	39 f0                	cmp    %esi,%eax
 623:	77 02                	ja     627 <strtoul+0x138>
    break;
 625:	eb 13                	jmp    63a <strtoul+0x14b>
      }
      result = result*base + digit;
 627:	8b 45 10             	mov    0x10(%ebp),%eax
 62a:	0f af c7             	imul   %edi,%eax
 62d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 630:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 637:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 638:	eb ca                	jmp    604 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 63a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 63e:	75 03                	jne    643 <strtoul+0x154>
  p = string;
 640:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 643:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 647:	74 05                	je     64e <strtoul+0x15f>
  *endPtr = p;
 649:	8b 45 0c             	mov    0xc(%ebp),%eax
 64c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 64e:	89 f8                	mov    %edi,%eax
}
 650:	83 c4 14             	add    $0x14,%esp
 653:	5b                   	pop    %ebx
 654:	5e                   	pop    %esi
 655:	5f                   	pop    %edi
 656:	5d                   	pop    %ebp
 657:	c3                   	ret    

00000658 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 658:	55                   	push   %ebp
 659:	89 e5                	mov    %esp,%ebp
 65b:	53                   	push   %ebx
 65c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 65f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 662:	eb 01                	jmp    665 <strtol+0xd>
      p += 1;
 664:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 665:	8a 03                	mov    (%ebx),%al
 667:	0f b6 c0             	movzbl %al,%eax
 66a:	89 04 24             	mov    %eax,(%esp)
 66d:	e8 3f fe ff ff       	call   4b1 <isspace>
 672:	85 c0                	test   %eax,%eax
 674:	75 ee                	jne    664 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 676:	8a 03                	mov    (%ebx),%al
 678:	3c 2d                	cmp    $0x2d,%al
 67a:	75 1e                	jne    69a <strtol+0x42>
  p += 1;
 67c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 67d:	8b 45 10             	mov    0x10(%ebp),%eax
 680:	89 44 24 08          	mov    %eax,0x8(%esp)
 684:	8b 45 0c             	mov    0xc(%ebp),%eax
 687:	89 44 24 04          	mov    %eax,0x4(%esp)
 68b:	89 1c 24             	mov    %ebx,(%esp)
 68e:	e8 5c fe ff ff       	call   4ef <strtoul>
 693:	f7 d8                	neg    %eax
 695:	89 45 f8             	mov    %eax,-0x8(%ebp)
 698:	eb 20                	jmp    6ba <strtol+0x62>
    } else {
  if (*p == '+') {
 69a:	8a 03                	mov    (%ebx),%al
 69c:	3c 2b                	cmp    $0x2b,%al
 69e:	75 01                	jne    6a1 <strtol+0x49>
      p += 1;
 6a0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6a1:	8b 45 10             	mov    0x10(%ebp),%eax
 6a4:	89 44 24 08          	mov    %eax,0x8(%esp)
 6a8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ab:	89 44 24 04          	mov    %eax,0x4(%esp)
 6af:	89 1c 24             	mov    %ebx,(%esp)
 6b2:	e8 38 fe ff ff       	call   4ef <strtoul>
 6b7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6ba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6be:	75 17                	jne    6d7 <strtol+0x7f>
 6c0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6c4:	74 11                	je     6d7 <strtol+0x7f>
 6c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c9:	8b 00                	mov    (%eax),%eax
 6cb:	39 d8                	cmp    %ebx,%eax
 6cd:	75 08                	jne    6d7 <strtol+0x7f>
  *endPtr = string;
 6cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d2:	8b 55 08             	mov    0x8(%ebp),%edx
 6d5:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 6da:	83 c4 1c             	add    $0x1c,%esp
 6dd:	5b                   	pop    %ebx
 6de:	5d                   	pop    %ebp
 6df:	c3                   	ret    

000006e0 <gets>:

char*
gets(char *buf, int max)
{
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6ed:	eb 49                	jmp    738 <gets+0x58>
    cc = read(0, &c, 1);
 6ef:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6f6:	00 
 6f7:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 705:	e8 3e 01 00 00       	call   848 <read>
 70a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 70d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 711:	7f 02                	jg     715 <gets+0x35>
      break;
 713:	eb 2c                	jmp    741 <gets+0x61>
    buf[i++] = c;
 715:	8b 45 f4             	mov    -0xc(%ebp),%eax
 718:	8d 50 01             	lea    0x1(%eax),%edx
 71b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 71e:	89 c2                	mov    %eax,%edx
 720:	8b 45 08             	mov    0x8(%ebp),%eax
 723:	01 c2                	add    %eax,%edx
 725:	8a 45 ef             	mov    -0x11(%ebp),%al
 728:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 72a:	8a 45 ef             	mov    -0x11(%ebp),%al
 72d:	3c 0a                	cmp    $0xa,%al
 72f:	74 10                	je     741 <gets+0x61>
 731:	8a 45 ef             	mov    -0x11(%ebp),%al
 734:	3c 0d                	cmp    $0xd,%al
 736:	74 09                	je     741 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 738:	8b 45 f4             	mov    -0xc(%ebp),%eax
 73b:	40                   	inc    %eax
 73c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 73f:	7c ae                	jl     6ef <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 741:	8b 55 f4             	mov    -0xc(%ebp),%edx
 744:	8b 45 08             	mov    0x8(%ebp),%eax
 747:	01 d0                	add    %edx,%eax
 749:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 74c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 74f:	c9                   	leave  
 750:	c3                   	ret    

00000751 <stat>:

int
stat(char *n, struct stat *st)
{
 751:	55                   	push   %ebp
 752:	89 e5                	mov    %esp,%ebp
 754:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 757:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 75e:	00 
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	89 04 24             	mov    %eax,(%esp)
 765:	e8 06 01 00 00       	call   870 <open>
 76a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 76d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 771:	79 07                	jns    77a <stat+0x29>
    return -1;
 773:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 778:	eb 23                	jmp    79d <stat+0x4c>
  r = fstat(fd, st);
 77a:	8b 45 0c             	mov    0xc(%ebp),%eax
 77d:	89 44 24 04          	mov    %eax,0x4(%esp)
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	89 04 24             	mov    %eax,(%esp)
 787:	e8 fc 00 00 00       	call   888 <fstat>
 78c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 78f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 792:	89 04 24             	mov    %eax,(%esp)
 795:	e8 be 00 00 00       	call   858 <close>
  return r;
 79a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 79d:	c9                   	leave  
 79e:	c3                   	ret    

0000079f <atoi>:

int
atoi(const char *s)
{
 79f:	55                   	push   %ebp
 7a0:	89 e5                	mov    %esp,%ebp
 7a2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7ac:	eb 24                	jmp    7d2 <atoi+0x33>
    n = n*10 + *s++ - '0';
 7ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7b1:	89 d0                	mov    %edx,%eax
 7b3:	c1 e0 02             	shl    $0x2,%eax
 7b6:	01 d0                	add    %edx,%eax
 7b8:	01 c0                	add    %eax,%eax
 7ba:	89 c1                	mov    %eax,%ecx
 7bc:	8b 45 08             	mov    0x8(%ebp),%eax
 7bf:	8d 50 01             	lea    0x1(%eax),%edx
 7c2:	89 55 08             	mov    %edx,0x8(%ebp)
 7c5:	8a 00                	mov    (%eax),%al
 7c7:	0f be c0             	movsbl %al,%eax
 7ca:	01 c8                	add    %ecx,%eax
 7cc:	83 e8 30             	sub    $0x30,%eax
 7cf:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7d2:	8b 45 08             	mov    0x8(%ebp),%eax
 7d5:	8a 00                	mov    (%eax),%al
 7d7:	3c 2f                	cmp    $0x2f,%al
 7d9:	7e 09                	jle    7e4 <atoi+0x45>
 7db:	8b 45 08             	mov    0x8(%ebp),%eax
 7de:	8a 00                	mov    (%eax),%al
 7e0:	3c 39                	cmp    $0x39,%al
 7e2:	7e ca                	jle    7ae <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7e7:	c9                   	leave  
 7e8:	c3                   	ret    

000007e9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7e9:	55                   	push   %ebp
 7ea:	89 e5                	mov    %esp,%ebp
 7ec:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7ef:	8b 45 08             	mov    0x8(%ebp),%eax
 7f2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 7f8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7fb:	eb 16                	jmp    813 <memmove+0x2a>
    *dst++ = *src++;
 7fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 800:	8d 50 01             	lea    0x1(%eax),%edx
 803:	89 55 fc             	mov    %edx,-0x4(%ebp)
 806:	8b 55 f8             	mov    -0x8(%ebp),%edx
 809:	8d 4a 01             	lea    0x1(%edx),%ecx
 80c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 80f:	8a 12                	mov    (%edx),%dl
 811:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 813:	8b 45 10             	mov    0x10(%ebp),%eax
 816:	8d 50 ff             	lea    -0x1(%eax),%edx
 819:	89 55 10             	mov    %edx,0x10(%ebp)
 81c:	85 c0                	test   %eax,%eax
 81e:	7f dd                	jg     7fd <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 820:	8b 45 08             	mov    0x8(%ebp),%eax
}
 823:	c9                   	leave  
 824:	c3                   	ret    
 825:	90                   	nop
 826:	90                   	nop
 827:	90                   	nop

00000828 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 828:	b8 01 00 00 00       	mov    $0x1,%eax
 82d:	cd 40                	int    $0x40
 82f:	c3                   	ret    

00000830 <exit>:
SYSCALL(exit)
 830:	b8 02 00 00 00       	mov    $0x2,%eax
 835:	cd 40                	int    $0x40
 837:	c3                   	ret    

00000838 <wait>:
SYSCALL(wait)
 838:	b8 03 00 00 00       	mov    $0x3,%eax
 83d:	cd 40                	int    $0x40
 83f:	c3                   	ret    

00000840 <pipe>:
SYSCALL(pipe)
 840:	b8 04 00 00 00       	mov    $0x4,%eax
 845:	cd 40                	int    $0x40
 847:	c3                   	ret    

00000848 <read>:
SYSCALL(read)
 848:	b8 05 00 00 00       	mov    $0x5,%eax
 84d:	cd 40                	int    $0x40
 84f:	c3                   	ret    

00000850 <write>:
SYSCALL(write)
 850:	b8 10 00 00 00       	mov    $0x10,%eax
 855:	cd 40                	int    $0x40
 857:	c3                   	ret    

00000858 <close>:
SYSCALL(close)
 858:	b8 15 00 00 00       	mov    $0x15,%eax
 85d:	cd 40                	int    $0x40
 85f:	c3                   	ret    

00000860 <kill>:
SYSCALL(kill)
 860:	b8 06 00 00 00       	mov    $0x6,%eax
 865:	cd 40                	int    $0x40
 867:	c3                   	ret    

00000868 <exec>:
SYSCALL(exec)
 868:	b8 07 00 00 00       	mov    $0x7,%eax
 86d:	cd 40                	int    $0x40
 86f:	c3                   	ret    

00000870 <open>:
SYSCALL(open)
 870:	b8 0f 00 00 00       	mov    $0xf,%eax
 875:	cd 40                	int    $0x40
 877:	c3                   	ret    

00000878 <mknod>:
SYSCALL(mknod)
 878:	b8 11 00 00 00       	mov    $0x11,%eax
 87d:	cd 40                	int    $0x40
 87f:	c3                   	ret    

00000880 <unlink>:
SYSCALL(unlink)
 880:	b8 12 00 00 00       	mov    $0x12,%eax
 885:	cd 40                	int    $0x40
 887:	c3                   	ret    

00000888 <fstat>:
SYSCALL(fstat)
 888:	b8 08 00 00 00       	mov    $0x8,%eax
 88d:	cd 40                	int    $0x40
 88f:	c3                   	ret    

00000890 <link>:
SYSCALL(link)
 890:	b8 13 00 00 00       	mov    $0x13,%eax
 895:	cd 40                	int    $0x40
 897:	c3                   	ret    

00000898 <mkdir>:
SYSCALL(mkdir)
 898:	b8 14 00 00 00       	mov    $0x14,%eax
 89d:	cd 40                	int    $0x40
 89f:	c3                   	ret    

000008a0 <chdir>:
SYSCALL(chdir)
 8a0:	b8 09 00 00 00       	mov    $0x9,%eax
 8a5:	cd 40                	int    $0x40
 8a7:	c3                   	ret    

000008a8 <dup>:
SYSCALL(dup)
 8a8:	b8 0a 00 00 00       	mov    $0xa,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <getpid>:
SYSCALL(getpid)
 8b0:	b8 0b 00 00 00       	mov    $0xb,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <sbrk>:
SYSCALL(sbrk)
 8b8:	b8 0c 00 00 00       	mov    $0xc,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <sleep>:
SYSCALL(sleep)
 8c0:	b8 0d 00 00 00       	mov    $0xd,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <uptime>:
SYSCALL(uptime)
 8c8:	b8 0e 00 00 00       	mov    $0xe,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8d0:	55                   	push   %ebp
 8d1:	89 e5                	mov    %esp,%ebp
 8d3:	83 ec 18             	sub    $0x18,%esp
 8d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 8d9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8dc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 8e3:	00 
 8e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 8e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8eb:	8b 45 08             	mov    0x8(%ebp),%eax
 8ee:	89 04 24             	mov    %eax,(%esp)
 8f1:	e8 5a ff ff ff       	call   850 <write>
}
 8f6:	c9                   	leave  
 8f7:	c3                   	ret    

000008f8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 8f8:	55                   	push   %ebp
 8f9:	89 e5                	mov    %esp,%ebp
 8fb:	56                   	push   %esi
 8fc:	53                   	push   %ebx
 8fd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 900:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 907:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 90b:	74 17                	je     924 <printint+0x2c>
 90d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 911:	79 11                	jns    924 <printint+0x2c>
    neg = 1;
 913:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 91a:	8b 45 0c             	mov    0xc(%ebp),%eax
 91d:	f7 d8                	neg    %eax
 91f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 922:	eb 06                	jmp    92a <printint+0x32>
  } else {
    x = xx;
 924:	8b 45 0c             	mov    0xc(%ebp),%eax
 927:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 92a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 931:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 934:	8d 41 01             	lea    0x1(%ecx),%eax
 937:	89 45 f4             	mov    %eax,-0xc(%ebp)
 93a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 93d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 940:	ba 00 00 00 00       	mov    $0x0,%edx
 945:	f7 f3                	div    %ebx
 947:	89 d0                	mov    %edx,%eax
 949:	8a 80 ac 11 00 00    	mov    0x11ac(%eax),%al
 94f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 953:	8b 75 10             	mov    0x10(%ebp),%esi
 956:	8b 45 ec             	mov    -0x14(%ebp),%eax
 959:	ba 00 00 00 00       	mov    $0x0,%edx
 95e:	f7 f6                	div    %esi
 960:	89 45 ec             	mov    %eax,-0x14(%ebp)
 963:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 967:	75 c8                	jne    931 <printint+0x39>
  if(neg)
 969:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 96d:	74 10                	je     97f <printint+0x87>
    buf[i++] = '-';
 96f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 972:	8d 50 01             	lea    0x1(%eax),%edx
 975:	89 55 f4             	mov    %edx,-0xc(%ebp)
 978:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 97d:	eb 1e                	jmp    99d <printint+0xa5>
 97f:	eb 1c                	jmp    99d <printint+0xa5>
    putc(fd, buf[i]);
 981:	8d 55 dc             	lea    -0x24(%ebp),%edx
 984:	8b 45 f4             	mov    -0xc(%ebp),%eax
 987:	01 d0                	add    %edx,%eax
 989:	8a 00                	mov    (%eax),%al
 98b:	0f be c0             	movsbl %al,%eax
 98e:	89 44 24 04          	mov    %eax,0x4(%esp)
 992:	8b 45 08             	mov    0x8(%ebp),%eax
 995:	89 04 24             	mov    %eax,(%esp)
 998:	e8 33 ff ff ff       	call   8d0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 99d:	ff 4d f4             	decl   -0xc(%ebp)
 9a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9a4:	79 db                	jns    981 <printint+0x89>
    putc(fd, buf[i]);
}
 9a6:	83 c4 30             	add    $0x30,%esp
 9a9:	5b                   	pop    %ebx
 9aa:	5e                   	pop    %esi
 9ab:	5d                   	pop    %ebp
 9ac:	c3                   	ret    

000009ad <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9ad:	55                   	push   %ebp
 9ae:	89 e5                	mov    %esp,%ebp
 9b0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9ba:	8d 45 0c             	lea    0xc(%ebp),%eax
 9bd:	83 c0 04             	add    $0x4,%eax
 9c0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9ca:	e9 77 01 00 00       	jmp    b46 <printf+0x199>
    c = fmt[i] & 0xff;
 9cf:	8b 55 0c             	mov    0xc(%ebp),%edx
 9d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d5:	01 d0                	add    %edx,%eax
 9d7:	8a 00                	mov    (%eax),%al
 9d9:	0f be c0             	movsbl %al,%eax
 9dc:	25 ff 00 00 00       	and    $0xff,%eax
 9e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9e8:	75 2c                	jne    a16 <printf+0x69>
      if(c == '%'){
 9ea:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9ee:	75 0c                	jne    9fc <printf+0x4f>
        state = '%';
 9f0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 9f7:	e9 47 01 00 00       	jmp    b43 <printf+0x196>
      } else {
        putc(fd, c);
 9fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ff:	0f be c0             	movsbl %al,%eax
 a02:	89 44 24 04          	mov    %eax,0x4(%esp)
 a06:	8b 45 08             	mov    0x8(%ebp),%eax
 a09:	89 04 24             	mov    %eax,(%esp)
 a0c:	e8 bf fe ff ff       	call   8d0 <putc>
 a11:	e9 2d 01 00 00       	jmp    b43 <printf+0x196>
      }
    } else if(state == '%'){
 a16:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a1a:	0f 85 23 01 00 00    	jne    b43 <printf+0x196>
      if(c == 'd'){
 a20:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a24:	75 2d                	jne    a53 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a26:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a29:	8b 00                	mov    (%eax),%eax
 a2b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a32:	00 
 a33:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a3a:	00 
 a3b:	89 44 24 04          	mov    %eax,0x4(%esp)
 a3f:	8b 45 08             	mov    0x8(%ebp),%eax
 a42:	89 04 24             	mov    %eax,(%esp)
 a45:	e8 ae fe ff ff       	call   8f8 <printint>
        ap++;
 a4a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a4e:	e9 e9 00 00 00       	jmp    b3c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a53:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a57:	74 06                	je     a5f <printf+0xb2>
 a59:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a5d:	75 2d                	jne    a8c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a62:	8b 00                	mov    (%eax),%eax
 a64:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a6b:	00 
 a6c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 a73:	00 
 a74:	89 44 24 04          	mov    %eax,0x4(%esp)
 a78:	8b 45 08             	mov    0x8(%ebp),%eax
 a7b:	89 04 24             	mov    %eax,(%esp)
 a7e:	e8 75 fe ff ff       	call   8f8 <printint>
        ap++;
 a83:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a87:	e9 b0 00 00 00       	jmp    b3c <printf+0x18f>
      } else if(c == 's'){
 a8c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a90:	75 42                	jne    ad4 <printf+0x127>
        s = (char*)*ap;
 a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a95:	8b 00                	mov    (%eax),%eax
 a97:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a9a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aa2:	75 09                	jne    aad <printf+0x100>
          s = "(null)";
 aa4:	c7 45 f4 c4 0d 00 00 	movl   $0xdc4,-0xc(%ebp)
        while(*s != 0){
 aab:	eb 1c                	jmp    ac9 <printf+0x11c>
 aad:	eb 1a                	jmp    ac9 <printf+0x11c>
          putc(fd, *s);
 aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab2:	8a 00                	mov    (%eax),%al
 ab4:	0f be c0             	movsbl %al,%eax
 ab7:	89 44 24 04          	mov    %eax,0x4(%esp)
 abb:	8b 45 08             	mov    0x8(%ebp),%eax
 abe:	89 04 24             	mov    %eax,(%esp)
 ac1:	e8 0a fe ff ff       	call   8d0 <putc>
          s++;
 ac6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 acc:	8a 00                	mov    (%eax),%al
 ace:	84 c0                	test   %al,%al
 ad0:	75 dd                	jne    aaf <printf+0x102>
 ad2:	eb 68                	jmp    b3c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 ad4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ad8:	75 1d                	jne    af7 <printf+0x14a>
        putc(fd, *ap);
 ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
 add:	8b 00                	mov    (%eax),%eax
 adf:	0f be c0             	movsbl %al,%eax
 ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
 ae6:	8b 45 08             	mov    0x8(%ebp),%eax
 ae9:	89 04 24             	mov    %eax,(%esp)
 aec:	e8 df fd ff ff       	call   8d0 <putc>
        ap++;
 af1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 af5:	eb 45                	jmp    b3c <printf+0x18f>
      } else if(c == '%'){
 af7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 afb:	75 17                	jne    b14 <printf+0x167>
        putc(fd, c);
 afd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b00:	0f be c0             	movsbl %al,%eax
 b03:	89 44 24 04          	mov    %eax,0x4(%esp)
 b07:	8b 45 08             	mov    0x8(%ebp),%eax
 b0a:	89 04 24             	mov    %eax,(%esp)
 b0d:	e8 be fd ff ff       	call   8d0 <putc>
 b12:	eb 28                	jmp    b3c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b14:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b1b:	00 
 b1c:	8b 45 08             	mov    0x8(%ebp),%eax
 b1f:	89 04 24             	mov    %eax,(%esp)
 b22:	e8 a9 fd ff ff       	call   8d0 <putc>
        putc(fd, c);
 b27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b2a:	0f be c0             	movsbl %al,%eax
 b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
 b31:	8b 45 08             	mov    0x8(%ebp),%eax
 b34:	89 04 24             	mov    %eax,(%esp)
 b37:	e8 94 fd ff ff       	call   8d0 <putc>
      }
      state = 0;
 b3c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b43:	ff 45 f0             	incl   -0x10(%ebp)
 b46:	8b 55 0c             	mov    0xc(%ebp),%edx
 b49:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4c:	01 d0                	add    %edx,%eax
 b4e:	8a 00                	mov    (%eax),%al
 b50:	84 c0                	test   %al,%al
 b52:	0f 85 77 fe ff ff    	jne    9cf <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b58:	c9                   	leave  
 b59:	c3                   	ret    
 b5a:	90                   	nop
 b5b:	90                   	nop

00000b5c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b5c:	55                   	push   %ebp
 b5d:	89 e5                	mov    %esp,%ebp
 b5f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b62:	8b 45 08             	mov    0x8(%ebp),%eax
 b65:	83 e8 08             	sub    $0x8,%eax
 b68:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b6b:	a1 d0 11 00 00       	mov    0x11d0,%eax
 b70:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b73:	eb 24                	jmp    b99 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b78:	8b 00                	mov    (%eax),%eax
 b7a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b7d:	77 12                	ja     b91 <free+0x35>
 b7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b82:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b85:	77 24                	ja     bab <free+0x4f>
 b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b8a:	8b 00                	mov    (%eax),%eax
 b8c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b8f:	77 1a                	ja     bab <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b94:	8b 00                	mov    (%eax),%eax
 b96:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b99:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b9f:	76 d4                	jbe    b75 <free+0x19>
 ba1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba4:	8b 00                	mov    (%eax),%eax
 ba6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ba9:	76 ca                	jbe    b75 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bab:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bae:	8b 40 04             	mov    0x4(%eax),%eax
 bb1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bbb:	01 c2                	add    %eax,%edx
 bbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc0:	8b 00                	mov    (%eax),%eax
 bc2:	39 c2                	cmp    %eax,%edx
 bc4:	75 24                	jne    bea <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bc9:	8b 50 04             	mov    0x4(%eax),%edx
 bcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bcf:	8b 00                	mov    (%eax),%eax
 bd1:	8b 40 04             	mov    0x4(%eax),%eax
 bd4:	01 c2                	add    %eax,%edx
 bd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 bdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdf:	8b 00                	mov    (%eax),%eax
 be1:	8b 10                	mov    (%eax),%edx
 be3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be6:	89 10                	mov    %edx,(%eax)
 be8:	eb 0a                	jmp    bf4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 bea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bed:	8b 10                	mov    (%eax),%edx
 bef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf7:	8b 40 04             	mov    0x4(%eax),%eax
 bfa:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c04:	01 d0                	add    %edx,%eax
 c06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c09:	75 20                	jne    c2b <free+0xcf>
    p->s.size += bp->s.size;
 c0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0e:	8b 50 04             	mov    0x4(%eax),%edx
 c11:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c14:	8b 40 04             	mov    0x4(%eax),%eax
 c17:	01 c2                	add    %eax,%edx
 c19:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c22:	8b 10                	mov    (%eax),%edx
 c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c27:	89 10                	mov    %edx,(%eax)
 c29:	eb 08                	jmp    c33 <free+0xd7>
  } else
    p->s.ptr = bp;
 c2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c31:	89 10                	mov    %edx,(%eax)
  freep = p;
 c33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c36:	a3 d0 11 00 00       	mov    %eax,0x11d0
}
 c3b:	c9                   	leave  
 c3c:	c3                   	ret    

00000c3d <morecore>:

static Header*
morecore(uint nu)
{
 c3d:	55                   	push   %ebp
 c3e:	89 e5                	mov    %esp,%ebp
 c40:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c43:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c4a:	77 07                	ja     c53 <morecore+0x16>
    nu = 4096;
 c4c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c53:	8b 45 08             	mov    0x8(%ebp),%eax
 c56:	c1 e0 03             	shl    $0x3,%eax
 c59:	89 04 24             	mov    %eax,(%esp)
 c5c:	e8 57 fc ff ff       	call   8b8 <sbrk>
 c61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c64:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c68:	75 07                	jne    c71 <morecore+0x34>
    return 0;
 c6a:	b8 00 00 00 00       	mov    $0x0,%eax
 c6f:	eb 22                	jmp    c93 <morecore+0x56>
  hp = (Header*)p;
 c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c7a:	8b 55 08             	mov    0x8(%ebp),%edx
 c7d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c83:	83 c0 08             	add    $0x8,%eax
 c86:	89 04 24             	mov    %eax,(%esp)
 c89:	e8 ce fe ff ff       	call   b5c <free>
  return freep;
 c8e:	a1 d0 11 00 00       	mov    0x11d0,%eax
}
 c93:	c9                   	leave  
 c94:	c3                   	ret    

00000c95 <malloc>:

void*
malloc(uint nbytes)
{
 c95:	55                   	push   %ebp
 c96:	89 e5                	mov    %esp,%ebp
 c98:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c9b:	8b 45 08             	mov    0x8(%ebp),%eax
 c9e:	83 c0 07             	add    $0x7,%eax
 ca1:	c1 e8 03             	shr    $0x3,%eax
 ca4:	40                   	inc    %eax
 ca5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ca8:	a1 d0 11 00 00       	mov    0x11d0,%eax
 cad:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cb4:	75 23                	jne    cd9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 cb6:	c7 45 f0 c8 11 00 00 	movl   $0x11c8,-0x10(%ebp)
 cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cc0:	a3 d0 11 00 00       	mov    %eax,0x11d0
 cc5:	a1 d0 11 00 00       	mov    0x11d0,%eax
 cca:	a3 c8 11 00 00       	mov    %eax,0x11c8
    base.s.size = 0;
 ccf:	c7 05 cc 11 00 00 00 	movl   $0x0,0x11cc
 cd6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cdc:	8b 00                	mov    (%eax),%eax
 cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce4:	8b 40 04             	mov    0x4(%eax),%eax
 ce7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cea:	72 4d                	jb     d39 <malloc+0xa4>
      if(p->s.size == nunits)
 cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cef:	8b 40 04             	mov    0x4(%eax),%eax
 cf2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 cf5:	75 0c                	jne    d03 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cfa:	8b 10                	mov    (%eax),%edx
 cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cff:	89 10                	mov    %edx,(%eax)
 d01:	eb 26                	jmp    d29 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d06:	8b 40 04             	mov    0x4(%eax),%eax
 d09:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d0c:	89 c2                	mov    %eax,%edx
 d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d11:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d17:	8b 40 04             	mov    0x4(%eax),%eax
 d1a:	c1 e0 03             	shl    $0x3,%eax
 d1d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d23:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d26:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d2c:	a3 d0 11 00 00       	mov    %eax,0x11d0
      return (void*)(p + 1);
 d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d34:	83 c0 08             	add    $0x8,%eax
 d37:	eb 38                	jmp    d71 <malloc+0xdc>
    }
    if(p == freep)
 d39:	a1 d0 11 00 00       	mov    0x11d0,%eax
 d3e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d41:	75 1b                	jne    d5e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d43:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d46:	89 04 24             	mov    %eax,(%esp)
 d49:	e8 ef fe ff ff       	call   c3d <morecore>
 d4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d55:	75 07                	jne    d5e <malloc+0xc9>
        return 0;
 d57:	b8 00 00 00 00       	mov    $0x0,%eax
 d5c:	eb 13                	jmp    d71 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d67:	8b 00                	mov    (%eax),%eax
 d69:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d6c:	e9 70 ff ff ff       	jmp    ce1 <malloc+0x4c>
}
 d71:	c9                   	leave  
 d72:	c3                   	ret    
