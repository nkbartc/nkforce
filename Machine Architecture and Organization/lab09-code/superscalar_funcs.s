	.file	"superscalar_funcs.c"
	.text
	.globl	add1_sep
	.type	add1_sep, @function
add1_sep:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	$0, -16(%rbp)
	jmp	.L2
.L3:
	movq	-8(%rbp), %rax
	addq	%rax, -24(%rbp)
	addq	$1, -16(%rbp)
.L2:
	movq	-16(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L3
	movq	-48(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	add1_sep, .-add1_sep
	.globl	add2_sep
	.type	add2_sep, @function
add2_sep:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	addq	$19, %rax
	movq	%rax, -32(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L5
.L6:
	movq	-16(%rbp), %rax
	addq	%rax, -40(%rbp)
	movq	-8(%rbp), %rax
	addq	%rax, -32(%rbp)
	addq	$1, -24(%rbp)
.L5:
	movq	-24(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jb	.L6
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	add2_sep, .-add2_sep
	.globl	add2_same
	.type	add2_same, @function
add2_same:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L8
.L9:
	movq	-16(%rbp), %rax
	addq	%rax, -32(%rbp)
	movq	-8(%rbp), %rax
	addq	%rax, -32(%rbp)
	addq	$1, -24(%rbp)
.L8:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L9
	movq	-48(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	add2_same, .-add2_same
	.globl	add3_sep
	.type	add3_sep, @function
add3_sep:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	addq	$19, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	addq	$193, %rax
	movq	%rax, -40(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	imulq	$632, %rax, %rax
	subq	$19, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -32(%rbp)
	jmp	.L11
.L12:
	movq	-24(%rbp), %rax
	addq	%rax, -56(%rbp)
	movq	-16(%rbp), %rax
	addq	%rax, -48(%rbp)
	movq	-8(%rbp), %rax
	addq	%rax, -40(%rbp)
	addq	$1, -32(%rbp)
.L11:
	movq	-32(%rbp), %rax
	cmpq	-72(%rbp), %rax
	jb	.L12
	movq	-56(%rbp), %rdx
	movq	-48(%rbp), %rax
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	add3_sep, .-add3_sep
	.globl	mul1_sep
	.type	mul1_sep, @function
mul1_sep:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	$0, -16(%rbp)
	jmp	.L14
.L15:
	movq	-24(%rbp), %rax
	imulq	-8(%rbp), %rax
	movq	%rax, -24(%rbp)
	addq	$1, -16(%rbp)
.L14:
	movq	-16(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L15
	movq	-48(%rbp), %rax
	movq	-24(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	mul1_sep, .-mul1_sep
	.globl	mul2_sep
	.type	mul2_sep, @function
mul2_sep:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-40(%rbp), %rax
	addq	$19, %rax
	movq	%rax, -32(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L17
.L18:
	movq	-40(%rbp), %rax
	imulq	-16(%rbp), %rax
	movq	%rax, -40(%rbp)
	movq	-32(%rbp), %rax
	imulq	-8(%rbp), %rax
	movq	%rax, -32(%rbp)
	addq	$1, -24(%rbp)
.L17:
	movq	-24(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jb	.L18
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	mul2_sep, .-mul2_sep
	.globl	mul3_sep
	.type	mul3_sep, @function
mul3_sep:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -72(%rbp)
	movq	%rsi, -80(%rbp)
	movq	%rdx, -88(%rbp)
	movq	-80(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	addq	$19, %rax
	movq	%rax, -48(%rbp)
	movq	-48(%rbp), %rax
	addq	$193, %rax
	movq	%rax, -40(%rbp)
	movq	-88(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -24(%rbp)
	movq	-24(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	imulq	$632, %rax, %rax
	subq	$19, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -32(%rbp)
	jmp	.L20
.L21:
	movq	-56(%rbp), %rax
	imulq	-24(%rbp), %rax
	movq	%rax, -56(%rbp)
	movq	-48(%rbp), %rax
	imulq	-16(%rbp), %rax
	movq	%rax, -48(%rbp)
	movq	-40(%rbp), %rax
	imulq	-8(%rbp), %rax
	movq	%rax, -40(%rbp)
	addq	$1, -32(%rbp)
.L20:
	movq	-32(%rbp), %rax
	cmpq	-72(%rbp), %rax
	jb	.L21
	movq	-56(%rbp), %rdx
	movq	-48(%rbp), %rax
	addq	%rax, %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-80(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	mul3_sep, .-mul3_sep
	.globl	mul2_same
	.type	mul2_same, @function
mul2_same:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L23
.L24:
	movq	-32(%rbp), %rax
	imulq	-16(%rbp), %rax
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	imulq	-8(%rbp), %rax
	movq	%rax, -32(%rbp)
	addq	$1, -24(%rbp)
.L23:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L24
	movq	-48(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	mul2_same, .-mul2_same
	.globl	add2_and_mul_sep
	.type	add2_and_mul_sep, @function
add2_and_mul_sep:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -48(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	addq	$19, %rax
	movq	%rax, -40(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L26
.L28:
	movq	-16(%rbp), %rax
	addq	%rax, -48(%rbp)
	movq	-32(%rbp), %rax
	imulq	-16(%rbp), %rax
	movq	%rax, -32(%rbp)
	cmpq	$10000, -16(%rbp)
	ja	.L27
	movq	-8(%rbp), %rax
	addq	%rax, -40(%rbp)
.L27:
	addq	$1, -24(%rbp)
.L26:
	movq	-24(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jb	.L28
	movq	-48(%rbp), %rdx
	movq	-40(%rbp), %rax
	addq	%rax, %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	add2_and_mul_sep, .-add2_and_mul_sep
	.globl	add2_and_mul_same
	.type	add2_and_mul_same, @function
add2_and_mul_same:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rdx
	movq	%rdx, %rax
	addq	%rax, %rax
	addq	%rdx, %rax
	addq	$17, %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L30
.L32:
	movq	-16(%rbp), %rax
	addq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	imulq	-16(%rbp), %rax
	movq	%rax, -32(%rbp)
	cmpq	$10000, -16(%rbp)
	ja	.L31
	movq	-8(%rbp), %rax
	addq	%rax, -32(%rbp)
.L31:
	addq	$1, -24(%rbp)
.L30:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L32
	movq	-48(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	add2_and_mul_same, .-add2_and_mul_same
	.globl	add1_then_mul_sep
	.type	add1_then_mul_sep, @function
add1_then_mul_sep:
.LFB12:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -56(%rbp)
	movq	%rsi, -64(%rbp)
	movq	%rdx, -72(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -40(%rbp)
	movq	-64(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-72(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L34
.L35:
	movq	-8(%rbp), %rax
	addq	%rax, -40(%rbp)
	addq	$1, -24(%rbp)
.L34:
	movq	-24(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jb	.L35
	movq	$0, -16(%rbp)
	jmp	.L36
.L37:
	movq	-32(%rbp), %rax
	imulq	-8(%rbp), %rax
	movq	%rax, -32(%rbp)
	addq	$1, -16(%rbp)
.L36:
	movq	-16(%rbp), %rax
	cmpq	-56(%rbp), %rax
	jb	.L37
	movq	-40(%rbp), %rdx
	movq	-32(%rbp), %rax
	addq	%rax, %rdx
	movq	-64(%rbp), %rax
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE12:
	.size	add1_then_mul_sep, .-add1_then_mul_sep
	.globl	add1_then_mul_same
	.type	add1_then_mul_same, @function
add1_then_mul_same:
.LFB13:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	%rdi, -40(%rbp)
	movq	%rsi, -48(%rbp)
	movq	%rdx, -56(%rbp)
	movq	-48(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -32(%rbp)
	movq	-56(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, -8(%rbp)
	movq	$0, -24(%rbp)
	jmp	.L39
.L40:
	movq	-8(%rbp), %rax
	addq	%rax, -32(%rbp)
	addq	$1, -24(%rbp)
.L39:
	movq	-24(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L40
	movq	$0, -16(%rbp)
	jmp	.L41
.L42:
	movq	-32(%rbp), %rax
	imulq	-8(%rbp), %rax
	movq	%rax, -32(%rbp)
	addq	$1, -16(%rbp)
.L41:
	movq	-16(%rbp), %rax
	cmpq	-40(%rbp), %rax
	jb	.L42
	movq	-48(%rbp), %rax
	movq	-32(%rbp), %rdx
	movq	%rdx, (%rax)
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE13:
	.size	add1_then_mul_same, .-add1_then_mul_same
	.globl	algs
	.section	.rodata
.LC0:
	.string	"add1_sep"
.LC1:
	.string	"add 1 times in loop"
.LC2:
	.string	"add2_sep"
	.align 8
.LC3:
	.string	"add 2 times in same loop; separate destinations"
.LC4:
	.string	"add3_sep"
	.align 8
.LC5:
	.string	"add 3 times in same loop; separate destinations"
.LC6:
	.string	"add2_same"
	.align 8
.LC7:
	.string	"add 2 times in same loop; same destinations"
.LC8:
	.string	"mul1_sep"
.LC9:
	.string	"multiply 1 times in loop"
.LC10:
	.string	"mul2_sep"
	.align 8
.LC11:
	.string	"multiply 2 times in same loop; separate destinations"
.LC12:
	.string	"mul3_sep"
	.align 8
.LC13:
	.string	"multiply 3 times in same loop; separate destinations"
.LC14:
	.string	"mul2_same"
	.align 8
.LC15:
	.string	"multiply 2 times in same loop; same destinations"
.LC16:
	.string	"add1_then_mul_sep"
	.align 8
.LC17:
	.string	"add and multiply in different loops; separate destinations"
.LC18:
	.string	"add1_then_mul_same"
	.align 8
.LC19:
	.string	"add and multiply in different loops; same destinations"
.LC20:
	.string	"add2_and_mul_sep"
	.align 8
.LC21:
	.string	"add twice and multiply in the same loop; separate destinations"
.LC22:
	.string	"add2_and_mul_same"
	.align 8
.LC23:
	.string	"add twice and multiply in the same loop; same destination "
	.data
	.align 32
	.type	algs, @object
	.size	algs, 312
algs:
	.quad	add1_sep
	.quad	.LC0
	.quad	.LC1
	.quad	add2_sep
	.quad	.LC2
	.quad	.LC3
	.quad	add3_sep
	.quad	.LC4
	.quad	.LC5
	.quad	add2_same
	.quad	.LC6
	.quad	.LC7
	.quad	mul1_sep
	.quad	.LC8
	.quad	.LC9
	.quad	mul2_sep
	.quad	.LC10
	.quad	.LC11
	.quad	mul3_sep
	.quad	.LC12
	.quad	.LC13
	.quad	mul2_same
	.quad	.LC14
	.quad	.LC15
	.quad	add1_then_mul_sep
	.quad	.LC16
	.quad	.LC17
	.quad	add1_then_mul_same
	.quad	.LC18
	.quad	.LC19
	.quad	add2_and_mul_sep
	.quad	.LC20
	.quad	.LC21
	.quad	add2_and_mul_same
	.quad	.LC22
	.quad	.LC23
	.quad	0
	.quad	0
	.quad	0
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
