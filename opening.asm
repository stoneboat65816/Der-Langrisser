arch snes.cpu
lorom

org $E10000	//$308000
	incbin "Font.smc"
org $E1A800
	incbin "Font2.smc"	
org $E1D000
	incbin "Font3.smc"
org $C0AF59
	incbin "smallfont.smc"
//width
org $C0B790
	db $06, $06

//Region
org $FFD9
	db $00
	
//Checksuom
org $FFDC
	dw $55CD
	dw $AA32
	
org $C18000
//	incbin "Command.smc"
	incbin "Command2.smc"
	
// This scenario has a forced arrangement.
org $03f39e
	 lda #$05
org $03f3a2 
	lda #$05
org $03f3a6
	lda #$16
org $03f392
	lda #$16
	
//#####################
//COMMAND
//#####################


	
//Bypass EOR text bank
org $40A873
	JML $E08100
	
org $E08100
	LDA $F9
	CMP #$E3
	BCS emu_A895
	CMP #$40
	BCC emu_A895
	JML $40A879
emu_A895:
	JML $40A895
	
//Bypass EOR scenario intro
org $40A8CB
	CMP #$E3

//Font 2 add	
org $40AABE
	LDA #$A800

//Font 3 add
org $40AAC7
	LDA #$CF80
	

	

//Font data


org $40ADCF
	LDA $E10000,x
org $40AE02
	LDA $E10001,x
org $40AE3E
	LDA $E10020,x
org $40AE71
	LDA $E10021,x
	
org $40ADA8	//width
	LDA $E00000,x
	
//Width table
org $E00000
	db $07, $07, $07, $07, $07, $07, $07, $08, $07, $04, $05, $07, $07, $08, $08, $08
	db $07, $08, $07, $05, $06, $07, $06, $08, $06, $07, $07, $06, $06, $06, $06, $06
	db $04, $06, $06, $04, $03, $06, $04, $08, $06, $06, $06, $06, $05, $05, $04, $06
	db $06, $08, $06, $06, $06, $06, $04, $06, $06, $06, $06, $06, $06, $06, $06, $07
	db $07, $06, $0C, $0D, $05, $0A, $06, $06, $0B, $06, $06, $05, $03, $06, $04, $0B
	db $08, $06, $06, $06, $06, $07, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $04, $06, $06, $06, $04, $04, $04
	db $04, $04, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $07, $07, $07, $07, $07, $06, $06
	db $06, $06, $07, $10, $0A, $0A, $0A, $0A, $0A, $0A, $08, $0C, $0A, $09
	
//Width 2 color
org $E0A800
	db $07, $07, $07, $07, $07, $07, $07, $08, $07, $04, $05, $07, $07, $08, $08, $08
	db $07, $08, $07, $05, $06, $07, $06, $08, $06, $07, $07, $06, $06, $06, $06, $06
	db $04, $06, $06, $04, $03, $06, $04, $08, $06, $06, $06, $06, $05, $05, $04, $06
	db $06, $08, $06, $06, $06, $06, $04, $06, $06, $06, $06, $06, $06, $06, $06, $07
	db $07, $06, $0C, $0D, $05, $0A, $06, $06, $0B, $06, $06, $05, $03, $06, $04, $0B
	db $08, $06, $06, $06, $06, $07, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $04, $06, $06, $06, $04, $04, $04
	db $04, $04, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $07, $07, $07, $07, $07, $06, $06
	db $06, $06, $07, $10, $0A, $0A, $0A, $0A, $0A, $0A, $08, $0C, $0A, $09
	
	
//Character order
org $40AD96
	LDA $FFFF00,x
	
