%% 用于求数独的解（用于解决新手数独）
%  主程序
clear all;clc;
load('shudu.mat');
A=xinshou{1,1};

B=A;
Maxtime=10;%计算的最大次数
time=0;
while(~(sum(sum(A))==405||time>Maxtime))   %计算次数
    for i=1:9
        for j=1:9
            A=select1(A,i,j);
        end
    end
    time=time+1;
end
disp('原数组为:');
B
if time>Maxtime&&sum(sum(A))~=405
    disp('对不起，解不出来');
else
    disp('能计算出来，结果如下:');
    disp('计算次数为');
    fprintf('%d',time);
    disp('次');
end
clear i j Maxtime ans 
A
