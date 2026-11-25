function [nOK, nAll, report] = compare_paper_values(results, P)
% COMPARE_PAPER_VALUES  Compare computed values with the values printed in the article.
%
%   [nOK, nAll, report] = compare_paper_values(results, P)
%
%   Checks each value printed in the article against the value computed by
%   the case-study scripts. It is called at the end of Plate/main.m,
%   Sheraton/main.m and XB2/main.m, with P built by plate_paper_values,
%   sheraton_paper_values and xb2_paper_values.
%   A number matches when abs(computed - printed) <= 0.5 * 10^-decimals
%   (plus a floating-point margin of 1e-12); a label matches when the
%   strings are equal; an upper bound matches when the computed value is
%   below the printed one. A value whose name is not a field of results
%   counts as a mismatch ("not computed").
%
%   INPUT
%   -----
%   results : structure whose fields carry the computed values, named as
%             P.name
%   P       : structure array of N elements with fields name, value,
%             decimals, source and type ('number', 'label' or 'upper'), as
%             returned by the <case>_paper_values functions
%
%   OUTPUT
%   ------
%   nOK    : scalar, number of matched values
%   nAll   : scalar, number of values checked, numel(P)
%   report : string array [(nAll - nOK) x 1], one line per mismatch
%            giving name, source, computed and printed value (name,
%            source and "not computed" for a missing field)
%   Prints "M of N published values matched" and each mismatch to the
%   command window.
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

nAll = numel(P);
ok = false(nAll, 1);
report = strings(nAll, 1);
for i = 1:nAll
    name = P(i).name;
    if ~isfield(results, name)
        report(i) = sprintf('%s (%s): not computed', name, P(i).source);
        continue
    end
    v = results.(name);
    if strcmp(P(i).type, 'label')
        ok(i) = strcmp(string(v), string(P(i).value));
        report(i) = sprintf('%s (%s): computed "%s", printed "%s"', name, P(i).source, string(v), string(P(i).value));
    elseif strcmp(P(i).type, 'upper')
        ok(i) = v < P(i).value;
        report(i) = sprintf('%s (%s): computed %.6g, printed upper bound %g', name, P(i).source, v, P(i).value);
    else
        tol = 0.5 * 10^(-P(i).decimals) + 1e-12;
        ok(i) = abs(v - P(i).value) <= tol;
        report(i) = sprintf('%s (%s): computed %.*f, printed %.*f', name, P(i).source, ...
            P(i).decimals + 2, v, P(i).decimals, P(i).value);
    end
end
nOK = nnz(ok);
fprintf('%d of %d published values matched\n', nOK, nAll);
for i = find(~ok).'
    fprintf('  mismatch: %s\n', report(i));
end
report = report(~ok);
end
