%General
tolerance = 10^(-3);

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
             

%No Wires
wireCount = 0;
wireConfig = WireConfiguration();
                             
%Center Wire:
wireCount = 1;
wire1 = Wire(-chargeDistribution/wireCount, [0,0,-0.5], [0,0,0.5]);
wireConfig = WireConfiguration(wire1);

%2 Wires on Sides, one after another
wireCount = 2;
wire1 = Wire(-chargeDistribution/wireCount, [0,-0.2,-0.5], [0,-0.2,0.5]);
wire2 = Wire(-chargeDistribution/wireCount, [0,0.2,-0.5], [0,0.2,0.5]);
wireConfig = WireConfiguration(wire1,wire2);

%2 Wires on Sides, side by side
wireCount = 2;
wire1 = Wire(-chargeDistribution/wireCount, [-0.1,0,-0.5], [-0.1,0,0.5]);
wire2 = Wire(-chargeDistribution/wireCount, [0.1,0,-0.5], [0.1,0,0.5]);
wireConfig = WireConfiguration(wire1,wire2);

%2 Wires crossing in middle
wireCount = 2;
wire1 = Wire(-chargeDistribution/wireCount, [0,0,-0.5], [0,0,0.5]);
wire2 = Wire(-chargeDistribution/wireCount, [-0.25,0,0], [0.25,0,0]);
wireConfig = WireConfiguration(wire1,wire2);


%Particles
particleCount = 100;
collected = 0;
undecided = 0;
notCollected = 0;
totalTime = 0;
timeElapsed = 0;
particles = generateParticlesForBombard(plateConfig,particleCount,0);


%position = [0.1,-plateWidth/2,0];
%velocity = [0,5,0];
%particle = DustParticle(position,velocity,0);

plateConfig.plotPlates();
hold on;
wireConfig.plotWires();
drawnow;

%Simulate all of the particles
for particlei = 1:particleCount

    %Simulate and time a single particle
    particles{particlei}.plotParticleState();
    hold on;
    tic
    [T,W,particles{particlei}] = ndParticleSim(particles{particlei}...
                                ,plateConfig,wireConfig,duration,...
                                tolerance,1);
    timeElapsed = toc;
    totalTime = totalTime + timeElapsed;
    
    particles{particlei}.plotParticleState();

    plot3(W(:,1),W(:,2),W(:,3));

    %Count the particles that were collected and survived
    switch particles{particlei}.wasCollected 
        case -1
            undecided = undecided + 1;
        case 0
            notCollected = notCollected + 1;
        case 1
            collected = collected + 1;
        otherwise
            error('This should be impossible!');
    end

    clc
    disp('#############RESULTS:#############')
    fprintf('Undecided (indicates wires deflected backwards): %i\n',undecided);
    fprintf('Not Collected: %i\n',notCollected);
    fprintf('Collected: %i\n',collected);
    fprintf('Total vs Initial Count: %i/%i\n',notCollected+collected,particleCount);
    fprintf('Time for Sim: %fs\n',timeElapsed);
    fprintf('Total Time: %fs\n',totalTime);
end

%hold on;


%vectorFieldVisualizer(plateConfig,wireConfig,10,tolerance,'vField');

%potentialVisualizer(plateConfig,wireConfig,20,tolerance);
