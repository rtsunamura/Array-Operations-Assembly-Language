INCLUDE Irvine32.inc
.data
	prompt1 byte "[1] Manually enter in values that will be stored in an array: ",0
	prompt2 byte "[2] Randomly fill an array with values between 100 - 200: ",0
	prompt3 byte "[3] Find the minimum value in the array: ",0
	prompt4 byte "[4] Find the maximum value in the array: ",0
	prompt5 byte "[5] Find the median value in the array: ",0
	prompt6 byte "[6] Print the array ",0
	prompt7 byte "[7] Run a selection sort on the array: ",0
	prompt8 byte "[8] Quit:",0

	promptA byte "Enter (0 - 8): "
	promptB byte " Enter value ",0
	promptC byte " Set Value ",0
	promptD byte " ",0
	promptE byte "  (1,4,99,33,22,66,88,41,87)",0
	promptG byte".",0

	array SDWORD 20 dup(?)
	array2 SDWORD 1,4,99,33,22,66,88,41,87
	count DWORD ?
	Median1 DWORD ?
	Median2 DWORD ?

.code
main proc
L0:
	mov esi,offset array
	mov ecx,lengthof array
	
	mov edx,offset prompt1
	call WriteString
	call Crlf
	
	mov edx,offset prompt2
	call WriteString
	call Crlf
	
	mov edx,offset prompt3
	call WriteString
	call Crlf
	
	mov edx,offset prompt4
	call WriteString
	call Crlf
	
	mov edi,offset array2
	mov edx,offset prompt5
	call WriteString
	call Crlf
	
	mov edx,offset prompt6
	call WriteString
	call Crlf

	mov edx,offset prompt7
	call WriteString
	call Crlf
	
	mov edx,offset prompt8
	call WriteString
	call Crlf
	Call Crlf

	mov edx,offset promptA
	Call WriteString           ;Ask the user what to do.

	Call ReadInt               
	cmp eax,1
	JNE NEXT2
	Call UserValueStore
NEXT2:
	cmp eax,2
	JNE NEXT3
	Call RandomValueStore
NEXT3:
	cmp eax,3
	JNE NEXT4
	Call FindMinValue
NEXT4:
	cmp eax,4
	JNE NEXT5
	Call FindMaxValue
NEXT5:
	cmp eax,5
	JNE NEXT6
	Call FindMedianValue
NEXT6:
	cmp eax,6
	JNE NEXT7
	Call Print
NEXT7:
	cmp eax,7
	JNE NEXT8
	Call Sort
NEXT8:
	cmp eax,8
	JE Quit
	Call Crlf
JMP L0

Quit:
		exit
main ENDP
;**********************************************************************
UserValueStore proc USES ecx esi eax
mov eax,0
mov ebx,0
mov edx,offset promptA

L1:
	mov eax,ebx
	mov edx,offset promptB
	
	call WriteDec
	call WriteString
	call ReadInt

	mov [esi],eax
	add esi,type array
	add ebx,1
	
	loop L1
	
	ret
UserValueStore ENDP

;****************************************************************
RandomValueStore Proc USES ecx esi eax
	mov ebx,0
	mov edx,offset promptC
L1:	
	mov eax,ebx
	call WriteDec
	call WriteString
	mov eax,101            ;Set the range
	call RandomRange
	add eax,100            ;+100
	mov [esi],eax
	add esi, type array
	add ebx,1
	call WriteInt
	call Crlf

	loop L1

	ret
RandomValueStore ENDP

;************************************************************************

FindMinValue proc USES esi ecx eax
	
	mov eax,[esi]
L1:
	cmp eax,[esi]
	JLE Next

	mov eax,[esi]

Next:
	add esi,type array
	loop L1

call WriteInt
call Crlf
	ret
FindMinValue ENDP
;**************************************************************************
FindMaxValue proc USES esi ecx eax
	
	mov eax,[esi]
L1:
	cmp eax,[esi]
	JGE Next

	mov eax,[esi]

Next:
	add esi,type array
	loop L1

call WriteInt
call Crlf
	ret
FindMaxValue ENDP
;*************************************************************************
FindMedianValue proc USES ecx eax
mov edi,offset array
mov eax,0                     ;currentValue
mov ebx,1                     ;SIndex
sub ecx,1                     ;Loop count
mov edx,0                     ;miniValue
L1:
	mov eax,[edi]             ;eax = min Value
	mov count,ecx             
	mov ecx,ebx               
	push edi                  ;Push esi
	mov edi,offset array      ;Reset array elements 
L2:                           ;set the element(min + 1)
	add edi,type array        
	loop L2
	mov ecx,20                
	sub ecx,ebx                

L3:
	mov edx,[edi]             
	cmp eax,edx               
	JNGE NEXT                 
	xchg eax,edx              
	mov [edi],edx             
NEXT:
	add edi,type array
	Loop L3
	
	pop edi
	mov [edi],eax
	add edi,type array
	add ebx,1
	mov ecx,count
	loop L1


	mov edi,offset array
    add edi,36
    mov eax,[edi]
    mov Median1,eax
    add edi,4
    mov ebx,[edi]
    mov Median2,ebx
   
    add eax,ebx   
    cdq                        ;Using CH7 staff
    mov ebx,2
    idiv ebx

    Call WriteInt 
   
    mov eax,edx
    mov edx,offset promptG

    cmp eax,1
    JNE NEXT2
    mov eax,5
NEXT2:
    Call WriteString
    Call WriteDec
    Call Crlf
	ret
FindMedianValue ENDP
;*************************************************************************
Print proc USES ecx esi eax
L1:
mov eax,[esi]
call WriteInt
mov al,' '           
call WriteChar               
add esi,type array
loop L1

Call Crlf
 ret
Print ENDP
;*************************************************************************
Sort proc USES esi ecx eax
mov eax,0                     ;currentValue
mov ebx,1                     ;SIndex
sub ecx,1                     ;Loop count
mov edx,0                     ;miniValue
L1:
	mov eax,[esi]             ;eax = min Value
	mov count,ecx             
	mov ecx,ebx               
	push esi                  ;Push esi
	mov esi,offset array      ;Reset array elements 
L2:                           ;set the element(min + 1)
	add esi,type array        
	loop L2                   
	mov ecx,20                
	sub ecx,ebx                

L3:
	mov edx,[esi]             
	cmp eax,edx               
	JNGE NEXT                 
	xchg eax,edx              
	mov [esi],edx             
NEXT:
	add esi,type array
	Loop L3
	
	pop esi                      
	mov [esi],eax
	add esi,type array
	add ebx,1
	mov ecx,count
	loop L1
	ret
Sort ENDP
;*************************************************************************

END main


