assume cs:code,ds:data
data segment
    dw 1,2,3,4,5,0,0,0
    dw 0,0,0,0,0,0,0,0
data ends
code segment
start:	
		mov dx,1
		mov ax,86a1h
		mov bx,100
		div bx
code ends
end start