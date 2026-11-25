function colourbar_figure(outFile)
% COLOURBAR_FIGURE  Write the colour bar shared by the mode-shape figures.
%
%   colourbar_figure(outFile)
%
%   Writes a horizontal colour bar of the normalised displacement norm,
%   ||U(p)|| / max ||U(p)|| from 0 to 1, with the blue, white and magenta
%   map of the mode-shape figures. The bar is drawn on a hidden figure of
%   14 x 1.8 cm with ticks every 0.2 and LaTeX labels, and is exported as
%   vector graphics. It is called by the main.m scripts of the Plate,
%   Sheraton and XB2 case studies (Figure3i.pdf and Figure5e.pdf).
%
%   INPUT
%   -----
%   outFile : character vector or string, path of the output file (the
%             format follows the extension, e.g. .pdf)
%
%   OUTPUT
%   ------
%   (none) : writes the colour bar to outFile
%
%   DEPENDENCIES: mode_colormap (this repository); MATLAB R2022a or later
%                 for clim and exportgraphics
%
%   LICENCE: MIT licence (see LICENSE)
%
%   AUTHOR(S): G. Dessena
%              Universidad Carlos III de Madrid
%              gdessena@ing.uc3m.es
%
%   REFERENCES:
%     [1] G. Dessena, M. Civera, S. Undiano Echaniz, and O.
%         Bonilla-Manrique, "Automated classification of modal
%         displacements," arXiv:2611.31472, 2026. Preprint.
%         doi: 10.48550/arXiv.2611.31472
% =========================================================================

fig = figure('Visible', 'off', 'Units', 'centimeters', 'Position', [1 1 14 1.8], 'Color', 'w');
ax = axes(fig, 'Visible', 'off');
colormap(ax, mode_colormap());
clim(ax, [0 1]);
cb = colorbar(ax, 'southoutside');
cb.Position = [0.05 0.55 0.9 0.25];
cb.TickLabelInterpreter = 'latex';
cb.FontSize = 9;
cb.Ticks = 0:0.2:1;
set(cb.Label, 'Interpreter', 'latex', 'String', '$\|\mathbf{U}(p)\| / \max \|\mathbf{U}(p)\|$', 'FontSize', 10);
exportgraphics(fig, outFile, 'ContentType', 'vector');
close(fig);
end
