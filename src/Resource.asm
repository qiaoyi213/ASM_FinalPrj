INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc

INCLUDE Reference.inc

extern main_getHInstance: PROC

Resource_load PROTO, :PTR BYTE, :PTR DWORD

.data
	WideNameBuf		WORD		64 DUP(0)
	NameBuf			BYTE		64 DUP(0)
	__resource		BYTE		"resources/", 0
	__PNG			BYTE		".png", 0

	bgImg			DWORD		?
	__bgName		BYTE		"bg", 0

	heartEmpty		DWORD		?
	__heartEmpty	BYTE		"HeartEmpty", 0
	heartFull		DWORD		?
	__heartFull		BYTE		"HeartFull", 0

	MobImg			DWORD		(_MOB_STATE_SIZE * _MOB_ID_SIZE) DUP (0)
	__slime0		BYTE 		"slime0", 0
	__slime1		BYTE		"slime1", 0
	__slime2		BYTE		"slime2", 0

	LoseImg			DWORD		?
	__LoseImg		BYTE		"Lose", 0

	VictoryImg		DWORD		?
	__VictoryImg	BYTE		"Victory", 0

.code

Resource_load PROC USES eax ebx ecx edx esi edi, name: PTR BYTE, imgPtr: PTR DWORD
format_directory:
	mov esi, OFFSET __resource
	mov edi, OFFSET NameBuf
	mov ecx, LENGTHOF __resource
	rep movsb

	dec edi
	mov esi, name
	mov edx, name
	call StrLength
	mov ecx, eax
	rep movsb

	; dec edi				won't need since StrLength don't count NULL
	mov esi, OFFSET __PNG
	mov ecx, LENGTHOF __PNG
	rep movsb
move_into_WideBuffer:
	mov esi, OFFSET NameBuf
	mov edi, OFFSET WideNameBuf
	.WHILE 1
		mov al, BYTE PTR [esi]
		mov BYTE PTR [edi], al	; tricky
		add esi, TYPE BYTE
		add edi, TYPE WORD
		.BREAK .IF al == 0
	.ENDW
loader:
	invoke GdipLoadImageFromFile, OFFSET WideNameBuf, imgPtr
	mShow eax
	ret
Resource_load ENDP

Resource_loadAll PROC USES eax
	invoke Resource_load, OFFSET __bgName, OFFSET bgImg

	invoke Resource_load, OFFSET __heartEmpty, OFFSET heartEmpty
	invoke Resource_load, OFFSET __heartFull, OFFSET heartFull

	invoke Resource_load, OFFSET __slime0, OFFSET MobImg[(_MOB_SLIME_ID * _MOB_STATE_SIZE + 0) * TYPE DWORD]
	invoke Resource_load, OFFSET __slime1, OFFSET MobImg[(_MOB_SLIME_ID * _MOB_STATE_SIZE + 1) * TYPE DWORD]
	invoke Resource_load, OFFSET __slime2, OFFSET MobImg[(_MOB_SLIME_ID * _MOB_STATE_SIZE + 2) * TYPE DWORD]

	invoke Resource_load, OFFSET __LoseImg, OFFSET LoseImg
	
	invoke Resource_load, OFFSEt __VictoryImg, OFFSET VictoryImg
	ret
Resource_loadAll ENDP

Resource_getBGImg PROC
	mov eax, bgImg
	ret
Resource_getBGImg ENDP

Resource_getMobImg PROC USES ebx, mob: Mob
	mov eax, mob._type
	mov ebx, _MOB_STATE_SIZE
	mul ebx
	add eax, mob.state
	mov ebx, (TYPE DWORD)
	mul ebx

	mov ebx, eax
	mov eax, MobImg[ebx]
	ret
Resource_getMobImg ENDP

Resource_getHeartImg PROC, isFull: DWORD
	.IF isFull == 1
		mov eax, heartFull
	.ELSE
		mov eax, heartEmpty
	.ENDIF
	ret
Resource_getHeartImg ENDP

Resource_getLose PROC
	mov eax, LoseImg
	ret
Resource_getLose ENDP

Resource_getVictory PROC
	mov eax, VictoryImg
	ret
Resource_getVictory ENDP

END