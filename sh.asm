
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
       c:	e8 7f 13 00 00       	call   1390 <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 00 19 00 00 	mov    0x1900(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 d4 18 00 00 	movl   $0x18d4,(%esp)
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
      40:	e8 4b 13 00 00       	call   1390 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 6b 13 00 00       	call   13c8 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 db 18 00 	movl   $0x18db,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 92 14 00 00       	call   150d <printf>
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
      8f:	e8 24 13 00 00       	call   13b8 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 24 13 00 00       	call   13d0 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 eb 18 00 	movl   $0x18eb,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 3f 14 00 00       	call   150d <printf>
      exit();
      ce:	e8 bd 12 00 00       	call   1390 <exit>
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
     103:	e8 90 12 00 00       	call   1398 <wait>
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
     127:	e8 74 12 00 00       	call   13a0 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 fb 18 00 00 	movl   $0x18fb,(%esp)
     137:	e8 12 02 00 00       	call   34e <panic>
    if(fork1() == 0){
     13c:	e8 33 02 00 00       	call   374 <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 67 12 00 00       	call   13b8 <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 ac 12 00 00       	call   1408 <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 51 12 00 00       	call   13b8 <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 46 12 00 00       	call   13b8 <close>
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
     190:	e8 23 12 00 00       	call   13b8 <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 68 12 00 00       	call   1408 <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 0d 12 00 00       	call   13b8 <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 02 12 00 00       	call   13b8 <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 e9 11 00 00       	call   13b8 <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 de 11 00 00       	call   13b8 <close>
    wait();
     1da:	e8 b9 11 00 00       	call   1398 <wait>
    wait();
     1df:	e8 b4 11 00 00       	call   1398 <wait>
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
     206:	e8 85 11 00 00       	call   1390 <exit>

0000020b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     20b:	55                   	push   %ebp
     20c:	89 e5                	mov    %esp,%ebp
     20e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     211:	c7 44 24 04 18 19 00 	movl   $0x1918,0x4(%esp)
     218:	00 
     219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     220:	e8 e8 12 00 00       	call   150d <printf>
  memset(buf, 0, nbuf);
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	89 44 24 08          	mov    %eax,0x8(%esp)
     22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     233:	00 
     234:	8b 45 08             	mov    0x8(%ebp),%eax
     237:	89 04 24             	mov    %eax,(%esp)
     23a:	e8 9f 0b 00 00       	call   dde <memset>
  gets(buf, nbuf);
     23f:	8b 45 0c             	mov    0xc(%ebp),%eax
     242:	89 44 24 04          	mov    %eax,0x4(%esp)
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 ef 0f 00 00       	call   1240 <gets>
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
     281:	e8 32 11 00 00       	call   13b8 <close>
      break;
     286:	eb 1f                	jmp    2a7 <main+0x3f>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     288:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     28f:	00 
     290:	c7 04 24 1b 19 00 00 	movl   $0x191b,(%esp)
     297:	e8 34 11 00 00       	call   13d0 <open>
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
     2ac:	a0 00 20 00 00       	mov    0x2000,%al
     2b1:	3c 63                	cmp    $0x63,%al
     2b3:	75 56                	jne    30b <main+0xa3>
     2b5:	a0 01 20 00 00       	mov    0x2001,%al
     2ba:	3c 64                	cmp    $0x64,%al
     2bc:	75 4d                	jne    30b <main+0xa3>
     2be:	a0 02 20 00 00       	mov    0x2002,%al
     2c3:	3c 20                	cmp    $0x20,%al
     2c5:	75 44                	jne    30b <main+0xa3>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     2c7:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
     2ce:	e8 e6 0a 00 00       	call   db9 <strlen>
     2d3:	48                   	dec    %eax
     2d4:	c6 80 00 20 00 00 00 	movb   $0x0,0x2000(%eax)
      if(chdir(buf+3) < 0)
     2db:	c7 04 24 03 20 00 00 	movl   $0x2003,(%esp)
     2e2:	e8 19 11 00 00       	call   1400 <chdir>
     2e7:	85 c0                	test   %eax,%eax
     2e9:	79 1e                	jns    309 <main+0xa1>
        printf(2, "cannot cd %s\n", buf+3);
     2eb:	c7 44 24 08 03 20 00 	movl   $0x2003,0x8(%esp)
     2f2:	00 
     2f3:	c7 44 24 04 23 19 00 	movl   $0x1923,0x4(%esp)
     2fa:	00 
     2fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     302:	e8 06 12 00 00       	call   150d <printf>
      continue;
     307:	eb 24                	jmp    32d <main+0xc5>
     309:	eb 22                	jmp    32d <main+0xc5>
    }
    if(fork1() == 0)
     30b:	e8 64 00 00 00       	call   374 <fork1>
     310:	85 c0                	test   %eax,%eax
     312:	75 14                	jne    328 <main+0xc0>
      runcmd(parsecmd(buf));
     314:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
     31b:	e8 b8 03 00 00       	call   6d8 <parsecmd>
     320:	89 04 24             	mov    %eax,(%esp)
     323:	e8 d8 fc ff ff       	call   0 <runcmd>
    wait();
     328:	e8 6b 10 00 00       	call   1398 <wait>
      break;
    }
  }

  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     32d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     334:	00 
     335:	c7 04 24 00 20 00 00 	movl   $0x2000,(%esp)
     33c:	e8 ca fe ff ff       	call   20b <getcmd>
     341:	85 c0                	test   %eax,%eax
     343:	0f 89 63 ff ff ff    	jns    2ac <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     349:	e8 42 10 00 00       	call   1390 <exit>

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
     35b:	c7 44 24 04 31 19 00 	movl   $0x1931,0x4(%esp)
     362:	00 
     363:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     36a:	e8 9e 11 00 00       	call   150d <printf>
  exit();
     36f:	e8 1c 10 00 00       	call   1390 <exit>

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
     37a:	e8 09 10 00 00       	call   1388 <fork>
     37f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     382:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     386:	75 0c                	jne    394 <fork1+0x20>
    panic("fork");
     388:	c7 04 24 35 19 00 00 	movl   $0x1935,(%esp)
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
     39f:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     3a6:	e8 4a 14 00 00       	call   17f5 <malloc>
     3ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3ae:	c7 44 24 08 54 00 00 	movl   $0x54,0x8(%esp)
     3b5:	00 
     3b6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3bd:	00 
     3be:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3c1:	89 04 24             	mov    %eax,(%esp)
     3c4:	e8 15 0a 00 00       	call   dde <memset>
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
     3e4:	e8 0c 14 00 00       	call   17f5 <malloc>
     3e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     3ec:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     3f3:	00 
     3f4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3fb:	00 
     3fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     3ff:	89 04 24             	mov    %eax,(%esp)
     402:	e8 d7 09 00 00       	call   dde <memset>
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
     44f:	e8 a1 13 00 00       	call   17f5 <malloc>
     454:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     457:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     45e:	00 
     45f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     466:	00 
     467:	8b 45 f4             	mov    -0xc(%ebp),%eax
     46a:	89 04 24             	mov    %eax,(%esp)
     46d:	e8 6c 09 00 00       	call   dde <memset>
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
     49f:	e8 51 13 00 00       	call   17f5 <malloc>
     4a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4a7:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     4ae:	00 
     4af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4b6:	00 
     4b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ba:	89 04 24             	mov    %eax,(%esp)
     4bd:	e8 1c 09 00 00       	call   dde <memset>
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
     4ef:	e8 01 13 00 00       	call   17f5 <malloc>
     4f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4f7:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     4fe:	00 
     4ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     506:	00 
     507:	8b 45 f4             	mov    -0xc(%ebp),%eax
     50a:	89 04 24             	mov    %eax,(%esp)
     50d:	e8 cc 08 00 00       	call   dde <memset>
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
     550:	c7 04 24 80 1f 00 00 	movl   $0x1f80,(%esp)
     557:	e8 a6 08 00 00       	call   e02 <strchr>
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
     5f2:	c7 04 24 80 1f 00 00 	movl   $0x1f80,(%esp)
     5f9:	e8 04 08 00 00       	call   e02 <strchr>
     5fe:	85 c0                	test   %eax,%eax
     600:	75 1c                	jne    61e <gettoken+0xf5>
     602:	8b 45 f4             	mov    -0xc(%ebp),%eax
     605:	8a 00                	mov    (%eax),%al
     607:	0f be c0             	movsbl %al,%eax
     60a:	89 44 24 04          	mov    %eax,0x4(%esp)
     60e:	c7 04 24 86 1f 00 00 	movl   $0x1f86,(%esp)
     615:	e8 e8 07 00 00       	call   e02 <strchr>
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
     64a:	c7 04 24 80 1f 00 00 	movl   $0x1f80,(%esp)
     651:	e8 ac 07 00 00       	call   e02 <strchr>
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
     68e:	c7 04 24 80 1f 00 00 	movl   $0x1f80,(%esp)
     695:	e8 68 07 00 00       	call   e02 <strchr>
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
     6c1:	e8 3c 07 00 00       	call   e02 <strchr>
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
     6e8:	e8 cc 06 00 00       	call   db9 <strlen>
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
     707:	c7 44 24 08 3a 19 00 	movl   $0x193a,0x8(%esp)
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
     730:	c7 44 24 04 3b 19 00 	movl   $0x193b,0x4(%esp)
     737:	00 
     738:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     73f:	e8 c9 0d 00 00       	call   150d <printf>
    panic("syntax");
     744:	c7 04 24 4a 19 00 00 	movl   $0x194a,(%esp)
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
     7b1:	c7 44 24 08 51 19 00 	movl   $0x1951,0x8(%esp)
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
     7cf:	c7 44 24 08 53 19 00 	movl   $0x1953,0x8(%esp)
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
     853:	c7 44 24 08 55 19 00 	movl   $0x1955,0x8(%esp)
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
     911:	c7 04 24 57 19 00 00 	movl   $0x1957,(%esp)
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
     9bd:	c7 44 24 08 74 19 00 	movl   $0x1974,0x8(%esp)
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
     9ea:	c7 44 24 08 77 19 00 	movl   $0x1977,0x8(%esp)
     9f1:	00 
     9f2:	8b 45 0c             	mov    0xc(%ebp),%eax
     9f5:	89 44 24 04          	mov    %eax,0x4(%esp)
     9f9:	8b 45 08             	mov    0x8(%ebp),%eax
     9fc:	89 04 24             	mov    %eax,(%esp)
     9ff:	e8 63 fc ff ff       	call   667 <peek>
     a04:	85 c0                	test   %eax,%eax
     a06:	75 0c                	jne    a14 <parseblock+0x30>
    panic("parseblock");
     a08:	c7 04 24 79 19 00 00 	movl   $0x1979,(%esp)
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
     a4b:	c7 44 24 08 84 19 00 	movl   $0x1984,0x8(%esp)
     a52:	00 
     a53:	8b 45 0c             	mov    0xc(%ebp),%eax
     a56:	89 44 24 04          	mov    %eax,0x4(%esp)
     a5a:	8b 45 08             	mov    0x8(%ebp),%eax
     a5d:	89 04 24             	mov    %eax,(%esp)
     a60:	e8 02 fc ff ff       	call   667 <peek>
     a65:	85 c0                	test   %eax,%eax
     a67:	75 0c                	jne    a75 <parseblock+0x91>
    panic("syntax - missing )");
     a69:	c7 04 24 86 19 00 00 	movl   $0x1986,(%esp)
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
     abe:	c7 44 24 08 77 19 00 	movl   $0x1977,0x8(%esp)
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
     b5d:	c7 04 24 4a 19 00 00 	movl   $0x194a,(%esp)
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
     b7f:	83 c1 08             	add    $0x8,%ecx
     b82:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    argc++;
     b86:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     b89:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
     b8d:	7e 0c                	jle    b9b <parseexec+0xe3>
      panic("too many args");
     b8f:	c7 04 24 99 19 00 00 	movl   $0x1999,(%esp)
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
     bb7:	c7 44 24 08 a7 19 00 	movl   $0x19a7,0x8(%esp)
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
     bed:	83 c2 08             	add    $0x8,%edx
     bf0:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
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
     c21:	8b 04 85 ac 19 00 00 	mov    0x19ac(,%eax,4),%eax
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
     c3f:	83 c2 08             	add    $0x8,%edx
     c42:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
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

