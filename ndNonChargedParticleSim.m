function [T,W,particle] = ndNonChargedParticleSim(particle,plateConfig,wireConfig,nD,duration,tol)
    %ndNonChargedParticleSim(particle,plateConfig,nD,duration,[tol])
    %   Simulate a noncharged particle moving between plates defined by 
    %   'plateConfig'
    
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
        odeset('Events', @terminationEvents,'AbsTol',tol));
    
    %Assign charge to particle if necessary
    if enteredCorona(0,W(end,1:3)') <= tol
        particle = particle.assignCharge();
    %Kill particle if collected
    elseif collected(0,W(end,1:3)) <= tol
        particle = particle.kill();
    end
    
    %%%%%% Re-dimensionalize %%%%%%
    W(:,1:3) = nD.dPos(W(:,1:3));
    W(:,4:6) = nD.dVel(W(:,4:6));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Kill particle if collected
    if sum(abs(collected(0,W(end,1:3))) <= tol) == 1
        particle = particle.kill();
    end
    
    %%%%%%Update Particle Pos and vel:%%%%%%
    particle.position = W(end,1:3);
    particle.velocity = W(end,4:6);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    function delta=simulate(~,W)
        %delta=simulate(t,W)
        %   ODE-compatible simulator for a particle
        
        vVec = W(4:6);
        dRdt = vVec;

        %Acceleration is always 0
        dVdt = [0,0,0];
        delta = [dRdt; dVdt'];
    end

    function [values,isterminal,direction] = terminationEvents(~,W)
        [distToWall,isterminal1,direction1] = collected(0,W);
        [closenessToDischarge,isterminal2,direction2] = enteredCorona(0,W);
        [distToEnd,isterminal3,direction3] = notCollected(0,W);
        
        values = [closenessToDischarge;distToWall;distToEnd];
        
        isterminal = [isterminal1;isterminal2;isterminal3]; %terminate
        direction = [direction1;direction2;direction3];
    end

	function [closenessToDischarge,isterminal,direction] = enteredCorona(~,W)
        %[closenessToDischarge,isterminal,direction] = enteredCorona(~,W)
        %   Termination event fuction used to see if  uncharged particles
        %   pass within the corona
        e0 = -8.854187817*10^(-12); %F/m
        rVec = W(1:3)';
        dischargeFieldStrength = -3*10^6*4*pi*e0; % V/m
        
        fieldStr = fieldAtPt(rVec,ndWireCollection,chargeDistribution,...
                              plateWidthRadius,plateHeightRadius,...
                              plateSeparationRadius,tol);
                    
        %norm(fieldStr);
        %dischargeFieldStrength;
        
        closenessToDischarge = dischargeFieldStrength - norm(fieldStr);
        
        isterminal = 1; %terminate
        direction = -1; %Decreasing
    end

    function [distToWall,isterminal,direction] = collected(~,W)
        %[distToWall,isterminal,direction] = collected(t,W)
        %   Termination event fuction used to see if particles are
        %   collected because they hit the plates.
        
        %Two conditions: pass left or right plate
        distToWall = [plateSeparationRadius - W(1);...
                    -plateSeparationRadius - W(1)]; 
        
        isterminal = [1;1]; %terminate in both cases
        direction = [-1;1]; %Decreasing, increasing
    end

    function [distToEnd,isterminal,direction] = notCollected(~,W)
         %[distToWall,isterminal,direction] = collected(t,W)
        %   Termination event fuction used to see if particles are
        %   collected because they hit the plates.
        
        %Two conditions: pass left or right plate
        distToEnd = plateWidthRadius - W(2); 
        
        isterminal = 1; %terminate in both cases
        direction = -1; %Decreasing, increasing
    end          
end
