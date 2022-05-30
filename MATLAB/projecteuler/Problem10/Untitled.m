%%
%The sum of the primes below 10 is 2 + 3 + 5 + 7 = 17.

%%
%Find the sum of all the primes below two million.

clc;clear;
tic
sum=2;
spmb=[2 3 5 7 11 13 17 19 23 29 31 37 41 43 47 53 59 61 67 71 73 79 83 89 97];
for i=3:2:2000000
    i
    flag=0;
    for k=1:length(spmb)
        if i>spmb(k)&&mod(i,spmb(k))==0
            flag=flag+1;
        end
        if flag>0
            continue;
        end
    end
    if flag>0
        continue;
    end
    for j=2:i-1
        if mod(i,j)==0
            flag=flag+1;
        end
        if flag>0
            continue;
        end
    end
    if flag==0
        sum=sum+i;
    end
end
toc
sum