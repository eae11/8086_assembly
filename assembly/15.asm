;将datasg段中每个单词的头一个字母改为大写字母。
assume cs:code,ds:data
data segment
db '1. file!        '
db '2. edit!        '
db '3. search!      '
db '4. view!        '
db '5. options!     '
db '6. help!        '
data ends

code segment
start:  mov ax,data
        mov ds,ax

        mov si,0;用si作为变量每次加16
        mov cx,6

    s:  mov al,[si+3]
        and al,11011111b
        mov [si+3],al
        add si,16
        loop s
        
        mov ax,4c00h
        int 21h
code ends
end start