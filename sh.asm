
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <runcmd>:
struct cmd *parsecmd(char*);

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
       6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
       a:	75 05                	jne    11 <runcmd+0x11>
    exit();
       c:	e8 7f 14 00 00       	call   1490 <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 60 1a 00 00 	mov    0x1a60(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 34 1a 00 00 	movl   $0x1a34,(%esp)
      2b:	e8 1e 03 00 00       	call   34e <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
      30:	8b 45 08             	mov    0x8(%ebp),%eax
      33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
      36:	8b 45 f4             	mov    -0xc(%ebp),%eax
      39:	8b 40 04             	mov    0x4(%eax),%eax
      3c:	85 c0                	test   %eax,%eax
      3e:	75 05                	jne    45 <runcmd+0x45>
      exit();
      40:	e8 4b 14 00 00       	call   1490 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 6b 14 00 00       	call   14c8 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 3b 1a 00 	movl   $0x1a3b,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 f2 15 00 00       	call   166d <printf>
    break;
      7b:	e9 86 01 00 00       	jmp    206 <runcmd+0x206>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
      80:	8b 45 08             	mov    0x8(%ebp),%eax
      83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
      86:	8b 45 f0             	mov    -0x10(%ebp),%eax
      89:	8b 40 14             	mov    0x14(%eax),%eax
      8c:	89 04 24             	mov    %eax,(%esp)
      8f:	e8 24 14 00 00       	call   14b8 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 24 14 00 00       	call   14d0 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 4b 1a 00 	movl   $0x1a4b,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 9f 15 00 00       	call   166d <printf>
      exit();
      ce:	e8 bd 13 00 00       	call   1490 <exit>
    }
    runcmd(rcmd->cmd);
      d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
      d6:	8b 40 04             	mov    0x4(%eax),%eax
      d9:	89 04 24             	mov    %eax,(%esp)
      dc:	e8 1f ff ff ff       	call   0 <runcmd>
    break;
      e1:	e9 20 01 00 00       	jmp    206 <runcmd+0x206>

  case LIST:
    lcmd = (struct listcmd*)cmd;
      e6:	8b 45 08             	mov    0x8(%ebp),%eax
      e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
      ec:	e8 83 02 00 00       	call   374 <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 90 13 00 00       	call   1498 <wait>
    runcmd(lcmd->right);
     108:	8b 45 ec             	mov    -0x14(%ebp),%eax
     10b:	8b 40 08             	mov    0x8(%eax),%eax
     10e:	89 04 24             	mov    %eax,(%esp)
     111:	e8 ea fe ff ff       	call   0 <runcmd>
    break;
     116:	e9 eb 00 00 00       	jmp    206 <runcmd+0x206>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     11b:	8b 45 08             	mov    0x8(%ebp),%eax
     11e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     121:	8d 45 dc             	lea    -0x24(%ebp),%eax
     124:	89 04 24             	mov    %eax,(%esp)
     127:	e8 74 13 00 00       	call   14a0 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 5b 1a 00 00 	movl   $0x1a5b,(%esp)
     137:	e8 12 02 00 00       	call   34e <panic>
    if(fork1() == 0){
     13c:	e8 33 02 00 00       	call   374 <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 67 13 00 00       	call   14b8 <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 ac 13 00 00       	call   1508 <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 51 13 00 00       	call   14b8 <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 46 13 00 00       	call   14b8 <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 ef 01 00 00       	call   374 <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 23 13 00 00       	call   14b8 <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 68 13 00 00       	call   1508 <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 0d 13 00 00       	call   14b8 <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 02 13 00 00       	call   14b8 <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 e9 12 00 00       	call   14b8 <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 de 12 00 00       	call   14b8 <close>
    wait();
     1da:	e8 b9 12 00 00       	call   1498 <wait>
    wait();
     1df:	e8 b4 12 00 00       	call   1498 <wait>
    break;
     1e4:	eb 20                	jmp    206 <runcmd+0x206>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 83 01 00 00       	call   374 <fork1>
     1f1:	85 c0                	test   %eax,%eax
     1f3:	75 10                	jne    205 <runcmd+0x205>
      runcmd(bcmd->cmd);
     1f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     1f8:	8b 40 04             	mov    0x4(%eax),%eax
     1fb:	89 04 24             	mov    %eax,(%esp)
     1fe:	e8 fd fd ff ff       	call   0 <runcmd>
    break;
     203:	eb 00                	jmp    205 <runcmd+0x205>
     205:	90                   	nop
  }
  exit();
     206:	e8 85 12 00 00       	call   1490 <exit>

0000020b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     20b:	55                   	push   %ebp
     20c:	89 e5                	mov    %esp,%ebp
     20e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     211:	c7 44 24 04 78 1a 00 	movl   $0x1a78,0x4(%esp)
     218:	00 
     219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     220:	e8 48 14 00 00       	call   166d <printf>
  memset(buf, 0, nbuf);
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	89 44 24 08          	mov    %eax,0x8(%esp)
     22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     233:	00 
     234:	8b 45 08             	mov    0x8(%ebp),%eax
     237:	89 04 24             	mov    %eax,(%esp)
     23a:	e8 9f 0c 00 00       	call   ede <memset>
  gets(buf, nbuf);
     23f:	8b 45 0c             	mov    0xc(%ebp),%eax
     242:	89 44 24 04          	mov    %eax,0x4(%esp)
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 ef 10 00 00       	call   1340 <gets>
  if(buf[0] == 0) // EOF
     251:	8b 45 08             	mov    0x8(%ebp),%eax
     254:	8a 00                	mov    (%eax),%al
     256:	84 c0                	test   %al,%al
     258:	75 07                	jne    261 <getcmd+0x56>
    return -1;
     25a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     25f:	eb 05                	jmp    266 <getcmd+0x5b>
  return 0;
     261:	b8 00 00 00 00       	mov    $0x0,%eax
}
     266:	c9                   	leave  
     267:	c3                   	ret    

00000268 <main>:

int
main(void)
{
     268:	55                   	push   %ebp
     269:	89 e5                	mov    %esp,%ebp
     26b:	83 e4 f0             	and    $0xfffffff0,%esp
     26e:	83 ec 20             	sub    $0x20,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     271:	eb 15                	jmp    288 <main+0x20>
    if(fd >= 3){
     273:	83 7c 24 1c 02       	cmpl   $0x2,0x1c(%esp)
     278:	7e 0e                	jle    288 <main+0x20>
      close(fd);
     27a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 32 12 00 00       	call   14b8 <close>
      break;
     286:	eb 1f                	jmp    2a7 <main+0x3f>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     288:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     28f:	00 
     290:	c7 04 24 7b 1a 00 00 	movl   $0x1a7b,(%esp)
     297:	e8 34 12 00 00       	call   14d0 <open>
     29c:	89 44 24 1c          	mov    %eax,0x1c(%esp)
     2a0:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
     2a5:	79 cc                	jns    273 <main+0xb>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2a7:	e9 81 00 00 00       	jmp    32d <main+0xc5>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     2ac:	a0 a0 21 00 00       	mov    0x21a0,%al
     2b1:	3c 63                	cmp    $0x63,%al
     2b3:	75 56                	jne    30b <main+0xa3>
     2b5:	a0 a1 21 00 00       	mov    0x21a1,%al
     2ba:	3c 64                	cmp    $0x64,%al
     2bc:	75 4d                	jne    30b <main+0xa3>
     2be:	a0 a2 21 00 00       	mov    0x21a2,%al
     2c3:	3c 20                	cmp    $0x20,%al
     2c5:	75 44                	jne    30b <main+0xa3>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2c7:	c7 04 24 a0 21 00 00 	movl   $0x21a0,(%esp)
     2ce:	e8 e6 0b 00 00       	call   eb9 <strlen>
     2d3:	48                   	dec    %eax
     2d4:	c6 80 a0 21 00 00 00 	movb   $0x0,0x21a0(%eax)
      if(chdir(buf+3) < 0)
     2db:	c7 04 24 a3 21 00 00 	movl   $0x21a3,(%esp)
     2e2:	e8 19 12 00 00       	call   1500 <chdir>
     2e7:	85 c0                	test   %eax,%eax
     2e9:	79 1e                	jns    309 <main+0xa1>
        printf(2, "cannot cd %s\n", buf+3);
     2eb:	c7 44 24 08 a3 21 00 	movl   $0x21a3,0x8(%esp)
     2f2:	00 
     2f3:	c7 44 24 04 83 1a 00 	movl   $0x1a83,0x4(%esp)
     2fa:	00 
     2fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     302:	e8 66 13 00 00       	call   166d <printf>
      continue;
     307:	eb 24                	jmp    32d <main+0xc5>
     309:	eb 22                	jmp    32d <main+0xc5>
    }
    if(fork1() == 0)
     30b:	e8 64 00 00 00       	call   374 <fork1>
     310:	85 c0                	test   %eax,%eax
     312:	75 14                	jne    328 <main+0xc0>
      runcmd(parsecmd(buf));
     314:	c7 04 24 a0 21 00 00 	movl   $0x21a0,(%esp)
     31b:	e8 b8 03 00 00       	call   6d8 <parsecmd>
     320:	89 04 24             	mov    %eax,(%esp)
     323:	e8 d8 fc ff ff       	call   0 <runcmd>
    wait();
     328:	e8 6b 11 00 00       	call   1498 <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     32d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     334:	00 
     335:	c7 04 24 a0 21 00 00 	movl   $0x21a0,(%esp)
     33c:	e8 ca fe ff ff       	call   20b <getcmd>
     341:	85 c0                	test   %eax,%eax
     343:	0f 89 63 ff ff ff    	jns    2ac <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     349:	e8 42 11 00 00       	call   1490 <exit>

0000034e <panic>:
}

void
panic(char *s)
{
     34e:	55                   	push   %ebp
     34f:	89 e5                	mov    %esp,%ebp
     351:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     354:	8b 45 08             	mov    0x8(%ebp),%eax
     357:	89 44 24 08          	mov    %eax,0x8(%esp)
     35b:	c7 44 24 04 91 1a 00 	movl   $0x1a91,0x4(%esp)
     362:	00 
     363:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     36a:	e8 fe 12 00 00       	call   166d <printf>
  exit();
     36f:	e8 1c 11 00 00       	call   1490 <exit>

00000374 <fork1>:
}

