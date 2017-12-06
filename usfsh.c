/* usfsh.c - simple shell */
#include "stdbool.h"
#include "stdarg.h"
#include "stddef.h"
#include "types.h"
#include "user.h"
#include "fcntl.h"
#include "fs.h"
#include "stat.h"
#include "param.h"
#include "debug.h"
#include "list.h"

#define HISTORY_SIZE 10
#define MAX_ARGS 256
#define MAX_CMD_LEN 512

struct cmd_node *new_cmd_node(char cmd[], int history_number);
int starts_with(const char *pre, const char *str);
int is_shell_command(char *cmd);
void print_prompt(int *command_counter);
void read_line(char *line);
void trim(char *input);
void parse_args(char *cmd, char *delimit, char **argv);
struct cmd_node *find_using_number(int cmd);
struct cmd_node *find_using_string(char *cmd);
struct cmd_node *find_in_history(char *buf);
void exec_history(struct cmd_node *cn);
void print_history();
int add_to_history(char *buf, int history_number);
void clear_history();
int redirect_output(char **argv);
void exec_command(char *cmd);
void exec_pipe(char *cmd);
void pipe_command(char *buf);
int exec_shell_command(char *buf);
int process_one_command(int *command_counter);

struct list history;

struct cmd_node
{
    struct list_elem elem;
    int history_number;
    char cmd[MAX_CMD_LEN];
};

struct cmd_node *new_cmd_node(char cmd[], int history_number)
{
    int i, len;
    struct cmd_node *cn;

    cn = (struct cmd_node *) malloc(sizeof(struct cmd_node));
    if(cn == 0)
    {
        printf(1, "new_cmd_node(): Cannot malloc. Exiting\n");
        exit();
    }

    len = strlen(cmd);
    for(i = 0; i < len; i++)
    {
        cn->cmd[i] = cmd[i];
    }
    cn->cmd[i] = '\0';

    cn->history_number = history_number;

    return cn;
}

int starts_with(const char *pre, const char *str)
{
    int lenpre = strlen(pre);
    int lenstr = strlen(str);
    
    /* Compare the prefix with the string */
    return lenstr < lenpre ? 0 : strncmp(pre, str, lenpre) == 0;
}

int is_shell_command(char *cmd)
{
    return (strcmp(cmd, "cd") == 0) ||
     (strcmp(cmd, "history") == 0) || 
     (strcmp(cmd, "exit") == 0) || 
     (starts_with("cd ", cmd)) ||
     (cmd[0] == '!' && cmd[1] != ' ');
}

void print_prompt(int *command_counter)
{
    int len;
    char num_string[9];
    char prompt[MAX_CMD_LEN];

    itoa(*command_counter, num_string, 10);
    strcpy(prompt, "[");
    strcat(prompt, num_string);
    strcat(prompt, "]$ ");

    len = strlen(prompt);
    write(1, prompt, len);
}

void read_line(char *line)
{
    int i = 0;
    char buf[1];
    
    while(read(0, buf, 1) > 0) 
    {
        if(buf[0] == '\n')
        {
            break;
        }

        line[i] = buf[0];
        i = i + 1;

        if(i > (MAX_CMD_LEN - 1))
        {
            break;
        }
    }

    line[i] = '\0';
}

void trim(char *str)
{
    int i, begin = 0, end = strlen(str) - 1;

    /* delete beginning white spaces */
    while(isspace((unsigned char) str[begin]))
    {
        begin++;
    }

    /* delete end white spaces */
    while ((end >= begin) && isspace((unsigned char) str[end]))
    {
        end--;
    }

    /* Shift all characters back to the start of the string array. */
    for (i = begin; i <= end; i++)
    {
        str[i - begin] = str[i];
    }

    str[i - begin] = '\0';
}

void parse_args(char *cmd, char *delimit, char **argv)
{
    int counter = 0;
    char delimiter[2];
    char buf[MAX_CMD_LEN];
    char *token;

    strcpy(buf, cmd);
    strcpy(delimiter, delimit);
    token = strtok(buf, delimiter);
    argv[counter++] = token;

    while(token != 0)
    {
        token = strtok(0, delimiter);
        if(token != 0)
        {
            trim(token);
        }
        argv[counter++] = token;
    }
}

struct cmd_node *find_using_number(int cmd)
{
    struct list_elem *e;
    struct cmd_node *cn;

    for(e = list_begin(&history); e != list_end(&history); e = list_next(e))
    {
        cn = list_entry(e, struct cmd_node, elem);
        if(cn->history_number == cmd)
        {
            return cn;
        }
    }

    return 0;
}

