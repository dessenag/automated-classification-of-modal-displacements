function paths = setup_paths(caseName)
% SETUP_PATHS  Add the shared functions to the path and return the folders of a case.
%
%   paths = setup_paths(caseName)
%
%   Adds Utilities and Utilities/external to the MATLAB path, together
%   with the src folder of the case ('Plate', 'XB2' or 'Sheraton'). It
%   creates Utilities/external and the data/raw, Figures and results
%   folders of the case when they are missing, and, for the XB2 case, the
%   XB-2 data folder. The main.m script of each case calls it.
%
%   Environment variables:
%     XB2_DATA_DIR  folder of the XB-2 data files (default XB2/data/raw)
%     ANSYS_EXE     Ansys Mechanical APDL executable (needed only to re-run
%                   the plate model)
%
%   INPUT
%   -----
%   caseName : string or char scalar, one of "Plate", "XB2" or "Sheraton"
%
%   OUTPUT
%   ------
%   paths : structure of folder paths (root, xb2_data and external are
%           char, the other fields are strings), fields:
%       .root      - repository root folder
%       .case      - folder of the case
%       .data      - <case>/data
%       .raw       - <case>/data/raw
%       .xb2_data  - XB-2 data folder (XB2_DATA_DIR or XB2/data/raw)
%       .external  - Utilities/external
%       .figures   - <case>/Figures
%       .results   - <case>/results
%       .ansys_exe - value of ANSYS_EXE ("" if not set)
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
    caseName (1,1) string {mustBeMember(caseName, ["Plate", "XB2", "Sheraton"])}
end

root = fileparts(mfilename('fullpath'));
addpath(fullfile(root, 'Utilities'));
ext = fullfile(root, 'Utilities', 'external');
if ~isfolder(ext)
    mkdir(ext);
end
addpath(ext);

caseDir = fullfile(root, caseName);
addpath(fullfile(caseDir, 'src'));

xb2Data = getenv('XB2_DATA_DIR');
if isempty(xb2Data)
    xb2Data = fullfile(root, 'XB2', 'data', 'raw');
end

paths = struct( ...
    'root', root, ...
    'case', caseDir, ...
    'data', fullfile(caseDir, 'data'), ...
    'raw', fullfile(caseDir, 'data', 'raw'), ...
    'xb2_data', xb2Data, ...
    'external', ext, ...
    'figures', fullfile(caseDir, 'Figures'), ...
    'results', fullfile(caseDir, 'results'), ...
    'ansys_exe', string(getenv('ANSYS_EXE')));

for f = ["raw", "figures", "results"]
    if ~isfolder(paths.(f))
        mkdir(paths.(f));
    end
end
if caseName == "XB2" && ~isfolder(paths.xb2_data)
    mkdir(paths.xb2_data);
end
end
