
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
   f:	c7 44 24 04 6f 0c 00 	movl   $0xc6f,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 86 08 00 00       	call   8a9 <printf>
    exit();
  23:	e8 04 07 00 00       	call   72c <exit>
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
  3f:	e8 48 07 00 00       	call   78c <link>
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
  60:	c7 44 24 04 82 0c 00 	movl   $0xc82,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 35 08 00 00       	call   8a9 <printf>
  exit();
  74:	e8 b3 06 00 00       	call   72c <exit>
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

000000cf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  cf:	55                   	push   %ebp
  d0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d2:	eb 06                	jmp    da <strcmp+0xb>
    p++, q++;
  d4:	ff 45 08             	incl   0x8(%ebp)
  d7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  da:	8b 45 08             	mov    0x8(%ebp),%eax
  dd:	8a 00                	mov    (%eax),%al
  df:	84 c0                	test   %al,%al
  e1:	74 0e                	je     f1 <strcmp+0x22>
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	8a 10                	mov    (%eax),%dl
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	8a 00                	mov    (%eax),%al
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 e3                	je     d4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	8a 00                	mov    (%eax),%al
  f6:	0f b6 d0             	movzbl %al,%edx
  f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  fc:	8a 00                	mov    (%eax),%al
  fe:	0f b6 c0             	movzbl %al,%eax
 101:	29 c2                	sub    %eax,%edx
 103:	89 d0                	mov    %edx,%eax
}
 105:	5d                   	pop    %ebp
 106:	c3                   	ret    

00000107 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 107:	55                   	push   %ebp
 108:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 10a:	eb 09                	jmp    115 <strncmp+0xe>
    n--, p++, q++;
 10c:	ff 4d 10             	decl   0x10(%ebp)
 10f:	ff 45 08             	incl   0x8(%ebp)
 112:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 115:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 119:	74 17                	je     132 <strncmp+0x2b>
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	8a 00                	mov    (%eax),%al
 120:	84 c0                	test   %al,%al
 122:	74 0e                	je     132 <strncmp+0x2b>
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	8a 10                	mov    (%eax),%dl
 129:	8b 45 0c             	mov    0xc(%ebp),%eax
 12c:	8a 00                	mov    (%eax),%al
 12e:	38 c2                	cmp    %al,%dl
 130:	74 da                	je     10c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 132:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 136:	75 07                	jne    13f <strncmp+0x38>
    return 0;
 138:	b8 00 00 00 00       	mov    $0x0,%eax
 13d:	eb 14                	jmp    153 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	8a 00                	mov    (%eax),%al
 144:	0f b6 d0             	movzbl %al,%edx
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	8a 00                	mov    (%eax),%al
 14c:	0f b6 c0             	movzbl %al,%eax
 14f:	29 c2                	sub    %eax,%edx
 151:	89 d0                	mov    %edx,%eax
}
 153:	5d                   	pop    %ebp
 154:	c3                   	ret    

00000155 <strlen>:

uint
strlen(const char *s)
{
 155:	55                   	push   %ebp
 156:	89 e5                	mov    %esp,%ebp
 158:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 15b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 162:	eb 03                	jmp    167 <strlen+0x12>
 164:	ff 45 fc             	incl   -0x4(%ebp)
 167:	8b 55 fc             	mov    -0x4(%ebp),%edx
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	01 d0                	add    %edx,%eax
 16f:	8a 00                	mov    (%eax),%al
 171:	84 c0                	test   %al,%al
 173:	75 ef                	jne    164 <strlen+0xf>
    ;
  return n;
 175:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 178:	c9                   	leave  
 179:	c3                   	ret    

0000017a <memset>:

void*
memset(void *dst, int c, uint n)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 180:	8b 45 10             	mov    0x10(%ebp),%eax
 183:	89 44 24 08          	mov    %eax,0x8(%esp)
 187:	8b 45 0c             	mov    0xc(%ebp),%eax
 18a:	89 44 24 04          	mov    %eax,0x4(%esp)
 18e:	8b 45 08             	mov    0x8(%ebp),%eax
 191:	89 04 24             	mov    %eax,(%esp)
 194:	e8 e3 fe ff ff       	call   7c <stosb>
  return dst;
 199:	8b 45 08             	mov    0x8(%ebp),%eax
}
 19c:	c9                   	leave  
 19d:	c3                   	ret    

0000019e <strchr>:

