function [A] = select2( A )
%一个利用以下原理求出见习9*9数独的解
%原理：如果一个3*3方阵中有一个方块（位置）可以放数a
%而这个方阵中其他方块都不能放数a，则这个方块就是a
L=cell(9);
for m=1:9
    for n=1:9
        L{m,n}=[1,2,3,4,5,6,7,8,9];
    end
end
%求出每个方块的里可能选择的值
%L表示这个方块可能放的值

for m=1:9
    for n=1:9
        [L{m,n},~]=select(A,m,n);
    end
end

%利用 takein 函数判断出一个3*3方阵里面可以填入的一个值
%并且用place（一个1*2的矩阵）表示这个值在方格中的位置
%    用spot  表示可以填入的这个值
for i1=1:3
    for i2=1:3
        [place,spot,time1]=takein( L(3*(i1-1)+1:3*i1,3*(i2-1)+1:3*i2));
        if time1~=0
            for i3=1:time1
                A(3*(i1-1)+place(1,1),3*(i2-1)+place(1,2))=...
                A(3*(i1-1)+place(1,1),3*(i2-1)+place(1,2))+spot(1);
            end
        end
    end
end

%在每一次用上述原理解决一个点后，用解决新手数独的方法
%对新的数独做一次运算
for i=1:9
    for j=1:9
        A=select1(A,i,j);
    end
end
end

