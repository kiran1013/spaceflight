%{ owner: kiran.eastman@amd.com }%
function rename_this
%{
todo main:
    -read from file generating random numbers with rdrand
    -set r0 and v0 *DONE
    -calculate trajectory *DONE
    -wait n seconds *DONE
    -perform manuever *DONE
    -calculate fuel levels
    -graph *DONE
    -run until out of fuel and start again

todo updates:
    -change from plotting every loop to adding points every loop *DONE
    (could be better)
    -modularize functionality
    -create 2 (or many) timers that run multithreaded and asynchrounously,
     one to calculate values every .1 seconds and another to update plot
     every .01 second
    
%}

%orbit functions
v_esc=@(mu,r) sqrt(2*mu/r);
a_from_T=@(T,mu) ((mu^(1/3))*(T/2*pi)^(2/3));
T_from_a=@(a,mu) 2*pi*sqrt((a^3)/mu);
r_sc_to_planet=@(pos1,pos2) norm(pos2-pos1);
r_a=@(h,mu,e) ((norm(h)^2)/mu)/(1-e);
r_p=@(h,mu,e) ((norm(h)^2)/mu)/(1+e);

%rocket functions
m_adder=@(m1,m2) m1+m2;

%universal constants
grav_const=6.67408E-20; %km^3/(kg*s^2)
g0=9.805;

%rocket properties
sc_standalone_m=200000; %kg, final stage
fuel_m0=15000; %kg
m=m_adder(sc_standalone_m,fuel_m0);
eff=.95; %efficiency
P=20; %kW, power
v_e=4.4; %exhaust velocity in units of seconds
Isp=v_e/g0; %specific imuple
thrust=eff*2*P*1000/(g0*Isp);


%initial inertial vectors
r0=[0,6378+500,0]; %km
v0=[9,0,0]; %km/s
mu=grav_const*6E24; %
[h,a,e,i,AoP,LAN,nu] = calc_OE(r0,v0,mu);



%****planet plot****
[xs,ys,zs]=sphere;
f1=figure('Position',[0 0 800 591]);
hold on
grid on
axis equal
view(3)
planet=surf(xs*1378,ys*1378,zs*1378);
colormap cool
shading flat%interp
dir=[0 1 0];
%set(gca,'Color','k')

timer_period=0.01;
T=T_from_a(a,mu);
t0=0;
tf_sc=10;%1*timer_period;
x0 = [r0(1) r0(2) r0(3) v0(1) v0(2) v0(3)];
options = odeset('RelTol',1e-10,'AbsTol',1e-10);

manuevered=false; %initial
burning=false;
%figure('Position',[0 0 800 591]);

