code	equ $F000
data	equ $0000
porta   equ $1000
portb	equ $1004
portc	equ $1003
porte	equ $100A
ddrc	equ	$1007 ; DDRC - регистр настройки направления разрядов порта C:
tlfg2	equ	$1025
tmsk2	equ	$1024

	org	data
init_PC		fcb $87 ; 10000111b
col_count	fcb $01 ; 00000001b
timer  fcb 0
start_led bsz 1
start_number bsz 1

	org	code
begin:
	lds #$000F
	ldaa #%00000011
	staa tmsk2	; настройка таймера (коэффициент деления частоты таймера)
	ldaa init_PC ; инициализация битов 0 - 2, 7 порта C на выход
	staa ddrc	 ; бит установлен в 0 - разряд порта работает на вход, 1 - на выход
	ldab col_count ; загрузка в регистр B начального значения счетчика колонок
	
scan_keys:
	cmpb #%08 ; сканирование колонок клавиатуры: проверка на переполнение счечика
	bne check1A ; переход, если значение B не равно $08
	ldab col_count ; реинициализация если было переполнение

check1A:
	stab portc ; загрузка единицы в очередную колонку, если не было переполнения в счетчике
	
	ldaa porte ; загрузка состояния порта Е в акк. А
	anda #%0001 ; нажата ли кнопка в первой строке?
	beq	check1B ; переход, если не первая строка
	tba ; перемещение счечика колонок в регистр A из B
	anda #%0100 ; нажата ли кнопка в первом столбце?
	beq check2A ; переход, если нет
	ldaa #%00001000 ; вывод цифры "1"
	staa porta ; вывод цифры "1"
	staa start_number
	ldaa #%10000000 ; зажигаем первый диод
	staa portb ; зажигаем первый диод
	staa start_led
	jmp end_scan ; переход в конец кода. Для команды BRA данный переход слишком делёкий!
check2A:	
	tba
	anda #%0010 ; нажата ли кнопка во втором столбце?
	beq check3A ; переход, если нет
	ldaa #%00010000 ; вывод цифры "2"
	staa porta ; вывод цифры "2"
	staa start_number
	ldaa #%01000000 ; зажигаем второй диод
	staa portb ; зажигаем второй диод
	staa start_led
	jmp end_scan ; переход в конец кода
check3A:	
	tba
	ldaa #%00011000 ; вывод цифры "3"
	staa porta ; вывод цифры "3"
	staa start_number
	ldaa #%00100000 ; зажигаем третий диод
	staa portb ; зажигаем третий диод
	staa start_led
	jmp end_scan

check1B:
	ldaa porte ; загрузка состояния порта Е в акк. А
	anda #%0010 ; нажата ли кнопка во второй строке?
	beq	check1C ; переход, если не вторая строка
	tba
	anda #%0100 ; нажата ли кнопка в первом столбце?
	beq check2B ; переход, если нет
	ldaa #%00100000 ; вывод цифры "4"
	staa porta ; вывод цифры "4"
	staa start_number
	ldaa #%00010000 ; зажигаем четвертый диод
	staa portb ; зажигаем четвертый диод
	staa start_led
	jmp end_scan
check2B:	
	tba
	anda #%0010 ; нажата ли кнопка во втором столбце?
	beq check3B
	ldaa #%00101000 ; вывод цифры "5"
	staa porta ; вывод цифры "5"
	staa start_number
	ldaa #%00001000 ; зажигаем пятый диод
	staa portb ; зажигаем пятый диод
	staa start_led
	jmp end_scan
check3B:	
	tba
	ldaa #%00110000 ; вывод цифры "6"
	staa porta ; вывод цифры "6"
	staa start_number
	ldaa #%00000100 ; зажигаем шестой диод
	staa portb ; зажигаем шестой диод
	staa start_led
	jmp end_scan
	
