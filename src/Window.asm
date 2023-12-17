INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc

INCLUDE Reference.inc

extern main_getHInstance: PROC
extern StartMenu_create: PROTO, :HWND
extern Lose_create: PROTO, :HWND
extern Victory_create: PROTO, :HWND
extern Pause_create: PROTO, :HWND

extern Pause_Show: PROC

Window_Process PROTO, :HWND, :UINT, :WPARAM, :LPARAM
Window_Paint PROTO, :HWND
Window_MouseMove PROTO, :LPARAM

.data
hInstance			HINSTANCE	?

windowClassName		BYTE		"GameWindow", 0
windowClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET windowClassName,?>

windowTitle			BYTE		"The Game", 0
 
CURName				DB			"cursorFile", 0
hCursor				HCURSOR		?
mouseX				DWORD		?
mouseY				DWORD		?

.code

Window_init PROC
	; fetch the main instance
	call	main_getHInstance
	mov		hInstance, eax

	mov     windowClass.hInstance, eax
	mov     windowClass.style, NULL
	mov     windowClass.lpfnWndProc, OFFSET Window_Process
	mov     windowClass.hbrBackground, COLOR_WINDOW+1

	; invoke  LoadImage, hInstance, OFFSET CURName, IMAGE_CURSOR, 60,60, LR_DEFAULTCOLOR  ; 讀取游標圖示


	mov hCursor, eax
	mShow hCursor
	invoke 	SetCursor, hCursor


	invoke  RegisterClassEx, OFFSET windowClass
	ret
Window_init ENDP

Window_create PROC
	LOCAL	hwnd:	HWND

	invoke  CreateWindowEx, NULL, OFFSET windowClassName, OFFSET windowTitle,\
			WS_OVERLAPPEDWINDOW xor WS_THICKFRAME,\
			CW_USEDEFAULT, CW_USEDEFAULT, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			NULL, NULL, hInstance, NULL
	mov     hwnd, eax

	invoke  ShowWindow, hwnd, SW_SHOWDEFAULT
	invoke  UpdateWindow, hwnd

	mov eax, hwnd
	ret
Window_create ENDP

Window_handleMsg PROC
	LOCAL msg: MSG
	
message_handling:
	invoke  GetMessage, ADDR msg, NULL, 0, 0
	cmp     eax, 0
	jz      message_quit
	invoke  TranslateMessage, ADDR msg
	invoke  DispatchMessage, ADDR msg
	jmp     message_handling

message_quit:
	mov     eax, msg.wParam
	
	ret
Window_handleMsg ENDP

Window_Process PROC, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	.IF uMsg == WM_CREATE
		invoke StartMenu_create, hwnd
		invoke Victory_create, hwnd
		invoke Lose_create, hwnd
		invoke Pause_create, hwnd
		; call Pause_Show

	.ELSEIF uMsg == WM_DESTROY
		invoke  PostQuitMessage, NULL
		mov eax, 0
		ret
	.ENDIF
msg_process:
    invoke  DefWindowProc, hwnd, uMsg, wParam, lParam

	ret
Window_Process ENDP

END