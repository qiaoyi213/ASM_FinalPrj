INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc


.data


.code
Mob_init PROTO, :PTR Mob, :DWORD, :DWORD, :DWORD, :DWORD


Level_Load PROC USES esi eax, level: DWORD, Mobs: PTR Mob

    
    .IF level == 1
        mWriteLn "Load Level"


        mov ecx, 5
        
        mov esi, Mobs

        invoke Mob_init, esi, _MOB_SLIME_ID, 640, 360, 100
        add esi, TYPE Mob

        
        invoke Mob_init, esi, _MOB_SLIME_ID, 740, 360, 100
        add esi, TYPE Mob
        
        
        invoke Mob_init, esi, _MOB_SLIME_ID, 540, 360, 100
        add esi, TYPE Mob
        
        invoke Mob_init, esi, _MOB_SLIME_ID, 640, 260, 100
        add esi, TYPE Mob

        
        invoke Mob_init, esi, _MOB_SLIME_ID, 640, 460, 100

        
    .ENDIF

    ret
Level_Load ENDP


Mob_init PROC USES esi eax, mob: PTR Mob, _type: DWORD, X: DWORD, Y:DWORD, HP:DWORD

	mov esi, mob
    mShow esi
	mov eax, _type
	mov (Mob PTR [esi])._type, eax
	mov eax, X
	mov (Mob PTR [esi]).X, eax
    
	mov eax, Y
	mov (Mob PTR [esi]).Y, eax
	mov eax, HP
	mov (Mob PTR [esi]).HP, eax

    ret
Mob_init ENDP

END