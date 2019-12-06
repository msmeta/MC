function [RE] = approx_RE(s_n,n,m_n)
% s_n = sample standard deviation
% m_n = sample mean
% n = number of simulations
% approximateive relative error from lecture 1
RE = (s_n/sqrt(n))/m_n;
end

