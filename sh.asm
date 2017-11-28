
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
  if(strcmp(cmd, "mkdir") == 0 || strcmp(cmd, "ls") == 0){
       6:	c7 44 24 04 94 1c 00 	movl   $0x1c94,0x4(%esp)
       d:	00 
       e:	8b 45 08             	mov    0x8(%ebp),%eax
      11:	89 04 24             	mov    %eax,(%esp)
      14:	e8 22 10 00 00       	call   103b <strcmp>
      19:	85 c0                	test   %eax,%eax
      1b:	74 17                	je     34 <isfscmd+0x34>
      1d:	c7 44 24 04 9a 1c 00 	movl   $0x1c9a,0x4(%esp)
      24:	00 
      25:	8b 45 08             	mov    0x8(%ebp),%eax
      28:	89 04 24             	mov    %eax,(%esp)
      2b:	e8 0b 10 00 00       	call   103b <strcmp>
      30:	85 c0                	test   %eax,%eax
      32:	75 07                	jne    3b <isfscmd+0x3b>
    return 1;
      34:	b8 01 00 00 00       	mov    $0x1,%eax
      39:	eb 05                	jmp    40 <isfscmd+0x40>
  }return 0;
      3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
      40:	c9                   	leave  
      41:	c3                   	ret    

00000042 <ifsafepath>:

int
ifsafepath(char *path){
      42:	55                   	push   %ebp
      43:	89 e5                	mov    %esp,%ebp
      45:	81 ec 38 01 00 00    	sub    $0x138,%esp
  int path_len = 0;
      4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int new_path_len;
  char *tok_path = path;
      52:	8b 45 08             	mov    0x8(%ebp),%eax
      55:	89 45 ec             	mov    %eax,-0x14(%ebp)
  char currpath[256];
  int index = getactivefsindex();
      58:	e8 6b 17 00 00       	call   17c8 <getactivefsindex>
      5d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  getpath(index, currpath);
      60:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
      66:	89 44 24 04          	mov    %eax,0x4(%esp)
      6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 6b 17 00 00       	call   17e0 <getpath>
  char *tok_currpath = currpath;
      75:	8d 85 e4 fe ff ff    	lea    -0x11c(%ebp),%eax
      7b:	89 45 e8             	mov    %eax,-0x18(%ebp)

  while ((tok_currpath = strtok(tok_currpath, "/")) != 0){
      7e:	eb 0a                	jmp    8a <ifsafepath+0x48>
    path_len++;
      80:	ff 45 f4             	incl   -0xc(%ebp)
    tok_currpath = 0;
      83:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  char currpath[256];
  int index = getactivefsindex();
  getpath(index, currpath);
  char *tok_currpath = currpath;

  while ((tok_currpath = strtok(tok_currpath, "/")) != 0){
      8a:	c7 44 24 04 9d 1c 00 	movl   $0x1c9d,0x4(%esp)
      91:	00 
      92:	8b 45 e8             	mov    -0x18(%ebp),%eax
      95:	89 04 24             	mov    %eax,(%esp)
      98:	e8 ad 11 00 00       	call   124a <strtok>
      9d:	89 45 e8             	mov    %eax,-0x18(%ebp)
      a0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
      a4:	75 da                	jne    80 <ifsafepath+0x3e>
    path_len++;
    tok_currpath = 0;
  }

  if(path[0] != '/'){
      a6:	8b 45 08             	mov    0x8(%ebp),%eax
      a9:	8a 00                	mov    (%eax),%al
      ab:	3c 2f                	cmp    $0x2f,%al
      ad:	74 08                	je     b7 <ifsafepath+0x75>
    new_path_len = path_len;
      af:	8b 45 f4             	mov    -0xc(%ebp),%eax
      b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  }else{
    new_path_len = 0;
  }

  while ((tok_path = strtok(tok_path, "/")) != 0){
      b5:	eb 2f                	jmp    e6 <ifsafepath+0xa4>
  }

  if(path[0] != '/'){
    new_path_len = path_len;
  }else{
    new_path_len = 0;
      b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  }

  while ((tok_path = strtok(tok_path, "/")) != 0){
      be:	eb 26                	jmp    e6 <ifsafepath+0xa4>
    if(strcmp(tok_path, "..") == 0){
      c0:	c7 44 24 04 9f 1c 00 	movl   $0x1c9f,0x4(%esp)
      c7:	00 
      c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
      cb:	89 04 24             	mov    %eax,(%esp)
      ce:	e8 68 0f 00 00       	call   103b <strcmp>
      d3:	85 c0                	test   %eax,%eax
      d5:	75 05                	jne    dc <ifsafepath+0x9a>
      new_path_len--;
      d7:	ff 4d f0             	decl   -0x10(%ebp)
      da:	eb 03                	jmp    df <ifsafepath+0x9d>
    }else{
      new_path_len++;
      dc:	ff 45 f0             	incl   -0x10(%ebp)
    }
    tok_path = 0;
      df:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    new_path_len = path_len;
  }else{
    new_path_len = 0;
  }

  while ((tok_path = strtok(tok_path, "/")) != 0){
      e6:	c7 44 24 04 9d 1c 00 	movl   $0x1c9d,0x4(%esp)
      ed:	00 
      ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
      f1:	89 04 24             	mov    %eax,(%esp)
      f4:	e8 51 11 00 00       	call   124a <strtok>
      f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
      fc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     100:	75 be                	jne    c0 <ifsafepath+0x7e>
      new_path_len++;
    }
    tok_path = 0;
  }

  return new_path_len > 0;
     102:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     106:	0f 9f c0             	setg   %al
     109:	0f b6 c0             	movzbl %al,%eax

}
     10c:	c9                   	leave  
     10d:	c3                   	ret    

0000010e <runcmd>:

// Execute cmd.  Never returns.
void
runcmd(struct cmd *cmd)
{
     10e:	55                   	push   %ebp
     10f:	89 e5                	mov    %esp,%ebp
     111:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     114:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     118:	75 05                	jne    11f <runcmd+0x11>
    exit();
     11a:	e8 79 15 00 00       	call   1698 <exit>

  switch(cmd->type){
     11f:	8b 45 08             	mov    0x8(%ebp),%eax
     122:	8b 00                	mov    (%eax),%eax
     124:	83 f8 05             	cmp    $0x5,%eax
     127:	77 09                	ja     132 <runcmd+0x24>
     129:	8b 04 85 fc 1c 00 00 	mov    0x1cfc(,%eax,4),%eax
     130:	ff e0                	jmp    *%eax
  default:
    panic("runcmd");
     132:	c7 04 24 a2 1c 00 00 	movl   $0x1ca2,(%esp)
     139:	e8 1a 04 00 00       	call   558 <panic>

  case EXEC:
    ecmd = (struct execcmd*)cmd;
     13e:	8b 45 08             	mov    0x8(%ebp),%eax
     141:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ecmd->argv[0] == 0)
     144:	8b 45 f4             	mov    -0xc(%ebp),%eax
     147:	8b 40 04             	mov    0x4(%eax),%eax
     14a:	85 c0                	test   %eax,%eax
     14c:	75 05                	jne    153 <runcmd+0x45>
      exit();
     14e:	e8 45 15 00 00       	call   1698 <exit>

    if(isfscmd(ecmd->argv[0]) && !ifsafepath(ecmd->argv[1])){
     153:	8b 45 f4             	mov    -0xc(%ebp),%eax
     156:	8b 40 04             	mov    0x4(%eax),%eax
     159:	89 04 24             	mov    %eax,(%esp)
     15c:	e8 9f fe ff ff       	call   0 <isfscmd>
     161:	85 c0                	test   %eax,%eax
     163:	74 35                	je     19a <runcmd+0x8c>
     165:	8b 45 f4             	mov    -0xc(%ebp),%eax
     168:	8b 40 08             	mov    0x8(%eax),%eax
     16b:	89 04 24             	mov    %eax,(%esp)
     16e:	e8 cf fe ff ff       	call   42 <ifsafepath>
     173:	85 c0                	test   %eax,%eax
     175:	75 23                	jne    19a <runcmd+0x8c>
      printf(2, "You dont have permission to go here! \"%s\"\n", ecmd->argv[1]);
     177:	8b 45 f4             	mov    -0xc(%ebp),%eax
     17a:	8b 40 08             	mov    0x8(%eax),%eax
     17d:	89 44 24 08          	mov    %eax,0x8(%esp)
     181:	c7 44 24 04 ac 1c 00 	movl   $0x1cac,0x4(%esp)
     188:	00 
     189:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     190:	e8 38 17 00 00       	call   18cd <printf>
      break;
     195:	e9 c1 01 00 00       	jmp    35b <runcmd+0x24d>
    }
    exec(ecmd->argv[0], ecmd->argv);
     19a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     19d:	8d 50 04             	lea    0x4(%eax),%edx
     1a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1a3:	8b 40 04             	mov    0x4(%eax),%eax
     1a6:	89 54 24 04          	mov    %edx,0x4(%esp)
     1aa:	89 04 24             	mov    %eax,(%esp)
     1ad:	e8 1e 15 00 00       	call   16d0 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     1b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1b5:	8b 40 04             	mov    0x4(%eax),%eax
     1b8:	89 44 24 08          	mov    %eax,0x8(%esp)
     1bc:	c7 44 24 04 d7 1c 00 	movl   $0x1cd7,0x4(%esp)
     1c3:	00 
     1c4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     1cb:	e8 fd 16 00 00       	call   18cd <printf>
    break;
     1d0:	e9 86 01 00 00       	jmp    35b <runcmd+0x24d>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     1d5:	8b 45 08             	mov    0x8(%ebp),%eax
     1d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    close(rcmd->fd);
     1db:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1de:	8b 40 14             	mov    0x14(%eax),%eax
     1e1:	89 04 24             	mov    %eax,(%esp)
     1e4:	e8 d7 14 00 00       	call   16c0 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     1e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1ec:	8b 50 10             	mov    0x10(%eax),%edx
     1ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
     1f2:	8b 40 08             	mov    0x8(%eax),%eax
     1f5:	89 54 24 04          	mov    %edx,0x4(%esp)
     1f9:	89 04 24             	mov    %eax,(%esp)
     1fc:	e8 d7 14 00 00       	call   16d8 <open>
     201:	85 c0                	test   %eax,%eax
     203:	79 23                	jns    228 <runcmd+0x11a>
      printf(2, "open %s failed\n", rcmd->file);
     205:	8b 45 f0             	mov    -0x10(%ebp),%eax
     208:	8b 40 08             	mov    0x8(%eax),%eax
     20b:	89 44 24 08          	mov    %eax,0x8(%esp)
     20f:	c7 44 24 04 e7 1c 00 	movl   $0x1ce7,0x4(%esp)
     216:	00 
     217:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     21e:	e8 aa 16 00 00       	call   18cd <printf>
      exit();
     223:	e8 70 14 00 00       	call   1698 <exit>
    }
    runcmd(rcmd->cmd);
     228:	8b 45 f0             	mov    -0x10(%ebp),%eax
     22b:	8b 40 04             	mov    0x4(%eax),%eax
     22e:	89 04 24             	mov    %eax,(%esp)
     231:	e8 d8 fe ff ff       	call   10e <runcmd>
    break;
     236:	e9 20 01 00 00       	jmp    35b <runcmd+0x24d>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     23b:	8b 45 08             	mov    0x8(%ebp),%eax
     23e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(fork1() == 0)
     241:	e8 38 03 00 00       	call   57e <fork1>
     246:	85 c0                	test   %eax,%eax
     248:	75 0e                	jne    258 <runcmd+0x14a>
      runcmd(lcmd->left);
     24a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     24d:	8b 40 04             	mov    0x4(%eax),%eax
     250:	89 04 24             	mov    %eax,(%esp)
     253:	e8 b6 fe ff ff       	call   10e <runcmd>
    wait();
     258:	e8 43 14 00 00       	call   16a0 <wait>
    runcmd(lcmd->right);
     25d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     260:	8b 40 08             	mov    0x8(%eax),%eax
     263:	89 04 24             	mov    %eax,(%esp)
     266:	e8 a3 fe ff ff       	call   10e <runcmd>
    break;
     26b:	e9 eb 00 00 00       	jmp    35b <runcmd+0x24d>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     270:	8b 45 08             	mov    0x8(%ebp),%eax
     273:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pipe(p) < 0)
     276:	8d 45 dc             	lea    -0x24(%ebp),%eax
     279:	89 04 24             	mov    %eax,(%esp)
     27c:	e8 27 14 00 00       	call   16a8 <pipe>
     281:	85 c0                	test   %eax,%eax
     283:	79 0c                	jns    291 <runcmd+0x183>
      panic("pipe");
     285:	c7 04 24 f7 1c 00 00 	movl   $0x1cf7,(%esp)
     28c:	e8 c7 02 00 00       	call   558 <panic>
    if(fork1() == 0){
     291:	e8 e8 02 00 00       	call   57e <fork1>
     296:	85 c0                	test   %eax,%eax
     298:	75 3b                	jne    2d5 <runcmd+0x1c7>
      close(1);
     29a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2a1:	e8 1a 14 00 00       	call   16c0 <close>
      dup(p[1]);
     2a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
     2a9:	89 04 24             	mov    %eax,(%esp)
     2ac:	e8 5f 14 00 00       	call   1710 <dup>
      close(p[0]);
     2b1:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2b4:	89 04 24             	mov    %eax,(%esp)
     2b7:	e8 04 14 00 00       	call   16c0 <close>
      close(p[1]);
     2bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
     2bf:	89 04 24             	mov    %eax,(%esp)
     2c2:	e8 f9 13 00 00       	call   16c0 <close>
      runcmd(pcmd->left);
     2c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
     2ca:	8b 40 04             	mov    0x4(%eax),%eax
     2cd:	89 04 24             	mov    %eax,(%esp)
     2d0:	e8 39 fe ff ff       	call   10e <runcmd>
    }
    if(fork1() == 0){
     2d5:	e8 a4 02 00 00       	call   57e <fork1>
     2da:	85 c0                	test   %eax,%eax
     2dc:	75 3b                	jne    319 <runcmd+0x20b>
      close(0);
     2de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     2e5:	e8 d6 13 00 00       	call   16c0 <close>
      dup(p[0]);
     2ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2ed:	89 04 24             	mov    %eax,(%esp)
     2f0:	e8 1b 14 00 00       	call   1710 <dup>
      close(p[0]);
     2f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
     2f8:	89 04 24             	mov    %eax,(%esp)
     2fb:	e8 c0 13 00 00       	call   16c0 <close>
      close(p[1]);
     300:	8b 45 e0             	mov    -0x20(%ebp),%eax
     303:	89 04 24             	mov    %eax,(%esp)
     306:	e8 b5 13 00 00       	call   16c0 <close>
      runcmd(pcmd->right);
     30b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     30e:	8b 40 08             	mov    0x8(%eax),%eax
     311:	89 04 24             	mov    %eax,(%esp)
     314:	e8 f5 fd ff ff       	call   10e <runcmd>
    }
    close(p[0]);
     319:	8b 45 dc             	mov    -0x24(%ebp),%eax
     31c:	89 04 24             	mov    %eax,(%esp)
     31f:	e8 9c 13 00 00       	call   16c0 <close>
    close(p[1]);
     324:	8b 45 e0             	mov    -0x20(%ebp),%eax
     327:	89 04 24             	mov    %eax,(%esp)
     32a:	e8 91 13 00 00       	call   16c0 <close>
    wait();
     32f:	e8 6c 13 00 00       	call   16a0 <wait>
    wait();
     334:	e8 67 13 00 00       	call   16a0 <wait>
    break;
     339:	eb 20                	jmp    35b <runcmd+0x24d>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     33b:	8b 45 08             	mov    0x8(%ebp),%eax
     33e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(fork1() == 0)
     341:	e8 38 02 00 00       	call   57e <fork1>
     346:	85 c0                	test   %eax,%eax
     348:	75 10                	jne    35a <runcmd+0x24c>
      runcmd(bcmd->cmd);
     34a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     34d:	8b 40 04             	mov    0x4(%eax),%eax
     350:	89 04 24             	mov    %eax,(%esp)
     353:	e8 b6 fd ff ff       	call   10e <runcmd>
    break;
     358:	eb 00                	jmp    35a <runcmd+0x24c>
     35a:	90                   	nop
  }
  exit();
     35b:	e8 38 13 00 00       	call   1698 <exit>

00000360 <getcmd>:
}

