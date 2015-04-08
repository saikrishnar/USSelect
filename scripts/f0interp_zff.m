function [f0_y,f0_hy,f0] = f0interp_zff(y,fs,frShift)
% Purpose : ZFF interpolation

% Input: (1) y       - signal
%        (2) fs      - sampling frequency
%        (3) frShift - frame shift in samples

% Output: (1) f0_y   - f0 from the signal for every frame
%         (2) f0_hy  - f0 from the hilbert envelope of y
%         (3) f0     - post processed final f0

% Ref: Event-based Instantaneous F0 estimation from speech signals - IEEE TASLP, May, 2009

lens = length(y);
ix = [1:frShift:lens]; % points to interpolate zff f0

% Step 1: Extract f0 from the signal
[~, gci,~,~,vad]=epochExtract(y,fs);

f0 = 1./(diff(gci)/fs);
f0(end+1) = f0(end);
f0 = f0.*vad(gci);
f0_y = interp1(gci,f0,ix,'linear','extrap');

% Step 2: Extract f0 from the hilbert evelope of the signal
yh = sqrt((y.^2 + hilbert(y).^2));
[~, gci,~,~,vad]=epochExtract(yh,fs);

f0 = 1./(diff(gci)/fs);
f0(end+1) = f0(end);
f0 = f0.*vad(gci);
f0_hy = interp1(gci,f0,ix,'linear','extrap'); % f0 from hilbert envelope of y


% Step 3: post processing step to give final f0
f0 = f0_y;
corr_ix = f0_y > 1.5*f0_hy;
f0(corr_ix) = f0_hy(corr_ix);

% plot
% if pflag
% figure
% subplot(211);
% plot(gci/fs,f0); hold on;
% plot(ix/fs,f0_int,'r-'); hold off;
%
% subplot(212);
% plot((1:lens)/fs,y,(1:lens)/fs,max(abs(y))*p,'r');


