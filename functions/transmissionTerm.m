function T = transmissionTerm(alpha,dz)
    T = NaN(size(alpha));
    cols = size(alpha,2);

    dz = dz';
    id = dz>=0;

    for i = 1:cols
        T(id,i) = exp(-2 * cumtrapz(dz(id),alpha(id,i)));
    end
end