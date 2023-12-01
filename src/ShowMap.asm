INCLUDE Irvine32.inc
INCLUDE macros.inc
.data

BUFSIZE = 5000
buffer BYTE BUFSIZE DUP(?)
fileName BYTE "data", 0
tmp BYTE ?
.code

extern ReadMapFromFile: PROTO, :PTR BYTE, :PTR BYTE
extern GetItem: PROTO, :PTR BYTE, :WORD, :WORD

ShowPart PROTO, :WORD, :WORD, :WORD, :WORD
ShowMap PROC USES eax ebx ecx edx
 
	invoke ReadMapFromFile, OFFSET buffer, OFFSET fileName
	; mov edx, OFFSET buffer
	; call WriteString
	
	; invoke GetItem, OFFSET buffer, 0, 0, ADDR tmp
	; invoke GetItem, OFFSET buffer, 1,0
	invoke ShowPart, 0,0, 3, 2 

	ret

ShowMap ENDP

ShowPart PROC USES eax ebx ecx edx, fx: WORD, fy: WORD, tx: WORD, ty: WORD
	LOCAL xLen: WORD
	LOCAL yLen: WORD
	LOCAL x: WORD
	LOCAL y: WORD

	mov ax, tx
	sub ax, fx
	mov xLen, ax
	inc xLen
	
	mov ax, ty
	sub ax, fy
	mov yLen, ax
	inc yLen

	movzx ecx, yLen
	mov ax, fx
	; call DumpRegs
L1:
	push ecx

	movzx ecx, xLen
	mov bx, fy
L2: 
	; call DumpRegs
	invoke GetItem, OFFSET buffer, ax, bx

	inc bx
	loop L2
	mWriteLn " "
	pop ecx

	inc ax
	loop L1

	ret
ShowPart ENDP
END
