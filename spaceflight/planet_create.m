function planet_create(planet)
    position=planet.getPosition;
    [xs,ys,zs]=sphere;
    surf(xs*planet.getRadius+position(1),ys*planet.getRadius+position(2),zs*planet.getRadius+position(3));
    
    %custom colormap
    map=rand([12 3]);
    colormap(map)
    
    %colormap cool
    shading interp%flat
    fprintf("Creating "+planet.getName()+"...\n")
end