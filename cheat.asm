arch snes.cpu
lorom

//Control any unit

org $03864A
	db $80, $2D
	
//Attack any tile
org $0E1AB
	db $80, $12
	
//Cast on any tile
org $E3B6
	db $00
org $E3BB
	db $80
	
//Move to any tile 
org $D539
	db $80
	
//Troops can Cast 
	org $38BA9
	db $00
	
//Enable all magic
	org $38BC9
		db $00
	org $39214
		db $00
	
//Cast costs 0MP
	org $393DC
		db $00
//Summon costs 0MP
	org $399A1
		db $00
		
//Load bonus exp after each scenario
org $00CC65
	LDA $07809B,x	//a8
	STA $1B
	
org $00CCA2
	LDA ($02),y		//char exp adr
	CLC
	ADC $1B
	BCC store
load:
	LDA #$FF
store:
	STA ($02),y
	
org $01CBD0
	CMP #$0A		
	
//infinity exp
org $01CC02
	LDA [$02],y
	SBC #$00	//sbc $1b
	
//##############
// DAMAGE hack
//###############


	
org $80DA15
	BRA $02

//#########
// In stage EXP
//########
	org $008CE4	//read pad
	JML pad
	
//########
// Powerful magic
//#####
org $01A0E8
	JML magic
	
org $87B600
pad:
	REP #$20
	LDA $B6
	CMP #$2020	//Select + L
	BNE +
	SEP #$20
	LDA $7EB02F //exp
	CLC
	ADC #$64
	STA $7EB02F
	BRA end
+
	LDA $B6
	CMP #$2010		//select + R
	BNE +
	SEP #$20
	LDA #$23
	STA $7EB038 //mp
	BRA end
+
	LDA $B6
	CMP #$2040 //select + X
	BNE +
	SEP #$20
	LDA #$0D //holy rod
	STA $7EB009
	BRA end
+
end:
	SEP #$20
	LDA $4218
	STA $B6
	JML $008CE9
	
	
magic:
	LDA #$FF
	LDY #$03
	CMP [$0B],y
	JML $01A0EC
	


	

	

	


	
















