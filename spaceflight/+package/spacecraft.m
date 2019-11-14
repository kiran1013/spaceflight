classdef spacecraft < package.Celestial_Object
   properties (Access = private)
       Velocity
       Unit_V
       Velocity_matrix
       isBurning
       Speed
       Trail_Color       
   end
   methods(Access = public)
       %constructor
       function obj = spacecraft(v,p,m,n)
           obj=obj@package.Celestial_Object(p,m,n);
           obj.isBurning=false;
           obj.Trail_Color='c';
           obj.Velocity=v;
       end
 
       
       %****************setting functions****************  
       function setVelocity_matrix(obj,vm)
           set(obj,'Velocity_matrix',vm) 
       end
       function setVelocity(obj,v)
           set(obj,'Velocity',v)
       end
       function setIsBurning(obj,b)
           set(obj,'isBurning',b)
       end
       %*************************************************
       
       %****************getting functions**************** 
       function v = getVelocity(obj)
           v = obj.Velocity;
       end
       function b = getIsBurning(obj)
           b = obj.isBurning;
       end
       function c = getTrail_Color(obj)
           if obj.isBurning
               c='r';
           else
               c='c';
           end
       end
       function s = getSpeed(obj)
           s = norm(obj.Velocity);
       end
       function uv = getUnit_V(obj)
          uv = obj.Velocity/obj.Speed; 
       end
       
       
       function vm = getVelocity_matrix(obj,index)
          vm = obj.Velocity_matrix;    
       end
       %*************************************************
       
       
   end
end