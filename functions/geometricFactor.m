function G = geometricFactor(O,R)
    G = O ./ R.^2;
    G(R==0) = NaN;
    G = fillmissing(G,"nearest");
end