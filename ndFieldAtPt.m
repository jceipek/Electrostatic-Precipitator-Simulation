function eVec = ndFieldAtPt(rVec,ndWireCollection,chargeDistribution,...
                          plateWidthRadius,plateHeightRadius,...
                          plateSeparationRadius,tol)
    %eVec = ndFieldAtPt(rVec,ndWireCollection,chargeDistribution,plateWidthRadius,plateHeightRadius,plateSeparationRadius,tol)
    %   Compute the electric field experienced at a point rVec
    %   due to the two plates and several wires.

    eVecPlate = ndFieldAtPtDueToPlate(rVec,chargeDistribution,...
                          plateWidthRadius,plateHeightRadius,...
                          plateSeparationRadius,tol);
    
    eVecWires = ndFieldAtPtDueToWires(rVec,ndWireCollection,tol);
                      
    eVec = eVecPlate + eVecWires;

end