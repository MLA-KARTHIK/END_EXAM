     area     appcode, CODE, READONLY
	 IMPORT printMsg
	 IMPORT printMsg1	 
	 IMPORT printMsg2p
	 export __main	
	 ENTRY 
__main  function		 
		VLDR.F32   s29, =20					; Radius value in pixel
		VCVT.U32.F32  s15, s29
		VMOV.F32   r0, s15
		BL printMsg
		VLDR.F32   s30, =50					; Center of circle "x value"
		VLDR.F32   s31, =50					; Center of circle "Y value"
		VLDR.F32   s15, =10					; Dummy variable
		VLDR.F32   s16, =360				; to compare
		VLDR.F32   s17, = 640				; Pixel x value
		VLDR.F32   s18, = 480				; pixel y value
		VLDR.F32   s25, =0 					; Teta value
LB		VLDR.F32   s26, = 3.14285714285    	; pi value
		VLDR.F32   s28, =180.00
		VLDR.F32   s0, = 1
		VMUL.F32   s0, s25, s26
		VDIV.F32   s0, s0, s28
		;VLDR.F32   s0, =1.57079				; X value
		VLDR.F32   s1, =20				; No of iterations
		
		;VLDR.F32   s20, =3.142857
		;VLDR.F32   s21, =180
		
	;	VMUL.F32   s0, s0, s20
	;	VDIV.F32   s0, s0, s21
		
		;vpush	   {s0}
		;vpush	   {s1}
		BL sinx							; calculate sine x value
sin1	;vpop	   {s23}					; sine result
		VMOV.F32   s23, s4
		;vpush      {s0}
		;vpush	   {s1}
		BL cosx
cos1	;vpop       {s21}				; s21 will have cos x value
		VMOV.F32    s21, s4
		
		;vpush      {s29}
		;vpush      {s23}
		;vpush      {s21}
		BL XY_co
		;vpop	   {s13}				; Popping x cordinate value
		;vpop	   {s14}				; Popping y cordinate value
		VLDR.F32   s17, = 640				; Pixel x value
		VLDR.F32   s18, = 480				; pixel y value
		;VABS.F32   s13, s13
		;VABS.F32   s14, s14
		VADD.F32   s13, s13, s30		; Adding the center corinate 
		VADD.F32   s14, s14, s31		; Adding the center corinate
		
		VCMP.F32   s13, #0
		vmrs    APSR_nzcv, FPSCR
		BGE        LM
		VLDR.F32   s13, =0
		
		
LM	    VCMP.F32   s13, s17
		vmrs    APSR_nzcv, FPSCR
		BLE        M1
		VLDR.F32   s13, =639
		
M1		VCMP.F32   s14, #0
		vmrs    APSR_nzcv, FPSCR
		BGE        M2
		
M2  	VCMP.F32   s14, s18
		vmrs    APSR_nzcv, FPSCR
		BLE        M3		
		VLDR.F32   s13, =479
		
M3		VCVT.U32.F32  s13, s13
		VCVT.U32.F32  s14, s14
		VCVT.U32.F32  s15, s25
		VMOV.F32   r0, s15
		BL printMsg1
		VMOV.F32   r0, s13				
		VMOV.F32   r1, s14
		BL printMsg2p
		VLDR.F32   s15, =10					; Dummy variable
		VADD.F32   s25, s25, s15
		VLDR.F32   s16, =360				; to compare
		VCMP.F32   s25, s16
		vmrs    APSR_nzcv, FPSCR
		BLE        LB
		B stop							; stopping the program
		
XY_co	;vpop	   {s10}				; poping value of cosine
	    ;vpop 	   {s11}				; Poping value of sine
		;vpop       {s12}				; pop radius value
		VMOV.F32   s10, s21
		VMOV.F32   s11, s23
		VMOV.F32   s12, s29
		VLDR.F32   s13, =1				; this will have final x cordinate value
		VLDR.F32   s14, =1				; This will have y value
		VMUL.F32   s13, s12, s10
		VMUL.F32   s14, s12, s11
		;vpush      {s14}
		;vpush	   {s13}
		BX lr
		
		
