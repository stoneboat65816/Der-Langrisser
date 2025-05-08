arch snes.cpu
lorom


//##################
//	DEFINE
//#################
define SCMD_NONE				$00
define SCMD_INITIALIZE			$01
define SCMD_LOAD				$02
define SCMD_STEREO				$03
define SCMD_GLOBAL_VOLUME		$04
define SCMD_CHANNEL_VOLUME		$05
define SCMD_MUSIC_PLAY 		$06
define SCMD_MUSIC_STOP 		$07
define SCMD_MUSIC_PAUSE 		$08
define SCMD_SFX_PLAY			$09
define SCMD_STOP_ALL_SOUNDS	$0a
define SCMD_STREAM_START		$0b
define SCMD_STREAM_STOP		$0c
define SCMD_STREAM_SEND		$0d
define	gss_param		$64		//16
define	gss_command  $66		//16
define	sound_ptrl		$61
define	sound_ptrh		$63		//8 bit
//###########################


//bypass opening naming check
org $409861
	LDA $008022
	CMP #$FE80  //CMP #$4080
//bypass x2 check
org $409A78
	LDA $808022
	CMP #$FE80

	

org $008020
	JML newcode




org $FE8000
newcode:
	SEI
	REP #$09
	CLC
	XCE
first_scr:
	JSR format
	REP #$10
	SEP #$20
	LDX #$1FFF
	TXS
	
//##################
//  SPC LOAD
//###################
//	LDX #$00FF
//	PHX
//	LDX #$A000
//	PHX
//	LDX #$564A	//size
//	PHX
//	LDX #$0200
//	PHX
//	JSL spc_load_data
//	PLX
//	PLX
//	PLX
//	PLX

	LDX #(spc_data)
	STX {sound_ptrl}
	SEP #$20
	LDX #(spc_data>>16)
	TXA
	STA {sound_ptrh}
	JSL UploadDataToSPC
	
	LDX #$0001
	PHX
	JSL spc_stereo
	PLX
	
	LDX #$0000
	PHX
	LDX #$0001	//init
	PHX
	JSL spc_command
	PLX
	PLX
	
	SEP #$20
	JSR register
	JSR wait_vblank
	LDX #$0000
	STX $2116

//################
// DMA INTRO MAP
//#################
	LDX #(intro_map>>16)
	TXA
	LDX #(intro_map)
	LDY #$0800
	JSR dma
	

	
//#################
// DMA COLOR
//##################
	
	LDA #$00
	STA $2121
	LDX #(intro_col>>16)
	TXA
	LDX #(intro_col)
	LDY #$0200
	JSR dma_pal

//######################
// DMA INTRO SET
//#####################
	
	JSR wait_vblank

	LDX #$1000
	STX $2116
	LDX #(intro_set>>16)
	TXA	
	LDX #(intro_set)
	LDY #$7B80
	JSR dma
	
//######################	
// SCREEN ON
//#####################
	JSR scr_on
	CLI
	
	LDX #$0080	//pan
	PHX
	LDX #$007E	//sfx volume
	PHX
	LDX #$0000 //sfx number
	PHX
	LDX #$0007	//channel
	PHX
	JSL sfx_play
	PLX
	PLX
	PLX
	PLX
	
	LDX #$000F
-
	JSR delay
	DEX
	BNE -
	JSR fade
	
	JSR format
	REP #$10
	SEP #$20	
	JSR register
	JSR wait_vblank
	LDX #$0000
	STX $2116

//################
// DMA baldea MAP
//#################
	LDX #(baldea_map>>16)
	TXA
	LDX #(baldea_map)
	LDY #$0800
	JSR dma
	

	
//#################
// DMA COLOR
//##################
	
	LDA #$00
	STA $2121
	LDX #(baldea_col>>16)
	TXA
	LDX #(baldea_col)
	LDY #$0200
	JSR dma_pal

//######################
// DMA baldea SET
//#####################
	

	JSR wait_vblank
	LDX #$1000
	STX $2116
	LDX #(baldea1_set>>16)
	TXA	
	LDX #(baldea1_set)
	LDY #$8000
	JSR dma
	

	JSR wait_vblank
	LDX #$5000
	STX $2116
	LDX #(baldea2_set>>16)
	TXA	
	LDX #(baldea2_set)
	LDY #$4A40
	JSR dma	

	
//######################	
// SCREEN ON
//#####################
	JSR scr_on
	CLI

	LDX #$000F
-
	JSR delay
	DEX
	BNE -
	JSR fade
	JSR format
	
	LDX #$0000
	PHX
	LDX #$0002	//Load
	PHX
	JSL spc_command
	PLX
	PLX
	
	JSL reset_sound_driver
	
return_to_main:
	CLD
	SEI
	CLC
	XCE
	JML $008024
	
