function [ len ] = func4( target , n )
%%%%%%%%%%%%%%% 计算路线总长度 %%%%%%%%%%%%%%
len=0;
for i=1:n-1
    temp=cos(target(i).x-target(i+1).x)*cos(target(i).y)*cos(target(i+1).y)+...
        sin(target(i).y)*sin(target(i+1).y);
    len=len+6370*acos(temp);
end
 temp=cos(target(n).x-target(1).x)*cos(target(n).y)*cos(target(1).y)+...
        sin(target(n).y)*sin(target(1).y);
len=len+6370*acos(temp);
end

