function P = sheraton_paper_values()
% SHERATON_PAPER_VALUES  Values printed in the article for the Sheraton Universal Hotel.
%
%   P = sheraton_paper_values()
%
%   Returns the values that the article reports for the Sheraton Universal
%   Hotel case study (Table 4 and Section 4.2, plus the leave-one-out
%   check of Section 5, second limitation), so that compare_paper_values
%   can check them against the values recomputed by the code. For each of
%   the five modes, Table 4 gives f, zeta, B, T, tau, rho and the mode
%   type label. Section 4.2 gives four values each for modes 2, 4 and 5,
%   the range for mode 1 and the upper bound on tau (below 0.0005).
%
%   INPUT
%   -----
%   (none)
%
%   OUTPUT
%   ------
%   P : [53 x 1] struct array, fields:
%       .name     - identifier of the value, char
%       .value    - value printed in the article, double or char (label)
%       .decimals - number of decimals printed in the article
%       .source   - table or section of the article, char
%       .type     - 'number', 'label' or 'upper' (upper bound), char
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
%     [2] G. Dessena, M. Civera, A. Yousefi, and C. Surace, "NExT-LF: A
%         Novel Operational Modal Analysis Method via Tangential
%         Interpolation," International Journal of Mechanical System
%         Dynamics, vol. 5, no. 3, pp. 401-414, 2025.
%         doi: 10.1002/msd2.70016
%     [3] G. Dessena, "Data supporting: NExT-LF: A Novel Operational Modal
%         Analysis Method via Tangential Interpolation," Universidad Carlos
%         III de Madrid, Zenodo, 13 May 2025. doi: 10.5281/zenodo.14975925
% =========================================================================

c = {
    'tab4_m1_f', 0.64, 2, 'Table 4', 'number'
    'tab4_m1_zeta', 0.03, 2, 'Table 4', 'number'
    'tab4_m1_B', 1, 3, 'Table 4', 'number'
    'tab4_m1_T', 0.219, 3, 'Table 4', 'number'
    'tab4_m1_tau', 0, 3, 'Table 4', 'number'
    'tab4_m1_rho', 0.22, 2, 'Table 4', 'number'
    'tab4_m1_type', 'North--South bending', 0, 'Table 4', 'label'
    'tab4_m2_f', 1.86, 2, 'Table 4', 'number'
    'tab4_m2_zeta', 0.01, 2, 'Table 4', 'number'
    'tab4_m2_B', 0.15, 3, 'Table 4', 'number'
    'tab4_m2_T', 0.163, 3, 'Table 4', 'number'
    'tab4_m2_tau', 0, 3, 'Table 4', 'number'
    'tab4_m2_rho', 0.33, 2, 'Table 4', 'number'
    'tab4_m2_type', 'North--South bending', 0, 'Table 4', 'label'
    'tab4_m3_f', 3.4, 2, 'Table 4', 'number'
    'tab4_m3_zeta', 0.02, 2, 'Table 4', 'number'
    'tab4_m3_B', 0.423, 3, 'Table 4', 'number'
    'tab4_m3_T', 0.064, 3, 'Table 4', 'number'
    'tab4_m3_tau', 0, 3, 'Table 4', 'number'
    'tab4_m3_rho', 0.21, 2, 'Table 4', 'number'
    'tab4_m3_type', 'North--South bending', 0, 'Table 4', 'label'
    'tab4_m4_f', 6.01, 2, 'Table 4', 'number'
    'tab4_m4_zeta', 0.02, 2, 'Table 4', 'number'
    'tab4_m4_B', 0.248, 3, 'Table 4', 'number'
    'tab4_m4_T', 0.347, 3, 'Table 4', 'number'
    'tab4_m4_tau', 0, 3, 'Table 4', 'number'
    'tab4_m4_rho', 0.53, 2, 'Table 4', 'number'
    'tab4_m4_type', 'North--South bending coupled with East--West bending', 0, 'Table 4', 'label'
    'tab4_m5_f', 6.99, 2, 'Table 4', 'number'
    'tab4_m5_zeta', 0.01, 2, 'Table 4', 'number'
    'tab4_m5_B', 0.677, 3, 'Table 4', 'number'
    'tab4_m5_T', 0.215, 3, 'Table 4', 'number'
    'tab4_m5_tau', 0, 3, 'Table 4', 'number'
    'tab4_m5_rho', 0.27, 2, 'Table 4', 'number'
    'tab4_m5_type', 'North--South bending coupled with East--West bending', 0, 'Table 4', 'label'
    'rs_m4_f1', 0.75, 2, 'Section 4.2', 'number'
    'rs_m4_f2', 0.16, 2, 'Section 4.2', 'number'
    'rs_m4_f3', 0.85, 2, 'Section 4.2', 'number'
    'rs_m4_f4', 0.96, 2, 'Section 4.2', 'number'
    'rs_m2_f1', 0.35, 2, 'Section 4.2', 'number'
    'rs_m2_f2', 0.37, 2, 'Section 4.2', 'number'
    'rs_m2_f3', 0.66, 2, 'Section 4.2', 'number'
    'rs_m2_f4', 0.33, 2, 'Section 4.2', 'number'
    'rs_m5_f1', 0.74, 2, 'Section 4.2', 'number'
    'rs_m5_f2', 1.95, 2, 'Section 4.2', 'number'
    'rs_m5_f3', 1.41, 2, 'Section 4.2', 'number'
    'rs_m5_f4', 0.1, 2, 'Section 4.2', 'number'
    'rs_m1_min', 0.11, 2, 'Section 4.2', 'number'
    'rs_m1_max', 0.24, 2, 'Section 4.2', 'number'
    'tau_max', 0.0005, 4, 'Section 4.2 (upper bound: tau below 0.0005)', 'upper'
    'loo_kept', 19, 0, 'Section 5 (second limitation)', 'number'
    'loo_m5_roof_rho', 1.75, 2, 'Section 5 (second limitation)', 'number'
    'loo_m5_roof_type', 'East--West bending coupled with North--South bending', 0, 'Section 5 (second limitation)', 'label'
    };
P = cell2struct(c, {'name', 'value', 'decimals', 'source', 'type'}, 2);
end
