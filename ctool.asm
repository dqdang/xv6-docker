
_ctool:     file format elf32-i386


Disassembly of section .text:

00000000 <create>:
#include "types.h"
#include "stat.h"
#include "user.h"

int create(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 68             	sub    $0x68,%esp
  int i, id, fd;
  char *mkdir[2];
  mkdir[0] = "mkdir";
   6:	c7 45 e4 a4 0d 00 00 	movl   $0xda4,-0x1c(%ebp)
  mkdir[1] = argv[2];
   d:	8b 45 0c             	mov    0xc(%ebp),%eax
  10:	8b 40 08             	mov    0x8(%eax),%eax
  13:	89 45 e8             	mov    %eax,-0x18(%ebp)
  
  id = fork();
  16:	e8 3d 08 00 00       	call   858 <fork>
  1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(id == 0)
  1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  22:	75 12                	jne    36 <create+0x36>
  {
    exec(mkdir[0], mkdir);
  24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  27:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  2a:	89 54 24 04          	mov    %edx,0x4(%esp)
  2e:	89 04 24             	mov    %eax,(%esp)
  31:	e8 62 08 00 00       	call   898 <exec>
  }
  id = wait();
  36:	e8 2d 08 00 00       	call   868 <wait>
  3b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(i = 3; i < argc; i++) // going through ls echo cat ...
  3e:	c7 45 f4 03 00 00 00 	movl   $0x3,-0xc(%ebp)
  45:	e9 e2 00 00 00       	jmp    12c <create+0x12c>
  {
    id = fork();
  4a:	e8 09 08 00 00       	call   858 <fork>
  4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(id == 0)
  52:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  56:	0f 85 c5 00 00 00    	jne    121 <create+0x121>
    {
      char *executable[4];
      char destination[32];

      strcpy(destination, "/");
  5c:	c7 44 24 04 aa 0d 00 	movl   $0xdaa,0x4(%esp)
  63:	00 
  64:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  67:	89 04 24             	mov    %eax,(%esp)
  6a:	e8 66 01 00 00       	call   1d5 <strcpy>
      strcat(destination, mkdir[1]);
  6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  72:	89 44 24 04          	mov    %eax,0x4(%esp)
  76:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  79:	89 04 24             	mov    %eax,(%esp)
  7c:	e8 81 02 00 00       	call   302 <strcat>
      strcat(destination, "/");
  81:	c7 44 24 04 aa 0d 00 	movl   $0xdaa,0x4(%esp)
  88:	00 
  89:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  8c:	89 04 24             	mov    %eax,(%esp)
  8f:	e8 6e 02 00 00       	call   302 <strcat>
      strcat(destination, argv[i]);
  94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  97:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  a1:	01 d0                	add    %edx,%eax
  a3:	8b 00                	mov    (%eax),%eax
  a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  a9:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  ac:	89 04 24             	mov    %eax,(%esp)
  af:	e8 4e 02 00 00       	call   302 <strcat>
      strcat(destination, "\0");
  b4:	c7 44 24 04 ac 0d 00 	movl   $0xdac,0x4(%esp)
  bb:	00 
  bc:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  bf:	89 04 24             	mov    %eax,(%esp)
  c2:	e8 3b 02 00 00       	call   302 <strcat>

      executable[0] = "cat";
  c7:	c7 45 d4 ae 0d 00 00 	movl   $0xdae,-0x2c(%ebp)
      executable[1] = argv[i];
  ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  db:	01 d0                	add    %edx,%eax
  dd:	8b 00                	mov    (%eax),%eax
  df:	89 45 d8             	mov    %eax,-0x28(%ebp)

      fd = open(destination, O_CREATE | O_RDWR);
  e2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  e9:	00 
  ea:	8d 45 b4             	lea    -0x4c(%ebp),%eax
  ed:	89 04 24             	mov    %eax,(%esp)
  f0:	e8 ab 07 00 00       	call   8a0 <open>
  f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    
      close(1);
  f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ff:	e8 84 07 00 00       	call   888 <close>
      dup(fd);
 104:	8b 45 ec             	mov    -0x14(%ebp),%eax
 107:	89 04 24             	mov    %eax,(%esp)
 10a:	e8 c9 07 00 00       	call   8d8 <dup>
      exec(executable[0], executable);
 10f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 112:	8d 55 d4             	lea    -0x2c(%ebp),%edx
 115:	89 54 24 04          	mov    %edx,0x4(%esp)
 119:	89 04 24             	mov    %eax,(%esp)
 11c:	e8 77 07 00 00       	call   898 <exec>
    }
    id = wait();
 121:	e8 42 07 00 00       	call   868 <wait>
 126:	89 45 f0             	mov    %eax,-0x10(%ebp)
  {
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 3; i < argc; i++) // going through ls echo cat ...
 129:	ff 45 f4             	incl   -0xc(%ebp)
 12c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 12f:	3b 45 08             	cmp    0x8(%ebp),%eax
 132:	0f 8c 12 ff ff ff    	jl     4a <create+0x4a>
      exec(executable[0], executable);
    }
    id = wait();
  }

  return 0;
 138:	b8 00 00 00 00       	mov    $0x0,%eax
}
 13d:	c9                   	leave  
 13e:	c3                   	ret    

0000013f <main>:

int main(int argc, char *argv[])
{
 13f:	55                   	push   %ebp
 140:	89 e5                	mov    %esp,%ebp
 142:	83 e4 f0             	and    $0xfffffff0,%esp
 145:	83 ec 10             	sub    $0x10,%esp
  {
    // TODO:
    // print_usage();
  }

  if(strcmp(argv[1], "create") == 0)
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	83 c0 04             	add    $0x4,%eax
 14e:	8b 00                	mov    (%eax),%eax
 150:	c7 44 24 04 b2 0d 00 	movl   $0xdb2,0x4(%esp)
 157:	00 
 158:	89 04 24             	mov    %eax,(%esp)
 15b:	e8 a3 00 00 00       	call   203 <strcmp>
 160:	85 c0                	test   %eax,%eax
 162:	75 47                	jne    1ab <main+0x6c>
  {
    if(argc < 4)
 164:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
 168:	7e 41                	jle    1ab <main+0x6c>
      // TODO:
      // print_usage("create");
    }
    else
    {
      if(chdir(argv[2]) < 0)
 16a:	8b 45 0c             	mov    0xc(%ebp),%eax
 16d:	83 c0 08             	add    $0x8,%eax
 170:	8b 00                	mov    (%eax),%eax
 172:	89 04 24             	mov    %eax,(%esp)
 175:	e8 56 07 00 00       	call   8d0 <chdir>
 17a:	85 c0                	test   %eax,%eax
 17c:	79 14                	jns    192 <main+0x53>
      {
         create(argc, argv);
 17e:	8b 45 0c             	mov    0xc(%ebp),%eax
 181:	89 44 24 04          	mov    %eax,0x4(%esp)
 185:	8b 45 08             	mov    0x8(%ebp),%eax
 188:	89 04 24             	mov    %eax,(%esp)
 18b:	e8 70 fe ff ff       	call   0 <create>
 190:	eb 19                	jmp    1ab <main+0x6c>
      }
      else
      {
        printf(1, "This device already has a container's filesystem\n");
 192:	c7 44 24 04 bc 0d 00 	movl   $0xdbc,0x4(%esp)
 199:	00 
 19a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1a1:	e8 37 08 00 00       	call   9dd <printf>
        exit();
 1a6:	e8 b5 06 00 00       	call   860 <exit>
      }
    }
  }

  exit();
 1ab:	e8 b0 06 00 00       	call   860 <exit>

