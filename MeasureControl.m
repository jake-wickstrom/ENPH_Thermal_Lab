l = 0.3; %Length of rod
k = 205; %Conductivity
c = 900; %Heat capacity
p = 2700; %density
r = 0.01 ; %Radius
k_c = 5; 
sigma = 5.67*(10^-8); %Stefan-Boltzman constant
P = 9.6; %Power

delta_x = 0.01; %Distance step
N = l / delta_x; %Total Intervals
delta_t = 0.1; %Time step
%T_heat = 50; %Heating Temperature
T_amb = 20; %Ambient Temperature

T_coeff = delta_t/(c * p * pi * (r^2) * delta_x);

time = 36000;

x = linspace(0,l,((l/delta_x))); %Distance vector
x_mid = x+(delta_x/2); %Midpoint vector

Temp = zeros([time ((l/delta_x))]); %Temperature vector
Temp_change = zeros([1 ((l/delta_x))]); %Temperature change vector
Temp =Temp +T_amb;

 for i = 2:time
     
    if mod(floor(i/3000)+1,2)== 0
        P = 0;
    else
        P = 9.6;
    end

    %Mid points
    Temp_change(2:N-1) = (k*delta_t/(c*p))*((Temp(i-1,1:N-2)-2*Temp(i-1,2:N-1)+Temp(i-1,3:N))/(delta_x^2));
        
    %End points
    Temp_change(1) = Temp_change(1) +((-k/(c*p*(delta_x^2)))*(Temp(i-1,1) - Temp(i-1,2))*(delta_t)); %Transfer to next slice, 1 - 2
    Temp_change(1) = Temp_change(1) +((T_coeff)*P); %Gain from power source
    
    Temp_change(30) = (((k/(c*p*(delta_x^2)))*(Temp(i-1,29) - Temp(i-1,30))*(delta_t))); %Transfer from slice before
    
    Temp_change = Temp_change - (T_coeff)*(2*pi*r*delta_x)*(k_c*(Temp(i-1,:)-T_amb)+(sigma*((Temp(i-1,:)+273).^4-(T_amb+273)^4))); %Convective and radiative loss
     
    Temp(i,:) = Temp_change + Temp(i-1,:);

    %Plot settings
        
    %pause(.01);
 end

figure
hold on
plot(Temp(:,3));
plot(Temp(:,8));
plot(Temp(:,11));
plot(Temp(:,19));
plot(Temp(:,28));

figure
plot(Temp(time,:));
title('Temperature vs Distance');


%% Data Loop 
clear
a = arduino();

time = 18000;
scaleFactor = [1.01984713,0.9782054819,0.9905064832,0.9990749907,1.023384885,0.9889810292]; %experimentally determined scaling coefficients
x = [0.03 0.076 0.114 0.190 0.2755];

volts = zeros([time 7]);

tic

c0 = clock;
t0 = 3600*c0(4) + 60*c0(5) + c0(6); % Time in minutes
ts = datetime('now');
DateString = datestr(ts,30);

for i = 1:time
    %record raw voltage values from sensors
    volts(i,1) = readVoltage(a,'A0');%/scaleFactor(1);
    volts(i,2) = readVoltage(a,'A1');%/scaleFactor(2);
    volts(i,3) = readVoltage(a,'A2');%/scaleFactor(3);
    volts(i,4) = readVoltage(a,'A3');%/scaleFactor(4);
    volts(i,5) = readVoltage(a,'A4');%/scaleFactor(5);
    volts(i,6) = readVoltage(a,'A5');%/scaleFactor(6);
    volts(i,7) = toc;
    
    %Code to monitor sensors to make sure there is no sensor failure
    clf('reset')
    plot(x(:) , volts(i, 1:5)*100/scaleFactor(1:5), '*');
    ylim([0 80]);
 
    pause(.1);
    
    if mod(i,10) == 0
        filename = ['C:\Users\Cam\workspace\ENPH_Thermal_Lab\Al-rod_SW_20s_period' DateString '.csv'];
        csvwrite(filename,volts);
    end
end

