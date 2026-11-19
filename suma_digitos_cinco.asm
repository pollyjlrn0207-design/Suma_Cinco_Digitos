.model small
.data
    ; Arreglos simples de 5 bytes para cada número y 6 bytes para el resultado (por si hay acarreo final)
    num1 db 5 dup(0)
    num2 db 5 dup(0)
    res  db 6 dup(0)

.code
    mov ax, @data
    mov ds, ax

    ; =========================================================
    ; 1. LEER PRIMER NÚMERO DE 5 DÍGITOS (de izquierda a derecha)
    ; =========================================================
    mov si, 0               ; Índice 0 = Decenas de millar ... Índice 4 = Unidades
leer_n1:
    mov ah, 01h
    int 21h
    sub al, 48              ; Convertir de ASCII a número
    mov num1[si], al
    inc si
    cmp si, 5
    jb  leer_n1

    ; Salto de línea (13 y 10)
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h

    ; =========================================================
    ; 2. LEER SEGUNDO NÚMERO DE 5 DÍGITOS
    ; =========================================================
    mov si, 0
leer_n2:
    mov ah, 01h
    int 21h
    sub al, 48
    mov num2[si], al
    inc si
    cmp si, 5
    jb  leer_n2

    ; Salto de línea (13 y 10)
    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h

    ; =========================================================
    ; 3. SUMAR DÍGITO POR DÍGITO (DE DERECHA A IZQUIERDA)
    ; =========================================================
    mov si, 4               ; Empezamos en el índice 4 (Unidades de num1 y num2)
    mov di, 5               ; Empezamos en el índice 5 (Unidades de res)
    mov bl, 0               ; BL guardará el acarreo (0 o 1)

sumar_columnas:
    mov al, num1[si]        ; Cargar dígito del 1er número
    add al, num2[si]        ; Sumar dígito del 2do número
    add al, bl              ; Sumar el acarreo de la columna anterior

    mov bl, 0               ; Reiniciar acarreo a 0
    cmp al, 9
    jbe guardar_digito      ; Si la suma <= 9, no hay acarreo

    sub al, 10              ; Si es >= 10, restar 10 para dejar solo la unidad
    mov bl, 1               ; Activar acarreo = 1 para la siguiente columna

guardar_digito:
    mov res[di], al         ; Guardar el dígito resultante

    dec di                  ; Mover índice de resultado a la izquierda
    dec si                  ; Mover índice de números a la izquierda
    cmp si, 0
    jge sumar_columnas      ; Repetir mientras SI >= 0

    ; Guardar el último acarreo en la primera posición del resultado (res[0])
    mov res[0], bl

    ; =========================================================
    ; 4. IMPRIMIR EL RESULTADO (HASTA 6 DÍGITOS)
    ; =========================================================
    mov di, 0
    ; Si el primer dígito (acarreo final) es 0, lo saltamos para no imprimir un 0 extra
    cmp res[0], 0
    jne imprimir_res
    mov di, 1

imprimir_res:
    mov dl, res[di]
    add dl, 48              ; Convertir de número a ASCII
    mov ah, 02h
    int 21h

    inc di
    cmp di, 6
    jb  imprimir_res

    ; --- Salir del programa ---
    mov ah, 4Ch
    int 21h

end