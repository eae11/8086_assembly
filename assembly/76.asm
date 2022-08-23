76.
;
assume cs:code,ds:data,ss:stack
data segment
number	dw 65
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			call init_reg
            call clear_screen

            mov ax,number;相当于 mov ax,ds:[0]
            mov di,160*10+40*2
            push ax
            call show_number


            mov ax,4c00h
            int 21h

show_number:push bp
            mov bp,sp

            cmp ax,0
            jne showNumber
            mov sp,bp
            pop bp
            ret
showNumber: mov dx,0
            mov bx,10
            div bx

            push ax;商
            call show_number

            mov ax,ss:[bp+4]
			
            mov dx,0

            mov bx,10
            div bx

            add dl,30h
            mov es:[di],dl
            add di,2

            mov sp,bp
            pop bp
            ret


clear_screen:
			mov bx,0
			mov cx,2000
clearScreen:mov word ptr es:[bx],0700h;数据0就是null,07背景黑色,字体白色
			add bx,2
			loop clearScreen
			ret
init_reg:
			mov bx,0b800h
			mov es,bx
			mov bx,data
			mov ds,bx
			ret
code ends
end start