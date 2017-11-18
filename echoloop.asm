
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
   f:	c7 44 24 04 9c 0c 00 	movl   $0xc9c,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 b2 08 00 00       	call   8d5 <printf>
  	exit();
  23:	e8 30 07 00 00       	call   758 <exit>
  }

  ticks = atoi(argv[1]);
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 04             	add    $0x4,%eax
  2e:	8b 00                	mov    (%eax),%eax
  30:	89 04 24             	mov    %eax,(%esp)
  33:	e8 8f 06 00 00       	call   6c7 <atoi>
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
  50:	b8 c3 0c 00 00       	mov    $0xcc3,%eax
  55:	eb 05                	jmp    5c <main+0x5c>
  57:	b8 c5 0c 00 00       	mov    $0xcc5,%eax
  5c:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  60:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  67:	8b 55 0c             	mov    0xc(%ebp),%edx
  6a:	01 ca                	add    %ecx,%edx
  6c:	8b 12                	mov    (%edx),%edx
  6e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  72:	89 54 24 08          	mov    %edx,0x8(%esp)
  76:	c7 44 24 04 c7 0c 00 	movl   $0xcc7,0x4(%esp)
  7d:	00 
  7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  85:	e8 4b 08 00 00       	call   8d5 <printf>
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
  9e:	e8 45 07 00 00       	call   7e8 <sleep>
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

000000fb <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fb:	55                   	push   %ebp
  fc:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  fe:	eb 06                	jmp    106 <strcmp+0xb>
    p++, q++;
 100:	ff 45 08             	incl   0x8(%ebp)
 103:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 106:	8b 45 08             	mov    0x8(%ebp),%eax
 109:	8a 00                	mov    (%eax),%al
 10b:	84 c0                	test   %al,%al
 10d:	74 0e                	je     11d <strcmp+0x22>
 10f:	8b 45 08             	mov    0x8(%ebp),%eax
 112:	8a 10                	mov    (%eax),%dl
 114:	8b 45 0c             	mov    0xc(%ebp),%eax
 117:	8a 00                	mov    (%eax),%al
 119:	38 c2                	cmp    %al,%dl
 11b:	74 e3                	je     100 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 11d:	8b 45 08             	mov    0x8(%ebp),%eax
 120:	8a 00                	mov    (%eax),%al
 122:	0f b6 d0             	movzbl %al,%edx
 125:	8b 45 0c             	mov    0xc(%ebp),%eax
 128:	8a 00                	mov    (%eax),%al
 12a:	0f b6 c0             	movzbl %al,%eax
 12d:	29 c2                	sub    %eax,%edx
 12f:	89 d0                	mov    %edx,%eax
}
 131:	5d                   	pop    %ebp
 132:	c3                   	ret    

00000133 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 133:	55                   	push   %ebp
 134:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 136:	eb 09                	jmp    141 <strncmp+0xe>
    n--, p++, q++;
 138:	ff 4d 10             	decl   0x10(%ebp)
 13b:	ff 45 08             	incl   0x8(%ebp)
 13e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 141:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 145:	74 17                	je     15e <strncmp+0x2b>
 147:	8b 45 08             	mov    0x8(%ebp),%eax
 14a:	8a 00                	mov    (%eax),%al
 14c:	84 c0                	test   %al,%al
 14e:	74 0e                	je     15e <strncmp+0x2b>
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	8a 10                	mov    (%eax),%dl
 155:	8b 45 0c             	mov    0xc(%ebp),%eax
 158:	8a 00                	mov    (%eax),%al
 15a:	38 c2                	cmp    %al,%dl
 15c:	74 da                	je     138 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 15e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 162:	75 07                	jne    16b <strncmp+0x38>
    return 0;
 164:	b8 00 00 00 00       	mov    $0x0,%eax
 169:	eb 14                	jmp    17f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 16b:	8b 45 08             	mov    0x8(%ebp),%eax
 16e:	8a 00                	mov    (%eax),%al
 170:	0f b6 d0             	movzbl %al,%edx
 173:	8b 45 0c             	mov    0xc(%ebp),%eax
 176:	8a 00                	mov    (%eax),%al
 178:	0f b6 c0             	movzbl %al,%eax
 17b:	29 c2                	sub    %eax,%edx
 17d:	89 d0                	mov    %edx,%eax
}
 17f:	5d                   	pop    %ebp
 180:	c3                   	ret    

00000181 <strlen>:

uint
strlen(const char *s)
{
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 187:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 18e:	eb 03                	jmp    193 <strlen+0x12>
 190:	ff 45 fc             	incl   -0x4(%ebp)
 193:	8b 55 fc             	mov    -0x4(%ebp),%edx
 196:	8b 45 08             	mov    0x8(%ebp),%eax
 199:	01 d0                	add    %edx,%eax
 19b:	8a 00                	mov    (%eax),%al
 19d:	84 c0                	test   %al,%al
 19f:	75 ef                	jne    190 <strlen+0xf>
    ;
  return n;
 1a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1a4:	c9                   	leave  
 1a5:	c3                   	ret    

000001a6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a6:	55                   	push   %ebp
 1a7:	89 e5                	mov    %esp,%ebp
 1a9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1ac:	8b 45 10             	mov    0x10(%ebp),%eax
 1af:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	89 04 24             	mov    %eax,(%esp)
 1c0:	e8 e3 fe ff ff       	call   a8 <stosb>
  return dst;
 1c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <strchr>:

char*
strchr(const char *s, char c)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 04             	sub    $0x4,%esp
 1d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d3:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1d6:	eb 12                	jmp    1ea <strchr+0x20>
    if(*s == c)
 1d8:	8b 45 08             	mov    0x8(%ebp),%eax
 1db:	8a 00                	mov    (%eax),%al
 1dd:	3a 45 fc             	cmp    -0x4(%ebp),%al
 1e0:	75 05                	jne    1e7 <strchr+0x1d>
      return (char*)s;
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	eb 11                	jmp    1f8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1e7:	ff 45 08             	incl   0x8(%ebp)
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	8a 00                	mov    (%eax),%al
 1ef:	84 c0                	test   %al,%al
 1f1:	75 e5                	jne    1d8 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 1f3:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <strcat>:

char *
strcat(char *dest, const char *src)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 200:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 207:	eb 03                	jmp    20c <strcat+0x12>
 209:	ff 45 fc             	incl   -0x4(%ebp)
 20c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	01 d0                	add    %edx,%eax
 214:	8a 00                	mov    (%eax),%al
 216:	84 c0                	test   %al,%al
 218:	75 ef                	jne    209 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 21a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 221:	eb 1e                	jmp    241 <strcat+0x47>
        dest[i+j] = src[j];
 223:	8b 45 f8             	mov    -0x8(%ebp),%eax
 226:	8b 55 fc             	mov    -0x4(%ebp),%edx
 229:	01 d0                	add    %edx,%eax
 22b:	89 c2                	mov    %eax,%edx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	01 c2                	add    %eax,%edx
 232:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 235:	8b 45 0c             	mov    0xc(%ebp),%eax
 238:	01 c8                	add    %ecx,%eax
 23a:	8a 00                	mov    (%eax),%al
 23c:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 23e:	ff 45 f8             	incl   -0x8(%ebp)
 241:	8b 55 f8             	mov    -0x8(%ebp),%edx
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	01 d0                	add    %edx,%eax
 249:	8a 00                	mov    (%eax),%al
 24b:	84 c0                	test   %al,%al
 24d:	75 d4                	jne    223 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 24f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 252:	8b 55 fc             	mov    -0x4(%ebp),%edx
 255:	01 d0                	add    %edx,%eax
 257:	89 c2                	mov    %eax,%edx
 259:	8b 45 08             	mov    0x8(%ebp),%eax
 25c:	01 d0                	add    %edx,%eax
 25e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 261:	8b 45 08             	mov    0x8(%ebp),%eax
}
 264:	c9                   	leave  
 265:	c3                   	ret    

