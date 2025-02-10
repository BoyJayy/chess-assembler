.model tiny
.186
code segment
    org 100h
    assume cs: code

start:
    ; Инициализация режима отображения
    int 10h
    ; Инициализация шахматного поля
    mov si, offset chessboard_data
    mov di, offset chessboard

    ; Настройка доски
    call init_chessboard

main_loop:
    ; Основной цикл игры
    call display_chessboard  ; Отображение доски
    call player_move         ; Ход игрока
    call update_chessboard   ; Обновление доски
    jmp main_loop            ; Повторить цикл

; Инициализация шахматной доски
init_chessboard:
    ; Заполняем шахматную доску начальной расстановкой
    mov cx, 8               ; 8 строк
    mov bx, 0               ; Начальная строка
fill_board:
    ; Заполняем клетки с фигурами
    mov al, [si]            ; Считываем текущий байт данных (позиции фигур)
    mov [di], al            ; Записываем в игровое поле
    inc si
    inc di
    loop fill_board
    ret

; Отображение шахматной доски
display_chessboard:
    mov si, offset chessboard
    mov cx, 64              ; 8x8 доска (64 клетки)
    mov dl, 0Ah             ; Символ новой строки для отображения
display_loop:
    lodsb                   ; Чтение байта из доски
    cmp al, 20h             ; Проверка на пустую клетку (символ пробела)
    jz display_empty_square
    ; Если клетка не пуста, отобразить символ фигуры
    mov ah, 02h
    int 21h                 ; Вывод символа
    jmp display_continue

display_empty_square:
    ; Если клетка пуста, вывести точку
    mov dl, '.'
    mov ah, 02h
    int 21h                 ; Вывод символа

display_continue:
    loop display_loop
    ; Переход на новую строку
    mov ah, 02h
    int 21h
    ret

; Ход игрока
player_move:
    ; Ожидаем ввод хода игрока в формате "e2 e4"
    ; Первая буква - колонка (a-h), вторая - строка (1-8)
    ; Преобразуем координаты из символов в индексы массива (0-63)
    mov ah, 01h             ; Ввод символа
    int 21h                 ; Чтение первого символа (например, 'e')
    sub al, 61h             ; Преобразуем в индекс (0 = a, 1 = b, ..., 7 = h)
    mov bl, al              ; Сохраняем в BL (для колонок)

    mov ah, 01h             ; Ввод второго символа (например, '2')
    int 21h
    sub al, 30h             ; Преобразуем в число (1 = 1, 2 = 2, ..., 8 = 8)
    sub al, 1               ; Переводим в индекс (0 = 1, 1 = 2, ..., 7 = 8)
    mov bh, al              ; Сохраняем строку в BH

    ; Чтение пробела между координатами
    mov ah, 01h
    int 21h

    ; Повторяем для второй клетки (например, "e4")
    mov ah, 01h
    int 21h
    sub al, 61h
    mov bl, al              ; Сохраняем в BL (для колонок)

    mov ah, 01h
    int 21h
    sub al, 30h
    sub al, 1
    mov bh, al              ; Сохраняем строку в BH

    ; Обновляем шахматную доску
    ; Перемещение фигуры на доске
    mov si, offset chessboard
    mov di, si
    add di, bx              ; Перемещение в колонку
    add di, 8 * bh          ; Перемещение в строку
    mov al, [si]            ; Чтение фигуры
    mov [di], al            ; Перемещение фигуры
    mov byte ptr [si], 20h  ; Очистка исходной клетки

    ret

; Обновление доски после хода
update_chessboard:
    ; Логика обновления доски после хода (пока нет)
    ret

; Данные шахматной доски (инициализация позиций фигур)
chessboard_data db 
    10h, 12h, 14h, 16h, 18h, 14h, 12h, 10h,  ; Черные фигуры
    20h, 20h, 20h, 20h, 20h, 20h, 20h, 20h,  ; Пустые клетки
    30h, 30h, 30h, 30h, 30h, 30h, 30h, 30h,  ; Белые пешки
    10h, 12h, 14h, 16h, 18h, 14h, 12h, 10h,  ; Белые фигуры

chessboard db 64 dup(20h)  ; Место для самой шахматной доски (символы фигур или пустые клетки)

code ends
end start
