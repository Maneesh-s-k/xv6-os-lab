// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

//------------------------------------------------------
#define MAXPAGES (PHYSTOP / PGSIZE)

int refcount[MAXPAGES];
struct spinlock refcount_lock;

static inline int pa2pageindex(uint64 pa);
void incref(void *pa);
void decref(void *pa);
int getref(void *pa);

//------------------------------------------------------



void
kinit()
{
  initlock(&kmem.lock, "kmem");
  
  //------------------------------------------------------
  initlock(&refcount_lock, "refcount");
  for(int i=0; i<MAXPAGES; i++){
    refcount[i] = 1;
  }
  //------------------------------------------------------

  freerange(end, (void*)PHYSTOP);
}


void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
}

// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  // Decrement reference count
  decref(pa);
  if(getref(pa) > 0){
    // Page is still being used by someone else
    return;
  }

  // safe to free now since nobody is using it
  memset(pa, 1, PGSIZE); // Fill with junk to catch dangling refs.
  r = (struct run*)pa;

  acquire(&kmem.lock);
  r->next = kmem.freelist;
  kmem.freelist = r;
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r)
    kmem.freelist = r->next;
  release(&kmem.lock);

  if(r){
    memset((char*)r, 5, PGSIZE); // fill with junk
    //------------------------------------------------------
    incref((void*)r); // initialize ref count to 1
    //------------------------------------------------------
  }
  return (void*)r;
}

//------------------------------------------------------
// functions to change refcount

static inline int pa2pageindex(uint64 pa) {
  int idx = pa >> PGSHIFT;
  if(idx < 0 || idx >= MAXPAGES)
    panic("pa2pageindex: out of range");
  return idx;
}

void incref(void *pa) {
  acquire(&refcount_lock);
  int idx = pa2pageindex((uint64)pa);
  refcount[idx]++;
  release(&refcount_lock);
}

void decref(void *pa) {
  acquire(&refcount_lock);
  int idx = pa2pageindex((uint64)pa);
  if(refcount[idx]<0){
    panic("decref: refcount underflow");
  }
  refcount[idx]--;
  release(&refcount_lock);
}

int getref(void *pa) {
  acquire(&refcount_lock);
  int idx=pa2pageindex((uint64)pa);
  int rc = refcount[idx];
  release(&refcount_lock);
  return rc;
}

//------------------------------------------------------