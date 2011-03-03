function vectorFieldVisualizer(plateConfig,nD,res,varargin)
    %vectorFieldVisualizer(plateConfig,nD,varargin)
    %   plot a vector field for the ESP

    %Handle variable argument count
    if length(varargin) == 1
        tol = varargin{1};
    elseif ~isempty(varargin)
        %Incorrect # of args specified
        error(strcat('vectorFieldVisualizer(plateConfig,nD,res,[tol])',...
                 ' takes 3 or 4 arguments.'));
    end

    
    chargeDistribution = plateConfig.chargeDistribution;
    
    %%%%%%%%%%%%%%%%%%% Non-dimensionalize %%%%%%%%%%%%%%%%%%%
    plateSeparationRadius = nD.ndPos(plateConfig.plateSeparation/2);
    plateWidthRadius = nD.ndPos(plateConfig.plateWidth/2);
    plateHeightRadius = nD.ndPos(plateConfig.plateHeight/2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Generate 3D Vector Field
    x = linspace(-plateSeparationRadius+0.01,plateSeparationRadius-0.01,res);
    y = linspace(-plateWidthRadius+0.01,plateWidthRadius-0.01,res);
    z = linspace(-plateHeightRadius+0.01,plateHeightRadius-0.01,res);
    [x,y,z] = meshgrid(x,y,z);
    u = zeros(res,res,res);
    v = zeros(res,res,res);
    w = zeros(res,res,res);
    
    for i = 1:res
        for j = 1:res
            for k = 1:res
                vec = plateFieldAtPt([x(i,j,k),y(i,j,k),z(i,j,k)]);
                u(i,j,k) = vec(1);
                v(i,j,k) = vec(2);
                w(i,j,k) = vec(3);
            end
        end
    end
    
    %%Dimensionalize%%
    x = nD.dPos(x);
    y = nD.dPos(y);
    z = nD.dPos(z);
    
    u = nD.dPos(u);
    v = nD.dPos(v);
    w = nD.dPos(w);
    %%%%%%%%%%%%%%%%%%
    
    %Plot 3D Vector Field
    quiver3(x,y,z,u,v,w);

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