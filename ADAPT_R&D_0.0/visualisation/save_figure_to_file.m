function save_figure_to_file(save_options)


%% Construct the filename
if numel(save_options.filename) < 5 || ~strcmpi(save_options.filename(end-3:end), '.eps')
    save_options.filename = [save_options.filename '.eps']; % Add the missing extension
end


%% Find all the used fonts in the figure
font_handles = findall(save_options.fig_handle, '-property', 'FontName');
fonts = get(font_handles, 'FontName');
if ~iscell(fonts)
    fonts = {fonts};
end


%% Map supported font aliases onto the correct name
fontsl = lower(fonts);
for a = 1:numel(fonts)
    f1 = fontsl{a};
    f1(f1==' ') = [];
    switch f1
        case {'times', 'timesnewroman', 'times-roman'}
            fontsl{a} = 'times-roman';
        case {'arial', 'helvetica'}
            fontsl{a} = 'helvetica';
        case {'newcenturyschoolbook', 'newcenturyschlbk'}
            fontsl{a} = 'newcenturyschlbk';
        otherwise
    end
end
fontslu = unique(fontsl);
% Determine the font swap table
matlab_fonts = {'Helvetica', 'Times-Roman', 'Palatino', 'Bookman', 'Helvetica-Narrow', 'Symbol', ...
                'AvantGarde', 'NewCenturySchlbk', 'Courier', 'ZapfChancery', 'ZapfDingbats'};
matlab_fontsl = lower(matlab_fonts);
require_swap = find(~ismember(fontslu, matlab_fontsl));
unused_fonts = find(~ismember(matlab_fontsl, fontslu));
font_swap = cell(3, min(numel(require_swap), numel(unused_fonts)));
fonts_new = fonts;
for a = 1:size(font_swap, 2)
    font_swap{1,a} = find(strcmp(fontslu{require_swap(a)}, fontsl));
    font_swap{2,a} = matlab_fonts{unused_fonts(a)};
    font_swap{3,a} = fonts{font_swap{1,a}(1)};
    fonts_new(font_swap{1,a}) = {font_swap{2,a}};
end


%% Swap the fonts
if ~isempty(font_swap)
    fonts_size = get(font_handles, 'FontSize');
    if iscell(fonts_size)
        fonts_size = cell2mat(fonts_size);
    end
    M = false(size(font_handles));
    % Loop because some changes may not stick first time, due to listeners
    c = 0;
    update = zeros(1000, 1);
    for b = 1:10 % Limit number of loops to avoid infinite loop case
        for a = 1:numel(M)
            M(a) = ~isequal(get(font_handles(a), 'FontName'), fonts_new{a}) || ~isequal(get(font_handles(a), 'FontSize'), fonts_size(a));
            if M(a)
                set(font_handles(a), 'FontName', fonts_new{a}, 'FontSize', fonts_size(a));
                c = c + 1;
                update(c) = a;
            end
        end
        if ~any(M)
            break;
        end
    end
    % Compute the order to revert fonts later, without the need of a loop
    [update, M] = unique(update(1:c));
    [M, M] = sort(M);
    update = reshape(update(M), 1, []);
end


%% Set paper size
old_pos_mode = get(save_options.fig_handle, 'PaperPositionMode');
old_orientation = get(save_options.fig_handle, 'PaperOrientation');
set(save_options.fig_handle, 'PaperPositionMode', 'auto', 'PaperOrientation', 'portrait');


%% MATLAB bug fix - black and white text can come out inverted sometimes
% Find the white and black text
white_text_handles = findobj(save_options.fig_handle, 'Type', 'text');
M = get(white_text_handles, 'Color');
if iscell(M)
    M = cell2mat(M);
end
M = sum(M, 2);
black_text_handles = white_text_handles(M == 0);
white_text_handles = white_text_handles(M == 3);


%% Set the font colors slightly off their correct values
set(black_text_handles, 'Color', [0 0 0] + eps);
set(white_text_handles, 'Color', [1 1 1] - eps);


%% MATLAB bug fix - white lines can come out funny sometimes
% Find the white lines
white_line_handles = findobj(save_options.fig_handle, 'Type', 'line');
M = get(white_line_handles, 'Color');
if iscell(M)
    M = cell2mat(M);
end
white_line_handles = white_line_handles(sum(M, 2) == 3);


%% Set the line color slightly off white
set(white_line_handles, 'Color', [1 1 1] - 0.00001);


%% Print to eps and png files
if save_options.eps
    print(save_options.fig_handle,'-depsc2',save_options.filename);
end
if save_options.png
    print(save_options.fig_handle,'-dpng',[save_options.filename(1:end-4) '.png']);
end


%% Reset the font and line colors
set(black_text_handles, 'Color', [0 0 0]);
set(white_text_handles, 'Color', [1 1 1]);
set(white_line_handles, 'Color', [1 1 1]);


%% Reset paper size
set(save_options.fig_handle, 'PaperPositionMode', old_pos_mode, 'PaperOrientation', old_orientation);


%% Correct the fonts
if ~isempty(font_swap)
    % Reset the font names in the figure
    for a = update
        set(font_handles(a), 'FontName', fonts{a}, 'FontSize', fonts_size(a));
    end
    % Replace the font names in the eps file
    font_swap = font_swap(2:3,:);
    try
        swap_fonts(save_options.filename, font_swap{:});
    catch
        warning('swap_fonts() failed. This is usually because the figure contains a large number of patch objects. Consider exporting to a bitmap format in this case.');
        return
    end
end


%% Fix the line styles
try
    fix_lines(save_options.filename);
catch
%     warning('fix_lines() failed. This is usually because the figure contains a large number of patch objects. Consider exporting to a bitmap format in this case.');
end
return



% =========================================================================================================================
function swap_fonts(fname, varargin)
% Read in the file
fh = fopen(fname, 'r');
if fh == -1
    error('File %s not found.', fname);
end
fstrm = fread(fh, '*char')';
fclose(fh);

% Replace the font names
for a = 1:2:numel(varargin)
    fstrm = regexprep(fstrm, [varargin{a} '-?[a-zA-Z]*\>'], varargin{a+1}(~isspace(varargin{a+1})));
end

% Write out the updated file
fh = fopen(fname, 'w');
if fh == -1
    error('Unable to open %s for writing.', fname2);
end
fwrite(fh, fstrm, 'char*1');
fclose(fh);
return