char*
strchr(const char *s, char c)
{
 19e:	55                   	push   %ebp
 19f:	89 e5                	mov    %esp,%ebp
 1a1:	83 ec 04             	sub    $0x4,%esp
 1a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1aa:	eb 12                	jmp    1be <strchr+0x20>
    if(*s == c)
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	8a 00                	mov    (%eax),%al
 1b1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1b4:	75 05                	jne    1bb <strchr+0x1d>
      return (char*)s;
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	eb 11                	jmp    1cc <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1bb:	ff 45 08             	incl   0x8(%ebp)
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	8a 00                	mov    (%eax),%al
 1c3:	84 c0                	test   %al,%al
 1c5:	75 e5                	jne    1ac <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1c7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1cc:	c9                   	leave  
 1cd:	c3                   	ret    

000001ce <strcat>:

char *
strcat(char *dest, const char *src)
{
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 1d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1db:	eb 03                	jmp    1e0 <strcat+0x12>
 1dd:	ff 45 fc             	incl   -0x4(%ebp)
 1e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e3:	8b 45 08             	mov    0x8(%ebp),%eax
 1e6:	01 d0                	add    %edx,%eax
 1e8:	8a 00                	mov    (%eax),%al
 1ea:	84 c0                	test   %al,%al
 1ec:	75 ef                	jne    1dd <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 1ee:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 1f5:	eb 1e                	jmp    215 <strcat+0x47>
        dest[i+j] = src[j];
 1f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 1fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1fd:	01 d0                	add    %edx,%eax
 1ff:	89 c2                	mov    %eax,%edx
 201:	8b 45 08             	mov    0x8(%ebp),%eax
 204:	01 c2                	add    %eax,%edx
 206:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 209:	8b 45 0c             	mov    0xc(%ebp),%eax
 20c:	01 c8                	add    %ecx,%eax
 20e:	8a 00                	mov    (%eax),%al
 210:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 212:	ff 45 f8             	incl   -0x8(%ebp)
 215:	8b 55 f8             	mov    -0x8(%ebp),%edx
 218:	8b 45 0c             	mov    0xc(%ebp),%eax
 21b:	01 d0                	add    %edx,%eax
 21d:	8a 00                	mov    (%eax),%al
 21f:	84 c0                	test   %al,%al
 221:	75 d4                	jne    1f7 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 223:	8b 45 f8             	mov    -0x8(%ebp),%eax
 226:	8b 55 fc             	mov    -0x4(%ebp),%edx
 229:	01 d0                	add    %edx,%eax
 22b:	89 c2                	mov    %eax,%edx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	01 d0                	add    %edx,%eax
 232:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 235:	8b 45 08             	mov    0x8(%ebp),%eax
}
 238:	c9                   	leave  
 239:	c3                   	ret    

0000023a <strstr>:

int 
strstr(char* s, char* sub)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 240:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 247:	eb 7c                	jmp    2c5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 249:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	01 d0                	add    %edx,%eax
 251:	8a 10                	mov    (%eax),%dl
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	8a 00                	mov    (%eax),%al
 258:	38 c2                	cmp    %al,%dl
 25a:	75 66                	jne    2c2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 25c:	8b 45 0c             	mov    0xc(%ebp),%eax
 25f:	89 04 24             	mov    %eax,(%esp)
 262:	e8 ee fe ff ff       	call   155 <strlen>
 267:	83 f8 01             	cmp    $0x1,%eax
 26a:	75 05                	jne    271 <strstr+0x37>
            {  
                return i;
 26c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 26f:	eb 6b                	jmp    2dc <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 271:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 278:	eb 3a                	jmp    2b4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 27a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 27d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 280:	01 d0                	add    %edx,%eax
 282:	89 c2                	mov    %eax,%edx
 284:	8b 45 08             	mov    0x8(%ebp),%eax
 287:	01 d0                	add    %edx,%eax
 289:	8a 10                	mov    (%eax),%dl
 28b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 28e:	8b 45 0c             	mov    0xc(%ebp),%eax
 291:	01 c8                	add    %ecx,%eax
 293:	8a 00                	mov    (%eax),%al
 295:	38 c2                	cmp    %al,%dl
 297:	75 16                	jne    2af <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 299:	8b 45 f8             	mov    -0x8(%ebp),%eax
 29c:	8d 50 01             	lea    0x1(%eax),%edx
 29f:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a2:	01 d0                	add    %edx,%eax
 2a4:	8a 00                	mov    (%eax),%al
 2a6:	84 c0                	test   %al,%al
 2a8:	75 07                	jne    2b1 <strstr+0x77>
                    {
                        return i;
 2aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ad:	eb 2d                	jmp    2dc <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 2af:	eb 11                	jmp    2c2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 2b1:	ff 45 f8             	incl   -0x8(%ebp)
 2b4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ba:	01 d0                	add    %edx,%eax
 2bc:	8a 00                	mov    (%eax),%al
 2be:	84 c0                	test   %al,%al
 2c0:	75 b8                	jne    27a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2c2:	ff 45 fc             	incl   -0x4(%ebp)
 2c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2c8:	8b 45 08             	mov    0x8(%ebp),%eax
 2cb:	01 d0                	add    %edx,%eax
 2cd:	8a 00                	mov    (%eax),%al
 2cf:	84 c0                	test   %al,%al
 2d1:	0f 85 72 ff ff ff    	jne    249 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 2d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <strtok>:

char *
strtok(char *s, const char *delim)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	53                   	push   %ebx
 2e2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 2e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e9:	75 08                	jne    2f3 <strtok+0x15>
  s = lasts;
 2eb:	a1 64 10 00 00       	mov    0x1064,%eax
 2f0:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 2f3:	8b 45 08             	mov    0x8(%ebp),%eax
 2f6:	8d 50 01             	lea    0x1(%eax),%edx
 2f9:	89 55 08             	mov    %edx,0x8(%ebp)
 2fc:	8a 00                	mov    (%eax),%al
 2fe:	0f be d8             	movsbl %al,%ebx
 301:	85 db                	test   %ebx,%ebx
 303:	75 07                	jne    30c <strtok+0x2e>
      return 0;
 305:	b8 00 00 00 00       	mov    $0x0,%eax
 30a:	eb 58                	jmp    364 <strtok+0x86>
    } while (strchr(delim, ch));
 30c:	88 d8                	mov    %bl,%al
 30e:	0f be c0             	movsbl %al,%eax
 311:	89 44 24 04          	mov    %eax,0x4(%esp)
 315:	8b 45 0c             	mov    0xc(%ebp),%eax
 318:	89 04 24             	mov    %eax,(%esp)
 31b:	e8 7e fe ff ff       	call   19e <strchr>
 320:	85 c0                	test   %eax,%eax
 322:	75 cf                	jne    2f3 <strtok+0x15>
    --s;
 324:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 327:	8b 45 0c             	mov    0xc(%ebp),%eax
 32a:	89 44 24 04          	mov    %eax,0x4(%esp)
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	89 04 24             	mov    %eax,(%esp)
 334:	e8 31 00 00 00       	call   36a <strcspn>
 339:	89 c2                	mov    %eax,%edx
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	01 d0                	add    %edx,%eax
 340:	a3 64 10 00 00       	mov    %eax,0x1064
    if (*lasts != 0)
 345:	a1 64 10 00 00       	mov    0x1064,%eax
 34a:	8a 00                	mov    (%eax),%al
 34c:	84 c0                	test   %al,%al
 34e:	74 11                	je     361 <strtok+0x83>
  *lasts++ = 0;
 350:	a1 64 10 00 00       	mov    0x1064,%eax
 355:	8d 50 01             	lea    0x1(%eax),%edx
 358:	89 15 64 10 00 00    	mov    %edx,0x1064
 35e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 361:	8b 45 08             	mov    0x8(%ebp),%eax
}
 364:	83 c4 14             	add    $0x14,%esp
 367:	5b                   	pop    %ebx
 368:	5d                   	pop    %ebp
 369:	c3                   	ret    

0000036a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 36a:	55                   	push   %ebp
 36b:	89 e5                	mov    %esp,%ebp
 36d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 370:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 377:	eb 26                	jmp    39f <strcspn+0x35>
        if(strchr(s2,*s1))
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	8a 00                	mov    (%eax),%al
 37e:	0f be c0             	movsbl %al,%eax
 381:	89 44 24 04          	mov    %eax,0x4(%esp)
 385:	8b 45 0c             	mov    0xc(%ebp),%eax
 388:	89 04 24             	mov    %eax,(%esp)
 38b:	e8 0e fe ff ff       	call   19e <strchr>
 390:	85 c0                	test   %eax,%eax
 392:	74 05                	je     399 <strcspn+0x2f>
            return ret;
 394:	8b 45 fc             	mov    -0x4(%ebp),%eax
 397:	eb 12                	jmp    3ab <strcspn+0x41>
        else
            s1++,ret++;
 399:	ff 45 08             	incl   0x8(%ebp)
 39c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	8a 00                	mov    (%eax),%al
 3a4:	84 c0                	test   %al,%al
 3a6:	75 d1                	jne    379 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ab:	c9                   	leave  
 3ac:	c3                   	ret    

000003ad <isspace>:

int
isspace(unsigned char c)
{
 3ad:	55                   	push   %ebp
 3ae:	89 e5                	mov    %esp,%ebp
 3b0:	83 ec 04             	sub    $0x4,%esp
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 3b9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 3bd:	74 1e                	je     3dd <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 3bf:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 3c3:	74 18                	je     3dd <isspace+0x30>
 3c5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 3c9:	74 12                	je     3dd <isspace+0x30>
 3cb:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 3cf:	74 0c                	je     3dd <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 3d1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 3d5:	74 06                	je     3dd <isspace+0x30>
 3d7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 3db:	75 07                	jne    3e4 <isspace+0x37>
 3dd:	b8 01 00 00 00       	mov    $0x1,%eax
 3e2:	eb 05                	jmp    3e9 <isspace+0x3c>
 3e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3e9:	c9                   	leave  
 3ea:	c3                   	ret    

000003eb <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 3eb:	55                   	push   %ebp
 3ec:	89 e5                	mov    %esp,%ebp
 3ee:	57                   	push   %edi
 3ef:	56                   	push   %esi
 3f0:	53                   	push   %ebx
 3f1:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 3f4:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 3f9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 400:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 403:	eb 01                	jmp    406 <strtoul+0x1b>
  p += 1;
 405:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 406:	8a 03                	mov    (%ebx),%al
 408:	0f b6 c0             	movzbl %al,%eax
 40b:	89 04 24             	mov    %eax,(%esp)
 40e:	e8 9a ff ff ff       	call   3ad <isspace>
 413:	85 c0                	test   %eax,%eax
 415:	75 ee                	jne    405 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 417:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 41b:	75 30                	jne    44d <strtoul+0x62>
    {
  if (*p == '0') {
 41d:	8a 03                	mov    (%ebx),%al
 41f:	3c 30                	cmp    $0x30,%al
 421:	75 21                	jne    444 <strtoul+0x59>
      p += 1;
 423:	43                   	inc    %ebx
      if (*p == 'x') {
 424:	8a 03                	mov    (%ebx),%al
 426:	3c 78                	cmp    $0x78,%al
 428:	75 0a                	jne    434 <strtoul+0x49>
    p += 1;
 42a:	43                   	inc    %ebx
    base = 16;
 42b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 432:	eb 31                	jmp    465 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 434:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 43b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 442:	eb 21                	jmp    465 <strtoul+0x7a>
      }
  }
  else base = 10;
 444:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 44b:	eb 18                	jmp    465 <strtoul+0x7a>
    } else if (base == 16) {
 44d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 451:	75 12                	jne    465 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 453:	8a 03                	mov    (%ebx),%al
 455:	3c 30                	cmp    $0x30,%al
 457:	75 0c                	jne    465 <strtoul+0x7a>
 459:	8d 43 01             	lea    0x1(%ebx),%eax
 45c:	8a 00                	mov    (%eax),%al
 45e:	3c 78                	cmp    $0x78,%al
 460:	75 03                	jne    465 <strtoul+0x7a>
      p += 2;
 462:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 465:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 469:	75 29                	jne    494 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 46b:	8a 03                	mov    (%ebx),%al
 46d:	0f be c0             	movsbl %al,%eax
 470:	83 e8 30             	sub    $0x30,%eax
 473:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 475:	83 fe 07             	cmp    $0x7,%esi
 478:	76 06                	jbe    480 <strtoul+0x95>
    break;
 47a:	90                   	nop
 47b:	e9 b6 00 00 00       	jmp    536 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 480:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 487:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 48a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 491:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 492:	eb d7                	jmp    46b <strtoul+0x80>
    } else if (base == 10) {
 494:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 498:	75 2b                	jne    4c5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 49a:	8a 03                	mov    (%ebx),%al
 49c:	0f be c0             	movsbl %al,%eax
 49f:	83 e8 30             	sub    $0x30,%eax
 4a2:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 4a4:	83 fe 09             	cmp    $0x9,%esi
 4a7:	76 06                	jbe    4af <strtoul+0xc4>
    break;
 4a9:	90                   	nop
 4aa:	e9 87 00 00 00       	jmp    536 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 4af:	89 f8                	mov    %edi,%eax
 4b1:	c1 e0 02             	shl    $0x2,%eax
 4b4:	01 f8                	add    %edi,%eax
 4b6:	01 c0                	add    %eax,%eax
 4b8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4bb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 4c2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 4c3:	eb d5                	jmp    49a <strtoul+0xaf>
    } else if (base == 16) {
 4c5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4c9:	75 35                	jne    500 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4cb:	8a 03                	mov    (%ebx),%al
 4cd:	0f be c0             	movsbl %al,%eax
 4d0:	83 e8 30             	sub    $0x30,%eax
 4d3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 4d5:	83 fe 4a             	cmp    $0x4a,%esi
 4d8:	76 02                	jbe    4dc <strtoul+0xf1>
    break;
 4da:	eb 22                	jmp    4fe <strtoul+0x113>
      }
      digit = cvtIn[digit];
 4dc:	8a 86 00 10 00 00    	mov    0x1000(%esi),%al
 4e2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 4e5:	83 fe 0f             	cmp    $0xf,%esi
 4e8:	76 02                	jbe    4ec <strtoul+0x101>
    break;
 4ea:	eb 12                	jmp    4fe <strtoul+0x113>
      }
      result = (result << 4) + digit;
 4ec:	89 f8                	mov    %edi,%eax
 4ee:	c1 e0 04             	shl    $0x4,%eax
 4f1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4f4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 4fb:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 4fc:	eb cd                	jmp    4cb <strtoul+0xe0>
 4fe:	eb 36                	jmp    536 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 500:	8a 03                	mov    (%ebx),%al
 502:	0f be c0             	movsbl %al,%eax
 505:	83 e8 30             	sub    $0x30,%eax
 508:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 50a:	83 fe 4a             	cmp    $0x4a,%esi
 50d:	76 02                	jbe    511 <strtoul+0x126>
    break;
 50f:	eb 25                	jmp    536 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 511:	8a 86 00 10 00 00    	mov    0x1000(%esi),%al
 517:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 51a:	8b 45 10             	mov    0x10(%ebp),%eax
 51d:	39 f0                	cmp    %esi,%eax
 51f:	77 02                	ja     523 <strtoul+0x138>
    break;
 521:	eb 13                	jmp    536 <strtoul+0x14b>
      }
      result = result*base + digit;
 523:	8b 45 10             	mov    0x10(%ebp),%eax
 526:	0f af c7             	imul   %edi,%eax
 529:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 52c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 533:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 534:	eb ca                	jmp    500 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 536:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53a:	75 03                	jne    53f <strtoul+0x154>
  p = string;
 53c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 53f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 543:	74 05                	je     54a <strtoul+0x15f>
  *endPtr = p;
 545:	8b 45 0c             	mov    0xc(%ebp),%eax
 548:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 54a:	89 f8                	mov    %edi,%eax
}
 54c:	83 c4 14             	add    $0x14,%esp
 54f:	5b                   	pop    %ebx
 550:	5e                   	pop    %esi
 551:	5f                   	pop    %edi
 552:	5d                   	pop    %ebp
 553:	c3                   	ret    

