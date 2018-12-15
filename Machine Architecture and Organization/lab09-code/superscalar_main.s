	.file	"superscalar_main.c"
	.section	.rodata
.LC0:
	.string	"usage: %s <ALG> <MULT> <EXP>\n"
	.align 8
.LC1:
	.string	"  <MULT> and <ALG> are integers, iterates for MULT * 2^{EXP} iterations"
.LC2:
	.string	"  <ALG> is one of"
.LC3:
	.string	"%18s : %s\n"
	.text
	.globl	print_usage
	.type	print_usage, @function
print_usage:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC0, %edi
	movl	$0, %eax
	call	printf
	movl	$.LC1, %edi
	call	puts
	movl	$.LC2, %edi
	call	puts
	movl	$0, -4(%rbp)
	jmp	.L2
.L3:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	$algs+16, %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	$algs+8, %rax
	movq	(%rax), %rax
	movq	%rcx, %rdx
	movq	%rax, %rsi
	movl	$.LC3, %edi
	movl	$0, %eax
	call	printf
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	$algs, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L3
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	print_usage, .-print_usage
	.section	.rodata
.LC4:
	.string	"Unknown algorithm '%s'\n"
	.align 8
.LC5:
	.string	"%s for %lu * 2^{%lu} = %lu iterations... "
.LC6:
	.string	"complete"
	.text
	.globl	main
	.type	main, @function
main:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$96, %rsp
	movl	%edi, -84(%rbp)
	movq	%rsi, -96(%rbp)
	movq	%fs:40, %rax
	movq	%rax, -8(%rbp)
	xorl	%eax, %eax
	cmpl	$3, -84(%rbp)
	jg	.L5
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	print_usage
	movl	$1, %eax
	jmp	.L11
.L5:
	movq	-96(%rbp), %rax
	movq	8(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	$0, -56(%rbp)
	movl	$0, -76(%rbp)
	jmp	.L7
.L9:
	movl	-76(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	$algs+8, %rax
	movq	(%rax), %rdx
	movq	-48(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L8
	movl	-76(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	$algs, %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
.L8:
	addl	$1, -76(%rbp)
.L7:
	movl	-76(%rbp), %eax
	movslq	%eax, %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	salq	$3, %rax
	addq	$algs, %rax
	movq	(%rax), %rax
	testq	%rax, %rax
	jne	.L9
	cmpq	$0, -56(%rbp)
	jne	.L10
	movq	-48(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC4, %edi
	movl	$0, %eax
	call	printf
	movq	-96(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	print_usage
	movl	$1, %eax
	jmp	.L11
.L10:
	movq	-96(%rbp), %rax
	addq	$16, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atol
	movq	%rax, -40(%rbp)
	movq	-96(%rbp), %rax
	addq	$24, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atol
	movq	%rax, -32(%rbp)
	movq	$1, -24(%rbp)
	movq	-32(%rbp), %rax
	movl	%eax, %edx
	movq	-24(%rbp), %rax
	movl	%edx, %ecx
	salq	%cl, %rax
	imulq	-40(%rbp), %rax
	movq	%rax, -16(%rbp)
	movq	$0, -72(%rbp)
	movq	$3, -64(%rbp)
	movq	-16(%rbp), %rsi
	movq	-32(%rbp), %rcx
	movq	-40(%rbp), %rdx
	movq	-48(%rbp), %rax
	movq	%rsi, %r8
	movq	%rax, %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	movq	stdout(%rip), %rax
	movq	%rax, %rdi
	call	fflush
	leaq	-64(%rbp), %rdx
	leaq	-72(%rbp), %rsi
	movq	-16(%rbp), %rcx
	movq	-56(%rbp), %rax
	movq	%rcx, %rdi
	call	*%rax
	movl	$.LC6, %edi
	call	puts
	movl	$0, %eax
.L11:
	movq	-8(%rbp), %rcx
	xorq	%fs:40, %rcx
	je	.L12
	call	__stack_chk_fail
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
