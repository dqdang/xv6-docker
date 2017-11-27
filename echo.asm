
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
  1d:	b8 e7 0d 00 00       	mov    $0xde7,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 e9 0d 00 00       	mov    $0xde9,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 eb 0d 00 	movl   $0xdeb,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 ca 09 00 00       	call   a21 <printf>
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
  64:	e8 b3 07 00 00       	call   81c <exit>
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

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
  bf:	55                   	push   %ebp
  c0:	89 e5                	mov    %esp,%ebp
  c2:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
  c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
  cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  d3:	00 
  d4:	8b 45 08             	mov    0x8(%ebp),%eax
  d7:	89 04 24             	mov    %eax,(%esp)
  da:	e8 7d 07 00 00       	call   85c <open>
  df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  e6:	79 20                	jns    108 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ef:	c7 44 24 04 f0 0d 00 	movl   $0xdf0,0x4(%esp)
  f6:	00 
  f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fe:	e8 1e 09 00 00       	call   a21 <printf>
      exit();
 103:	e8 14 07 00 00       	call   81c <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 108:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 10f:	00 
 110:	8b 45 0c             	mov    0xc(%ebp),%eax
 113:	89 04 24             	mov    %eax,(%esp)
 116:	e8 41 07 00 00       	call   85c <open>
 11b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 11e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 122:	79 20                	jns    144 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 124:	8b 45 0c             	mov    0xc(%ebp),%eax
 127:	89 44 24 08          	mov    %eax,0x8(%esp)
 12b:	c7 44 24 04 0b 0e 00 	movl   $0xe0b,0x4(%esp)
 132:	00 
 133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13a:	e8 e2 08 00 00       	call   a21 <printf>
      exit();
 13f:	e8 d8 06 00 00       	call   81c <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 144:	eb 3b                	jmp    181 <copy+0xc2>
  {
      max = used_disk+=count;
 146:	8b 45 e8             	mov    -0x18(%ebp),%eax
 149:	01 45 10             	add    %eax,0x10(%ebp)
 14c:	8b 45 10             	mov    0x10(%ebp),%eax
 14f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 152:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 155:	3b 45 14             	cmp    0x14(%ebp),%eax
 158:	7e 07                	jle    161 <copy+0xa2>
      {
        return -1;
 15a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 15f:	eb 5c                	jmp    1bd <copy+0xfe>
      }
      bytes = bytes + count;
 161:	8b 45 e8             	mov    -0x18(%ebp),%eax
 164:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 167:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 16e:	00 
 16f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 172:	89 44 24 04          	mov    %eax,0x4(%esp)
 176:	8b 45 ec             	mov    -0x14(%ebp),%eax
 179:	89 04 24             	mov    %eax,(%esp)
 17c:	e8 bb 06 00 00       	call   83c <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 181:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 188:	00 
 189:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 18c:	89 44 24 04          	mov    %eax,0x4(%esp)
 190:	8b 45 f0             	mov    -0x10(%ebp),%eax
 193:	89 04 24             	mov    %eax,(%esp)
 196:	e8 99 06 00 00       	call   834 <read>
 19b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 19e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1a2:	7f a2                	jg     146 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 1a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1a7:	89 04 24             	mov    %eax,(%esp)
 1aa:	e8 95 06 00 00       	call   844 <close>
  close(fd2);
 1af:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1b2:	89 04 24             	mov    %eax,(%esp)
 1b5:	e8 8a 06 00 00       	call   844 <close>
  return(bytes);
 1ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1bd:	c9                   	leave  
 1be:	c3                   	ret    

000001bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1bf:	55                   	push   %ebp
 1c0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1c2:	eb 06                	jmp    1ca <strcmp+0xb>
    p++, q++;
 1c4:	ff 45 08             	incl   0x8(%ebp)
 1c7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	8a 00                	mov    (%eax),%al
 1cf:	84 c0                	test   %al,%al
 1d1:	74 0e                	je     1e1 <strcmp+0x22>
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	8a 10                	mov    (%eax),%dl
 1d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1db:	8a 00                	mov    (%eax),%al
 1dd:	38 c2                	cmp    %al,%dl
 1df:	74 e3                	je     1c4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	8a 00                	mov    (%eax),%al
 1e6:	0f b6 d0             	movzbl %al,%edx
 1e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ec:	8a 00                	mov    (%eax),%al
 1ee:	0f b6 c0             	movzbl %al,%eax
 1f1:	29 c2                	sub    %eax,%edx
 1f3:	89 d0                	mov    %edx,%eax
}
 1f5:	5d                   	pop    %ebp
 1f6:	c3                   	ret    

000001f7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 1fa:	eb 09                	jmp    205 <strncmp+0xe>
    n--, p++, q++;
 1fc:	ff 4d 10             	decl   0x10(%ebp)
 1ff:	ff 45 08             	incl   0x8(%ebp)
 202:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 205:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 209:	74 17                	je     222 <strncmp+0x2b>
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	8a 00                	mov    (%eax),%al
 210:	84 c0                	test   %al,%al
 212:	74 0e                	je     222 <strncmp+0x2b>
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	8a 10                	mov    (%eax),%dl
 219:	8b 45 0c             	mov    0xc(%ebp),%eax
 21c:	8a 00                	mov    (%eax),%al
 21e:	38 c2                	cmp    %al,%dl
 220:	74 da                	je     1fc <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 222:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 226:	75 07                	jne    22f <strncmp+0x38>
    return 0;
 228:	b8 00 00 00 00       	mov    $0x0,%eax
 22d:	eb 14                	jmp    243 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	8a 00                	mov    (%eax),%al
 234:	0f b6 d0             	movzbl %al,%edx
 237:	8b 45 0c             	mov    0xc(%ebp),%eax
 23a:	8a 00                	mov    (%eax),%al
 23c:	0f b6 c0             	movzbl %al,%eax
 23f:	29 c2                	sub    %eax,%edx
 241:	89 d0                	mov    %edx,%eax
}
 243:	5d                   	pop    %ebp
 244:	c3                   	ret    

00000245 <strlen>:

