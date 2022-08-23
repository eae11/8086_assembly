;56.用7ch中断程序完成loop指令的功能
;应用举例在屏幕中显示80个"!"
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

			mov ax,0b800h
			mov es,ax
			mov di,160*12

			mov bx,offset s-offset se
			mov cx,80
        s:  mov byte ptr es:[di],'!'
            add di,2
            int 7ch  ;如果cx不等于0,跳到s处  用int 7ch模拟loop的功能
        se: nop


            mov ax,4c00h
            int 21h
do7ch:      push bp
            mov bp,sp
            dec cx
            jcxz return
            add [bp+2],bx;bp+2里面就是ip加上偏移位移就是s的标号iret弹出的时候就ip就指到了s处
return:     pop bp
            iret
do7chend:   nop
code ends
end start