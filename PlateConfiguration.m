classdef PlateConfiguration
    %PlateConfiguration(plateWidth,plateHeight,
    %                   plateSeparation,chargeDistribution)
    %   A class that serves as a basic plate configuration 
    %   (two positively charged, rectangular plates).
   
    properties
        lengthFactor;
        chargeDistribution;
        
        %Plate Properties
        plateWidth;
        plateHeight;
        plateSeparation;
    end
    
    methods
        %Constructor Method
        function obj = PlateConfiguration(plateWidth,...
                                          plateHeight,...
                                          plateSeparation,...
                                          chargeDistribution)
            %PlateConfiguration(plateWidth,plateHeight,
            %                   plateSeparation,chargeDistribution)
            %   Creates two rectangular plates plateSeparation apart, with
            %   dimensions plateWidth, plateHeight. The charge distribution
            %   for a given plate is a constant chargeDistribution.
            
            obj.plateWidth = plateWidth;
            obj.plateHeight = plateHeight;
            obj.plateSeparation = plateSeparation;
            obj.chargeDistribution = chargeDistribution;
            obj.lengthFactor = obj.plateWidth;
        end
    end
end
