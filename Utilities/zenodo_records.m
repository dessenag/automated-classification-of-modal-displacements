function rec = zenodo_records(key)
% ZENODO_RECORDS  Zenodo records used by the code: record id, files and MD5 checksums.
%
%   rec = zenodo_records(key)
%
%   Returns the Zenodo record id, the file names and their MD5 checksums
%   for one of the three records read by the code. Version-specific record
%   ids are used, so that a new version of a record does not change the
%   files read by the code. It is called by download_zenodo and by the main
%   script of the Sheraton case.
%
%   INPUT
%   -----
%   key : character vector, record key, one of 'xb2' (XB-2 dataset [2]),
%         'ilf' (iLF tutorial code [3]) or 'sheraton' (Sheraton Universal
%         Hotel data [4]); any other key raises the error
%         'zenodo_records:key'
%
%   OUTPUT
%   ------
%   rec : structure, fields:
%       .id      - Zenodo record id, character vector
%       .files   - structure array [1 x M], fields .name (file name or
%                  path in the record) and .md5 (MD5 checksum, 32 hex
%                  characters)
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
%     [3] G. Dessena, "A tutorial for the improved Loewner Framework for
%         modal analysis," Universidad Carlos III de Madrid, Zenodo,
%         16 Nov. 2024, doi: 10.5281/zenodo.13863292.
%     [4] G. Dessena, "Data supporting: NExT-LF: A Novel Operational Modal
%         Analysis Method via Tangential Interpolation," Universidad Carlos
%         III de Madrid, Zenodo, 13 May 2025, doi: 10.5281/zenodo.14975925.
% =========================================================================

switch key
    case 'xb2'
        % A dataset for partial in-plane acceleration of the XB-2 wing
        % (doi:10.5281/zenodo.24536230), CC BY 4.0
        rec.id = '[ZENODO RECORD]';
        rec.files = struct('name', {'XB2_timeseries_256Hz.mat', 'XB2_FRF_H1.mat'}, ...
            'md5', {'8ef9c4c5f59e7fd8dae193874e2b56b5', '0a6dca37a0f78752fd3ac103adb003ae'});
    case 'ilf'
        % A tutorial for the improved Loewner Framework for modal analysis
        % (doi:10.5281/zenodo.13863292, version post-pub), GPL-3.0-or-later
        rec.id = '14173432';
        rec.files = struct('name', {'dessenag/iLF-MIMO-post-pub.zip'}, ...
            'md5', {'98c20de571a227f908782e44315667ef'});
    case 'sheraton'
        % Data supporting: NExT-LF: A Novel Operational Modal Analysis Method via
        % Tangential Interpolation (doi:10.5281/zenodo.14975925), GPL-3.0-or-later
        rec.id = '15397656';
        rec.files = struct('name', {'SheratonMode1.fig', 'SheratonMode2.fig', 'SheratonMode3.fig', ...
            'SheratonMode4.fig', 'SheratonMode5.fig'}, ...
            'md5', {'3174aed731792b207d754e651f345b78', 'd04ec38ae7d812336940d193b864ef54', ...
            'd50040a1e5e31cf4dee8e157c9f4de98', '6c0fe1d2904b856991905eb0810f5d63', ...
            '78484a33f400ae2a8d5081ec4e6f1b2c'});
    otherwise
        error('zenodo_records:key', 'Unknown record key "%s".', key);
end
end
