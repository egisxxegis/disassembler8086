locals @@
	N equ 256d
.model small
.stack 100h
.data 
	buferisRAW     	DB N dup(0)
	buferisRAWsolo 	DB 0,0
	buferisPosli    DB "0100:    "
	buferisMasin   	DB 18d dup(' ')
	buferisAssem   	DB 50d dup(' '),13d,10d
	einamasisPoslinkis 	DW 0100h
	;pradinisPoslinkis  	DW 0100h
	jmpAdresas		DW 0000h
	cBuferisRAW   	DW 0000h
	cBuferisPosli	DW 0009h
	cBuferisMasin 	DW 0018d
	cBuferisAssem 	DW 0052d
	cRodoRM			DW 0006d
	posBuferisMasin	DW 0000h
	posBuferisAssem DW 0010d
	varSegPref 		DB 00000100b;00000011b
	varDir		 	DB 00000001b
	varS			DB 00000001b
	varWord			DB 00000001b
	varMod			DB "*";00000011b
	varReg			DB "r";00000111b
	varRM			DB "-";00000111b
	varRodoReg		DW "ND"
	varRodoSr		DW "ND"
	varRodoRM		DB "BX+SI "
	varAdresas		DB 00000001b
	posRodoRM		DW 0000h
	varPoslBSk		DB 0h
	varPtrReikia	DB 00000000b
	varPrefReikia	DB 00000100b
	varPrefSet		DB 00000000b;0false 1true
	varPridekIp		DB 00000000b
	;=================================
	ivestF  DB 50d dup(0)
	isvestF DB 50d dup(0)
	deskriptoriusIvestF  DW ?
	deskriptoriusIsvestF DW ?
	msgNoParam DB "Programa negavo parametru",'$'
	msgHelp DB "Atsiskaitantysis: Egidijus Gylys 1 kursas 5 grupe.",10,13,"Trumpas programos aprasas: programa nusiskaito masinini koda i buferi ir imdama po baita analizuoja ir iesko asemblerines atitikties, kuria veliau isspausdina rezultatu faile kartu su poslinkiu ir masiniu kodu.$"
	msgAtdrkSkaitymui DB "Nepavyko atidaryti duomenu failo $"
	msgAtdrkRasymui DB "Nepavyko atidaryti rasymo failo $"
	msgKldAccess DB "Priega uzdrausta prie rasymo failo $"
	msgKldKuriant DB "Nepavyko sukurti rez failo $"
	msgKldSkaitant DB "Nepavyko nuskaityti is duom failo $"
	msgKldDisassm DB "Ivyko klaida disassm funkcijoje $"
	msgKldSkaitantB DB "Klaida skaitant baita funkcijoje $"
	msgKurBaitas DB "Tiketasi baito, bet 0 baitu nuskaite funkcija $"
	msgButHow DB "Funkcijoje _FormuokOutput nenumatytas atvejis $"
	msgNetiketaKlaida DB "netiketa klaida $"
	enteris DB 10,13,'$'
	;======================================
	r_ax DW "ax"
	r_cx DW "cx"
	r_dx DW "dx"
	r_bx DW "bx"
	r_sp DW "sp"
	r_bp DW "bp"
	r_si DW "si"
	r_di DW "di"
	r_al DW "al"
	r_cl DW "cl"
	r_dl DW "dl"
	r_bl DW "bl"
	r_ah DW "ah"
	r_ch DW "ch"
	r_dh DW "dh"
	r_bh DW "bh"
	
	s_es dw "es"
	s_cs dw "cs"
	s_ss dw "ss"
	s_ds dw "ds"
	
	c_uni DB 10d ;0ah
	k_mov 	DB "mov       "
	k_ret 	DB "ret       "
	k_retf 	DB "retf      "
	k_push 	DB "push      "
	k_pop 	DB "pop       "
	k_inc 	DB "inc       "
	k_dec	DB "dec       "
	k_JO	DB "JO        "
	k_JNO	DB "JNO       "
	k_JB	DB "JB        "
	k_JAE	DB "JAE       "
	k_JE	DB "JE        "
	k_JNE	DB "JNE       "
	k_JBE	DB "JBE       "
	k_JA	DB "JA        "
	k_JS	DB "JS        "
	k_JNS	DB "JNS       "
	k_JP	DB "JP        "
	k_JNP	DB "JNP       "
	k_JL	DB "JL        "
	k_JGE	DB "JGE       "
	k_JLE	DB "JLE       "
	k_JG	DB "JG        "
	k_loop	DB "loop      "
	k_jmp	DB "jmp       "
	k_int	DB "int       "
	k_call	DB "call      "
	k_cmp 	DB "cmp       "
	k_add	DB "add       "
	k_sub	DB "sub       "
	k_mul	DB "mul       "
	k_div	DB "div       "
	k_xor	DB "xor       "
	
	k_neatp	DB "NEATPAZINTA"
	c_neatp DB 11d
	
	rm_bxsi DB "BX+SI"
	rm_bxdi DB "BX+DI"
	rm_bpsi DB "BP+SI"
	rm_bpdi DB "BP+DI"
	rm_si	DB "  SI "
	rm_di	DB "  DI "
	rm_bp	DB "  BP "
	rm_bx	DB "  BX "
	c_rm	DB 05h

	ptr_byte	DB "byte ptr "
	ptr_word	DB "word ptr "
	ptr_wordFar DB "word ptr far "
	c_ptr		DW 0009d
	c_ptrFar	DW 0013d
	
	tarpai DB "    "
	c_tarpai DB 4
	
.code
Pradzia:
	mov ax,@data
	mov ds,ax
	
	mov cx,0000h
	mov bx,0080h
	mov cl,byte ptr ES:[BX]
	inc bx
	cmp cl,0000h
	jne IeskokHelp
	jmp KldNoParam
JmpHelp:
	jmp Help
IeskokHelp:
	mov dx,ES:[BX]
	inc bx
	cmp dx,"?/"
	je JmpHelp
	loop IeskokHelp
IeskokIvestF:
	;mov cx,0000h
	mov bx,0080h
	mov al,00
	;mov cl,byte ptr ES:[BX]
	inc bx
	mov si, offset ivestF
	call _ExtractName
	cmp al,00h
	je IeskokIsvestF
	jmp KldIvestF
IeskokIsvestF:
	mov al,00
	mov si,offset isvestF
	call _ExtractName
	cmp al,00h
	je AtidarykSkaitymui
	jmp KldIsvestF
;==============================
AtidarykSkaitymui:
	mov cx,0000h
	mov ax,3D00h
	mov dx,offset ivestF
	int 21h
	jc KldAtidarymasSkaitymas
	mov deskriptoriusIvestF,ax
	mov si,0000h
	jmp AtidarykRasymui
KldAtidarymasSkaitymas:
	mov dx,offset msgAtdrkRasymui
	mov ah,09h
	int 21h
	jmp Endas
;====================================
	mov si,0000h
AtidarykRasymui:
	;mov cx,0001h
	mov ax,3D01h
	mov dx,offset isvestF
	int 21h
	jc KldAtidarymasRasymas
	mov deskriptoriusIsvestF,ax
	cmp si,0000h
	je Istrink
	jmp Skaityk
KldAtidarymasRasymas:
	cmp al,05h
	je KldAccess
	cmp si,0000
	je SukurkF
	mov ah,09h
	mov dx,offset msgAtdrkRasymui
	int 21h
	jmp Endas
SukurkF:
	inc si
	mov ax,3C00h
	mov dx, offset isvestF
	mov cx,0000h
	int 21h
	jc SukurkFailed
	mov bx,ax
	mov ah,3eh
	int 21h
	jmp AtidarykRasymui
KldAccess:
	mov dx,offset msgKldAccess
	mov ah,09h
	int 21h
	jmp Endas
SukurkFailed:
	mov ah,09h
	mov dx,offset msgKldKuriant
	int 21h
	jmp Endas
Istrink:
	mov ah,3Eh
	mov bx,deskriptoriusIsvestF
	int 21h
	mov ax,4100h
	mov dx,offset isvestF
	int 21h
	inc si
	jmp SukurkF
;================================
Skaityk:
	mov ax,3F00h
	mov bx,deskriptoriusIvestF
	mov cx,N
	mov dx,offset buferisRAW
	int 21h
	jc KlaidaSkaitant
	mov cx,ax ;kiek nuskaite
	cmp ax,0000h
	je EndasPrep
PrepDisassm:
	mov bx,deskriptoriusIsvestF
	mov si,offset buferisRAW
	;mov dx,offset buferisRAW
	call _DisassemblinkBuferiIrRasykIFaila
	;cmp al,00h	
	;je Skaityk
	jmp Skaityk
	;jmp KldDisassm
KlaidaSkaitant:
	mov ax,09h
	mov dx, offset msgKldSkaitant
	int 21h
	jmp EndasPrep
KldDisassm:
	mov ax,09h
	mov dx,offset msgKldDisassm
	int 21h
	jmp EndasPrep
	
	
	
	
SoFar:
	mov ah,02h
	mov dl,'O'
	int 21h
	mov ah,02h
	mov dl,'K'
	int 21h
	jmp Endas
	
	jmp Endas
;===================================
KldIvestF:
	mov ah,02
	mov dl,'I'
	int 21h
	jmp Help
KldIsvestF:
	mov ah,02
	mov dl,'O'
	int 21h
	jmp Help
KldNoParam:
	mov ax,0900h
	mov dx,offset msgNoParam
	int 21h
	jmp Endas
Help:
	mov ax,0900h
	mov dx, offset msgHelp
	int 21h
	jmp Endas
EndasPrep:
	mov bx,deskriptoriusIvestF
	mov ah,3Eh
	int 21h
	mov bx,deskriptoriusIsvestF
	mov ah,3Eh
	int 21h
	jmp Endas
Endas:
	mov ax,4C00h
	int 21h
