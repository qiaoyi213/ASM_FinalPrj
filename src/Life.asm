INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE gdiplus.inc
INCLUDE Reference.inc

extern Resource_getHeartImg: PROTO, :DWORD

.data
Life    DWORD    5
.code 

Life_Sub PROC USES edx, num: DWORD
    mov edx, num
    sub Life, edx
    mShow Life
    ret
Life_Sub ENDP

Life_Add PROC USES edx, num: DWORD
    mov edx, num
    add Life, edx
    ret
Life_Add ENDP

Life_Change PROC USES edx, num: DWORD
    mov edx, num
    mov Life, edx
    ret
Life_Change ENDP

DrawLife PROC USES ebx ecx edx, mainGraphic: DWORD
	LOCAL HF: DWORD
	LOCAL HE: DWORD

	invoke Resource_getHeartImg, 1
	mov HF, eax
	invoke Resource_getHeartImg, 0
	mov HE, eax

	mov ecx, 0
	mov edx, 0
	.WHILE ecx < 5
		.IF ecx < Life
			mov ebx, HF
		.ELSE
			mov ebx, HE
		.ENDIF

		invoke	GdipDrawImagePointRectI, mainGraphic, ebx, edx, 0, 0, 0, 36, 32, UnitPixel
		add edx, 36
		inc ecx
	.ENDW
    ret
DrawLife ENDP


END