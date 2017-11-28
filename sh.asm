
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <isfscmd>:
int fork1(void);  // Fork but panics on failure.
void panic(char*);
struct cmd *parsecmd(char*);

int 
isfscmd(char* cmd){
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  printf(1, "in isfscmd\n");
       6:	c7 44 24 04 04 1d 00 	movl   $0x1d04,0x4(%esp)
       d:	00 
       e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      15:	e8 23 19 00 00       	call   193d <printf>
  if(strcmp(cmd, "mkdir") == 0 || strcmp(cmd, "ls") == 0){
      1a:	c7 44 24 04 10 1d 00 	movl   $0x1d10,0x4(%esp)
      21:	00 
      22:	8b 45 08             	mov    0x8(%ebp),%eax
      25:	89 04 24             	mov    %eax,(%esp)
      28:	e8 7e 10 00 00       	call   10ab <strcmp>
      2d:	85 c0                	test   %eax,%eax
      2f:	74 17                	je     48 <isfscmd+0x48>
      31:	c7 44 24 04 16 1d 00 	movl   $0x1d16,0x4(%esp)
      38:	00 
      39:	8b 45 08             	mov    0x8(%ebp),%eax
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 67 10 00 00       	call   10ab <strcmp>
      44:	85 c0                	test   %eax,%eax
      46:	75 07                	jne    4f <isfscmd+0x4f>
    return 1;
      48:	b8 01 00 00 00       	mov    $0x1,%eax
      4d:	eb 05                	jmp    54 <isfscmd+0x54>
  }return 0;
      4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
      54:	c9                   	leave  
      55:	c3                   	ret    

00000056 <ifsafepath>:

int
ifsafepath(char *path){
      56:	55                   	push   %ebp
      57:	89 e5                	mov    %esp,%ebp
      59:	81 ec 38 01 00 00    	sub    $0x138,%esp
  if(path == 0){
      5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
      63:	75 0a                	jne    6f <ifsafepath+0x19>
    return 1;
      65:	b8 01 00 00 00       	mov    $0x1,%eax
      6a:	e9 f7 00 00 00       	jmp    166 <ifsafepath+0x110>
  }
  int path_len = 0;
      6f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int new_path_len;
  char *tok_path = path;
      76:	8b 45 08             	mov    0x8(%ebp),%eax
      79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char currpath[256];
  int index = getactivefsindex();
      7c:	e8 b7 17 00 00       	call   1838 <getactivefsindex>
      81:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  getpath(index, currpath);
      84:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
      8a:	89 44 24 04          	mov    %eax,0x4(%esp)
      8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      91:	89 04 24             	mov    %eax,(%esp)
      94:	e8 b7 17 00 00       	call   1850 <getpath>
  char *tok_currpath = currpath;
      99:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
      9f:	89 45 e8             	mov    %eax,-0x18(%ebp)

  while ((tok_currpath = strtok(tok_currpath, "/")) != 0){
      a2:	eb 0a                	jmp    ae <ifsafepath+0x58>
    path_len++;
      a4:	ff 45 f4             	incl   -0xc(%ebp)
    tok_currpath = 0;
      a7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  char currpath[256];
  int index = getactivefsindex();
  getpath(index, currpath);
  char *tok_currpath = currpath;

  while ((tok_currpath = strtok(tok_currpath, "/")) != 0){
      ae:	c7 44 24 04 19 1d 00 	movl   $0x1d19,0x4(%esp)
      b5:	00 
      b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
      b9:	89 04 24             	mov    %eax,(%esp)
      bc:	e8 f9 11 00 00       	call   12ba <strtok>
      c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
      c4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      c8:	75 da                	jne    a4 <ifsafepath+0x4e>
    path_len++;
    tok_currpath = 0;
  }

  if(path[0] != '/'){
      ca:	8b 45 08             	mov    0x8(%ebp),%eax
      cd:	8a 00                	mov    (%eax),%al
      cf:	3c 2f                	cmp    $0x2f,%al
      d1:	74 08                	je     db <ifsafepath+0x85>
    new_path_len = path_len;
      d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
      d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
      d9:	eb 07                	jmp    e2 <ifsafepath+0x8c>
  }else{
    new_path_len = 0;
      db:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }

  printf(1, "path len = %d\n", new_path_len);
      e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
      e5:	89 44 24 08          	mov    %eax,0x8(%esp)
      e9:	c7 44 24 04 1b 1d 00 	movl   $0x1d1b,0x4(%esp)
      f0:	00 
      f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
      f8:	e8 40 18 00 00       	call   193d <printf>

  while ((tok_path = strtok(tok_path, "/")) != 0){
      fd:	eb 41                	jmp    140 <ifsafepath+0xea>
    printf(1, "token = %s\n", tok_path);
      ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
     102:	89 44 24 08          	mov    %eax,0x8(%esp)
     106:	c7 44 24 04 2a 1d 00 	movl   $0x1d2a,0x4(%esp)
     10d:	00 
     10e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     115:	e8 23 18 00 00       	call   193d <printf>
    if(strcmp(tok_path, "..") == 0){
     11a:	c7 44 24 04 36 1d 00 	movl   $0x1d36,0x4(%esp)
     121:	00 
     122:	8b 45 ec             	mov    -0x14(%ebp),%eax
     125:	89 04 24             	mov    %eax,(%esp)
     128:	e8 7e 0f 00 00       	call   10ab <strcmp>
     12d:	85 c0                	test   %eax,%eax
     12f:	75 05                	jne    136 <ifsafepath+0xe0>
      new_path_len--;
     131:	ff 4d f0             	decl   -0x10(%ebp)
     134:	eb 03                	jmp    139 <ifsafepath+0xe3>
    }else{
      new_path_len++;
     136:	ff 45 f0             	incl   -0x10(%ebp)
    }
    tok_path = 0;
     139:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    new_path_len = 0;
  }

  printf(1, "path len = %d\n", new_path_len);

  while ((tok_path = strtok(tok_path, "/")) != 0){
     140:	c7 44 24 04 19 1d 00 	movl   $0x1d19,0x4(%esp)
     147:	00 
     148:	8b 45 ec             	mov    -0x14(%ebp),%eax
     14b:	89 04 24             	mov    %eax,(%esp)
     14e:	e8 67 11 00 00       	call   12ba <strtok>
     153:	89 45 ec             	mov    %eax,-0x14(%ebp)
     156:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     15a:	75 a3                	jne    ff <ifsafepath+0xa9>
      new_path_len++;
    }
    tok_path = 0;
  }

  return new_path_len > 0;
     15c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     160:	0f 9f c0             	setg   %al
     163:	0f b6 c0             	movzbl %al,%eax

}
     166:	c9                   	leave  
     167:	c3                   	ret    

00000168 <runcmd>:

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     168:	55                   	push   %ebp
     169:	89 e5                	mov    %esp,%ebp
     16b:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     16e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     172:	75 05                	jne    179 <runcmd+0x11>
    exit();
     174:	e8 8f 15 00 00       	call   1708 <exit>

  switch(cmd->type){
     179:	8b 45 08             	mov    0x8(%ebp),%eax
     17c:	8b 00                	mov    (%eax),%eax
     17e:	83 f8 05             	cmp    $0x5,%eax
     181:	77 09                	ja     18c <runcmd+0x24>
     183:	8b 04 85 90 1d 00 00 	mov    0x1d90(,%eax,4),%eax
     18a:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
     18c:	c7 04 24 39 1d 00 00 	movl   $0x1d39,(%esp)
     193:	e8 31 04 00 00       	call   5c9 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
     198:	8b 45 08             	mov    0x8(%ebp),%eax
     19b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
     19e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1a1:	8b 40 04             	mov    0x4(%eax),%eax
     1a4:	85 c0                	test   %eax,%eax
     1a6:	75 05                	jne    1ad <runcmd+0x45>
      exit();
     1a8:	e8 5b 15 00 00       	call   1708 <exit>

    if(isfscmd(ecmd->argv[0]) && !ifsafepath(ecmd->argv[1])){
     1ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1b0:	8b 40 04             	mov    0x4(%eax),%eax
     1b3:	89 04 24             	mov    %eax,(%esp)
     1b6:	e8 45 fe ff ff       	call   0 <isfscmd>
     1bb:	85 c0                	test   %eax,%eax
     1bd:	74 35                	je     1f4 <runcmd+0x8c>
     1bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c2:	8b 40 08             	mov    0x8(%eax),%eax
     1c5:	89 04 24             	mov    %eax,(%esp)
     1c8:	e8 89 fe ff ff       	call   56 <ifsafepath>
     1cd:	85 c0                	test   %eax,%eax
     1cf:	75 23                	jne    1f4 <runcmd+0x8c>
      printf(2, "You dont have permission to go here! \"%s\"\n", ecmd->argv[1]);
     1d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1d4:	8b 40 08             	mov    0x8(%eax),%eax
     1d7:	89 44 24 08          	mov    %eax,0x8(%esp)
     1db:	c7 44 24 04 40 1d 00 	movl   $0x1d40,0x4(%esp)
     1e2:	00 
     1e3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     1ea:	e8 4e 17 00 00       	call   193d <printf>
      break;
     1ef:	e9 c1 01 00 00       	jmp    3b5 <runcmd+0x24d>
    }
    exec(ecmd->argv[0], ecmd->argv);
     1f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1f7:	8d 50 04             	lea    0x4(%eax),%edx
     1fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1fd:	8b 40 04             	mov    0x4(%eax),%eax
     200:	89 54 24 04          	mov    %edx,0x4(%esp)
     204:	89 04 24             	mov    %eax,(%esp)
     207:	e8 34 15 00 00       	call   1740 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     20c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     20f:	8b 40 04             	mov    0x4(%eax),%eax
     212:	89 44 24 08          	mov    %eax,0x8(%esp)
     216:	c7 44 24 04 6b 1d 00 	movl   $0x1d6b,0x4(%esp)
     21d:	00 
     21e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     225:	e8 13 17 00 00       	call   193d <printf>
    break;
     22a:	e9 86 01 00 00       	jmp    3b5 <runcmd+0x24d>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     22f:	8b 45 08             	mov    0x8(%ebp),%eax
     232:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
     235:	8b 45 f0             	mov    -0x10(%ebp),%eax
     238:	8b 40 14             	mov    0x14(%eax),%eax
     23b:	89 04 24             	mov    %eax,(%esp)
     23e:	e8 ed 14 00 00       	call   1730 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     243:	8b 45 f0             	mov    -0x10(%ebp),%eax
     246:	8b 50 10             	mov    0x10(%eax),%edx
     249:	8b 45 f0             	mov    -0x10(%ebp),%eax
     24c:	8b 40 08             	mov    0x8(%eax),%eax
     24f:	89 54 24 04          	mov    %edx,0x4(%esp)
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 ed 14 00 00       	call   1748 <open>
     25b:	85 c0                	test   %eax,%eax
     25d:	79 23                	jns    282 <runcmd+0x11a>
      printf(2, "open %s failed\n", rcmd->file);
     25f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     262:	8b 40 08             	mov    0x8(%eax),%eax
     265:	89 44 24 08          	mov    %eax,0x8(%esp)
     269:	c7 44 24 04 7b 1d 00 	movl   $0x1d7b,0x4(%esp)
     270:	00 
     271:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     278:	e8 c0 16 00 00       	call   193d <printf>
      exit();
     27d:	e8 86 14 00 00       	call   1708 <exit>
    }
    runcmd(rcmd->cmd);
     282:	8b 45 f0             	mov    -0x10(%ebp),%eax
     285:	8b 40 04             	mov    0x4(%eax),%eax
     288:	89 04 24             	mov    %eax,(%esp)
     28b:	e8 d8 fe ff ff       	call   168 <runcmd>
    break;
     290:	e9 20 01 00 00       	jmp    3b5 <runcmd+0x24d>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     295:	8b 45 08             	mov    0x8(%ebp),%eax
     298:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
     29b:	e8 4f 03 00 00       	call   5ef <fork1>
     2a0:	85 c0                	test   %eax,%eax
     2a2:	75 0e                	jne    2b2 <runcmd+0x14a>
      runcmd(lcmd->left);
     2a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2a7:	8b 40 04             	mov    0x4(%eax),%eax
     2aa:	89 04 24             	mov    %eax,(%esp)
     2ad:	e8 b6 fe ff ff       	call   168 <runcmd>
    wait();
     2b2:	e8 59 14 00 00       	call   1710 <wait>
    runcmd(lcmd->right);
     2b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2ba:	8b 40 08             	mov    0x8(%eax),%eax
     2bd:	89 04 24             	mov    %eax,(%esp)
     2c0:	e8 a3 fe ff ff       	call   168 <runcmd>
    break;
     2c5:	e9 eb 00 00 00       	jmp    3b5 <runcmd+0x24d>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     2ca:	8b 45 08             	mov    0x8(%ebp),%eax
     2cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     2d0:	8d 45 dc             	lea    -0x24(%ebp),%eax
     2d3:	89 04 24             	mov    %eax,(%esp)
     2d6:	e8 3d 14 00 00       	call   1718 <pipe>
     2db:	85 c0                	test   %eax,%eax
     2dd:	79 0c                	jns    2eb <runcmd+0x183>
      panic("pipe");
     2df:	c7 04 24 8b 1d 00 00 	movl   $0x1d8b,(%esp)
     2e6:	e8 de 02 00 00       	call   5c9 <panic>
    if(fork1() == 0){
     2eb:	e8 ff 02 00 00       	call   5ef <fork1>
     2f0:	85 c0                	test   %eax,%eax
     2f2:	75 3b                	jne    32f <runcmd+0x1c7>
      close(1);
     2f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2fb:	e8 30 14 00 00       	call   1730 <close>
      dup(p[1]);
     300:	8b 45 e0             	mov    -0x20(%ebp),%eax
     303:	89 04 24             	mov    %eax,(%esp)
     306:	e8 75 14 00 00       	call   1780 <dup>
      close(p[0]);
     30b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     30e:	89 04 24             	mov    %eax,(%esp)
     311:	e8 1a 14 00 00       	call   1730 <close>
      close(p[1]);
     316:	8b 45 e0             	mov    -0x20(%ebp),%eax
     319:	89 04 24             	mov    %eax,(%esp)
     31c:	e8 0f 14 00 00       	call   1730 <close>
      runcmd(pcmd->left);
     321:	8b 45 e8             	mov    -0x18(%ebp),%eax
     324:	8b 40 04             	mov    0x4(%eax),%eax
     327:	89 04 24             	mov    %eax,(%esp)
     32a:	e8 39 fe ff ff       	call   168 <runcmd>
    }
    if(fork1() == 0){
     32f:	e8 bb 02 00 00       	call   5ef <fork1>
     334:	85 c0                	test   %eax,%eax
     336:	75 3b                	jne    373 <runcmd+0x20b>
      close(0);
     338:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     33f:	e8 ec 13 00 00       	call   1730 <close>
      dup(p[0]);
     344:	8b 45 dc             	mov    -0x24(%ebp),%eax
     347:	89 04 24             	mov    %eax,(%esp)
     34a:	e8 31 14 00 00       	call   1780 <dup>
      close(p[0]);
     34f:	8b 45 dc             	mov    -0x24(%ebp),%eax
     352:	89 04 24             	mov    %eax,(%esp)
     355:	e8 d6 13 00 00       	call   1730 <close>
      close(p[1]);
     35a:	8b 45 e0             	mov    -0x20(%ebp),%eax
     35d:	89 04 24             	mov    %eax,(%esp)
     360:	e8 cb 13 00 00       	call   1730 <close>
      runcmd(pcmd->right);
     365:	8b 45 e8             	mov    -0x18(%ebp),%eax
     368:	8b 40 08             	mov    0x8(%eax),%eax
     36b:	89 04 24             	mov    %eax,(%esp)
     36e:	e8 f5 fd ff ff       	call   168 <runcmd>
    }
    close(p[0]);
     373:	8b 45 dc             	mov    -0x24(%ebp),%eax
     376:	89 04 24             	mov    %eax,(%esp)
     379:	e8 b2 13 00 00       	call   1730 <close>
    close(p[1]);
     37e:	8b 45 e0             	mov    -0x20(%ebp),%eax
     381:	89 04 24             	mov    %eax,(%esp)
     384:	e8 a7 13 00 00       	call   1730 <close>
    wait();
     389:	e8 82 13 00 00       	call   1710 <wait>
    wait();
     38e:	e8 7d 13 00 00       	call   1710 <wait>
    break;
     393:	eb 20                	jmp    3b5 <runcmd+0x24d>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     395:	8b 45 08             	mov    0x8(%ebp),%eax
     398:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     39b:	e8 4f 02 00 00       	call   5ef <fork1>
     3a0:	85 c0                	test   %eax,%eax
     3a2:	75 10                	jne    3b4 <runcmd+0x24c>
      runcmd(bcmd->cmd);
     3a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     3a7:	8b 40 04             	mov    0x4(%eax),%eax
     3aa:	89 04 24             	mov    %eax,(%esp)
     3ad:	e8 b6 fd ff ff       	call   168 <runcmd>
    break;
     3b2:	eb 00                	jmp    3b4 <runcmd+0x24c>
     3b4:	90                   	nop
  }
  exit();
     3b5:	e8 4e 13 00 00       	call   1708 <exit>