;END Pradzia
;=====================================
PROC _ExtractName;()ex
	;AH - kiek uzima failo vardas
	;AL - returninsim ar buvo klaidu. 01 - buvo
	;BX - parametru vieta. ES:[BX]
	;;;;;CL - kiek elementu parametruose nuskaityti liko
	;;;;;CH - kiek uzima failo vardas
	;SI - kur irasysim varda DS:[SI]
push dx
;sub ax
@@CHECKING:
	mov ax,bx
	sub ax,0080h
	mov dh,00
	mov dl,ES:[0080h]
	add dl,1
	cmp ax,dx
ja @@OutOfRange

mov ax,0000
	@@MainLoop:
		mov dl,byte ptr ES:[BX]
		;mov dl,[es:bx]
		inc bx
		cmp dl,0dh
		jne @@MainLoopTesiasi
		jmp @@ParametraiBaigesi
	@@MainLoopTesiasi:
		cmp dl,' '
		jne @@MainLoopIrasom
		jmp @@RadomTarpa
	@@MainLoopIrasom:
		mov byte ptr DS:[SI],dl
		;mov [si],dl
		inc si
		INC AH
		jmp @@MainLoop
		
	@@RadomTarpa:
		cmp Ah,00h
		jne @@Dugnas
		jmp @@MainLoop
	@@ParametraiBaigesi:	
		cmp ah,00h
		jne @@Dugnas
		mov al,01
		jmp @@Dugnas
@@OutOfRange:
	mov al,01
@@Dugnas:
pop dx
	
RET
ENDP
PROC _GaukDarBaita;()gauk
	;si - buferisRAW
	;cx - kiek dar liko nenuskaitytu baitu
	;ah - papildomas baitas
	;bx - deskriptorius Ivest F				(not param)
	;dx - vieta, kur irasysim viena baita 	(not param)
	;3F - skaitymas	
@@Prep:
	push dx
	push bx
	@@ArBuferyjeYraBaitas:
		cmp cx,0000h
		je @@ImkIsFailo
		jmp @@ImkIsBuferio
	@@ImkIsFailo:
			push ax
				push cx
		mov ax,3F00h
		mov cx,0001h
		mov bx,deskriptoriusIvestF
		mov dx,offset buferisRAWsolo
		int 21h
		jc @@KritKldSkaitantBaita
		cmp ax,0000h
		je @@KritKldTiketasiBaito
				pop cx
			pop ax
		mov ah,buferisRAWsolo
		jmp @@Dugnas
	@@ImkIsBuferio:
		mov ah,byte ptr DS:[si]
		inc si
		dec cx
		jmp @@Dugnas
	@@KritKldSkaitantBaita:
				pop cx
			pop ax
		cmp ah,81h
		je @@PabaigaGi
		mov ax,0900h
		mov dx,offset msgKldSkaitantB
		int 21h
		
		
		
		jmp @@ExitProgram
	@@KritKldTiketasiBaito:
				pop cx
			pop ax
		cmp ah,81h
		je @@PabaigaGi
		mov ax,0900h
		mov dx,offset msgKurBaitas
		int 21h
		jmp @@ExitProgram
@@ExitProgram:
	mov ax,4C00h
	int 21h
@@PabaigaGi:
	mov posRodoRM,0FFh
	pop bx
	pop dx
	ret
@@Dugnas:
	inc einamasisPoslinkis
		push ax
		mov dl,ah
		mov ah,01h
		call _FormuokOutput
		pop ax
	pop bx
	pop dx
	
RET
ENDP
PROC _DisassemblinkBuferiIrRasykIFaila;()dis
	push si
	push di
	push bx
	;bx - deskriptorius Isvest F
	;cx - kiek nuskaityta
	;si - neapdoroti (RAW) baitu buferis
	;al - returnina 1, kai klaida, bet jame kaupsim ir nuskaityta baita
	;dl - al kopija, kurios negaila gadinti
	;40h - rasymas
@@Prep0:
	mov dx,0000h
	;mov si,0000h
	mov di,0000h
	@@Main:
		;kur tikrinimas,ar cx nepasibaige?
		cmp cx,00000h
		jne @@LoadBaitas
		jmp @@BuferisBaigesi
		@@LoadBaitas:
			mov al,byte ptr [si]
			inc si
			dec cx
				push ax;~~~~~~~~~~~~~~
			inc einamasisPoslinkis
			mov ah,01h ;masin
			mov dl,al ;baitas
			call _FormuokOutput
			cmp DS:[posBuferisMasin],0002h
			je @@ArPrefiksas
			jmp @@Atpazink
	@@ArPrefiksas:
		;001 xx 110; viskas viename baite
		and al,11100111b
		cmp al,00100110b
		je @@Prefiksas
		jmp @@Atpazink
		@@Prefiksas:
				pop ax ;~~~~~~~~~~~~~~~
			call _ImkOPKvidurySR
			jmp @@Main
	@@Atpazink:
				pop ax ;~~~~~~~~~~~~~
				push ax;-------------
		@@AtpazinkBeAdrBaito:
				;1100 0011 RET
				cmp al,11000011b
				jne @@AtpazinkBeAdrBaito0
				jmp @@Ret
			@@AtpazinkBeAdrBaito0:
				;1100 1011 RETF
				cmp al,11001011b
				jne @@AtpazinkBeAdrBaito1
				jmp @@Retf
			@@AtpazinkBeAdrBaito1:
				;0101 0reg PUSH REG
				cmp al,01010111b
				jbe @@GalPushReg
				jmp @@AtpazinkBeAdrBaito2
				@@GalPushReg:
					cmp al,01010000b
					jb @@AtpazinkBeAdrBaito2
					jmp @@PushReg
			@@AtpazinkBeAdrBaito2:
				;0101 1reg POP REG
				cmp al,01011111b
				jbe @@GalPopReg
				jmp @@AtpazinkBeAdrBaito3
				@@GalPopReg:
					cmp al,01011000b
					jb @@AtpazinkBeAdrBaito3
					jmp @@PopReg
			@@AtpazinkBeAdrBaito3:
				;0100 0reg INC REG
				mov dl,al
				and dl,11111000b
				cmp dl,01000000b
				jne @@AtpazinkBeAdrBaito4
				jmp @@IncReg
			@@AtpazinkBeAdrBaito4:
				;0100 1reg DEC REG
				mov dl,al
				and dl,11111000b
				cmp dl,01001000b
				jne @@AtpazinkBeAdrBaito5
				jmp @@DecReg
;JMP =======================================================
			@@AtpazinkBeAdrBaito5:
				;01110000 JO posl
				;and al,11111111b
				cmp al,01110000b
				jne @@AtpazinkBeAdrBaito6
				jmp @@JO
			@@AtpazinkBeAdrBaito6:
				;01110001 JNO posl
				;and al,11111111b
				cmp al,01110001b
				jne @@AtpazinkBeAdrBaito7
				jmp @@JNO
			@@AtpazinkBeAdrBaito7:
				;01110010 JB posl
				;and al,11111111b
				cmp al,01110010b
				jne @@AtpazinkBeAdrBaito8
				jmp @@JB
			@@AtpazinkBeAdrBaito8:
				;01110011 JAE posl
				;and al,11111111b
				cmp al,01110011b
				jne @@AtpazinkBeAdrBaito9
				jmp @@JAE
			@@AtpazinkBeAdrBaito9:
				;01110100 JE posl
				;and al,11111111b
				cmp al,01110100b
				jne @@AtpazinkBeAdrBaito10
				jmp @@JE
			@@AtpazinkBeAdrBaito10:
				;01110101 JNE posl
				;and al,11111111b
				cmp al,01110101b
				jne @@AtpazinkBeAdrBaito11
				jmp @@JNE
			@@AtpazinkBeAdrBaito11:
				;01110110 JBE posl
				;and al,11111111b
				cmp al,01110110b
				jne @@AtpazinkBeAdrBaito12
				jmp @@JBE
			@@AtpazinkBeAdrBaito12:
				;01110111 JA posl
				;and al,11111111b
				cmp al,01110111b
				jne @@AtpazinkBeAdrBaito13
				jmp @@JA
			@@AtpazinkBeAdrBaito13:
				;01111000 JS posl
				;and al,11111111b
				cmp al,01111000b
				jne @@AtpazinkBeAdrBaito14
				jmp @@JS
			@@AtpazinkBeAdrBaito14:
				;01111001 JNS posl
				;and al,11111111b
				cmp al,01111001b
				jne @@AtpazinkBeAdrBaito15
				jmp @@JNS
			@@AtpazinkBeAdrBaito15:
				;01111010 JP posl
				;and al,11111111b
				cmp al,01111010b
				jne @@AtpazinkBeAdrBaito16
				jmp @@JP
			@@AtpazinkBeAdrBaito16:
				;01111011 JNP posl
				;and al,11111111b
				cmp al,01111011b
				jne @@AtpazinkBeAdrBaito17
				jmp @@JNP
			@@AtpazinkBeAdrBaito17:
				;01111100 JL posl
				;and al,11111111b
				cmp al,01111100b
				jne @@AtpazinkBeAdrBaito19
				jmp @@JL
			@@AtpazinkBeAdrBaito19:
				;01111101 JGE posl
				;and al,11111111b
				cmp al,01111101b
				jne @@AtpazinkBeAdrBaito20
				jmp @@JGE
			@@AtpazinkBeAdrBaito20:
				;01111110 JLE posl
				;and al,11111111b
				cmp al,01111110b
				jne @@AtpazinkBeAdrBaito21
				jmp @@JLE
			@@AtpazinkBeAdrBaito21:
				;01111111 JG posl
				;and al,11111111b
				cmp al,01111111b
				jne @@AtpazinkBeAdrBaito22
				jmp @@JG
			@@AtpazinkBeAdrBaito22:
				;1110 0010 Loop posl
				cmp al,11100010b
				jne @@AtpazinkBeAdrBaito23
				jmp @@Loop
			@@AtpazinkBeAdrBaito23:
				;1110 1011 Jmp posl vid art
				cmp al,11101011b
				jne @@AtpazinkBeAdrBaito24
				jmp @@JmpVidArt
			@@AtpazinkBeAdrBaito24:
				;11001101 INT numeris
				cmp al,11001101b
				jne @@AtpazinkBeAdrBaito25
				jmp @@Int
