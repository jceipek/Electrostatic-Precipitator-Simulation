function [T,W,particle] = ndNonChargedParticleSim(particle,plateConfig,wireConfig,nD,duration,varargin)
    %ndNonChargedParticleSim(particle,plateConfig,nD,duration,[tol])
    %   Simulate a noncharged particle moving in plates defined by 'plateConfig'
    
    %Handle variable argument count
    if length(varargin) == 1
        tol = varargin{1};
    elseif ~isempty(varargin)
        %Incorrect # of args specified
        error(strcat('ndChargedParticleSim(particle,plateConfig,nD,duration,[tol])',...
                 ' takes 4 or 5 arguments.'));
    else
        tol = 10^-6; %Default value for tol
    end

    
    chargeDistribution = plateConfig.chargeDistribution;
    
    %%%%%%%%%%%%%%%%%%% Non-dimensionalize %%%%%%%%%%%%%%%%%%%
    plateSeparationRadius = nD.ndPos(plateConfig.plateSeparation/2);
    plateWidthRadius = nD.ndPos(plateConfig.plateWidth/2);
    plateHeightRadius = nD.ndPos(plateConfig.plateHeight/2);

    particlePosition = nD.ndPos(particle.position);
    particleVelocity = nD.ndVel(particle.velocity);
    duration = nD.ndTime(duration);
    
    ndWireCollection = wireConfig.wireCollection;
    for i = 1:length(ndWireCollection)
        currWire = ndWireCollection{i};
        currwire.startPos = nD.ndPos(currWire.startPos);
        currwire.endPos = nD.ndPos(currWire.endPos);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Perform the simulation
    [T,W] = ode45(@simulate, [0, duration], ...
       [particlePosition,particleVelocity],...
        odeset('Events', @collected,'AbsTol',tol));

    %Kill particle if collected
    if collected(0,W(end,1:3)) <= tol
        particle = particle.kill();
    end
    
    %%%%%% Re-dimensionalize %%%%%%
    W(:,1:3) = nD.dPos(W(:,1:3));
    W(:,4:6) = nD.dVel(W(:,4:6));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%Update Particle Pos and vel:%%%%%%
    particle.position = W(end,1:3);
    particle.velocity = W(end,4:6);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function delta=simulate(~,W)
        %delta=simulate(t,W)
        %   ODE-compatible simulator for a particle
        
        rVec = W(1:3)';
        vVec = W(4:6);

        dRdt = vVec;
        
        %Direction depends on charge
        dVdt = sign(particle.charge)*...
               fieldAtPt(rVec,ndWireCollection,chargeDistribution,...
                              plateWidthRadius,plateHeightRadius,...
                              plateSeparationRadius,tol);
           function [closenessToDischarge,isterminal,direction] = enteredCorona(~,W)
        %[closenessToDischarge,isterminal,direction] = enteredCorona(~,W)
        %   Termination event fuction used to see if  uncharged particles
        %   pass within the corona
       
        %Two conditions: pass left or right plate
        
        rVec = W(1:3)';
        dischargeFieldStrength = -3*10^6; % V/m
        
        closenessToDischarge = fieldAtPt(rVec,ndWireCollection,chargeDistribution,...
                              plateWidthRadius,plateHeightRadius,...
                              plateSeparationRadius,tol); 
                              
        closenessToDischarge = dischargeFieldStrength - closenessToDischarge;
        
        isterminal = 1; %terminate
        direction = -1; %Decreasing
  end

        delta = [dRdt; dVdt'];
 end
end
