function tau = twist_share(U, pairs, n)
% TWIST_SHARE  Twist share of a mode from the out-of-plane motion of sensor pairs.
%
%   tau = twist_share(U, pairs, n)
%
%   Projects the sensor vectors of a mode on the normal n of the reference
%   plane, w = U*n, and splits the motion of each section, defined by a
%   pair of sensors, into heave h = (w2 + w1)/2 and twist th = (w2 - w1)/2.
%   The twist share is tau = sum(th.^2) / sum(h.^2 + th.^2), summed over
%   the sections.
%
%   INPUT
%   -----
%   U     : double [N x 3], sensor vectors of the mode
%   pairs : positive integer [K x 2], sensor rows of each section (first,
%           second)
%   n     : double [1 x 3], unit normal of the reference plane
%
%   OUTPUT
%   ------
%   tau   : double scalar, twist share of the mode (dimensionless)
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
h = (w(pairs(:,2)) + w(pairs(:,1))) / 2;
th = (w(pairs(:,2)) - w(pairs(:,1))) / 2;
tau = sum(th.^2) / sum(h.^2 + th.^2);
end
