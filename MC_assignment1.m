% 1a

clear
% barycentric coordinates

% v(:,1) = v(:,9)
v=[cos(pi*[0:8]/4);sin(pi*[0:8]/4)];

points = Uniform_K(3000);

plot(v(1,:),v(2,:));
hold on
plot(points(1,:),points(2,:),'x');

%%
% 1b

clear
% acceptance-rejection 

% f = @(x) (sin(7*(2*x(1)^2+3*x(2)^2)))^2;
% acceptance probability function with M = 2*sqrt(2)
% alpha = @(x) f(x)/(2^(3/2));
v=[cos(pi*[0:8]/4);sin(pi*[0:8]/4)];
points = f_K(3000);

plot(v(1,:),v(2,:));
hold on
plot(points(1,:),points(2,:),'x');

%%

function points = Uniform_K(n)
% draws n points uniformly distributed in K
v=[cos(pi*[0:8]/4);sin(pi*[0:8]/4)];

points = [];

for i=1:n
    % choose one random octant from 1 to 8
    corner = floor(8*rand+1);
    s = rand; t = rand;
    % map the uniform r.v.s s,t to the correct triangle
    % using two corners from the octagon and (0,0) as the third
    point = t*s^(1/2)*v(:,corner) + (1-t)*s^(1/2)*v(:,corner+1);
    points = [points, point];
end
end

function points = f_K(n)
points = [];
% define the acceptance probability function
alpha = @(x) ((sin(7*(2*x(1)^2+3*x(2)^2)))^2)/(2^(3/2));
% generate n points
accepted=0;
while(accepted < n)
    x = Uniform_K(1);
    % the probablitiy that a uniform random variable is 
    % larger than alpha is the rejection probability
    accept = rand < alpha(x);
    if(accept == true)
        points = [points,x];
        accepted = accepted+1;
    end
end
end