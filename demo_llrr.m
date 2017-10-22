clear all 
clc

qZ = [0 0 0];
qL = [pi/8 pi/4 pi/8];
qR = [-pi/8 pi/8 pi/8];

t = [0:0.05:2]';
qTL = jtraj(qZ, qL, t);
qTR = jtraj(qZ, qR, t);


L1 = 0.5; L2 = 0.35; L3 = 0.15;
s = 'Rx(q1).Tz(L1).Rx(q2).Tz(L2).Rx(q3).Ty(L3)';
dh = DHFactor(s);
clc

legL = eval(dh.command('legLeft'))
legR = SerialLink(legL, 'name', 'legRight', 'base', legL.base*transl(0, 0, 0.2))

% 
% clc
% legL
% legR
% 
clf
set(gca, 'Zdir', 'reverse');
view(134, 48);
axis equal;
axis([-0.6 0.6 -0.6 0.6 0 1]);
hold on;
k = 1;
while 1
    legL.plot(gait(qTL, k, 0, 0), 'noshadow');
    legR.plot(gait(qTR, k, 0, 0), 'noshadow', 'cylinder', [200 0 0]);
    k = k+1;
end

