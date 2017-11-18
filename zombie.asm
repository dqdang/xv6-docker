
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
   9:	e8 be 06 00 00       	call   6cc <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 46 07 00 00       	call   764 <sleep>
  exit();
  1e:	e8 b1 06 00 00       	call   6d4 <exit>
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

00000077 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  77:	55                   	push   %ebp
  78:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7a:	eb 06                	jmp    82 <strcmp+0xb>
    p++, q++;
  7c:	ff 45 08             	incl   0x8(%ebp)
  7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  82:	8b 45 08             	mov    0x8(%ebp),%eax
  85:	8a 00                	mov    (%eax),%al
  87:	84 c0                	test   %al,%al
  89:	74 0e                	je     99 <strcmp+0x22>
  8b:	8b 45 08             	mov    0x8(%ebp),%eax
  8e:	8a 10                	mov    (%eax),%dl
  90:	8b 45 0c             	mov    0xc(%ebp),%eax
  93:	8a 00                	mov    (%eax),%al
  95:	38 c2                	cmp    %al,%dl
  97:	74 e3                	je     7c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  99:	8b 45 08             	mov    0x8(%ebp),%eax
  9c:	8a 00                	mov    (%eax),%al
  9e:	0f b6 d0             	movzbl %al,%edx
  a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  a4:	8a 00                	mov    (%eax),%al
  a6:	0f b6 c0             	movzbl %al,%eax
  a9:	29 c2                	sub    %eax,%edx
  ab:	89 d0                	mov    %edx,%eax
}
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
  b2:	eb 09                	jmp    bd <strncmp+0xe>
    n--, p++, q++;
  b4:	ff 4d 10             	decl   0x10(%ebp)
  b7:	ff 45 08             	incl   0x8(%ebp)
  ba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
  bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  c1:	74 17                	je     da <strncmp+0x2b>
  c3:	8b 45 08             	mov    0x8(%ebp),%eax
  c6:	8a 00                	mov    (%eax),%al
  c8:	84 c0                	test   %al,%al
  ca:	74 0e                	je     da <strncmp+0x2b>
  cc:	8b 45 08             	mov    0x8(%ebp),%eax
  cf:	8a 10                	mov    (%eax),%dl
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	8a 00                	mov    (%eax),%al
  d6:	38 c2                	cmp    %al,%dl
  d8:	74 da                	je     b4 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
  da:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  de:	75 07                	jne    e7 <strncmp+0x38>
    return 0;
  e0:	b8 00 00 00 00       	mov    $0x0,%eax
  e5:	eb 14                	jmp    fb <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	8a 00                	mov    (%eax),%al
  ec:	0f b6 d0             	movzbl %al,%edx
  ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  f2:	8a 00                	mov    (%eax),%al
  f4:	0f b6 c0             	movzbl %al,%eax
  f7:	29 c2                	sub    %eax,%edx
  f9:	89 d0                	mov    %edx,%eax
}
  fb:	5d                   	pop    %ebp
  fc:	c3                   	ret    

000000fd <strlen>:

uint
strlen(const char *s)
{
  fd:	55                   	push   %ebp
  fe:	89 e5                	mov    %esp,%ebp
 100:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 103:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10a:	eb 03                	jmp    10f <strlen+0x12>
 10c:	ff 45 fc             	incl   -0x4(%ebp)
 10f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 112:	8b 45 08             	mov    0x8(%ebp),%eax
 115:	01 d0                	add    %edx,%eax
 117:	8a 00                	mov    (%eax),%al
 119:	84 c0                	test   %al,%al
 11b:	75 ef                	jne    10c <strlen+0xf>
    ;
  return n;
 11d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 120:	c9                   	leave  
 121:	c3                   	ret    

00000122 <memset>:

void*
memset(void *dst, int c, uint n)
{
 122:	55                   	push   %ebp
 123:	89 e5                	mov    %esp,%ebp
 125:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 128:	8b 45 10             	mov    0x10(%ebp),%eax
 12b:	89 44 24 08          	mov    %eax,0x8(%esp)
 12f:	8b 45 0c             	mov    0xc(%ebp),%eax
 132:	89 44 24 04          	mov    %eax,0x4(%esp)
 136:	8b 45 08             	mov    0x8(%ebp),%eax
 139:	89 04 24             	mov    %eax,(%esp)
 13c:	e8 e3 fe ff ff       	call   24 <stosb>
  return dst;
 141:	8b 45 08             	mov    0x8(%ebp),%eax
}
 144:	c9                   	leave  
 145:	c3                   	ret    

00000146 <strchr>:

char*
strchr(const char *s, char c)
{
 146:	55                   	push   %ebp
 147:	89 e5                	mov    %esp,%ebp
 149:	83 ec 04             	sub    $0x4,%esp
 14c:	8b 45 0c             	mov    0xc(%ebp),%eax
 14f:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 152:	eb 12                	jmp    166 <strchr+0x20>
    if(*s == c)
 154:	8b 45 08             	mov    0x8(%ebp),%eax
 157:	8a 00                	mov    (%eax),%al
 159:	3a 45 fc             	cmp    -0x4(%ebp),%al
 15c:	75 05                	jne    163 <strchr+0x1d>
      return (char*)s;
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	eb 11                	jmp    174 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 163:	ff 45 08             	incl   0x8(%ebp)
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	8a 00                	mov    (%eax),%al
 16b:	84 c0                	test   %al,%al
 16d:	75 e5                	jne    154 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 16f:	b8 00 00 00 00       	mov    $0x0,%eax
}
 174:	c9                   	leave  
 175:	c3                   	ret    

00000176 <strcat>:

char *
strcat(char *dest, const char *src)
{
 176:	55                   	push   %ebp
 177:	89 e5                	mov    %esp,%ebp
 179:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 17c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 183:	eb 03                	jmp    188 <strcat+0x12>
 185:	ff 45 fc             	incl   -0x4(%ebp)
 188:	8b 55 fc             	mov    -0x4(%ebp),%edx
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	01 d0                	add    %edx,%eax
 190:	8a 00                	mov    (%eax),%al
 192:	84 c0                	test   %al,%al
 194:	75 ef                	jne    185 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 19d:	eb 1e                	jmp    1bd <strcat+0x47>
        dest[i+j] = src[j];
 19f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 1a2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1a5:	01 d0                	add    %edx,%eax
 1a7:	89 c2                	mov    %eax,%edx
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	01 c2                	add    %eax,%edx
 1ae:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	01 c8                	add    %ecx,%eax
 1b6:	8a 00                	mov    (%eax),%al
 1b8:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 1ba:	ff 45 f8             	incl   -0x8(%ebp)
 1bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	01 d0                	add    %edx,%eax
 1c5:	8a 00                	mov    (%eax),%al
 1c7:	84 c0                	test   %al,%al
 1c9:	75 d4                	jne    19f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 1cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 1ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1d1:	01 d0                	add    %edx,%eax
 1d3:	89 c2                	mov    %eax,%edx
 1d5:	8b 45 08             	mov    0x8(%ebp),%eax
 1d8:	01 d0                	add    %edx,%eax
 1da:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 1dd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <strstr>:

int 
strstr(char* s, char* sub)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 1e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ef:	eb 7c                	jmp    26d <strstr+0x8b>
    {
        if(s[i] == sub[0])
 1f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	01 d0                	add    %edx,%eax
 1f9:	8a 10                	mov    (%eax),%dl
 1fb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1fe:	8a 00                	mov    (%eax),%al
 200:	38 c2                	cmp    %al,%dl
 202:	75 66                	jne    26a <strstr+0x88>
        {
            if(strlen(sub) == 1)
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	89 04 24             	mov    %eax,(%esp)
 20a:	e8 ee fe ff ff       	call   fd <strlen>
 20f:	83 f8 01             	cmp    $0x1,%eax
 212:	75 05                	jne    219 <strstr+0x37>
            {  
                return i;
 214:	8b 45 fc             	mov    -0x4(%ebp),%eax
 217:	eb 6b                	jmp    284 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 219:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 220:	eb 3a                	jmp    25c <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 222:	8b 45 f8             	mov    -0x8(%ebp),%eax
 225:	8b 55 fc             	mov    -0x4(%ebp),%edx
 228:	01 d0                	add    %edx,%eax
 22a:	89 c2                	mov    %eax,%edx
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	01 d0                	add    %edx,%eax
 231:	8a 10                	mov    (%eax),%dl
 233:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 236:	8b 45 0c             	mov    0xc(%ebp),%eax
 239:	01 c8                	add    %ecx,%eax
 23b:	8a 00                	mov    (%eax),%al
 23d:	38 c2                	cmp    %al,%dl
 23f:	75 16                	jne    257 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 241:	8b 45 f8             	mov    -0x8(%ebp),%eax
 244:	8d 50 01             	lea    0x1(%eax),%edx
 247:	8b 45 0c             	mov    0xc(%ebp),%eax
 24a:	01 d0                	add    %edx,%eax
 24c:	8a 00                	mov    (%eax),%al
 24e:	84 c0                	test   %al,%al
 250:	75 07                	jne    259 <strstr+0x77>
                    {
                        return i;
 252:	8b 45 fc             	mov    -0x4(%ebp),%eax
 255:	eb 2d                	jmp    284 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 257:	eb 11                	jmp    26a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 259:	ff 45 f8             	incl   -0x8(%ebp)
 25c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 25f:	8b 45 0c             	mov    0xc(%ebp),%eax
 262:	01 d0                	add    %edx,%eax
 264:	8a 00                	mov    (%eax),%al
 266:	84 c0                	test   %al,%al
 268:	75 b8                	jne    222 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 26a:	ff 45 fc             	incl   -0x4(%ebp)
 26d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	01 d0                	add    %edx,%eax
 275:	8a 00                	mov    (%eax),%al
 277:	84 c0                	test   %al,%al
 279:	0f 85 72 ff ff ff    	jne    1f1 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 27f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <strtok>:

char *
strtok(char *s, const char *delim)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	53                   	push   %ebx
 28a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 28d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 291:	75 08                	jne    29b <strtok+0x15>
  s = lasts;
 293:	a1 e4 0f 00 00       	mov    0xfe4,%eax
 298:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 29b:	8b 45 08             	mov    0x8(%ebp),%eax
 29e:	8d 50 01             	lea    0x1(%eax),%edx
 2a1:	89 55 08             	mov    %edx,0x8(%ebp)
 2a4:	8a 00                	mov    (%eax),%al
 2a6:	0f be d8             	movsbl %al,%ebx
 2a9:	85 db                	test   %ebx,%ebx
 2ab:	75 07                	jne    2b4 <strtok+0x2e>
      return 0;
 2ad:	b8 00 00 00 00       	mov    $0x0,%eax
 2b2:	eb 58                	jmp    30c <strtok+0x86>
    } while (strchr(delim, ch));
 2b4:	88 d8                	mov    %bl,%al
 2b6:	0f be c0             	movsbl %al,%eax
 2b9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	89 04 24             	mov    %eax,(%esp)
 2c3:	e8 7e fe ff ff       	call   146 <strchr>
 2c8:	85 c0                	test   %eax,%eax
 2ca:	75 cf                	jne    29b <strtok+0x15>
    --s;
 2cc:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 2cf:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d2:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d6:	8b 45 08             	mov    0x8(%ebp),%eax
 2d9:	89 04 24             	mov    %eax,(%esp)
 2dc:	e8 31 00 00 00       	call   312 <strcspn>
 2e1:	89 c2                	mov    %eax,%edx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	01 d0                	add    %edx,%eax
 2e8:	a3 e4 0f 00 00       	mov    %eax,0xfe4
    if (*lasts != 0)
 2ed:	a1 e4 0f 00 00       	mov    0xfe4,%eax
 2f2:	8a 00                	mov    (%eax),%al
 2f4:	84 c0                	test   %al,%al
 2f6:	74 11                	je     309 <strtok+0x83>
  *lasts++ = 0;
 2f8:	a1 e4 0f 00 00       	mov    0xfe4,%eax
 2fd:	8d 50 01             	lea    0x1(%eax),%edx
 300:	89 15 e4 0f 00 00    	mov    %edx,0xfe4
 306:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 309:	8b 45 08             	mov    0x8(%ebp),%eax
}
 30c:	83 c4 14             	add    $0x14,%esp
 30f:	5b                   	pop    %ebx
 310:	5d                   	pop    %ebp
 311:	c3                   	ret    

00000312 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 318:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 31f:	eb 26                	jmp    347 <strcspn+0x35>
        if(strchr(s2,*s1))
 321:	8b 45 08             	mov    0x8(%ebp),%eax
 324:	8a 00                	mov    (%eax),%al
 326:	0f be c0             	movsbl %al,%eax
 329:	89 44 24 04          	mov    %eax,0x4(%esp)
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 04 24             	mov    %eax,(%esp)
 333:	e8 0e fe ff ff       	call   146 <strchr>
 338:	85 c0                	test   %eax,%eax
 33a:	74 05                	je     341 <strcspn+0x2f>
            return ret;
 33c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 33f:	eb 12                	jmp    353 <strcspn+0x41>
        else
            s1++,ret++;
 341:	ff 45 08             	incl   0x8(%ebp)
 344:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 347:	8b 45 08             	mov    0x8(%ebp),%eax
 34a:	8a 00                	mov    (%eax),%al
 34c:	84 c0                	test   %al,%al
 34e:	75 d1                	jne    321 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 350:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 353:	c9                   	leave  
 354:	c3                   	ret    

00000355 <isspace>:

int
isspace(unsigned char c)
{
 355:	55                   	push   %ebp
 356:	89 e5                	mov    %esp,%ebp
 358:	83 ec 04             	sub    $0x4,%esp
 35b:	8b 45 08             	mov    0x8(%ebp),%eax
 35e:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 361:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 365:	74 1e                	je     385 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 367:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 36b:	74 18                	je     385 <isspace+0x30>
 36d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 371:	74 12                	je     385 <isspace+0x30>
 373:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 377:	74 0c                	je     385 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 379:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 37d:	74 06                	je     385 <isspace+0x30>
 37f:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 383:	75 07                	jne    38c <isspace+0x37>
 385:	b8 01 00 00 00       	mov    $0x1,%eax
 38a:	eb 05                	jmp    391 <isspace+0x3c>
 38c:	b8 00 00 00 00       	mov    $0x0,%eax
}
 391:	c9                   	leave  
 392:	c3                   	ret    

00000393 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 393:	55                   	push   %ebp
 394:	89 e5                	mov    %esp,%ebp
 396:	57                   	push   %edi
 397:	56                   	push   %esi
 398:	53                   	push   %ebx
 399:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 39c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 3a1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 3a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 3ab:	eb 01                	jmp    3ae <strtoul+0x1b>
  p += 1;
 3ad:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 3ae:	8a 03                	mov    (%ebx),%al
 3b0:	0f b6 c0             	movzbl %al,%eax
 3b3:	89 04 24             	mov    %eax,(%esp)
 3b6:	e8 9a ff ff ff       	call   355 <isspace>
 3bb:	85 c0                	test   %eax,%eax
 3bd:	75 ee                	jne    3ad <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 3bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3c3:	75 30                	jne    3f5 <strtoul+0x62>
    {
  if (*p == '0') {
 3c5:	8a 03                	mov    (%ebx),%al
 3c7:	3c 30                	cmp    $0x30,%al
 3c9:	75 21                	jne    3ec <strtoul+0x59>
      p += 1;
 3cb:	43                   	inc    %ebx
      if (*p == 'x') {
 3cc:	8a 03                	mov    (%ebx),%al
 3ce:	3c 78                	cmp    $0x78,%al
 3d0:	75 0a                	jne    3dc <strtoul+0x49>
    p += 1;
 3d2:	43                   	inc    %ebx
    base = 16;
 3d3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 3da:	eb 31                	jmp    40d <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 3dc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 3e3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 3ea:	eb 21                	jmp    40d <strtoul+0x7a>
      }
  }
  else base = 10;
 3ec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 3f3:	eb 18                	jmp    40d <strtoul+0x7a>
    } else if (base == 16) {
 3f5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 3f9:	75 12                	jne    40d <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 3fb:	8a 03                	mov    (%ebx),%al
 3fd:	3c 30                	cmp    $0x30,%al
 3ff:	75 0c                	jne    40d <strtoul+0x7a>
 401:	8d 43 01             	lea    0x1(%ebx),%eax
 404:	8a 00                	mov    (%eax),%al
 406:	3c 78                	cmp    $0x78,%al
 408:	75 03                	jne    40d <strtoul+0x7a>
      p += 2;
 40a:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 40d:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 411:	75 29                	jne    43c <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 413:	8a 03                	mov    (%ebx),%al
 415:	0f be c0             	movsbl %al,%eax
 418:	83 e8 30             	sub    $0x30,%eax
 41b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 41d:	83 fe 07             	cmp    $0x7,%esi
 420:	76 06                	jbe    428 <strtoul+0x95>
    break;
 422:	90                   	nop
 423:	e9 b6 00 00 00       	jmp    4de <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 428:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 42f:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 432:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 439:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 43a:	eb d7                	jmp    413 <strtoul+0x80>
    } else if (base == 10) {
 43c:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 440:	75 2b                	jne    46d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 442:	8a 03                	mov    (%ebx),%al
 444:	0f be c0             	movsbl %al,%eax
 447:	83 e8 30             	sub    $0x30,%eax
 44a:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 44c:	83 fe 09             	cmp    $0x9,%esi
 44f:	76 06                	jbe    457 <strtoul+0xc4>
    break;
 451:	90                   	nop
 452:	e9 87 00 00 00       	jmp    4de <strtoul+0x14b>
      }
      result = (10*result) + digit;
 457:	89 f8                	mov    %edi,%eax
 459:	c1 e0 02             	shl    $0x2,%eax
 45c:	01 f8                	add    %edi,%eax
 45e:	01 c0                	add    %eax,%eax
 460:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 463:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 46a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 46b:	eb d5                	jmp    442 <strtoul+0xaf>
    } else if (base == 16) {
 46d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 471:	75 35                	jne    4a8 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 473:	8a 03                	mov    (%ebx),%al
 475:	0f be c0             	movsbl %al,%eax
 478:	83 e8 30             	sub    $0x30,%eax
 47b:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 47d:	83 fe 4a             	cmp    $0x4a,%esi
 480:	76 02                	jbe    484 <strtoul+0xf1>
    break;
 482:	eb 22                	jmp    4a6 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 484:	8a 86 80 0f 00 00    	mov    0xf80(%esi),%al
 48a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 48d:	83 fe 0f             	cmp    $0xf,%esi
 490:	76 02                	jbe    494 <strtoul+0x101>
    break;
 492:	eb 12                	jmp    4a6 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 494:	89 f8                	mov    %edi,%eax
 496:	c1 e0 04             	shl    $0x4,%eax
 499:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 49c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 4a3:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 4a4:	eb cd                	jmp    473 <strtoul+0xe0>
 4a6:	eb 36                	jmp    4de <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 4a8:	8a 03                	mov    (%ebx),%al
 4aa:	0f be c0             	movsbl %al,%eax
 4ad:	83 e8 30             	sub    $0x30,%eax
 4b0:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 4b2:	83 fe 4a             	cmp    $0x4a,%esi
 4b5:	76 02                	jbe    4b9 <strtoul+0x126>
    break;
 4b7:	eb 25                	jmp    4de <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 4b9:	8a 86 80 0f 00 00    	mov    0xf80(%esi),%al
 4bf:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 4c2:	8b 45 10             	mov    0x10(%ebp),%eax
 4c5:	39 f0                	cmp    %esi,%eax
 4c7:	77 02                	ja     4cb <strtoul+0x138>
    break;
 4c9:	eb 13                	jmp    4de <strtoul+0x14b>
      }
      result = result*base + digit;
 4cb:	8b 45 10             	mov    0x10(%ebp),%eax
 4ce:	0f af c7             	imul   %edi,%eax
 4d1:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 4db:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 4dc:	eb ca                	jmp    4a8 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 4de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4e2:	75 03                	jne    4e7 <strtoul+0x154>
  p = string;
 4e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 4e7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4eb:	74 05                	je     4f2 <strtoul+0x15f>
  *endPtr = p;
 4ed:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f0:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 4f2:	89 f8                	mov    %edi,%eax
}
 4f4:	83 c4 14             	add    $0x14,%esp
 4f7:	5b                   	pop    %ebx
 4f8:	5e                   	pop    %esi
 4f9:	5f                   	pop    %edi
 4fa:	5d                   	pop    %ebp
 4fb:	c3                   	ret    

000004fc <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 4fc:	55                   	push   %ebp
 4fd:	89 e5                	mov    %esp,%ebp
 4ff:	53                   	push   %ebx
 500:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 503:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 506:	eb 01                	jmp    509 <strtol+0xd>
      p += 1;
 508:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 509:	8a 03                	mov    (%ebx),%al
 50b:	0f b6 c0             	movzbl %al,%eax
 50e:	89 04 24             	mov    %eax,(%esp)
 511:	e8 3f fe ff ff       	call   355 <isspace>
 516:	85 c0                	test   %eax,%eax
 518:	75 ee                	jne    508 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 51a:	8a 03                	mov    (%ebx),%al
 51c:	3c 2d                	cmp    $0x2d,%al
 51e:	75 1e                	jne    53e <strtol+0x42>
  p += 1;
 520:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 521:	8b 45 10             	mov    0x10(%ebp),%eax
 524:	89 44 24 08          	mov    %eax,0x8(%esp)
 528:	8b 45 0c             	mov    0xc(%ebp),%eax
 52b:	89 44 24 04          	mov    %eax,0x4(%esp)
 52f:	89 1c 24             	mov    %ebx,(%esp)
 532:	e8 5c fe ff ff       	call   393 <strtoul>
 537:	f7 d8                	neg    %eax
 539:	89 45 f8             	mov    %eax,-0x8(%ebp)
 53c:	eb 20                	jmp    55e <strtol+0x62>
    } else {
  if (*p == '+') {
 53e:	8a 03                	mov    (%ebx),%al
 540:	3c 2b                	cmp    $0x2b,%al
 542:	75 01                	jne    545 <strtol+0x49>
      p += 1;
 544:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 545:	8b 45 10             	mov    0x10(%ebp),%eax
 548:	89 44 24 08          	mov    %eax,0x8(%esp)
 54c:	8b 45 0c             	mov    0xc(%ebp),%eax
 54f:	89 44 24 04          	mov    %eax,0x4(%esp)
 553:	89 1c 24             	mov    %ebx,(%esp)
 556:	e8 38 fe ff ff       	call   393 <strtoul>
 55b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 55e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 562:	75 17                	jne    57b <strtol+0x7f>
 564:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 568:	74 11                	je     57b <strtol+0x7f>
 56a:	8b 45 0c             	mov    0xc(%ebp),%eax
 56d:	8b 00                	mov    (%eax),%eax
 56f:	39 d8                	cmp    %ebx,%eax
 571:	75 08                	jne    57b <strtol+0x7f>
  *endPtr = string;
 573:	8b 45 0c             	mov    0xc(%ebp),%eax
 576:	8b 55 08             	mov    0x8(%ebp),%edx
 579:	89 10                	mov    %edx,(%eax)
    }
    return result;
 57b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 57e:	83 c4 1c             	add    $0x1c,%esp
 581:	5b                   	pop    %ebx
 582:	5d                   	pop    %ebp
 583:	c3                   	ret    

00000584 <gets>:

char*
gets(char *buf, int max)
{
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 58a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 591:	eb 49                	jmp    5dc <gets+0x58>
    cc = read(0, &c, 1);
 593:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 59a:	00 
 59b:	8d 45 ef             	lea    -0x11(%ebp),%eax
 59e:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5a9:	e8 3e 01 00 00       	call   6ec <read>
 5ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5b5:	7f 02                	jg     5b9 <gets+0x35>
      break;
 5b7:	eb 2c                	jmp    5e5 <gets+0x61>
    buf[i++] = c;
 5b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5bc:	8d 50 01             	lea    0x1(%eax),%edx
 5bf:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5c2:	89 c2                	mov    %eax,%edx
 5c4:	8b 45 08             	mov    0x8(%ebp),%eax
 5c7:	01 c2                	add    %eax,%edx
 5c9:	8a 45 ef             	mov    -0x11(%ebp),%al
 5cc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 5ce:	8a 45 ef             	mov    -0x11(%ebp),%al
 5d1:	3c 0a                	cmp    $0xa,%al
 5d3:	74 10                	je     5e5 <gets+0x61>
 5d5:	8a 45 ef             	mov    -0x11(%ebp),%al
 5d8:	3c 0d                	cmp    $0xd,%al
 5da:	74 09                	je     5e5 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5df:	40                   	inc    %eax
 5e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
 5e3:	7c ae                	jl     593 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 5e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	01 d0                	add    %edx,%eax
 5ed:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 5f0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5f3:	c9                   	leave  
 5f4:	c3                   	ret    

000005f5 <stat>:

int
stat(char *n, struct stat *st)
{
 5f5:	55                   	push   %ebp
 5f6:	89 e5                	mov    %esp,%ebp
 5f8:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 602:	00 
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	89 04 24             	mov    %eax,(%esp)
 609:	e8 06 01 00 00       	call   714 <open>
 60e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 611:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 615:	79 07                	jns    61e <stat+0x29>
    return -1;
 617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 61c:	eb 23                	jmp    641 <stat+0x4c>
  r = fstat(fd, st);
 61e:	8b 45 0c             	mov    0xc(%ebp),%eax
 621:	89 44 24 04          	mov    %eax,0x4(%esp)
 625:	8b 45 f4             	mov    -0xc(%ebp),%eax
 628:	89 04 24             	mov    %eax,(%esp)
 62b:	e8 fc 00 00 00       	call   72c <fstat>
 630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 633:	8b 45 f4             	mov    -0xc(%ebp),%eax
 636:	89 04 24             	mov    %eax,(%esp)
 639:	e8 be 00 00 00       	call   6fc <close>
  return r;
 63e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 641:	c9                   	leave  
 642:	c3                   	ret    

00000643 <atoi>:

int
atoi(const char *s)
{
 643:	55                   	push   %ebp
 644:	89 e5                	mov    %esp,%ebp
 646:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 649:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 650:	eb 24                	jmp    676 <atoi+0x33>
    n = n*10 + *s++ - '0';
 652:	8b 55 fc             	mov    -0x4(%ebp),%edx
 655:	89 d0                	mov    %edx,%eax
 657:	c1 e0 02             	shl    $0x2,%eax
 65a:	01 d0                	add    %edx,%eax
 65c:	01 c0                	add    %eax,%eax
 65e:	89 c1                	mov    %eax,%ecx
 660:	8b 45 08             	mov    0x8(%ebp),%eax
 663:	8d 50 01             	lea    0x1(%eax),%edx
 666:	89 55 08             	mov    %edx,0x8(%ebp)
 669:	8a 00                	mov    (%eax),%al
 66b:	0f be c0             	movsbl %al,%eax
 66e:	01 c8                	add    %ecx,%eax
 670:	83 e8 30             	sub    $0x30,%eax
 673:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 676:	8b 45 08             	mov    0x8(%ebp),%eax
 679:	8a 00                	mov    (%eax),%al
 67b:	3c 2f                	cmp    $0x2f,%al
 67d:	7e 09                	jle    688 <atoi+0x45>
 67f:	8b 45 08             	mov    0x8(%ebp),%eax
 682:	8a 00                	mov    (%eax),%al
 684:	3c 39                	cmp    $0x39,%al
 686:	7e ca                	jle    652 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 688:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 68b:	c9                   	leave  
 68c:	c3                   	ret    

0000068d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 68d:	55                   	push   %ebp
 68e:	89 e5                	mov    %esp,%ebp
 690:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 693:	8b 45 08             	mov    0x8(%ebp),%eax
 696:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 699:	8b 45 0c             	mov    0xc(%ebp),%eax
 69c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 69f:	eb 16                	jmp    6b7 <memmove+0x2a>
    *dst++ = *src++;
 6a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a4:	8d 50 01             	lea    0x1(%eax),%edx
 6a7:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6aa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6ad:	8d 4a 01             	lea    0x1(%edx),%ecx
 6b0:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6b3:	8a 12                	mov    (%edx),%dl
 6b5:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6b7:	8b 45 10             	mov    0x10(%ebp),%eax
 6ba:	8d 50 ff             	lea    -0x1(%eax),%edx
 6bd:	89 55 10             	mov    %edx,0x10(%ebp)
 6c0:	85 c0                	test   %eax,%eax
 6c2:	7f dd                	jg     6a1 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 6c4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6c7:	c9                   	leave  
 6c8:	c3                   	ret    
 6c9:	90                   	nop
 6ca:	90                   	nop
 6cb:	90                   	nop

000006cc <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6cc:	b8 01 00 00 00       	mov    $0x1,%eax
 6d1:	cd 40                	int    $0x40
 6d3:	c3                   	ret    

000006d4 <exit>:
SYSCALL(exit)
 6d4:	b8 02 00 00 00       	mov    $0x2,%eax
 6d9:	cd 40                	int    $0x40
 6db:	c3                   	ret    

000006dc <wait>:
SYSCALL(wait)
 6dc:	b8 03 00 00 00       	mov    $0x3,%eax
 6e1:	cd 40                	int    $0x40
 6e3:	c3                   	ret    

000006e4 <pipe>:
SYSCALL(pipe)
 6e4:	b8 04 00 00 00       	mov    $0x4,%eax
 6e9:	cd 40                	int    $0x40
 6eb:	c3                   	ret    

000006ec <read>:
SYSCALL(read)
 6ec:	b8 05 00 00 00       	mov    $0x5,%eax
 6f1:	cd 40                	int    $0x40
 6f3:	c3                   	ret    

000006f4 <write>:
SYSCALL(write)
 6f4:	b8 10 00 00 00       	mov    $0x10,%eax
 6f9:	cd 40                	int    $0x40
 6fb:	c3                   	ret    

000006fc <close>:
SYSCALL(close)
 6fc:	b8 15 00 00 00       	mov    $0x15,%eax
 701:	cd 40                	int    $0x40
 703:	c3                   	ret    

00000704 <kill>:
SYSCALL(kill)
 704:	b8 06 00 00 00       	mov    $0x6,%eax
 709:	cd 40                	int    $0x40
 70b:	c3                   	ret    

0000070c <exec>:
SYSCALL(exec)
 70c:	b8 07 00 00 00       	mov    $0x7,%eax
 711:	cd 40                	int    $0x40
 713:	c3                   	ret    

00000714 <open>:
SYSCALL(open)
 714:	b8 0f 00 00 00       	mov    $0xf,%eax
 719:	cd 40                	int    $0x40
 71b:	c3                   	ret    

0000071c <mknod>:
SYSCALL(mknod)
 71c:	b8 11 00 00 00       	mov    $0x11,%eax
 721:	cd 40                	int    $0x40
 723:	c3                   	ret    

00000724 <unlink>:
SYSCALL(unlink)
 724:	b8 12 00 00 00       	mov    $0x12,%eax
 729:	cd 40                	int    $0x40
 72b:	c3                   	ret    

0000072c <fstat>:
SYSCALL(fstat)
 72c:	b8 08 00 00 00       	mov    $0x8,%eax
 731:	cd 40                	int    $0x40
 733:	c3                   	ret    

00000734 <link>:
SYSCALL(link)
 734:	b8 13 00 00 00       	mov    $0x13,%eax
 739:	cd 40                	int    $0x40
 73b:	c3                   	ret    

0000073c <mkdir>:
SYSCALL(mkdir)
 73c:	b8 14 00 00 00       	mov    $0x14,%eax
 741:	cd 40                	int    $0x40
 743:	c3                   	ret    

00000744 <chdir>:
SYSCALL(chdir)
 744:	b8 09 00 00 00       	mov    $0x9,%eax
 749:	cd 40                	int    $0x40
 74b:	c3                   	ret    

0000074c <dup>:
SYSCALL(dup)
 74c:	b8 0a 00 00 00       	mov    $0xa,%eax
 751:	cd 40                	int    $0x40
 753:	c3                   	ret    

00000754 <getpid>:
SYSCALL(getpid)
 754:	b8 0b 00 00 00       	mov    $0xb,%eax
 759:	cd 40                	int    $0x40
 75b:	c3                   	ret    

0000075c <sbrk>:
SYSCALL(sbrk)
 75c:	b8 0c 00 00 00       	mov    $0xc,%eax
 761:	cd 40                	int    $0x40
 763:	c3                   	ret    

00000764 <sleep>:
SYSCALL(sleep)
 764:	b8 0d 00 00 00       	mov    $0xd,%eax
 769:	cd 40                	int    $0x40
 76b:	c3                   	ret    

0000076c <uptime>:
SYSCALL(uptime)
 76c:	b8 0e 00 00 00       	mov    $0xe,%eax
 771:	cd 40                	int    $0x40
 773:	c3                   	ret    

00000774 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 774:	55                   	push   %ebp
 775:	89 e5                	mov    %esp,%ebp
 777:	83 ec 18             	sub    $0x18,%esp
 77a:	8b 45 0c             	mov    0xc(%ebp),%eax
 77d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 780:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 787:	00 
 788:	8d 45 f4             	lea    -0xc(%ebp),%eax
 78b:	89 44 24 04          	mov    %eax,0x4(%esp)
 78f:	8b 45 08             	mov    0x8(%ebp),%eax
 792:	89 04 24             	mov    %eax,(%esp)
 795:	e8 5a ff ff ff       	call   6f4 <write>
}
 79a:	c9                   	leave  
 79b:	c3                   	ret    

0000079c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 79c:	55                   	push   %ebp
 79d:	89 e5                	mov    %esp,%ebp
 79f:	56                   	push   %esi
 7a0:	53                   	push   %ebx
 7a1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7a4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7ab:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7af:	74 17                	je     7c8 <printint+0x2c>
 7b1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7b5:	79 11                	jns    7c8 <printint+0x2c>
    neg = 1;
 7b7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7be:	8b 45 0c             	mov    0xc(%ebp),%eax
 7c1:	f7 d8                	neg    %eax
 7c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7c6:	eb 06                	jmp    7ce <printint+0x32>
  } else {
    x = xx;
 7c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 7cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7d5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7d8:	8d 41 01             	lea    0x1(%ecx),%eax
 7db:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7de:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7e4:	ba 00 00 00 00       	mov    $0x0,%edx
 7e9:	f7 f3                	div    %ebx
 7eb:	89 d0                	mov    %edx,%eax
 7ed:	8a 80 cc 0f 00 00    	mov    0xfcc(%eax),%al
 7f3:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 7f7:	8b 75 10             	mov    0x10(%ebp),%esi
 7fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
 7fd:	ba 00 00 00 00       	mov    $0x0,%edx
 802:	f7 f6                	div    %esi
 804:	89 45 ec             	mov    %eax,-0x14(%ebp)
 807:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 80b:	75 c8                	jne    7d5 <printint+0x39>
  if(neg)
 80d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 811:	74 10                	je     823 <printint+0x87>
    buf[i++] = '-';
 813:	8b 45 f4             	mov    -0xc(%ebp),%eax
 816:	8d 50 01             	lea    0x1(%eax),%edx
 819:	89 55 f4             	mov    %edx,-0xc(%ebp)
 81c:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 821:	eb 1e                	jmp    841 <printint+0xa5>
 823:	eb 1c                	jmp    841 <printint+0xa5>
    putc(fd, buf[i]);
 825:	8d 55 dc             	lea    -0x24(%ebp),%edx
 828:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82b:	01 d0                	add    %edx,%eax
 82d:	8a 00                	mov    (%eax),%al
 82f:	0f be c0             	movsbl %al,%eax
 832:	89 44 24 04          	mov    %eax,0x4(%esp)
 836:	8b 45 08             	mov    0x8(%ebp),%eax
 839:	89 04 24             	mov    %eax,(%esp)
 83c:	e8 33 ff ff ff       	call   774 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 841:	ff 4d f4             	decl   -0xc(%ebp)
 844:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 848:	79 db                	jns    825 <printint+0x89>
    putc(fd, buf[i]);
}
 84a:	83 c4 30             	add    $0x30,%esp
 84d:	5b                   	pop    %ebx
 84e:	5e                   	pop    %esi
 84f:	5d                   	pop    %ebp
 850:	c3                   	ret    

00000851 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 851:	55                   	push   %ebp
 852:	89 e5                	mov    %esp,%ebp
 854:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 857:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 85e:	8d 45 0c             	lea    0xc(%ebp),%eax
 861:	83 c0 04             	add    $0x4,%eax
 864:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 867:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 86e:	e9 77 01 00 00       	jmp    9ea <printf+0x199>
    c = fmt[i] & 0xff;
 873:	8b 55 0c             	mov    0xc(%ebp),%edx
 876:	8b 45 f0             	mov    -0x10(%ebp),%eax
 879:	01 d0                	add    %edx,%eax
 87b:	8a 00                	mov    (%eax),%al
 87d:	0f be c0             	movsbl %al,%eax
 880:	25 ff 00 00 00       	and    $0xff,%eax
 885:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 888:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 88c:	75 2c                	jne    8ba <printf+0x69>
      if(c == '%'){
 88e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 892:	75 0c                	jne    8a0 <printf+0x4f>
        state = '%';
 894:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 89b:	e9 47 01 00 00       	jmp    9e7 <printf+0x196>
      } else {
        putc(fd, c);
 8a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8a3:	0f be c0             	movsbl %al,%eax
 8a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8aa:	8b 45 08             	mov    0x8(%ebp),%eax
 8ad:	89 04 24             	mov    %eax,(%esp)
 8b0:	e8 bf fe ff ff       	call   774 <putc>
 8b5:	e9 2d 01 00 00       	jmp    9e7 <printf+0x196>
      }
    } else if(state == '%'){
 8ba:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8be:	0f 85 23 01 00 00    	jne    9e7 <printf+0x196>
      if(c == 'd'){
 8c4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8c8:	75 2d                	jne    8f7 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 8ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8cd:	8b 00                	mov    (%eax),%eax
 8cf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8d6:	00 
 8d7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8de:	00 
 8df:	89 44 24 04          	mov    %eax,0x4(%esp)
 8e3:	8b 45 08             	mov    0x8(%ebp),%eax
 8e6:	89 04 24             	mov    %eax,(%esp)
 8e9:	e8 ae fe ff ff       	call   79c <printint>
        ap++;
 8ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 8f2:	e9 e9 00 00 00       	jmp    9e0 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 8f7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 8fb:	74 06                	je     903 <printf+0xb2>
 8fd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 901:	75 2d                	jne    930 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 903:	8b 45 e8             	mov    -0x18(%ebp),%eax
 906:	8b 00                	mov    (%eax),%eax
 908:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 90f:	00 
 910:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 917:	00 
 918:	89 44 24 04          	mov    %eax,0x4(%esp)
 91c:	8b 45 08             	mov    0x8(%ebp),%eax
 91f:	89 04 24             	mov    %eax,(%esp)
 922:	e8 75 fe ff ff       	call   79c <printint>
        ap++;
 927:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 92b:	e9 b0 00 00 00       	jmp    9e0 <printf+0x18f>
      } else if(c == 's'){
 930:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 934:	75 42                	jne    978 <printf+0x127>
        s = (char*)*ap;
 936:	8b 45 e8             	mov    -0x18(%ebp),%eax
 939:	8b 00                	mov    (%eax),%eax
 93b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 93e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 942:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 946:	75 09                	jne    951 <printf+0x100>
          s = "(null)";
 948:	c7 45 f4 17 0c 00 00 	movl   $0xc17,-0xc(%ebp)
        while(*s != 0){
 94f:	eb 1c                	jmp    96d <printf+0x11c>
 951:	eb 1a                	jmp    96d <printf+0x11c>
          putc(fd, *s);
 953:	8b 45 f4             	mov    -0xc(%ebp),%eax
 956:	8a 00                	mov    (%eax),%al
 958:	0f be c0             	movsbl %al,%eax
 95b:	89 44 24 04          	mov    %eax,0x4(%esp)
 95f:	8b 45 08             	mov    0x8(%ebp),%eax
 962:	89 04 24             	mov    %eax,(%esp)
 965:	e8 0a fe ff ff       	call   774 <putc>
          s++;
 96a:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 970:	8a 00                	mov    (%eax),%al
 972:	84 c0                	test   %al,%al
 974:	75 dd                	jne    953 <printf+0x102>
 976:	eb 68                	jmp    9e0 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 978:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 97c:	75 1d                	jne    99b <printf+0x14a>
        putc(fd, *ap);
 97e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 981:	8b 00                	mov    (%eax),%eax
 983:	0f be c0             	movsbl %al,%eax
 986:	89 44 24 04          	mov    %eax,0x4(%esp)
 98a:	8b 45 08             	mov    0x8(%ebp),%eax
 98d:	89 04 24             	mov    %eax,(%esp)
 990:	e8 df fd ff ff       	call   774 <putc>
        ap++;
 995:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 999:	eb 45                	jmp    9e0 <printf+0x18f>
      } else if(c == '%'){
 99b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 99f:	75 17                	jne    9b8 <printf+0x167>
        putc(fd, c);
 9a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9a4:	0f be c0             	movsbl %al,%eax
 9a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ab:	8b 45 08             	mov    0x8(%ebp),%eax
 9ae:	89 04 24             	mov    %eax,(%esp)
 9b1:	e8 be fd ff ff       	call   774 <putc>
 9b6:	eb 28                	jmp    9e0 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9b8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9bf:	00 
 9c0:	8b 45 08             	mov    0x8(%ebp),%eax
 9c3:	89 04 24             	mov    %eax,(%esp)
 9c6:	e8 a9 fd ff ff       	call   774 <putc>
        putc(fd, c);
 9cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9ce:	0f be c0             	movsbl %al,%eax
 9d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	89 04 24             	mov    %eax,(%esp)
 9db:	e8 94 fd ff ff       	call   774 <putc>
      }
      state = 0;
 9e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 9e7:	ff 45 f0             	incl   -0x10(%ebp)
 9ea:	8b 55 0c             	mov    0xc(%ebp),%edx
 9ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9f0:	01 d0                	add    %edx,%eax
 9f2:	8a 00                	mov    (%eax),%al
 9f4:	84 c0                	test   %al,%al
 9f6:	0f 85 77 fe ff ff    	jne    873 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 9fc:	c9                   	leave  
 9fd:	c3                   	ret    
 9fe:	90                   	nop
 9ff:	90                   	nop

00000a00 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a00:	55                   	push   %ebp
 a01:	89 e5                	mov    %esp,%ebp
 a03:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a06:	8b 45 08             	mov    0x8(%ebp),%eax
 a09:	83 e8 08             	sub    $0x8,%eax
 a0c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0f:	a1 f0 0f 00 00       	mov    0xff0,%eax
 a14:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a17:	eb 24                	jmp    a3d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a1c:	8b 00                	mov    (%eax),%eax
 a1e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a21:	77 12                	ja     a35 <free+0x35>
 a23:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a26:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a29:	77 24                	ja     a4f <free+0x4f>
 a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a2e:	8b 00                	mov    (%eax),%eax
 a30:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a33:	77 1a                	ja     a4f <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a35:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a38:	8b 00                	mov    (%eax),%eax
 a3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a3d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a40:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a43:	76 d4                	jbe    a19 <free+0x19>
 a45:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a48:	8b 00                	mov    (%eax),%eax
 a4a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a4d:	76 ca                	jbe    a19 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a52:	8b 40 04             	mov    0x4(%eax),%eax
 a55:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a5f:	01 c2                	add    %eax,%edx
 a61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a64:	8b 00                	mov    (%eax),%eax
 a66:	39 c2                	cmp    %eax,%edx
 a68:	75 24                	jne    a8e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6d:	8b 50 04             	mov    0x4(%eax),%edx
 a70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a73:	8b 00                	mov    (%eax),%eax
 a75:	8b 40 04             	mov    0x4(%eax),%eax
 a78:	01 c2                	add    %eax,%edx
 a7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a7d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 a80:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a83:	8b 00                	mov    (%eax),%eax
 a85:	8b 10                	mov    (%eax),%edx
 a87:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a8a:	89 10                	mov    %edx,(%eax)
 a8c:	eb 0a                	jmp    a98 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 a8e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a91:	8b 10                	mov    (%eax),%edx
 a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a96:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9b:	8b 40 04             	mov    0x4(%eax),%eax
 a9e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa8:	01 d0                	add    %edx,%eax
 aaa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 aad:	75 20                	jne    acf <free+0xcf>
    p->s.size += bp->s.size;
 aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab2:	8b 50 04             	mov    0x4(%eax),%edx
 ab5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab8:	8b 40 04             	mov    0x4(%eax),%eax
 abb:	01 c2                	add    %eax,%edx
 abd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ac3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac6:	8b 10                	mov    (%eax),%edx
 ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acb:	89 10                	mov    %edx,(%eax)
 acd:	eb 08                	jmp    ad7 <free+0xd7>
  } else
    p->s.ptr = bp;
 acf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 ad5:	89 10                	mov    %edx,(%eax)
  freep = p;
 ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ada:	a3 f0 0f 00 00       	mov    %eax,0xff0
}
 adf:	c9                   	leave  
 ae0:	c3                   	ret    

00000ae1 <morecore>:

static Header*
morecore(uint nu)
{
 ae1:	55                   	push   %ebp
 ae2:	89 e5                	mov    %esp,%ebp
 ae4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ae7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 aee:	77 07                	ja     af7 <morecore+0x16>
    nu = 4096;
 af0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 af7:	8b 45 08             	mov    0x8(%ebp),%eax
 afa:	c1 e0 03             	shl    $0x3,%eax
 afd:	89 04 24             	mov    %eax,(%esp)
 b00:	e8 57 fc ff ff       	call   75c <sbrk>
 b05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b08:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b0c:	75 07                	jne    b15 <morecore+0x34>
    return 0;
 b0e:	b8 00 00 00 00       	mov    $0x0,%eax
 b13:	eb 22                	jmp    b37 <morecore+0x56>
  hp = (Header*)p;
 b15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b1e:	8b 55 08             	mov    0x8(%ebp),%edx
 b21:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b27:	83 c0 08             	add    $0x8,%eax
 b2a:	89 04 24             	mov    %eax,(%esp)
 b2d:	e8 ce fe ff ff       	call   a00 <free>
  return freep;
 b32:	a1 f0 0f 00 00       	mov    0xff0,%eax
}
 b37:	c9                   	leave  
 b38:	c3                   	ret    

00000b39 <malloc>:

void*
malloc(uint nbytes)
{
 b39:	55                   	push   %ebp
 b3a:	89 e5                	mov    %esp,%ebp
 b3c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b3f:	8b 45 08             	mov    0x8(%ebp),%eax
 b42:	83 c0 07             	add    $0x7,%eax
 b45:	c1 e8 03             	shr    $0x3,%eax
 b48:	40                   	inc    %eax
 b49:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b4c:	a1 f0 0f 00 00       	mov    0xff0,%eax
 b51:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b58:	75 23                	jne    b7d <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 b5a:	c7 45 f0 e8 0f 00 00 	movl   $0xfe8,-0x10(%ebp)
 b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b64:	a3 f0 0f 00 00       	mov    %eax,0xff0
 b69:	a1 f0 0f 00 00       	mov    0xff0,%eax
 b6e:	a3 e8 0f 00 00       	mov    %eax,0xfe8
    base.s.size = 0;
 b73:	c7 05 ec 0f 00 00 00 	movl   $0x0,0xfec
 b7a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b80:	8b 00                	mov    (%eax),%eax
 b82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b88:	8b 40 04             	mov    0x4(%eax),%eax
 b8b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b8e:	72 4d                	jb     bdd <malloc+0xa4>
      if(p->s.size == nunits)
 b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b93:	8b 40 04             	mov    0x4(%eax),%eax
 b96:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 b99:	75 0c                	jne    ba7 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9e:	8b 10                	mov    (%eax),%edx
 ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba3:	89 10                	mov    %edx,(%eax)
 ba5:	eb 26                	jmp    bcd <malloc+0x94>
      else {
        p->s.size -= nunits;
 ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 baa:	8b 40 04             	mov    0x4(%eax),%eax
 bad:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bb0:	89 c2                	mov    %eax,%edx
 bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbb:	8b 40 04             	mov    0x4(%eax),%eax
 bbe:	c1 e0 03             	shl    $0x3,%eax
 bc1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bca:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bd0:	a3 f0 0f 00 00       	mov    %eax,0xff0
      return (void*)(p + 1);
 bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd8:	83 c0 08             	add    $0x8,%eax
 bdb:	eb 38                	jmp    c15 <malloc+0xdc>
    }
    if(p == freep)
 bdd:	a1 f0 0f 00 00       	mov    0xff0,%eax
 be2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 be5:	75 1b                	jne    c02 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bea:	89 04 24             	mov    %eax,(%esp)
 bed:	e8 ef fe ff ff       	call   ae1 <morecore>
 bf2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 bf5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 bf9:	75 07                	jne    c02 <malloc+0xc9>
        return 0;
 bfb:	b8 00 00 00 00       	mov    $0x0,%eax
 c00:	eb 13                	jmp    c15 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c05:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0b:	8b 00                	mov    (%eax),%eax
 c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c10:	e9 70 ff ff ff       	jmp    b85 <malloc+0x4c>
}
 c15:	c9                   	leave  
 c16:	c3                   	ret    
