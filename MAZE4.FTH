( Maze for Robothon                                7-23-93

( This is the maze routine that allowed Whiskers to have the
( fastest time through the maze, 27 secs.  The next fastest was
( 90 secs.  This uses only the instinct level.  Buy using
( behaviors too, we can make him even smarter...

DISABLE

FORGET STUB

: STUB ;

: MAZE

  55 LEFT SPEED         ( follow left wall
  60 RIGHT SPEED        ( you may have to adjust this for your robot

 PVR rF-MASK SET        ( pivot left if both front sensors hit

 13 rRM-TRIGGER SET     ( setup stall instincts
 13 rLM-TRIGGER SET
 255 rSTALL-DELAY SET

 22 TRIGGER-FACTOR      ( setup light sensors
 60 SUM-FACTOR
 CALIBRATE

 BEGIN                  ( always go forward
    2 SECS              ( if we get a motor stall, reverse
    FORWARD             ( direction for 2 secs

 ?TERMINAL UNTIL

;

AUTO-START: MAZE