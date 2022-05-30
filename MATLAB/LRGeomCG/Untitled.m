clear,clc,close
%%
n=500;
k=10;
tau=1e-3;
p0=3.0*k*(2*n-k)/n^2;
max_iter=100;

%%

s=RandStream('mt19937ar','Seed',sum(100*clock));
RandStream.setGlobalStream(s);
M=randn(n,k)*randn(k,n);
Omega=rand(n,n);
Omega(Omega>1-p0)=1;Omega(Omega<=1-p0)=0;
A=M.*Omega;

%BOX=cell(3,3);    %第一行为点X、第二行为梯度、第三行为前进方向
BOX={randn(n,k)*randn(k,n) zeros(n) zeros(n);
    zeros(n)    zeros(n)    zeros(n);
    zeros(n)    zeros(n)    zeros(n)};


count=1;
while(count<max_iter)
    %计算梯度
    X=BOX{1,mod(count-1,3)+1};
    [U,~,V]=svds(X,k+5);
    BOX{2,mod(count-1,3)+1}=(U*U')*(A-X).*Omega*(V*V')+(eye(n)-U*U')*(A-X).*Omega*(V*V')+...
            (U*U')*(A-X).*Omega*(eye(n)-V*V');
    %判断是否结束
    xi=BOX{2,mod(count-1,3)+1};
    if(sqrt(xi*xi')<tau)
       break; 
    end
    %计算共轭方向
    xid=BOX{2,mod(count-2,3)+1};
    T=(U*U')*xid*(V*V')+(eye(n)-U*U')*xid*(V*V')+(U*U')*xid*(eye(n)-V*V');
    beta=max(0,trace((xi-T)'*xi)/trace(xi'*xi));
    BOX{3,mod(count-1,3)+1}=-xi+beta*T;
    
    yita=BOX{3,mod(count-1,3)+1};
    alpha=trace(-yita'*xi)/sqrt(trace(yita'*yita)*trace(xi'*xi));
    if(alpha<0.1) 
        BOX{3,mod(count-1,3)+1}=-xi; 
    end
    
    %计算步长
    M0=(U*U')*yita*(V*V')+(eye(n)-U*U')*yita*(V*V')+(U*U')*yita*(eye(n)-V*V');
    t=trace((Omega.*M0)'*(Omega.*(A-X)))/trace((Omega.*M0)'*(Omega.*M0));
    
    im=0;
    while(1)
        [U0,S,V0]=svds(X+xi,k+5);
        X0=U0*S*V0';
        
        fX=0.5*trace(((X-A).*Omega)*((X-A).*Omega)');
        fX0=0.5*trace(((X0-A).*Omega)*((X0-A).*Omega)');
        if(fX-fX0+0.0001*0.5^im*t*trace(xi*yita')>=0)
            break;
        else
            im=im+1;
        end
        if(im>20)
            break;
        end        
    end
    if(im<=20)
        BOX{1,mod(count,3)+1}=X0;
    end   
    rr=0.5*sqrt(trace((Omega.*(X0-A))*(Omega.*(X0-A)')));
    disp(rr)
    
    count=count+1;
end

