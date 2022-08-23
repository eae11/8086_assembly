assume cs:code
data segment
	db 'dadadaklgls',0
	db 'djajdajkda',0
	db 'aaaaahhh',0
	db 'lplpdalda',0
	dw 0,12,23,32;每行数据的首地址
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

            call init_reg
            call show_option


            mov ax,4c00h
            int 21h
;====================================
show_option:
            mov bx,2ah;第五行数据首地址
            mov di,160*10+30*2;第十行 三十列
            mov cx,4
showOption: mov si,ds:[bx+0]
            call show_string
            add di,160;换行
            add bx,2;换行
            loop showOption
            ret
;====================================
show_string:push cx;防止和外面的寄存器冲突把子程序里面使用到的寄存器全部push
            push ds
            push es
            push si
            push di

            mov ch,0
showString: mov cl,ds:[si]
            jcxz showStringRet
            mov es:[di],cl
            add di,2
            inc si
            jmp showString
showStringRet:
            pop di
            pop si
            pop es
            pop ds
            pop cx
            ret
;====================================
init_reg:
            mov bx,0b800h
            mov es,bx

            mov bx,data
            mov ds,bx
            ret
code ends
end start