$MOD51
;-----------------------------------------------------------------------
;  Example code for MCM51A boards       D. Capson   2002
;
;  Demo program for Comp Eng 3DJ4 Lab #5  - using the timer/counter and interrupts 
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

org 800bh   ;  Timer 0 overflow interrupt (TF0)
ljmp timer

org 8100h

message: db 'Comp Eng 3DJ4 Demo program - display a clock tick from internal timer interrupt ', CR, LF, NUll

tick:   db 'Tick! ', NULL

start:  mov 81h, #30h       ;  initialize the stack pointer (SFR 81H = SP)
	lcall CRLF          ;  output a cr and linefeed to the terminal
	mov dptr, #message  ;  show the sign-on message on the terminal
	lcall PUTS

; ---------------  main loop -------------------

	mov R7, #0fh          ; a counter for keeping track of 15 interrupts

	orl TMOD, #01h        ; select timer 0 to be a 16-bit count
			      ; (notice that TMOD is not bit-adressable) 
			      
	mov 8Ch, #0fh         ;  intial value of timer to give 1/15 sec 
	mov 8Ah, #19h         ;  SFR 8Ch = TH0    SFR 8Ah = TL0
			      ;  Timer counts up at freq = clock freq/12        
			      ;  therefore, we get a new clock pulse 
			      ;  every 1.085 microsec.  Timer overflow 
			      ;  interrupts when timer hits zero.

	orl 0A8h, #10000010b  ; interrupt enables  (SFR A8H = IE register)
 
	setb TR0            ; start timer 0  ( TR0 = bit 5 of TCON )

wait:   sjmp wait




; --------------- interrupt service routine for timer 0  -----------------------
timer:

   ;  get timer 0 started again immediately

	mov 8Ch, #0fh        ;  intial value of timer to give 1/15 sec 
	mov 8Ah, #19h        ;  SFR 8Ch = TH0    SFR 8Ah = TL0
	setb TR0

	djnz R7, exit     ; check if its the 15th time its been interrupted
cpl P1.3          ; complement Port 1, bit 3 so we can observe with scope
	mov dptr, #tick   ; if it is, then display "Tick!"
	lcall PUTS        ;  ie. exactly 1 sec has elapsed

	mov R7, #0fh      ; reset our counter for 15 interrupts

exit:   reti

end