int
fork1(void)
{
     374:	55                   	push   %ebp
     375:	89 e5                	mov    %esp,%ebp
     377:	83 ec 28             	sub    $0x28,%esp
  int pid;

  pid = fork();
     37a:	e8 09 11 00 00       	call   1488 <fork>
     37f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     382:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     386:	75 0c                	jne    394 <fork1+0x20>
    panic("fork");
     388:	c7 04 24 95 1a 00 00 	movl   $0x1a95,(%esp)
     38f:	e8 ba ff ff ff       	call   34e <panic>
  return pid;
     394:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     397:	c9                   	leave  
     398:	c3                   	ret    

00000399 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     399:	55                   	push   %ebp
     39a:	89 e5                	mov    %esp,%ebp
     39c:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     39f:	c7 04 24 a4 00 00 00 	movl   $0xa4,(%esp)
     3a6:	e8 aa 15 00 00       	call   1955 <malloc>
     3ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3ae:	c7 44 24 08 a4 00 00 	movl   $0xa4,0x8(%esp)
     3b5:	00 
     3b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3bd:	00 
     3be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3c1:	89 04 24             	mov    %eax,(%esp)
     3c4:	e8 15 0b 00 00       	call   ede <memset>
  cmd->type = EXEC;
     3c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3cc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     3d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     3d5:	c9                   	leave  
     3d6:	c3                   	ret    

000003d7 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     3d7:	55                   	push   %ebp
     3d8:	89 e5                	mov    %esp,%ebp
     3da:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3dd:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     3e4:	e8 6c 15 00 00       	call   1955 <malloc>
     3e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3ec:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3f3:	00 
     3f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3fb:	00 
     3fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3ff:	89 04 24             	mov    %eax,(%esp)
     402:	e8 d7 0a 00 00       	call   ede <memset>
  cmd->type = REDIR;
     407:	8b 45 f4             	mov    -0xc(%ebp),%eax
     40a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     410:	8b 45 f4             	mov    -0xc(%ebp),%eax
     413:	8b 55 08             	mov    0x8(%ebp),%edx
     416:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     419:	8b 45 f4             	mov    -0xc(%ebp),%eax
     41c:	8b 55 0c             	mov    0xc(%ebp),%edx
     41f:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     422:	8b 45 f4             	mov    -0xc(%ebp),%eax
     425:	8b 55 10             	mov    0x10(%ebp),%edx
     428:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     42b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     42e:	8b 55 14             	mov    0x14(%ebp),%edx
     431:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     434:	8b 45 f4             	mov    -0xc(%ebp),%eax
     437:	8b 55 18             	mov    0x18(%ebp),%edx
     43a:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     43d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     440:	c9                   	leave  
     441:	c3                   	ret    

00000442 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     442:	55                   	push   %ebp
     443:	89 e5                	mov    %esp,%ebp
     445:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     448:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     44f:	e8 01 15 00 00       	call   1955 <malloc>
     454:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     457:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     45e:	00 
     45f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     466:	00 
     467:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46a:	89 04 24             	mov    %eax,(%esp)
     46d:	e8 6c 0a 00 00       	call   ede <memset>
  cmd->type = PIPE;
     472:	8b 45 f4             	mov    -0xc(%ebp),%eax
     475:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     47e:	8b 55 08             	mov    0x8(%ebp),%edx
     481:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     484:	8b 45 f4             	mov    -0xc(%ebp),%eax
     487:	8b 55 0c             	mov    0xc(%ebp),%edx
     48a:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     48d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     490:	c9                   	leave  
     491:	c3                   	ret    

00000492 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     492:	55                   	push   %ebp
     493:	89 e5                	mov    %esp,%ebp
     495:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     498:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     49f:	e8 b1 14 00 00       	call   1955 <malloc>
     4a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4a7:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4ae:	00 
     4af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4b6:	00 
     4b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ba:	89 04 24             	mov    %eax,(%esp)
     4bd:	e8 1c 0a 00 00       	call   ede <memset>
  cmd->type = LIST;
     4c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c5:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     4cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ce:	8b 55 08             	mov    0x8(%ebp),%edx
     4d1:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     4d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d7:	8b 55 0c             	mov    0xc(%ebp),%edx
     4da:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     4dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4e0:	c9                   	leave  
     4e1:	c3                   	ret    

000004e2 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4e2:	55                   	push   %ebp
     4e3:	89 e5                	mov    %esp,%ebp
     4e5:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4e8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     4ef:	e8 61 14 00 00       	call   1955 <malloc>
     4f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4f7:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     4fe:	00 
     4ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     506:	00 
     507:	8b 45 f4             	mov    -0xc(%ebp),%eax
     50a:	89 04 24             	mov    %eax,(%esp)
     50d:	e8 cc 09 00 00       	call   ede <memset>
  cmd->type = BACK;
     512:	8b 45 f4             	mov    -0xc(%ebp),%eax
     515:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	8b 55 08             	mov    0x8(%ebp),%edx
     521:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     524:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     527:	c9                   	leave  
     528:	c3                   	ret    

00000529 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     529:	55                   	push   %ebp
     52a:	89 e5                	mov    %esp,%ebp
     52c:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;

  s = *ps;
     52f:	8b 45 08             	mov    0x8(%ebp),%eax
     532:	8b 00                	mov    (%eax),%eax
     534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     537:	eb 03                	jmp    53c <gettoken+0x13>
    s++;
     539:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     53c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     53f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     542:	73 1c                	jae    560 <gettoken+0x37>
     544:	8b 45 f4             	mov    -0xc(%ebp),%eax
     547:	8a 00                	mov    (%eax),%al
     549:	0f be c0             	movsbl %al,%eax
     54c:	89 44 24 04          	mov    %eax,0x4(%esp)
     550:	c7 04 24 20 21 00 00 	movl   $0x2120,(%esp)
     557:	e8 a6 09 00 00       	call   f02 <strchr>
     55c:	85 c0                	test   %eax,%eax
     55e:	75 d9                	jne    539 <gettoken+0x10>
    s++;
  if(q)
     560:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     564:	74 08                	je     56e <gettoken+0x45>
    *q = s;
     566:	8b 45 10             	mov    0x10(%ebp),%eax
     569:	8b 55 f4             	mov    -0xc(%ebp),%edx
     56c:	89 10                	mov    %edx,(%eax)
  ret = *s;
     56e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     571:	8a 00                	mov    (%eax),%al
     573:	0f be c0             	movsbl %al,%eax
     576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     579:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57c:	8a 00                	mov    (%eax),%al
     57e:	0f be c0             	movsbl %al,%eax
     581:	83 f8 29             	cmp    $0x29,%eax
     584:	7f 14                	jg     59a <gettoken+0x71>
     586:	83 f8 28             	cmp    $0x28,%eax
     589:	7d 28                	jge    5b3 <gettoken+0x8a>
     58b:	85 c0                	test   %eax,%eax
     58d:	0f 84 8d 00 00 00    	je     620 <gettoken+0xf7>
     593:	83 f8 26             	cmp    $0x26,%eax
     596:	74 1b                	je     5b3 <gettoken+0x8a>
     598:	eb 38                	jmp    5d2 <gettoken+0xa9>
     59a:	83 f8 3e             	cmp    $0x3e,%eax
     59d:	74 19                	je     5b8 <gettoken+0x8f>
     59f:	83 f8 3e             	cmp    $0x3e,%eax
     5a2:	7f 0a                	jg     5ae <gettoken+0x85>
     5a4:	83 e8 3b             	sub    $0x3b,%eax
     5a7:	83 f8 01             	cmp    $0x1,%eax
     5aa:	77 26                	ja     5d2 <gettoken+0xa9>
     5ac:	eb 05                	jmp    5b3 <gettoken+0x8a>
     5ae:	83 f8 7c             	cmp    $0x7c,%eax
     5b1:	75 1f                	jne    5d2 <gettoken+0xa9>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     5b3:	ff 45 f4             	incl   -0xc(%ebp)
    break;
     5b6:	eb 69                	jmp    621 <gettoken+0xf8>
  case '>':
    s++;
     5b8:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
     5bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5be:	8a 00                	mov    (%eax),%al
     5c0:	3c 3e                	cmp    $0x3e,%al
     5c2:	75 0c                	jne    5d0 <gettoken+0xa7>
      ret = '+';
     5c4:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     5cb:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
     5ce:	eb 51                	jmp    621 <gettoken+0xf8>
     5d0:	eb 4f                	jmp    621 <gettoken+0xf8>
  default:
    ret = 'a';
     5d2:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5d9:	eb 03                	jmp    5de <gettoken+0xb5>
      s++;
     5db:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5de:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e1:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5e4:	73 38                	jae    61e <gettoken+0xf5>
     5e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5e9:	8a 00                	mov    (%eax),%al
     5eb:	0f be c0             	movsbl %al,%eax
     5ee:	89 44 24 04          	mov    %eax,0x4(%esp)
     5f2:	c7 04 24 20 21 00 00 	movl   $0x2120,(%esp)
     5f9:	e8 04 09 00 00       	call   f02 <strchr>
     5fe:	85 c0                	test   %eax,%eax
     600:	75 1c                	jne    61e <gettoken+0xf5>
     602:	8b 45 f4             	mov    -0xc(%ebp),%eax
     605:	8a 00                	mov    (%eax),%al
     607:	0f be c0             	movsbl %al,%eax
     60a:	89 44 24 04          	mov    %eax,0x4(%esp)
     60e:	c7 04 24 26 21 00 00 	movl   $0x2126,(%esp)
     615:	e8 e8 08 00 00       	call   f02 <strchr>
     61a:	85 c0                	test   %eax,%eax
     61c:	74 bd                	je     5db <gettoken+0xb2>
      s++;
    break;
     61e:	eb 01                	jmp    621 <gettoken+0xf8>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     620:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     621:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     625:	74 0a                	je     631 <gettoken+0x108>
    *eq = s;
     627:	8b 45 14             	mov    0x14(%ebp),%eax
     62a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     62d:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     62f:	eb 05                	jmp    636 <gettoken+0x10d>
     631:	eb 03                	jmp    636 <gettoken+0x10d>
    s++;
     633:	ff 45 f4             	incl   -0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     636:	8b 45 f4             	mov    -0xc(%ebp),%eax
     639:	3b 45 0c             	cmp    0xc(%ebp),%eax
     63c:	73 1c                	jae    65a <gettoken+0x131>
     63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     641:	8a 00                	mov    (%eax),%al
     643:	0f be c0             	movsbl %al,%eax
     646:	89 44 24 04          	mov    %eax,0x4(%esp)
     64a:	c7 04 24 20 21 00 00 	movl   $0x2120,(%esp)
     651:	e8 ac 08 00 00       	call   f02 <strchr>
     656:	85 c0                	test   %eax,%eax
     658:	75 d9                	jne    633 <gettoken+0x10a>
    s++;
  *ps = s;
     65a:	8b 45 08             	mov    0x8(%ebp),%eax
     65d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     660:	89 10                	mov    %edx,(%eax)
  return ret;
     662:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     665:	c9                   	leave  
     666:	c3                   	ret    

00000667 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     667:	55                   	push   %ebp
     668:	89 e5                	mov    %esp,%ebp
     66a:	83 ec 28             	sub    $0x28,%esp
  char *s;

  s = *ps;
     66d:	8b 45 08             	mov    0x8(%ebp),%eax
     670:	8b 00                	mov    (%eax),%eax
     672:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     675:	eb 03                	jmp    67a <peek+0x13>
    s++;
     677:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     67a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     67d:	3b 45 0c             	cmp    0xc(%ebp),%eax
     680:	73 1c                	jae    69e <peek+0x37>
     682:	8b 45 f4             	mov    -0xc(%ebp),%eax
     685:	8a 00                	mov    (%eax),%al
     687:	0f be c0             	movsbl %al,%eax
     68a:	89 44 24 04          	mov    %eax,0x4(%esp)
     68e:	c7 04 24 20 21 00 00 	movl   $0x2120,(%esp)
     695:	e8 68 08 00 00       	call   f02 <strchr>
     69a:	85 c0                	test   %eax,%eax
     69c:	75 d9                	jne    677 <peek+0x10>
    s++;
  *ps = s;
     69e:	8b 45 08             	mov    0x8(%ebp),%eax
     6a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6a4:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     6a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a9:	8a 00                	mov    (%eax),%al
     6ab:	84 c0                	test   %al,%al
     6ad:	74 22                	je     6d1 <peek+0x6a>
     6af:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6b2:	8a 00                	mov    (%eax),%al
     6b4:	0f be c0             	movsbl %al,%eax
     6b7:	89 44 24 04          	mov    %eax,0x4(%esp)
     6bb:	8b 45 10             	mov    0x10(%ebp),%eax
     6be:	89 04 24             	mov    %eax,(%esp)
     6c1:	e8 3c 08 00 00       	call   f02 <strchr>
     6c6:	85 c0                	test   %eax,%eax
     6c8:	74 07                	je     6d1 <peek+0x6a>
     6ca:	b8 01 00 00 00       	mov    $0x1,%eax
     6cf:	eb 05                	jmp    6d6 <peek+0x6f>
     6d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
     6d6:	c9                   	leave  
     6d7:	c3                   	ret    

000006d8 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     6d8:	55                   	push   %ebp
     6d9:	89 e5                	mov    %esp,%ebp
     6db:	53                   	push   %ebx
     6dc:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     6df:	8b 5d 08             	mov    0x8(%ebp),%ebx
     6e2:	8b 45 08             	mov    0x8(%ebp),%eax
     6e5:	89 04 24             	mov    %eax,(%esp)
     6e8:	e8 cc 07 00 00       	call   eb9 <strlen>
     6ed:	01 d8                	add    %ebx,%eax
     6ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f5:	89 44 24 04          	mov    %eax,0x4(%esp)
     6f9:	8d 45 08             	lea    0x8(%ebp),%eax
     6fc:	89 04 24             	mov    %eax,(%esp)
     6ff:	e8 60 00 00 00       	call   764 <parseline>
     704:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     707:	c7 44 24 08 9a 1a 00 	movl   $0x1a9a,0x8(%esp)
     70e:	00 
     70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     712:	89 44 24 04          	mov    %eax,0x4(%esp)
     716:	8d 45 08             	lea    0x8(%ebp),%eax
     719:	89 04 24             	mov    %eax,(%esp)
     71c:	e8 46 ff ff ff       	call   667 <peek>
  if(s != es){
     721:	8b 45 08             	mov    0x8(%ebp),%eax
     724:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     727:	74 27                	je     750 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     729:	8b 45 08             	mov    0x8(%ebp),%eax
     72c:	89 44 24 08          	mov    %eax,0x8(%esp)
     730:	c7 44 24 04 9b 1a 00 	movl   $0x1a9b,0x4(%esp)
     737:	00 
     738:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     73f:	e8 29 0f 00 00       	call   166d <printf>
    panic("syntax");
     744:	c7 04 24 aa 1a 00 00 	movl   $0x1aaa,(%esp)
     74b:	e8 fe fb ff ff       	call   34e <panic>
  }
  nulterminate(cmd);
     750:	8b 45 f0             	mov    -0x10(%ebp),%eax
     753:	89 04 24             	mov    %eax,(%esp)
     756:	e8 a2 04 00 00       	call   bfd <nulterminate>
  return cmd;
     75b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     75e:	83 c4 24             	add    $0x24,%esp
     761:	5b                   	pop    %ebx
     762:	5d                   	pop    %ebp
     763:	c3                   	ret    

00000764 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     764:	55                   	push   %ebp
     765:	89 e5                	mov    %esp,%ebp
     767:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     76a:	8b 45 0c             	mov    0xc(%ebp),%eax
     76d:	89 44 24 04          	mov    %eax,0x4(%esp)
     771:	8b 45 08             	mov    0x8(%ebp),%eax
     774:	89 04 24             	mov    %eax,(%esp)
     777:	e8 bc 00 00 00       	call   838 <parsepipe>
     77c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     77f:	eb 30                	jmp    7b1 <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     781:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     788:	00 
     789:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     790:	00 
     791:	8b 45 0c             	mov    0xc(%ebp),%eax
     794:	89 44 24 04          	mov    %eax,0x4(%esp)
     798:	8b 45 08             	mov    0x8(%ebp),%eax
     79b:	89 04 24             	mov    %eax,(%esp)
     79e:	e8 86 fd ff ff       	call   529 <gettoken>
    cmd = backcmd(cmd);
     7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7a6:	89 04 24             	mov    %eax,(%esp)
     7a9:	e8 34 fd ff ff       	call   4e2 <backcmd>
     7ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     7b1:	c7 44 24 08 b1 1a 00 	movl   $0x1ab1,0x8(%esp)
     7b8:	00 
     7b9:	8b 45 0c             	mov    0xc(%ebp),%eax
     7bc:	89 44 24 04          	mov    %eax,0x4(%esp)
     7c0:	8b 45 08             	mov    0x8(%ebp),%eax
     7c3:	89 04 24             	mov    %eax,(%esp)
     7c6:	e8 9c fe ff ff       	call   667 <peek>
     7cb:	85 c0                	test   %eax,%eax
     7cd:	75 b2                	jne    781 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     7cf:	c7 44 24 08 b3 1a 00 	movl   $0x1ab3,0x8(%esp)
     7d6:	00 
     7d7:	8b 45 0c             	mov    0xc(%ebp),%eax
     7da:	89 44 24 04          	mov    %eax,0x4(%esp)
     7de:	8b 45 08             	mov    0x8(%ebp),%eax
     7e1:	89 04 24             	mov    %eax,(%esp)
     7e4:	e8 7e fe ff ff       	call   667 <peek>
     7e9:	85 c0                	test   %eax,%eax
     7eb:	74 46                	je     833 <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     7ed:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     7f4:	00 
     7f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     7fc:	00 
     7fd:	8b 45 0c             	mov    0xc(%ebp),%eax
     800:	89 44 24 04          	mov    %eax,0x4(%esp)
     804:	8b 45 08             	mov    0x8(%ebp),%eax
     807:	89 04 24             	mov    %eax,(%esp)
     80a:	e8 1a fd ff ff       	call   529 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     80f:	8b 45 0c             	mov    0xc(%ebp),%eax
     812:	89 44 24 04          	mov    %eax,0x4(%esp)
     816:	8b 45 08             	mov    0x8(%ebp),%eax
     819:	89 04 24             	mov    %eax,(%esp)
     81c:	e8 43 ff ff ff       	call   764 <parseline>
     821:	89 44 24 04          	mov    %eax,0x4(%esp)
     825:	8b 45 f4             	mov    -0xc(%ebp),%eax
     828:	89 04 24             	mov    %eax,(%esp)
     82b:	e8 62 fc ff ff       	call   492 <listcmd>
     830:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     833:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     836:	c9                   	leave  
     837:	c3                   	ret    

00000838 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     838:	55                   	push   %ebp
     839:	89 e5                	mov    %esp,%ebp
     83b:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     83e:	8b 45 0c             	mov    0xc(%ebp),%eax
     841:	89 44 24 04          	mov    %eax,0x4(%esp)
     845:	8b 45 08             	mov    0x8(%ebp),%eax
     848:	89 04 24             	mov    %eax,(%esp)
     84b:	e8 68 02 00 00       	call   ab8 <parseexec>
     850:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     853:	c7 44 24 08 b5 1a 00 	movl   $0x1ab5,0x8(%esp)
     85a:	00 
     85b:	8b 45 0c             	mov    0xc(%ebp),%eax
     85e:	89 44 24 04          	mov    %eax,0x4(%esp)
     862:	8b 45 08             	mov    0x8(%ebp),%eax
     865:	89 04 24             	mov    %eax,(%esp)
     868:	e8 fa fd ff ff       	call   667 <peek>
     86d:	85 c0                	test   %eax,%eax
     86f:	74 46                	je     8b7 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     871:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     878:	00 
     879:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     880:	00 
     881:	8b 45 0c             	mov    0xc(%ebp),%eax
     884:	89 44 24 04          	mov    %eax,0x4(%esp)
     888:	8b 45 08             	mov    0x8(%ebp),%eax
     88b:	89 04 24             	mov    %eax,(%esp)
     88e:	e8 96 fc ff ff       	call   529 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     893:	8b 45 0c             	mov    0xc(%ebp),%eax
     896:	89 44 24 04          	mov    %eax,0x4(%esp)
     89a:	8b 45 08             	mov    0x8(%ebp),%eax
     89d:	89 04 24             	mov    %eax,(%esp)
     8a0:	e8 93 ff ff ff       	call   838 <parsepipe>
     8a5:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ac:	89 04 24             	mov    %eax,(%esp)
     8af:	e8 8e fb ff ff       	call   442 <pipecmd>
     8b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8ba:	c9                   	leave  
     8bb:	c3                   	ret    

000008bc <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     8bc:	55                   	push   %ebp
     8bd:	89 e5                	mov    %esp,%ebp
     8bf:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     8c2:	e9 f6 00 00 00       	jmp    9bd <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     8c7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8ce:	00 
     8cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8d6:	00 
     8d7:	8b 45 10             	mov    0x10(%ebp),%eax
     8da:	89 44 24 04          	mov    %eax,0x4(%esp)
     8de:	8b 45 0c             	mov    0xc(%ebp),%eax
     8e1:	89 04 24             	mov    %eax,(%esp)
     8e4:	e8 40 fc ff ff       	call   529 <gettoken>
     8e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     8ec:	8d 45 ec             	lea    -0x14(%ebp),%eax
     8ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
     8f3:	8d 45 f0             	lea    -0x10(%ebp),%eax
     8f6:	89 44 24 08          	mov    %eax,0x8(%esp)
     8fa:	8b 45 10             	mov    0x10(%ebp),%eax
     8fd:	89 44 24 04          	mov    %eax,0x4(%esp)
     901:	8b 45 0c             	mov    0xc(%ebp),%eax
     904:	89 04 24             	mov    %eax,(%esp)
     907:	e8 1d fc ff ff       	call   529 <gettoken>
     90c:	83 f8 61             	cmp    $0x61,%eax
     90f:	74 0c                	je     91d <parseredirs+0x61>
      panic("missing file for redirection");
     911:	c7 04 24 b7 1a 00 00 	movl   $0x1ab7,(%esp)
     918:	e8 31 fa ff ff       	call   34e <panic>
    switch(tok){
     91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     920:	83 f8 3c             	cmp    $0x3c,%eax
     923:	74 0f                	je     934 <parseredirs+0x78>
     925:	83 f8 3e             	cmp    $0x3e,%eax
     928:	74 38                	je     962 <parseredirs+0xa6>
     92a:	83 f8 2b             	cmp    $0x2b,%eax
     92d:	74 61                	je     990 <parseredirs+0xd4>
     92f:	e9 89 00 00 00       	jmp    9bd <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     934:	8b 55 ec             	mov    -0x14(%ebp),%edx
     937:	8b 45 f0             	mov    -0x10(%ebp),%eax
     93a:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     941:	00 
     942:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     949:	00 
     94a:	89 54 24 08          	mov    %edx,0x8(%esp)
     94e:	89 44 24 04          	mov    %eax,0x4(%esp)
     952:	8b 45 08             	mov    0x8(%ebp),%eax
     955:	89 04 24             	mov    %eax,(%esp)
     958:	e8 7a fa ff ff       	call   3d7 <redircmd>
     95d:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     960:	eb 5b                	jmp    9bd <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     962:	8b 55 ec             	mov    -0x14(%ebp),%edx
     965:	8b 45 f0             	mov    -0x10(%ebp),%eax
     968:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     96f:	00 
     970:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     977:	00 
     978:	89 54 24 08          	mov    %edx,0x8(%esp)
     97c:	89 44 24 04          	mov    %eax,0x4(%esp)
     980:	8b 45 08             	mov    0x8(%ebp),%eax
     983:	89 04 24             	mov    %eax,(%esp)
     986:	e8 4c fa ff ff       	call   3d7 <redircmd>
     98b:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     98e:	eb 2d                	jmp    9bd <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     990:	8b 55 ec             	mov    -0x14(%ebp),%edx
     993:	8b 45 f0             	mov    -0x10(%ebp),%eax
     996:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     99d:	00 
     99e:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     9a5:	00 
     9a6:	89 54 24 08          	mov    %edx,0x8(%esp)
     9aa:	89 44 24 04          	mov    %eax,0x4(%esp)
     9ae:	8b 45 08             	mov    0x8(%ebp),%eax
     9b1:	89 04 24             	mov    %eax,(%esp)
     9b4:	e8 1e fa ff ff       	call   3d7 <redircmd>
     9b9:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     9bc:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9bd:	c7 44 24 08 d4 1a 00 	movl   $0x1ad4,0x8(%esp)
     9c4:	00 
     9c5:	8b 45 10             	mov    0x10(%ebp),%eax
     9c8:	89 44 24 04          	mov    %eax,0x4(%esp)
     9cc:	8b 45 0c             	mov    0xc(%ebp),%eax
     9cf:	89 04 24             	mov    %eax,(%esp)
     9d2:	e8 90 fc ff ff       	call   667 <peek>
     9d7:	85 c0                	test   %eax,%eax
     9d9:	0f 85 e8 fe ff ff    	jne    8c7 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     9df:	8b 45 08             	mov    0x8(%ebp),%eax
}
     9e2:	c9                   	leave  
     9e3:	c3                   	ret    

000009e4 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     9e4:	55                   	push   %ebp
     9e5:	89 e5                	mov    %esp,%ebp
     9e7:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     9ea:	c7 44 24 08 d7 1a 00 	movl   $0x1ad7,0x8(%esp)
     9f1:	00 
     9f2:	8b 45 0c             	mov    0xc(%ebp),%eax
     9f5:	89 44 24 04          	mov    %eax,0x4(%esp)
     9f9:	8b 45 08             	mov    0x8(%ebp),%eax
     9fc:	89 04 24             	mov    %eax,(%esp)
     9ff:	e8 63 fc ff ff       	call   667 <peek>
     a04:	85 c0                	test   %eax,%eax
     a06:	75 0c                	jne    a14 <parseblock+0x30>
    panic("parseblock");
     a08:	c7 04 24 d9 1a 00 00 	movl   $0x1ad9,(%esp)
     a0f:	e8 3a f9 ff ff       	call   34e <panic>
  gettoken(ps, es, 0, 0);
     a14:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a1b:	00 
     a1c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a23:	00 
     a24:	8b 45 0c             	mov    0xc(%ebp),%eax
     a27:	89 44 24 04          	mov    %eax,0x4(%esp)
     a2b:	8b 45 08             	mov    0x8(%ebp),%eax
     a2e:	89 04 24             	mov    %eax,(%esp)
     a31:	e8 f3 fa ff ff       	call   529 <gettoken>
  cmd = parseline(ps, es);
     a36:	8b 45 0c             	mov    0xc(%ebp),%eax
     a39:	89 44 24 04          	mov    %eax,0x4(%esp)
     a3d:	8b 45 08             	mov    0x8(%ebp),%eax
     a40:	89 04 24             	mov    %eax,(%esp)
     a43:	e8 1c fd ff ff       	call   764 <parseline>
     a48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     a4b:	c7 44 24 08 e4 1a 00 	movl   $0x1ae4,0x8(%esp)
     a52:	00 
     a53:	8b 45 0c             	mov    0xc(%ebp),%eax
     a56:	89 44 24 04          	mov    %eax,0x4(%esp)
     a5a:	8b 45 08             	mov    0x8(%ebp),%eax
     a5d:	89 04 24             	mov    %eax,(%esp)
     a60:	e8 02 fc ff ff       	call   667 <peek>
     a65:	85 c0                	test   %eax,%eax
     a67:	75 0c                	jne    a75 <parseblock+0x91>
    panic("syntax - missing )");
     a69:	c7 04 24 e6 1a 00 00 	movl   $0x1ae6,(%esp)
     a70:	e8 d9 f8 ff ff       	call   34e <panic>
  gettoken(ps, es, 0, 0);
     a75:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a7c:	00 
     a7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a84:	00 
     a85:	8b 45 0c             	mov    0xc(%ebp),%eax
     a88:	89 44 24 04          	mov    %eax,0x4(%esp)
     a8c:	8b 45 08             	mov    0x8(%ebp),%eax
     a8f:	89 04 24             	mov    %eax,(%esp)
     a92:	e8 92 fa ff ff       	call   529 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a97:	8b 45 0c             	mov    0xc(%ebp),%eax
     a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
     a9e:	8b 45 08             	mov    0x8(%ebp),%eax
     aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa8:	89 04 24             	mov    %eax,(%esp)
     aab:	e8 0c fe ff ff       	call   8bc <parseredirs>
     ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ab6:	c9                   	leave  
     ab7:	c3                   	ret    

00000ab8 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     ab8:	55                   	push   %ebp
     ab9:	89 e5                	mov    %esp,%ebp
     abb:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     abe:	c7 44 24 08 d7 1a 00 	movl   $0x1ad7,0x8(%esp)
     ac5:	00 
     ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ac9:	89 44 24 04          	mov    %eax,0x4(%esp)
     acd:	8b 45 08             	mov    0x8(%ebp),%eax
     ad0:	89 04 24             	mov    %eax,(%esp)
     ad3:	e8 8f fb ff ff       	call   667 <peek>
     ad8:	85 c0                	test   %eax,%eax
     ada:	74 17                	je     af3 <parseexec+0x3b>
    return parseblock(ps, es);
     adc:	8b 45 0c             	mov    0xc(%ebp),%eax
     adf:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae3:	8b 45 08             	mov    0x8(%ebp),%eax
     ae6:	89 04 24             	mov    %eax,(%esp)
     ae9:	e8 f6 fe ff ff       	call   9e4 <parseblock>
     aee:	e9 08 01 00 00       	jmp    bfb <parseexec+0x143>

  ret = execcmd();
     af3:	e8 a1 f8 ff ff       	call   399 <execcmd>
     af8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     afe:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     b01:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     b08:	8b 45 0c             	mov    0xc(%ebp),%eax
     b0b:	89 44 24 08          	mov    %eax,0x8(%esp)
     b0f:	8b 45 08             	mov    0x8(%ebp),%eax
     b12:	89 44 24 04          	mov    %eax,0x4(%esp)
     b16:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b19:	89 04 24             	mov    %eax,(%esp)
     b1c:	e8 9b fd ff ff       	call   8bc <parseredirs>
     b21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     b24:	e9 8e 00 00 00       	jmp    bb7 <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     b29:	8d 45 e0             	lea    -0x20(%ebp),%eax
     b2c:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b30:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     b33:	89 44 24 08          	mov    %eax,0x8(%esp)
     b37:	8b 45 0c             	mov    0xc(%ebp),%eax
     b3a:	89 44 24 04          	mov    %eax,0x4(%esp)
     b3e:	8b 45 08             	mov    0x8(%ebp),%eax
     b41:	89 04 24             	mov    %eax,(%esp)
     b44:	e8 e0 f9 ff ff       	call   529 <gettoken>
     b49:	89 45 e8             	mov    %eax,-0x18(%ebp)
     b4c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     b50:	75 05                	jne    b57 <parseexec+0x9f>
      break;
     b52:	e9 82 00 00 00       	jmp    bd9 <parseexec+0x121>
    if(tok != 'a')
     b57:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     b5b:	74 0c                	je     b69 <parseexec+0xb1>
      panic("syntax");
     b5d:	c7 04 24 aa 1a 00 00 	movl   $0x1aaa,(%esp)
     b64:	e8 e5 f7 ff ff       	call   34e <panic>
    cmd->argv[argc] = q;
     b69:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     b6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     b72:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     b76:	8b 55 e0             	mov    -0x20(%ebp),%edx
     b79:	8b 45 ec             	mov    -0x14(%ebp),%eax
     b7c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     b7f:	83 c1 14             	add    $0x14,%ecx
     b82:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    argc++;
     b86:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     b89:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     b8d:	7e 0c                	jle    b9b <parseexec+0xe3>
      panic("too many args");
     b8f:	c7 04 24 f9 1a 00 00 	movl   $0x1af9,(%esp)
     b96:	e8 b3 f7 ff ff       	call   34e <panic>
    ret = parseredirs(ret, ps, es);
     b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
     b9e:	89 44 24 08          	mov    %eax,0x8(%esp)
     ba2:	8b 45 08             	mov    0x8(%ebp),%eax
     ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
     ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bac:	89 04 24             	mov    %eax,(%esp)
     baf:	e8 08 fd ff ff       	call   8bc <parseredirs>
     bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     bb7:	c7 44 24 08 07 1b 00 	movl   $0x1b07,0x8(%esp)
     bbe:	00 
     bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
     bc6:	8b 45 08             	mov    0x8(%ebp),%eax
     bc9:	89 04 24             	mov    %eax,(%esp)
     bcc:	e8 96 fa ff ff       	call   667 <peek>
     bd1:	85 c0                	test   %eax,%eax
     bd3:	0f 84 50 ff ff ff    	je     b29 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     bd9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bdc:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bdf:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     be6:	00 
  cmd->eargv[argc] = 0;
     be7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     bea:	8b 55 f4             	mov    -0xc(%ebp),%edx
     bed:	83 c2 14             	add    $0x14,%edx
     bf0:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     bf7:	00 
  return ret;
     bf8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     bfb:	c9                   	leave  
     bfc:	c3                   	ret    

00000bfd <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     bfd:	55                   	push   %ebp
     bfe:	89 e5                	mov    %esp,%ebp
     c00:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     c07:	75 0a                	jne    c13 <nulterminate+0x16>
    return 0;
     c09:	b8 00 00 00 00       	mov    $0x0,%eax
     c0e:	e9 c8 00 00 00       	jmp    cdb <nulterminate+0xde>

  switch(cmd->type){
     c13:	8b 45 08             	mov    0x8(%ebp),%eax
     c16:	8b 00                	mov    (%eax),%eax
     c18:	83 f8 05             	cmp    $0x5,%eax
     c1b:	0f 87 b7 00 00 00    	ja     cd8 <nulterminate+0xdb>
     c21:	8b 04 85 0c 1b 00 00 	mov    0x1b0c(,%eax,4),%eax
     c28:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     c2a:	8b 45 08             	mov    0x8(%ebp),%eax
     c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c37:	eb 13                	jmp    c4c <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
     c39:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c3f:	83 c2 14             	add    $0x14,%edx
     c42:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c46:	c6 00 00             	movb   $0x0,(%eax)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     c49:	ff 45 f4             	incl   -0xc(%ebp)
     c4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c52:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     c56:	85 c0                	test   %eax,%eax
     c58:	75 df                	jne    c39 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     c5a:	eb 7c                	jmp    cd8 <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     c5c:	8b 45 08             	mov    0x8(%ebp),%eax
     c5f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     c62:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c65:	8b 40 04             	mov    0x4(%eax),%eax
     c68:	89 04 24             	mov    %eax,(%esp)
     c6b:	e8 8d ff ff ff       	call   bfd <nulterminate>
    *rcmd->efile = 0;
     c70:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c73:	8b 40 0c             	mov    0xc(%eax),%eax
     c76:	c6 00 00             	movb   $0x0,(%eax)
    break;
     c79:	eb 5d                	jmp    cd8 <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     c7b:	8b 45 08             	mov    0x8(%ebp),%eax
     c7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     c81:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c84:	8b 40 04             	mov    0x4(%eax),%eax
     c87:	89 04 24             	mov    %eax,(%esp)
     c8a:	e8 6e ff ff ff       	call   bfd <nulterminate>
    nulterminate(pcmd->right);
     c8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     c92:	8b 40 08             	mov    0x8(%eax),%eax
     c95:	89 04 24             	mov    %eax,(%esp)
     c98:	e8 60 ff ff ff       	call   bfd <nulterminate>
    break;
     c9d:	eb 39                	jmp    cd8 <nulterminate+0xdb>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     c9f:	8b 45 08             	mov    0x8(%ebp),%eax
     ca2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     ca5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ca8:	8b 40 04             	mov    0x4(%eax),%eax
     cab:	89 04 24             	mov    %eax,(%esp)
     cae:	e8 4a ff ff ff       	call   bfd <nulterminate>
    nulterminate(lcmd->right);
     cb3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     cb6:	8b 40 08             	mov    0x8(%eax),%eax
     cb9:	89 04 24             	mov    %eax,(%esp)
     cbc:	e8 3c ff ff ff       	call   bfd <nulterminate>
    break;
     cc1:	eb 15                	jmp    cd8 <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     cc3:	8b 45 08             	mov    0x8(%ebp),%eax
     cc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     cc9:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ccc:	8b 40 04             	mov    0x4(%eax),%eax
     ccf:	89 04 24             	mov    %eax,(%esp)
     cd2:	e8 26 ff ff ff       	call   bfd <nulterminate>
    break;
     cd7:	90                   	nop
  }
  return cmd;
     cd8:	8b 45 08             	mov    0x8(%ebp),%eax
}
     cdb:	c9                   	leave  
     cdc:	c3                   	ret    
     cdd:	90                   	nop
     cde:	90                   	nop
     cdf:	90                   	nop

