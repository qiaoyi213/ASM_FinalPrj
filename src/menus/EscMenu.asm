INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE ../Reference.inc

extern main_getHInstance: PROC
extern main_stop: PROC
extern Game_create: PROTO, :HWND
extern Game_Show: PROC
extern game_destory: PROC
extern GetIndexedStr: PROTO, :DWORD
extern battle_bgm_close: PROC
extern normal_bgm_play: PROC
extern battle_bgm_play: PROC

Pause_create PROTO, :HWND

.data

hInstance				HINSTANCE	?

PauseClassName		BYTE		"PausePane", 0
PauseClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET PauseClassName,?>

PauseTitle			BYTE		"Pause Menu", 0

BTN_WIDTH				DWORD		400
BTN_HEIGHT				DWORD		60

BTN_CONTINUE_EXECCODE	HMENU		111
BTN_CONTINUE_TEXT		BYTE		"Continue", 0

BTN_QUIT_EXECCODE	HMENU		112
BTN_QUIT_TEXT		BYTE		"Quit", 0

mainHwnd				HWND		?
pmHwnd					HWND		?

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
	mov 	edx, main_hwnd
	mov 	mainHwnd, edx
	
	invoke  CreateWindowEx, NULL, OFFSET PauseClassName, OFFSET PauseTitle,\
			WS_CHILD or WS_VISIBLE,\
			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			mainHwnd, NULL, hInstance, NULL
	mShow eax
	mov     pmHwnd, eax

	invoke  ShowWindow, pmHwnd, SW_HIDE
	invoke  UpdateWindow, pmHwnd

	mov eax, pmHwnd
	ret
Pause_create ENDP

Pause_Process PROC, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	; LOCAL buttonStringPtr: BYTE PTR

	.IF uMsg == WM_CREATE
		; call normal_bgm_play
		invoke GetIndexedStr, $BUTTON$
		
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_CONTINUE_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 200, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_CONTINUE_EXECCODE, hInstance, NULL

		invoke GetIndexedStr, $BUTTON$
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_QUIT_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 400, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_QUIT_EXECCODE, hInstance, NULL
	.ELSEIF uMsg == WM_COMMAND
		mov eax, wParam
		.IF eax == BTN_CONTINUE_EXECCODE
			; call normal_bgm_close
			invoke ShowWindow, hwnd, SW_HIDE
			; invoke Game_create, mainHwnd
			call Game_Show
			mWriteLn "BACK TO GAME"
		.ELSEIF eax == BTN_QUIT_EXECCODE
			mWriteLn "QUIT"
			call main_stop
		.ENDIF
	.ENDIF

    invoke  DefWindowProc, hwnd, uMsg, wParam, lParam

	ret
Pause_Process ENDP


Pause_Show PROC
	call battle_bgm_close
	call normal_bgm_play
	mWriteLn "in here"
    invoke ShowWindow, pmHwnd, SW_SHOW
    invoke UpdateWindow, pmHwnd
    ret
Pause_Show ENDP

Pause_Hide PROC
	
    invoke ShowWindow, pmHwnd, SW_HIDE
    invoke UpdateWindow, pmHwnd
    ret
Pause_Hide ENDP

END