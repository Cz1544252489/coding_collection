%%
%The prime factors of 13195 are 5, 7, 13 and 29.

%%
%What is the largest prime factor of the number 600851475143?

%for solving this project,I should know something about 
%how to get the prime factor,there are a lot ideas for get in link
% https://blog.csdn.net/yangxjsun/article/details/80201735

clc;clear;
number=600851475143;factor=zeros(1,1000000);
k=1;last=floor(number^0.5);
for i=3:last
    if mod(number,i)==0
        factor(k)=i;
        k=k+1
    end
end
factor(factor==0)=[];
len=length(factor)
temp=factor;
for i=len:-1:1
    i
    for j=1:i-1
        if mod(factor(i),factor(j))==0
            loc=find(temp==factor(i));
            temp(loc)=[];
        end
    end
end
temp