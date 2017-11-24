
_ctool:     file format elf32-i386


Disassembly of section .text:

00000000 <print_usage>:
  struct container tuperwares[4];
  int count;
} ctable;

void print_usage(int mode)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  if(mode == 0) // not enough arguments
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 14                	jne    20 <print_usage+0x20>
  {
    printf(1, "Usage: ctool <mode> <args>\n");
       c:	c7 44 24 04 00 13 00 	movl   $0x1300,0x4(%esp)
      13:	00 
      14:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      1b:	e8 19 0f 00 00       	call   f39 <printf>
  }
  if(mode == 1) // create
      20:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
      24:	75 14                	jne    3a <print_usage+0x3a>
  {
    printf(1, "Usage: ctool create <max proc> <max mem> <max disk> <container> <exec1> <exec2> ...\n");
      26:	c7 44 24 04 1c 13 00 	movl   $0x131c,0x4(%esp)
      2d:	00 
      2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      35:	e8 ff 0e 00 00       	call   f39 <printf>
  }
  if(mode == 2) // create with container created
      3a:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
      3e:	75 14                	jne    54 <print_usage+0x54>
  {
    printf(1, "Container taken. Failed to create, exiting...\n");
      40:	c7 44 24 04 74 13 00 	movl   $0x1374,0x4(%esp)
      47:	00 
      48:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      4f:	e8 e5 0e 00 00       	call   f39 <printf>
  }
  if(mode == 3) // start
      54:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
      58:	75 14                	jne    6e <print_usage+0x6e>
  {
    printf(1, "Usage: ctool start <console> <container> <exec>\n");
      5a:	c7 44 24 04 a4 13 00 	movl   $0x13a4,0x4(%esp)
      61:	00 
      62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      69:	e8 cb 0e 00 00       	call   f39 <printf>
  }
  
  exit();
      6e:	e8 49 0d 00 00       	call   dbc <exit>

00000073 <is_int>:
}

int is_int(char c)
{
      73:	55                   	push   %ebp
      74:	89 e5                	mov    %esp,%ebp
      76:	83 ec 04             	sub    $0x4,%esp
      79:	8b 45 08             	mov    0x8(%ebp),%eax
      7c:	88 45 fc             	mov    %al,-0x4(%ebp)
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
      7f:	80 7d fc 30          	cmpb   $0x30,-0x4(%ebp)
      83:	74 36                	je     bb <is_int+0x48>
  exit();
}

