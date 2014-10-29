function save_iter(filename, varargin)
%save R
result = varargin{1};
save(filename, 'result');
end

