% MAIN  XB-2 flexible wing: identification and indices of the modes from the ground vibration test.
%
%   Identifies the modes of the XB-2 wing from the ground vibration test
%   [3] with the real-valued improved Loewner Framework (iLF) over model
%   orders 2 to 80 in the 2 to 30 Hz band, takes four modes (the picks of
%   the article, or a selection by hand on the stabilisation diagram) and
%   computes their bending and torsion scores, twist share tau, in-plane
%   ratio rho and class. Reproduces Table 3 and Figure 5, checks the
%   sensor positions of Table 2, and reproduces the section in-plane
%   ratios of Section 4.1 and the rigid-rotation reference values of the
%   first limitation of the article. Downloads the decimated record [2]
%   from Zenodo and the iLF tutorial [4] on first use.
%
%   USAGE
%   -----
%   Run from any folder: >> main
%   SELECTION : 'stored' (article picks, default) or 'manual'   <-- USER
%               'stored' takes the modes selected for the article (model
%               order 80, iLF output columns 5, 14, 24 and 29) and checks
%               their frequencies; 'manual' opens the interactive
%               stabilisation diagram to pick the modes.
%   Other settings in section 1: model orders nn, band (Hz), stabilisation
%   criteria stab, vertical wing channels, classification bounds
%   tau_b = 0.05 and rho_b = 0.5, LE and TE sensor pairs per station,
%   reference plane normal [0 0 1] and shear centre positions (mm aft of
%   the quarter chord, per station).
%   Data: XB2/data/sensor_positions.csv and XB2_timeseries_256Hz.mat in
%   XB2/data/raw, or in the folder set by the variable XB2_DATA_DIR.
%
%   OUTPUT
%   ------
%   Figures: the mode shapes of Figure 5 (Figure5a.pdf to Figure5d.pdf)
%            and Figure5e.pdf (colour bar), in XB2/Figures
%   Printed: Table 3, the section in-plane ratios of stations 1 to 3, the
%            rigid-rotation values about the quarter chord and the shear
%            centre, and the comparison with the article values
%
%   DEPENDENCIES: setup_paths, download_zenodo, fetch_ilf, xb2_frf,
%                 stabilisation_diagram, identifyMotion, twist_share,
%                 inplane_ratio, section_ratios, classify_rule,
%                 rigid_rotation, xb2_mode_figures, colourbar_figure,
%                 compare_paper_values, xb2_paper_values (this
%                 repository); iLF_id (iLF tutorial [4], downloaded);
%                 Signal Processing Toolbox
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
%     [4] G. Dessena, "A tutorial for the improved Loewner Framework for
%         modal analysis," Universidad Carlos III de Madrid, Zenodo,
%         16 Nov. 2024, doi: 10.5281/zenodo.13863292.
% =========================================================================

clear; close all;
here = fileparts(mfilename('fullpath'));
addpath(fileparts(here));
paths = setup_paths("XB2");

%% 1. Settings
SELECTION = 'stored';                              % <-- USER: 'stored' (article picks) or 'manual'
nn = 2:2:80;                                       % model orders of the iLF
band = [2 30];                                     % identification band (Hz)
stab.d_min = 0.001;  stab.d_max = 0.3;             % stabilisation criteria
stab.f_min = 2;      stab.f_max = 30;
stab.dfr = 0.01;     stab.dz = 0.1;   stab.dMAC = 0.95;
stab.epsilon = 0.1;  stab.NumMAC = 2;
vertical = [1 3 4 6 7 9 10 11];                    % wing channels with a vertical axis
tau_b = 0.05; rho_b = 0.5;                         % bounds of the classification rule
names = struct('oop_bending', 'out-of-plane bending', 'ip_bending', 'in-plane bending', 'torsion', 'torsion');
pairs = [2 1; 4 3; 6 5; 8 7];                      % LE and TE sensor of each station
n = [0 0 1];                                       % normal of the reference plane
shearCentre = [20 16 12 8];                        % mm aft of the quarter chord, per station

%% 2. Data and iLF tutorial
dataFile = download_zenodo('xb2', 'XB2_timeseries_256Hz.mat', paths.xb2_data);
D = load(dataFile, 'x', 'fs');
fetch_ilf(paths.external);

%% 3. H1 FRFs (clamp input, 11 wing outputs)
[H, f] = xb2_frf(D.x, D.fs);
inBand = f >= band(1) & f <= band(2);
Hb = H(:, :, inBand);
fb = f(inBand);

%% 4. Real-valued iLF over the model orders
rng(1);                                            % the tangential directions are random
sysID = iLF_id(Hb, fb, nn);

%% 5. Stabilisation and mode selection
psds.fr_axis = fb;
psds.data = squeeze(abs(Hb)).';
psds.chan = vertical;
% modes selected for the article: model order and column of the iLF output, with
% the identified frequency (Hz) and damping ratio as a check
picks = array2table([1 80  5  3.16078428419205 0.0306843898950644
                     2 80 14 11.1841928972621  0.056566057545884
                     3 80 24 15.2473894401039  0.0297264676899483
                     4 80 29 16.9949400761666  0.0435546089123863], ...
    'VariableNames', {'mode', 'order', 'column', 'f_Hz', 'zeta'});
