INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC
extern Level_Load: PROTO, :DWORD, :PTR Mob
extern Victory_create: PROTO, :HWND
extern Resource_loadAll: PROC
extern Resource_getBGImg: PROC
extern Resource_getMobImg: PROTO, :Mob

extern Slime_update: PROTO, :PTR Mob
extern Slime_hurt: PROTO, :PTR Mob, :DWORD
extern Collision_Check: PROTO, :LPARAM, :Mob
extern Life_Sub: PROTO, :DWORD
extern DrawScore: PROTO, :HDC
extern DrawLife: PROTO, :HDC
extern battle_bgm_play: PROC
extern battle_bgm_close: PROTO
extern Victory_Show: PROC
extern Lose_create: PROTO, :HWND
extern Lose_Show: PROC
extern Life_Change: PROTO, :DWORD
extern Score_Change: PROTO, :DWORD
extern Life_Get: PROC
extern Pause_create: PROTO, :HWND
extern Pause_Show: PROTO

DrawMob PROTO, :Mob
Game_mousemove PROTO, :LPARAM

.data
Level	            BYTE		0

mobList				Mob			_MOB_LIST_MAX_SIZE DUP(<0, 0, ?, ?, ?, ?, ?>)
mobAmount			DWORD		0
levelKilled			DWORD		0

TimerID				EQU			74

hInstance			HINSTANCE	?
GameClassName		BYTE		"GamePane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>
GameTitle			BYTE		"Game Title", 0
game_hwnd			HWND		?

hdc					HDC			?
hdcBuffer			HDC			?
hbitmap				HBITMAP		?
mainGraphic			DWORD		?	; PTR GpGraphics
bufferGraphic		DWORD		?

isInvincible		DWORD		0
invincibleTick		DWORD		0

mainHwnd			HWND		?

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

Game_create PROC USES edx, main_hwnd: HWND
	mWriteLn "GAME CREATE"
	mov edx, main_hwnd
	mov mainHwnd, edx

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
    .IF uMsg == WM_CREATE
		call	Resource_loadAll
		call	battle_bgm_play
		invoke	SetTimer, hwnd, TimerID, 100, NULL

		invoke GetDC, hwnd
		mov hdc, eax
		invoke	GdipCreateFromHDC, hdc, ADDR mainGraphic

		invoke	CreateCompatibleDC, hdc
		mov		hdcBuffer, eax
		invoke	CreateCompatibleBitmap, hdc, _WINDOW_WIDTH, _WINDOW_HEIGHT
		mov		hbitmap, eax
		invoke	SelectObject, hdcBuffer, hbitmap
		invoke	GdipCreateFromHDC, hdcBuffer, ADDR bufferGraphic

		invoke	Level_Load, 1, ADDR mobList
		mov 	mobAmount, ecx
		
		invoke Pause_create, hwnd
		call Game_Hide
		invoke Pause_Show

	.ELSEIF uMsg == WM_PAINT
		call	Game_draw
		invoke	BitBlt, hdc, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT, hdcBuffer, 0, 0, SRCCOPY
	.ELSEIF uMsg == WM_KEYDOWN
		mShow wParam
		.IF wParam == VK_ESCAPE
			mWriteLn "ESC"
			invoke Pause_create, hwnd
			invoke Pause_Show
		.ENDIF
	.ELSEIF uMsg == WM_MOUSEMOVE
		invoke Game_mousemove, lParam
		mov ebx, mobAmount
		.IF levelKilled == ebx
			invoke battle_bgm_close
			invoke Victory_create, mainHwnd
			call Victory_Show
			invoke DestroyWindow, hwnd
		.ENDIF
		call Life_Get
		.IF eax == 0
			invoke battle_bgm_close
			invoke Lose_create, mainHwnd
			call Lose_Show
			invoke DestroyWindow, hwnd
		.ENDIF
	.ELSEIF uMsg == WM_TIMER
		call Game_update
		invoke InvalidateRect, hwnd, NULL, TRUE

	.ELSEIF uMsg == WM_DESTROY
		invoke	GdipDeleteGraphics, bufferGraphic
		invoke	DeleteObject, hbitmap
		invoke	DeleteDC, hdcBuffer
		invoke	GdipDeleteGraphics, mainGraphic
		invoke	ReleaseDC, hwnd, hdc
		call	Game_reset
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

Game_reset PROC
	invoke Life_Change, 5
	invoke Score_Change, 0
	mov levelKilled, 0
	call Randomize
Game_reset ENDP

Game_draw PROC USES eax
	call	DrawBG
	call	DrawMobs
	invoke	DrawLife, bufferGraphic
	invoke 	DrawScore, hdcBuffer
	ret
Game_draw ENDP

DrawBG PROC USES eax
	call 	Resource_getBGImg
	invoke	GdipDrawImageRectI, bufferGraphic, eax, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT
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
	invoke	Resource_getMobImg, mob
	mov		ebx, eax
	mov		eax, mob._width
	mul		mob.AnimationTick
	invoke	GdipDrawImagePointRectI, bufferGraphic, ebx, mob.X, mob.Y, eax, 0, mob._width, mob._height, UnitPixel
	ret
DrawMob ENDP

Game_update PROC USES ecx esi edx
	mov ecx, mobAmount
	mov esi, 0
	
	mov edx, isInvincible
	add invincibleTick, edx
	.IF invincibleTick >= 10
		mov isInvincible, 0
		mov invincibleTick, 0
	.ENDIF

update_mobs_loop:
	invoke Slime_update, ADDR mobList[esi]
	add esi, TYPE Mob
	loop update_mobs_loop

	ret
Game_update ENDP

Game_mousemove PROC USES eax ebx ecx edx esi edi, lParam: LPARAM
	LOCAL isTouched: DWORD
	mov ecx, 0
	mov esi, 0
	.WHILE ecx < mobAmount
		mov isTouched, 0
		invoke Collision_Check, lParam, mobList[esi]
		mov isTouched, eax
		.IF isTouched == 1 && mobList[esi].state == 2
			.IF isInvincible == 0
				invoke Life_Sub, 1
				mov isInvincible, 1
			.ENDIF
		.ENDIF

		.IF isTouched == 1 && mobList[esi].isTouched == 0 && mobList[esi].state <= 1
			mov mobList[esi].isTouched, 1
			invoke Slime_hurt, ADDR mobList[esi], 25
			add levelKilled, eax
		.ENDIF

		.IF isTouched == 0 && mobList[esi].isTouched == 1
			mov mobList[esi].isTouched, 0
		.ENDIF
		mov ebx, mobAmount
		
		inc ecx
		add esi, TYPE Mob
	.ENDW
	ret
Game_mousemove ENDP

game_destory PROC
	invoke DestroyWindow, game_hwnd
	ret
game_destory ENDP

END