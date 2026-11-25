function plate_mode_figures(shapes, U, pos, f, figDir)
% PLATE_MODE_FIGURES  Isometric figures of the plate modes (Figure 3a-h of the article).
%
%   plate_mode_figures(shapes, U, pos, f, figDir)
%
%   Draws one isometric figure per mode of the tapered plate and exports
%   it as a vector PDF (Figure 3a-h of the article). The shape is the top
%   surface displaced by the 3D motion, interpolated on the planform grid
%   and scaled so that max|U| draws as 150 mm. The colour is |U| / max|U|.
%   The eight sensors are drawn at their displaced positions: sensors 1-4
%   as blue circles and sensors 5-8 as magenta squares. Called by
%   Plate/main.m.
%
%   INPUT
%   -----
%   shapes : structure from plate_sensor_vectors, fields:
%       .X, .Y   - grid coordinates of the top surface (mm)
%       .Utop    - top-surface displacement [rows x cols x 3 x nModes]
%   U      : [8 x 3 x nModes] sensor displacement vectors
%   pos    : [8 x 3] sensor positions (mm)
%   f      : vector of nModes natural frequencies (Hz)
%   figDir : output folder for the figure files
%
%   OUTPUT
%   ------
%   (none) Writes Figure3a.pdf, Figure3b.pdf, ... (one per mode) to figDir.
%
%   DEPENDENCIES: mode_colormap (Utilities); shapes comes from
%                 plate_sensor_vectors. No toolboxes (MATLAB R2022a or
%                 later for clim).
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

amp = 150;
cmap = mode_colormap();
blue = cmap(1, :);
magenta = cmap(end, :);
[Eta, Yp] = meshgrid(linspace(0.002, 0.998, 61), linspace(0, 1000, 201));   % chord fraction, span
Xp = -150 + Eta .* (300 - 210 * Yp / 1000);
letters = 'abcdefghijklmnopqrstuvwxyz';
for m = 1:numel(f)
    G = zeros([size(Xp) 3]);
    for c = 1:3
        F = fillmissing(shapes.Utop(:,:,c,m), 'nearest', 2);   % fill the grid points outside the planform
        G(:,:,c) = interp2(shapes.X, shapes.Y, F, Xp, Yp, 'linear');
    end
    n = vecnorm(G, 2, 3);
    s = max(n(:));
    Gs = amp * G / s;
    fig = figure('Visible', 'off', 'Units', 'centimeters', 'Position', [1 1 8 4.6], 'Color', 'w', 'Renderer', 'painters');
    ax = axes(fig);
    surf(ax, Xp + Gs(:,:,1), Yp + Gs(:,:,2), Gs(:,:,3), n / s, 'EdgeColor', 'none', 'FaceColor', 'interp');
    hold(ax, 'on');
    plot3(ax, [-150 150 -60 -150 -150], [0 0 1000 1000 0], zeros(1, 5), 'k-', 'LineWidth', 0.5);
    Ps = pos + amp * U(:,:,m) / s;
    Ps(:,3) = amp * U(:,3,m) / s;
    plot3(ax, Ps(1:4,1), Ps(1:4,2), Ps(1:4,3), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue, 'MarkerSize', 5, 'LineWidth', 0.6, 'Clipping', 'off');
    plot3(ax, Ps(5:8,1), Ps(5:8,2), Ps(5:8,3), 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', magenta, 'MarkerSize', 5.5, 'LineWidth', 0.6, 'Clipping', 'off');
    ax.SortMethod = 'childorder';
    colormap(ax, cmap); clim(ax, [0 1]);
    axis(ax, 'equal'); view(ax, 135, 35.264);
    zlim(ax, [-amp amp]); xlim(ax, [-150 150]); ylim(ax, [0 1000]);
    set(ax, 'TickLabelInterpreter', 'latex', 'FontSize', 9, 'XTick', [-150 0 150], 'YTick', 0:250:1000, 'ZTick', [-100 0 100]);
    xlabel(ax, '$x$ (mm)', 'Interpreter', 'latex'); ylabel(ax, '$y$ (mm)', 'Interpreter', 'latex'); zlabel(ax, '$z$ (mm)', 'Interpreter', 'latex');
    title(ax, sprintf('Mode %d, %.2f Hz', m, f(m)), 'Interpreter', 'latex', 'FontSize', 10);
    grid(ax, 'on');
    exportgraphics(fig, fullfile(figDir, sprintf('Figure3%s.pdf', letters(m))), 'ContentType', 'vector');
    close(fig);
end
end
