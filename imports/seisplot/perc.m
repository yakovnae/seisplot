function Data=perc(Data,p)
    [Nt,Ns]=size(Data);

    dr=reshape(Data,Nt*Ns,1);
    dr=sort(abs(dr));

    nperc=round(p/100*Nt*Ns);
    perc=dr(nperc);
    Data=Data.*(abs(Data)<=perc)+perc.*(abs(Data)>perc).*sign(Data);
end