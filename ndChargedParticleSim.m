function [T,W] = ndChargedParticleSim(particle,plateConfig,nD,duration,varargin)
    %ndChargedParticleSim(particle,plateConfig,nD,duration,[tol])
    %   Simulate a particle moving in plates defined by 'plateConfig'

    %Handle variable argument count
    if length(varargin) == 1
        tol = varargin{1};
    elseif ~isempty(varargin)
        %Incorrect # of args specified
        error(strcat('ndChargedParticleSim(particle,plateConfig,nD,duration,[tol])',...
                 ' takes 4 or 5 arguments.'));
    end

    
    chargeDistribution = plateConfig.chargeDistribution;
    
    %%%%%%%%%%%%%%%%%%% Non-dimensionalize %%%%%%%%%%%%%%%%%%%
    plateSeparationRadius = nD.ndPos(plateConfig.plateSeparation/2);
    plateWidthRadius = nD.ndPos(plateConfig.plateWidth/2);
    plateHeightRadius = nD.ndPos(plateConfig.plateHeight/2);

    particlePosition = nD.ndPos(particle.position);
    particleVelocity = nD.ndVel(particle.velocity);
    duration = nD.ndTime(duration);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Perform the simulation
    [T,W] = ode45(@simulate, [0, duration], ...
       [particlePosition,particleVelocity],...
        odeset('Events', @collected,'AbsTol',tol));

    %%%%%% Re-dimensionalize %%%%%%
    W(:,1:3) = nD.dPos(W(:,1:3));
    W(:,4:6) = nD.dVel(W(:,4:6));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
    function delta=simulate(t,W)
        %delta=simulate(t,W)
        %   ODE-compatible simulator for a particle
        
        rVec = W(1:3)';
        vVec = W(4:6);

        dRdt = vVec;
        
        %Direction depends on charge
        dVdt = sign(particle.charge)*plateFieldAtPt(rVec);
        
        delta = [dRdt; dVdt'];
    end

    function [distToWall,isterminal,direction] = collected(t,W)
        %[distToWall,isterminal,direction] = collected(t,W)
        %   Termination event fuction used to see if particles are
        %   collected because they hit the plates.
        
        %Two conditions: pass left or right plate
        distToWall = [plateSeparationRadius - W(1);...
                    -plateSeparationRadius - W(1)]; 
        
        isterminal = [1;1]; %terminate in both cases
        direction = [-1;1]; %Decreasing, increasing
    end

    function eVec = plateFieldAtPt(rVec)
        %eVec = plateFieldAtPt(rVec)
        %   Compute the electric field experienced at a point rVec
        %   due to the two plates.
     
        eVec = dblquadv(@evalIntegral,-plateWidthRadius,plateWidthRadius,...
                                      -plateHeightRadius,plateHeightRadius,...
                                      tol);
        
        function eVecPartial = evalIntegral(y,z)
            %eVecPartial = evalIntegral(y,z)
            %   Core of the simulation: find the field at rVec due to y,z
            %   By superposition, this can be integrated with dblquadv
            
            srcVec1 = [-plateSeparationRadius,y,z];
            srcVec2 = [plateSeparationRadius,y,z];
            
            eVecPartial1 = chargeDistribution*(rVec - srcVec1)...
                           ./((norm(rVec - srcVec1))^3);
            eVecPartial2 = chargeDistribution*(rVec - srcVec2)...
                           ./((norm(rVec - srcVec2))^3);
            
            eVecPartial = eVecPartial1 + eVecPartial2;
  
        end
        
    end

end