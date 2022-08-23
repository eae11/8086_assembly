;58在屏幕的5行12列显示3个红底高亮闪烁绿色的“a”。
assume cs:code
code segment
start:      mov ah,2;置光标
            mov bh,0;参数页
            mov dh,5;参数行号
            mov dl,12;参数列号
            int 10h;bios提供的中断程序里面有很多子程序ah就是参数选择不同子程序

            mov ah,9;在光标位置显示字符
            mov al,'a';字符
            mov bl,11001010b;颜色
            mov bh,0;页
            mov cx,3;字符重复个数
            int 10h
            
            mov ax,4c00h
            int 21h

code ends
end start