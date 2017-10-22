clear all
clc


mdl_puma560;
path = [1 0 1; 1 0 0; 0 0 0; 0 2 0; 1 2 0; 1 2 1; 0 1 1; 0 1 0; 1 1 0; 1 1 1];
plot3(path(:,1), path(:,2), path(:,3), 'color', 'k', 'LineWidth', 2);
p = mstraj(path, [0.5, 0.5, 0.3], [], [2 2 2], 0.02, 0.2);
Tp = transl(0.1 * p);
Tp = homtrans(transl(0.4, 0, 0), Tp);
p560.tool = trotx(pi);
q = p560.ikine6s(Tp);
Ts = p560.fkine(q);
p = transl(Ts);
about(p)
% p560.plot(q)