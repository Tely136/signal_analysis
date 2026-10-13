function T = transmissionTerm(alpha_interp,z_interp,z)
    n_row = length(z);
    n_col = size(alpha_interp,2);

    T = NaN(n_row,n_col);
    for i = 1:n_col
        T_temp = exp(-2 * cumtrapz(z_interp,alpha_interp));

        T(:,i) = interp1(z_interp,T_temp,z);
    end
end