struct cmd_node *find_using_string(char *cmd)
{
    struct list_elem *e;
    struct cmd_node *cn;

    for(e = list_end(&history); e != list_begin(&history); e = list_prev(e))
    {
        cn = list_entry(e, struct cmd_node, elem);
        if(starts_with(cmd, cn->cmd))
        {
            return cn;
        }
    }

    return 0;
}

struct cmd_node *find_in_history(char *buf)
{
    int i = 0, cmd_number;
    while(buf[++i] == '!');
    char *cmd = &buf[i];
    struct cmd_node *cn;

    if((cmd_number = strtol(cmd, 0, 10)))
    {
        cn = find_using_number(cmd_number);
    }
    else if(strcmp(cmd, "0") == 0)
    {
        cmd_number = 0;
        cn = find_using_number(cmd_number);
    }
    else
    {
        cn = find_using_string(cmd);
    }

    return cn;
}

void exec_history(struct cmd_node *cn)
{
    if(strstr(cn->cmd, "|") > 0)
    {
        pipe_command(cn->cmd);
    }
    else if(is_shell_command(cn->cmd))
    {
        exec_shell_command(cn->cmd);
    }
    else
    {
        exec_command(cn->cmd);
    }
}

void print_history()
{
    struct list_elem *e;
    struct cmd_node *cn, *end;
    for(e = list_begin(&history); e != list_end(&history); e = list_next(e))
    {
        cn = list_entry(e, struct cmd_node, elem);
        end = list_entry(list_end(&history), struct cmd_node, elem);
        if(cn->history_number > end->history_number - HISTORY_SIZE)
        {
            printf(1, " %d  %s\n", cn->history_number, cn->cmd);
        }
    }
}

int add_to_history(char *buf, int history_number)
{
    int i;
    char cmd[MAX_CMD_LEN];
    struct cmd_node *cn;

    /* Find the line in history to match the command,
       otherwise will be !# or !xxx... */
    if(buf[0] == '!' && buf[1] != ' ')
    {
        cn = find_in_history(buf);
        if(cn != 0)
        {
            for(i = 0; cn->cmd[i] != '\0'; i++)
            {
                cmd[i] = cn->cmd[i];
            }
            cn = new_cmd_node(cmd, history_number);
        }
        else
        {
            printf(1, "%s: event not found!\n", buf);
            return 0;
        }
    }
    else
    {
        cn = new_cmd_node(buf, history_number);
    }

    list_push_back(&history, &cn->elem);

    return 1;
}

void clear_history()
{
    struct cmd_node *delete;
    
    while(!list_empty(&history))
    {
        delete = list_entry(list_pop_front(&history), struct cmd_node, elem);
        free(delete);
    }
}

int redirect_output(char **argv)
{
    int fd = 1, i = 1;

    while(argv[i - 1] != 0)
    {
        if(strcmp(argv[i - 1], ">") == 0)
        {
            unlink(argv[i]);
            if((fd = open(argv[i], O_CREATE | O_RDWR)) < 0)
            {
                printf(1, "Cannot open %s\n", argv[i]);
                exit();
            }

            /* Set rest of arguments to 0. */
            argv[i - 1] = 0;
            while(argv[i] != 0)
            {
                argv[i++] = 0;
            }
            break;
        }
        i++;
    }

    return fd;
}

void exec_command(char *cmd)
{
    int id, fd;
    char fs[32], new_path[32];
    char *argv[MAX_ARGS];

    parse_args(cmd, " ", argv);

    fd = redirect_output(argv);
    id = fork(0);

    if(id == 0)
    {
        if(fd != 1)
        {
            close(1);
            dup(fd);
            close(fd);
        }
        if(isfscmd(argv[0]))
        {
            if(argv[1][0] == '/' && !addedcpath(argv[1]))
            {
                char fs[32];
                getactivefs(fs);
                strcpy(new_path, fs);
                strcat(new_path, argv[1]);
                strcat(new_path, "\0");
                strcpy(argv[1], new_path);
            }
            if(!ifsafepath(argv[1]))
            {
                printf(2, "You dont have permission to go here! \"%s\"\n", argv[1]);
                return;
            }
        }
        getactivefs(fs);
        if((strcmp(fs, "/") != 0) && argv[0][0] == '/' && !addedcpath(argv[0]))
        {
          char fs[32];
          getactivefs(fs);
          strcpy(new_path, fs);
          strcat(new_path, argv[0]);
          strcat(new_path, "\0");
          strcpy(argv[0], new_path);
        }

        exec(argv[0], argv);
        printf(1, "%s: command not found.\n", cmd);
        exit();
    }
    else
    {
        id = wait();
    }
}

