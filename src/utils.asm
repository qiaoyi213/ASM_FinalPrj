INCLUDE Irvine32.inc
INCLUDE macros.inc
.data
fileName BYTE "data", 0
buffer BYTE 5000 DUP(?)
.code

SubString PROTO, StringPtr: PTR BYTE, StartPos: DWORD, Len: DWORD,  Result: PTR BYTE
ProcessBuffer PROTO, :PTR DWORD, :PTR BYTE

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

ReadMapFromFile PROC USES eax ecx edx, MapPtr: PTR DWORD
	LOCAL bytesRead: DWORD
	;LOCAL buffer[5000]: BYTE
	LOCAL fileHandle: DWORD
	
	; Read File
	lea edx, fileName
    call OpenInputFile
    mov fileHandle, eax    

	mov eax, fileHandle
    mov edx, OFFSET buffer
    mov ecx, 5000
    call ReadFromFile
    jc show_error_message
    mov bytesRead, eax
	
	
	; lea edx, buffer
    ; call WriteString
	invoke ProcessBuffer, MapPtr, ADDR buffer
	
	; ret
show_error_message: 
	call WriteWindowsMsg
 		
ReadMapFromFile ENDP

ProcessBuffer PROC USES eax ecx edx, ResultPtr: PTR DWORD, bufferPtr: PTR BYTE
	LOCAL StringLen: DWORD
	LOCAL tmpStr: PTR BYTE

	mov ecx, 30 
	mov esi, 0
	mov edi, ResultPtr
	
copy_substring:	

	call DumpRegs
	invoke SubString, bufferPtr, esi, 120, tmpStr
	
	mov edi, tmpStr
	add esi, 30
	add edi, 4
	loop copy_substring	
ProcessBuffer ENDP

SubString PROC USES eax ecx edx esi edi, StringPtr: PTR BYTE, StartPos: DWORD, Len: DWORD,  Result: PTR BYTE
	LOCAL StringLen: DWORD

	mov edx, StringPtr
	call StrLength
	mov StringLen, eax

	mov esi, StringPtr
	mov edi, Result
	
	mov eax, StringPtr
	mov ebx, 4
	call WriteHexB

	cld
	mov ecx, 120
	rep movsb
	
	mWrite "A"


	mov edx, StringPtr
	call WriteString

	ret
SubString ENDP


END
