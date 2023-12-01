INCLUDE Irvine32.inc

.data

BUFSIZE = 5000
buffer BYTE BUFSIZE DUP(?)
fileName BYTE "data", 0
tmp BYTE ?
.code

extern ReadMapFromFile: PROTO, :PTR BYTE, :PTR BYTE
extern GetItem: PROTO, :PTR BYTE, :WORD, :WORD, :PTR BYTE
ShowMap PROC USES eax ebx ecx edx
 
	invoke ReadMapFromFile, OFFSET buffer, OFFSET fileName
	; mov edx, OFFSET buffer
	; call WriteString
	
	invoke GetItem, OFFSET buffer, 0, 0, ADDR tmp

	mov edx, OFFSET tmp
	call WriteString

	ret

ShowMap ENDP

END
