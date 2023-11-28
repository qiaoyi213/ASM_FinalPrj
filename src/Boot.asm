INCLUDE Irvine32.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

.code
Boot PROC
	call Boot_CheckWindowSize
	
	.IF eax == 0
		mWriteLn "Your console window is too small."
		mWriteLn "Please resize the window then restart the game."
	.ENDIF

	ret
Boot ENDP

Boot_CheckWindowSize PROC USES ebx ecx edx
	LOCAL cwidth:	DWORD
	LOCAL cheight:	DWORD

	call GetMaxXY
	movzx ebx, dl
	mov  cwidth, ebx
	mov  cheight, eax

	.IF cwidth < GAME_WIDTH || cheight < GAME_HEIGHT
		mov eax, 0	
	.ENDIF
	ret
Boot_CheckWindowSize ENDP

END
