#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

struct shm{
    struct spinlock lock;
    char* shared_page; // pointer to physical shared page
    int allocated; //flag
}shared_mem;

void shm_init(void){
    initlock(&shared_mem.lock,"shared_mem");
    shared_mem.shared_page=0;
    shared_mem.allocated =0;
}

void* shm_get(struct proc *p,int key){
    acquire(&shared_mem.lock);
    if(!shared_mem.allocated){
    // Allocate a physical page
        shared_mem.shared_page = kalloc();
        if (shared_mem.shared_page == 0) {
            release(&shared_mem.lock);
            return 0; // allocation failed
        }
        memset(shared_mem.shared_page,0,PGSIZE);
        shared_mem.allocated=1;
    }
    release(&shared_mem.lock);
    uint64 shared_va = 0x40000000;
    // Map the physical page into the process page table
    if (mappages(p->pagetable, shared_va, PGSIZE,(uint64)shared_mem.shared_page, PTE_W | PTE_U)<0){
        return 0; // mapping failed
    }

    return (void*)shared_va;
}

