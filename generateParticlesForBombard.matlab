function particles = generateParticlesForBombard(plateConfig,particleCount,isRand)
    %generateParticlesForBombard(plateConfig,particleCount)
    %   Generate random particles between plates specified by plateConfig
    
    particles = cell(1,particleCount);
    
    if isRand
        for i = 1:particleCount
            x = rand() * (plateConfig.plateSeparation/2*0.9);
            if randi(2) == 1
                x = x*-1;
            end

            z = rand() * (plateConfig.plateHeight/2*0.9);
            if randi(2) == 1
                z = z*-1;
            end

            position = [x,-plateConfig.plateWidth/2,z];
            velocity = [0,5,0];
            particles{i} = DustParticle(position,velocity,0);
        end
    
    else

        px = linspace(-plateConfig.plateSeparation/2*0.9,...
                       plateConfig.plateSeparation/2*0.9,...
                       floor(sqrt(particleCount)));
        pz = linspace(-plateConfig.plateHeight/2*0.9,...
                       plateConfig.plateHeight/2*0.9,...
                       ceil(sqrt(particleCount)));

        n = 0;
        for i = 1:floor(sqrt(particleCount))
            for j = 1:ceil(sqrt(particleCount))
                x = px(i);
                z = pz(j);
                n = n + 1;
                position = [x,-plateConfig.plateWidth/2,z];
                velocity = [0,5,0];
                particles{n} = DustParticle(position,velocity,0);
            end
        end
    
    end
end