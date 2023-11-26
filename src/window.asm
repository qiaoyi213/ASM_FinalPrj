INCLUDE Irvine32.inc

.data
	str2 BYTE "abcd",0

.code
Window PROC
	mov edx, OFFSET str2
	call WriteString
Window ENDP

END