;JMP IF arba komanda b.o.j.b. =========================================	
			@@AtpazinkBeAdrBaito25:
				;000sr110 -push seg reg
				mov dl,al
				and dl,11100111b
				cmp dl,00000110b
				jne @@AtpazinkBeAdrBaito26
				jmp @@PushSeg
			@@AtpazinkBeAdrBaito26:
				;000sr111 -pop seg reg
				mov dl,al
				and dl,11100111b
				cmp dl,00000111b
				jne @@AtpazinkBeAdrBaito27
				jmp @@PopSeg
;OPK SR _be_ mov sr
			@@AtpazinkBeAdrBaito27:
				;1100 0010 bojb bovb RET XXXX
				cmp al,11000010b
				jne @@AtpazinkBeAdrBaito28
				jmp @@RetIslyg
			@@AtpazinkBeAdrBaito28:
				;1100 1010 bojb bovb RETF XXXX
				cmp al,11001010b
				jne @@AtpazinkBeAdrBaito29
				jmp @@RetfIslyg
			@@AtpazinkBeAdrBaito29:
				;1110 1001 pjv pvb JMP vid ties
				cmp al,11101001b
				jne @@AtpazinkBeAdrBaito30
				jmp @@JmpVidTies
			@@AtpazinkBeAdrBaito30:
				;1110 1000 ajb avb CALL vid ties
				cmp al,11101000b
				jne @@AtpazinkBeAdrBaito31
				jmp @@CallVidTies
			@@AtpazinkBeAdrBaito31:
				;1010 000w ajb avb MOV AKum <- atm
				mov dl,al
				and dl,11111110b
				cmp dl,10100000b
				jne @@AtpazinkBeAdrBaito32
				jmp @@MovAkAtm
			@@AtpazinkBeAdrBaito32:
				;1010 001w ajb avb MOV atm <- akum
				mov dl,al
				and dl,11111110b
				cmp dl,10100010b
				jne @@AtpazinkBeAdrBaito33
				jmp @@MovAkAtm
			@@AtpazinkBeAdrBaito33:
				;0011 110w bojb [bovb] cmp akum bet op
				mov dl,al
				and dl,11111110b
				cmp dl,00111100b
				jne @@AtpazinkBeAdrBaito34
				jmp @@CmpAkBet
			@@AtpazinkBeAdrBaito34:
				;0000 010w bojb [bovb] add akum bet op
				mov dl,al
				and dl,11111110b
				cmp dl,00000100b
				jne @@AtpazinkBeAdrBaito35
				jmp @@AddAkBet
			@@AtpazinkBeAdrBaito35:
				;1011 wreg bojb [bovb] MOV reg,bet op
				mov dl,al
				and dl,11110000b
				cmp dl,10110000b
				jne @@AtpazinkBeAdrBaito36
				jmp @@MovRegBet
			@@AtpazinkBeAdrBaito36:
				;0010 110w bojb [bovb] Sub akum,bet
				mov dl,al
				and dl,11111110b
				cmp dl,00101100b
				jne @@AtpazinkBeAdrBaito37
				jmp @@SubAkumBet
			@@AtpazinkBeAdrBaito37:
				;1001 1010 ajb avb srjb srvb call isorin ties
				cmp al,10011010b
				jne @@AtpazinkBeAdrBaito38
				jmp @@CallisorTies
				;%
			@@AtpazinkBeAdrBaito38:
				;1110 1010 ajb avb srjb srvb JMP isor ties
				cmp al,11101010b
				jne @@AtpazinkBeAdrBaito39;%
				jmp @@JmpIsorTies
				;%
			@@AtpazinkBeAdrBaito39:
			
			jmp @@AtpazinkSuAdrBaitu
			@@ShortNeatpazinta:
				jmp @@Neatpazinta
			@@ShortNeatpazintaBaik:
				jmp @@NeatpazintaBaik
		@@AtpazinkSuAdrBaitu:;()disadr
					pop ax
			mov ah,81h
			call _GaukDarBaita
					push ax
			cmp posRodoRM,0FFh
			je @@ShortNeatpazintaBaik
			call _ImkAdrModRegRM
			@@AtpazinkSuAdrBaitu01:
				;1000 1111 mod 000 r/m [poslinkis]
				cmp al,10001111b
				jne @@AtpazinkSuAdrBaitu02
				cmp varReg,00000000b
				jne @@AtpazinkSuAdrBaitu02
				jmp @@PopRM
			@@AtpazinkSuAdrBaitu02:
				;1111 1111 mod 110 r/m [posl]
				cmp al,11111111b
				jne @@AtpazinkSuAdrBaitu03
				cmp varReg,00000110b
				jne @@AtpazinkSuAdrBaitu03
				jmp @@PushRM
			@@AtpazinkSuAdrBaitu03:
				;1111 1111 mod 010 r/m [posl] Call vid neties
				cmp al,11111111b;%
				jne @@AtpazinkSuAdrBaitu04
				cmp varReg,00000010b
				jne @@AtpazinkSuAdrBaitu04
				jmp @@CallVidNeties
			@@AtpazinkSuAdrBaitu04:
				;1111 1111 mod 011 r/m [posl] Call isor neties
				cmp al,11111111b;%
				jne @@AtpazinkSuAdrBaitu05
				cmp varReg,00000011b
				jne @@AtpazinkSuAdrBaitu05
				jmp @@CallIsorNeties
			@@AtpazinkSuAdrBaitu05:
				;1111 1111 mod 100 r/m [posl] JMP vid neties
				cmp al,11111111b;%
				jne @@AtpazinkSuAdrBaitu06
				cmp varReg,00000100b
				jne @@AtpazinkSuAdrBaitu06
				jmp @@JmpVidNeties
			@@AtpazinkSuAdrBaitu06:
				;1111 1111 mod 101 r/m [posl] JMP isor neties
				cmp al,11111111b;%
				jne @@AtpazinkSuAdrBaitu07
				cmp varReg,00000101b
				jne @@AtpazinkSuAdrBaitu07
				jmp @@JmpIsorNeties
			@@AtpazinkSuAdrBaitu07:
				;1111 011w mod 110 r/m [posl] div rm
				mov dl,al
				and dl,11111110b
				cmp dl,11110110b
				jne @@AtpazinkSuAdrBaitu08
				cmp varReg,00000110b
				jne @@AtpazinkSuAdrBaitu08
				jmp @@DivRM
			@@AtpazinkSuAdrBaitu08:
				;1111 011w mod 100 r/m [posl] mul rm
				mov dl,al
				and dl,11111110b
				cmp dl,11110110b
				jne @@AtpazinkSuAdrBaitu09
				cmp varReg,00000100b
				jne @@AtpazinkSuAdrBaitu09
				jmp @@MulRM
			@@AtpazinkSuAdrBaitu09:
				;1111 111w mod 001 r/m [posl] dec rm
				mov dl,al
				and dl,11111110b
				cmp dl,11111110b
				jne @@AtpazinkSuAdrBaitu10
				cmp varReg,00000001b
				jne @@AtpazinkSuAdrBaitu10
				jmp @@DecRM
			@@AtpazinkSuAdrBaitu10:
				;1111 111w mod 000 r/m [posl] inc rm
				mov dl,al
				and dl,11111110b
				cmp dl,11111110b
				jne @@AtpazinkSuAdrBaitu11
				cmp varReg,00000000b
				jne @@AtpazinkSuAdrBaitu11
				jmp @@IncRM
			@@AtpazinkSuAdrBaitu11:
				;1000 00sw mod 000 r/m [posl] bojb [bovb] addRMBet
				mov dl,al
				and dl,11111100b
				cmp dl,10000000b
				jne @@AtpazinkSuAdrBaitu12
				cmp varReg,00000000b
				jne @@AtpazinkSuAdrBaitu12
				jmp @@AddRMBet
			@@AtpazinkSuAdrBaitu12:
				;1000 00sw mod 101 r/m [posl] bojb [bovb] SubRMBet
				mov dl,al
				and dl,11111100b
				cmp dl,10000000b
				jne @@AtpazinkSuAdrBaitu13
				cmp varReg,00000101b
				jne @@AtpazinkSuAdrBaitu13
				jmp @@SubRMBet
			@@AtpazinkSuAdrBaitu13:
				;1000 00sw mod 111 r/m [posl] bojb [bovb] CmpRMBet
				mov dl,al
				and dl,11111100b
				cmp dl,10000000b
				jne @@AtpazinkSuAdrBaitu14
				cmp varReg,00000111b
				jne @@AtpazinkSuAdrBaitu14
				jmp @@CmpRMBet
			@@AtpazinkSuAdrBaitu14:
				;1100 011w mod 000 r/m [posl] bojb [bovb] MovRMBet
				mov dl,al
				and dl,11111110b
				cmp dl,11000110b
				jne @@AtpazinkSuAdrBaitu15
				cmp varReg,00000000b
				jne @@AtpazinkSuAdrBaitu15
				jmp @@MovRMBet
			@@AtpazinkSuAdrBaitu15:
				;0000 00dw mod reg r/m [posl] Add reg,rm (<->)
				mov dl,al
				and dl,11111100b
				cmp dl,00000000b
				jne @@AtpazinkSuAdrBaitu16
				jmp @@AddDRegRM
			@@AtpazinkSuAdrBaitu16:
				;0010 10dw mod reg r/m [posl] Sub reg,rm (<->)
				mov dl,al
				and dl,11111100b
				cmp dl,00101000b
				jne @@AtpazinkSuAdrBaitu17
				jmp @@SubDRegRM
			@@AtpazinkSuAdrBaitu17:
				;0011 10dw mod reg r/m [posl] Cmp reg,rm (<->)
				mov dl,al
				and dl,11111100b
				cmp dl,00111000b
				jne @@AtpazinkSuAdrBaitu18
				jmp @@CmpDRegRM
			@@AtpazinkSuAdrBaitu18:
				;1000 10dw mod reg r/m [posl] Mov reg,rm (<->)
				mov dl,al
				and dl,11111100b
				cmp dl,10001000b
				jne @@AtpazinkSuAdrBaitu19
				jmp @@MovDRegRM
			@@AtpazinkSuAdrBaitu19:
				;1000 11d0 mod 0sr r/m [posl] Mov sr,rm (<->)
				mov dl,al
				and dl,11111101b
				cmp dl,10001100b
				jne @@AtpazinkSuAdrBaitu20
				cmp varReg,00000100b
				jae @@AtpazinkSuAdrBaitu20
				jmp @@MovDSRRM
			 @@AtpazinkSuAdrBaitu20:
				;0011 00dw mod reg r/m [poslinkis] xor reg rm (<->)
				mov dl,al
				and dl,11111100b
				cmp dl,00110000b
				jne @@AtpazinkSuAdrBaitu21;
				jmp @@XorDRegRM
			@@AtpazinkSuAdrBaitu21:
				
			jmp @@NeatpazintaZingsniAtgal
		@@NeatpazintaZingsniAtgal:
				pop ax
			dec si
			mov byte ptr [si],ah ;del visa ko, jeigu is failo skaitem
			inc cx ;priesinga skaitymui
				push si
					push cx
			mov si,offset BuferisMasin
			mov cx,posBuferisMasin
			add si,cx
			sub si,02h
			mov cx,0002h
			call _UzpildykTarpais
					pop cx
				pop si
				push ax
			dec einamasisPoslinkis
			jmp @@Neatpazinta
	@@Komandos:
		@@Ret:
				;pop ax;--------------
			mov dx,offset k_ret
			mov ah,02h ;step assem prad
			;mov al,c_ret
			mov al,c_uni
			jmp @@LastFormuokAndPrintPop
		@@Retf:
				;pop ax;-------------
			mov dx,offset k_retf
			mov al,c_uni
			mov ah,02h
			jmp @@LastFormuokAndPrintPop
