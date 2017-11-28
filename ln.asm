
_ln:     file format elf32-i386


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
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 27 0e 00 	movl   $0xe27,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 3e 0a 00 00       	call   a61 <printf>
    exit();
  23:	e8 04 08 00 00       	call   82c <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 48 08 00 00       	call   88c <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 3a 0e 00 	movl   $0xe3a,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 ed 09 00 00       	call   a61 <printf>
  exit();
  74:	e8 b3 07 00 00       	call   82c <exit>
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	90                   	nop
  ae:	8b 45 08             	mov    0x8(%ebp),%eax
  b1:	8d 50 01             	lea    0x1(%eax),%edx
  b4:	89 55 08             	mov    %edx,0x8(%ebp)
  b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  ba:	8d 4a 01             	lea    0x1(%edx),%ecx
  bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  c0:	8a 12                	mov    (%edx),%dl
  c2:	88 10                	mov    %dl,(%eax)
  c4:	8a 00                	mov    (%eax),%al
  c6:	84 c0                	test   %al,%al
  c8:	75 e4                	jne    ae <strcpy+0xd>
    ;
  return os;
  ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  cd:	c9                   	leave  
  ce:	c3                   	ret    

000000cf <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  d2:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
  d5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
  dc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  e3:	00 
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	89 04 24             	mov    %eax,(%esp)
  ea:	e8 7d 07 00 00       	call   86c <open>
  ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  f6:	79 20                	jns    118 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
  f8:	8b 45 08             	mov    0x8(%ebp),%eax
  fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  ff:	c7 44 24 04 4e 0e 00 	movl   $0xe4e,0x4(%esp)
 106:	00 
 107:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 10e:	e8 4e 09 00 00       	call   a61 <printf>
      exit();
 113:	e8 14 07 00 00       	call   82c <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
 118:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
 11f:	00 
 120:	8b 45 0c             	mov    0xc(%ebp),%eax
 123:	89 04 24             	mov    %eax,(%esp)
 126:	e8 41 07 00 00       	call   86c <open>
 12b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 12e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 132:	79 20                	jns    154 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 44 24 08          	mov    %eax,0x8(%esp)
 13b:	c7 44 24 04 69 0e 00 	movl   $0xe69,0x4(%esp)
 142:	00 
 143:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 14a:	e8 12 09 00 00       	call   a61 <printf>
      exit();
 14f:	e8 d8 06 00 00       	call   82c <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
 154:	eb 3b                	jmp    191 <copy+0xc2>
  {
      max = used_disk+=count;
 156:	8b 45 e8             	mov    -0x18(%ebp),%eax
 159:	01 45 10             	add    %eax,0x10(%ebp)
 15c:	8b 45 10             	mov    0x10(%ebp),%eax
 15f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 165:	3b 45 14             	cmp    0x14(%ebp),%eax
 168:	7e 07                	jle    171 <copy+0xa2>
      {
        return -1;
 16a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 16f:	eb 5c                	jmp    1cd <copy+0xfe>
      }
      bytes = bytes + count;
 171:	8b 45 e8             	mov    -0x18(%ebp),%eax
 174:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 177:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 17e:	00 
 17f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 182:	89 44 24 04          	mov    %eax,0x4(%esp)
 186:	8b 45 ec             	mov    -0x14(%ebp),%eax
 189:	89 04 24             	mov    %eax,(%esp)
 18c:	e8 bb 06 00 00       	call   84c <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 191:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 198:	00 
 199:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 19c:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 99 06 00 00       	call   844 <read>
 1ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
 1ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 1b2:	7f a2                	jg     156 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 1b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1b7:	89 04 24             	mov    %eax,(%esp)
 1ba:	e8 95 06 00 00       	call   854 <close>
  close(fd2);
 1bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 1c2:	89 04 24             	mov    %eax,(%esp)
 1c5:	e8 8a 06 00 00       	call   854 <close>
  return(bytes);
 1ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 1cd:	c9                   	leave  
 1ce:	c3                   	ret    

000001cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1d2:	eb 06                	jmp    1da <strcmp+0xb>
    p++, q++;
 1d4:	ff 45 08             	incl   0x8(%ebp)
 1d7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	8a 00                	mov    (%eax),%al
 1df:	84 c0                	test   %al,%al
 1e1:	74 0e                	je     1f1 <strcmp+0x22>
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	8a 10                	mov    (%eax),%dl
 1e8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1eb:	8a 00                	mov    (%eax),%al
 1ed:	38 c2                	cmp    %al,%dl
 1ef:	74 e3                	je     1d4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	8a 00                	mov    (%eax),%al
 1f6:	0f b6 d0             	movzbl %al,%edx
 1f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fc:	8a 00                	mov    (%eax),%al
 1fe:	0f b6 c0             	movzbl %al,%eax
 201:	29 c2                	sub    %eax,%edx
 203:	89 d0                	mov    %edx,%eax
}
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    

00000207 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 207:	55                   	push   %ebp
 208:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 20a:	eb 09                	jmp    215 <strncmp+0xe>
    n--, p++, q++;
 20c:	ff 4d 10             	decl   0x10(%ebp)
 20f:	ff 45 08             	incl   0x8(%ebp)
 212:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 215:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 219:	74 17                	je     232 <strncmp+0x2b>
 21b:	8b 45 08             	mov    0x8(%ebp),%eax
 21e:	8a 00                	mov    (%eax),%al
 220:	84 c0                	test   %al,%al
 222:	74 0e                	je     232 <strncmp+0x2b>
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	8a 10                	mov    (%eax),%dl
 229:	8b 45 0c             	mov    0xc(%ebp),%eax
 22c:	8a 00                	mov    (%eax),%al
 22e:	38 c2                	cmp    %al,%dl
 230:	74 da                	je     20c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 232:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 236:	75 07                	jne    23f <strncmp+0x38>
    return 0;
 238:	b8 00 00 00 00       	mov    $0x0,%eax
 23d:	eb 14                	jmp    253 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 23f:	8b 45 08             	mov    0x8(%ebp),%eax
 242:	8a 00                	mov    (%eax),%al
 244:	0f b6 d0             	movzbl %al,%edx
 247:	8b 45 0c             	mov    0xc(%ebp),%eax
 24a:	8a 00                	mov    (%eax),%al
 24c:	0f b6 c0             	movzbl %al,%eax
 24f:	29 c2                	sub    %eax,%edx
 251:	89 d0                	mov    %edx,%eax
}
 253:	5d                   	pop    %ebp
 254:	c3                   	ret    

00000255 <strlen>:

uint
strlen(const char *s)
{
 255:	55                   	push   %ebp
 256:	89 e5                	mov    %esp,%ebp
 258:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 25b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 262:	eb 03                	jmp    267 <strlen+0x12>
 264:	ff 45 fc             	incl   -0x4(%ebp)
 267:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26a:	8b 45 08             	mov    0x8(%ebp),%eax
 26d:	01 d0                	add    %edx,%eax
 26f:	8a 00                	mov    (%eax),%al
 271:	84 c0                	test   %al,%al
 273:	75 ef                	jne    264 <strlen+0xf>
    ;
  return n;
 275:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 278:	c9                   	leave  
 279:	c3                   	ret    

0000027a <memset>:

void*
memset(void *dst, int c, uint n)
{
 27a:	55                   	push   %ebp
 27b:	89 e5                	mov    %esp,%ebp
 27d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 280:	8b 45 10             	mov    0x10(%ebp),%eax
 283:	89 44 24 08          	mov    %eax,0x8(%esp)
 287:	8b 45 0c             	mov    0xc(%ebp),%eax
 28a:	89 44 24 04          	mov    %eax,0x4(%esp)
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	89 04 24             	mov    %eax,(%esp)
 294:	e8 e3 fd ff ff       	call   7c <stosb>
  return dst;
 299:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29c:	c9                   	leave  
 29d:	c3                   	ret    

0000029e <strchr>:

char*
strchr(const char *s, char c)
{
 29e:	55                   	push   %ebp
 29f:	89 e5                	mov    %esp,%ebp
 2a1:	83 ec 04             	sub    $0x4,%esp
 2a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2aa:	eb 12                	jmp    2be <strchr+0x20>
    if(*s == c)
 2ac:	8b 45 08             	mov    0x8(%ebp),%eax
 2af:	8a 00                	mov    (%eax),%al
 2b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2b4:	75 05                	jne    2bb <strchr+0x1d>
      return (char*)s;
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	eb 11                	jmp    2cc <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2bb:	ff 45 08             	incl   0x8(%ebp)
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
 2c1:	8a 00                	mov    (%eax),%al
 2c3:	84 c0                	test   %al,%al
 2c5:	75 e5                	jne    2ac <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <strcat>:

char *
strcat(char *dest, const char *src)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 2d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2db:	eb 03                	jmp    2e0 <strcat+0x12>
 2dd:	ff 45 fc             	incl   -0x4(%ebp)
 2e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	01 d0                	add    %edx,%eax
 2e8:	8a 00                	mov    (%eax),%al
 2ea:	84 c0                	test   %al,%al
 2ec:	75 ef                	jne    2dd <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 2ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 2f5:	eb 1e                	jmp    315 <strcat+0x47>
        dest[i+j] = src[j];
 2f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fd:	01 d0                	add    %edx,%eax
 2ff:	89 c2                	mov    %eax,%edx
 301:	8b 45 08             	mov    0x8(%ebp),%eax
 304:	01 c2                	add    %eax,%edx
 306:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 309:	8b 45 0c             	mov    0xc(%ebp),%eax
 30c:	01 c8                	add    %ecx,%eax
 30e:	8a 00                	mov    (%eax),%al
 310:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 312:	ff 45 f8             	incl   -0x8(%ebp)
 315:	8b 55 f8             	mov    -0x8(%ebp),%edx
 318:	8b 45 0c             	mov    0xc(%ebp),%eax
 31b:	01 d0                	add    %edx,%eax
 31d:	8a 00                	mov    (%eax),%al
 31f:	84 c0                	test   %al,%al
 321:	75 d4                	jne    2f7 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 323:	8b 45 f8             	mov    -0x8(%ebp),%eax
 326:	8b 55 fc             	mov    -0x4(%ebp),%edx
 329:	01 d0                	add    %edx,%eax
 32b:	89 c2                	mov    %eax,%edx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	01 d0                	add    %edx,%eax
 332:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 335:	8b 45 08             	mov    0x8(%ebp),%eax
}
 338:	c9                   	leave  
 339:	c3                   	ret    

0000033a <strstr>:

int 
strstr(char* s, char* sub)
{
 33a:	55                   	push   %ebp
 33b:	89 e5                	mov    %esp,%ebp
 33d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 340:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 347:	eb 7c                	jmp    3c5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 349:	8b 55 fc             	mov    -0x4(%ebp),%edx
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	01 d0                	add    %edx,%eax
 351:	8a 10                	mov    (%eax),%dl
 353:	8b 45 0c             	mov    0xc(%ebp),%eax
 356:	8a 00                	mov    (%eax),%al
 358:	38 c2                	cmp    %al,%dl
 35a:	75 66                	jne    3c2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 35c:	8b 45 0c             	mov    0xc(%ebp),%eax
 35f:	89 04 24             	mov    %eax,(%esp)
 362:	e8 ee fe ff ff       	call   255 <strlen>
 367:	83 f8 01             	cmp    $0x1,%eax
 36a:	75 05                	jne    371 <strstr+0x37>
            {  
                return i;
 36c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 36f:	eb 6b                	jmp    3dc <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 371:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 378:	eb 3a                	jmp    3b4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 37a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 37d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 380:	01 d0                	add    %edx,%eax
 382:	89 c2                	mov    %eax,%edx
 384:	8b 45 08             	mov    0x8(%ebp),%eax
 387:	01 d0                	add    %edx,%eax
 389:	8a 10                	mov    (%eax),%dl
 38b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	01 c8                	add    %ecx,%eax
 393:	8a 00                	mov    (%eax),%al
 395:	38 c2                	cmp    %al,%dl
 397:	75 16                	jne    3af <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 399:	8b 45 f8             	mov    -0x8(%ebp),%eax
 39c:	8d 50 01             	lea    0x1(%eax),%edx
 39f:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a2:	01 d0                	add    %edx,%eax
 3a4:	8a 00                	mov    (%eax),%al
 3a6:	84 c0                	test   %al,%al
 3a8:	75 07                	jne    3b1 <strstr+0x77>
                    {
                        return i;
 3aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ad:	eb 2d                	jmp    3dc <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3af:	eb 11                	jmp    3c2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3b1:	ff 45 f8             	incl   -0x8(%ebp)
 3b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ba:	01 d0                	add    %edx,%eax
 3bc:	8a 00                	mov    (%eax),%al
 3be:	84 c0                	test   %al,%al
 3c0:	75 b8                	jne    37a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3c2:	ff 45 fc             	incl   -0x4(%ebp)
 3c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
 3cb:	01 d0                	add    %edx,%eax
 3cd:	8a 00                	mov    (%eax),%al
 3cf:	84 c0                	test   %al,%al
 3d1:	0f 85 72 ff ff ff    	jne    349 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 3d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 3dc:	c9                   	leave  
 3dd:	c3                   	ret    

000003de <strtok>:

char *
strtok(char *s, const char *delim)
{
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	53                   	push   %ebx
 3e2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 3e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3e9:	75 08                	jne    3f3 <strtok+0x15>
  s = lasts;
 3eb:	a1 84 12 00 00       	mov    0x1284,%eax
 3f0:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 3f3:	8b 45 08             	mov    0x8(%ebp),%eax
 3f6:	8d 50 01             	lea    0x1(%eax),%edx
 3f9:	89 55 08             	mov    %edx,0x8(%ebp)
 3fc:	8a 00                	mov    (%eax),%al
 3fe:	0f be d8             	movsbl %al,%ebx
 401:	85 db                	test   %ebx,%ebx
 403:	75 07                	jne    40c <strtok+0x2e>
      return 0;
 405:	b8 00 00 00 00       	mov    $0x0,%eax
 40a:	eb 58                	jmp    464 <strtok+0x86>
    } while (strchr(delim, ch));
 40c:	88 d8                	mov    %bl,%al
 40e:	0f be c0             	movsbl %al,%eax
 411:	89 44 24 04          	mov    %eax,0x4(%esp)
 415:	8b 45 0c             	mov    0xc(%ebp),%eax
 418:	89 04 24             	mov    %eax,(%esp)
 41b:	e8 7e fe ff ff       	call   29e <strchr>
 420:	85 c0                	test   %eax,%eax
 422:	75 cf                	jne    3f3 <strtok+0x15>
    --s;
 424:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 427:	8b 45 0c             	mov    0xc(%ebp),%eax
 42a:	89 44 24 04          	mov    %eax,0x4(%esp)
 42e:	8b 45 08             	mov    0x8(%ebp),%eax
 431:	89 04 24             	mov    %eax,(%esp)
 434:	e8 31 00 00 00       	call   46a <strcspn>
 439:	89 c2                	mov    %eax,%edx
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	01 d0                	add    %edx,%eax
 440:	a3 84 12 00 00       	mov    %eax,0x1284
    if (*lasts != 0)
 445:	a1 84 12 00 00       	mov    0x1284,%eax
 44a:	8a 00                	mov    (%eax),%al
 44c:	84 c0                	test   %al,%al
 44e:	74 11                	je     461 <strtok+0x83>
  *lasts++ = 0;
 450:	a1 84 12 00 00       	mov    0x1284,%eax
 455:	8d 50 01             	lea    0x1(%eax),%edx
 458:	89 15 84 12 00 00    	mov    %edx,0x1284
 45e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 461:	8b 45 08             	mov    0x8(%ebp),%eax
}
 464:	83 c4 14             	add    $0x14,%esp
 467:	5b                   	pop    %ebx
 468:	5d                   	pop    %ebp
 469:	c3                   	ret    

0000046a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 46a:	55                   	push   %ebp
 46b:	89 e5                	mov    %esp,%ebp
 46d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 470:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 477:	eb 26                	jmp    49f <strcspn+0x35>
        if(strchr(s2,*s1))
 479:	8b 45 08             	mov    0x8(%ebp),%eax
 47c:	8a 00                	mov    (%eax),%al
 47e:	0f be c0             	movsbl %al,%eax
 481:	89 44 24 04          	mov    %eax,0x4(%esp)
 485:	8b 45 0c             	mov    0xc(%ebp),%eax
 488:	89 04 24             	mov    %eax,(%esp)
 48b:	e8 0e fe ff ff       	call   29e <strchr>
 490:	85 c0                	test   %eax,%eax
 492:	74 05                	je     499 <strcspn+0x2f>
            return ret;
 494:	8b 45 fc             	mov    -0x4(%ebp),%eax
 497:	eb 12                	jmp    4ab <strcspn+0x41>
        else
            s1++,ret++;
 499:	ff 45 08             	incl   0x8(%ebp)
 49c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 49f:	8b 45 08             	mov    0x8(%ebp),%eax
 4a2:	8a 00                	mov    (%eax),%al
 4a4:	84 c0                	test   %al,%al
 4a6:	75 d1                	jne    479 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4ab:	c9                   	leave  
 4ac:	c3                   	ret    

000004ad <isspace>:

int
isspace(unsigned char c)
{
 4ad:	55                   	push   %ebp
 4ae:	89 e5                	mov    %esp,%ebp
 4b0:	83 ec 04             	sub    $0x4,%esp
 4b3:	8b 45 08             	mov    0x8(%ebp),%eax
 4b6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4b9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4bd:	74 1e                	je     4dd <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4bf:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4c3:	74 18                	je     4dd <isspace+0x30>
 4c5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4c9:	74 12                	je     4dd <isspace+0x30>
 4cb:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 4cf:	74 0c                	je     4dd <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 4d1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 4d5:	74 06                	je     4dd <isspace+0x30>
 4d7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 4db:	75 07                	jne    4e4 <isspace+0x37>
 4dd:	b8 01 00 00 00       	mov    $0x1,%eax
 4e2:	eb 05                	jmp    4e9 <isspace+0x3c>
 4e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 4e9:	c9                   	leave  
 4ea:	c3                   	ret    

000004eb <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 4eb:	55                   	push   %ebp
 4ec:	89 e5                	mov    %esp,%ebp
 4ee:	57                   	push   %edi
 4ef:	56                   	push   %esi
 4f0:	53                   	push   %ebx
 4f1:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 4f4:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 4f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 500:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 503:	eb 01                	jmp    506 <strtoul+0x1b>
  p += 1;
 505:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 506:	8a 03                	mov    (%ebx),%al
 508:	0f b6 c0             	movzbl %al,%eax
 50b:	89 04 24             	mov    %eax,(%esp)
 50e:	e8 9a ff ff ff       	call   4ad <isspace>
 513:	85 c0                	test   %eax,%eax
 515:	75 ee                	jne    505 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 517:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 51b:	75 30                	jne    54d <strtoul+0x62>
    {
  if (*p == '0') {
 51d:	8a 03                	mov    (%ebx),%al
 51f:	3c 30                	cmp    $0x30,%al
 521:	75 21                	jne    544 <strtoul+0x59>
      p += 1;
 523:	43                   	inc    %ebx
      if (*p == 'x') {
 524:	8a 03                	mov    (%ebx),%al
 526:	3c 78                	cmp    $0x78,%al
 528:	75 0a                	jne    534 <strtoul+0x49>
    p += 1;
 52a:	43                   	inc    %ebx
    base = 16;
 52b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 532:	eb 31                	jmp    565 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 534:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 53b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 542:	eb 21                	jmp    565 <strtoul+0x7a>
      }
  }
  else base = 10;
 544:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 54b:	eb 18                	jmp    565 <strtoul+0x7a>
    } else if (base == 16) {
 54d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 551:	75 12                	jne    565 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 553:	8a 03                	mov    (%ebx),%al
 555:	3c 30                	cmp    $0x30,%al
 557:	75 0c                	jne    565 <strtoul+0x7a>
 559:	8d 43 01             	lea    0x1(%ebx),%eax
 55c:	8a 00                	mov    (%eax),%al
 55e:	3c 78                	cmp    $0x78,%al
 560:	75 03                	jne    565 <strtoul+0x7a>
      p += 2;
 562:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 565:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 569:	75 29                	jne    594 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 56b:	8a 03                	mov    (%ebx),%al
 56d:	0f be c0             	movsbl %al,%eax
 570:	83 e8 30             	sub    $0x30,%eax
 573:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 575:	83 fe 07             	cmp    $0x7,%esi
 578:	76 06                	jbe    580 <strtoul+0x95>
    break;
 57a:	90                   	nop
 57b:	e9 b6 00 00 00       	jmp    636 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 580:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 587:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 58a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 591:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 592:	eb d7                	jmp    56b <strtoul+0x80>
    } else if (base == 10) {
 594:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 598:	75 2b                	jne    5c5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 59a:	8a 03                	mov    (%ebx),%al
 59c:	0f be c0             	movsbl %al,%eax
 59f:	83 e8 30             	sub    $0x30,%eax
 5a2:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5a4:	83 fe 09             	cmp    $0x9,%esi
 5a7:	76 06                	jbe    5af <strtoul+0xc4>
    break;
 5a9:	90                   	nop
 5aa:	e9 87 00 00 00       	jmp    636 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5af:	89 f8                	mov    %edi,%eax
 5b1:	c1 e0 02             	shl    $0x2,%eax
 5b4:	01 f8                	add    %edi,%eax
 5b6:	01 c0                	add    %eax,%eax
 5b8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5bb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5c2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5c3:	eb d5                	jmp    59a <strtoul+0xaf>
    } else if (base == 16) {
 5c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5c9:	75 35                	jne    600 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5cb:	8a 03                	mov    (%ebx),%al
 5cd:	0f be c0             	movsbl %al,%eax
 5d0:	83 e8 30             	sub    $0x30,%eax
 5d3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5d5:	83 fe 4a             	cmp    $0x4a,%esi
 5d8:	76 02                	jbe    5dc <strtoul+0xf1>
    break;
 5da:	eb 22                	jmp    5fe <strtoul+0x113>
      }
      digit = cvtIn[digit];
 5dc:	8a 86 20 12 00 00    	mov    0x1220(%esi),%al
 5e2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 5e5:	83 fe 0f             	cmp    $0xf,%esi
 5e8:	76 02                	jbe    5ec <strtoul+0x101>
    break;
 5ea:	eb 12                	jmp    5fe <strtoul+0x113>
      }
      result = (result << 4) + digit;
 5ec:	89 f8                	mov    %edi,%eax
 5ee:	c1 e0 04             	shl    $0x4,%eax
 5f1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 5fb:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 5fc:	eb cd                	jmp    5cb <strtoul+0xe0>
 5fe:	eb 36                	jmp    636 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 600:	8a 03                	mov    (%ebx),%al
 602:	0f be c0             	movsbl %al,%eax
 605:	83 e8 30             	sub    $0x30,%eax
 608:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 60a:	83 fe 4a             	cmp    $0x4a,%esi
 60d:	76 02                	jbe    611 <strtoul+0x126>
    break;
 60f:	eb 25                	jmp    636 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 611:	8a 86 20 12 00 00    	mov    0x1220(%esi),%al
 617:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 61a:	8b 45 10             	mov    0x10(%ebp),%eax
 61d:	39 f0                	cmp    %esi,%eax
 61f:	77 02                	ja     623 <strtoul+0x138>
    break;
 621:	eb 13                	jmp    636 <strtoul+0x14b>
      }
      result = result*base + digit;
 623:	8b 45 10             	mov    0x10(%ebp),%eax
 626:	0f af c7             	imul   %edi,%eax
 629:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 62c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 633:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 634:	eb ca                	jmp    600 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 636:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 63a:	75 03                	jne    63f <strtoul+0x154>
  p = string;
 63c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 63f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 643:	74 05                	je     64a <strtoul+0x15f>
  *endPtr = p;
 645:	8b 45 0c             	mov    0xc(%ebp),%eax
 648:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 64a:	89 f8                	mov    %edi,%eax
}
 64c:	83 c4 14             	add    $0x14,%esp
 64f:	5b                   	pop    %ebx
 650:	5e                   	pop    %esi
 651:	5f                   	pop    %edi
 652:	5d                   	pop    %ebp
 653:	c3                   	ret    

00000654 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 654:	55                   	push   %ebp
 655:	89 e5                	mov    %esp,%ebp
 657:	53                   	push   %ebx
 658:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 65b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 65e:	eb 01                	jmp    661 <strtol+0xd>
      p += 1;
 660:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 661:	8a 03                	mov    (%ebx),%al
 663:	0f b6 c0             	movzbl %al,%eax
 666:	89 04 24             	mov    %eax,(%esp)
 669:	e8 3f fe ff ff       	call   4ad <isspace>
 66e:	85 c0                	test   %eax,%eax
 670:	75 ee                	jne    660 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 672:	8a 03                	mov    (%ebx),%al
 674:	3c 2d                	cmp    $0x2d,%al
 676:	75 1e                	jne    696 <strtol+0x42>
  p += 1;
 678:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 679:	8b 45 10             	mov    0x10(%ebp),%eax
 67c:	89 44 24 08          	mov    %eax,0x8(%esp)
 680:	8b 45 0c             	mov    0xc(%ebp),%eax
 683:	89 44 24 04          	mov    %eax,0x4(%esp)
 687:	89 1c 24             	mov    %ebx,(%esp)
 68a:	e8 5c fe ff ff       	call   4eb <strtoul>
 68f:	f7 d8                	neg    %eax
 691:	89 45 f8             	mov    %eax,-0x8(%ebp)
 694:	eb 20                	jmp    6b6 <strtol+0x62>
    } else {
  if (*p == '+') {
 696:	8a 03                	mov    (%ebx),%al
 698:	3c 2b                	cmp    $0x2b,%al
 69a:	75 01                	jne    69d <strtol+0x49>
      p += 1;
 69c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 69d:	8b 45 10             	mov    0x10(%ebp),%eax
 6a0:	89 44 24 08          	mov    %eax,0x8(%esp)
 6a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ab:	89 1c 24             	mov    %ebx,(%esp)
 6ae:	e8 38 fe ff ff       	call   4eb <strtoul>
 6b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6ba:	75 17                	jne    6d3 <strtol+0x7f>
 6bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6c0:	74 11                	je     6d3 <strtol+0x7f>
 6c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6c5:	8b 00                	mov    (%eax),%eax
 6c7:	39 d8                	cmp    %ebx,%eax
 6c9:	75 08                	jne    6d3 <strtol+0x7f>
  *endPtr = string;
 6cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ce:	8b 55 08             	mov    0x8(%ebp),%edx
 6d1:	89 10                	mov    %edx,(%eax)
    }
    return result;
 6d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 6d6:	83 c4 1c             	add    $0x1c,%esp
 6d9:	5b                   	pop    %ebx
 6da:	5d                   	pop    %ebp
 6db:	c3                   	ret    

000006dc <gets>:

char*
gets(char *buf, int max)
{
 6dc:	55                   	push   %ebp
 6dd:	89 e5                	mov    %esp,%ebp
 6df:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6e9:	eb 49                	jmp    734 <gets+0x58>
    cc = read(0, &c, 1);
 6eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 6f2:	00 
 6f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 701:	e8 3e 01 00 00       	call   844 <read>
 706:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70d:	7f 02                	jg     711 <gets+0x35>
      break;
 70f:	eb 2c                	jmp    73d <gets+0x61>
    buf[i++] = c;
 711:	8b 45 f4             	mov    -0xc(%ebp),%eax
 714:	8d 50 01             	lea    0x1(%eax),%edx
 717:	89 55 f4             	mov    %edx,-0xc(%ebp)
 71a:	89 c2                	mov    %eax,%edx
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	01 c2                	add    %eax,%edx
 721:	8a 45 ef             	mov    -0x11(%ebp),%al
 724:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 726:	8a 45 ef             	mov    -0x11(%ebp),%al
 729:	3c 0a                	cmp    $0xa,%al
 72b:	74 10                	je     73d <gets+0x61>
 72d:	8a 45 ef             	mov    -0x11(%ebp),%al
 730:	3c 0d                	cmp    $0xd,%al
 732:	74 09                	je     73d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 734:	8b 45 f4             	mov    -0xc(%ebp),%eax
 737:	40                   	inc    %eax
 738:	3b 45 0c             	cmp    0xc(%ebp),%eax
 73b:	7c ae                	jl     6eb <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 73d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 740:	8b 45 08             	mov    0x8(%ebp),%eax
 743:	01 d0                	add    %edx,%eax
 745:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 748:	8b 45 08             	mov    0x8(%ebp),%eax
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    

0000074d <stat>:

int
stat(char *n, struct stat *st)
{
 74d:	55                   	push   %ebp
 74e:	89 e5                	mov    %esp,%ebp
 750:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 753:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 75a:	00 
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	89 04 24             	mov    %eax,(%esp)
 761:	e8 06 01 00 00       	call   86c <open>
 766:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 769:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 76d:	79 07                	jns    776 <stat+0x29>
    return -1;
 76f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 774:	eb 23                	jmp    799 <stat+0x4c>
  r = fstat(fd, st);
 776:	8b 45 0c             	mov    0xc(%ebp),%eax
 779:	89 44 24 04          	mov    %eax,0x4(%esp)
 77d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 780:	89 04 24             	mov    %eax,(%esp)
 783:	e8 fc 00 00 00       	call   884 <fstat>
 788:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 78b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78e:	89 04 24             	mov    %eax,(%esp)
 791:	e8 be 00 00 00       	call   854 <close>
  return r;
 796:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 799:	c9                   	leave  
 79a:	c3                   	ret    

0000079b <atoi>:

int
atoi(const char *s)
{
 79b:	55                   	push   %ebp
 79c:	89 e5                	mov    %esp,%ebp
 79e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7a8:	eb 24                	jmp    7ce <atoi+0x33>
    n = n*10 + *s++ - '0';
 7aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7ad:	89 d0                	mov    %edx,%eax
 7af:	c1 e0 02             	shl    $0x2,%eax
 7b2:	01 d0                	add    %edx,%eax
 7b4:	01 c0                	add    %eax,%eax
 7b6:	89 c1                	mov    %eax,%ecx
 7b8:	8b 45 08             	mov    0x8(%ebp),%eax
 7bb:	8d 50 01             	lea    0x1(%eax),%edx
 7be:	89 55 08             	mov    %edx,0x8(%ebp)
 7c1:	8a 00                	mov    (%eax),%al
 7c3:	0f be c0             	movsbl %al,%eax
 7c6:	01 c8                	add    %ecx,%eax
 7c8:	83 e8 30             	sub    $0x30,%eax
 7cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7ce:	8b 45 08             	mov    0x8(%ebp),%eax
 7d1:	8a 00                	mov    (%eax),%al
 7d3:	3c 2f                	cmp    $0x2f,%al
 7d5:	7e 09                	jle    7e0 <atoi+0x45>
 7d7:	8b 45 08             	mov    0x8(%ebp),%eax
 7da:	8a 00                	mov    (%eax),%al
 7dc:	3c 39                	cmp    $0x39,%al
 7de:	7e ca                	jle    7aa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 7e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7e3:	c9                   	leave  
 7e4:	c3                   	ret    

000007e5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7e5:	55                   	push   %ebp
 7e6:	89 e5                	mov    %esp,%ebp
 7e8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 7eb:	8b 45 08             	mov    0x8(%ebp),%eax
 7ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 7f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7f7:	eb 16                	jmp    80f <memmove+0x2a>
    *dst++ = *src++;
 7f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fc:	8d 50 01             	lea    0x1(%eax),%edx
 7ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
 802:	8b 55 f8             	mov    -0x8(%ebp),%edx
 805:	8d 4a 01             	lea    0x1(%edx),%ecx
 808:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 80b:	8a 12                	mov    (%edx),%dl
 80d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 80f:	8b 45 10             	mov    0x10(%ebp),%eax
 812:	8d 50 ff             	lea    -0x1(%eax),%edx
 815:	89 55 10             	mov    %edx,0x10(%ebp)
 818:	85 c0                	test   %eax,%eax
 81a:	7f dd                	jg     7f9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 81c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 81f:	c9                   	leave  
 820:	c3                   	ret    
 821:	90                   	nop
 822:	90                   	nop
 823:	90                   	nop

00000824 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 824:	b8 01 00 00 00       	mov    $0x1,%eax
 829:	cd 40                	int    $0x40
 82b:	c3                   	ret    

0000082c <exit>:
SYSCALL(exit)
 82c:	b8 02 00 00 00       	mov    $0x2,%eax
 831:	cd 40                	int    $0x40
 833:	c3                   	ret    

00000834 <wait>:
SYSCALL(wait)
 834:	b8 03 00 00 00       	mov    $0x3,%eax
 839:	cd 40                	int    $0x40
 83b:	c3                   	ret    

0000083c <pipe>:
SYSCALL(pipe)
 83c:	b8 04 00 00 00       	mov    $0x4,%eax
 841:	cd 40                	int    $0x40
 843:	c3                   	ret    

00000844 <read>:
SYSCALL(read)
 844:	b8 05 00 00 00       	mov    $0x5,%eax
 849:	cd 40                	int    $0x40
 84b:	c3                   	ret    

0000084c <write>:
SYSCALL(write)
 84c:	b8 10 00 00 00       	mov    $0x10,%eax
 851:	cd 40                	int    $0x40
 853:	c3                   	ret    

00000854 <close>:
SYSCALL(close)
 854:	b8 15 00 00 00       	mov    $0x15,%eax
 859:	cd 40                	int    $0x40
 85b:	c3                   	ret    

0000085c <kill>:
SYSCALL(kill)
 85c:	b8 06 00 00 00       	mov    $0x6,%eax
 861:	cd 40                	int    $0x40
 863:	c3                   	ret    

00000864 <exec>:
SYSCALL(exec)
 864:	b8 07 00 00 00       	mov    $0x7,%eax
 869:	cd 40                	int    $0x40
 86b:	c3                   	ret    

0000086c <open>:
SYSCALL(open)
 86c:	b8 0f 00 00 00       	mov    $0xf,%eax
 871:	cd 40                	int    $0x40
 873:	c3                   	ret    

00000874 <mknod>:
SYSCALL(mknod)
 874:	b8 11 00 00 00       	mov    $0x11,%eax
 879:	cd 40                	int    $0x40
 87b:	c3                   	ret    

0000087c <unlink>:
SYSCALL(unlink)
 87c:	b8 12 00 00 00       	mov    $0x12,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <fstat>:
SYSCALL(fstat)
 884:	b8 08 00 00 00       	mov    $0x8,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <link>:
SYSCALL(link)
 88c:	b8 13 00 00 00       	mov    $0x13,%eax
 891:	cd 40                	int    $0x40
 893:	c3                   	ret    

00000894 <mkdir>:
SYSCALL(mkdir)
 894:	b8 14 00 00 00       	mov    $0x14,%eax
 899:	cd 40                	int    $0x40
 89b:	c3                   	ret    

0000089c <chdir>:
SYSCALL(chdir)
 89c:	b8 09 00 00 00       	mov    $0x9,%eax
 8a1:	cd 40                	int    $0x40
 8a3:	c3                   	ret    

000008a4 <dup>:
SYSCALL(dup)
 8a4:	b8 0a 00 00 00       	mov    $0xa,%eax
 8a9:	cd 40                	int    $0x40
 8ab:	c3                   	ret    

000008ac <getpid>:
SYSCALL(getpid)
 8ac:	b8 0b 00 00 00       	mov    $0xb,%eax
 8b1:	cd 40                	int    $0x40
 8b3:	c3                   	ret    

000008b4 <sbrk>:
SYSCALL(sbrk)
 8b4:	b8 0c 00 00 00       	mov    $0xc,%eax
 8b9:	cd 40                	int    $0x40
 8bb:	c3                   	ret    

000008bc <sleep>:
SYSCALL(sleep)
 8bc:	b8 0d 00 00 00       	mov    $0xd,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <uptime>:
SYSCALL(uptime)
 8c4:	b8 0e 00 00 00       	mov    $0xe,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <getname>:
SYSCALL(getname)
 8cc:	b8 16 00 00 00       	mov    $0x16,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <setname>:
SYSCALL(setname)
 8d4:	b8 17 00 00 00       	mov    $0x17,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <getmaxproc>:
SYSCALL(getmaxproc)
 8dc:	b8 18 00 00 00       	mov    $0x18,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <setmaxproc>:
SYSCALL(setmaxproc)
 8e4:	b8 19 00 00 00       	mov    $0x19,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <getmaxmem>:
SYSCALL(getmaxmem)
 8ec:	b8 1a 00 00 00       	mov    $0x1a,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <setmaxmem>:
SYSCALL(setmaxmem)
 8f4:	b8 1b 00 00 00       	mov    $0x1b,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <getmaxdisk>:
SYSCALL(getmaxdisk)
 8fc:	b8 1c 00 00 00       	mov    $0x1c,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <setmaxdisk>:
SYSCALL(setmaxdisk)
 904:	b8 1d 00 00 00       	mov    $0x1d,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <getusedmem>:
SYSCALL(getusedmem)
 90c:	b8 1e 00 00 00       	mov    $0x1e,%eax
 911:	cd 40                	int    $0x40
 913:	c3                   	ret    

00000914 <setusedmem>:
SYSCALL(setusedmem)
 914:	b8 1f 00 00 00       	mov    $0x1f,%eax
 919:	cd 40                	int    $0x40
 91b:	c3                   	ret    

0000091c <getuseddisk>:
SYSCALL(getuseddisk)
 91c:	b8 20 00 00 00       	mov    $0x20,%eax
 921:	cd 40                	int    $0x40
 923:	c3                   	ret    

00000924 <setuseddisk>:
SYSCALL(setuseddisk)
 924:	b8 21 00 00 00       	mov    $0x21,%eax
 929:	cd 40                	int    $0x40
 92b:	c3                   	ret    

0000092c <setvc>:
SYSCALL(setvc)
 92c:	b8 22 00 00 00       	mov    $0x22,%eax
 931:	cd 40                	int    $0x40
 933:	c3                   	ret    

00000934 <setactivefs>:
SYSCALL(setactivefs)
 934:	b8 24 00 00 00       	mov    $0x24,%eax
 939:	cd 40                	int    $0x40
 93b:	c3                   	ret    

0000093c <getactivefs>:
SYSCALL(getactivefs)
 93c:	b8 25 00 00 00       	mov    $0x25,%eax
 941:	cd 40                	int    $0x40
 943:	c3                   	ret    

00000944 <getvcfs>:
SYSCALL(getvcfs)
 944:	b8 23 00 00 00       	mov    $0x23,%eax
 949:	cd 40                	int    $0x40
 94b:	c3                   	ret    

0000094c <getcwd>:
SYSCALL(getcwd)
 94c:	b8 26 00 00 00       	mov    $0x26,%eax
 951:	cd 40                	int    $0x40
 953:	c3                   	ret    

00000954 <tostring>:
SYSCALL(tostring)
 954:	b8 27 00 00 00       	mov    $0x27,%eax
 959:	cd 40                	int    $0x40
 95b:	c3                   	ret    

0000095c <getactivefsindex>:
SYSCALL(getactivefsindex)
 95c:	b8 28 00 00 00       	mov    $0x28,%eax
 961:	cd 40                	int    $0x40
 963:	c3                   	ret    

00000964 <setatroot>:
SYSCALL(setatroot)
 964:	b8 2a 00 00 00       	mov    $0x2a,%eax
 969:	cd 40                	int    $0x40
 96b:	c3                   	ret    

0000096c <getatroot>:
SYSCALL(getatroot)
 96c:	b8 29 00 00 00       	mov    $0x29,%eax
 971:	cd 40                	int    $0x40
 973:	c3                   	ret    

00000974 <getpath>:
SYSCALL(getpath)
 974:	b8 2b 00 00 00       	mov    $0x2b,%eax
 979:	cd 40                	int    $0x40
 97b:	c3                   	ret    

0000097c <setpath>:
SYSCALL(setpath)
 97c:	b8 2c 00 00 00       	mov    $0x2c,%eax
 981:	cd 40                	int    $0x40
 983:	c3                   	ret    

00000984 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 984:	55                   	push   %ebp
 985:	89 e5                	mov    %esp,%ebp
 987:	83 ec 18             	sub    $0x18,%esp
 98a:	8b 45 0c             	mov    0xc(%ebp),%eax
 98d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 990:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 997:	00 
 998:	8d 45 f4             	lea    -0xc(%ebp),%eax
 99b:	89 44 24 04          	mov    %eax,0x4(%esp)
 99f:	8b 45 08             	mov    0x8(%ebp),%eax
 9a2:	89 04 24             	mov    %eax,(%esp)
 9a5:	e8 a2 fe ff ff       	call   84c <write>
}
 9aa:	c9                   	leave  
 9ab:	c3                   	ret    

000009ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 9ac:	55                   	push   %ebp
 9ad:	89 e5                	mov    %esp,%ebp
 9af:	56                   	push   %esi
 9b0:	53                   	push   %ebx
 9b1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 9b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 9bb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 9bf:	74 17                	je     9d8 <printint+0x2c>
 9c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 9c5:	79 11                	jns    9d8 <printint+0x2c>
    neg = 1;
 9c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 9ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 9d1:	f7 d8                	neg    %eax
 9d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9d6:	eb 06                	jmp    9de <printint+0x32>
  } else {
    x = xx;
 9d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 9db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 9de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 9e5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 9e8:	8d 41 01             	lea    0x1(%ecx),%eax
 9eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ee:	8b 5d 10             	mov    0x10(%ebp),%ebx
 9f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9f4:	ba 00 00 00 00       	mov    $0x0,%edx
 9f9:	f7 f3                	div    %ebx
 9fb:	89 d0                	mov    %edx,%eax
 9fd:	8a 80 6c 12 00 00    	mov    0x126c(%eax),%al
 a03:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 a07:	8b 75 10             	mov    0x10(%ebp),%esi
 a0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a0d:	ba 00 00 00 00       	mov    $0x0,%edx
 a12:	f7 f6                	div    %esi
 a14:	89 45 ec             	mov    %eax,-0x14(%ebp)
 a17:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a1b:	75 c8                	jne    9e5 <printint+0x39>
  if(neg)
 a1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a21:	74 10                	je     a33 <printint+0x87>
    buf[i++] = '-';
 a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a26:	8d 50 01             	lea    0x1(%eax),%edx
 a29:	89 55 f4             	mov    %edx,-0xc(%ebp)
 a2c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 a31:	eb 1e                	jmp    a51 <printint+0xa5>
 a33:	eb 1c                	jmp    a51 <printint+0xa5>
    putc(fd, buf[i]);
 a35:	8d 55 dc             	lea    -0x24(%ebp),%edx
 a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3b:	01 d0                	add    %edx,%eax
 a3d:	8a 00                	mov    (%eax),%al
 a3f:	0f be c0             	movsbl %al,%eax
 a42:	89 44 24 04          	mov    %eax,0x4(%esp)
 a46:	8b 45 08             	mov    0x8(%ebp),%eax
 a49:	89 04 24             	mov    %eax,(%esp)
 a4c:	e8 33 ff ff ff       	call   984 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 a51:	ff 4d f4             	decl   -0xc(%ebp)
 a54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a58:	79 db                	jns    a35 <printint+0x89>
    putc(fd, buf[i]);
}
 a5a:	83 c4 30             	add    $0x30,%esp
 a5d:	5b                   	pop    %ebx
 a5e:	5e                   	pop    %esi
 a5f:	5d                   	pop    %ebp
 a60:	c3                   	ret    

00000a61 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a61:	55                   	push   %ebp
 a62:	89 e5                	mov    %esp,%ebp
 a64:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a67:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a6e:	8d 45 0c             	lea    0xc(%ebp),%eax
 a71:	83 c0 04             	add    $0x4,%eax
 a74:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a77:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a7e:	e9 77 01 00 00       	jmp    bfa <printf+0x199>
    c = fmt[i] & 0xff;
 a83:	8b 55 0c             	mov    0xc(%ebp),%edx
 a86:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a89:	01 d0                	add    %edx,%eax
 a8b:	8a 00                	mov    (%eax),%al
 a8d:	0f be c0             	movsbl %al,%eax
 a90:	25 ff 00 00 00       	and    $0xff,%eax
 a95:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a98:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a9c:	75 2c                	jne    aca <printf+0x69>
      if(c == '%'){
 a9e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 aa2:	75 0c                	jne    ab0 <printf+0x4f>
        state = '%';
 aa4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 aab:	e9 47 01 00 00       	jmp    bf7 <printf+0x196>
      } else {
        putc(fd, c);
 ab0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ab3:	0f be c0             	movsbl %al,%eax
 ab6:	89 44 24 04          	mov    %eax,0x4(%esp)
 aba:	8b 45 08             	mov    0x8(%ebp),%eax
 abd:	89 04 24             	mov    %eax,(%esp)
 ac0:	e8 bf fe ff ff       	call   984 <putc>
 ac5:	e9 2d 01 00 00       	jmp    bf7 <printf+0x196>
      }
    } else if(state == '%'){
 aca:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 ace:	0f 85 23 01 00 00    	jne    bf7 <printf+0x196>
      if(c == 'd'){
 ad4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 ad8:	75 2d                	jne    b07 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 ada:	8b 45 e8             	mov    -0x18(%ebp),%eax
 add:	8b 00                	mov    (%eax),%eax
 adf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 ae6:	00 
 ae7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 aee:	00 
 aef:	89 44 24 04          	mov    %eax,0x4(%esp)
 af3:	8b 45 08             	mov    0x8(%ebp),%eax
 af6:	89 04 24             	mov    %eax,(%esp)
 af9:	e8 ae fe ff ff       	call   9ac <printint>
        ap++;
 afe:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b02:	e9 e9 00 00 00       	jmp    bf0 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 b07:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 b0b:	74 06                	je     b13 <printf+0xb2>
 b0d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 b11:	75 2d                	jne    b40 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 b13:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b16:	8b 00                	mov    (%eax),%eax
 b18:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 b1f:	00 
 b20:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 b27:	00 
 b28:	89 44 24 04          	mov    %eax,0x4(%esp)
 b2c:	8b 45 08             	mov    0x8(%ebp),%eax
 b2f:	89 04 24             	mov    %eax,(%esp)
 b32:	e8 75 fe ff ff       	call   9ac <printint>
        ap++;
 b37:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b3b:	e9 b0 00 00 00       	jmp    bf0 <printf+0x18f>
      } else if(c == 's'){
 b40:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 b44:	75 42                	jne    b88 <printf+0x127>
        s = (char*)*ap;
 b46:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b49:	8b 00                	mov    (%eax),%eax
 b4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 b4e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 b52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b56:	75 09                	jne    b61 <printf+0x100>
          s = "(null)";
 b58:	c7 45 f4 85 0e 00 00 	movl   $0xe85,-0xc(%ebp)
        while(*s != 0){
 b5f:	eb 1c                	jmp    b7d <printf+0x11c>
 b61:	eb 1a                	jmp    b7d <printf+0x11c>
          putc(fd, *s);
 b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b66:	8a 00                	mov    (%eax),%al
 b68:	0f be c0             	movsbl %al,%eax
 b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
 b6f:	8b 45 08             	mov    0x8(%ebp),%eax
 b72:	89 04 24             	mov    %eax,(%esp)
 b75:	e8 0a fe ff ff       	call   984 <putc>
          s++;
 b7a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b80:	8a 00                	mov    (%eax),%al
 b82:	84 c0                	test   %al,%al
 b84:	75 dd                	jne    b63 <printf+0x102>
 b86:	eb 68                	jmp    bf0 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b88:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b8c:	75 1d                	jne    bab <printf+0x14a>
        putc(fd, *ap);
 b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b91:	8b 00                	mov    (%eax),%eax
 b93:	0f be c0             	movsbl %al,%eax
 b96:	89 44 24 04          	mov    %eax,0x4(%esp)
 b9a:	8b 45 08             	mov    0x8(%ebp),%eax
 b9d:	89 04 24             	mov    %eax,(%esp)
 ba0:	e8 df fd ff ff       	call   984 <putc>
        ap++;
 ba5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ba9:	eb 45                	jmp    bf0 <printf+0x18f>
      } else if(c == '%'){
 bab:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 baf:	75 17                	jne    bc8 <printf+0x167>
        putc(fd, c);
 bb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bb4:	0f be c0             	movsbl %al,%eax
 bb7:	89 44 24 04          	mov    %eax,0x4(%esp)
 bbb:	8b 45 08             	mov    0x8(%ebp),%eax
 bbe:	89 04 24             	mov    %eax,(%esp)
 bc1:	e8 be fd ff ff       	call   984 <putc>
 bc6:	eb 28                	jmp    bf0 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 bc8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 bcf:	00 
 bd0:	8b 45 08             	mov    0x8(%ebp),%eax
 bd3:	89 04 24             	mov    %eax,(%esp)
 bd6:	e8 a9 fd ff ff       	call   984 <putc>
        putc(fd, c);
 bdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bde:	0f be c0             	movsbl %al,%eax
 be1:	89 44 24 04          	mov    %eax,0x4(%esp)
 be5:	8b 45 08             	mov    0x8(%ebp),%eax
 be8:	89 04 24             	mov    %eax,(%esp)
 beb:	e8 94 fd ff ff       	call   984 <putc>
      }
      state = 0;
 bf0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 bf7:	ff 45 f0             	incl   -0x10(%ebp)
 bfa:	8b 55 0c             	mov    0xc(%ebp),%edx
 bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c00:	01 d0                	add    %edx,%eax
 c02:	8a 00                	mov    (%eax),%al
 c04:	84 c0                	test   %al,%al
 c06:	0f 85 77 fe ff ff    	jne    a83 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 c0c:	c9                   	leave  
 c0d:	c3                   	ret    
 c0e:	90                   	nop
 c0f:	90                   	nop

00000c10 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c10:	55                   	push   %ebp
 c11:	89 e5                	mov    %esp,%ebp
 c13:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c16:	8b 45 08             	mov    0x8(%ebp),%eax
 c19:	83 e8 08             	sub    $0x8,%eax
 c1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c1f:	a1 90 12 00 00       	mov    0x1290,%eax
 c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c27:	eb 24                	jmp    c4d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 c29:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2c:	8b 00                	mov    (%eax),%eax
 c2e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c31:	77 12                	ja     c45 <free+0x35>
 c33:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c36:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c39:	77 24                	ja     c5f <free+0x4f>
 c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3e:	8b 00                	mov    (%eax),%eax
 c40:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c43:	77 1a                	ja     c5f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c48:	8b 00                	mov    (%eax),%eax
 c4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 c4d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 c53:	76 d4                	jbe    c29 <free+0x19>
 c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c58:	8b 00                	mov    (%eax),%eax
 c5a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c5d:	76 ca                	jbe    c29 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c62:	8b 40 04             	mov    0x4(%eax),%eax
 c65:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c6f:	01 c2                	add    %eax,%edx
 c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c74:	8b 00                	mov    (%eax),%eax
 c76:	39 c2                	cmp    %eax,%edx
 c78:	75 24                	jne    c9e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7d:	8b 50 04             	mov    0x4(%eax),%edx
 c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c83:	8b 00                	mov    (%eax),%eax
 c85:	8b 40 04             	mov    0x4(%eax),%eax
 c88:	01 c2                	add    %eax,%edx
 c8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c8d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c90:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c93:	8b 00                	mov    (%eax),%eax
 c95:	8b 10                	mov    (%eax),%edx
 c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c9a:	89 10                	mov    %edx,(%eax)
 c9c:	eb 0a                	jmp    ca8 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ca1:	8b 10                	mov    (%eax),%edx
 ca3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ca6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 ca8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cab:	8b 40 04             	mov    0x4(%eax),%eax
 cae:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cb8:	01 d0                	add    %edx,%eax
 cba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 cbd:	75 20                	jne    cdf <free+0xcf>
    p->s.size += bp->s.size;
 cbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cc2:	8b 50 04             	mov    0x4(%eax),%edx
 cc5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cc8:	8b 40 04             	mov    0x4(%eax),%eax
 ccb:	01 c2                	add    %eax,%edx
 ccd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cd0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 cd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 cd6:	8b 10                	mov    (%eax),%edx
 cd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cdb:	89 10                	mov    %edx,(%eax)
 cdd:	eb 08                	jmp    ce7 <free+0xd7>
  } else
    p->s.ptr = bp;
 cdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ce2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ce5:	89 10                	mov    %edx,(%eax)
  freep = p;
 ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 cea:	a3 90 12 00 00       	mov    %eax,0x1290
}
 cef:	c9                   	leave  
 cf0:	c3                   	ret    

00000cf1 <morecore>:

static Header*
morecore(uint nu)
{
 cf1:	55                   	push   %ebp
 cf2:	89 e5                	mov    %esp,%ebp
 cf4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 cf7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 cfe:	77 07                	ja     d07 <morecore+0x16>
    nu = 4096;
 d00:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 d07:	8b 45 08             	mov    0x8(%ebp),%eax
 d0a:	c1 e0 03             	shl    $0x3,%eax
 d0d:	89 04 24             	mov    %eax,(%esp)
 d10:	e8 9f fb ff ff       	call   8b4 <sbrk>
 d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 d18:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 d1c:	75 07                	jne    d25 <morecore+0x34>
    return 0;
 d1e:	b8 00 00 00 00       	mov    $0x0,%eax
 d23:	eb 22                	jmp    d47 <morecore+0x56>
  hp = (Header*)p;
 d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 d2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d2e:	8b 55 08             	mov    0x8(%ebp),%edx
 d31:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d37:	83 c0 08             	add    $0x8,%eax
 d3a:	89 04 24             	mov    %eax,(%esp)
 d3d:	e8 ce fe ff ff       	call   c10 <free>
  return freep;
 d42:	a1 90 12 00 00       	mov    0x1290,%eax
}
 d47:	c9                   	leave  
 d48:	c3                   	ret    

00000d49 <malloc>:

void*
malloc(uint nbytes)
{
 d49:	55                   	push   %ebp
 d4a:	89 e5                	mov    %esp,%ebp
 d4c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d4f:	8b 45 08             	mov    0x8(%ebp),%eax
 d52:	83 c0 07             	add    $0x7,%eax
 d55:	c1 e8 03             	shr    $0x3,%eax
 d58:	40                   	inc    %eax
 d59:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d5c:	a1 90 12 00 00       	mov    0x1290,%eax
 d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d68:	75 23                	jne    d8d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d6a:	c7 45 f0 88 12 00 00 	movl   $0x1288,-0x10(%ebp)
 d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d74:	a3 90 12 00 00       	mov    %eax,0x1290
 d79:	a1 90 12 00 00       	mov    0x1290,%eax
 d7e:	a3 88 12 00 00       	mov    %eax,0x1288
    base.s.size = 0;
 d83:	c7 05 8c 12 00 00 00 	movl   $0x0,0x128c
 d8a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d90:	8b 00                	mov    (%eax),%eax
 d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d98:	8b 40 04             	mov    0x4(%eax),%eax
 d9b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d9e:	72 4d                	jb     ded <malloc+0xa4>
      if(p->s.size == nunits)
 da0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 da3:	8b 40 04             	mov    0x4(%eax),%eax
 da6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 da9:	75 0c                	jne    db7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dae:	8b 10                	mov    (%eax),%edx
 db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 db3:	89 10                	mov    %edx,(%eax)
 db5:	eb 26                	jmp    ddd <malloc+0x94>
      else {
        p->s.size -= nunits;
 db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dba:	8b 40 04             	mov    0x4(%eax),%eax
 dbd:	2b 45 ec             	sub    -0x14(%ebp),%eax
 dc0:	89 c2                	mov    %eax,%edx
 dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dcb:	8b 40 04             	mov    0x4(%eax),%eax
 dce:	c1 e0 03             	shl    $0x3,%eax
 dd1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 dd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 dda:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 de0:	a3 90 12 00 00       	mov    %eax,0x1290
      return (void*)(p + 1);
 de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 de8:	83 c0 08             	add    $0x8,%eax
 deb:	eb 38                	jmp    e25 <malloc+0xdc>
    }
    if(p == freep)
 ded:	a1 90 12 00 00       	mov    0x1290,%eax
 df2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 df5:	75 1b                	jne    e12 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 df7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 dfa:	89 04 24             	mov    %eax,(%esp)
 dfd:	e8 ef fe ff ff       	call   cf1 <morecore>
 e02:	89 45 f4             	mov    %eax,-0xc(%ebp)
 e05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 e09:	75 07                	jne    e12 <malloc+0xc9>
        return 0;
 e0b:	b8 00 00 00 00       	mov    $0x0,%eax
 e10:	eb 13                	jmp    e25 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e15:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e1b:	8b 00                	mov    (%eax),%eax
 e1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 e20:	e9 70 ff ff ff       	jmp    d95 <malloc+0x4c>
}
 e25:	c9                   	leave  
 e26:	c3                   	ret    
