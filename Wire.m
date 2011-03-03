classdef Wire
    %Wire(charge,startPos,endPos)
    %   A class that contains the properties of a straight, charged wire
    %   with a start and end point
    
    properties
        charge;
        startPos;
        endPos;
    end
    
    methods
        %Constructor Method
        function obj = Wire(charge,startPos,endPos)
           %Wire(charge,startPos,endPos)
           %    Creates a charged wire going from startPos to endPos
           obj.charge = charge;
           obj.startPos = startPos;
           obj.endPos = endPos;
        end
        
    end
end
