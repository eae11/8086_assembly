;49.统计data段中数值小于8的字节的个数，用ax保存统计结果。
assume cs:code,ds:data,ss:stack
data segment
	db 8,11,8,1,8,5,63,38
data ends

stack segment
	db 128 dup(0)
stack ends

code segment
start:      mov ax,data
            mov ds,ax
            mov bx,0
            mov ax,0;初始化ax
            mov cx,8
    s:      cmp byte ptr ds:[bx],8
            jnb next;不低于8则转移
            inc ax
    next:   inc bx
            loop s
            mov ax,4c00h
            int 21h
code ends
end start