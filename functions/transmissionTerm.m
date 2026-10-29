function T = transmissionTerm(alpha_interp,z_interp,z)
%TRANSMISSIONTERM Two-way transmission for extinction in m^-1 and range in m.
% Rows are range bins; columns are separate profiles. Output is numel(z) x
% number of profiles. Optical depth is zero at z_interp(1): include the full
% propagation path in the supplied extinction grid when absolute T matters.
% Query points outside this grid return NaN; no extrapolation is assumed.
    z_interp = z_interp(:);
    z = z(:);
    if isvector(alpha_interp), alpha_interp = alpha_interp(:); end
    assert(numel(z_interp) >= 2 && all(isfinite(z_interp)) && ...
        all(diff(z_interp) > 0), 'Extinction grid must be finite and increasing.');
    assert(ismatrix(alpha_interp) && size(alpha_interp,1) == numel(z_interp) && ...
        all(isfinite(alpha_interp),'all'), ...
        'Extinction must be finite, with one row per extinction-grid point.');
    assert(all(isfinite(z)), 'Requested ranges must be finite.');

    % Integrate ALL columns along range. Interpolate optical depth before
    % exponentiating, rather than linearly interpolating transmission itself.
    opticalDepth = cumtrapz(z_interp,alpha_interp,1);
    T = exp(-2 * interp1(z_interp,opticalDepth,z,'linear'));
end
