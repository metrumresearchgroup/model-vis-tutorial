$PROB
# Wicha et all. 2015
- Moxifloxacin PK in diabetic foot infection
- https://www.ncbi.nlm.nih.gov/pubmed/25600294

$PARAM WGT = 70, IBW = 70, fu = 0.6

$CMT CENT PERIPH AUC

$GLOBAL
double AUCt[4];

$MAIN
double TVCL = THETA1;
double ASCCL = TVCL * pow(IBW/70,0.75);
double CL = ASCCL * exp(ETA(1));

double TVV1 = THETA2;
double ASCV1 = TVV1 * (WGT/70);
double V1 = ASCV1 * exp(ETA(2));

double Q = THETA3;

double TVV2 = THETA4;
double ASCV2 = TVV2 * (WGT/70);
double V2 = ASCV2;


$ODE
dxdt_CENT   = -(CL/V1)*CENT + (Q/V2)*PERIPH - (Q/V1)*CENT;
dxdt_PERIPH =               - (Q/V2)*PERIPH + (Q/V1)*CENT;
dxdt_AUC    =  CENT/V1;

$TABLE
capture IPRED = CENT/V1;
double  DV = IPRED+IPRED*EPS(1)+EPS(2);

if(TIME==0)  AUCt[0] = AUC;
if(TIME==24) AUCt[1] = AUC;
if(TIME==48) AUCt[2] = AUC;
if(TIME==72) AUCt[3] = AUC;

capture  AUC24 = (TIME >= 24) ? AUCt[1] - AUCt[0] : 0;
capture  AUC72 = (TIME >= 72) ? AUCt[3] - AUCt[2] : 0;
capture fAUC24 = fu*AUC24;
capture fAUC72 = fu*AUC72;

$CAPTURE DV WGT IBW

$THETA 1.21E+01  6.81E+01  2.03E+01  4.46E+01

$OMEGA @block
6.33E-02
0.00E+00  7.25E-02

$SIGMA 3.40E-02 4.65E-03


$SET delta=2, end=24*5, req="AUC"
