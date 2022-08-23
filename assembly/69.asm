;69.实现一个子程序setscreen，为显示输出提供如下功能。
;1.清屏2.设置前景色3.设置背景色4.向上滚动一行
;(1) 用ah寄存器传递功能号:0表示清屏，1表示设置前景色，2表示设置背景色，3表示向上滚动一行;
;(2)对于1、2号功能，用al传送颜色值，(al)∈ {0,1,2,3,4,5,6,7}。
assume cs:code,ds:data,ss:stack
data segment
	dw  0,0,0,0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

            mov ah,4
            mov al,2

            call setscreen

            mov ax,4c00h
            int 21h
setscreen:	jmp set
			table dw sub1,sub2,sub3,sub4
		set:push bx
			cmp ah,3
			ja sret
			mov bl,ah
			mov bh,0
			add bx,bx
			call word ptr table[bx]
	sret:	pop bx
			ret
;=========================================
sub1:       push bx
            push cx
            push es
            mov bx,0b800h
            mov es,bx
            mov bx,0
            mov cx,2000
sub1s:      mov byte ptr es:[bx],' '
            add bx,2
            loop sub1s
            pop es
            pop cx
            pop bx
            ret
;=========================================
sub2:       push bx
            push cx
            push es
            mov bx,0b800h
            mov es,bx
            mov bx,1
            mov cx,2000
sub2s:      and byte ptr es:[bx],11111000b;除了前景原来该是什么就是什么
            or es:[bx],al;用al中存放的颜色(前景)去改
            add bx,2
            loop sub2s
            pop es
            pop cx
            pop bx
            ret
;=========================================
sub3:       push bx
            push cx
            push es
            mov cl,4
            shl al,cl
            mov bx,0b800h
            mov es,bx
            mov bx,1
            mov cx,2000
sub3s:      and byte ptr es:[bx],10001111b;除了背景原来该是什么就是什么
            or es:[bx],al;用al中存放的颜色(背景)去改
            add bx,2
            loop sub3s
            pop es
            pop cx
            pop bx
            ret
;=========================================
sub4:       push cx
            push si
            push di
            push es
            push ds

            mov si,0b800h
            mov es,si
            mov ds,si
            mov si,160;si对应ds
            mov di,0
			mov cx,24*80;复制24行
			cld
			
			rep movsw
			
			mov si,160*24
			mov cx,80
sub4s:		mov es:[si],0700h
			add si,2
			loop sub4s
            

            pop ds
            pop es
            pop di
            pop si
            pop cx
            ret
code ends
end start