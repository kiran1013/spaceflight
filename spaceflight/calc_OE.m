%{ owner: kiran.eastman@amd.com }%
function [h,a,e,i,AoP,LAN,nu] = calc_OE(r,v,mu)
    x_hat=[0 0 1];y_hat=[0 0 1];z_hat=[0 0 1];
    h=cross(r,v); %angular momentum
    n=cross(z_hat,h)/norm(cross(z_hat,h)); %line of nodes
    e_vec=(cross(v,h)/mu) - (r/norm(r)); %eccentricity vec
    e=norm(e_vec);
    a=-mu/(2*(((norm(v)^2)/2)-(mu/norm(r)))); %semi-major axis
    LAN=atan2d(n(2),n(1)); %long. of ascending node
    
    i=acosd(dot(z_hat,h)/norm(h)); %inclination
    %i can only range from 0 to 180
    if (i<0)
        i=-1*i;
    end
    
    AoP=acosd(dot(n,e_vec)/norm(e_vec)); %argument of periapse
    %fix quadrant ambiguity
    if (e_vec(3)>0)
        if (AoP<0)
            AoP=-1*AoP;
        end
    else
        if (AoP>0)
            AoP=-1*AoP;
        end
    end
    
    nu=acosd(dot(r,e_vec)/(norm(r)*norm(e_vec))); %true anamoly
    %fix quadrant ambiguity
    if (dot(r,v)>0)
        if (nu<0)
            nu=-1*nu;
        end
    else
        if (nu>0)
            nu=-1*nu;
        end
    end
    
    
end