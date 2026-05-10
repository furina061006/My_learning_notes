	.file	"main.c"
	.text
	.section .rdata,"dr"
	.align 8
.LC0:
	.ascii "\350\241\245\345\205\250\351\242\234\346\226\207\345\255\227\357\274\232______~(\342\210\240\343\203\273\317\211< )\342\214\222\342\230\206\12\0"
.LC1:
	.ascii "%s\0"
.LC2:
	.ascii "YEAH,bro!\12%s!\0"
	.align 8
.LC3:
	.ascii "what's a pity!\12your answer is fault.\0"
	.text
	.globl	main
	.def	main;	.scl	2;	.type	32;	.endef
	.seh_proc	main
main:
.LFB49:
	pushq	%rbp
	.seh_pushreg	%rbp
	movq	%rsp, %rbp
	.seh_setframe	%rbp, 0
	subq	$48, %rsp
	.seh_stackalloc	48
	.seh_endprologue
	call	__main
	leaq	.LC0(%rip), %rax
	movq	%rax, %rcx
	call	__mingw_printf
	leaq	-6(%rbp), %rax
	leaq	.LC1(%rip), %rcx
	movq	%rax, %rdx
	call	__mingw_scanf
	movq	.refptr.answer(%rip), %rax
	movq	(%rax), %rdx
	leaq	-6(%rbp), %rax
	movq	%rax, %rcx
	call	strcmp
	testl	%eax, %eax
	jne	.L2
	movq	$0, -16(%rbp)
	leaq	-16(%rbp), %rax
	movq	%rax, %rcx
	call	_Z12SendPasswordPPc
	movq	-16(%rbp), %rdx
	leaq	.LC2(%rip), %rax
	movq	%rax, %rcx
	call	__mingw_printf
	jmp	.L3
.L2:
	leaq	.LC3(%rip), %rax
	movq	%rax, %rcx
	call	__mingw_printf
.L3:
	movl	$0, %eax
	addq	$48, %rsp
	popq	%rbp
	ret
	.seh_endproc
	.def	__main;	.scl	2;	.type	32;	.endef
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 15.2.0"
	.def	strcmp;	.scl	2;	.type	32;	.endef
	.def	_Z12SendPasswordPPc;	.scl	2;	.type	32;	.endef
	.section	.rdata$.refptr.answer, "dr"
	.p2align	3, 0
	.globl	.refptr.answer
	.linkonce	discard
.refptr.answer:
	.quad	answer