000003ba <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     3ba:	55                   	push   %ebp
     3bb:	89 e5                	mov    %esp,%ebp
     3bd:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     3c0:	c7 44 24 04 a8 1d 00 	movl   $0x1da8,0x4(%esp)
     3c7:	00 
     3c8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     3cf:	e8 69 15 00 00       	call   193d <printf>
  memset(buf, 0, nbuf);
     3d4:	8b 45 0c             	mov    0xc(%ebp),%eax
     3d7:	89 44 24 08          	mov    %eax,0x8(%esp)
     3db:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     3e2:	00 
     3e3:	8b 45 08             	mov    0x8(%ebp),%eax
     3e6:	89 04 24             	mov    %eax,(%esp)
     3e9:	e8 68 0d 00 00       	call   1156 <memset>
  gets(buf, nbuf);
     3ee:	8b 45 0c             	mov    0xc(%ebp),%eax
     3f1:	89 44 24 04          	mov    %eax,0x4(%esp)
     3f5:	8b 45 08             	mov    0x8(%ebp),%eax
     3f8:	89 04 24             	mov    %eax,(%esp)
     3fb:	e8 b8 11 00 00       	call   15b8 <gets>
  if(buf[0] == 0) // EOF
     400:	8b 45 08             	mov    0x8(%ebp),%eax
     403:	8a 00                	mov    (%eax),%al
     405:	84 c0                	test   %al,%al
     407:	75 07                	jne    410 <getcmd+0x56>
    return -1;
     409:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     40e:	eb 05                	jmp    415 <getcmd+0x5b>
  return 0;
     410:	b8 00 00 00 00       	mov    $0x0,%eax
}
     415:	c9                   	leave  
     416:	c3                   	ret    

00000417 <main>:

int
main(void)
{
     417:	55                   	push   %ebp
     418:	89 e5                	mov    %esp,%ebp
     41a:	83 e4 f0             	and    $0xfffffff0,%esp
     41d:	83 ec 40             	sub    $0x40,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     420:	eb 15                	jmp    437 <main+0x20>
    if(fd >= 3){
     422:	83 7c 24 3c 02       	cmpl   $0x2,0x3c(%esp)
     427:	7e 0e                	jle    437 <main+0x20>
      close(fd);
     429:	8b 44 24 3c          	mov    0x3c(%esp),%eax
     42d:	89 04 24             	mov    %eax,(%esp)
     430:	e8 fb 12 00 00       	call   1730 <close>
      break;
     435:	eb 1f                	jmp    456 <main+0x3f>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     437:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     43e:	00 
     43f:	c7 04 24 ab 1d 00 00 	movl   $0x1dab,(%esp)
     446:	e8 fd 12 00 00       	call   1748 <open>
     44b:	89 44 24 3c          	mov    %eax,0x3c(%esp)
     44f:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
     454:	79 cc                	jns    422 <main+0xb>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     456:	e9 4d 01 00 00       	jmp    5a8 <main+0x191>
    char fs[32];
    int index = getactivefsindex();
     45b:	e8 d8 13 00 00       	call   1838 <getactivefsindex>
     460:	89 44 24 38          	mov    %eax,0x38(%esp)
    getactivefs(fs);
     464:	8d 44 24 18          	lea    0x18(%esp),%eax
     468:	89 04 24             	mov    %eax,(%esp)
     46b:	e8 a8 13 00 00       	call   1818 <getactivefs>
    if((strcmp(buf, "/\n") == 0) || (buf[0] == 'c' && buf[1] == 'd' && buf[2] == 10)){
     470:	c7 44 24 04 b3 1d 00 	movl   $0x1db3,0x4(%esp)
     477:	00 
     478:	c7 04 24 20 25 00 00 	movl   $0x2520,(%esp)
     47f:	e8 27 0c 00 00       	call   10ab <strcmp>
     484:	85 c0                	test   %eax,%eax
     486:	74 1b                	je     4a3 <main+0x8c>
     488:	a0 20 25 00 00       	mov    0x2520,%al
     48d:	3c 63                	cmp    $0x63,%al
     48f:	75 64                	jne    4f5 <main+0xde>
     491:	a0 21 25 00 00       	mov    0x2521,%al
     496:	3c 64                	cmp    $0x64,%al
     498:	75 5b                	jne    4f5 <main+0xde>
     49a:	a0 22 25 00 00       	mov    0x2522,%al
     49f:	3c 0a                	cmp    $0xa,%al
     4a1:	75 52                	jne    4f5 <main+0xde>
      setpath(index, fs, 1);
     4a3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     4aa:	00 
     4ab:	8d 44 24 18          	lea    0x18(%esp),%eax
     4af:	89 44 24 04          	mov    %eax,0x4(%esp)
     4b3:	8b 44 24 38          	mov    0x38(%esp),%eax
     4b7:	89 04 24             	mov    %eax,(%esp)
     4ba:	e8 99 13 00 00       	call   1858 <setpath>
      if(chdir(fs) < 0)
     4bf:	8d 44 24 18          	lea    0x18(%esp),%eax
     4c3:	89 04 24             	mov    %eax,(%esp)
     4c6:	e8 ad 12 00 00       	call   1778 <chdir>
     4cb:	85 c0                	test   %eax,%eax
     4cd:	79 21                	jns    4f0 <main+0xd9>
        printf(2, "cannot cd %s\n", fs);
     4cf:	8d 44 24 18          	lea    0x18(%esp),%eax
     4d3:	89 44 24 08          	mov    %eax,0x8(%esp)
     4d7:	c7 44 24 04 b6 1d 00 	movl   $0x1db6,0x4(%esp)
     4de:	00 
     4df:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     4e6:	e8 52 14 00 00       	call   193d <printf>
      continue;
     4eb:	e9 b8 00 00 00       	jmp    5a8 <main+0x191>
     4f0:	e9 b3 00 00 00       	jmp    5a8 <main+0x191>
    }
    else if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     4f5:	a0 20 25 00 00       	mov    0x2520,%al
     4fa:	3c 63                	cmp    $0x63,%al
     4fc:	0f 85 84 00 00 00    	jne    586 <main+0x16f>
     502:	a0 21 25 00 00       	mov    0x2521,%al
     507:	3c 64                	cmp    $0x64,%al
     509:	75 7b                	jne    586 <main+0x16f>
     50b:	a0 22 25 00 00       	mov    0x2522,%al
     510:	3c 20                	cmp    $0x20,%al
     512:	75 72                	jne    586 <main+0x16f>

      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     514:	c7 04 24 20 25 00 00 	movl   $0x2520,(%esp)
     51b:	e8 11 0c 00 00       	call   1131 <strlen>
     520:	48                   	dec    %eax
     521:	c6 80 20 25 00 00 00 	movb   $0x0,0x2520(%eax)
      if(ifsafepath(buf+3)){
     528:	c7 04 24 23 25 00 00 	movl   $0x2523,(%esp)
     52f:	e8 22 fb ff ff       	call   56 <ifsafepath>
     534:	85 c0                	test   %eax,%eax
     536:	74 4c                	je     584 <main+0x16d>
        setpath(index, buf+3, 1);
     538:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     53f:	00 
     540:	c7 44 24 04 23 25 00 	movl   $0x2523,0x4(%esp)
     547:	00 
     548:	8b 44 24 38          	mov    0x38(%esp),%eax
     54c:	89 04 24             	mov    %eax,(%esp)
     54f:	e8 04 13 00 00       	call   1858 <setpath>
        if(chdir(buf+3) < 0)
     554:	c7 04 24 23 25 00 00 	movl   $0x2523,(%esp)
     55b:	e8 18 12 00 00       	call   1778 <chdir>
     560:	85 c0                	test   %eax,%eax
     562:	79 1e                	jns    582 <main+0x16b>
          printf(2, "cannot cd %s\n", buf+3);
     564:	c7 44 24 08 23 25 00 	movl   $0x2523,0x8(%esp)
     56b:	00 
     56c:	c7 44 24 04 b6 1d 00 	movl   $0x1db6,0x4(%esp)
     573:	00 
     574:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     57b:	e8 bd 13 00 00       	call   193d <printf>
          continue;
     580:	eb 26                	jmp    5a8 <main+0x191>
     582:	eb 24                	jmp    5a8 <main+0x191>
      }
      continue;
     584:	eb 22                	jmp    5a8 <main+0x191>
    }
    if(fork1() == 0)
     586:	e8 64 00 00 00       	call   5ef <fork1>
     58b:	85 c0                	test   %eax,%eax
     58d:	75 14                	jne    5a3 <main+0x18c>
      runcmd(parsecmd(buf));
     58f:	c7 04 24 20 25 00 00 	movl   $0x2520,(%esp)
     596:	e8 b8 03 00 00       	call   953 <parsecmd>
     59b:	89 04 24             	mov    %eax,(%esp)
     59e:	e8 c5 fb ff ff       	call   168 <runcmd>
    wait();
     5a3:	e8 68 11 00 00       	call   1710 <wait>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     5a8:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     5af:	00 
     5b0:	c7 04 24 20 25 00 00 	movl   $0x2520,(%esp)
     5b7:	e8 fe fd ff ff       	call   3ba <getcmd>
     5bc:	85 c0                	test   %eax,%eax
     5be:	0f 89 97 fe ff ff    	jns    45b <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     5c4:	e8 3f 11 00 00       	call   1708 <exit>

000005c9 <panic>:
}

void
panic(char *s)
{
     5c9:	55                   	push   %ebp
     5ca:	89 e5                	mov    %esp,%ebp
     5cc:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     5cf:	8b 45 08             	mov    0x8(%ebp),%eax
     5d2:	89 44 24 08          	mov    %eax,0x8(%esp)
     5d6:	c7 44 24 04 c4 1d 00 	movl   $0x1dc4,0x4(%esp)
     5dd:	00 
     5de:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5e5:	e8 53 13 00 00       	call   193d <printf>
  exit();
     5ea:	e8 19 11 00 00       	call   1708 <exit>

000005ef <fork1>:
}

