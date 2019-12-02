function sff = seisplot(data,varargin)
%seisplot: ploting several data volumes for comparing up to 4 volumes
%
%  seisplot(data,varargin)
%
%  IN   data: Seismic data set. 
%             Can either be a single matrix or a structure that contains 
%             several matixes
%  Example:
%   seisplot('ex3','subplot') - Plots 3 example volumes side by side
%   seisplot(vol,'dt',0.008,'cmap','jet') - Plots the seismic volume 'vol' 
%                                        considering dt=.008ms and jet colormap
%
%  Main options:
%   'dt'         (default = 0.004)
%   'hV'         (default = 1:nx)
%   'axis'       (default = []) 
%   'tpow'       (default = 2)
%   'gain_norm'  (default = 0)
%   'interp'     (default = 4)
%   'box'        (default = {})
%   'cmap'       (default = 'gray')
%   'title'      (default = inputname(1))
%   'font_size'  (default = 0)
%   'markerLine' (default = 0)
%   'perc'       (default = 99)
%
%  Main global_options:
%   'subplot'     - Plots all panels as subplots on the same figure
%   'colorbar'    - Plots the colorbar for each figure
%   'freq_spc'    - Plots the frequency spectrum of the signals
%   'suptitle'    - Plots a supertitle above subfigures
%   'save'        - 'name.pdf' save all results to single pdf file
%                   'name.sgy' save all results to sgy files  
%   'MCG_compare' - Plots a sum panel for each pannel
%
% -------------------
% More Examples:
%       Example: seisplot('ex3','subplot')
%       Example: seisplot('ex3','MCG_compare')
%       Example: seisplot('ex','subplot','interp',5); seisplot('ex','subplot');
%
% Save examples:
%      Example: seisplot('ex3','save','1.pdf');
%      Example: seisplot('ex3','save','1.sgy');
%
%
% 09 Janurary 2014, Author: Yakov Nae, PhD student, KobiNae@gmail.com
% Signal Processing Laboratory for Communications - UNICAMP\FEEC\DMO\DSPCom
% Tel:+55(19)3521-3857 Campinas,SP-Brazil; http://www.dspcom.fee.unicamp.br
%
    TAG = 'seisplot';
    warning('off','MATLAB:nargchk:deprecated')
    [opt, varargin] = seisplot_parser(varargin{:});

    if iscell(data), data=struct_new(data{:}); end
    if ischar(data) && ~isempty(strfind(data,'ex'))
        if length(data) > 2 
            numex = str2num(data(3));
        else 
            numex = 1;
        end
        data = struct;
        for ii=1:numex
            data.([ 'ex' num2str(ii) ]) = example_panel();
        end
    end
    if ischar(data)
        if length(data) < 5
            error([TAG ' :: Please check file name. It must end with one' ...
                       ' of the following of sgy/segy/su/MAT']);
        end
        [filepath,name,ext] = fileparts(data);
        if (strcmp(ext,'.sgy') || strcmp(ext,'.segy')) == 1
            [d,h1,h2]=ReadSegy(data);
            seisplot(d);
        else
            fprintf('su format and MAT will be launched in newer versions');
        end
        return;
    end
    if ~isstruct(data), 
        tmp=inputname(1);
        if isempty(tmp), tmp='d1'; end
           tmp2=data;
           clear data;
           data.(tmp)=tmp2; 
    end

    volume_names = fieldnames(data);
    if isfield(opt,'save')
        close all;
        file_exe=ses_save(opt,data,volume_names,varargin{:});
        if strcmp(file_exe,'.pdf')~=1
            if opt.show~=1, return; end
        end
    end
    if length(volume_names)>1
        if opt.MCG_compare
            seisplot_MCG_compare(data,volume_names,varargin{:});
            return;
        end
        sff = zeros(1,length(volume_names));
        [ty, tx] = size(getfield(data,volume_names{1}));
        for ii=2:length(volume_names)
            [ty2, tx2] = size(getfield(data,volume_names{ii}));
            if (ty~=ty2)||(tx~=tx2)
                error([TAG ' :: volumes are not of the same size']);
            end
        end
        for ii=1:length(volume_names)
            if opt.subplot
                if opt.freq_spc
                    sff(ii) = subplot(length(volume_names),1,ii);
                else
                    sff(ii) = subplot(1,length(volume_names),ii);
                end
            else
                eval(['f' num2str(ii)]) = figure;
                set(eval(['f' num2str(ii)]), 'WindowStyle', 'docked');
                sff(ii) = subplot(2,1,1:2);
            end
            varargintemp = varargin;
            if getnameidx(varargintemp,'title')==0
                varargintemp{end+1} = 'title';
                varargintemp{end+1} = volume_names;
            end
            seisplot_panel(getfield(data,volume_names{ii}),ii,varargintemp{:}); 
        end
        linkaxes(sff,'xy');
    else%single seisplot can be a part of subplot
            varargintemp = varargin;
            if getnameidx(varargintemp,'title')==0
                varargintemp{end+1} = 'title';
                varargintemp{end+1} = {inputname(1)};
            else 
                varargintemp{getnameidx(varargintemp,'title')+1} = ...
                { varargintemp{getnameidx(varargintemp,'title')+1} };    
            end
            sff=gcf;
            seisplot_panel(data.(volume_names{1}),1, varargintemp{:});
    end
    
    if isfield(opt,'suptitle')
        suptitle(opt.suptitle);
    end
    if isfield(opt,'save'), 
        [a1,a2,a3]=fileparts(opt.save);
        if (strcmp(a3,'.pdf')==1), save_figs2pdf(opt.save); end
    end
    warning('on','MATLAB:nargchk:deprecated')
end