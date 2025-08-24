#include "kernel/types.h"
#include "user/user.h"

int sem_id=0;

void producer(){
  for(int i=0;i<5;i++){
    sem_down(sem_id);  // wait for consumer to consume
    printf("producer %d\n",i);
    sem_up(sem_id);    // signal consumer produced
  }
  exit(0);
}

void consumer(){
  for(int i=0;i<5;i++) {
    sem_down(sem_id);  // wait for producer to produce
    printf("consumer %d\n",i);
    sem_up(sem_id);    // signal producer to produce next
  }
  exit(0);
}

int main(){
  if(sem_init(sem_id,1)<0) {
    printf("Failed to init semaphore\n");
    exit(1);
  }
  int pid=fork();
  if(pid<0) {
    printf("Fork failed\n");
    exit(1);
  }
  if(pid==0){
    producer();
  }else{
    consumer();
    wait(0);
  }
  exit(0);
}
