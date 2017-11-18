
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
  1d:	b8 5f 0c 00 00       	mov    $0xc5f,%eax
  22:	eb 05                	jmp    29 <main+0x29>
  24:	b8 61 0c 00 00       	mov    $0xc61,%eax
  29:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2d:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  37:	01 ca                	add    %ecx,%edx
  39:	8b 12                	mov    (%edx),%edx
  3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  43:	c7 44 24 04 63 0c 00 	movl   $0xc63,0x4(%esp)
  4a:	00 
  4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  52:	e8 42 08 00 00       	call   899 <printf>
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
  64:	e8 b3 06 00 00       	call   71c <exit>
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

000000bf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bf:	55                   	push   %ebp
  c0:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c2:	eb 06                	jmp    ca <strcmp+0xb>
    p++, q++;
  c4:	ff 45 08             	incl   0x8(%ebp)
  c7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	8a 00                	mov    (%eax),%al
  cf:	84 c0                	test   %al,%al
  d1:	74 0e                	je     e1 <strcmp+0x22>
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	8a 10                	mov    (%eax),%dl
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	8a 00                	mov    (%eax),%al
  dd:	38 c2                	cmp    %al,%dl
  df:	74 e3                	je     c4 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	8a 00                	mov    (%eax),%al
  e6:	0f b6 d0             	movzbl %al,%edx
  e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  ec:	8a 00                	mov    (%eax),%al
  ee:	0f b6 c0             	movzbl %al,%eax
  f1:	29 c2                	sub    %eax,%edx
  f3:	89 d0                	mov    %edx,%eax
}
  f5:	5d                   	pop    %ebp
  f6:	c3                   	ret    

000000f7 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  f7:	55                   	push   %ebp
  f8:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
  fa:	eb 09                	jmp    105 <strncmp+0xe>
    n--, p++, q++;
  fc:	ff 4d 10             	decl   0x10(%ebp)
  ff:	ff 45 08             	incl   0x8(%ebp)
 102:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 105:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 109:	74 17                	je     122 <strncmp+0x2b>
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	8a 00                	mov    (%eax),%al
 110:	84 c0                	test   %al,%al
 112:	74 0e                	je     122 <strncmp+0x2b>
 114:	8b 45 08             	mov    0x8(%ebp),%eax
 117:	8a 10                	mov    (%eax),%dl
 119:	8b 45 0c             	mov    0xc(%ebp),%eax
 11c:	8a 00                	mov    (%eax),%al
 11e:	38 c2                	cmp    %al,%dl
 120:	74 da                	je     fc <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 122:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 126:	75 07                	jne    12f <strncmp+0x38>
    return 0;
 128:	b8 00 00 00 00       	mov    $0x0,%eax
 12d:	eb 14                	jmp    143 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	8a 00                	mov    (%eax),%al
 134:	0f b6 d0             	movzbl %al,%edx
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	8a 00                	mov    (%eax),%al
 13c:	0f b6 c0             	movzbl %al,%eax
 13f:	29 c2                	sub    %eax,%edx
 141:	89 d0                	mov    %edx,%eax
}
 143:	5d                   	pop    %ebp
 144:	c3                   	ret    

00000145 <strlen>:

uint
strlen(const char *s)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 14b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 152:	eb 03                	jmp    157 <strlen+0x12>
 154:	ff 45 fc             	incl   -0x4(%ebp)
 157:	8b 55 fc             	mov    -0x4(%ebp),%edx
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	01 d0                	add    %edx,%eax
 15f:	8a 00                	mov    (%eax),%al
 161:	84 c0                	test   %al,%al
 163:	75 ef                	jne    154 <strlen+0xf>
    ;
  return n;
 165:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 168:	c9                   	leave  
 169:	c3                   	ret    

0000016a <memset>:

void*
memset(void *dst, int c, uint n)
{
 16a:	55                   	push   %ebp
 16b:	89 e5                	mov    %esp,%ebp
 16d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 170:	8b 45 10             	mov    0x10(%ebp),%eax
 173:	89 44 24 08          	mov    %eax,0x8(%esp)
 177:	8b 45 0c             	mov    0xc(%ebp),%eax
 17a:	89 44 24 04          	mov    %eax,0x4(%esp)
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	89 04 24             	mov    %eax,(%esp)
 184:	e8 e3 fe ff ff       	call   6c <stosb>
  return dst;
 189:	8b 45 08             	mov    0x8(%ebp),%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <strchr>:

char*
strchr(const char *s, char c)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 04             	sub    $0x4,%esp
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 19a:	eb 12                	jmp    1ae <strchr+0x20>
    if(*s == c)
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	8a 00                	mov    (%eax),%al
 1a1:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a4:	75 05                	jne    1ab <strchr+0x1d>
      return (char*)s;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	eb 11                	jmp    1bc <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1ab:	ff 45 08             	incl   0x8(%ebp)
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	8a 00                	mov    (%eax),%al
 1b3:	84 c0                	test   %al,%al
 1b5:	75 e5                	jne    19c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1bc:	c9                   	leave  
 1bd:	c3                   	ret    

000001be <strcat>:

char *
strcat(char *dest, const char *src)
{
 1be:	55                   	push   %ebp
 1bf:	89 e5                	mov    %esp,%ebp
 1c1:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 1c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1cb:	eb 03                	jmp    1d0 <strcat+0x12>
 1cd:	ff 45 fc             	incl   -0x4(%ebp)
 1d0:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d3:	8b 45 08             	mov    0x8(%ebp),%eax
 1d6:	01 d0                	add    %edx,%eax
 1d8:	8a 00                	mov    (%eax),%al
 1da:	84 c0                	test   %al,%al
 1dc:	75 ef                	jne    1cd <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 1de:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 1e5:	eb 1e                	jmp    205 <strcat+0x47>
        dest[i+j] = src[j];
 1e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 1ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ed:	01 d0                	add    %edx,%eax
 1ef:	89 c2                	mov    %eax,%edx
 1f1:	8b 45 08             	mov    0x8(%ebp),%eax
 1f4:	01 c2                	add    %eax,%edx
 1f6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 1f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fc:	01 c8                	add    %ecx,%eax
 1fe:	8a 00                	mov    (%eax),%al
 200:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 202:	ff 45 f8             	incl   -0x8(%ebp)
 205:	8b 55 f8             	mov    -0x8(%ebp),%edx
 208:	8b 45 0c             	mov    0xc(%ebp),%eax
 20b:	01 d0                	add    %edx,%eax
 20d:	8a 00                	mov    (%eax),%al
 20f:	84 c0                	test   %al,%al
 211:	75 d4                	jne    1e7 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 213:	8b 45 f8             	mov    -0x8(%ebp),%eax
 216:	8b 55 fc             	mov    -0x4(%ebp),%edx
 219:	01 d0                	add    %edx,%eax
 21b:	89 c2                	mov    %eax,%edx
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	01 d0                	add    %edx,%eax
 222:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 225:	8b 45 08             	mov    0x8(%ebp),%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <strstr>:

int 
strstr(char* s, char* sub)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 230:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 237:	eb 7c                	jmp    2b5 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 239:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	01 d0                	add    %edx,%eax
 241:	8a 10                	mov    (%eax),%dl
 243:	8b 45 0c             	mov    0xc(%ebp),%eax
 246:	8a 00                	mov    (%eax),%al
 248:	38 c2                	cmp    %al,%dl
 24a:	75 66                	jne    2b2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 24c:	8b 45 0c             	mov    0xc(%ebp),%eax
 24f:	89 04 24             	mov    %eax,(%esp)
 252:	e8 ee fe ff ff       	call   145 <strlen>
 257:	83 f8 01             	cmp    $0x1,%eax
 25a:	75 05                	jne    261 <strstr+0x37>
            {  
                return i;
 25c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25f:	eb 6b                	jmp    2cc <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 261:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 268:	eb 3a                	jmp    2a4 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 26a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 26d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 270:	01 d0                	add    %edx,%eax
 272:	89 c2                	mov    %eax,%edx
 274:	8b 45 08             	mov    0x8(%ebp),%eax
 277:	01 d0                	add    %edx,%eax
 279:	8a 10                	mov    (%eax),%dl
 27b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	01 c8                	add    %ecx,%eax
 283:	8a 00                	mov    (%eax),%al
 285:	38 c2                	cmp    %al,%dl
 287:	75 16                	jne    29f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 289:	8b 45 f8             	mov    -0x8(%ebp),%eax
 28c:	8d 50 01             	lea    0x1(%eax),%edx
 28f:	8b 45 0c             	mov    0xc(%ebp),%eax
 292:	01 d0                	add    %edx,%eax
 294:	8a 00                	mov    (%eax),%al
 296:	84 c0                	test   %al,%al
 298:	75 07                	jne    2a1 <strstr+0x77>
                    {
                        return i;
 29a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29d:	eb 2d                	jmp    2cc <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 29f:	eb 11                	jmp    2b2 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 2a1:	ff 45 f8             	incl   -0x8(%ebp)
 2a4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2aa:	01 d0                	add    %edx,%eax
 2ac:	8a 00                	mov    (%eax),%al
 2ae:	84 c0                	test   %al,%al
 2b0:	75 b8                	jne    26a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2b2:	ff 45 fc             	incl   -0x4(%ebp)
 2b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	01 d0                	add    %edx,%eax
 2bd:	8a 00                	mov    (%eax),%al
 2bf:	84 c0                	test   %al,%al
 2c1:	0f 85 72 ff ff ff    	jne    239 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 2c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 2cc:	c9                   	leave  
 2cd:	c3                   	ret    

000002ce <strtok>:

char *
strtok(char *s, const char *delim)
{
 2ce:	55                   	push   %ebp
 2cf:	89 e5                	mov    %esp,%ebp
 2d1:	53                   	push   %ebx
 2d2:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 2d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d9:	75 08                	jne    2e3 <strtok+0x15>
  s = lasts;
 2db:	a1 44 10 00 00       	mov    0x1044,%eax
 2e0:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8d 50 01             	lea    0x1(%eax),%edx
 2e9:	89 55 08             	mov    %edx,0x8(%ebp)
 2ec:	8a 00                	mov    (%eax),%al
 2ee:	0f be d8             	movsbl %al,%ebx
 2f1:	85 db                	test   %ebx,%ebx
 2f3:	75 07                	jne    2fc <strtok+0x2e>
      return 0;
 2f5:	b8 00 00 00 00       	mov    $0x0,%eax
 2fa:	eb 58                	jmp    354 <strtok+0x86>
    } while (strchr(delim, ch));
 2fc:	88 d8                	mov    %bl,%al
 2fe:	0f be c0             	movsbl %al,%eax
 301:	89 44 24 04          	mov    %eax,0x4(%esp)
 305:	8b 45 0c             	mov    0xc(%ebp),%eax
 308:	89 04 24             	mov    %eax,(%esp)
 30b:	e8 7e fe ff ff       	call   18e <strchr>
 310:	85 c0                	test   %eax,%eax
 312:	75 cf                	jne    2e3 <strtok+0x15>
    --s;
 314:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 317:	8b 45 0c             	mov    0xc(%ebp),%eax
 31a:	89 44 24 04          	mov    %eax,0x4(%esp)
 31e:	8b 45 08             	mov    0x8(%ebp),%eax
 321:	89 04 24             	mov    %eax,(%esp)
 324:	e8 31 00 00 00       	call   35a <strcspn>
 329:	89 c2                	mov    %eax,%edx
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	01 d0                	add    %edx,%eax
 330:	a3 44 10 00 00       	mov    %eax,0x1044
    if (*lasts != 0)
 335:	a1 44 10 00 00       	mov    0x1044,%eax
 33a:	8a 00                	mov    (%eax),%al
 33c:	84 c0                	test   %al,%al
 33e:	74 11                	je     351 <strtok+0x83>
  *lasts++ = 0;
 340:	a1 44 10 00 00       	mov    0x1044,%eax
 345:	8d 50 01             	lea    0x1(%eax),%edx
 348:	89 15 44 10 00 00    	mov    %edx,0x1044
 34e:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 351:	8b 45 08             	mov    0x8(%ebp),%eax
}
 354:	83 c4 14             	add    $0x14,%esp
 357:	5b                   	pop    %ebx
 358:	5d                   	pop    %ebp
 359:	c3                   	ret    

0000035a <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 360:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 367:	eb 26                	jmp    38f <strcspn+0x35>
        if(strchr(s2,*s1))
 369:	8b 45 08             	mov    0x8(%ebp),%eax
 36c:	8a 00                	mov    (%eax),%al
 36e:	0f be c0             	movsbl %al,%eax
 371:	89 44 24 04          	mov    %eax,0x4(%esp)
 375:	8b 45 0c             	mov    0xc(%ebp),%eax
 378:	89 04 24             	mov    %eax,(%esp)
 37b:	e8 0e fe ff ff       	call   18e <strchr>
 380:	85 c0                	test   %eax,%eax
 382:	74 05                	je     389 <strcspn+0x2f>
            return ret;
 384:	8b 45 fc             	mov    -0x4(%ebp),%eax
 387:	eb 12                	jmp    39b <strcspn+0x41>
        else
            s1++,ret++;
 389:	ff 45 08             	incl   0x8(%ebp)
 38c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 38f:	8b 45 08             	mov    0x8(%ebp),%eax
 392:	8a 00                	mov    (%eax),%al
 394:	84 c0                	test   %al,%al
 396:	75 d1                	jne    369 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 398:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 39b:	c9                   	leave  
 39c:	c3                   	ret    

0000039d <isspace>:

int
isspace(unsigned char c)
{
 39d:	55                   	push   %ebp
 39e:	89 e5                	mov    %esp,%ebp
 3a0:	83 ec 04             	sub    $0x4,%esp
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 3a9:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 3ad:	74 1e                	je     3cd <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 3af:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 3b3:	74 18                	je     3cd <isspace+0x30>
 3b5:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 3b9:	74 12                	je     3cd <isspace+0x30>
 3bb:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 3bf:	74 0c                	je     3cd <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 3c1:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 3c5:	74 06                	je     3cd <isspace+0x30>
 3c7:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 3cb:	75 07                	jne    3d4 <isspace+0x37>
 3cd:	b8 01 00 00 00       	mov    $0x1,%eax
 3d2:	eb 05                	jmp    3d9 <isspace+0x3c>
 3d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3d9:	c9                   	leave  
 3da:	c3                   	ret    

000003db <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 3db:	55                   	push   %ebp
 3dc:	89 e5                	mov    %esp,%ebp
 3de:	57                   	push   %edi
 3df:	56                   	push   %esi
 3e0:	53                   	push   %ebx
 3e1:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 3e4:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 3e9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 3f0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 3f3:	eb 01                	jmp    3f6 <strtoul+0x1b>
  p += 1;
 3f5:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 3f6:	8a 03                	mov    (%ebx),%al
 3f8:	0f b6 c0             	movzbl %al,%eax
 3fb:	89 04 24             	mov    %eax,(%esp)
 3fe:	e8 9a ff ff ff       	call   39d <isspace>
 403:	85 c0                	test   %eax,%eax
 405:	75 ee                	jne    3f5 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 407:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 40b:	75 30                	jne    43d <strtoul+0x62>
    {
  if (*p == '0') {
 40d:	8a 03                	mov    (%ebx),%al
 40f:	3c 30                	cmp    $0x30,%al
 411:	75 21                	jne    434 <strtoul+0x59>
      p += 1;
 413:	43                   	inc    %ebx
      if (*p == 'x') {
 414:	8a 03                	mov    (%ebx),%al
 416:	3c 78                	cmp    $0x78,%al
 418:	75 0a                	jne    424 <strtoul+0x49>
    p += 1;
 41a:	43                   	inc    %ebx
    base = 16;
 41b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 422:	eb 31                	jmp    455 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 424:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 42b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 432:	eb 21                	jmp    455 <strtoul+0x7a>
      }
  }
  else base = 10;
 434:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 43b:	eb 18                	jmp    455 <strtoul+0x7a>
    } else if (base == 16) {
 43d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 441:	75 12                	jne    455 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 443:	8a 03                	mov    (%ebx),%al
 445:	3c 30                	cmp    $0x30,%al
 447:	75 0c                	jne    455 <strtoul+0x7a>
 449:	8d 43 01             	lea    0x1(%ebx),%eax
 44c:	8a 00                	mov    (%eax),%al
 44e:	3c 78                	cmp    $0x78,%al
 450:	75 03                	jne    455 <strtoul+0x7a>
      p += 2;
 452:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 455:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 459:	75 29                	jne    484 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 45b:	8a 03                	mov    (%ebx),%al
 45d:	0f be c0             	movsbl %al,%eax
 460:	83 e8 30             	sub    $0x30,%eax
 463:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 465:	83 fe 07             	cmp    $0x7,%esi
 468:	76 06                	jbe    470 <strtoul+0x95>
    break;
 46a:	90                   	nop
 46b:	e9 b6 00 00 00       	jmp    526 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 470:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 477:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 47a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 481:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 482:	eb d7                	jmp    45b <strtoul+0x80>
    } else if (base == 10) {
 484:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 488:	75 2b                	jne    4b5 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 48a:	8a 03                	mov    (%ebx),%al
 48c:	0f be c0             	movsbl %al,%eax
 48f:	83 e8 30             	sub    $0x30,%eax
 492:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 494:	83 fe 09             	cmp    $0x9,%esi
 497:	76 06                	jbe    49f <strtoul+0xc4>
    break;
 499:	90                   	nop
 49a:	e9 87 00 00 00       	jmp    526 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 49f:	89 f8                	mov    %edi,%eax
 4a1:	c1 e0 02             	shl    $0x2,%eax
 4a4:	01 f8                	add    %edi,%eax
 4a6:	01 c0                	add    %eax,%eax
 4a8:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4ab:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 4b2:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 4b3:	eb d5                	jmp    48a <strtoul+0xaf>
    } else if (base == 16) {
 4b5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4b9:	75 35                	jne    4f0 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4bb:	8a 03                	mov    (%ebx),%al
 4bd:	0f be c0             	movsbl %al,%eax
 4c0:	83 e8 30             	sub    $0x30,%eax
 4c3:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 4c5:	83 fe 4a             	cmp    $0x4a,%esi
 4c8:	76 02                	jbe    4cc <strtoul+0xf1>
    break;
 4ca:	eb 22                	jmp    4ee <strtoul+0x113>
      }
      digit = cvtIn[digit];
 4cc:	8a 86 e0 0f 00 00    	mov    0xfe0(%esi),%al
 4d2:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 4d5:	83 fe 0f             	cmp    $0xf,%esi
 4d8:	76 02                	jbe    4dc <strtoul+0x101>
    break;
 4da:	eb 12                	jmp    4ee <strtoul+0x113>
      }
      result = (result << 4) + digit;
 4dc:	89 f8                	mov    %edi,%eax
 4de:	c1 e0 04             	shl    $0x4,%eax
 4e1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 4eb:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 4ec:	eb cd                	jmp    4bb <strtoul+0xe0>
 4ee:	eb 36                	jmp    526 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 4f0:	8a 03                	mov    (%ebx),%al
 4f2:	0f be c0             	movsbl %al,%eax
 4f5:	83 e8 30             	sub    $0x30,%eax
 4f8:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 4fa:	83 fe 4a             	cmp    $0x4a,%esi
 4fd:	76 02                	jbe    501 <strtoul+0x126>
    break;
 4ff:	eb 25                	jmp    526 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 501:	8a 86 e0 0f 00 00    	mov    0xfe0(%esi),%al
 507:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 50a:	8b 45 10             	mov    0x10(%ebp),%eax
 50d:	39 f0                	cmp    %esi,%eax
 50f:	77 02                	ja     513 <strtoul+0x138>
    break;
 511:	eb 13                	jmp    526 <strtoul+0x14b>
      }
      result = result*base + digit;
 513:	8b 45 10             	mov    0x10(%ebp),%eax
 516:	0f af c7             	imul   %edi,%eax
 519:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 51c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 523:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 524:	eb ca                	jmp    4f0 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 526:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 52a:	75 03                	jne    52f <strtoul+0x154>
  p = string;
 52c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 52f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 533:	74 05                	je     53a <strtoul+0x15f>
  *endPtr = p;
 535:	8b 45 0c             	mov    0xc(%ebp),%eax
 538:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 53a:	89 f8                	mov    %edi,%eax
}
 53c:	83 c4 14             	add    $0x14,%esp
 53f:	5b                   	pop    %ebx
 540:	5e                   	pop    %esi
 541:	5f                   	pop    %edi
 542:	5d                   	pop    %ebp
 543:	c3                   	ret    

00000544 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	53                   	push   %ebx
 548:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 54b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 54e:	eb 01                	jmp    551 <strtol+0xd>
      p += 1;
 550:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 551:	8a 03                	mov    (%ebx),%al
 553:	0f b6 c0             	movzbl %al,%eax
 556:	89 04 24             	mov    %eax,(%esp)
 559:	e8 3f fe ff ff       	call   39d <isspace>
 55e:	85 c0                	test   %eax,%eax
 560:	75 ee                	jne    550 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 562:	8a 03                	mov    (%ebx),%al
 564:	3c 2d                	cmp    $0x2d,%al
 566:	75 1e                	jne    586 <strtol+0x42>
  p += 1;
 568:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 569:	8b 45 10             	mov    0x10(%ebp),%eax
 56c:	89 44 24 08          	mov    %eax,0x8(%esp)
 570:	8b 45 0c             	mov    0xc(%ebp),%eax
 573:	89 44 24 04          	mov    %eax,0x4(%esp)
 577:	89 1c 24             	mov    %ebx,(%esp)
 57a:	e8 5c fe ff ff       	call   3db <strtoul>
 57f:	f7 d8                	neg    %eax
 581:	89 45 f8             	mov    %eax,-0x8(%ebp)
 584:	eb 20                	jmp    5a6 <strtol+0x62>
    } else {
  if (*p == '+') {
 586:	8a 03                	mov    (%ebx),%al
 588:	3c 2b                	cmp    $0x2b,%al
 58a:	75 01                	jne    58d <strtol+0x49>
      p += 1;
 58c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 58d:	8b 45 10             	mov    0x10(%ebp),%eax
 590:	89 44 24 08          	mov    %eax,0x8(%esp)
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	89 1c 24             	mov    %ebx,(%esp)
 59e:	e8 38 fe ff ff       	call   3db <strtoul>
 5a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 5a6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 5aa:	75 17                	jne    5c3 <strtol+0x7f>
 5ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5b0:	74 11                	je     5c3 <strtol+0x7f>
 5b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b5:	8b 00                	mov    (%eax),%eax
 5b7:	39 d8                	cmp    %ebx,%eax
 5b9:	75 08                	jne    5c3 <strtol+0x7f>
  *endPtr = string;
 5bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 5be:	8b 55 08             	mov    0x8(%ebp),%edx
 5c1:	89 10                	mov    %edx,(%eax)
    }
    return result;
 5c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 5c6:	83 c4 1c             	add    $0x1c,%esp
 5c9:	5b                   	pop    %ebx
 5ca:	5d                   	pop    %ebp
 5cb:	c3                   	ret    

000005cc <gets>:

char*
gets(char *buf, int max)
{
 5cc:	55                   	push   %ebp
 5cd:	89 e5                	mov    %esp,%ebp
 5cf:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5d9:	eb 49                	jmp    624 <gets+0x58>
    cc = read(0, &c, 1);
 5db:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5e2:	00 
 5e3:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5f1:	e8 3e 01 00 00       	call   734 <read>
 5f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5fd:	7f 02                	jg     601 <gets+0x35>
      break;
 5ff:	eb 2c                	jmp    62d <gets+0x61>
    buf[i++] = c;
 601:	8b 45 f4             	mov    -0xc(%ebp),%eax
 604:	8d 50 01             	lea    0x1(%eax),%edx
 607:	89 55 f4             	mov    %edx,-0xc(%ebp)
 60a:	89 c2                	mov    %eax,%edx
 60c:	8b 45 08             	mov    0x8(%ebp),%eax
 60f:	01 c2                	add    %eax,%edx
 611:	8a 45 ef             	mov    -0x11(%ebp),%al
 614:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 616:	8a 45 ef             	mov    -0x11(%ebp),%al
 619:	3c 0a                	cmp    $0xa,%al
 61b:	74 10                	je     62d <gets+0x61>
 61d:	8a 45 ef             	mov    -0x11(%ebp),%al
 620:	3c 0d                	cmp    $0xd,%al
 622:	74 09                	je     62d <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	40                   	inc    %eax
 628:	3b 45 0c             	cmp    0xc(%ebp),%eax
 62b:	7c ae                	jl     5db <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 62d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	01 d0                	add    %edx,%eax
 635:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 638:	8b 45 08             	mov    0x8(%ebp),%eax
}
 63b:	c9                   	leave  
 63c:	c3                   	ret    

0000063d <stat>:

int
stat(char *n, struct stat *st)
{
 63d:	55                   	push   %ebp
 63e:	89 e5                	mov    %esp,%ebp
 640:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 643:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 64a:	00 
 64b:	8b 45 08             	mov    0x8(%ebp),%eax
 64e:	89 04 24             	mov    %eax,(%esp)
 651:	e8 06 01 00 00       	call   75c <open>
 656:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 659:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 65d:	79 07                	jns    666 <stat+0x29>
    return -1;
 65f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 664:	eb 23                	jmp    689 <stat+0x4c>
  r = fstat(fd, st);
 666:	8b 45 0c             	mov    0xc(%ebp),%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 fc 00 00 00       	call   774 <fstat>
 678:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 67b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67e:	89 04 24             	mov    %eax,(%esp)
 681:	e8 be 00 00 00       	call   744 <close>
  return r;
 686:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 689:	c9                   	leave  
 68a:	c3                   	ret    

0000068b <atoi>:

int
atoi(const char *s)
{
 68b:	55                   	push   %ebp
 68c:	89 e5                	mov    %esp,%ebp
 68e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 698:	eb 24                	jmp    6be <atoi+0x33>
    n = n*10 + *s++ - '0';
 69a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 69d:	89 d0                	mov    %edx,%eax
 69f:	c1 e0 02             	shl    $0x2,%eax
 6a2:	01 d0                	add    %edx,%eax
 6a4:	01 c0                	add    %eax,%eax
 6a6:	89 c1                	mov    %eax,%ecx
 6a8:	8b 45 08             	mov    0x8(%ebp),%eax
 6ab:	8d 50 01             	lea    0x1(%eax),%edx
 6ae:	89 55 08             	mov    %edx,0x8(%ebp)
 6b1:	8a 00                	mov    (%eax),%al
 6b3:	0f be c0             	movsbl %al,%eax
 6b6:	01 c8                	add    %ecx,%eax
 6b8:	83 e8 30             	sub    $0x30,%eax
 6bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	8a 00                	mov    (%eax),%al
 6c3:	3c 2f                	cmp    $0x2f,%al
 6c5:	7e 09                	jle    6d0 <atoi+0x45>
 6c7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ca:	8a 00                	mov    (%eax),%al
 6cc:	3c 39                	cmp    $0x39,%al
 6ce:	7e ca                	jle    69a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 6d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6d3:	c9                   	leave  
 6d4:	c3                   	ret    

000006d5 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 6d5:	55                   	push   %ebp
 6d6:	89 e5                	mov    %esp,%ebp
 6d8:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 6e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 6e7:	eb 16                	jmp    6ff <memmove+0x2a>
    *dst++ = *src++;
 6e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ec:	8d 50 01             	lea    0x1(%eax),%edx
 6ef:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f5:	8d 4a 01             	lea    0x1(%edx),%ecx
 6f8:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6fb:	8a 12                	mov    (%edx),%dl
 6fd:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6ff:	8b 45 10             	mov    0x10(%ebp),%eax
 702:	8d 50 ff             	lea    -0x1(%eax),%edx
 705:	89 55 10             	mov    %edx,0x10(%ebp)
 708:	85 c0                	test   %eax,%eax
 70a:	7f dd                	jg     6e9 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 70c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 70f:	c9                   	leave  
 710:	c3                   	ret    
 711:	90                   	nop
 712:	90                   	nop
 713:	90                   	nop

00000714 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 714:	b8 01 00 00 00       	mov    $0x1,%eax
 719:	cd 40                	int    $0x40
 71b:	c3                   	ret    

0000071c <exit>:
SYSCALL(exit)
 71c:	b8 02 00 00 00       	mov    $0x2,%eax
 721:	cd 40                	int    $0x40
 723:	c3                   	ret    

00000724 <wait>:
SYSCALL(wait)
 724:	b8 03 00 00 00       	mov    $0x3,%eax
 729:	cd 40                	int    $0x40
 72b:	c3                   	ret    

0000072c <pipe>:
SYSCALL(pipe)
 72c:	b8 04 00 00 00       	mov    $0x4,%eax
 731:	cd 40                	int    $0x40
 733:	c3                   	ret    

00000734 <read>:
SYSCALL(read)
 734:	b8 05 00 00 00       	mov    $0x5,%eax
 739:	cd 40                	int    $0x40
 73b:	c3                   	ret    

0000073c <write>:
SYSCALL(write)
 73c:	b8 10 00 00 00       	mov    $0x10,%eax
 741:	cd 40                	int    $0x40
 743:	c3                   	ret    

00000744 <close>:
SYSCALL(close)
 744:	b8 15 00 00 00       	mov    $0x15,%eax
 749:	cd 40                	int    $0x40
 74b:	c3                   	ret    

0000074c <kill>:
SYSCALL(kill)
 74c:	b8 06 00 00 00       	mov    $0x6,%eax
 751:	cd 40                	int    $0x40
 753:	c3                   	ret    

00000754 <exec>:
SYSCALL(exec)
 754:	b8 07 00 00 00       	mov    $0x7,%eax
 759:	cd 40                	int    $0x40
 75b:	c3                   	ret    

0000075c <open>:
SYSCALL(open)
 75c:	b8 0f 00 00 00       	mov    $0xf,%eax
 761:	cd 40                	int    $0x40
 763:	c3                   	ret    

00000764 <mknod>:
SYSCALL(mknod)
 764:	b8 11 00 00 00       	mov    $0x11,%eax
 769:	cd 40                	int    $0x40
 76b:	c3                   	ret    

0000076c <unlink>:
SYSCALL(unlink)
 76c:	b8 12 00 00 00       	mov    $0x12,%eax
 771:	cd 40                	int    $0x40
 773:	c3                   	ret    

00000774 <fstat>:
SYSCALL(fstat)
 774:	b8 08 00 00 00       	mov    $0x8,%eax
 779:	cd 40                	int    $0x40
 77b:	c3                   	ret    

0000077c <link>:
SYSCALL(link)
 77c:	b8 13 00 00 00       	mov    $0x13,%eax
 781:	cd 40                	int    $0x40
 783:	c3                   	ret    

00000784 <mkdir>:
SYSCALL(mkdir)
 784:	b8 14 00 00 00       	mov    $0x14,%eax
 789:	cd 40                	int    $0x40
 78b:	c3                   	ret    

0000078c <chdir>:
SYSCALL(chdir)
 78c:	b8 09 00 00 00       	mov    $0x9,%eax
 791:	cd 40                	int    $0x40
 793:	c3                   	ret    

00000794 <dup>:
SYSCALL(dup)
 794:	b8 0a 00 00 00       	mov    $0xa,%eax
 799:	cd 40                	int    $0x40
 79b:	c3                   	ret    

0000079c <getpid>:
SYSCALL(getpid)
 79c:	b8 0b 00 00 00       	mov    $0xb,%eax
 7a1:	cd 40                	int    $0x40
 7a3:	c3                   	ret    

000007a4 <sbrk>:
SYSCALL(sbrk)
 7a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 7a9:	cd 40                	int    $0x40
 7ab:	c3                   	ret    

000007ac <sleep>:
SYSCALL(sleep)
 7ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 7b1:	cd 40                	int    $0x40
 7b3:	c3                   	ret    

000007b4 <uptime>:
SYSCALL(uptime)
 7b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 7b9:	cd 40                	int    $0x40
 7bb:	c3                   	ret    

000007bc <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7bc:	55                   	push   %ebp
 7bd:	89 e5                	mov    %esp,%ebp
 7bf:	83 ec 18             	sub    $0x18,%esp
 7c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 7c5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7c8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7cf:	00 
 7d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d7:	8b 45 08             	mov    0x8(%ebp),%eax
 7da:	89 04 24             	mov    %eax,(%esp)
 7dd:	e8 5a ff ff ff       	call   73c <write>
}
 7e2:	c9                   	leave  
 7e3:	c3                   	ret    

000007e4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7e4:	55                   	push   %ebp
 7e5:	89 e5                	mov    %esp,%ebp
 7e7:	56                   	push   %esi
 7e8:	53                   	push   %ebx
 7e9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7ec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7f3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7f7:	74 17                	je     810 <printint+0x2c>
 7f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7fd:	79 11                	jns    810 <printint+0x2c>
    neg = 1;
 7ff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 806:	8b 45 0c             	mov    0xc(%ebp),%eax
 809:	f7 d8                	neg    %eax
 80b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 80e:	eb 06                	jmp    816 <printint+0x32>
  } else {
    x = xx;
 810:	8b 45 0c             	mov    0xc(%ebp),%eax
 813:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 81d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 820:	8d 41 01             	lea    0x1(%ecx),%eax
 823:	89 45 f4             	mov    %eax,-0xc(%ebp)
 826:	8b 5d 10             	mov    0x10(%ebp),%ebx
 829:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82c:	ba 00 00 00 00       	mov    $0x0,%edx
 831:	f7 f3                	div    %ebx
 833:	89 d0                	mov    %edx,%eax
 835:	8a 80 2c 10 00 00    	mov    0x102c(%eax),%al
 83b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 83f:	8b 75 10             	mov    0x10(%ebp),%esi
 842:	8b 45 ec             	mov    -0x14(%ebp),%eax
 845:	ba 00 00 00 00       	mov    $0x0,%edx
 84a:	f7 f6                	div    %esi
 84c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 84f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 853:	75 c8                	jne    81d <printint+0x39>
  if(neg)
 855:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 859:	74 10                	je     86b <printint+0x87>
    buf[i++] = '-';
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	8d 50 01             	lea    0x1(%eax),%edx
 861:	89 55 f4             	mov    %edx,-0xc(%ebp)
 864:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 869:	eb 1e                	jmp    889 <printint+0xa5>
 86b:	eb 1c                	jmp    889 <printint+0xa5>
    putc(fd, buf[i]);
 86d:	8d 55 dc             	lea    -0x24(%ebp),%edx
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	01 d0                	add    %edx,%eax
 875:	8a 00                	mov    (%eax),%al
 877:	0f be c0             	movsbl %al,%eax
 87a:	89 44 24 04          	mov    %eax,0x4(%esp)
 87e:	8b 45 08             	mov    0x8(%ebp),%eax
 881:	89 04 24             	mov    %eax,(%esp)
 884:	e8 33 ff ff ff       	call   7bc <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 889:	ff 4d f4             	decl   -0xc(%ebp)
 88c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 890:	79 db                	jns    86d <printint+0x89>
    putc(fd, buf[i]);
}
 892:	83 c4 30             	add    $0x30,%esp
 895:	5b                   	pop    %ebx
 896:	5e                   	pop    %esi
 897:	5d                   	pop    %ebp
 898:	c3                   	ret    

00000899 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 899:	55                   	push   %ebp
 89a:	89 e5                	mov    %esp,%ebp
 89c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 89f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8a6:	8d 45 0c             	lea    0xc(%ebp),%eax
 8a9:	83 c0 04             	add    $0x4,%eax
 8ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8af:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8b6:	e9 77 01 00 00       	jmp    a32 <printf+0x199>
    c = fmt[i] & 0xff;
 8bb:	8b 55 0c             	mov    0xc(%ebp),%edx
 8be:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c1:	01 d0                	add    %edx,%eax
 8c3:	8a 00                	mov    (%eax),%al
 8c5:	0f be c0             	movsbl %al,%eax
 8c8:	25 ff 00 00 00       	and    $0xff,%eax
 8cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8d4:	75 2c                	jne    902 <printf+0x69>
      if(c == '%'){
 8d6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8da:	75 0c                	jne    8e8 <printf+0x4f>
        state = '%';
 8dc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8e3:	e9 47 01 00 00       	jmp    a2f <printf+0x196>
      } else {
        putc(fd, c);
 8e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8eb:	0f be c0             	movsbl %al,%eax
 8ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
 8f5:	89 04 24             	mov    %eax,(%esp)
 8f8:	e8 bf fe ff ff       	call   7bc <putc>
 8fd:	e9 2d 01 00 00       	jmp    a2f <printf+0x196>
      }
    } else if(state == '%'){
 902:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 906:	0f 85 23 01 00 00    	jne    a2f <printf+0x196>
      if(c == 'd'){
 90c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 910:	75 2d                	jne    93f <printf+0xa6>
        printint(fd, *ap, 10, 1);
 912:	8b 45 e8             	mov    -0x18(%ebp),%eax
 915:	8b 00                	mov    (%eax),%eax
 917:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 91e:	00 
 91f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 926:	00 
 927:	89 44 24 04          	mov    %eax,0x4(%esp)
 92b:	8b 45 08             	mov    0x8(%ebp),%eax
 92e:	89 04 24             	mov    %eax,(%esp)
 931:	e8 ae fe ff ff       	call   7e4 <printint>
        ap++;
 936:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 93a:	e9 e9 00 00 00       	jmp    a28 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 93f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 943:	74 06                	je     94b <printf+0xb2>
 945:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 949:	75 2d                	jne    978 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 94b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 94e:	8b 00                	mov    (%eax),%eax
 950:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 957:	00 
 958:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 95f:	00 
 960:	89 44 24 04          	mov    %eax,0x4(%esp)
 964:	8b 45 08             	mov    0x8(%ebp),%eax
 967:	89 04 24             	mov    %eax,(%esp)
 96a:	e8 75 fe ff ff       	call   7e4 <printint>
        ap++;
 96f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 973:	e9 b0 00 00 00       	jmp    a28 <printf+0x18f>
      } else if(c == 's'){
 978:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 97c:	75 42                	jne    9c0 <printf+0x127>
        s = (char*)*ap;
 97e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 986:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 98a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98e:	75 09                	jne    999 <printf+0x100>
          s = "(null)";
 990:	c7 45 f4 68 0c 00 00 	movl   $0xc68,-0xc(%ebp)
        while(*s != 0){
 997:	eb 1c                	jmp    9b5 <printf+0x11c>
 999:	eb 1a                	jmp    9b5 <printf+0x11c>
          putc(fd, *s);
 99b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99e:	8a 00                	mov    (%eax),%al
 9a0:	0f be c0             	movsbl %al,%eax
 9a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a7:	8b 45 08             	mov    0x8(%ebp),%eax
 9aa:	89 04 24             	mov    %eax,(%esp)
 9ad:	e8 0a fe ff ff       	call   7bc <putc>
          s++;
 9b2:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b8:	8a 00                	mov    (%eax),%al
 9ba:	84 c0                	test   %al,%al
 9bc:	75 dd                	jne    99b <printf+0x102>
 9be:	eb 68                	jmp    a28 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9c0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9c4:	75 1d                	jne    9e3 <printf+0x14a>
        putc(fd, *ap);
 9c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9c9:	8b 00                	mov    (%eax),%eax
 9cb:	0f be c0             	movsbl %al,%eax
 9ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	89 04 24             	mov    %eax,(%esp)
 9d8:	e8 df fd ff ff       	call   7bc <putc>
        ap++;
 9dd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9e1:	eb 45                	jmp    a28 <printf+0x18f>
      } else if(c == '%'){
 9e3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9e7:	75 17                	jne    a00 <printf+0x167>
        putc(fd, c);
 9e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ec:	0f be c0             	movsbl %al,%eax
 9ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 9f3:	8b 45 08             	mov    0x8(%ebp),%eax
 9f6:	89 04 24             	mov    %eax,(%esp)
 9f9:	e8 be fd ff ff       	call   7bc <putc>
 9fe:	eb 28                	jmp    a28 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a00:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a07:	00 
 a08:	8b 45 08             	mov    0x8(%ebp),%eax
 a0b:	89 04 24             	mov    %eax,(%esp)
 a0e:	e8 a9 fd ff ff       	call   7bc <putc>
        putc(fd, c);
 a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a16:	0f be c0             	movsbl %al,%eax
 a19:	89 44 24 04          	mov    %eax,0x4(%esp)
 a1d:	8b 45 08             	mov    0x8(%ebp),%eax
 a20:	89 04 24             	mov    %eax,(%esp)
 a23:	e8 94 fd ff ff       	call   7bc <putc>
      }
      state = 0;
 a28:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a2f:	ff 45 f0             	incl   -0x10(%ebp)
 a32:	8b 55 0c             	mov    0xc(%ebp),%edx
 a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a38:	01 d0                	add    %edx,%eax
 a3a:	8a 00                	mov    (%eax),%al
 a3c:	84 c0                	test   %al,%al
 a3e:	0f 85 77 fe ff ff    	jne    8bb <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a44:	c9                   	leave  
 a45:	c3                   	ret    
 a46:	90                   	nop
 a47:	90                   	nop

00000a48 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a48:	55                   	push   %ebp
 a49:	89 e5                	mov    %esp,%ebp
 a4b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a4e:	8b 45 08             	mov    0x8(%ebp),%eax
 a51:	83 e8 08             	sub    $0x8,%eax
 a54:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a57:	a1 50 10 00 00       	mov    0x1050,%eax
 a5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a5f:	eb 24                	jmp    a85 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a64:	8b 00                	mov    (%eax),%eax
 a66:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a69:	77 12                	ja     a7d <free+0x35>
 a6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a71:	77 24                	ja     a97 <free+0x4f>
 a73:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a76:	8b 00                	mov    (%eax),%eax
 a78:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a7b:	77 1a                	ja     a97 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a80:	8b 00                	mov    (%eax),%eax
 a82:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a85:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a88:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a8b:	76 d4                	jbe    a61 <free+0x19>
 a8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a90:	8b 00                	mov    (%eax),%eax
 a92:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a95:	76 ca                	jbe    a61 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a97:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a9a:	8b 40 04             	mov    0x4(%eax),%eax
 a9d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aa4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa7:	01 c2                	add    %eax,%edx
 aa9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aac:	8b 00                	mov    (%eax),%eax
 aae:	39 c2                	cmp    %eax,%edx
 ab0:	75 24                	jne    ad6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ab2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab5:	8b 50 04             	mov    0x4(%eax),%edx
 ab8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abb:	8b 00                	mov    (%eax),%eax
 abd:	8b 40 04             	mov    0x4(%eax),%eax
 ac0:	01 c2                	add    %eax,%edx
 ac2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acb:	8b 00                	mov    (%eax),%eax
 acd:	8b 10                	mov    (%eax),%edx
 acf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad2:	89 10                	mov    %edx,(%eax)
 ad4:	eb 0a                	jmp    ae0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ad6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad9:	8b 10                	mov    (%eax),%edx
 adb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ade:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae3:	8b 40 04             	mov    0x4(%eax),%eax
 ae6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af0:	01 d0                	add    %edx,%eax
 af2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 af5:	75 20                	jne    b17 <free+0xcf>
    p->s.size += bp->s.size;
 af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afa:	8b 50 04             	mov    0x4(%eax),%edx
 afd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b00:	8b 40 04             	mov    0x4(%eax),%eax
 b03:	01 c2                	add    %eax,%edx
 b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b08:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0e:	8b 10                	mov    (%eax),%edx
 b10:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b13:	89 10                	mov    %edx,(%eax)
 b15:	eb 08                	jmp    b1f <free+0xd7>
  } else
    p->s.ptr = bp;
 b17:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b1d:	89 10                	mov    %edx,(%eax)
  freep = p;
 b1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b22:	a3 50 10 00 00       	mov    %eax,0x1050
}
 b27:	c9                   	leave  
 b28:	c3                   	ret    