int
fork1(void)
{
     5ef:	55                   	push   %ebp
     5f0:	89 e5                	mov    %esp,%ebp
     5f2:	83 ec 28             	sub    $0x28,%esp
  int pid;

  pid = fork();
     5f5:	e8 06 11 00 00       	call   1700 <fork>
     5fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     5fd:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     601:	75 0c                	jne    60f <fork1+0x20>
    panic("fork");
     603:	c7 04 24 c8 1d 00 00 	movl   $0x1dc8,(%esp)
     60a:	e8 ba ff ff ff       	call   5c9 <panic>
  return pid;
     60f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     612:	c9                   	leave  
     613:	c3                   	ret    

00000614 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     614:	55                   	push   %ebp
     615:	89 e5                	mov    %esp,%ebp
     617:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     61a:	c7 04 24 a4 00 00 00 	movl   $0xa4,(%esp)
     621:	e8 ff 15 00 00       	call   1c25 <malloc>
     626:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     629:	c7 44 24 08 a4 00 00 	movl   $0xa4,0x8(%esp)
     630:	00 
     631:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     638:	00 
     639:	8b 45 f4             	mov    -0xc(%ebp),%eax
     63c:	89 04 24             	mov    %eax,(%esp)
     63f:	e8 12 0b 00 00       	call   1156 <memset>
  cmd->type = EXEC;
     644:	8b 45 f4             	mov    -0xc(%ebp),%eax
     647:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     64d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     650:	c9                   	leave  
     651:	c3                   	ret    

00000652 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     652:	55                   	push   %ebp
     653:	89 e5                	mov    %esp,%ebp
     655:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     658:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     65f:	e8 c1 15 00 00       	call   1c25 <malloc>
     664:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     667:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     66e:	00 
     66f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     676:	00 
     677:	8b 45 f4             	mov    -0xc(%ebp),%eax
     67a:	89 04 24             	mov    %eax,(%esp)
     67d:	e8 d4 0a 00 00       	call   1156 <memset>
  cmd->type = REDIR;
     682:	8b 45 f4             	mov    -0xc(%ebp),%eax
     685:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     68b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     68e:	8b 55 08             	mov    0x8(%ebp),%edx
     691:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     694:	8b 45 f4             	mov    -0xc(%ebp),%eax
     697:	8b 55 0c             	mov    0xc(%ebp),%edx
     69a:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     69d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a0:	8b 55 10             	mov    0x10(%ebp),%edx
     6a3:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     6a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6a9:	8b 55 14             	mov    0x14(%ebp),%edx
     6ac:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     6af:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6b2:	8b 55 18             	mov    0x18(%ebp),%edx
     6b5:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     6b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6bb:	c9                   	leave  
     6bc:	c3                   	ret    

000006bd <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     6bd:	55                   	push   %ebp
     6be:	89 e5                	mov    %esp,%ebp
     6c0:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6c3:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     6ca:	e8 56 15 00 00       	call   1c25 <malloc>
     6cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     6d2:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     6d9:	00 
     6da:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     6e1:	00 
     6e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e5:	89 04 24             	mov    %eax,(%esp)
     6e8:	e8 69 0a 00 00       	call   1156 <memset>
  cmd->type = PIPE;
     6ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f0:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     6f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6f9:	8b 55 08             	mov    0x8(%ebp),%edx
     6fc:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     6ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     702:	8b 55 0c             	mov    0xc(%ebp),%edx
     705:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     708:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     70b:	c9                   	leave  
     70c:	c3                   	ret    

0000070d <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     70d:	55                   	push   %ebp
     70e:	89 e5                	mov    %esp,%ebp
     710:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     713:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     71a:	e8 06 15 00 00       	call   1c25 <malloc>
     71f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     722:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     729:	00 
     72a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     731:	00 
     732:	8b 45 f4             	mov    -0xc(%ebp),%eax
     735:	89 04 24             	mov    %eax,(%esp)
     738:	e8 19 0a 00 00       	call   1156 <memset>
  cmd->type = LIST;
     73d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     740:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     746:	8b 45 f4             	mov    -0xc(%ebp),%eax
     749:	8b 55 08             	mov    0x8(%ebp),%edx
     74c:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     74f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     752:	8b 55 0c             	mov    0xc(%ebp),%edx
     755:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     758:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     75b:	c9                   	leave  
     75c:	c3                   	ret    

0000075d <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     75d:	55                   	push   %ebp
     75e:	89 e5                	mov    %esp,%ebp
     760:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     763:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     76a:	e8 b6 14 00 00       	call   1c25 <malloc>
     76f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     772:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     779:	00 
     77a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     781:	00 
     782:	8b 45 f4             	mov    -0xc(%ebp),%eax
     785:	89 04 24             	mov    %eax,(%esp)
     788:	e8 c9 09 00 00       	call   1156 <memset>
  cmd->type = BACK;
     78d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     790:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     796:	8b 45 f4             	mov    -0xc(%ebp),%eax
     799:	8b 55 08             	mov    0x8(%ebp),%edx
     79c:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     79f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     7a2:	c9                   	leave  
     7a3:	c3                   	ret    

000007a4 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     7a4:	55                   	push   %ebp
     7a5:	89 e5                	mov    %esp,%ebp
     7a7:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;

  s = *ps;
     7aa:	8b 45 08             	mov    0x8(%ebp),%eax
     7ad:	8b 00                	mov    (%eax),%eax
     7af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     7b2:	eb 03                	jmp    7b7 <gettoken+0x13>
    s++;
     7b4:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     7b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ba:	3b 45 0c             	cmp    0xc(%ebp),%eax
     7bd:	73 1c                	jae    7db <gettoken+0x37>
     7bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c2:	8a 00                	mov    (%eax),%al
     7c4:	0f be c0             	movsbl %al,%eax
     7c7:	89 44 24 04          	mov    %eax,0x4(%esp)
     7cb:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     7d2:	e8 a3 09 00 00       	call   117a <strchr>
     7d7:	85 c0                	test   %eax,%eax
     7d9:	75 d9                	jne    7b4 <gettoken+0x10>
    s++;
  if(q)
     7db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     7df:	74 08                	je     7e9 <gettoken+0x45>
    *q = s;
     7e1:	8b 45 10             	mov    0x10(%ebp),%eax
     7e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7e7:	89 10                	mov    %edx,(%eax)
  ret = *s;
     7e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7ec:	8a 00                	mov    (%eax),%al
     7ee:	0f be c0             	movsbl %al,%eax
     7f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     7f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f7:	8a 00                	mov    (%eax),%al
     7f9:	0f be c0             	movsbl %al,%eax
     7fc:	83 f8 29             	cmp    $0x29,%eax
     7ff:	7f 14                	jg     815 <gettoken+0x71>
     801:	83 f8 28             	cmp    $0x28,%eax
     804:	7d 28                	jge    82e <gettoken+0x8a>
     806:	85 c0                	test   %eax,%eax
     808:	0f 84 8d 00 00 00    	je     89b <gettoken+0xf7>
     80e:	83 f8 26             	cmp    $0x26,%eax
     811:	74 1b                	je     82e <gettoken+0x8a>
     813:	eb 38                	jmp    84d <gettoken+0xa9>
     815:	83 f8 3e             	cmp    $0x3e,%eax
     818:	74 19                	je     833 <gettoken+0x8f>
     81a:	83 f8 3e             	cmp    $0x3e,%eax
     81d:	7f 0a                	jg     829 <gettoken+0x85>
     81f:	83 e8 3b             	sub    $0x3b,%eax
     822:	83 f8 01             	cmp    $0x1,%eax
     825:	77 26                	ja     84d <gettoken+0xa9>
     827:	eb 05                	jmp    82e <gettoken+0x8a>
     829:	83 f8 7c             	cmp    $0x7c,%eax
     82c:	75 1f                	jne    84d <gettoken+0xa9>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     82e:	ff 45 f4             	incl   -0xc(%ebp)
    break;
     831:	eb 69                	jmp    89c <gettoken+0xf8>
  case '>':
    s++;
     833:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
     836:	8b 45 f4             	mov    -0xc(%ebp),%eax
     839:	8a 00                	mov    (%eax),%al
     83b:	3c 3e                	cmp    $0x3e,%al
     83d:	75 0c                	jne    84b <gettoken+0xa7>
      ret = '+';
     83f:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     846:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
     849:	eb 51                	jmp    89c <gettoken+0xf8>
     84b:	eb 4f                	jmp    89c <gettoken+0xf8>
  default:
    ret = 'a';
     84d:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     854:	eb 03                	jmp    859 <gettoken+0xb5>
      s++;
     856:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     859:	8b 45 f4             	mov    -0xc(%ebp),%eax
     85c:	3b 45 0c             	cmp    0xc(%ebp),%eax
     85f:	73 38                	jae    899 <gettoken+0xf5>
     861:	8b 45 f4             	mov    -0xc(%ebp),%eax
     864:	8a 00                	mov    (%eax),%al
     866:	0f be c0             	movsbl %al,%eax
     869:	89 44 24 04          	mov    %eax,0x4(%esp)
     86d:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     874:	e8 01 09 00 00       	call   117a <strchr>
     879:	85 c0                	test   %eax,%eax
     87b:	75 1c                	jne    899 <gettoken+0xf5>
     87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     880:	8a 00                	mov    (%eax),%al
     882:	0f be c0             	movsbl %al,%eax
     885:	89 44 24 04          	mov    %eax,0x4(%esp)
     889:	c7 04 24 a6 24 00 00 	movl   $0x24a6,(%esp)
     890:	e8 e5 08 00 00       	call   117a <strchr>
     895:	85 c0                	test   %eax,%eax
     897:	74 bd                	je     856 <gettoken+0xb2>
      s++;
    break;
     899:	eb 01                	jmp    89c <gettoken+0xf8>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     89b:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     89c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     8a0:	74 0a                	je     8ac <gettoken+0x108>
    *eq = s;
     8a2:	8b 45 14             	mov    0x14(%ebp),%eax
     8a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8a8:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     8aa:	eb 05                	jmp    8b1 <gettoken+0x10d>
     8ac:	eb 03                	jmp    8b1 <gettoken+0x10d>
    s++;
     8ae:	ff 45 f4             	incl   -0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b4:	3b 45 0c             	cmp    0xc(%ebp),%eax
     8b7:	73 1c                	jae    8d5 <gettoken+0x131>
     8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8bc:	8a 00                	mov    (%eax),%al
     8be:	0f be c0             	movsbl %al,%eax
     8c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c5:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     8cc:	e8 a9 08 00 00       	call   117a <strchr>
     8d1:	85 c0                	test   %eax,%eax
     8d3:	75 d9                	jne    8ae <gettoken+0x10a>
    s++;
  *ps = s;
     8d5:	8b 45 08             	mov    0x8(%ebp),%eax
     8d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8db:	89 10                	mov    %edx,(%eax)
  return ret;
     8dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     8e0:	c9                   	leave  
     8e1:	c3                   	ret    

000008e2 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     8e2:	55                   	push   %ebp
     8e3:	89 e5                	mov    %esp,%ebp
     8e5:	83 ec 28             	sub    $0x28,%esp
  char *s;

  s = *ps;
     8e8:	8b 45 08             	mov    0x8(%ebp),%eax
     8eb:	8b 00                	mov    (%eax),%eax
     8ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     8f0:	eb 03                	jmp    8f5 <peek+0x13>
    s++;
     8f2:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f8:	3b 45 0c             	cmp    0xc(%ebp),%eax
     8fb:	73 1c                	jae    919 <peek+0x37>
     8fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     900:	8a 00                	mov    (%eax),%al
     902:	0f be c0             	movsbl %al,%eax
     905:	89 44 24 04          	mov    %eax,0x4(%esp)
     909:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     910:	e8 65 08 00 00       	call   117a <strchr>
     915:	85 c0                	test   %eax,%eax
     917:	75 d9                	jne    8f2 <peek+0x10>
    s++;
  *ps = s;
     919:	8b 45 08             	mov    0x8(%ebp),%eax
     91c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     91f:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     921:	8b 45 f4             	mov    -0xc(%ebp),%eax
     924:	8a 00                	mov    (%eax),%al
     926:	84 c0                	test   %al,%al
     928:	74 22                	je     94c <peek+0x6a>
     92a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     92d:	8a 00                	mov    (%eax),%al
     92f:	0f be c0             	movsbl %al,%eax
     932:	89 44 24 04          	mov    %eax,0x4(%esp)
     936:	8b 45 10             	mov    0x10(%ebp),%eax
     939:	89 04 24             	mov    %eax,(%esp)
     93c:	e8 39 08 00 00       	call   117a <strchr>
     941:	85 c0                	test   %eax,%eax
     943:	74 07                	je     94c <peek+0x6a>
     945:	b8 01 00 00 00       	mov    $0x1,%eax
     94a:	eb 05                	jmp    951 <peek+0x6f>
     94c:	b8 00 00 00 00       	mov    $0x0,%eax
}
     951:	c9                   	leave  
     952:	c3                   	ret    

00000953 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     953:	55                   	push   %ebp
     954:	89 e5                	mov    %esp,%ebp
     956:	53                   	push   %ebx
     957:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     95a:	8b 5d 08             	mov    0x8(%ebp),%ebx
     95d:	8b 45 08             	mov    0x8(%ebp),%eax
     960:	89 04 24             	mov    %eax,(%esp)
     963:	e8 c9 07 00 00       	call   1131 <strlen>
     968:	01 d8                	add    %ebx,%eax
     96a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     96d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     970:	89 44 24 04          	mov    %eax,0x4(%esp)
     974:	8d 45 08             	lea    0x8(%ebp),%eax
     977:	89 04 24             	mov    %eax,(%esp)
     97a:	e8 60 00 00 00       	call   9df <parseline>
     97f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     982:	c7 44 24 08 cd 1d 00 	movl   $0x1dcd,0x8(%esp)
     989:	00 
     98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     98d:	89 44 24 04          	mov    %eax,0x4(%esp)
     991:	8d 45 08             	lea    0x8(%ebp),%eax
     994:	89 04 24             	mov    %eax,(%esp)
     997:	e8 46 ff ff ff       	call   8e2 <peek>
  if(s != es){
     99c:	8b 45 08             	mov    0x8(%ebp),%eax
     99f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     9a2:	74 27                	je     9cb <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     9a4:	8b 45 08             	mov    0x8(%ebp),%eax
     9a7:	89 44 24 08          	mov    %eax,0x8(%esp)
     9ab:	c7 44 24 04 ce 1d 00 	movl   $0x1dce,0x4(%esp)
     9b2:	00 
     9b3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9ba:	e8 7e 0f 00 00       	call   193d <printf>
    panic("syntax");
     9bf:	c7 04 24 dd 1d 00 00 	movl   $0x1ddd,(%esp)
     9c6:	e8 fe fb ff ff       	call   5c9 <panic>
  }
  nulterminate(cmd);
     9cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
     9ce:	89 04 24             	mov    %eax,(%esp)
     9d1:	e8 a2 04 00 00       	call   e78 <nulterminate>
  return cmd;
     9d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     9d9:	83 c4 24             	add    $0x24,%esp
     9dc:	5b                   	pop    %ebx
     9dd:	5d                   	pop    %ebp
     9de:	c3                   	ret    

000009df <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     9df:	55                   	push   %ebp
     9e0:	89 e5                	mov    %esp,%ebp
     9e2:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     9e5:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e8:	89 44 24 04          	mov    %eax,0x4(%esp)
     9ec:	8b 45 08             	mov    0x8(%ebp),%eax
     9ef:	89 04 24             	mov    %eax,(%esp)
     9f2:	e8 bc 00 00 00       	call   ab3 <parsepipe>
     9f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     9fa:	eb 30                	jmp    a2c <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     9fc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a03:	00 
     a04:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a0b:	00 
     a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a13:	8b 45 08             	mov    0x8(%ebp),%eax
     a16:	89 04 24             	mov    %eax,(%esp)
     a19:	e8 86 fd ff ff       	call   7a4 <gettoken>
    cmd = backcmd(cmd);
     a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a21:	89 04 24             	mov    %eax,(%esp)
     a24:	e8 34 fd ff ff       	call   75d <backcmd>
     a29:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     a2c:	c7 44 24 08 e4 1d 00 	movl   $0x1de4,0x8(%esp)
     a33:	00 
     a34:	8b 45 0c             	mov    0xc(%ebp),%eax
     a37:	89 44 24 04          	mov    %eax,0x4(%esp)
     a3b:	8b 45 08             	mov    0x8(%ebp),%eax
     a3e:	89 04 24             	mov    %eax,(%esp)
     a41:	e8 9c fe ff ff       	call   8e2 <peek>
     a46:	85 c0                	test   %eax,%eax
     a48:	75 b2                	jne    9fc <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     a4a:	c7 44 24 08 e6 1d 00 	movl   $0x1de6,0x8(%esp)
     a51:	00 
     a52:	8b 45 0c             	mov    0xc(%ebp),%eax
     a55:	89 44 24 04          	mov    %eax,0x4(%esp)
     a59:	8b 45 08             	mov    0x8(%ebp),%eax
     a5c:	89 04 24             	mov    %eax,(%esp)
     a5f:	e8 7e fe ff ff       	call   8e2 <peek>
     a64:	85 c0                	test   %eax,%eax
     a66:	74 46                	je     aae <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     a68:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a6f:	00 
     a70:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a77:	00 
     a78:	8b 45 0c             	mov    0xc(%ebp),%eax
     a7b:	89 44 24 04          	mov    %eax,0x4(%esp)
     a7f:	8b 45 08             	mov    0x8(%ebp),%eax
     a82:	89 04 24             	mov    %eax,(%esp)
     a85:	e8 1a fd ff ff       	call   7a4 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
     a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
     a91:	8b 45 08             	mov    0x8(%ebp),%eax
     a94:	89 04 24             	mov    %eax,(%esp)
     a97:	e8 43 ff ff ff       	call   9df <parseline>
     a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     aa3:	89 04 24             	mov    %eax,(%esp)
     aa6:	e8 62 fc ff ff       	call   70d <listcmd>
     aab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ab1:	c9                   	leave  
     ab2:	c3                   	ret    

00000ab3 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     ab3:	55                   	push   %ebp
     ab4:	89 e5                	mov    %esp,%ebp
     ab6:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
     abc:	89 44 24 04          	mov    %eax,0x4(%esp)
     ac0:	8b 45 08             	mov    0x8(%ebp),%eax
     ac3:	89 04 24             	mov    %eax,(%esp)
     ac6:	e8 68 02 00 00       	call   d33 <parseexec>
     acb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     ace:	c7 44 24 08 e8 1d 00 	movl   $0x1de8,0x8(%esp)
     ad5:	00 
     ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ad9:	89 44 24 04          	mov    %eax,0x4(%esp)
     add:	8b 45 08             	mov    0x8(%ebp),%eax
     ae0:	89 04 24             	mov    %eax,(%esp)
     ae3:	e8 fa fd ff ff       	call   8e2 <peek>
     ae8:	85 c0                	test   %eax,%eax
     aea:	74 46                	je     b32 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     aec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     af3:	00 
     af4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     afb:	00 
     afc:	8b 45 0c             	mov    0xc(%ebp),%eax
     aff:	89 44 24 04          	mov    %eax,0x4(%esp)
     b03:	8b 45 08             	mov    0x8(%ebp),%eax
     b06:	89 04 24             	mov    %eax,(%esp)
     b09:	e8 96 fc ff ff       	call   7a4 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
     b11:	89 44 24 04          	mov    %eax,0x4(%esp)
     b15:	8b 45 08             	mov    0x8(%ebp),%eax
     b18:	89 04 24             	mov    %eax,(%esp)
     b1b:	e8 93 ff ff ff       	call   ab3 <parsepipe>
     b20:	89 44 24 04          	mov    %eax,0x4(%esp)
     b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b27:	89 04 24             	mov    %eax,(%esp)
     b2a:	e8 8e fb ff ff       	call   6bd <pipecmd>
     b2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     b35:	c9                   	leave  
     b36:	c3                   	ret    

