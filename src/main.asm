INCLUDE Irvine32.inc

.data

StartGameMsg BYTE "Game Start!", 0
GoodByeMsg	 BYTE "Thanks for playing", 0
SettingMsg	 BYTE "Open Setting Dialogue",0

stdoutHandle	 DWORD ?
IngameCursorInfo CONSOLE_CURSOR_INFO <1, 0>
NormalCursorInfo CONSOLE_CURSOR_INFO <?, ?>

.code
extern HandleStartMenu: PROC
extern Boot: PROC
extern ShowMap: PROC

main PROC
	call Boot

	cmp eax, 0		; check if window size ok
	jne game_start
	invoke SetConsoleCursorInfo, stdoutHandle, OFFSET NormalCursorInfo
	exit

game_start:
	call HandleStartMenu

	.IF eax == 2
		mov edx, OFFSET GoodByeMsg
		call WriteString
		invoke SetConsoleCursorInfo, stdoutHandle, OFFSET NormalCursorInfo
		exit
	.ELSEIF eax == 0
		mov edx, OFFSET StartGameMsg
		call Game_init
	.ELSEIF eax == 1
		mov edx, OFFSET SettingMsg
		call WriteString
	.ENDIF
	
	ret
main ENDP


END main
