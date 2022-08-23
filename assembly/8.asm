;把mov ax,4c00h之前的指令复制到内存0:200处
assume cs:code
code segment
    mov ax,cs
    mov ds,ax
    mov ax,0020h
    mov es,ax
    mov bx,0
    mov cx,23

s:  mov al,ds:[bx]
    mov es:[bx],al
    inc bx
    loop s

    mov ax,4c00h
    int 21h
code ends
end