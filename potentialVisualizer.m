function potentialVisualizer(plateConfig,wireConfig,res,varargin)
    %potentialVisualizer(plateConfig,nD,varargin)
    %   plot the ESP's potential
    
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
        otherwise
            error(strcat('vectorFieldVisualizer(plateConfig,nD,res,[tol])',...
                     ' takes 3 - 5 arguments.'));
    end

    %NonDimensionalizer
    nD = NonDimensionalizer(plateConfig);
        
    chargeDistribution = plateConfig.chargeDistribution;
    

            plotType = varargin{2};    %%%%%%%%%%%%%%%%%%% Non-dimensionalize %%%%%%%%%%%%%%%%%%%
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
    x = linspace(-plateSeparationRadius+0.001,plateSeparationRadius-0.001,res);
    y = linspace(-plateWidthRadius+0.001,plateWidthRadius-0.001,res);
    %z = linspace(-plateHeightRadius+0.01,plateHeightRadius-0.01,res);
    %[x,y,z] = meshgrid(x,y,z);
    [x,y] = meshgrid(x,y);
    %u = zeros(res,res); %,res);
    v = zeros(res,res); %,res);
    %w = zeros(res,res); %,res);
    
    for i = 1:res
        for j = 1:res
            %for k = 1:res
                %rVec = [x(i,j,k),y(i,j,k),z(i,j,k)];
                rVec = [x(i,j),y(i,j),0];
                pot = ndPotentialAtPt(rVec,ndWireCollection,chargeDistribution,...
                          plateWidthRadius,plateHeightRadius,...
                          plateSeparationRadius,tol);
                v(i,j) = pot;
                %u(i,j,k) = vec(1);
                %v(i,j,k) = vec(2);
                %w(i,j,k) = vec(3);
            %end
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
    
    %Plot 3D Vector Field
    contourf(x,y,v,20);
%     pcolor(x,y,v);
%     shading interp
    colorbar;

end