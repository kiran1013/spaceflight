classdef Celestial_Object < matlab.mixin.SetGet
   properties(Access = protected)
       Name
       Mass
       Position
       Position_norm 
       Position_matrix
   end
   properties(Constant)
       grav_const = 6.67408E-20; %km^3/(kg*s^2)
   end   
   methods(Access = public)       
       %constructor
       function obj = Celestial_Object(p,m,n)
           obj.Position = p;
           obj.Mass = m;
           obj.Name = n;
       end
       
       %****************setting functions****************
       function setPosition_matrix(obj,pm)
           set(obj,'Position_matrix',pm) 
       end
       function setName(obj,n)
           set(obj,'Name',n);
       end
       function setMass(obj,m)
           set(obj,'Mass',m);
       end     
       function setPosition(obj,p)
           set(obj,'Position',p);
       end      
       %*************************************************       
       
       
       %****************getting functions****************       
       function n = getName(obj)
           n = obj.Name;
       end
       function m = getMass(obj)
           m = obj.Mass;
       end  
       function p = getPosition(obj)
           p = obj.Position;
       end     
       function pn = getPosition_norm(obj)
           pn = norm(obj.Position);
       end
       %*************************************************     
   end
end