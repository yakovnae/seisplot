function save_figs2pdf(pdf_name,varargin)
% save_figs2pdf: Saves all open figures into a single PDF file
%
%  save_figs2pdf(pdf_name,varargin)
%
%  IN pdf_name - File name to create
%
% OPTIONS:
%  'figs=[1,4,5,2]'            - Saves figs specified by the vector
%  'position=[691,91,745,706]' - Positions all figs before saving 
%  'overwrite=1'               - overwrite file if exist
%
%  'tmp_folder=/tmp/tmp'          - Uses a different temp directory
%
%
%  EXAMPLES: save_figs2pdf('all.pdf','position=[691,91,745,706]')
%            save_figs2pdf('all.pdf','figs=[1,4,5,2])
%
%
% COMMENTS:
% (1) tmp_folder is created and deleted allways
%
% 23 Jan 2017, Author: Yakov Nae, PhD student, KobiNae@gmail.com
% Signal Processing Laboratory for Communications - UNICAMP\FEEC\DMO\DSPCom
% Tel:+55(19)3521-3857 Campinas,SP-Brazil; http://www.dspcom.fee.unicamp.br

    clear opt;
    opt.figs=sort(findall(0,'Type','figure'));
    opt.tmp_folder=fullfile(getenv('HOME'),'Desktop','TMPpdf');
    opt.overwrite=true;
    opt.position=0;
    [opt]=myparse(opt,varargin{:});
    if opt.overwrite==1
        if isequal(exist(opt.tmp_folder, 'dir'),7), rmdir(opt.tmp_folder,'s'); end
        if isequal(exist(pdf_name,'file'),2), delete(pdf_name); end
    end
    if isequal(exist(pdf_name,'file'),2), 
        fprintf('file name already exist.\n');
        return;
    end
 
    if isequal(exist(opt.tmp_folder, 'dir'),7)
        fprintf('temporary directory already exist. Do you wish to delete it?(y/n)\n');
        c=getkeywait(5);
        if ( (c==121) || (c==89) ) %char(121)='y' char (89)='Y' 
            rmdir(opt.tmp_folder,'s'); 
        else
            fprintf('%s Stopped because temp directory exists.\n',mfilename);
            return;
        end
    end

    mkdir(opt.tmp_folder);
    for ii=1:length(opt.figs)
        figure(opt.figs(ii));
        set(gcf, 'PaperPosition', [0 0 5 5]); %Position plot at left hand corner with width 5 and height 5.
        set(gcf, 'PaperSize', [5 5]); %Set the paper to have width 5 and height 5.
        if opt.position~=0, set(gcf,'Position',opt.position); end
        saveas(gcf, fullfile(opt.tmp_folder,num2str(ii)), 'pdf');%Save figure 
    end
    tmp = dir(fullfile(opt.tmp_folder, '*.pdf'));
    if length(tmp)==1
        movefile(fullfile(opt.tmp_folder,tmp.name),pdf_name);
    else
        if computer == 'MACI64'
            [~,~]=system(['source ~/.bashrc; gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile='    pdf_name ' ' fullfile(opt.tmp_folder,'*.pdf')]);
        else
            [~,~]=system(['source ~/.bashrc; pdfunite ' fullfile(opt.tmp_folder,'*.pdf') ' ' pdf_name]);
        end
    end
    rmdir(opt.tmp_folder,'s'); 
end

function ch = getkeywait(m) 
% GETKEYWAIT - get a key within a time limit
%   CH = GETKEYWAIT(P) waits for a keypress for a maximum of P seconds. P
%   should be a positive number. CH is a double representing the key
%   pressed key as an ascii number, including backspace (8), space (32),
%   enter (13), etc. If a non-ascii key (Ctrl, Alt, etc.) is pressed, CH
%   will be NaN.
%   If no key is pressed within P seconds, -1 is returned, and if something
%   went wrong during excution 0 is returned. 
%
%  See also INPUT,
%           GETKEY (FileExchange)

% tested for Matlab 6.5 and higher
% version 2.1 (jan 2012)
% author : Jos van der Geest
% email  : jos@jasen.nl

% History
% 1.0 (2005) creation
% 2.0 (apr 2009) - expanded error check on input argument, changed return
% values when a non-ascii was pressed (now NaN), or when something went
% wrong (now 0); added comments ; slight change in coding
% 2.1 (jan 2012) - modified a few properties, included check is figure
%                  still exists (after comment on GETKEY on FEX by Andrew). 

% check input argument
error(nargchk(1,1,nargin)) ;
if numel(m)~=1 || ~isnumeric(m) || ~isfinite(m) || m <= 0,    
    error('Argument should be a single positive number.') ;
end

% set up the timer
tt = timer ;
tt.timerfcn = 'uiresume' ;
tt.startdelay = m ;            

% Set up the figure
% May be the position property should be individually tweaked to avoid visibility
callstr = 'set(gcbf,''Userdata'',double(get(gcbf,''Currentcharacter''))) ; uiresume ' ;
fh = figure(...
    'name','Press a key', ...
    'keypressfcn',callstr, ...
    'windowstyle','modal',... 
    'numbertitle','off', ...
    'position',[0 0  1 1],...
    'userdata',-1) ; 
try
    % Wait for something to happen or the timer to run out
    start(tt) ;    
    uiwait ;
    ch = get(fh,'Userdata') ;
    if isempty(ch), % a non-ascii key was pressed, return a NaN
        ch = NaN ;
    end
catch
    % Something went wrong, return zero.
    ch = 0 ;
end

% clean up the timer ...
stop(tt) ;
delete(tt) ; 
% ... and figure
if ishandle(fh)
    delete(fh) ;
end
end
