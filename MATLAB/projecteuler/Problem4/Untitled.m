%%
%A palindromic number reads the same both ways. 
%The largest palindrome made from the product of two 2-digit numbers is 9009 = 91 ¡Á 99.

%%
%Find the largest palindrome made from the product of two 3-digit numbers.

clc;clear;box=zeros(1,100000);
k=1;
for first=1:9
    for second=0:9
        for third=0:9
            number=first*1e+5+second*1e+4+third*1e+3+third*1e+2+second*1e+1+first;
            for i=101:999
                if mod(number,i)==0
                    if number/i>=100&&number/i<1000
                        box(k)=number;
                    end
                end
            end
            k=k+1;
        end
    end
end
box(box==0)=[];
box