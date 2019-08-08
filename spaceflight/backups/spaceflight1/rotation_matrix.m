function rotation = rotation_matrix(type, angle)
    if type == 1
        rotation = [ 1 0 0; 0 cos(angle) sin(angle); 0 -sin(angle) cos(angle) ];
    elseif type == 2
        rotation = [ cos(angle) 0 sin(angle); 0 1 0; sin(angle) 0 cos(angle) ];
    elseif type == 3
        rotation = [ cos(angle) sin(angle) 0; -sin(angle) cos(angle) 0; 0 0 1 ];
    end
end