00000266 <strstr>:

int 
strstr(char* s, char* sub)
{
 266:	55                   	push   %ebp
 267:	89 e5                	mov    %esp,%ebp
 269:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 26c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 273:	eb 7c                	jmp    2f1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 275:	8b 55 fc             	mov    -0x4(%ebp),%edx
 278:	8b 45 08             	mov    0x8(%ebp),%eax
 27b:	01 d0                	add    %edx,%eax
 27d:	8a 10                	mov    (%eax),%dl
 27f:	8b 45 0c             	mov    0xc(%ebp),%eax
 282:	8a 00                	mov    (%eax),%al
 284:	38 c2                	cmp    %al,%dl
 286:	75 66                	jne    2ee <strstr+0x88>
        {
            if(strlen(sub) == 1)
 288:	8b 45 0c             	mov    0xc(%ebp),%eax
 28b:	89 04 24             	mov    %eax,(%esp)
 28e:	e8 ee fe ff ff       	call   181 <strlen>
 293:	83 f8 01             	cmp    $0x1,%eax
 296:	75 05                	jne    29d <strstr+0x37>
            {  
                return i;
 298:	8b 45 fc             	mov    -0x4(%ebp),%eax
 29b:	eb 6b                	jmp    308 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 29d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 2a4:	eb 3a                	jmp    2e0 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 2a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2ac:	01 d0                	add    %edx,%eax
 2ae:	89 c2                	mov    %eax,%edx
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	01 d0                	add    %edx,%eax
 2b5:	8a 10                	mov    (%eax),%dl
 2b7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 2ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 2bd:	01 c8                	add    %ecx,%eax
 2bf:	8a 00                	mov    (%eax),%al
 2c1:	38 c2                	cmp    %al,%dl
 2c3:	75 16                	jne    2db <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 2c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2c8:	8d 50 01             	lea    0x1(%eax),%edx
 2cb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ce:	01 d0                	add    %edx,%eax
 2d0:	8a 00                	mov    (%eax),%al
 2d2:	84 c0                	test   %al,%al
 2d4:	75 07                	jne    2dd <strstr+0x77>
                    {
                        return i;
 2d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2d9:	eb 2d                	jmp    308 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 2db:	eb 11                	jmp    2ee <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 2dd:	ff 45 f8             	incl   -0x8(%ebp)
 2e0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2e3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2e6:	01 d0                	add    %edx,%eax
 2e8:	8a 00                	mov    (%eax),%al
 2ea:	84 c0                	test   %al,%al
 2ec:	75 b8                	jne    2a6 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2ee:	ff 45 fc             	incl   -0x4(%ebp)
 2f1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
 2f7:	01 d0                	add    %edx,%eax
 2f9:	8a 00                	mov    (%eax),%al
 2fb:	84 c0                	test   %al,%al
 2fd:	0f 85 72 ff ff ff    	jne    275 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 303:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 308:	c9                   	leave  
 309:	c3                   	ret    

0000030a <strtok>:

char *
strtok(char *s, const char *delim)
{
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	53                   	push   %ebx
 30e:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 311:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 315:	75 08                	jne    31f <strtok+0x15>
  s = lasts;
 317:	a1 a4 10 00 00       	mov    0x10a4,%eax
 31c:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	8d 50 01             	lea    0x1(%eax),%edx
 325:	89 55 08             	mov    %edx,0x8(%ebp)
 328:	8a 00                	mov    (%eax),%al
 32a:	0f be d8             	movsbl %al,%ebx
 32d:	85 db                	test   %ebx,%ebx
 32f:	75 07                	jne    338 <strtok+0x2e>
      return 0;
 331:	b8 00 00 00 00       	mov    $0x0,%eax
 336:	eb 58                	jmp    390 <strtok+0x86>
    } while (strchr(delim, ch));
 338:	88 d8                	mov    %bl,%al
 33a:	0f be c0             	movsbl %al,%eax
 33d:	89 44 24 04          	mov    %eax,0x4(%esp)
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	89 04 24             	mov    %eax,(%esp)
 347:	e8 7e fe ff ff       	call   1ca <strchr>
 34c:	85 c0                	test   %eax,%eax
 34e:	75 cf                	jne    31f <strtok+0x15>
    --s;
 350:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 353:	8b 45 0c             	mov    0xc(%ebp),%eax
 356:	89 44 24 04          	mov    %eax,0x4(%esp)
 35a:	8b 45 08             	mov    0x8(%ebp),%eax
 35d:	89 04 24             	mov    %eax,(%esp)
 360:	e8 31 00 00 00       	call   396 <strcspn>
 365:	89 c2                	mov    %eax,%edx
 367:	8b 45 08             	mov    0x8(%ebp),%eax
 36a:	01 d0                	add    %edx,%eax
 36c:	a3 a4 10 00 00       	mov    %eax,0x10a4
    if (*lasts != 0)
 371:	a1 a4 10 00 00       	mov    0x10a4,%eax
 376:	8a 00                	mov    (%eax),%al
 378:	84 c0                	test   %al,%al
 37a:	74 11                	je     38d <strtok+0x83>
  *lasts++ = 0;
 37c:	a1 a4 10 00 00       	mov    0x10a4,%eax
 381:	8d 50 01             	lea    0x1(%eax),%edx
 384:	89 15 a4 10 00 00    	mov    %edx,0x10a4
 38a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 390:	83 c4 14             	add    $0x14,%esp
 393:	5b                   	pop    %ebx
 394:	5d                   	pop    %ebp
 395:	c3                   	ret    

00000396 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 396:	55                   	push   %ebp
 397:	89 e5                	mov    %esp,%ebp
 399:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 39c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 3a3:	eb 26                	jmp    3cb <strcspn+0x35>
        if(strchr(s2,*s1))
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
 3a8:	8a 00                	mov    (%eax),%al
 3aa:	0f be c0             	movsbl %al,%eax
 3ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 3b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b4:	89 04 24             	mov    %eax,(%esp)
 3b7:	e8 0e fe ff ff       	call   1ca <strchr>
 3bc:	85 c0                	test   %eax,%eax
 3be:	74 05                	je     3c5 <strcspn+0x2f>
            return ret;
 3c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3c3:	eb 12                	jmp    3d7 <strcspn+0x41>
        else
            s1++,ret++;
 3c5:	ff 45 08             	incl   0x8(%ebp)
 3c8:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 3cb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ce:	8a 00                	mov    (%eax),%al
 3d0:	84 c0                	test   %al,%al
 3d2:	75 d1                	jne    3a5 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 3d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d7:	c9                   	leave  
 3d8:	c3                   	ret    

000003d9 <isspace>:

int
isspace(unsigned char c)
{
 3d9:	55                   	push   %ebp
 3da:	89 e5                	mov    %esp,%ebp
 3dc:	83 ec 04             	sub    $0x4,%esp
 3df:	8b 45 08             	mov    0x8(%ebp),%eax
 3e2:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 3e5:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 3e9:	74 1e                	je     409 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 3eb:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 3ef:	74 18                	je     409 <isspace+0x30>
 3f1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 3f5:	74 12                	je     409 <isspace+0x30>
 3f7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 3fb:	74 0c                	je     409 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 3fd:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 401:	74 06                	je     409 <isspace+0x30>
 403:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 407:	75 07                	jne    410 <isspace+0x37>
 409:	b8 01 00 00 00       	mov    $0x1,%eax
 40e:	eb 05                	jmp    415 <isspace+0x3c>
 410:	b8 00 00 00 00       	mov    $0x0,%eax
}
 415:	c9                   	leave  
 416:	c3                   	ret    

00000417 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 417:	55                   	push   %ebp
 418:	89 e5                	mov    %esp,%ebp
 41a:	57                   	push   %edi
 41b:	56                   	push   %esi
 41c:	53                   	push   %ebx
 41d:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 420:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 425:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 42c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 42f:	eb 01                	jmp    432 <strtoul+0x1b>
  p += 1;
 431:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 432:	8a 03                	mov    (%ebx),%al
 434:	0f b6 c0             	movzbl %al,%eax
 437:	89 04 24             	mov    %eax,(%esp)
 43a:	e8 9a ff ff ff       	call   3d9 <isspace>
 43f:	85 c0                	test   %eax,%eax
 441:	75 ee                	jne    431 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 443:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 447:	75 30                	jne    479 <strtoul+0x62>
    {
  if (*p == '0') {
 449:	8a 03                	mov    (%ebx),%al
 44b:	3c 30                	cmp    $0x30,%al
 44d:	75 21                	jne    470 <strtoul+0x59>
      p += 1;
 44f:	43                   	inc    %ebx
      if (*p == 'x') {
 450:	8a 03                	mov    (%ebx),%al
 452:	3c 78                	cmp    $0x78,%al
 454:	75 0a                	jne    460 <strtoul+0x49>
    p += 1;
 456:	43                   	inc    %ebx
    base = 16;
 457:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 45e:	eb 31                	jmp    491 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 460:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 467:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 46e:	eb 21                	jmp    491 <strtoul+0x7a>
      }
  }
  else base = 10;
 470:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 477:	eb 18                	jmp    491 <strtoul+0x7a>
    } else if (base == 16) {
 479:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 47d:	75 12                	jne    491 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 47f:	8a 03                	mov    (%ebx),%al
 481:	3c 30                	cmp    $0x30,%al
 483:	75 0c                	jne    491 <strtoul+0x7a>
 485:	8d 43 01             	lea    0x1(%ebx),%eax
 488:	8a 00                	mov    (%eax),%al
 48a:	3c 78                	cmp    $0x78,%al
 48c:	75 03                	jne    491 <strtoul+0x7a>
      p += 2;
 48e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 491:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 495:	75 29                	jne    4c0 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 497:	8a 03                	mov    (%ebx),%al
 499:	0f be c0             	movsbl %al,%eax
 49c:	83 e8 30             	sub    $0x30,%eax
 49f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 4a1:	83 fe 07             	cmp    $0x7,%esi
 4a4:	76 06                	jbe    4ac <strtoul+0x95>
    break;
 4a6:	90                   	nop
 4a7:	e9 b6 00 00 00       	jmp    562 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 4ac:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 4b3:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4b6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 4bd:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 4be:	eb d7                	jmp    497 <strtoul+0x80>
    } else if (base == 10) {
 4c0:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 4c4:	75 2b                	jne    4f1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4c6:	8a 03                	mov    (%ebx),%al
 4c8:	0f be c0             	movsbl %al,%eax
 4cb:	83 e8 30             	sub    $0x30,%eax
 4ce:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 4d0:	83 fe 09             	cmp    $0x9,%esi
 4d3:	76 06                	jbe    4db <strtoul+0xc4>
    break;
 4d5:	90                   	nop
 4d6:	e9 87 00 00 00       	jmp    562 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 4db:	89 f8                	mov    %edi,%eax
 4dd:	c1 e0 02             	shl    $0x2,%eax
 4e0:	01 f8                	add    %edi,%eax
 4e2:	01 c0                	add    %eax,%eax
 4e4:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 4e7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 4ee:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 4ef:	eb d5                	jmp    4c6 <strtoul+0xaf>
    } else if (base == 16) {
 4f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4f5:	75 35                	jne    52c <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4f7:	8a 03                	mov    (%ebx),%al
 4f9:	0f be c0             	movsbl %al,%eax
 4fc:	83 e8 30             	sub    $0x30,%eax
 4ff:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 501:	83 fe 4a             	cmp    $0x4a,%esi
 504:	76 02                	jbe    508 <strtoul+0xf1>
    break;
 506:	eb 22                	jmp    52a <strtoul+0x113>
      }
      digit = cvtIn[digit];
 508:	8a 86 40 10 00 00    	mov    0x1040(%esi),%al
 50e:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 511:	83 fe 0f             	cmp    $0xf,%esi
 514:	76 02                	jbe    518 <strtoul+0x101>
    break;
 516:	eb 12                	jmp    52a <strtoul+0x113>
      }
      result = (result << 4) + digit;
 518:	89 f8                	mov    %edi,%eax
 51a:	c1 e0 04             	shl    $0x4,%eax
 51d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 520:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 527:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 528:	eb cd                	jmp    4f7 <strtoul+0xe0>
 52a:	eb 36                	jmp    562 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 52c:	8a 03                	mov    (%ebx),%al
 52e:	0f be c0             	movsbl %al,%eax
 531:	83 e8 30             	sub    $0x30,%eax
 534:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 536:	83 fe 4a             	cmp    $0x4a,%esi
 539:	76 02                	jbe    53d <strtoul+0x126>
    break;
 53b:	eb 25                	jmp    562 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 53d:	8a 86 40 10 00 00    	mov    0x1040(%esi),%al
 543:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 546:	8b 45 10             	mov    0x10(%ebp),%eax
 549:	39 f0                	cmp    %esi,%eax
 54b:	77 02                	ja     54f <strtoul+0x138>
    break;
 54d:	eb 13                	jmp    562 <strtoul+0x14b>
      }
      result = result*base + digit;
 54f:	8b 45 10             	mov    0x10(%ebp),%eax
 552:	0f af c7             	imul   %edi,%eax
 555:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 558:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 55f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 560:	eb ca                	jmp    52c <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 562:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 566:	75 03                	jne    56b <strtoul+0x154>
  p = string;
 568:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 56b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 56f:	74 05                	je     576 <strtoul+0x15f>
  *endPtr = p;
 571:	8b 45 0c             	mov    0xc(%ebp),%eax
 574:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 576:	89 f8                	mov    %edi,%eax
}
 578:	83 c4 14             	add    $0x14,%esp
 57b:	5b                   	pop    %ebx
 57c:	5e                   	pop    %esi
 57d:	5f                   	pop    %edi
 57e:	5d                   	pop    %ebp
 57f:	c3                   	ret    

00000580 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 580:	55                   	push   %ebp
 581:	89 e5                	mov    %esp,%ebp
 583:	53                   	push   %ebx
 584:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 587:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 58a:	eb 01                	jmp    58d <strtol+0xd>
      p += 1;
 58c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 58d:	8a 03                	mov    (%ebx),%al
 58f:	0f b6 c0             	movzbl %al,%eax
 592:	89 04 24             	mov    %eax,(%esp)
 595:	e8 3f fe ff ff       	call   3d9 <isspace>
 59a:	85 c0                	test   %eax,%eax
 59c:	75 ee                	jne    58c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 59e:	8a 03                	mov    (%ebx),%al
 5a0:	3c 2d                	cmp    $0x2d,%al
 5a2:	75 1e                	jne    5c2 <strtol+0x42>
  p += 1;
 5a4:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 5a5:	8b 45 10             	mov    0x10(%ebp),%eax
 5a8:	89 44 24 08          	mov    %eax,0x8(%esp)
 5ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 5af:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b3:	89 1c 24             	mov    %ebx,(%esp)
 5b6:	e8 5c fe ff ff       	call   417 <strtoul>
 5bb:	f7 d8                	neg    %eax
 5bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
 5c0:	eb 20                	jmp    5e2 <strtol+0x62>
    } else {
  if (*p == '+') {
 5c2:	8a 03                	mov    (%ebx),%al
 5c4:	3c 2b                	cmp    $0x2b,%al
 5c6:	75 01                	jne    5c9 <strtol+0x49>
      p += 1;
 5c8:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 5c9:	8b 45 10             	mov    0x10(%ebp),%eax
 5cc:	89 44 24 08          	mov    %eax,0x8(%esp)
 5d0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d7:	89 1c 24             	mov    %ebx,(%esp)
 5da:	e8 38 fe ff ff       	call   417 <strtoul>
 5df:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 5e2:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 5e6:	75 17                	jne    5ff <strtol+0x7f>
 5e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ec:	74 11                	je     5ff <strtol+0x7f>
 5ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f1:	8b 00                	mov    (%eax),%eax
 5f3:	39 d8                	cmp    %ebx,%eax
 5f5:	75 08                	jne    5ff <strtol+0x7f>
  *endPtr = string;
 5f7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5fa:	8b 55 08             	mov    0x8(%ebp),%edx
 5fd:	89 10                	mov    %edx,(%eax)
    }
    return result;
 5ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 602:	83 c4 1c             	add    $0x1c,%esp
 605:	5b                   	pop    %ebx
 606:	5d                   	pop    %ebp
 607:	c3                   	ret    

00000608 <gets>:

char*
gets(char *buf, int max)
{
 608:	55                   	push   %ebp
 609:	89 e5                	mov    %esp,%ebp
 60b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 60e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 615:	eb 49                	jmp    660 <gets+0x58>
    cc = read(0, &c, 1);
 617:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 61e:	00 
 61f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 622:	89 44 24 04          	mov    %eax,0x4(%esp)
 626:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 62d:	e8 3e 01 00 00       	call   770 <read>
 632:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 639:	7f 02                	jg     63d <gets+0x35>
      break;
 63b:	eb 2c                	jmp    669 <gets+0x61>
    buf[i++] = c;
 63d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 640:	8d 50 01             	lea    0x1(%eax),%edx
 643:	89 55 f4             	mov    %edx,-0xc(%ebp)
 646:	89 c2                	mov    %eax,%edx
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	01 c2                	add    %eax,%edx
 64d:	8a 45 ef             	mov    -0x11(%ebp),%al
 650:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 652:	8a 45 ef             	mov    -0x11(%ebp),%al
 655:	3c 0a                	cmp    $0xa,%al
 657:	74 10                	je     669 <gets+0x61>
 659:	8a 45 ef             	mov    -0x11(%ebp),%al
 65c:	3c 0d                	cmp    $0xd,%al
 65e:	74 09                	je     669 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 660:	8b 45 f4             	mov    -0xc(%ebp),%eax
 663:	40                   	inc    %eax
 664:	3b 45 0c             	cmp    0xc(%ebp),%eax
 667:	7c ae                	jl     617 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 669:	8b 55 f4             	mov    -0xc(%ebp),%edx
 66c:	8b 45 08             	mov    0x8(%ebp),%eax
 66f:	01 d0                	add    %edx,%eax
 671:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 674:	8b 45 08             	mov    0x8(%ebp),%eax
}
 677:	c9                   	leave  
 678:	c3                   	ret    

00000679 <stat>:

int
stat(char *n, struct stat *st)
{
 679:	55                   	push   %ebp
 67a:	89 e5                	mov    %esp,%ebp
 67c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 67f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 686:	00 
 687:	8b 45 08             	mov    0x8(%ebp),%eax
 68a:	89 04 24             	mov    %eax,(%esp)
 68d:	e8 06 01 00 00       	call   798 <open>
 692:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 695:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 699:	79 07                	jns    6a2 <stat+0x29>
    return -1;
 69b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6a0:	eb 23                	jmp    6c5 <stat+0x4c>
  r = fstat(fd, st);
 6a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ac:	89 04 24             	mov    %eax,(%esp)
 6af:	e8 fc 00 00 00       	call   7b0 <fstat>
 6b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 be 00 00 00       	call   780 <close>
  return r;
 6c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 6c5:	c9                   	leave  
 6c6:	c3                   	ret    

000006c7 <atoi>:

int
atoi(const char *s)
{
 6c7:	55                   	push   %ebp
 6c8:	89 e5                	mov    %esp,%ebp
 6ca:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 6cd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 6d4:	eb 24                	jmp    6fa <atoi+0x33>
    n = n*10 + *s++ - '0';
 6d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 6d9:	89 d0                	mov    %edx,%eax
 6db:	c1 e0 02             	shl    $0x2,%eax
 6de:	01 d0                	add    %edx,%eax
 6e0:	01 c0                	add    %eax,%eax
 6e2:	89 c1                	mov    %eax,%ecx
 6e4:	8b 45 08             	mov    0x8(%ebp),%eax
 6e7:	8d 50 01             	lea    0x1(%eax),%edx
 6ea:	89 55 08             	mov    %edx,0x8(%ebp)
 6ed:	8a 00                	mov    (%eax),%al
 6ef:	0f be c0             	movsbl %al,%eax
 6f2:	01 c8                	add    %ecx,%eax
 6f4:	83 e8 30             	sub    $0x30,%eax
 6f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6fa:	8b 45 08             	mov    0x8(%ebp),%eax
 6fd:	8a 00                	mov    (%eax),%al
 6ff:	3c 2f                	cmp    $0x2f,%al
 701:	7e 09                	jle    70c <atoi+0x45>
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	8a 00                	mov    (%eax),%al
 708:	3c 39                	cmp    $0x39,%al
 70a:	7e ca                	jle    6d6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 70f:	c9                   	leave  
 710:	c3                   	ret    

00000711 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 711:	55                   	push   %ebp
 712:	89 e5                	mov    %esp,%ebp
 714:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 71d:	8b 45 0c             	mov    0xc(%ebp),%eax
 720:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 723:	eb 16                	jmp    73b <memmove+0x2a>
    *dst++ = *src++;
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8d 50 01             	lea    0x1(%eax),%edx
 72b:	89 55 fc             	mov    %edx,-0x4(%ebp)
 72e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 731:	8d 4a 01             	lea    0x1(%edx),%ecx
 734:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 737:	8a 12                	mov    (%edx),%dl
 739:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 73b:	8b 45 10             	mov    0x10(%ebp),%eax
 73e:	8d 50 ff             	lea    -0x1(%eax),%edx
 741:	89 55 10             	mov    %edx,0x10(%ebp)
 744:	85 c0                	test   %eax,%eax
 746:	7f dd                	jg     725 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 748:	8b 45 08             	mov    0x8(%ebp),%eax
}
 74b:	c9                   	leave  
 74c:	c3                   	ret    
 74d:	90                   	nop
 74e:	90                   	nop
 74f:	90                   	nop

00000750 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 750:	b8 01 00 00 00       	mov    $0x1,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <exit>:
SYSCALL(exit)
 758:	b8 02 00 00 00       	mov    $0x2,%eax
 75d:	cd 40                	int    $0x40
 75f:	c3                   	ret    

00000760 <wait>:
SYSCALL(wait)
 760:	b8 03 00 00 00       	mov    $0x3,%eax
 765:	cd 40                	int    $0x40
 767:	c3                   	ret    

00000768 <pipe>:
SYSCALL(pipe)
 768:	b8 04 00 00 00       	mov    $0x4,%eax
 76d:	cd 40                	int    $0x40
 76f:	c3                   	ret    

00000770 <read>:
SYSCALL(read)
 770:	b8 05 00 00 00       	mov    $0x5,%eax
 775:	cd 40                	int    $0x40
 777:	c3                   	ret    

00000778 <write>:
SYSCALL(write)
 778:	b8 10 00 00 00       	mov    $0x10,%eax
 77d:	cd 40                	int    $0x40
 77f:	c3                   	ret    

00000780 <close>:
SYSCALL(close)
 780:	b8 15 00 00 00       	mov    $0x15,%eax
 785:	cd 40                	int    $0x40
 787:	c3                   	ret    

00000788 <kill>:
SYSCALL(kill)
 788:	b8 06 00 00 00       	mov    $0x6,%eax
 78d:	cd 40                	int    $0x40
 78f:	c3                   	ret    

00000790 <exec>:
SYSCALL(exec)
 790:	b8 07 00 00 00       	mov    $0x7,%eax
 795:	cd 40                	int    $0x40
 797:	c3                   	ret    

00000798 <open>:
SYSCALL(open)
 798:	b8 0f 00 00 00       	mov    $0xf,%eax
 79d:	cd 40                	int    $0x40
 79f:	c3                   	ret    

000007a0 <mknod>:
SYSCALL(mknod)
 7a0:	b8 11 00 00 00       	mov    $0x11,%eax
 7a5:	cd 40                	int    $0x40
 7a7:	c3                   	ret    

000007a8 <unlink>:
SYSCALL(unlink)
 7a8:	b8 12 00 00 00       	mov    $0x12,%eax
 7ad:	cd 40                	int    $0x40
 7af:	c3                   	ret    

000007b0 <fstat>:
SYSCALL(fstat)
 7b0:	b8 08 00 00 00       	mov    $0x8,%eax
 7b5:	cd 40                	int    $0x40
 7b7:	c3                   	ret    

000007b8 <link>:
SYSCALL(link)
 7b8:	b8 13 00 00 00       	mov    $0x13,%eax
 7bd:	cd 40                	int    $0x40
 7bf:	c3                   	ret    

000007c0 <mkdir>:
SYSCALL(mkdir)
 7c0:	b8 14 00 00 00       	mov    $0x14,%eax
 7c5:	cd 40                	int    $0x40
 7c7:	c3                   	ret    

000007c8 <chdir>:
SYSCALL(chdir)
 7c8:	b8 09 00 00 00       	mov    $0x9,%eax
 7cd:	cd 40                	int    $0x40
 7cf:	c3                   	ret    

000007d0 <dup>:
SYSCALL(dup)
 7d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 7d5:	cd 40                	int    $0x40
 7d7:	c3                   	ret    

000007d8 <getpid>:
SYSCALL(getpid)
 7d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 7dd:	cd 40                	int    $0x40
 7df:	c3                   	ret    

000007e0 <sbrk>:
SYSCALL(sbrk)
 7e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 7e5:	cd 40                	int    $0x40
 7e7:	c3                   	ret    

000007e8 <sleep>:
SYSCALL(sleep)
 7e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 7ed:	cd 40                	int    $0x40
 7ef:	c3                   	ret    

000007f0 <uptime>:
SYSCALL(uptime)
 7f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 7f5:	cd 40                	int    $0x40
 7f7:	c3                   	ret    

000007f8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 7f8:	55                   	push   %ebp
 7f9:	89 e5                	mov    %esp,%ebp
 7fb:	83 ec 18             	sub    $0x18,%esp
 7fe:	8b 45 0c             	mov    0xc(%ebp),%eax
 801:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 804:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 80b:	00 
 80c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 80f:	89 44 24 04          	mov    %eax,0x4(%esp)
 813:	8b 45 08             	mov    0x8(%ebp),%eax
 816:	89 04 24             	mov    %eax,(%esp)
 819:	e8 5a ff ff ff       	call   778 <write>
}
 81e:	c9                   	leave  
 81f:	c3                   	ret    

00000820 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 820:	55                   	push   %ebp
 821:	89 e5                	mov    %esp,%ebp
 823:	56                   	push   %esi
 824:	53                   	push   %ebx
 825:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 828:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 82f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 833:	74 17                	je     84c <printint+0x2c>
 835:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 839:	79 11                	jns    84c <printint+0x2c>
    neg = 1;
 83b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 842:	8b 45 0c             	mov    0xc(%ebp),%eax
 845:	f7 d8                	neg    %eax
 847:	89 45 ec             	mov    %eax,-0x14(%ebp)
 84a:	eb 06                	jmp    852 <printint+0x32>
  } else {
    x = xx;
 84c:	8b 45 0c             	mov    0xc(%ebp),%eax
 84f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 852:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 859:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 85c:	8d 41 01             	lea    0x1(%ecx),%eax
 85f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 862:	8b 5d 10             	mov    0x10(%ebp),%ebx
 865:	8b 45 ec             	mov    -0x14(%ebp),%eax
 868:	ba 00 00 00 00       	mov    $0x0,%edx
 86d:	f7 f3                	div    %ebx
 86f:	89 d0                	mov    %edx,%eax
 871:	8a 80 8c 10 00 00    	mov    0x108c(%eax),%al
 877:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 87b:	8b 75 10             	mov    0x10(%ebp),%esi
 87e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 881:	ba 00 00 00 00       	mov    $0x0,%edx
 886:	f7 f6                	div    %esi
 888:	89 45 ec             	mov    %eax,-0x14(%ebp)
 88b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 88f:	75 c8                	jne    859 <printint+0x39>
  if(neg)
 891:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 895:	74 10                	je     8a7 <printint+0x87>
    buf[i++] = '-';
 897:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89a:	8d 50 01             	lea    0x1(%eax),%edx
 89d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8a0:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8a5:	eb 1e                	jmp    8c5 <printint+0xa5>
 8a7:	eb 1c                	jmp    8c5 <printint+0xa5>
    putc(fd, buf[i]);
 8a9:	8d 55 dc             	lea    -0x24(%ebp),%edx
 8ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8af:	01 d0                	add    %edx,%eax
 8b1:	8a 00                	mov    (%eax),%al
 8b3:	0f be c0             	movsbl %al,%eax
 8b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ba:	8b 45 08             	mov    0x8(%ebp),%eax
 8bd:	89 04 24             	mov    %eax,(%esp)
 8c0:	e8 33 ff ff ff       	call   7f8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 8c5:	ff 4d f4             	decl   -0xc(%ebp)
 8c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8cc:	79 db                	jns    8a9 <printint+0x89>
    putc(fd, buf[i]);
}
 8ce:	83 c4 30             	add    $0x30,%esp
 8d1:	5b                   	pop    %ebx
 8d2:	5e                   	pop    %esi
 8d3:	5d                   	pop    %ebp
 8d4:	c3                   	ret    

