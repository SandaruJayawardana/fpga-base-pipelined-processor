# FPGA-Base-Pipelined-Processor
> Custom 16bit pipelined RISC processor which was designed mainly to downsample a image. It can handle 512kb of data memory and 128kb instruction memory. It has __11 simple instructions__ and __6 extended instructions__ as shown in below. There are 3 18bit registers to handle the data read/write operations in data ram. We implemented python base assembler algorithm to convert the assembly code into machine code with __handling the possible pipeline hazards__ in input assembly code (Therefore user doesn't need to worry about the pipeline hazards). 

* __Pipelined Instruction Execution__


* __Data Path of the Processor__
