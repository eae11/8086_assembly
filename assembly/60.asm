;60.
;编写并安装int 7ch 中断例程，功能为显示一个用О结束的字符串，中断例程安装在0:200处。
;参数: (dh)=行号，(dl)=列号，(cl)=颜色，ds:si指向字符串首地址。
assume cs:code
data segment
    db 'welcome to masm!',0
data ends
stack segment
	db 128 dup(0)
stack ends
code segment
start:      ;先安装7ch到内存0:200处
            mov ax,stack
            mov ss,ax
            mov sp,128

            mov ax,cs
            mov ds,ax
            mov si,offset do7ch

            mov ax,0
            mov es,ax
            mov di,200h

            mov cx,offset do7chend-offset do7ch
            cld
            rep movsb
            ;设置中断向量表
            mov ax,0
            mov es,ax
            mov word ptr es:[4*7ch],200h
            mov word ptr es:[4*7ch+2],0

            mov cx,0;先把cx清空,避免上面cx影响到下面cl
            mov dh,10;参数行
            mov dl,10;参数列
            mov cl,2;参数颜色
            mov ax,data
            mov ds,ax
            mov si,0
            int 7ch

            mov ax,4c00h
            int 21h

do7ch:      mov ax,0b800h
            mov es,ax

			
            mov al,160;8位乘法一个在al中,结果在ax中
            mul dh
            mov di,ax

            mov al,2
            mul dl
            add di,ax
			
s:          mov bl,ds:[si]
            cmp bl,0
            je s1
            mov es:[di],bl
            mov byte ptr es:[di+1],cl
            add di,2
            inc si
            jmp s
s1:         iret
do7chend:   nop
code ends
end start