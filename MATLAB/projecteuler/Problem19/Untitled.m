%Counting sundays
%How many Sundays fell on the first of the month during the twentieth century (1 Jan 1901 to 31 Dec 2000)?

%A year being not a leap has 4*30+7*31+28=365
%while a year being a leap has 4*30+7*31+29=366
%Find the number that the day counts from 1 Jan 1901 to 31 Dec 2000
%mod(365,7)=2,that means 1 Jan 1901 is Wednesday

clear,clc
sumdays=0;
for year=1901:2000
    if (mod(year,4)==0&&mod(year,100)~=0)||mod(year,400)==0
        sumdays=sumdays+366;
    else
        sumdays=sumdays+365;
    end
end
sumdays
k=mod(sumdays,7)
h=(sumdays-k)/7
%Got the sum of days that is 36524
%36524=5217*7+5







