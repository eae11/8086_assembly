assume cs:code,ds:data,ss:stack
data segment
		db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
		db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
		db	'1993','1994','1995'		;以上是表示21年的21个字符串  year   84个字节    起始地址[0]

		dd	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514  ; 84个字节   起始地址[84] [54h]
		dd	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000		;以上是表示21年公司总收入的21个dword数据	sum

		dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226 ;42个字节     起始地址[168] [a8h]
		dw	11542,14430,15257,17800
data ends

table segment   ;21*16个字节     起始地址[210] [D2h]
		db	21 dup ('year summ ne ?? ')
table ends

stack segment stack
	db	128 dup (0)
stack ends

code segment
start:	mov ax,stack
        mov ss,ax
        mov sp,128;找到栈空间

        mov ax,data
        mov ds,ax  ;data段

        mov ax,table
        mov es,ax   ;table段

        mov si,0 ;data段年份偏移地址
        mov bx,21*4 ;data段收入偏移地址
        mov di,21*4+21*4 ;data段雇员数偏移地址
        mov bp,0 ;table段偏移地址

        mov cx,21
				
s:		push ds:[si+0]
        pop es:[bp+0]  ;放到table段中
        push ds:[si+2]
        pop es:[bp+2] ;放到table段中

        mov ax,ds:[bx+0]  ;被除数32位  低位放在ax中,高位放在dx中  除数16位 商在ax中 余数在dx中  被除数16位 放在ax中  除数8位  商在al中 余数在ah中
        mov dx,ds:[bx+2]
        mov es:[bp+5],ax;低位  放到table段中
        mov es:[bp+7],dx;高位  放到table段中

        push ds:[di+0]
        pop es:[bp+0ah]  ;放到table段中

        div word ptr ds:[di+0]  ;div 除以寄存器  或内存单元  这里直接用内存单元

        mov es:[bp+0dh],ax  ;把ax商存在 table段中
		
		add si,4
		add bx,4
		add di,2
		add bp,16
		loop s
		
        mov ax,4c00h
        int 21h
code ends
end start