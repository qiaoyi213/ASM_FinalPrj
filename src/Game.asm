INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC

extern Resource_getMobImgHandle: PROTO, :DWORD
extern Resource_getBGImgBrush: PROTO
extern DrawScore: PROTO, :HDC
Game_draw PROTO, :HWND

.data
Level	            BYTE		0
Life				WORD		5

TimerID				EQU			74
t					DWORD		0

hInstance			HINSTANCE	?
GameClassName		BYTE		"GamePane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>
GameTitle			BYTE		"Game Title", 0
game_hwnd			HWND		?

hdc					HDC			?
hdcBuffer			HDC			?

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
		invoke	SetTimer, hwnd, TimerID, 10, NULL

		invoke	GetDC, hwnd
		mov		hdc, eax
		invoke	CreateCompatibleDC, eax
		mov		hdcBuffer, eax

		; invoke	Level_Load, 1, ADDR Mobs

	.ELSEIF uMsg == WM_PAINT
		invoke  BitBlt, hdc, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT, hdcBuffer,\
				0, 0, SRCCOPY
	
	.ELSEIF uMsg == WM_MOUSEMOVE
		; Detect mouse and attack
		; invoke Detect_Collision, lParam
		; mWriteLn "MOVE"
	.ELSEIF uMsg == WM_TIMER
		.IF t == 9
			mov t, 0
		.ENDIF
		
		invoke Game_draw, hwnd

		inc t
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
	invoke ShowWindow, game_hwnd, SW_SHOW
	invoke UpdateWindow, game_hwnd
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
	
	call	Resource_getBGImgBrush
	INVOKE  SelectObject, hdcBuffer, eax									;選入筆刷
	INVOKE  PatBlt, hdcBuffer, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT, PATCOPY	;填充筆刷

	INVOKE 	DrawScore, hdcBuffer
	ret
Game_draw ENDP

END