;解决除法溢出问题
assume cs:code,ds:data,ss:stack
data segment
	dd 1000000;一百万
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			mov ax,data
			mov ds,ax

			mov bx,0
			mov ax,ds:[bx+0];低十六位
			mov dx,ds:[bx+2];高十六位

			mov cx,10
            push ax
            mov bp,sp
			call long_div
;参数ax=32位数据的低16位 dx为高16位  cx位除数
;返回结果不再是dx保存余数,ax保存商了,因为溢出了  而是  dx保存高16位商,ax保存低16位商,cx保存余数
;公式 X/N=int(H/N)*65536+[rem(H/N)*65536+L]/N
            mov ax,4c00h
            int 21h
long_div:   mov ax,dx;现在在高十六位上进行除法
            mov dx,0
            div cx   ;ax=int(H/N)ax要放到dx寄存器中所以先存起来  dx=rem(H/N)
            push ax

            mov ax,ss:[bp+0];把之前ax中的低十六位(也就是L)拿过来,现在dx=rem(H/N)又因为dx本身表示高16位所以(dx)=rem(H/N)*65536
            div cx;现在ax本身就存着结果的低16位
            mov cx,dx;余数放cx里
            pop dx  ; 再把之前放在ax中的高16位商取出来放到dx中
            ret
code ends
end start