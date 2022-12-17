# Pipelined-MIPS-Processor
Created and assembled 5 different stages of a MIPS(Microprocessor without Interlocked Pipelined Stages) Processor into an functional pipelined microprocessor architecture. Outputs of each stage were captured in a register, which then fed them as the inputs for the following stage. Each register operated on a shared clock signal to maintain the pipelined operation.

## Stages of development
### ALU
 - The first step of this project was to create a 4-bit ALU which supported the Logical OR, AND, XOR, Shift Left, Shift Right, and the Arithmetic Shift Right functions. This was then increased to a width of 32 bits as the components were declared with a generic bit width, then instantiated with a width of 32 bits. This was created, tested, and simulated using the Xilinx Vivado software package to confirm the successful function of each operation including edge cases.
 
### Register File
 - The next step was to design the register file for an FPGA, again using the Xilinx Design Suite. The goal was to have the implementation capable of storing multiple words which can be overwritten or read from. This was tested using a testbench designed to confirm the successful function of the register file and its components including edge cases. 

### Fetch and Decode
 - The third step was to design both the Instruction Fetch and Instruction Decode stages of the MIPS architecture. It utilized a Register File and Control Unit for the decode stage in addition to its base functionality. The Instruction Fetch stage obtains the instructions for use in the decode stage which derives the commands for the execute step. Both components were tested using a test bench designed to check the functionality of the design for test instructions with changing inputs. 

### Execute
 - This step involved the design the Execute Stage of the MIPS architecture. The Execute stage utilizes the ALU in tandem with its own processes in order to completely implement the logic behind each operation. This stage takes in the register values, Memory, and register control bits, a conditional bit for immediate, as well as the destination bits and ALU Opcode. Using the Opcode the ALU performs the desired operation providing the answer as the output. The memory and register control bits are passed through in this stage without modifications and the write data and address are updated with the correct values. This component and the ALU were tested to check the functionality of the design under different instruction conditions such as instruction opcodes with changing inputs.

### Memory and Writeback
 - The last individual step was to create the Memory and Writeback stages of the MIPS Datapath. They were first created in Verilog in order to get some experience creating parts in another industry standard language. These were then translated from their Verilog counterparts into VHDL. This stage focuses on the memory for longer term storage and loading, while redirecting specific signals into previous stages. Both the Data Memory and Writeback stages were tested using test benches to ensure proper functionality given different inputs that could be passed in.

### Pipelined Processor
 - The final stage was to combine each of the components of the MIPS processor made in past stages, into one Pipelined MIPS processor. The outputs of each stage were designed to be captured into a register which passed each output on the same clock signal to make the design follow a pipelined operation. The Pipelined processor was first tested using a instruction set that ran each operation followed by an instruction set that created the first 10 values in the Fibonacci sequence. This exercise was successful in creating a full MIPS processor, designing and running test benches, and reinforcing VHDL practices.