;OPK REG ======================================
		@@PushReg:
			;;0101 0reg PUSH REG
			mov dx,offset k_push
			mov al,c_uni
			jmp @@F00Form02PopOPKREGextractForm03Last
		@@PopReg:
			;;0101 1reg POP REG
			mov dx,offset k_pop
			mov al,c_uni
			jmp @@F00Form02PopOPKREGextractForm03Last
		@@IncReg:
			;0100 0reg INC REG
			mov dx,offset k_inc
			mov al,c_uni
			jmp @@F00Form02PopOPKREGextractForm03Last
		@@DecReg:
			;0100 1reg DEC REG
			mov dx,offset k_dec
			mov al,c_uni
			jmp @@F00Form02PopOPKREGextractForm03Last
;Poslinkieciai =======================================================
		@@JO:
			mov dx,offset k_JO
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JNO:
			mov dx,offset k_JNO
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JB:
			mov dx,offset k_JB
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JAE:
			mov dx,offset k_JAE
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JE:
			mov dx,offset k_JE
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JNE:
			mov dx,offset k_JNE
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JBE:
			mov dx,offset k_JBE
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JA:
			mov dx,offset k_JA
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JS:
			mov dx,offset k_JS
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JNS:
			mov dx,offset k_JNS
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JP:
			mov dx,offset k_JP
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JNP:
			mov dx,offset k_JNP
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JL:
			mov dx,offset k_JL
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JGE:
			mov dx,offset k_JGE
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JLE:
			mov dx,offset k_JLE
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JG:
			mov dx,offset k_JG
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@Loop:
			mov dx,offset k_loop
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@JmpVidArt:
			mov dx,offset k_jmp
			mov al,c_uni
			jmp @@F01Form02PopPoslForm04Last
		@@Int:
			mov dx,offset k_int
			mov al,c_uni
			jmp @@F01Form02PopPoslForm05Last
		@@JmpIsorTies:
			mov dx,offset k_jmp
			mov al,c_uni
			jmp @@F07Form02IsorTies
		@@CallIsorTies:
			mov dx,offset k_call
			mov al,c_uni
			jmp @@F07Form02IsorTies
;JMP salyg arba kom b.o.j.b. =================================================
		@@PushSeg:
			mov dx,offset k_push
			mov al,c_uni
			jmp @@F00Form02PopOPKSRextractForm03Last
		@@PopSeg:
			mov dx,offset k_pop
			mov al,c_uni
			jmp @@F00Form02PopOPKSRextractForm03Last
; KOM jb  / KOMw jb vb ====================
		@@RetIslyg:
			mov varAdresas,00h
			mov dx,offset k_ret
			mov al,c_uni
			jmp @@F02Form02JbVbForm06LastPop
		@@RetfIslyg:
			mov varAdresas,00h
			mov dx,offset k_retf
			mov al,c_uni
			jmp @@F02Form02JbVbForm06LastPop
		@@JmpVidTies:
			mov dx,offset k_jmp
			mov al,c_uni
			jmp @@F02Form02JbVbForm06LastPop
		@@CallVidTies:
			mov dx,offset k_call
			mov al,c_uni
			mov varAdresas,00h
			mov varPridekIp,01h
			jmp @@F02Form02JbVbForm06LastPop
		@@MovAkAtm:
			mov dx,offset k_mov
			mov al,c_uni
			mov varReg,00000000b
			mov varPrefReikia,00000011b
			jmp @@F02Form02wPopAkumAtmJbVbForm07Last
;=====betarpiski==============================
		@@CmpAkBet:
			mov dx,offset k_cmp
			mov al,c_uni
			jmp @@F03Form02wPopAkumBetJb0VbForm07Last
		@@AddAkBet:
			mov dx,offset k_add
			mov al,c_uni
			jmp @@F03Form02wPopAkumBetJb0VbForm07Last
		@@MovRegBet:
			call _ImkOPKgaleREG
			mov ah,03h
			call _ImkIsAlBitaAhNuo0Iki7IrGrazinkIAh
			mov varWord,ah
			mov dx,offset k_mov
			mov al,c_uni
			jmp @@F03Form02wregPopRegBetJb0VbForm07Last
		@@SubAkumBet:
			mov dx,offset k_sub
			mov al,c_uni
			jmp @@F03Form02wPopAkumBetJb0VbForm07Last
;SU ADR baitu======================================
		
		@@PopRM:
			mov dx,offset k_pop
			mov al,c_uni
			jmp @@F04Form02AdrPoslinkis
		@@PushRM:
			mov dx,offset k_push
			mov al,c_uni
			jmp @@F04Form02AdrPoslinkis
		@@CallVidNeties:
			mov dx,offset k_call
			mov al,c_uni
			jmp @@F04Form02wAdrPoslinkis
		@@CallIsorNeties:
			mov dx,offset k_call
			mov al,c_uni
			jmp @@F08Form02AdrPosl
		@@JmpVidNeties:
			mov dx,offset k_jmp
			mov al,c_uni
			jmp @@F04Form02wAdrPoslinkis
		@@JmpIsorNeties:
			mov dx,offset k_jmp
			mov al,c_uni
			jmp @@F08Form02AdrPosl
		;jmp @@NeatpazintaZingsniAtgal
		@@DivRM:
			mov dx,offset k_div
			mov al,c_uni
			jmp @@F04Form02wAdrPoslinkis
		@@MulRM:
			mov dx,offset k_mul
			mov al,c_uni
			jmp @@F04Form02wAdrPoslinkis
		@@IncRM:
			mov dx,offset k_inc
			mov al,c_uni
			jmp @@F04Form02wAdrPoslinkis
		@@DecRM:
			mov dx,offset k_dec
			mov al,c_uni
			jmp @@F04Form02wAdrPoslinkis
;==ADR posl bet vienkryptis====================================
		@@AddRMBet:
			mov dx,offset k_add
			mov al, c_uni
			jmp @@F05Form02swAdrPoslBojb0Bovb
		@@SubRMBet:
			mov dx,offset k_sub
			mov al, c_uni
			jmp @@F05Form02swAdrPoslBojb0Bovb
		@@CmpRMBet:
			mov dx,offset k_cmp
			mov al,c_uni
			jmp @@F05Form02swAdrPoslBojb0Bovb
		@@MovRMBet:
			mov dx,offset k_mov
			mov al,c_uni
			jmp @@F05Form02wAdrPoslBojb0Bovb
;==ADR posl (<-> (dir) )==============================
		@@AddDRegRM:
			mov dx,offset k_add
			mov al,c_uni
			jmp @@F06Form02dwAdrPosl
		@@SubDRegRM:
			mov dx,offset k_sub
			mov al,c_uni
			jmp @@F06Form02dwAdrPosl
		@@CmpDRegRM:
			mov dx,offset k_cmp
			mov al,c_uni
			jmp @@F06Form02dwAdrPosl
		@@MovDRegRM:
			mov dx,offset k_mov
			mov al,c_uni
			jmp @@F06Form02dwAdrPosl
		@@MovDSRRM:
			mov dx,offset k_mov
			mov al,c_uni
			jmp @@F06Form02d0Mod0SRRM
		@@XorDRegRM:
			mov dx,offset k_xor
			mov al,c_uni
			jmp @@F06Form02dwAdrPosl
