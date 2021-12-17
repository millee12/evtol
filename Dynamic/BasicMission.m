function [FlightOutput,L,n] = BasicMission(AeroProps, MissionProps, AtmosProps)
% set variables
%aero
MTOM = AeroProps.MTOM;
paxmax = AeroProps.paxmax;
Range = AeroProps.Range;
f = AeroProps.f;
cd0 = AeroProps.cd0;
FM = AeroProps.FM;
LD = AeroProps.LD;
K = AeroProps.K;
we_wmax = AeroProps.we_wmax;
area_load = AeroProps.area_load;
disk_load = AeroProps.disk_load;
Nhov = AeroProps.Nhov;
Ncli = AeroProps.Ncli;
Ncru = AeroProps.Ncru;
rotortype = AeroProps.rotortype;
%mission
VC = MissionProps.VC;
H0 = MissionProps.H0;
tup = MissionProps.tup;
Vv = MissionProps.Vv;
Hc = MissionProps.Hc;
VD = MissionProps.VD;
tdn = MissionProps.tdn;
VDVL = MissionProps.VDVL;
Hr = MissionProps.Hr;
tr = MissionProps.tr;
VCr = MissionProps.VCr;
% atmos
TGL = AtmosProps.TGL;
PGL = AtmosProps.PGL;
DGL = AtmosProps.DGL;
%===========================

%% 
TakeOffOutput = ...
    TakeOff(f, FM, disk_load,Nhov,VC, H0,MTOM,...
        TGL, PGL, DGL, rotortype);    
%%
TransitionUpOutput = ...
    TransUp(f, cd0, FM, K,area_load, disk_load,...
        Nhov, Ncli,H0, tup, Vv, MTOM,TGL, PGL, DGL);
%%    
ClimbOutput = ...
    AeroClimb(cd0, K, area_load, Ncli,H0, Vv, Hc,...
        MTOM, TGL, PGL, DGL);
%%    
CruiseOutput = ...
    Cruise(cd0, K, area_load, Ncru, VCr, LD, ...
        Hc, Range, MTOM, TGL, PGL, DGL);
%%    
DescentOutput = ...
    Descent(cd0, K, area_load, Ncli, H0, VD, Hc, ...
        MTOM, TGL, PGL, DGL);
%%
TransitionDownOutput = ...
    TransDown(f, cd0, FM, K, area_load, disk_load,...
        Ncli, Nhov, H0, tdn, VD, MTOM, TGL, PGL, DGL);
%%
LandingOutput = ...
    Land(f, FM, disk_load,Nhov, VDVL, H0, MTOM,...
        TGL, PGL, DGL, rotortype);    
%%

x = {TakeOffOutput, TransitionUpOutput, ...
    ClimbOutput, CruiseOutput, DescentOutput,...
    TransitionDownOutput, LandingOutput};
[FlightOutput,L,n] = FlyMission(x);
end