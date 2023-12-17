INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE ../Reference.inc

extern main_getHInstance: PROC
extern StartMenu_create: PROTO, :HWND
extern game_destory: PROC
extern GetIndexedStr: PROTO, :DWORD

.data

hInstance			HINSTANCE	?
PauseClassName	    BYTE		"PausePane", 0
PauseClass		    WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET PauseClassName,?>
PauseTitle		    BYTE		"Pause", 0
Pause_hwnd		    HWND		?
BTN_WIDTH			DWORD		400
BTN_HEIGHT			DWORD		60
hdc					HDC			?
hdcBuffer			HDC			?
hbitmap				HBITMAP		?
mainGraphic			DWORD		?	; PTR GpGraphics
bufferGraphic		DWORD		?

BTN_MENU_EXECCODE   HMENU       103
BTN_MENU_TEXT       BYTE        "Back to Menu", 0

BTN_BACK_EXECCODE   HMENU       104
BTN_BACK_TEXT       BYTE        "Back to Game", 0


mainHwnd            HWND        ?

.code

Pause_init PROC
 	call	main_getHInstance
	mov		hInstance, eax
	mov     PauseClass.hInstance, eax
	mov     PauseClass.style, NULL
	mov     PauseClass.lpfnWndProc, OFFSET Pause_Process
	mov     PauseClass.hbrBackground, COLOR_WINDOW+1

	invoke  LoadCursor, NULL, IDC_ARROW
	mov     PauseClass.hCursor, eax

	invoke  RegisterClassEx, OFFSET PauseClass
	ret
Pause_init ENDP

Pause_create PROC USES edx, main_hwnd: HWND
	mov edx, main_hwnd
    mov mainHwnd, edx

    invoke  CreateWindowEx, NULL, OFFSET PauseClassName, OFFSET PauseTitle,\
			WS_CHILD or WS_VISIBLE,\
			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			main_hwnd, NULL, hInstance, NULL

    mov Pause_hwnd, eax
    mShow Pause_hwnd

    invoke  ShowWindow, Pause_hwnd, SW_HIDE
	invoke  UpdateWindow, Pause_hwnd

	mov eax, Pause_hwnd
    ret
Pause_create ENDP

Pause_Process PROC USES ecx, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
    .IF uMsg == WM_CREATE
		; call normal_bgm_play
        mWriteLn "YOU Pause"
		invoke GetIndexedStr, $BUTTON$
		
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_BACK_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 200, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_BACK_EXECCODE, hInstance, NULL

        
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_BACK_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 400, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_MENU_EXECCODE, hInstance, NULL    

	.ELSEIF uMsg == WM_COMMAND
		mov eax, wParam
		.IF eax == BTN_BACK_EXECCODE
            call Pause_Hide
	    .ELSEIF eax == BTN_MENU_EXECCODE
            call game_destory
		 	mWriteLn "EXIT GAME"
            invoke StartMenu_create, mainHwnd
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
Pause_Process ENDP


Pause_Show PROC
    invoke ShowWindow, Pause_hwnd, SW_SHOW
    invoke UpdateWindow, Pause_hwnd
    ret
Pause_Show ENDP

Pause_Hide PROC
    invoke ShowWindow, Pause_hwnd, SW_HIDE
    invoke UpdateWindow, Pause_hwnd
    ret
Pause_Hide ENDP

END