000008d5 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 8d5:	55                   	push   %ebp
 8d6:	89 e5                	mov    %esp,%ebp
 8d8:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 8db:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 8e2:	8d 45 0c             	lea    0xc(%ebp),%eax
 8e5:	83 c0 04             	add    $0x4,%eax
 8e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 8eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 8f2:	e9 77 01 00 00       	jmp    a6e <printf+0x199>
    c = fmt[i] & 0xff;
 8f7:	8b 55 0c             	mov    0xc(%ebp),%edx
 8fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fd:	01 d0                	add    %edx,%eax
 8ff:	8a 00                	mov    (%eax),%al
 901:	0f be c0             	movsbl %al,%eax
 904:	25 ff 00 00 00       	and    $0xff,%eax
 909:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 90c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 910:	75 2c                	jne    93e <printf+0x69>
      if(c == '%'){
 912:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 916:	75 0c                	jne    924 <printf+0x4f>
        state = '%';
 918:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 91f:	e9 47 01 00 00       	jmp    a6b <printf+0x196>
      } else {
        putc(fd, c);
 924:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 927:	0f be c0             	movsbl %al,%eax
 92a:	89 44 24 04          	mov    %eax,0x4(%esp)
 92e:	8b 45 08             	mov    0x8(%ebp),%eax
 931:	89 04 24             	mov    %eax,(%esp)
 934:	e8 bf fe ff ff       	call   7f8 <putc>
 939:	e9 2d 01 00 00       	jmp    a6b <printf+0x196>
      }
    } else if(state == '%'){
 93e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 942:	0f 85 23 01 00 00    	jne    a6b <printf+0x196>
      if(c == 'd'){
 948:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 94c:	75 2d                	jne    97b <printf+0xa6>
        printint(fd, *ap, 10, 1);
 94e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 951:	8b 00                	mov    (%eax),%eax
 953:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 95a:	00 
 95b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 962:	00 
 963:	89 44 24 04          	mov    %eax,0x4(%esp)
 967:	8b 45 08             	mov    0x8(%ebp),%eax
 96a:	89 04 24             	mov    %eax,(%esp)
 96d:	e8 ae fe ff ff       	call   820 <printint>
        ap++;
 972:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 976:	e9 e9 00 00 00       	jmp    a64 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 97b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 97f:	74 06                	je     987 <printf+0xb2>
 981:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 985:	75 2d                	jne    9b4 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 987:	8b 45 e8             	mov    -0x18(%ebp),%eax
 98a:	8b 00                	mov    (%eax),%eax
 98c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 993:	00 
 994:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 99b:	00 
 99c:	89 44 24 04          	mov    %eax,0x4(%esp)
 9a0:	8b 45 08             	mov    0x8(%ebp),%eax
 9a3:	89 04 24             	mov    %eax,(%esp)
 9a6:	e8 75 fe ff ff       	call   820 <printint>
        ap++;
 9ab:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9af:	e9 b0 00 00 00       	jmp    a64 <printf+0x18f>
      } else if(c == 's'){
 9b4:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 9b8:	75 42                	jne    9fc <printf+0x127>
        s = (char*)*ap;
 9ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9bd:	8b 00                	mov    (%eax),%eax
 9bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 9c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 9c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9ca:	75 09                	jne    9d5 <printf+0x100>
          s = "(null)";
 9cc:	c7 45 f4 cc 0c 00 00 	movl   $0xccc,-0xc(%ebp)
        while(*s != 0){
 9d3:	eb 1c                	jmp    9f1 <printf+0x11c>
 9d5:	eb 1a                	jmp    9f1 <printf+0x11c>
          putc(fd, *s);
 9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9da:	8a 00                	mov    (%eax),%al
 9dc:	0f be c0             	movsbl %al,%eax
 9df:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e3:	8b 45 08             	mov    0x8(%ebp),%eax
 9e6:	89 04 24             	mov    %eax,(%esp)
 9e9:	e8 0a fe ff ff       	call   7f8 <putc>
          s++;
 9ee:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 9f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f4:	8a 00                	mov    (%eax),%al
 9f6:	84 c0                	test   %al,%al
 9f8:	75 dd                	jne    9d7 <printf+0x102>
 9fa:	eb 68                	jmp    a64 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 9fc:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a00:	75 1d                	jne    a1f <printf+0x14a>
        putc(fd, *ap);
 a02:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a05:	8b 00                	mov    (%eax),%eax
 a07:	0f be c0             	movsbl %al,%eax
 a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
 a0e:	8b 45 08             	mov    0x8(%ebp),%eax
 a11:	89 04 24             	mov    %eax,(%esp)
 a14:	e8 df fd ff ff       	call   7f8 <putc>
        ap++;
 a19:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a1d:	eb 45                	jmp    a64 <printf+0x18f>
      } else if(c == '%'){
 a1f:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a23:	75 17                	jne    a3c <printf+0x167>
        putc(fd, c);
 a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a28:	0f be c0             	movsbl %al,%eax
 a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
 a2f:	8b 45 08             	mov    0x8(%ebp),%eax
 a32:	89 04 24             	mov    %eax,(%esp)
 a35:	e8 be fd ff ff       	call   7f8 <putc>
 a3a:	eb 28                	jmp    a64 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a3c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a43:	00 
 a44:	8b 45 08             	mov    0x8(%ebp),%eax
 a47:	89 04 24             	mov    %eax,(%esp)
 a4a:	e8 a9 fd ff ff       	call   7f8 <putc>
        putc(fd, c);
 a4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a52:	0f be c0             	movsbl %al,%eax
 a55:	89 44 24 04          	mov    %eax,0x4(%esp)
 a59:	8b 45 08             	mov    0x8(%ebp),%eax
 a5c:	89 04 24             	mov    %eax,(%esp)
 a5f:	e8 94 fd ff ff       	call   7f8 <putc>
      }
      state = 0;
 a64:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 a6b:	ff 45 f0             	incl   -0x10(%ebp)
 a6e:	8b 55 0c             	mov    0xc(%ebp),%edx
 a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a74:	01 d0                	add    %edx,%eax
 a76:	8a 00                	mov    (%eax),%al
 a78:	84 c0                	test   %al,%al
 a7a:	0f 85 77 fe ff ff    	jne    8f7 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 a80:	c9                   	leave  
 a81:	c3                   	ret    
 a82:	90                   	nop
 a83:	90                   	nop

00000a84 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a84:	55                   	push   %ebp
 a85:	89 e5                	mov    %esp,%ebp
 a87:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a8a:	8b 45 08             	mov    0x8(%ebp),%eax
 a8d:	83 e8 08             	sub    $0x8,%eax
 a90:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a93:	a1 b0 10 00 00       	mov    0x10b0,%eax
 a98:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a9b:	eb 24                	jmp    ac1 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa0:	8b 00                	mov    (%eax),%eax
 aa2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aa5:	77 12                	ja     ab9 <free+0x35>
 aa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aaa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 aad:	77 24                	ja     ad3 <free+0x4f>
 aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab2:	8b 00                	mov    (%eax),%eax
 ab4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ab7:	77 1a                	ja     ad3 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ab9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abc:	8b 00                	mov    (%eax),%eax
 abe:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ac1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ac4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ac7:	76 d4                	jbe    a9d <free+0x19>
 ac9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acc:	8b 00                	mov    (%eax),%eax
 ace:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ad1:	76 ca                	jbe    a9d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 ad3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ad6:	8b 40 04             	mov    0x4(%eax),%eax
 ad9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ae0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae3:	01 c2                	add    %eax,%edx
 ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae8:	8b 00                	mov    (%eax),%eax
 aea:	39 c2                	cmp    %eax,%edx
 aec:	75 24                	jne    b12 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 aee:	8b 45 f8             	mov    -0x8(%ebp),%eax
 af1:	8b 50 04             	mov    0x4(%eax),%edx
 af4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af7:	8b 00                	mov    (%eax),%eax
 af9:	8b 40 04             	mov    0x4(%eax),%eax
 afc:	01 c2                	add    %eax,%edx
 afe:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b01:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b04:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b07:	8b 00                	mov    (%eax),%eax
 b09:	8b 10                	mov    (%eax),%edx
 b0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b0e:	89 10                	mov    %edx,(%eax)
 b10:	eb 0a                	jmp    b1c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b12:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b15:	8b 10                	mov    (%eax),%edx
 b17:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b1a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b1f:	8b 40 04             	mov    0x4(%eax),%eax
 b22:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b29:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b2c:	01 d0                	add    %edx,%eax
 b2e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b31:	75 20                	jne    b53 <free+0xcf>
    p->s.size += bp->s.size;
 b33:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b36:	8b 50 04             	mov    0x4(%eax),%edx
 b39:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b3c:	8b 40 04             	mov    0x4(%eax),%eax
 b3f:	01 c2                	add    %eax,%edx
 b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b44:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b47:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b4a:	8b 10                	mov    (%eax),%edx
 b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4f:	89 10                	mov    %edx,(%eax)
 b51:	eb 08                	jmp    b5b <free+0xd7>
  } else
    p->s.ptr = bp;
 b53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b56:	8b 55 f8             	mov    -0x8(%ebp),%edx
 b59:	89 10                	mov    %edx,(%eax)
  freep = p;
 b5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5e:	a3 b0 10 00 00       	mov    %eax,0x10b0
}
 b63:	c9                   	leave  
 b64:	c3                   	ret    

