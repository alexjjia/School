	.file	"nCr.c"
	.text
.globl Factorial
	.type	Factorial, @function
Factorial:
	pushq	%rbp
	movq	%rsp, %rbp
	movl	%edi, -20(%rbp)
	cmpl	$33, -20(%rbp)
	jle	.L2
	movl	$0, %eax
	jmp	.L3
.L2:
	movl	$1, -8(%rbp)
	movl	-20(%rbp), %eax
	movl	%eax, -4(%rbp)
	jmp	.L4
.L5:
	movl	-8(%rbp), %eax
	imull	-4(%rbp), %eax
	movl	%eax, -8(%rbp)
	subl	$1, -4(%rbp)
.L4:
	cmpl	$0, -4(%rbp)
	jg	.L5
	movl	-8(%rbp), %eax
.L3:
	leave
	ret
	.size	Factorial, .-Factorial
.globl nCr
	.type	nCr, @function
nCr:
	pushq	%rbp
	movq	%rsp, %rbp
	pushq	%r12
	pushq	%rbx
	subq	$32, %rsp
	movl	%edi, -36(%rbp)
	movl	%esi, -40(%rbp)
	movl	-40(%rbp), %eax
	cmpl	-36(%rbp), %eax
	jle	.L8
	movl	$0, %eax
	jmp	.L9
.L8:
	movl	-36(%rbp), %eax
	movl	%eax, %edi
	call	Factorial
	movl	%eax, %ebx
	movl	-40(%rbp), %eax
	movl	%eax, %edi
	call	Factorial
	movl	%eax, %r12d
	movl	-40(%rbp), %eax
	movl	-36(%rbp), %edx
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, %edi
	call	Factorial
	movl	%r12d, %edx
	imull	%eax, %edx
	movl	%edx, -44(%rbp)
	movl	%ebx, %edx
	movl	%edx, %eax
	sarl	$31, %edx
	idivl	-44(%rbp)
	movl	%eax, -20(%rbp)
	movl	-20(%rbp), %eax
.L9:
	addq	$32, %rsp
	popq	%rbx
	popq	%r12
	leave
	ret
