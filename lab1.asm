[bits 16]

segment stack stack
	resb 64
segment data
	dat dd 80000000h, 80000000h, 80000000h, 1h, 80000000h ; Исходная строка
	lenw dw ($-dat)/4 ; Длина массива в двойных словах 
	result times (lenw-dat)/4 db 0  ; Результат
	
segment code
..start:
	;Настраиваем сегмент данных
	mov ax, data
	mov ds, ax
	
	;Устанавливаем входные данные
	mov ax, ds
	mov es, ax
	mov fs, ax
	xor ax, ax
	
	mov dx, dat
	mov bx, result
	mov cx, [lenw]
	call bitString
	
	mov ah, 4ch
	int 21h
	
bitString:
		push si
		push di
		xor si, si
		mov di, dx
		cycle:
			bt dword[es:di], 31 ; Если 31 бит не установлен
			jnc zero ; Перемещаемся на следующий бит строки-результата
			bts [fs:bx], si ; Иначе устанавливаем бит с индексом si
			zero:
			inc si ; Переходим на следующий бит
			skip:
			add di, 4 ; Переходим к следующему элементу массива dword
			dec cx ; Уменьшаем счетчик
		cmp cx, 0 ; Если cx != 0
		jne cycle ; Продолжаем цикл
		
		;Восстанавливаем регистры
		pop di
		pop si
		
		ret

	
