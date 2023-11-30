INCLUDE Irvine32.inc

.data

.code
SubString PROC USES eax ecx edx esi edi, StringPtr: PTR BYTE, StartPos: DWORD, Len: DWORD,  ResultPtr: PTR BYTE
	mov esi, StringPtr
	mov edi, ResultPtr
	add esi, StartPos

	mov ecx, Len
	cld
	rep movsb

	ret
SubString ENDP

END