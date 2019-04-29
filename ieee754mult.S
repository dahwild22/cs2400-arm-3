		;		ARM Programming Assignment #3: 32 bit IEEE 754 single-precision multiplier
		;
		;		Write a 32-bit floating point multiplier. The numbers will be represented
		;		in the single-precision IEEE 754 floating-point standard. The result should
		;		also be in IEEE 754 binary32. Assume you only have normalized numbers, i.e.
		;		the exponent is never 0b00000000.
		;		Write the result in the provided "fill" word.
		
		;		Your code here
		
floats	DCD		0xa0bcff0d, 0x13c0adea
result	FILL		8
space		FILL		4
		
main
		adr		r0, floats 							; get ready to load  numbers into adress
		ldr		r1, [r0], #4							; load first number into address r1
		ldr		r2, [r0], #8							; load second number into address r2
		adr		r0, result							; r0 no longer needed, get ready to put answer into r0
		lsl		r1, r1, #9							;isolate whole number
		lsr		r3, r1, #1							;move back 1
		lsl		r2, r2, #9
		lsr		r4, r2, #1
		mov		r5, #10								; counter
		bl		multiply							;branch to multiply instruction
		mov		r2, r3								;places top half in r1, and bottom half in r2
		lsl		r1, r1, #2							;gets rid of understood bits
		lsr		r1, r1, #2							;lines up r2 again
		mov		r3, #10								;initializes counter
		
shift	

		lsrs		r1, r1, #1
		lsr		r2, r2, #1
		subs		r3, r3, #1
		bne		shift
		
		adr		r0, floats
		ldr		r6, [r0], #4
		ldr		r7, [r0]
		lsr		r6, r6, #23		
		lsr		r7, r7, #23		
		lsr		r4, r6, #8	
		lsr		r5, r7, #8		
		eors		r3, r4, r5		
		
		add		r6, r6, r7
		sub		r6, r6, #0x7f		
		lsl		r6, r6, #20
		add		r1, r1, r6
		adr		r0, result
		str		r1, [r0], #4
		str		r2, [r0]
		
		end
		
multiply
		adr		r0, space
		str		lr, [r0]
		
		
		mov		r2, r3, lsr #16	
		bic		r3, r3, r2, lsl #16 
		
		mov		r4, r5, lsr #16	
		bic		r5, r5, r4, lsl #16	
		
		
		mov		r8, r2		
		mov		r9, r4			
		bl		mul	
		mov		r1, r10		
		
		mov		r8, r2		
		mov		r9, r5		
		bl		mul			
		mov		r2, r10			
		
		mov		r8, r3			
		mov		r9, r4
		bl		mul		
		mov		r4, r10		
		
		mov		r8, r3			
		mov		r9, r5			
		bl		mul	
		mov		r3, r10			
		
		adds		r2, r2, r4		
		addcs	r1, r1, #0x10000	
		adds		r3, r3, r2, lsl #16	
		adc		r1, r1, r2, lsr #16	
		adr		r0, space
		ldr		lr, [r0]
		mov		pc, lr
		
		;Multiply	uses	
mul		mov		r10, #0		
		
loop		movs		r9, r9, lsr #1
		addcs	r10, r10, r8	
		mov		r8, r8, lsl #1	
		cmp		r9, #1
		bgt		loop			
		
		movs		r9, r9, lsr #1	
		addcs	r10, r10, r8	
		mov		pc, lr	
