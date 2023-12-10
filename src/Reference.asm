INCLUDE Ervine32.inc

.data
; ----- Indexed String Area
	GAME_NAME	BYTE "the game", 0
	BUTTON		BYTE "BUTTON", 0

	IndexedStrList DWORD \
		OFFSET GAME_NAME,
		OFFSET BUTTON
; -----

.code
GetIndexedStr PROC USES ebx, index: DWORD
	mov ebx, index
	mov eax, IndexedStrList[ebx * SIZEOF DWORD]
	ret
GetIndexedStr ENDP

END