;; 1. Based on: run021
;; 2. Description: PK of moxifloxacin in patients with diabetic foot infections
;; x1. Author: Sebastian G. Wicha, Freie Universitaet Berlin, Germany
;; 3. Label:
$PROBLEM PK

$INPUT ID TIME DV AMT RATE MDV EVID CMT WGT IBW 

$DATA MOX02_sim.csv ; IGNORE=#

$SUBROUTINES ADVAN3 TRANS4

$PK

TVCL  = THETA(1) 
ASCCL = TVCL * (IBW/70)**0.75
CL    = ASCCL * EXP(ETA(1))

TVV1  = THETA(2) 
ASCV1 = TVV1 * (WGT/70)**1
V1    = ASCV1 * EXP(ETA(2))

Q  = THETA(3) 

TVV2 = THETA(4)
ASCV2 = TVV2 * (WGT/70)**1
V2    = ASCV2 

S1 = V1

$ERROR
IPRED = F
DEL   = 0
IF (IPRED.EQ.0) DEL=0.0001
W     = F
Y     = F+F*EPS(1)+EPS(2)
IRES  = DV-IPRED
IWRES = IRES/(W+DEL)

$THETA
1.21E+01 ; CL
6.81E+01 ; V1
2.03E+01 ; Q
4.46E+01 ; V2

$OMEGA
6.33E-02        ; CL
7.25E-02        ; V1

$SIGMA
3.40E-02 ; Prop 
4.65E-03 ; Add


$EST METHOD=1 INTER MAXEVAL=0 NOABORT SIG=3 PRINT=1 POSTHOC
;$COV

