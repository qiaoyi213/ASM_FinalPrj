INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

.data

.code

Collision_Check PROC USES ebx, lParam:LPARAM, X:DWORD, Y:DWORD
	LOCAL mouseX: DWORD
	LOCAL mouseY: DWORD

    mov eax, lParam
    and eax, 0ffffh
    mov mouseX, eax
    mov eax, lParam
    shr eax, 10h
    mov mouseY, eax
    ; .IF Tmp_Mob.X <= mouseX  AND Tmp_Mob.X >= mouseX and Tmp_Mob.Y <= mouseY and Tmp_Mob.Y >= mouseY
	; 	mWrite "ATTACK"
    ; .ENDIF
    mShow mouseX
    mShow mouseY
    mov ebx, mouseX
    add ebx, 30
    .IF X <= ebx
        mov ebx, mouseX
        .IF X >= ebx
            mov ebx, mouseY
            add ebx, 44
            .IF Y <= ebx
                mov ebx, mouseY
                .IF Y >= ebx
                    mov eax, 1
                    ; mWrite "ATTACK"
                    ret
                .ENDIF
            .ENDIF
        .ENDIF
    .ENDIF
    
    mov eax, 0
    ret
Collision_Check ENDP
END