; INCLUDE Ervine32.inc
; INCLUDE WINDOWS.inc
; INCLUDE Macros.inc
; INCLUDE Reference.inc


; extern Resource_getHeartImgHandle: PROTO, :DWORD
; .data
; Life    DWORD    5
; .code 

; Life_Sub PROC USES edx, num: DWORD
;     mov edx, num
;     sub Life, edx
;     mShow Life
;     ret
; Life_Sub ENDP

; Life_Add PROC USES edx, num: DWORD
;     mov edx, num
;     add Life, edx
;     ret
; Life_Add ENDP

; Life_Change PROC USES edx, num: DWORD
;     mov edx, num
;     mov Life, edx
;     ret
; Life_Change ENDP

; DrawLife PROC USES ecx edx, hdcBuffer: HDC
; 	LOCAL tmpHdc: HDC
    
	
;     invoke 	CreateCompatibleDC, hdcBuffer
; 	mov		tmpHdc, eax
; 	invoke	Resource_getHeartImgHandle, 1
; 	invoke  SelectObject, tmpHdc, eax

;     ; mShow eax
;     mov edx, 0
;     mov ecx, Life
; draw_life_loop:
;     push ecx
;     push edx
    
; 	invoke  BitBlt, hdcBuffer, edx, 0, 36, 32, tmpHdc,\
; 			0, 0, SRCCOPY

;     pop edx
;     pop ecx
;     add edx,36
;     loop draw_life_loop
	
    
; 	invoke  DeleteDC, tmpHdc
;     ret
; DrawLife ENDP


END