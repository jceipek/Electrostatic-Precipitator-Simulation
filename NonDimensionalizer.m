classdef NonDimensionalizer
    %NonDimensionalizer(particle,plateConfig)
    %   A class that contains the information needed to
    %   non-dimensionalize the properties of plates and particles
    %   effectively (i.e. r0, t0).
   
    properties
        t0;
        r0;
    end
    
    methods
        %Constructor Method
        function obj = NonDimensionalizer(particle,plateConfig)
            %NonDimensionalizer(particle,plateConfig)
            %   Constructs a Non-dimensionalizer
            
            e0 = 8.854187817*10^(-12); %F/m
            obj.r0 = plateConfig.lengthFactor;
            obj.t0 = (obj.r0^3*4*pi*e0*particle.mass/...
                     (abs(particle.charge)*...
                     plateConfig.chargeDistribution))^(1/2);
        end
        
        function ndPos = ndPos(obj,pos)
            %ndPos = ndPos(pos)
            %   Non-dimensionalizes a position
            
            ndPos = pos/obj.r0;
        end 
        function pos = dPos(obj,ndPos)
            %pos = dPos(ndPos)
            %   Dimensionalizes a non-dimensionalized position
            
            pos = ndPos*obj.r0;
        end
        
        function ndTime = ndTime(obj,time)
            %ndTime = ndTime(time)
            %   Non-dimensionalizes a time
            
            ndTime = time/obj.t0;
        end
        function time = dTime(obj,ndTime)
            %time = dTime(ndTime)
            %   Dimensionalizes a non-dimensionalized time
            
            time = ndTime*obj.t0;
        end
        
        function ndVel = ndVel(obj,vel)
            %ndVel = ndVel(vel)
            %   Non-dimensionalizes a velocity
            
            ndVel = vel/obj.r0*obj.t0;
        end
        function vel = dVel(obj,ndVel)
            %time = dTime(ndTime)
            %   Dimensionalizes a non-dimensionalized velocity
            
            vel = ndVel*obj.r0/obj.t0;
        end
        
    end
end
