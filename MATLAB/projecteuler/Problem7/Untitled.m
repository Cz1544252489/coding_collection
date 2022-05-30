%%
%By listing the first six prime numbers: 2, 3, 5, 7, 11, and 13, 
%we can see that the 6th prime is 13.

%%
%What is the 10 001st prime number?

clc;clear;
list=zeros(1,1000000);
list(1)=2;
count=1;
for i=1:1.5e+5
    flag=0;
    for j=2:i-1
        if mod(i,j)==0
            flag=flag+1;
        end
    end
    if flag==0
        count=count+1;
        list(count)=i;
    end
    if count>=10002
        break;
    end
end
list(list==0)=[];
list(10001)