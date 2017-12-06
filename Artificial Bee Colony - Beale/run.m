clear;
clf;

problem = @(x) problemfunc(x);
nvar = 2;

bound.xmin = -4.5;
bound.xmax = 4.5;
bound.acc = 1;

param.itermax = 50;
param.npop = 45;

ABC(problem, nvar, bound, param)

% [X,Y] = meshgrid(bound.xmin:0.01:bound.xmax, bound.xmin:0.01:bound.xmax);
% surf(X,Y,(1.5 - X + X.*Y).^2 + (2.25 - X + X.*Y.^2).^2 + (2.625 - X + X.*Y.^3).^2, 'EdgeColor','none');
% view(0,90); saveas(gcf, 'Beale2.png');