00000b29 <morecore>:

static Header*
morecore(uint nu)
{
 b29:	55                   	push   %ebp
 b2a:	89 e5                	mov    %esp,%ebp
 b2c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b2f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b36:	77 07                	ja     b3f <morecore+0x16>
    nu = 4096;
 b38:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b3f:	8b 45 08             	mov    0x8(%ebp),%eax
 b42:	c1 e0 03             	shl    $0x3,%eax
 b45:	89 04 24             	mov    %eax,(%esp)
 b48:	e8 57 fc ff ff       	call   7a4 <sbrk>
 b4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b50:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b54:	75 07                	jne    b5d <morecore+0x34>
    return 0;
 b56:	b8 00 00 00 00       	mov    $0x0,%eax
 b5b:	eb 22                	jmp    b7f <morecore+0x56>
  hp = (Header*)p;
 b5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b63:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b66:	8b 55 08             	mov    0x8(%ebp),%edx
 b69:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6f:	83 c0 08             	add    $0x8,%eax
 b72:	89 04 24             	mov    %eax,(%esp)
 b75:	e8 ce fe ff ff       	call   a48 <free>
  return freep;
 b7a:	a1 50 10 00 00       	mov    0x1050,%eax
}
 b7f:	c9                   	leave  
 b80:	c3                   	ret    

