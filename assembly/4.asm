;计算ffff:0006单元中的数乘以3结果存在dx中
assume cs:code
code segment
    mov ax,0ffffh ;字母开头要加0
    mov ds,ax
	mov bx,6
    mov al,[bx] ;注意要写al,如果写ax则是字
    mov ah,0 ;还要把高位给他清掉
    mov dx,0
    mov cx,3
  s:add dx,ax
    loop s
    mov ax,4c00h
    int 21h
code ends
end