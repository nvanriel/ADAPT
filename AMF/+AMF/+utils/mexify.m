function outputStr = mexify(inputStr)

outputStr = inputStr;

% parsers
outputStr = regexprep(outputStr, '([-+\w]+)\^([-+\w]+)', 'pow($1,$2)');