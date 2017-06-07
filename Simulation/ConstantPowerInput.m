%% Assign Constants
BOLTZ = 5.67e-8;
sensor_loc = [0.03 0.076 0.114 0.190 0.2755]; % (m)

%% Import Simulation Data
uiwait(msgbox('Select a file to import data'))
[filename,pathname] = uigetfile('*.csv');
data_record = csvread([pathname,filename]);
data_record = array2table(data_record,'VariableNames',{'Sensor_1' 'Sensor_2' 'Sensor_3' 'Sensor_4' 'Sensor_5' 'Ambient' 'Time'});

%% Assign Simulation Parameters
rodlength = .3;
radius = .01;
initial_temp = 50 + 273; % °C
ambient_temp = 20 + 273;  % °K
input_power = 10;  % Watts
rod_temp = 20 + 273;     % °K 
convection_coeff = 5; % convection coefficient
emissivity = 1;

area = pi*radius^2;     % m^2
density = 2700;
heat_cap = 900;
K = 205;

time = 0;

slice = .03;
step  = 2;

%% Simulation Setup
rod_index = linspace(0,rodlength,rodlength/slice + 1);
rod = ones(1,rodlength/slice + 1)*rod_temp;
rod(1) = initial_temp;

h = figure;
plot(rod_index,rod)
time(1) = 0;
tracker(1,:) = rod;
i = 2;

%% Simulation 
while (time <= max(table2array(data_record(:,'Time'))))
    time(i) = time(i-1) + step;
    
    %calculate power losses at all points along the bar
    power = -2*pi*radius*slice*convection_coeff*(rod - ambient_temp) - 2*pi*radius*slice*emissivity*BOLTZ*(rod.^4-ambient_temp^4);
    power(1) = power(1) - area*convection_coeff*(rod(1) - ambient_temp) + input_power;
    power(end) = power(end) - area*convection_coeff*(rod(end) - ambient_temp);
    
    %calculate tempurate difference due to power losses
    Tloss = power/(heat_cap*density*area*slice);
    
    %update temperature along bar
    rod(2:end-1) = rod(2:end-1) + step*(K/(heat_cap*density))*(rod(1:end-2)-2*rod(2:end-1)+rod(3:end))/slice^2 + step*Tloss(2:end-1);
    rod(1) = rod(1) + step*(K/(heat_cap*density))*(rod(2)-rod(1))/slice^2 + step*Tloss(1);
    rod(end) = rod(end) + step*(K/(heat_cap*density))*(rod(end-1)-rod(end))/slice^2 + step*Tloss(end);
    
    tracker(i,:) = rod;
    i = i+1;
end

%% Plot simulation results against real data

t  = data_record{:,'Time'};
s1 = data_record{:,'Sensor_1'};
s2 = data_record{:,'Sensor_2'};
s3 = data_record{:,'Sensor_3'};
s4 = data_record{:,'Sensor_4'};
s5 = data_record{:,'Sensor_5'};
s6 = data_record{:,'Ambient'};
plot(t,s1,t,s2,t,s3,t,s4,t,s5,t,s6,time,(tracker(:,2)-273)./100)
legend('Sensor 1','Sensor 2','Sensor 3','Sensor 4','Sensor 5','Ambient','Simulation')
%axis([0 0.3 20 150])
%pause(5)

%add graph labels
title("Tempurature of Aluminum Rod with 10W Input")
xlabel("Time (s)")
ylabel("Temperature (°C)")

drawnow

fprintf("%f %f\r",mean(rod),sum(power))
    
fprintf("DONE!")