function [ err ] = rule( route )
%πÊ‘Ú
global level
err=0;
for i=1:level-1
    if(route(i+1)-route(i)~=0&&route(i+1)-route(i)~=1)
        err=err+1;
    end
end
end

