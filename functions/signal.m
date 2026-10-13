function [N,K,G,B,T] = signal(z,lam,E0,A,tau,eta,etaQ,Nair,co3,No3,O)


    max_z = max(z);
    z_interp = (0.1:3:max_z)';
    Nair_interp = airNumberDensity(z_interp);

    h = planckConstant;                         % J*s
    c = physconst("LightSpeed");                % m/s
    
    N0 = E0 * lam / h / c;                      % 1         number of photons in laser pulse
    K = N0 * A * eta * etaQ * (c * tau / 2);    % m^3       system factor
    
    % Backscatter Coefficient
    B = backScatter(rayleighBackscatterCross_Buckholtz(lam),Nair); % 1 / m / sr 

    % Transmission Term
    c_rayleigh = rayleighCross(lam);

    alpha_rayleigh_interp = sectionToCoefficient(c_rayleigh,Nair_interp);
    alpha_ozone = sectionToCoefficient(co3, No3);

    alpha_ozone_interp = interp1(z,alpha_ozone,z_interp,"linear",0);

    alpha_interp = alpha_rayleigh_interp + alpha_ozone_interp;

    T = transmissionTerm(alpha_interp,z_interp,z);                                 % 1
    T = fillmissing(T,"previous");

    % Geometric term
    G = geometricFactor(O,z);
    G = repmat(G,1,size(No3,2));                                   % 1 / m^2

    N = K .* G .* B .* T;                                           % m^3 / m^2 / m / sr = m * m^2 /m^2 / m / sr = m * sr / m / sr = 1          Number of photons received in range bin defined by speed of light and time tau
end