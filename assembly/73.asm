;73.课程设计2
assume cs:code,ds:data,ss:stack
data segment
	db 256 dup(0)
data ends
stack segment
	db 128 dup(0)
stack ends
code segment
    start:  mov ax,stack
            mov ss,ax
            mov sp,128

			call cpy_Boot;复制Boot到7e00h
			call sav_old_int9
            mov bx,0
            push bx
            mov bx,7e00h
            push bx
            retf; pop ip pop cs

            mov ax,4c00h
            int 21h
;=============================
Boot:       jmp BOOT_START
;************************************
OPTION_1    db  '1) restart pc',0
OPTION_2    db  '2) start system',0
OPTION_3    db  '3) show clock',0
OPTION_4    db  '4) set clock',0

ADDRESS_OPTION dw offset OPTION_1-offset Boot+7e00h
               dw offset OPTION_2-offset Boot+7e00h
               dw offset OPTION_3-offset Boot+7e00h
               dw offset OPTION_4-offset Boot+7e00h
TIME_CMOS       db 9,8,7,4,2,0
TIME_STYLE     	db  'YY/MM/DD HH:mm:SS',0
STRING_STACK   db 12 dup('0'),0
;************************************
;==================================
BOOT_START:
            mov bx,0b800h
            mov es,bx

            mov bx,0
            mov ds,bx;初始化寄存器

            call clear_screen
            call show_option
            jmp choose_option

;===============================
choose_option:
            call clear_buff
            mov ah,0
            int 16h;调用bios提供的16h获取键盘的输入
            ;返回值ah扫描码,al ascii码

            cmp al,'1'
            je isChooseOne
            cmp al,'2'
            je isChooseTwo
            cmp al,'3'
            je isChooseThree
            cmp al,'4'
            je isChooseFour
            jmp choose_option
;======================
isChooseOne:mov di,160*3
            mov byte ptr es:[di],'1'
            jmp choose_option
isChooseTwo:mov di,160*3
            mov byte ptr es:[di],'2'
            jmp choose_option
isChooseThree:mov di,160*3
            mov byte ptr es:[di],'3'
            call show_clock
            jmp BOOT_START
isChooseFour:mov di,160*3
            mov byte ptr es:[di],'4'
			call set_clock
            jmp choose_option
;============================			
set_clock:	call clear_string_stack
			call show_string_stack
			call get_string
			call set_time
			ret	
;============================
set_time:	mov bx,offset TIME_CMOS-offset Boot+7e00h
			mov si,offset STRING_STACK-offset Boot+7e00h
			mov cx,6
setTime:	mov dx,ds:[si] ;比如12 0000 0001 | 0000 0010
			sub dh,30h
			sub dl,30h;字符1先减30h
			shl dh,1    ;要得到 0001 0010
			shl dh,1
			shl dh,1
			shl dh,1;dh 0001 0000
			or dh,dl
			
			mov al,ds:[bx]
			out 70h,al;70h端口选中要操作的内存单元
			
			mov al,dh
			out 71h,al
			
			add si,2
			inc bx
			loop setTime
			ret
;============================
get_string:	mov si,offset STRING_STACK-offset Boot+7e00h
			mov bx,0
getString:	call clear_buff

			mov ah,0
			int 16h
			
			cmp al,'0'
			jb notNumber
			cmp al,'9'
			ja notNumber;判断数字是否在0~9
			call char_push
			call show_string_stack
			jmp getString
getStringRet:
			ret
notNumber:	cmp ah,0eh;BackSpace扫描码
			je isBackSpace  ;
			cmp ah,1ch;enter扫描码
			jmp getStringRet
isBackSpace:call char_pop
			call show_string_stack
			jmp getString
;============================
char_pop:	cmp bx,0
			je char_popRet
			dec bx
			mov byte ptr ds:[si+bx],'0'
char_popRet:ret
;============================
char_push:	cmp bx,11
			ja charPushRet		
			mov ds:[si+bx],al
			inc bx
charPushRet:ret
;============================
show_string_stack:
			push si
			push di
			mov si,offset STRING_STACK-offset Boot+7e00h
			mov di,160*4
			call show_string
			pop di
			pop si
			ret
