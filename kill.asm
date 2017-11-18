
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "usage: kill pid...\n");
   f:	c7 44 24 04 5b 0c 00 	movl   $0xc5b,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 72 08 00 00       	call   895 <printf>
    exit();
  23:	e8 f0 06 00 00       	call   718 <exit>
  }
  for(i=1; i<argc; i++)
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 26                	jmp    58 <main+0x58>
    kill(atoi(argv[i]));
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 3b 06 00 00       	call   687 <atoi>
  4c:	89 04 24             	mov    %eax,(%esp)
  4f:	e8 f4 06 00 00       	call   748 <kill>

  if(argc < 2){
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  54:	ff 44 24 1c          	incl   0x1c(%esp)
  58:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  5c:	3b 45 08             	cmp    0x8(%ebp),%eax
  5f:	7c d1                	jl     32 <main+0x32>
    kill(atoi(argv[i]));
  exit();
  61:	e8 b2 06 00 00       	call   718 <exit>
  66:	90                   	nop
  67:	90                   	nop

00000068 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	57                   	push   %edi
  6c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  70:	8b 55 10             	mov    0x10(%ebp),%edx
  73:	8b 45 0c             	mov    0xc(%ebp),%eax
  76:	89 cb                	mov    %ecx,%ebx
  78:	89 df                	mov    %ebx,%edi
  7a:	89 d1                	mov    %edx,%ecx
  7c:	fc                   	cld    
  7d:	f3 aa                	rep stos %al,%es:(%edi)
  7f:	89 ca                	mov    %ecx,%edx
  81:	89 fb                	mov    %edi,%ebx
  83:	89 5d 08             	mov    %ebx,0x8(%ebp)
  86:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  89:	5b                   	pop    %ebx
  8a:	5f                   	pop    %edi
  8b:	5d                   	pop    %ebp
  8c:	c3                   	ret    

0000008d <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  93:	8b 45 08             	mov    0x8(%ebp),%eax
  96:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  99:	90                   	nop
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	8d 50 01             	lea    0x1(%eax),%edx
  a0:	89 55 08             	mov    %edx,0x8(%ebp)
  a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  a6:	8d 4a 01             	lea    0x1(%edx),%ecx
  a9:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  ac:	8a 12                	mov    (%edx),%dl
  ae:	88 10                	mov    %dl,(%eax)
  b0:	8a 00                	mov    (%eax),%al
  b2:	84 c0                	test   %al,%al
  b4:	75 e4                	jne    9a <strcpy+0xd>
    ;
  return os;
  b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  b9:	c9                   	leave  
  ba:	c3                   	ret    

000000bb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  be:	eb 06                	jmp    c6 <strcmp+0xb>
    p++, q++;
  c0:	ff 45 08             	incl   0x8(%ebp)
  c3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  c6:	8b 45 08             	mov    0x8(%ebp),%eax
  c9:	8a 00                	mov    (%eax),%al
  cb:	84 c0                	test   %al,%al
  cd:	74 0e                	je     dd <strcmp+0x22>
  cf:	8b 45 08             	mov    0x8(%ebp),%eax
  d2:	8a 10                	mov    (%eax),%dl
  d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  d7:	8a 00                	mov    (%eax),%al
  d9:	38 c2                	cmp    %al,%dl
  db:	74 e3                	je     c0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  dd:	8b 45 08             	mov    0x8(%ebp),%eax
  e0:	8a 00                	mov    (%eax),%al
  e2:	0f b6 d0             	movzbl %al,%edx
  e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  e8:	8a 00                	mov    (%eax),%al
  ea:	0f b6 c0             	movzbl %al,%eax
  ed:	29 c2                	sub    %eax,%edx
  ef:	89 d0                	mov    %edx,%eax
}
  f1:	5d                   	pop    %ebp
  f2:	c3                   	ret    

000000f3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
  f3:	55                   	push   %ebp
  f4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
  f6:	eb 09                	jmp    101 <strncmp+0xe>
    n--, p++, q++;
  f8:	ff 4d 10             	decl   0x10(%ebp)
  fb:	ff 45 08             	incl   0x8(%ebp)
  fe:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 101:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 105:	74 17                	je     11e <strncmp+0x2b>
 107:	8b 45 08             	mov    0x8(%ebp),%eax
 10a:	8a 00                	mov    (%eax),%al
 10c:	84 c0                	test   %al,%al
 10e:	74 0e                	je     11e <strncmp+0x2b>
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	8a 10                	mov    (%eax),%dl
 115:	8b 45 0c             	mov    0xc(%ebp),%eax
 118:	8a 00                	mov    (%eax),%al
 11a:	38 c2                	cmp    %al,%dl
 11c:	74 da                	je     f8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 11e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 122:	75 07                	jne    12b <strncmp+0x38>
    return 0;
 124:	b8 00 00 00 00       	mov    $0x0,%eax
 129:	eb 14                	jmp    13f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 12b:	8b 45 08             	mov    0x8(%ebp),%eax
 12e:	8a 00                	mov    (%eax),%al
 130:	0f b6 d0             	movzbl %al,%edx
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	8a 00                	mov    (%eax),%al
 138:	0f b6 c0             	movzbl %al,%eax
 13b:	29 c2                	sub    %eax,%edx
 13d:	89 d0                	mov    %edx,%eax
}
 13f:	5d                   	pop    %ebp
 140:	c3                   	ret    

00000141 <strlen>:

uint
strlen(const char *s)
{
 141:	55                   	push   %ebp
 142:	89 e5                	mov    %esp,%ebp
 144:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 147:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 14e:	eb 03                	jmp    153 <strlen+0x12>
 150:	ff 45 fc             	incl   -0x4(%ebp)
 153:	8b 55 fc             	mov    -0x4(%ebp),%edx
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	01 d0                	add    %edx,%eax
 15b:	8a 00                	mov    (%eax),%al
 15d:	84 c0                	test   %al,%al
 15f:	75 ef                	jne    150 <strlen+0xf>
    ;
  return n;
 161:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <memset>:

void*
memset(void *dst, int c, uint n)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 16c:	8b 45 10             	mov    0x10(%ebp),%eax
 16f:	89 44 24 08          	mov    %eax,0x8(%esp)
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	89 44 24 04          	mov    %eax,0x4(%esp)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	89 04 24             	mov    %eax,(%esp)
 180:	e8 e3 fe ff ff       	call   68 <stosb>
  return dst;
 185:	8b 45 08             	mov    0x8(%ebp),%eax
}
 188:	c9                   	leave  
 189:	c3                   	ret    