00000b81 <malloc>:

void*
malloc(uint nbytes)
{
 b81:	55                   	push   %ebp
 b82:	89 e5                	mov    %esp,%ebp
 b84:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b87:	8b 45 08             	mov    0x8(%ebp),%eax
 b8a:	83 c0 07             	add    $0x7,%eax
 b8d:	c1 e8 03             	shr    $0x3,%eax
 b90:	40                   	inc    %eax
 b91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b94:	a1 50 10 00 00       	mov    0x1050,%eax
 b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b9c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ba0:	75 23                	jne    bc5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 ba2:	c7 45 f0 48 10 00 00 	movl   $0x1048,-0x10(%ebp)
 ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bac:	a3 50 10 00 00       	mov    %eax,0x1050
 bb1:	a1 50 10 00 00       	mov    0x1050,%eax
 bb6:	a3 48 10 00 00       	mov    %eax,0x1048
    base.s.size = 0;
 bbb:	c7 05 4c 10 00 00 00 	movl   $0x0,0x104c
 bc2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc8:	8b 00                	mov    (%eax),%eax
 bca:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd0:	8b 40 04             	mov    0x4(%eax),%eax
 bd3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bd6:	72 4d                	jb     c25 <malloc+0xa4>
      if(p->s.size == nunits)
 bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bdb:	8b 40 04             	mov    0x4(%eax),%eax
 bde:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 be1:	75 0c                	jne    bef <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be6:	8b 10                	mov    (%eax),%edx
 be8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 beb:	89 10                	mov    %edx,(%eax)
 bed:	eb 26                	jmp    c15 <malloc+0x94>
      else {
        p->s.size -= nunits;
 bef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf2:	8b 40 04             	mov    0x4(%eax),%eax
 bf5:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bf8:	89 c2                	mov    %eax,%edx
 bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c03:	8b 40 04             	mov    0x4(%eax),%eax
 c06:	c1 e0 03             	shl    $0x3,%eax
 c09:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c12:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c15:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c18:	a3 50 10 00 00       	mov    %eax,0x1050
      return (void*)(p + 1);
 c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c20:	83 c0 08             	add    $0x8,%eax
 c23:	eb 38                	jmp    c5d <malloc+0xdc>
    }
    if(p == freep)
 c25:	a1 50 10 00 00       	mov    0x1050,%eax
 c2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c2d:	75 1b                	jne    c4a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 c2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c32:	89 04 24             	mov    %eax,(%esp)
 c35:	e8 ef fe ff ff       	call   b29 <morecore>
 c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c41:	75 07                	jne    c4a <malloc+0xc9>
        return 0;
 c43:	b8 00 00 00 00       	mov    $0x0,%eax
 c48:	eb 13                	jmp    c5d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c53:	8b 00                	mov    (%eax),%eax
 c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c58:	e9 70 ff ff ff       	jmp    bcd <malloc+0x4c>
}
 c5d:	c9                   	leave  
 c5e:	c3                   	ret    
