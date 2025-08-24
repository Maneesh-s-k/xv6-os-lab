#include "kernel/types.h"
#include "user/user.h"

int main(){
    int key = 0;  // key is ignored in the kernel implementation
    char *shm = (char *)shm_get(key);
    if(shm == 0){
        printf("Failed to get shared memory\n");
        exit(1);
    }
  
    int pid=fork();
  
    if(pid<0){
        printf("Fork failed\n");
        exit(1);
    }
  
    if(pid==0){
    // Child process: write to shared memory
        for(int i=0;i<10;i++){
            shm[i]='A'+i;
        }
        shm[10]=0; // null terminator
        printf("Child wrote to shared memory: %s\n", shm);
        exit(0);
    }
    else{
    // Parent process: wait for child and then read shared memory
        wait(0);
        printf("Parent reads from shared memory: %s\n", shm);
    }
    exit(0);
}
