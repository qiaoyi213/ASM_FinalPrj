INCLUDE Irvine32.inc


.data

level		DWORD 1
isInRoom	DWORD 0

 
.code

Game_init PROC
	
Game_init ENDP

Game_loop PROC USES eax
main_loop:	; expect to be 20 fps
	call KeyHandle

	call Game_Render
	
	call Game_Moving
	
	mov  eax, 50
    call Delay

	ret
Game_loop ENDP

Game_Render PROC
	; call ShowMap
	; call Player_Render
	; call Enimies_Render
	; call Projectiles_Render

	ret
Game_Render ENDP

Game_Moving PROC
	; call Player_moving
	; call Enimies_moving
	; call Projectiles_moving

	ret
Game_Moving ENDP

Game_getLevel PROC
	mov eax, level
	ret
Game_getLevel ENDP


END
