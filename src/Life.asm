INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc


extern Resource_getHeartImgHandle: PROTO, :DWORD
.data
Life    DWORD    5
.code 

Life_Sub PROC USES edx, num: DWORD
    mov edx, num
    sub Life, edx
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

DrawLife PROC USES ecx edx, hdcBuffer: HDC

    
    invoke	Resource_getHeartImgHandle,1
    INVOKE  SelectObject, hdcBuffer, eax									;選入筆刷
    mov edx, 0
    mov ecx, Life
draw_life_loop:
    push ecx
    push edx
	INVOKE  PatBlt, hdcBuffer, edx, 0, 36, 32, PATCOPY	;填充筆刷
    pop edx
    pop ecx
    add edx,36
    loop draw_life_loop
	
    ret
DrawLife ENDP


END
