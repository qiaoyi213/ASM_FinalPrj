INCLUDE Irvine32.inc

.data

.code
WriteStringCenter PROC USES eax ecx edx, StringPtr: PTR BYTE, cwidth: DWORD, cheight: DWORD
	LOCAL StringLen: 	 	DWORD
	LOCAL StringPadding:	DWORD

	mov  edx, StringPtr
	call StrLength
	mov  StringLen, eax

	mov  edx, cwidth
	mov  StringPadding, edx
	mov  edx, StringLen
	sub  StringPadding, edx
	mov  edx, StringPadding
	shr  edx, 1
	mov  StringPadding, edx  

	mov  ecx, StringPadding
	mov  al, ' '
padding_loop:
	call WriteChar
	loop padding_loop

	mov  edx, StringPtr
	call WriteString
	call Crlf
	ret
WriteStringCenter ENDP
END