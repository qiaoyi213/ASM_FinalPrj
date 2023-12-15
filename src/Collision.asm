INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE Macros.inc
INCLUDE Reference.inc

.data

.code

Collision_Check PROC USES ebx edx, lParam: LPARAM, mob: Mob
	LOCAL mouseX: DWORD
	LOCAL mouseY: DWORD
	
	mov eax, lParam
	and eax, 0ffffh
	mov mouseX, eax
	mov eax, lParam
	shr eax, 10h
	mov mouseY, eax

	mov ebx, mob.X
	mov edx, mob.X
	add edx, mob._width
	.IF mouseX < ebx || edx < mouseX
		mov eax, 0
		ret
	.ENDIF

	mov ebx, mob.Y
	mov edx, mob.Y
	add edx, mob._height
	.IF mouseY < ebx || edx < mouseY
		mov eax, 0
		ret
	.ENDIF

	mov eax, 1
	ret
Collision_Check ENDP
END