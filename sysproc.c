#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

pte_t *walkpgdir(pde_t *pgdir, const void *va, int alloc);


int sys_shm_open(void) {
  int id;
  char **pointer;

  if(argint(0, &id) < 0)
    return -1;

  if(argptr(1, (char **) (&pointer),4)<0)
    return -1;
  return shm_open(id, pointer);
}

int sys_shm_close(void) {
  int id;

  if(argint(0, &id) < 0)
    return -1;

  
  return shm_close(id);
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_v2p(void) {
    int va;    // Virtual address input
    int *pa;   // Pointer to store physical address
    // Get the virtual address (first argument)
    if (argint(0, (int *)&va) < 0) {
        cprintf("v2p: Failed to retrieve virtual address\n");
        return -1;
    }

    // Get the pointer for the physical address (second argument)
    if (argptr(1, (void *)&pa, sizeof(uint)) < 0) {
        cprintf("v2p: Failed to retrieve physical address pointer\n");
        return -1;
    }
    return v2p(va,pa);
}
