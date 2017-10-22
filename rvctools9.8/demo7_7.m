clear all;
clc;

s = 'Rz(q1).Rx(q2).Ty(L1).Rx(q3).Tz(L2)';
dh = DHFactor(s);
cmd = dh.command('leg');
L1 = 0.1; L2 = 0.1;
leg = eval(cmd);
% leg.plot(transl(leg.fkine([0.2,0,0]))', 'nobase', 'noshadow');
% 翻转Z轴.具体信息可查看help set.
% set(gca, 'Zdir', 'reverse');
% view(137, 48);

% transl(leg.fkine([0.2,0,0]))';
% transl(leg.fkine([0,0.2,0]))';
% transl(leg.fkine([0,0,0.2]))';

xf = 5; xb = -xf; y = 5; zu = 2; zd = 5;
path = [xf,y,zd;xb,y,zd;xb,y,zu;xf,y,zu;xf,y,zd] * 0.01;
p = mstraj(path, [], [0,3,0.25,0.5,0.25]', path(1,:), 0.01, 0);
qcycle = leg.ikine(transl(p), [], [1 1 1 0 0 0]);
% leg.plot(qcycle, 'loop');

% 机器人的宽度和长度.
W = 0.1; L = 0.2;
% 将腿连到机器上.
legs(1) = SerialLink(leg, 'name', 'leg1');
legs(1) = SerialLink(leg, 'name', 'leg2', 'base', transl(-L, 0, 0));
legs(1) = SerialLink(leg, 'name', 'leg3', 'base', transl(-L, -W, 0)*trotz(pi));
legs(1) = SerialLink(leg, 'name', 'leg4', 'base', transl(0, -W, 0)*trotz(pi));

% 行走.
k = 1;
while 1
%     q = qleg(p,:);
    legs(1).plot(gait(qcycle, k, 0,   0));
    legs(2).plot(gait(qcycle, k, 100, 0));
    legs(3).plot(gait(qcycle, k, 200, 1));
    legs(4).plot(gait(qcycle, k, 300, 1));
    drawnow
    k = k+1;
end