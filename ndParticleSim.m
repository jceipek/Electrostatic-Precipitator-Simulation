function [T,W,particle] = ndParticleSim(particle,plateConfig,wireConfig,duration,varargin)
    %[T,W,particle] = ndParticleSim(particle,plateConfig,wireConfig,duration,tol)
    %   Simulate a dust particle moving in plates defined by 'plateConfig'
    %   Uses ndNonChargedParticleSim and ndChargedParticleSim as
    %   appropriate.
        
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
    
    %Initialize Path Variables
    T1 = []; W1 = [];
    T2 = []; W2 = [];
    %------------------------%
    
    %Non-Charged particle
    if abs(particle.charge) == 0 && particle.isAlive
        %NonDimensionalizer
        nD = NonDimensionalizer(particle,plateConfig);
        %Simulation
        [T1,W1,particle] = ndNonChargedParticleSim(particle,plateConfig,wireConfig,nD,duration,tol);
    end
    
    %Charged particle
    if abs(particle.charge) > 0 && particle.isAlive
        %NonDimensionalizer
        nD = NonDimensionalizer(particle,plateConfig);
        %Simulation
        [T2,W2,particle] = ndChargedParticleSim(particle,plateConfig,wireConfig,nD,duration,tol);
    end
    
    T = vertcat(T1,T2);
    W = vertcat(W1,W2);
end

    