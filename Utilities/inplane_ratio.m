function rho = inplane_ratio(U, n)
% INPLANE_RATIO  Largest in-plane over largest out-of-plane sensor motion.
%
%   rho = inplane_ratio(U, n)
%
%   Projects each sensor vector on the normal n of the reference plane,
%   takes the norm of the remaining in-plane part, and returns the ratio
%   of the largest in-plane magnitude to the largest absolute out-of-plane
%   component over all sensors. It is called by the main scripts of the
%   Plate, Sheraton and XB2 case studies and by XB2/src/rigid_rotation.m.
%
%   INPUT
%   -----
%   U   : double [N x 3], sensor vectors, one row per sensor
%   n   : double [1 x 3], unit normal of the reference plane
%
%   OUTPUT
%   ------
%   rho : double scalar, max in-plane norm over max absolute out-of-plane
%         component (dimensionless)
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
    n (1,3) double
end

w = U * n(:);
ip = vecnorm(U - w * n, 2, 2);
rho = max(ip) / max(abs(w));
end
