$MOD51
;-----------------------------------------------------------------------
;  Example code for MCM51A boards       D. Capson   2002
;
;  Output a ramp function to DAC Interface
;-----------------------------------------------------------------------

org 8000h   ; start location
ljmp start


org 8010h

start:

	mov a, #00h

again: inc a             
	 mov dptr, #1800h        ;  put the sample out to the DAC
	 movx @dptr, A           ;  by writing to /cs1
	 sjmp again
	
end