//########################
// DMA ROUTINE
//#######################
dma:
	PHP
	PHX
	PHY
	PHA
	
	SEP #$20
	REP #$10
	
	STX $4302
	STA $4304
	STY $4305
	
	LDA #$18
	STA $4301
	LDA #$01
	STA $4300
	LDA #$01
	STA $420B
	
	PLA
	PLY
	PLX
	PLP
	RTS
//#####################
// DMA PAL
//###################
dma_pal:
	PHP
	PHX
	PHY
	PHA
	
	REP #$10
	SEP #$20
	
	STX $4302
	STA $4304
	STY $4305
	
	LDA #$22
	STA $4301
	LDA #$00
	STA $4300
	LDA #$01
	STA $420B
	
	PLA
	PLY
	PLX
	PLP
	RTS	

//#########################
// WAIT VBLANK
//##########################

wait_vblank:
	PHP
	SEP #$20
	PHA
wait:
	LDA $4210
	AND #$80
	BEQ wait
	PLA
	PLP
	RTS
	
//################
// CHECK VBLANK
//################
check_v:
	LDA $4212
	AND #$80
	BEQ check_v
	RTS
	
//####################
// DELAY
//##################

delay:
	LDY #$FFFF
-
	DEY
	BNE -
	RTS
	

//####################
// INIT routine
//##################
format:
	SEP #$30
	LDA #$00
	PHA
	PLB
	LDA #$80
	STA $2100
	LDA #$00
	STA $2101
	STA $2102
	STA $2103
	STA $2105
	STA $2106
	STA $2107
	STA $2108
	STA $2109
	STA $210A
	STA $210B
	STA $210C
	STA $210D
	STA $210D
	STA $210E
	STA $210E
	STA $210F
	STA $210F
	STA $2110
	STA $2110
	STA $2111
	STA $2111
	STA $2112
	STA $2112
	STA $2113
	STA $2113
	STA $2114
	STA $2114


	LDA #$80
	STA $2115
	
	LDA #$00
	STA $2116
	STA $2117
	STA $211A
	STA $211B
	LDA #$01
	STA $211B
	LDA #$00
	STA $211C
	STA $211C
	STA $211D
	STA $211D
	STA $211E
	LDA #$01
	STA $211E
	LDA #$00
	STA $211F
	STA $211F
	STA $2120
	STA $2120
	STA $2121
	STA $2123
	STA $2124
	STA $2125
	STA $2126
	STA $2127
	STA $2128
	STA $2129
	STA $212A
	STA $212B
	LDA #$01
	STA $212C
	LDA #$00
	STA $212D
	STA $212E
	STA $212F
	LDA #$30
	STA $2130
	LDA #$00
	STA $2131
	LDA #$E0
	STA $2132
	LDA #$00
	STA $2133
	LDA #$01	//auto read joyINTROs

	STA $4200
	LDA #$FF
	STA $4201
	LDA #$00
	STA $4202
	STA $4203
	STA $4204
	STA $4205
	STA $4206
	STA $4207
	STA $4208
	STA $4209
	STA $420A
	STA $420B
	STA $420C
	STA $420D
	REP #$30
		LDY #$0000
		STY $2116
		LDA #$0000
	fill_vram:	
		STA $2118
		INY
		STY $2116
		CPY #$8000
		BNE fill_vram
	RTS	
	
//################
// REGISTER
//################

register:
	PHP
	SEP #$20
	LDA #$03		//BG mode 3
	STA $2105
	LDA #$01		//BG enable
	STA $212C	
	LDA #$00	//Tile map
	STA $2107
	LDA #$01
	STA $210B	//Tile set
	PLP
	RTS
	
//###############
//	SCR  ON
//##############

scr_on:	
	LDA #$01
akari:
	STA $2100
	INA
	JSR delay
	CMP #$10
	BCC akari
	RTS
	
fade:
	PHA
	LDA #$0F
-
	STA $2100
	JSR delay
	DEC
	BNE -
	PLA
	RTS
	
spc_load_data:
	PHP
	REP #$30
	SEI
	SEP #$20
	LDA #$AA
-
	CMP $2140
	BNE -
	
	REP #$20
	LDA $0B,s		//source adr high
	STA $02
	LDA $09,s			//source adr low
	STA $00
	LDA $07,s			//size
	TAX
	LDA $05,s		//adr
	STA $2142
	
	SEP #$20
	LDA #$01
	STA $2141
	LDA #$CC
	STA $2140
-
	CMP $2140
	BNE -
	LDY #$0000
_load_loop0:
	XBA
	LDA [$00],y
	XBA
	TYA
	
	REP #$20
	STA $2140
	SEP #$20
