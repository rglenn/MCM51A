$MOD51
;-----------------------------------------------------------------------
;  Example code for MCM51A boards       D. Capson   2002
;
;  Demo program for Comp Eng 3DJ4 Lab #5 Part 1  - using interrupts 
;-----------------------------------------------------------------------

; addresses of some monitor routines that are used

PUTS    equ 003ah   ; send text string to serial port, DPTR shows start, Null ends
CRLF    equ 003ch   ; output CR, LF to serial port

; ... some ASCII characters

CR    equ 0dh
LF    equ 0ah
NULL  equ 0


org 8000h   ; start location
ljmp start

org 8013h   ;  External interrupt (INT1)
ljmp Int1ISR

org 8100h

message: db 'Comp Eng 3DJ4 Demo program', CR, LF,'Displays a message every time an external interrupt comes in on INT1', CR, LF, NULL

ouch:   db ' *** OUCH !! *** ', NULL

start:  mov 81h, #30h       ;  initialize the stack pointer (SFR 81H = SP)
	lcall CRLF          ;  output a cr and linefeed to the terminal
	mov dptr, #message  ;  show the sign-on message on the terminal
	lcall PUTS

; ---------------  main loop -------------------
	
	orl 0A8h, #10000100b  ; interrupt enables  (SFR A8H = IE register)
 
	setb IT1        ; specify edge activated external interrupt for INT1
			    ;   (IT1 = bit 2 of TCON)

wait:   sjmp wait	; program loops here waiting for interrupts


; --------------- interrupt service routine for INT1  -----------------------
Int1ISR:
	mov dptr, #ouch       ; display "** Ouch !! **"
	lcall PUTS
	reti
;----------------------------------------------------------------------------

end