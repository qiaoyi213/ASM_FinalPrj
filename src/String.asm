INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

.data

.code

Number_to_String PROC USES eax ebx ecx edx esi edi, num: DWORD, StrPtr: PTR  BYTE, str_len: DWORD
    mov esi, str_len
    dec esi
    mov ecx, 0
    .WHILE ecx < str_len
        push ecx
            mov ecx, 0
            mov eax, 1
            mov ebx, 10
            .WHILE ecx < esi
                mul ebx
                inc ecx
            .ENDW
        pop ecx

        mov ebx, eax

        mov edx, 0
        mov eax, num
        div ebx

        mov edi, StrPtr
        add edi, esi
        mov [edi], 48
        .IF eax < 10
            add [edi], eax
        .ENDIF

        mul ebx
        sub num, eax
        
        dec esi
        inc ecx
    .ENDW
    ret
Number_to_String ENDP


; Reverse_String 程式碼由 ChatGPT 生成，可能含有問題，可能需要進行 Code Review
Reverse_String PROC USES esi edi StrPtr:PTR BYTE, str_len:DWORD
    mov esi, [StrPtr] ; 將字串指標加載到 esi
    xor edi, edi ; 清空 edi

    ; 找到字串長度
    mov edi, str_len

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