function cmap = mode_colormap()
% MODE_COLORMAP  Colour map of the mode-shape figures, blue to white to magenta.
%
%   cmap = mode_colormap()
%
%   Returns the colour map used for the mode-shape figures, applied to the
%   normalised displacement |U| / max|U| in [0, 1]. The first 128 rows run
%   linearly from blue (RGB 0x64 0x8F 0xFF) to white and the last 128 rows
%   from white to magenta (RGB 0xDC 0x26 0x7F). It is called by
%   plate_mode_figures, sheraton_mode_figures, xb2_mode_figures and
%   colourbar_figure.
%
%   INPUT
%   -----
%   (none)
%
%   OUTPUT
%   ------
%   cmap : double matrix [256 x 3], RGB colour map with values in [0, 1]
%
%   DEPENDENCIES: none
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

blue = double([0x64 0x8F 0xFF]) / 255;
magenta = double([0xDC 0x26 0x7F]) / 255;
tt = linspace(0, 1, 128).';
cmap = [blue + (1 - blue) .* tt; 1 - (1 - magenta) .* tt];
end
