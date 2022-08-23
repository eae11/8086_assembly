;63显示键盘状态字节到屏幕
assume cs:code,ds:data,ss:stack
data segment
	db 128 dup(0)
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			mov ax,0b800h
			mov es,ax
			mov di,160*10+30*2

			mov ax,40h
			mov ds,ax
            mov si,17h

show_status:
            mov al,ds:[si]
			
			push ax
            push dx
            push di
			
            mov cx,8
s:          mov dx,0
            shl al,1
            adc dl,30h
            mov es:[di],dl
            add di,2
            loop s
            pop di
            pop dx
            pop ax
			jmp show_status
            mov ax,4c00h
            int 21h
code ends
end start