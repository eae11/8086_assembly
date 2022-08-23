;53.编写0号中断处理程序
assume cs:code,ss:stack

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			mov ax,cs
			mov ds,ax
			mov si,offset do0

			mov ax,0
			mov es,ax
			mov di,200h

			mov cx,offset do0end-offset do0
			cld
			rep movsb;把do0这段程序复制到0:200这段空间中

            mov ax,0;设置中断向量表0号位置
            mov es,ax
            mov word ptr es:[0*4],200h
            mov word ptr es:[0*4+2],0
            
            int 0
            mov bx,0b800h
			mov es,bx
			
			mov bx,1
			mov dh,00010111b
			mov cx,2000
setColor:	mov es:[bx],dh
			add bx,2
			loop setColor
            mov ax,4c00h
            int 21h

    do0:    jmp do0start;
string:     db 'overflow!'
    do0start:
            mov ax,cs
            mov ds,ax
            mov si,offset string-offset do0+200h  ;字符串的起始偏移地址 也可以写成  db出的offset- offset do0+200

            mov ax,0b800h
            mov es,ax
            mov di,160*10+20*2

            mov cx,9
s:          mov al,ds:[si]
            mov es:[di],al
            mov byte ptr es:[di+1],00000100b
            add di,2
            inc si
            loop s
			
            iret
    do0end: nop
code ends
end start
