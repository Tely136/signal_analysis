function n = indexOfRefraction(lam)
    % takes wavelength in meters, convert to um for formulas

    % need to look at this

    n = NaN(size(lam));

    greater = lam > 230e-9;
    less = ~greater;

    lam_u  = lam .* 1e6;
    
    % lam <= 230 nm
    n(less) = 1 + 1e-8 .* (8060.51 + 2480990./(132.274 - lam_u(less).*1e-2) + 17455.7./(39.32957 - lam_u(less).*1e-2));

    % lam > 230 nm
    n(greater) = 1 + 1e-8 .* (5791817 ./ (238.0185 - lam_u(greater).*1e-2) + 167909 ./ (57.362 - lam_u(greater).*1e-2));
end