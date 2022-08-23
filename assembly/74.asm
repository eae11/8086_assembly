;安装一个新的int 7ch中断例程，实现通过逻辑扇区号对软盘进行读写。
;参数说明:
;(1)用ah寄存器传递功能号:0表示读，1表示写
;(2)用dx寄存器传递要读写的扇区的逻辑扇区号
;(3)用es:bx指向存储读出数据或写入数据的内存区。

assume cs:code,ds:data,ss:stack
data segment
	db 128 dup(0)
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			call cpy_new_int7ch
			call set_new_int7ch
			
			mov ah,1
			mov dx,1439
			int 7ch
			
		
            mov ax,4c00h
            int 21h
new_int7ch:	push ax
			push bx
			push cx
			push dx

			push ax
			
			mov ax,dx
			mov dx,0
			mov bx,1440
			div bx
			
			push ax	;保存面号
			
			mov ax,dx;dx中是余数
			mov dx,0
			mov bl,18
			
			div bl ;16除法 ah余数,al商
			
			;al磁道号, ah扇区
			
			inc ah ;扇区从1开始计算
			
			;bios提供的int13对应的参数
			;ch=磁道号	
			;cl=扇区号
			;dh=面号		
			;dl=驱动器号		
			;ah=int13h的功能号3表示写2表示读
			;al=写入的扇区数
			pop dx ;把面号放到dx中
			mov cl,8
			shl dx,cl;左移8位 让dh=面号
			
			
			mov cl,ah  
			mov ch,al
			
			pop ax;
			add ah,2;  
			
			int 13h
			
			pop dx
			pop cx
			pop bx
			pop ax
			iret
new_int7ch_end:nop
;========================
set_new_int7ch:
			mov bx,0
			mov es,bx
			cli
			mov word ptr es:[7ch*4],7e00h
			mov word ptr es:[7ch*4+2],0
			sti
			ret
;========================
cpy_new_int7ch:
			mov bx,cs
			mov ds,bx
			mov si,offset new_int7ch
			mov bx,0
			mov es,bx
			mov di,7e00h
			
			mov cx,offset new_int7ch_end-new_int7ch
			cld
			rep movsb
			ret
code ends
end start