sinx	;vpop	   {s2}					; Pop No of iteration         s2= s1
		;vpop	   {s3}					; Pop x value					s3= s0
		VMOV.F32   s2, s1
		VMOV.F32   s3, s0
		VLDR.F32   s4, =0				; Final sine results stored in s4
		VLDR.F32   s5, =1				; To calculate power and factorial
		VLDR.F32   s9, =2
		VLDR.F32   s10, =1				; Just to compare
		VLDR.F32   s19, =1
Loop1	;vpush	   {s3}
		;vpush      {s5}
		BL multy
		VMOV.F32    s6, s15
		;vpop       {s6}
		;vpush      {s5}
		BL fact
		;vpop       {s7}
		VMOV.F32    s7, s17
		VDIV.F32   s8, s6, s7
		VCMP.F32   s19, s10
		vmrs    APSR_nzcv, FPSCR
		BEQ        gre
		VSUB.F32   s4, s4, s8
		VADD.F32   s19,s19,s10
		B next1
gre		VADD.F32   s4, s4, s8
		VSUB.F32   s19,s19,s10
next1	VADD.F32   s5, s5, s9
		VSUB.F32   s2, s2, s10
		VCMP.F32   s2, #0
		vmrs    APSR_nzcv, FPSCR
		BGT Loop1
		;vpush      {s4}
		B sin1
		
cosx    ;vpop	   {s2}					; Pop No of iteration
		;vpop	   {s3}					; Pop x value
		VMOV.F32   s2, s1
		VMOV.F32   s3, s0
		VLDR.F32   s4, =1				; Final cosine results stored in s4
		VLDR.F32   s5, =2				; To calculate power and factorial
		VLDR.F32   s9, =2
		VLDR.F32   s10, =1				; Just to compare
		VLDR.F32   s19, =1
		
		VSUB.F32   s2, s2, s10
Loop2	;vpush      {s3}
		;vpush      {s5}
		BL  multy
		;vpop       {s6}
		VMOV.F32   s6, s15
		;vpush      {s5}
		BL fact
		;vpop       {s7}
		VMOV.F32   s7, s17
		VDIV.F32   s8, s6, s7
		VCMP.F32   s19, s10
		vmrs    APSR_nzcv, FPSCR
		BEQ    equal
		VADD.F32   s4, s4, s8
		VADD.F32   s19, s19, s10
		B next2
equal	VSUB.F32   s4, s4, s8
		VSUB.F32   s19, s19, s10
next2	VADD.F32   s5, s5, s9
		VSUB.F32   s2, s2, s10
		VCMP.F32   s2, #0
		vmrs    APSR_nzcv, FPSCR
		BGT Loop2
		;vpush      {s4}
		B cos1
		
; Multiply subroutine

multy	;vpop {s11} 						; No of times to multiply
		;vpop {s12}							; Number to multiply
		VMOV.F32  s11, s5
		VMOV.F32  s12, s3
		VMOV.F32  s15, s12
L4		VCMP.F32  s11, s10
		vmrs    APSR_nzcv, FPSCR
		BGT L3
		;vpush  {s15}
		BX lr
L3		VMUL.F32  s15, s15, s12
		VSUB.F32  s11, s11, s10
		B L4


; Factorial subroutine

fact   	;vpop {s16}
		VMOV.F32 s16,s5
		VLDR.F32 s17, = 1
		VLDR.F32 s18, =1
L2	   	VCMP.F32 s16, s18
		vmrs    APSR_nzcv, FPSCR
		BGT L1
		;vpush {s17}
		BX lr
L1	   	VMUL.F32 s17, s17, s16
		VSUB.F32 s16, s16, s18
		B L2
stop    B  stop ; stop program	   
     endfunc
     end