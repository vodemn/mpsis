*-------------------------------------------------------------------
* ��������� ��������� �������� ��������� y = (x1*3 + x2*x3)/(x4 - 2)
* ��������� ������������ � ������ ������ result � ������� 0x0000
*-------------------------------------------------------------------

DataAddr EQU $0000 *����� ������ ������� ������
CodeAddr EQU $F000 *����� ������ ������� ���������

*������� ������  
	ORG  DataAddr
res	FDB 0
x1	FCB 2
x2	FCB 3
x3	FCB 2
x4	FDB 4
mem	FDB	0

*������� ���������
	ORG  CodeAddr
begin:
	ldaa x2 * ��������� � ������� A ��������� x2
	ldab x3 * ��������� � ������� B ��������� x3
	mul     * �������� x2 �� x3, ��������� ���������� � ������� D
	std mem	* ��������� ��������� � ������
	
	ldaa x1 * ��������� � ������� A ��������� x1
	ldab #3 * ��������� � ������� B ��������� 3
	mul     * �������� x1 �� 3, ��������� ���������� � ������� D
	addd mem * ��������� ��������� x2*x3 � 3*x1

	ldx x4  * ��������� � ������� X ��������� d
	dex
	dex
	idiv   * ������������� 16-��������� ������� D �� X  
	stx res * ������� ���������� � �������� X, ������� - � �������� D

*����� ��������� ����� ���������	
	ORG  $FFFE 
    FDB  begin
