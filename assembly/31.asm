;编程，将data 段中的字符串转化为大写。
assume cs:code
data segment
db 'conversation'
data ends
code segment
start:  mov ax,data
        mov ds,ax
        mov si,0

        mov cx,12
        call capital
        mov ax,4c00h
        int 21h
capital:and word ptr ds:[si],11011111b;将ds:si所指单元中的字母转化为大写
        inc si
        loop capital
        ret
code ends
end start