% uppg 3
clear

r=0.03;
S1=75;
S2=50;
sigma_1=0.3;
sigma_2=0.2;
K=65;
T=8;

N=1000;

rho=0;
S_t=@(S1,S2) 0.55*S1+0.45*S2;

monitoring_dates=linspace(0,T,81); monitoring_dates=monitoring_dates(2:end)';
t=monitoring_dates(1);

Z1=randn(N,80); Z2=randn(N,80);
S_1=@(S0,T,Z1) S0.*exp((r-sigma_1^2/2)*T+sqrt(T)*sigma_1*Z1);
S_2=@(S0,T,Z1,Z2) S0.*exp((r-sigma_2^2/2)*T+sqrt(T)*sigma_2*(rho*Z1+sqrt(1-rho^2)*Z2));
asian=@(x) max(mean(x)-K,0);

S=[];
S_1vec=[];
S_2vec=[];
asian_call=[];

S_1vec=[S_1vec,S_1(S1*ones(N,1),t,Z1(:,1))];
%S_1vec=S1*exp((r-sigma^2/2)*t+sqrt(t)*sigma_1*Z1(:,1))
S_2vec=[S_2vec,S_2(S2*ones(N,1),t,Z1(:,1),Z2(:,1))];
%S_2vec=S2*exp((r-sigma^2/2)*t+sqrt(t)*sigma_2*(rho*Z1(:,1)+sqrt(1-rho^2)*Z2(:,1)));
S=[S,S_t(S_1vec(:,1),S_2vec(:,1))];

for i=2:80
    temp1=S_1(S_1vec(:,i-1),t,Z1(:,i));
    temp2=S_2(S_2vec(:,i-1),t,Z1(:,i),Z2(:,i));
    S=[S,S_t(temp1,temp2)];
    S_1vec=[S_1vec,temp1];
    S_2vec=[S_2vec,temp2];
end

for i = 1:N
    asian_call=[asian_call;asian(S(i,:))];
end

asian_crude=mean(asian_call)
asian_crude_var=var(asian_call)