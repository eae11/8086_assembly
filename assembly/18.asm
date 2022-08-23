;用div计算 data 段中第一个数据除以第二个数据后的结果，商存在第三个数据的存储单元中。
assume cs:code,ds:data
data segment
    dd 100001;000186a1h 2个字4个内存单元
    dw 100 ;[4]
    dw 0 ;[6]
data ends
code segment
start:
        mov ax,data
        mov ds,ax

		mov ax,ds:[0] ;常量要加上段地址不然被编译器直接当做数据0000
		mov dx,ds:[2]
		div word ptr ds:[4]
		mov ds:[6],ax
		
		
code ends
end start