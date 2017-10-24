clear all 
clc

% 从excel表中读取步态数据,需要将表中数据转为弧度.
[num text raw] = xlsread('/home/exbot/桌面/llrr_matlab/gait.xlsx');
% 设置一个放缩系数来进行观察.
kH = 1.0; 
kK = 1.0;
kA = 1.0;
% 右腿步态数据.
gaitHR = pi/180*[kH*num(:,2)];
gaitKR = pi/180*[kH*num(:,2) kK*num(:,3)];
gaitAR = pi/180*[kH*num(:,2) kK*num(:,3) kA*num(:,4)];
% 左腿步态数据.
gaitHL = pi/180*[kH*num(:,5)];
gaitKL = pi/180*[kH*num(:,5) kK*num(:,6)];
gaitAL = pi/180*[kH*num(:,5) kK*num(:,6) kA*num(:,7)];

% 分别建立D-H模型.
L1 = 0.5; L2 = 0.4; L3 = 0.15;
sH = 'Rz(q1).Ty(L1)';
sK = 'Rz(q1).Ty(L1).Rz(q2).Ty(L2)';
sA = 'Rz(q1).Ty(L1).Rz(q2).Ty(L2).Rz(q3).Ty(L3)';
dhH = DHFactor(sH);
dhK = DHFactor(sK);
dhA = DHFactor(sA);
legHR = eval(dhH.command('legHR'));
legKR = eval(dhK.command('legKR'));
legAR = eval(dhA.command('legAR'));
legAR.links(3).offset = pi/2;
% 复制右腿模型，并对base作平移，得到左腿模型.
legHL = SerialLink(legHR, 'name', 'legHL', 'base', transl(0, 0, 0.1));
legKL = SerialLink(legKR, 'name', 'legKL', 'base', transl(0, 0, 0.1));
legAL = SerialLink(legAR, 'name', 'legAL', 'base', transl(0, 0, 0.1));
legAL.links(3).offset = pi/2;

% % 测试复制及平移是否成功.
% clf;
% hold on;
% legHR.plot([0]);
% legHL.plot([0]);

% 正运动学分析,获得平面路径.

legHREnd = transl( legHR.fkine(gaitHR) );
legKREnd = transl( legKR.fkine(gaitKR) );
legAREnd = transl( legAR.fkine(gaitAR) );
legHLEnd = transl( legHL.fkine(gaitHL) );
legKLEnd = transl( legKL.fkine(gaitKL) );
legALEnd = transl( legAL.fkine(gaitAL) );

% 计算末端速度.
% 需要使用雅克比矩阵运算速度.
% 但是呢，现在并不会...
% 再说吧，吃饭去了...

% 绘制图像.
clc;
clf;
set(gca, 'YDir', 'reverse');
view(pi/8, 90);
axis equal;
axis([-0.6 0.4 0 1 0 0.2]);
hold on;
% xlabel('x');
% ylabel('y');
% plot(legHREnd(:,1), legHREnd(:,2));
% plot(legKREnd(:,1), legKREnd(:,2));
% plot(legAREnd(:,1), legAREnd(:,2));
% legend('hip', 'knee', 'ankle');
zeroM = zeros(size(legHLEnd)); 
plot3(legHLEnd(:,1), legHLEnd(:,2), zeroM);
plot3(legKLEnd(:,1), legKLEnd(:,2), zeroM);
plot3(legALEnd(:,1), legALEnd(:,2), zeroM);

% 绘制机器人图像，测试数据是否正确
i = 1;
while i < 52
    legAR.plot(gait(gaitAR, i, 0, 0), 'noshadow', 'nobase', 'nojaxes');
    legAL.plot(gait(gaitAL, i, 0, 0), 'noshadow', 'nobase', 'nojaxes');
    
    % 将图像保存为gif.
    nn = getframe(gcf);
    im = frame2im(nn);
    [I,map] = rgb2ind(im, 256);
    if i == 1
        imwrite(I, map, 'out.gif', 'gif', 'loopcount', inf, 'DelayTime', 0.05);
    else
        imwrite(I, map, 'out.gif', 'gif', 'writemode', 'append', 'DelayTime', 0.05);
    end
    
    i = i+1;
end





