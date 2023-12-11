INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC
extern Resource_getMobImgHandle: PROTO, :DWORD

Mob STRUCT
	_type	 		DWORD		?
	X				DWORD		?
	Y				DWORD		?
	HP				DWORD		?
	MoveBias		DWORD		?
	AttackClock		DWORD		?
	AnimationClock	DWORD		?

Mob ENDS

.data
Level	            BYTE		0
Life				WORD		5

Score				BYTE		"0000", 0
ScorePos			RECT		<1000, 20, 1280, 100>

; Mobs				Mob			_MOB_LIST_MAX_SIZE DUP(<>)
TimerID				EQU			74
t					DWORD		0
hInstance			HINSTANCE	?
GameClassName		BYTE		"GamePane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>
GameTitle			BYTE		"Game Title", 0
game_hwnd			HWND		?	

.code
Game_paint PROTO, :HWND
DrawMob PROTO, :HDC, :HDC, :DWORD, :DWORD,:DWORD,  :DWORD

Game_init PROC
    call	main_getHInstance
	mov		hInstance, eax

	mov     GameClass.hInstance, eax
	mov     GameClass.style, NULL
	mov     GameClass.lpfnWndProc, OFFSET Game_Process
	mov     GameClass.hbrBackground, COLOR_WINDOW+1

	invoke  LoadCursor, NULL, IDC_ARROW
	mov     GameClass.hCursor, eax

	invoke  RegisterClassEx, OFFSET GameClass
    
	ret
Game_init ENDP

Game_create PROC, main_hwnd: HWND
    
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

Game_Process PROC, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
    
    .IF uMsg == WM_CREATE
		invoke SetTimer, hwnd, TimerID, 100, NULL
		; invoke Load_Level, OFFSET Mobs
        mWrite "Create Success"

	.ELSEIF uMsg == WM_PAINT
		invoke Game_paint, hwnd
	
	.ELSEIF uMsg == WM_MOUSEMOVE
		; Detect mouse and attack 
	.ELSEIF uMsg == WM_TIMER
		.IF t == 9
			mov t, 0
		.ENDIF
		
		inc t
		invoke InvalidateRect, hwnd, NULL, TRUE
		
    .ENDIF

	invoke  DefWindowProc, hwnd, uMsg, wParam, lParam
    ret
Game_Process ENDP

Game_paint PROC, hwnd: HWND
	LOCAL   hdc: HDC
	LOCAL	hdcMem: HDC
	LOCAL   ps: PAINTSTRUCT

	invoke  BeginPaint, hwnd, ADDR ps
	mov     hdc, eax
	invoke  CreateCompatibleDC, eax  ;110 建立相同的設備內容作為來源
	mov     hdcMem, eax

	invoke DrawText, hdc, OFFSET Score, -1, OFFSET ScorePos, DT_CENTER ; Draw score

	invoke DrawMob, hdc, hdcMem, 500, 400, 0, _MOB_SLIME_ID
	invoke DrawMob, hdc, hdcMem, 800, 400, 0, _MOB_SLIME_ID


	invoke  DeleteDC, hdcMem         ;119 釋放來源設備內容
	invoke  EndPaint, hwnd, ADDR ps   ;120 釋放視窗設備內容
	ret
Game_paint ENDP

DrawMob PROC,hdc: HDC, hdcMem: HDC, X: DWORD, Y:DWORD, Animation:DWORD, MOB_ID: DWORD
	LOCAL hBitmap: DWORD 
	LOCAL imgX: DWORD
 	invoke Resource_getMobImgHandle, MOB_ID ; eax is the handler
	mov hBitmap, eax
	
	invoke  SelectObject, hdcMem, hBitmap     ;112 選定來源設備內容的位元圖
	
	mov eax, 44
	mul t
	mov imgX, eax

	mov     eax, 0
	mov     ecx, imgX

	invoke  BitBlt,hdc,X,Y,44,30,hdcMem,\
			ecx,eax,SRCCOPY         ;118 傳送位元圖到視窗的設備內
	
	ret
DrawMob ENDP

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

END