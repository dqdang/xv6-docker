
_ctool:     file format elf32-i386


Disassembly of section .text:

00000000 <is_int>:
  struct container tuperwares[4];
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
  int id, fd;
  fd = open(argv[2], O_RDWR);
      5c:	8b 45 0c             	mov    0xc(%ebp),%eax
      5f:	83 c0 08             	add    $0x8,%eax
      62:	8b 00                	mov    (%eax),%eax
      64:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
      6b:	00 
      6c:	89 04 24             	mov    %eax,(%esp)
      6f:	e8 0c 0d 00 00       	call   d80 <open>
      74:	89 45 f4             	mov    %eax,-0xc(%ebp)
  printf(1, "fd = %d\n", fd);
      77:	8b 45 f4             	mov    -0xc(%ebp),%eax
      7a:	89 44 24 08          	mov    %eax,0x8(%esp)
      7e:	c7 44 24 04 84 12 00 	movl   $0x1284,0x4(%esp)
      85:	00 
      86:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      8d:	e8 2b 0e 00 00       	call   ebd <printf>

  /* fork a child and exec argv[4] */
  id = fork();
      92:	e8 a1 0c 00 00       	call   d38 <fork>
      97:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (id == 0)
      9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
      9e:	0f 85 9c 00 00 00    	jne    140 <start+0xea>
  {
    close(0);
      a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      ab:	e8 b8 0c 00 00       	call   d68 <close>
    close(1);
      b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      b7:	e8 ac 0c 00 00       	call   d68 <close>
    close(2);
      bc:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c3:	e8 a0 0c 00 00       	call   d68 <close>
    dup(fd);
      c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
      cb:	89 04 24             	mov    %eax,(%esp)
      ce:	e8 e5 0c 00 00       	call   db8 <dup>
    dup(fd);
      d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d6:	89 04 24             	mov    %eax,(%esp)
      d9:	e8 da 0c 00 00       	call   db8 <dup>
    dup(fd);
      de:	8b 45 f4             	mov    -0xc(%ebp),%eax
      e1:	89 04 24             	mov    %eax,(%esp)
      e4:	e8 cf 0c 00 00       	call   db8 <dup>
    if(chdir(argv[3]) < 0)
      e9:	8b 45 0c             	mov    0xc(%ebp),%eax
      ec:	83 c0 0c             	add    $0xc,%eax
      ef:	8b 00                	mov    (%eax),%eax
      f1:	89 04 24             	mov    %eax,(%esp)
      f4:	e8 b7 0c 00 00       	call   db0 <chdir>
      f9:	85 c0                	test   %eax,%eax
      fb:	79 19                	jns    116 <start+0xc0>
    {
      printf(1, "Container does not exist.");
      fd:	c7 44 24 04 8d 12 00 	movl   $0x128d,0x4(%esp)
     104:	00 
     105:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     10c:	e8 ac 0d 00 00       	call   ebd <printf>
      exit();
     111:	e8 2a 0c 00 00       	call   d40 <exit>
    }
    exec(argv[4], &argv[4]);
     116:	8b 45 0c             	mov    0xc(%ebp),%eax
     119:	8d 50 10             	lea    0x10(%eax),%edx
     11c:	8b 45 0c             	mov    0xc(%ebp),%eax
     11f:	83 c0 10             	add    $0x10,%eax
     122:	8b 00                	mov    (%eax),%eax
     124:	89 54 24 04          	mov    %edx,0x4(%esp)
     128:	89 04 24             	mov    %eax,(%esp)
     12b:	e8 48 0c 00 00       	call   d78 <exec>
    close(fd);
     130:	8b 45 f4             	mov    -0xc(%ebp),%eax
     133:	89 04 24             	mov    %eax,(%esp)
     136:	e8 2d 0c 00 00       	call   d68 <close>
    exit();
     13b:	e8 00 0c 00 00       	call   d40 <exit>
  }

  return 0;
     140:	b8 00 00 00 00       	mov    $0x0,%eax
}
     145:	c9                   	leave  
     146:	c3                   	ret    

00000147 <create>:

