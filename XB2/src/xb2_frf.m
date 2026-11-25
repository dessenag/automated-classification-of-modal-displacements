function [H, f, opts] = xb2_frf(x, fs)
% XB2_FRF  H1 frequency response functions of the XB-2 wing channels.
%
%   [H, f, opts] = xb2_frf(x, fs)
%
%   Estimates the H1 frequency response functions of the 11 wing channels
%   of the XB-2 record against the clamp input channel, with h1_frf and its
%   default vectorised method. The estimator uses a Hann window of 2048
%   samples with 50% overlap (1024 samples); the window length is also the
%   FFT length. It is called by main.m of the XB-2 case.
%
%   INPUT
%   -----
%   x  : [N x 12] acceleration record, column 1 clamp input, columns 2 to
%        12 wing outputs
%   fs : sampling frequency, Hz
%
%   OUTPUT
%   ------
%   H    : [11 x 1 x Nf] complex H1 estimates, output acceleration over
%          input acceleration
%   f    : [Nf x 1] one-sided frequency lines, Hz
%   opts : structure of the estimator settings, fields:
%       .window          - window type                         ('hann')
%       .segment_length  - segment and FFT length, samples        (2048)
%       .overlap         - segment overlap, samples               (1024)
%
%   DEPENDENCIES: h1_frf (Utilities); Signal Processing Toolbox
%                 (through h1_frf)
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

opts = struct('window', 'hann', 'segment_length', 2048, 'overlap', 1024);
[H, f] = h1_frf(x(:, 1), x(:, 2:12), fs, opts.window, opts.segment_length, opts.overlap);
f = f(:);
end
