
_ctool:     file format elf32-i386


Disassembly of section .text:

00000000 <is_int>:
  struct container containers[4];
  int count;
} ctable;

int is_int(char c)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 04             	sub    $0x4,%esp
   6:	8b 45 08             	mov    0x8(%ebp),%eax
   9:	88 45 fc             	mov    %al,-0x4(%ebp)
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
   c:	80 7d fc 30          	cmpb   $0x30,-0x4(%ebp)
  10:	74 36                	je     48 <is_int+0x48>
  int count;
} ctable;

int is_int(char c)
{
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
  12:	80 7d fc 31          	cmpb   $0x31,-0x4(%ebp)
  16:	74 30                	je     48 <is_int+0x48>
  18:	80 7d fc 32          	cmpb   $0x32,-0x4(%ebp)
  1c:	74 2a                	je     48 <is_int+0x48>
  1e:	80 7d fc 33          	cmpb   $0x33,-0x4(%ebp)
  22:	74 24                	je     48 <is_int+0x48>
  24:	80 7d fc 34          	cmpb   $0x34,-0x4(%ebp)
  28:	74 1e                	je     48 <is_int+0x48>
  2a:	80 7d fc 35          	cmpb   $0x35,-0x4(%ebp)
  2e:	74 18                	je     48 <is_int+0x48>
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
  30:	80 7d fc 36          	cmpb   $0x36,-0x4(%ebp)
  34:	74 12                	je     48 <is_int+0x48>
  36:	80 7d fc 37          	cmpb   $0x37,-0x4(%ebp)
  3a:	74 0c                	je     48 <is_int+0x48>
  3c:	80 7d fc 38          	cmpb   $0x38,-0x4(%ebp)
  40:	74 06                	je     48 <is_int+0x48>
  42:	80 7d fc 39          	cmpb   $0x39,-0x4(%ebp)
  46:	75 07                	jne    4f <is_int+0x4f>
  48:	b8 01 00 00 00       	mov    $0x1,%eax
  4d:	eb 05                	jmp    54 <is_int+0x54>
  4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  54:	c9                   	leave  
  55:	c3                   	ret    

00000056 <start>:

// ctool start vc0 c0 usfsh 8 10 5
int start(int argc, char *argv[])
{
  56:	55                   	push   %ebp
  57:	89 e5                	mov    %esp,%ebp
  59:	83 ec 28             	sub    $0x28,%esp
  int id, fd, cindex = 0;
  5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while(!is_int(argv[3][cindex]))
  63:	eb 03                	jmp    68 <start+0x12>
  {
    cindex = cindex + 1;
  65:	ff 45 f4             	incl   -0xc(%ebp)

// ctool start vc0 c0 usfsh 8 10 5
int start(int argc, char *argv[])
{
  int id, fd, cindex = 0;
  while(!is_int(argv[3][cindex]))
  68:	8b 45 0c             	mov    0xc(%ebp),%eax
  6b:	83 c0 0c             	add    $0xc,%eax
  6e:	8b 10                	mov    (%eax),%edx
  70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  73:	01 d0                	add    %edx,%eax
  75:	8a 00                	mov    (%eax),%al
  77:	0f be c0             	movsbl %al,%eax
  7a:	89 04 24             	mov    %eax,(%esp)
  7d:	e8 7e ff ff ff       	call   0 <is_int>
  82:	85 c0                	test   %eax,%eax
  84:	74 df                	je     65 <start+0xf>
  {
    cindex = cindex + 1;
  }

  printf(1, "THIS IS ARGV[4]: %s\n", argv[4]);
  86:	8b 45 0c             	mov    0xc(%ebp),%eax
  89:	83 c0 10             	add    $0x10,%eax
  8c:	8b 00                	mov    (%eax),%eax
  8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  92:	c7 44 24 04 d4 0f 00 	movl   $0xfd4,0x4(%esp)
  99:	00 
  9a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a1:	e8 67 0b 00 00       	call   c0d <printf>
  fd = open(argv[2], O_RDWR);
  a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  a9:	83 c0 08             	add    $0x8,%eax
  ac:	8b 00                	mov    (%eax),%eax
  ae:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  b5:	00 
  b6:	89 04 24             	mov    %eax,(%esp)
  b9:	e8 12 0a 00 00       	call   ad0 <open>
  be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  printf(1, "fd = %d\n", fd);
  c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c4:	89 44 24 08          	mov    %eax,0x8(%esp)
  c8:	c7 44 24 04 e9 0f 00 	movl   $0xfe9,0x4(%esp)
  cf:	00 
  d0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d7:	e8 31 0b 00 00       	call   c0d <printf>
  // ctable.containers[cindex].max_proc = atoi(argv[5]);
  // ctable.containers[cindex].max_mem = atoi(argv[6]);
  // ctable.containers[cindex].max_disk = atoi(argv[7]);

  /* fork a child and exec argv[4] */
  id = fork();
  dc:	e8 a7 09 00 00       	call   a88 <fork>
  e1:	89 45 ec             	mov    %eax,-0x14(%ebp)

  if (id == 0)
  e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  e8:	0f 85 9c 00 00 00    	jne    18a <start+0x134>
  {
    close(0);
  ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  f5:	e8 be 09 00 00       	call   ab8 <close>
    close(1);
  fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 101:	e8 b2 09 00 00       	call   ab8 <close>
    close(2);
 106:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 10d:	e8 a6 09 00 00       	call   ab8 <close>
    dup(fd);
 112:	8b 45 f0             	mov    -0x10(%ebp),%eax
 115:	89 04 24             	mov    %eax,(%esp)
 118:	e8 eb 09 00 00       	call   b08 <dup>
    dup(fd);
 11d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 120:	89 04 24             	mov    %eax,(%esp)
 123:	e8 e0 09 00 00       	call   b08 <dup>
    dup(fd);
 128:	8b 45 f0             	mov    -0x10(%ebp),%eax
 12b:	89 04 24             	mov    %eax,(%esp)
 12e:	e8 d5 09 00 00       	call   b08 <dup>
    if(chdir(argv[3]) < 0)
 133:	8b 45 0c             	mov    0xc(%ebp),%eax
 136:	83 c0 0c             	add    $0xc,%eax
 139:	8b 00                	mov    (%eax),%eax
 13b:	89 04 24             	mov    %eax,(%esp)
 13e:	e8 bd 09 00 00       	call   b00 <chdir>
 143:	85 c0                	test   %eax,%eax
 145:	79 19                	jns    160 <start+0x10a>
    {
      printf(1, "Container does not exist.");
 147:	c7 44 24 04 f2 0f 00 	movl   $0xff2,0x4(%esp)
 14e:	00 
 14f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 156:	e8 b2 0a 00 00       	call   c0d <printf>
      exit();
 15b:	e8 30 09 00 00       	call   a90 <exit>
    }
    exec(argv[4], &argv[4]);
 160:	8b 45 0c             	mov    0xc(%ebp),%eax
 163:	8d 50 10             	lea    0x10(%eax),%edx
 166:	8b 45 0c             	mov    0xc(%ebp),%eax
 169:	83 c0 10             	add    $0x10,%eax
 16c:	8b 00                	mov    (%eax),%eax
 16e:	89 54 24 04          	mov    %edx,0x4(%esp)
 172:	89 04 24             	mov    %eax,(%esp)
 175:	e8 4e 09 00 00       	call   ac8 <exec>
    close(fd);
 17a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 17d:	89 04 24             	mov    %eax,(%esp)
 180:	e8 33 09 00 00       	call   ab8 <close>
    exit();
 185:	e8 06 09 00 00       	call   a90 <exit>
  }

  return 0;
 18a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 18f:	c9                   	leave  
 190:	c3                   	ret    

00000191 <create>:

// ctool create c0 cat ls echo sh ...
int create(int argc, char *argv[])
{
 191:	55                   	push   %ebp
 192:	89 e5                	mov    %esp,%ebp
 194:	83 ec 68             	sub    $0x68,%esp
  int i, id, fd;
  char *mkdir[2];
  mkdir[0] = "mkdir";
 197:	c7 45 e0 0c 10 00 00 	movl   $0x100c,-0x20(%ebp)
  mkdir[1] = argv[2];
 19e:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a1:	8b 40 08             	mov    0x8(%eax),%eax
 1a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  int cindex = 0;
 1a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  while(!is_int(argv[3][cindex]))
 1ae:	eb 03                	jmp    1b3 <create+0x22>
  {
    cindex = cindex + 1;
 1b0:	ff 45 f0             	incl   -0x10(%ebp)
  char *mkdir[2];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  int cindex = 0;
  while(!is_int(argv[3][cindex]))
 1b3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b6:	83 c0 0c             	add    $0xc,%eax
 1b9:	8b 10                	mov    (%eax),%edx
 1bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 1be:	01 d0                	add    %edx,%eax
 1c0:	8a 00                	mov    (%eax),%al
 1c2:	0f be c0             	movsbl %al,%eax
 1c5:	89 04 24             	mov    %eax,(%esp)
 1c8:	e8 33 fe ff ff       	call   0 <is_int>
 1cd:	85 c0                	test   %eax,%eax
 1cf:	74 df                	je     1b0 <create+0x1f>
  {
    cindex = cindex + 1;
  }

  strcpy(ctable.containers[cindex].name, argv[2]);
 1d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d4:	83 c0 08             	add    $0x8,%eax
 1d7:	8b 10                	mov    (%eax),%edx
 1d9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
 1dc:	89 c8                	mov    %ecx,%eax
 1de:	c1 e0 02             	shl    $0x2,%eax
 1e1:	01 c8                	add    %ecx,%eax
 1e3:	c1 e0 02             	shl    $0x2,%eax
 1e6:	05 a0 14 00 00       	add    $0x14a0,%eax
 1eb:	8b 00                	mov    (%eax),%eax
 1ed:	89 54 24 04          	mov    %edx,0x4(%esp)
 1f1:	89 04 24             	mov    %eax,(%esp)
 1f4:	e8 0c 02 00 00       	call   405 <strcpy>
  ctable.count = ctable.count + 1;
 1f9:	a1 f0 14 00 00       	mov    0x14f0,%eax
 1fe:	40                   	inc    %eax
 1ff:	a3 f0 14 00 00       	mov    %eax,0x14f0

  id = fork();
 204:	e8 7f 08 00 00       	call   a88 <fork>
 209:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0)
 20c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 210:	75 12                	jne    224 <create+0x93>
  {
    exec(mkdir[0], mkdir);
 212:	8b 45 e0             	mov    -0x20(%ebp),%eax
 215:	8d 55 e0             	lea    -0x20(%ebp),%edx
 218:	89 54 24 04          	mov    %edx,0x4(%esp)
 21c:	89 04 24             	mov    %eax,(%esp)
 21f:	e8 a4 08 00 00       	call   ac8 <exec>
  }
  id = wait();
 224:	e8 6f 08 00 00       	call   a98 <wait>
 229:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for(i = 3; i < argc; i++) // going through ls echo cat ...
 22c:	c7 45 f4 03 00 00 00 	movl   $0x3,-0xc(%ebp)
 233:	e9 ed 00 00 00       	jmp    325 <create+0x194>
  {
    id = fork();
 238:	e8 4b 08 00 00       	call   a88 <fork>
 23d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(id == 0)
 240:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 244:	0f 85 d0 00 00 00    	jne    31a <create+0x189>
    {
      char *executable[4];
      char destination[32];

      strcpy(destination, "/");
 24a:	c7 44 24 04 12 10 00 	movl   $0x1012,0x4(%esp)
 251:	00 
 252:	8d 45 b0             	lea    -0x50(%ebp),%eax
 255:	89 04 24             	mov    %eax,(%esp)
 258:	e8 a8 01 00 00       	call   405 <strcpy>
      strcat(destination, mkdir[1]);
 25d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 260:	89 44 24 04          	mov    %eax,0x4(%esp)
 264:	8d 45 b0             	lea    -0x50(%ebp),%eax
 267:	89 04 24             	mov    %eax,(%esp)
 26a:	e8 c3 02 00 00       	call   532 <strcat>
      strcat(destination, "/");
 26f:	c7 44 24 04 12 10 00 	movl   $0x1012,0x4(%esp)
 276:	00 
 277:	8d 45 b0             	lea    -0x50(%ebp),%eax
 27a:	89 04 24             	mov    %eax,(%esp)
 27d:	e8 b0 02 00 00       	call   532 <strcat>
      strcat(destination, argv[i]);
 282:	8b 45 f4             	mov    -0xc(%ebp),%eax
 285:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 28c:	8b 45 0c             	mov    0xc(%ebp),%eax
 28f:	01 d0                	add    %edx,%eax
 291:	8b 00                	mov    (%eax),%eax
 293:	89 44 24 04          	mov    %eax,0x4(%esp)
 297:	8d 45 b0             	lea    -0x50(%ebp),%eax
 29a:	89 04 24             	mov    %eax,(%esp)
 29d:	e8 90 02 00 00       	call   532 <strcat>
      strcat(destination, "\0");
 2a2:	c7 44 24 04 14 10 00 	movl   $0x1014,0x4(%esp)
 2a9:	00 
 2aa:	8d 45 b0             	lea    -0x50(%ebp),%eax
 2ad:	89 04 24             	mov    %eax,(%esp)
 2b0:	e8 7d 02 00 00       	call   532 <strcat>

      executable[0] = "cat";
 2b5:	c7 45 d0 16 10 00 00 	movl   $0x1016,-0x30(%ebp)
      executable[1] = argv[i];
 2bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2bf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	01 d0                	add    %edx,%eax
 2cb:	8b 00                	mov    (%eax),%eax
 2cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)

      fd = open(destination, O_CREATE | O_RDWR);
 2d0:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
 2d7:	00 
 2d8:	8d 45 b0             	lea    -0x50(%ebp),%eax
 2db:	89 04 24             	mov    %eax,(%esp)
 2de:	e8 ed 07 00 00       	call   ad0 <open>
 2e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    
      close(1);
 2e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ed:	e8 c6 07 00 00       	call   ab8 <close>
      dup(fd);
 2f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 2f5:	89 04 24             	mov    %eax,(%esp)
 2f8:	e8 0b 08 00 00       	call   b08 <dup>
      close(fd);
 2fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
 300:	89 04 24             	mov    %eax,(%esp)
 303:	e8 b0 07 00 00       	call   ab8 <close>
      exec(executable[0], executable);
 308:	8b 45 d0             	mov    -0x30(%ebp),%eax
 30b:	8d 55 d0             	lea    -0x30(%ebp),%edx
 30e:	89 54 24 04          	mov    %edx,0x4(%esp)
 312:	89 04 24             	mov    %eax,(%esp)
 315:	e8 ae 07 00 00       	call   ac8 <exec>
    }
    id = wait();
 31a:	e8 79 07 00 00       	call   a98 <wait>
 31f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  {
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 3; i < argc; i++) // going through ls echo cat ...
 322:	ff 45 f4             	incl   -0xc(%ebp)
 325:	8b 45 f4             	mov    -0xc(%ebp),%eax
 328:	3b 45 08             	cmp    0x8(%ebp),%eax
 32b:	0f 8c 07 ff ff ff    	jl     238 <create+0xa7>
      exec(executable[0], executable);
    }
    id = wait();
  }

  return 0;
 331:	b8 00 00 00 00       	mov    $0x0,%eax
}
 336:	c9                   	leave  
 337:	c3                   	ret    

00000338 <main>:

int main(int argc, char *argv[])
{
 338:	55                   	push   %ebp
 339:	89 e5                	mov    %esp,%ebp
 33b:	83 e4 f0             	and    $0xfffffff0,%esp
 33e:	83 ec 10             	sub    $0x10,%esp
  {
    // TODO:
    // print_usage();
  }

  if(strcmp(argv[1], "create") == 0)
 341:	8b 45 0c             	mov    0xc(%ebp),%eax
 344:	83 c0 04             	add    $0x4,%eax
 347:	8b 00                	mov    (%eax),%eax
 349:	c7 44 24 04 1a 10 00 	movl   $0x101a,0x4(%esp)
 350:	00 
 351:	89 04 24             	mov    %eax,(%esp)
 354:	e8 da 00 00 00       	call   433 <strcmp>
 359:	85 c0                	test   %eax,%eax
 35b:	75 47                	jne    3a4 <main+0x6c>
  {
    if(argc < 4)
 35d:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
 361:	7e 41                	jle    3a4 <main+0x6c>
      // TODO:
      // print_usage("create");
    }
    else
    {
      if(chdir(argv[2]) < 0)
 363:	8b 45 0c             	mov    0xc(%ebp),%eax
 366:	83 c0 08             	add    $0x8,%eax
 369:	8b 00                	mov    (%eax),%eax
 36b:	89 04 24             	mov    %eax,(%esp)
 36e:	e8 8d 07 00 00       	call   b00 <chdir>
 373:	85 c0                	test   %eax,%eax
 375:	79 14                	jns    38b <main+0x53>
      {
         create(argc, argv);
 377:	8b 45 0c             	mov    0xc(%ebp),%eax
 37a:	89 44 24 04          	mov    %eax,0x4(%esp)
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	89 04 24             	mov    %eax,(%esp)
 384:	e8 08 fe ff ff       	call   191 <create>
 389:	eb 19                	jmp    3a4 <main+0x6c>
      }
      else
      {
        printf(1, "This device already has a container's filesystem\n");
 38b:	c7 44 24 04 24 10 00 	movl   $0x1024,0x4(%esp)
 392:	00 
 393:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 39a:	e8 6e 08 00 00       	call   c0d <printf>
        exit();
 39f:	e8 ec 06 00 00       	call   a90 <exit>
      }
    }
  }

  if(strcmp(argv[1], "start") == 0)
 3a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a7:	83 c0 04             	add    $0x4,%eax
 3aa:	8b 00                	mov    (%eax),%eax
 3ac:	c7 44 24 04 56 10 00 	movl   $0x1056,0x4(%esp)
 3b3:	00 
 3b4:	89 04 24             	mov    %eax,(%esp)
 3b7:	e8 77 00 00 00       	call   433 <strcmp>
 3bc:	85 c0                	test   %eax,%eax
 3be:	75 18                	jne    3d8 <main+0xa0>
  {
    if(argc < 4)
 3c0:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
 3c4:	7e 12                	jle    3d8 <main+0xa0>
      // TODO:
      // print_usage("create");
    }
    else
    {
      start(argc, argv);
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	89 04 24             	mov    %eax,(%esp)
 3d3:	e8 7e fc ff ff       	call   56 <start>
    }
  }

  exit();
 3d8:	e8 b3 06 00 00       	call   a90 <exit>
 3dd:	90                   	nop
 3de:	90                   	nop
 3df:	90                   	nop

000003e0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 3e0:	55                   	push   %ebp
 3e1:	89 e5                	mov    %esp,%ebp
 3e3:	57                   	push   %edi
 3e4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 3e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3e8:	8b 55 10             	mov    0x10(%ebp),%edx
 3eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 3ee:	89 cb                	mov    %ecx,%ebx
 3f0:	89 df                	mov    %ebx,%edi
 3f2:	89 d1                	mov    %edx,%ecx
 3f4:	fc                   	cld    
 3f5:	f3 aa                	rep stos %al,%es:(%edi)
 3f7:	89 ca                	mov    %ecx,%edx
 3f9:	89 fb                	mov    %edi,%ebx
 3fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
 3fe:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 401:	5b                   	pop    %ebx
 402:	5f                   	pop    %edi
 403:	5d                   	pop    %ebp
 404:	c3                   	ret    

00000405 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
 405:	55                   	push   %ebp
 406:	89 e5                	mov    %esp,%ebp
 408:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 40b:	8b 45 08             	mov    0x8(%ebp),%eax
 40e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 411:	90                   	nop
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	8d 50 01             	lea    0x1(%eax),%edx
 418:	89 55 08             	mov    %edx,0x8(%ebp)
 41b:	8b 55 0c             	mov    0xc(%ebp),%edx
 41e:	8d 4a 01             	lea    0x1(%edx),%ecx
 421:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 424:	8a 12                	mov    (%edx),%dl
 426:	88 10                	mov    %dl,(%eax)
 428:	8a 00                	mov    (%eax),%al
 42a:	84 c0                	test   %al,%al
 42c:	75 e4                	jne    412 <strcpy+0xd>
    ;
  return os;
 42e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 431:	c9                   	leave  
 432:	c3                   	ret    

00000433 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 433:	55                   	push   %ebp
 434:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 436:	eb 06                	jmp    43e <strcmp+0xb>
    p++, q++;
 438:	ff 45 08             	incl   0x8(%ebp)
 43b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	8a 00                	mov    (%eax),%al
 443:	84 c0                	test   %al,%al
 445:	74 0e                	je     455 <strcmp+0x22>
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	8a 10                	mov    (%eax),%dl
 44c:	8b 45 0c             	mov    0xc(%ebp),%eax
 44f:	8a 00                	mov    (%eax),%al
 451:	38 c2                	cmp    %al,%dl
 453:	74 e3                	je     438 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	8a 00                	mov    (%eax),%al
 45a:	0f b6 d0             	movzbl %al,%edx
 45d:	8b 45 0c             	mov    0xc(%ebp),%eax
 460:	8a 00                	mov    (%eax),%al
 462:	0f b6 c0             	movzbl %al,%eax
 465:	29 c2                	sub    %eax,%edx
 467:	89 d0                	mov    %edx,%eax
}
 469:	5d                   	pop    %ebp
 46a:	c3                   	ret    

