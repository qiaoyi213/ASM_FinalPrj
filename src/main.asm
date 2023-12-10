INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

Mob STRUCT
	namePTR DWORD ?
	health	DWORD 0
Mob ENDS

.data
	hInstance	HINSTANCE ?
.code
	extern Window_init: PROC

main PROC
	call Boot
	call Window_init

	ret
main ENDP

Boot PROC USES eax ebx ecx edx esi edi
	invoke	GetModuleHandle, NULL
	mov		hInstance, eax

	ret
Boot ENDP

main_getHInstance PROC
	mov eax, hInstance
	ret
main_getHInstance ENDP

END main