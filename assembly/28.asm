;补全程序,实习从内存1000:0000处开始执行指令
assume cs:code
stack segment
    db 128 dup(0)
stack ends
code segment
start:  mov ax,stack
        mov ss,ax
        mov sp,128
        mov ax,1000h
        push ax
        mov ax,0h
        push ax
        retf
        mov ax,4c00h
        int 21h
code ends
end start