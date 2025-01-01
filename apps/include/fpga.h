
#define     FPGA_BASE_ADDRESS       0xA0000000
#define     FPGA_SIZE               0x00100000

#define     FPGA_REG_OFFSET         0x00000000

#define     TEST_RAM_OFFSET         0x00010000
#define     TEST_RAM_SIZE           0x00001000 // 4k

#define     DATA_RAM_SIZE           0x00010000 // 64k
#define     DATA_RAM0               0x00020000
#define     DATA_RAM1               0x00030000
#define     DATA_RAM2               0x00040000
#define     DATA_RAM3               0x00050000


// register numbers
#define     N_REGS                  16  // number of 32-bit registers.
#define     FPGA_ID                 0
#define     FPGA_VERSION            1
#define     DGEN_CONTROL            2   // [0]=dg_enable, [4]=dg_ready(read-only), [8]=dg_clear
#define     DGEN_LENGTH             3   // [15:0] = length of data record written to ram (minus 1).
#define     DGEN_PERIOD             4   // [31:0] = period between collections in 100MHz clock ticks (minus 1).

