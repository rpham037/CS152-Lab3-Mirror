#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char *frame;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].frame =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
    acquire(&shm_table.lock);

    struct proc *current_proc = myproc();
    uint va = PGROUNDUP(current_proc->sz);  // Get next aligned virtual address

    // Case 1: Check if the shared memory segment already exists
    for (int i = 0; i < 64; i++) {
        if (shm_table.shm_pages[i].id == id) {
            shm_table.shm_pages[i].refcnt++;  // Increment reference count
            if (mappages(current_proc->pgdir, (char *)va, PGSIZE, 
                         V2P(shm_table.shm_pages[i].frame), PTE_W | PTE_U) < 0) {
                release(&shm_table.lock);
                return -1;  // Mapping failed
            }
            *pointer = (char *)va;  // Set the pointer to the virtual address
            current_proc->sz = va + PGSIZE;  // Update process's virtual address size
            release(&shm_table.lock);
            return 0;
        }
    }

    // Case 2: Shared memory segment does not exist
    for (int i = 0; i < 64; i++) {
        if (shm_table.shm_pages[i].refcnt == 0) {  // Find an empty entry
            shm_table.shm_pages[i].id = id;
            shm_table.shm_pages[i].frame = kalloc();  // Allocate physical memory
            if (!shm_table.shm_pages[i].frame) {
                release(&shm_table.lock);
                return -1;  // Memory allocation failed
            }
            memset(shm_table.shm_pages[i].frame, 0, PGSIZE);  // Initialize memory
            shm_table.shm_pages[i].refcnt = 1;

            if (mappages(current_proc->pgdir, (char *)va, PGSIZE, 
                         V2P(shm_table.shm_pages[i].frame), PTE_W | PTE_U) < 0) {
                kfree(shm_table.shm_pages[i].frame);  // Free memory on failure
                shm_table.shm_pages[i].id = 0;
                shm_table.shm_pages[i].frame = 0;
                shm_table.shm_pages[i].refcnt = 0;
                release(&shm_table.lock);
                return -1;  // Mapping failed
            }
            *pointer = (char *)va;  // Set the pointer to the virtual address
            current_proc->sz = va + PGSIZE;  // Update process's virtual address size
            release(&shm_table.lock);
            return 0;
        }
    }

    release(&shm_table.lock);
    return -1;  // No available entries in shm_table
}


int shm_close(int id) {
    acquire(&shm_table.lock);

    for (int i = 0; i < 64; i++) {
        if (shm_table.shm_pages[i].id == id) {
            shm_table.shm_pages[i].refcnt--;  // Decrement reference count
            if (shm_table.shm_pages[i].refcnt > 0) {
                release(&shm_table.lock);
                return 0;  // Shared memory still in use
            }

            // Last reference, free resources
            kfree(shm_table.shm_pages[i].frame);  // Free physical memory
            shm_table.shm_pages[i].frame = 0;
            shm_table.shm_pages[i].id = 0;
            shm_table.shm_pages[i].refcnt = 0;

            release(&shm_table.lock);
            return 0;  // Successfully closed
        }
    }

    release(&shm_table.lock);
    return 1;  // ID not found
}
