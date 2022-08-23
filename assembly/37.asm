assume cs:code
data segment
;采用32位除法
	dw 1234
data ends

stack segment
	db 128 dup(0)
stack ends
;要显示1234  1234除以10余数分别是4 3 2 1
code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

            mov bx,data
            mov ds,bx
            mov si,0

            mov bx,0b800h
            mov es,bx
            mov di,160*10;十行
            add di,40*2;四十列

            mov ax,ds:[si];32除法 被除数ax低位 dx高位
            mov dx,0
            call short_div

			mov ax,4c00h
			int 21h
short_div:  mov cx,10
            div cx ;商ax 余数dx
            add dl,30h;+48  ascii 0->48  1->49
            mov es:[di+0],dl
            mov byte ptr es:[di+1],00000100b
            mov cx,ax;判断商是否为0 商为0就结束
            jcxz shortDivRet
            mov dx,0;清空余数 如果不清空余数会有问题 比如1234除以10余数4  ax123 dx4 下次再除的时候就是dx4高位和ax低位表示的数了就不是123了
            sub di,2;余数是4 3 2 1所以倒着来,减di
            jmp short_div

shortDivRet:ret

code ends
end start