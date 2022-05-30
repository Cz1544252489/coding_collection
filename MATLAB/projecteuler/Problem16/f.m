function [ s ] = f( n )
    s=zeros(1,n);
    len=zeros(1,n);
for j=1:n
    temp=2^j;
    A=num2str(temp);
    len(j)=length(A);
    for i=1:len(j)
        s(j)=s(j)+str2double(A(i));
    end
end
end

