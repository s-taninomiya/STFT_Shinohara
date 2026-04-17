clear; close all; clc;

% wavファイル読み込み
[audioSig,fs] = audioread("sig1.wav"); 

% 各種パラメータを定義
signalLength = length(audioSig); % 信号長
windowLength = 4096; % 窓長
shiftLength = windowLength / 2; % シフト長

% 零詰め
paddedSig = [zeros(windowLength / 2, 1) ; audioSig ; zeros(windowLength - 1, 1)];
numFlames = ceil((windowLength / 2 + signalLength) / shiftLength); % 分割数
S = zeros(windowLength,numFlames);

% 音声信号の分割
for i = 1 : numFlames
    startIndex = 1 + (i-1) * shiftLength;
    endIndex = startIndex + windowLength - 1;
    S(:,i) = paddedSig(startIndex : endIndex);    
end

% STFT
win = hann(windowLength);
winS = win .* S; % 暗黙的拡張で計算
spect = fft(winS);
ampSpect = abs(spect);
powerSpect = 20 * log10(ampSpect); % 利得[db]に変換

% パワースペクトログラムの表示
freqAxis = linspace(0, fs, windowLength); % 縦軸(周波数)取得
timeAxis = linspace(0, signalLength/fs, numFlames); % 横軸(時間)取得
imagesc (timeAxis, freqAxis, powerSpect); % グラフ表示
axis xy; % y軸を上下反転
c = colorbar;
c.Label.String = ("利得[db]");
xlabel("時間[s]");
ylabel("周波数[Hz]")
ylim([0, fs/2]);



