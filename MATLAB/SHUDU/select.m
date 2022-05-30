function [L,len] = select( A,i,j )
%   计算每个点可能的值
%   分析这个点所在的行、列和3*3方阵，判断这个点可能加入的值
L=[1,2,3,4,5,6,7,8,9];
if A(i,j)==0
    %判断行
    for s=1:9
        for p=1:9
            if A(i,s)==p
                L(p)=0;
            end
        end
    end
    %判断列
    for s=1:9
        for p=1:9
            if A(s,j)==p
                L(p)=0;
            end
        end
    end
    %判断3*3方阵
    i1=floor((i-1)/3);j1=floor((j-1)/3);
    for s=(3*i1+1):(3*i1+3)
        for t=(3*j1+1):(3*j1+3)
            for p=1:9
                if A(s,t)==p
                    L(p)=0;
                end
            end
        end
    end
    L(L==0)=[];
    len=length(L);
else
    L=0;
    len=0;
end
end
