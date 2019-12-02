%%=========================================================================
% SUBFUNCTION: example_panel - creates a seismic panel to simulate examples
%%=========================================================================
function d = example_panel()
    nx=300; nt=1000;
    dt=0.004;
    d = zeros(nt,nx);
    %t=sqrt(t0^2+x^2/v^2);
    T=-0.1:dt:0.1;
    fc=20;
    rckr = (1-2*(pi*fc*T).^2).*exp(-(pi*fc*T).^2);
    tV2 = (((1:nt)*dt).^2);

    dt=0.004; dx=25;
    t0=[.4 1 1.8,3];  v=[1500 1600 1800 2000];
    for ii=1:nx
        for jj=1:length(t0)
            t = floor( sqrt(t0(jj)^2+(ii*dx)^2/v(jj)^2) / dt );
            temp = zeros(1,t+2*fc+1);
            temp(t) = 1;
            temp = conv(rckr,temp);
            d(1:min(nt,length(temp)),ii) = d(1:min(nt,length(temp)),ii) + ...
                                               temp(1:min(nt,length(temp)))';
        end
        d(:,ii) = d(:,ii)./tV2';
    end
end
