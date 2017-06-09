%% Assign Constants
BOLTZ = 5.67e-8;
sensor_loc = [0.03 0.076 0.114 0.190 0.2755]; % (m)
scaleFactor = [100/1.01984713,100/0.9782054819,100/0.9905064832,100/0.9990749907,100/1.023384885,100/0.9889810292]; %experimentally determined scaling coefficients

%% Import Simulation Data
uiwait(msgbox('Select a file to import data'))
[filename,pathname] = uigetfile('*.csv');
data_record = csvread([pathname,filename]);
data_record = array2table(data_record,'VariableNames',{'Sensor_1' 'Sensor_2' 'Sensor_3' 'Sensor_4' 'Sensor_5' 'Ambient' 'Time'});
%% Plot simulation results against real data

%Create simulation data 
[Temp , time_array] = TempSim2(6.5 , floor(max(t)) , 610);

figure
hold on

t  = data_record{:,'Time'};
s1 = data_record{:,'Sensor_1'}*scaleFactor(1);
s2 = data_record{:,'Sensor_2'}*scaleFactor(2);
s3 = data_record{:,'Sensor_3'}*scaleFactor(3);
s4 = data_record{:,'Sensor_4'}*scaleFactor(4);
s5 = data_record{:,'Sensor_5'}*scaleFactor(5);
s6 = data_record{:,'Ambient'}*100;

%Plot data
plot(t,s1,t,s2,t,s3,t,s4,t,s5,t,s6)

%Plot Simulation
plot(time_array,Temp(:,3),time_array,Temp(:,8),time_array,Temp(:,11),time_array,Temp(:,19),time_array,Temp(:,28));

%legend('Sensor 1','Sensor 2','Sensor 3','Sensor 4','Sensor 5','Ambient','Sensor 1-SIM','Sensor 2-SIM','Sensor 3-SIM','Sensor 4-SIM','Sensor 5-SIM')

%add graph labels
title('Tempurature of Aluminum Rod with 10W Input')
xlabel('Time (s)')
ylabel('Temperature (°C)')

drawnow

fprintf('%f %f\r",mean(rod),sum(power)')
    
fprintf('DONE!')