00000ce0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     ce0:	55                   	push   %ebp
     ce1:	89 e5                	mov    %esp,%ebp
     ce3:	57                   	push   %edi
     ce4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     ce5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ce8:	8b 55 10             	mov    0x10(%ebp),%edx
     ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
     cee:	89 cb                	mov    %ecx,%ebx
     cf0:	89 df                	mov    %ebx,%edi
     cf2:	89 d1                	mov    %edx,%ecx
     cf4:	fc                   	cld    
     cf5:	f3 aa                	rep stos %al,%es:(%edi)
     cf7:	89 ca                	mov    %ecx,%edx
     cf9:	89 fb                	mov    %edi,%ebx
     cfb:	89 5d 08             	mov    %ebx,0x8(%ebp)
     cfe:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     d01:	5b                   	pop    %ebx
     d02:	5f                   	pop    %edi
     d03:	5d                   	pop    %ebp
     d04:	c3                   	ret    

00000d05 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     d05:	55                   	push   %ebp
     d06:	89 e5                	mov    %esp,%ebp
     d08:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     d0b:	8b 45 08             	mov    0x8(%ebp),%eax
     d0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     d11:	90                   	nop
     d12:	8b 45 08             	mov    0x8(%ebp),%eax
     d15:	8d 50 01             	lea    0x1(%eax),%edx
     d18:	89 55 08             	mov    %edx,0x8(%ebp)
     d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
     d1e:	8d 4a 01             	lea    0x1(%edx),%ecx
     d21:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     d24:	8a 12                	mov    (%edx),%dl
     d26:	88 10                	mov    %dl,(%eax)
     d28:	8a 00                	mov    (%eax),%al
     d2a:	84 c0                	test   %al,%al
     d2c:	75 e4                	jne    d12 <strcpy+0xd>
    ;
  return os;
     d2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d31:	c9                   	leave  
     d32:	c3                   	ret    

