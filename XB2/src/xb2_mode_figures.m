function xb2_mode_figures(U, pos, f, geo, figDir)
% XB2_MODE_FIGURES  Figures of the identified XB-2 modes (Figure 5a-d of the article).
%
%   xb2_mode_figures(U, pos, f, geo, figDir)
%
%   Draws each identified mode of the XB-2 wing as a deformed wing surface,
%   with the measured sensor motion as markers, and saves one vector PDF per
%   mode. It is called by XB2/main.m and produces Figure 5a-d.
%
%   Vertical motion: linear along each chord between the L and R sensors, and
%   linear along the span from zero at the clamp root (y = 0). Chordwise
%   motion (measured at 1R, 2R and 3R only): uniform along each chord, so that
%   the distance between the L and R sensors of each station is constant;
%   zero at station 4, where it is not measured; linear along the span.
%   Colour: |U| / max|U|. The planform spans y = 0 to 1325 mm, with stations
%   at y = 430, 650, 1010 and 1325 mm and the reference axis at quarter
%   chord; displacements are drawn with an amplitude of 150 mm for the
%   largest motion of each mode.
%
%   INPUT
%   -----
%   U      : array [8 x 3 x nModes], sensor vectors (x, y, z components),
%            rows 1R 1L 2R 2L 3R 3L 4R 4L
%   pos    : array [8 x 3], sensor positions (mm), same row order as U
%   f      : vector [nModes x 1], natural frequencies (Hz)
%   geo    : structure, sensor geometry; geo.sensors is a structure array
%            in the row order of U with fields:
%       .chord   - local chord at the sensor station (mm)
%       .xf      - chord fraction of the sensor
%   figDir : character vector, folder where the figures are written
%
%   OUTPUT
%   ------
%   (none) Writes Figure5a.pdf, Figure5b.pdf, ... (one per mode, 8 x 5.6
%   cm, vector) to figDir. Left sensors are drawn as circles, right sensors
%   as squares.
%
%   DEPENDENCIES: mode_colormap (Utilities); MATLAB R2022a or later
%                 (clim, exportgraphics)
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
%     [2] G. Dessena, "A dataset for partial in-plane acceleration of the
%         XB-2 wing," Universidad Carlos III de Madrid, Zenodo, 2026,
%         doi: 10.5281/zenodo.24536230.
%     [3] G. Dessena, D. I. Ignatyev, J. F. Whidborne, A. Pontillo, and
%         L. Zanotti Fragonara, "Ground vibration testing of a flexible
%         wing: A benchmark and case study," Aerospace, vol. 9, no. 8,
%         p. 438, 2022, doi: 10.3390/aerospace9080438.
% =========================================================================

ys = [430 650 1010 1325];
sens = geo.sensors;
chord = [sens(1:2:end).chord];
etaR = [sens(1:2:end).xf];
etaL = [sens(2:2:end).xf];
pc = polyfit(ys, chord, 1);
cOf = @(y) polyval(pc, y);
amp = 150;
cmap = mode_colormap();
blue = cmap(1, :);
magenta = cmap(end, :);
[Eta, Yp] = meshgrid(linspace(0, 1, 41), linspace(0, 1325, 133));
Xp = (Eta - 0.25) .* cOf(Yp);
letters = 'abcdefghijklmnopqrstuvwxyz';
nM = size(U, 3);

% shapes of all modes, and x-limits that contain every deformed surface
X = cell(nM, 1); W = cell(nM, 1); N = cell(nM, 1); S = zeros(nM, 1); UXs = cell(nM, 1);
xl = [-0.25 * cOf(0), 0.75 * cOf(0)];
for m = 1:nM
    Um = U(:,:,m);
    wR = Um(1:2:end, 3).'; wL = Um(2:2:end, 3).'; uR = Um([1 3 5], 1).';
    wst = zeros(4, size(Eta, 2));
    for k = 1:4
        wst(k,:) = wL(k) + (Eta(1,:) - etaL(k)) / (etaR(k) - etaL(k)) * (wR(k) - wL(k));
    end
    W{m} = interp1([0 ys], [zeros(1, size(Eta, 2)); wst], Yp(:,1), 'linear');
    ux = interp1([0 ys], [0 uR 0], Yp(:,1), 'linear');
    UX = repmat(ux, 1, size(Eta, 2));
    N{m} = hypot(UX, W{m});
    S(m) = max([N{m}(:); vecnorm(Um, 2, 2)]);
    X{m} = Xp + amp * UX / S(m);
    UXs{m} = interp1([0 ys], [0 uR 0], pos(:,2));
    % x-limits as in the article figures: scale from the chordwise motion and the
    % largest vertical sensor motion
    sl = max([max(hypot(ux, max(abs([wR wL])))); vecnorm(Um, 2, 2)]);
    xs = Xp + amp * UX / sl;
    xl = [min(xl(1), min(xs(:))), max(xl(2), max(xs(:)))];
end

for m = 1:nM
    s = S(m);
    fig = figure('Visible', 'off', 'Units', 'centimeters', 'Position', [1 1 8 5.6], 'Color', 'w', 'Renderer', 'painters');
    ax = axes(fig);
    surf(ax, X{m}, Yp, amp * W{m} / s, N{m} / s, 'EdgeColor', 'none', 'FaceColor', 'interp');
    hold(ax, 'on');
    yo = [0 1325 1325 0 0];
    xo = [-0.25*cOf(0) -0.25*cOf(1325) 0.75*cOf(1325) 0.75*cOf(0) -0.25*cOf(0)];
    plot3(ax, xo, yo, zeros(1, 5), 'k-', 'LineWidth', 0.5);
    Ps = [pos(:,1) + amp * UXs{m} / s, pos(:,2), amp * U(:,3,m) / s];
    plot3(ax, Ps(2:2:end,1), Ps(2:2:end,2), Ps(2:2:end,3), 'o', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', blue, 'MarkerSize', 5, 'LineWidth', 0.6, 'Clipping', 'off');
    plot3(ax, Ps(1:2:end,1), Ps(1:2:end,2), Ps(1:2:end,3), 's', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', magenta, 'MarkerSize', 5.5, 'LineWidth', 0.6, 'Clipping', 'off');
    ax.SortMethod = 'childorder';
    colormap(ax, cmap); clim(ax, [0 1]);
    axis(ax, 'equal'); view(ax, 155, 25);
    zlim(ax, [-amp amp]); xlim(ax, [xl(1) - 20, xl(2) + 20]); ylim(ax, [0 1325]);
    set(ax, 'TickLabelInterpreter', 'latex', 'FontSize', 9, 'XTick', [-100 0 100], 'YTick', [0 430 650 1010 1325], 'ZTick', [-100 0 100]);
    xlabel(ax, '$x$ (mm)', 'Interpreter', 'latex'); ylabel(ax, '$y$ (mm)', 'Interpreter', 'latex'); zlabel(ax, '$z$ (mm)', 'Interpreter', 'latex');
    title(ax, sprintf('Mode %d, %.2f Hz', m, f(m)), 'Interpreter', 'latex', 'FontSize', 10);
    grid(ax, 'on');
    exportgraphics(fig, fullfile(figDir, sprintf('Figure5%s.pdf', letters(m))), 'ContentType', 'vector');
    close(fig);
end
end