00000b37 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     b37:	55                   	push   %ebp
     b38:	89 e5                	mov    %esp,%ebp
     b3a:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     b3d:	e9 f6 00 00 00       	jmp    c38 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     b42:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b49:	00 
     b4a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     b51:	00 
     b52:	8b 45 10             	mov    0x10(%ebp),%eax
     b55:	89 44 24 04          	mov    %eax,0x4(%esp)
     b59:	8b 45 0c             	mov    0xc(%ebp),%eax
     b5c:	89 04 24             	mov    %eax,(%esp)
     b5f:	e8 40 fc ff ff       	call   7a4 <gettoken>
     b64:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     b67:	8d 45 ec             	lea    -0x14(%ebp),%eax
     b6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b6e:	8d 45 f0             	lea    -0x10(%ebp),%eax
     b71:	89 44 24 08          	mov    %eax,0x8(%esp)
     b75:	8b 45 10             	mov    0x10(%ebp),%eax
     b78:	89 44 24 04          	mov    %eax,0x4(%esp)
     b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
     b7f:	89 04 24             	mov    %eax,(%esp)
     b82:	e8 1d fc ff ff       	call   7a4 <gettoken>
     b87:	83 f8 61             	cmp    $0x61,%eax
     b8a:	74 0c                	je     b98 <parseredirs+0x61>
      panic("missing file for redirection");
     b8c:	c7 04 24 ea 1d 00 00 	movl   $0x1dea,(%esp)
     b93:	e8 31 fa ff ff       	call   5c9 <panic>
    switch(tok){
     b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b9b:	83 f8 3c             	cmp    $0x3c,%eax
     b9e:	74 0f                	je     baf <parseredirs+0x78>
     ba0:	83 f8 3e             	cmp    $0x3e,%eax
     ba3:	74 38                	je     bdd <parseredirs+0xa6>
     ba5:	83 f8 2b             	cmp    $0x2b,%eax
     ba8:	74 61                	je     c0b <parseredirs+0xd4>
     baa:	e9 89 00 00 00       	jmp    c38 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     baf:	8b 55 ec             	mov    -0x14(%ebp),%edx
     bb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
     bb5:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     bbc:	00 
     bbd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     bc4:	00 
     bc5:	89 54 24 08          	mov    %edx,0x8(%esp)
     bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
     bcd:	8b 45 08             	mov    0x8(%ebp),%eax
     bd0:	89 04 24             	mov    %eax,(%esp)
     bd3:	e8 7a fa ff ff       	call   652 <redircmd>
     bd8:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     bdb:	eb 5b                	jmp    c38 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     bdd:	8b 55 ec             	mov    -0x14(%ebp),%edx
     be0:	8b 45 f0             	mov    -0x10(%ebp),%eax
     be3:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     bea:	00 
     beb:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     bf2:	00 
     bf3:	89 54 24 08          	mov    %edx,0x8(%esp)
     bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
     bfb:	8b 45 08             	mov    0x8(%ebp),%eax
     bfe:	89 04 24             	mov    %eax,(%esp)
     c01:	e8 4c fa ff ff       	call   652 <redircmd>
     c06:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c09:	eb 2d                	jmp    c38 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     c0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
     c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
     c11:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     c18:	00 
     c19:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     c20:	00 
     c21:	89 54 24 08          	mov    %edx,0x8(%esp)
     c25:	89 44 24 04          	mov    %eax,0x4(%esp)
     c29:	8b 45 08             	mov    0x8(%ebp),%eax
     c2c:	89 04 24             	mov    %eax,(%esp)
     c2f:	e8 1e fa ff ff       	call   652 <redircmd>
     c34:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     c37:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     c38:	c7 44 24 08 07 1e 00 	movl   $0x1e07,0x8(%esp)
     c3f:	00 
     c40:	8b 45 10             	mov    0x10(%ebp),%eax
     c43:	89 44 24 04          	mov    %eax,0x4(%esp)
     c47:	8b 45 0c             	mov    0xc(%ebp),%eax
     c4a:	89 04 24             	mov    %eax,(%esp)
     c4d:	e8 90 fc ff ff       	call   8e2 <peek>
     c52:	85 c0                	test   %eax,%eax
     c54:	0f 85 e8 fe ff ff    	jne    b42 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     c5a:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c5d:	c9                   	leave  
     c5e:	c3                   	ret    

00000c5f <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     c5f:	55                   	push   %ebp
     c60:	89 e5                	mov    %esp,%ebp
     c62:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     c65:	c7 44 24 08 0a 1e 00 	movl   $0x1e0a,0x8(%esp)
     c6c:	00 
     c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
     c70:	89 44 24 04          	mov    %eax,0x4(%esp)
     c74:	8b 45 08             	mov    0x8(%ebp),%eax
     c77:	89 04 24             	mov    %eax,(%esp)
     c7a:	e8 63 fc ff ff       	call   8e2 <peek>
     c7f:	85 c0                	test   %eax,%eax
     c81:	75 0c                	jne    c8f <parseblock+0x30>
    panic("parseblock");
     c83:	c7 04 24 0c 1e 00 00 	movl   $0x1e0c,(%esp)
     c8a:	e8 3a f9 ff ff       	call   5c9 <panic>
  gettoken(ps, es, 0, 0);
     c8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     c96:	00 
     c97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     c9e:	00 
     c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
     ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
     ca6:	8b 45 08             	mov    0x8(%ebp),%eax
     ca9:	89 04 24             	mov    %eax,(%esp)
     cac:	e8 f3 fa ff ff       	call   7a4 <gettoken>
  cmd = parseline(ps, es);
     cb1:	8b 45 0c             	mov    0xc(%ebp),%eax
     cb4:	89 44 24 04          	mov    %eax,0x4(%esp)
     cb8:	8b 45 08             	mov    0x8(%ebp),%eax
     cbb:	89 04 24             	mov    %eax,(%esp)
     cbe:	e8 1c fd ff ff       	call   9df <parseline>
     cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     cc6:	c7 44 24 08 17 1e 00 	movl   $0x1e17,0x8(%esp)
     ccd:	00 
     cce:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd1:	89 44 24 04          	mov    %eax,0x4(%esp)
     cd5:	8b 45 08             	mov    0x8(%ebp),%eax
     cd8:	89 04 24             	mov    %eax,(%esp)
     cdb:	e8 02 fc ff ff       	call   8e2 <peek>
     ce0:	85 c0                	test   %eax,%eax
     ce2:	75 0c                	jne    cf0 <parseblock+0x91>
    panic("syntax - missing )");
     ce4:	c7 04 24 19 1e 00 00 	movl   $0x1e19,(%esp)
     ceb:	e8 d9 f8 ff ff       	call   5c9 <panic>
  gettoken(ps, es, 0, 0);
     cf0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     cf7:	00 
     cf8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     cff:	00 
     d00:	8b 45 0c             	mov    0xc(%ebp),%eax
     d03:	89 44 24 04          	mov    %eax,0x4(%esp)
     d07:	8b 45 08             	mov    0x8(%ebp),%eax
     d0a:	89 04 24             	mov    %eax,(%esp)
     d0d:	e8 92 fa ff ff       	call   7a4 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     d12:	8b 45 0c             	mov    0xc(%ebp),%eax
     d15:	89 44 24 08          	mov    %eax,0x8(%esp)
     d19:	8b 45 08             	mov    0x8(%ebp),%eax
     d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
     d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
     d23:	89 04 24             	mov    %eax,(%esp)
     d26:	e8 0c fe ff ff       	call   b37 <parseredirs>
     d2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     d31:	c9                   	leave  
     d32:	c3                   	ret    

00000d33 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     d33:	55                   	push   %ebp
     d34:	89 e5                	mov    %esp,%ebp
     d36:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     d39:	c7 44 24 08 0a 1e 00 	movl   $0x1e0a,0x8(%esp)
     d40:	00 
     d41:	8b 45 0c             	mov    0xc(%ebp),%eax
     d44:	89 44 24 04          	mov    %eax,0x4(%esp)
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	89 04 24             	mov    %eax,(%esp)
     d4e:	e8 8f fb ff ff       	call   8e2 <peek>
     d53:	85 c0                	test   %eax,%eax
     d55:	74 17                	je     d6e <parseexec+0x3b>
    return parseblock(ps, es);
     d57:	8b 45 0c             	mov    0xc(%ebp),%eax
     d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
     d5e:	8b 45 08             	mov    0x8(%ebp),%eax
     d61:	89 04 24             	mov    %eax,(%esp)
     d64:	e8 f6 fe ff ff       	call   c5f <parseblock>
     d69:	e9 08 01 00 00       	jmp    e76 <parseexec+0x143>

  ret = execcmd();
     d6e:	e8 a1 f8 ff ff       	call   614 <execcmd>
     d73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     d76:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d79:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     d7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     d83:	8b 45 0c             	mov    0xc(%ebp),%eax
     d86:	89 44 24 08          	mov    %eax,0x8(%esp)
     d8a:	8b 45 08             	mov    0x8(%ebp),%eax
     d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
     d91:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d94:	89 04 24             	mov    %eax,(%esp)
     d97:	e8 9b fd ff ff       	call   b37 <parseredirs>
     d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     d9f:	e9 8e 00 00 00       	jmp    e32 <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     da4:	8d 45 e0             	lea    -0x20(%ebp),%eax
     da7:	89 44 24 0c          	mov    %eax,0xc(%esp)
     dab:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     dae:	89 44 24 08          	mov    %eax,0x8(%esp)
     db2:	8b 45 0c             	mov    0xc(%ebp),%eax
     db5:	89 44 24 04          	mov    %eax,0x4(%esp)
     db9:	8b 45 08             	mov    0x8(%ebp),%eax
     dbc:	89 04 24             	mov    %eax,(%esp)
     dbf:	e8 e0 f9 ff ff       	call   7a4 <gettoken>
     dc4:	89 45 e8             	mov    %eax,-0x18(%ebp)
     dc7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     dcb:	75 05                	jne    dd2 <parseexec+0x9f>
      break;
     dcd:	e9 82 00 00 00       	jmp    e54 <parseexec+0x121>
    if(tok != 'a')
     dd2:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     dd6:	74 0c                	je     de4 <parseexec+0xb1>
      panic("syntax");
     dd8:	c7 04 24 dd 1d 00 00 	movl   $0x1ddd,(%esp)
     ddf:	e8 e5 f7 ff ff       	call   5c9 <panic>
    cmd->argv[argc] = q;
     de4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
     dea:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ded:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     df1:	8b 55 e0             	mov    -0x20(%ebp),%edx
     df4:	8b 45 ec             	mov    -0x14(%ebp),%eax
     df7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     dfa:	83 c1 14             	add    $0x14,%ecx
     dfd:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    argc++;
     e01:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     e04:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     e08:	7e 0c                	jle    e16 <parseexec+0xe3>
      panic("too many args");
     e0a:	c7 04 24 2c 1e 00 00 	movl   $0x1e2c,(%esp)
     e11:	e8 b3 f7 ff ff       	call   5c9 <panic>
    ret = parseredirs(ret, ps, es);
     e16:	8b 45 0c             	mov    0xc(%ebp),%eax
     e19:	89 44 24 08          	mov    %eax,0x8(%esp)
     e1d:	8b 45 08             	mov    0x8(%ebp),%eax
     e20:	89 44 24 04          	mov    %eax,0x4(%esp)
     e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e27:	89 04 24             	mov    %eax,(%esp)
     e2a:	e8 08 fd ff ff       	call   b37 <parseredirs>
     e2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     e32:	c7 44 24 08 3a 1e 00 	movl   $0x1e3a,0x8(%esp)
     e39:	00 
     e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
     e41:	8b 45 08             	mov    0x8(%ebp),%eax
     e44:	89 04 24             	mov    %eax,(%esp)
     e47:	e8 96 fa ff ff       	call   8e2 <peek>
     e4c:	85 c0                	test   %eax,%eax
     e4e:	0f 84 50 ff ff ff    	je     da4 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     e54:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e57:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e5a:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     e61:	00 
  cmd->eargv[argc] = 0;
     e62:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e65:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e68:	83 c2 14             	add    $0x14,%edx
     e6b:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     e72:	00 
  return ret;
     e73:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e76:	c9                   	leave  
     e77:	c3                   	ret    

00000e78 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e78:	55                   	push   %ebp
     e79:	89 e5                	mov    %esp,%ebp
     e7b:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e7e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e82:	75 0a                	jne    e8e <nulterminate+0x16>
    return 0;
     e84:	b8 00 00 00 00       	mov    $0x0,%eax
     e89:	e9 c8 00 00 00       	jmp    f56 <nulterminate+0xde>

  switch(cmd->type){
     e8e:	8b 45 08             	mov    0x8(%ebp),%eax
     e91:	8b 00                	mov    (%eax),%eax
     e93:	83 f8 05             	cmp    $0x5,%eax
     e96:	0f 87 b7 00 00 00    	ja     f53 <nulterminate+0xdb>
     e9c:	8b 04 85 40 1e 00 00 	mov    0x1e40(,%eax,4),%eax
     ea3:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     ea5:	8b 45 08             	mov    0x8(%ebp),%eax
     ea8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     eab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     eb2:	eb 13                	jmp    ec7 <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
     eb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eb7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     eba:	83 c2 14             	add    $0x14,%edx
     ebd:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     ec1:	c6 00 00             	movb   $0x0,(%eax)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     ec4:	ff 45 f4             	incl   -0xc(%ebp)
     ec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
     eca:	8b 55 f4             	mov    -0xc(%ebp),%edx
     ecd:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     ed1:	85 c0                	test   %eax,%eax
     ed3:	75 df                	jne    eb4 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     ed5:	eb 7c                	jmp    f53 <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     ed7:	8b 45 08             	mov    0x8(%ebp),%eax
     eda:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     edd:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ee0:	8b 40 04             	mov    0x4(%eax),%eax
     ee3:	89 04 24             	mov    %eax,(%esp)
     ee6:	e8 8d ff ff ff       	call   e78 <nulterminate>
    *rcmd->efile = 0;
     eeb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     eee:	8b 40 0c             	mov    0xc(%eax),%eax
     ef1:	c6 00 00             	movb   $0x0,(%eax)
    break;
     ef4:	eb 5d                	jmp    f53 <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     ef6:	8b 45 08             	mov    0x8(%ebp),%eax
     ef9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     efc:	8b 45 e8             	mov    -0x18(%ebp),%eax
     eff:	8b 40 04             	mov    0x4(%eax),%eax
     f02:	89 04 24             	mov    %eax,(%esp)
     f05:	e8 6e ff ff ff       	call   e78 <nulterminate>
    nulterminate(pcmd->right);
     f0a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f0d:	8b 40 08             	mov    0x8(%eax),%eax
     f10:	89 04 24             	mov    %eax,(%esp)
     f13:	e8 60 ff ff ff       	call   e78 <nulterminate>
    break;
     f18:	eb 39                	jmp    f53 <nulterminate+0xdb>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     f1a:	8b 45 08             	mov    0x8(%ebp),%eax
     f1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     f20:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f23:	8b 40 04             	mov    0x4(%eax),%eax
     f26:	89 04 24             	mov    %eax,(%esp)
     f29:	e8 4a ff ff ff       	call   e78 <nulterminate>
    nulterminate(lcmd->right);
     f2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f31:	8b 40 08             	mov    0x8(%eax),%eax
     f34:	89 04 24             	mov    %eax,(%esp)
     f37:	e8 3c ff ff ff       	call   e78 <nulterminate>
    break;
     f3c:	eb 15                	jmp    f53 <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     f3e:	8b 45 08             	mov    0x8(%ebp),%eax
     f41:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     f44:	8b 45 e0             	mov    -0x20(%ebp),%eax
     f47:	8b 40 04             	mov    0x4(%eax),%eax
     f4a:	89 04 24             	mov    %eax,(%esp)
     f4d:	e8 26 ff ff ff       	call   e78 <nulterminate>
    break;
     f52:	90                   	nop
  }
  return cmd;
     f53:	8b 45 08             	mov    0x8(%ebp),%eax
}
     f56:	c9                   	leave  
     f57:	c3                   	ret    

