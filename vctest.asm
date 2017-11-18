
_vctest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int fd, id;

  if (argc < 3) {
   9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(1, "usage: vctest <vc> <cmd> [<arg> ...]\n");
   f:	c7 44 24 04 f0 0c 00 	movl   $0xcf0,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 06 09 00 00       	call   929 <printf>
    exit();
  23:	e8 84 07 00 00       	call   7ac <exit>
  }

  fd = open(argv[1], O_RDWR);
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 04             	add    $0x4,%eax
  2e:	8b 00                	mov    (%eax),%eax
  30:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  37:	00 
  38:	89 04 24             	mov    %eax,(%esp)
  3b:	e8 ac 07 00 00       	call   7ec <open>
  40:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  printf(1, "fd = %d\n", fd);
  44:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  48:	89 44 24 08          	mov    %eax,0x8(%esp)
  4c:	c7 44 24 04 16 0d 00 	movl   $0xd16,0x4(%esp)
  53:	00 
  54:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  5b:	e8 c9 08 00 00       	call   929 <printf>

  /* fork a child and exec argv[1] */
  id = fork();
  60:	e8 3f 07 00 00       	call   7a4 <fork>
  65:	89 44 24 18          	mov    %eax,0x18(%esp)

  if (id == 0){
  69:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  6e:	75 67                	jne    d7 <main+0xd7>
    close(0);
  70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  77:	e8 58 07 00 00       	call   7d4 <close>
    close(1);
  7c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  83:	e8 4c 07 00 00       	call   7d4 <close>
    close(2);
  88:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8f:	e8 40 07 00 00       	call   7d4 <close>
    dup(fd);
  94:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  98:	89 04 24             	mov    %eax,(%esp)
  9b:	e8 84 07 00 00       	call   824 <dup>
    dup(fd);
  a0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  a4:	89 04 24             	mov    %eax,(%esp)
  a7:	e8 78 07 00 00       	call   824 <dup>
    dup(fd);
  ac:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b0:	89 04 24             	mov    %eax,(%esp)
  b3:	e8 6c 07 00 00       	call   824 <dup>
    exec(argv[2], &argv[2]);
  b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  bb:	8d 50 08             	lea    0x8(%eax),%edx
  be:	8b 45 0c             	mov    0xc(%ebp),%eax
  c1:	83 c0 08             	add    $0x8,%eax
  c4:	8b 00                	mov    (%eax),%eax
  c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  ca:	89 04 24             	mov    %eax,(%esp)
  cd:	e8 12 07 00 00       	call   7e4 <exec>
    exit();
  d2:	e8 d5 06 00 00       	call   7ac <exit>
  }

  printf(1, "%s started on vc0\n", argv[1]);
  d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  da:	83 c0 04             	add    $0x4,%eax
  dd:	8b 00                	mov    (%eax),%eax
  df:	89 44 24 08          	mov    %eax,0x8(%esp)
  e3:	c7 44 24 04 1f 0d 00 	movl   $0xd1f,0x4(%esp)
  ea:	00 
  eb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f2:	e8 32 08 00 00       	call   929 <printf>

  exit();
  f7:	e8 b0 06 00 00       	call   7ac <exit>

000000fc <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  fc:	55                   	push   %ebp
  fd:	89 e5                	mov    %esp,%ebp
  ff:	57                   	push   %edi
 100:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 101:	8b 4d 08             	mov    0x8(%ebp),%ecx
 104:	8b 55 10             	mov    0x10(%ebp),%edx
 107:	8b 45 0c             	mov    0xc(%ebp),%eax
 10a:	89 cb                	mov    %ecx,%ebx
 10c:	89 df                	mov    %ebx,%edi
 10e:	89 d1                	mov    %edx,%ecx
 110:	fc                   	cld    
 111:	f3 aa                	rep stos %al,%es:(%edi)
 113:	89 ca                	mov    %ecx,%edx
 115:	89 fb                	mov    %edi,%ebx
 117:	89 5d 08             	mov    %ebx,0x8(%ebp)
 11a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 11d:	5b                   	pop    %ebx
 11e:	5f                   	pop    %edi
 11f:	5d                   	pop    %ebp
 120:	c3                   	ret    

00000121 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 121:	55                   	push   %ebp
 122:	89 e5                	mov    %esp,%ebp
 124:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 127:	8b 45 08             	mov    0x8(%ebp),%eax
 12a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 12d:	90                   	nop
 12e:	8b 45 08             	mov    0x8(%ebp),%eax
 131:	8d 50 01             	lea    0x1(%eax),%edx
 134:	89 55 08             	mov    %edx,0x8(%ebp)
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
 13a:	8d 4a 01             	lea    0x1(%edx),%ecx
 13d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 140:	8a 12                	mov    (%edx),%dl
 142:	88 10                	mov    %dl,(%eax)
 144:	8a 00                	mov    (%eax),%al
 146:	84 c0                	test   %al,%al
 148:	75 e4                	jne    12e <strcpy+0xd>
    ;
  return os;
 14a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 14d:	c9                   	leave  
 14e:	c3                   	ret    

0000014f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14f:	55                   	push   %ebp
 150:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 152:	eb 06                	jmp    15a <strcmp+0xb>
    p++, q++;
 154:	ff 45 08             	incl   0x8(%ebp)
 157:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
 15d:	8a 00                	mov    (%eax),%al
 15f:	84 c0                	test   %al,%al
 161:	74 0e                	je     171 <strcmp+0x22>
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	8a 10                	mov    (%eax),%dl
 168:	8b 45 0c             	mov    0xc(%ebp),%eax
 16b:	8a 00                	mov    (%eax),%al
 16d:	38 c2                	cmp    %al,%dl
 16f:	74 e3                	je     154 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	8a 00                	mov    (%eax),%al
 176:	0f b6 d0             	movzbl %al,%edx
 179:	8b 45 0c             	mov    0xc(%ebp),%eax
 17c:	8a 00                	mov    (%eax),%al
 17e:	0f b6 c0             	movzbl %al,%eax
 181:	29 c2                	sub    %eax,%edx
 183:	89 d0                	mov    %edx,%eax
}
 185:	5d                   	pop    %ebp
 186:	c3                   	ret    

00000187 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 187:	55                   	push   %ebp
 188:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 18a:	eb 09                	jmp    195 <strncmp+0xe>
    n--, p++, q++;
 18c:	ff 4d 10             	decl   0x10(%ebp)
 18f:	ff 45 08             	incl   0x8(%ebp)
 192:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 195:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 199:	74 17                	je     1b2 <strncmp+0x2b>
 19b:	8b 45 08             	mov    0x8(%ebp),%eax
 19e:	8a 00                	mov    (%eax),%al
 1a0:	84 c0                	test   %al,%al
 1a2:	74 0e                	je     1b2 <strncmp+0x2b>
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	8a 10                	mov    (%eax),%dl
 1a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ac:	8a 00                	mov    (%eax),%al
 1ae:	38 c2                	cmp    %al,%dl
 1b0:	74 da                	je     18c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 1b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 1b6:	75 07                	jne    1bf <strncmp+0x38>
    return 0;
 1b8:	b8 00 00 00 00       	mov    $0x0,%eax
 1bd:	eb 14                	jmp    1d3 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 1bf:	8b 45 08             	mov    0x8(%ebp),%eax
 1c2:	8a 00                	mov    (%eax),%al
 1c4:	0f b6 d0             	movzbl %al,%edx
 1c7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ca:	8a 00                	mov    (%eax),%al
 1cc:	0f b6 c0             	movzbl %al,%eax
 1cf:	29 c2                	sub    %eax,%edx
 1d1:	89 d0                	mov    %edx,%eax
}
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    

