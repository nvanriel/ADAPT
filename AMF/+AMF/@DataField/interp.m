function [val, std] = interp(fieldArr, t, method)

if nargin < 3, method = 'LINEAR'; end

switch upper(method)
    
    case 'LINEAR'
        interpFunc = @interpLinear;
        
    case 'SPLINE'
        interpFunc = @interpSpline;
        
    case 'RAND_SPLINE'
        interpFunc = @interpRandSpline;
        
    otherwise
        error('Unknown interpolation method.');
end

for field = fieldArr
    field.time = t(:);
    
    if isConstant(field)
        % constant
        field.val = field.source.val * ones(size(t(:)));
        field.std = field.source.std * ones(size(t(:)));
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