000001b0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b0:	55                   	push   %ebp
 1b1:	89 e5                	mov    %esp,%ebp
 1b3:	57                   	push   %edi
 1b4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1b8:	8b 55 10             	mov    0x10(%ebp),%edx
 1bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1be:	89 cb                	mov    %ecx,%ebx
 1c0:	89 df                	mov    %ebx,%edi
 1c2:	89 d1                	mov    %edx,%ecx
 1c4:	fc                   	cld    
 1c5:	f3 aa                	rep stos %al,%es:(%edi)
 1c7:	89 ca                	mov    %ecx,%edx
 1c9:	89 fb                	mov    %edi,%ebx
 1cb:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ce:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d1:	5b                   	pop    %ebx
 1d2:	5f                   	pop    %edi
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    

000001d5 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 1d5:	55                   	push   %ebp
 1d6:	89 e5                	mov    %esp,%ebp
 1d8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1db:	8b 45 08             	mov    0x8(%ebp),%eax
 1de:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e1:	90                   	nop
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	8d 50 01             	lea    0x1(%eax),%edx
 1e8:	89 55 08             	mov    %edx,0x8(%ebp)
 1eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 1ee:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f4:	8a 12                	mov    (%edx),%dl
 1f6:	88 10                	mov    %dl,(%eax)
 1f8:	8a 00                	mov    (%eax),%al
 1fa:	84 c0                	test   %al,%al
 1fc:	75 e4                	jne    1e2 <strcpy+0xd>
    ;
  return os;
 1fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 201:	c9                   	leave  
 202:	c3                   	ret    

00000203 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 203:	55                   	push   %ebp
 204:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 206:	eb 06                	jmp    20e <strcmp+0xb>
    p++, q++;
 208:	ff 45 08             	incl   0x8(%ebp)
 20b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 20e:	8b 45 08             	mov    0x8(%ebp),%eax
 211:	8a 00                	mov    (%eax),%al
 213:	84 c0                	test   %al,%al
 215:	74 0e                	je     225 <strcmp+0x22>
 217:	8b 45 08             	mov    0x8(%ebp),%eax
 21a:	8a 10                	mov    (%eax),%dl
 21c:	8b 45 0c             	mov    0xc(%ebp),%eax
 21f:	8a 00                	mov    (%eax),%al
 221:	38 c2                	cmp    %al,%dl
 223:	74 e3                	je     208 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	8a 00                	mov    (%eax),%al
 22a:	0f b6 d0             	movzbl %al,%edx
 22d:	8b 45 0c             	mov    0xc(%ebp),%eax
 230:	8a 00                	mov    (%eax),%al
 232:	0f b6 c0             	movzbl %al,%eax
 235:	29 c2                	sub    %eax,%edx
 237:	89 d0                	mov    %edx,%eax
}
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    

0000023b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 23e:	eb 09                	jmp    249 <strncmp+0xe>
    n--, p++, q++;
 240:	ff 4d 10             	decl   0x10(%ebp)
 243:	ff 45 08             	incl   0x8(%ebp)
 246:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 249:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 24d:	74 17                	je     266 <strncmp+0x2b>
 24f:	8b 45 08             	mov    0x8(%ebp),%eax
 252:	8a 00                	mov    (%eax),%al
 254:	84 c0                	test   %al,%al
 256:	74 0e                	je     266 <strncmp+0x2b>
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	8a 10                	mov    (%eax),%dl
 25d:	8b 45 0c             	mov    0xc(%ebp),%eax
 260:	8a 00                	mov    (%eax),%al
 262:	38 c2                	cmp    %al,%dl
 264:	74 da                	je     240 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 266:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 26a:	75 07                	jne    273 <strncmp+0x38>
    return 0;
 26c:	b8 00 00 00 00       	mov    $0x0,%eax
 271:	eb 14                	jmp    287 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 273:	8b 45 08             	mov    0x8(%ebp),%eax
 276:	8a 00                	mov    (%eax),%al
 278:	0f b6 d0             	movzbl %al,%edx
 27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 27e:	8a 00                	mov    (%eax),%al
 280:	0f b6 c0             	movzbl %al,%eax
 283:	29 c2                	sub    %eax,%edx
 285:	89 d0                	mov    %edx,%eax
}
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    

00000289 <strlen>:

uint
strlen(const char *s)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 28f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 296:	eb 03                	jmp    29b <strlen+0x12>
 298:	ff 45 fc             	incl   -0x4(%ebp)
 29b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 29e:	8b 45 08             	mov    0x8(%ebp),%eax
 2a1:	01 d0                	add    %edx,%eax
 2a3:	8a 00                	mov    (%eax),%al
 2a5:	84 c0                	test   %al,%al
 2a7:	75 ef                	jne    298 <strlen+0xf>
    ;
  return n;
 2a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2ac:	c9                   	leave  
 2ad:	c3                   	ret    

000002ae <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ae:	55                   	push   %ebp
 2af:	89 e5                	mov    %esp,%ebp
 2b1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
 2b7:	89 44 24 08          	mov    %eax,0x8(%esp)
 2bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2be:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c2:	8b 45 08             	mov    0x8(%ebp),%eax
 2c5:	89 04 24             	mov    %eax,(%esp)
 2c8:	e8 e3 fe ff ff       	call   1b0 <stosb>
  return dst;
 2cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d0:	c9                   	leave  
 2d1:	c3                   	ret    

000002d2 <strchr>:

char*
strchr(const char *s, char c)
{
 2d2:	55                   	push   %ebp
 2d3:	89 e5                	mov    %esp,%ebp
 2d5:	83 ec 04             	sub    $0x4,%esp
 2d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 2db:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2de:	eb 12                	jmp    2f2 <strchr+0x20>
    if(*s == c)
 2e0:	8b 45 08             	mov    0x8(%ebp),%eax
 2e3:	8a 00                	mov    (%eax),%al
 2e5:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2e8:	75 05                	jne    2ef <strchr+0x1d>
      return (char*)s;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
 2ed:	eb 11                	jmp    300 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 2ef:	ff 45 08             	incl   0x8(%ebp)
 2f2:	8b 45 08             	mov    0x8(%ebp),%eax
 2f5:	8a 00                	mov    (%eax),%al
 2f7:	84 c0                	test   %al,%al
 2f9:	75 e5                	jne    2e0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 2fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
 300:	c9                   	leave  
 301:	c3                   	ret    

00000302 <strcat>:

char *
strcat(char *dest, const char *src)
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 308:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 30f:	eb 03                	jmp    314 <strcat+0x12>
 311:	ff 45 fc             	incl   -0x4(%ebp)
 314:	8b 55 fc             	mov    -0x4(%ebp),%edx
 317:	8b 45 08             	mov    0x8(%ebp),%eax
 31a:	01 d0                	add    %edx,%eax
 31c:	8a 00                	mov    (%eax),%al
 31e:	84 c0                	test   %al,%al
 320:	75 ef                	jne    311 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 322:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 329:	eb 1e                	jmp    349 <strcat+0x47>
        dest[i+j] = src[j];
 32b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 32e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 331:	01 d0                	add    %edx,%eax
 333:	89 c2                	mov    %eax,%edx
 335:	8b 45 08             	mov    0x8(%ebp),%eax
 338:	01 c2                	add    %eax,%edx
 33a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 33d:	8b 45 0c             	mov    0xc(%ebp),%eax
 340:	01 c8                	add    %ecx,%eax
 342:	8a 00                	mov    (%eax),%al
 344:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 346:	ff 45 f8             	incl   -0x8(%ebp)
 349:	8b 55 f8             	mov    -0x8(%ebp),%edx
 34c:	8b 45 0c             	mov    0xc(%ebp),%eax
 34f:	01 d0                	add    %edx,%eax
 351:	8a 00                	mov    (%eax),%al
 353:	84 c0                	test   %al,%al
 355:	75 d4                	jne    32b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 357:	8b 45 f8             	mov    -0x8(%ebp),%eax
 35a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 35d:	01 d0                	add    %edx,%eax
 35f:	89 c2                	mov    %eax,%edx
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	01 d0                	add    %edx,%eax
 366:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 369:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36c:	c9                   	leave  
 36d:	c3                   	ret    

0000036e <strstr>:

int 
strstr(char* s, char* sub)
{
 36e:	55                   	push   %ebp
 36f:	89 e5                	mov    %esp,%ebp
 371:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 374:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 37b:	eb 7c                	jmp    3f9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 37d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 380:	8b 45 08             	mov    0x8(%ebp),%eax
 383:	01 d0                	add    %edx,%eax
 385:	8a 10                	mov    (%eax),%dl
 387:	8b 45 0c             	mov    0xc(%ebp),%eax
 38a:	8a 00                	mov    (%eax),%al
 38c:	38 c2                	cmp    %al,%dl
 38e:	75 66                	jne    3f6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 390:	8b 45 0c             	mov    0xc(%ebp),%eax
 393:	89 04 24             	mov    %eax,(%esp)
 396:	e8 ee fe ff ff       	call   289 <strlen>
 39b:	83 f8 01             	cmp    $0x1,%eax
 39e:	75 05                	jne    3a5 <strstr+0x37>
            {  
                return i;
 3a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3a3:	eb 6b                	jmp    410 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 3a5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 3ac:	eb 3a                	jmp    3e8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 3ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3b1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3b4:	01 d0                	add    %edx,%eax
 3b6:	89 c2                	mov    %eax,%edx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	01 d0                	add    %edx,%eax
 3bd:	8a 10                	mov    (%eax),%dl
 3bf:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 3c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c5:	01 c8                	add    %ecx,%eax
 3c7:	8a 00                	mov    (%eax),%al
 3c9:	38 c2                	cmp    %al,%dl
 3cb:	75 16                	jne    3e3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 3cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3d0:	8d 50 01             	lea    0x1(%eax),%edx
 3d3:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d6:	01 d0                	add    %edx,%eax
 3d8:	8a 00                	mov    (%eax),%al
 3da:	84 c0                	test   %al,%al
 3dc:	75 07                	jne    3e5 <strstr+0x77>
                    {
                        return i;
 3de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3e1:	eb 2d                	jmp    410 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 3e3:	eb 11                	jmp    3f6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 3e5:	ff 45 f8             	incl   -0x8(%ebp)
 3e8:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ee:	01 d0                	add    %edx,%eax
 3f0:	8a 00                	mov    (%eax),%al
 3f2:	84 c0                	test   %al,%al
 3f4:	75 b8                	jne    3ae <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 3f6:	ff 45 fc             	incl   -0x4(%ebp)
 3f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3fc:	8b 45 08             	mov    0x8(%ebp),%eax
 3ff:	01 d0                	add    %edx,%eax
 401:	8a 00                	mov    (%eax),%al
 403:	84 c0                	test   %al,%al
 405:	0f 85 72 ff ff ff    	jne    37d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 40b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 410:	c9                   	leave  
 411:	c3                   	ret    

00000412 <strtok>:

char *
strtok(char *s, const char *delim)
{
 412:	55                   	push   %ebp
 413:	89 e5                	mov    %esp,%ebp
 415:	53                   	push   %ebx
 416:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 41d:	75 08                	jne    427 <strtok+0x15>
  s = lasts;
 41f:	a1 e4 11 00 00       	mov    0x11e4,%eax
 424:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	8d 50 01             	lea    0x1(%eax),%edx
 42d:	89 55 08             	mov    %edx,0x8(%ebp)
 430:	8a 00                	mov    (%eax),%al
 432:	0f be d8             	movsbl %al,%ebx
 435:	85 db                	test   %ebx,%ebx
 437:	75 07                	jne    440 <strtok+0x2e>
      return 0;
 439:	b8 00 00 00 00       	mov    $0x0,%eax
 43e:	eb 58                	jmp    498 <strtok+0x86>
    } while (strchr(delim, ch));
 440:	88 d8                	mov    %bl,%al
 442:	0f be c0             	movsbl %al,%eax
 445:	89 44 24 04          	mov    %eax,0x4(%esp)
 449:	8b 45 0c             	mov    0xc(%ebp),%eax
 44c:	89 04 24             	mov    %eax,(%esp)
 44f:	e8 7e fe ff ff       	call   2d2 <strchr>
 454:	85 c0                	test   %eax,%eax
 456:	75 cf                	jne    427 <strtok+0x15>
    --s;
 458:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 45b:	8b 45 0c             	mov    0xc(%ebp),%eax
 45e:	89 44 24 04          	mov    %eax,0x4(%esp)
 462:	8b 45 08             	mov    0x8(%ebp),%eax
 465:	89 04 24             	mov    %eax,(%esp)
 468:	e8 31 00 00 00       	call   49e <strcspn>
 46d:	89 c2                	mov    %eax,%edx
 46f:	8b 45 08             	mov    0x8(%ebp),%eax
 472:	01 d0                	add    %edx,%eax
 474:	a3 e4 11 00 00       	mov    %eax,0x11e4
    if (*lasts != 0)
 479:	a1 e4 11 00 00       	mov    0x11e4,%eax
 47e:	8a 00                	mov    (%eax),%al
 480:	84 c0                	test   %al,%al
 482:	74 11                	je     495 <strtok+0x83>
  *lasts++ = 0;
 484:	a1 e4 11 00 00       	mov    0x11e4,%eax
 489:	8d 50 01             	lea    0x1(%eax),%edx
 48c:	89 15 e4 11 00 00    	mov    %edx,0x11e4
 492:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 495:	8b 45 08             	mov    0x8(%ebp),%eax
}
 498:	83 c4 14             	add    $0x14,%esp
 49b:	5b                   	pop    %ebx
 49c:	5d                   	pop    %ebp
 49d:	c3                   	ret    

0000049e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 49e:	55                   	push   %ebp
 49f:	89 e5                	mov    %esp,%ebp
 4a1:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 4a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 4ab:	eb 26                	jmp    4d3 <strcspn+0x35>
        if(strchr(s2,*s1))
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	8a 00                	mov    (%eax),%al
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	89 44 24 04          	mov    %eax,0x4(%esp)
 4b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 4bc:	89 04 24             	mov    %eax,(%esp)
 4bf:	e8 0e fe ff ff       	call   2d2 <strchr>
 4c4:	85 c0                	test   %eax,%eax
 4c6:	74 05                	je     4cd <strcspn+0x2f>
            return ret;
 4c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 4cb:	eb 12                	jmp    4df <strcspn+0x41>
        else
            s1++,ret++;
 4cd:	ff 45 08             	incl   0x8(%ebp)
 4d0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	8a 00                	mov    (%eax),%al
 4d8:	84 c0                	test   %al,%al
 4da:	75 d1                	jne    4ad <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 4dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4df:	c9                   	leave  
 4e0:	c3                   	ret    

000004e1 <isspace>:

int
isspace(unsigned char c)
{
 4e1:	55                   	push   %ebp
 4e2:	89 e5                	mov    %esp,%ebp
 4e4:	83 ec 04             	sub    $0x4,%esp
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 4ed:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 4f1:	74 1e                	je     511 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 4f3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 4f7:	74 18                	je     511 <isspace+0x30>
 4f9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 4fd:	74 12                	je     511 <isspace+0x30>
 4ff:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 503:	74 0c                	je     511 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 505:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 509:	74 06                	je     511 <isspace+0x30>
 50b:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 50f:	75 07                	jne    518 <isspace+0x37>
 511:	b8 01 00 00 00       	mov    $0x1,%eax
 516:	eb 05                	jmp    51d <isspace+0x3c>
 518:	b8 00 00 00 00       	mov    $0x0,%eax
}
 51d:	c9                   	leave  
 51e:	c3                   	ret    

0000051f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	57                   	push   %edi
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
 525:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 528:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 52d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 534:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 537:	eb 01                	jmp    53a <strtoul+0x1b>
  p += 1;
 539:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 53a:	8a 03                	mov    (%ebx),%al
 53c:	0f b6 c0             	movzbl %al,%eax
 53f:	89 04 24             	mov    %eax,(%esp)
 542:	e8 9a ff ff ff       	call   4e1 <isspace>
 547:	85 c0                	test   %eax,%eax
 549:	75 ee                	jne    539 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 54b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 54f:	75 30                	jne    581 <strtoul+0x62>
    {
  if (*p == '0') {
 551:	8a 03                	mov    (%ebx),%al
 553:	3c 30                	cmp    $0x30,%al
 555:	75 21                	jne    578 <strtoul+0x59>
      p += 1;
 557:	43                   	inc    %ebx
      if (*p == 'x') {
 558:	8a 03                	mov    (%ebx),%al
 55a:	3c 78                	cmp    $0x78,%al
 55c:	75 0a                	jne    568 <strtoul+0x49>
    p += 1;
 55e:	43                   	inc    %ebx
    base = 16;
 55f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 566:	eb 31                	jmp    599 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 568:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 56f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 576:	eb 21                	jmp    599 <strtoul+0x7a>
      }
  }
  else base = 10;
 578:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 57f:	eb 18                	jmp    599 <strtoul+0x7a>
    } else if (base == 16) {
 581:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 585:	75 12                	jne    599 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 587:	8a 03                	mov    (%ebx),%al
 589:	3c 30                	cmp    $0x30,%al
 58b:	75 0c                	jne    599 <strtoul+0x7a>
 58d:	8d 43 01             	lea    0x1(%ebx),%eax
 590:	8a 00                	mov    (%eax),%al
 592:	3c 78                	cmp    $0x78,%al
 594:	75 03                	jne    599 <strtoul+0x7a>
      p += 2;
 596:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 599:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 59d:	75 29                	jne    5c8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 59f:	8a 03                	mov    (%ebx),%al
 5a1:	0f be c0             	movsbl %al,%eax
 5a4:	83 e8 30             	sub    $0x30,%eax
 5a7:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 5a9:	83 fe 07             	cmp    $0x7,%esi
 5ac:	76 06                	jbe    5b4 <strtoul+0x95>
    break;
 5ae:	90                   	nop
 5af:	e9 b6 00 00 00       	jmp    66a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 5b4:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 5bb:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5be:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 5c5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 5c6:	eb d7                	jmp    59f <strtoul+0x80>
    } else if (base == 10) {
 5c8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 5cc:	75 2b                	jne    5f9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5ce:	8a 03                	mov    (%ebx),%al
 5d0:	0f be c0             	movsbl %al,%eax
 5d3:	83 e8 30             	sub    $0x30,%eax
 5d6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 5d8:	83 fe 09             	cmp    $0x9,%esi
 5db:	76 06                	jbe    5e3 <strtoul+0xc4>
    break;
 5dd:	90                   	nop
 5de:	e9 87 00 00 00       	jmp    66a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 5e3:	89 f8                	mov    %edi,%eax
 5e5:	c1 e0 02             	shl    $0x2,%eax
 5e8:	01 f8                	add    %edi,%eax
 5ea:	01 c0                	add    %eax,%eax
 5ec:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 5ef:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 5f6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 5f7:	eb d5                	jmp    5ce <strtoul+0xaf>
    } else if (base == 16) {
 5f9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 5fd:	75 35                	jne    634 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 5ff:	8a 03                	mov    (%ebx),%al
 601:	0f be c0             	movsbl %al,%eax
 604:	83 e8 30             	sub    $0x30,%eax
 607:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 609:	83 fe 4a             	cmp    $0x4a,%esi
 60c:	76 02                	jbe    610 <strtoul+0xf1>
    break;
 60e:	eb 22                	jmp    632 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 610:	8a 86 80 11 00 00    	mov    0x1180(%esi),%al
 616:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 619:	83 fe 0f             	cmp    $0xf,%esi
 61c:	76 02                	jbe    620 <strtoul+0x101>
    break;
 61e:	eb 12                	jmp    632 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 620:	89 f8                	mov    %edi,%eax
 622:	c1 e0 04             	shl    $0x4,%eax
 625:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 628:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 62f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 630:	eb cd                	jmp    5ff <strtoul+0xe0>
 632:	eb 36                	jmp    66a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 634:	8a 03                	mov    (%ebx),%al
 636:	0f be c0             	movsbl %al,%eax
 639:	83 e8 30             	sub    $0x30,%eax
 63c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 63e:	83 fe 4a             	cmp    $0x4a,%esi
 641:	76 02                	jbe    645 <strtoul+0x126>
    break;
 643:	eb 25                	jmp    66a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 645:	8a 86 80 11 00 00    	mov    0x1180(%esi),%al
 64b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 64e:	8b 45 10             	mov    0x10(%ebp),%eax
 651:	39 f0                	cmp    %esi,%eax
 653:	77 02                	ja     657 <strtoul+0x138>
    break;
 655:	eb 13                	jmp    66a <strtoul+0x14b>
      }
      result = result*base + digit;
 657:	8b 45 10             	mov    0x10(%ebp),%eax
 65a:	0f af c7             	imul   %edi,%eax
 65d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 660:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 667:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 668:	eb ca                	jmp    634 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 66a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 66e:	75 03                	jne    673 <strtoul+0x154>
  p = string;
 670:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 673:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 677:	74 05                	je     67e <strtoul+0x15f>
  *endPtr = p;
 679:	8b 45 0c             	mov    0xc(%ebp),%eax
 67c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 67e:	89 f8                	mov    %edi,%eax
}
 680:	83 c4 14             	add    $0x14,%esp
 683:	5b                   	pop    %ebx
 684:	5e                   	pop    %esi
 685:	5f                   	pop    %edi
 686:	5d                   	pop    %ebp
 687:	c3                   	ret    

00000688 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 688:	55                   	push   %ebp
 689:	89 e5                	mov    %esp,%ebp
 68b:	53                   	push   %ebx
 68c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 68f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 692:	eb 01                	jmp    695 <strtol+0xd>
      p += 1;
 694:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 695:	8a 03                	mov    (%ebx),%al
 697:	0f b6 c0             	movzbl %al,%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 3f fe ff ff       	call   4e1 <isspace>
 6a2:	85 c0                	test   %eax,%eax
 6a4:	75 ee                	jne    694 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 6a6:	8a 03                	mov    (%ebx),%al
 6a8:	3c 2d                	cmp    $0x2d,%al
 6aa:	75 1e                	jne    6ca <strtol+0x42>
  p += 1;
 6ac:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 6ad:	8b 45 10             	mov    0x10(%ebp),%eax
 6b0:	89 44 24 08          	mov    %eax,0x8(%esp)
 6b4:	8b 45 0c             	mov    0xc(%ebp),%eax
 6b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bb:	89 1c 24             	mov    %ebx,(%esp)
 6be:	e8 5c fe ff ff       	call   51f <strtoul>
 6c3:	f7 d8                	neg    %eax
 6c5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 6c8:	eb 20                	jmp    6ea <strtol+0x62>
    } else {
  if (*p == '+') {
 6ca:	8a 03                	mov    (%ebx),%al
 6cc:	3c 2b                	cmp    $0x2b,%al
 6ce:	75 01                	jne    6d1 <strtol+0x49>
      p += 1;
 6d0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 6d1:	8b 45 10             	mov    0x10(%ebp),%eax
 6d4:	89 44 24 08          	mov    %eax,0x8(%esp)
 6d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 6db:	89 44 24 04          	mov    %eax,0x4(%esp)
 6df:	89 1c 24             	mov    %ebx,(%esp)
 6e2:	e8 38 fe ff ff       	call   51f <strtoul>
 6e7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 6ea:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 6ee:	75 17                	jne    707 <strtol+0x7f>
 6f0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 6f4:	74 11                	je     707 <strtol+0x7f>
 6f6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6f9:	8b 00                	mov    (%eax),%eax
 6fb:	39 d8                	cmp    %ebx,%eax
 6fd:	75 08                	jne    707 <strtol+0x7f>
  *endPtr = string;
 6ff:	8b 45 0c             	mov    0xc(%ebp),%eax
 702:	8b 55 08             	mov    0x8(%ebp),%edx
 705:	89 10                	mov    %edx,(%eax)
    }
    return result;
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 70a:	83 c4 1c             	add    $0x1c,%esp
 70d:	5b                   	pop    %ebx
 70e:	5d                   	pop    %ebp
 70f:	c3                   	ret    

00000710 <gets>:

char*
gets(char *buf, int max)
{
 710:	55                   	push   %ebp
 711:	89 e5                	mov    %esp,%ebp
 713:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 716:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 71d:	eb 49                	jmp    768 <gets+0x58>
    cc = read(0, &c, 1);
 71f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 726:	00 
 727:	8d 45 ef             	lea    -0x11(%ebp),%eax
 72a:	89 44 24 04          	mov    %eax,0x4(%esp)
 72e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 735:	e8 3e 01 00 00       	call   878 <read>
 73a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 73d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 741:	7f 02                	jg     745 <gets+0x35>
      break;
 743:	eb 2c                	jmp    771 <gets+0x61>
    buf[i++] = c;
 745:	8b 45 f4             	mov    -0xc(%ebp),%eax
 748:	8d 50 01             	lea    0x1(%eax),%edx
 74b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 74e:	89 c2                	mov    %eax,%edx
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	01 c2                	add    %eax,%edx
 755:	8a 45 ef             	mov    -0x11(%ebp),%al
 758:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 75a:	8a 45 ef             	mov    -0x11(%ebp),%al
 75d:	3c 0a                	cmp    $0xa,%al
 75f:	74 10                	je     771 <gets+0x61>
 761:	8a 45 ef             	mov    -0x11(%ebp),%al
 764:	3c 0d                	cmp    $0xd,%al
 766:	74 09                	je     771 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 768:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76b:	40                   	inc    %eax
 76c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 76f:	7c ae                	jl     71f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 771:	8b 55 f4             	mov    -0xc(%ebp),%edx
 774:	8b 45 08             	mov    0x8(%ebp),%eax
 777:	01 d0                	add    %edx,%eax
 779:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 77c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 77f:	c9                   	leave  
 780:	c3                   	ret    

00000781 <stat>:

int
stat(char *n, struct stat *st)
{
 781:	55                   	push   %ebp
 782:	89 e5                	mov    %esp,%ebp
 784:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 787:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 78e:	00 
 78f:	8b 45 08             	mov    0x8(%ebp),%eax
 792:	89 04 24             	mov    %eax,(%esp)
 795:	e8 06 01 00 00       	call   8a0 <open>
 79a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 79d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7a1:	79 07                	jns    7aa <stat+0x29>
    return -1;
 7a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 7a8:	eb 23                	jmp    7cd <stat+0x4c>
  r = fstat(fd, st);
 7aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b4:	89 04 24             	mov    %eax,(%esp)
 7b7:	e8 fc 00 00 00       	call   8b8 <fstat>
 7bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c2:	89 04 24             	mov    %eax,(%esp)
 7c5:	e8 be 00 00 00       	call   888 <close>
  return r;
 7ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 7cd:	c9                   	leave  
 7ce:	c3                   	ret    

000007cf <atoi>:

int
atoi(const char *s)
{
 7cf:	55                   	push   %ebp
 7d0:	89 e5                	mov    %esp,%ebp
 7d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7dc:	eb 24                	jmp    802 <atoi+0x33>
    n = n*10 + *s++ - '0';
 7de:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7e1:	89 d0                	mov    %edx,%eax
 7e3:	c1 e0 02             	shl    $0x2,%eax
 7e6:	01 d0                	add    %edx,%eax
 7e8:	01 c0                	add    %eax,%eax
 7ea:	89 c1                	mov    %eax,%ecx
 7ec:	8b 45 08             	mov    0x8(%ebp),%eax
 7ef:	8d 50 01             	lea    0x1(%eax),%edx
 7f2:	89 55 08             	mov    %edx,0x8(%ebp)
 7f5:	8a 00                	mov    (%eax),%al
 7f7:	0f be c0             	movsbl %al,%eax
 7fa:	01 c8                	add    %ecx,%eax
 7fc:	83 e8 30             	sub    $0x30,%eax
 7ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 802:	8b 45 08             	mov    0x8(%ebp),%eax
 805:	8a 00                	mov    (%eax),%al
 807:	3c 2f                	cmp    $0x2f,%al
 809:	7e 09                	jle    814 <atoi+0x45>
 80b:	8b 45 08             	mov    0x8(%ebp),%eax
 80e:	8a 00                	mov    (%eax),%al
 810:	3c 39                	cmp    $0x39,%al
 812:	7e ca                	jle    7de <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 817:	c9                   	leave  
 818:	c3                   	ret    

00000819 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 819:	55                   	push   %ebp
 81a:	89 e5                	mov    %esp,%ebp
 81c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 81f:	8b 45 08             	mov    0x8(%ebp),%eax
 822:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 825:	8b 45 0c             	mov    0xc(%ebp),%eax
 828:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 82b:	eb 16                	jmp    843 <memmove+0x2a>
    *dst++ = *src++;
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8d 50 01             	lea    0x1(%eax),%edx
 833:	89 55 fc             	mov    %edx,-0x4(%ebp)
 836:	8b 55 f8             	mov    -0x8(%ebp),%edx
 839:	8d 4a 01             	lea    0x1(%edx),%ecx
 83c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 83f:	8a 12                	mov    (%edx),%dl
 841:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 843:	8b 45 10             	mov    0x10(%ebp),%eax
 846:	8d 50 ff             	lea    -0x1(%eax),%edx
 849:	89 55 10             	mov    %edx,0x10(%ebp)
 84c:	85 c0                	test   %eax,%eax
 84e:	7f dd                	jg     82d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 850:	8b 45 08             	mov    0x8(%ebp),%eax
}
 853:	c9                   	leave  
 854:	c3                   	ret    
 855:	90                   	nop
 856:	90                   	nop
 857:	90                   	nop

00000858 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 858:	b8 01 00 00 00       	mov    $0x1,%eax
 85d:	cd 40                	int    $0x40
 85f:	c3                   	ret    

00000860 <exit>:
SYSCALL(exit)
 860:	b8 02 00 00 00       	mov    $0x2,%eax
 865:	cd 40                	int    $0x40
 867:	c3                   	ret    

00000868 <wait>:
SYSCALL(wait)
 868:	b8 03 00 00 00       	mov    $0x3,%eax
 86d:	cd 40                	int    $0x40
 86f:	c3                   	ret    

00000870 <pipe>:
SYSCALL(pipe)
 870:	b8 04 00 00 00       	mov    $0x4,%eax
 875:	cd 40                	int    $0x40
 877:	c3                   	ret    

00000878 <read>:
SYSCALL(read)
 878:	b8 05 00 00 00       	mov    $0x5,%eax
 87d:	cd 40                	int    $0x40
 87f:	c3                   	ret    

00000880 <write>:
SYSCALL(write)
 880:	b8 10 00 00 00       	mov    $0x10,%eax
 885:	cd 40                	int    $0x40
 887:	c3                   	ret    

00000888 <close>:
SYSCALL(close)
 888:	b8 15 00 00 00       	mov    $0x15,%eax
 88d:	cd 40                	int    $0x40
 88f:	c3                   	ret    

00000890 <kill>:
SYSCALL(kill)
 890:	b8 06 00 00 00       	mov    $0x6,%eax
 895:	cd 40                	int    $0x40
 897:	c3                   	ret    

00000898 <exec>:
SYSCALL(exec)
 898:	b8 07 00 00 00       	mov    $0x7,%eax
 89d:	cd 40                	int    $0x40
 89f:	c3                   	ret    

000008a0 <open>:
SYSCALL(open)
 8a0:	b8 0f 00 00 00       	mov    $0xf,%eax
 8a5:	cd 40                	int    $0x40
 8a7:	c3                   	ret    

000008a8 <mknod>:
SYSCALL(mknod)
 8a8:	b8 11 00 00 00       	mov    $0x11,%eax
 8ad:	cd 40                	int    $0x40
 8af:	c3                   	ret    

000008b0 <unlink>:
SYSCALL(unlink)
 8b0:	b8 12 00 00 00       	mov    $0x12,%eax
 8b5:	cd 40                	int    $0x40
 8b7:	c3                   	ret    

000008b8 <fstat>:
SYSCALL(fstat)
 8b8:	b8 08 00 00 00       	mov    $0x8,%eax
 8bd:	cd 40                	int    $0x40
 8bf:	c3                   	ret    

000008c0 <link>:
SYSCALL(link)
 8c0:	b8 13 00 00 00       	mov    $0x13,%eax
 8c5:	cd 40                	int    $0x40
 8c7:	c3                   	ret    

000008c8 <mkdir>:
SYSCALL(mkdir)
 8c8:	b8 14 00 00 00       	mov    $0x14,%eax
 8cd:	cd 40                	int    $0x40
 8cf:	c3                   	ret    

000008d0 <chdir>:
SYSCALL(chdir)
 8d0:	b8 09 00 00 00       	mov    $0x9,%eax
 8d5:	cd 40                	int    $0x40
 8d7:	c3                   	ret    

000008d8 <dup>:
SYSCALL(dup)
 8d8:	b8 0a 00 00 00       	mov    $0xa,%eax
 8dd:	cd 40                	int    $0x40
 8df:	c3                   	ret    

000008e0 <getpid>:
SYSCALL(getpid)
 8e0:	b8 0b 00 00 00       	mov    $0xb,%eax
 8e5:	cd 40                	int    $0x40
 8e7:	c3                   	ret    

000008e8 <sbrk>:
SYSCALL(sbrk)
 8e8:	b8 0c 00 00 00       	mov    $0xc,%eax
 8ed:	cd 40                	int    $0x40
 8ef:	c3                   	ret    

000008f0 <sleep>:
SYSCALL(sleep)
 8f0:	b8 0d 00 00 00       	mov    $0xd,%eax
 8f5:	cd 40                	int    $0x40
 8f7:	c3                   	ret    

000008f8 <uptime>:
SYSCALL(uptime)
 8f8:	b8 0e 00 00 00       	mov    $0xe,%eax
 8fd:	cd 40                	int    $0x40
 8ff:	c3                   	ret    

00000900 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 900:	55                   	push   %ebp
 901:	89 e5                	mov    %esp,%ebp
 903:	83 ec 18             	sub    $0x18,%esp
 906:	8b 45 0c             	mov    0xc(%ebp),%eax
 909:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 90c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 913:	00 
 914:	8d 45 f4             	lea    -0xc(%ebp),%eax
 917:	89 44 24 04          	mov    %eax,0x4(%esp)
 91b:	8b 45 08             	mov    0x8(%ebp),%eax
 91e:	89 04 24             	mov    %eax,(%esp)
 921:	e8 5a ff ff ff       	call   880 <write>
}
 926:	c9                   	leave  
 927:	c3                   	ret    

00000928 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 928:	55                   	push   %ebp
 929:	89 e5                	mov    %esp,%ebp
 92b:	56                   	push   %esi
 92c:	53                   	push   %ebx
 92d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 930:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 937:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 93b:	74 17                	je     954 <printint+0x2c>
 93d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 941:	79 11                	jns    954 <printint+0x2c>
    neg = 1;
 943:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 94a:	8b 45 0c             	mov    0xc(%ebp),%eax
 94d:	f7 d8                	neg    %eax
 94f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 952:	eb 06                	jmp    95a <printint+0x32>
  } else {
    x = xx;
 954:	8b 45 0c             	mov    0xc(%ebp),%eax
 957:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 95a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 961:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 964:	8d 41 01             	lea    0x1(%ecx),%eax
 967:	89 45 f4             	mov    %eax,-0xc(%ebp)
 96a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 96d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 970:	ba 00 00 00 00       	mov    $0x0,%edx
 975:	f7 f3                	div    %ebx
 977:	89 d0                	mov    %edx,%eax
 979:	8a 80 cc 11 00 00    	mov    0x11cc(%eax),%al
 97f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 983:	8b 75 10             	mov    0x10(%ebp),%esi
 986:	8b 45 ec             	mov    -0x14(%ebp),%eax
 989:	ba 00 00 00 00       	mov    $0x0,%edx
 98e:	f7 f6                	div    %esi
 990:	89 45 ec             	mov    %eax,-0x14(%ebp)
 993:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 997:	75 c8                	jne    961 <printint+0x39>
  if(neg)
 999:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 99d:	74 10                	je     9af <printint+0x87>
    buf[i++] = '-';
 99f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a2:	8d 50 01             	lea    0x1(%eax),%edx
 9a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 9a8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 9ad:	eb 1e                	jmp    9cd <printint+0xa5>
 9af:	eb 1c                	jmp    9cd <printint+0xa5>
    putc(fd, buf[i]);
 9b1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	01 d0                	add    %edx,%eax
 9b9:	8a 00                	mov    (%eax),%al
 9bb:	0f be c0             	movsbl %al,%eax
 9be:	89 44 24 04          	mov    %eax,0x4(%esp)
 9c2:	8b 45 08             	mov    0x8(%ebp),%eax
 9c5:	89 04 24             	mov    %eax,(%esp)
 9c8:	e8 33 ff ff ff       	call   900 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 9cd:	ff 4d f4             	decl   -0xc(%ebp)
 9d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d4:	79 db                	jns    9b1 <printint+0x89>
    putc(fd, buf[i]);
}
 9d6:	83 c4 30             	add    $0x30,%esp
 9d9:	5b                   	pop    %ebx
 9da:	5e                   	pop    %esi
 9db:	5d                   	pop    %ebp
 9dc:	c3                   	ret    

000009dd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9dd:	55                   	push   %ebp
 9de:	89 e5                	mov    %esp,%ebp
 9e0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9ea:	8d 45 0c             	lea    0xc(%ebp),%eax
 9ed:	83 c0 04             	add    $0x4,%eax
 9f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9fa:	e9 77 01 00 00       	jmp    b76 <printf+0x199>
    c = fmt[i] & 0xff;
 9ff:	8b 55 0c             	mov    0xc(%ebp),%edx
 a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a05:	01 d0                	add    %edx,%eax
 a07:	8a 00                	mov    (%eax),%al
 a09:	0f be c0             	movsbl %al,%eax
 a0c:	25 ff 00 00 00       	and    $0xff,%eax
 a11:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 a14:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a18:	75 2c                	jne    a46 <printf+0x69>
      if(c == '%'){
 a1a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a1e:	75 0c                	jne    a2c <printf+0x4f>
        state = '%';
 a20:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a27:	e9 47 01 00 00       	jmp    b73 <printf+0x196>
      } else {
        putc(fd, c);
 a2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a2f:	0f be c0             	movsbl %al,%eax
 a32:	89 44 24 04          	mov    %eax,0x4(%esp)
 a36:	8b 45 08             	mov    0x8(%ebp),%eax
 a39:	89 04 24             	mov    %eax,(%esp)
 a3c:	e8 bf fe ff ff       	call   900 <putc>
 a41:	e9 2d 01 00 00       	jmp    b73 <printf+0x196>
      }
    } else if(state == '%'){
 a46:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a4a:	0f 85 23 01 00 00    	jne    b73 <printf+0x196>
      if(c == 'd'){
 a50:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a54:	75 2d                	jne    a83 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a59:	8b 00                	mov    (%eax),%eax
 a5b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 a62:	00 
 a63:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 a6a:	00 
 a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
 a6f:	8b 45 08             	mov    0x8(%ebp),%eax
 a72:	89 04 24             	mov    %eax,(%esp)
 a75:	e8 ae fe ff ff       	call   928 <printint>
        ap++;
 a7a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a7e:	e9 e9 00 00 00       	jmp    b6c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 a83:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a87:	74 06                	je     a8f <printf+0xb2>
 a89:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a8d:	75 2d                	jne    abc <printf+0xdf>
        printint(fd, *ap, 16, 0);
 a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a92:	8b 00                	mov    (%eax),%eax
 a94:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 a9b:	00 
 a9c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 aa3:	00 
 aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
 aa8:	8b 45 08             	mov    0x8(%ebp),%eax
 aab:	89 04 24             	mov    %eax,(%esp)
 aae:	e8 75 fe ff ff       	call   928 <printint>
        ap++;
 ab3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ab7:	e9 b0 00 00 00       	jmp    b6c <printf+0x18f>
      } else if(c == 's'){
 abc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 ac0:	75 42                	jne    b04 <printf+0x127>
        s = (char*)*ap;
 ac2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ac5:	8b 00                	mov    (%eax),%eax
 ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 aca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ad2:	75 09                	jne    add <printf+0x100>
          s = "(null)";
 ad4:	c7 45 f4 ee 0d 00 00 	movl   $0xdee,-0xc(%ebp)
        while(*s != 0){
 adb:	eb 1c                	jmp    af9 <printf+0x11c>
 add:	eb 1a                	jmp    af9 <printf+0x11c>
          putc(fd, *s);
 adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae2:	8a 00                	mov    (%eax),%al
 ae4:	0f be c0             	movsbl %al,%eax
 ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
 aeb:	8b 45 08             	mov    0x8(%ebp),%eax
 aee:	89 04 24             	mov    %eax,(%esp)
 af1:	e8 0a fe ff ff       	call   900 <putc>
          s++;
 af6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 afc:	8a 00                	mov    (%eax),%al
 afe:	84 c0                	test   %al,%al
 b00:	75 dd                	jne    adf <printf+0x102>
 b02:	eb 68                	jmp    b6c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b04:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 b08:	75 1d                	jne    b27 <printf+0x14a>
        putc(fd, *ap);
 b0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 b0d:	8b 00                	mov    (%eax),%eax
 b0f:	0f be c0             	movsbl %al,%eax
 b12:	89 44 24 04          	mov    %eax,0x4(%esp)
 b16:	8b 45 08             	mov    0x8(%ebp),%eax
 b19:	89 04 24             	mov    %eax,(%esp)
 b1c:	e8 df fd ff ff       	call   900 <putc>
        ap++;
 b21:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 b25:	eb 45                	jmp    b6c <printf+0x18f>
      } else if(c == '%'){
 b27:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 b2b:	75 17                	jne    b44 <printf+0x167>
        putc(fd, c);
 b2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b30:	0f be c0             	movsbl %al,%eax
 b33:	89 44 24 04          	mov    %eax,0x4(%esp)
 b37:	8b 45 08             	mov    0x8(%ebp),%eax
 b3a:	89 04 24             	mov    %eax,(%esp)
 b3d:	e8 be fd ff ff       	call   900 <putc>
 b42:	eb 28                	jmp    b6c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b44:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 b4b:	00 
 b4c:	8b 45 08             	mov    0x8(%ebp),%eax
 b4f:	89 04 24             	mov    %eax,(%esp)
 b52:	e8 a9 fd ff ff       	call   900 <putc>
        putc(fd, c);
 b57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b5a:	0f be c0             	movsbl %al,%eax
 b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
 b61:	8b 45 08             	mov    0x8(%ebp),%eax
 b64:	89 04 24             	mov    %eax,(%esp)
 b67:	e8 94 fd ff ff       	call   900 <putc>
      }
      state = 0;
 b6c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 b73:	ff 45 f0             	incl   -0x10(%ebp)
 b76:	8b 55 0c             	mov    0xc(%ebp),%edx
 b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b7c:	01 d0                	add    %edx,%eax
 b7e:	8a 00                	mov    (%eax),%al
 b80:	84 c0                	test   %al,%al
 b82:	0f 85 77 fe ff ff    	jne    9ff <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 b88:	c9                   	leave  
 b89:	c3                   	ret    
 b8a:	90                   	nop
 b8b:	90                   	nop

00000b8c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b8c:	55                   	push   %ebp
 b8d:	89 e5                	mov    %esp,%ebp
 b8f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b92:	8b 45 08             	mov    0x8(%ebp),%eax
 b95:	83 e8 08             	sub    $0x8,%eax
 b98:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b9b:	a1 f0 11 00 00       	mov    0x11f0,%eax
 ba0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 ba3:	eb 24                	jmp    bc9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba8:	8b 00                	mov    (%eax),%eax
 baa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bad:	77 12                	ja     bc1 <free+0x35>
 baf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bb2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bb5:	77 24                	ja     bdb <free+0x4f>
 bb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bba:	8b 00                	mov    (%eax),%eax
 bbc:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bbf:	77 1a                	ja     bdb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bc4:	8b 00                	mov    (%eax),%eax
 bc6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 bc9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bcc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 bcf:	76 d4                	jbe    ba5 <free+0x19>
 bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bd4:	8b 00                	mov    (%eax),%eax
 bd6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 bd9:	76 ca                	jbe    ba5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 bdb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bde:	8b 40 04             	mov    0x4(%eax),%eax
 be1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 be8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 beb:	01 c2                	add    %eax,%edx
 bed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf0:	8b 00                	mov    (%eax),%eax
 bf2:	39 c2                	cmp    %eax,%edx
 bf4:	75 24                	jne    c1a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bf6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bf9:	8b 50 04             	mov    0x4(%eax),%edx
 bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bff:	8b 00                	mov    (%eax),%eax
 c01:	8b 40 04             	mov    0x4(%eax),%eax
 c04:	01 c2                	add    %eax,%edx
 c06:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c09:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 c0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0f:	8b 00                	mov    (%eax),%eax
 c11:	8b 10                	mov    (%eax),%edx
 c13:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c16:	89 10                	mov    %edx,(%eax)
 c18:	eb 0a                	jmp    c24 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 c1a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c1d:	8b 10                	mov    (%eax),%edx
 c1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c22:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 c24:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c27:	8b 40 04             	mov    0x4(%eax),%eax
 c2a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 c31:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c34:	01 d0                	add    %edx,%eax
 c36:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 c39:	75 20                	jne    c5b <free+0xcf>
    p->s.size += bp->s.size;
 c3b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c3e:	8b 50 04             	mov    0x4(%eax),%edx
 c41:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c44:	8b 40 04             	mov    0x4(%eax),%eax
 c47:	01 c2                	add    %eax,%edx
 c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c4c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c52:	8b 10                	mov    (%eax),%edx
 c54:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c57:	89 10                	mov    %edx,(%eax)
 c59:	eb 08                	jmp    c63 <free+0xd7>
  } else
    p->s.ptr = bp;
 c5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c5e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c61:	89 10                	mov    %edx,(%eax)
  freep = p;
 c63:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c66:	a3 f0 11 00 00       	mov    %eax,0x11f0
}
 c6b:	c9                   	leave  
 c6c:	c3                   	ret    

00000c6d <morecore>:

static Header*
morecore(uint nu)
{
 c6d:	55                   	push   %ebp
 c6e:	89 e5                	mov    %esp,%ebp
 c70:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c73:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c7a:	77 07                	ja     c83 <morecore+0x16>
    nu = 4096;
 c7c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c83:	8b 45 08             	mov    0x8(%ebp),%eax
 c86:	c1 e0 03             	shl    $0x3,%eax
 c89:	89 04 24             	mov    %eax,(%esp)
 c8c:	e8 57 fc ff ff       	call   8e8 <sbrk>
 c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c94:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c98:	75 07                	jne    ca1 <morecore+0x34>
    return 0;
 c9a:	b8 00 00 00 00       	mov    $0x0,%eax
 c9f:	eb 22                	jmp    cc3 <morecore+0x56>
  hp = (Header*)p;
 ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ca4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ca7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 caa:	8b 55 08             	mov    0x8(%ebp),%edx
 cad:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cb3:	83 c0 08             	add    $0x8,%eax
 cb6:	89 04 24             	mov    %eax,(%esp)
 cb9:	e8 ce fe ff ff       	call   b8c <free>
  return freep;
 cbe:	a1 f0 11 00 00       	mov    0x11f0,%eax
}
 cc3:	c9                   	leave  
 cc4:	c3                   	ret    

00000cc5 <malloc>:

void*
malloc(uint nbytes)
{
 cc5:	55                   	push   %ebp
 cc6:	89 e5                	mov    %esp,%ebp
 cc8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ccb:	8b 45 08             	mov    0x8(%ebp),%eax
 cce:	83 c0 07             	add    $0x7,%eax
 cd1:	c1 e8 03             	shr    $0x3,%eax
 cd4:	40                   	inc    %eax
 cd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 cd8:	a1 f0 11 00 00       	mov    0x11f0,%eax
 cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ce0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 ce4:	75 23                	jne    d09 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 ce6:	c7 45 f0 e8 11 00 00 	movl   $0x11e8,-0x10(%ebp)
 ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf0:	a3 f0 11 00 00       	mov    %eax,0x11f0
 cf5:	a1 f0 11 00 00       	mov    0x11f0,%eax
 cfa:	a3 e8 11 00 00       	mov    %eax,0x11e8
    base.s.size = 0;
 cff:	c7 05 ec 11 00 00 00 	movl   $0x0,0x11ec
 d06:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d09:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d0c:	8b 00                	mov    (%eax),%eax
 d0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d14:	8b 40 04             	mov    0x4(%eax),%eax
 d17:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d1a:	72 4d                	jb     d69 <malloc+0xa4>
      if(p->s.size == nunits)
 d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1f:	8b 40 04             	mov    0x4(%eax),%eax
 d22:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 d25:	75 0c                	jne    d33 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2a:	8b 10                	mov    (%eax),%edx
 d2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d2f:	89 10                	mov    %edx,(%eax)
 d31:	eb 26                	jmp    d59 <malloc+0x94>
      else {
        p->s.size -= nunits;
 d33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d36:	8b 40 04             	mov    0x4(%eax),%eax
 d39:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d3c:	89 c2                	mov    %eax,%edx
 d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d41:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d47:	8b 40 04             	mov    0x4(%eax),%eax
 d4a:	c1 e0 03             	shl    $0x3,%eax
 d4d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d53:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d56:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d5c:	a3 f0 11 00 00       	mov    %eax,0x11f0
      return (void*)(p + 1);
 d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d64:	83 c0 08             	add    $0x8,%eax
 d67:	eb 38                	jmp    da1 <malloc+0xdc>
    }
    if(p == freep)
 d69:	a1 f0 11 00 00       	mov    0x11f0,%eax
 d6e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d71:	75 1b                	jne    d8e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
 d76:	89 04 24             	mov    %eax,(%esp)
 d79:	e8 ef fe ff ff       	call   c6d <morecore>
 d7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d85:	75 07                	jne    d8e <malloc+0xc9>
        return 0;
 d87:	b8 00 00 00 00       	mov    $0x0,%eax
 d8c:	eb 13                	jmp    da1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d91:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d97:	8b 00                	mov    (%eax),%eax
 d99:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 d9c:	e9 70 ff ff ff       	jmp    d11 <malloc+0x4c>
}
 da1:	c9                   	leave  
 da2:	c3                   	ret    