00000d33 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d33:	55                   	push   %ebp
     d34:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     d36:	eb 06                	jmp    d3e <strcmp+0xb>
    p++, q++;
     d38:	ff 45 08             	incl   0x8(%ebp)
     d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     d3e:	8b 45 08             	mov    0x8(%ebp),%eax
     d41:	8a 00                	mov    (%eax),%al
     d43:	84 c0                	test   %al,%al
     d45:	74 0e                	je     d55 <strcmp+0x22>
     d47:	8b 45 08             	mov    0x8(%ebp),%eax
     d4a:	8a 10                	mov    (%eax),%dl
     d4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     d4f:	8a 00                	mov    (%eax),%al
     d51:	38 c2                	cmp    %al,%dl
     d53:	74 e3                	je     d38 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     d55:	8b 45 08             	mov    0x8(%ebp),%eax
     d58:	8a 00                	mov    (%eax),%al
     d5a:	0f b6 d0             	movzbl %al,%edx
     d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d60:	8a 00                	mov    (%eax),%al
     d62:	0f b6 c0             	movzbl %al,%eax
     d65:	29 c2                	sub    %eax,%edx
     d67:	89 d0                	mov    %edx,%eax
}
     d69:	5d                   	pop    %ebp
     d6a:	c3                   	ret    

00000d6b <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     d6b:	55                   	push   %ebp
     d6c:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     d6e:	eb 09                	jmp    d79 <strncmp+0xe>
    n--, p++, q++;
     d70:	ff 4d 10             	decl   0x10(%ebp)
     d73:	ff 45 08             	incl   0x8(%ebp)
     d76:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d7d:	74 17                	je     d96 <strncmp+0x2b>
     d7f:	8b 45 08             	mov    0x8(%ebp),%eax
     d82:	8a 00                	mov    (%eax),%al
     d84:	84 c0                	test   %al,%al
     d86:	74 0e                	je     d96 <strncmp+0x2b>
     d88:	8b 45 08             	mov    0x8(%ebp),%eax
     d8b:	8a 10                	mov    (%eax),%dl
     d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
     d90:	8a 00                	mov    (%eax),%al
     d92:	38 c2                	cmp    %al,%dl
     d94:	74 da                	je     d70 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     d96:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d9a:	75 07                	jne    da3 <strncmp+0x38>
    return 0;
     d9c:	b8 00 00 00 00       	mov    $0x0,%eax
     da1:	eb 14                	jmp    db7 <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     da3:	8b 45 08             	mov    0x8(%ebp),%eax
     da6:	8a 00                	mov    (%eax),%al
     da8:	0f b6 d0             	movzbl %al,%edx
     dab:	8b 45 0c             	mov    0xc(%ebp),%eax
     dae:	8a 00                	mov    (%eax),%al
     db0:	0f b6 c0             	movzbl %al,%eax
     db3:	29 c2                	sub    %eax,%edx
     db5:	89 d0                	mov    %edx,%eax
}
     db7:	5d                   	pop    %ebp
     db8:	c3                   	ret    

00000db9 <strlen>:

uint
strlen(const char *s)
{
     db9:	55                   	push   %ebp
     dba:	89 e5                	mov    %esp,%ebp
     dbc:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     dbf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     dc6:	eb 03                	jmp    dcb <strlen+0x12>
     dc8:	ff 45 fc             	incl   -0x4(%ebp)
     dcb:	8b 55 fc             	mov    -0x4(%ebp),%edx
     dce:	8b 45 08             	mov    0x8(%ebp),%eax
     dd1:	01 d0                	add    %edx,%eax
     dd3:	8a 00                	mov    (%eax),%al
     dd5:	84 c0                	test   %al,%al
     dd7:	75 ef                	jne    dc8 <strlen+0xf>
    ;
  return n;
     dd9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     ddc:	c9                   	leave  
     ddd:	c3                   	ret    

00000dde <memset>:

void*
memset(void *dst, int c, uint n)
{
     dde:	55                   	push   %ebp
     ddf:	89 e5                	mov    %esp,%ebp
     de1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     de4:	8b 45 10             	mov    0x10(%ebp),%eax
     de7:	89 44 24 08          	mov    %eax,0x8(%esp)
     deb:	8b 45 0c             	mov    0xc(%ebp),%eax
     dee:	89 44 24 04          	mov    %eax,0x4(%esp)
     df2:	8b 45 08             	mov    0x8(%ebp),%eax
     df5:	89 04 24             	mov    %eax,(%esp)
     df8:	e8 e3 fe ff ff       	call   ce0 <stosb>
  return dst;
     dfd:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e00:	c9                   	leave  
     e01:	c3                   	ret    

00000e02 <strchr>:

char*
strchr(const char *s, char c)
{
     e02:	55                   	push   %ebp
     e03:	89 e5                	mov    %esp,%ebp
     e05:	83 ec 04             	sub    $0x4,%esp
     e08:	8b 45 0c             	mov    0xc(%ebp),%eax
     e0b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     e0e:	eb 12                	jmp    e22 <strchr+0x20>
    if(*s == c)
     e10:	8b 45 08             	mov    0x8(%ebp),%eax
     e13:	8a 00                	mov    (%eax),%al
     e15:	3a 45 fc             	cmp    -0x4(%ebp),%al
     e18:	75 05                	jne    e1f <strchr+0x1d>
      return (char*)s;
     e1a:	8b 45 08             	mov    0x8(%ebp),%eax
     e1d:	eb 11                	jmp    e30 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     e1f:	ff 45 08             	incl   0x8(%ebp)
     e22:	8b 45 08             	mov    0x8(%ebp),%eax
     e25:	8a 00                	mov    (%eax),%al
     e27:	84 c0                	test   %al,%al
     e29:	75 e5                	jne    e10 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     e2b:	b8 00 00 00 00       	mov    $0x0,%eax
}
     e30:	c9                   	leave  
     e31:	c3                   	ret    

00000e32 <strcat>:

char *
strcat(char *dest, const char *src)
{
     e32:	55                   	push   %ebp
     e33:	89 e5                	mov    %esp,%ebp
     e35:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     e38:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     e3f:	eb 03                	jmp    e44 <strcat+0x12>
     e41:	ff 45 fc             	incl   -0x4(%ebp)
     e44:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e47:	8b 45 08             	mov    0x8(%ebp),%eax
     e4a:	01 d0                	add    %edx,%eax
     e4c:	8a 00                	mov    (%eax),%al
     e4e:	84 c0                	test   %al,%al
     e50:	75 ef                	jne    e41 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
     e52:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
     e59:	eb 1e                	jmp    e79 <strcat+0x47>
        dest[i+j] = src[j];
     e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e61:	01 d0                	add    %edx,%eax
     e63:	89 c2                	mov    %eax,%edx
     e65:	8b 45 08             	mov    0x8(%ebp),%eax
     e68:	01 c2                	add    %eax,%edx
     e6a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     e70:	01 c8                	add    %ecx,%eax
     e72:	8a 00                	mov    (%eax),%al
     e74:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
     e76:	ff 45 f8             	incl   -0x8(%ebp)
     e79:	8b 55 f8             	mov    -0x8(%ebp),%edx
     e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
     e7f:	01 d0                	add    %edx,%eax
     e81:	8a 00                	mov    (%eax),%al
     e83:	84 c0                	test   %al,%al
     e85:	75 d4                	jne    e5b <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
     e87:	8b 45 f8             	mov    -0x8(%ebp),%eax
     e8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
     e8d:	01 d0                	add    %edx,%eax
     e8f:	89 c2                	mov    %eax,%edx
     e91:	8b 45 08             	mov    0x8(%ebp),%eax
     e94:	01 d0                	add    %edx,%eax
     e96:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
     e99:	8b 45 08             	mov    0x8(%ebp),%eax
}
     e9c:	c9                   	leave  
     e9d:	c3                   	ret    

00000e9e <strstr>:

int 
strstr(char* s, char* sub)
{
     e9e:	55                   	push   %ebp
     e9f:	89 e5                	mov    %esp,%ebp
     ea1:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     ea4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     eab:	eb 7c                	jmp    f29 <strstr+0x8b>
    {
        if(s[i] == sub[0])
     ead:	8b 55 fc             	mov    -0x4(%ebp),%edx
     eb0:	8b 45 08             	mov    0x8(%ebp),%eax
     eb3:	01 d0                	add    %edx,%eax
     eb5:	8a 10                	mov    (%eax),%dl
     eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
     eba:	8a 00                	mov    (%eax),%al
     ebc:	38 c2                	cmp    %al,%dl
     ebe:	75 66                	jne    f26 <strstr+0x88>
        {
            if(strlen(sub) == 1)
     ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
     ec3:	89 04 24             	mov    %eax,(%esp)
     ec6:	e8 ee fe ff ff       	call   db9 <strlen>
     ecb:	83 f8 01             	cmp    $0x1,%eax
     ece:	75 05                	jne    ed5 <strstr+0x37>
            {  
                return i;
     ed0:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ed3:	eb 6b                	jmp    f40 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
     ed5:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
     edc:	eb 3a                	jmp    f18 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
     ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
     ee1:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ee4:	01 d0                	add    %edx,%eax
     ee6:	89 c2                	mov    %eax,%edx
     ee8:	8b 45 08             	mov    0x8(%ebp),%eax
     eeb:	01 d0                	add    %edx,%eax
     eed:	8a 10                	mov    (%eax),%dl
     eef:	8b 4d f8             	mov    -0x8(%ebp),%ecx
     ef2:	8b 45 0c             	mov    0xc(%ebp),%eax
     ef5:	01 c8                	add    %ecx,%eax
     ef7:	8a 00                	mov    (%eax),%al
     ef9:	38 c2                	cmp    %al,%dl
     efb:	75 16                	jne    f13 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
     efd:	8b 45 f8             	mov    -0x8(%ebp),%eax
     f00:	8d 50 01             	lea    0x1(%eax),%edx
     f03:	8b 45 0c             	mov    0xc(%ebp),%eax
     f06:	01 d0                	add    %edx,%eax
     f08:	8a 00                	mov    (%eax),%al
     f0a:	84 c0                	test   %al,%al
     f0c:	75 07                	jne    f15 <strstr+0x77>
                    {
                        return i;
     f0e:	8b 45 fc             	mov    -0x4(%ebp),%eax
     f11:	eb 2d                	jmp    f40 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
     f13:	eb 11                	jmp    f26 <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
     f15:	ff 45 f8             	incl   -0x8(%ebp)
     f18:	8b 55 f8             	mov    -0x8(%ebp),%edx
     f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f1e:	01 d0                	add    %edx,%eax
     f20:	8a 00                	mov    (%eax),%al
     f22:	84 c0                	test   %al,%al
     f24:	75 b8                	jne    ede <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
     f26:	ff 45 fc             	incl   -0x4(%ebp)
     f29:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f2c:	8b 45 08             	mov    0x8(%ebp),%eax
     f2f:	01 d0                	add    %edx,%eax
     f31:	8a 00                	mov    (%eax),%al
     f33:	84 c0                	test   %al,%al
     f35:	0f 85 72 ff ff ff    	jne    ead <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
     f3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
     f40:	c9                   	leave  
     f41:	c3                   	ret    

00000f42 <strtok>:

char *
strtok(char *s, const char *delim)
{
     f42:	55                   	push   %ebp
     f43:	89 e5                	mov    %esp,%ebp
     f45:	53                   	push   %ebx
     f46:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
     f49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f4d:	75 08                	jne    f57 <strtok+0x15>
  s = lasts;
     f4f:	a1 68 20 00 00       	mov    0x2068,%eax
     f54:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
     f57:	8b 45 08             	mov    0x8(%ebp),%eax
     f5a:	8d 50 01             	lea    0x1(%eax),%edx
     f5d:	89 55 08             	mov    %edx,0x8(%ebp)
     f60:	8a 00                	mov    (%eax),%al
     f62:	0f be d8             	movsbl %al,%ebx
     f65:	85 db                	test   %ebx,%ebx
     f67:	75 07                	jne    f70 <strtok+0x2e>
      return 0;
     f69:	b8 00 00 00 00       	mov    $0x0,%eax
     f6e:	eb 58                	jmp    fc8 <strtok+0x86>
    } while (strchr(delim, ch));
     f70:	88 d8                	mov    %bl,%al
     f72:	0f be c0             	movsbl %al,%eax
     f75:	89 44 24 04          	mov    %eax,0x4(%esp)
     f79:	8b 45 0c             	mov    0xc(%ebp),%eax
     f7c:	89 04 24             	mov    %eax,(%esp)
     f7f:	e8 7e fe ff ff       	call   e02 <strchr>
     f84:	85 c0                	test   %eax,%eax
     f86:	75 cf                	jne    f57 <strtok+0x15>
    --s;
     f88:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
     f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
     f92:	8b 45 08             	mov    0x8(%ebp),%eax
     f95:	89 04 24             	mov    %eax,(%esp)
     f98:	e8 31 00 00 00       	call   fce <strcspn>
     f9d:	89 c2                	mov    %eax,%edx
     f9f:	8b 45 08             	mov    0x8(%ebp),%eax
     fa2:	01 d0                	add    %edx,%eax
     fa4:	a3 68 20 00 00       	mov    %eax,0x2068
    if (*lasts != 0)
     fa9:	a1 68 20 00 00       	mov    0x2068,%eax
     fae:	8a 00                	mov    (%eax),%al
     fb0:	84 c0                	test   %al,%al
     fb2:	74 11                	je     fc5 <strtok+0x83>
  *lasts++ = 0;
     fb4:	a1 68 20 00 00       	mov    0x2068,%eax
     fb9:	8d 50 01             	lea    0x1(%eax),%edx
     fbc:	89 15 68 20 00 00    	mov    %edx,0x2068
     fc2:	c6 00 00             	movb   $0x0,(%eax)
    return s;
     fc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
     fc8:	83 c4 14             	add    $0x14,%esp
     fcb:	5b                   	pop    %ebx
     fcc:	5d                   	pop    %ebp
     fcd:	c3                   	ret    

00000fce <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
     fce:	55                   	push   %ebp
     fcf:	89 e5                	mov    %esp,%ebp
     fd1:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
     fd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
     fdb:	eb 26                	jmp    1003 <strcspn+0x35>
        if(strchr(s2,*s1))
     fdd:	8b 45 08             	mov    0x8(%ebp),%eax
     fe0:	8a 00                	mov    (%eax),%al
     fe2:	0f be c0             	movsbl %al,%eax
     fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
     fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
     fec:	89 04 24             	mov    %eax,(%esp)
     fef:	e8 0e fe ff ff       	call   e02 <strchr>
     ff4:	85 c0                	test   %eax,%eax
     ff6:	74 05                	je     ffd <strcspn+0x2f>
            return ret;
     ff8:	8b 45 fc             	mov    -0x4(%ebp),%eax
     ffb:	eb 12                	jmp    100f <strcspn+0x41>
        else
            s1++,ret++;
     ffd:	ff 45 08             	incl   0x8(%ebp)
    1000:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
    1003:	8b 45 08             	mov    0x8(%ebp),%eax
    1006:	8a 00                	mov    (%eax),%al
    1008:	84 c0                	test   %al,%al
    100a:	75 d1                	jne    fdd <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
    100c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    100f:	c9                   	leave  
    1010:	c3                   	ret    

00001011 <isspace>:

int
isspace(unsigned char c)
{
    1011:	55                   	push   %ebp
    1012:	89 e5                	mov    %esp,%ebp
    1014:	83 ec 04             	sub    $0x4,%esp
    1017:	8b 45 08             	mov    0x8(%ebp),%eax
    101a:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
    101d:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
    1021:	74 1e                	je     1041 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
    1023:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
    1027:	74 18                	je     1041 <isspace+0x30>
    1029:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
    102d:	74 12                	je     1041 <isspace+0x30>
    102f:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
    1033:	74 0c                	je     1041 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
    1035:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
    1039:	74 06                	je     1041 <isspace+0x30>
    103b:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
    103f:	75 07                	jne    1048 <isspace+0x37>
    1041:	b8 01 00 00 00       	mov    $0x1,%eax
    1046:	eb 05                	jmp    104d <isspace+0x3c>
    1048:	b8 00 00 00 00       	mov    $0x0,%eax
}
    104d:	c9                   	leave  
    104e:	c3                   	ret    

0000104f <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
    104f:	55                   	push   %ebp
    1050:	89 e5                	mov    %esp,%ebp
    1052:	57                   	push   %edi
    1053:	56                   	push   %esi
    1054:	53                   	push   %ebx
    1055:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
    1058:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
    105d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
    1064:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    1067:	eb 01                	jmp    106a <strtoul+0x1b>
  p += 1;
    1069:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    106a:	8a 03                	mov    (%ebx),%al
    106c:	0f b6 c0             	movzbl %al,%eax
    106f:	89 04 24             	mov    %eax,(%esp)
    1072:	e8 9a ff ff ff       	call   1011 <isspace>
    1077:	85 c0                	test   %eax,%eax
    1079:	75 ee                	jne    1069 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
    107b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    107f:	75 30                	jne    10b1 <strtoul+0x62>
    {
  if (*p == '0') {
    1081:	8a 03                	mov    (%ebx),%al
    1083:	3c 30                	cmp    $0x30,%al
    1085:	75 21                	jne    10a8 <strtoul+0x59>
      p += 1;
    1087:	43                   	inc    %ebx
      if (*p == 'x') {
    1088:	8a 03                	mov    (%ebx),%al
    108a:	3c 78                	cmp    $0x78,%al
    108c:	75 0a                	jne    1098 <strtoul+0x49>
    p += 1;
    108e:	43                   	inc    %ebx
    base = 16;
    108f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
    1096:	eb 31                	jmp    10c9 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
    1098:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
    109f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
    10a6:	eb 21                	jmp    10c9 <strtoul+0x7a>
      }
  }
  else base = 10;
    10a8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    10af:	eb 18                	jmp    10c9 <strtoul+0x7a>
    } else if (base == 16) {
    10b1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    10b5:	75 12                	jne    10c9 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
    10b7:	8a 03                	mov    (%ebx),%al
    10b9:	3c 30                	cmp    $0x30,%al
    10bb:	75 0c                	jne    10c9 <strtoul+0x7a>
    10bd:	8d 43 01             	lea    0x1(%ebx),%eax
    10c0:	8a 00                	mov    (%eax),%al
    10c2:	3c 78                	cmp    $0x78,%al
    10c4:	75 03                	jne    10c9 <strtoul+0x7a>
      p += 2;
    10c6:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
    10c9:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
    10cd:	75 29                	jne    10f8 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
    10cf:	8a 03                	mov    (%ebx),%al
    10d1:	0f be c0             	movsbl %al,%eax
    10d4:	83 e8 30             	sub    $0x30,%eax
    10d7:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
    10d9:	83 fe 07             	cmp    $0x7,%esi
    10dc:	76 06                	jbe    10e4 <strtoul+0x95>
    break;
    10de:	90                   	nop
    10df:	e9 b6 00 00 00       	jmp    119a <strtoul+0x14b>
      }
      result = (result << 3) + digit;
    10e4:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
    10eb:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    10ee:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
    10f5:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    10f6:	eb d7                	jmp    10cf <strtoul+0x80>
    } else if (base == 10) {
    10f8:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
    10fc:	75 2b                	jne    1129 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
    10fe:	8a 03                	mov    (%ebx),%al
    1100:	0f be c0             	movsbl %al,%eax
    1103:	83 e8 30             	sub    $0x30,%eax
    1106:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
    1108:	83 fe 09             	cmp    $0x9,%esi
    110b:	76 06                	jbe    1113 <strtoul+0xc4>
    break;
    110d:	90                   	nop
    110e:	e9 87 00 00 00       	jmp    119a <strtoul+0x14b>
      }
      result = (10*result) + digit;
    1113:	89 f8                	mov    %edi,%eax
    1115:	c1 e0 02             	shl    $0x2,%eax
    1118:	01 f8                	add    %edi,%eax
    111a:	01 c0                	add    %eax,%eax
    111c:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    111f:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
    1126:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    1127:	eb d5                	jmp    10fe <strtoul+0xaf>
    } else if (base == 16) {
    1129:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    112d:	75 35                	jne    1164 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
    112f:	8a 03                	mov    (%ebx),%al
    1131:	0f be c0             	movsbl %al,%eax
    1134:	83 e8 30             	sub    $0x30,%eax
    1137:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    1139:	83 fe 4a             	cmp    $0x4a,%esi
    113c:	76 02                	jbe    1140 <strtoul+0xf1>
    break;
    113e:	eb 22                	jmp    1162 <strtoul+0x113>
      }
      digit = cvtIn[digit];
    1140:	8a 86 a0 1f 00 00    	mov    0x1fa0(%esi),%al
    1146:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
    1149:	83 fe 0f             	cmp    $0xf,%esi
    114c:	76 02                	jbe    1150 <strtoul+0x101>
    break;
    114e:	eb 12                	jmp    1162 <strtoul+0x113>
      }
      result = (result << 4) + digit;
    1150:	89 f8                	mov    %edi,%eax
    1152:	c1 e0 04             	shl    $0x4,%eax
    1155:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1158:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
    115f:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    1160:	eb cd                	jmp    112f <strtoul+0xe0>
    1162:	eb 36                	jmp    119a <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
    1164:	8a 03                	mov    (%ebx),%al
    1166:	0f be c0             	movsbl %al,%eax
    1169:	83 e8 30             	sub    $0x30,%eax
    116c:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    116e:	83 fe 4a             	cmp    $0x4a,%esi
    1171:	76 02                	jbe    1175 <strtoul+0x126>
    break;
    1173:	eb 25                	jmp    119a <strtoul+0x14b>
      }
      digit = cvtIn[digit];
    1175:	8a 86 a0 1f 00 00    	mov    0x1fa0(%esi),%al
    117b:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
    117e:	8b 45 10             	mov    0x10(%ebp),%eax
    1181:	39 f0                	cmp    %esi,%eax
    1183:	77 02                	ja     1187 <strtoul+0x138>
    break;
    1185:	eb 13                	jmp    119a <strtoul+0x14b>
      }
      result = result*base + digit;
    1187:	8b 45 10             	mov    0x10(%ebp),%eax
    118a:	0f af c7             	imul   %edi,%eax
    118d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1190:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
    1197:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
    1198:	eb ca                	jmp    1164 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
    119a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    119e:	75 03                	jne    11a3 <strtoul+0x154>
  p = string;
    11a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
    11a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    11a7:	74 05                	je     11ae <strtoul+0x15f>
  *endPtr = p;
    11a9:	8b 45 0c             	mov    0xc(%ebp),%eax
    11ac:	89 18                	mov    %ebx,(%eax)
    }

    return result;
    11ae:	89 f8                	mov    %edi,%eax
}
    11b0:	83 c4 14             	add    $0x14,%esp
    11b3:	5b                   	pop    %ebx
    11b4:	5e                   	pop    %esi
    11b5:	5f                   	pop    %edi
    11b6:	5d                   	pop    %ebp
    11b7:	c3                   	ret    

