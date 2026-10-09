function [NB, CB] = background(lambda,A,tau,etaR,BW,FOV,L_lam)
    h = planckConstant;
    c = physconst("LightSpeed");

    Omega = FOV^2 * pi / 4;

    NB = etaR * L_lam * A * Omega * BW * tau * (lambda / h / c);
    CB = NB ./ tau;
end