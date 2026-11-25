% MAIN  Sheraton Universal Hotel: indices of the modes identified by NExT-LF.
%
%   Reproduces Table 4, Figure 7 and the floor ratios of Section 4.2 of
%   the article. The published mode figures (SheratonMode1-5.fig) [3] of
%   the NExT-LF identification [2] are downloaded from Zenodo on first
%   use and reduced to the rigid motion of four instrumented floors
%   (z = 7.8, 23.4, 39.0 and 54.6 m, plan 56 m x 17.5 m). Each floor gives
%   a West and an East point (data/sensor_positions.csv). For each mode the
%   script computes the bending and torsion scores B and T, the twist
%   share tau, the in-plane ratio rho and the East-West over North-South
%   ratio of every floor, and classifies the mode from tau, rho and the
%   floor ratios. It then classifies each mode again with one floor left
%   out, to check the sensitivity to sensor coverage.
%
%   USAGE
%   -----
%   Run main from any folder. No setting is marked <-- USER; the plan
%   dimensions, floor heights, bounds of the classification rule
%   (tau_b = 0.05, rho_b = 0.5) and the identified natural frequencies
%   (Hz) and damping ratios are set in Sections 1 and 3 of the script.
%   An internet connection is needed on the first run.
%
%   OUTPUT
%   ------
%   Command window : table of f_Hz, zeta, B, T, tau, rho and type per
%                    mode, floor ratios rounded to two decimals, labels
%                    that change with one floor left out and the number
%                    of unchanged labels, comparison with the values of
%                    the article
%   Figure7a-e.pdf : Figure 7, one mode figure per mode, written to the
%                    figures folder
%   Figure5e.pdf   : colour bar, written to the figures folder
%
%   DEPENDENCIES: setup_paths, zenodo_records, download_zenodo,
%                 fig_to_rigid, identifyMotion, twist_share,
%                 inplane_ratio, section_ratios, classify_rule,
%                 sheraton_mode_figures, colourbar_figure,
%                 compare_paper_values,
%                 sheraton_paper_values (this repository)
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
%     [3] G. Dessena, "Data supporting: NExT-LF: A Novel Operational
%         Modal Analysis Method via Tangential Interpolation,"
%         Universidad Carlos III de Madrid, Zenodo, 13 May 2025.
%         doi: 10.5281/zenodo.14975925
% =========================================================================

clear; close all;
here = fileparts(mfilename('fullpath'));
addpath(fileparts(here));
paths = setup_paths("Sheraton");

%% 1. Settings
L = 56; W = 17.5;                                  % plan dimensions in the mode figures (m)
Z = [7.8 23.4 39.0 54.6];                          % instrumented floors in the mode figures (m)
floorNames = {'floor3', 'floor9', 'floor16', 'roof'};
tau_b = 0.05; rho_b = 0.5;                         % bounds of the classification rule
names = struct('oop_bending', 'North--South bending', 'ip_bending', 'East--West bending', 'torsion', 'torsion');
n = [0 1 0];                                       % North-South direction (out of the reference plane)
pairs = [1 2; 3 4; 5 6; 7 8];                      % West and East point of each floor

%% 2. Mode figures from Zenodo and rigid floor motion
rec = zenodo_records('sheraton');
figFiles = cell(1, numel(rec.files));
for m = 1:numel(rec.files)
    figFiles{m} = download_zenodo('sheraton', rec.files(m).name, paths.raw);
end
R = fig_to_rigid(figFiles, Z, L, W);

%% 3. Sensor points and indices
% natural frequencies (Hz) and damping ratios identified through NExT-LF
mp = table([0.64; 1.86; 3.40; 6.01; 6.99], [0.03; 0.01; 0.02; 0.02; 0.01], 'VariableNames', {'f_Hz', 'zeta'});
nM = size(R, 3);
Pt = readtable(fullfile(paths.data, 'sensor_positions.csv'));   % West and East point of each floor
pos = [Pt.x_m, Pt.y_m, Pt.z_m];
res = struct();
rows = cell(nM, 8);
rs = zeros(4, nM);
taus = zeros(nM, 1);
fld = {'f', 'zeta', 'B', 'T', 'tau', 'rho'};
for m = 1:nM
    U = zeros(8, 3);
    for k = 1:4
        ux = R(k,1,m); uy = R(k,2,m); th = (R(k,3,m) + R(k,4,m)) / 2;
        U(2*k-1, :) = [ux, uy - th * L/2, 0];
        U(2*k, :) = [ux, uy + th * L/2, 0];
    end
    Uall(:, :, m) = U;
    r = identifyMotion(pos, reshape(U.', [], 1), [L/2 W/2 0], [0 0 1]);
    taus(m) = twist_share(U, pairs, n);
    rho = inplane_ratio(U, n);
    rs(:, m) = section_ratios(U, pairs, n);
    label = classify_rule(taus(m), rho, rs(:, m), names, tau_b, rho_b);
    vals = {mp.f_Hz(m), mp.zeta(m), r.b_score, r.t_score, taus(m), rho};
    for k = 1:6
        res.(sprintf('tab4_m%d_%s', m, fld{k})) = vals{k};
    end
    res.(sprintf('tab4_m%d_type', m)) = label;
    rows(m, :) = [{m}, vals, {label}];
    for k = 1:4
        res.(sprintf('rs_m%d_f%d', m, k)) = rs(k, m);
    end
end
res.rs_m1_min = min(rs(:, 1));
res.rs_m1_max = max(rs(:, 1));
res.tau_max = max(taus);
disp(cell2table(rows, 'VariableNames', {'mode', 'f_Hz', 'zeta', 'B', 'T', 'tau', 'rho', 'type'}));
disp('East-West over North-South motion at each floor:');
disp(array2table(round(rs.', 2), 'VariableNames', floorNames));

% sensitivity to sensor coverage: each mode classified again without one floor
fprintf('Labels with one floor left out (identified modes and bounds fixed):\n');
nKept = 0;
for m = 1:nM
    for drop = 1:4
        keep = setdiff(1:4, drop);
        sel = reshape([2*keep - 1; 2*keep], 1, []);
        Uk = Uall(sel, :, m);
        pk = reshape(1:numel(sel), 2, []).';
        rhoK = inplane_ratio(Uk, n);
        labK = classify_rule(twist_share(Uk, pk, n), rhoK, section_ratios(Uk, pk, n), names, tau_b, rho_b);
        if strcmp(labK, rows{m, 8})
            nKept = nKept + 1;
        else
            fprintf('  mode %d without %s: %s (rho %.2f)\n', m, floorNames{drop}, labK, rhoK);
            res.(sprintf('loo_m%d_%s_type', m, floorNames{drop})) = labK;
            res.(sprintf('loo_m%d_%s_rho', m, floorNames{drop})) = rhoK;
        end
    end
end
res.loo_kept = nKept;
fprintf('  %d of %d labels unchanged\n', nKept, 4 * nM);

%% 4. Figure 7
sheraton_mode_figures(R, mp.f_Hz, paths.figures);
colourbar_figure(fullfile(paths.figures, 'Figure5e.pdf'));

%% 5. Comparison with the article
compare_paper_values(res, sheraton_paper_values());
