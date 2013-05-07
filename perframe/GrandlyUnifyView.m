classdef GrandlyUnifyView < handle
  properties
    model  % a ref for the model
    fig  % the figure handle
    projectFileLabelText
    projectFileText
    chooseProjectFileButton
    classifierFileLabelText
    classifierFileText
    chooseClassifierFileButton
    gtExpDirsLabelText
    gtExpDirsListbox
    gtExpDirsAddButton
    gtExpDirsRemoveButton
    %quitButton
    convertButton
    spinDepth=0  % how many times spin() has been called, minus how many 
                 % times unspin() has been called
  end
  methods
    function self=GrandlyUnifyView(model,controller)
      self.model=model;
      % Set figure layout parameters
      figureWidth=730;
      figureHeight=274;

      sideButtonWidth=80;  % choose buttons, add/remove buttons
      sideButtonHeight=26;
      sideButtonOffsetWidth=20;  % side buttons are this far to the right of 
                                 % their parent text/listbox
      addRemoveInterButtonHeight=10;
      
      bottomButtonWidth=100;  % Convert and Quit are the bottom buttons
      bottomButtonHeight=30;
      %interBottomButtonWidth=20;
      
      centerColumnWidth=470;
      fileNameTextHeight=20;
      gtExpDirsListboxHeight=100;
      
      projectCenterLineYOffset=240;
      classifierCenterLineYOffset=200;
      gtTopLineYOffset=170;
      
      labelOffsetWidth=20;  % Labels are this far to the left of the 
                            % text/listbox that they label
      
      % Figure the placement of the figure, want it centered relative to
      % primary screen
      savedUnits=get(0,'units');
      set(0,'units','points');
      screenPosition=get(0,'screensize');
      set(0,'units',savedUnits);
      figureXOffset=screenPosition(1)+(screenPosition(3)-figureWidth )/2;
      figureYOffset=screenPosition(2)+(screenPosition(4)-figureHeight)/2;
      
      % Create the figure
      self.fig= ...
        figure('units','points', ...
               'position',[figureXOffset figureYOffset figureWidth figureHeight], ...
               'resize','off', ...
               'numbertitle','off', ...
               'menubar','none', ...
               'name','Grandly Unify', ...
               'windowstyle','normal', ...
               'closeRequestFcn',@(g,e)(controller.quit()));
      
      % make the labels, but make them invisible, so we can get their
      % extents
      self.projectFileLabelText= ...
        uicontrol('parent',self.fig, ...
                  'units','points', ...
                  'style','text', ...
                  'backgroundcolor',get(self.fig,'color'), ...
                  'string','Project File', ...
                  'HorizontalAlignment','right',...
                  'visible','off', ...
                  'fontsize',12);
      extent=get(self.projectFileLabelText,'extent');
      extentSize=extent(3:4);
      %projectFileLabelTextSize=extentSize+4;  % pad a little
      projectFileLabelTextSize=extentSize;
      
      self.classifierFileLabelText= ...
        uicontrol('parent',self.fig, ...
                  'units','points', ...
                  'style','text', ...
                  'backgroundcolor',get(self.fig,'color'), ...
                  'string','Classifier File', ...
                  'HorizontalAlignment','right',...
                  'visible','off', ...
                  'fontsize',12);
      extent=get(self.classifierFileLabelText,'extent');
      extentSize=extent(3:4);
      %classifierFileLabelTextSize=extentSize+4;  % pad a little
      classifierFileLabelTextSize=extentSize;

      self.gtExpDirsLabelText= ...
        uicontrol('parent',self.fig, ...
                  'units','points', ...
                  'style','text', ...
                  'backgroundcolor',get(self.fig,'color'), ...
                  'string',{'Ground-truth', ...
                            'Experiment', ...
                            'Directory Names'}, ...
                  'HorizontalAlignment','right',...
                  'visible','off', ...
                  'fontsize',12);
      extent=get(self.gtExpDirsLabelText,'extent');
      extentSize=extent(3:4);
      %gtExpDirsLabelTextSize=extentSize+4;  % pad a little
      gtExpDirsLabelTextSize=extentSize;
      
      % Calculate positions
      centerColumnXOffset=(figureWidth-centerColumnWidth)/2;
      projectFileTextXOffset=centerColumnXOffset;
      classifierFileTextXOffset=centerColumnXOffset;
      gtExpDirsListboxXOffset=centerColumnXOffset;
      
      sideButtonXOffset=centerColumnXOffset+centerColumnWidth+sideButtonOffsetWidth;
      chooseProjectFileButtonXOffset=sideButtonXOffset;
      chooseClassifierFileButtonXOffset=sideButtonXOffset;
      gtExpDirsAddButtonXOffset=sideButtonXOffset;
      gtExpDirsRemoveButtonXOffset=sideButtonXOffset;
      
      %bottomButtonRowWidth=bottomButtonWidth+interBottomButtonWidth+bottomButtonWidth;
      %bottomButtonRowWidth=bottomButtonWidth;
      convertButtonXOffset=(figureWidth-bottomButtonWidth)/2;
      %convertButtonXOffset=quitButtonXOffset+bottomButtonWidth+interBottomButtonWidth;
      projectFileLabelTextXOffset=centerColumnXOffset-labelOffsetWidth-projectFileLabelTextSize(1);
      classifierFileLabelTextXOffset=centerColumnXOffset-labelOffsetWidth-classifierFileLabelTextSize(1);
      gtExpDirsLabelTextXOffset=centerColumnXOffset-labelOffsetWidth-gtExpDirsLabelTextSize(1);

      projectFileLabelTextYOffset=projectCenterLineYOffset-projectFileLabelTextSize(2)/2;
      classifierFileLabelTextYOffset=classifierCenterLineYOffset-classifierFileLabelTextSize(2)/2;
      gtExpDirsLabelTextYOffset=gtTopLineYOffset-gtExpDirsLabelTextSize(2);
      
      projectFileTextYOffset=projectCenterLineYOffset-fileNameTextHeight/2;
      classifierFileTextYOffset=classifierCenterLineYOffset-fileNameTextHeight/2;
      gtExpDirsListboxYOffset=gtTopLineYOffset-gtExpDirsListboxHeight;
      
      chooseProjectFileButtonYOffset=projectCenterLineYOffset-sideButtonHeight/2;
      chooseClassifierFileButtonYOffset=classifierCenterLineYOffset-sideButtonHeight/2;
      gtExpDirsAddButtonYOffset=gtTopLineYOffset-sideButtonHeight;
      gtExpDirsRemoveButtonYOffset=gtTopLineYOffset-sideButtonHeight-addRemoveInterButtonHeight-sideButtonHeight;

      bottomAreaHeight=gtExpDirsListboxYOffset;  
        % The "bottom area" is the rectangular area below the listbox.  It
        % is as wide as the figure, and it's bottom edge is aligned with
        % with bottom edge of the figure.  The row of bottom buttons is
        % centered within this area.
      bottomButtonYOffset=(bottomAreaHeight-bottomButtonHeight)/2;  
        % for both Quit and Convert buttons

      projectFileTextWidth=centerColumnWidth;
      classifierFileTextWidth=centerColumnWidth;
      gtExpDirsListboxWidth=centerColumnWidth;      
        
      projectFileTextHeight=fileNameTextHeight;
      classifierFileTextHeight=fileNameTextHeight;
      
      
      % Position the labels, make them visible
      set(self.projectFileLabelText, ...
          'position',[projectFileLabelTextXOffset projectFileLabelTextYOffset projectFileLabelTextSize], ...
          'visible','on');
      set(self.classifierFileLabelText, ...
          'position',[classifierFileLabelTextXOffset classifierFileLabelTextYOffset classifierFileLabelTextSize], ...
          'visible','on');
      set(self.gtExpDirsLabelText, ...
          'position',[gtExpDirsLabelTextXOffset gtExpDirsLabelTextYOffset gtExpDirsLabelTextSize], ...
          'visible','on');
        
      % Create the non-label controls  
      self.projectFileText= ...
        uicontrol('parent',self.fig, ...
                  'style','text', ...
                  'backgroundcolor','w', ...
                  'HorizontalAlignment','left',...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[projectFileTextXOffset ...
                              projectFileTextYOffset ...
                              projectFileTextWidth ...
                              projectFileTextHeight]);
      self.classifierFileText= ...
        uicontrol('parent',self.fig, ...
                  'style','text', ...
                  'backgroundcolor','w', ...
                  'HorizontalAlignment','left',...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[classifierFileTextXOffset ...
                              classifierFileTextYOffset ...
                              classifierFileTextWidth ...
                              classifierFileTextHeight]);
      self.gtExpDirsListbox=...
        uicontrol('parent',self.fig, ...
                  'style','listbox', ...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[gtExpDirsListboxXOffset ...
                              gtExpDirsListboxYOffset ...
                              gtExpDirsListboxWidth ...
                              gtExpDirsListboxHeight]);
      self.chooseProjectFileButton= ...
        uicontrol('parent',self.fig, ...
                  'style','pushbutton', ...
                  'string','Choose', ...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[chooseProjectFileButtonXOffset ...
                              chooseProjectFileButtonYOffset ...
                              sideButtonWidth ...
                              sideButtonHeight], ...
                  'callback',@(g,e)(controller.chooseProjectFileButtonPressed()));
      self.chooseClassifierFileButton= ...
        uicontrol('parent',self.fig, ...
                  'style','pushbutton', ...
                  'string','Choose', ...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[chooseClassifierFileButtonXOffset ...
                              chooseClassifierFileButtonYOffset ...
                              sideButtonWidth ...
                              sideButtonHeight], ...
                  'callback',@(g,e)(controller.chooseClassifierFileButtonPressed()));
      self.gtExpDirsAddButton= ...
        uicontrol('parent',self.fig, ...
                  'style','pushbutton', ...
                  'string','Add', ...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[gtExpDirsAddButtonXOffset ...
                              gtExpDirsAddButtonYOffset ...
                              sideButtonWidth ...
                              sideButtonHeight], ...
                  'callback',@(g,e)(controller.gtExpDirsAddButtonPressed()));
      self.gtExpDirsRemoveButton= ...
        uicontrol('parent',self.fig, ...
                  'style','pushbutton', ...
                  'string','Remove', ...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[gtExpDirsRemoveButtonXOffset ...
                              gtExpDirsRemoveButtonYOffset ...
                              sideButtonWidth ...
                              sideButtonHeight], ...
                  'callback',@(g,e)(controller.gtExpDirsRemoveButtonPressed()));
