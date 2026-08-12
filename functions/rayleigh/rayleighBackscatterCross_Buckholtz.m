function dc = rayleighBackscatterCross_Buckholtz(lam)
    % takes wavelength in meters
    % calculates rayleigh backscattering cross section in m^2/sr
    
    % multiply by air number density in m^-3 to get backscatter coefficient
    % in 1/m/sr

    dc = rayleighCross(lam) .* rayleighPhaseFunction(pi) ./ (4*pi);
end