;若要使程序中的jmp指令执行后，CS:IP指向程序的第一条指令，在 data 段中应该定义哪些数据?
assume cs:code
data segment
	db 0
	dw 0;也可以写成  dw offset start ;ds:[1]
data ends

code segment
    start:  
			mov ax,data
			mov ds,ax
			mov bx,0
			
			jmp word ptr ds:[bx+1]
		

            mov ax,4c00h
            int 21h
code ends
end start