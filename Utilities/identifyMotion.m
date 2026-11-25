function result = identifyMotion(pos, mode, com, axis_known)
% IDENTIFYMOTION  Bending score B and torsion score T of a mode from its sensor vectors.
%
%   result = identifyMotion(pos, mode, com, axis_known)
%
%   Reshapes the mode vector into one displacement vector per sensor and
%   computes two scores. The bending score B is the length of the mean
%   sensor vector over the mean sensor vector length. The torsion score T
%   is the mean absolute cosine between each residual, left after removing
%   the component along the mean direction, and the tangent of a rotation
%   about the span axis. Sensors with a residual or a tangent of norm below
%   1e-10 are skipped in T; B and the mean direction are set to zero when
%   the mean vector or the mean length is below 1e-10. Called by the
%   main.m scripts of Plate, Sheraton and XB2 and by rigid_rotation.m.
%
%   INPUT
%   -----
%   pos        : [N x 3] sensor positions
%   mode       : [3N x 1] mode vector, [ux1 uy1 uz1 ux2 ...]
%   com        : [1 x 3] point on the span axis
%   axis_known : [1 x 3] direction of the span axis (normalised inside)
%
%   OUTPUT
%   ------
%   result : structure, fields:
%       .U        - [N x 3] sensor vectors
%       .U_res    - [N x 3] residual after removing the mean direction
%       .bend_dir - [1 x 3] mean direction (unit vector, or zeros)
%       .b_score  - B, length of the mean vector over the mean vector
%                   length
%       .t_score  - T, mean absolute cosine between each residual and the
%                   tangent of a rotation about the span axis
%
%   DEPENDENCIES: none
%
%   LICENCE: MIT licence (see LICENSE)
%
%   AUTHOR(S): G. Dessena, S. Undiano Echaniz
%              Universidad Carlos III de Madrid
%              gdessena@ing.uc3m.es
%
%   REFERENCES:
%     [1] G. Dessena, M. Civera, S. Undiano Echaniz, and O.
%         Bonilla-Manrique, "Automated classification of modal
%         displacements," arXiv:2611.31472, 2026. Preprint.
%         doi: 10.48550/arXiv.2611.31472
% =========================================================================

N = size(pos, 1);
U = reshape(mode, 3, N).';
r = pos - com;

% Mean direction
u_mean = mean(U, 1);
if norm(u_mean) > 1e-10
    bend_dir = u_mean / norm(u_mean);
else
    bend_dir = [0 0 0];
end

% Bending score
avg_norm = mean(vecnorm(U, 2, 2));
if avg_norm > 1e-10
    b_score = norm(u_mean) / avg_norm;
else
    b_score = 0;
end

% Span axis
axis_used = axis_known / norm(axis_known);

% Residual after removing the mean direction
U_res = zeros(N, 3);
for i = 1:N
    if norm(bend_dir) > 1e-10
        U_b = dot(U(i,:), bend_dir) * bend_dir;
    else
        U_b = [0 0 0];
    end
    U_res(i,:) = U(i,:) - U_b;
end

% Torsion score
t_accum = 0;
count = 0;
for i = 1:N
    if norm(U_res(i,:)) < 1e-10
        continue;
    end
    tangential = cross(axis_used, r(i,:));
    if norm(tangential) > 1e-10
        tangential = tangential / norm(tangential);
        u_res_unit = U_res(i,:) / norm(U_res(i,:));
        t_accum = t_accum + abs(dot(u_res_unit, tangential));
        count = count + 1;
    end
end
t_score = t_accum / max(count, 1);

result.U = U;
result.U_res = U_res;
result.bend_dir = bend_dir;
result.b_score = b_score;
result.t_score = t_score;
end
