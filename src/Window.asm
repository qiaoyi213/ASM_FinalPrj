INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc

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
	local bitmap: BITMAP
	local   ps:PAINTSTRUCT
    local   hdc,hdcMem:HDC
	
	.IF uMsg == WM_CREATE
		invoke LoadBitmap, hInstance, OFFSET BMPName
		mov hBitmap, eax
		invoke GetObject, hBitmap, SIZEOF BITMAP,ADDR bitmap
		call DumpRegs
		mov ecx, bitmap.bmWidth
		mov ncx, ecx
		mov edx, OFFSET ncx
		call WriteString
		mov ecx, bitmap.bmHeight
		mov ncy, ecx
		call DumpRegs

	.ELSEIF uMsg == WM_PAINT
		invoke BeginPaint, hWnd, ADDR ps
		mov hdc, eax
		invoke CreateCompatibleDC, eax
		mov hdcMem, eax
		invoke SelectObject, hdcMem, hBitmap
		mov eax, iVPos
		mov ecx, iHPos
		invoke BitBlt, hdc,0,0,nxClient, nyClient,hdcMem, ecx, eax, SRCCOPY
		invoke  DeleteDC,hdcMem         ;119 釋放來源設備內容
        invoke  EndPaint,hWnd,addr ps   ;120 釋放視窗設備內容


	.ELSEIF WM_SIZE
		mov     eax,lParam              ;087 取得工作區大小，ECX=高度，EAX=寬度
        mov     ecx,eax
        and     eax,0ffffh
        shr     ecx,16
        mov     nxClient,eax
        mov     nyClient,ecx
        mov     ecx,ncx                 ;093 計算水平捲軸最大範圍
        sub     ecx,eax
        shr     ecx,3
        mov     iHMax,ecx
        invoke  SetScrollRange,hWnd,SB_HORZ,0,ecx,TRUE
        mov     eax,ncy                 ;098 計算垂直捲軸最大範圍
        sub     eax,nyClient
        shr     eax,3
        mov     iVMax,eax
        invoke  SetScrollRange,hWnd,SB_VERT,0,eax,TRUE
        sub     edx,edx
        mov     iVPos,edx
        mov     iHPos,edx
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
