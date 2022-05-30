function [ route ] = chageroute( route )
 %完全二叉树遍历
 %rule
 global level
level=length(route);
flag=level;
temp=route;
for i=level:-1:1
    err=rule(route);
    if(~err)
        temp(i)=temp(i)+1;
        route=temp;
        break;
    else
        flag=flag-1;
        continue;
    end
    
end
end

