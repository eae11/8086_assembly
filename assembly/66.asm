;66.
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

            call cpy_new_int9
            call sav_old_int9
            call set_new_int9

testA:      mov ax,1000h
            jmp testA
            mov ax,4c00h
            int 21h
new_int9:   push ax
            in al,60h
            pushf
            call dword ptr cs:[200h]

            cmp al,1eh+80h
            jne int9Ret
            call set_screen
int9Ret:    pop ax
            iret
;==========================
set_screen: push bx
            push cx
            push dx
            push es

            mov bx,0b800h
            mov es,bx
            mov bx,0
            mov dl,'A'
            mov cx,2000
s:          mov es:[bx],dl
            add bx,2
            loop s

            pop es
            pop dx
            pop cx
            pop bx
            ret

new_int9end:nop

;==========================
set_new_int9:
            mov bx,0
            mov es,bx
            cli
            mov word ptr es:[4*9],204h
            mov word ptr es:[4*9+2],0
            sti
            ret
;==========================
sav_old_int9:
            mov bx,0
            mov es,bx
            push es:[4*9]
            pop es:[200h]
            push es:[4*9+2]
            pop es:[202h]
            ret
;==========================
cpy_new_int9:
            mov bx,cs
            mov ds,bx
            mov si,offset new_int9

            mov bx,0
            mov es,bx
            mov di,204h

            mov cx,offset new_int9end-offset new_int9
            cld
            rep movsb
            ret
code ends
end start