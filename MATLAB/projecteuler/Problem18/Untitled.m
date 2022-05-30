%Find the maximum total from top to bottom of the triangle below:
clear, clc
global data
global level
load('data');
[level,~]=size(data);
%Find all 16384 routes
%%  一个判断条件
sum=0;chage=zeros(1,level);
for i=1:level
    sum=sum+i;
    chage(i)=sum;
end
clear sum i
%%
maxsum=0;
route=ones(1,level);
maxsum=sumrou(route,maxsum);
route
% flag=level;flag0=level-2;
h=-8;
% k=3;
while(h)
%     if(sum(route(flag0:end))==chage(k))
%         route(flag0:end)=(k-1)*ones(1,level-flag0+1);
%         k=k+1;
%         flag0=flag0-1;
%     else
%         if(route(flag-1)==route(flag))
%             route(flag)=route(flag)+1;
%         else
%             route(flag-1)=route(flag-1)+1;
%         end
%     end
    route=chageroute( route );
    maxsum=sumrou(route,maxsum);
    h=h+1;
end
maxsum











