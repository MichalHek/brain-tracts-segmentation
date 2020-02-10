function displayVolumeSliceGUI(varargin)
%{
Usage : displayVolumeSliceGUI(X)  , where X is the 3D volumetric array
credit: Ohad Menashe
%}

close all

fh = figure('name','VolumeSliceGUI','NumberTitle','off','menubar','none','toolBar','figure');
h = guidata(fh);

if(nargin==0)
    vars = evalin('base','who');
    a=cellfun(@(x) evalin('base',['length(size(' x '))']),vars);
    vars = vars(a==3);
    
    
     if(length(vars)~=1)
         v=listdlg('PromptString','Select volume','SelectionMode','single','ListString',vars);
         
     else
         v = 1;
     end
         h.vol = evalin('base',vars{v});
else
    if(ischar(varargin{1}))
        h.vol = loadModel(varargin{1});
    elseif(length(size(varargin{1}))==3)
        h.vol=varargin{1};
    else
        error('unknonwn input');
    end
end
h.minmax = [min(h.vol(:)) eps+max(h.vol(:))];


guidata(fh,h);
%draw


h.a = axes('parent',fh);
guidata(fh,h);
h.xyz = zeros(4,1);
h.xyz(4) = uibuttongroup('parent',fh,'BorderType','none','SelectionChangeFcn',@dimChange);
h.xyz(3)=uicontrol('Style','radio','parent',h.xyz(4),'string','Z','units','normalized','position',[ 2/3 0 1/3 1]);
h.xyz(2)=uicontrol('Style','radio','parent',h.xyz(4),'string','X','units','normalized','position',[ 1/3 0 1/3 1]);
h.xyz(1)=uicontrol('Style','radio','parent',h.xyz(4),'string','Y','units','normalized','position',[ 0/3 0 1/3 1]);
h.slider = uicontrol('style','slider','parent',fh,'callback',@updateAxes);

guidata(fh,h);

updateGUI(fh);
updateAxes(fh);
  addlistener(h.slider,'Value','PostSet',@(s,e)updateAxes(fh));
set(fh,'ResizeFcn',@updateGUI);
end

function updateGUI(varargin)
fh = varargin{1};
H = 30;
RW=30;
h = guidata(fh);
p = get(fh,'pos');
set(h.a,'units','pixels','pos',[20 H+40,p(3)-20 p(4)-H-60]);
set(h.xyz(4),'units','pixels','pos',[0 0,RW*3+5 H]);
set(h.slider,'units','pixels','pos',[RW*3+5 0,p(3)-RW*3-5 H],'value',.5);
guidata(fh,h);
dimChange(fh)
end

function dimChange(varargin)
h = guidata(varargin{1});
dim = find(get(h.xyz(4),'selectedObject')==h.xyz);
dimSize = size(h.vol,dim);
oldv = get(h.slider,'value');
newv = oldv/(get(h.slider,'max')-get(h.slider,'min'))*(dimSize-1)+1;
set(h.slider,'min',1,'max',dimSize,'SliderStep',[1 1]/(dimSize-1),'value',newv);
guidata(varargin{1},h);
updateAxes(varargin{1});

end

function updateAxes(varargin)
h = guidata(varargin{1});
indx = get(h.slider,'value');
indx = round(indx);
dim = find(get(h.xyz(4),'selectedObject')==h.xyz);

switch(dim)
    case 1
        img = permute(h.vol(indx,:,:),[3 2 1]);
        imagesc(img,'parent',h.a);
         xlabel('z');
         ylabel('x');

    case 2
        img = permute(h.vol(:,indx,:),[3 1 2]);
        imagesc(img,'parent',h.a);
        xlabel('z');
        ylabel('y');
    case 3
        img = h.vol(:,:,indx);
        imagesc(img,'parent',h.a);
        xlabel('x');
       ylabel('y');

end
axis image
set(get(h.a,'title'),'string',sprintf('%4d',indx));
set(h.a,'clim',h.minmax);
% colorbar('peer',h.a,'SouthOutside' )
end