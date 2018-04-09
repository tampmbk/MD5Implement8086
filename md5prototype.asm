.MODEL SMALL
.STACK 100H
.DATA 
R DB 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22, 7, 12, 17, 22,5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20, 5,  9, 14, 20,4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 4, 11, 16, 23, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21, 6, 10, 15, 21
K DD d76aa478h,e8c7b756h,242070dbh,c1bdceeeh,f57c0fafh,4787c62ah,a8304613h,fd469501h,698098d8h,8b44f7afh,ffff5bb1h,895cd7beh,6b901122h,fd987193h,a679438eh,49b40821h,f61e2562h,c040b340h,265e5a51h,e9b6c7aah,d62f105dh,02441453h,d8a1e681h,e7d3fbc8h,21e1cde6h,c33707d6h,f4d50d87h,455a14edh,a9e3e905h,fcefa3f8h,676f02d9h,8d2a4c8ah,fffa3942h,8771f681h,6d9d6122h,fde5380ch,a4beea44h,4bdecfa9h,f6bb4b60h,bebfbc70h,289b7ec6h,eaa127fah,d4ef3085h,04881d05h,d9d4d039h,e6db99e5h,1fa27cf8h,c4ac5665h,f4292244h,432aff97h,ab9423a7h,fc93a039h,655b59c3h,8f0ccc92h,ffeff47dh,85845dd1h,6fa87e4fh,fe2ce6e0h,a3014314h,4e0811a1h,f7537e82h,bd3af235h,2ad7d2bbh,eb86d391h
H0 DD 0X67452301
H1 DD 0XEFCDAB89
H2 DD 0X98BADCFE
H3 DD 0X10325476
NHACNHAP DB "NHAP VAO CHUOI:$"
KQ DB 13,10,"MD5 LA:",13,10,"$"

XAU DB 56 DUP (0),80h,0,0,0,0,0,0,0
A DD 0X67452301
B DD 0XEFCDAB89
C DD 0X98BADCFE
D DD 0X10325476
tt1 dw 0
tt2 dw 0
F DD 0
G DD 0
TEMP DD 0

MANG DB 100 DUP (?)
count db 2
nhapdodaixau db "ban muon nhap bao nhieu ky tu",13,10,"$"
.CODE