;==Jmp ir call su ADR===============================
		;()diskom
		@@Neatpazinta:
			mov dx,offset k_neatp
			mov al,c_neatp
			mov ah,02h
			jmp @@LastFormuokAndPrintPop
		@@NeatpazintaBaik:
			mov dx,offset k_neatp
			mov al,c_neatp
			mov ah,02h
			mov cx,0000h
			jmp @@LastFormuokAndPrintPop
			@@F00Form02PopOPKREGextractForm03Last:
				mov ah,02h
				call _FormuokOutput
					pop ax;-------------
				call _ImkOPKgaleREG
				mov varWord,00000001b
				call _KokiRegistraRodoVarReg
				mov ah,03h
				jmp @@LastFormuokAndPrint
			@@F00Form02PopOPKSRextractForm03Last:
				mov ah,02h
				call _FormuokOutput
					pop ax;-------------------
				call _ImkOPKvidurySR
				mov ax,varRodoSr
				mov varRodoReg,ax
				mov ah,03h
				jmp @@LastFormuokAndPrint
			@@F01Form02PopPoslForm04Last:
				mov ah,02h
				call _FormuokOutput
					pop ax;-------------
				call _GaukDarBaita
				mov dl,ah
				mov ah,04h
				mov varPrefReikia,01h
				call _ImituokSegPref
				jmp @@LastFormuokAndPrint
			@@F01Form02PopPoslForm05Last:
				mov ah,02h
				call _FormuokOutput
					pop ax;-------------
				call _GaukDarBaita
				mov dl,ah
				mov ah,05h
				jmp @@LastFormuokAndPrint
			@@F02Form02JbVbForm06LastPop:
				mov ah,02h
				call _FormuokOutput
				call _GaukDarBaita
				mov dl,ah
				call _GaukDarBaita
				mov dh,ah
				mov ah,06h
				jmp @@LastFormuokAndPrintPop
			@@F02Form02wPopAkumAtmJbVbForm07Last:
				mov ah,02h
				call _FormuokOutput
				call _ImituokSegPref
					pop ax
				call _ImkOPKgaleDW
				call _KokiRegistraRodoVarReg
				call _GaukDarBaita
				mov dl,ah
				call _GaukDarBaita
				mov dh,ah
				cmp varDir,00000001b
					jne @@PartF02IsAtmintiesIAkuma
				mov ah,06h ; "xxxx"
				call _FormuokOutput
				mov ah,07h ;", "
				call _FormuokOutput
				mov ah,03h ;"reg'
				;call _FormuokOutput
				;mov ah,81h
				jmp @@LastFormuokAndPrint
					@@PartF02IsAtmintiesIAkuma:
				mov ah,03h
				call _FormuokOutput
				mov ah,07h
				call _FormuokOutput
				mov ah,06h
				;call _FormuokOutput
				;mov ah, 81h
				jmp @@LastFormuokAndPrint
			@@F03Form02wPopAkumBetJb0VbForm07Last:
				mov varReg,00000000b
				mov ah,02h
				call _FormuokOutput
					pop ax
				call _ImkOPKgaleDW
					@@F03RegBetJb0Vb:
				call _KokiRegistraRodoVarReg
				call _GaukDarBaita
				mov dl,ah
				cmp varWord,00000001b
					jne @@PF03Form02wPopAkumBetJb0VbForm07Last
				call _GaukDarBaita
				mov dh,ah
					@@PF03Form02wPopAkumBetJb0VbForm07Last:
				mov ah,03h ;reg
				call _FormuokOutput
				mov ah,07h ;', '
				call _FormuokOutput
				mov ah,0Bh ;bet (bojb [bovb] (nuspres AssemOp2The0A) )
				jmp @@LastFormuokAndPrint
			@@F03Form02wregPopRegBetJb0VbForm07Last:
				mov ah,02h
				call _FormuokOutput
					pop ax
				jmp @@F03RegBetJb0Vb
			@@F04Form02wAdrPoslinkis:;()f04
					pop ax
					push ax
				call _ImkOPKgaleDW ;Dir mums nereikia. tik W
				mov varPtrReikia,01h
				mov al,c_uni
			@@F04Form02AdrPoslinkis:
				mov ah,02h
				call _FormuokOutput
				mov ax,offset @@LastFormuokAndPrint
				mov jmpAdresas,ax
					@@PF04Form02AdrPoslContinue:
					pop ax;nebutina
				call _KaRodoVarRM
				call _ImituokSegPref
				cmp varPoslBSk,04h
					je @@PF04Form02Registras
				cmp varPtrReikia,01h
					jne @@PF04RodyklesNedek
				mov ah,08h
				call _FormuokOutput
					@@PF04RodyklesNedek:
				cmp varPoslBSk,03h
				je @@PF04Form02AdrPoslTies
				mov ah,0Ch
				call _FormuokOutput
				jmp @@PF04Form02AdrPoslTikrinimai
					@@PF04Form02Registras:
						mov varPtrReikia,00h
						mov ax,varRodoReg
							push ax
								push si
						mov si,offset varRodoRM
						mov ah,byte ptr ds:[si]
						inc si
						mov al,byte ptr ds:[si]
						mov varRodoReg,ax
						mov ah,03h
						call _FormuokOutpuT
								pop si
							pop ax
						mov varRodoReg,ax
						mov ah,0Ah ;tuscia
						jmp jmpAdresas
					@@PF04Form02AdrPoslTikrinimai:
						;mov varAdresas,00h
						cmp varPoslBSk,01h
						je @@PF04Form02AdrPoslReikiaPoslJb
						cmp varPoslBSk,02h
						je @@PF04Form02AdrPoslReikiaPoslJbVb
					@@PF04Form02AdrPoslNieko:
						mov ah,0Dh ;']'
						;jmp @@LastFormuokAndPrint
						jmp jmpAdresas
				jmp @@LastFormuokAndPrint
					@@PF04Form02AdrPoslReikiaPoslJb:
						call _GaukDarBaita
						mov dl,ah
						mov varAdresas,00000000b
						mov ah,0Eh ;praplestas
						call _FormuokOutput
						mov ah,0Dh ;']'
						;call _FormuokOutput
						;jmp @@AndPrint
						jmp jmpAdresas
					@@PF04Form02AdrPoslReikiaPoslJbVb:
						call _GaukDarBaita
						mov dl,ah
						call _GaukDarBaita
						mov dh,ah
						mov ah,06h ;poslinkis pilnas
						call _FormuokOutput
						mov ah,0Dh ;']'
						;call _FormuokOutput
						;jmp @@AndPrint 
						jmp jmpAdresas
					@@PF04Form02AdrPoslTies:
						call _GaukDarBaita
						mov dl,ah
						call _GaukDarBaita
						mov dh,ah
						;mov varAdresas,01h
						mov ah,06h
						;call _FormuokOutput
						;mov ah,07h
						;call _FormuokOutput
						;jmp @@LastFormuokAndPrint
						jmp jmpAdresas
			@@F05Form02swAdrPoslBojb0Bovb:
					mov ah,02h
					call _FormuokOutput
						pop ax
						push ax
					call _ImkOPKgaleDW ;Dir mums nereikia. tik SW
					mov ah,varDir
					mov varS,ah
					mov varPtrReikia,01h
					mov ax,offset @@PF05Form02swAdrPoslBojb0BovbTesk
					mov jmpAdresas,ax
					jmp @@PF04Form02AdrPoslContinue
				@@PF05Form02swAdrPoslBojb0BovbTesk:
					call _FormuokOutput
					mov ah,07h
					call _FormuokOutput
					;jmp @@LastFormuokAndPrint
					cmp varWord,00000000b
					je @@PF05Form02swAdrVienasBaitasBojb
					cmp varS,	000000001b
					je @@PF05Form02swAdrVienasBaitasBojb
						;S:W=00:01 ;Bojb ir Bovb
						call _GaukDarBaita
						mov dl,ah
						call _GaukDarBaita
						mov dh,ah
						mov ah,0Bh
						jmp @@LastFormuokAndPrint
					@@PF05Form02swAdrVienasBaitasBojb:
						cmp varWord,00000001b
						je @@PF05Form02swAdrVienasPraplestasBaitas
						;S:W=01:00
						call _GaukDarBaita
						mov dl,ah
						mov ah,05h
						jmp @@LastFormuokAndPrint
					@@PF05Form02swAdrVienasPraplestasBaitas:
						;S:W=0x:01
						call _GaukDarBaita
						mov dl,ah
						mov ah,0Eh
						mov varAdresas,00h
						jmp @@LastFormuokAndPrint
					;call _FormuokOutput
					;cmp 
			@@F05Form02wAdrPoslBojb0Bovb:
					mov ah,02h
					call _FormuokOutput
						pop ax
						push ax
					call _ImkOPKgaleDW ;Dir mums nereikia. tik W
					mov varPtrReikia,01h
					mov ax,offset @@PF05Form02wAdrPoslBojb0BovbTesk
					mov jmpAdresas,ax
					jmp @@PF04Form02AdrPoslContinue
				@@PF05Form02wAdrPoslBojb0BovbTesk:
					call _FormuokOutput
					mov ah,07h
					call _FormuokOutput
					cmp varWord,00000001b
					je  @@PF05Form02wAdrBojbBovb
					jmp @@PF05Form02wAdrBojb
					@@PF05Form02wAdrBojbBovb:
						call _GaukDarBaita
						mov dl,ah
						call _GaukDarBaita
						mov dh,ah
						mov ah,0Bh
						jmp @@LastFormuokAndPrint
					@@PF05Form02wAdrBojb:
						call _GaukDarBaita
						mov dl,ah
						mov ah,05h
						jmp @@LastFormuokAndPrint
			@@F06Form02dwAdrPosl:
					mov ah,02h
					call _FormuokOutput
						pop ax
						push ax
					call _ImkOPKgaleDW
					call _KokiRegistraRodoVarReg
					;call _KaRodoVarRM
				@@PF06Form02dwAdrPoslConti:
					mov varPtrReikia,01h
					cmp varDir,00000001b
					je  @@PF06Form02dwRegRM
					jmp @@PF06Form02dwRMReg
				@@PF06Form02dwRegRM:;()F06
					mov ah,03h ;reg
					call _FormuokOutput
					mov ah,07h ;', '
					call _FormuokOutput
					mov ax,offset @@LastFormuokAndPrint
					mov jmpAdresas,ax
					jmp @@PF04Form02AdrPoslContinue
				@@PF06Form02dwRMReg:
					mov ax,offset @@PF06Form02dwRMRegContinue
					mov jmpAdresas,ax
					jmp @@PF04Form02AdrPoslContinue
					@@PF06Form02dwRMRegContinue:
						call _FormuokOutpuT
						mov ah,07h
						call _FormuokOutput
						mov ah,03h
						jmp @@LastFormuokAndPrint
			@@F06Form02d0Mod0SRRM:
				mov ah,02h
				call _FormuokOutpuT
					pop ax
				call _ImkOPKgaleDW
					push ax ;--------------------------|
				mov al,ah
						push dx;************************|
						mov dx,varRodoSr
							push cx;~~~~~~~~~~~~~~~~~~~~~|
							mov cl,varPrefSet
							mov ch,varSegPref
				call _ImkOPKvidurySR
				mov ax,varRodoSr
				mov varRodoReg,ax
							mov varPrefSet,cl
							mov varSegPref,ch
							pop cx;~~~~~~~~~~~~~~~~~~~~~/
						mov varRodoSr,dx
						pop dx;************************/
					pop ax;---------------------------/
					push ax
				mov varWord,00000001b
				jmp @@PF06Form02dwAdrPoslConti
			@@F07Form02IsorTies:;()F07
				mov ah,02h
				call _FormuokOutpuT
				mov varWord,01h
				mov varPtrReikia,01h
				mov ah,08h ;ptr
				call _FormuokOutpuT
				call _GaukDarBaita
				mov dl,ah
				call _GaukDarBaita
				mov dh,ah
					push dx
				call _GaukDarBaita
				mov dl,ah
				call _GaukDarBaita
				mov dh,ah
				mov ah,06h
				mov varAdresas,00h
				call _FormuokOutpuT
				mov dl,':'
				mov ah,09h
				call _FormuokOutpuT
					pop dx
				mov ah,06h
				mov varAdresas,00h
				jmp @@LastFormuokAndPrintPop
			@@F08Form02AdrPosl:
				mov ah,02h
				call _FormuokOutpuT
				mov varPtrReikia,01h
				mov varWord,10h
				mov ah,08h
				call _FormuokOutpuT
				mov varWord,01h
				mov varPtrReikia,00h
				mov ax,offset @@LastFormuokAndPrint
				mov jmpAdresas,ax
				jmp @@PF04Form02AdrPoslContinue
				
			@@LastFormuokAndPrint:
				call _FormuokOutput
			@@AndPrint:
				mov ah,81h
				call _FormuokOutput
				jmp @@Main
			@@LastFormuokAndPrintPop:
				call _FormuokOutput
				mov ah,81h
				call _FormuokOutput
				pop ax;--------------------------------
				jmp @@Main
	@@BuferisBaigesi:
	jmp @@Dugnas
	
