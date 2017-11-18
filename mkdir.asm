
_mkdir:     file format elf32-i386


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

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 83 0c 00 	movl   $0xc83,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 9a 08 00 00       	call   8bd <printf>
    exit();
  23:	e8 18 07 00 00       	call   740 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4e                	jmp    80 <main+0x80>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 5c 07 00 00       	call   7a8 <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 9a 0c 00 	movl   $0xc9a,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 43 08 00 00       	call   8bd <printf>
      break;
  7a:	eb 0d                	jmp    89 <main+0x89>
  if(argc < 2){
    printf(2, "Usage: mkdir files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  7c:	ff 44 24 1c          	incl   0x1c(%esp)
  80:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  84:	3b 45 08             	cmp    0x8(%ebp),%eax
  87:	7c a9                	jl     32 <main+0x32>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit();
  89:	e8 b2 06 00 00       	call   740 <exit>
  8e:	90                   	nop
  8f:	90                   	nop

00000090 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	57                   	push   %edi
  94:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  98:	8b 55 10             	mov    0x10(%ebp),%edx
  9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  9e:	89 cb                	mov    %ecx,%ebx
  a0:	89 df                	mov    %ebx,%edi
  a2:	89 d1                	mov    %edx,%ecx
  a4:	fc                   	cld    
  a5:	f3 aa                	rep stos %al,%es:(%edi)
  a7:	89 ca                	mov    %ecx,%edx
  a9:	89 fb                	mov    %edi,%ebx
  ab:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ae:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b1:	5b                   	pop    %ebx
  b2:	5f                   	pop    %edi
  b3:	5d                   	pop    %ebp
  b4:	c3                   	ret    

000000b5 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  b5:	55                   	push   %ebp
  b6:	89 e5                	mov    %esp,%ebp
  b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  bb:	8b 45 08             	mov    0x8(%ebp),%eax
  be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c1:	90                   	nop
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8d 50 01             	lea    0x1(%eax),%edx
  c8:	89 55 08             	mov    %edx,0x8(%ebp)
  cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  ce:	8d 4a 01             	lea    0x1(%edx),%ecx
  d1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d4:	8a 12                	mov    (%edx),%dl
  d6:	88 10                	mov    %dl,(%eax)
  d8:	8a 00                	mov    (%eax),%al
  da:	84 c0                	test   %al,%al
  dc:	75 e4                	jne    c2 <strcpy+0xd>
    ;
  return os;
  de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e1:	c9                   	leave  
  e2:	c3                   	ret    

000000e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e3:	55                   	push   %ebp
  e4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e6:	eb 06                	jmp    ee <strcmp+0xb>
    p++, q++;
  e8:	ff 45 08             	incl   0x8(%ebp)
  eb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  ee:	8b 45 08             	mov    0x8(%ebp),%eax
  f1:	8a 00                	mov    (%eax),%al
  f3:	84 c0                	test   %al,%al
  f5:	74 0e                	je     105 <strcmp+0x22>
  f7:	8b 45 08             	mov    0x8(%ebp),%eax
  fa:	8a 10                	mov    (%eax),%dl
  fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  ff:	8a 00                	mov    (%eax),%al
 101:	38 c2                	cmp    %al,%dl
 103:	74 e3                	je     e8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 105:	8b 45 08             	mov    0x8(%ebp),%eax
 108:	8a 00                	mov    (%eax),%al
 10a:	0f b6 d0             	movzbl %al,%edx
 10d:	8b 45 0c             	mov    0xc(%ebp),%eax
 110:	8a 00                	mov    (%eax),%al
 112:	0f b6 c0             	movzbl %al,%eax
 115:	29 c2                	sub    %eax,%edx
 117:	89 d0                	mov    %edx,%eax
}
 119:	5d                   	pop    %ebp
 11a:	c3                   	ret    

0000011b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 11b:	55                   	push   %ebp
 11c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 11e:	eb 09                	jmp    129 <strncmp+0xe>
    n--, p++, q++;
 120:	ff 4d 10             	decl   0x10(%ebp)
 123:	ff 45 08             	incl   0x8(%ebp)
 126:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 129:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 12d:	74 17                	je     146 <strncmp+0x2b>
 12f:	8b 45 08             	mov    0x8(%ebp),%eax
 132:	8a 00                	mov    (%eax),%al
 134:	84 c0                	test   %al,%al
 136:	74 0e                	je     146 <strncmp+0x2b>
 138:	8b 45 08             	mov    0x8(%ebp),%eax
 13b:	8a 10                	mov    (%eax),%dl
 13d:	8b 45 0c             	mov    0xc(%ebp),%eax
 140:	8a 00                	mov    (%eax),%al
 142:	38 c2                	cmp    %al,%dl
 144:	74 da                	je     120 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 146:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 14a:	75 07                	jne    153 <strncmp+0x38>
    return 0;
 14c:	b8 00 00 00 00       	mov    $0x0,%eax
 151:	eb 14                	jmp    167 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 153:	8b 45 08             	mov    0x8(%ebp),%eax
 156:	8a 00                	mov    (%eax),%al
 158:	0f b6 d0             	movzbl %al,%edx
 15b:	8b 45 0c             	mov    0xc(%ebp),%eax
 15e:	8a 00                	mov    (%eax),%al
 160:	0f b6 c0             	movzbl %al,%eax
 163:	29 c2                	sub    %eax,%edx
 165:	89 d0                	mov    %edx,%eax
}
 167:	5d                   	pop    %ebp
 168:	c3                   	ret    

00000169 <strlen>:

