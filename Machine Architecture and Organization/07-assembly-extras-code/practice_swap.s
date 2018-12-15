.file	"swap.c"
.text
.globl	swap
.type	swap, @function

Swap:
  movq (%rdi), %rdx     
  movq (%rsi), %rcx
  movq %rdx, (%rsi)
  movq %rcx, (%rdi)
  ret

main:
    subq $8, %rsp
    movl $21, (%rsp)
    movl $20, 4(%rsp)
    leaq (%rsp), %rdi
    leaq 4(%rsp), %rsi
    call swap
    addq $8, %rsp
