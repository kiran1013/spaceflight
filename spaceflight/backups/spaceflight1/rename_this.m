%{
todo:
    read from file generating random numbers with rdrand
    set r0 and v0
    calculate trajectory
    wait n seconds
    perform manuever
    calculate fuel levels
    graph
    run until out of fuel and start again
%}


grav_const=6.67408E-20; %km^3/(kg*s^2)


%****values to read from rdrand file******
sc_standalone_m=200000; %kg, final stage
fuel_m0=15000; %kg


%initial inertial vectors
r0=[1000,1000,1000]; %km
v0=[10,0,0]; %km/s
mu=grav_const*6E24; %
[a,e,i,AoP,LAN,nu] = calc_OE(r0,v0,mu0);
e




v_esc=@(mu,r) sqrt(2*mu/r);
%a_from_T=@(T) ((mu^(1/3))*(T/2*pi)^(2/3))
r_sc_to_planet=@(pos1,pos2) norm(pos2-pos1);




t0=0;
tf=1;
tspan=[t0,tf];
x0 = [r0(1) r0(2) r0(3) v0(1) v0(2) v0(3)];
options = odeset('RelTol',1e-8);


figure
hold on
axis equal
[t,x]=ode45(@(t,x) eqn_motion(t,x,mu),tspan,x0,options); %initial

for iter=0:1:1000
    [t,x]=ode45(@(t,x) eqn_motion(t,x,mu),tspan,x(length(x),:),options);
    plot3(x(:,1),x(:,2),x(:,3));
    pause(.01)
    if mod(iter,20)==0%change this to if planet approaching
        %r_sc_to_planet=([x(length(x),1),x(length(x),2),x(length(x),3)],
        %period_range=[
        %a_range=[ a_from_T(period_range(1)), a_from_T(period_range(2)) ]
        %mu=
        %v_esc_object=v_esc(mu, radius_planet);
        %find_smallest_delta_v(
        %find_shortest_time
        %delta_v=manuever(
        x(length(x),4)=x(length(x),4)+delta_v(1);
        x(length(x),5)=x(length(x),5)+delta_v(2);
        x(length(x),6)=x(length(x),6)+delta_v(3);
    end
end

%{
[t,x]=ode45(@(t,x) eqn_motion(t,x,mu0),[0,10],x0,options);
plot3(x(:,1),x(:,2),x(:,3),'-.r*');
pause(1)
[t,x]=ode45(@(t,x) eqn_motion(t,x,mu0),[0,10],x(length(x),:),options);
plot3(x(:,1),x(:,2),x(:,3),':bs');
%}

%{
[xs,ys,zs]=sphere;
%figure('Position',[0 0 800 591]);
hold on
surf(xs*6378,ys*6378,zs*6378)
colormap summer
shading interp
%subplot(3,1,1)
plot3(x(:,1),x(:,2),x(:,3));
axis equal
%axis([-a-1000 a+1000 -a-1000 a+1000 -a-1000 a+1000])
title("Intertial")
xlabel('X (km)');
ylabel('Y (km)');
zlabel('Z (km)');
grid on;
%}
