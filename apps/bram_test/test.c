#include <stdio.h>
#include <stdint.h>
#include <unistd.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <string.h>

#include "fpga.h"


int main(int argc,char** argv)
{
    void* base_addr;

   int fd = open("/dev/mem",O_RDWR|O_SYNC);
   if(fd < 0) {
        fprintf(stderr,"Can't open /dev/mem, you must be root!\n");
    } else {
        base_addr=mmap(0,FPGA_SIZE,PROT_READ|PROT_WRITE,MAP_SHARED,fd,FPGA_BASE_ADDRESS);
        if(base_addr == NULL) fprintf(stderr,"Can't mmap\n");
    }

    printf("FPGA_BASE_ADDRESS = 0x%08x, base_addr = %p\n", FPGA_BASE_ADDRESS, base_addr);

    uint32_t *regptr = base_addr + FPGA_REG_OFFSET;

    printf("FPGA_ID = 0x%08x, FPGA_VERSION = 0x%08x\n", regptr[FPGA_ID], regptr[FPGA_VERSION]);


    uint32_t *write_data, *read_data, *bram_ptr;
    int errors;

    // Test the scratch bram.
    write_data = malloc(TEST_RAM_SIZE);
    read_data  = malloc(TEST_RAM_SIZE);
    // create test data.
    for (int i=0; i<TEST_RAM_SIZE/4; i++) write_data[i] = rand();
    bram_ptr = base_addr + TEST_RAM_OFFSET;
    fprintf(stdout, "\nbram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<TEST_RAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<TEST_RAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    errors = 0;
    for (int i=0; i<TEST_RAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "scratch bram errors = %d\n", errors);
    free(write_data);
    free(read_data);

    // Test data ram 0
    write_data = malloc(DATA_RAM_SIZE);
    read_data  = malloc(DATA_RAM_SIZE);
    // create test data.
    for (int i=0; i<DATA_RAM_SIZE/4; i++) write_data[i] = rand();
    bram_ptr = base_addr + DATA_RAM0;
    fprintf(stdout, "\nbram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    errors = 0;
    for (int i=0; i<DATA_RAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "data ram 0 errors = %d\n", errors);
    free(write_data);
    free(read_data);

    // Test data ram 1
    write_data = malloc(DATA_RAM_SIZE);
    read_data  = malloc(DATA_RAM_SIZE);
    // create test data.
    for (int i=0; i<DATA_RAM_SIZE/4; i++) write_data[i] = rand();
    bram_ptr = base_addr + DATA_RAM1;
    fprintf(stdout, "\nbram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    errors = 0;
    for (int i=0; i<DATA_RAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "data ram 1 errors = %d\n", errors);
    free(write_data);
    free(read_data);

    // Test data ram 2
    write_data = malloc(DATA_RAM_SIZE);
    read_data  = malloc(DATA_RAM_SIZE);
    // create test data.
    for (int i=0; i<DATA_RAM_SIZE/4; i++) write_data[i] = rand();
    bram_ptr = base_addr + DATA_RAM2;
    fprintf(stdout, "\nbram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    errors = 0;
    for (int i=0; i<DATA_RAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "data ram 2 errors = %d\n", errors);
    free(write_data);
    free(read_data);

    // Test data ram 3
    write_data = malloc(DATA_RAM_SIZE);
    read_data  = malloc(DATA_RAM_SIZE);
    // create test data.
    for (int i=0; i<DATA_RAM_SIZE/4; i++) write_data[i] = rand();
    bram_ptr = base_addr + DATA_RAM3;
    fprintf(stdout, "\nbram_ptr = %p\n", bram_ptr);
    // write bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) bram_ptr[i] = write_data[i];
    // read bram
    for (int i=0; i<DATA_RAM_SIZE/4; i++) read_data[i] = bram_ptr[i];
    // chech bram results
    errors = 0;
    for (int i=0; i<DATA_RAM_SIZE/4; i++) {
        if (read_data[i] != write_data[i]) errors++;
    }
    fprintf(stdout, "data ram 3 errors = %d\n", errors);
    free(write_data);
    free(read_data);



    munmap(base_addr,FPGA_SIZE);

    return 0;
}


/*
void* phy_addr_2_vir_addr(off_t phy_addr,size_t size)
{
   void* vir_addr=NULL;

   int fd = open("/dev/mem",O_RDWR|O_SYNC);
   if(fd < 0)
   {
       fprintf(stderr,"Can't open /dev/mem\n");
   }
   else
   {
                  //0 is not NULL
      vir_addr=mmap(0,size,PROT_READ|PROT_WRITE,MAP_SHARED,fd,phy_addr);
      if(vir_addr == NULL)
      {
          fprintf(stderr,"Can't mmap\n");
      }
      else
      {
          //DEBUG("phy_addr 0x%lX mapped to 0x%lX with size=0x%x bytes\n",phy_addr,(uint64_t)vir_addr,(uint32_t)size);
          //DEBUG("phy_addr 0x%lx mapped to 0x%p with size=0x%zx bytes\n", phy_addr, vir_addr, size);
      }
   }
   return vir_addr;
}


*/
