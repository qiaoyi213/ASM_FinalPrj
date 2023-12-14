INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc

INCLUDE Reference.inc

extern main_getHInstance: PROC
extern Resource_loadAll: PROTO, :HINSTANCE
extern StartMenu_create: PROTO, :HWND

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
		invoke Resource_loadAll, hInstance
		
		invoke StartMenu_create, hwnd

	.ELSEIF uMsg == WM_MOUSEMOVE
		invoke Window_MouseMove, lParam

	.ELSEIF uMsg == WM_PAINT
		invoke Window_Paint, hwnd

	.ELSEIF uMsg == WM_SETCURSOR
		mov eax, lParam
		.IF ax == HTCLIENT
			invoke SetCursor, hCursor
			ret
		.ENDIF
	.ELSEIF uMsg == WM_DESTROY
		invoke  PostQuitMessage, NULL
		mov eax, 0
		ret

	.ENDIF
msg_process:
    invoke  DefWindowProc, hwnd, uMsg, wParam, lParam

	ret
Window_Process ENDP

Window_Paint PROC, hwnd: HWND
	LOCAL   hdc: HDC
	LOCAL	hdcMem: HDC
	LOCAL   ps: PAINTSTRUCT

	invoke  BeginPaint, hwnd, ADDR ps
	mov     hdc, eax
	invoke  CreateCompatibleDC, eax  ;110 建立相同的設備內容作為來源
	mov     hdcMem, eax

	; invoke  SelectObject, hdcMem, hBitmap     ;112 選定來源設備內容的位元圖
	; mov     eax, 0
	; mov     ecx, 0
	; invoke  BitBlt,hdc,0,0,8,8,hdcMem,\
	; 		ecx,eax,SRCCOPY         ;118 傳送位元圖到視窗的設備內容


	invoke  DeleteDC, hdcMem         ;119 釋放來源設備內容
	invoke  EndPaint, hwnd, ADDR ps   ;120 釋放視窗設備內容
	ret
Window_Paint ENDP

Window_MouseMove PROC, lParam: LPARAM
	mov eax, lParam
	and eax, 0ffffh
	mov mouseX, eax
	mov eax, lParam
	shr eax, 10h
	mov mouseY, eax

	ret
Window_MouseMove ENDP

END