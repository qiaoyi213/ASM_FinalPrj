INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc

Window_Process PROTO, :HWND, :UINT, :WPARAM, :LPARAM 

.data

ClassName		BYTE		"SimpleWinClass", 0		; don't change this
windowTitle		BYTE		"The Game", 0
hInstance		HINSTANCE	?
hwnd			HWND		?
windowClass		WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET ClassName,?>
msg				MSG			<?>

.code

Window_init PROC
	invoke  GetModuleHandle, NULL
	mov     hInstance, eax

	mov     windowClass.style, CS_HREDRAW or CS_VREDRAW ; re draw when window resized

	mov     windowClass.lpfnWndProc, OFFSET Window_Process

	mov     eax, hInstance
	mov     windowClass.hInstance, eax

	mov     windowClass.hbrBackground, COLOR_WINDOW+1

	; Since no icon, disable first
	; invoke  LoadIcon,NULL,IDI_APPLICATION   ;取得圖示代碼
	; mov     wc.hIcon,eax                    ;存入圖示代碼
	; mov     wc.hIconSm,eax                  ;存入小圖示代碼

	invoke  LoadCursor, NULL, IDC_ARROW					;取得游標代碼
	mov     windowClass.hCursor,eax						;存入游標代碼

	invoke  RegisterClassEx, OFFSET windowClass			;註冊視窗類別

	invoke  CreateWindowEx, NULL, OFFSET ClassName, OFFSET windowTitle,\
			WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT,\
			CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL
	mov     hwnd, eax

	invoke  ShowWindow, hwnd, SW_SHOWDEFAULT
	invoke  UpdateWindow, hwnd
 
message_handling:
	invoke  GetMessage, OFFSET msg, NULL, 0, 0
	cmp     eax, 0
	jz      message_quit
	invoke  TranslateMessage, OFFSET msg
	invoke  DispatchMessage, OFFSET msg
	jmp     message_handling
message_quit:
	mov     eax, msg.wParam
	invoke  ExitProcess, eax
	ret
Window_init ENDP

Window_Process PROC, hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	.IF uMsg == WM_PAINT
		
	.ELSEIF uMsg == WM_DESTROY
		invoke  PostQuitMessage, NULL
		mov eax, 0
		ret
	.ENDIF
msg_process:
    invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
	
	ret
Window_Process ENDP

Window_Paint_Handle PROC

Window_Paint_Handle ENDP

END