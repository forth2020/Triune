(           Compass using speed           8-31-96

1479 vMAX-COMPASS !

: NO-INSTINCTS

  255 rLF-TRIGGER SET
  255 rLSF-TRIGGER SET
  255 rRF-TRIGGER SET
  255 rRSF-TRIGGER SET
  255 rR-TRIGGER SET
  255 rL-TRIGGER SET
  255 rF-TRIGGER SET
  255 rLM-TRIGGER SET
  255 rRM-TRIGGER SET
;

: BEARING

  vCOMPASS @ ABS vMAX-COMPASS @
  MOD
  360 vMAX-COMPASS @ */

  vCOMPASS @ 
   0<
      IF
          360 SWAP -
      THEN 
  DUP . CR
  ;

: DEGREES ( degrees -- )

  BEARING 
  rCHOICE C@

   cRIGHT =

      IF
         +
         360 MOD 1-

         BEGIN
           BEARING  
            OVER = 
         UNTIL

       ELSE
          -  
         DUP 0<
            IF
                360 +
            THEN

         BEGIN
           BEARING  
            OVER = 
         UNTIL
       THEN 
  DROP
;

: Q LEFT PIVOT 360 DEGREES STOP ;

: W RIGHT PIVOT 360 DEGREES STOP ;


: A LEFT PIVOT 10 DEGREES STOP BEARING . CR ;

: S RIGHT PIVOT 10 DEGREES STOP BEARING . CR ;

