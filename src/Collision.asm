INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

.data

.code

Detect_Collision PROC USES ecx, lParam:lParam
	LOCAL mouseX: DWORD
	LOCAL mouseY: DWORD

	mov ecx, 5
	mov edi, 0
detect_collision_loop:

	

	add edi, TYPE Mob
	loop detect_collision_loop
Detect_Collision ENDP

END