switch SELECTION
    case 'stored'
        phi = zeros(size(sysID(1).ident, 1), height(picks));
        for m = 1:height(picks)
            k = find([sysID.order] == picks.order(m), 1);
            phi(:, m) = sysID(k).ident(:, picks.column(m));
            if abs(phi(1, m) - picks.f_Hz(m)) > 1e-6 * picks.f_Hz(m)
                error('Stored pick %d does not match the identified pole (%.4f Hz against %.4f Hz).', ...
                    m, phi(1, m), picks.f_Hz(m));
            end
        end
    case 'manual'
        [~, ~, ~, sel] = stabilisation_diagram(sysID, fullfile(paths.results, 'xb2_manual'), 'stab', stab, psds, '', ...
            'XB-2 full wing, real-valued iLF', false);
        phi = sel.id;
        picks = table((1:size(phi, 2)).', sel.order(:), nan(size(phi, 2), 1), phi(1,:).', phi(2,:).', ...
            'VariableNames', {'mode', 'order', 'column', 'f_Hz', 'zeta'});
end
freq = phi(1, :);
zeta = phi(2, :);
nM = numel(freq);

%% 6. Sensor positions and sensor vectors
St = readtable(fullfile(paths.data, 'sensor_positions.csv'), 'TextType', 'char');   % rows 1R 1L 2R 2L 3R 3L 4R 4L
geo.sensors = struct('name', St.sensor, 'x', num2cell(St.x_mm), 'y', num2cell(St.y_mm), ...
    'z', num2cell(St.z_mm), 'chord', num2cell(St.chord_mm), 'xf', num2cell(St.chord_fraction)).';
pos = [St.x_mm, St.y_mm, St.z_mm];
% channel -> sensor and wing axis: Y channels give z (vertical), Z channels give x (chordwise)
chSensor = [1 1 2 3 3 4 5 5 6 7 8];
chAxis = [3 1 3 3 1 3 3 1 3 3 3];
U = zeros(8, 3, nM);
for m = 1:nM
    for c = 1:11
        U(chSensor(c), chAxis(c), m) = phi(2 + c, m);
    end
end

%% 7. Indices and classification rule
res = struct();
rows = cell(nM, 8);
rs = zeros(4, nM);
for m = 1:nM
    r = identifyMotion(pos, reshape(U(:,:,m).', [], 1), [0 0 0], [0 1 0]);
    tau = twist_share(U(:,:,m), pairs, n);
    rho = inplane_ratio(U(:,:,m), n);
    rs(:, m) = section_ratios(U(:,:,m), pairs, n);
    label = classify_rule(tau, rho, rs(:, m), names, tau_b, rho_b);
    vals = {freq(m), zeta(m), r.b_score, r.t_score, tau, rho};
    fld = {'f', 'zeta', 'B', 'T', 'tau', 'rho'};
    for k = 1:6
        res.(sprintf('tab3_m%d_%s', m, fld{k})) = vals{k};
    end
    res.(sprintf('tab3_m%d_type', m)) = label;
    rows(m, :) = [{m}, vals, {label}];
end
disp(cell2table(rows, 'VariableNames', {'mode', 'f_Hz', 'zeta', 'B', 'T', 'tau', 'rho', 'type'}));
fprintf('Section in-plane ratios (stations 1-3):\n');
for m = 1:nM
    fprintf('  mode %d: %s\n', m, mat2str(rs(1:3, m).', 2));
    for s = 1:3
        res.(sprintf('rs_m%d_s%d', m, s)) = rs(s, m);
    end
end
for s = geo.sensors
    res.(sprintf('tab2_%s_x', s.name)) = s.x;
    res.(sprintf('tab2_%s_y', s.name)) = s.y;
    res.(sprintf('tab2_%s_z', s.name)) = s.z;
end

%% 8. Rigid-rotation reference values (first limitation)
measured = [repmat([1 0 1], 8, 1)];
measured([2 4 6 7 8], 1) = 0;                      % chordwise channels at 1R, 2R and 3R only
[res.rot_c4_B, res.rot_c4_T, res.rot_c4_tau, res.rot_c4_rho] = rigid_rotation(pos, measured, [0 0 0 0], pairs, n);
[res.rot_sc_B, res.rot_sc_T, res.rot_sc_tau, res.rot_sc_rho] = rigid_rotation(pos, measured, shearCentre, pairs, n);
fprintf('Rigid rotation about the quarter chord: B %.3f, T %.3f, tau %.3f, rho %.3f\n', ...
    res.rot_c4_B, res.rot_c4_T, res.rot_c4_tau, res.rot_c4_rho);
fprintf('Rigid rotation about the shear centre:  B %.3f, T %.3f, tau %.3f, rho %.3f\n', ...
    res.rot_sc_B, res.rot_sc_T, res.rot_sc_tau, res.rot_sc_rho);

%% 9. Figure 5
xb2_mode_figures(U, pos, freq, geo, paths.figures);
colourbar_figure(fullfile(paths.figures, 'Figure5e.pdf'));

%% 10. Comparison with the article
compare_paper_values(res, xb2_paper_values());
