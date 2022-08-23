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

			mov dh,00000001b
			mov dl,00000010b
			shl dh,1    ;要得到 0001 0010
			shl dh,1
			shl dh,1
			shl dh,1;dh 0001 0000
			or dh,dl
			
            mov ax,4c00h
            int 21h
code ends
end start