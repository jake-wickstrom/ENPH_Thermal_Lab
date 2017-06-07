function [ Temp ] = TempSim( Power , time, frequency )
%{Pass this function a Power (in Watts) and time and the function will simulate
%}
l = 0.3; %Length of rod
k = 205; %Conductivity
c = 900; %Heat capacity
p = 2700; %density
r = 0.01 ; %Radius
k_c = 5; 
sigma = 5.67*(10^-8); %Stefan-Boltzman constant

delta_x = 0.01; %Distance step
N = l / delta_x; %Total Intervals
delta_t = 0.1; %Time step
%T_heat = 50; %Heating Temperature
T_amb = 20; %Ambient Temperature

T_coeff = delta_t/(c * p * pi * (r^2) * delta_x);

x = linspace(0,l,((l/delta_x))); %Distance vector

Temp = zeros([time ((l/delta_x))]); %Temperature vector
Temp_change = zeros([1 ((l/delta_x))]); %Temperature change vector
Temp =Temp +T_amb;

 for i = 2:time*10
    if frequency == 0
        P = Power;
    else if mod(floor(i/frequency)+1,2)== 0
        P = 0;
    else
        P = Power;
    end

    %Mid points
    Temp_change(2:N-1) = (k*delta_t/(c*p))*((Temp(i-1,1:N-2)-2*Temp(i-1,2:N-1)+Temp(i-1,3:N))/(delta_x^2));
        
    %End points
    Temp_change(1) = Temp_change(1) +((-k/(c*p*(delta_x^2)))*(Temp(i-1,1) - Temp(i-1,2))*(delta_t)); %Transfer to next slice, 1 - 2
    Temp_change(1) = Temp_change(1) +((T_coeff)*P); %Gain from power source
    
    Temp_change(30) = (((k/(c*p*(delta_x^2)))*(Temp(i-1,29) - Temp(i-1,30))*(delta_t))); %Transfer from slice before
    
    Temp_change = Temp_change - (T_coeff)*(2*pi*r*delta_x)*(k_c*(Temp(i-1,:)-T_amb)+(sigma*((Temp(i-1,:)+273).^4-(T_amb+273)^4))); %Convective and radiative loss
     
    Temp(i,:) = Temp_change + Temp(i-1,:);

    end
end