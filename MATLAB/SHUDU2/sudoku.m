function result = sudoku( m )
%SUDOKU 此处显示有关此函数的摘要
%   此处显示详细说明
while 1
    m0=ceil(m/9);
    l=81-sum(sum(m0));
    x=[];flag=1;
    for k=1:l
        for i=1:9
            for j=1:9
                if m(i,j)==0
                    k1=ceil(i/3);k2=ceil(j/3);
                    m1=m(3*k1-2:3*k1,3*k2-2:3*k2);
                    a=m(i,:);b=m(:,j)';c(1:9)=m1;
                    d=setdiff(1:9,union(union(a,b),c));
                    if length(d)==0
                        flag=0;break
                    else if length(d)==1
                            m(i,j)=d(1);
                            x=[x;[i,j,d(1)]];
                        else
                            r=i;c=j;choise=d;
                        end
                    end
                end
                if flag==0
                    break
                end
            end
            if flag==0
                break
            end
        end
        if flag==0
            break
        end
    end
    if flag==0
        disp('Impossible to complete!')
        break
    else if all(all(m))==0
            disp('Choose a number and fill intothe blank square,try again!');
            m
            [r,c]
            choise
            r=input('r=');
            c=input('c=');
            m(r,c)=input('m(r,c)=');
        else
            disp('Success!');
            result=m;
            break
        end
    end
end