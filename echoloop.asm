
_echoloop:     file format elf32-i386


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
  int ticks;

  if (argc < 3) {
   9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
  	printf(1, "usage: echoloop ticks arg1 [arg2 ...]\n");
   f:	c7 44 24 04 54 0e 00 	movl   $0xe54,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 6a 0a 00 00       	call   a8d <printf>
  	exit();
  23:	e8 30 08 00 00       	call   858 <exit>
  }

  ticks = atoi(argv[1]);
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 04             	add    $0x4,%eax
  2e:	8b 00                	mov    (%eax),%eax
  30:	89 04 24             	mov    %eax,(%esp)
  33:	e8 8f 07 00 00       	call   7c7 <atoi>
  38:	89 44 24 18          	mov    %eax,0x18(%esp)

  while(1){
	  for(i = 2; i < argc; i++)
  3c:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
  43:	00 
  44:	eb 48                	jmp    8e <main+0x8e>
    	printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  46:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  4a:	40                   	inc    %eax
  4b:	3b 45 08             	cmp    0x8(%ebp),%eax
  4e:	7d 07                	jge    57 <main+0x57>
  50:	b8 7b 0e 00 00       	mov    $0xe7b,%eax
  55:	eb 05                	jmp    5c <main+0x5c>
  57:	b8 7d 0e 00 00       	mov    $0xe7d,%eax
  5c:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  60:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	01 ca                	add    %ecx,%edx
  6c:	8b 12                	mov    (%edx),%edx
  6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  72:	89 54 24 08          	mov    %edx,0x8(%esp)
  76:	c7 44 24 04 7f 0e 00 	movl   $0xe7f,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 03 0a 00 00       	call   a8d <printf>
  }

  ticks = atoi(argv[1]);

  while(1){
	  for(i = 2; i < argc; i++)
  8a:	ff 44 24 1c          	incl   0x1c(%esp)
  8e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  92:	3b 45 08             	cmp    0x8(%ebp),%eax
  95:	7c af                	jl     46 <main+0x46>
    	printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
    sleep(ticks);
  97:	8b 44 24 18          	mov    0x18(%esp),%eax
  9b:	89 04 24             	mov    %eax,(%esp)
  9e:	e8 45 08 00 00       	call   8e8 <sleep>
  }
  a3:	eb 97                	jmp    3c <main+0x3c>
  a5:	90                   	nop
  a6:	90                   	nop
  a7:	90                   	nop

000000a8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  a8:	55                   	push   %ebp
  a9:	89 e5                	mov    %esp,%ebp
  ab:	57                   	push   %edi
  ac:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  ad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  b0:	8b 55 10             	mov    0x10(%ebp),%edx
  b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  b6:	89 cb                	mov    %ecx,%ebx
  b8:	89 df                	mov    %ebx,%edi
  ba:	89 d1                	mov    %edx,%ecx
  bc:	fc                   	cld    
  bd:	f3 aa                	rep stos %al,%es:(%edi)
  bf:	89 ca                	mov    %ecx,%edx
  c1:	89 fb                	mov    %edi,%ebx
  c3:	89 5d 08             	mov    %ebx,0x8(%ebp)
  c6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  c9:	5b                   	pop    %ebx
  ca:	5f                   	pop    %edi
  cb:	5d                   	pop    %ebp
  cc:	c3                   	ret    

000000cd <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  cd:	55                   	push   %ebp
  ce:	89 e5                	mov    %esp,%ebp
  d0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  d9:	90                   	nop
  da:	8b 45 08             	mov    0x8(%ebp),%eax
  dd:	8d 50 01             	lea    0x1(%eax),%edx
  e0:	89 55 08             	mov    %edx,0x8(%ebp)
  e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  e6:	8d 4a 01             	lea    0x1(%edx),%ecx
  e9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ec:	8a 12                	mov    (%edx),%dl
  ee:	88 10                	mov    %dl,(%eax)
  f0:	8a 00                	mov    (%eax),%al
  f2:	84 c0                	test   %al,%al
  f4:	75 e4                	jne    da <strcpy+0xd>
    ;
  return os;
  f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  f9:	c9                   	leave  
  fa:	c3                   	ret    

000000fb <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  fe:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
 101:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
 108:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 10f:	00 
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	89 04 24             	mov    %eax,(%esp)
 116:	e8 7d 07 00 00       	call   898 <open>
 11b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 11e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 122:	79 20                	jns    144 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	89 44 24 08          	mov    %eax,0x8(%esp)
 12b:	c7 44 24 04 84 0e 00 	movl   $0xe84,0x4(%esp)
 132:	00 
 133:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 13a:	e8 4e 09 00 00       	call   a8d <printf>
      exit();
 13f:	e8 14 07 00 00       	call   858 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 144:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 14b:	00 
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	89 04 24             	mov    %eax,(%esp)
 152:	e8 41 07 00 00       	call   898 <open>
 157:	89 45 ec             	mov    %eax,-0x14(%ebp)
 15a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 15e:	79 20                	jns    180 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 160:	8b 45 0c             	mov    0xc(%ebp),%eax
 163:	89 44 24 08          	mov    %eax,0x8(%esp)
 167:	c7 44 24 04 9f 0e 00 	movl   $0xe9f,0x4(%esp)
 16e:	00 
 16f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 176:	e8 12 09 00 00       	call   a8d <printf>
      exit();
 17b:	e8 d8 06 00 00       	call   858 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 180:	eb 3b                	jmp    1bd <copy+0xc2>
  {
      max = used_disk+=count;
 182:	8b 45 e8             	mov    -0x18(%ebp),%eax
 185:	01 45 10             	add    %eax,0x10(%ebp)
 188:	8b 45 10             	mov    0x10(%ebp),%eax
 18b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 18e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 191:	3b 45 14             	cmp    0x14(%ebp),%eax
 194:	7e 07                	jle    19d <copy+0xa2>
      {
        return -1;
 196:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 19b:	eb 5c                	jmp    1f9 <copy+0xfe>
      }
      bytes = bytes + count;
 19d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 1a0:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 1a3:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 1aa:	00 
 1ab:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1b5:	89 04 24             	mov    %eax,(%esp)
 1b8:	e8 bb 06 00 00       	call   878 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 1bd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 1c4:	00 
 1c5:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 1c8:	89 44 24 04          	mov    %eax,0x4(%esp)
 1cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1cf:	89 04 24             	mov    %eax,(%esp)
 1d2:	e8 99 06 00 00       	call   870 <read>
 1d7:	89 45 e8             	mov    %eax,-0x18(%ebp)
 1da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1de:	7f a2                	jg     182 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 1e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1e3:	89 04 24             	mov    %eax,(%esp)
 1e6:	e8 95 06 00 00       	call   880 <close>
  close(fd2);
 1eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1ee:	89 04 24             	mov    %eax,(%esp)
 1f1:	e8 8a 06 00 00       	call   880 <close>
  return(bytes);
 1f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1fe:	eb 06                	jmp    206 <strcmp+0xb>
    p++, q++;
 200:	ff 45 08             	incl   0x8(%ebp)
 203:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	8a 00                	mov    (%eax),%al
 20b:	84 c0                	test   %al,%al
 20d:	74 0e                	je     21d <strcmp+0x22>
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	8a 10                	mov    (%eax),%dl
 214:	8b 45 0c             	mov    0xc(%ebp),%eax
 217:	8a 00                	mov    (%eax),%al
 219:	38 c2                	cmp    %al,%dl
 21b:	74 e3                	je     200 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	8a 00                	mov    (%eax),%al
 222:	0f b6 d0             	movzbl %al,%edx
 225:	8b 45 0c             	mov    0xc(%ebp),%eax
 228:	8a 00                	mov    (%eax),%al
 22a:	0f b6 c0             	movzbl %al,%eax
 22d:	29 c2                	sub    %eax,%edx
 22f:	89 d0                	mov    %edx,%eax
}
 231:	5d                   	pop    %ebp
 232:	c3                   	ret    

