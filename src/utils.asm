INCLUDE Irvine32.inc
INCLUDE macros.inc
.data

.code

WriteStringCenter PROC USES eax ecx edx, StringPtr: PTR BYTE, cwidth: DWORD, cheight: DWORD, leftDecoPtr: PTR BYTE
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
	.IF leftDecoPtr != NULL
		sub  ecx, (LENGTHOF leftDecoPtr + 1)
	.ENDIF
	mov  al, ' '
padding_loop:
	call WriteChar
	loop padding_loop

	.IF leftDecoPtr != NULL
		mov edx, leftDecoPtr
		call WriteString
	.ENDIF

	mov  edx, StringPtr
	call WriteString
	call Crlf
	ret
WriteStringCenter ENDP

SubString PROC USES eax ecx edx esi edi, StringPtr: PTR BYTE, StartPos: DWORD, Len: DWORD,  Result: PTR BYTE

	
	mov esi, StringPtr
	mov edi, Result
	add esi, StartPos

	mov ecx, Len
	cld
	rep movsb

	ret

SubString ENDP


ReadMapFromFile PROC USES eax ecx edx, buffer: PTR BYTE, fileName: PTR BYTE
	LOCAL bytesRead: DWORD
	LOCAL fileHandle: DWORD
	
	; Read File
	mov edx, fileName
    call OpenInputFile
    mov fileHandle, eax    

	mov eax, fileHandle
    mov edx, buffer
    mov ecx, 5000
    call ReadFromFile
    jc show_error_message
    mov bytesRead, eax
	
	;mov edx, buffer
	;call WriteString
	ret

show_error_message: 
	call WriteWindowsMsg
	ret
ReadMapFromFile ENDP

END
