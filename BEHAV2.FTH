                       ( Behaviors using KB.1  )

( must load EFFECTKB.FTH 1st

DISABLE
FORGET BEHAVIOR2

: BEHAVIOR2 ;

VARIABLE vFRUSTRATION
0 vFRUSTRATION NOW

100 vWAIL NOW
VARIABLE vFRUST-TRIGGER
8 vFRUST-TRIGGER NOW

( ST rRM-MASK C!
( ST rLM-MASK C!
(  FWD rLSF-MASK C!
( FWD rLSF-MASK C!

: FRUSTRATED
  vFRUSTRATION VALUE
  vFRUST-TRIGGER VALUE
  >
    IF
      SAVE-DIR
      SAVE-SPEEDS
      5 0 DO
            40 LEFT SPEED
            40 RIGHT SPEED
            LEFT PIVOT
            30 2 WAIL
            RIGHT PIVOT
            30 2 WAIL
          LOOP
      RESTORE-DIR
      RESTORE-SPEEDS
      0 vFRUSTRATION NOW
      BEST-PIVOT
      30 10 WAIL              ( 7-13-94
      EXIT

    ELSE

      vFRUSTRATION VALUE
      0<
        IF
          1 vFRUSTRATION NOW
        ELSE
          vFRUSTRATION DECREMENT
        THEN
    THEN
;

VARIABLE rBAT-TRIGGER
70 rBAT-TRIGGER NOW
ALIAS rADR1-B rBATTERY

: LOW-BAT                         ( low too low
     rBATTERY GET
     rBAT-TRIGGER GET

       <               ( less than? )

         IF
           DISABLE
           DECIMAL
           ." Battery low!="
           rBATTERY GET  DISPLAY CR
           ." Please get me to the charger...FAST!" CR

           BEGIN
             600 50 WARBLE
           AGAIN

         THEN
;

: RM-HIT


   RM-OBSTACLE SENSOR

      IF

           SAVE-SPEEDS
           SAVE-DIR
           LEFT PIVOT
           700 LASER
           RESTORE-SPEEDS
           RESTORE-DIR
      THEN
;




: M-HIT                          ( motor stalled

        RM-OBSTACLE SENSOR
        LM-OBSTACLE SENSOR  OR
         OR

          IF
            4 vFRUSTRATION INCREASE

            SAVE-DIR
            SAVE-SPEEDS

            700 4 BIRD-CALL
            700 4 BIRD-CALL

            BEST-PIVOT

            700 4 BIRD-CALL
            700 4 BIRD-CALL

            RESTORE-DIR
            RESTORE-SPEEDS
            CLEAR-SENSORS
            FORWARD
          THEN
;

: F-HIT                           ( both front hit
        F-OBSTACLE SENSOR

          IF
            4 vFRUSTRATION INCREASE
            LM-OBSTACLE SENSOR
            RM-OBSTACLE SENSOR OR
              NOT IF

                    SAVE-DIR
                    SAVE-SPEEDS
                    BACKUP
                    6 60 RAMP-UP
                    500 LASER
                    BEST-PIVOT
                    500 LASER
                    RESTORE-DIR
                    RESTORE-SPEEDS
                    CLEAR-SENSORS
                  THEN
          THEN
;

: BS-HIT                           ( both sides hit
        LSF-OBSTACLE SENSOR
        RSF-OBSTACLE SENSOR
        AND

          IF

            SAVE-DIR
            SAVE-SPEEDS
            0 vFRUSTRATION NOW       ( turn off FRUSTRATION

            FORWARD
            FWD rLSF-MASK C!
            FWD rRSF-MASK C!
            FWD rL-MASK C!
            FWD rR-MASK C!

            50 LEFT SPEED
            50 RIGHT SPEED

            LSF-GREATER?
              IF
                FWD ALL-INSTINCTS
                85 RIGHT %SPEED
                MUSIC 1 4C
              ELSE
                85 LEFT %SPEED
                MUSIC 1 4C
              THEN

          RESTORE-DIR
          RESTORE-SPEEDS
          CLEAR-SENSORS
          DEFAULT-INSTINCTS
          THEN
;

: BW-HIT
        LW-OBSTACLE SENSOR
        RW-OBSTACLE SENSOR
        AND

          IF
            SAVE-DIR
            SAVE-SPEEDS
            3 vFRUSTRATION INCREASE
                    rLIGHTS OFF
                    rWHISKERS OFF
                    BACKUP
                    4 90 RAMP-UP
                    600 LASER
                    BEST-PIVOT

                    600 LASER

                    FORWARD
                    rWHISKERS ON
                    rLIGHTS ON

            RESTORE-DIR
            RESTORE-SPEEDS
            CLEAR-SENSORS
          THEN
;

DECIMAL
CLEAR-TASKS

  1 PRIORITY ADD-TASK: FRUSTRATED
  2 PRIORITY ADD-TASK: LOW-BAT
  3 PRIORITY ADD-TASK: F-HIT
  4 PRIORITY ADD-TASK: M-HIT
  5 PRIORITY ADD-TASK: BW-HIT
  6 PRIORITY ADD-TASK: BS-HIT
  7 PRIORITY ADD-TASK: FORWARD

: DEMO

  STOP
  65 LEFT SPEED
  65 RIGHT SPEED
  15 rRM-TRIGGER SET
  15 rLM-TRIGGER SET
  15 TRIGGER-FACTOR
  100 SUM-FACTOR
  CALIBRATE
  MULTITASKING
  FORWARD

  RIDE_OF_THE_VALKERIES
  BLOW_THE_MAN_DOWN!

;

15 TRIGGER-FACTOR
CALIBRATE





REMEMBER
AUTO-START: DEMO

 