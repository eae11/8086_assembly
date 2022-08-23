;70.将69的功能写在7ch中断表中
assume cs:code,ds:data,ss:stack
data segment
	
data ends
stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128
            call copy_int7ch;复制到0:200h处
            call set_new_int7ch;设置中断向量表
            mov ah,0
            mov al,2

            int 7ch

            mov ax,4c00h
            int 21h
set_new_int7ch:
            mov bx,0
            mov es,bx
            cli
            mov word ptr es:[4*7ch+0],200h
            mov word ptr es:[4*7ch+2],0
            sti
            ret
;===========================
copy_int7ch:mov cx,offset new_int7chend-offset new_int7ch
            mov bx,cs
            mov ds,bx

            mov bx,0
            mov es,bx

            mov si,offset new_int7ch
            mov di,200h
            cld
            rep movsb
            ret
;================================
new_int7ch: jmp s1
table       dw offset sub1-offset new_int7ch+200h
            dw offset sub2-offset new_int7ch+200h
            dw offset sub3-offset new_int7ch+200h
            dw offset sub4-offset new_int7ch+200h
s1:         
			
            mov bl,ah
            mov bh,0
            add bx,bx
			add bx,offset table-offset new_int7ch+200h
            call word ptr cs:[bx]

            iret
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
new_int7chend:nop
code ends
end start