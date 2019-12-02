function dataint = interp(data,n)
    if size(data,2) > 1
        [nt nx] = size(data);
        [X Y]   = meshgrid(1:nx,1:nt);
        [X2 Y2] = meshgrid(1:1/n:nx,1:nt);
        dataint= interp2(X,Y,data,X2,Y2,'linear');
    else dataint = data;
    end
end