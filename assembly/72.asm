;字符串输入
assume cs:code,ds:data,ss:stack
data segment
STRING	db 128 dup(0) ;0~126,最后一个0用来判断结尾
TOP dw 0
data ends
stack segment
	db 128 dup(0)
stack ends
code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

            mov bx,0b800h
            mov es,bx

            mov bx,data
            mov ds,bx

            call get_String




            mov ax,4c00h
            int 21h
;=====================
get_String: mov si,offset STRING
            mov di,160*10+40*2
            

getString:  mov ah,0
            int 16h

            cmp al,20h;20h以下控制字符
            jb notChar ;如果不是字符
            call char_push
            call show_string
            jmp getString

getStringRet:
            ret
notChar:    cmp ah,0eh;删除键描码
            je backspace
            cmp ah,1ch;回车扫描码
            je getStringRet
            jmp getString
;===========================
backspace:	call char_pop
			call show_string
			jmp getString
;===========================
char_pop:	cmp TOP,0
			je charPopRet
			dec TOP
			mov bx,TOP
			mov byte ptr ds:[si+bx],0			
charPopRet:	ret
;===========================
char_push:  cmp TOP,126
            ja charPushRet
			mov bx,TOP
            mov ds:[si+bx],al
            inc TOP
charPushRet:ret
;=========================
show_string:push dx
            push ds
            push es
            push si
            push di
showString: mov dl,ds:[si]
            cmp dl,0
            je showStringRet
            mov es:[di],dl
            add di,2
            inc si
            jmp showString           
showStringRet:
			mov byte ptr es:[di],0
			pop di
            pop si
            pop es
            pop ds
            pop dx
            ret
code ends
end start