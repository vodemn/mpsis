code	equ $F000
data	equ $0000
porta   equ $1000
portb	equ $1004
portc	equ $1003
porte	equ $100A
ddrc	equ	$1007 ; DDRC - ������� ��������� ����������� �������� ����� C:
tlfg2	equ	$1025
tmsk2	equ	$1024

	org	data
init_PC		fcb $87 ; 10000111b
col_count	fcb $01 ; 00000001b
timer  fcb 0
start_led bsz 1
start_number bsz 1
direction bsz 1

	org	code
begin:
	lds #$000F
	ldaa #%00000011
	staa tmsk2	; ��������� ������������ ������� ������� �������
	ldaa init_PC ; ������������� ����� 0 - 2, 7 ����� C �� �����
	staa ddrc	 ; ��� ���������� � 0 - �� ����, 1 - �� �����
	ldab col_count ; �������� ���������� �������� �������� �������

init:
	ldaa #%10000000
	staa start_led
	ldaa #%00000001
	staa direction
	staa start_number
scan_button:
    ldaa porta ; ��������� �������� � ����� A � ���. A
	anda #%00000001 ; ���������, ������ �� ������
	beq scan_keys ; ���� �� ������, �� ��������� ����������
	jmp check_button ; ����� ��������� ����
	
scan_keys:
	cmpb #%08 ; �������� �� ������������ �������
	bne check1A ; �������, ���� �������� B �� ����� $08
	ldab col_count ; ��������������� ���� ���� ������������

check1A:
	stab portc ; �������� �������, ���� �� ���� ������������ � ��������
	
	ldaa porte ; �������� ��������� ����� � � ���. �
	anda #%0001 ; ������ �� ������ � ������ ������?
	beq	check1B ; �������, ���� �� ������ ������
	tba ; ����������� ������� ������� � ������� A �� B
	anda #%0100 ; ������ �� ������ � ������ �������?
	beq check2A ; �������, ���� ���
	ldaa #%00001000 ; ��������� ����� "2"
	staa start_number
	ldaa #%10000000 ; ��������� ������ ����
	staa start_led
	jmp end_scan ; ������� � ����� ����
check2A:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3A ; �������, ���� ���
	ldaa #%00010000 ; ��������� ����� "2"
	staa start_number
	ldaa #%01000000 ; ��������� ������ ����
	staa start_led
	jmp end_scan ; ������� � ����� ����
check3A:	
	tba
	ldaa #%00011000 ; ��������� ����� "3"
	staa start_number
	ldaa #%00100000 ; ��������� ������ ����
	staa start_led
	jmp end_scan

check1B:
	ldaa porte ; �������� ��������� ����� � � ���. �
	anda #%0010 ; ������ �� ������ �� ������ ������?
	beq	check1C ; �������, ���� �� ������ ������
	tba
	anda #%0100 ; ������ �� ������ � ������ �������?
	beq check2B ; �������, ���� ���
	ldaa #%00100000 ; ��������� ����� "4"
	staa start_number
	ldaa #%00010000 ; ��������� ��������� ����
	staa start_led
	jmp end_scan
check2B:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3B
	ldaa #%00101000 ; ��������� ����� "5"
	staa start_number
	ldaa #%00001000 ; ��������� ����� ����
	staa start_led
	jmp end_scan
check3B:	
	tba
	ldaa #%00110000 ; ��������� ����� "6"
	staa start_number
	ldaa #%00000100 ; ��������� ������ ����
	staa start_led
	jmp end_scan
	
check1C:
	ldaa porte ; �������� ��������� ����� � � ���. �
	anda #%0100 ; ������ �� ������ � ������� ������?
	beq	check1D ; �������, ���� �� ������ ������
	tba
	anda #%0100 ; ������ �� ������ � ������ �������?
	beq check2C ; �������, ���� ���
	ldaa #%00111000 ; ��������� ����� "7"
	staa start_number
	ldaa #%00000010 ; ��������� ������� ����
	staa start_led
	jmp end_scan
check2C:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3C ; �������, ���� ���
	ldaa #%01000000 ; ��������� ����� "8"
	staa start_number
	ldaa #%00000001 ; ��������� ������� ����
	staa start_led
	jmp end_scan
check3C:	
	jmp end_scan
	
check1D:
	ldaa porte ; �������� ��������� ����� � � ���. �
	anda #%1000 ; ������ �� ������ � ��������� ������?
	beq	end_scan ; �������, ���� �� ��������� ������
	tba
	anda #%0100 ; ������ �� ������ � ������ �������?
	beq check2D ; �������, ���� ���
	ldaa #%10000000 ; ����� ������ ����������� �����
	staa direction
	jmp end_scan ; ���������� ���� ������
check2D:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3D ; �������, ���� ���
	jmp end_scan
check3D:	
	tba
	ldaa #%00000001 ; ������ ����������� ������
	staa direction
	jmp end_scan ; ���������� ���� ������
	
end_scan:
	aslb ; ����� �������� B �����
	jmp scan_button ; ������� � ������ ����� ������������

check_button:
	bsr	show ; ����� ���������
    ldaa porta ; ��������� �������� � ����� A � ���. A
	anda #%00000001 ; ���������, ������ �� ������
	bne loop ; ���� ������, �� ��������� ����
	ldaa #%00000000 ; ��������� ����� "0"
	staa porta ; ��������� ����� "0"
	staa start_number
	ldaa #%00000000 ; ��������� �����
	staa portb ; ��������� �����
	staa start_led
	ldab col_count
	jmp init

loop:
	ldaa start_led ; ��������� �� ������ ����
	cmpa #%00000001 ; ��������� ����� �������� ������
	beq set_left ; ������, ���� �������
	cmpa #%10000000 ; ����� ��������� ����� �������� �����
	beq set_right ; ������, ���� �������
loop_next:
	ldaa direction ; ��������� �� ������ �����������
	cmpa #%00000001 ; ��������� ����������� ������
	beq shift_right ; ���� ������, �� ��� ������
	bra shift_left ; ����� ��� �����

set_right:
	ldaa #%00000001 ; ������ ����������� ������
	staa direction
	bra loop_next
set_left:
	ldaa #%10000000 ; ������ ����������� �����
	staa direction
	bra loop_next

shift_right:
	ldaa start_number
	adda #%00001000 ; ��������� �����
	lsrb ; ����� ������
	bsr save_state ; ��������� ���������
	bra check_button ; ������� � �������� ������

shift_left:
	ldaa start_number
	suba #%00001000 ; ��������� �����
	lslb ; ����� �����
	bsr save_state ; ��������� ���������
	bra check_button ; ������� � �������� ������

save_state:
	staa start_number ; ��������� �����
	stab start_led ; ��������� ����
	rts

show:
	ldaa start_number ; ��������� �� ������ �����
	ldab start_led ; ��������� �� ������ ����
	staa porta ; ������� �����
	stab portb ; ������� ����
	bsr	delay
	rts

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