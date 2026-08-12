function A = circleOverlap(R1,R2,D)
% should check that r1 and r2 are same length
    A = NaN(size(R1));

    n = numel(A);
    
    for i = 1:n
        r1 = R1(i);
        r2 = R2(i);

        r12 = r1^2;
        r22 = r2^2;

        d = D(i);

        if d >= r1+r2
            A(i) = 0;
    
        elseif d <= abs(r1-r2)
            A(i) = pi * min(r1, r2)^2; % Area of the smaller circle
    
        else
            A(i) = r12 * acos((d^2 + r12 - r22)/(2*d*r1)) + ...
                   r22 * acos((d^2 + r22 - r12)/(2*d*r2)) - ...
                   0.5 * sqrt(((r1+r2)^2 - d^2) * (d^2 - (r1-r2)^2));
        end
    end
end