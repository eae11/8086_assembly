;显示字符串是现实工作中经常要用到的功能，应该编写一个通用的子程序来实现这个功能。我们应该提供灵活的调用接口，使调用者可以决定显示的位置(行、列)、内容和颜色
assume cs:code,ds:data,ss:stack
data segment
    db "welcome to masm!"
data ends
stack segment
    db 128 dup(0)
stack ends
code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128
            call init_reg
            mov di,0;显存指针

            mov dh,8;参数行号

            call get_row
            add di,ax;  ax中为160*参数 8位乘法 一个默认在al 结果放ax中,16位乘法 一个默认在ax 结果高位在dx,低位在ax

            mov dl,3;参数列号
            call get_col
            add di,ax

            mov cl,2;颜色
            mov dl,cl ;dl已经不使用了

            mov si,0
            call show_string



            mov ax,4c00h
            int 21h
show_string:mov cx,0
showString: mov cl,ds:[si]
            jcxz showStringRet
            mov es:[di],cl
            mov byte ptr es:[di+1],dl
            add di,2
            inc si
            jmp showString
showStringRet:
            ret
get_col:    mov al,2
            mul dl
            ret  ;2*3
get_row:    mov al,160
            mul dh; 160*8
            ret
init_reg:   mov ax,data
            mov ds,ax

            mov ax,0b800h
            mov es,ax
            ret
code ends
end start