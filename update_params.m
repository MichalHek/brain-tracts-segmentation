function [t, f, d] = update_params(iteration)

if (iteration == 1)
    t = 5;
    f = 0.5;
    d = 0.99;
elseif (iteration <= 5) && (iteration > 1)
    t = 5;
    f = 0.7;
    d = 0.99;
    elseif (iteration > 5)
    t = 20;
    f = 0.99;
    d = 0.97;
end
end