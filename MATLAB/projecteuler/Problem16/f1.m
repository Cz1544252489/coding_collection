function [ x ] = f1( n )
    s=zeros(1,n);
    len=zeros(1,n);
    x=zeros(1,14);
for j=1:len
    temp=2^j;
    for i=1:14
    x(i)=fix(mod(temp,10^i)/10^(i-1));
    end
end
end

