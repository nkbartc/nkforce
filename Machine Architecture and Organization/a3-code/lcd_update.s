	.file	"lcd_update.c"
	.text
	.globl	set_tod_from_secs
	.type	set_tod_from_secs, @function
set_tod_from_secs:
.LFB60: # edi = time_of_day_sec, rsi = tod_t *tod
	.cfi_startproc
	cmpl	$86400, %edi # if(time_of_day_sec > 86400 || time_of_day_sec < 0)
	ja	.L7 					 # jump to line 11
	cmpl	$43199, %edi # else if(time_of_day_sec < 43200)
	jg	.L3            # jump to line 31 else
	cmpl	$3599, %edi  # line 16 if(time_of_day_sec < 3600)
	          # jump to line 23
	movw	$12, (%rsi)
	movl	$-2004318071, %edx
	movl	%edi, %eax
	imull	%edx
	addl	%edi, %edx
	sarl	$5, %edx
	movl	%edi, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movw	%dx, 2(%rsi)
	leal	0(,%rdx,4), %eax
	sall	$6, %edx
	subl	%eax, %edx
	movl	%edi, %eax
	subl	%edx, %eax
	movw	%ax, 4(%rsi)
	movb	$0, 6(%rsi)
	movl	$0, %eax
	ret
.L4:
	movl	$-1851608123, %edx
	movl	%edi, %eax
	imull	%edx
	addl	%edi, %edx
	sarl	$11, %edx
	movl	%edi, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movw	%dx, (%rsi)
	imull	$3600, %edx, %edx
	movl	%edi, %ecx
	subl	%edx, %ecx
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	addl	%ecx, %edx
	sarl	$5, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movw	%dx, 2(%rsi)
	leal	0(,%rdx,4), %eax
	sall	$6, %edx
	subl	%eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	movw	%ax, 4(%rsi)
	movb	$0, 6(%rsi)
	movl	$0, %eax
	ret
.L3:
	leal	-43200(%rdi), %eax
	cmpl	$3599, %eax
	ja	.L5
	movw	$12, (%rsi)
	movl	$-1851608123, %edx
	movl	%edi, %eax
	imull	%edx
	leal	(%rdx,%rdi), %ecx
	sarl	$11, %ecx
	movl	%edi, %eax
	sarl	$31, %eax
	subl	%eax, %ecx
	imull	$3600, %ecx, %ecx
	subl	%ecx, %edi
	movl	$-2004318071, %edx
	movl	%edi, %eax
	imull	%edx
	addl	%edi, %edx
	sarl	$5, %edx
	movl	%edi, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movw	%dx, 2(%rsi)
	leal	0(,%rdx,4), %eax
	sall	$6, %edx
	subl	%eax, %edx
	movl	%edi, %eax
	subl	%edx, %eax
	movw	%ax, 4(%rsi)
	movb	$1, 6(%rsi)
	movl	$0, %eax
	ret
.L5:									 # line 39 else if (time_of_day_sec == 86400)
	cmpl	$86400, %edi
	jne	.L6
	movw	$12, (%rsi)
	movw	$0, 2(%rsi)
	movw	$0, 4(%rsi)
	movb	$0, 6(%rsi)
	movl	$0, %eax
	ret
.L6:									 # line 46 else
	movl	$-1851608123, %edx
	movl	%edi, %eax
	imull	%edx
	addl	%edi, %edx
	sarl	$11, %edx
	movl	%edi, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	leal	-12(%rdx), %eax
	movw	%ax, (%rsi)
	imull	$3600, %edx, %edx
	movl	%edi, %ecx
	subl	%edx, %ecx
	movl	$-2004318071, %edx
	movl	%ecx, %eax
	imull	%edx
	addl	%ecx, %edx
	sarl	$5, %edx
	movl	%ecx, %eax
	sarl	$31, %eax
	subl	%eax, %edx
	movw	%dx, 2(%rsi)
	leal	0(,%rdx,4), %eax
	sall	$6, %edx
	subl	%eax, %edx
	movl	%ecx, %eax
	subl	%edx, %eax
	movw	%ax, 4(%rsi)
	movb	$1, 6(%rsi)
	movl	$0, %eax
	ret
.L7:                # line 10 if(time_of_day_sec > 86400 || time_of_day_sec < 0)
	movl	$1, %eax  # return 1;
	ret
	.cfi_endproc