00000233 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 236:	eb 09                	jmp    241 <strncmp+0xe>
    n--, p++, q++;
 238:	ff 4d 10             	decl   0x10(%ebp)
 23b:	ff 45 08             	incl   0x8(%ebp)
 23e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 241:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 245:	74 17                	je     25e <strncmp+0x2b>
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	8a 00                	mov    (%eax),%al
 24c:	84 c0                	test   %al,%al
 24e:	74 0e                	je     25e <strncmp+0x2b>
 250:	8b 45 08             	mov    0x8(%ebp),%eax
 253:	8a 10                	mov    (%eax),%dl
 255:	8b 45 0c             	mov    0xc(%ebp),%eax
 258:	8a 00                	mov    (%eax),%al
 25a:	38 c2                	cmp    %al,%dl
 25c:	74 da                	je     238 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 25e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 262:	75 07                	jne    26b <strncmp+0x38>
    return 0;
 264:	b8 00 00 00 00       	mov    $0x0,%eax
 269:	eb 14                	jmp    27f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 26b:	8b 45 08             	mov    0x8(%ebp),%eax
 26e:	8a 00                	mov    (%eax),%al
 270:	0f b6 d0             	movzbl %al,%edx
 273:	8b 45 0c             	mov    0xc(%ebp),%eax
 276:	8a 00                	mov    (%eax),%al
 278:	0f b6 c0             	movzbl %al,%eax
 27b:	29 c2                	sub    %eax,%edx
 27d:	89 d0                	mov    %edx,%eax
}
 27f:	5d                   	pop    %ebp
 280:	c3                   	ret    

00000281 <strlen>:

