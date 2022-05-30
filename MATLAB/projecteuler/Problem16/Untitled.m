%2^15 = 32768 and the sum of its digits is 3 + 2 + 7 + 6 + 8 = 26.

%What is the sum of the digits of the number 2^1000?

clc, clear
n=50;s=zeros(n,1);sd=zeros(n,1);
for i=1:n
    s(i)=2^i;
    temp=num2str(s(i));
    for j=1:length(temp)
        sd(i)=sd(i)+str2double(temp(j));
    end
end



