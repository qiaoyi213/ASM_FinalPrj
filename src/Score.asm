INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern Number_to_String:PROTO, :DWORD, :PTR BYTE, :DWORD
extern Reverse_String: PROTO, :PTR BYTE, :DWORD

.data
Score       DWORD       0
ScoreText   BYTE        "0000"

.code


Score_Get PROC 
    mov eax, Score
    ret
Score_Get ENDP

Score_Change PROC USES eax, num: DWORD
    mov     eax, num
    mov     Score, eax
    ret
Score_Change ENDP

Score_Add PROC USES eax, num: DWORD
    mov     eax, num
    add     Score, eax
    ret
Score_Add ENDP

Score_Sub PROC USES eax, num:DWORD
    mov     eax, num
    sub     Score, eax
    ret
Score_Sub ENDP

DrawScore PROC USES eax , hdcBuffer:HDC
    LOCAL   OldMode: DWORD
	invoke 	SetBkMode, hdcBuffer, TRANSPARENT								;設定以透明顯示
    mov     OldMode, eax
    
    invoke  Number_to_String, Score, OFFSEt ScoreText, 4
    invoke  Reverse_String, OFFSET ScoreText, 4
	invoke	TextOut, hdcBuffer, 1000, 20, OFFSET ScoreText, LENGTHOF ScoreText
	invoke 	SetBkMode, hdcBuffer, OldMode										;設定回原本的模式顯示
    ret
DrawScore ENDP

END