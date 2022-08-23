;7   6    5   4   3    2   1   0
;BL  R    G   B   I    R   G   B
;闪烁  背景       高亮   前景
;
;闪烁黑底前景绿色   10000010b=82h
;绿底红色 		   00100100b=24h
;白底蓝色           01110001b=71h
;B8000h~B8F9Fh为前4000个字节,也就是第一页的内容  25行*80字符
;偏移000~09F对应显示器上的第1行(80个字符占160个字节)
;偏移0A0~13F对应显示器上的第2行
;偏移140~1DF对应显示器上的第3行
;偏移F00~F9F对应显示器上的第25行

;第十行640~6DF
;十一行6E0
;十二行780
;在屏幕中间分别显示绿色、绿底红色、白底蓝色的字符串 'welcome to masm!'
assume cs:code
data segment
	db 'welcome to masm!'
	db 82h,24h,71h
data ends
stack segment
db 128 dup(0)
stack ends
code segment
    start:  mov ax,data
            mov ds,ax

            mov ax,stack
            mov ss,ax
            mov sp,128

            mov ax,0b800h;段地址
            mov es,ax

            mov bp,0+160*10+2*2;偏移地址	第十行第二列  一列两个字节      直接这样写,吃饱了撑自己去算
            mov bx,0;数据指针
            mov si,0+16;颜色偏移地址
            mov cx,3

s1:         push bp
            push bx
            push si
            push cx

            mov cx,16

            mov ah,ds:[si] ;颜色高位

s:          mov al,ds:[bx] ;数据低位
            mov es:[bp],ax
            inc bx
            add bp,2
            loop s

            pop cx
            pop si
            pop bx
            pop bp
            add bp,160;下一行
            inc si;颜色换下一个
            loop s1

            mov ax,4c00h
            int 21h
code ends
end start