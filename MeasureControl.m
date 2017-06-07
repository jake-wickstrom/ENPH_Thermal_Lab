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
        filename = ['C:\CodeRepository\ENPH_Thermal_Lab\Al-rod_SW_20s_period' DateString '.csv'];
        csvwrite(filename,volts);
    end
end