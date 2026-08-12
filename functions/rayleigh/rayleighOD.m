function tau = rayleighOD(c,N,z)
    alpha = sectionToCoefficient(c,N);

    tau = cumtrapz(z, alpha);
end