00000554 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	53                   	push   %ebx
 558:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 55b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 55e:	eb 01                	jmp    561 <strtol+0xd>
      p += 1;
 560:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 561:	8a 03                	mov    (%ebx),%al
 563:	0f b6 c0             	movzbl %al,%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 3f fe ff ff       	call   3ad <isspace>
 56e:	85 c0                	test   %eax,%eax
 570:	75 ee                	jne    560 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 572:	8a 03                	mov    (%ebx),%al
 574:	3c 2d                	cmp    $0x2d,%al
 576:	75 1e                	jne    596 <strtol+0x42>
  p += 1;
 578:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 579:	8b 45 10             	mov    0x10(%ebp),%eax
 57c:	89 44 24 08          	mov    %eax,0x8(%esp)
 580:	8b 45 0c             	mov    0xc(%ebp),%eax
 583:	89 44 24 04          	mov    %eax,0x4(%esp)
 587:	89 1c 24             	mov    %ebx,(%esp)
 58a:	e8 5c fe ff ff       	call   3eb <strtoul>
 58f:	f7 d8                	neg    %eax
 591:	89 45 f8             	mov    %eax,-0x8(%ebp)
 594:	eb 20                	jmp    5b6 <strtol+0x62>
    } else {
  if (*p == '+') {
 596:	8a 03                	mov    (%ebx),%al
 598:	3c 2b                	cmp    $0x2b,%al
 59a:	75 01                	jne    59d <strtol+0x49>
      p += 1;
 59c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 59d:	8b 45 10             	mov    0x10(%ebp),%eax
 5a0:	89 44 24 08          	mov    %eax,0x8(%esp)
 5a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ab:	89 1c 24             	mov    %ebx,(%esp)
 5ae:	e8 38 fe ff ff       	call   3eb <strtoul>
 5b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 5b6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 5ba:	75 17                	jne    5d3 <strtol+0x7f>
 5bc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5c0:	74 11                	je     5d3 <strtol+0x7f>
 5c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c5:	8b 00                	mov    (%eax),%eax
 5c7:	39 d8                	cmp    %ebx,%eax
 5c9:	75 08                	jne    5d3 <strtol+0x7f>
  *endPtr = string;
 5cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ce:	8b 55 08             	mov    0x8(%ebp),%edx
 5d1:	89 10                	mov    %edx,(%eax)
    }
    return result;
 5d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 5d6:	83 c4 1c             	add    $0x1c,%esp
 5d9:	5b                   	pop    %ebx
 5da:	5d                   	pop    %ebp
 5db:	c3                   	ret    

000005dc <gets>:

char*
gets(char *buf, int max)
{
 5dc:	55                   	push   %ebp
 5dd:	89 e5                	mov    %esp,%ebp
 5df:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5e9:	eb 49                	jmp    634 <gets+0x58>
    cc = read(0, &c, 1);
 5eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5f2:	00 
 5f3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 601:	e8 3e 01 00 00       	call   744 <read>
 606:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 60d:	7f 02                	jg     611 <gets+0x35>
      break;
 60f:	eb 2c                	jmp    63d <gets+0x61>
    buf[i++] = c;
 611:	8b 45 f4             	mov    -0xc(%ebp),%eax
 614:	8d 50 01             	lea    0x1(%eax),%edx
 617:	89 55 f4             	mov    %edx,-0xc(%ebp)
 61a:	89 c2                	mov    %eax,%edx
 61c:	8b 45 08             	mov    0x8(%ebp),%eax
 61f:	01 c2                	add    %eax,%edx
 621:	8a 45 ef             	mov    -0x11(%ebp),%al
 624:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 626:	8a 45 ef             	mov    -0x11(%ebp),%al
 629:	3c 0a                	cmp    $0xa,%al
 62b:	74 10                	je     63d <gets+0x61>
 62d:	8a 45 ef             	mov    -0x11(%ebp),%al
 630:	3c 0d                	cmp    $0xd,%al
 632:	74 09                	je     63d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 634:	8b 45 f4             	mov    -0xc(%ebp),%eax
 637:	40                   	inc    %eax
 638:	3b 45 0c             	cmp    0xc(%ebp),%eax
 63b:	7c ae                	jl     5eb <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 63d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 640:	8b 45 08             	mov    0x8(%ebp),%eax
 643:	01 d0                	add    %edx,%eax
 645:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 648:	8b 45 08             	mov    0x8(%ebp),%eax
}
 64b:	c9                   	leave  
 64c:	c3                   	ret    

0000064d <stat>:

int
stat(char *n, struct stat *st)
{
 64d:	55                   	push   %ebp
 64e:	89 e5                	mov    %esp,%ebp
 650:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 653:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 65a:	00 
 65b:	8b 45 08             	mov    0x8(%ebp),%eax
 65e:	89 04 24             	mov    %eax,(%esp)
 661:	e8 06 01 00 00       	call   76c <open>
 666:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 669:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 66d:	79 07                	jns    676 <stat+0x29>
    return -1;
 66f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 674:	eb 23                	jmp    699 <stat+0x4c>
  r = fstat(fd, st);
 676:	8b 45 0c             	mov    0xc(%ebp),%eax
 679:	89 44 24 04          	mov    %eax,0x4(%esp)
 67d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 680:	89 04 24             	mov    %eax,(%esp)
 683:	e8 fc 00 00 00       	call   784 <fstat>
 688:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 68b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68e:	89 04 24             	mov    %eax,(%esp)
 691:	e8 be 00 00 00       	call   754 <close>
  return r;
 696:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 699:	c9                   	leave  
 69a:	c3                   	ret    

0000069b <atoi>:

int
atoi(const char *s)
{
 69b:	55                   	push   %ebp
 69c:	89 e5                	mov    %esp,%ebp
 69e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6a8:	eb 24                	jmp    6ce <atoi+0x33>
    n = n*10 + *s++ - '0';
 6aa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6ad:	89 d0                	mov    %edx,%eax
 6af:	c1 e0 02             	shl    $0x2,%eax
 6b2:	01 d0                	add    %edx,%eax
 6b4:	01 c0                	add    %eax,%eax
 6b6:	89 c1                	mov    %eax,%ecx
 6b8:	8b 45 08             	mov    0x8(%ebp),%eax
 6bb:	8d 50 01             	lea    0x1(%eax),%edx
 6be:	89 55 08             	mov    %edx,0x8(%ebp)
 6c1:	8a 00                	mov    (%eax),%al
 6c3:	0f be c0             	movsbl %al,%eax
 6c6:	01 c8                	add    %ecx,%eax
 6c8:	83 e8 30             	sub    $0x30,%eax
 6cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6ce:	8b 45 08             	mov    0x8(%ebp),%eax
 6d1:	8a 00                	mov    (%eax),%al
 6d3:	3c 2f                	cmp    $0x2f,%al
 6d5:	7e 09                	jle    6e0 <atoi+0x45>
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	8a 00                	mov    (%eax),%al
 6dc:	3c 39                	cmp    $0x39,%al
 6de:	7e ca                	jle    6aa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6e3:	c9                   	leave  
 6e4:	c3                   	ret    

000006e5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 6e5:	55                   	push   %ebp
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 6f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 6f7:	eb 16                	jmp    70f <memmove+0x2a>
    *dst++ = *src++;
 6f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fc:	8d 50 01             	lea    0x1(%eax),%edx
 6ff:	89 55 fc             	mov    %edx,-0x4(%ebp)
 702:	8b 55 f8             	mov    -0x8(%ebp),%edx
 705:	8d 4a 01             	lea    0x1(%edx),%ecx
 708:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 70b:	8a 12                	mov    (%edx),%dl
 70d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 70f:	8b 45 10             	mov    0x10(%ebp),%eax
 712:	8d 50 ff             	lea    -0x1(%eax),%edx
 715:	89 55 10             	mov    %edx,0x10(%ebp)
 718:	85 c0                	test   %eax,%eax
 71a:	7f dd                	jg     6f9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 71f:	c9                   	leave  
 720:	c3                   	ret    
 721:	90                   	nop
 722:	90                   	nop
 723:	90                   	nop

00000724 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 724:	b8 01 00 00 00       	mov    $0x1,%eax
 729:	cd 40                	int    $0x40
 72b:	c3                   	ret    

0000072c <exit>:
SYSCALL(exit)
 72c:	b8 02 00 00 00       	mov    $0x2,%eax
 731:	cd 40                	int    $0x40
 733:	c3                   	ret    

00000734 <wait>:
SYSCALL(wait)
 734:	b8 03 00 00 00       	mov    $0x3,%eax
 739:	cd 40                	int    $0x40
 73b:	c3                   	ret    

0000073c <pipe>:
SYSCALL(pipe)
 73c:	b8 04 00 00 00       	mov    $0x4,%eax
 741:	cd 40                	int    $0x40
 743:	c3                   	ret    

00000744 <read>:
SYSCALL(read)
 744:	b8 05 00 00 00       	mov    $0x5,%eax
 749:	cd 40                	int    $0x40
 74b:	c3                   	ret    

0000074c <write>:
SYSCALL(write)
 74c:	b8 10 00 00 00       	mov    $0x10,%eax
 751:	cd 40                	int    $0x40
 753:	c3                   	ret    

00000754 <close>:
SYSCALL(close)
 754:	b8 15 00 00 00       	mov    $0x15,%eax
 759:	cd 40                	int    $0x40
 75b:	c3                   	ret    

0000075c <kill>:
SYSCALL(kill)
 75c:	b8 06 00 00 00       	mov    $0x6,%eax
 761:	cd 40                	int    $0x40
 763:	c3                   	ret    

00000764 <exec>:
SYSCALL(exec)
 764:	b8 07 00 00 00       	mov    $0x7,%eax
 769:	cd 40                	int    $0x40
 76b:	c3                   	ret    

0000076c <open>:
SYSCALL(open)
 76c:	b8 0f 00 00 00       	mov    $0xf,%eax
 771:	cd 40                	int    $0x40
 773:	c3                   	ret    

00000774 <mknod>:
SYSCALL(mknod)
 774:	b8 11 00 00 00       	mov    $0x11,%eax
 779:	cd 40                	int    $0x40
 77b:	c3                   	ret    

0000077c <unlink>:
SYSCALL(unlink)
 77c:	b8 12 00 00 00       	mov    $0x12,%eax
 781:	cd 40                	int    $0x40
 783:	c3                   	ret    

00000784 <fstat>:
SYSCALL(fstat)
 784:	b8 08 00 00 00       	mov    $0x8,%eax
 789:	cd 40                	int    $0x40
 78b:	c3                   	ret    

0000078c <link>:
SYSCALL(link)
 78c:	b8 13 00 00 00       	mov    $0x13,%eax
 791:	cd 40                	int    $0x40
 793:	c3                   	ret    

00000794 <mkdir>:
SYSCALL(mkdir)
 794:	b8 14 00 00 00       	mov    $0x14,%eax
 799:	cd 40                	int    $0x40
 79b:	c3                   	ret    

0000079c <chdir>:
SYSCALL(chdir)
 79c:	b8 09 00 00 00       	mov    $0x9,%eax
 7a1:	cd 40                	int    $0x40
 7a3:	c3                   	ret    

000007a4 <dup>:
SYSCALL(dup)
 7a4:	b8 0a 00 00 00       	mov    $0xa,%eax
 7a9:	cd 40                	int    $0x40
 7ab:	c3                   	ret    

000007ac <getpid>:
SYSCALL(getpid)
 7ac:	b8 0b 00 00 00       	mov    $0xb,%eax
 7b1:	cd 40                	int    $0x40
 7b3:	c3                   	ret    

000007b4 <sbrk>:
SYSCALL(sbrk)
 7b4:	b8 0c 00 00 00       	mov    $0xc,%eax
 7b9:	cd 40                	int    $0x40
 7bb:	c3                   	ret    

000007bc <sleep>:
SYSCALL(sleep)
 7bc:	b8 0d 00 00 00       	mov    $0xd,%eax
 7c1:	cd 40                	int    $0x40
 7c3:	c3                   	ret    

000007c4 <uptime>:
SYSCALL(uptime)
 7c4:	b8 0e 00 00 00       	mov    $0xe,%eax
 7c9:	cd 40                	int    $0x40
 7cb:	c3                   	ret    

000007cc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7cc:	55                   	push   %ebp
 7cd:	89 e5                	mov    %esp,%ebp
 7cf:	83 ec 18             	sub    $0x18,%esp
 7d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7d5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7d8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7df:	00 
 7e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7e7:	8b 45 08             	mov    0x8(%ebp),%eax
 7ea:	89 04 24             	mov    %eax,(%esp)
 7ed:	e8 5a ff ff ff       	call   74c <write>
}
 7f2:	c9                   	leave  
 7f3:	c3                   	ret    

000007f4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7f4:	55                   	push   %ebp
 7f5:	89 e5                	mov    %esp,%ebp
 7f7:	56                   	push   %esi
 7f8:	53                   	push   %ebx
 7f9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 803:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 807:	74 17                	je     820 <printint+0x2c>
 809:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 80d:	79 11                	jns    820 <printint+0x2c>
    neg = 1;
 80f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 816:	8b 45 0c             	mov    0xc(%ebp),%eax
 819:	f7 d8                	neg    %eax
 81b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 81e:	eb 06                	jmp    826 <printint+0x32>
  } else {
    x = xx;
 820:	8b 45 0c             	mov    0xc(%ebp),%eax
 823:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 826:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 82d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 830:	8d 41 01             	lea    0x1(%ecx),%eax
 833:	89 45 f4             	mov    %eax,-0xc(%ebp)
 836:	8b 5d 10             	mov    0x10(%ebp),%ebx
 839:	8b 45 ec             	mov    -0x14(%ebp),%eax
 83c:	ba 00 00 00 00       	mov    $0x0,%edx
 841:	f7 f3                	div    %ebx
 843:	89 d0                	mov    %edx,%eax
 845:	8a 80 4c 10 00 00    	mov    0x104c(%eax),%al
 84b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 84f:	8b 75 10             	mov    0x10(%ebp),%esi
 852:	8b 45 ec             	mov    -0x14(%ebp),%eax
 855:	ba 00 00 00 00       	mov    $0x0,%edx
 85a:	f7 f6                	div    %esi
 85c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 85f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 863:	75 c8                	jne    82d <printint+0x39>
  if(neg)
 865:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 869:	74 10                	je     87b <printint+0x87>
    buf[i++] = '-';
 86b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86e:	8d 50 01             	lea    0x1(%eax),%edx
 871:	89 55 f4             	mov    %edx,-0xc(%ebp)
 874:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 879:	eb 1e                	jmp    899 <printint+0xa5>
 87b:	eb 1c                	jmp    899 <printint+0xa5>
    putc(fd, buf[i]);
 87d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 880:	8b 45 f4             	mov    -0xc(%ebp),%eax
 883:	01 d0                	add    %edx,%eax
 885:	8a 00                	mov    (%eax),%al
 887:	0f be c0             	movsbl %al,%eax
 88a:	89 44 24 04          	mov    %eax,0x4(%esp)
 88e:	8b 45 08             	mov    0x8(%ebp),%eax
 891:	89 04 24             	mov    %eax,(%esp)
 894:	e8 33 ff ff ff       	call   7cc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 899:	ff 4d f4             	decl   -0xc(%ebp)
 89c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8a0:	79 db                	jns    87d <printint+0x89>
    putc(fd, buf[i]);
}
 8a2:	83 c4 30             	add    $0x30,%esp
 8a5:	5b                   	pop    %ebx
 8a6:	5e                   	pop    %esi
 8a7:	5d                   	pop    %ebp
 8a8:	c3                   	ret    

000008a9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8a9:	55                   	push   %ebp
 8aa:	89 e5                	mov    %esp,%ebp
 8ac:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8b6:	8d 45 0c             	lea    0xc(%ebp),%eax
 8b9:	83 c0 04             	add    $0x4,%eax
 8bc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8c6:	e9 77 01 00 00       	jmp    a42 <printf+0x199>
    c = fmt[i] & 0xff;
 8cb:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d1:	01 d0                	add    %edx,%eax
 8d3:	8a 00                	mov    (%eax),%al
 8d5:	0f be c0             	movsbl %al,%eax
 8d8:	25 ff 00 00 00       	and    $0xff,%eax
 8dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e4:	75 2c                	jne    912 <printf+0x69>
      if(c == '%'){
 8e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8ea:	75 0c                	jne    8f8 <printf+0x4f>
        state = '%';
 8ec:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8f3:	e9 47 01 00 00       	jmp    a3f <printf+0x196>
      } else {
        putc(fd, c);
 8f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8fb:	0f be c0             	movsbl %al,%eax
 8fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 902:	8b 45 08             	mov    0x8(%ebp),%eax
 905:	89 04 24             	mov    %eax,(%esp)
 908:	e8 bf fe ff ff       	call   7cc <putc>
 90d:	e9 2d 01 00 00       	jmp    a3f <printf+0x196>
      }
    } else if(state == '%'){
 912:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 916:	0f 85 23 01 00 00    	jne    a3f <printf+0x196>
      if(c == 'd'){
 91c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 920:	75 2d                	jne    94f <printf+0xa6>
        printint(fd, *ap, 10, 1);
 922:	8b 45 e8             	mov    -0x18(%ebp),%eax
 925:	8b 00                	mov    (%eax),%eax
 927:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 92e:	00 
 92f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 936:	00 
 937:	89 44 24 04          	mov    %eax,0x4(%esp)
 93b:	8b 45 08             	mov    0x8(%ebp),%eax
 93e:	89 04 24             	mov    %eax,(%esp)
 941:	e8 ae fe ff ff       	call   7f4 <printint>
        ap++;
 946:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 94a:	e9 e9 00 00 00       	jmp    a38 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 94f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 953:	74 06                	je     95b <printf+0xb2>
 955:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 959:	75 2d                	jne    988 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 95b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 967:	00 
 968:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 96f:	00 
 970:	89 44 24 04          	mov    %eax,0x4(%esp)
 974:	8b 45 08             	mov    0x8(%ebp),%eax
 977:	89 04 24             	mov    %eax,(%esp)
 97a:	e8 75 fe ff ff       	call   7f4 <printint>
        ap++;
 97f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 983:	e9 b0 00 00 00       	jmp    a38 <printf+0x18f>
      } else if(c == 's'){
 988:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 98c:	75 42                	jne    9d0 <printf+0x127>
        s = (char*)*ap;
 98e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 991:	8b 00                	mov    (%eax),%eax
 993:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 996:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 99a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 99e:	75 09                	jne    9a9 <printf+0x100>
          s = "(null)";
 9a0:	c7 45 f4 96 0c 00 00 	movl   $0xc96,-0xc(%ebp)
        while(*s != 0){
 9a7:	eb 1c                	jmp    9c5 <printf+0x11c>
 9a9:	eb 1a                	jmp    9c5 <printf+0x11c>
          putc(fd, *s);
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	8a 00                	mov    (%eax),%al
 9b0:	0f be c0             	movsbl %al,%eax
 9b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	89 04 24             	mov    %eax,(%esp)
 9bd:	e8 0a fe ff ff       	call   7cc <putc>
          s++;
 9c2:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c8:	8a 00                	mov    (%eax),%al
 9ca:	84 c0                	test   %al,%al
 9cc:	75 dd                	jne    9ab <printf+0x102>
 9ce:	eb 68                	jmp    a38 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9d0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9d4:	75 1d                	jne    9f3 <printf+0x14a>
        putc(fd, *ap);
 9d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9d9:	8b 00                	mov    (%eax),%eax
 9db:	0f be c0             	movsbl %al,%eax
 9de:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e2:	8b 45 08             	mov    0x8(%ebp),%eax
 9e5:	89 04 24             	mov    %eax,(%esp)
 9e8:	e8 df fd ff ff       	call   7cc <putc>
        ap++;
 9ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9f1:	eb 45                	jmp    a38 <printf+0x18f>
      } else if(c == '%'){
 9f3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9f7:	75 17                	jne    a10 <printf+0x167>
        putc(fd, c);
 9f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9fc:	0f be c0             	movsbl %al,%eax
 9ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 a03:	8b 45 08             	mov    0x8(%ebp),%eax
 a06:	89 04 24             	mov    %eax,(%esp)
 a09:	e8 be fd ff ff       	call   7cc <putc>
 a0e:	eb 28                	jmp    a38 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a10:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a17:	00 
 a18:	8b 45 08             	mov    0x8(%ebp),%eax
 a1b:	89 04 24             	mov    %eax,(%esp)
 a1e:	e8 a9 fd ff ff       	call   7cc <putc>
        putc(fd, c);
 a23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a26:	0f be c0             	movsbl %al,%eax
 a29:	89 44 24 04          	mov    %eax,0x4(%esp)
 a2d:	8b 45 08             	mov    0x8(%ebp),%eax
 a30:	89 04 24             	mov    %eax,(%esp)
 a33:	e8 94 fd ff ff       	call   7cc <putc>
      }
      state = 0;
 a38:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a3f:	ff 45 f0             	incl   -0x10(%ebp)
 a42:	8b 55 0c             	mov    0xc(%ebp),%edx
 a45:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a48:	01 d0                	add    %edx,%eax
 a4a:	8a 00                	mov    (%eax),%al
 a4c:	84 c0                	test   %al,%al
 a4e:	0f 85 77 fe ff ff    	jne    8cb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a54:	c9                   	leave  
 a55:	c3                   	ret    
 a56:	90                   	nop
 a57:	90                   	nop

00000a58 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a58:	55                   	push   %ebp
 a59:	89 e5                	mov    %esp,%ebp
 a5b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a5e:	8b 45 08             	mov    0x8(%ebp),%eax
 a61:	83 e8 08             	sub    $0x8,%eax
 a64:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a67:	a1 70 10 00 00       	mov    0x1070,%eax
 a6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a6f:	eb 24                	jmp    a95 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a74:	8b 00                	mov    (%eax),%eax
 a76:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a79:	77 12                	ja     a8d <free+0x35>
 a7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a7e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a81:	77 24                	ja     aa7 <free+0x4f>
 a83:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a86:	8b 00                	mov    (%eax),%eax
 a88:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a8b:	77 1a                	ja     aa7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a90:	8b 00                	mov    (%eax),%eax
 a92:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a95:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a98:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a9b:	76 d4                	jbe    a71 <free+0x19>
 a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa0:	8b 00                	mov    (%eax),%eax
 aa2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 aa5:	76 ca                	jbe    a71 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 aa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aaa:	8b 40 04             	mov    0x4(%eax),%eax
 aad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ab4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab7:	01 c2                	add    %eax,%edx
 ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abc:	8b 00                	mov    (%eax),%eax
 abe:	39 c2                	cmp    %eax,%edx
 ac0:	75 24                	jne    ae6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ac2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac5:	8b 50 04             	mov    0x4(%eax),%edx
 ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acb:	8b 00                	mov    (%eax),%eax
 acd:	8b 40 04             	mov    0x4(%eax),%eax
 ad0:	01 c2                	add    %eax,%edx
 ad2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 ad8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 adb:	8b 00                	mov    (%eax),%eax
 add:	8b 10                	mov    (%eax),%edx
 adf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae2:	89 10                	mov    %edx,(%eax)
 ae4:	eb 0a                	jmp    af0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ae6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae9:	8b 10                	mov    (%eax),%edx
 aeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aee:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af3:	8b 40 04             	mov    0x4(%eax),%eax
 af6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b00:	01 d0                	add    %edx,%eax
 b02:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b05:	75 20                	jne    b27 <free+0xcf>
    p->s.size += bp->s.size;
 b07:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b0a:	8b 50 04             	mov    0x4(%eax),%edx
 b0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b10:	8b 40 04             	mov    0x4(%eax),%eax
 b13:	01 c2                	add    %eax,%edx
 b15:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b18:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1e:	8b 10                	mov    (%eax),%edx
 b20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b23:	89 10                	mov    %edx,(%eax)
 b25:	eb 08                	jmp    b2f <free+0xd7>
  } else
    p->s.ptr = bp;
 b27:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b2d:	89 10                	mov    %edx,(%eax)
  freep = p;
 b2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b32:	a3 70 10 00 00       	mov    %eax,0x1070
}
 b37:	c9                   	leave  
 b38:	c3                   	ret    