uint
strlen(const char *s)
{
 245:	55                   	push   %ebp
 246:	89 e5                	mov    %esp,%ebp
 248:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 252:	eb 03                	jmp    257 <strlen+0x12>
 254:	ff 45 fc             	incl   -0x4(%ebp)
 257:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25a:	8b 45 08             	mov    0x8(%ebp),%eax
 25d:	01 d0                	add    %edx,%eax
 25f:	8a 00                	mov    (%eax),%al
 261:	84 c0                	test   %al,%al
 263:	75 ef                	jne    254 <strlen+0xf>
    ;
  return n;
 265:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 268:	c9                   	leave  
 269:	c3                   	ret    

0000026a <memset>:

void*
memset(void *dst, int c, uint n)
{
 26a:	55                   	push   %ebp
 26b:	89 e5                	mov    %esp,%ebp
 26d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 270:	8b 45 10             	mov    0x10(%ebp),%eax
 273:	89 44 24 08          	mov    %eax,0x8(%esp)
 277:	8b 45 0c             	mov    0xc(%ebp),%eax
 27a:	89 44 24 04          	mov    %eax,0x4(%esp)
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
 281:	89 04 24             	mov    %eax,(%esp)
 284:	e8 e3 fd ff ff       	call   6c <stosb>
  return dst;
 289:	8b 45 08             	mov    0x8(%ebp),%eax
}
 28c:	c9                   	leave  
 28d:	c3                   	ret    

0000028e <strchr>:

char*
strchr(const char *s, char c)
{
 28e:	55                   	push   %ebp
 28f:	89 e5                	mov    %esp,%ebp
 291:	83 ec 04             	sub    $0x4,%esp
 294:	8b 45 0c             	mov    0xc(%ebp),%eax
 297:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29a:	eb 12                	jmp    2ae <strchr+0x20>
    if(*s == c)
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	8a 00                	mov    (%eax),%al
 2a1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a4:	75 05                	jne    2ab <strchr+0x1d>
      return (char*)s;
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	eb 11                	jmp    2bc <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2ab:	ff 45 08             	incl   0x8(%ebp)
 2ae:	8b 45 08             	mov    0x8(%ebp),%eax
 2b1:	8a 00                	mov    (%eax),%al
 2b3:	84 c0                	test   %al,%al
 2b5:	75 e5                	jne    29c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2bc:	c9                   	leave  
 2bd:	c3                   	ret    

000002be <strcat>:

char *
strcat(char *dest, const char *src)
{
 2be:	55                   	push   %ebp
 2bf:	89 e5                	mov    %esp,%ebp
 2c1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2cb:	eb 03                	jmp    2d0 <strcat+0x12>
 2cd:	ff 45 fc             	incl   -0x4(%ebp)
 2d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d3:	8b 45 08             	mov    0x8(%ebp),%eax
 2d6:	01 d0                	add    %edx,%eax
 2d8:	8a 00                	mov    (%eax),%al
 2da:	84 c0                	test   %al,%al
 2dc:	75 ef                	jne    2cd <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 2de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 2e5:	eb 1e                	jmp    305 <strcat+0x47>
        dest[i+j] = src[j];
 2e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ed:	01 d0                	add    %edx,%eax
 2ef:	89 c2                	mov    %eax,%edx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	01 c2                	add    %eax,%edx
 2f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fc:	01 c8                	add    %ecx,%eax
 2fe:	8a 00                	mov    (%eax),%al
 300:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 302:	ff 45 f8             	incl   -0x8(%ebp)
 305:	8b 55 f8             	mov    -0x8(%ebp),%edx
 308:	8b 45 0c             	mov    0xc(%ebp),%eax
 30b:	01 d0                	add    %edx,%eax
 30d:	8a 00                	mov    (%eax),%al
 30f:	84 c0                	test   %al,%al
 311:	75 d4                	jne    2e7 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 313:	8b 45 f8             	mov    -0x8(%ebp),%eax
 316:	8b 55 fc             	mov    -0x4(%ebp),%edx
 319:	01 d0                	add    %edx,%eax
 31b:	89 c2                	mov    %eax,%edx
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	01 d0                	add    %edx,%eax
 322:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 325:	8b 45 08             	mov    0x8(%ebp),%eax
}
 328:	c9                   	leave  
 329:	c3                   	ret    

0000032a <strstr>:

int 
strstr(char* s, char* sub)
{
 32a:	55                   	push   %ebp
 32b:	89 e5                	mov    %esp,%ebp
 32d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 330:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 337:	eb 7c                	jmp    3b5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 339:	8b 55 fc             	mov    -0x4(%ebp),%edx
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	01 d0                	add    %edx,%eax
 341:	8a 10                	mov    (%eax),%dl
 343:	8b 45 0c             	mov    0xc(%ebp),%eax
 346:	8a 00                	mov    (%eax),%al
 348:	38 c2                	cmp    %al,%dl
 34a:	75 66                	jne    3b2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 34c:	8b 45 0c             	mov    0xc(%ebp),%eax
 34f:	89 04 24             	mov    %eax,(%esp)
 352:	e8 ee fe ff ff       	call   245 <strlen>
 357:	83 f8 01             	cmp    $0x1,%eax
 35a:	75 05                	jne    361 <strstr+0x37>
            {  
                return i;
 35c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 35f:	eb 6b                	jmp    3cc <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 361:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 368:	eb 3a                	jmp    3a4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 36a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 36d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 370:	01 d0                	add    %edx,%eax
 372:	89 c2                	mov    %eax,%edx
 374:	8b 45 08             	mov    0x8(%ebp),%eax
 377:	01 d0                	add    %edx,%eax
 379:	8a 10                	mov    (%eax),%dl
 37b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 37e:	8b 45 0c             	mov    0xc(%ebp),%eax
 381:	01 c8                	add    %ecx,%eax
 383:	8a 00                	mov    (%eax),%al
 385:	38 c2                	cmp    %al,%dl
 387:	75 16                	jne    39f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 389:	8b 45 f8             	mov    -0x8(%ebp),%eax
 38c:	8d 50 01             	lea    0x1(%eax),%edx
 38f:	8b 45 0c             	mov    0xc(%ebp),%eax
 392:	01 d0                	add    %edx,%eax
 394:	8a 00                	mov    (%eax),%al
 396:	84 c0                	test   %al,%al
 398:	75 07                	jne    3a1 <strstr+0x77>
                    {
                        return i;
 39a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 39d:	eb 2d                	jmp    3cc <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 39f:	eb 11                	jmp    3b2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3a1:	ff 45 f8             	incl   -0x8(%ebp)
 3a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	01 d0                	add    %edx,%eax
 3ac:	8a 00                	mov    (%eax),%al
 3ae:	84 c0                	test   %al,%al
 3b0:	75 b8                	jne    36a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3b2:	ff 45 fc             	incl   -0x4(%ebp)
 3b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	01 d0                	add    %edx,%eax
 3bd:	8a 00                	mov    (%eax),%al
 3bf:	84 c0                	test   %al,%al
 3c1:	0f 85 72 ff ff ff    	jne    339 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 3c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3cc:	c9                   	leave  
 3cd:	c3                   	ret    

000003ce <strtok>:

char *
strtok(char *s, const char *delim)
{
 3ce:	55                   	push   %ebp
 3cf:	89 e5                	mov    %esp,%ebp
 3d1:	53                   	push   %ebx
 3d2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3d9:	75 08                	jne    3e3 <strtok+0x15>
  s = lasts;
 3db:	a1 24 12 00 00       	mov    0x1224,%eax
 3e0:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	8d 50 01             	lea    0x1(%eax),%edx
 3e9:	89 55 08             	mov    %edx,0x8(%ebp)
 3ec:	8a 00                	mov    (%eax),%al
 3ee:	0f be d8             	movsbl %al,%ebx
 3f1:	85 db                	test   %ebx,%ebx
 3f3:	75 07                	jne    3fc <strtok+0x2e>
      return 0;
 3f5:	b8 00 00 00 00       	mov    $0x0,%eax
 3fa:	eb 58                	jmp    454 <strtok+0x86>
    } while (strchr(delim, ch));
 3fc:	88 d8                	mov    %bl,%al
 3fe:	0f be c0             	movsbl %al,%eax
 401:	89 44 24 04          	mov    %eax,0x4(%esp)
 405:	8b 45 0c             	mov    0xc(%ebp),%eax
 408:	89 04 24             	mov    %eax,(%esp)
 40b:	e8 7e fe ff ff       	call   28e <strchr>
 410:	85 c0                	test   %eax,%eax
 412:	75 cf                	jne    3e3 <strtok+0x15>
    --s;
 414:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 417:	8b 45 0c             	mov    0xc(%ebp),%eax
 41a:	89 44 24 04          	mov    %eax,0x4(%esp)
 41e:	8b 45 08             	mov    0x8(%ebp),%eax
 421:	89 04 24             	mov    %eax,(%esp)
 424:	e8 31 00 00 00       	call   45a <strcspn>
 429:	89 c2                	mov    %eax,%edx
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	01 d0                	add    %edx,%eax
 430:	a3 24 12 00 00       	mov    %eax,0x1224
    if (*lasts != 0)
 435:	a1 24 12 00 00       	mov    0x1224,%eax
 43a:	8a 00                	mov    (%eax),%al
 43c:	84 c0                	test   %al,%al
 43e:	74 11                	je     451 <strtok+0x83>
  *lasts++ = 0;
 440:	a1 24 12 00 00       	mov    0x1224,%eax
 445:	8d 50 01             	lea    0x1(%eax),%edx
 448:	89 15 24 12 00 00    	mov    %edx,0x1224
 44e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 451:	8b 45 08             	mov    0x8(%ebp),%eax
}
 454:	83 c4 14             	add    $0x14,%esp
 457:	5b                   	pop    %ebx
 458:	5d                   	pop    %ebp
 459:	c3                   	ret    

0000045a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 45a:	55                   	push   %ebp
 45b:	89 e5                	mov    %esp,%ebp
 45d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 460:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 467:	eb 26                	jmp    48f <strcspn+0x35>
        if(strchr(s2,*s1))
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	8a 00                	mov    (%eax),%al
 46e:	0f be c0             	movsbl %al,%eax
 471:	89 44 24 04          	mov    %eax,0x4(%esp)
 475:	8b 45 0c             	mov    0xc(%ebp),%eax
 478:	89 04 24             	mov    %eax,(%esp)
 47b:	e8 0e fe ff ff       	call   28e <strchr>
 480:	85 c0                	test   %eax,%eax
 482:	74 05                	je     489 <strcspn+0x2f>
            return ret;
 484:	8b 45 fc             	mov    -0x4(%ebp),%eax
 487:	eb 12                	jmp    49b <strcspn+0x41>
        else
            s1++,ret++;
 489:	ff 45 08             	incl   0x8(%ebp)
 48c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 48f:	8b 45 08             	mov    0x8(%ebp),%eax
 492:	8a 00                	mov    (%eax),%al
 494:	84 c0                	test   %al,%al
 496:	75 d1                	jne    469 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 498:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 49b:	c9                   	leave  
 49c:	c3                   	ret    

0000049d <isspace>:

int
isspace(unsigned char c)
{
 49d:	55                   	push   %ebp
 49e:	89 e5                	mov    %esp,%ebp
 4a0:	83 ec 04             	sub    $0x4,%esp
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4a9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4ad:	74 1e                	je     4cd <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4af:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4b3:	74 18                	je     4cd <isspace+0x30>
 4b5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4b9:	74 12                	je     4cd <isspace+0x30>
 4bb:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4bf:	74 0c                	je     4cd <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4c1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 4c5:	74 06                	je     4cd <isspace+0x30>
 4c7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 4cb:	75 07                	jne    4d4 <isspace+0x37>
 4cd:	b8 01 00 00 00       	mov    $0x1,%eax
 4d2:	eb 05                	jmp    4d9 <isspace+0x3c>
 4d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4d9:	c9                   	leave  
 4da:	c3                   	ret    

000004db <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4db:	55                   	push   %ebp
 4dc:	89 e5                	mov    %esp,%ebp
 4de:	57                   	push   %edi
 4df:	56                   	push   %esi
 4e0:	53                   	push   %ebx
 4e1:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 4e4:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 4e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 4f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 4f3:	eb 01                	jmp    4f6 <strtoul+0x1b>
  p += 1;
 4f5:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 4f6:	8a 03                	mov    (%ebx),%al
 4f8:	0f b6 c0             	movzbl %al,%eax
 4fb:	89 04 24             	mov    %eax,(%esp)
 4fe:	e8 9a ff ff ff       	call   49d <isspace>
 503:	85 c0                	test   %eax,%eax
 505:	75 ee                	jne    4f5 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 50b:	75 30                	jne    53d <strtoul+0x62>
    {
  if (*p == '0') {
 50d:	8a 03                	mov    (%ebx),%al
 50f:	3c 30                	cmp    $0x30,%al
 511:	75 21                	jne    534 <strtoul+0x59>
      p += 1;
 513:	43                   	inc    %ebx
      if (*p == 'x') {
 514:	8a 03                	mov    (%ebx),%al
 516:	3c 78                	cmp    $0x78,%al
 518:	75 0a                	jne    524 <strtoul+0x49>
    p += 1;
 51a:	43                   	inc    %ebx
    base = 16;
 51b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 522:	eb 31                	jmp    555 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 524:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 52b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 532:	eb 21                	jmp    555 <strtoul+0x7a>
      }
  }
  else base = 10;
 534:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 53b:	eb 18                	jmp    555 <strtoul+0x7a>
    } else if (base == 16) {
 53d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 541:	75 12                	jne    555 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 543:	8a 03                	mov    (%ebx),%al
 545:	3c 30                	cmp    $0x30,%al
 547:	75 0c                	jne    555 <strtoul+0x7a>
 549:	8d 43 01             	lea    0x1(%ebx),%eax
 54c:	8a 00                	mov    (%eax),%al
 54e:	3c 78                	cmp    $0x78,%al
 550:	75 03                	jne    555 <strtoul+0x7a>
      p += 2;
 552:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 555:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 559:	75 29                	jne    584 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 55b:	8a 03                	mov    (%ebx),%al
 55d:	0f be c0             	movsbl %al,%eax
 560:	83 e8 30             	sub    $0x30,%eax
 563:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 565:	83 fe 07             	cmp    $0x7,%esi
 568:	76 06                	jbe    570 <strtoul+0x95>
    break;
 56a:	90                   	nop
 56b:	e9 b6 00 00 00       	jmp    626 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 570:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 577:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 57a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 581:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 582:	eb d7                	jmp    55b <strtoul+0x80>
    } else if (base == 10) {
 584:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 588:	75 2b                	jne    5b5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 58a:	8a 03                	mov    (%ebx),%al
 58c:	0f be c0             	movsbl %al,%eax
 58f:	83 e8 30             	sub    $0x30,%eax
 592:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 594:	83 fe 09             	cmp    $0x9,%esi
 597:	76 06                	jbe    59f <strtoul+0xc4>
    break;
 599:	90                   	nop
 59a:	e9 87 00 00 00       	jmp    626 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 59f:	89 f8                	mov    %edi,%eax
 5a1:	c1 e0 02             	shl    $0x2,%eax
 5a4:	01 f8                	add    %edi,%eax
 5a6:	01 c0                	add    %eax,%eax
 5a8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5b2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5b3:	eb d5                	jmp    58a <strtoul+0xaf>
    } else if (base == 16) {
 5b5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5b9:	75 35                	jne    5f0 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5bb:	8a 03                	mov    (%ebx),%al
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 e8 30             	sub    $0x30,%eax
 5c3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5c5:	83 fe 4a             	cmp    $0x4a,%esi
 5c8:	76 02                	jbe    5cc <strtoul+0xf1>
    break;
 5ca:	eb 22                	jmp    5ee <strtoul+0x113>
      }
      digit = cvtIn[digit];
 5cc:	8a 86 c0 11 00 00    	mov    0x11c0(%esi),%al
 5d2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5d5:	83 fe 0f             	cmp    $0xf,%esi
 5d8:	76 02                	jbe    5dc <strtoul+0x101>
    break;
 5da:	eb 12                	jmp    5ee <strtoul+0x113>
      }
      result = (result << 4) + digit;
 5dc:	89 f8                	mov    %edi,%eax
 5de:	c1 e0 04             	shl    $0x4,%eax
 5e1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 5eb:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 5ec:	eb cd                	jmp    5bb <strtoul+0xe0>
 5ee:	eb 36                	jmp    626 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 5f0:	8a 03                	mov    (%ebx),%al
 5f2:	0f be c0             	movsbl %al,%eax
 5f5:	83 e8 30             	sub    $0x30,%eax
 5f8:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5fa:	83 fe 4a             	cmp    $0x4a,%esi
 5fd:	76 02                	jbe    601 <strtoul+0x126>
    break;
 5ff:	eb 25                	jmp    626 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 601:	8a 86 c0 11 00 00    	mov    0x11c0(%esi),%al
 607:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 60a:	8b 45 10             	mov    0x10(%ebp),%eax
 60d:	39 f0                	cmp    %esi,%eax
 60f:	77 02                	ja     613 <strtoul+0x138>
    break;
 611:	eb 13                	jmp    626 <strtoul+0x14b>
      }
      result = result*base + digit;
 613:	8b 45 10             	mov    0x10(%ebp),%eax
 616:	0f af c7             	imul   %edi,%eax
 619:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 61c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 623:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 624:	eb ca                	jmp    5f0 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 626:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 62a:	75 03                	jne    62f <strtoul+0x154>
  p = string;
 62c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 62f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 633:	74 05                	je     63a <strtoul+0x15f>
  *endPtr = p;
 635:	8b 45 0c             	mov    0xc(%ebp),%eax
 638:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 63a:	89 f8                	mov    %edi,%eax
}
 63c:	83 c4 14             	add    $0x14,%esp
 63f:	5b                   	pop    %ebx
 640:	5e                   	pop    %esi
 641:	5f                   	pop    %edi
 642:	5d                   	pop    %ebp
 643:	c3                   	ret    

00000644 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 644:	55                   	push   %ebp
 645:	89 e5                	mov    %esp,%ebp
 647:	53                   	push   %ebx
 648:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 64e:	eb 01                	jmp    651 <strtol+0xd>
      p += 1;
 650:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 651:	8a 03                	mov    (%ebx),%al
 653:	0f b6 c0             	movzbl %al,%eax
 656:	89 04 24             	mov    %eax,(%esp)
 659:	e8 3f fe ff ff       	call   49d <isspace>
 65e:	85 c0                	test   %eax,%eax
 660:	75 ee                	jne    650 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 662:	8a 03                	mov    (%ebx),%al
 664:	3c 2d                	cmp    $0x2d,%al
 666:	75 1e                	jne    686 <strtol+0x42>
  p += 1;
 668:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 669:	8b 45 10             	mov    0x10(%ebp),%eax
 66c:	89 44 24 08          	mov    %eax,0x8(%esp)
 670:	8b 45 0c             	mov    0xc(%ebp),%eax
 673:	89 44 24 04          	mov    %eax,0x4(%esp)
 677:	89 1c 24             	mov    %ebx,(%esp)
 67a:	e8 5c fe ff ff       	call   4db <strtoul>
 67f:	f7 d8                	neg    %eax
 681:	89 45 f8             	mov    %eax,-0x8(%ebp)
 684:	eb 20                	jmp    6a6 <strtol+0x62>
    } else {
  if (*p == '+') {
 686:	8a 03                	mov    (%ebx),%al
 688:	3c 2b                	cmp    $0x2b,%al
 68a:	75 01                	jne    68d <strtol+0x49>
      p += 1;
 68c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 68d:	8b 45 10             	mov    0x10(%ebp),%eax
 690:	89 44 24 08          	mov    %eax,0x8(%esp)
 694:	8b 45 0c             	mov    0xc(%ebp),%eax
 697:	89 44 24 04          	mov    %eax,0x4(%esp)
 69b:	89 1c 24             	mov    %ebx,(%esp)
 69e:	e8 38 fe ff ff       	call   4db <strtoul>
 6a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6aa:	75 17                	jne    6c3 <strtol+0x7f>
 6ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6b0:	74 11                	je     6c3 <strtol+0x7f>
 6b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	39 d8                	cmp    %ebx,%eax
 6b9:	75 08                	jne    6c3 <strtol+0x7f>
  *endPtr = string;
 6bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6be:	8b 55 08             	mov    0x8(%ebp),%edx
 6c1:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 6c6:	83 c4 1c             	add    $0x1c,%esp
 6c9:	5b                   	pop    %ebx
 6ca:	5d                   	pop    %ebp
 6cb:	c3                   	ret    

000006cc <gets>:

char*
gets(char *buf, int max)
{
 6cc:	55                   	push   %ebp
 6cd:	89 e5                	mov    %esp,%ebp
 6cf:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6d9:	eb 49                	jmp    724 <gets+0x58>
    cc = read(0, &c, 1);
 6db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6e2:	00 
 6e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6f1:	e8 3e 01 00 00       	call   834 <read>
 6f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6fd:	7f 02                	jg     701 <gets+0x35>
      break;
 6ff:	eb 2c                	jmp    72d <gets+0x61>
    buf[i++] = c;
 701:	8b 45 f4             	mov    -0xc(%ebp),%eax
 704:	8d 50 01             	lea    0x1(%eax),%edx
 707:	89 55 f4             	mov    %edx,-0xc(%ebp)
 70a:	89 c2                	mov    %eax,%edx
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
 70f:	01 c2                	add    %eax,%edx
 711:	8a 45 ef             	mov    -0x11(%ebp),%al
 714:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 716:	8a 45 ef             	mov    -0x11(%ebp),%al
 719:	3c 0a                	cmp    $0xa,%al
 71b:	74 10                	je     72d <gets+0x61>
 71d:	8a 45 ef             	mov    -0x11(%ebp),%al
 720:	3c 0d                	cmp    $0xd,%al
 722:	74 09                	je     72d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 724:	8b 45 f4             	mov    -0xc(%ebp),%eax
 727:	40                   	inc    %eax
 728:	3b 45 0c             	cmp    0xc(%ebp),%eax
 72b:	7c ae                	jl     6db <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 72d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 730:	8b 45 08             	mov    0x8(%ebp),%eax
 733:	01 d0                	add    %edx,%eax
 735:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 738:	8b 45 08             	mov    0x8(%ebp),%eax
}
 73b:	c9                   	leave  
 73c:	c3                   	ret    

0000073d <stat>:

int
stat(char *n, struct stat *st)
{
 73d:	55                   	push   %ebp
 73e:	89 e5                	mov    %esp,%ebp
 740:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 743:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 74a:	00 
 74b:	8b 45 08             	mov    0x8(%ebp),%eax
 74e:	89 04 24             	mov    %eax,(%esp)
 751:	e8 06 01 00 00       	call   85c <open>
 756:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 759:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 75d:	79 07                	jns    766 <stat+0x29>
    return -1;
 75f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 764:	eb 23                	jmp    789 <stat+0x4c>
  r = fstat(fd, st);
 766:	8b 45 0c             	mov    0xc(%ebp),%eax
 769:	89 44 24 04          	mov    %eax,0x4(%esp)
 76d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 770:	89 04 24             	mov    %eax,(%esp)
 773:	e8 fc 00 00 00       	call   874 <fstat>
 778:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 77b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 77e:	89 04 24             	mov    %eax,(%esp)
 781:	e8 be 00 00 00       	call   844 <close>
  return r;
 786:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 789:	c9                   	leave  
 78a:	c3                   	ret    

0000078b <atoi>:

int
atoi(const char *s)
{
 78b:	55                   	push   %ebp
 78c:	89 e5                	mov    %esp,%ebp
 78e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 791:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 798:	eb 24                	jmp    7be <atoi+0x33>
    n = n*10 + *s++ - '0';
 79a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 79d:	89 d0                	mov    %edx,%eax
 79f:	c1 e0 02             	shl    $0x2,%eax
 7a2:	01 d0                	add    %edx,%eax
 7a4:	01 c0                	add    %eax,%eax
 7a6:	89 c1                	mov    %eax,%ecx
 7a8:	8b 45 08             	mov    0x8(%ebp),%eax
 7ab:	8d 50 01             	lea    0x1(%eax),%edx
 7ae:	89 55 08             	mov    %edx,0x8(%ebp)
 7b1:	8a 00                	mov    (%eax),%al
 7b3:	0f be c0             	movsbl %al,%eax
 7b6:	01 c8                	add    %ecx,%eax
 7b8:	83 e8 30             	sub    $0x30,%eax
 7bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7be:	8b 45 08             	mov    0x8(%ebp),%eax
 7c1:	8a 00                	mov    (%eax),%al
 7c3:	3c 2f                	cmp    $0x2f,%al
 7c5:	7e 09                	jle    7d0 <atoi+0x45>
 7c7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ca:	8a 00                	mov    (%eax),%al
 7cc:	3c 39                	cmp    $0x39,%al
 7ce:	7e ca                	jle    79a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7d3:	c9                   	leave  
 7d4:	c3                   	ret    

000007d5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7d5:	55                   	push   %ebp
 7d6:	89 e5                	mov    %esp,%ebp
 7d8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7db:	8b 45 08             	mov    0x8(%ebp),%eax
 7de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7e7:	eb 16                	jmp    7ff <memmove+0x2a>
    *dst++ = *src++;
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8d 50 01             	lea    0x1(%eax),%edx
 7ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7f5:	8d 4a 01             	lea    0x1(%edx),%ecx
 7f8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7fb:	8a 12                	mov    (%edx),%dl
 7fd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7ff:	8b 45 10             	mov    0x10(%ebp),%eax
 802:	8d 50 ff             	lea    -0x1(%eax),%edx
 805:	89 55 10             	mov    %edx,0x10(%ebp)
 808:	85 c0                	test   %eax,%eax
 80a:	7f dd                	jg     7e9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 80c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 80f:	c9                   	leave  
 810:	c3                   	ret    
 811:	90                   	nop
 812:	90                   	nop
 813:	90                   	nop

00000814 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 814:	b8 01 00 00 00       	mov    $0x1,%eax
 819:	cd 40                	int    $0x40
 81b:	c3                   	ret    

0000081c <exit>:
SYSCALL(exit)
 81c:	b8 02 00 00 00       	mov    $0x2,%eax
 821:	cd 40                	int    $0x40
 823:	c3                   	ret    

00000824 <wait>:
SYSCALL(wait)
 824:	b8 03 00 00 00       	mov    $0x3,%eax
 829:	cd 40                	int    $0x40
 82b:	c3                   	ret    

0000082c <pipe>:
SYSCALL(pipe)
 82c:	b8 04 00 00 00       	mov    $0x4,%eax
 831:	cd 40                	int    $0x40
 833:	c3                   	ret    

00000834 <read>:
SYSCALL(read)
 834:	b8 05 00 00 00       	mov    $0x5,%eax
 839:	cd 40                	int    $0x40
 83b:	c3                   	ret    

0000083c <write>:
SYSCALL(write)
 83c:	b8 10 00 00 00       	mov    $0x10,%eax
 841:	cd 40                	int    $0x40
 843:	c3                   	ret    

00000844 <close>:
SYSCALL(close)
 844:	b8 15 00 00 00       	mov    $0x15,%eax
 849:	cd 40                	int    $0x40
 84b:	c3                   	ret    

0000084c <kill>:
SYSCALL(kill)
 84c:	b8 06 00 00 00       	mov    $0x6,%eax
 851:	cd 40                	int    $0x40
 853:	c3                   	ret    

00000854 <exec>:
SYSCALL(exec)
 854:	b8 07 00 00 00       	mov    $0x7,%eax
 859:	cd 40                	int    $0x40
 85b:	c3                   	ret    

0000085c <open>:
SYSCALL(open)
 85c:	b8 0f 00 00 00       	mov    $0xf,%eax
 861:	cd 40                	int    $0x40
 863:	c3                   	ret    

00000864 <mknod>:
SYSCALL(mknod)
 864:	b8 11 00 00 00       	mov    $0x11,%eax
 869:	cd 40                	int    $0x40
 86b:	c3                   	ret    

0000086c <unlink>:
SYSCALL(unlink)
 86c:	b8 12 00 00 00       	mov    $0x12,%eax
 871:	cd 40                	int    $0x40
 873:	c3                   	ret    

00000874 <fstat>:
SYSCALL(fstat)
 874:	b8 08 00 00 00       	mov    $0x8,%eax
 879:	cd 40                	int    $0x40
 87b:	c3                   	ret    

0000087c <link>:
SYSCALL(link)
 87c:	b8 13 00 00 00       	mov    $0x13,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <mkdir>:
SYSCALL(mkdir)
 884:	b8 14 00 00 00       	mov    $0x14,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <chdir>:
SYSCALL(chdir)
 88c:	b8 09 00 00 00       	mov    $0x9,%eax
 891:	cd 40                	int    $0x40
 893:	c3                   	ret    

00000894 <dup>:
SYSCALL(dup)
 894:	b8 0a 00 00 00       	mov    $0xa,%eax
 899:	cd 40                	int    $0x40
 89b:	c3                   	ret    

0000089c <getpid>:
SYSCALL(getpid)
 89c:	b8 0b 00 00 00       	mov    $0xb,%eax
 8a1:	cd 40                	int    $0x40
 8a3:	c3                   	ret    

000008a4 <sbrk>:
SYSCALL(sbrk)
 8a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 8a9:	cd 40                	int    $0x40
 8ab:	c3                   	ret    

000008ac <sleep>:
SYSCALL(sleep)
 8ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 8b1:	cd 40                	int    $0x40
 8b3:	c3                   	ret    

000008b4 <uptime>:
SYSCALL(uptime)
 8b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 8b9:	cd 40                	int    $0x40
 8bb:	c3                   	ret    

000008bc <getname>:
SYSCALL(getname)
 8bc:	b8 16 00 00 00       	mov    $0x16,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <setname>:
SYSCALL(setname)
 8c4:	b8 17 00 00 00       	mov    $0x17,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <getmaxproc>:
SYSCALL(getmaxproc)
 8cc:	b8 18 00 00 00       	mov    $0x18,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <setmaxproc>:
SYSCALL(setmaxproc)
 8d4:	b8 19 00 00 00       	mov    $0x19,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <getmaxmem>:
SYSCALL(getmaxmem)
 8dc:	b8 1a 00 00 00       	mov    $0x1a,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <setmaxmem>:
SYSCALL(setmaxmem)
 8e4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <getmaxdisk>:
SYSCALL(getmaxdisk)
 8ec:	b8 1c 00 00 00       	mov    $0x1c,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <setmaxdisk>:
SYSCALL(setmaxdisk)
 8f4:	b8 1d 00 00 00       	mov    $0x1d,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <getusedmem>:
SYSCALL(getusedmem)
 8fc:	b8 1e 00 00 00       	mov    $0x1e,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <setusedmem>:
SYSCALL(setusedmem)
 904:	b8 1f 00 00 00       	mov    $0x1f,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <getuseddisk>:
SYSCALL(getuseddisk)
 90c:	b8 20 00 00 00       	mov    $0x20,%eax
 911:	cd 40                	int    $0x40
 913:	c3                   	ret    

00000914 <setuseddisk>:
SYSCALL(setuseddisk)
 914:	b8 21 00 00 00       	mov    $0x21,%eax
 919:	cd 40                	int    $0x40
 91b:	c3                   	ret    

0000091c <setvc>:
SYSCALL(setvc)
 91c:	b8 22 00 00 00       	mov    $0x22,%eax
 921:	cd 40                	int    $0x40
 923:	c3                   	ret    

00000924 <setactivefs>:
SYSCALL(setactivefs)
 924:	b8 24 00 00 00       	mov    $0x24,%eax
 929:	cd 40                	int    $0x40
 92b:	c3                   	ret    

0000092c <getactivefs>:
SYSCALL(getactivefs)
 92c:	b8 25 00 00 00       	mov    $0x25,%eax
 931:	cd 40                	int    $0x40
 933:	c3                   	ret    

00000934 <getvcfs>:
SYSCALL(getvcfs)
 934:	b8 23 00 00 00       	mov    $0x23,%eax
 939:	cd 40                	int    $0x40
 93b:	c3                   	ret    

0000093c <getcwd>:
SYSCALL(getcwd)
 93c:	b8 26 00 00 00       	mov    $0x26,%eax
 941:	cd 40                	int    $0x40
 943:	c3                   	ret    

00000944 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 944:	55                   	push   %ebp
 945:	89 e5                	mov    %esp,%ebp
 947:	83 ec 18             	sub    $0x18,%esp
 94a:	8b 45 0c             	mov    0xc(%ebp),%eax
 94d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 950:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 957:	00 
 958:	8d 45 f4             	lea    -0xc(%ebp),%eax
 95b:	89 44 24 04          	mov    %eax,0x4(%esp)
 95f:	8b 45 08             	mov    0x8(%ebp),%eax
 962:	89 04 24             	mov    %eax,(%esp)
 965:	e8 d2 fe ff ff       	call   83c <write>
}
 96a:	c9                   	leave  
 96b:	c3                   	ret    

0000096c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 96c:	55                   	push   %ebp
 96d:	89 e5                	mov    %esp,%ebp
 96f:	56                   	push   %esi
 970:	53                   	push   %ebx
 971:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 974:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 97b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 97f:	74 17                	je     998 <printint+0x2c>
 981:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 985:	79 11                	jns    998 <printint+0x2c>
    neg = 1;
 987:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 98e:	8b 45 0c             	mov    0xc(%ebp),%eax
 991:	f7 d8                	neg    %eax
 993:	89 45 ec             	mov    %eax,-0x14(%ebp)
 996:	eb 06                	jmp    99e <printint+0x32>
  } else {
    x = xx;
 998:	8b 45 0c             	mov    0xc(%ebp),%eax
 99b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 99e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9a8:	8d 41 01             	lea    0x1(%ecx),%eax
 9ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9b4:	ba 00 00 00 00       	mov    $0x0,%edx
 9b9:	f7 f3                	div    %ebx
 9bb:	89 d0                	mov    %edx,%eax
 9bd:	8a 80 0c 12 00 00    	mov    0x120c(%eax),%al
 9c3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9c7:	8b 75 10             	mov    0x10(%ebp),%esi
 9ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9cd:	ba 00 00 00 00       	mov    $0x0,%edx
 9d2:	f7 f6                	div    %esi
 9d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9db:	75 c8                	jne    9a5 <printint+0x39>
  if(neg)
 9dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9e1:	74 10                	je     9f3 <printint+0x87>
    buf[i++] = '-';
 9e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e6:	8d 50 01             	lea    0x1(%eax),%edx
 9e9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9ec:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9f1:	eb 1e                	jmp    a11 <printint+0xa5>
 9f3:	eb 1c                	jmp    a11 <printint+0xa5>
    putc(fd, buf[i]);
 9f5:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9fb:	01 d0                	add    %edx,%eax
 9fd:	8a 00                	mov    (%eax),%al
 9ff:	0f be c0             	movsbl %al,%eax
 a02:	89 44 24 04          	mov    %eax,0x4(%esp)
 a06:	8b 45 08             	mov    0x8(%ebp),%eax
 a09:	89 04 24             	mov    %eax,(%esp)
 a0c:	e8 33 ff ff ff       	call   944 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a11:	ff 4d f4             	decl   -0xc(%ebp)
 a14:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a18:	79 db                	jns    9f5 <printint+0x89>
    putc(fd, buf[i]);
}
 a1a:	83 c4 30             	add    $0x30,%esp
 a1d:	5b                   	pop    %ebx
 a1e:	5e                   	pop    %esi
 a1f:	5d                   	pop    %ebp
 a20:	c3                   	ret    

00000a21 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a21:	55                   	push   %ebp
 a22:	89 e5                	mov    %esp,%ebp
 a24:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a27:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a2e:	8d 45 0c             	lea    0xc(%ebp),%eax
 a31:	83 c0 04             	add    $0x4,%eax
 a34:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a37:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a3e:	e9 77 01 00 00       	jmp    bba <printf+0x199>
    c = fmt[i] & 0xff;
 a43:	8b 55 0c             	mov    0xc(%ebp),%edx
 a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a49:	01 d0                	add    %edx,%eax
 a4b:	8a 00                	mov    (%eax),%al
 a4d:	0f be c0             	movsbl %al,%eax
 a50:	25 ff 00 00 00       	and    $0xff,%eax
 a55:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a58:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a5c:	75 2c                	jne    a8a <printf+0x69>
      if(c == '%'){
 a5e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a62:	75 0c                	jne    a70 <printf+0x4f>
        state = '%';
 a64:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a6b:	e9 47 01 00 00       	jmp    bb7 <printf+0x196>
      } else {
        putc(fd, c);
 a70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a73:	0f be c0             	movsbl %al,%eax
 a76:	89 44 24 04          	mov    %eax,0x4(%esp)
 a7a:	8b 45 08             	mov    0x8(%ebp),%eax
 a7d:	89 04 24             	mov    %eax,(%esp)
 a80:	e8 bf fe ff ff       	call   944 <putc>
 a85:	e9 2d 01 00 00       	jmp    bb7 <printf+0x196>
      }
    } else if(state == '%'){
 a8a:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a8e:	0f 85 23 01 00 00    	jne    bb7 <printf+0x196>
      if(c == 'd'){
 a94:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a98:	75 2d                	jne    ac7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a9d:	8b 00                	mov    (%eax),%eax
 a9f:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 aa6:	00 
 aa7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 aae:	00 
 aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
 ab3:	8b 45 08             	mov    0x8(%ebp),%eax
 ab6:	89 04 24             	mov    %eax,(%esp)
 ab9:	e8 ae fe ff ff       	call   96c <printint>
        ap++;
 abe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ac2:	e9 e9 00 00 00       	jmp    bb0 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 ac7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 acb:	74 06                	je     ad3 <printf+0xb2>
 acd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 ad1:	75 2d                	jne    b00 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 ad3:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ad6:	8b 00                	mov    (%eax),%eax
 ad8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 adf:	00 
 ae0:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 ae7:	00 
 ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
 aec:	8b 45 08             	mov    0x8(%ebp),%eax
 aef:	89 04 24             	mov    %eax,(%esp)
 af2:	e8 75 fe ff ff       	call   96c <printint>
        ap++;
 af7:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 afb:	e9 b0 00 00 00       	jmp    bb0 <printf+0x18f>
      } else if(c == 's'){
 b00:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b04:	75 42                	jne    b48 <printf+0x127>
        s = (char*)*ap;
 b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b09:	8b 00                	mov    (%eax),%eax
 b0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b0e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b16:	75 09                	jne    b21 <printf+0x100>
          s = "(null)";
 b18:	c7 45 f4 27 0e 00 00 	movl   $0xe27,-0xc(%ebp)
        while(*s != 0){
 b1f:	eb 1c                	jmp    b3d <printf+0x11c>
 b21:	eb 1a                	jmp    b3d <printf+0x11c>
          putc(fd, *s);
 b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b26:	8a 00                	mov    (%eax),%al
 b28:	0f be c0             	movsbl %al,%eax
 b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b2f:	8b 45 08             	mov    0x8(%ebp),%eax
 b32:	89 04 24             	mov    %eax,(%esp)
 b35:	e8 0a fe ff ff       	call   944 <putc>
          s++;
 b3a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b40:	8a 00                	mov    (%eax),%al
 b42:	84 c0                	test   %al,%al
 b44:	75 dd                	jne    b23 <printf+0x102>
 b46:	eb 68                	jmp    bb0 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b48:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b4c:	75 1d                	jne    b6b <printf+0x14a>
        putc(fd, *ap);
 b4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b51:	8b 00                	mov    (%eax),%eax
 b53:	0f be c0             	movsbl %al,%eax
 b56:	89 44 24 04          	mov    %eax,0x4(%esp)
 b5a:	8b 45 08             	mov    0x8(%ebp),%eax
 b5d:	89 04 24             	mov    %eax,(%esp)
 b60:	e8 df fd ff ff       	call   944 <putc>
        ap++;
 b65:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b69:	eb 45                	jmp    bb0 <printf+0x18f>
      } else if(c == '%'){
 b6b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b6f:	75 17                	jne    b88 <printf+0x167>
        putc(fd, c);
 b71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b74:	0f be c0             	movsbl %al,%eax
 b77:	89 44 24 04          	mov    %eax,0x4(%esp)
 b7b:	8b 45 08             	mov    0x8(%ebp),%eax
 b7e:	89 04 24             	mov    %eax,(%esp)
 b81:	e8 be fd ff ff       	call   944 <putc>
 b86:	eb 28                	jmp    bb0 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b88:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b8f:	00 
 b90:	8b 45 08             	mov    0x8(%ebp),%eax
 b93:	89 04 24             	mov    %eax,(%esp)
 b96:	e8 a9 fd ff ff       	call   944 <putc>
        putc(fd, c);
 b9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b9e:	0f be c0             	movsbl %al,%eax
 ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
 ba5:	8b 45 08             	mov    0x8(%ebp),%eax
 ba8:	89 04 24             	mov    %eax,(%esp)
 bab:	e8 94 fd ff ff       	call   944 <putc>
      }
      state = 0;
 bb0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bb7:	ff 45 f0             	incl   -0x10(%ebp)
 bba:	8b 55 0c             	mov    0xc(%ebp),%edx
 bbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc0:	01 d0                	add    %edx,%eax
 bc2:	8a 00                	mov    (%eax),%al
 bc4:	84 c0                	test   %al,%al
 bc6:	0f 85 77 fe ff ff    	jne    a43 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bcc:	c9                   	leave  
 bcd:	c3                   	ret    
 bce:	90                   	nop
 bcf:	90                   	nop

00000bd0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bd0:	55                   	push   %ebp
 bd1:	89 e5                	mov    %esp,%ebp
 bd3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bd6:	8b 45 08             	mov    0x8(%ebp),%eax
 bd9:	83 e8 08             	sub    $0x8,%eax
 bdc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bdf:	a1 30 12 00 00       	mov    0x1230,%eax
 be4:	89 45 fc             	mov    %eax,-0x4(%ebp)
 be7:	eb 24                	jmp    c0d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bec:	8b 00                	mov    (%eax),%eax
 bee:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bf1:	77 12                	ja     c05 <free+0x35>
 bf3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bf9:	77 24                	ja     c1f <free+0x4f>
 bfb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bfe:	8b 00                	mov    (%eax),%eax
 c00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c03:	77 1a                	ja     c1f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c08:	8b 00                	mov    (%eax),%eax
 c0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c10:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c13:	76 d4                	jbe    be9 <free+0x19>
 c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c18:	8b 00                	mov    (%eax),%eax
 c1a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c1d:	76 ca                	jbe    be9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c22:	8b 40 04             	mov    0x4(%eax),%eax
 c25:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c2f:	01 c2                	add    %eax,%edx
 c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c34:	8b 00                	mov    (%eax),%eax
 c36:	39 c2                	cmp    %eax,%edx
 c38:	75 24                	jne    c5e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c3d:	8b 50 04             	mov    0x4(%eax),%edx
 c40:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c43:	8b 00                	mov    (%eax),%eax
 c45:	8b 40 04             	mov    0x4(%eax),%eax
 c48:	01 c2                	add    %eax,%edx
 c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c53:	8b 00                	mov    (%eax),%eax
 c55:	8b 10                	mov    (%eax),%edx
 c57:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c5a:	89 10                	mov    %edx,(%eax)
 c5c:	eb 0a                	jmp    c68 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c61:	8b 10                	mov    (%eax),%edx
 c63:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c66:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c68:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6b:	8b 40 04             	mov    0x4(%eax),%eax
 c6e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c78:	01 d0                	add    %edx,%eax
 c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c7d:	75 20                	jne    c9f <free+0xcf>
    p->s.size += bp->s.size;
 c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c82:	8b 50 04             	mov    0x4(%eax),%edx
 c85:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c88:	8b 40 04             	mov    0x4(%eax),%eax
 c8b:	01 c2                	add    %eax,%edx
 c8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c90:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c93:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c96:	8b 10                	mov    (%eax),%edx
 c98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c9b:	89 10                	mov    %edx,(%eax)
 c9d:	eb 08                	jmp    ca7 <free+0xd7>
  } else
    p->s.ptr = bp;
 c9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ca5:	89 10                	mov    %edx,(%eax)
  freep = p;
 ca7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 caa:	a3 30 12 00 00       	mov    %eax,0x1230
}
 caf:	c9                   	leave  
 cb0:	c3                   	ret    

00000cb1 <morecore>:

static Header*
morecore(uint nu)
{
 cb1:	55                   	push   %ebp
 cb2:	89 e5                	mov    %esp,%ebp
 cb4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 cb7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cbe:	77 07                	ja     cc7 <morecore+0x16>
    nu = 4096;
 cc0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 cc7:	8b 45 08             	mov    0x8(%ebp),%eax
 cca:	c1 e0 03             	shl    $0x3,%eax
 ccd:	89 04 24             	mov    %eax,(%esp)
 cd0:	e8 cf fb ff ff       	call   8a4 <sbrk>
 cd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cd8:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cdc:	75 07                	jne    ce5 <morecore+0x34>
    return 0;
 cde:	b8 00 00 00 00       	mov    $0x0,%eax
 ce3:	eb 22                	jmp    d07 <morecore+0x56>
  hp = (Header*)p;
 ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ceb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cee:	8b 55 08             	mov    0x8(%ebp),%edx
 cf1:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf7:	83 c0 08             	add    $0x8,%eax
 cfa:	89 04 24             	mov    %eax,(%esp)
 cfd:	e8 ce fe ff ff       	call   bd0 <free>
  return freep;
 d02:	a1 30 12 00 00       	mov    0x1230,%eax
}
 d07:	c9                   	leave  
 d08:	c3                   	ret    

00000d09 <malloc>:

void*
malloc(uint nbytes)
{
 d09:	55                   	push   %ebp
 d0a:	89 e5                	mov    %esp,%ebp
 d0c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d0f:	8b 45 08             	mov    0x8(%ebp),%eax
 d12:	83 c0 07             	add    $0x7,%eax
 d15:	c1 e8 03             	shr    $0x3,%eax
 d18:	40                   	inc    %eax
 d19:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d1c:	a1 30 12 00 00       	mov    0x1230,%eax
 d21:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d24:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d28:	75 23                	jne    d4d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d2a:	c7 45 f0 28 12 00 00 	movl   $0x1228,-0x10(%ebp)
 d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d34:	a3 30 12 00 00       	mov    %eax,0x1230
 d39:	a1 30 12 00 00       	mov    0x1230,%eax
 d3e:	a3 28 12 00 00       	mov    %eax,0x1228
    base.s.size = 0;
 d43:	c7 05 2c 12 00 00 00 	movl   $0x0,0x122c
 d4a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d50:	8b 00                	mov    (%eax),%eax
 d52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d58:	8b 40 04             	mov    0x4(%eax),%eax
 d5b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d5e:	72 4d                	jb     dad <malloc+0xa4>
      if(p->s.size == nunits)
 d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d63:	8b 40 04             	mov    0x4(%eax),%eax
 d66:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d69:	75 0c                	jne    d77 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6e:	8b 10                	mov    (%eax),%edx
 d70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d73:	89 10                	mov    %edx,(%eax)
 d75:	eb 26                	jmp    d9d <malloc+0x94>
      else {
        p->s.size -= nunits;
 d77:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7a:	8b 40 04             	mov    0x4(%eax),%eax
 d7d:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d80:	89 c2                	mov    %eax,%edx
 d82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d85:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d8b:	8b 40 04             	mov    0x4(%eax),%eax
 d8e:	c1 e0 03             	shl    $0x3,%eax
 d91:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d97:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d9a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da0:	a3 30 12 00 00       	mov    %eax,0x1230
      return (void*)(p + 1);
 da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da8:	83 c0 08             	add    $0x8,%eax
 dab:	eb 38                	jmp    de5 <malloc+0xdc>
    }
    if(p == freep)
 dad:	a1 30 12 00 00       	mov    0x1230,%eax
 db2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 db5:	75 1b                	jne    dd2 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 db7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 dba:	89 04 24             	mov    %eax,(%esp)
 dbd:	e8 ef fe ff ff       	call   cb1 <morecore>
 dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 dc9:	75 07                	jne    dd2 <malloc+0xc9>
        return 0;
 dcb:	b8 00 00 00 00       	mov    $0x0,%eax
 dd0:	eb 13                	jmp    de5 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ddb:	8b 00                	mov    (%eax),%eax
 ddd:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 de0:	e9 70 ff ff ff       	jmp    d55 <malloc+0x4c>
}
 de5:	c9                   	leave  
 de6:	c3                   	ret    
