load_dataset;
load('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\feature_ranking.mat');
featureIdx40 = rankedFeat(1:40);

nUsers = 10;
nRepeats = 10;   % matched repeat count for a fair head-to-head comparison

configs = struct( ...
    'name', {'Baseline (K=131, hidden=10)', 'Optimized (K=40, hidden=20)'}, ...
    'featureIdx', {1:131, featureIdx40'}, ...
    'hiddenSize', {10, 20} ...
);

compResults = table('Size', [2 5], ...
    'VariableTypes', {'string','double','double','double','double'}, ...
    'VariableNames', {'Config','MeanAcc','MeanFAR','MeanFRR','EER'});

allScoresByConfig = cell(1,2);
allLabelsByConfig = cell(1,2);

for c = 1:2
    accAll = zeros(nUsers, nRepeats);
    farAll = zeros(nUsers, nRepeats);
    frrAll = zeros(nUsers, nRepeats);
    allScores = [];
    allLabels = [];

    for u = 1:nUsers
        for r = 1:nRepeats
            [acc, far, frr, scores, labels] = train_and_evaluate_user( ...
                data, u, 4, configs(c).hiddenSize, configs(c).featureIdx);
            accAll(u,r) = acc;
            farAll(u,r) = far;
            frrAll(u,r) = frr;
            allScores = [allScores, scores];
            allLabels = [allLabels, labels];
        end
    end

    eerC = compute_eer(allScores, allLabels);

    compResults.Config(c) = configs(c).name;
    compResults.MeanAcc(c) = mean(accAll(:))*100;
    compResults.MeanFAR(c) = mean(farAll(:), 'omitnan')*100;
    compResults.MeanFRR(c) = mean(frrAll(:), 'omitnan')*100;
    compResults.EER(c) = eerC*100;

    allScoresByConfig{c} = allScores;
    allLabelsByConfig{c} = allLabels;

    fprintf('%s done: acc=%.2f%% EER=%.2f%%\n', configs(c).name, compResults.MeanAcc(c), compResults.EER(c));
end

compResults

save('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\head_to_head_comparison.mat', ...
    'compResults', 'allScoresByConfig', 'allLabelsByConfig');

figure;
bar(categorical(compResults.Config), [compResults.MeanAcc, 100-compResults.EER]);
ylabel('%');
legend('Mean Accuracy', '100 - EER');
title(sprintf('Baseline vs Optimized: direct head-to-head (n=%d repeats/user)', nRepeats));
grid on;
saveas(gcf, 'D:\Assingments\03) Refferals Coursework (AIML)\02) Project\report\graphs\head_to_head_01.png');
fprintf('Saved figure: head_to_head_01.png\n');
