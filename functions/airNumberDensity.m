function N = airNumberDensity(z)
    [T,~,p] = atmosisa(z);
    N = p ./ physconst('Boltzmann') ./ T;
end