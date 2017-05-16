	.file	"tokenizer.c"
	.text
.globl TKCreate
	.type	TKCreate, @function
TKCreate:
.LFB0:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	pushq	%rbx
	subq	$40, %rsp
	movq	%rdi, -40(%rbp)
	movl	$16, %edi
	.cfi_offset 3, -24
	call	malloc
	movq	%rax, -24(%rbp)
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, %rdx
	movq	-24(%rbp), %rax
	movq	%rdx, (%rax)
	movq	-40(%rbp), %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	strcpy
	movq	-24(%rbp), %rax
	movl	$0, 8(%rax)
	movq	-24(%rbp), %rax
	movq	(%rax), %rbx
	movq	-40(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	leaq	(%rbx,%rax), %rax
	movb	$0, (%rax)
	movq	-24(%rbp), %rax
	movl	$6, 12(%rax)
	movq	-24(%rbp), %rax
	addq	$40, %rsp
	popq	%rbx
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE0:
	.size	TKCreate, .-TKCreate
.globl TKDestroy
	.type	TKDestroy, @function
TKDestroy:
.LFB1:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movq	%rdi, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	free
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE1:
	.size	TKDestroy, .-TKDestroy
.globl state_octal
	.type	state_octal, @function
state_octal:
.LFB2:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L6
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$56, %al
	je	.L7
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	je	.L7
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_octal
	jmp	.L8
.L7:
	movq	-16(%rbp), %rax
	movl	$4, 12(%rax)
	movl	-4(%rbp), %eax
	jmp	.L8
.L6:
	movl	-4(%rbp), %eax
.L8:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE2:
	.size	state_octal, .-state_octal
.globl state_hex
	.type	state_hex, @function
state_hex:
.LFB3:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$4096, %eax
	testl	%eax, %eax
	je	.L11
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_hex
	jmp	.L12
.L11:
	movl	-4(%rbp), %eax
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE3:
	.size	state_hex, .-state_hex
.globl state_float
	.type	state_float, @function
state_float:
.LFB4:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L15
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_float
	jmp	.L16
.L15:
	movq	-16(%rbp), %rax
	movl	$2, 12(%rax)
	movl	-4(%rbp), %eax
.L16:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE4:
	.size	state_float, .-state_float
.globl state_3_f
	.type	state_3_f, @function
state_3_f:
.LFB5:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	je	.L19
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$45, %al
	jne	.L20
.L19:
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_float
	jmp	.L21
.L20:
	movq	-16(%rbp), %rax
	movl	$4, 12(%rax)
	movl	-4(%rbp), %eax
.L21:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE5:
	.size	state_3_f, .-state_3_f
.globl state_3
	.type	state_3, @function
state_3:
.LFB6:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L24
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_3
	jmp	.L25
.L24:
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$101, %al
	je	.L26
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$69, %al
	jne	.L27
.L26:
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_3_f
	jmp	.L25
.L27:
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L28
	movq	-16(%rbp), %rax
	movl	$4, 12(%rax)
	movl	-4(%rbp), %eax
	jmp	.L25
.L28:
	movq	-16(%rbp), %rax
	movl	$2, 12(%rax)
	movl	-4(%rbp), %eax
.L25:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE6:
	.size	state_3, .-state_3
.globl state_2
	.type	state_2, @function
state_2:
.LFB7:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L31
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_2
	jmp	.L32
.L31:
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$101, %al
	je	.L33
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$69, %al
	jne	.L34
.L33:
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_3_f
	jmp	.L32
.L34:
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$46, %al
	jne	.L35
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_3
	jmp	.L32
.L35:
	movq	-16(%rbp), %rax
	movl	$1, 12(%rax)
	movl	-4(%rbp), %eax
.L32:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE7:
	.size	state_2, .-state_2
.globl state_1
	.type	state_1, @function
state_1:
.LFB8:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$56, %al
	je	.L38
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$57, %al
	je	.L38
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$88, %al
	je	.L39
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$120, %al
	jne	.L40
.L39:
	movq	-16(%rbp), %rax
	movl	$3, 12(%rax)
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_hex
	jmp	.L41
.L40:
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$46, %al
	jne	.L42
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_3
	jmp	.L41
.L42:
	movq	-16(%rbp), %rax
	movl	$0, 12(%rax)
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_octal
	jmp	.L41
.L38:
	movq	-16(%rbp), %rax
	movl	$4, 12(%rax)
	movl	-4(%rbp), %eax
	addl	$1, %eax
.L41:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE8:
	.size	state_1, .-state_1
.globl state_init
	.type	state_init, @function
state_init:
.LFB9:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$16, %rsp
	movl	%edi, -4(%rbp)
	movq	%rsi, -16(%rbp)
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$2048, %eax
	testl	%eax, %eax
	je	.L45
	movq	-16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	cmpb	$48, %al
	jne	.L46
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_1
	jmp	.L47
.L46:
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_2
	jmp	.L47
.L45:
	call	__ctype_b_loc
	movq	(%rax), %rdx
	movq	-16(%rbp), %rax
	movq	(%rax), %rcx
	movl	-4(%rbp), %eax
	cltq
	leaq	(%rcx,%rax), %rax
	movzbl	(%rax), %eax
	movsbq	%al, %rax
	addq	%rax, %rax
	leaq	(%rdx,%rax), %rax
	movzwl	(%rax), %eax
	movzwl	%ax, %eax
	andl	$8192, %eax
	testl	%eax, %eax
	je	.L48
	movl	-4(%rbp), %eax
	leal	1(%rax), %edx
	movq	-16(%rbp), %rax
	movq	%rax, %rsi
	movl	%edx, %edi
	call	state_init
	jmp	.L47
.L48:
	movl	-4(%rbp), %eax
	addl	$1, %eax
.L47:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE9:
	.size	state_init, .-state_init
.globl TKGetNextToken
	.type	TKGetNextToken, @function
TKGetNextToken:
.LFB10:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movq	(%rax), %rdx
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	cltq
	leaq	(%rdx,%rax), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L51
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -16(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	movq	-24(%rbp), %rdx
	movq	%rdx, %rsi
	movl	%eax, %edi
	call	state_init
	movl	%eax, -4(%rbp)
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	subl	%eax, -4(%rbp)
	movl	-4(%rbp), %eax
	movslq	%eax, %rdx
	movq	-24(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rcx
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	cltq
	addq	%rax, %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
	movq	-24(%rbp), %rax
	movl	8(%rax), %eax
	movl	%eax, %edx
	addl	-4(%rbp), %edx
	movq	-24(%rbp), %rax
	movl	%edx, 8(%rax)
	movl	-4(%rbp), %eax
	cltq
	addq	-16(%rbp), %rax
	movb	$0, (%rax)
	movq	-16(%rbp), %rax
	jmp	.L52
.L51:
	movl	$0, %eax
.L52:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE10:
	.size	TKGetNextToken, .-TKGetNextToken
	.section	.rodata
.LC0:
	.string	"\noctal %s\n"
.LC1:
	.string	"\nhexadecimal %s\n"
.LC2:
	.string	"\ndecimal %s\n"
.LC3:
	.string	"\nfloat %s\n"
.LC4:
	.string	"\nbad input [0x%02x]\n "
	.text
.globl main
	.type	main, @function
main:
.LFB11:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	%edi, -20(%rbp)
	movq	%rsi, -32(%rbp)
	movq	-32(%rbp), %rax
	addq	$8, %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	TKCreate
	movq	%rax, -16(%rbp)
	movq	-16(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	strlen
	addq	$1, %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -8(%rbp)
.L63:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	TKGetNextToken
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	je	.L67
.L55:
	movq	-16(%rbp), %rax
	movl	12(%rax), %eax
	cmpl	$1, %eax
	je	.L59
	cmpl	$1, %eax
	jb	.L58
	cmpl	$2, %eax
	je	.L60
	cmpl	$3, %eax
	je	.L61
	jmp	.L66
.L58:
	movl	$.LC0, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L62
.L61:
	movl	$.LC1, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L62
.L59:
	movl	$.LC2, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L62
.L60:
	movl	$.LC3, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L62
.L66:
	movl	$.LC4, %eax
	movq	-8(%rbp), %rdx
	movq	%rdx, %rsi
	movq	%rax, %rdi
	movl	$0, %eax
	call	printf
	jmp	.L63
.L62:
	jmp	.L63
.L67:
	nop
.L65:
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	free
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	TKDestroy
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE11:
	.size	main, .-main
	.ident	"GCC: (GNU) 4.4.7 20120313 (Red Hat 4.4.7-16)"
	.section	.note.GNU-stack,"",@progbits
