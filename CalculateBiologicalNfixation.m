function [BNF]=CalculateBiologicalNfixation(DeltZ,NL)

    % The biological fixation of N occurs at all stands with an ex-ception for agricultural stands.There,it is applied only forthe nodulating leguminous crops pulses and soybean.Forthese two crops,biological N fixation(BNF)is simply thedifference between N demand and N uptake,basically firstusing the easily plant-available N from the soils and then fix-ing extra N at no extra cost.
    % For natural vegetation and grass-lands,
    % the function from Cleveland et al.(1999)is applieddepending on the 20-year 
    % average annual evapotranspiration(etp;in mm yr−1).BNF(in g N m−2d−1)is 
    % assumed to onlyoccur if there is a minimum root biomass of 20 g C m−2.
    % all N fixed by BNF is assumed to enter the system as ammoniumin the upper soil layer(l=1).
    etp=10;
    DeltZ1=DeltZ(NL);
    if etp > 7.35
        BNF=max(0,(0.0234*etp-0.172)/10/365/DeltZ1/864);%BNF(in g N m−2d−1)-> 1/864/DeltZ1 BNF(in pg N cm−3.s−1)
    else
        BNF=0;
    end
