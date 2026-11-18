; post2e.asm - INT 16h/AH=02h: estado de Shift/Ctrl reflejado en B800h
; Compilar: nasm -f bin post2e.asm -o post2e.com
ORG 100h

VIDEO_SEG   equ 0B800h
ATTR_ETIQ   equ 0Fh
ATTR_SHIFT  equ 0Ah
ATTR_CTRL   equ 0Ch
MASK_SHIFT  equ 03h         ; bits 0-1
MASK_CTRL   equ 04h         ; bit 2
OFF_SHIFT   equ 6*2         ; fila 0, col 6
OFF_CTRL    equ 13*2        ; fila 0, col 13
ESC_SCAN    equ 01h

section .text
start:
    mov ax, VIDEO_SEG
    mov es, ax

    ; Etiqueta "SHIFT:" en columnas 0-5
    xor di, di
    mov si, etiqSh
    mov cx, 6
.etq1:
    lodsb
    mov ah, ATTR_ETIQ
    stosw
    loop .etq1

    ; Etiqueta "CTRL:" en columnas 8-12
    mov si, etiqCt
    mov di, 8*2
    mov cx, 5
.etq2:
    lodsb
    mov ah, ATTR_ETIQ
    stosw
    loop .etq2

.bucle:
    mov ah, 02h             ; estado de modificadores (no bloqueante)
    int 16h
    mov bl, al

    ; Shift (cualquiera de los dos)
    mov cl, "0"
    test bl, MASK_SHIFT
    jz .sh_listo
    mov cl, "1"
.sh_listo:
    mov di, OFF_SHIFT
    mov byte [es:di], cl
    mov byte [es:di+1], ATTR_SHIFT

    ; Ctrl
    mov cl, "0"
    test bl, MASK_CTRL
    jz .ct_listo
    mov cl, "1"
.ct_listo:
    mov di, OFF_CTRL
    mov byte [es:di], cl
    mov byte [es:di+1], ATTR_CTRL

    ; Hay tecla en el buffer?
    mov ah, 01h
    int 16h
    jz .bucle
    mov ah, 00h             ; consumirla
    int 16h
    cmp ah, ESC_SCAN
    jne .bucle

    mov ah, 4Ch
    xor al, al
    int 21h

section .data
etiqSh db "SHIFT:"
etiqCt db "CTRL:"