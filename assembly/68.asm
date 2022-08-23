;68.计算sin(x)，x∈{0°，30°，60°，90°，120°，150°，180°},
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

            mov ax,60
			call showsin

            mov ax,4c00h
            int 21h
showsin:    jmp  show
table       dw ag0,ag30,ag60,ag90,ag120,ag150,ag180
            ag0 db '0',0
            ag30 db '0.5',0
            ag60 db '0.866',0
            ag90 db '1',0
            ag120 db '0.866',0
            ag150 db '0.5',0
            ag180 db '0',0
show:       push bx
            push es
            push si
            mov bx,0b800h
            mov es,bx
;以下用角度值/30 作为相对于table的偏移，取得对应的字符串的偏移地址，放在bx中
            mov ah,0;ax用来存放参数 0~180只可能在al把ah清空

            mov bl,30
            div bl
            mov bl,al;al存商

            mov bh,0
            add bx,bx;dw类型的所以要乘以2
            mov bx,table[bx];bx存放字符串的偏移地址
;显示sin(x)对应的字符串
            mov si,160*12+40*2

shows:      mov ah,cs:[bx]
            cmp ah,0
            je showret
            mov es:[si],ah
            inc bx
            add si,2
            jmp shows
showret:    pop si
            pop es
            pop bx
            ret

code ends
end start