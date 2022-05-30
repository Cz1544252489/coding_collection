function [ place,spot,time1 ] = takein( L )
%	在一个3*3方阵可能出现的数字中判断要填入的数字
%先将9个（一般会更少）方阵中的数字集合在一起
%找出只有一个数字数和其位置（可能有多个）
C=[];
for m=1:3
    for n=1:3
        C=[C,L{m,n}];
    end
end
C(C==0)=[];
% %tabulate函数：一个计数函数
% %原数放在第一列,数的个数放在第二列，百分比放在第三列
% D=tabulate(C);
% [hang,~]=size(D);%hang为行数，即是数的种类
% spot=zeros(1,9);
% place=zeros(2,9);
% time1=0;
% for i=1:hang
%     if D(i,2)==1
%         time1=time1+1;
%         spot(time1)=D(i,1);
%     end
% end

spot=zeros(9,1);
place=zeros(9,2);
time1=0;
for i1=1:9
    if sum(C==i1)==1
        time1=time1+1;
        spot(time1)=i1;
    end
end
place0=[1 1;1 2;1 3;2 1;2 2;2 3;3 1;3 2;3 3];
if sum(spot)~=0
    time2=1;
    for m=1:9
        for m1=1:time1
            if sum(L{place0(m,1),place0(m,2)}==spot(m1))==1
%                 ||...
%                     (length(L{place0(m,1),place0(m,2)})==1&&...
%                     sum(L{place0(m,1),place0(m,2)}==spot(m1))>1)
                %如果L{m,n}这个矩阵中有spot(m1)则真
                %否则 为假
                place(time2,1:2)=place0(m,1:2);
                time2=time2+1;
            end
        end
    end
end

% if sum(spot)~=0
%     for m=1:9
%         if sum(L{place0(m,1),place0(m,2)}==spot(m1))==1||...
%                 length(L{place0(m,1),place0(m,2)})==1
%         end
%     end
% end
            

spot(spot==0)=[];
place(place==0)=[];
if isempty(place)
    time1=0;
end
% if time1>1
%     time1=1;
% end
end

