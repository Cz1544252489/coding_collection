%%
%2520 is the smallest number that can be divided by each of the numbers 
%from 1 to 10 without any remainder.

%%
%What is the smallest positive number that is evenly divisible 
%by all of the numbers from 1 to 20?

%This problem ,I think,without a code,can be solved
% I can product from the largest one that is 20;
% it can be divided by 2 ,5,10,that means we need not to think them again.
% the next one is 19 that`s a prime number without factor;
% and 18 that can be divided by 3,6,9,here I don`t list the number it counts.
% by the same way,we get somenumber left that 
% 17(prime number) 16(divided by 4,8) 15(divided by none)
% 14(divided by 7) 13(prime number) 12(divided by none)
% 11(prime number)  so the smallest positive number that is evenly divisible
% by all of the numbers from 1 to 20 will be 11*13*14*17*18*19*20
% that is 232792560

%%
%I didn`t get the core,so I redo it.

clc; clear;
number=232792560
for i=2:20
    if mod(number,i)==0
        number/i
    end
end