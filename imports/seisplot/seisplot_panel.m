%%=========================================================================
% SUBFUNCTION: seisplot_panel - plots a signel seismic panel
%%=========================================================================
function seisplot_panel(data,ind,varargin)
    [nt nx] = size(data);
    p = parse_seisplot_panel(nx,varargin{:});
    if p.freq_spc
        data =  abs( mean(fftshift(fft(data)),2)/nt );
        p.tpow = 0;
        p.prec = 0;
    end
    if length(p.hV)>1
        if p.interp>0
            if length(unique(p.hV(2:end)-p.hV(1:end-1)))~=1, error('hV is not regular'); end
            data = interp(data,p.interp);
%             p.hV = p.hV(1):(p.hV(2)-p.hV(1))/p.interp:p.hV(end);
            p.hV=linspace(p.hV(1),p.hV(end),(length(p.hV)-1)*p.interp+1);
        elseif p.interp<0, 
            data=data(:,1:abs(p.interp):end); 
            p.hV = p.hV(1:abs(p.interp):end);
        end
    end
    
    if length(p.tV)==1
        tV = (0:nt-1)*p.dt;
    else tV = p.tV;
    end
    data_temp=data;
    
    if length(p.bp_filter)==4%if on - apply band pass filtering
        for ii=1:size(data_temp,2)
            data_temp(:,ii) = bp_filter(data_temp(:,ii),p.dt,p.bp_filter);
        end
    end
    
    if p.clip~=0
        data_temp = clip(data_temp,p.clip);
    elseif p.agc>0,
            data_temp = perc(gain(data_temp,p.dt,'agc',p.agc,p.gain_norm),p.perc(min(ind,length(p.perc))));
        else 
            data_temp = perc(gain(data_temp,p.dt,'time',[p.tpow 0],p.gain_norm),p.perc(min(ind,length(p.perc))));
    end

    
    if size(data,2)==1
        if ~p.freq_spc
            plot(data_temp,tV);
            set(gca,'YDir','reverse');
        else
            plot(-1/p.dt/2:1/p.dt/nt:1/p.dt/2-1/p.dt/nt, data_temp);
        end
    else
        if p.wigb==0
             if p.interp==0
                 imagesc(p.hV,tV,data_temp);
             else
                pimage(p.hV,tV,data_temp);
             end
            if ~isempty(p.markerLine)
               ppp = patch([p.markerLine(:,1);NaN],[p.markerLine(:,2);NaN],'y');
               set(ppp,'edgecolor','y','linewidth',15);
               set(ppp,'EdgeAlpha',0.2);  
            end
            if ~isempty(p.marker)
                hold on
                plot(p.marker(1),p.marker(2),'vw','markerfacecolor','blue');
                hold off;
            end            
        else
%             if p.interp == 0, p.interp = 1; end;
%             hvTemp = p.hV(1):(p.hV(2)-p.hV(1))/p.interp:p.hV(end);
            wigb(data_temp,1,p.hV,tV);
        end
        for ii=1:length(p.box)
            boxtemp=p.box{ii};
            boxtemp=[boxtemp(1) boxtemp(3) boxtemp(2)-boxtemp(1) boxtemp(4)-boxtemp(3)];
            hold on, rectangle('position',boxtemp, 'LineWidth',p.box_line_width ,'EdgeColor','k');
        end
    end
    %AXIS; COLORBAR;
    if ~isempty(p.axis), 
        axis(local_get_axis(p,data)); 
    end
    if p.colorbar, colorbar; end
    %COLORMAP AS STRING OR MATRIX    
    if ~iscell(p.cmap)&&ischar(p.cmap)
        colormap(eval(p.cmap));
    elseif ~iscell(p.cmap)&&~ischar(p.cmap)
        colormap(p.cmap);
    elseif iscell(p.cmap)&&ischar(p.cmap{ind})
        colormap(eval(p.cmap{ind}));
    elseif iscell(p.cmap)&&~ischar(p.cmap{ind})
        colormap(p.cmap{ind});
    end
    %----------------------------------------------------------------------
    %PLOTING THE TITLE-----------------------------------------------------
    %replaceing the '_' character (var name) with space to avoid subscript-
    if iscell(p.title), title_fig = p.title{ind};
                      else title_fig = p.title; end;
    if ~isempty(title_fig)&&~strcmp(title_fig(1),'$')%used incase of latex style
        title_fig = strrep(title_fig,'_',' ');
    elseif isempty(title_fig), title_fig='';
    end
    
    
    opt_tmp = {};
    if p.font_size ~= 0,
        set(gca,'FontSize',p.font_size);
        opt_tmp{end+1} = 'FontSize'; opt_tmp{end+1} = p.font_size;
    end
    
    if ~isempty(title_fig)&&strcmp(title_fig(1),'$')
        opt_tmp{end+1} = 'Interpreter'; opt_tmp{end+1} = 'latex';
    end
    title(title_fig,opt_tmp{:});
    if p.freez_colors, freezeColors; end;
    if length(p.caxis)==2,
        caxis manual; caxis(p.caxis);
    end
    if strcmp(get(gcf,'WindowStyle'),'docked')~=1, 
        if ~isempty(p.Position), set(gcf,'Position',p.Position); end
    end
