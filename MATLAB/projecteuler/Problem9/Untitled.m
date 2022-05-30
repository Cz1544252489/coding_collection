%%
%A Pythagorean triplet is a set of three natural numbers, a < b < c, for which,
%                   a^2 + b^2 = c^2
% For example, 3^2 + 4^2 = 9 + 16 = 25 = 5^2.

%%
% There exists exactly one Pythagorean triplet for which a + b + c = 1000.
% Find the product abc.

clc;clear;
tripsum=1000;last=floor(tripsum/3);stop=0;
for i=1:last
    for j=i:(2*last+1)
        if i^2+j^2==(tripsum-i-j)^2
            a=i;
            b=j;
            stop=1;
        end
    end
    if stop==1
        break;
    end
end
product=a*b*(tripsum-a-b)