MAIN PROC
    MOV AX,@DATA     ; HIEN THI LOI NHAC
    MOV DS,AX        ;          
    lea dx,nhapdodaixau ; nhac nhap do dai xau
    mov ah,09h
    int 21h
    mov bl,0
    mov bx,0
    nhapdodai:
        mov ah,01h
        int 21h
        cmp al,13       ;nhan enter
        je thoatnhap    ;     thi dung lai           
        mov bh,al       ; luu so vua nhap 
        sub bh,30h      ;     vao bh
        mov al,bl       ; nhan so da nhap luc truoc
        mov cl,10       ;     voi 10
        mul cl
        mov bl,al       ;     roi cong voi so vua nhap
        add bl,bh       ; ket qua o bl
    jmp nhapdodai       
    thoatnhap:
    mov cl,bl         ; so luong ky tu trong xau
    mov ch,0
    mov al,bl         ;nhan do dau cua xau
    mov ah,0
    mov dl,8          ;         voi 8
    mul dl
    
    
    lea dx,xau       ; luu bit dao nguoc vao trong xau
    mov xau+56,al
    mov xau+57,ah                                      
    
    LEA DX,NHACNHAP  ;
    MOV AH,09H       ;
    INT 21H
    ;MOV CX,16       ; XAU CO 16 KY TU
    LEA DX,XAU       ; LAY VI TRI CUA BO 
    MOV DI,DX        ;      NHO DE LUU XAU
    NHAPXAU:         ; NHAP 1
        MOV AH,01H   ;      KY TU
        INT 21H
        MOV [DI],AL  ; LUU KY TU VUA NHAP
        INC DI       ;      VAO TRONG BO NHO
    LOOP NHAPXAU
    MOV [DI],80H     ; THEM BIT 1 VAO SAU XAU
    
    ; TINH MD 5
    ; input chi co 1 block 512 byte
    MOV CX,64        ;LAP 64 LAN
    md5:
        cmp cx,48
        ja hamf
        cmp cx,32
        ja hamg
        cmp cx,16
        ja hamh
        cmp cx,0
        ja hamt
        hamf:
            mov ax,b    ;
            mov bx,c    ;
            and ax,bx   ; b_&c_
            mov tt1,ax
            mov ax,b
            mov bx,d
            not ax
            and ax,bx   ;~b_&d_
            mov bx,tt1
            or ax,bx    ;(b_&c_)|(~b_&d_)
            mov f,ax
            mov ax,b+2
            mov bx,c+2
            and ax,bx   ; b^&c^
            mov tt1,ax
            mov ax,b+2
            mov bx,d+2
            not ax
            and ax,bx   ;~b^&d^
            mov bx,tt1
            or ax,bx    ;(b^&c^)|(~b^&d^)
            mov f+2,ax
            mov ax,cx
            neg ax
            add ax,64
            mov g,ax
            jmp md5tiep
        hamg:
            mov ax,d    ;
            mov bx,b    ;
            and ax,bx   ; d_&b_
            mov tt1,ax
            mov ax,d
            mov bx,c
            not ax
            and ax,bx   ;~d_&c_
            mov bx,tt1
            or ax,bx    ;(d_&b_)|(~d_&c_)
            mov f,ax
            mov ax,d+2
            mov bx,b+2
            and ax,bx   ; d^&b^
            mov tt1,ax
            mov ax,d+2
            mov bx,c+2
            not ax
            and ax,bx   ;~d^&c^
            mov bx,tt1
            or ax,bx    ;(d^&b^)|(~d^&c^)
            mov f+2,ax
            mov ax,cx
            neg ax
            add ax,64   ;i
            mov bl,5
            mul bl       ;i*5
            add ax,1    ;5*i+1
            mov dl,16
            div dl      ;(5*i+1)%16
            mov al,ah
            mov ah,0
            mov g,ax
            jmp md5tiep    
        hamh:
            mov ax,b    ;
            mov bx,c    ;
            xor ax,bx   ; b_(+)c_
            mov bx,d
            xor ax,bx   ;b_(+)c_(+)d_
            mov f,ax
            mov ax,b+2
            mov bx,c+2
            xor ax,bx   ; b^(+)c^
            mov bx,d+2
            xor ax,bx   ;b(+)&c^(+)d^
            mov f+2,ax
            mov ax,cx
            neg ax
            add ax,64   ;i
            mov bl,3
            mul bl       ;i*3
            add ax,5    ;3*i+5
            mov dl,16
            div dl      ;(3*i+5)%16
            mov al,ah
            mov ah,0
            mov g,ax
            jmp md5tiep    
        hamt:
            mov ax,b    ;
            mov bx,d    ;
            not bx
            or ax,bx    ; b_|~d_
            mov bx,c
            xor ax,bx   ;c_(+)(b_|~d_)
            mov f,ax
            mov ax,b+2
            mov bx,d+2
            not bx
            or ax,bx    ; b^|~d^
            mov bx,c+2
            xor ax,bx   ;c^(+)(b^|~d^)
            mov f+2,ax
            mov ax,cx
            neg ax
            add ax,64   ;i
            mov dl,7
            mul dl       ;7*i
            mov dl,16
            div dl      ;(7*i)%16
            mov al,ah
            mov ah,0
            mov g,ax
        md5tiep:
        mov ax,d        ;
        mov temp,ax     ;
        mov ax,d+2      ;
        mov temp+2,ax   ;temp = d
        mov ax,c
        mov d,ax
        mov ax,c+2
        mov d+2,ax      ; d = c
        mov ax,b
        mov c,ax
        mov ax,b+2
        mov c+2,ax      ; c = b
        
        
        mov ax, word ptr a
        mov bx, word ptr f
        add ax,bx
        mov word ptr tt1,ax
        mov ax, word ptr a+2
        mov bx, word ptr f+2
        adc ax,bx
        mov word ptr tt2,ax  ; a+f
        
        mov ax,cx
        neg ax
        add ax,64           ;i
        mov dl,4
        mul dl
        mov bx,ax
        mov ax,[bx+K]         ;k[i]
        ;mov ah,[bx+K+1]       ;k[i]
        mov dx,tt1
        add ax,dx
        mov tt1,ax
        mov ax,[k+bx+2]      ;k[i]
        ;mov ah,[k+bx+3]      ;k[i]
        mov dx,tt2
        adc ax,dx
        mov tt2,ax          ; a+f+k[i]
        
        mov ax,g
        mov dl,4
        mul dl
        mov bx,ax
        mov al,[xau+bx]       ;w[g]
        mov ah,[xau+bx+1]     ;w[g]
        mov dx,tt1
        add ax,dx
        mov tt1,ax
        mov al,[xau+bx+2]     ;w
        mov ah,[xau+bx+3]     ;w
        mov dx,tt2
        adc ax,dx
        mov tt2,ax          ; a+f+k[i]+w[g]
        
        ;mov ax,b
        ;mov bx,tt1
        ;add ax,bx
        ;mov b,ax
        ;mov ax,b+2
        ;mov bx,tt2
        ;adc ax,bx
        ;mov b+2,ax        ;b+?? a+f+k[i]+w[g]
        
        mov ax,cx
        neg ax
        add ax,64           ;i
        mov bx,ax
        mov al,r+bx         ;r[i]
          ; so lan dich trai 
        mov bx,tt1
        mov dx,tt2
        dichtrai:
            clc
            rcl bx,1
            rcl dx,1
            rcr bx,1
            rol bx,1 
            sub al,1
            cmp al,0
            
            jne dichtrai ;LEFTROTATE((a+f+k[i]+w[g]),r[i])
            
        
        mov tt1,bx
        mov tt2,dx
        mov dx,c
        add bx,dx
        mov b,bx
        mov bx,tt2
        mov dx,c+2
        adc bx,dx
        mov b+2,bx      ;b+LEFTROTATE((a+f+k[i]+w[g]),r[i])
        mov ax,temp
        mov a,ax
        mov ax,temp+2
        mov a+2,ax      ; a = temp
    
    loop md5
    
    mov ax,h0
    mov bx,a
    add ax,bx
    mov h0,ax
    mov ax,h0+2
    mov bx,a+2
    adc ax,bx
    mov h0+2,ax       ; h0 = h0+a                      
    mov ax,h1
    mov bx,b
    add ax,bx
    mov h1,ax
    mov ax,h1+2
    mov bx,b+2
    adc ax,bx
    mov h1+2,ax       ; h1 = h1+b 
    mov ax,h2
    mov bx,c
    add ax,bx
    mov h2,ax
    mov ax,h2+2
    mov bx,c+2
    adc ax,bx
    mov h2+2,ax       ; h2 = h2+c 
    mov ax,h3
    mov bx,d
    add ax,bx
    mov h3,ax
    mov ax,h3+2
    mov bx,d+2
    adc ax,bx
    mov h3+2,ax       ; h3 = h3+d
    ;
    ;;;;;;;;
    ;hien thi gia tri hex
    lea dx,kq
    mov ah,09h
    int 21h 
    mov cl,16       ;divide by  
    mov ax, 0        
    mov bx,0
    inkq:
    
    
    mov ax, [h0+bx]    
    mov ah,0     
    mov dx,0    ; puting 0 in the high part of the divided number (DX:AX)
    div cx 
    again1:
      
        cmp dl, 9   
        ja kytud     ; neu dx >9 thi chuyen sang ky tu (A-F)
        cmp dl, 9
        jna sod      ; neu dx < 9 thi doi sang so
    againa:    
        cmp al,9
        ja kytua
        cmp al,9
        jna soa
    tiep:                   
        push dx
        jne againa
    tiepa:                   
        push ax
         
    again2:
        pop dx
        mov ah, 2
        int 21h
        dec count
        cmp count, 0
        jne again2  
     
    jmp thoat
      
    kytud:
        add dl, 37h
        jmp tiep  
    sod:
        add dl, 30h
        jmp tiep
    kytua:
        add al, 37h
        jmp tiepa  
    soa:
        add al, 30h
        jmp tiepa    
    
    thoat:
        add bx,1
        cmp bx,16
        mov count,2
        jne inkq
     
        mov ah, 4ch
        int 21h
     
    RET
    
MAIN ENDP


END MAIN