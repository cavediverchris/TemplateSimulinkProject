function [NewModelName] = CreateDialog(CombinedArray, FirstPrefix)
%CREATEDIALOG Summary of this function goes here
%   Detailed explanation goes here

% Initialise temporary values
choice = 'TBD';
name = 'TBD2';

dlg = dialog('Position', [300 300 500 150],'Name','Specify New Model Name');

    txt1 = uicontrol('Parent',dlg,...
            'Style','text',...
            'Position',[20 80 210 40],...
            'String','Select a prefix');
       
    popup = uicontrol('Parent',dlg,...
            'Style','popup',...
            'Position',[75 70 100 25],...
            'String',CombinedArray, ...;
            'Callback', @popup_callback);
        %'String',{'Red','Green','Blue'});
            
            

    txt2 = uicontrol('Parent',dlg,...
            'Style','text',...
            'Position',[230 80 210 40],...
            'String','Provide a name');
       
    edit1 = uicontrol('Parent',dlg,...
            'Style','edit',...
            'Callback', @edit_callback, ...
            'Position',[280 70 100 25]);
        
        
    btn = uicontrol('Parent',dlg,...
            'Position',[89 20 70 25],...
            'String','Done',...
            'Callback',@btn_callback);
        

uiwait(dlg)

    function popup_callback(popup, event)
        % Deduce prefix chosen
        idx = popup.Value;
        popupitems = FirstPrefix;
        choice = char(popupitems(idx,:));
    end

    function edit_callback(edit1, event)      
        % Deduce name given
        name = char(edit1.String);
    end

    function btn_callback(btn, event)      
            % Deduce name given
            @popup_callback;
            @edit_callback;
            NewModelName = strcat(choice, '_', name);
            delete(gcf);
    end
end