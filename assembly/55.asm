;55编写、安装中断7ch的中断例程。
;功能:将一个全是字母，以О结尾的字符串，转化为大写。
;参数: ds:si指向字符串的首地址。
;应用举例:将data 段中的字符串转化为大写。
assume cs:code,ds:data,ss:stack
data segment
	db "conversation",0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128


            mov ax,cs
            mov ds,ax
            mov si,offset do7ch

            mov ax,0
            mov es,ax
            mov di,200h

            mov cx,offset do7chend-offset do7ch
            cld
            rep movsb;把do7ch这段程序复制到0:200h处

            mov ax,0
            mov es,ax
            mov word ptr es:[4*7ch],200h
            mov word ptr es:[4*7ch+2],0;设置7ch处中断向量表

            mov ax,data
            mov ds,ax
            mov si,0;参数
            int 7ch

            mov ax,0b800h
            mov es,ax
            mov di,160*10+2*15

            mov dx,0
 showString:
            mov dl,ds:[si]
            cmp dx,0
            je endshowString
            mov es:[di],dl
            mov byte ptr es:[di+1],00000100b
            inc si
            add di,2
            jmp showString


endshowString:
			mov ax,4c00h
            int 21h
do7ch:      push si
            mov dx,0
change:     mov dl,ds:[si]
            cmp dx,0
            je ok
            and byte ptr ds:[si],11011111b
            inc si
            jmp change
        ok: pop si
            iret
do7chend:   nop
code ends
end start
