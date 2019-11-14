%{ owner: kiran.eastman@utexas.edu }%
%{
todo main:
    -calculate fuel levels
    -run until out of fuel and start again
    -add gui -> add more user control
    -Store a second planet and calculate SOI of both planets
        -When in SOI of second planet

todo updates:
    -de-spaghetti
    -change from plotting every loop to adding points every loop 
    (could be better)
    -create 2 (or many) timers that run multithreaded and asynchrounously,
     one to calculate values every .1 seconds and another to update plot
     every .01 second
    -make the spacecraft 3D
%}


function main
import package.*

close all;clc

%********orbit functions********
T_from_a=@(a,mu) 2*pi*sqrt((a^3)/mu);
D_between=@(vec1,vec2) norm(vec2-vec1);
%{
a_from_T=@(T,mu) ((mu^(1/3))*(T/2*pi)^(2/3));
r_sc_to_planet=@(pos1,pos2) norm(pos2-pos1);
r_a=@(h,mu,e) ((norm(h)^2)/mu)/(1-e);
r_p=@(h,mu,e) ((norm(h)^2)/mu)/(1+e);
SOI=@(m_sc,m_p,r) r*(m_sc/m_p)^(2/5);
%}
%*******************************

%********rocket functions********
m_adder=@(m1,m2) m1+m2;
%********************************


%********rocket properties********
%{
sc_standalone_m=200000; %kg, final stage
fuel_m0=15000; %kg
m=m_adder(sc_standalone_m,fuel_m0);
eff=.95; %efficiency
P=20; %kW, power
v_e=4.4; %exhaust velocity in units of seconds
Isp=v_e/9.81; %specific imuplse
thrust=eff*2*P*1000/(9.81*Isp);
%}
%**********************************


%********initial inertial vectors********
r0=[0,6378+1000,0]; %km
v0=[7,0,0]; %km/s
%****************************************

%******object initalization******
sc=spacecraft(v0,r0,10000,"Kiran's Tester"); %add constructor values
p=Planet(1378,[0,0,0],6E24,"HB-1337");
%********************************

p2=Planet(378,[10000,0,0],6E19,"HB-1338");

[h,a,e,i,AoP,LAN,nu] = calc_OE(sc.getPosition,sc.getVelocity,p.getMu);





%need to create more figures
% fig 1 = graphics
% fig 2 = annotations
% fig 3 = user control

%plots:
%   1: orbit path
%   2: spacecraft
%   3: spacecraft traveled path
plots=gobjects(3,1);
%annotations:
%   1: speed
%   2: velocity
%   3: position magnitude
%   4: position
%   5: time step
annotations=gobjects(7,1);

%figures=gobjects(3,1);



%****planet plot****
fig=figure('units','normalized','outerposition',[0 0 1 1]);%('Position',[100 100 1200 800]);
set(gcf,'Color',[0.25, 0.25, 0.25])
set(gca,'Color','k')
hold on
grid on
axis equal
view(3)
ax = gca;
ax.GridColor = [1, 1, 1];  % [R, G, B]

planet_create(p);
planet_create(p2);
%*******************

 



timer_period=0.1;
%need to update T function to handle escape velocity
T=T_from_a(a,p.getMu);
if e > 1 %parabolic
    T = 100;
end

t0=0;
tf_sc=10;%*timer_period;
options = odeset('RelTol',1e-10,'AbsTol',1e-10);




[t,x]=ode45(@(t,x) eqn_motion(t,x,p.getMu),[t0,T],[sc.getPosition sc.getVelocity],options); %initial
%sc.setPosition_matrix([x(:,1),x(:,2),x(:,3)]);
%sc.setVelocity_matrix([x(:,4),x(:,5),x(:,6)]);
sc.setPosition([x(length(x),1),x(length(x),2),x(length(x),3)]);
sc.setVelocity([x(length(x),4),x(length(x),5),x(length(x),6)]);


plots(1)=plot3(x(:,1),x(:,2),x(:,3),'--m');
xlabel('x','FontSize',10,'Color','w')
ylabel('y','FontSize',10,'Color','w')
zlabel('z','FontSize',10,'Color','w')

never_come_here_again=false;

%mu = p.getMu;
p.getEscape_Velocity

t1=timer('Period',timer_period,'ExecutionMode','fixedRate','TimerFcn',@flight,'StartDelay',0,'UserData',{plots,annotations});
%t2=timer('Period',.01,'ExecutionMode','fixedRate','TimerFcn','drawnow','StartDelay',0);
start(t1);
%start(t2);


    function [plots,annotations] = flight(obj,event)
        import package.*
        [this]=get(obj, 'UserData');
        plots=this{1,1};
        annotations=this{1,2};

        
        [h,a,e,i,AoP,LAN,nu] = calc_OE(sc.getPosition,sc.getVelocity,p.getMu);
        OE=[h,a,e,i,AoP,LAN,nu];
        T=T_from_a(a,p.getMu);
        if e > 1 %parabolic
            T = 10000;
        end

        tf_sc=key_get(tf_sc,timer_period);
        [t,x]=ode45(@(t,x) eqn_motion(t,x,p.getMu),[t0 tf_sc],[sc.getPosition,sc.getVelocity],options);

        [plots,annotations]=plot_fun(plots,annotations,x,sc.getSpeed,sc.getPosition_norm,sc.getVelocity,sc.getPosition,tf_sc,sc.getTrail_Color,OE);
        
        sc.setPosition([x(length(x),1),x(length(x),2),x(length(x),3)]);
        sc.setVelocity([x(length(x),4),x(length(x),5),x(length(x),6)]);

        [v_temp,ib_temp]=control_sc(sc.getVelocity);
        sc.setVelocity(v_temp);
        sc.setIsBurning(ib_temp);

        %update to add calculated manuevers
        if sc.getIsBurning==true
            delete(plots(1)) 
            [t,x]=ode45(@(t,x) eqn_motion(t,x,p.getMu),[t0,T],[sc.getPosition,sc.getVelocity],options); %plot path
            plots(1)=plot3(x(:,1),x(:,2),x(:,3),'--m');   %new path            
        end
        

        p.getEscape_Velocity;
        d=D_between(sc.getPosition,p.getPosition);
        

 %{       
        if sc.getSpeed > p.getEscape_Velocity && d > 5E3 && ~never_come_here_again
            %put the planet some distance away from sc vector
            temp=sc.getPosition;
            p=Planet(2378,[temp(1)+50000,temp(2)+1000,temp(3)+1000],6E25,"tester_creation");
            planet_create(p)
            never_come_here_again=true;
            fprintf('here\n')
        end
%}       

        drawnow
        for iter=1:length(annotations)
            delete(annotations(iter))
        end
        
        delete(plots(2))
        %drawnow
        this{1,1}=plots;
        this{1,2}=annotations;
        set(obj,'UserData',this);
        

    end

end
