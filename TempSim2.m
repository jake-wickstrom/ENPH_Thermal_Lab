function [ Temp , time_array] = TempSim2( Power , time, frequency )
%{Pass this function a Power (in Watts) and time and the function will simulate
%}
length = 0.3; %Length of rod
k = 205; %Conductivity - should be 205
c = 921; %Heat capacity - should be 921
p = 2700; %density - should be 2700
diameter = .0224;
r = diameter/2 ; %Radius
k_c = 6.1; %should be 5
sigma = 5.67*(10^-8); %Stefan-Boltzman constant
em = .25; %Emmisivity

delta_x = 0.01; %Distance step
N = length / delta_x; %Total Intervals
delta_t = .5; %Time step
T_amb = 20; %Ambient Temperature
T_init = 30; %Initial Temperature

T_coeff = delta_t/(c * p * pi * (r^2) * delta_x);

x = linspace(0,length,((length/delta_x))); %Distance vector

%Temp = zeros([time*2 ((length/delta_x))]); %Temperature vector
Temp_change = zeros([1 ((length/delta_x))]); %Temperature change vector
Temp(1,:) = linspace(T_init , T_init , N);

P = Power;
flag = false;

%If Frequency is 0 no modulation, set flag
if (frequency == 0)
        flag = true;
end
    
time_array(1) = 0;
i=1;

while time_array(end) < time
    i = i + 1;
    time_array(i) = time_array(i-1) + delta_t;
    %If power is being modulated, check if power on or off
    if ~flag
        if (mod(floor(time_array(i)/frequency)+1,2)== 0)
        P = 0;
        
        elseif (mod(floor(time_array(i)/frequency)+1,1)== 0)
        P = Power;
        end
    end
    
    %Mid points
    Temp_change(2:N-1) = (k*delta_t/(c*p)).*((Temp(i-1,1:N-2)-2*Temp(i-1,2:N-1)+Temp(i-1,3:N))/(delta_x^2));
        
    %End points
    Temp_change(1) = Temp_change(1) +((-k/(c*p*(delta_x^2)))*(Temp(i-1,1) - Temp(i-1,2)))*(delta_t); %Transfer to next slice, 1 - 2
    
    %Gain from power source
    Temp_change(1) = Temp_change(1) +((T_coeff)*P); 
    
    %Transfer from slice before
    Temp_change(N) = (((k/(c*p*(delta_x^2)))*(Temp(i-1,N-1) - Temp(i-1,N))))*(delta_t); 
    
    %Loses due to radiation and convection
    pout_convection = (2*pi*r*delta_x).*(k_c.*(Temp(i-1,:) - T_amb));
    
    pout_radiation = (2*pi*r*delta_x) .* em .*(sigma.*  ((Temp(i-1,:)+273).^4-(T_amb+273).^4));
    
    Temp_change = Temp_change - ((T_coeff)*(pout_convection + pout_radiation)); %Convective and radiative loss
     
    Temp(i,:) = Temp_change + Temp(i-1,:);
    
%      if mod(i,100)==0
%         plot(x , Temp(i,:));
%      end
    
end

end