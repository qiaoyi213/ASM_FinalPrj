INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern Number_to_String:PROTO, :DWORD, :PTR BYTE, :DWORD

.data
LifeText    BYTE        "5"
.code 

DrawLife PROC USES ecx, hdcBuffer: HDC
    LOCAL   OldMode: DWORD
	invoke 	SetBkMode, hdcBuffer, TRANSPARENT								;設定以透明顯示
    mov     OldMode, eax

	invoke	TextOut, hdcBuffer, 100, 20, OFFSET LifeText, LENGTHOF LifeText
	invoke 	SetBkMode, hdcBuffer, OldMode										;設定回原本的模式顯示
    ret
DrawLife ENDP


END
