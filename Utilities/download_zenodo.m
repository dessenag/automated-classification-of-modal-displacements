function filePath = download_zenodo(key, fileName, destDir)
% DOWNLOAD_ZENODO  Download one file of a Zenodo record, unless it is already present.
%
%   filePath = download_zenodo(key, fileName, destDir)
%
%   A file already in destDir with the expected MD5 is used as it is.
%   Otherwise the file is downloaded from
%   https://zenodo.org/api/records/<id>/files/<name>/content (timeout of
%   120 s) and its MD5 is checked; a file with the wrong MD5 is deleted.
%   While a record or a checksum is still a placeholder (a value starting
%   with "["), the MD5 check is skipped and, for a placeholder record, the
%   function stops and asks for the file to be placed in destDir (or for
%   XB2_DATA_DIR to point to its folder). On failure the function stops and
%   says where to put a manually downloaded copy. The destination folder is
%   created if it does not exist. A fileName not listed for the record
%   raises an error.
%
%   INPUT
%   -----
%   key      : char, record key of zenodo_records ('xb2', 'ilf' or
%              'sheraton')
%   fileName : char, file name in the record
%   destDir  : char, destination folder
%
%   OUTPUT
%   ------
%   filePath : char, full path of the file in destDir; the file is written
%              there when it is downloaded
%
%   DEPENDENCIES: zenodo_records, file_md5 (this repository); websave and
%                 weboptions (MATLAB)
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
%     [3] G. Dessena, "Data supporting: NExT-LF: A Novel Operational Modal
%         Analysis Method via Tangential Interpolation," Universidad Carlos
%         III de Madrid, Zenodo, 13 May 2025, doi: 10.5281/zenodo.14975925.
% =========================================================================

rec = zenodo_records(key);
k = find(strcmp({rec.files.name}, fileName), 1);
if isempty(k)
    error('download_zenodo:file', 'File "%s" is not listed for record "%s".', fileName, key);
end
md5 = rec.files(k).md5;
[~, base, ext] = fileparts(fileName);
filePath = fullfile(destDir, [base ext]);
url = sprintf('https://zenodo.org/api/records/%s/files/%s/content', rec.id, fileName);
manual = sprintf(['Download %s manually from %s\n(record %s, expected MD5 %s)\n' ...
    'and place it in %s'], fileName, url, rec.id, md5, destDir);

if isfile(filePath) && (startsWith(md5, '[') || strcmp(file_md5(filePath), md5))
    return
end
if startsWith(rec.id, '[')
    error('download_zenodo:placeholder', ['The Zenodo record "%s" is not published yet.\n' ...
        'Place %s in %s (or point XB2_DATA_DIR to its folder).'], key, fileName, destDir);
end
if ~isfolder(destDir)
    mkdir(destDir);
end
fprintf('Downloading %s from Zenodo record %s ...\n', fileName, rec.id);
try
    websave(filePath, url, weboptions('Timeout', 120));
catch err
    error('download_zenodo:download', '%s\n%s', err.message, manual);
end
if ~startsWith(md5, '[') && ~strcmp(file_md5(filePath), md5)
    delete(filePath);
    error('download_zenodo:md5', 'MD5 mismatch for %s.\n%s', fileName, manual);
end
end