int is_int(char c)
{
  return c == '0' || c == '1' || c == '2' || c == '3' || c == '4' ||
      85:	80 7d fc 31          	cmpb   $0x31,-0x4(%ebp)
      89:	74 30                	je     bb <is_int+0x48>
      8b:	80 7d fc 32          	cmpb   $0x32,-0x4(%ebp)
      8f:	74 2a                	je     bb <is_int+0x48>
      91:	80 7d fc 33          	cmpb   $0x33,-0x4(%ebp)
      95:	74 24                	je     bb <is_int+0x48>
      97:	80 7d fc 34          	cmpb   $0x34,-0x4(%ebp)
      9b:	74 1e                	je     bb <is_int+0x48>
      9d:	80 7d fc 35          	cmpb   $0x35,-0x4(%ebp)
      a1:	74 18                	je     bb <is_int+0x48>
         c == '5' || c == '6' || c == '7' || c == '8' || c == '9';
      a3:	80 7d fc 36          	cmpb   $0x36,-0x4(%ebp)
      a7:	74 12                	je     bb <is_int+0x48>
      a9:	80 7d fc 37          	cmpb   $0x37,-0x4(%ebp)
      ad:	74 0c                	je     bb <is_int+0x48>
      af:	80 7d fc 38          	cmpb   $0x38,-0x4(%ebp)
      b3:	74 06                	je     bb <is_int+0x48>
      b5:	80 7d fc 39          	cmpb   $0x39,-0x4(%ebp)
      b9:	75 07                	jne    c2 <is_int+0x4f>
      bb:	b8 01 00 00 00       	mov    $0x1,%eax
      c0:	eb 05                	jmp    c7 <is_int+0x54>
      c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
      c7:	c9                   	leave  
      c8:	c3                   	ret    

000000c9 <start>:

// ctool start vc0 c0 usfsh
int start(int argc, char *argv[])
{
      c9:	55                   	push   %ebp
      ca:	89 e5                	mov    %esp,%ebp
      cc:	83 ec 28             	sub    $0x28,%esp
  int id, fd;
  fd = open(argv[2], O_RDWR);
      cf:	8b 45 0c             	mov    0xc(%ebp),%eax
      d2:	83 c0 08             	add    $0x8,%eax
      d5:	8b 00                	mov    (%eax),%eax
      d7:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
      de:	00 
      df:	89 04 24             	mov    %eax,(%esp)
      e2:	e8 15 0d 00 00       	call   dfc <open>
      e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "fd = %d\n", fd);
      ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
      ed:	89 44 24 08          	mov    %eax,0x8(%esp)
      f1:	c7 44 24 04 d5 13 00 	movl   $0x13d5,0x4(%esp)
      f8:	00 
      f9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     100:	e8 34 0e 00 00       	call   f39 <printf>

  /* fork a child and exec argv[4] */
  id = fork();
     105:	e8 aa 0c 00 00       	call   db4 <fork>
     10a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(id == 0)
     10d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     111:	0f 85 9c 00 00 00    	jne    1b3 <start+0xea>
  {
    close(0);
     117:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     11e:	e8 c1 0c 00 00       	call   de4 <close>
    close(1);
     123:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     12a:	e8 b5 0c 00 00       	call   de4 <close>
    close(2);
     12f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     136:	e8 a9 0c 00 00       	call   de4 <close>
    dup(fd);
     13b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     13e:	89 04 24             	mov    %eax,(%esp)
     141:	e8 ee 0c 00 00       	call   e34 <dup>
    dup(fd);
     146:	8b 45 f4             	mov    -0xc(%ebp),%eax
     149:	89 04 24             	mov    %eax,(%esp)
     14c:	e8 e3 0c 00 00       	call   e34 <dup>
    dup(fd);
     151:	8b 45 f4             	mov    -0xc(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 d8 0c 00 00       	call   e34 <dup>
    if(chdir(argv[3]) < 0)
     15c:	8b 45 0c             	mov    0xc(%ebp),%eax
     15f:	83 c0 0c             	add    $0xc,%eax
     162:	8b 00                	mov    (%eax),%eax
     164:	89 04 24             	mov    %eax,(%esp)
     167:	e8 c0 0c 00 00       	call   e2c <chdir>
     16c:	85 c0                	test   %eax,%eax
     16e:	79 19                	jns    189 <start+0xc0>
    {
      printf(1, "Container does not exist.");
     170:	c7 44 24 04 de 13 00 	movl   $0x13de,0x4(%esp)
     177:	00 
     178:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     17f:	e8 b5 0d 00 00       	call   f39 <printf>
      exit();
     184:	e8 33 0c 00 00       	call   dbc <exit>
    }
    exec(argv[4], &argv[4]);
     189:	8b 45 0c             	mov    0xc(%ebp),%eax
     18c:	8d 50 10             	lea    0x10(%eax),%edx
     18f:	8b 45 0c             	mov    0xc(%ebp),%eax
     192:	83 c0 10             	add    $0x10,%eax
     195:	8b 00                	mov    (%eax),%eax
     197:	89 54 24 04          	mov    %edx,0x4(%esp)
     19b:	89 04 24             	mov    %eax,(%esp)
     19e:	e8 51 0c 00 00       	call   df4 <exec>
    close(fd);
     1a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1a6:	89 04 24             	mov    %eax,(%esp)
     1a9:	e8 36 0c 00 00       	call   de4 <close>
    exit();
     1ae:	e8 09 0c 00 00       	call   dbc <exit>
  }

  return 0;
     1b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
     1b8:	c9                   	leave  
     1b9:	c3                   	ret    

000001ba <create>:

// ctool create c0 8 8 8 cat ls echo sh ...
int create(int argc, char *argv[])
{
     1ba:	55                   	push   %ebp
     1bb:	89 e5                	mov    %esp,%ebp
     1bd:	53                   	push   %ebx
     1be:	83 ec 54             	sub    $0x54,%esp
  int i, id, bytes, cindex = 0;
     1c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  char *mkdir[2];
  mkdir[0] = "mkdir";
     1c8:	c7 45 e0 f8 13 00 00 	movl   $0x13f8,-0x20(%ebp)
  mkdir[1] = argv[2];
     1cf:	8b 45 0c             	mov    0xc(%ebp),%eax
     1d2:	8b 40 08             	mov    0x8(%eax),%eax
     1d5:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  while(!is_int(argv[2][cindex]))
     1d8:	eb 03                	jmp    1dd <create+0x23>
  {
    cindex = cindex + 1;
     1da:	ff 45 f0             	incl   -0x10(%ebp)
  int i, id, bytes, cindex = 0;
  char *mkdir[2];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  while(!is_int(argv[2][cindex]))
     1dd:	8b 45 0c             	mov    0xc(%ebp),%eax
     1e0:	83 c0 08             	add    $0x8,%eax
     1e3:	8b 10                	mov    (%eax),%edx
     1e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1e8:	01 d0                	add    %edx,%eax
     1ea:	8a 00                	mov    (%eax),%al
     1ec:	0f be c0             	movsbl %al,%eax
     1ef:	89 04 24             	mov    %eax,(%esp)
     1f2:	e8 7c fe ff ff       	call   73 <is_int>
     1f7:	85 c0                	test   %eax,%eax
     1f9:	74 df                	je     1da <create+0x20>
  {
    cindex = cindex + 1;
  }

  strcpy(ctable.tuperwares[cindex].name, argv[2]);
     1fb:	8b 45 0c             	mov    0xc(%ebp),%eax
     1fe:	83 c0 08             	add    $0x8,%eax
     201:	8b 08                	mov    (%eax),%ecx
     203:	8b 55 f0             	mov    -0x10(%ebp),%edx
     206:	89 d0                	mov    %edx,%eax
     208:	01 c0                	add    %eax,%eax
     20a:	01 d0                	add    %edx,%eax
     20c:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     213:	01 d8                	add    %ebx,%eax
     215:	01 d0                	add    %edx,%eax
     217:	05 40 19 00 00       	add    $0x1940,%eax
     21c:	8b 00                	mov    (%eax),%eax
     21e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
     222:	89 04 24             	mov    %eax,(%esp)
     225:	e8 07 04 00 00       	call   631 <strcpy>
  ctable.count = ctable.count + 1;
     22a:	a1 b0 19 00 00       	mov    0x19b0,%eax
     22f:	40                   	inc    %eax
     230:	a3 b0 19 00 00       	mov    %eax,0x19b0
  ctable.tuperwares[cindex].max_proc = atoi(argv[3]);
     235:	8b 45 0c             	mov    0xc(%ebp),%eax
     238:	83 c0 0c             	add    $0xc,%eax
     23b:	8b 00                	mov    (%eax),%eax
     23d:	89 04 24             	mov    %eax,(%esp)
     240:	e8 e6 0a 00 00       	call   d2b <atoi>
     245:	89 c1                	mov    %eax,%ecx
     247:	8b 55 f0             	mov    -0x10(%ebp),%edx
     24a:	89 d0                	mov    %edx,%eax
     24c:	01 c0                	add    %eax,%eax
     24e:	01 d0                	add    %edx,%eax
     250:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     257:	01 d8                	add    %ebx,%eax
     259:	01 d0                	add    %edx,%eax
     25b:	05 40 19 00 00       	add    $0x1940,%eax
     260:	89 48 08             	mov    %ecx,0x8(%eax)
  ctable.tuperwares[cindex].max_mem = atoi(argv[4])*1000000;
     263:	8b 45 0c             	mov    0xc(%ebp),%eax
     266:	83 c0 10             	add    $0x10,%eax
     269:	8b 00                	mov    (%eax),%eax
     26b:	89 04 24             	mov    %eax,(%esp)
     26e:	e8 b8 0a 00 00       	call   d2b <atoi>
     273:	89 c2                	mov    %eax,%edx
     275:	89 d0                	mov    %edx,%eax
     277:	c1 e0 02             	shl    $0x2,%eax
     27a:	01 d0                	add    %edx,%eax
     27c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     283:	01 d0                	add    %edx,%eax
     285:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     28c:	01 d0                	add    %edx,%eax
     28e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     295:	01 d0                	add    %edx,%eax
     297:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     29e:	01 d0                	add    %edx,%eax
     2a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2a7:	01 d0                	add    %edx,%eax
     2a9:	c1 e0 06             	shl    $0x6,%eax
     2ac:	89 c1                	mov    %eax,%ecx
     2ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
     2b1:	89 d0                	mov    %edx,%eax
     2b3:	01 c0                	add    %eax,%eax
     2b5:	01 d0                	add    %edx,%eax
     2b7:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     2be:	01 d8                	add    %ebx,%eax
     2c0:	01 d0                	add    %edx,%eax
     2c2:	05 40 19 00 00       	add    $0x1940,%eax
     2c7:	89 48 0c             	mov    %ecx,0xc(%eax)
  ctable.tuperwares[cindex].max_disk = atoi(argv[5])*1000000;
     2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
     2cd:	83 c0 14             	add    $0x14,%eax
     2d0:	8b 00                	mov    (%eax),%eax
     2d2:	89 04 24             	mov    %eax,(%esp)
     2d5:	e8 51 0a 00 00       	call   d2b <atoi>
     2da:	89 c2                	mov    %eax,%edx
     2dc:	89 d0                	mov    %edx,%eax
     2de:	c1 e0 02             	shl    $0x2,%eax
     2e1:	01 d0                	add    %edx,%eax
     2e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2ea:	01 d0                	add    %edx,%eax
     2ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2f3:	01 d0                	add    %edx,%eax
     2f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     2fc:	01 d0                	add    %edx,%eax
     2fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     305:	01 d0                	add    %edx,%eax
     307:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     30e:	01 d0                	add    %edx,%eax
     310:	c1 e0 06             	shl    $0x6,%eax
     313:	89 c1                	mov    %eax,%ecx
     315:	8b 55 f0             	mov    -0x10(%ebp),%edx
     318:	89 d0                	mov    %edx,%eax
     31a:	01 c0                	add    %eax,%eax
     31c:	01 d0                	add    %edx,%eax
     31e:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     325:	01 d8                	add    %ebx,%eax
     327:	01 d0                	add    %edx,%eax
     329:	05 50 19 00 00       	add    $0x1950,%eax
     32e:	89 08                	mov    %ecx,(%eax)
  ctable.tuperwares[cindex].used_mem = 0;
     330:	8b 55 f0             	mov    -0x10(%ebp),%edx
     333:	89 d0                	mov    %edx,%eax
     335:	01 c0                	add    %eax,%eax
     337:	01 d0                	add    %edx,%eax
     339:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     340:	01 c8                	add    %ecx,%eax
     342:	01 d0                	add    %edx,%eax
     344:	05 50 19 00 00       	add    $0x1950,%eax
     349:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  ctable.tuperwares[cindex].used_disk = 0;
     350:	8b 55 f0             	mov    -0x10(%ebp),%edx
     353:	89 d0                	mov    %edx,%eax
     355:	01 c0                	add    %eax,%eax
     357:	01 d0                	add    %edx,%eax
     359:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     360:	01 c8                	add    %ecx,%eax
     362:	01 d0                	add    %edx,%eax
     364:	05 50 19 00 00       	add    $0x1950,%eax
     369:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

  id = fork();
     370:	e8 3f 0a 00 00       	call   db4 <fork>
     375:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0)
     378:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     37c:	75 12                	jne    390 <create+0x1d6>
  {
    exec(mkdir[0], mkdir);
     37e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     381:	8d 55 e0             	lea    -0x20(%ebp),%edx
     384:	89 54 24 04          	mov    %edx,0x4(%esp)
     388:	89 04 24             	mov    %eax,(%esp)
     38b:	e8 64 0a 00 00       	call   df4 <exec>
  }
  id = wait();
     390:	e8 2f 0a 00 00       	call   dc4 <wait>
     395:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for(i = 6; i < argc; i++) // going through ls echo cat ...
     398:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     39f:	e9 8f 01 00 00       	jmp    533 <create+0x379>
  {
    char destination[32];

    strcpy(destination, "/");
     3a4:	c7 44 24 04 fe 13 00 	movl   $0x13fe,0x4(%esp)
     3ab:	00 
     3ac:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3af:	89 04 24             	mov    %eax,(%esp)
     3b2:	e8 7a 02 00 00       	call   631 <strcpy>
    strcat(destination, mkdir[1]);
     3b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     3ba:	89 44 24 04          	mov    %eax,0x4(%esp)
     3be:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3c1:	89 04 24             	mov    %eax,(%esp)
     3c4:	e8 95 04 00 00       	call   85e <strcat>
    strcat(destination, "/");
     3c9:	c7 44 24 04 fe 13 00 	movl   $0x13fe,0x4(%esp)
     3d0:	00 
     3d1:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3d4:	89 04 24             	mov    %eax,(%esp)
     3d7:	e8 82 04 00 00       	call   85e <strcat>
    strcat(destination, argv[i]);
     3dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3df:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     3e6:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e9:	01 d0                	add    %edx,%eax
     3eb:	8b 00                	mov    (%eax),%eax
     3ed:	89 44 24 04          	mov    %eax,0x4(%esp)
     3f1:	8d 45 b8             	lea    -0x48(%ebp),%eax
     3f4:	89 04 24             	mov    %eax,(%esp)
     3f7:	e8 62 04 00 00       	call   85e <strcat>
    strcat(destination, "\0");
     3fc:	c7 44 24 04 00 14 00 	movl   $0x1400,0x4(%esp)
     403:	00 
     404:	8d 45 b8             	lea    -0x48(%ebp),%eax
     407:	89 04 24             	mov    %eax,(%esp)
     40a:	e8 4f 04 00 00       	call   85e <strcat>

    bytes = copy(argv[i], destination, ctable.tuperwares[cindex].used_disk, ctable.tuperwares[cindex].max_disk);
     40f:	8b 55 f0             	mov    -0x10(%ebp),%edx
     412:	89 d0                	mov    %edx,%eax
     414:	01 c0                	add    %eax,%eax
     416:	01 d0                	add    %edx,%eax
     418:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     41f:	01 c8                	add    %ecx,%eax
     421:	01 d0                	add    %edx,%eax
     423:	05 50 19 00 00       	add    $0x1950,%eax
     428:	8b 08                	mov    (%eax),%ecx
     42a:	8b 55 f0             	mov    -0x10(%ebp),%edx
     42d:	89 d0                	mov    %edx,%eax
     42f:	01 c0                	add    %eax,%eax
     431:	01 d0                	add    %edx,%eax
     433:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     43a:	01 d8                	add    %ebx,%eax
     43c:	01 d0                	add    %edx,%eax
     43e:	05 50 19 00 00       	add    $0x1950,%eax
     443:	8b 50 08             	mov    0x8(%eax),%edx
     446:	8b 45 f4             	mov    -0xc(%ebp),%eax
     449:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
     450:	8b 45 0c             	mov    0xc(%ebp),%eax
     453:	01 d8                	add    %ebx,%eax
     455:	8b 00                	mov    (%eax),%eax
     457:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     45b:	89 54 24 08          	mov    %edx,0x8(%esp)
     45f:	8d 55 b8             	lea    -0x48(%ebp),%edx
     462:	89 54 24 04          	mov    %edx,0x4(%esp)
     466:	89 04 24             	mov    %eax,(%esp)
     469:	e8 f1 01 00 00       	call   65f <copy>
     46e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Bytes for each file: %d\n", bytes);
     471:	8b 45 e8             	mov    -0x18(%ebp),%eax
     474:	89 44 24 08          	mov    %eax,0x8(%esp)
     478:	c7 44 24 04 02 14 00 	movl   $0x1402,0x4(%esp)
     47f:	00 
     480:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     487:	e8 ad 0a 00 00       	call   f39 <printf>

    if(bytes > 0)
     48c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     490:	7e 40                	jle    4d2 <create+0x318>
    {
      ctable.tuperwares[cindex].used_disk += bytes; 
     492:	8b 55 f0             	mov    -0x10(%ebp),%edx
     495:	89 d0                	mov    %edx,%eax
     497:	01 c0                	add    %eax,%eax
     499:	01 d0                	add    %edx,%eax
     49b:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     4a2:	01 c8                	add    %ecx,%eax
     4a4:	01 d0                	add    %edx,%eax
     4a6:	05 50 19 00 00       	add    $0x1950,%eax
     4ab:	8b 50 08             	mov    0x8(%eax),%edx
     4ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
     4b1:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
     4b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
     4b7:	89 d0                	mov    %edx,%eax
     4b9:	01 c0                	add    %eax,%eax
     4bb:	01 d0                	add    %edx,%eax
     4bd:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     4c4:	01 d8                	add    %ebx,%eax
     4c6:	01 d0                	add    %edx,%eax
     4c8:	05 50 19 00 00       	add    $0x1950,%eax
     4cd:	89 48 08             	mov    %ecx,0x8(%eax)
     4d0:	eb 5e                	jmp    530 <create+0x376>
    }
    else
    {
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
     4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     4dc:	8b 45 0c             	mov    0xc(%ebp),%eax
     4df:	01 d0                	add    %edx,%eax
     4e1:	8b 00                	mov    (%eax),%eax
     4e3:	89 44 24 08          	mov    %eax,0x8(%esp)
     4e7:	c7 44 24 04 1c 14 00 	movl   $0x141c,0x4(%esp)
     4ee:	00 
     4ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     4f6:	e8 3e 0a 00 00       	call   f39 <printf>
      id = fork();
     4fb:	e8 b4 08 00 00       	call   db4 <fork>
     500:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(id == 0)
     503:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     507:	75 1f                	jne    528 <create+0x36e>
      {
        char *remove_args[2];
        remove_args[0] = "rm";
     509:	c7 45 d8 72 14 00 00 	movl   $0x1472,-0x28(%ebp)
        remove_args[1] = destination;
     510:	8d 45 b8             	lea    -0x48(%ebp),%eax
     513:	89 45 dc             	mov    %eax,-0x24(%ebp)
        exec(remove_args[0], remove_args);
     516:	8b 45 d8             	mov    -0x28(%ebp),%eax
     519:	8d 55 d8             	lea    -0x28(%ebp),%edx
     51c:	89 54 24 04          	mov    %edx,0x4(%esp)
     520:	89 04 24             	mov    %eax,(%esp)
     523:	e8 cc 08 00 00       	call   df4 <exec>
      }
      id = wait();
     528:	e8 97 08 00 00       	call   dc4 <wait>
     52d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  {
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 6; i < argc; i++) // going through ls echo cat ...
     530:	ff 45 f4             	incl   -0xc(%ebp)
     533:	8b 45 f4             	mov    -0xc(%ebp),%eax
     536:	3b 45 08             	cmp    0x8(%ebp),%eax
     539:	0f 8c 65 fe ff ff    	jl     3a4 <create+0x1ea>
        exec(remove_args[0], remove_args);
      }
      id = wait();
    }
  }
  return 0;
     53f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     544:	83 c4 54             	add    $0x54,%esp
     547:	5b                   	pop    %ebx
     548:	5d                   	pop    %ebp
     549:	c3                   	ret    

0000054a <main>:

int main(int argc, char *argv[])
{
     54a:	55                   	push   %ebp
     54b:	89 e5                	mov    %esp,%ebp
     54d:	83 e4 f0             	and    $0xfffffff0,%esp
     550:	83 ec 10             	sub    $0x10,%esp
  if(argc < 2)
     553:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
     557:	7f 0c                	jg     565 <main+0x1b>
  {
    print_usage(0);
     559:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     560:	e8 9b fa ff ff       	call   0 <print_usage>
  }

  if(strcmp(argv[1], "create") == 0)
     565:	8b 45 0c             	mov    0xc(%ebp),%eax
     568:	83 c0 04             	add    $0x4,%eax
     56b:	8b 00                	mov    (%eax),%eax
     56d:	c7 44 24 04 75 14 00 	movl   $0x1475,0x4(%esp)
     574:	00 
     575:	89 04 24             	mov    %eax,(%esp)
     578:	e8 e2 01 00 00       	call   75f <strcmp>
     57d:	85 c0                	test   %eax,%eax
     57f:	75 44                	jne    5c5 <main+0x7b>
  {
    if(argc < 7)
     581:	83 7d 08 06          	cmpl   $0x6,0x8(%ebp)
     585:	7f 0c                	jg     593 <main+0x49>
    {
      print_usage(1);
     587:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     58e:	e8 6d fa ff ff       	call   0 <print_usage>
    }
    if(chdir(argv[2]) > 0)
     593:	8b 45 0c             	mov    0xc(%ebp),%eax
     596:	83 c0 08             	add    $0x8,%eax
     599:	8b 00                	mov    (%eax),%eax
     59b:	89 04 24             	mov    %eax,(%esp)
     59e:	e8 89 08 00 00       	call   e2c <chdir>
     5a3:	85 c0                	test   %eax,%eax
     5a5:	7e 0c                	jle    5b3 <main+0x69>
    {
      print_usage(2);
     5a7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5ae:	e8 4d fa ff ff       	call   0 <print_usage>
    }

    create(argc, argv);
     5b3:	8b 45 0c             	mov    0xc(%ebp),%eax
     5b6:	89 44 24 04          	mov    %eax,0x4(%esp)
     5ba:	8b 45 08             	mov    0x8(%ebp),%eax
     5bd:	89 04 24             	mov    %eax,(%esp)
     5c0:	e8 f5 fb ff ff       	call   1ba <create>
  }

  if(strcmp(argv[1], "start") == 0)
     5c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     5c8:	83 c0 04             	add    $0x4,%eax
     5cb:	8b 00                	mov    (%eax),%eax
     5cd:	c7 44 24 04 7c 14 00 	movl   $0x147c,0x4(%esp)
     5d4:	00 
     5d5:	89 04 24             	mov    %eax,(%esp)
     5d8:	e8 82 01 00 00       	call   75f <strcmp>
     5dd:	85 c0                	test   %eax,%eax
     5df:	75 24                	jne    605 <main+0xbb>
  {
    if(argc < 5)
     5e1:	83 7d 08 04          	cmpl   $0x4,0x8(%ebp)
     5e5:	7f 0c                	jg     5f3 <main+0xa9>
    {
      print_usage(3);
     5e7:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
     5ee:	e8 0d fa ff ff       	call   0 <print_usage>
    }

    start(argc, argv);
     5f3:	8b 45 0c             	mov    0xc(%ebp),%eax
     5f6:	89 44 24 04          	mov    %eax,0x4(%esp)
     5fa:	8b 45 08             	mov    0x8(%ebp),%eax
     5fd:	89 04 24             	mov    %eax,(%esp)
     600:	e8 c4 fa ff ff       	call   c9 <start>
  }

  exit();
     605:	e8 b2 07 00 00       	call   dbc <exit>
     60a:	90                   	nop
     60b:	90                   	nop

0000060c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     60c:	55                   	push   %ebp
     60d:	89 e5                	mov    %esp,%ebp
     60f:	57                   	push   %edi
     610:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     611:	8b 4d 08             	mov    0x8(%ebp),%ecx
     614:	8b 55 10             	mov    0x10(%ebp),%edx
     617:	8b 45 0c             	mov    0xc(%ebp),%eax
     61a:	89 cb                	mov    %ecx,%ebx
     61c:	89 df                	mov    %ebx,%edi
     61e:	89 d1                	mov    %edx,%ecx
     620:	fc                   	cld    
     621:	f3 aa                	rep stos %al,%es:(%edi)
     623:	89 ca                	mov    %ecx,%edx
     625:	89 fb                	mov    %edi,%ebx
     627:	89 5d 08             	mov    %ebx,0x8(%ebp)
     62a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     62d:	5b                   	pop    %ebx
     62e:	5f                   	pop    %edi
     62f:	5d                   	pop    %ebp
     630:	c3                   	ret    

00000631 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     631:	55                   	push   %ebp
     632:	89 e5                	mov    %esp,%ebp
     634:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     637:	8b 45 08             	mov    0x8(%ebp),%eax
     63a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     63d:	90                   	nop
     63e:	8b 45 08             	mov    0x8(%ebp),%eax
     641:	8d 50 01             	lea    0x1(%eax),%edx
     644:	89 55 08             	mov    %edx,0x8(%ebp)
     647:	8b 55 0c             	mov    0xc(%ebp),%edx
     64a:	8d 4a 01             	lea    0x1(%edx),%ecx
     64d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     650:	8a 12                	mov    (%edx),%dl
     652:	88 10                	mov    %dl,(%eax)
     654:	8a 00                	mov    (%eax),%al
     656:	84 c0                	test   %al,%al
     658:	75 e4                	jne    63e <strcpy+0xd>
    ;
  return os;
     65a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     65d:	c9                   	leave  
     65e:	c3                   	ret    

0000065f <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     65f:	55                   	push   %ebp
     660:	89 e5                	mov    %esp,%ebp
     662:	83 ec 58             	sub    $0x58,%esp
    int fd1, fd2, count, bytes = 0, max;
     665:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    char buffer[32];
        
    if((fd1 = open(inputfile, O_RDONLY)) < 0)
     66c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     673:	00 
     674:	8b 45 08             	mov    0x8(%ebp),%eax
     677:	89 04 24             	mov    %eax,(%esp)
     67a:	e8 7d 07 00 00       	call   dfc <open>
     67f:	89 45 f0             	mov    %eax,-0x10(%ebp)
     682:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     686:	79 20                	jns    6a8 <copy+0x49>
    {
        printf(1, "Cannot open inputfile: %s\n", inputfile);
     688:	8b 45 08             	mov    0x8(%ebp),%eax
     68b:	89 44 24 08          	mov    %eax,0x8(%esp)
     68f:	c7 44 24 04 82 14 00 	movl   $0x1482,0x4(%esp)
     696:	00 
     697:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     69e:	e8 96 08 00 00       	call   f39 <printf>
        exit();
     6a3:	e8 14 07 00 00       	call   dbc <exit>
    }
    if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     6a8:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     6af:	00 
     6b0:	8b 45 0c             	mov    0xc(%ebp),%eax
     6b3:	89 04 24             	mov    %eax,(%esp)
     6b6:	e8 41 07 00 00       	call   dfc <open>
     6bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
     6be:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     6c2:	79 20                	jns    6e4 <copy+0x85>
    {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
     6c4:	8b 45 0c             	mov    0xc(%ebp),%eax
     6c7:	89 44 24 08          	mov    %eax,0x8(%esp)
     6cb:	c7 44 24 04 9d 14 00 	movl   $0x149d,0x4(%esp)
     6d2:	00 
     6d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6da:	e8 5a 08 00 00       	call   f39 <printf>
        exit();
     6df:	e8 d8 06 00 00       	call   dbc <exit>
    }

    while((count = read(fd1, buffer, 32)) > 0)
     6e4:	eb 3b                	jmp    721 <copy+0xc2>
    {
        max = used_disk+=count;
     6e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     6e9:	01 45 10             	add    %eax,0x10(%ebp)
     6ec:	8b 45 10             	mov    0x10(%ebp),%eax
     6ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(max > max_disk)
     6f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     6f5:	3b 45 14             	cmp    0x14(%ebp),%eax
     6f8:	7e 07                	jle    701 <copy+0xa2>
        {
          return -1;
     6fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     6ff:	eb 5c                	jmp    75d <copy+0xfe>
        }
        bytes = bytes + count;
     701:	8b 45 e8             	mov    -0x18(%ebp),%eax
     704:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
     707:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     70e:	00 
     70f:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     712:	89 44 24 04          	mov    %eax,0x4(%esp)
     716:	8b 45 ec             	mov    -0x14(%ebp),%eax
     719:	89 04 24             	mov    %eax,(%esp)
     71c:	e8 bb 06 00 00       	call   ddc <write>
    {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while((count = read(fd1, buffer, 32)) > 0)
     721:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     728:	00 
     729:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     72c:	89 44 24 04          	mov    %eax,0x4(%esp)
     730:	8b 45 f0             	mov    -0x10(%ebp),%eax
     733:	89 04 24             	mov    %eax,(%esp)
     736:	e8 99 06 00 00       	call   dd4 <read>
     73b:	89 45 e8             	mov    %eax,-0x18(%ebp)
     73e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     742:	7f a2                	jg     6e6 <copy+0x87>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
     744:	8b 45 f0             	mov    -0x10(%ebp),%eax
     747:	89 04 24             	mov    %eax,(%esp)
     74a:	e8 95 06 00 00       	call   de4 <close>
    close(fd2);
     74f:	8b 45 ec             	mov    -0x14(%ebp),%eax
     752:	89 04 24             	mov    %eax,(%esp)
     755:	e8 8a 06 00 00       	call   de4 <close>
    return(bytes);
     75a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     75d:	c9                   	leave  
     75e:	c3                   	ret    

0000075f <strcmp>:

int
strcmp(const char *p, const char *q)
{
     75f:	55                   	push   %ebp
     760:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     762:	eb 06                	jmp    76a <strcmp+0xb>
    p++, q++;
     764:	ff 45 08             	incl   0x8(%ebp)
     767:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     76a:	8b 45 08             	mov    0x8(%ebp),%eax
     76d:	8a 00                	mov    (%eax),%al
     76f:	84 c0                	test   %al,%al
     771:	74 0e                	je     781 <strcmp+0x22>
     773:	8b 45 08             	mov    0x8(%ebp),%eax
     776:	8a 10                	mov    (%eax),%dl
     778:	8b 45 0c             	mov    0xc(%ebp),%eax
     77b:	8a 00                	mov    (%eax),%al
     77d:	38 c2                	cmp    %al,%dl
     77f:	74 e3                	je     764 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     781:	8b 45 08             	mov    0x8(%ebp),%eax
     784:	8a 00                	mov    (%eax),%al
     786:	0f b6 d0             	movzbl %al,%edx
     789:	8b 45 0c             	mov    0xc(%ebp),%eax
     78c:	8a 00                	mov    (%eax),%al
     78e:	0f b6 c0             	movzbl %al,%eax
     791:	29 c2                	sub    %eax,%edx
     793:	89 d0                	mov    %edx,%eax
}
     795:	5d                   	pop    %ebp
     796:	c3                   	ret    

00000797 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     797:	55                   	push   %ebp
     798:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     79a:	eb 09                	jmp    7a5 <strncmp+0xe>
    n--, p++, q++;
     79c:	ff 4d 10             	decl   0x10(%ebp)
     79f:	ff 45 08             	incl   0x8(%ebp)
     7a2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     7a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     7a9:	74 17                	je     7c2 <strncmp+0x2b>
     7ab:	8b 45 08             	mov    0x8(%ebp),%eax
     7ae:	8a 00                	mov    (%eax),%al
     7b0:	84 c0                	test   %al,%al
     7b2:	74 0e                	je     7c2 <strncmp+0x2b>
     7b4:	8b 45 08             	mov    0x8(%ebp),%eax
     7b7:	8a 10                	mov    (%eax),%dl
     7b9:	8b 45 0c             	mov    0xc(%ebp),%eax
     7bc:	8a 00                	mov    (%eax),%al
     7be:	38 c2                	cmp    %al,%dl
     7c0:	74 da                	je     79c <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     7c2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     7c6:	75 07                	jne    7cf <strncmp+0x38>
    return 0;
     7c8:	b8 00 00 00 00       	mov    $0x0,%eax
     7cd:	eb 14                	jmp    7e3 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     7cf:	8b 45 08             	mov    0x8(%ebp),%eax
     7d2:	8a 00                	mov    (%eax),%al
     7d4:	0f b6 d0             	movzbl %al,%edx
     7d7:	8b 45 0c             	mov    0xc(%ebp),%eax
     7da:	8a 00                	mov    (%eax),%al
     7dc:	0f b6 c0             	movzbl %al,%eax
     7df:	29 c2                	sub    %eax,%edx
     7e1:	89 d0                	mov    %edx,%eax
}
     7e3:	5d                   	pop    %ebp
     7e4:	c3                   	ret    

000007e5 <strlen>:

uint
strlen(const char *s)
{
     7e5:	55                   	push   %ebp
     7e6:	89 e5                	mov    %esp,%ebp
     7e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     7eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     7f2:	eb 03                	jmp    7f7 <strlen+0x12>
     7f4:	ff 45 fc             	incl   -0x4(%ebp)
     7f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
     7fa:	8b 45 08             	mov    0x8(%ebp),%eax
     7fd:	01 d0                	add    %edx,%eax
     7ff:	8a 00                	mov    (%eax),%al
     801:	84 c0                	test   %al,%al
     803:	75 ef                	jne    7f4 <strlen+0xf>
    ;
  return n;
     805:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     808:	c9                   	leave  
     809:	c3                   	ret    

0000080a <memset>:

void*
memset(void *dst, int c, uint n)
{
     80a:	55                   	push   %ebp
     80b:	89 e5                	mov    %esp,%ebp
     80d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     810:	8b 45 10             	mov    0x10(%ebp),%eax
     813:	89 44 24 08          	mov    %eax,0x8(%esp)
     817:	8b 45 0c             	mov    0xc(%ebp),%eax
     81a:	89 44 24 04          	mov    %eax,0x4(%esp)
     81e:	8b 45 08             	mov    0x8(%ebp),%eax
     821:	89 04 24             	mov    %eax,(%esp)
     824:	e8 e3 fd ff ff       	call   60c <stosb>
  return dst;
     829:	8b 45 08             	mov    0x8(%ebp),%eax
}
     82c:	c9                   	leave  
     82d:	c3                   	ret    

0000082e <strchr>:

char*
strchr(const char *s, char c)
{
     82e:	55                   	push   %ebp
     82f:	89 e5                	mov    %esp,%ebp
     831:	83 ec 04             	sub    $0x4,%esp
     834:	8b 45 0c             	mov    0xc(%ebp),%eax
     837:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     83a:	eb 12                	jmp    84e <strchr+0x20>
    if(*s == c)
     83c:	8b 45 08             	mov    0x8(%ebp),%eax
     83f:	8a 00                	mov    (%eax),%al
     841:	3a 45 fc             	cmp    -0x4(%ebp),%al
     844:	75 05                	jne    84b <strchr+0x1d>
      return (char*)s;
     846:	8b 45 08             	mov    0x8(%ebp),%eax
     849:	eb 11                	jmp    85c <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     84b:	ff 45 08             	incl   0x8(%ebp)
     84e:	8b 45 08             	mov    0x8(%ebp),%eax
     851:	8a 00                	mov    (%eax),%al
     853:	84 c0                	test   %al,%al
     855:	75 e5                	jne    83c <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     857:	b8 00 00 00 00       	mov    $0x0,%eax
}
     85c:	c9                   	leave  
     85d:	c3                   	ret    

0000085e <strcat>:

char *
strcat(char *dest, const char *src)
{
     85e:	55                   	push   %ebp
     85f:	89 e5                	mov    %esp,%ebp
     861:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     864:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     86b:	eb 03                	jmp    870 <strcat+0x12>
     86d:	ff 45 fc             	incl   -0x4(%ebp)
     870:	8b 55 fc             	mov    -0x4(%ebp),%edx
     873:	8b 45 08             	mov    0x8(%ebp),%eax
     876:	01 d0                	add    %edx,%eax
     878:	8a 00                	mov    (%eax),%al
     87a:	84 c0                	test   %al,%al
     87c:	75 ef                	jne    86d <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     87e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     885:	eb 1e                	jmp    8a5 <strcat+0x47>
        dest[i+j] = src[j];
     887:	8b 45 f8             	mov    -0x8(%ebp),%eax
     88a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     88d:	01 d0                	add    %edx,%eax
     88f:	89 c2                	mov    %eax,%edx
     891:	8b 45 08             	mov    0x8(%ebp),%eax
     894:	01 c2                	add    %eax,%edx
     896:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     899:	8b 45 0c             	mov    0xc(%ebp),%eax
     89c:	01 c8                	add    %ecx,%eax
     89e:	8a 00                	mov    (%eax),%al
     8a0:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     8a2:	ff 45 f8             	incl   -0x8(%ebp)
     8a5:	8b 55 f8             	mov    -0x8(%ebp),%edx
     8a8:	8b 45 0c             	mov    0xc(%ebp),%eax
     8ab:	01 d0                	add    %edx,%eax
     8ad:	8a 00                	mov    (%eax),%al
     8af:	84 c0                	test   %al,%al
     8b1:	75 d4                	jne    887 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     8b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
     8b9:	01 d0                	add    %edx,%eax
     8bb:	89 c2                	mov    %eax,%edx
     8bd:	8b 45 08             	mov    0x8(%ebp),%eax
     8c0:	01 d0                	add    %edx,%eax
     8c2:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     8c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     8c8:	c9                   	leave  
     8c9:	c3                   	ret    

000008ca <strstr>:

int 
strstr(char* s, char* sub)
{
     8ca:	55                   	push   %ebp
     8cb:	89 e5                	mov    %esp,%ebp
     8cd:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     8d0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     8d7:	eb 7c                	jmp    955 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     8d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     8dc:	8b 45 08             	mov    0x8(%ebp),%eax
     8df:	01 d0                	add    %edx,%eax
     8e1:	8a 10                	mov    (%eax),%dl
     8e3:	8b 45 0c             	mov    0xc(%ebp),%eax
     8e6:	8a 00                	mov    (%eax),%al
     8e8:	38 c2                	cmp    %al,%dl
     8ea:	75 66                	jne    952 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     8ec:	8b 45 0c             	mov    0xc(%ebp),%eax
     8ef:	89 04 24             	mov    %eax,(%esp)
     8f2:	e8 ee fe ff ff       	call   7e5 <strlen>
     8f7:	83 f8 01             	cmp    $0x1,%eax
     8fa:	75 05                	jne    901 <strstr+0x37>
            {  
                return i;
     8fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8ff:	eb 6b                	jmp    96c <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     901:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     908:	eb 3a                	jmp    944 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     90a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     90d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     910:	01 d0                	add    %edx,%eax
     912:	89 c2                	mov    %eax,%edx
     914:	8b 45 08             	mov    0x8(%ebp),%eax
     917:	01 d0                	add    %edx,%eax
     919:	8a 10                	mov    (%eax),%dl
     91b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     91e:	8b 45 0c             	mov    0xc(%ebp),%eax
     921:	01 c8                	add    %ecx,%eax
     923:	8a 00                	mov    (%eax),%al
     925:	38 c2                	cmp    %al,%dl
     927:	75 16                	jne    93f <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     929:	8b 45 f8             	mov    -0x8(%ebp),%eax
     92c:	8d 50 01             	lea    0x1(%eax),%edx
     92f:	8b 45 0c             	mov    0xc(%ebp),%eax
     932:	01 d0                	add    %edx,%eax
     934:	8a 00                	mov    (%eax),%al
     936:	84 c0                	test   %al,%al
     938:	75 07                	jne    941 <strstr+0x77>
                    {
                        return i;
     93a:	8b 45 fc             	mov    -0x4(%ebp),%eax
     93d:	eb 2d                	jmp    96c <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     93f:	eb 11                	jmp    952 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     941:	ff 45 f8             	incl   -0x8(%ebp)
     944:	8b 55 f8             	mov    -0x8(%ebp),%edx
     947:	8b 45 0c             	mov    0xc(%ebp),%eax
     94a:	01 d0                	add    %edx,%eax
     94c:	8a 00                	mov    (%eax),%al
     94e:	84 c0                	test   %al,%al
     950:	75 b8                	jne    90a <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     952:	ff 45 fc             	incl   -0x4(%ebp)
     955:	8b 55 fc             	mov    -0x4(%ebp),%edx
     958:	8b 45 08             	mov    0x8(%ebp),%eax
     95b:	01 d0                	add    %edx,%eax
     95d:	8a 00                	mov    (%eax),%al
     95f:	84 c0                	test   %al,%al
     961:	0f 85 72 ff ff ff    	jne    8d9 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     967:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     96c:	c9                   	leave  
     96d:	c3                   	ret    

0000096e <strtok>:

char *
strtok(char *s, const char *delim)
{
     96e:	55                   	push   %ebp
     96f:	89 e5                	mov    %esp,%ebp
     971:	53                   	push   %ebx
     972:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     975:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     979:	75 08                	jne    983 <strtok+0x15>
  s = lasts;
     97b:	a1 24 19 00 00       	mov    0x1924,%eax
     980:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     983:	8b 45 08             	mov    0x8(%ebp),%eax
     986:	8d 50 01             	lea    0x1(%eax),%edx
     989:	89 55 08             	mov    %edx,0x8(%ebp)
     98c:	8a 00                	mov    (%eax),%al
     98e:	0f be d8             	movsbl %al,%ebx
     991:	85 db                	test   %ebx,%ebx
     993:	75 07                	jne    99c <strtok+0x2e>
      return 0;
     995:	b8 00 00 00 00       	mov    $0x0,%eax
     99a:	eb 58                	jmp    9f4 <strtok+0x86>
    } while (strchr(delim, ch));
     99c:	88 d8                	mov    %bl,%al
     99e:	0f be c0             	movsbl %al,%eax
     9a1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9a5:	8b 45 0c             	mov    0xc(%ebp),%eax
     9a8:	89 04 24             	mov    %eax,(%esp)
     9ab:	e8 7e fe ff ff       	call   82e <strchr>
     9b0:	85 c0                	test   %eax,%eax
     9b2:	75 cf                	jne    983 <strtok+0x15>
    --s;
     9b4:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     9b7:	8b 45 0c             	mov    0xc(%ebp),%eax
     9ba:	89 44 24 04          	mov    %eax,0x4(%esp)
     9be:	8b 45 08             	mov    0x8(%ebp),%eax
     9c1:	89 04 24             	mov    %eax,(%esp)
     9c4:	e8 31 00 00 00       	call   9fa <strcspn>
     9c9:	89 c2                	mov    %eax,%edx
     9cb:	8b 45 08             	mov    0x8(%ebp),%eax
     9ce:	01 d0                	add    %edx,%eax
     9d0:	a3 24 19 00 00       	mov    %eax,0x1924
    if (*lasts != 0)
     9d5:	a1 24 19 00 00       	mov    0x1924,%eax
     9da:	8a 00                	mov    (%eax),%al
     9dc:	84 c0                	test   %al,%al
     9de:	74 11                	je     9f1 <strtok+0x83>
  *lasts++ = 0;
     9e0:	a1 24 19 00 00       	mov    0x1924,%eax
     9e5:	8d 50 01             	lea    0x1(%eax),%edx
     9e8:	89 15 24 19 00 00    	mov    %edx,0x1924
     9ee:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     9f1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9f4:	83 c4 14             	add    $0x14,%esp
     9f7:	5b                   	pop    %ebx
     9f8:	5d                   	pop    %ebp
     9f9:	c3                   	ret    

000009fa <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     9fa:	55                   	push   %ebp
     9fb:	89 e5                	mov    %esp,%ebp
     9fd:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     a00:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     a07:	eb 26                	jmp    a2f <strcspn+0x35>
        if(strchr(s2,*s1))
     a09:	8b 45 08             	mov    0x8(%ebp),%eax
     a0c:	8a 00                	mov    (%eax),%al
     a0e:	0f be c0             	movsbl %al,%eax
     a11:	89 44 24 04          	mov    %eax,0x4(%esp)
     a15:	8b 45 0c             	mov    0xc(%ebp),%eax
     a18:	89 04 24             	mov    %eax,(%esp)
     a1b:	e8 0e fe ff ff       	call   82e <strchr>
     a20:	85 c0                	test   %eax,%eax
     a22:	74 05                	je     a29 <strcspn+0x2f>
            return ret;
     a24:	8b 45 fc             	mov    -0x4(%ebp),%eax
     a27:	eb 12                	jmp    a3b <strcspn+0x41>
        else
            s1++,ret++;
     a29:	ff 45 08             	incl   0x8(%ebp)
     a2c:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     a2f:	8b 45 08             	mov    0x8(%ebp),%eax
     a32:	8a 00                	mov    (%eax),%al
     a34:	84 c0                	test   %al,%al
     a36:	75 d1                	jne    a09 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     a3b:	c9                   	leave  
     a3c:	c3                   	ret    

00000a3d <isspace>:

int
isspace(unsigned char c)
{
     a3d:	55                   	push   %ebp
     a3e:	89 e5                	mov    %esp,%ebp
     a40:	83 ec 04             	sub    $0x4,%esp
     a43:	8b 45 08             	mov    0x8(%ebp),%eax
     a46:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     a49:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     a4d:	74 1e                	je     a6d <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     a4f:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     a53:	74 18                	je     a6d <isspace+0x30>
     a55:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     a59:	74 12                	je     a6d <isspace+0x30>
     a5b:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     a5f:	74 0c                	je     a6d <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     a61:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     a65:	74 06                	je     a6d <isspace+0x30>
     a67:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     a6b:	75 07                	jne    a74 <isspace+0x37>
     a6d:	b8 01 00 00 00       	mov    $0x1,%eax
     a72:	eb 05                	jmp    a79 <isspace+0x3c>
     a74:	b8 00 00 00 00       	mov    $0x0,%eax
}
     a79:	c9                   	leave  
     a7a:	c3                   	ret    

00000a7b <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     a7b:	55                   	push   %ebp
     a7c:	89 e5                	mov    %esp,%ebp
     a7e:	57                   	push   %edi
     a7f:	56                   	push   %esi
     a80:	53                   	push   %ebx
     a81:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     a84:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     a89:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     a90:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     a93:	eb 01                	jmp    a96 <strtoul+0x1b>
  p += 1;
     a95:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     a96:	8a 03                	mov    (%ebx),%al
     a98:	0f b6 c0             	movzbl %al,%eax
     a9b:	89 04 24             	mov    %eax,(%esp)
     a9e:	e8 9a ff ff ff       	call   a3d <isspace>
     aa3:	85 c0                	test   %eax,%eax
     aa5:	75 ee                	jne    a95 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     aa7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     aab:	75 30                	jne    add <strtoul+0x62>
    {
  if (*p == '0') {
     aad:	8a 03                	mov    (%ebx),%al
     aaf:	3c 30                	cmp    $0x30,%al
     ab1:	75 21                	jne    ad4 <strtoul+0x59>
      p += 1;
     ab3:	43                   	inc    %ebx
      if (*p == 'x') {
     ab4:	8a 03                	mov    (%ebx),%al
     ab6:	3c 78                	cmp    $0x78,%al
     ab8:	75 0a                	jne    ac4 <strtoul+0x49>
    p += 1;
     aba:	43                   	inc    %ebx
    base = 16;
     abb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     ac2:	eb 31                	jmp    af5 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     ac4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     acb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     ad2:	eb 21                	jmp    af5 <strtoul+0x7a>
      }
  }
  else base = 10;
     ad4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     adb:	eb 18                	jmp    af5 <strtoul+0x7a>
    } else if (base == 16) {
     add:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     ae1:	75 12                	jne    af5 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     ae3:	8a 03                	mov    (%ebx),%al
     ae5:	3c 30                	cmp    $0x30,%al
     ae7:	75 0c                	jne    af5 <strtoul+0x7a>
     ae9:	8d 43 01             	lea    0x1(%ebx),%eax
     aec:	8a 00                	mov    (%eax),%al
     aee:	3c 78                	cmp    $0x78,%al
     af0:	75 03                	jne    af5 <strtoul+0x7a>
      p += 2;
     af2:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     af5:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     af9:	75 29                	jne    b24 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     afb:	8a 03                	mov    (%ebx),%al
     afd:	0f be c0             	movsbl %al,%eax
     b00:	83 e8 30             	sub    $0x30,%eax
     b03:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     b05:	83 fe 07             	cmp    $0x7,%esi
     b08:	76 06                	jbe    b10 <strtoul+0x95>
    break;
     b0a:	90                   	nop
     b0b:	e9 b6 00 00 00       	jmp    bc6 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     b10:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     b17:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b1a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     b21:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     b22:	eb d7                	jmp    afb <strtoul+0x80>
    } else if (base == 10) {
     b24:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     b28:	75 2b                	jne    b55 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     b2a:	8a 03                	mov    (%ebx),%al
     b2c:	0f be c0             	movsbl %al,%eax
     b2f:	83 e8 30             	sub    $0x30,%eax
     b32:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     b34:	83 fe 09             	cmp    $0x9,%esi
     b37:	76 06                	jbe    b3f <strtoul+0xc4>
    break;
     b39:	90                   	nop
     b3a:	e9 87 00 00 00       	jmp    bc6 <strtoul+0x14b>
      }
      result = (10*result) + digit;
     b3f:	89 f8                	mov    %edi,%eax
     b41:	c1 e0 02             	shl    $0x2,%eax
     b44:	01 f8                	add    %edi,%eax
     b46:	01 c0                	add    %eax,%eax
     b48:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b4b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     b52:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     b53:	eb d5                	jmp    b2a <strtoul+0xaf>
    } else if (base == 16) {
     b55:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     b59:	75 35                	jne    b90 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     b5b:	8a 03                	mov    (%ebx),%al
     b5d:	0f be c0             	movsbl %al,%eax
     b60:	83 e8 30             	sub    $0x30,%eax
     b63:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     b65:	83 fe 4a             	cmp    $0x4a,%esi
     b68:	76 02                	jbe    b6c <strtoul+0xf1>
    break;
     b6a:	eb 22                	jmp    b8e <strtoul+0x113>
      }
      digit = cvtIn[digit];
     b6c:	8a 86 c0 18 00 00    	mov    0x18c0(%esi),%al
     b72:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     b75:	83 fe 0f             	cmp    $0xf,%esi
     b78:	76 02                	jbe    b7c <strtoul+0x101>
    break;
     b7a:	eb 12                	jmp    b8e <strtoul+0x113>
      }
      result = (result << 4) + digit;
     b7c:	89 f8                	mov    %edi,%eax
     b7e:	c1 e0 04             	shl    $0x4,%eax
     b81:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b84:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     b8b:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     b8c:	eb cd                	jmp    b5b <strtoul+0xe0>
     b8e:	eb 36                	jmp    bc6 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     b90:	8a 03                	mov    (%ebx),%al
     b92:	0f be c0             	movsbl %al,%eax
     b95:	83 e8 30             	sub    $0x30,%eax
     b98:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     b9a:	83 fe 4a             	cmp    $0x4a,%esi
     b9d:	76 02                	jbe    ba1 <strtoul+0x126>
    break;
     b9f:	eb 25                	jmp    bc6 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     ba1:	8a 86 c0 18 00 00    	mov    0x18c0(%esi),%al
     ba7:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     baa:	8b 45 10             	mov    0x10(%ebp),%eax
     bad:	39 f0                	cmp    %esi,%eax
     baf:	77 02                	ja     bb3 <strtoul+0x138>
    break;
     bb1:	eb 13                	jmp    bc6 <strtoul+0x14b>
      }
      result = result*base + digit;
     bb3:	8b 45 10             	mov    0x10(%ebp),%eax
     bb6:	0f af c7             	imul   %edi,%eax
     bb9:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     bbc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     bc3:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     bc4:	eb ca                	jmp    b90 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     bc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     bca:	75 03                	jne    bcf <strtoul+0x154>
  p = string;
     bcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     bcf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bd3:	74 05                	je     bda <strtoul+0x15f>
  *endPtr = p;
     bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd8:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     bda:	89 f8                	mov    %edi,%eax
}
     bdc:	83 c4 14             	add    $0x14,%esp
     bdf:	5b                   	pop    %ebx
     be0:	5e                   	pop    %esi
     be1:	5f                   	pop    %edi
     be2:	5d                   	pop    %ebp
     be3:	c3                   	ret    

00000be4 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     be4:	55                   	push   %ebp
     be5:	89 e5                	mov    %esp,%ebp
     be7:	53                   	push   %ebx
     be8:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     bee:	eb 01                	jmp    bf1 <strtol+0xd>
      p += 1;
     bf0:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     bf1:	8a 03                	mov    (%ebx),%al
     bf3:	0f b6 c0             	movzbl %al,%eax
     bf6:	89 04 24             	mov    %eax,(%esp)
     bf9:	e8 3f fe ff ff       	call   a3d <isspace>
     bfe:	85 c0                	test   %eax,%eax
     c00:	75 ee                	jne    bf0 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     c02:	8a 03                	mov    (%ebx),%al
     c04:	3c 2d                	cmp    $0x2d,%al
     c06:	75 1e                	jne    c26 <strtol+0x42>
  p += 1;
     c08:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     c09:	8b 45 10             	mov    0x10(%ebp),%eax
     c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
     c10:	8b 45 0c             	mov    0xc(%ebp),%eax
     c13:	89 44 24 04          	mov    %eax,0x4(%esp)
     c17:	89 1c 24             	mov    %ebx,(%esp)
     c1a:	e8 5c fe ff ff       	call   a7b <strtoul>
     c1f:	f7 d8                	neg    %eax
     c21:	89 45 f8             	mov    %eax,-0x8(%ebp)
     c24:	eb 20                	jmp    c46 <strtol+0x62>
    } else {
  if (*p == '+') {
     c26:	8a 03                	mov    (%ebx),%al
     c28:	3c 2b                	cmp    $0x2b,%al
     c2a:	75 01                	jne    c2d <strtol+0x49>
      p += 1;
     c2c:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     c2d:	8b 45 10             	mov    0x10(%ebp),%eax
     c30:	89 44 24 08          	mov    %eax,0x8(%esp)
     c34:	8b 45 0c             	mov    0xc(%ebp),%eax
     c37:	89 44 24 04          	mov    %eax,0x4(%esp)
     c3b:	89 1c 24             	mov    %ebx,(%esp)
     c3e:	e8 38 fe ff ff       	call   a7b <strtoul>
     c43:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     c46:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     c4a:	75 17                	jne    c63 <strtol+0x7f>
     c4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     c50:	74 11                	je     c63 <strtol+0x7f>
     c52:	8b 45 0c             	mov    0xc(%ebp),%eax
     c55:	8b 00                	mov    (%eax),%eax
     c57:	39 d8                	cmp    %ebx,%eax
     c59:	75 08                	jne    c63 <strtol+0x7f>
  *endPtr = string;
     c5b:	8b 45 0c             	mov    0xc(%ebp),%eax
     c5e:	8b 55 08             	mov    0x8(%ebp),%edx
     c61:	89 10                	mov    %edx,(%eax)
    }
    return result;
     c63:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     c66:	83 c4 1c             	add    $0x1c,%esp
     c69:	5b                   	pop    %ebx
     c6a:	5d                   	pop    %ebp
     c6b:	c3                   	ret    

00000c6c <gets>:

char*
gets(char *buf, int max)
{
     c6c:	55                   	push   %ebp
     c6d:	89 e5                	mov    %esp,%ebp
     c6f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c79:	eb 49                	jmp    cc4 <gets+0x58>
    cc = read(0, &c, 1);
     c7b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c82:	00 
     c83:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c86:	89 44 24 04          	mov    %eax,0x4(%esp)
     c8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c91:	e8 3e 01 00 00       	call   dd4 <read>
     c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c99:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c9d:	7f 02                	jg     ca1 <gets+0x35>
      break;
     c9f:	eb 2c                	jmp    ccd <gets+0x61>
    buf[i++] = c;
     ca1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ca4:	8d 50 01             	lea    0x1(%eax),%edx
     ca7:	89 55 f4             	mov    %edx,-0xc(%ebp)
     caa:	89 c2                	mov    %eax,%edx
     cac:	8b 45 08             	mov    0x8(%ebp),%eax
     caf:	01 c2                	add    %eax,%edx
     cb1:	8a 45 ef             	mov    -0x11(%ebp),%al
     cb4:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     cb6:	8a 45 ef             	mov    -0x11(%ebp),%al
     cb9:	3c 0a                	cmp    $0xa,%al
     cbb:	74 10                	je     ccd <gets+0x61>
     cbd:	8a 45 ef             	mov    -0x11(%ebp),%al
     cc0:	3c 0d                	cmp    $0xd,%al
     cc2:	74 09                	je     ccd <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cc7:	40                   	inc    %eax
     cc8:	3b 45 0c             	cmp    0xc(%ebp),%eax
     ccb:	7c ae                	jl     c7b <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cd0:	8b 45 08             	mov    0x8(%ebp),%eax
     cd3:	01 d0                	add    %edx,%eax
     cd5:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     cd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cdb:	c9                   	leave  
     cdc:	c3                   	ret    

00000cdd <stat>:

int
stat(char *n, struct stat *st)
{
     cdd:	55                   	push   %ebp
     cde:	89 e5                	mov    %esp,%ebp
     ce0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ce3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     cea:	00 
     ceb:	8b 45 08             	mov    0x8(%ebp),%eax
     cee:	89 04 24             	mov    %eax,(%esp)
     cf1:	e8 06 01 00 00       	call   dfc <open>
     cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     cf9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     cfd:	79 07                	jns    d06 <stat+0x29>
    return -1;
     cff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     d04:	eb 23                	jmp    d29 <stat+0x4c>
  r = fstat(fd, st);
     d06:	8b 45 0c             	mov    0xc(%ebp),%eax
     d09:	89 44 24 04          	mov    %eax,0x4(%esp)
     d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d10:	89 04 24             	mov    %eax,(%esp)
     d13:	e8 fc 00 00 00       	call   e14 <fstat>
     d18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d1e:	89 04 24             	mov    %eax,(%esp)
     d21:	e8 be 00 00 00       	call   de4 <close>
  return r;
     d26:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     d29:	c9                   	leave  
     d2a:	c3                   	ret    

00000d2b <atoi>:

int
atoi(const char *s)
{
     d2b:	55                   	push   %ebp
     d2c:	89 e5                	mov    %esp,%ebp
     d2e:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     d31:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     d38:	eb 24                	jmp    d5e <atoi+0x33>
    n = n*10 + *s++ - '0';
     d3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d3d:	89 d0                	mov    %edx,%eax
     d3f:	c1 e0 02             	shl    $0x2,%eax
     d42:	01 d0                	add    %edx,%eax
     d44:	01 c0                	add    %eax,%eax
     d46:	89 c1                	mov    %eax,%ecx
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	8d 50 01             	lea    0x1(%eax),%edx
     d4e:	89 55 08             	mov    %edx,0x8(%ebp)
     d51:	8a 00                	mov    (%eax),%al
     d53:	0f be c0             	movsbl %al,%eax
     d56:	01 c8                	add    %ecx,%eax
     d58:	83 e8 30             	sub    $0x30,%eax
     d5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d5e:	8b 45 08             	mov    0x8(%ebp),%eax
     d61:	8a 00                	mov    (%eax),%al
     d63:	3c 2f                	cmp    $0x2f,%al
     d65:	7e 09                	jle    d70 <atoi+0x45>
     d67:	8b 45 08             	mov    0x8(%ebp),%eax
     d6a:	8a 00                	mov    (%eax),%al
     d6c:	3c 39                	cmp    $0x39,%al
     d6e:	7e ca                	jle    d3a <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     d70:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d73:	c9                   	leave  
     d74:	c3                   	ret    

00000d75 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d75:	55                   	push   %ebp
     d76:	89 e5                	mov    %esp,%ebp
     d78:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     d7b:	8b 45 08             	mov    0x8(%ebp),%eax
     d7e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d81:	8b 45 0c             	mov    0xc(%ebp),%eax
     d84:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d87:	eb 16                	jmp    d9f <memmove+0x2a>
    *dst++ = *src++;
     d89:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d8c:	8d 50 01             	lea    0x1(%eax),%edx
     d8f:	89 55 fc             	mov    %edx,-0x4(%ebp)
     d92:	8b 55 f8             	mov    -0x8(%ebp),%edx
     d95:	8d 4a 01             	lea    0x1(%edx),%ecx
     d98:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     d9b:	8a 12                	mov    (%edx),%dl
     d9d:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d9f:	8b 45 10             	mov    0x10(%ebp),%eax
     da2:	8d 50 ff             	lea    -0x1(%eax),%edx
     da5:	89 55 10             	mov    %edx,0x10(%ebp)
     da8:	85 c0                	test   %eax,%eax
     daa:	7f dd                	jg     d89 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     dac:	8b 45 08             	mov    0x8(%ebp),%eax
}
     daf:	c9                   	leave  
     db0:	c3                   	ret    
     db1:	90                   	nop
     db2:	90                   	nop
     db3:	90                   	nop

00000db4 <fork>:
     db4:	b8 01 00 00 00       	mov    $0x1,%eax
     db9:	cd 40                	int    $0x40
     dbb:	c3                   	ret    

00000dbc <exit>:
     dbc:	b8 02 00 00 00       	mov    $0x2,%eax
     dc1:	cd 40                	int    $0x40
     dc3:	c3                   	ret    

00000dc4 <wait>:
     dc4:	b8 03 00 00 00       	mov    $0x3,%eax
     dc9:	cd 40                	int    $0x40
     dcb:	c3                   	ret    

00000dcc <pipe>:
     dcc:	b8 04 00 00 00       	mov    $0x4,%eax
     dd1:	cd 40                	int    $0x40
     dd3:	c3                   	ret    

00000dd4 <read>:
     dd4:	b8 05 00 00 00       	mov    $0x5,%eax
     dd9:	cd 40                	int    $0x40
     ddb:	c3                   	ret    

00000ddc <write>:
     ddc:	b8 10 00 00 00       	mov    $0x10,%eax
     de1:	cd 40                	int    $0x40
     de3:	c3                   	ret    

00000de4 <close>:
     de4:	b8 15 00 00 00       	mov    $0x15,%eax
     de9:	cd 40                	int    $0x40
     deb:	c3                   	ret    

00000dec <kill>:
     dec:	b8 06 00 00 00       	mov    $0x6,%eax
     df1:	cd 40                	int    $0x40
     df3:	c3                   	ret    

00000df4 <exec>:
     df4:	b8 07 00 00 00       	mov    $0x7,%eax
     df9:	cd 40                	int    $0x40
     dfb:	c3                   	ret    

00000dfc <open>:
     dfc:	b8 0f 00 00 00       	mov    $0xf,%eax
     e01:	cd 40                	int    $0x40
     e03:	c3                   	ret    

00000e04 <mknod>:
     e04:	b8 11 00 00 00       	mov    $0x11,%eax
     e09:	cd 40                	int    $0x40
     e0b:	c3                   	ret    

00000e0c <unlink>:
     e0c:	b8 12 00 00 00       	mov    $0x12,%eax
     e11:	cd 40                	int    $0x40
     e13:	c3                   	ret    

00000e14 <fstat>:
     e14:	b8 08 00 00 00       	mov    $0x8,%eax
     e19:	cd 40                	int    $0x40
     e1b:	c3                   	ret    

00000e1c <link>:
     e1c:	b8 13 00 00 00       	mov    $0x13,%eax
     e21:	cd 40                	int    $0x40
     e23:	c3                   	ret    

00000e24 <mkdir>:
     e24:	b8 14 00 00 00       	mov    $0x14,%eax
     e29:	cd 40                	int    $0x40
     e2b:	c3                   	ret    

00000e2c <chdir>:
     e2c:	b8 09 00 00 00       	mov    $0x9,%eax
     e31:	cd 40                	int    $0x40
     e33:	c3                   	ret    

00000e34 <dup>:
     e34:	b8 0a 00 00 00       	mov    $0xa,%eax
     e39:	cd 40                	int    $0x40
     e3b:	c3                   	ret    

00000e3c <getpid>:
     e3c:	b8 0b 00 00 00       	mov    $0xb,%eax
     e41:	cd 40                	int    $0x40
     e43:	c3                   	ret    

00000e44 <sbrk>:
     e44:	b8 0c 00 00 00       	mov    $0xc,%eax
     e49:	cd 40                	int    $0x40
     e4b:	c3                   	ret    

00000e4c <sleep>:
     e4c:	b8 0d 00 00 00       	mov    $0xd,%eax
     e51:	cd 40                	int    $0x40
     e53:	c3                   	ret    

00000e54 <uptime>:
     e54:	b8 0e 00 00 00       	mov    $0xe,%eax
     e59:	cd 40                	int    $0x40
     e5b:	c3                   	ret    

00000e5c <putc>:
     e5c:	55                   	push   %ebp
     e5d:	89 e5                	mov    %esp,%ebp
     e5f:	83 ec 18             	sub    $0x18,%esp
     e62:	8b 45 0c             	mov    0xc(%ebp),%eax
     e65:	88 45 f4             	mov    %al,-0xc(%ebp)
     e68:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e6f:	00 
     e70:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e73:	89 44 24 04          	mov    %eax,0x4(%esp)
     e77:	8b 45 08             	mov    0x8(%ebp),%eax
     e7a:	89 04 24             	mov    %eax,(%esp)
     e7d:	e8 5a ff ff ff       	call   ddc <write>
     e82:	c9                   	leave  
     e83:	c3                   	ret    

00000e84 <printint>:
     e84:	55                   	push   %ebp
     e85:	89 e5                	mov    %esp,%ebp
     e87:	56                   	push   %esi
     e88:	53                   	push   %ebx
     e89:	83 ec 30             	sub    $0x30,%esp
     e8c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     e93:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     e97:	74 17                	je     eb0 <printint+0x2c>
     e99:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e9d:	79 11                	jns    eb0 <printint+0x2c>
     e9f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ea9:	f7 d8                	neg    %eax
     eab:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eae:	eb 06                	jmp    eb6 <printint+0x32>
     eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb3:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     ebd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     ec0:	8d 41 01             	lea    0x1(%ecx),%eax
     ec3:	89 45 f4             	mov    %eax,-0xc(%ebp)
     ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
     ec9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ecc:	ba 00 00 00 00       	mov    $0x0,%edx
     ed1:	f7 f3                	div    %ebx
     ed3:	89 d0                	mov    %edx,%eax
     ed5:	8a 80 0c 19 00 00    	mov    0x190c(%eax),%al
     edb:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
     edf:	8b 75 10             	mov    0x10(%ebp),%esi
     ee2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ee5:	ba 00 00 00 00       	mov    $0x0,%edx
     eea:	f7 f6                	div    %esi
     eec:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eef:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ef3:	75 c8                	jne    ebd <printint+0x39>
     ef5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ef9:	74 10                	je     f0b <printint+0x87>
     efb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     efe:	8d 50 01             	lea    0x1(%eax),%edx
     f01:	89 55 f4             	mov    %edx,-0xc(%ebp)
     f04:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)
     f09:	eb 1e                	jmp    f29 <printint+0xa5>
     f0b:	eb 1c                	jmp    f29 <printint+0xa5>
     f0d:	8d 55 dc             	lea    -0x24(%ebp),%edx
     f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
     f13:	01 d0                	add    %edx,%eax
     f15:	8a 00                	mov    (%eax),%al
     f17:	0f be c0             	movsbl %al,%eax
     f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
     f1e:	8b 45 08             	mov    0x8(%ebp),%eax
     f21:	89 04 24             	mov    %eax,(%esp)
     f24:	e8 33 ff ff ff       	call   e5c <putc>
     f29:	ff 4d f4             	decl   -0xc(%ebp)
     f2c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f30:	79 db                	jns    f0d <printint+0x89>
     f32:	83 c4 30             	add    $0x30,%esp
     f35:	5b                   	pop    %ebx
     f36:	5e                   	pop    %esi
     f37:	5d                   	pop    %ebp
     f38:	c3                   	ret    

00000f39 <printf>:
     f39:	55                   	push   %ebp
     f3a:	89 e5                	mov    %esp,%ebp
     f3c:	83 ec 38             	sub    $0x38,%esp
     f3f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
     f46:	8d 45 0c             	lea    0xc(%ebp),%eax
     f49:	83 c0 04             	add    $0x4,%eax
     f4c:	89 45 e8             	mov    %eax,-0x18(%ebp)
     f4f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f56:	e9 77 01 00 00       	jmp    10d2 <printf+0x199>
     f5b:	8b 55 0c             	mov    0xc(%ebp),%edx
     f5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f61:	01 d0                	add    %edx,%eax
     f63:	8a 00                	mov    (%eax),%al
     f65:	0f be c0             	movsbl %al,%eax
     f68:	25 ff 00 00 00       	and    $0xff,%eax
     f6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     f70:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f74:	75 2c                	jne    fa2 <printf+0x69>
     f76:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f7a:	75 0c                	jne    f88 <printf+0x4f>
     f7c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f83:	e9 47 01 00 00       	jmp    10cf <printf+0x196>
     f88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f8b:	0f be c0             	movsbl %al,%eax
     f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
     f92:	8b 45 08             	mov    0x8(%ebp),%eax
     f95:	89 04 24             	mov    %eax,(%esp)
     f98:	e8 bf fe ff ff       	call   e5c <putc>
     f9d:	e9 2d 01 00 00       	jmp    10cf <printf+0x196>
     fa2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     fa6:	0f 85 23 01 00 00    	jne    10cf <printf+0x196>
     fac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     fb0:	75 2d                	jne    fdf <printf+0xa6>
     fb2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fb5:	8b 00                	mov    (%eax),%eax
     fb7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     fbe:	00 
     fbf:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     fc6:	00 
     fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     fcb:	8b 45 08             	mov    0x8(%ebp),%eax
     fce:	89 04 24             	mov    %eax,(%esp)
     fd1:	e8 ae fe ff ff       	call   e84 <printint>
     fd6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fda:	e9 e9 00 00 00       	jmp    10c8 <printf+0x18f>
     fdf:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     fe3:	74 06                	je     feb <printf+0xb2>
     fe5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     fe9:	75 2d                	jne    1018 <printf+0xdf>
     feb:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fee:	8b 00                	mov    (%eax),%eax
     ff0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ff7:	00 
     ff8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     fff:	00 
    1000:	89 44 24 04          	mov    %eax,0x4(%esp)
    1004:	8b 45 08             	mov    0x8(%ebp),%eax
    1007:	89 04 24             	mov    %eax,(%esp)
    100a:	e8 75 fe ff ff       	call   e84 <printint>
    100f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1013:	e9 b0 00 00 00       	jmp    10c8 <printf+0x18f>
    1018:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    101c:	75 42                	jne    1060 <printf+0x127>
    101e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1021:	8b 00                	mov    (%eax),%eax
    1023:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1026:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    102a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    102e:	75 09                	jne    1039 <printf+0x100>
    1030:	c7 45 f4 b9 14 00 00 	movl   $0x14b9,-0xc(%ebp)
    1037:	eb 1c                	jmp    1055 <printf+0x11c>
    1039:	eb 1a                	jmp    1055 <printf+0x11c>
    103b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    103e:	8a 00                	mov    (%eax),%al
    1040:	0f be c0             	movsbl %al,%eax
    1043:	89 44 24 04          	mov    %eax,0x4(%esp)
    1047:	8b 45 08             	mov    0x8(%ebp),%eax
    104a:	89 04 24             	mov    %eax,(%esp)
    104d:	e8 0a fe ff ff       	call   e5c <putc>
    1052:	ff 45 f4             	incl   -0xc(%ebp)
    1055:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1058:	8a 00                	mov    (%eax),%al
    105a:	84 c0                	test   %al,%al
    105c:	75 dd                	jne    103b <printf+0x102>
    105e:	eb 68                	jmp    10c8 <printf+0x18f>
    1060:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1064:	75 1d                	jne    1083 <printf+0x14a>
    1066:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1069:	8b 00                	mov    (%eax),%eax
    106b:	0f be c0             	movsbl %al,%eax
    106e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1072:	8b 45 08             	mov    0x8(%ebp),%eax
    1075:	89 04 24             	mov    %eax,(%esp)
    1078:	e8 df fd ff ff       	call   e5c <putc>
    107d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1081:	eb 45                	jmp    10c8 <printf+0x18f>
    1083:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1087:	75 17                	jne    10a0 <printf+0x167>
    1089:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    108c:	0f be c0             	movsbl %al,%eax
    108f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1093:	8b 45 08             	mov    0x8(%ebp),%eax
    1096:	89 04 24             	mov    %eax,(%esp)
    1099:	e8 be fd ff ff       	call   e5c <putc>
    109e:	eb 28                	jmp    10c8 <printf+0x18f>
    10a0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    10a7:	00 
    10a8:	8b 45 08             	mov    0x8(%ebp),%eax
    10ab:	89 04 24             	mov    %eax,(%esp)
    10ae:	e8 a9 fd ff ff       	call   e5c <putc>
    10b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10b6:	0f be c0             	movsbl %al,%eax
    10b9:	89 44 24 04          	mov    %eax,0x4(%esp)
    10bd:	8b 45 08             	mov    0x8(%ebp),%eax
    10c0:	89 04 24             	mov    %eax,(%esp)
    10c3:	e8 94 fd ff ff       	call   e5c <putc>
    10c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    10cf:	ff 45 f0             	incl   -0x10(%ebp)
    10d2:	8b 55 0c             	mov    0xc(%ebp),%edx
    10d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10d8:	01 d0                	add    %edx,%eax
    10da:	8a 00                	mov    (%eax),%al
    10dc:	84 c0                	test   %al,%al
    10de:	0f 85 77 fe ff ff    	jne    f5b <printf+0x22>
    10e4:	c9                   	leave  
    10e5:	c3                   	ret    
    10e6:	90                   	nop
    10e7:	90                   	nop

000010e8 <free>:
    10e8:	55                   	push   %ebp
    10e9:	89 e5                	mov    %esp,%ebp
    10eb:	83 ec 10             	sub    $0x10,%esp
    10ee:	8b 45 08             	mov    0x8(%ebp),%eax
    10f1:	83 e8 08             	sub    $0x8,%eax
    10f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
    10f7:	a1 30 19 00 00       	mov    0x1930,%eax
    10fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10ff:	eb 24                	jmp    1125 <free+0x3d>
    1101:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1104:	8b 00                	mov    (%eax),%eax
    1106:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1109:	77 12                	ja     111d <free+0x35>
    110b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    110e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1111:	77 24                	ja     1137 <free+0x4f>
    1113:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1116:	8b 00                	mov    (%eax),%eax
    1118:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    111b:	77 1a                	ja     1137 <free+0x4f>
    111d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1120:	8b 00                	mov    (%eax),%eax
    1122:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1125:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1128:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    112b:	76 d4                	jbe    1101 <free+0x19>
    112d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1130:	8b 00                	mov    (%eax),%eax
    1132:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1135:	76 ca                	jbe    1101 <free+0x19>
    1137:	8b 45 f8             	mov    -0x8(%ebp),%eax
    113a:	8b 40 04             	mov    0x4(%eax),%eax
    113d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1144:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1147:	01 c2                	add    %eax,%edx
    1149:	8b 45 fc             	mov    -0x4(%ebp),%eax
    114c:	8b 00                	mov    (%eax),%eax
    114e:	39 c2                	cmp    %eax,%edx
    1150:	75 24                	jne    1176 <free+0x8e>
    1152:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1155:	8b 50 04             	mov    0x4(%eax),%edx
    1158:	8b 45 fc             	mov    -0x4(%ebp),%eax
    115b:	8b 00                	mov    (%eax),%eax
    115d:	8b 40 04             	mov    0x4(%eax),%eax
    1160:	01 c2                	add    %eax,%edx
    1162:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1165:	89 50 04             	mov    %edx,0x4(%eax)
    1168:	8b 45 fc             	mov    -0x4(%ebp),%eax
    116b:	8b 00                	mov    (%eax),%eax
    116d:	8b 10                	mov    (%eax),%edx
    116f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1172:	89 10                	mov    %edx,(%eax)
    1174:	eb 0a                	jmp    1180 <free+0x98>
    1176:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1179:	8b 10                	mov    (%eax),%edx
    117b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    117e:	89 10                	mov    %edx,(%eax)
    1180:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1183:	8b 40 04             	mov    0x4(%eax),%eax
    1186:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    118d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1190:	01 d0                	add    %edx,%eax
    1192:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1195:	75 20                	jne    11b7 <free+0xcf>
    1197:	8b 45 fc             	mov    -0x4(%ebp),%eax
    119a:	8b 50 04             	mov    0x4(%eax),%edx
    119d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11a0:	8b 40 04             	mov    0x4(%eax),%eax
    11a3:	01 c2                	add    %eax,%edx
    11a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11a8:	89 50 04             	mov    %edx,0x4(%eax)
    11ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11ae:	8b 10                	mov    (%eax),%edx
    11b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b3:	89 10                	mov    %edx,(%eax)
    11b5:	eb 08                	jmp    11bf <free+0xd7>
    11b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11ba:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11bd:	89 10                	mov    %edx,(%eax)
    11bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c2:	a3 30 19 00 00       	mov    %eax,0x1930
    11c7:	c9                   	leave  
    11c8:	c3                   	ret    

000011c9 <morecore>:
    11c9:	55                   	push   %ebp
    11ca:	89 e5                	mov    %esp,%ebp
    11cc:	83 ec 28             	sub    $0x28,%esp
    11cf:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    11d6:	77 07                	ja     11df <morecore+0x16>
    11d8:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
    11df:	8b 45 08             	mov    0x8(%ebp),%eax
    11e2:	c1 e0 03             	shl    $0x3,%eax
    11e5:	89 04 24             	mov    %eax,(%esp)
    11e8:	e8 57 fc ff ff       	call   e44 <sbrk>
    11ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
    11f0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    11f4:	75 07                	jne    11fd <morecore+0x34>
    11f6:	b8 00 00 00 00       	mov    $0x0,%eax
    11fb:	eb 22                	jmp    121f <morecore+0x56>
    11fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1200:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1203:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1206:	8b 55 08             	mov    0x8(%ebp),%edx
    1209:	89 50 04             	mov    %edx,0x4(%eax)
    120c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    120f:	83 c0 08             	add    $0x8,%eax
    1212:	89 04 24             	mov    %eax,(%esp)
    1215:	e8 ce fe ff ff       	call   10e8 <free>
    121a:	a1 30 19 00 00       	mov    0x1930,%eax
    121f:	c9                   	leave  
    1220:	c3                   	ret    

00001221 <malloc>:
    1221:	55                   	push   %ebp
    1222:	89 e5                	mov    %esp,%ebp
    1224:	83 ec 28             	sub    $0x28,%esp
    1227:	8b 45 08             	mov    0x8(%ebp),%eax
    122a:	83 c0 07             	add    $0x7,%eax
    122d:	c1 e8 03             	shr    $0x3,%eax
    1230:	40                   	inc    %eax
    1231:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1234:	a1 30 19 00 00       	mov    0x1930,%eax
    1239:	89 45 f0             	mov    %eax,-0x10(%ebp)
    123c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1240:	75 23                	jne    1265 <malloc+0x44>
    1242:	c7 45 f0 28 19 00 00 	movl   $0x1928,-0x10(%ebp)
    1249:	8b 45 f0             	mov    -0x10(%ebp),%eax
    124c:	a3 30 19 00 00       	mov    %eax,0x1930
    1251:	a1 30 19 00 00       	mov    0x1930,%eax
    1256:	a3 28 19 00 00       	mov    %eax,0x1928
    125b:	c7 05 2c 19 00 00 00 	movl   $0x0,0x192c
    1262:	00 00 00 
    1265:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1268:	8b 00                	mov    (%eax),%eax
    126a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    126d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1270:	8b 40 04             	mov    0x4(%eax),%eax
    1273:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1276:	72 4d                	jb     12c5 <malloc+0xa4>
    1278:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127b:	8b 40 04             	mov    0x4(%eax),%eax
    127e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1281:	75 0c                	jne    128f <malloc+0x6e>
    1283:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1286:	8b 10                	mov    (%eax),%edx
    1288:	8b 45 f0             	mov    -0x10(%ebp),%eax
    128b:	89 10                	mov    %edx,(%eax)
    128d:	eb 26                	jmp    12b5 <malloc+0x94>
    128f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1292:	8b 40 04             	mov    0x4(%eax),%eax
    1295:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1298:	89 c2                	mov    %eax,%edx
    129a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129d:	89 50 04             	mov    %edx,0x4(%eax)
    12a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a3:	8b 40 04             	mov    0x4(%eax),%eax
    12a6:	c1 e0 03             	shl    $0x3,%eax
    12a9:	01 45 f4             	add    %eax,-0xc(%ebp)
    12ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12af:	8b 55 ec             	mov    -0x14(%ebp),%edx
    12b2:	89 50 04             	mov    %edx,0x4(%eax)
    12b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12b8:	a3 30 19 00 00       	mov    %eax,0x1930
    12bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c0:	83 c0 08             	add    $0x8,%eax
    12c3:	eb 38                	jmp    12fd <malloc+0xdc>
    12c5:	a1 30 19 00 00       	mov    0x1930,%eax
    12ca:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    12cd:	75 1b                	jne    12ea <malloc+0xc9>
    12cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12d2:	89 04 24             	mov    %eax,(%esp)
    12d5:	e8 ef fe ff ff       	call   11c9 <morecore>
    12da:	89 45 f4             	mov    %eax,-0xc(%ebp)
    12dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e1:	75 07                	jne    12ea <malloc+0xc9>
    12e3:	b8 00 00 00 00       	mov    $0x0,%eax
    12e8:	eb 13                	jmp    12fd <malloc+0xdc>
    12ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f3:	8b 00                	mov    (%eax),%eax
    12f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    12f8:	e9 70 ff ff ff       	jmp    126d <malloc+0x4c>
    12fd:	c9                   	leave  
    12fe:	c3                   	ret    
