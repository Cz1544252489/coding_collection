function [ Flynew , Turn ] = fun1( Flyend )
%fun1 知道了最近一次状态求下一次状态
XHT01=Flyend(1);
YHT01=Flyend(2);
VxHT01=Flyend(3);
VyHT01=Flyend(4);
XFY01=Flyend(5);
YFY01=Flyend(6);
VxFY01=Flyend(7);
VyFY01=Flyend(8);
XFY02=Flyend(9);
YFY02=Flyend(10);
VxFY02=Flyend(11);
VyFY02=Flyend(12);

t0=0.5;   %时间间隔
lamda=0.4;  %
VE=250;    %HT的速度
VP=200;    %FY的速度
RE=500;     %HT的最小转弯半径
RP=350;     %FY的最小转弯半径
%%%%%%  HT01 的飞行方式
Pointx=(XFY01+XFY01)/2*(1-lamda)+XHT01*lamda;
Pointy=(YFY01+YFY01)/2* +YHT01*lamda;
%%% FY01 的前进方向
PVxFY01=(XFY01-Pointx)/sqrt((XFY01-Pointx)^2+(YFY01-Pointy)^2);
PVyFY01=(YFY01-Pointy)/sqrt((XFY01-Pointx)^2+(YFY01-Pointy)^2);
%%% FY02 的前进方向
PVxFY02=(XFY02-Pointx)/sqrt((XFY02-Pointx)^2+(YFY02-Pointy)^2);
PVyFY02=(YFY02-Pointy)/sqrt((XFY02-Pointx)^2+(YFY02-Pointy)^2);
%%%  FY01 与HT01的角度（实际方向）
PVxFY01HT01=(XFY01-XHT01)/sqrt((XFY01-XHT01)^2+(YFY01-YHT01)^2);
PVyFY01HT01=(YFY01-YHT01)/sqrt((XFY01-XHT01)^2+(YFY01-YHT01)^2);
%%%  FY02 与HT01的角度（实际方向）
PVxFY02HT01=(XFY02-XHT01)/sqrt((XFY02-XHT01)^2+(YFY02-YHT01)^2);
PVyFY02HT01=(YFY02-YHT01)/sqrt((XFY02-XHT01)^2+(YFY02-YHT01)^2);
%%%  需要前进的方向
PVxHT01=(Pointx-XHT01)/sqrt((Pointx-XHT01)^2+(Pointy-YHT01)^2);
PVyHT01=(Pointy-YHT01)/sqrt((Pointx-XHT01)^2+(Pointy-YHT01)^2);
%%%  判断转弯还是直行
thetaFY=VP*t0/RP;
thetaHT=VE*t0/RE;
%%% 0 表示直行 1表示单独向上 2表示先向上后直行 -1表示向下 -2表示先向下后直行
TurnHT01=0;
TurnFY01=0;
TurnFY02=0;
%%%  FY01
if PVyFY01HT01<PVyFY01  %前进方向在实际方向下
    if abs(atan(PVyFY01HT01/PVxFY01HT01)-atan(PVyFY01/PVxFY01))>thetaFY
        Flynew(7)=cos(atan(VyFY01/VxFY01)+thetaFY);%向下旋转
        Flynew(8)=sin(atan(VyFY01/VxFY01)+thetaFY);
        TurnFY01=-1;
    else
        deltaFY01=abs(atan(PVyFY01HT01/PVxFY01HT01)-atan(PVyFY01/PVxFY01));
        Flynew(7)=cos(atan(VyFY01/VxFY01)+deltaFY01);%向下旋转
        Flynew(8)=sin(atan(VyFY01/VxFY01)+deltaFY01);
        TurnFY01=-2;
    end
elseif PVyFY01HT01>PVyFY01
    if abs(atan(PVyFY01HT01/PVxFY01HT01)-atan(PVyFY01/PVxFY01))>thetaFY
        Flynew(7)=cos(atan(VyFY01/VxFY01)-thetaFY);%向上旋转
        Flynew(8)=sin(atan(VyFY01/VxFY01)-thetaFY);
        TurnFY01=1;
    else
        Flynew(7)=cos(atan(VyFY01/VxFY01)-deltaFY01);%向上旋转
        Flynew(8)=sin(atan(VyFY01/VxFY01)-deltaFY01);
        TurnFY01=2;
    end
else
    Flynew(7)=PVxFY01;
    Flynew(8)=PVyFY01;
