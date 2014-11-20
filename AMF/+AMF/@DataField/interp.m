function [val, std] = interp(fieldArr, t, method)

if nargin < 3, method = 'LINEAR'; end

switch upper(method)
    
    case 'LINEAR'
        interpFunc = @interpLinear;
        
    case 'SPLINE'
        interpFunc = @interpSpline;
        
    otherwise
        error('Unknown interpolation method.');
end

for field = fieldArr
    field.time = t(:);
    
    if isConstant(field)
        if isempty(field.src.time)
            % static (no time point)
            val = ones(size(field.time)) * field.curr.val;
            
            if any(field.curr.std)
                std = ones(size(field.time)) * field.curr.std;
            else
                std = [];
            end
        else
            % constant (vector of NaNs with one value at the measured time
            % point)
            timeIdx = find(t == field.src.time);
            val = nan(size(field.time)); val(timeIdx) = field.curr.val;
            
            if any(field.curr.std)
                std = nan(size(field.time)); std(timeIdx) = field.curr.std;
            else
                std = [];
            end
        end
        
        field.val = val;
        field.std = std;
    else
        % dynamic
        [val, std] = interpFunc(field, t);
        field.val = val(:);
        field.std = std(:);
    end
end

val = [fieldArr.val];
std = [fieldArr.std];

% val = zeros(length(t), length(fieldArr));
% std = zeros(length(t), length(fieldArr));
% 
% for i = 1:length(fieldArr)
%     field = fieldArr(i);
%     
%     switch upper(field.type)
%         case 'CONSTANT'
%             val(:,i) = field.val * ones(length(t), 1);
%             std(:,i) = field.std * ones(length(t), 1);
%         otherwise
%             [fieldVal, fieldStd] = interpFunc(field, t);
% 
%             val(:,i) = fieldVal;
%             std(:,i) = fieldStd;
%     end
% end