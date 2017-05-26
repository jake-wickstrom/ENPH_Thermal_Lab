clear
a = arduino();

volts = zeros([6 200]);
calibrationData = zeros([6 200])

%% Temperature Calibration

uiwait(msgbox('Ready to calibrate. Place all temperature sensors together and press OK','Calibrating','modal'))
h = msgbox('Calibrating... Please do not touch sensors.');
child = get(h,'Children');
delete(child(1))

for i = 1:200
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

delete(h)

figure

for i = 1:200
    volts(1,i) = readVoltage(a,'A0');
    volts(2,i) = readVoltage(a,'A1');
    volts(3,i) = readVoltage(a,'A2');
    volts(4,i) = readVoltage(a,'A3');
    volts(5,i) = readVoltage(a,'A4');
    volts(6,i) = readVoltage(a,'A5');
    
    plot(volts(1,:).*scaleFactor(1))
    hold;
    plot(volts(2,:).*scaleFactor(2))
    plot(volts(3,:).*scaleFactor(3))
    plot(volts(4,:).*scaleFactor(4))
    plot(volts(5,:).*scaleFactor(5))
    plot(volts(6,:).*scaleFactor(6))
    hold;
    pause(.05);
end

volts_avg = zeros([6 1]);

for i=1:6
    volts_avg(i) = mean(volts(i));
end

