INCLUDE Irvine32.inc

.data
; ----- Indexed String Area
	GAME_NAME BYTE "the game"
	

	IndexedStrList DWORD \
		OFFSET GAME_NAME
; -----

.code
GetIndexedStr PROC USES ebx, index: DWORD
	mov ebx, index
	mov eax, IndexedStrList[ebx]
	ret
GetIndexedStr ENDP

END