-
	CMP $2140
	BNE -
	INY
	DEX
	BNE _load_loop0
	XBA
	LDA #$00
	XBA
	CLC
	ADC #$02
	REP #$20
	TAX
	LDA #$0200		//code start string
	STA $2142
	TXA
	STA $2140
	SEP #$20
-	
	CMP $2140
	BNE -
	REP #$20
-
	LDA $2140
	ORA $2142
	BNE -
	CLI
	PLP
	RTL
	
spc_command_asm:
	SEP #$20
ngc:
	LDA $2140
	BNE ngc
	REP #$20
	LDA {gss_param}
	STA $2142
	LDA {gss_command}
	SEP #$20
	XBA
	STA $2141
	XBA
	STA $2140
	CMP #{SCMD_LOAD}
	BEQ endcmd
ngc2:
	LDA $2140
	BEQ ngc2
endcmd:
	RTS
	
sound_stop_all:
	PHP
	REP #$30
	LDA #({SCMD_STOP_ALL_SOUNDS})
	STA {gss_command}
	STZ {gss_param}
	JSR spc_command_asm
	PLP
	RTL
	
global_volume:
	PHP
	REP #$30
	LDA $07,s
	XBA
	AND #$FF00
	STA {gss_param}
	LDA $05,s
	AND #$00FF
	ORA {gss_param}
	STA {gss_param}
	LDA #({SCMD_GLOBAL_VOLUME})
	STA {gss_command}
	JSR spc_command_asm
	PLP
	RTL
	
spc_command:
	PHP
	REP #$30
	LDA $07,s
	STA {gss_param}
	LDA $05,s			
	STA  {gss_command}
	JSR spc_command_asm
	PLP
	RTL
	
spc_stereo:
	PHP
	REP #$30
	LDA $05,s
	STA {gss_param}
	LDA #({SCMD_STEREO})
	STA {gss_command}
	JSR spc_command_asm
	PLP
	RTL
	
spc_channel_volume:
	PHP
	REP #$30
	LDA $05,s			//channel channels
	XBA
	AND #$FF00
	STA {gss_param}
	LDA $07,s		//volume
	AND #$00FF
	ORA {gss_param}
	STA {gss_param}
	LDA #({SCMD_CHANNEL_VOLUME})
	STA {gss_command}	
	JSR spc_command_asm
	PLP
	RTL
	
music_stop:
	PHP
	REP #$30
	LDA #({SCMD_MUSIC_STOP})
	STA {gss_command}
	STZ {gss_param}
	JSR spc_command_asm
	PLP
	RTL
	
music_pause:
	PHP
	REP #$30
	LDA $05,s			//pause
	STA {gss_param}
	LDA #({SCMD_MUSIC_PAUSE})
	STA {gss_command}
	JSR spc_command_asm
	PLP
	RTL
	
sound_stop_all:
	PHP
	REP #$30
	LDA #({SCMD_STOP_ALL_SOUNDS})
	STA {gss_command}
	STZ {gss_param}
	JSR spc_command_asm
	PLP
	RTL

sfx_play:
	PHP
	REP #$30
	LDA $11,s			//pan
	BPL +
	LDA #$0000
+
	CMP #$00FF
	BCC +
	LDA #$00FF
+
	XBA
	AND #$FF00
	STA {gss_param}
	
	LDA $07,s				//sfx number
	AND #$00FF
	ORA {gss_param}
	STA {gss_param}

	LDA $09,s			//volume
	XBA
	AND #$FF00
	STA {gss_command}

	LDA $05,s			//chn
	ASL
	ASL 
	ASL 
	ASL 
	AND #$00F0
	ORA #({SCMD_SFX_PLAY})
	ORA {gss_command}
	STA {gss_command}
	JSR spc_command_asm
	PLP
	RTL
			

spc_load_data:

	PHP
	REP #$30
	SEI
	SEP #$20
	LDA #$AA
-
	CMP $2140
	BNE -
	REP #$20
	LDA $0B,s				//srch
	STA {sound_ptrh}
	LDA $09,s					//srcl
	STA {sound_ptrl}
	LDA $07,s					//size
	TAX
	LDA $05,s					//adr
	STA $2142
	SEP #$20
	LDA #$01
	STA $2141
	LDA #$CC
	STA $2140
-
	CMP $2140
	bne -
	LDY #$0000

_load_loop:
	XBA
	LDA [{sound_ptrl}],y
	XBA
	TYA
	
	REP #$20
	STA $2140
	SEP #$20
-
	CMP $2140
	BNE -	
	INY
	DEX
	BNE _load_loop
	XBA
    	LDA #$00
    	XBA
	CLC
	ADC #$02
	REP #$20
	TAX
	LDA #$0200			//loaded code starting address
	STA $2142
	TXA
	STA $2140
	SEP #$20
-
	CMP $2140
	BNE -
	REP #$20