00000d33 <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     d33:	55                   	push   %ebp
     d34:	89 e5                	mov    %esp,%ebp
     d36:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     d39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     d40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     d47:	00 
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	89 04 24             	mov    %eax,(%esp)
     d4e:	e8 7d 07 00 00       	call   14d0 <open>
     d53:	89 45 f0             	mov    %eax,-0x10(%ebp)
     d56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     d5a:	79 20                	jns    d7c <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     d5c:	8b 45 08             	mov    0x8(%ebp),%eax
     d5f:	89 44 24 08          	mov    %eax,0x8(%esp)
     d63:	c7 44 24 04 24 1b 00 	movl   $0x1b24,0x4(%esp)
     d6a:	00 
     d6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     d72:	e8 f6 08 00 00       	call   166d <printf>
      exit();
     d77:	e8 14 07 00 00       	call   1490 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     d7c:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     d83:	00 
     d84:	8b 45 0c             	mov    0xc(%ebp),%eax
     d87:	89 04 24             	mov    %eax,(%esp)
     d8a:	e8 41 07 00 00       	call   14d0 <open>
     d8f:	89 45 ec             	mov    %eax,-0x14(%ebp)
     d92:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     d96:	79 20                	jns    db8 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     d98:	8b 45 0c             	mov    0xc(%ebp),%eax
     d9b:	89 44 24 08          	mov    %eax,0x8(%esp)
     d9f:	c7 44 24 04 3f 1b 00 	movl   $0x1b3f,0x4(%esp)
     da6:	00 
     da7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     dae:	e8 ba 08 00 00       	call   166d <printf>
      exit();
     db3:	e8 d8 06 00 00       	call   1490 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     db8:	eb 3b                	jmp    df5 <copy+0xc2>
  {
      max = used_disk+=count;
     dba:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dbd:	01 45 10             	add    %eax,0x10(%ebp)
     dc0:	8b 45 10             	mov    0x10(%ebp),%eax
     dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     dc6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     dc9:	3b 45 14             	cmp    0x14(%ebp),%eax
     dcc:	7e 07                	jle    dd5 <copy+0xa2>
      {
        return -1;
     dce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     dd3:	eb 5c                	jmp    e31 <copy+0xfe>
      }
      bytes = bytes + count;
     dd5:	8b 45 e8             	mov    -0x18(%ebp),%eax
     dd8:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     ddb:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     de2:	00 
     de3:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     de6:	89 44 24 04          	mov    %eax,0x4(%esp)
     dea:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ded:	89 04 24             	mov    %eax,(%esp)
     df0:	e8 bb 06 00 00       	call   14b0 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     df5:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     dfc:	00 
     dfd:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     e00:	89 44 24 04          	mov    %eax,0x4(%esp)
     e04:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e07:	89 04 24             	mov    %eax,(%esp)
     e0a:	e8 99 06 00 00       	call   14a8 <read>
     e0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
     e12:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     e16:	7f a2                	jg     dba <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e1b:	89 04 24             	mov    %eax,(%esp)
     e1e:	e8 95 06 00 00       	call   14b8 <close>
  close(fd2);
     e23:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e26:	89 04 24             	mov    %eax,(%esp)
     e29:	e8 8a 06 00 00       	call   14b8 <close>
  return(bytes);
     e2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     e31:	c9                   	leave  
     e32:	c3                   	ret    

00000e33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     e33:	55                   	push   %ebp
     e34:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     e36:	eb 06                	jmp    e3e <strcmp+0xb>
    p++, q++;
     e38:	ff 45 08             	incl   0x8(%ebp)
     e3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     e3e:	8b 45 08             	mov    0x8(%ebp),%eax
     e41:	8a 00                	mov    (%eax),%al
     e43:	84 c0                	test   %al,%al
     e45:	74 0e                	je     e55 <strcmp+0x22>
     e47:	8b 45 08             	mov    0x8(%ebp),%eax
     e4a:	8a 10                	mov    (%eax),%dl
     e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     e4f:	8a 00                	mov    (%eax),%al
     e51:	38 c2                	cmp    %al,%dl
     e53:	74 e3                	je     e38 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     e55:	8b 45 08             	mov    0x8(%ebp),%eax
     e58:	8a 00                	mov    (%eax),%al
     e5a:	0f b6 d0             	movzbl %al,%edx
     e5d:	8b 45 0c             	mov    0xc(%ebp),%eax
     e60:	8a 00                	mov    (%eax),%al
     e62:	0f b6 c0             	movzbl %al,%eax
     e65:	29 c2                	sub    %eax,%edx
     e67:	89 d0                	mov    %edx,%eax
}
     e69:	5d                   	pop    %ebp
     e6a:	c3                   	ret    

