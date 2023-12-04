INCLUDE Irvine32.inc

INCLUDE Macros.inc
INCLUDE Reference.inc

.data

mapFileName		BYTE "data", 0
readMapBuffer	BYTE BUFFER_MAX DUP(?)

.code
	ReadMapFromFile PROTO, :PTR BYTE, :DWORD


ReadMapFromFile PROC USES eax ecx edx, fileNamePtr: PTR BYTE, maxLen: DWORD
	LOCAL bytesRead: DWORD
	LOCAL fileHandle: DWORD

	.IF maxLen >= BUFFER_MAX
		mWriteLn "Given 'maxLen' is too large."
		ret
	.ENDIF
	
	; Read File
	mov edx, fileNamePtr
    call OpenInputFile
    mov fileHandle, eax    

	mov eax, fileHandle
    mov edx, OFFSET readMapBuffer
    mov ecx, maxLen
    call ReadFromFile
    jc show_error_message
    mov bytesRead, eax
	
	; invoke ProcessBuffer, OFFSET buffer
	; call DumpRegs
	mov edx, OFFSET readMapBuffer
	call WriteString
	
; 	mov edx, [Scene]
; 	call WriteString
	ret

show_error_message: 
	call WriteWindowsMsg
	ret
ReadMapFromFile ENDP 

ShowMap PROC USES eax ebx ecx edx
 
	invoke ReadMapFromFile, OFFSET mapFileName, 4000

	ret
ShowMap ENDP

ShowPart PROC USES eax ebx ecx edx, fx: WORD, fy: WORD, tx: WORD, ty: WORD
	LOCAL xLen: WORD
	LOCAL yLen: WORD
	LOCAL x: WORD
	LOCAL y: WORD

	mov ax, tx
	sub ax, fx
	mov xLen, ax
	inc xLen
	
	mov ax, ty
	sub ax, fy
	mov yLen, ax
	inc yLen

	movzx ecx, yLen
	mov ax, fx
	; call DumpRegs
L1:
	push ecx

	movzx ecx, xLen
	mov bx, fy
L2: 
	; call DumpRegs
	invoke GetItem, OFFSET buffer, ax, bx

	inc bx
	loop L2
	mWriteLn " "
	pop ecx

	inc ax
	loop L1

	ret
ShowPart ENDP
END
