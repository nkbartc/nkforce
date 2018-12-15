### In-class exercise to study data movement
###
### In gdb use the commands
###   gdb> print *($rdx)
### to print the integer pointed to by register rdx.

.section        .text
.globl  main
main:

.SETUP:
        movq $15, %rax
        movq $20, %rbx
        movq $25, %rcx
        pushq $100              # push 100 on stack
        movq %rsp,%rdx          # point rdx at location with 100

.EXERCISE:
        addq %rbx,%rax          # reg + reg
	addq $1,%rcx            # con + reg
        addq (%rdx),%rcx        # mem + reg
        addq %rbx,(%rdx)        # reg + mem
        addq $3,(%rdx)          # con + mem
	
        ## addq (%rdx),(%rdx)   # mem + mem not allowed
        ## addq $1,$2           # con + con not allowed
	

        ret
        
        
