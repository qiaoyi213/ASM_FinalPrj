INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

.data
	BMPName			DB			"VBMP", 0

.code
	extern Window_init: PROC

main PROC
	call Window_init
	ret
main ENDP

END main