classdef PlateConfiguration
    %PlateConfiguration(plateWidth,plateHeight,
    %                   plateSeparation,chargeDistribution)
    %   A class that serves as a basic plate configuration 
    %   (two positively charged, rectangular plates).
   
    properties
        lengthFactor; %The r0 term for non-dimensionalization
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
            obj.lengthFactor = obj.plateWidth/2; %Dividing by 2 increases speed
        end
        
        function plotPlates(obj)
            %plotPlates(obj)
            %   Display the plates specified by this configuration
            
            h = obj.plateHeight;
            w = obj.plateWidth;
            
            x = ones(1,5)*obj.plateSeparation/2;
            y = [-w/2,w/2,w/2,-w/2,-w/2];
            z = [h/2,h/2,-h/2,-h/2,h/2];
            plot3(x,y,z,'r');

            hold on

            x = ones(1,5)*-obj.plateSeparation/2;
            y = [-w/2,w/2,w/2,-w/2,-w/2];
            z = [h/2,h/2,-h/2,-h/2,h/2];
            plot3(x,y,z,'r');
            axis equal

            xlabel('X');ylabel('Y');zlabel('Z')
        end
    end
end
