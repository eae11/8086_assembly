;将a段和b段的数据依次相加,将结果存到c段中
assume cs:code
a segment
 db 1,2,3,4,5,6,7,8
a ends
b segment
 db 1,2,3,4,5,6,7,8
b ends
c segment
 db 0,0,0,0,0,0,0,0
c ends
code segment
    start:mov bx,0
          mov cx,8

          mov ax,c
          mov es,ax;c的段地址

   s:     mov dx,0 ;清空dx

          mov ax,a
          mov ds,ax
          mov dl,[bx] ;把a中的数据存到dx中

          mov ax,b
          mov ds,ax
          add dl,[bx] ;把b中数据相加到dx中

          mov es:[bx],dl
		  inc bx
          loop s
          
		  mov ax,4c00h
		  int 21h
code ends
end start