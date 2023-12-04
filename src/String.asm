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

AppendString PROC USES eax ebx ecx edx esi edi, DestPtr: PTR BYTE, AppendPtr: PTR BYTE
	mov edi, DestPtr
	mov edx, DestPtr
	call StrLength
	add edi, eax

	mov esi, AppendPtr
	mov edx, AppendPtr
	call StrLength
	mov ecx, eax

	cld
	rep movsb

	ret
AppendString ENDP

END