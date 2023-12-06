INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

Window_Process PROTO, :HWND, :UINT, :WPARAM, :LPARAM 

.data

ClassName		BYTE		"SimpleWinClass", 0		; don't change this
windowTitle		BYTE		"The Game", 0
hMenu           HMENU       ?
hwnd			HWND		?
hInstance		HINSTANCE	?
nxClient        dd          ?   ;023 工作區寬度
nyClient        dd          ?   ;024 工作區高度
hBitmap			dd			?
ncx             dd          ?   ;025 BMP 圖檔的寬度
ncy             dd          ?   ;026 BMP 圖檔的高度
cPosX			dd			?
cPosY			dd			?
iVPos           dd          ?   ;027 垂直捲軸操縱桿位置
iHPos           dd          ?   ;028 水平捲軸操縱桿位置
iVMax           dd          ?   ;029 垂直捲軸最大範圍
iHMax           dd          ?   ;030 水平捲軸最大範圍
BMPName         db          "VBMP",0
windowClass		WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET ClassName,?>
msg				MSG			<?>

BMPName			DB			"SlimeImg", 0
hBitmap			DWORD		?
rectangle		RECT		<0,0,256,256>
rectangle2		RECT		<100,100,300,300>
aColor			COLORREF 	00FF0000h
bColor			COLORREF 	0000FF00h
cColor			COLORREF 	000000FFh

.code

Window_init PROC
	invoke  GetModuleHandle, NULL
	mov     hInstance, eax
	
	mShow	hInstance

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

	invoke  CreateWindowEx,NULL,offset ClassName,offset \ 
                NULL,WS_VSCROLL or WS_HSCROLL or \           ;058 風格
                WS_OVERLAPPEDWINDOW,0,0,400,400,0,NULL,hInstance,NULL

	; invoke  CreateWindowEx, NULL, OFFSET ClassName, OFFSET windowTitle,\
	; 		WS_OVERLAPPEDWINDOW, CW_USEDEFAULT, CW_USEDEFAULT,\
	; 		CW_USEDEFAULT, CW_USEDEFAULT, NULL, NULL, hInstance, NULL
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
	local   hdc, hdcMem:HDC
	local   ps: PAINTSTRUCT

	local   bitmapABC: BITMAP           ;073 存放位元圖屬性

	.If uMsg == WM_CREATE
		; invoke FindResource, 0, OFFSET BMPName, OFFSET RT_BITMAP
		; mShow eax
		; invoke LoadResource, 0, eax
		; mShow eax


		invoke  LoadBitmap, hInstance, offset BMPName             ;078 載入位元圖
		mShow	eax
        mov     hBitmap,eax
        invoke  GetObject,hBitmap,sizeof bitmapABC,addr bitmapABC     ;080 位元圖屬性
        ; mov     ecx, bitmapABC.bmWidth      ;081 位元圖寬度存於 ncx
		; mShow ecx
        ; mov     ncx,ecx
        ; mov     ecx, bitmapABC.bmHeight     ;083 位元圖高度存於 ncy
		; mShow ecx
        ; mov     ncy,ecx
		; jnz a_label
		; mWriteLn "fail"
; 		jmp b_label
; a_label:
; 		mShow bitmap.bmType
; 		mShow bitmap.bmWidth
; 		mShow bitmap.bmHeight
; 		mShow bitmap.bmBitsPixel
; 		mShow bitmap.bmBits
; b_label:
		; mWriteLn "Finish"

	.ELSEIF uMsg == WM_PAINT
		invoke  BeginPaint,hWnd,addr ps ;108 取得視窗的設備內容
        mov     hdc, eax
        invoke  CreateCompatibleDC,eax  ;110 建立相同的設備內容作為來源
        mov     hdcMem,eax
        invoke  SelectObject,hdcMem,hBitmap     ;112 選定來源設備內容的位元圖
        mov     eax, 0
        mov     ecx, 0
        invoke  BitBlt,hdc,0,0,8,8,hdcMem,\
                ecx,eax,SRCCOPY         ;118 傳送位元圖到視窗的設備內容
        invoke  DeleteDC,hdcMem         ;119 釋放來源設備內容

			; invoke	CreateSolidBrush, aColor
			; invoke	FillRect, hdc, OFFSET rectangle, eax

			; mov rectangle.left, 256
			; add rectangle.right, 256
			; invoke	CreateSolidBrush, bColor
			; invoke	FillRect, hdc, OFFSET rectangle, eax

			; invoke	CreateSolidBrush, cColor
			; invoke	FillRect, hdc, OFFSET rectangle2, eax

        invoke  EndPaint,hWnd,addr ps   ;120 釋放視窗設備內容
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
