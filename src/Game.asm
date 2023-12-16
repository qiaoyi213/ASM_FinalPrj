INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC

extern Resource_getMobImgHandle: PROTO, :Mob
extern Resource_getBGImgHandle: PROTO

extern Level_Load: PROTO, :DWORD, :PTR Mob

extern Slime_update: PROTO, :PTR Mob
extern Slime_hert: PROTO, :PTR Mob, :DWORD
extern Collision_Check: PROTO, :LPARAM, :Mob
extern Life_Sub: PROTO, :DWORD
extern DrawScore: PROTO, :HDC
extern DrawLife: PROTO, :HDC
extern PlotIMG: PROTO, :HDC
Game_draw PROTO, :HWND
DrawMob PROTO, :Mob

.data
Level	            BYTE		0
Life				WORD		5

mobList				Mob			_MOB_LIST_MAX_SIZE DUP(<0, 0, ?, ?, ?, ?, ?>)
mobAmount			DWORD		5

TimerID				EQU			74
t					DWORD		0

hInstance			HINSTANCE	?
GameClassName		BYTE		"GamePane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>
GameTitle			BYTE		"Game Title", 0
game_hwnd			HWND		?

hdc					HDC			?
hdcBuffer			HDC			?

GpInput     		GdiplusStartupInput <1,0,0,0>
hToken        		dd      	?
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
    
	mov eax, game_hwnd

    ret
Game_create ENDP

Game_Process PROC USES ecx, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
    .IF uMsg == WM_CREATE
		invoke	SetTimer, hwnd, TimerID, 100, NULL

		invoke	GetDC, hwnd
		mov		hdc, eax
		invoke	CreateCompatibleDC, eax
		mov		hdcBuffer, eax

		invoke	Level_Load, 1, ADDR mobList
		mov 	mobAmount, ecx

	.ELSEIF uMsg == WM_PAINT
		invoke  BitBlt, hdc, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT, hdcBuffer,\
				0, 0, SRCCOPY
	
	.ELSEIF uMsg == WM_MOUSEMOVE
		; Detect mouse and attack
		; invoke Detect_Collision, lParam
		; mWriteLn "MOVE"
		mov ecx, 5
		mov esi, 0
		__detect_state_loop:
			invoke Collision_Check, lParam, mobList[esi]
			.IF eax == 1
				.IF mobList[esi].state == 3
					mov mobList[esi].state, 1
					invoke Life_Sub, 1
					jmp _mid_2
					_mid_1:
						jmp __detect_state_loop
					_mid_2:
				.ELSEIF mobList[esi].Invincible == 0
					mShow mobList[esi].Invincible
					mov mobList[esi].Invincible, 1
					invoke Slime_hert, ADDR mobList[esi], 25
					mov mobList[esi].state, 1
					
				.ENDIF
			.ENDIF
			add esi, TYPE Mob
		loop _mid_1
		
	.ELSEIF uMsg == WM_TIMER
		call Game_update
		invoke Game_draw, hwnd
		
		invoke InvalidateRect, hwnd, NULL, TRUE

	.ELSEIF uMsg == WM_DESTROY
		invoke  DeleteDC, hdcBuffer
		invoke	ReleaseDC, hwnd, hdc
		mWriteLn "Destory"

    .ENDIF

	invoke  DefWindowProc, hwnd, uMsg, wParam, lParam
    ret
Game_Process ENDP

Game_Show PROC
	invoke   GdiplusStartup,offset hToken,offset GpInput,NULL

	invoke ShowWindow, game_hwnd, SW_SHOW
	invoke UpdateWindow, game_hwnd

	invoke   GdiplusShutdown,hToken
	ret
Game_Show ENDP

Game_Hide PROC
	invoke ShowWindow, game_hwnd, SW_HIDE
	invoke UpdateWindow, game_hwnd
	ret
Game_Hide ENDP

Game_draw PROC USES eax, hwnd :HWND
	INVOKE  CreateCompatibleBitmap, hdc, _WINDOW_WIDTH, _WINDOW_HEIGHT		;以 hdc 為本，建立未初始化的位元圖
	INVOKE  SelectObject, hdcBuffer, eax									;把位元圖選入緩衝區的記憶體設備內容
	

	call DrawBG
	call DrawMobs
	
	INVOKE	DrawLife, hdcBuffer
	INVOKE 	DrawScore, hdcBuffer
	ret
Game_draw ENDP

DrawBG PROC USES eax
	call	Resource_getBGImgHandle
	invoke  CreatePatternBrush, eax
	INVOKE  SelectObject, hdcBuffer, eax
	INVOKE  PatBlt, hdcBuffer, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT, PATCOPY
	ret
DrawBG ENDP

DrawMobs PROC USES ecx esi
	mov ecx, mobAmount
	mov esi, 0

draw_mobs_loop:
	add esi, TYPE Mob
	invoke DrawMob, mobList[esi]
	loop draw_mobs_loop

	ret
DrawMobs ENDP

DrawMob PROC USES eax ebx ecx edx esi edi, mob: Mob
	LOCAL tmpHdc: HDC

	invoke 	CreateCompatibleDC, hdcBuffer
	mov		tmpHdc, eax
	invoke  Resource_getMobImgHandle, mob
	invoke  SelectObject, tmpHdc, eax

	

	mov		eax, 44
	mul		mob.AnimationTick

	invoke  BitBlt, hdcBuffer, mob.X, mob.Y, 44, 30, tmpHdc,\
			eax, 0, SRCCOPY
	
	invoke  DeleteDC, tmpHdc
	ret
DrawMob ENDP

Game_update PROC USES ecx esi edx
	mov ecx, mobAmount
	mov esi, 0

update_mobs_loop:
	invoke Slime_update, ADDR mobList[esi]
	add esi, TYPE Mob
	loop update_mobs_loop

	ret
Game_update ENDP

END