;61.编程,屏幕中间显示当前的月份。
assume cs:code,ds:data,ss:stack
data segment
	db 128 dup(0)
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov al,8
            out 70h,al
            in al,71h

            mov ah,al
            mov cl,4
            shr ah,cl;ah为月份的十位数
            and al,00001111b;al为月份的个位数

            add ah,30h
            add al,30h

            mov bx,0b800h
            mov es,bx
            mov byte ptr es:[160*12+40*2],ah
            mov byte ptr es:[160*12+41*2],al

            mov ax,4c00h
            int 21h
code ends
end start