000001d5 <strlen>:

uint
strlen(const char *s)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1db:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e2:	eb 03                	jmp    1e7 <strlen+0x12>
 1e4:	ff 45 fc             	incl   -0x4(%ebp)
 1e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ea:	8b 45 08             	mov    0x8(%ebp),%eax
 1ed:	01 d0                	add    %edx,%eax
 1ef:	8a 00                	mov    (%eax),%al
 1f1:	84 c0                	test   %al,%al
 1f3:	75 ef                	jne    1e4 <strlen+0xf>
    ;
  return n;
 1f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f8:	c9                   	leave  
 1f9:	c3                   	ret    

000001fa <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fa:	55                   	push   %ebp
 1fb:	89 e5                	mov    %esp,%ebp
 1fd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 200:	8b 45 10             	mov    0x10(%ebp),%eax
 203:	89 44 24 08          	mov    %eax,0x8(%esp)
 207:	8b 45 0c             	mov    0xc(%ebp),%eax
 20a:	89 44 24 04          	mov    %eax,0x4(%esp)
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	89 04 24             	mov    %eax,(%esp)
 214:	e8 e3 fe ff ff       	call   fc <stosb>
  return dst;
 219:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21c:	c9                   	leave  
 21d:	c3                   	ret    

0000021e <strchr>:

char*
strchr(const char *s, char c)
{
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	83 ec 04             	sub    $0x4,%esp
 224:	8b 45 0c             	mov    0xc(%ebp),%eax
 227:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22a:	eb 12                	jmp    23e <strchr+0x20>
    if(*s == c)
 22c:	8b 45 08             	mov    0x8(%ebp),%eax
 22f:	8a 00                	mov    (%eax),%al
 231:	3a 45 fc             	cmp    -0x4(%ebp),%al
 234:	75 05                	jne    23b <strchr+0x1d>
      return (char*)s;
 236:	8b 45 08             	mov    0x8(%ebp),%eax
 239:	eb 11                	jmp    24c <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23b:	ff 45 08             	incl   0x8(%ebp)
 23e:	8b 45 08             	mov    0x8(%ebp),%eax
 241:	8a 00                	mov    (%eax),%al
 243:	84 c0                	test   %al,%al
 245:	75 e5                	jne    22c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 247:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24c:	c9                   	leave  
 24d:	c3                   	ret    

0000024e <strcat>:

char *
strcat(char *dest, const char *src)
{
 24e:	55                   	push   %ebp
 24f:	89 e5                	mov    %esp,%ebp
 251:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 254:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 25b:	eb 03                	jmp    260 <strcat+0x12>
 25d:	ff 45 fc             	incl   -0x4(%ebp)
 260:	8b 55 fc             	mov    -0x4(%ebp),%edx
 263:	8b 45 08             	mov    0x8(%ebp),%eax
 266:	01 d0                	add    %edx,%eax
 268:	8a 00                	mov    (%eax),%al
 26a:	84 c0                	test   %al,%al
 26c:	75 ef                	jne    25d <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 26e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 275:	eb 1e                	jmp    295 <strcat+0x47>
        dest[i+j] = src[j];
 277:	8b 45 f8             	mov    -0x8(%ebp),%eax
 27a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 27d:	01 d0                	add    %edx,%eax
 27f:	89 c2                	mov    %eax,%edx
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	01 c2                	add    %eax,%edx
 286:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 289:	8b 45 0c             	mov    0xc(%ebp),%eax
 28c:	01 c8                	add    %ecx,%eax
 28e:	8a 00                	mov    (%eax),%al
 290:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 292:	ff 45 f8             	incl   -0x8(%ebp)
 295:	8b 55 f8             	mov    -0x8(%ebp),%edx
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	01 d0                	add    %edx,%eax
 29d:	8a 00                	mov    (%eax),%al
 29f:	84 c0                	test   %al,%al
 2a1:	75 d4                	jne    277 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 2a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2a6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2a9:	01 d0                	add    %edx,%eax
 2ab:	89 c2                	mov    %eax,%edx
 2ad:	8b 45 08             	mov    0x8(%ebp),%eax
 2b0:	01 d0                	add    %edx,%eax
 2b2:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b8:	c9                   	leave  
 2b9:	c3                   	ret    

000002ba <strstr>:

int 
strstr(char* s, char* sub)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 2c0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 2c7:	eb 7c                	jmp    345 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 2c9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2cc:	8b 45 08             	mov    0x8(%ebp),%eax
 2cf:	01 d0                	add    %edx,%eax
 2d1:	8a 10                	mov    (%eax),%dl
 2d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d6:	8a 00                	mov    (%eax),%al
 2d8:	38 c2                	cmp    %al,%dl
 2da:	75 66                	jne    342 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 2dc:	8b 45 0c             	mov    0xc(%ebp),%eax
 2df:	89 04 24             	mov    %eax,(%esp)
 2e2:	e8 ee fe ff ff       	call   1d5 <strlen>
 2e7:	83 f8 01             	cmp    $0x1,%eax
 2ea:	75 05                	jne    2f1 <strstr+0x37>
            {  
                return i;
 2ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2ef:	eb 6b                	jmp    35c <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 2f1:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 2f8:	eb 3a                	jmp    334 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 2fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2fd:	8b 55 fc             	mov    -0x4(%ebp),%edx
 300:	01 d0                	add    %edx,%eax
 302:	89 c2                	mov    %eax,%edx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	01 d0                	add    %edx,%eax
 309:	8a 10                	mov    (%eax),%dl
 30b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 30e:	8b 45 0c             	mov    0xc(%ebp),%eax
 311:	01 c8                	add    %ecx,%eax
 313:	8a 00                	mov    (%eax),%al
 315:	38 c2                	cmp    %al,%dl
 317:	75 16                	jne    32f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 319:	8b 45 f8             	mov    -0x8(%ebp),%eax
 31c:	8d 50 01             	lea    0x1(%eax),%edx
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	01 d0                	add    %edx,%eax
 324:	8a 00                	mov    (%eax),%al
 326:	84 c0                	test   %al,%al
 328:	75 07                	jne    331 <strstr+0x77>
                    {
                        return i;
 32a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 32d:	eb 2d                	jmp    35c <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 32f:	eb 11                	jmp    342 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 331:	ff 45 f8             	incl   -0x8(%ebp)
 334:	8b 55 f8             	mov    -0x8(%ebp),%edx
 337:	8b 45 0c             	mov    0xc(%ebp),%eax
 33a:	01 d0                	add    %edx,%eax
 33c:	8a 00                	mov    (%eax),%al
 33e:	84 c0                	test   %al,%al
 340:	75 b8                	jne    2fa <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 342:	ff 45 fc             	incl   -0x4(%ebp)
 345:	8b 55 fc             	mov    -0x4(%ebp),%edx
 348:	8b 45 08             	mov    0x8(%ebp),%eax
 34b:	01 d0                	add    %edx,%eax
 34d:	8a 00                	mov    (%eax),%al
 34f:	84 c0                	test   %al,%al
 351:	0f 85 72 ff ff ff    	jne    2c9 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 357:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <strtok>:

char *
strtok(char *s, const char *delim)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	53                   	push   %ebx
 362:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 365:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 369:	75 08                	jne    373 <strtok+0x15>
  s = lasts;
 36b:	a1 04 11 00 00       	mov    0x1104,%eax
 370:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 373:	8b 45 08             	mov    0x8(%ebp),%eax
 376:	8d 50 01             	lea    0x1(%eax),%edx
 379:	89 55 08             	mov    %edx,0x8(%ebp)
 37c:	8a 00                	mov    (%eax),%al
 37e:	0f be d8             	movsbl %al,%ebx
 381:	85 db                	test   %ebx,%ebx
 383:	75 07                	jne    38c <strtok+0x2e>
      return 0;
 385:	b8 00 00 00 00       	mov    $0x0,%eax
 38a:	eb 58                	jmp    3e4 <strtok+0x86>
    } while (strchr(delim, ch));
 38c:	88 d8                	mov    %bl,%al
 38e:	0f be c0             	movsbl %al,%eax
 391:	89 44 24 04          	mov    %eax,0x4(%esp)
 395:	8b 45 0c             	mov    0xc(%ebp),%eax
 398:	89 04 24             	mov    %eax,(%esp)
 39b:	e8 7e fe ff ff       	call   21e <strchr>
 3a0:	85 c0                	test   %eax,%eax
 3a2:	75 cf                	jne    373 <strtok+0x15>
    --s;
 3a4:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 3a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 3aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 3ae:	8b 45 08             	mov    0x8(%ebp),%eax
 3b1:	89 04 24             	mov    %eax,(%esp)
 3b4:	e8 31 00 00 00       	call   3ea <strcspn>
 3b9:	89 c2                	mov    %eax,%edx
 3bb:	8b 45 08             	mov    0x8(%ebp),%eax
 3be:	01 d0                	add    %edx,%eax
 3c0:	a3 04 11 00 00       	mov    %eax,0x1104
    if (*lasts != 0)
 3c5:	a1 04 11 00 00       	mov    0x1104,%eax
 3ca:	8a 00                	mov    (%eax),%al
 3cc:	84 c0                	test   %al,%al
 3ce:	74 11                	je     3e1 <strtok+0x83>
  *lasts++ = 0;
 3d0:	a1 04 11 00 00       	mov    0x1104,%eax
 3d5:	8d 50 01             	lea    0x1(%eax),%edx
 3d8:	89 15 04 11 00 00    	mov    %edx,0x1104
 3de:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 3e1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3e4:	83 c4 14             	add    $0x14,%esp
 3e7:	5b                   	pop    %ebx
 3e8:	5d                   	pop    %ebp
 3e9:	c3                   	ret    

000003ea <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 3ea:	55                   	push   %ebp
 3eb:	89 e5                	mov    %esp,%ebp
 3ed:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 3f0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 3f7:	eb 26                	jmp    41f <strcspn+0x35>
        if(strchr(s2,*s1))
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	8a 00                	mov    (%eax),%al
 3fe:	0f be c0             	movsbl %al,%eax
 401:	89 44 24 04          	mov    %eax,0x4(%esp)
 405:	8b 45 0c             	mov    0xc(%ebp),%eax
 408:	89 04 24             	mov    %eax,(%esp)
 40b:	e8 0e fe ff ff       	call   21e <strchr>
 410:	85 c0                	test   %eax,%eax
 412:	74 05                	je     419 <strcspn+0x2f>
            return ret;
 414:	8b 45 fc             	mov    -0x4(%ebp),%eax
 417:	eb 12                	jmp    42b <strcspn+0x41>
        else
            s1++,ret++;
 419:	ff 45 08             	incl   0x8(%ebp)
 41c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	8a 00                	mov    (%eax),%al
 424:	84 c0                	test   %al,%al
 426:	75 d1                	jne    3f9 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 428:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 42b:	c9                   	leave  
 42c:	c3                   	ret    

0000042d <isspace>:

int
isspace(unsigned char c)
{
 42d:	55                   	push   %ebp
 42e:	89 e5                	mov    %esp,%ebp
 430:	83 ec 04             	sub    $0x4,%esp
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 439:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 43d:	74 1e                	je     45d <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 43f:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 443:	74 18                	je     45d <isspace+0x30>
 445:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 449:	74 12                	je     45d <isspace+0x30>
 44b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 44f:	74 0c                	je     45d <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 451:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 455:	74 06                	je     45d <isspace+0x30>
 457:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 45b:	75 07                	jne    464 <isspace+0x37>
 45d:	b8 01 00 00 00       	mov    $0x1,%eax
 462:	eb 05                	jmp    469 <isspace+0x3c>
 464:	b8 00 00 00 00       	mov    $0x0,%eax
}
 469:	c9                   	leave  
 46a:	c3                   	ret    

0000046b <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 46b:	55                   	push   %ebp
 46c:	89 e5                	mov    %esp,%ebp
 46e:	57                   	push   %edi
 46f:	56                   	push   %esi
 470:	53                   	push   %ebx
 471:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 474:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 479:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 480:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 483:	eb 01                	jmp    486 <strtoul+0x1b>
  p += 1;
 485:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 486:	8a 03                	mov    (%ebx),%al
 488:	0f b6 c0             	movzbl %al,%eax
 48b:	89 04 24             	mov    %eax,(%esp)
 48e:	e8 9a ff ff ff       	call   42d <isspace>
 493:	85 c0                	test   %eax,%eax
 495:	75 ee                	jne    485 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 497:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 49b:	75 30                	jne    4cd <strtoul+0x62>
    {
  if (*p == '0') {
 49d:	8a 03                	mov    (%ebx),%al
 49f:	3c 30                	cmp    $0x30,%al
 4a1:	75 21                	jne    4c4 <strtoul+0x59>
      p += 1;
 4a3:	43                   	inc    %ebx
      if (*p == 'x') {
 4a4:	8a 03                	mov    (%ebx),%al
 4a6:	3c 78                	cmp    $0x78,%al
 4a8:	75 0a                	jne    4b4 <strtoul+0x49>
    p += 1;
 4aa:	43                   	inc    %ebx
    base = 16;
 4ab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 4b2:	eb 31                	jmp    4e5 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 4b4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 4bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 4c2:	eb 21                	jmp    4e5 <strtoul+0x7a>
      }
  }
  else base = 10;
 4c4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 4cb:	eb 18                	jmp    4e5 <strtoul+0x7a>
    } else if (base == 16) {
 4cd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 4d1:	75 12                	jne    4e5 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 4d3:	8a 03                	mov    (%ebx),%al
 4d5:	3c 30                	cmp    $0x30,%al
 4d7:	75 0c                	jne    4e5 <strtoul+0x7a>
 4d9:	8d 43 01             	lea    0x1(%ebx),%eax
 4dc:	8a 00                	mov    (%eax),%al
 4de:	3c 78                	cmp    $0x78,%al
 4e0:	75 03                	jne    4e5 <strtoul+0x7a>
      p += 2;
 4e2:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 4e5:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 4e9:	75 29                	jne    514 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 4eb:	8a 03                	mov    (%ebx),%al
 4ed:	0f be c0             	movsbl %al,%eax
 4f0:	83 e8 30             	sub    $0x30,%eax
 4f3:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 4f5:	83 fe 07             	cmp    $0x7,%esi
 4f8:	76 06                	jbe    500 <strtoul+0x95>
    break;
 4fa:	90                   	nop
 4fb:	e9 b6 00 00 00       	jmp    5b6 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 500:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 507:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 50a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 511:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 512:	eb d7                	jmp    4eb <strtoul+0x80>
    } else if (base == 10) {
 514:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 518:	75 2b                	jne    545 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 51a:	8a 03                	mov    (%ebx),%al
 51c:	0f be c0             	movsbl %al,%eax
 51f:	83 e8 30             	sub    $0x30,%eax
 522:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 524:	83 fe 09             	cmp    $0x9,%esi
 527:	76 06                	jbe    52f <strtoul+0xc4>
    break;
 529:	90                   	nop
 52a:	e9 87 00 00 00       	jmp    5b6 <strtoul+0x14b>
      }
      result = (10*result) + digit;
 52f:	89 f8                	mov    %edi,%eax
 531:	c1 e0 02             	shl    $0x2,%eax
 534:	01 f8                	add    %edi,%eax
 536:	01 c0                	add    %eax,%eax
 538:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 53b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 542:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 543:	eb d5                	jmp    51a <strtoul+0xaf>
    } else if (base == 16) {
 545:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 549:	75 35                	jne    580 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 54b:	8a 03                	mov    (%ebx),%al
 54d:	0f be c0             	movsbl %al,%eax
 550:	83 e8 30             	sub    $0x30,%eax
 553:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 555:	83 fe 4a             	cmp    $0x4a,%esi
 558:	76 02                	jbe    55c <strtoul+0xf1>
    break;
 55a:	eb 22                	jmp    57e <strtoul+0x113>
      }
      digit = cvtIn[digit];
 55c:	8a 86 a0 10 00 00    	mov    0x10a0(%esi),%al
 562:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 565:	83 fe 0f             	cmp    $0xf,%esi
 568:	76 02                	jbe    56c <strtoul+0x101>
    break;
 56a:	eb 12                	jmp    57e <strtoul+0x113>
      }
      result = (result << 4) + digit;
 56c:	89 f8                	mov    %edi,%eax
 56e:	c1 e0 04             	shl    $0x4,%eax
 571:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 574:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 57b:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 57c:	eb cd                	jmp    54b <strtoul+0xe0>
 57e:	eb 36                	jmp    5b6 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 580:	8a 03                	mov    (%ebx),%al
 582:	0f be c0             	movsbl %al,%eax
 585:	83 e8 30             	sub    $0x30,%eax
 588:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 58a:	83 fe 4a             	cmp    $0x4a,%esi
 58d:	76 02                	jbe    591 <strtoul+0x126>
    break;
 58f:	eb 25                	jmp    5b6 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 591:	8a 86 a0 10 00 00    	mov    0x10a0(%esi),%al
 597:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 59a:	8b 45 10             	mov    0x10(%ebp),%eax
 59d:	39 f0                	cmp    %esi,%eax
 59f:	77 02                	ja     5a3 <strtoul+0x138>
    break;
 5a1:	eb 13                	jmp    5b6 <strtoul+0x14b>
      }
      result = result*base + digit;
 5a3:	8b 45 10             	mov    0x10(%ebp),%eax
 5a6:	0f af c7             	imul   %edi,%eax
 5a9:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5ac:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 5b3:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 5b4:	eb ca                	jmp    580 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 5b6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5ba:	75 03                	jne    5bf <strtoul+0x154>
  p = string;
 5bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 5bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5c3:	74 05                	je     5ca <strtoul+0x15f>
  *endPtr = p;
 5c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c8:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 5ca:	89 f8                	mov    %edi,%eax
}
 5cc:	83 c4 14             	add    $0x14,%esp
 5cf:	5b                   	pop    %ebx
 5d0:	5e                   	pop    %esi
 5d1:	5f                   	pop    %edi
 5d2:	5d                   	pop    %ebp
 5d3:	c3                   	ret    

