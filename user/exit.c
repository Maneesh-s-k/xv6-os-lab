#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[]) {
    int status = 0;
    if(argc > 1) {
        status = atoi(argv[1]);
    }
    exit(status);
    return 0;  
}
