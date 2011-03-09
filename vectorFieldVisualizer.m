function vectorFieldVisualizer(plateConfig,wireConfig,res,varargin)
    %vectorFieldVisualizer(plateConfig,nD,varargin)
    %   plot a vector field/field lines for the ESP
    
    %Handle variable argument count
    switch length(varargin)
        case 0
            tol = 10^-6;
            plotType = 'vField';
        case 1
            tol = varargin{1};
            plotType = 'vField';
        case 2
            tol = varargin{1};
            plotType = varargin{2};
        otherwise
            error(strcat('vectorFieldVisualizer(plateConfig,nD,res,[tol])',...
                     ' takes 3 - 5 arguments.'));
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
                rVec = [x(i,j,k),y(i,j,k),z(i,j,k)];
                vec = ndFieldAtPt(rVec,ndWireCollection,chargeDistribution,...
                          plateWidthRadius,plateHeightRadius,...
                          plateSeparationRadius,tol);
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
    if strcmp(plotType,'vField')
        quiver3(x,y,z,u,v,w);
    else
        streamslice(x(:,:,floor(res/2)),y(:,:,floor(res/2)),...
                    u(:,:,floor(res/2)),v(:,:,floor(res/2)))
    end

end