.LFE60:
	.size	set_tod_from_secs, .-set_tod_from_secs
	.globl	set_display_bits_from_tod
	.type	set_display_bits_from_tod, @function
set_display_bits_from_tod:
.LFB61:
	.cfi_startproc
	subq	$56, %rsp
	.cfi_def_cfa_offset 64
	movq	%fs:40, %rax
	movq	%rax, 40(%rsp)
	xorl	%eax, %eax
	cmpw	$12, %di
	ja	.L14
	movl	%edi, %eax
	sarl	$16, %eax
	cmpw	$60, %ax
	jg	.L15
	testw	%ax, %ax
	js	.L16
	movl	$63, (%rsp)
	movl	$6, 4(%rsp)
	movl	$91, 8(%rsp)
	movl	$79, 12(%rsp)
	movl	$102, 16(%rsp)
	movl	$109, 20(%rsp)
	movl	$125, 24(%rsp)
	movl	$7, 28(%rsp)
	movl	$127, 32(%rsp)
	movl	$111, 36(%rsp)
	imull	$26215, %eax, %edx
	sarl	$18, %edx
	movl	%eax, %ecx
	sarw	$15, %cx
	subl	%ecx, %edx
	leal	(%rdx,%rdx,4), %r8d
	leal	(%r8,%r8), %ecx
	subl	%ecx, %eax
	movswq	%ax, %rax
	movl	(%rsp,%rax,4), %ecx
	movswq	%dx, %rdx
	movl	(%rsp,%rdx,4), %edx
	sall	$7, %edx
	movswl	%di, %eax
	imull	$26215, %eax, %eax
	sarl	$18, %eax
	movl	%edi, %r8d
	sarw	$15, %r8w
	subl	%r8d, %eax
	leal	(%rax,%rax,4), %eax
	leal	(%rax,%rax), %r8d
	movl	%edi, %eax
	subl	%r8d, %eax
	movswq	%ax, %rax
	movl	(%rsp,%rax,4), %eax
	sall	$14, %eax
	movl	%eax, %r8d
	cmpw	$9, %di
	jle	.L10
	salq	$8, %rdi
	sarq	$56, %rdi
	cmpb	$1, %dil
	jne	.L11
	orl	$536870912, %ecx
	orl	%edx, %ecx
	orl	%eax, %ecx
	orl	$12582912, %ecx
	movl	%ecx, (%rsi)
	movl	$0, %eax
	jmp	.L9
.L11:
	movl	%ecx, %eax
	orl	$268435456, %eax
	orl	%eax, %edx
	movl	%r8d, %ecx
	orl	%edx, %ecx
	orl	$12582912, %ecx
	movl	%ecx, (%rsi)
	movl	$0, %eax
	jmp	.L9
.L10:
	salq	$8, %rdi
	sarq	$56, %rdi
	cmpb	$1, %dil
	jne	.L12
	orl	$536870912, %ecx
	orl	%edx, %ecx
	orl	%eax, %ecx
	movl	%ecx, (%rsi)
	movl	$0, %eax
	jmp	.L9
.L12:
	movl	%ecx, %eax
	orl	$268435456, %eax
	orl	%eax, %edx
	movl	%edx, %ecx
	orl	%r8d, %ecx
	movl	%ecx, (%rsi)
	movl	$0, %eax
	jmp	.L9
.L14:
	movl	$1, %eax
	jmp	.L9
.L15:
	movl	$1, %eax
	jmp	.L9
.L16:
	movl	$1, %eax
.L9:
	movq	40(%rsp), %rsi
	xorq	%fs:40, %rsi
	je	.L13
	call	__stack_chk_fail
.L13:
	addq	$56, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE61:
	.size	set_display_bits_from_tod, .-set_display_bits_from_tod
	.globl	lcd_update
	.type	lcd_update, @function
lcd_update:
.LFB62:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movl	$temp, %esi
	movl	TIME_OF_DAY_SEC(%rip), %edi
	call	set_tod_from_secs
	cmpl	$1, %eax
	je	.L19
	movl	$LCD_DISPLAY_PORT, %esi
	movq	temp(%rip), %rdi
	call	set_display_bits_from_tod
	movl	$0, %eax
.L19:
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE62:
	.size	lcd_update, .-lcd_update
	.comm	temp,8,8
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.6) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
