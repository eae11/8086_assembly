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

			push cs
			pop ds

			mov ax,0
			mov es,ax

			mov si,offset int9
			mov di,204h
			mov cx,offset int9end-offset int9
			cld
			rep movsb;把int9复制到0:[204h]中

			push es:[9*4]
			pop es:[200h]
			push es:[9*4+2]
			pop es:[202h];把bios的int9先保存到0:[200h]中

			cli;在设置中断向量表 int9的过程中不响应外中断
			mov word ptr es:[9*4],204h
			mov word ptr es:[9*4+2],0
			sti


            mov ax,4c00h
            int 21h
int9:       push ax
            push bx
            push cx
            push es

            in al,60h
            pushf
            call dword ptr cs:[200h];调用bios int9

            cmp al,3bh;f1的扫描码3bh
            jne int9ret

            mov ax,0b800h
            mov es,ax
            mov bx,1
            mov cx,2000

        S:  inc byte ptr es:[bx]
            add bx,2
            loop s

int9ret:    pop es
            pop cx
            pop bx
            pop ax
            iret
int9end:    nop
code ends
end start
