INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC
extern StartMenu_create: PROTO, :HWND
extern GetIndexedStr: PROTO, :DWORD
extern victory_bgm_play: PROC
extern victory_bgm_stop: PROC
extern Resource_getVictory: PROC
DrawMob PROTO, :Mob


.data

hInstance			HINSTANCE	?
VictoryClassName	BYTE		"PaneVictory", 0
VictoryClass		WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET VictoryClassName,?>
VictoryTitle		BYTE		"Victory Title", 0
Victory_hwnd		HWND		?
BTN_WIDTH			DWORD		400
BTN_HEIGHT			DWORD		60
hdc					HDC			?
hdcBuffer			HDC			?
hbitmap				HBITMAP		?
mainGraphic			DWORD		?	; PTR GpGraphics
bufferGraphic		DWORD		?

BTN_BACK_EXECCODE   HMENU       103
BTN_BACK_TEXT       BYTE        "Back to Menu", 0
mainHwnd            HWND        ?

.code

Victory_init PROC
 	call	main_getHInstance
	mov		hInstance, eax
	mov     VictoryClass.hInstance, eax
	mov     VictoryClass.style, NULL
	mov     VictoryClass.lpfnWndProc, OFFSET Victory_Process
	mov     VictoryClass.hbrBackground, COLOR_WINDOW+1

	invoke  LoadCursor, NULL, IDC_ARROW
	mov     VictoryClass.hCursor, eax

	invoke  RegisterClassEx, OFFSET VictoryClass
	ret
Victory_init ENDP

Victory_create PROC USES eax edx, main_hwnd: HWND
	mov edx, main_hwnd
    mov mainHwnd, edx

    invoke  CreateWindowEx, NULL, OFFSET VictoryClassName, OFFSET VictoryTitle,\
			WS_CHILD or WS_VISIBLE,\
			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			main_hwnd, NULL, hInstance, NULL

    mov Victory_hwnd, eax
    mShow Victory_hwnd

    invoke  ShowWindow, Victory_hwnd, SW_HIDE
	invoke  UpdateWindow, Victory_hwnd

	mov eax, Victory_hwnd
    ret
Victory_create ENDP

Victory_Process PROC USES ecx, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
    .IF uMsg == WM_CREATE
		
        mWriteLn "VICTORY"
		invoke GetIndexedStr, $BUTTON$
		
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_BACK_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 400, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_BACK_EXECCODE, hInstance, NULL

		invoke GetDC, hwnd
		mov hdc, eax
		invoke	GdipCreateFromHDC, hdc, ADDR mainGraphic
		call	Victory_draw
		
	.ELSEIF uMsg == WM_PAINT
		
		; invoke	BitBlt, hdc, 0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT, hdcBuffer, 0, 0, SRCCOPY
	.ELSEIF uMsg == WM_COMMAND
		mov eax, wParam
		.IF eax == BTN_BACK_EXECCODE
			invoke StartMenu_create, mainHwnd
			mWriteLn "BACK"
            invoke DestroyWindow, hwnd
		; .ELSEIF eax == BTN_EXIT_EXECCODE
		; 	mWriteLn "EXIT GAME"
		; 	call main_stop
		.ENDIF

    .ELSEIF uMsg == WM_DESTROY
		invoke	GdipDeleteGraphics, bufferGraphic
		invoke	DeleteObject, hbitmap
		invoke	DeleteDC, hdcBuffer
		invoke	GdipDeleteGraphics, mainGraphic
		invoke	ReleaseDC, hwnd, hdc
		mWriteLn "Destory"

	.ENDIF

    invoke  DefWindowProc, hwnd, uMsg, wParam, lParam
    ret
Victory_Process ENDP

Victory_Show PROC
	call victory_bgm_play
    invoke ShowWindow, Victory_hwnd, SW_SHOW
    invoke UpdateWindow, Victory_hwnd
	
    ret
Victory_Show ENDP

Victory_Hide PROC
	call victory_bgm_stop
    invoke ShowWindow, Victory_hwnd, SW_HIDE
    invoke UpdateWindow, Victory_hwnd
    ret
Victory_Hide ENDP

Victory_draw PROC
	call Resource_getVictory
	mShow mainGraphic
	invoke	GdipDrawImageRectI, mainGraphic, eax, 0, 0, 640, 400
	ret
Victory_draw ENDP
END