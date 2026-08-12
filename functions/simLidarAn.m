function P = simLidarAn(paramPath)
    a = load(paramPath);

    % System factor
    P0 = a.E0/a.tau;
    A = pi * (a.telescope_radius^2 - a.obstruction_radius^2);
    
    K = systemFactor(P0,a.tau,A,a.eta);

    % Overlap Function
    O = overlapFunc(a.R,a.laser_beamwaist, a.laser_divergence, a.aperture_radius, a.obstruction_radius, a.telescope_radius, a.telescope_focus, a.za, a.delta, "gaussian");
    G = geometricFactor(O,a.R);

    % Backscatter Coefficient
    dc_rayleigh = rayleighBackscatterCross(a.lambda);
    dc = dc_rayleigh;

    B = backScatter(dc_rayleigh,a.N);

    % Transmission term
    c_rayleigh = rayleighCross(a.lambda);
    % co3 = 0;
    % No3 = zeros(size(a.R)); % change

    alpha_rayleigh = sectionToCoefficient(c_rayleigh,a.N);
    % alpha_ozone = sectionToCoefficient(co3,No3);

    alpha = alpha_rayleigh;
    T = transmissionTerm(alpha,a.R);

    % Full Equation
    P = K .* G .* B .* T;
end