function [T,W,particle] = ndChargedParticleSim(particle,plateConfig,wireConfig,nD,duration,varargin)
    %ndChargedParticleSim(particle,plateConfig,nD,duration,[tol])
    %   Simulate a particle moving in plates defined by 'plateConfig'
    
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
        
        delta = [dRdt; dVdt'];
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

end