INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
	TitleMsg BYTE "Welcome to the game", 0

	OptionMsgStart	BYTE "Start", 0
	OptionMsgConfig	BYTE "Setting", 0
	OptionMsgExit	BYTE "Close", 0
	OptionSelector	BYTE "> ", 0

	OptionMsgs		DWORD OFFSET OptionMsgStart, OFFSET OptionMsgConfig, OFFSET OptionMsgExit
	NowSelected	DWORD 0
.code
	extern WriteStringCenter: PROTO, :PTR BYTE, :DWORD, :DWORD, :PTR BYTE

	ShowStartMenu PROTO, :DWORD, :DWORD

HandleStartMenu PROC USES ebx ecx edx
	LOCAL cwidth:	DWORD
	LOCAL cheight:	DWORD

	call Clrscr

	call GetMaxXY
	movzx eax, dl
	mov  cwidth, eax
	movzx eax, dh
	mov  cheight, eax

	invoke ShowStartMenu, cwidth, cheight
	
key_listening_loop:
	mov  eax, 50
    call Delay

	call ReadKey
	; ZF=1 if no key is available,
    ; ZF=0 if a key is read into the following registers:
	; AL  = key's Ascii code (is set to zero for special extended codes)
	; AH  = Virtual scan code
	; DX  = Virtual key code
	; EBX = Keyboard flags (Alt,Ctrl,Caps,etc.)
    jz   key_listening_loop      ; no key pressed yet

	.IF dx == VK_DOWN || dx == VK_UP
		push ebx
		mov ebx, NowSelected

		.IF dx == VK_DOWN && ebx < 2
			inc ebx
		.ENDIF

		.IF dx == VK_UP && ebx > 0
			dec ebx
		.ENDIF

		mov NowSelected, ebx
		call Clrscr
		invoke ShowStartMenu, cwidth, cheight

		pop ebx
	.ENDIF
	
	.IF dx == VK_RETURN
		call Clrscr
		mov eax, NowSelected
		ret
	.ENDIF

	cmp    dx, VK_ESCAPE  ; time to quit?
    jne    key_listening_loop    ; no, go get next key.
	ret
HandleStartMenu ENDP

ShowStartMenu PROC,
	cwidth: DWORD,
	cheight: DWORD

	; Write Title
	invoke WriteStringCenter, OFFSET TitleMsg, cwidth, cheight, NULL

	call Crlf
	call Crlf

	; Write Options
	mov ecx, LENGTHOF OptionMsgs
	mov eax, 0
print_option_loop:
	mov edx, OptionMsgs[eax * TYPE OptionMsgs]
	
	.IF eax == NowSelected
		invoke WriteStringCenter, edx, cwidth, cheight, OFFSET OptionSelector
	.ELSE
		invoke WriteStringCenter, edx, cwidth, cheight, NULL
	.ENDIF

	inc eax
	loop print_option_loop
	
	ret
ShowStartMenu ENDP
END
