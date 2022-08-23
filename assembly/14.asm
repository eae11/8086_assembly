;在codesg 中填写代码，将datasg中的第一个字符串转化为大写，第二个字符串转化为小写。
assume cs:code,ds:data
data segment
db 'BaSiC'
db 'iNfOrMaTiOn'
data ends

code segment
start:  mov ax,data
        mov ds,ax

        mov bx,0
        mov cx,5

    s:  mov al,[bx]
        and al,11011111b
        mov [bx],al

        mov al,[bx+5]
        or al,00100000b
        inc bx
        loop s
code ends
end start
