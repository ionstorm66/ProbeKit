%
O9104(ProbeKit Web Probing)
(---Web Probing: R1+1. to R1+3. ---)
(R1= X use 1., Y use 2., X&Y use 3.)
(R2=Fixture Offset)
(R3= X Web Measurement to Probe)
(R4= Y Web Measurement to Probe)
(Usage: Jog to center, R1+1. R2+4. R3=3. M98 P9104)
(Result: R1=X Center, R2=Y Center, R3= X Web Length, R4= Y Web Length)
(Results only set for all if R1=3.)

(---ProbeKit User Variables---)
#V10 = 1 'Tool Number for tool height offset
#V11 = D(V10) 'Probe diameter from the tool table D offset
#V12 = 20.0 'Probe feedrate
#V15 = 0.75 'Z Drop Height
#V16 = 1.5 'Probe inward distance (reserved)
#V17 = 1.0 'Overtravel distance each side
#V25 = 75.0 'Rapid travel feedrate
#V33 = 1 'Probe fault check; set to 0 if this control does not support I(n)

(---Setup---)
M64 (Switch to Spindle Probe)
M66 (Turn On Probe)
M19 (Orient spindle)
G80 (Cancel fixed cycles)
G53 (Machine Coordinates)
G90 (Absolute Mode)
G17 (XY Plane Selection)
#V30 = R1
#V2 = R2 'Set Input Fixture Offset
#R5 = V25 'Travel feedrate
#V20 = AX 'Start Points
#V21 = AY
#V22 = AZ

(---TEST Probe Input Before Moving---)
#IF (V33 = 0) THEN GOTO:PROBEOKAY
#:CHECKPROBE
#V32 = 0 'Reset to known state
#V32 = I(7) 'Probe error input; see README for legacy controls
#IF (V32 = 0) THEN GOTO:PROBEOKAY
#PRINT "***********************************"
#PRINT "PROBE ERROR OR NOT TURNED ON: "
#PRINT "***********************************"
#PRINT "Press Enter to Retry Probe or No to Exit - Yes=ENTER, NO=1"
#INPUT V19
#IF (V19 = 0) THEN GOTO:CHECKPROBE
#GOTO:FAULT
#:PROBEOKAY
#V32 = 0 'Zero after use
#V19 = 0
(---END Probe Input Test---)

(Logical Variables)
#IF (R1 < 1) THEN GOTO:FAULT
#IF (R1 > 3) THEN GOTO:FAULT
#IF (R1 = 1) THEN GOTO:XWEBPROBE
#IF (R1 = 2) THEN GOTO:YWEBPROBE
#IF (R1 = 3) THEN GOTO:XYWEBPROBE
#GOTO:FAULT

#:XWEBPROBE
#:XYWEBPROBE
(Part 1)
#R6 = V20 - ((R3/2) + V17) 'Start Point
#R7 = AY
#R8 = AZ
#R5 = V25 'Travel feedrate
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Move to Start Point)
#WAIT
#R5 = V12 'Probe feedrate
#R8 = AZ - V15 'Drop Probe
G1 G31 Z+R8. F+R5. (Probe Down)
#WAIT
#R6 = V20
#R7 = AY
#R8 = AZ
L9101 R1+1. X+R6. Y+R7. Z+R8. P1 (Probe Point 1)
#WAIT
#R5 = V25 'Travel feedrate
#R8 = AZ + V15 'Raise Probe
G1 G31 Z+R8. F+R5. (Probe Up)
#WAIT
#R6 = V20
#R7 = V21
#R8 = V22
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Return to Start Point)
#WAIT
(Part 2)
#R6 = V20 + ((R3/2) + V17) 'Start Point
#R7 = AY
#R8 = AZ
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Move to Start Point)
#WAIT
#R5 = V12 'Probe feedrate
#R8 = AZ - V15 'Drop Probe
G1 G31 Z+R8. F+R5. (Probe Down)
#WAIT
#R6 = V20
#R7 = AY
#R8 = AZ
L9101 R1+1. X+R6. Y+R7. Z+R8. P2 (Probe Point 2)
#WAIT
#R5 = V25 'Travel feedrate
#R8 = AZ + V15 'Raise Probe
G1 G31 Z+R8. F+R5. (Probe Up)
#WAIT
#FX(V2) = (PX2 + PX1) / 2 'X Center; corrected midpoint
#R3 = ABS(PX2 - PX1) - V11 'Measured X web length
#WAIT
#R6 = V20
#R7 = V21
#R8 = V22
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Return to Start Point)
#WAIT
#PRINT " "
#PRINT " "
#PRINT "Probe P1: ", PX1
#PRINT "Probe P2: ", PX2
#PRINT "Fixture Offset for X: ", FX(V2)
#PRINT "X Web Length: ", R3
#PRINT "PRESS ENTER TO CONTINUE"
#INPUT V99
#IF (V30 = 1) THEN GOTO:END

#:YWEBPROBE
(Part 1)
#R6 = AX
#R7 = V21 - ((R4/2) + V17) 'Start Point
#R8 = AZ
#R5 = V25 'Travel feedrate
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Move to Start Point)
#WAIT
#R5 = V12 'Probe feedrate
#R8 = AZ - V15 'Drop Probe
G1 G31 Z+R8. F+R5. (Probe Down)
#WAIT
#R6 = AX
#R7 = V21
#R8 = AZ
L9101 R1+1. X+R6. Y+R7. Z+R8. P1 (Probe Point 1)
#WAIT
#R5 = V25 'Travel feedrate
#R8 = AZ + V15 'Raise Probe
G1 G31 Z+R8. F+R5. (Probe Up)
#WAIT
#R6 = V20
#R7 = V21
#R8 = V22
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Return to Start Point)
#WAIT
(Part 2)
#R6 = AX
#R7 = V21 + ((R4/2) + V17) 'Start Point
#R8 = AZ
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Move to Start Point)
#WAIT
#R5 = V12 'Probe feedrate
#R8 = AZ - V15 'Drop Probe
G1 G31 Z+R8. F+R5. (Probe Down)
#WAIT
#R6 = AX
#R7 = V21
#R8 = AZ
L9101 R1+1. X+R6. Y+R7. Z+R8. P2 (Probe Point 2)
#WAIT
#R5 = V25 'Travel feedrate
#R8 = AZ + V15 'Raise Probe
G1 G31 Z+R8. F+R5. (Probe Up)
#WAIT
#FY(V2) = (PY2 + PY1) / 2 'Y Center; corrected midpoint
#R4 = ABS(PY2 - PY1) - V11 'Measured Y web length
#WAIT
#R6 = V20
#R7 = V21
#R8 = V22
G1 G31 X+R6. Y+R7. Z+R8. F+R5. (Return to Start Point)
#WAIT
#PRINT " "
#PRINT " "
#PRINT "Probe P1: ", PY1
#PRINT "Probe P2: ", PY2
#PRINT "Fixture Offset for Y: ", FY(V2)
#PRINT "Y Web Length: ", R4
#PRINT "PRESS ENTER TO CONTINUE"
#INPUT V99
#GOTO:END

#:FAULT
#PRINT " "
#PRINT " "
#PRINT " "
#PRINT "ProbeKit Fault, Input Faulty"
#GOTO:END

#:END
#WAIT
#R1 = FX(V2) 'X Center
#R2 = FY(V2) 'Y Center
(R3 and R4 were calculated beside their probe points so later probing cannot overwrite them)
M67 (Turn Off Probe)
M99
%
