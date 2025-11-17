function [CMAC, Fig1, Fig2] = CMAC(phi1, phi2, Colmap, phi1Name, phi2Name, FontSizeVal, NumFig, ShowText)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% CMAC function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FUNCTION DESCRIPTION:
% This function computes the Modal Assurance Criterion (MAC) between
% two sets of mode shapes.
%
% INPUTS:
% phi1 = Mode shape matrix of the first set of modes
% phi2 = Mode shape matrix of the second set of modes
% Colmap = Colormap applied to the 3D graph. Valid options: 'jet', 'turbo',
%          'parula', 'hsv', 'hot', 'cool', 'spring', ...
% phi1Name = Label for phi1 mode axis
% phi2Name = Label for phi2 mode axis
% FontSizeVal = Font size used in figures
% NumFig = Number of figures: 1 = 3D only, 2 = 3D + 2D
% ShowText = 'yes' or 'no', whether to display MAC values on the plots
%
% OUTPUTS:
% CMAC = Modal Assurance Criterion matrix
% Fig1 = Handle to 3D MAC figure
% Fig2 = Handle to 2D MAC figure (empty if NumFig = 1)
%
% EXAMPLE:
% phi1 = rand(10,5);
% phi2 = rand(10,5);
% Colmap = 'parula';
% phi1Name = 'Experimental modes';
% phi2Name = 'Numerical modes';
% FontSizeVal = 12;
% NumFig = 2;
% ShowText = 'yes';
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%  Programmed by: Diego Díaz Salamanca  (diazsdiego@uniovi.es)  %%%%%
%%%%%%  Copyright (c) 2025 Diego Díaz Salamanca. All rights reserved %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Preliminar checks
if ~exist('Colmap','var') || isempty(Colmap)
    Colmap = 'default';
end

if ~exist('phi1Name','var') || isempty(phi1Name)
    phi1Name = 'Modes 1';
end

if ~exist('phi2Name','var') || isempty(phi2Name)
    phi2Name = 'Modes 2';
end

if ~exist('FontSizeVal','var') || isempty(FontSizeVal)
    FontSizeVal = 12;
end

if ~exist('NumFig','var') || isempty(NumFig) || ~ismember(NumFig,[1,2])
    warning('NumFig should be 1 or 2. Using 1  by default.');
    NumFig = 1;
end

if ~exist('ShowText','var') || isempty(ShowText) || ~ismember(lower(ShowText), {'yes','no'})
    warning('ShowText should be ''yes'' or ''no''. Using ''no'' by default.');
    ShowText = 'no';
end

% Evaluation of the modes matrix shapes
[~, Numphi1] = size(phi1);
[~, Numphi2] = size(phi2);

% Preallocation of the MAC matrix
CMAC = zeros(Numphi1, Numphi2);

% Compution of the MAC matrix
for i = 1:Numphi1
    for j = 1:Numphi2
        CMAC(i,j) = (abs(phi1(:,i)'*phi2(:,j)))^2/((phi1(:,i)'*phi1(:,i))*(phi2(:,j)'*phi2(:,j)));
    end
end

% 3D representation of the MAC
Fig1 = figure;
b = bar3(CMAC);
colormap(Colmap);
for k = 1:length(b)
    zdata = b(k).ZData;
    b(k).CData = zdata;
    b(k).FaceColor = 'interp';
end
if strcmpi(ShowText,'yes')
    textStrings = cellstr(num2str(CMAC(:), '%0.2f'));
    [x, y] = meshgrid(1:size(CMAC,2), 1:size(CMAC,1));
    text(x(:), y(:), 1.025*CMAC(:), textStrings, ...
        'HorizontalAlignment', 'center', 'FontSize', 10, 'Interpreter','latex');
end
box on;
xlabel(phi2Name,'interpreter','latex');
ylabel(phi1Name,'interpreter','latex');
zlabel('MAC','interpreter','latex')
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', FontSizeVal);
axis tight;
view(3);
cb = colorbar;         
cb.Label.Interpreter = 'latex';              
cb.Label.FontSize = 12;    
cb.TickLabelInterpreter = 'latex';

% 2D representation of the MAC
if NumFig == 2
    Fig2 = figure;     
    imagesc(CMAC);     
    colormap(Colmap);
    axis equal tight;
    xlabel(phi2Name,'interpreter','latex');
    ylabel(phi1Name,'interpreter','latex');
    set(gca, 'TickLabelInterpreter', 'latex','FontSize',FontSizeVal);
    grid on;
    cb = colorbar;         
    cb.Label.Interpreter = 'latex';              
    cb.Label.FontSize = 12;    
    cb.TickLabelInterpreter = 'latex';
    if strcmpi(ShowText,'yes')
        textStrings = cellstr(num2str(CMAC(:), '%0.2f'));
        [x, y] = meshgrid(1:size(CMAC,2), 1:size(CMAC,1));
        text(x(:), y(:), zeros(size(CMAC(:))), textStrings, ...
            'HorizontalAlignment', 'center', 'FontSize', 10, 'Interpreter','latex');
    end
else
    Fig2 = [];
end
end

