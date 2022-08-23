;59.用dos提供的程序在屏幕的5行12列显示字符串“Welcome to masm!”。
assume cs:code
data segment
    db 'Welcome to masm!','$'
data ends
code segment
start:      mov ah,2;置光标
            mov bh,0;参数页
            mov dh,5;参数行号
            mov dl,12;参数列号
            int 10h;bios提供的中断程序里面有很多子程序ah就是参数选择不同子程序

            mov ax,data
            mov ds,ax
            mov dx,0
            mov ah,9;参数调用21h中9号子程序
            int 21h

            mov ax,4c00h
            int 21h

code ends
end start