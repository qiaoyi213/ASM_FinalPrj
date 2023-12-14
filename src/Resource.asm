INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

INCLUDE Reference.inc

Resource_load PROTO, :HINSTANCE, :PTR DWORD, :PTR BYTE

.data

bitmapBuffer	BITMAP	<>

BGImgHandle		HBITMAP	?
__BGImg			BYTE	"BGImg"

MobImgHandle	HBITMAP	(_MOB_STATE_SIZE * _MOB_ID_SIZE) DUP (?)
__Slime0		BYTE 	"Slime0", 0
__Slime1		BYTE	"Slime1", 0
__Slime2		BYTE	"Slime2", 0
__Slime3		BYTE	"Slime3", 0

.code

Resource_load PROC USES esi eax, hInstance: HINSTANCE, hPtr: PTR DWORD, resName: PTR BYTE
	mov 	esi, hPtr
	; invoke  LoadBitmap, hInstance, resName
	invoke	LoadImage, hInstance, resName, IMAGE_BITMAP,\
			NULL, NULL, LR_CREATEDIBSECTION
	; mShow eax
	
	mov		[esi], eax
	invoke  GetObject, [esi], SIZEOF bitmapBuffer, OFFSET bitmapBuffer	
	ret
Resource_load ENDP

Resource_loadAll PROC, hInstance: HINSTANCE
	; load background
	invoke Resource_load, hInstance, OFFSET BGImgHandle, OFFSET __BGImg

	; load mobs
	invoke Resource_load, hInstance, OFFSET MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 0], OFFSET __Slime0
	invoke Resource_load, hInstance, OFFSET MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 1], OFFSET __Slime1
	invoke Resource_load, hInstance, OFFSET MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 2], OFFSET __Slime2
	invoke Resource_load, hInstance, OFFSET MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 3], OFFSET __Slime3
	
	; mShow MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 0]
	; mShow MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 1]
	; mShow MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 2]
	; mShow MobImgHandle[_MOB_SLIME_ID + _MOB_STATE_SIZE * 3]

	ret
Resource_loadAll ENDP

Resource_getBGImgHandle PROC
	mov eax, BGImgHandle
	ret
Resource_getBGImgHandle ENDP

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



END