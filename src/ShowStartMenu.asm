INCLUDE Irvine32.inc

.data
	WelcomeMsg BYTE "Welcome to the game", 0


.code
__WriteTitle PROC, cwidth: DWORD, cheight: DWORD
	LOCAL WelcomeMsgLen: 	 	DWORD
	LOCAL WelcomeMsgPadding:	DWORD

	mov  edx, OFFSET WelcomeMsg
	call StrLength
	mov  WelcomeMsgLen, eax

	mov  edx, cwidth
	mov  WelcomeMsgPadding, edx
	mov  edx, WelcomeMsgLen
	sub  WelcomeMsgPadding, edx
	mov  edx, WelcomeMsgPadding
	shr  edx, 1
	mov  WelcomeMsgPadding, edx  

	mov  ecx, WelcomeMsgPadding
	mov  al, ' '
padding_loop:
	call WriteChar
	loop padding_loop

	mov  edx, OFFSET WelcomeMsg
	call WriteString
	call Crlf
	ret
__WriteTitle ENDP

ShowStartMenu PROC
	LOCAL cwidth:	DWORD
	LOCAL cheight:	DWORD

	call GetMaxXY
	movzx eax, dl
	mov  cwidth, eax
	movzx eax, dh
	mov  cheight, eax
	
	invoke __WriteTitle, cwidth, cheight
	ret
ShowStartMenu ENDP
END