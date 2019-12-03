% uppg 2

r=0.019;
T=6;
sigma=0.25;
K=250;
S0=100;

N=10000;

h=@(x) max(S0*exp((r-(1/2)*sigma^2)*T+sqrt(T)*sigma*x)-K,0);
f=@(x) (1/sqrt(2*pi))*exp(-(1/2)*x.^2);

%exact=blsprice(100,100,r,T,sigma);
exact=bsexact(sigma, r, K, T, S0);

Z=randn(N,1);
crude_mc=exp(-r*T)*max(S0*exp((r-(1/2)*sigma^2)*T+sqrt(T)*sigma*Z)-K,0);

crude_alpha_tilde=mean(crude_mc);
var_crude=var(crude_mc);

g=@(x) 1/crude_alpha_tilde*(log(K/S0)-crude_alpha_tilde/2<x<log(K/S0)+crude_alpha_tilde/2);
gp=@(x) 1/sqrt(2*pi*sigma^2*T)*exp(-(x-log(K/S0)-(r-sigma^2/2)*T).^2/(2*sigma^2*T));

importance_mc=[];
importance_estimator = @(x) h(x).*f(x)./gp(x);
%Z2=rand(N,1)*crude_alpha_tilde+log(K)-crude_alpha_tilde/2;
Z2=randn(N,1)*(sigma*sqrt(T))+log(K/S0)+(r-sigma^2/2)*T;
importance_mc=[importance_mc, importance_estimator(Z2)];
importance_alpha_tilde=mean(importance_mc);
var_importance=var(importance_mc);