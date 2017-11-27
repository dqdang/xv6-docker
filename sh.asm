
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
       c:	e8 63 15 00 00       	call   1574 <exit>

  switch(cmd->type){
      11:	8b 45 08             	mov    0x8(%ebp),%eax
      14:	8b 00                	mov    (%eax),%eax
      16:	83 f8 05             	cmp    $0x5,%eax
      19:	77 09                	ja     24 <runcmd+0x24>
      1b:	8b 04 85 6c 1b 00 00 	mov    0x1b6c(,%eax,4),%eax
      22:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
      24:	c7 04 24 40 1b 00 00 	movl   $0x1b40,(%esp)
      2b:	e8 05 04 00 00       	call   435 <panic>

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
      40:	e8 2f 15 00 00       	call   1574 <exit>
    exec(ecmd->argv[0], ecmd->argv);
      45:	8b 45 f4             	mov    -0xc(%ebp),%eax
      48:	8d 50 04             	lea    0x4(%eax),%edx
      4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
      4e:	8b 40 04             	mov    0x4(%eax),%eax
      51:	89 54 24 04          	mov    %edx,0x4(%esp)
      55:	89 04 24             	mov    %eax,(%esp)
      58:	e8 4f 15 00 00       	call   15ac <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
      5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
      60:	8b 40 04             	mov    0x4(%eax),%eax
      63:	89 44 24 08          	mov    %eax,0x8(%esp)
      67:	c7 44 24 04 47 1b 00 	movl   $0x1b47,0x4(%esp)
      6e:	00 
      6f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      76:	e8 fe 16 00 00       	call   1779 <printf>
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
      8f:	e8 08 15 00 00       	call   159c <close>
    if(open(rcmd->file, rcmd->mode) < 0){
      94:	8b 45 f0             	mov    -0x10(%ebp),%eax
      97:	8b 50 10             	mov    0x10(%eax),%edx
      9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
      9d:	8b 40 08             	mov    0x8(%eax),%eax
      a0:	89 54 24 04          	mov    %edx,0x4(%esp)
      a4:	89 04 24             	mov    %eax,(%esp)
      a7:	e8 08 15 00 00       	call   15b4 <open>
      ac:	85 c0                	test   %eax,%eax
      ae:	79 23                	jns    d3 <runcmd+0xd3>
      printf(2, "open %s failed\n", rcmd->file);
      b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
      b3:	8b 40 08             	mov    0x8(%eax),%eax
      b6:	89 44 24 08          	mov    %eax,0x8(%esp)
      ba:	c7 44 24 04 57 1b 00 	movl   $0x1b57,0x4(%esp)
      c1:	00 
      c2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      c9:	e8 ab 16 00 00       	call   1779 <printf>
      exit();
      ce:	e8 a1 14 00 00       	call   1574 <exit>
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
      ec:	e8 6a 03 00 00       	call   45b <fork1>
      f1:	85 c0                	test   %eax,%eax
      f3:	75 0e                	jne    103 <runcmd+0x103>
      runcmd(lcmd->left);
      f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f8:	8b 40 04             	mov    0x4(%eax),%eax
      fb:	89 04 24             	mov    %eax,(%esp)
      fe:	e8 fd fe ff ff       	call   0 <runcmd>
    wait();
     103:	e8 74 14 00 00       	call   157c <wait>
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
     127:	e8 58 14 00 00       	call   1584 <pipe>
     12c:	85 c0                	test   %eax,%eax
     12e:	79 0c                	jns    13c <runcmd+0x13c>
      panic("pipe");
     130:	c7 04 24 67 1b 00 00 	movl   $0x1b67,(%esp)
     137:	e8 f9 02 00 00       	call   435 <panic>
    if(fork1() == 0){
     13c:	e8 1a 03 00 00       	call   45b <fork1>
     141:	85 c0                	test   %eax,%eax
     143:	75 3b                	jne    180 <runcmd+0x180>
      close(1);
     145:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     14c:	e8 4b 14 00 00       	call   159c <close>
      dup(p[1]);
     151:	8b 45 e0             	mov    -0x20(%ebp),%eax
     154:	89 04 24             	mov    %eax,(%esp)
     157:	e8 90 14 00 00       	call   15ec <dup>
      close(p[0]);
     15c:	8b 45 dc             	mov    -0x24(%ebp),%eax
     15f:	89 04 24             	mov    %eax,(%esp)
     162:	e8 35 14 00 00       	call   159c <close>
      close(p[1]);
     167:	8b 45 e0             	mov    -0x20(%ebp),%eax
     16a:	89 04 24             	mov    %eax,(%esp)
     16d:	e8 2a 14 00 00       	call   159c <close>
      runcmd(pcmd->left);
     172:	8b 45 e8             	mov    -0x18(%ebp),%eax
     175:	8b 40 04             	mov    0x4(%eax),%eax
     178:	89 04 24             	mov    %eax,(%esp)
     17b:	e8 80 fe ff ff       	call   0 <runcmd>
    }
    if(fork1() == 0){
     180:	e8 d6 02 00 00       	call   45b <fork1>
     185:	85 c0                	test   %eax,%eax
     187:	75 3b                	jne    1c4 <runcmd+0x1c4>
      close(0);
     189:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     190:	e8 07 14 00 00       	call   159c <close>
      dup(p[0]);
     195:	8b 45 dc             	mov    -0x24(%ebp),%eax
     198:	89 04 24             	mov    %eax,(%esp)
     19b:	e8 4c 14 00 00       	call   15ec <dup>
      close(p[0]);
     1a0:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1a3:	89 04 24             	mov    %eax,(%esp)
     1a6:	e8 f1 13 00 00       	call   159c <close>
      close(p[1]);
     1ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1ae:	89 04 24             	mov    %eax,(%esp)
     1b1:	e8 e6 13 00 00       	call   159c <close>
      runcmd(pcmd->right);
     1b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     1b9:	8b 40 08             	mov    0x8(%eax),%eax
     1bc:	89 04 24             	mov    %eax,(%esp)
     1bf:	e8 3c fe ff ff       	call   0 <runcmd>
    }
    close(p[0]);
     1c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
     1c7:	89 04 24             	mov    %eax,(%esp)
     1ca:	e8 cd 13 00 00       	call   159c <close>
    close(p[1]);
     1cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
     1d2:	89 04 24             	mov    %eax,(%esp)
     1d5:	e8 c2 13 00 00       	call   159c <close>
    wait();
     1da:	e8 9d 13 00 00       	call   157c <wait>
    wait();
     1df:	e8 98 13 00 00       	call   157c <wait>
    break;
     1e4:	eb 20                	jmp    206 <runcmd+0x206>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     1e6:	8b 45 08             	mov    0x8(%ebp),%eax
     1e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     1ec:	e8 6a 02 00 00       	call   45b <fork1>
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
     206:	e8 69 13 00 00       	call   1574 <exit>

0000020b <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     20b:	55                   	push   %ebp
     20c:	89 e5                	mov    %esp,%ebp
     20e:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     211:	c7 44 24 04 84 1b 00 	movl   $0x1b84,0x4(%esp)
     218:	00 
     219:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     220:	e8 54 15 00 00       	call   1779 <printf>
  memset(buf, 0, nbuf);
     225:	8b 45 0c             	mov    0xc(%ebp),%eax
     228:	89 44 24 08          	mov    %eax,0x8(%esp)
     22c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     233:	00 
     234:	8b 45 08             	mov    0x8(%ebp),%eax
     237:	89 04 24             	mov    %eax,(%esp)
     23a:	e8 83 0d 00 00       	call   fc2 <memset>
  gets(buf, nbuf);
     23f:	8b 45 0c             	mov    0xc(%ebp),%eax
     242:	89 44 24 04          	mov    %eax,0x4(%esp)
     246:	8b 45 08             	mov    0x8(%ebp),%eax
     249:	89 04 24             	mov    %eax,(%esp)
     24c:	e8 d3 11 00 00       	call   1424 <gets>
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

00000268 <atroot>:

int atroot(char *fs){
     268:	55                   	push   %ebp
     269:	89 e5                	mov    %esp,%ebp
     26b:	81 ec 18 02 00 00    	sub    $0x218,%esp
  char path[512];
  getcwd(path, 512);
     271:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
     278:	00 
     279:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
     27f:	89 04 24             	mov    %eax,(%esp)
     282:	e8 0d 14 00 00       	call   1694 <getcwd>
  if(strcmp(fs, path) == 0){
     287:	8d 85 f8 fd ff ff    	lea    -0x208(%ebp),%eax
     28d:	89 44 24 04          	mov    %eax,0x4(%esp)
     291:	8b 45 08             	mov    0x8(%ebp),%eax
     294:	89 04 24             	mov    %eax,(%esp)
     297:	e8 7b 0c 00 00       	call   f17 <strcmp>
     29c:	85 c0                	test   %eax,%eax
     29e:	75 07                	jne    2a7 <atroot+0x3f>
    return 1;
     2a0:	b8 01 00 00 00       	mov    $0x1,%eax
     2a5:	eb 05                	jmp    2ac <atroot+0x44>
  }

  return 0;
     2a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2ac:	c9                   	leave  
     2ad:	c3                   	ret    

000002ae <main>:

int
main(void)
{
     2ae:	55                   	push   %ebp
     2af:	89 e5                	mov    %esp,%ebp
     2b1:	83 e4 f0             	and    $0xfffffff0,%esp
     2b4:	83 ec 40             	sub    $0x40,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     2b7:	eb 15                	jmp    2ce <main+0x20>
    if(fd >= 3){
     2b9:	83 7c 24 3c 02       	cmpl   $0x2,0x3c(%esp)
     2be:	7e 0e                	jle    2ce <main+0x20>
      close(fd);
     2c0:	8b 44 24 3c          	mov    0x3c(%esp),%eax
     2c4:	89 04 24             	mov    %eax,(%esp)
     2c7:	e8 d0 12 00 00       	call   159c <close>
      break;
     2cc:	eb 1f                	jmp    2ed <main+0x3f>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     2ce:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     2d5:	00 
     2d6:	c7 04 24 87 1b 00 00 	movl   $0x1b87,(%esp)
     2dd:	e8 d2 12 00 00       	call   15b4 <open>
     2e2:	89 44 24 3c          	mov    %eax,0x3c(%esp)
     2e6:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
     2eb:	79 cc                	jns    2b9 <main+0xb>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     2ed:	e9 22 01 00 00       	jmp    414 <main+0x166>
    char fs[32];
    getactivefs(fs);
     2f2:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     2f6:	89 04 24             	mov    %eax,(%esp)
     2f9:	e8 86 13 00 00       	call   1684 <getactivefs>
    if((buf[0] == 'c' && buf[1] == 'd' && buf[2] == 10) || ((strcmp("cd ..", buf) == 0) && atroot(fs))){
     2fe:	a0 e0 22 00 00       	mov    0x22e0,%al
     303:	3c 63                	cmp    $0x63,%al
     305:	75 12                	jne    319 <main+0x6b>
     307:	a0 e1 22 00 00       	mov    0x22e1,%al
     30c:	3c 64                	cmp    $0x64,%al
     30e:	75 09                	jne    319 <main+0x6b>
     310:	a0 e2 22 00 00       	mov    0x22e2,%al
     315:	3c 0a                	cmp    $0xa,%al
     317:	74 28                	je     341 <main+0x93>
     319:	c7 44 24 04 e0 22 00 	movl   $0x22e0,0x4(%esp)
     320:	00 
     321:	c7 04 24 8f 1b 00 00 	movl   $0x1b8f,(%esp)
     328:	e8 ea 0b 00 00       	call   f17 <strcmp>
     32d:	85 c0                	test   %eax,%eax
     32f:	75 62                	jne    393 <main+0xe5>
     331:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     335:	89 04 24             	mov    %eax,(%esp)
     338:	e8 2b ff ff ff       	call   268 <atroot>
     33d:	85 c0                	test   %eax,%eax
     33f:	74 52                	je     393 <main+0xe5>
      printf(1, "fs = %s\n", fs);
     341:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     345:	89 44 24 08          	mov    %eax,0x8(%esp)
     349:	c7 44 24 04 95 1b 00 	movl   $0x1b95,0x4(%esp)
     350:	00 
     351:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     358:	e8 1c 14 00 00       	call   1779 <printf>
      if(chdir(fs) < 0)
     35d:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     361:	89 04 24             	mov    %eax,(%esp)
     364:	e8 7b 12 00 00       	call   15e4 <chdir>
     369:	85 c0                	test   %eax,%eax
     36b:	79 21                	jns    38e <main+0xe0>
        printf(2, "cannot cd %s\n", fs);
     36d:	8d 44 24 1c          	lea    0x1c(%esp),%eax
     371:	89 44 24 08          	mov    %eax,0x8(%esp)
     375:	c7 44 24 04 9e 1b 00 	movl   $0x1b9e,0x4(%esp)
     37c:	00 
     37d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     384:	e8 f0 13 00 00       	call   1779 <printf>
      continue;
     389:	e9 86 00 00 00       	jmp    414 <main+0x166>
     38e:	e9 81 00 00 00       	jmp    414 <main+0x166>
    }
    else if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     393:	a0 e0 22 00 00       	mov    0x22e0,%al
     398:	3c 63                	cmp    $0x63,%al
     39a:	75 56                	jne    3f2 <main+0x144>
     39c:	a0 e1 22 00 00       	mov    0x22e1,%al
     3a1:	3c 64                	cmp    $0x64,%al
     3a3:	75 4d                	jne    3f2 <main+0x144>
     3a5:	a0 e2 22 00 00       	mov    0x22e2,%al
     3aa:	3c 20                	cmp    $0x20,%al
     3ac:	75 44                	jne    3f2 <main+0x144>
      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     3ae:	c7 04 24 e0 22 00 00 	movl   $0x22e0,(%esp)
     3b5:	e8 e3 0b 00 00       	call   f9d <strlen>
     3ba:	48                   	dec    %eax
     3bb:	c6 80 e0 22 00 00 00 	movb   $0x0,0x22e0(%eax)
      if(chdir(buf+3) < 0)
     3c2:	c7 04 24 e3 22 00 00 	movl   $0x22e3,(%esp)
     3c9:	e8 16 12 00 00       	call   15e4 <chdir>
     3ce:	85 c0                	test   %eax,%eax
     3d0:	79 1e                	jns    3f0 <main+0x142>
        printf(2, "cannot cd %s\n", buf+3);
     3d2:	c7 44 24 08 e3 22 00 	movl   $0x22e3,0x8(%esp)
     3d9:	00 
     3da:	c7 44 24 04 9e 1b 00 	movl   $0x1b9e,0x4(%esp)
     3e1:	00 
     3e2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     3e9:	e8 8b 13 00 00       	call   1779 <printf>
      continue;
     3ee:	eb 24                	jmp    414 <main+0x166>
     3f0:	eb 22                	jmp    414 <main+0x166>
    }
    if(fork1() == 0)
     3f2:	e8 64 00 00 00       	call   45b <fork1>
     3f7:	85 c0                	test   %eax,%eax
     3f9:	75 14                	jne    40f <main+0x161>
      runcmd(parsecmd(buf));
     3fb:	c7 04 24 e0 22 00 00 	movl   $0x22e0,(%esp)
     402:	e8 b8 03 00 00       	call   7bf <parsecmd>
     407:	89 04 24             	mov    %eax,(%esp)
     40a:	e8 f1 fb ff ff       	call   0 <runcmd>
    wait();
     40f:	e8 68 11 00 00       	call   157c <wait>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     414:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     41b:	00 
     41c:	c7 04 24 e0 22 00 00 	movl   $0x22e0,(%esp)
     423:	e8 e3 fd ff ff       	call   20b <getcmd>
     428:	85 c0                	test   %eax,%eax
     42a:	0f 89 c2 fe ff ff    	jns    2f2 <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     430:	e8 3f 11 00 00       	call   1574 <exit>

00000435 <panic>:
}

void
panic(char *s)
{
     435:	55                   	push   %ebp
     436:	89 e5                	mov    %esp,%ebp
     438:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     43b:	8b 45 08             	mov    0x8(%ebp),%eax
     43e:	89 44 24 08          	mov    %eax,0x8(%esp)
     442:	c7 44 24 04 ac 1b 00 	movl   $0x1bac,0x4(%esp)
     449:	00 
     44a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     451:	e8 23 13 00 00       	call   1779 <printf>
  exit();
     456:	e8 19 11 00 00       	call   1574 <exit>

0000045b <fork1>:
}

int
fork1(void)
{
     45b:	55                   	push   %ebp
     45c:	89 e5                	mov    %esp,%ebp
     45e:	83 ec 28             	sub    $0x28,%esp
  int pid;

  pid = fork();
     461:	e8 06 11 00 00       	call   156c <fork>
     466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     469:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     46d:	75 0c                	jne    47b <fork1+0x20>
    panic("fork");
     46f:	c7 04 24 b0 1b 00 00 	movl   $0x1bb0,(%esp)
     476:	e8 ba ff ff ff       	call   435 <panic>
  return pid;
     47b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     47e:	c9                   	leave  
     47f:	c3                   	ret    

00000480 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     480:	55                   	push   %ebp
     481:	89 e5                	mov    %esp,%ebp
     483:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     486:	c7 04 24 a4 00 00 00 	movl   $0xa4,(%esp)
     48d:	e8 cf 15 00 00       	call   1a61 <malloc>
     492:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     495:	c7 44 24 08 a4 00 00 	movl   $0xa4,0x8(%esp)
     49c:	00 
     49d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4a4:	00 
     4a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4a8:	89 04 24             	mov    %eax,(%esp)
     4ab:	e8 12 0b 00 00       	call   fc2 <memset>
  cmd->type = EXEC;
     4b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4b3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     4b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     4bc:	c9                   	leave  
     4bd:	c3                   	ret    

000004be <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     4be:	55                   	push   %ebp
     4bf:	89 e5                	mov    %esp,%ebp
     4c1:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4c4:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     4cb:	e8 91 15 00 00       	call   1a61 <malloc>
     4d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     4d3:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     4da:	00 
     4db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     4e2:	00 
     4e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4e6:	89 04 24             	mov    %eax,(%esp)
     4e9:	e8 d4 0a 00 00       	call   fc2 <memset>
  cmd->type = REDIR;
     4ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4f1:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     4f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     4fa:	8b 55 08             	mov    0x8(%ebp),%edx
     4fd:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     500:	8b 45 f4             	mov    -0xc(%ebp),%eax
     503:	8b 55 0c             	mov    0xc(%ebp),%edx
     506:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     509:	8b 45 f4             	mov    -0xc(%ebp),%eax
     50c:	8b 55 10             	mov    0x10(%ebp),%edx
     50f:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     512:	8b 45 f4             	mov    -0xc(%ebp),%eax
     515:	8b 55 14             	mov    0x14(%ebp),%edx
     518:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     51b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     51e:	8b 55 18             	mov    0x18(%ebp),%edx
     521:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     524:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     527:	c9                   	leave  
     528:	c3                   	ret    

00000529 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     529:	55                   	push   %ebp
     52a:	89 e5                	mov    %esp,%ebp
     52c:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     52f:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     536:	e8 26 15 00 00       	call   1a61 <malloc>
     53b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     53e:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     545:	00 
     546:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     54d:	00 
     54e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     551:	89 04 24             	mov    %eax,(%esp)
     554:	e8 69 0a 00 00       	call   fc2 <memset>
  cmd->type = PIPE;
     559:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55c:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     562:	8b 45 f4             	mov    -0xc(%ebp),%eax
     565:	8b 55 08             	mov    0x8(%ebp),%edx
     568:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     56b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     56e:	8b 55 0c             	mov    0xc(%ebp),%edx
     571:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     574:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     577:	c9                   	leave  
     578:	c3                   	ret    

00000579 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     579:	55                   	push   %ebp
     57a:	89 e5                	mov    %esp,%ebp
     57c:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     57f:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     586:	e8 d6 14 00 00       	call   1a61 <malloc>
     58b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     58e:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     595:	00 
     596:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     59d:	00 
     59e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5a1:	89 04 24             	mov    %eax,(%esp)
     5a4:	e8 19 0a 00 00       	call   fc2 <memset>
  cmd->type = LIST;
     5a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5ac:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     5b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5b5:	8b 55 08             	mov    0x8(%ebp),%edx
     5b8:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     5bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5be:	8b 55 0c             	mov    0xc(%ebp),%edx
     5c1:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     5c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5c7:	c9                   	leave  
     5c8:	c3                   	ret    

000005c9 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     5c9:	55                   	push   %ebp
     5ca:	89 e5                	mov    %esp,%ebp
     5cc:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5cf:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     5d6:	e8 86 14 00 00       	call   1a61 <malloc>
     5db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     5de:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     5e5:	00 
     5e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5ed:	00 
     5ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5f1:	89 04 24             	mov    %eax,(%esp)
     5f4:	e8 c9 09 00 00       	call   fc2 <memset>
  cmd->type = BACK;
     5f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5fc:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     602:	8b 45 f4             	mov    -0xc(%ebp),%eax
     605:	8b 55 08             	mov    0x8(%ebp),%edx
     608:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     60b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     60e:	c9                   	leave  
     60f:	c3                   	ret    

00000610 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     610:	55                   	push   %ebp
     611:	89 e5                	mov    %esp,%ebp
     613:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;

  s = *ps;
     616:	8b 45 08             	mov    0x8(%ebp),%eax
     619:	8b 00                	mov    (%eax),%eax
     61b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     61e:	eb 03                	jmp    623 <gettoken+0x13>
    s++;
     620:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     623:	8b 45 f4             	mov    -0xc(%ebp),%eax
     626:	3b 45 0c             	cmp    0xc(%ebp),%eax
     629:	73 1c                	jae    647 <gettoken+0x37>
     62b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     62e:	8a 00                	mov    (%eax),%al
     630:	0f be c0             	movsbl %al,%eax
     633:	89 44 24 04          	mov    %eax,0x4(%esp)
     637:	c7 04 24 60 22 00 00 	movl   $0x2260,(%esp)
     63e:	e8 a3 09 00 00       	call   fe6 <strchr>
     643:	85 c0                	test   %eax,%eax
     645:	75 d9                	jne    620 <gettoken+0x10>
    s++;
  if(q)
     647:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     64b:	74 08                	je     655 <gettoken+0x45>
    *q = s;
     64d:	8b 45 10             	mov    0x10(%ebp),%eax
     650:	8b 55 f4             	mov    -0xc(%ebp),%edx
     653:	89 10                	mov    %edx,(%eax)
  ret = *s;
     655:	8b 45 f4             	mov    -0xc(%ebp),%eax
     658:	8a 00                	mov    (%eax),%al
     65a:	0f be c0             	movsbl %al,%eax
     65d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     660:	8b 45 f4             	mov    -0xc(%ebp),%eax
     663:	8a 00                	mov    (%eax),%al
     665:	0f be c0             	movsbl %al,%eax
     668:	83 f8 29             	cmp    $0x29,%eax
     66b:	7f 14                	jg     681 <gettoken+0x71>
     66d:	83 f8 28             	cmp    $0x28,%eax
     670:	7d 28                	jge    69a <gettoken+0x8a>
     672:	85 c0                	test   %eax,%eax
     674:	0f 84 8d 00 00 00    	je     707 <gettoken+0xf7>
     67a:	83 f8 26             	cmp    $0x26,%eax
     67d:	74 1b                	je     69a <gettoken+0x8a>
     67f:	eb 38                	jmp    6b9 <gettoken+0xa9>
     681:	83 f8 3e             	cmp    $0x3e,%eax
     684:	74 19                	je     69f <gettoken+0x8f>
     686:	83 f8 3e             	cmp    $0x3e,%eax
     689:	7f 0a                	jg     695 <gettoken+0x85>
     68b:	83 e8 3b             	sub    $0x3b,%eax
     68e:	83 f8 01             	cmp    $0x1,%eax
     691:	77 26                	ja     6b9 <gettoken+0xa9>
     693:	eb 05                	jmp    69a <gettoken+0x8a>
     695:	83 f8 7c             	cmp    $0x7c,%eax
     698:	75 1f                	jne    6b9 <gettoken+0xa9>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     69a:	ff 45 f4             	incl   -0xc(%ebp)
    break;
     69d:	eb 69                	jmp    708 <gettoken+0xf8>
  case '>':
    s++;
     69f:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
     6a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a5:	8a 00                	mov    (%eax),%al
     6a7:	3c 3e                	cmp    $0x3e,%al
     6a9:	75 0c                	jne    6b7 <gettoken+0xa7>
      ret = '+';
     6ab:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     6b2:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
     6b5:	eb 51                	jmp    708 <gettoken+0xf8>
     6b7:	eb 4f                	jmp    708 <gettoken+0xf8>
  default:
    ret = 'a';
     6b9:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     6c0:	eb 03                	jmp    6c5 <gettoken+0xb5>
      s++;
     6c2:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     6c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c8:	3b 45 0c             	cmp    0xc(%ebp),%eax
     6cb:	73 38                	jae    705 <gettoken+0xf5>
     6cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6d0:	8a 00                	mov    (%eax),%al
     6d2:	0f be c0             	movsbl %al,%eax
     6d5:	89 44 24 04          	mov    %eax,0x4(%esp)
     6d9:	c7 04 24 60 22 00 00 	movl   $0x2260,(%esp)
     6e0:	e8 01 09 00 00       	call   fe6 <strchr>
     6e5:	85 c0                	test   %eax,%eax
     6e7:	75 1c                	jne    705 <gettoken+0xf5>
     6e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6ec:	8a 00                	mov    (%eax),%al
     6ee:	0f be c0             	movsbl %al,%eax
     6f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     6f5:	c7 04 24 66 22 00 00 	movl   $0x2266,(%esp)
     6fc:	e8 e5 08 00 00       	call   fe6 <strchr>
     701:	85 c0                	test   %eax,%eax
     703:	74 bd                	je     6c2 <gettoken+0xb2>
      s++;
    break;
     705:	eb 01                	jmp    708 <gettoken+0xf8>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     707:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     708:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     70c:	74 0a                	je     718 <gettoken+0x108>
    *eq = s;
     70e:	8b 45 14             	mov    0x14(%ebp),%eax
     711:	8b 55 f4             	mov    -0xc(%ebp),%edx
     714:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     716:	eb 05                	jmp    71d <gettoken+0x10d>
     718:	eb 03                	jmp    71d <gettoken+0x10d>
    s++;
     71a:	ff 45 f4             	incl   -0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     71d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     720:	3b 45 0c             	cmp    0xc(%ebp),%eax
     723:	73 1c                	jae    741 <gettoken+0x131>
     725:	8b 45 f4             	mov    -0xc(%ebp),%eax
     728:	8a 00                	mov    (%eax),%al
     72a:	0f be c0             	movsbl %al,%eax
     72d:	89 44 24 04          	mov    %eax,0x4(%esp)
     731:	c7 04 24 60 22 00 00 	movl   $0x2260,(%esp)
     738:	e8 a9 08 00 00       	call   fe6 <strchr>
     73d:	85 c0                	test   %eax,%eax
     73f:	75 d9                	jne    71a <gettoken+0x10a>
    s++;
  *ps = s;
     741:	8b 45 08             	mov    0x8(%ebp),%eax
     744:	8b 55 f4             	mov    -0xc(%ebp),%edx
     747:	89 10                	mov    %edx,(%eax)
  return ret;
     749:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     74c:	c9                   	leave  
     74d:	c3                   	ret    

0000074e <peek>:

int
peek(char **ps, char *es, char *toks)
{
     74e:	55                   	push   %ebp
     74f:	89 e5                	mov    %esp,%ebp
     751:	83 ec 28             	sub    $0x28,%esp
  char *s;

  s = *ps;
     754:	8b 45 08             	mov    0x8(%ebp),%eax
     757:	8b 00                	mov    (%eax),%eax
     759:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     75c:	eb 03                	jmp    761 <peek+0x13>
    s++;
     75e:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     761:	8b 45 f4             	mov    -0xc(%ebp),%eax
     764:	3b 45 0c             	cmp    0xc(%ebp),%eax
     767:	73 1c                	jae    785 <peek+0x37>
     769:	8b 45 f4             	mov    -0xc(%ebp),%eax
     76c:	8a 00                	mov    (%eax),%al
     76e:	0f be c0             	movsbl %al,%eax
     771:	89 44 24 04          	mov    %eax,0x4(%esp)
     775:	c7 04 24 60 22 00 00 	movl   $0x2260,(%esp)
     77c:	e8 65 08 00 00       	call   fe6 <strchr>
     781:	85 c0                	test   %eax,%eax
     783:	75 d9                	jne    75e <peek+0x10>
    s++;
  *ps = s;
     785:	8b 45 08             	mov    0x8(%ebp),%eax
     788:	8b 55 f4             	mov    -0xc(%ebp),%edx
     78b:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     790:	8a 00                	mov    (%eax),%al
     792:	84 c0                	test   %al,%al
     794:	74 22                	je     7b8 <peek+0x6a>
     796:	8b 45 f4             	mov    -0xc(%ebp),%eax
     799:	8a 00                	mov    (%eax),%al
     79b:	0f be c0             	movsbl %al,%eax
     79e:	89 44 24 04          	mov    %eax,0x4(%esp)
     7a2:	8b 45 10             	mov    0x10(%ebp),%eax
     7a5:	89 04 24             	mov    %eax,(%esp)
     7a8:	e8 39 08 00 00       	call   fe6 <strchr>
     7ad:	85 c0                	test   %eax,%eax
     7af:	74 07                	je     7b8 <peek+0x6a>
     7b1:	b8 01 00 00 00       	mov    $0x1,%eax
     7b6:	eb 05                	jmp    7bd <peek+0x6f>
     7b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
     7bd:	c9                   	leave  
     7be:	c3                   	ret    

000007bf <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     7bf:	55                   	push   %ebp
     7c0:	89 e5                	mov    %esp,%ebp
     7c2:	53                   	push   %ebx
     7c3:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     7c6:	8b 5d 08             	mov    0x8(%ebp),%ebx
     7c9:	8b 45 08             	mov    0x8(%ebp),%eax
     7cc:	89 04 24             	mov    %eax,(%esp)
     7cf:	e8 c9 07 00 00       	call   f9d <strlen>
     7d4:	01 d8                	add    %ebx,%eax
     7d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     7d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7dc:	89 44 24 04          	mov    %eax,0x4(%esp)
     7e0:	8d 45 08             	lea    0x8(%ebp),%eax
     7e3:	89 04 24             	mov    %eax,(%esp)
     7e6:	e8 60 00 00 00       	call   84b <parseline>
     7eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     7ee:	c7 44 24 08 b5 1b 00 	movl   $0x1bb5,0x8(%esp)
     7f5:	00 
     7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f9:	89 44 24 04          	mov    %eax,0x4(%esp)
     7fd:	8d 45 08             	lea    0x8(%ebp),%eax
     800:	89 04 24             	mov    %eax,(%esp)
     803:	e8 46 ff ff ff       	call   74e <peek>
  if(s != es){
     808:	8b 45 08             	mov    0x8(%ebp),%eax
     80b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     80e:	74 27                	je     837 <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     810:	8b 45 08             	mov    0x8(%ebp),%eax
     813:	89 44 24 08          	mov    %eax,0x8(%esp)
     817:	c7 44 24 04 b6 1b 00 	movl   $0x1bb6,0x4(%esp)
     81e:	00 
     81f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     826:	e8 4e 0f 00 00       	call   1779 <printf>
    panic("syntax");
     82b:	c7 04 24 c5 1b 00 00 	movl   $0x1bc5,(%esp)
     832:	e8 fe fb ff ff       	call   435 <panic>
  }
  nulterminate(cmd);
     837:	8b 45 f0             	mov    -0x10(%ebp),%eax
     83a:	89 04 24             	mov    %eax,(%esp)
     83d:	e8 a2 04 00 00       	call   ce4 <nulterminate>
  return cmd;
     842:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     845:	83 c4 24             	add    $0x24,%esp
     848:	5b                   	pop    %ebx
     849:	5d                   	pop    %ebp
     84a:	c3                   	ret    

0000084b <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     84b:	55                   	push   %ebp
     84c:	89 e5                	mov    %esp,%ebp
     84e:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     851:	8b 45 0c             	mov    0xc(%ebp),%eax
     854:	89 44 24 04          	mov    %eax,0x4(%esp)
     858:	8b 45 08             	mov    0x8(%ebp),%eax
     85b:	89 04 24             	mov    %eax,(%esp)
     85e:	e8 bc 00 00 00       	call   91f <parsepipe>
     863:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     866:	eb 30                	jmp    898 <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     868:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     86f:	00 
     870:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     877:	00 
     878:	8b 45 0c             	mov    0xc(%ebp),%eax
     87b:	89 44 24 04          	mov    %eax,0x4(%esp)
     87f:	8b 45 08             	mov    0x8(%ebp),%eax
     882:	89 04 24             	mov    %eax,(%esp)
     885:	e8 86 fd ff ff       	call   610 <gettoken>
    cmd = backcmd(cmd);
     88a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     88d:	89 04 24             	mov    %eax,(%esp)
     890:	e8 34 fd ff ff       	call   5c9 <backcmd>
     895:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     898:	c7 44 24 08 cc 1b 00 	movl   $0x1bcc,0x8(%esp)
     89f:	00 
     8a0:	8b 45 0c             	mov    0xc(%ebp),%eax
     8a3:	89 44 24 04          	mov    %eax,0x4(%esp)
     8a7:	8b 45 08             	mov    0x8(%ebp),%eax
     8aa:	89 04 24             	mov    %eax,(%esp)
     8ad:	e8 9c fe ff ff       	call   74e <peek>
     8b2:	85 c0                	test   %eax,%eax
     8b4:	75 b2                	jne    868 <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     8b6:	c7 44 24 08 ce 1b 00 	movl   $0x1bce,0x8(%esp)
     8bd:	00 
     8be:	8b 45 0c             	mov    0xc(%ebp),%eax
     8c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c5:	8b 45 08             	mov    0x8(%ebp),%eax
     8c8:	89 04 24             	mov    %eax,(%esp)
     8cb:	e8 7e fe ff ff       	call   74e <peek>
     8d0:	85 c0                	test   %eax,%eax
     8d2:	74 46                	je     91a <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     8d4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     8db:	00 
     8dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     8e3:	00 
     8e4:	8b 45 0c             	mov    0xc(%ebp),%eax
     8e7:	89 44 24 04          	mov    %eax,0x4(%esp)
     8eb:	8b 45 08             	mov    0x8(%ebp),%eax
     8ee:	89 04 24             	mov    %eax,(%esp)
     8f1:	e8 1a fd ff ff       	call   610 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     8f6:	8b 45 0c             	mov    0xc(%ebp),%eax
     8f9:	89 44 24 04          	mov    %eax,0x4(%esp)
     8fd:	8b 45 08             	mov    0x8(%ebp),%eax
     900:	89 04 24             	mov    %eax,(%esp)
     903:	e8 43 ff ff ff       	call   84b <parseline>
     908:	89 44 24 04          	mov    %eax,0x4(%esp)
     90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     90f:	89 04 24             	mov    %eax,(%esp)
     912:	e8 62 fc ff ff       	call   579 <listcmd>
     917:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     91a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     91d:	c9                   	leave  
     91e:	c3                   	ret    

0000091f <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     91f:	55                   	push   %ebp
     920:	89 e5                	mov    %esp,%ebp
     922:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     925:	8b 45 0c             	mov    0xc(%ebp),%eax
     928:	89 44 24 04          	mov    %eax,0x4(%esp)
     92c:	8b 45 08             	mov    0x8(%ebp),%eax
     92f:	89 04 24             	mov    %eax,(%esp)
     932:	e8 68 02 00 00       	call   b9f <parseexec>
     937:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     93a:	c7 44 24 08 d0 1b 00 	movl   $0x1bd0,0x8(%esp)
     941:	00 
     942:	8b 45 0c             	mov    0xc(%ebp),%eax
     945:	89 44 24 04          	mov    %eax,0x4(%esp)
     949:	8b 45 08             	mov    0x8(%ebp),%eax
     94c:	89 04 24             	mov    %eax,(%esp)
     94f:	e8 fa fd ff ff       	call   74e <peek>
     954:	85 c0                	test   %eax,%eax
     956:	74 46                	je     99e <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     958:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     95f:	00 
     960:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     967:	00 
     968:	8b 45 0c             	mov    0xc(%ebp),%eax
     96b:	89 44 24 04          	mov    %eax,0x4(%esp)
     96f:	8b 45 08             	mov    0x8(%ebp),%eax
     972:	89 04 24             	mov    %eax,(%esp)
     975:	e8 96 fc ff ff       	call   610 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     97a:	8b 45 0c             	mov    0xc(%ebp),%eax
     97d:	89 44 24 04          	mov    %eax,0x4(%esp)
     981:	8b 45 08             	mov    0x8(%ebp),%eax
     984:	89 04 24             	mov    %eax,(%esp)
     987:	e8 93 ff ff ff       	call   91f <parsepipe>
     98c:	89 44 24 04          	mov    %eax,0x4(%esp)
     990:	8b 45 f4             	mov    -0xc(%ebp),%eax
     993:	89 04 24             	mov    %eax,(%esp)
     996:	e8 8e fb ff ff       	call   529 <pipecmd>
     99b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     99e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     9a1:	c9                   	leave  
     9a2:	c3                   	ret    

000009a3 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     9a3:	55                   	push   %ebp
     9a4:	89 e5                	mov    %esp,%ebp
     9a6:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     9a9:	e9 f6 00 00 00       	jmp    aa4 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     9ae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     9b5:	00 
     9b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     9bd:	00 
     9be:	8b 45 10             	mov    0x10(%ebp),%eax
     9c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     9c5:	8b 45 0c             	mov    0xc(%ebp),%eax
     9c8:	89 04 24             	mov    %eax,(%esp)
     9cb:	e8 40 fc ff ff       	call   610 <gettoken>
     9d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     9d3:	8d 45 ec             	lea    -0x14(%ebp),%eax
     9d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
     9da:	8d 45 f0             	lea    -0x10(%ebp),%eax
     9dd:	89 44 24 08          	mov    %eax,0x8(%esp)
     9e1:	8b 45 10             	mov    0x10(%ebp),%eax
     9e4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e8:	8b 45 0c             	mov    0xc(%ebp),%eax
     9eb:	89 04 24             	mov    %eax,(%esp)
     9ee:	e8 1d fc ff ff       	call   610 <gettoken>
     9f3:	83 f8 61             	cmp    $0x61,%eax
     9f6:	74 0c                	je     a04 <parseredirs+0x61>
      panic("missing file for redirection");
     9f8:	c7 04 24 d2 1b 00 00 	movl   $0x1bd2,(%esp)
     9ff:	e8 31 fa ff ff       	call   435 <panic>
    switch(tok){
     a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a07:	83 f8 3c             	cmp    $0x3c,%eax
     a0a:	74 0f                	je     a1b <parseredirs+0x78>
     a0c:	83 f8 3e             	cmp    $0x3e,%eax
     a0f:	74 38                	je     a49 <parseredirs+0xa6>
     a11:	83 f8 2b             	cmp    $0x2b,%eax
     a14:	74 61                	je     a77 <parseredirs+0xd4>
     a16:	e9 89 00 00 00       	jmp    aa4 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a21:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     a28:	00 
     a29:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a30:	00 
     a31:	89 54 24 08          	mov    %edx,0x8(%esp)
     a35:	89 44 24 04          	mov    %eax,0x4(%esp)
     a39:	8b 45 08             	mov    0x8(%ebp),%eax
     a3c:	89 04 24             	mov    %eax,(%esp)
     a3f:	e8 7a fa ff ff       	call   4be <redircmd>
     a44:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a47:	eb 5b                	jmp    aa4 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a49:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a4f:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     a56:	00 
     a57:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     a5e:	00 
     a5f:	89 54 24 08          	mov    %edx,0x8(%esp)
     a63:	89 44 24 04          	mov    %eax,0x4(%esp)
     a67:	8b 45 08             	mov    0x8(%ebp),%eax
     a6a:	89 04 24             	mov    %eax,(%esp)
     a6d:	e8 4c fa ff ff       	call   4be <redircmd>
     a72:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     a75:	eb 2d                	jmp    aa4 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     a77:	8b 55 ec             	mov    -0x14(%ebp),%edx
     a7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     a7d:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     a84:	00 
     a85:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     a8c:	00 
     a8d:	89 54 24 08          	mov    %edx,0x8(%esp)
     a91:	89 44 24 04          	mov    %eax,0x4(%esp)
     a95:	8b 45 08             	mov    0x8(%ebp),%eax
     a98:	89 04 24             	mov    %eax,(%esp)
     a9b:	e8 1e fa ff ff       	call   4be <redircmd>
     aa0:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     aa3:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     aa4:	c7 44 24 08 ef 1b 00 	movl   $0x1bef,0x8(%esp)
     aab:	00 
     aac:	8b 45 10             	mov    0x10(%ebp),%eax
     aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
     ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ab6:	89 04 24             	mov    %eax,(%esp)
     ab9:	e8 90 fc ff ff       	call   74e <peek>
     abe:	85 c0                	test   %eax,%eax
     ac0:	0f 85 e8 fe ff ff    	jne    9ae <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     ac6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ac9:	c9                   	leave  
     aca:	c3                   	ret    

00000acb <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     acb:	55                   	push   %ebp
     acc:	89 e5                	mov    %esp,%ebp
     ace:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     ad1:	c7 44 24 08 f2 1b 00 	movl   $0x1bf2,0x8(%esp)
     ad8:	00 
     ad9:	8b 45 0c             	mov    0xc(%ebp),%eax
     adc:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae0:	8b 45 08             	mov    0x8(%ebp),%eax
     ae3:	89 04 24             	mov    %eax,(%esp)
     ae6:	e8 63 fc ff ff       	call   74e <peek>
     aeb:	85 c0                	test   %eax,%eax
     aed:	75 0c                	jne    afb <parseblock+0x30>
    panic("parseblock");
     aef:	c7 04 24 f4 1b 00 00 	movl   $0x1bf4,(%esp)
     af6:	e8 3a f9 ff ff       	call   435 <panic>
  gettoken(ps, es, 0, 0);
     afb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b02:	00 
     b03:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b0a:	00 
     b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
     b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
     b12:	8b 45 08             	mov    0x8(%ebp),%eax
     b15:	89 04 24             	mov    %eax,(%esp)
     b18:	e8 f3 fa ff ff       	call   610 <gettoken>
  cmd = parseline(ps, es);
     b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
     b20:	89 44 24 04          	mov    %eax,0x4(%esp)
     b24:	8b 45 08             	mov    0x8(%ebp),%eax
     b27:	89 04 24             	mov    %eax,(%esp)
     b2a:	e8 1c fd ff ff       	call   84b <parseline>
     b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     b32:	c7 44 24 08 ff 1b 00 	movl   $0x1bff,0x8(%esp)
     b39:	00 
     b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
     b41:	8b 45 08             	mov    0x8(%ebp),%eax
     b44:	89 04 24             	mov    %eax,(%esp)
     b47:	e8 02 fc ff ff       	call   74e <peek>
     b4c:	85 c0                	test   %eax,%eax
     b4e:	75 0c                	jne    b5c <parseblock+0x91>
    panic("syntax - missing )");
     b50:	c7 04 24 01 1c 00 00 	movl   $0x1c01,(%esp)
     b57:	e8 d9 f8 ff ff       	call   435 <panic>
  gettoken(ps, es, 0, 0);
     b5c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b63:	00 
     b64:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b6b:	00 
     b6c:	8b 45 0c             	mov    0xc(%ebp),%eax
     b6f:	89 44 24 04          	mov    %eax,0x4(%esp)
     b73:	8b 45 08             	mov    0x8(%ebp),%eax
     b76:	89 04 24             	mov    %eax,(%esp)
     b79:	e8 92 fa ff ff       	call   610 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
     b81:	89 44 24 08          	mov    %eax,0x8(%esp)
     b85:	8b 45 08             	mov    0x8(%ebp),%eax
     b88:	89 44 24 04          	mov    %eax,0x4(%esp)
     b8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b8f:	89 04 24             	mov    %eax,(%esp)
     b92:	e8 0c fe ff ff       	call   9a3 <parseredirs>
     b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b9d:	c9                   	leave  
     b9e:	c3                   	ret    

00000b9f <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     b9f:	55                   	push   %ebp
     ba0:	89 e5                	mov    %esp,%ebp
     ba2:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     ba5:	c7 44 24 08 f2 1b 00 	movl   $0x1bf2,0x8(%esp)
     bac:	00 
     bad:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb4:	8b 45 08             	mov    0x8(%ebp),%eax
     bb7:	89 04 24             	mov    %eax,(%esp)
     bba:	e8 8f fb ff ff       	call   74e <peek>
     bbf:	85 c0                	test   %eax,%eax
     bc1:	74 17                	je     bda <parseexec+0x3b>
    return parseblock(ps, es);
     bc3:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
     bca:	8b 45 08             	mov    0x8(%ebp),%eax
     bcd:	89 04 24             	mov    %eax,(%esp)
     bd0:	e8 f6 fe ff ff       	call   acb <parseblock>
     bd5:	e9 08 01 00 00       	jmp    ce2 <parseexec+0x143>

  ret = execcmd();
     bda:	e8 a1 f8 ff ff       	call   480 <execcmd>
     bdf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     be2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     be5:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     be8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     bef:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf2:	89 44 24 08          	mov    %eax,0x8(%esp)
     bf6:	8b 45 08             	mov    0x8(%ebp),%eax
     bf9:	89 44 24 04          	mov    %eax,0x4(%esp)
     bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c00:	89 04 24             	mov    %eax,(%esp)
     c03:	e8 9b fd ff ff       	call   9a3 <parseredirs>
     c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     c0b:	e9 8e 00 00 00       	jmp    c9e <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     c10:	8d 45 e0             	lea    -0x20(%ebp),%eax
     c13:	89 44 24 0c          	mov    %eax,0xc(%esp)
     c17:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     c1a:	89 44 24 08          	mov    %eax,0x8(%esp)
     c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c21:	89 44 24 04          	mov    %eax,0x4(%esp)
     c25:	8b 45 08             	mov    0x8(%ebp),%eax
     c28:	89 04 24             	mov    %eax,(%esp)
     c2b:	e8 e0 f9 ff ff       	call   610 <gettoken>
     c30:	89 45 e8             	mov    %eax,-0x18(%ebp)
     c33:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     c37:	75 05                	jne    c3e <parseexec+0x9f>
      break;
     c39:	e9 82 00 00 00       	jmp    cc0 <parseexec+0x121>
    if(tok != 'a')
     c3e:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     c42:	74 0c                	je     c50 <parseexec+0xb1>
      panic("syntax");
     c44:	c7 04 24 c5 1b 00 00 	movl   $0x1bc5,(%esp)
     c4b:	e8 e5 f7 ff ff       	call   435 <panic>
    cmd->argv[argc] = q;
     c50:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     c53:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
     c59:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     c5d:	8b 55 e0             	mov    -0x20(%ebp),%edx
     c60:	8b 45 ec             	mov    -0x14(%ebp),%eax
     c63:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     c66:	83 c1 14             	add    $0x14,%ecx
     c69:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    argc++;
     c6d:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     c70:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     c74:	7e 0c                	jle    c82 <parseexec+0xe3>
      panic("too many args");
     c76:	c7 04 24 14 1c 00 00 	movl   $0x1c14,(%esp)
     c7d:	e8 b3 f7 ff ff       	call   435 <panic>
    ret = parseredirs(ret, ps, es);
     c82:	8b 45 0c             	mov    0xc(%ebp),%eax
     c85:	89 44 24 08          	mov    %eax,0x8(%esp)
     c89:	8b 45 08             	mov    0x8(%ebp),%eax
     c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
     c90:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c93:	89 04 24             	mov    %eax,(%esp)
     c96:	e8 08 fd ff ff       	call   9a3 <parseredirs>
     c9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     c9e:	c7 44 24 08 22 1c 00 	movl   $0x1c22,0x8(%esp)
     ca5:	00 
     ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ca9:	89 44 24 04          	mov    %eax,0x4(%esp)
     cad:	8b 45 08             	mov    0x8(%ebp),%eax
     cb0:	89 04 24             	mov    %eax,(%esp)
     cb3:	e8 96 fa ff ff       	call   74e <peek>
     cb8:	85 c0                	test   %eax,%eax
     cba:	0f 84 50 ff ff ff    	je     c10 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     cc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cc3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cc6:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     ccd:	00 
  cmd->eargv[argc] = 0;
     cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
     cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     cd4:	83 c2 14             	add    $0x14,%edx
     cd7:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     cde:	00 
  return ret;
     cdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ce2:	c9                   	leave  
     ce3:	c3                   	ret    

00000ce4 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     ce4:	55                   	push   %ebp
     ce5:	89 e5                	mov    %esp,%ebp
     ce7:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     cea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     cee:	75 0a                	jne    cfa <nulterminate+0x16>
    return 0;
     cf0:	b8 00 00 00 00       	mov    $0x0,%eax
     cf5:	e9 c8 00 00 00       	jmp    dc2 <nulterminate+0xde>

  switch(cmd->type){
     cfa:	8b 45 08             	mov    0x8(%ebp),%eax
     cfd:	8b 00                	mov    (%eax),%eax
     cff:	83 f8 05             	cmp    $0x5,%eax
     d02:	0f 87 b7 00 00 00    	ja     dbf <nulterminate+0xdb>
     d08:	8b 04 85 28 1c 00 00 	mov    0x1c28(,%eax,4),%eax
     d0f:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     d11:	8b 45 08             	mov    0x8(%ebp),%eax
     d14:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     d17:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     d1e:	eb 13                	jmp    d33 <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
     d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d23:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d26:	83 c2 14             	add    $0x14,%edx
     d29:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     d2d:	c6 00 00             	movb   $0x0,(%eax)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     d30:	ff 45 f4             	incl   -0xc(%ebp)
     d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d39:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     d3d:	85 c0                	test   %eax,%eax
     d3f:	75 df                	jne    d20 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     d41:	eb 7c                	jmp    dbf <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     d43:	8b 45 08             	mov    0x8(%ebp),%eax
     d46:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     d49:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d4c:	8b 40 04             	mov    0x4(%eax),%eax
     d4f:	89 04 24             	mov    %eax,(%esp)
     d52:	e8 8d ff ff ff       	call   ce4 <nulterminate>
    *rcmd->efile = 0;
     d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d5a:	8b 40 0c             	mov    0xc(%eax),%eax
     d5d:	c6 00 00             	movb   $0x0,(%eax)
    break;
     d60:	eb 5d                	jmp    dbf <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     d62:	8b 45 08             	mov    0x8(%ebp),%eax
     d65:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     d68:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d6b:	8b 40 04             	mov    0x4(%eax),%eax
     d6e:	89 04 24             	mov    %eax,(%esp)
     d71:	e8 6e ff ff ff       	call   ce4 <nulterminate>
    nulterminate(pcmd->right);
     d76:	8b 45 e8             	mov    -0x18(%ebp),%eax
     d79:	8b 40 08             	mov    0x8(%eax),%eax
     d7c:	89 04 24             	mov    %eax,(%esp)
     d7f:	e8 60 ff ff ff       	call   ce4 <nulterminate>
    break;
     d84:	eb 39                	jmp    dbf <nulterminate+0xdb>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     d86:	8b 45 08             	mov    0x8(%ebp),%eax
     d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     d8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d8f:	8b 40 04             	mov    0x4(%eax),%eax
     d92:	89 04 24             	mov    %eax,(%esp)
     d95:	e8 4a ff ff ff       	call   ce4 <nulterminate>
    nulterminate(lcmd->right);
     d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     d9d:	8b 40 08             	mov    0x8(%eax),%eax
     da0:	89 04 24             	mov    %eax,(%esp)
     da3:	e8 3c ff ff ff       	call   ce4 <nulterminate>
    break;
     da8:	eb 15                	jmp    dbf <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     daa:	8b 45 08             	mov    0x8(%ebp),%eax
     dad:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     db0:	8b 45 e0             	mov    -0x20(%ebp),%eax
     db3:	8b 40 04             	mov    0x4(%eax),%eax
     db6:	89 04 24             	mov    %eax,(%esp)
     db9:	e8 26 ff ff ff       	call   ce4 <nulterminate>
    break;
     dbe:	90                   	nop
  }
  return cmd;
     dbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
     dc2:	c9                   	leave  
     dc3:	c3                   	ret    

00000dc4 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     dc4:	55                   	push   %ebp
     dc5:	89 e5                	mov    %esp,%ebp
     dc7:	57                   	push   %edi
     dc8:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     dc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
     dcc:	8b 55 10             	mov    0x10(%ebp),%edx
     dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
     dd2:	89 cb                	mov    %ecx,%ebx
     dd4:	89 df                	mov    %ebx,%edi
     dd6:	89 d1                	mov    %edx,%ecx
     dd8:	fc                   	cld    
     dd9:	f3 aa                	rep stos %al,%es:(%edi)
     ddb:	89 ca                	mov    %ecx,%edx
     ddd:	89 fb                	mov    %edi,%ebx
     ddf:	89 5d 08             	mov    %ebx,0x8(%ebp)
     de2:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     de5:	5b                   	pop    %ebx
     de6:	5f                   	pop    %edi
     de7:	5d                   	pop    %ebp
     de8:	c3                   	ret    

00000de9 <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     de9:	55                   	push   %ebp
     dea:	89 e5                	mov    %esp,%ebp
     dec:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     def:	8b 45 08             	mov    0x8(%ebp),%eax
     df2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     df5:	90                   	nop
     df6:	8b 45 08             	mov    0x8(%ebp),%eax
     df9:	8d 50 01             	lea    0x1(%eax),%edx
     dfc:	89 55 08             	mov    %edx,0x8(%ebp)
     dff:	8b 55 0c             	mov    0xc(%ebp),%edx
     e02:	8d 4a 01             	lea    0x1(%edx),%ecx
     e05:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     e08:	8a 12                	mov    (%edx),%dl
     e0a:	88 10                	mov    %dl,(%eax)
     e0c:	8a 00                	mov    (%eax),%al
     e0e:	84 c0                	test   %al,%al
     e10:	75 e4                	jne    df6 <strcpy+0xd>
    ;
  return os;
     e12:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     e15:	c9                   	leave  
     e16:	c3                   	ret    

00000e17 <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     e17:	55                   	push   %ebp
     e18:	89 e5                	mov    %esp,%ebp
     e1a:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     e1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     e24:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     e2b:	00 
     e2c:	8b 45 08             	mov    0x8(%ebp),%eax
     e2f:	89 04 24             	mov    %eax,(%esp)
     e32:	e8 7d 07 00 00       	call   15b4 <open>
     e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
     e3a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     e3e:	79 20                	jns    e60 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     e40:	8b 45 08             	mov    0x8(%ebp),%eax
     e43:	89 44 24 08          	mov    %eax,0x8(%esp)
     e47:	c7 44 24 04 40 1c 00 	movl   $0x1c40,0x4(%esp)
     e4e:	00 
     e4f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e56:	e8 1e 09 00 00       	call   1779 <printf>
      exit();
     e5b:	e8 14 07 00 00       	call   1574 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     e60:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     e67:	00 
     e68:	8b 45 0c             	mov    0xc(%ebp),%eax
     e6b:	89 04 24             	mov    %eax,(%esp)
     e6e:	e8 41 07 00 00       	call   15b4 <open>
     e73:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     e7a:	79 20                	jns    e9c <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     e7c:	8b 45 0c             	mov    0xc(%ebp),%eax
     e7f:	89 44 24 08          	mov    %eax,0x8(%esp)
     e83:	c7 44 24 04 5b 1c 00 	movl   $0x1c5b,0x4(%esp)
     e8a:	00 
     e8b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     e92:	e8 e2 08 00 00       	call   1779 <printf>
      exit();
     e97:	e8 d8 06 00 00       	call   1574 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     e9c:	eb 3b                	jmp    ed9 <copy+0xc2>
  {
      max = used_disk+=count;
     e9e:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ea1:	01 45 10             	add    %eax,0x10(%ebp)
     ea4:	8b 45 10             	mov    0x10(%ebp),%eax
     ea7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     eaa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ead:	3b 45 14             	cmp    0x14(%ebp),%eax
     eb0:	7e 07                	jle    eb9 <copy+0xa2>
      {
        return -1;
     eb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     eb7:	eb 5c                	jmp    f15 <copy+0xfe>
      }
      bytes = bytes + count;
     eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ebc:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     ebf:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     ec6:	00 
     ec7:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     eca:	89 44 24 04          	mov    %eax,0x4(%esp)
     ece:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ed1:	89 04 24             	mov    %eax,(%esp)
     ed4:	e8 bb 06 00 00       	call   1594 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     ed9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     ee0:	00 
     ee1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     ee4:	89 44 24 04          	mov    %eax,0x4(%esp)
     ee8:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eeb:	89 04 24             	mov    %eax,(%esp)
     eee:	e8 99 06 00 00       	call   158c <read>
     ef3:	89 45 e8             	mov    %eax,-0x18(%ebp)
     ef6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     efa:	7f a2                	jg     e9e <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
     efc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eff:	89 04 24             	mov    %eax,(%esp)
     f02:	e8 95 06 00 00       	call   159c <close>
  close(fd2);
     f07:	8b 45 ec             	mov    -0x14(%ebp),%eax
     f0a:	89 04 24             	mov    %eax,(%esp)
     f0d:	e8 8a 06 00 00       	call   159c <close>
  return(bytes);
     f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     f15:	c9                   	leave  
     f16:	c3                   	ret    

00000f17 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     f17:	55                   	push   %ebp
     f18:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     f1a:	eb 06                	jmp    f22 <strcmp+0xb>
    p++, q++;
     f1c:	ff 45 08             	incl   0x8(%ebp)
     f1f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     f22:	8b 45 08             	mov    0x8(%ebp),%eax
     f25:	8a 00                	mov    (%eax),%al
     f27:	84 c0                	test   %al,%al
     f29:	74 0e                	je     f39 <strcmp+0x22>
     f2b:	8b 45 08             	mov    0x8(%ebp),%eax
     f2e:	8a 10                	mov    (%eax),%dl
     f30:	8b 45 0c             	mov    0xc(%ebp),%eax
     f33:	8a 00                	mov    (%eax),%al
     f35:	38 c2                	cmp    %al,%dl
     f37:	74 e3                	je     f1c <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     f39:	8b 45 08             	mov    0x8(%ebp),%eax
     f3c:	8a 00                	mov    (%eax),%al
     f3e:	0f b6 d0             	movzbl %al,%edx
     f41:	8b 45 0c             	mov    0xc(%ebp),%eax
     f44:	8a 00                	mov    (%eax),%al
     f46:	0f b6 c0             	movzbl %al,%eax
     f49:	29 c2                	sub    %eax,%edx
     f4b:	89 d0                	mov    %edx,%eax
}
     f4d:	5d                   	pop    %ebp
     f4e:	c3                   	ret    

00000f4f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
     f4f:	55                   	push   %ebp
     f50:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
     f52:	eb 09                	jmp    f5d <strncmp+0xe>
    n--, p++, q++;
     f54:	ff 4d 10             	decl   0x10(%ebp)
     f57:	ff 45 08             	incl   0x8(%ebp)
     f5a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
     f5d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f61:	74 17                	je     f7a <strncmp+0x2b>
     f63:	8b 45 08             	mov    0x8(%ebp),%eax
     f66:	8a 00                	mov    (%eax),%al
     f68:	84 c0                	test   %al,%al
     f6a:	74 0e                	je     f7a <strncmp+0x2b>
     f6c:	8b 45 08             	mov    0x8(%ebp),%eax
     f6f:	8a 10                	mov    (%eax),%dl
     f71:	8b 45 0c             	mov    0xc(%ebp),%eax
     f74:	8a 00                	mov    (%eax),%al
     f76:	38 c2                	cmp    %al,%dl
     f78:	74 da                	je     f54 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
     f7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     f7e:	75 07                	jne    f87 <strncmp+0x38>
    return 0;
     f80:	b8 00 00 00 00       	mov    $0x0,%eax
     f85:	eb 14                	jmp    f9b <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
     f87:	8b 45 08             	mov    0x8(%ebp),%eax
     f8a:	8a 00                	mov    (%eax),%al
     f8c:	0f b6 d0             	movzbl %al,%edx
     f8f:	8b 45 0c             	mov    0xc(%ebp),%eax
     f92:	8a 00                	mov    (%eax),%al
     f94:	0f b6 c0             	movzbl %al,%eax
     f97:	29 c2                	sub    %eax,%edx
     f99:	89 d0                	mov    %edx,%eax
}
     f9b:	5d                   	pop    %ebp
     f9c:	c3                   	ret    

00000f9d <strlen>:

uint
strlen(const char *s)
{
     f9d:	55                   	push   %ebp
     f9e:	89 e5                	mov    %esp,%ebp
     fa0:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     fa3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     faa:	eb 03                	jmp    faf <strlen+0x12>
     fac:	ff 45 fc             	incl   -0x4(%ebp)
     faf:	8b 55 fc             	mov    -0x4(%ebp),%edx
     fb2:	8b 45 08             	mov    0x8(%ebp),%eax
     fb5:	01 d0                	add    %edx,%eax
     fb7:	8a 00                	mov    (%eax),%al
     fb9:	84 c0                	test   %al,%al
     fbb:	75 ef                	jne    fac <strlen+0xf>
    ;
  return n;
     fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     fc0:	c9                   	leave  
     fc1:	c3                   	ret    

00000fc2 <memset>:

void*
memset(void *dst, int c, uint n)
{
     fc2:	55                   	push   %ebp
     fc3:	89 e5                	mov    %esp,%ebp
     fc5:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     fc8:	8b 45 10             	mov    0x10(%ebp),%eax
     fcb:	89 44 24 08          	mov    %eax,0x8(%esp)
     fcf:	8b 45 0c             	mov    0xc(%ebp),%eax
     fd2:	89 44 24 04          	mov    %eax,0x4(%esp)
     fd6:	8b 45 08             	mov    0x8(%ebp),%eax
     fd9:	89 04 24             	mov    %eax,(%esp)
     fdc:	e8 e3 fd ff ff       	call   dc4 <stosb>
  return dst;
     fe1:	8b 45 08             	mov    0x8(%ebp),%eax
}
     fe4:	c9                   	leave  
     fe5:	c3                   	ret    

00000fe6 <strchr>:

char*
strchr(const char *s, char c)
{
     fe6:	55                   	push   %ebp
     fe7:	89 e5                	mov    %esp,%ebp
     fe9:	83 ec 04             	sub    $0x4,%esp
     fec:	8b 45 0c             	mov    0xc(%ebp),%eax
     fef:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     ff2:	eb 12                	jmp    1006 <strchr+0x20>
    if(*s == c)
     ff4:	8b 45 08             	mov    0x8(%ebp),%eax
     ff7:	8a 00                	mov    (%eax),%al
     ff9:	3a 45 fc             	cmp    -0x4(%ebp),%al
     ffc:	75 05                	jne    1003 <strchr+0x1d>
      return (char*)s;
     ffe:	8b 45 08             	mov    0x8(%ebp),%eax
    1001:	eb 11                	jmp    1014 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1003:	ff 45 08             	incl   0x8(%ebp)
    1006:	8b 45 08             	mov    0x8(%ebp),%eax
    1009:	8a 00                	mov    (%eax),%al
    100b:	84 c0                	test   %al,%al
    100d:	75 e5                	jne    ff4 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    100f:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1014:	c9                   	leave  
    1015:	c3                   	ret    

00001016 <strcat>:

char *
strcat(char *dest, const char *src)
{
    1016:	55                   	push   %ebp
    1017:	89 e5                	mov    %esp,%ebp
    1019:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
    101c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1023:	eb 03                	jmp    1028 <strcat+0x12>
    1025:	ff 45 fc             	incl   -0x4(%ebp)
    1028:	8b 55 fc             	mov    -0x4(%ebp),%edx
    102b:	8b 45 08             	mov    0x8(%ebp),%eax
    102e:	01 d0                	add    %edx,%eax
    1030:	8a 00                	mov    (%eax),%al
    1032:	84 c0                	test   %al,%al
    1034:	75 ef                	jne    1025 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
    1036:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    103d:	eb 1e                	jmp    105d <strcat+0x47>
        dest[i+j] = src[j];
    103f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1042:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1045:	01 d0                	add    %edx,%eax
    1047:	89 c2                	mov    %eax,%edx
    1049:	8b 45 08             	mov    0x8(%ebp),%eax
    104c:	01 c2                	add    %eax,%edx
    104e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    1051:	8b 45 0c             	mov    0xc(%ebp),%eax
    1054:	01 c8                	add    %ecx,%eax
    1056:	8a 00                	mov    (%eax),%al
    1058:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
    105a:	ff 45 f8             	incl   -0x8(%ebp)
    105d:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1060:	8b 45 0c             	mov    0xc(%ebp),%eax
    1063:	01 d0                	add    %edx,%eax
    1065:	8a 00                	mov    (%eax),%al
    1067:	84 c0                	test   %al,%al
    1069:	75 d4                	jne    103f <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
    106b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    106e:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1071:	01 d0                	add    %edx,%eax
    1073:	89 c2                	mov    %eax,%edx
    1075:	8b 45 08             	mov    0x8(%ebp),%eax
    1078:	01 d0                	add    %edx,%eax
    107a:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
    107d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1080:	c9                   	leave  
    1081:	c3                   	ret    

00001082 <strstr>:

int 
strstr(char* s, char* sub)
{
    1082:	55                   	push   %ebp
    1083:	89 e5                	mov    %esp,%ebp
    1085:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    1088:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    108f:	eb 7c                	jmp    110d <strstr+0x8b>
    {
        if(s[i] == sub[0])
    1091:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1094:	8b 45 08             	mov    0x8(%ebp),%eax
    1097:	01 d0                	add    %edx,%eax
    1099:	8a 10                	mov    (%eax),%dl
    109b:	8b 45 0c             	mov    0xc(%ebp),%eax
    109e:	8a 00                	mov    (%eax),%al
    10a0:	38 c2                	cmp    %al,%dl
    10a2:	75 66                	jne    110a <strstr+0x88>
        {
            if(strlen(sub) == 1)
    10a4:	8b 45 0c             	mov    0xc(%ebp),%eax
    10a7:	89 04 24             	mov    %eax,(%esp)
    10aa:	e8 ee fe ff ff       	call   f9d <strlen>
    10af:	83 f8 01             	cmp    $0x1,%eax
    10b2:	75 05                	jne    10b9 <strstr+0x37>
            {  
                return i;
    10b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10b7:	eb 6b                	jmp    1124 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
    10b9:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
    10c0:	eb 3a                	jmp    10fc <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
    10c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10c5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10c8:	01 d0                	add    %edx,%eax
    10ca:	89 c2                	mov    %eax,%edx
    10cc:	8b 45 08             	mov    0x8(%ebp),%eax
    10cf:	01 d0                	add    %edx,%eax
    10d1:	8a 10                	mov    (%eax),%dl
    10d3:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    10d6:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d9:	01 c8                	add    %ecx,%eax
    10db:	8a 00                	mov    (%eax),%al
    10dd:	38 c2                	cmp    %al,%dl
    10df:	75 16                	jne    10f7 <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
    10e1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10e4:	8d 50 01             	lea    0x1(%eax),%edx
    10e7:	8b 45 0c             	mov    0xc(%ebp),%eax
    10ea:	01 d0                	add    %edx,%eax
    10ec:	8a 00                	mov    (%eax),%al
    10ee:	84 c0                	test   %al,%al
    10f0:	75 07                	jne    10f9 <strstr+0x77>
                    {
                        return i;
    10f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10f5:	eb 2d                	jmp    1124 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
    10f7:	eb 11                	jmp    110a <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
    10f9:	ff 45 f8             	incl   -0x8(%ebp)
    10fc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    10ff:	8b 45 0c             	mov    0xc(%ebp),%eax
    1102:	01 d0                	add    %edx,%eax
    1104:	8a 00                	mov    (%eax),%al
    1106:	84 c0                	test   %al,%al
    1108:	75 b8                	jne    10c2 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    110a:	ff 45 fc             	incl   -0x4(%ebp)
    110d:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	01 d0                	add    %edx,%eax
    1115:	8a 00                	mov    (%eax),%al
    1117:	84 c0                	test   %al,%al
    1119:	0f 85 72 ff ff ff    	jne    1091 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
    111f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1124:	c9                   	leave  
    1125:	c3                   	ret    

00001126 <strtok>:

char *
strtok(char *s, const char *delim)
{
    1126:	55                   	push   %ebp
    1127:	89 e5                	mov    %esp,%ebp
    1129:	53                   	push   %ebx
    112a:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
    112d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1131:	75 08                	jne    113b <strtok+0x15>
  s = lasts;
    1133:	a1 48 23 00 00       	mov    0x2348,%eax
    1138:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
    113b:	8b 45 08             	mov    0x8(%ebp),%eax
    113e:	8d 50 01             	lea    0x1(%eax),%edx
    1141:	89 55 08             	mov    %edx,0x8(%ebp)
    1144:	8a 00                	mov    (%eax),%al
    1146:	0f be d8             	movsbl %al,%ebx
    1149:	85 db                	test   %ebx,%ebx
    114b:	75 07                	jne    1154 <strtok+0x2e>
      return 0;
    114d:	b8 00 00 00 00       	mov    $0x0,%eax
    1152:	eb 58                	jmp    11ac <strtok+0x86>
    } while (strchr(delim, ch));
    1154:	88 d8                	mov    %bl,%al
    1156:	0f be c0             	movsbl %al,%eax
    1159:	89 44 24 04          	mov    %eax,0x4(%esp)
    115d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1160:	89 04 24             	mov    %eax,(%esp)
    1163:	e8 7e fe ff ff       	call   fe6 <strchr>
    1168:	85 c0                	test   %eax,%eax
    116a:	75 cf                	jne    113b <strtok+0x15>
    --s;
    116c:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
    116f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1172:	89 44 24 04          	mov    %eax,0x4(%esp)
    1176:	8b 45 08             	mov    0x8(%ebp),%eax
    1179:	89 04 24             	mov    %eax,(%esp)
    117c:	e8 31 00 00 00       	call   11b2 <strcspn>
    1181:	89 c2                	mov    %eax,%edx
    1183:	8b 45 08             	mov    0x8(%ebp),%eax
    1186:	01 d0                	add    %edx,%eax
    1188:	a3 48 23 00 00       	mov    %eax,0x2348
    if (*lasts != 0)
    118d:	a1 48 23 00 00       	mov    0x2348,%eax
    1192:	8a 00                	mov    (%eax),%al
    1194:	84 c0                	test   %al,%al
    1196:	74 11                	je     11a9 <strtok+0x83>
  *lasts++ = 0;
    1198:	a1 48 23 00 00       	mov    0x2348,%eax
    119d:	8d 50 01             	lea    0x1(%eax),%edx
    11a0:	89 15 48 23 00 00    	mov    %edx,0x2348
    11a6:	c6 00 00             	movb   $0x0,(%eax)
    return s;
    11a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11ac:	83 c4 14             	add    $0x14,%esp
    11af:	5b                   	pop    %ebx
    11b0:	5d                   	pop    %ebp
    11b1:	c3                   	ret    

000011b2 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
    11b2:	55                   	push   %ebp
    11b3:	89 e5                	mov    %esp,%ebp
    11b5:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
    11b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
    11bf:	eb 26                	jmp    11e7 <strcspn+0x35>
        if(strchr(s2,*s1))
    11c1:	8b 45 08             	mov    0x8(%ebp),%eax
    11c4:	8a 00                	mov    (%eax),%al
    11c6:	0f be c0             	movsbl %al,%eax
    11c9:	89 44 24 04          	mov    %eax,0x4(%esp)
    11cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    11d0:	89 04 24             	mov    %eax,(%esp)
    11d3:	e8 0e fe ff ff       	call   fe6 <strchr>
    11d8:	85 c0                	test   %eax,%eax
    11da:	74 05                	je     11e1 <strcspn+0x2f>
            return ret;
    11dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11df:	eb 12                	jmp    11f3 <strcspn+0x41>
        else
            s1++,ret++;
    11e1:	ff 45 08             	incl   0x8(%ebp)
    11e4:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
    11e7:	8b 45 08             	mov    0x8(%ebp),%eax
    11ea:	8a 00                	mov    (%eax),%al
    11ec:	84 c0                	test   %al,%al
    11ee:	75 d1                	jne    11c1 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
    11f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    11f3:	c9                   	leave  
    11f4:	c3                   	ret    

000011f5 <isspace>:

int
isspace(unsigned char c)
{
    11f5:	55                   	push   %ebp
    11f6:	89 e5                	mov    %esp,%ebp
    11f8:	83 ec 04             	sub    $0x4,%esp
    11fb:	8b 45 08             	mov    0x8(%ebp),%eax
    11fe:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
    1201:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
    1205:	74 1e                	je     1225 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
    1207:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
    120b:	74 18                	je     1225 <isspace+0x30>
    120d:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
    1211:	74 12                	je     1225 <isspace+0x30>
    1213:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
    1217:	74 0c                	je     1225 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
    1219:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
    121d:	74 06                	je     1225 <isspace+0x30>
    121f:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
    1223:	75 07                	jne    122c <isspace+0x37>
    1225:	b8 01 00 00 00       	mov    $0x1,%eax
    122a:	eb 05                	jmp    1231 <isspace+0x3c>
    122c:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1231:	c9                   	leave  
    1232:	c3                   	ret    

00001233 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
    1233:	55                   	push   %ebp
    1234:	89 e5                	mov    %esp,%ebp
    1236:	57                   	push   %edi
    1237:	56                   	push   %esi
    1238:	53                   	push   %ebx
    1239:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
    123c:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
    1241:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
    1248:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    124b:	eb 01                	jmp    124e <strtoul+0x1b>
  p += 1;
    124d:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    124e:	8a 03                	mov    (%ebx),%al
    1250:	0f b6 c0             	movzbl %al,%eax
    1253:	89 04 24             	mov    %eax,(%esp)
    1256:	e8 9a ff ff ff       	call   11f5 <isspace>
    125b:	85 c0                	test   %eax,%eax
    125d:	75 ee                	jne    124d <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
    125f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1263:	75 30                	jne    1295 <strtoul+0x62>
    {
  if (*p == '0') {
    1265:	8a 03                	mov    (%ebx),%al
    1267:	3c 30                	cmp    $0x30,%al
    1269:	75 21                	jne    128c <strtoul+0x59>
      p += 1;
    126b:	43                   	inc    %ebx
      if (*p == 'x') {
    126c:	8a 03                	mov    (%ebx),%al
    126e:	3c 78                	cmp    $0x78,%al
    1270:	75 0a                	jne    127c <strtoul+0x49>
    p += 1;
    1272:	43                   	inc    %ebx
    base = 16;
    1273:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
    127a:	eb 31                	jmp    12ad <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
    127c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
    1283:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
    128a:	eb 21                	jmp    12ad <strtoul+0x7a>
      }
  }
  else base = 10;
    128c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    1293:	eb 18                	jmp    12ad <strtoul+0x7a>
    } else if (base == 16) {
    1295:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    1299:	75 12                	jne    12ad <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
    129b:	8a 03                	mov    (%ebx),%al
    129d:	3c 30                	cmp    $0x30,%al
    129f:	75 0c                	jne    12ad <strtoul+0x7a>
    12a1:	8d 43 01             	lea    0x1(%ebx),%eax
    12a4:	8a 00                	mov    (%eax),%al
    12a6:	3c 78                	cmp    $0x78,%al
    12a8:	75 03                	jne    12ad <strtoul+0x7a>
      p += 2;
    12aa:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
    12ad:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
    12b1:	75 29                	jne    12dc <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
    12b3:	8a 03                	mov    (%ebx),%al
    12b5:	0f be c0             	movsbl %al,%eax
    12b8:	83 e8 30             	sub    $0x30,%eax
    12bb:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
    12bd:	83 fe 07             	cmp    $0x7,%esi
    12c0:	76 06                	jbe    12c8 <strtoul+0x95>
    break;
    12c2:	90                   	nop
    12c3:	e9 b6 00 00 00       	jmp    137e <strtoul+0x14b>
      }
      result = (result << 3) + digit;
    12c8:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
    12cf:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    12d2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
    12d9:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    12da:	eb d7                	jmp    12b3 <strtoul+0x80>
    } else if (base == 10) {
    12dc:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
    12e0:	75 2b                	jne    130d <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
    12e2:	8a 03                	mov    (%ebx),%al
    12e4:	0f be c0             	movsbl %al,%eax
    12e7:	83 e8 30             	sub    $0x30,%eax
    12ea:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
    12ec:	83 fe 09             	cmp    $0x9,%esi
    12ef:	76 06                	jbe    12f7 <strtoul+0xc4>
    break;
    12f1:	90                   	nop
    12f2:	e9 87 00 00 00       	jmp    137e <strtoul+0x14b>
      }
      result = (10*result) + digit;
    12f7:	89 f8                	mov    %edi,%eax
    12f9:	c1 e0 02             	shl    $0x2,%eax
    12fc:	01 f8                	add    %edi,%eax
    12fe:	01 c0                	add    %eax,%eax
    1300:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1303:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
    130a:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    130b:	eb d5                	jmp    12e2 <strtoul+0xaf>
    } else if (base == 16) {
    130d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    1311:	75 35                	jne    1348 <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
    1313:	8a 03                	mov    (%ebx),%al
    1315:	0f be c0             	movsbl %al,%eax
    1318:	83 e8 30             	sub    $0x30,%eax
    131b:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    131d:	83 fe 4a             	cmp    $0x4a,%esi
    1320:	76 02                	jbe    1324 <strtoul+0xf1>
    break;
    1322:	eb 22                	jmp    1346 <strtoul+0x113>
      }
      digit = cvtIn[digit];
    1324:	8a 86 80 22 00 00    	mov    0x2280(%esi),%al
    132a:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
    132d:	83 fe 0f             	cmp    $0xf,%esi
    1330:	76 02                	jbe    1334 <strtoul+0x101>
    break;
    1332:	eb 12                	jmp    1346 <strtoul+0x113>
      }
      result = (result << 4) + digit;
    1334:	89 f8                	mov    %edi,%eax
    1336:	c1 e0 04             	shl    $0x4,%eax
    1339:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    133c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
    1343:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    1344:	eb cd                	jmp    1313 <strtoul+0xe0>
    1346:	eb 36                	jmp    137e <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
    1348:	8a 03                	mov    (%ebx),%al
    134a:	0f be c0             	movsbl %al,%eax
    134d:	83 e8 30             	sub    $0x30,%eax
    1350:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    1352:	83 fe 4a             	cmp    $0x4a,%esi
    1355:	76 02                	jbe    1359 <strtoul+0x126>
    break;
    1357:	eb 25                	jmp    137e <strtoul+0x14b>
      }
      digit = cvtIn[digit];
    1359:	8a 86 80 22 00 00    	mov    0x2280(%esi),%al
    135f:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
    1362:	8b 45 10             	mov    0x10(%ebp),%eax
    1365:	39 f0                	cmp    %esi,%eax
    1367:	77 02                	ja     136b <strtoul+0x138>
    break;
    1369:	eb 13                	jmp    137e <strtoul+0x14b>
      }
      result = result*base + digit;
    136b:	8b 45 10             	mov    0x10(%ebp),%eax
    136e:	0f af c7             	imul   %edi,%eax
    1371:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1374:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
    137b:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
    137c:	eb ca                	jmp    1348 <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
    137e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1382:	75 03                	jne    1387 <strtoul+0x154>
  p = string;
    1384:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
    1387:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    138b:	74 05                	je     1392 <strtoul+0x15f>
  *endPtr = p;
    138d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1390:	89 18                	mov    %ebx,(%eax)
    }

    return result;
    1392:	89 f8                	mov    %edi,%eax
}
    1394:	83 c4 14             	add    $0x14,%esp
    1397:	5b                   	pop    %ebx
    1398:	5e                   	pop    %esi
    1399:	5f                   	pop    %edi
    139a:	5d                   	pop    %ebp
    139b:	c3                   	ret    

0000139c <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
    139c:	55                   	push   %ebp
    139d:	89 e5                	mov    %esp,%ebp
    139f:	53                   	push   %ebx
    13a0:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
    13a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    13a6:	eb 01                	jmp    13a9 <strtol+0xd>
      p += 1;
    13a8:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    13a9:	8a 03                	mov    (%ebx),%al
    13ab:	0f b6 c0             	movzbl %al,%eax
    13ae:	89 04 24             	mov    %eax,(%esp)
    13b1:	e8 3f fe ff ff       	call   11f5 <isspace>
    13b6:	85 c0                	test   %eax,%eax
    13b8:	75 ee                	jne    13a8 <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
    13ba:	8a 03                	mov    (%ebx),%al
    13bc:	3c 2d                	cmp    $0x2d,%al
    13be:	75 1e                	jne    13de <strtol+0x42>
  p += 1;
    13c0:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
    13c1:	8b 45 10             	mov    0x10(%ebp),%eax
    13c4:	89 44 24 08          	mov    %eax,0x8(%esp)
    13c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    13cb:	89 44 24 04          	mov    %eax,0x4(%esp)
    13cf:	89 1c 24             	mov    %ebx,(%esp)
    13d2:	e8 5c fe ff ff       	call   1233 <strtoul>
    13d7:	f7 d8                	neg    %eax
    13d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    13dc:	eb 20                	jmp    13fe <strtol+0x62>
    } else {
  if (*p == '+') {
    13de:	8a 03                	mov    (%ebx),%al
    13e0:	3c 2b                	cmp    $0x2b,%al
    13e2:	75 01                	jne    13e5 <strtol+0x49>
      p += 1;
    13e4:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
    13e5:	8b 45 10             	mov    0x10(%ebp),%eax
    13e8:	89 44 24 08          	mov    %eax,0x8(%esp)
    13ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    13ef:	89 44 24 04          	mov    %eax,0x4(%esp)
    13f3:	89 1c 24             	mov    %ebx,(%esp)
    13f6:	e8 38 fe ff ff       	call   1233 <strtoul>
    13fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
    13fe:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
    1402:	75 17                	jne    141b <strtol+0x7f>
    1404:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1408:	74 11                	je     141b <strtol+0x7f>
    140a:	8b 45 0c             	mov    0xc(%ebp),%eax
    140d:	8b 00                	mov    (%eax),%eax
    140f:	39 d8                	cmp    %ebx,%eax
    1411:	75 08                	jne    141b <strtol+0x7f>
  *endPtr = string;
    1413:	8b 45 0c             	mov    0xc(%ebp),%eax
    1416:	8b 55 08             	mov    0x8(%ebp),%edx
    1419:	89 10                	mov    %edx,(%eax)
    }
    return result;
    141b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
    141e:	83 c4 1c             	add    $0x1c,%esp
    1421:	5b                   	pop    %ebx
    1422:	5d                   	pop    %ebp
    1423:	c3                   	ret    

00001424 <gets>:

char*
gets(char *buf, int max)
{
    1424:	55                   	push   %ebp
    1425:	89 e5                	mov    %esp,%ebp
    1427:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    142a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1431:	eb 49                	jmp    147c <gets+0x58>
    cc = read(0, &c, 1);
    1433:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    143a:	00 
    143b:	8d 45 ef             	lea    -0x11(%ebp),%eax
    143e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1442:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1449:	e8 3e 01 00 00       	call   158c <read>
    144e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1455:	7f 02                	jg     1459 <gets+0x35>
      break;
    1457:	eb 2c                	jmp    1485 <gets+0x61>
    buf[i++] = c;
    1459:	8b 45 f4             	mov    -0xc(%ebp),%eax
    145c:	8d 50 01             	lea    0x1(%eax),%edx
    145f:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1462:	89 c2                	mov    %eax,%edx
    1464:	8b 45 08             	mov    0x8(%ebp),%eax
    1467:	01 c2                	add    %eax,%edx
    1469:	8a 45 ef             	mov    -0x11(%ebp),%al
    146c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    146e:	8a 45 ef             	mov    -0x11(%ebp),%al
    1471:	3c 0a                	cmp    $0xa,%al
    1473:	74 10                	je     1485 <gets+0x61>
    1475:	8a 45 ef             	mov    -0x11(%ebp),%al
    1478:	3c 0d                	cmp    $0xd,%al
    147a:	74 09                	je     1485 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    147c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    147f:	40                   	inc    %eax
    1480:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1483:	7c ae                	jl     1433 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1485:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1488:	8b 45 08             	mov    0x8(%ebp),%eax
    148b:	01 d0                	add    %edx,%eax
    148d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1490:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1493:	c9                   	leave  
    1494:	c3                   	ret    

00001495 <stat>:

int
stat(char *n, struct stat *st)
{
    1495:	55                   	push   %ebp
    1496:	89 e5                	mov    %esp,%ebp
    1498:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    149b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    14a2:	00 
    14a3:	8b 45 08             	mov    0x8(%ebp),%eax
    14a6:	89 04 24             	mov    %eax,(%esp)
    14a9:	e8 06 01 00 00       	call   15b4 <open>
    14ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    14b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    14b5:	79 07                	jns    14be <stat+0x29>
    return -1;
    14b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    14bc:	eb 23                	jmp    14e1 <stat+0x4c>
  r = fstat(fd, st);
    14be:	8b 45 0c             	mov    0xc(%ebp),%eax
    14c1:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c8:	89 04 24             	mov    %eax,(%esp)
    14cb:	e8 fc 00 00 00       	call   15cc <fstat>
    14d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    14d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d6:	89 04 24             	mov    %eax,(%esp)
    14d9:	e8 be 00 00 00       	call   159c <close>
  return r;
    14de:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    14e1:	c9                   	leave  
    14e2:	c3                   	ret    

000014e3 <atoi>:

int
atoi(const char *s)
{
    14e3:	55                   	push   %ebp
    14e4:	89 e5                	mov    %esp,%ebp
    14e6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    14e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    14f0:	eb 24                	jmp    1516 <atoi+0x33>
    n = n*10 + *s++ - '0';
    14f2:	8b 55 fc             	mov    -0x4(%ebp),%edx
    14f5:	89 d0                	mov    %edx,%eax
    14f7:	c1 e0 02             	shl    $0x2,%eax
    14fa:	01 d0                	add    %edx,%eax
    14fc:	01 c0                	add    %eax,%eax
    14fe:	89 c1                	mov    %eax,%ecx
    1500:	8b 45 08             	mov    0x8(%ebp),%eax
    1503:	8d 50 01             	lea    0x1(%eax),%edx
    1506:	89 55 08             	mov    %edx,0x8(%ebp)
    1509:	8a 00                	mov    (%eax),%al
    150b:	0f be c0             	movsbl %al,%eax
    150e:	01 c8                	add    %ecx,%eax
    1510:	83 e8 30             	sub    $0x30,%eax
    1513:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1516:	8b 45 08             	mov    0x8(%ebp),%eax
    1519:	8a 00                	mov    (%eax),%al
    151b:	3c 2f                	cmp    $0x2f,%al
    151d:	7e 09                	jle    1528 <atoi+0x45>
    151f:	8b 45 08             	mov    0x8(%ebp),%eax
    1522:	8a 00                	mov    (%eax),%al
    1524:	3c 39                	cmp    $0x39,%al
    1526:	7e ca                	jle    14f2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    1528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    152b:	c9                   	leave  
    152c:	c3                   	ret    

0000152d <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    152d:	55                   	push   %ebp
    152e:	89 e5                	mov    %esp,%ebp
    1530:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1533:	8b 45 08             	mov    0x8(%ebp),%eax
    1536:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    1539:	8b 45 0c             	mov    0xc(%ebp),%eax
    153c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    153f:	eb 16                	jmp    1557 <memmove+0x2a>
    *dst++ = *src++;
    1541:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1544:	8d 50 01             	lea    0x1(%eax),%edx
    1547:	89 55 fc             	mov    %edx,-0x4(%ebp)
    154a:	8b 55 f8             	mov    -0x8(%ebp),%edx
    154d:	8d 4a 01             	lea    0x1(%edx),%ecx
    1550:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1553:	8a 12                	mov    (%edx),%dl
    1555:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    1557:	8b 45 10             	mov    0x10(%ebp),%eax
    155a:	8d 50 ff             	lea    -0x1(%eax),%edx
    155d:	89 55 10             	mov    %edx,0x10(%ebp)
    1560:	85 c0                	test   %eax,%eax
    1562:	7f dd                	jg     1541 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1564:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1567:	c9                   	leave  
    1568:	c3                   	ret    
    1569:	90                   	nop
    156a:	90                   	nop
    156b:	90                   	nop

0000156c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    156c:	b8 01 00 00 00       	mov    $0x1,%eax
    1571:	cd 40                	int    $0x40
    1573:	c3                   	ret    

00001574 <exit>:
SYSCALL(exit)
    1574:	b8 02 00 00 00       	mov    $0x2,%eax
    1579:	cd 40                	int    $0x40
    157b:	c3                   	ret    

0000157c <wait>:
SYSCALL(wait)
    157c:	b8 03 00 00 00       	mov    $0x3,%eax
    1581:	cd 40                	int    $0x40
    1583:	c3                   	ret    

00001584 <pipe>:
SYSCALL(pipe)
    1584:	b8 04 00 00 00       	mov    $0x4,%eax
    1589:	cd 40                	int    $0x40
    158b:	c3                   	ret    

0000158c <read>:
SYSCALL(read)
    158c:	b8 05 00 00 00       	mov    $0x5,%eax
    1591:	cd 40                	int    $0x40
    1593:	c3                   	ret    

00001594 <write>:
SYSCALL(write)
    1594:	b8 10 00 00 00       	mov    $0x10,%eax
    1599:	cd 40                	int    $0x40
    159b:	c3                   	ret    

0000159c <close>:
SYSCALL(close)
    159c:	b8 15 00 00 00       	mov    $0x15,%eax
    15a1:	cd 40                	int    $0x40
    15a3:	c3                   	ret    

000015a4 <kill>:
SYSCALL(kill)
    15a4:	b8 06 00 00 00       	mov    $0x6,%eax
    15a9:	cd 40                	int    $0x40
    15ab:	c3                   	ret    

000015ac <exec>:
SYSCALL(exec)
    15ac:	b8 07 00 00 00       	mov    $0x7,%eax
    15b1:	cd 40                	int    $0x40
    15b3:	c3                   	ret    

000015b4 <open>:
SYSCALL(open)
    15b4:	b8 0f 00 00 00       	mov    $0xf,%eax
    15b9:	cd 40                	int    $0x40
    15bb:	c3                   	ret    

000015bc <mknod>:
SYSCALL(mknod)
    15bc:	b8 11 00 00 00       	mov    $0x11,%eax
    15c1:	cd 40                	int    $0x40
    15c3:	c3                   	ret    

000015c4 <unlink>:
SYSCALL(unlink)
    15c4:	b8 12 00 00 00       	mov    $0x12,%eax
    15c9:	cd 40                	int    $0x40
    15cb:	c3                   	ret    

000015cc <fstat>:
SYSCALL(fstat)
    15cc:	b8 08 00 00 00       	mov    $0x8,%eax
    15d1:	cd 40                	int    $0x40
    15d3:	c3                   	ret    

000015d4 <link>:
SYSCALL(link)
    15d4:	b8 13 00 00 00       	mov    $0x13,%eax
    15d9:	cd 40                	int    $0x40
    15db:	c3                   	ret    

000015dc <mkdir>:
SYSCALL(mkdir)
    15dc:	b8 14 00 00 00       	mov    $0x14,%eax
    15e1:	cd 40                	int    $0x40
    15e3:	c3                   	ret    

000015e4 <chdir>:
SYSCALL(chdir)
    15e4:	b8 09 00 00 00       	mov    $0x9,%eax
    15e9:	cd 40                	int    $0x40
    15eb:	c3                   	ret    

000015ec <dup>:
SYSCALL(dup)
    15ec:	b8 0a 00 00 00       	mov    $0xa,%eax
    15f1:	cd 40                	int    $0x40
    15f3:	c3                   	ret    

000015f4 <getpid>:
SYSCALL(getpid)
    15f4:	b8 0b 00 00 00       	mov    $0xb,%eax
    15f9:	cd 40                	int    $0x40
    15fb:	c3                   	ret    

000015fc <sbrk>:
SYSCALL(sbrk)
    15fc:	b8 0c 00 00 00       	mov    $0xc,%eax
    1601:	cd 40                	int    $0x40
    1603:	c3                   	ret    

00001604 <sleep>:
SYSCALL(sleep)
    1604:	b8 0d 00 00 00       	mov    $0xd,%eax
    1609:	cd 40                	int    $0x40
    160b:	c3                   	ret    

0000160c <uptime>:
SYSCALL(uptime)
    160c:	b8 0e 00 00 00       	mov    $0xe,%eax
    1611:	cd 40                	int    $0x40
    1613:	c3                   	ret    

00001614 <getname>:
SYSCALL(getname)
    1614:	b8 16 00 00 00       	mov    $0x16,%eax
    1619:	cd 40                	int    $0x40
    161b:	c3                   	ret    

0000161c <setname>:
SYSCALL(setname)
    161c:	b8 17 00 00 00       	mov    $0x17,%eax
    1621:	cd 40                	int    $0x40
    1623:	c3                   	ret    

00001624 <getmaxproc>:
SYSCALL(getmaxproc)
    1624:	b8 18 00 00 00       	mov    $0x18,%eax
    1629:	cd 40                	int    $0x40
    162b:	c3                   	ret    

0000162c <setmaxproc>:
SYSCALL(setmaxproc)
    162c:	b8 19 00 00 00       	mov    $0x19,%eax
    1631:	cd 40                	int    $0x40
    1633:	c3                   	ret    

00001634 <getmaxmem>:
SYSCALL(getmaxmem)
    1634:	b8 1a 00 00 00       	mov    $0x1a,%eax
    1639:	cd 40                	int    $0x40
    163b:	c3                   	ret    

0000163c <setmaxmem>:
SYSCALL(setmaxmem)
    163c:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1641:	cd 40                	int    $0x40
    1643:	c3                   	ret    

00001644 <getmaxdisk>:
SYSCALL(getmaxdisk)
    1644:	b8 1c 00 00 00       	mov    $0x1c,%eax
    1649:	cd 40                	int    $0x40
    164b:	c3                   	ret    

0000164c <setmaxdisk>:
SYSCALL(setmaxdisk)
    164c:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1651:	cd 40                	int    $0x40
    1653:	c3                   	ret    

00001654 <getusedmem>:
SYSCALL(getusedmem)
    1654:	b8 1e 00 00 00       	mov    $0x1e,%eax
    1659:	cd 40                	int    $0x40
    165b:	c3                   	ret    

0000165c <setusedmem>:
SYSCALL(setusedmem)
    165c:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1661:	cd 40                	int    $0x40
    1663:	c3                   	ret    

00001664 <getuseddisk>:
SYSCALL(getuseddisk)
    1664:	b8 20 00 00 00       	mov    $0x20,%eax
    1669:	cd 40                	int    $0x40
    166b:	c3                   	ret    

0000166c <setuseddisk>:
SYSCALL(setuseddisk)
    166c:	b8 21 00 00 00       	mov    $0x21,%eax
    1671:	cd 40                	int    $0x40
    1673:	c3                   	ret    

00001674 <setvc>:
SYSCALL(setvc)
    1674:	b8 22 00 00 00       	mov    $0x22,%eax
    1679:	cd 40                	int    $0x40
    167b:	c3                   	ret    

0000167c <setactivefs>:
SYSCALL(setactivefs)
    167c:	b8 24 00 00 00       	mov    $0x24,%eax
    1681:	cd 40                	int    $0x40
    1683:	c3                   	ret    

00001684 <getactivefs>:
SYSCALL(getactivefs)
    1684:	b8 25 00 00 00       	mov    $0x25,%eax
    1689:	cd 40                	int    $0x40
    168b:	c3                   	ret    

0000168c <getvcfs>:
SYSCALL(getvcfs)
    168c:	b8 23 00 00 00       	mov    $0x23,%eax
    1691:	cd 40                	int    $0x40
    1693:	c3                   	ret    

00001694 <getcwd>:
SYSCALL(getcwd)
    1694:	b8 26 00 00 00       	mov    $0x26,%eax
    1699:	cd 40                	int    $0x40
    169b:	c3                   	ret    

0000169c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    169c:	55                   	push   %ebp
    169d:	89 e5                	mov    %esp,%ebp
    169f:	83 ec 18             	sub    $0x18,%esp
    16a2:	8b 45 0c             	mov    0xc(%ebp),%eax
    16a5:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    16a8:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    16af:	00 
    16b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
    16b3:	89 44 24 04          	mov    %eax,0x4(%esp)
    16b7:	8b 45 08             	mov    0x8(%ebp),%eax
    16ba:	89 04 24             	mov    %eax,(%esp)
    16bd:	e8 d2 fe ff ff       	call   1594 <write>
}
    16c2:	c9                   	leave  
    16c3:	c3                   	ret    

000016c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    16c4:	55                   	push   %ebp
    16c5:	89 e5                	mov    %esp,%ebp
    16c7:	56                   	push   %esi
    16c8:	53                   	push   %ebx
    16c9:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    16cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    16d3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    16d7:	74 17                	je     16f0 <printint+0x2c>
    16d9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    16dd:	79 11                	jns    16f0 <printint+0x2c>
    neg = 1;
    16df:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    16e6:	8b 45 0c             	mov    0xc(%ebp),%eax
    16e9:	f7 d8                	neg    %eax
    16eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    16ee:	eb 06                	jmp    16f6 <printint+0x32>
  } else {
    x = xx;
    16f0:	8b 45 0c             	mov    0xc(%ebp),%eax
    16f3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    16f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    16fd:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1700:	8d 41 01             	lea    0x1(%ecx),%eax
    1703:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1706:	8b 5d 10             	mov    0x10(%ebp),%ebx
    1709:	8b 45 ec             	mov    -0x14(%ebp),%eax
    170c:	ba 00 00 00 00       	mov    $0x0,%edx
    1711:	f7 f3                	div    %ebx
    1713:	89 d0                	mov    %edx,%eax
    1715:	8a 80 cc 22 00 00    	mov    0x22cc(%eax),%al
    171b:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    171f:	8b 75 10             	mov    0x10(%ebp),%esi
    1722:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1725:	ba 00 00 00 00       	mov    $0x0,%edx
    172a:	f7 f6                	div    %esi
    172c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    172f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1733:	75 c8                	jne    16fd <printint+0x39>
  if(neg)
    1735:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1739:	74 10                	je     174b <printint+0x87>
    buf[i++] = '-';
    173b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    173e:	8d 50 01             	lea    0x1(%eax),%edx
    1741:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1744:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    1749:	eb 1e                	jmp    1769 <printint+0xa5>
    174b:	eb 1c                	jmp    1769 <printint+0xa5>
    putc(fd, buf[i]);
    174d:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1750:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1753:	01 d0                	add    %edx,%eax
    1755:	8a 00                	mov    (%eax),%al
    1757:	0f be c0             	movsbl %al,%eax
    175a:	89 44 24 04          	mov    %eax,0x4(%esp)
    175e:	8b 45 08             	mov    0x8(%ebp),%eax
    1761:	89 04 24             	mov    %eax,(%esp)
    1764:	e8 33 ff ff ff       	call   169c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    1769:	ff 4d f4             	decl   -0xc(%ebp)
    176c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1770:	79 db                	jns    174d <printint+0x89>
    putc(fd, buf[i]);
}
    1772:	83 c4 30             	add    $0x30,%esp
    1775:	5b                   	pop    %ebx
    1776:	5e                   	pop    %esi
    1777:	5d                   	pop    %ebp
    1778:	c3                   	ret    

00001779 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    1779:	55                   	push   %ebp
    177a:	89 e5                	mov    %esp,%ebp
    177c:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    177f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    1786:	8d 45 0c             	lea    0xc(%ebp),%eax
    1789:	83 c0 04             	add    $0x4,%eax
    178c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    178f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    1796:	e9 77 01 00 00       	jmp    1912 <printf+0x199>
    c = fmt[i] & 0xff;
    179b:	8b 55 0c             	mov    0xc(%ebp),%edx
    179e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    17a1:	01 d0                	add    %edx,%eax
    17a3:	8a 00                	mov    (%eax),%al
    17a5:	0f be c0             	movsbl %al,%eax
    17a8:	25 ff 00 00 00       	and    $0xff,%eax
    17ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    17b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    17b4:	75 2c                	jne    17e2 <printf+0x69>
      if(c == '%'){
    17b6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    17ba:	75 0c                	jne    17c8 <printf+0x4f>
        state = '%';
    17bc:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    17c3:	e9 47 01 00 00       	jmp    190f <printf+0x196>
      } else {
        putc(fd, c);
    17c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    17cb:	0f be c0             	movsbl %al,%eax
    17ce:	89 44 24 04          	mov    %eax,0x4(%esp)
    17d2:	8b 45 08             	mov    0x8(%ebp),%eax
    17d5:	89 04 24             	mov    %eax,(%esp)
    17d8:	e8 bf fe ff ff       	call   169c <putc>
    17dd:	e9 2d 01 00 00       	jmp    190f <printf+0x196>
      }
    } else if(state == '%'){
    17e2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    17e6:	0f 85 23 01 00 00    	jne    190f <printf+0x196>
      if(c == 'd'){
    17ec:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    17f0:	75 2d                	jne    181f <printf+0xa6>
        printint(fd, *ap, 10, 1);
    17f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    17f5:	8b 00                	mov    (%eax),%eax
    17f7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    17fe:	00 
    17ff:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    1806:	00 
    1807:	89 44 24 04          	mov    %eax,0x4(%esp)
    180b:	8b 45 08             	mov    0x8(%ebp),%eax
    180e:	89 04 24             	mov    %eax,(%esp)
    1811:	e8 ae fe ff ff       	call   16c4 <printint>
        ap++;
    1816:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    181a:	e9 e9 00 00 00       	jmp    1908 <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    181f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1823:	74 06                	je     182b <printf+0xb2>
    1825:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    1829:	75 2d                	jne    1858 <printf+0xdf>
        printint(fd, *ap, 16, 0);
    182b:	8b 45 e8             	mov    -0x18(%ebp),%eax
    182e:	8b 00                	mov    (%eax),%eax
    1830:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    1837:	00 
    1838:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    183f:	00 
    1840:	89 44 24 04          	mov    %eax,0x4(%esp)
    1844:	8b 45 08             	mov    0x8(%ebp),%eax
    1847:	89 04 24             	mov    %eax,(%esp)
    184a:	e8 75 fe ff ff       	call   16c4 <printint>
        ap++;
    184f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1853:	e9 b0 00 00 00       	jmp    1908 <printf+0x18f>
      } else if(c == 's'){
    1858:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    185c:	75 42                	jne    18a0 <printf+0x127>
        s = (char*)*ap;
    185e:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1861:	8b 00                	mov    (%eax),%eax
    1863:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1866:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    186a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    186e:	75 09                	jne    1879 <printf+0x100>
          s = "(null)";
    1870:	c7 45 f4 77 1c 00 00 	movl   $0x1c77,-0xc(%ebp)
        while(*s != 0){
    1877:	eb 1c                	jmp    1895 <printf+0x11c>
    1879:	eb 1a                	jmp    1895 <printf+0x11c>
          putc(fd, *s);
    187b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    187e:	8a 00                	mov    (%eax),%al
    1880:	0f be c0             	movsbl %al,%eax
    1883:	89 44 24 04          	mov    %eax,0x4(%esp)
    1887:	8b 45 08             	mov    0x8(%ebp),%eax
    188a:	89 04 24             	mov    %eax,(%esp)
    188d:	e8 0a fe ff ff       	call   169c <putc>
          s++;
    1892:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1895:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1898:	8a 00                	mov    (%eax),%al
    189a:	84 c0                	test   %al,%al
    189c:	75 dd                	jne    187b <printf+0x102>
    189e:	eb 68                	jmp    1908 <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    18a0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    18a4:	75 1d                	jne    18c3 <printf+0x14a>
        putc(fd, *ap);
    18a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    18a9:	8b 00                	mov    (%eax),%eax
    18ab:	0f be c0             	movsbl %al,%eax
    18ae:	89 44 24 04          	mov    %eax,0x4(%esp)
    18b2:	8b 45 08             	mov    0x8(%ebp),%eax
    18b5:	89 04 24             	mov    %eax,(%esp)
    18b8:	e8 df fd ff ff       	call   169c <putc>
        ap++;
    18bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    18c1:	eb 45                	jmp    1908 <printf+0x18f>
      } else if(c == '%'){
    18c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    18c7:	75 17                	jne    18e0 <printf+0x167>
        putc(fd, c);
    18c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18cc:	0f be c0             	movsbl %al,%eax
    18cf:	89 44 24 04          	mov    %eax,0x4(%esp)
    18d3:	8b 45 08             	mov    0x8(%ebp),%eax
    18d6:	89 04 24             	mov    %eax,(%esp)
    18d9:	e8 be fd ff ff       	call   169c <putc>
    18de:	eb 28                	jmp    1908 <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    18e0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    18e7:	00 
    18e8:	8b 45 08             	mov    0x8(%ebp),%eax
    18eb:	89 04 24             	mov    %eax,(%esp)
    18ee:	e8 a9 fd ff ff       	call   169c <putc>
        putc(fd, c);
    18f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    18f6:	0f be c0             	movsbl %al,%eax
    18f9:	89 44 24 04          	mov    %eax,0x4(%esp)
    18fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1900:	89 04 24             	mov    %eax,(%esp)
    1903:	e8 94 fd ff ff       	call   169c <putc>
      }
      state = 0;
    1908:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    190f:	ff 45 f0             	incl   -0x10(%ebp)
    1912:	8b 55 0c             	mov    0xc(%ebp),%edx
    1915:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1918:	01 d0                	add    %edx,%eax
    191a:	8a 00                	mov    (%eax),%al
    191c:	84 c0                	test   %al,%al
    191e:	0f 85 77 fe ff ff    	jne    179b <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1924:	c9                   	leave  
    1925:	c3                   	ret    
    1926:	90                   	nop
    1927:	90                   	nop

00001928 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1928:	55                   	push   %ebp
    1929:	89 e5                	mov    %esp,%ebp
    192b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    192e:	8b 45 08             	mov    0x8(%ebp),%eax
    1931:	83 e8 08             	sub    $0x8,%eax
    1934:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1937:	a1 54 23 00 00       	mov    0x2354,%eax
    193c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    193f:	eb 24                	jmp    1965 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1941:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1944:	8b 00                	mov    (%eax),%eax
    1946:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1949:	77 12                	ja     195d <free+0x35>
    194b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    194e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1951:	77 24                	ja     1977 <free+0x4f>
    1953:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1956:	8b 00                	mov    (%eax),%eax
    1958:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    195b:	77 1a                	ja     1977 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    195d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1960:	8b 00                	mov    (%eax),%eax
    1962:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1965:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1968:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    196b:	76 d4                	jbe    1941 <free+0x19>
    196d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1970:	8b 00                	mov    (%eax),%eax
    1972:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1975:	76 ca                	jbe    1941 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1977:	8b 45 f8             	mov    -0x8(%ebp),%eax
    197a:	8b 40 04             	mov    0x4(%eax),%eax
    197d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1984:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1987:	01 c2                	add    %eax,%edx
    1989:	8b 45 fc             	mov    -0x4(%ebp),%eax
    198c:	8b 00                	mov    (%eax),%eax
    198e:	39 c2                	cmp    %eax,%edx
    1990:	75 24                	jne    19b6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1992:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1995:	8b 50 04             	mov    0x4(%eax),%edx
    1998:	8b 45 fc             	mov    -0x4(%ebp),%eax
    199b:	8b 00                	mov    (%eax),%eax
    199d:	8b 40 04             	mov    0x4(%eax),%eax
    19a0:	01 c2                	add    %eax,%edx
    19a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19a5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    19a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19ab:	8b 00                	mov    (%eax),%eax
    19ad:	8b 10                	mov    (%eax),%edx
    19af:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19b2:	89 10                	mov    %edx,(%eax)
    19b4:	eb 0a                	jmp    19c0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    19b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19b9:	8b 10                	mov    (%eax),%edx
    19bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19be:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    19c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19c3:	8b 40 04             	mov    0x4(%eax),%eax
    19c6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    19cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19d0:	01 d0                	add    %edx,%eax
    19d2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    19d5:	75 20                	jne    19f7 <free+0xcf>
    p->s.size += bp->s.size;
    19d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19da:	8b 50 04             	mov    0x4(%eax),%edx
    19dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19e0:	8b 40 04             	mov    0x4(%eax),%eax
    19e3:	01 c2                	add    %eax,%edx
    19e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19e8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    19eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    19ee:	8b 10                	mov    (%eax),%edx
    19f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19f3:	89 10                	mov    %edx,(%eax)
    19f5:	eb 08                	jmp    19ff <free+0xd7>
  } else
    p->s.ptr = bp;
    19f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    19fa:	8b 55 f8             	mov    -0x8(%ebp),%edx
    19fd:	89 10                	mov    %edx,(%eax)
  freep = p;
    19ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a02:	a3 54 23 00 00       	mov    %eax,0x2354
}
    1a07:	c9                   	leave  
    1a08:	c3                   	ret    

00001a09 <morecore>:

static Header*
morecore(uint nu)
{
    1a09:	55                   	push   %ebp
    1a0a:	89 e5                	mov    %esp,%ebp
    1a0c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1a0f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1a16:	77 07                	ja     1a1f <morecore+0x16>
    nu = 4096;
    1a18:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1a1f:	8b 45 08             	mov    0x8(%ebp),%eax
    1a22:	c1 e0 03             	shl    $0x3,%eax
    1a25:	89 04 24             	mov    %eax,(%esp)
    1a28:	e8 cf fb ff ff       	call   15fc <sbrk>
    1a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1a30:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1a34:	75 07                	jne    1a3d <morecore+0x34>
    return 0;
    1a36:	b8 00 00 00 00       	mov    $0x0,%eax
    1a3b:	eb 22                	jmp    1a5f <morecore+0x56>
  hp = (Header*)p;
    1a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a46:	8b 55 08             	mov    0x8(%ebp),%edx
    1a49:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a4f:	83 c0 08             	add    $0x8,%eax
    1a52:	89 04 24             	mov    %eax,(%esp)
    1a55:	e8 ce fe ff ff       	call   1928 <free>
  return freep;
    1a5a:	a1 54 23 00 00       	mov    0x2354,%eax
}
    1a5f:	c9                   	leave  
    1a60:	c3                   	ret    

00001a61 <malloc>:

void*
malloc(uint nbytes)
{
    1a61:	55                   	push   %ebp
    1a62:	89 e5                	mov    %esp,%ebp
    1a64:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1a67:	8b 45 08             	mov    0x8(%ebp),%eax
    1a6a:	83 c0 07             	add    $0x7,%eax
    1a6d:	c1 e8 03             	shr    $0x3,%eax
    1a70:	40                   	inc    %eax
    1a71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1a74:	a1 54 23 00 00       	mov    0x2354,%eax
    1a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1a7c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1a80:	75 23                	jne    1aa5 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1a82:	c7 45 f0 4c 23 00 00 	movl   $0x234c,-0x10(%ebp)
    1a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a8c:	a3 54 23 00 00       	mov    %eax,0x2354
    1a91:	a1 54 23 00 00       	mov    0x2354,%eax
    1a96:	a3 4c 23 00 00       	mov    %eax,0x234c
    base.s.size = 0;
    1a9b:	c7 05 50 23 00 00 00 	movl   $0x0,0x2350
    1aa2:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1aa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1aa8:	8b 00                	mov    (%eax),%eax
    1aaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ab0:	8b 40 04             	mov    0x4(%eax),%eax
    1ab3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ab6:	72 4d                	jb     1b05 <malloc+0xa4>
      if(p->s.size == nunits)
    1ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1abb:	8b 40 04             	mov    0x4(%eax),%eax
    1abe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1ac1:	75 0c                	jne    1acf <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ac6:	8b 10                	mov    (%eax),%edx
    1ac8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1acb:	89 10                	mov    %edx,(%eax)
    1acd:	eb 26                	jmp    1af5 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ad2:	8b 40 04             	mov    0x4(%eax),%eax
    1ad5:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1ad8:	89 c2                	mov    %eax,%edx
    1ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1add:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ae3:	8b 40 04             	mov    0x4(%eax),%eax
    1ae6:	c1 e0 03             	shl    $0x3,%eax
    1ae9:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1aec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1aef:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1af2:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1af8:	a3 54 23 00 00       	mov    %eax,0x2354
      return (void*)(p + 1);
    1afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b00:	83 c0 08             	add    $0x8,%eax
    1b03:	eb 38                	jmp    1b3d <malloc+0xdc>
    }
    if(p == freep)
    1b05:	a1 54 23 00 00       	mov    0x2354,%eax
    1b0a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1b0d:	75 1b                	jne    1b2a <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1b0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1b12:	89 04 24             	mov    %eax,(%esp)
    1b15:	e8 ef fe ff ff       	call   1a09 <morecore>
    1b1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1b1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1b21:	75 07                	jne    1b2a <malloc+0xc9>
        return 0;
    1b23:	b8 00 00 00 00       	mov    $0x0,%eax
    1b28:	eb 13                	jmp    1b3d <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b33:	8b 00                	mov    (%eax),%eax
    1b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1b38:	e9 70 ff ff ff       	jmp    1aad <malloc+0x4c>
}
    1b3d:	c9                   	leave  
    1b3e:	c3                   	ret    