00000f58 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     f58:	55                   	push   %ebp
     f59:	89 e5                	mov    %esp,%ebp
     f5b:	57                   	push   %edi
     f5c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     f5d:	8b 4d 08             	mov    0x8(%ebp),%ecx
     f60:	8b 55 10             	mov    0x10(%ebp),%edx
     f63:	8b 45 0c             	mov    0xc(%ebp),%eax
     f66:	89 cb                	mov    %ecx,%ebx
     f68:	89 df                	mov    %ebx,%edi
     f6a:	89 d1                	mov    %edx,%ecx
     f6c:	fc                   	cld    
     f6d:	f3 aa                	rep stos %al,%es:(%edi)
     f6f:	89 ca                	mov    %ecx,%edx
     f71:	89 fb                	mov    %edi,%ebx
     f73:	89 5d 08             	mov    %ebx,0x8(%ebp)
     f76:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     f79:	5b                   	pop    %ebx
     f7a:	5f                   	pop    %edi
     f7b:	5d                   	pop    %ebp
     f7c:	c3                   	ret    

00000f7d <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     f7d:	55                   	push   %ebp
     f7e:	89 e5                	mov    %esp,%ebp
     f80:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     f83:	8b 45 08             	mov    0x8(%ebp),%eax
     f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     f89:	90                   	nop
     f8a:	8b 45 08             	mov    0x8(%ebp),%eax
     f8d:	8d 50 01             	lea    0x1(%eax),%edx
     f90:	89 55 08             	mov    %edx,0x8(%ebp)
     f93:	8b 55 0c             	mov    0xc(%ebp),%edx
     f96:	8d 4a 01             	lea    0x1(%edx),%ecx
     f99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     f9c:	8a 12                	mov    (%edx),%dl
     f9e:	88 10                	mov    %dl,(%eax)
     fa0:	8a 00                	mov    (%eax),%al
     fa2:	84 c0                	test   %al,%al
     fa4:	75 e4                	jne    f8a <strcpy+0xd>
    ;
  return os;
     fa6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     fa9:	c9                   	leave  
     faa:	c3                   	ret    

00000fab <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     fab:	55                   	push   %ebp
     fac:	89 e5                	mov    %esp,%ebp
     fae:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     fb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     fb8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     fbf:	00 
     fc0:	8b 45 08             	mov    0x8(%ebp),%eax
     fc3:	89 04 24             	mov    %eax,(%esp)
     fc6:	e8 7d 07 00 00       	call   1748 <open>
     fcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
     fce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     fd2:	79 20                	jns    ff4 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     fd4:	8b 45 08             	mov    0x8(%ebp),%eax
     fd7:	89 44 24 08          	mov    %eax,0x8(%esp)
     fdb:	c7 44 24 04 58 1e 00 	movl   $0x1e58,0x4(%esp)
     fe2:	00 
     fe3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fea:	e8 4e 09 00 00       	call   193d <printf>
      exit();
     fef:	e8 14 07 00 00       	call   1708 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     ff4:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     ffb:	00 
     ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
     fff:	89 04 24             	mov    %eax,(%esp)
    1002:	e8 41 07 00 00       	call   1748 <open>
    1007:	89 45 ec             	mov    %eax,-0x14(%ebp)
    100a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    100e:	79 20                	jns    1030 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
    1010:	8b 45 0c             	mov    0xc(%ebp),%eax
    1013:	89 44 24 08          	mov    %eax,0x8(%esp)
    1017:	c7 44 24 04 73 1e 00 	movl   $0x1e73,0x4(%esp)
    101e:	00 
    101f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1026:	e8 12 09 00 00       	call   193d <printf>
      exit();
    102b:	e8 d8 06 00 00       	call   1708 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
    1030:	eb 3b                	jmp    106d <copy+0xc2>
  {
      max = used_disk+=count;
    1032:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1035:	01 45 10             	add    %eax,0x10(%ebp)
    1038:	8b 45 10             	mov    0x10(%ebp),%eax
    103b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
    103e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1041:	3b 45 14             	cmp    0x14(%ebp),%eax
    1044:	7e 07                	jle    104d <copy+0xa2>
      {
        return -1;
    1046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    104b:	eb 5c                	jmp    10a9 <copy+0xfe>
      }
      bytes = bytes + count;
    104d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1050:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
    1053:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    105a:	00 
    105b:	8d 45 c4             	lea    -0x3c(%ebp),%eax
    105e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1062:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1065:	89 04 24             	mov    %eax,(%esp)
    1068:	e8 bb 06 00 00       	call   1728 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
    106d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    1074:	00 
    1075:	8d 45 c4             	lea    -0x3c(%ebp),%eax
    1078:	89 44 24 04          	mov    %eax,0x4(%esp)
    107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    107f:	89 04 24             	mov    %eax,(%esp)
    1082:	e8 99 06 00 00       	call   1720 <read>
    1087:	89 45 e8             	mov    %eax,-0x18(%ebp)
    108a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    108e:	7f a2                	jg     1032 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
    1090:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1093:	89 04 24             	mov    %eax,(%esp)
    1096:	e8 95 06 00 00       	call   1730 <close>
  close(fd2);
    109b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    109e:	89 04 24             	mov    %eax,(%esp)
    10a1:	e8 8a 06 00 00       	call   1730 <close>
  return(bytes);
    10a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    10a9:	c9                   	leave  
    10aa:	c3                   	ret    

000010ab <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ab:	55                   	push   %ebp
    10ac:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    10ae:	eb 06                	jmp    10b6 <strcmp+0xb>
    p++, q++;
    10b0:	ff 45 08             	incl   0x8(%ebp)
    10b3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    10b6:	8b 45 08             	mov    0x8(%ebp),%eax
    10b9:	8a 00                	mov    (%eax),%al
    10bb:	84 c0                	test   %al,%al
    10bd:	74 0e                	je     10cd <strcmp+0x22>
    10bf:	8b 45 08             	mov    0x8(%ebp),%eax
    10c2:	8a 10                	mov    (%eax),%dl
    10c4:	8b 45 0c             	mov    0xc(%ebp),%eax
    10c7:	8a 00                	mov    (%eax),%al
    10c9:	38 c2                	cmp    %al,%dl
    10cb:	74 e3                	je     10b0 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    10cd:	8b 45 08             	mov    0x8(%ebp),%eax
    10d0:	8a 00                	mov    (%eax),%al
    10d2:	0f b6 d0             	movzbl %al,%edx
    10d5:	8b 45 0c             	mov    0xc(%ebp),%eax
    10d8:	8a 00                	mov    (%eax),%al
    10da:	0f b6 c0             	movzbl %al,%eax
    10dd:	29 c2                	sub    %eax,%edx
    10df:	89 d0                	mov    %edx,%eax
}
    10e1:	5d                   	pop    %ebp
    10e2:	c3                   	ret    

000010e3 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    10e3:	55                   	push   %ebp
    10e4:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
    10e6:	eb 09                	jmp    10f1 <strncmp+0xe>
    n--, p++, q++;
    10e8:	ff 4d 10             	decl   0x10(%ebp)
    10eb:	ff 45 08             	incl   0x8(%ebp)
    10ee:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    10f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    10f5:	74 17                	je     110e <strncmp+0x2b>
    10f7:	8b 45 08             	mov    0x8(%ebp),%eax
    10fa:	8a 00                	mov    (%eax),%al
    10fc:	84 c0                	test   %al,%al
    10fe:	74 0e                	je     110e <strncmp+0x2b>
    1100:	8b 45 08             	mov    0x8(%ebp),%eax
    1103:	8a 10                	mov    (%eax),%dl
    1105:	8b 45 0c             	mov    0xc(%ebp),%eax
    1108:	8a 00                	mov    (%eax),%al
    110a:	38 c2                	cmp    %al,%dl
    110c:	74 da                	je     10e8 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
    110e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1112:	75 07                	jne    111b <strncmp+0x38>
    return 0;
    1114:	b8 00 00 00 00       	mov    $0x0,%eax
    1119:	eb 14                	jmp    112f <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
    111b:	8b 45 08             	mov    0x8(%ebp),%eax
    111e:	8a 00                	mov    (%eax),%al
    1120:	0f b6 d0             	movzbl %al,%edx
    1123:	8b 45 0c             	mov    0xc(%ebp),%eax
    1126:	8a 00                	mov    (%eax),%al
    1128:	0f b6 c0             	movzbl %al,%eax
    112b:	29 c2                	sub    %eax,%edx
    112d:	89 d0                	mov    %edx,%eax
}
    112f:	5d                   	pop    %ebp
    1130:	c3                   	ret    

00001131 <strlen>:

