; post2d.asm - Mini editor: INT 16h + B800h
; Compilar: nasm -f bin post2d.asm -o post2d.com
ORG 100h

VIDEO_SEG equ 0B800h
COLS      equ 80
fila      equ 12
col_ini   equ 0
atributo  equ 0Fh

section .text
start:
    mov ax, VIDEO_SEG
    mov es, ax
    mov dl, col_ini         ; columna actual

.leer:
    mov ah, 00h
    int 16h                 ; AH = scan, AL = ASCII
    cmp al, 0Dh             ; Enter termina
    je .fin
    or al, al
    jz .leer                ; tecla extendida: ignorar
    mov cl, al              ; guardar el caracter (una sola lectura)

    ; offset = (fila*80 + col)*2
    xor bh, bh
    mov bl, dl
    mov ax, fila*COLS
    add ax, bx
    shl ax, 1
    mov di, ax

    mov byte [es:di], cl
    mov byte [es:di+1], atributo

    inc dl
    cmp dl, COLS
    jl .leer
    mov dl, col_ini         ; volver al inicio al llegar al borde
    jmp .leer

.fin:
    mov ah, 4Ch
    xor al, al
    int 21h