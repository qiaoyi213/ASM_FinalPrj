INCLUDE Irvine32.inc

.data

W_DOWN	BYTE 0
A_DOWN	BYTE 0
S_DOWN	BYTE 0
D_DOWN	BYTE 0

Q_DOWN	BYTE 0
E_DOWN	BYTE 0
Z_DOWN	BYTE 0
X_DOWN	BYTE 0
C_DOWN	BYTE 0

ESCAPE_DOWN	BYTE 0
ENTER_DOWN	BYTE 0

KeyDownList PTR BYTE \
	; 0 for escape
	OFFSET ESCAPE_DOWN,\
	; 1~4 for w a s d
	OFFSET W_DOWN,\
	OFFSET A_DOWN,\
	OFFSET S_DOWN,\
	OFFSET D_DOWN,\
	; 5~6 for q e
	OFFSET Q_DOWN,\
	OFFSET E_DOWN,\

	; 7~9 for z x c
	OFFSET Z_DOWN,\
	OFFSET X_DOWN,\
	OFFSET C_DOWN,\

	; 10 for enter
	OFFSET ENTER_DOWN


.code

KeyDownHandle PROC USES ebx ecx edx esi edi
	LOCAL hasKeyDown: DWORD

; -- reset flags
	mov esi, KeyDownList
	mov eax, 0
	mov ecx, LENGTHOF KeyDownList
reset_loop:
	mov, [esi+eax], 0
	inc eax
	loop reset_loop
; -- reset flags

	call ReadKey
	; ZF=1 if no key is available,
    ; ZF=0 if a key is read into the following registers:
	; AL  = key's Ascii code (is set to zero for special extended codes)
	; AH  = Virtual scan code
	; DX  = Virtual key code
	; EBX = Keyboard flags (Alt,Ctrl,Caps,etc.)
	jnz  no_key_label

	.IF dx == VK_ESCAPE
		ESCAPE_DOWN = 1
	.ELSEIF dx == VK_RETURN
		ENTER_DOWN = 1
	
	.ELSEIF al == 'W'
		W_DOWN = 1
	.ELSEIF al == 'A'
		A_DOWN = 1
	.ELSEIF al == 'S'
		S_DOWN = 1
	.ELSEIF al == 'D'
		D_DOWN = 1
	
	.ELSEIF al == 'Q'
		Q_DOWN = 1
	.ELSEIF al == 'E'
		E_DOWN = 1


	.ELSEIF al == 'Z'
		Z_DOWN = 1
	.ELSEIF al == 'X'
		X_DOWN = 1
	.ELSEIF al == 'C'
		C_DOWN = 1
	.ENDIF

	mov eax, 0
	jmp ret_label

no_key_label:
	mov eax, 1
ret_label:
	ret
KeyDownHandle ENDP

CheckKeyDown PROC USES ebx, keycode: BYTE
	movzx ebx, keycode
	mov eax, KeyDownList[keycode]
	
	ret
CheckKeyDown ENDP