// ctool create c0 cat ls echo sh ...
int create(int argc, char *argv[])
{
     147:	55                   	push   %ebp
     148:	89 e5                	mov    %esp,%ebp
     14a:	53                   	push   %ebx
     14b:	83 ec 54             	sub    $0x54,%esp
  int i, id, cindex = 0;
     14e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  char *mkdir[2];
  mkdir[0] = "mkdir";
     155:	c7 45 e0 a7 12 00 00 	movl   $0x12a7,-0x20(%ebp)
  mkdir[1] = argv[2];
     15c:	8b 45 0c             	mov    0xc(%ebp),%eax
     15f:	8b 40 08             	mov    0x8(%eax),%eax
     162:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  while(!is_int(argv[2][cindex]))
     165:	eb 03                	jmp    16a <create+0x23>
  {
    cindex = cindex + 1;
     167:	ff 45 f0             	incl   -0x10(%ebp)
  int i, id, cindex = 0;
  char *mkdir[2];
  mkdir[0] = "mkdir";
  mkdir[1] = argv[2];

  while(!is_int(argv[2][cindex]))
     16a:	8b 45 0c             	mov    0xc(%ebp),%eax
     16d:	83 c0 08             	add    $0x8,%eax
     170:	8b 10                	mov    (%eax),%edx
     172:	8b 45 f0             	mov    -0x10(%ebp),%eax
     175:	01 d0                	add    %edx,%eax
     177:	8a 00                	mov    (%eax),%al
     179:	0f be c0             	movsbl %al,%eax
     17c:	89 04 24             	mov    %eax,(%esp)
     17f:	e8 7c fe ff ff       	call   0 <is_int>
     184:	85 c0                	test   %eax,%eax
     186:	74 df                	je     167 <create+0x20>
  {
    cindex = cindex + 1;
  }

  strcpy(ctable.tuperwares[cindex].name, argv[2]);
     188:	8b 45 0c             	mov    0xc(%ebp),%eax
     18b:	83 c0 08             	add    $0x8,%eax
     18e:	8b 08                	mov    (%eax),%ecx
     190:	8b 55 f0             	mov    -0x10(%ebp),%edx
     193:	89 d0                	mov    %edx,%eax
     195:	01 c0                	add    %eax,%eax
     197:	01 d0                	add    %edx,%eax
     199:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     1a0:	01 d8                	add    %ebx,%eax
     1a2:	01 d0                	add    %edx,%eax
     1a4:	05 20 18 00 00       	add    $0x1820,%eax
     1a9:	8b 00                	mov    (%eax),%eax
     1ab:	89 4c 24 04          	mov    %ecx,0x4(%esp)
     1af:	89 04 24             	mov    %eax,(%esp)
     1b2:	e8 ea 03 00 00       	call   5a1 <strcpy>
  ctable.count = ctable.count + 1;
     1b7:	a1 90 18 00 00       	mov    0x1890,%eax
     1bc:	40                   	inc    %eax
     1bd:	a3 90 18 00 00       	mov    %eax,0x1890
  ctable.tuperwares[cindex].max_proc = atoi(argv[3]);
     1c2:	8b 45 0c             	mov    0xc(%ebp),%eax
     1c5:	83 c0 0c             	add    $0xc,%eax
     1c8:	8b 00                	mov    (%eax),%eax
     1ca:	89 04 24             	mov    %eax,(%esp)
     1cd:	e8 dd 0a 00 00       	call   caf <atoi>
     1d2:	89 c1                	mov    %eax,%ecx
     1d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
     1d7:	89 d0                	mov    %edx,%eax
     1d9:	01 c0                	add    %eax,%eax
     1db:	01 d0                	add    %edx,%eax
     1dd:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     1e4:	01 d8                	add    %ebx,%eax
     1e6:	01 d0                	add    %edx,%eax
     1e8:	05 20 18 00 00       	add    $0x1820,%eax
     1ed:	89 48 08             	mov    %ecx,0x8(%eax)
  ctable.tuperwares[cindex].max_mem = atoi(argv[4])*1000000;
     1f0:	8b 45 0c             	mov    0xc(%ebp),%eax
     1f3:	83 c0 10             	add    $0x10,%eax
     1f6:	8b 00                	mov    (%eax),%eax
     1f8:	89 04 24             	mov    %eax,(%esp)
     1fb:	e8 af 0a 00 00       	call   caf <atoi>
     200:	89 c2                	mov    %eax,%edx
     202:	89 d0                	mov    %edx,%eax
     204:	c1 e0 02             	shl    $0x2,%eax
     207:	01 d0                	add    %edx,%eax
     209:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     210:	01 d0                	add    %edx,%eax
     212:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     219:	01 d0                	add    %edx,%eax
     21b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     222:	01 d0                	add    %edx,%eax
     224:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     22b:	01 d0                	add    %edx,%eax
     22d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     234:	01 d0                	add    %edx,%eax
     236:	c1 e0 06             	shl    $0x6,%eax
     239:	89 c1                	mov    %eax,%ecx
     23b:	8b 55 f0             	mov    -0x10(%ebp),%edx
     23e:	89 d0                	mov    %edx,%eax
     240:	01 c0                	add    %eax,%eax
     242:	01 d0                	add    %edx,%eax
     244:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     24b:	01 d8                	add    %ebx,%eax
     24d:	01 d0                	add    %edx,%eax
     24f:	05 20 18 00 00       	add    $0x1820,%eax
     254:	89 48 0c             	mov    %ecx,0xc(%eax)
  ctable.tuperwares[cindex].max_disk = atoi(argv[5])*1000000;
     257:	8b 45 0c             	mov    0xc(%ebp),%eax
     25a:	83 c0 14             	add    $0x14,%eax
     25d:	8b 00                	mov    (%eax),%eax
     25f:	89 04 24             	mov    %eax,(%esp)
     262:	e8 48 0a 00 00       	call   caf <atoi>
     267:	89 c2                	mov    %eax,%edx
     269:	89 d0                	mov    %edx,%eax
     26b:	c1 e0 02             	shl    $0x2,%eax
     26e:	01 d0                	add    %edx,%eax
     270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     277:	01 d0                	add    %edx,%eax
     279:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     280:	01 d0                	add    %edx,%eax
     282:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     289:	01 d0                	add    %edx,%eax
     28b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     292:	01 d0                	add    %edx,%eax
     294:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     29b:	01 d0                	add    %edx,%eax
     29d:	c1 e0 06             	shl    $0x6,%eax
     2a0:	89 c1                	mov    %eax,%ecx
     2a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
     2a5:	89 d0                	mov    %edx,%eax
     2a7:	01 c0                	add    %eax,%eax
     2a9:	01 d0                	add    %edx,%eax
     2ab:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     2b2:	01 d8                	add    %ebx,%eax
     2b4:	01 d0                	add    %edx,%eax
     2b6:	05 30 18 00 00       	add    $0x1830,%eax
     2bb:	89 08                	mov    %ecx,(%eax)
  ctable.tuperwares[cindex].used_mem = 0;
     2bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
     2c0:	89 d0                	mov    %edx,%eax
     2c2:	01 c0                	add    %eax,%eax
     2c4:	01 d0                	add    %edx,%eax
     2c6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     2cd:	01 c8                	add    %ecx,%eax
     2cf:	01 d0                	add    %edx,%eax
     2d1:	05 30 18 00 00       	add    $0x1830,%eax
     2d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  ctable.tuperwares[cindex].used_disk = 0;
     2dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
     2e0:	89 d0                	mov    %edx,%eax
     2e2:	01 c0                	add    %eax,%eax
     2e4:	01 d0                	add    %edx,%eax
     2e6:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     2ed:	01 c8                	add    %ecx,%eax
     2ef:	01 d0                	add    %edx,%eax
     2f1:	05 30 18 00 00       	add    $0x1830,%eax
     2f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)



  id = fork();
     2fd:	e8 36 0a 00 00       	call   d38 <fork>
     302:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id == 0)
     305:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     309:	75 12                	jne    31d <create+0x1d6>
  {
    exec(mkdir[0], mkdir);
     30b:	8b 45 e0             	mov    -0x20(%ebp),%eax
     30e:	8d 55 e0             	lea    -0x20(%ebp),%edx
     311:	89 54 24 04          	mov    %edx,0x4(%esp)
     315:	89 04 24             	mov    %eax,(%esp)
     318:	e8 5b 0a 00 00       	call   d78 <exec>
  }
  id = wait();
     31d:	e8 26 0a 00 00       	call   d48 <wait>
     322:	89 45 ec             	mov    %eax,-0x14(%ebp)

  for(i = 6; i < argc; i++) // going through ls echo cat ...
     325:	c7 45 f4 06 00 00 00 	movl   $0x6,-0xc(%ebp)
     32c:	e9 8f 01 00 00       	jmp    4c0 <create+0x379>
  {
    
      // char *executable[4];
    char destination[32];

    strcpy(destination, "/");
     331:	c7 44 24 04 ad 12 00 	movl   $0x12ad,0x4(%esp)
     338:	00 
     339:	8d 45 b8             	lea    -0x48(%ebp),%eax
     33c:	89 04 24             	mov    %eax,(%esp)
     33f:	e8 5d 02 00 00       	call   5a1 <strcpy>
    strcat(destination, mkdir[1]);
     344:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     347:	89 44 24 04          	mov    %eax,0x4(%esp)
     34b:	8d 45 b8             	lea    -0x48(%ebp),%eax
     34e:	89 04 24             	mov    %eax,(%esp)
     351:	e8 8c 04 00 00       	call   7e2 <strcat>
    strcat(destination, "/");
     356:	c7 44 24 04 ad 12 00 	movl   $0x12ad,0x4(%esp)
     35d:	00 
     35e:	8d 45 b8             	lea    -0x48(%ebp),%eax
     361:	89 04 24             	mov    %eax,(%esp)
     364:	e8 79 04 00 00       	call   7e2 <strcat>
    strcat(destination, argv[i]);
     369:	8b 45 f4             	mov    -0xc(%ebp),%eax
     36c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     373:	8b 45 0c             	mov    0xc(%ebp),%eax
     376:	01 d0                	add    %edx,%eax
     378:	8b 00                	mov    (%eax),%eax
     37a:	89 44 24 04          	mov    %eax,0x4(%esp)
     37e:	8d 45 b8             	lea    -0x48(%ebp),%eax
     381:	89 04 24             	mov    %eax,(%esp)
     384:	e8 59 04 00 00       	call   7e2 <strcat>
    strcat(destination, "\0");
     389:	c7 44 24 04 af 12 00 	movl   $0x12af,0x4(%esp)
     390:	00 
     391:	8d 45 b8             	lea    -0x48(%ebp),%eax
     394:	89 04 24             	mov    %eax,(%esp)
     397:	e8 46 04 00 00       	call   7e2 <strcat>
    int bytes = copy(argv[i], destination, ctable.tuperwares[cindex].used_disk, ctable.tuperwares[cindex].max_disk);
     39c:	8b 55 f0             	mov    -0x10(%ebp),%edx
     39f:	89 d0                	mov    %edx,%eax
     3a1:	01 c0                	add    %eax,%eax
     3a3:	01 d0                	add    %edx,%eax
     3a5:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     3ac:	01 c8                	add    %ecx,%eax
     3ae:	01 d0                	add    %edx,%eax
     3b0:	05 30 18 00 00       	add    $0x1830,%eax
     3b5:	8b 08                	mov    (%eax),%ecx
     3b7:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3ba:	89 d0                	mov    %edx,%eax
     3bc:	01 c0                	add    %eax,%eax
     3be:	01 d0                	add    %edx,%eax
     3c0:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     3c7:	01 d8                	add    %ebx,%eax
     3c9:	01 d0                	add    %edx,%eax
     3cb:	05 30 18 00 00       	add    $0x1830,%eax
     3d0:	8b 50 08             	mov    0x8(%eax),%edx
     3d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3d6:	8d 1c 85 00 00 00 00 	lea    0x0(,%eax,4),%ebx
     3dd:	8b 45 0c             	mov    0xc(%ebp),%eax
     3e0:	01 d8                	add    %ebx,%eax
     3e2:	8b 00                	mov    (%eax),%eax
     3e4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     3e8:	89 54 24 08          	mov    %edx,0x8(%esp)
     3ec:	8d 55 b8             	lea    -0x48(%ebp),%edx
     3ef:	89 54 24 04          	mov    %edx,0x4(%esp)
     3f3:	89 04 24             	mov    %eax,(%esp)
     3f6:	e8 d4 01 00 00       	call   5cf <copy>
     3fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Bytes for each file: %d\n", bytes);
     3fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
     401:	89 44 24 08          	mov    %eax,0x8(%esp)
     405:	c7 44 24 04 b1 12 00 	movl   $0x12b1,0x4(%esp)
     40c:	00 
     40d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     414:	e8 a4 0a 00 00       	call   ebd <printf>
    if(bytes > 0){
     419:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     41d:	7e 40                	jle    45f <create+0x318>
      ctable.tuperwares[cindex].used_disk += bytes; 
     41f:	8b 55 f0             	mov    -0x10(%ebp),%edx
     422:	89 d0                	mov    %edx,%eax
     424:	01 c0                	add    %eax,%eax
     426:	01 d0                	add    %edx,%eax
     428:	8d 0c c5 00 00 00 00 	lea    0x0(,%eax,8),%ecx
     42f:	01 c8                	add    %ecx,%eax
     431:	01 d0                	add    %edx,%eax
     433:	05 30 18 00 00       	add    $0x1830,%eax
     438:	8b 50 08             	mov    0x8(%eax),%edx
     43b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     43e:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
     441:	8b 55 f0             	mov    -0x10(%ebp),%edx
     444:	89 d0                	mov    %edx,%eax
     446:	01 c0                	add    %eax,%eax
     448:	01 d0                	add    %edx,%eax
     44a:	8d 1c c5 00 00 00 00 	lea    0x0(,%eax,8),%ebx
     451:	01 d8                	add    %ebx,%eax
     453:	01 d0                	add    %edx,%eax
     455:	05 30 18 00 00       	add    $0x1830,%eax
     45a:	89 48 08             	mov    %ecx,0x8(%eax)
     45d:	eb 5e                	jmp    4bd <create+0x376>
    }else{
      printf(1, "\nCONTAINER OUT OF MEMORY!\nFailed to copy executable %s. Removing incomplete binary.\n\n", argv[i]);
     45f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     462:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
     469:	8b 45 0c             	mov    0xc(%ebp),%eax
     46c:	01 d0                	add    %edx,%eax
     46e:	8b 00                	mov    (%eax),%eax
     470:	89 44 24 08          	mov    %eax,0x8(%esp)
     474:	c7 44 24 04 cc 12 00 	movl   $0x12cc,0x4(%esp)
     47b:	00 
     47c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     483:	e8 35 0a 00 00       	call   ebd <printf>
      id = fork();
     488:	e8 ab 08 00 00       	call   d38 <fork>
     48d:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(id == 0){
     490:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     494:	75 1f                	jne    4b5 <create+0x36e>
        char *remove_args[2];
        remove_args[0] = "rm";
     496:	c7 45 d8 22 13 00 00 	movl   $0x1322,-0x28(%ebp)
        remove_args[1] = destination;
     49d:	8d 45 b8             	lea    -0x48(%ebp),%eax
     4a0:	89 45 dc             	mov    %eax,-0x24(%ebp)
        exec(remove_args[0], remove_args);
     4a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
     4a6:	8d 55 d8             	lea    -0x28(%ebp),%edx
     4a9:	89 54 24 04          	mov    %edx,0x4(%esp)
     4ad:	89 04 24             	mov    %eax,(%esp)
     4b0:	e8 c3 08 00 00       	call   d78 <exec>
      }id = wait();
     4b5:	e8 8e 08 00 00       	call   d48 <wait>
     4ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  {
    exec(mkdir[0], mkdir);
  }
  id = wait();

  for(i = 6; i < argc; i++) // going through ls echo cat ...
     4bd:	ff 45 f4             	incl   -0xc(%ebp)
     4c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c3:	3b 45 08             	cmp    0x8(%ebp),%eax
     4c6:	0f 8c 65 fe ff ff    	jl     331 <create+0x1ea>
        remove_args[1] = destination;
        exec(remove_args[0], remove_args);
      }id = wait();
    }
  }
  return 0;
     4cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
     4d1:	83 c4 54             	add    $0x54,%esp
     4d4:	5b                   	pop    %ebx
     4d5:	5d                   	pop    %ebp
     4d6:	c3                   	ret    

000004d7 <main>:

int main(int argc, char *argv[])
{
     4d7:	55                   	push   %ebp
     4d8:	89 e5                	mov    %esp,%ebp
     4da:	83 e4 f0             	and    $0xfffffff0,%esp
     4dd:	83 ec 10             	sub    $0x10,%esp
  {
    // TODO:
    // print_usage();
  }

  if(strcmp(argv[1], "create") == 0)
     4e0:	8b 45 0c             	mov    0xc(%ebp),%eax
     4e3:	83 c0 04             	add    $0x4,%eax
     4e6:	8b 00                	mov    (%eax),%eax
     4e8:	c7 44 24 04 25 13 00 	movl   $0x1325,0x4(%esp)
     4ef:	00 
     4f0:	89 04 24             	mov    %eax,(%esp)
     4f3:	e8 eb 01 00 00       	call   6e3 <strcmp>
     4f8:	85 c0                	test   %eax,%eax
     4fa:	75 47                	jne    543 <main+0x6c>
  {
    if(argc < 4)
     4fc:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
     500:	7e 41                	jle    543 <main+0x6c>
      // TODO:
      // print_usage("create");
    }
    else
    {
      if(chdir(argv[2]) < 0)
     502:	8b 45 0c             	mov    0xc(%ebp),%eax
     505:	83 c0 08             	add    $0x8,%eax
     508:	8b 00                	mov    (%eax),%eax
     50a:	89 04 24             	mov    %eax,(%esp)
     50d:	e8 9e 08 00 00       	call   db0 <chdir>
     512:	85 c0                	test   %eax,%eax
     514:	79 14                	jns    52a <main+0x53>
      {
         create(argc, argv);
     516:	8b 45 0c             	mov    0xc(%ebp),%eax
     519:	89 44 24 04          	mov    %eax,0x4(%esp)
     51d:	8b 45 08             	mov    0x8(%ebp),%eax
     520:	89 04 24             	mov    %eax,(%esp)
     523:	e8 1f fc ff ff       	call   147 <create>
     528:	eb 19                	jmp    543 <main+0x6c>
      }
      else
      {
        printf(1, "This device already has a container's filesystem\n");
     52a:	c7 44 24 04 2c 13 00 	movl   $0x132c,0x4(%esp)
     531:	00 
     532:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     539:	e8 7f 09 00 00       	call   ebd <printf>
        exit();
     53e:	e8 fd 07 00 00       	call   d40 <exit>
      }
    }
  }

  if(strcmp(argv[1], "start") == 0)
     543:	8b 45 0c             	mov    0xc(%ebp),%eax
     546:	83 c0 04             	add    $0x4,%eax
     549:	8b 00                	mov    (%eax),%eax
     54b:	c7 44 24 04 5e 13 00 	movl   $0x135e,0x4(%esp)
     552:	00 
     553:	89 04 24             	mov    %eax,(%esp)
     556:	e8 88 01 00 00       	call   6e3 <strcmp>
     55b:	85 c0                	test   %eax,%eax
     55d:	75 18                	jne    577 <main+0xa0>
  {
    if(argc < 4)
     55f:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
     563:	7e 12                	jle    577 <main+0xa0>
      // TODO:
      // print_usage("create");
    }
    else
    {
      start(argc, argv);
     565:	8b 45 0c             	mov    0xc(%ebp),%eax
     568:	89 44 24 04          	mov    %eax,0x4(%esp)
     56c:	8b 45 08             	mov    0x8(%ebp),%eax
     56f:	89 04 24             	mov    %eax,(%esp)
     572:	e8 df fa ff ff       	call   56 <start>
    }
  }

  exit();
     577:	e8 c4 07 00 00       	call   d40 <exit>

0000057c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     57c:	55                   	push   %ebp
     57d:	89 e5                	mov    %esp,%ebp
     57f:	57                   	push   %edi
     580:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     581:	8b 4d 08             	mov    0x8(%ebp),%ecx
     584:	8b 55 10             	mov    0x10(%ebp),%edx
     587:	8b 45 0c             	mov    0xc(%ebp),%eax
     58a:	89 cb                	mov    %ecx,%ebx
     58c:	89 df                	mov    %ebx,%edi
     58e:	89 d1                	mov    %edx,%ecx
     590:	fc                   	cld    
     591:	f3 aa                	rep stos %al,%es:(%edi)
     593:	89 ca                	mov    %ecx,%edx
     595:	89 fb                	mov    %edi,%ebx
     597:	89 5d 08             	mov    %ebx,0x8(%ebp)
     59a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     59d:	5b                   	pop    %ebx
     59e:	5f                   	pop    %edi
     59f:	5d                   	pop    %ebp
     5a0:	c3                   	ret    

000005a1 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     5a1:	55                   	push   %ebp
     5a2:	89 e5                	mov    %esp,%ebp
     5a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     5a7:	8b 45 08             	mov    0x8(%ebp),%eax
     5aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     5ad:	90                   	nop
     5ae:	8b 45 08             	mov    0x8(%ebp),%eax
     5b1:	8d 50 01             	lea    0x1(%eax),%edx
     5b4:	89 55 08             	mov    %edx,0x8(%ebp)
     5b7:	8b 55 0c             	mov    0xc(%ebp),%edx
     5ba:	8d 4a 01             	lea    0x1(%edx),%ecx
     5bd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     5c0:	8a 12                	mov    (%edx),%dl
     5c2:	88 10                	mov    %dl,(%eax)
     5c4:	8a 00                	mov    (%eax),%al
     5c6:	84 c0                	test   %al,%al
     5c8:	75 e4                	jne    5ae <strcpy+0xd>
    ;
  return os;
     5ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     5cd:	c9                   	leave  
     5ce:	c3                   	ret    

000005cf <copy>:

int copy(char *inputfile, char *outputfile, int used_disk, int max_disk){
     5cf:	55                   	push   %ebp
     5d0:	89 e5                	mov    %esp,%ebp
     5d2:	83 ec 58             	sub    $0x58,%esp
    char buffer[32];
    int fd1, fd2, count, bytes;
        
    if ( (fd1 = open(inputfile, O_RDONLY)) < 0) {
     5d5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5dc:	00 
     5dd:	8b 45 08             	mov    0x8(%ebp),%eax
     5e0:	89 04 24             	mov    %eax,(%esp)
     5e3:	e8 98 07 00 00       	call   d80 <open>
     5e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
     5eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     5ef:	79 20                	jns    611 <copy+0x42>
        printf(1, "Cannot open inputfile: %s\n", inputfile);
     5f1:	8b 45 08             	mov    0x8(%ebp),%eax
     5f4:	89 44 24 08          	mov    %eax,0x8(%esp)
     5f8:	c7 44 24 04 64 13 00 	movl   $0x1364,0x4(%esp)
     5ff:	00 
     600:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     607:	e8 b1 08 00 00       	call   ebd <printf>
        exit();
     60c:	e8 2f 07 00 00       	call   d40 <exit>
    }
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
     611:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     618:	00 
     619:	8b 45 0c             	mov    0xc(%ebp),%eax
     61c:	89 04 24             	mov    %eax,(%esp)
     61f:	e8 5c 07 00 00       	call   d80 <open>
     624:	89 45 ec             	mov    %eax,-0x14(%ebp)
     627:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     62b:	79 20                	jns    64d <copy+0x7e>
        printf(1, "Cannot open outputfile: %s\n", outputfile);
     62d:	8b 45 0c             	mov    0xc(%ebp),%eax
     630:	89 44 24 08          	mov    %eax,0x8(%esp)
     634:	c7 44 24 04 7f 13 00 	movl   $0x137f,0x4(%esp)
     63b:	00 
     63c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     643:	e8 75 08 00 00       	call   ebd <printf>
        exit();
     648:	e8 f3 06 00 00       	call   d40 <exit>
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
     64d:	eb 56                	jmp    6a5 <copy+0xd6>
        int max = used_disk+=count;
     64f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     652:	01 45 10             	add    %eax,0x10(%ebp)
     655:	8b 45 10             	mov    0x10(%ebp),%eax
     658:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        printf(1, "This is max: %d\n", max);
     65b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     65e:	89 44 24 08          	mov    %eax,0x8(%esp)
     662:	c7 44 24 04 9b 13 00 	movl   $0x139b,0x4(%esp)
     669:	00 
     66a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     671:	e8 47 08 00 00       	call   ebd <printf>
        if(max > max_disk){
     676:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     679:	3b 45 14             	cmp    0x14(%ebp),%eax
     67c:	7e 07                	jle    685 <copy+0xb6>
          return -1;
     67e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     683:	eb 5c                	jmp    6e1 <copy+0x112>
        }
        bytes = bytes + count;
     685:	8b 45 e8             	mov    -0x18(%ebp),%eax
     688:	01 45 f4             	add    %eax,-0xc(%ebp)
        write(fd2, buffer, 32);
     68b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     692:	00 
     693:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     696:	89 44 24 04          	mov    %eax,0x4(%esp)
     69a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     69d:	89 04 24             	mov    %eax,(%esp)
     6a0:	e8 bb 06 00 00       	call   d60 <write>
    if ( (fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0) {
        printf(1, "Cannot open outputfile: %s\n", outputfile);
        exit();
    }

    while ( (count = read(fd1, buffer, 32)) > 0 ) {
     6a5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     6ac:	00 
     6ad:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     6b0:	89 44 24 04          	mov    %eax,0x4(%esp)
     6b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6b7:	89 04 24             	mov    %eax,(%esp)
     6ba:	e8 99 06 00 00       	call   d58 <read>
     6bf:	89 45 e8             	mov    %eax,-0x18(%ebp)
     6c2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     6c6:	7f 87                	jg     64f <copy+0x80>
        }
        bytes = bytes + count;
        write(fd2, buffer, 32);
    }

    close(fd1);
     6c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     6cb:	89 04 24             	mov    %eax,(%esp)
     6ce:	e8 95 06 00 00       	call   d68 <close>
    close(fd2);
     6d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     6d6:	89 04 24             	mov    %eax,(%esp)
     6d9:	e8 8a 06 00 00       	call   d68 <close>
    return(bytes);
     6de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6e1:	c9                   	leave  
     6e2:	c3                   	ret    

000006e3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     6e3:	55                   	push   %ebp
     6e4:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     6e6:	eb 06                	jmp    6ee <strcmp+0xb>
    p++, q++;
     6e8:	ff 45 08             	incl   0x8(%ebp)
     6eb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     6ee:	8b 45 08             	mov    0x8(%ebp),%eax
     6f1:	8a 00                	mov    (%eax),%al
     6f3:	84 c0                	test   %al,%al
     6f5:	74 0e                	je     705 <strcmp+0x22>
     6f7:	8b 45 08             	mov    0x8(%ebp),%eax
     6fa:	8a 10                	mov    (%eax),%dl
     6fc:	8b 45 0c             	mov    0xc(%ebp),%eax
     6ff:	8a 00                	mov    (%eax),%al
     701:	38 c2                	cmp    %al,%dl
     703:	74 e3                	je     6e8 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     705:	8b 45 08             	mov    0x8(%ebp),%eax
     708:	8a 00                	mov    (%eax),%al
     70a:	0f b6 d0             	movzbl %al,%edx
     70d:	8b 45 0c             	mov    0xc(%ebp),%eax
     710:	8a 00                	mov    (%eax),%al
     712:	0f b6 c0             	movzbl %al,%eax
     715:	29 c2                	sub    %eax,%edx
     717:	89 d0                	mov    %edx,%eax
}
     719:	5d                   	pop    %ebp
     71a:	c3                   	ret    