00000b65 <morecore>:

static Header*
morecore(uint nu)
{
 b65:	55                   	push   %ebp
 b66:	89 e5                	mov    %esp,%ebp
 b68:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b6b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b72:	77 07                	ja     b7b <morecore+0x16>
    nu = 4096;
 b74:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b7b:	8b 45 08             	mov    0x8(%ebp),%eax
 b7e:	c1 e0 03             	shl    $0x3,%eax
 b81:	89 04 24             	mov    %eax,(%esp)
 b84:	e8 57 fc ff ff       	call   7e0 <sbrk>
 b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b8c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b90:	75 07                	jne    b99 <morecore+0x34>
    return 0;
 b92:	b8 00 00 00 00       	mov    $0x0,%eax
 b97:	eb 22                	jmp    bbb <morecore+0x56>
  hp = (Header*)p;
 b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba2:	8b 55 08             	mov    0x8(%ebp),%edx
 ba5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bab:	83 c0 08             	add    $0x8,%eax
 bae:	89 04 24             	mov    %eax,(%esp)
 bb1:	e8 ce fe ff ff       	call   a84 <free>
  return freep;
 bb6:	a1 b0 10 00 00       	mov    0x10b0,%eax
}
 bbb:	c9                   	leave  
 bbc:	c3                   	ret    