@@NetiketaKlaida:
	mov ax,09h
	mov dx,offset msgNetiketaKlaida
	int 21h
	mov ax,4c00h
	int 21h
@@Dugnas:
	pop bx
	pop di
	pop si
RET
ENDP
PROC _FormuokOutput
	push ax
	push cx
	push dx
	push si
	push di
	push bx
	;dx - parametras. @@masininiame baitas (DL), kitur kazkas
	;		@@AssemPrad komandos adresas pvz adr i "mov "
	;al - kopijuojamo buferio ilgis per @@AssemPrad
	;ah - kuris jau step
	;0 - posl; 1 - masininis;
	;2 - assem prad (kom)
	;03h <=ah<= 0Ah - assem op1
	;0Bh <=ah<= 18h - assem op2
	@@Tikrinimai:
		cmp ah,00h
		je @@Posl
		cmp ah,01h
		je @@ShortMasininis
		cmp ah,02h
		je @@ShortAssemPrad
		cmp ah,0Ah
		ja @@PaskutinisTikrinimas
		jmp @@AssemOp1 ;02 < ah < 0B h
	@@PaskutinisTikrinimas:
		cmp ah,19h ; 0A < ah < 19h
		jb @@ShortAssemOp2
		cmp ah,81h
		je @@ShortPrint
		jmp @@Neapibrezta
		@@ShortMasininis:
			jmp @@Masininis
		@@ShortPrint:
			jmp @@Print
		@@ShortAssemPrad:
			jmp @@AssemPrad
	@@ShortAssemOp2:
		jmp @@AssemOp2
	@@Posl:
		@@FormBuferisPoslinkis:
			mov dl,00h
			mov si,offset buferisPosli
			mov ax,einamasisPoslinkis
			call _PoslinkiBuferin
		jmp @@Dugnas
	@@Masininis:
		mov bh,10h
		mov dh,00h
		;dl baitas
		mov ax,dx
		div bh
		call _AlToASCIIHex
		;exchange
		mov dh,ah
		mov ah,al
		mov al,dh
		call _AlToASCIIHex
		mov bx,offset buferisMasin
		mov si,posBuferisMasin
		mov byte ptr DS:[BX+SI],ah
		inc si
		mov byte ptr DS:[BX+SI],al
		inc si
		mov posBuferisMasin,si
		;inc byte ptr einamasisPoslinkis
		jmp @@Dugnas
		
	@@AssemPrad:
		;mov bx,offset buferisAssem
		;mov si,cBuferisAssem ;nereikia pacioj pradzioj
		mov ah,00
		;mov cBuferisAssem,ax
			push es
				push ds
				pop es
		;mov es,ds
		mov cx,0000h
		mov cl,al ;al kaip parametras
		mov si,dx ;adresas komandos zodziu pvz adr i "mov "
		mov di,offset buferisAssem
		REP movsb
			pop es
		mov ax,0010d
		mov posBuferisAssem,ax
		jmp @@Dugnas
	@@AssemOp1:;()form
			;feel free to edit
			;02 < ah < 0B
			cmp ah,03h
			jne @@AssemOp1Vari04
			jmp @@AssemOp1The03
		@@AssemOp1Vari04:
			cmp ah,04h
			jne @@AssemOp1Vari05
			jmp @@AssemOp1The04
		@@AssemOp1Vari05:
			cmp ah,05h
			jne @@AssemblyOp1Vari06
			jmp @@AssemOp1The05
		@@AssemblyOp1Vari06:
			cmp ah,06h
			jne @@AssemblyOp1Vari07
			jmp @@AssemOp1The06
		@@AssemblyOp1Vari07:
			cmp ah,07h
			jne @@AssemblyOp1Vari08
			jmp @@AssemOp1The07
		@@AssemblyOp1Vari08:
			cmp ah,08h
			jne @@AssemblyOp1Vari09
			jmp @@AssemOp1The08
		@@AssemblyOp1Vari09:
			cmp ah,09h
			jne @@AssemblyOp1TheVari0A
			jmp @@AssemOp1The09
		@@AssemblyOp1TheVari0A:
			jmp @@Dugnas
		@@AssemOp1The03:
			;komanda registras
			;mov ax,posBuferisAssem
			;__reg__
			mov ax,posBuferisAssem
			mov si,offset buferisAssem
			add si,ax
			mov dx,varRodoReg
			mov byte ptr[si],dh
			inc si
			mov byte ptr[si],dl
			add ax,02h
			mov posBuferisAssem,ax
			jmp @@Dugnas
		@@AssemOp1The04:
			;komanda __poslinkis__ jb SU ZENKLU 1 baitas
			;poslinkis dl
			mov al,dl
			cbw
			mov dx,ax
			mov ax,einamasisPoslinkis
			add ax,dx
				@@AssemOp1The04Conti:
				;komanda __poslinkis__ jb vb 2 baitu
			mov si,offset buferisPosli
			add si,0005d ;"xxxx:----"
			mov dl,00h
			call _PoslinkiBuferin
			mov ax,posBuferisAssem
			mov di,offset buferisAssem
			add di,ax
			cmp varAdresas,00000001b
				jne @@PriesToliauAssemOp1The04
			cmp varSegPref,00000100b
				je @@PriesAdresasTrueTeskAssemOp1The04
			mov dx,varRodoSr
			mov byte ptr DS:[di],dh
			inc di
			mov byte ptr DS:[di],dl
			inc di
			mov byte ptr DS:[di],':'
			inc di
			add ax,03h
				@@PriesAdresasTrueTeskAssemOp1The04:
				cmp varAdresas,00h
				jne @@Op1The04Lauzt
				jmp @@PriesToliauAssemOp1The04
				@@Op1The04Lauzt:
			mov byte ptr DS:[di],'['
			inc di
			inc ax
				@@PriesToliauAssemOp1The04:
			cmp byte ptr DS:[si],'A'
			jae @@UzdekNuliuka
			jmp @@ToliauAssempOp1The04
			@@UzdekNuliuka:
				mov byte ptr DS:[di],'0'
				inc di
				inc ax
			@@ToliauAssempOp1The04:
			mov cx,0004h
			add ax,cx
				push es
					push ds
					pop es
			rep movsb
				pop es
			mov byte ptr DS:[di],'h'
			inc di
			cmp varAdresas,00000001b
				jne @@PabaigaAssemOp1The04
			mov byte ptr ds:[di],']'
			inc ax
				@@PabaigaAssemOp1The04:
			inc ax
			mov posBuferisAssem,ax
			sub si,0004h
			mov cx,0004h
			call _UzpildykTarpais
			jmp @@Dugnas
		@@AssemOp1The05:
			;kom __num__ (int num)
			mov si,offset buferisPosli
			add si,0005d
			mov ax,0000h
			mov al,dl
			mov dl,01h;special 02 simboliu rez
			call _PoslinkiBuferin
			mov di,offset buferisAssem
			mov ax,posBuferisAssem
			add di,ax
			cmp byte ptr DS:[si],'A'
			jb @@ToliauAssempOp1The05
				mov byte ptr DS:[di],'0'
				inc di
				inc ax
			@@ToliauAssempOp1The05:
			mov cx,0002h
			add ax,cx
				push es
					push ds
					pop es
			rep movsb
				pop es
			mov byte ptr DS:[di],'h'
			inc ax
			mov posBuferisAssem,ax
			sub si,0002h
			mov cx,0002h
			call _UzpildykTarpais
			jmp @@Dugnas
		@@AssemOp1The06:
			;__poslinkis__
			mov ax,dx
			cmp varPridekIp,01h
				je @@PridekIp
				jmp @@Tesk06
				@@PridekIp:
			add ax,einamasisPoslinkis
				@@Tesk06:
			mov dl,0000h
			jmp @@AssemOp1The04Conti
		@@AssemOp1The07:
			; __", "__
			mov ax,posBuferisAssem
			mov si,offset buferisAssem
			add si,ax
			mov byte ptr ds:[si], ','
			inc si
			mov byte ptr ds:[si], ' '
			add ax,02h
			mov posBuferisAssem,ax
			;jmp @@AssemOp1The06
			jmp @@Dugnas
		@@AssemOp1The08:
			; nemanau?  ? ?  / ?; __bet__ (bojb [bovb])
			; dabar bus pointerio
			cmp varWord,00000010h
			je @@AssemOp1The08WordFar
			mov ax,c_ptr
			mov si,offset ptr_byte
			mul varWord
			add si,ax
			mov cx,c_ptr
			@@AssemOp1The08Copy:
			mov di,offset buferisAssem
			mov ax,posBuferisAssem
			add di,ax
			add ax,cx
				push es
					push ds
					pop es
				rep movsb
				pop es
			mov posBuferisAssem,ax
			jmp @@Dugnas
			@@AssemOp1The08WordFar:
				mov ax,c_ptrFar
				mov si,offset ptr_wordFar
				mov cx,c_ptrFar
				jmp @@AssemOp1The08Copy
		@@AssemOp1The09:
			;__zenklas__ (custom zenklas is dl)
			mov si,offset buferisAssem
			mov ax,posBuferisAssem
			add si,ax
			mov byte ptr ds:[si],dl
			inc posBuferisAssem
			jmp @@Dugnas
		@@AssemOp1The0A:
			;Nieko nedaro. kaip NOP
			jmp @@Dugnas
	@@AssemOp2:;()form2
		;0B <= ah <= 19h
			cmp ah,0Bh
			jne @@AssemOp2Vari0C
			jmp @@AssemOp2The0B
		@@AssemOp2Vari0C:
			cmp ah,0Ch
			jne @@AssemOp2Vari0D
			jmp @@AssemOp2The0C
		@@AssemOp2Vari0D:
			cmp ah,0Dh
			jne @@AssemOp2Vari0E
			jmp @@AssemOp2The0D
		@@AssemOp2Vari0E:
			cmp ah,0Eh
			jne @@AssemOp2Vari0F
			jmp @@AssemOp2The0E
		@@AssemOp2Vari0F:
			
		jmp @@Dugnas
		
		@@AssemOp2The0B:
			;__BET__ (bojb [bovb])
			mov varAdresas,00000000b
			cmp varWord,00000001b
				jne @@AssemOp2The0BTikBOJB
			jmp @@AssemOp1The06
				@@AssemOp2The0BTikBOJB:
			jmp @@AssemOp1The05
		@@AssemOp2The0C:
			;BX+SI ir t.t.
			mov si,offset varRodoRM
			mov di,offset buferisAssem
			mov ax,posBuferisAssem
			add di,ax
			cmp varSegPref,00000100b
				je @@PriesSkliaustusAssemOp2The0C
			mov dx,varRodoSr
			mov byte ptr DS:[di],dh
			inc di
			mov byte ptr DS:[di],dl
			inc di
			mov byte ptr DS:[di],':'
			inc di
			add ax,03h
				@@PriesSkliaustusAssemOp2The0C:
			mov byte ptr ds:[di],'['
			inc di
			inc ax
			xor cx,cx
			mov cx,cRodoRM
			add ax,cx
				push es
					push ds
					pop es
				rep movsb
				pop es
			mov posBuferisAssem,ax
			jmp @@Dugnas
		@@AssemOp2The0D:
			;uzdeda ']'
			mov si,offset buferisAssem
			mov ax,posBuferisAssem
			add si,ax
			mov byte ptr ds:[si],']'
			inc posBuferisAssem
			jmp @@Dugnas
		@@AssemOp2The0E:
			; __bet__ (bojb -> bojb bovb)
			mov al,dl
			cbw
			mov si,offset buferisPosli
			add si,0005d ;"xxxx:----"
			mov dl,00h
			call _PoslinkiBuferin
			mov di,offset buferisAssem
			mov ax,posBuferisAssem
			add di,ax
			cmp byte ptr DS:[si],'A'
			jb @@ToliauAssempOp2The0E
				mov byte ptr DS:[di],'0'
				inc di
				inc ax
			@@ToliauAssempOp2The0E:
			mov cx,0004h
			add ax,cx
				push es
					push ds
					pop es
				rep movsb
				pop es
			mov byte ptr ds:[di],'h'
			inc ax
			mov posBuferisAssem,ax
			sub si,04d
			mov cx,04h
			call _UzpildykTarpais
			jmp @@Dugnas
			
			
		
		jmp @@Dugnas
	@@Print:
		@@PrintBuferPoslinkis:
					;pop ax ;--------
			mov bx,deskriptoriusIsvestF
			mov cx,cBuferisPosli
			mov dx,offset buferisPosli
			mov ah,40h
			int 21h
			jc @@PrintBuferPoslinkisNepavyko
			jmp @@PrintBuferMasin
		@@PrintBuferPoslinkisNepavyko:
			mov dl,'%'
			mov ah,02
			int 21h
			jmp @@ButHow
		@@PrintBuferMasin:
			mov bx, deskriptoriusIsvestF
			mov dx,offset buferisMasin
			mov cx,cBuferisMasin
			mov ah,40h
			int 21h
			jc @@PrintBuferMasinNepavyko
			jmp @@PrintBuferAssem
		@@PrintBuferMasinNepavyko:
			mov dl,'^'
			mov ah,02
			int 21h
			jmp @@ButHow
		@@PrintBuferAssem:
			mov bx, deskriptoriusIsvestF
			mov dx,offset buferisAssem
			mov cx,cBuferisAssem
			mov ah,40h
			int 21h
			jc @@PrintBuferAssemNepavyko
			jmp @@EiluteBaigta
		@@PrintBuferAssemNepavyko:
			mov dl,'&'
			mov ah,02
			int 21h
			jmp @@ButHow
		@@EiluteBaigta:
			;mov ax,einamasisPoslinkis
			;mov pradinisPoslinkis,ax
			mov si,offset buferisMasin
			mov cx,cBuferisMasin
			;e cia gi ne assem; sub cx,2 ;naujos eilutes nenorim istrinti
			mov dl,00h
			@@Nunulink: ;buferisMasin buferisAssem
				mov byte ptr [si],20h
				inc si
				loop @@Nunulink
			cmp dl,00h
			jne @@EilutePabaik
			inc dl
			mov di,0002h
			mov si,offset buferisAssem
			mov cx,cBuferisAssem
			sub cx,02
			jmp @@Nunulink
			@@EilutePabaik:
				mov posBuferisMasin,0000h
				mov posBuferisAssem,0000h
				mov varAdresas,00000001b
				mov varPtrReikia,00000000b
				mov varSegPref,00000100b
				mov varPrefReikia,00000100b
				mov varPrefSet,00000000b
				mov varPridekIp,00h
				mov si,offset varRodoRM
				mov cx,cRodoRM
				call _UzpildykTarpais
				mov ah,00h ;posl
				call _FormuokOutput
			jmp @@Dugnas
				
				
				
				
				
				
	@@Neapibrezta:
		jmp @@ButHow
	@@ButHow:
		mov ah,09h
		mov dx,offset msgButHow
		int 21h
		mov ax,4c00h
		int 21h
