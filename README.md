# FPGA-Base-Pipelined-Processor
> Custom 16bit pipelined RISC processor which was designed mainly to downsample a image. It can handle 512kb of data memory and 128kb instruction memory. It has __11 simple instructions__ and __6 extended instructions__ as shown in below. There are 3 18bit registers to handle the data read/write operations in data ram. We implemented python base assembler algorithm to convert the assembly code into machine code with __handling the possible pipeline hazards__ in input assembly code (Therefore user doesn't need to worry about the pipeline hazards). 

> __All the details related to the design are given below__
## Instructions
<img src="https://github.com/SandaruJayawardana/fpga-base-pipelined-processor/blob/main/Instructions.png" alt="alt text" width="600" height="3000">

## Architecture of the Processor
* __Pipelined Instruction Execution__
<img src="https://github.com/SandaruJayawardana/fpga-base-pipelined-processor/blob/main/pipelined_inst_exec.png" alt="alt text" width="800" height="400">

* __Data Path of the Processor__
<img src="https://github.com/SandaruJayawardana/fpga-base-pipelined-processor/blob/main/Data_path.png" alt="alt text" width="600" height="600">

* __Mux selections for A, B, C and D buses__
> Selection bit patterns are similar for each bus
<img src="https://github.com/SandaruJayawardana/fpga-base-pipelined-processor/blob/main/mux_sel_reg_bank.png" alt="alt text" width="200" height="600">
