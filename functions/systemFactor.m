function K = systemFactor(P0,tau,A,eta)
    K = P0 * physconst("LightSpeed") * tau * A * eta / 2;
end