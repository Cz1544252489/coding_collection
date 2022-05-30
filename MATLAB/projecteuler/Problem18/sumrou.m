function [ maxsum ] = sumrou( route ,maxsum )
global data
global level
sum=0;
for i=1:level
    sum=sum+data(i,route(i));
end
if(maxsum<sum)
    maxsum=sum;
end
end

