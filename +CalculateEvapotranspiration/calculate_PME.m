function PME = calculate_PME(DELTAA, Rn, gama, Gasphaseparameterconstants,num_steps)
    for iN = 1:num_steps
        % simplified form ignoring wind speed and vapor pressure difference
        PME(iN) = DELTAA(iN) * Rn(iN) / (Gasphaseparameterconstants.lambdav * (DELTAA(iN) + gama));

    end
end
