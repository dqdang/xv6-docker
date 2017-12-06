#include "types.h"
#include "stat.h"
#include "fcntl.h"
#include "user.h"
#include "x86.h"
#include "container.h"

void *NULL = 0;

static char cvtIn[] = {
    0, 1, 2, 3, 4, 5, 6, 7, 8, 9,   /* '0' - '9' */
    100, 100, 100, 100, 100, 100, 100,    /* punctuation */
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, /* 'A' - 'Z' */
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35,
    100, 100, 100, 100, 100, 100,   /* punctuation */
    10, 11, 12, 13, 14, 15, 16, 17, 18, 19, /* 'a' - 'z' */
    20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
    30, 31, 32, 33, 34, 35};

char*
strcpy(char *s, char *t)
{
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    ;
  return os;
}

char *spaces(int amount, char spaces[]){
  int i;
  spaces[0] = ' ';
  for(i = 1; i <= amount-1; i++){
    spaces[i] = ' ';
  }
  spaces[i] = '\0';

  return spaces;
}

int 
copy(char *inputfile, char *outputfile){//, int used_disk, int max_disk)

  int fd1, fd2, count, bytes = 0;
  char buffer[32];
      
  if((fd1 = open(inputfile, O_RDONLY)) < 0)
  {
      printf(1, "Cannot open inputfile: %s\n", inputfile);
      exit();
  }
  if((fd2 = open(outputfile, O_CREATE | O_WRONLY)) < 0)
  {
      printf(1, "Cannot open outputfile: %s\n", outputfile);
      exit();
  }

  while((count = read(fd1, buffer, 32)) > 0)
  {
      // max = used_disk+=count;
      // if(max > max_disk)
      // {
      //   return -1;
      // }
      bytes = bytes + count;
      write(fd2, buffer, 32);
  }

  close(fd1);
  close(fd2);
  return(bytes);
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
    p++, q++;
  return (uchar)*p - (uchar)*q;
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
    ;
  return n;
}

void*
memset(void *dst, int c, uint n)
{
  stosb(dst, c, n);
  return dst;
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
    if(*s == c)
      return (char*)s;
  return 0;
}

char *
strcat(char *dest, const char *src)
{
    int i,j;
    for (i = 0; dest[i] != '\0'; i++)
        ;
    for (j = 0; src[j] != '\0'; j++)
        dest[i+j] = src[j];
    dest[i+j] = '\0';
    return dest;
}

int 
strstr(char* s, char* sub)
{
    int i, j;

    for(i = 0; s[i] != '\0'; i++)
    {
        if(s[i] == sub[0])
        {
            if(strlen(sub) == 1)
            {  
                return i;
            }
            for(j = 1; sub[j] != '\0'; j++)
            {
                if(s[i + j] == sub[j])
                {
                    if(sub[j + 1] == '\0')
                    {
                        return i;
                    }
                }
                else
                {
                    break;
                }
            }
        }
     }
     return -1;
}

char *
strtok(char *s, const char *delim)
{
    static char *lasts;
    register int ch;

    if (s == 0)
  s = lasts;
    do {
  if ((ch = *s++) == '\0')
      return 0;
    } while (strchr(delim, ch));
    --s;
    lasts = s + strcspn(s, delim);
    if (*lasts != 0)
  *lasts++ = 0;
    return s;
}

int
strcspn(const char *s1, const char *s2)
{
    int ret=0;
    while(*s1)
        if(strchr(s2,*s1))
            return ret;
        else
            s1++,ret++;
    return ret;
}

int
isspace(unsigned char c)
{
    return c == '\n' || c == ' ' || c == '\f' ||
    c == '\r' || c == '\t' || c == '\v';
}

