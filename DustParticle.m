classdef DustParticle
    %DustParticle(position,velocity,[radius,mass])
    %   A class that contains the information needed to
    %   represent a charged dust particle.
   
    properties
        %Standard defaults
        isAlive = 1;
        charge = -1.60217646*10^(-19); %C %Charge on an electron

        %Must be set on a per-particle basis
        position;
        velocity;
        
        %May be set on a per-particle basis
        radius = 0.001;    %m
        mass = 7.53^(-10); %kg
    end
    
    methods
        %Constructor Method
        function obj = DustParticle(position,velocity,varargin)
            %DustParticle(position,velocity,[radius,mass])
            %   Creates a dust particle at vector 'position', moving with a
            %   vector 'velocity'
            
            obj.velocity = velocity;
            obj.position = position;
            
            %Optional parameter configuration
            if length(varargin) == 2
                obj.radius = varargin{1};
                obj.mass = varargin{2};
            elseif ~isempty(varargin)
                %Incorrect # of args specified
                error(strcat('DustParticle(position,velocity,[radius,mass])',...
                             ' constructor can take 2 or 4 arguments'));
            end
        end
        
        function obj = kill(obj)
            %kill()
            %   Call when a particle is collected  
            
            obj.velocity = [0,0,0];
            obj.isAlive = 0;
        end
        
        function plotParticleState(obj)
            if obj.isAlive
                plot3(obj.position(1),obj.position(2),obj.position(3),'bo');
            else
                plot3(obj.position(1),obj.position(2),obj.position(3),'ko');
            end
        end
        
    end
end
