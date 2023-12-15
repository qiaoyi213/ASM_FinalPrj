INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

extern Mob_spawn: PROTO, :DWORD, :PTR Mob

.data

mobLevel1		DWORD		5, -1
mobLevel2		DWORD		10, -1
mobLevel3		DWORD		5, 5, -1

mobWaveList		DWORD		OFFSET mobLevel1, OFFSET mobLevel2, OFFSET mobLevel3

.code


Level_Load PROC USES eax ebx edx esi edi, level: DWORD, mobListPtr: PTR Mob
	LOCAL mobAmount: DWORD
	
	mov mobAmount, 0

	; eax = (level - 1) * 4
	mov edx, level
	dec edx
	mov eax, TYPE DWORD
	mul edx

	mov esi, mobWaveList[eax]

	mov ebx, 0	; mob type
	mov edi, mobListPtr

	.WHILE 1
		mov eax, DWORD PTR [esi]

		.BREAK .IF eax == -1
		
		add mobAmount, eax
		.REPEAT
			invoke Mob_spawn, ebx, edi
			add edi, TYPE Mob
			dec eax
		.UNTIL eax <= 0

		inc ebx
		add esi, TYPE DWORD
	.ENDW

	mov ecx, mobAmount	; return mobAmount
	ret
Level_Load ENDP

END