INCLUDE Irvine32.inc
INCLUDE macros.inc
.data
fileName BYTE "data", 0
buffer BYTE 5000 DUP(?)
Scene LABEL DWORD; Array of pointer to BYTE 
HeapHandle        HANDLE ?
.code

SubString PROTO, StringPtr: PTR BYTE, StartPos: DWORD, Len: DWORD,  Result: PTR BYTE
ProcessBuffer PROTO,  :PTR BYTE

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

ProcessBuffer PROC USES eax ecx edx esi edi, bufferPtr: PTR BYTE
	
	LOCAL StartPos: DWORD

	mov ecx, 30
	mov StartPos, 0
	mov edi, 0
	
copy_substring:	

    ; 在堆上分配的地址传递给 SubString
    invoke SubString, bufferPtr, StartPos, 120, eax	

	mov edx, eax
	call WriteString

	mov  [Scene + edi], eax ;TODO 

	add StartPos, 120
	add edi, 4 

	invoke HeapFree, HeapHandle, 0, eax
	loop copy_substring	

	ret
ProcessBuffer ENDP


ReadMapFromFile PROC USES eax ecx edx
	LOCAL bytesRead: DWORD
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
	
	
	invoke ProcessBuffer, OFFSET buffer
	call DumpRegs
	
	mov edx, [Scene]
	call WriteString
	ret

show_error_message: 
	call WriteWindowsMsg
	ret
ReadMapFromFile ENDP

END
