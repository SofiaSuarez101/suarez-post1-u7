; post2c.asm - Limpiar pantalla con REP STOSW en B800h
; Compilar: nasm -f bin post2c.asm -o post2c.com
ORG 100h

VIDEO_SEG  equ 0B800h
COLS       equ 80
CELDAS     equ 2000
FONDO_AZUL equ 1720h        ; AH=17h (azul/blanco), AL=20h (espacio)
ATTR_TEXTO equ 1Fh          ; blanco brillante sobre azul

section .text
start:
    mov ax, VIDEO_SEG
    mov es, ax

    mov ax, FONDO_AZUL
    xor di, di
    mov cx, CELDAS
    cld
    rep stosw

    ; Mensaje en fila 12, col 30
    mov di, (12*COLS + 30)*2
    mov si, titulo
.bucle:
    lodsb
    or al, al
    jz .fin
    mov ah, ATTR_TEXTO
    stosw
    jmp .bucle

.fin:
    mov ah, 07h
    int 21h
    mov ah, 4Ch
    xor al, al
    int 21h

section .data
titulo db "HOLA DESDE B800h", 0