function [frf, freqs] = h1_frf(input_signal_array, output_signal_array, fs, window, segment_length, overlap, method)
% H1_FRF  MIMO, SIMO or SISO H1 frequency response function estimate.
%
%   [frf, freqs] = h1_frf(input_signal_array, output_signal_array, fs)
%   [frf, freqs] = h1_frf(input_signal_array, output_signal_array, fs, window)
%   [frf, freqs] = h1_frf(input_signal_array, output_signal_array, fs, ...
%                         window, segment_length)
%   [frf, freqs] = h1_frf(input_signal_array, output_signal_array, fs, ...
%                         window, segment_length, overlap)
%   [frf, freqs] = h1_frf(input_signal_array, output_signal_array, fs, ...
%                         window, segment_length, overlap, method)
%
%   Estimates the H1 frequency response function between every input and
%   every output channel from segment-averaged auto and cross spectra,
%   H1 = Sxy / Sxx, with the cross spectrum taken as E[conj(X)*Y]. Three
%   methods are available: a vectorised block approach on the short-time
%   Fourier transform (default), which solves the block least-squares
%   problem Sxy / Sxx for MIMO data; a per-channel STFT approach, used as
%   fallback (with a warning) when the vectorised one fails; and a
%   per-channel Welch approach (pwelch and cpsd) that treats each
%   input-output pair as SISO. The 'stft' method uses spectrogram when its
%   first stft call fails. A small term eps is added to the auto spectrum to
%   avoid division by zero. Signals may be given either way round: an
%   array with fewer rows than columns is transposed to N x n_channel.
%
%   INPUT
%   -----
%   input_signal_array  : [n_input x N] or [N x n_input] input signals
%   output_signal_array : [n_output x N] or [N x n_output] output signals
%   fs                  : sampling frequency, Hz
%   window              : (optional) window type, 'hann' (or 'hanning'),
%                         'hamming', 'blackman', 'rect' or 'bartlett'
%                                                           (def: 'hann')
%   segment_length      : (optional) window and segment length, also the
%                         FFT length, samples                 (def: 256)
%   overlap             : (optional) segment overlap, samples
%                                         (def: floor(segment_length/2))
%   method              : (optional) 'vectorised', 'stft' or 'welch'
%                                                     (def: 'vectorised')
%
%   OUTPUT
%   ------
%   frf   : [n_output x n_input x n_freq] complex H1 FRF, output units per
%           input unit
%   freqs : [n_freq x 1] one-sided frequency vector, Hz
%
%   DEPENDENCIES: Signal Processing Toolbox (stft, spectrogram, pwelch,
%                 cpsd, hann, hamming, blackman, rectwin, bartlett)
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

% --- Parse inputs and set defaults ---
if nargin < 4 || isempty(window),       window = 'hann';         end
if nargin < 5 || isempty(segment_length), segment_length = 256;  end
if nargin < 6 || isempty(overlap),      overlap = floor(segment_length/2); end
if nargin < 7 || isempty(method),       method = 'vectorised';   end

% --- Handle signal dimensions (always use N x n_channel) ---
[Nin, Din] = size(input_signal_array);
[Nout, Dout] = size(output_signal_array);

if Nin < Din,  input_signal_array  = input_signal_array.';  end
if Nout < Dout, output_signal_array = output_signal_array.'; end

[N, n_input] = size(input_signal_array);
[~, n_output] = size(output_signal_array);

win_vec = window_function(window, segment_length);

