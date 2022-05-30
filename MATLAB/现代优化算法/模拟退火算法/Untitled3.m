%%%%%%%%%% 数据结构 %%%%%%%%%%
%  X:[0,50000]   Y:[-35000,35000]   %范围
%   Vx:方向的横向速度    Vy方向的纵向速度 
clear 
clc
Fly=[0 0 1 0 50000 15000 -1 0 50000 -15000 -1 0]';
for i=1:50
    [Flynew Turn ]=fun1(Fly(:,end));
    Fly=[Fly Flynew'];
    Turn
end








