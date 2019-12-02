%%=========================================================================
% SUBFUNCTION: parse_shave - "shaves" global options from the varargin
%                 * Obs. "Shaved" options will be used out of seisplot_panel
%%=========================================================================
function [opt varargin] = seisplot_parser(varargin)
    global_options_1D = {'subplot','MCG_compare','colorbar','freq_spc','wigb','show'};
    global_options_2D = {'suptitle','save'};
    opt = struct();
    for ii=1:length(global_options_1D)
        temp = getnameidx(varargin,global_options_1D{ii});
        if temp~=0
            opt.(global_options_1D{ii}) = 1;
            varargin = {varargin{1:temp-1},varargin{temp+1:end}};
        else
            opt.(global_options_1D{ii}) = 0;
        end
    end
    for ii=1:length(global_options_2D)
        temp = getnameidx(varargin,global_options_2D{ii});
        if temp~=0
            opt.(global_options_2D{ii}) = varargin{temp+1};
            varargin = {varargin{1:temp-1},varargin{temp+2:end}};
        end
    end
    %Parsing options to varargin
    if opt.freq_spc, 
        varargin{end+1} = 'freq_spc';
        varargin{end+1} = 1;
    end
    if opt.colorbar, 
        varargin{end+1} = 'colorbar';
        varargin{end+1} = 1;
    end
    if opt.wigb, 
        varargin{end+1} = 'wigb';
        varargin{end+1} = 1;
    end

end
