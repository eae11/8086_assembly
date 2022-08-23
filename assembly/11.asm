;把数据,代码栈放入不同的段
assume cs:code,ds:data,ss:stack
data segment
     dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
data ends

stack segment
    dw 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0 ;16个字单元
stack ends

code segment
start: mov ax,stack
       mov ss,ax
       mov sp,32;栈空间

       mov ax,data
       mov ds,ax;数据段
       mov bx,0
       mov cx,8
	   
     s:push [bx]
       add bx,2
       loop s
	   
       mov bx,0
       mov cx,8
	   
     s0:pop [bx]
        add bx,2
        loop s0
		
        mov ax,4c00h
        int 21h
code ends
end start