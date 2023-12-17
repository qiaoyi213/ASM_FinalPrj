INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE ../Reference.inc

extern GetIndexedStr: PROTO, :PTR BYTE
extern Score_Add :PROTO, :DWORD
extern slime_hit_play: PROC
extern slime_dead_play: PROC
extern slime_hit_close: PROC
extern slime_dead_close: PROC

.data
	AttackEdge		DWORD	50
	AnimationEdges	DWORD	10, 5, 10, 20
.code

Slime_Build PROC USES eax esi, mptr: PTR Mob
	mov esi, mptr

	mov (Mob PTR [esi])._type, _MOB_SLIME_ID
	mov (Mob PTR [esi]).state, 0

	mov (Mob PTR [esi])._width, 44
	mov (Mob PTR [esi])._height, 30

	mov (Mob PTR [esi]).HP, 100

	; random attack tick
	mov eax, AttackEdge
	shr eax, 1
	call RandomRange

	mov (Mob PTR [esi]).AttackTick, eax
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

	.IF state == _MOB_STATE_SIZE
		ret
	.ENDIF

	mov eax, aniTick
	mov ebx, aniEdge
	.IF eax >= ebx
		mov aniTick, 0
		.IF state == 1
			mov state, 2
		.ELSEIF state == 2
			mov state, 0
		.ENDIF
	.ENDIF

	mov eax, atkTick
	mov ebx, atkEdge
	.IF eax >= ebx
		mov atkTick, 0
		mov state, 1
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

Slime_hurt PROC USES esi, mptr: PTR Mob, MATK: DWORD
	mov esi, mptr
	mov eax, (Mob PTR [esi]).HP
	sub eax, MATK

	mov (Mob PTR [esi]).HP, eax
	mov eax, 0
	call slime_hit_close
	call slime_hit_play
	.IF (Mob PTR [esi]).HP <= 0
		mov (Mob PTR [esi]).state, _MOB_STATE_SIZE
		invoke Score_Add, 100
		call slime_dead_close
		call slime_dead_play
		mWriteLn "DEAD"
		mov eax, 1
	.ENDIF

	ret
Slime_hurt ENDP
END