int
getcmd(char *buf, int nbuf)
{
     360:	55                   	push   %ebp
     361:	89 e5                	mov    %esp,%ebp
     363:	83 ec 18             	sub    $0x18,%esp
  printf(2, "$ ");
     366:	c7 44 24 04 14 1d 00 	movl   $0x1d14,0x4(%esp)
     36d:	00 
     36e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     375:	e8 53 15 00 00       	call   18cd <printf>
  memset(buf, 0, nbuf);
     37a:	8b 45 0c             	mov    0xc(%ebp),%eax
     37d:	89 44 24 08          	mov    %eax,0x8(%esp)
     381:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     388:	00 
     389:	8b 45 08             	mov    0x8(%ebp),%eax
     38c:	89 04 24             	mov    %eax,(%esp)
     38f:	e8 52 0d 00 00       	call   10e6 <memset>
  gets(buf, nbuf);
     394:	8b 45 0c             	mov    0xc(%ebp),%eax
     397:	89 44 24 04          	mov    %eax,0x4(%esp)
     39b:	8b 45 08             	mov    0x8(%ebp),%eax
     39e:	89 04 24             	mov    %eax,(%esp)
     3a1:	e8 a2 11 00 00       	call   1548 <gets>
  if(buf[0] == 0) // EOF
     3a6:	8b 45 08             	mov    0x8(%ebp),%eax
     3a9:	8a 00                	mov    (%eax),%al
     3ab:	84 c0                	test   %al,%al
     3ad:	75 07                	jne    3b6 <getcmd+0x56>
    return -1;
     3af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     3b4:	eb 05                	jmp    3bb <getcmd+0x5b>
  return 0;
     3b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
     3bb:	c9                   	leave  
     3bc:	c3                   	ret    

000003bd <main>:

int
main(void)
{
     3bd:	55                   	push   %ebp
     3be:	89 e5                	mov    %esp,%ebp
     3c0:	83 e4 f0             	and    $0xfffffff0,%esp
     3c3:	83 ec 40             	sub    $0x40,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     3c6:	eb 15                	jmp    3dd <main+0x20>
    if(fd >= 3){
     3c8:	83 7c 24 3c 02       	cmpl   $0x2,0x3c(%esp)
     3cd:	7e 0e                	jle    3dd <main+0x20>
      close(fd);
     3cf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
     3d3:	89 04 24             	mov    %eax,(%esp)
     3d6:	e8 e5 12 00 00       	call   16c0 <close>
      break;
     3db:	eb 1f                	jmp    3fc <main+0x3f>
{
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
     3dd:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     3e4:	00 
     3e5:	c7 04 24 17 1d 00 00 	movl   $0x1d17,(%esp)
     3ec:	e8 e7 12 00 00       	call   16d8 <open>
     3f1:	89 44 24 3c          	mov    %eax,0x3c(%esp)
     3f5:	83 7c 24 3c 00       	cmpl   $0x0,0x3c(%esp)
     3fa:	79 cc                	jns    3c8 <main+0xb>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     3fc:	e9 36 01 00 00       	jmp    537 <main+0x17a>
    char fs[32];
    int index = getactivefsindex();
     401:	e8 c2 13 00 00       	call   17c8 <getactivefsindex>
     406:	89 44 24 38          	mov    %eax,0x38(%esp)
    getactivefs(fs);
     40a:	8d 44 24 18          	lea    0x18(%esp),%eax
     40e:	89 04 24             	mov    %eax,(%esp)
     411:	e8 92 13 00 00       	call   17a8 <getactivefs>
    if((strcmp(buf, "/\n") == 0) || (buf[0] == 'c' && buf[1] == 'd' && buf[2] == 10) || ((strcmp("cd ..\n", buf) == 0) && getatroot(index))){
     416:	c7 44 24 04 1f 1d 00 	movl   $0x1d1f,0x4(%esp)
     41d:	00 
     41e:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     425:	e8 11 0c 00 00       	call   103b <strcmp>
     42a:	85 c0                	test   %eax,%eax
     42c:	74 43                	je     471 <main+0xb4>
     42e:	a0 a0 24 00 00       	mov    0x24a0,%al
     433:	3c 63                	cmp    $0x63,%al
     435:	75 12                	jne    449 <main+0x8c>
     437:	a0 a1 24 00 00       	mov    0x24a1,%al
     43c:	3c 64                	cmp    $0x64,%al
     43e:	75 09                	jne    449 <main+0x8c>
     440:	a0 a2 24 00 00       	mov    0x24a2,%al
     445:	3c 0a                	cmp    $0xa,%al
     447:	74 28                	je     471 <main+0xb4>
     449:	c7 44 24 04 a0 24 00 	movl   $0x24a0,0x4(%esp)
     450:	00 
     451:	c7 04 24 22 1d 00 00 	movl   $0x1d22,(%esp)
     458:	e8 de 0b 00 00       	call   103b <strcmp>
     45d:	85 c0                	test   %eax,%eax
     45f:	75 55                	jne    4b6 <main+0xf9>
     461:	8b 44 24 38          	mov    0x38(%esp),%eax
     465:	89 04 24             	mov    %eax,(%esp)
     468:	e8 6b 13 00 00       	call   17d8 <getatroot>
     46d:	85 c0                	test   %eax,%eax
     46f:	74 45                	je     4b6 <main+0xf9>
      if(chdir(fs) < 0)
     471:	8d 44 24 18          	lea    0x18(%esp),%eax
     475:	89 04 24             	mov    %eax,(%esp)
     478:	e8 8b 12 00 00       	call   1708 <chdir>
     47d:	85 c0                	test   %eax,%eax
     47f:	79 1c                	jns    49d <main+0xe0>
        printf(2, "cannot cd %s\n", fs);
     481:	8d 44 24 18          	lea    0x18(%esp),%eax
     485:	89 44 24 08          	mov    %eax,0x8(%esp)
     489:	c7 44 24 04 29 1d 00 	movl   $0x1d29,0x4(%esp)
     490:	00 
     491:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     498:	e8 30 14 00 00       	call   18cd <printf>
      setatroot(index, 1);
     49d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
     4a4:	00 
     4a5:	8b 44 24 38          	mov    0x38(%esp),%eax
     4a9:	89 04 24             	mov    %eax,(%esp)
     4ac:	e8 1f 13 00 00       	call   17d0 <setatroot>
      continue;
     4b1:	e9 81 00 00 00       	jmp    537 <main+0x17a>
    }
    else if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     4b6:	a0 a0 24 00 00       	mov    0x24a0,%al
     4bb:	3c 63                	cmp    $0x63,%al
     4bd:	75 56                	jne    515 <main+0x158>
     4bf:	a0 a1 24 00 00       	mov    0x24a1,%al
     4c4:	3c 64                	cmp    $0x64,%al
     4c6:	75 4d                	jne    515 <main+0x158>
     4c8:	a0 a2 24 00 00       	mov    0x24a2,%al
     4cd:	3c 20                	cmp    $0x20,%al
     4cf:	75 44                	jne    515 <main+0x158>

      // Chdir must be called by the parent, not the child.
      buf[strlen(buf)-1] = 0;  // chop \n
     4d1:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     4d8:	e8 e4 0b 00 00       	call   10c1 <strlen>
     4dd:	48                   	dec    %eax
     4de:	c6 80 a0 24 00 00 00 	movb   $0x0,0x24a0(%eax)

      if(chdir(buf+3) < 0)
     4e5:	c7 04 24 a3 24 00 00 	movl   $0x24a3,(%esp)
     4ec:	e8 17 12 00 00       	call   1708 <chdir>
     4f1:	85 c0                	test   %eax,%eax
     4f3:	79 1e                	jns    513 <main+0x156>
        printf(2, "cannot cd %s\n", buf+3);
     4f5:	c7 44 24 08 a3 24 00 	movl   $0x24a3,0x8(%esp)
     4fc:	00 
     4fd:	c7 44 24 04 29 1d 00 	movl   $0x1d29,0x4(%esp)
     504:	00 
     505:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     50c:	e8 bc 13 00 00       	call   18cd <printf>
        continue;
     511:	eb 24                	jmp    537 <main+0x17a>
     513:	eb 22                	jmp    537 <main+0x17a>
      setatroot(index, 0);
      continue;
    }
    if(fork1() == 0)
     515:	e8 64 00 00 00       	call   57e <fork1>
     51a:	85 c0                	test   %eax,%eax
     51c:	75 14                	jne    532 <main+0x175>
      runcmd(parsecmd(buf));
     51e:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     525:	e8 b8 03 00 00       	call   8e2 <parsecmd>
     52a:	89 04 24             	mov    %eax,(%esp)
     52d:	e8 dc fb ff ff       	call   10e <runcmd>
    wait();
     532:	e8 69 11 00 00       	call   16a0 <wait>
    }
  }


  // Read and run input commands.
  while(getcmd(buf, sizeof(buf)) >= 0){
     537:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
     53e:	00 
     53f:	c7 04 24 a0 24 00 00 	movl   $0x24a0,(%esp)
     546:	e8 15 fe ff ff       	call   360 <getcmd>
     54b:	85 c0                	test   %eax,%eax
     54d:	0f 89 ae fe ff ff    	jns    401 <main+0x44>
    }
    if(fork1() == 0)
      runcmd(parsecmd(buf));
    wait();
  }
  exit();
     553:	e8 40 11 00 00       	call   1698 <exit>

00000558 <panic>:
}

void
panic(char *s)
{
     558:	55                   	push   %ebp
     559:	89 e5                	mov    %esp,%ebp
     55b:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     55e:	8b 45 08             	mov    0x8(%ebp),%eax
     561:	89 44 24 08          	mov    %eax,0x8(%esp)
     565:	c7 44 24 04 37 1d 00 	movl   $0x1d37,0x4(%esp)
     56c:	00 
     56d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     574:	e8 54 13 00 00       	call   18cd <printf>
  exit();
     579:	e8 1a 11 00 00       	call   1698 <exit>

0000057e <fork1>:
}

int
fork1(void)
{
     57e:	55                   	push   %ebp
     57f:	89 e5                	mov    %esp,%ebp
     581:	83 ec 28             	sub    $0x28,%esp
  int pid;

  pid = fork();
     584:	e8 07 11 00 00       	call   1690 <fork>
     589:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pid == -1)
     58c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
     590:	75 0c                	jne    59e <fork1+0x20>
    panic("fork");
     592:	c7 04 24 3b 1d 00 00 	movl   $0x1d3b,(%esp)
     599:	e8 ba ff ff ff       	call   558 <panic>
  return pid;
     59e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5a1:	c9                   	leave  
     5a2:	c3                   	ret    

000005a3 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     5a3:	55                   	push   %ebp
     5a4:	89 e5                	mov    %esp,%ebp
     5a6:	83 ec 28             	sub    $0x28,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5a9:	c7 04 24 a4 00 00 00 	movl   $0xa4,(%esp)
     5b0:	e8 00 16 00 00       	call   1bb5 <malloc>
     5b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     5b8:	c7 44 24 08 a4 00 00 	movl   $0xa4,0x8(%esp)
     5bf:	00 
     5c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     5c7:	00 
     5c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5cb:	89 04 24             	mov    %eax,(%esp)
     5ce:	e8 13 0b 00 00       	call   10e6 <memset>
  cmd->type = EXEC;
     5d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5d6:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  return (struct cmd*)cmd;
     5dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     5df:	c9                   	leave  
     5e0:	c3                   	ret    

000005e1 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     5e1:	55                   	push   %ebp
     5e2:	89 e5                	mov    %esp,%ebp
     5e4:	83 ec 28             	sub    $0x28,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5e7:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     5ee:	e8 c2 15 00 00       	call   1bb5 <malloc>
     5f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     5f6:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
     5fd:	00 
     5fe:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     605:	00 
     606:	8b 45 f4             	mov    -0xc(%ebp),%eax
     609:	89 04 24             	mov    %eax,(%esp)
     60c:	e8 d5 0a 00 00       	call   10e6 <memset>
  cmd->type = REDIR;
     611:	8b 45 f4             	mov    -0xc(%ebp),%eax
     614:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  cmd->cmd = subcmd;
     61a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     61d:	8b 55 08             	mov    0x8(%ebp),%edx
     620:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->file = file;
     623:	8b 45 f4             	mov    -0xc(%ebp),%eax
     626:	8b 55 0c             	mov    0xc(%ebp),%edx
     629:	89 50 08             	mov    %edx,0x8(%eax)
  cmd->efile = efile;
     62c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     62f:	8b 55 10             	mov    0x10(%ebp),%edx
     632:	89 50 0c             	mov    %edx,0xc(%eax)
  cmd->mode = mode;
     635:	8b 45 f4             	mov    -0xc(%ebp),%eax
     638:	8b 55 14             	mov    0x14(%ebp),%edx
     63b:	89 50 10             	mov    %edx,0x10(%eax)
  cmd->fd = fd;
     63e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     641:	8b 55 18             	mov    0x18(%ebp),%edx
     644:	89 50 14             	mov    %edx,0x14(%eax)
  return (struct cmd*)cmd;
     647:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     64a:	c9                   	leave  
     64b:	c3                   	ret    

0000064c <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     64c:	55                   	push   %ebp
     64d:	89 e5                	mov    %esp,%ebp
     64f:	83 ec 28             	sub    $0x28,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     652:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     659:	e8 57 15 00 00       	call   1bb5 <malloc>
     65e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     661:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     668:	00 
     669:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     670:	00 
     671:	8b 45 f4             	mov    -0xc(%ebp),%eax
     674:	89 04 24             	mov    %eax,(%esp)
     677:	e8 6a 0a 00 00       	call   10e6 <memset>
  cmd->type = PIPE;
     67c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     67f:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
  cmd->left = left;
     685:	8b 45 f4             	mov    -0xc(%ebp),%eax
     688:	8b 55 08             	mov    0x8(%ebp),%edx
     68b:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     68e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     691:	8b 55 0c             	mov    0xc(%ebp),%edx
     694:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     697:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     69a:	c9                   	leave  
     69b:	c3                   	ret    

0000069c <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     69c:	55                   	push   %ebp
     69d:	89 e5                	mov    %esp,%ebp
     69f:	83 ec 28             	sub    $0x28,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6a2:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     6a9:	e8 07 15 00 00       	call   1bb5 <malloc>
     6ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     6b1:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
     6b8:	00 
     6b9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     6c0:	00 
     6c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6c4:	89 04 24             	mov    %eax,(%esp)
     6c7:	e8 1a 0a 00 00       	call   10e6 <memset>
  cmd->type = LIST;
     6cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6cf:	c7 00 04 00 00 00    	movl   $0x4,(%eax)
  cmd->left = left;
     6d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6d8:	8b 55 08             	mov    0x8(%ebp),%edx
     6db:	89 50 04             	mov    %edx,0x4(%eax)
  cmd->right = right;
     6de:	8b 45 f4             	mov    -0xc(%ebp),%eax
     6e1:	8b 55 0c             	mov    0xc(%ebp),%edx
     6e4:	89 50 08             	mov    %edx,0x8(%eax)
  return (struct cmd*)cmd;
     6e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     6ea:	c9                   	leave  
     6eb:	c3                   	ret    

000006ec <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     6ec:	55                   	push   %ebp
     6ed:	89 e5                	mov    %esp,%ebp
     6ef:	83 ec 28             	sub    $0x28,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     6f2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     6f9:	e8 b7 14 00 00       	call   1bb5 <malloc>
     6fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(cmd, 0, sizeof(*cmd));
     701:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
     708:	00 
     709:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     710:	00 
     711:	8b 45 f4             	mov    -0xc(%ebp),%eax
     714:	89 04 24             	mov    %eax,(%esp)
     717:	e8 ca 09 00 00       	call   10e6 <memset>
  cmd->type = BACK;
     71c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     71f:	c7 00 05 00 00 00    	movl   $0x5,(%eax)
  cmd->cmd = subcmd;
     725:	8b 45 f4             	mov    -0xc(%ebp),%eax
     728:	8b 55 08             	mov    0x8(%ebp),%edx
     72b:	89 50 04             	mov    %edx,0x4(%eax)
  return (struct cmd*)cmd;
     72e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     731:	c9                   	leave  
     732:	c3                   	ret    

