# assembly-arrm64-linux

## Introduction
This repository provides an introduction to assembly language programming for the ARM64 architecture on Linux, specifically tailored for Termux. Assembly language allows you to write low-level code that directly interfaces with your computer's hardware, offering precise control and performance optimizations. Note: This README.md is inspired by the [learn-assembly-arabic](https://github.com/dhomred/learn-assembly-arabic?utm_source=chatgpt.com) repository.

## Table of Contents
- [Introduction](#introduction)
- [Table of Contents](#table-of-contents)
- [Components of an Assembly Program](#components-of-an-assembly-program)
  - [1. Directives](#1-directives)
  - [2. Instructions](#2-instructions)
  - [3. Comments](#3-comments)
- [Basic Structure of an ARM64 Assembly Program](#basic-structure-of-an-arm64-assembly-program)
- [Example: "Hello, World!" Program on ARM64](#example-hello-world-program-on-arm64)
- [ARM64 Registers Overview](#arm64-registers-overview)
- [Flags](#flags)
- [Control and Branching Instructions](#control-and-branching-instructions)
- [System Calls and Function Calls](#system-calls-and-function-calls)
- [Build Instructions](#build-instructions)
- [Conclusion](#conclusion)
- [Additional Resources](#additional-resources)
- [License](#license)

## Components of an Assembly Program

### 1. Directives
Directives are instructions given to the assembler to set up the environment. Examples include:
- **section**: Specifies the different sections of the program (e.g., data, bss, text).
- **global**: Defines the entry point of the program.

```assembly
.section .data   // Data section for initialized variables and constants
.section .bss    // BSS section for uninitialized variables
.section .text   // Code section
.global _start   // Define the entry point of the program
```

### 2. Instructions

Instructions are commands executed by the CPU. Common instructions include:

- **mov:** Transfers data between registers or between memory and registers.

- **add:** Performs arithmetic addition.

- **b, b.eq, b.ne:** Branch instructions for conditional or unconditional jumps.

```assembly
mov x0, #5      // Move the immediate value 5 into register x0
add x0, x0, #3  // Add 3 to the value in x0 and store the result in x0
```

### 3. Comments

Comments are non-executable text used to explain the code. This repository uses C-style comments:

- **Single-line comments:** // This is a comment

- **Multi-line comments:** /** This is a block comment **/

```assembly
// This is a single-line comment explaining the code
/** This is a block comment that can span multiple lines **/
mov x0, #5  // Load 5 into x0
```

## Basic Structure of an ARM64 Assembly Program

A typical ARM64 assembly program on Linux is divided into three main sections: data, bss, and text.

```assembly
.section .data
    // Data section for storing initialized variables and constants

.section .bss
    // BSS section for uninitialized variables

.section .text
.global _start   // Define the entry point of the program
_start:
    // Program instructions start here
```

## Example: "Hello, World!" Program on ARM64

Below is an example program that writes "Hello, World!" to stdout and then exits.

```assembly
.section .data
msg:
    .asciz "Hello, World!\n"   // Define a null-terminated string
msg_len = . - msg               // Calculate the length of the string

.section .text
.global _start
_start:
    mov x0, #1                // Set file descriptor to 1 (stdout)
    adr x1, msg               // Load the address of msg into x1
    mov x2, #msg_len          // Set the number of bytes to write
    mov x8, #64               // Syscall number for write (sys_write = 64)
    svc #0                    // Make the system call

    mov x0, #0                // Set exit status to 0
    mov x8, #93               // Syscall number for exit (sys_exit = 93)
    svc #0                    // Make the system call
```

## ARM64 Registers Overview

Unlike x86 registers (AX, BX, CX, DX), ARM64 uses registers x0 through x30 (or w0 to w30 for 32-bit operations). Key registers include:

- **x0 – x7:** Used for passing arguments in system calls.

- **x8:** Typically holds the syscall number.

- **x29 (fp) and x30 (lr):** Used as the frame pointer and link register (for function calls).

```assembly
mov x0, #10    // Load the immediate value 10 into x0
mov x1, #20    // Load the immediate value 20 into x1
add x2, x0, x1 // x2 = x0 + x1 (result is 30)
```

## Flags

ARM64 uses condition flags to record the outcome of arithmetic and logical operations. These flags are part of the processor's status register (PSTATE) and include:

- **N (Negative Flag):** Set if the result of an operation is negative.

- **Z (Zero Flag):** Set if the result of an operation is zero.

- **C (Carry Flag):** Set if an operation results in a carry out (useful for unsigned arithmetic).

- **V (Overflow Flag):** Set if an operation causes an arithmetic overflow (useful for signed arithmetic).

These flags are updated by many instructions (e.g., cmp, adds, subs) and can be used to control conditional branches.

Example using condition flags:
```assembly
mov x0, #5
mov x1, #5
cmp x0, x1         // Compare x0 and x1, updating the condition flags
b.eq equal_label   // If Z flag is set (values are equal), jump to equal_label

// Instructions if not equal
b end_label

equal_label:
    // Instructions when equal

end_label:
    // Continue execution
```

## Control and Branching Instructions

ARM64 control flow is managed with instructions such as:

- **cmp:** Compares two values.

- **b.eq, b.ne:** Branch based on the result of a comparison.

- **b Label:** Unconditional jump to a specified label.


Example of a conditional branch:

```assembly
mov x0, #5
mov x1, #5
cmp x0, x1         // Compare x0 and x1
b.eq equal_label   // If the values are equal, jump to equal_label

// Instructions if not equal
b end_label

equal_label:
    // Instructions when equal

end_label:
    // Continue execution
```

## System Calls and Function Calls

System calls on ARM64 are made using the svc instruction. For function calls, ARM64 uses:

- **bl Label:** Branch with link; it calls a function and stores the return address in x30 (LR).

- **ret:** Returns from a function.


Example of a function call:

```assembly
.section .text
.global _start

_start:
    bl my_function   // Call the function my_function
    // Continue execution after function returns
    mov x0, #0
    mov x8, #93      // Syscall for exit (sys_exit = 93)
    svc #0

my_function:
    // Function instructions
    ret              // Return to caller
```

## Build Instructions

To compile and run your ARM64 assembly programs on Termux, follow these steps:

1. Save your code in a file, for example, hello.s.


2. Assemble the code using the GNU assembler:
```bash
as -o hello.o hello.s
```

3. Link the object file to create an executable:
```bash
ld -o hello hello.o
```

4. Run the executable:
```bash
./hello
```


## Conclusion

This repository offers a practical introduction to ARM64 assembly programming on Linux in the Termux environment. Begin with simple programs and gradually explore advanced topics such as conditional branching, function calls, and memory management. Enjoy your journey into low-level programming and master the hardware!

## Additional Resources

- [ARM Architecture Reference Manual](https://developer.arm.com/documentation)

- [learn-assembly-arabic](https://github.com/dhomred/learn-assembly-arabic)

- [Termux Wiki](https://wiki.termux.com/wiki/Main_Page)


## License

This project is licensed under the MIT License. See the [LICENSE](/LICENSE) file for details.

---

Feel free to further customize this file to match your project's needs. Happy coding!