check1C:
	ldaa porte ; загрузка состояния порта Е в акк. А
	anda #%0100 ; нажата ли кнопка в третьей строке?
	beq	check1D ; переход, если не третья строка
	tba
	anda #%0100 ; нажата ли кнопка в первом столбце?
	beq check2C ; переход, если нет
	ldaa #%00111000 ; вывод цифры "7"
	staa porta ; вывод цифры "7"
	staa start_number
	ldaa #%00000010 ; зажигаем седьмой диод
	staa portb ; зажигаем седьмой диод
	staa start_led
	jmp end_scan
check2C:	
	tba
	anda #%0010 ; нажата ли кнопка во втором столбце?
	beq check3C ; переход, если нет
	ldaa #%01000000 ; вывод цифры "8"
	staa porta ; вывод цифры "8"
	staa start_number
	ldaa #%00000001 ; зажигаем восьмой диод
	staa portb ; зажигаем восьмой диод
	staa start_led
	jmp end_scan
check3C:	
	jmp end_scan
	
check1D:
	ldaa porte ; загрузка состояния порта Е в акк. А
	anda #%1000 ; нажата ли кнопка в четвертой строке?
	beq	end_scan ; переход, если не четвертая строка
	tba
	anda #%0100 ; нажата ли кнопка в первом столбце?
	beq check2D ; переход, если нет
	ldaa start_led ; иначе проверяем инициализацию диода
	cmpa #%00000000
	bne start_left ; если диод инициализирован, то запускаем цикл
	jmp end_scan ; иначе продолжаем скан кнопок
check2D:	
	tba
	anda #%0010 ; нажата ли кнопка во втором столбце?
	beq check3D ; переход, если нет
	jmp end_scan
check3D:	
	tba
	ldaa start_led ; проверяем инициализацию диода
	cmpa #%00000000
	bne start_right ; если диод инициализирован, то запускаем цикл
	jmp end_scan ; иначе продолжаем скан кнопок
	
end_scan:
	aslb ; сдвиг регистра B влево
	jmp scan_keys ; переход в начало цикла сканирования
	
start_right:
	ldaa start_number
	ldab start_led
	bsr shift_right_loop
	bsr shift_left_loop
	bsr shift_left
	jmp end_show

start_left:
	ldaa start_number
	ldab start_led
	bsr shift_left_loop
	bsr shift_right_loop
	bsr shift_right
	jmp end_show

shift_right_loop:
	bsr	shift_right ; подпрограмма движения
	cmpb #%00000001 ; проверяем конец движения вправо
	bne shift_right_loop ; продолжаем движение, если не упёрлись
	rts ; иначе возвращаемся

shift_left_loop:
	bsr	shift_left ; подпрограмма движения
	cmpb #%10000000 ; проверяем конец движения влево
	bne shift_left_loop ; продолжаем движение, если не упёрлись
	rts ; иначе возвращаемся

shift_right:
	staa porta ; вывод цифры
	stab portb ; вывод диода
	bsr	delay
	ldaa start_number
	adda #%00001000 ; инкремент цифры
	staa start_number
	lsrb ; сдвиг вправо
	rts

shift_left:
	staa porta ; вывод цифры
	stab portb ; вывод диода
	bsr	delay
	ldaa start_number
	suba #%00001000 ; декремент цифры
	staa start_number
	lslb ; сдвиг влево
	rts

end_show:
	ldaa #%00000000 ; вывод цифры "0"
	staa porta ; вывод цифры "0"
	staa start_number
	ldaa #%00000000 ; выключаем диоды
	staa portb ; выключаем диоды
	staa start_led
	ldab col_count
	jmp scan_keys

delay:
	ldaa #3 ; 0,524sec*3=1.5sec
	staa timer
wait
	ldaa tlfg2
    anda #%10000000
    beq	wait	
	staa tlfg2
    ldaa timer        			
	deca
    staa timer
    bne	wait
    rts

	org $FFFE
	FDB	begin