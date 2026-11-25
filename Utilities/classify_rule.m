function [label, names_used] = classify_rule(tau, rho, rs, names, tau_b, rho_b)
% CLASSIFY_RULE  Type of motion of a mode from the twist share and the in-plane ratios.
%
%   [label, names_used] = classify_rule(tau, rho, rs, names)
%   [label, names_used] = classify_rule(tau, rho, rs, names, tau_b, rho_b)
%
%   Names the motion of one mode from its twist share, its in-plane ratio
%   and the in-plane ratios of its sections. The dominant motion is
%   in-plane bending if rho > 1, otherwise out-of-plane bending if
%   tau < 1/2 and torsion if tau > 1/2. Out-of-plane bending and torsion
%   are both named when min(tau, 1 - tau) >= tau_b, in the order of their
%   shares. In-plane and out-of-plane motion are both named when at least
%   two sections have rs within [rho_b, 1/rho_b]. The dominant motion is
%   named first; the others follow "coupled with", joined by "and".
%
%   INPUT
%   -----
%   tau   : scalar double, twist share
%   rho   : scalar double, in-plane ratio
%   rs    : double [K x 1], section in-plane ratios
%   names : scalar structure, fields:
%       .oop_bending - name of out-of-plane bending
%       .ip_bending  - name of in-plane bending
%       .torsion     - name of torsion
%   tau_b : (optional) scalar double, bound on min(tau, 1 - tau) for
%           naming both bending and torsion                  (def: 0.05)
%   rho_b : (optional) scalar double, lower bound of the band
%           [rho_b, 1/rho_b] of rs                           (def: 1/2)
%
%   OUTPUT
%   ------
%   label      : char, dominant motion, followed by " coupled with " and
%                the other motions joined by " and " when there are any
%   names_used : cell array of char [1 x M], the motions named, dominant
%                first
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
    tau (1,1) double
    rho (1,1) double
    rs (:,1) double
    names (1,1) struct
    tau_b (1,1) double = 0.05
    rho_b (1,1) double = 0.5
end

if tau < 0.5
    oop = {names.oop_bending, names.torsion};
else
    oop = {names.torsion, names.oop_bending};
end
if min(tau, 1 - tau) < tau_b
    oop = oop(1);
end
nBand = nnz(rs >= rho_b & rs <= 1 / rho_b);
if rho > 1
    names_used = {names.ip_bending};
    if nBand >= 2
        names_used = [names_used, oop];
    end
else
    names_used = oop;
    if nBand >= 2
        names_used = [names_used, {names.ip_bending}];
    end
end
label = names_used{1};
if numel(names_used) > 1
    label = [label ' coupled with ' strjoin(names_used(2:end), ' and ')];
end
end