uint
strtoul(char *string, char **endPtr, int base)
{
    register char *p;
    register unsigned long int result = 0;
    register unsigned digit;
    int anyDigits = 0;

    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
  p += 1;
    }

    /*
     * If no base was provided, pick one from the leading characters
     * of the string.
     */
    
    if (base == 0)
    {
  if (*p == '0') {
      p += 1;
      if (*p == 'x') {
    p += 1;
    base = 16;
      } else {

    /*
     * Must set anyDigits here, otherwise "0" produces a
     * "no digits" error.
     */

    anyDigits = 1;
    base = 8;
      }
  }
  else base = 10;
    } else if (base == 16) {

  /*
   * Skip a leading "0x" from hex numbers.
   */

  if ((p[0] == '0') && (p[1] == 'x')) {
      p += 2;
  }
    }

    /*
     * Sorry this code is so messy, but speed seems important.  Do
     * different things for base 8, 10, 16, and other.
     */

    if (base == 8) {
  for ( ; ; p += 1) {
      digit = *p - '0';
      if (digit > 7) {
    break;
      }
      result = (result << 3) + digit;
      anyDigits = 1;
  }
    } else if (base == 10) {
  for ( ; ; p += 1) {
      digit = *p - '0';
      if (digit > 9) {
    break;
      }
      result = (10*result) + digit;
      anyDigits = 1;
  }
    } else if (base == 16) {
  for ( ; ; p += 1) {
      digit = *p - '0';
      if (digit > ('z' - '0')) {
    break;
      }
      digit = cvtIn[digit];
      if (digit > 15) {
    break;
      }
      result = (result << 4) + digit;
      anyDigits = 1;
  }
    } else {
  for ( ; ; p += 1) {
      digit = *p - '0';
      if (digit > ('z' - '0')) {
    break;
      }
      digit = cvtIn[digit];
      if (digit >= base) {
    break;
      }
      result = result*base + digit;
      anyDigits = 1;
  }
    }

    /*
     * See if there were any digits at all.
     */

    if (!anyDigits) {
  p = string;
    }

    if (endPtr != 0) {
  *endPtr = p;
    }

    return result;
}

int
strtol(char *string, char **endPtr, int base)
{
    register char *p;
    int result;

    /*
     * Skip any leading blanks.
     */

    p = string;
    while (isspace(*p)) {
      p += 1;
    }

    /*
     * Check for a sign.
     */

    if (*p == '-') {
  p += 1;
  result = -(strtoul(p, endPtr, base));
    } else {
  if (*p == '+') {
      p += 1;
  }
  result = strtoul(p, endPtr, base);
    }
    if ((result == 0) && (endPtr != 0) && (*endPtr == p)) {
  *endPtr = string;
    }
    return result;
}

char*
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
  return buf;
}

int
stat(char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
  close(fd);
  return r;
}

int
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    n = n*10 + *s++ - '0';
  return n;
}

void
itoa(int num, char* str, int base)
{
    char temp;
    int rem, i = 0, j = 0;
 
    if (num == 0)
    {
        str[i++] = '0';
        str[i] = '\0';
        return;
    }
    while (num != 0)
    {
        rem = num % base;
        if(rem > 9)
        {
            rem = rem - 10;
        }
        str[i++] = rem + '0';
        num = num/base;
    }
    str[i] = '\0';
    for(j = 0; j < i / 2; j++)
    {
        temp = str[j];
        str[j] = str[i - j - 1];
        str[i - j - 1] = temp;
    }
    return;
}

void*
memmove(void *vdst, void *vsrc, int n)
{
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    *dst++ = *src++;
  return vdst;
}

int 
isfscmd(char* cmd){
  if(strcmp(cmd, "mkdir") == 0 || strcmp(cmd, "ls") == 0){
    return 1;
  }return 0;
}

int
addedcpath(char *cmd){
  char temp_path[128];
  strcpy(temp_path, cmd);
  strcat(temp_path, "\0");
  char fs[32];
  getactivefs(fs);
  char *tok_currpath = strtok(temp_path, "/");

  return (strcmp(&fs[1], tok_currpath) == 0);
}

int
ifsafepath(char *path){

  char temp_path[128];
  if(path == 0){
    return 1;
  }
  int path_len = 0;
  int new_path_len;
  strcpy(temp_path, path);
  strcat(temp_path, "\0");
  char *tok_path = temp_path;
  char currpath[256];
  int index = getactivefsindex();
  getpath(index, currpath);
  char *tok_currpath = strtok(currpath, "/");

  while(tok_currpath != 0){
    path_len++;
    tok_currpath = strtok(0, "/");
  }

  if(path[0] != '/'){
    new_path_len = path_len;
  }else{
    new_path_len = 0;
  }

  tok_path = strtok(tok_path, "/");
  while (tok_path != 0){
    if(strcmp(tok_path, "..") == 0){
      new_path_len--;
    }else{
      new_path_len++;
    }
    tok_path = strtok(0, "/");
  }

  return new_path_len > 0;
}


