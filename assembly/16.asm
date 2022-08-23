;将data段中每个单词的前4个字母改为大写字母。
assume cs:code,ds:data,ss:stack
data segment
db '1. display      ';16个字节
db '2. brows        '
db '3. replace      '
db '4. modify       '
data ends

stack segment
dw 0,0,0,0,0,0,0,0;8个字
stack ends

code segment
start:  mov ax,data
        mov ds,ax

        mov ax,stack;初始化栈
        mov ss,ax
        mov sp,16

        mov si,0
        mov cx,4;外层循环4次


    s0: push cx;将外层循环次数保存到栈中
        mov bx,3
        mov cx,4;内层循环

    s:  mov al,[bx+si]
        and al,11011111b
        mov [bx+si],al
        inc bx
        loop s

        add si,16
        pop cx;从栈中将外层循环的值取出
        loop s0

        mov ax,4c00h
        int 21h
code ends
end start