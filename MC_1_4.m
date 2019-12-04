% uppg4
clear

r=0.025;
T1=6;
T2=3;
sigma=0.3;
K=19;
S0=300;
L=300;

N1=1000;
N2=1000;

put_0 = @(x) exp(-r*T2)*max(K-x,0);
call_T2 = @(x) exp(-r*(T1-T2))*max(x-L,0);

% simulate values of the underlying at time T2
Z1=randn(N1,1);
S_T2 = S0*exp((r-sigma^2/2)*T2+sqrt(T2)*sigma*Z1);

% call prices at time T2
Z2 = randn(N1,N2);
call_prices_T2=[];
for i=1:N1
    S_T1 = S_T2(i)*exp((r-sigma^2/2)*3+sqrt(3)*sigma*Z2(i,:)');
    call_prices_T2=[call_prices_T2; mean(call_T2(S_T1))];
end

% put prices at time 0
put_prices_0 = put_0(call_prices_T2);