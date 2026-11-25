function [U, f, shapes] = plate_sensor_vectors(runDir, nModes, pos)
% PLATE_SENSOR_VECTORS  Top-surface sensor vectors of the plate from the APDL mode files.
%
%   [U, f, shapes] = plate_sensor_vectors(runDir, nModes, pos)
%
%   Reads the mode files mode_<n>.csv written by plate_modal.mac, builds
%   the motion of the top surface of the 2 mm thick tapered plate
%   (length 1000 mm, root chord 300 mm, tip chord 90 mm) as
%   u_top = u + rot x (t/2 z), interpolates the displacement and rotation
%   fields linearly onto a 1 mm grid and samples it at the eight sensor
%   positions. It is called by main.m of the Plate case, and its shapes
%   output feeds plate_mode_figures.m. An error is raised if a sensor
%   position lies outside the plate.
%
%   INPUT
%   -----
%   runDir : char, folder holding mode_<n>.csv written by plate_modal.mac
%   nModes : scalar, number of modes
%   pos    : [8 x 3] sensor positions (mm) on the 1 mm grid
%            (data/sensor_positions.csv); columns 1 and 2 (x, y) are used
%
%   OUTPUT
%   ------
%   U      : [8 x 3 x nModes] sensor vectors, in the rows of pos, with
%            the x, y and z components along the second dimension
%   f      : [nModes x 1] natural frequencies (Hz)
%   shapes : structure for the figures, fields:
%       .X, .Y   - grid coordinates (mm), x from -150 to 150 and y from
%                  0 to 1000
%       .Utop    - top-surface motion [rows x cols x 3 x nModes], NaN at
%                  grid points outside the plate
%
%   DEPENDENCIES: none (reads the mode files written by plate_modal.mac
%                 in ANSYS APDL)
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

L = 1000; cr = 300; ct = 90; t = 2;                       % mm
[X, Y] = meshgrid(-150:1:150, 0:1:L);
inside = X >= -150 - 1e-9 & X <= -150 + cr - (cr - ct) * Y / L + 1e-9;

U = zeros(8, 3, nModes);
f = zeros(nModes, 1);
Utop = zeros([size(X) 3 nModes]);
for m = 1:nModes
    raw = readmatrix(fullfile(runDir, sprintf('mode_%d.csv', m)));
    f(m) = raw(1, 5);
    xy = round(raw(:, 2:3) * 1000, 6);
    u = raw(:, 6:8);
    rot = raw(:, 9:11);
    utop = u + [rot(:,2) * (t/2) / 1000, -rot(:,1) * (t/2) / 1000, zeros(size(u, 1), 1)];
    F = scatteredInterpolant(xy(:,1), xy(:,2), utop(:,1), 'linear', 'none');
    G = zeros([size(X) 3]);
    for k = 1:3
        F.Values = utop(:, k);
        G(:,:,k) = F(X, Y);
    end
    idx = sub2ind(size(X), pos(:,2) - Y(1) + 1, pos(:,1) - X(1) + 1);
    if any(~inside(idx)) || any(isnan(G(idx + 2 * numel(X))))
        error('A sensor position lies outside the plate.');
    end
    for k = 1:3
        Gk = G(:,:,k);
        U(:, k, m) = Gk(idx);
    end
    Utop(:,:,:,m) = G;
end
shapes = struct('X', X, 'Y', Y, 'Utop', Utop);
end
