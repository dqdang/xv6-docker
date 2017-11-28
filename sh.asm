
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
       c:	e8 33 15 00 00       	call   1544 <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 5c 1b 00 00 	mov    0x1b5c(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 30 1b 00 00 	movl   $0x1b30,(%esp)
      2b:	e8 d3 03 00 00       	call   403 <panic>

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
      40:	e8 ff 14 00 00       	call   1544 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 1f 15 00 00       	call   157c <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 37 1b 00 	movl   $0x1b37,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 ee 16 00 00       	call   1769 <printf>
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
      8f:	e8 d8 14 00 00       	call   156c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 d8 14 00 00       	call   1584 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 47 1b 00 	movl   $0x1b47,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 9b 16 00 00       	call   1769 <printf>
      exit();
      ce:	e8 71 14 00 00       	call   1544 <exit>
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
      ec:	e8 38 03 00 00       	call   429 <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 44 14 00 00       	call   154c <wait>
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
     127:	e8 28 14 00 00       	call   1554 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 57 1b 00 00 	movl   $0x1b57,(%esp)
     137:	e8 c7 02 00 00       	call   403 <panic>
    if(fork1() == 0){
     13c:	e8 e8 02 00 00       	call   429 <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 1b 14 00 00       	call   156c <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 60 14 00 00       	call   15bc <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 05 14 00 00       	call   156c <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 fa 13 00 00       	call   156c <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 a4 02 00 00       	call   429 <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 d7 13 00 00       	call   156c <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 1c 14 00 00       	call   15bc <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 c1 13 00 00       	call   156c <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 b6 13 00 00       	call   156c <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 9d 13 00 00       	call   156c <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 92 13 00 00       	call   156c <close>
    wait();
     1da:	e8 6d 13 00 00       	call   154c <wait>
    wait();
     1df:	e8 68 13 00 00       	call   154c <wait>
    break;
     1e4:	eb 20                	jmp    206 <runcmd+0x206>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 38 02 00 00       	call   429 <fork1>
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
     206:	e8 39 13 00 00       	call   1544 <exit>

0000020b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     20b:	55                   	push   %ebp
     20c:	89 e5                	mov    %esp,%ebp
     20e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     211:	c7 44 24 04 74 1b 00 	movl   $0x1b74,0x4(%esp)
     218:	00 
     219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     220:	e8 44 15 00 00       	call   1769 <printf>
  memset(buf, 0, nbuf);
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	89 44 24 08          	mov    %eax,0x8(%esp)
     22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     233:	00 
     234:	8b 45 08             	mov    0x8(%ebp),%eax
     237:	89 04 24             	mov    %eax,(%esp)
     23a:	e8 53 0d 00 00       	call   f92 <memset>
  gets(buf, nbuf);
     23f:	8b 45 0c             	mov    0xc(%ebp),%eax
     242:	89 44 24 04          	mov    %eax,0x4(%esp)
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 a3 11 00 00       	call   13f4 <gets>
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
     26e:	83 ec 40             	sub    $0x40,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     271:	eb 15                	jmp    288 <main+0x20>
    if(fd >= 3){
     273:	83 7c 24 3c 02       	cmpl   $0x2,0x3c(%esp)
     278:	7e 0e                	jle    288 <main+0x20>
      close(fd);
     27a:	8b 44 24 3c          	mov    0x3c(%esp),%eax
     27e:	89 04 24             	mov    %eax,(%esp)
     281:	e8 e6 12 00 00       	call   156c <close>
      break;
     286:	eb 1f                	jmp    2a7 <main+0x3f>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     288:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     28f:	00 
     290:	c7 04 24 77 1b 00 00 	movl   $0x1b77,(%esp)
     297:	e8 e8 12 00 00       	call   1584 <open>
     29c:	89 44 24 3c          	mov    %eax,0x3c(%esp)
     2a0:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
     2a5:	79 cc                	jns    273 <main+0xb>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2a7:	e9 36 01 00 00       	jmp    3e2 <main+0x17a>
    char fs[32];
    int index = getactivefsindex();
     2ac:	e8 c3 13 00 00       	call   1674 <getactivefsindex>
     2b1:	89 44 24 38          	mov    %eax,0x38(%esp)
    getactivefs(fs);
     2b5:	8d 44 24 18          	lea    0x18(%esp),%eax
     2b9:	89 04 24             	mov    %eax,(%esp)
     2bc:	e8 93 13 00 00       	call   1654 <getactivefs>
    if((strcmp(buf, "/\n") == 0) || (buf[0] == 'c' && buf[1] == 'd' && buf[2] == 10) || ((strcmp("cd ..\n", buf) == 0) && getatroot(index))){
     2c1:	c7 44 24 04 7f 1b 00 	movl   $0x1b7f,0x4(%esp)
     2c8:	00 
     2c9:	c7 04 24 c0 22 00 00 	movl   $0x22c0,(%esp)
     2d0:	e8 12 0c 00 00       	call   ee7 <strcmp>
     2d5:	85 c0                	test   %eax,%eax
     2d7:	74 43                	je     31c <main+0xb4>
     2d9:	a0 c0 22 00 00       	mov    0x22c0,%al
     2de:	3c 63                	cmp    $0x63,%al
     2e0:	75 12                	jne    2f4 <main+0x8c>
     2e2:	a0 c1 22 00 00       	mov    0x22c1,%al
     2e7:	3c 64                	cmp    $0x64,%al
     2e9:	75 09                	jne    2f4 <main+0x8c>
     2eb:	a0 c2 22 00 00       	mov    0x22c2,%al
     2f0:	3c 0a                	cmp    $0xa,%al
     2f2:	74 28                	je     31c <main+0xb4>
     2f4:	c7 44 24 04 c0 22 00 	movl   $0x22c0,0x4(%esp)
     2fb:	00 
     2fc:	c7 04 24 82 1b 00 00 	movl   $0x1b82,(%esp)
     303:	e8 df 0b 00 00       	call   ee7 <strcmp>
     308:	85 c0                	test   %eax,%eax
     30a:	75 55                	jne    361 <main+0xf9>
     30c:	8b 44 24 38          	mov    0x38(%esp),%eax
     310:	89 04 24             	mov    %eax,(%esp)
     313:	e8 6c 13 00 00       	call   1684 <getatroot>
     318:	85 c0                	test   %eax,%eax
     31a:	74 45                	je     361 <main+0xf9>
      if(chdir(fs) < 0)
     31c:	8d 44 24 18          	lea    0x18(%esp),%eax
     320:	89 04 24             	mov    %eax,(%esp)
     323:	e8 8c 12 00 00       	call   15b4 <chdir>
     328:	85 c0                	test   %eax,%eax
     32a:	79 1c                	jns    348 <main+0xe0>
        printf(2, "cannot cd %s\n", fs);
     32c:	8d 44 24 18          	lea    0x18(%esp),%eax
     330:	89 44 24 08          	mov    %eax,0x8(%esp)
     334:	c7 44 24 04 89 1b 00 	movl   $0x1b89,0x4(%esp)
     33b:	00 
     33c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     343:	e8 21 14 00 00       	call   1769 <printf>
      setatroot(index, 1);
     348:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
     34f:	00 
     350:	8b 44 24 38          	mov    0x38(%esp),%eax
     354:	89 04 24             	mov    %eax,(%esp)
     357:	e8 20 13 00 00       	call   167c <setatroot>
      continue;
     35c:	e9 81 00 00 00       	jmp    3e2 <main+0x17a>
    }
    else if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     361:	a0 c0 22 00 00       	mov    0x22c0,%al
     366:	3c 63                	cmp    $0x63,%al
     368:	75 56                	jne    3c0 <main+0x158>
     36a:	a0 c1 22 00 00       	mov    0x22c1,%al
     36f:	3c 64                	cmp    $0x64,%al
     371:	75 4d                	jne    3c0 <main+0x158>
     373:	a0 c2 22 00 00       	mov    0x22c2,%al
     378:	3c 20                	cmp    $0x20,%al
     37a:	75 44                	jne    3c0 <main+0x158>

      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     37c:	c7 04 24 c0 22 00 00 	movl   $0x22c0,(%esp)
     383:	e8 e5 0b 00 00       	call   f6d <strlen>
     388:	48                   	dec    %eax
     389:	c6 80 c0 22 00 00 00 	movb   $0x0,0x22c0(%eax)

      if(chdir(buf+3) < 0)
     390:	c7 04 24 c3 22 00 00 	movl   $0x22c3,(%esp)
     397:	e8 18 12 00 00       	call   15b4 <chdir>
     39c:	85 c0                	test   %eax,%eax
     39e:	79 1e                	jns    3be <main+0x156>
        printf(2, "cannot cd %s\n", buf+3);
     3a0:	c7 44 24 08 c3 22 00 	movl   $0x22c3,0x8(%esp)
     3a7:	00 
     3a8:	c7 44 24 04 89 1b 00 	movl   $0x1b89,0x4(%esp)
     3af:	00 
     3b0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     3b7:	e8 ad 13 00 00       	call   1769 <printf>
        continue;
     3bc:	eb 24                	jmp    3e2 <main+0x17a>
     3be:	eb 22                	jmp    3e2 <main+0x17a>
      setatroot(index, 0);
      continue;
    }
    if(fork1() == 0)
     3c0:	e8 64 00 00 00       	call   429 <fork1>
     3c5:	85 c0                	test   %eax,%eax
     3c7:	75 14                	jne    3dd <main+0x175>
      runcmd(parsecmd(buf));
     3c9:	c7 04 24 c0 22 00 00 	movl   $0x22c0,(%esp)
     3d0:	e8 b8 03 00 00       	call   78d <parsecmd>
     3d5:	89 04 24             	mov    %eax,(%esp)
     3d8:	e8 23 fc ff ff       	call   0 <runcmd>
    wait();
     3dd:	e8 6a 11 00 00       	call   154c <wait>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     3e2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     3e9:	00 
     3ea:	c7 04 24 c0 22 00 00 	movl   $0x22c0,(%esp)
     3f1:	e8 15 fe ff ff       	call   20b <getcmd>
     3f6:	85 c0                	test   %eax,%eax
     3f8:	0f 89 ae fe ff ff    	jns    2ac <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     3fe:	e8 41 11 00 00       	call   1544 <exit>

00000403 <panic>:
}

void
panic(char *s)
{
     403:	55                   	push   %ebp
     404:	89 e5                	mov    %esp,%ebp
     406:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     409:	8b 45 08             	mov    0x8(%ebp),%eax
     40c:	89 44 24 08          	mov    %eax,0x8(%esp)
     410:	c7 44 24 04 97 1b 00 	movl   $0x1b97,0x4(%esp)
     417:	00 
     418:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     41f:	e8 45 13 00 00       	call   1769 <printf>
  exit();
     424:	e8 1b 11 00 00       	call   1544 <exit>

00000429 <fork1>:
}

int
fork1(void)
{
     429:	55                   	push   %ebp
     42a:	89 e5                	mov    %esp,%ebp
     42c:	83 ec 28             	sub    $0x28,%esp
  int pid;

  pid = fork();
     42f:	e8 08 11 00 00       	call   153c <fork>
     434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     437:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     43b:	75 0c                	jne    449 <fork1+0x20>
    panic("fork");
     43d:	c7 04 24 9b 1b 00 00 	movl   $0x1b9b,(%esp)
     444:	e8 ba ff ff ff       	call   403 <panic>
  return pid;
     449:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     44c:	c9                   	leave  
     44d:	c3                   	ret    

0000044e <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     44e:	55                   	push   %ebp
     44f:	89 e5                	mov    %esp,%ebp
     451:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     454:	c7 04 24 a4 00 00 00 	movl   $0xa4,(%esp)
     45b:	e8 f1 15 00 00       	call   1a51 <malloc>
     460:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     463:	c7 44 24 08 a4 00 00 	movl   $0xa4,0x8(%esp)
     46a:	00 
     46b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     472:	00 
     473:	8b 45 f4             	mov    -0xc(%ebp),%eax
     476:	89 04 24             	mov    %eax,(%esp)
     479:	e8 14 0b 00 00       	call   f92 <memset>
  cmd->type = EXEC;
     47e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     481:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     487:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     48a:	c9                   	leave  
     48b:	c3                   	ret    

0000048c <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     48c:	55                   	push   %ebp
     48d:	89 e5                	mov    %esp,%ebp
     48f:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     492:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     499:	e8 b3 15 00 00       	call   1a51 <malloc>
     49e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4a1:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     4a8:	00 
     4a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4b0:	00 
     4b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b4:	89 04 24             	mov    %eax,(%esp)
     4b7:	e8 d6 0a 00 00       	call   f92 <memset>
  cmd->type = REDIR;
     4bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4bf:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     4c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4c8:	8b 55 08             	mov    0x8(%ebp),%edx
     4cb:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     4ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4d1:	8b 55 0c             	mov    0xc(%ebp),%edx
     4d4:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     4d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4da:	8b 55 10             	mov    0x10(%ebp),%edx
     4dd:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     4e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e3:	8b 55 14             	mov    0x14(%ebp),%edx
     4e6:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     4e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4ec:	8b 55 18             	mov    0x18(%ebp),%edx
     4ef:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     4f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4f5:	c9                   	leave  
     4f6:	c3                   	ret    

000004f7 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     4f7:	55                   	push   %ebp
     4f8:	89 e5                	mov    %esp,%ebp
     4fa:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4fd:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     504:	e8 48 15 00 00       	call   1a51 <malloc>
     509:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     50c:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     513:	00 
     514:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     51b:	00 
     51c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51f:	89 04 24             	mov    %eax,(%esp)
     522:	e8 6b 0a 00 00       	call   f92 <memset>
  cmd->type = PIPE;
     527:	8b 45 f4             	mov    -0xc(%ebp),%eax
     52a:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     530:	8b 45 f4             	mov    -0xc(%ebp),%eax
     533:	8b 55 08             	mov    0x8(%ebp),%edx
     536:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     539:	8b 45 f4             	mov    -0xc(%ebp),%eax
     53c:	8b 55 0c             	mov    0xc(%ebp),%edx
     53f:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     542:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     545:	c9                   	leave  
     546:	c3                   	ret    

00000547 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     547:	55                   	push   %ebp
     548:	89 e5                	mov    %esp,%ebp
     54a:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     54d:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     554:	e8 f8 14 00 00       	call   1a51 <malloc>
     559:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     55c:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     563:	00 
     564:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     56b:	00 
     56c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56f:	89 04 24             	mov    %eax,(%esp)
     572:	e8 1b 0a 00 00       	call   f92 <memset>
  cmd->type = LIST;
     577:	8b 45 f4             	mov    -0xc(%ebp),%eax
     57a:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     580:	8b 45 f4             	mov    -0xc(%ebp),%eax
     583:	8b 55 08             	mov    0x8(%ebp),%edx
     586:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     589:	8b 45 f4             	mov    -0xc(%ebp),%eax
     58c:	8b 55 0c             	mov    0xc(%ebp),%edx
     58f:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     592:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     595:	c9                   	leave  
     596:	c3                   	ret    

00000597 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     597:	55                   	push   %ebp
     598:	89 e5                	mov    %esp,%ebp
     59a:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     59d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     5a4:	e8 a8 14 00 00       	call   1a51 <malloc>
     5a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     5ac:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     5b3:	00 
     5b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5bb:	00 
     5bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5bf:	89 04 24             	mov    %eax,(%esp)
     5c2:	e8 cb 09 00 00       	call   f92 <memset>
  cmd->type = BACK;
     5c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ca:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     5d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d3:	8b 55 08             	mov    0x8(%ebp),%edx
     5d6:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     5d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5dc:	c9                   	leave  
     5dd:	c3                   	ret    

000005de <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     5de:	55                   	push   %ebp
     5df:	89 e5                	mov    %esp,%ebp
     5e1:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;

  s = *ps;
     5e4:	8b 45 08             	mov    0x8(%ebp),%eax
     5e7:	8b 00                	mov    (%eax),%eax
     5e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     5ec:	eb 03                	jmp    5f1 <gettoken+0x13>
    s++;
     5ee:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     5f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f4:	3b 45 0c             	cmp    0xc(%ebp),%eax
     5f7:	73 1c                	jae    615 <gettoken+0x37>
     5f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fc:	8a 00                	mov    (%eax),%al
     5fe:	0f be c0             	movsbl %al,%eax
     601:	89 44 24 04          	mov    %eax,0x4(%esp)
     605:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
     60c:	e8 a5 09 00 00       	call   fb6 <strchr>
     611:	85 c0                	test   %eax,%eax
     613:	75 d9                	jne    5ee <gettoken+0x10>
    s++;
  if(q)
     615:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     619:	74 08                	je     623 <gettoken+0x45>
    *q = s;
     61b:	8b 45 10             	mov    0x10(%ebp),%eax
     61e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     621:	89 10                	mov    %edx,(%eax)
  ret = *s;
     623:	8b 45 f4             	mov    -0xc(%ebp),%eax
     626:	8a 00                	mov    (%eax),%al
     628:	0f be c0             	movsbl %al,%eax
     62b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     62e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     631:	8a 00                	mov    (%eax),%al
     633:	0f be c0             	movsbl %al,%eax
     636:	83 f8 29             	cmp    $0x29,%eax
     639:	7f 14                	jg     64f <gettoken+0x71>
     63b:	83 f8 28             	cmp    $0x28,%eax
     63e:	7d 28                	jge    668 <gettoken+0x8a>
     640:	85 c0                	test   %eax,%eax
     642:	0f 84 8d 00 00 00    	je     6d5 <gettoken+0xf7>
     648:	83 f8 26             	cmp    $0x26,%eax
     64b:	74 1b                	je     668 <gettoken+0x8a>
     64d:	eb 38                	jmp    687 <gettoken+0xa9>
     64f:	83 f8 3e             	cmp    $0x3e,%eax
     652:	74 19                	je     66d <gettoken+0x8f>
     654:	83 f8 3e             	cmp    $0x3e,%eax
     657:	7f 0a                	jg     663 <gettoken+0x85>
     659:	83 e8 3b             	sub    $0x3b,%eax
     65c:	83 f8 01             	cmp    $0x1,%eax
     65f:	77 26                	ja     687 <gettoken+0xa9>
     661:	eb 05                	jmp    668 <gettoken+0x8a>
     663:	83 f8 7c             	cmp    $0x7c,%eax
     666:	75 1f                	jne    687 <gettoken+0xa9>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     668:	ff 45 f4             	incl   -0xc(%ebp)
    break;
     66b:	eb 69                	jmp    6d6 <gettoken+0xf8>
  case '>':
    s++;
     66d:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
     670:	8b 45 f4             	mov    -0xc(%ebp),%eax
     673:	8a 00                	mov    (%eax),%al
     675:	3c 3e                	cmp    $0x3e,%al
     677:	75 0c                	jne    685 <gettoken+0xa7>
      ret = '+';
     679:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     680:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
     683:	eb 51                	jmp    6d6 <gettoken+0xf8>
     685:	eb 4f                	jmp    6d6 <gettoken+0xf8>
  default:
    ret = 'a';
     687:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     68e:	eb 03                	jmp    693 <gettoken+0xb5>
      s++;
     690:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     693:	8b 45 f4             	mov    -0xc(%ebp),%eax
     696:	3b 45 0c             	cmp    0xc(%ebp),%eax
     699:	73 38                	jae    6d3 <gettoken+0xf5>
     69b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     69e:	8a 00                	mov    (%eax),%al
     6a0:	0f be c0             	movsbl %al,%eax
     6a3:	89 44 24 04          	mov    %eax,0x4(%esp)
     6a7:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
     6ae:	e8 03 09 00 00       	call   fb6 <strchr>
     6b3:	85 c0                	test   %eax,%eax
     6b5:	75 1c                	jne    6d3 <gettoken+0xf5>
     6b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ba:	8a 00                	mov    (%eax),%al
     6bc:	0f be c0             	movsbl %al,%eax
     6bf:	89 44 24 04          	mov    %eax,0x4(%esp)
     6c3:	c7 04 24 46 22 00 00 	movl   $0x2246,(%esp)
     6ca:	e8 e7 08 00 00       	call   fb6 <strchr>
     6cf:	85 c0                	test   %eax,%eax
     6d1:	74 bd                	je     690 <gettoken+0xb2>
      s++;
    break;
     6d3:	eb 01                	jmp    6d6 <gettoken+0xf8>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     6d5:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     6d6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     6da:	74 0a                	je     6e6 <gettoken+0x108>
    *eq = s;
     6dc:	8b 45 14             	mov    0x14(%ebp),%eax
     6df:	8b 55 f4             	mov    -0xc(%ebp),%edx
     6e2:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     6e4:	eb 05                	jmp    6eb <gettoken+0x10d>
     6e6:	eb 03                	jmp    6eb <gettoken+0x10d>
    s++;
     6e8:	ff 45 f4             	incl   -0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     6eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ee:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6f1:	73 1c                	jae    70f <gettoken+0x131>
     6f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f6:	8a 00                	mov    (%eax),%al
     6f8:	0f be c0             	movsbl %al,%eax
     6fb:	89 44 24 04          	mov    %eax,0x4(%esp)
     6ff:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
     706:	e8 ab 08 00 00       	call   fb6 <strchr>
     70b:	85 c0                	test   %eax,%eax
     70d:	75 d9                	jne    6e8 <gettoken+0x10a>
    s++;
  *ps = s;
     70f:	8b 45 08             	mov    0x8(%ebp),%eax
     712:	8b 55 f4             	mov    -0xc(%ebp),%edx
     715:	89 10                	mov    %edx,(%eax)
  return ret;
     717:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     71a:	c9                   	leave  
     71b:	c3                   	ret    

0000071c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     71c:	55                   	push   %ebp
     71d:	89 e5                	mov    %esp,%ebp
     71f:	83 ec 28             	sub    $0x28,%esp
  char *s;

  s = *ps;
     722:	8b 45 08             	mov    0x8(%ebp),%eax
     725:	8b 00                	mov    (%eax),%eax
     727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     72a:	eb 03                	jmp    72f <peek+0x13>
    s++;
     72c:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     72f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     732:	3b 45 0c             	cmp    0xc(%ebp),%eax
     735:	73 1c                	jae    753 <peek+0x37>
     737:	8b 45 f4             	mov    -0xc(%ebp),%eax
     73a:	8a 00                	mov    (%eax),%al
     73c:	0f be c0             	movsbl %al,%eax
     73f:	89 44 24 04          	mov    %eax,0x4(%esp)
     743:	c7 04 24 40 22 00 00 	movl   $0x2240,(%esp)
     74a:	e8 67 08 00 00       	call   fb6 <strchr>
     74f:	85 c0                	test   %eax,%eax
     751:	75 d9                	jne    72c <peek+0x10>
    s++;
  *ps = s;
     753:	8b 45 08             	mov    0x8(%ebp),%eax
     756:	8b 55 f4             	mov    -0xc(%ebp),%edx
     759:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     75b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     75e:	8a 00                	mov    (%eax),%al
     760:	84 c0                	test   %al,%al
     762:	74 22                	je     786 <peek+0x6a>
     764:	8b 45 f4             	mov    -0xc(%ebp),%eax
     767:	8a 00                	mov    (%eax),%al
     769:	0f be c0             	movsbl %al,%eax
     76c:	89 44 24 04          	mov    %eax,0x4(%esp)
     770:	8b 45 10             	mov    0x10(%ebp),%eax
     773:	89 04 24             	mov    %eax,(%esp)
     776:	e8 3b 08 00 00       	call   fb6 <strchr>
     77b:	85 c0                	test   %eax,%eax
     77d:	74 07                	je     786 <peek+0x6a>
     77f:	b8 01 00 00 00       	mov    $0x1,%eax
     784:	eb 05                	jmp    78b <peek+0x6f>
     786:	b8 00 00 00 00       	mov    $0x0,%eax
}
     78b:	c9                   	leave  
     78c:	c3                   	ret    

0000078d <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     78d:	55                   	push   %ebp
     78e:	89 e5                	mov    %esp,%ebp
     790:	53                   	push   %ebx
     791:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     794:	8b 5d 08             	mov    0x8(%ebp),%ebx
     797:	8b 45 08             	mov    0x8(%ebp),%eax
     79a:	89 04 24             	mov    %eax,(%esp)
     79d:	e8 cb 07 00 00       	call   f6d <strlen>
     7a2:	01 d8                	add    %ebx,%eax
     7a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     7a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7aa:	89 44 24 04          	mov    %eax,0x4(%esp)
     7ae:	8d 45 08             	lea    0x8(%ebp),%eax
     7b1:	89 04 24             	mov    %eax,(%esp)
     7b4:	e8 60 00 00 00       	call   819 <parseline>
     7b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     7bc:	c7 44 24 08 a0 1b 00 	movl   $0x1ba0,0x8(%esp)
     7c3:	00 
     7c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c7:	89 44 24 04          	mov    %eax,0x4(%esp)
     7cb:	8d 45 08             	lea    0x8(%ebp),%eax
     7ce:	89 04 24             	mov    %eax,(%esp)
     7d1:	e8 46 ff ff ff       	call   71c <peek>
  if(s != es){
     7d6:	8b 45 08             	mov    0x8(%ebp),%eax
     7d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     7dc:	74 27                	je     805 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     7de:	8b 45 08             	mov    0x8(%ebp),%eax
     7e1:	89 44 24 08          	mov    %eax,0x8(%esp)
     7e5:	c7 44 24 04 a1 1b 00 	movl   $0x1ba1,0x4(%esp)
     7ec:	00 
     7ed:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     7f4:	e8 70 0f 00 00       	call   1769 <printf>
    panic("syntax");
     7f9:	c7 04 24 b0 1b 00 00 	movl   $0x1bb0,(%esp)
     800:	e8 fe fb ff ff       	call   403 <panic>
  }
  nulterminate(cmd);
     805:	8b 45 f0             	mov    -0x10(%ebp),%eax
     808:	89 04 24             	mov    %eax,(%esp)
     80b:	e8 a2 04 00 00       	call   cb2 <nulterminate>
  return cmd;
     810:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     813:	83 c4 24             	add    $0x24,%esp
     816:	5b                   	pop    %ebx
     817:	5d                   	pop    %ebp
     818:	c3                   	ret    

00000819 <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     819:	55                   	push   %ebp
     81a:	89 e5                	mov    %esp,%ebp
     81c:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     81f:	8b 45 0c             	mov    0xc(%ebp),%eax
     822:	89 44 24 04          	mov    %eax,0x4(%esp)
     826:	8b 45 08             	mov    0x8(%ebp),%eax
     829:	89 04 24             	mov    %eax,(%esp)
     82c:	e8 bc 00 00 00       	call   8ed <parsepipe>
     831:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     834:	eb 30                	jmp    866 <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     836:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     83d:	00 
     83e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     845:	00 
     846:	8b 45 0c             	mov    0xc(%ebp),%eax
     849:	89 44 24 04          	mov    %eax,0x4(%esp)
     84d:	8b 45 08             	mov    0x8(%ebp),%eax
     850:	89 04 24             	mov    %eax,(%esp)
     853:	e8 86 fd ff ff       	call   5de <gettoken>
    cmd = backcmd(cmd);
     858:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85b:	89 04 24             	mov    %eax,(%esp)
     85e:	e8 34 fd ff ff       	call   597 <backcmd>
     863:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     866:	c7 44 24 08 b7 1b 00 	movl   $0x1bb7,0x8(%esp)
     86d:	00 
     86e:	8b 45 0c             	mov    0xc(%ebp),%eax
     871:	89 44 24 04          	mov    %eax,0x4(%esp)
     875:	8b 45 08             	mov    0x8(%ebp),%eax
     878:	89 04 24             	mov    %eax,(%esp)
     87b:	e8 9c fe ff ff       	call   71c <peek>
     880:	85 c0                	test   %eax,%eax
     882:	75 b2                	jne    836 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     884:	c7 44 24 08 b9 1b 00 	movl   $0x1bb9,0x8(%esp)
     88b:	00 
     88c:	8b 45 0c             	mov    0xc(%ebp),%eax
     88f:	89 44 24 04          	mov    %eax,0x4(%esp)
     893:	8b 45 08             	mov    0x8(%ebp),%eax
     896:	89 04 24             	mov    %eax,(%esp)
     899:	e8 7e fe ff ff       	call   71c <peek>
     89e:	85 c0                	test   %eax,%eax
     8a0:	74 46                	je     8e8 <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     8a2:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8a9:	00 
     8aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8b1:	00 
     8b2:	8b 45 0c             	mov    0xc(%ebp),%eax
     8b5:	89 44 24 04          	mov    %eax,0x4(%esp)
     8b9:	8b 45 08             	mov    0x8(%ebp),%eax
     8bc:	89 04 24             	mov    %eax,(%esp)
     8bf:	e8 1a fd ff ff       	call   5de <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8c4:	8b 45 0c             	mov    0xc(%ebp),%eax
     8c7:	89 44 24 04          	mov    %eax,0x4(%esp)
     8cb:	8b 45 08             	mov    0x8(%ebp),%eax
     8ce:	89 04 24             	mov    %eax,(%esp)
     8d1:	e8 43 ff ff ff       	call   819 <parseline>
     8d6:	89 44 24 04          	mov    %eax,0x4(%esp)
     8da:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8dd:	89 04 24             	mov    %eax,(%esp)
     8e0:	e8 62 fc ff ff       	call   547 <listcmd>
     8e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     8eb:	c9                   	leave  
     8ec:	c3                   	ret    

000008ed <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     8ed:	55                   	push   %ebp
     8ee:	89 e5                	mov    %esp,%ebp
     8f0:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     8f3:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f6:	89 44 24 04          	mov    %eax,0x4(%esp)
     8fa:	8b 45 08             	mov    0x8(%ebp),%eax
     8fd:	89 04 24             	mov    %eax,(%esp)
     900:	e8 68 02 00 00       	call   b6d <parseexec>
     905:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     908:	c7 44 24 08 bb 1b 00 	movl   $0x1bbb,0x8(%esp)
     90f:	00 
     910:	8b 45 0c             	mov    0xc(%ebp),%eax
     913:	89 44 24 04          	mov    %eax,0x4(%esp)
     917:	8b 45 08             	mov    0x8(%ebp),%eax
     91a:	89 04 24             	mov    %eax,(%esp)
     91d:	e8 fa fd ff ff       	call   71c <peek>
     922:	85 c0                	test   %eax,%eax
     924:	74 46                	je     96c <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     926:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     92d:	00 
     92e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     935:	00 
     936:	8b 45 0c             	mov    0xc(%ebp),%eax
     939:	89 44 24 04          	mov    %eax,0x4(%esp)
     93d:	8b 45 08             	mov    0x8(%ebp),%eax
     940:	89 04 24             	mov    %eax,(%esp)
     943:	e8 96 fc ff ff       	call   5de <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     948:	8b 45 0c             	mov    0xc(%ebp),%eax
     94b:	89 44 24 04          	mov    %eax,0x4(%esp)
     94f:	8b 45 08             	mov    0x8(%ebp),%eax
     952:	89 04 24             	mov    %eax,(%esp)
     955:	e8 93 ff ff ff       	call   8ed <parsepipe>
     95a:	89 44 24 04          	mov    %eax,0x4(%esp)
     95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     961:	89 04 24             	mov    %eax,(%esp)
     964:	e8 8e fb ff ff       	call   4f7 <pipecmd>
     969:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     96c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     96f:	c9                   	leave  
     970:	c3                   	ret    

00000971 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     971:	55                   	push   %ebp
     972:	89 e5                	mov    %esp,%ebp
     974:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     977:	e9 f6 00 00 00       	jmp    a72 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     97c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     983:	00 
     984:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     98b:	00 
     98c:	8b 45 10             	mov    0x10(%ebp),%eax
     98f:	89 44 24 04          	mov    %eax,0x4(%esp)
     993:	8b 45 0c             	mov    0xc(%ebp),%eax
     996:	89 04 24             	mov    %eax,(%esp)
     999:	e8 40 fc ff ff       	call   5de <gettoken>
     99e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     9a1:	8d 45 ec             	lea    -0x14(%ebp),%eax
     9a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
     9a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
     9ab:	89 44 24 08          	mov    %eax,0x8(%esp)
     9af:	8b 45 10             	mov    0x10(%ebp),%eax
     9b2:	89 44 24 04          	mov    %eax,0x4(%esp)
     9b6:	8b 45 0c             	mov    0xc(%ebp),%eax
     9b9:	89 04 24             	mov    %eax,(%esp)
     9bc:	e8 1d fc ff ff       	call   5de <gettoken>
     9c1:	83 f8 61             	cmp    $0x61,%eax
     9c4:	74 0c                	je     9d2 <parseredirs+0x61>
      panic("missing file for redirection");
     9c6:	c7 04 24 bd 1b 00 00 	movl   $0x1bbd,(%esp)
     9cd:	e8 31 fa ff ff       	call   403 <panic>
    switch(tok){
     9d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9d5:	83 f8 3c             	cmp    $0x3c,%eax
     9d8:	74 0f                	je     9e9 <parseredirs+0x78>
     9da:	83 f8 3e             	cmp    $0x3e,%eax
     9dd:	74 38                	je     a17 <parseredirs+0xa6>
     9df:	83 f8 2b             	cmp    $0x2b,%eax
     9e2:	74 61                	je     a45 <parseredirs+0xd4>
     9e4:	e9 89 00 00 00       	jmp    a72 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     9e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
     9ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ef:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     9f6:	00 
     9f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     9fe:	00 
     9ff:	89 54 24 08          	mov    %edx,0x8(%esp)
     a03:	89 44 24 04          	mov    %eax,0x4(%esp)
     a07:	8b 45 08             	mov    0x8(%ebp),%eax
     a0a:	89 04 24             	mov    %eax,(%esp)
     a0d:	e8 7a fa ff ff       	call   48c <redircmd>
     a12:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a15:	eb 5b                	jmp    a72 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a17:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a1d:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     a24:	00 
     a25:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     a2c:	00 
     a2d:	89 54 24 08          	mov    %edx,0x8(%esp)
     a31:	89 44 24 04          	mov    %eax,0x4(%esp)
     a35:	8b 45 08             	mov    0x8(%ebp),%eax
     a38:	89 04 24             	mov    %eax,(%esp)
     a3b:	e8 4c fa ff ff       	call   48c <redircmd>
     a40:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a43:	eb 2d                	jmp    a72 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a45:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a48:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a4b:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     a52:	00 
     a53:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     a5a:	00 
     a5b:	89 54 24 08          	mov    %edx,0x8(%esp)
     a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a63:	8b 45 08             	mov    0x8(%ebp),%eax
     a66:	89 04 24             	mov    %eax,(%esp)
     a69:	e8 1e fa ff ff       	call   48c <redircmd>
     a6e:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a71:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     a72:	c7 44 24 08 da 1b 00 	movl   $0x1bda,0x8(%esp)
     a79:	00 
     a7a:	8b 45 10             	mov    0x10(%ebp),%eax
     a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
     a81:	8b 45 0c             	mov    0xc(%ebp),%eax
     a84:	89 04 24             	mov    %eax,(%esp)
     a87:	e8 90 fc ff ff       	call   71c <peek>
     a8c:	85 c0                	test   %eax,%eax
     a8e:	0f 85 e8 fe ff ff    	jne    97c <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     a94:	8b 45 08             	mov    0x8(%ebp),%eax
}
     a97:	c9                   	leave  
     a98:	c3                   	ret    

00000a99 <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     a99:	55                   	push   %ebp
     a9a:	89 e5                	mov    %esp,%ebp
     a9c:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     a9f:	c7 44 24 08 dd 1b 00 	movl   $0x1bdd,0x8(%esp)
     aa6:	00 
     aa7:	8b 45 0c             	mov    0xc(%ebp),%eax
     aaa:	89 44 24 04          	mov    %eax,0x4(%esp)
     aae:	8b 45 08             	mov    0x8(%ebp),%eax
     ab1:	89 04 24             	mov    %eax,(%esp)
     ab4:	e8 63 fc ff ff       	call   71c <peek>
     ab9:	85 c0                	test   %eax,%eax
     abb:	75 0c                	jne    ac9 <parseblock+0x30>
    panic("parseblock");
     abd:	c7 04 24 df 1b 00 00 	movl   $0x1bdf,(%esp)
     ac4:	e8 3a f9 ff ff       	call   403 <panic>
  gettoken(ps, es, 0, 0);
     ac9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ad0:	00 
     ad1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     ad8:	00 
     ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
     adc:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae0:	8b 45 08             	mov    0x8(%ebp),%eax
     ae3:	89 04 24             	mov    %eax,(%esp)
     ae6:	e8 f3 fa ff ff       	call   5de <gettoken>
  cmd = parseline(ps, es);
     aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
     aee:	89 44 24 04          	mov    %eax,0x4(%esp)
     af2:	8b 45 08             	mov    0x8(%ebp),%eax
     af5:	89 04 24             	mov    %eax,(%esp)
     af8:	e8 1c fd ff ff       	call   819 <parseline>
     afd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     b00:	c7 44 24 08 ea 1b 00 	movl   $0x1bea,0x8(%esp)
     b07:	00 
     b08:	8b 45 0c             	mov    0xc(%ebp),%eax
     b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
     b0f:	8b 45 08             	mov    0x8(%ebp),%eax
     b12:	89 04 24             	mov    %eax,(%esp)
     b15:	e8 02 fc ff ff       	call   71c <peek>
     b1a:	85 c0                	test   %eax,%eax
     b1c:	75 0c                	jne    b2a <parseblock+0x91>
    panic("syntax - missing )");
     b1e:	c7 04 24 ec 1b 00 00 	movl   $0x1bec,(%esp)
     b25:	e8 d9 f8 ff ff       	call   403 <panic>
  gettoken(ps, es, 0, 0);
     b2a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b31:	00 
     b32:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b39:	00 
     b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
     b41:	8b 45 08             	mov    0x8(%ebp),%eax
     b44:	89 04 24             	mov    %eax,(%esp)
     b47:	e8 92 fa ff ff       	call   5de <gettoken>
  cmd = parseredirs(cmd, ps, es);
     b4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     b4f:	89 44 24 08          	mov    %eax,0x8(%esp)
     b53:	8b 45 08             	mov    0x8(%ebp),%eax
     b56:	89 44 24 04          	mov    %eax,0x4(%esp)
     b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b5d:	89 04 24             	mov    %eax,(%esp)
     b60:	e8 0c fe ff ff       	call   971 <parseredirs>
     b65:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b6b:	c9                   	leave  
     b6c:	c3                   	ret    

00000b6d <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     b6d:	55                   	push   %ebp
     b6e:	89 e5                	mov    %esp,%ebp
     b70:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     b73:	c7 44 24 08 dd 1b 00 	movl   $0x1bdd,0x8(%esp)
     b7a:	00 
     b7b:	8b 45 0c             	mov    0xc(%ebp),%eax
     b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
     b82:	8b 45 08             	mov    0x8(%ebp),%eax
     b85:	89 04 24             	mov    %eax,(%esp)
     b88:	e8 8f fb ff ff       	call   71c <peek>
     b8d:	85 c0                	test   %eax,%eax
     b8f:	74 17                	je     ba8 <parseexec+0x3b>
    return parseblock(ps, es);
     b91:	8b 45 0c             	mov    0xc(%ebp),%eax
     b94:	89 44 24 04          	mov    %eax,0x4(%esp)
     b98:	8b 45 08             	mov    0x8(%ebp),%eax
     b9b:	89 04 24             	mov    %eax,(%esp)
     b9e:	e8 f6 fe ff ff       	call   a99 <parseblock>
     ba3:	e9 08 01 00 00       	jmp    cb0 <parseexec+0x143>

  ret = execcmd();
     ba8:	e8 a1 f8 ff ff       	call   44e <execcmd>
     bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bb3:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     bb6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     bbd:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc0:	89 44 24 08          	mov    %eax,0x8(%esp)
     bc4:	8b 45 08             	mov    0x8(%ebp),%eax
     bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
     bcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bce:	89 04 24             	mov    %eax,(%esp)
     bd1:	e8 9b fd ff ff       	call   971 <parseredirs>
     bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     bd9:	e9 8e 00 00 00       	jmp    c6c <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     bde:	8d 45 e0             	lea    -0x20(%ebp),%eax
     be1:	89 44 24 0c          	mov    %eax,0xc(%esp)
     be5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     be8:	89 44 24 08          	mov    %eax,0x8(%esp)
     bec:	8b 45 0c             	mov    0xc(%ebp),%eax
     bef:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf3:	8b 45 08             	mov    0x8(%ebp),%eax
     bf6:	89 04 24             	mov    %eax,(%esp)
     bf9:	e8 e0 f9 ff ff       	call   5de <gettoken>
     bfe:	89 45 e8             	mov    %eax,-0x18(%ebp)
     c01:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c05:	75 05                	jne    c0c <parseexec+0x9f>
      break;
     c07:	e9 82 00 00 00       	jmp    c8e <parseexec+0x121>
    if(tok != 'a')
     c0c:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     c10:	74 0c                	je     c1e <parseexec+0xb1>
      panic("syntax");
     c12:	c7 04 24 b0 1b 00 00 	movl   $0x1bb0,(%esp)
     c19:	e8 e5 f7 ff ff       	call   403 <panic>
    cmd->argv[argc] = q;
     c1e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     c21:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c24:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c27:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     c2b:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c31:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     c34:	83 c1 14             	add    $0x14,%ecx
     c37:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    argc++;
     c3b:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     c3e:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     c42:	7e 0c                	jle    c50 <parseexec+0xe3>
      panic("too many args");
     c44:	c7 04 24 ff 1b 00 00 	movl   $0x1bff,(%esp)
     c4b:	e8 b3 f7 ff ff       	call   403 <panic>
    ret = parseredirs(ret, ps, es);
     c50:	8b 45 0c             	mov    0xc(%ebp),%eax
     c53:	89 44 24 08          	mov    %eax,0x8(%esp)
     c57:	8b 45 08             	mov    0x8(%ebp),%eax
     c5a:	89 44 24 04          	mov    %eax,0x4(%esp)
     c5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c61:	89 04 24             	mov    %eax,(%esp)
     c64:	e8 08 fd ff ff       	call   971 <parseredirs>
     c69:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     c6c:	c7 44 24 08 0d 1c 00 	movl   $0x1c0d,0x8(%esp)
     c73:	00 
     c74:	8b 45 0c             	mov    0xc(%ebp),%eax
     c77:	89 44 24 04          	mov    %eax,0x4(%esp)
     c7b:	8b 45 08             	mov    0x8(%ebp),%eax
     c7e:	89 04 24             	mov    %eax,(%esp)
     c81:	e8 96 fa ff ff       	call   71c <peek>
     c86:	85 c0                	test   %eax,%eax
     c88:	0f 84 50 ff ff ff    	je     bde <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     c8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c91:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c94:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     c9b:	00 
  cmd->eargv[argc] = 0;
     c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ca2:	83 c2 14             	add    $0x14,%edx
     ca5:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     cac:	00 
  return ret;
     cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cb0:	c9                   	leave  
     cb1:	c3                   	ret    

00000cb2 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     cb2:	55                   	push   %ebp
     cb3:	89 e5                	mov    %esp,%ebp
     cb5:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     cb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     cbc:	75 0a                	jne    cc8 <nulterminate+0x16>
    return 0;
     cbe:	b8 00 00 00 00       	mov    $0x0,%eax
     cc3:	e9 c8 00 00 00       	jmp    d90 <nulterminate+0xde>

  switch(cmd->type){
     cc8:	8b 45 08             	mov    0x8(%ebp),%eax
     ccb:	8b 00                	mov    (%eax),%eax
     ccd:	83 f8 05             	cmp    $0x5,%eax
     cd0:	0f 87 b7 00 00 00    	ja     d8d <nulterminate+0xdb>
     cd6:	8b 04 85 14 1c 00 00 	mov    0x1c14(,%eax,4),%eax
     cdd:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     cdf:	8b 45 08             	mov    0x8(%ebp),%eax
     ce2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     ce5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     cec:	eb 13                	jmp    d01 <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
     cee:	8b 45 f0             	mov    -0x10(%ebp),%eax
     cf1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cf4:	83 c2 14             	add    $0x14,%edx
     cf7:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     cfb:	c6 00 00             	movb   $0x0,(%eax)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     cfe:	ff 45 f4             	incl   -0xc(%ebp)
     d01:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d04:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d07:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     d0b:	85 c0                	test   %eax,%eax
     d0d:	75 df                	jne    cee <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     d0f:	eb 7c                	jmp    d8d <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     d11:	8b 45 08             	mov    0x8(%ebp),%eax
     d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d1a:	8b 40 04             	mov    0x4(%eax),%eax
     d1d:	89 04 24             	mov    %eax,(%esp)
     d20:	e8 8d ff ff ff       	call   cb2 <nulterminate>
    *rcmd->efile = 0;
     d25:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d28:	8b 40 0c             	mov    0xc(%eax),%eax
     d2b:	c6 00 00             	movb   $0x0,(%eax)
    break;
     d2e:	eb 5d                	jmp    d8d <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     d30:	8b 45 08             	mov    0x8(%ebp),%eax
     d33:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     d36:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d39:	8b 40 04             	mov    0x4(%eax),%eax
     d3c:	89 04 24             	mov    %eax,(%esp)
     d3f:	e8 6e ff ff ff       	call   cb2 <nulterminate>
    nulterminate(pcmd->right);
     d44:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d47:	8b 40 08             	mov    0x8(%eax),%eax
     d4a:	89 04 24             	mov    %eax,(%esp)
     d4d:	e8 60 ff ff ff       	call   cb2 <nulterminate>
    break;
     d52:	eb 39                	jmp    d8d <nulterminate+0xdb>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     d54:	8b 45 08             	mov    0x8(%ebp),%eax
     d57:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     d5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d5d:	8b 40 04             	mov    0x4(%eax),%eax
     d60:	89 04 24             	mov    %eax,(%esp)
     d63:	e8 4a ff ff ff       	call   cb2 <nulterminate>
    nulterminate(lcmd->right);
     d68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d6b:	8b 40 08             	mov    0x8(%eax),%eax
     d6e:	89 04 24             	mov    %eax,(%esp)
     d71:	e8 3c ff ff ff       	call   cb2 <nulterminate>
    break;
     d76:	eb 15                	jmp    d8d <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     d78:	8b 45 08             	mov    0x8(%ebp),%eax
     d7b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     d7e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     d81:	8b 40 04             	mov    0x4(%eax),%eax
     d84:	89 04 24             	mov    %eax,(%esp)
     d87:	e8 26 ff ff ff       	call   cb2 <nulterminate>
    break;
     d8c:	90                   	nop
  }
  return cmd;
     d8d:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d90:	c9                   	leave  
     d91:	c3                   	ret    
     d92:	90                   	nop
     d93:	90                   	nop

00000d94 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     d94:	55                   	push   %ebp
     d95:	89 e5                	mov    %esp,%ebp
     d97:	57                   	push   %edi
     d98:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     d99:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d9c:	8b 55 10             	mov    0x10(%ebp),%edx
     d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     da2:	89 cb                	mov    %ecx,%ebx
     da4:	89 df                	mov    %ebx,%edi
     da6:	89 d1                	mov    %edx,%ecx
     da8:	fc                   	cld    
     da9:	f3 aa                	rep stos %al,%es:(%edi)
     dab:	89 ca                	mov    %ecx,%edx
     dad:	89 fb                	mov    %edi,%ebx
     daf:	89 5d 08             	mov    %ebx,0x8(%ebp)
     db2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     db5:	5b                   	pop    %ebx
     db6:	5f                   	pop    %edi
     db7:	5d                   	pop    %ebp
     db8:	c3                   	ret    

00000db9 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     db9:	55                   	push   %ebp
     dba:	89 e5                	mov    %esp,%ebp
     dbc:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     dbf:	8b 45 08             	mov    0x8(%ebp),%eax
     dc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     dc5:	90                   	nop
     dc6:	8b 45 08             	mov    0x8(%ebp),%eax
     dc9:	8d 50 01             	lea    0x1(%eax),%edx
     dcc:	89 55 08             	mov    %edx,0x8(%ebp)
     dcf:	8b 55 0c             	mov    0xc(%ebp),%edx
     dd2:	8d 4a 01             	lea    0x1(%edx),%ecx
     dd5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     dd8:	8a 12                	mov    (%edx),%dl
     dda:	88 10                	mov    %dl,(%eax)
     ddc:	8a 00                	mov    (%eax),%al
     dde:	84 c0                	test   %al,%al
     de0:	75 e4                	jne    dc6 <strcpy+0xd>
    ;
  return os;
     de2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     de5:	c9                   	leave  
     de6:	c3                   	ret    

00000de7 <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     de7:	55                   	push   %ebp
     de8:	89 e5                	mov    %esp,%ebp
     dea:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     ded:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     df4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     dfb:	00 
     dfc:	8b 45 08             	mov    0x8(%ebp),%eax
     dff:	89 04 24             	mov    %eax,(%esp)
     e02:	e8 7d 07 00 00       	call   1584 <open>
     e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
     e0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e0e:	79 20                	jns    e30 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     e10:	8b 45 08             	mov    0x8(%ebp),%eax
     e13:	89 44 24 08          	mov    %eax,0x8(%esp)
     e17:	c7 44 24 04 2c 1c 00 	movl   $0x1c2c,0x4(%esp)
     e1e:	00 
     e1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e26:	e8 3e 09 00 00       	call   1769 <printf>
      exit();
     e2b:	e8 14 07 00 00       	call   1544 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     e30:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     e37:	00 
     e38:	8b 45 0c             	mov    0xc(%ebp),%eax
     e3b:	89 04 24             	mov    %eax,(%esp)
     e3e:	e8 41 07 00 00       	call   1584 <open>
     e43:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e4a:	79 20                	jns    e6c <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
     e4f:	89 44 24 08          	mov    %eax,0x8(%esp)
     e53:	c7 44 24 04 47 1c 00 	movl   $0x1c47,0x4(%esp)
     e5a:	00 
     e5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e62:	e8 02 09 00 00       	call   1769 <printf>
      exit();
     e67:	e8 d8 06 00 00       	call   1544 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     e6c:	eb 3b                	jmp    ea9 <copy+0xc2>
  {
      max = used_disk+=count;
     e6e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e71:	01 45 10             	add    %eax,0x10(%ebp)
     e74:	8b 45 10             	mov    0x10(%ebp),%eax
     e77:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     e7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     e7d:	3b 45 14             	cmp    0x14(%ebp),%eax
     e80:	7e 07                	jle    e89 <copy+0xa2>
      {
        return -1;
     e82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     e87:	eb 5c                	jmp    ee5 <copy+0xfe>
      }
      bytes = bytes + count;
     e89:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e8c:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     e8f:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     e96:	00 
     e97:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     e9a:	89 44 24 04          	mov    %eax,0x4(%esp)
     e9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ea1:	89 04 24             	mov    %eax,(%esp)
     ea4:	e8 bb 06 00 00       	call   1564 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     ea9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     eb0:	00 
     eb1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
     eb8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ebb:	89 04 24             	mov    %eax,(%esp)
     ebe:	e8 99 06 00 00       	call   155c <read>
     ec3:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ec6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     eca:	7f a2                	jg     e6e <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     ecc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ecf:	89 04 24             	mov    %eax,(%esp)
     ed2:	e8 95 06 00 00       	call   156c <close>
  close(fd2);
     ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     eda:	89 04 24             	mov    %eax,(%esp)
     edd:	e8 8a 06 00 00       	call   156c <close>
  return(bytes);
     ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ee5:	c9                   	leave  
     ee6:	c3                   	ret    

00000ee7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ee7:	55                   	push   %ebp
     ee8:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     eea:	eb 06                	jmp    ef2 <strcmp+0xb>
    p++, q++;
     eec:	ff 45 08             	incl   0x8(%ebp)
     eef:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     ef2:	8b 45 08             	mov    0x8(%ebp),%eax
     ef5:	8a 00                	mov    (%eax),%al
     ef7:	84 c0                	test   %al,%al
     ef9:	74 0e                	je     f09 <strcmp+0x22>
     efb:	8b 45 08             	mov    0x8(%ebp),%eax
     efe:	8a 10                	mov    (%eax),%dl
     f00:	8b 45 0c             	mov    0xc(%ebp),%eax
     f03:	8a 00                	mov    (%eax),%al
     f05:	38 c2                	cmp    %al,%dl
     f07:	74 e3                	je     eec <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     f09:	8b 45 08             	mov    0x8(%ebp),%eax
     f0c:	8a 00                	mov    (%eax),%al
     f0e:	0f b6 d0             	movzbl %al,%edx
     f11:	8b 45 0c             	mov    0xc(%ebp),%eax
     f14:	8a 00                	mov    (%eax),%al
     f16:	0f b6 c0             	movzbl %al,%eax
     f19:	29 c2                	sub    %eax,%edx
     f1b:	89 d0                	mov    %edx,%eax
}
     f1d:	5d                   	pop    %ebp
     f1e:	c3                   	ret    

00000f1f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     f1f:	55                   	push   %ebp
     f20:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     f22:	eb 09                	jmp    f2d <strncmp+0xe>
    n--, p++, q++;
     f24:	ff 4d 10             	decl   0x10(%ebp)
     f27:	ff 45 08             	incl   0x8(%ebp)
     f2a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     f2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f31:	74 17                	je     f4a <strncmp+0x2b>
     f33:	8b 45 08             	mov    0x8(%ebp),%eax
     f36:	8a 00                	mov    (%eax),%al
     f38:	84 c0                	test   %al,%al
     f3a:	74 0e                	je     f4a <strncmp+0x2b>
     f3c:	8b 45 08             	mov    0x8(%ebp),%eax
     f3f:	8a 10                	mov    (%eax),%dl
     f41:	8b 45 0c             	mov    0xc(%ebp),%eax
     f44:	8a 00                	mov    (%eax),%al
     f46:	38 c2                	cmp    %al,%dl
     f48:	74 da                	je     f24 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     f4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f4e:	75 07                	jne    f57 <strncmp+0x38>
    return 0;
     f50:	b8 00 00 00 00       	mov    $0x0,%eax
     f55:	eb 14                	jmp    f6b <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     f57:	8b 45 08             	mov    0x8(%ebp),%eax
     f5a:	8a 00                	mov    (%eax),%al
     f5c:	0f b6 d0             	movzbl %al,%edx
     f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
     f62:	8a 00                	mov    (%eax),%al
     f64:	0f b6 c0             	movzbl %al,%eax
     f67:	29 c2                	sub    %eax,%edx
     f69:	89 d0                	mov    %edx,%eax
}
     f6b:	5d                   	pop    %ebp
     f6c:	c3                   	ret    

