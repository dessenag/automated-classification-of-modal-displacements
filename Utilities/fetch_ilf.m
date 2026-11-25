function fetch_ilf(extDir)
% FETCH_ILF  Download the iLF tutorial from Zenodo and add its functions to the path.
%
%   fetch_ilf(extDir)
%
%   Downloads dessenag/iLF-MIMO-post-pub.zip from the iLF tutorial record
%   [2] (doi:10.5281/zenodo.13863292, version 14173432, GPL-3.0-or-later)
%   into extDir, unzips it and adds the folder holding the tutorial
%   functions iLF and iLF_id to the path. Nothing is downloaded if the
%   tutorial is already unzipped there, that is, if the file of iLF_id is
%   found in extDir or any of its subfolders. An error with identifier
%   fetch_ilf:missing is raised if that file is still not found after
%   unzipping.
%
%   INPUT
%   -----
%   extDir : char or string, folder where the tutorial is downloaded and
%            unzipped
%
%   OUTPUT
%   ------
%   (none). The zip file and its unzipped contents are written to extDir,
%   and the folder holding iLF_id is added to the MATLAB path.
%
%   DEPENDENCIES: download_zenodo (this repository); iLF tutorial [2],
%                 downloaded by this function
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
%     [2] G. Dessena, "A tutorial for the improved Loewner Framework for
%         modal analysis," Universidad Carlos III de Madrid, Zenodo,
%         16 Nov. 2024, doi: 10.5281/zenodo.13863292.
% =========================================================================

found = dir(fullfile(extDir, '**', 'iLF_id.m'));
if isempty(found)
    zipFile = download_zenodo('ilf', 'dessenag/iLF-MIMO-post-pub.zip', extDir);
    unzip(zipFile, extDir);
    found = dir(fullfile(extDir, '**', 'iLF_id.m'));
end
if isempty(found)
    error('fetch_ilf:missing', 'iLF_id.m was not found in %s.', extDir);
end
addpath(found(1).folder);
end
