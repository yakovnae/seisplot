%%=========================================================================
% SUBFUNCTION: seisplot_MCG_compare - plots a sum version of each pannel
%%=========================================================================
function seisplot_MCG_compare(data,volume_names,varargin)
    n=2*length(volume_names);
    sf = zeros(1,2*length(volume_names));
    index=1;
    for ii=1:length(volume_names)
        sf(index)   =  subplot(1,n,index);   
            seisplot_panel(data.(volume_names{ii}),ii,varargin{:}); title(volume_names{ii});
        sf(index+1) =  subplot(1,n,index+1); 
            if size(data.(volume_names{ii}),2)>1
                seisplot_panel(sum(data.(volume_names{ii}),2),ii,varargin{:});
                set(gca,'YDir','reverse');
            else
                seisplot_panel(data.(volume_names{ii}),ii,varargin{:});
            end
            title(volume_names{ii});
            index=index+2;
    end
    linkaxes(sf,'y');
end