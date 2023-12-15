INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE Reference.inc
INCLUDELIB gdiplus.lib

.data
    hInstance dd ?
    gptoken dd ? ; Define the variable to receive the token
    imgName BYTE "..\\resources\\assets\\image.png", 0
    BmpImage DWORD ?
    pGraphics QWORD ?
    gpstart GdiplusStartupInput <1,0,0,0>
    
.code

PlotIMG PROC, hwnd: HWND
    ; Initialize GDI+

    invoke GdiplusStartup, ADDR gptoken, ADDR gpstart, NULL

    invoke GdipCreateFromHWND, hwnd, addr pGraphics

    invoke GdipFillRectangleI, pGraphics
    ret

PlotIMG ENDP

END
