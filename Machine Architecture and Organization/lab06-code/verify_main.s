	.file	"verify_main.c"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC0:
	.string	"Complete this sentence by C creator Dennis Ritchie:"
	.align 8
.LC1:
	.string	"C has the power of assembly language and the convenience of ..."
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC2:
	.string	"Correct!"
	.section	.rodata.str1.8
	.align 8
.LC3:
	.string	"Have a nice tall glass of ... NOPE."
	.text
	.globl	main
	.type	main, @function
main:
.LFB23:
	.cfi_startproc
	subq	$1048, %rsp
	.cfi_def_cfa_offset 1056
	movq	%fs:40, %rax
	movq	%rax, 1032(%rsp)
	xorl	%eax, %eax
	movl	$.LC0, %edi
	call	puts
	movl	$.LC1, %edi
	call	puts
	movq	stdin(%rip), %rdx
	movl	$1024, %esi
	movq	%rsp, %rdi
	call	fgets
	movq	%rsp, %rdi
	call	verify
	testl	%eax, %eax
	jne	.L2
	movl	$.LC2, %edi
	call	puts
	jmp	.L3
.L2:
	movl	$.LC3, %edi
	call	puts
.L3:
	movl	$0, %eax
	movq	1032(%rsp), %rcx
	xorq	%fs:40, %rcx
	je	.L4
	call	__stack_chk_fail
.L4:
	addq	$1048, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE23:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.6) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