00000b39 <morecore>:

static Header*
morecore(uint nu)
{
 b39:	55                   	push   %ebp
 b3a:	89 e5                	mov    %esp,%ebp
 b3c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b3f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b46:	77 07                	ja     b4f <morecore+0x16>
    nu = 4096;
 b48:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b4f:	8b 45 08             	mov    0x8(%ebp),%eax
 b52:	c1 e0 03             	shl    $0x3,%eax
 b55:	89 04 24             	mov    %eax,(%esp)
 b58:	e8 57 fc ff ff       	call   7b4 <sbrk>
 b5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b60:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b64:	75 07                	jne    b6d <morecore+0x34>
    return 0;
 b66:	b8 00 00 00 00       	mov    $0x0,%eax
 b6b:	eb 22                	jmp    b8f <morecore+0x56>
  hp = (Header*)p;
 b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b73:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b76:	8b 55 08             	mov    0x8(%ebp),%edx
 b79:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b7f:	83 c0 08             	add    $0x8,%eax
 b82:	89 04 24             	mov    %eax,(%esp)
 b85:	e8 ce fe ff ff       	call   a58 <free>
  return freep;
 b8a:	a1 70 10 00 00       	mov    0x1070,%eax
}
 b8f:	c9                   	leave  
 b90:	c3                   	ret    

