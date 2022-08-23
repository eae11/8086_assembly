;课程设计1未解决除法溢出问题
assume cs:code,ds:data,ss:stack
data segment
	db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
    db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
    db	'1993','1994','1995'
    ;以上是表示21年的21个字符串 year


    dd	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd	345980,590827,80353,118300,184300,275900,375300,464900,593700
    ;以上是表示21年公司总收入的21个dword数据	sum

    dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
    dw	11542,14430,15257,17800
data ends
table segment
    db 21 dup('year summ ne ?? ')
table ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			call input_table
			call clear_screen
            call output_table
            mov ax,4c00h
            int 21h
;=================================
clear_screen:
            mov bx,0b800h
            mov es,bx
            mov bx,0

            mov dx,0700h;数据00 白色 00000111b
            mov cx,2000

clearScreen:mov es:[bx],dx
            add bx,2
            loop clearScreen
            ret
;把table中的数据输出到屏幕上
output_table:
            mov bx,table
            mov ds,bx
            mov si,0

            mov bx,0b800h
            mov es,bx
            mov di,160*3;行
            mov cx,21

outputTable:call show_year
            call show_sum
            call show_ne
            call show_average
            add di,160;换行
            add si,16;换行
            loop outputTable
            ret
;==============================
show_average:
            push ax
            push bx
            push cx
            push dx
            push ds
            push es
            push si
            push di
            mov ax,ds:[si+13]
            mov dx,0
            add di,50*2
            call short_div
            pop di
            pop si
            pop es
            pop ds
            pop dx
            pop cx
            pop bx
            pop ax
            ret
;==============================
show_ne:    push ax
            push bx
            push cx
            push dx
            push ds
            push es
            push si
            push di
            mov ax,ds:[si+10];低位   人数
            mov dx,0
            add di,30*2
            call short_div
            pop di
            pop si
            pop es
            pop ds
            pop dx
            pop cx
            pop bx
            pop ax
            ret
;显示收入
show_sum:   push ax
            push bx
            push cx
            push dx
            push ds
            push es
            push si
            push di

            mov ax,ds:[si+5];低位
            mov dx,ds:[si+7];高位
            add di,25*2
            call short_div
            pop di
            pop si
            pop es
            pop ds
            pop dx
            pop cx
            pop bx
            pop ax
            ret
;打印数字到屏幕上比如1234 4 3 2 1 倒着打印
;注意一个问题有的子程序要push有的不用,要看子程序修改的某些寄存器是否对调用他的程序有所影响,如果没有影响不用push
short_div:  mov cx,10
            div cx ;商ax 余数dx
            add dl,30h;+48  ascii 0->48  1->49
            mov es:[di+0],dl
            mov byte ptr es:[di+1],00000010b
            mov cx,ax;判断商是否为0 商为0就结束
            jcxz shortDivRet
            mov dx,0;清空余数 如果不清空余数会有问题 比如1234除以10余数4  ax123 dx4 下次再除的时候就是dx4高位和ax低位表示的数了就不是123了
            sub di,2;余数是4 3 2 1所以倒着来,减di
            jmp short_div

shortDivRet:ret
;显示年份
show_year:
            push ax;子程序用到的寄存器
            push cx
            push ds
            push es
            push si
            push di

            mov cx,4
            add di,3*2;列

showYear:   mov al,ds:[si]
            mov es:[di],al
            add di,2
            inc si
            loop showYear

            pop di
            pop si
            pop es
            pop ds
            pop cx
            pop ax
            ret
;把数据放到table段里面去
input_table:mov bx,data;数据段
            mov ds,bx
            mov si,0;年份和收入的指针

            mov bx,table;table段
            mov es,bx
            mov di,0;table指针

            mov bx,21*4*2;员工段
            mov cx,21

inputTable: call set_table
            add di,16
            add si,4
            add bx,2
            loop inputTable
            ret
set_table:  push ds:[si+0];年份
            pop es:[di+0]
            push ds:[si+2]
            pop es:[di+2]

            mov ax,ds:[si+21*4+0];收入因为后面要用到收入求平均值所以没用push而是放在寄存器里ax低位,dx高位
            mov dx,ds:[si+21*4+2]
            mov es:[di+5],ax
            mov es:[di+7],dx

            push ds:[bx];员工
            pop es:[di+10]

            div word ptr es:[di+10]
            mov es:[di+13],ax
            ret
code ends
end start