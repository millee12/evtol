function [whpm,range,packmission,peakp] = betaalia(mile,numPax)
% addpath("../Static/") 

%% Initialize betaalia
C = csv2cell("../Static/betaalia_param.csv");
AeroProps = cell2struct(C(2:end,:)', C(1,:));
%% Initialize betaalia
C = csv2cell("../Static/betaalia_mission.csv");
MissionProps = cell2struct(C(2:end,:)', C(1,:));

% AeroProps           = readtable('betaalia_param.csv');
AeroProps.K         = 1./(4.*AeroProps.cd0.*AeroProps.LD.^2);

%% Global assumptions
mpax                = 100; %kg

%% FOR ANALYSIS
AeroProps.Range  = mile*1.6e3;
AeroProps.MTOM   = AeroProps.MTOM-((AeroProps.paxmax-numPax)*mpax); % kg

%% Atmos initialization
AtmosPropsGood      = atm(1);

%% Initialize mission
% MissionProps        = readtable('betaalia_mission.csv');

%% Run the model
[Mission,~,~]       = BasicMission(AeroProps, MissionProps, AtmosPropsGood);
Mission
% [Reserve,~,~]       = ReserveMission(AeroProps, MissionProps, AtmosPropsGood);

%% Overall performance
whpm        = Mission.EnergykWh(end)*1e3/(Mission.Rangem(end)/1.6e3); %Wh/mi
% whpm_r      = Reserve.EnergykWh(end)*1e3/(Reserve.Rangem(end)/1.6e3); %Wh/mi
range       = Mission.Rangem(end)/1.6e3;
mph         = max(Mission.Airspeedmps)*2.23694; %mi/h
peakp       = Mission.PowerkW(1); %kW
packmission = ((AeroProps.Range./1.6e3).*whpm)./1e3; %kWh
% packreserve = packmission+(Reserve.EnergykWh(end)-Mission.EnergykWh(end));

end