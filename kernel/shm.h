#ifndef SHM_H
#define SHM_H

void shm_init(void);
void* shm_get(struct proc *p, int key);

#endif // SHM_H
