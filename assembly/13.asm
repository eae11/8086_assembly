assume cs:code
a segment
 dw 1,2,3,4,5,6,7,8,9,0ah,0bh,0ch,0dh,0eh,0fh,0ffh
a ends
b segment
 dw 0,0,0,0,0,0,0,0
b ends
code segment
start:           mov ax,a
            mov ds,ax;ds存放a的段地址

            mov ax,b
            mov es,ax;es存放b的段地址

            mov bx,0
            mov cx,8

  s:        push [bx]
            add bx,2   ;注意这里是add bx,2不是inc bx
            loop s

            mov bx,0
			mov cx,8
    s1:     pop es:[bx]
            add bx,2  ;注意这里是add bx,2不是inc bx
            loop s1

		    mov ax,4c00h
		    int 21h
code ends
end start