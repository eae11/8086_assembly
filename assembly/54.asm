;54编写、安装中断7ch的中断例程。
;功能:求一word型数据的平方。参数: (ax)要计算的数据。
;返回值: dx、ax 中存放结果的高16位和低16位。
;应用举例:求2*3456^2。
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


            mov ax,cs
            mov ds,ax
            mov si,offset do7ch

            mov ax,0
            mov es,ax
            mov di,200h

            mov cx,offset do7chend-offset do7ch
            cld
            rep movsb;把do7ch这段程序复制到0:200h处

            mov ax,0
            mov es,ax
            mov word ptr es:[4*7ch],200h
            mov word ptr es:[4*7ch+2],0;设置7ch处中断向量表

            mov ax,3456
            int 7ch
            add ax,ax
            adc dx,dx

            mov ax,4c00h
            int 21h
do7ch:      mul ax
            iret
do7chend:   nop
code ends
end start
