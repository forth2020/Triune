                              ( 1993 rssc FAIR RACE )

DISABLE
FORGET STUB
: STUB ;

50 LEFT SPEED
50 RIGHT SPEED

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

( CLEAR-SENSORS

( ?TERMINAL UNTIL ;
;

: F-HIT

  F-OBSTACLE SENSOR

    IF
       CR ." front side hit!"  
       BACKUP 
       300 LASER
       LEFT PIVOT 90 DEGREES
       FORWARD
       500 LASER  
       CLEAR-SENSORS   
    THEN
  
 ;

: R-HIT

  R-OBSTACLE SENSOR

    IF
      CR ." right side hit!"  
       LEFT PIVOT 
       500 2 WARBLE
       FORWARD
       400 LASER  
       CLEAR-SENSORS
    THEN ;


: L-HIT

  L-OBSTACLE SENSOR

    IF
      CR ." left side hit!"  
       RIGHT PIVOT 
       500 2 WARBLE
       FORWARD
       400 LASER  
       CLEAR-SENSORS
    THEN ;

CLEAR-TASKS

0 PRIORITY ADD-TASK: F-HIT
1 PRIORITY ADD-TASK: R-HIT
2 PRIORITY ADD-TASK: L-HIT
3 PRIORITY ADD-TASK: STAY-COURSE-PIVOT
4 PRIORITY ADD-TASK: ENABLE-STALLS

: START-SOUND

  DISABLE  
  130 vPIVOT-SOUND !
  7 rSOUND-AVERAGE C!
  500 SAMPLES  
  1000 vMAX-COMPASS !
  DEFAULT-INSTINCTS
  DECIMAL
  ENABLE
  80 TRIGGER-FACTOR
  80 SUM-FACTOR
  CALIBRATE
  50 LEFT SPEED
  50 RIGHT SPEED

BEGIN
  
  rSTAY-COURSE ON
  WAIT-FOR-SOUND
  FORWARD
  1000 6 BIRD-CALL

  CLEAR-COMPASS
  FORWARD

  1540 vMAX-COMPASS !
  STANDARD
  FIND-SOUND
  PIVOT-SOUND

  FORWARD
  MULTITASKING

  1000 LASER 
  100 PERIODS

  STANDARD
  rSTAY-COURSE OFF
  1950 vMAX-COMPASS !
  SAVE-SPEEDS
  100 LEFT SPEED
  100 RIGHT SPEED
  LEFT PIVOT 360 DEGREES STOP
  CLEAR-COMPASS
  LEFT PIVOT 180 DEGREES STOP
  CLEAR-COMPASS
  CR ." found noise...going back"
  RESTORE-SPEEDS

  FORWARD
  rSTAY-COURSE ON
  MULTITASKING

  1000 LASER
  100 PERIODS

  CR ." home pivot"
  STANDARD
  SAVE-SPEEDS
  100 LEFT SPEED
  100 RIGHT SPEED
  LEFT PIVOT 180 DEGREES STOP
  CLEAR-COMPASS
  RESTORE-SPEEDS

?TERMINAL UNTIL 
;

REMEMBER

AUTO-START: START-SOUND

REMEMBER
