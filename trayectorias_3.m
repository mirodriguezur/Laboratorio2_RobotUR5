%%% script que saca nueestros puntos
clc
clear
close

% parametro t, separacion entre cada punto
t=0.019048;

K = [0.59428, 0.13333, 0.40572]; %vertices del cuadrado
M = [0.40572, -0.13333, 0.59428];
E = [0.40572, 0.13333, 0.59428];
I = [0.59428, -0.13333, 0.40572];

J = [0.5, 0.13333, 0.5]; % Punto medio EK, centro del circulo 

%segmento entre 2 puntos KI = I-K (15 puntos)
punto=[0.59428, 0.13333, 0.40572]';
for i=1:14
    punto (:,i+1)=[K(1),(K(2)-i*t),K(3)];
end

%segmento ENTRE 2 PUNTOS ME IM=M-I (14 puntos)
for i=1:14
    punto (:,i+15)=[(I(1)-i*t/sqrt(2)),(I(2)),(I(3)+i*t/sqrt(2))];
end

%segmento ENTRE 2 PUNTOS ME ME=E-M (14 puntos)
for i=1:14
    punto (:,i+29)=[M(1),(M(2)+i*t),M(3)];
end

%Semicirculo centro radio JK, EMPIEZA EN E, TERMINA EN K (22 puntos)
j=-90;
for i=1:22
    punto (:,i+43)= [J(1)+(J(1)-E(1))*sind(t+j),J(2)+J(2)*cosd(t+j), J(3)+(J(3)-E(3))*sind(t+j)];
    j=j+8.2;
end
p = plot3(punto(1,:),punto(2,:),punto(3,:),'.');

ur5 = loadrobot("universalUR5",'Gravity',[0 0 -9.81]);
ur5.DataFormat = 'row';
showdetails(ur5)

eeName = "tool0";  % Define end-effector body name

numJoints = 6; % Define the number of joints in the manipulator

eeOrientation = [pi/2, 0, pi/3]; % The Euler angles for the desired ee orientation 


clear wayPoints % Clear previous waypoints and begin building wayPoint array

% create array
for i = 1:65
    waypt1 = [punto(:,i)',eeOrientation];
    wayPoints(:,i) = waypt1';
end

q0 = zeros(numJoints,1)';

%Specify the trajectory time step and approximate desired tool speed.
toolSpeed = 0.5; % m/s
distance = norm(punto(:,1)'-punto(:,2)');
initTime = 0;
timeStep = (distance/toolSpeed) - initTime; % seconds
finalTime = timeStep*64;
trajTimes = initTime:timeStep:finalTime;
timeInterval = [trajTimes(1); trajTimes(end)];

% Define a [1x6] vector of relative weights on the orientation and 
% position error for the inverse kinematics solver.
weights = ones(1,6);

% Transform the first waypoint to a Homogenous Transform Matrix for initialization
initTargetPose = eul2tform(wayPoints(4:6,1)'); 
initTargetPose(1:3,end) = wayPoints(1:3,1);%> wayPoints(1:3,1)

% Solve for q0 such that the manipulator begins at the first waypoint
ik = inverseKinematics('RigidBodyTree',ur5);
q0 = ik(eeName,initTargetPose,weights,q0);

%Show the initial configuration of the robot.

show(ur5,q0,'PreservePlot',false,'Frames','off');
hold on
axis([-1 1 -1 1 -0.1 1.5]);
show(ur5,q0,'PreservePlot',false,'Frames','off');
plot3(punto(1,i),punto(2,i),punto(3,i),'b.','MarkerSize',20)
drawnow;
%Visualize the task-space trajectory. Iterate through the stateTask states and interpolate based on the current time.

for i=2:length(trajTimes)
    % Current time 
    tNow= trajTimes(i);

    TargetPose = eul2tform(wayPoints(4:6,i)'); 
    TargetPose(1:3,end) = wayPoints(1:3,i);%> wayPoints(1:3,i)
    
    % Solve for q
    q0(i,:) = ik(eeName,TargetPose,weights,q0(i-1,:));    
    show(ur5,q0(i,:),'PreservePlot',false,'Frames','off');
    plot3(punto(1,i),punto(2,i),punto(3,i),'b.','MarkerSize',20)
    drawnow;
end



%% IMAGENES DE CAMBIO ARTICULACION

plot(trajTimes(:),q0(:,1)',trajTimes(:),q0(:,2)',trajTimes(:),q0(:,3)',trajTimes(:),q0(:,4)',trajTimes(:),q0(:,5)',trajTimes(:),q0(:,6)')
title('Variacion de angulo de articulacion, para la trayectoria escogida')
xlabel('tiempo') 
ylabel('angulo (rad)') 
legend({'q1','q2','q3','q4','q5','q6'},'Location','northeast')

%%  IMAGENES DE VELOCIDAD ARTICULACION
for i=1:64
    vel(i,:) = (q0(i+1,:)-q0(i,:))/timeStep;
end


plot(trajTimes(1:64),vel(:,1)',trajTimes(1:64),vel(:,2)',trajTimes(1:64),vel(:,3)',trajTimes(1:64),vel(:,4)',trajTimes(1:64),vel(:,5)',trajTimes(1:64),vel(:,6)')
title('Velocidad en rad/s, para la trayectoria escogida')
xlabel('tiempo (s)') 
ylabel('velociad (rad/s)') 
legend({'vel_q1','vel_q2','vel_q3','vel_q4','vel_q5','vel_q6'},'Location','northeast')

