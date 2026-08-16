load_dataset;
load('D:\Assingments\03) Refferals Coursework (AIML)\02) Project\results\feature_ranking.mat');
featureIdx40 = rankedFeat(1:40);

hiddenSizes = [5, 10, 20, 30, 50];
nUsers = 10;
nRepeats = 3;   % exploratory pass, same reasoning as the feature sweep

hpResults = table('Size', [numel(hiddenSizes) 5], ...
    'VariableTypes', {'double','double','double','double','double'}, ...
    'VariableNames', {'HiddenSize','MeanAcc','MeanFAR','MeanFRR','EER'});

for hi = 1:numel(hiddenSizes)
    h = hiddenSizes(hi);
    accAll = zeros(nUsers, nRepeats);
    farAll = zeros(nUsers, nRepeats);
    frrAll = zeros(nUsers, nRepeats);
    allScores = [];
    allLabels = [];

    for u = 1:nUsers
        for r = 1:nRepeats
            [acc, far, frr, scores, labels] = train_and_evaluate_user(data, u, 4, h, featureIdx40);
            accAll(u,r) = acc;
            farAll(u,r) = far;
            frrAll(u,r) = frr;
            allScores = [allScores, scores];
            allLabels = [allLabels, labels];
        end
    end

    eerH = compute_eer(allScores, allLabels);

    hpResults.HiddenSize(hi) = h;
    hpResults.MeanAcc(hi) = mean(accAll(:))*100;
    hpResults.MeanFAR(hi) = mean(farAll(:), 'omitnan')*100;
    hpResults.MeanFRR(hi) = mean(frrAll(:), 'omitnan')*100;
    hpResults.EER(hi) = eerH*100;

    fprintf('hidden=%d done: acc=%.2f%% EER=%.2f%%\n', h, hpResults.MeanAcc(hi), hpResults.EER(hi));
end

hpResults

figure;
plot(hpResults.HiddenSize, hpResults.MeanAcc, 'o-', hpResults.HiddenSize, 100-hpResults.EER, 's-', 'LineWidth', 1.5);
xlabel('Hidden layer size'); ylabel('%');
legend('Mean Accuracy', '100 - EER'); title('Performance vs hidden layer size (K=40 features)');
grid on;