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
        
        function plotWire(obj)
           plot3([obj.startPos(1),obj.endPos(1)],...
                 [obj.startPos(2),obj.endPos(2)],...
                 [obj.startPos(3),obj.endPos(3)],'r'); 
        end
    end
end
