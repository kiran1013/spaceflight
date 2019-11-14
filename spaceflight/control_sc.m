function [v_vec,burning] = control_sc(v_vec)

        burning=true;
        key=get(gcf,'CurrentCharacter');
        if strcmp(key,'x')
            v_vec(1)=v_vec(1)+.1;
        elseif strcmp(key,'y')
            v_vec(2)=v_vec(2)+.01;
        elseif strcmp(key,'z')
            v_vec(3)=v_vec(3)+.01;
        else
            burning=false;
        end

end