@@Dugnas:
	pop bx
	pop di
	pop si
	pop dx
	pop cx
	pop ax
RET
ENDP
PROC _AlToASCIIHex
	cmp al,0ah
	jb @@PliusNulis
	cmp al,10h
	jb @@PliusIkiUppercaseRaides
	jmp @@Returnas
	@@PliusNulis:
		add al,'0'
		jmp @@Returnas
	@@PliusIkiUppercaseRaides:
		add al,'7'
	@@Returnas:
RET
ENDP
PROC _KokiRegistraRodoVarReg;()rodoreg
push ax
	;atmintyje varReg ir varRodoReg pagal varWord
	mov al,varReg
	cmp varWord,00000001b
	je @@Word
	jmp @@NotWord
	@@Word:
			cmp al,00000000b
			jne @@Word001
			jmp @@AX
		@@Word001:
			cmp al,00000001b
			jne @@Word010
			jmp @@CX
		@@Word010:
			cmp al,00000010b
			jne @@Word011
			jmp @@DX
		@@Word011:
			cmp al,00000011b
			jne @@Word100
			jmp @@BX
		@@Word100:
			cmp al,00000100b
			jne @@Word101
			jmp @@SP
		@@Word101:
			cmp al,00000101b
			jne @@Word110
			jmp @@BP
		@@Word110:
			cmp al,00000110b
			jne @@Word111
			jmp @@SI
		@@Word111:
			cmp al,00000111b
			jne @@NetinkamasVarReg
			jmp @@DI
				@@NetinkamasVarReg:
					mov ah,02h
					mov dx,offset msgNetiketaKlaida
					int 21h
					jmp @@Dugnas
	@@NotWord:
			cmp al,00000000b
			jne @@NWord001
			jmp @@AL
		@@NWord001:
			cmp al,00000001b
			jne @@NWord010
			jmp @@CL
		@@NWord010:
			cmp al,00000010b
			jne @@NWord011
			jmp @@DL
		@@NWord011:
			cmp al,00000011b
			jne @@NWord100
			jmp @@BL
		@@NWord100:
			cmp al,00000100b
			jne @@NWord101
			jmp @@AH
		@@NWord101:
			cmp al,00000101b
			jne @@NWord110
			jmp @@CH
		@@NWord110:
			cmp al,00000110b
			jne @@NWord111
			jmp @@DH
		@@NWord111:
			cmp al,000000111b
			jne @@ShortNetinkamasVarReg
			jmp @@BH
				@@ShortNetinkamasVarReg:
					jmp @@NetinkamasVarReg
		
	@@AX:
		mov ax,r_ax
		mov varRodoReg,ax
		jmp @@Dugnas
	@@CX:
		mov ax,r_cx
		mov varRodoReg,ax
		jmp @@Dugnas
	@@DX:
		mov ax,r_dx
		mov varRodoReg,ax
		jmp @@Dugnas
	@@BX:
		mov ax,r_bx
		mov varRodoReg,ax
		jmp @@Dugnas
	@@SP:
		mov ax,r_sp
		mov varRodoReg,ax
		jmp @@Dugnas
	@@BP:
		mov ax,r_bp
		mov varRodoReg,ax
		jmp @@Dugnas
	@@SI:
		mov ax,r_si
		mov varRodoReg,ax
		jmp @@Dugnas
	@@DI:
		mov ax,r_di
		mov varRodoReg,ax
		jmp @@Dugnas
	@@AL:
		mov ax,r_al
		mov varRodoReg,ax
		jmp @@Dugnas
	@@CL:
		mov ax,r_cl
		mov varRodoReg,ax
		jmp @@Dugnas
	@@DL:
		mov ax,r_dl
		mov varRodoReg,ax
		jmp @@Dugnas
	@@BL:
		mov ax,r_bl
		mov varRodoReg,ax
		jmp @@Dugnas
	@@AH:
		mov ax,r_ah
		mov varRodoReg,ax
		jmp @@Dugnas
	@@CH:
		mov ax,r_ch
		mov varRodoReg,ax
		jmp @@Dugnas
	@@DH:
		mov ax,r_dh
		mov varRodoReg,ax
		jmp @@Dugnas
	@@BH:
		mov ax,r_bh
		mov varRodoReg,ax
		jmp @@Dugnas
		
