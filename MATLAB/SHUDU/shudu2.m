%% 用于求数独的解（用于解决见习数独）
%  主程序
clear all;clc;
load('shudu.mat');
A=jianxi{2,2};

B=A;
Maxtime=50;%计算的最大次数
time=0;%计算实时次数
flag=0;%判断：当计算一次后数独没有变化的时候结束计算

%对while循环做一个分析：
%在sum(sum(A))==405、tiem>Maxtime、flag中有一个成立
%则sum(...)==405||time>...||flag为真，其否为假，则停止计算
while(~(sum(sum(A))==405||time>Maxtime||flag))   %计算次数
    C=A;
    A=select2(A);
    time=time+1;
    if sum(sum(abs(C-A)))==0
       flag=1; %如果计算没有变化就令flag为1
    end
end
%若最后结果中 flag=1  说明计算能力没有达到
%若最后结果中 time=Maxtime+1  说明计算次数不够，应该提高最大计算次数
%若最后结果中 flag=0并且time<=Maxtime  
%说明完成计算达到要求：所有空格都填入了数字并且符合要求
disp('数独为');
B
disp('通过');
fprintf('%d',time);
disp('次计算后得到结果如下:');
A
clear C