end
%%%  FY02
if PVyFY02HT01<PVyFY02 %前进方向在实际方向下
    if abs(atan(PVyFY02HT01/PVxFY02HT01)-atan(PVyFY02/PVxFY02))>thetaFY
        Flynew(11)=cos(atan(VyFY02/VxFY02)+thetaFY);%向下旋转
        Flynew(12)=sin(atan(VyFY02/VxFY02)+thetaFY);
        TurnFY01=-1;
    else
        deltaFY02=abs(atan(PVyFY02HT01/PVxFY02HT01)-atan(PVyFY02/PVxFY02));
        Flynew(11)=cos(atan(VyFY02/VxFY02)+deltaFY02);%向下旋转
        Flynew(12)=sin(atan(VyFY02/VxFY02)+deltaFY02);
        TurnFY01=-2;
    end
elseif PVyFY01HT01>PVyFY01
    if abs(atan(PVyFY02HT01/PVxFY02HT01)-atan(PVyFY02/PVxFY02))>thetaFY
        Flynew(11)=cos(atan(VyFY02/VxFY02)-thetaFY);
        Flynew(12)=sin(atan(VyFY02/VxFY02)-thetaFY);%向上旋转
        TurnFY01=1;
    else
        Flynew(11)=cos(atan(VyFY02/VxFY02)-deltaFY02);
        Flynew(12)=sin(atan(VyFY02/VxFY02)-deltaFY02);%向上旋转
        TurnFY01=2;
    end
else
    Flynew(11)=PVxFY01;
    Flynew(12)=PVyFY01;
end
%%%  HT01
if PVyHT01>VyHT01     %前进方向在实际方向下方
    if abs(atan(VyHT01/VxHT01)-atan(PVyHT01/PVxHT01))>thetaHT
        Flynew(3)=cos(atan(VyHT01/VxHT01)-thetaHT);%向下旋转
        Flynew(4)=sin(atan(VyHT01/VxHT01)-thetaHT);%向下旋转
        TurnHT01=-1;
    else
        deltaHT01=abs(atan(VyHT01/VxHT01)-atan(PVyHT01/PVxHT01));
        Flynew(3)=cos(atan(VyHT01/VxHT01)-deltaHT01);%向下旋转
        Flynew(4)=sin(atan(VyHT01/VxHT01)-deltaHT01);%向下旋转
        TurnHT01=-2;
    end
elseif PVyHT01<VyHT01
    if abs(atan(VyHT01/VxHT01)-atan(PVyHT01/PVxHT01))>thetaHT
        Flynew(3)=cos(atan(VyHT01/VxHT01)+thetaHT);%向上旋转
        Flynew(4)=sin(atan(VyHT01/VxHT01)+thetaHT);%向上旋转
        TurnHT01=1;
    else
        Flynew(3)=cos(atan(VyHT01/VxHT01)+deltaHT01);%向上旋转
        Flynew(4)=sin(atan(VyHT01/VxHT01)+deltaHT01);%向上旋转
        TurnHT01=2;
    end
else
    Flynew(3)=PVxHT01;
    Flynew(3)=PVyHT01;
end
%%% 位置的变化
%%% HT01
if TurnHT01==0
    Flynew(1)=XHT01+VE*t0*VxHT01;
    Flynew(2)=YHT01+VE*t0*VyHT01;
elseif TurnHT01==1
    Flynew(1)=XHT01+RE*(2*cos(atan(VyHT01/VxHT01))-cos(atan(VyHT01/VxHT01)+thetaHT)-1);
    Flynew(2)=YHT01+RE*(sin(atan(VyHT01/VxHT01)+thetaHT)-sin(atan(VyHT01/VxHT01)));
elseif TurnHT01==2
    Flynew(1)=XHT01+RE*(2*cos(atan(VyHT01/VxHT01))-cos(atan(VyHT01/VxHT01)+thetaHT)-1);
    Flynew(2)=YHT01+RE*(sin(atan(VyHT01/VxHT01)+thetaHT)-sin(atan(VyHT01/VxHT01)));
    Flynew(1)=Flynew(1)+RE*tan(thetaHT-deltaHT01)*Flynew(3);
    Flynew(2)=Flynew(2)+RE*tan(thetaHT-deltaHT01)*Flynew(4);
elseif TurnHT01==-1
    Flynew(1)=XHT01+RE*(2*cos(atan(VyHT01/VxHT01))-cos(atan(VyHT01/VxHT01)+thetaHT)-1);
    Flynew(2)=YHT01-RE*(sin(atan(VyHT01/VxHT01)+thetaHT)-sin(atan(VyHT01/VxHT01)));
