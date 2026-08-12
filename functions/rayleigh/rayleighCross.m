function c = rayleighCross(lam)
    % returns rayleigh scattering cross section in m^2
    % input is wavelength in m

    % ns = indexOfRefraction(lam);
    % Ns = surfaceAirDensity;

    % c = 24 * pi^3 * (ns.^2 - 1).^2 ./ (lam.^4 .* Ns^2 .* (ns.^2 + 2).^2);
    % c = c .* 1.056;

    lam = lam .*1e6;

    A = 3.01577e-28;
    B = 3.55212;
    C = 1.35579;
    D = 0.11563;
    c = A .* lam .^ -(B + C.*lam + D./lam) .* 1e-4;
end