-
	LDA $2140			//wait until SPC700 clears all communication ports, confirming that code has started
	ORA $2142
	BNE -
	
	CLI					//enable IRQ
	PLP
	RTL	
	
reset_sound_driver:
	PHA
	PHX
	PHP
	SEP #$20
	LDX #(ipl_rom)
	STX {sound_ptrl}
	LDX #(ipl_rom>>16)
	TXA
	STA {sound_ptrh}
	JSL UploadDataToSPC
	PLP
	PLX
	PLA
	RTL
	
UploadDataToSPC:
	SEP #$20
	LDA #$FF		// Get SPC ready for upload
	STA $2141		
	SEI			// Disable interrupts
	STZ $4200		// Disable NMI *NOT part of original code*
	JSR SPC700UploadLoop
	LDA #$01
	STA $4200		// Reenable NMI *NOT part of original code*
	REP #$20	
	CLI			// Reenable interrupts
	RTL


SPC700UploadLoop:
	PHP
	REP #$30		// 16-bit A & X/Y
	LDY #$0000
	LDA #$BBAA		// 0xBBAA is what $2140-41 will contain when
WaitForSPCEcho1:			// the SPC is ready
	CMP $2140		// Keep looping until it is ready
	BNE WaitForSPCEcho1	// 
	
	SEP #$20		// 8-bit A
	LDA #$CC		// 0xCC is what we send to the SPC to tell it we're ready
	BRA GetLengthADDR
GetDataBytes:
	LDA [{sound_ptrl}],y		// Put our first data byte in the high byte of the
	INY			// accumulator, and 0x00 in the low byte
	XBA
	LDA #$00
	BRA StoreByte

GetDataBytes2:
	XBA
	LDA [{sound_ptrl}],y
	INY
	XBA
WaitForSPCEcho2:
	CMP $2140
	BNE WaitForSPCEcho2
	INC 
StoreByte:
	REP #$20                // Accum (16 bit) 
	STA $2140		
	SEP #$20		// Accum (8 bit)
	DEX			// decrement LENGTH
	BNE GetDataBytes2
WaitForSPCEcho3:
	CMP $2140
	BNE WaitForSPCEcho3
Add3:
	ADC #$03		// prevent our index count from being 0
	BEQ Add3		
		
GetLengthADDR:
	PHA			
	REP #$20		// 16-bit A
	LDA [{sound_ptrl}],y		// Get data block length. 
	INY
	INY			// Y+2, point to next word in table
	TAX			// LENGTH goes into X
	LDA [{sound_ptrl}],y		// Get target address. 
	INY			// Y+2, point to next word in table
	INY
	STA $2142		// Send address to APU port 2&3
	SEP #$20
	CPX #$0001		// Roll the carry flag from the operation CPX #$0001 
	LDA #$00		// into bit 0 of A. in other words, if X is nonzero,
	ROL			// load A with 0x01. otherwise A=0x00
	STA $2141		// Send it to APU port 1
	ADC #$7F		// If A = 1, overflow flag will be set here
	PLA			//
	STA $2140		// Store either 0xCC to APU port 0, signaling that we are ready to transfer, or our nonzero index count
WaitForSPCEcho0:
	CMP $2140		// Wait for the SPC to echo the value we've sent
	BNE WaitForSPCEcho0
	BVS GetDataBytes	// If the overflow flag was set earlier, branch, there 
			// is more data to send. 
	STZ $2140		// Otherwise, finish up SPC transfer
	STZ $2141
	STZ $2142
	STZ $2143
	PLP
Return:	
	RTS	

	
	
intro_map:
	incbin "intro.map"
intro_col:
	incbin "intro.col"
	
org $FF8000
baldea_map:
	incbin "baldea.map"
baldea_col:
	incbin "baldea.col"	


	
	
org $FA8000
intro_set:
	incbin "intro.set"

org $FB8000
baldea1_set:
	incbin "baldea1.set"
	
org $FC8000
baldea2_set:
	incbin "baldea2.set"
	
org $FFA000
spc_data:
	dw $564A, $0200
	incbin "spc700.bin"
	dw $0000, $0200
	
ipl_rom:
	db $3C, $00, $00, $02
	db $CD, $EF, $BD, $E8, $00, $C6, $1D, $D0, $FC, $8F, $AA, $F4, $8F, $BB, $F5, $78, $CC, $F4, $D0, $FB, $2F, $19, $EB, $F4, $D0, $FC, $7E, $F4, $D0, $0B, $E4, $F5, $CB, $F4, $D7, $00, $FC, $D0, $F3, $AB, $01, $10, $EF, $7E, $F4, $10, $EB, $BA, $F6, $DA, $00, $BA, $F4, $C4, $F4, $DD, $5D, $D0, $DB, $1F
	db $00, $00, $C0, $FF	

org $4082B2
	BRA $01