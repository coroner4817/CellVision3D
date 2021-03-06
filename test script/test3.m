% membrane analysis
clear all;
close all;
clc
import CellVision3D.*
import CellVision3D.filesystem.*
% initialize
global datapath;
global codepath;
filesystem.SetupUserPath;
dirpath=fullfile(datapath,'Movie for analysis\mempar1');
[ fns,filepaths,filenames ] = GetFilesWithinFolder( dirpath, '.dv' );
savedir=fullfile(datapath,'Movie for analysis\mempar1');


%% select initial for all movies
for ifile=1%:length(fns)
    %% load movie and set channel
    ifile=1
    obj=Movie(fullfile(datapath,fns{ifile}));
    obj.setChannels('FluorescentParticle3D','lacO',...
        'FluorescentMembrane3D','cut11');
    obj.load();
    obj.getChannel('cut11').setIlluminationcorrection(dirpath);
    %% segment the image based on first stack
    contours=obj.getChannel('cut11').init(1);
    obj.getChannel('cut11').view();
    %% get the particles based on the first stack
    obj.getChannel('lacO').setParam('zxr',obj.zxr,'lnoise',.1,...
        'lobject',5,'peakthreshold',.3,'fitwindow',15);
    particles=obj.getChannel('lacO').init(1);
    obj.getChannel('lacO').init(1);
    obj.getChannel('lacO').view();
    %% construct cell
    cells=Cell.constructCellsByMembraneParticles(contours, particles);
    filter=CellFilter('lacO','particlenumber',[1,1]);
    cells=filter.applyFilter(cells);

    %%
    for ichannel=1:obj.numchannels
        obj.getChannel(ichannel).run(cells);
    end
end


