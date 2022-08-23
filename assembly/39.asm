;将word型数据转变为表示十进制数的字符串，字符串以0为结尾符。
assume cs:code,ds:data,ss:stack
data segment
	dw 1234
data ends
String  segment
	db '0000000000',0
String ends
stack segment
	db 128 dup(0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			mov ax,data
			mov ds,ax
			mov si,0

			mov ax,String
			mov es,ax
			mov di,10

            mov ax,ds:[si]
            mov dx,0
			call short_div

            mov ax,String
            mov ds,ax
            mov si,di ;di现在指到1的位置

            mov ax,0b800h
            mov es,ax
            mov di,160*10
            add di,40*2

            call show_string


            mov ax,4c00h
            int 21h
show_string:push cx
            push ds
            push es
            push si
            push di

            mov cx,0

showString:  mov cl,ds:[si]
            jcxz showStringRet
            mov es:[di],cl
            mov byte ptr es:[di+1],00000100b
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
short_div:  mov cx,10
            div cx
            add dl,30h
            sub di,1
            mov es:[di],dl
            mov cx,ax
            jcxz shortDivRet
            mov dx,0
            jmp short_div

shortDivRet:ret
code ends
end start