elseif TurnHT01==-2
    Flynew(1)=XHT01+RE*(2*cos(atan(VyHT01/VxHT01))-cos(atan(VyHT01/VxHT01)+thetaHT)-1);
    Flynew(2)=YHT01-RE*(sin(atan(VyHT01/VxHT01)+thetaHT)-sin(atan(VyHT01/VxHT01)));
    Flynew(1)=Flynew(1)+RE*tan(thetaHT-deltaHT01)*Flynew(3);
    Flynew(2)=Flynew(2)-RE*tan(thetaHT-deltaHT01)*Flynew(4);
end
if TurnFY01==0
    Flynew(5)=XFY01+VP*t0*VxFY01;
    Flynew(6)=YFY01+VP*t0*VyFY01;
elseif TurnFY01==1
    Flynew(5)=XFY01-RP*(2*cos(atan(VyFY01/VxFY01))-cos(atan(VyFY01/VxFY01)+thetaFY)-1);
    Flynew(6)=YFY01+RP*(sin(atan(VyFY01/VxFY01)+thetaFY)-sin(atan(VyFY01/VxFY01)));
elseif TurnFY01==2
    Flynew(5)=XFY01-RP*(2*cos(atan(VyFY01/VxFY01))-cos(atan(VyFY01/VxFY01)+thetaFY)-1);
    Flynew(6)=YFY01+RP*(sin(atan(VyFY01/VxFY01)+thetaFY)-sin(atan(VyFY01/VxFY01)));
    Flynew(5)=Flynew(5)-RP*tan(thetaFY-deltaFY01)*Flynew(7);
    Flynew(6)=Flynew(6)+RP*tan(thetaFY-deltaFY01)*Flynew(8);
elseif TurnFY01==-1
    Flynew(5)=XFY01-RP*(2*cos(atan(VyFY01/VxFY01))-cos(atan(VyFY01/VxFY01)+thetaFY)-1);
    Flynew(6)=YFY01-RP*(sin(atan(VyFY01/VxFY01)+thetaFY)-sin(atan(VyFY01/VxFY01)));
elseif TurnFY01==-2
    Flynew(5)=XFY01+RP*(2*cos(atan(VyFY01/VxFY01))-cos(atan(VyFY01/VxFY01)+thetaFY)-1);
    Flynew(6)=YFY01-RP*(sin(atan(VyFY01/VxFY01)+thetaFY)-sin(atan(VyFY01/VxFY01)));
    Flynew(5)=Flynew(5)+RP*tan(thetaFY-deltaFY01)*Flynew(7);
    Flynew(6)=Flynew(6)-RP*tan(thetaFY-deltaFY01)*Flynew(8);
end
if TurnFY02==0
    Flynew(9)=XFY02+VP*t0*VxFY02;
    Flynew(10)=YFY02+VP*t0*VyFY02;
elseif TurnFY02==1
    Flynew(9)=XFY02-RP*(2*cos(atan(VyFY02/VxFY02))-cos(atan(VyFY02/VxFY02)+thetaFY)-1);
    Flynew(10)=YFY02+RP*(sin(atan(VyFY02/VxFY02)+thetaFY)-sin(atan(VyFY02/VxFY01)));
elseif TurnFY02==2
    Flynew(9)=XFY02-RP*(2*cos(atan(VyFY02/VxFY02))-cos(atan(VyFY02/VxFY02)+thetaFY)-1);
    Flynew(10)=YFY02+RP*(sin(atan(VyFY02/VxFY02)+thetaFY)-sin(atan(VyFY02/VxFY02)));
    Flynew(9)=Flynew(9)-RP*tan(thetaFY-deltaFY02)*Flynew(11);
    Flynew(10)=Flynew(10)+RP*tan(thetaFY-deltaFY02)*Flynew(12);
elseif TurnFY02==-1
    Flynew(9)=XFY02-RP*(2*cos(atan(VyFY02/VxFY02))-cos(atan(VyFY02/VxFY02)+thetaFY)-1);
    Flynew(10)=YFY02-RP*(sin(atan(VyFY02/VxFY02)+thetaFY)-sin(atan(VyFY02/VxFY02)));
elseif TurnFY02==-2
    Flynew(9)=XFY01+RP*(2*cos(atan(VyFY02/VxFY02))-cos(atan(VyFY02/VxFY02)+thetaFY)-1);
    Flynew(10)=YFY01-RP*(sin(atan(VyFY02/VxFY02)+thetaFY)-sin(atan(VyFY02/VxFY02)));
    Flynew(9)=Flynew(9)+RP*tan(thetaFY-deltaFY02)*Flynew(11);
    Flynew(10)=Flynew(10)-RP*tan(thetaFY-deltaFY02)*Flynew(2);
end  
Turn=[TurnHT01,TurnFY01,TurnFY02];
end

