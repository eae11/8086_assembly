;printf函数
assume cs:code,ds:data,ss:stack

data segment
string db 'This is Test %c %c is Test %c %d',0
data ends

stack segment stack
	db 128 dup (0)
stack ends

code segment
	start:	mov ax,stack
			mov ss,ax
			mov sp,128
			
			call init_reg
			call clear_screen
			;mov bx,160*10
			;mov word ptr es:[bx],0961h
			;printf(char*,'a','b','z',5);
			mov ax,0
			mov al,5
			push ax
			mov al,'z'
			push ax
			mov al,'b'
			push ax
			mov al,'a'
			push ax
			mov si,offset string
			mov ax,si
			push ax
			
			mov bx,160*10+20*2
			call my_printf
			
			mov ax,4c00h
			int 21h
my_printf:	push bp
			mov bp,sp
			
			mov di,0
			
printf:		mov al,ds:[si]
			cmp al,0
			je printfRet;如果是0就结束
			cmp al,'%';如果遇到%
			jne printfCol
			cmp byte ptr ds:[si+1],'c'
			je showChar
			cmp byte ptr ds:[si+1],'d'
			je showNumber
			
showNumber:	mov dl,ss:[bp+6+di]
			add dl,30h
			mov es:[bx],dl
			add bx,2
			add di,2
			add si,2
			jmp printf
			
showChar:	mov dl,ss:[bp+6+di] ;栈情况bp,ip,char*,a,b,z
			mov es:[bx],dl
			add bx,2
			add di,2
			add si,2
			jmp printf
			
printfCol:	mov es:[bx],al
			add bx,2
			inc si
			jmp printf
			
			
			
printfRet:
			mov sp,bp
			pop bp
			ret
clear_screen:
			mov bx,0
			mov cx,2000
clearScreen:mov word ptr es:[bx],0700h;数据0就是null,07背景黑色,字体白色
			add bx,2
			loop clearScreen
			ret
init_reg:
			mov bx,0b800h
			mov es,bx
			mov bx,data
			mov ds,bx
			ret
code ends
end start