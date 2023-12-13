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

MobImgBrush		HBRUSH	_MOB_ID_SIZE DUP (?)

__SlimeImg		BYTE 	"SlimeImg", 0
__SlimeHitImg	BYTE	"SlimeHitImg", 0
__TrunkImg		BYTE 	"TrunkImg", 0
__MushroomImg	BYTE 	"MushroomImg", 0

SlimeBrush		HBRUSH	?

.code

Resource_load PROC USES esi eax, hInstance: HINSTANCE, hBrushPtr: PTR DWORD, resName: PTR BYTE
	mov 	esi, hBrushPtr
	invoke  LoadBitmap, hInstance, resName
	invoke  CreatePatternBrush, eax
	mov		[esi], eax
	
	ret
Resource_load ENDP

Resource_loadAll PROC, hInstance: HINSTANCE
	; load background
	invoke Resource_load, hInstance, OFFSET BGImgBrush, OFFSET __BGImg
	ret
Resource_loadAll ENDP

Resource_getBGImgBrush PROC
	mov eax, BGImgBrush
	ret
Resource_getBGImgBrush ENDP

Resource_getMobImgHandle PROC USES edx, id: DWORD
	mov edx, id
	mov eax, MobImgBrush[edx]

	ret
Resource_getMobImgHandle ENDP

END