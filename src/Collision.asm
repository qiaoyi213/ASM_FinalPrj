INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

.data

.code

Collision_Check PROC USES ebx, lParam:LPARAM, mob:Mob
	LOCAL mouseX: DWORD
	LOCAL mouseY: DWORD

    mov eax, lParam
    and eax, 0ffffh
    mov mouseX, eax
    mov eax, lParam
    shr eax, 10h
    mov mouseY, eax

    mov ebx, mob.X
    add ebx, 44
    
    ; mShow mob.X
    ; mShow mob.Y
    
    .IF mouseX <= ebx
        mov ebx, mob.X
        
        .IF mouseX >= ebx
            mov ebx, mob.Y
            add ebx, 30
            
            .IF mouseY <= ebx
                mov ebx, mob.Y
                
                .IF mouseY >= ebx
                    mov eax, 1

                    ret
                .ENDIF
            .ENDIF
        .ENDIF
    .ENDIF
    
    mov eax, 0
    ret
Collision_Check ENDP
END