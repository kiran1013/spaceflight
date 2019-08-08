%{ owner: kiran.eastman@amd.com }%
function f = eqn_motion(t,x,mu)
    rx = x(1);
    ry = x(2);
    rz = x(3);
    vx = x(4);
    vy = x(5);
    vz = x(6);
    r  = sqrt(rx.^2+ry.^2+rz.^2);
    f=zeros(6,1);
    f(1) = vx;
    f(2) = vy;
    f(3) = vz;
    f(4) = -mu*rx/r.^3;
    f(5) = -mu*ry/r.^3;
    f(6) = -mu*rz/r.^3;
end