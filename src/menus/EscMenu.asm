; INCLUDE Ervine32.inc
; INCLUDE WINDOWS.inc
; INCLUDE Macros.inc
; INCLUDE ../Reference.inc

; extern main_getHInstance: PROC
; extern main_stop:PROC
; extern GetIndexedStr: PROTO, :DWORD
; extern Game_create: PROTO, :HWND
; extern Game_Show: PROC
; extern normal_bgm_play: PROC
; extern normal_bgm_close: PROC

; .data

; hInstance				HINSTANCE	?

; PauseMenuClassName		BYTE		"PanePauseMenu", 0
; PauseMenuClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET PauseMenuClassName,?>

; PauseMenuTitle			BYTE		"PAUSED", 0

; BTN_WIDTH				DWORD		400
; BTN_HEIGHT				DWORD		60

; BTN_START_EXECCODE		HMENU		101
; BTN_START_TEXT			BYTE		"CONTINUE", 0

; BTN_EXIT_EXECCODE		HMENU		102
; BTN_EXIT_TEXT			BYTE		"QUIT", 0
; mainHwnd				HWND		?

; .code
; PauseMenu_init PROC
; 	call	main_getHInstance
; 	mov		hInstance, eax
; 	mov     PauseMenuClass.hInstance, eax
; 	mov     PauseMenuClass.style, NULL
; 	mov     PauseMenuClass.lpfnWndProc, OFFSET PauseMenu_Process
; 	mov     PauseMenuClass.hbrBackground, COLOR_WINDOW+1

; 	invoke  LoadCursor, NULL, IDC_ARROW
; 	mov     PauseMenuClass.hCursor, eax

; 	invoke  RegisterClassEx, OFFSET PauseMenuClass

; 	ret
; PauseMenu_init ENDP

; PauseMenu_create PROC USES edx, main_hwnd: HWND
; 	LOCAL	sm_hwnd: HWND

; 	mov 	edx, main_hwnd
; 	mov 	mainHwnd, edx
	
; 	invoke  CreateWindowEx, NULL, OFFSET PauseMenuClassName, OFFSET PauseMenuTitle,\
; 			WS_CHILD or WS_VISIBLE,\
; 			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
; 			mainHwnd, NULL, hInstance, NULL
; 	mov     sm_hwnd, eax

; 	invoke  ShowWindow, sm_hwnd, SW_SHOW
; 	invoke  UpdateWindow, sm_hwnd

; 	mov eax, sm_hwnd
; 	ret
; PauseMenu_create ENDP

; PauseMenu_Process PROC, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM

; 	.IF uMsg == WM_CREATE
; 		mWriteLn "CREATE MENU"
; 		call normal_bgm_play
; 		invoke GetIndexedStr, $BUTTON$
		
; 		mov ebx, _WINDOW_WIDTH
; 		sub ebx, BTN_WIDTH
; 		shr ebx, 1

; 		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_START_TEXT,\
; 			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
; 			ebx, 200, BTN_WIDTH, BTN_HEIGHT,\
; 			hwnd, BTN_START_EXECCODE, hInstance, NULL

; 		invoke GetIndexedStr, $BUTTON$
; 		mov ebx, _WINDOW_WIDTH
; 		sub ebx, BTN_WIDTH
; 		shr ebx, 1

; 		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_EXIT_TEXT,\
; 			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
; 			ebx, 400, BTN_WIDTH, BTN_HEIGHT,\
; 			hwnd, BTN_EXIT_EXECCODE, hInstance, NULL
; 	.ELSEIF uMsg == WM_COMMAND
; 		mov eax, wParam
; 		.IF eax == BTN_START_EXECCODE
; 			call normal_bgm_close
; 			invoke ShowWindow, hwnd, SW_HIDE
; 			invoke Game_create, mainHwnd
; 			call Game_Show
; 			mWriteLn "START GAME"
; 		.ELSEIF eax == BTN_EXIT_EXECCODE
; 			mWriteLn "EXIT GAME"
; 			call main_stop
; 		.ENDIF
; 	.ENDIF

;     invoke  DefWindowProc, hwnd, uMsg, wParam, lParam

; 	ret
; PauseMenu_Process ENDP


END