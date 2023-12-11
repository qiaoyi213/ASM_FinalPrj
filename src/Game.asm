INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC
extern Resource_getMobImgHandle: PROTO, :DWORD
extern Level_Load: PROTO, level: DWORD, Mobs: PTR Mob
extern Mob_init: PROTO, :PTR Mob, :DWORD, :DWORD, :DWORD, :DWORD
extern Collision_Check: PROTO, :LPARAM, :DWORD, :DWORD
.data
Level	            BYTE		0
Life				WORD		5

Score				BYTE		"0000", 0
ScorePos			RECT		<1000, 20, 1280, 100>

Mobs				Mob			5 DUP(<>)
TimerID				EQU			74
t					DWORD		0
hInstance			HINSTANCE	?
GameClassName		BYTE		"GamePane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>
GameTitle			BYTE		"Game Title", 0
game_hwnd			HWND		?	

.code
Game_paint PROTO, :HWND
DrawMob PROTO, :HDC, :HDC, :DWORD, :DWORD,  :DWORD
DrawMobs PROTO, :HDC, :HDC
Detect_Collision PROTO, :LPARAM

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

Game_Process PROC USES ecx, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
    
    .IF uMsg == WM_CREATE
		invoke SetTimer, hwnd, TimerID, 100, NULL

		invoke Level_Load, 1, ADDR Mobs

		; mov eax, OFFSET Mobs
		
        ; invoke Mob_init,eax, _MOB_SLIME_ID, 500, 50, 100
        ; add eax, TYPE Mob

        ; invoke Mob_init,eax, _MOB_SLIME_ID, 1000, 50, 100
		
		; mShow Mobs[TYPE Mob].X
        mWriteLn "Create Success"

	.ELSEIF uMsg == WM_PAINT
		invoke Game_paint, hwnd
	
	.ELSEIF uMsg == WM_MOUSEMOVE
		; Detect mouse and attack
		invoke Detect_Collision, lParam
		; mWriteLn "MOVE"
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

	invoke DrawMobs, hdc, hdcMem


	invoke  DeleteDC, hdcMem         ;119 釋放來源設備內容
	invoke  EndPaint, hwnd, ADDR ps   ;120 釋放視窗設備內容
	ret
Game_paint ENDP


Detect_Collision PROC USES ecx, lParam:LPARAM

	mov ecx, 5
	mov edi, 0
detect_collision_loop:
	invoke Collision_Check, lParam, Mobs[edi].X, Mobs[edi].Y
	
    .IF eax == 1
		mWrite "ATTACK"
    .ENDIF

	add edi, TYPE Mob
	loop detect_collision_loop
	ret
Detect_Collision ENDP

DrawMobs PROC USES edi ecx eax, hdc, hdcMem

	mov ecx, 5
	mov edi, 0

draw_mobs_loop:
	; mShow ecx
	invoke DrawMob, hdc, hdcMem, Mobs[edi].X, Mobs[edi].Y, Mobs[edi]._type
	add edi, TYPE Mob
	

	loop draw_mobs_loop
	ret 
DrawMobs ENDP

DrawMob PROC USES ecx,hdc: HDC, hdcMem: HDC, X: DWORD, Y:DWORD, MOB_ID: DWORD
	LOCAL hBitmap: DWORD 
	LOCAL imgX: DWORD

 	invoke Resource_getMobImgHandle, MOB_ID ; eax is the handler
	mov hBitmap, eax
	
	; mWriteLn "DRAW MOB"
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