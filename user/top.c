#include "kernel/types.h"
#include "user/user.h"



struct proc_info {
    int pid;
    int state;
    int ticks;
    char name[16];
};

#define MAX_PROC 64
#define SYS_getprocs 22  

//----------invocation of syscall for user-----------------
int getprocs(struct proc_info *info, int max) {
    int ret;
    asm volatile (
        "li a7, %1\n"
        "mv a0, %2\n"
        "mv a1, %3\n"
        "ecall\n"
        "mv %0, a0\n"
        : "=r"(ret)
        : "i"(SYS_getprocs), "r"(info), "r"(max)
        : "a0", "a1", "a7"
    );
    return ret;
}
//-----------------------------------------------------------

static char* states[] = {"UNUSED", "USED", "SLEEPING", "RUNNABLE", "RUNNING", "ZOMBIE"};

int main(void) {
    
    
    while (1) {
    struct proc_info pinfo[MAX_PROC];
    int n = getprocs(pinfo, MAX_PROC);
    printf("PID\tSTATE\t\tTICKS\tNAME\n");
    for (int i = 0; i < n; i++) {
        char *state = (pinfo[i].state >= 0 && pinfo[i].state <= 5) ? states[pinfo[i].state] : "???";
        printf("%d\t%s\t%d\t%s\n", pinfo[i].pid, state, pinfo[i].ticks, pinfo[i].name);
    }
    sleep(20);                  // sleep for 200 ticks (~2 seconds)
    printf("\033[2J\033[H");   // clear screen and move cursor home
    }
    exit(0);
}
