clear
a = arduino();

% %CONSTANTS
% CALIBRATION_LENGTH = 300;
volts = zeros([6 2000]);
calibrationData = zeros([6 CALIBRATION_LENGTH]);

% %% Temperature Calibration
% 
% %Calibration begin message. Waits until ok is pressed
uiwait(msgbox('Ready to calibrate. Place all temperature sensors together and press OK','Calibrating','modal'))
% 
% %Calibration warning message
h = msgbox('Calibrating... Please do not touch sensors.');
% %Gets children of UI element and delete the ok button so warning stays on
% %screen during 
child = get(h,'Children');
delete(child(1))

% %% Calibration loop
for i = 1:CALIBRATION_LENGTH
    calibrationData(1,i) = readVoltage(a,'A0');
    calibrationData(2,i) = readVoltage(a,'A1');
    calibrationData(3,i) = readVoltage(a,'A2');
    calibrationData(4,i) = readVoltage(a,'A3');
    calibrationData(5,i) = readVoltage(a,'A4');
    calibrationData(6,i) = readVoltage(a,'A5');
    pause(0.01)
end

meanVoltage = mean2(calibrationData)

scaleFactor = mean(calibrationData,2)./meanVoltage