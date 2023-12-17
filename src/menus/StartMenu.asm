INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE ../Reference.inc

extern main_getHInstance: PROC
extern GetIndexedStr: PROTO, :DWORD
extern Game_create: PROTO, :HWND
extern Game_Show: PROC

.data

hInstance				HINSTANCE	?

StartMenuClassName		BYTE		"Pane", 0
StartMenuClass			WNDCLASSEX	<30h,?,?,0,0,?,?,?,?,0,OFFSET StartMenuClassName,?>

StartMenuTitle			BYTE		"Start Menu", 0

BTN_WIDTH				DWORD		400
BTN_HEIGHT				DWORD		60

BTN_START_EXECCODE		HMENU		101
BTN_START_TEXT			BYTE		"Start", 0

BTN_EXIT_EXECCODE		HMENU		102
BTN_EXIT_TEXT			BYTE		"Exit", 0

mainHwnd				HWND		?

.code
StartMenu_init PROC
	call	main_getHInstance
	mov		hInstance, eax

	mov     StartMenuClass.hInstance, eax
	mov     StartMenuClass.style, NULL
	mov     StartMenuClass.lpfnWndProc, OFFSET StartMenu_Process
	mov     StartMenuClass.hbrBackground, COLOR_WINDOW+1

	invoke  LoadCursor, NULL, IDC_ARROW
	mov     StartMenuClass.hCursor, eax

	invoke  RegisterClassEx, OFFSET StartMenuClass

	ret
StartMenu_init ENDP

StartMenu_create PROC USES edx, main_hwnd: HWND
	LOCAL	sm_hwnd: HWND

	mov 	edx, main_hwnd
	mov 	mainHwnd, edx
	
	invoke  CreateWindowEx, NULL, OFFSET StartMenuClassName, OFFSET StartMenuTitle,\
			WS_CHILD or WS_VISIBLE,\
			0, 0, _WINDOW_WIDTH, _WINDOW_HEIGHT,\
			mainHwnd, NULL, hInstance, NULL
	mov     sm_hwnd, eax

	invoke  ShowWindow, sm_hwnd, SW_SHOW
	invoke  UpdateWindow, sm_hwnd

	mov eax, sm_hwnd
	ret
StartMenu_create ENDP

StartMenu_Process PROC, hwnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	; LOCAL buttonStringPtr: BYTE PTR

	.IF uMsg == WM_CREATE
		mWriteLn "CREATE MENU"
		invoke GetIndexedStr, $BUTTON$
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_START_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 200, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_START_EXECCODE, hInstance, NULL

		invoke GetIndexedStr, $BUTTON$
		mov ebx, _WINDOW_WIDTH
		sub ebx, BTN_WIDTH
		shr ebx, 1

		invoke  CreateWindowEx, NULL, eax, OFFSET BTN_EXIT_TEXT,\
			WS_CHILD or WS_VISIBLE or BS_DEFPUSHBUTTON,\
			ebx, 400, BTN_WIDTH, BTN_HEIGHT,\
			hwnd, BTN_EXIT_EXECCODE, hInstance, NULL
	.ELSEIF uMsg == WM_COMMAND
		mov eax, wParam
		.IF eax == BTN_START_EXECCODE
			invoke ShowWindow, hwnd, SW_HIDE

			invoke Game_create, mainHwnd
			call Game_Show
			mWriteLn "START GAME"
		.ELSEIF eax == BTN_EXIT_EXECCODE
			mWriteLn "EXIT GAME"
		.ENDIF
	.ENDIF

    invoke  DefWindowProc, hwnd, uMsg, wParam, lParam

	ret
StartMenu_Process ENDP


END