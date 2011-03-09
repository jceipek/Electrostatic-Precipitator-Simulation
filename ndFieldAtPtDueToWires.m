function eVecWires = ndFieldAtPtDueToWires(rVec,ndWireCollection,tol)
               
    eVecWires = 0;
    for i = 1:length(ndWireCollection)
        currWire = ndWireCollection{i};
        eVecWire = quadv(@(t)evalIntegralWires(t,currWire.startPos,...
                                               currWire.endPos),0,1,tol);
        eVecWire = currWire.charge * eVecWire;
        eVecWires = eVecWires + eVecWire;
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