INCLUDE Irvine32.inc

.data

BUFSIZE = 5000
buffer BYTE BUFSIZE DUP(?)
fileHandle DWORD ?
bytesRead DWORD ?
fileName BYTE "data", 0
Result BYTE BUFSIZE DUP(?)

.code

extern SubString: PROTO , StringPtr: PTR BYTE, StartPos: DWORD, Len: DWORD,  Result: PTR BYTE

ShowMap PROC USES eax ebx ecx edx 
    LOCAL cwidth: DWORD
	LOCAL cheight: DWORD
    
    call GetMaxXY
    movzx eax, dl
	mov  cwidth, eax
	movzx eax, dh
	mov  cheight, eax


	mov edx, OFFSET fileName
	call OpenInputFile
	mov fileHandle, eax

	mov eax, fileHandle
	mov edx, OFFSET buffer
	mov ecx, BUFSIZE
	call ReadFromFile
	jc show_error_message
	mov bytesRead, eax

    invoke SubString, OFFSET buffer,0, 5, OFFSET Result

    mov edx, OFFSET Result
	call WriteString

	ret

show_error_message:
	call WriteWindowsMsg
	ret

ShowMap ENDP

END