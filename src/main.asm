INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc

WndProc PROTO	:HWND, :UINT, :WPARAM, :LPARAM 

.data

ClassName       DB          "SimpleWinClass",0  ;視窗類別名稱
AppName         DB          "Our First Window",0
hInstance       HINSTANCE   ?                   ;模組代碼
hwnd            HWND        ?                   ;視窗代碼
CommandLine     LPSTR       ?                   ;命令列位址
wc      WNDCLASSEX      <30h,?,?,0,0,?,?,?,?,0,OFFSET ClassName,?>
msg     MSG             <?>

.code

main PROC
	INVOKE  GetModuleHandle,NULL            ;取得模組代碼
	mov     hInstance,eax
	INVOKE  GetCommandLine                  ;取得命令列字串參數位址
	mov     CommandLine,eax
	mov     wc.style,CS_HREDRAW or CS_VREDRAW
	mov     wc.lpfnWndProc,OFFSET WndProc
	mov     eax,hInstance
	mov     wc.hInstance,eax
	mov     wc.hbrBackground,COLOR_WINDOW+1
	INVOKE  LoadIcon,NULL,IDI_APPLICATION   ;取得圖示代碼
	mov     wc.hIcon,eax                    ;存入圖示代碼
	mov     wc.hIconSm,eax                  ;存入小圖示代碼
	INVOKE  LoadCursor,NULL,IDC_ARROW       ;取得游標代碼
	mov     wc.hCursor,eax                  ;存入游標代碼
	INVOKE  RegisterClassEx,OFFSET wc       ;註冊視窗類別

	INVOKE  CreateWindowEx,NULL,OFFSET ClassName,OFFSET AppName,\
			WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,CW_USEDEFAULT,\
			CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,hInstance,NULL
	mov     hwnd,eax
	INVOKE  ShowWindow,hwnd,SW_SHOWDEFAULT
	INVOKE  UpdateWindow,hwnd
 
gt_msg:
	INVOKE  GetMessage,OFFSET msg,NULL,0,0
	or      eax,eax
	jz      wm_qut
	INVOKE  TranslateMessage,OFFSET msg
	INVOKE  DispatchMessage,OFFSET msg
	jmp     gt_msg
wm_qut:
	mov     eax,msg.wParam                  ;程式結束
    INVOKE  ExitProcess,eax
	ret
main ENDP

WndProc PROC    hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
        cmp     uMsg,WM_DESTROY
        jne     msg_process
        INVOKE  PostQuitMessage,NULL
        jmp     exit
msg_process:
        INVOKE  DefWindowProc,hWnd,uMsg,wParam,lParam
        ret
exit:   xor     eax,eax
        ret
WndProc ENDP

END main