;52.编写一个子程序，将包含任意字符，以0结尾的字符串中的小写字母转变成大写字母
assume cs:code,ds:data,ss:stack
data segment
	db "FAGAGAf afa fafa klaj dlka.",0
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
start:      mov ax,data
            mov ds,ax
            mov si,0
            call toUpperCase
            call show_string
            mov ax,4c00h
            int 21h
show_string:mov ax,data
            mov ds,ax

            mov ax,0b800h
            mov es,ax

            mov di,160*8+10*2
            mov si,0

            mov cx,0
showString:
            mov cl,ds:[si]
            jcxz showStringRet
            mov es:[di],cl
            mov byte ptr es:[di+1],00000100b
			inc si
            add di,2
            jmp showString
showStringRet:
            ret
toUpperCase:push ax
            push cx
            push si
            push ds
            mov cx,0
s:          mov al,ds:[si]
            mov cl,al
            jcxz toUpperCaseRet
            cmp al,'a'
            jb s0
            cmp al,'z'
            ja s0
            sub al,32
            mov ds:[si],al
     s0:    inc si
            jmp s
toUpperCaseRet:
            pop ds
            pop si
            pop cx
            pop ax
           ret
code ends
end start