0000046b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
 46b:	55                   	push   %ebp
 46c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
 46e:	eb 09                	jmp    479 <strncmp+0xe>
    n--, p++, q++;
 470:	ff 4d 10             	decl   0x10(%ebp)
 473:	ff 45 08             	incl   0x8(%ebp)
 476:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
 479:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 47d:	74 17                	je     496 <strncmp+0x2b>
 47f:	8b 45 08             	mov    0x8(%ebp),%eax
 482:	8a 00                	mov    (%eax),%al
 484:	84 c0                	test   %al,%al
 486:	74 0e                	je     496 <strncmp+0x2b>
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	8a 10                	mov    (%eax),%dl
 48d:	8b 45 0c             	mov    0xc(%ebp),%eax
 490:	8a 00                	mov    (%eax),%al
 492:	38 c2                	cmp    %al,%dl
 494:	74 da                	je     470 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
 496:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 49a:	75 07                	jne    4a3 <strncmp+0x38>
    return 0;
 49c:	b8 00 00 00 00       	mov    $0x0,%eax
 4a1:	eb 14                	jmp    4b7 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
 4a3:	8b 45 08             	mov    0x8(%ebp),%eax
 4a6:	8a 00                	mov    (%eax),%al
 4a8:	0f b6 d0             	movzbl %al,%edx
 4ab:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ae:	8a 00                	mov    (%eax),%al
 4b0:	0f b6 c0             	movzbl %al,%eax
 4b3:	29 c2                	sub    %eax,%edx
 4b5:	89 d0                	mov    %edx,%eax
}
 4b7:	5d                   	pop    %ebp
 4b8:	c3                   	ret    

