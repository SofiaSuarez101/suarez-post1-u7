; post1d.asm - INT 10h: modo de video (AH=0Fh) y relectura de celda (AH=08h)
; Compilar: nasm -f bin post1d.asm -o post1d.com
ORG 100h

section .text
start:
    ; AH=0Fh: obtener el modo de video activo
    mov ah, 0Fh
    int 10h             ; AL=modo, AH=columnas, BH=pagina activa
    mov bl, al          ; guardar el modo en BL (DX se usa para imprimir)

    mov ah, 09h
    mov dx, msgModo
    int 21h

    cmp bl, 03h         ; 03h = texto 80x25 color
    jne .modo_raro
    mov ah, 09h
    mov dx, msgOk
    int 21h
    jmp .escribir

.modo_raro:
    mov ah, 09h
    mov dx, msgNook
    int 21h

.escribir:
    ; Cursor en fila 8, columna 10
    mov ah, 02h
    xor bh, bh
    mov dh, 08h
    mov dl, 0Ah
    int 10h

    ; "Z" con atributo 2Fh (fondo verde, texto blanco brillante)
    mov ah, 09h
    mov al, "Z"
    xor bh, bh
    mov bl, 2Fh
    mov cx, 1
    int 10h

    ; Reposicionar el cursor en la misma celda antes de leer
    mov ah, 02h
    xor bh, bh
    mov dh, 08h
    mov dl, 0Ah
    int 10h

    ; AH=08h: leer caracter y atributo (pagina 0)
    mov ah, 08h
    xor bh, bh
    int 10h             ; AH=atributo, AL=caracter

    cmp al, "Z"
    jne .no_coincide
    cmp ah, 2Fh
    jne .no_coincide
    mov ah, 09h
    mov dx, msgVerOk
    int 21h
    jmp .fin

.no_coincide:
    mov ah, 09h
    mov dx, msgVerBad
    int 21h

.fin:
    mov ah, 07h
    int 21h
    mov ah, 4Ch
    xor al, al
    int 21h

section .data
msgModo   db "Modo de video: $"
msgOk     db "03h", 0Dh, 0Ah, "Modo texto 80x25 confirmado (03h)", 0Dh, 0Ah, "$"
msgNook   db "?", 0Dh, 0Ah, "Modo inesperado, se continua de todas formas", 0Dh, 0Ah, "$"
msgVerOk  db 0Dh, 0Ah, "Verificacion OK: caracter y atributo releidos coinciden", "$"
msgVerBad db 0Dh, 0Ah, "ERROR: la relectura no coincide con lo escrito", "$"