uint
strlen(const char *s)
{
 169:	55                   	push   %ebp
 16a:	89 e5                	mov    %esp,%ebp
 16c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 16f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 176:	eb 03                	jmp    17b <strlen+0x12>
 178:	ff 45 fc             	incl   -0x4(%ebp)
 17b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	01 d0                	add    %edx,%eax
 183:	8a 00                	mov    (%eax),%al
 185:	84 c0                	test   %al,%al
 187:	75 ef                	jne    178 <strlen+0xf>
    ;
  return n;
 189:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18c:	c9                   	leave  
 18d:	c3                   	ret    

0000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	55                   	push   %ebp
 18f:	89 e5                	mov    %esp,%ebp
 191:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 194:	8b 45 10             	mov    0x10(%ebp),%eax
 197:	89 44 24 08          	mov    %eax,0x8(%esp)
 19b:	8b 45 0c             	mov    0xc(%ebp),%eax
 19e:	89 44 24 04          	mov    %eax,0x4(%esp)
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	89 04 24             	mov    %eax,(%esp)
 1a8:	e8 e3 fe ff ff       	call   90 <stosb>
  return dst;
 1ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1b0:	c9                   	leave  
 1b1:	c3                   	ret    

000001b2 <strchr>:

char*
strchr(const char *s, char c)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 04             	sub    $0x4,%esp
 1b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 1bb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1be:	eb 12                	jmp    1d2 <strchr+0x20>
    if(*s == c)
 1c0:	8b 45 08             	mov    0x8(%ebp),%eax
 1c3:	8a 00                	mov    (%eax),%al
 1c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1c8:	75 05                	jne    1cf <strchr+0x1d>
      return (char*)s;
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	eb 11                	jmp    1e0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1cf:	ff 45 08             	incl   0x8(%ebp)
 1d2:	8b 45 08             	mov    0x8(%ebp),%eax
 1d5:	8a 00                	mov    (%eax),%al
 1d7:	84 c0                	test   %al,%al
 1d9:	75 e5                	jne    1c0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1db:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1e0:	c9                   	leave  
 1e1:	c3                   	ret    

000001e2 <strcat>:

char *
strcat(char *dest, const char *src)
{
 1e2:	55                   	push   %ebp
 1e3:	89 e5                	mov    %esp,%ebp
 1e5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 1e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1ef:	eb 03                	jmp    1f4 <strcat+0x12>
 1f1:	ff 45 fc             	incl   -0x4(%ebp)
 1f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1f7:	8b 45 08             	mov    0x8(%ebp),%eax
 1fa:	01 d0                	add    %edx,%eax
 1fc:	8a 00                	mov    (%eax),%al
 1fe:	84 c0                	test   %al,%al
 200:	75 ef                	jne    1f1 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 202:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 209:	eb 1e                	jmp    229 <strcat+0x47>
        dest[i+j] = src[j];
 20b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 20e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 211:	01 d0                	add    %edx,%eax
 213:	89 c2                	mov    %eax,%edx
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	01 c2                	add    %eax,%edx
 21a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	01 c8                	add    %ecx,%eax
 222:	8a 00                	mov    (%eax),%al
 224:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 226:	ff 45 f8             	incl   -0x8(%ebp)
 229:	8b 55 f8             	mov    -0x8(%ebp),%edx
 22c:	8b 45 0c             	mov    0xc(%ebp),%eax
 22f:	01 d0                	add    %edx,%eax
 231:	8a 00                	mov    (%eax),%al
 233:	84 c0                	test   %al,%al
 235:	75 d4                	jne    20b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 237:	8b 45 f8             	mov    -0x8(%ebp),%eax
 23a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 23d:	01 d0                	add    %edx,%eax
 23f:	89 c2                	mov    %eax,%edx
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	01 d0                	add    %edx,%eax
 246:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 249:	8b 45 08             	mov    0x8(%ebp),%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <strstr>:

int 
strstr(char* s, char* sub)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25b:	eb 7c                	jmp    2d9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 25d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 260:	8b 45 08             	mov    0x8(%ebp),%eax
 263:	01 d0                	add    %edx,%eax
 265:	8a 10                	mov    (%eax),%dl
 267:	8b 45 0c             	mov    0xc(%ebp),%eax
 26a:	8a 00                	mov    (%eax),%al
 26c:	38 c2                	cmp    %al,%dl
 26e:	75 66                	jne    2d6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 270:	8b 45 0c             	mov    0xc(%ebp),%eax
 273:	89 04 24             	mov    %eax,(%esp)
 276:	e8 ee fe ff ff       	call   169 <strlen>
 27b:	83 f8 01             	cmp    $0x1,%eax
 27e:	75 05                	jne    285 <strstr+0x37>
            {  
                return i;
 280:	8b 45 fc             	mov    -0x4(%ebp),%eax
 283:	eb 6b                	jmp    2f0 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 285:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 28c:	eb 3a                	jmp    2c8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 28e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 291:	8b 55 fc             	mov    -0x4(%ebp),%edx
 294:	01 d0                	add    %edx,%eax
 296:	89 c2                	mov    %eax,%edx
 298:	8b 45 08             	mov    0x8(%ebp),%eax
 29b:	01 d0                	add    %edx,%eax
 29d:	8a 10                	mov    (%eax),%dl
 29f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a5:	01 c8                	add    %ecx,%eax
 2a7:	8a 00                	mov    (%eax),%al
 2a9:	38 c2                	cmp    %al,%dl
 2ab:	75 16                	jne    2c3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 2ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b0:	8d 50 01             	lea    0x1(%eax),%edx
 2b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b6:	01 d0                	add    %edx,%eax
 2b8:	8a 00                	mov    (%eax),%al
 2ba:	84 c0                	test   %al,%al
 2bc:	75 07                	jne    2c5 <strstr+0x77>
                    {
                        return i;
 2be:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c1:	eb 2d                	jmp    2f0 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 2c3:	eb 11                	jmp    2d6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 2c5:	ff 45 f8             	incl   -0x8(%ebp)
 2c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ce:	01 d0                	add    %edx,%eax
 2d0:	8a 00                	mov    (%eax),%al
 2d2:	84 c0                	test   %al,%al
 2d4:	75 b8                	jne    28e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2d6:	ff 45 fc             	incl   -0x4(%ebp)
 2d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2dc:	8b 45 08             	mov    0x8(%ebp),%eax
 2df:	01 d0                	add    %edx,%eax
 2e1:	8a 00                	mov    (%eax),%al
 2e3:	84 c0                	test   %al,%al
 2e5:	0f 85 72 ff ff ff    	jne    25d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 2eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 2f0:	c9                   	leave  
 2f1:	c3                   	ret    

000002f2 <strtok>:

char *
strtok(char *s, const char *delim)
{
 2f2:	55                   	push   %ebp
 2f3:	89 e5                	mov    %esp,%ebp
 2f5:	53                   	push   %ebx
 2f6:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 2f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2fd:	75 08                	jne    307 <strtok+0x15>
  s = lasts;
 2ff:	a1 84 10 00 00       	mov    0x1084,%eax
 304:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	8d 50 01             	lea    0x1(%eax),%edx
 30d:	89 55 08             	mov    %edx,0x8(%ebp)
 310:	8a 00                	mov    (%eax),%al
 312:	0f be d8             	movsbl %al,%ebx
 315:	85 db                	test   %ebx,%ebx
 317:	75 07                	jne    320 <strtok+0x2e>
      return 0;
 319:	b8 00 00 00 00       	mov    $0x0,%eax
 31e:	eb 58                	jmp    378 <strtok+0x86>
    } while (strchr(delim, ch));
 320:	88 d8                	mov    %bl,%al
 322:	0f be c0             	movsbl %al,%eax
 325:	89 44 24 04          	mov    %eax,0x4(%esp)
 329:	8b 45 0c             	mov    0xc(%ebp),%eax
 32c:	89 04 24             	mov    %eax,(%esp)
 32f:	e8 7e fe ff ff       	call   1b2 <strchr>
 334:	85 c0                	test   %eax,%eax
 336:	75 cf                	jne    307 <strtok+0x15>
    --s;
 338:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 33b:	8b 45 0c             	mov    0xc(%ebp),%eax
 33e:	89 44 24 04          	mov    %eax,0x4(%esp)
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	89 04 24             	mov    %eax,(%esp)
 348:	e8 31 00 00 00       	call   37e <strcspn>
 34d:	89 c2                	mov    %eax,%edx
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	01 d0                	add    %edx,%eax
 354:	a3 84 10 00 00       	mov    %eax,0x1084
    if (*lasts != 0)
 359:	a1 84 10 00 00       	mov    0x1084,%eax
 35e:	8a 00                	mov    (%eax),%al
 360:	84 c0                	test   %al,%al
 362:	74 11                	je     375 <strtok+0x83>
  *lasts++ = 0;
 364:	a1 84 10 00 00       	mov    0x1084,%eax
 369:	8d 50 01             	lea    0x1(%eax),%edx
 36c:	89 15 84 10 00 00    	mov    %edx,0x1084
 372:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 375:	8b 45 08             	mov    0x8(%ebp),%eax
}
 378:	83 c4 14             	add    $0x14,%esp
 37b:	5b                   	pop    %ebx
 37c:	5d                   	pop    %ebp
 37d:	c3                   	ret    

0000037e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 37e:	55                   	push   %ebp
 37f:	89 e5                	mov    %esp,%ebp
 381:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 384:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 38b:	eb 26                	jmp    3b3 <strcspn+0x35>
        if(strchr(s2,*s1))
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	8a 00                	mov    (%eax),%al
 392:	0f be c0             	movsbl %al,%eax
 395:	89 44 24 04          	mov    %eax,0x4(%esp)
 399:	8b 45 0c             	mov    0xc(%ebp),%eax
 39c:	89 04 24             	mov    %eax,(%esp)
 39f:	e8 0e fe ff ff       	call   1b2 <strchr>
 3a4:	85 c0                	test   %eax,%eax
 3a6:	74 05                	je     3ad <strcspn+0x2f>
            return ret;
 3a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ab:	eb 12                	jmp    3bf <strcspn+0x41>
        else
            s1++,ret++;
 3ad:	ff 45 08             	incl   0x8(%ebp)
 3b0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 3b3:	8b 45 08             	mov    0x8(%ebp),%eax
 3b6:	8a 00                	mov    (%eax),%al
 3b8:	84 c0                	test   %al,%al
 3ba:	75 d1                	jne    38d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 3bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3bf:	c9                   	leave  
 3c0:	c3                   	ret    

000003c1 <isspace>:

int
isspace(unsigned char c)
{
 3c1:	55                   	push   %ebp
 3c2:	89 e5                	mov    %esp,%ebp
 3c4:	83 ec 04             	sub    $0x4,%esp
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 3cd:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 3d1:	74 1e                	je     3f1 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 3d3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 3d7:	74 18                	je     3f1 <isspace+0x30>
 3d9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 3dd:	74 12                	je     3f1 <isspace+0x30>
 3df:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 3e3:	74 0c                	je     3f1 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 3e5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 3e9:	74 06                	je     3f1 <isspace+0x30>
 3eb:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 3ef:	75 07                	jne    3f8 <isspace+0x37>
 3f1:	b8 01 00 00 00       	mov    $0x1,%eax
 3f6:	eb 05                	jmp    3fd <isspace+0x3c>
 3f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
 3fd:	c9                   	leave  
 3fe:	c3                   	ret    

000003ff <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 3ff:	55                   	push   %ebp
 400:	89 e5                	mov    %esp,%ebp
 402:	57                   	push   %edi
 403:	56                   	push   %esi
 404:	53                   	push   %ebx
 405:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 408:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 40d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 414:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 417:	eb 01                	jmp    41a <strtoul+0x1b>
  p += 1;
 419:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 41a:	8a 03                	mov    (%ebx),%al
 41c:	0f b6 c0             	movzbl %al,%eax
 41f:	89 04 24             	mov    %eax,(%esp)
 422:	e8 9a ff ff ff       	call   3c1 <isspace>
 427:	85 c0                	test   %eax,%eax
 429:	75 ee                	jne    419 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 42b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 42f:	75 30                	jne    461 <strtoul+0x62>
    {
  if (*p == '0') {
 431:	8a 03                	mov    (%ebx),%al
 433:	3c 30                	cmp    $0x30,%al
 435:	75 21                	jne    458 <strtoul+0x59>
      p += 1;
 437:	43                   	inc    %ebx
      if (*p == 'x') {
 438:	8a 03                	mov    (%ebx),%al
 43a:	3c 78                	cmp    $0x78,%al
 43c:	75 0a                	jne    448 <strtoul+0x49>
    p += 1;
 43e:	43                   	inc    %ebx
    base = 16;
 43f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 446:	eb 31                	jmp    479 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 448:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 44f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 456:	eb 21                	jmp    479 <strtoul+0x7a>
      }
  }
  else base = 10;
 458:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 45f:	eb 18                	jmp    479 <strtoul+0x7a>
    } else if (base == 16) {
 461:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 465:	75 12                	jne    479 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 467:	8a 03                	mov    (%ebx),%al
 469:	3c 30                	cmp    $0x30,%al
 46b:	75 0c                	jne    479 <strtoul+0x7a>
 46d:	8d 43 01             	lea    0x1(%ebx),%eax
 470:	8a 00                	mov    (%eax),%al
 472:	3c 78                	cmp    $0x78,%al
 474:	75 03                	jne    479 <strtoul+0x7a>
      p += 2;
 476:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 479:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 47d:	75 29                	jne    4a8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 47f:	8a 03                	mov    (%ebx),%al
 481:	0f be c0             	movsbl %al,%eax
 484:	83 e8 30             	sub    $0x30,%eax
 487:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 489:	83 fe 07             	cmp    $0x7,%esi
 48c:	76 06                	jbe    494 <strtoul+0x95>
    break;
 48e:	90                   	nop
 48f:	e9 b6 00 00 00       	jmp    54a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 494:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 49b:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 49e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 4a5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 4a6:	eb d7                	jmp    47f <strtoul+0x80>
    } else if (base == 10) {
 4a8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 4ac:	75 2b                	jne    4d9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4ae:	8a 03                	mov    (%ebx),%al
 4b0:	0f be c0             	movsbl %al,%eax
 4b3:	83 e8 30             	sub    $0x30,%eax
 4b6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 4b8:	83 fe 09             	cmp    $0x9,%esi
 4bb:	76 06                	jbe    4c3 <strtoul+0xc4>
    break;
 4bd:	90                   	nop
 4be:	e9 87 00 00 00       	jmp    54a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 4c3:	89 f8                	mov    %edi,%eax
 4c5:	c1 e0 02             	shl    $0x2,%eax
 4c8:	01 f8                	add    %edi,%eax
 4ca:	01 c0                	add    %eax,%eax
 4cc:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 4d6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 4d7:	eb d5                	jmp    4ae <strtoul+0xaf>
    } else if (base == 16) {
 4d9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4dd:	75 35                	jne    514 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4df:	8a 03                	mov    (%ebx),%al
 4e1:	0f be c0             	movsbl %al,%eax
 4e4:	83 e8 30             	sub    $0x30,%eax
 4e7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 4e9:	83 fe 4a             	cmp    $0x4a,%esi
 4ec:	76 02                	jbe    4f0 <strtoul+0xf1>
    break;
 4ee:	eb 22                	jmp    512 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 4f0:	8a 86 20 10 00 00    	mov    0x1020(%esi),%al
 4f6:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 4f9:	83 fe 0f             	cmp    $0xf,%esi
 4fc:	76 02                	jbe    500 <strtoul+0x101>
    break;
 4fe:	eb 12                	jmp    512 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 500:	89 f8                	mov    %edi,%eax
 502:	c1 e0 04             	shl    $0x4,%eax
 505:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 508:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 50f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 510:	eb cd                	jmp    4df <strtoul+0xe0>
 512:	eb 36                	jmp    54a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 514:	8a 03                	mov    (%ebx),%al
 516:	0f be c0             	movsbl %al,%eax
 519:	83 e8 30             	sub    $0x30,%eax
 51c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 51e:	83 fe 4a             	cmp    $0x4a,%esi
 521:	76 02                	jbe    525 <strtoul+0x126>
    break;
 523:	eb 25                	jmp    54a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 525:	8a 86 20 10 00 00    	mov    0x1020(%esi),%al
 52b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 52e:	8b 45 10             	mov    0x10(%ebp),%eax
 531:	39 f0                	cmp    %esi,%eax
 533:	77 02                	ja     537 <strtoul+0x138>
    break;
 535:	eb 13                	jmp    54a <strtoul+0x14b>
      }
      result = result*base + digit;
 537:	8b 45 10             	mov    0x10(%ebp),%eax
 53a:	0f af c7             	imul   %edi,%eax
 53d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 540:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 547:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 548:	eb ca                	jmp    514 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 54a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 54e:	75 03                	jne    553 <strtoul+0x154>
  p = string;
 550:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 553:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 557:	74 05                	je     55e <strtoul+0x15f>
  *endPtr = p;
 559:	8b 45 0c             	mov    0xc(%ebp),%eax
 55c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 55e:	89 f8                	mov    %edi,%eax
}
 560:	83 c4 14             	add    $0x14,%esp
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    

00000568 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	53                   	push   %ebx
 56c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 56f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 572:	eb 01                	jmp    575 <strtol+0xd>
      p += 1;
 574:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 575:	8a 03                	mov    (%ebx),%al
 577:	0f b6 c0             	movzbl %al,%eax
 57a:	89 04 24             	mov    %eax,(%esp)
 57d:	e8 3f fe ff ff       	call   3c1 <isspace>
 582:	85 c0                	test   %eax,%eax
 584:	75 ee                	jne    574 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 586:	8a 03                	mov    (%ebx),%al
 588:	3c 2d                	cmp    $0x2d,%al
 58a:	75 1e                	jne    5aa <strtol+0x42>
  p += 1;
 58c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 58d:	8b 45 10             	mov    0x10(%ebp),%eax
 590:	89 44 24 08          	mov    %eax,0x8(%esp)
 594:	8b 45 0c             	mov    0xc(%ebp),%eax
 597:	89 44 24 04          	mov    %eax,0x4(%esp)
 59b:	89 1c 24             	mov    %ebx,(%esp)
 59e:	e8 5c fe ff ff       	call   3ff <strtoul>
 5a3:	f7 d8                	neg    %eax
 5a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 5a8:	eb 20                	jmp    5ca <strtol+0x62>
    } else {
  if (*p == '+') {
 5aa:	8a 03                	mov    (%ebx),%al
 5ac:	3c 2b                	cmp    $0x2b,%al
 5ae:	75 01                	jne    5b1 <strtol+0x49>
      p += 1;
 5b0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 5b1:	8b 45 10             	mov    0x10(%ebp),%eax
 5b4:	89 44 24 08          	mov    %eax,0x8(%esp)
 5b8:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5bf:	89 1c 24             	mov    %ebx,(%esp)
 5c2:	e8 38 fe ff ff       	call   3ff <strtoul>
 5c7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 5ca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 5ce:	75 17                	jne    5e7 <strtol+0x7f>
 5d0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5d4:	74 11                	je     5e7 <strtol+0x7f>
 5d6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d9:	8b 00                	mov    (%eax),%eax
 5db:	39 d8                	cmp    %ebx,%eax
 5dd:	75 08                	jne    5e7 <strtol+0x7f>
  *endPtr = string;
 5df:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e2:	8b 55 08             	mov    0x8(%ebp),%edx
 5e5:	89 10                	mov    %edx,(%eax)
    }
    return result;
 5e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 5ea:	83 c4 1c             	add    $0x1c,%esp
 5ed:	5b                   	pop    %ebx
 5ee:	5d                   	pop    %ebp
 5ef:	c3                   	ret    

000005f0 <gets>:

char*
gets(char *buf, int max)
{
 5f0:	55                   	push   %ebp
 5f1:	89 e5                	mov    %esp,%ebp
 5f3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 5f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 5fd:	eb 49                	jmp    648 <gets+0x58>
    cc = read(0, &c, 1);
 5ff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 606:	00 
 607:	8d 45 ef             	lea    -0x11(%ebp),%eax
 60a:	89 44 24 04          	mov    %eax,0x4(%esp)
 60e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 615:	e8 3e 01 00 00       	call   758 <read>
 61a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 61d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 621:	7f 02                	jg     625 <gets+0x35>
      break;
 623:	eb 2c                	jmp    651 <gets+0x61>
    buf[i++] = c;
 625:	8b 45 f4             	mov    -0xc(%ebp),%eax
 628:	8d 50 01             	lea    0x1(%eax),%edx
 62b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 62e:	89 c2                	mov    %eax,%edx
 630:	8b 45 08             	mov    0x8(%ebp),%eax
 633:	01 c2                	add    %eax,%edx
 635:	8a 45 ef             	mov    -0x11(%ebp),%al
 638:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 63a:	8a 45 ef             	mov    -0x11(%ebp),%al
 63d:	3c 0a                	cmp    $0xa,%al
 63f:	74 10                	je     651 <gets+0x61>
 641:	8a 45 ef             	mov    -0x11(%ebp),%al
 644:	3c 0d                	cmp    $0xd,%al
 646:	74 09                	je     651 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 648:	8b 45 f4             	mov    -0xc(%ebp),%eax
 64b:	40                   	inc    %eax
 64c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 64f:	7c ae                	jl     5ff <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 651:	8b 55 f4             	mov    -0xc(%ebp),%edx
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	01 d0                	add    %edx,%eax
 659:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 65c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 65f:	c9                   	leave  
 660:	c3                   	ret    

00000661 <stat>:

int
stat(char *n, struct stat *st)
{
 661:	55                   	push   %ebp
 662:	89 e5                	mov    %esp,%ebp
 664:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 667:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 66e:	00 
 66f:	8b 45 08             	mov    0x8(%ebp),%eax
 672:	89 04 24             	mov    %eax,(%esp)
 675:	e8 06 01 00 00       	call   780 <open>
 67a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 67d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 681:	79 07                	jns    68a <stat+0x29>
    return -1;
 683:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 688:	eb 23                	jmp    6ad <stat+0x4c>
  r = fstat(fd, st);
 68a:	8b 45 0c             	mov    0xc(%ebp),%eax
 68d:	89 44 24 04          	mov    %eax,0x4(%esp)
 691:	8b 45 f4             	mov    -0xc(%ebp),%eax
 694:	89 04 24             	mov    %eax,(%esp)
 697:	e8 fc 00 00 00       	call   798 <fstat>
 69c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 69f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a2:	89 04 24             	mov    %eax,(%esp)
 6a5:	e8 be 00 00 00       	call   768 <close>
  return r;
 6aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6ad:	c9                   	leave  
 6ae:	c3                   	ret    

000006af <atoi>:

int
atoi(const char *s)
{
 6af:	55                   	push   %ebp
 6b0:	89 e5                	mov    %esp,%ebp
 6b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6bc:	eb 24                	jmp    6e2 <atoi+0x33>
    n = n*10 + *s++ - '0';
 6be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6c1:	89 d0                	mov    %edx,%eax
 6c3:	c1 e0 02             	shl    $0x2,%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	01 c0                	add    %eax,%eax
 6ca:	89 c1                	mov    %eax,%ecx
 6cc:	8b 45 08             	mov    0x8(%ebp),%eax
 6cf:	8d 50 01             	lea    0x1(%eax),%edx
 6d2:	89 55 08             	mov    %edx,0x8(%ebp)
 6d5:	8a 00                	mov    (%eax),%al
 6d7:	0f be c0             	movsbl %al,%eax
 6da:	01 c8                	add    %ecx,%eax
 6dc:	83 e8 30             	sub    $0x30,%eax
 6df:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	8a 00                	mov    (%eax),%al
 6e7:	3c 2f                	cmp    $0x2f,%al
 6e9:	7e 09                	jle    6f4 <atoi+0x45>
 6eb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ee:	8a 00                	mov    (%eax),%al
 6f0:	3c 39                	cmp    $0x39,%al
 6f2:	7e ca                	jle    6be <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 6f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 6f7:	c9                   	leave  
 6f8:	c3                   	ret    

000006f9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 6f9:	55                   	push   %ebp
 6fa:	89 e5                	mov    %esp,%ebp
 6fc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 6ff:	8b 45 08             	mov    0x8(%ebp),%eax
 702:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 705:	8b 45 0c             	mov    0xc(%ebp),%eax
 708:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 70b:	eb 16                	jmp    723 <memmove+0x2a>
    *dst++ = *src++;
 70d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 710:	8d 50 01             	lea    0x1(%eax),%edx
 713:	89 55 fc             	mov    %edx,-0x4(%ebp)
 716:	8b 55 f8             	mov    -0x8(%ebp),%edx
 719:	8d 4a 01             	lea    0x1(%edx),%ecx
 71c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 71f:	8a 12                	mov    (%edx),%dl
 721:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 723:	8b 45 10             	mov    0x10(%ebp),%eax
 726:	8d 50 ff             	lea    -0x1(%eax),%edx
 729:	89 55 10             	mov    %edx,0x10(%ebp)
 72c:	85 c0                	test   %eax,%eax
 72e:	7f dd                	jg     70d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 730:	8b 45 08             	mov    0x8(%ebp),%eax
}
 733:	c9                   	leave  
 734:	c3                   	ret    
 735:	90                   	nop
 736:	90                   	nop
 737:	90                   	nop

00000738 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 738:	b8 01 00 00 00       	mov    $0x1,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <exit>:
SYSCALL(exit)
 740:	b8 02 00 00 00       	mov    $0x2,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <wait>:
SYSCALL(wait)
 748:	b8 03 00 00 00       	mov    $0x3,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <pipe>:
SYSCALL(pipe)
 750:	b8 04 00 00 00       	mov    $0x4,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <read>:
SYSCALL(read)
 758:	b8 05 00 00 00       	mov    $0x5,%eax
 75d:	cd 40                	int    $0x40
 75f:	c3                   	ret    

00000760 <write>:
SYSCALL(write)
 760:	b8 10 00 00 00       	mov    $0x10,%eax
 765:	cd 40                	int    $0x40
 767:	c3                   	ret    

00000768 <close>:
SYSCALL(close)
 768:	b8 15 00 00 00       	mov    $0x15,%eax
 76d:	cd 40                	int    $0x40
 76f:	c3                   	ret    

00000770 <kill>:
SYSCALL(kill)
 770:	b8 06 00 00 00       	mov    $0x6,%eax
 775:	cd 40                	int    $0x40
 777:	c3                   	ret    

00000778 <exec>:
SYSCALL(exec)
 778:	b8 07 00 00 00       	mov    $0x7,%eax
 77d:	cd 40                	int    $0x40
 77f:	c3                   	ret    

00000780 <open>:
SYSCALL(open)
 780:	b8 0f 00 00 00       	mov    $0xf,%eax
 785:	cd 40                	int    $0x40
 787:	c3                   	ret    

00000788 <mknod>:
SYSCALL(mknod)
 788:	b8 11 00 00 00       	mov    $0x11,%eax
 78d:	cd 40                	int    $0x40
 78f:	c3                   	ret    

00000790 <unlink>:
SYSCALL(unlink)
 790:	b8 12 00 00 00       	mov    $0x12,%eax
 795:	cd 40                	int    $0x40
 797:	c3                   	ret    

00000798 <fstat>:
SYSCALL(fstat)
 798:	b8 08 00 00 00       	mov    $0x8,%eax
 79d:	cd 40                	int    $0x40
 79f:	c3                   	ret    

000007a0 <link>:
SYSCALL(link)
 7a0:	b8 13 00 00 00       	mov    $0x13,%eax
 7a5:	cd 40                	int    $0x40
 7a7:	c3                   	ret    

000007a8 <mkdir>:
SYSCALL(mkdir)
 7a8:	b8 14 00 00 00       	mov    $0x14,%eax
 7ad:	cd 40                	int    $0x40
 7af:	c3                   	ret    

000007b0 <chdir>:
SYSCALL(chdir)
 7b0:	b8 09 00 00 00       	mov    $0x9,%eax
 7b5:	cd 40                	int    $0x40
 7b7:	c3                   	ret    

000007b8 <dup>:
SYSCALL(dup)
 7b8:	b8 0a 00 00 00       	mov    $0xa,%eax
 7bd:	cd 40                	int    $0x40
 7bf:	c3                   	ret    

000007c0 <getpid>:
SYSCALL(getpid)
 7c0:	b8 0b 00 00 00       	mov    $0xb,%eax
 7c5:	cd 40                	int    $0x40
 7c7:	c3                   	ret    

000007c8 <sbrk>:
SYSCALL(sbrk)
 7c8:	b8 0c 00 00 00       	mov    $0xc,%eax
 7cd:	cd 40                	int    $0x40
 7cf:	c3                   	ret    

000007d0 <sleep>:
SYSCALL(sleep)
 7d0:	b8 0d 00 00 00       	mov    $0xd,%eax
 7d5:	cd 40                	int    $0x40
 7d7:	c3                   	ret    

000007d8 <uptime>:
SYSCALL(uptime)
 7d8:	b8 0e 00 00 00       	mov    $0xe,%eax
 7dd:	cd 40                	int    $0x40
 7df:	c3                   	ret    

000007e0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7e0:	55                   	push   %ebp
 7e1:	89 e5                	mov    %esp,%ebp
 7e3:	83 ec 18             	sub    $0x18,%esp
 7e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7ec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7f3:	00 
 7f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fb:	8b 45 08             	mov    0x8(%ebp),%eax
 7fe:	89 04 24             	mov    %eax,(%esp)
 801:	e8 5a ff ff ff       	call   760 <write>
}
 806:	c9                   	leave  
 807:	c3                   	ret    

00000808 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 808:	55                   	push   %ebp
 809:	89 e5                	mov    %esp,%ebp
 80b:	56                   	push   %esi
 80c:	53                   	push   %ebx
 80d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 810:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 817:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 81b:	74 17                	je     834 <printint+0x2c>
 81d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 821:	79 11                	jns    834 <printint+0x2c>
    neg = 1;
 823:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 82a:	8b 45 0c             	mov    0xc(%ebp),%eax
 82d:	f7 d8                	neg    %eax
 82f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 832:	eb 06                	jmp    83a <printint+0x32>
  } else {
    x = xx;
 834:	8b 45 0c             	mov    0xc(%ebp),%eax
 837:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 83a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 841:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 844:	8d 41 01             	lea    0x1(%ecx),%eax
 847:	89 45 f4             	mov    %eax,-0xc(%ebp)
 84a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 84d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 850:	ba 00 00 00 00       	mov    $0x0,%edx
 855:	f7 f3                	div    %ebx
 857:	89 d0                	mov    %edx,%eax
 859:	8a 80 6c 10 00 00    	mov    0x106c(%eax),%al
 85f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 863:	8b 75 10             	mov    0x10(%ebp),%esi
 866:	8b 45 ec             	mov    -0x14(%ebp),%eax
 869:	ba 00 00 00 00       	mov    $0x0,%edx
 86e:	f7 f6                	div    %esi
 870:	89 45 ec             	mov    %eax,-0x14(%ebp)
 873:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 877:	75 c8                	jne    841 <printint+0x39>
  if(neg)
 879:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 87d:	74 10                	je     88f <printint+0x87>
    buf[i++] = '-';
 87f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 882:	8d 50 01             	lea    0x1(%eax),%edx
 885:	89 55 f4             	mov    %edx,-0xc(%ebp)
 888:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 88d:	eb 1e                	jmp    8ad <printint+0xa5>
 88f:	eb 1c                	jmp    8ad <printint+0xa5>
    putc(fd, buf[i]);
 891:	8d 55 dc             	lea    -0x24(%ebp),%edx
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	01 d0                	add    %edx,%eax
 899:	8a 00                	mov    (%eax),%al
 89b:	0f be c0             	movsbl %al,%eax
 89e:	89 44 24 04          	mov    %eax,0x4(%esp)
 8a2:	8b 45 08             	mov    0x8(%ebp),%eax
 8a5:	89 04 24             	mov    %eax,(%esp)
 8a8:	e8 33 ff ff ff       	call   7e0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8ad:	ff 4d f4             	decl   -0xc(%ebp)
 8b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8b4:	79 db                	jns    891 <printint+0x89>
    putc(fd, buf[i]);
}
 8b6:	83 c4 30             	add    $0x30,%esp
 8b9:	5b                   	pop    %ebx
 8ba:	5e                   	pop    %esi
 8bb:	5d                   	pop    %ebp
 8bc:	c3                   	ret    

000008bd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8bd:	55                   	push   %ebp
 8be:	89 e5                	mov    %esp,%ebp
 8c0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8ca:	8d 45 0c             	lea    0xc(%ebp),%eax
 8cd:	83 c0 04             	add    $0x4,%eax
 8d0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8da:	e9 77 01 00 00       	jmp    a56 <printf+0x199>
    c = fmt[i] & 0xff;
 8df:	8b 55 0c             	mov    0xc(%ebp),%edx
 8e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8e5:	01 d0                	add    %edx,%eax
 8e7:	8a 00                	mov    (%eax),%al
 8e9:	0f be c0             	movsbl %al,%eax
 8ec:	25 ff 00 00 00       	and    $0xff,%eax
 8f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8f4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8f8:	75 2c                	jne    926 <printf+0x69>
      if(c == '%'){
 8fa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8fe:	75 0c                	jne    90c <printf+0x4f>
        state = '%';
 900:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 907:	e9 47 01 00 00       	jmp    a53 <printf+0x196>
      } else {
        putc(fd, c);
 90c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 90f:	0f be c0             	movsbl %al,%eax
 912:	89 44 24 04          	mov    %eax,0x4(%esp)
 916:	8b 45 08             	mov    0x8(%ebp),%eax
 919:	89 04 24             	mov    %eax,(%esp)
 91c:	e8 bf fe ff ff       	call   7e0 <putc>
 921:	e9 2d 01 00 00       	jmp    a53 <printf+0x196>
      }
    } else if(state == '%'){
 926:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 92a:	0f 85 23 01 00 00    	jne    a53 <printf+0x196>
      if(c == 'd'){
 930:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 934:	75 2d                	jne    963 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 936:	8b 45 e8             	mov    -0x18(%ebp),%eax
 939:	8b 00                	mov    (%eax),%eax
 93b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 942:	00 
 943:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 94a:	00 
 94b:	89 44 24 04          	mov    %eax,0x4(%esp)
 94f:	8b 45 08             	mov    0x8(%ebp),%eax
 952:	89 04 24             	mov    %eax,(%esp)
 955:	e8 ae fe ff ff       	call   808 <printint>
        ap++;
 95a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 95e:	e9 e9 00 00 00       	jmp    a4c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 963:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 967:	74 06                	je     96f <printf+0xb2>
 969:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 96d:	75 2d                	jne    99c <printf+0xdf>
        printint(fd, *ap, 16, 0);
 96f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 972:	8b 00                	mov    (%eax),%eax
 974:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 97b:	00 
 97c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 983:	00 
 984:	89 44 24 04          	mov    %eax,0x4(%esp)
 988:	8b 45 08             	mov    0x8(%ebp),%eax
 98b:	89 04 24             	mov    %eax,(%esp)
 98e:	e8 75 fe ff ff       	call   808 <printint>
        ap++;
 993:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 997:	e9 b0 00 00 00       	jmp    a4c <printf+0x18f>
      } else if(c == 's'){
 99c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9a0:	75 42                	jne    9e4 <printf+0x127>
        s = (char*)*ap;
 9a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a5:	8b 00                	mov    (%eax),%eax
 9a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9b2:	75 09                	jne    9bd <printf+0x100>
          s = "(null)";
 9b4:	c7 45 f4 b6 0c 00 00 	movl   $0xcb6,-0xc(%ebp)
        while(*s != 0){
 9bb:	eb 1c                	jmp    9d9 <printf+0x11c>
 9bd:	eb 1a                	jmp    9d9 <printf+0x11c>
          putc(fd, *s);
 9bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c2:	8a 00                	mov    (%eax),%al
 9c4:	0f be c0             	movsbl %al,%eax
 9c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9cb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ce:	89 04 24             	mov    %eax,(%esp)
 9d1:	e8 0a fe ff ff       	call   7e0 <putc>
          s++;
 9d6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	8a 00                	mov    (%eax),%al
 9de:	84 c0                	test   %al,%al
 9e0:	75 dd                	jne    9bf <printf+0x102>
 9e2:	eb 68                	jmp    a4c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9e4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9e8:	75 1d                	jne    a07 <printf+0x14a>
        putc(fd, *ap);
 9ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9ed:	8b 00                	mov    (%eax),%eax
 9ef:	0f be c0             	movsbl %al,%eax
 9f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 9f6:	8b 45 08             	mov    0x8(%ebp),%eax
 9f9:	89 04 24             	mov    %eax,(%esp)
 9fc:	e8 df fd ff ff       	call   7e0 <putc>
        ap++;
 a01:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a05:	eb 45                	jmp    a4c <printf+0x18f>
      } else if(c == '%'){
 a07:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a0b:	75 17                	jne    a24 <printf+0x167>
        putc(fd, c);
 a0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a10:	0f be c0             	movsbl %al,%eax
 a13:	89 44 24 04          	mov    %eax,0x4(%esp)
 a17:	8b 45 08             	mov    0x8(%ebp),%eax
 a1a:	89 04 24             	mov    %eax,(%esp)
 a1d:	e8 be fd ff ff       	call   7e0 <putc>
 a22:	eb 28                	jmp    a4c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a24:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a2b:	00 
 a2c:	8b 45 08             	mov    0x8(%ebp),%eax
 a2f:	89 04 24             	mov    %eax,(%esp)
 a32:	e8 a9 fd ff ff       	call   7e0 <putc>
        putc(fd, c);
 a37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a3a:	0f be c0             	movsbl %al,%eax
 a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
 a41:	8b 45 08             	mov    0x8(%ebp),%eax
 a44:	89 04 24             	mov    %eax,(%esp)
 a47:	e8 94 fd ff ff       	call   7e0 <putc>
      }
      state = 0;
 a4c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a53:	ff 45 f0             	incl   -0x10(%ebp)
 a56:	8b 55 0c             	mov    0xc(%ebp),%edx
 a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a5c:	01 d0                	add    %edx,%eax
 a5e:	8a 00                	mov    (%eax),%al
 a60:	84 c0                	test   %al,%al
 a62:	0f 85 77 fe ff ff    	jne    8df <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a68:	c9                   	leave  
 a69:	c3                   	ret    
 a6a:	90                   	nop
 a6b:	90                   	nop

00000a6c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a6c:	55                   	push   %ebp
 a6d:	89 e5                	mov    %esp,%ebp
 a6f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a72:	8b 45 08             	mov    0x8(%ebp),%eax
 a75:	83 e8 08             	sub    $0x8,%eax
 a78:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a7b:	a1 90 10 00 00       	mov    0x1090,%eax
 a80:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a83:	eb 24                	jmp    aa9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a88:	8b 00                	mov    (%eax),%eax
 a8a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a8d:	77 12                	ja     aa1 <free+0x35>
 a8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a92:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a95:	77 24                	ja     abb <free+0x4f>
 a97:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9a:	8b 00                	mov    (%eax),%eax
 a9c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a9f:	77 1a                	ja     abb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aa1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa4:	8b 00                	mov    (%eax),%eax
 aa6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 aa9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aaf:	76 d4                	jbe    a85 <free+0x19>
 ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab4:	8b 00                	mov    (%eax),%eax
 ab6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ab9:	76 ca                	jbe    a85 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 abb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abe:	8b 40 04             	mov    0x4(%eax),%eax
 ac1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ac8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 acb:	01 c2                	add    %eax,%edx
 acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad0:	8b 00                	mov    (%eax),%eax
 ad2:	39 c2                	cmp    %eax,%edx
 ad4:	75 24                	jne    afa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 ad6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad9:	8b 50 04             	mov    0x4(%eax),%edx
 adc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 adf:	8b 00                	mov    (%eax),%eax
 ae1:	8b 40 04             	mov    0x4(%eax),%eax
 ae4:	01 c2                	add    %eax,%edx
 ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aef:	8b 00                	mov    (%eax),%eax
 af1:	8b 10                	mov    (%eax),%edx
 af3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af6:	89 10                	mov    %edx,(%eax)
 af8:	eb 0a                	jmp    b04 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afd:	8b 10                	mov    (%eax),%edx
 aff:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b02:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b07:	8b 40 04             	mov    0x4(%eax),%eax
 b0a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b11:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b14:	01 d0                	add    %edx,%eax
 b16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b19:	75 20                	jne    b3b <free+0xcf>
    p->s.size += bp->s.size;
 b1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1e:	8b 50 04             	mov    0x4(%eax),%edx
 b21:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b24:	8b 40 04             	mov    0x4(%eax),%eax
 b27:	01 c2                	add    %eax,%edx
 b29:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b32:	8b 10                	mov    (%eax),%edx
 b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b37:	89 10                	mov    %edx,(%eax)
 b39:	eb 08                	jmp    b43 <free+0xd7>
  } else
    p->s.ptr = bp;
 b3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b41:	89 10                	mov    %edx,(%eax)
  freep = p;
 b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b46:	a3 90 10 00 00       	mov    %eax,0x1090
}
 b4b:	c9                   	leave  
 b4c:	c3                   	ret    

00000b4d <morecore>:

static Header*
morecore(uint nu)
{
 b4d:	55                   	push   %ebp
 b4e:	89 e5                	mov    %esp,%ebp
 b50:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b53:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b5a:	77 07                	ja     b63 <morecore+0x16>
    nu = 4096;
 b5c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b63:	8b 45 08             	mov    0x8(%ebp),%eax
 b66:	c1 e0 03             	shl    $0x3,%eax
 b69:	89 04 24             	mov    %eax,(%esp)
 b6c:	e8 57 fc ff ff       	call   7c8 <sbrk>
 b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b74:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b78:	75 07                	jne    b81 <morecore+0x34>
    return 0;
 b7a:	b8 00 00 00 00       	mov    $0x0,%eax
 b7f:	eb 22                	jmp    ba3 <morecore+0x56>
  hp = (Header*)p;
 b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b8a:	8b 55 08             	mov    0x8(%ebp),%edx
 b8d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b90:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b93:	83 c0 08             	add    $0x8,%eax
 b96:	89 04 24             	mov    %eax,(%esp)
 b99:	e8 ce fe ff ff       	call   a6c <free>
  return freep;
 b9e:	a1 90 10 00 00       	mov    0x1090,%eax
}
 ba3:	c9                   	leave  
 ba4:	c3                   	ret    

00000ba5 <malloc>:

void*
malloc(uint nbytes)
{
 ba5:	55                   	push   %ebp
 ba6:	89 e5                	mov    %esp,%ebp
 ba8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bab:	8b 45 08             	mov    0x8(%ebp),%eax
 bae:	83 c0 07             	add    $0x7,%eax
 bb1:	c1 e8 03             	shr    $0x3,%eax
 bb4:	40                   	inc    %eax
 bb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bb8:	a1 90 10 00 00       	mov    0x1090,%eax
 bbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bc4:	75 23                	jne    be9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 bc6:	c7 45 f0 88 10 00 00 	movl   $0x1088,-0x10(%ebp)
 bcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bd0:	a3 90 10 00 00       	mov    %eax,0x1090
 bd5:	a1 90 10 00 00       	mov    0x1090,%eax
 bda:	a3 88 10 00 00       	mov    %eax,0x1088
    base.s.size = 0;
 bdf:	c7 05 8c 10 00 00 00 	movl   $0x0,0x108c
 be6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 be9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bec:	8b 00                	mov    (%eax),%eax
 bee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf4:	8b 40 04             	mov    0x4(%eax),%eax
 bf7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bfa:	72 4d                	jb     c49 <malloc+0xa4>
      if(p->s.size == nunits)
 bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bff:	8b 40 04             	mov    0x4(%eax),%eax
 c02:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c05:	75 0c                	jne    c13 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 c07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0a:	8b 10                	mov    (%eax),%edx
 c0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c0f:	89 10                	mov    %edx,(%eax)
 c11:	eb 26                	jmp    c39 <malloc+0x94>
      else {
        p->s.size -= nunits;
 c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c16:	8b 40 04             	mov    0x4(%eax),%eax
 c19:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c1c:	89 c2                	mov    %eax,%edx
 c1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c21:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c27:	8b 40 04             	mov    0x4(%eax),%eax
 c2a:	c1 e0 03             	shl    $0x3,%eax
 c2d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c33:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c36:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c3c:	a3 90 10 00 00       	mov    %eax,0x1090
      return (void*)(p + 1);
 c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c44:	83 c0 08             	add    $0x8,%eax
 c47:	eb 38                	jmp    c81 <malloc+0xdc>
    }
    if(p == freep)
 c49:	a1 90 10 00 00       	mov    0x1090,%eax
 c4e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c51:	75 1b                	jne    c6e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c56:	89 04 24             	mov    %eax,(%esp)
 c59:	e8 ef fe ff ff       	call   b4d <morecore>
 c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c65:	75 07                	jne    c6e <malloc+0xc9>
        return 0;
 c67:	b8 00 00 00 00       	mov    $0x0,%eax
 c6c:	eb 13                	jmp    c81 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c77:	8b 00                	mov    (%eax),%eax
 c79:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c7c:	e9 70 ff ff ff       	jmp    bf1 <malloc+0x4c>
}
 c81:	c9                   	leave  
 c82:	c3                   	ret    