000005d4 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	53                   	push   %ebx
 5d8:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 5db:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 5de:	eb 01                	jmp    5e1 <strtol+0xd>
      p += 1;
 5e0:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 5e1:	8a 03                	mov    (%ebx),%al
 5e3:	0f b6 c0             	movzbl %al,%eax
 5e6:	89 04 24             	mov    %eax,(%esp)
 5e9:	e8 3f fe ff ff       	call   42d <isspace>
 5ee:	85 c0                	test   %eax,%eax
 5f0:	75 ee                	jne    5e0 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 5f2:	8a 03                	mov    (%ebx),%al
 5f4:	3c 2d                	cmp    $0x2d,%al
 5f6:	75 1e                	jne    616 <strtol+0x42>
  p += 1;
 5f8:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 5f9:	8b 45 10             	mov    0x10(%ebp),%eax
 5fc:	89 44 24 08          	mov    %eax,0x8(%esp)
 600:	8b 45 0c             	mov    0xc(%ebp),%eax
 603:	89 44 24 04          	mov    %eax,0x4(%esp)
 607:	89 1c 24             	mov    %ebx,(%esp)
 60a:	e8 5c fe ff ff       	call   46b <strtoul>
 60f:	f7 d8                	neg    %eax
 611:	89 45 f8             	mov    %eax,-0x8(%ebp)
 614:	eb 20                	jmp    636 <strtol+0x62>
    } else {
  if (*p == '+') {
 616:	8a 03                	mov    (%ebx),%al
 618:	3c 2b                	cmp    $0x2b,%al
 61a:	75 01                	jne    61d <strtol+0x49>
      p += 1;
 61c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 61d:	8b 45 10             	mov    0x10(%ebp),%eax
 620:	89 44 24 08          	mov    %eax,0x8(%esp)
 624:	8b 45 0c             	mov    0xc(%ebp),%eax
 627:	89 44 24 04          	mov    %eax,0x4(%esp)
 62b:	89 1c 24             	mov    %ebx,(%esp)
 62e:	e8 38 fe ff ff       	call   46b <strtoul>
 633:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 636:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 63a:	75 17                	jne    653 <strtol+0x7f>
 63c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 640:	74 11                	je     653 <strtol+0x7f>
 642:	8b 45 0c             	mov    0xc(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	39 d8                	cmp    %ebx,%eax
 649:	75 08                	jne    653 <strtol+0x7f>
  *endPtr = string;
 64b:	8b 45 0c             	mov    0xc(%ebp),%eax
 64e:	8b 55 08             	mov    0x8(%ebp),%edx
 651:	89 10                	mov    %edx,(%eax)
    }
    return result;
 653:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 656:	83 c4 1c             	add    $0x1c,%esp
 659:	5b                   	pop    %ebx
 65a:	5d                   	pop    %ebp
 65b:	c3                   	ret    

0000065c <gets>:

char*
gets(char *buf, int max)
{
 65c:	55                   	push   %ebp
 65d:	89 e5                	mov    %esp,%ebp
 65f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 662:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 669:	eb 49                	jmp    6b4 <gets+0x58>
    cc = read(0, &c, 1);
 66b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 672:	00 
 673:	8d 45 ef             	lea    -0x11(%ebp),%eax
 676:	89 44 24 04          	mov    %eax,0x4(%esp)
 67a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 681:	e8 3e 01 00 00       	call   7c4 <read>
 686:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 689:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 68d:	7f 02                	jg     691 <gets+0x35>
      break;
 68f:	eb 2c                	jmp    6bd <gets+0x61>
    buf[i++] = c;
 691:	8b 45 f4             	mov    -0xc(%ebp),%eax
 694:	8d 50 01             	lea    0x1(%eax),%edx
 697:	89 55 f4             	mov    %edx,-0xc(%ebp)
 69a:	89 c2                	mov    %eax,%edx
 69c:	8b 45 08             	mov    0x8(%ebp),%eax
 69f:	01 c2                	add    %eax,%edx
 6a1:	8a 45 ef             	mov    -0x11(%ebp),%al
 6a4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 6a6:	8a 45 ef             	mov    -0x11(%ebp),%al
 6a9:	3c 0a                	cmp    $0xa,%al
 6ab:	74 10                	je     6bd <gets+0x61>
 6ad:	8a 45 ef             	mov    -0x11(%ebp),%al
 6b0:	3c 0d                	cmp    $0xd,%al
 6b2:	74 09                	je     6bd <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b7:	40                   	inc    %eax
 6b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
 6bb:	7c ae                	jl     66b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 6bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 6c0:	8b 45 08             	mov    0x8(%ebp),%eax
 6c3:	01 d0                	add    %edx,%eax
 6c5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 6c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6cb:	c9                   	leave  
 6cc:	c3                   	ret    

000006cd <stat>:

int
stat(char *n, struct stat *st)
{
 6cd:	55                   	push   %ebp
 6ce:	89 e5                	mov    %esp,%ebp
 6d0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 6d3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 6da:	00 
 6db:	8b 45 08             	mov    0x8(%ebp),%eax
 6de:	89 04 24             	mov    %eax,(%esp)
 6e1:	e8 06 01 00 00       	call   7ec <open>
 6e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 6e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ed:	79 07                	jns    6f6 <stat+0x29>
    return -1;
 6ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 6f4:	eb 23                	jmp    719 <stat+0x4c>
  r = fstat(fd, st);
 6f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 700:	89 04 24             	mov    %eax,(%esp)
 703:	e8 fc 00 00 00       	call   804 <fstat>
 708:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 70b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70e:	89 04 24             	mov    %eax,(%esp)
 711:	e8 be 00 00 00       	call   7d4 <close>
  return r;
 716:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 719:	c9                   	leave  
 71a:	c3                   	ret    

0000071b <atoi>:

int
atoi(const char *s)
{
 71b:	55                   	push   %ebp
 71c:	89 e5                	mov    %esp,%ebp
 71e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 721:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 728:	eb 24                	jmp    74e <atoi+0x33>
    n = n*10 + *s++ - '0';
 72a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 72d:	89 d0                	mov    %edx,%eax
 72f:	c1 e0 02             	shl    $0x2,%eax
 732:	01 d0                	add    %edx,%eax
 734:	01 c0                	add    %eax,%eax
 736:	89 c1                	mov    %eax,%ecx
 738:	8b 45 08             	mov    0x8(%ebp),%eax
 73b:	8d 50 01             	lea    0x1(%eax),%edx
 73e:	89 55 08             	mov    %edx,0x8(%ebp)
 741:	8a 00                	mov    (%eax),%al
 743:	0f be c0             	movsbl %al,%eax
 746:	01 c8                	add    %ecx,%eax
 748:	83 e8 30             	sub    $0x30,%eax
 74b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 74e:	8b 45 08             	mov    0x8(%ebp),%eax
 751:	8a 00                	mov    (%eax),%al
 753:	3c 2f                	cmp    $0x2f,%al
 755:	7e 09                	jle    760 <atoi+0x45>
 757:	8b 45 08             	mov    0x8(%ebp),%eax
 75a:	8a 00                	mov    (%eax),%al
 75c:	3c 39                	cmp    $0x39,%al
 75e:	7e ca                	jle    72a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 763:	c9                   	leave  
 764:	c3                   	ret    

00000765 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 765:	55                   	push   %ebp
 766:	89 e5                	mov    %esp,%ebp
 768:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 76b:	8b 45 08             	mov    0x8(%ebp),%eax
 76e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 771:	8b 45 0c             	mov    0xc(%ebp),%eax
 774:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 777:	eb 16                	jmp    78f <memmove+0x2a>
    *dst++ = *src++;
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8d 50 01             	lea    0x1(%eax),%edx
 77f:	89 55 fc             	mov    %edx,-0x4(%ebp)
 782:	8b 55 f8             	mov    -0x8(%ebp),%edx
 785:	8d 4a 01             	lea    0x1(%edx),%ecx
 788:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 78b:	8a 12                	mov    (%edx),%dl
 78d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 78f:	8b 45 10             	mov    0x10(%ebp),%eax
 792:	8d 50 ff             	lea    -0x1(%eax),%edx
 795:	89 55 10             	mov    %edx,0x10(%ebp)
 798:	85 c0                	test   %eax,%eax
 79a:	7f dd                	jg     779 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 79c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 79f:	c9                   	leave  
 7a0:	c3                   	ret    
 7a1:	90                   	nop
 7a2:	90                   	nop
 7a3:	90                   	nop

000007a4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 7a4:	b8 01 00 00 00       	mov    $0x1,%eax
 7a9:	cd 40                	int    $0x40
 7ab:	c3                   	ret    

000007ac <exit>:
SYSCALL(exit)
 7ac:	b8 02 00 00 00       	mov    $0x2,%eax
 7b1:	cd 40                	int    $0x40
 7b3:	c3                   	ret    

000007b4 <wait>:
SYSCALL(wait)
 7b4:	b8 03 00 00 00       	mov    $0x3,%eax
 7b9:	cd 40                	int    $0x40
 7bb:	c3                   	ret    

000007bc <pipe>:
SYSCALL(pipe)
 7bc:	b8 04 00 00 00       	mov    $0x4,%eax
 7c1:	cd 40                	int    $0x40
 7c3:	c3                   	ret    

000007c4 <read>:
SYSCALL(read)
 7c4:	b8 05 00 00 00       	mov    $0x5,%eax
 7c9:	cd 40                	int    $0x40
 7cb:	c3                   	ret    

000007cc <write>:
SYSCALL(write)
 7cc:	b8 10 00 00 00       	mov    $0x10,%eax
 7d1:	cd 40                	int    $0x40
 7d3:	c3                   	ret    

000007d4 <close>:
SYSCALL(close)
 7d4:	b8 15 00 00 00       	mov    $0x15,%eax
 7d9:	cd 40                	int    $0x40
 7db:	c3                   	ret    

000007dc <kill>:
SYSCALL(kill)
 7dc:	b8 06 00 00 00       	mov    $0x6,%eax
 7e1:	cd 40                	int    $0x40
 7e3:	c3                   	ret    

000007e4 <exec>:
SYSCALL(exec)
 7e4:	b8 07 00 00 00       	mov    $0x7,%eax
 7e9:	cd 40                	int    $0x40
 7eb:	c3                   	ret    

000007ec <open>:
SYSCALL(open)
 7ec:	b8 0f 00 00 00       	mov    $0xf,%eax
 7f1:	cd 40                	int    $0x40
 7f3:	c3                   	ret    

000007f4 <mknod>:
SYSCALL(mknod)
 7f4:	b8 11 00 00 00       	mov    $0x11,%eax
 7f9:	cd 40                	int    $0x40
 7fb:	c3                   	ret    

000007fc <unlink>:
SYSCALL(unlink)
 7fc:	b8 12 00 00 00       	mov    $0x12,%eax
 801:	cd 40                	int    $0x40
 803:	c3                   	ret    

00000804 <fstat>:
SYSCALL(fstat)
 804:	b8 08 00 00 00       	mov    $0x8,%eax
 809:	cd 40                	int    $0x40
 80b:	c3                   	ret    

0000080c <link>:
SYSCALL(link)
 80c:	b8 13 00 00 00       	mov    $0x13,%eax
 811:	cd 40                	int    $0x40
 813:	c3                   	ret    

00000814 <mkdir>:
SYSCALL(mkdir)
 814:	b8 14 00 00 00       	mov    $0x14,%eax
 819:	cd 40                	int    $0x40
 81b:	c3                   	ret    

0000081c <chdir>:
SYSCALL(chdir)
 81c:	b8 09 00 00 00       	mov    $0x9,%eax
 821:	cd 40                	int    $0x40
 823:	c3                   	ret    

00000824 <dup>:
SYSCALL(dup)
 824:	b8 0a 00 00 00       	mov    $0xa,%eax
 829:	cd 40                	int    $0x40
 82b:	c3                   	ret    

0000082c <getpid>:
SYSCALL(getpid)
 82c:	b8 0b 00 00 00       	mov    $0xb,%eax
 831:	cd 40                	int    $0x40
 833:	c3                   	ret    

00000834 <sbrk>:
SYSCALL(sbrk)
 834:	b8 0c 00 00 00       	mov    $0xc,%eax
 839:	cd 40                	int    $0x40
 83b:	c3                   	ret    

0000083c <sleep>:
SYSCALL(sleep)
 83c:	b8 0d 00 00 00       	mov    $0xd,%eax
 841:	cd 40                	int    $0x40
 843:	c3                   	ret    

00000844 <uptime>:
SYSCALL(uptime)
 844:	b8 0e 00 00 00       	mov    $0xe,%eax
 849:	cd 40                	int    $0x40
 84b:	c3                   	ret    

0000084c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 84c:	55                   	push   %ebp
 84d:	89 e5                	mov    %esp,%ebp
 84f:	83 ec 18             	sub    $0x18,%esp
 852:	8b 45 0c             	mov    0xc(%ebp),%eax
 855:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 858:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 85f:	00 
 860:	8d 45 f4             	lea    -0xc(%ebp),%eax
 863:	89 44 24 04          	mov    %eax,0x4(%esp)
 867:	8b 45 08             	mov    0x8(%ebp),%eax
 86a:	89 04 24             	mov    %eax,(%esp)
 86d:	e8 5a ff ff ff       	call   7cc <write>
}
 872:	c9                   	leave  
 873:	c3                   	ret    

00000874 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 874:	55                   	push   %ebp
 875:	89 e5                	mov    %esp,%ebp
 877:	56                   	push   %esi
 878:	53                   	push   %ebx
 879:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 87c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 883:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 887:	74 17                	je     8a0 <printint+0x2c>
 889:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 88d:	79 11                	jns    8a0 <printint+0x2c>
    neg = 1;
 88f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 896:	8b 45 0c             	mov    0xc(%ebp),%eax
 899:	f7 d8                	neg    %eax
 89b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 89e:	eb 06                	jmp    8a6 <printint+0x32>
  } else {
    x = xx;
 8a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 8a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 8a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 8ad:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 8b0:	8d 41 01             	lea    0x1(%ecx),%eax
 8b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
 8b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8bc:	ba 00 00 00 00       	mov    $0x0,%edx
 8c1:	f7 f3                	div    %ebx
 8c3:	89 d0                	mov    %edx,%eax
 8c5:	8a 80 ec 10 00 00    	mov    0x10ec(%eax),%al
 8cb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 8cf:	8b 75 10             	mov    0x10(%ebp),%esi
 8d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d5:	ba 00 00 00 00       	mov    $0x0,%edx
 8da:	f7 f6                	div    %esi
 8dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 8df:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8e3:	75 c8                	jne    8ad <printint+0x39>
  if(neg)
 8e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8e9:	74 10                	je     8fb <printint+0x87>
    buf[i++] = '-';
 8eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ee:	8d 50 01             	lea    0x1(%eax),%edx
 8f1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8f4:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 8f9:	eb 1e                	jmp    919 <printint+0xa5>
 8fb:	eb 1c                	jmp    919 <printint+0xa5>
    putc(fd, buf[i]);
 8fd:	8d 55 dc             	lea    -0x24(%ebp),%edx
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	01 d0                	add    %edx,%eax
 905:	8a 00                	mov    (%eax),%al
 907:	0f be c0             	movsbl %al,%eax
 90a:	89 44 24 04          	mov    %eax,0x4(%esp)
 90e:	8b 45 08             	mov    0x8(%ebp),%eax
 911:	89 04 24             	mov    %eax,(%esp)
 914:	e8 33 ff ff ff       	call   84c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 919:	ff 4d f4             	decl   -0xc(%ebp)
 91c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 920:	79 db                	jns    8fd <printint+0x89>
    putc(fd, buf[i]);
}
 922:	83 c4 30             	add    $0x30,%esp
 925:	5b                   	pop    %ebx
 926:	5e                   	pop    %esi
 927:	5d                   	pop    %ebp
 928:	c3                   	ret    

00000929 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 929:	55                   	push   %ebp
 92a:	89 e5                	mov    %esp,%ebp
 92c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 92f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 936:	8d 45 0c             	lea    0xc(%ebp),%eax
 939:	83 c0 04             	add    $0x4,%eax
 93c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 93f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 946:	e9 77 01 00 00       	jmp    ac2 <printf+0x199>
    c = fmt[i] & 0xff;
 94b:	8b 55 0c             	mov    0xc(%ebp),%edx
 94e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 951:	01 d0                	add    %edx,%eax
 953:	8a 00                	mov    (%eax),%al
 955:	0f be c0             	movsbl %al,%eax
 958:	25 ff 00 00 00       	and    $0xff,%eax
 95d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 960:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 964:	75 2c                	jne    992 <printf+0x69>
      if(c == '%'){
 966:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 96a:	75 0c                	jne    978 <printf+0x4f>
        state = '%';
 96c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 973:	e9 47 01 00 00       	jmp    abf <printf+0x196>
      } else {
        putc(fd, c);
 978:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 97b:	0f be c0             	movsbl %al,%eax
 97e:	89 44 24 04          	mov    %eax,0x4(%esp)
 982:	8b 45 08             	mov    0x8(%ebp),%eax
 985:	89 04 24             	mov    %eax,(%esp)
 988:	e8 bf fe ff ff       	call   84c <putc>
 98d:	e9 2d 01 00 00       	jmp    abf <printf+0x196>
      }
    } else if(state == '%'){
 992:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 996:	0f 85 23 01 00 00    	jne    abf <printf+0x196>
      if(c == 'd'){
 99c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 9a0:	75 2d                	jne    9cf <printf+0xa6>
        printint(fd, *ap, 10, 1);
 9a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a5:	8b 00                	mov    (%eax),%eax
 9a7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 9ae:	00 
 9af:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 9b6:	00 
 9b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 9bb:	8b 45 08             	mov    0x8(%ebp),%eax
 9be:	89 04 24             	mov    %eax,(%esp)
 9c1:	e8 ae fe ff ff       	call   874 <printint>
        ap++;
 9c6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9ca:	e9 e9 00 00 00       	jmp    ab8 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 9cf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 9d3:	74 06                	je     9db <printf+0xb2>
 9d5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 9d9:	75 2d                	jne    a08 <printf+0xdf>
        printint(fd, *ap, 16, 0);
 9db:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9de:	8b 00                	mov    (%eax),%eax
 9e0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 9e7:	00 
 9e8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 9ef:	00 
 9f0:	89 44 24 04          	mov    %eax,0x4(%esp)
 9f4:	8b 45 08             	mov    0x8(%ebp),%eax
 9f7:	89 04 24             	mov    %eax,(%esp)
 9fa:	e8 75 fe ff ff       	call   874 <printint>
        ap++;
 9ff:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a03:	e9 b0 00 00 00       	jmp    ab8 <printf+0x18f>
      } else if(c == 's'){
 a08:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a0c:	75 42                	jne    a50 <printf+0x127>
        s = (char*)*ap;
 a0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a11:	8b 00                	mov    (%eax),%eax
 a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a16:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a1e:	75 09                	jne    a29 <printf+0x100>
          s = "(null)";
 a20:	c7 45 f4 32 0d 00 00 	movl   $0xd32,-0xc(%ebp)
        while(*s != 0){
 a27:	eb 1c                	jmp    a45 <printf+0x11c>
 a29:	eb 1a                	jmp    a45 <printf+0x11c>
          putc(fd, *s);
 a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2e:	8a 00                	mov    (%eax),%al
 a30:	0f be c0             	movsbl %al,%eax
 a33:	89 44 24 04          	mov    %eax,0x4(%esp)
 a37:	8b 45 08             	mov    0x8(%ebp),%eax
 a3a:	89 04 24             	mov    %eax,(%esp)
 a3d:	e8 0a fe ff ff       	call   84c <putc>
          s++;
 a42:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a48:	8a 00                	mov    (%eax),%al
 a4a:	84 c0                	test   %al,%al
 a4c:	75 dd                	jne    a2b <printf+0x102>
 a4e:	eb 68                	jmp    ab8 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 a50:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 a54:	75 1d                	jne    a73 <printf+0x14a>
        putc(fd, *ap);
 a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a59:	8b 00                	mov    (%eax),%eax
 a5b:	0f be c0             	movsbl %al,%eax
 a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
 a62:	8b 45 08             	mov    0x8(%ebp),%eax
 a65:	89 04 24             	mov    %eax,(%esp)
 a68:	e8 df fd ff ff       	call   84c <putc>
        ap++;
 a6d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a71:	eb 45                	jmp    ab8 <printf+0x18f>
      } else if(c == '%'){
 a73:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a77:	75 17                	jne    a90 <printf+0x167>
        putc(fd, c);
 a79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a7c:	0f be c0             	movsbl %al,%eax
 a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
 a83:	8b 45 08             	mov    0x8(%ebp),%eax
 a86:	89 04 24             	mov    %eax,(%esp)
 a89:	e8 be fd ff ff       	call   84c <putc>
 a8e:	eb 28                	jmp    ab8 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 a90:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 a97:	00 
 a98:	8b 45 08             	mov    0x8(%ebp),%eax
 a9b:	89 04 24             	mov    %eax,(%esp)
 a9e:	e8 a9 fd ff ff       	call   84c <putc>
        putc(fd, c);
 aa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 aa6:	0f be c0             	movsbl %al,%eax
 aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
 aad:	8b 45 08             	mov    0x8(%ebp),%eax
 ab0:	89 04 24             	mov    %eax,(%esp)
 ab3:	e8 94 fd ff ff       	call   84c <putc>
      }
      state = 0;
 ab8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 abf:	ff 45 f0             	incl   -0x10(%ebp)
 ac2:	8b 55 0c             	mov    0xc(%ebp),%edx
 ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ac8:	01 d0                	add    %edx,%eax
 aca:	8a 00                	mov    (%eax),%al
 acc:	84 c0                	test   %al,%al
 ace:	0f 85 77 fe ff ff    	jne    94b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 ad4:	c9                   	leave  
 ad5:	c3                   	ret    
 ad6:	90                   	nop
 ad7:	90                   	nop

00000ad8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ad8:	55                   	push   %ebp
 ad9:	89 e5                	mov    %esp,%ebp
 adb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 ade:	8b 45 08             	mov    0x8(%ebp),%eax
 ae1:	83 e8 08             	sub    $0x8,%eax
 ae4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ae7:	a1 10 11 00 00       	mov    0x1110,%eax
 aec:	89 45 fc             	mov    %eax,-0x4(%ebp)
 aef:	eb 24                	jmp    b15 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af4:	8b 00                	mov    (%eax),%eax
 af6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 af9:	77 12                	ja     b0d <free+0x35>
 afb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 afe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b01:	77 24                	ja     b27 <free+0x4f>
 b03:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b06:	8b 00                	mov    (%eax),%eax
 b08:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b0b:	77 1a                	ja     b27 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b10:	8b 00                	mov    (%eax),%eax
 b12:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b15:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b18:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b1b:	76 d4                	jbe    af1 <free+0x19>
 b1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b20:	8b 00                	mov    (%eax),%eax
 b22:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b25:	76 ca                	jbe    af1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 b27:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b2a:	8b 40 04             	mov    0x4(%eax),%eax
 b2d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b34:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b37:	01 c2                	add    %eax,%edx
 b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b3c:	8b 00                	mov    (%eax),%eax
 b3e:	39 c2                	cmp    %eax,%edx
 b40:	75 24                	jne    b66 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 b42:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b45:	8b 50 04             	mov    0x4(%eax),%edx
 b48:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b4b:	8b 00                	mov    (%eax),%eax
 b4d:	8b 40 04             	mov    0x4(%eax),%eax
 b50:	01 c2                	add    %eax,%edx
 b52:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b55:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 b58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b5b:	8b 00                	mov    (%eax),%eax
 b5d:	8b 10                	mov    (%eax),%edx
 b5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b62:	89 10                	mov    %edx,(%eax)
 b64:	eb 0a                	jmp    b70 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 b66:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b69:	8b 10                	mov    (%eax),%edx
 b6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b6e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 b70:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b73:	8b 40 04             	mov    0x4(%eax),%eax
 b76:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 b7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b80:	01 d0                	add    %edx,%eax
 b82:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 b85:	75 20                	jne    ba7 <free+0xcf>
    p->s.size += bp->s.size;
 b87:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b8a:	8b 50 04             	mov    0x4(%eax),%edx
 b8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b90:	8b 40 04             	mov    0x4(%eax),%eax
 b93:	01 c2                	add    %eax,%edx
 b95:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b98:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b9b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b9e:	8b 10                	mov    (%eax),%edx
 ba0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba3:	89 10                	mov    %edx,(%eax)
 ba5:	eb 08                	jmp    baf <free+0xd7>
  } else
    p->s.ptr = bp;
 ba7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 baa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 bad:	89 10                	mov    %edx,(%eax)
  freep = p;
 baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bb2:	a3 10 11 00 00       	mov    %eax,0x1110
}
 bb7:	c9                   	leave  
 bb8:	c3                   	ret    

00000bb9 <morecore>:

static Header*
morecore(uint nu)
{
 bb9:	55                   	push   %ebp
 bba:	89 e5                	mov    %esp,%ebp
 bbc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 bbf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 bc6:	77 07                	ja     bcf <morecore+0x16>
    nu = 4096;
 bc8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 bcf:	8b 45 08             	mov    0x8(%ebp),%eax
 bd2:	c1 e0 03             	shl    $0x3,%eax
 bd5:	89 04 24             	mov    %eax,(%esp)
 bd8:	e8 57 fc ff ff       	call   834 <sbrk>
 bdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 be0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 be4:	75 07                	jne    bed <morecore+0x34>
    return 0;
 be6:	b8 00 00 00 00       	mov    $0x0,%eax
 beb:	eb 22                	jmp    c0f <morecore+0x56>
  hp = (Header*)p;
 bed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf6:	8b 55 08             	mov    0x8(%ebp),%edx
 bf9:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bff:	83 c0 08             	add    $0x8,%eax
 c02:	89 04 24             	mov    %eax,(%esp)
 c05:	e8 ce fe ff ff       	call   ad8 <free>
  return freep;
 c0a:	a1 10 11 00 00       	mov    0x1110,%eax
}
 c0f:	c9                   	leave  
 c10:	c3                   	ret    

00000c11 <malloc>:

void*
malloc(uint nbytes)
{
 c11:	55                   	push   %ebp
 c12:	89 e5                	mov    %esp,%ebp
 c14:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c17:	8b 45 08             	mov    0x8(%ebp),%eax
 c1a:	83 c0 07             	add    $0x7,%eax
 c1d:	c1 e8 03             	shr    $0x3,%eax
 c20:	40                   	inc    %eax
 c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 c24:	a1 10 11 00 00       	mov    0x1110,%eax
 c29:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c2c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 c30:	75 23                	jne    c55 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 c32:	c7 45 f0 08 11 00 00 	movl   $0x1108,-0x10(%ebp)
 c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c3c:	a3 10 11 00 00       	mov    %eax,0x1110
 c41:	a1 10 11 00 00       	mov    0x1110,%eax
 c46:	a3 08 11 00 00       	mov    %eax,0x1108
    base.s.size = 0;
 c4b:	c7 05 0c 11 00 00 00 	movl   $0x0,0x110c
 c52:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c55:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c58:	8b 00                	mov    (%eax),%eax
 c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c60:	8b 40 04             	mov    0x4(%eax),%eax
 c63:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c66:	72 4d                	jb     cb5 <malloc+0xa4>
      if(p->s.size == nunits)
 c68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c6b:	8b 40 04             	mov    0x4(%eax),%eax
 c6e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 c71:	75 0c                	jne    c7f <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c76:	8b 10                	mov    (%eax),%edx
 c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c7b:	89 10                	mov    %edx,(%eax)
 c7d:	eb 26                	jmp    ca5 <malloc+0x94>
      else {
        p->s.size -= nunits;
 c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c82:	8b 40 04             	mov    0x4(%eax),%eax
 c85:	2b 45 ec             	sub    -0x14(%ebp),%eax
 c88:	89 c2                	mov    %eax,%edx
 c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c8d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c93:	8b 40 04             	mov    0x4(%eax),%eax
 c96:	c1 e0 03             	shl    $0x3,%eax
 c99:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 c9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c9f:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ca2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ca8:	a3 10 11 00 00       	mov    %eax,0x1110
      return (void*)(p + 1);
 cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cb0:	83 c0 08             	add    $0x8,%eax
 cb3:	eb 38                	jmp    ced <malloc+0xdc>
    }
    if(p == freep)
 cb5:	a1 10 11 00 00       	mov    0x1110,%eax
 cba:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 cbd:	75 1b                	jne    cda <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
 cc2:	89 04 24             	mov    %eax,(%esp)
 cc5:	e8 ef fe ff ff       	call   bb9 <morecore>
 cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ccd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 cd1:	75 07                	jne    cda <malloc+0xc9>
        return 0;
 cd3:	b8 00 00 00 00       	mov    $0x0,%eax
 cd8:	eb 13                	jmp    ced <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cda:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ce3:	8b 00                	mov    (%eax),%eax
 ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 ce8:	e9 70 ff ff ff       	jmp    c5d <malloc+0x4c>
}
 ced:	c9                   	leave  
 cee:	c3                   	ret    
