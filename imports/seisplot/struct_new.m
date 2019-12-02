function [output] = struct_new(varargin)
% struct_new: creating an structure with n identical pannels
%
%
%  struct_new(varargin) - This function can be called in three modes:
%                     (1) struct_new(size,name1,name2...)
%                     (2) struct_new(name1,vol1, name2,vol2...)
%                     (3) struct_new(vol1, vol2...)
%
% 08 April 2014, Author: Yakov Nae, PhD student, KobiNae@gmail.com
% Signal Processing Laboratory for Communications - UNICAMP\FEEC\DMO\DSPCom
% Tel:+55(19)3521-3857 Campinas,SP-Brazil; http://www.dspcom.fee.unicamp.br
    output = [];
    
    %struct_new(size,name1,name2...) - creates a zerorized structure with volumes 
    %                               of size and names (name1,name2,...)
    if isnumeric(varargin{1}) && ...
       length(size(varargin{1})) == 2 && ...
       size(varargin{1},1) == 1 && size(varargin{1},2) == 2
        pannel_size = varargin{1};
        for ii=2:length(varargin)
            output.(varargin{ii}) = zeros(pannel_size(1), pannel_size(2));
        end
        return;
    end
    %struct_new(name1,vol1, name2,vol2...) - creates a volume structure with name 
    %                                     entries and their data volumes 
    if ischar(varargin{1})&&  ...
       (length(varargin)>1)&& ...
       isnumeric(varargin{2})
        for ii=1:2:length(varargin)
            output.(varargin{ii}) = varargin{ii+1};
        end
        return;
    end
    %struct_new(vol1, vol2...) - creates a volume structure with names d1,d2,... 
    %                        and data volumes vol1,vol2... respectivly
    %                        vol can be an structure also
    %struct_new(vol1,'name1',vol2,vol3,...) - non structure volumes can be named
    ii=1;
    while (ii<=length(varargin))
        flag=true;
        %case vol,'name'
        if ( flag && isnumeric(varargin{ii}) && ((ii+1)<=length(varargin)) )
            if isstr( varargin{ii+1} )
                output.(varargin{ii+1})=varargin{ii};
                ii=ii+1;
                flag=false;
            end
        end
        %case vol is not an structure
        if ( flag && isnumeric(varargin{ii}) )
            if strcmp(inputname(ii),'')
                output.(['d' num2str(ii)]) = varargin{ii};
            else output.(inputname(ii)) = varargin{ii};
            end
            flag=false;
        end
        %case vol is an structure
        if ( flag && isstruct(varargin{ii}) )
           fnames=fieldnames(varargin{ii});
           for jj=1:length(fnames)
               output.(fnames{jj}) = varargin{ii}.(fnames{jj});
           end
           flag=false;
        end
        if (flag), error('struct_new :: Could not mount a data structure'); end
        ii=ii+1;
    end %while
end %end function