switch lower(method)
    case 'vectorised'
        try
            [S_in, f_stft, ~] = stft(input_signal_array, fs, ...
                'Window', win_vec, 'OverlapLength', overlap, ...
                'FFTLength', segment_length, 'FrequencyRange','onesided');
            [S_out, ~, ~] = stft(output_signal_array, fs, ...
                'Window', win_vec, 'OverlapLength', overlap, ...
                'FFTLength', segment_length, 'FrequencyRange','onesided');
            % S_in: (n_freq x n_win x n_input), S_out: (n_freq x n_win x n_output)
            n_freq = size(S_in,1); n_win = size(S_in,2);
            % Compute cross and auto spectra (vectorised)
            Sxy = zeros(n_freq, n_output, n_input);
            Sxx = zeros(n_freq, n_input, n_input);
            for f = 1:n_freq
                X = squeeze(S_in(f,:,:));    % (n_win, n_input) or (n_win,) if n_input==1
                if isvector(X), X = reshape(X, [], n_input); end
                Y = squeeze(S_out(f,:,:));   % (n_win, n_output) or (n_win,) if n_output==1
                if isvector(Y), Y = reshape(Y, [], n_output); end
                % H1 cross-spectrum E[conj(X)*Y]: (Y')*X gives E[conj(Y)*X], so its
                % conjugate is taken. Without it, the FRF would be the conjugate of
                % the true one and the impulse response derived from it would be
                % reversed in time.
                Sxy(f,:,:) = conj((Y') * X) / n_win;  % (n_output, n_input)
                Sxx(f,:,:) = (X') * X / n_win;  % (n_input, n_input)
            end
            % Solve block least squares
            frf = zeros(n_output, n_input, n_freq);
            for f = 1:n_freq
                Sxx_f = squeeze(Sxx(f,:,:));
                Sxy_f = squeeze(Sxy(f,:,:));
                if n_input == 1
                    % SISO/SIMO
                    frf(:,1,f) = Sxy_f ./ (Sxx_f + eps);
                else
                    % General MIMO
                    frf(:,:,f) = Sxy_f / (Sxx_f + eps*eye(n_input));
                end
            end
            freqs = f_stft(:);
            return; % Success, do not fall back

        catch ME
            warning('Vectorised STFT failed (%s), falling back to STFT-per-channel.', ME.message);
            % Explicit fallback call
            [frf, freqs] = h1_frf(input_signal_array, output_signal_array, fs, window, segment_length, overlap, 'stft');
            return
        end

    case 'stft'
        % Per-channel (non-vectorised) STFT/spectrogram approach
        use_spectrogram = false;
        try
            [~, f, ~, ~] = stft(input_signal_array(:,1), fs, ...
                'Window', win_vec, 'OverlapLength', overlap, ...
                'FFTLength', segment_length, 'FrequencyRange','onesided');
        catch
            use_spectrogram = true;
            [~, f, ~] = spectrogram(input_signal_array(:,1), win_vec, overlap, segment_length, fs, 'yaxis');
        end
        n_freq = length(f);
        frf = zeros(n_output, n_input, n_freq);
        for i_in = 1:n_input
            if use_spectrogram
                [S_in, ~, ~] = spectrogram(input_signal_array(:,i_in), win_vec, overlap, segment_length, fs, 'yaxis');
            else
                [~, ~, ~, S_in] = stft(input_signal_array(:,i_in), fs, 'Window', win_vec, ...
                    'OverlapLength', overlap, 'FFTLength', segment_length, 'FrequencyRange','onesided');
            end
            Sxx = mean(S_in .* conj(S_in), 2); % auto-spectrum
            for i_out = 1:n_output
                if use_spectrogram
                    [S_out, ~, ~] = spectrogram(output_signal_array(:,i_out), win_vec, overlap, segment_length, fs, 'yaxis');
                else
                    [~, ~, ~, S_out] = stft(output_signal_array(:,i_out), fs, 'Window', win_vec, ...
                        'OverlapLength', overlap, 'FFTLength', segment_length, 'FrequencyRange','onesided');
                end
                % H1 cross-spectrum E[conj(X)*Y], as in the 'vectorised' case above.
                Sxy = mean(conj(S_in) .* S_out, 2); % cross-spectrum
                frf(i_out, i_in, :) = Sxy ./ (Sxx + eps);
            end
        end
        freqs = f(:);
        return

    case 'welch'
        % Per-channel Welch/cpsd approach
        [~, f] = pwelch(input_signal_array(:,1), win_vec, overlap, segment_length, fs, 'onesided');
        n_freq = length(f);
        frf = zeros(n_output, n_input, n_freq);
        for i_in = 1:n_input
            [Gxx, ~] = pwelch(input_signal_array(:,i_in), win_vec, overlap, segment_length, fs, 'onesided');
            for i_out = 1:n_output
                [Gxy, ~] = cpsd(input_signal_array(:,i_in), output_signal_array(:,i_out), win_vec, overlap, segment_length, fs, 'onesided');
                frf(i_out, i_in, :) = Gxy ./ (Gxx + eps);
            end
        end
        freqs = f(:);
        return

    otherwise
        error('Unknown FRF computation method: %s', method);
end

end

function w = window_function(name, n)
    switch lower(name)
        case {'hann', 'hanning'}
            w = hann(n, 'periodic');
        case 'hamming'
            w = hamming(n, 'periodic');
        case 'blackman'
            w = blackman(n, 'periodic');
        case 'rect'
            w = rectwin(n);
        case 'bartlett'
            w = bartlett(n);
        otherwise
            error('Unknown window type: %s', name);
    end
end
