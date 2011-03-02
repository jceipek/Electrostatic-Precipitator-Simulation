%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Plates
plateWidth = 0.5;
plateHeight = 0.5;
plateSeparation = 0.25;
duration = 1;
chargeDistribution = 1;
plateConfig = PlateConfiguration(plateWidth,...
                                 plateHeight,...
                                 plateSeparation,...
                                 chargeDistribution);

%Particle
position = [-.1,-plateWidth,0];
velocity = [0,0.1,0];
particle = DustParticle(position,velocity);

%NonDimensionalizer
nD = NonDimensionalizer(particle,plateConfig);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                        Plot Plates                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x = ones(1,5)*plateSeparation;
y = [-plateWidth,plateWidth,plateWidth,-plateWidth,-plateWidth];
z = [plateHeight,plateHeight,-plateHeight,-plateHeight,plateHeight];
plot3(x,y,z,'r');

hold on

x = ones(1,5)*-plateSeparation;
y = [-plateWidth,plateWidth,plateWidth,-plateWidth,-plateWidth];
z = [plateHeight,plateHeight,-plateHeight,-plateHeight,plateHeight];
plot3(x,y,z,'r');
axis equal

xlabel('X');ylabel('Y');zlabel('Z')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
ndChargedParticleSim(particle,plateConfig,nD,duration)
toc
