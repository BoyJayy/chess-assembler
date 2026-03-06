.model tiny
.186
code segment
org 100h
assume cs:code, ds:code

start:
    push cs
    pop ds

    mov si, offset chessboard_data
    mov di, offset chessboard
    call init_chessboard

main_loop:
    call display_chessboard
    call player_move
    jmp main_loop

init_chessboard:
    mov cx, 64
copy_loop:
    mov al, [si]
    mov [di], al
    inc si
    inc di
    loop copy_loop
    ret

display_chessboard:
    mov si, offset chessboard
    mov cx, 64
    xor bx, bx

print_loop:
    lodsb
    cmp al, ' '
    jne print_piece
    mov dl, '.'
    jmp print_char

print_piece:
    mov dl, al

print_char:
    mov ah, 02h
    int 21h

    mov dl, ' '
    mov ah, 02h
    int 21h

    inc bl
    cmp bl, 8
    jne no_newline

    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h
    xor bl, bl

no_newline:
    loop print_loop
    ret

player_move:
    mov ah, 01h
    int 21h
    sub al, 'a'
    mov dl, al

    mov ah, 01h
    int 21h
    sub al, '1'
    mov dh, al

    mov ah, 01h
    int 21h
    sub al, 'a'
    mov bl, al

    mov ah, 01h
    int 21h
    sub al, '1'
    mov bh, al

    xor ax, ax
    mov al, dh
    shl al, 1
    shl al, 1
    shl al, 1
    add al, dl
    xor si, si
    mov si, offset chessboard
    add si, ax

    xor ax, ax
    mov al, bh
    shl al, 1
    shl al, 1
    shl al, 1
    add al, bl
    xor di, di
    mov di, offset chessboard
    add di, ax

    mov al, [si]
    mov [di], al
    mov byte ptr [si], ' '

    mov dl, 13
    mov ah, 02h
    int 21h
    mov dl, 10
    mov ah, 02h
    int 21h

    ret

chessboard_data db \
'R','N','B','Q','K','B','N','R',\
'P','P','P','P','P','P','P','P',\
' ',' ',' ',' ',' ',' ',' ',' ',\
' ',' ',' ',' ',' ',' ',' ',' ',\
' ',' ',' ',' ',' ',' ',' ',' ',\
' ',' ',' ',' ',' ',' ',' ',' ',\
'p','p','p','p','p','p','p','p',\
'r','n','b','q','k','b','n','r'

chessboard db 64 dup(' ')

code ends
end start
