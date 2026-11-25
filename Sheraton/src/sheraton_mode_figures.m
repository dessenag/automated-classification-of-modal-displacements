function sheraton_mode_figures(R, f, figDir)
% SHERATON_MODE_FIGURES  Figures of the Sheraton Universal Hotel modes.
%
%   sheraton_mode_figures(R, f, figDir)
%
%   Draws one figure per mode of the Sheraton Universal Hotel (Figure 7a-e
%   of the article) and saves it as a vector PDF. It is called by main.m
%   of the Sheraton case study after fig_to_rigid.
%   Each instrumented floor is drawn as a plate, rigid in its plane,
%   displaced by its translation and rotation. Colour: |U| / max|U| over
%   the plotted floors; markers at the two North-South sensor points of
%   each floor (West: circle, East: square); thin lines join the floor
%   corners to the fixed base. The building is drawn at 54 m and 17.6 m,
%   as in the original paper, with the floor heights scaled in
%   proportion. Axes: x East, y North, z up. The largest in-plane motion
%   of each mode is plotted with an amplitude of 12 m.
%
%   INPUT
%   -----
%   R      : array [nFloors x 4 x nModes], rigid floor motion
%            [ux, uy, thy, thx] from fig_to_rigid; the code draws four
%            floors, and the floor rotation is the mean of thy and thx
%   f      : vector [nModes x 1], natural frequencies in Hz
%   figDir : char or string, output folder
%
%   OUTPUT
%   ------
%   (none) Writes Figure7a.pdf, Figure7b.pdf, ... (one per mode, letter
%   by mode index) to figDir.
%
%   DEPENDENCIES: mode_colormap (Utilities); MATLAB (exportgraphics and
%                 clim need R2022a or later)
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
%     [2] G. Dessena, M. Civera, A. Yousefi, and C. Surace, "NExT-LF: A
%         Novel Operational Modal Analysis Method via Tangential
%         Interpolation," International Journal of Mechanical System
%         Dynamics, vol. 5, no. 3, pp. 401-414, 2025.
%         doi: 10.1002/msd2.70016
%     [3] G. Dessena, "Data supporting: NExT-LF: A Novel Operational Modal
%         Analysis Method via Tangential Interpolation," Universidad Carlos
%         III de Madrid, Zenodo, 13 May 2025.
%         doi: 10.5281/zenodo.14975925
% =========================================================================

L = 56; W = 17.6; Z = [7.8 23.4 39.0 54.6] * 54 / 54.6;
xc = L/2; yc = W/2;
amp = 12;                                          % plotted amplitude of the largest motion (m)
cmap = mode_colormap();
blue = cmap(1, :);
magenta = cmap(end, :);
[Xg, Yg] = meshgrid(linspace(0, L, 29), linspace(0, W, 10));
corners = [0 0; L 0; L W; 0 W; 0 0];
letters = 'abcdefghijklmnopqrstuvwxyz';
for m = 1:size(R, 3)
    r = R(:, :, m);
    th = (r(:,3) + r(:,4)) / 2;
    disp_at = @(k, x, y) deal(r(k,1) - th(k) * (y - yc), r(k,2) + th(k) * (x - xc));
    s = 0;
    for k = 1:4
        [ux, uy] = disp_at(k, Xg, Yg);
        s = max(s, max(hypot(ux(:), uy(:))));
    end
    fig = figure('Visible', 'off', 'Units', 'centimeters', 'Position', [1 1 6 7.2], 'Color', 'w', 'Renderer', 'painters');
    ax = axes(fig); hold(ax, 'on');
    for k = 1:4
        plot3(ax, corners(:,1), corners(:,2), Z(k) * ones(5,1), 'k-', 'LineWidth', 0.4);
        [ux, uy] = disp_at(k, Xg, Yg);
        surf(ax, Xg + amp * ux / s, Yg + amp * uy / s, Z(k) * ones(size(Xg)), hypot(ux, uy) / s, ...
            'EdgeColor', 'none', 'FaceColor', 'interp');
    end
    for c = 1:4                                    % corner lines from the base to the roof
        x0 = corners(c,1); y0 = corners(c,2);
        px = zeros(1, 5) + x0; py = zeros(1, 5) + y0; pz = [0 Z];
        for k = 1:4
            [ux, uy] = disp_at(k, x0, y0);
            px(k+1) = x0 + amp * ux / s; py(k+1) = y0 + amp * uy / s;
        end
        plot3(ax, px, py, pz, '-', 'Color', [0.35 0.35 0.35], 'LineWidth', 0.5);
    end
    for k = 1:4                                    % sensor points: West circle, East square
        [ux, uy] = disp_at(k, 0, yc);
        plot3(ax, amp * ux / s, yc + amp * uy / s, Z(k), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue, 'MarkerSize', 5, 'LineWidth', 0.6, 'Clipping', 'off');
        [ux, uy] = disp_at(k, L, yc);
        plot3(ax, L + amp * ux / s, yc + amp * uy / s, Z(k), 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', magenta, 'MarkerSize', 5.5, 'LineWidth', 0.6, 'Clipping', 'off');
    end
    plot3(ax, corners(:,1), corners(:,2), zeros(5,1), 'k-', 'LineWidth', 0.6);
    ax.SortMethod = 'childorder';
    colormap(ax, cmap); clim(ax, [0 1]);
    axis(ax, 'equal'); view(ax, -35, 22);
    xlim(ax, [-amp - 2, L + amp + 2]); ylim(ax, [-amp - 2, W + amp + 2]); zlim(ax, [0 57.4]);
    set(ax, 'TickLabelInterpreter', 'latex', 'FontSize', 9, 'XTick', [0 28 56], 'YTick', [0 17.6], 'ZTick', [0 Z]);
    ax.ZTickLabel = {'0', '7.7', '23.1', '38.6', '54'};
    xlabel(ax, '$x$ (m)', 'Interpreter', 'latex'); ylabel(ax, '$y$ (m)', 'Interpreter', 'latex'); zlabel(ax, '$z$ (m)', 'Interpreter', 'latex');
    title(ax, sprintf('Mode %d, %.2f Hz', m, f(m)), 'Interpreter', 'latex', 'FontSize', 10);
    grid(ax, 'on');
    exportgraphics(fig, fullfile(figDir, sprintf('Figure7%s.pdf', letters(m))), 'ContentType', 'vector');
    close(fig);
end
end
