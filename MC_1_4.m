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
put_price_crude = mean(put_prices_0)
var_crude = var(put_prices_0)

approx_RE=approx_RE(sqrt(var_crude),N1,put_price_crude);
CI_crude = [put_price_crude-1.96*sqrt(var_crude)/sqrt(N1),put_price_crude+1.96*sqrt(var_crude)/sqrt(N1)]
CI2 = [quantile(put_prices_0,0.025),quantile(put_prices_0,0.975)]
%%
S_T = @(S0,T,Z) S0*exp((r-sigma^2/2)*T+sqrt(T)*sigma*Z);
k=30;
b=linspace(S_T(S0,T2,-2),S_T(S0,T2,2),k)';
dvec=dval(b,S0,r,sigma,T2);
probs=normcdf(dvec);
p=[probs(1);probs(2:end)-probs(1:end-1);1-probs(end)];

S=[];
N=[];
sigmas=[];
for i=1:k+1
    if(i==1)
        Stemp=put_prices_0(S_T2 < b(i));
    elseif(i==k+1)
        Stemp=put_prices_0(b(i-1)<S_T2);
    else
        Stemp=put_prices_0(b(i-1)<S_T2 & S_T2 < b(i));
    end
    sigmas=[sigmas;var(Stemp)];
    S=[S;sum(Stemp)];
    N=[N;numel(Stemp)];
end

% vanliga estimatorn fast undvik termer där N=0
put_price_poststrat = sum(p(N>0).*S(N>0)./N(N>0))
% konfidensintervall föreläsning 11
% dubbelkolla variansen, detta är skattningar av sigma^2_i
% undviker NAN i sigmas med index
var_poststrat = sum(sigmas(sigmas>0).*p(sigmas>0))

function d = dval(b,S0,r,sigma,T)
d=(log(b/S0)-(r-sigma^2/2)*T)/(sqrt(T)*sigma);
end