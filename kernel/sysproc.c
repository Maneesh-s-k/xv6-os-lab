#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"
//-----------------------------------------
#include "sem.h"
#include "shm.h"
//-----------------------------------------


uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(n < 0) {
    if(shrinkproc(-n) < 0)
      return -1;
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


/*------------------------------------------------------------------------------
we make system call handlers for sem_init,sem_up,sem_down and shm_get
--------------------------------------------------------------------------------*/

// sys_sem_init : syscall handler for sem_init(int sem_id, int val)
uint64
sys_sem_init(void)
{
  int sem_id,val;
  argint(0, &sem_id);
  argint(1, &val);
  return sem_init(sem_id,val);
}

// argint(n, &var) extracts the nth arg into the variable sem_id, here 0th(first).

// sys_sem_down : syscall handler for sem_down(int sem_id,int val)
uint64
sys_sem_down(void){
  int sem_id;
  argint(0, &sem_id);
  return sem_down(sem_id);
}


// sys_sem_up : syscall handler for sem_up(int sem_id,int val)
uint64
sys_sem_up(void){
  int sem_id;
  argint(0, &sem_id);
  return sem_up(sem_id);
}

// sys_shm_get : syscall handler for shm_get(struct proc* p,key)
uint64
sys_shm_get(void)
{
  int key;
  struct proc *p=myproc();
  argint(0, &key);  //key is ignored internally but required by interface
  void *shared_addr=shm_get(p, key);
  return (uint64)shared_addr;
}


