function eVec = ndFieldAtPt(rVec,ndWireCollection,chargeDistribution,...
                          plateWidthRadius,plateHeightRadius,...
                          plateSeparationRadius,tol)
    %eVec = ndFieldAtPt(rVec,ndWireCollection,chargeDistribution,plateWidthRadius,plateHeightRadius,plateSeparationRadius,tol)
    %   Compute the electric field experienced at a point rVec
    %   due to the two plates and several wires.

    eVecPlate = dblquadv(@evalIntegralPlate,-plateWidthRadius,plateWidthRadius,...
                                  -plateHeightRadius,plateHeightRadius,...
                                  tol);
    eVec = eVecPlate;

    for i = 1:length(ndWireCollection)
        currWire = ndWireCollection{i};
        eVecWire = quadv(@(t)evalIntegralWires(t,currWire.startPos,...
                                               currWire.endPos),0,1);
        eVecWire = currWire.charge * eVecWire;
        eVec = eVec + eVecWire;
    end

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

       function eVecPartialWires = evalIntegralWires(t,startPos,endPos)
        %eVecPartialWires = evalIntegralWires(t,startPos,endPos)
        %   Core of the simulation: find the field at rVec due to wires
        %   By superposition, this can be integrated with quadv

        srcVec1 = [startPos(1) + (endPos(1) - startPos(1))*t,...
                   startPos(2) + (endPos(2) - startPos(2))*t,...
                   startPos(3) + (endPos(3) - startPos(3))*t];

        eVecPartialWires = (rVec - srcVec1)...
                       ./((norm(rVec - srcVec1))^3);


    end
end