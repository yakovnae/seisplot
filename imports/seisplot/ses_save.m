function [o] = ses_save(opt,data,volume_names,varargin)
    tmp=strfind(opt.save,' ');
    if isempty(tmp)
        dgopts='';
        file_name=opt.save;
    else
        dgopts=opt.save(tmp(1):end);
        file_name=opt.save(1:(tmp(1)-1));
    end

    [a1,a2,a3]=fileparts(file_name);
    o=a3;
    tmp=fullfile(a1,a2);
    if (strcmp(a3,'.sgy')==1)
        p=parse_seisplot_panel(size(data.(volume_names{1}),2),varargin{:});
        for ii=1:length(volume_names)
            WriteSegy([tmp '_' volume_names{ii} a3],data.(volume_names{ii}),'dt',p.dt,'offset',p.hV);
        end
        return;
    end
end