;============================	
clear_string_stack:
			push bx
			push cx
			push es
			push si
			push di
			
			mov si,offset STRING_STACK-offset Boot+7e00h
			mov dx,3030h;0的ascii码
			mov cx,6
clearStringStack:
			mov ds:[si],dx
			add si,2
			loop clearStringStack
			
			pop di
			pop si
			pop es
			pop cx
			pop bx
			ret
;============================
show_clock: call show_style
			call set_new_int9
			
showTime:
            mov si,offset TIME_CMOS-offset Boot +7e00h
			mov di,160*20
			mov cx,6
			
showDate:	mov al,ds:[si]
			out 70h,al
			in al,71h
			mov ah,al
			shr ah,1
			shr ah,1
			shr ah,1
			shr ah,1
			and al,00001111b
			
			add ah,30h
			add al,30h
			
			mov es:[di],ah
			mov es:[di+2],al
			
			add di,6
			inc si
			loop showDate
			jmp showTime
showTimeRet:call set_old_int9;把原来的int9设置回去
			
            ret
;=========================
set_new_int9:push bx;设置自己的int9到中断向量表里
			push es
			mov bx,0
			mov es,bx
			cli
			mov word ptr es:[9*4],offset new_int9-offset Boot+7e00h
			mov word ptr es:[9*4+2],0		
			sti
			pop es
			pop bx
			ret
;=========================
new_int9:	push ax
			call clear_buff
			in al,60h;从键盘读取输入
			pushf;将标志寄存器入栈
			call dword ptr cs:[200h];bios的int9被保存在0,200h,调用他
			cmp al,01h;esc的扫描码
			je isEsc
			cmp al,3bh  ;F1的扫描码		
			jne int9Ret
			call change_time_color
			
int9Ret:  	pop ax
			iret
isEsc:		pop ax
			add sp,4  ;pushf push cs push ip现在cs,ip指向显示时间的某一条指令,现在要退出不需要这个cs和ip了
			popf;只需要标志寄存器
			jmp showTimeRet
		
set_old_int9:
			push bx
			push es
			mov bx,0
			mov es,bx
			cli
			push es:[200h]
			pop es:[4*9]
			push es:[202h]
			pop es:[4*9+2]
			sti
			pop es
			pop bx
			ret
;=========================
change_time_color:
			push bx
			push cx
			push es
			mov bx,0b800h
			mov es,bx
			mov bx,160*20+1
			mov cx,17
changeTimeColor:
			inc byte ptr es:[bx]
			add bx,2
			loop changeTimeColor
			pop es
			pop cx
			pop bx
			ret
;=========================
show_style:
            mov si,offset TIME_STYLE-offset Boot +7e00h
            mov di,160*20
            call show_string
            ret
;=========================
clear_buff: mov ah,1
            int 16h
            jz clearBuffRet
            mov ah,0
            int 16h
            jmp clear_buff
clearBuffRet:
            ret
;============================
show_option:
            mov bx,offset ADDRESS_OPTION-offset Boot+7e00h
            mov di,160*10+30*2
            mov cx,4

showOption:
            mov si,ds:[bx];把option的偏移地址给si
            call show_string
            add bx,2
            add di,160
            loop showOption
            ret
;===========================
show_string:push dx
            push ds
            push es
            push si
            push di
showString: mov dl,ds:[si]
            cmp dl,0
            je showStringRet
            mov es:[di],dl
            add di,2
            inc si
            jmp showString
showStringRet:
            pop di
            pop si
            pop es
            pop ds
            pop dx
            ret
;============================
clear_screen:
            mov bx,0
            mov dx,0700h
            mov cx,2000
clearScreen:
            mov es:[bx],dx
            add bx,2
            loop clearScreen
            ret
Boot_end:   nop
;=============================
sav_old_int9:
			mov bx,0
			mov es,bx
			push es:[9*4]
			pop es:[200h]
			push es:[9*4+2]
			pop es:[202h]
			ret
;=============================
cpy_Boot:   mov bx,cs
            mov ds,bx
            mov si,offset Boot

            mov bx,0
            mov es,bx
            mov di,7e00h

            mov cx,offset Boot_end-offset Boot
            cld
            rep movsb
            ret
;=============================
code ends
end start