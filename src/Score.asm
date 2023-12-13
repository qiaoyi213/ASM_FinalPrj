INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

.data
Score       DWORD       0
ScoreText   BYTE        "0000"

.code
Number_to_String PROTO, :DWORD, :PTR BYTE
Reverse_String PROTO, :PTR BYTE

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
    
    invoke  Number_to_String, Score, OFFSEt ScoreText
    invoke  Reverse_String, OFFSET ScoreText
	invoke	TextOut, hdcBuffer, 1000, 20, OFFSET ScoreText, LENGTHOF ScoreText
	invoke 	SetBkMode, hdcBuffer, OldMode										;設定回原本的模式顯示
    ret
DrawScore ENDP

Number_to_String PROC USES eax ebx ecx edx edi, num: DWORD, StrPtr: PTR  BYTE
    LOCAL   const10: DWORD
    mov     edi, 4  ; 字串長度
    mov     edx, 10
    mov     const10, edx
    
    mov     eax, num
    mov     esi, StrPtr
transfer_number_loop:
    xor     edx, edx 

    div     const10
    add     edx, 48
    mov     [esi], edx
    dec     edi
    add     esi, (TYPE BYTE)
    
    test    eax, eax
    je      zero_quotient
    jmp     transfer_number_loop

zero_quotient:

    mov ecx, edi
    
padding:
    mov     [esi], 48
    add     esi, (TYPE BYTE)
    loop padding
    

    ret
Number_to_String ENDP


; Reverse_String 程式碼由 ChatGPT 生成，可能含有問題，可能需要進行 Code Review
Reverse_String PROC USES esi edi StrPtr:PTR BYTE
    mov esi, [StrPtr] ; 將字串指標加載到 esi
    xor edi, edi ; 清空 edi

    ; 找到字串長度
    mov edi, 4

    test edi, edi ; 檢查字串長度是否為 0 或 1
    jbe @@EndReverse

    mov esi, [StrPtr] ; 重新設置 esi 為字串指標
    lea edi, [esi + edi - 1] ; 將 edi 指向字串結尾

    ; 反轉字串
    @@ReverseLoop:
        cmp esi, edi ; 比較 esi 和 edi
        jae @@EndReverseLoop ; 如果相遇或交錯，結束循環

        mov al, [esi] ; 加載第一個字元到 al
        mov bl, [edi] ; 加載最後一個字元到 bl

        mov [esi], bl ; 將最後一個字元放到第一個位置
        mov [edi], al ; 將第一個字元放到最後一個位置

        inc esi ; 移動 esi 到下一個字元
        dec edi ; 移動 edi 到上一個字元

        jmp @@ReverseLoop ; 回到循環開頭

    @@EndReverseLoop:
    @@EndReverse:
    ret
Reverse_String ENDP

END