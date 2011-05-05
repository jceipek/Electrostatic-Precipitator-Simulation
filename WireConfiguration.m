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
        
        function plotWires(obj)
            for i = 1:length(obj.wireCollection)
                obj.wireCollection{i}.plotWire;
            end
        end
    end
end
