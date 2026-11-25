function [B, T, tau, rho] = rigid_rotation(pos, measured, xs, pairs, n)
% RIGID_ROTATION  Indices of a rigid rotation of all XB-2 sections by the same angle.
%
%   [B, T, tau, rho] = rigid_rotation(pos, measured, xs, pairs, n)
%
%   Builds the sensor vectors of a rigid rotation of every XB-2 section by
%   the same unit angle and returns the indices of this synthetic mode. A
%   unit rotation about a spanwise line at x = xs, z = 0 moves a sensor by
%   [dz, 0, -dx], with dx and dz its offsets from the line; only the
%   measured components are kept. B and T are referred to the
%   quarter-chord span axis (point [0 0 0], direction [0 1 0]). Called
%   twice by XB2/main.m, with the axis at the quarter chord (xs = 0) and
%   at the shear centre.
%
%   INPUT
%   -----
%   pos      : double [8 x 3], sensor positions (mm), rows 1R 1L 2R 2L 3R
%              3L 4R 4L
%   measured : logical [8 x 3], true for the measured components of each
%              sensor
%   xs       : double [1 x 4], chordwise position of the rotation axis at
%              each station (mm); sensor i belongs to station ceil(i/2)
%   pairs    : positive integer [K x 2], sensor rows of each section,
%              passed to twist_share
%   n        : double [1 x 3], unit normal of the reference plane
%
%   OUTPUT
%   ------
%   B   : double scalar, bending score of the rotation (identifyMotion)
%   T   : double scalar, torsion score of the rotation (identifyMotion)
%   tau : double scalar, twist share of the rotation (twist_share)
%   rho : double scalar, in-plane ratio of the rotation (inplane_ratio)
%
%   DEPENDENCIES: identifyMotion, twist_share, inplane_ratio (Utilities)
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
%         p. 438, 2022. doi: 10.3390/aerospace9080438
% =========================================================================

U = zeros(8, 3);
for i = 1:8
    s = ceil(i / 2);
    dx = pos(i, 1) - xs(s);
    dz = pos(i, 3);
    U(i, :) = [dz, 0, -dx] .* measured(i, :);
end
r = identifyMotion(pos, reshape(U.', [], 1), [0 0 0], [0 1 0]);
B = r.b_score;
T = r.t_score;
tau = twist_share(U, pairs, n);
rho = inplane_ratio(U, n);
end
