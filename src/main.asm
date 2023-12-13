INCLUDE Ervine32.inc
INCLUDE WINDOWS.inc
INCLUDE WinUser.inc
INCLUDE Macros.inc

INCLUDE Reference.inc

extern Window_init: PROC
extern Window_create: PROC
extern Window_handleMsg: PROC

extern StartMenu_init: PROC
extern Game_init: PROC
.data
	hInstance	HINSTANCE	?
	
	; States
	; 0 : start menu
	; 1 : in game
	State		DWORD		0
.code

main PROC
	call Boot
	call Window_init
 	call StartMenu_init
	call Game_init

	call Window_create	
	call Window_handleMsg


	invoke  ExitProcess, eax

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

main_getState PROC
	mov eax, State
	ret
main_getState ENDP


END main