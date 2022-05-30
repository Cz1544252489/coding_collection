clc,clear
load sj.mat %加载敌方100 个目标的数据，数据按照表格中的位置保存在纯文本文件sj.txt 中
x=sj(:,1:2:8);x=x(:);
y=sj(:,2:2:8);y=y(:);
sj=[x y]; d1=[70,40];
sj=[d1;sj;d1]; sj=sj*pi/180;
d=zeros(102); %距离矩阵d
for i=1:101
    for j=i+1:102
        temp=cos(sj(i,1)-sj(j,1))*cos(sj(i,2))*cos(sj(j,2))+sin(sj(i,2))*sin(sj(j,2));
        d(i,j)=6370*acos(temp);
    end
end
d=d+d';
S0=[];Sum=inf;
rand('state',sum(clock));
%%%%%%%% 先给出一个比较优秀的初始值 %%%%%%%%
for j=1:1000
    S=[1 1+randperm(100),102];
    temp=0;
    for i=1:101
        temp=temp+d(S(i),S(i+1));
    end
    if temp<Sum
        S0=S;Sum=temp;
    end
end
n=100;                      %问题规模，目标个数
T=100*n;                    %初始温度
L=100;                          %马尔科夫链长度
K=0.99;                         %衰减参数
%%%%%%%%%%%%  目标结构体 %%%%%%%%%%%%%
target=struct([]);
for i=1:n
    target(i).x=sj(S0(i),1);
    target(i).y=sj(S0(i),2);
end
l=1;                                %迭代次数
len(l)=func4(target,n);     %每次迭代后的路线长度
figure(1);
while T>0.001                       %停止迭代温度
    %%%%%%%%%%% 多次迭代扰动，温度降低前多次试验  %%%%%%%%%%%
    for i=1:L
        %%%%%%%%%%%% 计算原路线总距离 %%%%%%%%%%%%%%%%%
        len1=func4(target,n);
        %%%%%%%%%%%%  产生随机扰动  %%%%%%%%%%%%%%%
        %%%%%%%%%%%随机置换两个不同城市的坐标  %%%%%%%%%%
        p1=floor(1+n*rand());
        p2=floor(1+n*rand());
        while p1==p2
            p1=floor(1+n*rand());
            p2=floor(1+n*rand());
        end
        tmp_target=target;
        tmp=tmp_target(p1);
        tmp_target(p1)=tmp_target(p2);
        tmp_target(p2)=tmp;
        %%%%%%%%%%%%%%计算新路线的总距离  %%%%%%%%%%%
        len2=func4(tmp_target,n);
        %%%%%%%%%%%%  新老路线的差值，相当于能量 %%%%%%%
        delta_e=len2-len1;
        %%%%%%%%%%%  新路线好于旧路线，用新的代替旧的 %%%%%%%
        if delta_e<0
            target=tmp_target;
        else
            %%%%%%%%%% 以概率选择是否接受新解 %%%%%%%%%%%%%
            if exp(-delta_e/T)>rand()
                target=tmp_target;
            end
        end
    end
    l=l+1;
    %%%%%%%%%%% 计算新路线距离 %%%%%%%%%%%%%%%%%
    len(l)=func4(target,n);
    %%%%%%%%%%%%% 温度不断下降 %%%%%%%%%%%%%%
    T=T*K;
    for i=1:n-1
        plot([target(i).x,target(i+1).x],[target(i).y,target(i+1).y],'bo-');
        hold on
    end
    plot([target(n).x,target(1).x],[target(n).y,target(1).y],'ro-');
    title(['优化最短距离:',num2str(len(l))]);
    hold off
    pause(0.005);
end
figure(2);
plot(len)
xlabel('迭代次数');
ylabel('目标函数值');
title('适应度进化曲线');













