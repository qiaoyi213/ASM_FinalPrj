INCLUDE Irvine32.inc

.data

BUFSIZE = 5000
buffer BYTE BUFSIZE DUP(?)
fileName BYTE "data", 0
.code

extern ReadMapFromFile: PROTO, :PTR BYTE, :PTR BYTE

ShowMap PROC USES eax ebx ecx edx
 
	invoke ReadMapFromFile, OFFSET buffer, OFFSET fileName
	mov edx, OFFSET buffer
	call WriteString
	ret

ShowMap ENDP

END
