%Plates
plateWidth = 1;
plateHeight = 1;
plateSeparation = 0.5;
duration = 1;
chargeDistribution = 5e-5;
plateConfig = PlateConfiguration(plateWidth,...
                                 plateHeight,...
                                 plateSeparation,...
                                 chargeDistribution);
             
wireCount = 2;
wire1 = Wire(-chargeDistribution/wireCount, [0,0,-0.5], [0,0,0.5]);
wire2 = Wire(-chargeDistribution/wireCount, [0,0.2,-0.5], [0,0.2,0.5]);
wireConfig = WireConfiguration(wire1,wire2);

%Particle
position = [0.1,-plateWidth/2,0];
velocity = [0,5,0];
particle = DustParticle(position,velocity,0);

plateConfig.plotPlates();
hold on;
wireConfig.plotWires();

%Simulate and time a single particle
particle.plotParticleState();
hold on;
tic
[T,W,particle] = ndParticleSim(particle,plateConfig,wireConfig,duration,10^(-1));
toc
particle.plotParticleState();

plot3(W(:,1),W(:,2),W(:,3));

%hold on;
% vectorFieldVisualizer(plateConfig,wireConfig,nD,8,10^(-2));

