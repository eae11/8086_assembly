assume cs:code
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

			mov ax,data
			mov ds,ax
			
			mov ds:[0],2233h
			mov word ptr ds:[2],4455h
			
			jmp dword ptr ds:[0]  ;ip=ds:[0] cs=ds:[2]
			
            mov ax,4c00h
            int 21h
code ends
end start