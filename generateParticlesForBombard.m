function particles = generateParticlesForBombard(plateConfig,particleCount)
    %generateParticlesForBombard(plateConfig,particleCount)
    %   Generate random particles between plates specified by plateConfig
    
    particles = cell(1,particleCount);
    for i = 1:particleCount
        x = rand() * (plateConfig.plateSeparation/2*0.99);
        if randi(2) == 1
            x = x*-1;
        end
            
        z = rand() * (plateConfig.plateHeight/2*0.99);
        if randi(2) == 1
            z = z*-1;
        end
        
        position = [x,-plateConfig.plateWidth/2,z];
        velocity = [0,5,0];
        particles{i} = DustParticle(position,velocity,0);
    end
end