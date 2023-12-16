INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc

INCLUDE Reference.inc

extern main_getHInstance: PROC

Resource_load PROTO, :PTR BYTE, :PTR PTR GpImage

.data
	GpInput			GdiplusStartupInput <1, 0, 0, 0>
	hToken			DWORD				?
	
	WideNameBuf		WORD		64 DUP(0)
	NameBuf			BYTE		64 DUP(0)
	__resource		BYTE		"resources/", 0
	__PNG			BYTE		".png", 0

	bgImg			DWORD		?
	__bgName		BYTE		"bg", 0

	MobImg			DWORD		(_MOB_STATE_SIZE * _MOB_ID_SIZE) DUP (0)
	__slime0		BYTE 		"slime0", 0
	__slime1		BYTE		"slime1", 0
	__slime2		BYTE		"slime2", 0


.code

Resource_init PROC
	mWriteLn "Resource init"
	invoke	GdiplusStartup, offset hToken, offset GpInput, NULL
	ret
Resource_init ENDP

Resource_cleanUp PROC
	mWriteLn "Resource clean up"
	invoke	GdiplusShutdown, hToken
	ret
Resource_cleanUp ENDP

Resource_load PROC USES eax ebx ecx edx esi edi, name: PTR BYTE, imgPtr: PTR PTR GpImage
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
	ret
Resource_load ENDP

Resource_loadAll PROC USES eax
	invoke Resource_load, OFFSET __bgName, OFFSET bgImg
	invoke Resource_load, OFFSET __slime0, OFFSET MobImg[_MOB_SLIME_ID + _MOB_STATE_SIZE * 0]
	invoke Resource_load, OFFSET __slime1, OFFSET MobImg[_MOB_SLIME_ID + _MOB_STATE_SIZE * 1]
	invoke Resource_load, OFFSET __slime2, OFFSET MobImg[_MOB_SLIME_ID + _MOB_STATE_SIZE * 2]

	ret
Resource_loadAll ENDP

Resource_getBGImg PROC
	mov eax, bgImg
	ret
Resource_getBGImg ENDP

Resource_getMobImg PROC USES ebx, mob: Mob
	mov eax, mob.state
	mov ebx, _MOB_STATE_SIZE
	mul ebx
	add eax, mob._type

	mov ebx, eax
	mov eax, MobImg[ebx]
	mShow eax
	ret
Resource_getMobImg ENDP


END