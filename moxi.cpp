


$PROB
# Wicha et al. 2015
- Moxifloxacin PK in diabetic foot infection
- https://www.ncbi.nlm.nih.gov/pubmed/25600294

$PARAM WGT = 70, IBW = 70, fu = 0.6

$PKMODEL cmt="CENT PERIPH"

$MAIN
double TVCL  = THETA1;
double ASCCL = TVCL*pow(IBW/70,0.75);
double CL    = ASCCL*exp(ETA(1));

double TVV1  = THETA2;
double ASCV1 = TVV1*WGT/70.0;
double V1    = ASCV1*exp(ETA(2));

double Q = THETA3;

double TVV2  = THETA4;
double ASCV2 = TVV2*WGT/70.0;
double V2    = ASCV2;

$TABLE
capture IPRED = CENT/V1;
double  DV = IPRED+IPRED*EPS(1)+EPS(2);

capture fIPRED = fu*IPRED;
capture fDV = fu*DV;

$CAPTURE DV

$THETA
1.21E+01
6.81E+01
2.03E+01
4.46E+01

$OMEGA
6.33E-02
7.25E-02

$SIGMA
3.40E-02
4.65E-03

$SET delta=0.1, end=24*3
