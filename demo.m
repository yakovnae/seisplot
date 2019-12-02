examples = { {'First exmple, ploting a seismic volume:',...
              'seisplot(''ex1'')'} ...
             {'Second example, comparing 3 volumes on top of each other',...
              'seisplot(''ex3'')'},...
             {'Third example, comparing 3 volumes side by side',...
              'seisplot(''ex3'',''subplot'')'}...
           };

for i=1:length(examples)
    demo_show(examples{i})
end