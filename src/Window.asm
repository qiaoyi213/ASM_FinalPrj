INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

Window_Process PROTO, :HWND, :UINT, :WPARAM, :LPARAM 
StartMenu_init PROTO, :HWND, :HDC
.data

ClassName		BYTE		"SimpleWinClass", 0		; don't change this
windowTitle		BYTE		"The Game", 0
hMenu           HMENU       ?
hwnd			HWND		?
hInstance		HINSTANCE	?
hCursor			HCURSOR		?
ncx             dd          ?   ;025 BMP 圖檔的寬度
ncy             dd          ?   ;026 BMP 圖檔的高度
cPosX			dd			?
cPosY			dd			?
iVPos           dd          ?   ;027 垂直捲軸操縱桿位置
iHPos           dd          ?   ;028 水平捲軸操縱桿位置
iVMax           dd          ?   ;029 垂直捲軸最大範圍
iHMax           dd          ?   ;030 水平捲軸最大範圍
windowClass		WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET ClassName,?>
msg				MSG			<?>

BMPName			DB			"SlimeImg", 0
CURName			DB			"cursorFile", 0
hBitmap			DWORD		?
rectangle		RECT		<0,0,256,256>
rectangle2		RECT		<100,100,300,300>
aColor			COLORREF 	00FF0000h
bColor			COLORREF 	0000FF00h
cColor			COLORREF 	000000FFh
mouseX			DWORD		?
mouseY			DWORD		?

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

	invoke  LoadImage, hInstance, OFFSET CURName, IMAGE_CURSOR, 60,60, LR_DEFAULTCOLOR  ; 讀取游標圖示

	mov hCursor, eax
	mShow hCursor
	invoke 	SetCursor, hCursor


	invoke  RegisterClassEx, OFFSET windowClass			;註冊視窗類別

	invoke  CreateWindowEx,NULL,offset ClassName,offset \ 
                NULL,           ;058 風格
                WS_OVERLAPPEDWINDOW xor WS_THICKFRAME,0,0,1280,720,0,NULL,hInstance,NULL

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

		; invoke ShowCursor, FALSE ; Hide cursor
		
		invoke StartMenu_init, hWnd, hdc
		
		
		invoke  LoadBitmap, hInstance, offset BMPName             ;078 載入位元圖
		mShow	eax
        mov     hBitmap,eax
        invoke  GetObject,hBitmap,sizeof bitmapABC,addr bitmapABC     ;080 位元圖屬性


				
	.ELSEIF uMsg == WM_PAINT


		invoke  BeginPaint,hWnd,addr ps ;108 取得視窗的設備內容
        mov     hdc, eax
        invoke  CreateCompatibleDC,eax  ;110 建立相同的設備內容作為來源
        mov     hdcMem,eax
        invoke  SelectObject,hdcMem,hBitmap     ;112 選定來源設備內容的位元圖
		; mShow mouseX
		; mShow mouseY
		
		
		
        mov     eax, 0
        mov     ecx, 0
        invoke  BitBlt,hdc, mouseX,mouseY,8,8,hdcMem,\
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

	.ELSEIF uMsg == WM_MOUSEMOVE
		mov eax, lParam
		and eax, 0ffffh
		mov mouseX, eax
		mov eax, lParam
		shr eax, 10h
		mov mouseY, eax

		; invoke InvalidateRect, hWnd, NULL, TRUE ; 產生 WM_PAINT 訊息並清空畫面 重新繪製
	.ELSEIF uMsg == WM_LBUTTONUP
		mWrite "CLICK LEFT" 
	.ELSEIF uMsg == WM_RBUTTONUP

	.ELSEIF uMsg == WM_COMMAND
		mov eax, wParam
		; mShow eax
		.IF ax == 101 ; Start Button ID defined in StartMenu.asm
			mWrite "Start Game"
			
			; invoke Game_init

		.ELSEIF ax == 100 ; Exit 
			invoke PostQuitMessage,NULL
			mov eax, 0
			ret
		.ENDIF
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
    invoke  DefWindowProc, hWnd, uMsg, wParam, lParam
	
	ret
Window_Process ENDP

Window_Paint_Handle PROC

Window_Paint_Handle ENDP


END
