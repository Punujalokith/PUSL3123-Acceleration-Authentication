load_dataset;

nUsers = 10;
meanSim = zeros(nUsers, 1);
simMatrices = cell(nUsers, 1);

for u = 1:nUsers
    uid = sprintf('U%02d', u);
    fday = data.(uid).TimeD_FreqD_FDay;   % 36 x 131
    mday = data.(uid).TimeD_FreqD_MDay;   % 36 x 131

    fdayNorm = fday ./ vecnorm(fday, 2, 2);
    mdayNorm = mday ./ vecnorm(mday, 2, 2);

    simMat = fdayNorm * mdayNorm';        % 36 x 36 cosine similarity
    simMatrices{u} = simMat;
    meanSim(u) = mean(simMat(:));
end

save('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\fday_mday_similarity.mat', ...
    'meanSim', 'simMatrices');

fprintf('Mean FDay-MDay cosine similarity per user:\n');
disp(array2table(meanSim, 'VariableNames', {'MeanCosineSimilarity'}, ...
    'RowNames', strcat('U', string(1:nUsers))));

[~, worstIdx] = min(meanSim);
[~, bestIdx] = max(meanSim);
fprintf('Most consistent (highest similarity): User %d (%.4f)\n', bestIdx, meanSim(bestIdx));
fprintf('Least consistent (lowest similarity): User %d (%.4f)\n', worstIdx, meanSim(worstIdx));

% Summary bar chart
figure('Position', [100 100 700 450]);
bar(1:nUsers, meanSim, 'FaceColor', [0.2 0.4 0.7]);
set(gca, 'XTick', 1:nUsers);
xlabel('User Index');
ylabel('Mean Cosine Similarity (FDay vs MDay)');
title('Mean Within-User FDay-MDay Sample Similarity');
ylim([floor(min(meanSim)*100)/100 - 0.005, 1]);
grid on;
saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\fday_mday_similarity_summary_01.png');
fprintf('Saved figure: fday_mday_similarity_summary_01.png\n');

% Example heatmaps: best and worst user
caseNames = ["best", "worst"];
caseUsers = [bestIdx, worstIdx];
for ci = 1:2
    caseName = caseNames(ci);
    u = caseUsers(ci);
    figure('Position', [100 100 550 480]);
    imagesc(simMatrices{u});
    colormap(jet);
    colorbar;
    axis square;
    xlabel('MDay Sample Index');
    ylabel('FDay Sample Index');
    title(sprintf('User %d: FDay-MDay Cosine Similarity (%s case)', u, caseName));
    outFile = sprintf('D:\\Assingments\\03) Refferals Coursework (AIML)\\02) Project\\report\\graphs\\fday_mday_similarity_%s_01.png', caseName);
    saveas(gcf, outFile);
    fprintf('Saved figure: fday_mday_similarity_%s_01.png\n', caseName);
end
