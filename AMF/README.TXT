** Read the manual (manual.pdf) for a complete overview of how to install and use the AMF package.

Install the ADAPT Modeling Framework (AMF) by running

setup

in the AMF root directory. This will add all subdirectories to the MATLAB path and will attempt to start a parralel pool.
To run the examples, please make sure the ODEMEX toolbox is configured properly (Instructions.pdf located in the odemex folder).

The following example run files are included:

runToy

-> runs ADAPT on the toy model (Natal van Riel et al) to compute parameter trajectories

runMinGluc

-> fits the minimal glucose model (Dalla man et al) to post-bariatric surgery insulin data

runMinCPep

-> fits the minimal c-peptide model (Dalla man et al) to post-bariatric surgery glucose data