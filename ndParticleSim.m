function [T,W,particle] = ndParticleSim(particle,plateConfig,wireConfig,duration,varargin)
    %[T,W,particle] = ndParticleSim(particle,plateConfig,wireConfig,duration,[tol,[doPlot]])
    %   Simulate a dust particle moving in plates defined by 'plateConfig'
    %   Uses ndNonChargedParticleSim and ndChargedParticleSim as
    %   appropriate.
        
    %Handle variable argument count
    switch length(varargin)
        case 0
            tol = 10^-6;
            doPlot = 0;
        case 1
            tol = varargin{1};
            doPlot = 0;
        case 2
            tol = varargin{1};
            doPlot = varargin{2};
        otherwise
            error(strcat('ndParticleSim(particle,plateConfig,wireConfig,duration,[tol,[doPlot]])',...
                     ' takes 4 - 6 arguments.'));
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
        if doPlot
           plot3(W1(end,1),W1(end,2),W1(end,3),'ro');
        end
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

    