00000e6b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     e6b:	55                   	push   %ebp
     e6c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     e6e:	eb 09                	jmp    e79 <strncmp+0xe>
    n--, p++, q++;
     e70:	ff 4d 10             	decl   0x10(%ebp)
     e73:	ff 45 08             	incl   0x8(%ebp)
     e76:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     e79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     e7d:	74 17                	je     e96 <strncmp+0x2b>
     e7f:	8b 45 08             	mov    0x8(%ebp),%eax
     e82:	8a 00                	mov    (%eax),%al
     e84:	84 c0                	test   %al,%al
     e86:	74 0e                	je     e96 <strncmp+0x2b>
     e88:	8b 45 08             	mov    0x8(%ebp),%eax
     e8b:	8a 10                	mov    (%eax),%dl
     e8d:	8b 45 0c             	mov    0xc(%ebp),%eax
     e90:	8a 00                	mov    (%eax),%al
     e92:	38 c2                	cmp    %al,%dl
     e94:	74 da                	je     e70 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     e96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     e9a:	75 07                	jne    ea3 <strncmp+0x38>
    return 0;
     e9c:	b8 00 00 00 00       	mov    $0x0,%eax
     ea1:	eb 14                	jmp    eb7 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     ea3:	8b 45 08             	mov    0x8(%ebp),%eax
     ea6:	8a 00                	mov    (%eax),%al
     ea8:	0f b6 d0             	movzbl %al,%edx
     eab:	8b 45 0c             	mov    0xc(%ebp),%eax
     eae:	8a 00                	mov    (%eax),%al
     eb0:	0f b6 c0             	movzbl %al,%eax
     eb3:	29 c2                	sub    %eax,%edx
     eb5:	89 d0                	mov    %edx,%eax
}
     eb7:	5d                   	pop    %ebp
     eb8:	c3                   	ret    

00000eb9 <strlen>:

uint
strlen(const char *s)
{
     eb9:	55                   	push   %ebp
     eba:	89 e5                	mov    %esp,%ebp
     ebc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     ebf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     ec6:	eb 03                	jmp    ecb <strlen+0x12>
     ec8:	ff 45 fc             	incl   -0x4(%ebp)
     ecb:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ece:	8b 45 08             	mov    0x8(%ebp),%eax
     ed1:	01 d0                	add    %edx,%eax
     ed3:	8a 00                	mov    (%eax),%al
     ed5:	84 c0                	test   %al,%al
     ed7:	75 ef                	jne    ec8 <strlen+0xf>
    ;
  return n;
     ed9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     edc:	c9                   	leave  
     edd:	c3                   	ret    

00000ede <memset>:

void*
memset(void *dst, int c, uint n)
{
     ede:	55                   	push   %ebp
     edf:	89 e5                	mov    %esp,%ebp
     ee1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     ee4:	8b 45 10             	mov    0x10(%ebp),%eax
     ee7:	89 44 24 08          	mov    %eax,0x8(%esp)
     eeb:	8b 45 0c             	mov    0xc(%ebp),%eax
     eee:	89 44 24 04          	mov    %eax,0x4(%esp)
     ef2:	8b 45 08             	mov    0x8(%ebp),%eax
     ef5:	89 04 24             	mov    %eax,(%esp)
     ef8:	e8 e3 fd ff ff       	call   ce0 <stosb>
  return dst;
     efd:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f00:	c9                   	leave  
     f01:	c3                   	ret    

00000f02 <strchr>:

char*
strchr(const char *s, char c)
{
     f02:	55                   	push   %ebp
     f03:	89 e5                	mov    %esp,%ebp
     f05:	83 ec 04             	sub    $0x4,%esp
     f08:	8b 45 0c             	mov    0xc(%ebp),%eax
     f0b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     f0e:	eb 12                	jmp    f22 <strchr+0x20>
    if(*s == c)
     f10:	8b 45 08             	mov    0x8(%ebp),%eax
     f13:	8a 00                	mov    (%eax),%al
     f15:	3a 45 fc             	cmp    -0x4(%ebp),%al
     f18:	75 05                	jne    f1f <strchr+0x1d>
      return (char*)s;
     f1a:	8b 45 08             	mov    0x8(%ebp),%eax
     f1d:	eb 11                	jmp    f30 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     f1f:	ff 45 08             	incl   0x8(%ebp)
     f22:	8b 45 08             	mov    0x8(%ebp),%eax
     f25:	8a 00                	mov    (%eax),%al
     f27:	84 c0                	test   %al,%al
     f29:	75 e5                	jne    f10 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     f2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     f30:	c9                   	leave  
     f31:	c3                   	ret    

00000f32 <strcat>:

char *
strcat(char *dest, const char *src)
{
     f32:	55                   	push   %ebp
     f33:	89 e5                	mov    %esp,%ebp
     f35:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     f38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     f3f:	eb 03                	jmp    f44 <strcat+0x12>
     f41:	ff 45 fc             	incl   -0x4(%ebp)
     f44:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f47:	8b 45 08             	mov    0x8(%ebp),%eax
     f4a:	01 d0                	add    %edx,%eax
     f4c:	8a 00                	mov    (%eax),%al
     f4e:	84 c0                	test   %al,%al
     f50:	75 ef                	jne    f41 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     f52:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     f59:	eb 1e                	jmp    f79 <strcat+0x47>
        dest[i+j] = src[j];
     f5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f61:	01 d0                	add    %edx,%eax
     f63:	89 c2                	mov    %eax,%edx
     f65:	8b 45 08             	mov    0x8(%ebp),%eax
     f68:	01 c2                	add    %eax,%edx
     f6a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     f70:	01 c8                	add    %ecx,%eax
     f72:	8a 00                	mov    (%eax),%al
     f74:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     f76:	ff 45 f8             	incl   -0x8(%ebp)
     f79:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f7c:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7f:	01 d0                	add    %edx,%eax
     f81:	8a 00                	mov    (%eax),%al
     f83:	84 c0                	test   %al,%al
     f85:	75 d4                	jne    f5b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     f87:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f8d:	01 d0                	add    %edx,%eax
     f8f:	89 c2                	mov    %eax,%edx
     f91:	8b 45 08             	mov    0x8(%ebp),%eax
     f94:	01 d0                	add    %edx,%eax
     f96:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     f99:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f9c:	c9                   	leave  
     f9d:	c3                   	ret    

00000f9e <strstr>:

int 
strstr(char* s, char* sub)
{
     f9e:	55                   	push   %ebp
     f9f:	89 e5                	mov    %esp,%ebp
     fa1:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     fa4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     fab:	eb 7c                	jmp    1029 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     fad:	8b 55 fc             	mov    -0x4(%ebp),%edx
     fb0:	8b 45 08             	mov    0x8(%ebp),%eax
     fb3:	01 d0                	add    %edx,%eax
     fb5:	8a 10                	mov    (%eax),%dl
     fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
     fba:	8a 00                	mov    (%eax),%al
     fbc:	38 c2                	cmp    %al,%dl
     fbe:	75 66                	jne    1026 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
     fc3:	89 04 24             	mov    %eax,(%esp)
     fc6:	e8 ee fe ff ff       	call   eb9 <strlen>
     fcb:	83 f8 01             	cmp    $0x1,%eax
     fce:	75 05                	jne    fd5 <strstr+0x37>
            {  
                return i;
     fd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     fd3:	eb 6b                	jmp    1040 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     fd5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     fdc:	eb 3a                	jmp    1018 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     fde:	8b 45 f8             	mov    -0x8(%ebp),%eax
     fe1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     fe4:	01 d0                	add    %edx,%eax
     fe6:	89 c2                	mov    %eax,%edx
     fe8:	8b 45 08             	mov    0x8(%ebp),%eax
     feb:	01 d0                	add    %edx,%eax
     fed:	8a 10                	mov    (%eax),%dl
     fef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     ff2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ff5:	01 c8                	add    %ecx,%eax
     ff7:	8a 00                	mov    (%eax),%al
     ff9:	38 c2                	cmp    %al,%dl
     ffb:	75 16                	jne    1013 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     ffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1000:	8d 50 01             	lea    0x1(%eax),%edx
    1003:	8b 45 0c             	mov    0xc(%ebp),%eax
    1006:	01 d0                	add    %edx,%eax
    1008:	8a 00                	mov    (%eax),%al
    100a:	84 c0                	test   %al,%al
    100c:	75 07                	jne    1015 <strstr+0x77>
                    {
                        return i;
    100e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1011:	eb 2d                	jmp    1040 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
    1013:	eb 11                	jmp    1026 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
    1015:	ff 45 f8             	incl   -0x8(%ebp)
    1018:	8b 55 f8             	mov    -0x8(%ebp),%edx
    101b:	8b 45 0c             	mov    0xc(%ebp),%eax
    101e:	01 d0                	add    %edx,%eax
    1020:	8a 00                	mov    (%eax),%al
    1022:	84 c0                	test   %al,%al
    1024:	75 b8                	jne    fde <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    1026:	ff 45 fc             	incl   -0x4(%ebp)
    1029:	8b 55 fc             	mov    -0x4(%ebp),%edx
    102c:	8b 45 08             	mov    0x8(%ebp),%eax
    102f:	01 d0                	add    %edx,%eax
    1031:	8a 00                	mov    (%eax),%al
    1033:	84 c0                	test   %al,%al
    1035:	0f 85 72 ff ff ff    	jne    fad <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
    103b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1040:	c9                   	leave  
    1041:	c3                   	ret    

00001042 <strtok>:

char *
strtok(char *s, const char *delim)
{
    1042:	55                   	push   %ebp
    1043:	89 e5                	mov    %esp,%ebp
    1045:	53                   	push   %ebx
    1046:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
    1049:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    104d:	75 08                	jne    1057 <strtok+0x15>
  s = lasts;
    104f:	a1 08 22 00 00       	mov    0x2208,%eax
    1054:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
    1057:	8b 45 08             	mov    0x8(%ebp),%eax
    105a:	8d 50 01             	lea    0x1(%eax),%edx
    105d:	89 55 08             	mov    %edx,0x8(%ebp)
    1060:	8a 00                	mov    (%eax),%al
    1062:	0f be d8             	movsbl %al,%ebx
    1065:	85 db                	test   %ebx,%ebx
    1067:	75 07                	jne    1070 <strtok+0x2e>
      return 0;
    1069:	b8 00 00 00 00       	mov    $0x0,%eax
    106e:	eb 58                	jmp    10c8 <strtok+0x86>
    } while (strchr(delim, ch));
    1070:	88 d8                	mov    %bl,%al
    1072:	0f be c0             	movsbl %al,%eax
    1075:	89 44 24 04          	mov    %eax,0x4(%esp)
    1079:	8b 45 0c             	mov    0xc(%ebp),%eax
    107c:	89 04 24             	mov    %eax,(%esp)
    107f:	e8 7e fe ff ff       	call   f02 <strchr>
    1084:	85 c0                	test   %eax,%eax
    1086:	75 cf                	jne    1057 <strtok+0x15>
    --s;
    1088:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
    108b:	8b 45 0c             	mov    0xc(%ebp),%eax
    108e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1092:	8b 45 08             	mov    0x8(%ebp),%eax
    1095:	89 04 24             	mov    %eax,(%esp)
    1098:	e8 31 00 00 00       	call   10ce <strcspn>
    109d:	89 c2                	mov    %eax,%edx
    109f:	8b 45 08             	mov    0x8(%ebp),%eax
    10a2:	01 d0                	add    %edx,%eax
    10a4:	a3 08 22 00 00       	mov    %eax,0x2208
    if (*lasts != 0)
    10a9:	a1 08 22 00 00       	mov    0x2208,%eax
    10ae:	8a 00                	mov    (%eax),%al
    10b0:	84 c0                	test   %al,%al
    10b2:	74 11                	je     10c5 <strtok+0x83>
  *lasts++ = 0;
    10b4:	a1 08 22 00 00       	mov    0x2208,%eax
    10b9:	8d 50 01             	lea    0x1(%eax),%edx
    10bc:	89 15 08 22 00 00    	mov    %edx,0x2208
    10c2:	c6 00 00             	movb   $0x0,(%eax)
    return s;
    10c5:	8b 45 08             	mov    0x8(%ebp),%eax
}
    10c8:	83 c4 14             	add    $0x14,%esp
    10cb:	5b                   	pop    %ebx
    10cc:	5d                   	pop    %ebp
    10cd:	c3                   	ret    

000010ce <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
    10ce:	55                   	push   %ebp
    10cf:	89 e5                	mov    %esp,%ebp
    10d1:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
    10d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
    10db:	eb 26                	jmp    1103 <strcspn+0x35>
        if(strchr(s2,*s1))
    10dd:	8b 45 08             	mov    0x8(%ebp),%eax
    10e0:	8a 00                	mov    (%eax),%al
    10e2:	0f be c0             	movsbl %al,%eax
    10e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    10e9:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ec:	89 04 24             	mov    %eax,(%esp)
    10ef:	e8 0e fe ff ff       	call   f02 <strchr>
    10f4:	85 c0                	test   %eax,%eax
    10f6:	74 05                	je     10fd <strcspn+0x2f>
            return ret;
    10f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10fb:	eb 12                	jmp    110f <strcspn+0x41>
        else
            s1++,ret++;
    10fd:	ff 45 08             	incl   0x8(%ebp)
    1100:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
    1103:	8b 45 08             	mov    0x8(%ebp),%eax
    1106:	8a 00                	mov    (%eax),%al
    1108:	84 c0                	test   %al,%al
    110a:	75 d1                	jne    10dd <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
    110c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    110f:	c9                   	leave  
    1110:	c3                   	ret    

00001111 <isspace>:

int
isspace(unsigned char c)
{
    1111:	55                   	push   %ebp
    1112:	89 e5                	mov    %esp,%ebp
    1114:	83 ec 04             	sub    $0x4,%esp
    1117:	8b 45 08             	mov    0x8(%ebp),%eax
    111a:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
    111d:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
    1121:	74 1e                	je     1141 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
    1123:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
    1127:	74 18                	je     1141 <isspace+0x30>
    1129:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
    112d:	74 12                	je     1141 <isspace+0x30>
    112f:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
    1133:	74 0c                	je     1141 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
    1135:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
    1139:	74 06                	je     1141 <isspace+0x30>
    113b:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
    113f:	75 07                	jne    1148 <isspace+0x37>
    1141:	b8 01 00 00 00       	mov    $0x1,%eax
    1146:	eb 05                	jmp    114d <isspace+0x3c>
    1148:	b8 00 00 00 00       	mov    $0x0,%eax
}
    114d:	c9                   	leave  
    114e:	c3                   	ret    

0000114f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
    114f:	55                   	push   %ebp
    1150:	89 e5                	mov    %esp,%ebp
    1152:	57                   	push   %edi
    1153:	56                   	push   %esi
    1154:	53                   	push   %ebx
    1155:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
    1158:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
    115d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
    1164:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    1167:	eb 01                	jmp    116a <strtoul+0x1b>
  p += 1;
    1169:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    116a:	8a 03                	mov    (%ebx),%al
    116c:	0f b6 c0             	movzbl %al,%eax
    116f:	89 04 24             	mov    %eax,(%esp)
    1172:	e8 9a ff ff ff       	call   1111 <isspace>
    1177:	85 c0                	test   %eax,%eax
    1179:	75 ee                	jne    1169 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
    117b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    117f:	75 30                	jne    11b1 <strtoul+0x62>
    {
  if (*p == '0') {
    1181:	8a 03                	mov    (%ebx),%al
    1183:	3c 30                	cmp    $0x30,%al
    1185:	75 21                	jne    11a8 <strtoul+0x59>
      p += 1;
    1187:	43                   	inc    %ebx
      if (*p == 'x') {
    1188:	8a 03                	mov    (%ebx),%al
    118a:	3c 78                	cmp    $0x78,%al
    118c:	75 0a                	jne    1198 <strtoul+0x49>
    p += 1;
    118e:	43                   	inc    %ebx
    base = 16;
    118f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
    1196:	eb 31                	jmp    11c9 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
    1198:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
    119f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
    11a6:	eb 21                	jmp    11c9 <strtoul+0x7a>
      }
  }
  else base = 10;
    11a8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    11af:	eb 18                	jmp    11c9 <strtoul+0x7a>
    } else if (base == 16) {
    11b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    11b5:	75 12                	jne    11c9 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
    11b7:	8a 03                	mov    (%ebx),%al
    11b9:	3c 30                	cmp    $0x30,%al
    11bb:	75 0c                	jne    11c9 <strtoul+0x7a>
    11bd:	8d 43 01             	lea    0x1(%ebx),%eax
    11c0:	8a 00                	mov    (%eax),%al
    11c2:	3c 78                	cmp    $0x78,%al
    11c4:	75 03                	jne    11c9 <strtoul+0x7a>
      p += 2;
    11c6:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
    11c9:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
    11cd:	75 29                	jne    11f8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
    11cf:	8a 03                	mov    (%ebx),%al
    11d1:	0f be c0             	movsbl %al,%eax
    11d4:	83 e8 30             	sub    $0x30,%eax
    11d7:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
    11d9:	83 fe 07             	cmp    $0x7,%esi
    11dc:	76 06                	jbe    11e4 <strtoul+0x95>
    break;
    11de:	90                   	nop
    11df:	e9 b6 00 00 00       	jmp    129a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
    11e4:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
    11eb:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    11ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
    11f5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    11f6:	eb d7                	jmp    11cf <strtoul+0x80>
    } else if (base == 10) {
    11f8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
    11fc:	75 2b                	jne    1229 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
    11fe:	8a 03                	mov    (%ebx),%al
    1200:	0f be c0             	movsbl %al,%eax
    1203:	83 e8 30             	sub    $0x30,%eax
    1206:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
    1208:	83 fe 09             	cmp    $0x9,%esi
    120b:	76 06                	jbe    1213 <strtoul+0xc4>
    break;
    120d:	90                   	nop
    120e:	e9 87 00 00 00       	jmp    129a <strtoul+0x14b>
      }
      result = (10*result) + digit;
    1213:	89 f8                	mov    %edi,%eax
    1215:	c1 e0 02             	shl    $0x2,%eax
    1218:	01 f8                	add    %edi,%eax
    121a:	01 c0                	add    %eax,%eax
    121c:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    121f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
    1226:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    1227:	eb d5                	jmp    11fe <strtoul+0xaf>
    } else if (base == 16) {
    1229:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    122d:	75 35                	jne    1264 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
    122f:	8a 03                	mov    (%ebx),%al
    1231:	0f be c0             	movsbl %al,%eax
    1234:	83 e8 30             	sub    $0x30,%eax
    1237:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    1239:	83 fe 4a             	cmp    $0x4a,%esi
    123c:	76 02                	jbe    1240 <strtoul+0xf1>
    break;
    123e:	eb 22                	jmp    1262 <strtoul+0x113>
      }
      digit = cvtIn[digit];
    1240:	8a 86 40 21 00 00    	mov    0x2140(%esi),%al
    1246:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
    1249:	83 fe 0f             	cmp    $0xf,%esi
    124c:	76 02                	jbe    1250 <strtoul+0x101>
    break;
    124e:	eb 12                	jmp    1262 <strtoul+0x113>
      }
      result = (result << 4) + digit;
    1250:	89 f8                	mov    %edi,%eax
    1252:	c1 e0 04             	shl    $0x4,%eax
    1255:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1258:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
    125f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    1260:	eb cd                	jmp    122f <strtoul+0xe0>
    1262:	eb 36                	jmp    129a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
    1264:	8a 03                	mov    (%ebx),%al
    1266:	0f be c0             	movsbl %al,%eax
    1269:	83 e8 30             	sub    $0x30,%eax
    126c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    126e:	83 fe 4a             	cmp    $0x4a,%esi
    1271:	76 02                	jbe    1275 <strtoul+0x126>
    break;
    1273:	eb 25                	jmp    129a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
    1275:	8a 86 40 21 00 00    	mov    0x2140(%esi),%al
    127b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
    127e:	8b 45 10             	mov    0x10(%ebp),%eax
    1281:	39 f0                	cmp    %esi,%eax
    1283:	77 02                	ja     1287 <strtoul+0x138>
    break;
    1285:	eb 13                	jmp    129a <strtoul+0x14b>
      }
      result = result*base + digit;
    1287:	8b 45 10             	mov    0x10(%ebp),%eax
    128a:	0f af c7             	imul   %edi,%eax
    128d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1290:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
    1297:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
    1298:	eb ca                	jmp    1264 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
    129a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    129e:	75 03                	jne    12a3 <strtoul+0x154>
  p = string;
    12a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
    12a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    12a7:	74 05                	je     12ae <strtoul+0x15f>
  *endPtr = p;
    12a9:	8b 45 0c             	mov    0xc(%ebp),%eax
    12ac:	89 18                	mov    %ebx,(%eax)
    }

    return result;
    12ae:	89 f8                	mov    %edi,%eax
}
    12b0:	83 c4 14             	add    $0x14,%esp
    12b3:	5b                   	pop    %ebx
    12b4:	5e                   	pop    %esi
    12b5:	5f                   	pop    %edi
    12b6:	5d                   	pop    %ebp
    12b7:	c3                   	ret    

000012b8 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
    12b8:	55                   	push   %ebp
    12b9:	89 e5                	mov    %esp,%ebp
    12bb:	53                   	push   %ebx
    12bc:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
    12bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    12c2:	eb 01                	jmp    12c5 <strtol+0xd>
      p += 1;
    12c4:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    12c5:	8a 03                	mov    (%ebx),%al
    12c7:	0f b6 c0             	movzbl %al,%eax
    12ca:	89 04 24             	mov    %eax,(%esp)
    12cd:	e8 3f fe ff ff       	call   1111 <isspace>
    12d2:	85 c0                	test   %eax,%eax
    12d4:	75 ee                	jne    12c4 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
    12d6:	8a 03                	mov    (%ebx),%al
    12d8:	3c 2d                	cmp    $0x2d,%al
    12da:	75 1e                	jne    12fa <strtol+0x42>
  p += 1;
    12dc:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
    12dd:	8b 45 10             	mov    0x10(%ebp),%eax
    12e0:	89 44 24 08          	mov    %eax,0x8(%esp)
    12e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    12e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    12eb:	89 1c 24             	mov    %ebx,(%esp)
    12ee:	e8 5c fe ff ff       	call   114f <strtoul>
    12f3:	f7 d8                	neg    %eax
    12f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    12f8:	eb 20                	jmp    131a <strtol+0x62>
    } else {
  if (*p == '+') {
    12fa:	8a 03                	mov    (%ebx),%al
    12fc:	3c 2b                	cmp    $0x2b,%al
    12fe:	75 01                	jne    1301 <strtol+0x49>
      p += 1;
    1300:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
    1301:	8b 45 10             	mov    0x10(%ebp),%eax
    1304:	89 44 24 08          	mov    %eax,0x8(%esp)
    1308:	8b 45 0c             	mov    0xc(%ebp),%eax
    130b:	89 44 24 04          	mov    %eax,0x4(%esp)
    130f:	89 1c 24             	mov    %ebx,(%esp)
    1312:	e8 38 fe ff ff       	call   114f <strtoul>
    1317:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
    131a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
    131e:	75 17                	jne    1337 <strtol+0x7f>
    1320:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1324:	74 11                	je     1337 <strtol+0x7f>
    1326:	8b 45 0c             	mov    0xc(%ebp),%eax
    1329:	8b 00                	mov    (%eax),%eax
    132b:	39 d8                	cmp    %ebx,%eax
    132d:	75 08                	jne    1337 <strtol+0x7f>
  *endPtr = string;
    132f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1332:	8b 55 08             	mov    0x8(%ebp),%edx
    1335:	89 10                	mov    %edx,(%eax)
    }
    return result;
    1337:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
    133a:	83 c4 1c             	add    $0x1c,%esp
    133d:	5b                   	pop    %ebx
    133e:	5d                   	pop    %ebp
    133f:	c3                   	ret    

00001340 <gets>:

char*
gets(char *buf, int max)
{
    1340:	55                   	push   %ebp
    1341:	89 e5                	mov    %esp,%ebp
    1343:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1346:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    134d:	eb 49                	jmp    1398 <gets+0x58>
    cc = read(0, &c, 1);
    134f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1356:	00 
    1357:	8d 45 ef             	lea    -0x11(%ebp),%eax
    135a:	89 44 24 04          	mov    %eax,0x4(%esp)
    135e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1365:	e8 3e 01 00 00       	call   14a8 <read>
    136a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    136d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1371:	7f 02                	jg     1375 <gets+0x35>
      break;
    1373:	eb 2c                	jmp    13a1 <gets+0x61>
    buf[i++] = c;
    1375:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1378:	8d 50 01             	lea    0x1(%eax),%edx
    137b:	89 55 f4             	mov    %edx,-0xc(%ebp)
    137e:	89 c2                	mov    %eax,%edx
    1380:	8b 45 08             	mov    0x8(%ebp),%eax
    1383:	01 c2                	add    %eax,%edx
    1385:	8a 45 ef             	mov    -0x11(%ebp),%al
    1388:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    138a:	8a 45 ef             	mov    -0x11(%ebp),%al
    138d:	3c 0a                	cmp    $0xa,%al
    138f:	74 10                	je     13a1 <gets+0x61>
    1391:	8a 45 ef             	mov    -0x11(%ebp),%al
    1394:	3c 0d                	cmp    $0xd,%al
    1396:	74 09                	je     13a1 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1398:	8b 45 f4             	mov    -0xc(%ebp),%eax
    139b:	40                   	inc    %eax
    139c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    139f:	7c ae                	jl     134f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    13a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    13a4:	8b 45 08             	mov    0x8(%ebp),%eax
    13a7:	01 d0                	add    %edx,%eax
    13a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    13ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
    13af:	c9                   	leave  
    13b0:	c3                   	ret    

000013b1 <stat>:

int
stat(char *n, struct stat *st)
{
    13b1:	55                   	push   %ebp
    13b2:	89 e5                	mov    %esp,%ebp
    13b4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    13be:	00 
    13bf:	8b 45 08             	mov    0x8(%ebp),%eax
    13c2:	89 04 24             	mov    %eax,(%esp)
    13c5:	e8 06 01 00 00       	call   14d0 <open>
    13ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    13cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    13d1:	79 07                	jns    13da <stat+0x29>
    return -1;
    13d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    13d8:	eb 23                	jmp    13fd <stat+0x4c>
  r = fstat(fd, st);
    13da:	8b 45 0c             	mov    0xc(%ebp),%eax
    13dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    13e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13e4:	89 04 24             	mov    %eax,(%esp)
    13e7:	e8 fc 00 00 00       	call   14e8 <fstat>
    13ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    13ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    13f2:	89 04 24             	mov    %eax,(%esp)
    13f5:	e8 be 00 00 00       	call   14b8 <close>
  return r;
    13fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    13fd:	c9                   	leave  
    13fe:	c3                   	ret    

000013ff <atoi>:

int
atoi(const char *s)
{
    13ff:	55                   	push   %ebp
    1400:	89 e5                	mov    %esp,%ebp
    1402:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1405:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    140c:	eb 24                	jmp    1432 <atoi+0x33>
    n = n*10 + *s++ - '0';
    140e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1411:	89 d0                	mov    %edx,%eax
    1413:	c1 e0 02             	shl    $0x2,%eax
    1416:	01 d0                	add    %edx,%eax
    1418:	01 c0                	add    %eax,%eax
    141a:	89 c1                	mov    %eax,%ecx
    141c:	8b 45 08             	mov    0x8(%ebp),%eax
    141f:	8d 50 01             	lea    0x1(%eax),%edx
    1422:	89 55 08             	mov    %edx,0x8(%ebp)
    1425:	8a 00                	mov    (%eax),%al
    1427:	0f be c0             	movsbl %al,%eax
    142a:	01 c8                	add    %ecx,%eax
    142c:	83 e8 30             	sub    $0x30,%eax
    142f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1432:	8b 45 08             	mov    0x8(%ebp),%eax
    1435:	8a 00                	mov    (%eax),%al
    1437:	3c 2f                	cmp    $0x2f,%al
    1439:	7e 09                	jle    1444 <atoi+0x45>
    143b:	8b 45 08             	mov    0x8(%ebp),%eax
    143e:	8a 00                	mov    (%eax),%al
    1440:	3c 39                	cmp    $0x39,%al
    1442:	7e ca                	jle    140e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1444:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1447:	c9                   	leave  
    1448:	c3                   	ret    

00001449 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1449:	55                   	push   %ebp
    144a:	89 e5                	mov    %esp,%ebp
    144c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    144f:	8b 45 08             	mov    0x8(%ebp),%eax
    1452:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1455:	8b 45 0c             	mov    0xc(%ebp),%eax
    1458:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    145b:	eb 16                	jmp    1473 <memmove+0x2a>
    *dst++ = *src++;
    145d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1460:	8d 50 01             	lea    0x1(%eax),%edx
    1463:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1466:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1469:	8d 4a 01             	lea    0x1(%edx),%ecx
    146c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    146f:	8a 12                	mov    (%edx),%dl
    1471:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1473:	8b 45 10             	mov    0x10(%ebp),%eax
    1476:	8d 50 ff             	lea    -0x1(%eax),%edx
    1479:	89 55 10             	mov    %edx,0x10(%ebp)
    147c:	85 c0                	test   %eax,%eax
    147e:	7f dd                	jg     145d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1480:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1483:	c9                   	leave  
    1484:	c3                   	ret    
    1485:	90                   	nop
    1486:	90                   	nop
    1487:	90                   	nop

00001488 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1488:	b8 01 00 00 00       	mov    $0x1,%eax
    148d:	cd 40                	int    $0x40
    148f:	c3                   	ret    

00001490 <exit>:
SYSCALL(exit)
    1490:	b8 02 00 00 00       	mov    $0x2,%eax
    1495:	cd 40                	int    $0x40
    1497:	c3                   	ret    

00001498 <wait>:
SYSCALL(wait)
    1498:	b8 03 00 00 00       	mov    $0x3,%eax
    149d:	cd 40                	int    $0x40
    149f:	c3                   	ret    

000014a0 <pipe>:
SYSCALL(pipe)
    14a0:	b8 04 00 00 00       	mov    $0x4,%eax
    14a5:	cd 40                	int    $0x40
    14a7:	c3                   	ret    

000014a8 <read>:
SYSCALL(read)
    14a8:	b8 05 00 00 00       	mov    $0x5,%eax
    14ad:	cd 40                	int    $0x40
    14af:	c3                   	ret    

000014b0 <write>:
SYSCALL(write)
    14b0:	b8 10 00 00 00       	mov    $0x10,%eax
    14b5:	cd 40                	int    $0x40
    14b7:	c3                   	ret    

000014b8 <close>:
SYSCALL(close)
    14b8:	b8 15 00 00 00       	mov    $0x15,%eax
    14bd:	cd 40                	int    $0x40
    14bf:	c3                   	ret    

000014c0 <kill>:
SYSCALL(kill)
    14c0:	b8 06 00 00 00       	mov    $0x6,%eax
    14c5:	cd 40                	int    $0x40
    14c7:	c3                   	ret    

000014c8 <exec>:
SYSCALL(exec)
    14c8:	b8 07 00 00 00       	mov    $0x7,%eax
    14cd:	cd 40                	int    $0x40
    14cf:	c3                   	ret    

000014d0 <open>:
SYSCALL(open)
    14d0:	b8 0f 00 00 00       	mov    $0xf,%eax
    14d5:	cd 40                	int    $0x40
    14d7:	c3                   	ret    

000014d8 <mknod>:
SYSCALL(mknod)
    14d8:	b8 11 00 00 00       	mov    $0x11,%eax
    14dd:	cd 40                	int    $0x40
    14df:	c3                   	ret    

000014e0 <unlink>:
SYSCALL(unlink)
    14e0:	b8 12 00 00 00       	mov    $0x12,%eax
    14e5:	cd 40                	int    $0x40
    14e7:	c3                   	ret    

000014e8 <fstat>:
SYSCALL(fstat)
    14e8:	b8 08 00 00 00       	mov    $0x8,%eax
    14ed:	cd 40                	int    $0x40
    14ef:	c3                   	ret    

000014f0 <link>:
SYSCALL(link)
    14f0:	b8 13 00 00 00       	mov    $0x13,%eax
    14f5:	cd 40                	int    $0x40
    14f7:	c3                   	ret    

000014f8 <mkdir>:
SYSCALL(mkdir)
    14f8:	b8 14 00 00 00       	mov    $0x14,%eax
    14fd:	cd 40                	int    $0x40
    14ff:	c3                   	ret    

00001500 <chdir>:
SYSCALL(chdir)
    1500:	b8 09 00 00 00       	mov    $0x9,%eax
    1505:	cd 40                	int    $0x40
    1507:	c3                   	ret    

00001508 <dup>:
SYSCALL(dup)
    1508:	b8 0a 00 00 00       	mov    $0xa,%eax
    150d:	cd 40                	int    $0x40
    150f:	c3                   	ret    

00001510 <getpid>:
SYSCALL(getpid)
    1510:	b8 0b 00 00 00       	mov    $0xb,%eax
    1515:	cd 40                	int    $0x40
    1517:	c3                   	ret    

00001518 <sbrk>:
SYSCALL(sbrk)
    1518:	b8 0c 00 00 00       	mov    $0xc,%eax
    151d:	cd 40                	int    $0x40
    151f:	c3                   	ret    

00001520 <sleep>:
SYSCALL(sleep)
    1520:	b8 0d 00 00 00       	mov    $0xd,%eax
    1525:	cd 40                	int    $0x40
    1527:	c3                   	ret    

00001528 <uptime>:
SYSCALL(uptime)
    1528:	b8 0e 00 00 00       	mov    $0xe,%eax
    152d:	cd 40                	int    $0x40
    152f:	c3                   	ret    

00001530 <getname>:
SYSCALL(getname)
    1530:	b8 16 00 00 00       	mov    $0x16,%eax
    1535:	cd 40                	int    $0x40
    1537:	c3                   	ret    

00001538 <setname>:
SYSCALL(setname)
    1538:	b8 17 00 00 00       	mov    $0x17,%eax
    153d:	cd 40                	int    $0x40
    153f:	c3                   	ret    

00001540 <getmaxproc>:
SYSCALL(getmaxproc)
    1540:	b8 18 00 00 00       	mov    $0x18,%eax
    1545:	cd 40                	int    $0x40
    1547:	c3                   	ret    

00001548 <setmaxproc>:
SYSCALL(setmaxproc)
    1548:	b8 19 00 00 00       	mov    $0x19,%eax
    154d:	cd 40                	int    $0x40
    154f:	c3                   	ret    

00001550 <getmaxmem>:
SYSCALL(getmaxmem)
    1550:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1555:	cd 40                	int    $0x40
    1557:	c3                   	ret    

00001558 <setmaxmem>:
SYSCALL(setmaxmem)
    1558:	b8 1b 00 00 00       	mov    $0x1b,%eax
    155d:	cd 40                	int    $0x40
    155f:	c3                   	ret    

00001560 <getmaxdisk>:
SYSCALL(getmaxdisk)
    1560:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1565:	cd 40                	int    $0x40
    1567:	c3                   	ret    

00001568 <setmaxdisk>:
SYSCALL(setmaxdisk)
    1568:	b8 1d 00 00 00       	mov    $0x1d,%eax
    156d:	cd 40                	int    $0x40
    156f:	c3                   	ret    

00001570 <getusedmem>:
SYSCALL(getusedmem)
    1570:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1575:	cd 40                	int    $0x40
    1577:	c3                   	ret    

00001578 <setusedmem>:
SYSCALL(setusedmem)
    1578:	b8 1f 00 00 00       	mov    $0x1f,%eax
    157d:	cd 40                	int    $0x40
    157f:	c3                   	ret    

00001580 <getuseddisk>:
SYSCALL(getuseddisk)
    1580:	b8 20 00 00 00       	mov    $0x20,%eax
    1585:	cd 40                	int    $0x40
    1587:	c3                   	ret    

00001588 <setuseddisk>:
SYSCALL(setuseddisk)
    1588:	b8 21 00 00 00       	mov    $0x21,%eax
    158d:	cd 40                	int    $0x40
    158f:	c3                   	ret    

00001590 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1590:	55                   	push   %ebp
    1591:	89 e5                	mov    %esp,%ebp
    1593:	83 ec 18             	sub    $0x18,%esp
    1596:	8b 45 0c             	mov    0xc(%ebp),%eax
    1599:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    159c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15a3:	00 
    15a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
    15a7:	89 44 24 04          	mov    %eax,0x4(%esp)
    15ab:	8b 45 08             	mov    0x8(%ebp),%eax
    15ae:	89 04 24             	mov    %eax,(%esp)
    15b1:	e8 fa fe ff ff       	call   14b0 <write>
}
    15b6:	c9                   	leave  
    15b7:	c3                   	ret    

000015b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    15b8:	55                   	push   %ebp
    15b9:	89 e5                	mov    %esp,%ebp
    15bb:	56                   	push   %esi
    15bc:	53                   	push   %ebx
    15bd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    15c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    15c7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    15cb:	74 17                	je     15e4 <printint+0x2c>
    15cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    15d1:	79 11                	jns    15e4 <printint+0x2c>
    neg = 1;
    15d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    15da:	8b 45 0c             	mov    0xc(%ebp),%eax
    15dd:	f7 d8                	neg    %eax
    15df:	89 45 ec             	mov    %eax,-0x14(%ebp)
    15e2:	eb 06                	jmp    15ea <printint+0x32>
  } else {
    x = xx;
    15e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    15e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    15ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    15f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    15f4:	8d 41 01             	lea    0x1(%ecx),%eax
    15f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    15fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
    15fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1600:	ba 00 00 00 00       	mov    $0x0,%edx
    1605:	f7 f3                	div    %ebx
    1607:	89 d0                	mov    %edx,%eax
    1609:	8a 80 8c 21 00 00    	mov    0x218c(%eax),%al
    160f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1613:	8b 75 10             	mov    0x10(%ebp),%esi
    1616:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1619:	ba 00 00 00 00       	mov    $0x0,%edx
    161e:	f7 f6                	div    %esi
    1620:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1623:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1627:	75 c8                	jne    15f1 <printint+0x39>
  if(neg)
    1629:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    162d:	74 10                	je     163f <printint+0x87>
    buf[i++] = '-';
    162f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1632:	8d 50 01             	lea    0x1(%eax),%edx
    1635:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1638:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    163d:	eb 1e                	jmp    165d <printint+0xa5>
    163f:	eb 1c                	jmp    165d <printint+0xa5>
    putc(fd, buf[i]);
    1641:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1644:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1647:	01 d0                	add    %edx,%eax
    1649:	8a 00                	mov    (%eax),%al
    164b:	0f be c0             	movsbl %al,%eax
    164e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1652:	8b 45 08             	mov    0x8(%ebp),%eax
    1655:	89 04 24             	mov    %eax,(%esp)
    1658:	e8 33 ff ff ff       	call   1590 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    165d:	ff 4d f4             	decl   -0xc(%ebp)
    1660:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1664:	79 db                	jns    1641 <printint+0x89>
    putc(fd, buf[i]);
}
    1666:	83 c4 30             	add    $0x30,%esp
    1669:	5b                   	pop    %ebx
    166a:	5e                   	pop    %esi
    166b:	5d                   	pop    %ebp
    166c:	c3                   	ret    

0000166d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    166d:	55                   	push   %ebp
    166e:	89 e5                	mov    %esp,%ebp
    1670:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1673:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    167a:	8d 45 0c             	lea    0xc(%ebp),%eax
    167d:	83 c0 04             	add    $0x4,%eax
    1680:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1683:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    168a:	e9 77 01 00 00       	jmp    1806 <printf+0x199>
    c = fmt[i] & 0xff;
    168f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1692:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1695:	01 d0                	add    %edx,%eax
    1697:	8a 00                	mov    (%eax),%al
    1699:	0f be c0             	movsbl %al,%eax
    169c:	25 ff 00 00 00       	and    $0xff,%eax
    16a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    16a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    16a8:	75 2c                	jne    16d6 <printf+0x69>
      if(c == '%'){
    16aa:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    16ae:	75 0c                	jne    16bc <printf+0x4f>
        state = '%';
    16b0:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    16b7:	e9 47 01 00 00       	jmp    1803 <printf+0x196>
      } else {
        putc(fd, c);
    16bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    16bf:	0f be c0             	movsbl %al,%eax
    16c2:	89 44 24 04          	mov    %eax,0x4(%esp)
    16c6:	8b 45 08             	mov    0x8(%ebp),%eax
    16c9:	89 04 24             	mov    %eax,(%esp)
    16cc:	e8 bf fe ff ff       	call   1590 <putc>
    16d1:	e9 2d 01 00 00       	jmp    1803 <printf+0x196>
      }
    } else if(state == '%'){
    16d6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    16da:	0f 85 23 01 00 00    	jne    1803 <printf+0x196>
      if(c == 'd'){
    16e0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    16e4:	75 2d                	jne    1713 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    16e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    16e9:	8b 00                	mov    (%eax),%eax
    16eb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    16f2:	00 
    16f3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    16fa:	00 
    16fb:	89 44 24 04          	mov    %eax,0x4(%esp)
    16ff:	8b 45 08             	mov    0x8(%ebp),%eax
    1702:	89 04 24             	mov    %eax,(%esp)
    1705:	e8 ae fe ff ff       	call   15b8 <printint>
        ap++;
    170a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    170e:	e9 e9 00 00 00       	jmp    17fc <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    1713:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1717:	74 06                	je     171f <printf+0xb2>
    1719:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    171d:	75 2d                	jne    174c <printf+0xdf>
        printint(fd, *ap, 16, 0);
    171f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1722:	8b 00                	mov    (%eax),%eax
    1724:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    172b:	00 
    172c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1733:	00 
    1734:	89 44 24 04          	mov    %eax,0x4(%esp)
    1738:	8b 45 08             	mov    0x8(%ebp),%eax
    173b:	89 04 24             	mov    %eax,(%esp)
    173e:	e8 75 fe ff ff       	call   15b8 <printint>
        ap++;
    1743:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1747:	e9 b0 00 00 00       	jmp    17fc <printf+0x18f>
      } else if(c == 's'){
    174c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1750:	75 42                	jne    1794 <printf+0x127>
        s = (char*)*ap;
    1752:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1755:	8b 00                	mov    (%eax),%eax
    1757:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    175a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    175e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1762:	75 09                	jne    176d <printf+0x100>
          s = "(null)";
    1764:	c7 45 f4 5b 1b 00 00 	movl   $0x1b5b,-0xc(%ebp)
        while(*s != 0){
    176b:	eb 1c                	jmp    1789 <printf+0x11c>
    176d:	eb 1a                	jmp    1789 <printf+0x11c>
          putc(fd, *s);
    176f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1772:	8a 00                	mov    (%eax),%al
    1774:	0f be c0             	movsbl %al,%eax
    1777:	89 44 24 04          	mov    %eax,0x4(%esp)
    177b:	8b 45 08             	mov    0x8(%ebp),%eax
    177e:	89 04 24             	mov    %eax,(%esp)
    1781:	e8 0a fe ff ff       	call   1590 <putc>
          s++;
    1786:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1789:	8b 45 f4             	mov    -0xc(%ebp),%eax
    178c:	8a 00                	mov    (%eax),%al
    178e:	84 c0                	test   %al,%al
    1790:	75 dd                	jne    176f <printf+0x102>
    1792:	eb 68                	jmp    17fc <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1794:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1798:	75 1d                	jne    17b7 <printf+0x14a>
        putc(fd, *ap);
    179a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    179d:	8b 00                	mov    (%eax),%eax
    179f:	0f be c0             	movsbl %al,%eax
    17a2:	89 44 24 04          	mov    %eax,0x4(%esp)
    17a6:	8b 45 08             	mov    0x8(%ebp),%eax
    17a9:	89 04 24             	mov    %eax,(%esp)
    17ac:	e8 df fd ff ff       	call   1590 <putc>
        ap++;
    17b1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    17b5:	eb 45                	jmp    17fc <printf+0x18f>
      } else if(c == '%'){
    17b7:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17bb:	75 17                	jne    17d4 <printf+0x167>
        putc(fd, c);
    17bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17c0:	0f be c0             	movsbl %al,%eax
    17c3:	89 44 24 04          	mov    %eax,0x4(%esp)
    17c7:	8b 45 08             	mov    0x8(%ebp),%eax
    17ca:	89 04 24             	mov    %eax,(%esp)
    17cd:	e8 be fd ff ff       	call   1590 <putc>
    17d2:	eb 28                	jmp    17fc <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    17d4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    17db:	00 
    17dc:	8b 45 08             	mov    0x8(%ebp),%eax
    17df:	89 04 24             	mov    %eax,(%esp)
    17e2:	e8 a9 fd ff ff       	call   1590 <putc>
        putc(fd, c);
    17e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17ea:	0f be c0             	movsbl %al,%eax
    17ed:	89 44 24 04          	mov    %eax,0x4(%esp)
    17f1:	8b 45 08             	mov    0x8(%ebp),%eax
    17f4:	89 04 24             	mov    %eax,(%esp)
    17f7:	e8 94 fd ff ff       	call   1590 <putc>
      }
      state = 0;
    17fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1803:	ff 45 f0             	incl   -0x10(%ebp)
    1806:	8b 55 0c             	mov    0xc(%ebp),%edx
    1809:	8b 45 f0             	mov    -0x10(%ebp),%eax
    180c:	01 d0                	add    %edx,%eax
    180e:	8a 00                	mov    (%eax),%al
    1810:	84 c0                	test   %al,%al
    1812:	0f 85 77 fe ff ff    	jne    168f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1818:	c9                   	leave  
    1819:	c3                   	ret    
    181a:	90                   	nop
    181b:	90                   	nop

0000181c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    181c:	55                   	push   %ebp
    181d:	89 e5                	mov    %esp,%ebp
    181f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1822:	8b 45 08             	mov    0x8(%ebp),%eax
    1825:	83 e8 08             	sub    $0x8,%eax
    1828:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    182b:	a1 14 22 00 00       	mov    0x2214,%eax
    1830:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1833:	eb 24                	jmp    1859 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1835:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1838:	8b 00                	mov    (%eax),%eax
    183a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    183d:	77 12                	ja     1851 <free+0x35>
    183f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1842:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1845:	77 24                	ja     186b <free+0x4f>
    1847:	8b 45 fc             	mov    -0x4(%ebp),%eax
    184a:	8b 00                	mov    (%eax),%eax
    184c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    184f:	77 1a                	ja     186b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1851:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1854:	8b 00                	mov    (%eax),%eax
    1856:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1859:	8b 45 f8             	mov    -0x8(%ebp),%eax
    185c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    185f:	76 d4                	jbe    1835 <free+0x19>
    1861:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1864:	8b 00                	mov    (%eax),%eax
    1866:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1869:	76 ca                	jbe    1835 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    186b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    186e:	8b 40 04             	mov    0x4(%eax),%eax
    1871:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1878:	8b 45 f8             	mov    -0x8(%ebp),%eax
    187b:	01 c2                	add    %eax,%edx
    187d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1880:	8b 00                	mov    (%eax),%eax
    1882:	39 c2                	cmp    %eax,%edx
    1884:	75 24                	jne    18aa <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1886:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1889:	8b 50 04             	mov    0x4(%eax),%edx
    188c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    188f:	8b 00                	mov    (%eax),%eax
    1891:	8b 40 04             	mov    0x4(%eax),%eax
    1894:	01 c2                	add    %eax,%edx
    1896:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1899:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    189c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    189f:	8b 00                	mov    (%eax),%eax
    18a1:	8b 10                	mov    (%eax),%edx
    18a3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18a6:	89 10                	mov    %edx,(%eax)
    18a8:	eb 0a                	jmp    18b4 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    18aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ad:	8b 10                	mov    (%eax),%edx
    18af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18b2:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    18b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18b7:	8b 40 04             	mov    0x4(%eax),%eax
    18ba:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    18c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18c4:	01 d0                	add    %edx,%eax
    18c6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    18c9:	75 20                	jne    18eb <free+0xcf>
    p->s.size += bp->s.size;
    18cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ce:	8b 50 04             	mov    0x4(%eax),%edx
    18d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18d4:	8b 40 04             	mov    0x4(%eax),%eax
    18d7:	01 c2                	add    %eax,%edx
    18d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18dc:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    18df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    18e2:	8b 10                	mov    (%eax),%edx
    18e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18e7:	89 10                	mov    %edx,(%eax)
    18e9:	eb 08                	jmp    18f3 <free+0xd7>
  } else
    p->s.ptr = bp;
    18eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18ee:	8b 55 f8             	mov    -0x8(%ebp),%edx
    18f1:	89 10                	mov    %edx,(%eax)
  freep = p;
    18f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    18f6:	a3 14 22 00 00       	mov    %eax,0x2214
}
    18fb:	c9                   	leave  
    18fc:	c3                   	ret    

000018fd <morecore>:

static Header*
morecore(uint nu)
{
    18fd:	55                   	push   %ebp
    18fe:	89 e5                	mov    %esp,%ebp
    1900:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1903:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    190a:	77 07                	ja     1913 <morecore+0x16>
    nu = 4096;
    190c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1913:	8b 45 08             	mov    0x8(%ebp),%eax
    1916:	c1 e0 03             	shl    $0x3,%eax
    1919:	89 04 24             	mov    %eax,(%esp)
    191c:	e8 f7 fb ff ff       	call   1518 <sbrk>
    1921:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1924:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1928:	75 07                	jne    1931 <morecore+0x34>
    return 0;
    192a:	b8 00 00 00 00       	mov    $0x0,%eax
    192f:	eb 22                	jmp    1953 <morecore+0x56>
  hp = (Header*)p;
    1931:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1934:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1937:	8b 45 f0             	mov    -0x10(%ebp),%eax
    193a:	8b 55 08             	mov    0x8(%ebp),%edx
    193d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1940:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1943:	83 c0 08             	add    $0x8,%eax
    1946:	89 04 24             	mov    %eax,(%esp)
    1949:	e8 ce fe ff ff       	call   181c <free>
  return freep;
    194e:	a1 14 22 00 00       	mov    0x2214,%eax
}
    1953:	c9                   	leave  
    1954:	c3                   	ret    

00001955 <malloc>:

void*
malloc(uint nbytes)
{
    1955:	55                   	push   %ebp
    1956:	89 e5                	mov    %esp,%ebp
    1958:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    195b:	8b 45 08             	mov    0x8(%ebp),%eax
    195e:	83 c0 07             	add    $0x7,%eax
    1961:	c1 e8 03             	shr    $0x3,%eax
    1964:	40                   	inc    %eax
    1965:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1968:	a1 14 22 00 00       	mov    0x2214,%eax
    196d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1970:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1974:	75 23                	jne    1999 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1976:	c7 45 f0 0c 22 00 00 	movl   $0x220c,-0x10(%ebp)
    197d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1980:	a3 14 22 00 00       	mov    %eax,0x2214
    1985:	a1 14 22 00 00       	mov    0x2214,%eax
    198a:	a3 0c 22 00 00       	mov    %eax,0x220c
    base.s.size = 0;
    198f:	c7 05 10 22 00 00 00 	movl   $0x0,0x2210
    1996:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1999:	8b 45 f0             	mov    -0x10(%ebp),%eax
    199c:	8b 00                	mov    (%eax),%eax
    199e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    19a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19a4:	8b 40 04             	mov    0x4(%eax),%eax
    19a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    19aa:	72 4d                	jb     19f9 <malloc+0xa4>
      if(p->s.size == nunits)
    19ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19af:	8b 40 04             	mov    0x4(%eax),%eax
    19b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    19b5:	75 0c                	jne    19c3 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    19b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19ba:	8b 10                	mov    (%eax),%edx
    19bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19bf:	89 10                	mov    %edx,(%eax)
    19c1:	eb 26                	jmp    19e9 <malloc+0x94>
      else {
        p->s.size -= nunits;
    19c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19c6:	8b 40 04             	mov    0x4(%eax),%eax
    19c9:	2b 45 ec             	sub    -0x14(%ebp),%eax
    19cc:	89 c2                	mov    %eax,%edx
    19ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    19d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d7:	8b 40 04             	mov    0x4(%eax),%eax
    19da:	c1 e0 03             	shl    $0x3,%eax
    19dd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    19e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19e3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    19e6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    19e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    19ec:	a3 14 22 00 00       	mov    %eax,0x2214
      return (void*)(p + 1);
    19f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19f4:	83 c0 08             	add    $0x8,%eax
    19f7:	eb 38                	jmp    1a31 <malloc+0xdc>
    }
    if(p == freep)
    19f9:	a1 14 22 00 00       	mov    0x2214,%eax
    19fe:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1a01:	75 1b                	jne    1a1e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1a06:	89 04 24             	mov    %eax,(%esp)
    1a09:	e8 ef fe ff ff       	call   18fd <morecore>
    1a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1a11:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a15:	75 07                	jne    1a1e <malloc+0xc9>
        return 0;
    1a17:	b8 00 00 00 00       	mov    $0x0,%eax
    1a1c:	eb 13                	jmp    1a31 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a21:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a27:	8b 00                	mov    (%eax),%eax
    1a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1a2c:	e9 70 ff ff ff       	jmp    19a1 <malloc+0x4c>
}
    1a31:	c9                   	leave  
    1a32:	c3                   	ret    
