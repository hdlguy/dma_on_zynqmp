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

    //printf("FPGA_BASE_ADDRESS = 0x%08x, base_addr = %p\n", FPGA_BASE_ADDRESS, base_addr);

    uint32_t *regptr = base_addr + FPGA_REG_OFFSET;

    printf("FPGA_ID = 0x%08x, FPGA_VERSION = 0x%08x\n", regptr[FPGA_ID], regptr[FPGA_VERSION]);


    uint32_t *write_data, *read_data, *bram_ptr;
    int errors;

    const uint32_t period = 100000000;
    const uint16_t length = 32; // must be power of two, why?
    const int Nrecord = 5;

    regptr[DGEN_CONTROL] = 0x0000; // clear enable
    regptr[DGEN_PERIOD] = period-1;
    regptr[DGEN_LENGTH] = length-1;

    FILE* fp = fopen("dgen_data.bin","w");

    fwrite(regptr, sizeof(uint32_t), N_REGS, fp);

    bram_ptr = base_addr + DATA_RAM0;
    int whilecount = 0;
    regptr[DGEN_CONTROL] = 0x0001; // enable dgen
    while(whilecount<Nrecord) {

        while(((regptr[DGEN_CONTROL]) & 0x00000010) == 0); // wait for ready signal
        regptr[DGEN_CONTROL] = 0x0101; // assert clear
        //while(((regptr[DGEN_CONTROL]) & 0x0010) != 0); // wait for not ready signal
        regptr[DGEN_CONTROL] = 0x0001; // deassert clear
        printf("dgen_ready = 1\n");
        fwrite(bram_ptr, sizeof(uint32_t), length/2, fp);
        
        whilecount++;
    }
    regptr[DGEN_CONTROL] = 0x0000;

    fclose(fp);

    // data ram 0
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



    munmap(base_addr,FPGA_SIZE);

    return 0;
}


/*

*/
