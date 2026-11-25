function h = file_md5(filePath)
% FILE_MD5  MD5 checksum of a file, as a lower-case hexadecimal string.
%
%   h = file_md5(filePath)
%
%   Reads the whole file as bytes and returns its MD5 digest. It is used
%   by download_zenodo.m to check a downloaded data file against the MD5
%   checksum listed in the Zenodo record.
%
%   INPUT
%   -----
%   filePath : character vector or string, path of the file to hash
%
%   OUTPUT
%   ------
%   h : character vector [1 x 32], MD5 digest in lower-case hexadecimal
%
%   DEPENDENCIES: none of this repository; uses the Java class
%                 java.security.MessageDigest, so MATLAB must run with Java
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

fid = fopen(filePath, 'r');
bytes = fread(fid, Inf, '*uint8');
fclose(fid);
md = java.security.MessageDigest.getInstance('MD5');
md.update(bytes);
h = lower(reshape(dec2hex(typecast(md.digest(), 'uint8'), 2).', 1, []));
end
