;显示a~z,按下esc改变颜色
assume cs:code,ds:data,ss:stack
data segment
	dw 0,0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

            mov ax,data
            mov ds,ax

            mov ax,0
            mov es,ax

            push es:[4*9]
            pop ds:[0]
            push es:[4*9+2]
            pop ds:[2];将原来的int9的入口地址保存到data段中

            cli
            mov word ptr es:[9*4],offset int9

            mov es:[9*4+2],cs
            sti

            mov ax,0b800h
            mov es,ax
            mov ah,'a'
        s:  mov es:[160*12+40*2],ah
            call delay
            inc ah
            cmp ah,'z'
            jna s

            mov ax,0
            mov es,ax

            push ds:[0]
            pop es:[4*9]
            push ds:[2]
            pop es:[4*9+2];将原来的入口地址再恢复回去

            mov ax,4c00h
            int 21h

delay:      push ax
            push dx
            
            mov dx,14
            mov ax,0
    s1:     sub ax,1
            sbb dx,0
            cmp ax,0
            jne s1
            cmp dx,0
            jne s1
            
            pop dx
            pop ax
            ret
int9:       push ax;键盘输入调用9号中断
            push bx
            push es

            in al,60h  ;从60h端口读出键盘的输入
            ;调用原来bios提供的9中断程序 不能用int9因为这里已经把int9里面的地址改了,自己模拟int9调用原来的bios的中断程序
            pushf;标志寄存器入栈
            call dword ptr ds:[0];cs ip入栈 ip =ds:[0] cs=ds:[2]

            cmp al,1;esc的扫描码是1
            jne int9ret

            mov ax,0b800h
            mov es,ax
            inc byte ptr es:[160*12+40*2+1]
int9ret:    pop es
            pop bx
            pop ax
            iret

code ends
end start