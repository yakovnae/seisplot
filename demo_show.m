function demo_show(ex)
    answer = questdlg([ex{1} '\n' ex{2}], ...
        'seisplot demo running', ...
        'Show','Next example', 'Quit','Quit');
    if strcmp('Show',answer)
        close all;
        eval(ex{2})
    end
end