.model small
buferioDydis	EQU	121
BSeg SEGMENT

	ORG	100h
	ASSUME ds:BSeg, cs:BSeg, ss:BSeg


Pradzia:

;xor ax,bx
;xor ax,[bx+1]

; ret
; inc ax
; dec cx
; push dx
; pop bx
; inc ax
; dec bp
; pop si
; pop di
; retf
; jo Pradzia
; jno Pradzia
; jb Pradzia
; jae Pradzia
; je Pradzia
; jne Pradzia
; jbe Pradzia
; ja Pradzia
; js Pradzia
; jns Pradzia
; jp Pradzia
; jnp Pradzia
; jl Pradzia
; jge Pradzia
; jle cs:[0100h] 
; jg Pradzia
; int 21h
; push es
; push cs
; pop ss
; pop ds
; je CS:[00133h]
; ret 05543h
; retf 0FEDCh
; mov al,skaicius
; mov skaiciusw,ax
; cmp ax,0123h
; cmp al,12h
; add ax,0aaFFh
; add al,69h
; mov ah,09h
; mov bx,0ABCDh
; sub ax,0ABCDh
; sub al,89h
; loop Pradzia
; RET
; mov si,offset skaicius
; pop [bp+di+0FE89h]
; pop [si]
 ;call cs:[5555h]
; jmp CS:[0FEdch]
 ;call DS:[0DCBAh] 
; mov al,ds:[di]
; add ds:[0156h],0F579h
; mov al,ds:[0a633h]
; inc word ptr [bx+si+0FF8Bh]
; dec byte ptr [bx+di]
; dec byte ptr [bp+si]
; dec byte ptr [bp+di]
; dec byte ptr [si]
; dec byte ptr [di]
 ; add word ptr ds:[0107h],0FF84h
 ; add byte ptr ds:[0106h],0FFh
 ; add byte ptr ds:[0106h],bh
 ; add ah,al
 ; sub byte ptr [bx],0FEh
; cmp       word ptr ss:[BP+SI+0FEACh], 0FFAAh  
; dec       byte ptr ss:[  BP +0FEDDh]          
; cmp       byte ptr ds:[0A663h], 10h           
; mov       di, 005Ah                           
; mov       word ptr ss:[BP+DI+0FEAAh], 005Ah   
; add       byte ptr ds:[1234h], ah             
; add       ah, byte ptr ds:[1234h]             
; sub       word ptr ds:[0FABCh], di            
; sub       si, word ptr ds:[0FFBCh]            
; cmp       word ptr cs:[0079h], bp             
; cmp       bh, byte ptr cs:[0080h]             
; mov       word ptr ss:[0079h], bp             
; mov       dh, byte ptr ss:[0080h]             
; mov       al, byte ptr cs:[  SI +0080h]       
; mov       ss, word ptr ds:[0137h]             
; mov       word ptr ss:[BX+SI+0FF80h], ss      
; jmp       word ptr ss:[  BP +0123h]           
; jmp       word ptr [  SI +0FFFFh]             
; jmp       word ptr [BX+SI+1C0Bh]              
; jmp       word ptr [BX+SI+0FFFEh]             
 ;call      word ptr ss:[BP+DI+0123h]  
; call      0BCABh
;call ;0BCABh
; add       word ptr [  SI  ], 0F579h           
; sub       word ptr ds:[0208h], 0F689h         
; cmp       word ptr ds:[0309h], 0F799h         
; mul       word ptr ds:[0FA99h]                
; pop       ax                                  
; mov       al, 0A3h                            
; div       word ptr ss:[BP+DI ]                

    POPF			;Išimame pakoreguotą reikšmę į SF; Nuo čia TF=1
	NOP			;Pirmas pertraukimas kyla ne prieš šią komandą, o po jos; todėl tiesiog vieną komandą nieko nedarome
	
	MOV	ax, bx	

kazkur:
 ;skaicius db 40h
 ;skaiciusw dw 5040h
 ;callIsorTies db 9Ah, 78h, 56h, 34h, 12h ;9A78563412
 ;jmpIsorTies db 0EAh, 78h, 56h, 34h, 12h ;EA78563412
 ;callIsorNeties db 0FFh, 9Ah, 30h, 20h ;FF9A3020
 ;jumpIsorNeties db 0ffh,68h,0ffh ;FF68FF
 ;calll db 0E8h,0ABh,0BCh

BSeg ENDS
END Pradzia