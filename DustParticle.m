classdef DustParticle
    %DustParticle(position,velocity,[radius,mass])
    %   A class that contains the information needed to
    %   represent a charged dust particle.
   
    properties
        %Standard defaults
        isAlive = 1;
        
        %Must be set on a per-particle basis
        position;
        velocity;
        
        %May be set on a per-particle basis
        radius = 0.001;    %m
        mass = 7.53^(-10); %kg
        charge = -1.60217646*10^(-19); %C %Charge on an electron
        %charge = 0;
        
    end
    
    methods
        %Constructor Method
        function obj = DustParticle(position,velocity,varargin)
            %DustParticle(position,velocity,[charge,[radius,[mass]]])
            %   Creates a dust particle at vector 'position', moving with a
            %   vector 'velocity'
            
            obj.velocity = velocity;
            obj.position = position;
            
            %Optional parameter configuration
            switch length(varargin)
                case 0
                    
                case 1
                    obj.charge = varargin{1};
                case 2
                    obj.charge = varargin{1};
                    obj.radius = varargin{2};
                case 3
                    obj.charge = varargin{1};
                    obj.radius = varargin{2};
                    obj.mass = varargin{3};
                otherwise
                    error(strcat('DustParticle(position,velocity,[charge,[radius,[mass]]])',...
                        ' constructor can take 2 - 5 arguments'));
            end

        end
        
        function obj = kill(obj)
            %kill()
            %   Call when a particle is collected  
            
            obj.velocity = [0,0,0];
            obj.isAlive = 0;
        end
        
        function obj = assignCharge(obj)
           obj.charge = -1.60217646*10^(-19);
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
