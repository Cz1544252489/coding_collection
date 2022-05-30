% The following iterative sequence is defined for the set of positive integers:
% 
% n ¡ú n/2 (n is even)
% n ¡ú 3n + 1 (n is odd)
% 
% Using the rule above and starting with 13, we generate the following sequence:
% 
% 13 ¡ú 40 ¡ú 20 ¡ú 10 ¡ú 5 ¡ú 16 ¡ú 8 ¡ú 4 ¡ú 2 ¡ú 1
% It can be seen that this sequence (starting at 13 and finishing at 1) contains 10 terms. 
% Although it has not been proved yet (Collatz Problem), it is thought that all starting numbers finish at 1.
% 
% Which starting number, under one million, produces the longest chain?

% NOTE: Once the chain starts the terms are allowed to go above one million.

clear,clc
%use function 'finishat1'
tic
maxlength=0;
maxstart=0;
for startfrom=13:13
    startfrom
    length=0;
    number=startfrom;
    while number>1
        number=finishat1(number);
        length=length+1;
    end
    if length>maxlength
        maxlength=length;
        maxstart=startfrom;
    end
end
toc
maxstart
maxlength