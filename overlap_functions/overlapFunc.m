function O = overlapFunc(z,laser_beamwaist, laser_divergence, aperture_radius, obstruction_radius, telescope_radius, telescope_focus, za, delta, prof_type)
    O = NaN(1,length(z));

    for i = 1:length(z)
        z_current = z(i);
        w_current = laserBeamWidth(laser_beamwaist,laser_divergence,z_current);
    
        O(i) = (telescope_radius^2 / (telescope_radius^2 - obstruction_radius^2)) * (1/(pi * w_current^2)) * integral2(@(r,theta) fun(r, theta, z_current, laser_beamwaist, laser_divergence, aperture_radius, obstruction_radius, telescope_radius, telescope_focus, za, delta, prof_type), 0, Inf, 0, 2*pi);
    end
end

function A = fun(r,theta,z,w0,phi,a,b,R,f,zap,delta,prof_type)
    w = laserBeamWidth(w0,phi,z);

    rp = @(r,theta,delta) sqrt(r.^2 + delta.^2 - 2*delta.*r.*cos(theta));

    F =  laserProfile(w,rp(r,theta,delta),prof_type);

    psi = overlapFrac(a,b,R,f,r,zap,z);

    A = psi .* F .* r;
end