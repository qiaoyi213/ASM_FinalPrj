INCLUDE Irvine32.inc

.data


.code
extern ShowStartMenu: PROC
extern ShowMap: PROC
main PROC
	;call ShowStartMenu
	call ShowMap
	ret
	
main ENDP


END main