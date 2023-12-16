INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE ../Reference.inc

extern Score_Add :PROTO, :DWORD
extern slime_hit_play: PROC
extern slime_dead_play: PROC
.data
	AttackEdge		DWORD	50
	AnimationEdges	DWORD	10, 5, 10, 10
	
.code

Slime_Build PROC, mptr: PTR Mob
	mov esi, mptr

	mov (Mob PTR [esi])._type, _MOB_SLIME_ID
	mov (Mob PTR [esi]).state, 0

	mov (Mob PTR [esi])._width, 44
	mov (Mob PTR [esi])._height, 30

	mov (Mob PTR [esi]).HP, 100

	mov (Mob PTR [esi]).AttackTick, 0
	mov (Mob PTR [esi]).AnimationTick, 0

	mov eax, AnimationEdges[0]
	mov (Mob PTR [esi]).AnimationEdge, eax
	mov eax, AttackEdge
	mov (Mob PTR [esi]).AttackEdge, eax

	mov (Mob PTR [esi]).isTouched, 0
	ret
Slime_Build ENDP

Slime_update PROC USES eax ebx esi, mptr: PTR Mob
	LOCAL state: DWORD
	LOCAL aniTick: DWORD
	LOCAL aniEdge: DWORD
	LOCAL atkTick: DWORD
	LOCAL atkEdge: DWORD
	
	
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

	.IF state == 4
		ret
	.ENDIF

	mov eax, aniTick
	mov ebx, aniEdge
	.IF eax >= ebx
		mov aniTick, 0
		.IF state == 2
			mov state, 3
		.ELSEIF state == 3 
			mov state, 0
		.ELSEIF state == 1
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

Slime_hert PROC USES eax esi, mptr: PTR Mob, MATK: DWORD
	mov esi, mptr
	mov eax, (Mob PTR [esi]).HP
	sub eax, MATK

	mov (Mob PTR [esi]).HP, eax
	mShow (Mob PTR [esi]).HP
	call slime_hit_play
	.IF (Mob PTR [esi]).HP <= 0
		mov (Mob PTR [esi]).state, 4
		invoke Score_Add, 100
		call slime_dead_play
		mWriteLn "DEAD"
	.ENDIF

	ret
Slime_hert ENDP
END