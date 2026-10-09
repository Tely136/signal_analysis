function [N, N_nsy] = add_noise(NS,NB,navg)
    N = NS + NB;
    N_nsy = poissrnd(N.*navg) ./ navg;
   
end