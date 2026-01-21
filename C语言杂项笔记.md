# C语言杂项笔记
>在嵌入式的入门过程里，我时常会感到困惑
>所以写下这篇笔记，供以复习
## 目录
- [C语言杂项笔记](#c语言杂项笔记)
  - [目录](#目录)
  - [1. #define（宏预处理） 的作用](#1-define宏预处理-的作用)
      - [一、定义常量（最常见）:](#一定义常量最常见)
      - [二、定义宏函数（带参数的宏）](#二定义宏函数带参数的宏)
      - [三、条件编译开关（控制代码是否编译）](#三条件编译开关控制代码是否编译)
      - [四、防止头文件重复包含](#四防止头文件重复包含)
        - [(其实和上一点同源)](#其实和上一点同源)
      - [五、字符串化与拼接（高级用法）](#五字符串化与拼接高级用法)
  - [2、程序编译运行过程](#2程序编译运行过程)
    - [Q: 链接时发生了什么？](#q-链接时发生了什么)
    - [A :](#a-)
        - [C 程序内存布局：`.text`、`.data` 与 `.bss` 段了](#c-程序内存布局textdata-与-bss-段了)
        - [主要内存段概览](#主要内存段概览)
      - [示例代码与段归属](#示例代码与段归属)
      - [而在嵌入式系统（如 STM32）中：](#而在嵌入式系统如-stm32中)
  - [3、位运算](#3位运算)
    - [`~`  (按位取反)](#--按位取反)
    - [`| `（按位或）](#-按位或)
    - [`&`(按位与)](#按位与)
    - [`^`(按位异或)](#按位异或)
    - [没时间写了😵,先写一下常见位运算的概况](#没时间写了先写一下常见位运算的概况)
  - [4、规范函数库的写法](#4规范函数库的写法)
    - [一个函数的完整写法](#一个函数的完整写法)
      - [注释](#注释)
      - [函数定义与实现](#函数定义与实现)
##  1. #define（宏预处理） 的作用
***C 语言编译的第一步是预处理（由预处理器 cpp 完成），它会处理所有以 # 开头的指令***
#### 一、定义常量（最常见）:
```c
#define NAME value
#define Pi 3.1415926
#define 苦命鸳鸯 250234(但其实不能用中文)
```
- 用一个名字代替一个值，提高可读性和可维护性
- 修改只需改一处
- 比 const int 更节省 RAM（不占内存，直接替换为字面量）
>纯文本替换，只是在预处理阶段，把下文中的`NAME`文本全部换成`value`文本，十分单纯，执行这个重复的过程，所以又称`#define`为**宏处理**  
***
#### 二、定义宏函数（带参数的宏）
```C
#define MACRO_NAME(param1, param2)  (表达式)
#define MIN(a, b)                   ((a) < (b) ? (a) : (b))
#define SET_BIT(REG, BIT)           ((REG) |= (BIT))
```
- 实现类似函数的功能，但没有函数调用开销（直接内联展开）
> 每个变量都必须加括号！否则可能因运算符优先级出错。
 ```C
> #define SQUARE(x) x * x   // SQUARE(2+3) → 2+3*2+3 = 11 ❌
> #define SQUARE(x) ((x) * (x))  // → ((2+3) * (2+3)) = 25 ✅
 ```
***
#### 三、条件编译开关（控制代码是否编译）
```C
#define FEATURE_ENABLED
// ...
#ifdef FEATURE_ENABLED
    // 这段代码只有定义了才编译
#endif
```
- 在 Keil 中，也可以通过 魔术棒 → Define 来定义这些宏，无需在每个源程序文件的代码开头都写一次, 也是达到了**宏**的作用
>此时`#define`后边只有一个定义名
***
#### 四、防止头文件重复包含 
##### (其实和上一点同源)
```C
#ifndef __MY_HEADER_H  → 条件为真（如果没定义过）
#define __MY_HEADER_H  → 定义这个宏
    /* 头文件内容 */    → 保留中间的内容
#endif                 → 结束条件块
```
- 避免同一个头文件被 `#include` 多次，导致重复定义错误
>最后的预处理结果是只留下
>`头文件内容`
***
#### 五、字符串化与拼接（高级用法）
- ##### 字符串化（Stringify）—— 用 \#
*用来输出名字*
```C
#define PRINT_VAR(x) printf(#x " = %d\n", x)

PRINT_VAR(count);  // 展开为：printf("count" " = %d\n", count);
                   // 等价于：printf("count = %d\n", count);
                   //变成了两个字符串`count`和` = %d\n `
```
- ##### 标识符拼接（Token Pasting）—— 用 \##
*用来构造名字*
```C
#define REG_PORT(n) GPIO##n
#define ENABLE_CLK(port) RCC_APB2PeriphClockCmd(RCC_APB2Periph_##port, ENABLE)

ENABLE_CLK(GPIOA);  // 展开为：RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
```
**简单来说**

|操作符|名称|作用|输入|输出|简单说|
|---|---|---|---|---|---|
|#	|字符串化（Stringify）|	把宏参数**变成字符串字面量**|	标识符（如 count）|	"count"（带双引号的字符串）|`#x` → "x"|
|##	|标识符拼接（Token Pasting）|	把两个符号**拼成一个新标识符**|	GPIO + A|	GPIOA（一个变量/宏名）|`a##b` → `ab`|

***
***
## 2、程序编译运行过程
> ### C程序从生到跑有六大过程:

**前四个阶段合起来叫 “构建”（`Build`），结果是一个可执行文件**

| 阶段 | 工具 | 输入->输出 | 作用 |
|---|---|---|---|
|预处理（Preprocessing）| cpp |  ``.c`` → `.i`|处理 #include、#define、条件编译等 |
编译（Compilation）|cc1|`.i` → `.s`|把 C 代码翻译成汇编语言|
汇编（Assembly）|as|`.s` → `.o`|把汇编转成机器码（目标文件，含符号但未定位）|
链接（Linking）|ld|`.o` + 库 → 可执行文件（如 `a.out`）|合并多个 .o，解析符号引用，分配最终地址|

**自此,  C源程序文件转为可执行文件**
**后两个阶段是运行阶段：**
|阶段|	谁负责	|发生时机|	关键动作|
|---|---|---|---|
加载|	操作系统|	运行时|	把可执行文件装入内存，准备执行
运行|
***
### Q: 链接时发生了什么？
### A :
> 链接器为**每个函数/全局变量**分配最终的虚拟地址（在可执行文件中固定）
> 把多个 `.o` 文件中**相互引用的符号**（如函数、变量）进行**地址绑定**，解决“谁调用了谁”的问题，最终生成可执行文件。
> **地址绑定**: **相互引用的符号**都会分配同一`text`段地址
> 那是**段**是什么意思呢？
> 这就要谈到

##### C 程序内存布局：`.text`、`.data` 与 `.bss` 段了

当你编译并运行一个 C 程序，操作系统会将其加载到内存，并划分为几个关键区域。理解这些段（segments/sections）对调试、优化和嵌入式开发至关重要。

#####  主要内存段概览
(内存从低到高)

| 段名 | 全称 | 作用 | 权限 |
|------|------|------|------|
| `.text` | 代码段（Text Segment） | 存放程序的机器指令（函数代码） | **只读 + 可执行** |
| `.data` | 已初始化数据段 | 存放已初始化的全局变量和静态变量 | 可读 + 可写 |
| `.bss` | 未初始化数据段（Block Started by Symbol） | 存放未初始化或初始化为 0 的全局/静态变量 | 可读 + 可写（运行前清零） |
| **堆（Heap）** | — | 动态分配内存（`malloc`、`new`） | 可读写，运行时增长 |
| **栈（Stack）** | — | 局部变量、函数参数、返回地址等 | 可读写，自动管理 |

>  `.text`、`.data`、`.bss` 是 **静态内存布局**，由编译器和链接器在构建阶段确定。

---

#### 示例代码与段归属

```c
#include <stdio.h>
#include <stdlib.h>

// 1. 已初始化的全局变量 → .data
int global_var = 100;

// 2. 初始化为 0 的全局变量 → .bss
int global_zero = 0;

// 3. 未初始化的全局变量 → .bss
int global_uninit;

// 4. 已初始化的静态变量（文件作用域） → .data
static int static_global = 200;

// 5. 未初始化的静态变量 → .bss
static int static_uninit;

// 6. 函数代码 → .text
void my_function(int x) {
    // 7. 局部变量 → 栈（Stack）
    int local_var = x + 1;

    // 8. 字符串字面量 → .rodata（只读数据段，通常紧邻 .text）
    printf("Hello from my_function! local=%d\n", local_var);
}

int main(void) {
    // 9. 局部变量 → 栈
    int a = 10;

    // 10. 动态分配 → 堆（Heap）
    int *p = (int *)malloc(sizeof(int));
    *p = 42;

    my_function(a);

    free(p);
    return 0;
}
```
***
#### 而在嵌入式系统（如 STM32）中：
- .text 和 .rodata 通常放在 Flash（只读存储器）
- .data 需在启动时从 Flash 复制到 RAM
- .bss 需在启动时 清零

## 3、位运算
### `~`  (按位取反)
```C
~a  // 把 a 的每一位都翻转：0 变 1，1 变 0
```
>注意：~ 是 按位取反，不是逻辑取反（!）
***
### `| `（按位或）
`|` 是 按位或（bitwise OR）
它对两个数的每一位进行比较：
如果任意一位是 1，结果就是 1
只有当两位都是 0，结果才是 0
**也就是**
**有一则一**
以下是基础运算:
```c
a |= b;   //等价于 a = a | b;
a = 0b1010;  // 二进制 1010
b = 0b0110;  // 二进制 0110
a |= b;      // a = a | b = 0b1110
```
在嵌入式中:
```C
RCC->APB2ENR |= RCC_APB2Periph;
//其中, RCC_APB2Periph =0x00001000
//结果就是
把 RCC->APB2ENR里"RCC_APB2Periph 对应的位"打开（置为 1），不影响其他位。
```
***
###  `&`(按位与)
`&` 是 按位与（bitwise AND）
规则：
只有当两位都是 1，结果才是 1
否则为 0
**其实**,个人认为`&`就是`|`的否运算
我们不妨这样看`&`:
它对两个数的每一位进行比较：
如果任意一位是 0，结果就是 0
只有当两位都是 1，结果才是 1
**也就是**
**有零则零**
>这与`|`恰好相反

以下是基础运算:
```c
a = 0b1110;
b = 0b0110;
a &= b;   // a = 0b0110
```
在嵌入式中:
```C
RCC->APB2ENR &= ~RCC_APB2Periph;
//由上文可知,RCC_APB2Periph =0x00001000     所以~RCC_APB2Periph =0x11110111
//结果就是
把 RCC->APB2ENR里"RCC_APB2Periph 对应的位"关闭（置为 0），不影响其他位。
```
***
### `^`(按位异或)
规则：
只有当两位状态不同，结果才是 1
相同为 0
**也就是**
**不同则一**

***
### 没时间写了😵,先写一下常见位运算的概况
C语言有6种基本的位运算符，如下表所示：

| 运算符 | 名称     | 功能描述                                               |
|--------|----------|--------------------------------------------------------|
| `&`    | 按位与   | 对应的两个二进位均为1时，结果位才为1                   |
| `\|`   | 按位或   | 对应的两个二进位有一个为1时，结果位就为1               |
| `^`    | 按位异或 | 对应的二进位不同时为1，相同时为0                       |
| `~`    | 取反     | 单目运算符，将1变0，0变1                               |
| `<<`   | 左移     | 将二进位向左移动，低位补0                              |
| `>>`   | 右移     | 将二进位向右移动，高位补符号位（有符号数）或0（无符号数） |

## 4、规范函数库的写法
### 一个函数的完整写法
```c
/**
  * @brief  Enables or disables the AHB peripheral clock.
  * @param  RCC_AHBPeriph: specifies the AHB peripheral to gates its clock.
  *   
  *   For @b STM32_Connectivity_line_devices, this parameter can be any combination
  *   of the following values:        
  *     @arg RCC_AHBPeriph_DMA1
  *     @arg RCC_AHBPeriph_DMA2
  *     @arg RCC_AHBPeriph_SRAM
  *     @arg RCC_AHBPeriph_FLITF
  *     @arg RCC_AHBPeriph_CRC
  *     @arg RCC_AHBPeriph_OTG_FS    
  *     @arg RCC_AHBPeriph_ETH_MAC   
  *     @arg RCC_AHBPeriph_ETH_MAC_Tx
  *     @arg RCC_AHBPeriph_ETH_MAC_Rx
  * 
  *   For @b other_STM32_devices, this parameter can be any combination of the 
  *   following values:        
  *     @arg RCC_AHBPeriph_DMA1
  *     @arg RCC_AHBPeriph_DMA2
  *     @arg RCC_AHBPeriph_SRAM
  *     @arg RCC_AHBPeriph_FLITF
  *     @arg RCC_AHBPeriph_CRC
  *     @arg RCC_AHBPeriph_FSMC
  *     @arg RCC_AHBPeriph_SDIO
  *   
  * @note SRAM and FLITF clock can be disabled only during sleep mode.
  * @param  NewState: new state of the specified peripheral clock.
  *   This parameter can be: ENABLE or DISABLE.
  * @retval None
  */
void RCC_AHBPeriphClockCmd(uint32_t RCC_AHBPeriph, FunctionalState NewState)
{
  /* Check the parameters */
  assert_param(IS_RCC_AHB_PERIPH(RCC_AHBPeriph));
  assert_param(IS_FUNCTIONAL_STATE(NewState));

  if (NewState != DISABLE)
  {
    RCC->AHBENR |= RCC_AHBPeriph;
  }
  else
  {
    RCC->AHBENR &= ~RCC_AHBPeriph;
  }
}
```
#### 注释
```C
/**
  *
  *
  */
```
每行前边都有一个`*`,来表示这行是注释

---
注释内的内容分为
- 简要描述`@brief`
- 参数含义`@param`
- 参数具体取值`@arg`
- 注意事项`@note`
- 返回值的具体含义`@retval`

一般是这几个部分组成,具体情况可以看`@`,即`Doxygen`风格的文档注释标签来分析, 以下是一些常见的`Doxygen`风格标签:
| 标签 | 用途 | 示例 |
|------|:------:|------|
| `@brief` | 简要描述函数/结构体/宏的作用（必写） | `@brief Initializes the GPIO peripheral.` |
| `@param` | 描述函数参数的含义 | `@param GPIOx: where x can be (A..K) to select the GPIO peripheral.` |
| `@arg` | 列出某个参数允许的具体取值（常用于枚举或宏定义） | `@arg GPIO_PIN_0: Pin 0 selected`<br>`@arg GPIO_PIN_1: Pin 1 selected` |
| `@note` | 注意事项、限制条件、副作用等 | `@note This function must be called before using GPIO.` |
| `@retval` | 描述返回值的具体含义（尤其用于返回状态码） | `@retval HAL_OK: Operation is OK`<br>`@retval HAL_ERROR: Error occurred` |
| `@return` | 通用返回值说明（和 `@retval` 类似，但更笼统） | `@return None`（用于 void 函数） |
|`@class / @namespace`|类/命名空间||
|`@exception / @throw`|异常||
|`@overload`|函数重载||
|`@template`|模板||
| `@see` | 参考其他函数或文档 | `@see GPIO_Init()` |
| `@code{.c} ... @endcode` | 插入示例代码块 | 用于展示用法 |
| `@defgroup` / `@addtogroup` | 分组管理（大型库如 HAL 会用） | 组织模块化文档 |
| `@author` / `@date` | 作者和日期（部分项目保留） | 多见于内核或老代码 |
|`@ref`|使后面的标识符转为链接，点它可以跳转到相关详细说明|创建内部交叉引用链接|
#### 函数定义与实现
对每一模块的功能都进行注释解明.