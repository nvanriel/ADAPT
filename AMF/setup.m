function setup()

addpath(genpath('.'));

disp('Added the AMF core folder and subfolders to path.');

try
    matlabpool
catch err
    fprintf('No parallel pool available.');
end