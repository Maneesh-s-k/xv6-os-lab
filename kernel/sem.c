#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "spinlock.h"
#include "proc.h"
#include "memlayout.h"

#define MAX_SEM 100

struct semaphore {
  struct spinlock lock;  // to maintain locking 
  int count;            
  int initialized;       // flag to check if initialized
};

static struct semaphore semaphores[MAX_SEM]; // global array of semaphores

int sem_init(int sem_id,int val) {
    if(sem_id<0 || sem_id>=MAX_SEM || val<0) return -1;

    struct semaphore *sem = &semaphores[sem_id];
    acquire(&sem->lock);

    if(sem->initialized) {
        release(&sem->lock);
        return -1;       
        // Already initialized, hence an error
    }

    sem->count=val;
    sem->initialized=1;
    release(&sem->lock);

    return 0;
}


// P(wait) operation : decrement semaphore count or sleep if count is 0 or less
int sem_down(int sem_id) {
    if(sem_id<0 || sem_id>=MAX_SEM) return -1;

    struct semaphore *sem=&semaphores[sem_id];
    acquire(&sem->lock);

    if(!sem->initialized) {
        release(&sem->lock);
        return -1;
    }

    while(sem->count<=0) sleep(sem, &sem->lock);

    sem->count--;
    release(&sem->lock);
    return 0;
}

// V(signal) operation : increment semaphore and wakeup one waiting process
int sem_up(int sem_id){
    if(sem_id<0 || sem_id>=MAX_SEM) return -1;

    struct semaphore *sem=&semaphores[sem_id];
    acquire(&sem->lock);
    if(!sem->initialized){
        release(&sem->lock);
        return -1;
    }
    sem->count++;
    wakeup(sem);
    release(&sem->lock);
    return 0;
}