00000733 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     733:	55                   	push   %ebp
     734:	89 e5                	mov    %esp,%ebp
     736:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int ret;

  s = *ps;
     739:	8b 45 08             	mov    0x8(%ebp),%eax
     73c:	8b 00                	mov    (%eax),%eax
     73e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     741:	eb 03                	jmp    746 <gettoken+0x13>
    s++;
     743:	ff 45 f4             	incl   -0xc(%ebp)
{
  char *s;
  int ret;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     746:	8b 45 f4             	mov    -0xc(%ebp),%eax
     749:	3b 45 0c             	cmp    0xc(%ebp),%eax
     74c:	73 1c                	jae    76a <gettoken+0x37>
     74e:	8b 45 f4             	mov    -0xc(%ebp),%eax
     751:	8a 00                	mov    (%eax),%al
     753:	0f be c0             	movsbl %al,%eax
     756:	89 44 24 04          	mov    %eax,0x4(%esp)
     75a:	c7 04 24 20 24 00 00 	movl   $0x2420,(%esp)
     761:	e8 a4 09 00 00       	call   110a <strchr>
     766:	85 c0                	test   %eax,%eax
     768:	75 d9                	jne    743 <gettoken+0x10>
    s++;
  if(q)
     76a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     76e:	74 08                	je     778 <gettoken+0x45>
    *q = s;
     770:	8b 45 10             	mov    0x10(%ebp),%eax
     773:	8b 55 f4             	mov    -0xc(%ebp),%edx
     776:	89 10                	mov    %edx,(%eax)
  ret = *s;
     778:	8b 45 f4             	mov    -0xc(%ebp),%eax
     77b:	8a 00                	mov    (%eax),%al
     77d:	0f be c0             	movsbl %al,%eax
     780:	89 45 f0             	mov    %eax,-0x10(%ebp)
  switch(*s){
     783:	8b 45 f4             	mov    -0xc(%ebp),%eax
     786:	8a 00                	mov    (%eax),%al
     788:	0f be c0             	movsbl %al,%eax
     78b:	83 f8 29             	cmp    $0x29,%eax
     78e:	7f 14                	jg     7a4 <gettoken+0x71>
     790:	83 f8 28             	cmp    $0x28,%eax
     793:	7d 28                	jge    7bd <gettoken+0x8a>
     795:	85 c0                	test   %eax,%eax
     797:	0f 84 8d 00 00 00    	je     82a <gettoken+0xf7>
     79d:	83 f8 26             	cmp    $0x26,%eax
     7a0:	74 1b                	je     7bd <gettoken+0x8a>
     7a2:	eb 38                	jmp    7dc <gettoken+0xa9>
     7a4:	83 f8 3e             	cmp    $0x3e,%eax
     7a7:	74 19                	je     7c2 <gettoken+0x8f>
     7a9:	83 f8 3e             	cmp    $0x3e,%eax
     7ac:	7f 0a                	jg     7b8 <gettoken+0x85>
     7ae:	83 e8 3b             	sub    $0x3b,%eax
     7b1:	83 f8 01             	cmp    $0x1,%eax
     7b4:	77 26                	ja     7dc <gettoken+0xa9>
     7b6:	eb 05                	jmp    7bd <gettoken+0x8a>
     7b8:	83 f8 7c             	cmp    $0x7c,%eax
     7bb:	75 1f                	jne    7dc <gettoken+0xa9>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     7bd:	ff 45 f4             	incl   -0xc(%ebp)
    break;
     7c0:	eb 69                	jmp    82b <gettoken+0xf8>
  case '>':
    s++;
     7c2:	ff 45 f4             	incl   -0xc(%ebp)
    if(*s == '>'){
     7c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7c8:	8a 00                	mov    (%eax),%al
     7ca:	3c 3e                	cmp    $0x3e,%al
     7cc:	75 0c                	jne    7da <gettoken+0xa7>
      ret = '+';
     7ce:	c7 45 f0 2b 00 00 00 	movl   $0x2b,-0x10(%ebp)
      s++;
     7d5:	ff 45 f4             	incl   -0xc(%ebp)
    }
    break;
     7d8:	eb 51                	jmp    82b <gettoken+0xf8>
     7da:	eb 4f                	jmp    82b <gettoken+0xf8>
  default:
    ret = 'a';
     7dc:	c7 45 f0 61 00 00 00 	movl   $0x61,-0x10(%ebp)
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     7e3:	eb 03                	jmp    7e8 <gettoken+0xb5>
      s++;
     7e5:	ff 45 f4             	incl   -0xc(%ebp)
      s++;
    }
    break;
  default:
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     7e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
     7ee:	73 38                	jae    828 <gettoken+0xf5>
     7f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     7f3:	8a 00                	mov    (%eax),%al
     7f5:	0f be c0             	movsbl %al,%eax
     7f8:	89 44 24 04          	mov    %eax,0x4(%esp)
     7fc:	c7 04 24 20 24 00 00 	movl   $0x2420,(%esp)
     803:	e8 02 09 00 00       	call   110a <strchr>
     808:	85 c0                	test   %eax,%eax
     80a:	75 1c                	jne    828 <gettoken+0xf5>
     80c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     80f:	8a 00                	mov    (%eax),%al
     811:	0f be c0             	movsbl %al,%eax
     814:	89 44 24 04          	mov    %eax,0x4(%esp)
     818:	c7 04 24 26 24 00 00 	movl   $0x2426,(%esp)
     81f:	e8 e6 08 00 00       	call   110a <strchr>
     824:	85 c0                	test   %eax,%eax
     826:	74 bd                	je     7e5 <gettoken+0xb2>
      s++;
    break;
     828:	eb 01                	jmp    82b <gettoken+0xf8>
  if(q)
    *q = s;
  ret = *s;
  switch(*s){
  case 0:
    break;
     82a:	90                   	nop
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     82b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     82f:	74 0a                	je     83b <gettoken+0x108>
    *eq = s;
     831:	8b 45 14             	mov    0x14(%ebp),%eax
     834:	8b 55 f4             	mov    -0xc(%ebp),%edx
     837:	89 10                	mov    %edx,(%eax)

  while(s < es && strchr(whitespace, *s))
     839:	eb 05                	jmp    840 <gettoken+0x10d>
     83b:	eb 03                	jmp    840 <gettoken+0x10d>
    s++;
     83d:	ff 45 f4             	incl   -0xc(%ebp)
    break;
  }
  if(eq)
    *eq = s;

  while(s < es && strchr(whitespace, *s))
     840:	8b 45 f4             	mov    -0xc(%ebp),%eax
     843:	3b 45 0c             	cmp    0xc(%ebp),%eax
     846:	73 1c                	jae    864 <gettoken+0x131>
     848:	8b 45 f4             	mov    -0xc(%ebp),%eax
     84b:	8a 00                	mov    (%eax),%al
     84d:	0f be c0             	movsbl %al,%eax
     850:	89 44 24 04          	mov    %eax,0x4(%esp)
     854:	c7 04 24 20 24 00 00 	movl   $0x2420,(%esp)
     85b:	e8 aa 08 00 00       	call   110a <strchr>
     860:	85 c0                	test   %eax,%eax
     862:	75 d9                	jne    83d <gettoken+0x10a>
    s++;
  *ps = s;
     864:	8b 45 08             	mov    0x8(%ebp),%eax
     867:	8b 55 f4             	mov    -0xc(%ebp),%edx
     86a:	89 10                	mov    %edx,(%eax)
  return ret;
     86c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     86f:	c9                   	leave  
     870:	c3                   	ret    

00000871 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     871:	55                   	push   %ebp
     872:	89 e5                	mov    %esp,%ebp
     874:	83 ec 28             	sub    $0x28,%esp
  char *s;

  s = *ps;
     877:	8b 45 08             	mov    0x8(%ebp),%eax
     87a:	8b 00                	mov    (%eax),%eax
     87c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(s < es && strchr(whitespace, *s))
     87f:	eb 03                	jmp    884 <peek+0x13>
    s++;
     881:	ff 45 f4             	incl   -0xc(%ebp)
peek(char **ps, char *es, char *toks)
{
  char *s;

  s = *ps;
  while(s < es && strchr(whitespace, *s))
     884:	8b 45 f4             	mov    -0xc(%ebp),%eax
     887:	3b 45 0c             	cmp    0xc(%ebp),%eax
     88a:	73 1c                	jae    8a8 <peek+0x37>
     88c:	8b 45 f4             	mov    -0xc(%ebp),%eax
     88f:	8a 00                	mov    (%eax),%al
     891:	0f be c0             	movsbl %al,%eax
     894:	89 44 24 04          	mov    %eax,0x4(%esp)
     898:	c7 04 24 20 24 00 00 	movl   $0x2420,(%esp)
     89f:	e8 66 08 00 00       	call   110a <strchr>
     8a4:	85 c0                	test   %eax,%eax
     8a6:	75 d9                	jne    881 <peek+0x10>
    s++;
  *ps = s;
     8a8:	8b 45 08             	mov    0x8(%ebp),%eax
     8ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8ae:	89 10                	mov    %edx,(%eax)
  return *s && strchr(toks, *s);
     8b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8b3:	8a 00                	mov    (%eax),%al
     8b5:	84 c0                	test   %al,%al
     8b7:	74 22                	je     8db <peek+0x6a>
     8b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8bc:	8a 00                	mov    (%eax),%al
     8be:	0f be c0             	movsbl %al,%eax
     8c1:	89 44 24 04          	mov    %eax,0x4(%esp)
     8c5:	8b 45 10             	mov    0x10(%ebp),%eax
     8c8:	89 04 24             	mov    %eax,(%esp)
     8cb:	e8 3a 08 00 00       	call   110a <strchr>
     8d0:	85 c0                	test   %eax,%eax
     8d2:	74 07                	je     8db <peek+0x6a>
     8d4:	b8 01 00 00 00       	mov    $0x1,%eax
     8d9:	eb 05                	jmp    8e0 <peek+0x6f>
     8db:	b8 00 00 00 00       	mov    $0x0,%eax
}
     8e0:	c9                   	leave  
     8e1:	c3                   	ret    

000008e2 <parsecmd>:
struct cmd *parseexec(char**, char*);
struct cmd *nulterminate(struct cmd*);

struct cmd*
parsecmd(char *s)
{
     8e2:	55                   	push   %ebp
     8e3:	89 e5                	mov    %esp,%ebp
     8e5:	53                   	push   %ebx
     8e6:	83 ec 24             	sub    $0x24,%esp
  char *es;
  struct cmd *cmd;

  es = s + strlen(s);
     8e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
     8ec:	8b 45 08             	mov    0x8(%ebp),%eax
     8ef:	89 04 24             	mov    %eax,(%esp)
     8f2:	e8 ca 07 00 00       	call   10c1 <strlen>
     8f7:	01 d8                	add    %ebx,%eax
     8f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cmd = parseline(&s, es);
     8fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ff:	89 44 24 04          	mov    %eax,0x4(%esp)
     903:	8d 45 08             	lea    0x8(%ebp),%eax
     906:	89 04 24             	mov    %eax,(%esp)
     909:	e8 60 00 00 00       	call   96e <parseline>
     90e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  peek(&s, es, "");
     911:	c7 44 24 08 40 1d 00 	movl   $0x1d40,0x8(%esp)
     918:	00 
     919:	8b 45 f4             	mov    -0xc(%ebp),%eax
     91c:	89 44 24 04          	mov    %eax,0x4(%esp)
     920:	8d 45 08             	lea    0x8(%ebp),%eax
     923:	89 04 24             	mov    %eax,(%esp)
     926:	e8 46 ff ff ff       	call   871 <peek>
  if(s != es){
     92b:	8b 45 08             	mov    0x8(%ebp),%eax
     92e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
     931:	74 27                	je     95a <parsecmd+0x78>
    printf(2, "leftovers: %s\n", s);
     933:	8b 45 08             	mov    0x8(%ebp),%eax
     936:	89 44 24 08          	mov    %eax,0x8(%esp)
     93a:	c7 44 24 04 41 1d 00 	movl   $0x1d41,0x4(%esp)
     941:	00 
     942:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     949:	e8 7f 0f 00 00       	call   18cd <printf>
    panic("syntax");
     94e:	c7 04 24 50 1d 00 00 	movl   $0x1d50,(%esp)
     955:	e8 fe fb ff ff       	call   558 <panic>
  }
  nulterminate(cmd);
     95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
     95d:	89 04 24             	mov    %eax,(%esp)
     960:	e8 a2 04 00 00       	call   e07 <nulterminate>
  return cmd;
     965:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     968:	83 c4 24             	add    $0x24,%esp
     96b:	5b                   	pop    %ebx
     96c:	5d                   	pop    %ebp
     96d:	c3                   	ret    

0000096e <parseline>:

struct cmd*
parseline(char **ps, char *es)
{
     96e:	55                   	push   %ebp
     96f:	89 e5                	mov    %esp,%ebp
     971:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
     974:	8b 45 0c             	mov    0xc(%ebp),%eax
     977:	89 44 24 04          	mov    %eax,0x4(%esp)
     97b:	8b 45 08             	mov    0x8(%ebp),%eax
     97e:	89 04 24             	mov    %eax,(%esp)
     981:	e8 bc 00 00 00       	call   a42 <parsepipe>
     986:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(peek(ps, es, "&")){
     989:	eb 30                	jmp    9bb <parseline+0x4d>
    gettoken(ps, es, 0, 0);
     98b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     992:	00 
     993:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     99a:	00 
     99b:	8b 45 0c             	mov    0xc(%ebp),%eax
     99e:	89 44 24 04          	mov    %eax,0x4(%esp)
     9a2:	8b 45 08             	mov    0x8(%ebp),%eax
     9a5:	89 04 24             	mov    %eax,(%esp)
     9a8:	e8 86 fd ff ff       	call   733 <gettoken>
    cmd = backcmd(cmd);
     9ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9b0:	89 04 24             	mov    %eax,(%esp)
     9b3:	e8 34 fd ff ff       	call   6ec <backcmd>
     9b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
parseline(char **ps, char *es)
{
  struct cmd *cmd;

  cmd = parsepipe(ps, es);
  while(peek(ps, es, "&")){
     9bb:	c7 44 24 08 57 1d 00 	movl   $0x1d57,0x8(%esp)
     9c2:	00 
     9c3:	8b 45 0c             	mov    0xc(%ebp),%eax
     9c6:	89 44 24 04          	mov    %eax,0x4(%esp)
     9ca:	8b 45 08             	mov    0x8(%ebp),%eax
     9cd:	89 04 24             	mov    %eax,(%esp)
     9d0:	e8 9c fe ff ff       	call   871 <peek>
     9d5:	85 c0                	test   %eax,%eax
     9d7:	75 b2                	jne    98b <parseline+0x1d>
    gettoken(ps, es, 0, 0);
    cmd = backcmd(cmd);
  }
  if(peek(ps, es, ";")){
     9d9:	c7 44 24 08 59 1d 00 	movl   $0x1d59,0x8(%esp)
     9e0:	00 
     9e1:	8b 45 0c             	mov    0xc(%ebp),%eax
     9e4:	89 44 24 04          	mov    %eax,0x4(%esp)
     9e8:	8b 45 08             	mov    0x8(%ebp),%eax
     9eb:	89 04 24             	mov    %eax,(%esp)
     9ee:	e8 7e fe ff ff       	call   871 <peek>
     9f3:	85 c0                	test   %eax,%eax
     9f5:	74 46                	je     a3d <parseline+0xcf>
    gettoken(ps, es, 0, 0);
     9f7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     9fe:	00 
     9ff:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a06:	00 
     a07:	8b 45 0c             	mov    0xc(%ebp),%eax
     a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
     a0e:	8b 45 08             	mov    0x8(%ebp),%eax
     a11:	89 04 24             	mov    %eax,(%esp)
     a14:	e8 1a fd ff ff       	call   733 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     a19:	8b 45 0c             	mov    0xc(%ebp),%eax
     a1c:	89 44 24 04          	mov    %eax,0x4(%esp)
     a20:	8b 45 08             	mov    0x8(%ebp),%eax
     a23:	89 04 24             	mov    %eax,(%esp)
     a26:	e8 43 ff ff ff       	call   96e <parseline>
     a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
     a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a32:	89 04 24             	mov    %eax,(%esp)
     a35:	e8 62 fc ff ff       	call   69c <listcmd>
     a3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     a40:	c9                   	leave  
     a41:	c3                   	ret    

00000a42 <parsepipe>:

struct cmd*
parsepipe(char **ps, char *es)
{
     a42:	55                   	push   %ebp
     a43:	89 e5                	mov    %esp,%ebp
     a45:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  cmd = parseexec(ps, es);
     a48:	8b 45 0c             	mov    0xc(%ebp),%eax
     a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
     a4f:	8b 45 08             	mov    0x8(%ebp),%eax
     a52:	89 04 24             	mov    %eax,(%esp)
     a55:	e8 68 02 00 00       	call   cc2 <parseexec>
     a5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(peek(ps, es, "|")){
     a5d:	c7 44 24 08 5b 1d 00 	movl   $0x1d5b,0x8(%esp)
     a64:	00 
     a65:	8b 45 0c             	mov    0xc(%ebp),%eax
     a68:	89 44 24 04          	mov    %eax,0x4(%esp)
     a6c:	8b 45 08             	mov    0x8(%ebp),%eax
     a6f:	89 04 24             	mov    %eax,(%esp)
     a72:	e8 fa fd ff ff       	call   871 <peek>
     a77:	85 c0                	test   %eax,%eax
     a79:	74 46                	je     ac1 <parsepipe+0x7f>
    gettoken(ps, es, 0, 0);
     a7b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     a82:	00 
     a83:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     a8a:	00 
     a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
     a8e:	89 44 24 04          	mov    %eax,0x4(%esp)
     a92:	8b 45 08             	mov    0x8(%ebp),%eax
     a95:	89 04 24             	mov    %eax,(%esp)
     a98:	e8 96 fc ff ff       	call   733 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
     aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
     aa4:	8b 45 08             	mov    0x8(%ebp),%eax
     aa7:	89 04 24             	mov    %eax,(%esp)
     aaa:	e8 93 ff ff ff       	call   a42 <parsepipe>
     aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
     ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ab6:	89 04 24             	mov    %eax,(%esp)
     ab9:	e8 8e fb ff ff       	call   64c <pipecmd>
     abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
  return cmd;
     ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     ac4:	c9                   	leave  
     ac5:	c3                   	ret    

00000ac6 <parseredirs>:

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     ac6:	55                   	push   %ebp
     ac7:	89 e5                	mov    %esp,%ebp
     ac9:	83 ec 38             	sub    $0x38,%esp
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     acc:	e9 f6 00 00 00       	jmp    bc7 <parseredirs+0x101>
    tok = gettoken(ps, es, 0, 0);
     ad1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ad8:	00 
     ad9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     ae0:	00 
     ae1:	8b 45 10             	mov    0x10(%ebp),%eax
     ae4:	89 44 24 04          	mov    %eax,0x4(%esp)
     ae8:	8b 45 0c             	mov    0xc(%ebp),%eax
     aeb:	89 04 24             	mov    %eax,(%esp)
     aee:	e8 40 fc ff ff       	call   733 <gettoken>
     af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(gettoken(ps, es, &q, &eq) != 'a')
     af6:	8d 45 ec             	lea    -0x14(%ebp),%eax
     af9:	89 44 24 0c          	mov    %eax,0xc(%esp)
     afd:	8d 45 f0             	lea    -0x10(%ebp),%eax
     b00:	89 44 24 08          	mov    %eax,0x8(%esp)
     b04:	8b 45 10             	mov    0x10(%ebp),%eax
     b07:	89 44 24 04          	mov    %eax,0x4(%esp)
     b0b:	8b 45 0c             	mov    0xc(%ebp),%eax
     b0e:	89 04 24             	mov    %eax,(%esp)
     b11:	e8 1d fc ff ff       	call   733 <gettoken>
     b16:	83 f8 61             	cmp    $0x61,%eax
     b19:	74 0c                	je     b27 <parseredirs+0x61>
      panic("missing file for redirection");
     b1b:	c7 04 24 5d 1d 00 00 	movl   $0x1d5d,(%esp)
     b22:	e8 31 fa ff ff       	call   558 <panic>
    switch(tok){
     b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
     b2a:	83 f8 3c             	cmp    $0x3c,%eax
     b2d:	74 0f                	je     b3e <parseredirs+0x78>
     b2f:	83 f8 3e             	cmp    $0x3e,%eax
     b32:	74 38                	je     b6c <parseredirs+0xa6>
     b34:	83 f8 2b             	cmp    $0x2b,%eax
     b37:	74 61                	je     b9a <parseredirs+0xd4>
     b39:	e9 89 00 00 00       	jmp    bc7 <parseredirs+0x101>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     b3e:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b41:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b44:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
     b4b:	00 
     b4c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     b53:	00 
     b54:	89 54 24 08          	mov    %edx,0x8(%esp)
     b58:	89 44 24 04          	mov    %eax,0x4(%esp)
     b5c:	8b 45 08             	mov    0x8(%ebp),%eax
     b5f:	89 04 24             	mov    %eax,(%esp)
     b62:	e8 7a fa ff ff       	call   5e1 <redircmd>
     b67:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     b6a:	eb 5b                	jmp    bc7 <parseredirs+0x101>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     b6c:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     b72:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     b79:	00 
     b7a:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     b81:	00 
     b82:	89 54 24 08          	mov    %edx,0x8(%esp)
     b86:	89 44 24 04          	mov    %eax,0x4(%esp)
     b8a:	8b 45 08             	mov    0x8(%ebp),%eax
     b8d:	89 04 24             	mov    %eax,(%esp)
     b90:	e8 4c fa ff ff       	call   5e1 <redircmd>
     b95:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     b98:	eb 2d                	jmp    bc7 <parseredirs+0x101>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     b9a:	8b 55 ec             	mov    -0x14(%ebp),%edx
     b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     ba0:	c7 44 24 10 01 00 00 	movl   $0x1,0x10(%esp)
     ba7:	00 
     ba8:	c7 44 24 0c 01 02 00 	movl   $0x201,0xc(%esp)
     baf:	00 
     bb0:	89 54 24 08          	mov    %edx,0x8(%esp)
     bb4:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb8:	8b 45 08             	mov    0x8(%ebp),%eax
     bbb:	89 04 24             	mov    %eax,(%esp)
     bbe:	e8 1e fa ff ff       	call   5e1 <redircmd>
     bc3:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     bc6:	90                   	nop
parseredirs(struct cmd *cmd, char **ps, char *es)
{
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     bc7:	c7 44 24 08 7a 1d 00 	movl   $0x1d7a,0x8(%esp)
     bce:	00 
     bcf:	8b 45 10             	mov    0x10(%ebp),%eax
     bd2:	89 44 24 04          	mov    %eax,0x4(%esp)
     bd6:	8b 45 0c             	mov    0xc(%ebp),%eax
     bd9:	89 04 24             	mov    %eax,(%esp)
     bdc:	e8 90 fc ff ff       	call   871 <peek>
     be1:	85 c0                	test   %eax,%eax
     be3:	0f 85 e8 fe ff ff    	jne    ad1 <parseredirs+0xb>
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    }
  }
  return cmd;
     be9:	8b 45 08             	mov    0x8(%ebp),%eax
}
     bec:	c9                   	leave  
     bed:	c3                   	ret    

00000bee <parseblock>:

struct cmd*
parseblock(char **ps, char *es)
{
     bee:	55                   	push   %ebp
     bef:	89 e5                	mov    %esp,%ebp
     bf1:	83 ec 28             	sub    $0x28,%esp
  struct cmd *cmd;

  if(!peek(ps, es, "("))
     bf4:	c7 44 24 08 7d 1d 00 	movl   $0x1d7d,0x8(%esp)
     bfb:	00 
     bfc:	8b 45 0c             	mov    0xc(%ebp),%eax
     bff:	89 44 24 04          	mov    %eax,0x4(%esp)
     c03:	8b 45 08             	mov    0x8(%ebp),%eax
     c06:	89 04 24             	mov    %eax,(%esp)
     c09:	e8 63 fc ff ff       	call   871 <peek>
     c0e:	85 c0                	test   %eax,%eax
     c10:	75 0c                	jne    c1e <parseblock+0x30>
    panic("parseblock");
     c12:	c7 04 24 7f 1d 00 00 	movl   $0x1d7f,(%esp)
     c19:	e8 3a f9 ff ff       	call   558 <panic>
  gettoken(ps, es, 0, 0);
     c1e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     c25:	00 
     c26:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     c2d:	00 
     c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c31:	89 44 24 04          	mov    %eax,0x4(%esp)
     c35:	8b 45 08             	mov    0x8(%ebp),%eax
     c38:	89 04 24             	mov    %eax,(%esp)
     c3b:	e8 f3 fa ff ff       	call   733 <gettoken>
  cmd = parseline(ps, es);
     c40:	8b 45 0c             	mov    0xc(%ebp),%eax
     c43:	89 44 24 04          	mov    %eax,0x4(%esp)
     c47:	8b 45 08             	mov    0x8(%ebp),%eax
     c4a:	89 04 24             	mov    %eax,(%esp)
     c4d:	e8 1c fd ff ff       	call   96e <parseline>
     c52:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!peek(ps, es, ")"))
     c55:	c7 44 24 08 8a 1d 00 	movl   $0x1d8a,0x8(%esp)
     c5c:	00 
     c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
     c60:	89 44 24 04          	mov    %eax,0x4(%esp)
     c64:	8b 45 08             	mov    0x8(%ebp),%eax
     c67:	89 04 24             	mov    %eax,(%esp)
     c6a:	e8 02 fc ff ff       	call   871 <peek>
     c6f:	85 c0                	test   %eax,%eax
     c71:	75 0c                	jne    c7f <parseblock+0x91>
    panic("syntax - missing )");
     c73:	c7 04 24 8c 1d 00 00 	movl   $0x1d8c,(%esp)
     c7a:	e8 d9 f8 ff ff       	call   558 <panic>
  gettoken(ps, es, 0, 0);
     c7f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     c86:	00 
     c87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
     c8e:	00 
     c8f:	8b 45 0c             	mov    0xc(%ebp),%eax
     c92:	89 44 24 04          	mov    %eax,0x4(%esp)
     c96:	8b 45 08             	mov    0x8(%ebp),%eax
     c99:	89 04 24             	mov    %eax,(%esp)
     c9c:	e8 92 fa ff ff       	call   733 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     ca1:	8b 45 0c             	mov    0xc(%ebp),%eax
     ca4:	89 44 24 08          	mov    %eax,0x8(%esp)
     ca8:	8b 45 08             	mov    0x8(%ebp),%eax
     cab:	89 44 24 04          	mov    %eax,0x4(%esp)
     caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cb2:	89 04 24             	mov    %eax,(%esp)
     cb5:	e8 0c fe ff ff       	call   ac6 <parseredirs>
     cba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  return cmd;
     cbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
     cc0:	c9                   	leave  
     cc1:	c3                   	ret    

00000cc2 <parseexec>:

struct cmd*
parseexec(char **ps, char *es)
{
     cc2:	55                   	push   %ebp
     cc3:	89 e5                	mov    %esp,%ebp
     cc5:	83 ec 38             	sub    $0x38,%esp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     cc8:	c7 44 24 08 7d 1d 00 	movl   $0x1d7d,0x8(%esp)
     ccf:	00 
     cd0:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
     cd7:	8b 45 08             	mov    0x8(%ebp),%eax
     cda:	89 04 24             	mov    %eax,(%esp)
     cdd:	e8 8f fb ff ff       	call   871 <peek>
     ce2:	85 c0                	test   %eax,%eax
     ce4:	74 17                	je     cfd <parseexec+0x3b>
    return parseblock(ps, es);
     ce6:	8b 45 0c             	mov    0xc(%ebp),%eax
     ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
     ced:	8b 45 08             	mov    0x8(%ebp),%eax
     cf0:	89 04 24             	mov    %eax,(%esp)
     cf3:	e8 f6 fe ff ff       	call   bee <parseblock>
     cf8:	e9 08 01 00 00       	jmp    e05 <parseexec+0x143>

  ret = execcmd();
     cfd:	e8 a1 f8 ff ff       	call   5a3 <execcmd>
     d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  cmd = (struct execcmd*)ret;
     d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d08:	89 45 ec             	mov    %eax,-0x14(%ebp)

  argc = 0;
     d0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  ret = parseredirs(ret, ps, es);
     d12:	8b 45 0c             	mov    0xc(%ebp),%eax
     d15:	89 44 24 08          	mov    %eax,0x8(%esp)
     d19:	8b 45 08             	mov    0x8(%ebp),%eax
     d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
     d20:	8b 45 f0             	mov    -0x10(%ebp),%eax
     d23:	89 04 24             	mov    %eax,(%esp)
     d26:	e8 9b fd ff ff       	call   ac6 <parseredirs>
     d2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  while(!peek(ps, es, "|)&;")){
     d2e:	e9 8e 00 00 00       	jmp    dc1 <parseexec+0xff>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     d33:	8d 45 e0             	lea    -0x20(%ebp),%eax
     d36:	89 44 24 0c          	mov    %eax,0xc(%esp)
     d3a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     d3d:	89 44 24 08          	mov    %eax,0x8(%esp)
     d41:	8b 45 0c             	mov    0xc(%ebp),%eax
     d44:	89 44 24 04          	mov    %eax,0x4(%esp)
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	89 04 24             	mov    %eax,(%esp)
     d4e:	e8 e0 f9 ff ff       	call   733 <gettoken>
     d53:	89 45 e8             	mov    %eax,-0x18(%ebp)
     d56:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
     d5a:	75 05                	jne    d61 <parseexec+0x9f>
      break;
     d5c:	e9 82 00 00 00       	jmp    de3 <parseexec+0x121>
    if(tok != 'a')
     d61:	83 7d e8 61          	cmpl   $0x61,-0x18(%ebp)
     d65:	74 0c                	je     d73 <parseexec+0xb1>
      panic("syntax");
     d67:	c7 04 24 50 1d 00 00 	movl   $0x1d50,(%esp)
     d6e:	e8 e5 f7 ff ff       	call   558 <panic>
    cmd->argv[argc] = q;
     d73:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
     d76:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d79:	8b 55 f4             	mov    -0xc(%ebp),%edx
     d7c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
    cmd->eargv[argc] = eq;
     d80:	8b 55 e0             	mov    -0x20(%ebp),%edx
     d83:	8b 45 ec             	mov    -0x14(%ebp),%eax
     d86:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     d89:	83 c1 14             	add    $0x14,%ecx
     d8c:	89 54 88 04          	mov    %edx,0x4(%eax,%ecx,4)
    argc++;
     d90:	ff 45 f4             	incl   -0xc(%ebp)
    if(argc >= MAXARGS)
     d93:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
     d97:	7e 0c                	jle    da5 <parseexec+0xe3>
      panic("too many args");
     d99:	c7 04 24 9f 1d 00 00 	movl   $0x1d9f,(%esp)
     da0:	e8 b3 f7 ff ff       	call   558 <panic>
    ret = parseredirs(ret, ps, es);
     da5:	8b 45 0c             	mov    0xc(%ebp),%eax
     da8:	89 44 24 08          	mov    %eax,0x8(%esp)
     dac:	8b 45 08             	mov    0x8(%ebp),%eax
     daf:	89 44 24 04          	mov    %eax,0x4(%esp)
     db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
     db6:	89 04 24             	mov    %eax,(%esp)
     db9:	e8 08 fd ff ff       	call   ac6 <parseredirs>
     dbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
  while(!peek(ps, es, "|)&;")){
     dc1:	c7 44 24 08 ad 1d 00 	movl   $0x1dad,0x8(%esp)
     dc8:	00 
     dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
     dcc:	89 44 24 04          	mov    %eax,0x4(%esp)
     dd0:	8b 45 08             	mov    0x8(%ebp),%eax
     dd3:	89 04 24             	mov    %eax,(%esp)
     dd6:	e8 96 fa ff ff       	call   871 <peek>
     ddb:	85 c0                	test   %eax,%eax
     ddd:	0f 84 50 ff ff ff    	je     d33 <parseexec+0x71>
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
     de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     de6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     de9:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     df0:	00 
  cmd->eargv[argc] = 0;
     df1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     df4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     df7:	83 c2 14             	add    $0x14,%edx
     dfa:	c7 44 90 04 00 00 00 	movl   $0x0,0x4(%eax,%edx,4)
     e01:	00 
  return ret;
     e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     e05:	c9                   	leave  
     e06:	c3                   	ret    

00000e07 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e07:	55                   	push   %ebp
     e08:	89 e5                	mov    %esp,%ebp
     e0a:	83 ec 38             	sub    $0x38,%esp
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     e11:	75 0a                	jne    e1d <nulterminate+0x16>
    return 0;
     e13:	b8 00 00 00 00       	mov    $0x0,%eax
     e18:	e9 c8 00 00 00       	jmp    ee5 <nulterminate+0xde>

  switch(cmd->type){
     e1d:	8b 45 08             	mov    0x8(%ebp),%eax
     e20:	8b 00                	mov    (%eax),%eax
     e22:	83 f8 05             	cmp    $0x5,%eax
     e25:	0f 87 b7 00 00 00    	ja     ee2 <nulterminate+0xdb>
     e2b:	8b 04 85 b4 1d 00 00 	mov    0x1db4(,%eax,4),%eax
     e32:	ff e0                	jmp    *%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
     e34:	8b 45 08             	mov    0x8(%ebp),%eax
     e37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0; ecmd->argv[i]; i++)
     e3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     e41:	eb 13                	jmp    e56 <nulterminate+0x4f>
      *ecmd->eargv[i] = 0;
     e43:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e46:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e49:	83 c2 14             	add    $0x14,%edx
     e4c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     e50:	c6 00 00             	movb   $0x0,(%eax)
    return 0;

  switch(cmd->type){
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     e53:	ff 45 f4             	incl   -0xc(%ebp)
     e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
     e59:	8b 55 f4             	mov    -0xc(%ebp),%edx
     e5c:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
     e60:	85 c0                	test   %eax,%eax
     e62:	75 df                	jne    e43 <nulterminate+0x3c>
      *ecmd->eargv[i] = 0;
    break;
     e64:	eb 7c                	jmp    ee2 <nulterminate+0xdb>

  case REDIR:
    rcmd = (struct redircmd*)cmd;
     e66:	8b 45 08             	mov    0x8(%ebp),%eax
     e69:	89 45 ec             	mov    %eax,-0x14(%ebp)
    nulterminate(rcmd->cmd);
     e6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e6f:	8b 40 04             	mov    0x4(%eax),%eax
     e72:	89 04 24             	mov    %eax,(%esp)
     e75:	e8 8d ff ff ff       	call   e07 <nulterminate>
    *rcmd->efile = 0;
     e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e7d:	8b 40 0c             	mov    0xc(%eax),%eax
     e80:	c6 00 00             	movb   $0x0,(%eax)
    break;
     e83:	eb 5d                	jmp    ee2 <nulterminate+0xdb>

  case PIPE:
    pcmd = (struct pipecmd*)cmd;
     e85:	8b 45 08             	mov    0x8(%ebp),%eax
     e88:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nulterminate(pcmd->left);
     e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e8e:	8b 40 04             	mov    0x4(%eax),%eax
     e91:	89 04 24             	mov    %eax,(%esp)
     e94:	e8 6e ff ff ff       	call   e07 <nulterminate>
    nulterminate(pcmd->right);
     e99:	8b 45 e8             	mov    -0x18(%ebp),%eax
     e9c:	8b 40 08             	mov    0x8(%eax),%eax
     e9f:	89 04 24             	mov    %eax,(%esp)
     ea2:	e8 60 ff ff ff       	call   e07 <nulterminate>
    break;
     ea7:	eb 39                	jmp    ee2 <nulterminate+0xdb>

  case LIST:
    lcmd = (struct listcmd*)cmd;
     ea9:	8b 45 08             	mov    0x8(%ebp),%eax
     eac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nulterminate(lcmd->left);
     eaf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     eb2:	8b 40 04             	mov    0x4(%eax),%eax
     eb5:	89 04 24             	mov    %eax,(%esp)
     eb8:	e8 4a ff ff ff       	call   e07 <nulterminate>
    nulterminate(lcmd->right);
     ebd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     ec0:	8b 40 08             	mov    0x8(%eax),%eax
     ec3:	89 04 24             	mov    %eax,(%esp)
     ec6:	e8 3c ff ff ff       	call   e07 <nulterminate>
    break;
     ecb:	eb 15                	jmp    ee2 <nulterminate+0xdb>

  case BACK:
    bcmd = (struct backcmd*)cmd;
     ecd:	8b 45 08             	mov    0x8(%ebp),%eax
     ed0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nulterminate(bcmd->cmd);
     ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
     ed6:	8b 40 04             	mov    0x4(%eax),%eax
     ed9:	89 04 24             	mov    %eax,(%esp)
     edc:	e8 26 ff ff ff       	call   e07 <nulterminate>
    break;
     ee1:	90                   	nop
  }
  return cmd;
     ee2:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ee5:	c9                   	leave  
     ee6:	c3                   	ret    
     ee7:	90                   	nop

00000ee8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     ee8:	55                   	push   %ebp
     ee9:	89 e5                	mov    %esp,%ebp
     eeb:	57                   	push   %edi
     eec:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     eed:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ef0:	8b 55 10             	mov    0x10(%ebp),%edx
     ef3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ef6:	89 cb                	mov    %ecx,%ebx
     ef8:	89 df                	mov    %ebx,%edi
     efa:	89 d1                	mov    %edx,%ecx
     efc:	fc                   	cld    
     efd:	f3 aa                	rep stos %al,%es:(%edi)
     eff:	89 ca                	mov    %ecx,%edx
     f01:	89 fb                	mov    %edi,%ebx
     f03:	89 5d 08             	mov    %ebx,0x8(%ebp)
     f06:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     f09:	5b                   	pop    %ebx
     f0a:	5f                   	pop    %edi
     f0b:	5d                   	pop    %ebp
     f0c:	c3                   	ret    

00000f0d <strcpy>:
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
     f0d:	55                   	push   %ebp
     f0e:	89 e5                	mov    %esp,%ebp
     f10:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     f13:	8b 45 08             	mov    0x8(%ebp),%eax
     f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     f19:	90                   	nop
     f1a:	8b 45 08             	mov    0x8(%ebp),%eax
     f1d:	8d 50 01             	lea    0x1(%eax),%edx
     f20:	89 55 08             	mov    %edx,0x8(%ebp)
     f23:	8b 55 0c             	mov    0xc(%ebp),%edx
     f26:	8d 4a 01             	lea    0x1(%edx),%ecx
     f29:	89 4d 0c             	mov    %ecx,0xc(%ebp)
     f2c:	8a 12                	mov    (%edx),%dl
     f2e:	88 10                	mov    %dl,(%eax)
     f30:	8a 00                	mov    (%eax),%al
     f32:	84 c0                	test   %al,%al
     f34:	75 e4                	jne    f1a <strcpy+0xd>
    ;
  return os;
     f36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     f39:	c9                   	leave  
     f3a:	c3                   	ret    

00000f3b <copy>:

int 
copy(char *inputfile, char *outputfile, int used_disk, int max_disk)
{
     f3b:	55                   	push   %ebp
     f3c:	89 e5                	mov    %esp,%ebp
     f3e:	83 ec 58             	sub    $0x58,%esp
  int fd1, fd2, count, bytes = 0, max;
     f41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
     f48:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     f4f:	00 
     f50:	8b 45 08             	mov    0x8(%ebp),%eax
     f53:	89 04 24             	mov    %eax,(%esp)
     f56:	e8 7d 07 00 00       	call   16d8 <open>
     f5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
     f5e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f62:	79 20                	jns    f84 <copy+0x49>
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
     f64:	8b 45 08             	mov    0x8(%ebp),%eax
     f67:	89 44 24 08          	mov    %eax,0x8(%esp)
     f6b:	c7 44 24 04 cc 1d 00 	movl   $0x1dcc,0x4(%esp)
     f72:	00 
     f73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     f7a:	e8 4e 09 00 00       	call   18cd <printf>
      exit();
     f7f:	e8 14 07 00 00       	call   1698 <exit>
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
     f84:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     f8b:	00 
     f8c:	8b 45 0c             	mov    0xc(%ebp),%eax
     f8f:	89 04 24             	mov    %eax,(%esp)
     f92:	e8 41 07 00 00       	call   16d8 <open>
     f97:	89 45 ec             	mov    %eax,-0x14(%ebp)
     f9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f9e:	79 20                	jns    fc0 <copy+0x85>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
     fa0:	8b 45 0c             	mov    0xc(%ebp),%eax
     fa3:	89 44 24 08          	mov    %eax,0x8(%esp)
     fa7:	c7 44 24 04 e7 1d 00 	movl   $0x1de7,0x4(%esp)
     fae:	00 
     faf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     fb6:	e8 12 09 00 00       	call   18cd <printf>
      exit();
     fbb:	e8 d8 06 00 00       	call   1698 <exit>
  }

  while((count = read(fd1, buffer, 32)) > 0)
     fc0:	eb 3b                	jmp    ffd <copy+0xc2>
  {
      max = used_disk+=count;
     fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fc5:	01 45 10             	add    %eax,0x10(%ebp)
     fc8:	8b 45 10             	mov    0x10(%ebp),%eax
     fcb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(max > max_disk)
     fce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     fd1:	3b 45 14             	cmp    0x14(%ebp),%eax
     fd4:	7e 07                	jle    fdd <copy+0xa2>
      {
        return -1;
     fd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     fdb:	eb 5c                	jmp    1039 <copy+0xfe>
      }
      bytes = bytes + count;
     fdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fe0:	01 45 f4             	add    %eax,-0xc(%ebp)
      write(fd2, buffer, 32);
     fe3:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
     fea:	00 
     feb:	8d 45 c4             	lea    -0x3c(%ebp),%eax
     fee:	89 44 24 04          	mov    %eax,0x4(%esp)
     ff2:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ff5:	89 04 24             	mov    %eax,(%esp)
     ff8:	e8 bb 06 00 00       	call   16b8 <write>
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
     ffd:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    1004:	00 
    1005:	8d 45 c4             	lea    -0x3c(%ebp),%eax
    1008:	89 44 24 04          	mov    %eax,0x4(%esp)
    100c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    100f:	89 04 24             	mov    %eax,(%esp)
    1012:	e8 99 06 00 00       	call   16b0 <read>
    1017:	89 45 e8             	mov    %eax,-0x18(%ebp)
    101a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
    101e:	7f a2                	jg     fc2 <copy+0x87>
      }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
    1020:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1023:	89 04 24             	mov    %eax,(%esp)
    1026:	e8 95 06 00 00       	call   16c0 <close>
  close(fd2);
    102b:	8b 45 ec             	mov    -0x14(%ebp),%eax
    102e:	89 04 24             	mov    %eax,(%esp)
    1031:	e8 8a 06 00 00       	call   16c0 <close>
  return(bytes);
    1036:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1039:	c9                   	leave  
    103a:	c3                   	ret    

0000103b <strcmp>:

int
strcmp(const char *p, const char *q)
{
    103b:	55                   	push   %ebp
    103c:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
    103e:	eb 06                	jmp    1046 <strcmp+0xb>
    p++, q++;
    1040:	ff 45 08             	incl   0x8(%ebp)
    1043:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    1046:	8b 45 08             	mov    0x8(%ebp),%eax
    1049:	8a 00                	mov    (%eax),%al
    104b:	84 c0                	test   %al,%al
    104d:	74 0e                	je     105d <strcmp+0x22>
    104f:	8b 45 08             	mov    0x8(%ebp),%eax
    1052:	8a 10                	mov    (%eax),%dl
    1054:	8b 45 0c             	mov    0xc(%ebp),%eax
    1057:	8a 00                	mov    (%eax),%al
    1059:	38 c2                	cmp    %al,%dl
    105b:	74 e3                	je     1040 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
    105d:	8b 45 08             	mov    0x8(%ebp),%eax
    1060:	8a 00                	mov    (%eax),%al
    1062:	0f b6 d0             	movzbl %al,%edx
    1065:	8b 45 0c             	mov    0xc(%ebp),%eax
    1068:	8a 00                	mov    (%eax),%al
    106a:	0f b6 c0             	movzbl %al,%eax
    106d:	29 c2                	sub    %eax,%edx
    106f:	89 d0                	mov    %edx,%eax
}
    1071:	5d                   	pop    %ebp
    1072:	c3                   	ret    

00001073 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    1073:	55                   	push   %ebp
    1074:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
    1076:	eb 09                	jmp    1081 <strncmp+0xe>
    n--, p++, q++;
    1078:	ff 4d 10             	decl   0x10(%ebp)
    107b:	ff 45 08             	incl   0x8(%ebp)
    107e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    1081:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1085:	74 17                	je     109e <strncmp+0x2b>
    1087:	8b 45 08             	mov    0x8(%ebp),%eax
    108a:	8a 00                	mov    (%eax),%al
    108c:	84 c0                	test   %al,%al
    108e:	74 0e                	je     109e <strncmp+0x2b>
    1090:	8b 45 08             	mov    0x8(%ebp),%eax
    1093:	8a 10                	mov    (%eax),%dl
    1095:	8b 45 0c             	mov    0xc(%ebp),%eax
    1098:	8a 00                	mov    (%eax),%al
    109a:	38 c2                	cmp    %al,%dl
    109c:	74 da                	je     1078 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
    109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    10a2:	75 07                	jne    10ab <strncmp+0x38>
    return 0;
    10a4:	b8 00 00 00 00       	mov    $0x0,%eax
    10a9:	eb 14                	jmp    10bf <strncmp+0x4c>
  return (uchar)*p - (uchar)*q;
    10ab:	8b 45 08             	mov    0x8(%ebp),%eax
    10ae:	8a 00                	mov    (%eax),%al
    10b0:	0f b6 d0             	movzbl %al,%edx
    10b3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10b6:	8a 00                	mov    (%eax),%al
    10b8:	0f b6 c0             	movzbl %al,%eax
    10bb:	29 c2                	sub    %eax,%edx
    10bd:	89 d0                	mov    %edx,%eax
}
    10bf:	5d                   	pop    %ebp
    10c0:	c3                   	ret    

000010c1 <strlen>:

uint
strlen(const char *s)
{
    10c1:	55                   	push   %ebp
    10c2:	89 e5                	mov    %esp,%ebp
    10c4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
    10c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    10ce:	eb 03                	jmp    10d3 <strlen+0x12>
    10d0:	ff 45 fc             	incl   -0x4(%ebp)
    10d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
    10d6:	8b 45 08             	mov    0x8(%ebp),%eax
    10d9:	01 d0                	add    %edx,%eax
    10db:	8a 00                	mov    (%eax),%al
    10dd:	84 c0                	test   %al,%al
    10df:	75 ef                	jne    10d0 <strlen+0xf>
    ;
  return n;
    10e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    10e4:	c9                   	leave  
    10e5:	c3                   	ret    

000010e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10e6:	55                   	push   %ebp
    10e7:	89 e5                	mov    %esp,%ebp
    10e9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
    10ec:	8b 45 10             	mov    0x10(%ebp),%eax
    10ef:	89 44 24 08          	mov    %eax,0x8(%esp)
    10f3:	8b 45 0c             	mov    0xc(%ebp),%eax
    10f6:	89 44 24 04          	mov    %eax,0x4(%esp)
    10fa:	8b 45 08             	mov    0x8(%ebp),%eax
    10fd:	89 04 24             	mov    %eax,(%esp)
    1100:	e8 e3 fd ff ff       	call   ee8 <stosb>
  return dst;
    1105:	8b 45 08             	mov    0x8(%ebp),%eax
}
    1108:	c9                   	leave  
    1109:	c3                   	ret    

0000110a <strchr>:

char*
strchr(const char *s, char c)
{
    110a:	55                   	push   %ebp
    110b:	89 e5                	mov    %esp,%ebp
    110d:	83 ec 04             	sub    $0x4,%esp
    1110:	8b 45 0c             	mov    0xc(%ebp),%eax
    1113:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
    1116:	eb 12                	jmp    112a <strchr+0x20>
    if(*s == c)
    1118:	8b 45 08             	mov    0x8(%ebp),%eax
    111b:	8a 00                	mov    (%eax),%al
    111d:	3a 45 fc             	cmp    -0x4(%ebp),%al
    1120:	75 05                	jne    1127 <strchr+0x1d>
      return (char*)s;
    1122:	8b 45 08             	mov    0x8(%ebp),%eax
    1125:	eb 11                	jmp    1138 <strchr+0x2e>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    1127:	ff 45 08             	incl   0x8(%ebp)
    112a:	8b 45 08             	mov    0x8(%ebp),%eax
    112d:	8a 00                	mov    (%eax),%al
    112f:	84 c0                	test   %al,%al
    1131:	75 e5                	jne    1118 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
    1133:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1138:	c9                   	leave  
    1139:	c3                   	ret    

0000113a <strcat>:

char *
strcat(char *dest, const char *src)
{
    113a:	55                   	push   %ebp
    113b:	89 e5                	mov    %esp,%ebp
    113d:	83 ec 10             	sub    $0x10,%esp
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
    1140:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    1147:	eb 03                	jmp    114c <strcat+0x12>
    1149:	ff 45 fc             	incl   -0x4(%ebp)
    114c:	8b 55 fc             	mov    -0x4(%ebp),%edx
    114f:	8b 45 08             	mov    0x8(%ebp),%eax
    1152:	01 d0                	add    %edx,%eax
    1154:	8a 00                	mov    (%eax),%al
    1156:	84 c0                	test   %al,%al
    1158:	75 ef                	jne    1149 <strcat+0xf>
        ;
    for (j = 0; src[j] != '\0'; j++)
    115a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
    1161:	eb 1e                	jmp    1181 <strcat+0x47>
        dest[i+j] = src[j];
    1163:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1166:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1169:	01 d0                	add    %edx,%eax
    116b:	89 c2                	mov    %eax,%edx
    116d:	8b 45 08             	mov    0x8(%ebp),%eax
    1170:	01 c2                	add    %eax,%edx
    1172:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    1175:	8b 45 0c             	mov    0xc(%ebp),%eax
    1178:	01 c8                	add    %ecx,%eax
    117a:	8a 00                	mov    (%eax),%al
    117c:	88 02                	mov    %al,(%edx)
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
    117e:	ff 45 f8             	incl   -0x8(%ebp)
    1181:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1184:	8b 45 0c             	mov    0xc(%ebp),%eax
    1187:	01 d0                	add    %edx,%eax
    1189:	8a 00                	mov    (%eax),%al
    118b:	84 c0                	test   %al,%al
    118d:	75 d4                	jne    1163 <strcat+0x29>
        dest[i+j] = src[j];
    dest[i+j] = '\0';
    118f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1192:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1195:	01 d0                	add    %edx,%eax
    1197:	89 c2                	mov    %eax,%edx
    1199:	8b 45 08             	mov    0x8(%ebp),%eax
    119c:	01 d0                	add    %edx,%eax
    119e:	c6 00 00             	movb   $0x0,(%eax)
    return dest;
    11a1:	8b 45 08             	mov    0x8(%ebp),%eax
}
    11a4:	c9                   	leave  
    11a5:	c3                   	ret    

000011a6 <strstr>:

int 
strstr(char* s, char* sub)
{
    11a6:	55                   	push   %ebp
    11a7:	89 e5                	mov    %esp,%ebp
    11a9:	83 ec 14             	sub    $0x14,%esp
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    11ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    11b3:	eb 7c                	jmp    1231 <strstr+0x8b>
    {
        if(s[i] == sub[0])
    11b5:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11b8:	8b 45 08             	mov    0x8(%ebp),%eax
    11bb:	01 d0                	add    %edx,%eax
    11bd:	8a 10                	mov    (%eax),%dl
    11bf:	8b 45 0c             	mov    0xc(%ebp),%eax
    11c2:	8a 00                	mov    (%eax),%al
    11c4:	38 c2                	cmp    %al,%dl
    11c6:	75 66                	jne    122e <strstr+0x88>
        {
            if(strlen(sub) == 1)
    11c8:	8b 45 0c             	mov    0xc(%ebp),%eax
    11cb:	89 04 24             	mov    %eax,(%esp)
    11ce:	e8 ee fe ff ff       	call   10c1 <strlen>
    11d3:	83 f8 01             	cmp    $0x1,%eax
    11d6:	75 05                	jne    11dd <strstr+0x37>
            {  
                return i;
    11d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11db:	eb 6b                	jmp    1248 <strstr+0xa2>
            }
            for(j = 1; sub[j] != '\0'; j++)
    11dd:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
    11e4:	eb 3a                	jmp    1220 <strstr+0x7a>
            {
                if(s[i + j] == sub[j])
    11e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11e9:	8b 55 fc             	mov    -0x4(%ebp),%edx
    11ec:	01 d0                	add    %edx,%eax
    11ee:	89 c2                	mov    %eax,%edx
    11f0:	8b 45 08             	mov    0x8(%ebp),%eax
    11f3:	01 d0                	add    %edx,%eax
    11f5:	8a 10                	mov    (%eax),%dl
    11f7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    11fa:	8b 45 0c             	mov    0xc(%ebp),%eax
    11fd:	01 c8                	add    %ecx,%eax
    11ff:	8a 00                	mov    (%eax),%al
    1201:	38 c2                	cmp    %al,%dl
    1203:	75 16                	jne    121b <strstr+0x75>
                {
                    if(sub[j + 1] == '\0')
    1205:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1208:	8d 50 01             	lea    0x1(%eax),%edx
    120b:	8b 45 0c             	mov    0xc(%ebp),%eax
    120e:	01 d0                	add    %edx,%eax
    1210:	8a 00                	mov    (%eax),%al
    1212:	84 c0                	test   %al,%al
    1214:	75 07                	jne    121d <strstr+0x77>
                    {
                        return i;
    1216:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1219:	eb 2d                	jmp    1248 <strstr+0xa2>
                    }
                }
                else
                {
                    break;
    121b:	eb 11                	jmp    122e <strstr+0x88>
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
    121d:	ff 45 f8             	incl   -0x8(%ebp)
    1220:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1223:	8b 45 0c             	mov    0xc(%ebp),%eax
    1226:	01 d0                	add    %edx,%eax
    1228:	8a 00                	mov    (%eax),%al
    122a:	84 c0                	test   %al,%al
    122c:	75 b8                	jne    11e6 <strstr+0x40>
int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    122e:	ff 45 fc             	incl   -0x4(%ebp)
    1231:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1234:	8b 45 08             	mov    0x8(%ebp),%eax
    1237:	01 d0                	add    %edx,%eax
    1239:	8a 00                	mov    (%eax),%al
    123b:	84 c0                	test   %al,%al
    123d:	0f 85 72 ff ff ff    	jne    11b5 <strstr+0xf>
                    break;
                }
            }
        }
     }
     return -1;
    1243:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
    1248:	c9                   	leave  
    1249:	c3                   	ret    

0000124a <strtok>:

char *
strtok(char *s, const char *delim)
{
    124a:	55                   	push   %ebp
    124b:	89 e5                	mov    %esp,%ebp
    124d:	53                   	push   %ebx
    124e:	83 ec 14             	sub    $0x14,%esp
    static char *lasts;
    register int ch;

    if (s == 0)
    1251:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1255:	75 08                	jne    125f <strtok+0x15>
  s = lasts;
    1257:	a1 08 25 00 00       	mov    0x2508,%eax
    125c:	89 45 08             	mov    %eax,0x8(%ebp)
    do {
  if ((ch = *s++) == '\0')
    125f:	8b 45 08             	mov    0x8(%ebp),%eax
    1262:	8d 50 01             	lea    0x1(%eax),%edx
    1265:	89 55 08             	mov    %edx,0x8(%ebp)
    1268:	8a 00                	mov    (%eax),%al
    126a:	0f be d8             	movsbl %al,%ebx
    126d:	85 db                	test   %ebx,%ebx
    126f:	75 07                	jne    1278 <strtok+0x2e>
      return 0;
    1271:	b8 00 00 00 00       	mov    $0x0,%eax
    1276:	eb 58                	jmp    12d0 <strtok+0x86>
    } while (strchr(delim, ch));
    1278:	88 d8                	mov    %bl,%al
    127a:	0f be c0             	movsbl %al,%eax
    127d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1281:	8b 45 0c             	mov    0xc(%ebp),%eax
    1284:	89 04 24             	mov    %eax,(%esp)
    1287:	e8 7e fe ff ff       	call   110a <strchr>
    128c:	85 c0                	test   %eax,%eax
    128e:	75 cf                	jne    125f <strtok+0x15>
    --s;
    1290:	ff 4d 08             	decl   0x8(%ebp)
    lasts = s + strcspn(s, delim);
    1293:	8b 45 0c             	mov    0xc(%ebp),%eax
    1296:	89 44 24 04          	mov    %eax,0x4(%esp)
    129a:	8b 45 08             	mov    0x8(%ebp),%eax
    129d:	89 04 24             	mov    %eax,(%esp)
    12a0:	e8 31 00 00 00       	call   12d6 <strcspn>
    12a5:	89 c2                	mov    %eax,%edx
    12a7:	8b 45 08             	mov    0x8(%ebp),%eax
    12aa:	01 d0                	add    %edx,%eax
    12ac:	a3 08 25 00 00       	mov    %eax,0x2508
    if (*lasts != 0)
    12b1:	a1 08 25 00 00       	mov    0x2508,%eax
    12b6:	8a 00                	mov    (%eax),%al
    12b8:	84 c0                	test   %al,%al
    12ba:	74 11                	je     12cd <strtok+0x83>
  *lasts++ = 0;
    12bc:	a1 08 25 00 00       	mov    0x2508,%eax
    12c1:	8d 50 01             	lea    0x1(%eax),%edx
    12c4:	89 15 08 25 00 00    	mov    %edx,0x2508
    12ca:	c6 00 00             	movb   $0x0,(%eax)
    return s;
    12cd:	8b 45 08             	mov    0x8(%ebp),%eax
}
    12d0:	83 c4 14             	add    $0x14,%esp
    12d3:	5b                   	pop    %ebx
    12d4:	5d                   	pop    %ebp
    12d5:	c3                   	ret    

000012d6 <strcspn>:

int
strcspn(const char *s1, const char *s2)
{
    12d6:	55                   	push   %ebp
    12d7:	89 e5                	mov    %esp,%ebp
    12d9:	83 ec 18             	sub    $0x18,%esp
    int ret=0;
    12dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while(*s1)
    12e3:	eb 26                	jmp    130b <strcspn+0x35>
        if(strchr(s2,*s1))
    12e5:	8b 45 08             	mov    0x8(%ebp),%eax
    12e8:	8a 00                	mov    (%eax),%al
    12ea:	0f be c0             	movsbl %al,%eax
    12ed:	89 44 24 04          	mov    %eax,0x4(%esp)
    12f1:	8b 45 0c             	mov    0xc(%ebp),%eax
    12f4:	89 04 24             	mov    %eax,(%esp)
    12f7:	e8 0e fe ff ff       	call   110a <strchr>
    12fc:	85 c0                	test   %eax,%eax
    12fe:	74 05                	je     1305 <strcspn+0x2f>
            return ret;
    1300:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1303:	eb 12                	jmp    1317 <strcspn+0x41>
        else
            s1++,ret++;
    1305:	ff 45 08             	incl   0x8(%ebp)
    1308:	ff 45 fc             	incl   -0x4(%ebp)

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
    130b:	8b 45 08             	mov    0x8(%ebp),%eax
    130e:	8a 00                	mov    (%eax),%al
    1310:	84 c0                	test   %al,%al
    1312:	75 d1                	jne    12e5 <strcspn+0xf>
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
    1314:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    1317:	c9                   	leave  
    1318:	c3                   	ret    

00001319 <isspace>:

int
isspace(unsigned char c)
{
    1319:	55                   	push   %ebp
    131a:	89 e5                	mov    %esp,%ebp
    131c:	83 ec 04             	sub    $0x4,%esp
    131f:	8b 45 08             	mov    0x8(%ebp),%eax
    1322:	88 45 fc             	mov    %al,-0x4(%ebp)
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
    1325:	80 7d fc 0a          	cmpb   $0xa,-0x4(%ebp)
    1329:	74 1e                	je     1349 <isspace+0x30>
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
    132b:	80 7d fc 20          	cmpb   $0x20,-0x4(%ebp)
    132f:	74 18                	je     1349 <isspace+0x30>
    1331:	80 7d fc 0c          	cmpb   $0xc,-0x4(%ebp)
    1335:	74 12                	je     1349 <isspace+0x30>
    1337:	80 7d fc 0d          	cmpb   $0xd,-0x4(%ebp)
    133b:	74 0c                	je     1349 <isspace+0x30>
    c == '\r' || c == '\t' || c == '\v';
    133d:	80 7d fc 09          	cmpb   $0x9,-0x4(%ebp)
    1341:	74 06                	je     1349 <isspace+0x30>
    1343:	80 7d fc 0b          	cmpb   $0xb,-0x4(%ebp)
    1347:	75 07                	jne    1350 <isspace+0x37>
    1349:	b8 01 00 00 00       	mov    $0x1,%eax
    134e:	eb 05                	jmp    1355 <isspace+0x3c>
    1350:	b8 00 00 00 00       	mov    $0x0,%eax
}
    1355:	c9                   	leave  
    1356:	c3                   	ret    

00001357 <strtoul>:

uint
strtoul(char *string, char **endPtr, int base)
{
    1357:	55                   	push   %ebp
    1358:	89 e5                	mov    %esp,%ebp
    135a:	57                   	push   %edi
    135b:	56                   	push   %esi
    135c:	53                   	push   %ebx
    135d:	83 ec 14             	sub    $0x14,%esp
    register char *p;
    register unsigned long int result = 0;
    1360:	bf 00 00 00 00       	mov    $0x0,%edi
    register unsigned digit;
    int anyDigits = 0;
    1365:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

    /*
     * Skip any leading blanks.
     */

    p = string;
    136c:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    136f:	eb 01                	jmp    1372 <strtoul+0x1b>
  p += 1;
    1371:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    1372:	8a 03                	mov    (%ebx),%al
    1374:	0f b6 c0             	movzbl %al,%eax
    1377:	89 04 24             	mov    %eax,(%esp)
    137a:	e8 9a ff ff ff       	call   1319 <isspace>
    137f:	85 c0                	test   %eax,%eax
    1381:	75 ee                	jne    1371 <strtoul+0x1a>
    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
    1383:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
    1387:	75 30                	jne    13b9 <strtoul+0x62>
    {
  if (*p == '0') {
    1389:	8a 03                	mov    (%ebx),%al
    138b:	3c 30                	cmp    $0x30,%al
    138d:	75 21                	jne    13b0 <strtoul+0x59>
      p += 1;
    138f:	43                   	inc    %ebx
      if (*p == 'x') {
    1390:	8a 03                	mov    (%ebx),%al
    1392:	3c 78                	cmp    $0x78,%al
    1394:	75 0a                	jne    13a0 <strtoul+0x49>
    p += 1;
    1396:	43                   	inc    %ebx
    base = 16;
    1397:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
    139e:	eb 31                	jmp    13d1 <strtoul+0x7a>
    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
    13a0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    base = 8;
    13a7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
    13ae:	eb 21                	jmp    13d1 <strtoul+0x7a>
      }
  }
  else base = 10;
    13b0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
    13b7:	eb 18                	jmp    13d1 <strtoul+0x7a>
    } else if (base == 16) {
    13b9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    13bd:	75 12                	jne    13d1 <strtoul+0x7a>

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
    13bf:	8a 03                	mov    (%ebx),%al
    13c1:	3c 30                	cmp    $0x30,%al
    13c3:	75 0c                	jne    13d1 <strtoul+0x7a>
    13c5:	8d 43 01             	lea    0x1(%ebx),%eax
    13c8:	8a 00                	mov    (%eax),%al
    13ca:	3c 78                	cmp    $0x78,%al
    13cc:	75 03                	jne    13d1 <strtoul+0x7a>
      p += 2;
    13ce:	83 c3 02             	add    $0x2,%ebx
    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
    13d1:	83 7d 10 08          	cmpl   $0x8,0x10(%ebp)
    13d5:	75 29                	jne    1400 <strtoul+0xa9>
  for ( ; ; p += 1) {
      digit = *p - '0';
    13d7:	8a 03                	mov    (%ebx),%al
    13d9:	0f be c0             	movsbl %al,%eax
    13dc:	83 e8 30             	sub    $0x30,%eax
    13df:	89 c6                	mov    %eax,%esi
      if (digit > 7) {
    13e1:	83 fe 07             	cmp    $0x7,%esi
    13e4:	76 06                	jbe    13ec <strtoul+0x95>
    break;
    13e6:	90                   	nop
    13e7:	e9 b6 00 00 00       	jmp    14a2 <strtoul+0x14b>
      }
      result = (result << 3) + digit;
    13ec:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
    13f3:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    13f6:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
    13fd:	43                   	inc    %ebx
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    13fe:	eb d7                	jmp    13d7 <strtoul+0x80>
    } else if (base == 10) {
    1400:	83 7d 10 0a          	cmpl   $0xa,0x10(%ebp)
    1404:	75 2b                	jne    1431 <strtoul+0xda>
  for ( ; ; p += 1) {
      digit = *p - '0';
    1406:	8a 03                	mov    (%ebx),%al
    1408:	0f be c0             	movsbl %al,%eax
    140b:	83 e8 30             	sub    $0x30,%eax
    140e:	89 c6                	mov    %eax,%esi
      if (digit > 9) {
    1410:	83 fe 09             	cmp    $0x9,%esi
    1413:	76 06                	jbe    141b <strtoul+0xc4>
    break;
    1415:	90                   	nop
    1416:	e9 87 00 00 00       	jmp    14a2 <strtoul+0x14b>
      }
      result = (10*result) + digit;
    141b:	89 f8                	mov    %edi,%eax
    141d:	c1 e0 02             	shl    $0x2,%eax
    1420:	01 f8                	add    %edi,%eax
    1422:	01 c0                	add    %eax,%eax
    1424:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1427:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
    142e:	43                   	inc    %ebx
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    142f:	eb d5                	jmp    1406 <strtoul+0xaf>
    } else if (base == 16) {
    1431:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
    1435:	75 35                	jne    146c <strtoul+0x115>
  for ( ; ; p += 1) {
      digit = *p - '0';
    1437:	8a 03                	mov    (%ebx),%al
    1439:	0f be c0             	movsbl %al,%eax
    143c:	83 e8 30             	sub    $0x30,%eax
    143f:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    1441:	83 fe 4a             	cmp    $0x4a,%esi
    1444:	76 02                	jbe    1448 <strtoul+0xf1>
    break;
    1446:	eb 22                	jmp    146a <strtoul+0x113>
      }
      digit = cvtIn[digit];
    1448:	8a 86 40 24 00 00    	mov    0x2440(%esi),%al
    144e:	0f be f0             	movsbl %al,%esi
      if (digit > 15) {
    1451:	83 fe 0f             	cmp    $0xf,%esi
    1454:	76 02                	jbe    1458 <strtoul+0x101>
    break;
    1456:	eb 12                	jmp    146a <strtoul+0x113>
      }
      result = (result << 4) + digit;
    1458:	89 f8                	mov    %edi,%eax
    145a:	c1 e0 04             	shl    $0x4,%eax
    145d:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1460:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
    1467:	43                   	inc    %ebx
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    1468:	eb cd                	jmp    1437 <strtoul+0xe0>
    146a:	eb 36                	jmp    14a2 <strtoul+0x14b>
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
    146c:	8a 03                	mov    (%ebx),%al
    146e:	0f be c0             	movsbl %al,%eax
    1471:	83 e8 30             	sub    $0x30,%eax
    1474:	89 c6                	mov    %eax,%esi
      if (digit > ('z' - '0')) {
    1476:	83 fe 4a             	cmp    $0x4a,%esi
    1479:	76 02                	jbe    147d <strtoul+0x126>
    break;
    147b:	eb 25                	jmp    14a2 <strtoul+0x14b>
      }
      digit = cvtIn[digit];
    147d:	8a 86 40 24 00 00    	mov    0x2440(%esi),%al
    1483:	0f be f0             	movsbl %al,%esi
      if (digit >= base) {
    1486:	8b 45 10             	mov    0x10(%ebp),%eax
    1489:	39 f0                	cmp    %esi,%eax
    148b:	77 02                	ja     148f <strtoul+0x138>
    break;
    148d:	eb 13                	jmp    14a2 <strtoul+0x14b>
      }
      result = result*base + digit;
    148f:	8b 45 10             	mov    0x10(%ebp),%eax
    1492:	0f af c7             	imul   %edi,%eax
    1495:	8d 3c 30             	lea    (%eax,%esi,1),%edi
      anyDigits = 1;
    1498:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
    149f:	43                   	inc    %ebx
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
    14a0:	eb ca                	jmp    146c <strtoul+0x115>

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
    14a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    14a6:	75 03                	jne    14ab <strtoul+0x154>
  p = string;
    14a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
    }

    if (endPtr != 0) {
    14ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    14af:	74 05                	je     14b6 <strtoul+0x15f>
  *endPtr = p;
    14b1:	8b 45 0c             	mov    0xc(%ebp),%eax
    14b4:	89 18                	mov    %ebx,(%eax)
    }

    return result;
    14b6:	89 f8                	mov    %edi,%eax
}
    14b8:	83 c4 14             	add    $0x14,%esp
    14bb:	5b                   	pop    %ebx
    14bc:	5e                   	pop    %esi
    14bd:	5f                   	pop    %edi
    14be:	5d                   	pop    %ebp
    14bf:	c3                   	ret    

000014c0 <strtol>:

int
strtol(char *string, char **endPtr, int base)
{
    14c0:	55                   	push   %ebp
    14c1:	89 e5                	mov    %esp,%ebp
    14c3:	53                   	push   %ebx
    14c4:	83 ec 1c             	sub    $0x1c,%esp

    /*
     * Skip any leading blanks.
     */

    p = string;
    14c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    while (isspace(*p)) {
    14ca:	eb 01                	jmp    14cd <strtol+0xd>
      p += 1;
    14cc:	43                   	inc    %ebx
    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
    14cd:	8a 03                	mov    (%ebx),%al
    14cf:	0f b6 c0             	movzbl %al,%eax
    14d2:	89 04 24             	mov    %eax,(%esp)
    14d5:	e8 3f fe ff ff       	call   1319 <isspace>
    14da:	85 c0                	test   %eax,%eax
    14dc:	75 ee                	jne    14cc <strtol+0xc>

    /*
     * Check for a sign.
     */

    if (*p == '-') {
    14de:	8a 03                	mov    (%ebx),%al
    14e0:	3c 2d                	cmp    $0x2d,%al
    14e2:	75 1e                	jne    1502 <strtol+0x42>
  p += 1;
    14e4:	43                   	inc    %ebx
  result = -(strtoul(p, endPtr, base));
    14e5:	8b 45 10             	mov    0x10(%ebp),%eax
    14e8:	89 44 24 08          	mov    %eax,0x8(%esp)
    14ec:	8b 45 0c             	mov    0xc(%ebp),%eax
    14ef:	89 44 24 04          	mov    %eax,0x4(%esp)
    14f3:	89 1c 24             	mov    %ebx,(%esp)
    14f6:	e8 5c fe ff ff       	call   1357 <strtoul>
    14fb:	f7 d8                	neg    %eax
    14fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
    1500:	eb 20                	jmp    1522 <strtol+0x62>
    } else {
  if (*p == '+') {
    1502:	8a 03                	mov    (%ebx),%al
    1504:	3c 2b                	cmp    $0x2b,%al
    1506:	75 01                	jne    1509 <strtol+0x49>
      p += 1;
    1508:	43                   	inc    %ebx
  }
  result = strtoul(p, endPtr, base);
    1509:	8b 45 10             	mov    0x10(%ebp),%eax
    150c:	89 44 24 08          	mov    %eax,0x8(%esp)
    1510:	8b 45 0c             	mov    0xc(%ebp),%eax
    1513:	89 44 24 04          	mov    %eax,0x4(%esp)
    1517:	89 1c 24             	mov    %ebx,(%esp)
    151a:	e8 38 fe ff ff       	call   1357 <strtoul>
    151f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
    1522:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
    1526:	75 17                	jne    153f <strtol+0x7f>
    1528:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    152c:	74 11                	je     153f <strtol+0x7f>
    152e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1531:	8b 00                	mov    (%eax),%eax
    1533:	39 d8                	cmp    %ebx,%eax
    1535:	75 08                	jne    153f <strtol+0x7f>
  *endPtr = string;
    1537:	8b 45 0c             	mov    0xc(%ebp),%eax
    153a:	8b 55 08             	mov    0x8(%ebp),%edx
    153d:	89 10                	mov    %edx,(%eax)
    }
    return result;
    153f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
    1542:	83 c4 1c             	add    $0x1c,%esp
    1545:	5b                   	pop    %ebx
    1546:	5d                   	pop    %ebp
    1547:	c3                   	ret    

00001548 <gets>:

char*
gets(char *buf, int max)
{
    1548:	55                   	push   %ebp
    1549:	89 e5                	mov    %esp,%ebp
    154b:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    1555:	eb 49                	jmp    15a0 <gets+0x58>
    cc = read(0, &c, 1);
    1557:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    155e:	00 
    155f:	8d 45 ef             	lea    -0x11(%ebp),%eax
    1562:	89 44 24 04          	mov    %eax,0x4(%esp)
    1566:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    156d:	e8 3e 01 00 00       	call   16b0 <read>
    1572:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
    1575:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1579:	7f 02                	jg     157d <gets+0x35>
      break;
    157b:	eb 2c                	jmp    15a9 <gets+0x61>
    buf[i++] = c;
    157d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1580:	8d 50 01             	lea    0x1(%eax),%edx
    1583:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1586:	89 c2                	mov    %eax,%edx
    1588:	8b 45 08             	mov    0x8(%ebp),%eax
    158b:	01 c2                	add    %eax,%edx
    158d:	8a 45 ef             	mov    -0x11(%ebp),%al
    1590:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
    1592:	8a 45 ef             	mov    -0x11(%ebp),%al
    1595:	3c 0a                	cmp    $0xa,%al
    1597:	74 10                	je     15a9 <gets+0x61>
    1599:	8a 45 ef             	mov    -0x11(%ebp),%al
    159c:	3c 0d                	cmp    $0xd,%al
    159e:	74 09                	je     15a9 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    15a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15a3:	40                   	inc    %eax
    15a4:	3b 45 0c             	cmp    0xc(%ebp),%eax
    15a7:	7c ae                	jl     1557 <gets+0xf>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
    15a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    15ac:	8b 45 08             	mov    0x8(%ebp),%eax
    15af:	01 d0                	add    %edx,%eax
    15b1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
    15b4:	8b 45 08             	mov    0x8(%ebp),%eax
}
    15b7:	c9                   	leave  
    15b8:	c3                   	ret    

000015b9 <stat>:

int
stat(char *n, struct stat *st)
{
    15b9:	55                   	push   %ebp
    15ba:	89 e5                	mov    %esp,%ebp
    15bc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    15bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    15c6:	00 
    15c7:	8b 45 08             	mov    0x8(%ebp),%eax
    15ca:	89 04 24             	mov    %eax,(%esp)
    15cd:	e8 06 01 00 00       	call   16d8 <open>
    15d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
    15d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    15d9:	79 07                	jns    15e2 <stat+0x29>
    return -1;
    15db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    15e0:	eb 23                	jmp    1605 <stat+0x4c>
  r = fstat(fd, st);
    15e2:	8b 45 0c             	mov    0xc(%ebp),%eax
    15e5:	89 44 24 04          	mov    %eax,0x4(%esp)
    15e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15ec:	89 04 24             	mov    %eax,(%esp)
    15ef:	e8 fc 00 00 00       	call   16f0 <fstat>
    15f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
    15f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    15fa:	89 04 24             	mov    %eax,(%esp)
    15fd:	e8 be 00 00 00       	call   16c0 <close>
  return r;
    1602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1605:	c9                   	leave  
    1606:	c3                   	ret    

00001607 <atoi>:

int
atoi(const char *s)
{
    1607:	55                   	push   %ebp
    1608:	89 e5                	mov    %esp,%ebp
    160a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
    160d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
    1614:	eb 24                	jmp    163a <atoi+0x33>
    n = n*10 + *s++ - '0';
    1616:	8b 55 fc             	mov    -0x4(%ebp),%edx
    1619:	89 d0                	mov    %edx,%eax
    161b:	c1 e0 02             	shl    $0x2,%eax
    161e:	01 d0                	add    %edx,%eax
    1620:	01 c0                	add    %eax,%eax
    1622:	89 c1                	mov    %eax,%ecx
    1624:	8b 45 08             	mov    0x8(%ebp),%eax
    1627:	8d 50 01             	lea    0x1(%eax),%edx
    162a:	89 55 08             	mov    %edx,0x8(%ebp)
    162d:	8a 00                	mov    (%eax),%al
    162f:	0f be c0             	movsbl %al,%eax
    1632:	01 c8                	add    %ecx,%eax
    1634:	83 e8 30             	sub    $0x30,%eax
    1637:	89 45 fc             	mov    %eax,-0x4(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    163a:	8b 45 08             	mov    0x8(%ebp),%eax
    163d:	8a 00                	mov    (%eax),%al
    163f:	3c 2f                	cmp    $0x2f,%al
    1641:	7e 09                	jle    164c <atoi+0x45>
    1643:	8b 45 08             	mov    0x8(%ebp),%eax
    1646:	8a 00                	mov    (%eax),%al
    1648:	3c 39                	cmp    $0x39,%al
    164a:	7e ca                	jle    1616 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
    164c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
    164f:	c9                   	leave  
    1650:	c3                   	ret    

00001651 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
    1651:	55                   	push   %ebp
    1652:	89 e5                	mov    %esp,%ebp
    1654:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;

  dst = vdst;
    1657:	8b 45 08             	mov    0x8(%ebp),%eax
    165a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
    165d:	8b 45 0c             	mov    0xc(%ebp),%eax
    1660:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
    1663:	eb 16                	jmp    167b <memmove+0x2a>
    *dst++ = *src++;
    1665:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1668:	8d 50 01             	lea    0x1(%eax),%edx
    166b:	89 55 fc             	mov    %edx,-0x4(%ebp)
    166e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1671:	8d 4a 01             	lea    0x1(%edx),%ecx
    1674:	89 4d f8             	mov    %ecx,-0x8(%ebp)
    1677:	8a 12                	mov    (%edx),%dl
    1679:	88 10                	mov    %dl,(%eax)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    167b:	8b 45 10             	mov    0x10(%ebp),%eax
    167e:	8d 50 ff             	lea    -0x1(%eax),%edx
    1681:	89 55 10             	mov    %edx,0x10(%ebp)
    1684:	85 c0                	test   %eax,%eax
    1686:	7f dd                	jg     1665 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
    1688:	8b 45 08             	mov    0x8(%ebp),%eax
}
    168b:	c9                   	leave  
    168c:	c3                   	ret    
    168d:	90                   	nop
    168e:	90                   	nop
    168f:	90                   	nop

00001690 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    1690:	b8 01 00 00 00       	mov    $0x1,%eax
    1695:	cd 40                	int    $0x40
    1697:	c3                   	ret    

00001698 <exit>:
SYSCALL(exit)
    1698:	b8 02 00 00 00       	mov    $0x2,%eax
    169d:	cd 40                	int    $0x40
    169f:	c3                   	ret    

000016a0 <wait>:
SYSCALL(wait)
    16a0:	b8 03 00 00 00       	mov    $0x3,%eax
    16a5:	cd 40                	int    $0x40
    16a7:	c3                   	ret    

000016a8 <pipe>:
SYSCALL(pipe)
    16a8:	b8 04 00 00 00       	mov    $0x4,%eax
    16ad:	cd 40                	int    $0x40
    16af:	c3                   	ret    

000016b0 <read>:
SYSCALL(read)
    16b0:	b8 05 00 00 00       	mov    $0x5,%eax
    16b5:	cd 40                	int    $0x40
    16b7:	c3                   	ret    

000016b8 <write>:
SYSCALL(write)
    16b8:	b8 10 00 00 00       	mov    $0x10,%eax
    16bd:	cd 40                	int    $0x40
    16bf:	c3                   	ret    

000016c0 <close>:
SYSCALL(close)
    16c0:	b8 15 00 00 00       	mov    $0x15,%eax
    16c5:	cd 40                	int    $0x40
    16c7:	c3                   	ret    

000016c8 <kill>:
SYSCALL(kill)
    16c8:	b8 06 00 00 00       	mov    $0x6,%eax
    16cd:	cd 40                	int    $0x40
    16cf:	c3                   	ret    

000016d0 <exec>:
SYSCALL(exec)
    16d0:	b8 07 00 00 00       	mov    $0x7,%eax
    16d5:	cd 40                	int    $0x40
    16d7:	c3                   	ret    

000016d8 <open>:
SYSCALL(open)
    16d8:	b8 0f 00 00 00       	mov    $0xf,%eax
    16dd:	cd 40                	int    $0x40
    16df:	c3                   	ret    

000016e0 <mknod>:
SYSCALL(mknod)
    16e0:	b8 11 00 00 00       	mov    $0x11,%eax
    16e5:	cd 40                	int    $0x40
    16e7:	c3                   	ret    

000016e8 <unlink>:
SYSCALL(unlink)
    16e8:	b8 12 00 00 00       	mov    $0x12,%eax
    16ed:	cd 40                	int    $0x40
    16ef:	c3                   	ret    

000016f0 <fstat>:
SYSCALL(fstat)
    16f0:	b8 08 00 00 00       	mov    $0x8,%eax
    16f5:	cd 40                	int    $0x40
    16f7:	c3                   	ret    

000016f8 <link>:
SYSCALL(link)
    16f8:	b8 13 00 00 00       	mov    $0x13,%eax
    16fd:	cd 40                	int    $0x40
    16ff:	c3                   	ret    

00001700 <mkdir>:
SYSCALL(mkdir)
    1700:	b8 14 00 00 00       	mov    $0x14,%eax
    1705:	cd 40                	int    $0x40
    1707:	c3                   	ret    

00001708 <chdir>:
SYSCALL(chdir)
    1708:	b8 09 00 00 00       	mov    $0x9,%eax
    170d:	cd 40                	int    $0x40
    170f:	c3                   	ret    

00001710 <dup>:
SYSCALL(dup)
    1710:	b8 0a 00 00 00       	mov    $0xa,%eax
    1715:	cd 40                	int    $0x40
    1717:	c3                   	ret    

00001718 <getpid>:
SYSCALL(getpid)
    1718:	b8 0b 00 00 00       	mov    $0xb,%eax
    171d:	cd 40                	int    $0x40
    171f:	c3                   	ret    

00001720 <sbrk>:
SYSCALL(sbrk)
    1720:	b8 0c 00 00 00       	mov    $0xc,%eax
    1725:	cd 40                	int    $0x40
    1727:	c3                   	ret    

00001728 <sleep>:
SYSCALL(sleep)
    1728:	b8 0d 00 00 00       	mov    $0xd,%eax
    172d:	cd 40                	int    $0x40
    172f:	c3                   	ret    

00001730 <uptime>:
SYSCALL(uptime)
    1730:	b8 0e 00 00 00       	mov    $0xe,%eax
    1735:	cd 40                	int    $0x40
    1737:	c3                   	ret    

00001738 <getname>:
SYSCALL(getname)
    1738:	b8 16 00 00 00       	mov    $0x16,%eax
    173d:	cd 40                	int    $0x40
    173f:	c3                   	ret    

00001740 <setname>:
SYSCALL(setname)
    1740:	b8 17 00 00 00       	mov    $0x17,%eax
    1745:	cd 40                	int    $0x40
    1747:	c3                   	ret    

00001748 <getmaxproc>:
SYSCALL(getmaxproc)
    1748:	b8 18 00 00 00       	mov    $0x18,%eax
    174d:	cd 40                	int    $0x40
    174f:	c3                   	ret    

00001750 <setmaxproc>:
SYSCALL(setmaxproc)
    1750:	b8 19 00 00 00       	mov    $0x19,%eax
    1755:	cd 40                	int    $0x40
    1757:	c3                   	ret    

00001758 <getmaxmem>:
SYSCALL(getmaxmem)
    1758:	b8 1a 00 00 00       	mov    $0x1a,%eax
    175d:	cd 40                	int    $0x40
    175f:	c3                   	ret    

00001760 <setmaxmem>:
SYSCALL(setmaxmem)
    1760:	b8 1b 00 00 00       	mov    $0x1b,%eax
    1765:	cd 40                	int    $0x40
    1767:	c3                   	ret    

00001768 <getmaxdisk>:
SYSCALL(getmaxdisk)
    1768:	b8 1c 00 00 00       	mov    $0x1c,%eax
    176d:	cd 40                	int    $0x40
    176f:	c3                   	ret    

00001770 <setmaxdisk>:
SYSCALL(setmaxdisk)
    1770:	b8 1d 00 00 00       	mov    $0x1d,%eax
    1775:	cd 40                	int    $0x40
    1777:	c3                   	ret    

00001778 <getusedmem>:
SYSCALL(getusedmem)
    1778:	b8 1e 00 00 00       	mov    $0x1e,%eax
    177d:	cd 40                	int    $0x40
    177f:	c3                   	ret    

00001780 <setusedmem>:
SYSCALL(setusedmem)
    1780:	b8 1f 00 00 00       	mov    $0x1f,%eax
    1785:	cd 40                	int    $0x40
    1787:	c3                   	ret    

00001788 <getuseddisk>:
SYSCALL(getuseddisk)
    1788:	b8 20 00 00 00       	mov    $0x20,%eax
    178d:	cd 40                	int    $0x40
    178f:	c3                   	ret    

00001790 <setuseddisk>:
SYSCALL(setuseddisk)
    1790:	b8 21 00 00 00       	mov    $0x21,%eax
    1795:	cd 40                	int    $0x40
    1797:	c3                   	ret    

00001798 <setvc>:
SYSCALL(setvc)
    1798:	b8 22 00 00 00       	mov    $0x22,%eax
    179d:	cd 40                	int    $0x40
    179f:	c3                   	ret    

000017a0 <setactivefs>:
SYSCALL(setactivefs)
    17a0:	b8 24 00 00 00       	mov    $0x24,%eax
    17a5:	cd 40                	int    $0x40
    17a7:	c3                   	ret    

000017a8 <getactivefs>:
SYSCALL(getactivefs)
    17a8:	b8 25 00 00 00       	mov    $0x25,%eax
    17ad:	cd 40                	int    $0x40
    17af:	c3                   	ret    

000017b0 <getvcfs>:
SYSCALL(getvcfs)
    17b0:	b8 23 00 00 00       	mov    $0x23,%eax
    17b5:	cd 40                	int    $0x40
    17b7:	c3                   	ret    

000017b8 <getcwd>:
SYSCALL(getcwd)
    17b8:	b8 26 00 00 00       	mov    $0x26,%eax
    17bd:	cd 40                	int    $0x40
    17bf:	c3                   	ret    

000017c0 <tostring>:
SYSCALL(tostring)
    17c0:	b8 27 00 00 00       	mov    $0x27,%eax
    17c5:	cd 40                	int    $0x40
    17c7:	c3                   	ret    

000017c8 <getactivefsindex>:
SYSCALL(getactivefsindex)
    17c8:	b8 28 00 00 00       	mov    $0x28,%eax
    17cd:	cd 40                	int    $0x40
    17cf:	c3                   	ret    

000017d0 <setatroot>:
SYSCALL(setatroot)
    17d0:	b8 2a 00 00 00       	mov    $0x2a,%eax
    17d5:	cd 40                	int    $0x40
    17d7:	c3                   	ret    

000017d8 <getatroot>:
SYSCALL(getatroot)
    17d8:	b8 29 00 00 00       	mov    $0x29,%eax
    17dd:	cd 40                	int    $0x40
    17df:	c3                   	ret    

000017e0 <getpath>:
SYSCALL(getpath)
    17e0:	b8 2b 00 00 00       	mov    $0x2b,%eax
    17e5:	cd 40                	int    $0x40
    17e7:	c3                   	ret    

000017e8 <setpath>:
SYSCALL(setpath)
    17e8:	b8 2c 00 00 00       	mov    $0x2c,%eax
    17ed:	cd 40                	int    $0x40
    17ef:	c3                   	ret    

000017f0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    17f0:	55                   	push   %ebp
    17f1:	89 e5                	mov    %esp,%ebp
    17f3:	83 ec 18             	sub    $0x18,%esp
    17f6:	8b 45 0c             	mov    0xc(%ebp),%eax
    17f9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
    17fc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
    1803:	00 
    1804:	8d 45 f4             	lea    -0xc(%ebp),%eax
    1807:	89 44 24 04          	mov    %eax,0x4(%esp)
    180b:	8b 45 08             	mov    0x8(%ebp),%eax
    180e:	89 04 24             	mov    %eax,(%esp)
    1811:	e8 a2 fe ff ff       	call   16b8 <write>
}
    1816:	c9                   	leave  
    1817:	c3                   	ret    

00001818 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1818:	55                   	push   %ebp
    1819:	89 e5                	mov    %esp,%ebp
    181b:	56                   	push   %esi
    181c:	53                   	push   %ebx
    181d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
    1820:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
    1827:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
    182b:	74 17                	je     1844 <printint+0x2c>
    182d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
    1831:	79 11                	jns    1844 <printint+0x2c>
    neg = 1;
    1833:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
    183a:	8b 45 0c             	mov    0xc(%ebp),%eax
    183d:	f7 d8                	neg    %eax
    183f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1842:	eb 06                	jmp    184a <printint+0x32>
  } else {
    x = xx;
    1844:	8b 45 0c             	mov    0xc(%ebp),%eax
    1847:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
    184a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
    1851:	8b 4d f4             	mov    -0xc(%ebp),%ecx
    1854:	8d 41 01             	lea    0x1(%ecx),%eax
    1857:	89 45 f4             	mov    %eax,-0xc(%ebp)
    185a:	8b 5d 10             	mov    0x10(%ebp),%ebx
    185d:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1860:	ba 00 00 00 00       	mov    $0x0,%edx
    1865:	f7 f3                	div    %ebx
    1867:	89 d0                	mov    %edx,%eax
    1869:	8a 80 8c 24 00 00    	mov    0x248c(%eax),%al
    186f:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
    1873:	8b 75 10             	mov    0x10(%ebp),%esi
    1876:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1879:	ba 00 00 00 00       	mov    $0x0,%edx
    187e:	f7 f6                	div    %esi
    1880:	89 45 ec             	mov    %eax,-0x14(%ebp)
    1883:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1887:	75 c8                	jne    1851 <printint+0x39>
  if(neg)
    1889:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    188d:	74 10                	je     189f <printint+0x87>
    buf[i++] = '-';
    188f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1892:	8d 50 01             	lea    0x1(%eax),%edx
    1895:	89 55 f4             	mov    %edx,-0xc(%ebp)
    1898:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
    189d:	eb 1e                	jmp    18bd <printint+0xa5>
    189f:	eb 1c                	jmp    18bd <printint+0xa5>
    putc(fd, buf[i]);
    18a1:	8d 55 dc             	lea    -0x24(%ebp),%edx
    18a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    18a7:	01 d0                	add    %edx,%eax
    18a9:	8a 00                	mov    (%eax),%al
    18ab:	0f be c0             	movsbl %al,%eax
    18ae:	89 44 24 04          	mov    %eax,0x4(%esp)
    18b2:	8b 45 08             	mov    0x8(%ebp),%eax
    18b5:	89 04 24             	mov    %eax,(%esp)
    18b8:	e8 33 ff ff ff       	call   17f0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
    18bd:	ff 4d f4             	decl   -0xc(%ebp)
    18c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    18c4:	79 db                	jns    18a1 <printint+0x89>
    putc(fd, buf[i]);
}
    18c6:	83 c4 30             	add    $0x30,%esp
    18c9:	5b                   	pop    %ebx
    18ca:	5e                   	pop    %esi
    18cb:	5d                   	pop    %ebp
    18cc:	c3                   	ret    

000018cd <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
    18cd:	55                   	push   %ebp
    18ce:	89 e5                	mov    %esp,%ebp
    18d0:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
    18d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
    18da:	8d 45 0c             	lea    0xc(%ebp),%eax
    18dd:	83 c0 04             	add    $0x4,%eax
    18e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
    18e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    18ea:	e9 77 01 00 00       	jmp    1a66 <printf+0x199>
    c = fmt[i] & 0xff;
    18ef:	8b 55 0c             	mov    0xc(%ebp),%edx
    18f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    18f5:	01 d0                	add    %edx,%eax
    18f7:	8a 00                	mov    (%eax),%al
    18f9:	0f be c0             	movsbl %al,%eax
    18fc:	25 ff 00 00 00       	and    $0xff,%eax
    1901:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
    1904:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
    1908:	75 2c                	jne    1936 <printf+0x69>
      if(c == '%'){
    190a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    190e:	75 0c                	jne    191c <printf+0x4f>
        state = '%';
    1910:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
    1917:	e9 47 01 00 00       	jmp    1a63 <printf+0x196>
      } else {
        putc(fd, c);
    191c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    191f:	0f be c0             	movsbl %al,%eax
    1922:	89 44 24 04          	mov    %eax,0x4(%esp)
    1926:	8b 45 08             	mov    0x8(%ebp),%eax
    1929:	89 04 24             	mov    %eax,(%esp)
    192c:	e8 bf fe ff ff       	call   17f0 <putc>
    1931:	e9 2d 01 00 00       	jmp    1a63 <printf+0x196>
      }
    } else if(state == '%'){
    1936:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
    193a:	0f 85 23 01 00 00    	jne    1a63 <printf+0x196>
      if(c == 'd'){
    1940:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
    1944:	75 2d                	jne    1973 <printf+0xa6>
        printint(fd, *ap, 10, 1);
    1946:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1949:	8b 00                	mov    (%eax),%eax
    194b:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
    1952:	00 
    1953:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
    195a:	00 
    195b:	89 44 24 04          	mov    %eax,0x4(%esp)
    195f:	8b 45 08             	mov    0x8(%ebp),%eax
    1962:	89 04 24             	mov    %eax,(%esp)
    1965:	e8 ae fe ff ff       	call   1818 <printint>
        ap++;
    196a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    196e:	e9 e9 00 00 00       	jmp    1a5c <printf+0x18f>
      } else if(c == 'x' || c == 'p'){
    1973:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
    1977:	74 06                	je     197f <printf+0xb2>
    1979:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
    197d:	75 2d                	jne    19ac <printf+0xdf>
        printint(fd, *ap, 16, 0);
    197f:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1982:	8b 00                	mov    (%eax),%eax
    1984:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
    198b:	00 
    198c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1993:	00 
    1994:	89 44 24 04          	mov    %eax,0x4(%esp)
    1998:	8b 45 08             	mov    0x8(%ebp),%eax
    199b:	89 04 24             	mov    %eax,(%esp)
    199e:	e8 75 fe ff ff       	call   1818 <printint>
        ap++;
    19a3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    19a7:	e9 b0 00 00 00       	jmp    1a5c <printf+0x18f>
      } else if(c == 's'){
    19ac:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    19b0:	75 42                	jne    19f4 <printf+0x127>
        s = (char*)*ap;
    19b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
    19b5:	8b 00                	mov    (%eax),%eax
    19b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    19ba:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    19be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    19c2:	75 09                	jne    19cd <printf+0x100>
          s = "(null)";
    19c4:	c7 45 f4 03 1e 00 00 	movl   $0x1e03,-0xc(%ebp)
        while(*s != 0){
    19cb:	eb 1c                	jmp    19e9 <printf+0x11c>
    19cd:	eb 1a                	jmp    19e9 <printf+0x11c>
          putc(fd, *s);
    19cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19d2:	8a 00                	mov    (%eax),%al
    19d4:	0f be c0             	movsbl %al,%eax
    19d7:	89 44 24 04          	mov    %eax,0x4(%esp)
    19db:	8b 45 08             	mov    0x8(%ebp),%eax
    19de:	89 04 24             	mov    %eax,(%esp)
    19e1:	e8 0a fe ff ff       	call   17f0 <putc>
          s++;
    19e6:	ff 45 f4             	incl   -0xc(%ebp)
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    19e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    19ec:	8a 00                	mov    (%eax),%al
    19ee:	84 c0                	test   %al,%al
    19f0:	75 dd                	jne    19cf <printf+0x102>
    19f2:	eb 68                	jmp    1a5c <printf+0x18f>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    19f4:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    19f8:	75 1d                	jne    1a17 <printf+0x14a>
        putc(fd, *ap);
    19fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
    19fd:	8b 00                	mov    (%eax),%eax
    19ff:	0f be c0             	movsbl %al,%eax
    1a02:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a06:	8b 45 08             	mov    0x8(%ebp),%eax
    1a09:	89 04 24             	mov    %eax,(%esp)
    1a0c:	e8 df fd ff ff       	call   17f0 <putc>
        ap++;
    1a11:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1a15:	eb 45                	jmp    1a5c <printf+0x18f>
      } else if(c == '%'){
    1a17:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1a1b:	75 17                	jne    1a34 <printf+0x167>
        putc(fd, c);
    1a1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1a20:	0f be c0             	movsbl %al,%eax
    1a23:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a27:	8b 45 08             	mov    0x8(%ebp),%eax
    1a2a:	89 04 24             	mov    %eax,(%esp)
    1a2d:	e8 be fd ff ff       	call   17f0 <putc>
    1a32:	eb 28                	jmp    1a5c <printf+0x18f>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1a34:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1a3b:	00 
    1a3c:	8b 45 08             	mov    0x8(%ebp),%eax
    1a3f:	89 04 24             	mov    %eax,(%esp)
    1a42:	e8 a9 fd ff ff       	call   17f0 <putc>
        putc(fd, c);
    1a47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1a4a:	0f be c0             	movsbl %al,%eax
    1a4d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1a51:	8b 45 08             	mov    0x8(%ebp),%eax
    1a54:	89 04 24             	mov    %eax,(%esp)
    1a57:	e8 94 fd ff ff       	call   17f0 <putc>
      }
      state = 0;
    1a5c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1a63:	ff 45 f0             	incl   -0x10(%ebp)
    1a66:	8b 55 0c             	mov    0xc(%ebp),%edx
    1a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1a6c:	01 d0                	add    %edx,%eax
    1a6e:	8a 00                	mov    (%eax),%al
    1a70:	84 c0                	test   %al,%al
    1a72:	0f 85 77 fe ff ff    	jne    18ef <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1a78:	c9                   	leave  
    1a79:	c3                   	ret    
    1a7a:	90                   	nop
    1a7b:	90                   	nop

00001a7c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1a7c:	55                   	push   %ebp
    1a7d:	89 e5                	mov    %esp,%ebp
    1a7f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1a82:	8b 45 08             	mov    0x8(%ebp),%eax
    1a85:	83 e8 08             	sub    $0x8,%eax
    1a88:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1a8b:	a1 14 25 00 00       	mov    0x2514,%eax
    1a90:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1a93:	eb 24                	jmp    1ab9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1a95:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1a98:	8b 00                	mov    (%eax),%eax
    1a9a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1a9d:	77 12                	ja     1ab1 <free+0x35>
    1a9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1aa2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1aa5:	77 24                	ja     1acb <free+0x4f>
    1aa7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1aaa:	8b 00                	mov    (%eax),%eax
    1aac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1aaf:	77 1a                	ja     1acb <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1ab4:	8b 00                	mov    (%eax),%eax
    1ab6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1ab9:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1abc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1abf:	76 d4                	jbe    1a95 <free+0x19>
    1ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1ac4:	8b 00                	mov    (%eax),%eax
    1ac6:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1ac9:	76 ca                	jbe    1a95 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1acb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1ace:	8b 40 04             	mov    0x4(%eax),%eax
    1ad1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1ad8:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1adb:	01 c2                	add    %eax,%edx
    1add:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1ae0:	8b 00                	mov    (%eax),%eax
    1ae2:	39 c2                	cmp    %eax,%edx
    1ae4:	75 24                	jne    1b0a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
    1ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1ae9:	8b 50 04             	mov    0x4(%eax),%edx
    1aec:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1aef:	8b 00                	mov    (%eax),%eax
    1af1:	8b 40 04             	mov    0x4(%eax),%eax
    1af4:	01 c2                	add    %eax,%edx
    1af6:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1af9:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1afc:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1aff:	8b 00                	mov    (%eax),%eax
    1b01:	8b 10                	mov    (%eax),%edx
    1b03:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b06:	89 10                	mov    %edx,(%eax)
    1b08:	eb 0a                	jmp    1b14 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
    1b0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b0d:	8b 10                	mov    (%eax),%edx
    1b0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b12:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1b14:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b17:	8b 40 04             	mov    0x4(%eax),%eax
    1b1a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
    1b21:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b24:	01 d0                	add    %edx,%eax
    1b26:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1b29:	75 20                	jne    1b4b <free+0xcf>
    p->s.size += bp->s.size;
    1b2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b2e:	8b 50 04             	mov    0x4(%eax),%edx
    1b31:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b34:	8b 40 04             	mov    0x4(%eax),%eax
    1b37:	01 c2                	add    %eax,%edx
    1b39:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b3c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1b3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1b42:	8b 10                	mov    (%eax),%edx
    1b44:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b47:	89 10                	mov    %edx,(%eax)
    1b49:	eb 08                	jmp    1b53 <free+0xd7>
  } else
    p->s.ptr = bp;
    1b4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b4e:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1b51:	89 10                	mov    %edx,(%eax)
  freep = p;
    1b53:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1b56:	a3 14 25 00 00       	mov    %eax,0x2514
}
    1b5b:	c9                   	leave  
    1b5c:	c3                   	ret    

00001b5d <morecore>:

static Header*
morecore(uint nu)
{
    1b5d:	55                   	push   %ebp
    1b5e:	89 e5                	mov    %esp,%ebp
    1b60:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1b63:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1b6a:	77 07                	ja     1b73 <morecore+0x16>
    nu = 4096;
    1b6c:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1b73:	8b 45 08             	mov    0x8(%ebp),%eax
    1b76:	c1 e0 03             	shl    $0x3,%eax
    1b79:	89 04 24             	mov    %eax,(%esp)
    1b7c:	e8 9f fb ff ff       	call   1720 <sbrk>
    1b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    1b84:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    1b88:	75 07                	jne    1b91 <morecore+0x34>
    return 0;
    1b8a:	b8 00 00 00 00       	mov    $0x0,%eax
    1b8f:	eb 22                	jmp    1bb3 <morecore+0x56>
  hp = (Header*)p;
    1b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1b94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1b9a:	8b 55 08             	mov    0x8(%ebp),%edx
    1b9d:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    1ba0:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1ba3:	83 c0 08             	add    $0x8,%eax
    1ba6:	89 04 24             	mov    %eax,(%esp)
    1ba9:	e8 ce fe ff ff       	call   1a7c <free>
  return freep;
    1bae:	a1 14 25 00 00       	mov    0x2514,%eax
}
    1bb3:	c9                   	leave  
    1bb4:	c3                   	ret    

00001bb5 <malloc>:

void*
malloc(uint nbytes)
{
    1bb5:	55                   	push   %ebp
    1bb6:	89 e5                	mov    %esp,%ebp
    1bb8:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1bbb:	8b 45 08             	mov    0x8(%ebp),%eax
    1bbe:	83 c0 07             	add    $0x7,%eax
    1bc1:	c1 e8 03             	shr    $0x3,%eax
    1bc4:	40                   	inc    %eax
    1bc5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1bc8:	a1 14 25 00 00       	mov    0x2514,%eax
    1bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1bd0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1bd4:	75 23                	jne    1bf9 <malloc+0x44>
    base.s.ptr = freep = prevp = &base;
    1bd6:	c7 45 f0 0c 25 00 00 	movl   $0x250c,-0x10(%ebp)
    1bdd:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1be0:	a3 14 25 00 00       	mov    %eax,0x2514
    1be5:	a1 14 25 00 00       	mov    0x2514,%eax
    1bea:	a3 0c 25 00 00       	mov    %eax,0x250c
    base.s.size = 0;
    1bef:	c7 05 10 25 00 00 00 	movl   $0x0,0x2510
    1bf6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1bf9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1bfc:	8b 00                	mov    (%eax),%eax
    1bfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1c01:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c04:	8b 40 04             	mov    0x4(%eax),%eax
    1c07:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1c0a:	72 4d                	jb     1c59 <malloc+0xa4>
      if(p->s.size == nunits)
    1c0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c0f:	8b 40 04             	mov    0x4(%eax),%eax
    1c12:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1c15:	75 0c                	jne    1c23 <malloc+0x6e>
        prevp->s.ptr = p->s.ptr;
    1c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c1a:	8b 10                	mov    (%eax),%edx
    1c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c1f:	89 10                	mov    %edx,(%eax)
    1c21:	eb 26                	jmp    1c49 <malloc+0x94>
      else {
        p->s.size -= nunits;
    1c23:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c26:	8b 40 04             	mov    0x4(%eax),%eax
    1c29:	2b 45 ec             	sub    -0x14(%ebp),%eax
    1c2c:	89 c2                	mov    %eax,%edx
    1c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c31:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1c34:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c37:	8b 40 04             	mov    0x4(%eax),%eax
    1c3a:	c1 e0 03             	shl    $0x3,%eax
    1c3d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c43:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1c46:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1c49:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1c4c:	a3 14 25 00 00       	mov    %eax,0x2514
      return (void*)(p + 1);
    1c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c54:	83 c0 08             	add    $0x8,%eax
    1c57:	eb 38                	jmp    1c91 <malloc+0xdc>
    }
    if(p == freep)
    1c59:	a1 14 25 00 00       	mov    0x2514,%eax
    1c5e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1c61:	75 1b                	jne    1c7e <malloc+0xc9>
      if((p = morecore(nunits)) == 0)
    1c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1c66:	89 04 24             	mov    %eax,(%esp)
    1c69:	e8 ef fe ff ff       	call   1b5d <morecore>
    1c6e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1c71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1c75:	75 07                	jne    1c7e <malloc+0xc9>
        return 0;
    1c77:	b8 00 00 00 00       	mov    $0x0,%eax
    1c7c:	eb 13                	jmp    1c91 <malloc+0xdc>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1c7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c81:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1c87:	8b 00                	mov    (%eax),%eax
    1c89:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    1c8c:	e9 70 ff ff ff       	jmp    1c01 <malloc+0x4c>
}
    1c91:	c9                   	leave  
    1c92:	c3                   	ret    
