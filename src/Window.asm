INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

INCLUDE Reference.inc

extern main_getHInstance: PROC
extern Resource_loadAll: PROTO, :HINSTANCE

Window_Process PROTO, :HWND, :UINT, :WPARAM, :LPARAM
Window_Paint PROTO, :HWND

.data
hInstance	HINSTANCE	?

wndClassName	BYTE		"SimpleWinClass", 0		; don't change this
wndTitle		BYTE		"The Game", 0

windowClass		WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET wndClassName,?>

BMPName			DB			"SlimeImg", 0
hBitmap			DWORD		?

.code

Window_init PROC
	LOCAL	hwnd:	HWND
	LOCAL	msg:	MSG

	; fetch the main instance
	call	main_getHInstance
	mov		hInstance, eax

make_class:
	mov     windowClass.hInstance, eax

	mov     windowClass.style, NULL
	mov     windowClass.lpfnWndProc, OFFSET Window_Process

	mov     windowClass.hbrBackground, COLOR_WINDOW+1

	; Since no icon, disable first
	; invoke  LoadIcon,NULL,IDI_APPLICATION   ;取得圖示代碼
	; mov     wc.hIcon,eax                    ;存入圖示代碼
	; mov     wc.hIconSm,eax                  ;存入小圖示代碼

	invoke  LoadCursor, NULL, IDC_ARROW
	mov     windowClass.hCursor, eax

	invoke  RegisterClassEx, OFFSET windowClass

create_window:
	invoke  CreateWindowEx, NULL, OFFSET wndClassName, OFFSET wndTitle,\
			WS_OVERLAPPEDWINDOW,\
			CW_USEDEFAULT, CW_USEDEFAULT, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			NULL, NULL, hInstance, NULL
	mov     hwnd, eax

	invoke  ShowWindow, hwnd, SW_SHOWDEFAULT
	invoke  UpdateWindow, hwnd
 
message_handling:
	invoke  GetMessage, ADDR msg, NULL, 0, 0
	cmp     eax, 0
	jz      message_quit
	invoke  TranslateMessage, ADDR msg
	invoke  DispatchMessage, ADDR msg
	jmp     message_handling

message_quit:
	mov     eax, msg.wParam
	invoke  ExitProcess, eax
	ret
Window_init ENDP

Window_Process PROC, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	.IF uMsg == WM_CREATE
		invoke Resource_loadAll, hInstance

	.ELSEIF uMsg == WM_MOUSEMOVE
		invoke Window_MouseMove

	.ELSEIF uMsg == WM_PAINT
		invoke Window_Paint, hwnd

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

Window_MouseMove PROC
Window_MouseMove ENDP

END