0000071b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     71b:	55                   	push   %ebp
     71c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     71e:	eb 09                	jmp    729 <strncmp+0xe>
    n--, p++, q++;
     720:	ff 4d 10             	decl   0x10(%ebp)
     723:	ff 45 08             	incl   0x8(%ebp)
     726:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     729:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     72d:	74 17                	je     746 <strncmp+0x2b>
     72f:	8b 45 08             	mov    0x8(%ebp),%eax
     732:	8a 00                	mov    (%eax),%al
     734:	84 c0                	test   %al,%al
     736:	74 0e                	je     746 <strncmp+0x2b>
     738:	8b 45 08             	mov    0x8(%ebp),%eax
     73b:	8a 10                	mov    (%eax),%dl
     73d:	8b 45 0c             	mov    0xc(%ebp),%eax
     740:	8a 00                	mov    (%eax),%al
     742:	38 c2                	cmp    %al,%dl
     744:	74 da                	je     720 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     746:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     74a:	75 07                	jne    753 <strncmp+0x38>
    return 0;
     74c:	b8 00 00 00 00       	mov    $0x0,%eax
     751:	eb 14                	jmp    767 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     753:	8b 45 08             	mov    0x8(%ebp),%eax
     756:	8a 00                	mov    (%eax),%al
     758:	0f b6 d0             	movzbl %al,%edx
     75b:	8b 45 0c             	mov    0xc(%ebp),%eax
     75e:	8a 00                	mov    (%eax),%al
     760:	0f b6 c0             	movzbl %al,%eax
     763:	29 c2                	sub    %eax,%edx
     765:	89 d0                	mov    %edx,%eax
}
     767:	5d                   	pop    %ebp
     768:	c3                   	ret    

00000769 <strlen>:

