function potentialVisualizer(plateConfig,wireConfig,res,varargin)
    %potentialVisualizer(plateConfig,nD,varargin)
    %   plot the ESP's potential
    
    %Handle variable argument count
    switch length(varargin)
        case 0
            tol = 10^-6;
        case 1
            tol = varargin{1};
        otherwise
            error(strcat('potentialVisualizer(plateConfig,nD,res,[tol])',...
                     ' takes 3 or 4 arguments.'));
    end

    %NonDimensionalizer
    nD = NonDimensionalizer(plateConfig);
        
    chargeDistribution = plateConfig.chargeDistribution;
    

    %%%%%%%%%%%%%%%%%%% Non-dimensionalize %%%%%%%%%%%%%%%%%%%
    plateSeparationRadius = nD.ndPos(plateConfig.plateSeparation/2);
    plateWidthRadius = nD.ndPos(plateConfig.plateWidth/2);
    plateHeightRadius = nD.ndPos(plateConfig.plateHeight/2);
    
    ndWireCollection = wireConfig.wireCollection;
    for i = 1:length(ndWireCollection)
        currWire = ndWireCollection{i};
        currwire.startPos = nD.ndPos(currWire.startPos);
        currwire.endPos = nD.ndPos(currWire.endPos);
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %Generate 3D Vector Field
    x = linspace(-plateSeparationRadius*0.9,plateSeparationRadius*0.9,res);
    y = linspace(-plateWidthRadius*0.9,plateWidthRadius*0.9,res);
    [x,y] = meshgrid(x,y);
    v = zeros(res,res);
    
    for i = 1:res
        for j = 1:res
            rVec = [x(i,j),y(i,j),0];
            pot = ndPotentialAtPt(rVec,ndWireCollection,chargeDistribution,...
                      plateWidthRadius,plateHeightRadius,...
                      plateSeparationRadius,tol);
            v(i,j) = pot;
        end
    end

    %%Dimensionalize%%
    x = nD.dPos(x);
    y = nD.dPos(y);
    %z = nD.dPos(z);
    
    %u = nD.dPos(u);
    v = nD.dPos(v);
    %w = nD.dPos(w);
    %%%%%%%%%%%%%%%%%%
    
    %Plot Center Contour
    contourf(x,y,v,20);
%     pcolor(x,y,v);
%     shading interp
    colorbar;

end