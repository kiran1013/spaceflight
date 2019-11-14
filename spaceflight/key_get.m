function tf_sc = key_get(tf_sc_init,timer_period)

        key=get(gcf,'CurrentCharacter');
        switch key
            case ','
                tf_sc=20;%tf_sc=tf_sc*2;                
            case '.'
                tf_sc=10;
            case '/'
                tf_sc=1;
            case '\'
                tf_sc=.5;
            %case 'p'
            %    pause(5)
            %    tf_sc=tf_sc_init;
            otherwise
                tf_sc=tf_sc_init;
        end
end