		;		ARM Programming Assignment #3: 32 bit IEEE 754 single-precision multiplier
		;
		;		Write a 32-bit floating point multiplier. The numbers will be represented
		;       in the single-precision IEEE 754 floating-point standard. The result should
		;       also be in IEEE 754 binary32. Assume you only have normalized numbers, i.e.
		;       the exponent is never 0b00000000.
		;		Write the result in the provided "fill" word.

		;		Your code here

floats	DCD		0xa0bcff0d, 0x13c0adea
result	FILL	8


main
		adr		r1, floats
		ldr		r0, [r1], #4
		bl		convert
		adr		r2, result
		str		r0, [r2], #4
		ldr		r0, [r1]
		bl		convert
		str		r0, [r2]
		end
		
		
		
		
		
convert
		str		r1, [sp, #-4]!
		str		r2, [sp, #-4]!
		str		r3, [sp, #-4]!
		str		r4, [sp ,#-4]!
		mov		r2, r0
		mov		r1, #1
		lsl		r1, r1, #31
		and		r3, r2, r1  ;unpack sign to r3 ready to repack
		lsl		r4, r2, #1
		lsr		r4, r4, #24 ;unpack	exponent to r4
		lsl		r2, r2, #9
		lsr		r2, r2, #9 ;unpack significandto r2
		sub		r2, r2, #255
		lsl		r2, r2, #9
		lsl		r4, r4, #1
		add		r0, r0, r4
		add		r0, r0, r2
		add		r0, r0, r3
		ldr		r4, [sp], #4
		ldr		r3, [sp], #4
		ldr		r2, [sp], #4
		ldr		r1, [sp], #4
		mov		pc, lr
