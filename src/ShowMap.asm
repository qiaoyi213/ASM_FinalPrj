INCLUDE Irvine32.inc

.data

BUFSIZE = 5000
buffer BYTE BUFSIZE DUP(?)
fileHandle DWORD ?
bytesRead DWORD ?
fileName BYTE "daa", 0
Result BYTE BUFSIZE DUP(?)
Scene DWORD 30 DUP(?) ; 
.code

extern ReadMapFromFile: PROTO :PTR DWORD

ShowMap PROC USES eax ebx ecx edx
 
	invoke ReadMapFromFile, ADDR Scene
	
	
	mov edx, Scene[0]
	call WriteString

	ret

show_error_message:
	call WriteWindowsMsg
	ret

ShowMap ENDP

END
