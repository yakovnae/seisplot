function [p, pF, var_out] = myparse(p,varargin)
% myparse: Parsing a varargin list into a parser structure (p)
%        There are two types of fields that can be parsed:
%        (1) 'varname=value' - will be parsed into p.varname=value
%        (2) 'varname',value - will parse value into p.varname
%        (2) 'varname'       - will turn (on/off) the varname entry in p 
%                              e.g: p.varname=(~p.varname)
%
%  myparse(p,varargin)
%
%  IN   p:         An structure with desired entries (that will be parsed)
%       varargin:  Input list
%
% OUT   p:       Updated structure, where varargin entries where paresed
%       pF:      stracture, similar to p, only all fileds are boolean:
%                   0- case field was not given to parser, 1- case field was to be parsed
%       var_out: Output list consist of entries that didn't fit in p
%
% Example:
% $ p.v1=6; p.v2='value1'; p.v3=3; p.v4=5; v5=100;
% $ [p pF vout]=myparse(p,'v1=5','v2=value2','v3=[4 5 6]','v6=8')
%
% p =             pF = 
%   v1: 5            v1: 1
%   v2: 'value2'     v2: 1
%   v3: [4 5 6]      v3: 1
%   v4: 5            v4: 1
%   v5: 100          v5: 0
%
% vout = 'v6=8'
%
% 17 April 2017, Author: Yakov Nae, PhD student, KobiNae@gmail.com
% Signal Processing Laboratory for Communications - UNICAMP\FEEC\DMO\DSPCom
% Tel:+55(19)3521-3857 Campinas,SP-Brazil; http://www.dspcom.fee.unicamp.br
%
% Updates by Yakov Nae:
% ---------------------
% 10 MAY 2017, Parser can receive stractures (loads thier intersaction)

    var_out={};             % returns the unparsed fields from varargin
    fnames=fieldnames(p);   % fields to be parsed from varargin
    pF=p;                   % flag for each field indicate if it was feed through varargin
    for ii=1:length(fnames), pF.(fnames{ii})=0; end
    
    fields=zeros(1,length(varargin));  %Listing field number for each varargin entry 
    eq_sign=zeros(1,length(varargin)); %Listing first '=' char for each varargin entry
    for ii=1:length(varargin)
        if isstr(varargin{ii})
            tmp=strfind(varargin{ii},'=');
            if isempty(tmp)
                parameter=varargin{ii};
            else
                eq_sign(ii)=tmp(1); 
                parameter=varargin{ii}(1:(eq_sign(ii)-1)); 
            end
            for jj=1:length(fnames)
                if strcmp(fnames{jj},parameter), 
                    fields(ii)=jj;
                end
            end
        end
        %CASE A STRACTURE WAS ENTERED - LOAD THE INTERSECTION WITH P
        if isstruct(varargin{ii})
            tmp=varargin{ii};
            fnames_tmp=fieldnames(tmp);
            for jj=1:length(fnames_tmp)
                for kk=1:length(fnames)
                    if isequal(strcmp(fnames_tmp{jj},fnames{kk}),1)
                        p.(fnames{kk})=tmp.(fnames{kk});
                        pF.(fnames{kk})=1;
                    end
                end
            end
        end%STRACTURE INTERSECTION
    end
    
    ii=1;
    while ii<=length(varargin)

        if ~isstr(varargin{ii}),                var_out={var_out{:},varargin{ii}}; ii=ii+1; continue; end
        if fields(ii)==0,                       var_out={var_out{:},varargin{ii}}; ii=ii+1; continue; end
%        if ~isempty(strfind(varargin{ii},' ')), var_out={var_out{:},varargin{ii}}; ii=ii+1; continue; end
        if eq_sign(ii)~=0 %(1) 'varname=value'
            tmp=varargin{ii}((eq_sign(ii)+1):end);
            [num, status] = str2num(tmp);
            if status==1
                p.(fnames{fields(ii)})=num;
            else
                p.(fnames{fields(ii)})=tmp;
            end
            pF.(fnames{fields(ii)})=1;
            ii=ii+1; continue;
        else%(2/3) not a 'varname=value' format
            if islogical(p.(fnames{fields(ii)}))%'varname' is boolean
                if ii<length(varargin)%(2) case 'varname','value' and value is boolean
                    if isnumeric(varargin{ii+1}) || islogical(varargin{ii+1})
                        if varargin{ii+1}==1 || varargin{ii+1}==true
                            p.(fnames{fields(ii)})=true;
                            pF.(fnames{fields(ii)})=1;
                            ii=ii+2; continue;
                        end
                        if varargin{ii+1}==0 || varargin{ii+1}==false
                            p.(fnames{fields(ii)})=false;
                            pF.(fnames{fields(ii)})=1;
                            ii=ii+2; continue;
                        end
                    end
                end
                %(3) 'varname' boolean - turn on/off
                p.(fnames{fields(ii)})=~p.(fnames{fields(ii)});
                pF.(fnames{fields(ii)})=1;
                ii=ii+1; continue;
            else%'varname' is not boolean
                if ii<length(varargin)
                    if fields(ii+1)==0 %if next entry is a field, this entry is a 'varname' - boolean
                        p.(fnames{fields(ii)})=varargin{ii+1};
                        pF.(fnames{fields(ii)})=1;
                        ii=ii+2; continue;
                    end
                end
            end
        end
        error('%s:: Could not parse entry number %d (%s)',mfilename,ii,fnames{fields(ii)});
%         %(3) 'varname' - boolean
%         if eq_sign(ii)==0
%             if p.(fnames{fields(ii)})==0
%                p.(fnames{fields(ii)})=1;
%                pF.(fnames{fields(ii)})=1;
%                ii=ii+1; continue;
%             else if p.(fnames{fields(ii)})==1
%                     p.(fnames{fields(ii)})=0;
%                     pF.(fnames{fields(ii)})=1;
%                     ii=ii+1; continue;
%                 else
%                     error('%s:: Could not parse');
%                 end
%             end
%         end
    end
 

end