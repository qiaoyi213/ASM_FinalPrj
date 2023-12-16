        .386
        .model flat,stdcall
        option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;include文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include       windows.inc
; include       GDI32.inc

include       gdiplus.inc
INCLUDE Ervine32.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc
include       Reference.inc

includelib    gdiplus.lib

includelib    gdi32.lib
includelib    User32.Lib
includelib    Kernel32.Lib

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.data
GpInput     GdiplusStartupInput <1,0,0,0>
                
hInstance     dd       ?
hWinMain      dd       ?
hToken        dd       ?
                .const
szClassName   db       'MyClass',0
szCaptionMain db       'GDI+!',0
imgName       db        'image.png', 0
imgBuf         Qword       ?
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    .code
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;窗口过程
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_ProcWinMain  proc     uses ebx edi esi,hWnd,uMsg,wParam,lParam
          local    @gdip
          local    @hBrush
         local Clror
          mov eax,uMsg
;*******************************************************************************************
               .if  eax == WM_CREATE
                    invoke GdipLoadImageFromFile,offset imgName, offset imgBuf
                    mShow eax
              .elseif  eax ==  WM_PAINT
                   mov     ebx,hWnd
               .if  ebx == hWinMain
                    invoke  GdipCreateFromHWND,hWnd,addr @gdip
                    ;mov Clror, 064FF0000h
                    ;invoke  GdipCreateSolidFill, Clror ,addr @hBrush
                    ;invoke  GdipFillRectangleI,@gdip,@hBrush,10,10,160,240
                         
                    ;invoke GdipLoadImageFromFile, imgName, offset imgBuf
                    ;invoke GdipGetImageGraphicsContext, 
                    ;invoke GdipDrawImage,@gdip, offset imgBuf,0,0
                    
                    invoke  GdipDeleteBrush,@hBrush
                    invoke  GdipDeleteGraphics,@gdip
               .endif
;********************************************************************************************
              .elseif  eax ==  WM_CLOSE
                   invoke  DestroyWindow,hWinMain
               invoke  PostQuitMessage,NULL
;*******************************************************************************************
              .else    
                   invoke DefWindowProc,hWnd,uMsg,wParam,lParam
               ret
          .endif
;********************************************************************************************
              xor      eax,eax
          ret

_ProcWinMain  endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_WinMain      proc
              local    @stWndClass:WNDCLASSEX
              local    @stMsg:MSG

              invoke   GetModuleHandle,NULL
              mov      hInstance,eax
              invoke   RtlZeroMemory,addr @stWndClass,sizeof @stWndClass
;*******************************************************************************************
;注册窗口类
;*******************************************************************************************
              invoke   LoadCursor,0,IDC_ARROW
              mov      @stWndClass.hCursor,eax
              push     hInstance
              pop      @stWndClass.hInstance
              mov       @stWndClass.cbSize,sizeof WNDCLASSEX
              mov      @stWndClass.style,CS_HREDRAW or CS_VREDRAW
              mov      @stWndClass.lpfnWndProc,offset _ProcWinMain
              mov      @stWndClass.hbrBackground,COLOR_WINDOW+1
              mov      @stWndClass.lpszClassName,offset szClassName
              invoke   RegisterClassEx,addr @stWndClass
;*******************************************************************************************
;建立并显示窗口
;*******************************************************************************************
              invoke   CreateWindowEx,WS_EX_CLIENTEDGE,offset szClassName,\
                       offset szCaptionMain,WS_OVERLAPPEDWINDOW,100,100,200,300,\
                       NULL,NULL,hInstance,NULL
              mov      hWinMain,eax
              invoke   ShowWindow,hWinMain,SW_SHOWNORMAL
              invoke   UpdateWindow,hWinMain
;*******************************************************************************************
;消息循环
;*******************************************************************************************
              .while   TRUE
                   invoke  GetMessage,addr @stMsg,NULL,0,0
                   .break  .if eax ==  0
                   invoke  TranslateMessage,addr @stMsg
                   invoke  DispatchMessage,addr @stMsg
              .endw
              ret
_WinMain      endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
StartGP PROC
          invoke   GdiplusStartup,offset hToken,offset GpInput,NULL
          call     _WinMain
          invoke   GdiplusShutdown,hToken
          invoke   ExitProcess,NULL
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
StartGP ENDP
end  