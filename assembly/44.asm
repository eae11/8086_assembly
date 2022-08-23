;44.
assume cs:code,ds:data,ss:stack
data segment


		db	'1975','1976','1977','1978','1979','1980','1981','1982','1983'
		db	'1984','1985','1986','1987','1988','1989','1990','1991','1992'
		db	'1993','1994','1995'
		;以上是表示21年的21个字符串 year


		dd	16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
		dd	345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000
		;以上是表示21年公司总收入的21个dword数据	sum

		dw	3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5635,8226
		dw	11542,14430,15257,17800



data ends

stack segment stack
	db	128 dup (0)
stack ends

code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			call init_reg
			call clear_screen
            call output_table
            mov ax,4c00h
            int 21h
output_table:
            mov si,0
            mov di,160*3
            mov bx,21*4*2
            mov cx,21
outputTable:call show_year
            call show_income
            call show_employee
            call show_average
            add di,160
            add si,4
            add bx,2
            loop outputTable
            ret
show_average:
             push ax
             push bx
             push cx
             push dx
             push ds
             push es
             push si
             push di
             push bp
            mov ax,ds:[si+21*4]
            mov dx,ds:[si+21*4+2]
            mov cx,ds:[bx];除数
            push ax
            mov bp,sp
            call long_div
            add sp,2
            add di,40*2
            call isShortDiv
            pop bp
            pop di
            pop si
            pop es
            pop ds
            pop dx
            pop cx
            pop bx
            pop ax
            ret
show_employee:
            push ax
            push bx
            push cx
            push dx
            push ds
            push es
            push si
            push di
            push bp

            mov ax,ds:[bx]
            mov dx,0
            add di,30*2
            call isShortDiv
            pop bp
            pop di
            pop si
            pop es
            pop ds
            pop dx
            pop cx
            pop bx
            pop ax
            ret
show_income:push ax
            push bx
            push cx
            push dx
            push ds
            push es
            push si
            push di
            push bp
            mov ax,ds:[si+21*4+0]
            mov dx,ds:[si+21*4+2]
            add di,20*2
            call isShortDiv
            pop bp
            pop di
            pop si
            pop es
            pop ds
            pop dx
            pop cx
            pop bx
            pop ax
            ret
isShortDiv: mov cx,dx
            jcxz shortDiv
            mov cx,10
            push ax
            mov bp,sp
            call long_div
            add sp,2
            add cl,30h
            mov es:[di],cl
            mov byte ptr es:[di+1],00000100b
            sub di,2
            jmp isShortDiv
shortDivRet:ret

long_div:   mov ax,dx
            mov dx,0
            div cx
            push ax
            mov ax,ss:[bp+0]
            div cx
            mov cx,dx
            pop dx
            ret

shortDiv:   mov cx,10
            div cx
            add dl,30h
            mov es:[di],dl
            mov byte ptr es:[di+1],00000100b
            mov cx,ax
            jcxz shortDivRet
            sub di,2
            mov dx,0
            jmp shortDiv
show_year:  push ax
            push bx
            push cx
            push ds
            push es
            push si
            push di
            mov bx,0b800h
            mov es,bx
            mov cx,4
            add di,3*2
showYear:   mov al,ds:[si]
            mov es:[di],al
            mov byte ptr es:[di+1],00000100b
            add di,2
            inc si
            loop showYear
            pop di
            pop si
            pop es
            pop ds
            pop cx
            pop bx
            pop ax
            ret
clear_screen:
            mov bx,0
            mov cx,2000
clearScreen:
            mov word ptr es:[bx],0700h
            add bx,2
            loop clearScreen
            ret
init_reg:
            mov bx,0b800h
            mov es,bx
            mov bx,data
            mov ds,bx
            ret
code ends
end start
