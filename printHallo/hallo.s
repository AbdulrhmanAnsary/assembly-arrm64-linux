.section .data
msg:
	.asciz "Hello, World!\n"  // Define a null-terminated string
msg_len = . - msg           // Calculate the length of the string

.section .text
.global _start
_start:
	mov x0, #1                 // Set file descriptor to 1 (stdout)
	adr x1, msg               // Load the address of msg into x1
	mov x2, #msg_len           // Set the number of bytes to write
	mov x8, #64                // Specify syscall number for write (64)
	svc #0                     // Make the system call

	mov x0, #0                 // Set exit status to 0
	mov x8, #93                // Specify syscall number for exit (93)
	svc #0                     // Make the system call
