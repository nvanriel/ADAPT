function save_figure(m)
    if m.plotinfo.save
        for i_fig = 1:length(m.plotinfo.f)
            save_options.filename = [m.plotinfo.save_dir m.plotinfo.filename_fig{i_fig}];
            save_options.fig_handle = m.plotinfo.f(i_fig);
            if ~isfield(m.plotinfo,'save_format')
                save_options.eps = 1;
                save_options.png = 0;
            else
                if strcmp(m.plotinfo.save_format,'eps')
                    save_options.eps = 1;
                    save_options.png = 0;
                elseif strcmp(m.plotinfo.save_format,'png')
                    save_options.eps = 0;
                    save_options.png = 1;
                end
            end

            save_figure_to_file(save_options)
            close(m.plotinfo.f(i_fig))
        end
    end
end