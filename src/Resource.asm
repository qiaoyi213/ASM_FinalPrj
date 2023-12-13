INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

INCLUDE Reference.inc

Resource_load PROTO, :HINSTANCE, :PTR DWORD, :PTR BYTE

.data

bitmapBuffer	BITMAP	<>

BGImgBrush		HBRUSH	?
__BGImg			BYTE	"BGImg"

MobImgBrush		HBRUSH	(_MOB_STATE_SIZE * _MOB_ID_SIZE) DUP (?)
__Slime0		BYTE 	"Slime0", 0
__Slime1		BYTE	"Slime1", 0
__Slime2		BYTE	"Slime2", 0
__Slime3		BYTE	"Slime3", 0

SlimeHandle		DWORD	?

.code

Resource_load PROC USES esi eax, hInstance: HINSTANCE, hBrushPtr: PTR DWORD, resName: PTR BYTE
	; mWriteLn "ld res"
	mov 	esi, hBrushPtr
	invoke  LoadBitmap, hInstance, resName
	; mShow eax
	invoke  CreatePatternBrush, eax
	mov		[esi], eax
	; mShow eax

	ret
Resource_load ENDP

Resource_loadAll PROC, hInstance: HINSTANCE
	; load background
	invoke Resource_load, hInstance, OFFSET BGImgBrush, OFFSET __BGImg

	; load mobs
	invoke Resource_load, hInstance, OFFSET MobImgBrush[_MOB_SLIME_ID + _MOB_STATE_SIZE * 0], OFFSET __Slime0
	invoke Resource_load, hInstance, OFFSET MobImgBrush[_MOB_SLIME_ID + _MOB_STATE_SIZE * 1], OFFSET __Slime1
	invoke Resource_load, hInstance, OFFSET MobImgBrush[_MOB_SLIME_ID + _MOB_STATE_SIZE * 2], OFFSET __Slime2
	invoke Resource_load, hInstance, OFFSET MobImgBrush[_MOB_SLIME_ID + _MOB_STATE_SIZE * 3], OFFSET __Slime3


	invoke  LoadBitmap, hInstance, OFFSET __Slime0
	mov		SlimeHandle, eax

	ret
Resource_loadAll ENDP

Resource_getBGImgBrush PROC
	mov eax, BGImgBrush
	ret
Resource_getBGImgBrush ENDP

Resource_getMobImgBrush PROC USES ebx, mob: Mob
	mov eax, mob.state
	mov ebx, _MOB_STATE_SIZE
	mul ebx
	add eax, mob._type

	mov ebx, TYPE HBRUSH
	mul ebx

	mov ebx, eax
	mov eax, MobImgBrush[ebx]
	ret
Resource_getMobImgBrush ENDP

Resource_getSlimeHandle PROC
	mov eax, SlimeHandle
	ret
Resource_getSlimeHandle ENDP



END