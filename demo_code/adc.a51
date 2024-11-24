$MOD51
;-----------------------------------------------------------------------
;  Example code for MCM51 boards       D. Capson  2002
;
;  Lab #5  -  collect a sample from ADC and display via the DAC Interface
;-----------------------------------------------------------------------

; addresses of monitor routines that are used

PUTS    equ 003ah   ; send text string to serial port, DPTR shows start, Null ends
CRLF    equ 003ch   ; output CR, LF to serial port

; ... some ASCII characters

CR    equ 0dh
LF    equ 0ah
NULL  equ 0


org 8000h   ; start location
ljmp start

org 8013h   ;  INT1  vector
ljmp sample

org 8100h

message: db 'Comp Eng 3DJ4 Test program - ADC/DAC Interface', CR, LF, NULL

start:  mov 81h, #30h       ;  initialize the stack pointer (SFR 81H = SP)
	  lcall CRLF          ;  output a cr and linefeed to the terminal
	  mov dptr, #message  ;  show the sign-on message on the terminal
	  lcall PUTS

; ---------------  main loop -------------------

	orl 0A8h, #10000100b  ; interrupt enables  (SFR A8H = IE register)
;         enable INT1 ^
 
	orl 88h, #00000100b   ; INT1 control bit   (SFR 88H = TCON register)
;                    ^  INT1 is edge activated



;  Get things started...

	mov dptr, #1000h        ; issue start-of-convert to ADC by issuing
	movx @dptr, A           ; a /cs0 together with the /WR pulse

wait:   sjmp wait             ;  wait for interrupts to indicate a sample is 
					;  available





; --------------- interrupt service routine for INT1  -----------------------
sample:
	mov dptr, #1000h        ; get the sample from the ADC by 
	movx A, @dptr           ; reading with /cs0 ...

	mov dptr, #1800h        ; ... and put the sample out to the DAC
	movx @dptr, A           ;     by writing to /cs1

; now issue another start-of-convert to initiate the next sample        

	mov dptr, #1000h        ; /cs1 responds to address 1000h
	movx @dptr, A           ; issue the /WR pulse with /cs0
	
	reti
;----------------------------------------------------------------------------


end
