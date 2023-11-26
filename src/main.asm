INCLUDE Irvine32.inc

.data
str1 BYTE "Hello World!",0

.code
extern Window: PROC

main PROC
	call Window
	
	mov edx, OFFSET str1
	call WriteString
	call Crlf
	call WaitMsg
main ENDP


END main