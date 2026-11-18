; post2b.asm - Escritura directa en B800h
; Compilar: nasm -f bin post2b.asm -o post2b.com
ORG 100h

VIDEO_SEG equ 0B800h
COLS      equ 80
ATTR_BLANCO   equ 0Fh
ATTR_AMARILLO equ 0Eh
ATTR_VERDE    equ 0Ah
ATTR_ROJO     equ 0Ch

section .text
start:
    mov ax, VIDEO_SEG
    mov es, ax

    ; offset = (fila*80 + col)*2
    mov di, (10*COLS + 35)*2
    mov byte [es:di], "H"
    mov byte [es:di+1], ATTR_BLANCO

    mov di, (11*COLS + 35)*2
    mov byte [es:di], "O"
    mov byte [es:di+1], ATTR_AMARILLO

    mov di, (12*COLS + 35)*2
    mov byte [es:di], "L"
    mov byte [es:di+1], ATTR_VERDE

    mov di, (13*COLS + 35)*2
    mov byte [es:di], "A"
    mov byte [es:di+1], ATTR_ROJO

    mov ah, 07h
    int 21h
    mov ah, 4Ch
    xor al, al
    int 21h