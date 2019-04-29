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
link		FILL		4
		
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
		adr		r0, link
		str		lr, [r0]
		
		
		mov		r2, r3, lsr #16	;puts top half of r2 (a) in r1 | (top a)
		bic		r3, r3, r2, lsl #16 ;puts bottom half of r2 (a) in r2 | (bottom a)
		
		mov		r4, r5, lsr #16	;puts top half of r4 (b) in r3 | (top b)
		bic		r5, r5, r4, lsl #16	;puts bottom half of r4 (b) in r4 | (bottom b)
		
		
		mov		r8, r2			;moves (top a) into r8
		mov		r9, r4			;moves (top b) into r9
		bl		mul			;(top a) * (top b)
		mov		r1, r10			;moves result (partial sum) to r1
		
		mov		r8, r2			;moves (top a) into r8
		mov		r9, r5			;moves (bottom b) into r9
		bl		mul			;(top a) * (bottom b)
		mov		r2, r10			;moves result (partial sum) to r2
		
		mov		r8, r3			;moves (bottom a) into r8
		mov		r9, r4			;moves (top b) into r9
		bl		mul				;(bottom a) * (top b)
		mov		r4, r10			;moves result (partial sum) to r4
		
		mov		r8, r3			;moves (bottom a) into r8
		mov		r9, r5			;moves (bottom b) into r9
		bl		mul		;(bottom a) * (bottom b)
		mov		r3, r10			;moves result (partial sum) to r3
		
		adds		r2, r2, r4		;add middle parts
		addcs	r1, r1, #0x10000	;add in carry from above
		adds		r3, r3, r2, lsl #16	;LSB 32 bits
		adc		r1, r1, r2, lsr #16	;MSB 32 bits
		adr		r0, link
		ldr		lr, [r0]
		mov		pc, lr
		
		;Multiply	uses	r8 for operand 1, r9 for operand 2, r10 for result
mul		mov		r10, #0		;initialize result register
		
loop		movs		r9, r9, lsr #1	;shifts r9 (b) right 1, writes that back to r9, and sets the status flags
		addcs	r10, r10, r8	;if the carry bit is set, add r8 to r10
		mov		r8, r8, lsl #1	;update r8 (a) by shifting it left 1
		cmp		r9, #1
		bgt		loop			;branch back to loop if r9 is not 0
		
		movs		r9, r9, lsr #1	;shifts r9 (b) right 1, writes that back to r9 (b), and sets the status flags for the last time
		addcs	r10, r10, r8	;if the carry bit is set, add r8 (a) to r10 for the last time
		mov		pc, lr		;returns
