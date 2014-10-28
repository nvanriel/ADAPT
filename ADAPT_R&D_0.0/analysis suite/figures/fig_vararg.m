function fig_vararg(time, varargin)
% creates figure of variable amount of fluxes
% max of varargin = 3
% colormap = {'y' 'm' 'c' 'r' 'g'};
colormap = [ 0.45 0.45 0.45     % shades of grey
             0.7 0.7 0.7
             0.9 0.9 0.9 ];
linespec = {'k-' 'k-' 'k-' 'k-' 'k-'};
legend_names = {};
hp = zeros(length(varargin),1);
X = [time fliplr(time)];

if ~isempty(varargin)  && length(varargin) < 6
    for i = 1:length(varargin)
        Yupp = varargin{i}(:,3)';
        Ylwr = varargin{i}(:,4)';
        Y = [Ylwr fliplr(Yupp)];
        hp(i) = fill(X, Y, colormap(i, :));
        legend_names{i,1} = strrep(inputname(i+1), '_', ' ');
    end
    for i = 1:length(varargin)
         plot(time, varargin{i}(:,1), linespec{i}, 'LineWidth', 2);
    end
    legend(hp,legend_names);
    xlabel('Time (hours)');
    par_or_flux = inputname(2);
    if par_or_flux(1) == 'k';
        ylabel('1/h');
    else 
        ylabel('\mumol / h');
    end
else
    disp('wrong number of arguments')
end   
xlim([0 time(end)]);
end

