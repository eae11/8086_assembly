;向内存0:200~0:23f依次存放数据0~63(3fh)
;20h:0 20h:3f 注意要循环64次
assume cs:code
code segment
    mov bx,0
    mov cx,6
    mov ax,0ffffh
    mov ds,ax;设置好段地址
    mov ax,20h
    mov es,ax;设置好段地址

s:  mov dx,ds:[bx]  ; 还可以这样寄存器空间节省下来了 push dx:[bx]
    mov es:[bx],dx   ;          pop es:[bx]
    add bx,2
    loop s

    mov ax,4c00h
    int 21h
code ends
end