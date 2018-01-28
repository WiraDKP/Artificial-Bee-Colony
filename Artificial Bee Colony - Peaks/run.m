clear;
clf;

problem = @(x) problemfunc(x);
nvar = 2;

bound.xmin = -3;
bound.xmax = 3;
bound.acc = 1;

param.itermax = 50;
param.npop = 21;

ABC(problem, nvar, bound, param)

% [X,Y] = meshgrid(bound.xmin:0.01:bound.xmax, bound.xmin:0.01:bound.xmax);
% surf(X,Y,3*(1-X).^2.*exp(-(X.^2) - (Y+1).^2) - 10*(X/5 - X.^3 - Y.^5).*exp(-X.^2-Y.^2) ... 
%                 - 1/3*exp(-(X+1).^2 - Y.^2), 'EdgeColor','none');
% view(40,55); saveas(gcf, 'Peak.png');