
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
   9:	e8 be 07 00 00       	call   7cc <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 46 08 00 00       	call   864 <sleep>
  exit();
  1e:	e8 b1 07 00 00       	call   7d4 <exit>
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

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  7a:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
  7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
  84:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8b:	00 
  8c:	8b 45 08             	mov    0x8(%ebp),%eax
  8f:	89 04 24             	mov    %eax,(%esp)
  92:	e8 7d 07 00 00       	call   814 <open>
  97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  9e:	79 20                	jns    c0 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  a7:	c7 44 24 04 cf 0d 00 	movl   $0xdcf,0x4(%esp)
  ae:	00 
  af:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  b6:	e8 4e 09 00 00       	call   a09 <printf>
      exit();
  bb:	e8 14 07 00 00       	call   7d4 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
  c0:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  c7:	00 
  c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  cb:	89 04 24             	mov    %eax,(%esp)
  ce:	e8 41 07 00 00       	call   814 <open>
  d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  da:	79 20                	jns    fc <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
  dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  df:	89 44 24 08          	mov    %eax,0x8(%esp)
  e3:	c7 44 24 04 ea 0d 00 	movl   $0xdea,0x4(%esp)
  ea:	00 
  eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f2:	e8 12 09 00 00       	call   a09 <printf>
      exit();
  f7:	e8 d8 06 00 00       	call   7d4 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
  fc:	eb 3b                	jmp    139 <copy+0xc2>
  {
      max = used_disk+=count;
  fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
 101:	01 45 10             	add    %eax,0x10(%ebp)
 104:	8b 45 10             	mov    0x10(%ebp),%eax
 107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
 10a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 10d:	3b 45 14             	cmp    0x14(%ebp),%eax
 110:	7e 07                	jle    119 <copy+0xa2>
      {
        return -1;
 112:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 117:	eb 5c                	jmp    175 <copy+0xfe>
      }
      bytes = bytes + count;
 119:	8b 45 e8             	mov    -0x18(%ebp),%eax
 11c:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
 11f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 126:	00 
 127:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 12a:	89 44 24 04          	mov    %eax,0x4(%esp)
 12e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 131:	89 04 24             	mov    %eax,(%esp)
 134:	e8 bb 06 00 00       	call   7f4 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
 139:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 140:	00 
 141:	8d 45 c4             	lea    -0x3c(%ebp),%eax
 144:	89 44 24 04          	mov    %eax,0x4(%esp)
 148:	8b 45 f0             	mov    -0x10(%ebp),%eax
 14b:	89 04 24             	mov    %eax,(%esp)
 14e:	e8 99 06 00 00       	call   7ec <read>
 153:	89 45 e8             	mov    %eax,-0x18(%ebp)
 156:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
 15a:	7f a2                	jg     fe <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
 15c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 15f:	89 04 24             	mov    %eax,(%esp)
 162:	e8 95 06 00 00       	call   7fc <close>
  close(fd2);
 167:	8b 45 ec             	mov    -0x14(%ebp),%eax
 16a:	89 04 24             	mov    %eax,(%esp)
 16d:	e8 8a 06 00 00       	call   7fc <close>
  return(bytes);
 172:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 175:	c9                   	leave  
 176:	c3                   	ret    

00000177 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 177:	55                   	push   %ebp
 178:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 17a:	eb 06                	jmp    182 <strcmp+0xb>
    p++, q++;
 17c:	ff 45 08             	incl   0x8(%ebp)
 17f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 182:	8b 45 08             	mov    0x8(%ebp),%eax
 185:	8a 00                	mov    (%eax),%al
 187:	84 c0                	test   %al,%al
 189:	74 0e                	je     199 <strcmp+0x22>
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	8a 10                	mov    (%eax),%dl
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	8a 00                	mov    (%eax),%al
 195:	38 c2                	cmp    %al,%dl
 197:	74 e3                	je     17c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
 19c:	8a 00                	mov    (%eax),%al
 19e:	0f b6 d0             	movzbl %al,%edx
 1a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a4:	8a 00                	mov    (%eax),%al
 1a6:	0f b6 c0             	movzbl %al,%eax
 1a9:	29 c2                	sub    %eax,%edx
 1ab:	89 d0                	mov    %edx,%eax
}
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret    

000001af <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 1b2:	eb 09                	jmp    1bd <strncmp+0xe>
    n--, p++, q++;
 1b4:	ff 4d 10             	decl   0x10(%ebp)
 1b7:	ff 45 08             	incl   0x8(%ebp)
 1ba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 1bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1c1:	74 17                	je     1da <strncmp+0x2b>
 1c3:	8b 45 08             	mov    0x8(%ebp),%eax
 1c6:	8a 00                	mov    (%eax),%al
 1c8:	84 c0                	test   %al,%al
 1ca:	74 0e                	je     1da <strncmp+0x2b>
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	8a 10                	mov    (%eax),%dl
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	8a 00                	mov    (%eax),%al
 1d6:	38 c2                	cmp    %al,%dl
 1d8:	74 da                	je     1b4 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 1da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1de:	75 07                	jne    1e7 <strncmp+0x38>
    return 0;
 1e0:	b8 00 00 00 00       	mov    $0x0,%eax
 1e5:	eb 14                	jmp    1fb <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	8a 00                	mov    (%eax),%al
 1ec:	0f b6 d0             	movzbl %al,%edx
 1ef:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f2:	8a 00                	mov    (%eax),%al
 1f4:	0f b6 c0             	movzbl %al,%eax
 1f7:	29 c2                	sub    %eax,%edx
 1f9:	89 d0                	mov    %edx,%eax
}
 1fb:	5d                   	pop    %ebp
 1fc:	c3                   	ret    

000001fd <strlen>:

uint
strlen(const char *s)
{
 1fd:	55                   	push   %ebp
 1fe:	89 e5                	mov    %esp,%ebp
 200:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 203:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 20a:	eb 03                	jmp    20f <strlen+0x12>
 20c:	ff 45 fc             	incl   -0x4(%ebp)
 20f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 212:	8b 45 08             	mov    0x8(%ebp),%eax
 215:	01 d0                	add    %edx,%eax
 217:	8a 00                	mov    (%eax),%al
 219:	84 c0                	test   %al,%al
 21b:	75 ef                	jne    20c <strlen+0xf>
    ;
  return n;
 21d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 220:	c9                   	leave  
 221:	c3                   	ret    

00000222 <memset>:

void*
memset(void *dst, int c, uint n)
{
 222:	55                   	push   %ebp
 223:	89 e5                	mov    %esp,%ebp
 225:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 228:	8b 45 10             	mov    0x10(%ebp),%eax
 22b:	89 44 24 08          	mov    %eax,0x8(%esp)
 22f:	8b 45 0c             	mov    0xc(%ebp),%eax
 232:	89 44 24 04          	mov    %eax,0x4(%esp)
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	89 04 24             	mov    %eax,(%esp)
 23c:	e8 e3 fd ff ff       	call   24 <stosb>
  return dst;
 241:	8b 45 08             	mov    0x8(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <strchr>:

char*
strchr(const char *s, char c)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 04             	sub    $0x4,%esp
 24c:	8b 45 0c             	mov    0xc(%ebp),%eax
 24f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 252:	eb 12                	jmp    266 <strchr+0x20>
    if(*s == c)
 254:	8b 45 08             	mov    0x8(%ebp),%eax
 257:	8a 00                	mov    (%eax),%al
 259:	3a 45 fc             	cmp    -0x4(%ebp),%al
 25c:	75 05                	jne    263 <strchr+0x1d>
      return (char*)s;
 25e:	8b 45 08             	mov    0x8(%ebp),%eax
 261:	eb 11                	jmp    274 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 263:	ff 45 08             	incl   0x8(%ebp)
 266:	8b 45 08             	mov    0x8(%ebp),%eax
 269:	8a 00                	mov    (%eax),%al
 26b:	84 c0                	test   %al,%al
 26d:	75 e5                	jne    254 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 26f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 274:	c9                   	leave  
 275:	c3                   	ret    

00000276 <strcat>:

char *
strcat(char *dest, const char *src)
{
 276:	55                   	push   %ebp
 277:	89 e5                	mov    %esp,%ebp
 279:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 27c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 283:	eb 03                	jmp    288 <strcat+0x12>
 285:	ff 45 fc             	incl   -0x4(%ebp)
 288:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	01 d0                	add    %edx,%eax
 290:	8a 00                	mov    (%eax),%al
 292:	84 c0                	test   %al,%al
 294:	75 ef                	jne    285 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 29d:	eb 1e                	jmp    2bd <strcat+0x47>
        dest[i+j] = src[j];
 29f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a5:	01 d0                	add    %edx,%eax
 2a7:	89 c2                	mov    %eax,%edx
 2a9:	8b 45 08             	mov    0x8(%ebp),%eax
 2ac:	01 c2                	add    %eax,%edx
 2ae:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b4:	01 c8                	add    %ecx,%eax
 2b6:	8a 00                	mov    (%eax),%al
 2b8:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 2ba:	ff 45 f8             	incl   -0x8(%ebp)
 2bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c3:	01 d0                	add    %edx,%eax
 2c5:	8a 00                	mov    (%eax),%al
 2c7:	84 c0                	test   %al,%al
 2c9:	75 d4                	jne    29f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 2cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2d1:	01 d0                	add    %edx,%eax
 2d3:	89 c2                	mov    %eax,%edx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	01 d0                	add    %edx,%eax
 2da:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2e0:	c9                   	leave  
 2e1:	c3                   	ret    

000002e2 <strstr>:

int 
strstr(char* s, char* sub)
{
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2ef:	eb 7c                	jmp    36d <strstr+0x8b>
    {
        if(s[i] == sub[0])
 2f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	01 d0                	add    %edx,%eax
 2f9:	8a 10                	mov    (%eax),%dl
 2fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2fe:	8a 00                	mov    (%eax),%al
 300:	38 c2                	cmp    %al,%dl
 302:	75 66                	jne    36a <strstr+0x88>
        {
            if(strlen(sub) == 1)
 304:	8b 45 0c             	mov    0xc(%ebp),%eax
 307:	89 04 24             	mov    %eax,(%esp)
 30a:	e8 ee fe ff ff       	call   1fd <strlen>
 30f:	83 f8 01             	cmp    $0x1,%eax
 312:	75 05                	jne    319 <strstr+0x37>
            {  
                return i;
 314:	8b 45 fc             	mov    -0x4(%ebp),%eax
 317:	eb 6b                	jmp    384 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 319:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 320:	eb 3a                	jmp    35c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 322:	8b 45 f8             	mov    -0x8(%ebp),%eax
 325:	8b 55 fc             	mov    -0x4(%ebp),%edx
 328:	01 d0                	add    %edx,%eax
 32a:	89 c2                	mov    %eax,%edx
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	01 d0                	add    %edx,%eax
 331:	8a 10                	mov    (%eax),%dl
 333:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 336:	8b 45 0c             	mov    0xc(%ebp),%eax
 339:	01 c8                	add    %ecx,%eax
 33b:	8a 00                	mov    (%eax),%al
 33d:	38 c2                	cmp    %al,%dl
 33f:	75 16                	jne    357 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 341:	8b 45 f8             	mov    -0x8(%ebp),%eax
 344:	8d 50 01             	lea    0x1(%eax),%edx
 347:	8b 45 0c             	mov    0xc(%ebp),%eax
 34a:	01 d0                	add    %edx,%eax
 34c:	8a 00                	mov    (%eax),%al
 34e:	84 c0                	test   %al,%al
 350:	75 07                	jne    359 <strstr+0x77>
                    {
                        return i;
 352:	8b 45 fc             	mov    -0x4(%ebp),%eax
 355:	eb 2d                	jmp    384 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 357:	eb 11                	jmp    36a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 359:	ff 45 f8             	incl   -0x8(%ebp)
 35c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 35f:	8b 45 0c             	mov    0xc(%ebp),%eax
 362:	01 d0                	add    %edx,%eax
 364:	8a 00                	mov    (%eax),%al
 366:	84 c0                	test   %al,%al
 368:	75 b8                	jne    322 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 36a:	ff 45 fc             	incl   -0x4(%ebp)
 36d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 370:	8b 45 08             	mov    0x8(%ebp),%eax
 373:	01 d0                	add    %edx,%eax
 375:	8a 00                	mov    (%eax),%al
 377:	84 c0                	test   %al,%al
 379:	0f 85 72 ff ff ff    	jne    2f1 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 37f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 384:	c9                   	leave  
 385:	c3                   	ret    

00000386 <strtok>:

char *
strtok(char *s, const char *delim)
{
 386:	55                   	push   %ebp
 387:	89 e5                	mov    %esp,%ebp
 389:	53                   	push   %ebx
 38a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 38d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 391:	75 08                	jne    39b <strtok+0x15>
  s = lasts;
 393:	a1 04 12 00 00       	mov    0x1204,%eax
 398:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 39b:	8b 45 08             	mov    0x8(%ebp),%eax
 39e:	8d 50 01             	lea    0x1(%eax),%edx
 3a1:	89 55 08             	mov    %edx,0x8(%ebp)
 3a4:	8a 00                	mov    (%eax),%al
 3a6:	0f be d8             	movsbl %al,%ebx
 3a9:	85 db                	test   %ebx,%ebx
 3ab:	75 07                	jne    3b4 <strtok+0x2e>
      return 0;
 3ad:	b8 00 00 00 00       	mov    $0x0,%eax
 3b2:	eb 58                	jmp    40c <strtok+0x86>
    } while (strchr(delim, ch));
 3b4:	88 d8                	mov    %bl,%al
 3b6:	0f be c0             	movsbl %al,%eax
 3b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c0:	89 04 24             	mov    %eax,(%esp)
 3c3:	e8 7e fe ff ff       	call   246 <strchr>
 3c8:	85 c0                	test   %eax,%eax
 3ca:	75 cf                	jne    39b <strtok+0x15>
    --s;
 3cc:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 3cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	89 04 24             	mov    %eax,(%esp)
 3dc:	e8 31 00 00 00       	call   412 <strcspn>
 3e1:	89 c2                	mov    %eax,%edx
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	01 d0                	add    %edx,%eax
 3e8:	a3 04 12 00 00       	mov    %eax,0x1204
    if (*lasts != 0)
 3ed:	a1 04 12 00 00       	mov    0x1204,%eax
 3f2:	8a 00                	mov    (%eax),%al
 3f4:	84 c0                	test   %al,%al
 3f6:	74 11                	je     409 <strtok+0x83>
  *lasts++ = 0;
 3f8:	a1 04 12 00 00       	mov    0x1204,%eax
 3fd:	8d 50 01             	lea    0x1(%eax),%edx
 400:	89 15 04 12 00 00    	mov    %edx,0x1204
 406:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 409:	8b 45 08             	mov    0x8(%ebp),%eax
}
 40c:	83 c4 14             	add    $0x14,%esp
 40f:	5b                   	pop    %ebx
 410:	5d                   	pop    %ebp
 411:	c3                   	ret    

00000412 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 41f:	eb 26                	jmp    447 <strcspn+0x35>
        if(strchr(s2,*s1))
 421:	8b 45 08             	mov    0x8(%ebp),%eax
 424:	8a 00                	mov    (%eax),%al
 426:	0f be c0             	movsbl %al,%eax
 429:	89 44 24 04          	mov    %eax,0x4(%esp)
 42d:	8b 45 0c             	mov    0xc(%ebp),%eax
 430:	89 04 24             	mov    %eax,(%esp)
 433:	e8 0e fe ff ff       	call   246 <strchr>
 438:	85 c0                	test   %eax,%eax
 43a:	74 05                	je     441 <strcspn+0x2f>
            return ret;
 43c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 43f:	eb 12                	jmp    453 <strcspn+0x41>
        else
            s1++,ret++;
 441:	ff 45 08             	incl   0x8(%ebp)
 444:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	8a 00                	mov    (%eax),%al
 44c:	84 c0                	test   %al,%al
 44e:	75 d1                	jne    421 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 450:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 453:	c9                   	leave  
 454:	c3                   	ret    

00000455 <isspace>:

int
isspace(unsigned char c)
{
 455:	55                   	push   %ebp
 456:	89 e5                	mov    %esp,%ebp
 458:	83 ec 04             	sub    $0x4,%esp
 45b:	8b 45 08             	mov    0x8(%ebp),%eax
 45e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 461:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 465:	74 1e                	je     485 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 467:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 46b:	74 18                	je     485 <isspace+0x30>
 46d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 471:	74 12                	je     485 <isspace+0x30>
 473:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 477:	74 0c                	je     485 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 479:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 47d:	74 06                	je     485 <isspace+0x30>
 47f:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 483:	75 07                	jne    48c <isspace+0x37>
 485:	b8 01 00 00 00       	mov    $0x1,%eax
 48a:	eb 05                	jmp    491 <isspace+0x3c>
 48c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 491:	c9                   	leave  
 492:	c3                   	ret    

00000493 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 493:	55                   	push   %ebp
 494:	89 e5                	mov    %esp,%ebp
 496:	57                   	push   %edi
 497:	56                   	push   %esi
 498:	53                   	push   %ebx
 499:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 49c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 4a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 4a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 4ab:	eb 01                	jmp    4ae <strtoul+0x1b>
  p += 1;
 4ad:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 4ae:	8a 03                	mov    (%ebx),%al
 4b0:	0f b6 c0             	movzbl %al,%eax
 4b3:	89 04 24             	mov    %eax,(%esp)
 4b6:	e8 9a ff ff ff       	call   455 <isspace>
 4bb:	85 c0                	test   %eax,%eax
 4bd:	75 ee                	jne    4ad <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 4bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 4c3:	75 30                	jne    4f5 <strtoul+0x62>
    {
  if (*p == '0') {
 4c5:	8a 03                	mov    (%ebx),%al
 4c7:	3c 30                	cmp    $0x30,%al
 4c9:	75 21                	jne    4ec <strtoul+0x59>
      p += 1;
 4cb:	43                   	inc    %ebx
      if (*p == 'x') {
 4cc:	8a 03                	mov    (%ebx),%al
 4ce:	3c 78                	cmp    $0x78,%al
 4d0:	75 0a                	jne    4dc <strtoul+0x49>
    p += 1;
 4d2:	43                   	inc    %ebx
    base = 16;
 4d3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 4da:	eb 31                	jmp    50d <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 4dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 4e3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 4ea:	eb 21                	jmp    50d <strtoul+0x7a>
      }
  }
  else base = 10;
 4ec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 4f3:	eb 18                	jmp    50d <strtoul+0x7a>
    } else if (base == 16) {
 4f5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4f9:	75 12                	jne    50d <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 4fb:	8a 03                	mov    (%ebx),%al
 4fd:	3c 30                	cmp    $0x30,%al
 4ff:	75 0c                	jne    50d <strtoul+0x7a>
 501:	8d 43 01             	lea    0x1(%ebx),%eax
 504:	8a 00                	mov    (%eax),%al
 506:	3c 78                	cmp    $0x78,%al
 508:	75 03                	jne    50d <strtoul+0x7a>
      p += 2;
 50a:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 50d:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 511:	75 29                	jne    53c <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 513:	8a 03                	mov    (%ebx),%al
 515:	0f be c0             	movsbl %al,%eax
 518:	83 e8 30             	sub    $0x30,%eax
 51b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 51d:	83 fe 07             	cmp    $0x7,%esi
 520:	76 06                	jbe    528 <strtoul+0x95>
    break;
 522:	90                   	nop
 523:	e9 b6 00 00 00       	jmp    5de <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 528:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 52f:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 532:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 539:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 53a:	eb d7                	jmp    513 <strtoul+0x80>
    } else if (base == 10) {
 53c:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 540:	75 2b                	jne    56d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 542:	8a 03                	mov    (%ebx),%al
 544:	0f be c0             	movsbl %al,%eax
 547:	83 e8 30             	sub    $0x30,%eax
 54a:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 54c:	83 fe 09             	cmp    $0x9,%esi
 54f:	76 06                	jbe    557 <strtoul+0xc4>
    break;
 551:	90                   	nop
 552:	e9 87 00 00 00       	jmp    5de <strtoul+0x14b>
      }
      result = (10*result) + digit;
 557:	89 f8                	mov    %edi,%eax
 559:	c1 e0 02             	shl    $0x2,%eax
 55c:	01 f8                	add    %edi,%eax
 55e:	01 c0                	add    %eax,%eax
 560:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 563:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 56a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 56b:	eb d5                	jmp    542 <strtoul+0xaf>
    } else if (base == 16) {
 56d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 571:	75 35                	jne    5a8 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 573:	8a 03                	mov    (%ebx),%al
 575:	0f be c0             	movsbl %al,%eax
 578:	83 e8 30             	sub    $0x30,%eax
 57b:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 57d:	83 fe 4a             	cmp    $0x4a,%esi
 580:	76 02                	jbe    584 <strtoul+0xf1>
    break;
 582:	eb 22                	jmp    5a6 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 584:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 58a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 58d:	83 fe 0f             	cmp    $0xf,%esi
 590:	76 02                	jbe    594 <strtoul+0x101>
    break;
 592:	eb 12                	jmp    5a6 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 594:	89 f8                	mov    %edi,%eax
 596:	c1 e0 04             	shl    $0x4,%eax
 599:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 59c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 5a3:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 5a4:	eb cd                	jmp    573 <strtoul+0xe0>
 5a6:	eb 36                	jmp    5de <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 5a8:	8a 03                	mov    (%ebx),%al
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	83 e8 30             	sub    $0x30,%eax
 5b0:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 5b2:	83 fe 4a             	cmp    $0x4a,%esi
 5b5:	76 02                	jbe    5b9 <strtoul+0x126>
    break;
 5b7:	eb 25                	jmp    5de <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 5b9:	8a 86 a0 11 00 00    	mov    0x11a0(%esi),%al
 5bf:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 5c2:	8b 45 10             	mov    0x10(%ebp),%eax
 5c5:	39 f0                	cmp    %esi,%eax
 5c7:	77 02                	ja     5cb <strtoul+0x138>
    break;
 5c9:	eb 13                	jmp    5de <strtoul+0x14b>
      }
      result = result*base + digit;
 5cb:	8b 45 10             	mov    0x10(%ebp),%eax
 5ce:	0f af c7             	imul   %edi,%eax
 5d1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 5db:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 5dc:	eb ca                	jmp    5a8 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 5de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5e2:	75 03                	jne    5e7 <strtoul+0x154>
  p = string;
 5e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 5e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5eb:	74 05                	je     5f2 <strtoul+0x15f>
  *endPtr = p;
 5ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f0:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 5f2:	89 f8                	mov    %edi,%eax
}
 5f4:	83 c4 14             	add    $0x14,%esp
 5f7:	5b                   	pop    %ebx
 5f8:	5e                   	pop    %esi
 5f9:	5f                   	pop    %edi
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    

000005fc <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 5fc:	55                   	push   %ebp
 5fd:	89 e5                	mov    %esp,%ebp
 5ff:	53                   	push   %ebx
 600:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 603:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 606:	eb 01                	jmp    609 <strtol+0xd>
      p += 1;
 608:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 609:	8a 03                	mov    (%ebx),%al
 60b:	0f b6 c0             	movzbl %al,%eax
 60e:	89 04 24             	mov    %eax,(%esp)
 611:	e8 3f fe ff ff       	call   455 <isspace>
 616:	85 c0                	test   %eax,%eax
 618:	75 ee                	jne    608 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 61a:	8a 03                	mov    (%ebx),%al
 61c:	3c 2d                	cmp    $0x2d,%al
 61e:	75 1e                	jne    63e <strtol+0x42>
  p += 1;
 620:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 621:	8b 45 10             	mov    0x10(%ebp),%eax
 624:	89 44 24 08          	mov    %eax,0x8(%esp)
 628:	8b 45 0c             	mov    0xc(%ebp),%eax
 62b:	89 44 24 04          	mov    %eax,0x4(%esp)
 62f:	89 1c 24             	mov    %ebx,(%esp)
 632:	e8 5c fe ff ff       	call   493 <strtoul>
 637:	f7 d8                	neg    %eax
 639:	89 45 f8             	mov    %eax,-0x8(%ebp)
 63c:	eb 20                	jmp    65e <strtol+0x62>
    } else {
  if (*p == '+') {
 63e:	8a 03                	mov    (%ebx),%al
 640:	3c 2b                	cmp    $0x2b,%al
 642:	75 01                	jne    645 <strtol+0x49>
      p += 1;
 644:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 645:	8b 45 10             	mov    0x10(%ebp),%eax
 648:	89 44 24 08          	mov    %eax,0x8(%esp)
 64c:	8b 45 0c             	mov    0xc(%ebp),%eax
 64f:	89 44 24 04          	mov    %eax,0x4(%esp)
 653:	89 1c 24             	mov    %ebx,(%esp)
 656:	e8 38 fe ff ff       	call   493 <strtoul>
 65b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 65e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 662:	75 17                	jne    67b <strtol+0x7f>
 664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 668:	74 11                	je     67b <strtol+0x7f>
 66a:	8b 45 0c             	mov    0xc(%ebp),%eax
 66d:	8b 00                	mov    (%eax),%eax
 66f:	39 d8                	cmp    %ebx,%eax
 671:	75 08                	jne    67b <strtol+0x7f>
  *endPtr = string;
 673:	8b 45 0c             	mov    0xc(%ebp),%eax
 676:	8b 55 08             	mov    0x8(%ebp),%edx
 679:	89 10                	mov    %edx,(%eax)
    }
    return result;
 67b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 67e:	83 c4 1c             	add    $0x1c,%esp
 681:	5b                   	pop    %ebx
 682:	5d                   	pop    %ebp
 683:	c3                   	ret    

00000684 <gets>:

char*
gets(char *buf, int max)
{
 684:	55                   	push   %ebp
 685:	89 e5                	mov    %esp,%ebp
 687:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 68a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 691:	eb 49                	jmp    6dc <gets+0x58>
    cc = read(0, &c, 1);
 693:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 69a:	00 
 69b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 69e:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 6a9:	e8 3e 01 00 00       	call   7ec <read>
 6ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 6b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6b5:	7f 02                	jg     6b9 <gets+0x35>
      break;
 6b7:	eb 2c                	jmp    6e5 <gets+0x61>
    buf[i++] = c;
 6b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6bc:	8d 50 01             	lea    0x1(%eax),%edx
 6bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6c2:	89 c2                	mov    %eax,%edx
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
 6c7:	01 c2                	add    %eax,%edx
 6c9:	8a 45 ef             	mov    -0x11(%ebp),%al
 6cc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6ce:	8a 45 ef             	mov    -0x11(%ebp),%al
 6d1:	3c 0a                	cmp    $0xa,%al
 6d3:	74 10                	je     6e5 <gets+0x61>
 6d5:	8a 45 ef             	mov    -0x11(%ebp),%al
 6d8:	3c 0d                	cmp    $0xd,%al
 6da:	74 09                	je     6e5 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6df:	40                   	inc    %eax
 6e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6e3:	7c ae                	jl     693 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6e8:	8b 45 08             	mov    0x8(%ebp),%eax
 6eb:	01 d0                	add    %edx,%eax
 6ed:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 6f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6f3:	c9                   	leave  
 6f4:	c3                   	ret    

000006f5 <stat>:

int
stat(char *n, struct stat *st)
{
 6f5:	55                   	push   %ebp
 6f6:	89 e5                	mov    %esp,%ebp
 6f8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 702:	00 
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 06 01 00 00       	call   814 <open>
 70e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 711:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 715:	79 07                	jns    71e <stat+0x29>
    return -1;
 717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 71c:	eb 23                	jmp    741 <stat+0x4c>
  r = fstat(fd, st);
 71e:	8b 45 0c             	mov    0xc(%ebp),%eax
 721:	89 44 24 04          	mov    %eax,0x4(%esp)
 725:	8b 45 f4             	mov    -0xc(%ebp),%eax
 728:	89 04 24             	mov    %eax,(%esp)
 72b:	e8 fc 00 00 00       	call   82c <fstat>
 730:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 733:	8b 45 f4             	mov    -0xc(%ebp),%eax
 736:	89 04 24             	mov    %eax,(%esp)
 739:	e8 be 00 00 00       	call   7fc <close>
  return r;
 73e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 741:	c9                   	leave  
 742:	c3                   	ret    

00000743 <atoi>:

int
atoi(const char *s)
{
 743:	55                   	push   %ebp
 744:	89 e5                	mov    %esp,%ebp
 746:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 749:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 750:	eb 24                	jmp    776 <atoi+0x33>
    n = n*10 + *s++ - '0';
 752:	8b 55 fc             	mov    -0x4(%ebp),%edx
 755:	89 d0                	mov    %edx,%eax
 757:	c1 e0 02             	shl    $0x2,%eax
 75a:	01 d0                	add    %edx,%eax
 75c:	01 c0                	add    %eax,%eax
 75e:	89 c1                	mov    %eax,%ecx
 760:	8b 45 08             	mov    0x8(%ebp),%eax
 763:	8d 50 01             	lea    0x1(%eax),%edx
 766:	89 55 08             	mov    %edx,0x8(%ebp)
 769:	8a 00                	mov    (%eax),%al
 76b:	0f be c0             	movsbl %al,%eax
 76e:	01 c8                	add    %ecx,%eax
 770:	83 e8 30             	sub    $0x30,%eax
 773:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 776:	8b 45 08             	mov    0x8(%ebp),%eax
 779:	8a 00                	mov    (%eax),%al
 77b:	3c 2f                	cmp    $0x2f,%al
 77d:	7e 09                	jle    788 <atoi+0x45>
 77f:	8b 45 08             	mov    0x8(%ebp),%eax
 782:	8a 00                	mov    (%eax),%al
 784:	3c 39                	cmp    $0x39,%al
 786:	7e ca                	jle    752 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 78b:	c9                   	leave  
 78c:	c3                   	ret    

0000078d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 78d:	55                   	push   %ebp
 78e:	89 e5                	mov    %esp,%ebp
 790:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 793:	8b 45 08             	mov    0x8(%ebp),%eax
 796:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 799:	8b 45 0c             	mov    0xc(%ebp),%eax
 79c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 79f:	eb 16                	jmp    7b7 <memmove+0x2a>
    *dst++ = *src++;
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8d 50 01             	lea    0x1(%eax),%edx
 7a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 7aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 7b0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 7b3:	8a 12                	mov    (%edx),%dl
 7b5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 7b7:	8b 45 10             	mov    0x10(%ebp),%eax
 7ba:	8d 50 ff             	lea    -0x1(%eax),%edx
 7bd:	89 55 10             	mov    %edx,0x10(%ebp)
 7c0:	85 c0                	test   %eax,%eax
 7c2:	7f dd                	jg     7a1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 7c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 7c7:	c9                   	leave  
 7c8:	c3                   	ret    
 7c9:	90                   	nop
 7ca:	90                   	nop
 7cb:	90                   	nop

000007cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7cc:	b8 01 00 00 00       	mov    $0x1,%eax
 7d1:	cd 40                	int    $0x40
 7d3:	c3                   	ret    

000007d4 <exit>:
SYSCALL(exit)
 7d4:	b8 02 00 00 00       	mov    $0x2,%eax
 7d9:	cd 40                	int    $0x40
 7db:	c3                   	ret    

000007dc <wait>:
SYSCALL(wait)
 7dc:	b8 03 00 00 00       	mov    $0x3,%eax
 7e1:	cd 40                	int    $0x40
 7e3:	c3                   	ret    

000007e4 <pipe>:
SYSCALL(pipe)
 7e4:	b8 04 00 00 00       	mov    $0x4,%eax
 7e9:	cd 40                	int    $0x40
 7eb:	c3                   	ret    

000007ec <read>:
SYSCALL(read)
 7ec:	b8 05 00 00 00       	mov    $0x5,%eax
 7f1:	cd 40                	int    $0x40
 7f3:	c3                   	ret    

000007f4 <write>:
SYSCALL(write)
 7f4:	b8 10 00 00 00       	mov    $0x10,%eax
 7f9:	cd 40                	int    $0x40
 7fb:	c3                   	ret    

000007fc <close>:
SYSCALL(close)
 7fc:	b8 15 00 00 00       	mov    $0x15,%eax
 801:	cd 40                	int    $0x40
 803:	c3                   	ret    

00000804 <kill>:
SYSCALL(kill)
 804:	b8 06 00 00 00       	mov    $0x6,%eax
 809:	cd 40                	int    $0x40
 80b:	c3                   	ret    

0000080c <exec>:
SYSCALL(exec)
 80c:	b8 07 00 00 00       	mov    $0x7,%eax
 811:	cd 40                	int    $0x40
 813:	c3                   	ret    

00000814 <open>:
SYSCALL(open)
 814:	b8 0f 00 00 00       	mov    $0xf,%eax
 819:	cd 40                	int    $0x40
 81b:	c3                   	ret    

0000081c <mknod>:
SYSCALL(mknod)
 81c:	b8 11 00 00 00       	mov    $0x11,%eax
 821:	cd 40                	int    $0x40
 823:	c3                   	ret    

00000824 <unlink>:
SYSCALL(unlink)
 824:	b8 12 00 00 00       	mov    $0x12,%eax
 829:	cd 40                	int    $0x40
 82b:	c3                   	ret    

0000082c <fstat>:
SYSCALL(fstat)
 82c:	b8 08 00 00 00       	mov    $0x8,%eax
 831:	cd 40                	int    $0x40
 833:	c3                   	ret    

00000834 <link>:
SYSCALL(link)
 834:	b8 13 00 00 00       	mov    $0x13,%eax
 839:	cd 40                	int    $0x40
 83b:	c3                   	ret    

0000083c <mkdir>:
SYSCALL(mkdir)
 83c:	b8 14 00 00 00       	mov    $0x14,%eax
 841:	cd 40                	int    $0x40
 843:	c3                   	ret    

00000844 <chdir>:
SYSCALL(chdir)
 844:	b8 09 00 00 00       	mov    $0x9,%eax
 849:	cd 40                	int    $0x40
 84b:	c3                   	ret    

0000084c <dup>:
SYSCALL(dup)
 84c:	b8 0a 00 00 00       	mov    $0xa,%eax
 851:	cd 40                	int    $0x40
 853:	c3                   	ret    

00000854 <getpid>:
SYSCALL(getpid)
 854:	b8 0b 00 00 00       	mov    $0xb,%eax
 859:	cd 40                	int    $0x40
 85b:	c3                   	ret    

0000085c <sbrk>:
SYSCALL(sbrk)
 85c:	b8 0c 00 00 00       	mov    $0xc,%eax
 861:	cd 40                	int    $0x40
 863:	c3                   	ret    

00000864 <sleep>:
SYSCALL(sleep)
 864:	b8 0d 00 00 00       	mov    $0xd,%eax
 869:	cd 40                	int    $0x40
 86b:	c3                   	ret    

0000086c <uptime>:
SYSCALL(uptime)
 86c:	b8 0e 00 00 00       	mov    $0xe,%eax
 871:	cd 40                	int    $0x40
 873:	c3                   	ret    

00000874 <getname>:
SYSCALL(getname)
 874:	b8 16 00 00 00       	mov    $0x16,%eax
 879:	cd 40                	int    $0x40
 87b:	c3                   	ret    

0000087c <setname>:
SYSCALL(setname)
 87c:	b8 17 00 00 00       	mov    $0x17,%eax
 881:	cd 40                	int    $0x40
 883:	c3                   	ret    

00000884 <getmaxproc>:
SYSCALL(getmaxproc)
 884:	b8 18 00 00 00       	mov    $0x18,%eax
 889:	cd 40                	int    $0x40
 88b:	c3                   	ret    

0000088c <setmaxproc>:
SYSCALL(setmaxproc)
 88c:	b8 19 00 00 00       	mov    $0x19,%eax
 891:	cd 40                	int    $0x40
 893:	c3                   	ret    

00000894 <getmaxmem>:
SYSCALL(getmaxmem)
 894:	b8 1a 00 00 00       	mov    $0x1a,%eax
 899:	cd 40                	int    $0x40
 89b:	c3                   	ret    

0000089c <setmaxmem>:
SYSCALL(setmaxmem)
 89c:	b8 1b 00 00 00       	mov    $0x1b,%eax
 8a1:	cd 40                	int    $0x40
 8a3:	c3                   	ret    

000008a4 <getmaxdisk>:
SYSCALL(getmaxdisk)
 8a4:	b8 1c 00 00 00       	mov    $0x1c,%eax
 8a9:	cd 40                	int    $0x40
 8ab:	c3                   	ret    

000008ac <setmaxdisk>:
SYSCALL(setmaxdisk)
 8ac:	b8 1d 00 00 00       	mov    $0x1d,%eax
 8b1:	cd 40                	int    $0x40
 8b3:	c3                   	ret    

000008b4 <getusedmem>:
SYSCALL(getusedmem)
 8b4:	b8 1e 00 00 00       	mov    $0x1e,%eax
 8b9:	cd 40                	int    $0x40
 8bb:	c3                   	ret    

000008bc <setusedmem>:
SYSCALL(setusedmem)
 8bc:	b8 1f 00 00 00       	mov    $0x1f,%eax
 8c1:	cd 40                	int    $0x40
 8c3:	c3                   	ret    

000008c4 <getuseddisk>:
SYSCALL(getuseddisk)
 8c4:	b8 20 00 00 00       	mov    $0x20,%eax
 8c9:	cd 40                	int    $0x40
 8cb:	c3                   	ret    

000008cc <setuseddisk>:
SYSCALL(setuseddisk)
 8cc:	b8 21 00 00 00       	mov    $0x21,%eax
 8d1:	cd 40                	int    $0x40
 8d3:	c3                   	ret    

000008d4 <setvc>:
SYSCALL(setvc)
 8d4:	b8 22 00 00 00       	mov    $0x22,%eax
 8d9:	cd 40                	int    $0x40
 8db:	c3                   	ret    

000008dc <setactivefs>:
SYSCALL(setactivefs)
 8dc:	b8 24 00 00 00       	mov    $0x24,%eax
 8e1:	cd 40                	int    $0x40
 8e3:	c3                   	ret    

000008e4 <getactivefs>:
SYSCALL(getactivefs)
 8e4:	b8 25 00 00 00       	mov    $0x25,%eax
 8e9:	cd 40                	int    $0x40
 8eb:	c3                   	ret    

000008ec <getvcfs>:
SYSCALL(getvcfs)
 8ec:	b8 23 00 00 00       	mov    $0x23,%eax
 8f1:	cd 40                	int    $0x40
 8f3:	c3                   	ret    

000008f4 <getcwd>:
SYSCALL(getcwd)
 8f4:	b8 26 00 00 00       	mov    $0x26,%eax
 8f9:	cd 40                	int    $0x40
 8fb:	c3                   	ret    

000008fc <tostring>:
SYSCALL(tostring)
 8fc:	b8 27 00 00 00       	mov    $0x27,%eax
 901:	cd 40                	int    $0x40
 903:	c3                   	ret    

00000904 <getactivefsindex>:
SYSCALL(getactivefsindex)
 904:	b8 28 00 00 00       	mov    $0x28,%eax
 909:	cd 40                	int    $0x40
 90b:	c3                   	ret    

0000090c <setatroot>:
SYSCALL(setatroot)
 90c:	b8 2a 00 00 00       	mov    $0x2a,%eax
 911:	cd 40                	int    $0x40
 913:	c3                   	ret    

00000914 <getatroot>:
SYSCALL(getatroot)
 914:	b8 29 00 00 00       	mov    $0x29,%eax
 919:	cd 40                	int    $0x40
 91b:	c3                   	ret    

0000091c <getpath>:
SYSCALL(getpath)
 91c:	b8 2b 00 00 00       	mov    $0x2b,%eax
 921:	cd 40                	int    $0x40
 923:	c3                   	ret    

00000924 <setpath>:
SYSCALL(setpath)
 924:	b8 2c 00 00 00       	mov    $0x2c,%eax
 929:	cd 40                	int    $0x40
 92b:	c3                   	ret    

0000092c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 92c:	55                   	push   %ebp
 92d:	89 e5                	mov    %esp,%ebp
 92f:	83 ec 18             	sub    $0x18,%esp
 932:	8b 45 0c             	mov    0xc(%ebp),%eax
 935:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 938:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 93f:	00 
 940:	8d 45 f4             	lea    -0xc(%ebp),%eax
 943:	89 44 24 04          	mov    %eax,0x4(%esp)
 947:	8b 45 08             	mov    0x8(%ebp),%eax
 94a:	89 04 24             	mov    %eax,(%esp)
 94d:	e8 a2 fe ff ff       	call   7f4 <write>
}
 952:	c9                   	leave  
 953:	c3                   	ret    

00000954 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 954:	55                   	push   %ebp
 955:	89 e5                	mov    %esp,%ebp
 957:	56                   	push   %esi
 958:	53                   	push   %ebx
 959:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 95c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 963:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 967:	74 17                	je     980 <printint+0x2c>
 969:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 96d:	79 11                	jns    980 <printint+0x2c>
    neg = 1;
 96f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 976:	8b 45 0c             	mov    0xc(%ebp),%eax
 979:	f7 d8                	neg    %eax
 97b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 97e:	eb 06                	jmp    986 <printint+0x32>
  } else {
    x = xx;
 980:	8b 45 0c             	mov    0xc(%ebp),%eax
 983:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 986:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 98d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 990:	8d 41 01             	lea    0x1(%ecx),%eax
 993:	89 45 f4             	mov    %eax,-0xc(%ebp)
 996:	8b 5d 10             	mov    0x10(%ebp),%ebx
 999:	8b 45 ec             	mov    -0x14(%ebp),%eax
 99c:	ba 00 00 00 00       	mov    $0x0,%edx
 9a1:	f7 f3                	div    %ebx
 9a3:	89 d0                	mov    %edx,%eax
 9a5:	8a 80 ec 11 00 00    	mov    0x11ec(%eax),%al
 9ab:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 9af:	8b 75 10             	mov    0x10(%ebp),%esi
 9b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9b5:	ba 00 00 00 00       	mov    $0x0,%edx
 9ba:	f7 f6                	div    %esi
 9bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 9bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 9c3:	75 c8                	jne    98d <printint+0x39>
  if(neg)
 9c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9c9:	74 10                	je     9db <printint+0x87>
    buf[i++] = '-';
 9cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ce:	8d 50 01             	lea    0x1(%eax),%edx
 9d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9d4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9d9:	eb 1e                	jmp    9f9 <printint+0xa5>
 9db:	eb 1c                	jmp    9f9 <printint+0xa5>
    putc(fd, buf[i]);
 9dd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e3:	01 d0                	add    %edx,%eax
 9e5:	8a 00                	mov    (%eax),%al
 9e7:	0f be c0             	movsbl %al,%eax
 9ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ee:	8b 45 08             	mov    0x8(%ebp),%eax
 9f1:	89 04 24             	mov    %eax,(%esp)
 9f4:	e8 33 ff ff ff       	call   92c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9f9:	ff 4d f4             	decl   -0xc(%ebp)
 9fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a00:	79 db                	jns    9dd <printint+0x89>
    putc(fd, buf[i]);
}
 a02:	83 c4 30             	add    $0x30,%esp
 a05:	5b                   	pop    %ebx
 a06:	5e                   	pop    %esi
 a07:	5d                   	pop    %ebp
 a08:	c3                   	ret    

00000a09 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 a09:	55                   	push   %ebp
 a0a:	89 e5                	mov    %esp,%ebp
 a0c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 a0f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 a16:	8d 45 0c             	lea    0xc(%ebp),%eax
 a19:	83 c0 04             	add    $0x4,%eax
 a1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 a1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 a26:	e9 77 01 00 00       	jmp    ba2 <printf+0x199>
    c = fmt[i] & 0xff;
 a2b:	8b 55 0c             	mov    0xc(%ebp),%edx
 a2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a31:	01 d0                	add    %edx,%eax
 a33:	8a 00                	mov    (%eax),%al
 a35:	0f be c0             	movsbl %al,%eax
 a38:	25 ff 00 00 00       	and    $0xff,%eax
 a3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a40:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a44:	75 2c                	jne    a72 <printf+0x69>
      if(c == '%'){
 a46:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a4a:	75 0c                	jne    a58 <printf+0x4f>
        state = '%';
 a4c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a53:	e9 47 01 00 00       	jmp    b9f <printf+0x196>
      } else {
        putc(fd, c);
 a58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a5b:	0f be c0             	movsbl %al,%eax
 a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a62:	8b 45 08             	mov    0x8(%ebp),%eax
 a65:	89 04 24             	mov    %eax,(%esp)
 a68:	e8 bf fe ff ff       	call   92c <putc>
 a6d:	e9 2d 01 00 00       	jmp    b9f <printf+0x196>
      }
    } else if(state == '%'){
 a72:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a76:	0f 85 23 01 00 00    	jne    b9f <printf+0x196>
      if(c == 'd'){
 a7c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a80:	75 2d                	jne    aaf <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a85:	8b 00                	mov    (%eax),%eax
 a87:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a8e:	00 
 a8f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a96:	00 
 a97:	89 44 24 04          	mov    %eax,0x4(%esp)
 a9b:	8b 45 08             	mov    0x8(%ebp),%eax
 a9e:	89 04 24             	mov    %eax,(%esp)
 aa1:	e8 ae fe ff ff       	call   954 <printint>
        ap++;
 aa6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 aaa:	e9 e9 00 00 00       	jmp    b98 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 aaf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 ab3:	74 06                	je     abb <printf+0xb2>
 ab5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 ab9:	75 2d                	jne    ae8 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 abb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 abe:	8b 00                	mov    (%eax),%eax
 ac0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 ac7:	00 
 ac8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 acf:	00 
 ad0:	89 44 24 04          	mov    %eax,0x4(%esp)
 ad4:	8b 45 08             	mov    0x8(%ebp),%eax
 ad7:	89 04 24             	mov    %eax,(%esp)
 ada:	e8 75 fe ff ff       	call   954 <printint>
        ap++;
 adf:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ae3:	e9 b0 00 00 00       	jmp    b98 <printf+0x18f>
      } else if(c == 's'){
 ae8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 aec:	75 42                	jne    b30 <printf+0x127>
        s = (char*)*ap;
 aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
 af1:	8b 00                	mov    (%eax),%eax
 af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 af6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 afe:	75 09                	jne    b09 <printf+0x100>
          s = "(null)";
 b00:	c7 45 f4 06 0e 00 00 	movl   $0xe06,-0xc(%ebp)
        while(*s != 0){
 b07:	eb 1c                	jmp    b25 <printf+0x11c>
 b09:	eb 1a                	jmp    b25 <printf+0x11c>
          putc(fd, *s);
 b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0e:	8a 00                	mov    (%eax),%al
 b10:	0f be c0             	movsbl %al,%eax
 b13:	89 44 24 04          	mov    %eax,0x4(%esp)
 b17:	8b 45 08             	mov    0x8(%ebp),%eax
 b1a:	89 04 24             	mov    %eax,(%esp)
 b1d:	e8 0a fe ff ff       	call   92c <putc>
          s++;
 b22:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b28:	8a 00                	mov    (%eax),%al
 b2a:	84 c0                	test   %al,%al
 b2c:	75 dd                	jne    b0b <printf+0x102>
 b2e:	eb 68                	jmp    b98 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b30:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b34:	75 1d                	jne    b53 <printf+0x14a>
        putc(fd, *ap);
 b36:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b39:	8b 00                	mov    (%eax),%eax
 b3b:	0f be c0             	movsbl %al,%eax
 b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
 b42:	8b 45 08             	mov    0x8(%ebp),%eax
 b45:	89 04 24             	mov    %eax,(%esp)
 b48:	e8 df fd ff ff       	call   92c <putc>
        ap++;
 b4d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b51:	eb 45                	jmp    b98 <printf+0x18f>
      } else if(c == '%'){
 b53:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b57:	75 17                	jne    b70 <printf+0x167>
        putc(fd, c);
 b59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b5c:	0f be c0             	movsbl %al,%eax
 b5f:	89 44 24 04          	mov    %eax,0x4(%esp)
 b63:	8b 45 08             	mov    0x8(%ebp),%eax
 b66:	89 04 24             	mov    %eax,(%esp)
 b69:	e8 be fd ff ff       	call   92c <putc>
 b6e:	eb 28                	jmp    b98 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b70:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b77:	00 
 b78:	8b 45 08             	mov    0x8(%ebp),%eax
 b7b:	89 04 24             	mov    %eax,(%esp)
 b7e:	e8 a9 fd ff ff       	call   92c <putc>
        putc(fd, c);
 b83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b86:	0f be c0             	movsbl %al,%eax
 b89:	89 44 24 04          	mov    %eax,0x4(%esp)
 b8d:	8b 45 08             	mov    0x8(%ebp),%eax
 b90:	89 04 24             	mov    %eax,(%esp)
 b93:	e8 94 fd ff ff       	call   92c <putc>
      }
      state = 0;
 b98:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b9f:	ff 45 f0             	incl   -0x10(%ebp)
 ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
 ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba8:	01 d0                	add    %edx,%eax
 baa:	8a 00                	mov    (%eax),%al
 bac:	84 c0                	test   %al,%al
 bae:	0f 85 77 fe ff ff    	jne    a2b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 bb4:	c9                   	leave  
 bb5:	c3                   	ret    
 bb6:	90                   	nop
 bb7:	90                   	nop

00000bb8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb8:	55                   	push   %ebp
 bb9:	89 e5                	mov    %esp,%ebp
 bbb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bbe:	8b 45 08             	mov    0x8(%ebp),%eax
 bc1:	83 e8 08             	sub    $0x8,%eax
 bc4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc7:	a1 10 12 00 00       	mov    0x1210,%eax
 bcc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bcf:	eb 24                	jmp    bf5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd4:	8b 00                	mov    (%eax),%eax
 bd6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bd9:	77 12                	ja     bed <free+0x35>
 bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bde:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 be1:	77 24                	ja     c07 <free+0x4f>
 be3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be6:	8b 00                	mov    (%eax),%eax
 be8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 beb:	77 1a                	ja     c07 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf0:	8b 00                	mov    (%eax),%eax
 bf2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bf5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bfb:	76 d4                	jbe    bd1 <free+0x19>
 bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c00:	8b 00                	mov    (%eax),%eax
 c02:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c05:	76 ca                	jbe    bd1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 c07:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c0a:	8b 40 04             	mov    0x4(%eax),%eax
 c0d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c14:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c17:	01 c2                	add    %eax,%edx
 c19:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1c:	8b 00                	mov    (%eax),%eax
 c1e:	39 c2                	cmp    %eax,%edx
 c20:	75 24                	jne    c46 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 c22:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c25:	8b 50 04             	mov    0x4(%eax),%edx
 c28:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2b:	8b 00                	mov    (%eax),%eax
 c2d:	8b 40 04             	mov    0x4(%eax),%eax
 c30:	01 c2                	add    %eax,%edx
 c32:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c35:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c38:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3b:	8b 00                	mov    (%eax),%eax
 c3d:	8b 10                	mov    (%eax),%edx
 c3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c42:	89 10                	mov    %edx,(%eax)
 c44:	eb 0a                	jmp    c50 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c46:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c49:	8b 10                	mov    (%eax),%edx
 c4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c4e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c50:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c53:	8b 40 04             	mov    0x4(%eax),%eax
 c56:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c60:	01 d0                	add    %edx,%eax
 c62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c65:	75 20                	jne    c87 <free+0xcf>
    p->s.size += bp->s.size;
 c67:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c6a:	8b 50 04             	mov    0x4(%eax),%edx
 c6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c70:	8b 40 04             	mov    0x4(%eax),%eax
 c73:	01 c2                	add    %eax,%edx
 c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c78:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c7e:	8b 10                	mov    (%eax),%edx
 c80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c83:	89 10                	mov    %edx,(%eax)
 c85:	eb 08                	jmp    c8f <free+0xd7>
  } else
    p->s.ptr = bp;
 c87:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c8a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c8d:	89 10                	mov    %edx,(%eax)
  freep = p;
 c8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c92:	a3 10 12 00 00       	mov    %eax,0x1210
}
 c97:	c9                   	leave  
 c98:	c3                   	ret    

00000c99 <morecore>:

static Header*
morecore(uint nu)
{
 c99:	55                   	push   %ebp
 c9a:	89 e5                	mov    %esp,%ebp
 c9c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c9f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 ca6:	77 07                	ja     caf <morecore+0x16>
    nu = 4096;
 ca8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 caf:	8b 45 08             	mov    0x8(%ebp),%eax
 cb2:	c1 e0 03             	shl    $0x3,%eax
 cb5:	89 04 24             	mov    %eax,(%esp)
 cb8:	e8 9f fb ff ff       	call   85c <sbrk>
 cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 cc0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 cc4:	75 07                	jne    ccd <morecore+0x34>
    return 0;
 cc6:	b8 00 00 00 00       	mov    $0x0,%eax
 ccb:	eb 22                	jmp    cef <morecore+0x56>
  hp = (Header*)p;
 ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cd0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cd6:	8b 55 08             	mov    0x8(%ebp),%edx
 cd9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cdf:	83 c0 08             	add    $0x8,%eax
 ce2:	89 04 24             	mov    %eax,(%esp)
 ce5:	e8 ce fe ff ff       	call   bb8 <free>
  return freep;
 cea:	a1 10 12 00 00       	mov    0x1210,%eax
}
 cef:	c9                   	leave  
 cf0:	c3                   	ret    

00000cf1 <malloc>:

void*
malloc(uint nbytes)
{
 cf1:	55                   	push   %ebp
 cf2:	89 e5                	mov    %esp,%ebp
 cf4:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 cf7:	8b 45 08             	mov    0x8(%ebp),%eax
 cfa:	83 c0 07             	add    $0x7,%eax
 cfd:	c1 e8 03             	shr    $0x3,%eax
 d00:	40                   	inc    %eax
 d01:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 d04:	a1 10 12 00 00       	mov    0x1210,%eax
 d09:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 d10:	75 23                	jne    d35 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 d12:	c7 45 f0 08 12 00 00 	movl   $0x1208,-0x10(%ebp)
 d19:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d1c:	a3 10 12 00 00       	mov    %eax,0x1210
 d21:	a1 10 12 00 00       	mov    0x1210,%eax
 d26:	a3 08 12 00 00       	mov    %eax,0x1208
    base.s.size = 0;
 d2b:	c7 05 0c 12 00 00 00 	movl   $0x0,0x120c
 d32:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d38:	8b 00                	mov    (%eax),%eax
 d3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d40:	8b 40 04             	mov    0x4(%eax),%eax
 d43:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d46:	72 4d                	jb     d95 <malloc+0xa4>
      if(p->s.size == nunits)
 d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d4b:	8b 40 04             	mov    0x4(%eax),%eax
 d4e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d51:	75 0c                	jne    d5f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d56:	8b 10                	mov    (%eax),%edx
 d58:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d5b:	89 10                	mov    %edx,(%eax)
 d5d:	eb 26                	jmp    d85 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d62:	8b 40 04             	mov    0x4(%eax),%eax
 d65:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d68:	89 c2                	mov    %eax,%edx
 d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d73:	8b 40 04             	mov    0x4(%eax),%eax
 d76:	c1 e0 03             	shl    $0x3,%eax
 d79:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d82:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d85:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d88:	a3 10 12 00 00       	mov    %eax,0x1210
      return (void*)(p + 1);
 d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d90:	83 c0 08             	add    $0x8,%eax
 d93:	eb 38                	jmp    dcd <malloc+0xdc>
    }
    if(p == freep)
 d95:	a1 10 12 00 00       	mov    0x1210,%eax
 d9a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d9d:	75 1b                	jne    dba <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 da2:	89 04 24             	mov    %eax,(%esp)
 da5:	e8 ef fe ff ff       	call   c99 <morecore>
 daa:	89 45 f4             	mov    %eax,-0xc(%ebp)
 dad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 db1:	75 07                	jne    dba <malloc+0xc9>
        return 0;
 db3:	b8 00 00 00 00       	mov    $0x0,%eax
 db8:	eb 13                	jmp    dcd <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 dc3:	8b 00                	mov    (%eax),%eax
 dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 dc8:	e9 70 ff ff ff       	jmp    d3d <malloc+0x4c>
}
 dcd:	c9                   	leave  
 dce:	c3                   	ret    