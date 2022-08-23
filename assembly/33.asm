;显示字符串
assume cs:code
data segment
    db 'Welcome to masm!',0
data ends
stack segment
db 128 dup(0)
stack ends
code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,128;初始化栈

        mov ax,data
        mov ds,ax
        mov si,0

        mov ax,0b800h
        mov es,ax
        mov di,160*3
        add di,3*2

        call show_string

        mov ax,4c00h
        int 21h
show_string:push cx
            push si
            push di
            push es
            push ds

            mov cx,0
showString: mov cl,ds:[si]
            jcxz showStringRet
            mov es:[di],cl
            mov byte ptr es:[di+1],00000100b
            inc si
            add di,2
            jmp showString
showStringRet:
            pop ds
            pop es
            pop di
            pop si
            pop cx
            ret
code ends
end start