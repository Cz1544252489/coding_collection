%%%%%%%%%%% 模拟退火算法 %%%%%%%%%%%%
% 参考 智能优化算法及其MATLAB实例  P150
clear all;
close all;
clc;
XMAX=10;
XMIN=0;
YMAX=175;
YMIN=0;

L=100;
K=0.999;
S=0.02;
T=100;
YZ=1e-8;
P=0;

PreX=rand*(XMAX-XMIN)+XMIN;
PreY=rand*(YMAX-YMIN)+YMIN;
PreBestX=PreX;
PreBestY=PreY;

PreX=rand*(XMAX-XMIN)+XMIN;
PreY=rand*(YMAX-YMIN)+YMIN;
BestX=PreX;
BestY=PreY;
trace1=[];

deta=abs(func2(BestX,BestY)-func2(PreBestX,PreBestY));
while (deta> YZ)&&(T>0.01)
    T=K*T
    
    for i=1:L
        
        p=0;
        while p==0
            NextX=PreX+S*(rand*(XMAX-XMIN)+XMIN);
            NextY=PreY+S*(rand*(YMAX-YMIN)+YMIN);
            if(NextX>=XMIN &&NextX<=XMAX &&NextY>=...
                    YMIN &&NextY<=YMAX)
                p=1;
            end
        end
    
    if(func2(BestX,BestY)>func2(NextX,NextY))
        PreBestX=BestX;
        PreBestY=BestY;
        
        BestX=NextX;
        BestY=NextY;
    end
    
    if(func2(PreX,PreY)-func2(NextX,NextY)>0)
        PreX=NextX;
        PreY=NextY;
        P=P+1;
    else
        changer=-1*(func2(NextX,NextY)-func2(PreX,PreY))/T;
        p1=exp(changer);
        
        if p1>rand
            PreX=NextX;
            PreY=NextY;
            P=P+1;
        end
    end
    trace1(P+1)=func2(BestX,BestY);
    end
    deta=abs(func2(BestX,BestY)-func2(PreBestX,PreBestY));
end
disp('最小值在点:');
BestX
BestY
dl1=250*(BestX+BestY)
dh1=200*BestX
dh2=200*BestY
disp('最小值为:');
func2(BestX,BestY)
plot(trace1(2:end))
xlabel('迭代次数');
ylabel('目标函数值');
title('适配值进化曲线');





















