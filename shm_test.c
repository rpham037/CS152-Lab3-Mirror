#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    char *shm;
    if (shm_open(1, &shm) < 0) {
        printf(1, "shm_open failed\n");
        exit();
    }
    printf(1, "shm_open successful, shm address: %p\n", shm);

    if (shm_close(1) < 0) {
        printf(1, "shm_close failed\n");
    } else {
        printf(1, "shm_close successful\n");
    }

    exit();
}