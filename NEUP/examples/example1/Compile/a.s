	.file	"a.c";声明源文件名
	.text;切换到.text段

	.data;切换到.data段
	.align 8;内存对齐指令，确保接下来的数据在 8 字节边界上，提高 CPU 读取速度
	;CPU一次读取只能按,0~7, 8~15这样的顺序读, 如果数据不在边界上,CPU需要读取多次,然后拼接在一起.
	;一般数据比较大的时候会用这个指令.
	;满足下面 任意一条，汇编器就会自动加 .align ：
	; 8字节变量
	; 结构体
	; 数组
	; 需要快速访问的全局数据


_ZL8password:;这种无 tab 的, 是标签，数据地址的代表
	.ascii "0d000721\0";内容
	
	.globl	answer;单纯声明answer是全局变量, 这相当于给链接器打标签,告诉后续的编译器这里有个全局变量可以链接.
	
	.section .rdata,"dr";这是自定义段的定义并切换的方法, "dr"是属性, 只读数据段,放常量用的.
.LC0:
	.ascii "Ciallo\0"
	
	.data
	.align 8
answer:
	.quad	.LC0;.quad,全称是quadruple word,标准上, word,全字, 是4字节的,但这里的word是两字节,历史遗留问题说是
	;定义一个 8字节的数据,这里存的就是.LC0,"Ciallo\0"的地址.
	
	.globl	example1
	
	.bss
	.align 8
example1:
	.space 8;这里没写,但是..text段里给char b 0个偏移量, 给int a 4个偏移量.
	
	.text
	.globl	_Z12SendPasswordPPc
	.def	_Z12SendPasswordPPc;	.scl	2;	.type	32;	.endef
	;上面这行是给链接器和调试器, 意思是
	; 我现在描述一个符号：_Z12SendPasswordPPc
	; 它是【全局外部符号】(scl=2)
	; 它是【函数】(type=32)
	; 描述完毕

	.seh_proc	_Z12SendPasswordPPc;函数开启标志,给操作系统看的, 让windows知道函数哪里开始, 然后如果函数奔溃, win可以正确打印栈堆,.seh_都是这个作用
_Z12SendPasswordPPc:
.LFB86:;函数栈帧开始的位置标记, 告诉调试器,这个函数栈帧的开始
	pushq	%rbp;将基址指针压入栈,这是为了保存调用者的栈帧状态。
	.seh_pushreg	%rbp
	movq	%rsp, %rbp;将当前的栈顶指针赋值给基址指针。建立当前函数的栈帧。
	.seh_setframe	%rbp, 0
	subq	$48, %rsp; 将rsp地址减去48, 开辟 48 字节的栈空间。这是为了存放局部变量（如 i, length）和对齐。
	.seh_stackalloc	48
	.seh_endprologue
	movq	%rcx, 16(%rbp); 把rcx寄存器上的值存到 RBP 向上 16 字节 的栈位置上。% rcx 里存的是函数的第一个参数
	movl	$1, 4+example1(%rip);把 1 赋值 到 全局变量example1 + 4(字节) 的 地址上, 其中example1 在堆上,%rip用来快速找到全局变量
	leaq	_ZL8password(%rip), %rax;计算字符串 password 的地址，然后把这个地址存入 rax 寄存器。
	;mov取值, lea取地址
	movq	%rax, %rcx; 参数要放在rcx里
	call	strlen;调用函数,返回值会在rax里,而eax是rax的低32位
	movl	%eax, -8(%rbp);值存在 -8 ~ -11 这 4 个地址
	movl	-8(%rbp), %eax
	addl	$1, %eax
	cltq; 把 eax 里的 32 位整数，“补全” 成 64 位整数，放到 rax 里。说白了, 就是int → long long的转变
	movq	%rax, %rcx
	call	malloc
	movq	%rax, %rdx
	movq	16(%rbp), %rax; 把ptarget指针的地址传到 rax 里
	movq	%rdx, (%rax); 把rdx里刚malloc的首地址传到ptarget指针的地址里, 因为有加(),所以不是rax寄存器本身
	movl	$0, -4(%rbp); 给 i 赋值 0 
	jmp	.L2; 无条件跳转到标签.L2(循环条件判断处)
.L3:
	movq	16(%rbp), %rax
	movq	(%rax), %rdx
	movl	-4(%rbp), %eax
	cltq
	addq	%rax, %rdx
	movl	-4(%rbp), %eax
	cltq
	leaq	_ZL8password(%rip), %rcx
	movzbl	(%rax,%rcx), %eax
	movb	%al, (%rdx)
	addl	$1, -4(%rbp)
.L2:
	movl	-4(%rbp), %eax
	cltq
	leaq	_ZL8password(%rip), %rdx
	movzbl	(%rax,%rdx), %eax;(%rax,%rdx)两寄存器值之和的地址的值, 赋给eax 
	testb	%al, %al;testb = 对 1 字节数据做 按位与. 结果放入第零标志寄存器ZF(zero flag)
	;对自己做按位与, 至少有一位是1.
	jne	.L3; 条件跳转,jump if not equal, 也就是看ZF的值是不是0
	movq	16(%rbp), %rax
	movq	(%rax), %rdx; rdx指向malloc的首地址
	movl	-4(%rbp), %eax; 现在的 i 的值
	cltq
	addq	%rdx, %rax; 算出最后'\0'的地址
	movb	$0, (%rax); 赋值进去
	;只占了3字节
	nop;No Operation,空指令,只占 1 字节位置、耗一个 CPU 周期，主要用来代码对齐和留空位,这里用作代码对齐
	;再占1字节, 后续指令首字节就可以从 16 字节边界开始, 这样CPU读取快
	;CPU 要求：一段代码块、函数入口、分支目标标签，尽量从 16 字节边界开始。
	;下面是收尾三件套:
	addq	$48, %rsp;把栈空间还回去
	popq	%rbp	;从栈顶弹出 8 字节 → 写入 rbp,同时 rsp 再往上走 8 字节。
	ret				;从栈顶弹出返回地址, 跳回这个地址, 函数结束，回到调用者
	.seh_endproc
	.ident	"GCC: (x86_64-posix-seh-rev0, Built by MinGW-Builds project) 15.2.0"
	.def	strlen;	.scl	2;	.type	32;	.endef
	.def	malloc;	.scl	2;	.type	32;	.endef