00000f6d <strlen>:

uint
strlen(const char *s)
{
     f6d:	55                   	push   %ebp
     f6e:	89 e5                	mov    %esp,%ebp
     f70:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     f73:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     f7a:	eb 03                	jmp    f7f <strlen+0x12>
     f7c:	ff 45 fc             	incl   -0x4(%ebp)
     f7f:	8b 55 fc             	mov    -0x4(%ebp),%edx
     f82:	8b 45 08             	mov    0x8(%ebp),%eax
     f85:	01 d0                	add    %edx,%eax
     f87:	8a 00                	mov    (%eax),%al
     f89:	84 c0                	test   %al,%al
     f8b:	75 ef                	jne    f7c <strlen+0xf>
    ;
  return n;
     f8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f90:	c9                   	leave  
     f91:	c3                   	ret    

00000f92 <memset>:

void*
memset(void *dst, int c, uint n)
{
     f92:	55                   	push   %ebp
     f93:	89 e5                	mov    %esp,%ebp
     f95:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     f98:	8b 45 10             	mov    0x10(%ebp),%eax
     f9b:	89 44 24 08          	mov    %eax,0x8(%esp)
     f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa2:	89 44 24 04          	mov    %eax,0x4(%esp)
     fa6:	8b 45 08             	mov    0x8(%ebp),%eax
     fa9:	89 04 24             	mov    %eax,(%esp)
     fac:	e8 e3 fd ff ff       	call   d94 <stosb>
  return dst;
     fb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     fb4:	c9                   	leave  
     fb5:	c3                   	ret    

00000fb6 <strchr>:

char*
strchr(const char *s, char c)
{
     fb6:	55                   	push   %ebp
     fb7:	89 e5                	mov    %esp,%ebp
     fb9:	83 ec 04             	sub    $0x4,%esp
     fbc:	8b 45 0c             	mov    0xc(%ebp),%eax
     fbf:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     fc2:	eb 12                	jmp    fd6 <strchr+0x20>
    if(*s == c)
     fc4:	8b 45 08             	mov    0x8(%ebp),%eax
     fc7:	8a 00                	mov    (%eax),%al
     fc9:	3a 45 fc             	cmp    -0x4(%ebp),%al
     fcc:	75 05                	jne    fd3 <strchr+0x1d>
      return (char*)s;
     fce:	8b 45 08             	mov    0x8(%ebp),%eax
     fd1:	eb 11                	jmp    fe4 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     fd3:	ff 45 08             	incl   0x8(%ebp)
     fd6:	8b 45 08             	mov    0x8(%ebp),%eax
     fd9:	8a 00                	mov    (%eax),%al
     fdb:	84 c0                	test   %al,%al
     fdd:	75 e5                	jne    fc4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     fdf:	b8 00 00 00 00       	mov    $0x0,%eax
}
     fe4:	c9                   	leave  
     fe5:	c3                   	ret    

00000fe6 <strcat>:

char *
strcat(char *dest, const char *src)
{
     fe6:	55                   	push   %ebp
     fe7:	89 e5                	mov    %esp,%ebp
     fe9:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
     fec:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     ff3:	eb 03                	jmp    ff8 <strcat+0x12>
     ff5:	ff 45 fc             	incl   -0x4(%ebp)
     ff8:	8b 55 fc             	mov    -0x4(%ebp),%edx
     ffb:	8b 45 08             	mov    0x8(%ebp),%eax
     ffe:	01 d0                	add    %edx,%eax
    1000:	8a 00                	mov    (%eax),%al
    1002:	84 c0                	test   %al,%al
    1004:	75 ef                	jne    ff5 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
    1006:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    100d:	eb 1e                	jmp    102d <strcat+0x47>
        dest[i+j] = src[j];
    100f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1012:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1015:	01 d0                	add    %edx,%eax
    1017:	89 c2                	mov    %eax,%edx
    1019:	8b 45 08             	mov    0x8(%ebp),%eax
    101c:	01 c2                	add    %eax,%edx
    101e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    1021:	8b 45 0c             	mov    0xc(%ebp),%eax
    1024:	01 c8                	add    %ecx,%eax
    1026:	8a 00                	mov    (%eax),%al
    1028:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
    102a:	ff 45 f8             	incl   -0x8(%ebp)
    102d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1030:	8b 45 0c             	mov    0xc(%ebp),%eax
    1033:	01 d0                	add    %edx,%eax
    1035:	8a 00                	mov    (%eax),%al
    1037:	84 c0                	test   %al,%al
    1039:	75 d4                	jne    100f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
    103b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    103e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1041:	01 d0                	add    %edx,%eax
    1043:	89 c2                	mov    %eax,%edx
    1045:	8b 45 08             	mov    0x8(%ebp),%eax
    1048:	01 d0                	add    %edx,%eax
    104a:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
    104d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1050:	c9                   	leave  
    1051:	c3                   	ret    

00001052 <strstr>:

int 
strstr(char* s, char* sub)
{
    1052:	55                   	push   %ebp
    1053:	89 e5                	mov    %esp,%ebp
    1055:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    1058:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    105f:	eb 7c                	jmp    10dd <strstr+0x8b>
    {
        if(s[i] == sub[0])
    1061:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1064:	8b 45 08             	mov    0x8(%ebp),%eax
    1067:	01 d0                	add    %edx,%eax
    1069:	8a 10                	mov    (%eax),%dl
    106b:	8b 45 0c             	mov    0xc(%ebp),%eax
    106e:	8a 00                	mov    (%eax),%al
    1070:	38 c2                	cmp    %al,%dl
    1072:	75 66                	jne    10da <strstr+0x88>
        {
            if(strlen(sub) == 1)
    1074:	8b 45 0c             	mov    0xc(%ebp),%eax
    1077:	89 04 24             	mov    %eax,(%esp)
    107a:	e8 ee fe ff ff       	call   f6d <strlen>
    107f:	83 f8 01             	cmp    $0x1,%eax
    1082:	75 05                	jne    1089 <strstr+0x37>
            {  
                return i;
    1084:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1087:	eb 6b                	jmp    10f4 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
    1089:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
    1090:	eb 3a                	jmp    10cc <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
    1092:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1095:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1098:	01 d0                	add    %edx,%eax
    109a:	89 c2                	mov    %eax,%edx
    109c:	8b 45 08             	mov    0x8(%ebp),%eax
    109f:	01 d0                	add    %edx,%eax
    10a1:	8a 10                	mov    (%eax),%dl
    10a3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    10a6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a9:	01 c8                	add    %ecx,%eax
    10ab:	8a 00                	mov    (%eax),%al
    10ad:	38 c2                	cmp    %al,%dl
    10af:	75 16                	jne    10c7 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
    10b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10b4:	8d 50 01             	lea    0x1(%eax),%edx
    10b7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ba:	01 d0                	add    %edx,%eax
    10bc:	8a 00                	mov    (%eax),%al
    10be:	84 c0                	test   %al,%al
    10c0:	75 07                	jne    10c9 <strstr+0x77>
                    {
                        return i;
    10c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10c5:	eb 2d                	jmp    10f4 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
    10c7:	eb 11                	jmp    10da <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
    10c9:	ff 45 f8             	incl   -0x8(%ebp)
    10cc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    10cf:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d2:	01 d0                	add    %edx,%eax
    10d4:	8a 00                	mov    (%eax),%al
    10d6:	84 c0                	test   %al,%al
    10d8:	75 b8                	jne    1092 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    10da:	ff 45 fc             	incl   -0x4(%ebp)
    10dd:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10e0:	8b 45 08             	mov    0x8(%ebp),%eax
    10e3:	01 d0                	add    %edx,%eax
    10e5:	8a 00                	mov    (%eax),%al
    10e7:	84 c0                	test   %al,%al
    10e9:	0f 85 72 ff ff ff    	jne    1061 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
    10ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    10f4:	c9                   	leave  
    10f5:	c3                   	ret    

000010f6 <strtok>:

char *
strtok(char *s, const char *delim)
{
    10f6:	55                   	push   %ebp
    10f7:	89 e5                	mov    %esp,%ebp
    10f9:	53                   	push   %ebx
    10fa:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
    10fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1101:	75 08                	jne    110b <strtok+0x15>
  s = lasts;
    1103:	a1 28 23 00 00       	mov    0x2328,%eax
    1108:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
    110b:	8b 45 08             	mov    0x8(%ebp),%eax
    110e:	8d 50 01             	lea    0x1(%eax),%edx
    1111:	89 55 08             	mov    %edx,0x8(%ebp)
    1114:	8a 00                	mov    (%eax),%al
    1116:	0f be d8             	movsbl %al,%ebx
    1119:	85 db                	test   %ebx,%ebx
    111b:	75 07                	jne    1124 <strtok+0x2e>
      return 0;
    111d:	b8 00 00 00 00       	mov    $0x0,%eax
    1122:	eb 58                	jmp    117c <strtok+0x86>
    } while (strchr(delim, ch));
    1124:	88 d8                	mov    %bl,%al
    1126:	0f be c0             	movsbl %al,%eax
    1129:	89 44 24 04          	mov    %eax,0x4(%esp)
    112d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1130:	89 04 24             	mov    %eax,(%esp)
    1133:	e8 7e fe ff ff       	call   fb6 <strchr>
    1138:	85 c0                	test   %eax,%eax
    113a:	75 cf                	jne    110b <strtok+0x15>
    --s;
    113c:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
    113f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1142:	89 44 24 04          	mov    %eax,0x4(%esp)
    1146:	8b 45 08             	mov    0x8(%ebp),%eax
    1149:	89 04 24             	mov    %eax,(%esp)
    114c:	e8 31 00 00 00       	call   1182 <strcspn>
    1151:	89 c2                	mov    %eax,%edx
    1153:	8b 45 08             	mov    0x8(%ebp),%eax
    1156:	01 d0                	add    %edx,%eax
    1158:	a3 28 23 00 00       	mov    %eax,0x2328
    if (*lasts != 0)
    115d:	a1 28 23 00 00       	mov    0x2328,%eax
    1162:	8a 00                	mov    (%eax),%al
    1164:	84 c0                	test   %al,%al
    1166:	74 11                	je     1179 <strtok+0x83>
  *lasts++ = 0;
    1168:	a1 28 23 00 00       	mov    0x2328,%eax
    116d:	8d 50 01             	lea    0x1(%eax),%edx
    1170:	89 15 28 23 00 00    	mov    %edx,0x2328
    1176:	c6 00 00             	movb   $0x0,(%eax)
    return s;
    1179:	8b 45 08             	mov    0x8(%ebp),%eax
}
    117c:	83 c4 14             	add    $0x14,%esp
    117f:	5b                   	pop    %ebx
    1180:	5d                   	pop    %ebp
    1181:	c3                   	ret    

00001182 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
    1182:	55                   	push   %ebp
    1183:	89 e5                	mov    %esp,%ebp
    1185:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
    1188:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
    118f:	eb 26                	jmp    11b7 <strcspn+0x35>
        if(strchr(s2,*s1))
    1191:	8b 45 08             	mov    0x8(%ebp),%eax
    1194:	8a 00                	mov    (%eax),%al
    1196:	0f be c0             	movsbl %al,%eax
    1199:	89 44 24 04          	mov    %eax,0x4(%esp)
    119d:	8b 45 0c             	mov    0xc(%ebp),%eax
    11a0:	89 04 24             	mov    %eax,(%esp)
    11a3:	e8 0e fe ff ff       	call   fb6 <strchr>
    11a8:	85 c0                	test   %eax,%eax
    11aa:	74 05                	je     11b1 <strcspn+0x2f>
            return ret;
    11ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11af:	eb 12                	jmp    11c3 <strcspn+0x41>
        else
            s1++,ret++;
    11b1:	ff 45 08             	incl   0x8(%ebp)
    11b4:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
    11b7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ba:	8a 00                	mov    (%eax),%al
    11bc:	84 c0                	test   %al,%al
    11be:	75 d1                	jne    1191 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
    11c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11c3:	c9                   	leave  
    11c4:	c3                   	ret    

000011c5 <isspace>:

int
isspace(unsigned char c)
{
    11c5:	55                   	push   %ebp
    11c6:	89 e5                	mov    %esp,%ebp
    11c8:	83 ec 04             	sub    $0x4,%esp
    11cb:	8b 45 08             	mov    0x8(%ebp),%eax
    11ce:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
    11d1:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
    11d5:	74 1e                	je     11f5 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
    11d7:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
    11db:	74 18                	je     11f5 <isspace+0x30>
    11dd:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
    11e1:	74 12                	je     11f5 <isspace+0x30>
    11e3:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
    11e7:	74 0c                	je     11f5 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
    11e9:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
    11ed:	74 06                	je     11f5 <isspace+0x30>
    11ef:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
    11f3:	75 07                	jne    11fc <isspace+0x37>
    11f5:	b8 01 00 00 00       	mov    $0x1,%eax
    11fa:	eb 05                	jmp    1201 <isspace+0x3c>
    11fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1201:	c9                   	leave  
    1202:	c3                   	ret    

00001203 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
    1203:	55                   	push   %ebp
    1204:	89 e5                	mov    %esp,%ebp
    1206:	57                   	push   %edi
    1207:	56                   	push   %esi
    1208:	53                   	push   %ebx
    1209:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
    120c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
    1211:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
    1218:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    121b:	eb 01                	jmp    121e <strtoul+0x1b>
  p += 1;
    121d:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    121e:	8a 03                	mov    (%ebx),%al
    1220:	0f b6 c0             	movzbl %al,%eax
    1223:	89 04 24             	mov    %eax,(%esp)
    1226:	e8 9a ff ff ff       	call   11c5 <isspace>
    122b:	85 c0                	test   %eax,%eax
    122d:	75 ee                	jne    121d <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
    122f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1233:	75 30                	jne    1265 <strtoul+0x62>
    {
  if (*p == '0') {
    1235:	8a 03                	mov    (%ebx),%al
    1237:	3c 30                	cmp    $0x30,%al
    1239:	75 21                	jne    125c <strtoul+0x59>
      p += 1;
    123b:	43                   	inc    %ebx
      if (*p == 'x') {
    123c:	8a 03                	mov    (%ebx),%al
    123e:	3c 78                	cmp    $0x78,%al
    1240:	75 0a                	jne    124c <strtoul+0x49>
    p += 1;
    1242:	43                   	inc    %ebx
    base = 16;
    1243:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
    124a:	eb 31                	jmp    127d <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
    124c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
    1253:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
    125a:	eb 21                	jmp    127d <strtoul+0x7a>
      }
  }
  else base = 10;
    125c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    1263:	eb 18                	jmp    127d <strtoul+0x7a>
    } else if (base == 16) {
    1265:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    1269:	75 12                	jne    127d <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
    126b:	8a 03                	mov    (%ebx),%al
    126d:	3c 30                	cmp    $0x30,%al
    126f:	75 0c                	jne    127d <strtoul+0x7a>
    1271:	8d 43 01             	lea    0x1(%ebx),%eax
    1274:	8a 00                	mov    (%eax),%al
    1276:	3c 78                	cmp    $0x78,%al
    1278:	75 03                	jne    127d <strtoul+0x7a>
      p += 2;
    127a:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
    127d:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
    1281:	75 29                	jne    12ac <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
    1283:	8a 03                	mov    (%ebx),%al
    1285:	0f be c0             	movsbl %al,%eax
    1288:	83 e8 30             	sub    $0x30,%eax
    128b:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
    128d:	83 fe 07             	cmp    $0x7,%esi
    1290:	76 06                	jbe    1298 <strtoul+0x95>
    break;
    1292:	90                   	nop
    1293:	e9 b6 00 00 00       	jmp    134e <strtoul+0x14b>
      }
      result = (result << 3) + digit;
    1298:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
    129f:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    12a2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
    12a9:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    12aa:	eb d7                	jmp    1283 <strtoul+0x80>
    } else if (base == 10) {
    12ac:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
    12b0:	75 2b                	jne    12dd <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
    12b2:	8a 03                	mov    (%ebx),%al
    12b4:	0f be c0             	movsbl %al,%eax
    12b7:	83 e8 30             	sub    $0x30,%eax
    12ba:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
    12bc:	83 fe 09             	cmp    $0x9,%esi
    12bf:	76 06                	jbe    12c7 <strtoul+0xc4>
    break;
    12c1:	90                   	nop
    12c2:	e9 87 00 00 00       	jmp    134e <strtoul+0x14b>
      }
      result = (10*result) + digit;
    12c7:	89 f8                	mov    %edi,%eax
    12c9:	c1 e0 02             	shl    $0x2,%eax
    12cc:	01 f8                	add    %edi,%eax
    12ce:	01 c0                	add    %eax,%eax
    12d0:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    12d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
    12da:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    12db:	eb d5                	jmp    12b2 <strtoul+0xaf>
    } else if (base == 16) {
    12dd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    12e1:	75 35                	jne    1318 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
    12e3:	8a 03                	mov    (%ebx),%al
    12e5:	0f be c0             	movsbl %al,%eax
    12e8:	83 e8 30             	sub    $0x30,%eax
    12eb:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    12ed:	83 fe 4a             	cmp    $0x4a,%esi
    12f0:	76 02                	jbe    12f4 <strtoul+0xf1>
    break;
    12f2:	eb 22                	jmp    1316 <strtoul+0x113>
      }
      digit = cvtIn[digit];
    12f4:	8a 86 60 22 00 00    	mov    0x2260(%esi),%al
    12fa:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
    12fd:	83 fe 0f             	cmp    $0xf,%esi
    1300:	76 02                	jbe    1304 <strtoul+0x101>
    break;
    1302:	eb 12                	jmp    1316 <strtoul+0x113>
      }
      result = (result << 4) + digit;
    1304:	89 f8                	mov    %edi,%eax
    1306:	c1 e0 04             	shl    $0x4,%eax
    1309:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    130c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
    1313:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    1314:	eb cd                	jmp    12e3 <strtoul+0xe0>
    1316:	eb 36                	jmp    134e <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
    1318:	8a 03                	mov    (%ebx),%al
    131a:	0f be c0             	movsbl %al,%eax
    131d:	83 e8 30             	sub    $0x30,%eax
    1320:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    1322:	83 fe 4a             	cmp    $0x4a,%esi
    1325:	76 02                	jbe    1329 <strtoul+0x126>
    break;
    1327:	eb 25                	jmp    134e <strtoul+0x14b>
      }
      digit = cvtIn[digit];
    1329:	8a 86 60 22 00 00    	mov    0x2260(%esi),%al
    132f:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
    1332:	8b 45 10             	mov    0x10(%ebp),%eax
    1335:	39 f0                	cmp    %esi,%eax
    1337:	77 02                	ja     133b <strtoul+0x138>
    break;
    1339:	eb 13                	jmp    134e <strtoul+0x14b>
      }
      result = result*base + digit;
    133b:	8b 45 10             	mov    0x10(%ebp),%eax
    133e:	0f af c7             	imul   %edi,%eax
    1341:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1344:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
    134b:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
    134c:	eb ca                	jmp    1318 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
    134e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1352:	75 03                	jne    1357 <strtoul+0x154>
  p = string;
    1354:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
    1357:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    135b:	74 05                	je     1362 <strtoul+0x15f>
  *endPtr = p;
    135d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1360:	89 18                	mov    %ebx,(%eax)
    }

    return result;
    1362:	89 f8                	mov    %edi,%eax
}
    1364:	83 c4 14             	add    $0x14,%esp
    1367:	5b                   	pop    %ebx
    1368:	5e                   	pop    %esi
    1369:	5f                   	pop    %edi
    136a:	5d                   	pop    %ebp
    136b:	c3                   	ret    

0000136c <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
    136c:	55                   	push   %ebp
    136d:	89 e5                	mov    %esp,%ebp
    136f:	53                   	push   %ebx
    1370:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
    1373:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    1376:	eb 01                	jmp    1379 <strtol+0xd>
      p += 1;
    1378:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    1379:	8a 03                	mov    (%ebx),%al
    137b:	0f b6 c0             	movzbl %al,%eax
    137e:	89 04 24             	mov    %eax,(%esp)
    1381:	e8 3f fe ff ff       	call   11c5 <isspace>
    1386:	85 c0                	test   %eax,%eax
    1388:	75 ee                	jne    1378 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
    138a:	8a 03                	mov    (%ebx),%al
    138c:	3c 2d                	cmp    $0x2d,%al
    138e:	75 1e                	jne    13ae <strtol+0x42>
  p += 1;
    1390:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
    1391:	8b 45 10             	mov    0x10(%ebp),%eax
    1394:	89 44 24 08          	mov    %eax,0x8(%esp)
    1398:	8b 45 0c             	mov    0xc(%ebp),%eax
    139b:	89 44 24 04          	mov    %eax,0x4(%esp)
    139f:	89 1c 24             	mov    %ebx,(%esp)
    13a2:	e8 5c fe ff ff       	call   1203 <strtoul>
    13a7:	f7 d8                	neg    %eax
    13a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    13ac:	eb 20                	jmp    13ce <strtol+0x62>
    } else {
  if (*p == '+') {
    13ae:	8a 03                	mov    (%ebx),%al
    13b0:	3c 2b                	cmp    $0x2b,%al
    13b2:	75 01                	jne    13b5 <strtol+0x49>
      p += 1;
    13b4:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
    13b5:	8b 45 10             	mov    0x10(%ebp),%eax
    13b8:	89 44 24 08          	mov    %eax,0x8(%esp)
    13bc:	8b 45 0c             	mov    0xc(%ebp),%eax
    13bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    13c3:	89 1c 24             	mov    %ebx,(%esp)
    13c6:	e8 38 fe ff ff       	call   1203 <strtoul>
    13cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
    13ce:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
    13d2:	75 17                	jne    13eb <strtol+0x7f>
    13d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    13d8:	74 11                	je     13eb <strtol+0x7f>
    13da:	8b 45 0c             	mov    0xc(%ebp),%eax
    13dd:	8b 00                	mov    (%eax),%eax
    13df:	39 d8                	cmp    %ebx,%eax
    13e1:	75 08                	jne    13eb <strtol+0x7f>
  *endPtr = string;
    13e3:	8b 45 0c             	mov    0xc(%ebp),%eax
    13e6:	8b 55 08             	mov    0x8(%ebp),%edx
    13e9:	89 10                	mov    %edx,(%eax)
    }
    return result;
    13eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
    13ee:	83 c4 1c             	add    $0x1c,%esp
    13f1:	5b                   	pop    %ebx
    13f2:	5d                   	pop    %ebp
    13f3:	c3                   	ret    

000013f4 <gets>:

char*
gets(char *buf, int max)
{
    13f4:	55                   	push   %ebp
    13f5:	89 e5                	mov    %esp,%ebp
    13f7:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    13fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1401:	eb 49                	jmp    144c <gets+0x58>
    cc = read(0, &c, 1);
    1403:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    140a:	00 
    140b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    140e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1412:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1419:	e8 3e 01 00 00       	call   155c <read>
    141e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1421:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1425:	7f 02                	jg     1429 <gets+0x35>
      break;
    1427:	eb 2c                	jmp    1455 <gets+0x61>
    buf[i++] = c;
    1429:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142c:	8d 50 01             	lea    0x1(%eax),%edx
    142f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1432:	89 c2                	mov    %eax,%edx
    1434:	8b 45 08             	mov    0x8(%ebp),%eax
    1437:	01 c2                	add    %eax,%edx
    1439:	8a 45 ef             	mov    -0x11(%ebp),%al
    143c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    143e:	8a 45 ef             	mov    -0x11(%ebp),%al
    1441:	3c 0a                	cmp    $0xa,%al
    1443:	74 10                	je     1455 <gets+0x61>
    1445:	8a 45 ef             	mov    -0x11(%ebp),%al
    1448:	3c 0d                	cmp    $0xd,%al
    144a:	74 09                	je     1455 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144f:	40                   	inc    %eax
    1450:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1453:	7c ae                	jl     1403 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1455:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1458:	8b 45 08             	mov    0x8(%ebp),%eax
    145b:	01 d0                	add    %edx,%eax
    145d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1460:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1463:	c9                   	leave  
    1464:	c3                   	ret    

00001465 <stat>:

int
stat(char *n, struct stat *st)
{
    1465:	55                   	push   %ebp
    1466:	89 e5                	mov    %esp,%ebp
    1468:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    146b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1472:	00 
    1473:	8b 45 08             	mov    0x8(%ebp),%eax
    1476:	89 04 24             	mov    %eax,(%esp)
    1479:	e8 06 01 00 00       	call   1584 <open>
    147e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1481:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1485:	79 07                	jns    148e <stat+0x29>
    return -1;
    1487:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    148c:	eb 23                	jmp    14b1 <stat+0x4c>
  r = fstat(fd, st);
    148e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1491:	89 44 24 04          	mov    %eax,0x4(%esp)
    1495:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1498:	89 04 24             	mov    %eax,(%esp)
    149b:	e8 fc 00 00 00       	call   159c <fstat>
    14a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    14a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14a6:	89 04 24             	mov    %eax,(%esp)
    14a9:	e8 be 00 00 00       	call   156c <close>
  return r;
    14ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    14b1:	c9                   	leave  
    14b2:	c3                   	ret    

000014b3 <atoi>:

int
atoi(const char *s)
{
    14b3:	55                   	push   %ebp
    14b4:	89 e5                	mov    %esp,%ebp
    14b6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    14b9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    14c0:	eb 24                	jmp    14e6 <atoi+0x33>
    n = n*10 + *s++ - '0';
    14c2:	8b 55 fc             	mov    -0x4(%ebp),%edx
    14c5:	89 d0                	mov    %edx,%eax
    14c7:	c1 e0 02             	shl    $0x2,%eax
    14ca:	01 d0                	add    %edx,%eax
    14cc:	01 c0                	add    %eax,%eax
    14ce:	89 c1                	mov    %eax,%ecx
    14d0:	8b 45 08             	mov    0x8(%ebp),%eax
    14d3:	8d 50 01             	lea    0x1(%eax),%edx
    14d6:	89 55 08             	mov    %edx,0x8(%ebp)
    14d9:	8a 00                	mov    (%eax),%al
    14db:	0f be c0             	movsbl %al,%eax
    14de:	01 c8                	add    %ecx,%eax
    14e0:	83 e8 30             	sub    $0x30,%eax
    14e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    14e6:	8b 45 08             	mov    0x8(%ebp),%eax
    14e9:	8a 00                	mov    (%eax),%al
    14eb:	3c 2f                	cmp    $0x2f,%al
    14ed:	7e 09                	jle    14f8 <atoi+0x45>
    14ef:	8b 45 08             	mov    0x8(%ebp),%eax
    14f2:	8a 00                	mov    (%eax),%al
    14f4:	3c 39                	cmp    $0x39,%al
    14f6:	7e ca                	jle    14c2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    14f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    14fb:	c9                   	leave  
    14fc:	c3                   	ret    

000014fd <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    14fd:	55                   	push   %ebp
    14fe:	89 e5                	mov    %esp,%ebp
    1500:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1503:	8b 45 08             	mov    0x8(%ebp),%eax
    1506:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1509:	8b 45 0c             	mov    0xc(%ebp),%eax
    150c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    150f:	eb 16                	jmp    1527 <memmove+0x2a>
    *dst++ = *src++;
    1511:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1514:	8d 50 01             	lea    0x1(%eax),%edx
    1517:	89 55 fc             	mov    %edx,-0x4(%ebp)
    151a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    151d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1520:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1523:	8a 12                	mov    (%edx),%dl
    1525:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1527:	8b 45 10             	mov    0x10(%ebp),%eax
    152a:	8d 50 ff             	lea    -0x1(%eax),%edx
    152d:	89 55 10             	mov    %edx,0x10(%ebp)
    1530:	85 c0                	test   %eax,%eax
    1532:	7f dd                	jg     1511 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1534:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1537:	c9                   	leave  
    1538:	c3                   	ret    
    1539:	90                   	nop
    153a:	90                   	nop
    153b:	90                   	nop

0000153c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    153c:	b8 01 00 00 00       	mov    $0x1,%eax
    1541:	cd 40                	int    $0x40
    1543:	c3                   	ret    

00001544 <exit>:
SYSCALL(exit)
    1544:	b8 02 00 00 00       	mov    $0x2,%eax
    1549:	cd 40                	int    $0x40
    154b:	c3                   	ret    

0000154c <wait>:
SYSCALL(wait)
    154c:	b8 03 00 00 00       	mov    $0x3,%eax
    1551:	cd 40                	int    $0x40
    1553:	c3                   	ret    

00001554 <pipe>:
SYSCALL(pipe)
    1554:	b8 04 00 00 00       	mov    $0x4,%eax
    1559:	cd 40                	int    $0x40
    155b:	c3                   	ret    

0000155c <read>:
SYSCALL(read)
    155c:	b8 05 00 00 00       	mov    $0x5,%eax
    1561:	cd 40                	int    $0x40
    1563:	c3                   	ret    

00001564 <write>:
SYSCALL(write)
    1564:	b8 10 00 00 00       	mov    $0x10,%eax
    1569:	cd 40                	int    $0x40
    156b:	c3                   	ret    

0000156c <close>:
SYSCALL(close)
    156c:	b8 15 00 00 00       	mov    $0x15,%eax
    1571:	cd 40                	int    $0x40
    1573:	c3                   	ret    

00001574 <kill>:
SYSCALL(kill)
    1574:	b8 06 00 00 00       	mov    $0x6,%eax
    1579:	cd 40                	int    $0x40
    157b:	c3                   	ret    

0000157c <exec>:
SYSCALL(exec)
    157c:	b8 07 00 00 00       	mov    $0x7,%eax
    1581:	cd 40                	int    $0x40
    1583:	c3                   	ret    

00001584 <open>:
SYSCALL(open)
    1584:	b8 0f 00 00 00       	mov    $0xf,%eax
    1589:	cd 40                	int    $0x40
    158b:	c3                   	ret    

0000158c <mknod>:
SYSCALL(mknod)
    158c:	b8 11 00 00 00       	mov    $0x11,%eax
    1591:	cd 40                	int    $0x40
    1593:	c3                   	ret    

00001594 <unlink>:
SYSCALL(unlink)
    1594:	b8 12 00 00 00       	mov    $0x12,%eax
    1599:	cd 40                	int    $0x40
    159b:	c3                   	ret    

0000159c <fstat>:
SYSCALL(fstat)
    159c:	b8 08 00 00 00       	mov    $0x8,%eax
    15a1:	cd 40                	int    $0x40
    15a3:	c3                   	ret    

000015a4 <link>:
SYSCALL(link)
    15a4:	b8 13 00 00 00       	mov    $0x13,%eax
    15a9:	cd 40                	int    $0x40
    15ab:	c3                   	ret    

000015ac <mkdir>:
SYSCALL(mkdir)
    15ac:	b8 14 00 00 00       	mov    $0x14,%eax
    15b1:	cd 40                	int    $0x40
    15b3:	c3                   	ret    

000015b4 <chdir>:
SYSCALL(chdir)
    15b4:	b8 09 00 00 00       	mov    $0x9,%eax
    15b9:	cd 40                	int    $0x40
    15bb:	c3                   	ret    

000015bc <dup>:
SYSCALL(dup)
    15bc:	b8 0a 00 00 00       	mov    $0xa,%eax
    15c1:	cd 40                	int    $0x40
    15c3:	c3                   	ret    

000015c4 <getpid>:
SYSCALL(getpid)
    15c4:	b8 0b 00 00 00       	mov    $0xb,%eax
    15c9:	cd 40                	int    $0x40
    15cb:	c3                   	ret    

000015cc <sbrk>:
SYSCALL(sbrk)
    15cc:	b8 0c 00 00 00       	mov    $0xc,%eax
    15d1:	cd 40                	int    $0x40
    15d3:	c3                   	ret    

000015d4 <sleep>:
SYSCALL(sleep)
    15d4:	b8 0d 00 00 00       	mov    $0xd,%eax
    15d9:	cd 40                	int    $0x40
    15db:	c3                   	ret    

000015dc <uptime>:
SYSCALL(uptime)
    15dc:	b8 0e 00 00 00       	mov    $0xe,%eax
    15e1:	cd 40                	int    $0x40
    15e3:	c3                   	ret    

000015e4 <getname>:
SYSCALL(getname)
    15e4:	b8 16 00 00 00       	mov    $0x16,%eax
    15e9:	cd 40                	int    $0x40
    15eb:	c3                   	ret    

000015ec <setname>:
SYSCALL(setname)
    15ec:	b8 17 00 00 00       	mov    $0x17,%eax
    15f1:	cd 40                	int    $0x40
    15f3:	c3                   	ret    

000015f4 <getmaxproc>:
SYSCALL(getmaxproc)
    15f4:	b8 18 00 00 00       	mov    $0x18,%eax
    15f9:	cd 40                	int    $0x40
    15fb:	c3                   	ret    

000015fc <setmaxproc>:
SYSCALL(setmaxproc)
    15fc:	b8 19 00 00 00       	mov    $0x19,%eax
    1601:	cd 40                	int    $0x40
    1603:	c3                   	ret    

00001604 <getmaxmem>:
SYSCALL(getmaxmem)
    1604:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1609:	cd 40                	int    $0x40
    160b:	c3                   	ret    

0000160c <setmaxmem>:
SYSCALL(setmaxmem)
    160c:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1611:	cd 40                	int    $0x40
    1613:	c3                   	ret    

00001614 <getmaxdisk>:
SYSCALL(getmaxdisk)
    1614:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1619:	cd 40                	int    $0x40
    161b:	c3                   	ret    

0000161c <setmaxdisk>:
SYSCALL(setmaxdisk)
    161c:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1621:	cd 40                	int    $0x40
    1623:	c3                   	ret    

00001624 <getusedmem>:
SYSCALL(getusedmem)
    1624:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1629:	cd 40                	int    $0x40
    162b:	c3                   	ret    

0000162c <setusedmem>:
SYSCALL(setusedmem)
    162c:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1631:	cd 40                	int    $0x40
    1633:	c3                   	ret    

00001634 <getuseddisk>:
SYSCALL(getuseddisk)
    1634:	b8 20 00 00 00       	mov    $0x20,%eax
    1639:	cd 40                	int    $0x40
    163b:	c3                   	ret    

0000163c <setuseddisk>:
SYSCALL(setuseddisk)
    163c:	b8 21 00 00 00       	mov    $0x21,%eax
    1641:	cd 40                	int    $0x40
    1643:	c3                   	ret    

00001644 <setvc>:
SYSCALL(setvc)
    1644:	b8 22 00 00 00       	mov    $0x22,%eax
    1649:	cd 40                	int    $0x40
    164b:	c3                   	ret    

0000164c <setactivefs>:
SYSCALL(setactivefs)
    164c:	b8 24 00 00 00       	mov    $0x24,%eax
    1651:	cd 40                	int    $0x40
    1653:	c3                   	ret    

00001654 <getactivefs>:
SYSCALL(getactivefs)
    1654:	b8 25 00 00 00       	mov    $0x25,%eax
    1659:	cd 40                	int    $0x40
    165b:	c3                   	ret    

0000165c <getvcfs>:
SYSCALL(getvcfs)
    165c:	b8 23 00 00 00       	mov    $0x23,%eax
    1661:	cd 40                	int    $0x40
    1663:	c3                   	ret    

00001664 <getcwd>:
SYSCALL(getcwd)
    1664:	b8 26 00 00 00       	mov    $0x26,%eax
    1669:	cd 40                	int    $0x40
    166b:	c3                   	ret    

0000166c <tostring>:
SYSCALL(tostring)
    166c:	b8 27 00 00 00       	mov    $0x27,%eax
    1671:	cd 40                	int    $0x40
    1673:	c3                   	ret    

00001674 <getactivefsindex>:
SYSCALL(getactivefsindex)
    1674:	b8 28 00 00 00       	mov    $0x28,%eax
    1679:	cd 40                	int    $0x40
    167b:	c3                   	ret    

0000167c <setatroot>:
SYSCALL(setatroot)
    167c:	b8 2a 00 00 00       	mov    $0x2a,%eax
    1681:	cd 40                	int    $0x40
    1683:	c3                   	ret    

00001684 <getatroot>:
SYSCALL(getatroot)
    1684:	b8 29 00 00 00       	mov    $0x29,%eax
    1689:	cd 40                	int    $0x40
    168b:	c3                   	ret    

0000168c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    168c:	55                   	push   %ebp
    168d:	89 e5                	mov    %esp,%ebp
    168f:	83 ec 18             	sub    $0x18,%esp
    1692:	8b 45 0c             	mov    0xc(%ebp),%eax
    1695:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    1698:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    169f:	00 
    16a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    16a3:	89 44 24 04          	mov    %eax,0x4(%esp)
    16a7:	8b 45 08             	mov    0x8(%ebp),%eax
    16aa:	89 04 24             	mov    %eax,(%esp)
    16ad:	e8 b2 fe ff ff       	call   1564 <write>
}
    16b2:	c9                   	leave  
    16b3:	c3                   	ret    

000016b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    16b4:	55                   	push   %ebp
    16b5:	89 e5                	mov    %esp,%ebp
    16b7:	56                   	push   %esi
    16b8:	53                   	push   %ebx
    16b9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    16bc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16c3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16c7:	74 17                	je     16e0 <printint+0x2c>
    16c9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16cd:	79 11                	jns    16e0 <printint+0x2c>
    neg = 1;
    16cf:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16d6:	8b 45 0c             	mov    0xc(%ebp),%eax
    16d9:	f7 d8                	neg    %eax
    16db:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16de:	eb 06                	jmp    16e6 <printint+0x32>
  } else {
    x = xx;
    16e0:	8b 45 0c             	mov    0xc(%ebp),%eax
    16e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16e6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16ed:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    16f0:	8d 41 01             	lea    0x1(%ecx),%eax
    16f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    16f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
    16f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
    16fc:	ba 00 00 00 00       	mov    $0x0,%edx
    1701:	f7 f3                	div    %ebx
    1703:	89 d0                	mov    %edx,%eax
    1705:	8a 80 ac 22 00 00    	mov    0x22ac(%eax),%al
    170b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    170f:	8b 75 10             	mov    0x10(%ebp),%esi
    1712:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1715:	ba 00 00 00 00       	mov    $0x0,%edx
    171a:	f7 f6                	div    %esi
    171c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    171f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1723:	75 c8                	jne    16ed <printint+0x39>
  if(neg)
    1725:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1729:	74 10                	je     173b <printint+0x87>
    buf[i++] = '-';
    172b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    172e:	8d 50 01             	lea    0x1(%eax),%edx
    1731:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1734:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1739:	eb 1e                	jmp    1759 <printint+0xa5>
    173b:	eb 1c                	jmp    1759 <printint+0xa5>
    putc(fd, buf[i]);
    173d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1740:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1743:	01 d0                	add    %edx,%eax
    1745:	8a 00                	mov    (%eax),%al
    1747:	0f be c0             	movsbl %al,%eax
    174a:	89 44 24 04          	mov    %eax,0x4(%esp)
    174e:	8b 45 08             	mov    0x8(%ebp),%eax
    1751:	89 04 24             	mov    %eax,(%esp)
    1754:	e8 33 ff ff ff       	call   168c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1759:	ff 4d f4             	decl   -0xc(%ebp)
    175c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1760:	79 db                	jns    173d <printint+0x89>
    putc(fd, buf[i]);
}
    1762:	83 c4 30             	add    $0x30,%esp
    1765:	5b                   	pop    %ebx
    1766:	5e                   	pop    %esi
    1767:	5d                   	pop    %ebp
    1768:	c3                   	ret    

00001769 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1769:	55                   	push   %ebp
    176a:	89 e5                	mov    %esp,%ebp
    176c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    176f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1776:	8d 45 0c             	lea    0xc(%ebp),%eax
    1779:	83 c0 04             	add    $0x4,%eax
    177c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    177f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1786:	e9 77 01 00 00       	jmp    1902 <printf+0x199>
    c = fmt[i] & 0xff;
    178b:	8b 55 0c             	mov    0xc(%ebp),%edx
    178e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1791:	01 d0                	add    %edx,%eax
    1793:	8a 00                	mov    (%eax),%al
    1795:	0f be c0             	movsbl %al,%eax
    1798:	25 ff 00 00 00       	and    $0xff,%eax
    179d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    17a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17a4:	75 2c                	jne    17d2 <printf+0x69>
      if(c == '%'){
    17a6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17aa:	75 0c                	jne    17b8 <printf+0x4f>
        state = '%';
    17ac:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    17b3:	e9 47 01 00 00       	jmp    18ff <printf+0x196>
      } else {
        putc(fd, c);
    17b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17bb:	0f be c0             	movsbl %al,%eax
    17be:	89 44 24 04          	mov    %eax,0x4(%esp)
    17c2:	8b 45 08             	mov    0x8(%ebp),%eax
    17c5:	89 04 24             	mov    %eax,(%esp)
    17c8:	e8 bf fe ff ff       	call   168c <putc>
    17cd:	e9 2d 01 00 00       	jmp    18ff <printf+0x196>
      }
    } else if(state == '%'){
    17d2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17d6:	0f 85 23 01 00 00    	jne    18ff <printf+0x196>
      if(c == 'd'){
    17dc:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17e0:	75 2d                	jne    180f <printf+0xa6>
        printint(fd, *ap, 10, 1);
    17e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17e5:	8b 00                	mov    (%eax),%eax
    17e7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17ee:	00 
    17ef:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    17f6:	00 
    17f7:	89 44 24 04          	mov    %eax,0x4(%esp)
    17fb:	8b 45 08             	mov    0x8(%ebp),%eax
    17fe:	89 04 24             	mov    %eax,(%esp)
    1801:	e8 ae fe ff ff       	call   16b4 <printint>
        ap++;
    1806:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    180a:	e9 e9 00 00 00       	jmp    18f8 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    180f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1813:	74 06                	je     181b <printf+0xb2>
    1815:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1819:	75 2d                	jne    1848 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    181b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    181e:	8b 00                	mov    (%eax),%eax
    1820:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1827:	00 
    1828:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    182f:	00 
    1830:	89 44 24 04          	mov    %eax,0x4(%esp)
    1834:	8b 45 08             	mov    0x8(%ebp),%eax
    1837:	89 04 24             	mov    %eax,(%esp)
    183a:	e8 75 fe ff ff       	call   16b4 <printint>
        ap++;
    183f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1843:	e9 b0 00 00 00       	jmp    18f8 <printf+0x18f>
      } else if(c == 's'){
    1848:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    184c:	75 42                	jne    1890 <printf+0x127>
        s = (char*)*ap;
    184e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1851:	8b 00                	mov    (%eax),%eax
    1853:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1856:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    185a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    185e:	75 09                	jne    1869 <printf+0x100>
          s = "(null)";
    1860:	c7 45 f4 63 1c 00 00 	movl   $0x1c63,-0xc(%ebp)
        while(*s != 0){
    1867:	eb 1c                	jmp    1885 <printf+0x11c>
    1869:	eb 1a                	jmp    1885 <printf+0x11c>
          putc(fd, *s);
    186b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    186e:	8a 00                	mov    (%eax),%al
    1870:	0f be c0             	movsbl %al,%eax
    1873:	89 44 24 04          	mov    %eax,0x4(%esp)
    1877:	8b 45 08             	mov    0x8(%ebp),%eax
    187a:	89 04 24             	mov    %eax,(%esp)
    187d:	e8 0a fe ff ff       	call   168c <putc>
          s++;
    1882:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1885:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1888:	8a 00                	mov    (%eax),%al
    188a:	84 c0                	test   %al,%al
    188c:	75 dd                	jne    186b <printf+0x102>
    188e:	eb 68                	jmp    18f8 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1890:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1894:	75 1d                	jne    18b3 <printf+0x14a>
        putc(fd, *ap);
    1896:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1899:	8b 00                	mov    (%eax),%eax
    189b:	0f be c0             	movsbl %al,%eax
    189e:	89 44 24 04          	mov    %eax,0x4(%esp)
    18a2:	8b 45 08             	mov    0x8(%ebp),%eax
    18a5:	89 04 24             	mov    %eax,(%esp)
    18a8:	e8 df fd ff ff       	call   168c <putc>
        ap++;
    18ad:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18b1:	eb 45                	jmp    18f8 <printf+0x18f>
      } else if(c == '%'){
    18b3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18b7:	75 17                	jne    18d0 <printf+0x167>
        putc(fd, c);
    18b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18bc:	0f be c0             	movsbl %al,%eax
    18bf:	89 44 24 04          	mov    %eax,0x4(%esp)
    18c3:	8b 45 08             	mov    0x8(%ebp),%eax
    18c6:	89 04 24             	mov    %eax,(%esp)
    18c9:	e8 be fd ff ff       	call   168c <putc>
    18ce:	eb 28                	jmp    18f8 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18d0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18d7:	00 
    18d8:	8b 45 08             	mov    0x8(%ebp),%eax
    18db:	89 04 24             	mov    %eax,(%esp)
    18de:	e8 a9 fd ff ff       	call   168c <putc>
        putc(fd, c);
    18e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18e6:	0f be c0             	movsbl %al,%eax
    18e9:	89 44 24 04          	mov    %eax,0x4(%esp)
    18ed:	8b 45 08             	mov    0x8(%ebp),%eax
    18f0:	89 04 24             	mov    %eax,(%esp)
    18f3:	e8 94 fd ff ff       	call   168c <putc>
      }
      state = 0;
    18f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    18ff:	ff 45 f0             	incl   -0x10(%ebp)
    1902:	8b 55 0c             	mov    0xc(%ebp),%edx
    1905:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1908:	01 d0                	add    %edx,%eax
    190a:	8a 00                	mov    (%eax),%al
    190c:	84 c0                	test   %al,%al
    190e:	0f 85 77 fe ff ff    	jne    178b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1914:	c9                   	leave  
    1915:	c3                   	ret    
    1916:	90                   	nop
    1917:	90                   	nop

00001918 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1918:	55                   	push   %ebp
    1919:	89 e5                	mov    %esp,%ebp
    191b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    191e:	8b 45 08             	mov    0x8(%ebp),%eax
    1921:	83 e8 08             	sub    $0x8,%eax
    1924:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1927:	a1 34 23 00 00       	mov    0x2334,%eax
    192c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    192f:	eb 24                	jmp    1955 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1931:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1934:	8b 00                	mov    (%eax),%eax
    1936:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1939:	77 12                	ja     194d <free+0x35>
    193b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    193e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1941:	77 24                	ja     1967 <free+0x4f>
    1943:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1946:	8b 00                	mov    (%eax),%eax
    1948:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    194b:	77 1a                	ja     1967 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    194d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1950:	8b 00                	mov    (%eax),%eax
    1952:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1955:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1958:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    195b:	76 d4                	jbe    1931 <free+0x19>
    195d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1960:	8b 00                	mov    (%eax),%eax
    1962:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1965:	76 ca                	jbe    1931 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1967:	8b 45 f8             	mov    -0x8(%ebp),%eax
    196a:	8b 40 04             	mov    0x4(%eax),%eax
    196d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1974:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1977:	01 c2                	add    %eax,%edx
    1979:	8b 45 fc             	mov    -0x4(%ebp),%eax
    197c:	8b 00                	mov    (%eax),%eax
    197e:	39 c2                	cmp    %eax,%edx
    1980:	75 24                	jne    19a6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1982:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1985:	8b 50 04             	mov    0x4(%eax),%edx
    1988:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198b:	8b 00                	mov    (%eax),%eax
    198d:	8b 40 04             	mov    0x4(%eax),%eax
    1990:	01 c2                	add    %eax,%edx
    1992:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1995:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1998:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199b:	8b 00                	mov    (%eax),%eax
    199d:	8b 10                	mov    (%eax),%edx
    199f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19a2:	89 10                	mov    %edx,(%eax)
    19a4:	eb 0a                	jmp    19b0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    19a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19a9:	8b 10                	mov    (%eax),%edx
    19ab:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19ae:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    19b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b3:	8b 40 04             	mov    0x4(%eax),%eax
    19b6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c0:	01 d0                	add    %edx,%eax
    19c2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19c5:	75 20                	jne    19e7 <free+0xcf>
    p->s.size += bp->s.size;
    19c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ca:	8b 50 04             	mov    0x4(%eax),%edx
    19cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19d0:	8b 40 04             	mov    0x4(%eax),%eax
    19d3:	01 c2                	add    %eax,%edx
    19d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19db:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19de:	8b 10                	mov    (%eax),%edx
    19e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e3:	89 10                	mov    %edx,(%eax)
    19e5:	eb 08                	jmp    19ef <free+0xd7>
  } else
    p->s.ptr = bp;
    19e7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ea:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19ed:	89 10                	mov    %edx,(%eax)
  freep = p;
    19ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f2:	a3 34 23 00 00       	mov    %eax,0x2334
}
    19f7:	c9                   	leave  
    19f8:	c3                   	ret    

000019f9 <morecore>:

static Header*
morecore(uint nu)
{
    19f9:	55                   	push   %ebp
    19fa:	89 e5                	mov    %esp,%ebp
    19fc:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    19ff:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1a06:	77 07                	ja     1a0f <morecore+0x16>
    nu = 4096;
    1a08:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1a0f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a12:	c1 e0 03             	shl    $0x3,%eax
    1a15:	89 04 24             	mov    %eax,(%esp)
    1a18:	e8 af fb ff ff       	call   15cc <sbrk>
    1a1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a20:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a24:	75 07                	jne    1a2d <morecore+0x34>
    return 0;
    1a26:	b8 00 00 00 00       	mov    $0x0,%eax
    1a2b:	eb 22                	jmp    1a4f <morecore+0x56>
  hp = (Header*)p;
    1a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a33:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a36:	8b 55 08             	mov    0x8(%ebp),%edx
    1a39:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a3f:	83 c0 08             	add    $0x8,%eax
    1a42:	89 04 24             	mov    %eax,(%esp)
    1a45:	e8 ce fe ff ff       	call   1918 <free>
  return freep;
    1a4a:	a1 34 23 00 00       	mov    0x2334,%eax
}
    1a4f:	c9                   	leave  
    1a50:	c3                   	ret    

00001a51 <malloc>:

void*
malloc(uint nbytes)
{
    1a51:	55                   	push   %ebp
    1a52:	89 e5                	mov    %esp,%ebp
    1a54:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a57:	8b 45 08             	mov    0x8(%ebp),%eax
    1a5a:	83 c0 07             	add    $0x7,%eax
    1a5d:	c1 e8 03             	shr    $0x3,%eax
    1a60:	40                   	inc    %eax
    1a61:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a64:	a1 34 23 00 00       	mov    0x2334,%eax
    1a69:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a70:	75 23                	jne    1a95 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1a72:	c7 45 f0 2c 23 00 00 	movl   $0x232c,-0x10(%ebp)
    1a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a7c:	a3 34 23 00 00       	mov    %eax,0x2334
    1a81:	a1 34 23 00 00       	mov    0x2334,%eax
    1a86:	a3 2c 23 00 00       	mov    %eax,0x232c
    base.s.size = 0;
    1a8b:	c7 05 30 23 00 00 00 	movl   $0x0,0x2330
    1a92:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a98:	8b 00                	mov    (%eax),%eax
    1a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aa0:	8b 40 04             	mov    0x4(%eax),%eax
    1aa3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1aa6:	72 4d                	jb     1af5 <malloc+0xa4>
      if(p->s.size == nunits)
    1aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aab:	8b 40 04             	mov    0x4(%eax),%eax
    1aae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ab1:	75 0c                	jne    1abf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab6:	8b 10                	mov    (%eax),%edx
    1ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1abb:	89 10                	mov    %edx,(%eax)
    1abd:	eb 26                	jmp    1ae5 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac2:	8b 40 04             	mov    0x4(%eax),%eax
    1ac5:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ac8:	89 c2                	mov    %eax,%edx
    1aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1acd:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad3:	8b 40 04             	mov    0x4(%eax),%eax
    1ad6:	c1 e0 03             	shl    $0x3,%eax
    1ad9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1adf:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1ae2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ae8:	a3 34 23 00 00       	mov    %eax,0x2334
      return (void*)(p + 1);
    1aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1af0:	83 c0 08             	add    $0x8,%eax
    1af3:	eb 38                	jmp    1b2d <malloc+0xdc>
    }
    if(p == freep)
    1af5:	a1 34 23 00 00       	mov    0x2334,%eax
    1afa:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1afd:	75 1b                	jne    1b1a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b02:	89 04 24             	mov    %eax,(%esp)
    1b05:	e8 ef fe ff ff       	call   19f9 <morecore>
    1b0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b0d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b11:	75 07                	jne    1b1a <malloc+0xc9>
        return 0;
    1b13:	b8 00 00 00 00       	mov    $0x0,%eax
    1b18:	eb 13                	jmp    1b2d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b23:	8b 00                	mov    (%eax),%eax
    1b25:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b28:	e9 70 ff ff ff       	jmp    1a9d <malloc+0x4c>
}
    1b2d:	c9                   	leave  
    1b2e:	c3                   	ret    