end
%%=========================================================================
% SUBFUNCTION: parse_seisplot_panel - parses the seisplot_panel options
%%=========================================================================
function p = parse_seisplot_panel(nx,varargin)
    pR = inputParser;
    addOptional(pR,'dt',            0.004,      @isnumeric);
    addOptional(pR,'hV',            1:nx,       @isnumeric);
    addOptional(pR,'axis',          [],         @isnumeric);
    addOptional(pR,'Position',      [],         @isnumeric);
    addOptional(pR,'tpow',          2,          @isnumeric);
    addOptional(pR,'interp',        0,          @isnumeric);
    addOptional(pR,'box',           {},         @iscell);
    addOptional(pR,'cmap',          'gray');
    addOptional(pR,'title',         '',         @iscell);
    addOptional(pR,'font_size',     0,          @isnumeric);
    addOptional(pR,'wigb',          0,          @isnumeric);
    addOptional(pR,'colorbar',      0,          @isnumeric);
    addOptional(pR,'gain_norm',     0,          @isnumeric);
    addOptional(pR,'perc',          99,         @isnumeric);
    addOptional(pR,'tV',            0,          @isnumeric);
    addOptional(pR,'freq_spc',      0,          @isnumeric);
    addOptional(pR,'markerLine',    [],         @isnumeric);
    addOptional(pR,'box_line_width',2,          @isnumeric);
    addOptional(pR,'agc',           0,          @isnumeric);
    addOptional(pR,'marker',        [],         @isnumeric);
    addOptional(pR,'freez_colors',  1,          @isnumeric);
    addOptional(pR,'caxis',         0,          @isnumeric);
    addOptional(pR,'bp_filter',     0,          @isnumeric);
    addOptional(pR,'clip',          0,          @isnumeric);

    parse(pR,varargin{:});
    fields_names = fieldnames(pR.Results);
    p = [];
    for ii=1:length(fields_names)
        p.(fields_names{ii}) = pR.Results.(fields_names{ii});
    end
    
    %Enabling a predefined band pass filter
    if (length(p.bp_filter)==1&&(p.bp_filter))
        p.bp_filter = [5 10 60 65];
    end
    if ~isempty(p.Position), if length(p.Position)~=4, error('%s:: Position should be a 4 coordinates vector',mfilename); end; end

end


function axis_region=local_get_axis(p,data)
    [nt nx] = size(data);
    if length(p.tV)==1
        tV = (0:nt-1)*p.dt;
    else tV = p.tV;
    end

    switch length(p.axis)
        case 1
            axis_region = [p.hV(1) p.hV(end) p.axis tV(end)];
        case 2
            axis_region = [p.hV(1) p.hV(end) p.axis(1) p.axis(2)];
        case 3
            axis_region = [p.axis(1) p.axis(2) p.axis(3) tV(end)];
        case 4
            axis_region = p.axis;
        otherwise
            error('seisplot :: check axis range');
    end
    if size(data,2)==1,
        axis_region = [min(data) max(data) axis_region(3) axis_region(4)];
    end
end
