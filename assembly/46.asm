;46.编写一个子程序，对两个128位数据进行相加。
assume cs:code,ds:data,ss:stack
data segment
	dw 2222h,3333h,4444h,5555h,6666h,7777h,8888h,9999h
	dw 0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,0ffffh,
	dw 8 dup (0)
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			call add_number_128

            mov ax,4c00h
            int 21h
add_number_128:
            push ax
            push cx
            push si
            push di
            mov bx,data
            mov ds,bx

            mov si,0
            mov di,16
            mov cx,8
            sub ax,ax;先将CF标志设为0
addNumber:
            mov ax,ds:[si]
            adc ax,ds:[di]
            ;add si,2这里不能写add 因为可能会影响CF标志
            ;add di,2
            inc si
            inc si
            inc di
            inc di
            loop addNumber
            pop di
            pop si
            pop cx
            pop ax
            ret
code ends
end start