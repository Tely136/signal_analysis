function w = laserBeamWidth(w0,phi,z)
    w = sqrt(w0^2 + (phi.*z).^2);
end