#include "types.h"
#include "stat.h"
#include "user.h"

int main() {
    uint va;  // Virtual address
    uint pa;  // Physical address

    // Allocate memory
    char *mem = sbrk(4096);  // Allocate one page (4 KB)
    va = (uint)mem;

    // Write to memory to ensure the page is allocated
    *mem = 'A';

    // Test v2p
    if (v2p(va, &pa) < 0) {
        printf(1, "v2p failed for virtual address: 0x%x\n", va);
        exit();
    }

    printf(1, "Virtual Address: 0x%x -> Physical Address: 0x%x\n", va, pa);
    exit();
}
