;设计一个子程序，功能:将一个全是字母，以О结尾的字符串，转化为大写
capital:    mov cl,[si]
            mov ch,0
            jcxz ok
            and byte ptr [si],11011111b
            inc si
            jmp short capital
        ok: ret
;
assume cs:code
data segment
db 'word',0
db 'unix',0
db 'wind',0
db 'good',0
data ends
code segment
start:  mov ax,data
        mov ds,ax
        mov bx,0
        mov cx,4

    s:  mov si,bx

capital:mov cl,[si]
        mov ch,0
        jcxz ok
        and byte ptr [si],11011111b
        inc si
        jmp short capital
        ok: ret
code ends
end start