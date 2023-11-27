INCLUDE Irvine32.inc

.data
	TitleMsg BYTE "Welcome to the game", 0

	OptionMsgStart	BYTE "Start"
	OptionMsgConfig	BYTE "Config"
	OptionMsgExit	BYTE "Exit"
	
	OptionMsg		DWORD OptionMsg, OptionMsgConfig, OptionMsgExit
.code
	extern WriteStringCenter: PROTO, :PTR BYTE, :DWORD, :DWORD

ShowStartMenu PROC
	LOCAL cwidth:	DWORD
	LOCAL cheight:	DWORD

	call GetMaxXY
	movzx eax, dl
	mov  cwidth, eax
	movzx eax, dh
	mov  cheight, eax
	
	; Write Title
	invoke WriteStringCenter, OFFSET TitleMsg, cwidth, cheight

	call Crlf
	call Crlf

	; Write Options
	; invoke OptionSelectorHandler,
	; invoke WriteStringCenter, OFFSET Op, cwidth, cheight
	; call Crlf
	
	ret
ShowStartMenu ENDP
END