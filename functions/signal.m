function [N,K,G,B,T] = signal(alt,lam,E0,A,tau,eta,etaQ,Nair,co3,No3,O)
    n_prof = size(No3,2);

    h = planckConstant;                         % J*s
    c = physconst("LightSpeed");                % m/s
    
    N0 = E0 * lam / h / c;                      % 1         number of photons in laser pulse
    K = N0 * A * eta * etaQ * (c * tau / 2);    % m^3       system factor
    
    % Backscatter Coefficient
    B = backScatter(rayleighBackscatterCross_Buckholtz(lam),Nair); % 1 / m / sr 
    B = repmat(B,1,n_prof);

    % Transmission Term
    % Can be made better by ensuring sufficiently narrow grid for integral
    c_rayleigh = rayleighCross(lam);

    alpha_rayleigh = sectionToCoefficient(c_rayleigh,Nair);
    alpha_ozone = sectionToCoefficient(co3, No3);

    alpha = repmat(alpha_rayleigh,1, n_prof) + alpha_ozone;
    dz = alt - alt(1);
    T = transmissionTerm(alpha,dz);                                 % 1

    % Geometric term
    G = geometricFactor(O,dz);
    G = repmat(G,1,size(No3,2));                                   % 1 / m^2

    N = K .* G .* B .* T;                                           % m^3 / m^2 / m / sr = m * m^2 /m^2 / m / sr = m * sr / m / sr = 1          Number of photons received in range bin defined by speed of light and time tau
end