clear
a = arduino();

%CONSTANTS
CALIBRATION_LENGTH = 500;

Measurement_Length = 5000;

volts = zeros([6 2000]);
calibrationData = zeros([6 Measurement_Length]);

%% Temperature Calibration

%Calibration begin message. Waits until ok is pressed
uiwait(msgbox('Ready to calibrate. Place all temperature sensors together and press OK','Calibrating','modal'))

%Calibration warning message
h = msgbox('Calibrating... Please do not touch sensors.');
%Gets children of UI element and delete the ok button so warning stays on
%screen during 
child = get(h,'Children');
delete(child(1))

%% Calibration loop
for i = 1:CALIBRATION_LENGTH
    calibrationData(1,i) = readVoltage(a,'A0');
    calibrationData(2,i) = readVoltage(a,'A1');
    calibrationData(3,i) = readVoltage(a,'A2');
    calibrationData(4,i) = readVoltage(a,'A3');
    calibrationData(5,i) = readVoltage(a,'A4');
    calibrationData(6,i) = readVoltage(a,'A5');
    pause(0.01)
end

meanVoltage = mean2(calibrationData);

scaleFactor = mean(calibrationData,2)./meanVoltage;

%create figure to dipslay plots
f = figure;

%% Data Loop 
for i = 1:Measurement_Length
    %record voltage values from sensors
    volts(1,i) = readVoltage(a,'A0')/scaleFactor(1);
    volts(2,i) = readVoltage(a,'A1')/scaleFactor(2);
    volts(3,i) = readVoltage(a,'A2')/scaleFactor(3);
    volts(4,i) = readVoltage(a,'A3')/scaleFactor(4);
    volts(5,i) = readVoltage(a,'A4')/scaleFactor(5);
    volts(6,i) = readVoltage(a,'A5')/scaleFactor(6);
    
    %display voltage values on plot
    plot(volts(1,:))
    hold;
    plot(volts(2,:))
    plot(volts(3,:))
    plot(volts(4,:))
    plot(volts(5,:))
    plot(volts(6,:))
    legend('1','2','3','4','5','6')
    hold;
    pause(.05);
    
    %if the figure has been closed, break out of the temperature
    %measurement loop
    if not(ishandle(f))
        break
    end  
end
