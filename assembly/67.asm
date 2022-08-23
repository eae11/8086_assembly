;67.编写子程序以十六进制的形式在屏幕中间显示给定的字节型数据。
assume cs:code,ds:data,ss:stack
data segment
array	db 88h,0cch,0fh,0a1h,3fh
data ends
stack segment
	db 128 dup(0)
stack ends
code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

            mov bx,data
            mov ds,bx

            mov bx,0b800h
            mov es,bx

            mov di,160*10+30*2
            mov si,offset array

            mov cx,5
            mov ax,0
s:          mov al,ds:[si]
			call showbyte
			inc si
			add di,4
            loop s

            mov ax,4c00h
            int 21h
            
showbyte:   jmp short show
            table db '0123456789ABCDEF' ;字符表
    show:   push bx
            push es

            mov ah,al ;al用于要存放的数据
            shr ah,1
            shr ah,1
            shr ah,1
            shr ah,1;ah放高4位
            and al,00001111b;al放低四位



            mov bl,ah;高
            mov bh,0
            mov ah,cs:table[bx];bx是几就对应table中的几也就是让0~15对0~F建立一一对应的映射


            mov es:[di],ah
            mov byte ptr es:[di+1],00000100b

            mov bl,al;低
            mov bh,0
            mov ah,cs:table[bx]

            mov es:[di+2],ah
            mov byte ptr es:[di+3],00000100b

            pop es
            pop bx

            ret
code ends
end start