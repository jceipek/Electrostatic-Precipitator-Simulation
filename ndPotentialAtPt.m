function vVec = ndPotentialAtPt(rVec,ndWireCollection,chargeDistribution,...
                          plateWidthRadius,plateHeightRadius,...
                          plateSeparationRadius,tol)
    %vVec = ndPotentialAtPt(rVec,ndWireCollection,chargeDistribution,plateWidthRadius,plateHeightRadius,plateSeparationRadius,tol)
    %   Compute the potential experienced at a point rVec
    %   due to the two plates and several wires.

    vVecPlate = dblquadv(@evalIntegralPlate,-plateWidthRadius,plateWidthRadius,...
                                  -plateHeightRadius,plateHeightRadius,...
                                  tol);
    vVec = vVecPlate;

    for i = 1:length(ndWireCollection)
        currWire = ndWireCollection{i};
        vVecWire = quadv(@(t)evalIntegralWires(t,currWire.startPos,...
                                               currWire.endPos),0,1);
        vVecWire = currWire.charge * vVecWire;
        vVec = vVec + vVecWire;
    end
    

    function vVecPartialPlate = evalIntegralPlate(y,z)
        %vVecPartialPlate = evalIntegralPlate(y,z)
        %   Core of the simulation: find the potential at rVec due to y,z
        %   By superposition, this can be integrated with dblquadv

        srcVec1 = [-plateSeparationRadius,y,z];
        srcVec2 = [plateSeparationRadius,y,z];

        vVecPartial1 = chargeDistribution/2 ...
                       ./((norm(rVec - srcVec1)));
        vVecPartial2 = chargeDistribution/2 ...
                       ./((norm(rVec - srcVec2)));

        vVecPartialPlate = vVecPartial1 + vVecPartial2;

    end

    function vVecPartialWires = evalIntegralWires(t,startPos,endPos)
        %vVecPartialWires = evalIntegralWires(t,startPos,endPos)
        %   Core of the simulation: find the potential at rVec due to wires
        %   By superposition, this can be integrated with quadv

        srcVec1 = [startPos(1) + (endPos(1) - startPos(1))*t,...
                   startPos(2) + (endPos(2) - startPos(2))*t,...
                   startPos(3) + (endPos(3) - startPos(3))*t];

        vVecPartialWires = 1/norm(rVec - srcVec1);


    end
end