%hold on
%axis equal
%grid on
%view(3)
[t,x]=ode45(@(t,x) eqn_motion(t,x,mu),[t0,T],x0,options); %initial
path0=plot3(x(:,1),x(:,2),x(:,3),'k');
path=path0;
sc_trail='c';
never_come_here_again_please=false; %for testing
t_iter=0;
dT_total=0;
t1=timer('Period',timer_period,'ExecutionMode','fixedRate','TimerFcn',@(~,~)flight,'StartDelay',0);
t2=timer('Period',3,'ExecutionMode','fixedRate','TimerFcn','fprintf("hello\n")','StartDelay',0);
start(t1);
start(t2);
%{
while 1
    tf_sc = tf_sc+.05
end
%}
    function flight
        
        key=get(gcf,'CurrentCharacter');
        if strcmp(key,',')
            %fprintf(",\n")
            tf_sc=10;%tf_sc=tf_sc*2;
        elseif strcmp(key,'.')
            %fprintf(".\n")
            if tf_sc/2 >= timer_period
                tf_sc=timer_period;%tf_sc=tf_sc/2;
            end
        elseif strcmp(key,'/')
            tf_sc=1;
        elseif strcmp(key,'\')
            tf_sc=.5;
        end


        [t,x]=ode45(@(t,x) eqn_motion(t,x,mu),[t0 tf_sc],x(length(x),:),options);
        sc_path=plot3(x(:,1),x(:,2),x(:,3),'o',...
        'MarkerEdgeColor',sc_trail,...
        'MarkerFaceColor',sc_trail,...
        'MarkerSize',4);
        sc=plot3(x(length(x),1),x(length(x),2),x(length(x),3),'bo',...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor',[.49 1 .63],...
        'MarkerSize',10);
        r=norm([x(length(x),1),x(length(x),2),x(length(x),3)]);
        v=norm([x(length(x),4),x(length(x),5),x(length(x),6)]);
        unit_v=[x(length(x),4), x(length(x),5),x(length(x),6)]/v;



        if cast(r,'int16')==cast(r_a(h,mu,e),'int16') & ~never_come_here_again_please%change this to if planet approaching
            %r_sc_to_planet=([x(length(x),1),x(length(x),2),x(length(x),3)],
            %period_range=[
            %a_range=[ a_from_T(period_range(1)), a_from_T(period_range(2)) ]
            %mu=
            %v_esc_object=v_esc(mu, radius_planet);
            %find_smallest_delta_v(
            %find_shortest_time

            %***test***
            fprintf("now\n")
            mu=grav_const*6E24;
            r=norm([x(length(x),1),x(length(x),2),x(length(x),3)]);
            %r=r_sc_to_planet([x(length(x),1),x(length(x),2),x(length(x),3)],[x(length(x),1),x(length(x),2),x(length(x),3)+6378])
            %x(length(x),4)
            %v_esc(mu,r)
            v2=6.5;%sqrt(mu/r);%sqrt((2*mu/r)-(mu/a))
            delta_v=v2-v;
            norm([x(length(x),4),x(length(x),5),x(length(x),6)])
            manuevered=true;
            dT_total=delta_v*m/thrust
            burning=true;
            t_iter=0;
            never_come_here_again_please=true;
        end
        
        
        if burning==true
            sc_trail='r';
            dT=tf_sc-t0;
            delta_v=thrust*dT/m;
            x(length(x),4)=x(length(x),4)+unit_v(1)*delta_v;
            x(length(x),5)=x(length(x),5)+unit_v(2)*delta_v;
            x(length(x),6)=x(length(x),6)+unit_v(3)*delta_v;
            x0=x(length(x),:);
            [h,a,e,i,AoP,LAN,nu]=calc_OE([x0(1),x0(2),x0(3)],[x0(4),x0(5),x0(6)],mu);
            T=T_from_a(a,mu);
            delete(path)
            t_iter=t_iter+dT;
            if t_iter >= dT_total
                burning=false;
                %manuevered=false;
            end      
        else
            sc_trail='c';
        end

        if manuevered==true
            [t,x]=ode45(@(t,x) eqn_motion(t,x,mu),[t0,T],x0,options); %plot path
            path=plot3(x(:,1),x(:,2),x(:,3),'m');
            if burning==false
                manuevered=false;
            end
        end

        
        
        
        
        
        an1=annotation('textbox', [0.75, 1, 0, 0], 'string', "v (magnitude): "+v+" km/s");
        an2=annotation('textbox', [0.75, .85, 0, 0], 'string', "v (vectorized): ["+...
            x(length(x),4)+","+x(length(x),5)+","+x(length(x),6)+"]"+" km/s");
        an3=annotation('textbox', [0.75, .7, 0, 0], 'string', "r (magnitude): "+r+" km");
        an4=annotation('textbox', [0.75, .55, 0, 0], 'string', "r (vectorized): ["+...
            x(length(x),1)+","+x(length(x),2)+","+x(length(x),3)+"]"+" km");


        %rotate(planet,dir,.1)       
        
        
        
        
        
        
        drawnow

        delete(an1)
        delete(an2)
        delete(an3)
        delete(an4)
        delete(sc)
    end

    delete(t1)
    delete(t2)
end
