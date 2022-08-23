assume cs:code
data segment
	db 'welcome to masm!'
	db 82h,24h,71h
data ends
stack segment
db 128 dup(0)
stack ends
code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

            call init_reg
            call show_masm

            mov ax,4c00h
            int 21h
;========================================================
show_masm:  mov bp,0+160*10+2*2;第十行偏移地址直接这样写,吃饱了撑自己去算
            mov bx,0;数据指针
            mov si,0+16;颜色偏移地址
            mov cx,3

s1:         push bp
            push bx
            push si
            push cx

            mov cx,16

            mov ah,ds:[si] ;颜色高位

s:          mov al,ds:[bx] ;数据低位
            mov es:[bp],ax
            inc bx
            add bp,2
            loop s

            pop cx
            pop si
            pop bx
            pop bp
            add bp,160;下一行
            inc si;颜色换下一个
            loop s1
            ret
;=============================================
init_reg:   mov ax,data
            mov ds,ax

            mov ax,0b800h;段地址
            mov es,ax
            ret
code ends
end start