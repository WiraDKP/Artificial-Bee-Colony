clear;
clf;

problem = @(x) problemfunc(x);
nvar = 2;

bound.xmin = -10;
bound.xmax = 10;
bound.acc = 1;

param.itermax = 50;
param.npop = 45;

ABC(problem, nvar, bound, param)

% [X,Y] = meshgrid(bound.xmin:0.01:bound.xmax, bound.xmin:0.01:bound.xmax);
% surf(X,Y,-cos(X).*cos(Y).*exp(-((X-pi).^2+(Y-pi).^2)), 'EdgeColor','none');
% view(-40,70); saveas(gcf, 'Easom.png');