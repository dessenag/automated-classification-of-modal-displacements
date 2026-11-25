% MAIN  Indices and types of the first eight modes of the tapered plate.
%
%   Tapered cantilever plate with a swept trailing edge. The script
%   computes the indices and the type of the first eight modes and
%   reproduces Table 1 and Figure 3 of the article.
%
%   USAGE
%   -----
%   Run main.m from MATLAB (any current folder). The modal analysis is run
%   with Ansys Mechanical APDL, whose executable is given by the
%   environment variable ANSYS_EXE. Mode files already present in
%   results/apdl are reused instead of running the model again, so
%   ANSYS_EXE is needed only when they are missing. Settings in section 1:
%   nModes = 8, bounds of the classification rule tau_b = 0.05 and
%   rho_b = 0.5, leading and trailing edge sensor pairs of the four
%   stations, and normal of the reference plane n = [0 0 1].
%
%   OUTPUT
%   ------
%   results/apdl         : APDL input and mode files (mode_1.csv, ...)
%   command window       : table of mode, f_Hz, B, T, tau, rho and type
%   Figures/Figure3a.pdf, ... and Figure3i.pdf : Figure 3 (mode shapes
%                          and colour bar)
%   command window       : comparison with the values of the article
%
%   DEPENDENCIES: setup_paths, plate_sensor_vectors, identifyMotion,
%                 twist_share, inplane_ratio, section_ratios,
%                 classify_rule, plate_mode_figures, colourbar_figure,
%                 compare_paper_values,
%                 plate_paper_values (this repository); Plate/apdl
%                 (plate_modal.mac, params.inc) and
%                 data/sensor_positions.csv; Ansys Mechanical APDL
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

clear; close all;
here = fileparts(mfilename('fullpath'));
addpath(fileparts(here));
paths = setup_paths("Plate");

%% 1. Settings
nModes = 8;
tau_b = 0.05; rho_b = 0.5;                         % bounds of the classification rule
names = struct('oop_bending', 'out-of-plane bending', 'ip_bending', 'in-plane bending', 'torsion', 'torsion');
pairs = [1 5; 2 6; 3 7; 4 8];                      % LE and TE sensor of each station
n = [0 0 1];                                       % normal of the reference plane

%% 2. FE modal analysis and sensor vectors
runDir = fullfile(paths.results, 'apdl');
if ~isfolder(runDir), mkdir(runDir); end
have = arrayfun(@(m) isfile(fullfile(runDir, sprintf('mode_%d.csv', m))), 1:nModes);
if ~all(have)
    if strlength(paths.ansys_exe) == 0
        error('Set the environment variable ANSYS_EXE to the Ansys Mechanical APDL executable.');
    end
    copyfile(fullfile(here, 'apdl', 'plate_modal.mac'), runDir);
    copyfile(fullfile(here, 'apdl', 'params.inc'), runDir);
    fid = fopen(fullfile(runDir, 'mesh.inc'), 'w');
    fprintf(fid, 'N_CHORD = 156\nN_SPAN = 800\nN_MODES = %d\n', nModes);
    fclose(fid);
    cmd = sprintf('"%s" -b -np 4 -dir "%s" -i plate_modal.mac -o out.txt -j fe8', paths.ansys_exe, runDir);
    fprintf('Running the FE model (this takes several minutes) ...\n');
    status = system(cmd);
    have = arrayfun(@(m) isfile(fullfile(runDir, sprintf('mode_%d.csv', m))), 1:nModes);
    if status ~= 0 || ~all(have)
        error('The APDL run failed (exit code %d); see %s.', status, fullfile(runDir, 'out.txt'));
    end
end
Pt = readtable(fullfile(paths.data, 'sensor_positions.csv'));   % rows LE S1-S4, TE S1-S4
pos = [Pt.x_mm, Pt.y_mm, Pt.z_mm];
[U, f, shapes] = plate_sensor_vectors(runDir, nModes, pos);

%% 3. Indices and classification rule
res = struct();
rows = cell(nModes, 7);
for m = 1:nModes
    r = identifyMotion(pos, reshape(U(:,:,m).', [], 1), [0 0 0], [0 1 0]);
    tau = twist_share(U(:,:,m), pairs, n);
    rho = inplane_ratio(U(:,:,m), n);
    rs = section_ratios(U(:,:,m), pairs, n);
    label = classify_rule(tau, rho, rs, names, tau_b, rho_b);
    vals = {f(m), r.b_score, r.t_score, tau, rho};
    fld = {'f', 'B', 'T', 'tau', 'rho'};
    for k = 1:5
        res.(sprintf('tab1_m%d_%s', m, fld{k})) = vals{k};
    end
    res.(sprintf('tab1_m%d_type', m)) = label;
    rows(m,:) = [{m}, vals, {label}];
end
disp(cell2table(rows, 'VariableNames', {'mode', 'f_Hz', 'B', 'T', 'tau', 'rho', 'type'}));

%% 4. Figure 3
plate_mode_figures(shapes, U, pos, f, paths.figures);
colourbar_figure(fullfile(paths.figures, 'Figure3i.pdf'));

%% 5. Comparison with the article
compare_paper_values(res, plate_paper_values());
