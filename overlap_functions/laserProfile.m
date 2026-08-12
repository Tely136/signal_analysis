function f = laserProfile(w,r,prof)
    arg = r ./ w;

    switch prof
        case "gaussian"
            f = gaussianProf(arg);

        case "rectangular"
            f = rectangularProf(arg);

        otherwise
            error("Not a profile type")
    end
end


function f = gaussianProf(x)
    f = exp(-x.^2);
end

function f = rectangularProf(x)
    f = thetaFunc(1-x);
end

function t = thetaFunc(x)
    t = 0.5 * (1 + eFunc(x));
end

function e = eFunc(x)
    e = x ./ abs(x);
end