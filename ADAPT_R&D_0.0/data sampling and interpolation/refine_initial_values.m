function x0_curr = refine_initial_values(data_curr, x0_curr, m)
% obtain initial values of the splines

for i = 1:length(m.x0_spline_adjust)
    state_name = char(m.x0_spline_adjust{i}{1});
    data_item = char(m.x0_spline_adjust{i}{2});
    adjust_factor = str2double(m.x0_spline_adjust{i}{3});
    x0_curr(m.s.(state_name)) = data_curr.(data_item).m * adjust_factor;
end

end

