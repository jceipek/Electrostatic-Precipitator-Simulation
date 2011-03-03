classdef WireConfiguration
    %WireConfiguration([wire1],[wire2],[...])
    %   A class that contains the information needed to
    %   represent a collection of charged wires.
    
    properties
        wireCollection = {};
    end
    
    methods
        %Constructor Method
        function obj = WireConfiguration(varargin)
            %WireConfiguration([wire1],[wire2],[...])
            %   Creates a wireconfiguration from several wires
            
            obj.wireCollection = varargin;
        end
        
        function obj = addWire(obj,wire)
            %addWire(obj,wire)
            %   Add a new wire to the collection
            
            obj = [obj.wireCollection {wire}];
        end
        
    end
end
