INCLUDE Irvine32.inc

.data

BUFSIZE = 5000
buffer BYTE BUFSIZE DUP(?)
fileHandle DWORD ?
bytesRead DWORD ?
fileName BYTE "data", 0
Result BYTE BUFSIZE DUP(?)

.code
COORD STRUCT
	X WORD ?
	Y WORD ?
COORD ENDS


extern SubString: PROTO , StringPtr: PTR BYTE, StartPos: DWORD, Len: DWORD,  Result: PTR BYTE

ShowMap PROC USES eax ebx ecx edx, StartPos: COORD, cWidth: DWORD, cHeight:DWORD
	
 
	長 = 總數/總共有多少 Row
	mov ecx, StartPos.Y 
	
L1:
	output substring from esi to esi+StartPos.X
	add esi, 長

	loop L1
	


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