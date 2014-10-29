function get_one(folder)
    list = dir(folder);
    files = cell(1,length(list)-2);
    for i = 3:length(list);
        split =  strsplit(list(i).name, 'result');
        if strcmp(split{1}, '')
            load([folder list(i).name])
            R(i-2).raw_data = result.raw_data;
            R(i-2).t = result.t;
            R(i-2).p = result.p;
            R(i-2).x = result.x;
            R(i-2).y = result.y;
            R(i-2).j = result.j;
            R(i-2).j1 = result.j1; R(i-2).j2 = result.j2; R(i-2).j3 = result.j3;
            R(i-2).j4 = result.j4; R(i-2).j5 = result.j5; R(i-2).j6 = result.j6;
            R(i-2).j7 = result.j7; R(i-2).j8 = result.j8; R(i-2).j9 = result.j9;
            R(i-2).j10 = result.j10; R(i-2).jm = result.jm;
            R(i-2).SSE = result.SSE;
            R(i-2).spline_data = result.spline_data;
            R(i-2).spline_func = result.spline_func;
            R(i-2).data_sample = result.data_sample;
            R(i-2).gene_spline = result.gene_spline;
            R(i-2).gene_func = result.gene_spline_func;
            R(i-2).gene_sample = result.gene_sample;
            R(i-2).p_initial = result.p_initial;
            R(i-2).x0 = result.x0;
            R(i-2).lab1 = result.lab1;
            R(i-2).lab2 = result.lab2;
        end
        files{i-2} = [folder list(i).name];
    end
    save([folder 'result'], 'R');
    delete(files{:});
end
    
