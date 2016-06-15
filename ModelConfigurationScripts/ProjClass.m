%% Project Class File
% The purpose of the Project Class file is to parameterise numbers that
% will be re-used across the entire model. These numbers could be detector
% dimensions for example. The reason they are being parameterised and
% stored here is so that they are defined once and can be used globally.

classdef ProjClass
    properties (Constant)        
        %% Truth Data Generator
        table_rate = 1.75; % rads per second (100 deg/s)
        
    end
    
%     methods        
%     %% Method Storage
%     function obj = methodName(obj,arg2)
%         %TODO
%         obj(arg2);
%     end
%     end
%     
%     %% Events Storage
%     events()
%         
%         
%     end
%     %% Enumeration Storage
%     enumeration
%         EnumName
%     end

end