uint
strlen(const char *s)
{
     769:	55                   	push   %ebp
     76a:	89 e5                	mov    %esp,%ebp
     76c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     76f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     776:	eb 03                	jmp    77b <strlen+0x12>
     778:	ff 45 fc             	incl   -0x4(%ebp)
     77b:	8b 55 fc             	mov    -0x4(%ebp),%edx
     77e:	8b 45 08             	mov    0x8(%ebp),%eax
     781:	01 d0                	add    %edx,%eax
     783:	8a 00                	mov    (%eax),%al
     785:	84 c0                	test   %al,%al
     787:	75 ef                	jne    778 <strlen+0xf>
    ;
  return n;
     789:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     78c:	c9                   	leave  
     78d:	c3                   	ret    

0000078e <memset>:

void*
memset(void *dst, int c, uint n)
{
     78e:	55                   	push   %ebp
     78f:	89 e5                	mov    %esp,%ebp
     791:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     794:	8b 45 10             	mov    0x10(%ebp),%eax
     797:	89 44 24 08          	mov    %eax,0x8(%esp)
     79b:	8b 45 0c             	mov    0xc(%ebp),%eax
     79e:	89 44 24 04          	mov    %eax,0x4(%esp)
     7a2:	8b 45 08             	mov    0x8(%ebp),%eax
     7a5:	89 04 24             	mov    %eax,(%esp)
     7a8:	e8 cf fd ff ff       	call   57c <stosb>
  return dst;
     7ad:	8b 45 08             	mov    0x8(%ebp),%eax
}
     7b0:	c9                   	leave  
     7b1:	c3                   	ret    

000007b2 <strchr>:

char*
strchr(const char *s, char c)
{
     7b2:	55                   	push   %ebp
     7b3:	89 e5                	mov    %esp,%ebp
     7b5:	83 ec 04             	sub    $0x4,%esp
     7b8:	8b 45 0c             	mov    0xc(%ebp),%eax
     7bb:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     7be:	eb 12                	jmp    7d2 <strchr+0x20>
    if(*s == c)
     7c0:	8b 45 08             	mov    0x8(%ebp),%eax
     7c3:	8a 00                	mov    (%eax),%al
     7c5:	3a 45 fc             	cmp    -0x4(%ebp),%al
     7c8:	75 05                	jne    7cf <strchr+0x1d>
      return (char*)s;
     7ca:	8b 45 08             	mov    0x8(%ebp),%eax
     7cd:	eb 11                	jmp    7e0 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     7cf:	ff 45 08             	incl   0x8(%ebp)
     7d2:	8b 45 08             	mov    0x8(%ebp),%eax
     7d5:	8a 00                	mov    (%eax),%al
     7d7:	84 c0                	test   %al,%al
     7d9:	75 e5                	jne    7c0 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     7db:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7e0:	c9                   	leave  
     7e1:	c3                   	ret    

000007e2 <strcat>:

char *
strcat(char *dest, const char *src)
{
     7e2:	55                   	push   %ebp
     7e3:	89 e5                	mov    %esp,%ebp
     7e5:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     7e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     7ef:	eb 03                	jmp    7f4 <strcat+0x12>
     7f1:	ff 45 fc             	incl   -0x4(%ebp)
     7f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
     7f7:	8b 45 08             	mov    0x8(%ebp),%eax
     7fa:	01 d0                	add    %edx,%eax
     7fc:	8a 00                	mov    (%eax),%al
     7fe:	84 c0                	test   %al,%al
     800:	75 ef                	jne    7f1 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     802:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     809:	eb 1e                	jmp    829 <strcat+0x47>
        dest[i+j] = src[j];
     80b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     80e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     811:	01 d0                	add    %edx,%eax
     813:	89 c2                	mov    %eax,%edx
     815:	8b 45 08             	mov    0x8(%ebp),%eax
     818:	01 c2                	add    %eax,%edx
     81a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     81d:	8b 45 0c             	mov    0xc(%ebp),%eax
     820:	01 c8                	add    %ecx,%eax
     822:	8a 00                	mov    (%eax),%al
     824:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     826:	ff 45 f8             	incl   -0x8(%ebp)
     829:	8b 55 f8             	mov    -0x8(%ebp),%edx
     82c:	8b 45 0c             	mov    0xc(%ebp),%eax
     82f:	01 d0                	add    %edx,%eax
     831:	8a 00                	mov    (%eax),%al
     833:	84 c0                	test   %al,%al
     835:	75 d4                	jne    80b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     837:	8b 45 f8             	mov    -0x8(%ebp),%eax
     83a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     83d:	01 d0                	add    %edx,%eax
     83f:	89 c2                	mov    %eax,%edx
     841:	8b 45 08             	mov    0x8(%ebp),%eax
     844:	01 d0                	add    %edx,%eax
     846:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     849:	8b 45 08             	mov    0x8(%ebp),%eax
}
     84c:	c9                   	leave  
     84d:	c3                   	ret    

0000084e <strstr>:

int 
strstr(char* s, char* sub)
{
     84e:	55                   	push   %ebp
     84f:	89 e5                	mov    %esp,%ebp
     851:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     854:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     85b:	eb 7c                	jmp    8d9 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     85d:	8b 55 fc             	mov    -0x4(%ebp),%edx
     860:	8b 45 08             	mov    0x8(%ebp),%eax
     863:	01 d0                	add    %edx,%eax
     865:	8a 10                	mov    (%eax),%dl
     867:	8b 45 0c             	mov    0xc(%ebp),%eax
     86a:	8a 00                	mov    (%eax),%al
     86c:	38 c2                	cmp    %al,%dl
     86e:	75 66                	jne    8d6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     870:	8b 45 0c             	mov    0xc(%ebp),%eax
     873:	89 04 24             	mov    %eax,(%esp)
     876:	e8 ee fe ff ff       	call   769 <strlen>
     87b:	83 f8 01             	cmp    $0x1,%eax
     87e:	75 05                	jne    885 <strstr+0x37>
            {  
                return i;
     880:	8b 45 fc             	mov    -0x4(%ebp),%eax
     883:	eb 6b                	jmp    8f0 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     885:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     88c:	eb 3a                	jmp    8c8 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     88e:	8b 45 f8             	mov    -0x8(%ebp),%eax
     891:	8b 55 fc             	mov    -0x4(%ebp),%edx
     894:	01 d0                	add    %edx,%eax
     896:	89 c2                	mov    %eax,%edx
     898:	8b 45 08             	mov    0x8(%ebp),%eax
     89b:	01 d0                	add    %edx,%eax
     89d:	8a 10                	mov    (%eax),%dl
     89f:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     8a2:	8b 45 0c             	mov    0xc(%ebp),%eax
     8a5:	01 c8                	add    %ecx,%eax
     8a7:	8a 00                	mov    (%eax),%al
     8a9:	38 c2                	cmp    %al,%dl
     8ab:	75 16                	jne    8c3 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     8ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
     8b0:	8d 50 01             	lea    0x1(%eax),%edx
     8b3:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b6:	01 d0                	add    %edx,%eax
     8b8:	8a 00                	mov    (%eax),%al
     8ba:	84 c0                	test   %al,%al
     8bc:	75 07                	jne    8c5 <strstr+0x77>
                    {
                        return i;
     8be:	8b 45 fc             	mov    -0x4(%ebp),%eax
     8c1:	eb 2d                	jmp    8f0 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     8c3:	eb 11                	jmp    8d6 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     8c5:	ff 45 f8             	incl   -0x8(%ebp)
     8c8:	8b 55 f8             	mov    -0x8(%ebp),%edx
     8cb:	8b 45 0c             	mov    0xc(%ebp),%eax
     8ce:	01 d0                	add    %edx,%eax
     8d0:	8a 00                	mov    (%eax),%al
     8d2:	84 c0                	test   %al,%al
     8d4:	75 b8                	jne    88e <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     8d6:	ff 45 fc             	incl   -0x4(%ebp)
     8d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
     8dc:	8b 45 08             	mov    0x8(%ebp),%eax
     8df:	01 d0                	add    %edx,%eax
     8e1:	8a 00                	mov    (%eax),%al
     8e3:	84 c0                	test   %al,%al
     8e5:	0f 85 72 ff ff ff    	jne    85d <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     8eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     8f0:	c9                   	leave  
     8f1:	c3                   	ret    

000008f2 <strtok>:

char *
strtok(char *s, const char *delim)
{
     8f2:	55                   	push   %ebp
     8f3:	89 e5                	mov    %esp,%ebp
     8f5:	53                   	push   %ebx
     8f6:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     8f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     8fd:	75 08                	jne    907 <strtok+0x15>
  s = lasts;
     8ff:	a1 04 18 00 00       	mov    0x1804,%eax
     904:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     907:	8b 45 08             	mov    0x8(%ebp),%eax
     90a:	8d 50 01             	lea    0x1(%eax),%edx
     90d:	89 55 08             	mov    %edx,0x8(%ebp)
     910:	8a 00                	mov    (%eax),%al
     912:	0f be d8             	movsbl %al,%ebx
     915:	85 db                	test   %ebx,%ebx
     917:	75 07                	jne    920 <strtok+0x2e>
      return 0;
     919:	b8 00 00 00 00       	mov    $0x0,%eax
     91e:	eb 58                	jmp    978 <strtok+0x86>
    } while (strchr(delim, ch));
     920:	88 d8                	mov    %bl,%al
     922:	0f be c0             	movsbl %al,%eax
     925:	89 44 24 04          	mov    %eax,0x4(%esp)
     929:	8b 45 0c             	mov    0xc(%ebp),%eax
     92c:	89 04 24             	mov    %eax,(%esp)
     92f:	e8 7e fe ff ff       	call   7b2 <strchr>
     934:	85 c0                	test   %eax,%eax
     936:	75 cf                	jne    907 <strtok+0x15>
    --s;
     938:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     93b:	8b 45 0c             	mov    0xc(%ebp),%eax
     93e:	89 44 24 04          	mov    %eax,0x4(%esp)
     942:	8b 45 08             	mov    0x8(%ebp),%eax
     945:	89 04 24             	mov    %eax,(%esp)
     948:	e8 31 00 00 00       	call   97e <strcspn>
     94d:	89 c2                	mov    %eax,%edx
     94f:	8b 45 08             	mov    0x8(%ebp),%eax
     952:	01 d0                	add    %edx,%eax
     954:	a3 04 18 00 00       	mov    %eax,0x1804
    if (*lasts != 0)
     959:	a1 04 18 00 00       	mov    0x1804,%eax
     95e:	8a 00                	mov    (%eax),%al
     960:	84 c0                	test   %al,%al
     962:	74 11                	je     975 <strtok+0x83>
  *lasts++ = 0;
     964:	a1 04 18 00 00       	mov    0x1804,%eax
     969:	8d 50 01             	lea    0x1(%eax),%edx
     96c:	89 15 04 18 00 00    	mov    %edx,0x1804
     972:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     975:	8b 45 08             	mov    0x8(%ebp),%eax
}
     978:	83 c4 14             	add    $0x14,%esp
     97b:	5b                   	pop    %ebx
     97c:	5d                   	pop    %ebp
     97d:	c3                   	ret    

0000097e <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     97e:	55                   	push   %ebp
     97f:	89 e5                	mov    %esp,%ebp
     981:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     984:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     98b:	eb 26                	jmp    9b3 <strcspn+0x35>
        if(strchr(s2,*s1))
     98d:	8b 45 08             	mov    0x8(%ebp),%eax
     990:	8a 00                	mov    (%eax),%al
     992:	0f be c0             	movsbl %al,%eax
     995:	89 44 24 04          	mov    %eax,0x4(%esp)
     999:	8b 45 0c             	mov    0xc(%ebp),%eax
     99c:	89 04 24             	mov    %eax,(%esp)
     99f:	e8 0e fe ff ff       	call   7b2 <strchr>
     9a4:	85 c0                	test   %eax,%eax
     9a6:	74 05                	je     9ad <strcspn+0x2f>
            return ret;
     9a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     9ab:	eb 12                	jmp    9bf <strcspn+0x41>
        else
            s1++,ret++;
     9ad:	ff 45 08             	incl   0x8(%ebp)
     9b0:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
     9b3:	8b 45 08             	mov    0x8(%ebp),%eax
     9b6:	8a 00                	mov    (%eax),%al
     9b8:	84 c0                	test   %al,%al
     9ba:	75 d1                	jne    98d <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
     9bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     9bf:	c9                   	leave  
     9c0:	c3                   	ret    

000009c1 <isspace>:

int
isspace(unsigned char c)
{
     9c1:	55                   	push   %ebp
     9c2:	89 e5                	mov    %esp,%ebp
     9c4:	83 ec 04             	sub    $0x4,%esp
     9c7:	8b 45 08             	mov    0x8(%ebp),%eax
     9ca:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
     9cd:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
     9d1:	74 1e                	je     9f1 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
     9d3:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
     9d7:	74 18                	je     9f1 <isspace+0x30>
     9d9:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
     9dd:	74 12                	je     9f1 <isspace+0x30>
     9df:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
     9e3:	74 0c                	je     9f1 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
     9e5:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
     9e9:	74 06                	je     9f1 <isspace+0x30>
     9eb:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
     9ef:	75 07                	jne    9f8 <isspace+0x37>
     9f1:	b8 01 00 00 00       	mov    $0x1,%eax
     9f6:	eb 05                	jmp    9fd <isspace+0x3c>
     9f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
     9fd:	c9                   	leave  
     9fe:	c3                   	ret    

000009ff <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
     9ff:	55                   	push   %ebp
     a00:	89 e5                	mov    %esp,%ebp
     a02:	57                   	push   %edi
     a03:	56                   	push   %esi
     a04:	53                   	push   %ebx
     a05:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
     a08:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
     a0d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
     a14:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     a17:	eb 01                	jmp    a1a <strtoul+0x1b>
  p += 1;
     a19:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     a1a:	8a 03                	mov    (%ebx),%al
     a1c:	0f b6 c0             	movzbl %al,%eax
     a1f:	89 04 24             	mov    %eax,(%esp)
     a22:	e8 9a ff ff ff       	call   9c1 <isspace>
     a27:	85 c0                	test   %eax,%eax
     a29:	75 ee                	jne    a19 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
     a2b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     a2f:	75 30                	jne    a61 <strtoul+0x62>
    {
  if (*p == '0') {
     a31:	8a 03                	mov    (%ebx),%al
     a33:	3c 30                	cmp    $0x30,%al
     a35:	75 21                	jne    a58 <strtoul+0x59>
      p += 1;
     a37:	43                   	inc    %ebx
      if (*p == 'x') {
     a38:	8a 03                	mov    (%ebx),%al
     a3a:	3c 78                	cmp    $0x78,%al
     a3c:	75 0a                	jne    a48 <strtoul+0x49>
    p += 1;
     a3e:	43                   	inc    %ebx
    base = 16;
     a3f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
     a46:	eb 31                	jmp    a79 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
     a48:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
     a4f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
     a56:	eb 21                	jmp    a79 <strtoul+0x7a>
      }
  }
  else base = 10;
     a58:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
     a5f:	eb 18                	jmp    a79 <strtoul+0x7a>
    } else if (base == 16) {
     a61:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     a65:	75 12                	jne    a79 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
     a67:	8a 03                	mov    (%ebx),%al
     a69:	3c 30                	cmp    $0x30,%al
     a6b:	75 0c                	jne    a79 <strtoul+0x7a>
     a6d:	8d 43 01             	lea    0x1(%ebx),%eax
     a70:	8a 00                	mov    (%eax),%al
     a72:	3c 78                	cmp    $0x78,%al
     a74:	75 03                	jne    a79 <strtoul+0x7a>
      p += 2;
     a76:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
     a79:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
     a7d:	75 29                	jne    aa8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
     a7f:	8a 03                	mov    (%ebx),%al
     a81:	0f be c0             	movsbl %al,%eax
     a84:	83 e8 30             	sub    $0x30,%eax
     a87:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
     a89:	83 fe 07             	cmp    $0x7,%esi
     a8c:	76 06                	jbe    a94 <strtoul+0x95>
    break;
     a8e:	90                   	nop
     a8f:	e9 b6 00 00 00       	jmp    b4a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
     a94:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
     a9b:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     a9e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
     aa5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
     aa6:	eb d7                	jmp    a7f <strtoul+0x80>
    } else if (base == 10) {
     aa8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
     aac:	75 2b                	jne    ad9 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
     aae:	8a 03                	mov    (%ebx),%al
     ab0:	0f be c0             	movsbl %al,%eax
     ab3:	83 e8 30             	sub    $0x30,%eax
     ab6:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
     ab8:	83 fe 09             	cmp    $0x9,%esi
     abb:	76 06                	jbe    ac3 <strtoul+0xc4>
    break;
     abd:	90                   	nop
     abe:	e9 87 00 00 00       	jmp    b4a <strtoul+0x14b>
      }
      result = (10*result) + digit;
     ac3:	89 f8                	mov    %edi,%eax
     ac5:	c1 e0 02             	shl    $0x2,%eax
     ac8:	01 f8                	add    %edi,%eax
     aca:	01 c0                	add    %eax,%eax
     acc:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     acf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
     ad6:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
     ad7:	eb d5                	jmp    aae <strtoul+0xaf>
    } else if (base == 16) {
     ad9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
     add:	75 35                	jne    b14 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
     adf:	8a 03                	mov    (%ebx),%al
     ae1:	0f be c0             	movsbl %al,%eax
     ae4:	83 e8 30             	sub    $0x30,%eax
     ae7:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     ae9:	83 fe 4a             	cmp    $0x4a,%esi
     aec:	76 02                	jbe    af0 <strtoul+0xf1>
    break;
     aee:	eb 22                	jmp    b12 <strtoul+0x113>
      }
      digit = cvtIn[digit];
     af0:	8a 86 a0 17 00 00    	mov    0x17a0(%esi),%al
     af6:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
     af9:	83 fe 0f             	cmp    $0xf,%esi
     afc:	76 02                	jbe    b00 <strtoul+0x101>
    break;
     afe:	eb 12                	jmp    b12 <strtoul+0x113>
      }
      result = (result << 4) + digit;
     b00:	89 f8                	mov    %edi,%eax
     b02:	c1 e0 04             	shl    $0x4,%eax
     b05:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b08:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
     b0f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
     b10:	eb cd                	jmp    adf <strtoul+0xe0>
     b12:	eb 36                	jmp    b4a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
     b14:	8a 03                	mov    (%ebx),%al
     b16:	0f be c0             	movsbl %al,%eax
     b19:	83 e8 30             	sub    $0x30,%eax
     b1c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
     b1e:	83 fe 4a             	cmp    $0x4a,%esi
     b21:	76 02                	jbe    b25 <strtoul+0x126>
    break;
     b23:	eb 25                	jmp    b4a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
     b25:	8a 86 a0 17 00 00    	mov    0x17a0(%esi),%al
     b2b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
     b2e:	8b 45 10             	mov    0x10(%ebp),%eax
     b31:	39 f0                	cmp    %esi,%eax
     b33:	77 02                	ja     b37 <strtoul+0x138>
    break;
     b35:	eb 13                	jmp    b4a <strtoul+0x14b>
      }
      result = result*base + digit;
     b37:	8b 45 10             	mov    0x10(%ebp),%eax
     b3a:	0f af c7             	imul   %edi,%eax
     b3d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
     b40:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
     b47:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
     b48:	eb ca                	jmp    b14 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
     b4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     b4e:	75 03                	jne    b53 <strtoul+0x154>
  p = string;
     b50:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
     b53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     b57:	74 05                	je     b5e <strtoul+0x15f>
  *endPtr = p;
     b59:	8b 45 0c             	mov    0xc(%ebp),%eax
     b5c:	89 18                	mov    %ebx,(%eax)
    }

    return result;
     b5e:	89 f8                	mov    %edi,%eax
}
     b60:	83 c4 14             	add    $0x14,%esp
     b63:	5b                   	pop    %ebx
     b64:	5e                   	pop    %esi
     b65:	5f                   	pop    %edi
     b66:	5d                   	pop    %ebp
     b67:	c3                   	ret    

