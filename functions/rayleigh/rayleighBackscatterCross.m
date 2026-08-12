function dc = rayleighBackscatterCross(lam)
    ns = indexOfRefraction(lam);
    Ns = surfaceAirDensity;

    dc = 9 * pi^2 * ((ns.^2-1)./(ns.^2+2)).^2 ./ (lam.^4 * Ns^2);
end