0000018a <strchr>:

char*
strchr(const char *s, char c)
{
 18a:	55                   	push   %ebp
 18b:	89 e5                	mov    %esp,%ebp
 18d:	83 ec 04             	sub    $0x4,%esp
 190:	8b 45 0c             	mov    0xc(%ebp),%eax
 193:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 196:	eb 12                	jmp    1aa <strchr+0x20>
    if(*s == c)
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	8a 00                	mov    (%eax),%al
 19d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1a0:	75 05                	jne    1a7 <strchr+0x1d>
      return (char*)s;
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	eb 11                	jmp    1b8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1a7:	ff 45 08             	incl   0x8(%ebp)
 1aa:	8b 45 08             	mov    0x8(%ebp),%eax
 1ad:	8a 00                	mov    (%eax),%al
 1af:	84 c0                	test   %al,%al
 1b1:	75 e5                	jne    198 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b8:	c9                   	leave  
 1b9:	c3                   	ret    

000001ba <strcat>:

char *
strcat(char *dest, const char *src)
{
 1ba:	55                   	push   %ebp
 1bb:	89 e5                	mov    %esp,%ebp
 1bd:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 1c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1c7:	eb 03                	jmp    1cc <strcat+0x12>
 1c9:	ff 45 fc             	incl   -0x4(%ebp)
 1cc:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1cf:	8b 45 08             	mov    0x8(%ebp),%eax
 1d2:	01 d0                	add    %edx,%eax
 1d4:	8a 00                	mov    (%eax),%al
 1d6:	84 c0                	test   %al,%al
 1d8:	75 ef                	jne    1c9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 1da:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 1e1:	eb 1e                	jmp    201 <strcat+0x47>
        dest[i+j] = src[j];
 1e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 1e6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e9:	01 d0                	add    %edx,%eax
 1eb:	89 c2                	mov    %eax,%edx
 1ed:	8b 45 08             	mov    0x8(%ebp),%eax
 1f0:	01 c2                	add    %eax,%edx
 1f2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 1f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f8:	01 c8                	add    %ecx,%eax
 1fa:	8a 00                	mov    (%eax),%al
 1fc:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 1fe:	ff 45 f8             	incl   -0x8(%ebp)
 201:	8b 55 f8             	mov    -0x8(%ebp),%edx
 204:	8b 45 0c             	mov    0xc(%ebp),%eax
 207:	01 d0                	add    %edx,%eax
 209:	8a 00                	mov    (%eax),%al
 20b:	84 c0                	test   %al,%al
 20d:	75 d4                	jne    1e3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 20f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 212:	8b 55 fc             	mov    -0x4(%ebp),%edx
 215:	01 d0                	add    %edx,%eax
 217:	89 c2                	mov    %eax,%edx
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	01 d0                	add    %edx,%eax
 21e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 221:	8b 45 08             	mov    0x8(%ebp),%eax
}
 224:	c9                   	leave  
 225:	c3                   	ret    

00000226 <strstr>:

int 
strstr(char* s, char* sub)
{
 226:	55                   	push   %ebp
 227:	89 e5                	mov    %esp,%ebp
 229:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 22c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 233:	eb 7c                	jmp    2b1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 235:	8b 55 fc             	mov    -0x4(%ebp),%edx
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	01 d0                	add    %edx,%eax
 23d:	8a 10                	mov    (%eax),%dl
 23f:	8b 45 0c             	mov    0xc(%ebp),%eax
 242:	8a 00                	mov    (%eax),%al
 244:	38 c2                	cmp    %al,%dl
 246:	75 66                	jne    2ae <strstr+0x88>
        {
            if(strlen(sub) == 1)
 248:	8b 45 0c             	mov    0xc(%ebp),%eax
 24b:	89 04 24             	mov    %eax,(%esp)
 24e:	e8 ee fe ff ff       	call   141 <strlen>
 253:	83 f8 01             	cmp    $0x1,%eax
 256:	75 05                	jne    25d <strstr+0x37>
            {  
                return i;
 258:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25b:	eb 6b                	jmp    2c8 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 25d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 264:	eb 3a                	jmp    2a0 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 266:	8b 45 f8             	mov    -0x8(%ebp),%eax
 269:	8b 55 fc             	mov    -0x4(%ebp),%edx
 26c:	01 d0                	add    %edx,%eax
 26e:	89 c2                	mov    %eax,%edx
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	01 d0                	add    %edx,%eax
 275:	8a 10                	mov    (%eax),%dl
 277:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 27a:	8b 45 0c             	mov    0xc(%ebp),%eax
 27d:	01 c8                	add    %ecx,%eax
 27f:	8a 00                	mov    (%eax),%al
 281:	38 c2                	cmp    %al,%dl
 283:	75 16                	jne    29b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 285:	8b 45 f8             	mov    -0x8(%ebp),%eax
 288:	8d 50 01             	lea    0x1(%eax),%edx
 28b:	8b 45 0c             	mov    0xc(%ebp),%eax
 28e:	01 d0                	add    %edx,%eax
 290:	8a 00                	mov    (%eax),%al
 292:	84 c0                	test   %al,%al
 294:	75 07                	jne    29d <strstr+0x77>
                    {
                        return i;
 296:	8b 45 fc             	mov    -0x4(%ebp),%eax
 299:	eb 2d                	jmp    2c8 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 29b:	eb 11                	jmp    2ae <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 29d:	ff 45 f8             	incl   -0x8(%ebp)
 2a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a6:	01 d0                	add    %edx,%eax
 2a8:	8a 00                	mov    (%eax),%al
 2aa:	84 c0                	test   %al,%al
 2ac:	75 b8                	jne    266 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2ae:	ff 45 fc             	incl   -0x4(%ebp)
 2b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	01 d0                	add    %edx,%eax
 2b9:	8a 00                	mov    (%eax),%al
 2bb:	84 c0                	test   %al,%al
 2bd:	0f 85 72 ff ff ff    	jne    235 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 2c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 2c8:	c9                   	leave  
 2c9:	c3                   	ret    

000002ca <strtok>:

char *
strtok(char *s, const char *delim)
{
 2ca:	55                   	push   %ebp
 2cb:	89 e5                	mov    %esp,%ebp
 2cd:	53                   	push   %ebx
 2ce:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 2d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2d5:	75 08                	jne    2df <strtok+0x15>
  s = lasts;
 2d7:	a1 44 10 00 00       	mov    0x1044,%eax
 2dc:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	8d 50 01             	lea    0x1(%eax),%edx
 2e5:	89 55 08             	mov    %edx,0x8(%ebp)
 2e8:	8a 00                	mov    (%eax),%al
 2ea:	0f be d8             	movsbl %al,%ebx
 2ed:	85 db                	test   %ebx,%ebx
 2ef:	75 07                	jne    2f8 <strtok+0x2e>
      return 0;
 2f1:	b8 00 00 00 00       	mov    $0x0,%eax
 2f6:	eb 58                	jmp    350 <strtok+0x86>
    } while (strchr(delim, ch));
 2f8:	88 d8                	mov    %bl,%al
 2fa:	0f be c0             	movsbl %al,%eax
 2fd:	89 44 24 04          	mov    %eax,0x4(%esp)
 301:	8b 45 0c             	mov    0xc(%ebp),%eax
 304:	89 04 24             	mov    %eax,(%esp)
 307:	e8 7e fe ff ff       	call   18a <strchr>
 30c:	85 c0                	test   %eax,%eax
 30e:	75 cf                	jne    2df <strtok+0x15>
    --s;
 310:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 313:	8b 45 0c             	mov    0xc(%ebp),%eax
 316:	89 44 24 04          	mov    %eax,0x4(%esp)
 31a:	8b 45 08             	mov    0x8(%ebp),%eax
 31d:	89 04 24             	mov    %eax,(%esp)
 320:	e8 31 00 00 00       	call   356 <strcspn>
 325:	89 c2                	mov    %eax,%edx
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	01 d0                	add    %edx,%eax
 32c:	a3 44 10 00 00       	mov    %eax,0x1044
    if (*lasts != 0)
 331:	a1 44 10 00 00       	mov    0x1044,%eax
 336:	8a 00                	mov    (%eax),%al
 338:	84 c0                	test   %al,%al
 33a:	74 11                	je     34d <strtok+0x83>
  *lasts++ = 0;
 33c:	a1 44 10 00 00       	mov    0x1044,%eax
 341:	8d 50 01             	lea    0x1(%eax),%edx
 344:	89 15 44 10 00 00    	mov    %edx,0x1044
 34a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 350:	83 c4 14             	add    $0x14,%esp
 353:	5b                   	pop    %ebx
 354:	5d                   	pop    %ebp
 355:	c3                   	ret    

00000356 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 356:	55                   	push   %ebp
 357:	89 e5                	mov    %esp,%ebp
 359:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 35c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 363:	eb 26                	jmp    38b <strcspn+0x35>
        if(strchr(s2,*s1))
 365:	8b 45 08             	mov    0x8(%ebp),%eax
 368:	8a 00                	mov    (%eax),%al
 36a:	0f be c0             	movsbl %al,%eax
 36d:	89 44 24 04          	mov    %eax,0x4(%esp)
 371:	8b 45 0c             	mov    0xc(%ebp),%eax
 374:	89 04 24             	mov    %eax,(%esp)
 377:	e8 0e fe ff ff       	call   18a <strchr>
 37c:	85 c0                	test   %eax,%eax
 37e:	74 05                	je     385 <strcspn+0x2f>
            return ret;
 380:	8b 45 fc             	mov    -0x4(%ebp),%eax
 383:	eb 12                	jmp    397 <strcspn+0x41>
        else
            s1++,ret++;
 385:	ff 45 08             	incl   0x8(%ebp)
 388:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	8a 00                	mov    (%eax),%al
 390:	84 c0                	test   %al,%al
 392:	75 d1                	jne    365 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 394:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 397:	c9                   	leave  
 398:	c3                   	ret    

00000399 <isspace>:

int
isspace(unsigned char c)
{
 399:	55                   	push   %ebp
 39a:	89 e5                	mov    %esp,%ebp
 39c:	83 ec 04             	sub    $0x4,%esp
 39f:	8b 45 08             	mov    0x8(%ebp),%eax
 3a2:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 3a5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 3a9:	74 1e                	je     3c9 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 3ab:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 3af:	74 18                	je     3c9 <isspace+0x30>
 3b1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 3b5:	74 12                	je     3c9 <isspace+0x30>
 3b7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 3bb:	74 0c                	je     3c9 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 3bd:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 3c1:	74 06                	je     3c9 <isspace+0x30>
 3c3:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 3c7:	75 07                	jne    3d0 <isspace+0x37>
 3c9:	b8 01 00 00 00       	mov    $0x1,%eax
 3ce:	eb 05                	jmp    3d5 <isspace+0x3c>
 3d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3d5:	c9                   	leave  
 3d6:	c3                   	ret    

000003d7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	57                   	push   %edi
 3db:	56                   	push   %esi
 3dc:	53                   	push   %ebx
 3dd:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 3e0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 3e5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 3ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 3ef:	eb 01                	jmp    3f2 <strtoul+0x1b>
  p += 1;
 3f1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 3f2:	8a 03                	mov    (%ebx),%al
 3f4:	0f b6 c0             	movzbl %al,%eax
 3f7:	89 04 24             	mov    %eax,(%esp)
 3fa:	e8 9a ff ff ff       	call   399 <isspace>
 3ff:	85 c0                	test   %eax,%eax
 401:	75 ee                	jne    3f1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 403:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 407:	75 30                	jne    439 <strtoul+0x62>
    {
  if (*p == '0') {
 409:	8a 03                	mov    (%ebx),%al
 40b:	3c 30                	cmp    $0x30,%al
 40d:	75 21                	jne    430 <strtoul+0x59>
      p += 1;
 40f:	43                   	inc    %ebx
      if (*p == 'x') {
 410:	8a 03                	mov    (%ebx),%al
 412:	3c 78                	cmp    $0x78,%al
 414:	75 0a                	jne    420 <strtoul+0x49>
    p += 1;
 416:	43                   	inc    %ebx
    base = 16;
 417:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 41e:	eb 31                	jmp    451 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 420:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 427:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 42e:	eb 21                	jmp    451 <strtoul+0x7a>
      }
  }
  else base = 10;
 430:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 437:	eb 18                	jmp    451 <strtoul+0x7a>
    } else if (base == 16) {
 439:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 43d:	75 12                	jne    451 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 43f:	8a 03                	mov    (%ebx),%al
 441:	3c 30                	cmp    $0x30,%al
 443:	75 0c                	jne    451 <strtoul+0x7a>
 445:	8d 43 01             	lea    0x1(%ebx),%eax
 448:	8a 00                	mov    (%eax),%al
 44a:	3c 78                	cmp    $0x78,%al
 44c:	75 03                	jne    451 <strtoul+0x7a>
      p += 2;
 44e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 451:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 455:	75 29                	jne    480 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 457:	8a 03                	mov    (%ebx),%al
 459:	0f be c0             	movsbl %al,%eax
 45c:	83 e8 30             	sub    $0x30,%eax
 45f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 461:	83 fe 07             	cmp    $0x7,%esi
 464:	76 06                	jbe    46c <strtoul+0x95>
    break;
 466:	90                   	nop
 467:	e9 b6 00 00 00       	jmp    522 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 46c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 473:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 476:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 47d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 47e:	eb d7                	jmp    457 <strtoul+0x80>
    } else if (base == 10) {
 480:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 484:	75 2b                	jne    4b1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 486:	8a 03                	mov    (%ebx),%al
 488:	0f be c0             	movsbl %al,%eax
 48b:	83 e8 30             	sub    $0x30,%eax
 48e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 490:	83 fe 09             	cmp    $0x9,%esi
 493:	76 06                	jbe    49b <strtoul+0xc4>
    break;
 495:	90                   	nop
 496:	e9 87 00 00 00       	jmp    522 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 49b:	89 f8                	mov    %edi,%eax
 49d:	c1 e0 02             	shl    $0x2,%eax
 4a0:	01 f8                	add    %edi,%eax
 4a2:	01 c0                	add    %eax,%eax
 4a4:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4a7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 4ae:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 4af:	eb d5                	jmp    486 <strtoul+0xaf>
    } else if (base == 16) {
 4b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4b5:	75 35                	jne    4ec <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4b7:	8a 03                	mov    (%ebx),%al
 4b9:	0f be c0             	movsbl %al,%eax
 4bc:	83 e8 30             	sub    $0x30,%eax
 4bf:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 4c1:	83 fe 4a             	cmp    $0x4a,%esi
 4c4:	76 02                	jbe    4c8 <strtoul+0xf1>
    break;
 4c6:	eb 22                	jmp    4ea <strtoul+0x113>
      }
      digit = cvtIn[digit];
 4c8:	8a 86 e0 0f 00 00    	mov    0xfe0(%esi),%al
 4ce:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 4d1:	83 fe 0f             	cmp    $0xf,%esi
 4d4:	76 02                	jbe    4d8 <strtoul+0x101>
    break;
 4d6:	eb 12                	jmp    4ea <strtoul+0x113>
      }
      result = (result << 4) + digit;
 4d8:	89 f8                	mov    %edi,%eax
 4da:	c1 e0 04             	shl    $0x4,%eax
 4dd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4e0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 4e7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 4e8:	eb cd                	jmp    4b7 <strtoul+0xe0>
 4ea:	eb 36                	jmp    522 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 4ec:	8a 03                	mov    (%ebx),%al
 4ee:	0f be c0             	movsbl %al,%eax
 4f1:	83 e8 30             	sub    $0x30,%eax
 4f4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 4f6:	83 fe 4a             	cmp    $0x4a,%esi
 4f9:	76 02                	jbe    4fd <strtoul+0x126>
    break;
 4fb:	eb 25                	jmp    522 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 4fd:	8a 86 e0 0f 00 00    	mov    0xfe0(%esi),%al
 503:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 506:	8b 45 10             	mov    0x10(%ebp),%eax
 509:	39 f0                	cmp    %esi,%eax
 50b:	77 02                	ja     50f <strtoul+0x138>
    break;
 50d:	eb 13                	jmp    522 <strtoul+0x14b>
      }
      result = result*base + digit;
 50f:	8b 45 10             	mov    0x10(%ebp),%eax
 512:	0f af c7             	imul   %edi,%eax
 515:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 518:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 51f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 520:	eb ca                	jmp    4ec <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 522:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 526:	75 03                	jne    52b <strtoul+0x154>
  p = string;
 528:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 52b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 52f:	74 05                	je     536 <strtoul+0x15f>
  *endPtr = p;
 531:	8b 45 0c             	mov    0xc(%ebp),%eax
 534:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 536:	89 f8                	mov    %edi,%eax
}
 538:	83 c4 14             	add    $0x14,%esp
 53b:	5b                   	pop    %ebx
 53c:	5e                   	pop    %esi
 53d:	5f                   	pop    %edi
 53e:	5d                   	pop    %ebp
 53f:	c3                   	ret    

00000540 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	53                   	push   %ebx
 544:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 547:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 54a:	eb 01                	jmp    54d <strtol+0xd>
      p += 1;
 54c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 54d:	8a 03                	mov    (%ebx),%al
 54f:	0f b6 c0             	movzbl %al,%eax
 552:	89 04 24             	mov    %eax,(%esp)
 555:	e8 3f fe ff ff       	call   399 <isspace>
 55a:	85 c0                	test   %eax,%eax
 55c:	75 ee                	jne    54c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 55e:	8a 03                	mov    (%ebx),%al
 560:	3c 2d                	cmp    $0x2d,%al
 562:	75 1e                	jne    582 <strtol+0x42>
  p += 1;
 564:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 565:	8b 45 10             	mov    0x10(%ebp),%eax
 568:	89 44 24 08          	mov    %eax,0x8(%esp)
 56c:	8b 45 0c             	mov    0xc(%ebp),%eax
 56f:	89 44 24 04          	mov    %eax,0x4(%esp)
 573:	89 1c 24             	mov    %ebx,(%esp)
 576:	e8 5c fe ff ff       	call   3d7 <strtoul>
 57b:	f7 d8                	neg    %eax
 57d:	89 45 f8             	mov    %eax,-0x8(%ebp)
 580:	eb 20                	jmp    5a2 <strtol+0x62>
    } else {
  if (*p == '+') {
 582:	8a 03                	mov    (%ebx),%al
 584:	3c 2b                	cmp    $0x2b,%al
 586:	75 01                	jne    589 <strtol+0x49>
      p += 1;
 588:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 589:	8b 45 10             	mov    0x10(%ebp),%eax
 58c:	89 44 24 08          	mov    %eax,0x8(%esp)
 590:	8b 45 0c             	mov    0xc(%ebp),%eax
 593:	89 44 24 04          	mov    %eax,0x4(%esp)
 597:	89 1c 24             	mov    %ebx,(%esp)
 59a:	e8 38 fe ff ff       	call   3d7 <strtoul>
 59f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 5a2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 5a6:	75 17                	jne    5bf <strtol+0x7f>
 5a8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ac:	74 11                	je     5bf <strtol+0x7f>
 5ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 5b1:	8b 00                	mov    (%eax),%eax
 5b3:	39 d8                	cmp    %ebx,%eax
 5b5:	75 08                	jne    5bf <strtol+0x7f>
  *endPtr = string;
 5b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ba:	8b 55 08             	mov    0x8(%ebp),%edx
 5bd:	89 10                	mov    %edx,(%eax)
    }
    return result;
 5bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 5c2:	83 c4 1c             	add    $0x1c,%esp
 5c5:	5b                   	pop    %ebx
 5c6:	5d                   	pop    %ebp
 5c7:	c3                   	ret    

000005c8 <gets>:

char*
gets(char *buf, int max)
{
 5c8:	55                   	push   %ebp
 5c9:	89 e5                	mov    %esp,%ebp
 5cb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5d5:	eb 49                	jmp    620 <gets+0x58>
    cc = read(0, &c, 1);
 5d7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5de:	00 
 5df:	8d 45 ef             	lea    -0x11(%ebp),%eax
 5e2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 5ed:	e8 3e 01 00 00       	call   730 <read>
 5f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 5f5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5f9:	7f 02                	jg     5fd <gets+0x35>
      break;
 5fb:	eb 2c                	jmp    629 <gets+0x61>
    buf[i++] = c;
 5fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 600:	8d 50 01             	lea    0x1(%eax),%edx
 603:	89 55 f4             	mov    %edx,-0xc(%ebp)
 606:	89 c2                	mov    %eax,%edx
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	01 c2                	add    %eax,%edx
 60d:	8a 45 ef             	mov    -0x11(%ebp),%al
 610:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 612:	8a 45 ef             	mov    -0x11(%ebp),%al
 615:	3c 0a                	cmp    $0xa,%al
 617:	74 10                	je     629 <gets+0x61>
 619:	8a 45 ef             	mov    -0x11(%ebp),%al
 61c:	3c 0d                	cmp    $0xd,%al
 61e:	74 09                	je     629 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 620:	8b 45 f4             	mov    -0xc(%ebp),%eax
 623:	40                   	inc    %eax
 624:	3b 45 0c             	cmp    0xc(%ebp),%eax
 627:	7c ae                	jl     5d7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 629:	8b 55 f4             	mov    -0xc(%ebp),%edx
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	01 d0                	add    %edx,%eax
 631:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 634:	8b 45 08             	mov    0x8(%ebp),%eax
}
 637:	c9                   	leave  
 638:	c3                   	ret    

00000639 <stat>:

int
stat(char *n, struct stat *st)
{
 639:	55                   	push   %ebp
 63a:	89 e5                	mov    %esp,%ebp
 63c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 63f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 646:	00 
 647:	8b 45 08             	mov    0x8(%ebp),%eax
 64a:	89 04 24             	mov    %eax,(%esp)
 64d:	e8 06 01 00 00       	call   758 <open>
 652:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 659:	79 07                	jns    662 <stat+0x29>
    return -1;
 65b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 660:	eb 23                	jmp    685 <stat+0x4c>
  r = fstat(fd, st);
 662:	8b 45 0c             	mov    0xc(%ebp),%eax
 665:	89 44 24 04          	mov    %eax,0x4(%esp)
 669:	8b 45 f4             	mov    -0xc(%ebp),%eax
 66c:	89 04 24             	mov    %eax,(%esp)
 66f:	e8 fc 00 00 00       	call   770 <fstat>
 674:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 677:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67a:	89 04 24             	mov    %eax,(%esp)
 67d:	e8 be 00 00 00       	call   740 <close>
  return r;
 682:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 685:	c9                   	leave  
 686:	c3                   	ret    

00000687 <atoi>:

int
atoi(const char *s)
{
 687:	55                   	push   %ebp
 688:	89 e5                	mov    %esp,%ebp
 68a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 68d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 694:	eb 24                	jmp    6ba <atoi+0x33>
    n = n*10 + *s++ - '0';
 696:	8b 55 fc             	mov    -0x4(%ebp),%edx
 699:	89 d0                	mov    %edx,%eax
 69b:	c1 e0 02             	shl    $0x2,%eax
 69e:	01 d0                	add    %edx,%eax
 6a0:	01 c0                	add    %eax,%eax
 6a2:	89 c1                	mov    %eax,%ecx
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	8d 50 01             	lea    0x1(%eax),%edx
 6aa:	89 55 08             	mov    %edx,0x8(%ebp)
 6ad:	8a 00                	mov    (%eax),%al
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	01 c8                	add    %ecx,%eax
 6b4:	83 e8 30             	sub    $0x30,%eax
 6b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6ba:	8b 45 08             	mov    0x8(%ebp),%eax
 6bd:	8a 00                	mov    (%eax),%al
 6bf:	3c 2f                	cmp    $0x2f,%al
 6c1:	7e 09                	jle    6cc <atoi+0x45>
 6c3:	8b 45 08             	mov    0x8(%ebp),%eax
 6c6:	8a 00                	mov    (%eax),%al
 6c8:	3c 39                	cmp    $0x39,%al
 6ca:	7e ca                	jle    696 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 6cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6cf:	c9                   	leave  
 6d0:	c3                   	ret    

000006d1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 6d1:	55                   	push   %ebp
 6d2:	89 e5                	mov    %esp,%ebp
 6d4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 6dd:	8b 45 0c             	mov    0xc(%ebp),%eax
 6e0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 6e3:	eb 16                	jmp    6fb <memmove+0x2a>
    *dst++ = *src++;
 6e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e8:	8d 50 01             	lea    0x1(%eax),%edx
 6eb:	89 55 fc             	mov    %edx,-0x4(%ebp)
 6ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6f1:	8d 4a 01             	lea    0x1(%edx),%ecx
 6f4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 6f7:	8a 12                	mov    (%edx),%dl
 6f9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 6fb:	8b 45 10             	mov    0x10(%ebp),%eax
 6fe:	8d 50 ff             	lea    -0x1(%eax),%edx
 701:	89 55 10             	mov    %edx,0x10(%ebp)
 704:	85 c0                	test   %eax,%eax
 706:	7f dd                	jg     6e5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 708:	8b 45 08             	mov    0x8(%ebp),%eax
}
 70b:	c9                   	leave  
 70c:	c3                   	ret    
 70d:	90                   	nop
 70e:	90                   	nop
 70f:	90                   	nop

00000710 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 710:	b8 01 00 00 00       	mov    $0x1,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <exit>:
SYSCALL(exit)
 718:	b8 02 00 00 00       	mov    $0x2,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <wait>:
SYSCALL(wait)
 720:	b8 03 00 00 00       	mov    $0x3,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <pipe>:
SYSCALL(pipe)
 728:	b8 04 00 00 00       	mov    $0x4,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <read>:
SYSCALL(read)
 730:	b8 05 00 00 00       	mov    $0x5,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <write>:
SYSCALL(write)
 738:	b8 10 00 00 00       	mov    $0x10,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <close>:
SYSCALL(close)
 740:	b8 15 00 00 00       	mov    $0x15,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <kill>:
SYSCALL(kill)
 748:	b8 06 00 00 00       	mov    $0x6,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <exec>:
SYSCALL(exec)
 750:	b8 07 00 00 00       	mov    $0x7,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <open>:
SYSCALL(open)
 758:	b8 0f 00 00 00       	mov    $0xf,%eax
 75d:	cd 40                	int    $0x40
 75f:	c3                   	ret    

00000760 <mknod>:
SYSCALL(mknod)
 760:	b8 11 00 00 00       	mov    $0x11,%eax
 765:	cd 40                	int    $0x40
 767:	c3                   	ret    

00000768 <unlink>:
SYSCALL(unlink)
 768:	b8 12 00 00 00       	mov    $0x12,%eax
 76d:	cd 40                	int    $0x40
 76f:	c3                   	ret    

00000770 <fstat>:
SYSCALL(fstat)
 770:	b8 08 00 00 00       	mov    $0x8,%eax
 775:	cd 40                	int    $0x40
 777:	c3                   	ret    

00000778 <link>:
SYSCALL(link)
 778:	b8 13 00 00 00       	mov    $0x13,%eax
 77d:	cd 40                	int    $0x40
 77f:	c3                   	ret    

00000780 <mkdir>:
SYSCALL(mkdir)
 780:	b8 14 00 00 00       	mov    $0x14,%eax
 785:	cd 40                	int    $0x40
 787:	c3                   	ret    

00000788 <chdir>:
SYSCALL(chdir)
 788:	b8 09 00 00 00       	mov    $0x9,%eax
 78d:	cd 40                	int    $0x40
 78f:	c3                   	ret    

00000790 <dup>:
SYSCALL(dup)
 790:	b8 0a 00 00 00       	mov    $0xa,%eax
 795:	cd 40                	int    $0x40
 797:	c3                   	ret    

00000798 <getpid>:
SYSCALL(getpid)
 798:	b8 0b 00 00 00       	mov    $0xb,%eax
 79d:	cd 40                	int    $0x40
 79f:	c3                   	ret    

000007a0 <sbrk>:
SYSCALL(sbrk)
 7a0:	b8 0c 00 00 00       	mov    $0xc,%eax
 7a5:	cd 40                	int    $0x40
 7a7:	c3                   	ret    

000007a8 <sleep>:
SYSCALL(sleep)
 7a8:	b8 0d 00 00 00       	mov    $0xd,%eax
 7ad:	cd 40                	int    $0x40
 7af:	c3                   	ret    

000007b0 <uptime>:
SYSCALL(uptime)
 7b0:	b8 0e 00 00 00       	mov    $0xe,%eax
 7b5:	cd 40                	int    $0x40
 7b7:	c3                   	ret    

000007b8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	83 ec 18             	sub    $0x18,%esp
 7be:	8b 45 0c             	mov    0xc(%ebp),%eax
 7c1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7cb:	00 
 7cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d3:	8b 45 08             	mov    0x8(%ebp),%eax
 7d6:	89 04 24             	mov    %eax,(%esp)
 7d9:	e8 5a ff ff ff       	call   738 <write>
}
 7de:	c9                   	leave  
 7df:	c3                   	ret    

000007e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	56                   	push   %esi
 7e4:	53                   	push   %ebx
 7e5:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7e8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7ef:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7f3:	74 17                	je     80c <printint+0x2c>
 7f5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7f9:	79 11                	jns    80c <printint+0x2c>
    neg = 1;
 7fb:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 802:	8b 45 0c             	mov    0xc(%ebp),%eax
 805:	f7 d8                	neg    %eax
 807:	89 45 ec             	mov    %eax,-0x14(%ebp)
 80a:	eb 06                	jmp    812 <printint+0x32>
  } else {
    x = xx;
 80c:	8b 45 0c             	mov    0xc(%ebp),%eax
 80f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 812:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 819:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 81c:	8d 41 01             	lea    0x1(%ecx),%eax
 81f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 822:	8b 5d 10             	mov    0x10(%ebp),%ebx
 825:	8b 45 ec             	mov    -0x14(%ebp),%eax
 828:	ba 00 00 00 00       	mov    $0x0,%edx
 82d:	f7 f3                	div    %ebx
 82f:	89 d0                	mov    %edx,%eax
 831:	8a 80 2c 10 00 00    	mov    0x102c(%eax),%al
 837:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 83b:	8b 75 10             	mov    0x10(%ebp),%esi
 83e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 841:	ba 00 00 00 00       	mov    $0x0,%edx
 846:	f7 f6                	div    %esi
 848:	89 45 ec             	mov    %eax,-0x14(%ebp)
 84b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 84f:	75 c8                	jne    819 <printint+0x39>
  if(neg)
 851:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 855:	74 10                	je     867 <printint+0x87>
    buf[i++] = '-';
 857:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85a:	8d 50 01             	lea    0x1(%eax),%edx
 85d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 860:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 865:	eb 1e                	jmp    885 <printint+0xa5>
 867:	eb 1c                	jmp    885 <printint+0xa5>
    putc(fd, buf[i]);
 869:	8d 55 dc             	lea    -0x24(%ebp),%edx
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	01 d0                	add    %edx,%eax
 871:	8a 00                	mov    (%eax),%al
 873:	0f be c0             	movsbl %al,%eax
 876:	89 44 24 04          	mov    %eax,0x4(%esp)
 87a:	8b 45 08             	mov    0x8(%ebp),%eax
 87d:	89 04 24             	mov    %eax,(%esp)
 880:	e8 33 ff ff ff       	call   7b8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 885:	ff 4d f4             	decl   -0xc(%ebp)
 888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 88c:	79 db                	jns    869 <printint+0x89>
    putc(fd, buf[i]);
}
 88e:	83 c4 30             	add    $0x30,%esp
 891:	5b                   	pop    %ebx
 892:	5e                   	pop    %esi
 893:	5d                   	pop    %ebp
 894:	c3                   	ret    

00000895 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 895:	55                   	push   %ebp
 896:	89 e5                	mov    %esp,%ebp
 898:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 89b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8a2:	8d 45 0c             	lea    0xc(%ebp),%eax
 8a5:	83 c0 04             	add    $0x4,%eax
 8a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8b2:	e9 77 01 00 00       	jmp    a2e <printf+0x199>
    c = fmt[i] & 0xff;
 8b7:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	01 d0                	add    %edx,%eax
 8bf:	8a 00                	mov    (%eax),%al
 8c1:	0f be c0             	movsbl %al,%eax
 8c4:	25 ff 00 00 00       	and    $0xff,%eax
 8c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8d0:	75 2c                	jne    8fe <printf+0x69>
      if(c == '%'){
 8d2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8d6:	75 0c                	jne    8e4 <printf+0x4f>
        state = '%';
 8d8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8df:	e9 47 01 00 00       	jmp    a2b <printf+0x196>
      } else {
        putc(fd, c);
 8e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8e7:	0f be c0             	movsbl %al,%eax
 8ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ee:	8b 45 08             	mov    0x8(%ebp),%eax
 8f1:	89 04 24             	mov    %eax,(%esp)
 8f4:	e8 bf fe ff ff       	call   7b8 <putc>
 8f9:	e9 2d 01 00 00       	jmp    a2b <printf+0x196>
      }
    } else if(state == '%'){
 8fe:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 902:	0f 85 23 01 00 00    	jne    a2b <printf+0x196>
      if(c == 'd'){
 908:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 90c:	75 2d                	jne    93b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 90e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 911:	8b 00                	mov    (%eax),%eax
 913:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 91a:	00 
 91b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 922:	00 
 923:	89 44 24 04          	mov    %eax,0x4(%esp)
 927:	8b 45 08             	mov    0x8(%ebp),%eax
 92a:	89 04 24             	mov    %eax,(%esp)
 92d:	e8 ae fe ff ff       	call   7e0 <printint>
        ap++;
 932:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 936:	e9 e9 00 00 00       	jmp    a24 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 93b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 93f:	74 06                	je     947 <printf+0xb2>
 941:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 945:	75 2d                	jne    974 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 947:	8b 45 e8             	mov    -0x18(%ebp),%eax
 94a:	8b 00                	mov    (%eax),%eax
 94c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 953:	00 
 954:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 95b:	00 
 95c:	89 44 24 04          	mov    %eax,0x4(%esp)
 960:	8b 45 08             	mov    0x8(%ebp),%eax
 963:	89 04 24             	mov    %eax,(%esp)
 966:	e8 75 fe ff ff       	call   7e0 <printint>
        ap++;
 96b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 96f:	e9 b0 00 00 00       	jmp    a24 <printf+0x18f>
      } else if(c == 's'){
 974:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 978:	75 42                	jne    9bc <printf+0x127>
        s = (char*)*ap;
 97a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 97d:	8b 00                	mov    (%eax),%eax
 97f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 982:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 98a:	75 09                	jne    995 <printf+0x100>
          s = "(null)";
 98c:	c7 45 f4 6f 0c 00 00 	movl   $0xc6f,-0xc(%ebp)
        while(*s != 0){
 993:	eb 1c                	jmp    9b1 <printf+0x11c>
 995:	eb 1a                	jmp    9b1 <printf+0x11c>
          putc(fd, *s);
 997:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99a:	8a 00                	mov    (%eax),%al
 99c:	0f be c0             	movsbl %al,%eax
 99f:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	89 04 24             	mov    %eax,(%esp)
 9a9:	e8 0a fe ff ff       	call   7b8 <putc>
          s++;
 9ae:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b4:	8a 00                	mov    (%eax),%al
 9b6:	84 c0                	test   %al,%al
 9b8:	75 dd                	jne    997 <printf+0x102>
 9ba:	eb 68                	jmp    a24 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9bc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9c0:	75 1d                	jne    9df <printf+0x14a>
        putc(fd, *ap);
 9c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9c5:	8b 00                	mov    (%eax),%eax
 9c7:	0f be c0             	movsbl %al,%eax
 9ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ce:	8b 45 08             	mov    0x8(%ebp),%eax
 9d1:	89 04 24             	mov    %eax,(%esp)
 9d4:	e8 df fd ff ff       	call   7b8 <putc>
        ap++;
 9d9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9dd:	eb 45                	jmp    a24 <printf+0x18f>
      } else if(c == '%'){
 9df:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9e3:	75 17                	jne    9fc <printf+0x167>
        putc(fd, c);
 9e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9e8:	0f be c0             	movsbl %al,%eax
 9eb:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ef:	8b 45 08             	mov    0x8(%ebp),%eax
 9f2:	89 04 24             	mov    %eax,(%esp)
 9f5:	e8 be fd ff ff       	call   7b8 <putc>
 9fa:	eb 28                	jmp    a24 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9fc:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a03:	00 
 a04:	8b 45 08             	mov    0x8(%ebp),%eax
 a07:	89 04 24             	mov    %eax,(%esp)
 a0a:	e8 a9 fd ff ff       	call   7b8 <putc>
        putc(fd, c);
 a0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a12:	0f be c0             	movsbl %al,%eax
 a15:	89 44 24 04          	mov    %eax,0x4(%esp)
 a19:	8b 45 08             	mov    0x8(%ebp),%eax
 a1c:	89 04 24             	mov    %eax,(%esp)
 a1f:	e8 94 fd ff ff       	call   7b8 <putc>
      }
      state = 0;
 a24:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a2b:	ff 45 f0             	incl   -0x10(%ebp)
 a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
 a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a34:	01 d0                	add    %edx,%eax
 a36:	8a 00                	mov    (%eax),%al
 a38:	84 c0                	test   %al,%al
 a3a:	0f 85 77 fe ff ff    	jne    8b7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a40:	c9                   	leave  
 a41:	c3                   	ret    
 a42:	90                   	nop
 a43:	90                   	nop

00000a44 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a44:	55                   	push   %ebp
 a45:	89 e5                	mov    %esp,%ebp
 a47:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a4a:	8b 45 08             	mov    0x8(%ebp),%eax
 a4d:	83 e8 08             	sub    $0x8,%eax
 a50:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a53:	a1 50 10 00 00       	mov    0x1050,%eax
 a58:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a5b:	eb 24                	jmp    a81 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a60:	8b 00                	mov    (%eax),%eax
 a62:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a65:	77 12                	ja     a79 <free+0x35>
 a67:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a6a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a6d:	77 24                	ja     a93 <free+0x4f>
 a6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a72:	8b 00                	mov    (%eax),%eax
 a74:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a77:	77 1a                	ja     a93 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a79:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a7c:	8b 00                	mov    (%eax),%eax
 a7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a81:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a84:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a87:	76 d4                	jbe    a5d <free+0x19>
 a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8c:	8b 00                	mov    (%eax),%eax
 a8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a91:	76 ca                	jbe    a5d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 a93:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a96:	8b 40 04             	mov    0x4(%eax),%eax
 a99:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 aa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa3:	01 c2                	add    %eax,%edx
 aa5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa8:	8b 00                	mov    (%eax),%eax
 aaa:	39 c2                	cmp    %eax,%edx
 aac:	75 24                	jne    ad2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 aae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab1:	8b 50 04             	mov    0x4(%eax),%edx
 ab4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab7:	8b 00                	mov    (%eax),%eax
 ab9:	8b 40 04             	mov    0x4(%eax),%eax
 abc:	01 c2                	add    %eax,%edx
 abe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 ac4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac7:	8b 00                	mov    (%eax),%eax
 ac9:	8b 10                	mov    (%eax),%edx
 acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ace:	89 10                	mov    %edx,(%eax)
 ad0:	eb 0a                	jmp    adc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad5:	8b 10                	mov    (%eax),%edx
 ad7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ada:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 adc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 adf:	8b 40 04             	mov    0x4(%eax),%eax
 ae2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ae9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aec:	01 d0                	add    %edx,%eax
 aee:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 af1:	75 20                	jne    b13 <free+0xcf>
    p->s.size += bp->s.size;
 af3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af6:	8b 50 04             	mov    0x4(%eax),%edx
 af9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 afc:	8b 40 04             	mov    0x4(%eax),%eax
 aff:	01 c2                	add    %eax,%edx
 b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b04:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b07:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0a:	8b 10                	mov    (%eax),%edx
 b0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b0f:	89 10                	mov    %edx,(%eax)
 b11:	eb 08                	jmp    b1b <free+0xd7>
  } else
    p->s.ptr = bp;
 b13:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b16:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b19:	89 10                	mov    %edx,(%eax)
  freep = p;
 b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1e:	a3 50 10 00 00       	mov    %eax,0x1050
}
 b23:	c9                   	leave  
 b24:	c3                   	ret    

00000b25 <morecore>:

static Header*
morecore(uint nu)
{
 b25:	55                   	push   %ebp
 b26:	89 e5                	mov    %esp,%ebp
 b28:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b2b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b32:	77 07                	ja     b3b <morecore+0x16>
    nu = 4096;
 b34:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b3b:	8b 45 08             	mov    0x8(%ebp),%eax
 b3e:	c1 e0 03             	shl    $0x3,%eax
 b41:	89 04 24             	mov    %eax,(%esp)
 b44:	e8 57 fc ff ff       	call   7a0 <sbrk>
 b49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b4c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b50:	75 07                	jne    b59 <morecore+0x34>
    return 0;
 b52:	b8 00 00 00 00       	mov    $0x0,%eax
 b57:	eb 22                	jmp    b7b <morecore+0x56>
  hp = (Header*)p;
 b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b62:	8b 55 08             	mov    0x8(%ebp),%edx
 b65:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b68:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b6b:	83 c0 08             	add    $0x8,%eax
 b6e:	89 04 24             	mov    %eax,(%esp)
 b71:	e8 ce fe ff ff       	call   a44 <free>
  return freep;
 b76:	a1 50 10 00 00       	mov    0x1050,%eax
}
 b7b:	c9                   	leave  
 b7c:	c3                   	ret    

00000b7d <malloc>:

void*
malloc(uint nbytes)
{
 b7d:	55                   	push   %ebp
 b7e:	89 e5                	mov    %esp,%ebp
 b80:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b83:	8b 45 08             	mov    0x8(%ebp),%eax
 b86:	83 c0 07             	add    $0x7,%eax
 b89:	c1 e8 03             	shr    $0x3,%eax
 b8c:	40                   	inc    %eax
 b8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b90:	a1 50 10 00 00       	mov    0x1050,%eax
 b95:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b98:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b9c:	75 23                	jne    bc1 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 b9e:	c7 45 f0 48 10 00 00 	movl   $0x1048,-0x10(%ebp)
 ba5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba8:	a3 50 10 00 00       	mov    %eax,0x1050
 bad:	a1 50 10 00 00       	mov    0x1050,%eax
 bb2:	a3 48 10 00 00       	mov    %eax,0x1048
    base.s.size = 0;
 bb7:	c7 05 4c 10 00 00 00 	movl   $0x0,0x104c
 bbe:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc4:	8b 00                	mov    (%eax),%eax
 bc6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bcc:	8b 40 04             	mov    0x4(%eax),%eax
 bcf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bd2:	72 4d                	jb     c21 <malloc+0xa4>
      if(p->s.size == nunits)
 bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd7:	8b 40 04             	mov    0x4(%eax),%eax
 bda:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bdd:	75 0c                	jne    beb <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be2:	8b 10                	mov    (%eax),%edx
 be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be7:	89 10                	mov    %edx,(%eax)
 be9:	eb 26                	jmp    c11 <malloc+0x94>
      else {
        p->s.size -= nunits;
 beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bee:	8b 40 04             	mov    0x4(%eax),%eax
 bf1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bf4:	89 c2                	mov    %eax,%edx
 bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bff:	8b 40 04             	mov    0x4(%eax),%eax
 c02:	c1 e0 03             	shl    $0x3,%eax
 c05:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c0e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c14:	a3 50 10 00 00       	mov    %eax,0x1050
      return (void*)(p + 1);
 c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c1c:	83 c0 08             	add    $0x8,%eax
 c1f:	eb 38                	jmp    c59 <malloc+0xdc>
    }
    if(p == freep)
 c21:	a1 50 10 00 00       	mov    0x1050,%eax
 c26:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c29:	75 1b                	jne    c46 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 c2b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c2e:	89 04 24             	mov    %eax,(%esp)
 c31:	e8 ef fe ff ff       	call   b25 <morecore>
 c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c3d:	75 07                	jne    c46 <malloc+0xc9>
        return 0;
 c3f:	b8 00 00 00 00       	mov    $0x0,%eax
 c44:	eb 13                	jmp    c59 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c49:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4f:	8b 00                	mov    (%eax),%eax
 c51:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c54:	e9 70 ff ff ff       	jmp    bc9 <malloc+0x4c>
}
 c59:	c9                   	leave  
 c5a:	c3                   	ret    