00000b68 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
     b68:	55                   	push   %ebp
     b69:	89 e5                	mov    %esp,%ebp
     b6b:	53                   	push   %ebx
     b6c:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
     b6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
     b72:	eb 01                	jmp    b75 <strtol+0xd>
      p += 1;
     b74:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
     b75:	8a 03                	mov    (%ebx),%al
     b77:	0f b6 c0             	movzbl %al,%eax
     b7a:	89 04 24             	mov    %eax,(%esp)
     b7d:	e8 3f fe ff ff       	call   9c1 <isspace>
     b82:	85 c0                	test   %eax,%eax
     b84:	75 ee                	jne    b74 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
     b86:	8a 03                	mov    (%ebx),%al
     b88:	3c 2d                	cmp    $0x2d,%al
     b8a:	75 1e                	jne    baa <strtol+0x42>
  p += 1;
     b8c:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
     b8d:	8b 45 10             	mov    0x10(%ebp),%eax
     b90:	89 44 24 08          	mov    %eax,0x8(%esp)
     b94:	8b 45 0c             	mov    0xc(%ebp),%eax
     b97:	89 44 24 04          	mov    %eax,0x4(%esp)
     b9b:	89 1c 24             	mov    %ebx,(%esp)
     b9e:	e8 5c fe ff ff       	call   9ff <strtoul>
     ba3:	f7 d8                	neg    %eax
     ba5:	89 45 f8             	mov    %eax,-0x8(%ebp)
     ba8:	eb 20                	jmp    bca <strtol+0x62>
    } else {
  if (*p == '+') {
     baa:	8a 03                	mov    (%ebx),%al
     bac:	3c 2b                	cmp    $0x2b,%al
     bae:	75 01                	jne    bb1 <strtol+0x49>
      p += 1;
     bb0:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
     bb1:	8b 45 10             	mov    0x10(%ebp),%eax
     bb4:	89 44 24 08          	mov    %eax,0x8(%esp)
     bb8:	8b 45 0c             	mov    0xc(%ebp),%eax
     bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
     bbf:	89 1c 24             	mov    %ebx,(%esp)
     bc2:	e8 38 fe ff ff       	call   9ff <strtoul>
     bc7:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
     bca:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
     bce:	75 17                	jne    be7 <strtol+0x7f>
     bd0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     bd4:	74 11                	je     be7 <strtol+0x7f>
     bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd9:	8b 00                	mov    (%eax),%eax
     bdb:	39 d8                	cmp    %ebx,%eax
     bdd:	75 08                	jne    be7 <strtol+0x7f>
  *endPtr = string;
     bdf:	8b 45 0c             	mov    0xc(%ebp),%eax
     be2:	8b 55 08             	mov    0x8(%ebp),%edx
     be5:	89 10                	mov    %edx,(%eax)
    }
    return result;
     be7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
     bea:	83 c4 1c             	add    $0x1c,%esp
     bed:	5b                   	pop    %ebx
     bee:	5d                   	pop    %ebp
     bef:	c3                   	ret    

00000bf0 <gets>:

char*
gets(char *buf, int max)
{
     bf0:	55                   	push   %ebp
     bf1:	89 e5                	mov    %esp,%ebp
     bf3:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bf6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bfd:	eb 49                	jmp    c48 <gets+0x58>
    cc = read(0, &c, 1);
     bff:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c06:	00 
     c07:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
     c0e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c15:	e8 3e 01 00 00       	call   d58 <read>
     c1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c21:	7f 02                	jg     c25 <gets+0x35>
      break;
     c23:	eb 2c                	jmp    c51 <gets+0x61>
    buf[i++] = c;
     c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c28:	8d 50 01             	lea    0x1(%eax),%edx
     c2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
     c2e:	89 c2                	mov    %eax,%edx
     c30:	8b 45 08             	mov    0x8(%ebp),%eax
     c33:	01 c2                	add    %eax,%edx
     c35:	8a 45 ef             	mov    -0x11(%ebp),%al
     c38:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
     c3a:	8a 45 ef             	mov    -0x11(%ebp),%al
     c3d:	3c 0a                	cmp    $0xa,%al
     c3f:	74 10                	je     c51 <gets+0x61>
     c41:	8a 45 ef             	mov    -0x11(%ebp),%al
     c44:	3c 0d                	cmp    $0xd,%al
     c46:	74 09                	je     c51 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c4b:	40                   	inc    %eax
     c4c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c4f:	7c ae                	jl     bff <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c51:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c54:	8b 45 08             	mov    0x8(%ebp),%eax
     c57:	01 d0                	add    %edx,%eax
     c59:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     c5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c5f:	c9                   	leave  
     c60:	c3                   	ret    

00000c61 <stat>:

int
stat(char *n, struct stat *st)
{
     c61:	55                   	push   %ebp
     c62:	89 e5                	mov    %esp,%ebp
     c64:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c67:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c6e:	00 
     c6f:	8b 45 08             	mov    0x8(%ebp),%eax
     c72:	89 04 24             	mov    %eax,(%esp)
     c75:	e8 06 01 00 00       	call   d80 <open>
     c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     c7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c81:	79 07                	jns    c8a <stat+0x29>
    return -1;
     c83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c88:	eb 23                	jmp    cad <stat+0x4c>
  r = fstat(fd, st);
     c8a:	8b 45 0c             	mov    0xc(%ebp),%eax
     c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
     c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c94:	89 04 24             	mov    %eax,(%esp)
     c97:	e8 fc 00 00 00       	call   d98 <fstat>
     c9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ca2:	89 04 24             	mov    %eax,(%esp)
     ca5:	e8 be 00 00 00       	call   d68 <close>
  return r;
     caa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cad:	c9                   	leave  
     cae:	c3                   	ret    

00000caf <atoi>:

int
atoi(const char *s)
{
     caf:	55                   	push   %ebp
     cb0:	89 e5                	mov    %esp,%ebp
     cb2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     cb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     cbc:	eb 24                	jmp    ce2 <atoi+0x33>
    n = n*10 + *s++ - '0';
     cbe:	8b 55 fc             	mov    -0x4(%ebp),%edx
     cc1:	89 d0                	mov    %edx,%eax
     cc3:	c1 e0 02             	shl    $0x2,%eax
     cc6:	01 d0                	add    %edx,%eax
     cc8:	01 c0                	add    %eax,%eax
     cca:	89 c1                	mov    %eax,%ecx
     ccc:	8b 45 08             	mov    0x8(%ebp),%eax
     ccf:	8d 50 01             	lea    0x1(%eax),%edx
     cd2:	89 55 08             	mov    %edx,0x8(%ebp)
     cd5:	8a 00                	mov    (%eax),%al
     cd7:	0f be c0             	movsbl %al,%eax
     cda:	01 c8                	add    %ecx,%eax
     cdc:	83 e8 30             	sub    $0x30,%eax
     cdf:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ce2:	8b 45 08             	mov    0x8(%ebp),%eax
     ce5:	8a 00                	mov    (%eax),%al
     ce7:	3c 2f                	cmp    $0x2f,%al
     ce9:	7e 09                	jle    cf4 <atoi+0x45>
     ceb:	8b 45 08             	mov    0x8(%ebp),%eax
     cee:	8a 00                	mov    (%eax),%al
     cf0:	3c 39                	cmp    $0x39,%al
     cf2:	7e ca                	jle    cbe <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     cf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cf7:	c9                   	leave  
     cf8:	c3                   	ret    

00000cf9 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     cf9:	55                   	push   %ebp
     cfa:	89 e5                	mov    %esp,%ebp
     cfc:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
     cff:	8b 45 08             	mov    0x8(%ebp),%eax
     d02:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d05:	8b 45 0c             	mov    0xc(%ebp),%eax
     d08:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d0b:	eb 16                	jmp    d23 <memmove+0x2a>
    *dst++ = *src++;
     d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d10:	8d 50 01             	lea    0x1(%eax),%edx
     d13:	89 55 fc             	mov    %edx,-0x4(%ebp)
     d16:	8b 55 f8             	mov    -0x8(%ebp),%edx
     d19:	8d 4a 01             	lea    0x1(%edx),%ecx
     d1c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
     d1f:	8a 12                	mov    (%edx),%dl
     d21:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d23:	8b 45 10             	mov    0x10(%ebp),%eax
     d26:	8d 50 ff             	lea    -0x1(%eax),%edx
     d29:	89 55 10             	mov    %edx,0x10(%ebp)
     d2c:	85 c0                	test   %eax,%eax
     d2e:	7f dd                	jg     d0d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d30:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d33:	c9                   	leave  
     d34:	c3                   	ret    
     d35:	90                   	nop
     d36:	90                   	nop
     d37:	90                   	nop

00000d38 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d38:	b8 01 00 00 00       	mov    $0x1,%eax
     d3d:	cd 40                	int    $0x40
     d3f:	c3                   	ret    

00000d40 <exit>:
SYSCALL(exit)
     d40:	b8 02 00 00 00       	mov    $0x2,%eax
     d45:	cd 40                	int    $0x40
     d47:	c3                   	ret    

00000d48 <wait>:
SYSCALL(wait)
     d48:	b8 03 00 00 00       	mov    $0x3,%eax
     d4d:	cd 40                	int    $0x40
     d4f:	c3                   	ret    

00000d50 <pipe>:
SYSCALL(pipe)
     d50:	b8 04 00 00 00       	mov    $0x4,%eax
     d55:	cd 40                	int    $0x40
     d57:	c3                   	ret    

00000d58 <read>:
SYSCALL(read)
     d58:	b8 05 00 00 00       	mov    $0x5,%eax
     d5d:	cd 40                	int    $0x40
     d5f:	c3                   	ret    

00000d60 <write>:
SYSCALL(write)
     d60:	b8 10 00 00 00       	mov    $0x10,%eax
     d65:	cd 40                	int    $0x40
     d67:	c3                   	ret    

00000d68 <close>:
SYSCALL(close)
     d68:	b8 15 00 00 00       	mov    $0x15,%eax
     d6d:	cd 40                	int    $0x40
     d6f:	c3                   	ret    

00000d70 <kill>:
SYSCALL(kill)
     d70:	b8 06 00 00 00       	mov    $0x6,%eax
     d75:	cd 40                	int    $0x40
     d77:	c3                   	ret    

00000d78 <exec>:
SYSCALL(exec)
     d78:	b8 07 00 00 00       	mov    $0x7,%eax
     d7d:	cd 40                	int    $0x40
     d7f:	c3                   	ret    

00000d80 <open>:
SYSCALL(open)
     d80:	b8 0f 00 00 00       	mov    $0xf,%eax
     d85:	cd 40                	int    $0x40
     d87:	c3                   	ret    

00000d88 <mknod>:
SYSCALL(mknod)
     d88:	b8 11 00 00 00       	mov    $0x11,%eax
     d8d:	cd 40                	int    $0x40
     d8f:	c3                   	ret    

00000d90 <unlink>:
SYSCALL(unlink)
     d90:	b8 12 00 00 00       	mov    $0x12,%eax
     d95:	cd 40                	int    $0x40
     d97:	c3                   	ret    

00000d98 <fstat>:
SYSCALL(fstat)
     d98:	b8 08 00 00 00       	mov    $0x8,%eax
     d9d:	cd 40                	int    $0x40
     d9f:	c3                   	ret    

00000da0 <link>:
SYSCALL(link)
     da0:	b8 13 00 00 00       	mov    $0x13,%eax
     da5:	cd 40                	int    $0x40
     da7:	c3                   	ret    

00000da8 <mkdir>:
SYSCALL(mkdir)
     da8:	b8 14 00 00 00       	mov    $0x14,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <chdir>:
SYSCALL(chdir)
     db0:	b8 09 00 00 00       	mov    $0x9,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <dup>:
SYSCALL(dup)
     db8:	b8 0a 00 00 00       	mov    $0xa,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <getpid>:
SYSCALL(getpid)
     dc0:	b8 0b 00 00 00       	mov    $0xb,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <sbrk>:
SYSCALL(sbrk)
     dc8:	b8 0c 00 00 00       	mov    $0xc,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <sleep>:
SYSCALL(sleep)
     dd0:	b8 0d 00 00 00       	mov    $0xd,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <uptime>:
SYSCALL(uptime)
     dd8:	b8 0e 00 00 00       	mov    $0xe,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     de0:	55                   	push   %ebp
     de1:	89 e5                	mov    %esp,%ebp
     de3:	83 ec 18             	sub    $0x18,%esp
     de6:	8b 45 0c             	mov    0xc(%ebp),%eax
     de9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     dec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     df3:	00 
     df4:	8d 45 f4             	lea    -0xc(%ebp),%eax
     df7:	89 44 24 04          	mov    %eax,0x4(%esp)
     dfb:	8b 45 08             	mov    0x8(%ebp),%eax
     dfe:	89 04 24             	mov    %eax,(%esp)
     e01:	e8 5a ff ff ff       	call   d60 <write>
}
     e06:	c9                   	leave  
     e07:	c3                   	ret    

00000e08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e08:	55                   	push   %ebp
     e09:	89 e5                	mov    %esp,%ebp
     e0b:	56                   	push   %esi
     e0c:	53                   	push   %ebx
     e0d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     e10:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     e17:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     e1b:	74 17                	je     e34 <printint+0x2c>
     e1d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e21:	79 11                	jns    e34 <printint+0x2c>
    neg = 1;
     e23:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e2d:	f7 d8                	neg    %eax
     e2f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e32:	eb 06                	jmp    e3a <printint+0x32>
  } else {
    x = xx;
     e34:	8b 45 0c             	mov    0xc(%ebp),%eax
     e37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     e3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     e41:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     e44:	8d 41 01             	lea    0x1(%ecx),%eax
     e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
     e4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
     e4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e50:	ba 00 00 00 00       	mov    $0x0,%edx
     e55:	f7 f3                	div    %ebx
     e57:	89 d0                	mov    %edx,%eax
     e59:	8a 80 ec 17 00 00    	mov    0x17ec(%eax),%al
     e5f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
     e63:	8b 75 10             	mov    0x10(%ebp),%esi
     e66:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e69:	ba 00 00 00 00       	mov    $0x0,%edx
     e6e:	f7 f6                	div    %esi
     e70:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e73:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e77:	75 c8                	jne    e41 <printint+0x39>
  if(neg)
     e79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e7d:	74 10                	je     e8f <printint+0x87>
    buf[i++] = '-';
     e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e82:	8d 50 01             	lea    0x1(%eax),%edx
     e85:	89 55 f4             	mov    %edx,-0xc(%ebp)
     e88:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
     e8d:	eb 1e                	jmp    ead <printint+0xa5>
     e8f:	eb 1c                	jmp    ead <printint+0xa5>
    putc(fd, buf[i]);
     e91:	8d 55 dc             	lea    -0x24(%ebp),%edx
     e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
     e97:	01 d0                	add    %edx,%eax
     e99:	8a 00                	mov    (%eax),%al
     e9b:	0f be c0             	movsbl %al,%eax
     e9e:	89 44 24 04          	mov    %eax,0x4(%esp)
     ea2:	8b 45 08             	mov    0x8(%ebp),%eax
     ea5:	89 04 24             	mov    %eax,(%esp)
     ea8:	e8 33 ff ff ff       	call   de0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     ead:	ff 4d f4             	decl   -0xc(%ebp)
     eb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     eb4:	79 db                	jns    e91 <printint+0x89>
    putc(fd, buf[i]);
}
     eb6:	83 c4 30             	add    $0x30,%esp
     eb9:	5b                   	pop    %ebx
     eba:	5e                   	pop    %esi
     ebb:	5d                   	pop    %ebp
     ebc:	c3                   	ret    

00000ebd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     ebd:	55                   	push   %ebp
     ebe:	89 e5                	mov    %esp,%ebp
     ec0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     ec3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     eca:	8d 45 0c             	lea    0xc(%ebp),%eax
     ecd:	83 c0 04             	add    $0x4,%eax
     ed0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     ed3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     eda:	e9 77 01 00 00       	jmp    1056 <printf+0x199>
    c = fmt[i] & 0xff;
     edf:	8b 55 0c             	mov    0xc(%ebp),%edx
     ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ee5:	01 d0                	add    %edx,%eax
     ee7:	8a 00                	mov    (%eax),%al
     ee9:	0f be c0             	movsbl %al,%eax
     eec:	25 ff 00 00 00       	and    $0xff,%eax
     ef1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     ef4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ef8:	75 2c                	jne    f26 <printf+0x69>
      if(c == '%'){
     efa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     efe:	75 0c                	jne    f0c <printf+0x4f>
        state = '%';
     f00:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f07:	e9 47 01 00 00       	jmp    1053 <printf+0x196>
      } else {
        putc(fd, c);
     f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f0f:	0f be c0             	movsbl %al,%eax
     f12:	89 44 24 04          	mov    %eax,0x4(%esp)
     f16:	8b 45 08             	mov    0x8(%ebp),%eax
     f19:	89 04 24             	mov    %eax,(%esp)
     f1c:	e8 bf fe ff ff       	call   de0 <putc>
     f21:	e9 2d 01 00 00       	jmp    1053 <printf+0x196>
      }
    } else if(state == '%'){
     f26:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     f2a:	0f 85 23 01 00 00    	jne    1053 <printf+0x196>
      if(c == 'd'){
     f30:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     f34:	75 2d                	jne    f63 <printf+0xa6>
        printint(fd, *ap, 10, 1);
     f36:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f39:	8b 00                	mov    (%eax),%eax
     f3b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     f42:	00 
     f43:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f4a:	00 
     f4b:	89 44 24 04          	mov    %eax,0x4(%esp)
     f4f:	8b 45 08             	mov    0x8(%ebp),%eax
     f52:	89 04 24             	mov    %eax,(%esp)
     f55:	e8 ae fe ff ff       	call   e08 <printint>
        ap++;
     f5a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     f5e:	e9 e9 00 00 00       	jmp    104c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
     f63:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     f67:	74 06                	je     f6f <printf+0xb2>
     f69:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     f6d:	75 2d                	jne    f9c <printf+0xdf>
        printint(fd, *ap, 16, 0);
     f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f72:	8b 00                	mov    (%eax),%eax
     f74:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     f7b:	00 
     f7c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     f83:	00 
     f84:	89 44 24 04          	mov    %eax,0x4(%esp)
     f88:	8b 45 08             	mov    0x8(%ebp),%eax
     f8b:	89 04 24             	mov    %eax,(%esp)
     f8e:	e8 75 fe ff ff       	call   e08 <printint>
        ap++;
     f93:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     f97:	e9 b0 00 00 00       	jmp    104c <printf+0x18f>
      } else if(c == 's'){
     f9c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     fa0:	75 42                	jne    fe4 <printf+0x127>
        s = (char*)*ap;
     fa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fa5:	8b 00                	mov    (%eax),%eax
     fa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     faa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     fae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fb2:	75 09                	jne    fbd <printf+0x100>
          s = "(null)";
     fb4:	c7 45 f4 ac 13 00 00 	movl   $0x13ac,-0xc(%ebp)
        while(*s != 0){
     fbb:	eb 1c                	jmp    fd9 <printf+0x11c>
     fbd:	eb 1a                	jmp    fd9 <printf+0x11c>
          putc(fd, *s);
     fbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fc2:	8a 00                	mov    (%eax),%al
     fc4:	0f be c0             	movsbl %al,%eax
     fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     fcb:	8b 45 08             	mov    0x8(%ebp),%eax
     fce:	89 04 24             	mov    %eax,(%esp)
     fd1:	e8 0a fe ff ff       	call   de0 <putc>
          s++;
     fd6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
     fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fdc:	8a 00                	mov    (%eax),%al
     fde:	84 c0                	test   %al,%al
     fe0:	75 dd                	jne    fbf <printf+0x102>
     fe2:	eb 68                	jmp    104c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     fe4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
     fe8:	75 1d                	jne    1007 <printf+0x14a>
        putc(fd, *ap);
     fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fed:	8b 00                	mov    (%eax),%eax
     fef:	0f be c0             	movsbl %al,%eax
     ff2:	89 44 24 04          	mov    %eax,0x4(%esp)
     ff6:	8b 45 08             	mov    0x8(%ebp),%eax
     ff9:	89 04 24             	mov    %eax,(%esp)
     ffc:	e8 df fd ff ff       	call   de0 <putc>
        ap++;
    1001:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1005:	eb 45                	jmp    104c <printf+0x18f>
      } else if(c == '%'){
    1007:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    100b:	75 17                	jne    1024 <printf+0x167>
        putc(fd, c);
    100d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1010:	0f be c0             	movsbl %al,%eax
    1013:	89 44 24 04          	mov    %eax,0x4(%esp)
    1017:	8b 45 08             	mov    0x8(%ebp),%eax
    101a:	89 04 24             	mov    %eax,(%esp)
    101d:	e8 be fd ff ff       	call   de0 <putc>
    1022:	eb 28                	jmp    104c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1024:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    102b:	00 
    102c:	8b 45 08             	mov    0x8(%ebp),%eax
    102f:	89 04 24             	mov    %eax,(%esp)
    1032:	e8 a9 fd ff ff       	call   de0 <putc>
        putc(fd, c);
    1037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    103a:	0f be c0             	movsbl %al,%eax
    103d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1041:	8b 45 08             	mov    0x8(%ebp),%eax
    1044:	89 04 24             	mov    %eax,(%esp)
    1047:	e8 94 fd ff ff       	call   de0 <putc>
      }
      state = 0;
    104c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1053:	ff 45 f0             	incl   -0x10(%ebp)
    1056:	8b 55 0c             	mov    0xc(%ebp),%edx
    1059:	8b 45 f0             	mov    -0x10(%ebp),%eax
    105c:	01 d0                	add    %edx,%eax
    105e:	8a 00                	mov    (%eax),%al
    1060:	84 c0                	test   %al,%al
    1062:	0f 85 77 fe ff ff    	jne    edf <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1068:	c9                   	leave  
    1069:	c3                   	ret    
    106a:	90                   	nop
    106b:	90                   	nop

0000106c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    106c:	55                   	push   %ebp
    106d:	89 e5                	mov    %esp,%ebp
    106f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1072:	8b 45 08             	mov    0x8(%ebp),%eax
    1075:	83 e8 08             	sub    $0x8,%eax
    1078:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    107b:	a1 10 18 00 00       	mov    0x1810,%eax
    1080:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1083:	eb 24                	jmp    10a9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1085:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1088:	8b 00                	mov    (%eax),%eax
    108a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    108d:	77 12                	ja     10a1 <free+0x35>
    108f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1092:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1095:	77 24                	ja     10bb <free+0x4f>
    1097:	8b 45 fc             	mov    -0x4(%ebp),%eax
    109a:	8b 00                	mov    (%eax),%eax
    109c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    109f:	77 1a                	ja     10bb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10a4:	8b 00                	mov    (%eax),%eax
    10a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10ac:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10af:	76 d4                	jbe    1085 <free+0x19>
    10b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10b4:	8b 00                	mov    (%eax),%eax
    10b6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10b9:	76 ca                	jbe    1085 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    10bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10be:	8b 40 04             	mov    0x4(%eax),%eax
    10c1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    10c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10cb:	01 c2                	add    %eax,%edx
    10cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10d0:	8b 00                	mov    (%eax),%eax
    10d2:	39 c2                	cmp    %eax,%edx
    10d4:	75 24                	jne    10fa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    10d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10d9:	8b 50 04             	mov    0x4(%eax),%edx
    10dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10df:	8b 00                	mov    (%eax),%eax
    10e1:	8b 40 04             	mov    0x4(%eax),%eax
    10e4:	01 c2                	add    %eax,%edx
    10e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10e9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    10ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10ef:	8b 00                	mov    (%eax),%eax
    10f1:	8b 10                	mov    (%eax),%edx
    10f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10f6:	89 10                	mov    %edx,(%eax)
    10f8:	eb 0a                	jmp    1104 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    10fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10fd:	8b 10                	mov    (%eax),%edx
    10ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1102:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1104:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1107:	8b 40 04             	mov    0x4(%eax),%eax
    110a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1111:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1114:	01 d0                	add    %edx,%eax
    1116:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1119:	75 20                	jne    113b <free+0xcf>
    p->s.size += bp->s.size;
    111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    111e:	8b 50 04             	mov    0x4(%eax),%edx
    1121:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1124:	8b 40 04             	mov    0x4(%eax),%eax
    1127:	01 c2                	add    %eax,%edx
    1129:	8b 45 fc             	mov    -0x4(%ebp),%eax
    112c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    112f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1132:	8b 10                	mov    (%eax),%edx
    1134:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1137:	89 10                	mov    %edx,(%eax)
    1139:	eb 08                	jmp    1143 <free+0xd7>
  } else
    p->s.ptr = bp;
    113b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    113e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1141:	89 10                	mov    %edx,(%eax)
  freep = p;
    1143:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1146:	a3 10 18 00 00       	mov    %eax,0x1810
}
    114b:	c9                   	leave  
    114c:	c3                   	ret    

0000114d <morecore>:

static Header*
morecore(uint nu)
{
    114d:	55                   	push   %ebp
    114e:	89 e5                	mov    %esp,%ebp
    1150:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1153:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    115a:	77 07                	ja     1163 <morecore+0x16>
    nu = 4096;
    115c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1163:	8b 45 08             	mov    0x8(%ebp),%eax
    1166:	c1 e0 03             	shl    $0x3,%eax
    1169:	89 04 24             	mov    %eax,(%esp)
    116c:	e8 57 fc ff ff       	call   dc8 <sbrk>
    1171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1174:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1178:	75 07                	jne    1181 <morecore+0x34>
    return 0;
    117a:	b8 00 00 00 00       	mov    $0x0,%eax
    117f:	eb 22                	jmp    11a3 <morecore+0x56>
  hp = (Header*)p;
    1181:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1184:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1187:	8b 45 f0             	mov    -0x10(%ebp),%eax
    118a:	8b 55 08             	mov    0x8(%ebp),%edx
    118d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1190:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1193:	83 c0 08             	add    $0x8,%eax
    1196:	89 04 24             	mov    %eax,(%esp)
    1199:	e8 ce fe ff ff       	call   106c <free>
  return freep;
    119e:	a1 10 18 00 00       	mov    0x1810,%eax
}
    11a3:	c9                   	leave  
    11a4:	c3                   	ret    

000011a5 <malloc>:

void*
malloc(uint nbytes)
{
    11a5:	55                   	push   %ebp
    11a6:	89 e5                	mov    %esp,%ebp
    11a8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11ab:	8b 45 08             	mov    0x8(%ebp),%eax
    11ae:	83 c0 07             	add    $0x7,%eax
    11b1:	c1 e8 03             	shr    $0x3,%eax
    11b4:	40                   	inc    %eax
    11b5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    11b8:	a1 10 18 00 00       	mov    0x1810,%eax
    11bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    11c0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11c4:	75 23                	jne    11e9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    11c6:	c7 45 f0 08 18 00 00 	movl   $0x1808,-0x10(%ebp)
    11cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11d0:	a3 10 18 00 00       	mov    %eax,0x1810
    11d5:	a1 10 18 00 00       	mov    0x1810,%eax
    11da:	a3 08 18 00 00       	mov    %eax,0x1808
    base.s.size = 0;
    11df:	c7 05 0c 18 00 00 00 	movl   $0x0,0x180c
    11e6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11ec:	8b 00                	mov    (%eax),%eax
    11ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    11f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11f4:	8b 40 04             	mov    0x4(%eax),%eax
    11f7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    11fa:	72 4d                	jb     1249 <malloc+0xa4>
      if(p->s.size == nunits)
    11fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11ff:	8b 40 04             	mov    0x4(%eax),%eax
    1202:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1205:	75 0c                	jne    1213 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1207:	8b 45 f4             	mov    -0xc(%ebp),%eax
    120a:	8b 10                	mov    (%eax),%edx
    120c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    120f:	89 10                	mov    %edx,(%eax)
    1211:	eb 26                	jmp    1239 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1213:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1216:	8b 40 04             	mov    0x4(%eax),%eax
    1219:	2b 45 ec             	sub    -0x14(%ebp),%eax
    121c:	89 c2                	mov    %eax,%edx
    121e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1221:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1224:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1227:	8b 40 04             	mov    0x4(%eax),%eax
    122a:	c1 e0 03             	shl    $0x3,%eax
    122d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1230:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1233:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1236:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1239:	8b 45 f0             	mov    -0x10(%ebp),%eax
    123c:	a3 10 18 00 00       	mov    %eax,0x1810
      return (void*)(p + 1);
    1241:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1244:	83 c0 08             	add    $0x8,%eax
    1247:	eb 38                	jmp    1281 <malloc+0xdc>
    }
    if(p == freep)
    1249:	a1 10 18 00 00       	mov    0x1810,%eax
    124e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1251:	75 1b                	jne    126e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1253:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1256:	89 04 24             	mov    %eax,(%esp)
    1259:	e8 ef fe ff ff       	call   114d <morecore>
    125e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1261:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1265:	75 07                	jne    126e <malloc+0xc9>
        return 0;
    1267:	b8 00 00 00 00       	mov    $0x0,%eax
    126c:	eb 13                	jmp    1281 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    126e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1271:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1274:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1277:	8b 00                	mov    (%eax),%eax
    1279:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    127c:	e9 70 ff ff ff       	jmp    11f1 <malloc+0x4c>
}
    1281:	c9                   	leave  
    1282:	c3                   	ret    
