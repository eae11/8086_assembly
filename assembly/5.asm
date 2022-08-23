;计算ffff:0~ffff:b单元中的数据的和,结果存储在dx中
assume cs:code
code segment
    mov ax,0ffffh
    mov ds,ax
    mov cx,12;初始化循环计数器
    mov dx,0;初始化累加器
    mov bx,0
s:  mov al,[bx]
    mov ah,0
    add dx,ax
    inc bx
    loop s
    mov ax,4c00h
    int 21h
code ends
end