function rs = section_ratios(U, pairs, n)
% SECTION_RATIOS  In-plane ratio of each section, over its two sensors.
%
%   rs = section_ratios(U, pairs, n)
%
%   Splits each sensor vector into its component along the unit normal n
%   of the reference plane (out-of-plane motion) and its component in that
%   plane (in-plane motion). For each section k, rs(k) is the largest
%   in-plane motion over the largest out-of-plane motion of the two
%   sensors of section k; a section with no in-plane measurement gives 0.
%
%   INPUT
%   -----
%   U     : double [N x 3], sensor vectors, one row per sensor
%   pairs : positive integers [K x 2], sensor rows of U of each section
%   n     : double [1 x 3], unit normal of the reference plane
%
%   OUTPUT
%   ------
%   rs    : double [K x 1], in-plane ratio of each section (dimensionless)
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

arguments
    U (:,3) double
    pairs (:,2) double {mustBeInteger, mustBePositive}
    n (1,3) double
end

w = U * n(:);
ip = vecnorm(U - w * n, 2, 2);
rs = max(ip(pairs), [], 2) ./ max(abs(w(pairs)), [], 2);
end
