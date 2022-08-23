;若要使程序中的 jmp 指令执行后，CS:IP指向程序的第一条指令，在data段中应该定义哪些数据?
assume cs:code
data segment
	dd 12345678H
data ends

code segment
    start:  mov ax,data
            mov ds,ax
            mov bx,0

			mov word ptr [bx],offset start ;也可以直接写mov [bx],0
			mov [bx+2],cs
			
			jmp dword ptr ds:[0]
            mov ax,4c00h
            int 21h
code ends
end start