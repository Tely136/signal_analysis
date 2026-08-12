function [w,theta,R,zr] = laserBeamProp(w0,lam,z)

    zr = rayleighRange(w0,lam);

    theta = divergence(w0, lam);

    w = beamWidth(w0,zr,z);

    R = phaseRadius(zr,z);
end

function w = beamWidth(w0,zr,z)
    w = w0 * sqrt(1 + (z./zr).^2);
end

function zr = rayleighRange(w0,lam)
    zr = pi * w0^2 / lam;
end

function theta = divergence(w0,lam)
    theta = lam / pi / w0;
end

function R = phaseRadius(zr,z)
    R = z + zr.^2 ./ z;
end