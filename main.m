%Plates
plateWidth = 1;
plateHeight = 1;
plateSeparation = 0.5;
duration = 1;
chargeDistribution = 1;
plateConfig = PlateConfiguration(plateWidth,...
                                 plateHeight,...
                                 plateSeparation,...
                                 chargeDistribution);
                             
wire1 = Wire(-1, [0,0,-0.5], [0,0,0.5]);
wireConfig = WireConfiguration(wire1);

%Particle
position = [0,-plateWidth/2,0];
velocity = [0,5,0];
particle = DustParticle(position,velocity);

%NonDimensionalizer
nD = NonDimensionalizer(particle,plateConfig);

plateConfig.plotPlates();


%Simulate and time a single particle
tic
[T,W] = ndChargedParticleSim(particle,plateConfig,wireConfig,nD,duration,10^(-1));
toc

plot3(W(:,1),W(:,2),W(:,3));

hold on;
% vectorFieldVisualizer(plateConfig,nD,8,10^(-2));

