function eVecPlate = ndFieldAtPtDueToPlate(rVec,chargeDistribution,...
                          plateWidthRadius,plateHeightRadius,...
                          plateSeparationRadius,tol)
                      
    eVecPlate = dblquadv(@evalIntegralPlate,-plateWidthRadius,plateWidthRadius,...
                              -plateHeightRadius,plateHeightRadius,...
                              tol);
                          
	function eVecPartialPlate = evalIntegralPlate(y,z)
        %eVecPartialPlate = evalIntegralPlate(y,z)
        %   Core of the simulation: find the field at rVec due to y,z
        %   By superposition, this can be integrated with dblquadv

        srcVec1 = [-plateSeparationRadius,y,z];
        srcVec2 = [plateSeparationRadius,y,z];

        eVecPartial1 = chargeDistribution*(rVec - srcVec1)...
                       ./((norm(rVec - srcVec1))^3);
        eVecPartial2 = chargeDistribution*(rVec - srcVec2)...
                       ./((norm(rVec - srcVec2))^3);

        eVecPartialPlate = eVecPartial1 + eVecPartial2;

    end       
                      
end