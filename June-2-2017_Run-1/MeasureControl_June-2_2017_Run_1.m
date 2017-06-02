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

time = 1800;


x = linspace(0,l,((l/delta_x))); %Distance vector
x_mid = x+(delta_x/2); %Midpoint vector

Temp = zeros([time ((l/delta_x))]); %Temperature vector
Temp_change = zeros([1 ((l/delta_x))]); %Temperature change vector
Temp =Temp +T_amb;

 for i = 2:time
    %Mid points
    Temp_change(i,2:N-1) = (k*delta_t/(c*p))*((Temp(1:N-2)-2*Temp(2:N-1)+Temp(3:N))/(delta_x^2));
        
    %End points
    Temp_change(i,1) = Temp_change(1) +((-k/(c*p*(delta_x^2)))*(Temp(1) - Temp(2))*(delta_t)); %Transfer to next slice, 1 - 2
    Temp_change(i,1) = Temp_change(1) +((T_coeff)*P); %Gain from power source
    
    Temp_change(i,30) = (((k/(c*p*(delta_x^2)))*(Temp(29) - Temp(30))*(delta_t))); %Transfer from slice before
    
    Temp_change(i) = Temp_change(i) - (T_coeff)*(2*pi*r*delta_x)*(k_c*(Temp-T_amb)+(sigma*((Temp+273).^4-(T_amb+273)^4))); %Convective and radiative loss
     
    Temp(i) = Temp_change(i) + Temp(i-1);

    
    %Plot settings
    
    
    %pause(.01);
end

plot(1:time,Temp(:, 10));
    title('Temperature vs Distance');


%% Data Loop 
clear
a = arduino();

time = 18000;
scaleFactor = [1.01984713,0.9782054819,0.9905064832,0.9990749907,1.023384885,0.9889810292]; %experimentally determined scaling coefficients
x = [0.03 0.076 0.114 0.190 0.2755];

volts = zeros([6 time]);



for i = 1:time
    %record voltage values from sensors
    volts(1,i) = readVoltage(a,'A0');%/scaleFactor(1);
    volts(2,i) = readVoltage(a,'A1');%/scaleFactor(2);
    volts(3,i) = readVoltage(a,'A2');%/scaleFactor(3);
    volts(4,i) = readVoltage(a,'A3');%/scaleFactor(4);
    volts(5,i) = readVoltage(a,'A4');%/scaleFactor(5);
    volts(6,i) = readVoltage(a,'A5');%/scaleFactor(6);
    
    clf('reset')
    plot(x(:) , volts(1:5,i)*100, '*');
    ylim([0 80]);
    
    if mod(i,10) == 0
%     plot(i,volts(1,i)*scaleFactor(1));
%     plot(i,volts(2,i)*scaleFactor(2));
%     plot(i,volts(3,i)*scaleFactor(3));
%     plot(i,volts(4,i)*scaleFactor(4));
%     plot(i,volts(5,i)*scaleFactor(5));
    
    end
    pause(.1);
    
    if mod(i,300) == 0
        c0 = clock;
        t0 = 3600*c0(4) + 60*c0(5) + c0(6); % Time in minutes
        ts = datetime('now');
        DateString = datestr(ts,30);
        filename = ['C:\Users\Cam\workspace\ENPH_Thermal_Lab\Al-rod_SW_20s_period' DateString '.csv'];
        csvwrite(filename,volts);
    end
end

