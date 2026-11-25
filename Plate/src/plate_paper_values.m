function P = plate_paper_values()
% PLATE_PAPER_VALUES  Values printed in the article for the plate case (Table 1).
%
%   P = plate_paper_values()
%
%   Returns the values that the article reports in Table 1 for the eight
%   modes of the plate: natural frequency f, indices B, T, tau and rho,
%   and the mode type label. Plate/main.m passes the result to
%   compare_paper_values, which checks the computed results against it.
%
%   INPUT
%   -----
%   (none)
%
%   OUTPUT
%   ------
%   P : struct array [48 x 1], one element per printed value, fields:
%       .name     - identifier of the value, e.g. 'tab1_m3_tau'
%       .value    - printed value (number, or character vector for labels)
%       .decimals - number of decimals printed in the article (0 for labels)
%       .source   - table or section of the article ('Table 1')
%       .type     - 'number', 'label' or 'upper'
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

c = {
    'tab1_m1_f', 2.32, 2, 'Table 1', 'number'
    'tab1_m1_B', 1, 3, 'Table 1', 'number'
    'tab1_m1_T', 0.007, 3, 'Table 1', 'number'
    'tab1_m1_tau', 0, 3, 'Table 1', 'number'
    'tab1_m1_rho', 0.001, 3, 'Table 1', 'number'
    'tab1_m1_type', 'out-of-plane bending', 0, 'Table 1', 'label'
    'tab1_m2_f', 11.6, 2, 'Table 1', 'number'
    'tab1_m2_B', 0.103, 3, 'Table 1', 'number'
    'tab1_m2_T', 0.03, 3, 'Table 1', 'number'
    'tab1_m2_tau', 0.002, 3, 'Table 1', 'number'
    'tab1_m2_rho', 0.004, 3, 'Table 1', 'number'
    'tab1_m2_type', 'out-of-plane bending', 0, 'Table 1', 'label'
    'tab1_m3_f', 25.12, 2, 'Table 1', 'number'
    'tab1_m3_B', 0.021, 3, 'Table 1', 'number'
    'tab1_m3_T', 0.659, 3, 'Table 1', 'number'
    'tab1_m3_tau', 0.996, 3, 'Table 1', 'number'
    'tab1_m3_rho', 0.014, 3, 'Table 1', 'number'
    'tab1_m3_type', 'torsion', 0, 'Table 1', 'label'
    'tab1_m4_f', 30.37, 2, 'Table 1', 'number'
    'tab1_m4_B', 0.507, 3, 'Table 1', 'number'
    'tab1_m4_T', 0.015, 3, 'Table 1', 'number'
    'tab1_m4_tau', 0.009, 3, 'Table 1', 'number'
    'tab1_m4_rho', 0.007, 3, 'Table 1', 'number'
    'tab1_m4_type', 'out-of-plane bending', 0, 'Table 1', 'label'
    'tab1_m5_f', 58.19, 2, 'Table 1', 'number'
    'tab1_m5_B', 0.202, 3, 'Table 1', 'number'
    'tab1_m5_T', 0.037, 3, 'Table 1', 'number'
    'tab1_m5_tau', 0.101, 3, 'Table 1', 'number'
    'tab1_m5_rho', 0.01, 3, 'Table 1', 'number'
    'tab1_m5_type', 'out-of-plane bending coupled with torsion', 0, 'Table 1', 'label'
    'tab1_m6_f', 60.69, 2, 'Table 1', 'number'
    'tab1_m6_B', 0.079, 3, 'Table 1', 'number'
    'tab1_m6_T', 0.086, 3, 'Table 1', 'number'
    'tab1_m6_tau', 0.9, 3, 'Table 1', 'number'
    'tab1_m6_rho', 0.016, 3, 'Table 1', 'number'
    'tab1_m6_type', 'torsion coupled with out-of-plane bending', 0, 'Table 1', 'label'
    'tab1_m7_f', 95.72, 2, 'Table 1', 'number'
    'tab1_m7_B', 0.539, 3, 'Table 1', 'number'
    'tab1_m7_T', 0.011, 3, 'Table 1', 'number'
    'tab1_m7_tau', 0.141, 3, 'Table 1', 'number'
    'tab1_m7_rho', 0.013, 3, 'Table 1', 'number'
    'tab1_m7_type', 'out-of-plane bending coupled with torsion', 0, 'Table 1', 'label'
    'tab1_m8_f', 100.9, 2, 'Table 1', 'number'
    'tab1_m8_B', 0.084, 3, 'Table 1', 'number'
    'tab1_m8_T', 0.083, 3, 'Table 1', 'number'
    'tab1_m8_tau', 0.971, 3, 'Table 1', 'number'
    'tab1_m8_rho', 0.017, 3, 'Table 1', 'number'
    'tab1_m8_type', 'torsion', 0, 'Table 1', 'label'
    };
P = cell2struct(c, {'name', 'value', 'decimals', 'source', 'type'}, 2);
end
