INCLUDE Irvine32.inc

.data

StartGameMsg BYTE "Game Start!", 0
GoodByeMsg	 BYTE "Thanks for playing", 0
SettingMsg	 BYTE "Open Setting Dialogue",0

.code
extern HandleStartMenu: PROC
extern ShowMap: PROC
main PROC

	call ShowMap
	
	;call HandleStartMenu

	.IF eax == 2
		mov edx, OFFSET GoodByeMsg
		call WriteString
		exit
	.ELSEIF eax == 0
		mov edx, OFFSET StartGameMsg
		call ShowMap
	.ELSEIF eax == 1
		mov edx, OFFSET SettingMsg
		call WriteString
	.ENDIF
	ret

main ENDP


END main
