INCLUDE Irvine32.inc


.data
 
.code

extern ShowMap: PROTO
extern ShowPart: PROTO, :WORD, : WORD, : WORD, : WORD

Game PROC USES eax ebx
	LOCAL maxV: WORD
    invoke ShowMap

    mov bx, 0
    mov ecx, 120


game_update_loop:
    mov eax, 50
    call Delay
    mov maxV, bx
    call Clrscr
    invoke ShowPart, 0, 0, maxV, 29

    
    inc bx
    loop game_update_loop

    
    ret
Game ENDP

END