%       self.quitButton= ...
%         uicontrol('parent',self.fig, ...
%                   'style','pushbutton', ...
%                   'string','Quit', ...
%                   'fontsize',12, ...
%                   'units','points', ...
%                   'position',[quitButtonXOffset ...
%                               bottomButtonYOffset ...
%                               bottomButtonWidth ...
%                               bottomButtonHeight], ...
%                   'callback',@(g,e)(self.quitButtonPressed()));
      self.convertButton= ...
        uicontrol('parent',self.fig, ...
                  'style','pushbutton', ...
                  'string','Convert', ...
                  'fontsize',12, ...
                  'units','points', ...
                  'position',[convertButtonXOffset ...
                              bottomButtonYOffset ...
                              bottomButtonWidth ...
                              bottomButtonHeight], ...
                  'callback',@(g,e)(controller.convertButtonPressed()));
                              
      % sync the view with the model
      self.update();
    end  % constructor method

    
    % ---------------------------------------------------------------------
    function spin(self)
      % Change the cursor to the watch cursor
      self.spinDepth=self.spinDepth+1;
      set(self.fig,'pointer','watch');
      drawnow('update');
    end
      
      
    % ---------------------------------------------------------------------
    function unspin(self)
      % Change the cursor back to normal, unless spin() has been called
      % multiple times without a corresponding unspin() calls.
      if self.spinDepth>0 ,
        self.spinDepth=self.spinDepth-1;
        drawnow('update');  % make sure the figure is as it should be before
                            % switching to the normal cursor
        set(self.fig,'pointer','arrow');
        drawnow('update');
      end
    end
    
    
    % ---------------------------------------------------------------------
    function update(self)
      % Update the view to match the model
      
      % Update the project file text object
      if self.model.projectFileSpecified ,
        set(self.projectFileText, ...
            'String',self.model.projectFileName, ...
            'FontAngle','normal');
      else
        set(self.projectFileText, ...
            'String','Not specified', ...
            'FontAngle','italic');
      end
        
      % Update the classifier file text object
      if self.model.classifierFileSpecified ,
        set(self.classifierFileText, ...
            'String',self.model.classifierFileName, ...
            'FontAngle','normal');
      else
        set(self.classifierFileText, ...
            'String','Not specified', ...
            'FontAngle','italic');
      end
      
      % Update the GT experiment listbox
      set(self.gtExpDirsListbox,'String',self.model.gtExpDirNames);
      set(self.gtExpDirsListbox,'Value',self.model.iCurrentGTExpDir);

      % Update enablement of Remove button
      set(self.gtExpDirsRemoveButton,'enable',offIff(isempty(self.model.gtExpDirNames)));
      
      % Update enablement of convert button
      set(self.convertButton,'enable',onIff(self.model.projectFileSpecified));
    end  % method
    
    % ---------------------------------------------------------------------
    function close(self)
      if ishandle(self.fig)
        delete(self.fig);
        self.fig=[];
      end
    end  % method
    
  end
end
