function outputStr = mexify2(inputStr, compName)

outputStr = inputStr;

% parsers
outputStr = regexprep(outputStr, '([-+\w]+)\^([-+\w]+)', 'pow($1,$2)');

outputStr = regexprep(outputStr, 'if\((.*),(.*),(.*)\)', sprintf('0;\nif ($1)\n\t%s = $2;\nelse\n\t%s = $3;\nend', compName, compName));