.model small
.data
    
    num1 db 5 dup(0)
    num2 db 5 dup(0)
    res  db 6 dup(0)

.code
    mov ax, @data
    mov ds, ax

    
    mov si, 0               
leer_n1:
    mov ah, 01h
    int 21h
    sub al, 48              
    mov num1[si], al
    inc si
    cmp si, 5
    jb  leer_n1

    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h

    mov si, 0
leer_n2:
    mov ah, 01h
    int 21h
    sub al, 48
    mov num2[si], al
    inc si
    cmp si, 5
    jb  leer_n2

    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h

    mov si, 4               
    mov di, 5             
    mov bl, 0               

sumar_columnas:
    mov al, num1[si]        
    add al, num2[si]        
    add al, bl              

    mov bl, 0              
    cmp al, 9
    jbe guardar_digito      

    sub al, 10              
    mov bl, 1               

guardar_digito:
    mov res[di], al        

    dec di                  
    dec si                 
    cmp si, 0
    jge sumar_columnas      

    mov res[0], bl

    mov di, 0

    cmp res[0], 0
    jne imprimir_res
    mov di, 1

imprimir_res:
    mov dl, res[di]
    add dl, 48             
    mov ah, 02h
    int 21h

    inc di
    cmp di, 6
    jb  imprimir_res

    mov ah, 4Ch
    int 21h

end