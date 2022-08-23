;利用loop指令在内存2000H段中查找第一个值为0的字节，找到后，将它的偏移地址存储在dx 中。
assume cs:code
code segment
    start:  mov ax,2000h
            mov ds,ax
            mov bx,0

      s:    mov cl,ds:[bx]
            mov ch,0
            inc cx;如果找到0,loop会将cx-1,cx从0变成ffff,所以要+1
            inc bx
            loop s

        ok: dec bx;-1
            mov dx,bx

            mov ax,4c00h
            int 21h
code ends
end start