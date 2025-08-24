#ifndef SEM_H
#define SEM_H

int sem_init(int sem_id, int val);
int sem_down(int sem_id);
int sem_up(int sem_id);

#endif // SEM_H