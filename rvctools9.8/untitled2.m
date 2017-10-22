clear all
clc
mdl_puma560;
p560.base = transl(0,0,3) * trotx(pi);
p560.plot(qz);