00000bbd <malloc>:

void*
malloc(uint nbytes)
{
 bbd:	55                   	push   %ebp
 bbe:	89 e5                	mov    %esp,%ebp
 bc0:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 bc3:	8b 45 08             	mov    0x8(%ebp),%eax
 bc6:	83 c0 07             	add    $0x7,%eax
 bc9:	c1 e8 03             	shr    $0x3,%eax
 bcc:	40                   	inc    %eax
 bcd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 bd0:	a1 b0 10 00 00       	mov    0x10b0,%eax
 bd5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 bd8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bdc:	75 23                	jne    c01 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 bde:	c7 45 f0 a8 10 00 00 	movl   $0x10a8,-0x10(%ebp)
 be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 be8:	a3 b0 10 00 00       	mov    %eax,0x10b0
 bed:	a1 b0 10 00 00       	mov    0x10b0,%eax
 bf2:	a3 a8 10 00 00       	mov    %eax,0x10a8
    base.s.size = 0;
 bf7:	c7 05 ac 10 00 00 00 	movl   $0x0,0x10ac
 bfe:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c01:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c04:	8b 00                	mov    (%eax),%eax
 c06:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c0c:	8b 40 04             	mov    0x4(%eax),%eax
 c0f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c12:	72 4d                	jb     c61 <malloc+0xa4>
      if(p->s.size == nunits)
 c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c17:	8b 40 04             	mov    0x4(%eax),%eax
 c1a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c1d:	75 0c                	jne    c2b <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c22:	8b 10                	mov    (%eax),%edx
 c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c27:	89 10                	mov    %edx,(%eax)
 c29:	eb 26                	jmp    c51 <malloc+0x94>
      else {
        p->s.size -= nunits;
 c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2e:	8b 40 04             	mov    0x4(%eax),%eax
 c31:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c34:	89 c2                	mov    %eax,%edx
 c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c39:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c3f:	8b 40 04             	mov    0x4(%eax),%eax
 c42:	c1 e0 03             	shl    $0x3,%eax
 c45:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 c4e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 c51:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c54:	a3 b0 10 00 00       	mov    %eax,0x10b0
      return (void*)(p + 1);
 c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c5c:	83 c0 08             	add    $0x8,%eax
 c5f:	eb 38                	jmp    c99 <malloc+0xdc>
    }
    if(p == freep)
 c61:	a1 b0 10 00 00       	mov    0x10b0,%eax
 c66:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c69:	75 1b                	jne    c86 <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 c6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c6e:	89 04 24             	mov    %eax,(%esp)
 c71:	e8 ef fe ff ff       	call   b65 <morecore>
 c76:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c7d:	75 07                	jne    c86 <malloc+0xc9>
        return 0;
 c7f:	b8 00 00 00 00       	mov    $0x0,%eax
 c84:	eb 13                	jmp    c99 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c89:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c8f:	8b 00                	mov    (%eax),%eax
 c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 c94:	e9 70 ff ff ff       	jmp    c09 <malloc+0x4c>
}
 c99:	c9                   	leave  
 c9a:	c3                   	ret    
