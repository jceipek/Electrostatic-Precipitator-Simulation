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

%Particle
position = [-.1,-plateWidth/2,0];
velocity = [0,0.1,0];
particle = DustParticle(position,velocity);

%NonDimensionalizer
nD = NonDimensionalizer(particle,plateConfig);

plateConfig.plotPlates();


%Simulate and time a single particle
tic
[T,W] = ndChargedParticleSim(particle,plateConfig,wireConfig,nD,duration,10^(-1));
toc
W(end,1:3)



plot3(W(:,1),W(:,2),W(:,3));

%hold on;
%vectorFieldVisualizer(plateConfig,nD,3,10^(-2));