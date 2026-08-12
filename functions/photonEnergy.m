function E = photonEnergy(lam)
    c = physconst("LightSpeed");
    h = planckConstant;

    E = h * c / lam;
end