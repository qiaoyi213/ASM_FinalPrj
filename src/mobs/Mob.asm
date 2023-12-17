INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE ../Reference.inc

extern Slime_Build: PROTO, :PTR Mob

.data

.code

Mob_spawn PROC USES eax esi, _type: DWORD, mptr: PTR Mob
	mov esi, mptr

	.IF _type == _MOB_SLIME_ID
		invoke Slime_Build, mptr
	.ELSEIF _type == _MOB_TRUNK_ID
		; ...
	.ENDIF

	mov	 eax, _WINDOW_WIDTH
	sub  eax, (Mob PTR [esi])._width
	call RandomRange
	mov (Mob PTR [esi]).X, eax

	mov  eax, _WINDOW_HEIGHT
	sub  eax, (Mob PTR [esi])._height
	call RandomRange
	mov (Mob PTR [esi]).Y, eax

	ret
Mob_spawn ENDP

END