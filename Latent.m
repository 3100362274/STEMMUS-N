function [L]= Latent(TT,NN)
%calculate the latent heat of vaporization of water
    
    for MN = 1:NN
        L(MN) = (2.501 * 10^6 - 2369.2 * TT(MN)) / 1000;
    end

end
