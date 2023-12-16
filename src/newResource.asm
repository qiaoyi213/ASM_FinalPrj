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
	
	WideNameBuf		WORD		32 DUP(0)
	__PNG			WORD		"P","N","G",0

	bgName			BYTE		"BGImg", 0
	bgImg			DWORD		?

	MobImgHandle	HBITMAP		(_MOB_STATE_SIZE * _MOB_ID_SIZE) DUP (?)
	__Slime0		BYTE 		"Slime0", 0
	__Slime1		BYTE		"Slime1", 0
	__Slime2		BYTE		"Slime2", 0
	__Slime3		BYTE		"Slime3", 0


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
	LOCAL hInstance:	HINSTANCE
	LOCAL hrsrc:		HRSRC
	LOCAL resSize:		DWORD
	LOCAL hGlobalRes:	HGLOBAL

	LOCAL imgBytesPtr:	DWORD
	LOCAL hGlobal:		HGLOBAL
	LOCAL bufferPtr:	DWORD

	mov esi, name
	mov edi, OFFSET WideNameBuf
	.WHILE 1
		mov al, BYTE PTR [esi]
		mov BYTE PTR [edi], al	; tricky
		add esi, TYPE BYTE
		add edi, TYPE WORD
		.BREAK .IF al == 0
	.ENDW

	; call main_getHInstance
	; mov hInstance, eax

	; invoke FindResourceW, hInstance, OFFSET WideNameBuf, OFFSET __PNG
	; mov hrsrc, eax

	; invoke SizeofResource, hInstance, hrsrc
	; mov resSize, eax

	; invoke LoadResource, hInstance, hrsrc
	; mov hGlobalRes, eax

	; invoke LockResource, hGlobalRes
	; mov imgBytesPtr, eax

	; invoke GlobalAlloc

	

	invoke GdipLoadImageFromFile, OFFSET WideNameBuf, imgPtr
	ret
Resource_load ENDP

Resource_loadAll PROC USES eax
	invoke Resource_load, OFFSET bgName, ADDR bgImg
	ret
Resource_loadAll ENDP

Resource_getBGImg PROC
	mov eax, bgImg
	ret
Resource_getBGImg ENDP


Resource_getMobImgHandle PROC USES ebx, mob: Mob
	mov eax, mob.state
	mov ebx, _MOB_STATE_SIZE
	mul ebx
	add eax, mob._type

	mov ebx, eax
	mov eax, MobImgHandle[ebx]
	; mShow eax
	ret
Resource_getMobImgHandle ENDP

Resource_getMobImg PROC USES ebx, mob: Mob
	mov eax, mob.state
	mov ebx, _MOB_STATE_SIZE
	mul ebx
	add eax, mob._type

	mov ebx, eax
	mov eax, MobImgHandle[ebx]
	ret
Resource_getMobImg ENDP


END