uint
strlen(const char *s)
{
 281:	55                   	push   %ebp
 282:	89 e5                	mov    %esp,%ebp
 284:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 287:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 28e:	eb 03                	jmp    293 <strlen+0x12>
 290:	ff 45 fc             	incl   -0x4(%ebp)
 293:	8b 55 fc             	mov    -0x4(%ebp),%edx
 296:	8b 45 08             	mov    0x8(%ebp),%eax
 299:	01 d0                	add    %edx,%eax
 29b:	8a 00                	mov    (%eax),%al
 29d:	84 c0                	test   %al,%al
 29f:	75 ef                	jne    290 <strlen+0xf>
    ;
  return n;
 2a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2a4:	c9                   	leave  
 2a5:	c3                   	ret    

000002a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a6:	55                   	push   %ebp
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2ac:	8b 45 10             	mov    0x10(%ebp),%eax
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 2ba:	8b 45 08             	mov    0x8(%ebp),%eax
 2bd:	89 04 24             	mov    %eax,(%esp)
 2c0:	e8 e3 fd ff ff       	call   a8 <stosb>
  return dst;
 2c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <strchr>:

char*
strchr(const char *s, char c)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	83 ec 04             	sub    $0x4,%esp
 2d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2d6:	eb 12                	jmp    2ea <strchr+0x20>
    if(*s == c)
 2d8:	8b 45 08             	mov    0x8(%ebp),%eax
 2db:	8a 00                	mov    (%eax),%al
 2dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2e0:	75 05                	jne    2e7 <strchr+0x1d>
      return (char*)s;
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	eb 11                	jmp    2f8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2e7:	ff 45 08             	incl   0x8(%ebp)
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	8a 00                	mov    (%eax),%al
 2ef:	84 c0                	test   %al,%al
 2f1:	75 e5                	jne    2d8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f8:	c9                   	leave  
 2f9:	c3                   	ret    

000002fa <strcat>:

char *
strcat(char *dest, const char *src)
{
 2fa:	55                   	push   %ebp
 2fb:	89 e5                	mov    %esp,%ebp
 2fd:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 307:	eb 03                	jmp    30c <strcat+0x12>
 309:	ff 45 fc             	incl   -0x4(%ebp)
 30c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 30f:	8b 45 08             	mov    0x8(%ebp),%eax
 312:	01 d0                	add    %edx,%eax
 314:	8a 00                	mov    (%eax),%al
 316:	84 c0                	test   %al,%al
 318:	75 ef                	jne    309 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 31a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 321:	eb 1e                	jmp    341 <strcat+0x47>
        dest[i+j] = src[j];
 323:	8b 45 f8             	mov    -0x8(%ebp),%eax
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	01 d0                	add    %edx,%eax
 32b:	89 c2                	mov    %eax,%edx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	01 c2                	add    %eax,%edx
 332:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 335:	8b 45 0c             	mov    0xc(%ebp),%eax
 338:	01 c8                	add    %ecx,%eax
 33a:	8a 00                	mov    (%eax),%al
 33c:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 33e:	ff 45 f8             	incl   -0x8(%ebp)
 341:	8b 55 f8             	mov    -0x8(%ebp),%edx
 344:	8b 45 0c             	mov    0xc(%ebp),%eax
 347:	01 d0                	add    %edx,%eax
 349:	8a 00                	mov    (%eax),%al
 34b:	84 c0                	test   %al,%al
 34d:	75 d4                	jne    323 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 34f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 352:	8b 55 fc             	mov    -0x4(%ebp),%edx
 355:	01 d0                	add    %edx,%eax
 357:	89 c2                	mov    %eax,%edx
 359:	8b 45 08             	mov    0x8(%ebp),%eax
 35c:	01 d0                	add    %edx,%eax
 35e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 361:	8b 45 08             	mov    0x8(%ebp),%eax
}
 364:	c9                   	leave  
 365:	c3                   	ret    

00000366 <strstr>:

int 
strstr(char* s, char* sub)
{
 366:	55                   	push   %ebp
 367:	89 e5                	mov    %esp,%ebp
 369:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 36c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 373:	eb 7c                	jmp    3f1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 375:	8b 55 fc             	mov    -0x4(%ebp),%edx
 378:	8b 45 08             	mov    0x8(%ebp),%eax
 37b:	01 d0                	add    %edx,%eax
 37d:	8a 10                	mov    (%eax),%dl
 37f:	8b 45 0c             	mov    0xc(%ebp),%eax
 382:	8a 00                	mov    (%eax),%al
 384:	38 c2                	cmp    %al,%dl
 386:	75 66                	jne    3ee <strstr+0x88>
        {
            if(strlen(sub) == 1)
 388:	8b 45 0c             	mov    0xc(%ebp),%eax
 38b:	89 04 24             	mov    %eax,(%esp)
 38e:	e8 ee fe ff ff       	call   281 <strlen>
 393:	83 f8 01             	cmp    $0x1,%eax
 396:	75 05                	jne    39d <strstr+0x37>
            {  
                return i;
 398:	8b 45 fc             	mov    -0x4(%ebp),%eax
 39b:	eb 6b                	jmp    408 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 39d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 3a4:	eb 3a                	jmp    3e0 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 3a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ac:	01 d0                	add    %edx,%eax
 3ae:	89 c2                	mov    %eax,%edx
 3b0:	8b 45 08             	mov    0x8(%ebp),%eax
 3b3:	01 d0                	add    %edx,%eax
 3b5:	8a 10                	mov    (%eax),%dl
 3b7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 3bd:	01 c8                	add    %ecx,%eax
 3bf:	8a 00                	mov    (%eax),%al
 3c1:	38 c2                	cmp    %al,%dl
 3c3:	75 16                	jne    3db <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 3c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3c8:	8d 50 01             	lea    0x1(%eax),%edx
 3cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ce:	01 d0                	add    %edx,%eax
 3d0:	8a 00                	mov    (%eax),%al
 3d2:	84 c0                	test   %al,%al
 3d4:	75 07                	jne    3dd <strstr+0x77>
                    {
                        return i;
 3d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3d9:	eb 2d                	jmp    408 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3db:	eb 11                	jmp    3ee <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3dd:	ff 45 f8             	incl   -0x8(%ebp)
 3e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e6:	01 d0                	add    %edx,%eax
 3e8:	8a 00                	mov    (%eax),%al
 3ea:	84 c0                	test   %al,%al
 3ec:	75 b8                	jne    3a6 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3ee:	ff 45 fc             	incl   -0x4(%ebp)
 3f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3f4:	8b 45 08             	mov    0x8(%ebp),%eax
 3f7:	01 d0                	add    %edx,%eax
 3f9:	8a 00                	mov    (%eax),%al
 3fb:	84 c0                	test   %al,%al
 3fd:	0f 85 72 ff ff ff    	jne    375 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 403:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 408:	c9                   	leave  
 409:	c3                   	ret    

0000040a <strtok>:

char *
strtok(char *s, const char *delim)
{
 40a:	55                   	push   %ebp
 40b:	89 e5                	mov    %esp,%ebp
 40d:	53                   	push   %ebx
 40e:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 411:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 415:	75 08                	jne    41f <strtok+0x15>
  s = lasts;
 417:	a1 a4 12 00 00       	mov    0x12a4,%eax
 41c:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	8d 50 01             	lea    0x1(%eax),%edx
 425:	89 55 08             	mov    %edx,0x8(%ebp)
 428:	8a 00                	mov    (%eax),%al
 42a:	0f be d8             	movsbl %al,%ebx
 42d:	85 db                	test   %ebx,%ebx
 42f:	75 07                	jne    438 <strtok+0x2e>
      return 0;
 431:	b8 00 00 00 00       	mov    $0x0,%eax
 436:	eb 58                	jmp    490 <strtok+0x86>
    } while (strchr(delim, ch));
 438:	88 d8                	mov    %bl,%al
 43a:	0f be c0             	movsbl %al,%eax
 43d:	89 44 24 04          	mov    %eax,0x4(%esp)
 441:	8b 45 0c             	mov    0xc(%ebp),%eax
 444:	89 04 24             	mov    %eax,(%esp)
 447:	e8 7e fe ff ff       	call   2ca <strchr>
 44c:	85 c0                	test   %eax,%eax
 44e:	75 cf                	jne    41f <strtok+0x15>
    --s;
 450:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 453:	8b 45 0c             	mov    0xc(%ebp),%eax
 456:	89 44 24 04          	mov    %eax,0x4(%esp)
 45a:	8b 45 08             	mov    0x8(%ebp),%eax
 45d:	89 04 24             	mov    %eax,(%esp)
 460:	e8 31 00 00 00       	call   496 <strcspn>
 465:	89 c2                	mov    %eax,%edx
 467:	8b 45 08             	mov    0x8(%ebp),%eax
 46a:	01 d0                	add    %edx,%eax
 46c:	a3 a4 12 00 00       	mov    %eax,0x12a4
    if (*lasts != 0)
 471:	a1 a4 12 00 00       	mov    0x12a4,%eax
 476:	8a 00                	mov    (%eax),%al
 478:	84 c0                	test   %al,%al
 47a:	74 11                	je     48d <strtok+0x83>
  *lasts++ = 0;
 47c:	a1 a4 12 00 00       	mov    0x12a4,%eax
 481:	8d 50 01             	lea    0x1(%eax),%edx
 484:	89 15 a4 12 00 00    	mov    %edx,0x12a4
 48a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 48d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 490:	83 c4 14             	add    $0x14,%esp
 493:	5b                   	pop    %ebx
 494:	5d                   	pop    %ebp
 495:	c3                   	ret    

00000496 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 496:	55                   	push   %ebp
 497:	89 e5                	mov    %esp,%ebp
 499:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 49c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 4a3:	eb 26                	jmp    4cb <strcspn+0x35>
        if(strchr(s2,*s1))
 4a5:	8b 45 08             	mov    0x8(%ebp),%eax
 4a8:	8a 00                	mov    (%eax),%al
 4aa:	0f be c0             	movsbl %al,%eax
 4ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b4:	89 04 24             	mov    %eax,(%esp)
 4b7:	e8 0e fe ff ff       	call   2ca <strchr>
 4bc:	85 c0                	test   %eax,%eax
 4be:	74 05                	je     4c5 <strcspn+0x2f>
            return ret;
 4c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4c3:	eb 12                	jmp    4d7 <strcspn+0x41>
        else
            s1++,ret++;
 4c5:	ff 45 08             	incl   0x8(%ebp)
 4c8:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4cb:	8b 45 08             	mov    0x8(%ebp),%eax
 4ce:	8a 00                	mov    (%eax),%al
 4d0:	84 c0                	test   %al,%al
 4d2:	75 d1                	jne    4a5 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4d7:	c9                   	leave  
 4d8:	c3                   	ret    

000004d9 <isspace>:

int
isspace(unsigned char c)
{
 4d9:	55                   	push   %ebp
 4da:	89 e5                	mov    %esp,%ebp
 4dc:	83 ec 04             	sub    $0x4,%esp
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4e5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4e9:	74 1e                	je     509 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4eb:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4ef:	74 18                	je     509 <isspace+0x30>
 4f1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4f5:	74 12                	je     509 <isspace+0x30>
 4f7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4fb:	74 0c                	je     509 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4fd:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 501:	74 06                	je     509 <isspace+0x30>
 503:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 507:	75 07                	jne    510 <isspace+0x37>
 509:	b8 01 00 00 00       	mov    $0x1,%eax
 50e:	eb 05                	jmp    515 <isspace+0x3c>
 510:	b8 00 00 00 00       	mov    $0x0,%eax
}
 515:	c9                   	leave  
 516:	c3                   	ret    

00000517 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 517:	55                   	push   %ebp
 518:	89 e5                	mov    %esp,%ebp
 51a:	57                   	push   %edi
 51b:	56                   	push   %esi
 51c:	53                   	push   %ebx
 51d:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 520:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 525:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 52c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 52f:	eb 01                	jmp    532 <strtoul+0x1b>
  p += 1;
 531:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 532:	8a 03                	mov    (%ebx),%al
 534:	0f b6 c0             	movzbl %al,%eax
 537:	89 04 24             	mov    %eax,(%esp)
 53a:	e8 9a ff ff ff       	call   4d9 <isspace>
 53f:	85 c0                	test   %eax,%eax
 541:	75 ee                	jne    531 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 543:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 547:	75 30                	jne    579 <strtoul+0x62>
    {
  if (*p == '0') {
 549:	8a 03                	mov    (%ebx),%al
 54b:	3c 30                	cmp    $0x30,%al
 54d:	75 21                	jne    570 <strtoul+0x59>
      p += 1;
 54f:	43                   	inc    %ebx
      if (*p == 'x') {
 550:	8a 03                	mov    (%ebx),%al
 552:	3c 78                	cmp    $0x78,%al
 554:	75 0a                	jne    560 <strtoul+0x49>
    p += 1;
 556:	43                   	inc    %ebx
    base = 16;
 557:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 55e:	eb 31                	jmp    591 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 560:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 567:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 56e:	eb 21                	jmp    591 <strtoul+0x7a>
      }
  }
  else base = 10;
 570:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 577:	eb 18                	jmp    591 <strtoul+0x7a>
    } else if (base == 16) {
 579:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 57d:	75 12                	jne    591 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 57f:	8a 03                	mov    (%ebx),%al
 581:	3c 30                	cmp    $0x30,%al
 583:	75 0c                	jne    591 <strtoul+0x7a>
 585:	8d 43 01             	lea    0x1(%ebx),%eax
 588:	8a 00                	mov    (%eax),%al
 58a:	3c 78                	cmp    $0x78,%al
 58c:	75 03                	jne    591 <strtoul+0x7a>
      p += 2;
 58e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 591:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 595:	75 29                	jne    5c0 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 597:	8a 03                	mov    (%ebx),%al
 599:	0f be c0             	movsbl %al,%eax
 59c:	83 e8 30             	sub    $0x30,%eax
 59f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 5a1:	83 fe 07             	cmp    $0x7,%esi
 5a4:	76 06                	jbe    5ac <strtoul+0x95>
    break;
 5a6:	90                   	nop
 5a7:	e9 b6 00 00 00       	jmp    662 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 5ac:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 5b3:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 5bd:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 5be:	eb d7                	jmp    597 <strtoul+0x80>
    } else if (base == 10) {
 5c0:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 5c4:	75 2b                	jne    5f1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5c6:	8a 03                	mov    (%ebx),%al
 5c8:	0f be c0             	movsbl %al,%eax
 5cb:	83 e8 30             	sub    $0x30,%eax
 5ce:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5d0:	83 fe 09             	cmp    $0x9,%esi
 5d3:	76 06                	jbe    5db <strtoul+0xc4>
    break;
 5d5:	90                   	nop
 5d6:	e9 87 00 00 00       	jmp    662 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5db:	89 f8                	mov    %edi,%eax
 5dd:	c1 e0 02             	shl    $0x2,%eax
 5e0:	01 f8                	add    %edi,%eax
 5e2:	01 c0                	add    %eax,%eax
 5e4:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5ee:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5ef:	eb d5                	jmp    5c6 <strtoul+0xaf>
    } else if (base == 16) {
 5f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5f5:	75 35                	jne    62c <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5f7:	8a 03                	mov    (%ebx),%al
 5f9:	0f be c0             	movsbl %al,%eax
 5fc:	83 e8 30             	sub    $0x30,%eax
 5ff:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 601:	83 fe 4a             	cmp    $0x4a,%esi
 604:	76 02                	jbe    608 <strtoul+0xf1>
    break;
 606:	eb 22                	jmp    62a <strtoul+0x113>
      }
      digit = cvtIn[digit];
 608:	8a 86 40 12 00 00    	mov    0x1240(%esi),%al
 60e:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 611:	83 fe 0f             	cmp    $0xf,%esi
 614:	76 02                	jbe    618 <strtoul+0x101>
    break;
 616:	eb 12                	jmp    62a <strtoul+0x113>
      }
      result = (result << 4) + digit;
 618:	89 f8                	mov    %edi,%eax
 61a:	c1 e0 04             	shl    $0x4,%eax
 61d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 620:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 627:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 628:	eb cd                	jmp    5f7 <strtoul+0xe0>
 62a:	eb 36                	jmp    662 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 62c:	8a 03                	mov    (%ebx),%al
 62e:	0f be c0             	movsbl %al,%eax
 631:	83 e8 30             	sub    $0x30,%eax
 634:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 636:	83 fe 4a             	cmp    $0x4a,%esi
 639:	76 02                	jbe    63d <strtoul+0x126>
    break;
 63b:	eb 25                	jmp    662 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 63d:	8a 86 40 12 00 00    	mov    0x1240(%esi),%al
 643:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 646:	8b 45 10             	mov    0x10(%ebp),%eax
 649:	39 f0                	cmp    %esi,%eax
 64b:	77 02                	ja     64f <strtoul+0x138>
    break;
 64d:	eb 13                	jmp    662 <strtoul+0x14b>
      }
      result = result*base + digit;
 64f:	8b 45 10             	mov    0x10(%ebp),%eax
 652:	0f af c7             	imul   %edi,%eax
 655:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 658:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 65f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 660:	eb ca                	jmp    62c <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 662:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 666:	75 03                	jne    66b <strtoul+0x154>
  p = string;
 668:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 66b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 66f:	74 05                	je     676 <strtoul+0x15f>
  *endPtr = p;
 671:	8b 45 0c             	mov    0xc(%ebp),%eax
 674:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 676:	89 f8                	mov    %edi,%eax
}
 678:	83 c4 14             	add    $0x14,%esp
 67b:	5b                   	pop    %ebx
 67c:	5e                   	pop    %esi
 67d:	5f                   	pop    %edi
 67e:	5d                   	pop    %ebp
 67f:	c3                   	ret    

00000680 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 680:	55                   	push   %ebp
 681:	89 e5                	mov    %esp,%ebp
 683:	53                   	push   %ebx
 684:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 687:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 68a:	eb 01                	jmp    68d <strtol+0xd>
      p += 1;
 68c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 68d:	8a 03                	mov    (%ebx),%al
 68f:	0f b6 c0             	movzbl %al,%eax
 692:	89 04 24             	mov    %eax,(%esp)
 695:	e8 3f fe ff ff       	call   4d9 <isspace>
 69a:	85 c0                	test   %eax,%eax
 69c:	75 ee                	jne    68c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 69e:	8a 03                	mov    (%ebx),%al
 6a0:	3c 2d                	cmp    $0x2d,%al
 6a2:	75 1e                	jne    6c2 <strtol+0x42>
  p += 1;
 6a4:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 6a5:	8b 45 10             	mov    0x10(%ebp),%eax
 6a8:	89 44 24 08          	mov    %eax,0x8(%esp)
 6ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 6af:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b3:	89 1c 24             	mov    %ebx,(%esp)
 6b6:	e8 5c fe ff ff       	call   517 <strtoul>
 6bb:	f7 d8                	neg    %eax
 6bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6c0:	eb 20                	jmp    6e2 <strtol+0x62>
    } else {
  if (*p == '+') {
 6c2:	8a 03                	mov    (%ebx),%al
 6c4:	3c 2b                	cmp    $0x2b,%al
 6c6:	75 01                	jne    6c9 <strtol+0x49>
      p += 1;
 6c8:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6c9:	8b 45 10             	mov    0x10(%ebp),%eax
 6cc:	89 44 24 08          	mov    %eax,0x8(%esp)
 6d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 6d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d7:	89 1c 24             	mov    %ebx,(%esp)
 6da:	e8 38 fe ff ff       	call   517 <strtoul>
 6df:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6e6:	75 17                	jne    6ff <strtol+0x7f>
 6e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6ec:	74 11                	je     6ff <strtol+0x7f>
 6ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f1:	8b 00                	mov    (%eax),%eax
 6f3:	39 d8                	cmp    %ebx,%eax
 6f5:	75 08                	jne    6ff <strtol+0x7f>
  *endPtr = string;
 6f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6fa:	8b 55 08             	mov    0x8(%ebp),%edx
 6fd:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 702:	83 c4 1c             	add    $0x1c,%esp
 705:	5b                   	pop    %ebx
 706:	5d                   	pop    %ebp
 707:	c3                   	ret    

00000708 <gets>:

char*
gets(char *buf, int max)
{
 708:	55                   	push   %ebp
 709:	89 e5                	mov    %esp,%ebp
 70b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 70e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 715:	eb 49                	jmp    760 <gets+0x58>
    cc = read(0, &c, 1);
 717:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 71e:	00 
 71f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 722:	89 44 24 04          	mov    %eax,0x4(%esp)
 726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 72d:	e8 3e 01 00 00       	call   870 <read>
 732:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 739:	7f 02                	jg     73d <gets+0x35>
      break;
 73b:	eb 2c                	jmp    769 <gets+0x61>
    buf[i++] = c;
 73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 740:	8d 50 01             	lea    0x1(%eax),%edx
 743:	89 55 f4             	mov    %edx,-0xc(%ebp)
 746:	89 c2                	mov    %eax,%edx
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	01 c2                	add    %eax,%edx
 74d:	8a 45 ef             	mov    -0x11(%ebp),%al
 750:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 752:	8a 45 ef             	mov    -0x11(%ebp),%al
 755:	3c 0a                	cmp    $0xa,%al
 757:	74 10                	je     769 <gets+0x61>
 759:	8a 45 ef             	mov    -0x11(%ebp),%al
 75c:	3c 0d                	cmp    $0xd,%al
 75e:	74 09                	je     769 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 760:	8b 45 f4             	mov    -0xc(%ebp),%eax
 763:	40                   	inc    %eax
 764:	3b 45 0c             	cmp    0xc(%ebp),%eax
 767:	7c ae                	jl     717 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 769:	8b 55 f4             	mov    -0xc(%ebp),%edx
 76c:	8b 45 08             	mov    0x8(%ebp),%eax
 76f:	01 d0                	add    %edx,%eax
 771:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 774:	8b 45 08             	mov    0x8(%ebp),%eax
}
 777:	c9                   	leave  
 778:	c3                   	ret    

00000779 <stat>:

int
stat(char *n, struct stat *st)
{
 779:	55                   	push   %ebp
 77a:	89 e5                	mov    %esp,%ebp
 77c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 77f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 786:	00 
 787:	8b 45 08             	mov    0x8(%ebp),%eax
 78a:	89 04 24             	mov    %eax,(%esp)
 78d:	e8 06 01 00 00       	call   898 <open>
 792:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 795:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 799:	79 07                	jns    7a2 <stat+0x29>
    return -1;
 79b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7a0:	eb 23                	jmp    7c5 <stat+0x4c>
  r = fstat(fd, st);
 7a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 7a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ac:	89 04 24             	mov    %eax,(%esp)
 7af:	e8 fc 00 00 00       	call   8b0 <fstat>
 7b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ba:	89 04 24             	mov    %eax,(%esp)
 7bd:	e8 be 00 00 00       	call   880 <close>
  return r;
 7c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7c5:	c9                   	leave  
 7c6:	c3                   	ret    

000007c7 <atoi>:

int
atoi(const char *s)
{
 7c7:	55                   	push   %ebp
 7c8:	89 e5                	mov    %esp,%ebp
 7ca:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7d4:	eb 24                	jmp    7fa <atoi+0x33>
    n = n*10 + *s++ - '0';
 7d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7d9:	89 d0                	mov    %edx,%eax
 7db:	c1 e0 02             	shl    $0x2,%eax
 7de:	01 d0                	add    %edx,%eax
 7e0:	01 c0                	add    %eax,%eax
 7e2:	89 c1                	mov    %eax,%ecx
 7e4:	8b 45 08             	mov    0x8(%ebp),%eax
 7e7:	8d 50 01             	lea    0x1(%eax),%edx
 7ea:	89 55 08             	mov    %edx,0x8(%ebp)
 7ed:	8a 00                	mov    (%eax),%al
 7ef:	0f be c0             	movsbl %al,%eax
 7f2:	01 c8                	add    %ecx,%eax
 7f4:	83 e8 30             	sub    $0x30,%eax
 7f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7fa:	8b 45 08             	mov    0x8(%ebp),%eax
 7fd:	8a 00                	mov    (%eax),%al
 7ff:	3c 2f                	cmp    $0x2f,%al
 801:	7e 09                	jle    80c <atoi+0x45>
 803:	8b 45 08             	mov    0x8(%ebp),%eax
 806:	8a 00                	mov    (%eax),%al
 808:	3c 39                	cmp    $0x39,%al
 80a:	7e ca                	jle    7d6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 80f:	c9                   	leave  
 810:	c3                   	ret    

00000811 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 811:	55                   	push   %ebp
 812:	89 e5                	mov    %esp,%ebp
 814:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 817:	8b 45 08             	mov    0x8(%ebp),%eax
 81a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 81d:	8b 45 0c             	mov    0xc(%ebp),%eax
 820:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 823:	eb 16                	jmp    83b <memmove+0x2a>
    *dst++ = *src++;
 825:	8b 45 fc             	mov    -0x4(%ebp),%eax
 828:	8d 50 01             	lea    0x1(%eax),%edx
 82b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 82e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 831:	8d 4a 01             	lea    0x1(%edx),%ecx
 834:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 837:	8a 12                	mov    (%edx),%dl
 839:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 83b:	8b 45 10             	mov    0x10(%ebp),%eax
 83e:	8d 50 ff             	lea    -0x1(%eax),%edx
 841:	89 55 10             	mov    %edx,0x10(%ebp)
 844:	85 c0                	test   %eax,%eax
 846:	7f dd                	jg     825 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 848:	8b 45 08             	mov    0x8(%ebp),%eax
}
 84b:	c9                   	leave  
 84c:	c3                   	ret    
 84d:	90                   	nop
 84e:	90                   	nop
 84f:	90                   	nop

00000850 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 850:	b8 01 00 00 00       	mov    $0x1,%eax
 855:	cd 40                	int    $0x40
 857:	c3                   	ret    

00000858 <exit>:
SYSCALL(exit)
 858:	b8 02 00 00 00       	mov    $0x2,%eax
 85d:	cd 40                	int    $0x40
 85f:	c3                   	ret    

00000860 <wait>:
SYSCALL(wait)
 860:	b8 03 00 00 00       	mov    $0x3,%eax
 865:	cd 40                	int    $0x40
 867:	c3                   	ret    

00000868 <pipe>:
SYSCALL(pipe)
 868:	b8 04 00 00 00       	mov    $0x4,%eax
 86d:	cd 40                	int    $0x40
 86f:	c3                   	ret    

00000870 <read>:
SYSCALL(read)
 870:	b8 05 00 00 00       	mov    $0x5,%eax
 875:	cd 40                	int    $0x40
 877:	c3                   	ret    

00000878 <write>:
SYSCALL(write)
 878:	b8 10 00 00 00       	mov    $0x10,%eax
 87d:	cd 40                	int    $0x40
 87f:	c3                   	ret    

00000880 <close>:
SYSCALL(close)
 880:	b8 15 00 00 00       	mov    $0x15,%eax
 885:	cd 40                	int    $0x40
 887:	c3                   	ret    

00000888 <kill>:
SYSCALL(kill)
 888:	b8 06 00 00 00       	mov    $0x6,%eax
 88d:	cd 40                	int    $0x40
 88f:	c3                   	ret    

00000890 <exec>:
SYSCALL(exec)
 890:	b8 07 00 00 00       	mov    $0x7,%eax
 895:	cd 40                	int    $0x40
 897:	c3                   	ret    

00000898 <open>:
SYSCALL(open)
 898:	b8 0f 00 00 00       	mov    $0xf,%eax
 89d:	cd 40                	int    $0x40
 89f:	c3                   	ret    

000008a0 <mknod>:
SYSCALL(mknod)
 8a0:	b8 11 00 00 00       	mov    $0x11,%eax
 8a5:	cd 40                	int    $0x40
 8a7:	c3                   	ret    

000008a8 <unlink>:
SYSCALL(unlink)
 8a8:	b8 12 00 00 00       	mov    $0x12,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <fstat>:
SYSCALL(fstat)
 8b0:	b8 08 00 00 00       	mov    $0x8,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <link>:
SYSCALL(link)
 8b8:	b8 13 00 00 00       	mov    $0x13,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <mkdir>:
SYSCALL(mkdir)
 8c0:	b8 14 00 00 00       	mov    $0x14,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <chdir>:
SYSCALL(chdir)
 8c8:	b8 09 00 00 00       	mov    $0x9,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <dup>:
SYSCALL(dup)
 8d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <getpid>:
SYSCALL(getpid)
 8d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <sbrk>:
SYSCALL(sbrk)
 8e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <sleep>:
SYSCALL(sleep)
 8e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <uptime>:
SYSCALL(uptime)
 8f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <getname>:
SYSCALL(getname)
 8f8:	b8 16 00 00 00       	mov    $0x16,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <setname>:
SYSCALL(setname)
 900:	b8 17 00 00 00       	mov    $0x17,%eax
 905:	cd 40                	int    $0x40
 907:	c3                   	ret    

00000908 <getmaxproc>:
SYSCALL(getmaxproc)
 908:	b8 18 00 00 00       	mov    $0x18,%eax
 90d:	cd 40                	int    $0x40
 90f:	c3                   	ret    

00000910 <setmaxproc>:
SYSCALL(setmaxproc)
 910:	b8 19 00 00 00       	mov    $0x19,%eax
 915:	cd 40                	int    $0x40
 917:	c3                   	ret    

00000918 <getmaxmem>:
SYSCALL(getmaxmem)
 918:	b8 1a 00 00 00       	mov    $0x1a,%eax
 91d:	cd 40                	int    $0x40
 91f:	c3                   	ret    

00000920 <setmaxmem>:
SYSCALL(setmaxmem)
 920:	b8 1b 00 00 00       	mov    $0x1b,%eax
 925:	cd 40                	int    $0x40
 927:	c3                   	ret    

00000928 <getmaxdisk>:
SYSCALL(getmaxdisk)
 928:	b8 1c 00 00 00       	mov    $0x1c,%eax
 92d:	cd 40                	int    $0x40
 92f:	c3                   	ret    

00000930 <setmaxdisk>:
SYSCALL(setmaxdisk)
 930:	b8 1d 00 00 00       	mov    $0x1d,%eax
 935:	cd 40                	int    $0x40
 937:	c3                   	ret    

00000938 <getusedmem>:
SYSCALL(getusedmem)
 938:	b8 1e 00 00 00       	mov    $0x1e,%eax
 93d:	cd 40                	int    $0x40
 93f:	c3                   	ret    

00000940 <setusedmem>:
SYSCALL(setusedmem)
 940:	b8 1f 00 00 00       	mov    $0x1f,%eax
 945:	cd 40                	int    $0x40
 947:	c3                   	ret    

00000948 <getuseddisk>:
SYSCALL(getuseddisk)
 948:	b8 20 00 00 00       	mov    $0x20,%eax
 94d:	cd 40                	int    $0x40
 94f:	c3                   	ret    

00000950 <setuseddisk>:
SYSCALL(setuseddisk)
 950:	b8 21 00 00 00       	mov    $0x21,%eax
 955:	cd 40                	int    $0x40
 957:	c3                   	ret    

00000958 <setvc>:
SYSCALL(setvc)
 958:	b8 22 00 00 00       	mov    $0x22,%eax
 95d:	cd 40                	int    $0x40
 95f:	c3                   	ret    

00000960 <setactivefs>:
SYSCALL(setactivefs)
 960:	b8 24 00 00 00       	mov    $0x24,%eax
 965:	cd 40                	int    $0x40
 967:	c3                   	ret    

00000968 <getactivefs>:
SYSCALL(getactivefs)
 968:	b8 25 00 00 00       	mov    $0x25,%eax
 96d:	cd 40                	int    $0x40
 96f:	c3                   	ret    

00000970 <getvcfs>:
SYSCALL(getvcfs)
 970:	b8 23 00 00 00       	mov    $0x23,%eax
 975:	cd 40                	int    $0x40
 977:	c3                   	ret    

00000978 <getcwd>:
SYSCALL(getcwd)
 978:	b8 26 00 00 00       	mov    $0x26,%eax
 97d:	cd 40                	int    $0x40
 97f:	c3                   	ret    

00000980 <tostring>:
SYSCALL(tostring)
 980:	b8 27 00 00 00       	mov    $0x27,%eax
 985:	cd 40                	int    $0x40
 987:	c3                   	ret    

00000988 <getactivefsindex>:
SYSCALL(getactivefsindex)
 988:	b8 28 00 00 00       	mov    $0x28,%eax
 98d:	cd 40                	int    $0x40
 98f:	c3                   	ret    

00000990 <setatroot>:
SYSCALL(setatroot)
 990:	b8 2a 00 00 00       	mov    $0x2a,%eax
 995:	cd 40                	int    $0x40
 997:	c3                   	ret    

00000998 <getatroot>:
SYSCALL(getatroot)
 998:	b8 29 00 00 00       	mov    $0x29,%eax
 99d:	cd 40                	int    $0x40
 99f:	c3                   	ret    

000009a0 <getpath>:
SYSCALL(getpath)
 9a0:	b8 2b 00 00 00       	mov    $0x2b,%eax
 9a5:	cd 40                	int    $0x40
 9a7:	c3                   	ret    

000009a8 <setpath>:
SYSCALL(setpath)
 9a8:	b8 2c 00 00 00       	mov    $0x2c,%eax
 9ad:	cd 40                	int    $0x40
 9af:	c3                   	ret    

000009b0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 9b0:	55                   	push   %ebp
 9b1:	89 e5                	mov    %esp,%ebp
 9b3:	83 ec 18             	sub    $0x18,%esp
 9b6:	8b 45 0c             	mov    0xc(%ebp),%eax
 9b9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 9bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 9c3:	00 
 9c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 9c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9cb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ce:	89 04 24             	mov    %eax,(%esp)
 9d1:	e8 a2 fe ff ff       	call   878 <write>
}
 9d6:	c9                   	leave  
 9d7:	c3                   	ret    

000009d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9d8:	55                   	push   %ebp
 9d9:	89 e5                	mov    %esp,%ebp
 9db:	56                   	push   %esi
 9dc:	53                   	push   %ebx
 9dd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 9e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 9e7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9eb:	74 17                	je     a04 <printint+0x2c>
 9ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9f1:	79 11                	jns    a04 <printint+0x2c>
    neg = 1;
 9f3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 9fd:	f7 d8                	neg    %eax
 9ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a02:	eb 06                	jmp    a0a <printint+0x32>
  } else {
    x = xx;
 a04:	8b 45 0c             	mov    0xc(%ebp),%eax
 a07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 a0a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 a11:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 a14:	8d 41 01             	lea    0x1(%ecx),%eax
 a17:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 a1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a20:	ba 00 00 00 00       	mov    $0x0,%edx
 a25:	f7 f3                	div    %ebx
 a27:	89 d0                	mov    %edx,%eax
 a29:	8a 80 8c 12 00 00    	mov    0x128c(%eax),%al
 a2f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a33:	8b 75 10             	mov    0x10(%ebp),%esi
 a36:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a39:	ba 00 00 00 00       	mov    $0x0,%edx
 a3e:	f7 f6                	div    %esi
 a40:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a47:	75 c8                	jne    a11 <printint+0x39>
  if(neg)
 a49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a4d:	74 10                	je     a5f <printint+0x87>
    buf[i++] = '-';
 a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a52:	8d 50 01             	lea    0x1(%eax),%edx
 a55:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a58:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a5d:	eb 1e                	jmp    a7d <printint+0xa5>
 a5f:	eb 1c                	jmp    a7d <printint+0xa5>
    putc(fd, buf[i]);
 a61:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a67:	01 d0                	add    %edx,%eax
 a69:	8a 00                	mov    (%eax),%al
 a6b:	0f be c0             	movsbl %al,%eax
 a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a72:	8b 45 08             	mov    0x8(%ebp),%eax
 a75:	89 04 24             	mov    %eax,(%esp)
 a78:	e8 33 ff ff ff       	call   9b0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a7d:	ff 4d f4             	decl   -0xc(%ebp)
 a80:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a84:	79 db                	jns    a61 <printint+0x89>
    putc(fd, buf[i]);
}
 a86:	83 c4 30             	add    $0x30,%esp
 a89:	5b                   	pop    %ebx
 a8a:	5e                   	pop    %esi
 a8b:	5d                   	pop    %ebp
 a8c:	c3                   	ret    

00000a8d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a8d:	55                   	push   %ebp
 a8e:	89 e5                	mov    %esp,%ebp
 a90:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a93:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a9a:	8d 45 0c             	lea    0xc(%ebp),%eax
 a9d:	83 c0 04             	add    $0x4,%eax
 aa0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 aa3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 aaa:	e9 77 01 00 00       	jmp    c26 <printf+0x199>
    c = fmt[i] & 0xff;
 aaf:	8b 55 0c             	mov    0xc(%ebp),%edx
 ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ab5:	01 d0                	add    %edx,%eax
 ab7:	8a 00                	mov    (%eax),%al
 ab9:	0f be c0             	movsbl %al,%eax
 abc:	25 ff 00 00 00       	and    $0xff,%eax
 ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 ac4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 ac8:	75 2c                	jne    af6 <printf+0x69>
      if(c == '%'){
 aca:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ace:	75 0c                	jne    adc <printf+0x4f>
        state = '%';
 ad0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 ad7:	e9 47 01 00 00       	jmp    c23 <printf+0x196>
      } else {
        putc(fd, c);
 adc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 adf:	0f be c0             	movsbl %al,%eax
 ae2:	89 44 24 04          	mov    %eax,0x4(%esp)
 ae6:	8b 45 08             	mov    0x8(%ebp),%eax
 ae9:	89 04 24             	mov    %eax,(%esp)
 aec:	e8 bf fe ff ff       	call   9b0 <putc>
 af1:	e9 2d 01 00 00       	jmp    c23 <printf+0x196>
      }
    } else if(state == '%'){
 af6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 afa:	0f 85 23 01 00 00    	jne    c23 <printf+0x196>
      if(c == 'd'){
 b00:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 b04:	75 2d                	jne    b33 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b09:	8b 00                	mov    (%eax),%eax
 b0b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 b12:	00 
 b13:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 b1a:	00 
 b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b1f:	8b 45 08             	mov    0x8(%ebp),%eax
 b22:	89 04 24             	mov    %eax,(%esp)
 b25:	e8 ae fe ff ff       	call   9d8 <printint>
        ap++;
 b2a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b2e:	e9 e9 00 00 00       	jmp    c1c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 b33:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b37:	74 06                	je     b3f <printf+0xb2>
 b39:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b3d:	75 2d                	jne    b6c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 b3f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b42:	8b 00                	mov    (%eax),%eax
 b44:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 b4b:	00 
 b4c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b53:	00 
 b54:	89 44 24 04          	mov    %eax,0x4(%esp)
 b58:	8b 45 08             	mov    0x8(%ebp),%eax
 b5b:	89 04 24             	mov    %eax,(%esp)
 b5e:	e8 75 fe ff ff       	call   9d8 <printint>
        ap++;
 b63:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b67:	e9 b0 00 00 00       	jmp    c1c <printf+0x18f>
      } else if(c == 's'){
 b6c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b70:	75 42                	jne    bb4 <printf+0x127>
        s = (char*)*ap;
 b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b75:	8b 00                	mov    (%eax),%eax
 b77:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b7a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b7e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b82:	75 09                	jne    b8d <printf+0x100>
          s = "(null)";
 b84:	c7 45 f4 bb 0e 00 00 	movl   $0xebb,-0xc(%ebp)
        while(*s != 0){
 b8b:	eb 1c                	jmp    ba9 <printf+0x11c>
 b8d:	eb 1a                	jmp    ba9 <printf+0x11c>
          putc(fd, *s);
 b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b92:	8a 00                	mov    (%eax),%al
 b94:	0f be c0             	movsbl %al,%eax
 b97:	89 44 24 04          	mov    %eax,0x4(%esp)
 b9b:	8b 45 08             	mov    0x8(%ebp),%eax
 b9e:	89 04 24             	mov    %eax,(%esp)
 ba1:	e8 0a fe ff ff       	call   9b0 <putc>
          s++;
 ba6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bac:	8a 00                	mov    (%eax),%al
 bae:	84 c0                	test   %al,%al
 bb0:	75 dd                	jne    b8f <printf+0x102>
 bb2:	eb 68                	jmp    c1c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 bb4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 bb8:	75 1d                	jne    bd7 <printf+0x14a>
        putc(fd, *ap);
 bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bbd:	8b 00                	mov    (%eax),%eax
 bbf:	0f be c0             	movsbl %al,%eax
 bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
 bc6:	8b 45 08             	mov    0x8(%ebp),%eax
 bc9:	89 04 24             	mov    %eax,(%esp)
 bcc:	e8 df fd ff ff       	call   9b0 <putc>
        ap++;
 bd1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 bd5:	eb 45                	jmp    c1c <printf+0x18f>
      } else if(c == '%'){
 bd7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bdb:	75 17                	jne    bf4 <printf+0x167>
        putc(fd, c);
 bdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 be0:	0f be c0             	movsbl %al,%eax
 be3:	89 44 24 04          	mov    %eax,0x4(%esp)
 be7:	8b 45 08             	mov    0x8(%ebp),%eax
 bea:	89 04 24             	mov    %eax,(%esp)
 bed:	e8 be fd ff ff       	call   9b0 <putc>
 bf2:	eb 28                	jmp    c1c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 bf4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 bfb:	00 
 bfc:	8b 45 08             	mov    0x8(%ebp),%eax
 bff:	89 04 24             	mov    %eax,(%esp)
 c02:	e8 a9 fd ff ff       	call   9b0 <putc>
        putc(fd, c);
 c07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c0a:	0f be c0             	movsbl %al,%eax
 c0d:	89 44 24 04          	mov    %eax,0x4(%esp)
 c11:	8b 45 08             	mov    0x8(%ebp),%eax
 c14:	89 04 24             	mov    %eax,(%esp)
 c17:	e8 94 fd ff ff       	call   9b0 <putc>
      }
      state = 0;
 c1c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 c23:	ff 45 f0             	incl   -0x10(%ebp)
 c26:	8b 55 0c             	mov    0xc(%ebp),%edx
 c29:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c2c:	01 d0                	add    %edx,%eax
 c2e:	8a 00                	mov    (%eax),%al
 c30:	84 c0                	test   %al,%al
 c32:	0f 85 77 fe ff ff    	jne    aaf <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c38:	c9                   	leave  
 c39:	c3                   	ret    
 c3a:	90                   	nop
 c3b:	90                   	nop

00000c3c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c3c:	55                   	push   %ebp
 c3d:	89 e5                	mov    %esp,%ebp
 c3f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c42:	8b 45 08             	mov    0x8(%ebp),%eax
 c45:	83 e8 08             	sub    $0x8,%eax
 c48:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c4b:	a1 b0 12 00 00       	mov    0x12b0,%eax
 c50:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c53:	eb 24                	jmp    c79 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c58:	8b 00                	mov    (%eax),%eax
 c5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c5d:	77 12                	ja     c71 <free+0x35>
 c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c62:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c65:	77 24                	ja     c8b <free+0x4f>
 c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6a:	8b 00                	mov    (%eax),%eax
 c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c6f:	77 1a                	ja     c8b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c74:	8b 00                	mov    (%eax),%eax
 c76:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c79:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c7f:	76 d4                	jbe    c55 <free+0x19>
 c81:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c84:	8b 00                	mov    (%eax),%eax
 c86:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c89:	76 ca                	jbe    c55 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8e:	8b 40 04             	mov    0x4(%eax),%eax
 c91:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c9b:	01 c2                	add    %eax,%edx
 c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca0:	8b 00                	mov    (%eax),%eax
 ca2:	39 c2                	cmp    %eax,%edx
 ca4:	75 24                	jne    cca <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ca6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca9:	8b 50 04             	mov    0x4(%eax),%edx
 cac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 caf:	8b 00                	mov    (%eax),%eax
 cb1:	8b 40 04             	mov    0x4(%eax),%eax
 cb4:	01 c2                	add    %eax,%edx
 cb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cb9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 cbc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cbf:	8b 00                	mov    (%eax),%eax
 cc1:	8b 10                	mov    (%eax),%edx
 cc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc6:	89 10                	mov    %edx,(%eax)
 cc8:	eb 0a                	jmp    cd4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 cca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ccd:	8b 10                	mov    (%eax),%edx
 ccf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cd2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd7:	8b 40 04             	mov    0x4(%eax),%eax
 cda:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ce1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce4:	01 d0                	add    %edx,%eax
 ce6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ce9:	75 20                	jne    d0b <free+0xcf>
    p->s.size += bp->s.size;
 ceb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cee:	8b 50 04             	mov    0x4(%eax),%edx
 cf1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cf4:	8b 40 04             	mov    0x4(%eax),%eax
 cf7:	01 c2                	add    %eax,%edx
 cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cfc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d02:	8b 10                	mov    (%eax),%edx
 d04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d07:	89 10                	mov    %edx,(%eax)
 d09:	eb 08                	jmp    d13 <free+0xd7>
  } else
    p->s.ptr = bp;
 d0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d0e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 d11:	89 10                	mov    %edx,(%eax)
  freep = p;
 d13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d16:	a3 b0 12 00 00       	mov    %eax,0x12b0
}
 d1b:	c9                   	leave  
 d1c:	c3                   	ret    

00000d1d <morecore>:

static Header*
morecore(uint nu)
{
 d1d:	55                   	push   %ebp
 d1e:	89 e5                	mov    %esp,%ebp
 d20:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 d23:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 d2a:	77 07                	ja     d33 <morecore+0x16>
    nu = 4096;
 d2c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d33:	8b 45 08             	mov    0x8(%ebp),%eax
 d36:	c1 e0 03             	shl    $0x3,%eax
 d39:	89 04 24             	mov    %eax,(%esp)
 d3c:	e8 9f fb ff ff       	call   8e0 <sbrk>
 d41:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d44:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d48:	75 07                	jne    d51 <morecore+0x34>
    return 0;
 d4a:	b8 00 00 00 00       	mov    $0x0,%eax
 d4f:	eb 22                	jmp    d73 <morecore+0x56>
  hp = (Header*)p;
 d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d54:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d5a:	8b 55 08             	mov    0x8(%ebp),%edx
 d5d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d60:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d63:	83 c0 08             	add    $0x8,%eax
 d66:	89 04 24             	mov    %eax,(%esp)
 d69:	e8 ce fe ff ff       	call   c3c <free>
  return freep;
 d6e:	a1 b0 12 00 00       	mov    0x12b0,%eax
}
 d73:	c9                   	leave  
 d74:	c3                   	ret    

00000d75 <malloc>:

void*
malloc(uint nbytes)
{
 d75:	55                   	push   %ebp
 d76:	89 e5                	mov    %esp,%ebp
 d78:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d7b:	8b 45 08             	mov    0x8(%ebp),%eax
 d7e:	83 c0 07             	add    $0x7,%eax
 d81:	c1 e8 03             	shr    $0x3,%eax
 d84:	40                   	inc    %eax
 d85:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d88:	a1 b0 12 00 00       	mov    0x12b0,%eax
 d8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d94:	75 23                	jne    db9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d96:	c7 45 f0 a8 12 00 00 	movl   $0x12a8,-0x10(%ebp)
 d9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 da0:	a3 b0 12 00 00       	mov    %eax,0x12b0
 da5:	a1 b0 12 00 00       	mov    0x12b0,%eax
 daa:	a3 a8 12 00 00       	mov    %eax,0x12a8
    base.s.size = 0;
 daf:	c7 05 ac 12 00 00 00 	movl   $0x0,0x12ac
 db6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 db9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dbc:	8b 00                	mov    (%eax),%eax
 dbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc4:	8b 40 04             	mov    0x4(%eax),%eax
 dc7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dca:	72 4d                	jb     e19 <malloc+0xa4>
      if(p->s.size == nunits)
 dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcf:	8b 40 04             	mov    0x4(%eax),%eax
 dd2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 dd5:	75 0c                	jne    de3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dda:	8b 10                	mov    (%eax),%edx
 ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ddf:	89 10                	mov    %edx,(%eax)
 de1:	eb 26                	jmp    e09 <malloc+0x94>
      else {
        p->s.size -= nunits;
 de3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de6:	8b 40 04             	mov    0x4(%eax),%eax
 de9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 dec:	89 c2                	mov    %eax,%edx
 dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 df7:	8b 40 04             	mov    0x4(%eax),%eax
 dfa:	c1 e0 03             	shl    $0x3,%eax
 dfd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 e00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e03:	8b 55 ec             	mov    -0x14(%ebp),%edx
 e06:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e0c:	a3 b0 12 00 00       	mov    %eax,0x12b0
      return (void*)(p + 1);
 e11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e14:	83 c0 08             	add    $0x8,%eax
 e17:	eb 38                	jmp    e51 <malloc+0xdc>
    }
    if(p == freep)
 e19:	a1 b0 12 00 00       	mov    0x12b0,%eax
 e1e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 e21:	75 1b                	jne    e3e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
 e26:	89 04 24             	mov    %eax,(%esp)
 e29:	e8 ef fe ff ff       	call   d1d <morecore>
 e2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e35:	75 07                	jne    e3e <malloc+0xc9>
        return 0;
 e37:	b8 00 00 00 00       	mov    $0x0,%eax
 e3c:	eb 13                	jmp    e51 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e47:	8b 00                	mov    (%eax),%eax
 e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e4c:	e9 70 ff ff ff       	jmp    dc1 <malloc+0x4c>
}
 e51:	c9                   	leave  
 e52:	c3                   	ret    
