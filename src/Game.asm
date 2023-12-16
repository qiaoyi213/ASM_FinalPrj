INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC

extern Level_Load: PROTO, :DWORD, :PTR Mob

extern Resource_loadAll: PROC
extern Resource_getBGImg: PROC
extern Resource_getMobImg: PROTO, :Mob

; extern Slime_update: PROTO, :PTR Mob
; extern Slime_hert: PROTO, :PTR Mob, :DWORD
; extern Collision_Check: PROTO, :LPARAM, :Mob
; extern Life_Sub: PROTO, :DWORD
; extern DrawScore: PROTO, :HDC
; extern DrawLife: PROTO, :HDC
; extern PlotIMG: PROTO, :HDC
DrawMob PROTO, :Mob

.data
Level	            BYTE		0
Life				WORD		5

mobList				Mob			_MOB_LIST_MAX_SIZE DUP(<0, 0, ?, ?, ?, ?, ?>)
mobAmount			DWORD		0

TimerID				EQU			74

hInstance			HINSTANCE	?
GameClassName		BYTE		"GamePane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>
GameTitle			BYTE		"Game Title", 0
game_hwnd			HWND		?

; cacheImage			DWORD		?	; PTR GpBitmap
; cacheGraphic		DWORD		?	; PTR GpGraphics
mainGraphic			DWORD		?	; PTR GpGraphics

isInvincible		DWORD		0
invincibleTick		DWORD		0

.code

Game_init PROC
    call	main_getHInstance
	mov		hInstance, eax

	mov     GameClass.hInstance, eax
	mov     GameClass.style, NULL
	mov     GameClass.lpfnWndProc, OFFSET Game_Process
	mov     GameClass.hbrBackground, NULL

	invoke  LoadCursor, NULL, IDC_ARROW
	mov     GameClass.hCursor, eax

	invoke  RegisterClassEx, OFFSET GameClass
    
	ret
Game_init ENDP

Game_create PROC, main_hwnd: HWND
	mWriteLn "GAME CREATE"
    invoke  CreateWindowEx, NULL, OFFSET GameClassName, OFFSET GameTitle,\
			WS_CHILD or WS_VISIBLE,\
			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			main_hwnd, NULL, hInstance, NULL

    mov game_hwnd, eax

    invoke  ShowWindow, game_hwnd, SW_HIDE
	invoke  UpdateWindow, game_hwnd

	call Randomize
    
	mov eax, game_hwnd
    ret
Game_create ENDP

Game_Process PROC USES ecx, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	local    @gdip

    .IF uMsg == WM_CREATE
		call	Resource_loadAll
		invoke	SetTimer, hwnd, TimerID, 100, NULL

		invoke	GdipCreateFromHWND, hwnd, ADDR mainGraphic
		; invoke	GdipCreateBitmapFromGraphics, _WINDOW_WIDTH, _WINDOW_HEIGHT, ADDR mainGraphic, ADDR cacheImage

		invoke	Level_Load, 1, ADDR mobList
		mov 	mobAmount, ecx

	.ELSEIF uMsg == WM_PAINT
		; mWriteLn "paint"
		; invoke  BitBlt, hdc, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT, hdcBuffer,\
				; 0, 0, SRCCOPY
	
	.ELSEIF uMsg == WM_MOUSEMOVE
		; mov ecx, 0
		; mov esi, 0
		; .WHILE ecx < mobAmount
		; 	invoke Collision_Check, lParam, mobList[esi]
		; 	.IF eax == 1 && mobList[esi].state == 3
		; 		.IF isInvincible == 0
		; 			invoke Life_Sub, 1
		; 			mov isInvincible, 1
		; 		.ENDIF
		; 	.ENDIF

		; 	.IF eax == 1 && mobList[esi].isTouched == 0
		; 		mov mobList[esi].isTouched, 1
		; 		invoke Slime_hert, ADDR mobList[esi], 25
		; 	.ENDIF

		; 	.IF eax == 0 && mobList[esi].isTouched == 1
		; 		mov mobList[esi].isTouched, 0
		; 	.ENDIF
		; 	inc ecx
		; 	add esi, TYPE Mob
		; .ENDW
		
	.ELSEIF uMsg == WM_TIMER
		; call Game_update
		call Game_draw
		
		invoke InvalidateRect, hwnd, NULL, TRUE

	.ELSEIF uMsg == WM_DESTROY
		invoke	GdipDeleteGraphics, mainGraphic
		mWriteLn "Destory"

    .ENDIF

	invoke  DefWindowProc, hwnd, uMsg, wParam, lParam
    ret
Game_Process ENDP

Game_Show PROC
	invoke ShowWindow, game_hwnd, SW_SHOW
	invoke UpdateWindow, game_hwnd
	ret
Game_Show ENDP

Game_Hide PROC
	invoke ShowWindow, game_hwnd, SW_HIDE
	invoke UpdateWindow, game_hwnd
	ret
Game_Hide ENDP

Game_draw PROC USES eax
	call DrawBG
	call DrawMobs
	; INVOKE	DrawLife, hdcBuffer
	; INVOKE 	DrawScore, hdcBuffer
	ret
Game_draw ENDP

DrawBG PROC USES eax
	call 	Resource_getBGImg
	invoke	GdipDrawImageRectI, mainGraphic, eax, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT
	ret
DrawBG ENDP

DrawMobs PROC USES ecx esi
	mov ecx, 0
	lea esi, mobList

	.WHILE ecx < mobAmount
		invoke DrawMob, Mob PTR [esi]
		add esi, TYPE Mob
		inc ecx
	.ENDW

	ret
DrawMobs ENDP

DrawMob PROC USES eax ebx ecx edx esi edi, mob: Mob
	LOCAL tmpHdc: HDC

	; mShow mob.X

	invoke	Resource_getMobImg, mob
	mov		ebx, eax
	mov		eax, 44
	mul		mob.AnimationTick
	invoke	GdipDrawImagePointRectI, mainGraphic, ebx, mob.X, mob.Y, eax, 0, 44, 30, NULL
	ret
DrawMob ENDP

; Game_update PROC USES ecx esi edx
; 	mov ecx, mobAmount
; 	mov esi, 0
	
; 	mov edx, isInvincible
; 	add invincibleTick, edx
; 	.IF invincibleTick >= 10
; 		mov isInvincible, 0
; 		mov invincibleTick, 0
; 	.ENDIF

; update_mobs_loop:
; 	invoke Slime_update, ADDR mobList[esi]
; 	add esi, TYPE Mob
; 	loop update_mobs_loop

; 	ret
; Game_update ENDP

END