000011b8 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
    11b8:	55                   	push   %ebp
    11b9:	89 e5                	mov    %esp,%ebp
    11bb:	53                   	push   %ebx
    11bc:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
    11bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    11c2:	eb 01                	jmp    11c5 <strtol+0xd>
      p += 1;
    11c4:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    11c5:	8a 03                	mov    (%ebx),%al
    11c7:	0f b6 c0             	movzbl %al,%eax
    11ca:	89 04 24             	mov    %eax,(%esp)
    11cd:	e8 3f fe ff ff       	call   1011 <isspace>
    11d2:	85 c0                	test   %eax,%eax
    11d4:	75 ee                	jne    11c4 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
    11d6:	8a 03                	mov    (%ebx),%al
    11d8:	3c 2d                	cmp    $0x2d,%al
    11da:	75 1e                	jne    11fa <strtol+0x42>
  p += 1;
    11dc:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
    11dd:	8b 45 10             	mov    0x10(%ebp),%eax
    11e0:	89 44 24 08          	mov    %eax,0x8(%esp)
    11e4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e7:	89 44 24 04          	mov    %eax,0x4(%esp)
    11eb:	89 1c 24             	mov    %ebx,(%esp)
    11ee:	e8 5c fe ff ff       	call   104f <strtoul>
    11f3:	f7 d8                	neg    %eax
    11f5:	89 45 f8             	mov    %eax,-0x8(%ebp)
    11f8:	eb 20                	jmp    121a <strtol+0x62>
    } else {
  if (*p == '+') {
    11fa:	8a 03                	mov    (%ebx),%al
    11fc:	3c 2b                	cmp    $0x2b,%al
    11fe:	75 01                	jne    1201 <strtol+0x49>
      p += 1;
    1200:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
    1201:	8b 45 10             	mov    0x10(%ebp),%eax
    1204:	89 44 24 08          	mov    %eax,0x8(%esp)
    1208:	8b 45 0c             	mov    0xc(%ebp),%eax
    120b:	89 44 24 04          	mov    %eax,0x4(%esp)
    120f:	89 1c 24             	mov    %ebx,(%esp)
    1212:	e8 38 fe ff ff       	call   104f <strtoul>
    1217:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
    121a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
    121e:	75 17                	jne    1237 <strtol+0x7f>
    1220:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1224:	74 11                	je     1237 <strtol+0x7f>
    1226:	8b 45 0c             	mov    0xc(%ebp),%eax
    1229:	8b 00                	mov    (%eax),%eax
    122b:	39 d8                	cmp    %ebx,%eax
    122d:	75 08                	jne    1237 <strtol+0x7f>
  *endPtr = string;
    122f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1232:	8b 55 08             	mov    0x8(%ebp),%edx
    1235:	89 10                	mov    %edx,(%eax)
    }
    return result;
    1237:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
    123a:	83 c4 1c             	add    $0x1c,%esp
    123d:	5b                   	pop    %ebx
    123e:	5d                   	pop    %ebp
    123f:	c3                   	ret    

00001240 <gets>:

char*
gets(char *buf, int max)
{
    1240:	55                   	push   %ebp
    1241:	89 e5                	mov    %esp,%ebp
    1243:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1246:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    124d:	eb 49                	jmp    1298 <gets+0x58>
    cc = read(0, &c, 1);
    124f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1256:	00 
    1257:	8d 45 ef             	lea    -0x11(%ebp),%eax
    125a:	89 44 24 04          	mov    %eax,0x4(%esp)
    125e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1265:	e8 3e 01 00 00       	call   13a8 <read>
    126a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    126d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1271:	7f 02                	jg     1275 <gets+0x35>
      break;
    1273:	eb 2c                	jmp    12a1 <gets+0x61>
    buf[i++] = c;
    1275:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1278:	8d 50 01             	lea    0x1(%eax),%edx
    127b:	89 55 f4             	mov    %edx,-0xc(%ebp)
    127e:	89 c2                	mov    %eax,%edx
    1280:	8b 45 08             	mov    0x8(%ebp),%eax
    1283:	01 c2                	add    %eax,%edx
    1285:	8a 45 ef             	mov    -0x11(%ebp),%al
    1288:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    128a:	8a 45 ef             	mov    -0x11(%ebp),%al
    128d:	3c 0a                	cmp    $0xa,%al
    128f:	74 10                	je     12a1 <gets+0x61>
    1291:	8a 45 ef             	mov    -0x11(%ebp),%al
    1294:	3c 0d                	cmp    $0xd,%al
    1296:	74 09                	je     12a1 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1298:	8b 45 f4             	mov    -0xc(%ebp),%eax
    129b:	40                   	inc    %eax
    129c:	3b 45 0c             	cmp    0xc(%ebp),%eax
    129f:	7c ae                	jl     124f <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    12a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    12a4:	8b 45 08             	mov    0x8(%ebp),%eax
    12a7:	01 d0                	add    %edx,%eax
    12a9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    12ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12af:	c9                   	leave  
    12b0:	c3                   	ret    

000012b1 <stat>:

int
stat(char *n, struct stat *st)
{
    12b1:	55                   	push   %ebp
    12b2:	89 e5                	mov    %esp,%ebp
    12b4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    12be:	00 
    12bf:	8b 45 08             	mov    0x8(%ebp),%eax
    12c2:	89 04 24             	mov    %eax,(%esp)
    12c5:	e8 06 01 00 00       	call   13d0 <open>
    12ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    12cd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12d1:	79 07                	jns    12da <stat+0x29>
    return -1;
    12d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    12d8:	eb 23                	jmp    12fd <stat+0x4c>
  r = fstat(fd, st);
    12da:	8b 45 0c             	mov    0xc(%ebp),%eax
    12dd:	89 44 24 04          	mov    %eax,0x4(%esp)
    12e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12e4:	89 04 24             	mov    %eax,(%esp)
    12e7:	e8 fc 00 00 00       	call   13e8 <fstat>
    12ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    12ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f2:	89 04 24             	mov    %eax,(%esp)
    12f5:	e8 be 00 00 00       	call   13b8 <close>
  return r;
    12fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    12fd:	c9                   	leave  
    12fe:	c3                   	ret    

000012ff <atoi>:

int
atoi(const char *s)
{
    12ff:	55                   	push   %ebp
    1300:	89 e5                	mov    %esp,%ebp
    1302:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    1305:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    130c:	eb 24                	jmp    1332 <atoi+0x33>
    n = n*10 + *s++ - '0';
    130e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1311:	89 d0                	mov    %edx,%eax
    1313:	c1 e0 02             	shl    $0x2,%eax
    1316:	01 d0                	add    %edx,%eax
    1318:	01 c0                	add    %eax,%eax
    131a:	89 c1                	mov    %eax,%ecx
    131c:	8b 45 08             	mov    0x8(%ebp),%eax
    131f:	8d 50 01             	lea    0x1(%eax),%edx
    1322:	89 55 08             	mov    %edx,0x8(%ebp)
    1325:	8a 00                	mov    (%eax),%al
    1327:	0f be c0             	movsbl %al,%eax
    132a:	01 c8                	add    %ecx,%eax
    132c:	83 e8 30             	sub    $0x30,%eax
    132f:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1332:	8b 45 08             	mov    0x8(%ebp),%eax
    1335:	8a 00                	mov    (%eax),%al
    1337:	3c 2f                	cmp    $0x2f,%al
    1339:	7e 09                	jle    1344 <atoi+0x45>
    133b:	8b 45 08             	mov    0x8(%ebp),%eax
    133e:	8a 00                	mov    (%eax),%al
    1340:	3c 39                	cmp    $0x39,%al
    1342:	7e ca                	jle    130e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1344:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1347:	c9                   	leave  
    1348:	c3                   	ret    

00001349 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1349:	55                   	push   %ebp
    134a:	89 e5                	mov    %esp,%ebp
    134c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    134f:	8b 45 08             	mov    0x8(%ebp),%eax
    1352:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1355:	8b 45 0c             	mov    0xc(%ebp),%eax
    1358:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    135b:	eb 16                	jmp    1373 <memmove+0x2a>
    *dst++ = *src++;
    135d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1360:	8d 50 01             	lea    0x1(%eax),%edx
    1363:	89 55 fc             	mov    %edx,-0x4(%ebp)
    1366:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1369:	8d 4a 01             	lea    0x1(%edx),%ecx
    136c:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    136f:	8a 12                	mov    (%edx),%dl
    1371:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1373:	8b 45 10             	mov    0x10(%ebp),%eax
    1376:	8d 50 ff             	lea    -0x1(%eax),%edx
    1379:	89 55 10             	mov    %edx,0x10(%ebp)
    137c:	85 c0                	test   %eax,%eax
    137e:	7f dd                	jg     135d <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1380:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1383:	c9                   	leave  
    1384:	c3                   	ret    
    1385:	90                   	nop
    1386:	90                   	nop
    1387:	90                   	nop

00001388 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1388:	b8 01 00 00 00       	mov    $0x1,%eax
    138d:	cd 40                	int    $0x40
    138f:	c3                   	ret    

00001390 <exit>:
SYSCALL(exit)
    1390:	b8 02 00 00 00       	mov    $0x2,%eax
    1395:	cd 40                	int    $0x40
    1397:	c3                   	ret    

00001398 <wait>:
SYSCALL(wait)
    1398:	b8 03 00 00 00       	mov    $0x3,%eax
    139d:	cd 40                	int    $0x40
    139f:	c3                   	ret    

000013a0 <pipe>:
SYSCALL(pipe)
    13a0:	b8 04 00 00 00       	mov    $0x4,%eax
    13a5:	cd 40                	int    $0x40
    13a7:	c3                   	ret    

000013a8 <read>:
SYSCALL(read)
    13a8:	b8 05 00 00 00       	mov    $0x5,%eax
    13ad:	cd 40                	int    $0x40
    13af:	c3                   	ret    

000013b0 <write>:
SYSCALL(write)
    13b0:	b8 10 00 00 00       	mov    $0x10,%eax
    13b5:	cd 40                	int    $0x40
    13b7:	c3                   	ret    

000013b8 <close>:
SYSCALL(close)
    13b8:	b8 15 00 00 00       	mov    $0x15,%eax
    13bd:	cd 40                	int    $0x40
    13bf:	c3                   	ret    

000013c0 <kill>:
SYSCALL(kill)
    13c0:	b8 06 00 00 00       	mov    $0x6,%eax
    13c5:	cd 40                	int    $0x40
    13c7:	c3                   	ret    

000013c8 <exec>:
SYSCALL(exec)
    13c8:	b8 07 00 00 00       	mov    $0x7,%eax
    13cd:	cd 40                	int    $0x40
    13cf:	c3                   	ret    

000013d0 <open>:
SYSCALL(open)
    13d0:	b8 0f 00 00 00       	mov    $0xf,%eax
    13d5:	cd 40                	int    $0x40
    13d7:	c3                   	ret    

000013d8 <mknod>:
SYSCALL(mknod)
    13d8:	b8 11 00 00 00       	mov    $0x11,%eax
    13dd:	cd 40                	int    $0x40
    13df:	c3                   	ret    

000013e0 <unlink>:
SYSCALL(unlink)
    13e0:	b8 12 00 00 00       	mov    $0x12,%eax
    13e5:	cd 40                	int    $0x40
    13e7:	c3                   	ret    

000013e8 <fstat>:
SYSCALL(fstat)
    13e8:	b8 08 00 00 00       	mov    $0x8,%eax
    13ed:	cd 40                	int    $0x40
    13ef:	c3                   	ret    

000013f0 <link>:
SYSCALL(link)
    13f0:	b8 13 00 00 00       	mov    $0x13,%eax
    13f5:	cd 40                	int    $0x40
    13f7:	c3                   	ret    

000013f8 <mkdir>:
SYSCALL(mkdir)
    13f8:	b8 14 00 00 00       	mov    $0x14,%eax
    13fd:	cd 40                	int    $0x40
    13ff:	c3                   	ret    

00001400 <chdir>:
SYSCALL(chdir)
    1400:	b8 09 00 00 00       	mov    $0x9,%eax
    1405:	cd 40                	int    $0x40
    1407:	c3                   	ret    

00001408 <dup>:
SYSCALL(dup)
    1408:	b8 0a 00 00 00       	mov    $0xa,%eax
    140d:	cd 40                	int    $0x40
    140f:	c3                   	ret    

00001410 <getpid>:
SYSCALL(getpid)
    1410:	b8 0b 00 00 00       	mov    $0xb,%eax
    1415:	cd 40                	int    $0x40
    1417:	c3                   	ret    

00001418 <sbrk>:
SYSCALL(sbrk)
    1418:	b8 0c 00 00 00       	mov    $0xc,%eax
    141d:	cd 40                	int    $0x40
    141f:	c3                   	ret    

00001420 <sleep>:
SYSCALL(sleep)
    1420:	b8 0d 00 00 00       	mov    $0xd,%eax
    1425:	cd 40                	int    $0x40
    1427:	c3                   	ret    

00001428 <uptime>:
SYSCALL(uptime)
    1428:	b8 0e 00 00 00       	mov    $0xe,%eax
    142d:	cd 40                	int    $0x40
    142f:	c3                   	ret    

00001430 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1430:	55                   	push   %ebp
    1431:	89 e5                	mov    %esp,%ebp
    1433:	83 ec 18             	sub    $0x18,%esp
    1436:	8b 45 0c             	mov    0xc(%ebp),%eax
    1439:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    143c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1443:	00 
    1444:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1447:	89 44 24 04          	mov    %eax,0x4(%esp)
    144b:	8b 45 08             	mov    0x8(%ebp),%eax
    144e:	89 04 24             	mov    %eax,(%esp)
    1451:	e8 5a ff ff ff       	call   13b0 <write>
}
    1456:	c9                   	leave  
    1457:	c3                   	ret    

00001458 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1458:	55                   	push   %ebp
    1459:	89 e5                	mov    %esp,%ebp
    145b:	56                   	push   %esi
    145c:	53                   	push   %ebx
    145d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1460:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1467:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    146b:	74 17                	je     1484 <printint+0x2c>
    146d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1471:	79 11                	jns    1484 <printint+0x2c>
    neg = 1;
    1473:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    147a:	8b 45 0c             	mov    0xc(%ebp),%eax
    147d:	f7 d8                	neg    %eax
    147f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1482:	eb 06                	jmp    148a <printint+0x32>
  } else {
    x = xx;
    1484:	8b 45 0c             	mov    0xc(%ebp),%eax
    1487:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    148a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1491:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1494:	8d 41 01             	lea    0x1(%ecx),%eax
    1497:	89 45 f4             	mov    %eax,-0xc(%ebp)
    149a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    149d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14a0:	ba 00 00 00 00       	mov    $0x0,%edx
    14a5:	f7 f3                	div    %ebx
    14a7:	89 d0                	mov    %edx,%eax
    14a9:	8a 80 ec 1f 00 00    	mov    0x1fec(%eax),%al
    14af:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    14b3:	8b 75 10             	mov    0x10(%ebp),%esi
    14b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    14b9:	ba 00 00 00 00       	mov    $0x0,%edx
    14be:	f7 f6                	div    %esi
    14c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    14c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    14c7:	75 c8                	jne    1491 <printint+0x39>
  if(neg)
    14c9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14cd:	74 10                	je     14df <printint+0x87>
    buf[i++] = '-';
    14cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d2:	8d 50 01             	lea    0x1(%eax),%edx
    14d5:	89 55 f4             	mov    %edx,-0xc(%ebp)
    14d8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    14dd:	eb 1e                	jmp    14fd <printint+0xa5>
    14df:	eb 1c                	jmp    14fd <printint+0xa5>
    putc(fd, buf[i]);
    14e1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    14e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14e7:	01 d0                	add    %edx,%eax
    14e9:	8a 00                	mov    (%eax),%al
    14eb:	0f be c0             	movsbl %al,%eax
    14ee:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f2:	8b 45 08             	mov    0x8(%ebp),%eax
    14f5:	89 04 24             	mov    %eax,(%esp)
    14f8:	e8 33 ff ff ff       	call   1430 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    14fd:	ff 4d f4             	decl   -0xc(%ebp)
    1500:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1504:	79 db                	jns    14e1 <printint+0x89>
    putc(fd, buf[i]);
}
    1506:	83 c4 30             	add    $0x30,%esp
    1509:	5b                   	pop    %ebx
    150a:	5e                   	pop    %esi
    150b:	5d                   	pop    %ebp
    150c:	c3                   	ret    

0000150d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    150d:	55                   	push   %ebp
    150e:	89 e5                	mov    %esp,%ebp
    1510:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1513:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    151a:	8d 45 0c             	lea    0xc(%ebp),%eax
    151d:	83 c0 04             	add    $0x4,%eax
    1520:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1523:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    152a:	e9 77 01 00 00       	jmp    16a6 <printf+0x199>
    c = fmt[i] & 0xff;
    152f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1532:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1535:	01 d0                	add    %edx,%eax
    1537:	8a 00                	mov    (%eax),%al
    1539:	0f be c0             	movsbl %al,%eax
    153c:	25 ff 00 00 00       	and    $0xff,%eax
    1541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1544:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1548:	75 2c                	jne    1576 <printf+0x69>
      if(c == '%'){
    154a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    154e:	75 0c                	jne    155c <printf+0x4f>
        state = '%';
    1550:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1557:	e9 47 01 00 00       	jmp    16a3 <printf+0x196>
      } else {
        putc(fd, c);
    155c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    155f:	0f be c0             	movsbl %al,%eax
    1562:	89 44 24 04          	mov    %eax,0x4(%esp)
    1566:	8b 45 08             	mov    0x8(%ebp),%eax
    1569:	89 04 24             	mov    %eax,(%esp)
    156c:	e8 bf fe ff ff       	call   1430 <putc>
    1571:	e9 2d 01 00 00       	jmp    16a3 <printf+0x196>
      }
    } else if(state == '%'){
    1576:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    157a:	0f 85 23 01 00 00    	jne    16a3 <printf+0x196>
      if(c == 'd'){
    1580:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1584:	75 2d                	jne    15b3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1586:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1589:	8b 00                	mov    (%eax),%eax
    158b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1592:	00 
    1593:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    159a:	00 
    159b:	89 44 24 04          	mov    %eax,0x4(%esp)
    159f:	8b 45 08             	mov    0x8(%ebp),%eax
    15a2:	89 04 24             	mov    %eax,(%esp)
    15a5:	e8 ae fe ff ff       	call   1458 <printint>
        ap++;
    15aa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15ae:	e9 e9 00 00 00       	jmp    169c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    15b3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    15b7:	74 06                	je     15bf <printf+0xb2>
    15b9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    15bd:	75 2d                	jne    15ec <printf+0xdf>
        printint(fd, *ap, 16, 0);
    15bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15c2:	8b 00                	mov    (%eax),%eax
    15c4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    15cb:	00 
    15cc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    15d3:	00 
    15d4:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d8:	8b 45 08             	mov    0x8(%ebp),%eax
    15db:	89 04 24             	mov    %eax,(%esp)
    15de:	e8 75 fe ff ff       	call   1458 <printint>
        ap++;
    15e3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    15e7:	e9 b0 00 00 00       	jmp    169c <printf+0x18f>
      } else if(c == 's'){
    15ec:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    15f0:	75 42                	jne    1634 <printf+0x127>
        s = (char*)*ap;
    15f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    15f5:	8b 00                	mov    (%eax),%eax
    15f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    15fa:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    15fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1602:	75 09                	jne    160d <printf+0x100>
          s = "(null)";
    1604:	c7 45 f4 c4 19 00 00 	movl   $0x19c4,-0xc(%ebp)
        while(*s != 0){
    160b:	eb 1c                	jmp    1629 <printf+0x11c>
    160d:	eb 1a                	jmp    1629 <printf+0x11c>
          putc(fd, *s);
    160f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1612:	8a 00                	mov    (%eax),%al
    1614:	0f be c0             	movsbl %al,%eax
    1617:	89 44 24 04          	mov    %eax,0x4(%esp)
    161b:	8b 45 08             	mov    0x8(%ebp),%eax
    161e:	89 04 24             	mov    %eax,(%esp)
    1621:	e8 0a fe ff ff       	call   1430 <putc>
          s++;
    1626:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1629:	8b 45 f4             	mov    -0xc(%ebp),%eax
    162c:	8a 00                	mov    (%eax),%al
    162e:	84 c0                	test   %al,%al
    1630:	75 dd                	jne    160f <printf+0x102>
    1632:	eb 68                	jmp    169c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1634:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1638:	75 1d                	jne    1657 <printf+0x14a>
        putc(fd, *ap);
    163a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    163d:	8b 00                	mov    (%eax),%eax
    163f:	0f be c0             	movsbl %al,%eax
    1642:	89 44 24 04          	mov    %eax,0x4(%esp)
    1646:	8b 45 08             	mov    0x8(%ebp),%eax
    1649:	89 04 24             	mov    %eax,(%esp)
    164c:	e8 df fd ff ff       	call   1430 <putc>
        ap++;
    1651:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1655:	eb 45                	jmp    169c <printf+0x18f>
      } else if(c == '%'){
    1657:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    165b:	75 17                	jne    1674 <printf+0x167>
        putc(fd, c);
    165d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1660:	0f be c0             	movsbl %al,%eax
    1663:	89 44 24 04          	mov    %eax,0x4(%esp)
    1667:	8b 45 08             	mov    0x8(%ebp),%eax
    166a:	89 04 24             	mov    %eax,(%esp)
    166d:	e8 be fd ff ff       	call   1430 <putc>
    1672:	eb 28                	jmp    169c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1674:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    167b:	00 
    167c:	8b 45 08             	mov    0x8(%ebp),%eax
    167f:	89 04 24             	mov    %eax,(%esp)
    1682:	e8 a9 fd ff ff       	call   1430 <putc>
        putc(fd, c);
    1687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    168a:	0f be c0             	movsbl %al,%eax
    168d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1691:	8b 45 08             	mov    0x8(%ebp),%eax
    1694:	89 04 24             	mov    %eax,(%esp)
    1697:	e8 94 fd ff ff       	call   1430 <putc>
      }
      state = 0;
    169c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    16a3:	ff 45 f0             	incl   -0x10(%ebp)
    16a6:	8b 55 0c             	mov    0xc(%ebp),%edx
    16a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    16ac:	01 d0                	add    %edx,%eax
    16ae:	8a 00                	mov    (%eax),%al
    16b0:	84 c0                	test   %al,%al
    16b2:	0f 85 77 fe ff ff    	jne    152f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    16b8:	c9                   	leave  
    16b9:	c3                   	ret    
    16ba:	90                   	nop
    16bb:	90                   	nop

000016bc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    16bc:	55                   	push   %ebp
    16bd:	89 e5                	mov    %esp,%ebp
    16bf:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    16c2:	8b 45 08             	mov    0x8(%ebp),%eax
    16c5:	83 e8 08             	sub    $0x8,%eax
    16c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16cb:	a1 74 20 00 00       	mov    0x2074,%eax
    16d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16d3:	eb 24                	jmp    16f9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    16d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d8:	8b 00                	mov    (%eax),%eax
    16da:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16dd:	77 12                	ja     16f1 <free+0x35>
    16df:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16e2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16e5:	77 24                	ja     170b <free+0x4f>
    16e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16ea:	8b 00                	mov    (%eax),%eax
    16ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    16ef:	77 1a                	ja     170b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    16f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16f4:	8b 00                	mov    (%eax),%eax
    16f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    16f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    16fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    16ff:	76 d4                	jbe    16d5 <free+0x19>
    1701:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1704:	8b 00                	mov    (%eax),%eax
    1706:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1709:	76 ca                	jbe    16d5 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    170b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    170e:	8b 40 04             	mov    0x4(%eax),%eax
    1711:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1718:	8b 45 f8             	mov    -0x8(%ebp),%eax
    171b:	01 c2                	add    %eax,%edx
    171d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1720:	8b 00                	mov    (%eax),%eax
    1722:	39 c2                	cmp    %eax,%edx
    1724:	75 24                	jne    174a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1726:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1729:	8b 50 04             	mov    0x4(%eax),%edx
    172c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    172f:	8b 00                	mov    (%eax),%eax
    1731:	8b 40 04             	mov    0x4(%eax),%eax
    1734:	01 c2                	add    %eax,%edx
    1736:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1739:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    173c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    173f:	8b 00                	mov    (%eax),%eax
    1741:	8b 10                	mov    (%eax),%edx
    1743:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1746:	89 10                	mov    %edx,(%eax)
    1748:	eb 0a                	jmp    1754 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    174d:	8b 10                	mov    (%eax),%edx
    174f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1752:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1754:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1757:	8b 40 04             	mov    0x4(%eax),%eax
    175a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1761:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1764:	01 d0                	add    %edx,%eax
    1766:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1769:	75 20                	jne    178b <free+0xcf>
    p->s.size += bp->s.size;
    176b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    176e:	8b 50 04             	mov    0x4(%eax),%edx
    1771:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1774:	8b 40 04             	mov    0x4(%eax),%eax
    1777:	01 c2                	add    %eax,%edx
    1779:	8b 45 fc             	mov    -0x4(%ebp),%eax
    177c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    177f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1782:	8b 10                	mov    (%eax),%edx
    1784:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1787:	89 10                	mov    %edx,(%eax)
    1789:	eb 08                	jmp    1793 <free+0xd7>
  } else
    p->s.ptr = bp;
    178b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    178e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1791:	89 10                	mov    %edx,(%eax)
  freep = p;
    1793:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1796:	a3 74 20 00 00       	mov    %eax,0x2074
}
    179b:	c9                   	leave  
    179c:	c3                   	ret    

0000179d <morecore>:

static Header*
morecore(uint nu)
{
    179d:	55                   	push   %ebp
    179e:	89 e5                	mov    %esp,%ebp
    17a0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    17a3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    17aa:	77 07                	ja     17b3 <morecore+0x16>
    nu = 4096;
    17ac:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    17b3:	8b 45 08             	mov    0x8(%ebp),%eax
    17b6:	c1 e0 03             	shl    $0x3,%eax
    17b9:	89 04 24             	mov    %eax,(%esp)
    17bc:	e8 57 fc ff ff       	call   1418 <sbrk>
    17c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    17c4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    17c8:	75 07                	jne    17d1 <morecore+0x34>
    return 0;
    17ca:	b8 00 00 00 00       	mov    $0x0,%eax
    17cf:	eb 22                	jmp    17f3 <morecore+0x56>
  hp = (Header*)p;
    17d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    17d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    17d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17da:	8b 55 08             	mov    0x8(%ebp),%edx
    17dd:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    17e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17e3:	83 c0 08             	add    $0x8,%eax
    17e6:	89 04 24             	mov    %eax,(%esp)
    17e9:	e8 ce fe ff ff       	call   16bc <free>
  return freep;
    17ee:	a1 74 20 00 00       	mov    0x2074,%eax
}
    17f3:	c9                   	leave  
    17f4:	c3                   	ret    

000017f5 <malloc>:

void*
malloc(uint nbytes)
{
    17f5:	55                   	push   %ebp
    17f6:	89 e5                	mov    %esp,%ebp
    17f8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17fb:	8b 45 08             	mov    0x8(%ebp),%eax
    17fe:	83 c0 07             	add    $0x7,%eax
    1801:	c1 e8 03             	shr    $0x3,%eax
    1804:	40                   	inc    %eax
    1805:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1808:	a1 74 20 00 00       	mov    0x2074,%eax
    180d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1810:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1814:	75 23                	jne    1839 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1816:	c7 45 f0 6c 20 00 00 	movl   $0x206c,-0x10(%ebp)
    181d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1820:	a3 74 20 00 00       	mov    %eax,0x2074
    1825:	a1 74 20 00 00       	mov    0x2074,%eax
    182a:	a3 6c 20 00 00       	mov    %eax,0x206c
    base.s.size = 0;
    182f:	c7 05 70 20 00 00 00 	movl   $0x0,0x2070
    1836:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1839:	8b 45 f0             	mov    -0x10(%ebp),%eax
    183c:	8b 00                	mov    (%eax),%eax
    183e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1841:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1844:	8b 40 04             	mov    0x4(%eax),%eax
    1847:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    184a:	72 4d                	jb     1899 <malloc+0xa4>
      if(p->s.size == nunits)
    184c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    184f:	8b 40 04             	mov    0x4(%eax),%eax
    1852:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1855:	75 0c                	jne    1863 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1857:	8b 45 f4             	mov    -0xc(%ebp),%eax
    185a:	8b 10                	mov    (%eax),%edx
    185c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    185f:	89 10                	mov    %edx,(%eax)
    1861:	eb 26                	jmp    1889 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1863:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1866:	8b 40 04             	mov    0x4(%eax),%eax
    1869:	2b 45 ec             	sub    -0x14(%ebp),%eax
    186c:	89 c2                	mov    %eax,%edx
    186e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1871:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1874:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1877:	8b 40 04             	mov    0x4(%eax),%eax
    187a:	c1 e0 03             	shl    $0x3,%eax
    187d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1880:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1883:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1886:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1889:	8b 45 f0             	mov    -0x10(%ebp),%eax
    188c:	a3 74 20 00 00       	mov    %eax,0x2074
      return (void*)(p + 1);
    1891:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1894:	83 c0 08             	add    $0x8,%eax
    1897:	eb 38                	jmp    18d1 <malloc+0xdc>
    }
    if(p == freep)
    1899:	a1 74 20 00 00       	mov    0x2074,%eax
    189e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    18a1:	75 1b                	jne    18be <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    18a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18a6:	89 04 24             	mov    %eax,(%esp)
    18a9:	e8 ef fe ff ff       	call   179d <morecore>
    18ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18b5:	75 07                	jne    18be <malloc+0xc9>
        return 0;
    18b7:	b8 00 00 00 00       	mov    $0x0,%eax
    18bc:	eb 13                	jmp    18d1 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    18c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18c7:	8b 00                	mov    (%eax),%eax
    18c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    18cc:	e9 70 ff ff ff       	jmp    1841 <malloc+0x4c>
}
    18d1:	c9                   	leave  
    18d2:	c3                   	ret    
