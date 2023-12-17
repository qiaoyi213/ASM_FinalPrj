INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE Reference.inc

extern main_getHInstance: PROC
extern StartMenu_create: PROTO, :HWND
extern GetIndexedStr: PROTO, :DWORD
extern lose_bgm_play: PROC
extern lose_bgm_stop: PROC
extern Resource_getLose: PROC
DrawMob PROTO, :Mob


.data

hInstance			HINSTANCE	?
LoseClassName		BYTE		"PaneLose", 0
LoseClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET LoseClassName,?>
LoseTitle			BYTE		"Lose Title", 0
Lose_hwnd			HWND		?
BTN_WIDTH			DWORD		400
BTN_HEIGHT			DWORD		60
hdc					HDC			?
hdcBuffer			HDC			?
hbitmap				HBITMAP		?
mainGraphic			DWORD		?	; PTR GpGraphics
bufferGraphic		DWORD		?

BTN_BACK_EXECCODE   HMENU       103
BTN_BACK_TEXT       BYTE        "Back to Menu", 0

LOSE_TEXT			BYTE		"You LOSE", 0
mainHwnd            HWND        ?

.code

Lose_init PROC
 	call	main_getHInstance
	mov		hInstance, eax
	mov     LoseClass.hInstance, eax
	mov     LoseClass.style, NULL
	mov     LoseClass.lpfnWndProc, OFFSET Lose_Process
	mov     LoseClass.hbrBackground, COLOR_WINDOW+1

	invoke  LoadCursor, NULL, IDC_ARROW
	mov     LoseClass.hCursor, eax

	invoke  RegisterClassEx, OFFSET LoseClass
	ret
Lose_init ENDP

Lose_create PROC USES eax edx, main_hwnd: HWND
	mov edx, main_hwnd
    mov mainHwnd, edx

    invoke  CreateWindowEx, NULL, OFFSET LoseClassName, OFFSET LoseTitle,\
			WS_CHILD or WS_VISIBLE,\
			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			main_hwnd, NULL, hInstance, NULL

    mov Lose_hwnd, eax
    mShow Lose_hwnd

    invoke  ShowWindow, Lose_hwnd, SW_HIDE
	invoke  UpdateWindow, Lose_hwnd
	mov eax, Lose_hwnd
    ret
Lose_create ENDP

Lose_Process PROC USES ecx, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	local @gdip
    .IF uMsg == WM_CREATE
        mWriteLn "YOU LOSE"
		
		invoke GetIndexedStr, $BUTTON$
		
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_BACK_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 400, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_BACK_EXECCODE, hInstance, NULL

		invoke GetIndexedStr, $BUTTON$
		
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET LOSE_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_FLAT,\
			ebx, 200, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, 0, hInstance, NULL

	.ELSEIF uMsg == WM_COMMAND
		mov eax, wParam
		.IF eax == BTN_BACK_EXECCODE
			invoke StartMenu_create, mainHwnd
			mWriteLn "BACK"
			call lose_bgm_stop
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
Lose_Process ENDP


Lose_Show PROC
	call lose_bgm_play
    invoke ShowWindow, Lose_hwnd, SW_SHOW
    invoke UpdateWindow, Lose_hwnd
    ret
Lose_Show ENDP

Lose_Hide PROC
	call lose_bgm_stop
    invoke ShowWindow, Lose_hwnd, SW_HIDE
    invoke UpdateWindow, Lose_hwnd
    ret
Lose_Hide ENDP

Lose_draw PROC USES eax
	ret
Lose_draw ENDP
END