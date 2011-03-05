function [T,W,particle] = ndParticleSim(particle,plateConfig,wireConfig,nD,duration,varargin)
    %ndNonChargedParticleSim(particle,plateConfig,nD,duration,[tol])
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
    
    

    