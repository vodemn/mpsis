code	equ $F000
data	equ $0000
porta   equ $1000
portb	equ $1004
portc	equ $1003
porte	equ $100A
ddrc	equ	$1007 ; DDRC - ������� ��������� ����������� �������� ����� C:
tlfg2	equ	$1025
tmsk2	equ	$1024

* TODO
*--------------------------------------------
* ����� ������� ������� �� ��������� ��������
* ����� ���������� �� �������
*--------------------------------------------

	org	data
init_PC		fcb $87 ; 10000111b
col_count	fcb $01 ; 00000001b
timer  fcb 0
direction bsz 1
start_led bsz 1

	org	code
begin:
	ldaa init_PC ; ������������� ����� 0 - 2, 7 ����� C �� �����
	staa ddrc	 ; ��� ���������� � 0 - ������ ����� �������� �� ����, 1 - �� �����
	ldab col_count ; �������� � ������� B ���������� �������� �������� �������
	
scan_keys:
	cmpb #$08 ; ������������ ������� ����������: �������� �� ������������ �������
	bne check1A ; �������, ���� �������� B �� ����� $08
	ldab col_count ; ��������������� ���� ���� ������������

check1A:
	stab portc ; �������� ������� � ��������� �������, ���� �� ���� ������������ � ��������
	
	ldaa porte ; �������� ��������� ����� � � ���. �
	anda #%0001 ; ������ �� ������ � ������ ������?
	beq	check1B ; �������, ���� �� ������ ������
	tba ; ����������� ������� ������� � ������� A �� B
	anda #%0100 ; ������ �� ������ � ������ �������?
	beq check2A ; �������, ���� ���
	ldaa #%00001000 ; ����� ����� "1"
	staa porta ; ����� ����� "1"
	ldaa #%10000000 ; �������� ������ ����
	staa portb ; �������� ������ ����
	staa start_led ; ��������� ��������� �����
	jmp end_scan ; ������� � ����� ����. ��� ������� BRA ������ ������� ������� ������!
check2A:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3A ; �������, ���� ���
	ldaa #%00010000 ; ����� ����� "2"
	staa porta ; ����� ����� "2"
	ldaa #%01000000 ; �������� ������ ����
	staa portb ; �������� ������ ����
	staa start_led ; ��������� ��������� �����
	jmp end_scan ; ������� � ����� ����
check3A:	
	tba
	ldaa #%00011000 ; ����� ����� "3"
	staa porta ; ����� ����� "3"
	ldaa #%00100000 ; �������� ������ ����
	staa portb ; �������� ������ ����
	staa start_led ; ��������� ��������� �����
	jmp end_scan

check1B:
	ldaa porte ; �������� ��������� ����� � � ���. �
	anda #%0010 ; ������ �� ������ �� ������ ������?
	beq	check1C ; �������, ���� �� ������ ������
	tba
	anda #%0100 ; ������ �� ������ � ������ �������?
	beq check2B ; �������, ���� ���
	ldaa #%00100000 ; ����� ����� "4"
	staa porta ; ����� ����� "4"
	ldaa #%00010000 ; �������� ��������� ����
	staa portb ; �������� ��������� ����
	staa start_led ; ��������� ��������� �����
	jmp end_scan
check2B:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3B
	ldaa #%00101000 ; ����� ����� "5"
	staa porta ; ����� ����� "5"
	ldaa #%00001000 ; �������� ����� ����
	staa portb ; �������� ����� ����
	staa start_led ; ��������� ��������� �����
	jmp end_scan
check3B:	
	tba
	ldaa #%00110000 ; ����� ����� "6"
	staa porta ; ����� ����� "6"
	ldaa #%00000100 ; �������� ������ ����
	staa portb ; �������� ������ ����
	staa start_led ; ��������� ��������� �����
	jmp end_scan
	
check1C:
	ldaa porte ; �������� ��������� ����� � � ���. �
	anda #%0100 ; ������ �� ������ � ������� ������?
	beq	check1D ; �������, ���� �� ������ ������
	tba
	anda #%0100 ; ������ �� ������ � ������ �������?
	beq check2C ; �������, ���� ���
	ldaa #%00111000 ; ����� ����� "7"
	staa porta ; ����� ����� "7"
	ldaa #%00000010 ; �������� ������� ����
	staa portb ; �������� ������� ����
	staa start_led ; ��������� ��������� �����
	jmp end_scan
check2C:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3C ; �������, ���� ���
	ldaa #%01000000 ; ����� ����� "8"
	staa porta ; ����� ����� "8"
	ldaa #%00000001 ; �������� ������� ����
	staa portb ; �������� ������� ����
	staa start_led ; ��������� ��������� �����
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
	ldaa #01010000 ; ����� ����� "A"
	staa porta ; ����� ����� "A"

	ldaa #%10000000 ; ������ �������� �����
	staa portb ; ������ �������� �����
	
	jmp end_scan
check2D:	
	tba
	anda #%0010 ; ������ �� ������ �� ������ �������?
	beq check3D ; �������, ���� ���
	jmp end_scan
check3D:	
	tba
	ldaa #$01011000 ; ����� �������� "b"
	staa porta ; ����� �������� "b"
	
end_scan:
	aslb ; ����� �������� B �����
	jmp scan_keys ; ������� � ������ ����� ������������. ��� ������� BRA ������ ������� ������� ������!

loop:
	staa portb ; ���������� �������� ���. � � ���� B
	bsr	delay ; ������������ ��������
	incb ; ��������� �������� ���. B

	cmpb #15 ; ���������, ��� �������� ����������
	beq begin ; ������� � ������ ���������, ���� == 15
	cmpb #9 ; ����� ���������, ��� �������� �������� ������ ����������
	bhs shift_left ; ���� >= 9, �� ����� �����
	bra shift_right ; ����� ����� ������

to_right:
	ldaa start_led ; ��������� ��������� �����
	staa portb ; ������� �� �����
	bsr	delay ; ������������ ��������
	bra right_loop ; ���� ������ ������
	
	cmpa #%10000000 ; ���������, ��� �������� ����������
	beq begin ; ������� � ������ ���������, ���� ����������
	cmpb #%10000000 ; ����� ���������, ��� �������� �������� ������ ����������
	bhs shift_left ; ���� >= 9, �� ����� �����
	bra shift_right ; ����� ����� ������

right_loop:
	cmpa #%00000001 ; ���������, ��� �������� ������ �����������
	bne shift_right ; �����, ���� �������� ������ �� �����������
	rts ; ����� ������� � ����� ������

shift_right:
	lsra ; ����� �������� ���. � ������
	rts ; ������� � �����

shift_left:
	lsla ; ����� �������� ���. � �����
	rts ; ������� � �����

delay:
	ldaa tlfg2
    anda #%10000000
    beq	delay	
	staa tlfg2
    ldaa timer        			
	deca
    staa timer
    bne	delay
    rts

	org $FFFE
	FDB	begin