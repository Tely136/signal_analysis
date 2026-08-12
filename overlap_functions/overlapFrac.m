function psi = overlapFrac(a,b,R,f,r,zap,z)
    arguments
        a % aperture radius
        b % obstruction radius
        R % telescope primary radius
        f % telescope focal length
        r % distance from telescope OA
        zap % distance between focal plane and aperture
        z % distance from telescope on OA
    end

    n_r = length(r);
    n_z = length(z);

    aG = repmat(a,n_z,n_r);

    [rG,zG] = meshgrid(r,z);

    nu = nuFunc(zap,f,zG);
    gamma = gammaFunc(zap,f);


    telescope_img = rhoPrime(nu, f, R, zG);
    obstruction_img = rhoPrime(nu,f,b,zG);
    delta = rPrime(gamma, f, rG, zG);

    aperture_telescope_overlap = circleOverlap(aG, telescope_img, delta);
    aperture_obstruction_verlap = circleOverlap(aG, obstruction_img, delta);
    denom = pi * telescope_img.^2;

    psi = (aperture_telescope_overlap - aperture_obstruction_verlap) ./ denom;
end

function n = nuFunc(zap,f,z)
    n = abs(gammaFunc(zap,f) - zap.* z ./ f^2);
end

function g = gammaFunc(zap,f)
    g = 1 + zap / f; 
end

function rhop = rhoPrime(nu,f,rho,z)
    rhop = nu .* f .* rho ./ z;
end

function  rp = rPrime(gamma,f,r,z)
    rp = gamma * f .* r ./ z;
end