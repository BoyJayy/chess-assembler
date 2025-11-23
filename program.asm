.model tiny
.186
code segment
    org 100h
    assume cs: code

start:
    int 10h
    mov si, offset chessboard_data
    mov di, offset chessboard

    ; Настройка доски
    call init_chessboard

main_loop:
    ; Основной цикл игры
    call display_chessboard 
    call player_move       
    call update_chessboard 
    jmp main_loop          

init_chessboard:
    mov cx, 8              
    mov bx, 0              
fill_board:
    ; Заполняем клетки с фигурами
    mov al, [si]         
    mov [di], al         
    inc si
    inc di
    loop fill_board
    ret

display_chessboard:
    mov si, offset chessboard
    mov cx, 64            
    mov dl, 0Ah            
display_loop:
    lodsb               
    cmp al, 20h         
    jz display_empty_square
    mov ah, 02h
    int 21h             
    jmp display_continue

display_empty_square:
    mov dl, '.'
    mov ah, 02h
    int 21h          

display_continue:
    loop display_loop
    ; Переход на новую строку
    mov ah, 02h
    int 21h
    ret

player_move:
    mov ah, 01h        
    int 21h            
    sub al, 61h       
    mov bl, al           

    mov ah, 01h           
    int 21h
    sub al, 30h          
    sub al, 1            
    mov bh, al           

    mov ah, 01h
    int 21h

    mov ah, 01h
    int 21h
    sub al, 61h
    mov bl, al          

    mov ah, 01h
    int 21h
    sub al, 30h
    sub al, 1
    mov bh, al             

    mov si, offset chessboard
    mov di, si
    add di, bx           
    add di, 8 * bh        
    mov al, [si]           
    mov [di], al         
    mov byte ptr [si], 20h 

    ret

update_chessboard:
    ret
chessboard_data db 
    10h, 12h, 14h, 16h, 18h, 14h, 12h, 10h,  
    20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h, 
    30h, 30h, 30h, 30h, 30h, 30h, 30h, 30h, 
    10h, 12h, 14h, 16h, 18h, 14h, 12h, 10h,  

chessboard db 64 dup(20h) 

code ends
end start

