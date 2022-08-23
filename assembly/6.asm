;将内存ffff:0~ffff:b单元中的数据复制到0:200~0:20b单元中
assume cs:code
code segment
    mov bx,0
    mov cx,12
    mov ax,0ffffh
    mov ds,ax;设置好段地址
    mov ax,20h
    mov es,ax;设置好段地址
  s:mov dl,ds:[bx]
    mov es:[bx],dl
    inc bx
    loop s
    mov ax,4c00h
    int 21h
code ends
end