clear all;
clc;

% 设置各连杆长度.

L2 = 0.3;
L3 = 0.2;
L4 = 0.1;
% 设置初始位形.
qz = [0 0 0];
qn1 = [pi/8 -pi/2 0];
qn2 = [pi/4 -pi/4 -pi/4];
% 关节空间轨迹.
%q;

% 确定D-H参数.
s = 'Rx(q1) Tz(L2) Rx(q2) Tz(L3) Rx(q3) Tz(L4)';
dh = DHFactor(s);
cmd = dh.command('leg');
robot = eval(cmd);
% 设置偏移量，确定初始位形.
robot.links(3).offset = pi/2;
% 改变坐标原点位置，旋转坐标系，使机器人倒挂.还没解决（已解决，翻转z轴即可）.
% robot.base = transl(0,0,0.6);

% 绘制机器人.
% robot.plot(qz);

t = [0:0.05:2]';
qd0 = [0 0 0];
qdf = [0 1 0.5];

q = jtraj(qz, qn2, t, qd0, qdf);
clf;
% qplot中的q需要6axis，但是这里只有3，所以不能用.
plot(t, q(:,1));
hold on;
plot(t, q(:,2));
plot(t, q(:,3));
clc
q

% 设置完后一定要hold on.
% clf;
% axis([-0.6 0.6 -0.6 0.6 0 0.6]);
% set(gca, 'Zdir', 'reverse');
% view(137, 48);
% hold on;
% robot.plot(q, 'nobase', 'noshadow', 'loop');
% hold off;

% T = robot.fkine(q);
% p = transl(T);
% plot(p(:,2), p(:,3));
% xlabel('x');
% ylabel('y');


