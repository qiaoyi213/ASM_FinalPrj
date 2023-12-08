INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE winuser.inc
INCLUDE Macros.inc


.data

WelcomeMsg          BYTE    "Welcome!", 0
StartMsg            BYTE    "Start", 0
QuitMsg             BYTE    "Quit", 0
WelcomeRect         RECT    <540,100,740,200>    
StartRect           RECT    <540,150,740,250>
BtnClass            BYTE    "button", 0
IDC_BUTTON_START    HMENU   101
IDC_BUTTON_EXIT     HMENU   100
.code

StartMenu_init PROC  hWnd: HWND, hdc: HDC

    invoke CreateWindowEx, NULL, OFFSET BtnClass,  OFFSET StartMsg, WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON , 540, 150, 200, 100, hWnd, IDC_BUTTON_START, hWnd, NULL
    invoke CreateWindowEx, NULL, OFFSET BtnClass,  OFFSET QuitMsg, WS_VISIBLE or WS_CHILD or BS_DEFPUSHBUTTON , 540, 550, 200, 100, hWnd, IDC_BUTTON_EXIT, hWnd, NULL
    ret
StartMenu_init ENDP

; StartMenu_click PROC lParam: lParam

; StartMenu_click ENDP

END