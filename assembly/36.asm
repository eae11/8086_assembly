;计算前一组数据的三次方放到后一组数据中
assume cs:code
data segment
	dw 11,22,33,44,55,66,77,88
	dd 0,0,0,0,0,0,0,0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			call init_reg
			call number_cube

number_cube:
            mov si,0
            mov di,16
            mov cx,8
s:          mov bx,ds:[si]
            call get_cube
            mov ds:[di],ax;低位在ax中
            mov ds:[di+2],dx;高位在dx中
            add si,2
            add di,4
            loop s
            ret
            mov ax,4c00h
            int 21h
;====================================
get_cube:   push bx
            mov ax,bx
            mul bx
            mul bx
            pop bx
            ret
;====================================
init_reg:   mov bx,data
            mov ds,bx
            mov bx,data
            mov es,bx
            ret
code ends
end start