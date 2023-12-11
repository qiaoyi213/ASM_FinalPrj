INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC
extern Resource_getMobImgHandle: PROTO, :DWORD
.data
Level	            BYTE	0
Life				WORD	5

Score				BYTE		"0000", 0
ScorePos			RECT		<1000, 20, 1280, 100>


hInstance			HINSTANCE	?
GameClassName		BYTE		"GamePane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>

GameTitle			BYTE		"Game Title", 0
game_hwnd			HWND		?	
.code
Game_paint PROTO, :HWND

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

        mWrite "Create Success"

	.ELSEIF uMsg == WM_PAINT
		
		invoke Game_paint, hwnd
		; invoke InvalidateRect, hwnd,NULL, TRUE

	.ELSEIF uMsg == WM_MOUSEMOVE
		; Detect mouse 
    .ENDIF

	invoke  DefWindowProc, hwnd, uMsg, wParam, lParam
    ret
Game_Process ENDP

Game_paint PROC, hwnd: HWND
	LOCAL   hdc: HDC
	LOCAL	hdcMem: HDC
	LOCAL   ps: PAINTSTRUCT
	LOCAL hBitmap: DWORD

	invoke  BeginPaint, hwnd, ADDR ps
	mov     hdc, eax
	invoke  CreateCompatibleDC, eax  ;110 建立相同的設備內容作為來源
	mov     hdcMem, eax

	invoke DrawText, hdc, OFFSET Score, -1, OFFSET ScorePos, DT_CENTER ; Draw score
	

	invoke Resource_getMobImgHandle, _MOB_SLIME_ID ; eax is the handler
	
	mov hBitmap, eax

	invoke  SelectObject, hdcMem, hBitmap     ;112 選定來源設備內容的位元圖
	mov     eax, 0
	mov     ecx, 0
	invoke  BitBlt,hdc,300,500,44,30,hdcMem,\
			ecx,eax,SRCCOPY         ;118 傳送位元圖到視窗的設備內容

	
	invoke  DeleteDC, hdcMem         ;119 釋放來源設備內容
	invoke  EndPaint, hwnd, ADDR ps   ;120 釋放視窗設備內容
	ret
Game_paint ENDP

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