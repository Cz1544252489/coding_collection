% Starting in the top left corner of a 2¡Á2 grid, 
% and only being able to move to the right and down, 
% there are exactly 6 routes to the bottom right corner.

% How many such routes are there through a 20¡Á20 grid?
% USE THE FUNCTION supA

clc,clear
tic
A=zeros(20,20);
n=9;
for i=1:n
    for j=1:n
        A(i,j)=supA(i,j);
    end
end
toc
clear i j 
save A110
%n=10   44.92911second
%n=11       232.490679

% the result is C(40,20)=137846528820
%  use nchoosek(40,20)=137846528820