void exec_pipe(char *cmd)
{
    int fd;
    char fs[32], new_path[32];
    char* argv[MAX_ARGS];
    
    parse_args(cmd, " ", argv);
    fd = redirect_output(argv);

    if(fd != 1)
    {
        close(1);
        dup(fd);
        close(fd);
    }

    if(isfscmd(argv[0]))
    {
        if(argv[1][0] == '/' && !addedcpath(argv[1]))
        {
            char fs[32];
            getactivefs(fs);
            strcpy(new_path, fs);
            strcat(new_path, argv[1]);
            strcat(new_path, "\0");
            strcpy(argv[1], new_path);
        }
        if(!ifsafepath(argv[1]))
        {
            printf(2, "You dont have permission to go here! \"%s\"\n", argv[1]);
            return;
        }
    }
    getactivefs(fs);
    if((strcmp(fs, "/") != 0) && argv[0][0] == '/' && !addedcpath(argv[0]))
    {
      char fs[32];
      getactivefs(fs);
      strcpy(new_path, fs);
      strcat(new_path, argv[0]);
      strcat(new_path, "\0");
      strcpy(argv[0], new_path);
    }

    exec(argv[0], argv);
}

void pipe_command(char *buf)
{
    int id, fd[2];
    char *argv[MAX_ARGS];

    parse_args(buf, "|", argv);

    pipe(fd);
    id = fork(0);
    if(id == 0)
    {
        close(1);     /* close stdout */
        dup(fd[1]);   /* put write end of pipe into stdin index */
        close(fd[0]); /* close "read" end of pipe */
        close(fd[1]); /* close "write" end of pipe */
        exec_pipe(argv[0]);
    }
    id = fork(0);
    if(id == 0)
    {
        close(0);     /* close stdin */
        dup(fd[0]);   /* put read end of pipe into stdin index */
        close(fd[1]); /* close "write" end of pipe */
        close(fd[0]); /* close "read" end of pipe */
        exec_pipe(argv[1]);
    }

    close(fd[0]);
    close(fd[1]);
    id = wait();
    id = wait();
}

int exec_shell_command(char *buf)
{
    int index = getactivefsindex();
    char fs[32];
    getactivefs(fs);
    struct cmd_node *cn;

    if(strcmp(buf, "exit") == 0)
    {
        printf(1, "logout\n");

        printf(1, "...deleting history...");
        clear_history();
        printf(1, "done\n");

        printf(1, "\n[Process completed]\n\n");
        return 1;
    }
    else if((strcmp(buf, "cd /\n") == 0) || (strcmp(buf, "cd") == 0))
    {
      setpath(index, fs, 0);
      if(chdir(fs) < 0)
      {
        printf(2, "cannot cd %s\n", fs);
      }
      return 0;
    }
    else if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
    {
        if(ifsafepath(buf+3))
        {
            setpath(index, buf+3, 1);
            if(chdir(&(buf[3])) < 0)
            {
                printf(1, "%s does not exist.\n", &buf[3]);
            }
        }
    }
    else if(buf[0] == '!' && buf[1] != ' ')
    {
        cn = find_in_history(buf);
        if(cn == 0)
        {
            printf(1, "Command not found\n");
        }
        else
        {
            printf(1, "%s\n", cn->cmd);
            exec_history(cn);
        }
    }
    else if(strcmp(buf, "history") == 0)
    {
        print_history();
    }

    return 0;
}

int process_one_command(int *command_counter)
{
    int done = 0;
    char buf[MAX_CMD_LEN];
    struct cmd_node *delete;


    *command_counter = *command_counter + 1;

    print_prompt(command_counter);
    read_line(buf);

    if(buf[0] == '\0' || buf[0] == '\n')
    {
        *command_counter = *command_counter - 1;
        return done;
    }
    else
    {
        if(!add_to_history(buf, *command_counter))
        {
            *command_counter = *command_counter - 1;
            return done;
        }
    }

    if(is_shell_command(buf))
    {
        done = exec_shell_command(buf);
    }
    else if(strstr(buf, "|") > 0)
    {
        pipe_command(buf);
    }
    else
    {
        exec_command(buf);
    }

    if(list_size(&history) > HISTORY_SIZE)
    {
        delete = list_entry(list_pop_front(&history), struct cmd_node, elem);
        free(delete);
    }
    
    return done;
}

int main(int argc, char *argv[])
{
    int command_counter = -1;
    int done = 0;
    
    list_init(&history);

    while(!done)
    {
        done = process_one_command(&command_counter);
    }
    
    exit();    
}
