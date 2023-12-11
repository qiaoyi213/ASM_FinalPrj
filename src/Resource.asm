INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

INCLUDE Reference.inc

Resource_load PROTO, :HINSTANCE, :PTR DWORD, :PTR BYTE

.data

bitmapBuffer	BITMAP	<>

MobImgHandles	DWORD	_MOB_ID_SIZE DUP (?)

__SlimeImg		BYTE 	"SlimeImg", 0
__TrunkImg		BYTE 	"TrunkImg", 0
__MushroomImg	BYTE 	"MushroomImg", 0

.code

Resource_load PROC USES esi, hInstance: HINSTANCE, hPtr: PTR DWORD, resName: PTR BYTE
	
	mov     esi, hPtr
	invoke  LoadBitmap, hInstance, resName
	
	mov [esi], eax
	
	invoke  GetObject, [esi], SIZEOF bitmapBuffer, OFFSET bitmapBuffer
	
	ret
Resource_load ENDP

Resource_loadAll PROC, hInstance: HINSTANCE
	; load mob images
	invoke Resource_load, hInstance, OFFSET MobImgHandles[_MOB_SLIME_ID], OFFSET __SlimeImg
	
	ret
Resource_loadAll ENDP

Resource_getMobImgHandle PROC USES edx, id: DWORD
	mov edx, id
	mov eax, MobImgHandles[edx]
	; mShow eax

	ret
Resource_getMobImgHandle ENDP

END