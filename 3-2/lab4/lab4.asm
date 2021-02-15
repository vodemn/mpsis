code	equ $F000
data	equ $0040
porta   equ $1000
portb	equ $1004
TFLG2	equ	$1025
TMSK2	equ	$1024

	org	data
letter	fcb	$67,$72,$6F,$75,$70,$20,$38,$35,$30,$37,$30,$32	; letters g,r,o,u,p, ,8,5,0,7,0,2
ltr_cnt	fcb $0C	; letters counter
cmd_clr	fcb	$01	; clear display
cmd_shl	fcb	$06	; entry mode set: the display does not shift, cursor moves to the right
cmd_set	fcb	$3F	; function set: 8 bits data length, 2 lines, 5 x 10 dots character font 
cmd_off	fcb $08
cmd_on	fcb $0E

	org	code
begin
*initialization part***
	lds #$00ff	; stack initialization
	clra	
	ldaa TMSK2	; timer setting 
	oraa #%00000000	; timer setting: divider set to 1
	staa TMSK2	; timer setting
*initialization part***
	
	clra
	bsr DELAY_UNIT	; jump to subroutine
	
*LCD settings***
	ldaa cmd_set
	bsr FALLING_EDGE
	
	bsr DELAY_UNIT	
	
	ldaa cmd_off
	bsr FALLING_EDGE
	
	bsr DELAY_UNIT	
	
	ldaa cmd_shl
	bsr FALLING_EDGE
	
	bsr DELAY_UNIT	
	
	ldaa cmd_on
	bsr FALLING_EDGE
*LCD settings***
	
	bsr DELAY_UNIT
	
*write letters form memory to LCD***
	ldx #letter
write_words
	ldaa 0,x
	bsr PUT_LETTER
	inx
	ldaa ltr_cnt
	deca
	staa ltr_cnt
	bgt write_words
*write letters form memory to LCD***
	
finish
	bra finish

*subroutines***
PUT_LETTER
	staa portb
	ldaa #$18	; set PA4 (LCD "E") to "1", PA3 (LCD "RS") to "1"
	staa porta
	bsr DELAY_UNIT	
	ldaa #$08	; set PA4 (LCD "E") to "0", PA3 (LCD "RS") to "1"
	staa porta
	rts	; back to the main program from the subroutine
	
FALLING_EDGE
	staa portb
	ldaa #$10	; set PA4 (LCD "E") to "1", PA3 (LCD "RS") to "0"
	staa porta
	bsr DELAY_UNIT	
	ldaa #$00	; set PA4 (LCD "E") to "0", PA3 (LCD "RS") to "0"
	staa porta
	rts
	
DELAY_UNIT:
counting
	ldab TFLG2	
	andb #%10000000	; overflow check (TOF)
	beq counting	; branch if 0
	stab TFLG2
	rts	; go back from subroutine
*subroutines***
	
	org	$FFFE
	FDB begin