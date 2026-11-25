function P = xb2_paper_values()
% XB2_PAPER_VALUES  Values printed in the article for the XB-2 wing.
%
%   P = xb2_paper_values()
%
%   Returns the values printed in the article for the XB-2 wing, taken
%   from Tables 2 and 3, Section 4.1 and the first limitation discussed in
%   Section 5. The struct array is read by compare_paper_values, which
%   checks the values computed by the repository against the article.
%
%   INPUT
%   -----
%   (none)
%
%   OUTPUT
%   ------
%   P : struct array [66 x 1], fields:
%       .name     - identifier of the value (char)
%       .value    - value printed in the article (double, or char for a
%                   label)
%       .decimals - number of decimals printed in the article
%       .source   - table or section of the article (char)
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
%     [2] G. Dessena, "A dataset for partial in-plane acceleration of the
%         XB-2 wing," Universidad Carlos III de Madrid, Zenodo, 2026,
%         doi: 10.5281/zenodo.24536230.
%     [3] G. Dessena, D. I. Ignatyev, J. F. Whidborne, A. Pontillo, and
%         L. Zanotti Fragonara, "Ground vibration testing of a flexible
%         wing: A benchmark and case study," Aerospace, vol. 9, no. 8,
%         p. 438, 2022, doi: 10.3390/aerospace9080438.
% =========================================================================

c = {
    'tab2_1R_x', 105, 0, 'Table 2', 'number'
    'tab2_1R_y', 430, 0, 'Table 2', 'number'
    'tab2_1R_z', 12, 0, 'Table 2', 'number'
    'tab2_1L_x', -17, 0, 'Table 2', 'number'
    'tab2_1L_y', 430, 0, 'Table 2', 'number'
    'tab2_1L_z', 20, 0, 'Table 2', 'number'
    'tab2_2R_x', 97, 0, 'Table 2', 'number'
    'tab2_2R_y', 650, 0, 'Table 2', 'number'
    'tab2_2R_z', 11, 0, 'Table 2', 'number'
    'tab2_2L_x', -14, 0, 'Table 2', 'number'
    'tab2_2L_y', 650, 0, 'Table 2', 'number'
    'tab2_2L_z', 18, 0, 'Table 2', 'number'
    'tab2_3R_x', 74, 0, 'Table 2', 'number'
    'tab2_3R_y', 1010, 0, 'Table 2', 'number'
    'tab2_3R_z', 8, 0, 'Table 2', 'number'
    'tab2_3L_x', -10, 0, 'Table 2', 'number'
    'tab2_3L_y', 1010, 0, 'Table 2', 'number'
    'tab2_3L_z', 15, 0, 'Table 2', 'number'
    'tab2_4R_x', 51, 0, 'Table 2', 'number'
    'tab2_4R_y', 1325, 0, 'Table 2', 'number'
    'tab2_4R_z', 8, 0, 'Table 2', 'number'
    'tab2_4L_x', -4, 0, 'Table 2', 'number'
    'tab2_4L_y', 1325, 0, 'Table 2', 'number'
    'tab2_4L_z', 13, 0, 'Table 2', 'number'
    'tab3_m1_f', 3.16, 2, 'Table 3', 'number'
    'tab3_m1_zeta', 0.031, 3, 'Table 3', 'number'
    'tab3_m1_B', 0.996, 3, 'Table 3', 'number'
    'tab3_m1_T', 0.466, 3, 'Table 3', 'number'
    'tab3_m1_tau', 0.001, 3, 'Table 3', 'number'
    'tab3_m1_rho', 0.1, 2, 'Table 3', 'number'
    'tab3_m1_type', 'out-of-plane bending', 0, 'Table 3', 'label'
    'tab3_m2_f', 11.18, 2, 'Table 3', 'number'
    'tab3_m2_zeta', 0.057, 3, 'Table 3', 'number'
    'tab3_m2_B', 0.417, 3, 'Table 3', 'number'
    'tab3_m2_T', 0.608, 3, 'Table 3', 'number'
    'tab3_m2_tau', 0.451, 3, 'Table 3', 'number'
    'tab3_m2_rho', 0.25, 2, 'Table 3', 'number'
    'tab3_m2_type', 'out-of-plane bending coupled with torsion', 0, 'Table 3', 'label'
    'tab3_m3_f', 15.25, 2, 'Table 3', 'number'
    'tab3_m3_zeta', 0.03, 3, 'Table 3', 'number'
    'tab3_m3_B', 0.453, 3, 'Table 3', 'number'
    'tab3_m3_T', 0.729, 3, 'Table 3', 'number'
    'tab3_m3_tau', 0.264, 3, 'Table 3', 'number'
    'tab3_m3_rho', 1.33, 2, 'Table 3', 'number'
    'tab3_m3_type', 'in-plane bending coupled with out-of-plane bending and torsion', 0, 'Table 3', 'label'
    'tab3_m4_f', 16.99, 2, 'Table 3', 'number'
    'tab3_m4_zeta', 0.044, 3, 'Table 3', 'number'
    'tab3_m4_B', 0.235, 3, 'Table 3', 'number'
    'tab3_m4_T', 0.604, 3, 'Table 3', 'number'
    'tab3_m4_tau', 0.339, 3, 'Table 3', 'number'
    'tab3_m4_rho', 0.2, 2, 'Table 3', 'number'
    'tab3_m4_type', 'out-of-plane bending coupled with torsion', 0, 'Table 3', 'label'
    'rot_c4_B', 0.76, 2, 'Section 5, first limitation', 'number'
    'rot_c4_T', 0.45, 2, 'Section 5, first limitation', 'number'
    'rot_c4_tau', 0.64, 2, 'Section 5, first limitation', 'number'
    'rot_c4_rho', 0.12, 2, 'Section 5, first limitation', 'number'
    'rot_sc_B', 0.47, 2, 'Section 5, first limitation', 'number'
    'rot_sc_T', 0.49, 2, 'Section 5, first limitation', 'number'
    'rot_sc_tau', 0.83, 2, 'Section 5, first limitation', 'number'
    'rot_sc_rho', 0.15, 2, 'Section 5, first limitation', 'number'
    'rs_m3_s1', 0.98, 2, 'Section 4.1', 'number'
    'rs_m3_s2', 1.1, 2, 'Section 4.1', 'number'
    'rs_m3_s3', 3.7, 2, 'Section 4.1', 'number'
    'rs_m4_s1', 0.13, 2, 'Section 4.1', 'number'
    'rs_m4_s2', 0.08, 2, 'Section 4.1', 'number'
    'rs_m4_s3', 0.75, 2, 'Section 4.1', 'number'
    };
P = cell2struct(c, {'name', 'value', 'decimals', 'source', 'type'}, 2);
end
