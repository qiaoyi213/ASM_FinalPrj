INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC
.data
Level	            BYTE	0
hInstance				HINSTANCE	?

GameClassName		BYTE		"pane", 0
GameClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET GameClassName,?>
TextPos				RECT		<10, 100, 50, 150>
GameTitle			BYTE		"Game Title", 0

.code

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
    LOCAL game_hwnd: HWND

    
    invoke  CreateWindowEx, NULL, OFFSET GameClassName, OFFSET GameTitle,\
			WS_CHILD or WS_VISIBLE,\
			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			main_hwnd, NULL, hInstance, NULL

    mov game_hwnd, eax

    invoke  ShowWindow, game_hwnd, SW_SHOW
	invoke  UpdateWindow, game_hwnd
    
	mov eax, game_hwnd
    ret
Game_create ENDP

Game_Process PROC, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
    
    .IF uMsg == WM_CREATE
	
        mWrite "Create Success"
		invoke DrawText, hInstance, OFFSET GameTitle, NULL, OFFSET TextPos, DT_CENTER
    .ENDIF

	invoke  DefWindowProc, hwnd, uMsg, wParam, lParam
    ret
Game_Process ENDP

END