@@Dugnas:
pop ax
RET
ENDP
PROC _KaRodoVarRM;()rodorm ;()rm
push si
push di
push dx
push cx
	mov varAdresas,00h
	mov al,varRM
	cmp varMod,00000011b
	je @@Registras
			@@Mod00:
				xor cx,cx
				mov si,offset rm_bxsi
				mov dl,al
				mov cl,c_rm
				xor ax,ax
				mov al,dl
				mul cl
				add si,ax
				mov di,offset varRodoRM
					push es
						push ds
						pop es
					rep movsb
					pop es
				cmp varMod,00h
					jne @@TikrinimasNeMod00
				cmp varRM,00000110b
				jne @@TikrinimasVisiemsMod
				jmp @@Tiesioginis
					@@TikrinimasNeMod00:
				cmp varRM,00000110b
					jne @@TikrinimasVisiemsMod
				mov varPrefReikia,00000010b
					@@TikrinimasVisiemsMod:
				cmp varRM,00000010b
				jne @@Mod00Tesk01
				mov varPrefReikia,00000010b
			@@Mod00Tesk01:
				cmp varRM,00000011b
				jne @@Tesk00
				mov varPrefReikia,00000010b
					@@Tesk00:
				mov al,c_rm
				mov posRodoRM,ax
				mov varPoslBSk,00h
	cmp varMod,01h
	je @@Mod01
	cmp varMod,00000010b
	je @@Mod10
	jmp @@Dugnas
		@@Registras:
			mov ah,varReg
			mov dx,varRodoReg
			mov varReg,al
			call _KokiRegistraRodoVarReg
			mov varReg,ah
			mov ax,varRodoReg
			mov varRodoReg,dx
			mov di,offset varRodoRM
			mov byte ptr ds:[di],ah
			inc di
			mov byte ptr ds:[di],al
			mov posRodoRM,02h
			mov varPoslBSk,04h
			jmp @@Dugnas
		@@Mod01:
			mov varPoslBSk,01h
			jmp @@ReikesPoslinkio
		@@Mod10:
			mov varPoslBSk,02h
			jmp @@ReikesPoslinkio	
		@@ReikesPoslinkio:
			mov byte ptr ds:[di],'+'
			inc posRodoRM
			jmp @@Dugnas
		@@Tiesioginis:
			mov varPrefReikia,00000011b
			mov si,offset varRodoRM
			mov cx,cRodoRM
			call _UzpildykTarpais
			mov varPoslBSk,03h
			mov varAdresas,01h
			jmp @@Dugnas
		
@@Dugnas:
pop cx
pop dx
pop di
pop si
RET
ENDP
PROC _ImkOPKgaleREG;()imkreg
push ax
	and al,00000111b
	mov ah,00h
	mov varReg,al
pop ax
RET
ENDP
PROC _ImkOPKvidurySR;()imksr
		push ax
	and al,00011000b
	cmp al,00000000b
	je @@SegES
	cmp al,00001000b
	je @@SegCS
	cmp al,00010000b
	je @@SegSS
	cmp al,00011000b
	je @@SegDS
	jmp @@Dugnas
	@@SegES:
		mov varSegPref,00b
		mov ax,s_es
		jmp @@Dugnas
	@@SegCS:
		mov varSegPref,01b
		mov ax,s_cs
		jmp @@Dugnas
	@@SegSS:
		mov varSegPref,10b
		mov ax,s_ss
		jmp @@Dugnas
	@@SegDS:
		mov varSegPref,11b
		mov ax,s_ds
@@Dugnas:
	mov varRodoSr,ax
	mov varPrefSet,00000001b
		pop ax
RET
ENDP
PROC _ImkOPKgaleDW;()imkdw ;()imkw
		push ax
	and al,00000001b
	mov varWord,al
		pop ax
		push ax
	and al,00000010b
	shr al,1
	mov varDir,al
		pop ax
RET
ENDP
PROC _ImkIsAlBitaAhNuo0Iki7IrGrazinkIAh;()imkcustom
	push dx
	push cx
		mov dl,al
		mov dh,00000001b
		mov cl,ah
		shl dh,cl
		and dl,dh
		shr dl,cl
		mov ah,dl
	pop cx
	pop dx
RET
ENDP
PROC _ImkAdrModRegRM;()imkmodregm ;()imkmod ;()imkreg ;()imkrm
		push ax
	and ah,11000000b
	shr ah,06h
	mov varMod,ah
		pop ax
		push ax
	and ah,00111000b
	shr ah,03h
	mov varReg,ah
		pop ax
		push ax
	and ah,00000111b
	mov varRM,ah
		pop ax
RET
ENDP
PROC _ImituokSegPref;()imisegpref ;()segpref; ()prefreikia
push ax
				mov al,varPrefReikia
				cmp varPrefSet,00000001b
					je @@Dugnas
				mov varSegPref,al
				shl al,03h
				call _ImkOPKvidurySR
				cmp varPrefReikia,00000100b
					jne @@Dugnas
				mov varSegPref,00000100b
	@@Dugnas:
pop ax
RET
ENDP
PROC _PoslinkiBuferin;()buferin
push ax
push si
push dx
push cx
push bx
push di
	;dl - kiek norim reze skaiciu, kai dl=?, tai gausim 4, dl=1 ->2
	;ax - poslinkis
	;si - adresas
	cmp dl,01h
	jne @@FormBuferisPoslinkis
		mov cx,0010h
		mov bx,0010h
		mov di,02h
				push ax;-----------------
		jmp @@Poslinkis3ir4
	@@FormBuferisPoslinkis:
			;bl - kuri is 4 hex skaitmenu spausdinam
			;si - poslinkio buferis,dvitaskis,4tarpai
			;mov si,offset buferisPosli
			mov dx,0000h
			;mov ax,einamasisPoslinkis
			mov cx,1000h
			mov bx,0010h
			mov di,01h
			;0000 0101
			@@Poslinkis1ir2:
				div cx ;0101 0000				;0001 0001
				call _AlToASCIIHex ;0101 0030	;0001 0031
			@@PrintPoslinkis1ir2:
				mov byte ptr DS:[si],al
				inc si
					push ax ;~~~~~~ ;0030		;0031
					push dx ;~~~~~~!! ;0101		;0001
				mov ax,cx
				mov dx,0000h
				div bx
				mov cx,ax ;1000h -> 100h	100h -> 10h
				cmp di,02h
				je @@PrepPoslinkis3ir4
					pop dx ;~~~~~~~!!
					pop ax ;~~~~~~~ siaip sau
				mov ax,dx ;0101 0101
				mov dx,0000h ;0000 0101
				inc di
				jmp @@Poslinkis1ir2
			@@PrepPoslinkis3ir4:
					pop dx ;~~~~~~~!!
					pop ax ;~~~~~~~
					push dx ;~~~~~~			;0001
			@@Poslinkis3ir4:
				inc di
					pop ax ;~~~~~~~~	;0001
					       ;--------
				;mov ah,00h
				;call _AlToASCIIHex
				cmp di,04h
				je @@ApkeiskLiekanaSuDalm
				jmp @@PrintPoslinkis3ir4
				@@ApkeiskLiekanaSuDalm:
					mov al,ah
					mov ah,00h
			@@PrintPoslinkis3ir4:
				div cl  ;dalyba is 10h
				call _AlToASCIIHex
				mov byte ptr DS:[SI],al
				inc si
					push ax ;-------
				mov ax,cx
				div bl ;10h
				mov cx,ax
				cmp di,04h
				jne @@Poslinkis3ir4
					pop ax ;---------
	@@Dugnas:
pop di
pop bx
pop cx
pop dx
pop si
pop ax
RET
ENDP
PROC _UzpildykTarpais
push si
push cx
	zymee:
	@@Main:
		mov byte ptr DS:[si],' '
		inc si
		loop @@Main
pop cx
pop si
ret
ENDP
END