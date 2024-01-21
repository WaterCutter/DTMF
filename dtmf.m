clear all;close all;

% 获取当前目录下的所有文件
files = dir('./dat');
filenum = 0;
fileList = string([]);
for i = 1:length(files)
    if files(i).isdir
        % fprintf('文件夹：%s\n', files(i).name);
    else
        fileList(filenum+1) = files(i).name;
        filenum = filenum+1;
    end
end

figure;
for i=1:12
    subplot(4,3,i)
    [y, Fs] = audioread('./dat/'+fileList(i));
    % 计算信号的频谱
    N = length(y);
    Y = fft(y);
    f = (0:N-1)*(Fs/N);
    Y = Y(1:N/2);
    
    % 绘制频谱图
    plot(f(1:length(f)/2), abs(Y));
    xlabel('频率 (Hz)');
    ylabel('幅度');
    
    % 找到频谱中的峰值
    [peaks, locs] = findpeaks(abs(Y));
    
    % 找到幅值最大的两个峰值
    [~, sortedIdx] = sort(peaks, 'descend');
    maxPeaks = peaks(sortedIdx(1:2));
    maxLocs = locs(sortedIdx(1:2));
    
    % 在图上标注频谱幅值最大的两个频点
    text(f(maxLocs(1)), maxPeaks(1), sprintf('%.2f Hz', f(maxLocs(1))), 'VerticalAlignment', 'bottom');
    text(f(maxLocs(2)), maxPeaks(2), sprintf('%.2f Hz', f(maxLocs(2))), 'VerticalAlignment', 'bottom');
    
    % 计算频谱显示区间
    maxFreq = max(f(maxLocs));
    minFreq = min(f(maxLocs));
    deltaFreq = maxFreq - minFreq;
    padding = deltaFreq * 0.8; % 添加空白边距
    xlim([minFreq - padding, maxFreq + padding]);

    maxAMP = max(maxPeaks);
    padding = maxAMP * 0.2; % 添加20%的空白边距
    ylim([0, maxAMP + padding]);


    title(fileList(i));
end
%%
figure;
for i=1:12
    subplot(4,3,i)
    [y, Fs] = audioread('./dat/'+fileList(i));
    % 计算信号的频谱
    plot(y)
    title(fileList(i));
end
