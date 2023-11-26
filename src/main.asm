INCLUDE Irvine32.inc

.data
str1 BYTE "Hello World!",0

.code
extern ShowStartMenu: PROC

main PROC
	call ShowStartMenu
	; call WaitMsg
	; call Window
	
	; mov edx, OFFSET str1
	; call WriteString
	; call Crlf
	; call WaitMsg
	ret
main ENDP


END main