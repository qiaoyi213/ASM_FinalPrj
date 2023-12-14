INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE ../Reference.inc

.data
	_width			DWORD	44
	_height			DWORD	30

	AttackEdge		DWORD	50
	AnimationEdges	DWORD	10, 5, 10, 10
.code

Slime_Build PROC, mptr: PTR Mob
	mov esi, mptr

	mov (Mob PTR [esi])._type, _MOB_SLIME_ID
	mov (Mob PTR [esi]).state, 0

	mov (Mob PTR [esi]).HP, 100

	mov (Mob PTR [esi]).AttackTick, 0
	mov (Mob PTR [esi]).AnimationTick, 0

	mov eax, AnimationEdges[0]
	mov (Mob PTR [esi]).AnimationEdge, eax
	mov eax, AttackEdge
	mov (Mob PTR [esi]).AttackEdge, eax

	ret
Slime_Build ENDP

Slime_update PROC USES eax ebx esi, mptr: PTR Mob
	LOCAL state: DWORD
	LOCAL aniTick: DWORD
	LOCAL aniEdge: DWORD
	LOCAL atkTick: DWORD
	LOCAL atkEdge: DWORD
	LOCAL edge: DWORD
	
	mov esi, mptr
	mov eax, (Mob PTR [esi]).state
	mov state, eax
	mov eax, (Mob PTR [esi]).AnimationTick
	mov aniTick, eax
	mov eax, (Mob PTR [esi]).AnimationEdge
	mov aniEdge, eax
	mov eax, (Mob PTR [esi]).AttackTick
	mov atkTick, eax
	mov eax, (Mob PTR [esi]).AttackEdge
	mov atkEdge, eax

	inc aniTick

	.IF state == 0
		inc atkTick
	.ENDIF

	mov eax, aniTick
	mov ebx, aniEdge
	.IF eax >= ebx
		mov aniTick, 0

		.IF state == 2
			mov state, 3
		.ELSEIF state == 3 
			mov state, 0
		.ELSEIF state == 4
			mov state, 0
		.ENDIF
	.ENDIF

	
	mov eax, atkTick
	mov ebx, atkEdge
	.IF eax >= ebx
		mov atkTick, 0
		mov state, 2
		mov aniTick, 0
	.ENDIF
	
	mov eax, state
	mov ebx, AnimationEdges[eax * TYPE DWORD]
	mov aniEdge, ebx
	
	mov eax, state
	mov (Mob PTR [esi]).state, eax
	mov eax, aniTick
	mov (Mob PTR [esi]).AnimationTick, eax
	mov eax, aniEdge
	mov (Mob PTR [esi]).AnimationEdge, eax
	mov eax, atkTick
	mov (Mob PTR [esi]).AttackTick, eax
	mov eax, atkEdge
	mov (Mob PTR [esi]).AttackEdge, eax 

	ret	
Slime_update ENDP

END