000004b9 <strlen>:

uint
strlen(const char *s)
{
 4b9:	55                   	push   %ebp
 4ba:	89 e5                	mov    %esp,%ebp
 4bc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 4bf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 4c6:	eb 03                	jmp    4cb <strlen+0x12>
 4c8:	ff 45 fc             	incl   -0x4(%ebp)
 4cb:	8b 55 fc             	mov    -0x4(%ebp),%edx
 4ce:	8b 45 08             	mov    0x8(%ebp),%eax
 4d1:	01 d0                	add    %edx,%eax
 4d3:	8a 00                	mov    (%eax),%al
 4d5:	84 c0                	test   %al,%al
 4d7:	75 ef                	jne    4c8 <strlen+0xf>
    ;
  return n;
 4d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 4dc:	c9                   	leave  
 4dd:	c3                   	ret    

000004de <memset>:

void*
memset(void *dst, int c, uint n)
{
 4de:	55                   	push   %ebp
 4df:	89 e5                	mov    %esp,%ebp
 4e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 4e4:	8b 45 10             	mov    0x10(%ebp),%eax
 4e7:	89 44 24 08          	mov    %eax,0x8(%esp)
 4eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f2:	8b 45 08             	mov    0x8(%ebp),%eax
 4f5:	89 04 24             	mov    %eax,(%esp)
 4f8:	e8 e3 fe ff ff       	call   3e0 <stosb>
  return dst;
 4fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 500:	c9                   	leave  
 501:	c3                   	ret    

00000502 <strchr>:

char*
strchr(const char *s, char c)
{
 502:	55                   	push   %ebp
 503:	89 e5                	mov    %esp,%ebp
 505:	83 ec 04             	sub    $0x4,%esp
 508:	8b 45 0c             	mov    0xc(%ebp),%eax
 50b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 50e:	eb 12                	jmp    522 <strchr+0x20>
    if(*s == c)
 510:	8b 45 08             	mov    0x8(%ebp),%eax
 513:	8a 00                	mov    (%eax),%al
 515:	3a 45 fc             	cmp    -0x4(%ebp),%al
 518:	75 05                	jne    51f <strchr+0x1d>
      return (char*)s;
 51a:	8b 45 08             	mov    0x8(%ebp),%eax
 51d:	eb 11                	jmp    530 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 51f:	ff 45 08             	incl   0x8(%ebp)
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	8a 00                	mov    (%eax),%al
 527:	84 c0                	test   %al,%al
 529:	75 e5                	jne    510 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 52b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 530:	c9                   	leave  
 531:	c3                   	ret    

00000532 <strcat>:

char *
strcat(char *dest, const char *src)
{
 532:	55                   	push   %ebp
 533:	89 e5                	mov    %esp,%ebp
 535:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
 538:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 53f:	eb 03                	jmp    544 <strcat+0x12>
 541:	ff 45 fc             	incl   -0x4(%ebp)
 544:	8b 55 fc             	mov    -0x4(%ebp),%edx
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	01 d0                	add    %edx,%eax
 54c:	8a 00                	mov    (%eax),%al
 54e:	84 c0                	test   %al,%al
 550:	75 ef                	jne    541 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
 552:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
 559:	eb 1e                	jmp    579 <strcat+0x47>
        dest[i+j] = src[j];
 55b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 55e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 561:	01 d0                	add    %edx,%eax
 563:	89 c2                	mov    %eax,%edx
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	01 c2                	add    %eax,%edx
 56a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 56d:	8b 45 0c             	mov    0xc(%ebp),%eax
 570:	01 c8                	add    %ecx,%eax
 572:	8a 00                	mov    (%eax),%al
 574:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
 576:	ff 45 f8             	incl   -0x8(%ebp)
 579:	8b 55 f8             	mov    -0x8(%ebp),%edx
 57c:	8b 45 0c             	mov    0xc(%ebp),%eax
 57f:	01 d0                	add    %edx,%eax
 581:	8a 00                	mov    (%eax),%al
 583:	84 c0                	test   %al,%al
 585:	75 d4                	jne    55b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
 587:	8b 45 f8             	mov    -0x8(%ebp),%eax
 58a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 58d:	01 d0                	add    %edx,%eax
 58f:	89 c2                	mov    %eax,%edx
 591:	8b 45 08             	mov    0x8(%ebp),%eax
 594:	01 d0                	add    %edx,%eax
 596:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
 599:	8b 45 08             	mov    0x8(%ebp),%eax
}
 59c:	c9                   	leave  
 59d:	c3                   	ret    

0000059e <strstr>:

int 
strstr(char* s, char* sub)
{
 59e:	55                   	push   %ebp
 59f:	89 e5                	mov    %esp,%ebp
 5a1:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 5a4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 5ab:	eb 7c                	jmp    629 <strstr+0x8b>
    {
        if(s[i] == sub[0])
 5ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5b0:	8b 45 08             	mov    0x8(%ebp),%eax
 5b3:	01 d0                	add    %edx,%eax
 5b5:	8a 10                	mov    (%eax),%dl
 5b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ba:	8a 00                	mov    (%eax),%al
 5bc:	38 c2                	cmp    %al,%dl
 5be:	75 66                	jne    626 <strstr+0x88>
        {
            if(strlen(sub) == 1)
 5c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c3:	89 04 24             	mov    %eax,(%esp)
 5c6:	e8 ee fe ff ff       	call   4b9 <strlen>
 5cb:	83 f8 01             	cmp    $0x1,%eax
 5ce:	75 05                	jne    5d5 <strstr+0x37>
            {  
                return i;
 5d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 5d3:	eb 6b                	jmp    640 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
 5d5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
 5dc:	eb 3a                	jmp    618 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
 5de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 5e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 5e4:	01 d0                	add    %edx,%eax
 5e6:	89 c2                	mov    %eax,%edx
 5e8:	8b 45 08             	mov    0x8(%ebp),%eax
 5eb:	01 d0                	add    %edx,%eax
 5ed:	8a 10                	mov    (%eax),%dl
 5ef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
 5f2:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f5:	01 c8                	add    %ecx,%eax
 5f7:	8a 00                	mov    (%eax),%al
 5f9:	38 c2                	cmp    %al,%dl
 5fb:	75 16                	jne    613 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
 5fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 600:	8d 50 01             	lea    0x1(%eax),%edx
 603:	8b 45 0c             	mov    0xc(%ebp),%eax
 606:	01 d0                	add    %edx,%eax
 608:	8a 00                	mov    (%eax),%al
 60a:	84 c0                	test   %al,%al
 60c:	75 07                	jne    615 <strstr+0x77>
                    {
                        return i;
 60e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 611:	eb 2d                	jmp    640 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
 613:	eb 11                	jmp    626 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
 615:	ff 45 f8             	incl   -0x8(%ebp)
 618:	8b 55 f8             	mov    -0x8(%ebp),%edx
 61b:	8b 45 0c             	mov    0xc(%ebp),%eax
 61e:	01 d0                	add    %edx,%eax
 620:	8a 00                	mov    (%eax),%al
 622:	84 c0                	test   %al,%al
 624:	75 b8                	jne    5de <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
 626:	ff 45 fc             	incl   -0x4(%ebp)
 629:	8b 55 fc             	mov    -0x4(%ebp),%edx
 62c:	8b 45 08             	mov    0x8(%ebp),%eax
 62f:	01 d0                	add    %edx,%eax
 631:	8a 00                	mov    (%eax),%al
 633:	84 c0                	test   %al,%al
 635:	0f 85 72 ff ff ff    	jne    5ad <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
 63b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
 640:	c9                   	leave  
 641:	c3                   	ret    

00000642 <strtok>:

char *
strtok(char *s, const char *delim)
{
 642:	55                   	push   %ebp
 643:	89 e5                	mov    %esp,%ebp
 645:	53                   	push   %ebx
 646:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
 649:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 64d:	75 08                	jne    657 <strtok+0x15>
  s = lasts;
 64f:	a1 84 14 00 00       	mov    0x1484,%eax
 654:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
 657:	8b 45 08             	mov    0x8(%ebp),%eax
 65a:	8d 50 01             	lea    0x1(%eax),%edx
 65d:	89 55 08             	mov    %edx,0x8(%ebp)
 660:	8a 00                	mov    (%eax),%al
 662:	0f be d8             	movsbl %al,%ebx
 665:	85 db                	test   %ebx,%ebx
 667:	75 07                	jne    670 <strtok+0x2e>
      return 0;
 669:	b8 00 00 00 00       	mov    $0x0,%eax
 66e:	eb 58                	jmp    6c8 <strtok+0x86>
    } while (strchr(delim, ch));
 670:	88 d8                	mov    %bl,%al
 672:	0f be c0             	movsbl %al,%eax
 675:	89 44 24 04          	mov    %eax,0x4(%esp)
 679:	8b 45 0c             	mov    0xc(%ebp),%eax
 67c:	89 04 24             	mov    %eax,(%esp)
 67f:	e8 7e fe ff ff       	call   502 <strchr>
 684:	85 c0                	test   %eax,%eax
 686:	75 cf                	jne    657 <strtok+0x15>
    --s;
 688:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
 68b:	8b 45 0c             	mov    0xc(%ebp),%eax
 68e:	89 44 24 04          	mov    %eax,0x4(%esp)
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 31 00 00 00       	call   6ce <strcspn>
 69d:	89 c2                	mov    %eax,%edx
 69f:	8b 45 08             	mov    0x8(%ebp),%eax
 6a2:	01 d0                	add    %edx,%eax
 6a4:	a3 84 14 00 00       	mov    %eax,0x1484
    if (*lasts != 0)
 6a9:	a1 84 14 00 00       	mov    0x1484,%eax
 6ae:	8a 00                	mov    (%eax),%al
 6b0:	84 c0                	test   %al,%al
 6b2:	74 11                	je     6c5 <strtok+0x83>
  *lasts++ = 0;
 6b4:	a1 84 14 00 00       	mov    0x1484,%eax
 6b9:	8d 50 01             	lea    0x1(%eax),%edx
 6bc:	89 15 84 14 00 00    	mov    %edx,0x1484
 6c2:	c6 00 00             	movb   $0x0,(%eax)
    return s;
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6c8:	83 c4 14             	add    $0x14,%esp
 6cb:	5b                   	pop    %ebx
 6cc:	5d                   	pop    %ebp
 6cd:	c3                   	ret    

000006ce <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
 6ce:	55                   	push   %ebp
 6cf:	89 e5                	mov    %esp,%ebp
 6d1:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
 6d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
 6db:	eb 26                	jmp    703 <strcspn+0x35>
        if(strchr(s2,*s1))
 6dd:	8b 45 08             	mov    0x8(%ebp),%eax
 6e0:	8a 00                	mov    (%eax),%al
 6e2:	0f be c0             	movsbl %al,%eax
 6e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ec:	89 04 24             	mov    %eax,(%esp)
 6ef:	e8 0e fe ff ff       	call   502 <strchr>
 6f4:	85 c0                	test   %eax,%eax
 6f6:	74 05                	je     6fd <strcspn+0x2f>
            return ret;
 6f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6fb:	eb 12                	jmp    70f <strcspn+0x41>
        else
            s1++,ret++;
 6fd:	ff 45 08             	incl   0x8(%ebp)
 700:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	8a 00                	mov    (%eax),%al
 708:	84 c0                	test   %al,%al
 70a:	75 d1                	jne    6dd <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 70f:	c9                   	leave  
 710:	c3                   	ret    

00000711 <isspace>:

int
isspace(unsigned char c)
{
 711:	55                   	push   %ebp
 712:	89 e5                	mov    %esp,%ebp
 714:	83 ec 04             	sub    $0x4,%esp
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
 71d:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
 721:	74 1e                	je     741 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
 723:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
 727:	74 18                	je     741 <isspace+0x30>
 729:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
 72d:	74 12                	je     741 <isspace+0x30>
 72f:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
 733:	74 0c                	je     741 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
 735:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
 739:	74 06                	je     741 <isspace+0x30>
 73b:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
 73f:	75 07                	jne    748 <isspace+0x37>
 741:	b8 01 00 00 00       	mov    $0x1,%eax
 746:	eb 05                	jmp    74d <isspace+0x3c>
 748:	b8 00 00 00 00       	mov    $0x0,%eax
}
 74d:	c9                   	leave  
 74e:	c3                   	ret    

0000074f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
 74f:	55                   	push   %ebp
 750:	89 e5                	mov    %esp,%ebp
 752:	57                   	push   %edi
 753:	56                   	push   %esi
 754:	53                   	push   %ebx
 755:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
 758:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
 75d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
 764:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 767:	eb 01                	jmp    76a <strtoul+0x1b>
  p += 1;
 769:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 76a:	8a 03                	mov    (%ebx),%al
 76c:	0f b6 c0             	movzbl %al,%eax
 76f:	89 04 24             	mov    %eax,(%esp)
 772:	e8 9a ff ff ff       	call   711 <isspace>
 777:	85 c0                	test   %eax,%eax
 779:	75 ee                	jne    769 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
 77b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 77f:	75 30                	jne    7b1 <strtoul+0x62>
    {
  if (*p == '0') {
 781:	8a 03                	mov    (%ebx),%al
 783:	3c 30                	cmp    $0x30,%al
 785:	75 21                	jne    7a8 <strtoul+0x59>
      p += 1;
 787:	43                   	inc    %ebx
      if (*p == 'x') {
 788:	8a 03                	mov    (%ebx),%al
 78a:	3c 78                	cmp    $0x78,%al
 78c:	75 0a                	jne    798 <strtoul+0x49>
    p += 1;
 78e:	43                   	inc    %ebx
    base = 16;
 78f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
 796:	eb 31                	jmp    7c9 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
 798:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
 79f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
 7a6:	eb 21                	jmp    7c9 <strtoul+0x7a>
      }
  }
  else base = 10;
 7a8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
 7af:	eb 18                	jmp    7c9 <strtoul+0x7a>
    } else if (base == 16) {
 7b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 7b5:	75 12                	jne    7c9 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
 7b7:	8a 03                	mov    (%ebx),%al
 7b9:	3c 30                	cmp    $0x30,%al
 7bb:	75 0c                	jne    7c9 <strtoul+0x7a>
 7bd:	8d 43 01             	lea    0x1(%ebx),%eax
 7c0:	8a 00                	mov    (%eax),%al
 7c2:	3c 78                	cmp    $0x78,%al
 7c4:	75 03                	jne    7c9 <strtoul+0x7a>
      p += 2;
 7c6:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
 7c9:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
 7cd:	75 29                	jne    7f8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
 7cf:	8a 03                	mov    (%ebx),%al
 7d1:	0f be c0             	movsbl %al,%eax
 7d4:	83 e8 30             	sub    $0x30,%eax
 7d7:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
 7d9:	83 fe 07             	cmp    $0x7,%esi
 7dc:	76 06                	jbe    7e4 <strtoul+0x95>
    break;
 7de:	90                   	nop
 7df:	e9 b6 00 00 00       	jmp    89a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
 7e4:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
 7eb:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 7ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
 7f5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
 7f6:	eb d7                	jmp    7cf <strtoul+0x80>
    } else if (base == 10) {
 7f8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
 7fc:	75 2b                	jne    829 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
 7fe:	8a 03                	mov    (%ebx),%al
 800:	0f be c0             	movsbl %al,%eax
 803:	83 e8 30             	sub    $0x30,%eax
 806:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
 808:	83 fe 09             	cmp    $0x9,%esi
 80b:	76 06                	jbe    813 <strtoul+0xc4>
    break;
 80d:	90                   	nop
 80e:	e9 87 00 00 00       	jmp    89a <strtoul+0x14b>
      }
      result = (10*result) + digit;
 813:	89 f8                	mov    %edi,%eax
 815:	c1 e0 02             	shl    $0x2,%eax
 818:	01 f8                	add    %edi,%eax
 81a:	01 c0                	add    %eax,%eax
 81c:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 81f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
 826:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
 827:	eb d5                	jmp    7fe <strtoul+0xaf>
    } else if (base == 16) {
 829:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
 82d:	75 35                	jne    864 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
 82f:	8a 03                	mov    (%ebx),%al
 831:	0f be c0             	movsbl %al,%eax
 834:	83 e8 30             	sub    $0x30,%eax
 837:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 839:	83 fe 4a             	cmp    $0x4a,%esi
 83c:	76 02                	jbe    840 <strtoul+0xf1>
    break;
 83e:	eb 22                	jmp    862 <strtoul+0x113>
      }
      digit = cvtIn[digit];
 840:	8a 86 20 14 00 00    	mov    0x1420(%esi),%al
 846:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
 849:	83 fe 0f             	cmp    $0xf,%esi
 84c:	76 02                	jbe    850 <strtoul+0x101>
    break;
 84e:	eb 12                	jmp    862 <strtoul+0x113>
      }
      result = (result << 4) + digit;
 850:	89 f8                	mov    %edi,%eax
 852:	c1 e0 04             	shl    $0x4,%eax
 855:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 858:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
 85f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
 860:	eb cd                	jmp    82f <strtoul+0xe0>
 862:	eb 36                	jmp    89a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
 864:	8a 03                	mov    (%ebx),%al
 866:	0f be c0             	movsbl %al,%eax
 869:	83 e8 30             	sub    $0x30,%eax
 86c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
 86e:	83 fe 4a             	cmp    $0x4a,%esi
 871:	76 02                	jbe    875 <strtoul+0x126>
    break;
 873:	eb 25                	jmp    89a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
 875:	8a 86 20 14 00 00    	mov    0x1420(%esi),%al
 87b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
 87e:	8b 45 10             	mov    0x10(%ebp),%eax
 881:	39 f0                	cmp    %esi,%eax
 883:	77 02                	ja     887 <strtoul+0x138>
    break;
 885:	eb 13                	jmp    89a <strtoul+0x14b>
      }
      result = result*base + digit;
 887:	8b 45 10             	mov    0x10(%ebp),%eax
 88a:	0f af c7             	imul   %edi,%eax
 88d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
 890:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
 897:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
 898:	eb ca                	jmp    864 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
 89a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 89e:	75 03                	jne    8a3 <strtoul+0x154>
  p = string;
 8a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
 8a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 8a7:	74 05                	je     8ae <strtoul+0x15f>
  *endPtr = p;
 8a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 8ac:	89 18                	mov    %ebx,(%eax)
    }

    return result;
 8ae:	89 f8                	mov    %edi,%eax
}
 8b0:	83 c4 14             	add    $0x14,%esp
 8b3:	5b                   	pop    %ebx
 8b4:	5e                   	pop    %esi
 8b5:	5f                   	pop    %edi
 8b6:	5d                   	pop    %ebp
 8b7:	c3                   	ret    

000008b8 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
 8b8:	55                   	push   %ebp
 8b9:	89 e5                	mov    %esp,%ebp
 8bb:	53                   	push   %ebx
 8bc:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
 8bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
 8c2:	eb 01                	jmp    8c5 <strtol+0xd>
      p += 1;
 8c4:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
 8c5:	8a 03                	mov    (%ebx),%al
 8c7:	0f b6 c0             	movzbl %al,%eax
 8ca:	89 04 24             	mov    %eax,(%esp)
 8cd:	e8 3f fe ff ff       	call   711 <isspace>
 8d2:	85 c0                	test   %eax,%eax
 8d4:	75 ee                	jne    8c4 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
 8d6:	8a 03                	mov    (%ebx),%al
 8d8:	3c 2d                	cmp    $0x2d,%al
 8da:	75 1e                	jne    8fa <strtol+0x42>
  p += 1;
 8dc:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
 8dd:	8b 45 10             	mov    0x10(%ebp),%eax
 8e0:	89 44 24 08          	mov    %eax,0x8(%esp)
 8e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 8e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 8eb:	89 1c 24             	mov    %ebx,(%esp)
 8ee:	e8 5c fe ff ff       	call   74f <strtoul>
 8f3:	f7 d8                	neg    %eax
 8f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
 8f8:	eb 20                	jmp    91a <strtol+0x62>
    } else {
  if (*p == '+') {
 8fa:	8a 03                	mov    (%ebx),%al
 8fc:	3c 2b                	cmp    $0x2b,%al
 8fe:	75 01                	jne    901 <strtol+0x49>
      p += 1;
 900:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
 901:	8b 45 10             	mov    0x10(%ebp),%eax
 904:	89 44 24 08          	mov    %eax,0x8(%esp)
 908:	8b 45 0c             	mov    0xc(%ebp),%eax
 90b:	89 44 24 04          	mov    %eax,0x4(%esp)
 90f:	89 1c 24             	mov    %ebx,(%esp)
 912:	e8 38 fe ff ff       	call   74f <strtoul>
 917:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
 91a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
 91e:	75 17                	jne    937 <strtol+0x7f>
 920:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 924:	74 11                	je     937 <strtol+0x7f>
 926:	8b 45 0c             	mov    0xc(%ebp),%eax
 929:	8b 00                	mov    (%eax),%eax
 92b:	39 d8                	cmp    %ebx,%eax
 92d:	75 08                	jne    937 <strtol+0x7f>
  *endPtr = string;
 92f:	8b 45 0c             	mov    0xc(%ebp),%eax
 932:	8b 55 08             	mov    0x8(%ebp),%edx
 935:	89 10                	mov    %edx,(%eax)
    }
    return result;
 937:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 93a:	83 c4 1c             	add    $0x1c,%esp
 93d:	5b                   	pop    %ebx
 93e:	5d                   	pop    %ebp
 93f:	c3                   	ret    

00000940 <gets>:

char*
gets(char *buf, int max)
{
 940:	55                   	push   %ebp
 941:	89 e5                	mov    %esp,%ebp
 943:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 94d:	eb 49                	jmp    998 <gets+0x58>
    cc = read(0, &c, 1);
 94f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 956:	00 
 957:	8d 45 ef             	lea    -0x11(%ebp),%eax
 95a:	89 44 24 04          	mov    %eax,0x4(%esp)
 95e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 965:	e8 3e 01 00 00       	call   aa8 <read>
 96a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 96d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 971:	7f 02                	jg     975 <gets+0x35>
      break;
 973:	eb 2c                	jmp    9a1 <gets+0x61>
    buf[i++] = c;
 975:	8b 45 f4             	mov    -0xc(%ebp),%eax
 978:	8d 50 01             	lea    0x1(%eax),%edx
 97b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 97e:	89 c2                	mov    %eax,%edx
 980:	8b 45 08             	mov    0x8(%ebp),%eax
 983:	01 c2                	add    %eax,%edx
 985:	8a 45 ef             	mov    -0x11(%ebp),%al
 988:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 98a:	8a 45 ef             	mov    -0x11(%ebp),%al
 98d:	3c 0a                	cmp    $0xa,%al
 98f:	74 10                	je     9a1 <gets+0x61>
 991:	8a 45 ef             	mov    -0x11(%ebp),%al
 994:	3c 0d                	cmp    $0xd,%al
 996:	74 09                	je     9a1 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	40                   	inc    %eax
 99c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 99f:	7c ae                	jl     94f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 9a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9a4:	8b 45 08             	mov    0x8(%ebp),%eax
 9a7:	01 d0                	add    %edx,%eax
 9a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 9ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 9af:	c9                   	leave  
 9b0:	c3                   	ret    

000009b1 <stat>:

int
stat(char *n, struct stat *st)
{
 9b1:	55                   	push   %ebp
 9b2:	89 e5                	mov    %esp,%ebp
 9b4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 9b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9be:	00 
 9bf:	8b 45 08             	mov    0x8(%ebp),%eax
 9c2:	89 04 24             	mov    %eax,(%esp)
 9c5:	e8 06 01 00 00       	call   ad0 <open>
 9ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 9cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d1:	79 07                	jns    9da <stat+0x29>
    return -1;
 9d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 9d8:	eb 23                	jmp    9fd <stat+0x4c>
  r = fstat(fd, st);
 9da:	8b 45 0c             	mov    0xc(%ebp),%eax
 9dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e4:	89 04 24             	mov    %eax,(%esp)
 9e7:	e8 fc 00 00 00       	call   ae8 <fstat>
 9ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 9ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9f2:	89 04 24             	mov    %eax,(%esp)
 9f5:	e8 be 00 00 00       	call   ab8 <close>
  return r;
 9fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 9fd:	c9                   	leave  
 9fe:	c3                   	ret    

000009ff <atoi>:

int
atoi(const char *s)
{
 9ff:	55                   	push   %ebp
 a00:	89 e5                	mov    %esp,%ebp
 a02:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 a05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 a0c:	eb 24                	jmp    a32 <atoi+0x33>
    n = n*10 + *s++ - '0';
 a0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 a11:	89 d0                	mov    %edx,%eax
 a13:	c1 e0 02             	shl    $0x2,%eax
 a16:	01 d0                	add    %edx,%eax
 a18:	01 c0                	add    %eax,%eax
 a1a:	89 c1                	mov    %eax,%ecx
 a1c:	8b 45 08             	mov    0x8(%ebp),%eax
 a1f:	8d 50 01             	lea    0x1(%eax),%edx
 a22:	89 55 08             	mov    %edx,0x8(%ebp)
 a25:	8a 00                	mov    (%eax),%al
 a27:	0f be c0             	movsbl %al,%eax
 a2a:	01 c8                	add    %ecx,%eax
 a2c:	83 e8 30             	sub    $0x30,%eax
 a2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 a32:	8b 45 08             	mov    0x8(%ebp),%eax
 a35:	8a 00                	mov    (%eax),%al
 a37:	3c 2f                	cmp    $0x2f,%al
 a39:	7e 09                	jle    a44 <atoi+0x45>
 a3b:	8b 45 08             	mov    0x8(%ebp),%eax
 a3e:	8a 00                	mov    (%eax),%al
 a40:	3c 39                	cmp    $0x39,%al
 a42:	7e ca                	jle    a0e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 a44:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 a47:	c9                   	leave  
 a48:	c3                   	ret    

00000a49 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 a49:	55                   	push   %ebp
 a4a:	89 e5                	mov    %esp,%ebp
 a4c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
 a4f:	8b 45 08             	mov    0x8(%ebp),%eax
 a52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 a55:	8b 45 0c             	mov    0xc(%ebp),%eax
 a58:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 a5b:	eb 16                	jmp    a73 <memmove+0x2a>
    *dst++ = *src++;
 a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a60:	8d 50 01             	lea    0x1(%eax),%edx
 a63:	89 55 fc             	mov    %edx,-0x4(%ebp)
 a66:	8b 55 f8             	mov    -0x8(%ebp),%edx
 a69:	8d 4a 01             	lea    0x1(%edx),%ecx
 a6c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 a6f:	8a 12                	mov    (%edx),%dl
 a71:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 a73:	8b 45 10             	mov    0x10(%ebp),%eax
 a76:	8d 50 ff             	lea    -0x1(%eax),%edx
 a79:	89 55 10             	mov    %edx,0x10(%ebp)
 a7c:	85 c0                	test   %eax,%eax
 a7e:	7f dd                	jg     a5d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 a80:	8b 45 08             	mov    0x8(%ebp),%eax
}
 a83:	c9                   	leave  
 a84:	c3                   	ret    
 a85:	90                   	nop
 a86:	90                   	nop
 a87:	90                   	nop

00000a88 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 a88:	b8 01 00 00 00       	mov    $0x1,%eax
 a8d:	cd 40                	int    $0x40
 a8f:	c3                   	ret    

00000a90 <exit>:
SYSCALL(exit)
 a90:	b8 02 00 00 00       	mov    $0x2,%eax
 a95:	cd 40                	int    $0x40
 a97:	c3                   	ret    

00000a98 <wait>:
SYSCALL(wait)
 a98:	b8 03 00 00 00       	mov    $0x3,%eax
 a9d:	cd 40                	int    $0x40
 a9f:	c3                   	ret    

00000aa0 <pipe>:
SYSCALL(pipe)
 aa0:	b8 04 00 00 00       	mov    $0x4,%eax
 aa5:	cd 40                	int    $0x40
 aa7:	c3                   	ret    

00000aa8 <read>:
SYSCALL(read)
 aa8:	b8 05 00 00 00       	mov    $0x5,%eax
 aad:	cd 40                	int    $0x40
 aaf:	c3                   	ret    

00000ab0 <write>:
SYSCALL(write)
 ab0:	b8 10 00 00 00       	mov    $0x10,%eax
 ab5:	cd 40                	int    $0x40
 ab7:	c3                   	ret    

00000ab8 <close>:
SYSCALL(close)
 ab8:	b8 15 00 00 00       	mov    $0x15,%eax
 abd:	cd 40                	int    $0x40
 abf:	c3                   	ret    

00000ac0 <kill>:
SYSCALL(kill)
 ac0:	b8 06 00 00 00       	mov    $0x6,%eax
 ac5:	cd 40                	int    $0x40
 ac7:	c3                   	ret    

00000ac8 <exec>:
SYSCALL(exec)
 ac8:	b8 07 00 00 00       	mov    $0x7,%eax
 acd:	cd 40                	int    $0x40
 acf:	c3                   	ret    

00000ad0 <open>:
SYSCALL(open)
 ad0:	b8 0f 00 00 00       	mov    $0xf,%eax
 ad5:	cd 40                	int    $0x40
 ad7:	c3                   	ret    

00000ad8 <mknod>:
SYSCALL(mknod)
 ad8:	b8 11 00 00 00       	mov    $0x11,%eax
 add:	cd 40                	int    $0x40
 adf:	c3                   	ret    

00000ae0 <unlink>:
SYSCALL(unlink)
 ae0:	b8 12 00 00 00       	mov    $0x12,%eax
 ae5:	cd 40                	int    $0x40
 ae7:	c3                   	ret    

00000ae8 <fstat>:
SYSCALL(fstat)
 ae8:	b8 08 00 00 00       	mov    $0x8,%eax
 aed:	cd 40                	int    $0x40
 aef:	c3                   	ret    

00000af0 <link>:
SYSCALL(link)
 af0:	b8 13 00 00 00       	mov    $0x13,%eax
 af5:	cd 40                	int    $0x40
 af7:	c3                   	ret    

00000af8 <mkdir>:
SYSCALL(mkdir)
 af8:	b8 14 00 00 00       	mov    $0x14,%eax
 afd:	cd 40                	int    $0x40
 aff:	c3                   	ret    

00000b00 <chdir>:
SYSCALL(chdir)
 b00:	b8 09 00 00 00       	mov    $0x9,%eax
 b05:	cd 40                	int    $0x40
 b07:	c3                   	ret    

00000b08 <dup>:
SYSCALL(dup)
 b08:	b8 0a 00 00 00       	mov    $0xa,%eax
 b0d:	cd 40                	int    $0x40
 b0f:	c3                   	ret    

00000b10 <getpid>:
SYSCALL(getpid)
 b10:	b8 0b 00 00 00       	mov    $0xb,%eax
 b15:	cd 40                	int    $0x40
 b17:	c3                   	ret    

00000b18 <sbrk>:
SYSCALL(sbrk)
 b18:	b8 0c 00 00 00       	mov    $0xc,%eax
 b1d:	cd 40                	int    $0x40
 b1f:	c3                   	ret    

00000b20 <sleep>:
SYSCALL(sleep)
 b20:	b8 0d 00 00 00       	mov    $0xd,%eax
 b25:	cd 40                	int    $0x40
 b27:	c3                   	ret    

00000b28 <uptime>:
SYSCALL(uptime)
 b28:	b8 0e 00 00 00       	mov    $0xe,%eax
 b2d:	cd 40                	int    $0x40
 b2f:	c3                   	ret    

00000b30 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 b30:	55                   	push   %ebp
 b31:	89 e5                	mov    %esp,%ebp
 b33:	83 ec 18             	sub    $0x18,%esp
 b36:	8b 45 0c             	mov    0xc(%ebp),%eax
 b39:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 b3c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 b43:	00 
 b44:	8d 45 f4             	lea    -0xc(%ebp),%eax
 b47:	89 44 24 04          	mov    %eax,0x4(%esp)
 b4b:	8b 45 08             	mov    0x8(%ebp),%eax
 b4e:	89 04 24             	mov    %eax,(%esp)
 b51:	e8 5a ff ff ff       	call   ab0 <write>
}
 b56:	c9                   	leave  
 b57:	c3                   	ret    

00000b58 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 b58:	55                   	push   %ebp
 b59:	89 e5                	mov    %esp,%ebp
 b5b:	56                   	push   %esi
 b5c:	53                   	push   %ebx
 b5d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 b60:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 b67:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 b6b:	74 17                	je     b84 <printint+0x2c>
 b6d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 b71:	79 11                	jns    b84 <printint+0x2c>
    neg = 1;
 b73:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 b7a:	8b 45 0c             	mov    0xc(%ebp),%eax
 b7d:	f7 d8                	neg    %eax
 b7f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b82:	eb 06                	jmp    b8a <printint+0x32>
  } else {
    x = xx;
 b84:	8b 45 0c             	mov    0xc(%ebp),%eax
 b87:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 b8a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 b91:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 b94:	8d 41 01             	lea    0x1(%ecx),%eax
 b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
 b9a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 ba0:	ba 00 00 00 00       	mov    $0x0,%edx
 ba5:	f7 f3                	div    %ebx
 ba7:	89 d0                	mov    %edx,%eax
 ba9:	8a 80 6c 14 00 00    	mov    0x146c(%eax),%al
 baf:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 bb3:	8b 75 10             	mov    0x10(%ebp),%esi
 bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 bb9:	ba 00 00 00 00       	mov    $0x0,%edx
 bbe:	f7 f6                	div    %esi
 bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 bc3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bc7:	75 c8                	jne    b91 <printint+0x39>
  if(neg)
 bc9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 bcd:	74 10                	je     bdf <printint+0x87>
    buf[i++] = '-';
 bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd2:	8d 50 01             	lea    0x1(%eax),%edx
 bd5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 bd8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 bdd:	eb 1e                	jmp    bfd <printint+0xa5>
 bdf:	eb 1c                	jmp    bfd <printint+0xa5>
    putc(fd, buf[i]);
 be1:	8d 55 dc             	lea    -0x24(%ebp),%edx
 be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be7:	01 d0                	add    %edx,%eax
 be9:	8a 00                	mov    (%eax),%al
 beb:	0f be c0             	movsbl %al,%eax
 bee:	89 44 24 04          	mov    %eax,0x4(%esp)
 bf2:	8b 45 08             	mov    0x8(%ebp),%eax
 bf5:	89 04 24             	mov    %eax,(%esp)
 bf8:	e8 33 ff ff ff       	call   b30 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 bfd:	ff 4d f4             	decl   -0xc(%ebp)
 c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c04:	79 db                	jns    be1 <printint+0x89>
    putc(fd, buf[i]);
}
 c06:	83 c4 30             	add    $0x30,%esp
 c09:	5b                   	pop    %ebx
 c0a:	5e                   	pop    %esi
 c0b:	5d                   	pop    %ebp
 c0c:	c3                   	ret    

00000c0d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 c0d:	55                   	push   %ebp
 c0e:	89 e5                	mov    %esp,%ebp
 c10:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 c13:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 c1a:	8d 45 0c             	lea    0xc(%ebp),%eax
 c1d:	83 c0 04             	add    $0x4,%eax
 c20:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 c23:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 c2a:	e9 77 01 00 00       	jmp    da6 <printf+0x199>
    c = fmt[i] & 0xff;
 c2f:	8b 55 0c             	mov    0xc(%ebp),%edx
 c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c35:	01 d0                	add    %edx,%eax
 c37:	8a 00                	mov    (%eax),%al
 c39:	0f be c0             	movsbl %al,%eax
 c3c:	25 ff 00 00 00       	and    $0xff,%eax
 c41:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 c44:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 c48:	75 2c                	jne    c76 <printf+0x69>
      if(c == '%'){
 c4a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 c4e:	75 0c                	jne    c5c <printf+0x4f>
        state = '%';
 c50:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 c57:	e9 47 01 00 00       	jmp    da3 <printf+0x196>
      } else {
        putc(fd, c);
 c5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 c5f:	0f be c0             	movsbl %al,%eax
 c62:	89 44 24 04          	mov    %eax,0x4(%esp)
 c66:	8b 45 08             	mov    0x8(%ebp),%eax
 c69:	89 04 24             	mov    %eax,(%esp)
 c6c:	e8 bf fe ff ff       	call   b30 <putc>
 c71:	e9 2d 01 00 00       	jmp    da3 <printf+0x196>
      }
    } else if(state == '%'){
 c76:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 c7a:	0f 85 23 01 00 00    	jne    da3 <printf+0x196>
      if(c == 'd'){
 c80:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 c84:	75 2d                	jne    cb3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
 c86:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c89:	8b 00                	mov    (%eax),%eax
 c8b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 c92:	00 
 c93:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 c9a:	00 
 c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
 c9f:	8b 45 08             	mov    0x8(%ebp),%eax
 ca2:	89 04 24             	mov    %eax,(%esp)
 ca5:	e8 ae fe ff ff       	call   b58 <printint>
        ap++;
 caa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 cae:	e9 e9 00 00 00       	jmp    d9c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
 cb3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 cb7:	74 06                	je     cbf <printf+0xb2>
 cb9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 cbd:	75 2d                	jne    cec <printf+0xdf>
        printint(fd, *ap, 16, 0);
 cbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
 cc2:	8b 00                	mov    (%eax),%eax
 cc4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 ccb:	00 
 ccc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 cd3:	00 
 cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
 cd8:	8b 45 08             	mov    0x8(%ebp),%eax
 cdb:	89 04 24             	mov    %eax,(%esp)
 cde:	e8 75 fe ff ff       	call   b58 <printint>
        ap++;
 ce3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 ce7:	e9 b0 00 00 00       	jmp    d9c <printf+0x18f>
      } else if(c == 's'){
 cec:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 cf0:	75 42                	jne    d34 <printf+0x127>
        s = (char*)*ap;
 cf2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 cf5:	8b 00                	mov    (%eax),%eax
 cf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 cfa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 cfe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d02:	75 09                	jne    d0d <printf+0x100>
          s = "(null)";
 d04:	c7 45 f4 5c 10 00 00 	movl   $0x105c,-0xc(%ebp)
        while(*s != 0){
 d0b:	eb 1c                	jmp    d29 <printf+0x11c>
 d0d:	eb 1a                	jmp    d29 <printf+0x11c>
          putc(fd, *s);
 d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d12:	8a 00                	mov    (%eax),%al
 d14:	0f be c0             	movsbl %al,%eax
 d17:	89 44 24 04          	mov    %eax,0x4(%esp)
 d1b:	8b 45 08             	mov    0x8(%ebp),%eax
 d1e:	89 04 24             	mov    %eax,(%esp)
 d21:	e8 0a fe ff ff       	call   b30 <putc>
          s++;
 d26:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 d29:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2c:	8a 00                	mov    (%eax),%al
 d2e:	84 c0                	test   %al,%al
 d30:	75 dd                	jne    d0f <printf+0x102>
 d32:	eb 68                	jmp    d9c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 d34:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 d38:	75 1d                	jne    d57 <printf+0x14a>
        putc(fd, *ap);
 d3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 d3d:	8b 00                	mov    (%eax),%eax
 d3f:	0f be c0             	movsbl %al,%eax
 d42:	89 44 24 04          	mov    %eax,0x4(%esp)
 d46:	8b 45 08             	mov    0x8(%ebp),%eax
 d49:	89 04 24             	mov    %eax,(%esp)
 d4c:	e8 df fd ff ff       	call   b30 <putc>
        ap++;
 d51:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 d55:	eb 45                	jmp    d9c <printf+0x18f>
      } else if(c == '%'){
 d57:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 d5b:	75 17                	jne    d74 <printf+0x167>
        putc(fd, c);
 d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 d60:	0f be c0             	movsbl %al,%eax
 d63:	89 44 24 04          	mov    %eax,0x4(%esp)
 d67:	8b 45 08             	mov    0x8(%ebp),%eax
 d6a:	89 04 24             	mov    %eax,(%esp)
 d6d:	e8 be fd ff ff       	call   b30 <putc>
 d72:	eb 28                	jmp    d9c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 d74:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 d7b:	00 
 d7c:	8b 45 08             	mov    0x8(%ebp),%eax
 d7f:	89 04 24             	mov    %eax,(%esp)
 d82:	e8 a9 fd ff ff       	call   b30 <putc>
        putc(fd, c);
 d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 d8a:	0f be c0             	movsbl %al,%eax
 d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
 d91:	8b 45 08             	mov    0x8(%ebp),%eax
 d94:	89 04 24             	mov    %eax,(%esp)
 d97:	e8 94 fd ff ff       	call   b30 <putc>
      }
      state = 0;
 d9c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 da3:	ff 45 f0             	incl   -0x10(%ebp)
 da6:	8b 55 0c             	mov    0xc(%ebp),%edx
 da9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 dac:	01 d0                	add    %edx,%eax
 dae:	8a 00                	mov    (%eax),%al
 db0:	84 c0                	test   %al,%al
 db2:	0f 85 77 fe ff ff    	jne    c2f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 db8:	c9                   	leave  
 db9:	c3                   	ret    
 dba:	90                   	nop
 dbb:	90                   	nop

00000dbc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 dbc:	55                   	push   %ebp
 dbd:	89 e5                	mov    %esp,%ebp
 dbf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 dc2:	8b 45 08             	mov    0x8(%ebp),%eax
 dc5:	83 e8 08             	sub    $0x8,%eax
 dc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 dcb:	a1 90 14 00 00       	mov    0x1490,%eax
 dd0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 dd3:	eb 24                	jmp    df9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dd5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dd8:	8b 00                	mov    (%eax),%eax
 dda:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 ddd:	77 12                	ja     df1 <free+0x35>
 ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 de2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 de5:	77 24                	ja     e0b <free+0x4f>
 de7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dea:	8b 00                	mov    (%eax),%eax
 dec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 def:	77 1a                	ja     e0b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 df1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 df4:	8b 00                	mov    (%eax),%eax
 df6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 df9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dfc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 dff:	76 d4                	jbe    dd5 <free+0x19>
 e01:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e04:	8b 00                	mov    (%eax),%eax
 e06:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 e09:	76 ca                	jbe    dd5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 e0b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e0e:	8b 40 04             	mov    0x4(%eax),%eax
 e11:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e1b:	01 c2                	add    %eax,%edx
 e1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e20:	8b 00                	mov    (%eax),%eax
 e22:	39 c2                	cmp    %eax,%edx
 e24:	75 24                	jne    e4a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 e26:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e29:	8b 50 04             	mov    0x4(%eax),%edx
 e2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e2f:	8b 00                	mov    (%eax),%eax
 e31:	8b 40 04             	mov    0x4(%eax),%eax
 e34:	01 c2                	add    %eax,%edx
 e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e39:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e3f:	8b 00                	mov    (%eax),%eax
 e41:	8b 10                	mov    (%eax),%edx
 e43:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e46:	89 10                	mov    %edx,(%eax)
 e48:	eb 0a                	jmp    e54 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e4d:	8b 10                	mov    (%eax),%edx
 e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e52:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 e54:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e57:	8b 40 04             	mov    0x4(%eax),%eax
 e5a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e64:	01 d0                	add    %edx,%eax
 e66:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 e69:	75 20                	jne    e8b <free+0xcf>
    p->s.size += bp->s.size;
 e6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e6e:	8b 50 04             	mov    0x4(%eax),%edx
 e71:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e74:	8b 40 04             	mov    0x4(%eax),%eax
 e77:	01 c2                	add    %eax,%edx
 e79:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e7c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 e7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 e82:	8b 10                	mov    (%eax),%edx
 e84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e87:	89 10                	mov    %edx,(%eax)
 e89:	eb 08                	jmp    e93 <free+0xd7>
  } else
    p->s.ptr = bp;
 e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 e91:	89 10                	mov    %edx,(%eax)
  freep = p;
 e93:	8b 45 fc             	mov    -0x4(%ebp),%eax
 e96:	a3 90 14 00 00       	mov    %eax,0x1490
}
 e9b:	c9                   	leave  
 e9c:	c3                   	ret    

00000e9d <morecore>:

static Header*
morecore(uint nu)
{
 e9d:	55                   	push   %ebp
 e9e:	89 e5                	mov    %esp,%ebp
 ea0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 ea3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 eaa:	77 07                	ja     eb3 <morecore+0x16>
    nu = 4096;
 eac:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 eb3:	8b 45 08             	mov    0x8(%ebp),%eax
 eb6:	c1 e0 03             	shl    $0x3,%eax
 eb9:	89 04 24             	mov    %eax,(%esp)
 ebc:	e8 57 fc ff ff       	call   b18 <sbrk>
 ec1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 ec4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 ec8:	75 07                	jne    ed1 <morecore+0x34>
    return 0;
 eca:	b8 00 00 00 00       	mov    $0x0,%eax
 ecf:	eb 22                	jmp    ef3 <morecore+0x56>
  hp = (Header*)p;
 ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ed4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 ed7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eda:	8b 55 08             	mov    0x8(%ebp),%edx
 edd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ee3:	83 c0 08             	add    $0x8,%eax
 ee6:	89 04 24             	mov    %eax,(%esp)
 ee9:	e8 ce fe ff ff       	call   dbc <free>
  return freep;
 eee:	a1 90 14 00 00       	mov    0x1490,%eax
}
 ef3:	c9                   	leave  
 ef4:	c3                   	ret    

00000ef5 <malloc>:

void*
malloc(uint nbytes)
{
 ef5:	55                   	push   %ebp
 ef6:	89 e5                	mov    %esp,%ebp
 ef8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 efb:	8b 45 08             	mov    0x8(%ebp),%eax
 efe:	83 c0 07             	add    $0x7,%eax
 f01:	c1 e8 03             	shr    $0x3,%eax
 f04:	40                   	inc    %eax
 f05:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 f08:	a1 90 14 00 00       	mov    0x1490,%eax
 f0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 f10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 f14:	75 23                	jne    f39 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
 f16:	c7 45 f0 88 14 00 00 	movl   $0x1488,-0x10(%ebp)
 f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f20:	a3 90 14 00 00       	mov    %eax,0x1490
 f25:	a1 90 14 00 00       	mov    0x1490,%eax
 f2a:	a3 88 14 00 00       	mov    %eax,0x1488
    base.s.size = 0;
 f2f:	c7 05 8c 14 00 00 00 	movl   $0x0,0x148c
 f36:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f3c:	8b 00                	mov    (%eax),%eax
 f3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f44:	8b 40 04             	mov    0x4(%eax),%eax
 f47:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 f4a:	72 4d                	jb     f99 <malloc+0xa4>
      if(p->s.size == nunits)
 f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f4f:	8b 40 04             	mov    0x4(%eax),%eax
 f52:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 f55:	75 0c                	jne    f63 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
 f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f5a:	8b 10                	mov    (%eax),%edx
 f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f5f:	89 10                	mov    %edx,(%eax)
 f61:	eb 26                	jmp    f89 <malloc+0x94>
      else {
        p->s.size -= nunits;
 f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f66:	8b 40 04             	mov    0x4(%eax),%eax
 f69:	2b 45 ec             	sub    -0x14(%ebp),%eax
 f6c:	89 c2                	mov    %eax,%edx
 f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f71:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f77:	8b 40 04             	mov    0x4(%eax),%eax
 f7a:	c1 e0 03             	shl    $0x3,%eax
 f7d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f83:	8b 55 ec             	mov    -0x14(%ebp),%edx
 f86:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 f89:	8b 45 f0             	mov    -0x10(%ebp),%eax
 f8c:	a3 90 14 00 00       	mov    %eax,0x1490
      return (void*)(p + 1);
 f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f94:	83 c0 08             	add    $0x8,%eax
 f97:	eb 38                	jmp    fd1 <malloc+0xdc>
    }
    if(p == freep)
 f99:	a1 90 14 00 00       	mov    0x1490,%eax
 f9e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 fa1:	75 1b                	jne    fbe <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
 fa3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 fa6:	89 04 24             	mov    %eax,(%esp)
 fa9:	e8 ef fe ff ff       	call   e9d <morecore>
 fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
 fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 fb5:	75 07                	jne    fbe <malloc+0xc9>
        return 0;
 fb7:	b8 00 00 00 00       	mov    $0x0,%eax
 fbc:	eb 13                	jmp    fd1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 fbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 fc7:	8b 00                	mov    (%eax),%eax
 fc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 fcc:	e9 70 ff ff ff       	jmp    f41 <malloc+0x4c>
}
 fd1:	c9                   	leave  
 fd2:	c3                   	ret    
