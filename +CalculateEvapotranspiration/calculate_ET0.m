function PT_PM_0 = calculate_ET0(DELTAA, Rn, gama, es, e_a, u_2, Tm,num_steps)
for iN = 1:num_steps
    % PT/PE - Penman-Monteith
    % mm.day-1 FAO56 pag19 eq3
    PT_PM_0(iN) = (0.408 * DELTAA(iN) * Rn(iN) + gama * (900 / (Tm(iN) + 273)) * (es(iN) - e_a(iN)) * u_2(iN)) / (DELTAA(iN) + gama * (1 + 0.34 * u_2(iN)));
end

end
