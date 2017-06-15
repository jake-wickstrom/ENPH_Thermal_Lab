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

t  = data_record{:,'Time'};

p = 6.3; %Power - Watts
c = 920; %Heat capacity - should be 921
k = 140; %Conductivity - should be 205
em = 0.95; %emmisivity
k_c = 7.5; 


%Create simulation data 
[Temp , time_array] = TempSim2(p , floor(max(t)) , 300, c, k, em, k_c);

figure('Position', [05, 05, 1049, 895])
hold on

s1 = data_record{:,'Sensor_1'}*scaleFactor(1);
s2 = data_record{:,'Sensor_2'}*scaleFactor(2);
s3 = data_record{:,'Sensor_3'}*scaleFactor(3);
s4 = data_record{:,'Sensor_4'}*scaleFactor(4);
s5 = data_record{:,'Sensor_5'}*scaleFactor(5);
s6 = data_record{:,'Ambient'}*100;

%Plot data
plot(t,s1,'r',t,s2,'b',t,s3,'g',t,s4,'m' ,t,s5, 'y', t,s6)

%Plot Simulation
plot(time_array,Temp(:,3),'r',time_array,Temp(:,8),'b',time_array,Temp(:,11),'g',time_array,Temp(:,18),'m',time_array,Temp(:,27),'y')

%legend('Sensor 1','Sensor 2','Sensor 3','Sensor 4','Sensor 5','Ambient','Sensor 1-SIM','Sensor 2-SIM','Sensor 3-SIM','Sensor 4-SIM','Sensor 5-SIM')

%add graph labels
title({'Tempurature of Aluminum Rod with ' num2str(p) ' Watts'...
    ' Specific Heat Capacity = ' num2str(c)...
    ' Conductivity = ' num2str(k)...
    ' Emmisivity = ' num2str(em)...
    ' k_c = ' num2str(k_c)...
    })

xlabel('Time (s)')
ylabel('Temperature (°C)')

drawnow

fprintf('%f %f\r",mean(rod),sum(power)')
    
fprintf('DONE!')