00000b91 <malloc>:

void*
malloc(uint nbytes)
{
 b91:	55                   	push   %ebp
 b92:	89 e5                	mov    %esp,%ebp
 b94:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b97:	8b 45 08             	mov    0x8(%ebp),%eax
 b9a:	83 c0 07             	add    $0x7,%eax
 b9d:	c1 e8 03             	shr    $0x3,%eax
 ba0:	40                   	inc    %eax
 ba1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 ba4:	a1 70 10 00 00       	mov    0x1070,%eax
 ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bb0:	75 23                	jne    bd5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 bb2:	c7 45 f0 68 10 00 00 	movl   $0x1068,-0x10(%ebp)
 bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bbc:	a3 70 10 00 00       	mov    %eax,0x1070
 bc1:	a1 70 10 00 00       	mov    0x1070,%eax
 bc6:	a3 68 10 00 00       	mov    %eax,0x1068
    base.s.size = 0;
 bcb:	c7 05 6c 10 00 00 00 	movl   $0x0,0x106c
 bd2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bd8:	8b 00                	mov    (%eax),%eax
 bda:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be0:	8b 40 04             	mov    0x4(%eax),%eax
 be3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 be6:	72 4d                	jb     c35 <malloc+0xa4>
      if(p->s.size == nunits)
 be8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 beb:	8b 40 04             	mov    0x4(%eax),%eax
 bee:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bf1:	75 0c                	jne    bff <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf6:	8b 10                	mov    (%eax),%edx
 bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bfb:	89 10                	mov    %edx,(%eax)
 bfd:	eb 26                	jmp    c25 <malloc+0x94>
      else {
        p->s.size -= nunits;
 bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c02:	8b 40 04             	mov    0x4(%eax),%eax
 c05:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c08:	89 c2                	mov    %eax,%edx
 c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c13:	8b 40 04             	mov    0x4(%eax),%eax
 c16:	c1 e0 03             	shl    $0x3,%eax
 c19:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c22:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c28:	a3 70 10 00 00       	mov    %eax,0x1070
      return (void*)(p + 1);
 c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c30:	83 c0 08             	add    $0x8,%eax
 c33:	eb 38                	jmp    c6d <malloc+0xdc>
    }
    if(p == freep)
 c35:	a1 70 10 00 00       	mov    0x1070,%eax
 c3a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c3d:	75 1b                	jne    c5a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 c3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c42:	89 04 24             	mov    %eax,(%esp)
 c45:	e8 ef fe ff ff       	call   b39 <morecore>
 c4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c51:	75 07                	jne    c5a <malloc+0xc9>
        return 0;
 c53:	b8 00 00 00 00       	mov    $0x0,%eax
 c58:	eb 13                	jmp    c6d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c63:	8b 00                	mov    (%eax),%eax
 c65:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c68:	e9 70 ff ff ff       	jmp    bdd <malloc+0x4c>
}
 c6d:	c9                   	leave  
 c6e:	c3                   	ret    
