( COLD

( Last change: default rFACTOR TO 14 INSTEAD OF 22  2-16-95 )

( This code was written for MAXForth CPU from New Micros - 1990)
(Use at your own risk!)
(Don Golding - Forth2020 Facebook Group)

HEX
( save speaker! )
80 B026 C!
0 B000 C!

FORGET TASK

HEX
100 7F00 ERASE

100 TIB !       ( WAS 7D80

( TIB length
50 TIB 2+ !

7EFE 10 ! ( data stack
7FFE  E ! ( return stack

7E40 22 ! ( PAD

( Move end of memory out of ram area
E100 50 !
E000 4E !

ABORT ( DON 5-5-97

( Last revised        04/13/94 02:13:29.07 BY KBB
( modified mulitasker
( improved decompiler
( reconfigured memory
( gave interrupts full user space

( added dynamic relocation of variables, regs, 2vars, and arrays
( removed dynmaic relocation of variables...

( MEMORY MAP for final rom
(    0- 200 USER VARIABLES

(  200-8000 ROM program space ASSEMBLER AT 6000
( 8000-B000 free for VARIABLES, DICTIONARY
( 8000-8C00 CURRENT VARIABLES 3K!   --      1kbuffer and 1k task list space
( 9000          CURRENT DP for base system

( B100-B600 PAD, TIB, DATA STACK, RETURN STACK
(      B140 PAD
(      B180 TIB
( B200-B400 DATA
( B400-B600 RETURN

( B800-C000 interrupt frame USER, PAD, TIB, DATA, RETURN, DICTIONARY
(      B840 PAD
(      B880 TIB
( B900-BA00 USER
( BA00-BB00 DATA
( BB00-BC00 RETURN
( BC00-C000 DICTIONARY

( C000-D000 FREE
( D000-E000 HISTORY BUFFER


( ASM6811

ASSEMBLER DEFINITIONS

200 DP !     ( 9-15-95 WAS 6006
( NOTE: VARIABLE MODE NEEDS TO BE ASSIGNED
(     TO RAM IF THIS TO BE EPROM/ROM'ed
( IE: 8 CONSTANT MODE

( VARIABLE MODE
8 CONSTANT MODE         ( DON

: #   00 MODE ! ;
: DIR 10 MODE ! ;
: ,X  20 MODE ! ;
: ,Y 120 MODE ! ;
: EXT 30 MODE ! ;

EXT ( INITIALIZE MODE VARIABLE

: ?# MODE @ 0= ;
: ?DIR MODE @ 10 = ;
: ?,X MODE @  20 = ;
: ?,Y MODE @ 120 = ;
: ?EXT MODE @ 30 = ;
: MODE-LSB MODE @ FF AND ;
: ERROR EXT ' ID. CFA 4A + EXECUTE ;
: RANGE-C, DUP FF00 AND IF HERE 1+ - DUP ABS FF00 AND
          IF 3 ERROR THEN THEN C, ;

: CPU <BUILDS C, DOES> C@ C, EXT ; ( SINGLE BYTE OP-CODE
: PG-2-CPU <BUILDS C, DOES> 18 C, C@ C, EXT ; ( 18 AND SINGLE BYTE OP-CODE


: HHLL/LL, ?EXT IF , ELSE C, THEN EXT ;
: 2HHLL/LL, ?EXT ?# OR IF , ELSE C, THEN EXT ;
: MODE-ADJ, ( a n --- a
  ?EXT IF OVER FF00 AND 0= IF DIR THEN THEN MODE-LSB OR C, ;
: 18,Y ?,Y IF 18 C, THEN ;
: SOK? ?# IF 3 ERROR THEN ;

: xx12-CPU <BUILDS C, DOES> 18,Y ?# ?DIR OR IF 3 ERROR THEN
         C@ MODE-LSB OR C, HHLL/LL, ;
: 1112-CPU <BUILDS C, DOES> 18,Y C@ MODE-ADJ, HHLL/LL, ;
: x112-CPU <BUILDS C, DOES> 18,Y SOK? C@ MODE-ADJ, HHLL/LL, ;
: 2112-CPU <BUILDS C, DOES> 18,Y C@ MODE-ADJ, 2HHLL/LL, ;

: (OP-DD-MM    18,Y MODE-LSB IF C OR THEN C, C, C, ;
: OP-RR <BUILDS C, DOES> C@ C, RANGE-C, EXT ;
: OP-DD-MM <BUILDS C, DOES> C@ (OP-DD-MM      EXT ;
: OP-DD-MM-RR <BUILDS C, DOES> C@ (OP-DD-MM    RANGE-C, EXT ;

: CPX, ?,Y IF CD C, THEN 8C MODE-ADJ, 2HHLL/LL, ;
: LDX, ?,Y IF CD C, THEN CE MODE-ADJ, 2HHLL/LL, ;
: STX, ?,Y IF CD C, THEN SOK? CF MODE-ADJ,  HHLL/LL, ;
: CPY, ?,X IF 1A ELSE 18 THEN C, 8C MODE-ADJ, 2HHLL/LL, ;
: LDY, ?,X IF 1A ELSE 18 THEN C, CE MODE-ADJ, 2HHLL/LL, ;
: STY, ?,X IF 1A ELSE 18 THEN C, SOK? CF MODE-ADJ, HHLL/LL, ;
: CPD, ?,Y IF CD C, ELSE 1A C, THEN 83 MODE-ADJ, 2HHLL/LL, ;


00 CPU TEST,
01 CPU NOP,
02 CPU IDIV,
03 CPU FDIV,
04 CPU LSRD,
05 CPU ASLD, 05 CPU LSLD,
06 CPU TAP,
07 CPU TPA,
08 CPU INX,
09 CPU DEX,
0A CPU CLV,
0B CPU SEV,
0C CPU CLC,
0D CPU SEC,
0E CPU CLI,
0F CPU SEI,
10 CPU SBA,
11 CPU CBA,
12 OP-DD-MM-RR BRSET,
13 OP-DD-MM-RR BRCLR,
14 OP-DD-MM BSET,
15 OP-DD-MM BCLR,
16 CPU TAB,
17 CPU TBA,
( 18 PAGE 2
19 CPU DAA,
( 1A PAGE 3
1B CPU ABA,
( 1C BSET,
( 1D BCLR,
( 1E BRSET,
( 1F BRCLR,
20 OP-RR BRA,
21 OP-RR BRN,
22 OP-RR BHI,
23 OP-RR BLS,
24 OP-RR BCC,
24 OP-RR BHS,
25 OP-RR BCS,
25 OP-RR BLO,
26 OP-RR BNE,
27 OP-RR BEQ,
28 OP-RR BVC,
29 OP-RR BVS,
2A OP-RR BPL,
2B OP-RR BMI,
2C OP-RR BGE,
2D OP-RR BLT,
2E OP-RR BGT,
2F OP-RR BLE,
30 CPU TSX,
31 CPU INS,
32 CPU PULA,
33 CPU PULB,
34 CPU DES,
35 CPU TXS,
36 CPU PSHA,
37 CPU PSHB,
38 CPU PULX,
39 CPU RTS,
3A CPU ABX,
3B CPU RTI,
3C CPU PSHX,
3D CPU MUL,
3E CPU WAI,
3F CPU SWI,
40 CPU NEGA,
( 41 NC
( 42 NC
43 CPU COMA,
44 CPU LSRA,
( 45 NC
46 CPU RORA,
47 CPU ASRA,
48 CPU ASLA,
49 CPU ROLA,
4A CPU DECA,
( 4B NC
4C CPU INCA,
4D CPU TSTA,
( 4E NC
4F CPU CLRA,
50 CPU NEGB,
( 51 NC
( 52 NC
53 CPU COMB,
54 CPU LSRB,
( 55 NC
56 CPU RORB,
57 CPU ASRB,
58 CPU ASLB,
59 CPU ROLB,
5A CPU DECB,
( 5B NC
5C CPU INCB,
5D CPU TSTB,
( 5E NC
5F CPU CLRB,
( 60-7F
40 xx12-CPU NEG,
43 xx12-CPU COM,
44 xx12-CPU LSR,
46 xx12-CPU ROR,
47 xx12-CPU ASR,
48 xx12-CPU ASL,
49 xx12-CPU ROL,
4A xx12-CPU DEC,
4C xx12-CPU INC,
4D xx12-CPU TST,
4E xx12-CPU JMP,
4F xx12-CPU CLR,
( 80-BF
80 1112-CPU SUBA,
81 1112-CPU CMPA,
82 1112-CPU SBCA,
83 2112-CPU SUBD,
84 1112-CPU ANDA,
85 1112-CPU BITA,
86 1112-CPU LDAA,
87 x112-CPU STAA,
88 1112-CPU EORA,
89 1112-CPU ADCA,
8A 1112-CPU ORAA,
8B 1112-CPU ADDA,
( 8C CPX,
8D x112-CPU JSR,
8E 2112-CPU LDS,
8F x112-CPU STS,
8F CPU XGDX,
( C0-FF
C0 1112-CPU SUBB,
C1 1112-CPU CMPB,
C2 1112-CPU SBCB,
C3 2112-CPU ADDD,
C4 1112-CPU ANDB,
C5 1112-CPU BITB,
C6 1112-CPU LDAB,
C7 x112-CPU STAB,
C8 1112-CPU EORB,
C9 1112-CPU ADCB,
CA 1112-CPU ORAB,
CB 1112-CPU ADDB,
CC 2112-CPU LDD,
CD x112-CPU STD,
( CE LDX,
( CF STX,
CF CPU STOP,

08 PG-2-CPU INY,
09 PG-2-CPU DEY,
30 PG-2-CPU TSY,
35 PG-2-CPU TYS,
38 PG-2-CPU PULY,
3A PG-2-CPU ABY,
3C PG-2-CPU PSHY,

8F PG-2-CPU XGDY,

8D OP-RR BSR,


: TOP ,Y    0  ;      ( ADDRESS THE BOTTOM OF THE STACK   *
: SEC ,Y    2  ;      ( ADDRESS SECOND ITEM ON STACK     *

: ?EXEC STATE @ IF 12 ERROR THEN ;
: ?PAIRS - IF 13 ERROR THEN ;

: BEGIN,   HERE        1   ;
: UNTIL,   ?EXEC >R 1 ?PAIRS R> C, HERE        1+ - C, ;
: AGAIN,   20 UNTIL, ;
: IF,        C,    HERE  0     C,    2  ;
: THEN,          ?EXEC  2    ?PAIRS    HERE OVER 1+ - SWAP C! ;
: ELSE,          2 ?PAIRS HERE 1+    0 BRA,
   SWAP HERE OVER 1+ - SWAP  C!      2  ;
: .NOT. 1 XOR ;          ( REVERSE ASSEMBLY TEST

20 CONSTANT .FL.
21 CONSTANT .TR.
22 CONSTANT .LS.
23 CONSTANT .HI.
24 CONSTANT .CS.
24 CONSTANT .LO.
25 CONSTANT .CC.
25 CONSTANT .HS.
26 CONSTANT .EQ.
27 CONSTANT .NE.
28 CONSTANT .VS.
29 CONSTANT .VC.
2A CONSTANT .--.
2B CONSTANT .++.
2C CONSTANT .LT.
2D CONSTANT .GE.
2E CONSTANT .LE.
2F CONSTANT .GT.

: BIT-BR <BUILDS C, DOES> C@ 18,Y MODE-LSB IF C OR THEN C, C, ; IMMEDIATE
12 BIT-BR .CLR.
13 BIT-BR .SET.

' @  CFA FE43 FE22 - + CONSTANT PUSHD
' @  CFA FE47 FE22 - + CONSTANT NEXTSD
' @  CFA FE47 FE22 - + CONSTANT PUT
' @  CFA FE4A FE22 - + CONSTANT NEXT
' @  CFA FE4C FE22 - + CONSTANT NEXT3
' @  CFA FE50 FE22 - + CONSTANT NEXT1
' @  CFA FE52 FE22 - + CONSTANT NEXT2
' 1+ CFA FC97 FC7C - + CONSTANT POP
' 1+ CFA FC93 FC7C - + CONSTANT POPTWO

0 CONSTANT W
2 CONSTANT IP
4 CONSTANT UP

FORTH DEFINITIONS

HEX

(  200 DP !  DON 9-13-95  leave room for an autostart vector
(  and assembler pointer

: CODE-SUB [COMPILE] CODE-SUB [COMPILE] ASSEMBLER ; IMMEDIATE


: VERSION
  CR
  ." Whiskers KB.2.90" CR
  ." Multitasker 1.2" CR
  ." Last Rev 8-28-96" CR

  ." V27G1BS.TXT" CR
  ." SPIMD2B.TXT" CR
  ." V27G2BS.TXT" CR
;

( Set up variables in RAM space
74 USER VP
8000 VP !

76 USER CLASS

: ARRAY: ( bytes -- )
   <BUILDS VP @ 2+ , VP +!
   DOES> 5 CLASS !
   @
   ;


: REG: ( -- )

   <BUILDS VP @ 2+ , VP 1+!
   DOES> 1 CLASS !
   @
   ;

: VARIABLE

   <BUILDS VP @ 2+ , 2 VP +!
   DOES> 2 CLASS !
   @
;

: 2VARIABLE

   <BUILDS VP @ 2+ , 4 VP +!
   DOES> 4 CLASS !
   @
   ;

( Set up EEROM variables
2A USER EEP
B604 EEP ! ( leaving room for autostart vector

: EEVAR

   <BUILDS EEP @ , 2 EEP +!
   DOES> @  3 CLASS !
;

: EE! 2DUP SWAP >< SWAP EEC! 1+ EEC! ;

: WARN ( Redefine warning to work with FORTH.ASP PROCOM protocal
   CR HERE COUNT TYPE ."  ? MS" 47 EMIT 20 EMIT DUP .
   1000 0 DO LOOP
   HERE COUNT TYPE ."  forth error message " . CR ABORT ;

' WARN CFA 04C !
-1 054 !     ( enable warning
 0 054 !     ( Disable warning

( Register Locations
HEX
B000 CONSTANT PORTA
B002 CONSTANT PIOC
B003 CONSTANT PORTC
B004 CONSTANT PORTB
B005 CONSTANT PORLCL
B007 CONSTANT DDRC
B008 CONSTANT PORTD
B009 CONSTANT DDRD
B00A CONSTANT PORTE
B00B CONSTANT CFORC ( oc1 oc2 oc3 oc4 oc5 - - - force output compare            8
B00C CONSTANT OC1M  ( oc1 oc2 oc3 oc4 oc5 - - - enable port A pins              8
B00D CONSTANT OC1D  ( oc1 oc2 oc3 oc4 oc5 - - - pin level high = 1              8
B00E CONSTANT TCNT  ( main timer read only                                     16
B010 CONSTANT TIC1  ( input compare 1 timer                                    16
B012 CONSTANT TIC2  ( input compare 2 timer                                    16
B014 CONSTANT TIC3  ( input compare 3 timer                                    16
B016 CONSTANT OC1   ( output compare 1 timer                                   16
B018 CONSTANT OC2   ( output compare 2 timer                                   16
B01A CONSTANT OC3   ( output compare 3 timer                                   16
B01C CONSTANT OC4   ( output compare 4 timer                                   16
B01E CONSTANT OC5   ( output compare 5 timer                                   16
B020 CONSTANT TCTL1 ( om2 ol2 om3 ol3 om4 ol4 om5 ol5 timer contro              8
B021 CONSTANT TCTL2 (  - - edg1b edg1a edg2b edg2a edg3b edg3a                  8
B022 CONSTANT TMSK1 ( oc1 oc2 oc3 oc4 oc5 ic1 ic2 ic3 IRQ enable                8
B023 CONSTANT TFLG1 ( oc1f oc2f oc3f oc4f oc5f ic1f ic2f ic3f IRQ f 1=clr       8
B024 CONSTANT TMSK2 ( toI rtiI paovI raiI - - pr1 pr0 overflow ) ( IRQ enable   8
B025 CONSTANT TFLG2 ( tof rtif paovf paif - - - - timer ovrflow     1 tof=1 set 8
B026 CONSTANT PACTL ( ddrA7 paen pamod pedge - - rtr1 rtr0 pulse acc ctrl       8
B027 CONSTANT PACNT
B028 CONSTANT SPCR
B029 CONSTANT SPSR
B02A CONSTANT SPDR
B02B CONSTANT BAUD
B02C CONSTANT SCCR1
B02D CONSTANT SCCR2
B02E CONSTANT SCSR
B02F CONSTANT SCDR
B030 CONSTANT ADCTL
B031 CONSTANT ADR1
B032 CONSTANT ADR2
B033 CONSTANT ADR3
B034 CONSTANT ADR4

( WORD TIMER CODE            Feb 13,1991

HEX
: TM    ( use: TM WORD to time WORD in microseconds
     ' CFA
     80 TFLG2 C! ( clear overflow
     BEGIN TFLG2 C@ 80 AND UNTIL  ( Wait for another overflow
     80 TFLG2 C! ( clear overflow
     TCNT @ >R
     EXECUTE
     TCNT @
     TFLG2 C@ 80 AND IF 1 ELSE 0 THEN ( may be more than 1 overflow
     R> 0
     .C6 D+ ( account for the EXECUTE time
     D-
     D2/  CR D. ."  microseconds"
     ;

( Machine language monitor routines

( : DUMP BASE @ >R HEX DUMP R> BASE ! ; DON

( VP @      22 ERASE
20 VP +!
VARIABLE MSTACK

: (MON) ( RP@ SP@ DEPTH -- )
     CR ."  Data  Dn    Dn-1  Dn-2  ...      n="
     DUP  . 1 MAX DUMP
   ."   Ret   P  B  A  X     Y    Rn    Rn-1  Rn-2  ..."
     1 DUMP ;

CODE-SUB MONITOR
     PSHY, PSHX, PSHA, PSHB, TPA, PSHA,
     MSTACK 01A + # LDY,
     4 LDX,         ( GET UP
     A ,X LDD,      ( GET SP0
     TSX,           ( GET RP
     5 ,X SUBD,     ( SP0-SP
     LSRD,          ( DEPTH
     0 ,Y STD,      ( STORE Stack depth
     5 ,X LDD,
     2 ,Y STD,      ( Data stack pointer
     4 ,Y STX,      ( top of return stack
     ' (MON)    CFA # LDD, ATO4 JSR,
     PULA, TAP, PULB, PULA, PULX, PULY,
     RTS,  END-CODE

: BREAK         ( assemble a break point call to monitor
     [ ASSEMBLER ' MONITOR @ ] LITERAL JSR, ;

: TAG ( N -- \ assemble time )          ( -- N \ Run time
     ASSEMBLER DEY, DEY, # LDD, 0 ,Y STD, ;

( DECOMPILER                Dec 1 1990
( MODIFIED  12/23/93 02:48:24.42  ADDED SMUDGE AND IMPROVED OUTPUT

HEX

: NAME ( CFA -- )       ( usage   CFA NAME NEWNAME
   CREATE -2 ALLOT 2+ HERE 2- ! ;

F415 NAME INNUMBER
F65A NAME 0
FDD6 NAME 0!
EBB7 NAME -FIND
F57C NAME SP!
F573 NAME RP!
F38C NAME ?STATE
EA69 NAME ?ERROR
EA81 NAME ?STACK
F656 NAME 1
FE2C NAME CLIT
FE39 NAME LIT
FCFC NAME NZBRANCH
F50C NAME HEADERLESS
FE07 NAME @@
FE13 NAME @!
( E6E5 NAME DOCOL
( FE80 NAME DOCON
( EE50 NAME DO2CON
( FEB7 NAME DOUSE
FC87 NAME (DO
FCBC NAME (+LOOP
F670 NAME (."
EA51 NAME ?EXEC
F2EA NAME ?NOTEND
F52D NAME WARNING
F521 NAME UABORT
EC48 NAME SMUDGE
EA15 NAME (ABORT"
FC9E NAME (LOOP
FACB NAME (LEAVE
F51E NAME FENCE


: ALIAS         ( usage ALIAS OLDNAME NEWNAME
    ' CFA NAME ;

: .=
     BASE @ >R
     ."   = HEX "
     HEX DUP 6 U.R
     ."  OR DECIMAL "
     DECIMAL DUP 8 .R
     100 /MOD ."   ASCII " EMIT SPACE EMIT
     R> BASE ! ;

VOCABULARY DECOMPILER IMMEDIATE
DECOMPILER DEFINITIONS

HEX

: NFA>LFA
     1 TRAVERSE 1+ ;

: NFA>PFAPTR
     NFA>LFA 2+ ;

: NFA>CFA
     NFA>PFAPTR @ 2- ;

: LFA>CFA
     2+ @ 2- ;

: >NAME ( CFA -- NFA | 0 )
   CONTEXT @@
   BEGIN
     DUP >R NFA>LFA
     2DUP LFA>CFA = IF 2DROP R> EXIT ELSE R> DROP THEN
     @ DUP 0=
   UNTIL SWAP DROP
   ;

: KNOWN        ( ADR NFA ... ADR' )
     3 SPACES
     [ ' CLIT NFA ] LITERAL
     OVER = IF DROP 2+ DUP C@ [ ' LITERAL NFA ] LITERAL ID. .= 1+
     ELSE
    [ ' LIT NFA ] LITERAL
    OVER = IF DROP 2+ DUP @ [ ' LITERAL NFA ] LITERAL ID. .= 2+
    ELSE
         [ ' (."      NFA ] LITERAL
         OVER = IF DROP [ ' ." NFA ] LITERAL ID.
           SPACE 2+ COUNT 2DUP TYPE +
         ELSE
          [ ' (ABORT"   NFA ] LITERAL
          OVER = IF DROP [ ' ABORT" NFA ] LITERAL ID.
            SPACE 2+ COUNT 2DUP TYPE +
          ELSE
         [ ' (+LOOP      NFA ] LITERAL OVER = >R
         [ ' (LOOP     NFA ] LITERAL OVER = >R
         [ ' (LEAVE      NFA ] LITERAL OVER = >R
         [ ' BRANCH NFA ] LITERAL OVER = >R
         [ ' ?BRANCH NFA ] LITERAL OVER = >R
         [ ' NZBRANCH NFA ] LITERAL OVER =
         R> OR R> OR R> OR R> OR R> OR
         IF         ID. SPACE 2+ DUP @ OVER + U. 2+
         ELSE      ID. 2+
         THEN
          THEN
         THEN
    THEN
     THEN
     ;

: SEE-: ( ADD -- )     ( decompile a FORTH word
   BEGIN DUP
      DUP CR U.
      @ DUP
      IF >NAME THEN
      DUP >R
      ?DUP IF KNOWN
      ELSE DUP @ 3 SPACES .= 2+
      THEN
      ?TERMINAL IF KEY ELSE 0 THEN
      R> [ ' EXIT NFA ] LITERAL = OR
      IF KEY D = ELSE 0 THEN
   UNTIL DROP ;


: SEE-DOES>
     CR DUP 2+ DUP U. @ SPACE U. ( Get parameter
     @ SEE-:     ( SEE DOES>
     ;

: SEE-CONSTANT
     CR ." CONSTANT " @ .= ;

: SEE-CODE
     CR ." ASSEMBLER DEFINITION, can not be decompiled " DROP ;

: SEE-USER
     CR ." USER VARIABLE # " C@ DUP .
     4 @ + @
     .= ;

: SEE-CASE
     CR ." CASE: " CR
     SEE-: ;

FORTH DEFINITIONS

: SEE  ( decompile a FORTH word
     DECOMPILER
     BASE @ >R HEX
     ' @
     DUP 2- @
     DUP FE99 = IF DROP SEE-DOES>
    ELSE DUP FE80 = IF DROP SEE-CONSTANT
     ELSE DUP FEAC = IF DROP CR SEE-:
         ELSE DUP FE87 = IF DROP SEE-USER
          ELSE DUP FE5F = IF DROP SEE-CASE
         ELSE
          DROP CR SEE-CODE
         THEN
          THEN
         THEN
     THEN
    THEN
     R> BASE ! ;

: EEVARS ( print all EEVARS in the current search order
   DECOMPILER
   BASE @
   CONTEXT @@
   BEGIN
     DUP NFA>LFA
     DUP 2+ ( PFAPTR )
     @@ [ ' EEVAR 15 + ] LITERAL =
     IF HEX SWAP CR
   DUP C@ 1F AND 10 SWAP - SWAP
   ID. SPACES
   DUP 8 + @ DUP 6 U.R @ .=
     ELSE SWAP DROP THEN
     @ DUP 0=
   UNTIL DROP BASE ! ;

: REGS ( print all REGS in the current search order
   DECOMPILER
   BASE @
   CONTEXT @@
   BEGIN
     DUP NFA>LFA
     DUP 2+ ( PFAPTR )
     @@ [ ' REG: 12 + ] LITERAL =
     IF HEX SWAP CR
   DUP C@ 1F AND 10 SWAP - SWAP
   ID. SPACES
   DUP 8 + @ DUP 6 U.R C@ .=
     ELSE SWAP DROP THEN
     @ DUP 0=
   UNTIL DROP BASE ! ;

: VARS ( print all VARIABLESS in the current search order
   DECOMPILER
   BASE @
   CONTEXT @@
   BEGIN
     DUP NFA>LFA
     DUP 2+ ( PFAPTR )
     @@ [ ' VARIABLE 15 + ] LITERAL =
     IF HEX SWAP CR
   DUP C@ 1F AND 10 SWAP - SWAP
   ID. SPACES
   DUP 8 + @ DUP 6 U.R @ .=
     ELSE SWAP DROP THEN
     @ DUP 0=
   UNTIL DROP BASE ! ;

: 2VARS (  ...      print all 2VARIABLES in the current search order
   DECOMPILER
   BASE @
   CONTEXT @@
   BEGIN
     DUP NFA>LFA
     DUP 2+ ( PFAPTR )
     @@ [ ' 2VARIABLE 15 + ] LITERAL =
     IF HEX SWAP CR
   DUP C@ 1F AND 10 SWAP - SWAP
   ID. SPACES
   DUP 8 + @ DUP 6 U.R 2@ 2DUP 10 D.R DECIMAL 12 D.R
     ELSE SWAP DROP THEN
     @ DUP 0=
   UNTIL DROP BASE ! ;

: ARRAYS (  ...        print all ARRAYS in the current search order
   DECOMPILER
   BASE @
   CONTEXT @@
   BEGIN
     DUP NFA>LFA
     DUP 2+ ( PFAPTR )
     @@ [ ' ARRAY: 12 + ] LITERAL =
     IF HEX SWAP CR
   DUP C@ 1F AND 10 SWAP - SWAP
   ID. SPACES
   DUP 8 + @ 6 U.R
     ELSE SWAP DROP THEN
     @ DUP 0=
   UNTIL DROP BASE ! ;

: CONSTANTS (  ...  print all CONSTANTS in the current search order
   DECOMPILER
   BASE @
   CONTEXT @@
   BEGIN
     DUP NFA>LFA
     DUP 2+ ( PFAPTR )
     @ 2- @
     [ FE80 ] LITERAL =
     IF HEX SWAP CR
   DUP C@ 1F AND 10 SWAP - SWAP
   ID. SPACES
   DUP LFA>CFA EXECUTE 6 U.R
     ELSE SWAP DROP THEN
     @ DUP 0=
   UNTIL DROP BASE ! ;

HEX
: VOC. ( print a vocabulary name
   DUP C - NFA ID. SPACE ;

: VOCS      ( print all defined vocabularies
   34 BEGIN
      @ DUP 46 = NOT
   WHILE
      VOC.
   REPEAT DROP
;

( System Words

( FORGET SYSTEM

: SYSTEM ;

: COPYRIGHT
 CR VERSION
 CR ." (c) 1992-1996 ANGELUS RESEARCH CORP."
 CR ." This software cannot be sold or incorporated into"
 CR ." another product without express permission from"
 CR ." Angelus Research Corp., 6344 Sugar Pine Circle, #98"
 CR ." Angelus Oaks, California 92305 (909) 794-8325"
 CR ." Purchasing this product, gains the purchaser the"
 CR ." right to modify and use the source code provided for"
 CR ." their personal use only, with exception to the source"
 CR ." files provided on disk."
 CR
 CR ." All rights reserved"
 CR
 CR ." to bypass autostarting, press space bar..."
 CR ." to restore system to factory configuration, press Q."
 CR
 CR ." May the Forth be with you..."
;

HEX

: BINARY
  2 BASE ! ;

: &H HEX ;     IMMEDIATE
: &D DECIMAL ; IMMEDIATE
: &B BINARY ;  IMMEDIATE

DECIMAL

: ON ( a -- )
  -1 SWAP C! ;

: OFF ( a -- )
  0 SWAP C! ;

REG: rBUSY     ( DON flag for behavior level
REG: rINSTINCTS

&B
: INIT ( -- )
  10000000 PACTL C!
  00000000 PORTA C!
  00100000 DDRD C! ;
&D

REG: rOLD-MODE

: SAVE-MODE ( -- )                     ( DON 8-21-96

  TMSK1 C@
  rOLD-MODE C! ;

: RESTORE-MODE ( -- )                  ( DON 8-21-96

  rOLD-MODE C@
  TMSK1 C! ;

: DISABLE ( -- )

  SAVE-MODE                ( DON 8-21-96
  0 PORTA C!
  0 TMSK1 C!
  ;

: ENABLE ( -- )

&B 00010000 &D TMSK1 C!
  ;

&B
01100000 CONSTANT LF
01000000 CONSTANT LR
00011000 CONSTANT RF
00010000 CONSTANT RR
01111000 CONSTANT FWD
01010000 CONSTANT REV
00000000 CONSTANT ST
01110000 CONSTANT PVR
01011000 CONSTANT PVL

&H

REG: rMASK

&D

: M ( n -- )
  DEPTH
  IF
     DUP PORTA C!
     rMASK C!
  ELSE
     CR ." Nothing on stack "
  THEN
  CR ." Use one of these: LF LR RF RR FWD REV ST PVL PVR"
;

: S ( -- )
  ST M ;


DECIMAL

( Task Words

ALIAS +!    INCREASE     ( n ADDR -- )      ( DON 6-24-93
ALIAS 1+!   INCREMENT      ( ADDR -- )      ( DON 6-24-93
ALIAS 1-!   DECREMENT      ( ADDR -- )
ALIAS SP!   CLEAR-STACK    ( -- )
ALIAS ."    DISPLAY"           ( DON 7-14-93
ALIAS +      DATA           ( DON 8-1-93
ALIAS .      DISPLAY         ( DON 8-1-93
ALIAS . .
ALIAS + +
ALIAS +!  +!
ALIAS 1+! 1+!
ALIAS 1-! 1-!


:CASE     STORE
     C!
     !
     EE!
     2!
     ;
: NOW       ( ADDR -- )
     CLASS @ CLASS 0!
     1- DUP 4 U< NOT ABORT" NOW error"
     STORE ;

ALIAS NOW SET         ( DON 4-19-94

:CASE FETCH
     C@
     @
     @
     2@
     ;

: VALUE ( ADDR -- N )
     CLASS @ CLASS 0!
     1- DUP 4 U< NOT ABORT" VALUE error"
     FETCH ;

ALIAS VALUE GET           ( DON 4-19-94

: DECREASE ( n addr -- )
  >R
  DUP R@ @
  >
    IF
      R> 2DROP
      EXIT
    ELSE
      NEGATE R> +!
    THEN
;

: INDEX ( addr offset -- n )

  DEPTH
  1 >
    IF
      1- +
    ELSE
      CLEAR-STACK
      CR ." need array name and index!"
    THEN
;

: SYSTEM-INIT
  INIT
  &H FF6C 26 ! &D   ( KHZ FOR writing to EE rom
  0 rMASK C! ;

.( load TIMER.FTH next...

( Timer Routines   DRG 3-7-92

HEX
( SENSOR 203-374-1411 EXT 127
( FORTH DEFINITIONS
( ASSEMBLER

CODE-SUB CLI
  0E C, ( CLI )
  39 C, ( RTS )
END-CODE

CODE-SUB SEI
  0F C, ( SEI )
  39 C, ( RTS )
END-CODE

( FORGET ADC1
: ADC1 ;

&B
    01111111 CONSTANT BPC-OFF
    10000000 CONSTANT BPC-ON
&H

: BEYES-ON ( -- )
  PORTA C@  BPC-ON OR  PORTA C! ;

: BEYES-OFF ( -- )
  PORTA C@  BPC-OFF AND        PORTA C! ;

: DELAY ( time -- )
  0 DO LOOP ;


DECIMAL

( REG: addresses are consecutive and can be treated as a table

( storage table for the first bank of the adc registers
REG: rADR1-OFF
REG: rADR2-OFF
REG: rADR3-OFF
REG: rADR4-OFF
REG: rADR1-ON
REG: rADR2-ON
REG: rADR3-ON
REG: rADR4-ON
( storage table for the second bank of the adc registers
REG: rADR1-B
VP 1-!          ( also call this storage location battery KEN
REG: rBATTERY
REG: rADR2-B
REG: rADR3-B
REG: rADR4-B

: AMBIENT-LIGHT ( -- light )   ( DON 4-28-96

  rADR1-OFF C@
  rADR2-OFF C@ +
  rADR3-OFF C@ +
  rADR4-OFF C@ +
  4 / ;

1024  CONSTANT 1K

1K ARRAY: 1K-BUFFER

VARIABLE vSAMPLES
: SAMPLES ( samples -- )

     DUP 1K >
   IF
     ." too many...1024 max!"
     DROP
   ELSE
     vSAMPLES !
   THEN ;

VARIABLE vRATE
: RATE ( rate -- )

  vRATE ! ;


: INIT-ADC1 ( -- )
  1K-BUFFER 1K ERASE
  rADR1-OFF 12 ERASE

  256 vSAMPLES          !
  100 RATE
;

DECIMAL

1 CONSTANT cRIGHT     ( RCL Direction controls
2 CONSTANT cLEFT
3 CONSTANT cFWD
4 CONSTANT cREV

REG: rCHOICE         ( RCL direction choice

REG: rLSPEED
REG: rRSPEED

( left motor pulse width modulation registers
REG: rLEFT-CTR
REG: rLTON
REG: rLTOFF

( right motor pulse width modulation registers
REG: rRIGHT-CTR
REG: rRTON
REG: rRTOFF

VARIABLE vCOUNTER     ( Counts instinct interrupts

32 CONSTANT cMAX-TASKS ( Maximum number of tasks in Behaviors

VP @ 2+ CONSTANT cVAR-START ( start of the system variables


( ************* start of system variables *****************

cMAX-TASKS 2+ ARRAY: TASKS

REG: rMAX-SPEED

REG: rCORRECTION ( Modifies right speed to match left, can be + or -

REG: rLF-TRIGGER      ( discriminator values
REG: rLSF-TRIGGER
REG: rRF-TRIGGER
REG: rRSF-TRIGGER
REG: rL-TRIGGER
REG: rR-TRIGGER
REG: rF-TRIGGER
REG: rLM-TRIGGER
REG: rRM-TRIGGER

REG: rFACTOR         ( trigger calibration factor

REG: rLF-MASK        ( collision response masks
REG: rLSF-MASK
REG: rRF-MASK
REG: rRSF-MASK
REG: rLW-MASK
REG: rRW-MASK
REG: rL-MASK
REG: rR-MASK
REG: rF-MASK
REG: rLM-MASK
REG: rRM-MASK

REG: rCOLLISION       ( disable collision detection flag

VARIABLE vSENSOR-CTR    ( sensor timing values--could be REG:
VARIABLE vEYES-ON-PER
VARIABLE vEYES-OFF-PER
VARIABLE vSCAN-OFF-DELAY
VARIABLE vSCAN-ON-DELAY

VARIABLE vPWM-CYC

REG: rSTALL-DELAY     ( disable stall detection VALUE
REG: rLIGHTS         ( disable light collisions
REG: rSTALLS         ( disable stall collisions
REG: rWHISKERS      ( disable whiskers collisions
REG: rSENSE        ( disable ADC readout -required for LIGHTS,STALLS
REG: rSUM-FACTOR     ( DON used to adjust sum trigger for calibration

VARIABLE vMAX-COMPASS

REG: rMAX-INSTINCTS
REG: rNUM-TASKS

2VARIABLE vPACE        ( sets pace of song in units of 1/4 notes/min
( example   60 vPACE ! will slow a song to 60 1/4 notes/min
( 120 vPACE ! is 'normal'

VARIABLE vINT-CFA   ( cfa of hi level hook in interrupt routine
VARIABLE vINT-UP       ( USER page pointer for hi level interrupts
VARIABLE vBOOT-WORD     ( cfa of word to run on bootup

VARIABLE vFRUSTRATION
VARIABLE vFRUST-TRIGGER
VARIABLE vWAIL      ( DON 6-22-93
REG: rBAT-TRIGGER

32 ARRAY: REG-LIST     ( list used by CAPTURE

( ************* end of system variables *****************

VP @ 2+ cVAR-START -
CONSTANT cVAR-LENGTH      ( length of the system variable table

DECIMAL

VARIABLE vCOMPASS
VARIABLE vDISTANCE       ( DON 10-2-93
REG: rNO-STALLS            ( disable stall detection flag

: FAST-DIGITIZE ( -- )

     DISABLE     ( interupts
     &B 00110100 &D ADCTL C!

     vSAMPLES @ 0

       DO

         ADR4 C@
         1K-BUFFER I + C!
     LOOP

  &B 00010000 &D ADCTL C!
     RESTORE-MODE               ( DON 8-21-96
;

: DIGITIZE ( -- )

     DISABLE     ( interupts
     &B 00110100 &D ADCTL C!

     vSAMPLES @

       0 DO

         vRATE @
            0 DO LOOP

         ADR4 C@
         1K-BUFFER I + C!
     LOOP

  &B 00010000 &D ADCTL C!
     RESTORE-MODE               ( DON 8-21-96
;

REG: rPEAK-SOUND
    0 rPEAK-SOUND

VARIABLE vPEAK-ADDR
    0 vPEAK-ADDR

: PEAK-SOUND ( -- addr peak )

     0 rPEAK-SOUND C!
     0 vPEAK-ADDR   !

     1K-BUFFER 0         ( buffer peak -- seed stack

     vSAMPLES @          ( HI
     0                   ( LO

     DO

        1K-BUFFER I + C@  DUP        ( data
        rPEAK-SOUND C@  >         (  flag

           IF
              rPEAK-SOUND C!
              1K-BUFFER I + vPEAK-ADDR !
           ELSE
              DROP
           THEN

     LOOP

     2DROP

     ;

REG: rSOUND-AVERAGE
15 rSOUND-AVERAGE C!

: DIGITIZE-PEAK ( -- )

     0 rPEAK-SOUND C!

     DISABLE     ( interupts
     &B 00110100 &D ADCTL C!

     vSAMPLES @          ( HI
     0                   ( LO

     DO
        0
        rSOUND-AVERAGE C@

           0 DO
                  ADR4 C@ +        ( data
             LOOP

           rSOUND-AVERAGE C@ /

       DUP
       rPEAK-SOUND C@
         >         (  flag

           IF
              rPEAK-SOUND C!
           ELSE
              DROP
           THEN

     LOOP

  &B 00010000 &D ADCTL C!
     RESTORE-MODE               ( DON 8-21-96
;

: SOUND-LEVEL ( -- level )            ( DON 8-21-96

   DISABLE
   2000 DELAY
   10 RATE
   1K SAMPLES
   DIGITIZE
   PEAK-SOUND
   rPEAK-SOUND GET
   CR ." LEVEL=" .
   RESTORE-MODE ;

100 ARRAY: LEVELS

VARIABLE vSTEP
30 vSTEP !

: STEP ( step -- )      ( degrees to step
     vSTEP ! ;

VARIABLE vDELAY
20000 vDELAY !

: TRIGGER-FACTOR ( n -- )

  DUP 255 <
    IF
      rFACTOR C!
    ELSE
      CR ." too high...must be less than 255!"
    THEN
;

: SUM-FACTOR ( n -- )

  DUP 255 <
    IF
      rSUM-FACTOR C!
    ELSE
      CR ." too high...must be less than 255!"
    THEN
  ;

VARIABLE vCHECK-DELAY       ( DON 4-19-94

( These are all in the system table

     vSENSOR-CTR     0!
  3  vEYES-ON-PER     !
  3 vEYES-OFF-PER     !
  1 vSCAN-OFF-DELAY   !
  1 vSCAN-ON-DELAY    !
  16667 vPWM-CYC      !

 DECIMAL
 100 rSUM-FACTOR       C!       ( DON 8-21-96
 11  rFACTOR          C!       ( DON 2-28-96
 100 rMAX-SPEED       C!
     rCORRECTION     OFF
 1559 vMAX-COMPASS   !      ( DON 5-1-96
 0 vCOMPASS          !      ( DON 8-27-96  10000 vCOMPASS      !
 0 vDISTANCE         !      ( DON 10-2-93
     vINT-CFA       0!
  65 rLSPEED        C!      ( DON 5-1-96
  65 rRSPEED        C!      ( DON 5-1-96
  50 rNO-STALLS     C!
  255 rSTALL-DELAY  C!      ( DON stall disable time
  35  rLM-TRIGGER   C!      ( DON 4-28-96 was 25
  35  rRM-TRIGGER   C!      ( DON 4-28-96 was 25
  160 vWAIL          !      ( DON 6-22-93
  &H
  10 rMAX-INSTINCTS C!
  -1 rCOLLISION     C!      ( Enable collision detection
  -1 rSENSE         C!      ( Enable flashing lights and ADC reads
  -1 rWHISKERS      C!      ( Enable whisker collisions
  -1 rLIGHTS        C!      ( Enable light collisions
  -1 rSTALLS        C!      ( Enable stall collisions
  ( rLF-TRIGGER 7 FF FILL     ( DON set trigger levels

  &D
  120 120 vPACE      2!       ( set full rational fraction
  30000 vCHECK-DELAY  !       ( DON 4-19-94

: INIT-OPTIONS
  &D
   65 rLSPEED        C!       ( 5-1-96
   65 rRSPEED        C!
   0 vCOMPASS         !       ( DON 8-27-96
   0 vDISTANCE        !       ( DON 10-2-93
   50 rNO-STALLS     C!
  &H ;

INIT-OPTIONS

DECIMAL
11 ARRAY: aSAV-INSTINCTS    ( DON 8-12-93

: SAVE-INSTINCTS    ( MODIFIED BY KEN 12-10-93
  rLF-MASK  aSAV-INSTINCTS 11 CMOVE
;

: RESTORE-INSTINCTS
 aSAV-INSTINCTS rLF-MASK  11 CMOVE
;


REG: rLF-VALUE      ( on - off values
REG: rLSF-VALUE
REG: rRF-VALUE
REG: rRSF-VALUE
REG: rL-VALUE
REG: rR-VALUE
REG: rF-VALUE
REG: rLM-VALUE
REG: rRM-VALUE

&B
1 CONSTANT LF-OBSTACLE          ( specific collision flags
10 CONSTANT LSF-OBSTACLE
100 CONSTANT RF-OBSTACLE
1000 CONSTANT RSF-OBSTACLE
10000 CONSTANT L-OBSTACLE
100000 CONSTANT R-OBSTACLE
&B 1000000 CONSTANT F-OBSTACLE
( Start new byte for whiskers and stalls
100000000 CONSTANT LW-OBSTACLE
1000000000 CONSTANT RW-OBSTACLE
10000000000 CONSTANT LM-OBSTACLE
100000000000 CONSTANT RM-OBSTACLE

VARIABLE vCOLLIDED       ( any collision flag - or of obstacles
VARIABLE vCOL-FLAG       ( any collision signal

VARIABLE vSENSOR-CYC         ( sensor cycle toggle

&B 00010000 &H CONSTANT TFLG1-MASK          ( OC4 int flag
&B 00010000 &H CONSTANT SCAN-A         ( 1st ADC bank
&B 00010100 &H CONSTANT SCAN-B         ( 2nd ADC bank
&B 10000000 &H CONSTANT SENSOR-MASK

( DON
( &B 00000001 &H CONSTANT RW-MASK         ( whisker masks
( &B 00000010 &H CONSTANT LW-MASK
  &B 00000010 &H CONSTANT RW-MASK         ( whisker masks
  &B 00000001 &H CONSTANT LW-MASK

REG: rCOL-MASK           ( motor mask from collision

: RIGHT ( -- )
  cRIGHT rCHOICE C! ;

: LEFT ( -- )
  cLEFT rCHOICE C! ;

  &B
     10111111 CONSTANT L-OFF
     01000000 CONSTANT L-ON
  &D


  &B 11101111 CONSTANT R-OFF
     00010000 CONSTANT R-ON
  &D


HEX

: SENSOR ( mask -- flag )
  vCOLLIDED @ AND
  0= NOT        ( DON 4-18-94 make it work as before
;

: OBSTACLE ( MASK -- T/F )
  SENSOR 0= NOT ;

: CLEAR-SENSORS ( -- )         ( erase memory of hit
  vCOLLIDED 0!
  vCOL-FLAG 0!
  ;

DECIMAL

: PRINT ( print the name of the following word inside : definition
     R@ 2+ @ 2- NFA ID. SPACE
     ;

: 10.R 9 .R SPACE ;
: 7.R 6 .R SPACE ;
: 5.R 4 .R SPACE ;
: 10_ 10 SPACES ;
: 17.R 10_ 7.R ;

: SCANS
     CR    PRINT vPWM-CYC @ 7.R
     CR    PRINT vSENSOR-CTR @ 7.R
    PRINT vSENSOR-CYC @ 7.R
     CR    PRINT vEYES-ON-PER @ 7.R
    PRINT vEYES-OFF-PER @ 7.R
     CR    PRINT vSCAN-OFF-DELAY @ 7.R
    PRINT vSCAN-ON-DELAY @ 7.R
     CR ;

: MOTORS
  CR PRINT rMAX-SPEED C@ 7.R
     PRINT rCORRECTION C@ 7.R
     PRINT vPWM-CYC @ 7.R
  CR PRINT rLSPEED C@ 5.R
     PRINT rRSPEED C@ 5.R
  CR PRINT rLTON  C@ 5.R
     PRINT rLTOFF C@ 5.R
     PRINT rLEFT-CTR C@ 5.R
  CR PRINT rRTON  C@ 5.R
     PRINT rRTOFF C@ 5.R
     PRINT rRIGHT-CTR C@ 5.R
  BASE @ BINARY
  CR PRINT rMASK C@ .
     PRINT PORTB C@ 10.R
     PRINT PORTA C@ 10.R
  BASE !
     ;

( : SET-SCANS
(     CR  PRINT vSENSOR-CTR     QUERY INTERPRET SWAP !
(     CR  PRINT vSENSOR-CYC     QUERY INTERPRET SWAP !
(     CR  PRINT vEYES-ON-PER      QUERY INTERPRET SWAP !
(     CR  PRINT vEYES-OFF-PER       QUERY INTERPRET SWAP !
(     CR  PRINT vSCAN-ON-DELAY   QUERY INTERPRET SWAP !
(     CR  PRINT vSCAN-OFF-DELAY QUERY INTERPRET SWAP !
( ;

: .MASK ( mask -- )                 ( DON 8-30-96

  DUP FWD =
   IF ." FWD" THEN

  DUP REV =
   IF ." REV" THEN

  DUP RF =
   IF ." RF" THEN

  DUP RR =
   IF ." RR" THEN

  DUP LF =
   IF ." LF" THEN

  DUP LR =
   IF ." LR" THEN

  DUP ST =
   IF ." ST" THEN

  DUP PVL =
   IF ." PVL" THEN

  PVR =
   IF ." PVR" THEN

;

DECIMAL
: SENSORS ( -- )

  CR 21 SPACES
  ." ON  OFF  VALUE  OBSTACLE   TRIGGER   MASK"
  CR
  ." Left Front Sensor  "
    rADR1-ON C@ 5.R
    rADR1-OFF C@ 5.R
    rLF-VALUE  C@ 7.R
    LF-OBSTACLE OBSTACLE 10.R
    rLF-TRIGGER C@ 10.R
    rLF-MASK C@ .MASK
  CR
  ." Left Side Sensor   "
    rADR2-ON C@ 5.R
    rADR2-OFF C@ 5.R
    rLSF-VALUE      C@ 7.R
    LSF-OBSTACLE OBSTACLE 10.R
    rLSF-TRIGGER C@ 10.R
    rLSF-MASK C@ .MASK
  CR
  ." Right Front Sensor "
    rADR3-ON C@ 5.R
    rADR3-OFF C@ 5.R
    rRF-VALUE  C@ 7.R
    RF-OBSTACLE OBSTACLE 10.R
    rRF-TRIGGER C@ 10.R
    rRF-MASK C@ .MASK
  CR
  ." Right Side Sensor  "
    rADR4-ON C@ 5.R
    rADR4-OFF C@ 5.R
    rRSF-VALUE      C@ 7.R
    RSF-OBSTACLE OBSTACLE 10.R
    rRSF-TRIGGER C@ 10.R
    rRSF-MASK C@ .MASK
  CR
  ." Left summed sensor "
    rL-VALUE    C@ 17.R
    L-OBSTACLE OBSTACLE 10.R
    rL-TRIGGER C@ 10.R
    rL-MASK C@ .MASK
  CR
  ." Right summed sensor"
    rR-VALUE    C@ 17.R
    R-OBSTACLE OBSTACLE 10.R
    rR-TRIGGER C@ 10.R
    rR-MASK C@ .MASK
  CR
  ." Front summed sensor"
    rF-VALUE    C@ 17.R
    F-OBSTACLE OBSTACLE 10.R
    rF-TRIGGER C@ 10.R
    rF-MASK C@ .MASK
  CR
  ." Left whisker       "
    LW-OBSTACLE OBSTACLE 10_ 17.R
    rLW-MASK C@ 10_ .MASK
  CR
  ." Right whisker      "
    RW-OBSTACLE OBSTACLE 10_ 17.R
    rRW-MASK C@ 10_ .MASK
  CR
  ." Left motor current "
    rLM-VALUE     C@ 17.R
    LM-OBSTACLE OBSTACLE 10.R
    rLM-TRIGGER C@ 10.R
    rLM-MASK C@ .MASK
  CR
  ." Right motor current"
    rRM-VALUE     C@ 17.R
    RM-OBSTACLE OBSTACLE 10.R
    rRM-TRIGGER C@ 10.R
    rRM-MASK C@ .MASK
  CR
    PRINT rCOLLISION C@ 7.R
    PRINT vCOLLIDED @ 7.R
    PRINT vCOL-FLAG @ 7.R
    PRINT rFACTOR C@ 5.R
  CR
    PRINT rWHISKERS C@ 5.R
    PRINT rSENSE C@ 5.R
    PRINT rLIGHTS C@ 5.R
    PRINT rSTALLS C@ 5.R
  CR
    PRINT vDISTANCE @ 7.R
    PRINT vCOMPASS @ 7.R
    PRINT vMAX-COMPASS @ 7.R
  CR ." BATTERY =" rADR1-B    C@ 5.R
     ."    SOUND =" rADR4-B    C@ 5.R
  CR
     PRINT rNO-STALLS C@ 5.R
     PRINT rSTALL-DELAY C@ 5.R
     PRINT rMASK C@ 5.R
     PRINT rCOL-MASK C@ 5.R
  CR
     PRINT rBUSY C@ 5.R
     PRINT rMAX-INSTINCTS C@ 5.R
     PRINT vINT-CFA @ DUP IF 2- NFA SPACE ID. ELSE . THEN
  CR
  ;

HEX
CODE-SUB SENSE ( CHECK ADC SENSES

      PSHY, ( only needed for testing to save data stack pointer
       ( Y register used to index into storage registers

      ADR1 # LDX, ( start address of ADC bank
        ( used as index to read all 4 bytes

      0 # LDD,      ( zero flag
      vCOL-FLAG STD, rCOL-MASK STAA,
      vSENSOR-CTR LDD, 1 # ADDD, vSENSOR-CTR STD,
      vSENSOR-CYC LDD,

( Flash lights and read return signals

      .EQ. IF,
       vSENSOR-CTR     LDD, vEYES-OFF-PER CPD,
       .GE. IF,
       PORTA LDAA, BPC-ON # ORAA, PORTA STAA,
       0 # LDD, vSENSOR-CTR  STD,
       vSENSOR-CYC  1+ INC, ( set to 1
       SCAN-B # LDAB,
       ELSE,
       vSENSOR-CTR LDD, vSCAN-OFF-DELAY CPD,
       TPA,     ( save status register
       .GT. IF, ( read sensors after delay
          rADR1-OFF # LDY,
          SCAN-A # LDAB,
       ELSE,      ( read scan-b during delay
          rADR1-B      # LDY,
          SCAN-B # LDAB,
          TAP, ( recover status register
          .EQ. IF,          ( last time?
            SCAN-A # LDAB, ( switch ADC bank
          THEN,
       THEN,
       ( Move 4 ADC bytes two at a time
       PSHB,      ( save scan value
       0 ,X LDD, 0 ,Y STD,
       2 ,X LDD, 2 ,Y STD,
       PULB,
       THEN,
       ADCTL STAB,       ( start next scan
      ELSE,
       vSENSOR-CTR LDD, vEYES-ON-PER CPD,
       .GE. IF,
       PORTA LDAA, BPC-OFF # ANDA, PORTA STAA,
       0 # LDD, vSENSOR-CTR  STD,
       vSENSOR-CYC STD,      ( Set to 0
       SCAN-B # LDAB,       ( starting delay
       ELSE,
       vSENSOR-CTR LDD, vSCAN-ON-DELAY CPD,
       TPA,     ( save status register
       .GT. IF,
          rADR1-ON # LDY,
          SCAN-A # LDAB,
       ELSE,
          rADR1-B      # LDY,
          SCAN-B # LDAB,
          TAP,   ( restore status
          .EQ. IF,   ( last time trade ADC bank
            SCAN-A # LDAB,
          THEN,
       THEN,
       ( Move 4 ADC bytes two at a time
       PSHB, ( Save scan value
       0 ,X LDD, 0 ,Y STD, ( transfer first 2 ADC's
       2 ,X LDD, 2 ,Y STD, ( transfer last 2 ADC's
       PULB, ( Restore scan value
       THEN,
       ADCTL STAB,       ( start next scan
      THEN,
      PULY, ( only needed for testing
      RTS,
END-CODE

CODE-SUB LIGHTS ( any hits on the light senses?
     ( right sensors have higher priority then left
     ( front sensors have higher priority then side

     vCOL-FLAG 1+ LDAB, ( Load current collision status
     rCOL-MASK LDX,     ( Use only high half

( left side sensor hit?
     rADR2-OFF LDAA, rADR2-ON SUBA,
       .CC. IF,
               rLSF-VALUE STAA, rLSF-TRIGGER CMPA,
               .CC. IF,
                        LSF-OBSTACLE # ORAB,       ( update col flag
                        rLSF-MASK LDX,
                    THEN,
            THEN,

( right side sensor hit?
     rADR4-OFF    LDAA,   rADR4-ON  SUBA,
     .CC. IF,
     rRSF-VALUE STAA, rRSF-TRIGGER CMPA,
     .CC. IF,
        RSF-OBSTACLE # ORAB,       ( update col flag
        rRSF-MASK LDX,
     THEN,
     THEN,

( left front sensor hit?
     rADR1-OFF LDAA, rADR1-ON SUBA,
     .CC. IF,
     rLF-VALUE STAA, rLF-TRIGGER CMPA,
     .CC. IF,
        LF-OBSTACLE # ORAB,     ( update col flag
        rLF-MASK LDX,
     THEN,
     THEN,

( right front sensor hit?
     rADR3-OFF LDAA, rADR3-ON SUBA,
     .CC. IF,
     rRF-VALUE STAA, rRF-TRIGGER CMPA,
     .CC. IF,
        RF-OBSTACLE # ORAB,     ( update col flag
        rRF-MASK LDX,
     THEN,
     THEN,

( left summed sensors hit?
     ( These values are always +
     rLF-VALUE LDAA, rLSF-VALUE ADDA,
     .CS. IF, FF LDAA, THEN, ( handle possible overflow
     rL-VALUE STAA, rL-TRIGGER CMPA,
     .CC. IF,
     L-OBSTACLE # ORAB,
     rL-MASK LDX,
     THEN,

( right summed sensors hit?
     ( These values are always +
     rRF-VALUE LDAA, rRSF-VALUE ADDA,
     .CS. IF, FF LDAA, THEN, ( handle possible overflow
     rR-VALUE STAA, rR-TRIGGER CMPA,
     .CC. IF,
     R-OBSTACLE # ORAB,
     rR-MASK LDX,
     THEN,

( front summed sensors hit?
     ( These values are always +
     rLF-VALUE LDAA, rRF-VALUE ADDA,
     .CS. IF, FF LDAA, THEN, ( handle possible overflow
     rF-VALUE STAA, rF-TRIGGER CMPA,
     .CC. IF,
     F-OBSTACLE # ORAB,
     rF-MASK LDX,
     THEN,

     TBA,          ( save collision bits
     vCOLLIDED 1+ ORAB,
     vCOLLIDED 1+ STAB,    ( vCOLLIDED has bits set for all calls

     rLIGHTS TST,
     .NE. IF,
     vCOL-FLAG 1+ STAA, ( COL-FLAG has bits set for this call
     XGDX,
     rCOL-MASK STAA,   ( only the high half of the X reg is valid
     THEN,
     RTS,

END-CODE

CODE-SUB NO-STALLS
     rSTALL-DELAY LDAA,
     rNO-STALLS STAA,
     RTS,
END-CODE

CODE-SUB STALLS ( are either motors stalled?

     vCOL-FLAG LDAB, ( Load current collision status
     rCOL-MASK LDX, ( only high byte is valid

     rNO-STALLS TST,    ( allow delay after changing motors
     .EQ. IF,

     rADR3-B       LDAA,
     rLM-VALUE STAA,
     rLM-TRIGGER CMPA,
     .CC. IF,
     rSTALL-DELAY LDAA, rNO-STALLS STAA,
     rMASK LDAA, PVL PVR XOR # EORA, ( reverse motor direction
     rLM-MASK STAA,
     ( rMASK STAA,       DON 4-19-94 override the default direction
     XGDX,
     LM-OBSTACLE >< # ORAB,
     THEN,

     rADR2-B       LDAA,
     rRM-VALUE STAA,
     rRM-TRIGGER CMPA,
     .CC. IF,
     rSTALL-DELAY LDAA, rNO-STALLS STAA,
     rMASK LDAA, PVL PVR XOR # EORA, ( reverse motor diretion
     rRM-MASK STAA,
     ( rMASK STAA, DON 4-19-94
     XGDX,
     RM-OBSTACLE >< # ORAB,
     THEN,

     TBA,      ( save collision bits
     vCOLLIDED ORAB,
     vCOLLIDED STAB,     ( vCOLLIDED has bits set for all calls

     rSTALLS TST,      ( act on motor stalls?
     .NE. IF,
     vCOL-FLAG STAA, (  vCOL-FLAG has bits set for this call
     XGDX,
     rCOL-MASK STAA, ( store high byte only
     THEN,

     ELSE,
     ( Wait for all collisions to end
     vCOL-FLAG 1+ ORAB,
     .EQ. IF,
     rNO-STALLS DEC,
     THEN,
     THEN,

     RTS,
END-CODE

CODE-SUB WHISKERS      ( check for whiskers hits

     vCOL-FLAG LDAB, ( Load current collision status
     rCOL-MASK LDX, ( only high byte is valid

     PORTA LDAA,
     LW-MASK     # ANDA,    ( left whisker?
     .EQ. IF,
     LW-OBSTACLE >< # ORAB,
     rLW-MASK LDX,
     THEN,

     PORTA LDAA,
     RW-MASK     # ANDA,    ( right whisker?
     .EQ. IF,
     RW-OBSTACLE >< # ORAB,
     rRW-MASK LDX,
     THEN,

     TBA,       ( save bits
     vCOLLIDED ORAB,
     vCOLLIDED STAB,     ( vCOLLIDED has bits set for all sensors hit

     rWHISKERS TST,     ( act on wisker hits ?
     .NE. IF,
     vCOL-FLAG STAA, (  COL-FLAG has bits set for this call
     XGDX,
     rCOL-MASK STAA, ( store high byte only
     THEN,
     RTS,
END-CODE

CODE-SUB PW-MOD
( update pulse width modulation
( new algorithm to distribute pulses uniformly      02/10/93 21:42:25
     PORTA LDAA,     ( obtain sensor status
     SENSOR-MASK # ANDA,

     vCOL-FLAG LDX,         ( ON section of PWM.
     .NE. IF,
             rCOL-MASK ORAA,
             rSTALL-DELAY LDAB, ( disable stall detection
             rNO-STALLS STAB,
          ELSE,
             rMASK ORAA,
          THEN,

     rLEFT-CTR LDAB,         ( left motor control
     .--. IF,          ( off section
            rLTON ADDB,
            L-OFF # ANDA,
          ELSE,       ( on section
            rLTOFF SUBB,
          THEN,

     rLEFT-CTR STAB,

     rRIGHT-CTR LDAB,     ( right motor control
     .--. IF,          ( off section
            rRTON ADDB,
            R-OFF # ANDA,
          ELSE,       ( on section
            rRTOFF SUBB,
          THEN,
            rRIGHT-CTR STAB,

     PORTA STAA,     ( Store the motor mask and sensors
     RTS,
END-CODE

CODE-SUB UPD-COMPASS

     PORTA LDAA,
     vCOMPASS LDX,

     RF # ANDA,
     RF # CMPA,
     .EQ. IF, ( RIGHT FORWARD
     DEX,
     DEX,
     THEN,

     RR # CMPA,
     .EQ. IF, ( RIGHT REVERSE
     INX,
     INX,
     THEN,

     PORTA LDAA,
     LF # ANDA, ( left forward
     LF # CMPA,
     .EQ. IF,
     INX,
     INX,
     THEN,

     LR # CMPA,
     .EQ. IF, ( LEFT REVERSE
     DEX,
     DEX,               ( DON 2-26-97
     THEN,

     PORTA LDAA,        ( DON 10-1-93 ....
     PVR # ANDA, ( pivot right
     PVR # CMPA,
     .EQ. IF,
     INX,
     INX,               ( DON 2-26-97
     THEN,

     PORTA LDAA,
     PVL # ANDA, ( pivot left
     PVL # CMPA,
     .EQ. IF,
     DEX,
     DEX,           ( DON 2-26-97
     THEN,          ( ... END DON

     vCOMPASS STX,
     RTS,
END-CODE

CODE-SUB DISTANCE         ( DON 10-2-93

     PORTA LDAA,
     vDISTANCE LDX,

     RF # ANDA,
     RF # CMPA,
     .EQ. IF, ( RIGHT FORWARD
     INX,
     THEN,

     RR # CMPA,
     .EQ. IF, ( RIGHT REVERSE
     DEX,
     THEN,

     PORTA LDAA,
     LF # ANDA, ( LEFT FORWARD
     LF # CMPA,
     .EQ. IF,
     INX,
     THEN,

     LR # CMPA,
     .EQ. IF, ( LEFT REVERSE
     DEX,
     THEN,
                         ( DON 2-26-97
     FWD # CMPA,
     .EQ. IF, ( FORWARD
     INX,
     INX,
     THEN,

     REV # CMPA,
     .EQ. IF, ( BACKUP
     DEX,
     DEX,
     THEN,
                         ( DON END
     vDISTANCE STX,
     RTS,
END-CODE

CODE-SUB INSTINCT

      rSENSE TST,
     .NE. IF,
         ' SENSE @ JSR,  ( read sensor ADC values
     THEN,

     ' LIGHTS @   JSR,         ( set collision flags and mask
     ' WHISKERS @ JSR,
     ' STALLS @   JSR,

     rCOLLISION TST,         ( collision action enabled?
     .EQ. IF,
             0 # LDX,         ( zero collision flag
             vCOL-FLAG STX,
          THEN,


     ' PW-MOD       @ JSR,         ( update motor status
     ' UPD-COMPASS  @ JSR,         ( update compass
     ' DISTANCE     @ JSR,         ( DON 10-2-93 update distance

( update clock
     vCOUNTER LDD,        ( used as a real time clock
     1 # ADDD,
     vCOUNTER STD,

( update interrupt
     TFLG1-MASK # LDAA,       ( clear interrupt flag
     TFLG1 STAA,

( Set next int. time
     OC4 LDD, vPWM-CYC ADDD, OC4 STD,

rINSTINCTS DEC,

  .EQ. IF,      ( infrequently select 'INSTINCT'

          rBUSY TST,       ( DON
            .EQ. IF,       ( changed from .NE. not tested!!!!!

                           ( jump to forth routine
                      vINT-CFA LDD,

                         .NE. IF,

                                 CLI,                         ( KEN MODS )
                                 rBUSY INC,
                                 vINT-UP LDX,
                                 0 ,X STY,         ( STORE CURRENT POINTERS
                                 TSY,
                                 2 ,X STY,
                                 UP LDY,
                                 4 ,X STY,
                                 8 ( R0 ) ,X LDY, ( LOAD INT POINTERS )
                                 TYS, A ( SP0 ) ,X LDY,
                                UP STX,

                                ATO4 JSR,

                                vINT-UP LDX,
                                2 ,X LDY,
                                TYS,
                                0 ,X LDY,
                                4 ,X LDX,
                                UP STX,
                                rBUSY CLR,
                                SEI,

                              THEN,

         rMAX-INSTINCTS LDAA,
         rINSTINCTS STAA,

                  THEN,      ( normally do sensing
       THEN,      ( DON
     RTI,

END-CODE

&D
       (     Behaviors using KB.1

REG: rTASK# ( tasks can have #'s 0 - cMAX-TASKS/2

: TASK# ( n -- )      ( set task number

  1 -
  cMAX-TASKS 2/ OVER 2+ U<
    IF
     DROP
     CR ." Too many tasks!" CR
     cMAX-TASKS 2/ 1- . SPACE ." maximum " CR
    THEN

  rTASK# C! ;

: MAKE-ROOM ( -- )     ( make room in task list for new CFA

  rTASK# C@        ( Ken  12/22/93 04:32:57.84
  cMAX-TASKS 2/ 1- U<
    IF
     TASKS  rTASK# C@  2* +           ( addr1
     DUP 2+                           ( addr1 addr2
     cMAX-TASKS 2-  rTASK# C@ 2*  -
     CMOVE>
    THEN ;

: COUNT-TASKS ( -- )
  0
  cMAX-TASKS
    0 DO
     TASKS I + @     ( list addr1

       0= NOT
    IF
      1+
    THEN
      2 +LOOP
      rNUM-TASKS C!
;

: ADD-TASK: ( -- )     ( add new task to list

  DISABLE
  ( add specified task
  ' CFA

  TASKS
  rTASK# C@  2* + @    ( look at location pointed to by TASK#

      IF           ( Already filled?
         MAKE-ROOM       ( shift tasks down
      THEN

  TASKS
  rTASK# C@  2* + !
  COUNT-TASKS
  RESTORE-MODE                ( DON 8-21-96

; IMMEDIATE

: PRIORITY ( n -- )            ( DON 4-25-94

  1- rTASK# C! ;    ( DON 4-28-96  was -1  rTASK# C!
                    ( DON ADDED BACK!
: FIND-TASK: ( -- addr offset )

  ' CFA             ( list cfa
( find task in list and return address
  cMAX-TASKS
    0 DO
        TASKS I +   @     (    cfa list-cfa
        OVER        (   cfa list-cfa cfa
           = IF
                 DROP
                 TASKS I +         ( task-addr
                 I      ( task-offset
                 LEAVE
             THEN
      2 +LOOP
;

: .NAME ( cfa -- )
  2- NFA ID. ;

: SHOW-TASKS ( -- )
  CR
  cMAX-TASKS
    0 DO
     TASKS I + @     ( list addr1

     DUP      ( check for end of tasks, zero
       0=
    IF
      DROP
    ELSE
      I 2/ 1+ . .NAME CR     ( display task name
    THEN


      2 +LOOP
;

ALIAS SHOW-TASKS .TASKS

REG: rCURRENT-TASK

: NEXT-TASK  ( ... n )        ( get next task number

  rCURRENT-TASK C@ 2+
  DUP cMAX-TASKS U<
   IF
   ELSE
     DROP 0
   THEN

  DUP rCURRENT-TASK C! ;

: TERMINATE          ( DON 4-25
  0 rCURRENT-TASK C! ;


: PROC-TASK         ( process behavior task list

     BEGIN        ( there must be one non-zero task
     NEXT-TASK
     TASKS + @    ( get task
     DUP 0=
     WHILE
     DROP
     REPEAT

     EXECUTE ;

' PROC-TASK CFA CONSTANT vecTASKER

: STANDARD ( -- )      ( DON 6-22-93
  0 vINT-CFA ! ;

: MULTITASKING ( -- )    ( KEN    12/22/93 05:06:47.23

     ENABLE        ( DON 8-21-96
     0      ( check for tasks present
     cMAX-TASKS 0
     DO
     I TASKS + @ OR
     2 +LOOP

     IF
     vecTASKER vINT-CFA !
     0 rBUSY C!
     ELSE
     CR ." Unable to start multitasking, No tasks present "
     STANDARD
     0 rTASK# C!
     THEN ;

: CLEAR-TASKS ( -- )        ( clear task list
     STANDARD
     TASKS cMAX-TASKS 2+ ERASE
     rBUSY OFF
     COUNT-TASKS ;

: DEL-TASK: ( -- )     ( del named task from list

( delete specified task
  STANDARD
  DISABLE
  FIND-TASK:      ( task-addr offset

  SWAP      DUP 2+     SWAP ROT ( task-addr task-addr+2 offset
  cMAX-TASKS   SWAP - ( task-addr bytes

  CMOVE
  COUNT-TASKS
  RESTORE-MODE              ( DON 8-21-96
; IMMEDIATE

FORTH DEFINITIONS

( Random Number Code        April 1 1988
( 8 byte seed
( with Gausian Noise generator

VOCABULARY GENERATOR IMMEDIATE
GENERATOR DEFINITIONS

DECIMAL

VARIABLE PTR
8 ARRAY: SEED

: INIT.SEED ( Reset sequence to known point
   12345 SEED !
   -325 2 SEED + !
   133 4 SEED + !
   -11 6 SEED + !
;

: PTRMOD ( N ... P )   ( P = <PTR+N>MOD 7
   PTR @
   + 7 AND
   DUP PTR !
;

FORTH DEFINITIONS
: RND ( ... N )      ( -32769 < N < 32768
   [ GENERATOR ]
   TCNT @  ( bring in 'random' time
   ( 1 PTRMOD SEED + @
   2 PTRMOD SEED + @ +
   3 PTRMOD SEED + @ +
   >< DUP PTR @ SEED + !
;

: GAUSS ( RANGE ... N )      ( -RANGE < N < RANGE
   0.0 6 0 DO RND S->D D+ LOOP 6 UM/MOD SWAP DROP
   32767 */
;

: CHOOSE ( RANGE ... N | 0 <= N < RANGE )
     RND ABS SWAP MOD ;

HEX

CREATE VEC-TABLE

 7E C, FFFE @ ,         ( B7BF SCI SER SYS
 7E C, FFFE @ ,         ( B7C2 SPI SER
 7E C, FFFE @ ,         ( B7C5 PLS ACC EDGE
 7E C, FFFE @ ,         ( B7C8 PLS ACC OVFL
 7E C, FFFE @ ,         ( B7CB TMR OVERFLOW
 7E C, FFFE @ ,         ( B7CE TMR OUT CMP 5
 7E C, ' INSTINCT @ , ( B7D1 TMR OUT CMP 4
 7E C, FFFE @ ,          ( B7D4 TMR OUT CMP 3
 7E C, FFFE @ ,          ( B7D7 TMR OUT CMP 2
 7E C, FFFE @ ,         ( B7DA TMR OUT CMP 1
 7E C, FFFE @ ,         ( B7DD TMR IN CAP 3
 7E C, FFFE @ ,         ( B7E0 TMR IN CAP 2
 7E C, FFFE @ ,         ( B7E3 TMR IN CAP 1
 7E C, FFFE @ ,         ( B7E6 REAL TIME
 7E C, FFFE @ ,         ( B7E9 IRQ
 7E C, FFFE @ ,         ( B7EC XIRQ
 7E C, FFFE @ ,         ( B7EF SWI
 7E C, FFFE @ ,         ( Ä B7F2 OP-CODE TRAP
 7E C, FFFE @ ,         ( B7F5 COP FAILURE
 7E C, FFFE @ ,         ( B7F8 CLK MON
 HERE CONSTANT VEC-TABLE-END

HEX
: VEC-INIT

  FF6C 26 !
    ( DID IT IN SYSTEM2.FTH | INIT make OC5 larger to insure EEC!

  DISABLE
( CHECK AND MOVE VECTORS IF NECESSARY

  VEC-TABLE-END VEC-TABLE - 0 ( RANGE
    DO
     B7BF I + C@
     VEC-TABLE I + C@ =

       NOT

    IF
       ." ."
       VEC-TABLE I +  C@
       B7BF I +          EEC!
    THEN
    LOOP ;
      DECIMAL
HEX


.( load RCL.FTH next
CR


      ( Robot Control Language Version 1.0    12-3-92

( Copyright Angelus Research 1992
( This software cannot be sold or incorporated into
( another product without express permission from
( Angelus Research, 6344 Sugar Pine Circle,
( Angelus Oaks, California 92305 ( 909-794-8325
( All rights reserved

( FORGET RCL
: RCL ;
DECIMAL

: SPEED ( speed -- )    ( motor = LEFT or RIGHT
  rMAX-SPEED C@ MIN
  0 MAX
  rCHOICE C@
    cLEFT = IF
      DUP rLSPEED C!
      DUP rLTON C!
      rMAX-SPEED C@ SWAP - rLTOFF C!
    ELSE
      DUP rRSPEED C!
      DUP rRTON C!
      rMAX-SPEED C@ SWAP - rRTOFF C!
    THEN
  NO-STALLS
  ;

: % ( n percent --  )
  100 */ ;

: %SPEED ( n -- )         ( n is percent of full speed
     rMAX-SPEED C@ %
     SPEED ;

: ACTION ( -- t/f )  ( sense both whiskers hit
     RW-OBSTACLE LW-OBSTACLE +
     DUP OBSTACLE =
     ;

REG: rSAV-DIR

: REVERSE-DIR ( -- )
  rMASK C@
   &B 00101000 XOR  &D
  rMASK C!
;

: SAVE-DIR ( -- )
  rMASK C@
  rSAV-DIR C! ;

: RESTORE-DIR ( -- )
  rSAV-DIR C@
  rMASK C! ;

&D

: PERIODS ( ms -- | ~ 2 ms typical )
  vCOUNTER 0!
  BEGIN
    vCOUNTER @ OVER >
  UNTIL
  DROP ;

: SECS ( secs -- )      ( wait for specified time
  2000.000 vPWM-CYC @ UM/MOD SWAP DROP      *
  PERIODS ;

: MINUTES ( min -- )
  60 SECS ;


360 CONSTANT 360

: ADJUST-DEGREES ( n -- )
  vMAX-COMPASS +! ;

: CLEAR-COMPASS
     vCOMPASS 0!
;

: BEARING ( -- bearing )
     vCOMPASS @
     360 vMAX-COMPASS @ */
     ;

: DEGREES  ( degrees -- )
     ABS
     rCHOICE C@
     cRIGHT =
       IF
          BEARING +
            BEGIN
              DUP BEARING
            < UNTIL
       ELSE
           NEGATE BEARING +
             BEGIN
               DUP BEARING
             > UNTIL
       THEN
     DROP ;

: STOP ( -- )
  ( CLEAR-SENSORS
  NO-STALLS
  ST rMASK C! ;

: FORWARD ( -- )
  ( CLEAR-SENSORS
  NO-STALLS
  FWD rMASK C! ;

: BACKUP ( -- )
  ( CLEAR-SENSORS
  NO-STALLS
  REV rMASK C! ;

ALIAS BACKUP BACK

( CREATE TRIGGER-TABLE  ( DON 4-20-94 too sensitive to bright light

( 10 C, 11 C, 12 C, 13 C, 14 C, 14 C, 16 C, 17 C, 18 C, 19 C, 20 C,
( 21 C, 22 C, 23 C, 24 C, 25 C, 26 C, 27 C, 28 C, 29 C, 30 C, 31 C,
( 32 C, 33 C, 34 C, 35 C, 36 C,

DECIMAL
( DON

: FAST-CAL ( calibrate without printout

             rFACTOR C@

             DUP rLF-TRIGGER  C!
             DUP rLSF-TRIGGER C!
             DUP rRF-TRIGGER  C!
                 rRSF-TRIGGER C!

             rSUM-FACTOR C@

             DUP rL-TRIGGER C!
             DUP rR-TRIGGER C!
                 rF-TRIGGER C!
     ;
( CALIB takes 16 milliseconds

: CALIBRATE

     FAST-CAL
     CR ." trigger set to   L    LS   R    RS   L+   R+   F+ "
     CR 15 SPACES
     4 0 DO         ( Treat individual triggers as a table
     rLF-TRIGGER I + C@ 5.R   ( DON 4-25-94
     LOOP
     rL-TRIGGER C@ 5.R
     rR-TRIGGER C@ 5.R
     rF-TRIGGER C@ 5.R
     ;

: START-ROBOT

  DISABLE      ( DON 4-18-94
  INIT

  &B 00010000 &H ADCTL C!
  SEI
  VEC-INIT
  VEC-INIT

  &B 00010000 &D TMSK1 C!
  900  OC4 !
  CLI
( CALIBRATE   DON moved to BOOTING so robot doesn't move on bootup
  ;

REG: SAV-rLSPEED
REG: SAV-rRSPEED

: SAVE-SPEEDS ( -- )
  rLSPEED C@ SAV-rLSPEED C!
  rRSPEED C@ SAV-rRSPEED C! ;

: RESTORE-SPEEDS ( -- )
  ( CLEAR-SENSORS
  SAV-rLSPEED C@  LEFT SPEED
  SAV-rRSPEED C@  RIGHT SPEED ;

: RAMP-UP ( rate speed -- )
  ( CLEAR-SENSORS
  SWAP 10 * SWAP     ( DON delay interval
  100 MIN
  0 DO
    I LEFT SPEED     ( DON changed to SPEED
    I RIGHT SPEED      ( "
    DUP DELAY
  LOOP
  DROP ;

: RAMP-DOWN ( rate --  )
  ( CLEAR-SENSORS
  100 *
  0 rLSPEED C@      rRSPEED C@  MIN
  DO
    I LEFT SPEED
    I RIGHT SPEED
    DUP DELAY
  -1 +LOOP
  STOP
  ;

ALIAS SENSORS SHOW-SENSORS ( -- )

: STRAIGHT ( Set speeds to same average value -with correction
  rCHOICE C@
  rCORRECTION C@
  rRSPEED C@ rLSPEED C@ + OVER + 2/
  ( Split speed difference between sides
  RIGHT SPEED
  rRSPEED C@ SWAP -
  LEFT SPEED
  rCHOICE C!
  ;

: PIVOT ( -- )     ( use current average speed
  ( CLEAR-SENSORS
  NO-STALLS
  rCHOICE C@         ( Get chosen direction
    cLEFT = IF
      PVL rMASK C!
    ELSE
      PVR rMASK C!
    THEN
  ;

: BEST-PIVOT ( -- )

( CLEAR-SENSORS
  NO-STALLS                        ( DON 4-28-96

  rL-VALUE C@
  rR-VALUE C@
   >
     IF
        RIGHT PIVOT       ( DON
    ELSE
        LEFT PIVOT   ( DON
    THEN  ;


: ALL-INSTINCTS ( mask -- )
  rLF-MASK  11 ROT FILL ; ( masks are stored consequtively in RAM

100 ARRAY: LEVELS

VARIABLE vSTEP

: STEP ( step -- )      ( degrees to step
     vSTEP ! ;

: FIND-SOUND ( -- )       ( DON

     STOP
     CLEAR-COMPASS
     75 LEFT SPEED
     75 RIGHT SPEED
     SAVE-INSTINCTS      ( DON 8-12-93
     PVR ALL-INSTINCTS

     360  vSTEP @  /
            0 DO

                NO-STALLS
                ENABLE
                RIGHT PIVOT
                vSTEP @ I * BEARING -
                DEGREES
                STOP

                DISABLE
                10000 DELAY
                SOUND-LEVEL  DUP
                LEVELS I +  C!

                CR ." level=" . SPACE
                PRINT BEARING .

              LOOP

  RESTORE-INSTINCTS
  RESTORE-MODE              ( DON 8-21-96

  ;

: MAX-LEVEL ( -- index )

     0 0   ( maximum index,level reading
     360 vSTEP @ / 0
        DO
          DUP I LEVELS + C@
              < IF           ( new maximum
                   2DROP         ( old index,level
                   I DUP LEVELS + C@     ( new index, level
                THEN

        LOOP
     ;

: PIVOT-SOUND ( -- )

     SAVE-INSTINCTS
     PVL ALL-INSTINCTS        ( DON 8-12-93

     BEARING
     MAX-LEVEL DROP
     vSTEP @ * -
     CR ." going to " BEARING OVER - .  SPACE ." degrees" CR
     NO-STALLS
     ENABLE
     LEFT
     PIVOT
     DEGREES
     STOP
     RESTORE-INSTINCTS ;    ( DON 8-12-93


: TURN ( -- )

  NO-STALLS
  rCHOICE C@

    cLEFT =          ( DON 10-1-93 WAS DUP cLEFT

       IF
      RF rMASK C!
       ELSE
      LF rMASK C!
       THEN
;

: CIRCLE ( dia -- )  ( Set difference in speed of 'dia'
  rMAX-SPEED C@ %    ( All speeds are treated as % of full speed
  rCORRECTION C@ +   ( Split speed difference between sides
  rRSPEED C@ rLSPEED C@ + OVER + 2/
  rCHOICE C@
    cRIGHT =
      IF
     LEFT SPEED       ( use range check in speed to set bounds
     rLSPEED C@ SWAP -      ( ensure proper difference
     RIGHT SPEED
      ELSE
     RIGHT SPEED
     rRSPEED C@ SWAP -
     LEFT SPEED
      THEN
  FORWARD ;

: SQUARE ( size -- )
  1000 *
  STRAIGHT FORWARD
  4 0 DO
     DUP DELAY
     RIGHT PIVOT  90 DEGREES
     FORWARD
  LOOP
  DROP
  STOP ;

VARIABLE vWAIT-TIME

: %HIGHER-TRIGGER ( percent -- )
     7 0 DO
     rLF-TRIGGER I + C@
     OVER %
     rLF-TRIGGER I + C!
     LOOP DROP ;

: WAIT-TIME ( time -- )
  vWAIT-TIME ! ;

: DEFAULT-INSTINCTS ( -- )
   PVL rRF-MASK        C!       ( intialize instincts
   PVL rRSF-MASK C!
   PVR rLF-MASK        C!
   PVR rLSF-MASK C!
   PVR rLW-MASK        C!
   PVL rRW-MASK        C!
   PVR      rL-MASK   C!
   PVL      rR-MASK   C!
   REV      rF-MASK   C!
   RR  rLM-MASK        C!      ( DON 5-13-93
   LR  rRM-MASK        C!      ( DON 5-13-93
;
DEFAULT-INSTINCTS

: STOP-INSTINCTS ( -- )
     rLF-MASK 11 ERASE ( intialize instincts
     ;

: SPIN ( %speed -- )
  rCHOICE C@ SWAP      ( get current direction choice
  DUP LEFT %SPEED RIGHT %SPEED
    cLEFT =
      IF
     LEFT PIVOT
      ELSE
     RIGHT PIVOT
      THEN
;

: INIT-RCL
  0 SAV-rLSPEED        C!
  0 SAV-rRSPEED        C!

  20 vSTEP    !
  1000 vWAIT-TIME !
;

( ' ( NFA ' SYSTEM LFA !
( ' COPYRIGHT NFA
( .( update $38 on prom system with  U.


          ( Sound routines

HEX

VOCABULARY MUSIC IMMEDIATE
MUSIC DEFINITIONS

HEX

CODE NOTE ( Period Dur --- )

( Period is 2MHz divided by 2* note freq in Hz
    SEC LDD,
    TCNT ADDD,
    TOP LDX,
    BEGIN,
     BEGIN,
     TCNT CPD,
     .--. UNTIL,
     SEC ADDD,
     PSHA,
     B008 LDAA,
     20 # EORA,
     B008 STAA,
     PULA,
    DEX,
    .EQ. UNTIL,
    20 NOT # LDAA,
    B008 ANDA,
    B008 STAA,
    POPTWO JMP,
END-CODE

DECIMAL

: NOTE: <BUILDS , , DOES> 2@ ROT * vPACE 2@ */ NOTE ;
( period dur .. --define time
( n ..      - run time and n is length in 1/8th notes

(  period     dur

  18182      28     NOTE:  A
  17161      29     NOTE:  A#
  16198      31     NOTE:  B
  15289      33     NOTE:  C
  14431      35     NOTE:  C#
  13621      37     NOTE:  D
  12856      39     NOTE:  D#
  12135      41     NOTE:  E
  11454      44     NOTE:  F
  10811      46     NOTE:  F#
  10204      49     NOTE:  G
   9631      52     NOTE:  G#
   9091      55     NOTE: 1A
   8581      58     NOTE: 1A#
   8099      62     NOTE: 1B
   7645      65     NOTE: 1C
   7215      69     NOTE: 1C#
   6810      73     NOTE: 1D
   6428      78     NOTE: 1D#
   6067      82     NOTE: 1E
   5727      87     NOTE: 1F
   5405      92     NOTE: 1F#
   5102      98     NOTE: 1G
   4816          104     NOTE: 1G#
   4545          110     NOTE: 2A
   4290          117     NOTE: 2A#
   4050          123     NOTE: 2B
   3822          131     NOTE: 2C
   3608          139     NOTE: 2C#
   3405          147     NOTE: 2D
   3214          156     NOTE: 2D#
   3034          165     NOTE: 2E
   2863          175     NOTE: 2F
   2703          185     NOTE: 2F#
   2551          196     NOTE: 2G
   2408          208     NOTE: 2G#
   2273          220     NOTE: 3A
   2145          233     NOTE: 3A#
   2025          247     NOTE: 3B
   1911          262     NOTE: 3C
   1804          277     NOTE: 3C#
   1703          294     NOTE: 3D
   1607          311     NOTE: 3D#
   1517          330     NOTE: 3E
   1432          349     NOTE: 3F
   1351          370     NOTE: 3F#
   1276          392     NOTE: 3G
   1204          415     NOTE: 3G#
   1136          440     NOTE: 4A
   1073          466     NOTE: 4A#
   1012          494     NOTE: 4B
    956          523     NOTE: 4C
    902          554     NOTE: 4C#
    851          587     NOTE: 4D
    804          622     NOTE: 4D#
    758          659     NOTE: 4E
    716          698     NOTE: 4F
    676          740     NOTE: 4F#
    638          784     NOTE: 4G
    602          831     NOTE: 4G#

DECIMAL

( START DON
( : CYCLES ( Period Duration ---
(     MUSIC
(     SWAP 57 * SWAP 1 MAX NOTE ;  ( This is equivelent to old CYCLES

FORTH DEFINITIONS
VARIABLE dTIME
VARIABLE sTIME

HEX

FORTH

VARIABLE MIN-FREQ

VARIABLE LENGTH

VARIABLE vADJ-INCHES          ( DON 4-25-94  -->

: ADJUST-INCHES        ( n -- )
  vADJ-INCHES +! ;

: INCHES  ( inches -- )
  vDISTANCE @
  +
  vADJ-INCHES @ + >R

  BEGIN
    vDISTANCE @
    R@

  > UNTIL
  R> DROP ;

: FEET ( feet --  )
  0 DO
    12 INCHES
    LOOP ;            ( DON 4-25-94

ALIAS FEET FOOT            ( DON 4-25-94

: WAIL ( rate times  -- )
  MUSIC
    0 DO
     vWAIL @     DUP
     2* SWAP DO
       I I 2 PICK / NOTE
     LOOP
     LOOP
  DROP
;

: LSF-GREATER? ( -- )          ( left side sensor greater than
  rLSF-VALUE C@         ( right side sensor? T/F
  rRSF-VALUE C@
  > ;

: RSF-GREATER? ( -- )          ( right side sensor greater than
  rRSF-VALUE C@         ( left side sensor? T/F
  rLSF-VALUE C@
  > ;

: WARBLE ( freg times -- )     ( 400 10 WARBLE
  MUSIC
    0 DO
     DUP 60 DO
      I OVER 1 / I - NOTE
       10 +LOOP
      LOOP
DROP ;

: LASER ( freg -- )     ( 800 LASER
  MUSIC
  10 0 DO
      DUP 60 DO
        I 10 NOTE
     10 +LOOP
       LOOP
  DROP ;

: BIRD-CALL ( freq times -- )        ( 600 2 TONES
  MUSIC
    0 DO
     DUP 0 DO
     I OVER I - NOTE
      100 +LOOP
      LOOP
DROP ;

: UP-DOWN ( freq steps -- )  (     1000 20 UP-DOWN

  MUSIC

    DUP
    1 DO
     I OVER NOTE
      10 +LOOP

    DUP
    1 DO
     DUP I - OVER NOTE
      10 +LOOP
    2DROP
   ;

: TONES ( period times -- )   ( 60 2 TONES
  MUSIC
     0 DO
    DUP 0 DO
          I OVER I - NOTE
       LOOP
       LOOP DROP ;

: ~ 2000 0 DO LOOP ;

FORTH DEFINITIONS

: BLOW_THE_MAN_DOWN!
     MUSIC
     2 2G
     2 2G 1 3A 3 2G
     2 2E 2 2C 2 2E
     3 2G 1 3A 2 2G
     4 2E 1 2C 1 2E
     6 2G 6 3A
     3 2F 1 2E 2 2F
     4 2D 4 2D
     2 2D 2 2D 2 2D
     2 2F 2 2E 2 2D
     2 2F 2 2E 2 2D
     6 3A
     2 2G 2 2G 2 2G
     4 2G 2 2F
     3 2E 1 2D 2 2E
     6 2C ;

: RIDE_OF_THE_VALKERIES
     MUSIC
     2 2C 1 2C 3 2D# 3 2C
     2 2D# 1 2D# 3 2G 3 2D#
     2 2G 1 2G 3 3A# 3 2A#
     2 2D# 1 2D# 6 2G ;

: CANCEL     ( DON MOVED
  vBOOT-WORD 0! ;

: STAY-COURSE

  vCOMPASS @
  DUP . SPACE

    0 <
         IF
             rRSPEED C@
             vCOMPASS @  ABS
             -
             RIGHT SPEED

             rLSPEED C@
             vCOMPASS @  ABS
             +
             LEFT SPEED

         THEN

  vCOMPASS @

    0 >
         IF
             rLSPEED C@
             vCOMPASS @  ABS
             -
             LEFT SPEED

             rRSPEED C@
             vCOMPASS @  ABS
             +
             RIGHT SPEED

         THEN
;

VARIABLE vSTAY-TIME
  50 vSTAY-TIME !

REG: rSTAY-COURSE
     rSTAY-COURSE OFF

: STAY-COURSE-PIVOT

  rSTAY-COURSE C@

     0=
         IF
            CLEAR-COMPASS
            EXIT
         THEN

( BEGIN

  vCOLLIDED @
  0=
    IF

       vSTAY-TIME @  PERIODS

       vCOMPASS @  ( DUP . SPACE

         0=
            IF
              FORWARD
            THEN

       vCOMPASS @
         0<
          IF
(              CR ." TOO LOW"
              SAVE-SPEEDS
(              20 LEFT SPEED
              RIGHT PIVOT

              BEGIN

                  vCOMPASS @ DUP . SPACE

              0> UNTIL
              CLEAR-COMPASS
              FORWARD
              RESTORE-SPEEDS
          ELSE
              vSTAY-TIME @ PERIODS
          THEN

  vCOMPASS @
     0>
          IF
(              CR ." TOO HIGH"
              SAVE-SPEEDS
(              20 LEFT SPEED
              LEFT PIVOT

              BEGIN

                  vCOMPASS @

              0< UNTIL
              CLEAR-COMPASS
              FORWARD
              RESTORE-SPEEDS
          THEN
  THEN

;

( REG: rWAIT-FOR-SOUND
( 100 rWAIT-FOR-SOUND C!

( : WAIT-FOR-SOUND

(  CR ." Waiting for sound..."

(  BEGIN

(    DIGITIZE-PEAK
(    rPEAK-SOUND C@
(    rWAIT-FOR-SOUND C@
(      >
(         IF
(            EXIT
(         THEN
(  AGAIN
( ;


( : START-SOUND

(  DISABLE
(  7 rSOUND-AVERAGE C!
(  500 SAMPLES
(  1000 vMAX-COMPASS !
(  DEFAULT-INSTINCTS
(  DECIMAL
(  ENABLE
(  80 TRIGGER-FACTOR
(  80 SUM-FACTOR
(  CALIBRATE
(  50 LEFT SPEED
(  50 RIGHT SPEED
(
( BEGIN

(  rSTAY-COURSE ON
(  WAIT-FOR-SOUND
(  FORWARD
(  1000 6 BIRD-CALL

(  CLEAR-COMPASS
(  FORWARD

(  1540 vMAX-COMPASS !
(  STANDARD
(  FIND-SOUND
(  PIVOT-SOUND

(  FORWARD
(  MULTITASKING
(
(  1000 LASER
(  100 PERIODS

(  STANDARD
(  rSTAY-COURSE OFF
(  1950 vMAX-COMPASS !
(  SAVE-SPEEDS
(  100 LEFT SPEED
(  100 RIGHT SPEED
(  LEFT PIVOT 360 DEGREES STOP
(  CLEAR-COMPASS
(  LEFT PIVOT 180 DEGREES STOP
(  CLEAR-COMPASS
(  CR ." found noise...going back"
(  RESTORE-SPEEDS

(  FORWARD
(  rSTAY-COURSE ON
(  MULTITASKING

( 1000 LASER
( 100 PERIODS

( CR ." home pivot"
( STANDARD
( SAVE-SPEEDS
( 100 LEFT SPEED
( 100 RIGHT SPEED
( LEFT PIVOT 180 DEGREES STOP
( CLEAR-COMPASS
( RESTORE-SPEEDS
(
( ?TERMINAL UNTIL
( ;

REG: rCENTER-GAIN
2 rCENTER-GAIN SET

REG: rCENTER-DIFF
10 rCENTER-DIFF C!

REG: rCENTER-MIN-SPEED
     20 rCENTER-MIN-SPEED C!

: SIDE-CENTERING

  rMAX-SPEED C@

  rLSF-VALUE C@
  rLF-VALUE C@ +

  rCENTER-DIFF C@ +
  rCENTER-GAIN C@ *
  -
  rCENTER-MIN-SPEED C@  MAX
  RIGHT SPEED


  rMAX-SPEED C@

  rRSF-VALUE C@
  rRF-VALUE C@ +

  rCENTER-GAIN C@ *
  -
  rCENTER-MIN-SPEED C@  MAX
  LEFT SPEED
;

: ENABLE-STALLS

  rNO-STALLS OFF ;
(

( : SEARCH-FOR-SOUND

( 30 rLM-TRIGGER SET
( 30 rRM-TRIGGER SET

( 80 TRIGGER-FACTOR
( CALIBRATE
( 1940 vMAX-COMPASS !
( 7 rSOUND-AVERAGE C!
( 500 SAMPLES
( CALIBRATE

( WAIT-FOR-SOUND

( ;

CANCEL
DECIMAL
: INIT-ROBOT ( -- )

(  100 rWAIT-FOR-SOUND C!
  2  rCENTER-GAIN SET
  10 rCENTER-DIFF C!
  20 rCENTER-MIN-SPEED C!
  15 rSOUND-AVERAGE C!    ( DON 8-30-96

 SYSTEM-INIT
  INIT
  vCOUNTER       0!
  1  vSENSOR-CYC     !
     vCOLLIDED      0!
     rINSTINCTS       OFF
  INIT-OPTIONS
  INIT-ADC1
  INIT-RCL
  ST ALL-INSTINCTS ;     ( DON 4-18-94 was DEFAULT-INSTINCTS

CR
.( load SPIMD2B.TXT NEXT )


