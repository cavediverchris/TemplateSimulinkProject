The Resources folder contains useful reference information. 

The config file is used with SVN to configure the locally installed client. The primary changes that exist within this config file compared to the default config file that comes with SVN is the addition of instructions on how to handle MATLAB- and Simulink-specific files.

The reason for this is because of SVNs built-in techniques for handling files: SVN by default will try to store the differences between files - this traditionally has resulted in issues when reverting to previous revisions of a MATLAB- and Simulink-specific files.
