function out = problemfunc(x)
    out = -cos(x(1)).*cos(x(2)).*exp(-((x(1)-pi).^2+(x(2)-pi).^2));
end

