This folder is used to contain scripts that are used to enforce a Referenced Model COnfiguration.

Using a Referenced Model Configuration means that all Simulink models that use it will be consistent with each
other. Multiple Model Configurations can be generated, for example, in one Referenced Model Configuration you
may choose a small timestep, possibly for a closed-loop controller for a plant item, however another Referenced
Model Configuration may use a significantly larger timestep because it is for a system-level (or platform-level)
controller.

Model Configurations will come in pairs: the Simulink Model and an *m file. The M-file captures all of the
configuration information within the Simulink in a textual form. Historically it has always been easier to 
edit the Simulink model and generate a new *.m file from it. This has also been easier because normally small
incremental changes will be made, such as changing the time step from 100 Hz (frequency equivalent) to say
120 Hz (frequency equivalent), compared to drastic changes across a large number of parameters.
