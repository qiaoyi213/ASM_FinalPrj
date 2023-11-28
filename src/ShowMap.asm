INCLUDE Irvine32.inc

.data

BUFSIZE = 5000
buffer BYTE BUFSIZE DUP(?)
fileHandle DWORD ?
bytesRead DWORD ?
fileName BYTE "daa", 0
Result BYTE BUFSIZE DUP(?)
Scene DWORD 30 DUP(?) 
.code

extern ReadMapFromFile: PROTO 

ShowMap PROC USES eax ebx ecx edx
 
	invoke ReadMapFromFile

	ret

ShowMap ENDP

END
