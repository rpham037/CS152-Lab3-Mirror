#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "spinlock.h"

#define SHM_MAX 64

struct {
  struct spinlock lock;
  struct shm_page {
    uint id;
    char *fr;
    int refcnt;
  } shm_pages[64];
} shm_table;

void shminit() {
  int i;
  initlock(&(shm_table.lock), "SHM lock");
  acquire(&(shm_table.lock));
  for (i = 0; i< 64; i++) {
    shm_table.shm_pages[i].id =0;
    shm_table.shm_pages[i].fr =0;
    shm_table.shm_pages[i].refcnt =0;
  }
  release(&(shm_table.lock));
}

int shm_open(int id, char **pointer) {
    struct proc *curproc = myproc(); // Get the current process
    uint aligned_sz = PGROUNDUP(curproc->sz); // Align the size to the next page boundary
    int free_index = -1;

    acquire(&(shm_table.lock)); // Acquire the lock for thread safety

    for (int i = 0; i < SHM_MAX; i++) {
        if (shm_table.shm_pages[i].id == id) {
            // Shared memory segment already exists
            mappages(curproc->pgdir, (char *)aligned_sz, PGSIZE,
                     V2P(shm_table.shm_pages[i].fr), PTE_W | PTE_U);
            shm_table.shm_pages[i].refcnt++; // Increment reference count
            *pointer = (char *)aligned_sz;  // Return virtual address
            release(&(shm_table.lock));
            return 0; // Success
        }

        if (free_index == -1 && shm_table.shm_pages[i].id == 0) {
            free_index = i; // Record first free slot
        }
    }

    if (free_index != -1) {
        void *fr = kalloc(); // Allocate a physical page
        if (fr == 0) {
            release(&(shm_table.lock));
            return -1; // Error: Memory allocation failed
        }

        memset(fr, 0, PGSIZE); // Clear the allocated page
        shm_table.shm_pages[free_index] = (struct shm_page) {
            .id = id,
            .fr = fr,
            .refcnt = 1
        };

        mappages(curproc->pgdir, (char *)aligned_sz, PGSIZE, V2P(fr), PTE_W | PTE_U);
        curproc->sz = aligned_sz + PGSIZE; // Update process size
        *pointer = (char *)aligned_sz;    // Return virtual address

        release(&(shm_table.lock));
        return 0; // Success
    }

    release(&(shm_table.lock));
    return -1; // Error: No free slot available
}

int shm_close(int id) {
    struct proc *curproc = myproc();
    int id_found = 0;

    acquire(&(shm_table.lock)); // Acquire the lock for thread safety

    for (int i = 0; i < SHM_MAX; i++) {
        if (shm_table.shm_pages[i].id == id) {
            id_found = 1;

            // Decrement reference count
            shm_table.shm_pages[i].refcnt--;
            if (shm_table.shm_pages[i].refcnt > 0) {
                break; // Other processes still using this segment
            }

            // No more references; clean up
            //void *fr = shm_table.shm_pages[i].fr; // Physical frame
            shm_table.shm_pages[i] = (struct shm_page){0}; // Reset entry

            // Unmap the virtual address associated with this shared memory
            uint vaddr = PGROUNDUP((uint)shm_table.shm_pages[i].fr);
            pte_t *pte = walkpgdir(curproc->pgdir, (char *)vaddr, 0);

            if (pte && (*pte & PTE_P)) {
                *pte = 0; // Clear the page table entry
                lcr3(V2P(curproc->pgdir)); // Refresh TLB
            }

            //kfree(fr); // Free the physical memory

            break; // Exit loop after processing
        }
    }

    release(&(shm_table.lock)); // Release the lock

    return id_found ? 0 : 1; // Return 0 if successful, 1 if ID not found
}