org $FFFF00
	db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0A, $0B, $0C, $0D, $0E, $0F
	db $10, $11, $12, $13, $14, $15, $16, $17, $18, $19, $1A, $1B, $1C, $1D, $1E, $1F
	db $20, $21, $22, $23, $24, $25, $26, $27, $28, $29, $2A, $2B, $2C, $2D, $50, $51
	db $52, $53, $54, $55, $56, $57, $58, $59, $5A, $5B, $5C, $5D, $5E, $5F, $60
	db $61, $62, $63, $64, $65, $66, $67, $68, $3F, $40, $41, $42, $43, $2E, $2F, $30
	db $31, $32, $33, $34, $00, $69, $6A, $6B, $6C, $35, $36, $37, $38, $39, $3A, $3B
	db $3C, $3D, $3E, $44, $45, $46, $47, $48, $49, $4A, $4B, $4C, $4D, $4E, $4F, $6D
	db $6E, $6F, $70, $71, $72, $73, $74, $75, $76, $00, $00, $77, $78, $79, $7A, $7B
	db $7C, $7D, $7E, $7F, $80, $81, $82, $83, $00, $00, $00, $00, $00, $00, $84, $85
	db $86, $87, $88, $89, $8A, $8B, $8C, $00, $8D, $8E, $8F, $90, $91, $92, $93, $94
	db $95, $96, $97, $98, $99, $9A, $9B, $9C, $9D
	
//Width 3

org $E0CF80
	db $04, $07, $07, $07, $07, $07, $07, $08, $07, $04, $05, $07, $07, $08, $08, $08
	db $07, $08, $07, $05, $06, $07, $06, $08, $06, $07, $07, $06, $06, $06, $06, $06
	db $04, $06, $06, $04, $03, $06, $04, $08, $06, $06, $06, $06, $05, $05, $04, $06
	db $06, $08, $06, $06, $06, $06, $04, $06, $06, $06, $06, $06, $06, $06, $06, $07
	db $07, $06, $0C, $0F, $05, $0A, $06, $06, $0B, $06, $06, $05, $03, $06, $04, $0B
	db $08, $06, $06, $06, $06, $07, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $04, $04, $04
	db $04, $04, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06, $06
	db $06, $06, $06, $06, $06, $06, $06, $06, $06, $07, $07, $07, $07, $07, $06, $06
	db $06, $06, $07, $10, $0A, $0A, $0A, $0A, $0A, $0A, $08, $0C, $0A, $09
	
//Load command text
//org $00ABB9
//	LDA #$A2
//org $00ABB2
//	ADC #$D000


// Yes/No
//org $03ba7f : lda #$0e
//org $03ba83 : lda #$08
//org $03ba87 : lda #$06
//org $03ba73 : lda #$06

org $03BA87
	LDA #$07
org $03BA73
	LDA #$07

// Yes/No
//org $07db7d : ldx #$02
//org $07db7f : ldy #$0b
//org $07db85 : lda #$06
//org $07db48 : lda #$06

org $07DB85
	LDA #$07
org $07DB48
	LDA #$07


//Yes/No ("Unable to equip, will you still purchase this?")
//org $03f2b4 : lda #$15
//org $03f2b8 : lda #$0b
//org $03f2bc : lda #$06
//org $03f2a8 : lda #$06

org $03F2BC
	LDA #$07
org $03F2A8
	LDA #$07
	
//Saved window

org $03bb5b
	 lda #$07
org $03bb47
	 lda #$07
	 
  //---Enemy Phase Window-------------------
org $03c2e0 
	lda #$0C   //x position
org $03c2e4 
	lda #$0b   //y position
org $03c2e8 
	lda #$09   //width
org $03c2d4
	 lda #$09   //width
	 
	 
//press a button on char menu vram pos
//frame pos
org $0386B4
	LDA #$01
	
//frame width
org $83869D
	LDA #$0A
org $8386BC
	LDA #$0A
	
//commander summary frame pos
org $038571
	LDA #$0C
	
//avatar pos
org $385CD
	LDA #$0B
	
org $40A313
	LDA $FF0000,x
//	LDA $400000,x
	
//sentou shirei menu width
org $387EA
	LDA #$06
