clc
clear
tic
load('A110');
save('A11');
%%   Íâ±ß
for i=19-n:20
    A(i,1)=i+1;
    A(1,i)=i+1;
end
%%   ÄÚ²ã
for i=2:n
    for j=19-n:20
            A(i,j)=A(i-1,j)+A(i,j-1);
    end
end
for i=19-n:20
    for j=2:n
        A(i,j)=A(j,i);
    end
end
%%   ÓÒÏÂ½Ç
for i=19-n:20
    for j=19-n:20
        if i==j
            A(i,j)=2*A(i-1,j)-A(i-1,j-1);
        else
            A(i,j)=A(i-1,j)+A(i,j-1);
        end
    end
end
save('A11');
toc

