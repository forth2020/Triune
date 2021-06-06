                              ( 1993 rssc FAIR RACE )

DISABLE
FORGET STUB
: STUB ;

VARIABLE TOTAL-DISTANCE
VARIABLE vADJ-DISTANCE

: ADJUST-DISTANCE

  vADJ-DISTANCE ! ;

&D 18 ADJUST-DISTANCE

: INCHES ( inches -- )

  SAVE-SPEEDS
  100 LEFT SPEED
  100 RIGHT SPEED
  vADJ-DISTANCE @ *

  rMASK C@
    FWD =
      IF
        0 vDISTANCE !
        vDISTANCE @ +
        BEGIN
          DUP
          vDISTANCE @
        < UNTIL
        DROP
      THEN

  rMASK C@
    REV =
      IF
        vDISTANCE !
        BEGIN
          vDISTANCE @
       0< UNTIL
      THEN

  RESTORE-SPEEDS
  STOP ;

: FEET ( feet -- )
  12 INCHES ;

ALIAS FEET FOOT

: F-HIT

  F-OBSTACLE SENSOR

  IF
    LM-OBSTACLE SENSOR
    RM-OBSTACLE SENSOR OR
      NOT IF
            BEST-PIVOT
            600 LASER ( 45 DEGREES
            FORWARD
            CLEAR-SENSORS
         THEN
  THEN
;
: BW-HIT

        LW-OBSTACLE SENSOR
        RW-OBSTACLE SENSOR
        AND

          IF
                    BACKUP
                    500 LASER
                    BEST-PIVOT
                    90 DEGREES
                    FORWARD
                    CLEAR-SENSORS
          THEN
;

VARIABLE vCUR-BEARING
10000 vCUR-BEARING NOW

100 LEFT SPEED
100 RIGHT SPEED
SAVE-SPEEDS

: BEARING-DIFF  ( -- n )

  vCUR-BEARING VALUE
  vCOMPASS VALUE - ABS
  ;

: CHECK-INSTINCTS

  BEGIN
    vCOLLIDED VALUE
      0=
        IF
          EXIT
        ELSE
          SAVE-SPEEDS
          100 LEFT SPEED
          100 RIGHT SPEED
          500 3 WARBLE
          CLEAR-SENSORS
          RESTORE-SPEEDS
        THEN
  AGAIN
;

: STAY-COURSE

  BEARING-DIFF 0= NOT

    IF
     ( SAVE-DIR
     ( SAVE-SPEEDS
      FORWARD 500 LASER
      BEGIN

       CHECK-INSTINCTS
       vCUR-BEARING VALUE
       vCOMPASS VALUE

          >
            IF
               BEARING-DIFF                        LEFT SPEED
               100 BEARING-DIFF -  30 MIN          RIGHT SPEED

                 rLSPEED GET
                 rRSPEED GET  10 +

                   <
                     IF
                       ( FORWARD 1 SECS
                       100 LEFT SPEED
                       70 RIGHT SPEED
                       ( RIGHT PIVOT
                     THEN
            ELSE
              BEARING-DIFF                       RIGHT SPEED
              100 BEARING-DIFF -   30 MIN        LEFT SPEED

                 rRSPEED GET
                 rLSPEED GET 10 +
                   <
                     IF
                       ( FORWARD 1 SECS
                       100 RIGHT SPEED
                       70 LEFT SPEED    ( LEFT TURN
                       ( LEFT PIVOT
                     THEN
            THEN

 (     vCOMPASS @ .

      BEARING-DIFF 0= UNTIL
    THEN
(  vCOMPASS @ .
(  RESTORE-DIR
  RESTORE-SPEEDS
;

1 PRIORITY ADD-TASK: BW-HIT
2 PRIORITY ADD-TASK: F-HIT
3 PRIORITY ADD-TASK: STAY-COURSE
4 PRIORITY ADD-TASK: FORWARD

: OB-COURSE

  STANDARD
  38 TRIGGER-FACTOR
  CALIBRATE

  18 ADJUST-DISTANCE
  5000 vCOMPASS !
  5000 vCUR-BEARING !
  PVL rF-MASK SET
  80 LEFT SPEED
  80 RIGHT SPEED
  FORWARD

  MULTITASKING
  RIDE_OF_THE_VALKERIES
  BLOW_THE_MAN_DOWN!
;

REMEMBER
AUTO-START: OB-COURSE


: OB-TEST

  STANDARD
  38 TRIGGER-FACTOR
  CALIBRATE

  18 ADJUST-DISTANCE
  5000 vCOMPASS !
  5000 vCUR-BEARING !
  PVL rF-MASK SET
  80 LEFT SPEED
  80 RIGHT SPEED
  SAVE-SPEEDS
  FORWARD
   BEGIN
     STAY-COURSE
   AGAIN

  RIDE_OF_THE_VALKERIES
  BLOW_THE_MAN_DOWN!
;
REMEMBER
AUTO-START: OB-TEST

