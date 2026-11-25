function R = fig_to_rigid(figFiles, Z, L, W)
% FIG_TO_RIGID  Rigid in-plane motion of each instrumented floor from the Sheraton mode figures.
%
%   R = fig_to_rigid(figFiles, Z, L, W)
%
%   Opens each Sheraton mode figure without showing it and reads the
%   deformed floor outlines, which are the dashed lines of the figures, one
%   two-point segment per side of each floor. For every floor it returns
%   the rigid in-plane motion: ux and uy are the mean offsets of the
%   corners from the plan centre; thy is the mean over the two long sides
%   of (y_East - y_West) / L, and thx the mean over the two short sides of
%   -(x_North - x_South) / W. A floor is matched to its segments by the
%   z coordinate of both points (tolerance 1e-6 m); the function stops
%   with an error if a floor does not have exactly 4 dashed sides.
%
%   INPUT
%   -----
%   figFiles : cell array [1 x nModes] of the SheratonMode<n>.fig files
%              (one per mode)
%   Z        : vector [nFloors x 1], floor heights drawn in the figures (m)
%   L        : scalar, plan dimension drawn in the figures, East-West (m)
%   W        : scalar, plan dimension drawn in the figures, North-South (m)
%
%   OUTPUT
%   ------
%   R : array [nFloors x 4 x nModes], columns [ux, uy, thy, thx] of each
%       floor, with ux and uy in the units of the figures and thy, thx
%       the corresponding rotations (length / length)
%
%   DEPENDENCIES: none (core MATLAB only)
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

nM = numel(figFiles);
R = zeros(numel(Z), 4, nM);
for m = 1:nM
    fig = openfig(figFiles{m}, 'invisible');
    cleanup = onCleanup(@() close(fig));
    seg = findall(fig, 'Type', 'line', 'LineStyle', '--');
    for k = 1:numel(Z)
        s = seg(arrayfun(@(h) numel(h.ZData) == 2 && all(abs(h.ZData - Z(k)) < 1e-6), seg));
        if numel(s) ~= 4
            error('fig_to_rigid:outline', 'Floor at z = %.1f m of %s has %d dashed sides, not 4.', ...
                Z(k), figFiles{m}, numel(s));
        end
        x = vertcat(s.XData);
        y = vertcat(s.YData);
        long = abs(x(:,2) - x(:,1)) > abs(y(:,2) - y(:,1));
        thy = zeros(2, 1); thx = zeros(2, 1);
        il = find(long); is = find(~long);
        for j = 1:2
            [~, e] = max(x(il(j), :)); w = 3 - e;
            thy(j) = (y(il(j), e) - y(il(j), w)) / L;
            [~, nn] = max(y(is(j), :)); ss = 3 - nn;
            thx(j) = -(x(is(j), nn) - x(is(j), ss)) / W;
        end
        R(k, :, m) = [mean(x(:)) - L/2, mean(y(:)) - W/2, mean(thy), mean(thx)];
    end
    clear cleanup
end
end