uint
strlen(const char *s)
{
    1131:	55                   	push   %ebp
    1132:	89 e5                	mov    %esp,%ebp
    1134:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    1137:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    113e:	eb 03                	jmp    1143 <strlen+0x12>
    1140:	ff 45 fc             	incl   -0x4(%ebp)
    1143:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1146:	8b 45 08             	mov    0x8(%ebp),%eax
    1149:	01 d0                	add    %edx,%eax
    114b:	8a 00                	mov    (%eax),%al
    114d:	84 c0                	test   %al,%al
    114f:	75 ef                	jne    1140 <strlen+0xf>
    ;
  return n;
    1151:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1154:	c9                   	leave  
    1155:	c3                   	ret    

00001156 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1156:	55                   	push   %ebp
    1157:	89 e5                	mov    %esp,%ebp
    1159:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    115c:	8b 45 10             	mov    0x10(%ebp),%eax
    115f:	89 44 24 08          	mov    %eax,0x8(%esp)
    1163:	8b 45 0c             	mov    0xc(%ebp),%eax
    1166:	89 44 24 04          	mov    %eax,0x4(%esp)
    116a:	8b 45 08             	mov    0x8(%ebp),%eax
    116d:	89 04 24             	mov    %eax,(%esp)
    1170:	e8 e3 fd ff ff       	call   f58 <stosb>
  return dst;
    1175:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1178:	c9                   	leave  
    1179:	c3                   	ret    

0000117a <strchr>:

char*
strchr(const char *s, char c)
{
    117a:	55                   	push   %ebp
    117b:	89 e5                	mov    %esp,%ebp
    117d:	83 ec 04             	sub    $0x4,%esp
    1180:	8b 45 0c             	mov    0xc(%ebp),%eax
    1183:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1186:	eb 12                	jmp    119a <strchr+0x20>
    if(*s == c)
    1188:	8b 45 08             	mov    0x8(%ebp),%eax
    118b:	8a 00                	mov    (%eax),%al
    118d:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1190:	75 05                	jne    1197 <strchr+0x1d>
      return (char*)s;
    1192:	8b 45 08             	mov    0x8(%ebp),%eax
    1195:	eb 11                	jmp    11a8 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1197:	ff 45 08             	incl   0x8(%ebp)
    119a:	8b 45 08             	mov    0x8(%ebp),%eax
    119d:	8a 00                	mov    (%eax),%al
    119f:	84 c0                	test   %al,%al
    11a1:	75 e5                	jne    1188 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    11a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
    11a8:	c9                   	leave  
    11a9:	c3                   	ret    

000011aa <strcat>:

char *
strcat(char *dest, const char *src)
{
    11aa:	55                   	push   %ebp
    11ab:	89 e5                	mov    %esp,%ebp
    11ad:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
    11b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b7:	eb 03                	jmp    11bc <strcat+0x12>
    11b9:	ff 45 fc             	incl   -0x4(%ebp)
    11bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11bf:	8b 45 08             	mov    0x8(%ebp),%eax
    11c2:	01 d0                	add    %edx,%eax
    11c4:	8a 00                	mov    (%eax),%al
    11c6:	84 c0                	test   %al,%al
    11c8:	75 ef                	jne    11b9 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
    11ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    11d1:	eb 1e                	jmp    11f1 <strcat+0x47>
        dest[i+j] = src[j];
    11d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11d9:	01 d0                	add    %edx,%eax
    11db:	89 c2                	mov    %eax,%edx
    11dd:	8b 45 08             	mov    0x8(%ebp),%eax
    11e0:	01 c2                	add    %eax,%edx
    11e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    11e5:	8b 45 0c             	mov    0xc(%ebp),%eax
    11e8:	01 c8                	add    %ecx,%eax
    11ea:	8a 00                	mov    (%eax),%al
    11ec:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
    11ee:	ff 45 f8             	incl   -0x8(%ebp)
    11f1:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11f4:	8b 45 0c             	mov    0xc(%ebp),%eax
    11f7:	01 d0                	add    %edx,%eax
    11f9:	8a 00                	mov    (%eax),%al
    11fb:	84 c0                	test   %al,%al
    11fd:	75 d4                	jne    11d3 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
    11ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1202:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1205:	01 d0                	add    %edx,%eax
    1207:	89 c2                	mov    %eax,%edx
    1209:	8b 45 08             	mov    0x8(%ebp),%eax
    120c:	01 d0                	add    %edx,%eax
    120e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
    1211:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1214:	c9                   	leave  
    1215:	c3                   	ret    

00001216 <strstr>:

int 
strstr(char* s, char* sub)
{
    1216:	55                   	push   %ebp
    1217:	89 e5                	mov    %esp,%ebp
    1219:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1223:	eb 7c                	jmp    12a1 <strstr+0x8b>
    {
        if(s[i] == sub[0])
    1225:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1228:	8b 45 08             	mov    0x8(%ebp),%eax
    122b:	01 d0                	add    %edx,%eax
    122d:	8a 10                	mov    (%eax),%dl
    122f:	8b 45 0c             	mov    0xc(%ebp),%eax
    1232:	8a 00                	mov    (%eax),%al
    1234:	38 c2                	cmp    %al,%dl
    1236:	75 66                	jne    129e <strstr+0x88>
        {
            if(strlen(sub) == 1)
    1238:	8b 45 0c             	mov    0xc(%ebp),%eax
    123b:	89 04 24             	mov    %eax,(%esp)
    123e:	e8 ee fe ff ff       	call   1131 <strlen>
    1243:	83 f8 01             	cmp    $0x1,%eax
    1246:	75 05                	jne    124d <strstr+0x37>
            {  
                return i;
    1248:	8b 45 fc             	mov    -0x4(%ebp),%eax
    124b:	eb 6b                	jmp    12b8 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
    124d:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
    1254:	eb 3a                	jmp    1290 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
    1256:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1259:	8b 55 fc             	mov    -0x4(%ebp),%edx
    125c:	01 d0                	add    %edx,%eax
    125e:	89 c2                	mov    %eax,%edx
    1260:	8b 45 08             	mov    0x8(%ebp),%eax
    1263:	01 d0                	add    %edx,%eax
    1265:	8a 10                	mov    (%eax),%dl
    1267:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    126a:	8b 45 0c             	mov    0xc(%ebp),%eax
    126d:	01 c8                	add    %ecx,%eax
    126f:	8a 00                	mov    (%eax),%al
    1271:	38 c2                	cmp    %al,%dl
    1273:	75 16                	jne    128b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
    1275:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1278:	8d 50 01             	lea    0x1(%eax),%edx
    127b:	8b 45 0c             	mov    0xc(%ebp),%eax
    127e:	01 d0                	add    %edx,%eax
    1280:	8a 00                	mov    (%eax),%al
    1282:	84 c0                	test   %al,%al
    1284:	75 07                	jne    128d <strstr+0x77>
                    {
                        return i;
    1286:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1289:	eb 2d                	jmp    12b8 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
    128b:	eb 11                	jmp    129e <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
    128d:	ff 45 f8             	incl   -0x8(%ebp)
    1290:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1293:	8b 45 0c             	mov    0xc(%ebp),%eax
    1296:	01 d0                	add    %edx,%eax
    1298:	8a 00                	mov    (%eax),%al
    129a:	84 c0                	test   %al,%al
    129c:	75 b8                	jne    1256 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    129e:	ff 45 fc             	incl   -0x4(%ebp)
    12a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
    12a4:	8b 45 08             	mov    0x8(%ebp),%eax
    12a7:	01 d0                	add    %edx,%eax
    12a9:	8a 00                	mov    (%eax),%al
    12ab:	84 c0                	test   %al,%al
    12ad:	0f 85 72 ff ff ff    	jne    1225 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
    12b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    12b8:	c9                   	leave  
    12b9:	c3                   	ret    

000012ba <strtok>:

char *
strtok(char *s, const char *delim)
{
    12ba:	55                   	push   %ebp
    12bb:	89 e5                	mov    %esp,%ebp
    12bd:	53                   	push   %ebx
    12be:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
    12c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12c5:	75 08                	jne    12cf <strtok+0x15>
  s = lasts;
    12c7:	a1 88 25 00 00       	mov    0x2588,%eax
    12cc:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
    12cf:	8b 45 08             	mov    0x8(%ebp),%eax
    12d2:	8d 50 01             	lea    0x1(%eax),%edx
    12d5:	89 55 08             	mov    %edx,0x8(%ebp)
    12d8:	8a 00                	mov    (%eax),%al
    12da:	0f be d8             	movsbl %al,%ebx
    12dd:	85 db                	test   %ebx,%ebx
    12df:	75 07                	jne    12e8 <strtok+0x2e>
      return 0;
    12e1:	b8 00 00 00 00       	mov    $0x0,%eax
    12e6:	eb 58                	jmp    1340 <strtok+0x86>
    } while (strchr(delim, ch));
    12e8:	88 d8                	mov    %bl,%al
    12ea:	0f be c0             	movsbl %al,%eax
    12ed:	89 44 24 04          	mov    %eax,0x4(%esp)
    12f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12f4:	89 04 24             	mov    %eax,(%esp)
    12f7:	e8 7e fe ff ff       	call   117a <strchr>
    12fc:	85 c0                	test   %eax,%eax
    12fe:	75 cf                	jne    12cf <strtok+0x15>
    --s;
    1300:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
    1303:	8b 45 0c             	mov    0xc(%ebp),%eax
    1306:	89 44 24 04          	mov    %eax,0x4(%esp)
    130a:	8b 45 08             	mov    0x8(%ebp),%eax
    130d:	89 04 24             	mov    %eax,(%esp)
    1310:	e8 31 00 00 00       	call   1346 <strcspn>
    1315:	89 c2                	mov    %eax,%edx
    1317:	8b 45 08             	mov    0x8(%ebp),%eax
    131a:	01 d0                	add    %edx,%eax
    131c:	a3 88 25 00 00       	mov    %eax,0x2588
    if (*lasts != 0)
    1321:	a1 88 25 00 00       	mov    0x2588,%eax
    1326:	8a 00                	mov    (%eax),%al
    1328:	84 c0                	test   %al,%al
    132a:	74 11                	je     133d <strtok+0x83>
  *lasts++ = 0;
    132c:	a1 88 25 00 00       	mov    0x2588,%eax
    1331:	8d 50 01             	lea    0x1(%eax),%edx
    1334:	89 15 88 25 00 00    	mov    %edx,0x2588
    133a:	c6 00 00             	movb   $0x0,(%eax)
    return s;
    133d:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1340:	83 c4 14             	add    $0x14,%esp
    1343:	5b                   	pop    %ebx
    1344:	5d                   	pop    %ebp
    1345:	c3                   	ret    

00001346 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
    1346:	55                   	push   %ebp
    1347:	89 e5                	mov    %esp,%ebp
    1349:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
    134c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
    1353:	eb 26                	jmp    137b <strcspn+0x35>
        if(strchr(s2,*s1))
    1355:	8b 45 08             	mov    0x8(%ebp),%eax
    1358:	8a 00                	mov    (%eax),%al
    135a:	0f be c0             	movsbl %al,%eax
    135d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1361:	8b 45 0c             	mov    0xc(%ebp),%eax
    1364:	89 04 24             	mov    %eax,(%esp)
    1367:	e8 0e fe ff ff       	call   117a <strchr>
    136c:	85 c0                	test   %eax,%eax
    136e:	74 05                	je     1375 <strcspn+0x2f>
            return ret;
    1370:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1373:	eb 12                	jmp    1387 <strcspn+0x41>
        else
            s1++,ret++;
    1375:	ff 45 08             	incl   0x8(%ebp)
    1378:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
    137b:	8b 45 08             	mov    0x8(%ebp),%eax
    137e:	8a 00                	mov    (%eax),%al
    1380:	84 c0                	test   %al,%al
    1382:	75 d1                	jne    1355 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
    1384:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1387:	c9                   	leave  
    1388:	c3                   	ret    

00001389 <isspace>:

int
isspace(unsigned char c)
{
    1389:	55                   	push   %ebp
    138a:	89 e5                	mov    %esp,%ebp
    138c:	83 ec 04             	sub    $0x4,%esp
    138f:	8b 45 08             	mov    0x8(%ebp),%eax
    1392:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
    1395:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
    1399:	74 1e                	je     13b9 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
    139b:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
    139f:	74 18                	je     13b9 <isspace+0x30>
    13a1:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
    13a5:	74 12                	je     13b9 <isspace+0x30>
    13a7:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
    13ab:	74 0c                	je     13b9 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
    13ad:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
    13b1:	74 06                	je     13b9 <isspace+0x30>
    13b3:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
    13b7:	75 07                	jne    13c0 <isspace+0x37>
    13b9:	b8 01 00 00 00       	mov    $0x1,%eax
    13be:	eb 05                	jmp    13c5 <isspace+0x3c>
    13c0:	b8 00 00 00 00       	mov    $0x0,%eax
}
    13c5:	c9                   	leave  
    13c6:	c3                   	ret    

000013c7 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
    13c7:	55                   	push   %ebp
    13c8:	89 e5                	mov    %esp,%ebp
    13ca:	57                   	push   %edi
    13cb:	56                   	push   %esi
    13cc:	53                   	push   %ebx
    13cd:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
    13d0:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
    13d5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
    13dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    13df:	eb 01                	jmp    13e2 <strtoul+0x1b>
  p += 1;
    13e1:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    13e2:	8a 03                	mov    (%ebx),%al
    13e4:	0f b6 c0             	movzbl %al,%eax
    13e7:	89 04 24             	mov    %eax,(%esp)
    13ea:	e8 9a ff ff ff       	call   1389 <isspace>
    13ef:	85 c0                	test   %eax,%eax
    13f1:	75 ee                	jne    13e1 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
    13f3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    13f7:	75 30                	jne    1429 <strtoul+0x62>
    {
  if (*p == '0') {
    13f9:	8a 03                	mov    (%ebx),%al
    13fb:	3c 30                	cmp    $0x30,%al
    13fd:	75 21                	jne    1420 <strtoul+0x59>
      p += 1;
    13ff:	43                   	inc    %ebx
      if (*p == 'x') {
    1400:	8a 03                	mov    (%ebx),%al
    1402:	3c 78                	cmp    $0x78,%al
    1404:	75 0a                	jne    1410 <strtoul+0x49>
    p += 1;
    1406:	43                   	inc    %ebx
    base = 16;
    1407:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
    140e:	eb 31                	jmp    1441 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
    1410:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
    1417:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
    141e:	eb 21                	jmp    1441 <strtoul+0x7a>
      }
  }
  else base = 10;
    1420:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    1427:	eb 18                	jmp    1441 <strtoul+0x7a>
    } else if (base == 16) {
    1429:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    142d:	75 12                	jne    1441 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
    142f:	8a 03                	mov    (%ebx),%al
    1431:	3c 30                	cmp    $0x30,%al
    1433:	75 0c                	jne    1441 <strtoul+0x7a>
    1435:	8d 43 01             	lea    0x1(%ebx),%eax
    1438:	8a 00                	mov    (%eax),%al
    143a:	3c 78                	cmp    $0x78,%al
    143c:	75 03                	jne    1441 <strtoul+0x7a>
      p += 2;
    143e:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
    1441:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
    1445:	75 29                	jne    1470 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
    1447:	8a 03                	mov    (%ebx),%al
    1449:	0f be c0             	movsbl %al,%eax
    144c:	83 e8 30             	sub    $0x30,%eax
    144f:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
    1451:	83 fe 07             	cmp    $0x7,%esi
    1454:	76 06                	jbe    145c <strtoul+0x95>
    break;
    1456:	90                   	nop
    1457:	e9 b6 00 00 00       	jmp    1512 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
    145c:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
    1463:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1466:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
    146d:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    146e:	eb d7                	jmp    1447 <strtoul+0x80>
    } else if (base == 10) {
    1470:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
    1474:	75 2b                	jne    14a1 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
    1476:	8a 03                	mov    (%ebx),%al
    1478:	0f be c0             	movsbl %al,%eax
    147b:	83 e8 30             	sub    $0x30,%eax
    147e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
    1480:	83 fe 09             	cmp    $0x9,%esi
    1483:	76 06                	jbe    148b <strtoul+0xc4>
    break;
    1485:	90                   	nop
    1486:	e9 87 00 00 00       	jmp    1512 <strtoul+0x14b>
      }
      result = (10*result) + digit;
    148b:	89 f8                	mov    %edi,%eax
    148d:	c1 e0 02             	shl    $0x2,%eax
    1490:	01 f8                	add    %edi,%eax
    1492:	01 c0                	add    %eax,%eax
    1494:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1497:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
    149e:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    149f:	eb d5                	jmp    1476 <strtoul+0xaf>
    } else if (base == 16) {
    14a1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    14a5:	75 35                	jne    14dc <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
    14a7:	8a 03                	mov    (%ebx),%al
    14a9:	0f be c0             	movsbl %al,%eax
    14ac:	83 e8 30             	sub    $0x30,%eax
    14af:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    14b1:	83 fe 4a             	cmp    $0x4a,%esi
    14b4:	76 02                	jbe    14b8 <strtoul+0xf1>
    break;
    14b6:	eb 22                	jmp    14da <strtoul+0x113>
      }
      digit = cvtIn[digit];
    14b8:	8a 86 c0 24 00 00    	mov    0x24c0(%esi),%al
    14be:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
    14c1:	83 fe 0f             	cmp    $0xf,%esi
    14c4:	76 02                	jbe    14c8 <strtoul+0x101>
    break;
    14c6:	eb 12                	jmp    14da <strtoul+0x113>
      }
      result = (result << 4) + digit;
    14c8:	89 f8                	mov    %edi,%eax
    14ca:	c1 e0 04             	shl    $0x4,%eax
    14cd:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    14d0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
    14d7:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    14d8:	eb cd                	jmp    14a7 <strtoul+0xe0>
    14da:	eb 36                	jmp    1512 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
    14dc:	8a 03                	mov    (%ebx),%al
    14de:	0f be c0             	movsbl %al,%eax
    14e1:	83 e8 30             	sub    $0x30,%eax
    14e4:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    14e6:	83 fe 4a             	cmp    $0x4a,%esi
    14e9:	76 02                	jbe    14ed <strtoul+0x126>
    break;
    14eb:	eb 25                	jmp    1512 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
    14ed:	8a 86 c0 24 00 00    	mov    0x24c0(%esi),%al
    14f3:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
    14f6:	8b 45 10             	mov    0x10(%ebp),%eax
    14f9:	39 f0                	cmp    %esi,%eax
    14fb:	77 02                	ja     14ff <strtoul+0x138>
    break;
    14fd:	eb 13                	jmp    1512 <strtoul+0x14b>
      }
      result = result*base + digit;
    14ff:	8b 45 10             	mov    0x10(%ebp),%eax
    1502:	0f af c7             	imul   %edi,%eax
    1505:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1508:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
    150f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
    1510:	eb ca                	jmp    14dc <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
    1512:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1516:	75 03                	jne    151b <strtoul+0x154>
  p = string;
    1518:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
    151b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    151f:	74 05                	je     1526 <strtoul+0x15f>
  *endPtr = p;
    1521:	8b 45 0c             	mov    0xc(%ebp),%eax
    1524:	89 18                	mov    %ebx,(%eax)
    }

    return result;
    1526:	89 f8                	mov    %edi,%eax
}
    1528:	83 c4 14             	add    $0x14,%esp
    152b:	5b                   	pop    %ebx
    152c:	5e                   	pop    %esi
    152d:	5f                   	pop    %edi
    152e:	5d                   	pop    %ebp
    152f:	c3                   	ret    

00001530 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
    1530:	55                   	push   %ebp
    1531:	89 e5                	mov    %esp,%ebp
    1533:	53                   	push   %ebx
    1534:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
    1537:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    153a:	eb 01                	jmp    153d <strtol+0xd>
      p += 1;
    153c:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    153d:	8a 03                	mov    (%ebx),%al
    153f:	0f b6 c0             	movzbl %al,%eax
    1542:	89 04 24             	mov    %eax,(%esp)
    1545:	e8 3f fe ff ff       	call   1389 <isspace>
    154a:	85 c0                	test   %eax,%eax
    154c:	75 ee                	jne    153c <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
    154e:	8a 03                	mov    (%ebx),%al
    1550:	3c 2d                	cmp    $0x2d,%al
    1552:	75 1e                	jne    1572 <strtol+0x42>
  p += 1;
    1554:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
    1555:	8b 45 10             	mov    0x10(%ebp),%eax
    1558:	89 44 24 08          	mov    %eax,0x8(%esp)
    155c:	8b 45 0c             	mov    0xc(%ebp),%eax
    155f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1563:	89 1c 24             	mov    %ebx,(%esp)
    1566:	e8 5c fe ff ff       	call   13c7 <strtoul>
    156b:	f7 d8                	neg    %eax
    156d:	89 45 f8             	mov    %eax,-0x8(%ebp)
    1570:	eb 20                	jmp    1592 <strtol+0x62>
    } else {
  if (*p == '+') {
    1572:	8a 03                	mov    (%ebx),%al
    1574:	3c 2b                	cmp    $0x2b,%al
    1576:	75 01                	jne    1579 <strtol+0x49>
      p += 1;
    1578:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
    1579:	8b 45 10             	mov    0x10(%ebp),%eax
    157c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1580:	8b 45 0c             	mov    0xc(%ebp),%eax
    1583:	89 44 24 04          	mov    %eax,0x4(%esp)
    1587:	89 1c 24             	mov    %ebx,(%esp)
    158a:	e8 38 fe ff ff       	call   13c7 <strtoul>
    158f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
    1592:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
    1596:	75 17                	jne    15af <strtol+0x7f>
    1598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    159c:	74 11                	je     15af <strtol+0x7f>
    159e:	8b 45 0c             	mov    0xc(%ebp),%eax
    15a1:	8b 00                	mov    (%eax),%eax
    15a3:	39 d8                	cmp    %ebx,%eax
    15a5:	75 08                	jne    15af <strtol+0x7f>
  *endPtr = string;
    15a7:	8b 45 0c             	mov    0xc(%ebp),%eax
    15aa:	8b 55 08             	mov    0x8(%ebp),%edx
    15ad:	89 10                	mov    %edx,(%eax)
    }
    return result;
    15af:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
    15b2:	83 c4 1c             	add    $0x1c,%esp
    15b5:	5b                   	pop    %ebx
    15b6:	5d                   	pop    %ebp
    15b7:	c3                   	ret    

000015b8 <gets>:

char*
gets(char *buf, int max)
{
    15b8:	55                   	push   %ebp
    15b9:	89 e5                	mov    %esp,%ebp
    15bb:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    15be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    15c5:	eb 49                	jmp    1610 <gets+0x58>
    cc = read(0, &c, 1);
    15c7:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    15ce:	00 
    15cf:	8d 45 ef             	lea    -0x11(%ebp),%eax
    15d2:	89 44 24 04          	mov    %eax,0x4(%esp)
    15d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    15dd:	e8 3e 01 00 00       	call   1720 <read>
    15e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    15e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    15e9:	7f 02                	jg     15ed <gets+0x35>
      break;
    15eb:	eb 2c                	jmp    1619 <gets+0x61>
    buf[i++] = c;
    15ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15f0:	8d 50 01             	lea    0x1(%eax),%edx
    15f3:	89 55 f4             	mov    %edx,-0xc(%ebp)
    15f6:	89 c2                	mov    %eax,%edx
    15f8:	8b 45 08             	mov    0x8(%ebp),%eax
    15fb:	01 c2                	add    %eax,%edx
    15fd:	8a 45 ef             	mov    -0x11(%ebp),%al
    1600:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1602:	8a 45 ef             	mov    -0x11(%ebp),%al
    1605:	3c 0a                	cmp    $0xa,%al
    1607:	74 10                	je     1619 <gets+0x61>
    1609:	8a 45 ef             	mov    -0x11(%ebp),%al
    160c:	3c 0d                	cmp    $0xd,%al
    160e:	74 09                	je     1619 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1610:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1613:	40                   	inc    %eax
    1614:	3b 45 0c             	cmp    0xc(%ebp),%eax
    1617:	7c ae                	jl     15c7 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    1619:	8b 55 f4             	mov    -0xc(%ebp),%edx
    161c:	8b 45 08             	mov    0x8(%ebp),%eax
    161f:	01 d0                	add    %edx,%eax
    1621:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    1624:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1627:	c9                   	leave  
    1628:	c3                   	ret    

00001629 <stat>:

int
stat(char *n, struct stat *st)
{
    1629:	55                   	push   %ebp
    162a:	89 e5                	mov    %esp,%ebp
    162c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    162f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1636:	00 
    1637:	8b 45 08             	mov    0x8(%ebp),%eax
    163a:	89 04 24             	mov    %eax,(%esp)
    163d:	e8 06 01 00 00       	call   1748 <open>
    1642:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    1645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1649:	79 07                	jns    1652 <stat+0x29>
    return -1;
    164b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    1650:	eb 23                	jmp    1675 <stat+0x4c>
  r = fstat(fd, st);
    1652:	8b 45 0c             	mov    0xc(%ebp),%eax
    1655:	89 44 24 04          	mov    %eax,0x4(%esp)
    1659:	8b 45 f4             	mov    -0xc(%ebp),%eax
    165c:	89 04 24             	mov    %eax,(%esp)
    165f:	e8 fc 00 00 00       	call   1760 <fstat>
    1664:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    1667:	8b 45 f4             	mov    -0xc(%ebp),%eax
    166a:	89 04 24             	mov    %eax,(%esp)
    166d:	e8 be 00 00 00       	call   1730 <close>
  return r;
    1672:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1675:	c9                   	leave  
    1676:	c3                   	ret    

00001677 <atoi>:

int
atoi(const char *s)
{
    1677:	55                   	push   %ebp
    1678:	89 e5                	mov    %esp,%ebp
    167a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    167d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1684:	eb 24                	jmp    16aa <atoi+0x33>
    n = n*10 + *s++ - '0';
    1686:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1689:	89 d0                	mov    %edx,%eax
    168b:	c1 e0 02             	shl    $0x2,%eax
    168e:	01 d0                	add    %edx,%eax
    1690:	01 c0                	add    %eax,%eax
    1692:	89 c1                	mov    %eax,%ecx
    1694:	8b 45 08             	mov    0x8(%ebp),%eax
    1697:	8d 50 01             	lea    0x1(%eax),%edx
    169a:	89 55 08             	mov    %edx,0x8(%ebp)
    169d:	8a 00                	mov    (%eax),%al
    169f:	0f be c0             	movsbl %al,%eax
    16a2:	01 c8                	add    %ecx,%eax
    16a4:	83 e8 30             	sub    $0x30,%eax
    16a7:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    16aa:	8b 45 08             	mov    0x8(%ebp),%eax
    16ad:	8a 00                	mov    (%eax),%al
    16af:	3c 2f                	cmp    $0x2f,%al
    16b1:	7e 09                	jle    16bc <atoi+0x45>
    16b3:	8b 45 08             	mov    0x8(%ebp),%eax
    16b6:	8a 00                	mov    (%eax),%al
    16b8:	3c 39                	cmp    $0x39,%al
    16ba:	7e ca                	jle    1686 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    16bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    16bf:	c9                   	leave  
    16c0:	c3                   	ret    

000016c1 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    16c1:	55                   	push   %ebp
    16c2:	89 e5                	mov    %esp,%ebp
    16c4:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    16c7:	8b 45 08             	mov    0x8(%ebp),%eax
    16ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    16cd:	8b 45 0c             	mov    0xc(%ebp),%eax
    16d0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    16d3:	eb 16                	jmp    16eb <memmove+0x2a>
    *dst++ = *src++;
    16d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    16d8:	8d 50 01             	lea    0x1(%eax),%edx
    16db:	89 55 fc             	mov    %edx,-0x4(%ebp)
    16de:	8b 55 f8             	mov    -0x8(%ebp),%edx
    16e1:	8d 4a 01             	lea    0x1(%edx),%ecx
    16e4:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    16e7:	8a 12                	mov    (%edx),%dl
    16e9:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    16eb:	8b 45 10             	mov    0x10(%ebp),%eax
    16ee:	8d 50 ff             	lea    -0x1(%eax),%edx
    16f1:	89 55 10             	mov    %edx,0x10(%ebp)
    16f4:	85 c0                	test   %eax,%eax
    16f6:	7f dd                	jg     16d5 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    16f8:	8b 45 08             	mov    0x8(%ebp),%eax
}
    16fb:	c9                   	leave  
    16fc:	c3                   	ret    
    16fd:	90                   	nop
    16fe:	90                   	nop
    16ff:	90                   	nop

00001700 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1700:	b8 01 00 00 00       	mov    $0x1,%eax
    1705:	cd 40                	int    $0x40
    1707:	c3                   	ret    

00001708 <exit>:
SYSCALL(exit)
    1708:	b8 02 00 00 00       	mov    $0x2,%eax
    170d:	cd 40                	int    $0x40
    170f:	c3                   	ret    

00001710 <wait>:
SYSCALL(wait)
    1710:	b8 03 00 00 00       	mov    $0x3,%eax
    1715:	cd 40                	int    $0x40
    1717:	c3                   	ret    

00001718 <pipe>:
SYSCALL(pipe)
    1718:	b8 04 00 00 00       	mov    $0x4,%eax
    171d:	cd 40                	int    $0x40
    171f:	c3                   	ret    

00001720 <read>:
SYSCALL(read)
    1720:	b8 05 00 00 00       	mov    $0x5,%eax
    1725:	cd 40                	int    $0x40
    1727:	c3                   	ret    

00001728 <write>:
SYSCALL(write)
    1728:	b8 10 00 00 00       	mov    $0x10,%eax
    172d:	cd 40                	int    $0x40
    172f:	c3                   	ret    

00001730 <close>:
SYSCALL(close)
    1730:	b8 15 00 00 00       	mov    $0x15,%eax
    1735:	cd 40                	int    $0x40
    1737:	c3                   	ret    

00001738 <kill>:
SYSCALL(kill)
    1738:	b8 06 00 00 00       	mov    $0x6,%eax
    173d:	cd 40                	int    $0x40
    173f:	c3                   	ret    

00001740 <exec>:
SYSCALL(exec)
    1740:	b8 07 00 00 00       	mov    $0x7,%eax
    1745:	cd 40                	int    $0x40
    1747:	c3                   	ret    

00001748 <open>:
SYSCALL(open)
    1748:	b8 0f 00 00 00       	mov    $0xf,%eax
    174d:	cd 40                	int    $0x40
    174f:	c3                   	ret    

00001750 <mknod>:
SYSCALL(mknod)
    1750:	b8 11 00 00 00       	mov    $0x11,%eax
    1755:	cd 40                	int    $0x40
    1757:	c3                   	ret    

00001758 <unlink>:
SYSCALL(unlink)
    1758:	b8 12 00 00 00       	mov    $0x12,%eax
    175d:	cd 40                	int    $0x40
    175f:	c3                   	ret    

00001760 <fstat>:
SYSCALL(fstat)
    1760:	b8 08 00 00 00       	mov    $0x8,%eax
    1765:	cd 40                	int    $0x40
    1767:	c3                   	ret    

00001768 <link>:
SYSCALL(link)
    1768:	b8 13 00 00 00       	mov    $0x13,%eax
    176d:	cd 40                	int    $0x40
    176f:	c3                   	ret    

00001770 <mkdir>:
SYSCALL(mkdir)
    1770:	b8 14 00 00 00       	mov    $0x14,%eax
    1775:	cd 40                	int    $0x40
    1777:	c3                   	ret    

00001778 <chdir>:
SYSCALL(chdir)
    1778:	b8 09 00 00 00       	mov    $0x9,%eax
    177d:	cd 40                	int    $0x40
    177f:	c3                   	ret    

00001780 <dup>:
SYSCALL(dup)
    1780:	b8 0a 00 00 00       	mov    $0xa,%eax
    1785:	cd 40                	int    $0x40
    1787:	c3                   	ret    

00001788 <getpid>:
SYSCALL(getpid)
    1788:	b8 0b 00 00 00       	mov    $0xb,%eax
    178d:	cd 40                	int    $0x40
    178f:	c3                   	ret    

00001790 <sbrk>:
SYSCALL(sbrk)
    1790:	b8 0c 00 00 00       	mov    $0xc,%eax
    1795:	cd 40                	int    $0x40
    1797:	c3                   	ret    

00001798 <sleep>:
SYSCALL(sleep)
    1798:	b8 0d 00 00 00       	mov    $0xd,%eax
    179d:	cd 40                	int    $0x40
    179f:	c3                   	ret    

000017a0 <uptime>:
SYSCALL(uptime)
    17a0:	b8 0e 00 00 00       	mov    $0xe,%eax
    17a5:	cd 40                	int    $0x40
    17a7:	c3                   	ret    

000017a8 <getname>:
SYSCALL(getname)
    17a8:	b8 16 00 00 00       	mov    $0x16,%eax
    17ad:	cd 40                	int    $0x40
    17af:	c3                   	ret    

000017b0 <setname>:
SYSCALL(setname)
    17b0:	b8 17 00 00 00       	mov    $0x17,%eax
    17b5:	cd 40                	int    $0x40
    17b7:	c3                   	ret    

000017b8 <getmaxproc>:
SYSCALL(getmaxproc)
    17b8:	b8 18 00 00 00       	mov    $0x18,%eax
    17bd:	cd 40                	int    $0x40
    17bf:	c3                   	ret    

000017c0 <setmaxproc>:
SYSCALL(setmaxproc)
    17c0:	b8 19 00 00 00       	mov    $0x19,%eax
    17c5:	cd 40                	int    $0x40
    17c7:	c3                   	ret    

000017c8 <getmaxmem>:
SYSCALL(getmaxmem)
    17c8:	b8 1a 00 00 00       	mov    $0x1a,%eax
    17cd:	cd 40                	int    $0x40
    17cf:	c3                   	ret    

000017d0 <setmaxmem>:
SYSCALL(setmaxmem)
    17d0:	b8 1b 00 00 00       	mov    $0x1b,%eax
    17d5:	cd 40                	int    $0x40
    17d7:	c3                   	ret    

000017d8 <getmaxdisk>:
SYSCALL(getmaxdisk)
    17d8:	b8 1c 00 00 00       	mov    $0x1c,%eax
    17dd:	cd 40                	int    $0x40
    17df:	c3                   	ret    

000017e0 <setmaxdisk>:
SYSCALL(setmaxdisk)
    17e0:	b8 1d 00 00 00       	mov    $0x1d,%eax
    17e5:	cd 40                	int    $0x40
    17e7:	c3                   	ret    

000017e8 <getusedmem>:
SYSCALL(getusedmem)
    17e8:	b8 1e 00 00 00       	mov    $0x1e,%eax
    17ed:	cd 40                	int    $0x40
    17ef:	c3                   	ret    

000017f0 <setusedmem>:
SYSCALL(setusedmem)
    17f0:	b8 1f 00 00 00       	mov    $0x1f,%eax
    17f5:	cd 40                	int    $0x40
    17f7:	c3                   	ret    

000017f8 <getuseddisk>:
SYSCALL(getuseddisk)
    17f8:	b8 20 00 00 00       	mov    $0x20,%eax
    17fd:	cd 40                	int    $0x40
    17ff:	c3                   	ret    

00001800 <setuseddisk>:
SYSCALL(setuseddisk)
    1800:	b8 21 00 00 00       	mov    $0x21,%eax
    1805:	cd 40                	int    $0x40
    1807:	c3                   	ret    

00001808 <setvc>:
SYSCALL(setvc)
    1808:	b8 22 00 00 00       	mov    $0x22,%eax
    180d:	cd 40                	int    $0x40
    180f:	c3                   	ret    

00001810 <setactivefs>:
SYSCALL(setactivefs)
    1810:	b8 24 00 00 00       	mov    $0x24,%eax
    1815:	cd 40                	int    $0x40
    1817:	c3                   	ret    

00001818 <getactivefs>:
SYSCALL(getactivefs)
    1818:	b8 25 00 00 00       	mov    $0x25,%eax
    181d:	cd 40                	int    $0x40
    181f:	c3                   	ret    

00001820 <getvcfs>:
SYSCALL(getvcfs)
    1820:	b8 23 00 00 00       	mov    $0x23,%eax
    1825:	cd 40                	int    $0x40
    1827:	c3                   	ret    

00001828 <getcwd>:
SYSCALL(getcwd)
    1828:	b8 26 00 00 00       	mov    $0x26,%eax
    182d:	cd 40                	int    $0x40
    182f:	c3                   	ret    

00001830 <tostring>:
SYSCALL(tostring)
    1830:	b8 27 00 00 00       	mov    $0x27,%eax
    1835:	cd 40                	int    $0x40
    1837:	c3                   	ret    

00001838 <getactivefsindex>:
SYSCALL(getactivefsindex)
    1838:	b8 28 00 00 00       	mov    $0x28,%eax
    183d:	cd 40                	int    $0x40
    183f:	c3                   	ret    

00001840 <setatroot>:
SYSCALL(setatroot)
    1840:	b8 2a 00 00 00       	mov    $0x2a,%eax
    1845:	cd 40                	int    $0x40
    1847:	c3                   	ret    

00001848 <getatroot>:
SYSCALL(getatroot)
    1848:	b8 29 00 00 00       	mov    $0x29,%eax
    184d:	cd 40                	int    $0x40
    184f:	c3                   	ret    

00001850 <getpath>:
SYSCALL(getpath)
    1850:	b8 2b 00 00 00       	mov    $0x2b,%eax
    1855:	cd 40                	int    $0x40
    1857:	c3                   	ret    

00001858 <setpath>:
SYSCALL(setpath)
    1858:	b8 2c 00 00 00       	mov    $0x2c,%eax
    185d:	cd 40                	int    $0x40
    185f:	c3                   	ret    

00001860 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    1860:	55                   	push   %ebp
    1861:	89 e5                	mov    %esp,%ebp
    1863:	83 ec 18             	sub    $0x18,%esp
    1866:	8b 45 0c             	mov    0xc(%ebp),%eax
    1869:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    186c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1873:	00 
    1874:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1877:	89 44 24 04          	mov    %eax,0x4(%esp)
    187b:	8b 45 08             	mov    0x8(%ebp),%eax
    187e:	89 04 24             	mov    %eax,(%esp)
    1881:	e8 a2 fe ff ff       	call   1728 <write>
}
    1886:	c9                   	leave  
    1887:	c3                   	ret    

00001888 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1888:	55                   	push   %ebp
    1889:	89 e5                	mov    %esp,%ebp
    188b:	56                   	push   %esi
    188c:	53                   	push   %ebx
    188d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1890:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1897:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    189b:	74 17                	je     18b4 <printint+0x2c>
    189d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    18a1:	79 11                	jns    18b4 <printint+0x2c>
    neg = 1;
    18a3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    18aa:	8b 45 0c             	mov    0xc(%ebp),%eax
    18ad:	f7 d8                	neg    %eax
    18af:	89 45 ec             	mov    %eax,-0x14(%ebp)
    18b2:	eb 06                	jmp    18ba <printint+0x32>
  } else {
    x = xx;
    18b4:	8b 45 0c             	mov    0xc(%ebp),%eax
    18b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    18ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    18c1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    18c4:	8d 41 01             	lea    0x1(%ecx),%eax
    18c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    18ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
    18cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18d0:	ba 00 00 00 00       	mov    $0x0,%edx
    18d5:	f7 f3                	div    %ebx
    18d7:	89 d0                	mov    %edx,%eax
    18d9:	8a 80 0c 25 00 00    	mov    0x250c(%eax),%al
    18df:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    18e3:	8b 75 10             	mov    0x10(%ebp),%esi
    18e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
    18e9:	ba 00 00 00 00       	mov    $0x0,%edx
    18ee:	f7 f6                	div    %esi
    18f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    18f3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    18f7:	75 c8                	jne    18c1 <printint+0x39>
  if(neg)
    18f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    18fd:	74 10                	je     190f <printint+0x87>
    buf[i++] = '-';
    18ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1902:	8d 50 01             	lea    0x1(%eax),%edx
    1905:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1908:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    190d:	eb 1e                	jmp    192d <printint+0xa5>
    190f:	eb 1c                	jmp    192d <printint+0xa5>
    putc(fd, buf[i]);
    1911:	8d 55 dc             	lea    -0x24(%ebp),%edx
    1914:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1917:	01 d0                	add    %edx,%eax
    1919:	8a 00                	mov    (%eax),%al
    191b:	0f be c0             	movsbl %al,%eax
    191e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1922:	8b 45 08             	mov    0x8(%ebp),%eax
    1925:	89 04 24             	mov    %eax,(%esp)
    1928:	e8 33 ff ff ff       	call   1860 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    192d:	ff 4d f4             	decl   -0xc(%ebp)
    1930:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1934:	79 db                	jns    1911 <printint+0x89>
    putc(fd, buf[i]);
}
    1936:	83 c4 30             	add    $0x30,%esp
    1939:	5b                   	pop    %ebx
    193a:	5e                   	pop    %esi
    193b:	5d                   	pop    %ebp
    193c:	c3                   	ret    

0000193d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    193d:	55                   	push   %ebp
    193e:	89 e5                	mov    %esp,%ebp
    1940:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    1943:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    194a:	8d 45 0c             	lea    0xc(%ebp),%eax
    194d:	83 c0 04             	add    $0x4,%eax
    1950:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    1953:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    195a:	e9 77 01 00 00       	jmp    1ad6 <printf+0x199>
    c = fmt[i] & 0xff;
    195f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1962:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1965:	01 d0                	add    %edx,%eax
    1967:	8a 00                	mov    (%eax),%al
    1969:	0f be c0             	movsbl %al,%eax
    196c:	25 ff 00 00 00       	and    $0xff,%eax
    1971:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1974:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1978:	75 2c                	jne    19a6 <printf+0x69>
      if(c == '%'){
    197a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    197e:	75 0c                	jne    198c <printf+0x4f>
        state = '%';
    1980:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1987:	e9 47 01 00 00       	jmp    1ad3 <printf+0x196>
      } else {
        putc(fd, c);
    198c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    198f:	0f be c0             	movsbl %al,%eax
    1992:	89 44 24 04          	mov    %eax,0x4(%esp)
    1996:	8b 45 08             	mov    0x8(%ebp),%eax
    1999:	89 04 24             	mov    %eax,(%esp)
    199c:	e8 bf fe ff ff       	call   1860 <putc>
    19a1:	e9 2d 01 00 00       	jmp    1ad3 <printf+0x196>
      }
    } else if(state == '%'){
    19a6:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    19aa:	0f 85 23 01 00 00    	jne    1ad3 <printf+0x196>
      if(c == 'd'){
    19b0:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    19b4:	75 2d                	jne    19e3 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    19b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    19b9:	8b 00                	mov    (%eax),%eax
    19bb:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    19c2:	00 
    19c3:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    19ca:	00 
    19cb:	89 44 24 04          	mov    %eax,0x4(%esp)
    19cf:	8b 45 08             	mov    0x8(%ebp),%eax
    19d2:	89 04 24             	mov    %eax,(%esp)
    19d5:	e8 ae fe ff ff       	call   1888 <printint>
        ap++;
    19da:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    19de:	e9 e9 00 00 00       	jmp    1acc <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    19e3:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    19e7:	74 06                	je     19ef <printf+0xb2>
    19e9:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    19ed:	75 2d                	jne    1a1c <printf+0xdf>
        printint(fd, *ap, 16, 0);
    19ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
    19f2:	8b 00                	mov    (%eax),%eax
    19f4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    19fb:	00 
    19fc:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1a03:	00 
    1a04:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a08:	8b 45 08             	mov    0x8(%ebp),%eax
    1a0b:	89 04 24             	mov    %eax,(%esp)
    1a0e:	e8 75 fe ff ff       	call   1888 <printint>
        ap++;
    1a13:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1a17:	e9 b0 00 00 00       	jmp    1acc <printf+0x18f>
      } else if(c == 's'){
    1a1c:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1a20:	75 42                	jne    1a64 <printf+0x127>
        s = (char*)*ap;
    1a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1a25:	8b 00                	mov    (%eax),%eax
    1a27:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    1a2a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1a2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1a32:	75 09                	jne    1a3d <printf+0x100>
          s = "(null)";
    1a34:	c7 45 f4 8f 1e 00 00 	movl   $0x1e8f,-0xc(%ebp)
        while(*s != 0){
    1a3b:	eb 1c                	jmp    1a59 <printf+0x11c>
    1a3d:	eb 1a                	jmp    1a59 <printf+0x11c>
          putc(fd, *s);
    1a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a42:	8a 00                	mov    (%eax),%al
    1a44:	0f be c0             	movsbl %al,%eax
    1a47:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a4b:	8b 45 08             	mov    0x8(%ebp),%eax
    1a4e:	89 04 24             	mov    %eax,(%esp)
    1a51:	e8 0a fe ff ff       	call   1860 <putc>
          s++;
    1a56:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1a5c:	8a 00                	mov    (%eax),%al
    1a5e:	84 c0                	test   %al,%al
    1a60:	75 dd                	jne    1a3f <printf+0x102>
    1a62:	eb 68                	jmp    1acc <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1a64:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1a68:	75 1d                	jne    1a87 <printf+0x14a>
        putc(fd, *ap);
    1a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1a6d:	8b 00                	mov    (%eax),%eax
    1a6f:	0f be c0             	movsbl %al,%eax
    1a72:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a76:	8b 45 08             	mov    0x8(%ebp),%eax
    1a79:	89 04 24             	mov    %eax,(%esp)
    1a7c:	e8 df fd ff ff       	call   1860 <putc>
        ap++;
    1a81:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1a85:	eb 45                	jmp    1acc <printf+0x18f>
      } else if(c == '%'){
    1a87:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1a8b:	75 17                	jne    1aa4 <printf+0x167>
        putc(fd, c);
    1a8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1a90:	0f be c0             	movsbl %al,%eax
    1a93:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a97:	8b 45 08             	mov    0x8(%ebp),%eax
    1a9a:	89 04 24             	mov    %eax,(%esp)
    1a9d:	e8 be fd ff ff       	call   1860 <putc>
    1aa2:	eb 28                	jmp    1acc <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1aa4:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1aab:	00 
    1aac:	8b 45 08             	mov    0x8(%ebp),%eax
    1aaf:	89 04 24             	mov    %eax,(%esp)
    1ab2:	e8 a9 fd ff ff       	call   1860 <putc>
        putc(fd, c);
    1ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1aba:	0f be c0             	movsbl %al,%eax
    1abd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1ac1:	8b 45 08             	mov    0x8(%ebp),%eax
    1ac4:	89 04 24             	mov    %eax,(%esp)
    1ac7:	e8 94 fd ff ff       	call   1860 <putc>
      }
      state = 0;
    1acc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1ad3:	ff 45 f0             	incl   -0x10(%ebp)
    1ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
    1ad9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1adc:	01 d0                	add    %edx,%eax
    1ade:	8a 00                	mov    (%eax),%al
    1ae0:	84 c0                	test   %al,%al
    1ae2:	0f 85 77 fe ff ff    	jne    195f <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1ae8:	c9                   	leave  
    1ae9:	c3                   	ret    
    1aea:	90                   	nop
    1aeb:	90                   	nop

00001aec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1aec:	55                   	push   %ebp
    1aed:	89 e5                	mov    %esp,%ebp
    1aef:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1af2:	8b 45 08             	mov    0x8(%ebp),%eax
    1af5:	83 e8 08             	sub    $0x8,%eax
    1af8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1afb:	a1 94 25 00 00       	mov    0x2594,%eax
    1b00:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1b03:	eb 24                	jmp    1b29 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1b05:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b08:	8b 00                	mov    (%eax),%eax
    1b0a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1b0d:	77 12                	ja     1b21 <free+0x35>
    1b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b12:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1b15:	77 24                	ja     1b3b <free+0x4f>
    1b17:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b1a:	8b 00                	mov    (%eax),%eax
    1b1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1b1f:	77 1a                	ja     1b3b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1b21:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b24:	8b 00                	mov    (%eax),%eax
    1b26:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1b29:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b2c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1b2f:	76 d4                	jbe    1b05 <free+0x19>
    1b31:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b34:	8b 00                	mov    (%eax),%eax
    1b36:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1b39:	76 ca                	jbe    1b05 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1b3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b3e:	8b 40 04             	mov    0x4(%eax),%eax
    1b41:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1b48:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b4b:	01 c2                	add    %eax,%edx
    1b4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b50:	8b 00                	mov    (%eax),%eax
    1b52:	39 c2                	cmp    %eax,%edx
    1b54:	75 24                	jne    1b7a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1b56:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b59:	8b 50 04             	mov    0x4(%eax),%edx
    1b5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b5f:	8b 00                	mov    (%eax),%eax
    1b61:	8b 40 04             	mov    0x4(%eax),%eax
    1b64:	01 c2                	add    %eax,%edx
    1b66:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b69:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1b6c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b6f:	8b 00                	mov    (%eax),%eax
    1b71:	8b 10                	mov    (%eax),%edx
    1b73:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b76:	89 10                	mov    %edx,(%eax)
    1b78:	eb 0a                	jmp    1b84 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1b7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b7d:	8b 10                	mov    (%eax),%edx
    1b7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b82:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1b84:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b87:	8b 40 04             	mov    0x4(%eax),%eax
    1b8a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1b91:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b94:	01 d0                	add    %edx,%eax
    1b96:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1b99:	75 20                	jne    1bbb <free+0xcf>
    p->s.size += bp->s.size;
    1b9b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b9e:	8b 50 04             	mov    0x4(%eax),%edx
    1ba1:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1ba4:	8b 40 04             	mov    0x4(%eax),%eax
    1ba7:	01 c2                	add    %eax,%edx
    1ba9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1bac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1baf:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1bb2:	8b 10                	mov    (%eax),%edx
    1bb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1bb7:	89 10                	mov    %edx,(%eax)
    1bb9:	eb 08                	jmp    1bc3 <free+0xd7>
  } else
    p->s.ptr = bp;
    1bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1bbe:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1bc1:	89 10                	mov    %edx,(%eax)
  freep = p;
    1bc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1bc6:	a3 94 25 00 00       	mov    %eax,0x2594
}
    1bcb:	c9                   	leave  
    1bcc:	c3                   	ret    

00001bcd <morecore>:

static Header*
morecore(uint nu)
{
    1bcd:	55                   	push   %ebp
    1bce:	89 e5                	mov    %esp,%ebp
    1bd0:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1bd3:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1bda:	77 07                	ja     1be3 <morecore+0x16>
    nu = 4096;
    1bdc:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1be3:	8b 45 08             	mov    0x8(%ebp),%eax
    1be6:	c1 e0 03             	shl    $0x3,%eax
    1be9:	89 04 24             	mov    %eax,(%esp)
    1bec:	e8 9f fb ff ff       	call   1790 <sbrk>
    1bf1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1bf4:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1bf8:	75 07                	jne    1c01 <morecore+0x34>
    return 0;
    1bfa:	b8 00 00 00 00       	mov    $0x0,%eax
    1bff:	eb 22                	jmp    1c23 <morecore+0x56>
  hp = (Header*)p;
    1c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1c07:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c0a:	8b 55 08             	mov    0x8(%ebp),%edx
    1c0d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1c10:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c13:	83 c0 08             	add    $0x8,%eax
    1c16:	89 04 24             	mov    %eax,(%esp)
    1c19:	e8 ce fe ff ff       	call   1aec <free>
  return freep;
    1c1e:	a1 94 25 00 00       	mov    0x2594,%eax
}
    1c23:	c9                   	leave  
    1c24:	c3                   	ret    

00001c25 <malloc>:

void*
malloc(uint nbytes)
{
    1c25:	55                   	push   %ebp
    1c26:	89 e5                	mov    %esp,%ebp
    1c28:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1c2b:	8b 45 08             	mov    0x8(%ebp),%eax
    1c2e:	83 c0 07             	add    $0x7,%eax
    1c31:	c1 e8 03             	shr    $0x3,%eax
    1c34:	40                   	inc    %eax
    1c35:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1c38:	a1 94 25 00 00       	mov    0x2594,%eax
    1c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1c40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1c44:	75 23                	jne    1c69 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1c46:	c7 45 f0 8c 25 00 00 	movl   $0x258c,-0x10(%ebp)
    1c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c50:	a3 94 25 00 00       	mov    %eax,0x2594
    1c55:	a1 94 25 00 00       	mov    0x2594,%eax
    1c5a:	a3 8c 25 00 00       	mov    %eax,0x258c
    base.s.size = 0;
    1c5f:	c7 05 90 25 00 00 00 	movl   $0x0,0x2590
    1c66:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c6c:	8b 00                	mov    (%eax),%eax
    1c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c74:	8b 40 04             	mov    0x4(%eax),%eax
    1c77:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1c7a:	72 4d                	jb     1cc9 <malloc+0xa4>
      if(p->s.size == nunits)
    1c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c7f:	8b 40 04             	mov    0x4(%eax),%eax
    1c82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1c85:	75 0c                	jne    1c93 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1c87:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c8a:	8b 10                	mov    (%eax),%edx
    1c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c8f:	89 10                	mov    %edx,(%eax)
    1c91:	eb 26                	jmp    1cb9 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1c93:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c96:	8b 40 04             	mov    0x4(%eax),%eax
    1c99:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1c9c:	89 c2                	mov    %eax,%edx
    1c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ca1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1ca7:	8b 40 04             	mov    0x4(%eax),%eax
    1caa:	c1 e0 03             	shl    $0x3,%eax
    1cad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1cb6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1cb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1cbc:	a3 94 25 00 00       	mov    %eax,0x2594
      return (void*)(p + 1);
    1cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cc4:	83 c0 08             	add    $0x8,%eax
    1cc7:	eb 38                	jmp    1d01 <malloc+0xdc>
    }
    if(p == freep)
    1cc9:	a1 94 25 00 00       	mov    0x2594,%eax
    1cce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1cd1:	75 1b                	jne    1cee <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1cd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1cd6:	89 04 24             	mov    %eax,(%esp)
    1cd9:	e8 ef fe ff ff       	call   1bcd <morecore>
    1cde:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1ce1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1ce5:	75 07                	jne    1cee <malloc+0xc9>
        return 0;
    1ce7:	b8 00 00 00 00       	mov    $0x0,%eax
    1cec:	eb 13                	jmp    1d01 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1cf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1cf7:	8b 00                	mov    (%eax),%eax
    1cf9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1cfc:	e9 70 ff ff ff       	jmp    1c71 <malloc+0x4c>
}
    1d01:	c9                   	leave  
    1d02:	c3                   	ret    
