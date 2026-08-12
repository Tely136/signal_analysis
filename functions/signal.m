function [N,K,G,B,T] = signal(alt,alt_inst,lam,E0,t_r,o_r,tau,eta,etaQ,Nair,co3,No3)
    n_prof = size(No3,2);
    
    A = pi * (t_r^2 - o_r^2);
    h = planckConstant;
    K = E0 * A * eta * etaQ * (tau /2) * (lam / h);
    
    % Backscatter Coefficient
    B = backScatter(rayleighBackscatterCross_Buckholtz(lam),Nair);
    B = repmat(B',1,n_prof);

    % Transmission Term
    c_rayleigh = rayleighCross(lam);

    alpha_rayleigh = sectionToCoefficient(c_rayleigh,Nair);
    alpha_ozone = sectionToCoefficient(co3, No3);

    alpha = repmat(alpha_rayleigh',1, n_prof) + alpha_ozone;
    dz = alt - alt_inst;
    T = transmissionTerm(alpha,dz); % still need to fix transmission term

    % Geometric term
    O = ones(size(alt)); % assume overlap function is unity for now
    G = geometricFactor(O,alt);
    G = repmat(G',1,size(No3,2));

    N = K .* G .* B .* T;
end