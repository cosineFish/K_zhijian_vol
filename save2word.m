function save2word(filespec,prnopt)
% if nargin<1 | isempty(filespec);
%   [fname, fpath] = uiputfile('*.doc');
%   if fpath == 0; return; end
%   filespec = fullfile(fpath,fname);
% else
%   [fpath,fname,fext] = fileparts(filespec);
%   if isempty(fpath); fpath = pwd; end
%   if isempty(fext); fext = '.doc'; end
%   filespec = fullfile(fpath,[fname,fext]);
% end
% 
% % Capture current figure/model into clipboard:
% if nargin<2
%   print -dmeta
% else
%   set(gcf,'inverthardcopy','off');
%   print('-dmeta',prnopt)
% end
% 
% % Start an ActiveX session with PowerPoint:
% word = actxserver('Word.Application');
% %word.Visible = 1;
% 
% if ~exist(filespec,'file');
%    % Create new presentation:
%   op = invoke(word.Documents,'Add');
% else
%    % Open existing presentation:
%   op = invoke(word.Documents,'Open',filespec);
% end
% 
% % Find end of document and make it the insertion point:
% end_of_doc = get(word.activedocument.content,'end');
% set(word.application.selection,'Start',end_of_doc);
% set(word.application.selection,'End',end_of_doc);
% 
% % Paste the contents of the Clipboard:
% invoke(word.Selection,'Paste');
% 
% if ~exist(filespec,'file')
%   % Save file as new:
%   invoke(op,'SaveAs',filespec,1);
% else
%   % Save existing file:
%   invoke(op,'Save');
% end
% 
% % Close the presentation window:
% invoke(op,'Close');
% 
% % Quit MS Word
% invoke(word,'Quit');
% 
% % Close PowerPoint and terminate ActiveX:
% delete(word);

return