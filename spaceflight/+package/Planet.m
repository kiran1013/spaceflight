classdef Planet < package.Celestial_Object
   properties (Access = private)
       Radius
       mu
       Escape_Velocity     
       %SOI
   end
   methods
       %constructor
       function obj = Planet(r,p,m,n)
           obj=obj@package.Celestial_Object(p,m,n);
           obj.Radius = r;
           obj.mu = obj.Mass*obj.grav_const;
       end
       
       
       %****************getting functions****************
       function r = getRadius(obj)
           r = obj.Radius;
       end
       function gp = getMu(obj)
           gp = obj.mu;
       end
       function ev = getEscape_Velocity(obj)
           ev = sqrt(2*obj.mu/obj.Radius);
       end
       %*************************************************
   end
    
end