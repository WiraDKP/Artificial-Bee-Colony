function out = problemfunc(x)
    A = 2; nvar = 2;
    out = A*nvar + x(1).^2 - A*cos(2*pi.*x(1)) + x(2).^2 - A*cos(2*pi.*x(2));
end

