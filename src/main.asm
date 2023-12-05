INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc

.data

.code
	extern Window_init: PROC

main PROC
	call Window_init
	ret
main ENDP

END main