org $38808
	LDA #$06
//sentou shirei menu y pos
org $038804
	LDA #$0C
//sentou sirei menu x pos
org $038800
	LDA #$07
	
//Main command
org $40A2BE
	LDA $08    
	CMP #$829A
	BNE $06
	LDA #(s_move)
	JMP $A30A
	CMP #$829E
	BNE $06
	LDA #(s_attack)
	JMP $A30A
	CMP #$82A2
	BNE $06
	LDA #(s_magic)
	JMP $A30A
	CMP #$82A6
	BNE $06
	LDA #(s_summon)
	JMP $A30A
	CMP #$82AA
	BNE $06
	LDA #(s_heal)
	JMP $A30A
	CMP #$82AE
	BNE $06
	LDA #(s_orders)
	JMP $A30A
	LDA [$08]
	STA [$02]
	
//sentou shirei
org $C0A45C
 w_orders:
	 dw $0025,$0026, $0027, $fffe   //Battle
	 dw $0028,$0029,$002A, $fffe //Assault
	 dw $002B,$002C, $fffe //Defend
	 dw $002D,$002E,$002F, $fffe //Manual
	 dw $ffff
	 
//windows options
org $C0A533
w_turn:
 	dw $0007,$0008,$0009,$ffff  //Turn

 dw $003f,$0040,$0041,$0042,$0043,$0044,$0045,$0046   //Game Speed
 dw $0000,$005A,$005B,$005C,$005D,$005E               //Fast
 dw $0000,$005F,$0060,$0061,$0062,$0063,$0000         //Normal
 dw $0000,$0000,$0000

 
	 dw $0047,$0048,$0049,$004a,$004b,$0000,$0000,$0000   //Windows
	 dw $0000,$0076,$0077,$0078,$0079,$0000               //Remix
	 dw $0000,$007a,$007b,$007c,$007d,$007e,$0000         //Classic
	 dw $0000,$0000,$0000
	 
	 dw $004c,$004d,$004e,$004f,$0050,$0051,$0052,$0000   //Sound Mode
	 dw $0000,$0064,$0065,$0066,$0000,$0000               //Stereo
	 dw $0000,$0068,$0069,$006a,$006b,$006c,$006d         //Monoraul
	 dw $0000,$0000,$0000

	 dw $0053,$0054,$0055,$0056,$0057,$0058,$0059,$0000   //Battles
	 dw $0000,$006e,$006f,$0070,$0071,$0072               //Display
	 dw $0000,$0073,$0074,$0075                           //Skip
	 dw $0000,$0000,$0000
	 dw $ffff
	
org $FF9000
s_move:
	 db $00,$01,$02,$03, $04, $05, $ff        //Move
s_attack:
 	db $06,$07,$08,$09,$0A, $0B, $0C, $ff    //Attack
s_magic:
 	db $0D,$0E,$0F,$10, $11, $12, $ff        //Magic
s_summon:
 	db $13,$14,$15,$16,$17,$18, $19, $ff//Summon
s_heal:
 	db $1A,$1B,$1C,$1D, $1E, $ff    //Health
s_orders:
 	db $1F,$20,$21,$22,$23, $24, $ff    //Orders
 	
 fix_avatar_06:
 	LDA [$02],y
 	BNE emu_a405
 	LDA $1D88
 	JML $07A3F0
 	
 emu_a405:
 	CMP #$36
 	BEQ check_scenario_06
 -
 	JML $07A405
 	
 check_scenario_06:
 	PHA
 	LDA $7E1A00
 	CMP #$06
 	BEQ check_vargas
 	PLA
 	BRA -
 	
 check_vargas:
  	LDA $02
 	CMP #$72
 	BEQ right_avatar_06
 	PLA
 	BRA -
 	
right_avatar_06:
	PLA
	LDA #$01
	BRA -
 	

//Fix wrong avatar scenario 6
org $07A3E9
	JML fix_avatar_06
	
